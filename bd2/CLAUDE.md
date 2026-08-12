# BD2 - BomERP Oracle (Administración de Base de Datos II)

Workspace de artefactos del curso **Administración de Base de Datos II**
dentro del monorepo `bomerp` (que también incluye `ads/`, `lp2/`, `docs/`
para las otras asignaturas del ciclo). Este archivo aplica solo a lo que
está bajo `bd2/`.

BD2 no es un proyecto Spring Boot ni tiene build propio: es un curso de
administración avanzada de Oracle. Su "código" son scripts SQL/PL-SQL y
evidencia de ejecución contra una instancia Oracle real, no un artefacto
que se compila. BD2 continúa el modelo físico que BD1 (ciclo 3,
`262ciclo3/bomstart/bd1`) dejó preparado, y provee los esquemas que LP2
consume vía JPA (convención `BOM_<MODULO>` en `@Table(schema = ...)`, ver
[ADR-002 de LP2](../docs/lp2/adr/ADR-002-spring-modulith.md)).

## Ambientes

- **U1 (S1-S6): Oracle XE local.** Contenedor `bomerp-oracle`, base
  `FREEPDB1`, puerto `1521`. Se administra con `sqlplus` dentro del
  contenedor: `docker exec -it bomerp-oracle sqlplus system/123456@localhost:1521/FREEPDB1`.
  Mismo criterio que LP2: **sin `.env`**, contraseñas en texto plano
  (`123456`) porque son valores de laptop de desarrollo, no secretos (ver
  `docs/bd2/sesiones/S01_PLSQL_Aplicado_Negocio.md`, 3.2). La contraseña de
  `BOMERP_APP` debe coincidir exactamente con `application-local.yml` de
  `lp2/bomerp-backend`.
- **U2-U3 (S7-S16): Oracle Database 19c EE + Oracle Linux**, según el
  sílabo (sección VII, "Recursos, medios y materiales") y el listado de
  arquitectura en `docs/index.md`. A diferencia de U1, este ambiente
  **todavía no está operacionalizado en el repo**: no hay `compose-*.yml`,
  script de aprovisionamiento ni instructivo de conexión concreto para él
  todavía — las sesiones S07 y S13, por ejemplo, son plantillas genéricas
  (ver más abajo, "Estado real de las sesiones") que no bajan a comandos
  específicos de conexión. No asumas Docker para este ambiente sin
  confirmarlo primero.
- No existe un ambiente de "producción" para BD2 (a diferencia de LP2 S13);
  el equivalente de BD2 a "preparación para producción" es la Unidad 3
  completa (backup, recovery, monitoreo, resiliencia).

## Dónde está cada cosa

- **`bd2/backup-recovery/`, `bd2/oracle/plsql/`, `bd2/oracle/schemas/`,
  `bd2/security/`, `bd2/tuning/`**: hoy son **scaffolding vacío** — cada
  una solo tiene un `README.md` con "Contenido Esperado" (p. ej.
  `bd2/oracle/plsql/README.md` describe procedimientos/funciones/triggers/
  paquetes/excepciones). No hay ningún script `.sql` real todavía en
  `bd2/`. No confundir esto con que el curso no tenga scripts: los scripts
  de referencia sí existen, pero viven en otro lugar (ver siguiente punto).
- **Scripts de referencia reales, ejecutables**, los que los `.md` de
  sesión enlazan directamente: `docs/proyecto-integrador/u1/oracle/`
  (`S01_01_esquemas.sql`, `S01_02_tablas.sql`, `S01_03_plsql.sql`,
  `S02_triggers_dml_auditoria.sql`), `docs/proyecto-integrador/u2/oracle/`
  (`01_security.sql`, `02_storage_audit.sql`, `03_partition_perf.sql`) y
  `docs/proyecto-integrador/u3/oracle/` (`01_rman_backup.md`,
  `02_recovery_scenario.md`, `03_monitoring_queries.sql`,
  `04_operational_checklist.md`). Ojo: la numeración **no es uniforme**
  entre unidades — U1 usa prefijo `S0X_NN_tema.sql` (uno por sesión), U2/U3
  usan `NN_tema.{sql,md}` sin prefijo de sesión y agrupan varias sesiones
  en pocos archivos temáticos. No fuerces una convención única al agregar
  archivos nuevos sin antes revisar el patrón ya usado en esa unidad.
- **Documentación** (sílabo, sesiones, roadmap): en `docs/bd2/` en la raíz
  del repo, nunca dentro de `bd2/`:
  - `docs/bd2/silabo_bd2_2026_1.md` y `docs/bd2/silabo_bd2_2026_2.md` —
    sílabos oficiales (no editar salvo pedido explícito; el vigente es
    `_2026_2.md`).
  - `docs/bd2/sesiones/S0X_*.md` — guía de sesión.
  - `docs/bd2/index.md` — visión de producto del curso y roadmap de las 3
    unidades (equivalente a `docs/lp2/index.md`, no una tabla granular
    adicional distinta a la del sílabo).
  - **No existe** `docs/bd2/adr/` (a diferencia de `docs/lp2/adr/`). Las
    decisiones de arquitectura que sí afectan a BD2 (p. ej. un esquema por
    módulo `BOM_<MODULO>`) están registradas del lado de LP2, en
    `docs/lp2/adr/ADR-002-spring-modulith.md`. Si se necesita una ADR
    propia de BD2, hay que crearla explícitamente siguiendo el mismo
    patrón (`docs/lp2/adr/ADR-NNN-*.md`) — no asumir que ya existe una
    carpeta `docs/bd2/adr/`. Tampoco existe `docs/bd2/plan-trabajo.md` —
    ningún curso del ciclo usa ya ese archivo.
- **Skills**: `bd2/.claude/skills/` (`bd2-sesion`, scoped a este
  directorio).

## Estado real de las sesiones (importante antes de "avanzar" una)

Las guías de sesión en `docs/bd2/sesiones/` **no tienen el mismo nivel de
detalle entre sí**:

- `S01` (508 líneas) y `S02` (352 líneas) están completamente desarrolladas
  con el caso concreto de BomERP (esquema `BOM_CATALOGO`, scripts
  enlazados, salida esperada literal, rúbrica).
- `S03`, `S04`, `S05`, `S07`-`S11`, `S13`-`S15` son **plantillas genéricas
  de 98 líneas** (secciones con campos en blanco tipo "Dominio del
  equipo: ___", "Concepto central de la sesión: ___"), sin el mismo nivel
  de script/resultado concreto que S01-S02.
- `S06`, `S12`, `S16` son sesiones de evaluación (34 líneas, sin
  contenido técnico nuevo).

Para cualquier sesión S03 en adelante, el contenido técnico concreto hay
que derivarlo de la fila correspondiente del sílabo
(`docs/bd2/silabo_bd2_2026_2.md`) y de los scripts de referencia de esa
unidad en `docs/proyecto-integrador/`, **no inventarlo**, y tampoco asumir
que la guía de sesión ya trae el mismo nivel de detalle que S01.

## Convenciones observadas (S01-S02, únicas sesiones con patrón concreto)

- Un esquema Oracle por módulo funcional: `BOM_CATALOGO` (S1; `BOM_VENTAS`
  y `BOM_SEGURIDAD` se crean recién cuando LP2 llegue a esos módulos, S4 y
  S10 respectivamente — mismo criterio de "no crear por si acaso" que usa
  LP2 con sus paquetes Java).
- Usuario propietario del esquema (`BOM_CATALOGO`, con
  `CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE PROCEDURE, CREATE TRIGGER`)
  separado del usuario técnico de aplicación (`BOMERP_APP`, solo
  `CREATE SESSION` + `GRANT`s puntuales sobre tablas concretas) — mínimo
  privilegio, nunca un usuario DBA para la app.
- Objetos PL/SQL con prefijo por tipo: `sp_` para procedimientos
  (`sp_registrar_producto`), `fn_` para funciones
  (`fn_valor_inventario_producto`), siempre schema-calificados
  (`BOM_CATALOGO.sp_...`).
- Evidencia de ejecución vía `DBMS_OUTPUT.PUT_LINE` con el resultado
  esperado documentado literal en el `.md` de la sesión, más una consulta
  `SELECT` de verificación posterior.

## Cómo avanzar sesión a sesión

1. Usar el skill `bd2-sesion` (o seguir su mismo procedimiento a mano):
   identificar la sesión, leer `docs/bd2/index.md` +
   `docs/bd2/sesiones/S0X_*.md` + la fila correspondiente del sílabo
   vigente (`docs/bd2/silabo_bd2_2026_2.md`), y revisar qué scripts de
   referencia ya existen en `docs/proyecto-integrador/{u1,u2,u3}/oracle/`
   para esa unidad.
2. Ubicar el script nuevo en el subdirectorio de `bd2/` que corresponda al
   tema (mapeo por contenido del sílabo, no por número de sesión):
   `bd2/oracle/plsql/` (S1-S3: procedimientos, funciones, triggers,
   excepciones), `bd2/oracle/schemas/` (creación/evolución de esquemas y
   tablas), `bd2/tuning/` (S4-S5, S10-S11: índices, Explain Plan,
   DBMS_STATS, AWR, particionamiento), `bd2/security/` (S8-S9: usuarios,
   roles, privilegios, auditoría), `bd2/backup-recovery/` (S13: RMAN, Data
   Pump, PITR). Sesiones S6, S7, S9 (parte de almacenamiento no-seguridad),
   S12, S14, S15, S16 no calzan limpio en un único subdirectorio existente
   — no forzar el encaje; dejarlo señalado en vez de inventar una carpeta.
3. Implementar **solo el incremento de esa sesión**, siguiendo el patrón
   de nombres y estilo de S01/S02 (única referencia con patrón real
   verificado) cuando el tema sea comparable.
4. Verificar ejecutando el script contra la instancia Oracle real (U1:
   `docker exec -it bomerp-oracle sqlplus ...`; U2/U3: instancia Oracle
   19c EE/Oracle Linux, no disponible por defecto en este entorno —
   indicarlo como paso manual si no hay acceso) y capturando la misma
   evidencia que usa S01 (salida de `DBMS_OUTPUT` + `SELECT` de
   verificación). **No existe** un equivalente a `mvn test`: no hay
   suite automatizada para BD2; la "prueba" es la ejecución real más la
   evidencia, o el checklist manual de
   `docs/proyecto-integrador/u3/oracle/04_operational_checklist.md` para
   temas de U3.
5. No hay `docs/bd2/plan-trabajo.md` que actualizar, ni lo hay ya en ningún
   otro curso del ciclo. Si se necesita un rastreador de avance, hay que
   proponerlo y crearlo explícitamente — no asumir su existencia.
6. Si la sesión implica una decisión de arquitectura propia de BD2 (no ya
   cubierta por las ADR de LP2), usar modo plan antes de escribir SQL y
   proponer registrar la decisión como ADR nueva (no existe todavía
   `docs/bd2/adr/`, habría que crear la carpeta la primera vez).

## Fuera de alcance salvo pedido explícito

- No modificar `docs/bd2/sesiones/*`, `docs/bd2/index.md` ni los
  sílabos — son contenido pedagógico publicado del curso.
- No adelantar alcance de sesiones futuras (p. ej. no crear `BOM_VENTAS`
  en S1 solo porque el sílabo la menciona más adelante).
- No asumir Docker/VM concretos para el ambiente U2-U3 (Oracle 19c EE +
  Oracle Linux) sin confirmarlo — a diferencia de U1, no está
  operacionalizado en este repo todavía.
