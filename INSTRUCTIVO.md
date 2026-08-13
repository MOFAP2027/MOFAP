# CORRIDA UVA 26-27 · Instructivo de instalación

App de gestión de labores de uva de mesa con base de datos compartida.
Sigue estos 4 pasos en orden. Toma unos 15 minutos.

---

## PASO 1 — Crear las tablas en Supabase (5 min)

1. Entra a https://supabase.com y abre tu proyecto.
2. En el menú izquierdo, haz clic en **SQL Editor**.
3. Haz clic en **New query**.
4. Abre el archivo `supabase_setup.sql` (de esta carpeta), copia TODO su contenido y pégalo.
5. Haz clic en **Run** (botón verde).
6. Debe decir "Success. No rows returned". Listo, las tablas están creadas.

Las tablas tienen el prefijo `corrida_` para no chocar con las de tus otras apps.

---

## PASO 2 — Poner tu anon key en la app (2 min)

1. En Supabase, ve a **Settings → API** (⚙ abajo a la izquierda).
2. Copia la clave **anon public** (la larga que empieza con "eyJ...").
3. Abre el archivo `index.html` con un editor de texto (Bloc de notas sirve).
4. Busca cerca del inicio esta línea:

   const SUPABASE_ANON_KEY = "PEGA_AQUI_TU_ANON_KEY";

5. Reemplaza PEGA_AQUI_TU_ANON_KEY por tu clave (déjala entre comillas).
6. Verifica también que la línea de arriba tenga la URL de TU proyecto:

   const SUPABASE_URL = "https://wobwyfwgadiapzetkwsy.supabase.co";

7. Guarda el archivo.

---

## PASO 3 — Subir a GitHub y publicar en Netlify (5 min)

**GitHub:**
1. Entra a https://github.com y crea un repositorio nuevo (ej: `corrida-uva`).
2. Haz clic en **uploading an existing file** y arrastra TODOS los archivos
   de esta carpeta: index.html, manifest.json, sw.js, icon-192.png, icon-512.png.
   (El .sql y este instructivo no hace falta subirlos, pero no estorban.)
3. Haz clic en **Commit changes**.

**Netlify:**
1. Entra a https://app.netlify.com.
2. **Add new site → Import an existing project → GitHub** y elige tu repositorio.
3. No cambies nada de configuración, solo haz clic en **Deploy**.
4. En 1 minuto tendrás tu link, algo como: `https://corrida-uva.netlify.app`

Ese link funciona en cualquier celular o computadora, y todos ven la misma
información porque los datos viven en Supabase.

---

## PASO 4 — Instalarla como app en el celular (1 min)

**Android (Chrome):**
1. Abre el link en Chrome.
2. Toca el menú ⋮ (arriba a la derecha) → **Agregar a pantalla de inicio**
   (o "Instalar app" si aparece).
3. Listo: tendrás el ícono del racimo de uva como una app más.

**iPhone (Safari):**
1. Abre el link en Safari.
2. Toca el botón de compartir (cuadrado con flecha) → **Añadir a pantalla de inicio**.

---

## Cómo funciona el uso compartido

- Todos los que abran el link ven la MISMA información (modo solo lectura).
- Para LLENAR o EDITAR datos hay que ingresar una contraseña (ver abajo).
- Los cambios se guardan al instante en Supabase.
- Si otra persona hizo cambios, toca el botón **↻ Actualizar** (arriba a la
  derecha) para traer lo último.
- La primera vez que se abre, la app carga automáticamente los 40 lotes
  de tu Excel a la base de datos.

## Acceso para editar (quién llena cada dato)

Al abrir el link, cualquiera puede VER todo. Para editar, se toca
"🔒 Solo lectura — ingresar" (arriba a la derecha) y se pone la contraseña:

- Contraseña **ap2627** → los cambios quedan registrados como **JEFFERSON** (fundo AP)
- Contraseña **lg2627** → los cambios quedan registrados como **TAMENDY** (fundo LG)

La contraseña se pone UNA sola vez por equipo; queda recordada en ese
celular/computadora hasta que se toque "salir". Cada cambio (editar un lote,
registrar una fecha real, editar una pauta, etc.) queda guardado con el nombre
de quien lo hizo.

En la pestaña **Bitácora** se ve el historial: quién cambió qué y cuándo.
Así sabes si alguien tocó un fundo que no le corresponde.

IMPORTANTE: si cambiaste las contraseñas o los nombres, edítalos en `index.html`
en la sección `const USUARIOS = {...}` cerca del inicio del archivo.

## Nota sobre seguridad

Las contraseñas sirven para IDENTIFICAR quién edita, no como seguridad fuerte
(están dentro del index.html). Para tu caso —saber quién llenó qué entre dos
personas de confianza— funciona bien. Si más adelante necesitas seguridad real
con usuarios de verdad, se puede migrar a Supabase Auth.

## Si algo falla

- "Falta configurar la anon key" → revisa el PASO 2.
- "No se pudo conectar" → revisa que ejecutaste el SQL del PASO 1 y que
  tienes internet.
- Si cambias algo en index.html, vuelve a subirlo a GitHub y Netlify se
  actualiza solo en ~1 minuto.
