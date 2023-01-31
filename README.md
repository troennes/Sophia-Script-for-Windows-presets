# Sophia-Script-for-Windows-presets

Download Sophia and this preset, then run it:

```powershell
irm script.sophi.app | iex
wget https://raw.githubusercontent.com/troennes/Sophia-Script-for-Windows-presets/main/hacking-preset.ps1 -UseBasicParsing -OutFile "Sophia.ps1"
Move-Item "Sophia.ps1" ".\Downloads\Sophia*\Sophia.ps1" -Force
Set-Location ".\Downloads\Sophia*\"
.\Sophia.ps1
```
