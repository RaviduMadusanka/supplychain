package com.globaltrade.ejb;

import com.globaltrade.core.dto.UserDTO;
import com.globaltrade.core.entity.AccountStatus;
import com.globaltrade.core.entity.Role;
import com.globaltrade.core.entity.User;
import com.globaltrade.core.service.EmailService;
import com.globaltrade.core.service.UserService;
import com.globaltrade.core.util.PasswordUtil;
import com.globaltrade.ejb.interceptor.AuditLogInterceptor;
import jakarta.ejb.EJB;
import jakarta.ejb.Stateless;
import jakarta.interceptor.Interceptors;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.List;

@Stateless
@Interceptors(AuditLogInterceptor.class)
public class UserServiceBean implements UserService {

    @PersistenceContext(unitName = "SupplyChainPU")
    private EntityManager em;

    @EJB
    private EmailService emailService;

    @Override
    public List<UserDTO> getAllUsers() {
        List<User> users = em.createQuery("SELECT u FROM User u LEFT JOIN FETCH u.role LEFT JOIN FETCH u.status ORDER BY u.createdAt DESC", User.class).getResultList();
        List<UserDTO> dtos = new ArrayList<>();
        for (User u : users) {
            String roleName = (u.getRole() != null) ? u.getRole().getName() : "UNKNOWN";
            String statusName = (u.getStatus() != null) ? u.getStatus().getName() : "ACTIVE";
            dtos.add(new UserDTO(
                u.getId(), 
                u.getUsername(), 
                u.getEmail(), 
                u.getFullName(), 
                roleName, 
                statusName, 
                u.getCreatedAt()
            ));
        }
        return dtos;
    }

    @Override
    public void createUser(String fullName, String email, String roleName) throws Exception {
        if (fullName == null || email == null || roleName == null) {
            throw new IllegalArgumentException("Full Name, Email, and Role are required.");
        }

        List<User> existing = em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class)
                                .setParameter("email", email.trim())
                                .getResultList();
        if (!existing.isEmpty()) {
            throw new Exception("Email already registered in the system.");
        }

        Role role;
        try {
            role = em.createQuery("SELECT r FROM Role r WHERE UPPER(r.name) = :name", Role.class)
                     .setParameter("name", roleName.toUpperCase())
                     .getSingleResult();
        } catch (Exception e) {
            throw new Exception("Invalid role selected: " + roleName);
        }

        AccountStatus status;
        try {
            status = em.createQuery("SELECT s FROM AccountStatus s WHERE UPPER(s.name) = 'ACTIVE'", AccountStatus.class)
                       .setMaxResults(1)
                       .getSingleResult();
        } catch (Exception e) {
            status = new AccountStatus();
            status.setName("ACTIVE");
            status.setDescription("Active account");
            em.persist(status);
        }

        String baseUsername = email.split("@")[0].toLowerCase().replaceAll("[^a-z0-9]", "");
        String username = baseUsername;
        int counter = 1;
        while (!em.createQuery("SELECT u FROM User u WHERE u.username = :uname", User.class)
                  .setParameter("uname", username)
                  .getResultList().isEmpty()) {
            username = baseUsername + counter;
            counter++;
        }

        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
        SecureRandom random = new SecureRandom();
        StringBuilder sb = new StringBuilder(8);
        for (int i = 0; i < 8; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        String plainPassword = sb.toString();

        String hashedPassword = PasswordUtil.hashPassword(plainPassword);

        User user = new User();
        user.setFullName(fullName.trim());
        user.setEmail(email.trim());
        user.setUsername(username);
        user.setPasswordHash(hashedPassword);
        user.setRole(role);
        user.setStatus(status);

        em.persist(user);
        em.flush();

        emailService.sendCredentialsEmail(user.getEmail(), user.getFullName(), user.getUsername(), plainPassword);
    }
}