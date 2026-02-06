# Namaa (Youth-Centric Smart Savings App)

Repositorio inicial para el proyecto **Namaa**, una app de ahorro gamificada enfocada en público juvenil.

## Estructura del repositorio

```
apps/
  mobile/   # App Flutter (UI/UX)
  backend/  # API NestJS (servicios y datos)
docs/       # Documentación y especificaciones
scripts/    # Utilidades locales (bootstrap, helpers)
```

## Empezar en Windows (VS Code)

Sigue estos pasos para crear tu versión local del proyecto en tu PC con Windows:

1. **Clona el repositorio** (o copia la carpeta del proyecto).
   ```powershell
   git clone <URL-del-repositorio>
   cd Youth-Centric-Smart-Savings-App
   ```
2. **Instala Flutter**
   - Descarga desde https://docs.flutter.dev/get-started/install/windows
   - Verifica:
     ```powershell
     flutter doctor
     ```
3. **Instala Node.js (LTS)**
   - Descarga desde https://nodejs.org/
   - Verifica:
     ```powershell
     node -v
     npm -v
     ```
4. **(Opcional) Instala NestJS CLI**
   ```powershell
   npm install -g @nestjs/cli
   ```
5. **Abrir en VS Code**
   ```powershell
   code .
   ```

> Nota: este repo solo contiene la estructura inicial. Los módulos Flutter y NestJS se irán creando dentro de `apps/mobile` y `apps/backend`.

## Próximos pasos sugeridos

- Crear el proyecto Flutter dentro de `apps/mobile`.
- Crear el proyecto NestJS dentro de `apps/backend`.
- Definir variables de entorno y scripts de arranque.

Revisa la especificación UX/UI en `docs/ux-ui-spec.md`.

## Arquitectura (resumen para Codex)

### Cliente móvil (Flutter)

```
namaa_app/
├── android/
├── ios/
├── assets/
│   ├── images/
│   ├── icons/
│   ├── animations/
│   └── fonts/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   │   ├── config/
│   │   ├── constants/
│   │   ├── errors/
│   │   ├── services/
│   │   ├── utils/
│   │   └── widgets/
│   └── features/
│       ├── auth/
│       ├── home/
│       ├── goals/
│       ├── gamification/
│       └── social/
├── test/
├── pubspec.yaml
└── analysis_options.yaml
```

### Backend (NestJS)

```
namaa_backend/
├── src/
│   ├── main.ts
│   ├── app.module.ts
│   ├── common/
│   │   ├── decorators/
│   │   ├── filters/
│   │   ├── guards/
│   │   └── interceptors/
│   ├── config/
│   ├── database/
│   └── modules/
│       ├── auth/
│       ├── users/
│       ├── goals/
│       ├── savings/
│       ├── gamification/
│       └── notifications/
├── test/
├── .env
├── docker-compose.yml
└── package.json
```

### Infraestructura en la raíz

- `.github/workflows/ci_cd.yml`
- `docker-compose.dev.yml`
- `.gitignore`

## Comandos para crear los proyectos

```powershell
flutter create apps/mobile
nest new apps/backend --package-manager npm --skip-git
```
