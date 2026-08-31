# DevOps_equipo-
SIGAS — Sistema de Gestión de Activos para Laboratorio LS5

Documento de Definición de Proyecto — Materia de DevOps

1. Descripción y Uso del Sistema

SIGAS es un Sistema de Gestión de Activos diseñado para centralizar, monitorear y administrar el ciclo de vida de los activos físicos y tecnológicos del laboratorio. El sistema cuenta con:

Interfaces web interactivas
Un panel de administración robusto
Gestión de racks
Un módulo especializado de auditoría mediante códigos QR

Su uso principal es proporcionar una única plataforma para el control de inventario, permitiendo a los equipos:

Localizar equipos rápidamente
Auditar el estado de los mismos en tiempo real
Gestionar mantenimientos de forma eficiente

Todo esto integrando buenas prácticas de despliegue y control de versiones.

2. Público Objetivo
Rol	Uso dentro del sistema
Jefe de laboratorio	Verifica el estado en que se encuentran los equipos
Docentes	Asignan racks y equipos a los estudiantes
Alumnos	Reportan al jefe de laboratorio las condiciones de los equipos, para que este las coteje en la aplicación y decida poner en mantenimiento o deshabilitar el equipo
3. Objetivo General

Desarrollar, gestionar y desplegar el Sistema de Gestión de Activos (SIGAS) para optimizar el control de inventario y reducir significativamente los tiempos de respuesta de mantenimiento, mediante:

Automatización de auditorías físicas con códigos QR
Centralización de la información en un panel web administrativo
Aplicación de metodologías DevOps para asegurar escalabilidad y disponibilidad del sistema
4. Stack Tecnológico
Capa	Tecnología
Backend	Java
Frontend	HTML5, CSS3, JavaScript (Bootstrap)
Base de datos	MySQL
Servidor	Ubuntu Server (Linux)
API / Librería	Html5Qrcode (activación de cámara del dispositivo)
