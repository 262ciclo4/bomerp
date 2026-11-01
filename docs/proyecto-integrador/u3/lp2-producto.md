# LP2 - Producto de Unidad 3

**Este documento es el ejemplo BomERP del docente, no una plantilla obligatoria.** Cada sede (Lima, Juliaca, Tarapoto) y cada grupo dentro de una misma sede estabiliza y sustenta su propia base full-stack sobre su propio dominio. Los módulos y casos de prueba concretos de este documento (`catalogo`/`ventas`) son los del ejemplo BomERP; cada equipo los reemplaza por los suyos. Lo exigible a todos es la estructura: backend y frontend modular funcionando integrado, seguridad, optimización, caché, observabilidad, paginación, auditoría, pruebas y estabilización.

## Producto

**Base Full-Stack modular de BomERP —una SPA, una aplicación Spring Boot única (módulos verificados con Spring Modulith) y una base Oracle organizada por esquemas funcionales— integrada, optimizada, monitoreada y estabilizada.**

## Componentes finales

| Componente | Evidencia esperada |
|---|---|
| Backend REST modular | Un `bomerp-backend` ejecutable; Catálogo y Ventas funcionales; Inventario, Compras y Seguridad como paquetes agregados solo cuando su sesión les dio contenido; conexión a Oracle, DTO, validaciones y consultas. |
| Frontend SPA modular | Una SPA con `core`, `shared` y funcionalidades; navegación, CRUD, ventas, consultas, reportes, guards e interceptores. |
| Integración | Flujo SPA → aplicación Spring Boot → módulos → esquemas Oracle completo y verificable. |
| Seguridad | Keycloak (no JWT propio, reemplazado desde S10b): *Authorization Code* + PKCE, roles reales (`realm_access.roles`), rutas protegidas, manejo de 401/403 con refresco automático. |
| Límites modulares | Dependencias unidireccionales, repositorios privados y comunicación interna mediante servicios Java, sin Feign. |
| Optimización frontend | Lazy Loading, Code Splitting y evidencia del build optimizado. |
| Caché | Política de navegador y uso justificado de Redis o justificación de no uso. |
| Observabilidad | Logs estructurados, endpoint de salud y monitoreo básico. |
| Paginación | Listado de alto volumen con metadatos, filtros y ordenamiento conservados. |
| Auditoría | Usuario, fecha, acción, entidad afectada y cambio relevante. |
| Pruebas | Casos funcionales, seguridad, integración, end-to-end y regresión. |
| Estabilización | Bitácora de incidencias, prioridad, corrección y prueba de no regresión. |
| Despliegue o ejecución | Configuración por ambientes y guía reproducible para levantar o revisar el sistema. |

## Plan de pruebas final

| Tipo | Caso | Resultado esperado |
|---|---|---|
| Funcional | Registrar operación principal. | Se persiste y se visualiza correctamente. |
| Seguridad | Acceder sin token a ruta protegida. | Acceso bloqueado. |
| Integración | Ejecutar flujo SPA -> API -> Oracle. | Respuesta coherente y datos actualizados. |
| Validación | Enviar datos inválidos. | Error controlado y mensaje claro. |
| Paginación | Consultar un listado de alto volumen y cambiar de página. | Mantiene filtros, ordenamiento y metadatos consistentes. |
| Auditoría | Ejecutar una operación crítica. | Registra actor, fecha, acción y cambio. |
| Observabilidad | Provocar una operación correcta y un error controlado. | Logs correlacionables y estado de salud visible. |
| End-to-end | Ejecutar autenticación, transacción y consulta desde la SPA. | El flujo completo finaliza sin rupturas. |
| Recuperación | Revisar sistema después de restore de BD. | Datos y flujo principal disponibles. |
| Arquitectura modular | Revisar dependencias entre módulos. | Existe un ejecutable, no hay acceso a repositorios ajenos y los módulos se relacionan mediante servicios públicos. |

## Bitácora de estabilización

**Hallazgo real de S14**, verificado contra el código: `VentaReporteComponent` (frontend) nunca llamaba a `GET /api/v1/ventas/resumen` (el agregado real, con `SUM`/`COUNT` en Oracle, existente desde S9) — recalculaba `totalVentas`/`montoTotal`/`ticketPromedio` en el navegador, con `.reduce()`, sobre la lista completa sin paginar. Corregido en S14: el listado se paginó (`Page<VentaResponse>`) y la SPA se reconectó al agregado real del servidor.

| Hallazgo | Corrección | Evidencia |
|---|---|---|
| `VentaReporteComponent` recalculaba sus totales en el navegador en vez de usar el agregado real de `/resumen` (S9, nunca conectado) | Listado paginado (`Page<VentaResponse>`) + SPA reconectada al agregado real del servidor (S14) | `VentaEndToEndTest` en verde; verificación manual de `montoTotal` contra una suma real de las filas. |
| Error de validación incompleta | Se agregó validación frontend/backend. | Caso de prueba actualizado. |
| Consulta lenta | Se revisó plan e índice con BD2. | Evidencia de optimización. |
| Ruta sin protección | Se agregó guard/interceptor. | Prueba de acceso 401/403. |
| Falta de trazabilidad | Se vinculó endpoint con diseño y tabla. | Matriz final actualizada. |
| Listado inestable con volumen | Se incorporó paginación conservando filtros. | Prueba de alto volumen. |
| Error recurrente del flujo | Se corrigió y añadió prueba de regresión. | E2E ejecutada satisfactoriamente. |

## Rúbrica de Evaluación

**Tabla 1. Rúbrica de evaluación de la Unidad 3**

A diferencia de las demás unidades (5 criterios técnicos + Sustentación como criterio transversal), el sílabo de LP2 lista exactamente **4** criterios para esta unidad, y la sustentación es, literalmente, uno de ellos (criterio 4) — no un criterio "Agregado manual" aparte. Los 4 son cita literal.

| Criterio | Peso | CE / Nivel | A (20 pts) | B (15 pts) | C (10 pts) | D (5 pts) | Calificación obtenida |
|---|---:|---|---|---|---|---|---:|
| 1. Aplica Lazy Loading, Code Splitting, caché del navegador y Redis cuando corresponda, logging, monitoreo básico y buenas prácticas de despliegue | 25% | CE023-N2 (cierre) | Build optimizado medido (antes/después), decisión de caché/Redis justificada con criterio medido, logging y monitoreo básico verificados en vivo. | Optimización presente, con la decisión de Redis o el monitoreo incompleto. | Solo una de las piezas (optimización, caché o monitoreo) presente. | No presenta evidencia de optimización ni monitoreo. | |
| 2. Implementa paginación en listados de alto volumen e integra funcionalmente los módulos de la aplicación | 25% | CE023-N2 (cierre) | Listado paginado con agregado correcto verificado, e integración funcional completa (checklist end-to-end) entre todos los módulos. | Uno de los dos presente y verificado; el otro parcial. | Paginación o integración mencionada sin verificación real. | No presenta paginación ni integración funcional verificable. | |
| 3. Incorpora auditoría y ejecuta pruebas end-to-end, corrige errores y estabiliza el sistema | 25% | CE023-N2 (cierre) | Auditoría real sobre al menos 2 acciones, prueba end-to-end en verde contra la base real, y al menos un hallazgo real en la bitácora con su corrección. | Dos de los tres elementos presentes y verificados. | Solo uno de los tres elementos presente. | No presenta auditoría, pruebas end-to-end ni bitácora. | |
| 4. Sustenta exclusivamente el Proyecto Integrador mediante una demostración funcional y defensa técnica | 25% | CG | Sustenta con claridad y profesionalismo su aporte individual, con demostración funcional en vivo y defensa técnica precisa. | Sustenta con solvencia, con detalles menores en la demostración o la defensa. | Sustenta con dificultad; demostración o defensa insuficientes. | No sustenta adecuadamente ni demuestra su aporte individual. | |

Nota final = suma de (`Peso` × `Puntos de la calificación obtenida`) / 100 × 20.

`CE023-N2 (cierre)` = cierre del Nivel 2 de CE023 (Programación): la [Unidad 2](../u2/lp2-demo.md#6-rubrica-de-evaluacion) ya dejó ese nivel "parcial" (SPA, CRUD, seguridad); esta unidad lo completa con optimización, integración funcional, auditoría y pruebas end-to-end sobre el mismo backend y la misma SPA. `CG` = Competencia General del sílabo de LP2 — el criterio 4 es, en este sílabo, la propia sustentación, a diferencia de otras unidades donde es un criterio transversal aparte.

**Tabla 2. Subaspectos de la sustentación (Unidad 3)**

El criterio 4 se evalúa con los mismos 6 subaspectos de la sustentación integral del Proyecto Integrador ([Guía de Sustentación Final](guia-sustentacion.md#subaspectos-de-la-sustentacion-integral)) — la misma exigencia de Unidad 1 y Unidad 2, ahora en la sustentación final del curso.

| Subaspecto | Qué observa en Unidad 3 |
|---|---|
| 1. Aporte individual | Cada integrante demuestra el hallazgo real que diagnosticó y corrigió (paginación, auditoría o prueba end-to-end). |
| 2. Comunicación y orden | Claridad, estructura, tiempo y lenguaje técnico durante la presentación. |
| 3. Presentación personal y actitud | Puntualidad, vestimenta limpia y adecuada, higiene, cabello ordenado, actitud profesional, respeto, honestidad y coherencia con los valores y principios cristianos de la institución. |
| 4. Repositorio y estándares | Organización, commits y reproducibilidad del código desde S13. |
| 5. MkDocs o equivalente | Documentación de Unidad 3 publicada, navegable y alineada con `lp2-producto.md`. |
| 6. Pitch/demo ejecutiva | La aplicación Full-Stack completa, optimizada y estabilizada, con apoyo visual (.pptx, Canva o equivalente) — no reemplaza la demo técnica de S15, la precede. |

Para usar la rúbrica con IA, solicita:

```text
Evalúa la sustentación y el producto (lp2-producto.md o la sección 2 de la guía S15) usando la rúbrica de esta sección.
Para cada criterio selecciona la calificación obtenida: A=20, B=15, C=10, D=5.
Justifica brevemente cada nivel con evidencia concreta (optimización medida, paginación con agregado correcto, auditoría, pruebas end-to-end, demostración y defensa técnica).
Calcula la nota final con la fórmula: suma de (Peso × Puntos de la calificación obtenida) / 100 × 20.
Indica 2 fortalezas y 2 recomendaciones.
```

## Trazabilidad y procedencia de la rúbrica

Los cuatro criterios son cita literal de los "Criterios de evaluación del producto" de la Unidad 3 en el sílabo de LP2 — incluida la sustentación (criterio 4), que este sílabo integra como criterio propio en vez de agregarla aparte como las demás unidades.

## Cierre LP2

LP2 está completo cuando la base de BomERP continúa el dominio de Ciclo 3, mantiene una sola aplicación Spring Boot y una SPA con módulos cohesionados, ejecuta `Venta–DetalleVenta` de extremo a extremo, aplica seguridad, optimización, caché y observabilidad básica, pagina listados de alto volumen, audita operaciones, supera pruebas end-to-end, queda estabilizada y puede ser sustentada por cada integrante. `Compras` queda como módulo delimitado o ampliación del equipo, no como segundo flujo obligatorio. La preparación para producción tiene alcance académico y debe demostrarse con evidencias reproducibles.
