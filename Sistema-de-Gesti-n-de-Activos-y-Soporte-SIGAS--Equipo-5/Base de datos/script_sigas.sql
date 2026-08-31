-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS sigas_db;
USE sigas_db;

-- 1. Tabla RACK_UBICACION
CREATE TABLE RACK_UBICACION (
    ID_Rack INT PRIMARY KEY AUTO_INCREMENT,
    Nombre_Ubicacion VARCHAR(100) NOT NULL
);

-- 2. Tabla USUARIO
CREATE TABLE USUARIO (
    Matricula_ID VARCHAR(20) PRIMARY KEY,
    Nombre_Completo VARCHAR(150) NOT NULL,
    Correo VARCHAR(100) NOT NULL UNIQUE,
    Contrasena_Hash VARCHAR(255) NOT NULL,
    Rol VARCHAR(50) NOT NULL, -- (Admin, Docente, Alumno)
    Estatus VARCHAR(20) NOT NULL DEFAULT 'Activo'
);

-- 3. Tabla EQUIPO
CREATE TABLE EQUIPO (
    ID_Equipo_QR VARCHAR(50) PRIMARY KEY,
    Num_Serie VARCHAR(100) NOT NULL UNIQUE,
    Marca VARCHAR(100) NOT NULL,
    Modelo VARCHAR(100) NOT NULL,
    Estado VARCHAR(50) NOT NULL, -- (Disponible, En Mantenimiento, Prestado)
    Ultima_Auditoria DATE,
    ID_Rack INT,
    FOREIGN KEY (ID_Rack) REFERENCES RACK_UBICACION(ID_Rack)
);

-- 4. Tabla MATERIAL
CREATE TABLE MATERIAL (
    ID_Material INT PRIMARY KEY AUTO_INCREMENT,
    Nombre_Pieza VARCHAR(100) NOT NULL,
    Descripcion TEXT,
    Cantidad_Stock INT NOT NULL,
    Ultima_Auditoria DATE,
    ID_Rack INT,
    FOREIGN KEY (ID_Rack) REFERENCES RACK_UBICACION(ID_Rack)
);

-- 5. Tabla PRESTAMO
CREATE TABLE PRESTAMO (
    ID_Prestamo INT PRIMARY KEY AUTO_INCREMENT,
    Fecha_Salida DATE NOT NULL,
    Fecha_Limite DATE NOT NULL,
    Fecha_Devolucion DATE,
    Estado_Prestamo VARCHAR(50) NOT NULL,
    Matricula_ID VARCHAR(20),
    ID_Equipo_QR VARCHAR(50),
    FOREIGN KEY (Matricula_ID) REFERENCES USUARIO(Matricula_ID),
    FOREIGN KEY (ID_Equipo_QR) REFERENCES EQUIPO(ID_Equipo_QR)
);

-- 6. Tabla REPORTE_FALLA
CREATE TABLE REPORTE_FALLA (
    ID_Reporte INT PRIMARY KEY AUTO_INCREMENT,
    Descripcion_Dano TEXT NOT NULL,
    Fecha_Reporte DATE NOT NULL,
    Estado_Resolucion VARCHAR(50) NOT NULL,
    ID_Equipo_QR VARCHAR(50),
    ID_Prestamo INT,
    FOREIGN KEY (ID_Equipo_QR) REFERENCES EQUIPO(ID_Equipo_QR),
    FOREIGN KEY (ID_Prestamo) REFERENCES PRESTAMO(ID_Prestamo)
);