#!/bin/sh

set -eu

export MESON_BUILD_ROOT="$1"
export MESON_SOURCE_ROOT="$2"
export CARGO_TARGET_DIR="$MESON_BUILD_ROOT"/target
export CARGO_HOME="$CARGO_TARGET_DIR"/cargo-home
export OUTPUT="$3"
export BUILDTYPE="$4"
export APP_BIN="$5"

cargo_jobs="${CARGO_BUILD_JOBS:-}"
if [ -z "$cargo_jobs" ]; then
    case "$(uname -o 2>/dev/null || true)" in
        Android)
            cargo_jobs=1
            ;;
    esac
fi

if [ "$BUILDTYPE" = "release" ]
then
    echo "RELEASE MODE"
    if [ -n "$cargo_jobs" ]; then
        cargo build --manifest-path \
            "$MESON_SOURCE_ROOT"/Cargo.toml --locked --jobs "$cargo_jobs" --release
    else
        cargo build --manifest-path \
            "$MESON_SOURCE_ROOT"/Cargo.toml --locked --release
    fi
    cp "$CARGO_TARGET_DIR"/release/"$APP_BIN" "$OUTPUT"
else
    echo "DEBUG MODE"
    if [ -n "$cargo_jobs" ]; then
        cargo build --manifest-path \
            "$MESON_SOURCE_ROOT"/Cargo.toml --locked --jobs "$cargo_jobs"
    else
        cargo build --manifest-path \
            "$MESON_SOURCE_ROOT"/Cargo.toml --locked
    fi
    cp "$CARGO_TARGET_DIR"/debug/"$APP_BIN" "$OUTPUT"
fi
