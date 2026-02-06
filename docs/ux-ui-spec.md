# Namaa UX/UI Design Spec

Este documento resume el apartado de diseño UX/UI para la app Namaa, enfocado en una experiencia juvenil con gamificación, claridad financiera y una identidad visual coherente. Incluye el flujo lógico para que Codex interprete navegación, estados de UI e interacciones en Flutter.

## 1. Concepto visual (Look & Feel)

**Estilo:** Soft-Modern & Playful. Una mezcla de interfaces limpias con elementos vibrantes y orgánicos.

**Paleta de colores:**

- Verde Crecimiento (Primario): `#00A896` (dinero y naturaleza).
- Azul Confianza (Secundario): `#028090`.
- Amarillo Recompensa (Acento): `#F0B67F` (monedas, logros, alertas).
- Fondo: `#F8FAFC` (blanco roto para evitar fatiga visual).

**Tipografía:** Montserrat o Plus Jakarta Sans (geométricas, legibles, tono tecnológico y amigable).

## 2. User journeys (flujos críticos)

- **Onboarding educativo:** Registro → Selección de “Personalidad de Ahorro” → Tutorial rápido con micro-interacciones.
- **Creación de meta:** Definir nombre (ej. “PlayStation 5”) → Monto objetivo → Elegir “Triggers” (ej. ahorrar $1 por cada 1 km caminando).
- **Gamificación (The Loop):** Barra de progreso → Notificación de “Racha” (Streaks) → Animación de celebración (Lottie) al depositar.
- **Social/Challenges:** Invitación a amigos → Ranking de ahorro semanal → Chat de ánimos.

## 3. Arquitectura de información (sitemap)

- **Home:** Dashboard con balance total, racha actual y accesos rápidos.
- **Metas (Goals):** Cards con progreso visual y fotos personalizadas.
- **Social:** Feed de actividad (ej. “Alex cumplió el 50% de su meta”).
- **Aprender:** Cápsulas de contenido financiero estilo “Stories”.
- **Perfil:** Configuración, insignias (Badges) ganadas y nivel de usuario.

## 4. Componentes del design system (Figma handoff)

- **Botones:** Bordes redondeados (`radius: 16px`), sombras suaves para profundidad.
- **Tarjetas:** Diseño neumórfico sutil para agrupar información de ahorro.
- **Widgets de datos:** Gráficos de barras simplificados y anillos de progreso circulares.
- **Micro-animaciones (Lottie):**
  - `Coin_Rain.json` para completar una meta.
  - `Growth_Plant.json` planta que crece según saldo ahorrado.

## 5. Flujo lógico de la aplicación (Codex specs)

### 5.1 Onboarding & Auth

- **Pantalla 1: Bienvenida (Splash/Hero)**
  - Acción: el usuario visualiza el valor de la app (ahorro divertido).
  - Lógica: verificar token JWT local. Si existe, redirigir a Home; si no, a Sign Up.
- **Pantalla 2: Registro/Login**
  - Inputs: Email, Teléfono (OTP) o Social Auth.
  - Componentes: botones de acción principal (Custom Button) y campos con validación.

### 5.2 Dashboard principal (Home)

- **Estado inicial:** `BalanceTotal` y `MonthlyInsights`.
- **Componentes visuales:**
  - `SavingsCard`: widget con saldo actual y gráfico de barras (ahorro semanal).
  - `ActiveGoalsList`: lista horizontal de tarjetas con progreso circular.
- **Navegación:** `BottomNavigationBar` con 4 destinos: Home, Metas, Social, Perfil.

### 5.3 Flujo de creación de metas (Set a New Goal)

- **Paso 1: Categoría** → selección de iconos (Viajes, Tecnología, Educación).
- **Paso 2: Detalles** → nombre de meta y monto objetivo.
- **Paso 3: Triggers** → reglas automáticas (ej. “Ahorrar el cambio” o “Reto de $5 semanales”).
- **Acción final:** `POST /goals/create` y animación Lottie “Meta Creada”.

### 5.4 Detalle de meta y gamificación

- **Vista de progreso:**
  - `ProgressBar`: widget que cambia color según % completado.
  - `StreakBadge`: icono de fuego con contador de días consecutivos.
- **Interacción:** botón flotante (+) para añadir dinero manualmente o simular depósito.
- **Feedback visual:** hitos 25%, 50%, 75% → popup de recompensa (insignia).

### 5.5 Flujo social y desafíos (Social & Challenges)

- **Feed de actividad:** logros recientes (ej. “Maria completó No Spend November”).
- **Ranking (Leaderboard):** orden por “Puntos de Hábito”.
- **Retos peer-to-peer:** invitar amigo a desafío común (ej. “Ahorrar para el concierto juntos”).

## 6. Estructura de datos para el backend (NestJS context)

| Entidad | Campos clave | Relación |
| --- | --- | --- |
| User | id, username, email, streak_count, total_saved | 1:N con Goals |
| Goal | id, title, target_amount, current_amount, category | N:1 con User |
| Transaction | id, amount, type (manual/auto), timestamp | N:1 con Goal |
| Challenge | id, title, duration, participants_ids | N:N con Users |

## 7. Documentación de UX para Codex

**Prompt sugerido:**

> Genera la estructura de archivos en Flutter siguiendo el Design System de Namaa. Usa widgets personalizados para las tarjetas de metas con bordes redondeados de 16px, implementa una paleta basada en el verde #00A896 y asegura que las transiciones entre pantallas sean fluidas usando el paquete animations.

**Prompt de implementación:**

> Implementa el flujo de navegación en Flutter usando go_router. Crea un widget GoalCard que reciba un objeto Goal con campos title, progress (double) y color. Asegúrate de que al hacer clic en la tarjeta, navegue a /goal-details/:id con una transición de hero animation.

## 8. Epic User Story (visión cultural occidental)

**Título:** De Gastador Impulsivo a “Savings Master”

**Persona:** Alex, 20 años. Estudia y trabaja medio tiempo (gig economy). Le da ansiedad mirar su cuenta bancaria. Quiere viajar a Japón con amigos, pero gasta todo en suscripciones y café.

### 8.1 El encuentro (Discovery & Onboarding)

- **Contexto:** Alex descarga Namaa porque un amigo compartió en Instagram su racha de ahorro de 50 días.
- **Acción:** abre la app y ve una interfaz estilo videojuego, no formularios bancarios.
- **Western twist:** “Financial Vibe Check” (test de personalidad financiera) para clasificar entre “Impulse Spender” o “Calculated Saver”.
- **Resultado:** en menos de 60 segundos se configura su perfil y se asigna un avatar (planta pequeña) que crecerá con el ahorro.

### 8.2 La misión (Goal Setting)

- **Objetivo:** dejar de ahorrar “para el futuro” y enfocarse en “Japón 2026”.
- **Acción:** crea la meta “Tokyo Drift” y sube una foto de Shibuya como portada.
- **Configuración:** sugerencia automática: “Para llegar a $2,000 en 6 meses, necesitas guardar $11 al día. ¿Te parece bien o es mucho?”.
- **Automation:** activa “Round-ups” y “Guilty Pleasure Tax” (si compra Starbucks, se mueve $1 extra a ahorro).

### 8.3 El bucle diario (Core Loop & Gamification)

- **Notificación:** push al mediodía: “🔥 Llevas 12 días de racha. Si ahorras $5 hoy, desbloqueas el badge de ‘Samurai Saver’.”
- **Interacción:** entra y desliza una moneda virtual hacia “Tokyo Drift”.
- **Feedback:** vibración háptica, sonido de monedas (ASMR) y el avatar planta crece una hoja nueva.

### 8.4 El factor social (Social & Challenges)

- **Multiplayer:** crea un “Squad” con 3 amigos y ve barra de progreso grupal.
- **Competencia:** nota que Sarah ahorró más esta semana.
- **Feed:** publica el hito de 50% y recibe reacciones con emojis de fuego.

### 8.5 La recompensa (Cash out & Reward)

- **Acción:** rompe la alcancía virtual; confeti y fuegos artificiales llenan la pantalla.
- **Off-boarding:** transfiere el dinero a su tarjeta para comprar el boleto. El logro queda en “Hall of Fame”.

## 9. Desglose funcional para Codex (Gherkin)

```gherkin
Feature: Gamified Savings Lifecycle

  Scenario: User sets a tangible goal with visual cues
    Given the user is logged in
    When the user creates a goal with title "Tokyo" and target "2000"
    Then the app calculates daily_contribution based on deadline
    And displays a visual progress bar (plant metaphor)

  Scenario: User executes a savings action (Gamification)
    Given the user has a linked payment source
    When the user triggers a "Manual Save" of $5
    Then the backend processes the transaction
    And the UI triggers "Lottie_Coin_Explosion" animation
    And the user's Streak Counter increments by 1

  Scenario: Social Accountability (Western Trend)
    Given the user is part of a "Squad"
    When a squad member saves money
    Then send a push notification to other members: "Sarah just leveled up toward Tokyo!"
    And update the Leaderboard ranking
```

## 10. Novedades y tendencias de mercado (2025)

1. **Save Now, Buy Later (SNBL)**
   - Antítesis del BNPL: ahorrar para un producto específico.
   - Alianzas con marcas (Nike, Apple, Expedia) para descuentos al completar metas.
   - Beneficio: la marca paga por intención de compra; el usuario obtiene precio mejor.

2. **AI Financial “Roast” or “Hype”**
   - Chatbot con personalidad seleccionable.
   - Modo “Bestie” vs “Roast” (estilo viral TikTok).

3. **Impulse Bloqueado (Cooling-off Period)**
   - Pegar link de compra impulsiva y congelar fondos 72 horas.
   - Si decide no comprar, gana puntos o “Karma Coins”.

4. **Loot Boxes éticas**
   - Recompensa aleatoria por rachas (skins de avatar, cupones o micro-depósitos).

## 11. Entorno, operativa invisible y requisitos previos

### 11.1 Estrategia de entornos y feature flags

- **Entornos definidos:**
  - **Dev:** espacio para iteración rápida y pruebas diarias.
  - **Staging:** réplica de producción con datos falsos y aprobación del Product Owner.
  - **Production:** entorno real con despliegues controlados.
- **Feature flagging:**
  - Implementar un sistema (Firebase Remote Config, LaunchDarkly u otro) para activar/desactivar funcionalidades sin publicar una nueva versión.
  - Caso de uso: si “Retos Grupales” falla en lanzamiento, se apaga remotamente.

### 11.2 Cumplimiento legal y confianza (fintech)

- **Términos y privacidad:** documentos claros sobre datos recopilados.
- **KYC ligero (futuro):** reservar espacio en UI para verificación cuando sea necesario.
- **Edad mínima:** contemplar COPPA/GDPR Kids y flujo de consentimiento parental si el usuario es menor de edad.

### 11.3 App Store Optimization (ASO) y review

- **Cuenta demo:** credenciales de prueba para revisores de Apple/Google con datos simulados.
- **Materiales de tienda:** screenshots promocionales y video corto explicando la propuesta de valor.
- **Plan de revisión:** anticipar rechazos en apps fintech nuevas.

### 11.4 Gestión de errores y feedback loop

- **Estados vacíos y de error:** diseñar pantallas para falta de internet y fallos de carga.
- **Soporte in-app:** botón “Ayuda/Reportar bug” en Perfil.
- **Crash reporting:** Crashlytics/Sentry con alertas cuando los crashes superen 1%.

### 11.5 Monetización y modelo de negocio

- **Freemium vs Premium:** definir lógica de permisos (ej. `user.isPremium`).
- **Affiliate tracking:** si se usa SNBL, planificar tracking de conversiones de marca.

## 12. Workflow recomendado (Big Tech)

- **Refinement:** definición clara de historia y métricas.
- **Design handoff:** exportables de Figma (1x, 2x, 3x).
- **Development + Unit Tests:** no aceptar código sin tests.
- **QA:** pruebas en dispositivos reales (TestFlight para iOS).
- **Release:** despliegue gradual (10% → 50% → 100%).

## 13. Prompt adicional para Codex (infra y soporte)

> Actúa como un Tech Lead experimentado. Basado en el stack Flutter/NestJS, genera los siguientes archivos y estructuras:
> - GitHub Actions Workflow (.yml): CI/CD que ejecute `flutter test` al hacer push y genere una build Android (APK).
> - Manejo de errores: clase `ErrorHandler` que capture excepciones globales y envíe eventos a Sentry/Firebase, mostrando un diálogo amigable en UI.
> - Feature Flag Service: servicio que consulte un endpoint o Firebase Remote Config para decidir si mostrar “Crypto Savings” en tiempo real.
