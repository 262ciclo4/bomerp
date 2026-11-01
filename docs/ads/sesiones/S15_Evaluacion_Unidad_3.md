# S15 - Evaluación de la Unidad III

## 1. Propósito de la evaluación

Esta sesión no enseña contenido nuevo: cierra la Unidad III de **ADS**, y con ella, el curso completo. El sílabo (sesión 15) define dos actividades:

1. Resolver la evaluación teórico-práctica de los temas de la Unidad III (sesiones 13 a 14).
2. Presentar y sustentar el Diseño Técnico Profesional Documentado.

**Esta sesión coincide con la sustentación final integrada del ciclo**, según la [Guía de Sustentación Final](../../proyecto-integrador/u3/guia-sustentacion.md): BD2 y LP2 también cierran su Unidad III esta misma semana, en sus propias sesiones 15. A diferencia de S5 y S12 (cortes solo de ADS), la sustentación de hoy comparte un solo pitch ejecutivo y una sola demo final con los otros dos cursos (Guía de Sustentación Final, "Secuencia sugerida") — el bloque de "Diseño ADS" (3 min) es tu propio espacio dentro de esa sustentación conjunta, no una presentación aparte.

## 2. Producto evaluado

Del sílabo, el producto de la Unidad III (y del curso completo) es:

> Diseño Técnico Profesional Documentado, con arquitectura completa, modelo de dominio, UML, APIs, integraciones, patrones, ADRs y trazabilidad.

El producto completo — plantilla-ejemplo con el contenido de BomERP, verificado contra el código real — vive en [`ads-producto.md`](../../proyecto-integrador/u3/ads-producto.md): componentes finales, matriz de trazabilidad con requerimientos, atributos de calidad justificados, ADR final de referencia, rúbrica de evaluación y trazabilidad de esa rúbrica contra la malla curricular. La estructura es exigible a todos; el contenido de BomERP se reemplaza por el del propio proyecto de cada equipo.

### Lo que acumulaste sesión por sesión

Este producto no se construye en S15: se ensambla con lo que cada sesión anterior ya te pidió sobre tu propio proyecto.

**Tabla 1. De la sesión al dossier técnico profesional**

| Sesión | Qué produjiste (tu propio proyecto) | Dónde queda en `ads-producto.md` |
|---|---|---|
| S13 | Auditoría de consistencia real entre tu Producto U1 y tu Producto U2, con al menos un hallazgo registrado (resuelto o diferido explícitamente) y el dossier consolidado de los cuatro componentes de la unidad. | Componentes finales + Matriz final de trazabilidad |
| S14 | Al menos un ADR formal a partir de un hallazgo real, tus atributos de calidad justificados con evidencia (no solo declarados desde S1), y al menos dos requerimientos reales trazados de punta a punta. | ADR final de referencia + Atributos de calidad: justificación final + Matriz final de trazabilidad |
| S15 (esta sesión) | Ensamblas todo lo anterior —y lo acumulado desde U1-U2— en el dossier técnico profesional final y lo sustentas. | El documento completo + sección 4 de esta guía |

Lo que sustentas en S15 es **tu propio diseño técnico profesional**: la arquitectura, el dominio, el catálogo UML, los ADR y la trazabilidad que tú construiste sobre tu propio dominio — no el de BomERP. `ads-producto.md` muestra cómo se ve ese dossier terminado usando el ejemplo del docente; tu entregable real tiene la misma estructura, con el contenido que tú construiste en S13-S14, sobre la arquitectura y el diseño detallado que S1-S12 ya dejaron construidos.

## 3. Evaluación teórico-práctica (S13-S14)

Cubre los dos temas dictados antes de esta sesión. El docente puede tomarla escrita, oral o mixta.

**Tabla 2. Temario de la evaluación teórico-práctica**

| Sesión | Tema | Qué puede evaluar el docente |
|---|---|---|
| S13 | Integración del Diseño Técnico | Diferencia entre concatenar y consolidar, auditoría de consistencia entre arquitectura (Vista C3) y modelo de dominio, entre el dominio y el catálogo UML/patrones, y entre los patrones y el diseño de integración — y por qué un resultado "consistente" es tan válido como un hallazgo real. |
| S14 | Decisiones Arquitectónicas y Trazabilidad | Las cuatro partes de un ADR (contexto, decisión, alternativas, consecuencias), por qué una decisión de diseño no registrada se pierde con el tiempo, la diferencia entre declarar y justificar un atributo de calidad con evidencia real, y qué eslabones debe tener un requerimiento trazado de punta a punta. |

Preguntas de referencia (el docente puede formular equivalentes):

1. ¿Por qué consolidar un dossier técnico no es lo mismo que concatenar once archivos en uno solo?
2. Da un ejemplo propio (o el de BomERP, `calcularTotal()`) de una decisión de diseño que una sesión posterior contradijo en silencio. ¿Cómo se detecta ese tipo de inconsistencia?
3. ¿Por qué una "Decisión" de ADR debe poder confirmarse o refutarse contra el código real, y no ser solo una intención bien redactada?
4. ¿Qué diferencia hay entre declarar un atributo de calidad (S1) y justificarlo con evidencia (S14)? Da un ejemplo propio de cada uno.
5. ¿Qué eslabones debe tener un requerimiento trazado de punta a punta, y qué significa que uno de ellos quede "registrado como pendiente" en vez de completo?
6. Relaciona el caso de Nygard (S13) con el del Ariane 5 (S14): ¿qué tienen en común una decisión arquitectónica sin registro formal y una asunción de diseño nunca revalidada?

## 4. Sustentación del diseño técnico profesional

**Tabla 3. Distribución de tiempo de la sustentación**

| Momento | Tiempo | Quién | Propósito |
|---|---:|---|---|
| Pitch ejecutivo (diapositiva) | 1-3 min | Grupal | **Una sola vez para los tres cursos** — problema, solución y valor del Proyecto Integrador completo ([Guía de Sustentación Final](../../proyecto-integrador/u3/guia-sustentacion.md)). No se repite en BD2/LP2. |
| Diseño ADS (diapositiva + demo) | 3 min | Grupal | Arquitectura, UML, patrones y ADRs — componentes reales del dossier: al menos un ADR formalizado en S14, la matriz de trazabilidad con requerimientos, y los atributos de calidad justificados. |
| Demo final conjunta | 5 min (compartido con BD2/LP2) | Grupal | Flujo end-to-end autenticado, con el diseño técnico sosteniendo la arquitectura real del sistema en vivo. |
| Preguntas individuales | 3 min por integrante | Individual | Verificar dominio y aporte propio, con base en la Tabla 2. |

**Tabla 4. Entregables obligatorios**

| Entregable | Evidencia mínima | Criterio de aceptación |
|---|---|---|
| Producto final de unidad/curso | [`ads-producto.md`](../../proyecto-integrador/u3/ads-producto.md) completo | Coherente con el sílabo y con el código real del proyecto |
| Evidencia de consolidación | Auditoría real de consistencia entre U1 y U2, con hallazgos registrados | Trazabilidad verificable, no solo documentada |
| Evidencia de decisiones y trazabilidad | ADR formal, atributos de calidad justificados, requerimientos trazados de punta a punta | Verificable contra el código real de LP2/BD2 |
| Sustentación individual | Preguntas y defensa por integrante (sección 3) | Autoría demostrada |

Secuencia sugerida de presentación (referencias a secciones de `ads-producto.md`):

1. Presentar los componentes finales del dossier (arquitectura, dominio, UML, patrones, integración).
2. Mostrar al menos un hallazgo real de la auditoría de consistencia (S13) y su resolución.
3. Presentar el ADR formalizado en S14, con sus cuatro partes y su decisión verificable.
4. Mostrar la tabla de atributos de calidad, con al menos un atributo justificado con evidencia real (no solo declarado desde S1).
5. Recorrer la matriz de trazabilidad final, siguiendo un requerimiento real de punta a punta hasta su prueba.
6. Cerrar explicando cómo el dossier queda listo como insumo directo para BD2 y LP2.

Criterios mínimos de aceptación:

- El dossier consolidado (S13) incluye al menos un hallazgo real de inconsistencia, resuelto o diferido explícitamente.
- El ADR de S14 tiene sus cuatro partes completas, con una decisión verificable contra el código.
- Al menos cuatro atributos de calidad están justificados con evidencia real.
- Al menos dos requerimientos reales están trazados de punta a punta.
- La matriz de trazabilidad final incluye la columna de requerimiento.
- Cada integrante responde individualmente al menos una pregunta de la Tabla 2.

## 5. Rúbrica de evaluación

La rúbrica (6 criterios: 5 cita literal de los criterios de evaluación del producto de la Unidad III + sustentación) vive en [`ads-producto.md`](../../proyecto-integrador/u3/ads-producto.md#rubrica-de-evaluacion), junto con la plantilla del producto y su trazabilidad con la malla curricular (CE021 Nivel 2 y CE024 Nivel 1, ambos en cierre desde esta unidad). Úsala directamente desde ahí para calificar la sustentación de esta sesión — no se duplica aquí.
