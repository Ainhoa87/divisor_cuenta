<!--
Sync Impact Report
- Version change: plantilla sin versión → 1.0.0 (constitución inicial).
- Principios añadidos: Calidad de código, Arquitectura, Seguridad, Calidad y pruebas, Regla de la materia.
- Secciones añadidas: Alcance del proyecto, Estándares del proyecto.
- Secciones eliminadas: ninguna.
- Pendiente: confirmar la fecha original de ratificación.
-->

# Constitución de Divisor Cuenta

## Principios fundamentales

### I. Calidad de código: SOLID
El código MUST respetar SOLID. SRP: cada clase tendrá una sola razón de cambio; el cálculo
no validará ni formateará. OCP: agregar una regla de redondeo no requerirá editar las
clases existentes. LSP: cualquier implementación de una interfaz podrá sustituir a otra
sin que quien la use tenga que identificar su tipo. ISP: las interfaces serán pequeñas y
ningún consumidor dependerá de métodos que no use. DIP: presentation dependerá de
abstracciones de domain y nunca de clases concretas de data.

### II. Arquitectura
El código se organizará en las capas `presentation`, `domain` y `data`, con dependencias
`presentation -> domain <- data`. `lib/domain/` será Dart puro y no importará
`package:flutter`. `main.dart` será el único lugar donde se instancien implementaciones
concretas.

### III. Seguridad
Nunca se guardarán secretos ni API keys en el repositorio.

### IV. Calidad y pruebas
Toda funcionalidad crítica tendrá pruebas. Los criterios de aceptación de cada spec se
convertirán en pruebas ejecutables.

### V. Regla de la materia
El estudiante deberá poder explicar cada función generada por el agente: qué hace, por
qué existe, qué recibe, qué devuelve y qué errores produce.

## Alcance del proyecto

La aplicación es una app Flutter de una sola pantalla para dividir una cuenta.

## Estándares del proyecto

El código usará null safety, nombres en español y no agregará paquetes externos.

## Gobernanza

Esta constitución guía las decisiones de implementación del proyecto. Toda enmienda se
registrará aquí y actualizará la versión: MAJOR para cambios incompatibles en los
principios, MINOR para agregar o ampliar principios y PATCH para aclaraciones sin cambio
de significado. En cada revisión de cambios se comprobará su conformidad con estos
principios y se revisarán las pruebas ejecutables correspondientes.

**Versión**: 1.0.0 | **Ratificada**: TODO(RATIFICATION_DATE): fecha original desconocida | **Última modificación**: 2026-10-06
