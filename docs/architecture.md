# Arquitectura del proyecto

Este documento describe la arquitectura general de **Carto** y las decisiones estructurales que permiten mantener el proyecto organizado, mantenible y preparado para escalar.

Aunque Carto es un prototipo enfocado en UI/UX y no cuenta con backend real, su arquitectura está pensada para comportarse como la base de una aplicación de producción.

---

## Enfoque arquitectónico

Carto adopta una arquitectura **modular y desacoplada**, donde cada parte del proyecto tiene una responsabilidad clara y bien definida.

Principios aplicados:

- Separación clara de responsabilidades  
- Bajo acoplamiento entre capas  
- Flujo de datos predecible  
- Código legible y fácil de mantener  
- Preparación para crecimiento futuro  

Se evita la complejidad innecesaria sin sacrificar estructura ni buenas prácticas.

---

## Organización del proyecto

El proyecto se estructura en capas funcionales bien diferenciadas.

### Capa de presentación (UI)

Incluye:

- Screens  
- Widgets reutilizables  

Responsabilidades:

- Renderizar la interfaz  
- Gestionar la navegación  
- Mostrar el estado actual de la aplicación  

Las pantallas no contienen lógica de negocio ni manejo directo del estado.

---

### Manejo de estado y lógica de negocio

Incluye:

- Providers  
- Clases `ChangeNotifier`  

Responsabilidades:

- Mantener el estado global de la aplicación  
- Ejecutar la lógica de negocio  
- Notificar cambios a la UI  

Los providers actúan como la **fuente única de verdad**, manteniendo las pantallas limpias y predecibles.

---

### Modelos de datos

Incluye:

- Models  

Responsabilidades:

- Definir las estructuras de datos  
- Representar entidades como productos, pedidos o perfil  
- Facilitar la comunicación entre capas  

Los modelos son simples y no dependen de la UI ni del estado.

---

### Sistema de diseño y tokens visuales

Incluye:

- Colores  
- Tipografías  
- Espaciados  
- Constantes visuales  

Responsabilidades:

- Centralizar decisiones visuales  
- Mantener coherencia en toda la aplicación  
- Facilitar cambios globales de diseño  

Esto refuerza la consistencia visual y mejora la mantenibilidad.

---

### Persistencia local

Incluye:

- Almacenamiento local del dispositivo  
- Providers con persistencia integrada  

Responsabilidades:

- Guardar información básica del usuario  
- Mantener el estado entre sesiones  
- Simular el comportamiento de una app real  

Esta capa está pensada para ser sustituida fácilmente por un backend o soluciones más avanzadas.

---

## Flujo de datos

El flujo de datos sigue un patrón **unidireccional**:

UI → Provider → Actualización de estado → UI


Este enfoque permite:

- Reducir efectos secundarios  
- Facilitar la depuración  
- Mantener un comportamiento consistente  
- Evitar dependencias circulares  

---

## Escalabilidad y evolución

La arquitectura actual permite:

- Integrar un backend sin modificar la UI  
- Añadir nuevas funcionalidades sin reestructurar el proyecto  
- Introducir pruebas unitarias y de widgets  
- Sustituir o ampliar el manejo de estado si es necesario  

Todo esto sin comprometer la experiencia de usuario ni la claridad del código.

---

## Enfoque final

La arquitectura de **Carto** prioriza:

- Claridad sobre complejidad  
- Organización sobre improvisación  
- Escalabilidad sobre soluciones temporales  

El resultado es una base sólida, comprensible y alineada con buenas prácticas en Flutter, adecuada tanto para aprendizaje, portafolio o evolución hacia una aplicación real.