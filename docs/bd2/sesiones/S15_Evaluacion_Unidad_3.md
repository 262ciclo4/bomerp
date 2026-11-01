# S15 - Evaluación de la Unidad III

## 1. Propósito de la evaluación

Esta sesión no enseña contenido nuevo: cierra la Unidad III de **BD2**, y con ella, el curso completo. El sílabo (sesión 15) define dos actividades:

1. Resolver la evaluación teórico-práctica de los temas de la Unidad III (sesiones 13 a 14).
2. Presentar y sustentar la Base de datos empresarial Oracle operativa, administrada, optimizada, auditada y resiliente.

**Esta sesión coincide con la sustentación final integrada del ciclo**, según la [Guía de Sustentación Final](../../proyecto-integrador/u3/guia-sustentacion.md): ADS y LP2 también cierran su Unidad III esta misma semana, en sus propias sesiones 15. A diferencia de S6 y S12 (cortes solo de BD2), la sustentación de hoy comparte un solo pitch ejecutivo y una sola demo final con los otros dos cursos (Guía de Sustentación Final, "Secuencia sugerida") — el bloque de "Operación BD2" (3 min) es tu propio espacio dentro de esa sustentación conjunta, no una presentación aparte.

## 2. Producto evaluado

Del sílabo, el producto de la Unidad III (y del curso completo) es:

> Base de datos empresarial Oracle operativa, administrada, optimizada, auditada y resiliente.

El producto completo — plantilla-ejemplo con el contenido de BomERP, verificado en vivo — vive en [`bd2-producto.md`](../../proyecto-integrador/u3/bd2-producto.md): scripts de backup/recovery/monitoreo, evidencias esperadas, rúbrica de evaluación y trazabilidad de esa rúbrica contra la malla curricular. La estructura es exigible a todos; el contenido de BomERP se reemplaza por el del propio proyecto de cada equipo.

### Lo que acumulaste sesión por sesión

Este producto no se construye en S15: se ensambla con lo que cada sesión anterior ya te pidió sobre tu propio proyecto.

**Tabla 1. De la sesión a la base de datos resiliente**

| Sesión | Qué produjiste (tu propio proyecto) | Dónde queda en `bd2-producto.md` |
|---|---|---|
| S13 | `ARCHIVELOG` activado, respaldo completo e incremental reales con RMAN, un incidente simulado recuperado exactamente hasta el punto correcto con PITR, y un respaldo lógico con Data Pump. | 1. Scripts (`01_rman_backup.md`, `02_recovery_scenario.md`) y 2. Evidencias esperadas (Backup, Recovery) |
| S14 | Sesiones activas monitoreadas, un bloqueo real diagnosticado y resuelto, al menos un objeto revisado en `DBA_OBJECTS`, y el rendimiento en vivo medido con `V$SYSSTAT`. | 1. Scripts (`03_monitoring_queries.sql`) y 2. Evidencias esperadas (Monitoreo, Diagnóstico, Rendimiento) |
| S15 (esta sesión) | Ensamblas todo lo anterior —y lo acumulado desde U1-U2— en el producto final y lo sustentas. | El producto completo + sección 4 de esta guía |

Lo que sustentas en S15 es **tu propia base de datos resiliente**: los objetos, respaldos y diagnósticos que tú construiste, con los datos de tu propio dominio — no el de BomERP. `bd2-producto.md` muestra cómo se ve ese producto terminado usando el ejemplo del docente; tu entregable real tiene la misma estructura, con el contenido que tú construiste en S13-S14, sobre el motor que S1-S12 ya dejaron administrado y optimizado.

## 3. Evaluación teórico-práctica (S13-S14)

Cubre los dos temas dictados antes de esta sesión. El docente puede tomarla escrita, oral o mixta.

**Tabla 2. Temario de la evaluación teórico-práctica**

| Sesión | Tema | Qué puede evaluar el docente |
|---|---|---|
| S13 | Backup y Recovery con RMAN | Respaldo completo (*Level 0*) frente a incremental (*Level 1*), por qué `ARCHIVELOG` es condición necesaria de *Point-In-Time Recovery*, la diferencia entre `RESTORE` y `RECOVER`, RTO/RPO, y cuándo corresponde RMAN frente a Data Pump. |
| S14 | Monitoreo y diagnóstico | Vistas `V$` frente a `DBA_`, cómo diagnosticar un bloqueo real con `DBA_BLOCKERS`/`DBA_WAITERS` sin confundirlo con una sesión simplemente inactiva, qué significa que un objeto esté `INVALID`, el *buffer cache hit ratio* como indicador relativo (no absoluto), y por qué Enterprise Manager Express cubre lo que este curso necesita frente a Oracle Cloud Control. |

Preguntas de referencia (el docente puede formular equivalentes):

1. ¿Por qué un respaldo tomado en `NOARCHIVELOG` solo puede restaurar exactamente al instante en que se tomó, y nunca a un punto intermedio?
2. En tu propio incremental (*Level 1*), ¿qué datafile se omitió por no haber cambiado, y cómo lo confirmaste?
3. ¿Qué diferencia de fondo hay entre `RESTORE` y `RECOVER`, y por qué casi siempre se usan juntos?
4. ¿Qué diferencia hay entre una sesión `INACTIVE` y una sesión bloqueada en `V$SESSION`, y cómo lo confirmas con evidencia?
5. ¿Por qué `ALTER SYSTEM KILL SESSION` sobre la sesión bloqueadora, sin diagnosticar antes, puede ser una decisión peligrosa?
6. ¿Qué significa que un objeto esté `INVALID`, y por qué Oracle no lo recompila solo hasta que alguien lo usa?
7. ¿Por qué Enterprise Manager Express, y no Oracle Cloud Control, es la herramienta real de monitoreo de este curso?

## 4. Sustentación del producto final

**Tabla 3. Distribución de tiempo de la sustentación**

| Momento | Tiempo | Quién | Propósito |
|---|---:|---|---|
| Pitch ejecutivo (diapositiva) | 1-3 min | Grupal | **Una sola vez para los tres cursos** — problema, solución y valor del Proyecto Integrador completo ([Guía de Sustentación Final](../../proyecto-integrador/u3/guia-sustentacion.md)). No se repite en ADS/LP2. |
| Operación BD2 (diapositiva + demo) | 3 min | Grupal | Seguridad, optimización, backup, recovery y monitoreo — componentes reales de `bomerp-oracle`: `ARCHIVELOG`, RMAN, PITR, bloqueos y objetos diagnosticados. |
| Demo final conjunta | 5 min (compartido con ADS/LP2) | Grupal | Flujo end-to-end autenticado, con la base de datos resiliente sosteniendo la transacción, la persistencia y la consulta en vivo. |
| Preguntas individuales | 3 min por integrante | Individual | Verificar dominio y aporte propio, con base en la Tabla 2. |

**Tabla 4. Entregables obligatorios**

| Entregable | Evidencia mínima | Criterio de aceptación |
|---|---|---|
| Producto final de unidad/curso | [`bd2-producto.md`](../../proyecto-integrador/u3/bd2-producto.md) completo | Coherente con el sílabo y con los objetos Oracle reales |
| Evidencia de continuidad | Backup completo e incremental reales, PITR verificado, Data Pump ejecutado | Trazabilidad verificable en vivo, no solo documentada |
| Evidencia de monitoreo | Bloqueo real diagnosticado y resuelto, objetos revisados, rendimiento medido | Verificable en vivo, con interpretación correcta |
| Sustentación individual | Preguntas y defensa por integrante (sección 3) | Autoría demostrada |

Secuencia sugerida de presentación (referencias a secciones de `bd2-producto.md`):

1. Confirmar que la instancia está disponible y en `ARCHIVELOG`.
2. Mostrar `LIST BACKUP SUMMARY` con el respaldo completo e incremental reales.
3. Ejecutar en vivo (o mostrar grabado) el escenario de PITR: el cambio correcto sobrevive, el incidente simulado no.
4. Construir un bloqueo real entre dos sesiones y diagnosticarlo con `DBA_BLOCKERS`/`DBA_WAITERS`.
5. Resolverlo y verificar qué cambio quedó confirmado.
6. Mostrar el objeto inválido encontrado (o la búsqueda documentada sin hallazgo) y el resultado real del intento de recompilación.
7. Mostrar el indicador de rendimiento medido con `V$SYSSTAT`, e interpretarlo en el contexto de la carga real.
8. Cerrar conectando lo sustentado con el motor administrado desde U1-U2 — explicando al menos una decisión propia distinta al ejemplo del docente.

Criterios mínimos de aceptación:

- Los objetos y escenarios Oracle existen y responden en vivo, no solo en captura de pantalla.
- El respaldo completo e incremental están verificados, con evidencia real de al menos un datafile omitido en el incremental.
- El PITR está verificado con una consulta que distingue el cambio que sobrevivió del incidente descartado.
- El bloqueo está diagnosticado con `DBA_BLOCKERS`/`DBA_WAITERS` y resuelto, con la verificación final.
- El rendimiento está medido (no estimado), con interpretación correcta.
- Cada integrante responde individualmente al menos una pregunta de la Tabla 2.

## 5. Rúbrica de evaluación

La rúbrica (6 criterios: 5 cita literal de los criterios de evaluación del producto de la Unidad III + sustentación) vive en [`bd2-producto.md`](../../proyecto-integrador/u3/bd2-producto.md#4-rubrica-de-evaluacion), junto con la plantilla del producto y su trazabilidad con la malla curricular (CE022 Nivel 2, completo desde esta unidad). Úsala directamente desde ahí para calificar la sustentación de esta sesión — no se duplica aquí.
