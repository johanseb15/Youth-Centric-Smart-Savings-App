# Configuración en Windows (VS Code)

Guía rápida para tener una copia local del proyecto en Windows.

## 1) Requisitos

- Git
- VS Code
- Flutter SDK
- Node.js (LTS)
- (Opcional) NestJS CLI

## 2) Crear la versión local del proyecto

1. Clona el repositorio:
   ```powershell
   git clone <URL-del-repositorio>
   cd Youth-Centric-Smart-Savings-App
   ```
2. Abre el proyecto:
   ```powershell
   code .
   ```

## 3) Inicializar los módulos (opcional)

Si ya tienes Flutter y Node instalados, puedes usar el script:

```powershell
./scripts/bootstrap-windows.ps1
```

Este script crea:
- `apps/mobile` con `flutter create`
- `apps/backend` con `nest new`

## 4) Verificaciones rápidas

```powershell
flutter doctor
node -v
npm -v
```

## 5) Comandos para crear los proyectos (manual)

```powershell
flutter create apps/mobile
nest new apps/backend --package-manager npm --skip-git
```

## Android toolchain (Android Studio) — pasos rápidos

1. Instalar Android Studio y abrir el SDK Manager. Desde allí instalar **Android SDK Command-line Tools** y al menos un Android SDK (ej. 33).
2. Aceptar licencias en terminal:

```powershell
flutter doctor --android-licenses
```

3. Establecer ruta del SDK (si es necesario):

```powershell
flutter config --android-sdk "C:\\Users\\<tu_usuario>\\AppData\\Local\\Android\\Sdk"
```

## Plataformas soportadas
- **Mobile (Android & iOS)** — prioridad: Android.
- **Web** — habilitar para prototipado rápido.
- **Windows/macOS/linux** — NO build por ahora (omitidos intencionalmente).

## Habilitar Web en Flutter

```powershell
flutter config --enable-web
flutter devices
```

## Notas de Firebase
- Integra `firebase_core` y `firebase_analytics` desde el inicio. Sigue la guía oficial para configurar `google-services.json` (Android) y `index.html` (web).
