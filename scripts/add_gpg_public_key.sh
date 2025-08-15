#!/bin/bash

# Required environment variables:
#   GPG_PUBLIC_KEY_BINARY - the binary (not armored) export of the pgp pulic key

# constants
EXPECTED_SHA256='55576a9b920fa828647f1866c69c8936138f3c97a1f62875ed72126991ba1f7d  ./public_key_binary.gpg'

# get version
shasum --version

# echo environment var into file
echo $GPG_PUBLIC_KEY_BINARY > ./public_key_binary.gpg

# calculate sha256 hash of file
calculated_sha256=shasum -a 256 ./public_key_binary.gpg

# output
echo "expected sha256:    $EXPECTED_SHA256"
echo "calculated sha256:  $calculated_sha256"
