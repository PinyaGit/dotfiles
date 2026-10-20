# 🚀 Arch Linux + Hyprland + OP-Caelestia Dotfiles

Полностью настроенная и оптимизированная система на базе **Arch Linux**, оконного менеджера **Hyprland** и кастомной оболочки **OP-Caelestia (Quickshell)** с поддержкой русского языка, игровыми твиками для NVIDIA RTX и автоматическим обслуживанием.

---

## 📦 Что включено в сборку

- **Оконный менеджер Hyprland:**
  - Русская и английская раскладки клавиатуры с переключением по `Alt + Shift`.
  - Браузер по умолчанию — **Brave** (`Super + W`).
  - 3D Taskview / Overview по `Super + Tab`.
  - Быстрый перезапуск оболочки по `Ctrl + Super + Alt + R`.
- **Оболочка OP-Caelestia Shell (Quickshell):**
  - Полная русификация интерфейса (виджеты сети, аудио, батареи, дашборда, сессии).
  - Классические маскоты: Bongo Cat в медиаплеере и Kurukuru в меню выключения.
  - Погода для Воронежа и поддержка локализованных названий дат/дней недели.
  - Устранены вылеты SIGSEGV и ошибки конфигурации.
- **Интерактивная шпаргалка (`Super + F1` / `Super + /`):**
  - Всплывающее окно с вкладками (Игры, Окна, Caelestia, Приложения, Звук).
  - Живой поиск (`Ctrl + F`).
  - Параметры запуска Steam (DLSS, FSR, GameMode, MangoHud, Gamescope) с кнопкой копирования в один клик.
- **Игровой комфорт:**
  - Конфигурация оверлея **MangoHud** (FPS, frametime, температуры и частоты GPU/CPU) по `Right Shift + F12`.
  - Настройка **ProtonUp-Qt** для загрузки GE-Proton.
- **Файловый менеджер Thunar:**
  - Генерация превью изображений, видео и документов (`tumbler`, `ffmpegthumbnailer`, `poppler-glib`).
  - Просмотр картинок через быстрый `Viewnior` вместо браузера.
  - Интеграция архивов в контекстное меню.
  - Быстрый доступ к SMB-шарам домашнего сервера.
- **Обслуживание системы:**
  - Автоматический TRIM для NVMe SSD (`fstrim.timer`).
  - Автоочистка старых пакетов pacman (`paccache.timer`).
  - Настроенная служба планировщика `cronie` для Btrfs-снимков Timeshift.

---

## 📥 Установка на чистую систему

На свежеустановленном **Arch Linux** с установленным `git`:

```bash
# 1. Клонируйте ваш репозиторий
git clone https://github.com/PinyaGit/dotfiles.git ~/dotfiles

# 2. Перейдите в папку и запустите установщик
cd ~/dotfiles
./install.sh
```

Скрипт автоматически:
1. Установит все необходимые пакеты из официальных репозиториев и AUR.
2. Создаст правильную структуру папок пользователя и русские симлинки.
3. Развернёт конфигурации Hyprland, Caelestia, MangoHud и ассоциации файлов.
4. Склонирует и скомпилирует C++ плагин OP-Caelestia Shell со всеми переводами и маскотами.
5. Включит системные службы и таймеры обслуживания.

---

## 📤 Как опубликовать эти dotfiles на ваш GitHub

Если вы ещё не загрузили эту папку на GitHub:

### Вариант 1: Через утилиту GitHub CLI (`gh`)
```bash
cd ~/dotfiles
git init
git add .
git commit -m "feat: initial commit of Arch + Hyprland + OP-Caelestia setup"
gh auth login
gh repo create dotfiles --public --source=. --remote=origin --push
```

### Вариант 2: Через сайт GitHub вручную
1. Создайте новый пустой репозиторий на сайте [GitHub](https://github.com/new) с именем `dotfiles` (не добавляйте README и .gitignore).
2. Выполните в терминале:
```bash
cd ~/dotfiles
git init
git add .
git commit -m "feat: initial commit of Arch + Hyprland + OP-Caelestia setup"
git branch -M main
git remote add origin https://github.com/<ВАШ_НИКНЕЙМ>/dotfiles.git
git push -u origin main
```
