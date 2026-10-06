# bitácora

| Criterio | Rama vibe | Rama sdd |
|---|---:|---:|
| Iteraciones (veces que le tuviste que volver a pedir algo) | 1 (corrección de la prueba) | 0 (sin retrabajo en constitución/especificación) |
| Casos de aceptación que cumple (0–6) | Pendiente: no se han definido | 0/6 verificados; implementación pendiente |
| Pruebas automatizadas que pasan | Pendiente: no ejecutadas | No ejecutadas (`flutter test` pendiente) |
| Archivos en `lib/` | 1 | 1 |
| Líneas de código en `lib/` | 179 | 179 (código heredado; sin cambios SDD) |
| ¿`domain/` depende de Flutter? | No aplica: no existe `domain/` | No aplica: no existe `domain/` |
| ¿Existe separación `presentation/domain/data`? | No | No |
| ¿El agente agregó algo que nadie pidió? | No identificado | No se agregaron funciones de app; supuestos de la especificación están documentados |
| ¿Se puede agregar otra estrategia sin modificar el cálculo existente? | No: el cálculo está ligado a la pantalla | No: el cálculo sigue ligado a `lib/main.dart` |

## Registro de actividades — fase SDD

| Hito | Comando registrado | Estado | Criterios, reglas de negocio y notas |
|---|---|---|---|
| Inicialización de Spec Kit | `specify init . --ignore-agent-tools` | Hecho; el usuario indicó PowerShell (`ps`) y agente Codex. `.specify/init-options.json` confirma `ps` y `codex`. | Se inicializó la estructura `.specify/` y la numeración secuencial de funciones. |
| Creación de la Constitución | `/speckit-constitution` | Hecho; `.specify/memory/constitution.md` creada en versión 1.0.0. | Define SOLID, capas `presentation/domain/data`, dominio Dart puro, seguridad, pruebas y la regla de que el estudiante explique el código. La fecha original de ratificación sigue pendiente. |
| Generación de la Especificación | `/speckit-specify` | Hecho; `specs/001-dividir-cuenta/spec.md` creada y lista de calidad completa. | Incluye los 6 escenarios solicitados (4 cálculos y 2 validaciones), además de requisitos offline y casos límite. Reglas: dividir monto más propina; modo exacto muestra 2 decimales; modo hacia arriba eleva el importe individual al entero siguiente; cero personas muestra «Debe haber al menos una persona»; monto inválido muestra «Monto inválido». |
| Verificación de aceptación | `flutter test` | Pendiente; no ejecutado. | Los seis escenarios están especificados, pero 0/6 se han probado o verificado en la implementación. La app SDD todavía requiere el botón «Calcular», selección de redondeo y validaciones. |

### Estado de conectividad

La especificación exige que el cálculo funcione sin conexión a Internet y sin red ni
base de datos. Este requisito está documentado, pero todavía no se ha verificado en una
implementación SDD.
