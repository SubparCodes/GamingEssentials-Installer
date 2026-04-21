# ============================================
# Game Launcher + Utility Installer Script
# Categories + Hidden URLs + Silent Installs
# ============================================

# Define apps with categories + silent switches
$apps = @(
    # Launchers
    @{ Name="Steam"; Url="https://cdn.fastly.steamstatic.com/client/installer/SteamSetup.exe"; Category="Launchers"; Silent="/S" }
    @{ Name="Ubisoft Connect"; Url="https://ubi.li/4vxt9"; Category="Launchers"; Silent="/S" }
    @{ Name="Epic Games"; Url="https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/installer/download/EpicGamesLauncherInstaller.msi"; Category="Launchers"; Silent="/quiet" }
    @{ Name="Battle.net"; Url="https://downloader.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe"; Category="Launchers"; Silent="--silent" }
    @{ Name="GOG Galaxy"; Url="https://webinstallers.gog-statics.com/download/GOG_Galaxy_2.0.exe"; Category="Launchers"; Silent="/VERYSILENT" }
    @{ Name="EA App"; Url="https://origin-a.akamaihd.net/EA-Desktop-Client-Download/installer-releases/EAappInstaller.exe"; Category="Launchers"; Silent="--silent" }
    @{ Name="Xbox App"; Url="https://aka.ms/xboxappdownload"; Category="Launchers"; Silent=$null }
    @{ Name="Riot Client"; Url="https://client.riotgames.com/install"; Category="Launchers"; Silent=$null }
    @{ Name="Rockstar Games"; Url="https://gamedownloads.rockstargames.com/public/installer/Rockstar-Games-Launcher.exe"; Category="Launchers"; Silent="/S" }
    @{ Name="Amazon Games"; Url="https://download.amazongames.com/AmazonGamesSetup.exe"; Category="Launchers"; Silent="/S" }
    @{ Name="Itch.io"; Url="https://itch.io/app/download?platform=windows"; Category="Launchers"; Silent="/S" }
    @{ Name="Medal"; Url="https://medal.tv/desktop/download/win"; Category="Launchers"; Silent="--silent" }

    # Social
    @{ Name="Discord"; Url="https://discord.com/api/download?platform=win"; Category="Social"; Silent="--silent" }

    # Streaming
    @{ Name="OBS Studio"; Url="https://cdn-fastly.obsproject.com/downloads/OBS-Studio-30.0.2-Full-Installer-x64.exe"; Category="Streaming"; Silent="/S" }

    # GPU / Performance
    @{ Name="MSI Afterburner"; Url="https://download.msi.com/uti_exe/vga/MSIAfterburnerSetup.zip"; Category="GPU / Performance"; Silent=$null }
    @{ Name="NVIDIA GeForce Experience"; Url="https://us.download.nvidia.com/GFE/GFEClient/3.27.0.120/GeForce_Experience_v3.27.0.120.exe"; Category="GPU / Performance"; Silent="/S" }
    @{ Name="AMD Adrenalin"; Url="https://drivers.amd.com/drivers/installer/amd-software-adrenalin-edition.exe"; Category="GPU / Performance"; Silent="/S" }

    # Utilities
    @{ Name="7-Zip"; Url="https://www.7-zip.org/a/7z2408-x64.exe"; Category="Utilities"; Silent="/S" }
    @{ Name="WinRAR"; Url="https://www.win-rar.com/fileadmin/winrar-versions/winrar/winrar-x64-701.exe"; Category="Utilities"; Silent="/S" }
    @{ Name="Notepad++"; Url="https://github.com/notepad-plus-plus/notepad-plus-plus/releases/latest/download/npp.8.6.2.Installer.x64.exe"; Category="Utilities"; Silent="/S" }

    # Peripherals
    @{ Name="Razer Synapse"; Url="https://rzr.to/synapse-3-pc-download"; Category="Peripherals"; Silent=$null }
    @{ Name="Logitech G Hub"; Url="https://download01.logi.com/web/ftp/pub/techsupport/gaming/lghub_installer.exe"; Category="Peripherals"; Silent="/S" }
)

# Convert to objects for Out-GridView (URL + Silent hidden)
$choices = $apps | ForEach-Object {
    [PSCustomObject]@{
        App       = $_.Name
        Category  = $_.Category
        HiddenUrl = $_.Url
        Silent    = $_.Silent
    }
}

# Show only App + Category in the popup
$selected = $choices |
    Out-GridView -Title "Select Apps to Install" -PassThru

if (-not $selected) {
    Write-Host "No apps selected. Exiting."
    exit
}

foreach ($item in $selected) {

    $name   = $item.App
    $url    = $item.HiddenUrl
    $silent = $item.Silent

    $outfile = "$env:USERPROFILE\Downloads\$name-Installer.exe"

    Write-Host "Downloading $name..."
    Invoke-WebRequest -Uri $url -OutFile $outfile -Headers @{ "User-Agent" = "Mozilla/5.0" }

    if ($silent) {
        Write-Host "Silently installing $name..."
        Start-Process $outfile -ArgumentList $silent -Wait
    }
    else {
        Write-Host "$name does not support silent install. Launching normally..."
        Start-Process $outfile
    }
}

Write-Host "All selected installers have been launched."
