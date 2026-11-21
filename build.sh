#!/usr/bin/env bash
# Si Render define SUPABASE_URL y SUPABASE_ANON_KEY, regenera public/config.js.
# Si no, se usa el public/config.js incluido en el repositorio.
set -euo pipefail
if [[ -n "${SUPABASE_URL:-}" && -n "${SUPABASE_ANON_KEY:-}" ]]; then
  cat > public/config.js <<CFG
window.ENV = { SUPABASE_URL: "${SUPABASE_URL}", SUPABASE_ANON_KEY: "${SUPABASE_ANON_KEY}" };
CFG
  echo "public/config.js generado desde variables de entorno"
else
  echo "Usando public/config.js del repositorio"
fi
