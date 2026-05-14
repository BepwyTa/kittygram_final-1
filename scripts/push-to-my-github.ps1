# Запуск из корня репозитория kittygram_final:
#   .\scripts\push-to-my-github.ps1 -GitHubUser ВАШ_ЛОГИН
#
# Перед запуском на github.com создай пустой репозиторий kittygram_final
# (без README, .gitignore и лицензии — или разреши слияние при первом push).

param(
    [Parameter(Mandatory = $true)]
    [string] $GitHubUser
)

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot\..

if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
    Write-Error "Запускай скрипт из клонированного kittygram_final (внутри .git)."
}

$url = "https://github.com/$GitHubUser/kittygram_final.git"
git remote remove origin 2>$null
git remote add origin $url
Write-Host "Remote origin -> $url"
git push -u origin main
Write-Host "Готово: ветка main на GitHub."
