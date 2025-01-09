#!/usr/bin/env bash

sudo -v
sudo nixos-rebuild switch --flake .# $@ --log-format internal-json -v |& nom --json
