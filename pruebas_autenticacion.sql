-- ============================================
-- SCRIPT DE PRUEBAS - SISTEMA DE AUTENTICACIÓN
-- Cosméticos Mercy JSP - 2025
-- ============================================
use cosmeticos_mercy;
DROP table usuarios;
-- 1. CREAR TABLA (Si no existe)
CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    contraseña VARCHAR(255) NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(255),
    estado VARCHAR(20) DEFAULT 'activo',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_correo (correo),
    INDEX idx_estado (estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. LIMPIAR USUARIOS PREVIOS (Opcional - comentar si no desea borrar)
-- DELETE FROM usuarios;
-- ALTER TABLE usuarios AUTO_INCREMENT = 1;

-- 3. INSERTAR USUARIOS DE PRUEBA
INSERT INTO usuarios (nombre, correo, contraseña, telefono, direccion, estado)
VALUES
    ('Juan García López', 'juan@ejemplo.com', '123456', '+57 312 345 6789', 'Calle 123, Apto 456', 'activo'),
    ('María Rodríguez', 'maria@ejemplo.com', 'password123', '+57 301 234 5678', 'Carrera 50, Apto 200', 'activo'),
    ('Carlos Martínez', 'carlos@ejemplo.com', 'segura2024', '+57 315 789 0123', 'Calle 99, Piso 3', 'activo'),
    ('Ana López', 'ana@ejemplo.com', 'mipass456', '+57 323 456 7890', 'Avenida Principal 100', 'activo'),
    ('Usuario Inactivo', 'inactivo@ejemplo.com', 'pass123456', '+57 300 000 0000', 'Dirección Temporal', 'inactivo');

-- 4. VERIFICAR INSERCIONES
SELECT * FROM usuarios;

-- 5. PRUEBAS DE QUERIES

-- a) Verificar login válido
SELECT * FROM usuarios
WHERE correo = 'juan@ejemplo.com'
AND contraseña = '123456'
AND estado = 'activo';

-- b) Verificar login con email incorrecto
SELECT * FROM usuarios
WHERE correo = 'noexiste@ejemplo.com'
AND contraseña = '123456'
AND estado = 'activo';

-- c) Verificar login con contraseña incorrecta
SELECT * FROM usuarios
WHERE correo = 'juan@ejemplo.com'
AND contraseña = 'contraseñaincorrecta'
AND estado = 'activo';

-- d) Verificar usuario inactivo no puede login
SELECT * FROM usuarios
WHERE correo = 'inactivo@ejemplo.com'
AND contraseña = 'pass123456'
AND estado = 'activo';

-- e) Verificar si email existe
SELECT COUNT(*) FROM usuarios WHERE correo = 'juan@ejemplo.com';

-- f) Obtener usuario por ID
SELECT * FROM usuarios WHERE id_usuario = 1;

-- g) Obtener todos los usuarios activos
SELECT * FROM usuarios WHERE estado = 'activo';

-- h) Contar usuarios activos
SELECT COUNT(*) as total_activos FROM usuarios WHERE estado = 'activo';

-- 6. PRUEBAS DE ACTUALIZACIÓN

-- a) Actualizar datos de usuario
UPDATE usuarios
SET nombre = 'Juan Carlos García',
    telefono = '+57 312 999 8888',
    direccion = 'Calle Nueva 555'
WHERE id_usuario = 1;

-- Verificar actualización
SELECT * FROM usuarios WHERE id_usuario = 1;

-- 7. PRUEBAS DE SOFT DELETE (Cambiar estado a inactivo)

-- a) Desactivar usuario
UPDATE usuarios SET estado = 'inactivo' WHERE id_usuario = 2;

-- Verificar cambio
SELECT * FROM usuarios WHERE id_usuario = 2;

-- b) Reactivar usuario
UPDATE usuarios SET estado = 'activo' WHERE id_usuario = 2;

-- 8. LIMPIAR PRUEBAS (Desactivar usuario de prueba)
UPDATE usuarios SET estado = 'inactivo' WHERE correo = 'ana@ejemplo.com';

-- 9. ESTADÍSTICAS
SELECT
    COUNT(*) as total_usuarios,
    SUM(CASE WHEN estado = 'activo' THEN 1 ELSE 0 END) as usuarios_activos,
    SUM(CASE WHEN estado = 'inactivo' THEN 1 ELSE 0 END) as usuarios_inactivos,
    MIN(fecha_registro) as primer_registro,
    MAX(fecha_registro) as ultimo_registro
FROM usuarios;

-- 10. VALIDAR ESTRUCTURA DE TABLA
DESCRIBE usuarios;

-- 11. MOSTRAR ÍNDICES
SHOW INDEXES FROM usuarios;

-- 12. RESETEAR AUTO_INCREMENT (Si necesario - comentar si no)
-- ALTER TABLE usuarios AUTO_INCREMENT = 1;

-- 13. CONSULTAS ÚTILES PARA DEPURACIÓN

-- a) Buscar por patrón de email
SELECT id_usuario, nombre, correo, estado, fecha_registro
FROM usuarios
WHERE correo LIKE '%@ejemplo.com'
ORDER BY fecha_registro DESC;

-- b) Usuarios registrados en los últimos 7 días
SELECT * FROM usuarios
WHERE fecha_registro >= DATE_SUB(NOW(), INTERVAL 7 DAY)
ORDER BY fecha_registro DESC;

-- c) Listar usuarios ordenados por nombre
SELECT id_usuario, nombre, correo, estado, fecha_registro
FROM usuarios
WHERE estado = 'activo'
ORDER BY nombre ASC;

-- d) Buscar correos duplicados (si existen)
SELECT correo, COUNT(*) as cantidad
FROM usuarios
GROUP BY correo
HAVING COUNT(*) > 1;

-- ============================================
-- NOTAS IMPORTANTES:
-- ============================================
-- 1. Las contraseñas están en texto plano (TEMPORAL)
--    NOTA: En producción usar bcrypt o argon2
-- 2. El estado 'inactivo' es un soft delete
-- 3. Los índices en correo y estado optimizan búsquedas
-- 4. El email tiene constraint UNIQUE
-- 5. fecha_registro es automática (NOW())
-- ============================================
<!--
NOTAS DE IMPLEMENTACIÓN DEL SISTEMA DE AUTENTICACIÓN
Cosméticos Mercy JSP - 2025
-->

## ✅ CARACTERÍSTICAS IMPLEMENTADAS

### 1. Autenticación de Usuarios
- [x] Página de login con validaciones
- [x] Página de registro con confirmación de contraseña
- [x] Sistema de sesiones HTTP
- [x] Filtro de seguridad para proteger vistas
- [x] Logout con invalidación de sesiones

### 2. Validaciones

#### En Registro:
```
✓ Nombre: Requerido, no vacío
✓ Email: Requerido, formato válido, único
✓ Contraseña: Requerido, mínimo 6 caracteres, con indicador de fortaleza
✓ Confirmación: Debe coincidir con contraseña
✓ Teléfono: Opcional
✓ Dirección: Opcional
✓ Términos: Debe aceptar términos y condiciones
```

#### En Login:
```
✓ Email: Requerido, formato válido
✓ Contraseña: Requerido
✓ Verificación en BD: Usuario activo, credenciales válidas
```

### 3. Seguridad
- [x] Sesiones HTTP protegidas
- [x] Filtro de autenticación global
- [x] Soft delete (cambiar estado en lugar de eliminar)
- [x] Email único en BD
- [x] Validación server-side y client-side
- [x] Mensajes de error genéricos para seguridad

### 4. Interfaz de Usuario
- [x] Diseño responsive (móvil, tablet, desktop)
- [x] Gradientes modernos
- [x] Animaciones suaves
- [x] Indicador de fortaleza de contraseña
- [x] Mensajes de error y éxito
- [x] Iconos emoji
- [x] Colores formales y profesionales

## 🔧 CONFIGURACIÓN NECESARIA

### 1. Tabla en Base de Datos
```sql
CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    contraseña VARCHAR(255) NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(255),
    estado VARCHAR(20) DEFAULT 'activo',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_correo (correo),
    INDEX idx_estado (estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### 2. Conexión a Base de Datos
Archivo: `src/main/resources/database.properties`
```properties
db.url=jdbc:mariadb://localhost:3307/cosmeticos_mercy
db.username=root
db.password=Lolsito
db.driver=org.mariadb.jdbc.Driver
```

### 3. Servlets Mapeados
- `GET /login` → Mostrar formulario
- `POST /auth/login` → Procesar login
- `GET /registro` → Mostrar formulario
- `POST /auth/registro` → Procesar registro
- `POST /auth/logout` → Cerrar sesión

## 📁 ESTRUCTURA DE ARCHIVOS

```
src/
├── main/
│   ├── java/org/example/
│   │   ├── modelo/
│   │   │   └── User.java                          ← Modelo de usuario
│   │   ├── dao/
│   │   │   └── UserDAO.java                       ← Acceso a datos
│   │   ├── servicios/
│   │   │   ├── IUserServicio.java                 ← Interfaz servicio
│   │   │   └── UserServicio.java                  ← Implementación
│   │   ├── serverlet/
│   │   │   ├── UserServerlet.java                 ← Controlador auth
│   │   │   ├── LoginViewServerlet.java            ← Servlet /login
│   │   │   └── RegistroViewServerlet.java         ← Servlet /registro
│   │   └── filtros/
│   │       └── AuthenticationFilter.java          ← Filtro de seguridad
│   ├── resources/
│   │   └── database.properties                    ← Config BD
│   └── webapp/
│       └── WEB-INF/views/login/
│           ├── login.jsp                          ← Página de login
│           └── registro.jsp                       ← Página de registro
└── setup_usuarios.sql                             ← Script SQL
```

## 🚀 CÓMO USAR

### Crear Nuevo Usuario
1. Acceder a: `http://localhost:8080/cosmeticosmercyjsp/registro`
2. Llenar formulario:
   - Nombre: Campo de texto
   - Email: Debe ser único
   - Contraseña: Mínimo 6 caracteres
   - Confirmar contraseña: Debe coincidir
   - Teléfono (Opcional)
   - Dirección (Opcional)
3. Aceptar términos y condiciones
4. Hacer click en "Crear Cuenta"

### Iniciar Sesión
1. Acceder a: `http://localhost:8080/cosmeticosmercyjsp/login`
2. Ingresar email y contraseña
3. Opcional: Marcar "Recuérdame"
4. Hacer click en "Iniciar Sesión"

### Cerrar Sesión
1. Hacer click en "Cerrar Sesión" en la navbar
2. Se invalida la sesión
3. Se redirige a login

### Acceder a Páginas Protegidas
- Cualquier intento de acceso sin sesión activa redirige a login
- Las vistas dentro de WEB-INF están protegidas
- Se valida en cada request

## 🔍 EJEMPLO DE FLUJO COMPLETO

```
1. Usuario abre navegador
   ↓
2. Accede a: /cosmeticosmercyjsp/
   ↓
3. Filtro verifica: ¿Hay sesión?
   → NO → Redirige a /login
   → SÍ → Permite acceso
   ↓
4. Usuario hace POST a /auth/login
   ├─ Email: juan@ejemplo.com
   └─ Contraseña: 123456
   ↓
5. UserServerlet procesa:
   ├─ Valida campos
   ├─ Consulta BD: SELECT * FROM usuarios WHERE correo=? AND contraseña=? AND estado='activo'
   ├─ Si encontrado: Crea sesión con datos del usuario
   └─ Si no encontrado: Muestra error
   ↓
6. Si todo OK:
   ├─ session.setAttribute("usuario", usuario)
   ├─ session.setAttribute("nombreUsuario", "Juan García")
   └─ Redirige a /index.jsp
   ↓
7. Filtro permite acceso a /index.jsp
   ↓
8. Usuario ve página con "Bienvenido/a, Juan García"
   ↓
9. Usuario hace logout:
   ├─ POST a /auth/logout
   ├─ session.invalidate()
   └─ Redirige a /login
```

## 💾 DATOS ALMACENADOS EN SESIÓN

```jsp
<%
    // Acceso en JSP:
    String nombreUsuario = (String) session.getAttribute("nombreUsuario");
    int idUsuario = (int) session.getAttribute("idUsuario");
    User usuario = (User) session.getAttribute("usuario");
%>
```

## 🎨 ESTILOS Y DISEÑO

### Paleta de Colores
```css
/* Primario */
--primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);

/* Secundario */
--secondary: #f0f0f0;

/* Texto */
--text-dark: #333333;
--text-muted: #666666;

/* Estados */
--error: #e74c3c;
--success: #27ae60;
--warning: #f39c12;

/* Fondo */
--bg-light: #fafafa;
--bg-border: #e0e0e0;
```

### Componentes
- Input focus: Borde #667eea + sombra púrpura suave
- Botones: Gradiente con sombra y transformación hover
- Mensajes: Borde izquierdo coloreado (4px)
- Transiciones: 0.3s ease

## 🧪 PRUEBAS RECOMENDADAS

### 1. Prueba de Registro
```
✓ Registrar con datos válidos
✓ Intentar registrar con email duplicado
✓ Enviar forma incompleta
✓ Contraseñas que no coinciden
✓ Email con formato inválido
```

### 2. Prueba de Login
```
✓ Login con credenciales correctas
✓ Login con email incorrecto
✓ Login con contraseña incorrecta
✓ Login con campos vacíos
```

### 3. Prueba de Sesión
```
✓ Acceder a página sin sesión → Redirige a login
✓ Iniciar sesión → Acceso permitido
✓ Logout → Sesión invalidada
✓ Timeout sesión (30 min) → Redirige a login
```

## 📝 USUARIO DE PRUEBA

Para pruebas rápidas, ejecutar:
```sql
INSERT INTO usuarios (nombre, correo, contraseña, telefono, direccion, estado)
VALUES ('Usuario Prueba', 'prueba@ejemplo.com', '123456', '+57 312 123 4567', 'Calle 1 #2-3', 'activo');
```

Credenciales:
- Email: `prueba@ejemplo.com`
- Contraseña: `123456`

## ⚠️ CONSIDERACIONES DE SEGURIDAD

### Actual (Implementado)
✅ Sesiones protegidas
✅ Validación server-side
✅ Email único
✅ Soft delete
✅ Filtro de autenticación

### Mejorar a Futuro
⚠️ Hashear contraseñas (bcrypt/argon2)
⚠️ CSRF tokens
⚠️ Rate limiting en login
⚠️ Validación de email
⚠️ HTTPS en producción
⚠️ SQL injection prevention (ya usando PreparedStatement)

## 🐛 TROUBLESHOOTING

### Problema: Error 404 en /login
**Solución:**
- Verificar que LoginViewServerlet compile correctamente
- Limpiar: `mvn clean`
- Recompilar: `mvn compile`

### Problema: No se puede conectar a BD
**Solución:**
- Verificar MariaDB está corriendo
- Verificar credenciales en database.properties
- Verificar tabla usuarios existe

### Problema: Sesión no persiste
**Solución:**
- Verificar que AuthenticationFilter está en web.xml
- Verificar cookies habilitadas en navegador
- Revisar timeout en web.xml

### Problema: Contraseña no funciona
**Solución:**
- Verificar que se almacena en texto plano (actual implementación)
- Comparar exactamente como se envía vs se almacena
- Revisar encoding en base de datos (UTF-8)

## 📞 SOPORTE

Para reportar issues o sugerencias, contactar al equipo de desarrollo.

---
Documento actualizado: Noviembre 2025

