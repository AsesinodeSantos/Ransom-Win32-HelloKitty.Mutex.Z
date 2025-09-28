#!/bin/bash
# Build all core files for Windows using MinGW cross-compiler
set -e

# Install mingw-w64 if not present
type x86_64-w64-mingw32-g++ >/dev/null 2>&1 || {
  echo "mingw-w64 not found. Installing..."
  sudo apt-get update && sudo apt-get install -y mingw-w64
}

# Build command
echo "Compiling for Windows..."
x86_64-w64-mingw32-g++ \
  Core/main.cpp \
  Core/innocent/Base64.cpp \
  Core/innocent/lock.cpp \
  Core/crc32/crc32.cpp \
  Core/sha256/sha256.cpp \
  -o core_app.exe \
  -lws2_32 -liphlpapi -lshlwapi -lole32 -luuid

echo "Build complete: core_app.exe"
