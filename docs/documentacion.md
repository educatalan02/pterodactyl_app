# **Pterodactyl APP**

## **Datos del Proyecto**

- **Título:** Pterodactyl App
- **Ciclo:** Desarrollo de Aplicaciones Multiplataforma
- **Curso:** 2º DAM
- **Fecha:** 17/06/2024
- **Centro:** IES Segundo de Chomón
![Logo del Centro](chomon.png)

### **Datos del Alumno**

- **Nombre:** Eduardo Catalán Mor
- **Correo electrónico:** educatalan02@gmail.com
  
    
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br><br>

# **Documento Descripción del Proyecto**

### Contexto del Proyecto

La aplicación que he desarrollado está construida utilizando Flutter de Google, una tecnología que permite crear aplicaciones multiplataforma de manera eficiente. Esta aplicación surge como una necesidad, ya que a pesar de que Pterodactyl, una plataforma de hosting de código abierto, ofrece una API para su gestión, actualmente no existe ninguna aplicación activa que permita acceder a esta plataforma desde dispositivos móviles.

He utilizado Visual Studio Code como entorno de desarrollo para construir esta aplicación. La decisión de hacerla de código abierto responde a la idea de hacerla accesible de forma gratuita para todos los usuarios. Con esta aplicación, cualquier persona podrá mantener su servidor de hosting abierto sin preocupaciones, ya que podrá acceder a él desde su dispositivo móvil, independientemente de su ubicación, utilizando redes WiFi o datos móviles.

Sin embargo, es importante destacar que durante la implementación la API de Pterodactyl me enfrenté a ciertas limitaciones. La API de Pterodactyl no está completamente documentada, lo que dificulta su comprensión y utilización al 100%. Aunque teóricamente es posible realizar todas las funciones que Pterodactyl permite a través de su API, su complejidad y falta de documentación han representado un desafío durante el desarrollo.

Durante el proceso de desarrollo, mis investigaciones se centraron principalmente en el uso de websockets para establecer la conexión con la aplicación y acceder a la funcionalidad ofrecida por Pterodactyl.

En resumen, esta aplicación representa un esfuerzo por hacer accesible la gestión de servidores de hosting a través de dispositivos móviles, aunque ha enfrentado desafíos debido a la complejidad y falta de documentación de la API subyacente.

<br>

### **Ámbito y Entorno**

El ámbito de este proyecto se sitúa en el contexto de la gestión de servidores de hosting a través de dispositivos móviles. Con el crecimiento exponencial de la demanda de servicios en la nube y la proliferación de aplicaciones y sitios web, la necesidad de una gestión eficiente de los servidores de hosting se ha vuelto cada vez más crucial. En este entorno, surge la necesidad de una solución que permita a los usuarios acceder y administrar sus servidores desde cualquier lugar y en cualquier momento, utilizando dispositivos móviles.

### **Análisis de la Realidad**

Actualmente, la mayoría de las plataformas de hosting ofrecen interfaces web para la gestión de servidores, lo que limita su accesibilidad y conveniencia. A pesar de que Pterodactyl, una plataforma de hosting de código abierto, proporciona una API para la gestión de servidores, no existe una aplicación móvil activa que permita a los usuarios acceder a esta funcionalidad desde sus dispositivos móviles. Esta brecha en el mercado ha generado la necesidad de una solución que proporcione una experiencia móvil intuitiva y conveniente para la gestión de servidores de hosting.

<br>

### **Solución y Justificación**

La solución propuesta consiste en el desarrollo de una aplicación móvil utilizando Flutter de Google, que permita a los usuarios acceder y administrar sus servidores de hosting a través de dispositivos móviles. Esta aplicación aprovechará la API proporcionada por Pterodactyl para ofrecer una amplia gama de funcionalidades, incluida la gestión de servidores, la monitorización del rendimiento y la configuración de opciones avanzadas.

La justificación de esta solución radica en la necesidad de ofrecer una experiencia de gestión de servidores más conveniente y accesible para los usuarios. Al proporcionar una aplicación móvil dedicada, los usuarios podrán acceder a sus servidores de hosting desde cualquier lugar y en cualquier momento, lo que aumentará su eficiencia y productividad. Además, al ser de código abierto y gratuito para todos, esta aplicación contribuirá a democratizar el acceso a la gestión de servidores de hosting, eliminando barreras de entrada y fomentando la participación en la comunidad de desarrollo.

### **Destinatarios**

Los destinatarios de esta aplicación son cualquier persona o entidad que gestione servidores de hosting a través de la plataforma Pterodactyl y desee acceder a esta funcionalidad desde dispositivos móviles. Esto incluye a administradores de sistemas, desarrolladores web, empresas de alojamiento, y cualquier persona que requiera una gestión remota y conveniente de sus servidores de hosting.


### **Objetivo del Proyecto**

El objetivo principal de este proyecto es proporcionar una solución real y efectiva para aquellos usuarios que deseen o necesiten acceder a la gestión de servidores de hosting a través de una aplicación móvil. Esto incluye tanto a administradores de sistemas y desarrolladores web como a empresas de alojamiento y cualquier otra entidad que requiera una gestión remota y conveniente de sus servidores.

Además, el proyecto tiene como objetivo ofrecer una funcionalidad adicional que permita a los usuarios gestionar servidores de distintos proveedores de paneles Pterodactyl desde la misma aplicación. Esto significa que los usuarios podrán agrupar y gestionar todos sus servidores de hosting, independientemente del proveedor, en una sola interfaz móvil unificada.

En resumen, el objetivo del proyecto es desarrollar una aplicación móvil que proporcione una solución integral para la gestión de servidores de hosting, tanto individualmente como en grupos, desde cualquier lugar y en cualquier momento, a través de dispositivos móviles.

<br><br><br><br><br><br><br><br><br><br>

### **Objetivo del Proyecto en Lengua Extranjera**

En entornos donde el idioma predeterminado no es ni español ni inglés, la proyección del proyecto se centra en garantizar una experiencia de usuario fluida y accesible. Aquí hay algunos aspectos clave de esta proyección:

1. **Idioma Predeterminado en Inglés**: Dado que el inglés es ampliamente utilizado como un idioma común en todo el mundo, se establece como el idioma predeterminado para usuarios cuyo idioma principal no sea ni español ni inglés. Esto asegura que puedan acceder a la aplicación y comprenderla de manera efectiva, incluso si no tienen acceso inmediato a su idioma nativo.

2. **Opción de Cambio de Idioma en Ajustes**: Aunque la aplicación se inicia en el idioma predeterminado del dispositivo, se proporciona una opción en los ajustes para que los usuarios puedan cambiar el idioma a su preferencia. Esto permite una mayor personalización y adaptación a las necesidades individuales de cada usuario.

3. **Consideración de la Usabilidad**: Se prioriza la usabilidad y la accesibilidad en el diseño de la interfaz de usuario para garantizar que los usuarios puedan navegar y utilizar la aplicación de manera intuitiva, independientemente del idioma en el que esté configurada.

4. **Compatibilidad con Diversos Idiomas**: Aunque la aplicación inicialmente se lanza en inglés y español, se prevé la posibilidad de agregar soporte para otros idiomas en futuras actualizaciones, lo que ampliará aún más su accesibilidad y utilidad para una audiencia global diversa.

En resumen, la proyección del proyecto en entornos que no son el español se enfoca en proporcionar una experiencia de usuario inclusiva y adaptable, con el inglés como idioma predeterminado y la opción de cambiar el idioma según las preferencias individuales de los usuarios. Esto asegura que la aplicación pueda ser utilizada eficazmente por una amplia variedad de usuarios en diferentes regiones y con distintos idiomas.
<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>

# **Documento de Acuerdo del Proyecto**

### **Requisitos Funcionales y No Funcionales**
<br>

#### **Requisitos Funcionales**
<br>

 1. Autenticación de Usuario
     - Permite a los usuarios identificarse mediante las API Keys proporcionadas por el panel Pterodactyl.
     - Recuerda las sesiones de autenticación.

 2. Múltiples Usuarios
     - Permite poner varios usuarios/credenciales.
     - Permite poner las credenciales de varias instalaciones pterodactyl a la vez desde la misma app.

 3. Gestión de Consola
     - Permite a los usuarios acceder y enviar comandos a la consola del servidor.
     - Debe mostrar en tiempo real la salida de la consola.
     - Wrapper de Códigos de Escape ANSI
         - Implementa un wrapper que interpreta los códigos de escape ANSI utilizados por Pterodactyl.
         - El wrapper traduce los códigos de colores ANSI a los colores equivalentes en Flutter, permitiendo que la salida de la consola mantenga su formato de colores original cuando se visualiza desde la app.
         - Esta funcionalidad asegura que los colores y estilos de texto utilizados en la consola web se reflejen correctamente en la app, mejorando la experiencia de usuario y facilitando la administración de los servidores.

 4. Gestión de Ficheros
     - Los usuarios pueden navegar por el sistema de archivos del servidor. (No es mediante FTP) 
     - Permite editar y eliminar archivos.
 5. Editor de Ficheros
     - Incluye un editor de ficheros integrado que automáticamente detecta el tipo de archivo (xml,json,yaml, etc.).
     - Dependiendo de la sintaxis del archivo detectado, el editor aplica un esquema de colores predefinido para resaltar la sintaxis de dicho fichero, mejorando la legibilidad y facilitando la edición de los ficheros.

 6. Visualización del Estado del Servidor
     - La aplicación muestra el estado actual del servidor (encendido,apagado).
     - Muestra estadísticas del servidor (CPU & Memoria).
 7. Control del Servidor
     - El usuario puede iniciar,detener y reiniciar el servidor desde la aplicación.
 8. Logs 
     - La aplicación permite al usuario acceder a los logs del servidor mediante el explorador de archivos.
 9.  Gestión de Bases de Datos
     - Permite la visualización de las credenciales de acceso.
   <br><br>
### **Requisitos NO Funcionales**
1. Gestión de ficheros
    - No permite descargar ficheros.
    - No permite operaciones bulk/múltiples.
2. Gestión de Bases de Datos
    - No permite la gestión de la base de datos.
3. Gestión de Schedules
    - No permite la gestión de Schedules/Programaciones.
4. Gestión de Parámetros de Inicio
    - No permite cambiar los parámetros de inicio del servidor.
  
<br><br><br>

### **Tareas**
<br>

#### **Fase de Análisis y Planificación**

  1. Revisión de Requisitos
    - Investigación sobre Pterodactyl y su API.
  2. Definición de Funcionalidades
    -  Edición de ficheros.
    -  Autenticación mediante API KEYS.
    -  Permite múltiples API KEYS (incluído diferentes instalaciones).
    -  Consola en vivo y usable.
    -  Visualización de directorios y ficheros.
    -  Eliminación de ficheros.
    -  Reiniciar/Iniciar el servidor.
    -  Multi lenguaje.
    -  Modo oscuro y modo claro.
<br>

#### **Fase de Desarrollo**
   3. Configuración  del Entorno de Desarrollo
       - Instalación y configuración de Android Studio, Flutter y Visual Studio Code.
       - Configuración de GIT & Github para controlar las versiones.
   4. Desarrollo de la conexión con la API
        - Implementación de métodos para autenticarse y realizar operaciones básicas con la API de Pterodactyl.
        - Pruebas iniciales de conectividad.
   5. Implementación de Funcionalidades Principales
        - Gestión de Consola:
            - Desarrollo del Wrapper para códigos de escape ANSI.
            - Traducción de colores ANSI a colores de Flutter.
            - Uso de Websockets para recibir la consola en tiempo real.
        - Gestión de Archivos:
            - Navegación por el sistema de archivos del servidor.
            - Implementación de operaciones CRUD (actualizar, leer, eliminar) en ficheros.
        - Control del Servidor:
            - Funcionalidades para iniciar, detener y reiniciar el servidor. 
   6. Implementación del Editor de Ficheros
        - Detección automática del tipo de archivo (XML, JSON, YAML, ETC...).
        - Aplicación de esquemas de colores predefinidos para la sintaxis.
  <br>
### **Fase de Pruebas**

   1. Desarrollo de Pruebas Unitarias:
        - Pruebas específicas para verificar la correcta funcionalidad de la conexión con la API de Pterodactyl.
            - Resultado: APTO 
      - 
       


      



### Metodología a Seguir




### Planificación Temporal de Tareas

[Establece un cronograma detallado de las tareas y su duración.]

### Presupuesto

[Detalla los gastos, ingresos y beneficios esperados del proyecto.]

### Contrato/Pliego de Condiciones

[Incluye el contrato o las condiciones del proyecto, si los hay.]

### Análisis de Riesgos

[Identifica y analiza los posibles riesgos del proyecto.]

## Documento de Análisis y Diseño

### Modelado de Datos

[Describe el modelado de datos utilizado en tu proyecto.]

### Análisis y Diseño del Sistema Funcional

[Explica el análisis y diseño del sistema funcional de tu proyecto.]

### Análisis y Diseño de la Interfaz de Usuario

[Describe cómo se diseñó la interfaz de usuario de tu proyecto.]

### Diseño de la Arquitectura de la Aplicación

#### Tecnologías/Herramientas Usadas

[Enumera y describe las tecnologías y herramientas utilizadas en tu proyecto.]

#### Arquitectura de Componentes

[Describe la arquitectura de componentes de tu aplicación.]

## Documento de Implementación e Implantación del Sistema

### Implementación

[Detalla cómo se implementó tu proyecto.]

### Pruebas

[Describe las pruebas realizadas y sus resultados.]

## Documento de Cierre

### Documento de Instalación y Configuración

[Instrucciones para instalar y configurar tu proyecto.]

### Manual de Usuario

[Manual detallado para que los usuarios puedan utilizar tu aplicación.]

### Resultados Obtenidos y Conclusiones

[Presenta los resultados obtenidos y las conclusiones de tu proyecto.]

### Diario de Bitácora

[Registra las actividades realizadas durante el desarrollo del proyecto.]

## Bibliografía

[Lista de todas las fuentes consultadas para tu proyecto.]

## Anexos

[Cualquier material adicional que sea relevante para tu proyecto.]
