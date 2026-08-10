---
name: ads-sesion
description: Produce el artefacto de diseño de una sesión de ADS (S1 a S16) para el módulo BOM ERP asignado al grupo, dentro de ads/, respetando el sílabo y manteniendo consistencia con el código real de LP2 cuando exista. Usar cuando se pida "avanza la sesión SXX de ADS", "produce/implementa S0X de ADS" o "continúa con la siguiente sesión de ADS".
---

# Sesión de ADS (BomERP)

Este skill produce **una sola sesión** del curso ADS sobre los artefactos
de `ads/` (este directorio). No mezcla el trabajo de dos sesiones ni
adelanta alcance de sesiones futuras.

Antes de usarlo, si no conoces el workspace, lee
[`ads/README.md`](../../../README.md): ahí está el onboarding completo
(qué produce cada subcarpeta, la relación de trazabilidad obligatoria con
LP2, y cómo se verifica un entregable). Este skill no repite esa
explicación — solo el procedimiento de sesión.

## Antes de producir el artefacto

1. Identifica el número de sesión (S1, S2, ... S16). Si no se especifica,
   revisa qué subcarpetas de `ads/` (`01-requerimientos` ...
   `05-adrs`) ya tienen contenido más allá del `README.md` para detectar
   la última sesión completada y continúa con la siguiente.
2. Lee `docs/ads/silabo_ads_2026_2.md` (raíz del repo) — sección V, la
   unidad y fila de sesión correspondiente: contenido, actividad práctica
   y sobre todo los **"Criterios de evaluación del producto"** de esa
   unidad, que son la rúbrica oficial.
3. Lee `docs/ads/index.md` para el alcance narrativo de la unidad y los
   enlaces a los productos de referencia.
4. Lee `docs/ads/sesiones/S0X_*.md` para la plantilla/rúbrica específica
   de esa sesión.
5. Revisa el `ads-producto.md` de la unidad correspondiente en
   `docs/proyecto-integrador/{u1,u2,u3}/ads-producto.md` — es un
   **ejemplo de referencia**, no una plantilla a copiar: muestra el nivel
   de detalle y de trazabilidad esperado, incluida la forma de enlazar con
   `docs/lp2/adr/` y con el código real de `lp2/bomerp-backend`.
6. Si el módulo asignado al grupo ya tiene código en
   `lp2/bomerp-backend/src/main/java/pe/edu/upeu/bomerp`, revísalo antes
   de diagramar — los nombres de paquete/servicio del diagrama de
   componentes y del modelo de dominio deben coincidir con lo que el
   backend ya implementa (o, si LP2 aún no llegó a esa sesión, con lo que
   `docs/lp2/index.md` tiene planeado).
7. Revisa el contenido actual de la subcarpeta `ads/0X-.../` (README + lo
   que el grupo ya produjo) para no repetir ni contradecir trabajo previo.

## Reglas al producir el artefacto

- Produce **solo el incremento de la sesión pedida**, ni más ni menos.
  Ejemplo: en S2 (Modelo C4) se elaboran C1 y C2; C3/C4 y vista de
  despliegue no son obligatorias hasta que el sílabo las pida en sesiones
  posteriores.
- Formato por defecto: Markdown + diagramas **Mermaid embebidos** (ver
  `docs/proyecto-integrador/u1/ads-producto.md` como referencia de
  formato), salvo que el usuario pida explícitamente otra herramienta.
- Coloca el artefacto en la subcarpeta de `ads/` que corresponda
  (`01-requerimientos`, `02-arquitectura-c4`, `03-modelo-dominio`,
  `04-uml` o `05-adrs`) según el "Contenido Esperado" de su `README.md` —
  no mezcles el contenido de dos subcarpetas en un mismo archivo.
- Los ADR van en `ads/05-adrs/ADR-000X-titulo-de-la-decision.md` (formato
  numerado, ver `README.md` de esa carpeta), con contexto, decisión,
  consecuencias y alternativas consideradas.
- Mantén **consistencia de nombres** (módulos, entidades, endpoints) entre
  subcarpetas: el modelo de dominio de `03-modelo-dominio` debe usar las
  mismas entidades que `04-uml`, y la vista de componentes de
  `02-arquitectura-c4` debe usar los mismos nombres de módulo que
  `05-adrs` y que, si existe, el código real de `lp2/bomerp-backend`.
- No inventes trazabilidad con LP2/BD2 que no exista: si el backend real
  todavía no implementó el módulo, dilo explícitamente como "previsto para
  S0X" (mismo criterio que usa `docs/proyecto-integrador/u1/ads-producto.md`
  con decisiones "aún no formalizadas").
- No adelantes alcance de unidades futuras (p. ej. no diseñar integración
  con servicios de IA en S2; eso es S11).

## Verificación

Sigue el procedimiento de verificación descrito en la sección "Cómo se
verifica un entregable" de [`ads/README.md`](../../../README.md) (checklist
del `README.md` de la subcarpeta + criterios de evaluación del sílabo).
Recorre cada criterio de esas dos listas y confirma explícitamente en tu
respuesta qué parte del artefacto producido cubre cada ítem; si algo queda
pendiente o no aplica a esta sesión, dilo en vez de omitirlo.

## Al terminar

Resume en 3-5 líneas qué artefacto se produjo, en qué subcarpeta de
`ads/` quedó, qué criterios de la rúbrica de esa sesión cubre, y qué queda
pendiente para la siguiente sesión.
