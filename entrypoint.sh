#!/bin/bash -l
set -uxo pipefail

LYCHEE_OUT=${LYCHEE_OUT:="lychee/out.md"}
LYCHEE_TMP="/tmp/lychee/out.md"
GITHUB_WORKFLOW_URL=https://github.com/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID 


# Create temp dir
mkdir -p "$(dirname $LYCHEE_TMP)"

# Execute lychee
lychee "$@" --output "$LYCHEE_TMP"
exit_code=$?

# If link errors were found, create a report in the designated directory
if [ $exit_code -ne 0 ]; then
    mkdir -p "$(dirname $LYCHEE_OUT)"
    echo 'Errors were reported while checking the availability of links.' > $LYCHEE_OUT
    echo >> $LYCHEE_OUT
    cat "$LYCHEE_TMP" >> $LYCHEE_OUT
    echo >> $LYCHEE_OUT
    echo "[Full Github Action output](${GITHUB_WORKFLOW_URL})" >> $LYCHEE_OUT
fi

# Output to console
cat "$LYCHEE_TMP"

# Pass lychee exit code to next step
echo ::set-output name=exit_code::$exit_code

