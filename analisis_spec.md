# Análisis de la Spec y Constitution (SDD - Deber 2)

## 1. Análisis de la Spec (`specs/001-dividir-cuenta/spec.md`)

| Enunciado de la spec | Tipo (QUÉ/CÓMO/MIXTO) | ¿Viaja a React? | Justificación |
| :--- | :--- | :--- | :--- |
| El total se divide entre las personas | QUÉ | Intacto | Regla de negocio independiente del framework |
| El núcleo no importa `package:flutter` | MIXTO | Adaptado | En React se expresa como no importar `react` en el dominio |
| Usar Riverpod para el estado | CÓMO | No viaja | Librería específica de Flutter |

---

## 2. Análisis de la Constitution (`.specify/memory/constitution.md`)

| Regla de la Constitution | Clasificación (idéntica / adaptada en redacción / reemplazada) | Justificación |
| :--- | :--- | :--- |
| Separación en capas (domain, presentation, data) | idéntica | Aplica por igual en Flutter y React |
| No dependencias de UI en el dominio | adaptada en redacción | Cambia la referencia de `package:flutter` a React/HTML |

---

## 3. Porcentaje de decisiones CÓMO en la Spec

* **Total de enunciados analizados:** X
* **Enunciados clasificados como CÓMO:** Y
* **Cálculo:** (Y / X) * 100 = Z%