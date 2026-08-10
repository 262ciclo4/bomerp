# Plan de trabajo LP2

Este documento es el rastreador vivo de avance del backend/frontend de
referencia de LP2 (`lp2/`) y de sus guías de sesión (`docs/lp2/sesiones/`).
Se actualiza sesión a sesión; no confundir con el sílabo (contenido del
curso) ni con las ADR (decisiones de arquitectura, en [`adr/`](adr/)).

## Estado actual

- **Reinicio del repositorio (2026-08)**: se eliminaron físicamente
  `S02_*.md` a `S16_*.md` de `docs/lp2/sesiones/` (no solo se ocultaron del
  menú) — el repo se está reconstruyendo sesión por sesión desde S01, con
  un tag de git congelado al cerrar cada sesión.
- **Arquitectura**: proyecto único Spring Boot + Spring Modulith (no reactor
  Maven multi-módulo). Ver [ADR-001](adr/ADR-001-arquitectura-backend.md) y
  [ADR-002](adr/ADR-002-spring-modulith.md).
- **`lp2/bomerp-backend` — estado real del código (verificado 2026-08,
  corrige una afirmación anterior de este mismo documento)**: solo existe
  el andamiaje base — `BomerpBackendApplication`, `HelloController`
  (`/api/v1/hello`), `OpenApiConfig`, conexión a Oracle
  (`compose-local.yml` + `application-local.yml`, contenedor
  `bomerp-oracle` corriendo y saludable). **El módulo `catalogo`
  (`Categoria`/`Producto`: entity, repository, service, DTO, controller)
  que la propia guía S01 (sección 3.2.6) describe como parte del producto
  de la sesión todavía NO está implementado.** No asumir que existe solo
  porque la guía o `docs/proyecto-integrador/u1/ads-producto.md` lo
  mencionan — ambos documentan el estado objetivo, no necesariamente el
  código ya escrito.
- La base Oracle (esquema `BOM_CATALOGO`, tablas `categoria`/`producto`)
  **sí existe y está operativa** — la crean los scripts de BD2 S1
  (`docs/proyecto-integrador/u1/oracle/S01_01_esquemas.sql` y
  `S01_02_tablas.sql`), ya ejecutados contra `bomerp-oracle`.
- **Guía S1**: alineada a la plantilla ampliada (Índice, Metodología,
  Motivación/1.6.1 Caso, Hoja de ruta en Aplica). Publicada en
  `mkdocs.yml`.

## Pendiente explícito: completar el módulo `catalogo`

Antes de dar S1 por completamente cerrado (y no solo "proyecto creado"),
falta implementar `Categoria`/`Producto` (entity, repository, service, DTO,
controller) con los listados `GET /api/v1/categorias` y
`GET /api/v1/productos` que la guía S01 pide como producto de la sesión.
Se dejó pendiente a propósito en la sesión de trabajo del 2026-08 (decisión
explícita del usuario) — no completar sin que se pida.

## Pendiente explícito: reincorporar `spring-modulith-starter-jpa`

En S1 se **quitó** `spring-modulith-starter-jpa` del `pom.xml` (Initializr la
agrega automáticamente al combinar Spring Modulith + Spring Data JPA, ver
[ADR-002](adr/ADR-002-spring-modulith.md)) porque trae el registro de
eventos de Modulith respaldado por JPA, que exige la tabla
`event_publication` — con `ddl-auto: validate` y sin esa tabla en Oracle,
la app no arrancaba. Los módulos de S1-S13 se comunican solo por servicios
Java, no por eventos, así que no hace falta.

**Cuando una sesión adopte comunicación por eventos entre módulos**
(candidato: S14, auditoría/integración — ver ADR-002), hay que:

1. Volver a agregar `spring-modulith-starter-jpa` al `pom.xml`.
2. Crear la tabla `event_publication` en Oracle (migración de BD2 para esa
   sesión, no antes).
3. Verificar con `mvnw clean test` + arranque real contra Oracle, igual que
   se hizo al quitarla en S1.

No agregar esta dependencia de vuelta "por si acaso" en una sesión anterior
a la que realmente la necesite.

## Cómo se continúa

Cada sesión se implementa con el skill `lp2-sesion`
(`lp2/.claude/skills/lp2-sesion/SKILL.md`), que:

1. Lee el alcance concreto en `index.md` (fila de la sesión) y la rúbrica en
   `sesiones/S0X_*.md`.
2. Lee las ADR vigentes en `adr/`.
3. Implementa solo el incremento de esa sesión sobre `lp2/bomerp-backend`
   (y `lp2/frontend` desde S7).
4. Verifica con `mvn -f lp2/bomerp-backend/pom.xml test` **y arranque real
   contra `bomerp-oracle`** — no basta con que compile, hay que probar los
   endpoints.
5. Publica la sesión en `mkdocs.yml` y cierra con un tag de git (`s02`,
   `s03`, ...) una vez verificada.

## Hoja de ruta

| Sesión | Foco | Estado |
|---|---|---|
| S1 | Proyecto backend, listados iniciales de `Categoria`/`Producto` | Proyecto y guía listos; módulo `catalogo` pendiente (ver arriba) |
| S2 | CRUD completo de `Producto` (validaciones, excepciones, logs, pruebas) | Pendiente (reconstruir) |
| S3 | Asociación `Categoria–Producto` vía ORM/DTO | Pendiente (reconstruir) |
| S4 | `Venta–DetalleVenta` cabecera-detalle transaccional | Pendiente (reconstruir) |
| S5 | Consultas, reportes, CORS | Pendiente (reconstruir) |
| S6 | Evaluación integrada U1 | Pendiente (reconstruir) |
| S7 | SPA: layout, navegación, CRUD independiente | Pendiente (reconstruir) |
| S8 | CRUD de tablas dependientes | Pendiente (reconstruir) |
| S9 | Formularios transaccionales cabecera-detalle | Pendiente (reconstruir) |
| S10 | Seguridad backend: JWT, roles, permisos | Pendiente (reconstruir) |
| S11 | Seguridad frontend: guards, interceptores | Pendiente (reconstruir) |
| S12 | Evaluación integrada U2 | Pendiente (reconstruir) |
| S13 | Optimización y preparación para producción | Pendiente (reconstruir) |
| S14 | Paginación, auditoría, integración, e2e | Pendiente (reconstruir) — candidata a reincorporar `spring-modulith-starter-jpa` (ver arriba) |
| S15 | Sustentación del Proyecto Integrador | Pendiente (reconstruir) |
| S16 | Evaluación final individual | Pendiente (reconstruir) |
