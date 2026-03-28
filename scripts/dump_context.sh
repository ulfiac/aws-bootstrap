#!/bin/bash

echo -e "Dumping context...\n"

echo "::group::env context (filtered):"
echo "$CONTEXT_ENV" | grep -v -i "aws" # filter out any AWS creds from the env context
echo "::endgroup::"

echo "::group::github context:"
echo "$CONTEXT_GITHUB"
echo "::endgroup::"

echo "::group::inputs context:"
echo "$CONTEXT_INPUTS"
echo "::endgroup::"

echo "::group::job context:"
echo "$CONTEXT_JOB"
echo "::endgroup::"

echo "::group::matrix context:"
echo "$CONTEXT_MATRIX"
echo "::endgroup::"

echo "::group::needs context:"
echo "$CONTEXT_NEEDS"
echo "::endgroup::"

echo "::group::runner context:"
echo "$CONTEXT_RUNNER"
echo "::endgroup::"

echo "::group::secrets context:"
echo "<redacted> because reasons"
echo "::endgroup::"

echo "::group::steps context:"
echo "$CONTEXT_STEPS"
echo "::endgroup::"

echo "::group::strategy context:"
echo "$CONTEXT_STRATEGY"
echo "::endgroup::"

echo "::group::vars context:"
echo "$CONTEXT_VARS"
echo "::endgroup::"

# if the ANNOTATE env var is set to "true", then annotate the context details in the GitHub Actions log
if [[ "$ANNOTATE" = "true" ]]; then
  echo -e "\n::notice::Context details.\n"
fi
