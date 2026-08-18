package com.globaltrade.ejb;

import com.globaltrade.core.dto.UserDTO;
import com.globaltrade.core.entity.User;
import com.globaltrade.core.util.PasswordUtil;
import com.globaltrade.core.service.AuthService;
import jakarta.ejb.Local;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;

@Stateless
@Local(AuthService.class)
public class AuthServiceBean implements AuthService {

    @PersistenceContext(unitName = "SupplyChainPU")
    private EntityManager em;

    public UserDTO authenticate(String username, String plainPassword) throws Exception {
        try {
            User user = em.createQuery("SELECT u FROM User u WHERE u.username = :username", User.class)
                    .setParameter("username", username)
                    .getSingleResult();

            if (user != null && PasswordUtil.checkPassword(plainPassword, user.getPasswordHash())) {
                if (!"ACTIVE".equals(user.getStatus().getName())) {
                    throw new Exception("Account is not active.");
                }
                return new UserDTO(user.getId(), user.getUsername(), user.getEmail(), user.getFullName(), user.getRole().getName());
            } else {
                throw new Exception("Invalid username or password.");
            }
        } catch (NoResultException e) {
            throw new Exception("Invalid username or password.");
        }
    }
}
