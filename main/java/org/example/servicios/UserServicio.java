package org.example.servicios;

import org.example.dao.UserDAO;
import org.example.modelo.User;

import java.util.List;

public class UserServicio implements IUserServicio {
    private UserDAO userDAO;

    public UserServicio() {
        this.userDAO = new UserDAO();
    }

    @Override
    public boolean registrarUsuario(User usuario) {
        // Validar que el usuario no existe
        if (userDAO.existeCorreo(usuario.getCorreo())) {
            return false;
        }
        return userDAO.registrarUsuario(usuario);
    }

    @Override
    public User autenticarUsuario(String correo, String contraseña) {
        return userDAO.obtenerUsuarioPorCorreoYContraseña(correo, contraseña);
    }

    @Override
    public User obtenerUsuarioPorId(int idUsuario) {
        return userDAO.obtenerUsuarioPorId(idUsuario);
    }

    @Override
    public boolean existeCorreo(String correo) {
        return userDAO.existeCorreo(correo);
    }

    @Override
    public List<User> obtenerTodosLosUsuarios() {
        return userDAO.obtenerTodosLosUsuarios();
    }

    @Override
    public boolean actualizarUsuario(User usuario) {
        return userDAO.actualizarUsuario(usuario);
    }

    @Override
    public boolean eliminarUsuario(int idUsuario) {
        return userDAO.eliminarUsuario(idUsuario);
    }
}
