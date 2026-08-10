# ADS - Diseño técnico de BomERP

Workspace de documentación/diseño del curso **Análisis y Diseño de Sistemas
de Información** dentro del monorepo `bomerp` (que también incluye `lp2/`,
`bd2/`, `docs/` para las otras asignaturas del ciclo 4). Este archivo
aplica solo a lo que está bajo `ads/`.

## Formatos y herramientas (no hay "ambientes" de ejecución)

A diferencia de LP2, ADS no produce código ejecutable, así que no existen
ambientes local/producción, `.env` ni `compose-local.yml`. Lo más parecido
a esa distinción es el **formato del artefacto**:

- Los artefactos son documentos **Markdown versionados en git**, con
  diagramas **Mermaid embebidos** (`flowchart`, etc.) para vistas C4,
  modelo de dominio, secuencia y actividades — mismo formato que ya usa
  `docs/proyecto-integrador/u1/ads-producto.md` como referencia.
- El sílabo solo pide "Herramientas de modelado UML/C4" sin prescribir cuál;
  el criterio por defecto de este repo es Markdown + Mermaid (se ve
  directo en GitHub/MkDocs sin plugin adicional). Si el equipo prefiere
  otra herramienta (draw.io, PlantUML, etc.), se adjunta el export junto al
  `.md` que lo explica, no se reemplaza el `.md`.
- No hay build ni versión de runtime que fijar aquí.

## Dónde está cada cosa

- **`ads/` (este workspace)**: carpetas `01-requerimientos`,
  `02-arquitectura-c4`, `03-modelo-dominio`, `04-uml`, `05-adrs`, cada una
  con un `README.md` que lista su "Contenido Esperado". Hoy están **vacías
  salvo el README** — son la plantilla que cada grupo llena con el diseño
  de "el módulo BOM ERP asignado al grupo" (ver
  `ads/01-requerimientos/README.md`).
- **Documentación pedagógica** (sílabo, sesiones, alcance): siempre en
  `docs/ads/` en la raíz del repo, nunca dentro de `ads/`. En concreto:
  - `docs/ads/silabo_ads_2026_2.md` — sílabo oficial **vigente** (no
    editar salvo pedido explícito). También existe
    `docs/ads/silabo_ads_2026_1.md`, de un ciclo anterior — no es el
    vigente, no confundir.
  - `docs/ads/sesiones/S0X_*.md` — rúbrica/plantilla genérica por sesión
    (S01 a S16).
  - `docs/ads/index.md` — alcance por unidad/sesión, con enlaces a los
    productos de referencia en `docs/proyecto-integrador/`.
  - **No existen** `docs/ads/adr/` ni `docs/ads/plan-trabajo.md` (a
    diferencia de `docs/lp2/adr/` y `docs/lp2/plan-trabajo.md`) — ver
    "Fuera de alcance" más abajo sobre cómo tratar ese hueco.
- **`docs/proyecto-integrador/{index.md, u1,u2,u3}/ads-producto.md`**: no
  son la plantilla de tu entrega, son el **ejemplo de referencia** que ata
  las decisiones de ADS al código real ya versionado en
  `lp2/bomerp-backend` y a `docs/lp2/adr/ADR-00X`. Sirven para calibrar
  nivel de detalle y trazabilidad esperado, no para copiar tal cual (el
  módulo/dominio asignado a tu grupo puede ser otro).
- **Skills**: `ads/.claude/skills/` (p. ej. `ads-sesion`, scoped a este
  directorio).

## Relación con LP2 (consistencia obligatoria, no opcional)

ADS y LP2 comparten el mismo caso — el dominio heredado de Ciclo 3
(`Producto`, `Categoria`, `Venta`, `DetalleVenta`, `Usuario`, ver
`docs/proyecto-integrador/index.md` §2) — y el Proyecto Integrador excluye
explícitamente como evidencia válida "diseño técnico que no se refleja en
la aplicación" y "backend y frontend sin trazabilidad con ADS"
(`docs/proyecto-integrador/index.md`, sección "No se considera proyecto
integrador"). Esto no es una relación inferida: está documentada.

Evidencia concreta de esa trazabilidad, ya en el repo:
`docs/proyecto-integrador/u1/ads-producto.md` dibuja la vista C3 del
backend nombrando los mismos paquetes de módulo que existen o existirán en
`lp2/bomerp-backend/src/main/java/pe/edu/upeu/bomerp` (`catalogo`,
`ventas`, y luego `inventario`/`compras`/`seguridad`), y remite a las ADR
reales de arquitectura del backend (`docs/lp2/adr/ADR-001`, `ADR-002`,
`ADR-003`) como decisiones "ya formalizadas... verificadas contra el
código (`mvnw test`), no solo documentadas aquí".

Por eso: cuando produzcas `02-arquitectura-c4/` o `05-adrs/` para el
módulo asignado a tu grupo, si ese módulo ya tiene código en
`lp2/bomerp-backend`, el diagrama de componentes y los ADR deben usar los
mismos nombres de paquete/servicio que el backend ya implementa — no
inventes nombres de módulo distintos. Si el backend todavía no llegó a esa
parte, dilo explícitamente como "previsto para S0X" en vez de simularlo
como si ya existiera (mismo criterio que usa `ads-producto.md` de U1 con
sus ADR "aún no formalizadas").

## Cómo avanzar sesión a sesión

1. Usar el skill `ads-sesion` (o seguir su mismo procedimiento a mano):
   leer `docs/ads/index.md` + `docs/ads/sesiones/S0X_*.md` +
   `docs/ads/silabo_ads_2026_2.md` (criterios de evaluación de la unidad)
   + el `ads-producto.md` de referencia de esa unidad en
   `docs/proyecto-integrador/`, revisar qué ya existe en `ads/0X-.../` del
   grupo, y producir **solo** el incremento de esa sesión.
2. Verificar completitud contra la rúbrica de la sesión (ver sección
   "Verificación" del skill `ads-sesion`) — ADS no tiene tests
   automatizados, la verificación es una revisión manual de checklist.
3. No existe hoy `docs/ads/plan-trabajo.md`: si se quiere llevar estado de
   avance sesión a sesión como en LP2, créalo solo si el usuario lo pide
   explícitamente — no por iniciativa propia (ver "Fuera de alcance").
4. Si la sesión formaliza una decisión arquitectónica del módulo asignado
   (no solo completar una plantilla), regístrala como ADR nueva en
   `ads/05-adrs/ADR-000X-titulo-de-la-decision.md`, con el formato de
   `ads/05-adrs/README.md` (contexto, decisión, consecuencias,
   alternativas consideradas).

## Fuera de alcance salvo pedido explícito

- No modificar `docs/ads/sesiones/*`, `docs/ads/index.md`,
  `docs/ads/silabo_ads_*.md`, ni `docs/proyecto-integrador/**` — son
  contenido pedagógico/de referencia publicado del curso.
- No adelantar alcance de sesiones futuras (p. ej. no diseñar integración
  con IA en S2; eso es S11-S14).
- No crear `docs/ads/adr/` ni `docs/ads/plan-trabajo.md` por iniciativa
  propia — hoy no existen (a diferencia de LP2). Si el usuario los pide,
  seguir la misma convención de `docs/lp2/`.
- No generar código de aplicación dentro de `ads/` — eso corresponde a
  `lp2/`.
