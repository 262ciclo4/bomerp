# Plan de trabajo ADS

Este documento es el rastreador vivo de avance de las guías de sesión de
ADS (`docs/ads/sesiones/`). No confundir con el sílabo (contenido oficial,
en `silabo_ads_2026_2.md`) ni con `CLAUDE.md` (guía operativa de dónde vive
cada cosa en el repositorio).

## Estado actual

- **Reinicio del repositorio (2026-08)**: se eliminaron físicamente
  `S02_*.md` a `S16_*.md` de `docs/ads/sesiones/` (no solo se ocultaron del
  menú) — el repo se está reconstruyendo sesión por sesión desde S01, con
  un tag de git congelado al cerrar cada sesión. El contenido de esas
  sesiones (ya verificado contra `silabo_ads_2026_2.md` en una revisión
  anterior, sin problemas de fondo) no se conserva localmente; se
  reconstruye cuando corresponda avanzar cada sesión.
- **S1**: única sesión existente hoy. Alineada a la plantilla ampliada
  (Índice, Metodología, Motivación/1.6.1 Caso, Hoja de ruta en Aplica,
  bullet "Producto del curso"). Publicada en `mkdocs.yml`.
- El curso no tiene código propio: produce artefactos de diseño Markdown.
  `ads/01-requerimientos/`, `02-arquitectura-c4/`, etc. son plantillas en
  blanco para cada grupo (ver `ads/README.md`) — no se llenan desde aquí.
  El artefacto de referencia real es
  `docs/proyecto-integrador/u1/ads-producto.md`, ya construido y verificado
  contra el código real de LP2 y las ADR de `docs/lp2/adr/`.
- **Proyecto Integrador**: el hub compartido con BD2 y LP2 vive en
  `docs/proyecto-integrador/` (fuera de `docs/ads/`) — no se toca desde
  este plan.

## Cómo se continúa

1. Leer el alcance oficial de la sesión en `silabo_ads_2026_2.md` (fila de
   esa sesión) y en `docs/ads/index.md`.
2. Usar `docs/ads/sesiones/S01_Fundamentos_Arquitectura_Software.md` como
   referencia estructural exacta: 1.1 Contexto, 1.2 Índice, 1.3 Propósito
   de aprendizaje, 1.4 Producto de sesión, 1.5 Metodología, 1.6
   Motivación/1.6.1 Caso, 1.7 Ubicación en el curso; Hoja de ruta antes de
   3.1; 4.1.1-4.1.5 en h4; sin agregar el cierre "Metodología para
   resolver problemas" (exclusivo de FP/POO).
3. Mantener los mismos valores de `Tiempo:` (20min/25min/2h/2h fuera del
   aula/20min) — no recalcular.
4. Publicar la sesión en `mkdocs.yml` y cerrar con un tag de git
   (`s02`, `s03`, ...) una vez verificada.

## Hoja de ruta

| Sesión | Foco | Estado |
|---|---|---|
| S1 | Fundamentos de Arquitectura de Software | Hecho (plantilla alineada) |
| S2 | Modelo C4 y Vistas Arquitectónicas | Pendiente (reconstruir) |
| S3 | Diseño Estructural y Principios SOLID | Pendiente (reconstruir) |
| S4 | Arquitecturas Modernas | Pendiente (reconstruir) |
| S5 | Evaluación Unidad 1 | Pendiente (reconstruir) |
| S6 | Descubrimiento y Modelado del Dominio | Pendiente (reconstruir) |
| S7 | Diseño de Clases del Dominio | Pendiente (reconstruir) |
| S8 | Diseño de Clases Avanzado y Transformación Objeto-Relacional | Pendiente (reconstruir) |
| S9 | Diagramas Dinámicos UML | Pendiente (reconstruir) |
| S10 | Patrones de Diseño y Arquitectura Empresarial | Pendiente (reconstruir) |
| S11 | Integración y Sistemas Empresariales | Pendiente (reconstruir) |
| S12 | Evaluación Unidad 2 | Pendiente (reconstruir) |
| S13 | Integración del Diseño Técnico | Pendiente (reconstruir) |
| S14 | Decisiones Arquitectónicas y Trazabilidad | Pendiente (reconstruir) |
| S15 | Sustentación del Diseño Técnico Profesional | Pendiente (reconstruir) |
| S16 | Evaluación Final | Pendiente (reconstruir) |
