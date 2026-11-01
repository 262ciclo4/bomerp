# S13 - Optimización y Preparación para Producción

*Por: Angel Sullon Macalupu @asullom - 2026*

## 1. Introducción

Tiempo: 20 min.

### 1.1 Presentación de la sesión

Unidad 2 cerró con un sistema funcionalmente completo: catálogo, ventas, seguridad con Keycloak, observabilidad con Prometheus/Loki/Grafana. Todo eso corrió siempre con `spring.profiles.active: dev` (S1) y con la SPA servida por `ng serve` — nunca se preguntó qué cambia si alguien más, en otra máquina, tiene que ejecutar o desplegar esto de verdad. Esta sesión abre Unidad 3 respondiendo esa pregunta: qué tan rápido carga la SPA la primera vez (Lazy Loading, Code Splitting), qué no debería repetir trabajo innecesario (caché del navegador, Redis), qué nivel de detalle debe registrar un log en producción frente a uno en desarrollo, qué debe exponer públicamente un endpoint de monitoreo y qué no, y qué necesita `bomerp-backend` para arrancar con un perfil `prod` que S1 (3.9) dejó anunciado, pero deliberadamente vacío. El porqué de tratar "producción" como una preocupación propia, no como "lo mismo de siempre pero en otro servidor", se desarrolla en 1.6, a partir del caso.

### 1.2 Índice

1. Lazy Loading y Code Splitting: medir lo que ya existe.
2. Caché del navegador: `Cache-Control` y validación condicional.
3. Caché con Redis: cuándo se justifica.
4. Logging para producción: niveles por perfil.
5. Monitoreo básico: Actuator seguro para producción.
6. Buenas prácticas de despliegue: perfiles, variables de entorno y build de producción.

### 1.3 Propósito de aprendizaje

Al concluir la clase, estarás en condiciones de:

- **Medir y documentar**, con evidencia antes y después, el tamaño de carga de tu SPA y el uso de Lazy Loading ya existente; **decidir con criterio** —midiendo, no por intuición— si tu proyecto necesita caché con Redis; **ajustar** logging y Actuator para que produzcan información útil sin exponer datos sensibles; y **preparar** una configuración de producción real (`application-prod.yml`, `environment.prod.ts`) con secretos fuera del código fuente.

### 1.4 Producto de sesión

Evidencia de Lazy Loading real por ruta (`ng build` con estadísticas de *chunks*, Network del navegador); presupuestos de bundle (`angular.json`) que fallan el build si una ruta crece de más; `Cache-Control` aplicado a un recurso que no cambia seguido; decisión documentada sobre Redis (implementado y justificado, o explícitamente descartado con la medición que lo sustenta); `logback-spring.xml` con niveles distintos por perfil (`dev` ruidoso, `prod` sobrio); `/actuator` expuesto de forma mínima y segura en `prod`; `application-prod.yml` y `environment.prod.ts` con la configuración real de producción, sin ninguna contraseña ni *secret* escrito en el código; y una guía reproducible de cómo levantar el sistema completo en modo producción local.

### 1.5 Metodología

**Tabla 1. Metodología de la sesión**

| Actividades a Realizar en el Periodo | Orientaciones generales (Orientaciones Metodológicas) | Material de estudio recomendado |
|---|---|---|
| Revisión previa individual | Confirmar que `lp2/bomerp-backend` y `lp2/bomerp-frontend` siguen arrancando en DEV (S1-S11). Revisar `application.yml` (S1, 3.9) y confirmar que `profiles.active: dev` sigue ahí. Trabajo individual, antes de clase. | S1 (3.9), S9 (`environment.ts`), S10b (`compose-dev.yml` de Keycloak). |
| Clase presencial | Medición guiada del bundle actual, configuración de presupuestos, `Cache-Control` sobre un endpoint real, decisión medida sobre Redis, ajuste de logging y Actuator por perfil, y construcción de `application-prod.yml`/`environment.prod.ts`. Trabajo individual en la propia laptop, siguiendo al docente paso a paso. | Contenedores y servicios de S1-S11 corriendo, Pasos 3.1 a 3.10 de esta guía. |
| Evaluación formativa | Revisión en clase del build de producción corriendo localmente, con `Cache-Control` verificado en el navegador y `/actuator` restringido en el perfil `prod`. La evidencia se completa y sustenta de forma individual, fuera del aula, según los criterios mínimos de la sección 4.4. | Indicaciones de entrega (4.3), rúbrica de evaluación (4.6). |

El cierre real de S12, construido con las respuestas del Anexo de feedback de esa sesión, se entrega al inicio de esta clase.

### 1.6 Motivación de la sesión

#### 1.6.1 Caso: el endpoint que nadie decidió exponer

Spring Boot Actuator, desde la versión 2 en adelante, solo expone `/actuator/health` por HTTP de forma predeterminada — el resto de endpoints (`/env`, `/beans`, `/heapdump`, `/configprops`) requieren una decisión explícita del desarrollador (`management.endpoints.web.exposure.include`) para quedar accesibles. Es un patrón de vulnerabilidad real y bien documentado, no hipotético: la propia documentación oficial de Spring Boot advierte explícitamente que "conviene considerar con cuidado qué endpoints exponer", porque varios de ellos exponen información sensible — `/env` puede mostrar variables de entorno completas, incluidas credenciales de base de datos si no se enmascaran; `/heapdump` puede entregar una copia de la memoria del proceso, con cualquier dato que estuviera en ella en ese instante.

Fuente: Spring Boot Reference Documentation. *Production-ready Features — Endpoints*. https://docs.spring.io/spring-boot/reference/actuator/endpoints.html

El problema no es Actuator — es copiar, sin revisar, una configuración de `application.yml` que en DEV usaba `include: "*"` ("expón todo, así no tengo que acordarme de nada") directo a producción. Nadie *decide* exponer `/env`; alguien lo deja así porque nunca lo volvió a mirar después de S1. Esta sesión trata exactamente ese tipo de decisión — qué se expone, qué se cachea, qué se registra en un log — como una configuración propia de cada perfil, no como un olvido que se arrastra de DEV a producción.

**Preguntas de análisis**

**Activación de conocimientos previos**

1. En `application.yml` (S1, 3.9), ¿qué perfil está activo hoy en tu proyecto? ¿Alguna vez lo cambiaste a mano?

**Comprensión de preparación para producción**

1. Si tu backend expusiera hoy `/actuator/env` sin restricción, ¿qué información real de tu propio proyecto podría ver cualquiera que encontrara esa URL?
2. ¿Por qué "funciona en mi laptop con `ng serve`" no es evidencia de que la SPA cargue rápido para un usuario real?

### 1.7 Ubicación en el curso

- Unidad: U3 - Proyecto Integrador Full-Stack.
- Producto del curso: Aplicación Full-Stack empresarial integrada, optimizada, monitoreada, estabilizada y preparada para producción, con evidencias y sustentación técnica.
- Producto de unidad: base Full-Stack modular de BomERP integrada, optimizada, monitoreada y estabilizada (`lp2-producto.md`, Unidad 3).
- Avance del producto en esta sesión: Lazy Loading y Code Splitting medidos y documentados, caché del navegador aplicado, decisión medida sobre Redis, logging y Actuator ajustados por perfil, y configuración real de producción (`application-prod.yml`, `environment.prod.ts`).

Roadmap del producto de la unidad:

**Figura 1. Roadmap del producto de la unidad**

```mermaid
flowchart TB
    S13["`**S13:** Optimización y preparación para producción`"]
    S14["`**S14:** Integración y estabilización`"]
    S15["`**S15:** Evaluación de la Unidad III`"]
    S16["`**S16:** Continuación de la evaluación`"]

    S13 --> S14 --> S15 --> S16

    classDef today fill:#ffe08a,stroke:#9a6b00,stroke-width:2px,color:#111;
    class S13 today;
```

## 2. Explica

Tiempo: 40 min.

### 2.1 Arquitectura de la sesión

**Figura 2. De una aplicación que funciona a una lista verificada de producción**

```mermaid
flowchart TB
    A[Bundle actual de la SPA] --> B[Medir Lazy Loading real<br/>y presupuestos de tamaño]
    C[Endpoint que casi no cambia] --> D[Cache-Control del navegador]
    C --> E{"¿Se repite la misma<br/>consulta seguido?"}
    E -- Si, medido --> F[Redis]
    E -- No, o sin medir --> G[Sin Redis, justificado]
    H[logback-spring.xml] --> I[Niveles por perfil:<br/>dev ruidoso, prod sobrio]
    J[Actuator] --> K[Mínimo expuesto en prod]
    B --> L[application-prod.yml<br/>environment.prod.ts]
    D --> L
    F --> L
    G --> L
    I --> L
    K --> L
```

Lectura del diagrama: ninguna de las cinco piezas (Lazy Loading, caché del navegador, Redis, logging, Actuator) es un tema aislado — todas convergen en la misma pregunta de cierre, la configuración real de producción. Cada apartado siguiente desarrolla una pieza, en el mismo orden del Índice (1.2).

### 2.2 Lazy Loading y Code Splitting: medir lo que ya existe

**Lazy Loading** es la técnica de cargar el código de una pantalla solo cuando el usuario navega a ella, en vez de descargar toda la aplicación de una sola vez al abrir el sitio (Angular, 2026a). **Code Splitting** es el mecanismo del empaquetador (*bundler*) que hace eso posible: en vez de un único archivo JavaScript con toda la aplicación, genera varios archivos más pequeños — un **chunk** (literalmente "trozo" o "fragmento"; en adelante, un fragmento de código JavaScript independiente, con su propio nombre de archivo) por cada punto de carga diferida.

**Esto no es contenido nuevo — ya está construido desde S7.** Cada ruta de `app.routes.ts` usa `loadComponent: () => import(...)` (S7, 3.6-3.7), y `import()` dinámico es, precisamente, la sintaxis que le indica al compilador de Angular dónde cortar un *chunk* nuevo (Angular, 2026b). Lo que esta sesión agrega no es la técnica — es la **medición**: confirmar con evidencia real que el *chunk* de `Ventas` no se descarga cuando el usuario solo visita `Categorías`, y poner un límite (presupuesto) que impida que una ruta crezca sin que nadie se dé cuenta.

**Tabla 2. Qué ya existe (S7-S11) frente a qué agrega esta sesión**

| | Ya construido (S7-S11) | Esta sesión agrega |
|---|---|---|
| Mecanismo | `loadComponent` por ruta, en cada *feature* | — (no cambia) |
| Evidencia | Ninguna, se asumía que funcionaba | *Chunks* medidos con `ng build` y con el Network del navegador |
| Límite | Ninguno | Presupuestos (`budgets`) en `angular.json` que fallan el build si se exceden |

**Error frecuente**: confundir "mi aplicación tiene pocas pantallas" con "no necesito medir esto". El problema no es cuántas rutas tiene la SPA hoy — es que, sin un presupuesto, nada evita que una ruta crezca sin control más adelante (una librería agregada sin pensar, un componente que importa todo un módulo de Angular Material) y nadie lo note hasta que la aplicación ya se siente lenta en producción.

### 2.3 Caché del navegador: `Cache-Control` y validación condicional

El navegador puede evitar una petición HTTP completa si el servidor ya le dijo, en una respuesta anterior, cuánto tiempo puede reutilizar ese mismo recurso sin volver a pedirlo. Esa instrucción viaja en la cabecera `Cache-Control` (IETF, 2014) — `max-age=<segundos>` dice cuánto tiempo el navegador puede servir la respuesta guardada sin preguntarle nada al servidor; `no-cache` permite guardarla, pero exige revalidar con el servidor antes de reusarla; `no-store` prohíbe guardarla por completo.

**Tabla 3. Qué `Cache-Control` conviene según el tipo de recurso**

| Tipo de recurso | Cambia con qué frecuencia | `Cache-Control` recomendado |
|---|---|---|
| Archivos estáticos de la SPA ya compilados (JS, CSS con *hash* en el nombre) | Nunca — un build nuevo genera nombres de archivo distintos | `max-age` largo (un año), porque el nombre del archivo ya cambia si el contenido cambia |
| `GET /api/v1/categorias` (catálogo de referencia) | Rara vez, solo cuando alguien administra el catálogo | `max-age` corto a moderado, o validación condicional (`ETag`) |
| `GET /api/v1/ventas` (datos transaccionales propios del usuario) | Constantemente | `no-store` — nunca cachear datos que cambian por cada venta nueva |

**Error frecuente**: aplicar el mismo `Cache-Control` a todos los endpoints "porque ya funcionó en uno". Cachear `GET /api/v1/ventas` con el mismo `max-age` que el catálogo haría que un usuario viera una lista de ventas desactualizada después de registrar una nueva, sin que ningún error se lo avisara — el síntoma sería "mi venta no aparece", no un error técnico claro.

### 2.4 Caché con Redis: cuándo se justifica

**Redis** es un almacén de datos en memoria, separado de la base de datos relacional, que responde en microsegundos porque no tiene que leer disco ni resolver un plan de consultas (Redis Ltd., 2024). Se usa como caché del lado del servidor para evitar repetir, contra Oracle, una consulta cuyo resultado ya se calculó hace poco y probablemente no cambió.

El sílabo dice explícitamente "Redis **cuando corresponda**" — no es obligatorio por sí mismo, y el criterio para decidir es el mismo que ya usó BD2 para un índice (selectividad medida, S5 de BD2): si la mayoría de las peticiones a un endpoint piden exactamente el mismo resultado, en una ventana corta de tiempo, cachearlo ahorra trabajo real; si cada petición es distinta (filtros distintos, datos que cambian por usuario), Redis solo agrega una pieza más que mantener sincronizada, sin beneficio real.

**Tabla 4. Candidatos reales a caché con Redis en BomERP**

| Endpoint | ¿Buen candidato? | Por qué |
|---|---|---|
| `GET /api/v1/categorias` | Sí | Pocas filas, cambia rara vez, se consulta en cada carga de `ProductoForm` (S8) y de cada filtro de `ProductoList`. |
| `GET /api/v1/productos` | Depende del volumen | Si el catálogo es grande y estable, sí; si cambia seguido (stock descontándose en cada venta), el beneficio baja. |
| `GET /api/v1/ventas` | No | Transaccional por naturaleza — cachearlo arriesga mostrar datos desactualizados justo después de una venta nueva. |

**Decisión medida, no por intuición.** Antes de implementar Redis, mide: ¿cuántas veces se repite la misma consulta en un período corto? Si `GET /api/v1/categorias` se llama una vez por carga de pantalla y el catálogo tiene cinco categorías, el ahorro real es marginal — documentar esa medición y decidir **no** usar Redis es una entrega tan válida como implementarlo, siempre que la decisión esté justificada con datos, no con "por si acaso" (mismo criterio que ya aplicó BD2 con el índice sobre `ESTADO`, S5).

**Caso especial: los datos del usuario autenticado.** Un patrón muy común es pedir, justo después de iniciar sesión, "mi perfil" a un endpoint propio para mostrar el nombre o el rol en el encabezado — y volver a pedirlo cada vez que una pantalla lo necesita. En BomERP eso casi nunca hace falta: el JWT que Keycloak ya emitió (S10b, S11) trae, como *claims*, exactamente los datos básicos de perfil que la SPA necesita mostrar — `sub` (identificador), `email` y `realm_access.roles`. La SPA ya decodifica ese token al iniciar sesión para decidir el menú por rol (S11); no hace falta un segundo endpoint HTTP, y menos un caché en Redis, para algo que ya vive en memoria desde el login. Cachear esos mismos datos en Redis sería cachear algo que nunca costó una consulta a Oracle en primer lugar — el problema que Redis resuelve es evitar repetir una consulta **cara**, no evitar leer un valor que el propio navegador ya tiene decodificado.

Redis sí se justifica si tu proyecto agrega un perfil de usuario más rico que el que trae el JWT (preferencias, datos de negocio propios de ese usuario, guardados en tu propio esquema Oracle) — ahí aplica el mismo criterio medido de la Tabla 4: si ese perfil extendido se consulta seguido y cambia poco, mide y decide.

**Invalidación**: el problema que Redis agrega, no el que resuelve. Un caché que nunca se actualiza es peor que no tener caché — si `ProductoService.crear()` guarda una categoría nueva pero el caché de `listar()` sigue sirviendo la lista vieja, el usuario ve datos incorrectos sin ningún error. Por eso cada operación de escritura sobre una entidad cacheada debe invalidar (evict) la entrada correspondiente del caché, en la misma transacción que la escritura.

### 2.5 Logging para producción: niveles por perfil

`logback-spring.xml` (S1) ya escribe logs estructurados a archivo, con `CorrelationIdFilter` agregando el `traceId` a cada línea desde S5. Lo que nunca se revisó es **qué nivel** de detalle corresponde a cada ambiente. Un nivel de log decide qué tan ruidoso es el registro — de más detallado a menos: `TRACE`, `DEBUG`, `INFO`, `WARN`, `ERROR` (Logback, 2024).

**Tabla 5. Nivel de log recomendado por perfil**

| Perfil | Nivel recomendado | Por qué |
|---|---|---|
| `dev` | `DEBUG` | Ayuda a diagnosticar mientras se programa; el volumen de logs no importa en una laptop de desarrollo. |
| `prod` | `INFO` (o `WARN` para librerías de terceros) | `DEBUG` en producción genera un volumen de logs que cuesta espacio y dinero de verdad, y puede llegar a registrar datos sensibles que un nivel más alto omite. |

Spring Boot resuelve esto con **perfiles** dentro del mismo `logback-spring.xml`, usando `<springProfile name="...">` para declarar configuración distinta según `spring.profiles.active` (Spring Boot, 2026a) — el mismo mecanismo de perfiles que `application.yml` ya usa desde S1, aplicado ahora al archivo de logging.

**Error frecuente**: registrar en el log el cuerpo completo de un request que incluye una contraseña o un token — ni siquiera en `DEBUG`. Un nivel de log más bajo reduce el volumen, pero no reemplaza la responsabilidad de nunca loguear un dato sensible en ningún nivel.

### 2.6 Monitoreo básico: Actuator seguro para producción

Spring Boot Actuator ya responde `/actuator/health` desde S1 (3.3) — ese es, de hecho, el único endpoint que Actuator expone por HTTP de forma predeterminada desde la versión 2 (Spring Boot, 2026b). Esta sesión no agrega el endpoint: revisa **qué más** queda expuesto, y decide, por perfil, qué corresponde mostrar.

**Tabla 6. Endpoints de Actuator — exposición recomendada por perfil**

| Endpoint | Qué muestra | DEV | PROD |
|---|---|---|---|
| `/actuator/health` | Estado de salud (`UP`/`DOWN`), con el componente `db` (S1). | Sí | Sí |
| `/actuator/info` | Información del build (versión, commit), sin datos sensibles. | Sí | Sí |
| `/actuator/metrics` | Métricas internas (uso de memoria, conteo de peticiones). | Sí | Opcional, protegido por autenticación |
| `/actuator/env` | Variables de entorno completas, incluidas credenciales si no se enmascaran. | Sí (consulta propia) | **No** |
| `/actuator/heapdump` | Volcado completo de memoria del proceso. | Sí (consulta propia) | **No** |

`management.endpoints.web.exposure.include` en `application-prod.yml` declara explícitamente la lista corta (`health,info`), en vez de heredar lo que `application-dev.yml` tenga configurado — nunca con el valor `"*"` ("todo") en producción, por la misma razón que desarrolla el caso de 1.6.1.

### 2.7 Buenas prácticas de despliegue: perfiles, variables de entorno y build de producción

Un **ambiente de producción** no es "la misma configuración de DEV en otra máquina" — es un perfil propio, con sus propias decisiones: `application-prod.yml` (backend) y `environment.prod.ts` (frontend), ambos anunciados desde S1 (backend) y S9 (frontend) pero vacíos hasta hoy.

**Tabla 7. DEV frente a PROD: qué cambia realmente**

| Decisión | DEV | PROD |
|---|---|---|
| Contraseña de base de datos | Puede vivir en `application-dev.yml`, de uso solo local | Nunca en el archivo — se lee de una variable de entorno (`${DB_PASSWORD}`) |
| `ddl-auto` de Hibernate (S1) | `update` o `validate`, cómodo para iterar | `validate` siempre — producción nunca modifica el esquema sola |
| Nivel de log | `DEBUG` | `INFO`/`WARN` (2.5) |
| Actuator expuesto | Lista amplia | Lista mínima (2.6) |
| URL del backend en la SPA (`environment.ts`, S9) | `http://localhost:8080` | La URL real del servidor de producción |
| Build de Angular | `ng serve` (sin optimizar, recarga en caliente) | `ng build --configuration production` (minificado, *tree-shaking*, sin *source maps* públicos) |
| Cómo arranca el backend | `mvnw spring-boot:run` (recompila y corre directo desde el código fuente) | Imagen Docker ya construida (`Dockerfile`, 3.8), arrancada con `docker compose -f compose-prod.yml up` |

Una variable que sí viaja en el archivo (como `ddl-auto` o el nivel de log) no es un secreto; una contraseña, una clave de API o un *secret* de firma de JWT **nunca** se escribe directo en un archivo `.yml` que vive en el repositorio — se lee desde una variable de entorno del sistema operativo o del contenedor (`${VARIABLE}` en la sintaxis de Spring), siguiendo el mismo principio de mínimo privilegio que BD2 ya aplicó a los usuarios de Oracle.

**Error frecuente**: subir `application-prod.yml` al repositorio con una contraseña real ya escrita adentro, "solo por ahora, para probar". Una vez que un commit con un secreto llega al historial de Git, ese secreto queda expuesto para siempre, aunque se borre en un commit posterior — el historial lo sigue conservando.

## 3. Aplica: actividad práctica guiada

Tiempo: 120 min.

**Actividad:** medición guiada de Lazy Loading y presupuestos de bundle, `Cache-Control` sobre un endpoint real, decisión medida sobre Redis, ajuste de logging y Actuator por perfil, y construcción de la configuración real de producción (Producto de la sesión en 1.4).

**Propósito de la actividad:** llevar BomERP de "funciona en mi laptop con `ng serve`" a "tiene una configuración de producción real, medida y documentada", con el mismo criterio que cada estudiante aplicará después sobre su propio proyecto.

**Orientaciones metodológicas:** en el laboratorio, el docente mide y configura `bomerp-backend`/`bomerp-frontend` paso a paso frente a la clase; los estudiantes repiten cada paso en su propia instancia y aplican después el mismo criterio a su propio proyecto (ver sección 4).

**Actividades para realizar:**

- **3.1** Verificar el punto de partida.
- **3.2** Medir el bundle actual y confirmar Lazy Loading real.
- **3.3** Configurar presupuestos de bundle.
- **3.4** Aplicar `Cache-Control` a un endpoint real.
- **3.5** Medir y decidir sobre Redis.
- **3.6** Ajustar logging por perfil.
- **3.7** Asegurar Actuator para producción.
- **3.8** Construir `application-prod.yml` y `environment.prod.ts`.
- **3.9** Ejecutar el build de producción y verificar de punta a punta.
- **3.10** Relacionar con ADS y BD2.

### 3.1 Verificar el punto de partida

**Punto de partida común:** todo el equipo debe comenzar exactamente desde donde quedó S11, no desde su propio avance individual — S12 fue evaluación, sin código nuevo. Clona la rama `s11-seguridad-frontend-keycloak` (el snapshot de cierre de S11):

```bash
git clone --branch s11-seguridad-frontend-keycloak https://github.com/262ciclo4/bomerp.git
```

**Producto del paso:** confirmación de que `bomerp-backend` y `bomerp-frontend` siguen arrancando en DEV, punto de partida de toda la sesión.

PowerShell:

```powershell
cd lp2/bomerp-backend
.\mvnw.cmd spring-boot:run
```

macOS/Linux:

```bash
cd lp2/bomerp-backend
./mvnw spring-boot:run
```

En otra terminal:

```bash
cd lp2/bomerp-frontend
ng serve
```

Confirma `http://localhost:8080/actuator/health` (`UP`) y `http://localhost:4200` (la SPA carga con el login de Keycloak, S11).

### 3.2 Medir el bundle actual y confirmar Lazy Loading real

**Producto del paso:** evidencia real de que cada *feature* de la SPA se descarga como un *chunk* separado, no todo de una vez.

Genera un build de producción con estadísticas:

```bash
cd lp2/bomerp-frontend
ng build --configuration production --stats-json
```

La terminal imprime una tabla con cada *chunk* generado y su tamaño — confirma que existen archivos separados para `catalogo`, `ventas` y `seguridad` (o los nombres reales de tus *features*), no un único archivo gigante con toda la aplicación.

Ahora confírmalo en vivo, en el navegador: abre `http://localhost:4200` con las herramientas de desarrollo (`F12`) en la pestaña **Network**, filtra por `JS`, limpia la lista y navega directo a **Categorías** sin pasar por **Ventas**. Ningún archivo con `ventas` en el nombre debería aparecer en la lista — recién aparece cuando haces clic en el enlace de **Ventas** del sidebar.

**Error frecuente**: medir el bundle con `ng serve` (modo desarrollo). `ng serve` no aplica las mismas optimizaciones que `ng build --configuration production` (minificación, *tree-shaking*) — el tamaño que ves en DEV no representa el tamaño real que descargaría un usuario en producción.

### 3.3 Configurar presupuestos de bundle

**Producto del paso:** `angular.json` con un límite de tamaño que hace fallar el build si una ruta crece sin control.

En `angular.json`, dentro de la configuración `production` del proyecto, agrega o revisa `budgets`:

```json
"budgets": [
  {
    "type": "initial",
    "maximumWarning": "500kB",
    "maximumError": "1MB"
  },
  {
    "type": "anyComponentStyle",
    "maximumWarning": "4kB",
    "maximumError": "8kB"
  }
]
```

`initial` mide el *chunk* que se descarga al abrir la aplicación por primera vez (antes de cualquier Lazy Loading) — ese es el que de verdad afecta cuánto espera un usuario nuevo. Vuelve a correr `ng build --configuration production`: si algún *chunk* supera `maximumError`, el build falla con el archivo y el tamaño exacto que lo causó — una alerta temprana, no un descubrimiento tardío en producción.

### 3.4 Aplicar `Cache-Control` a un endpoint real

**Producto del paso:** `GET /api/v1/categorias` respondiendo con una cabecera `Cache-Control` real, verificada en el navegador.

En `CategoriaController` (S7), agrega la cabecera a la respuesta del listado:

```java
@GetMapping
public ResponseEntity<List<CategoriaResponse>> listar() {
    List<CategoriaResponse> categorias = categoriaService.listar();
    return ResponseEntity.ok()
            .cacheControl(CacheControl.maxAge(Duration.ofMinutes(5)))
            .body(categorias);
}
```

`CacheControl.maxAge(...)` (de `org.springframework.http.CacheControl`) arma la cabecera por ti, sin construir el texto a mano. Verifica en el navegador: con las herramientas de desarrollo abiertas, pestaña **Network**, recarga `CategoriaList` y revisa la respuesta de `/api/v1/categorias` — la cabecera `Cache-Control: max-age=300` debe aparecer, y una segunda petición dentro de esos 5 minutos no debería generar una llamada de red nueva (aparece marcada como servida desde caché).

**Error frecuente**: aplicar la misma cabecera a `VentaController.crear()` o a cualquier endpoint que escribe datos (`POST`/`PUT`/`DELETE`). `Cache-Control` solo tiene sentido sobre respuestas de lectura (`GET`) — cachear la respuesta de una escritura no tiene ningún efecto útil y puede confundir a quien revise el comportamiento más adelante.

### 3.5 Medir y decidir sobre Redis

**Producto del paso:** una decisión documentada sobre Redis para tu propio proyecto — implementado y justificado, o descartado con la medición que lo sustenta.

Antes de escribir una sola línea de código, mide: abre el reporte de uso de `CategoriaService.listar()` (o agrega un contador simple, un `AtomicInteger` incrementado en cada llamada) y observa cuántas veces se invoca en una sesión de prueba normal de 5 minutos navegando la SPA. Documenta ese número — es el dato que justifica (o no) el siguiente paso.

**Si la medición justifica Redis**, agrega la dependencia a `pom.xml`:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
```

Agrega Redis a `lp2/bomerp-backend/compose-dev.yml` (mismo criterio de puertos que Keycloak, S10b — prefijo `3` para LP2 DEV):

```yaml
  bomerp-redis:
    image: redis:7.4-alpine
    container_name: bomerp-redis-dev
    ports:
      - "36379:6379"
```

Habilita el caché y anota el método a cachear:

```java
@EnableCaching
@SpringBootApplication
public class BomerpBackendApplication { }
```

```java
@Cacheable("categorias")
public List<CategoriaResponse> listar() {
    // la consulta real a Oracle, sin cambios
}
```

E invalida el caché en cada escritura, en la misma clase:

```java
@CacheEvict(value = "categorias", allEntries = true)
public CategoriaResponse crear(CategoriaRequest request) {
    // igual que antes
}
```

**Si la medición no lo justifica**, documenta la decisión igual (el número medido en 3.5, y por qué no alcanza para justificar una pieza nueva de infraestructura) — es una entrega tan válida como implementarlo (2.4).

### 3.6 Ajustar logging por perfil

**Producto del paso:** `logback-spring.xml` con `DEBUG` en `dev` e `INFO` en `prod`, verificado con el mismo log real en los dos perfiles.

Envuelve el nivel del paquete propio del proyecto (`pe.edu.upeu.bomerp`) con `springProfile`:

```xml
<springProfile name="dev">
    <logger name="pe.edu.upeu.bomerp" level="DEBUG"/>
</springProfile>

<springProfile name="prod">
    <logger name="pe.edu.upeu.bomerp" level="INFO"/>
</springProfile>
```

Arranca en `dev` (como siempre, S1) y confirma el volumen del log al ejecutar el mismo flujo (listar categorías, registrar una venta):

```powershell
.\mvnw.cmd spring-boot:run "-Dspring-boot.run.profiles=dev"
```

La comparación contra `prod` se hace en 3.9, sobre el contenedor real — `mvnw spring-boot:run` es una herramienta de desarrollo (recompila y arranca directo desde el código fuente); no es como corre un `prod` real, que arranca desde un JAR ya empaquetado dentro de una imagen Docker.

### 3.7 Asegurar Actuator para producción

**Producto del paso:** `/actuator/env` y `/actuator/heapdump` accesibles en `dev`, bloqueados en `prod`.

En `application-dev.yml` (ya existe desde S1):

```yaml
management:
  endpoints:
    web:
      exposure:
        include: "*"
```

En `application-prod.yml` (3.8, nuevo hoy):

```yaml
management:
  endpoints:
    web:
      exposure:
        include: health,info
```

La verificación real (`curl http://localhost:8080/actuator/env` → `404`) se hace en 3.9, sobre el contenedor de `prod` — la misma protección por omisión que el caso de 1.6.1 describe, aplicada explícitamente en tu propio `application-prod.yml`, no heredada por accidente.

### 3.8 Construir `application-prod.yml`, `environment.prod.ts` y el `Dockerfile` del backend

**Producto del paso:** la configuración de producción real, con secretos leídos de variables de entorno, y la imagen Docker que empaqueta `bomerp-backend` para correr como correría de verdad — nunca con `mvnw`.

`lp2/bomerp-backend/src/main/resources/application-prod.yml`:

```yaml
spring:
  datasource:
    url: jdbc:oracle:thin:@${DB_HOST:localhost}:1521/FREEPDB1
    username: ${DB_USERNAME}
    password: ${DB_PASSWORD}
  jpa:
    hibernate:
      ddl-auto: validate
management:
  endpoints:
    web:
      exposure:
        include: health,info
```

`lp2/bomerp-backend/Dockerfile` (*multi-stage*: compila en una imagen con Maven, y el contenedor final solo lleva el JAR ya construido y el JRE, sin el código fuente ni Maven):

```dockerfile
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .
RUN ./mvnw clean package -DskipTests

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

`lp2/bomerp-backend/compose-prod.yml` — el backend corre en su propio contenedor, pero reutiliza el mismo Oracle y el mismo Keycloak que `compose-dev.yml` ya levantó (S1, S10b): `host.docker.internal` es el mismo mecanismo que `obs/prometheus` ya usa, al revés, para llegar desde Docker hasta un proceso que corre fuera de Docker (S4) — aquí lo usa el backend, ya adentro de Docker, para llegar a los contenedores de infraestructura publicados en el host:

```yaml
services:
  bomerp-backend:
    build: .
    container_name: bomerp-backend-prod
    ports:
      - "8080:8080"
    environment:
      SPRING_PROFILES_ACTIVE: prod
      DB_HOST: host.docker.internal
      DB_USERNAME: ${DB_USERNAME}
      DB_PASSWORD: ${DB_PASSWORD}
    extra_hosts:
      - "host.docker.internal:host-gateway"
```

`extra_hosts` hace que `host.docker.internal` resuelva también en Linux (en Docker Desktop para Windows/macOS ya resuelve solo) — la recomendación oficial de Docker para este mismo caso (Docker Inc., 2024).

`lp2/bomerp-frontend/src/environments/environment.prod.ts`:

```ts
export const environment = {
  apiBaseUrl: 'https://api.tu-dominio-real.com',
};
```

Confirma en `angular.json` que la configuración `production` ya reemplaza `environment.ts` por `environment.prod.ts` (`fileReplacements`) — la CLI lo deja así desde `ng new` (S7, 3.3); si tu proyecto no lo tiene, agrégalo:

```json
"fileReplacements": [
  {
    "replace": "src/environments/environment.ts",
    "with": "src/environments/environment.prod.ts"
  }
]
```

**Error frecuente**: escribir `DB_PASSWORD` con un valor real directo en `application-prod.yml`, "para probar más rápido". La sintaxis `${DB_PASSWORD}` sin un valor por defecto obliga a que la variable exista en el entorno donde corre el proceso — si no existe, el arranque falla con un mensaje claro, en vez de arrancar en silencio con una contraseña expuesta en el repositorio.

### 3.9 Ejecutar el build de producción y verificar de punta a punta

**Producto del paso:** el sistema completo corriendo con la configuración de producción, de punta a punta.

Define las variables de entorno (una sola vez por sesión de terminal) y construye/levanta el contenedor de `prod` — ya no `mvnw`, la imagen que 3.8 construyó:

PowerShell:

```powershell
cd lp2/bomerp-backend
$env:DB_USERNAME = "BOMERP_APP"
$env:DB_PASSWORD = "123456"
docker compose -f compose-prod.yml up --build -d
```

macOS/Linux:

```bash
cd lp2/bomerp-backend
export DB_USERNAME=BOMERP_APP
export DB_PASSWORD=123456
docker compose -f compose-prod.yml up --build -d
```

Confirma que el contenedor arrancó sano y compara su log contra el de `dev` (3.6) — ahora sí, los dos arrancados de la forma en que cada uno corre de verdad:

```bash
docker compose -f compose-prod.yml logs -f bomerp-backend
```

Y verifica Actuator (3.7) contra el contenedor real:

```bash
curl http://localhost:8080/actuator/health
curl http://localhost:8080/actuator/env
```

Resultado esperado: `health` responde `UP`; `env` responde `404` — la protección de 3.7 ya no es una promesa en el YAML, es el comportamiento real del contenedor que de verdad va a correr.

Construye el frontend en modo producción y sírvelo con cualquier servidor estático simple (por ejemplo, `http-server`, sin instalar nada nuevo si ya tienes Node.js, S7):

```bash
cd lp2/bomerp-frontend
ng build --configuration production
npx http-server dist/bomerp-frontend/browser -p 4300
```

Abre `http://localhost:4300`, inicia sesión contra Keycloak (S11) y registra una venta de punta a punta — el mismo flujo completo de siempre, ahora sobre el build optimizado y con el backend en perfil `prod`.

### 3.10 Relacionar con ADS y BD2

Sesión equivalente en los otros dos cursos, misma semana: ADS cierra su propio Catálogo UML en S12 y entra a Unidad 3 con la integración y consolidación del producto del curso. BD2 ya cerró Unidad 2 (S12) con la base administrada, optimizada y asegurada — la decisión de `ddl-auto: validate` en producción (3.8) es, precisamente, la garantía de que `bomerp-backend` nunca modifica sola el esquema que BD2 ya administra.

## 4. Crea: actividad autónoma

Tiempo: 2h fuera del aula.

### 4.1 Actividad

Optimización y preparación para producción del proyecto propio del equipo, documentada en evidencia individual.

Completa y evidencia estas tareas:

1. Medir el bundle de tu propia SPA y confirmar Lazy Loading real, con evidencia de Network.
2. Configurar presupuestos de bundle en `angular.json` propio.
3. Aplicar `Cache-Control` a al menos un endpoint de lectura propio.
4. Medir el uso real de al menos un endpoint candidato y decidir, con esa medición, si Redis se justifica — implementarlo si corresponde, o documentar por qué no.
5. Ajustar `logback-spring.xml` (o equivalente) con niveles distintos por perfil.
6. Asegurar Actuator: lista mínima expuesta en `prod`, verificada con `/actuator/env` devolviendo `404`.
7. Construir `application-prod.yml`/`environment.prod.ts` propios, sin ningún secreto escrito en el código.
8. Ejecutar el build de producción de punta a punta sobre tu propio dominio.

### 4.2 Propósito

Que cada estudiante demuestre, de forma individual y fuera del aula, que puede preparar su propio sistema para un ambiente de producción real —medido, no asumido—, sin el acompañamiento del docente.

### 4.3 Indicaciones

Entrega un PDF con el siguiente nombre:

```text
S13_LP2_Equipo##_ApellidoNombre.pdf
```

Cada captura de pantalla del informe debe mostrar, sin recortar, el reloj del sistema (fecha y hora) y tu usuario o foto de perfil (Windows, VS Code o navegador) visibles en pantalla — es lo que permite verificar que la evidencia es tuya y que corresponde al momento real de tu trabajo.

#### 4.3.1 Estructura del informe

**Datos del estudiante**

- Nombre:
- Equipo:
- Sesión: S13 - Optimización y Preparación para Producción
- Rol o aporte realizado:
- Link de GitHub:

**Evidencia técnica**

Incluye capturas o salidas con una breve explicación debajo de cada una, organizadas en los mismos 5 bloques de la rúbrica (4.6):

1. *Lazy Loading y presupuestos*
    - Evidencia de Network confirmando carga diferida real, y `angular.json` con `budgets` configurados.
2. *Caché del navegador*
    - `Cache-Control` verificado en un endpoint de lectura real.
3. *Decisión sobre Redis*
    - Medición real del uso del endpoint candidato, y la decisión (implementado o descartado) justificada con ese número.
4. *Logging y Actuator por perfil*
    - Comparación del log en `dev` frente a `prod`, y `/actuator/env` devolviendo `404` en `prod`.
5. *Configuración de producción*
    - `application-prod.yml`/`environment.prod.ts` propios, con el build de producción corriendo de punta a punta.

**Error o hallazgo**

Describe un hallazgo real: una ruta que resultó más pesada de lo esperado, un secreto que casi queda escrito en el repositorio, un endpoint de Actuator que no sabías que estaba expuesto, o una decisión sobre Redis que la medición cambió frente a tu primera intuición.

**Reflexión técnica breve**

Responde en 5 a 8 líneas:

```text
¿Por qué una configuración que "funciona en mi laptop" no es evidencia
de que esté lista para producción? Relaciona tu respuesta con el caso
de 1.6 y con al menos una decisión propia de esta sesión.
```

**Anexo: Feedback de la sesión**

Pega esta página como la última hoja del PDF, con tus respuestas.

1. ¿Cuál es el aprendizaje más importante que te llevas de la clase de hoy?
2. ¿Qué punto de la clase te resultó más confuso o te dejó con dudas?
3. ¿Tienes alguna pregunta que te gustaría que sea respondida la siguiente clase?
4. Sobre tu nivel de comprensión de la clase de hoy, marca una opción:
    - ¡Entendido! - Lo domino y podría explicarlo.
    - Más o menos. - Entendí la idea general, pero tengo dudas.
    - Necesito ayuda. - Me siento perdido/a con este tema.
5. ¿Cómo puedo ayudarte a comprender mejor el tema?
6. Pensando en tu participación y esfuerzo en la clase de hoy, ¿cómo te autoevaluarías? Marca una opción:
    - Muy Comprometido/a: Me esforcé al máximo.
    - Comprometido/a: Sé que podría haberme esforzado un poco más.
    - Poco Comprometido/a: Hoy no di mi mejor esfuerzo.
7. Mi satisfacción con la clase fue... (califica del 1 al 10, donde 1 es insatisfecho y 10 es muy satisfecho).

### 4.4 Criterios mínimos de aceptación

La evidencia individual se considera completa si:

- El archivo respeta el nombre solicitado.
- Presenta evidencia real de Lazy Loading (Network) y presupuestos de bundle configurados.
- Aplica `Cache-Control` a al menos un endpoint de lectura, verificado en el navegador.
- Presenta una decisión sobre Redis respaldada por una medición real, en cualquiera de los dos sentidos.
- Ajusta el logging por perfil y asegura Actuator en `prod` (`/actuator/env` → `404`).
- Construye `application-prod.yml`/`environment.prod.ts` sin ningún secreto en el código, y ejecuta el build de producción de punta a punta.
- Cada captura de la evidencia técnica muestra el reloj del sistema y el usuario/perfil visible, sin recortar.
- Las fechas y horas de las capturas son coherentes con el historial de commits de su repositorio en GitHub.
- Incluye un error o hallazgo técnico diagnosticado.
- Incluye la reflexión técnica breve solicitada.
- Incluye el Anexo de feedback de la sesión respondido, como última página del PDF.

### 4.5 Preguntas de defensa

1. ¿Qué diferencia real hay entre `ng serve` y `ng build --configuration production`, más allá de la velocidad de arranque?
2. ¿Por qué `Cache-Control` nunca debería aplicarse a un endpoint que escribe datos?
3. ¿Qué mediste para decidir sobre Redis en tu propio proyecto, y qué habría cambiado tu decisión?
4. ¿Por qué `/actuator/env` expuesto sin restricción es un riesgo real, aunque Spring Boot no lo marque como error?
5. ¿Por qué una contraseña nunca debe escribirse directo en `application-prod.yml`, aunque el archivo esté en un repositorio privado?

### 4.6 Rúbrica de evaluación

**Tabla 8. Rúbrica de evaluación**

| Criterio | Peso (%) | A (20 pts) | B (15 pts) | C (10 pts) | D (5 pts) | Nivel obtenido |
|---|---:|---|---|---|---|---:|
| 1. Lazy Loading y presupuestos* | 20 | Evidencia real de carga diferida por ruta, con presupuestos de `angular.json` configurados y verificados. | Evidencia presente, con presupuestos configurados pero sin verificar que fallen ante un exceso real. | Solo uno de los dos (evidencia o presupuestos) presente. | No presenta ninguno de los dos. | |
| 2. Caché del navegador* | 20 | `Cache-Control` aplicado correctamente a un endpoint de lectura real, verificado en el navegador. | `Cache-Control` presente, sin verificación clara en el navegador. | `Cache-Control` aplicado a un endpoint de escritura, o mal configurado. | No presenta `Cache-Control` en ningún endpoint. | |
| 3. Decisión sobre Redis* | 20 | Medición real presentada, con decisión (implementado o descartado) claramente justificada por esa medición. | Medición presente, con justificación parcial de la decisión. | Decisión presentada sin medición real que la respalde. | No presenta medición ni decisión sobre Redis. | |
| 4. Logging y Actuator por perfil* | 20 | Niveles de log distintos por perfil verificados, y `/actuator/env` devolviendo `404` en `prod`, con evidencia real. | Ambos presentes, con verificación parcial de alguno. | Solo uno de los dos (logging o Actuator) ajustado. | No ajusta logging ni Actuator por perfil. | |
| 5. Configuración de producción* | 20 | `application-prod.yml`/`environment.prod.ts` completos, sin secretos en el código, con el build de producción corriendo de punta a punta. | Configuración presente, con el build corriendo pero algún secreto o detalle mal resuelto. | Configuración incompleta, o build de producción sin verificar de punta a punta. | No presenta configuración de producción. | |

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

**Resumen breve:** hoy BomERP pasó de "funciona en mi laptop" a tener una configuración de producción real y medida — Lazy Loading confirmado con evidencia (no asumido), un presupuesto que impide que un bundle crezca sin control, `Cache-Control` aplicado donde corresponde, una decisión documentada sobre Redis, logging y Actuator ajustados por perfil, y `application-prod.yml`/`environment.prod.ts` sin ningún secreto expuesto en el código.

**Dinámica participativa:** en una ronda rápida, cada estudiante comparte en una frase qué decisión de esta sesión (Redis, Cache-Control, Actuator) midió en vez de asumir, y qué encontró.

**Metacognición:** cada estudiante responde el Anexo de feedback de la sesión, incluido en su evidencia individual (ver 4.3.1). El docente analiza esas respuestas con IA para identificar temas recurrentes o dudas comunes del equipo, y con esos indicadores construye el cierre real de la sesión — que se entrega al inicio de S14, no al final de esta clase.

**Proyección:** S14 retoma el sistema ya preparado para producción de hoy y lo lleva a integración y estabilización completa: paginación de listados de alto volumen, integración funcional de todos los módulos, auditoría, pruebas end-to-end y corrección de errores — el paso previo directo a la sustentación de Unidad III (S15-S16).

## Bibliografía

1. Angular. (2026a). *Lazy-loading feature modules*. https://angular.dev/guide/ngmodules/lazy-loading
2. Angular. (2026b). *Deferrable Views and Dynamic Imports*. https://angular.dev/guide/defer
3. IETF. (2014). *RFC 7234 — Hypertext Transfer Protocol (HTTP/1.1): Caching*. https://www.rfc-editor.org/rfc/rfc7234
4. Redis Ltd. (2024). *What is Redis?*. https://redis.io/docs/latest/develop/get-started/
5. Spring Boot. (2026a). *Logging — Profile-specific Configuration*. Spring Boot Reference Documentation. https://docs.spring.io/spring-boot/reference/features/logging.html
6. Spring Boot. (2026b). *Production-ready Features — Endpoints*. Spring Boot Reference Documentation. https://docs.spring.io/spring-boot/reference/actuator/endpoints.html
7. Logback. (2024). *Chapter 4: Loggers, Appenders and Layouts*. https://logback.qos.ch/manual/layouts.html
8. Docker Inc. (2024). *Networking — Use host.docker.internal*. Docker Docs. https://docs.docker.com/desktop/features/networking/
