<#
	.SYNOPSIS
	Default preset file for "Sophia Script for Windows 10 LTSC 2021"

	Version: v5.15.0
	Date: 30.01.2023

	Copyright (c) 2014—2023 farag
	Copyright (c) 2019—2023 farag & Inestic

	Thanks to all https://forum.ru-board.com members involved

	.DESCRIPTION
	Place the "#" char before function if you don't want to run it
	Remove the "#" char before function if you want to run it
	Every tweak in the preset file has its' corresponding function to restore the default settings

	.EXAMPLE Run the whole script
	.\Sophia.ps1

	.EXAMPLE Run the script by specifying the module functions as an argument
	.\Sophia.ps1 -Functions "DiagTrackService -Disable", "DiagnosticDataLevel -Minimal"

	.EXAMPLE Download and expand the latest Sophia Script version archive (without running) according which Windows and PowerShell versions it is run on
	irm script.sophi.app -useb | iex

	.NOTES
	Supported Windows 10 version
	Version: 21H2
	Build: 19044.2364+
	Edition: Enterprise LTSC 2021
	Architecture: x64

	.NOTES
	To use the TAB completion for functions and their arguments dot source the Function.ps1 script first:
		. .\Function.ps1 (with a dot at the beginning)
	Read more in the Functions.ps1 file

	.LINK GitHub
	https://github.com/farag2/Sophia-Script-for-Windows

	.LINK Telegram
	https://t.me/sophianews
	https://t.me/sophia_chat

	.LINK Discord
	https://discord.gg/sSryhaEv79

	.NOTES
	https://forum.ru-board.com/topic.cgi?forum=62&topic=30617#15
	https://habr.com/company/skillfactory/blog/553800/
	https://forums.mydigitallife.net/threads/powershell-windows-10-sophia-script.81675/
	https://www.reddit.com/r/PowerShell/comments/go2n5v/powershell_script_setup_windows_10/

	.LINK Authors
	https://github.com/farag2
	https://github.com/Inestic
#>

#Requires -RunAsAdministrator
#Requires -Version 5.1

[CmdletBinding()]
param
(
	[Parameter(Mandatory = $false)]
	[string[]]
	$Functions
)

Clear-Host

$Host.UI.RawUI.WindowTitle = "Sophia Script for Windows 10 LTSC 2021 v5.15.0 | Made with $([char]::ConvertFromUtf32(0x1F497)) of Windows | $([char]0x00A9) farag & Inestic, 2014$([char]0x2013)2023"

Remove-Module -Name Sophia -Force -ErrorAction Ignore
Import-Module -Name $PSScriptRoot\Manifest\Sophia.psd1 -PassThru -Force

Import-LocalizedData -BindingVariable Global:Localization -BaseDirectory $PSScriptRoot\Localizations -FileName Sophia

<#
	.SYNOPSIS
	Run the script by specifying functions as an argument
	Запустить скрипт, указав в качестве аргумента функции

	.EXAMPLE
	.\Sophia.ps1 -Functions "DiagTrackService -Disable", "DiagnosticDataLevel -Minimal"

	.NOTES
	Use commas to separate funtions
	Разделяйте функции запятыми
#>
if ($Functions)
{
	Invoke-Command -ScriptBlock {Checks}

	foreach ($Function in $Functions)
	{
		Invoke-Expression -Command $Function
	}

	# The "RefreshEnvironment" and "Errors" functions will be executed at the end
	Invoke-Command -ScriptBlock {RefreshEnvironment; Errors}

	exit
}

#region Protection
<#
	The mandatory checks. If you want to disable a warning message about whether the preset file was customized, remove the "-Warning" argument
	Please, do not comment out this function

	Обязательные проверки. Чтобы выключить предупреждение о необходимости настройки пресет-файла, удалите аргумент "-Warning"
	Пожалуйста, не комментируйте данную функцию
#>
Checks -Warning

<#
	Enable script logging. Log will be recorded into the script folder
	To stop logging just close console or type "Stop-Transcript"

	Включить логирование работы скрипта. Лог будет записываться в папку скрипта
	Чтобы остановить логгирование, закройте консоль или наберите "Stop-Transcript"
#>
# Logging

# Create a restore point
# Создать точку восстановления
CreateRestorePoint
#endregion Protection

#region Privacy & Telemetry
# Disable the "Connected User Experiences and Telemetry" service (DiagTrack), and block the connection for the Unified Telemetry Client Outbound Traffic
# Отключить службу "Функциональные возможности для подключенных пользователей и телеметрия" (DiagTrack) и блокировать соединение для исходящего трафик клиента единой телеметрии
DiagTrackService -Disable

# Enable the "Connected User Experiences and Telemetry" service (DiagTrack), and allow the connection for the Unified Telemetry Client Outbound Traffic (default value)
# Включить службу "Функциональные возможности для подключенных пользователей и телеметрия" (DiagTrack) и разрешить подключение для исходящего трафик клиента единой телеметрии  (значение по умолчанию)
# DiagTrackService -Enable

# Set the diagnostic data collection to minimum
# Установить уровень сбора диагностических данных ОС на минимальный
DiagnosticDataLevel -Minimal

# Set the diagnostic data collection to default (default value)
# Установить уровень сбора диагностических данных ОС по умолчанию (значение по умолчанию)
# DiagnosticDataLevel -Default

# Turn off the Windows Error Reporting
# Отключить запись отчетов об ошибках Windows
ErrorReporting -Disable

# Turn on the Windows Error Reporting (default value)
# Включить отчеты об ошибках Windows (значение по умолчанию)
# ErrorReporting -Enable

# Change the feedback frequency to "Never"
# Изменить частоту формирования отзывов на "Никогда"
FeedbackFrequency -Never

# Change the feedback frequency to "Automatically" (default value)
# Изменить частоту формирования отзывов на "Автоматически" (значение по умолчанию)
# FeedbackFrequency -Automatically

# Turn off the diagnostics tracking scheduled tasks
# Отключить задачи диагностического отслеживания
ScheduledTasks -Disable

# Turn on the diagnostics tracking scheduled tasks (default value)
# Включить задачи диагностического отслеживания (значение по умолчанию)
# ScheduledTasks -Enable

# Do not use sign-in info to automatically finish setting up device and reopen apps after an update or restart
# Не использовать данные для входа для автоматического завершения настройки устройства и открытия приложений после перезапуска или обновления
SigninInfo -Disable

# Use sign-in info to automatically finish setting up device and reopen apps after an update or restart (default value)
# Использовать данные для входа для автоматического завершения настройки устройства и открытия приложений после перезапуска или обновления (значение по умолчанию)
# SigninInfo -Enable

# Do not let websites provide locally relevant content by accessing language list
# Не позволять веб-сайтам предоставлять местную информацию за счет доступа к списку языков
LanguageListAccess -Disable

# Let websites provide locally relevant content by accessing language list (default value)
# Позволять веб-сайтам предоставлять местную информацию за счет доступа к списку языков (значение по умолчанию)
# LanguageListAccess -Enable

# Do not allow apps to use advertising ID to make ads more interresting to you based on your app usage 
# Не разрешать приложениям использовать идентификатор рекламы
AdvertisingID -Disable

# Let apps use advertising ID to make ads more interresting to you based on your app usage (default value)
# Разрешить приложениям использовать идентификатор рекламы (значение по умолчанию)
# AdvertisingID -Enable

# Do not suggest ways I can finish setting up my device to get the most out of Windows
# Не предлагать способы завершения настройки устройства для максимально эффективного использования Windows
WhatsNewInWindows -Disable

# Suggest ways I can finish setting up my device to get the most out of Windows (default value)
# Предлагать способы завершения настройки устройства для максимально эффективного использования Windows (значение по умолчанию)
# WhatsNewInWindows -Enable

# Do not let Microsoft offer you tailored experiences based on the diagnostic data setting you have chosen
# Не разрешать корпорации Майкософт использовать ваши диагностические данные для предоставления вам персонализированных советов, рекламы и рекомендаций, чтобы улучшить работу со службами Майкрософт
TailoredExperiences -Disable

# Let Microsoft offer you tailored experiences based on the diagnostic data setting you have chosen (default value)
# Разрешите корпорации Майкософт использовать ваши диагностические данные для предоставления вам персонализированных советов, рекламы и рекомендаций, чтобы улучшить работу со службами Майкрософт (значение по умолчанию)
# TailoredExperiences -Enable

# Disable Bing search in the Start Menu
# Отключить в меню "Пуск" поиск через Bing
BingSearch -Disable

# Enable Bing search in the Start Menu (default value)
# Включить поиск через Bing в меню "Пуск" (значение по умолчанию)
# BingSearch -Enable
#endregion Privacy & Telemetry

#region UI & Personalization
# Show the "This PC" icon on Desktop
# Отобразить значок "Этот компьютер" на рабочем столе
ThisPC -Show

# Hide the "This PC" icon on Desktop (default value)
# Скрыть "Этот компьютер" на рабочем столе (значение по умолчанию)
# ThisPC -Hide

# Do not use item check boxes
# Не использовать флажки для выбора элементов
CheckBoxes -Disable

# Use check item check boxes (default value)
# Использовать флажки для выбора элементов (значение по умолчанию)
# CheckBoxes -Enable

# Show hidden files, folders, and drives
# Отобразить скрытые файлы, папки и диски
HiddenItems -Enable

# Do not show hidden files, folders, and drives (default value)
# Не показывать скрытые файлы, папки и диски (значение по умолчанию)
# HiddenItems -Disable

# Show file name extensions
# Отобразить расширения имён файлов
FileExtensions -Show

# Hide file name extensions (default value)
# Скрывать расширения имён файлов файлов (значение по умолчанию)
# FileExtensions -Hide

# Show folder merge conflicts
# Не скрывать конфликт слияния папок
MergeConflicts -Show

# Hide folder merge conflicts (default value)
# Скрывать конфликт слияния папок (значение по умолчанию)
# MergeConflicts -Hide

# Open File Explorer to "This PC"
# Открывать проводник для "Этот компьютер"
OpenFileExplorerTo -ThisPC

# Open File Explorer to Quick access (default value)
# Открывать проводник для "Быстрый доступ" (значение по умолчанию)
# OpenFileExplorerTo -QuickAccess

# Do not show sync provider notification within File Explorer
# Не показывать уведомления поставщика синхронизации в проводнике
OneDriveFileExplorerAd -Hide

# Show sync provider notification within File Explorer (default value)
# Показывать уведомления поставщика синхронизации в проводнике (значение по умолчанию)
# OneDriveFileExplorerAd -Show

# When I snap a window, do not show what I can snap next to it
# При прикреплении окна не показывать, что можно прикрепить рядом с ним
SnapAssist -Disable

# When I snap a window, show what I can snap next to it (default value)
# При прикреплении окна показывать, что можно прикрепить рядом с ним (значение по умолчанию)
# SnapAssist -Enable

# Show the file transfer dialog box in the detailed mode
# Отображать диалоговое окно передачи файлов в развернутом виде
FileTransferDialog -Detailed

# Show the file transfer dialog box in the compact mode (default value)
# Отображать диалоговое окно передачи файлов в свернутом виде (значение по умолчанию)
# FileTransferDialog -Compact

# Expand the File Explorer ribbon
# Развернуть ленту проводника
FileExplorerRibbon -Expanded

# Minimize the File Explorer ribbon (default value)
# Свернуть ленту проводника (значение по умолчанию)
# FileExplorerRibbon -Minimized

# Display the recycle bin files delete confirmation dialog
# Запрашивать подтверждение на удаление файлов в корзину
RecycleBinDeleteConfirmation -Enable

# Do not display the recycle bin files delete confirmation dialog (default value)
# Не запрашивать подтверждение на удаление файлов в корзину (значение по умолчанию)
# RecycleBinDeleteConfirmation -Disable

# Hide the "3D Objects" folder in "This PC" and Quick access
# Скрыть папку "Объемные объекты" в "Этот компьютер" и панели быстрого доступа
3DObjects -Hide

# Show the "3D Objects" folder in "This PC" and Quick access (default value)
# Отобразить папку "Объемные объекты" в "Этот компьютер" и панели быстрого доступа (значение по умолчанию)
# 3DObjects -Show

# Hide recently used files in Quick access
# Скрыть недавно использовавшиеся файлы на панели быстрого доступа
# QuickAccessRecentFiles -Hide

# Show recently used files in Quick access (default value)
# Показать недавно использовавшиеся файлы на панели быстрого доступа (значение по умолчанию)
QuickAccessRecentFiles -Show

# Hide frequently used folders in Quick access
# Скрыть недавно используемые папки на панели быстрого доступа
# QuickAccessFrequentFolders -Hide

# Show frequently used folders in Quick access (default value)
# Показать часто используемые папки на панели быстрого доступа (значение по умолчанию)
QuickAccessFrequentFolders -Show

# Hide the Task View button on the taskbar
# Скрыть кнопку Просмотра задач
TaskViewButton -Hide

# Show the Task View button on the taskbar (default value)
# Отобразить кнопку Просмотра задач (значение по умолчанию)
# TaskViewButton -Show

# Hide People on the taskbar
# Скрыть панель "Люди" на панели задач
PeopleTaskbar -Hide

# Show People on the taskbar (default value)
# Отобразить панель "Люди" на панели задач (значение по умолчанию)
# PeopleTaskbar -Show

# Show seconds on the taskbar clock
# Отобразить секунды в системных часах на панели задач
# SecondsInSystemClock -Show

# Hide seconds on the taskbar clock (default value)
# Скрыть секунды в системных часах на панели задач (значение по умолчанию)
SecondsInSystemClock -Hide

# Hide the search on the taskbar
# Скрыть поле или значок поиска на панели задач
TaskbarSearch -Hide

# Show the search icon on the taskbar
# Показать значок поиска на панели задач
# TaskbarSearch -SearchIcon

# Show the search box on the taskbar (default value)
# Показать поле поиска на панели задач (значение по умолчанию)
# TaskbarSearch -SearchBox

# Hide the Windows Ink Workspace button on the taskbar
# Скрыть кнопку Windows Ink Workspace на панели задач
WindowsInkWorkspace -Hide

# Show Windows Ink Workspace button on the taskbar (default value)
# Показать кнопку Windows Ink Workspace на панели задач (значение по умолчанию)
# WindowsInkWorkspace -Show

# Always show all icons in the notification area
# Всегда отображать все значки в области уведомлений
# NotificationAreaIcons -Show

# Hide all icons in the notification area (default value)
# Скрыть все значки в области уведомлений (значение по умолчанию)
NotificationAreaIcons -Hide

# View the Control Panel icons by large icons
# Просмотр иконок Панели управления как: крупные значки
# ControlPanelView -LargeIcons

# View the Control Panel icons by small icons
# Просмотр иконок Панели управления как: маленькие значки
# ControlPanelView -SmallIcons

# View the Control Panel icons by category (default value)
# Просмотр иконок Панели управления как: категория (значение по умолчанию)
ControlPanelView -Category

# Set the default Windows mode to dark
# Установить режим Windows по умолчанию на темный
WindowsColorMode -Dark

# Set the default Windows mode to light (default value)
# Установить режим Windows по умолчанию на светлый (значение по умолчанию)
# WindowsColorMode -Light

# Set the default app mode to dark
# Установить цвет режима приложения на темный
AppColorMode -Dark

# Set the default app mode to light (default value)
# Установить цвет режима приложения на светлый (значение по умолчанию)
# AppColorMode -Light

# Hide the "New App Installed" indicator
# Скрыть уведомление "Установлено новое приложение"
NewAppInstalledNotification -Hide

# Show the "New App Installed" indicator (default value)
# Показывать уведомление "Установлено новое приложение" (значение по умолчанию)
# NewAppInstalledNotification -Show

# Hide first sign-in animation after the upgrade
# Скрывать анимацию при первом входе в систему после обновления
FirstLogonAnimation -Disable

# Show first sign-in animation after the upgrade (default value)
# Показывать анимацию при первом входе в систему после обновления (значение по умолчанию)
# FirstLogonAnimation -Enable

# Set the quality factor of the JPEG desktop wallpapers to maximum
# Установить коэффициент качества обоев рабочего стола в формате JPEG на максимальный
JPEGWallpapersQuality -Max

# Set the quality factor of the JPEG desktop wallpapers to default
# Установить коэффициент качества обоев рабочего стола в формате JPEG по умолчанию
# JPEGWallpapersQuality -Default

# Start Task Manager in the expanded mode
# Запускать Диспетчера задач в развернутом виде
TaskManagerWindow -Expanded

# Start Task Manager in the compact mode (default value)
# Запускать Диспетчера задач в свернутом виде (значение по умолчанию)
# TaskManagerWindow -Compact

# Show a notification when your PC requires a restart to finish updating
# Показывать уведомление, когда компьютеру требуется перезагрузка для завершения обновления
RestartNotification -Show

# Do not show a notification when your PC requires a restart to finish updating (default value)
# Не показывать уведомление, когда компьютеру требуется перезагрузка для завершения обновления (значение по умолчанию)
# RestartNotification -Hide

# Do not add the "- Shortcut" suffix to the file name of created shortcuts
# Нe дoбaвлять "- яpлык" к имени coздaвaeмых яpлыков
ShortcutsSuffix -Disable

# Add the "- Shortcut" suffix to the file name of created shortcuts (default value)
# Дoбaвлять "- яpлык" к имени coздaвaeмых яpлыков (значение по умолчанию)
# ShortcutsSuffix -Enable

# Use the Print screen button to open screen snipping
# Использовать кнопку PRINT SCREEN, чтобы запустить функцию создания фрагмента экрана
PrtScnSnippingTool -Enable

# Do not use the Print screen button to open screen snipping (default value)
# Не использовать кнопку PRINT SCREEN, чтобы запустить функцию создания фрагмента экрана (значение по умолчанию)
# PrtScnSnippingTool -Disable

# Let me use a different input method for each app window
# Позволить выбирать метод ввода для каждого окна
# AppsLanguageSwitch -Enable

# Do not use a different input method for each app window (default value)
# Не использовать метод ввода для каждого окна (значение по умолчанию)
AppsLanguageSwitch -Disable

# When I grab a windows's title bar and shake it, minimize all other windows (default value)
# При захвате заголовка окна и встряхивании сворачиваются все остальные окна (значение по умолчанию)
# AeroShaking -Enable

# When I grab a windows's title bar and shake it, don't minimize all other windows
# При захвате заголовка окна и встряхивании не сворачиваются все остальные окна
AeroShaking -Disable

# Download and install free dark "Windows 11 Cursors Concept v2" cursors from Jepri Creations
# Скачать и установить бесплатные темные курсоры "Windows 11 Cursors Concept v2" от Jepri Creations
# Cursors -Dark

# Download and install free light "Windows 11 Cursors Concept v2" cursors from Jepri Creations
# Скачать и установить бесплатные светлые курсоры "Windows 11 Cursors Concept v2" от Jepri Creations
# Cursors -Light

# Set default cursors (default value)
# Установить курсоры по умолчанию (значение по умолчанию)
# Cursors -Default
#endregion UI & Personalization

#region System
#region StorageSense
# Turn on Storage Sense
# Включить Контроль памяти
StorageSense -Enable

# Turn off Storage Sense (default value)
# Выключить Контроль памяти (значение по умолчанию)
# StorageSense -Disable

# Run Storage Sense every month
# Запускать Контроль памяти каждый месяц
StorageSenseFrequency -Month

# Run Storage Sense during low free disk space (default value)
# Запускать Контроль памяти, когда остается мало место на диске (значение по умолчанию)
# StorageSenseFrequency -Default

# Delete temporary files that apps aren't using
# Удалять временные файлы, не используемые в приложениях
StorageSenseTempFiles -Enable

# Do not delete temporary files that apps aren't using
# Не удалять временные файлы, не используемые в приложениях
# StorageSenseTempFiles -Disable
#endregion StorageSense

# Disable hibernation. Do not recommend turning it off on laptops
# Отключить режим гибернации. Не рекомендуется выключать на ноутбуках
Hibernation -Disable

# Enable hibernate (default value)
# Включить режим гибернации (значение по умолчанию)
# Hibernation -Enable

# Change the %TEMP% environment variable path to %SystemDrive%\Temp
# Изменить путь переменной среды для %TEMP% на %SystemDrive%\Temp
# TempFolder -SystemDrive

# Change %TEMP% environment variable path to %LOCALAPPDATA%\Temp (default value)
# Изменить путь переменной среды для %TEMP% на LOCALAPPDATA%\Temp (значение по умолчанию)
# TempFolder -Default

# Disable the Windows 260 characters path limit
# Отключить ограничение Windows на 260 символов в пути
Win32LongPathLimit -Disable

# Enable the Windows 260 character path limit (default value)
# Включить ограничение Windows на 260 символов в пути (значение по умолчанию)
# Win32LongPathLimit -Enable

# Display Stop error code when BSoD occurs
# Отображать код Stop-ошибки при появлении BSoD
BSoDStopError -Enable

# Do not Stop error code when BSoD occurs (default value)
# Не отображать код Stop-ошибки при появлении BSoD (значение по умолчанию)
# BSoDStopError -Disable

# Choose when to be notified about changes to your computer: never notify
# Настройка уведомления об изменении параметров компьютера: никогда не уведомлять
# AdminApprovalMode -Never

# Choose when to be notified about changes to your computer: notify me only when apps try to make changes to my computer (default value)
# Настройка уведомления об изменении параметров компьютера: уведомлять меня только при попытках приложений внести изменения в компьютер (значение по умолчанию)
AdminApprovalMode -Default

# Turn on access to mapped drives from app running with elevated permissions with Admin Approval Mode enabled
# Включить доступ к сетевым дискам при включенном режиме одобрения администратором при доступе из программ, запущенных с повышенными правами
# MappedDrivesAppElevatedAccess -Enable

# Turn off access to mapped drives from app running with elevated permissions with Admin Approval Mode enabled (default value)
# Выключить доступ к сетевым дискам при включенном режиме одобрения администратором при доступе из программ, запущенных с повышенными правами (значение по умолчанию)
# MappedDrivesAppElevatedAccess -Disable

# Turn off Delivery Optimization
# Выключить оптимизацию доставки
DeliveryOptimization -Disable

# Turn on Delivery Optimization (default value)
# Включить оптимизацию доставки (значение по умолчанию)
# DeliveryOptimization -Enable

# Always wait for the network at computer startup and logon for workgroup networks
# Всегда ждать сеть при запуске и входе в систему для рабочих групп
# WaitNetworkStartup -Enable

# Never wait for the network at computer startup and logon for workgroup networks (default value)
# Никогда не ждать сеть при запуске и входе в систему для рабочих групп (значение по умолчанию)
# WaitNetworkStartup -Disable

# Do not let Windows manage my default printer
# Не разрешать Windows управлять принтером, используемым по умолчанию
# WindowsManageDefaultPrinter -Disable

# Let Windows manage my default printer (default value)
# Разрешать Windows управлять принтером, используемым по умолчанию (значение по умолчанию)
# WindowsManageDefaultPrinter -Enable

<#
	Disable the Windows features using the pop-up dialog box
	If you want to leave "Multimedia settings" element in the advanced settings of Power Options do not disable the "Media Features" feature

	Если вы хотите оставить параметр "Параметры мультимедиа" в дополнительных параметрах схемы управления питанием, не отключайте "Компоненты для работы с медиа"
	Отключить компоненты Windows, используя всплывающее диалоговое окно
#>
WindowsFeatures -Disable

# Enable the Windows features using the pop-up dialog box
# Включить компоненты Windows, используя всплывающее диалоговое окно
# WindowsFeatures -Enable

<#
	Uninstall optional features using the pop-up dialog box
	If you want to leave "Multimedia settings" element in the advanced settings of Power Options do not uninstall the "Media Features" feature

	Удалить дополнительные компоненты, используя всплывающее диалоговое окно
	Если вы хотите оставить параметр "Параметры мультимедиа" в дополнительных параметрах схемы управления питанием, не удаляйте компонент "Компоненты для работы с медиа"
#>
WindowsCapabilities -Uninstall

# Install optional features using the pop-up dialog box
# Установить дополнительные компоненты, используя всплывающее диалоговое окно
# WindowsCapabilities -Install

# Receive updates for other Microsoft products when you update Windows
# При обновлении Windows получать обновления для других продуктов Майкрософт
UpdateMicrosoftProducts -Enable

# Do not receive updates for other Microsoft products when you update Windows (default value)
# При обновлении Windows не получать обновления для других продуктов Майкрософт (значение по умолчанию)
# UpdateMicrosoftProducts -Disable

<#
	Set power plan on "High performance"
	It isn't recommended to turn on the "High performance" power plan on laptops

	Установить схему управления питанием на "Высокая производительность"
	Не рекомендуется включать схему управления питанием "Высокая производительность" для ноутбуков
#>
PowerPlan -High

# Set power plan on "Balanced" (default value)
# Установить схему управления питанием на "Сбалансированная" (значение по умолчанию)
# PowerPlan -Balanced

# Do not allow the computer to turn off the network adapters to save power
# Запретить отключение всех сетевых адаптеров для экономии энергии
NetworkAdaptersSavePower -Disable

# Allow the computer to turn off the network adapters to save power (default value)
# Разрешить отключение всех сетевых адаптеров для экономии энергии (значение по умолчанию)
# NetworkAdaptersSavePower -Enable

<#
	Disable the Internet Protocol Version 6 (TCP/IPv6) component for all network connections
	Before invoking the function, a check will be run whether your ISP supports the IPv6 protocol using https://ipv6-test.com

	Выключить IP версии 6 (TCP/IPv6)
	Перед выполнением функции будет проведена проверка: поддерживает ли ваш провайдер IPv6, используя ресурс https://ipv6-test.com
#>
# IPv6Component -Disable

<#
	Enable the Internet Protocol Version 6 (TCP/IPv6) component for all network connections (default value)
	Before invoking the function, a check will be run whether your ISP supports the IPv6 protocol using https://ipv6-test.com

	Включить IP версии 6 (TCP/IPv6) (значение по умолчанию)
	Перед выполнением функции будет проведена проверка: поддерживает ли ваш провайдер IPv6, используя ресурс https://ipv6-test.com
#>
# IPv6Component -Enable

<#
	Enable the Internet Protocol Version 6 (TCP/IPv6) component for all network connections. Prefer IPv4 over IPv6
	Before invoking the function, a check will be run whether your ISP supports the IPv6 protocol using https://ipv6-test.com

	Включить IP версии 6 (TCP/IPv6) и предпочитать. Предпочтение IPv4 перед IPv6
	Перед выполнением функции будет проведена проверка: поддерживает ли ваш провайдер IPv6, используя ресурс https://ipv6-test.com
#>
# IPv6Component -PreferIPv4overIPv6

# Override for default input method: English
# Переопределить метод ввода по умолчанию: английский
# InputMethod -English

# Override for default input method: use language list (default value)
# Переопределить метод ввода по умолчанию: использовать список языков (значение по умолчанию)
# InputMethod -Default

<#
	Move user folders location to the root of any drive using the interactive menu
	User files or folders won't me moved to a new location. Move them manually
	They're located in the %USERPROFILE% folder by default

	Переместить пользовательские папки в корень любого диска на выбор с помощью интерактивного меню
	Пользовательские файлы и папки не будут перемещены в новое расположение. Переместите их вручную
	По умолчанию они располагаются в папке %USERPROFILE%
#>
SetUserShellFolderLocation -Root

<#
	Select folders for user folders location manually using a folder browser dialog
	User files or folders won't me moved to a new location. Move them manually
	They're located in the %USERPROFILE% folder by default

	Выбрать папки для расположения пользовательских папок вручную, используя диалог "Обзор папок"
	Пользовательские файлы и папки не будут перемещены в новое расположение. Переместите их вручную
	По умолчанию они располагаются в папке %USERPROFILE%
#>
# SetUserShellFolderLocation -Custom

<#
	Change user folders location to the default values
	User files or folders won't me moved to the new location. Move them manually
	They're located in the %USERPROFILE% folder by default

	Изменить расположение пользовательских папок на значения по умолчанию
	Пользовательские файлы и папки не будут перемещены в новое расположение. Переместите их вручную
	По умолчанию они располагаются в папке %USERPROFILE%
#>
# SetUserShellFolderLocation -Default

# Use the latest installed .NET runtime for all apps
# Использовать последнюю установленную среду выполнения .NET для всех приложений
LatestInstalled.NET -Enable

# Do not use the latest installed .NET runtime for all apps (default value)
# Не использовать последнюю установленную версию .NET для всех приложений (значение по умолчанию)
# LatestInstalled.NET -Disable

# Save screenshots by pressing Win+PrtScr on the Desktop
# Сохранять скриншоты по нажатию Win+PrtScr на рабочий столе
WinPrtScrFolder -Desktop

# Save screenshots by pressing Win+PrtScr in the Pictures folder (default value)
# Cохранять скриншоты по нажатию Win+PrtScr в папку "Изображения" (значение по умолчанию)
# WinPrtScrFolder -Default

<#
	Run troubleshooter automatically, then notify me
	In order this feature to work the OS level of diagnostic data gathering will be set to "Optional diagnostic data", and the error reporting feature will be turned on

	Автоматически запускать средства устранения неполадок, а затем уведомлять
	Чтобы заработала данная функция, уровень сбора диагностических данных ОС будет установлен на "Необязательные диагностические данные" и включится создание отчетов об ошибках Windows
#>
# RecommendedTroubleshooting -Automatically

<#
	Ask me before running troubleshooter (default value)
	In order this feature to work the OS level of diagnostic data gathering will be set to "Optional diagnostic data"

	Спрашивать перед запуском средств устранения неполадок (значение по умолчанию)
	Чтобы заработала данная функция, уровень сбора диагностических данных ОС будет установлен на "Необязательные диагностические данные" и включится создание отчетов об ошибках Windows
#>
RecommendedTroubleshooting -Default

# Launch folder windows in a separate process
# Запускать окна с папками в отдельном процессе
# FoldersLaunchSeparateProcess -Enable

# Do not launch folder windows in a separate process (default value)
# Не запускать окна с папками в отдельном процессе (значение по умолчанию)
# FoldersLaunchSeparateProcess -Disable

# Disable and delete reserved storage after the next update installation
# Отключить и удалить зарезервированное хранилище после следующей установки обновлений
ReservedStorage -Disable

# Enable reserved storage (default value)
# Включить зарезервированное хранилище (значение по умолчанию)
# ReservedStorage -Enable

# Disable help lookup via F1
# Отключить открытие справки по нажатию F1
F1HelpPage -Disable

# Enable help lookup via F1 (default value)
# Включить открытие справки по нажатию F1 (значение по умолчанию)
# F1HelpPage -Enable

# Enable Num Lock at startup
# Включить Num Lock при загрузке
NumLock -Enable

# Disable Num Lock at startup (default value)
# Выключить Num Lock при загрузке (значение по умолчанию)
# NumLock -Disable

# Disable Caps Lock
# Выключить Caps Lock
# CapsLock -Disable

# Enable Caps Lock (default value)
# Включить Caps Lock (значение по умолчанию)
# CapsLock -Enable

# Do not allow the shortcut key to Start Sticky Keys by pressing the the Shift key 5 times
# Не разрешать включения залипания клавиши Shift после 5 нажатий
StickyShift -Disable

# Allow the shortcut key to Start Sticky Keys by pressing the the Shift key 5 times (default value)
# Разрешать включения залипания клавиши Shift после 5 нажатий (значение по умолчанию)
# StickyShift -Enable

# Don't use AutoPlay for all media and devices
# Не использовать автозапуск для всех носителей и устройств
Autoplay -Disable

# Use AutoPlay for all media and devices (default value)
# Использовать автозапуск для всех носителей и устройств (значение по умолчанию)
# Autoplay -Enable

# Disable thumbnail cache removal
# Отключить удаление кэша миниатюр
# ThumbnailCacheRemoval -Disable

# Enable thumbnail cache removal (default value)
# Включить удаление кэша миниатюр (значение по умолчанию)
ThumbnailCacheRemoval -Enable

# Automatically saving my restartable apps when signing out and restart them after signing in
# Автоматически сохранять мои перезапускаемые приложения при выходе из системы и перезапускать их при повторном входе
SaveRestartableApps -Enable

# Turn off automatically saving my restartable apps when signing out and restart them after signing in (default value)
# Выключить автоматическое сохранение моих перезапускаемых приложений при выходе из системы и перезапускать их после выхода (значение по умолчанию)
# SaveRestartableApps -Disable

# Enable "Network Discovery" and "File and Printers Sharing" for workgroup networks
# Включить сетевое обнаружение и общий доступ к файлам и принтерам для рабочих групп
NetworkDiscovery -Enable

# Disable "Network Discovery" and "File and Printers Sharing" for workgroup networks (default value)
# Выключить сетевое обнаружение и общий доступ к файлам и принтерам для рабочих групп (значение по умолчанию)
# NetworkDiscovery -Disable

# Automatically adjust active hours for me based on daily usage
# Автоматически изменять период активности для этого устройства на основе действий
# ActiveHours -Automatically

# Manually adjust active hours for me based on daily usage (default value)
# Вручную изменять период активности для этого устройства на основе действий (значение по умолчанию)
# ActiveHours -Manually

# Restart this device as soon as possible when a restart is required to install an update
# Перезапускать это устройство как можно быстрее, если для установки обновления требуется перезагрузка
# RestartDeviceAfterUpdate -Enable

# Do not restart this device as soon as possible when a restart is required to install an update (default value)
# Не перезапускать это устройство как можно быстрее, если для установки обновления требуется перезагрузка (значение по умолчанию)
# RestartDeviceAfterUpdate -Disable

<#
	Register app, calculate hash, and associate with an extension with the "How do you want to open this" pop-up hidden
	Зарегистрировать приложение, вычислить хэш и ассоциировать его с расширением без всплывающего окна "Каким образом вы хотите открыть этот файл?"

	Set-Association -ProgramPath "C:\SumatraPDF.exe" -Extension .pdf -Icon "shell32.dll,100"
	Set-Association -ProgramPath "%ProgramFiles%\Notepad++\notepad++.exe" -Extension .txt -Icon "%ProgramFiles%\Notepad++\notepad++.exe,0"
#>
# Set-Association -ProgramPath "%ProgramFiles%\Notepad++\notepad++.exe" -Extension .txt -Icon "%ProgramFiles%\Notepad++\notepad++.exe,0"

<#
	Install the latest Microsoft Visual C++ Redistributable Packages 2015–2022 (x86/x64)
	Установить последнюю версию распространяемых пакетов Microsoft Visual C++ 2015–2022 (x86/x64)

	https://docs.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist
#>
InstallVCRedist

<#
	Install the latest .NET Desktop Runtime 6, 7 (x86/x64)
	Установить последнюю версию .NET Desktop Runtime 6 (x86/x64)

	https://dotnet.microsoft.com/en-us/download/dotnet
#>
InstallDotNetRuntimes

# Enable proxying only blocked sites from the unified registry of Roskomnadzor. The function is applicable for Russia only
# Включить проксирование только заблокированных сайтов из единого реестра Роскомнадзора. Функция применима только для России
# https://antizapret.prostovpn.org
#RKNBypass -Enable

# Disable proxying only blocked sites from the unified registry of Roskomnadzor (default value)
# Выключить проксирование только заблокированных сайтов из единого реестра Роскомнадзора (значение по умолчанию)
# https://antizapret.prostovpn.org
# RKNBypass -Disable

# List Microsoft Edge channels to prevent desktop shortcut creation upon its' update
# Перечислите каналы Microsoft Edge для предотвращения создания ярлыков на рабочем столе после его обновления
PreventEdgeShortcutCreation -Channels Stable, Beta, Dev, Canary

# Do not prevent desktop shortcut creation upon Microsoft Edge update (default value)
# Не предотвращать создание ярлыков на рабочем столе при обновлении Microsoft Edge (значение по умолчанию)
# PreventEdgeShortcutCreation -Disable
#endregion System

#region WSL
<#
	Enable Windows Subsystem for Linux (WSL), install the latest WSL Linux kernel version, and a Linux distribution using a pop-up form
	The "Receive updates for other Microsoft products" setting will enabled automatically to receive kernel updates

	Установить подсистему Windows для Linux (WSL), последний пакет обновления ядра Linux и дистрибутив Linux, используя всплывающую форму
	Параметр "При обновлении Windows получать обновления для других продуктов Майкрософт" будет включен автоматически в Центре обновлении Windows, чтобы получать обновления ядра
#>
# WSL
#endregion WSL

#region Start menu
# Hide recently added apps in the Start menu
# Скрывать недавно добавленные приложения в меню "Пуск"
#RecentlyAddedApps -Hide

# Show recently added apps in the Start menu (default value)
# Показывать недавно добавленные приложения в меню "Пуск" (значение по умолчанию)
# RecentlyAddedApps -Show

# Hide app suggestions in the Start menu
# Скрывать рекомендации в меню "Пуск"
AppSuggestions -Hide

# Show app suggestions in the Start menu (default value)
# Показывать рекомендации в меню "Пуск" (значение по умолчанию)
# AppSuggestions -Show

# Run the Windows PowerShell shortcut from the Start menu as Administrator
# Запускать ярлык Windows PowerShell в меню "Пуск" от имени Администратора
RunPowerShellShortcut -Elevated

# Run the Windows PowerShell shortcut from the Start menu as user (default value)
# Запускать ярлык Windows PowerShell в меню "Пуск" от имени пользователя (значение по умолчанию)
# RunPowerShellShortcut -NonElevated

<#
	Pin to Start the following shortcuts: Control Panel, Devices and Printers, PowerShell
	Valid shortcuts values: ControlPanel, DevicesPrinters and PowerShell

	Закрепить на начальном экране следующие ярлыки: Панель управления, Устройства и принтеры, PowerShell
	Валидные значения ярлыков: ControlPanel, DevicesPrinters, PowerShell
#>
PinToStart -Tiles ControlPanel, PowerShell

# Unpin all tiles first and pin necessary ones
# Открепить все ярлыки сначала и закрепить необходимые
# PinToStart -UnpinAll -Tiles ControlPanel, DevicesPrinters, PowerShell

# Unpin all the Start tiles
# Открепить все ярлыки от начального экрана
# PinToStart -UnpinAll
#endregion Start menu

#region Gaming
# Choose an app and set the "High performance" graphics performance for it. Only if you have a dedicated GPU
# Выбрать приложение и установить для него параметры производительности графики на "Высокая производительность". Только при наличии внешней видеокарты
#SetAppGraphicsPerformance

<#
	Turn on hardware-accelerated GPU scheduling. Restart needed
	Only if you have a dedicated GPU and WDDM verion is 2.7 or higher

	Включить планирование графического процессора с аппаратным ускорением. Необходима перезагрузка
	Только при наличии внешней видеокарты и WDDM версии 2.7 и выше
#>
#GPUScheduling -Enable

# Turn off hardware-accelerated GPU scheduling (default value). Restart needed
# Выключить планирование графического процессора с аппаратным ускорением (значение по умолчанию). Необходима перезагрузка
# GPUScheduling -Disable
#endregion Gaming

#region Scheduled tasks
<#
	Create the "Windows Cleanup" scheduled task for cleaning up Windows unused files and updates
	A native interactive toast notification pops up every 30 days. The task runs every 30 days

	Создать задачу "Windows Cleanup" по очистке неиспользуемых файлов и обновлений Windows в Планировщике заданий
	Нативный интерактивный тост всплывает каждые 30 дней. Задача выполняется каждые 30 дней
#>
#CleanupTask -Register

# Delete the "Windows Cleanup" and "Windows Cleanup Notification" scheduled tasks for cleaning up Windows unused files and updates
# Удалить задачи "Windows Cleanup" и "Windows Cleanup Notification" по очистке неиспользуемых файлов и обновлений Windows из Планировщика заданий
# CleanupTask -Delete

<#
	Create the "SoftwareDistribution" scheduled task for cleaning up the %SystemRoot%\SoftwareDistribution\Download folder
	The task will wait until the Windows Updates service finishes running. The task runs every 90 days

	Создать задачу "SoftwareDistribution" по очистке папки %SystemRoot%\SoftwareDistribution\Download в Планировщике заданий
	Задача будет ждать, пока служба обновлений Windows не закончит работу. Задача выполняется каждые 90 дней
#>
#SoftwareDistributionTask -Register

# Delete the "SoftwareDistribution" scheduled task for cleaning up the %SystemRoot%\SoftwareDistribution\Download folder
# Удалить задачу "SoftwareDistribution" по очистке папки %SystemRoot%\SoftwareDistribution\Download из Планировщика заданий
# SoftwareDistributionTask -Delete

<#
	Create the "Temp" scheduled task for cleaning up the %TEMP% folder
	Only files older than one day will be deleted. The task runs every 60 days

	Создать задачу "Temp" в Планировщике заданий по очистке папки %TEMP%
	Удаляться будут только файлы старше одного дня. Задача выполняется каждые 60 дней
#>
#TempTask -Register

# Delete the "Temp" scheduled task for cleaning up the %TEMP% folder
# Удалить задачу "Temp" по очистке папки %TEMP% из Планировщика заданий
# TempTask -Delete
#endregion Scheduled tasks

#region Microsoft Defender & Security
# Enable Microsoft Defender Exploit Guard network protection
# Включить защиту сети в Microsoft Defender Exploit Guard
NetworkProtection -Enable

# Disable Microsoft Defender Exploit Guard network protection (default value)
# Выключить защиту сети в Microsoft Defender Exploit Guard
# NetworkProtection -Disable

# Enable detection for potentially unwanted applications and block them
# Включить обнаружение потенциально нежелательных приложений и блокировать их
PUAppsDetection -Enable

# Disable detection for potentially unwanted applications and block them (default value)
# Выключить обнаружение потенциально нежелательных приложений и блокировать их (значение по умолчанию)
# PUAppsDetection -Disable

<#
	Enable sandboxing for Microsoft Defender
	There is a bug in KVM with QEMU: enabling this function causes VM to freeze up during the loading phase of Windows

	Включить песочницу для Microsoft Defender
	В KVM с QEMU присутствует баг: включение этой функции приводит ВМ к зависанию во время загрузки Windows
#>
#DefenderSandbox -Enable

# Disable sandboxing for Microsoft Defender (default value)
# Выключить песочницу для Microsoft Defender (значение по умолчанию)
# DefenderSandbox -Disable

# Dismiss Microsoft Defender offer in the Windows Security about signing in Microsoft account
# Отклонить предложение Microsoft Defender в "Безопасность Windows" о входе в аккаунт Microsoft
DismissMSAccount

# Dismiss Microsoft Defender offer in the Windows Security about turning on the SmartScreen filter for Microsoft Edge
# Отклонить предложение Microsoft Defender в "Безопасность Windows" включить фильтр SmartScreen для Microsoft Edge
DismissSmartScreenFilter

# Enable events auditing generated when a process is created (starts)
# Включить аудит событий, возникающих при создании или запуске процесса
#AuditProcess -Enable

# Disable events auditing generated when a process is created (starts) (default value)
# Выключить аудит событий, возникающих при создании или запуске процесса (значение по умолчанию)
# AuditProcess -Disable

<#
	Include command line in process creation events
	In order this feature to work events auditing (ProcessAudit -Enable) will be enabled

	Включать командную строку в событиях создания процесса
	Для того, чтобы работал данный функционал, будет включен аудит событий (AuditProcess -Enable)
#>
#CommandLineProcessAudit -Enable

# Do not include command line in process creation events (default value)
# Не включать командную строку в событиях создания процесса (значение по умолчанию)
# CommandLineProcessAudit -Disable

<#
	Create the "Process Creation" сustom view in the Event Viewer to log executed processes and their arguments
	In order this feature to work events auditing (AuditProcess -Enable) and command line (CommandLineProcessAudit -Enable) in process creation events will be enabled

	Создать настраиваемое представление "Создание процесса" в Просмотре событий для журналирования запускаемых процессов и их аргументов
	Для того, чтобы работал данный функционал, буден включен аудит событий (AuditProcess -Enable) и командной строки (CommandLineProcessAudit -Enable) в событиях создания процесса
#>
#EventViewerCustomView -Enable

# Remove the "Process Creation" custom view in the Event Viewer to log executed processes and their arguments (default value)
# Удалить настаиваемое представление "Создание процесса" в Просмотре событий для журналирования запускаемых процессов и их аргументов (значение по умолчанию)
# EventViewerCustomView -Disable

# Enable logging for all Windows PowerShell modules
# Включить ведение журнала для всех модулей Windows PowerShell
#PowerShellModulesLogging -Enable

# Disable logging for all Windows PowerShell modules (default value)
# Выключить ведение журнала для всех модулей Windows PowerShell (значение по умолчанию)
# PowerShellModulesLogging -Disable

# Enable logging for all PowerShell scripts input to the Windows PowerShell event log
# Включить ведение журнала для всех вводимых сценариев PowerShell в журнале событий Windows PowerShell
#PowerShellScriptsLogging -Enable

# Disable logging for all PowerShell scripts input to the Windows PowerShell event log (default value)
# Выключить ведение журнала для всех вводимых сценариев PowerShell в журнале событий Windows PowerShell (значение по умолчанию)
# PowerShellScriptsLogging -Disable

# Microsoft Defender SmartScreen doesn't marks downloaded files from the Internet as unsafe
# Microsoft Defender SmartScreen не помечает скачанные файлы из интернета как небезопасные
AppsSmartScreen -Disable

# Microsoft Defender SmartScreen marks downloaded files from the Internet as unsafe (default value)
# Microsoft Defender SmartScreen помечает скачанные файлы из интернета как небезопасные (значение по умолчанию)
# AppsSmartScreen -Enable

# Disable the Attachment Manager marking files that have been downloaded from the Internet as unsafe
# Выключить проверку Диспетчером вложений файлов, скачанных из интернета, как небезопасные
SaveZoneInformation -Disable

# Enable the Attachment Manager marking files that have been downloaded from the Internet as unsafe (default value)
# Включить проверку Диспетчера вложений файлов, скачанных из интернета как небезопасные (значение по умолчанию)
# SaveZoneInformation -Enable

<#
	Disable Windows Script Host
	Blocks WSH from executing .js and .vbs files

	Отключить Windows Script Host
	Блокирует запуск файлов .js и .vbs
#>
# WindowsScriptHost -Disable

# Enable Windows Script Host (default value)
# Включить Windows Script Host (значение по умолчанию)
# WindowsScriptHost -Enable

# Enable Windows Sandbox
# Включить Windows Sandbox
# WindowsSandbox -Enable

# Disable Windows Sandbox (default value)
# Выключить Windows Sandbox (значение по умолчанию)
# WindowsSandbox -Disable
#endregion Microsoft Defender & Security

#region Context menu
# Show the "Extract all" item in the Windows Installer (.msi) context menu
# Отобразить пункт "Извлечь все" в контекстное меню Windows Installer (.msi)
MSIExtractContext -Show

# Hide the "Extract all" item from the Windows Installer (.msi) context menu (default value)
# Скрыть пункт "Извлечь все" из контекстного меню Windows Installer (.msi) (значение по умолчанию)
# MSIExtractContext -Hide

# Show the "Install" item in the Cabinet (.cab) filenames extensions context menu
# Отобразить пункт "Установить" в контекстное меню .cab архивов
CABInstallContext -Show

# Hide the "Install" item from the Cabinet (.cab) filenames extensions context menu (default value)
# Скрыть пункт "Установить" из контекстного меню .cab архивов (значение по умолчанию)
# CABInstallContext -Hide

# Show the "Run as different user" item to the .exe filename extensions context menu
# Отобразить пункт "Запуск от имени другого пользователя" в контекстное меню .exe файлов
RunAsDifferentUserContext -Show

# Hide the "Run as different user" item from the .exe filename extensions context menu (default value)
# Скрыть пункт "Запуск от имени другого пользователя" из контекстное меню .exe файлов (значение по умолчанию)
# RunAsDifferentUserContext -Hide

# Hide the "Cast to Device" item from the media files and folders context menu
# Скрыть пункт "Передать на устройство" из контекстного меню медиа-файлов и папок
CastToDeviceContext -Hide

# Show the "Cast to Device" item in the media files and folders context menu (default value)
# Отобразить пункт "Передать на устройство" в контекстном меню медиа-файлов и папок (значение по умолчанию)
# CastToDeviceContext -Show

# Hide the "Share" item from the context menu
# Скрыть пункт "Отправить" (поделиться) из контекстного меню
ShareContext -Hide

# Show the "Share" item in the context menu (default value)
# Отобразить пункт "Отправить" (поделиться) в контекстном меню (значение по умолчанию)
# ShareContext -Show

# Hide the "Edit with Paint 3D" item from the media files context menu
# Скрыть пункт "Изменить с помощью Paint 3D" из контекстного меню медиа-файлов
EditWithPaint3DContext -Hide

# Show the "Edit with Paint 3D" item in the media files context menu (default value)
# Отобразить пункт "Изменить с помощью Paint 3D" в контекстном меню медиа-файлов (значение по умолчанию)
# EditWithPaint3DContext -Show

# Hide the "Edit" item from the images context menu
# Скрыть пункт "Изменить" из контекстного меню изображений
#ImagesEditContext -Hide

# Show the "Edit" item in images context menu (default value)
# Отобразить пункт "Изменить" в контекстном меню изображений (значение по умолчанию)
# ImagesEditContext -Show

# Hide the "Print" item from the .bat and .cmd context menu
# Скрыть пункт "Печать" из контекстного меню .bat и .cmd файлов
PrintCMDContext -Hide

# Show the "Print" item in the .bat and .cmd context menu (default value)
# Отобразить пункт "Печать" в контекстном меню .bat и .cmd файлов (значение по умолчанию)
# PrintCMDContext -Show

# Hide the "Include in Library" item from the folders and drives context menu
# Скрыть пункт "Добавить в библиотеку" из контекстного меню папок и дисков
IncludeInLibraryContext -Hide

# Show the "Include in Library" item in the folders and drives context menu (default value)
# Отобразить пункт "Добавить в библиотеку" в контекстном меню папок и дисков (значение по умолчанию)
# IncludeInLibraryContext -Show

# Hide the "Send to" item from the folders context menu
# Скрыть пункт "Отправить" из контекстного меню папок
#SendToContext -Hide

# Show the "Send to" item in the folders context menu (default value)
# Отобразить пункт "Отправить" в контекстном меню папок (значение по умолчанию)
# SendToContext -Show

# Hide the "Bitmap image" item from the "New" context menu
# Скрыть пункт "Точечный рисунок" из контекстного меню "Создать"
BitmapImageNewContext -Hide

# Show the "Bitmap image" item to the "New" context menu (default value)
# Отобразить пункт "Точечный рисунок" в контекстного меню "Создать" (значение по умолчанию)
# BitmapImageNewContext -Show

# Hide the "Rich Text Document" item from the "New" context menu
# Скрыть пункт "Документ в формате RTF" из контекстного меню "Создать"
RichTextDocumentNewContext -Hide

# Show the "Rich Text Document" item to the "New" context menu (default value)
# Отобразить пункт "Документ в формате RTF" в контекстного меню "Создать" (значение по умолчанию)
# RichTextDocumentNewContext -Show

# Hide the "Compressed (zipped) Folder" item from the "New" context menu
# Скрыть пункт "Сжатая ZIP-папка" из контекстного меню "Создать"
CompressedFolderNewContext -Hide

# Show the "Compressed (zipped) Folder" item to the "New" context menu (default value)
# Отобразить пункт "Сжатая ZIP-папка" в контекстном меню "Создать" (значение по умолчанию)
# CompressedFolderNewContext -Show

# Enable the "Open", "Print", and "Edit" context menu items for more than 15 items selected
# Включить элементы контекстного меню "Открыть", "Изменить" и "Печать" при выделении более 15 элементов
MultipleInvokeContext -Enable

# Disable the "Open", "Print", and "Edit" context menu items for more than 15 items selected (default value)
# Отключить элементы контекстного меню "Открыть", "Изменить" и "Печать" при выделении более 15 элементов (значение по умолчанию)
# MultipleInvokeContext -Disable
#endregion Context menu

#region Update Policies
<#
	Display all policy registry keys (even manually created ones) in the Local Group Policy Editor snap-in (gpedit.msc)
	This can take up to 30 minutes, depending on on the number of policies created in the registry and your system resources

	Отобразить все политики реестра (даже созданные вручную) в оснастке Редактора локальной групповой политики (gpedit.msc)
	Это может занять до 30 минут в зависимости от количества политик, созданных в реестре, и мощности вашей системы
#>
# UpdateLGPEPolicies
#endregion Update Policies

<#
	Simulate pressing F5 to refresh the desktop
	Refresh desktop icons, environment variables, taskbar
	Restart the Start menu
	Please, do not comment out this function

	Симулировать нажатие F5 для обновления рабочего стола
	Обновить иконки рабочего стола, переменные среды, панель задач
	Перезапустить меню "Пуск"
	Пожалуйста, не комментируйте данную функцию
#>
RefreshEnvironment

<#
	Errors output
	Please, do not comment out this function

	Вывод ошибок
	Пожалуйста, не комментируйте данную функцию
#>
Errors

# SIG # Begin signature block
# MIIblQYJKoZIhvcNAQcCoIIbhjCCG4ICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUCaiKaPFrfiluKSmerYKcbK7P
# fmugghYNMIIDAjCCAeqgAwIBAgIQIFLqwiyJO7RAePJJC7HSFzANBgkqhkiG9w0B
# AQsFADAZMRcwFQYDVQQDDA5Tb3BoaWEgUHJvamVjdDAeFw0yMzAxMzAxODE1NTJa
# Fw0yNTAxMzAxODI1NDFaMBkxFzAVBgNVBAMMDlNvcGhpYSBQcm9qZWN0MIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArMU3ouDQOF0pB3BZ54Q4mwHE1q1j
# Fcy6THBKsDZThfT50PT0UzTLbAYqMAK2zW9RzP8SV4OICS/gMslNWACPYPAN4/PS
# Gpuj497tXJIN6W3KfTdDn6AiA/1DWGSat+U6t/ABG/XrIWMrGIaUi1o8UoJ2QNW9
# WQvIV298/iKskbP2Er9v8NzGHYSj7RlYjKHhh6hhJhahVoCJeNtgKmygaQ7n70X7
# 73PQQ9blYWfUshayX5E9LoeiCj7ae1pi4k6UtQSw4X2p5cT6Z8Lq4hHRF5SH3liE
# PPakNphc1jwtrx6eTLDY+CVCFBnB5itp/ruor+plKYdPJTMcecjGoldMlQIDAQAB
# o0YwRDAOBgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwHQYDVR0O
# BBYEFAUgXv+SOh2j4uT8+0rqGVak9XaSMA0GCSqGSIb3DQEBCwUAA4IBAQCJnVZm
# /6GoE5JgItZ2bwFKeHuCtrxLp/jXP6J4L7ydLYwCHHmVo1QhCjv1WNfnv8xUoLls
# /bDeRhSJfDzeydqq8RGYaAglq05m4UUTRB2YL/lleELL/VMipdA3LHHwvinstmLO
# Z/DSRAtH/W8DxFtAfQpltZXYbcH6ZPsF/bsbq6+o/71LqJu9y1Dk4HPEU7yKKo5Q
# Z3MHdckJDMuGmZCXXcRWosQeQoa3tbeqZ5dVSJ9tTVN2mROSN9y4fdhsP8bqrwxU
# Kfm0JZeXQSmioscjyIuUtCDgoryyHL9ul+MS15Cv86U+kOgVbXtVXXc0ZLiarDeR
# +78bd+DrQXvNonpgMIIFjTCCBHWgAwIBAgIQDpsYjvnQLefv21DiCEAYWjANBgkq
# hkiG9w0BAQwFADBlMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5j
# MRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBB
# c3N1cmVkIElEIFJvb3QgQ0EwHhcNMjIwODAxMDAwMDAwWhcNMzExMTA5MjM1OTU5
# WjBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQL
# ExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQDExhEaWdpQ2VydCBUcnVzdGVkIFJv
# b3QgRzQwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC/5pBzaN675F1K
# PDAiMGkz7MKnJS7JIT3yithZwuEppz1Yq3aaza57G4QNxDAf8xukOBbrVsaXbR2r
# snnyyhHS5F/WBTxSD1Ifxp4VpX6+n6lXFllVcq9ok3DCsrp1mWpzMpTREEQQLt+C
# 8weE5nQ7bXHiLQwb7iDVySAdYyktzuxeTsiT+CFhmzTrBcZe7FsavOvJz82sNEBf
# sXpm7nfISKhmV1efVFiODCu3T6cw2Vbuyntd463JT17lNecxy9qTXtyOj4DatpGY
# QJB5w3jHtrHEtWoYOAMQjdjUN6QuBX2I9YI+EJFwq1WCQTLX2wRzKm6RAXwhTNS8
# rhsDdV14Ztk6MUSaM0C/CNdaSaTC5qmgZ92kJ7yhTzm1EVgX9yRcRo9k98FpiHaY
# dj1ZXUJ2h4mXaXpI8OCiEhtmmnTK3kse5w5jrubU75KSOp493ADkRSWJtppEGSt+
# wJS00mFt6zPZxd9LBADMfRyVw4/3IbKyEbe7f/LVjHAsQWCqsWMYRJUadmJ+9oCw
# ++hkpjPRiQfhvbfmQ6QYuKZ3AeEPlAwhHbJUKSWJbOUOUlFHdL4mrLZBdd56rF+N
# P8m800ERElvlEFDrMcXKchYiCd98THU/Y+whX8QgUWtvsauGi0/C1kVfnSD8oR7F
# wI+isX4KJpn15GkvmB0t9dmpsh3lGwIDAQABo4IBOjCCATYwDwYDVR0TAQH/BAUw
# AwEB/zAdBgNVHQ4EFgQU7NfjgtJxXWRM3y5nP+e6mK4cD08wHwYDVR0jBBgwFoAU
# Reuir/SSy4IxLVGLp6chnfNtyA8wDgYDVR0PAQH/BAQDAgGGMHkGCCsGAQUFBwEB
# BG0wazAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEMGCCsG
# AQUFBzAChjdodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1
# cmVkSURSb290Q0EuY3J0MEUGA1UdHwQ+MDwwOqA4oDaGNGh0dHA6Ly9jcmwzLmRp
# Z2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcmwwEQYDVR0gBAow
# CDAGBgRVHSAAMA0GCSqGSIb3DQEBDAUAA4IBAQBwoL9DXFXnOF+go3QbPbYW1/e/
# Vwe9mqyhhyzshV6pGrsi+IcaaVQi7aSId229GhT0E0p6Ly23OO/0/4C5+KH38nLe
# JLxSA8hO0Cre+i1Wz/n096wwepqLsl7Uz9FDRJtDIeuWcqFItJnLnU+nBgMTdydE
# 1Od/6Fmo8L8vC6bp8jQ87PcDx4eo0kxAGTVGamlUsLihVo7spNU96LHc/RzY9Hda
# XFSMb++hUD38dglohJ9vytsgjTVgHAIDyyCwrFigDkBjxZgiwbJZ9VVrzyerbHbO
# byMt9H5xaiNrIv8SuFQtJ37YOtnwtoeW/VvRXKwYw02fc7cBqZ9Xql4o4rmUMIIG
# rjCCBJagAwIBAgIQBzY3tyRUfNhHrP0oZipeWzANBgkqhkiG9w0BAQsFADBiMQsw
# CQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cu
# ZGlnaWNlcnQuY29tMSEwHwYDVQQDExhEaWdpQ2VydCBUcnVzdGVkIFJvb3QgRzQw
# HhcNMjIwMzIzMDAwMDAwWhcNMzcwMzIyMjM1OTU5WjBjMQswCQYDVQQGEwJVUzEX
# MBUGA1UEChMORGlnaUNlcnQsIEluYy4xOzA5BgNVBAMTMkRpZ2lDZXJ0IFRydXN0
# ZWQgRzQgUlNBNDA5NiBTSEEyNTYgVGltZVN0YW1waW5nIENBMIICIjANBgkqhkiG
# 9w0BAQEFAAOCAg8AMIICCgKCAgEAxoY1BkmzwT1ySVFVxyUDxPKRN6mXUaHW0oPR
# nkyibaCwzIP5WvYRoUQVQl+kiPNo+n3znIkLf50fng8zH1ATCyZzlm34V6gCff1D
# tITaEfFzsbPuK4CEiiIY3+vaPcQXf6sZKz5C3GeO6lE98NZW1OcoLevTsbV15x8G
# ZY2UKdPZ7Gnf2ZCHRgB720RBidx8ald68Dd5n12sy+iEZLRS8nZH92GDGd1ftFQL
# IWhuNyG7QKxfst5Kfc71ORJn7w6lY2zkpsUdzTYNXNXmG6jBZHRAp8ByxbpOH7G1
# WE15/tePc5OsLDnipUjW8LAxE6lXKZYnLvWHpo9OdhVVJnCYJn+gGkcgQ+NDY4B7
# dW4nJZCYOjgRs/b2nuY7W+yB3iIU2YIqx5K/oN7jPqJz+ucfWmyU8lKVEStYdEAo
# q3NDzt9KoRxrOMUp88qqlnNCaJ+2RrOdOqPVA+C/8KI8ykLcGEh/FDTP0kyr75s9
# /g64ZCr6dSgkQe1CvwWcZklSUPRR8zZJTYsg0ixXNXkrqPNFYLwjjVj33GHek/45
# wPmyMKVM1+mYSlg+0wOI/rOP015LdhJRk8mMDDtbiiKowSYI+RQQEgN9XyO7ZONj
# 4KbhPvbCdLI/Hgl27KtdRnXiYKNYCQEoAA6EVO7O6V3IXjASvUaetdN2udIOa5kM
# 0jO0zbECAwEAAaOCAV0wggFZMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYE
# FLoW2W1NhS9zKXaaL3WMaiCPnshvMB8GA1UdIwQYMBaAFOzX44LScV1kTN8uZz/n
# upiuHA9PMA4GA1UdDwEB/wQEAwIBhjATBgNVHSUEDDAKBggrBgEFBQcDCDB3Bggr
# BgEFBQcBAQRrMGkwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNv
# bTBBBggrBgEFBQcwAoY1aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lD
# ZXJ0VHJ1c3RlZFJvb3RHNC5jcnQwQwYDVR0fBDwwOjA4oDagNIYyaHR0cDovL2Ny
# bDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZFJvb3RHNC5jcmwwIAYDVR0g
# BBkwFzAIBgZngQwBBAIwCwYJYIZIAYb9bAcBMA0GCSqGSIb3DQEBCwUAA4ICAQB9
# WY7Ak7ZvmKlEIgF+ZtbYIULhsBguEE0TzzBTzr8Y+8dQXeJLKftwig2qKWn8acHP
# HQfpPmDI2AvlXFvXbYf6hCAlNDFnzbYSlm/EUExiHQwIgqgWvalWzxVzjQEiJc6V
# aT9Hd/tydBTX/6tPiix6q4XNQ1/tYLaqT5Fmniye4Iqs5f2MvGQmh2ySvZ180HAK
# fO+ovHVPulr3qRCyXen/KFSJ8NWKcXZl2szwcqMj+sAngkSumScbqyQeJsG33irr
# 9p6xeZmBo1aGqwpFyd/EjaDnmPv7pp1yr8THwcFqcdnGE4AJxLafzYeHJLtPo0m5
# d2aR8XKc6UsCUqc3fpNTrDsdCEkPlM05et3/JWOZJyw9P2un8WbDQc1PtkCbISFA
# 0LcTJM3cHXg65J6t5TRxktcma+Q4c6umAU+9Pzt4rUyt+8SVe+0KXzM5h0F4ejjp
# nOHdI/0dKNPH+ejxmF/7K9h+8kaddSweJywm228Vex4Ziza4k9Tm8heZWcpw8De/
# mADfIBZPJ/tgZxahZrrdVcA6KYawmKAr7ZVBtzrVFZgxtGIJDwq9gdkT/r+k0fNX
# 2bwE+oLeMt8EifAAzV3C+dAjfwAL5HYCJtnwZXZCpimHCUcr5n8apIUP/JiW9lVU
# Kx+A+sDyDivl1vupL0QVSucTDh3bNzgaoSv27dZ8/DCCBsAwggSooAMCAQICEAxN
# aXJLlPo8Kko9KQeAPVowDQYJKoZIhvcNAQELBQAwYzELMAkGA1UEBhMCVVMxFzAV
# BgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYDVQQDEzJEaWdpQ2VydCBUcnVzdGVk
# IEc0IFJTQTQwOTYgU0hBMjU2IFRpbWVTdGFtcGluZyBDQTAeFw0yMjA5MjEwMDAw
# MDBaFw0zMzExMjEyMzU5NTlaMEYxCzAJBgNVBAYTAlVTMREwDwYDVQQKEwhEaWdp
# Q2VydDEkMCIGA1UEAxMbRGlnaUNlcnQgVGltZXN0YW1wIDIwMjIgLSAyMIICIjAN
# BgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAz+ylJjrGqfJru43BDZrboegUhXQz
# Gias0BxVHh42bbySVQxh9J0Jdz0Vlggva2Sk/QaDFteRkjgcMQKW+3KxlzpVrzPs
# YYrppijbkGNcvYlT4DotjIdCriak5Lt4eLl6FuFWxsC6ZFO7KhbnUEi7iGkMiMbx
# vuAvfTuxylONQIMe58tySSgeTIAehVbnhe3yYbyqOgd99qtu5Wbd4lz1L+2N1E2V
# hGjjgMtqedHSEJFGKes+JvK0jM1MuWbIu6pQOA3ljJRdGVq/9XtAbm8WqJqclUeG
# hXk+DF5mjBoKJL6cqtKctvdPbnjEKD+jHA9QBje6CNk1prUe2nhYHTno+EyREJZ+
# TeHdwq2lfvgtGx/sK0YYoxn2Off1wU9xLokDEaJLu5i/+k/kezbvBkTkVf826uV8
# MefzwlLE5hZ7Wn6lJXPbwGqZIS1j5Vn1TS+QHye30qsU5Thmh1EIa/tTQznQZPpW
# z+D0CuYUbWR4u5j9lMNzIfMvwi4g14Gs0/EH1OG92V1LbjGUKYvmQaRllMBY5eUu
# KZCmt2Fk+tkgbBhRYLqmgQ8JJVPxvzvpqwcOagc5YhnJ1oV/E9mNec9ixezhe7nM
# ZxMHmsF47caIyLBuMnnHC1mDjcbu9Sx8e47LZInxscS451NeX1XSfRkpWQNO+l3q
# RXMchH7XzuLUOncCAwEAAaOCAYswggGHMA4GA1UdDwEB/wQEAwIHgDAMBgNVHRMB
# Af8EAjAAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMIMCAGA1UdIAQZMBcwCAYGZ4EM
# AQQCMAsGCWCGSAGG/WwHATAfBgNVHSMEGDAWgBS6FtltTYUvcyl2mi91jGogj57I
# bzAdBgNVHQ4EFgQUYore0GH8jzEU7ZcLzT0qlBTfUpwwWgYDVR0fBFMwUTBPoE2g
# S4ZJaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZEc0UlNB
# NDA5NlNIQTI1NlRpbWVTdGFtcGluZ0NBLmNybDCBkAYIKwYBBQUHAQEEgYMwgYAw
# JAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBYBggrBgEFBQcw
# AoZMaHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZEc0
# UlNBNDA5NlNIQTI1NlRpbWVTdGFtcGluZ0NBLmNydDANBgkqhkiG9w0BAQsFAAOC
# AgEAVaoqGvNG83hXNzD8deNP1oUj8fz5lTmbJeb3coqYw3fUZPwV+zbCSVEseIhj
# VQlGOQD8adTKmyn7oz/AyQCbEx2wmIncePLNfIXNU52vYuJhZqMUKkWHSphCK1D8
# G7WeCDAJ+uQt1wmJefkJ5ojOfRu4aqKbwVNgCeijuJ3XrR8cuOyYQfD2DoD75P/f
# nRCn6wC6X0qPGjpStOq/CUkVNTZZmg9U0rIbf35eCa12VIp0bcrSBWcrduv/mLIm
# lTgZiEQU5QpZomvnIj5EIdI/HMCb7XxIstiSDJFPPGaUr10CU+ue4p7k0x+GAWSc
# AMLpWnR1DT3heYi/HAGXyRkjgNc2Wl+WFrFjDMZGQDvOXTXUWT5Dmhiuw8nLw/ub
# E19qtcfg8wXDWd8nYiveQclTuf80EGf2JjKYe/5cQpSBlIKdrAqLxksVStOYkEVg
# M4DgI974A6T2RUflzrgDQkfoQTZxd639ouiXdE4u2h4djFrIHprVwvDGIqhPm73Y
# HJpRxC+a9l+nJ5e6li6FV8Bg53hWf2rvwpWaSxECyIKcyRoFfLpxtU56mWz06J7U
# WpjIn7+NuxhcQ/XQKujiYu54BNu90ftbCqhwfvCXhHjjCANdRyxjqCU4lwHSPzra
# 5eX25pvcfizM/xdMTQCi2NYBDriL7ubgclWJLCcZYfZ3AYwxggTyMIIE7gIBATAt
# MBkxFzAVBgNVBAMMDlNvcGhpYSBQcm9qZWN0AhAgUurCLIk7tEB48kkLsdIXMAkG
# BSsOAwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJ
# AzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMG
# CSqGSIb3DQEJBDEWBBQhx8yTrw00d//KZQEV54nSUFqXAjANBgkqhkiG9w0BAQEF
# AASCAQAplV80mdAIlQ4NavF3SNePIFfwuz93bV61yTME0izVMs5JIpGmbQj2nsix
# K55HFTMoLDQDULPlG7I/MaTULIrgJjQqewKH1l4yMRcPMLLhAr5crWxNte55NtGm
# tY2dj3q5Rm13otao52TQVS9ycmiIwRe8TaVoUOQ2Agbpa3dkzYmCXcLdLFZJzY6L
# oajATA7EdL8nHByHXXUs4VKcghvZnbmMotmGiTbLDmqwnHBBkbv0Pa45tuAxkIPt
# U7Axu06DD+FgNkwEDXnETnlacw9RZJcMfZ+wllfX9WnEHkaRfKeaXMyhYMa4cGmC
# TtOZs01leazjsOA/rAV402fe/2jNoYIDIDCCAxwGCSqGSIb3DQEJBjGCAw0wggMJ
# AgEBMHcwYzELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTsw
# OQYDVQQDEzJEaWdpQ2VydCBUcnVzdGVkIEc0IFJTQTQwOTYgU0hBMjU2IFRpbWVT
# dGFtcGluZyBDQQIQDE1pckuU+jwqSj0pB4A9WjANBglghkgBZQMEAgEFAKBpMBgG
# CSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDEzMDE4
# MjU1NVowLwYJKoZIhvcNAQkEMSIEICQMHHPVUUI4/WqlYzKbbkZcehJvO881F4Yc
# qIwU0+4lMA0GCSqGSIb3DQEBAQUABIICABD9FFPotHHRdVDZ6zbuFTYsfeMqq8dJ
# nQeGYFoHFMHckrpXg6o2Z8gVZPgSk64G+y2R0D+6XhWM+KfUidfdTy5JTO4tObVj
# PHu1732DblnyOy/tEDFxrYwywCrWN2UvFiNzWc45B/mrrBrC8WUxTC9T/ZpQRRGD
# l4mF3eDluSlbsVODzTihujXkSs3UekDBdS2naaB8xqAcYiSKt1gHZ8ctRIXptZ5u
# RusafssZZbWMhJmfW+H0Fyj8CYrNEuJ9N4tXRoQO0d1Z1p28DkvIL+dHurOwfY2t
# dQmIlGeRpDQgok0er1lzBXrFH6PIoG+bxyBV2pH2Bg9f9USiMC++nBpnwgCadyph
# nw7DHHRK3ADS8gvP0RZfacc/n04Re9eZeL8HXS1mPX+T4BqJG1ADb24lv39DOjAM
# Zo766ZPynaIBpoMY7NfXlYX45Cqt/sLAOI1f6osusU5vFm2iaINoQbnJvfCNPP0q
# F9U3rXfknZygq3mwvnMjHBHfqqZU3i36d3DjeBmKGgp0Wgj2do6KKGagoci24wOP
# SZtsM7aqRgMB3vcRd/w6GxHu+J/E+xcKJFBvy0MK4SrhuBe+uz/2GapBLHBGlJvk
# HZl4PFYLNMTVe6K39PDNb+kcnnNxx24CopuCRRVQ+bxDcoollHQJX6ZRtVNwrKQJ
# 9iRsH7weuysP
# SIG # End signature block
