# obs

Stack de observabilidad de LP2 (BomERP): Prometheus (métricas) + Loki/Promtail
(logs) + Grafana (dashboards), vía Docker Compose. **Opcional para
desarrollo** — no lo necesitas para programar ni para probar
backend/frontend, solo cuando quieras ver métricas o logs agregados del
backend.

**Estado actual:** Grafana trae preconfiguradas las fuentes de datos
Prometheus y Loki (`grafana/provisioning/datasources/datasources.yml`); el
*provider* de dashboards (`grafana/provisioning/dashboards/dashboards.yml`)
ya apunta a una carpeta propia (`BomERP`), pero todavía no tiene ningún
dashboard `.json` cargado — se arman recién cuando una sesión concreta lo
pida.

## Prerrequisitos

- **Docker** — los cuatro servicios corren en contenedores, nada se instala
  en la máquina.
- `bomerp-backend` corriendo (ver [`../bomerp-backend/README.md`](../bomerp-backend/README.md))
  con `/actuator/prometheus` expuesto — si no está arriba, Prometheus
  levanta igual, pero sin datos que mostrar.

## Levantar el ambiente DEV

```bash
docker compose -f compose-dev.yml up -d
```

Crea cuatro contenedores:

| Servicio | Contenedor | Puerto en DEV | Qué hace |
|---|---|---|---|
| Prometheus | `bomerp-prometheus-dev` | `39090` | Recolecta métricas de `bomerp-backend` (`/actuator/prometheus`, cada 15s). |
| Loki | `bomerp-loki-dev` | `33100` | Almacena logs — sin interfaz propia, se consulta desde Grafana. |
| Promtail | `bomerp-promtail-dev` | — (sin puerto expuesto) | Lee los logs de `../bomerp-backend/logs` y los envía a Loki. |
| Grafana | `bomerp-grafana-dev` | `33000` | Dashboards, usuario `admin` / contraseña `admin` (`GF_SECURITY_ADMIN_PASSWORD`, valor de laptop en texto plano — mismo criterio que el resto de credenciales DEV, ver `../CLAUDE.md`). |

Prometheus apunta a `host.docker.internal:8080` (el puerto de DEV de
`bomerp-backend`) — `extra_hosts: host.docker.internal:host-gateway` en
`compose-dev.yml` es lo que le permite a un contenedor alcanzar un proceso
que corre directo en la máquina de desarrollo, no en otro contenedor.

## Verificar

- Prometheus: `http://localhost:39090` → **Status → Targets**, el job
  `bomerp-backend` debe aparecer `UP`.
- Grafana: `http://localhost:33000` → **Connections → Data sources**,
  Prometheus y Loki deben responder `OK` al probarlas.
- Loki no tiene interfaz propia: se consulta desde Grafana (**Explore**,
  eligiendo la fuente `Loki`).

## Detener

```bash
docker compose -f compose-dev.yml down
```

Baja solo los cuatro contenedores de `obs` — no afecta a `bomerp-oracle` ni
al backend/frontend, que se detienen por su cuenta (ver sus propios
`README.md`).
