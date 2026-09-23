# bomerp-frontend-vue

Anexo del Proyecto Integrador: la misma arquitectura de LP2 S07 (Angular, sesión oficial), resuelta en **Vue** — para el equipo que eligió este stack para su propio proyecto. Guía completa: [`docs/proyecto-integrador/anexos/S07_Creacion_Arquitectura_SPA_Vue.md`](../../docs/proyecto-integrador/anexos/S07_Creacion_Arquitectura_SPA_Vue.md).

**No reemplaza** [`lp2/bomerp-frontend`](../bomerp-frontend) (Angular, la sesión oficial de LP2) — es una ruta alternativa, no una entrega paralela.

## Prerrequisitos

- **Node.js LTS** (incluye `npm`). No hace falta instalar nada más de forma global.
- [`lp2/bomerp-backend`](../bomerp-backend) corriendo en `http://localhost:8080`, con CORS habilitado para `http://localhost:5173` (S5).

## Levantar el ambiente DEV

1. Backend, en otra terminal:

   ```powershell
   cd ../bomerp-backend
   .\mvnw.cmd spring-boot:run
   ```

2. Variables de ambiente — crea `.env` en esta carpeta (no se versiona, cada quien lo crea localmente):

   ```text
   VITE_API_BASE_URL=http://localhost:8080
   ```

3. Frontend:

   ```bash
   npm install
   npm run dev
   ```

   Abre `http://localhost:5173`.

## Estructura

```text
src/
├── core/                          # AppLayout, InicioView, api.ts (fetch + trazabilidad X-Trace-ID)
├── router/index.ts                # rutas de la aplicación
└── features/
    └── catalogo/
        └── categoria/              # modelo, servicio y vistas del CRUD de Categoria
```

## Stack

- Vue 3 (Composition API, `<script setup>`) + TypeScript, Vite
- Vue Router (rutas anidadas, `<RouterView>`, carga perezosa con `() => import(...)`)
- `fetch` nativo, sin Axios — ver `src/core/api.ts`
- Sin Pinia: no hace falta gestor de estado global para este CRUD

## Estado actual

CRUD completo de `Categoria` (listar, crear, editar, eliminar), navegación por layout con sidebar, validación de formulario (`nombre` obligatorio y máximo 80 caracteres, `descripcion` máximo 200) con `touched` independiente por campo.
