#!/usr/bin/env python3
# ==============================================================================
# nom-determinate-workaround.py
# 
# A middleware utility to bridge the gap between Determinate Systems Nix
# (and Lix) structured logging and nix-output-monitor (nom).
#
# It intercepts the non-standard "Atomic Result" events (Type 110) produced by
# Determinate Nix and synthesizes standard "Start/Stop" activity events that
# nom understands. This restores the progress bar and "Green Ticks" for cached
# builds without crashing existing tools.
#
# LICENSE: AGPLv3
# AUTHOR:  Gemini 3 pro preview
# DATE:    2025-01-12
#
# USAGE:
#   Nushell:
#     nix build ... --log-format internal-json -v out+err>| ^python3 nom-patch.py | nom --json
# ==============================================================================

import sys
import json
import hashlib

def main():
    # Iterate over stdin line-by-line using the default iterator.
    # We consciously avoid readlines() to ensure we process the stream as it arrives.
    for line in sys.stdin:
        
        # 1. Pass-Through Non-JSON Lines
        # Standard Nix text output (git warnings, evaluation errors) does not start 
        # with @nix. We pass these through immediately to keep the user informed.
        if not line.startswith("@nix "):
            sys.stdout.write(line)
            sys.stdout.flush()
            continue

        try:
            # 2. Parse Valid Nix JSON
            # nom expects lines to start with "@nix ", but python's json parser 
            # does not. We slice the prefix off [5:] before parsing.
            data = json.loads(line[5:])

            # 3. Intercept Determinate Systems "Type 110"
            # Type 110 is an "Atomic Result" (cached hit or immediate failure) 
            # introduced by DetSys. upstream C++ Nix uses Type 100/104/105.
            # nom crashes on 110 because it maps IDs to strict Haskell types.
            if data.get("type") == 110:
                payload = data.get("payload", {})

                # 4. Normalize Path Schema
                # The schema for 'path' is inconsistent in Type 110 events:
                # - Success/Cached: 'path' is a Dict containing 'drvPath'
                # - Failure/NoSub : 'path' is a String (the store path itself)
                path_entry = payload.get("path")
                if isinstance(path_entry, dict):
                    drv_path = path_entry.get("drvPath", "unknown-drv")
                else:
                    drv_path = str(path_entry)
                
                # 5. ID Synthesis
                # nom requires 'id' to be an Integer. DetSys sends 'id: 0' for atomic events.
                # To make these appear as distinct rows in the UI, we hash the derivation
                # path to generate a stable, pseudo-unique integer ID.
                # We use MD5 for speed; security is irrelevant here.
                # Modulo 2^60 ensures it fits within standard integer types.
                name = drv_path.split("/")[-1].replace(".drv", "")
                path_hash = hashlib.md5(drv_path.encode()).hexdigest()
                fake_id = abs(int(path_hash, 16)) % (2**60)

                # 6. Event Synthesis Strategy
                if payload.get("status") == "AlreadyValid" or payload.get("success"):
                    # SCENARIO A: Meaningful Cache Hit
                    # To get a "Green Tick" in nom, we must simulate a duration.
                    # We emit a "Start Activity" (104) followed immediately by a 
                    # "Stop Activity" (105).
                    
                    # Synthesize Start
                    start_json = json.dumps({
                        "action": "start", 
                        "id": fake_id, 
                        "level": 0, 
                        "type": 104,
                        "text": f"cached: {name}", 
                        "parent": 0
                    })
                    sys.stdout.write(f"@nix {start_json}\n")

                    # Synthesize Stop (Success)
                    stop_json = json.dumps({
                        "action": "stop", 
                        "id": fake_id, 
                        "type": 105
                    })
                    sys.stdout.write(f"@nix {stop_json}\n")
                
                else:
                    # SCENARIO B: Cache Miss / No Substituter
                    # If we emit a Start/Stop task for a cache miss, nom might flag it
                    # as a build failure (Red X) if the status isn't "success".
                    # Instead, we downgrade this to a simple Log Message (msg).
                    # This keeps the UI clean while still informing the user.
                    msg_json = json.dumps({
                        "action": "msg", 
                        "level": 0, 
                        "msg": f"cache miss: {name}"
                    })
                    sys.stdout.write(f"@nix {msg_json}\n")

            else:
                # 7. Pass Standard Events Untouched
                # Types 100-105 are standard Nix protocol. Let nom handle them.
                sys.stdout.write(line)

        except Exception as e:
            # 8. Defensiveness / Error reporting
            # If our patch logic fails (e.g. schema changes in future Nix versions),
            # we MUST NOT swallow the line silently. 
            
            # Step A: Shout about the error in the UI (Red Text, Level 3)
            err_json = json.dumps({
                "action": "msg", 
                "level": 3,
                "msg": f"NOM-COMPAT ERROR: {str(e)}"
            })
            sys.stdout.write(f"@nix {err_json}\n")
            
            # Step B: Pass the raw line through. 
            # nom might crash on it, but at least the user sees the original data.
            sys.stdout.write(line)

        # 9. Force Flush
        # Critical: Python buffers stdout by default when piping.
        # Without this, nom will hang and update in chunky bursts.
        sys.stdout.flush()

if __name__ == "__main__":
    main()
