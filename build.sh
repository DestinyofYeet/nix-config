#!/usr/bin/env bash

sudo nixos-rebuild switch --flake .# --impure $@ --log-format internal-json -v |& nom --json
