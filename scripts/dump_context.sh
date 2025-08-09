#!/bin/bash

echo -e "Dumping context...\n"
# echo -e "inputs context:\n${{ toJson(inputs) }}\n"
# echo -e "env context:\n${{ toJson(env) }}\n"
# echo -e "github context:\n${{ toJson(github) }}\n"

echo -e "::group::inputs context:\n${{ toJson(inputs) }}\n"
echo -e "::endgroup::"

echo -e "::group::env context:\n"
echo -e "${{ toJson(env) }}"
echo -e "::endgroup::"

echo -e "::group::github context:\n"
echo -e "${{ toJson(github) }}"
echo -e "::endgroup::"

# github
# env
# vars
# job
# jobs
# steps
# runner
# secrets
# strategy
# matrix
# needs
# inputs
