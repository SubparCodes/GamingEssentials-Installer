# ============================================
# Game Launcher + Utility Installer Script
# ============================================

# Define apps with categories
$apps = @(
    # Launchers
    @{ Name="Steam"; Url="https://cdn.fastly.steamstatic.com/client/installer/SteamSetup.exe"; Category="Launchers" }
    @{ Name="Ubisoft Connect"; Url="https://ubi.li/4vxt9"; Category="Launchers" }
    @{ Name="Epic Games"; Url="https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/installer/download/EpicGamesLauncherInstaller.msi"; Category="Launchers" }
    @{ Name="Battle.net"; Url="https://downloader.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe"; Category="Launchers" }
    @{ Name="GOG Galaxy"; Url="https://webinstallers.gog-statics.com/download/GOG_Galaxy_2.0.exe"; Category="Launchers" }
    @{ Name="EA App"; Url="https://origin-a.akamaihd.net/EA-Desktop-Client-Download/installer-releases/EAappInstaller.exe"; Category="Launchers" }
    @{ Name="Xbox App"; Url="https://aka.ms/xboxappdownload"; Category="Launchers" }
    @{ Name="Riot Client"; Url="https://client.riotgames.com/install"; Category="Launchers" }
    @{ Name="Rockstar Games"; Url="https://gamedownloads.rockstargames.com/public/installer/Rockstar-Games-Launcher.exe"; Category="Launchers" }
    @{ Name="Amazon Games"; Url="https://download.amazongames.com/AmazonGamesSetup.exe"; Category="Launchers" }
    @{ Name="Itch.io"; Url="https://itch.io/app/download?platform=windows"; Category="Launchers" }
    @{ Name="Medal"; Url="https://medal.tv/desktop/download/win"; Category="Launchers" }

    # Social
    @{ Name="Discord"; Url="https://discord.com/api/download?platform=win"; Category="Social" }

    # Streaming
    @{ Name="OBS Studio"; Url="https://cdn-fastly.obsproject.com/downloads/OBS-Studio-30.0.2-Full-Installer-x64.exe"; Category="Streaming" }

    # GPU / Performance
    @{ Name="MSI Afterburner"; Url="https://download.msi.com/uti_exe/vga/MSIAfterburnerSetup.zip"; Category="GPU / Performance" }
    @{ Name="NVIDIA GeForce Experience"; Url="https://us.download.nvidia.com/GFE/GFEClient/3.27.0.120/GeForce_Experience_v3.27.0.120.exe"; Category="GPU / Performance" }
    @{ Name="AMD Adrenalin"; Url="https://drivers.amd.com/drivers/installer/amd-software-adrenalin-edition.exe"; Category="GPU / Performance" }

    # Utilities
    @{ Name="7-Zip"; Url="https://www.7-zip.org/a/7z2408-x64.exe"; Category="Utilities" }
    @{ Name="WinRAR"; Url="https://www.win-rar.com/fileadmin/winrar-versions/winrar/winrar-x64-701.exe"; Category="Utilities" }
    @{ Name="Notepad++"; Url="https://github.com/notepad-plus-plus/notepad-plus-plus/releases/latest/download/npp.8.6.2.Installer.x64.exe"; Category="Utilities" }

    # Peripherals
    @{ Name="Razer Synapse"; Url="https://rzr.to/synapse-3-pc-download"; Category="Peripherals" }
    @{ Name="Logitech G Hub"; Url="https://download01.logi.com/web/ftp/pub/techsupport/gaming/lghub_installer.exe"; Category="Peripherals" }
)

# Convert to objects for Out-GridView (URL + Silent hidden)
$choices = $apps | ForEach-Object {
    [PSCustomObject]@{
        App       = $_.Name
        Category  = $_.Category
        Url = $_.Url
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
    $url    = $item.Url

    $outfile = "$env:USERPROFILE\Downloads\$name-Installer.exe"

    Write-Host "Downloading $name..."
    Invoke-WebRequest -Uri $url -OutFile $outfile -Headers @{ "User-Agent" = "Mozilla/5.0" }
}

Write-Host "All selected installers have been launched."
