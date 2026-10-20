#!/usr/bin/env bash
set -e

# ==============================================================================
# Arch Linux + Hyprland + OP-Caelestia Dotfiles Installer
# ==============================================================================

BOLD="\033[1m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
NC="\033[0m"

info()    { echo -e "${BLUE}${BOLD}[ИНФО]${NC} $1"; }
success() { echo -e "${GREEN}${BOLD}[ГОТОВО]${NC} $1"; }
warn()    { echo -e "${YELLOW}${BOLD}[ВНИМАНИЕ]${NC} $1"; }
error()   { echo -e "${RED}${BOLD}[ОШИБКА]${NC} $1"; }

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BOLD}"
echo "  ╔═══════════════════════════════════════════════════════════╗"
echo "  ║   Arch Linux + Hyprland + OP-Caelestia Dotfiles Setup    ║"
echo "  ╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# 1. Проверка операционной системы
if [ ! -f /etc/arch-release ]; then
    error "Данный скрипт предназначен только для Arch Linux!"
    exit 1
fi

# 2. Определение AUR-хелпера
AUR_HELPER=""
if command -v paru &>/dev/null; then
    AUR_HELPER="paru"
elif command -v yay &>/dev/null; then
    AUR_HELPER="yay"
else
    warn "AUR-хелпер (paru/yay) не найден. Пакеты из AUR не смогут быть установлены автоматически."
fi

# 3. Установка пакетов
info "Установка пакетов из официальных репозиториев pacman..."
if [ -f "$DOTFILES_DIR/packages/pacman.txt" ]; then
    # Фильтруем комментарии и пустые строки
    PKGS=$(grep -v '^#' "$DOTFILES_DIR/packages/pacman.txt" | grep -v '^[[:space:]]*$' | tr '\n' ' ')
    sudo pacman -S --needed --noconfirm $PKGS || warn "Некоторые пакеты не удалось установить."
fi

if [ -n "$AUR_HELPER" ] && [ -f "$DOTFILES_DIR/packages/aur.txt" ]; then
    info "Установка пакетов из AUR через $AUR_HELPER..."
    AUR_PKGS=$(grep -v '^#' "$DOTFILES_DIR/packages/aur.txt" | grep -v '^[[:space:]]*$' | tr '\n' ' ')
    $AUR_HELPER -S --needed --noconfirm $AUR_PKGS || warn "Некоторые AUR-пакеты не удалось установить."
fi

# 4. Настройка папок пользователя и симлинков совместимости
info "Настройка стандартных папок пользователя..."
xdg-user-dirs-update || true
mkdir -p "$HOME/Загрузки" "$HOME/Изображения" "$HOME/Документы" "$HOME/Музыка" "$HOME/Видео"
[ ! -e "$HOME/Downloads" ] && ln -sf "$HOME/Загрузки" "$HOME/Downloads"
[ ! -e "$HOME/Pictures" ] && ln -sf "$HOME/Изображения" "$HOME/Pictures"

# 5. Копирование конфигураций в ~/.config
info "Развёртывание конфигурационных файлов в ~/.config..."
mkdir -p "$HOME/.config"

for dir in hypr caelestia MangoHud gtk-3.0; do
    if [ -d "$DOTFILES_DIR/config/$dir" ]; then
        mkdir -p "$HOME/.config/$dir"
        cp -rf "$DOTFILES_DIR/config/$dir/"* "$HOME/.config/$dir/"
    fi
done

if [ -f "$DOTFILES_DIR/config/mimeapps.list" ]; then
    cp -f "$DOTFILES_DIR/config/mimeapps.list" "$HOME/.config/mimeapps.list"
fi

# Закладки GTK для Thunar (SMB)
if [ -f "$HOME/.config/gtk-3.0/bookmarks" ]; then
    ln -sf "$HOME/.config/gtk-3.0/bookmarks" "$HOME/.gtk-bookmarks"
fi

# 6. Установка пользовательских скриптов в ~/.local/bin
info "Установка скриптов в ~/.local/bin..."
mkdir -p "$HOME/.local/bin"
cp -rf "$DOTFILES_DIR/local/bin/"* "$HOME/.local/bin/"
chmod +x "$HOME/.local/bin/"*

# Проверка PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    warn "~/.local/bin отсутствует в вашем PATH. Рекомендуется добавить 'export PATH=\"\$HOME/.local/bin:\$PATH\"' в ~/.bashrc или ~/.zshrc."
fi

# 7. Развёртывание и сборка OP-Caelestia Shell
info "Настройка и сборка OP-Caelestia Shell..."
CAELESTIA_DIR="$HOME/.config/quickshell/op-caelestia"

if [ ! -d "$CAELESTIA_DIR/.git" ]; then
    info "Клонирование репозитория OP-Caelestia Shell..."
    mkdir -p "$HOME/.config/quickshell"
    git clone https://github.com/OVERxPOWERED/op-caelestia-shell.git "$CAELESTIA_DIR"
fi

cd "$CAELESTIA_DIR"

# Применение правок и патча
if [ -f "$DOTFILES_DIR/op-caelestia-patch/patch.diff" ]; then
    info "Применение русификации, Mascots Classic и исправлений..."
    git checkout -f || true
    patch -p1 < "$DOTFILES_DIR/op-caelestia-patch/patch.diff" || true
fi

# Копирование тем и переводов
if [ -d "$DOTFILES_DIR/op-caelestia-patch/extra_files" ]; then
    info "Развёртывание модулей Ollama AI и Display Settings..."
    cp -rf "$DOTFILES_DIR/op-caelestia-patch/extra_files/"* "$CAELESTIA_DIR/"
fi

if [ -d "$DOTFILES_DIR/op-caelestia-patch/assets_Classic" ]; then
    mkdir -p "$CAELESTIA_DIR/assets/themes/Classic"
    cp -rf "$DOTFILES_DIR/op-caelestia-patch/assets_Classic/"* "$CAELESTIA_DIR/assets/themes/Classic/"
fi

if [ -d "$DOTFILES_DIR/op-caelestia-patch/translations" ]; then
    mkdir -p "$CAELESTIA_DIR/translations"
    cp -rf "$DOTFILES_DIR/op-caelestia-patch/translations/"* "$CAELESTIA_DIR/translations/"
fi

# Компиляция C++ плагина
info "Компиляция нативного C++ плагина Caelestia..."
mkdir -p "$CAELESTIA_DIR/build"
cd "$CAELESTIA_DIR/build"
cmake .. -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$CAELESTIA_DIR/.local-caelestia-plugin/usr"
ninja
ninja install
cd "$DOTFILES_DIR"

# 8. Включение системных служб и таймеров
info "Включение фоновых служб (fstrim, paccache, cronie)..."
sudo systemctl enable --now fstrim.timer || true
sudo systemctl enable --now paccache.timer || true
sudo systemctl enable --now cronie.service || true

# 9. Настройка темы SDDM (опционально)
if [ -f "$DOTFILES_DIR/system/sddm.conf.d/caelestia.conf" ] && [ -d /usr/share/sddm/themes/caelestia ]; then
    info "Применение конфигурации SDDM темы..."
    sudo mkdir -p /etc/sddm.conf.d
    sudo cp -f "$DOTFILES_DIR/system/sddm.conf.d/caelestia.conf" /etc/sddm.conf.d/caelestia.conf
    # Устранение возможного конфликта со старым theme.conf
    [ -f /etc/sddm.conf.d/theme.conf ] && sudo rm -f /etc/sddm.conf.d/theme.conf || true
fi

# 10. Перезагрузка Hyprland если запущен
if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    info "Перезагрузка активной конфигурации Hyprland и Caelestia..."
    hyprctl reload || true
    op-caelestia -r || true
fi

echo ""
success "Установка и настройка успешно завершены!"
echo -e "Подсказка: нажимайте ${BOLD}Super + F1${NC} в любой момент для вызова интерактивной шпаргалки."
