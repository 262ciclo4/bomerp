# BOM ERP

**Business Operations Management Platform**

BOM ERP es un entorno integrado de desarrollo academico para construir modulos empresariales tipo ERP modular o aplicaciones empresariales con backend, frontend y base de datos.

El proyecto articula la linea curricular:

```text
ADS -> BD2 -> LP2
```

Este repositorio es la plantilla base del proyecto integrador del Ciclo 4. Cada grupo puede clonarlo o crear un repositorio propio a partir de esta estructura para desarrollar su modulo de BOM ERP.

## Alcance Inicial

```text
BOM ERP
|-- Comercial
|-- Inventario
|-- Facturacion
|-- Ventas
|-- Compras
|-- Integraciones
|-- IA
`-- Analitica
```

## Estructura

```text
bomerp/
|-- .github/workflows/  - despliegue automatico a GitHub Pages
|-- ads/                - entregables del curso ADS
|-- bd2/                - entregables del curso BD2
|-- docs/               - documentacion MkDocs para ADS, BD2 y LP2
|-- lp2/                - entregables del curso LP2
|-- overrides/          - personalizacion del tema MkDocs (main.html)
|-- .gitignore
|-- mkdocs.yml          - configuracion del sitio
`-- README.md           - onboarding del proyecto
```

## Documentacion

La documentacion se mantiene en [`docs/`](docs/) y se publica automaticamente con GitHub Actions en la rama `gh-pages`.

El archivo principal del proyecto contiene la integracion curricular del ciclo:

```text
docs/index.md
```

Cada curso tiene su propia seccion:

```text
docs/ads/index.md
docs/bd2/index.md
docs/lp2/index.md
```

## Despliegue

No es necesario compilar la documentacion en local. El workflow ubicado en `.github/workflows/deploy.yml` instala MkDocs en GitHub Actions y ejecuta:

```bash
mkdocs gh-deploy --force
```

Para publicar cambios, basta con subirlos a la rama `main`.

## Uso por Grupos

1. Clonar o crear un repositorio desde esta plantilla.
2. Actualizar el README con el nombre del grupo y modulo asignado.
3. Completar los entregables en `ads/`, `bd2/` y `lp2/`.
4. Mantener la documentacion publica en `docs/`.
5. Publicar GitHub Pages usando el workflow incluido.

## Onboarding Futuro

Mas adelante este README servira como guia de entrada para estudiantes y docentes, incluyendo:

* Vision general del proyecto.
* Separacion de entregables por ADS, BD2 y LP2.
* Instalacion de modulos tecnicos cuando existan.
* Flujo de trabajo por curso y por grupo.
* Convenciones de ramas y entregables.
* Enlaces a documentacion, APIs y base de datos.
