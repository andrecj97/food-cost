# Food Cost – Supabase + GitHub Pages

App web para el control de food cost de un restaurante (S/, IGV 18%).
Los datos se guardan en **Supabase** (PostgreSQL).

**Publicada en:** https://andrecj97.github.io/food-cost/
Cada cambio que se sube a la rama `main` se publica solo (GitHub Actions → `.github/workflows/pages.yml`).
También es compatible con Render (Static Site, build `bash build.sh`, carpeta `public`) si algún día se registra una tarjeta allí.

## Estructura

```
food-cost-app/
├── public/
│   ├── index.html            ← la aplicación
│   └── config.example.js     ← plantilla de configuración para pruebas locales
├── supabase/
│   └── schema.sql            ← tablas y seguridad (ejecutar una vez en Supabase)
├── build.sh                  ← Render lo ejecuta para crear public/config.js
└── .gitignore
```

## Paso 1 – Supabase (base de datos)

1. Entra a https://supabase.com y crea una cuenta.
2. **New project**: nombre `food-cost`, guarda la contraseña de la base de datos y elige la región **São Paulo (sa-east-1)**, que es la más cercana a Perú.
3. Ve a **SQL Editor → New query**, pega todo el contenido de `supabase/schema.sql` y pulsa **Run**. Debe responder "Success".
4. Revisa en **Table Editor** que existan las tablas `config`, `insumos`, `recetas`, `receta_items`, `ventas` e `inventario`.
5. Ve a **Authentication → Sign In / Providers**: deja activo **Email** y desactiva **Allow new users to sign up**, para que solo tú puedas crear usuarios.
6. Ve a **Authentication → Users → Add user → Create new user**: pon el correo y la contraseña de cada persona que usará la app y marca **Auto Confirm User**.
7. Copia los dos datos de conexión desde el botón **Connect** o desde **Project Settings → API / API Keys**:
   - **Project URL**, por ejemplo `https://abcd1234.supabase.co`
   - **Publishable key** (`sb_publishable_…`) o, en proyectos antiguos, la **anon public key**.
   - ⚠️ Nunca uses la `secret` / `service_role` key en la web.

## Paso 2 – GitHub (repositorio del código)

1. Crea una cuenta en https://github.com y luego **New repository** → nombre `food-cost` → Private → Create.
2. Pulsa **uploading an existing file** y arrastra el *contenido* de la carpeta `food-cost-app` (las carpetas `public` y `supabase` y los archivos `build.sh`, `.gitignore` y `README.md`).
   Si no ves `.gitignore` porque es un archivo oculto, no pasa nada.
3. Pulsa **Commit changes**.

## Paso 3 – Render (publicación)

1. Entra a https://render.com e inicia sesión con tu cuenta de GitHub.
2. **New → Static Site** → conecta tu repositorio `food-cost`.
3. Configuración:
   | Campo | Valor |
   |---|---|
   | Name | `food-cost` (será parte de la URL) |
   | Branch | `main` |
   | Build Command | `bash build.sh` |
   | Publish Directory | `public` |
4. En **Environment Variables** agrega:
   | Key | Value |
   |---|---|
   | `SUPABASE_URL` | tu Project URL |
   | `SUPABASE_ANON_KEY` | tu Publishable / anon key |
5. **Create Static Site**. En 1 o 2 minutos tendrás la URL, por ejemplo `https://food-cost.onrender.com`.

## Paso 4 – Ajuste final en Supabase

**Authentication → URL Configuration → Site URL** = la URL de Render.

## Paso 5 – Primer uso

1. Abre la URL de Render e ingresa con el usuario que creaste en el paso 1.6.
2. La primera vez la base está vacía: pulsa **Cargar datos de ejemplo** o empieza a registrar tus propios insumos y recetas.
3. Cada cambio se guarda solo (indicador "✓ Guardado" en el encabezado).

## Respaldos: Exportar / Importar

- **Exportar** descarga un archivo `food-cost-respaldo-AAAA-MM-DD.json` con todos los datos.
- **Importar** reemplaza todos los datos de la base por los de un respaldo (pide confirmación).
- Para pasar lo que tenías en la versión anterior (el archivo `food-cost.html` sin base de datos),
  usa **Exportar** en esa versión e **Importar** en la nueva.

## Ten en cuenta (plan gratuito)

- **Pausa por inactividad:** Supabase pausa los proyectos gratuitos que pasan alrededor de una semana sin uso. Se reactiva desde el panel con **Restore project**, sin perder datos.
- **Respaldos:** el plan gratuito no te da respaldos descargables. Exporta un JSON al cierre de cada mes, o antes de cambios grandes.
- **Edición simultánea:** si dos personas editan el mismo campo a la vez, se queda el último cambio guardado. Usa **Recargar** para ver lo que guardaron otros.
- **Render gratuito:** los Static Sites no se "duermen", así que la web carga rápido siempre.

## Actualizaciones

Cada vez que subas un cambio a GitHub, Render vuelve a publicar la web automáticamente.

## Probar en tu computadora (opcional)

Copia `public/config.example.js` como `public/config.js`, pon tus datos y sirve la carpeta con
`npx serve public` o con la extensión *Live Server* de VS Code. Abrir el archivo con doble clic no basta,
porque la sesión necesita http/https.

## Solución de problemas

| Mensaje | Causa probable |
|---|---|
| "Falta la configuración de Supabase" | Las variables de entorno en Render están mal escritas o vacías. Corrígelas y usa **Manual Deploy → Clear build cache & deploy**. |
| "Correo o contraseña incorrectos" | El usuario no existe o no se marcó *Auto Confirm User*. |
| "permission denied" o "relation does not exist" | No se ejecutó `schema.sql` completo. |
| "⚠ Error al guardar" | Sin internet. La app reintenta sola cada 5 segundos; no cierres la pestaña hasta que diga "✓ Guardado". |
