
# Analista del Cuarto Camino - Chatbot con Gemini

Esta es una aplicación de chatbot que utiliza Gemini AI para realizar análisis de personalidad basados en la metodología de G.I. Gurdjieff y el Cuarto Camino.

## 🔑 Configuración del Token de Gemini

### Paso 1: Obtener tu API Key de Gemini

1. Ve a [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Inicia sesión con tu cuenta de Google
3. Haz clic en "Create API Key" (Crear clave de API)
4. Copia la clave generada

### Paso 2: Agregar el Token a tu Proyecto

**⚠️ IMPORTANTE: Debes agregar tu token de Gemini como variable de entorno**

Crea un archivo `.env.local` en la raíz del proyecto (al mismo nivel que `package.json`) con el siguiente contenido:

```env
GEMINI_API_KEY=tu_token_aqui
```

**Ejemplo:**
```env
GEMINI_API_KEY=AIzaSyBxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### Ubicación del archivo de configuración

El token se utiliza en el archivo: `src/app/next_api/chat/gemini/route.ts`

```typescript
// El código busca automáticamente la variable de entorno
if (!process.env.GEMINI_API_KEY) {
  return createErrorResponse({
    errorMessage: "API key de Gemini no configurada",
    status: 500,
  });
}
```

## 🚀 Instalación y Ejecución

### Requisitos previos
- Node.js 18+ instalado
- pnpm instalado (o npm/yarn)

### Pasos de instalación

1. **Instalar dependencias:**
```bash
pnpm install
```

2. **Configurar variables de entorno:**
   - Crea el archivo `.env.local` con tu `GEMINI_API_KEY` (ver sección anterior)
   - Asegúrate de tener configuradas las variables de base de datos:
     - `POSTGREST_URL`
     - `POSTGREST_SCHEMA`
     - `POSTGREST_API_KEY`

3. **Ejecutar en modo desarrollo:**
```bash
pnpm dev
```

4. **Abrir en el navegador:**
   - Ve a [http://localhost:3000](http://localhost:3000)

## 📋 Características de la Aplicación

### 1. Sistema de Autenticación
- Registro de usuarios con verificación por email
- Login con email y contraseña
- Login con Google OAuth
- Gestión de sesiones seguras

### 2. Chat Conversacional
- Interfaz de chat intuitiva con Gemini AI
- Seguimiento del protocolo de 6 pasos del análisis Gurdjieff
- Historial de conversaciones
- Múltiples sesiones de análisis

### 3. Análisis del Cuarto Camino
El chatbot guía al usuario a través de:
- **Paso 0:** Saludo y solicitud de nombre
- **Paso 1:** Identificación del campo de batalla (Personas/Tareas/Cuerpo)
- **Paso 2-4:** Tres escenarios de reacción
- **Paso 5:** Pregunta sobre el cuerpo
- **Paso 6:** Generación del reporte final extenso

### 4. Reportes de Análisis
- Visualización de reportes completos
- Historial de análisis anteriores
- Descarga de reportes en formato texto
- Información sobre tipo diagnosticado

### 5. Gestión de Prompts del Sistema
- Configuración del prompt base que guía a Gemini
- Versionado de prompts
- Activación/desactivación de prompts

## 🗂️ Estructura del Proyecto

```
src/
├── app/
│   ├── page.tsx                    # Página principal del chat
│   ├── reports/page.tsx            # Página de reportes
│   ├── login/page.tsx              # Página de login
│   └── next_api/
│       ├── chat/
│       │   ├── gemini/route.ts     # ⭐ API de Gemini (usa GEMINI_API_KEY)
│       │   ├── sessions/route.ts   # Gestión de sesiones de chat
│       │   └── messages/route.ts   # Gestión de mensajes
│       ├── analysis/
│       │   ├── reports/route.ts    # Reportes de análisis
│       │   └── responses/route.ts  # Respuestas del usuario
│       ├── system-prompts/route.ts # Gestión de prompts
│       └── auth/                   # Rutas de autenticación
├── components/
│   ├── chat/
│   │   ├── ChatInput.tsx           # Input del chat
│   │   ├── ChatMessage.tsx         # Burbuja de mensaje
│   │   └── SessionList.tsx         # Lista de sesiones
│   └── auth/                       # Componentes de autenticación
├── lib/
│   ├── api-client.ts               # Cliente HTTP
│   ├── crud-operations.ts          # Operaciones CRUD
│   └── postgrest.ts                # Cliente de base de datos
└── types/
    └── chat.ts                     # Tipos TypeScript
```

## 🔧 Configuración Avanzada

### Personalizar el Prompt del Sistema

El prompt que guía el comportamiento de Gemini se almacena en la base de datos en la tabla `system_prompts`. Puedes:

1. Crear un nuevo prompt desde la aplicación
2. Activar/desactivar prompts
3. Versionar diferentes variantes del prompt

El prompt actual incluye:
- ROL del analista
- CONOCIMIENTO BASE (Teoría de los Tres Cerebros)
- PROTOCOLO DE INTERACCIÓN (6 pasos)
- Instrucciones para generar reportes extensos

### Modificar el Modelo de Gemini

En `src/app/next_api/chat/gemini/route.ts`, puedes cambiar el modelo:

```typescript
const response = await fetch(
  `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${process.env.GEMINI_API_KEY}`,
  // Cambia 'gemini-1.5-flash' por otro modelo disponible
  // Opciones: gemini-1.5-pro, gemini-1.5-flash, etc.
```

### Ajustar Parámetros de Generación

```typescript
generationConfig: {
  temperature: 0.7,      // Creatividad (0.0 - 1.0)
  topK: 40,              // Diversidad de tokens
  topP: 0.95,            // Probabilidad acumulativa
  maxOutputTokens: 8192, // Longitud máxima de respuesta
}
```

## 📊 Base de Datos

### Tablas principales:

- `chat_sessions`: Sesiones de análisis
- `chat_messages`: Mensajes del chat
- `analysis_responses`: Respuestas del usuario durante el análisis
- `analysis_reports`: Reportes finales generados
- `system_prompts`: Prompts del sistema
- `users`: Usuarios registrados
- `user_profiles`: Perfiles de usuario

## 🛡️ Seguridad

- Las API keys nunca se exponen al cliente
- Autenticación basada en JWT
- Tokens de refresh para sesiones largas
- Validación de permisos en cada endpoint
- Variables de entorno para datos sensibles

## 🐛 Solución de Problemas

### Error: "API key de Gemini no configurada"
- Verifica que el archivo `.env.local` existe
- Confirma que la variable se llama exactamente `GEMINI_API_KEY`
- Reinicia el servidor de desarrollo después de crear el archivo

### Error: "No se recibió respuesta de Gemini"
- Verifica que tu API key es válida
- Revisa los límites de tu cuenta en Google AI Studio
- Comprueba tu conexión a internet

### El chat no responde
- Abre la consola del navegador (F12) para ver errores
- Revisa los logs del servidor en la terminal
- Verifica que la base de datos está conectada

## 📝 Licencia

Este proyecto está bajo la licencia MIT.

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:
1. Haz fork del proyecto
2. Crea una rama para tu feature
3. Haz commit de tus cambios
4. Haz push a la rama
5. Abre un Pull Request

## 📧 Soporte

Si tienes problemas o preguntas:
1. Revisa la sección de solución de problemas
2. Abre un issue en GitHub
3. Consulta la documentación de [Gemini API](https://ai.google.dev/docs)
