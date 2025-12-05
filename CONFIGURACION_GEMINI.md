
# 🔑 Guía Completa: Configuración del Token de Gemini

Esta guía te explica paso a paso cómo obtener y configurar tu API Key de Gemini para que el chatbot funcione correctamente.

## 📋 Tabla de Contenidos

1. [¿Qué es Gemini?](#qué-es-gemini)
2. [Obtener tu API Key](#obtener-tu-api-key)
3. [Configurar el Token en el Proyecto](#configurar-el-token-en-el-proyecto)
4. [Verificar la Configuración](#verificar-la-configuración)
5. [Límites y Cuotas](#límites-y-cuotas)
6. [Solución de Problemas](#solución-de-problemas)

---

## ¿Qué es Gemini?

Gemini es el modelo de inteligencia artificial de Google que utilizamos para:
- Analizar las respuestas del usuario
- Seguir el protocolo de 6 pasos del análisis Gurdjieff
- Generar reportes personalizados y detallados
- Mantener conversaciones contextuales

---

## Obtener tu API Key

### Paso 1: Acceder a Google AI Studio

1. Abre tu navegador y ve a: **https://makersuite.google.com/app/apikey**
2. Inicia sesión con tu cuenta de Google (Gmail)

### Paso 2: Crear una API Key

1. Una vez dentro, verás la página de "API Keys"
2. Haz clic en el botón **"Create API Key"** (Crear clave de API)
3. Selecciona un proyecto de Google Cloud (o crea uno nuevo si es tu primera vez)
4. Espera unos segundos mientras se genera la clave

### Paso 3: Copiar la API Key

1. Una vez generada, verás tu API Key en pantalla
2. Haz clic en el botón de **copiar** (icono de portapapeles)
3. **⚠️ IMPORTANTE:** Guarda esta clave en un lugar seguro. Por seguridad, Google solo la muestra una vez.

**Ejemplo de cómo se ve una API Key:**
```
AIzaSyBxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

---

## Configurar el Token en el Proyecto

### Opción 1: Crear archivo .env.local (Recomendado)

1. **Abre tu proyecto** en tu editor de código (VS Code, etc.)

2. **Crea un nuevo archivo** en la raíz del proyecto (al mismo nivel que `package.json`)
   - Nombre del archivo: `.env.local`
   - **NO** lo llames `.env` ni `.env.development`

3. **Agrega el siguiente contenido:**
   ```env
   GEMINI_API_KEY=AIzaSyBxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   ```
   
4. **Reemplaza** `AIzaSyBxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx` con tu API Key real

5. **Guarda el archivo** (Ctrl+S o Cmd+S)

### Estructura de archivos correcta:

```
mi-proyecto/
├── .env.local          ← Aquí va tu token (NUEVO ARCHIVO)
├── .gitignore          ← Ya incluye .env.local
├── package.json
├── README.md
├── src/
│   └── app/
│       └── next_api/
│           └── chat/
│               └── gemini/
│                   └── route.ts  ← Aquí se usa el token
└── ...
```

### ⚠️ Seguridad Importante

- **NUNCA** subas el archivo `.env.local` a Git
- El archivo `.gitignore` ya está configurado para ignorarlo
- **NUNCA** compartas tu API Key públicamente
- Si accidentalmente expones tu clave, elimínala inmediatamente desde Google AI Studio

---

## Verificar la Configuración

### Paso 1: Reiniciar el servidor

Si el servidor ya estaba corriendo, debes reiniciarlo:

```bash
# Detén el servidor (Ctrl+C en la terminal)
# Luego inicia de nuevo:
pnpm dev
```

### Paso 2: Probar el chatbot

1. Abre tu navegador en `http://localhost:3000`
2. Inicia sesión o regístrate
3. Crea una nueva sesión de análisis
4. Envía un mensaje de prueba

### Paso 3: Verificar en la consola

Si todo está bien, deberías ver:
- ✅ El chatbot responde a tus mensajes
- ✅ No hay errores en la consola del navegador (F12)
- ✅ No hay errores en la terminal del servidor

Si hay problemas, verás uno de estos errores:
- ❌ "API key de Gemini no configurada"
- ❌ "Error de Gemini API: Invalid API key"

---

## Límites y Cuotas

### Plan Gratuito de Gemini

Google ofrece un plan gratuito con los siguientes límites:

| Característica | Límite Gratuito |
|----------------|-----------------|
| Solicitudes por minuto | 60 |
| Solicitudes por día | 1,500 |
| Tokens por minuto | 32,000 |
| Tokens por solicitud | 32,000 |

### ¿Qué pasa si supero los límites?

- Recibirás un error 429 (Too Many Requests)
- Deberás esperar hasta que se restablezca el límite
- Considera actualizar a un plan de pago si necesitas más capacidad

### Monitorear tu uso

1. Ve a [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Haz clic en tu API Key
3. Revisa las estadísticas de uso

---

## Solución de Problemas

### Error: "API key de Gemini no configurada"

**Causa:** El archivo `.env.local` no existe o no tiene la variable correcta.

**Solución:**
1. Verifica que el archivo se llama exactamente `.env.local` (con el punto al inicio)
2. Verifica que la variable se llama exactamente `GEMINI_API_KEY`
3. Reinicia el servidor de desarrollo

### Error: "Invalid API key"

**Causa:** La API Key es incorrecta o ha sido revocada.

**Solución:**
1. Verifica que copiaste la clave completa (sin espacios al inicio o final)
2. Genera una nueva API Key en Google AI Studio
3. Reemplaza la clave en `.env.local`

### Error: "Quota exceeded"

**Causa:** Has superado los límites del plan gratuito.

**Solución:**
1. Espera unos minutos (los límites se restablecen)
2. Revisa tu uso en Google AI Studio
3. Considera actualizar a un plan de pago

### El chatbot no responde

**Diagnóstico:**
1. Abre la consola del navegador (F12)
2. Ve a la pestaña "Network"
3. Envía un mensaje
4. Busca la petición a `/next_api/chat/gemini`
5. Revisa el código de estado y la respuesta

**Soluciones comunes:**
- Si ves 500: Revisa la configuración del token
- Si ves 429: Has superado los límites
- Si ves 401: La API Key es inválida

### Variables de entorno no se cargan

**Causa:** Next.js no detecta los cambios en `.env.local`

**Solución:**
1. Detén completamente el servidor (Ctrl+C)
2. Elimina la carpeta `.next` (caché de Next.js)
   ```bash
   rm -rf .next
   ```
3. Inicia el servidor de nuevo
   ```bash
   pnpm dev
   ```

---

## 🎯 Checklist Final

Antes de empezar a usar la aplicación, verifica:

- [ ] Tengo mi API Key de Gemini
- [ ] Creé el archivo `.env.local` en la raíz del proyecto
- [ ] La variable se llama exactamente `GEMINI_API_KEY`
- [ ] Copié la API Key completa (sin espacios)
- [ ] Reinicié el servidor de desarrollo
- [ ] El chatbot responde correctamente
- [ ] No veo errores en la consola

---

## 📚 Recursos Adicionales

- [Documentación oficial de Gemini API](https://ai.google.dev/docs)
- [Google AI Studio](https://makersuite.google.com/)
- [Precios y límites de Gemini](https://ai.google.dev/pricing)
- [Guía de mejores prácticas](https://ai.google.dev/docs/best_practices)

---

## 💡 Consejos Pro

1. **Guarda tu API Key en un gestor de contraseñas** (LastPass, 1Password, etc.)
2. **Crea diferentes API Keys** para desarrollo y producción
3. **Monitorea tu uso regularmente** para evitar sorpresas
4. **Revoca claves antiguas** que ya no uses
5. **Nunca hardcodees la API Key** en el código fuente

---

## 🆘 ¿Necesitas Ayuda?

Si después de seguir esta guía sigues teniendo problemas:

1. Revisa los logs del servidor en la terminal
2. Revisa la consola del navegador (F12)
3. Busca el error específico en la documentación de Gemini
4. Abre un issue en el repositorio del proyecto

---

**¡Listo!** Ahora tu chatbot está configurado y listo para realizar análisis del Cuarto Camino. 🎉
