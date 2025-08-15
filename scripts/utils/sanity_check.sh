#!/usr/bin/env bash

# ===== CONFIG =====
declare -A REQUIRED_TOOLS=(
  [attr]="attr"
  [ccache]="ccache"
  [clang]="clang"
  [git]="git"
  [golang]="go"
  [libbrotli-dev]="brotli"
  [libgtest-dev]="/usr/include/gtest/gtest.h"
  [liblz4-dev]="lz4"
  [libpcre2-dev]="pcre2grep"
  [libprotobuf-dev]="protobuf"
  [libunwind-dev]="/usr/include/libunwind.h"
  [libusb-1.0-0-dev]="/usr/include/libusb-1.0/libusb.h"
  [libzstd-dev]="zstd"
  [lld]="lld"
  [protobuf-compiler]="protoc"
  [zip]="zip"
  [zipalign]="zipalign"
  [make]="make"
  [cmake]="cmake"
  [npm]="npm"
  [lz4]="lz4"
  [brotli]="brotli"
  [patchelf]="patchelf"
  [pcre2-utils]="pcre2grep"
  [webp]="cwebp"
  [zstd]="zstd"
  [meld]="meld"
)

FILESYSTEMS=(erofs f2fs)
MISSING_PKGS=()

# ===== DETECT DISTRO =====
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO_ID=$ID
else
    DISTRO_ID="unknown"
fi

# ===== PACKAGE CHECK =====
echo "Checking required tools/libraries..."
for pkg in "${!REQUIRED_TOOLS[@]}"; do
    check="${REQUIRED_TOOLS[$pkg]}"

    # Special case: Java check
    if [[ "$pkg" == "openjdk-11-jdk" ]]; then
        if command -v javac &>/dev/null; then
            ver=$(javac -version 2>&1 | awk '{print $2}' | cut -d'.' -f1)
            if [[ "$ver" =~ ^[0-9]+$ && "$ver" -ge 11 ]]; then
                echo "✅ Java ($ver) is available"
            else
                echo "❌ Java version too old (found $ver)"
                MISSING_PKGS+=("openjdk-17-jdk")
            fi
        else
            echo "❌ Java (>=11) missing"
            MISSING_PKGS+=("openjdk-17-jdk")
        fi
        continue
    fi

    if [[ "$pkg" == "libprotobuf-dev" ]]; then
        if command -v pkg-config &>/dev/null && pkg-config --exists protobuf; then
            echo "✅ $pkg (pkg-config)"
        elif [ -f /usr/lib/x86_64-linux-gnu/libprotobuf.a ] || [ -f /usr/lib/libprotobuf.a ]; then
            echo "✅ $pkg (library file found)"
        else
            echo "❌ $pkg missing"
            MISSING_PKGS+=("$pkg")
        fi
        continue
    fi

    if [[ "$check" == /*.h ]]; then
        if [ -f "$check" ]; then
            echo "✅ $pkg (header found)"
        elif command -v pkg-config &>/dev/null && pkg-config --exists "${pkg%%-dev}"; then
            echo "✅ $pkg (pkg-config)"
        else
            echo "❌ $pkg missing"
            MISSING_PKGS+=("$pkg")
        fi
    else
        if command -v "$check" &>/dev/null; then
            echo "✅ $pkg ($check) is available"
        elif [[ "$pkg" == *-dev ]] && command -v pkg-config &>/dev/null && pkg-config --exists "${pkg%%-dev}"; then
            echo "✅ $pkg (pkg-config)"
        else
            echo "❌ $pkg missing"
            MISSING_PKGS+=("$pkg")
        fi
    fi
done

# ===== FILESYSTEM CHECK =====
echo -e "\nChecking filesystem support..."
for fs in "${FILESYSTEMS[@]}"; do
    if grep -qw "$fs" /proc/filesystems; then
        echo "✅ $fs supported (built-in)"
    elif lsmod | grep -q "^$fs"; then
        echo "✅ $fs supported (module loaded)"
    else
        if [[ "$fs" == "f2fs" ]]; then
            echo "⚠️  fs not found (no built-in, no loaded module, this might not cause problems)"
        else
            echo "❌ $fs not found (no built-in, no loaded module)"
        fi
    fi
done

# ===== GIT SUBMODULE CHECK =====
echo -e "\nChecking Git submodules..."
if [ -d .git ]; then
    if git submodule status 2>/dev/null | grep -q '^-'; then
        echo "❌ Some submodules are missing. Cloning..."
        git submodule update --init --recursive
    else
        echo "✅ All submodules are initialized"
    fi
else
    echo "⚠️ Not a Git repository — skipping submodule check."
fi

# ===== SUGGEST FIX COMMAND =====
if [ ${#MISSING_PKGS[@]} -gt 0 ]; then
    echo -e "\nPossible fix commands:"
    case "$DISTRO_ID" in
        debian|ubuntu|linuxmint|pop)
            echo "sudo apt install -y ${MISSING_PKGS[*]}"
            ;;
        fedora)
            echo "sudo dnf install -y ${MISSING_PKGS[*]}"
            ;;
        centos|rhel|rocky|almalinux)
            echo "sudo yum install -y ${MISSING_PKGS[*]}"
            ;;
        arch)
            echo "sudo pacman -S --needed ${MISSING_PKGS[*]}"
            ;;
        *)
            echo "Unknown distro. Please install manually: ${MISSING_PKGS[*]}"
            ;;
    esac
else
    echo -e "\n✅ No missing packages!"
fi

echo -e "\nDone."
