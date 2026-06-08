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
    @{ Name="Rockstar Games"; Url="https://gamedownloads.rockstargames.com/public/installer/Rockstar-Games-Launcher.exe"; Category="Launchers" }
    @{ Name="Amazon Games"; Url="https://download.amazongames.com/AmazonGamesSetup.exe"; Category="Launchers" }
    @{ Name="Itch.io"; Url="https://itch.io/app/download?platform=windows"; Category="Launchers" }

    # Social
    @{ Name="Discord"; Url="https://discord.com/api/download?platform=win"; Category="Social" }
    @{ Name="TeamSpeak 6"; Url="https://files.teamspeak-services.com/pre_releases/client/6.0.0-beta4.1/teamspeak-client.msi"; Category="Social" }

    # Streaming
    @{ Name="OBS Studio"; Url="https://cdn-fastly.obsproject.com/downloads/OBS-Studio-30.0.2-Full-Installer-x64.exe"; Category="Streaming" }

    # GPU / Performance
    @{ Name="MSI Afterburner"; Url="https://download.msi.com/uti_exe/vga/MSIAfterburnerSetup.zip?__token__=exp=1781081256~acl=/*~hmac=bf9fbc1f76ec60e1b45828cab6b0b876abaf0d39f596e8728694ab1248ffc7a7"; Category="GPU / Performance" }
    @{ Name="NVIDIA App"; Url="https://us.download.nvidia.com/nvapp/client/11.0.7.247/NVIDIA_app_v11.0.7.247.exe"; Category="GPU / Performance" }

    # Utilities
    @{ Name="7-Zip"; Url="https://www.7-zip.org/a/7z2408-x64.exe"; Category="Utilities" }
    @{ Name="WinRAR"; Url="https://www.win-rar.com/fileadmin/winrar-versions/winrar/winrar-x64-701.exe"; Category="Utilities" }

    # Peripherals
    @{ Name="Razer Synapse"; Url="https://rzr.to/synapse-3-pc-download"; Category="Peripherals" }
    @{ Name="Logitech G Hub"; Url="https://download01.logi.com/web/ftp/pub/techsupport/gaming/lghub_installer.exe"; Category="Peripherals" }
    @{ Name="Corsair iCUE"; Url="https://www3.corsair.com/software/CUE_V5/public/modules/windows/installer/Install%20iCUE.exe"; Category="Peripherals" }
    @{ Name="SteelSeries GG"; Url="https://steelseries.com/gg/downloads/gg/latest/windows"; Category="Peripherals" }
    @{ Name="HyperX NGENUITY"; Url="https://files.hyperx.com/software-installers/ngenuity/stable/2.0.2/HyperX_NGENUITY_Installer.exe"; Category="Peripherals" }
    
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
    Start-Process -FilePath $outfile
}

Write-Host "All selected installers have been launched."
