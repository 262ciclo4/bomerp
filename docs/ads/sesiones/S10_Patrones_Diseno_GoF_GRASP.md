# S10 - Patrones de Diseño GoF y GRASP

## 1. Introducción

Tiempo: 20 min.

### 1.1 Presentación de la sesión

S9 modeló el **comportamiento** del módulo `ventas` sin cuestionar su estructura: los diagramas de secuencia, actividades y comunicación reutilizaron tal cual las clases que S8 ya había organizado por capas. Esta sesión hace la pregunta que S8 y S9 dejaron pendiente a propósito: **¿por qué** esas clases están organizadas así, y no de otra forma? El catálogo GoF (*Gang of Four*) describe 23 patrones de diseño de propósito general; GRASP (*General Responsibility Assignment Software Patterns*) describe 9. Ningún sistema real usa los 32 a la vez, y memorizarlos de memoria no sirve de nada si no se sabe reconocer **cuándo** cada uno resuelve un problema real. Esta sesión no intenta cubrir el catálogo completo — se concentra en los patrones que más aparecen en sistemas empresariales reales (ERP, *Enterprise Resource Planning*, y cualquier backend con reglas de negocio, no solo BomERP), con la profundidad suficiente para reconocerlos y aplicarlos en **cualquier** proyecto futuro, no solo para etiquetar las clases que `ventas` ya tiene.

Esta sesión también confronta una tensión real que BomERP tiene **hoy**, no en una hipótesis: S7 diseñó `Venta.calcularTotal()` y `Producto.descontarStock(cantidad)` como operaciones del dominio, y el código real de LP2 (Lenguaje de Programación II) las implementó como lógica de servicio, dejando las entidades `Venta` y `Producto` sin un solo método propio. El porqué de que esto importe, con la fuente que le puso nombre al problema, se desarrolla en 1.6.

### 1.2 Índice

1. Patrones creacionales GoF: Factory Method y Builder.
2. Patrones estructurales GoF: Facade y Proxy.
3. Patrones de comportamiento GoF: Strategy, State, Chain of Responsibility y Observer.
4. GRASP — asignación de responsabilidades: Information Expert, Creator, Controller.
5. GRASP — acoplamiento y cohesión: Low Coupling, High Cohesion, Polymorphism.
6. GRASP — patrones de protección: Pure Fabrication, Indirection, Protected Variations.
7. Dependency Injection.

### 1.3 Propósito de aprendizaje

Al concluir la clase, estarás en condiciones de:

- **Reconocer y aplicar**, en cualquier sistema —no solo BomERP—, los patrones GoF y GRASP más frecuentes en software empresarial, **decidir con criterio** cuándo un patrón resuelve un problema real y cuándo es sobreingeniería, y **diagnosticar** con Information Expert si un dominio es anémico o rico.

### 1.4 Producto de sesión

Catálogo de patrones aplicado a `ventas`, con cada patrón explicado primero en general y después aplicado al caso: Factory Method resolviendo el hueco de Creator en `Venta.agregarDetalle(...)`, Proxy reconocido en el código real (carga perezosa de JPA, *Java Persistence API*, y el *proxy* transaccional de Spring), decisión justificada de si `Venta` necesita el patrón State completo o un `enum` simple basta, cadena de autorización de ventas por monto diseñada con Chain of Responsibility, el evento de dominio identificado como Observer (previsto, formalizado en S11), diagnóstico de Information Expert sobre el modelo anémico de `Venta`/`Producto` con su refactor, diseño del polimorfismo previsto de `Cliente`, y verificación de Dependency Injection, Indirection y Protected Variations ya aplicados en el código real.

### 1.5 Metodología

**Tabla 1. Metodología de la sesión**

| Actividades a Realizar en el Periodo | Orientaciones generales (Orientaciones Metodológicas) | Material de estudio recomendado |
|---|---|---|
| Revisión previa individual | Releer la Figura 6 de S8 (diagrama de código por capas), el diagrama de clases del dominio de S7 (`calcularTotal()`, `descontarStock()`) y la jerarquía `Cliente`. Trabajo individual, antes de clase. | S7 (2.2, Figura de clases del dominio), S8 (Figura 6, Tablas 12-15). |
| Clase presencial | Reconocimiento guiado de los patrones GoF más usados en sistemas empresariales, catalogación de GRASP, diagnóstico con Information Expert y diseño del refactor, la cadena de autorización y el polimorfismo. Trabajo individual, siguiendo al docente paso a paso; consulta inmediata ante dudas sobre cuándo un patrón aplica de verdad. | Pasos 3.1 a 3.7 de esta guía. |
| Evaluación formativa | Revisión en clase del catálogo completo de patrones y del diagnóstico de Information Expert, con su justificación. La evidencia se completa y sustenta de forma individual, fuera del aula, según los criterios mínimos de la sección 4.4. | Indicaciones de entrega (4.3), rúbrica de evaluación (4.6). |

### 1.6 Motivación de la sesión

#### 1.6.1 Caso: el antipatrón que Martin Fowler le puso nombre, y que `ventas` tiene hoy mismo

En 2003, Martin Fowler publicó un ensayo corto que nombró un problema que llevaba años viendo en proyectos reales: el **Anemic Domain Model** (modelo de dominio anémico). Describe entidades que parecen objetos de dominio —tienen atributos, relaciones, hasta nombres del negocio— pero que no son más que "bolsas de getters y setters", porque toda la lógica de negocio vive afuera, en clases de servicio.

Fuente: Fowler, M. (2003). *AnemicDomainModel*. martinfowler.com. https://martinfowler.com/bliki/AnemicDomainModel.html

Su argumento central, textual: *"el problema de fondo con los modelos de dominio anémicos es que incurren en todos los costos de un modelo de dominio, sin producir ninguno de sus beneficios"* (traducción propia). Larman (2004) le da a este problema un nombre operativo: **Information Expert** (2.5) dice que la responsabilidad de una operación debe asignarse a la clase que tiene la información necesaria para cumplirla. `Venta` tiene su propia lista de `detalles` — es la experta en calcular su propio total; `Producto` tiene su propio `stock` — es el experto en decidir si puede descontarse. BomERP tiene este problema hoy, no como hipótesis: `Venta.java` y `Producto.java`, en el código real de LP2, son exactamente lo que Fowler describe — `@Getter @Setter`, sin un solo método propio —, aunque S7 ya había diseñado `calcularTotal()` y `descontarStock(cantidad)` como operaciones reales.

**Preguntas de análisis**

**Activación de conocimientos previos**

1. Antes de leer el argumento de Fowler, ¿qué significa que una clase "incurra en los costos de un modelo de dominio sin sus beneficios"?

**Comprensión de Information Expert**

1. Según el caso, ¿por qué `Venta` —y no `VentaServiceImpl`— es la "experta en información" para calcular su propio total?
2. En tu propio proyecto, ¿tus entidades tienen algún método propio además de getters/setters, o toda la lógica vive en los servicios?

### 1.7 Ubicación en el curso

- Producto del curso: Diseño Técnico Profesional Documentado.
- Producto de unidad: Catálogo UML con patrones de diseño e integración aplicados.
- Avance del producto en esta sesión: catálogo de los patrones GoF y GRASP más usados en sistemas empresariales, aplicados a `ventas`, con el diagnóstico de Information Expert y el diseño del polimorfismo previsto de `Cliente`.

**Figura 1. Roadmap del producto de la unidad**

```mermaid
flowchart TB
    S6["`**S6:** Descubrimiento y modelado del dominio`"]
    S7["`**S7:** Diseño de clases del dominio`"]
    S8["`**S8:** Diseño de clases avanzado y transformación OR`"]
    S9["`**S9:** Diagramas dinámicos UML`"]
    S10["`**S10:** Patrones de diseño GoF y GRASP`"]
    S11["`**S11:** Integración y sistemas empresariales`"]
    S12["`**S12:** Producto U2`"]

    S6 --> S7 --> S8 --> S9 --> S10 --> S11 --> S12

    classDef today fill:#ffe08a,stroke:#9a6b00,stroke-width:2px,color:#111;
    class S10 today;
```

## 2. Explica

Tiempo: 55 min.

### 2.1 Arquitectura de la sesión

**Figura 2. De clases con nombre a clases con patrón**

```mermaid
flowchart TB
    A[Figura 6 de S8:<br/>clases por capas] --> B[GoF creacionales:<br/>Factory Method, Builder]
    A --> C[GoF estructurales:<br/>Facade, Proxy]
    A --> D[GoF de comportamiento:<br/>Strategy, State]
    A --> E[GRASP: asignacion<br/>de responsabilidades]
    E --> F{"Venta/Producto:<br/>Information Expert aplicado?"}
    F -- No --> G[Disenar el refactor]
    A --> H[GRASP: acoplamiento,<br/>cohesion, polimorfismo]
    A --> I[GRASP: patrones<br/>de proteccion]
    I --> J[Verificar Dependency<br/>Injection]
    B --> K[Catalogo completo<br/>de patrones]
    C --> K
    D --> K
    G --> K
    H --> K
    J --> K
```

Lectura del diagrama: esta sesión no dibuja clases nuevas — reconoce, en las que S8 ya construyó, los patrones que más aparecen en cualquier sistema empresarial, y decide dónde falta aplicar uno. Cada apartado siguiente desarrolla uno de los bloques del Índice (1.2), abriendo siempre con la definición general del patrón —aplicable a cualquier sistema— antes de llegar al caso concreto de `ventas`.

### 2.2 Patrones creacionales GoF: Factory Method y Builder

Los patrones **creacionales** resuelven cómo se construye un objeto, sin acoplar al código cliente a una clase concreta ni a los detalles de esa construcción (Gamma et al., 1994). De los cinco patrones creacionales del catálogo original, dos aparecen constantemente en sistemas empresariales:

**Factory Method** define un método cuya única responsabilidad es construir un objeto completo y válido, ocultando los detalles de esa construcción al código que lo llama — en cualquier sistema, úsalo cuando construir un objeto requiere combinar datos de más de una fuente, o cuando la construcción en sí misma protege un invariante (Gamma et al., 1994).

**Builder** separa la construcción de un objeto complejo —con muchos campos opcionales o un orden de inicialización que importa— de su representación final, permitiendo construirlo paso a paso (Gamma et al., 1994). Úsalo cuando un constructor tendría demasiados parámetros, o cuando no todos los campos son obligatorios en todos los casos.

**Tabla 2. Factory Method y Builder en `ventas`**

| Patrón | Dónde en `ventas` | Por qué |
|---|---|---|
| Builder | `VentaResponse`/`DetalleVentaResponse` (S8, convención de LP2) | `@Builder` de Lombok genera un constructor paso a paso, en vez de uno con todos los campos de una vez — varios de esos campos (`detalles`, por ejemplo) no siempre están disponibles en el mismo punto del código. |
| Factory Method | **Hueco real, diseñado en 3.1** | Hoy, `DetalleVenta` lo construye `VentaMapper`, no `Venta` — 3.1 diseña un método de fábrica dentro de `Venta` que resuelve esto. |

### 2.3 Patrones estructurales GoF: Facade y Proxy

Los patrones **estructurales** resuelven cómo se componen clases y objetos para formar estructuras más grandes, sin que una dependa de los detalles internos de otra (Gamma et al., 1994).

**Facade** ofrece una interfaz simplificada a un subsistema complejo, para que quien lo usa no necesite conocer sus clases internas (Gamma et al., 1994). Es, de los siete patrones estructurales, el que más aparece en cualquier backend organizado por capas: `ProductoService` es una *Facade* real — simplifica, para `ventas`, todo lo que `catalogo` hace por dentro (`ProductoRepository`, `CategoriaRepository`, validaciones).

**Proxy** provee un sustituto o intermediario de otro objeto, para controlar el acceso a él —sin que quien lo usa note la diferencia— por razones de costo (cargarlo es caro), de seguridad (hay que verificar permisos) o de coordinación (hay que envolver la llamada con algo más) (Gamma et al., 1994). Es uno de los patrones GoF más usados **sin que se note**, porque casi siempre lo aplica el framework, no el programador.

**Tabla 3. Dos *Proxy* reales en el código de LP2, sin que nadie los haya escrito a mano**

| Dónde | Qué intercepta | Tipo de Proxy |
|---|---|---|
| `Producto.categoria` (`@ManyToOne(fetch = FetchType.LAZY)`, S3) | El acceso a `Categoria`: Hibernate entrega un objeto sustituto que solo consulta la base de datos la primera vez que se usa de verdad. | *Virtual Proxy* (carga perezosa) |
| `VentaServiceImpl` con `@Transactional` (S8, 2.3) | Cada llamada al método real: Spring envuelve la clase en un *proxy* generado en tiempo de ejecución que abre la transacción antes de llamar al método real, y la confirma o revierte después. | *Proxy* de framework (intercepción transaccional) |

Ninguno de los dos *Proxy* de la Tabla 3 aparece como una clase escrita a mano en el código — eso es, precisamente, lo que distingue a Proxy de los demás patrones estructurales: su punto es ser invisible para quien usa el objeto real.

### 2.4 Patrones de comportamiento GoF: Strategy, State, Chain of Responsibility y Observer

Los patrones **de comportamiento** resuelven cómo se distribuye la responsabilidad de un algoritmo o un flujo entre objetos que colaboran (Gamma et al., 1994). Es la familia GoF más grande (once patrones) y la que más se nota en sistemas con reglas de negocio reales — cuatro se repiten en casi cualquier ERP:

**Strategy** encapsula una familia de algoritmos intercambiables detrás de una misma interfaz, para que el código cliente pueda cambiar de algoritmo sin cambiar su propia estructura (Gamma et al., 1994). El parámetro `Sort` que `VentaServiceImpl.buscar` arma a partir de `ordenarPor`/`direccion` (S8) encapsula una estrategia de ordenamiento intercambiable, sin que `VentaRepository` sepa cuál.

**State** permite que un objeto cambie su comportamiento cuando cambia su estado interno, de forma que parezca que el objeto cambió de clase — cada estado se modela como su propia clase, con su propia implementación de las operaciones que varían (Gamma et al., 1994). No todo atributo de estado necesita este patrón: un `enum` con una validación simple (`if estado != REGISTRADA`) resuelve el mismo problema cuando hay pocos estados y poco comportamiento que varíe. El patrón completo se justifica cuando los estados son varios **y** el comportamiento difiere de forma sustancial entre ellos, no solo en una condición.

**Tabla 4. Cuándo State (clases) y cuándo un `enum` con validación basta**

| Señal | ¿Justifica el patrón State completo? |
|---|---|
| Dos o tres estados, con una sola regla de transición cada uno | No — un `enum` + una validación por método alcanza. |
| Cinco o más estados, cada uno habilitando o prohibiendo operaciones distintas | Sí — una clase por estado evita que un único método acumule un `switch` gigante. |
| Las transiciones válidas cambian seguido (nuevas reglas de negocio agregan estados con frecuencia) | Sí — agregar una clase de estado nueva no obliga a tocar las demás. |

3.3 aplica esta tabla al `EstadoVenta` real de BomERP, que hoy tiene un solo valor (`REGISTRADA`) y uno previsto (`ANULADA`, S9) — y decide, con este criterio, si ya justifica el patrón completo o si el `enum` con validación (como el que S9 ya diseñó) sigue siendo la opción correcta.

**Chain of Responsibility** evita que un objeto que envía una petición conozca de antemano cuál objeto la va a manejar: la petición pasa de un manejador a otro, en una cadena, hasta que uno la resuelve (Gamma et al., 1994). Es, de los patrones de comportamiento, el más reconocible en cualquier ERP: **cualquier flujo de aprobación por niveles** (una compra, un descuento, un reembolso) es, estructuralmente, este patrón. `ventas` no lo tiene implementado todavía, pero es un diseño natural y previsto para una regla de negocio real: una venta de monto alto no debería aprobarse automáticamente.

**Figura 3. Chain of Responsibility: autorización de una venta por monto (previsto)**

```mermaid
flowchart LR
    V[Venta nueva] --> A{"Autorizador<br/>Vendedor"}
    A -- "total <= S/500" --> OK1([Autorizada])
    A -- "total > S/500" --> B{"Autorizador<br/>Supervisor"}
    B -- "total <= S/5000" --> OK2([Autorizada])
    B -- "total > S/5000" --> C{"Autorizador<br/>Admin"}
    C --> OK3([Autorizada])
```

```text
// AutorizadorVenta.java — interfaz de la cadena, pseudocodigo
interface AutorizadorVenta:
    establecerSiguiente(AutorizadorVenta siguiente)
    autorizar(Venta venta)

// AutorizadorVendedor.java — primer eslabon
autorizar(venta):
    si venta.total <= 500:
        devolver AUTORIZADA
    sino si siguiente != null:
        devolver siguiente.autorizar(venta)
    sino:
        devolver RECHAZADA
```

Cada autorizador solo sabe dos cosas: su propia regla, y a quién pasarle la petición si no le corresponde a él. `AutorizadorVendedor` no conoce a `AutorizadorAdmin` directamente —ni cuántos eslabones hay en total—; si BomERP agrega un cuarto nivel de aprobación mañana, ningún autorizador existente cambia una sola línea.

**Error frecuente**: implementar esto como un único método con `if total <= 500 ... else if total <= 5000 ... else ...`. Funciona igual de bien con pocos niveles, pero cada nivel nuevo obliga a tocar el mismo método gigante — exactamente lo que Chain of Responsibility evita, separando cada regla en su propio eslabón.

**Observer** define una dependencia de uno-a-muchos entre objetos, de forma que cuando uno cambia de estado, todos sus dependientes son notificados automáticamente, sin que el primero los conozca por nombre (Gamma et al., 1994). La publicación de eventos de dominio es Observer aplicado a nivel de módulos: `ventas` (el *sujeto*) no conoce a sus suscriptores (los *observadores*), y puede tener cero, uno o varios al mismo tiempo. Hoy, en esta sesión, es un concepto; S11 lo formaliza con `VentaRegistrada` y `@ApplicationModuleListener` de Spring Modulith — el mismo patrón, con nombre e implementación concretos.

### 2.5 GRASP — asignación de responsabilidades: Information Expert, Creator, Controller

Tres de los nueve patrones GRASP (Larman, 2004) responden la misma pregunta de fondo —¿a qué clase le corresponde esta responsabilidad?— desde tres ángulos distintos.

**Information Expert**: asigna una responsabilidad a la clase que tiene la información necesaria para cumplirla. Es el patrón que el caso de 1.6 dejó planteado: `Venta` tiene sus propios `detalles`, así que es la experta en calcular su propio `total` — no `VentaServiceImpl`, que solo coordina. 3.5 aplica este criterio a `Venta` y `Producto`.

**Creator**: asigna la responsabilidad de crear una instancia de una clase A a la clase B, si B agrega o contiene a A, registra instancias de A, las usa íntimamente, o tiene los datos de inicialización que A necesita (Larman, 2004). `Venta` **contiene** (compone) a `DetalleVenta` — por Creator, `Venta` debería ser quien cree sus propios objetos `DetalleVenta`. Hoy no lo es (`VentaMapper.toDetalle(...)` los crea); 3.1 resuelve este hueco con un Factory Method dentro de `Venta`, matando dos pájaros —GRASP Creator y GoF Factory Method— con el mismo refactor.

**Controller**: ya presentado en S8 (2.3) y verificado en S9 — asigna la responsabilidad de recibir un evento del sistema a una clase que no es la interfaz de usuario ni el dominio. `VentaController` lo aplica: recibe la petición HTTP (*HyperText Transfer Protocol*), delega en `VentaService`, no decide ninguna regla de negocio.

### 2.6 GRASP — acoplamiento y cohesión: Low Coupling, High Cohesion, Polymorphism

**Low Coupling**: asigna responsabilidades de forma que la dependencia entre clases se mantenga baja, para que un cambio en una no obligue a cambiar muchas otras (Larman, 2004). El DTO (*Data Transfer Object*, S8) es la aplicación más directa en `ventas`: `VentaController` depende de `VentaRequest`/`VentaResponse`, nunca de la entidad `Venta` — si `Venta` cambia sus columnas internas, el contrato HTTP no tiene por qué cambiar.

**High Cohesion**: asigna responsabilidades de forma que las de una clase estén fuertemente relacionadas y enfocadas (Larman, 2004). `VentaMapper` solo traduce; `VentaRepository` solo persiste y consulta — ninguna de las dos mezcla responsabilidades que no le correspondan.

**Polymorphism**: cuando el comportamiento varía según el tipo de un objeto, esa variación se asigna con operaciones polimórficas definidas en cada tipo, en vez de condicionales que pregunten de qué tipo es cada objeto (Larman, 2004). BomERP todavía no implementa `Cliente`, pero S7 ya diseñó la jerarquía (`Cliente` abstracta, `ClientePersonaNatural`, `ClienteEmpresa`) — el candidato natural para aplicar Polymorphism hoy, en diseño.

**Figura 4. Polymorphism aplicado a la jerarquía prevista de `Cliente`**

```mermaid
classDiagram
    class Cliente {
        <<abstracta, prevista>>
        #Long id
        #String nombreORazonSocial
        +obtenerIdentificadorFiscal()* String
    }
    class ClientePersonaNatural {
        -String dni
        +obtenerIdentificadorFiscal() String
    }
    class ClienteEmpresa {
        -String ruc
        +obtenerIdentificadorFiscal() String
    }
    Cliente <|-- ClientePersonaNatural
    Cliente <|-- ClienteEmpresa
```

```text
// Sin Polymorphism (lo que GRASP pide evitar)
si cliente instanceof ClientePersonaNatural:
    identificador = cliente.getDni()
sino si cliente instanceof ClienteEmpresa:
    identificador = cliente.getRuc()

// Con Polymorphism (lo que la Figura 4 disena)
identificador = cliente.obtenerIdentificadorFiscal()
```

**Polymorphism no es lo mismo que una interfaz con una sola implementación.** En UML, la línea de `Cliente <|-- ClientePersonaNatural` (generalización, **línea sólida**) no es la única forma de dibujar polimorfismo — una interfaz implementada por una clase (`VentaService <|.. VentaServiceImpl`, realización, **línea punteada**) también lo es, como mecanismo de lenguaje. La diferencia que importa para GRASP no es la notación, es si **hay variación real que resolver**:

**Tabla 5. Polymorphism frente a Indirection/Protected Variations: la misma notación `implements`/`extends`, dos patrones distintos**

| | `Cliente` → `ClientePersonaNatural`/`ClienteEmpresa` | `VentaService` → `VentaServiceImpl` |
|---|---|---|
| ¿Cuántas implementaciones hay? | Dos, con comportamiento genuinamente distinto (DNI frente a RUC). | Una sola, hoy. |
| ¿Hay variación que el código cliente deba ignorar? | Sí — `obtenerIdentificadorFiscal()` resuelve esa variación en tiempo de ejecución. | No hay nada que variar todavía; la interfaz protege un punto de cambio *futuro*, no uno que ya exista. |
| Patrón GRASP correcto | **Polymorphism** | **Indirection** / **Protected Variations** (2.7) |

Una interfaz con una sola implementación no es polimorfismo aplicado — es protección contra un cambio que todavía no ocurrió.

### 2.7 GRASP — patrones de protección: Pure Fabrication, Indirection, Protected Variations

**Pure Fabrication**: una clase inventada, que no representa ningún concepto del dominio del negocio, creada exclusivamente para lograr bajo acoplamiento y alta cohesión (Larman, 2004). `VentaMapper` y `VentaRepository` son Pure Fabrication — ningún experto del negocio describe "un mapeador" o "un repositorio" como parte de cómo funciona una venta.

**Indirection**: asigna la responsabilidad a un objeto intermediario, para mediar entre otros componentes o servicios y evitar que se acoplen directamente (Larman, 2004). La interfaz `ProductoService` es ese intermediario: `VentaServiceImpl` nunca habla con `ProductoRepository` ni con `ProductoServiceImpl` directamente.

**Protected Variations**: identifica puntos de variación probable y les pone alrededor una interfaz estable, para que el resto del sistema quede protegido de esos cambios (Larman, 2004). La anotación real `@NamedInterface("producto-service")` sobre el paquete `catalogo.producto.service` (Spring Modulith) es la forma concreta en que LP2 declara ese punto protegido en código.

**Tabla 6. La misma clase, dos patrones — por qué no es un error**

| Clase | Indirection (el mecanismo) | Protected Variations (el propósito) |
|---|---|---|
| `ProductoService` | Es el objeto intermediario entre `ventas` y la implementación real de `catalogo`. | Protege a `ventas` de que `ProductoServiceImpl` cambie su lógica interna. |

Indirection describe **cómo** se logra (un intermediario); Protected Variations describe **para qué** (proteger un punto de variación). La misma clase puede —y en este caso debe— cumplir los dos a la vez.

### 2.8 Dependency Injection

**Dependency Injection** (inyección de dependencias) es el patrón donde un objeto recibe sus colaboradores desde afuera —por constructor, en el caso de Spring con `@RequiredArgsConstructor`— en vez de crearlos él mismo con `new` (Fowler, 2004). `VentaServiceImpl` ya lo aplica: recibe `VentaRepository`, `ProductoService` y `VentaMapper` como parámetros de su constructor, generado por Lombok.

**Error frecuente**: confundir "usar Spring" con "aplicar Dependency Injection". El contenedor de Spring es el *mecanismo* que resuelve las dependencias automáticamente; el *patrón* es la decisión de diseño de que una clase nunca construya sus propios colaboradores.

## 3. Aplica: actividad práctica guiada

Tiempo: 115 min.

**Actividad:** reconocimiento y aplicación de los patrones GoF y GRASP más usados en sistemas empresariales sobre el módulo `ventas`, resolviendo dos huecos reales (Creator/Factory Method, Information Expert) y diseñando tres decisiones previstas (State, Chain of Responsibility, Polymorphism).

**Propósito de la actividad:** salir de la sesión sabiendo reconocer estos patrones en cualquier sistema, no solo en `ventas` — por eso cada paso empieza por decidir **si** el patrón aplica, antes de aplicarlo.

**Orientaciones metodológicas:** en el laboratorio, el docente aplica cada patrón a `ventas` paso a paso frente a la clase; los estudiantes repiten cada paso sobre su propio módulo de S8 (ver sección 4).

**Actividades para realizar:**

- **3.1** Resolver el hueco de Creator con un Factory Method.
- **3.2** Reconocer Proxy en el código real.
- **3.3** Decidir si `Venta` necesita el patrón State completo.
- **3.4** Diseñar la cadena de autorización de ventas (Chain of Responsibility).
- **3.5** Diagnosticar y refactorizar con Information Expert.
- **3.6** Diseñar el polimorfismo de `Cliente`.
- **3.7** Catalogar acoplamiento/cohesión y verificar los patrones de protección y Dependency Injection.

### 3.1 Resolver el hueco de Creator con un Factory Method

**Producto del paso:** el método de fábrica dentro de `Venta`, que la convierte en la creadora de sus propios `DetalleVenta` (2.2, 2.5).

```text
// Venta.java — pseudocodigo, Factory Method que resuelve el hueco de Creator
agregarDetalle(productoId, cantidad, nombreProducto, precioUnitario):
    detalle = nuevo DetalleVenta(
        venta: este,
        productoId: productoId,
        cantidad: cantidad,
        nombreProducto: nombreProducto,
        precioUnitario: precioUnitario,
        subtotal: precioUnitario * cantidad
    )
    detalles.agregar(detalle)
    devolver detalle
```

`VentaServiceImpl.crear` deja de pedirle a `VentaMapper` que construya el `DetalleVenta` — pide los datos del producto (a `ProductoService`, como ya hace hoy) y se los pasa a `venta.agregarDetalle(...)`, que es ahora quien construye y agrega el objeto. `VentaMapper` conserva su trabajo de **traducir** `Venta` a `VentaResponse` (2.3, Adapter) — construir y traducir son responsabilidades distintas, y este refactor las separa en la clase que corresponde a cada una.

### 3.2 Reconocer Proxy en el código real

**Producto del paso:** evidencia de los dos *Proxy* de la Tabla 3 (2.3), verificados contra el código y el comportamiento real.

```java
// Producto.java — codigo real, S3
@ManyToOne(fetch = FetchType.LAZY)
@JoinColumn(name = "ID_CATEGORIA", nullable = false)
private Categoria categoria;
```

```java
// VentaServiceImpl.java — codigo real, S8
@Transactional
public VentaResponse crear(VentaRequest request) { /* ... */ }
```

Ninguna de las dos líneas menciona la palabra "Proxy" — y esa es la evidencia de que el patrón está aplicado correctamente: Hibernate y Spring lo aplican automáticamente, a partir de una anotación, sin que el código de `ventas` tenga que escribir ninguna clase intermediaria a mano.

**Error frecuente**: serializar una entidad con una relación `LAZY` fuera de una transacción activa (por ejemplo, devolver la entidad directamente desde un controlador). El *proxy* de Hibernate lanza `LazyInitializationException` porque ya no hay transacción para resolver la carga real — es exactamente la razón por la que S8 (2.4) exige exponer siempre un DTO, nunca la entidad directamente.

### 3.3 Decidir si `Venta` necesita el patrón State completo

**Producto del paso:** una decisión explícita, aplicando la Tabla 4 (2.4) al `EstadoVenta` real y previsto de BomERP.

```java
public enum EstadoVenta {
    REGISTRADA
    // ANULADA, previsto desde S9
}
```

**Tabla 7. Tabla 4 aplicada a `EstadoVenta`**

| Señal | ¿Se cumple en `Venta` hoy? |
|---|---|
| Dos o tres estados, con una sola regla de transición cada uno | Sí — `REGISTRADA` y `ANULADA` (previsto), con una sola precondición cada una (S9, Tabla 8). |
| Cinco o más estados con comportamiento muy distinto | No. |
| Las transiciones cambian seguido | No hay evidencia de esto en el sílabo ni en el proyecto. |

**Decisión:** el `enum` con validación, ya diseñado en S9 (`Venta.anular()` comprobando `estado == REGISTRADA`), sigue siendo la opción correcta — el patrón State completo (una clase `EstadoRegistrada`, una clase `EstadoAnulada`, cada una con su propia implementación de `anular()`) sería sobreingeniería para dos estados con una sola regla. Si en el futuro BomERP agregara una devolución con varios pasos (`ANULADA_PARCIAL`, `EN_REVISION`, `DEVUELTA`, cada una habilitando operaciones distintas), ese sería el momento de migrar a State — no antes.

### 3.4 Diseñar la cadena de autorización de ventas (Chain of Responsibility)

**Producto del paso:** la cadena de autorizadores de la Figura 3 (2.4), con sus tres eslabones y el criterio de monto de cada uno.

```text
// AutorizadorVendedor.java, AutorizadorSupervisor.java, AutorizadorAdmin.java — pseudocodigo
interface AutorizadorVenta:
    establecerSiguiente(AutorizadorVenta siguiente)
    autorizar(Venta venta) ResultadoAutorizacion

class AutorizadorVendedor implements AutorizadorVenta:
    autorizar(venta):
        si venta.total <= 500: devolver AUTORIZADA
        sino: devolver siguiente.autorizar(venta)

class AutorizadorSupervisor implements AutorizadorVenta:
    autorizar(venta):
        si venta.total <= 5000: devolver AUTORIZADA
        sino: devolver siguiente.autorizar(venta)

class AutorizadorAdmin implements AutorizadorVenta:
    autorizar(venta):
        devolver AUTORIZADA  // ultimo eslabon: siempre resuelve

// Construccion de la cadena (una sola vez, al iniciar la aplicacion)
vendedor.establecerSiguiente(supervisor)
supervisor.establecerSiguiente(admin)
```

Cada clase implementa la misma interfaz `AutorizadorVenta` (GRASP Polymorphism, 2.6, aplicado aquí también: las tres variantes se tratan de forma uniforme desde fuera de la cadena) y GRASP Low Coupling (2.6): `VentaServiceImpl.crear` solo necesita conocer el primer eslabón (`vendedor`), nunca a los otros dos.

**Error frecuente**: olvidar el caso del último eslabón (`AutorizadorAdmin`). Si ningún eslabón resuelve la petición y la cadena termina sin un caso por defecto, la autorización queda indefinida — el último eslabón de toda cadena de responsabilidad debe resolver siempre, nunca volver a delegar.

### 3.5 Diagnosticar y refactorizar con Information Expert

**Producto del paso:** el estado real de `Venta` y `Producto` frente al diseño de S7, y el refactor que Information Expert exige.

**Tabla 8. Diagnóstico de Information Expert, operación por operación**

| Operación (diseñada en S7) | ¿Quién tiene la información? | ¿Dónde vive hoy? | ¿Information Expert aplicado? |
|---|---|---|---|
| `Venta.calcularTotal()` | `Venta`, a través de sus propios `detalles` | `VentaServiceImpl.crear` (brecha ya anotada en S8, Tabla 20) | **No** |
| `Producto.descontarStock(cantidad)` | `Producto`, a través de su propio `stock` | `ProductoServiceImpl.descontarStock` | **No** |

```text
// Venta.java — pseudocodigo del refactor
calcularTotal():
    total = suma de detalle.subtotal para cada detalle en detalles
    este.total = total
    devolver total
```

```text
// Producto.java — pseudocodigo del refactor
descontarStock(cantidad):
    si stock < cantidad:
        lanzar StockInsuficienteException(...)
    stock = stock - cantidad
```

`VentaServiceImpl.crear` deja de calcular el total a mano — llama a `venta.calcularTotal()` después de agregar los detalles (3.1). `ProductoServiceImpl.descontarStock` deja de comparar `stock < cantidad` él mismo — llama a `producto.descontarStock(cantidad)`.

**Error frecuente**: mover `calcularTotal()` a `Venta` pero dejar una copia del cálculo en el servicio "por si acaso". Si la regla vive en dos lugares, Information Expert no se aplicó — solo se duplicó el problema.

### 3.6 Diseñar el polimorfismo de `Cliente`

**Producto del paso:** el método polimórfico de `Cliente` (2.6, Figura 4), documentado como parte del catálogo.

Ya diseñado en 2.6 — este paso consiste en agregarlo al catálogo final (3.7) con su justificación: `Cliente.obtenerIdentificadorFiscal()` evita condicionales `instanceof` para decidir si leer `dni` o `ruc`, y el código cliente no cambia si BomERP agrega un tercer tipo de cliente.

### 3.7 Catalogar acoplamiento/cohesión y verificar los patrones de protección y Dependency Injection

**Producto del paso:** el catálogo completo de la sesión, y la verificación de que Pure Fabrication, Indirection, Protected Variations y Dependency Injection ya existen en el código real.

```java
// package-info.java de catalogo.producto.service — código real de LP2
@org.springframework.modulith.NamedInterface("producto-service")
package pe.edu.upeu.bomerp.catalogo.producto.service;
```

```java
// VentaServiceImpl.java — constructor generado por @RequiredArgsConstructor, código real
private final VentaRepository ventaRepository;
private final ProductoService productoService;
private final VentaMapper ventaMapper;
```

**Tabla 9. Catálogo completo de patrones de `ventas`**

| Clase o decisión | Patrón(es) | Catálogo |
|---|---|---|
| `Venta.agregarDetalle(...)` (3.1) | Factory Method; Creator | GoF; GRASP |
| `VentaResponse`/`DetalleVentaResponse` | Builder | GoF |
| `ProductoService` | Facade; Indirection; Protected Variations | GoF; GRASP |
| `Producto.categoria` (`LAZY`) | Proxy | GoF |
| `VentaServiceImpl` (`@Transactional`) | Proxy (de framework) | GoF |
| `Sort` en `VentaServiceImpl.buscar` | Strategy | GoF |
| `EstadoVenta` (decisión de 3.3) | `enum` + validación — State completo descartado por sobreingeniería | GoF (evaluado y descartado) |
| `AutorizadorVendedor`/`Supervisor`/`Admin` (3.4) | Chain of Responsibility; también Polymorphism (misma interfaz, tres implementaciones) | GoF; GRASP |
| `VentaRegistrada` (previsto, formalizado en S11) | Observer | GoF |
| `Venta.calcularTotal()`, `Producto.descontarStock()` (3.5) | Information Expert | GRASP |
| `VentaController` | Controller | GRASP |
| `VentaRequest`/`VentaResponse` (DTO) | Low Coupling | GRASP |
| `VentaMapper`, `VentaRepository` | High Cohesion; Pure Fabrication | GRASP |
| `Cliente.obtenerIdentificadorFiscal()` (3.6) | Polymorphism | GRASP |
| Constructor de `VentaServiceImpl` | Dependency Injection | Empresarial (Fowler, 2004) |

**Evidencia de aprendizaje:**

- Factory Method diseñado en `Venta`, resolviendo el hueco de Creator.
- Los dos *Proxy* reales de LP2 reconocidos y explicados (no solo nombrados).
- Decisión justificada sobre State completo frente a `enum` con validación.
- Cadena de autorización de ventas diseñada (Chain of Responsibility), con sus tres eslabones.
- Evento de dominio identificado como Observer, con su formalización prevista en S11.
- Diagnóstico de Information Expert sobre `Venta` y `Producto`, con el refactor diseñado.
- Polimorfismo de `Cliente` diseñado.
- Catálogo completo (Tabla 9), con los nueve patrones GRASP y los ocho patrones GoF seleccionados.

## 4. Crea: actividad autónoma

Tiempo: 2h fuera del aula.

### 4.1 Actividad

Reconocimiento y aplicación de patrones GoF y GRASP del módulo del proyecto propio del equipo ya diseñado en S8, documentado en evidencia individual.

Completa y evidencia estas tareas:

1. Identificar, en tu propio módulo, al menos un ejemplo real (o un hueco real, o un diseño previsto) de Factory Method/Creator, Facade, Proxy, Strategy, Chain of Responsibility y Observer, y decidir con la Tabla 4 si State completo o un `enum` simple es lo correcto para tu caso.
2. Catalogar, como la Tabla 9, los nueve patrones GRASP en tu propio módulo — si alguno no aparece todavía, documenta dónde debería aplicarse y por qué no está.
3. Diagnosticar con Information Expert si tus entidades son anémicas o ricas, y diseñar el refactor de al menos una operación que el diagnóstico exija mover al dominio.
4. Si tu dominio tiene (o prevé) una jerarquía de herencia con comportamiento que varía por tipo, diseñar su aplicación de Polymorphism.
5. Verificar que tu propio módulo aplica Dependency Injection y, si colabora con otro módulo, Indirection/Protected Variations — con la evidencia real de tu código.

### 4.2 Propósito

Que cada estudiante demuestre, de forma individual y fuera del aula, que puede reconocer y aplicar los patrones GoF y GRASP más usados en sistemas empresariales sobre su propio módulo, con criterio para decidir cuándo un patrón resuelve un problema real y cuándo es sobreingeniería.

### 4.3 Indicaciones

Entrega un PDF con el siguiente nombre:

```text
S10_ADS_Equipo##_ApellidoNombre.pdf
```

Cada captura de pantalla del informe debe mostrar, sin recortar, el reloj del sistema (fecha y hora) y tu usuario o foto de perfil (Windows, VS Code o navegador) visibles en pantalla — es lo que permite verificar que la evidencia es tuya y que corresponde al momento real de tu trabajo.

#### 4.3.1 Estructura del informe

**Datos del estudiante**

- Nombre:
- Equipo:
- Sesión: S10 - Patrones de Diseño GoF y GRASP
- Rol o aporte realizado:
- Link de GitHub:

**Evidencia técnica**

Incluye capturas o extractos con una breve explicación debajo de cada uno, organizados en los mismos 4 bloques de la rúbrica (4.6):

1. *Patrones GoF reconocidos o aplicados*
    - Factory Method/Creator, Facade, Proxy, Strategy, Chain of Responsibility, Observer y la decisión sobre State, cada uno con su justificación.
2. *Catálogo GRASP e Information Expert*
    - Los nueve patrones identificados, y el diagnóstico de Information Expert con su decisión.
3. *Refactor y Polymorphism*
    - El refactor diseñado según el diagnóstico, y el diseño de Polymorphism si tu dominio tiene una jerarquía aplicable.
4. *Dependency Injection y patrones de protección*
    - Evidencia real de tu código de Dependency Injection e Indirection/Protected Variations.

**Error o hallazgo**

Describe un error real: un patrón que al principio catalogaste mal, una decisión de State que reconsideraste después de aplicar la Tabla 4, una operación que el diagnóstico de Information Expert dijo que debía moverse y generó una duplicación que tuviste que limpiar, o un *Proxy* de framework que no habías notado hasta esta sesión.

**Reflexión técnica breve**

Responde en 5 a 8 líneas:

```text
¿Qué patrón de esta sesión reconociste en tu propio proyecto sin
haberlo diseñado a propósito (como los Proxy de framework)? ¿Y qué
operación diagnosticaste con Information Expert? Relaciona tu
respuesta con el caso de Fowler (1.6).
```

### 4.4 Criterios mínimos de aceptación

- El archivo respeta el nombre solicitado.
- Factory Method/Creator, Facade, Proxy, Strategy, Chain of Responsibility y Observer están identificados (reales o diseñados) en el módulo propio, con justificación.
- La decisión sobre State aplica el criterio de la Tabla 4, no una preferencia sin justificar.
- El catálogo GRASP cubre los nueve patrones, cada uno con su clase o diseño correspondiente.
- El diagnóstico de Information Expert evalúa al menos dos operaciones, con una decisión justificada.
- El refactor diseñado mueve lógica genuinamente propia de la entidad (la que tiene la información), sin duplicarla en el servicio.
- Si aplica, el diseño de Polymorphism reemplaza condicionales `instanceof` por un método polimórfico.
- La verificación de Dependency Injection e Indirection/Protected Variations usa código real del proyecto propio, no un ejemplo genérico.
- Cada captura de la evidencia técnica muestra el reloj del sistema y el usuario/perfil visible, sin recortar.
- Las fechas y horas de las capturas son coherentes con el historial de commits de su repositorio en GitHub.
- Incluye un error o hallazgo técnico diagnosticado.
- Incluye la reflexión técnica breve solicitada.

### 4.5 Preguntas de defensa

1. ¿Qué patrón de framework (Proxy) identificaste en tu propio proyecto sin haberlo escrito tú?
2. ¿Por qué Information Expert dice que una entidad debe calcular su propio total, y no el servicio?
3. ¿Bajo qué condición tu propio dominio justificaría el patrón State completo, y por qué hoy no lo justifica (o sí)?
4. ¿Qué diferencia hay entre Indirection y Protected Variations, si ambos pueden aplicarse a la misma clase?
5. ¿Por qué Creator predeciría que una clase que compone a otra debería crearla, y qué pasa si en tu código la crea una tercera clase?
6. En tu cadena de Chain of Responsibility (o la que diseñaste), ¿qué pasaría si el último eslabón no resolviera siempre la petición?
7. ¿Por qué un evento de dominio (Observer) no debería obligar a quien lo publica a esperar la respuesta de sus suscriptores?
8. Relaciona el caso de Fowler (1.6) con una regla de tu propio proyecto que hoy vive en el lugar equivocado.

### 4.6 Rúbrica de evaluación

**Tabla 10. Rúbrica de evaluación**

| Criterio | Peso (%) | A (20 pts) | B (15 pts) | C (10 pts) | D (5 pts) | Nivel obtenido |
|---|---:|---|---|---|---|---:|
| 1. Patrones GoF reconocidos o aplicados* | 25 | Factory Method/Creator, Facade, Proxy, Strategy, Chain of Responsibility y Observer identificados y justificados; decisión sobre State justificada con el criterio de la Tabla 4. | Los seis presentes, con alguna justificación imprecisa o la decisión de State sin criterio claro. | Falta más de uno de los seis patrones, o la decisión de State es solo una preferencia. | No presenta patrones GoF reconocidos. | |
| 2. Catálogo GRASP e Information Expert* | 25 | Los nueve patrones identificados; diagnóstico de Information Expert con decisión justificada en al menos dos operaciones. | Catálogo casi completo, diagnóstico presente con alguna justificación débil. | Catálogo incompleto, o diagnóstico sin aplicar el criterio de Information Expert. | No presenta catálogo GRASP ni diagnóstico. | |
| 3. Refactor y Polymorphism* | 25 | Refactor que mueve correctamente la lógica a la entidad experta, sin duplicación; Polymorphism bien diseñado si aplica. | Refactor correcto con alguna duplicación menor, o Polymorphism incompleto. | Refactor que mueve lógica que no le corresponde a la entidad, o Polymorphism mal aplicado. | No presenta refactor ni diseño de Polymorphism. | |
| 4. Dependency Injection y patrones de protección* | 25 | DI e Indirection/Protected Variations verificados con código real propio, bien distinguidos entre sí. | Ambos presentes, con alguna confusión entre los patrones. | Solo uno de los dos verificado correctamente. | No presenta verificación de ninguno. | |

\* Agregado manual.

Nota final = suma de (`Peso` / 100 × `Puntos del nivel obtenido`) = ____ / 20.

Para usar la rúbrica con IA (inteligencia artificial), solicita:

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

**Resumen breve:** hoy no se intentó cubrir los 32 patrones de GoF y GRASP — se reconocieron los ocho GoF más frecuentes en sistemas empresariales (Factory Method, Builder, Facade, Proxy, Strategy, State —evaluado y descartado por ahora—, Chain of Responsibility y Observer) y los nueve GRASP completos, con la profundidad suficiente para reconocerlos en cualquier proyecto futuro, no solo en `ventas`. Tres diseños concretos cerraron huecos reales o previstos: Creator/Factory Method (`Venta.agregarDetalle`), Information Expert (`calcularTotal()`, `descontarStock()`) y la cadena de autorización de ventas (Chain of Responsibility); y dos decisiones quedaron documentadas con su criterio: Polymorphism para `Cliente`, y por qué State completo todavía no se justifica para `Venta`.

**Dinámica participativa:** en una ronda rápida, cada estudiante comparte en una frase qué patrón de framework (Proxy) descubrió en su propio proyecto sin haberlo escrito a propósito.

**Metacognición:** ¿qué te costó más entender hoy: reconocer un patrón que el framework ya aplica solo (Proxy), o decidir con un criterio explícito si tu dominio justifica el patrón State completo o una cadena de Chain of Responsibility?

**Proyección:** S11 extiende el mismo criterio de responsabilidades a la frontera completa de la empresa: APIs externas, servicios de terceros y eventos de dominio — donde el *Observer* de hoy se formaliza como el mecanismo central de integración.

## Bibliografía

1. Fowler, M. (2003). *AnemicDomainModel*. martinfowler.com. https://martinfowler.com/bliki/AnemicDomainModel.html
2. Gamma, E., Helm, R., Johnson, R., & Vlissides, J. (1994). *Design Patterns: Elements of Reusable Object-Oriented Software*. Addison-Wesley.
3. Larman, C. (2004). *Applying UML and Patterns: An Introduction to Object-Oriented Analysis and Design and Iterative Development* (3rd ed.). Prentice Hall.
4. Fowler, M. (2004). *Inversion of Control Containers and the Dependency Injection pattern*. martinfowler.com. https://martinfowler.com/articles/injection.html
