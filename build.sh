#!/bin/bash
###############################################################################
## Build Raylib and its FFI bindings in a (hopefully) idempotent manor.
###############################################################################
set -e

function print_header {
    echo
    echo "###############################################################################"
    echo "##"
    echo "##        $1"
    echo "##"
    echo "###############################################################################"
    echo
}


print_header "Fetching dependencies"

git submodule update --init --recursive
dart pub get


print_header "Generating Raylib FFI bindings"

mkdir -p src/generated
dart run ffigen


print_header "Compiling Raylib DLL"

pushd deps/raylib/src > /dev/null
# The default resource file needs to be removed because it's 32bit.
make PLATFORM=PLATFORM_DESKTOP RAYLIB_LIBTYPE=SHARED RAYLIB_RES_FILE=""
popd > /dev/null

mkdir -p dist
FOUND=""
for FILE in deps/raylib/src/raylib.{so,dll,dylib}
do
    if [[ -f $FILE ]]
    then
        FOUND+=$FILE
        echo
        echo "Copied $FOUND to dist."
        cp $FILE dist/
    fi
done
if [[ -z $FOUND ]]
then
    echo
    echo "Couldn't find shared Raylib binary."
    exit 1
fi


print_header "Compiling Dart executable."

dart compile exe src/main.dart -o dist/raydart.exe
