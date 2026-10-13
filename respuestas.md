# Respuestas para la entrega del Deber 3

## Rojo antes de verde 
**¿Qué mensaje de error te mostró flutter test en la Parte 2?**

El mensaje de error fue:
Expected: not null
Actual:<null>

**¿Por qué era importante ver esa prueba fallar antes de escribir el código?**

Si una prueba pasa de la nada antes de escribir el código, no tendría forma de saber si realmente está probando algo útil o si está mal escrita y siempre va a dar verde. Verla fallar con un mensaje claro (Actual: <null>) me demuestra que la prueba es estricta y realmente está detectando la ausencia de la funcionalidad.

El error mostraba que el sistema devolvía null (no rechazaba la propina todavía) en lugar del error esperado. Esto te da la certeza de que la prueba está evaluando exactamente la nueva regla de negocio que querías implementar y no otra cosa.

## Linter vs. IA

**Nombra un aviso que te mostró flutter analyze y un code smell que te señaló la IA.** 

Aviso del linter: Cuando en la terminal mandé un flutter analyze, este mostró un error de que el switch no era exhaustivo con CodigoErrorEntrada.propinaMayorAlCien. Este era esencial para este deber, porque nuestro objetivo era precisamente no permitir que se procesara una propina que sea más del 100% al pago normal.

Code smell señalado por la IA: El método largo y anidado en el build de pantalla_divisor.dart

**¿Por qué el linter no encontró el code smell?**

El linter busca reglas sintácticas y estáticas: Funciona mediante reglas predefinidas estrictas (como variables sin usar, constructores mal declarados, tipos de datos o faltas de sintaxis de Dart), pero no entiende el contexto del negocio ni la arquitectura de la interfaz.

El código funcionaba correctamente: El método build largo y anidado en pantalla_divisor.dart es sintácticamente perfecto para Dart; compila sin errores y cumple con todas las reglas del lenguaje.

El code smell es una cuestión de diseño humano: Detectar que un método es demasiado largo, complejo o difícil de mantener requiere interpretar la legibilidad y las buenas prácticas de ingeniería de software, algo que supera el análisis plano de un linter y requiere la comprensión semántica que aporta la IA (o una revisión humana).

## Tu refactorización

* ¿Qué code smell elegiste, qué cambió en el código y cómo sabes que la app sigue haciendo exactamente lo mismo?

Elegí el método build largo y anidado en el archivo lib/presentation/pantalla_divisor.dart (línea 71), el cual concentraba toda la interfaz de la pantalla en una sola función gigante.

Dividimos con el agente ese gran método build extrayendo secciones de la interfaz en widgets privados más pequeños y específicos (por ejemplo, separando componentes del formulario, campos de entrada y resultados), lo que redujo la complejidad visual y mejoró la legibilidad de la clase sin alterar la estructura general de la vista.

Lo puedo saber porque todas las pruebas automatizadas pasaron en verde (All tests passed!) al correr flutter test después de la refactorización, y el análisis estático (flutter analyze) confirmó que no hay errores ni advertencias (No issues found!). Al no haberse tocado la carpeta de pruebas test/, la lógica de negocio y los contratos originales se mantuvieron intactos, garantizando que el comportamiento funcional de la aplicación es exactamente el mismo.

## Coverage 

* ¿Qué archivo de lib/ tiene el porcentaje más bajo?

El archivo con el porcentaje más bajo es main.dart, el cual registra un 56,3% de cobertura.

* ¿Significa eso que ese archivo tiene errores? Explica.

No. Que un archivo tenga un porcentaje de cobertura bajo no significa que contenga errores, fallos ni código defectuoso. La cobertura de código únicamente indica qué porcentaje de las líneas de código fueron ejecutadas durante la ejecución de las pruebas automatizadas (flutter test).

En el caso particular de main.dart, este archivo contiene el punto de entrada de la aplicación (main() y la inicialización de runApp), código de configuración que muchas veces no se alcanza a ejecutar por completo mediante pruebas unitarias tradicionales, lo cual es completamente normal en los proyectos de Flutter y no implica ningún error de funcionamiento.