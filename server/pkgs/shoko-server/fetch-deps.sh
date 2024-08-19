#!/usr/bin/env bash
nix-build -A server.fetch-deps
./result
