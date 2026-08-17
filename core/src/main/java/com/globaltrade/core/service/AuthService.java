package com.globaltrade.core.service;

import com.globaltrade.core.dto.UserDTO;

public interface AuthService {
    UserDTO authenticate(String username, String plainPassword) throws Exception;
}
