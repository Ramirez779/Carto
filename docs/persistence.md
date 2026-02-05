# Persistencia de datos

Este documento describe cómo se implementa la persistencia de datos en **Carto**, así como el alcance y las decisiones tomadas en relación con el almacenamiento local.

La persistencia se utiliza para mejorar la experiencia de usuario y simular el comportamiento de una aplicación real, sin depender de un backend.

---

## Objetivo de la persistencia

La persistencia local en Carto tiene como objetivos principales:

- Conservar información del usuario entre sesiones  
- Evitar reconfiguraciones repetitivas  
- Reforzar la sensación de continuidad en la aplicación  
- Simular flujos reales de una app de e-commerce  

No busca reemplazar un backend, sino servir como una base funcional y educativa.

---

## Información persistida

Actualmente se almacena de forma local información **no sensible**, incluyendo:

- Nombre del usuario  
- Correo electrónico  
- Imagen de perfil  
- Preferencias básicas relacionadas con el perfil  

Estos datos se mantienen incluso después de cerrar y volver a abrir la aplicación.

---

## Alcance y limitaciones

La persistencia está deliberadamente limitada a datos simples:

- No se almacenan credenciales  
- No existe autenticación real  
- No hay sincronización entre dispositivos  
- No se gestionan datos sensibles  

Estas limitaciones forman parte del alcance definido del proyecto.

---

## Implementación general

La persistencia se implementa mediante almacenamiento local del dispositivo.

Características clave:

- Carga automática de datos al iniciar la aplicación  
- Guardado inmediato al producirse cambios  
- Sincronización directa con el estado en memoria  

La lógica de persistencia está encapsulada dentro de providers dedicados, manteniendo la UI desacoplada del almacenamiento.

---

## Relación con el manejo de estado

La persistencia está integrada directamente con el sistema de manejo de estado:

- Los providers actúan como única fuente de verdad  
- La UI consume estado ya sincronizado  
- El almacenamiento no es accesible desde las pantallas  

Esto evita duplicación de lógica y mantiene un flujo de datos claro y controlado.

---

## Escalabilidad

La implementación actual permite evolucionar el proyecto sin cambios estructurales:

- Puede sustituirse por un backend remoto  
- Permite migrar a bases de datos locales más complejas  
- No requiere modificar la interfaz de usuario  

Esto hace que Carto esté preparado para crecer sin comprometer la arquitectura existente.

---

## Enfoque del proyecto

La persistencia en Carto está pensada como:

- Un refuerzo de la experiencia de usuario  
- Una simulación realista de comportamiento de aplicación  
- Una base educativa para buenas prácticas  

Se prioriza la claridad, la simplicidad y la mantenibilidad sobre soluciones complejas o innecesarias.