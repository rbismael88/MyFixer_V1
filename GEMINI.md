# Resumen del Proyecto

**Instrucciones para Gemini:**
*   Recuerda siempre que debes responderme todo en español.
*   Recuerda que siempre debes utilizar el modelo gemini-2.5-pro por default.

---

Esta es una aplicación full-stack que consiste en un backend de Django y un frontend de Flutter. El proyecto parece ser un mercado de servicios llamado "MyFixer" donde los clientes pueden conectarse con proveedores de servicios.

## Backend

El backend es un proyecto de Django que utiliza el Django REST Framework para proporcionar una API RESTful. Incluye características para el registro de usuarios, inicio de sesión, gestión de perfiles, verificación de documentos y autenticación basada en JWT. El proyecto también utiliza Django Channels para la comunicación en tiempo real, probablemente para características como chat o notificaciones.

### Tecnologías Clave

*   **Framework:** Django
*   **API:** Django REST Framework
*   **Autenticación:** JSON Web Tokens (JWT)
*   **Base de Datos:** PostgreSQL
*   **Tiempo Real:** Django Channels
*   **Procesamiento de Imágenes:** Pillow

### Compilación y Ejecución

Para compilar y ejecutar el backend, necesitarás tener instalados Python, Docker y Docker Compose.

1.  **Instalar dependencias:**
    ```bash
    pip install -r requirements.txt
    ```

2.  **Ejecutar la base de datos:**
    ```bash
    docker-compose up -d db
    ```

3.  **Aplicar migraciones:**
    ```bash
    python manage.py migrate
    ```

4.  **Ejecutar el servidor de desarrollo:**
    ```bash
    python manage.py runserver 0.0.0.0:8001
    ```

## Frontend

El frontend es una aplicación de Flutter que proporciona la interfaz de usuario para el servicio MyFixer. Incluye características para la interacción del usuario con la API del backend, como el registro, inicio de sesión y gestión de perfiles.

### Tecnologías Clave

*   **Framework:** Flutter
*   **Cliente HTTP:** http
*   **Selector de Imágenes:** image_picker

### Compilación y Ejecución

Para compilar y ejecutar el frontend, necesitarás tener instalado el SDK de Flutter.

1.  **Instalar dependencias:**
    ```bash
    flutter pub get
    ```

2.  **Ejecutar la aplicación:**
    ```bash
    flutter run
    ```

## Convenciones de Desarrollo

*   El backend sigue una estructura de proyecto estándar de Django, con aplicaciones separadas para `api` y `users`.
*   El frontend sigue una estructura de proyecto estándar de Flutter.
*   El backend utiliza JWT para la autenticación, por lo que el frontend deberá manejar la autenticación basada en tokens.
*   El backend utiliza Django Channels, por lo que el frontend deberá implementar la comunicación WebSocket para las características en tiempo real.