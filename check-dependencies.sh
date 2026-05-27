#!/bin/bash

# Neovim configuration dependency checker
# Verifies all system-level dependencies required by the nvim config

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[1;36m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BLUE}=== Neovim Configuration Dependency Checker ===${NC}\n"

MISSING=0
INSTALLED=0

check_command() {
  local cmd=$1
  local name=$2
  local install_hint=$3

  if command -v "$cmd" &> /dev/null; then
    local version=$("$cmd" --version 2>&1 | head -n1)
    echo -e "${GREEN}✓${NC} $name - $version"
    ((INSTALLED++))
  else
    echo -e "${RED}✗${NC} $name - NOT FOUND"
    if [ -n "$install_hint" ]; then
      echo -e "  ${YELLOW}Install:${NC} ${CYAN}${BOLD}$install_hint${NC}"
    fi
    ((MISSING++))
  fi
}

check_file() {
  local file=$1
  local name=$2

  if [ -f "$file" ]; then
    echo -e "${GREEN}✓${NC} $name"
    ((INSTALLED++))
  else
    echo -e "${RED}✗${NC} $name - NOT FOUND at $file"
    ((MISSING++))
  fi
}

echo -e "${BLUE}Core Requirements:${NC}"
check_command "nvim" "Neovim" "nvim"
check_command "git" "Git" "git"
check_command "gcc" "GCC (C compiler)" "gcc"
check_command "g++" "G++ (C++ compiler)" "g++"

echo -e "\n${BLUE}Code Search & Navigation:${NC}"
check_command "rg" "ripgrep" "ripgrep"
check_command "fd" "fd" "fd"
check_command "fzf" "fzf (optional)" "fzf"

echo -e "\n${BLUE}Code Formatting:${NC}"
check_command "prettier" "Prettier" "prettier"
check_command "stylua" "Stylua" "stylua"
check_command "black" "Black (Python)" "black"
check_command "clang-format" "clang-format" "clang-format"

echo -e "\n${BLUE}Language Servers (managed by Mason):${NC}"
echo -e "${YELLOW}Note:${NC} These are automatically installed by Mason. Run :Mason to check status."
echo "- clangd (C/C++)"
echo "- pyright (Python)"
echo "- typescript-language-server (TypeScript/JavaScript)"
echo "- lua-language-server (Lua)"

echo -e "\n${BLUE}Debuggers (managed by Mason):${NC}"
echo "- codelldb (C/C++/Rust/Microcontrollers)"
echo "- debugpy (Python)"
echo "- node-debug2-adapter (JavaScript/Node.js)"

echo -e "\n${BLUE}Microcontroller Debugging (optional):${NC}"
check_command "openocd" "OpenOCD" "openocd"
check_command "arm-none-eabi-gcc" "ARM toolchain" "arm-none-eabi-gcc"

echo -e "\n${BLUE}Python & Node (for LSP/DAP):${NC}"
check_command "python3" "Python 3" "python3"
check_command "npm" "Node.js (npm)" "npm"
check_command "node" "Node.js" "node"

echo -e "\n${BLUE}Clipboard Support (for system clipboard integration):${NC}"
if [ "$OSTYPE" = "linux-gnu"* ] || [ "$OSTYPE" = "linux" ]; then
  if command -v xclip &> /dev/null || command -v xsel &> /dev/null; then
    if command -v xclip &> /dev/null; then
      echo -e "${GREEN}✓${NC} xclip (clipboard provider)"
    else
      echo -e "${GREEN}✓${NC} xsel (clipboard provider)"
    fi
    ((INSTALLED++))
  else
    echo -e "${RED}✗${NC} Clipboard provider - NOT FOUND"
    echo -e "  ${YELLOW}Install one of:${NC} ${CYAN}${BOLD}xclip${NC} or ${CYAN}${BOLD}xsel${NC}"
    ((MISSING++))
  fi
elif [ "$OSTYPE" = "darwin"* ]; then
  echo -e "${GREEN}✓${NC} macOS native clipboard support"
  ((INSTALLED++))
else
  echo -e "${YELLOW}?${NC} Clipboard support - Cannot determine for this OS"
fi

echo -e "\n${BLUE}Utilities:${NC}"
check_command "curl" "curl" "curl"
check_command "wget" "wget" "wget"

echo -e "\n${BLUE}=== Summary ===${NC}"
echo -e "${GREEN}Installed:${NC} $INSTALLED"
echo -e "${RED}Missing:${NC} $MISSING"

if [ $MISSING -eq 0 ]; then
  echo -e "\n${GREEN}✓ All dependencies are installed!${NC}"
  echo -e "\nYour nvim configuration is ready to use."
  echo -e "Start nvim with: ${BLUE}nvim${NC}"
  exit 0
else
  echo -e "\n${YELLOW}⚠ Some dependencies are missing.${NC}"
  echo -e "\nFor Mason-managed tools (LSP/Debuggers):"
  echo -e "  1. Open nvim: ${BLUE}nvim${NC}"
  echo -e "  2. Run: ${BLUE}:Mason${NC}"
  echo -e "  3. Install missing tools (press 'i' to install)"
  echo -e "\nFor system-level tools:"
  echo -e "  Install the missing packages using your package manager."
  echo -e "  (apt, brew, pacman, dnf, zypper, etc.)"
  exit 1
fi
