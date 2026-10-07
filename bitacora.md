# bitácora

| Criterio | Rama vibe | Rama sdd |
|---|---:|---:|
| Iteraciones (veces que le tuviste que volver a pedir algo) | 1 (corrección de la prueba) | 0 |
| Casos de aceptación que cumple (0–6) | Pendiente: no se han definido | 6/6 verificados con pruebas automatizadas |
| Pruebas automatizadas que pasan | Pendiente: no ejecutadas | 14/14 (`flutter test`) |
| Archivos en `lib/` | 1 | 12 |
| Líneas de código en `lib/` | 179 | 504 |
| ¿`domain/` depende de Flutter? | No aplica: no existe `domain/` | No; 0 imports de Flutter |
| ¿Existe separación `presentation/domain/data`? | No | Sí |
| ¿El agente agregó algo que nadie pidió? | No identificado | No identificado; se implementó la app y la cobertura especificada |
| ¿Se puede agregar otra estrategia sin modificar el cálculo existente? | No: el cálculo está ligado a la pantalla | Sí; registro abierto `Map<String, EstrategiaRedondeo>` |

## Registro de actividades — fase SDD

| Hito | Comando registrado | Estado | Criterios, reglas de negocio y notas |
|---|---|---|---|
| Inicialización de Spec Kit | `specify init . --ignore-agent-tools` | Hecho; usuario seleccionó PowerShell (`ps`) y Codex. | Estructura `.specify/` inicializada. |
| Creación de la Constitución | `/speckit-constitution` | Hecho; `.specify/memory/constitution.md` creada. | Define SOLID, capas `presentation/domain/data`, dominio Dart puro, seguridad, pruebas y explicabilidad del código. |
| Generación de la Especificación | `/speckit-specify` | Hecho; `specs/001-dividir-cuenta/spec.md`. | Seis escenarios de aceptación; propina incluida antes de dividir, dos modos de redondeo, mensajes de validación y funcionamiento offline. |
| Aclaración de requisitos | `/speckit-clarify` | Hecho. | No quedaron ambigüedades críticas pendientes. |
| Planificación técnica | `/speckit-plan` | Hecho; plan y artefactos de diseño creados. | Flutter estable, sin paquetes externos, estado local con `setState`, capas solicitadas y `main.dart` como raíz de composición. |
| Desglose de tareas | `/speckit-tasks` | Hecho; `specs/001-dividir-cuenta/tasks.md`. | 19 tareas organizadas por dependencias e historias de usuario. |
| Implementación | `/speckit-implement` | Hecho; tareas T001–T018 completadas. | Implementadas las capas, validación, cálculo, estrategias intercambiables, interfaz de una pantalla y manejo de errores. `flutter analyze` sin hallazgos. `flutter test` pasó 14 pruebas, que cubren los seis escenarios, errores de validación y cálculo con peticiones HTTP bloqueadas. |
| Comprobación manual en modo avión | Paso indicado en `specs/001-dividir-cuenta/quickstart.md` | Pendiente (T019). | La prueba automatizada sustituye el cliente HTTP y confirma que un cálculo válido no necesita crear conexiones. No se ha ejecutado una comprobación manual en un dispositivo en modo avión. |

### Estado de conectividad

La aplicación no incluye dependencias de red ni base de datos; el cálculo y el estado permanecen en memoria. Una prueba widget impide crear clientes HTTP y confirma un cálculo válido sin red. La comprobación manual en modo avión queda pendiente.
