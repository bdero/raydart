#!/bin/bash
# Build Raylib and its FFI bindings in a (hopefully) idempotent manor.

git submodule update --init --recursive
dart pub get

# Build Raylib FFI bindings
dart run ffigen

# Build raylib

## The DLL produced was completely devoid of symbols...
#pushd deps/raylib
#cmake -GNinja -DBUILD_SHARED_LIBS=ON -DBUILD_EXAMPLES=OFF .
#ninja
#popd

# The default resource file needs to be removed because it's 32bit.
pushd deps/raylib/src
make PLATFORM=PLATFORM_DESKTOP RAYLIB_LIBTYPE=SHARED RAYLIB_RES_FILE=""
popd

cp deps/raylib/src/raylib.{so,dll,dylib} ./
