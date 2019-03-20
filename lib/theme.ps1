$themedir = fullpath "$PSScriptRoot\..\themes"
$user_themedir = $env:PSHAZZ_THEMES, "$env:USERPROFILE\pshazz" | Select-Object -first 1

function theme($name) {
    $path = find_path $name

    if ([bool]$path) {
        $theme = load_theme $path
        if ($theme) {
            return $theme
        }
    }
}

function find_path($name) {
    # try user dir first
    $path = "$user_themedir\$name.json"
    if (Test-Path $path) {
        return $path
    }

    # fallback to builtin dir
    $path = "$themedir\$name.json"
    if (Test-Path $path) {
        return $path
    }
}

function load_theme($path) {
    try {
        return (Get-Content $path -Raw | ConvertFrom-Json -ErrorAction Stop)
    } catch {
        Write-Host "ERROR loading JSON for '$path'`:"
        Write-Host "$($_.Exception.Message)" -f DarkRed
    }
}

function new_theme($name) {
    if (!(Test-Path $user_themedir)) {
        New-Item -Path $user_themedir -ItemType Directory | Out-Null
    }
    Copy-Item "$themedir\default.json" "$user_themedir\$name.json"
}
