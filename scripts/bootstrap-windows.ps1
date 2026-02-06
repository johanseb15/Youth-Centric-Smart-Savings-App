$ErrorActionPreference = "Stop"

Write-Host "==> Validando herramientas" -ForegroundColor Cyan

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
  Write-Host "Flutter no está instalado o no está en PATH." -ForegroundColor Red
  exit 1
}

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
  Write-Host "Node.js no está instalado o no está en PATH." -ForegroundColor Red
  exit 1
}

if (-not (Get-Command nest -ErrorAction SilentlyContinue)) {
  Write-Host "NestJS CLI no está instalado. Instálalo con: npm install -g @nestjs/cli" -ForegroundColor Yellow
}

Write-Host "==> Creando app Flutter" -ForegroundColor Cyan
if (-not (Test-Path "apps/mobile/lib")) {
  flutter create apps/mobile
} else {
  Write-Host "apps/mobile ya existe. Se omite." -ForegroundColor Yellow
}

Write-Host "==> Creando backend NestJS" -ForegroundColor Cyan
if (-not (Test-Path "apps/backend/src")) {
  nest new apps/backend --package-manager npm --skip-git
} else {
  Write-Host "apps/backend ya existe. Se omite." -ForegroundColor Yellow
}

Write-Host "Listo ✅" -ForegroundColor Green
