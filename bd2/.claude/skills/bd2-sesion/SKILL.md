---
name: bd2-sesion
description: Implementa el incremento de scripts SQL/PL-SQL de una sesión de BD2 (S1 a S16) sobre la base Oracle de BomERP, respetando el sílabo vigente y la evidencia de sesiones previas. Usar cuando se pida "avanza la sesión SXX de BD2", "implementa S0X de BD2" o "continúa con la siguiente sesión de BD2".
---

# Sesión de BD2 (BomERP - Oracle)

Este skill implementa **una sola sesión** del curso BD2 sobre los
artefactos de `bd2/` (este directorio) y, cuando corresponda, sobre los
scripts de referencia de `docs/proyecto-integrador/`. No mezcla el
trabajo de dos sesiones ni adelanta alcance de sesiones futuras.

BD2 no tiene build ni proyecto que compilar: el incremento de sesión es
uno o más scripts `.sql`/`.md` de evidencia, verificados ejecutándolos
contra una instancia Oracle real.

## Antes de escribir SQL

1. Identifica el número de sesión (S1 a S16). Si no se especifica, revisa
   qué scripts existen ya en `bd2/oracle/schemas/`, `bd2/oracle/plsql/`,
   `bd2/tuning/`, `bd2/security/`, `bd2/backup-recovery/` y en
   `docs/proyecto-integrador/{u1,u2,u3}/oracle/` para detectar el avance
   real y continuar con la siguiente sesión del sílabo.
2. Lee `docs/bd2/index.md` (raíz del repo) para el producto de unidad y el
   roadmap general.
3. Lee `docs/bd2/sesiones/S0X_*.md` para la rúbrica. **Ojo**: solo `S01` y
   `S02` traen el caso BomERP completamente desarrollado (esquema
   `BOM_CATALOGO`, scripts enlazados, resultado esperado literal). De
   `S03` en adelante (excepto `S06`, `S12`, `S16`, que son evaluaciones)
   la guía es una **plantilla genérica de 98 líneas** con campos en
   blanco — no asumas que ya trae el detalle concreto de BomERP.
4. Cuando la guía de sesión sea genérica, deriva el contenido técnico
   concreto de la fila correspondiente en el sílabo vigente
   (`docs/bd2/silabo_bd2_2026_2.md`, tabla "Sesiones de aprendizaje" de la
   unidad) y de los scripts de referencia ya publicados para esa unidad en
   `docs/proyecto-integrador/{u1,u2,u3}/oracle/` — no inventes alcance que
   no esté en ninguno de los dos.
5. Inspecciona lo que ya existe en `bd2/<subcarpeta>` correspondiente y en
   `docs/proyecto-integrador/` antes de agregar nada, para no repetir un
   esquema/objeto ya creado en una sesión anterior.

## Reglas al implementar

- Implementa **solo el incremento de la sesión pedida**, ni más ni menos.
  Ejemplo: en S2 se agregan los triggers de auditoría sobre
  `BOM_CATALOGO.producto` — no se toca `BOM_VENTAS` ni `BOM_SEGURIDAD`
  todavía (esos esquemas se crean recién cuando el sílabo/LP2 los
  necesite por primera vez, S4 y S10 respectivamente).
- Un esquema Oracle por módulo funcional (`BOM_<MODULO>`), coherente con
  `@Table(schema = "BOM_<MODULO>")` del lado de LP2 (ver
  `../../../CLAUDE.md` y `docs/lp2/adr/ADR-002-spring-modulith.md`). No
  crear esquemas nuevos "por si acaso".
- Usuario propietario del esquema con privilegios de creación de objetos,
  separado del usuario técnico de aplicación (`BOMERP_APP`, mínimo
  privilegio vía `GRANT` puntual, nunca DBA) — mismo patrón que
  `docs/proyecto-integrador/u1/oracle/S01_01_esquemas.sql`.
- Objetos PL/SQL con prefijo por tipo y schema-calificados: `sp_` para
  procedimientos, `fn_` para funciones (p. ej. `BOM_CATALOGO.sp_...`),
  siguiendo el estilo de `S01_03_plsql.sql` y
  `S02_triggers_dml_auditoria.sql`.
- Guarda el script nuevo en el subdirectorio de `bd2/` que corresponda al
  tema de la sesión (ver mapeo en `../../../CLAUDE.md`, sección "Cómo
  avanzar sesión a sesión"). Si el tema no calza limpio en ningún
  subdirectorio existente (p. ej. S07 arquitectura de instancia, S14
  monitoreo), dilo explícitamente en vez de forzar el encaje o crear una
  carpeta nueva sin que se pida.
- Respeta la numeración ya usada en la unidad: U1 usa `S0X_NN_tema.sql`
  (un archivo por sesión); U2/U3 usan `NN_tema.{sql,md}` sin prefijo de
  sesión, agrupando varias sesiones por tema. No inventes una convención
  nueva para una unidad que ya tiene la suya.
- Ambiente local (U1): credenciales en texto plano (`123456`), igual
  criterio que `application-local.yml` de LP2 — nunca `.env`. Ambiente
  U2/U3 (Oracle 19c EE + Oracle Linux): no está operacionalizado en este
  repo todavía; no asumas Docker ni una VM concreta sin confirmarlo. Para
  el onboarding completo (cómo levantar el contenedor de U1, credenciales,
  cliente gráfico) ver [`../../../README.md`](../../../README.md) — no lo
  dupliques aquí.

## Verificación

BD2 no tiene equivalente a `mvn test`: no hay suite automatizada. La
verificación real es:

1. Ejecutar el script contra una instancia Oracle real (comandos de
   conexión completos en [`../../../README.md`](../../../README.md)):
   - U1: contenedor `bomerp-oracle` (compartido con LP2), vía `sqlplus`
     dentro del contenedor o cliente gráfico.
   - U2/U3: instancia Oracle 19c EE / Oracle Linux — no disponible en
     este repo, indícalo como **paso manual pendiente**, no lo des por
     hecho ni simules el resultado.
2. Capturar la misma evidencia que usa S01/S02: salida de
   `DBMS_OUTPUT.PUT_LINE` con el resultado esperado, más una consulta
   `SELECT`/`DESC` que confirme el estado final (fila insertada, objeto
   compilado sin errores, trigger disparado, etc.).
3. Para temas de Unidad 3 (backup/recovery, monitoreo), contrasta contra
   el checklist manual de
   `docs/proyecto-integrador/u3/oracle/04_operational_checklist.md` en
   vez de asumir un chequeo automático.
4. Si la sesión pide evidencia de herramienta gráfica (Enterprise Manager
   Express, AWR report), indícalo como captura/pantallazo manual — no es
   algo que este skill pueda generar por sí solo.

## Al terminar

Resume en 3-5 líneas qué scripts se crearon o modificaron, en qué
esquema/objetos quedaron, qué evidencia de ejecución se obtuvo (o qué
paso manual queda pendiente si no había instancia Oracle disponible), y
qué queda para la siguiente sesión.
