package org.example.serverlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.modelo.User;
import org.example.servicios.UserServicio;

import java.io.IOException;

@WebServlet("/auth/*")
public class UserServerlet extends HttpServlet {
    private UserServicio userServicio;

    @Override
    public void init() {
        this.userServicio = new UserServicio();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();

        if (action == null || action.equals("/")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        switch (action) {
            case "/login":
                loginUsuario(request, response);
                break;
            case "/registro":
                registroUsuario(request, response);
                break;
            case "/logout":
                logoutUsuario(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void loginUsuario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String correo = request.getParameter("correo");
        String contraseña = request.getParameter("contraseña");

        if (correo == null || correo.isEmpty() || contraseña == null || contraseña.isEmpty()) {
            request.setAttribute("error", "Correo y contraseña son requeridos");
            request.getRequestDispatcher("/WEB-INF/views/login/login.jsp").forward(request, response);
            return;
        }

        User usuario = userServicio.autenticarUsuario(correo, contraseña);

        if (usuario != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("usuario", usuario);
            session.setAttribute("idUsuario", usuario.getIdUsuario());
            session.setAttribute("nombreUsuario", usuario.getNombre());
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        } else {
            request.setAttribute("error", "Correo o contraseña incorrectos");
            request.getRequestDispatcher("/WEB-INF/views/login/login.jsp").forward(request, response);
        }
    }

    private void registroUsuario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nombre = request.getParameter("nombre");
        String correo = request.getParameter("correo");
        String contraseña = request.getParameter("contraseña");
        String confirmarContraseña = request.getParameter("confirmarContraseña");
        String telefono = request.getParameter("telefono");
        String direccion = request.getParameter("direccion");

        // Validaciones
        if (nombre == null || nombre.isEmpty() || correo == null || correo.isEmpty() ||
            contraseña == null || contraseña.isEmpty() || confirmarContraseña == null || confirmarContraseña.isEmpty()) {
            request.setAttribute("error", "Todos los campos son requeridos");
            request.getRequestDispatcher("/WEB-INF/views/login/registro.jsp").forward(request, response);
            return;
        }

        if (!contraseña.equals(confirmarContraseña)) {
            request.setAttribute("error", "Las contraseñas no coinciden");
            request.getRequestDispatcher("/WEB-INF/views/login/registro.jsp").forward(request, response);
            return;
        }

        if (userServicio.existeCorreo(correo)) {
            request.setAttribute("error", "El correo ya está registrado");
            request.getRequestDispatcher("/WEB-INF/views/login/registro.jsp").forward(request, response);
            return;
        }

        User nuevoUsuario = new User();
        nuevoUsuario.setNombre(nombre);
        nuevoUsuario.setCorreo(correo);
        nuevoUsuario.setContraseña(contraseña);
        nuevoUsuario.setTelefono(telefono != null ? telefono : "");
        nuevoUsuario.setDireccion(direccion != null ? direccion : "");

        if (userServicio.registrarUsuario(nuevoUsuario)) {
            request.setAttribute("mensaje", "Registro exitoso. Por favor inicia sesión");
            request.getRequestDispatcher("/WEB-INF/views/login/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Error al registrar el usuario");
            request.getRequestDispatcher("/WEB-INF/views/login/registro.jsp").forward(request, response);
        }
    }

    private void logoutUsuario(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/login");
    }
}
