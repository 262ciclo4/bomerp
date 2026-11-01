# S15 - Evaluación de la Unidad III

## 1. Propósito de la evaluación

Esta sesión no enseña contenido nuevo: cierra la Unidad III de **LP2** con la sustentación del producto final. El sílabo (sesión 15) define, para esta sesión, una sola actividad:

> Presentar la demostración funcional y sustentar técnicamente el Proyecto Integrador Full-Stack.

A diferencia de S6 y S12 (donde la evaluación teórico-práctica y la sustentación ocurren en la misma sesión), el sílabo de LP2 separa ambas actividades en Unidad III: la evaluación teórico-práctica **individual** y acumulativa de todo el curso queda para [S16](S16_Evaluacion_Final_Individual.md), con su propio peso (10%, "Evaluación individual") distinto del de esta sesión (30%, "Evaluación del producto"). Esta sesión evalúa únicamente la demostración y la defensa del producto.

**Esta sesión coincide con la sustentación final integrada del ciclo**, según la [Guía de Sustentación Final](../../proyecto-integrador/u3/guia-sustentacion.md): ADS y BD2 también cierran su Unidad III esta misma semana, en sus propias sesiones 15. La sustentación de hoy es individual de LP2 —tu backend, tu SPA, tu evidencia—, pero la demo final comparte un solo flujo end-to-end con los otros dos cursos.

## 2. Producto evaluado

Del sílabo, el producto de la Unidad III (y del curso completo) es:

> Aplicación Full-Stack empresarial integrada, optimizada, monitoreada, estabilizada y preparada para producción, con evidencias y sustentación técnica.

El producto completo — plantilla-ejemplo con el contenido de BomERP — vive en [`lp2-producto.md`](../../proyecto-integrador/u3/lp2-producto.md): componentes finales, plan de pruebas, bitácora de estabilización (con el hallazgo real de S14 ya registrado), rúbrica de evaluación y trazabilidad de esa rúbrica contra la malla curricular. La estructura es exigible a todos; el contenido de BomERP se reemplaza por el del propio proyecto de cada equipo.

### Lo que acumulaste sesión por sesión

Este producto no se construye en S15: se ensambla con lo que cada sesión anterior ya te pidió sobre tu propio proyecto.

**Tabla 1. De la sesión al producto final**

| Sesión | Qué produjiste (tu propio proyecto) | Dónde queda en `lp2-producto.md` |
|---|---|---|
| S13 | Build optimizado (Lazy Loading, Code Splitting, evidencia antes/después), decisión de caché/Redis justificada con criterio medido, logging y monitoreo básico por perfil, configuración real de producción con Docker. | Componentes finales (Optimización frontend, Caché, Observabilidad, Despliegue) |
| S14 | Listado paginado sin romper sus agregados (con un hallazgo real diagnosticado y corregido), integración funcional verificada de punta a punta, auditoría real sobre acciones críticas, y una prueba end-to-end ejecutada contra la base real. | Componentes finales (Paginación, Auditoría, Pruebas) + Bitácora de estabilización |
| S15 (esta sesión) | Ensamblas todo lo anterior —y lo acumulado desde U1-U2— en el producto final y lo sustentas. | El documento completo + sección 3 de esta guía |

Lo que sustentas en S15 es **tu propia aplicación Full-Stack**: el backend, la SPA y la base de datos que tú construiste sobre tu propio dominio —no el de BomERP. `lp2-producto.md` muestra cómo se ve ese producto terminado usando el ejemplo del docente; tu entregable real tiene la misma estructura, con el contenido que tú construiste en S13-S14, sobre el backend y la SPA que S1-S12 ya dejaron funcionando.

## 3. Sustentación del producto final

**Tabla 2. Distribución de tiempo de la sustentación**

| Momento | Tiempo | Quién | Propósito |
|---|---:|---|---|
| Pitch ejecutivo (diapositiva) | 1-3 min | Grupal | **Una sola vez para los tres cursos** — problema, solución y valor del Proyecto Integrador completo ([Guía de Sustentación Final](../../proyecto-integrador/u3/guia-sustentacion.md)). No se repite en ADS/BD2. |
| Aplicación LP2 (diapositiva + demo) | 5 min | Grupal | Módulos propios, backend, SPA, Keycloak, optimización, caché, observabilidad, paginación y auditoría — componentes reales del producto final. |
| Demo final conjunta | 5 min (compartido con ADS/BD2) | Grupal | Flujo end-to-end autenticado: transacción, persistencia, consulta y evidencia de operación, sobre la arquitectura y la base de datos real. |
| Preguntas individuales | 5 min por integrante | Individual | Aporte y defensa técnica por integrante ([Guía de Sustentación Final](../../proyecto-integrador/u3/guia-sustentacion.md), "Defensa individual"). |

**Tabla 3. Entregables obligatorios**

| Entregable | Evidencia mínima | Criterio de aceptación |
|---|---|---|
| Producto final de unidad/curso | [`lp2-producto.md`](../../proyecto-integrador/u3/lp2-producto.md) completo | Coherente con el sílabo y con el código real ejecutable |
| Evidencia de integración y estabilización | Listado paginado con agregado correcto, integración funcional verificada, auditoría real, prueba end-to-end en verde | Verificable en vivo, no solo documentada |
| Sustentación individual | Defensa técnica por integrante ([Guía de Sustentación Final](../../proyecto-integrador/u3/guia-sustentacion.md), "Defensa individual") | Autoría demostrada |

Secuencia sugerida de presentación (referencias a secciones de `lp2-producto.md`):

1. Presentar los componentes finales: backend REST modular, SPA modular, integración completa.
2. Mostrar el build optimizado (S13) con evidencia antes/después, y la decisión de caché/Redis justificada.
3. Ejecutar en vivo el listado paginado, mostrando que el agregado (total, promedio) sigue siendo correcto sin importar la página.
4. Mostrar el checklist de integración funcional (S14) ejecutado de punta a punta: login, crear, consultar, anular.
5. Mostrar al menos un registro real de auditoría, con actor, acción y fecha.
6. Ejecutar la prueba end-to-end en vivo (o mostrar su salida real), explicando qué detecta que una prueba con mocks no detectaría.
7. Cerrar con la bitácora de estabilización, explicando el hallazgo real de S14 (el agregado nunca conectado) y su corrección.

Criterios mínimos de aceptación:

- La aplicación completa arranca y conecta backend, SPA, Keycloak y Oracle reales, no datos simulados.
- El build optimizado (S13) tiene evidencia real antes/después, con la decisión de caché/Redis justificada.
- El listado paginado (S14) mantiene su agregado correcto, verificado en vivo.
- El checklist de integración funcional (S14, Tabla 6) está completo, verificado en vivo.
- La auditoría registra al menos dos acciones reales, con actor real.
- La prueba end-to-end se ejecuta contra la base real y pasa en verde.
- Cada integrante defiende individualmente su propio aporte ([Guía de Sustentación Final](../../proyecto-integrador/u3/guia-sustentacion.md), "Defensa individual").

## 4. Rúbrica de evaluación

La rúbrica (4 criterios, los cuatro cita literal del sílabo de la Unidad III — a diferencia de otras unidades, la sustentación es aquí uno de los cuatro criterios, no un criterio transversal aparte) vive en [`lp2-producto.md`](../../proyecto-integrador/u3/lp2-producto.md#rubrica-de-evaluacion), junto con la plantilla del producto y su trazabilidad con la malla curricular (CE023 Nivel 2, completo desde esta unidad). Úsala directamente desde ahí para calificar la sustentación de esta sesión — no se duplica aquí.

La evaluación teórico-práctica individual de todo el curso, distinta de esta sustentación, se resuelve en [S16](S16_Evaluacion_Final_Individual.md).
