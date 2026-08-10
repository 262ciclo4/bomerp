# BD2 - BomERP Oracle (Administración de Base de Datos II)

Carpeta del curso **Administración de Base de Datos II** dentro del
monorepo `bomerp`. BD2 no es un proyecto con build propio: es un curso de
administración avanzada de Oracle, y su "código" son scripts SQL/PL-SQL
verificados contra una instancia Oracle real, no un artefacto que se
compila.

## Qué hay (y qué no) en esta carpeta

Las subcarpetas `backup-recovery/`, `oracle/plsql/`, `oracle/schemas/`,
`security/`, `tuning/` son hoy **scaffolding vacío**: cada una solo tiene
un `README.md` con el contenido esperado, sin ningún script `.sql` real
todavía.

**Los scripts de referencia reales y ejecutables viven en
`docs/proyecto-integrador/`**, uno por unidad:

- `docs/proyecto-integrador/u1/oracle/`: `S01_01_esquemas.sql`,
  `S01_02_tablas.sql`, `S01_03_plsql.sql`,
  `S02_triggers_dml_auditoria.sql`.
- `docs/proyecto-integrador/u2/oracle/`: `01_security.sql`,
  `02_storage_audit.sql`, `03_partition_perf.sql`.
- `docs/proyecto-integrador/u3/oracle/`: `01_rman_backup.md`,
  `02_recovery_scenario.md`, `03_monitoring_queries.sql`,
  `04_operational_checklist.md`.

La numeración **no es uniforme** entre unidades: U1 usa
`S0X_NN_tema.sql` (un archivo por sesión), U2/U3 usan `NN_tema.{sql,md}`
sin prefijo de sesión, agrupando varias sesiones por archivo temático.

Las guías de sesión están en `docs/bd2/sesiones/S0X_*.md`. Solo `S01` y
`S02` traen el caso BomERP completamente desarrollado (esquema
`BOM_CATALOGO`); el resto son plantillas genéricas o sesiones de
evaluación. Detalle completo del estado real de cada sesión en
[`CLAUDE.md`](./CLAUDE.md).

## Requisitos previos

- Docker Desktop corriendo.
- Un cliente con soporte Oracle para ejecutar los scripts (por ejemplo la
  extensión de VS Code **Database Client**,
  `cweijan.vscode-postgresql-client2` — a pesar del nombre soporta
  Oracle), o `sqlplus` dentro del propio contenedor (no requiere cliente
  Oracle instalado en el host).

## Ambiente U1 (S1-S6): Oracle en Docker, compartido con LP2

U1 reutiliza el mismo contenedor Oracle que usa LP2 para el backend — no
hay un ambiente Oracle separado para BD2. Definición real (confirmada en
[`lp2/bomerp-backend/compose-local.yml`](../lp2/bomerp-backend/compose-local.yml)):

```yaml
services:
  oracle:
    image: gvenzl/oracle-free:23-slim
    container_name: bomerp-oracle
    ports:
      - "1521:1521"
    environment:
      ORACLE_PASSWORD: 123456
      APP_USER: BOMERP_APP
      APP_USER_PASSWORD: 123456
```

Es **Oracle Database Free 23c** (imagen `gvenzl/oracle-free:23-slim`), no
Oracle XE clásico ni la 19c EE que pide el sílabo para U2-U3 (ver más
abajo).

### Levantar el contenedor

Desde la raíz de `bomerp/` (no desde `bd2/`):

```powershell
docker compose -f lp2/bomerp-backend/compose-local.yml up -d
```

### Conectarse

Con cliente gráfico (ver también
[LP2 S01, 3.2.2](../docs/lp2/sesiones/S01_Arquitectura_Backend_REST_Profesional.md)):

| Campo | Valor |
|---|---|
| Host | `127.0.0.1` |
| Port | `1521` |
| Username | `system` (o `BOMERP_APP` para verificar con el usuario de app) |
| Password | `123456` |
| Database | `FREEPDB1` (**no** `XE`, que es el valor por defecto del cliente) |

Desde terminal, sin cliente gráfico:

```powershell
docker exec -it bomerp-oracle sqlplus system/123456@localhost:1521/FREEPDB1
```

Credenciales en texto plano (`123456`) a propósito: son valores de laptop
de desarrollo, no secretos — mismo criterio que `application-local.yml`
de `lp2/bomerp-backend`. La contraseña de `BOMERP_APP` debe coincidir
exactamente entre ambos.

### Ejecutar y verificar los scripts de U1

Ejecuta en orden `S01_01_esquemas.sql` → `S01_02_tablas.sql` →
`S01_03_plsql.sql` → `S02_triggers_dml_auditoria.sql` (con `system`, que
tiene privilegios de DBA para crear los usuarios `BOM_CATALOGO` y
`BOMERP_APP`; los scripts siguientes ya pueden ejecutarse contra el
esquema `BOM_CATALOGO`). No hay suite automatizada tipo `mvn test`: la
verificación es la evidencia de `DBMS_OUTPUT.PUT_LINE` documentada en
`docs/bd2/sesiones/S01_*.md`/`S02_*.md`, más una consulta `SELECT`/`DESC`
posterior que confirme el estado final.

## Ambiente U2-U3 (S7-S16): Oracle 19c EE + Oracle Linux — no operacionalizado

El sílabo pide Oracle Database 19c Enterprise Edition sobre Oracle Linux
para las unidades 2 y 3. **Este ambiente todavía no existe en el repo**:
no hay `compose-*.yml`, script de aprovisionamiento, VM ni instructivo de
conexión para él. Los scripts de referencia de U2/U3
(`docs/proyecto-integrador/u2/oracle/`, `docs/proyecto-integrador/u3/oracle/`)
ya existen como texto, pero no hay dónde ejecutarlos por defecto en este
entorno.

Esto es un pendiente real, no un detalle a completar por analogía con
U1: el contenedor `bomerp-oracle` (Oracle Free 23c) no es Oracle 19c EE,
y no se debe asumir que sirve para U2/U3 sin decidirlo explícitamente. Si
necesitas avanzar una sesión de U2/U3, indícalo como paso manual
pendiente en vez de inventar instrucciones de instalación.

## Dónde seguir

- [`CLAUDE.md`](./CLAUDE.md): contexto completo para trabajar en esta
  carpeta con Claude Code (convenciones, estado detallado de cada
  sesión, mapeo de subcarpetas, fuera de alcance).
- [`.claude/skills/bd2-sesion/SKILL.md`](./.claude/skills/bd2-sesion/SKILL.md):
  flujo para implementar el incremento de una sesión concreta.
- `docs/bd2/silabo_bd2_2026_2.md`: sílabo vigente.
- `docs/bd2/index.md`: visión de producto y roadmap de las 3 unidades.
