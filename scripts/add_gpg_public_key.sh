#!/bin/bash

# Required environment variables:
#   GPG_PUBLIC_KEY_BINARY_BASE64 - the binary (not armored) and base64 encoded export of the gpg pulic key 
#   GPG_PUBLIC_KEY_ARMORED       - the armored export of the gpg public key

# constants
EXPECTED_SHA256_BINARY='55576a9b920fa828647f1866c69c8936138f3c97a1f62875ed72126991ba1f7d  ./public_key_binary.gpg'
EXPECTED_SHA256_BINARY_BASE64='c56a7fc499669c37391f61b72c796a60fc5bb01ee88bf5da25547684c1a438a3  ./public_key_binary_base64encoded.gpg'
EXPECTED_SHA256_ARMORED='324a45b8e9456f7506dbe5bf6c3d491e98bced1e2bf9d6992e23d658a2f56e34  ./public_key_armored.asc'

# echo environment var into file(s)
echo $GPG_PUBLIC_KEY_BINARY_BASE64 > ./public_key_binary_base64encoded.gpg
echo $GPG_PUBLIC_KEY_ARMORED > ./public_key_armored.asc

# decode the binary
echo $GPG_PUBLIC_KEY_BINARY_BASE64 | base64 -d > ./public_key_binary.gpg

# calculate sha256 hash of file(s)
calculated_sha256_binary=$(shasum -a 256 ./public_key_binary.gpg)
calculated_sha256_binary_base64=$(shasum -a 256 ./public_key_binary_base64encoded.gpg)
calculated_sha256_armored=$(shasum -a 256 ./public_key_armored.asc)

# output
echo
echo "gpg binary public key:"
echo "expected sha256:    $EXPECTED_SHA256_BINARY"
echo "calculated sha256:  $calculated_sha256_binary"
echo
echo "gpg binary base64 encoded public key:"
echo "expected sha256:    $EXPECTED_SHA256_BINARY_BASE64"
echo "calculated sha256:  $calculated_sha256_binary_base64"
echo
echo "gpg armored public key:"
echo "expected sha256:    $EXPECTED_SHA256_ARMORED"
echo "calculated sha256:  $calculated_sha256_armored"
