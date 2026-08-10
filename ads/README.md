# ADS — Diseño técnico de BomERP

Workspace de documentación/diseño del curso **Análisis y Diseño de Sistemas
de Información**, dentro del monorepo `bomerp` (que también incluye
`lp2/` — backend/frontend —, `bd2/` — base de datos — y `docs/` —
documentación pedagógica de todo el ciclo). Este README aplica solo a lo
que está bajo `ads/`.

## Qué es esta carpeta

ADS **no produce código ejecutable**. Produce artefactos de diseño:
documentos **Markdown versionados en git**, con diagramas **Mermaid
embebidos** (`flowchart`, diagramas de secuencia, etc.) para vistas C4,
modelo de dominio, UML y ADR. No hay build, no hay tests automatizados, no
hay ambientes local/producción — el "entregable" es el propio `.md`
renderizado en GitHub.

El formato de referencia es `docs/proyecto-integrador/u1/ads-producto.md`
(fuera de esta carpeta): muestra el nivel de detalle y el estilo Markdown +
Mermaid esperado. Si un equipo prefiere otra herramienta de modelado
(draw.io, PlantUML, etc.), el export se adjunta junto al `.md` que lo
explica — no lo reemplaza.

## Qué produce cada subcarpeta

Cada una tiene su propio `README.md` con el "Contenido Esperado" completo.
Hoy todas están **vacías salvo ese README** — son la plantilla que cada
grupo llena con el diseño del módulo BOM ERP que le fue asignado:

| Carpeta | Qué documenta |
|---|---|
| [`01-requerimientos/`](01-requerimientos/README.md) | Actores, requerimientos funcionales/no funcionales, reglas de negocio, casos de uso, matriz de trazabilidad. |
| [`02-arquitectura-c4/`](02-arquitectura-c4/README.md) | Vistas C4 (contexto, contenedores, componentes, despliegue) y justificación de las decisiones arquitectónicas. |
| [`03-modelo-dominio/`](03-modelo-dominio/README.md) | Entidades, objetos de valor, relaciones, reglas de negocio y glosario del dominio. |
| [`04-uml/`](04-uml/README.md) | Diagramas de clases, secuencia, actividades y estados. |
| [`05-adrs/`](05-adrs/README.md) | Decisiones arquitectónicas formales (`ADR-000X-titulo.md`): contexto, decisión, consecuencias, alternativas consideradas. |

## Relación de trazabilidad con LP2 (obligatoria, no opcional)

ADS y LP2 comparten el mismo caso — el dominio heredado de Ciclo 3
(`Producto`, `Categoria`, `Venta`, `DetalleVenta`, `Usuario`) — y el
Proyecto Integrador excluye explícitamente como evidencia válida "diseño
técnico que no se refleja en la aplicación" y "backend y frontend sin
trazabilidad con ADS" (`docs/proyecto-integrador/index.md`, sección "No se
considera proyecto integrador"). No es una relación inferida: está
documentada y ya tiene un ejemplo real en el repo.

`docs/proyecto-integrador/u1/ads-producto.md` dibuja la vista C3 del
backend nombrando los mismos paquetes de módulo que existen o existirán en
`lp2/bomerp-backend/src/main/java/pe/edu/upeu/bomerp` (`catalogo`,
`ventas`, y luego `inventario`/`compras`/`seguridad`), y remite a las ADR
reales de arquitectura del backend — [ADR-001](../docs/lp2/adr/ADR-001-arquitectura-backend.md),
[ADR-002](../docs/lp2/adr/ADR-002-spring-modulith.md),
[ADR-003](../docs/lp2/adr/ADR-003-spring-boot-4.md) en `docs/lp2/adr/` —
como decisiones "ya formalizadas... verificadas contra el código
(`mvnw test`), no solo documentadas aquí".

Consecuencia práctica para cualquier artefacto que produzcas en
`02-arquitectura-c4/` o `05-adrs/`:

- Si el módulo asignado ya tiene código en `lp2/bomerp-backend`, el
  diagrama de componentes y los ADR deben usar los **mismos nombres de
  paquete/servicio** que el backend ya implementa — no inventes nombres de
  módulo distintos.
- Si el backend todavía no llegó a esa parte, dilo explícitamente como
  "previsto para S0X" en vez de simularlo como si ya existiera (mismo
  criterio que usa `ads-producto.md` de U1 con sus ADR "aún no
  formalizadas").
- Mantén nombres consistentes entre subcarpetas: el modelo de dominio de
  `03-modelo-dominio` debe usar las mismas entidades que `04-uml`, y la
  vista de componentes de `02-arquitectura-c4` debe usar los mismos
  nombres de módulo que `05-adrs`.

## Cómo se verifica un entregable

ADS no tiene build ni tests automatizados: la verificación es una
**revisión de completitud manual** contra dos fuentes:

1. El **"Contenido Esperado"** del `README.md` de la subcarpeta usada
   (tabla de arriba) — checklist mínimo de esa carpeta.
2. Los **"Criterios de evaluación del producto"** de la unidad
   correspondiente en `docs/ads/silabo_ads_2026_2.md` (sección V) — la
   rúbrica oficial del curso. Por ejemplo, la Unidad 1 exige poder observar
   "Representa vistas arquitectónicas mediante C4 o equivalente", "Define
   límites, responsabilidades y componentes del sistema", "Aplica
   principios SOLID...", etc.

Un entregable está completo cuando cada ítem de ambas listas está cubierto
explícitamente por el artefacto, o marcado como pendiente/no aplicable de
forma explícita (nunca omitido en silencio).

## Dónde está la documentación pedagógica

El sílabo, las sesiones y el alcance del curso viven en `docs/ads/` (raíz
del repo), **nunca dentro de `ads/`**:

- `docs/ads/silabo_ads_2026_2.md` — sílabo oficial vigente. (También existe
  `docs/ads/silabo_ads_2026_1.md`, de un ciclo anterior; no confundir.)
- `docs/ads/sesiones/S0X_*.md` — rúbrica/plantilla por sesión (S01 a S16).
- `docs/ads/index.md` — alcance por unidad/sesión, con enlaces a los
  productos de referencia en `docs/proyecto-integrador/`.

`docs/proyecto-integrador/{index.md, u1,u2,u3}/ads-producto.md` no es la
plantilla de tu entrega: es el **ejemplo de referencia** que ata las
decisiones de ADS al código real de LP2 y a sus ADR. Sirve para calibrar
nivel de detalle y trazabilidad, no para copiar tal cual (el módulo
asignado a tu grupo puede ser otro).

## Trabajar con Claude Code en esta carpeta

Si avanzas sesiones de ADS con Claude Code, usa el skill
[`ads-sesion`](.claude/skills/ads-sesion/SKILL.md) (`ads/.claude/skills/`),
que automatiza el flujo de lectura de sílabo/sesión/rúbrica y producción
del incremento. Este README es la referencia de fondo que ese skill
asume conocida; no la repite.
