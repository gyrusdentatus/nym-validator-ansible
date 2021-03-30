#!/bin/bash

# This is pretty hideous. If you just upload the compiled nymd binary to a server after compiling it locally,
# nymd will barf on run because it can't find livwasmvm.so (a shared library needed for wasm).
#
# So we use ldd here to find out which shared library file we just compiled, and copy it to /tmp/ so that
# we can upload it. 
#
# I would rather do this in Ansible than in a shell script, but Ansible barfs on the !cosm!wasm part of the
# shared library path. Bit of a struggle. 
WASMVM_SO=$(ldd /tmp/nymd | grep libwasmvm.so | awk '{ print $3 }')
cp "$WASMVM_SO" /tmp/libwasmvm.so
chmod 600 /tmp/libwasmvm.so