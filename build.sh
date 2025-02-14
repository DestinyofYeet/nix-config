#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nix-output-monitor

sudo -v
sudo nixos-rebuild $1 --flake .# ${@:2} --log-format internal-json -v |& nom --json
