<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión - Cosméticos Mercy</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .container {
            width: 100%;
            max-width: 450px;
        }

        .login-box {
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.25);
            padding: 50px;
            animation: slideIn 0.3s ease-out;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .login-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .login-header .logo-icon {
            font-size: 48px;
            margin-bottom: 15px;
            display: block;
        }

        .login-header h1 {
            color: #333;
            font-size: 32px;
            margin-bottom: 8px;
            font-weight: 700;
        }

        .login-header p {
            color: #666;
            font-size: 15px;
            font-weight: 400;
        }

        .form-group {
            margin-bottom: 22px;
        }

        .form-group label {
            display: block;
            margin-bottom: 10px;
            color: #333;
            font-weight: 600;
            font-size: 14px;
        }

        .form-group input {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            font-size: 14px;
            transition: all 0.3s ease;
            background-color: #fafafa;
        }

        .form-group input:focus {
            outline: none;
            border-color: #667eea;
            background-color: white;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }

        .form-group input::placeholder {
            color: #999;
        }

        .error-message {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            border-left: 4px solid #e74c3c;
            color: #721c24;
            padding: 14px 16px;
            border-radius: 6px;
            margin-bottom: 25px;
            font-size: 14px;
            animation: shake 0.3s ease-in-out;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-10px); }
            75% { transform: translateX(10px); }
        }

        .success-message {
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            border-left: 4px solid #27ae60;
            color: #155724;
            padding: 14px 16px;
            border-radius: 6px;
            margin-bottom: 25px;
            font-size: 14px;
        }

        .remember-forgot {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            font-size: 14px;
        }

        .remember-forgot label {
            margin: 0;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 6px;
            cursor: pointer;
        }

        .remember-forgot input[type="checkbox"] {
            cursor: pointer;
            width: 16px;
            height: 16px;
        }

        .remember-forgot a {
            color: #667eea;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .remember-forgot a:hover {
            color: #764ba2;
            text-decoration: underline;
        }

        .button-group {
            margin-top: 30px;
        }

        button {
            width: 100%;
            padding: 14px 20px;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn-login {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
            margin-bottom: 12px;
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }

        .btn-login:active {
            transform: translateY(0);
        }

        .btn-register {
            background-color: #f0f0f0;
            color: #333;
            border: 2px solid #ddd;
            text-transform: capitalize;
            letter-spacing: 0;
        }

        .btn-register:hover {
            background-color: #e8e8e8;
            border-color: #999;
        }

        .register-link {
            text-align: center;
            margin-top: 30px;
            padding-top: 25px;
            border-top: 1px solid #f0f0f0;
            font-size: 14px;
            color: #666;
        }

        .register-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        .register-link a:hover {
            color: #764ba2;
            text-decoration: underline;
        }

        @media (max-width: 500px) {
            .login-box {
                padding: 30px 20px;
            }

            .login-header h1 {
                font-size: 24px;
            }

            .remember-forgot {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="login-box">
            <div class="login-header">
                <span class="logo-icon">💄</span>
                <h1>Cosméticos Mercy</h1>
                <p>Accede a tu cuenta</p>
            </div>

            <%
                String error = (String) request.getAttribute("error");
                String mensaje = (String) request.getAttribute("mensaje");
            %>

            <% if (error != null && !error.isEmpty()) { %>
                <div class="error-message">
                    ⚠️ <%= error %>
                </div>
            <% } %>

            <% if (mensaje != null && !mensaje.isEmpty()) { %>
                <div class="success-message">
                    ✓ <%= mensaje %>
                </div>
            <% } %>

            <form method="POST" action="${pageContext.request.contextPath}/auth/login">
                <div class="form-group">
                    <label for="correo">Correo Electrónico</label>
                    <input type="email" id="correo" name="correo" required placeholder="tu.correo@ejemplo.com" autofocus>
                </div>

                <div class="form-group">
                    <label for="contraseña">Contraseña</label>
                    <input type="password" id="contraseña" name="contraseña" required placeholder="••••••••">
                </div>

                <div class="remember-forgot">
                    <label for="recordar">
                        <input type="checkbox" id="recordar" name="recordar">
                        Recuérdame
                    </label>
                    <a href="#">¿Olvidaste tu contraseña?</a>
                </div>

                <div class="button-group">
                    <button type="submit" class="btn-login">Iniciar Sesión</button>
                    <button type="button" class="btn-register" onclick="window.location='${pageContext.request.contextPath}/registro'">Crear Cuenta</button>
                </div>
            </form>

            <div class="register-link">
                ¿No tienes cuenta? <a href="${pageContext.request.contextPath}/registro">Regístrate aquí</a>
            </div>
        </div>
    </div>
</body>
</html>



