package org.example.servicios;

import org.example.modelo.User;

import java.util.List;

public interface IUserServicio {
    // Registrar nuevo usuario
    boolean registrarUsuario(User usuario);

    // Autenticar usuario (login)
    User autenticarUsuario(String correo, String contraseña);

    // Obtener usuario por ID
    User obtenerUsuarioPorId(int idUsuario);

    // Verificar si correo ya existe
    boolean existeCorreo(String correo);

    // Obtener todos los usuarios
    List<User> obtenerTodosLosUsuarios();

    // Actualizar usuario
    boolean actualizarUsuario(User usuario);

    // Eliminar usuario
    boolean eliminarUsuario(int idUsuario);
}
