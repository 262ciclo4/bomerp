# Análisis y Diseño de Sistemas de Información

**Repositorio:** [262ciclo4/bomerp](https://github.com/262ciclo4/bomerp)

## Propósito del Curso

Diseñar técnicamente sistemas de información empresariales definiendo arquitectura, modelos estructurales y dinámicos, mecanismos de integración y decisiones arquitectónicas, aplicando principios de diseño, patrones de software y buenas prácticas de ingeniería, garantizando mantenibilidad, escalabilidad, interoperabilidad y trazabilidad entre requerimientos, diseño e implementación.

## Producto Final del Curso

**Diseño Técnico Profesional Documentado (Producto Final del Curso)**

Artefacto de referencia para el Proyecto Integrador: [ADS - Producto de Unidad 3](../proyecto-integrador/u3/ads-producto.md).

Incluye:

* Arquitectura modelada mediante C4 o equivalente.
* Diseño estructural aplicando principios SOLID.
* Modelo de dominio documentado.
* Catálogo UML estructural y dinámico.
* Diseño conceptual de APIs REST.
* Diseño de integración con servicios externos.
* Diseño de integración con servicios de IA.
* Aplicación justificada de patrones de diseño.
* Registro de decisiones arquitectónicas (ADRs).
* Trazabilidad entre requerimientos, arquitectura y diseño.
* Base técnica para implementación en BD2 y LP2.

---

# Unidad 1: Arquitectura y Diseño Estructural

## Propósito

Definir la arquitectura del sistema aplicando principios de diseño estructural, modelando mediante C4 u otro enfoque arquitectónico y justificando decisiones técnicas alineadas a los requerimientos del negocio.

## Producto

**Arquitectura documentada mediante vistas arquitectónicas y principios de diseño aplicados.**

Artefacto de referencia para el Proyecto Integrador: [ADS - Producto de Unidad 1](../proyecto-integrador/u1/ads-producto.md).

## Sesiones

### Sesión 1. Fundamentos de Arquitectura de Software

* Rol de la arquitectura.
* Stakeholders.
* Atributos de calidad.
* Relación entre arquitectura y requerimientos.
* Estándar IEEE 42010 (opcional).

### Sesión 2. Modelo C4 y Vistas Arquitectónicas

* C1: Vista de contexto.
* C2: Vista de contenedores.
* C3: Vista de componentes.
* C4: Vista de código.
* Vista de despliegue (opcional).
* Relación entre C4 y UML (opcional).

### Sesión 3. Diseño Estructural y Principios SOLID

* Principios SOLID.
* Cohesión.
* Acoplamiento.
* Modularidad.
* Abstracción.

### Sesión 4. Arquitecturas Modernas

* Monolito modular.
* Arquitectura en capas.
* Arquitectura hexagonal.
* Trade-offs arquitectónicos.
* Microservicios (opcional).
* Clean Architecture (opcional).
* Escalabilidad horizontal (opcional).
* Principio Stateless (opcional).
* Cuándo Domain-Driven Design (DDD) orienta la elección hacia arquitectura hexagonal o Clean Architecture.

### Sesión 5. Evaluación Unidad 1

**Producto U1:** Arquitectura documentada mediante vistas arquitectónicas y principios de diseño aplicados.

---

# Unidad 2: Diseño Dinámico, Modelado UML y Patrones

## Propósito

Modelar la estructura y comportamiento del sistema utilizando UML, aplicando principios de diseño orientado a objetos, patrones de software y mecanismos de integración propios de sistemas empresariales.

## Producto

**Catálogo UML con patrones de diseño e integración aplicados.**

Artefacto de referencia para el Proyecto Integrador: [ADS - Producto de Unidad 2](../proyecto-integrador/u2/ads-producto.md).

## Sesiones

### Sesión 6. Descubrimiento y Modelado del Dominio

* Identificación de entidades.
* Reglas de negocio.
* Agrupación funcional.
* Delimitación de módulos.
* Casos de uso relevantes.
* Objetos de valor (opcional).
* Preparación del modelo conceptual (opcional).
* Diseño estratégico de Domain-Driven Design: lenguaje ubicuo, agregado como límite de consistencia.

### Sesión 7. Diseño de Clases del Dominio

* Entidades persistentes.
* Atributos y operaciones.
* Relaciones y multiplicidades.
* Agregación y composición.
* Herencia.
* Restricciones del modelo (opcional).

### Sesión 8. Diseño de Clases Avanzado y Transformación Objeto-Relacional

* Refinamiento del modelo de clases.
* Transformación UML a modelo relacional.
* Clases, tablas y claves.
* Asociaciones y claves foráneas.
* Trazabilidad dominio, clases y base de datos.
* Estrategias de persistencia de herencia (opcional).

### Sesión 9. Diagramas Dinámicos UML

* Diagramas de secuencia.
* Diagramas de actividades.
* Ciclo de vida de objetos.
* Interacción entre componentes.
* Diagramas de comunicación (opcional).
* Diagramas de estados (opcional).

### Sesión 10. Patrones de Diseño y Arquitectura Empresarial

* Controller Pattern.
* Service Layer Pattern.
* Repository Pattern.
* DTO Pattern.
* Diseño conceptual de APIs REST.
* Contratos Request-Response.
* Mapper Pattern (opcional).
* Dependency Injection (opcional).
* Repository/agregado como patrones tácticos de Domain-Driven Design frente al Service Layer clásico.

### Sesión 11. Integración y Sistemas Empresariales

* Consumo de APIs externas.
* Integración con servicios de terceros.
* Eventos de dominio.
* Publicación y suscripción.
* Integración entre servicios.
* Integración con servicios de IA (opcional).
* Mensajería asíncrona (opcional).
* Introducción a sistemas distribuidos (opcional).
* Patrones de integración empresarial (opcional).

### Sesión 12. Evaluación Unidad 2

**Producto U2:** Catálogo UML con patrones de diseño e integración aplicados.

---

# Unidad 3: Proyecto de Diseño Técnico Profesional

## Propósito

Integrar arquitectura, modelos UML, patrones de diseño, mecanismos de integración y decisiones arquitectónicas en un diseño técnico profesional listo para ser implementado en cursos posteriores.

## Producto

**Diseño Técnico Profesional Documentado (Producto Final del Curso)**

Incluye:

* Arquitectura completa del sistema.
* Modelo de dominio.
* Catálogo UML estructural y dinámico.
* Diseño conceptual de APIs.
* Diseño de integración con servicios externos.
* Diseño de integración con servicios de IA.
* Patrones aplicados.
* ADRs.
* Trazabilidad entre requerimientos, arquitectura, base de datos y diseño.

## Sesiones

### Sesión 13. Integración del Diseño Técnico

* Consolidación de arquitectura.
* Consolidación del modelo de dominio.
* Consolidación de UML.
* Consolidación de patrones.
* Consolidación de integraciones.

### Sesión 14. Decisiones Arquitectónicas y Trazabilidad

* Architectural Decision Records (ADRs).
* Atributos de calidad.
* Justificación técnica de decisiones.
* Trazabilidad entre requerimientos, arquitectura y diseño.

### Sesión 15. Sustentación del Diseño Técnico Profesional

* Exposición del diseño.
* Defensa técnica.
* Justificación arquitectónica.
* Presentación del dossier técnico.

**Producto U3 = Producto Final del Curso**

### Sesión 16. Evaluación Final

* Evaluación individual.
* Recuperación de sustentaciones pendientes.
* Levantamiento de observaciones.
* Cierre académico del proyecto.

---

# Integración Curricular

## Producto Unidad 1

**Arquitectura documentada mediante vistas arquitectónicas y principios de diseño aplicados.**

## Producto Unidad 2

**Catálogo UML con patrones de diseño e integración aplicados.**

## Producto Unidad 3 = Producto Final del Curso

**Diseño Técnico Profesional Documentado**

Este producto servirá como insumo directo para:

## Base de Datos II

* Modelo lógico.
* Modelo físico.
* Procedimientos almacenados.
* Restricciones e integridad.
* Seguridad de datos.
* Optimización y administración.

## Lenguaje de Programación II

* Backend.
* Frontend.
* APIs REST.
* DTOs.
* Servicios.
* Repositorios.
* Integración con servicios externos.
* Integración con servicios de IA.
