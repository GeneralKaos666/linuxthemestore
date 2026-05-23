#!/bin/sh

set -eu

export MESON_BUILD_ROOT="$1"
export MESON_SOURCE_ROOT="$2"
export CARGO_TARGET_DIR="$MESON_BUILD_ROOT"/target
export CARGO_HOME="$CARGO_TARGET_DIR"/cargo-home
export OUTPUT="$3"
export BUILDTYPE="$4"
export APP_BIN="$5"
export PKG_CONFIG_ALLOW_CROSS=1

cargo_target="${CARGO_TARGET_NAME:-}"
target_path="$CARGO_TARGET_DIR"
if [ -n "$cargo_target" ]; then
    target_path="$target_path/$cargo_target"
fi

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
    set -- cargo build --manifest-path "$MESON_SOURCE_ROOT"/Cargo.toml --locked
    if [ -n "$cargo_target" ]; then
        set -- "$@" --target "$cargo_target"
    fi
    if [ -n "$cargo_jobs" ]; then
        set -- "$@" --jobs "$cargo_jobs"
    fi
    set -- "$@" --release
    "$@"
    cp "$target_path"/release/"$APP_BIN" "$OUTPUT"
else
    echo "DEBUG MODE"
    set -- cargo build --manifest-path "$MESON_SOURCE_ROOT"/Cargo.toml --locked
    if [ -n "$cargo_target" ]; then
        set -- "$@" --target "$cargo_target"
    fi
    if [ -n "$cargo_jobs" ]; then
        set -- "$@" --jobs "$cargo_jobs"
    fi
    "$@"
    cp "$target_path"/debug/"$APP_BIN" "$OUTPUT"
fi
