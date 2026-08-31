# Unidad 3 - Producto integrado

## Corte U3

La Unidad 3 consolida el producto final del ciclo. No repite la funcionalidad de U2: demuestra que la aplicación full-stack ya puede ser operada, recuperada, monitoreada, explicada y defendida técnicamente.

## Producto integrado U3

**Base Full-Stack modular de BomERP integrada, optimizada, monitoreada y estabilizada, con diseño técnico final, base Oracle resiliente, evidencias y sustentación técnica.**

Este producto evidencia que el equipo no solo construyó una aplicación funcional, sino que también cerró su diseño técnico, estabilizó el producto, preparó operación básica, documentó evidencias y puede sustentar decisiones de punta a punta.

**BomERP es el ejemplo del docente, no el dominio obligatorio.** Cada sede (Lima, Juliaca, Tarapoto) y cada grupo dentro de una misma sede cierra su propio producto final sobre su propio dominio, declarado desde el [brief.md](../brief.md) de S2. Las secciones siguientes usan los nombres de BomERP solo como referencia concreta; cada equipo los lee en clave de sus propios módulos.

## Productos por curso

| Curso | Producto U3 | Archivo |
|---|---|---|
| ADS | Diseño Técnico Profesional Documentado. | [Producto ADS U3](ads-producto.md) |
| BD2 | Base Oracle operativa, administrada, optimizada, auditada y resiliente. | [Producto BD2 U3](bd2-producto.md) |
| LP2 | Base Full-Stack modular de BomERP: una SPA, una aplicación Spring Boot única (módulos verificados con Spring Modulith) y una base Oracle por esquemas funcionales, optimizadas, monitoreadas y estabilizadas. | [Producto LP2 U3](lp2-producto.md) |
| Integrado | Evidencia final de trazabilidad, operación, pruebas y sustentación. | [Checklist final](checklist-final.md) |

## Integración esperada

```mermaid
flowchart TB
    A[ADS U3<br/>Diseño técnico final, ADRs y trazabilidad]
    B[BD2 U3<br/>Backup, recovery, monitoreo y diagnóstico]
    C[LP2 U3<br/>Base de BomERP optimizada,<br/>monitoreada y estabilizada]
    D[Producto final<br/>Base Full-Stack operable,<br/>resiliente y sustentada]

    A --> D
    B --> D
    C --> D
    A --> C
    B --> C
```

## Evidencia mínima para presentar

- Diseño técnico final con arquitectura, UML, patrones, ADRs y trazabilidad.
- Matriz final ADS-BD2-LP2.
- Evidencia de backup, recovery, monitoreo y diagnóstico Oracle.
- Evidencia LP2 de Lazy Loading o Code Splitting y build optimizado.
- Política de caché del navegador y uso justificado de Redis o justificación técnica de no uso.
- Logs estructurados, endpoint de salud y monitoreo básico.
- Paginación de al menos un listado de alto volumen conservando filtros y ordenamiento.
- Auditoría técnica con usuario, fecha, acción, entidad y cambio relevante.
- Pruebas end-to-end y regresión del flujo principal.
- Bitácora de estabilización y corrección de errores.
- Plan de pruebas funcionales, seguridad, integración y operación.
- Guía de despliegue o ejecución.
- Repositorio con topics, documentación MkDocs o equivalente y evidencias reproducibles.
- Evidencia de un único ejecutable Spring Boot, módulos cohesionados, repositorios privados y dependencias unidireccionales.
- Sustentación técnica con aporte individual.

## Diferencia entre U2 y U3

| Aspecto | Unidad 2 | Unidad 3 |
|---|---|---|
| Enfoque | Integración funcional. | Operación, resiliencia, estabilización y defensa final. |
| ADS | Catálogo UML y patrones. | Diseño técnico final, ADRs y trazabilidad completa. |
| BD2 | Base administrada, optimizada y asegurada. | Base respaldada, recuperable, monitoreada y diagnosticable. |
| LP2 | Una SPA modular segura integrada a una aplicación Spring Boot modular. | Base modular de BomERP optimizada, paginada, auditada, probada, estabilizada y sustentada. |
| Evidencia | Funciona integrado y con control de acceso. | Funciona, se optimiza, se monitorea, se audita, se recupera, se explica y se defiende. |

## Criterios de aprobación U3

| Criterio | Evidencia |
|---|---|
| Trazabilidad final | Requerimiento/diseño, objeto Oracle, endpoint, pantalla y prueba relacionados. |
| Operación Oracle | Backup, recovery, monitoreo, diagnóstico y evidencias. |
| Preparación para producción | Build optimizado, caché, logging, salud, monitoreo y guía de despliegue. |
| Integración y estabilización | Paginación justificada, auditoría, E2E, errores corregidos y resultados documentados. |
| Sustentación | Cada integrante defiende una parte verificable. |
| Reproducibilidad | Repositorio y documentación permiten ejecutar o revisar el producto. |
