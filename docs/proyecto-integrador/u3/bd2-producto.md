# BD2 - Producto de Unidad 3

**Este documento es el ejemplo BomERP del docente, no una plantilla obligatoria.** Cada sede (Lima, Juliaca, Tarapoto) y cada grupo dentro de una misma sede opera su propio esquema Oracle sobre su propio dominio, continuando el motor administrado y optimizado de su [Producto U2](../u2/bd2-producto.md). Los comandos, resultados y evidencias concretas de este documento son los del ejemplo BomERP, verificados en vivo contra `bomerp-oracle`; cada equipo los reemplaza por los de su propio proyecto. Lo exigible a todos es la estructura: backup, recovery con PITR, monitoreo, diagnóstico y sustentación final.

## Producto

**Base de datos empresarial Oracle operativa, administrada, optimizada, auditada y resiliente.**

## 1. Scripts y evidencias

| Archivo | Propósito |
|---|---|
| [01_rman_backup.md](oracle/01_rman_backup.md) | Backup completo (L0) e incremental (L1) con RMAN, verificado contra `bomerp-oracle` (S13). |
| [02_recovery_scenario.md](oracle/02_recovery_scenario.md) | Incidente simulado y recuperación con *Point-In-Time Recovery* (S13). |
| [03_monitoring_queries.sql](oracle/03_monitoring_queries.sql) | Consultas reales de sesiones, bloqueos, objetos y rendimiento (S14). |
| [04_operational_checklist.md](oracle/04_operational_checklist.md) | Checklist operativo de BD2, resuelto contra el estado real de `bomerp-oracle`. |

## 2. Evidencias mínimas

| Dimensión | Evidencia |
|---|---|
| Backup | `ARCHIVELOG` activo, `LIST BACKUP SUMMARY` con el respaldo completo (L0) y el incremental (L1), con al menos un datafile omitido en el L1 por no haber cambiado. |
| Recovery | Incidente simulado con dos cambios reales y recuperación con `SET UNTIL TIME`, verificada con una consulta que distingue el cambio que sobrevivió del descartado. |
| Monitoreo | `V$SESSION`, `DBA_BLOCKERS`/`DBA_WAITERS` sobre un bloqueo real construido y resuelto. |
| Diagnóstico | Objeto `DBA_OBJECTS` inválido encontrado (o búsqueda documentada sin hallazgo), con el resultado real del intento de recompilación. |
| Rendimiento | Indicador de `V$SYSSTAT` (ej. *buffer cache hit ratio*) medido, no estimado. |
| Seguridad y auditoría (acumulado de U2) | Usuarios, roles, privilegios y auditoría vigentes, confirmados antes de iniciar U3 (S13, 3.1). |

## 3. Integración con el producto final

| Evidencia BD2 | Relación con ADS | Relación con LP2 |
|---|---|---|
| Backup y recovery con PITR | Atributo de resiliencia documentado en ADS (atributos de calidad, U1). | La aplicación puede recuperarse ante pérdida de datos sin perder más de lo necesario. |
| Monitoreo de sesiones y bloqueos | Decisión de integración/observabilidad. | Un bloqueo real en la base puede explicar una petición lenta o colgada del backend. |
| Objetos inválidos diagnosticados | Trazabilidad entre diseño y base real. | Un objeto roto en la base puede manifestarse como un error 500 inesperado en la API. |
| Rendimiento en vivo | Atributo de eficiencia. | Respuesta de consultas y filtros del sistema bajo carga real. |

## 4. Rúbrica de Evaluación

**Tabla 1. Rúbrica de evaluación de la Unidad 3**

| Criterio | Peso | CE / Nivel | A (20 pts) | B (15 pts) | C (10 pts) | D (5 pts) | Calificación obtenida |
|---|---:|---|---|---|---|---|---:|
| 1. Implementa estrategias de backup y recovery con RMAN | 16% | CE022-N2 (completa) | Backup completo e incremental reales, con evidencia de al menos un datafile omitido por no haber cambiado, y `ARCHIVELOG` verificado. | Backup completo e incremental presentes, sin evidencia de omisión real. | Solo backup completo, sin incremental. | No presenta backup con RMAN. | |
| 2. Usa Data Pump y escenarios de recuperación como PITR | 16% | CE022-N2 (completa) | PITR verificado con un incidente real (el cambio correcto sobrevive, el incidente no) y Data Pump ejecutado con directorio persistente. | Uno de los dos completo, el otro parcial o solo documentado. | Ambos mencionados sin ejecución real. | No presenta PITR ni Data Pump. | |
| 3. Monitorea sesiones, bloqueos y rendimiento con vistas administrativas y herramientas Oracle | 16% | CE022-N2 (completa) | Bloqueo real diagnosticado y resuelto con `DBA_BLOCKERS`/`DBA_WAITERS`, objetos inválidos revisados, rendimiento medido con `V$SYSSTAT`, todo confirmado también en Enterprise Manager Express. | Monitoreo presente, sin confirmar en Enterprise Manager Express o con alguna evidencia incompleta. | Vistas consultadas sin interpretación ni verificación real. | No presenta evidencia de monitoreo. | |
| 4. Sustenta evidencias técnicas de programación, administración, seguridad, auditoría, optimización y recuperación | 16% | CE022-N2 (completa) + CE023-N1 (cierre acumulado) | Sustentación coherente que conecta U1 (PL/SQL), U2 (administración) y U3 (backup/monitoreo) sobre el mismo proyecto real. | Sustentación completa, con la conexión entre unidades parcialmente explicada. | Sustentación centrada solo en U3, sin conectar con el trabajo acumulado. | No sustenta evidencia técnica acumulada. | |
| 5. Presenta el producto final operativo, auditado y resiliente | 16% | CE022-N2 (completa) | `bd2-producto.md` completo y coherente con los objetos Oracle reales, con las evidencias mínimas de la sección 2 verificables en vivo. | Producto completo, con alguna evidencia mínima incompleta. | Producto incompleto o con evidencias no verificables en vivo. | No presenta producto final. | |
| 6. Sustentación | 20% | CG | Sustenta con claridad y profesionalismo su aporte individual, respondiendo con precisión las preguntas del jurado. | Sustenta con solvencia, con detalles menores en claridad, orden o precisión. | Sustenta con dificultad; claridad, orden o precisión insuficientes. | No sustenta adecuadamente ni demuestra su aporte individual. | |

Nota final = suma de (`Peso` × `Puntos de la calificación obtenida`) / 100 × 20.

`CE022-N2 (completa)` = cierre del Nivel 2 de CE022 (Ingeniería de la Información): la [Unidad 2](../u2/bd2-producto.md#4-rubrica-de-evaluacion) ya cubrió la porción de administración empresarial (usuarios, almacenamiento, auditoría, optimización, particionamiento); esta unidad completa la porción de **continuidad del negocio y operación empresarial** (respaldo, recuperación con PITR, monitoreo y diagnóstico) que esa misma nota de U2 dejó pendiente para aquí. `CE023-N1 (cierre acumulado)` se menciona en el criterio 4 porque la sustentación integra también el motor transaccional de [Unidad 1](../u1/bd2-producto.md#7-rubrica-de-evaluacion) (CE023-N1, ya cerrado desde esa unidad) — no abre ni reabre ese nivel, solo lo integra en el discurso de la sustentación. `CG` = Competencia General del sílabo de BD2, con la misma inconsistencia de nombre entre secciones III y VIII ya documentada en el [Producto U1](../u1/bd2-producto.md#7-rubrica-de-evaluacion). No es CE022: los criterios 1-5 ya son la evidencia técnica, incluida su verificación en vivo; el criterio 6 verifica aporte individual y comunicación.

**Tabla 2. Subaspectos de la sustentación (Unidad 3)**

El criterio 6 se evalúa con los mismos 6 subaspectos de la sustentación integral del Proyecto Integrador ([Guía de Sustentación Final](guia-sustentacion.md#subaspectos-de-la-sustentacion-integral)) — la misma exigencia de Unidad 1 y Unidad 2, ahora en la sustentación final del curso.

| Subaspecto | Qué observa en Unidad 3 |
|---|---|
| 1. Aporte individual | Cada integrante demuestra al menos un objeto o escenario real que administró: un backup, una recuperación PITR, un bloqueo diagnosticado, o un objeto inválido investigado. |
| 2. Comunicación y orden | Claridad, estructura, tiempo y lenguaje técnico durante la presentación. |
| 3. Presentación personal y actitud | Puntualidad, vestimenta limpia y adecuada, higiene, cabello ordenado, actitud profesional, respeto, honestidad y coherencia con los valores y principios cristianos de la institución. |
| 4. Repositorio y estándares | Organización, commits y reproducibilidad de los scripts y evidencias de respaldo/monitoreo desde S13. |
| 5. MkDocs o equivalente | Documentación de Unidad 3 publicada, navegable y alineada con `bd2-producto.md`. |
| 6. Pitch/demo ejecutiva | El producto final operativo (backup, recovery, monitoreo) con apoyo visual (.pptx, Canva o equivalente) — no reemplaza la demo técnica de S15, la precede. |

Para usar la rúbrica con IA, solicita:

```text
Evalúa la sustentación y el producto (bd2-producto.md o la sección 2 de la guía S15) usando la rúbrica de esta sección.
Para cada criterio selecciona la calificación obtenida: A=20, B=15, C=10, D=5.
Justifica brevemente cada nivel con evidencia concreta (backup/recovery con RMAN, PITR, Data Pump, bloqueos diagnosticados, objetos inválidos, rendimiento medido).
Calcula la nota final con la fórmula: suma de (Peso × Puntos de la calificación obtenida) / 100 × 20.
Indica 2 fortalezas y 2 recomendaciones para la sustentación final del curso.
```

## 5. Trazabilidad y procedencia de la rúbrica

Los primeros cinco criterios son cita literal de los "Criterios de evaluación del producto" de la Unidad 3 en el sílabo de BD2; el sexto (Sustentación) corresponde a la sustentación exigida por el mismo sílabo (sesión 15, actividad 2).

**Con la malla curricular:** los criterios 1-5 completan el **Nivel 2 de CE022** (Ingeniería de la Información) — la porción de **continuidad del negocio y operación empresarial** (respaldo, recuperación con PITR, monitoreo, diagnóstico) que la [Unidad 2](../u2/bd2-producto.md#5-trazabilidad-y-procedencia-de-la-rubrica) dejó pendiente explícitamente para esta unidad. Con esta unidad, CE022-N2 queda completo para BD2. El criterio 6 (Sustentación) es transversal y no forma parte de la definición de la competencia.

## Cierre BD2

BD2 está completo cuando la base no solo almacena datos, sino que puede ser administrada, auditada, optimizada, respaldada, recuperada con un punto exacto en el tiempo, y diagnosticada en vivo — verificado contra la instancia real, no solo documentado.
