# MVP Setup & Run Guide (Namaa)

## Pre-requisitos
- Flutter 3.38.9+ ([instalación Windows](https://docs.flutter.dev/get-started/install/windows))
- Node.js 24+ LTS ([descargar](https://nodejs.org/))
- PostgreSQL 13+ running locally o en Docker
- Android SDK (para emulador o dispositivo físico)

## 1. Configurar Backend (NestJS)

### Instalar dependencias (ya hecho en setup, pero aquí para referencia):
```powershell
cd apps/backend
npm install
```

### Configurar variables de entorno:
```powershell
# Ya existe .env con valores de desarrollo
# Editar si es necesario (DB_HOST, DB_PASSWORD, etc.)
cat .env
```

### Iniciar servidor backend:
```powershell
cd apps/backend
npm run start:dev
# Debería escuchar en http://localhost:3000
```

Backend estará disponible en: **http://localhost:3000/api**

---

## 2. Configurar Mobile (Flutter)

### Instalar dependencias (ya hecho, pero aquí para referencia):
```powershell
cd apps/mobile
flutter pub get
```

### Antes de ejecutar: Habilitar Web (opcional, para prototipado rápido)
```powershell
flutter config --enable-web
```

### Ejecutar en **Web** (más rápido para prototipado):
```powershell
cd apps/mobile
flutter run -d web
# Abrirá en http://localhost:58510 (puerto puede variar)
```

### Ejecutar en **Android** (emulador o dispositivo físico):

#### 1. Verificar que Android SDK está configurado:
```powershell
flutter doctor
```

Si hay errores de Android toolchain, seguir: [docs/setup-windows.md](../docs/setup-windows.md)

#### 2. Listar dispositivos disponibles:
```powershell
flutter devices
```

#### 3. Ejecutar en dispositivo:
```powershell
cd apps/mobile
flutter run
# Si hay múltiples dispositivos:
flutter run -d emulator-5554  # o el ID que aparezca en 'flutter devices'
```

---

## 3. Flujo de Prueba (MVP endpoints)

### Backend - Auth Endpoints:

**Register:**
```powershell
$body = @{
    email = "test@example.com"
    username = "testuser"
    password = "password123"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:3000/api/auth/register" `
  -Method Post `
  -Headers @{"Content-Type"="application/json"} `
  -Body $body
```

**Login:**
```powershell
$body = @{
    email = "test@example.com"
    password = "password123"
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri "http://localhost:3000/api/auth/login" `
  -Method Post `
  -Headers @{"Content-Type"="application/json"} `
  -Body $body

# Guardar token para próximas llamadas
$token = $response.access_token
```

### Mobile - Flujo de Login:
1. Ejecutar `flutter run` (web o Android)
2. App abre en pantalla de Login
3. Ingresar credenciales (email/password)
4. Click en "Login" → se conecta a backend
5. Si éxito → navega a Home (dashboard)
6. Si error → muestra SnackBar con mensaje de error

---

## 4. Docker (Opcional - para PostgreSQL local)

Si prefieres usar Docker para la base de datos:
```powershell
# En la raíz del proyecto
docker-compose -f docker-compose.dev.yml up -d

# Verificar que PostgreSQL está corriendo
docker ps
```

PostgreSQL estará en: `localhost:5432` (credenciales en .env)

---

## 5. Próximos Pasos del MVP (Sprint 1)

✅ **Completado:**
- Setup estructura clean architecture
- Auth API (backend) - sin persistencia real aún
- Login UI (mobile)
- Navegación go_router

⏳ **Por hacer:**
- [ ] Conectar PostgreSQL real (migrations TypeORM)
- [ ] Crear Goals CRUD (backend)
- [ ] Goals UI (mobile)
- [ ] Firebase Analytics integration
- [ ] Dashboard básico con progreso de metas

---

## 6. Troubleshooting

### "Cannot find module '@nestjs/config'"
```powershell
cd apps/backend
npm install
```

### "No Android SDK found" en flutter doctor
Seguir pasos en [docs/setup-windows.md](../docs/setup-windows.md) sección "Android toolchain"

### Flutter "gradle build failed"
```powershell
cd apps/mobile
flutter clean
flutter pub get
flutter run
```

### Backend conexión a PostgreSQL falla
1. Verificar que PostgreSQL está corriendo
2. Revisar credenciales en `apps/backend/.env`
3. Si usas Docker: `docker-compose -f docker-compose.dev.yml up`

---

## 7. Comandos Útiles

**Backend:**
```powershell
cd apps/backend
npm run lint        # Chequear código
npm run build       # Build para producción
npm run start:dev   # Dev con hot-reload
```

**Mobile:**
```powershell
cd apps/mobile
flutter clean       # Limpiar build
flutter pub get     # Actualizar deps
flutter analyze     # Análisis de código
flutter test        # Ejecutar tests
```

---

**¿Preguntas?** Revisar [README.md](../README.md) o [ux-ui-spec.md](../docs/ux-ui-spec.md)
