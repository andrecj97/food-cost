#!/usr/bin/env bash
# Genera public/config.js con las variables de entorno definidas en Render.
set -euo pipefail
: "${SUPABASE_URL:?Falta la variable de entorno SUPABASE_URL}"
: "${SUPABASE_ANON_KEY:?Falta la variable de entorno SUPABASE_ANON_KEY}"
cat > public/config.js <<CFG
window.ENV = { SUPABASE_URL: "${SUPABASE_URL}", SUPABASE_ANON_KEY: "${SUPABASE_ANON_KEY}" };
CFG
echo "public/config.js generado correctamente"
