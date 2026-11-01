# ADS - Producto de Unidad 3

**Este documento es el ejemplo BomERP del docente, no una plantilla obligatoria.** Cada sede (Lima, Juliaca, Tarapoto) y cada grupo dentro de una misma sede cierra su propio diseño técnico sobre su propio dominio, definido desde S2 y consolidado en sus propios productos U1/U2. Los ADR y la matriz de trazabilidad de este documento son los del ejemplo BomERP; cada equipo los reemplaza por los suyos, con sus propios códigos si ya vienen de U1/U2. Lo exigible a todos es la estructura: arquitectura final, modelo de dominio, catálogo UML, patrones, ADR y trazabilidad completa.

## Producto

**Diseño Técnico Profesional Documentado.**

## Componentes finales

| Componente | Evidencia esperada |
|---|---|
| Arquitectura final | C4 actualizado: contexto, contenedores, componentes y despliegue si aplica. |
| Modelo de dominio | Entidades, reglas, módulos y límites del sistema. |
| Catálogo UML | Clases, secuencia, actividad y estados si aplica. |
| Patrones | Controller, Service, Repository, DTO, Mapper u otros aplicados; Domain-Driven Design táctico (agregado) en los módulos donde se justificó por invariantes reales (candidato: `ventas`, ver Producto ADS U2). |
| ADRs | Decisiones arquitectónicas finales con contexto y consecuencia. |
| Trazabilidad | Relación diseño-BD2-LP2-pruebas. |

## Matriz final de trazabilidad

La columna "Requerimiento" se agregó en S14 (3.5) — el sílabo de esta sesión exige trazabilidad "entre requerimientos, arquitectura y diseño", no solo entre decisión, base de datos y backend.

| Requerimiento | Decisión o modelo ADS | Evidencia BD2 | Evidencia LP2 | Prueba o sustentación |
|---|---|---|---|---|
| RN8 (filtra por `vendedorId` si es `VENDEDOR`, S8) | API REST stateless con JWT | Usuario/rol de aplicación | Backend y SPA protegidos | Login, guard e interceptor. |
| Precondición de `anular()`: `{estado = 'REGISTRADA'}` (S7, 2.7) | Auditabilidad de ventas | Trigger o auditoría Oracle | Registro/anulación de venta | Evidencia de evento auditado. |
| RN10 (`ordenarPor` de lista cerrada, S8) | Rendimiento en consultas | Índice, estadísticas o AWR | Filtros y consultas API | Comparación de plan o tiempo. |
| RN1 (`404` si el producto no existe o no está activo, S8) | Service + Repository | Paquetes/tablas Oracle | Servicios y repositorios | Demo de flujo transaccional. |
| Requisito no funcional: listar grandes volúmenes sin degradar | Paginación de alto volumen | Índices y consulta estable | Metadatos, filtros y ordenamiento | Prueba con volumen justificable. |
| Requisito no funcional: diagnosticar un error en producción | Observabilidad | Sesiones, bloqueos y monitoreo Oracle | Logs, salud y monitoreo básico | Diagnóstico de una operación y un error. |
| RN2 (stock suficiente, `409`, S8) | Integración full-stack | Dato persistido y auditado | Flujo SPA -> API -> Oracle | Prueba end-to-end y regresión. |

## Atributos de calidad: justificación final (S14)

La Sección 2 del [Producto U1](../u1/ads-producto.md#2-atributos-de-calidad) priorizó estos atributos como decisión inicial, sin evidencia todavía. S14 (3.3) los justifica con evidencia real de las 13 sesiones siguientes — el criterio 3 de esta unidad ("Justifica atributos de calidad y decisiones técnicas") se califica aquí, no antes.

| Atributo | Decisión inicial (U1) | Evidencia real (S14) |
|---|---|---|
| Seguridad futura | Autenticación y autorización para U2. | Keycloak integrado (LP2 S10b-S11): JWT con `realm_access.roles`, Gateway valida el rol antes de reenviar. |
| Mantenibilidad | Ejecutable único, paquetes de módulo cohesionados. | `ModularityTests` en verde (ADR-002), verificado contra el código real. |
| Integridad | Reglas transaccionales en servicio y Oracle. | RN1-RN10 (S8) + `TRG_PRODUCTO_AUDITORIA` (BD2 S2). |
| Rendimiento | Índices y consultas optimizadas por fecha. | `IX_VENTAS_FECHA` (BD2 S5), selectividad medida (BD2 S10). |
| Auditabilidad | Trigger de auditoría de cambios de precio/stock. | `TRG_PRODUCTO_AUDITORIA` disparado en vivo (BD2 S2) + Unified Auditing (BD2 S9). |
| Escalabilidad inicial | API stateless preparada para SPA. | JWT sin sesión de servidor (LP2 S10b); `VENTAS_HISTORICO` particionado (BD2 S11). |

## ADR final de referencia

Los códigos de ADR no se reinventan por unidad: son los mismos a lo largo del ciclo. Los tres primeros ya son ADR reales del código (`docs/lp2/adr/`), verificados desde U1; los siguientes se formalizan cuando su sesión llega, no antes (ver [Producto ADS U1](../u1/ads-producto.md), sección 7):

| Código | Decisión | Estado | Evidencia |
|---|---|---|---|
| [ADR-001](../../lp2/adr/ADR-001-arquitectura-backend.md) | Un único proyecto Spring Boot, sin reactor Maven multi-módulo. | Aprobada (U1) | `mvnw test` verde desde S1. |
| [ADR-002](../../lp2/adr/ADR-002-spring-modulith.md) | Módulos de negocio verificados con Spring Modulith. | Aprobada (U1) | `ModularityTests` en verde. |
| [ADR-003](../../lp2/adr/ADR-003-spring-boot-4.md) | Spring Boot exacto en 4.0.7. | Aprobada (U1) | Verificado contra `start.spring.io`. |
| ADR-004 | API REST protegida con JWT. | Formalizada en S10 | Backend y SPA usan token. |
| ADR-005 | Una sola SPA organizada por funcionalidades. | Formalizada en S7 | `core`/`shared`/módulos con rutas propias. |
| ADR-006 | Documentación MkDocs como evidencia técnica navegable. | Formalizada al publicar el sitio | Publicación y repositorio. |
| ADR-007 | Caché y Redis se aplican solo cuando existe beneficio medible. | Formalizada en S13 | Evidencia de caché o decisión documentada de no usarlo. |
| ADR-008 | `Venta.calcularTotal()` es responsabilidad de la entidad (Information Expert), no del servicio — el cálculo actual en `VentaServiceImpl.crear` queda como deuda técnica. | Formalizada en S14 (ADS) | Hallazgo real de auditoría (S13, Tabla 7); refactor pendiente registrado para LP2. |

## Rúbrica de Evaluación

**Tabla 1. Rúbrica de evaluación de la Unidad 3**

| Criterio | Peso | CE / Nivel | A (20 pts) | B (15 pts) | C (10 pts) | D (5 pts) | Calificación obtenida |
|---|---:|---|---|---|---|---|---:|
| 1. Consolida arquitectura, dominio, UML, patrones e integraciones | 16% | CE021-N2 (cierre) | Auditoría de consistencia real entre U1 y U2 (S13), con hallazgos registrados y resueltos o diferidos explícitamente. | Consolidación presente, con algún hallazgo real sin resolución explícita. | Consolidación superficial, sin auditoría real entre unidades. | No presenta consolidación verificable. | |
| 2. Registra decisiones arquitectónicas mediante ADRs | 16% | CE021-N2 (cierre) | Al menos un ADR nuevo (4 partes completas) a partir de un hallazgo real, verificable contra el código. | ADR completo, con la decisión poco verificable. | ADR incompleto o sin hallazgo real que lo motive. | No presenta ADR nuevo en esta unidad. | |
| 3. Justifica atributos de calidad y decisiones técnicas | 16% | CE024-N1 (cierre) | Al menos 4 atributos de la Tabla de S1 justificados con evidencia real, correctamente asignada. | Al menos 4 atributos, con alguna evidencia mal asignada. | Menos de 4 atributos, o evidencia genérica. | No presenta justificación de atributos de calidad. | |
| 4. Mantiene trazabilidad entre requerimientos, arquitectura, base de datos y diseño | 16% | CE021-N2 (cierre) | Al menos 2 requerimientos reales trazados de punta a punta, con los 5 eslabones completos o pendientes registrados. | Al menos 2 requerimientos, con algún eslabón faltante sin registrar. | Solo 1 requerimiento trazado completo. | No presenta trazabilidad de ningún requerimiento. | |
| 5. Presenta un dossier técnico profesional listo para BD2 y LP2 | 16% | CE021-N2 (cierre) | Dossier completo y coherente (arquitectura, dominio, UML, patrones, ADR, trazabilidad), verificable en vivo. | Dossier completo, con alguna sección incompleta. | Dossier incompleto o con secciones no verificables. | No presenta dossier técnico. | |
| 6. Sustentación | 20% | CG | Sustenta con claridad y profesionalismo su aporte individual, respondiendo con precisión las preguntas del jurado. | Sustenta con solvencia, con detalles menores en claridad, orden o precisión. | Sustenta con dificultad; claridad, orden o precisión insuficientes. | No sustenta adecuadamente ni demuestra su aporte individual. | |

Nota final = suma de (`Peso` × `Puntos de la calificación obtenida`) / 100 × 20.

`CE021-N2 (cierre)` = cierre del Nivel 2 de CE021 (Ingeniería de Requerimientos): la arquitectura (U1) y el diseño detallado (U2) ya certificaron trazabilidad real acotada a su propio corte de unidad ([Producto U1](../u1/ads-producto.md#9-rubrica-de-evaluacion), [Producto U2](../u2/ads-producto.md#4-rubrica-de-evaluacion)); esta unidad cierra el nivel con la consolidación entre unidades (criterio 1), los ADR formales (criterio 2), la trazabilidad completa hasta el requerimiento (criterio 4) y el dossier final (criterio 5). `CE024-N1 (cierre)` = cierre del Nivel 1 de CE024 (Calidad de Software): los atributos de calidad se usaron como insumo de diseño desde S1, sin calificarse — el criterio 3 de esta unidad es la primera vez que se califican con evidencia real. `CG` = Competencia General del sílabo de ADS. No es CE021 ni CE024 en los criterios 1-5: ya son la evidencia técnica, incluida su verificación en vivo; el criterio 6 verifica aporte individual y comunicación.

**Tabla 2. Subaspectos de la sustentación (Unidad 3)**

El criterio 6 se evalúa con los mismos 6 subaspectos de la sustentación integral del Proyecto Integrador ([Guía de Sustentación Final](guia-sustentacion.md#subaspectos-de-la-sustentacion-integral)) — la misma exigencia de Unidad 1 y Unidad 2, ahora en la sustentación final del curso.

| Subaspecto | Qué observa en Unidad 3 |
|---|---|
| 1. Aporte individual | Cada integrante demuestra al menos un ADR, una justificación de atributo de calidad, o un requerimiento trazado que formalizó. |
| 2. Comunicación y orden | Claridad, estructura, tiempo y lenguaje técnico durante la presentación. |
| 3. Presentación personal y actitud | Puntualidad, vestimenta limpia y adecuada, higiene, cabello ordenado, actitud profesional, respeto, honestidad y coherencia con los valores y principios cristianos de la institución. |
| 4. Repositorio y estándares | Organización, commits y reproducibilidad de los ADR y la matriz de trazabilidad desde S13. |
| 5. MkDocs o equivalente | Documentación de Unidad 3 publicada, navegable y alineada con `ads-producto.md`. |
| 6. Pitch/demo ejecutiva | El dossier técnico profesional completo, con apoyo visual (.pptx, Canva o equivalente) — no reemplaza la demo técnica de S15, la precede. |

Para usar la rúbrica con IA, solicita:

```text
Evalúa la sustentación y el producto (ads-producto.md o la sección 2 de la guía S15) usando la rúbrica de esta sección.
Para cada criterio selecciona la calificación obtenida: A=20, B=15, C=10, D=5.
Justifica brevemente cada nivel con evidencia concreta (ADR, atributos de calidad, trazabilidad, dossier).
Calcula la nota final con la fórmula: suma de (Peso × Puntos de la calificación obtenida) / 100 × 20.
Indica 2 fortalezas y 2 recomendaciones.
```

## Trazabilidad y procedencia de la rúbrica

Los primeros cinco criterios son cita literal de los "Criterios de evaluación del producto" de la Unidad 3 en el sílabo de ADS; el sexto (Sustentación) corresponde a la sustentación exigida por el mismo sílabo (sesión 15, actividad 2).

## Cierre ADS

El diseño final se considera completo cuando otra persona puede entender la arquitectura, ubicar componentes, relacionar decisiones con evidencias y explicar por qué la solución técnica es coherente con el producto implementado.
