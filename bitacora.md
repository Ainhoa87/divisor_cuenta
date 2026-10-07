# bitácora

| Criterio | Rama vibe | Rama sdd |
|---|---:|---:|
| Iteraciones (veces que le tuviste que volver a pedir algo) | 1 (corrección de la prueba) | 0 (sin retrabajo en constitución/especificación/plan) |
| Casos de aceptación que cumple (0–6) | Pendiente: no se han definido | 0/6 verificados; implementación pendiente |
| Pruebas automatizadas que pasan | Pendiente: no ejecutadas | No ejecutadas (`flutter test` pendiente) |
| Archivos en `lib/` | 1 | 1 |
| Líneas de código en `lib/` | 179 | 179 (código heredado; sin cambios SDD) |
| ¿`domain/` depende de Flutter? | No aplica: no existe `domain/` | No aplica: no existe `domain/` |
| ¿Existe separación `presentation/domain/data`? | No | No (definida en el plan; falta implementarla) |
| ¿El agente agregó algo que nadie pidió? | No identificado | No se agregaron funciones de app; el plan concreta la arquitectura solicitada |
| ¿Se puede agregar otra estrategia sin modificar el cálculo existente? | No: el cálculo está ligado a la pantalla | No en el código actual; el diseño lo permite mediante `EstrategiaRedondeo` |

## Registro de actividades — fase SDD

| Hito | Comando registrado | Estado | Criterios, reglas de negocio y notas |
|---|---|---|---|
| Inicialización de Spec Kit | `specify init . --ignore-agent-tools` | Hecho; el usuario indicó PowerShell (`ps`) y agente Codex. `.specify/init-options.json` confirma `ps` y `codex`. | Se inicializó la estructura `.specify/` y la numeración secuencial de funciones. |
| Creación de la Constitución | `/speckit-constitution` | Hecho; `.specify/memory/constitution.md` creada en versión 1.0.0. | Define SOLID, capas `presentation/domain/data`, dominio Dart puro, seguridad, pruebas y la regla de que el estudiante explique el código. La fecha original de ratificación sigue pendiente. |
| Generación de la Especificación | `/speckit-specify` | Hecho; `specs/001-dividir-cuenta/spec.md` creada y lista de calidad completa. | Incluye los 6 escenarios solicitados (4 cálculos y 2 validaciones), además de requisitos offline y casos límite. Reglas: dividir monto más propina; modo exacto muestra 2 decimales; modo hacia arriba eleva el importe individual al entero siguiente; cero personas muestra «Debe haber al menos una persona»; monto inválido muestra «Monto inválido». |
| Aclaración de requisitos | `/speckit-clarify` | Hecho; no se encontraron ambigüedades críticas y no se hicieron preguntas ni cambios a la spec. | Se recomendó avanzar a planificación; las decisiones de redondeo y validación ya estaban expresadas en la especificación. |
| Planificación técnica | `/speckit-plan` | Hecho; plan y artefactos de diseño creados. | Define Flutter estable, estado local con `setState`, capas solicitadas, estrategias de redondeo inyectadas y `main.dart` como composición. No se modificó código, `pubspec.yaml` ni `test/`. Se anotó retirar `cupertino_icons` y `flutter_lints` durante implementación para cumplir “sin paquetes externos”. |
| Desglose de tareas | `/speckit-tasks` | Hecho; `specs/001-dividir-cuenta/tasks.md` contiene 19 tareas en orden de dependencia. | Separadas en Setup, Foundation, US1, US2 y Polish. El MVP es US1. Cuatro tareas de pruebas están planificadas, pero requieren autorización explícita antes de modificar `test/`. No se ejecutó implementación. |
| Verificación de aceptación | `flutter test` | Pendiente; no ejecutado. | Los seis escenarios están especificados, pero 0/6 se han probado o verificado en la implementación. El plan reserva cobertura ejecutable para cálculo, validación, redondeo e interacción de pantalla. |

### Estado de conectividad

La especificación y el plan exigen que el cálculo funcione sin conexión a Internet y sin
red ni base de datos. El diseño mantiene entradas y resultados en memoria; este requisito
todavía no se ha verificado en una implementación SDD.
