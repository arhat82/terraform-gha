#!/bin/bash

set -euo pipefail

function plan() {

    local PLAN_OUT_ARG
    if [[ -n "$PLAN_OUT" ]]; then
        PLAN_OUT_ARG="-out=$PLAN_OUT"
    else
        PLAN_OUT_ARG=""
    fi

    # shellcheck disable=SC2086
    debug_log terraform plan -input=false -no-color -detailed-exitcode -lock-timeout=300s $PARALLEL_ARG $PLAN_OUT_ARG '$PLAN_ARGS'  # don't expand PLAN_ARGS

    set +e
    # shellcheck disable=SC2086
    (cd "$INPUT_PATH" && terraform plan -input=false -no-color -detailed-exitcode -lock-timeout=300s $PARALLEL_ARG $PLAN_OUT_ARG $PLAN_ARGS) \
        2>"$STEP_TMP_DIR/terraform_plan.stderr" \
        | $TFMASK \
        | tee /dev/fd/3 "$STEP_TMP_DIR/terraform_plan.stdout" \
        | compact_plan \
            >"$STEP_TMP_DIR/plan.txt"

    # shellcheck disable=SC2034
    PLAN_EXIT=${PIPESTATUS[0]}
    set -e
}
