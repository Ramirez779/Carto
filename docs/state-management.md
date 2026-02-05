# Manejo de estado

Este documento describe cómo se gestiona el estado en **Carto**, así como las decisiones tomadas para mantener una arquitectura clara, predecible y escalable.

El manejo de estado se diseñó con el objetivo de separar la lógica de negocio de la interfaz de usuario y facilitar la evolución futura del proyecto.

---

## Enfoque general

Carto utiliza un enfoque de **estado centralizado** basado en providers, lo que permite:

- Compartir estado entre múltiples pantallas  
- Evitar lógica de negocio dentro de la UI  
- Mantener flujos de datos claros y predecibles  
- Facilitar pruebas y mantenimiento  

Las pantallas se limitan a consumir y reaccionar al estado, sin modificar directamente la lógica interna.

---

## Uso de Provider

El proyecto utiliza **Provider** como solución de manejo de estado por su:

- Simplicidad  
- Integración nativa con Flutter  
- Baja curva de aprendizaje  
- Adecuación al tamaño del proyecto  

Provider permite notificar automáticamente a la interfaz cuando el estado cambia, manteniendo la UI sincronizada sin lógica adicional.

---

## Providers principales

El estado de la aplicación se divide en providers con responsabilidades bien definidas.

### CartProvider

`CartProvider` se encarga exclusivamente de la lógica relacionada con el carrito de compras.

Responsabilidades principales:

- Almacenar la lista de productos añadidos  
- Controlar cantidades y eliminaciones  
- Calcular el total del carrito  
- Notificar cambios a la UI  

Gracias a esta separación, pantallas como `CartScreen` y `CheckoutScreen` se enfocan únicamente en renderizar información.

---

### UserProvider

`UserProvider` gestiona la información básica del usuario a nivel local.

Responsabilidades principales:

- Almacenar nombre y correo electrónico  
- Gestionar imagen de perfil  
- Mantener preferencias básicas del usuario  
- Sincronizar datos persistidos con la UI  

Este provider simula un perfil de usuario realista sin depender de un backend.

---

## Flujo de datos

El flujo de datos en Carto es **unidireccional**:

1. La UI dispara una acción  
2. El provider actualiza el estado  
3. Se notifica a los widgets escuchando cambios  
4. La UI se reconstruye con el nuevo estado  

Este enfoque reduce efectos secundarios y hace que el comportamiento de la aplicación sea más fácil de entender.

---

## Persistencia y estado

Algunos providers integran persistencia local para mantener el estado entre sesiones.

- El estado persistido se carga al iniciar la aplicación  
- Los cambios se guardan automáticamente  
- La UI se mantiene sincronizada con los datos locales  

La lógica de persistencia está encapsulada dentro de los providers, evitando que la interfaz conozca detalles de almacenamiento.

---

## Escalabilidad

El sistema de manejo de estado fue diseñado para escalar sin fricción:

- Es posible agregar nuevos providers sin afectar los existentes  
- Puede migrarse a soluciones más complejas si el proyecto crece  
- La UI no requiere cambios al modificar la lógica interna  

Esto permite que Carto evolucione hacia una aplicación con backend real manteniendo una base sólida.

---

## Alcance actual

El manejo de estado en Carto está enfocado en:

- Flujos principales de una app de compras  
- Simulación realista de comportamiento de e-commerce  
- Buenas prácticas de arquitectura en Flutter  

No se implementan soluciones complejas de sincronización ni estados distribuidos, ya que el objetivo principal del proyecto es el diseño, la experiencia de usuario y la estructura del código.