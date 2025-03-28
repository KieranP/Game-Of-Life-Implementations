#!/bin/bash

source ../helpers.sh

compile tsc

echo -n "TypeScript - Bun - "
bun --version | head -n 1
benchmark bun run play.js

echo ""

echo -n "TypeScript - Deno - "
deno --version | head -n 1
benchmark deno run --allow-env play.js

echo ""

echo -n "TypeScript - Node - "
node --version | head -n 1
benchmark node play.js
