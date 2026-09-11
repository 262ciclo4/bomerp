# S6 - Descubrimiento y Modelado del Dominio

## 1. Introducción

Tiempo: 20 min.

### 1.1 Presentación de la sesión

La Unidad I dejó decidido el estilo arquitectónico y las vistas C1-C3 del sistema; todavía no dice qué reglas de negocio protege ese sistema por dentro. Esta sesión abre la Unidad II mirando hacia adentro del contenedor "backend": qué entidades existen, qué reglas gobiernan sus cambios de estado, cómo se agrupan en módulos y qué límite de consistencia necesita protección real, no solo documentación. Ese límite (el **agregado**) es lo que LP2 va a implementar como transacción y BD2 como restricción Oracle — sin descubrirlo aquí, ambos cursos improvisan por separado.

### 1.2 Índice

1. Identificación de entidades y reglas de negocio.
2. Agrupación funcional y delimitación de módulos.
3. Casos de uso relevantes.
4. Objetos de valor.
5. Diseño estratégico de Domain-Driven Design (lenguaje ubicuo, agregado como límite de consistencia).

### 1.3 Propósito de aprendizaje

Al concluir la clase, estarás en condiciones de:

- **Descubrir y modelar** el dominio de tu propio proyecto: identificar entidades y reglas de negocio, agruparlas en módulos funcionales, reconocer casos de uso relevantes y objetos de valor, y aplicar diseño estratégico de Domain-Driven Design para delimitar el agregado que protege la consistencia del proceso transaccional.

### 1.4 Producto de sesión

Modelo de dominio inicial: entidades, reglas de negocio, módulos funcionales delimitados, casos de uso relevantes, objetos de valor y el primer diseño estratégico de DDD (lenguaje ubicuo y agregado) de tu propio proyecto.

### 1.5 Metodología

**Tabla 1. Metodología de la sesión**

| Actividades a Realizar en el Periodo | Orientaciones generales (Orientaciones Metodológicas) | Material de estudio recomendado |
|---|---|---|
| Revisión previa individual | Releer el SRS y las reglas de negocio del propio proyecto (Ciclo 3, si continúa un dominio existente). Trabajo individual, antes de clase; traer identificadas al menos cinco entidades candidatas. | Sílabo ADS U2, SRS propio del equipo. |
| Clase presencial | Descubrimiento guiado de entidades, reglas, módulos, casos de uso, objetos de valor y agregado para BomERP. Trabajo individual, siguiendo al docente paso a paso; consulta inmediata ante dudas de límite de módulo. | Plantillas de las tablas de 3.1-3.7. |
| Evaluación formativa | Revisión en clase del modelo de dominio inicial (entidades, reglas, módulos, agregado). La evidencia se completa y sustenta de forma individual, fuera del aula, según los criterios mínimos de la sección 4.4. | Indicaciones de entrega (4.3), rúbrica de evaluación (4.6). |

### 1.6 Motivación de la sesión

#### 1.6.1 Caso: BomERP (`Categoria`–`Producto`–`Venta`–`DetalleVenta`)

BomERP ya tiene arquitectura y vistas C1-C3 (Unidad I), pero ninguna de esas vistas dice qué pasa si dos cambios simultáneos dejan el total de una venta descuadrado con sus detalles, o si el stock de un producto queda en negativo. Esas son reglas de negocio del dominio, no decisiones de arquitectura — y hasta que no se descubren y modelan explícitamente, cualquier implementación en LP2 las resuelve por intuición, distinta en cada módulo.

**Preguntas de análisis**

**Activación de conocimientos previos**

1. ¿Qué entidades del sistema ya mencionaste en tu arquitectura de Unidad I sin definir todavía sus reglas internas?
2. ¿Qué pasa hoy en tu proyecto si un descuento deja el precio de un producto en un valor absurdo?
3. ¿Por qué "Producto" y "Venta" no deberían vivir en el mismo módulo funcional?

**Comprensión del modelado de dominio**

1. ¿Qué diferencia hay entre una entidad (tiene identidad, cambia en el tiempo) y un objeto de valor (se compara por su contenido, es inmutable)?
2. Si dos operaciones distintas pueden dejar inconsistente el total de una venta frente a sus detalles, ¿qué objeto debería ser responsable de impedirlo?

### 1.7 Ubicación en el curso

- Producto del curso: Diseño Técnico Profesional Documentado.
- Producto de unidad: Catálogo UML con patrones de diseño e integración aplicados.
- Avance del producto en esta sesión: entidades, reglas de negocio, módulos delimitados, casos de uso relevantes, objetos de valor y agregado inicial.

Roadmap del producto de la unidad:

**Figura 1. Roadmap del producto de la unidad**

```mermaid
flowchart TB
    S6["`**S6:** Descubrimiento y modelado del dominio`"]
    S7["`**S7:** Diseño de clases del dominio`"]
    S8["`**S8:** Diseño avanzado y transformación OR`"]
    S9["`**S9:** Diagramas dinámicos UML`"]
    S10["`**S10:** Patrones y arquitectura empresarial`"]
    S11["`**S11:** Integración y sistemas empresariales`"]
    S12["`**S12:** Producto U2`"]

    S6 --> S7 --> S8 --> S9 --> S10 --> S11 --> S12

    classDef today fill:#ffe08a,stroke:#9a6b00,stroke-width:2px,color:#111;
    class S6 today;
```

## 2. Explica

Tiempo: 25 min.

### 2.1 Arquitectura de la sesión

**Figura 2. Flujo de descubrimiento del dominio de BomERP**

```mermaid
flowchart TB
    A[SRS y reglas de negocio] --> B[Entidades y reglas]
    B --> C[Módulos funcionales]
    C --> D[Casos de uso relevantes]
    D --> E[Objetos de valor]
    E --> F[Diseño estratégico DDD<br/>lenguaje ubicuo y agregado]
```

Lectura del diagrama:

- El modelo de dominio no arranca dibujando clases: arranca releyendo el SRS y las reglas de negocio ya conocidas, de ahí salen entidades, luego módulos, casos de uso, objetos de valor y recién al final el agregado — en ese orden, porque el agregado se decide sobre entidades y reglas ya identificadas, no al revés.
- Sin este orden, el "agregado" termina siendo una decisión arbitraria sin relación con una regla de negocio real que proteger.
- Integración (referencia, no requisito para esta sesión): el agregado que se delimite aquí es el mismo límite que LP2 ya implementó como transacción (`@Transactional` sobre `Venta`–`DetalleVenta`, su propia S4) y que BD2 restringe con `CHECK`/triggers a nivel de esquema. **Errores frecuentes**: modelar entidades sin revisar antes las reglas de negocio (el agregado queda mal delimitado); tratar todo objeto como entidad, incluso lo que se compara solo por su valor (precio, rango de fechas); o delimitar módulos por conveniencia de archivo en vez de por cohesión de reglas.

Este diagrama es el mapa que guía el resto de la explicación: cada apartado siguiente desarrolla uno de sus componentes, en el mismo orden del Índice (1.2).

### 2.2 Identificación de entidades y reglas de negocio

Una **entidad** tiene identidad propia (un identificador que la distingue) y cambia de estado en el tiempo sin dejar de ser la misma instancia. Una **regla de negocio** es una condición que el dominio impone sobre esos cambios de estado, independiente de cómo se implemente después en código o base de datos.

En BomERP: `Categoria`, `Producto`, `Venta`, `DetalleVenta` y `Cliente` son entidades (cada una con su propio identificador y ciclo de vida). `Cliente` ya aparece referenciado en el diagrama de clases de `u2/ads-producto.md` (`Venta.cliente`), pero hasta hoy nadie lo había descubierto como entidad propia, con su propio ciclo de vida independiente de cualquier venta puntual. Reglas de negocio ya conocidas del dominio: un producto se registra con una categoría existente; una venta no puede registrarse con stock insuficiente; el total de una venta debe cuadrar con la suma de sus detalles; solo una venta en estado `REGISTRADA` puede anularse; una venta debe estar asociada a un cliente registrado, y un cliente suspendido no puede registrar una venta nueva.

**Error frecuente**: confundir una regla de negocio con una validación de formato (por ejemplo, "el nombre no puede estar vacío") — las reglas de negocio protegen invariantes del dominio, no solo la forma de un dato.

### 2.3 Agrupación funcional y delimitación de módulos

Un **módulo funcional** (en DDD, **bounded context**: un límite explícito dentro del cual un modelo y su lenguaje son consistentes) agrupa entidades y reglas que cambian juntas por la misma razón de negocio — la misma cohesión que ya se verificó con Spring Modulith en Unidad I, pero decidida aquí desde el dominio, no desde el código.

Un ERP como BomERP es precisamente el tipo de dominio donde esta habilidad se pone a prueba: no hay dos módulos obvios, hay varios módulos candidatos compitiendo por las mismas entidades, y trazar mal el límite entre ellos es el error más caro de corregir después. Para trazarlo bien, DDD clasifica cada módulo candidato por el tipo de subdominio que resuelve, no solo por qué entidades contiene:

**Tabla 2. Subdominios de BomERP**

| Módulo candidato | Tipo de subdominio | Por qué |
|---|---|---|
| `ventas` | **Core** (el negocio mismo) | Es la razón de existir de un ERP comercial: ahí vive la lógica más valiosa y compleja (consistencia transaccional, anulación, auditoría). |
| `catalogo` | Supporting | Necesario para que exista algo que vender, pero no es el diferenciador — cualquier ERP tiene un catálogo parecido. |
| `clientes` | Supporting | Necesario para saber a quién se le vende y aplicar reglas propias del cliente (suspensión, tipo), pero no es el diferenciador — un directorio de clientes es genérico entre ERP. |
| `inventario` (candidato) | Supporting | Sostiene la disponibilidad para vender; acoplado a `catalogo`, pero su lógica de movimientos es genérica entre distintos ERP. |
| `compras` (candidato) | Supporting | Sostiene el inventario, con reglas de aprobación propias del negocio, pero es un proceso bastante estándar en cualquier ERP. |
| `seguridad` (candidato) | **Generic** (problema ya resuelto) | Autenticación y autorización no son el negocio de BomERP — por eso otros proyectos de este mismo programa lo resuelven con un IAM externo (Keycloak) en vez de construirlo; aquí se construye con JWT solo porque es contenido de aprendizaje del sílabo de LP2 (S10), no porque diferencie al negocio. |

Un subdominio **Core** justifica invertir el mayor esfuerzo de modelado (por eso `ventas` es el único módulo, junto con `catalogo` y `clientes`, con sesión propia ya en esta unidad); un subdominio **Generic** casi nunca debería construirse desde cero en un proyecto real — se reconoce igual, aunque este curso lo construya por razones pedagógicas.

Delimitar el módulo no basta: también hay que decidir cómo se relacionan entre sí, porque un bounded context nunca vive aislado.

- `ventas` (Core) consume `catalogo` (Supporting) **por referencia, no por composición**: `DetalleVenta` no incluye el objeto `Producto` completo, solo su id y una copia congelada del precio al momento de la venta — si mañana `catalogo` cambia el precio de un producto, una venta ya registrada no debe cambiar. Esta es la razón real (no solo de estilo) por la que `Dinero` se modela como valor copiado en el detalle, no como referencia viva al catálogo (ver 2.5).
- `ventas` (Core) consume `clientes` (Supporting) con el mismo patrón: `Venta` guarda solo el id del cliente, no lo compone — un cliente existe antes, durante y después de cualquier venta puntual, con su propio ciclo de vida (puede quedar suspendido sin que eso borre su historial de ventas ya registradas). Dos módulos distintos, la misma regla de referencia, no composición.
- `catalogo` e `inventario` (candidato) comparten el concepto de "stock disponible" con responsabilidades distintas: `catalogo` puede mostrar un stock de lectura rápida en `Producto.stock`, pero la fuente de verdad de cuánto stock hay debería ser la suma de movimientos que `inventario` registre (`MovimientoStock`), no un contador editado directamente desde dos módulos a la vez.
- `compras` (candidato) alimenta a `inventario` (candidato): una orden de compra recibida genera movimientos de entrada de stock — `compras` produce el evento, `inventario` lo consume.
- `seguridad` (candidato) no se consume por composición desde ningún otro módulo: todos los demás solo guardan el id del usuario como referencia para auditoría (quién vendió, quién registró el movimiento) — nadie más necesita conocer las reglas internas de `Usuario`/`Rol`.

**Prueba de tres partes: ¿referencia o composición?** Cuando dos entidades están relacionadas, no se componen automáticamente solo por estar cerca en el flujo de negocio. Se componen (una vive dentro del agregado de la otra) solo si las tres pruebas dan que sí:

1. **Ciclo de vida:** ¿la entidad "hija" tiene sentido sin la entidad "padre"? (`DetalleVenta` no tiene sentido sin su `Venta` → compone. `Cliente` sí tiene sentido sin ninguna `Venta` puntual → no compone, se referencia).
2. **Cardinalidad:** ¿la misma instancia se reutiliza en muchas instancias del padre a lo largo del tiempo? Si sí, componerla duplicaría sus datos en cada una.
3. **Invariante compartido:** ¿alguna regla de negocio exige que ambas cambien juntas, atómicamente, en la misma transacción? Si la relación solo exige que la referencia sea válida *al momento de* usarla (no que cambien juntas), no compone.

Esta prueba de tres partes no es una invención de esta guía: simplifica dos de las **"Rules of Aggregate Design" de Vaughn Vernon** (*Implementing Domain-Driven Design*, ya citado en la Bibliografía) — la Regla 1 ("protege invariantes reales dentro del límite de consistencia") es la base de la prueba 3; la Regla 3 ("referencia otros agregados solo por identidad, nunca por objeto completo") es la base de por qué `Venta` guarda `clienteId`, no un `Cliente` completo. Las pruebas 1 y 2 son una forma más concreta y verificable de aplicar esas reglas, no una regla adicional de Vernon.

Esta misma prueba separa `Proveedor` de `OrdenCompra` dentro de `compras`, aunque `compras` todavía no tenga sesión propia: un proveedor existe antes y después de cualquier orden puntual (1), participa en muchas órdenes a la vez (2), y aprobar una orden no exige modificar el proveedor en la misma transacción (3) — así que `Proveedor`, igual que `Cliente`, queda como entidad referenciada, no compuesta dentro de `OrdenCompra`.

**Otras técnicas de DDD para delimitar módulos** (fuera del alcance de esta sesión, quedan como referencia): *Event Storming* (Alberto Brandolini) — taller colaborativo donde el equipo mapea eventos de negocio en una pared y los límites emergen de cómo se agrupan naturalmente, útil para *descubrir* módulos junto al negocio, no solo para *verificar* uno ya propuesto; el **cambio de significado del lenguaje ubicuo** (Evans) — si la misma palabra significa algo distinto en dos partes del sistema (`Producto` para `ventas` es "algo con precio"; para un futuro `inventario` sería "algo con ubicación y cantidad física"), ahí hay una señal de límite, aunque compartan el nombre; y los **patrones de Context Mapping** (Shared Kernel, Customer/Supplier, Anti-Corruption Layer) — no deciden el límite en sí, describen cómo se relacionan dos bounded contexts ya delimitados, un nivel más detallado que los bullets de esta sección.

**El tamaño del módulo no es el criterio.** `clientes` tiene una sola entidad (`Cliente`) y aun así es su propio módulo, con el mismo derecho que `ventas`, que tiene dos — el número de tablas no decide el límite, la prueba de tres partes sí. Un módulo de una sola entidad es tan válido como uno de diez, si esa entidad falla las tres pruebas de composición frente a todo lo demás.

¿Y cuándo sí se juntan dos entidades en el mismo módulo, entonces — como `Venta` y `DetalleVenta` en `ventas`? Solo cuando la prueba da que sí en las tres partes a la vez: `DetalleVenta` no tiene sentido sin su `Venta` (1, ciclo de vida dependiente); cada `DetalleVenta` pertenece a exactamente una `Venta`, no se reutiliza entre varias (2, cardinalidad); y el invariante de `Venta` — el total debe cuadrar con la suma de los detalles — exige que ambas cambien atómicamente en la misma transacción (3, invariante compartido). Si `Cliente` pasara esas mismas tres pruebas frente a `Venta`, también se uniría a `ventas` como un solo módulo — pero no las pasa (existe antes y después de cualquier venta puntual, se reutiliza en muchas, y no comparte ningún invariante transaccional con una venta específica), y por eso queda separado, aunque esté "cerca" del proceso de venta.

**La prueba dice cuándo puedes separar, no que siempre debas hacerlo al máximo.** Separar un módulo tiene un costo real: más referencias cruzadas, más lugares donde mantener consistencia, más piezas que coordinar — incluso dentro de un mismo monolito modular, sin costo de red pero con costo cognitivo y de mantenimiento. Si en la práctica dos entidades casi siempre cambian juntas y casi nunca por separado, unirlas puede ser la decisión más simple, aunque la prueba técnica permitiera separarlas. Regla práctica (la misma que recomienda Vernon): ante la duda, empieza con menos módulos, más grandes, y sepáralos después, cuando el dolor real de tenerlos juntos aparezca — no al revés.

**Bounded context no es lo mismo que microservicio.** Seis o siete módulos funcionales dentro de un solo backend (monolito modular, verificado con Spring Modulith) siguen siendo perfectamente manejables — es exactamente lo que esta unidad enseña a delimitar. Seis o siete *microservicios* separados, cada uno con su propio despliegue, base de datos y contrato de red que coordinar, es un problema de otra naturaleza completamente distinta. La prueba de tres partes decide límites conceptuales dentro del modelo de dominio; cuántos servicios desplegar es una decisión de arquitectura aparte (Unidad 2, S10), que no se toma solo por haber identificado varios módulos aquí.

**Dos ejemplos reales, del curso de Desarrollo de Aplicaciones Distribuidas (DIST), para ver el mismo principio en la práctica** ([`produccion.md`](https://github.com/262dist/pagatu/blob/main/docs/proyecto-sello/produccion.md) y [`acad.md`](https://github.com/262dist/pagatu/blob/main/docs/proyecto-sello/acad.md) del Proyecto Sello de DIST):

**Figura 5. ERP de Producción y Comercialización — seis módulos, un solo backend**

```mermaid
flowchart TB
    Compras["1. COMPRAS<br/>proveedores, cotizaciones,<br/>órdenes de compra"]
    Inventario["2. INVENTARIO<br/>recepción (pesaje, calidad, lotes),<br/>almacenes y existencias,<br/>despacho (picking, entrega)"]
    Produccion["3. PRODUCCIÓN<br/>fórmulas, órdenes,<br/>consumo, rendimiento"]
    Ventas["4. VENTAS<br/>clientes, cotizaciones,<br/>pedidos, precios"]
    Cliente(["CLIENTE"])
    Portal(["PORTAL WEB<br/>· anónimo: catálogo + contacto<br/>· con sesión: login + menú por rol"])

    Compras -->|"orden de compra<br/>(recepción)"| Inventario
    Inventario --> Produccion
    Produccion -->|"productos terminados,<br/>subproductos, mermas"| Inventario
    Inventario -->|"disponibilidad"| Ventas
    Ventas -->|"pedido aprobado<br/>(despacho)"| Inventario
    Inventario --> Cliente
    Portal -->|"solicitud de<br/>contacto/pedido"| Ventas

    Finanzas["5. FINANZAS<br/>cuentas por pagar (Compras),<br/>cuentas por cobrar (Ventas), caja"]
    Administracion["6. ADMINISTRACIÓN<br/>usuarios, roles, permisos,<br/>catálogos compartidos, auditoría"]

    Compras -->|"cuenta por pagar"| Finanzas
    Ventas -->|"cuenta por cobrar"| Finanzas
```

*Nota.* Adaptado de *Sistema Integral de Gestión de Producción y Comercialización* (`produccion.md`), Proyecto Sello de DIST, UPeU.

Los seis módulos corren en **un solo desplegable** — ningún microservicio. `Inventario` junta recepción y despacho a propósito: son dos operaciones distintas sobre el mismo invariante (la existencia nunca queda negativa) — pasan la prueba 3 como una sola unidad, el mismo criterio que usa Odoo (`stock` frente a `purchase`/`sale`). `clientes` vive dentro de `ventas` en vez de separado: en rigor no pasa las tres pruebas (tiene ciclo de vida propio, se reutiliza en muchos pedidos), pero el equipo eligió empezar así — es la "primera separación", válida hasta que el dolor de tenerlos juntos aparezca.

**Figura 6. Sistema académico — mismos tres módulos, dos formas válidas de desplegarlos**

```mermaid
flowchart TB
    subgraph A["A. Monolito modular — un solo despliegue"]
        direction TB
        ClienteA["Cliente"]
        subgraph APPA["Aplicación (1 proceso)"]
            direction TB
            CurriculoA["Módulo Currículo"]
            PlanificacionA["Módulo Planificación"]
            MatriculaA["Módulo Matrícula"]
            MatriculaA -->|"llamada Java directa"| PlanificacionA
            PlanificacionA -->|"llamada Java directa"| CurriculoA
        end
        DBA[("1 base de datos<br/>schemas separados")]
        ClienteA --> APPA
        APPA --> DBA
    end

    subgraph B["B. Microservicios — un despliegue por servicio"]
        direction TB
        ClienteB["Cliente"]
        GatewayB["API Gateway"]
        CurriculoB["Servicio Currículo"]
        PlanificacionB["Servicio Planificación"]
        MatriculaB["Servicio Matrícula"]
        DBCurriculoB[("BD Currículo")]
        DBPlanificacionB[("BD Planificación")]
        DBMatriculaB[("BD Matrícula")]
        ClienteB --> GatewayB
        GatewayB --> CurriculoB
        GatewayB --> PlanificacionB
        GatewayB --> MatriculaB
        MatriculaB -.->|"HTTP"| PlanificacionB
        PlanificacionB -.->|"HTTP"| CurriculoB
        CurriculoB --> DBCurriculoB
        PlanificacionB --> DBPlanificacionB
        MatriculaB --> DBMatriculaB
    end
```

*Nota.* Adaptado de *Sistema Universitario Integrado* (`acad.md`), Proyecto Sello de DIST, UPeU.

Los **mismos tres módulos conceptuales** (`Currículo`, `Planificación`, `Matrícula`) se implementan de dos formas — en A, un solo proceso con llamadas Java directas entre módulos; en B, tres procesos independientes que se llaman por red — sin que el modelo de dominio cambie en absoluto. El sistema académico real de DIST hace algo más específico todavía: junta `Currículo` y `Planificación` con otros dos dominios más (datos maestros de `Personas`/`Institucional`) en **un solo monolito modular**, y separa `Matrícula` como microservicio propio — no porque la prueba de tres partes lo distinga más que a los demás (lo distingue igual), sino porque tiene picos de carga reales que el resto del sistema no tiene (miles de estudiantes matriculándose al mismo tiempo). `Finanzas del Estudiante` y `Pagos en línea` también se separan, por manejar dinero con requisitos de seguridad y cumplimiento distintos. Ningún módulo se separó "porque sí" — cada separación tiene una razón operacional concreta, además de ser un bounded context distinto.

La lección de los dos ejemplos juntos: la prueba de tres partes encuentra las costuras *posibles*; decidir cuáles de esas costuras se convierten en un servicio desplegado aparte depende de razones operacionales (escala, seguridad, equipo, ciclo de release) que esta sesión no evalúa — eso se decide más adelante, con información que esta sesión todavía no tiene.

**Hallazgo de aplicar DDD aquí:** `Producto.stock`, tal como ya se usa en BD2/LP2 (S4-S5), es en realidad una vista denormalizada de algo que el módulo `inventario` todavía no existe para gobernar. Cuando `inventario` reciba su propia sesión, su primer trabajo de modelado será decidir si esa columna se conserva como caché de lectura o se recalcula desde el ledger de movimientos — no es un error de BD2/LP2, es una decisión de límite de contexto que esta sesión recién deja planteada.

**Error frecuente**: agrupar por tipo técnico (todas las entidades juntas, todos los DTO juntos) en vez de por razón de negocio — eso es organización por capa, no por módulo funcional. Otro error frecuente: tratar todos los módulos candidatos como si tuvieran la misma importancia — un subdominio Core exige el modelado más cuidadoso; uno Generic no debería competir por ese mismo esfuerzo.

### 2.4 Casos de uso relevantes

Un **caso de uso relevante** describe una interacción completa entre un actor y el sistema que produce un resultado de valor para el negocio — no cada método de una clase, solo los que un stakeholder reconocería como "algo que el sistema hace por mí".

En BomERP: *Registrar producto*, *Registrar venta* (cabecera y detalle en la misma operación), *Anular venta*, *Consultar ventas por filtro y rango de fecha*. No son casos de uso relevantes operaciones internas como "calcular subtotal de una línea" — esas son parte de la implementación de *Registrar venta*, no un caso de uso aparte.

**Error frecuente**: listar un caso de uso por cada operación CRUD (crear, listar, actualizar, eliminar) sin filtrar cuáles realmente representan una decisión o un proceso de negocio.

### 2.5 Objetos de valor

Un **objeto de valor** no tiene identidad propia: dos instancias con el mismo contenido son intercambiables, y una vez creado no cambia — cualquier "cambio" en realidad crea una instancia nueva. Se usa para conceptos que el dominio compara por su valor, no por quién los creó.

En BomERP: `Dinero` (monto + moneda) es un candidato claro de objeto de valor para `Producto.precio` y `DetalleVenta.precioUnitario`/`subtotal` — dos montos de S/ 50.00 son el mismo valor sin importar en qué línea aparezcan, y sumar o comparar montos debe hacerse con una lógica propia (por ejemplo, no mezclar monedas), no con aritmética suelta repetida en cada clase. Un `RangoFecha` (desde/hasta) para las consultas de S5 de LP2 es otro candidato: se compara por su contenido, no por identidad.

**Error frecuente**: modelar todo como entidad "por si acaso necesita cambiar" — eso agrega identidad y ciclo de vida innecesarios a algo que el dominio solo necesita comparar por su valor.

### 2.6 Diseño estratégico de Domain-Driven Design

**Domain-Driven Design (DDD)** es un enfoque para diseñar software modelando el código directamente sobre el dominio del negocio, no sobre la base de datos ni sobre la conveniencia técnica — la idea central es que el modelo de software y el modelo mental del negocio deben ser el mismo modelo, no dos traducciones que se desalinean con el tiempo. DDD trabaja en dos niveles: el **diseño estratégico** (el que corresponde a esta sesión) delimita el vocabulario compartido y los límites de consistencia del dominio; el **diseño táctico** (patrones como Aggregate, Repository o Entity ya implementados en código, que esta misma asignatura contrasta con el Service Layer clásico en **S10 de ADS**, "Patrones de Diseño y Arquitectura Empresarial") construye esos límites dentro del código. Sin el diseño estratégico primero, el diseño táctico no tiene sobre qué límite aplicarse — por eso esta sesión antecede a S10.

Las dos herramientas de diseño estratégico que se aplican en esta sesión son el lenguaje ubicuo y el agregado.

El **lenguaje ubicuo** es el vocabulario que el equipo técnico y el negocio comparten sin traducción: si el negocio dice "anular una venta", el código dice `venta.anular()`, no `venta.setEstado(3)`. El **agregado** es el límite de consistencia transaccional: un conjunto de entidades que deben cambiar juntas, atómicamente, para que una regla de negocio nunca quede violada — se accede siempre a través de su raíz (*aggregate root*), nunca modificando un elemento interno por su cuenta.

En BomERP, `Venta` es la raíz del agregado `Venta`–`DetalleVenta`: sus invariantes (el total debe cuadrar con la suma de los detalles; el stock del producto nunca queda negativo; solo una venta `REGISTRADA` puede anularse) solo se protegen si toda modificación pasa por `Venta`, no directamente por `DetalleVenta`. `Categoria` y `Producto` no comparten ese mismo agregado — un cambio de categoría no necesita la misma atomicidad que registrar una venta completa.

**Error frecuente**: declarar "todo es un agregado" o, al contrario, un único agregado gigante para todo el sistema — el agregado se delimita por la regla de negocio que protege, no por conveniencia de diseño.

## 3. Aplica: actividad práctica guiada

Tiempo: 2h.

**Actividad:** descubrimiento guiado del modelo de dominio de BomERP: entidades, reglas de negocio, módulos, casos de uso relevantes, objetos de valor y diseño estratégico de DDD (Producto de la sesión en 1.4).

**Propósito de la actividad:** construir el primer modelo de dominio de BomERP — entidades con sus reglas, módulos delimitados, casos de uso relevantes, objetos de valor y el agregado que protege la consistencia transaccional — nombrando en términos de dominio el mismo límite que LP2 ya implementó como transacción (S4) y que BD2 ya restringe a nivel de esquema (S1-S5).

**Orientaciones metodológicas:** en el laboratorio, el docente guía el descubrimiento de entidades, reglas, módulos, casos de uso, objetos de valor y agregado para BomERP paso a paso frente a la clase; los estudiantes completan las mismas tablas para el dominio de su propio proyecto de equipo (ver sección 4).

**Actividades para realizar:**

- **3.1** Identificar entidades y reglas de negocio.
- **3.2** Delimitar módulos funcionales.
- **3.3** Reconocer casos de uso relevantes.
- **3.4** Identificar objetos de valor.
- **3.5** Aplicar diseño estratégico de DDD (lenguaje ubicuo y agregado).
- **3.6** Bosquejar el modelo de dominio inicial.
- **3.7** Trazar ADS con BD2 y LP2.

### 3.1 Identificar entidades y reglas de negocio

**Producto del paso:** listado de entidades con sus reglas de negocio asociadas.

**Tabla 3. Entidades y reglas de negocio de BomERP**

| Entidad | Identificador | Regla de negocio asociada |
|---|---|---|
| `Categoria` | id | Un producto se registra con una categoría existente. |
| `Producto` | id | Un descuento no puede dejar el precio fuera de rango razonable. |
| `Venta` | id | El total debe cuadrar con la suma de los detalles; solo una venta `REGISTRADA` puede anularse; debe estar asociada a un cliente registrado. |
| `DetalleVenta` | id | No puede registrarse con stock insuficiente del producto asociado. |
| `Cliente` | id | Un cliente suspendido no puede registrar una venta nueva. |

### 3.2 Delimitar módulos funcionales

**Producto del paso:** agrupación de entidades en módulos con su razón de cohesión.

**Tabla 4. Módulos funcionales de BomERP**

| Módulo | Entidades | Razón de cohesión |
|---|---|---|
| `catalogo` | `Categoria`, `Producto` | Cambian por decisiones de qué existe y a qué precio, no por el proceso de venderlo. |
| `ventas` | `Venta`, `DetalleVenta` | Cambian juntas por el proceso comercial de venta; el dinero fluye hacia adentro. |
| `clientes` | `Cliente` | Cambia por identidad y estado del comprador (alta, suspensión), independiente de si compró o no en este momento. |
| `inventario` (candidato, futuro) | `MovimientoStock` | Cambia por recepción o consumo físico de stock — una razón distinta de "qué existe" (`catalogo`); sin sesión asignada aún, no se modela en profundidad todavía. |
| `compras` (candidato, futuro) | `OrdenCompra` (`Proveedor` referenciado, no compuesto — misma prueba que `Cliente`) | El dinero fluye hacia afuera, con reglas de aprobación propias — lo opuesto de `ventas`; delimitado, no obligatorio en esta unidad. |
| `seguridad` (candidato, futuro) | `Usuario`, `Rol` | Cambia por identidad y acceso, no por el negocio de catálogo o ventas; se implementa en S10 (Patrones y arquitectura empresarial). |

### 3.3 Reconocer casos de uso relevantes

**Producto del paso:** lista de casos de uso relevantes por módulo.

**Tabla 5. Casos de uso relevantes de BomERP**

| Módulo | Caso de uso | Valor para el negocio |
|---|---|---|
| `catalogo` | Registrar producto | Ampliar el catálogo disponible para la venta. |
| `catalogo` | Actualizar stock | Mantener el inventario disponible confiable. |
| `ventas` | Registrar venta | Concretar una transacción comercial con su detalle. |
| `ventas` | Anular venta | Revertir una transacción sin dejar el stock inconsistente. |
| `ventas` | Consultar ventas por filtro y fecha | Dar soporte a reportes y auditoría. |
| `clientes` | Registrar cliente | Habilitar a un comprador para registrar ventas. |
| `clientes` | Suspender cliente | Impedir nuevas ventas a un cliente sin borrar su historial. |

### 3.4 Identificar objetos de valor

**Producto del paso:** objetos de valor candidatos y qué reemplazan.

**Tabla 6. Objetos de valor candidatos**

| Objeto de valor | Reemplaza a | Por qué es objeto de valor |
|---|---|---|
| `Dinero` (monto + moneda) | `precio`, `precioUnitario`, `subtotal` sueltos como `BigDecimal` | Se compara por contenido; dos montos iguales son intercambiables; no tiene ciclo de vida propio. |
| `RangoFecha` (desde/hasta) | Parámetros sueltos `desde`, `hasta` en la consulta de S5 (LP2) | Se compara por contenido; agrupa una validación propia (desde ≤ hasta) en un solo lugar. |

### 3.5 Aplicar diseño estratégico de DDD

**Producto del paso:** glosario de lenguaje ubicuo y delimitación del agregado.

**Tabla 7. Lenguaje ubicuo de BomERP**

| Término del negocio | Significado compartido | Cómo se ve en el código |
|---|---|---|
| Venta | Transacción comercial registrada, con su detalle. | `Venta.registrar()` |
| Anular | Revertir una venta activa sin eliminarla del historial. | `Venta.anular()` |
| Stock | Cantidad disponible de un producto para la venta. | `Producto.stock` |
| Suspender | Impedir que un cliente registre ventas nuevas, sin borrar su historial. | `Cliente.suspender()` |

**Figura 3. Agregado `Venta`–`DetalleVenta`**

```mermaid
flowchart TB
    subgraph AGG["Agregado: Venta (raíz)"]
        V[Venta]
        D[DetalleVenta]
        V -->|contiene, protege invariantes| D
    end
    EXT[Cualquier acceso externo] -->|solo a través de la raíz| V
    EXT -.->|prohibido: modificar directo| D
```

### 3.6 Bosquejar el modelo de dominio inicial

**Producto del paso:** esquema inicial del modelo de dominio (sin atributos ni operaciones todavía — eso se detalla en S7).

**Figura 4. Esquema inicial del modelo de dominio de BomERP**

```mermaid
flowchart LR
    subgraph MCAT["Módulo catalogo"]
        CAT[Categoria]
        PROD[Producto]
        CAT --- PROD
    end
    subgraph MVEN["Módulo ventas - agregado"]
        VEN[Venta]
        DET[DetalleVenta]
        VEN --- DET
    end
    subgraph MCLI["Módulo clientes"]
        CLI[Cliente]
    end
    PROD -.->|referenciado por| DET
    CLI -.->|referenciado por| VEN
```

Este esquema es intencionalmente simple: el diagrama de clases completo, con atributos, operaciones y multiplicidades, se construye en S7. Aquí solo se fija qué entidades existen, en qué módulo viven y cuál es el agregado.

**Dónde vive esto en el modelo C4 (S2):** los módulos de la Figura 4 (`catalogo`, `ventas`, y los candidatos `inventario`/`compras`/`seguridad`) son el mismo nivel que la **Vista C3 (Componentes)** de `ads-producto.md` U1 — de hecho son los mismos boxes (`CAT`, `VEN`) que ya aparecen ahí. No son C2 (Contenedores): BomERP es un monolito modular con un solo backend, así que los módulos no son contenedores separados, son componentes dentro de uno solo. La Figura 3 (el agregado `Venta`–`DetalleVenta`) va un nivel más adentro que C3, hacia el nivel de Código/clases — es zoom hacia el interior del componente `ventas`, y se formaliza completo recién en S7. En un ERP real que creciera hasta necesitar microservicios, el bounded context mejor delimitado (no un corte arbitrario de código) es la costura natural para extraerlo como su propio contenedor C2 — la industria decide así qué servicio separar primero.

### 3.7 Trazar ADS con BD2 y LP2

**Producto del paso:** matriz de integración del modelo de dominio.

**Tabla 8. Matriz de integración ADS-BD2-LP2**

| Decisión de dominio (ADS) | Evidencia esperada en BD2 | Evidencia esperada en LP2 |
|---|---|---|
| Agregado `Venta`–`DetalleVenta` | Transacción PL/SQL o restricción que impide guardar detalle sin cabecera | `@Transactional` en el servicio de registro de venta — ya construido en la S4 de LP2 |
| Regla: stock nunca negativo | `CHECK` o trigger sobre `Producto.stock` | Validación de stock antes de persistir el detalle |
| Objeto de valor `Dinero` | Columna con precisión y escala fija para montos | Clase `Dinero` o equivalente, sin `BigDecimal` suelto en la entidad |
| Módulos `catalogo`/`ventas` | Esquemas Oracle con propietario funcional propio | Paquetes de módulo verificados con Spring Modulith |

Misma semana, ritmo distinto: ADS cierra Unidad I una sesión antes que BD2 y LP2 (S5 frente a S6), así que mientras tú arrancas Unidad II descubriendo el dominio, tus compañeros de equipo están cerrando y sustentando el producto de Unidad I de esos dos cursos: [BD2 - S6 Evaluación de la Unidad I](../../bd2/sesiones/S06_Evaluacion_Unidad_1.md) y [LP2 - S6 Evaluación de la Unidad I](../../lp2/sesiones/S06_Evaluacion_Unidad_1.md). Esta matriz no describe trabajo futuro: por la continuidad de Ciclo 3, BD2 y LP2 ya construyeron buena parte de `Venta`–`DetalleVenta` en su propia Unidad I (esquemas y operación cabecera-detalle) — esta sesión formaliza en términos de dominio (agregado, objeto de valor) el límite que esos dos cursos ya empezaron a construir de forma pragmática, sin nombrarlo así todavía.

**Evidencia de aprendizaje:**

- Entidades y reglas de negocio, módulos delimitados y casos de uso relevantes de BomERP.
- Objetos de valor candidatos y su justificación.
- Glosario de lenguaje ubicuo y agregado delimitado, con su esquema inicial.
- Matriz de integración con BD2 y LP2.

## 4. Crea: actividad autónoma

Tiempo: 2h fuera del aula.

### 4.1 Actividad

Descubrimiento y modelado autónomo del dominio del proyecto propio del equipo, documentado en evidencia individual.

Completa y evidencia estas tareas:

1. Identificar al menos cuatro entidades con su regla de negocio asociada.
2. Delimitar al menos seis módulos candidatos de todo el sistema (como los seis de BomERP), cada uno con su razón de cambio — de esos, elegir los dos o tres que sí se modelan en profundidad esta unidad (el equivalente propio de `catalogo`/`ventas`/`clientes`) y justificar por qué los demás quedan como candidatos futuros.
3. Reconocer al menos tres casos de uso relevantes.
4. Identificar al menos un objeto de valor candidato.
5. Elaborar el glosario de lenguaje ubicuo y delimitar el agregado del proceso transaccional propio.
6. Bosquejar el esquema inicial del modelo de dominio.

### 4.2 Propósito

Que cada estudiante demuestre, de forma individual y fuera del aula, que puede reproducir el patrón de descubrimiento de dominio construido en clase sin el acompañamiento del docente.

Cada estudiante consolida el modelo de dominio inicial del proyecto.

### 4.3 Indicaciones

Entrega un PDF con el siguiente nombre:

```text
S06_ADS_Equipo##_ApellidoNombre.pdf
```

Cada captura de pantalla del informe debe mostrar, sin recortar, el reloj del sistema (fecha y hora) y tu usuario o foto de perfil (Windows, VS Code o navegador) visibles en pantalla — es lo que permite verificar que la evidencia es tuya y que corresponde al momento real de tu trabajo.

#### 4.3.1 Estructura del informe

**Datos del estudiante**

- Nombre:
- Equipo:
- Sesión: S06 - Descubrimiento y Modelado del Dominio
- Rol o aporte realizado:
- Link de GitHub:

**Evidencia técnica**

Incluye capturas o salidas con una breve explicación debajo de cada una, organizadas en los mismos 4 bloques de la rúbrica (4.6) — así queda claro qué evidencia corresponde a cada criterio evaluado:

1. *Entidades, reglas y módulos*
    - Tabla de entidades y reglas de negocio.
    - Tabla de módulos funcionales.
2. *Casos de uso y objetos de valor*
    - Tabla de casos de uso relevantes.
    - Tabla de objetos de valor candidatos.
3. *Diseño estratégico DDD*
    - Glosario de lenguaje ubicuo.
    - Agregado delimitado (figura del agregado).
4. *Esquema del modelo de dominio*
    - Esquema inicial del modelo de dominio.

**Error o hallazgo**

Describe al menos un error o hallazgo: qué entidad confundiste inicialmente con un objeto de valor (o viceversa), qué regla de negocio se te había pasado, qué ajuste hiciste y qué aprendiste sobre modelado de dominio.

**Reflexión técnica breve**

Responde en 5 a 8 líneas:

```text
¿Por qué el agregado se decide a partir de una regla de negocio real
y no a partir de qué tan cómodo es agrupar clases en el código?
```

### 4.4 Criterios mínimos de aceptación

La evidencia individual se considera completa si:

- El archivo respeta el nombre solicitado.
- Identifica entidades con su regla de negocio asociada.
- Delimita al menos seis módulos candidatos de todo el sistema, cada uno con su razón de cambio, distinguiendo cuáles se modelan en profundidad esta unidad y cuáles quedan como candidatos futuros.
- Reconoce casos de uso relevantes, no solo operaciones CRUD sueltas.
- Identifica al menos un objeto de valor justificado.
- Presenta el glosario de lenguaje ubicuo y el agregado delimitado.
- Cada captura de la evidencia técnica muestra el reloj del sistema y el usuario/perfil visible, sin recortar.
- Las fechas y horas de las capturas son coherentes con el historial de commits de su repositorio en GitHub.
- Incluye un error o hallazgo técnico diagnosticado.
- Incluye la reflexión técnica breve solicitada.

### 4.5 Preguntas de defensa

1. ¿Qué regla de negocio protege el agregado que delimitaste?
2. ¿Por qué el objeto de valor que identificaste no necesita identidad propia?
3. ¿Qué pasaría si alguien modificara una entidad interna del agregado sin pasar por su raíz?
4. ¿Por qué separaste tus módulos funcionales de esa forma y no de otra?

### 4.6 Rúbrica de evaluación

**Tabla 9. Rúbrica de evaluación**

| Criterio | Peso (%) | A (20 pts) | B (15 pts) | C (10 pts) | D (5 pts) | Nivel obtenido |
|---|---:|---|---|---|---|---:|
| 1. Entidades, reglas y módulos* | 25 | Identifica entidades con reglas de negocio claras y delimita al menos seis módulos candidatos de todo el sistema, cada uno con su razón de cambio propia. | Identifica entidades y la mayoría de los módulos candidatos, con alguna razón de cambio genérica. | Entidades o módulos incompletos, o módulos delimitados sin razón de cambio distinta entre ellos. | No identifica entidades ni módulos verificables. | |
| 2. Casos de uso y objetos de valor* | 25 | Reconoce casos de uso relevantes y objetos de valor bien justificados. | Reconoce casos de uso y objetos de valor, con justificación parcial. | Lista casos de uso u objetos de valor sin justificación suficiente. | No reconoce casos de uso ni objetos de valor. | |
| 3. Diseño estratégico DDD* | 25 | Glosario de lenguaje ubicuo claro y agregado delimitado sobre una regla de negocio real. | Glosario y agregado presentes, con justificación general. | Glosario o agregado débil o genérico. | No presenta glosario ni agregado. | |
| 4. Esquema del modelo de dominio* | 25 | Esquema claro, coherente con entidades, módulos y agregado ya definidos. | Esquema comprensible, con inconsistencias menores. | Esquema incompleto o poco conectado con el resto del informe. | No presenta esquema. | |

\* Agregado manual.

Nota final = suma de (`Peso` / 100 × `Puntos del nivel obtenido`) = ____ / 20.

Para usar la rúbrica con IA, solicita:

```text
Evalúa el PDF usando la rúbrica de la sesión.
Para cada criterio selecciona el nivel obtenido usando la escala A=20, B=15, C=10, D=5 puntos.
Justifica brevemente cada nivel asignado.
Verifica que cada captura muestre reloj del sistema y usuario/perfil visible, y que las fechas sean coherentes con el historial de commits de GitHub. Si falta esta evidencia o hay inconsistencias, indícalo explícitamente antes de calificar.
Calcula la nota final con la fórmula: suma de (Peso/100 × Puntos del nivel obtenido), directamente sobre 20.
Indica 2 fortalezas y 2 recomendaciones.
```

## 5. Cierre

Tiempo: 5 min.

**Resumen breve:** hoy BomERP pasó de tener arquitectura declarada a tener un dominio descubierto — entidades con sus reglas, módulos delimitados, casos de uso relevantes, objetos de valor y un agregado que protege la consistencia transaccional, con su propio lenguaje ubicuo.

**Dinámica participativa:** en una ronda rápida (o con una herramienta digital tipo formulario o encuesta en vivo), cada estudiante comparte en una frase qué regla de negocio protege el agregado que delimitó.

**Metacognición:** cada estudiante responde en voz alta o por escrito: ¿qué te costó más distinguir hoy, una entidad de un objeto de valor o el límite del agregado, y cómo lo resolviste?

**Proyección:** el modelo de dominio de hoy se refina en S7 con el diagrama de clases completo (atributos, operaciones, relaciones y multiplicidades). El agregado delimitado hoy no es una construcción futura: es el mismo límite que LP2 ya protegió con `@Transactional` desde su propia Unidad I — esta sesión lo nombra en términos de dominio, no lo estrena.

## Bibliografía

1. Evans, E. (2003). *Domain-Driven Design: Tackling Complexity in the Heart of Software*. Addison-Wesley.
2. Vernon, V. (2013). *Implementing Domain-Driven Design*. Addison-Wesley.
3. Seidl, M., Scholz, M., Huemer, C., & Kappel, G. (2015). *UML@Classroom: An Introduction to Object-Oriented Modeling*. Springer.
