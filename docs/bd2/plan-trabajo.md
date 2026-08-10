# Plan de trabajo BD2

Este documento es el rastreador vivo de avance de las guías de sesión de
BD2 (`docs/bd2/sesiones/`). No confundir con el sílabo (contenido oficial,
en `silabo_bd2_2026_2.md`) ni con `CLAUDE.md` (guía operativa de dónde vive
cada cosa en el repositorio).

## Estado actual

- **Reinicio del repositorio (2026-08)**: se eliminaron físicamente
  `S02_*.md` a `S16_*.md` de `docs/bd2/sesiones/` (no solo se ocultaron del
  menú) — el repo se está reconstruyendo sesión por sesión desde S01, con
  un tag de git congelado al cerrar cada sesión.
- **S1**: única sesión existente hoy. Alineada a la plantilla ampliada, y
  **verificada de punta a punta contra la Oracle real** (`bomerp-oracle`,
  contenedor compartido con LP2, `gvenzl/oracle-free:23-slim`): el esquema
  `BOM_CATALOGO` y sus tablas ya existen (los crea LP2 S1); se ejecutó
  `S01_03_plsql.sql` (función y 2 procedimientos) contra esa base, y se
  corrió el bloque de prueba de la sección 3.6 — encontró y corrigió un bug
  real (faltaba un `INSERT` de categoría antes de la prueba, causaba
  `ORA-02291`). Publicada en `mkdocs.yml`.
- Código de referencia SQL en `bd2/` (`oracle/`, `security/`, `tuning/`,
  `backup-recovery/`) y los scripts ejecutables de sesión en
  `docs/proyecto-integrador/u1/oracle/` (`S01_01_esquemas.sql`,
  `S01_02_tablas.sql`, `S01_03_plsql.sql`).
- Recordatorio ya documentado en `CLAUDE.md`: el `docker-compose` real de
  S1 usa `gvenzl/oracle-free:23-slim` (Oracle 23ai Free), mientras el
  sílabo pide Oracle 19c EE + Oracle Linux para U2-U3 — sigue sin
  operacionalizar, no es parte de este plan de plantillas.
- **Proyecto Integrador**: el hub compartido con ADS y LP2 vive en
  `docs/proyecto-integrador/` (fuera de `docs/bd2/`) — no se toca desde
  este plan.

## Cómo se continúa

1. Leer el alcance oficial de la sesión en `silabo_bd2_2026_2.md` (fila de
   esa sesión) y en `docs/bd2/index.md`.
2. Usar `docs/bd2/sesiones/S01_PLSQL_Aplicado_Negocio.md` como referencia
   estructural exacta: 1.1 Contexto, 1.2 Índice, 1.3 Propósito de
   aprendizaje, 1.4 Producto de sesión, 1.5 Metodología, 1.6 Motivación/
   1.6.1 Caso, 1.7 Ubicación en el curso; Hoja de ruta antes de 3.1;
   4.1.1-4.1.5 en h4; sin agregar el cierre "Metodología para resolver
   problemas" (exclusivo de FP/POO).
3. Mantener los mismos valores de `Tiempo:` (20min/25min/2h/2h fuera del
   aula/20min) — no recalcular.
4. Escribir los scripts SQL en `docs/proyecto-integrador/u1/oracle/` (o la
   unidad que corresponda) y **ejecutarlos contra `bomerp-oracle` real**
   antes de dar la sesión por cerrada — no basta con que el script esté
   escrito, hay que correrlo y verificar la salida.
5. Publicar la sesión en `mkdocs.yml` y cerrar con un tag de git (`s02`,
   `s03`, ...) una vez verificada.

## Hoja de ruta

| Sesión | Foco | Estado |
|---|---|---|
| S1 | PL/SQL aplicado al negocio | Hecho (plantilla alineada + verificado contra Oracle real) |
| S2 | Triggers DML y auditoría básica | Pendiente (reconstruir) |
| S3 | Manejo de excepciones y robustez | Pendiente (reconstruir) |
| S4 | Optimización de consultas SQL | Pendiente (reconstruir) |
| S5 | Índices para optimización | Pendiente (reconstruir) |
| S6 | Evaluación Unidad 1 | Pendiente (reconstruir) |
| S7 | Arquitectura Oracle e instancia | Pendiente (reconstruir) |
| S8 | Gestión de usuarios, roles y privilegios | Pendiente (reconstruir) |
| S9 | Administración del almacenamiento y seguridad | Pendiente (reconstruir) |
| S10 | Optimización del rendimiento (AWR) | Pendiente (reconstruir) |
| S11 | Particionamiento y escalabilidad | Pendiente (reconstruir) |
| S12 | Evaluación Unidad 2 | Pendiente (reconstruir) |
| S13 | Backup y Recovery con RMAN | Pendiente (reconstruir) |
| S14 | Monitoreo y diagnóstico | Pendiente (reconstruir) |
| S15 | Sustentación del producto final del curso | Pendiente (reconstruir) |
| S16 | Evaluación final individual | Pendiente (reconstruir) |
