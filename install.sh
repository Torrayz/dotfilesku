#!/usr/bin/env bash
#
# install.sh — pasang dotfiles dengan GNU Stow (symlink ke $HOME).
#
# Cara pakai:
#   ./install.sh          # pasang
#   ./install.sh --dry-run # lihat dulu apa yang akan ditautkan
#
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$HOME"
DRY_RUN=false

for arg in "$@"; do
  case "$arg" in
    --dry-run|-n) DRY_RUN=true ;;
    -h|--help)
      echo "Usage: $0 [--dry-run]"
      exit 0 ;;
  esac
done

# --- 1. pastikan stow tersedia -------------------------------------------
if ! command -v stow >/dev/null 2>&1; then
  echo "ERROR: GNU Stow tidak ditemukan."
  echo "       Install dulu, misalnya:"
  echo "         sudo pacman -S stow    # Arch / Manjaro / EndeavourOS"
  echo "         sudo apt install stow  # Debian / Ubuntu"
  exit 1
fi

# --- 2. ganti placeholder @HOME@ dengan HOME user ini ---------------------
if grep -rIl '@HOME@' "$REPO/home" >/dev/null 2>&1; then
  echo "→ Menyesuaikan path @HOME@ → $TARGET"
  grep -rIl '@HOME@' "$REPO/home" | while IFS= read -r f; do
    sed -i "s|@HOME@|$TARGET|g" "$f"
  done
fi

if [ "$DRY_RUN" = true ]; then
  echo "→ Dry-run (tidak ada yang diubah):"
  (cd "$REPO" && stow --target="$TARGET" --no --verbose=2 home) || true
  exit 0
fi

# --- 3. stow --------------------------------------------------------------
echo "→ Membuat symlink ke $TARGET ..."
(cd "$REPO" && stow --target="$TARGET" home)

cat <<'MSG'

✅ Selesai. Konfigurasi sudah di-symlink ke HOME kamu.
   - ~/.config/{hypr,waybar,rofi,kitty,ml4w,...}
   - ~/.bashrc  ~/.zshrc

   Untuk uninstal:
     cd ~/dotfiles && stow -D --target="$HOME" home

   PENTING:
   - Dotfiles ini berbasis ML4W (dots-hyprland). Pastikan dependency-nya
     sudah terpasang (lihat README.md) sebelum restart/login ke Hyprland.
   - Jangan commit API key. Simpan rahasia di ~/.bashrc_custom / ~/.zshrc_custom.
   - Tambahkan wallpaper kamu ke ~/.config/ml4w/wallpapers/ (dikeluarkan dari repo).
MSG