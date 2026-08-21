package com.globaltrade.core.service;

import com.globaltrade.core.dto.UserDTO;
import jakarta.ejb.Local;
import java.util.List;

@Local
public interface UserService {
    List<UserDTO> getAllUsers();
    void createUser(String fullName, String email, String roleName) throws Exception;
}