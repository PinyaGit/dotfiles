import xml.etree.ElementTree as ET
import subprocess

# Dictionary of context -> list of (source, translation)
translations = {
    # Network Popout
    "Network": [
        ("Wireless", "Беспроводная сеть"),
        ("Enabled", "Включено"),
        ("Ethernet", "Проводная сеть"),
        ("%1 networks available", "Доступно сетей: %1"),
        ("%1 devices available", "Доступно устройств: %1"),
        ("Rescan networks", "Обновить список сетей"),
        ("Unknown", "Неизвестно"),
    ],
    "WirelessPassword": [
        ("Connect", "Подключить"),
        ("Connecting...", "Подключение..."),
        ("Enter password", "Введите пароль"),
        ("Network: %1", "Сеть: %1"),
        ("Network: Unknown", "Сеть: Неизвестно"),
        ("Connection failed. Please check your password and try again.", "Сбой подключения. Проверьте пароль и повторите попытку."),
        ("Password", "Пароль"),
        ("Cancel", "Отмена"),
    ],
    # Audio Popout
    "AudioPopout": [
        ("Output device", "Устройство вывода"),
        ("Input device", "Устройство ввода"),
        ("Volume (%1)", "Громкость (%1)"),
        ("Muted", "Без звука"),
        ("Applications", "Приложения"),
        ("%1 active", "Активно: %1"),
        ("No apps playing audio", "Нет играющих приложений"),
        ("Open settings", "Открыть настройки"),
    ],
    # Bluetooth Popout
    "Bluetooth": [
        ("Bluetooth", "Bluetooth"),
        ("Enabled", "Включено"),
        ("Discovering", "Поиск устройств..."),
        ("%1 device%2 available", "Доступно устройств: %1"),
        (" (%1 connected)", " (%1 подкл.)"),
        ("Open settings", "Открыть настройки"),
    ],
    # Battery Popout
    "Battery": [
        ("No battery detected", "Батарея не обнаружена"),
        ("Remaining: %1%", "Осталось: %1%"),
        ("Power profile: %1", "Режим питания: %1"),
        ("Performance Degraded", "Производительность снижена"),
        ("Reason: %1", "Причина: %1"),
    ],
    # Lock Status
    "LockStatus": [
        ("Capslock: %1", "Caps Lock: %1"),
        ("Numlock: %1", "Num Lock: %1"),
    ],
    # Dashboard Tabs & Cards
    "Content": [
        ("Dashboard", "Главная"),
        ("Media", "Медиа"),
        ("Performance", "Мониторинг"),
        ("Weather", "Погода"),
    ],
    "Performance": [
        ("No widgets enabled", "Виджеты не включены"),
        ("Enable widgets in the dashboard settings", "Включите виджеты в настройках"),
        ("CPU", "Процессор"),
        ("GPU", "Видеокарта"),
    ],
    "MemoryCard": [
        ("Memory", "Оперативная память"),
        ("Used", "Использовано"),
    ],
    "StorageCard": [
        ("Storage", "Диски"),
        ("Used", "Занято"),
        ("No disks detected", "Диски не обнаружены"),
        ("No disks", "Нет дисков"),
    ],
    "NetworkCard": [
        ("Network", "Сеть"),
        ("Collecting data...", "Сбор данных..."),
        ("Download", "Входящий"),
        ("Upload", "Исходящий"),
        ("Total", "Всего"),
    ],
    "BatteryTank": [
        ("Battery", "Батарея"),
        ("Full", "Заряжена"),
        ("Charging", "Заряжается"),
        ("Usage", "Нагрузка"),
    ],
    "WeatherTab": [
        ("7-Day Forecast", "Прогноз на 7 дней"),
        ("Today", "Сегодня"),
        ("Loading...", "Загрузка..."),
    ],
    "Media": [
        ("Nothing playing", "Ничего не играет"),
        ("Play something for it to show up here!", "Включите музыку или видео, чтобы они появились здесь"),
        ("No media", "Нет медиа"),
        ("Unknown title", "Неизвестный трек"),
        ("Unknown artist", "Неизвестный исполнитель"),
        ("Unknown album", "Неизвестный альбом"),
        ("Lyrics", "Текст песни"),
        ("Loading lyrics...", "Загрузка текста..."),
        ("No lyrics found", "Текст не найден"),
        ("No players", "Нет плееров"),
    ],
    # Session Menu
    "Session": [
        ("Shutdown", "Выключение"),
        ("Restart", "Перезагрузка"),
        ("Reboot", "Перезагрузка"),
        ("Lock", "Блокировка"),
        ("Logout", "Выход"),
        ("Hibernate", "Гибернация"),
        ("Suspend", "Ждущий режим"),
    ],
    # Toasts
    "ConfigToasts": [
        ("Config loaded", "Конфигурация загружена"),
        ("Config loaded successfully!", "Настройки успешно применены!"),
        ("Failed to parse config%1", "Ошибка в конфигурации%1"),
        ("Failed to save config%1", "Не удалось сохранить настройки%1"),
        ("Unknown option in%1 config", "Неизвестная опция в конфиге%1"),
    ],
    # Generic empty context for fallback
    "": [
        ("Enabled", "Включено"),
        ("Disabled", "Выключено"),
        ("Wireless", "Беспроводная сеть"),
        ("Ethernet", "Проводная сеть"),
        ("Bluetooth", "Bluetooth"),
        ("Volume", "Громкость"),
        ("Brightness", "Яркость"),
        ("Back", "Назад"),
        ("Cancel", "Отмена"),
        ("Connect", "Подключить"),
        ("Connected", "Подключено"),
        ("Connecting...", "Подключение..."),
        ("Disconnect", "Отключить"),
        ("Password", "Пароль"),
        ("Today", "Сегодня"),
        ("Dashboard", "Главная"),
        ("Media", "Медиа"),
        ("Performance", "Мониторинг"),
        ("Weather", "Погода"),
        ("Shutdown", "Выключение"),
        ("Restart", "Перезагрузка"),
        ("Lock", "Блокировка"),
        ("Logout", "Выход"),
        ("Memory", "Память"),
        ("Network", "Сеть"),
        ("Storage", "Диски"),
    ]
}

root = ET.Element("TS", version="2.1", language="ru_RU")

for ctx_name, msgs in translations.items():
    ctx_el = ET.SubElement(root, "context")
    name_el = ET.SubElement(ctx_el, "name")
    name_el.text = ctx_name
    for src, trans in msgs:
        msg_el = ET.SubElement(ctx_el, "message")
        src_el = ET.SubElement(msg_el, "source")
        src_el.text = src
        trans_el = ET.SubElement(msg_el, "translation")
        trans_el.text = trans

tree = ET.ElementTree(root)
ts_file = "/home/pinya/.config/quickshell/op-caelestia/translations/caelestia_ru.ts"
qm_file = "/home/pinya/.config/quickshell/op-caelestia/translations/caelestia_ru.qm"

tree.write(ts_file, encoding="utf-8", xml_declaration=True)
print(f"Generated {ts_file}")

res = subprocess.run(["lrelease", ts_file, "-qm", qm_file], capture_output=True, text=True)
print(res.stdout)
if res.returncode == 0:
    print(f"Successfully compiled {qm_file}")
else:
    print("lrelease error:", res.stderr)
