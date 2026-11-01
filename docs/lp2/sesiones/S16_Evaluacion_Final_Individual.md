# S16 - Evaluación Final Individual

## 1. Propósito de la sesión

A diferencia de S6 y S12 (evaluación teórico-práctica y sustentación en la misma sesión), el sílabo de LP2 reserva esta sesión para dos actividades distintas, con pesos propios en la evaluación final del curso:

1. **Evaluación final individual teórico-práctica** (10%, peso propio, distinto del 30% de la "Evaluación del producto" de S15) — cubre, de forma acumulativa, los temas de **todo el curso** (S1 a S14), no solo la Unidad III. Es la única evaluación verdaderamente individual y comprensiva del sílabo de LP2.
2. **Continuación de la evaluación de la Unidad III** — para los equipos que no alcanzaron a presentar su sustentación en S15, o que necesitan completar observaciones del jurado.

No hay un segundo producto que construir hoy: la evaluación individual se resuelve sobre lo que ya existe desde S1-S14; la continuación de sustentaciones usa el mismo [`lp2-producto.md`](../../proyecto-integrador/u3/lp2-producto.md) y la misma rúbrica de S15.

## 2. Evaluación final individual teórico-práctica (S1-S14)

Cubre los catorce temas dictados durante todo el curso. El docente puede tomarla escrita, oral o mixta — es individual por diseño, sin trabajo grupal involucrado.

**Tabla 1. Temario acumulado de la evaluación final**

| Sesión | Tema | Qué puede evaluar el docente |
|---|---|---|
| S1 | Arquitectura backend REST profesional | Estructura del proyecto, configuración por ambientes, ORM, driver, conexión, contrato y versionado básico de API. |
| S2 | CRUD REST completo de una entidad principal | DTO de entrada/salida, mapeo explícito, validaciones, manejo global de errores y trazabilidad por petición. |
| S3 | Objetos relacionados mediante REST y ORM | Asociación entre entidades, DTO relacionado, navegación controlada y prevención de ciclos de serialización. |
| S4 | Operación de dominio con cabecera-detalle | DTO compuesto, cálculos, una regla de negocio real, transacción atómica y comunicación entre módulos. |
| S5 | Consultas empresariales y CORS | Filtros combinados, ordenamiento, proyecciones, agregaciones y por qué CORS es una restricción del navegador, no del servidor. |
| S7 | Creación y arquitectura de la SPA | Organización `core`/`shared`/`features`, layout con `router-outlet`, servicio HTTP, interceptor `X-Trace-ID`, CRUD independiente. |
| S8 | CRUD de tablas dependientes | Carga de datos relacionados, *autocomplete*, validación de la dependencia, separación lista/formulario. |
| S9 | Formularios transaccionales con cabecera-detalle | `FormArray` de líneas, cálculo en vivo, validación de al menos una línea, consultas y reportes agregados. |
| S10 / S10b | Seguridad backend y su reemplazo por Keycloak | JWT propio como primer paso pedagógico, por qué se diseñó "listo para reemplazo", y qué cambia (y qué no) al migrar a Keycloak. |
| S11 | Seguridad frontend con Keycloak | *Authorization Code* + PKCE, dónde vive el token, *guards*, interceptor con refresco en `401`, menú por rol. |
| S13 | Optimización y preparación para producción | Lazy Loading, Code Splitting, caché del navegador frente a Redis, logging y Actuator por perfil, Docker para producción. |
| S14 | Integración y estabilización | Paginación sin romper agregados, integración funcional de punta a punta, auditoría real, pruebas end-to-end frente a pruebas con mocks. |

Preguntas de referencia (el docente puede formular equivalentes, una por bloque del curso):

1. ¿Por qué el *layout* de la SPA vive en un componente propio con su propio `router-outlet`, en vez de repetirse en cada pantalla?
2. ¿Por qué `vendedorId` se lee del claim `sub` del token ya verificado, y nunca de un campo que el cliente podría enviar en el `request`?
3. ¿Qué diferencia hay entre el *fallback* de una excepción de negocio y el manejo global de errores de S2?
4. ¿Por qué un `401` dispara un intento de refresco y un `403` no?
5. ¿Por qué paginar un listado, sin más, puede romper un total que antes era correcto? ¿Cómo se evita?
6. ¿Qué detecta una prueba end-to-end real que una prueba de controlador con mocks nunca podría detectar?
7. ¿Por qué la decisión de usar (o no usar) Redis se justifica con evidencia medida, y no por costumbre?
8. Relaciona un caso real citado en cualquier sesión del curso (Nygard, GitLab, Knight Capital, u otro) con una decisión técnica propia de tu proyecto.

## 3. Para equipos pendientes de sustentar la Unidad III

Repite exactamente la secuencia de la sección 3 de [S15](S15_Evaluacion_Unidad_3.md) — "Aplicación LP2", demo final y preguntas individuales — sobre [`lp2-producto.md`](../../proyecto-integrador/u3/lp2-producto.md).

**Criterios mínimos de aceptación:** los mismos de S15, sección 3. No hay una versión reducida de la exigencia por sustentar una semana después.

## 4. Para equipos que ya sustentaron en S15

**Tabla 2. Cierre del producto final**

| Entregable | Qué revisar antes de la entrega final |
|---|---|
| `lp2-producto.md` | Observaciones del jurado de S15 incorporadas, con la bitácora de estabilización actualizada si algo nuevo se corrigió. |
| Backend y SPA | Coherentes con lo sustentado — ningún cambio a medias entre S14 y la entrega final. |
| Documentación (MkDocs o equivalente) | Publicada, navegable, y alineada con el producto final — mismo criterio del subaspecto 5 de la sustentación (S15, `lp2-producto.md`, Tabla 2). |
| Repositorio | Commits y organización reproducibles desde S13, mismo criterio del subaspecto 4. |

## 5. Rúbricas de evaluación

- La evaluación final individual (sección 2 de esta guía) se califica directamente sobre las preguntas de referencia y el temario acumulado — no tiene una tabla de rúbrica A/B/C/D propia, por ser una evaluación teórico-práctica individual, no un producto con evidencia técnica por bloques.
- La sustentación pendiente o la entrega final del producto (secciones 3-4) usan la misma rúbrica de 4 criterios de [`lp2-producto.md`](../../proyecto-integrador/u3/lp2-producto.md#rubrica-de-evaluacion) que ya usó S15 — no se duplica ni se reemplaza aquí.

## 6. Cierre académico

Con esta sesión cierra LP2: el backend modular de U1, la SPA segura de U2, y la optimización, integración, auditoría y estabilización de U3 quedan entregados como una sola aplicación Full-Stack, verificada contra Oracle y Keycloak reales — no solo documentada. La evaluación final individual cierra, además, el curso completo: lo que un estudiante aprendió desde S1, no solo lo último que construyó.
