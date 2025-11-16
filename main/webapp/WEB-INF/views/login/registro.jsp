<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrarse - Cosméticos Mercy</title>
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
            max-width: 600px;
        }

        .register-box {
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

        .register-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .register-header h1 {
            color: #333;
            font-size: 32px;
            margin-bottom: 8px;
            font-weight: 700;
        }

        .register-header .logo-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }

        .register-header p {
            color: #666;
            font-size: 15px;
            font-weight: 400;
        }

        .form-wrapper {
            width: 100%;
        }

        .form-section {
            margin-bottom: 25px;
        }

        .form-section-title {
            color: #667eea;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f0f0f0;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 15px;
        }

        .form-row.full {
            grid-template-columns: 1fr;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
            font-size: 14px;
        }

        .form-group .required {
            color: #e74c3c;
        }

        .form-group input,
        .form-group textarea {
            padding: 14px 16px;
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.3s ease;
            background-color: #fafafa;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
            background-color: white;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }

        .form-group input::placeholder,
        .form-group textarea::placeholder {
            color: #999;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 90px;
            font-size: 13px;
        }

        .password-strength {
            font-size: 12px;
            color: #666;
            margin-top: 6px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .strength-indicator {
            width: 100%;
            height: 3px;
            background-color: #e0e0e0;
            border-radius: 3px;
            overflow: hidden;
            margin-top: 4px;
        }

        .strength-bar {
            height: 100%;
            width: 0%;
            background-color: #e74c3c;
            transition: all 0.3s ease;
        }

        .strength-bar.medium {
            width: 50%;
            background-color: #f39c12;
        }

        .strength-bar.strong {
            width: 100%;
            background-color: #27ae60;
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

        .terms-agreement {
            background-color: #f8f9fa;
            border: 1px solid #e0e0e0;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 25px;
            font-size: 13px;
            color: #666;
            line-height: 1.6;
        }

        .terms-agreement input[type="checkbox"] {
            margin-right: 8px;
            cursor: pointer;
        }

        .terms-agreement label {
            margin: 0;
            cursor: pointer;
            display: inline;
            font-weight: 400;
        }

        .button-group {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-top: 30px;
        }

        button {
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

        .btn-register {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }

        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }

        .btn-register:active {
            transform: translateY(0);
        }

        .btn-cancel {
            background-color: #f0f0f0;
            color: #333;
            border: 2px solid #ddd;
        }

        .btn-cancel:hover {
            background-color: #e8e8e8;
            border-color: #999;
        }

        .login-link {
            text-align: center;
            margin-top: 25px;
            font-size: 14px;
            color: #666;
            padding-top: 25px;
            border-top: 1px solid #f0f0f0;
        }

        .login-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        .login-link a:hover {
            color: #764ba2;
            text-decoration: underline;
        }

        @media (max-width: 600px) {
            .register-box {
                padding: 30px 20px;
            }

            .form-row {
                grid-template-columns: 1fr;
                gap: 15px;
            }

            .register-header h1 {
                font-size: 24px;
            }

            .button-group {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="register-box">
            <div class="register-header">
                <div class="logo-icon">💄</div>
                <h1>Cosméticos Mercy</h1>
                <p>Crea tu cuenta y comienza a disfrutar de nuestros productos</p>
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

            <form method="POST" action="${pageContext.request.contextPath}/auth/registro" class="form-wrapper">
                <!-- Sección de Información Personal -->
                <div class="form-section">
                    <div class="form-section-title">Información Personal</div>

                    <div class="form-row full">
                        <div class="form-group">
                            <label for="nombre">Nombre Completo <span class="required">*</span></label>
                            <input type="text" id="nombre" name="nombre" required placeholder="Juan García López">
                        </div>
                    </div>

                    <div class="form-row full">
                        <div class="form-group">
                            <label for="correo">Correo Electrónico <span class="required">*</span></label>
                            <input type="email" id="correo" name="correo" required placeholder="tu.correo@ejemplo.com">
                        </div>
                    </div>
                </div>

                <!-- Sección de Seguridad -->
                <div class="form-section">
                    <div class="form-section-title">Seguridad</div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="contraseña">Contraseña <span class="required">*</span></label>
                            <input type="password" id="contraseña" name="contraseña" required placeholder="••••••••" minlength="6">
                            <div class="password-strength">
                                <span>Fortaleza:</span>
                                <div class="strength-indicator">
                                    <div class="strength-bar"></div>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="confirmarContraseña">Confirmar Contraseña <span class="required">*</span></label>
                            <input type="password" id="confirmarContraseña" name="confirmarContraseña" required placeholder="••••••••" minlength="6">
                        </div>
                    </div>
                </div>

                <!-- Sección de Contacto (Opcional) -->
                <div class="form-section">
                    <div class="form-section-title">Información de Contacto (Opcional)</div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="telefono">Teléfono</label>
                            <input type="tel" id="telefono" name="telefono" placeholder="+57 300 123 4567">
                        </div>

                        <div class="form-group">
                            <label for="direccion">Dirección</label>
                            <input type="text" id="direccion" name="direccion" placeholder="Calle 123, Apto 456">
                        </div>
                    </div>
                </div>

                <!-- Términos y Condiciones -->
                <div class="terms-agreement">
                    <label>
                        <input type="checkbox" name="aceptaTerminos" required>
                        Acepto los <a href="#" style="color: #667eea; text-decoration: none;">términos y condiciones</a> y la <a href="#" style="color: #667eea; text-decoration: none;">política de privacidad</a>
                    </label>
                </div>

                <!-- Botones de Acción -->
                <div class="button-group">
                    <button type="submit" class="btn-register">Crear Cuenta</button>
                    <button type="button" class="btn-cancel" onclick="window.location='${pageContext.request.contextPath}/login'">Cancelar</button>
                </div>
            </form>

            <div class="login-link">
                ¿Ya tienes cuenta? <a href="${pageContext.request.contextPath}/login">Inicia sesión aquí</a>
            </div>
        </div>
    </div>

    <script>
        // Mostrar fortaleza de contraseña
        document.getElementById('contraseña').addEventListener('input', function() {
            const password = this.value;
            const strengthBar = this.parentElement.querySelector('.strength-bar');

            if (password.length === 0) {
                strengthBar.className = 'strength-bar';
            } else if (password.length < 8) {
                strengthBar.className = 'strength-bar';
            } else if (password.length < 12 || !/[A-Z]/.test(password) || !/[0-9]/.test(password)) {
                strengthBar.className = 'strength-bar medium';
            } else {
                strengthBar.className = 'strength-bar strong';
            }
        });

        // Validar que las contraseñas coincidan
        document.querySelector('form').addEventListener('submit', function(e) {
            const contraseña = document.getElementById('contraseña').value;
            const confirmar = document.getElementById('confirmarContraseña').value;

            if (contraseña !== confirmar) {
                e.preventDefault();
                alert('Las contraseñas no coinciden. Por favor verifica.');
                document.getElementById('confirmarContraseña').focus();
            }
        });
    </script>
</body>
</html>



