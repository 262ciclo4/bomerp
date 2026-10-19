# BOM ERP

**Business Operations Management Platform**

BOM ERP es un entorno integrado de desarrollo academico para construir modulos empresariales tipo ERP modular o aplicaciones empresariales con backend, frontend y base de datos.

El proyecto articula la linea curricular:

```text
ADS -> BD2 -> LP2
```

Este repositorio es la plantilla base del proyecto integrador del Ciclo 4. Cada grupo puede clonarlo o crear un repositorio propio a partir de esta estructura para desarrollar su modulo de BOM ERP.

## Alcance Inicial

```text
BOM ERP
|-- Comercial
|-- Inventario
|-- Facturacion
|-- Ventas
|-- Compras
|-- Integraciones
|-- IA
`-- Analitica
```

## Estructura

```text
bomerp/
|-- .github/workflows/  - despliegue automatico a GitHub Pages
|-- ads/                - entregables del curso ADS
|-- bd2/                - entregables del curso BD2
|-- docs/               - documentacion MkDocs para ADS, BD2 y LP2
|-- lp2/                - entregables del curso LP2
|-- overrides/          - personalizacion del tema MkDocs (main.html)
|-- .gitignore
|-- mkdocs.yml          - configuracion del sitio
`-- README.md           - onboarding del proyecto
```

## Documentacion

La documentacion se mantiene en [`docs/`](docs/) y se publica automaticamente con GitHub Actions en la rama `gh-pages`.

El archivo principal del proyecto contiene la integracion curricular del ciclo:

```text
docs/index.md
```

Cada curso tiene su propia seccion:

```text
docs/ads/index.md
docs/bd2/index.md
docs/lp2/index.md
```

## Despliegue

No es necesario compilar la documentacion en local. El workflow ubicado en `.github/workflows/deploy.yml` instala MkDocs en GitHub Actions y ejecuta:

```bash
mkdocs gh-deploy --force
```

Para publicar cambios, basta con subirlos a la rama `main`.

## Uso por Grupos

1. Clonar o crear un repositorio desde esta plantilla.
2. Actualizar el README con el nombre del grupo y modulo asignado.
3. Completar los entregables en `ads/`, `bd2/` y `lp2/`.
4. Mantener la documentacion publica en `docs/`.
5. Publicar GitHub Pages usando el workflow incluido.

## Arranque rápido en DEV (LP2)

El proyecto ejecutable (backend, frontend y observabilidad) vive en [`lp2/`](lp2/). El **orden importa**: primero la base de datos, después el backend, y recién con el backend respondiendo, el frontend. Los comandos son de PowerShell, desde la raíz del repositorio; en macOS/Linux, `.\mvnw.cmd` es `./mvnw`.

`.\mvnw.cmd spring-boot:run` y `npm start` quedan corriendo en primer plano — no devuelven el *prompt*. Para el siguiente paso, **duplica la pestaña** (no cierres ni reuses la que tiene un proceso corriendo: cerrarla apaga ese servidor).

### 1. Backend ([`lp2/bomerp-backend/`](lp2/bomerp-backend/))

Base de datos (Oracle, contenedor `bomerp-oracle`):

```powershell
cd lp2/bomerp-backend
docker compose -f compose-dev.yml up -d
```

La primera vez, el contenedor tarda un poco más en quedar listo (`healthcheck` de Oracle). Confírmalo con `docker ps` antes de levantar el backend — debe aparecer `healthy`, no solo `Up`.

Backend (Maven Wrapper, no hace falta instalar Maven):

```powershell
.\mvnw.cmd spring-boot:run
```

Verificación:

- Swagger: `http://localhost:8080/swagger-ui.html`
- Health: `http://localhost:8080/actuator/health`
- Un endpoint real: `http://localhost:8080/api/v1/categorias`

Desde S10b, la autorización depende de Keycloak (contenedores `bomerp-keycloak`/`bomerp-keycloak-db`), no de un módulo `seguridad` propio — ver [`docs/lp2/sesiones/S10b_Seguridad_Backend_Keycloak.md`](docs/lp2/sesiones/S10b_Seguridad_Backend_Keycloak.md) para levantarlo.

### 2. Frontend ([`lp2/bomerp-frontend/`](lp2/bomerp-frontend/))

Con el backend ya respondiendo, en otra terminal:

```powershell
cd lp2/bomerp-frontend
npm install
npm start
```

Abre `http://localhost:4200`. El frontend apunta al backend por `environment.apiBaseUrl` (`src/environments/environment.ts`), hoy `http://localhost:8080` — si cambias el puerto del backend, ese es el archivo que hay que actualizar. El backend ya acepta ese origen por CORS (`bomerp.cors.allowed-origins`, `application-dev.yml`).

### 3. Observabilidad ([`lp2/obs/`](lp2/obs/)), opcional

No hace falta para desarrollar ni para probar backend/frontend — súbelo solo cuando necesites ver métricas o logs agregados. Detalle completo en [`lp2/obs/README.md`](lp2/obs/README.md).

```powershell
cd lp2/obs
docker compose -f compose-dev.yml up -d
```

Verificación:

- Prometheus: `http://localhost:39090`
- Grafana: `http://localhost:33000` (usuario `admin`, contraseña `admin`)
- Loki (logs, vía Grafana, no tiene UI propia): `http://localhost:33100`

### Detener

`Ctrl+C` detiene el backend y el frontend en sus propias terminales.

Para los contenedores, cada carpeta con su propio `compose-dev.yml` (`lp2/bomerp-backend/`, `lp2/obs/`) baja solo los suyos:

```powershell
docker compose -f compose-dev.yml down
```

Todos los contenedores de `lp2` se nombran con el prefijo `bomerp-` (`bomerp-oracle`, `bomerp-keycloak`, `bomerp-prometheus-dev`...) — a propósito, para poder pararlos todos juntos sin entrar carpeta por carpeta:

```powershell
docker stop (docker ps --filter "name=bomerp-" -q)
```

```bash
docker stop $(docker ps --filter "name=bomerp-" -q)
```

`docker stop` (no `down`): deja los contenedores creados, listos para un `docker start (docker ps -a --filter "name=bomerp-" -q)` rápido la próxima vez, en vez de recrearlos desde cero con `compose up`.

## Onboarding Futuro

Pendiente: flujo de trabajo por curso y por grupo, convenciones de ramas y entregables, y el mismo arranque rápido para ADS y BD2 cuando tengan su propio proyecto ejecutable (hoy son entregables de documentación, sin backend/frontend propios).
