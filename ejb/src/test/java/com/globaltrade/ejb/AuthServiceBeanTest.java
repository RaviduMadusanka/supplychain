package com.globaltrade.ejb;

import com.globaltrade.core.dto.UserDTO;
import com.globaltrade.core.entity.AccountStatus;
import com.globaltrade.core.entity.Role;
import com.globaltrade.core.entity.User;
import com.globaltrade.core.util.PasswordUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class AuthServiceBeanTest {

    @Mock
    private EntityManager em;

    @Mock
    private TypedQuery<User> typedQuery;

    @InjectMocks
    private AuthServiceBean authService;

    @BeforeEach
    void setUp() throws Exception {
        // Inject EntityManager using reflection if needed
        Field emField = AuthServiceBean.class.getDeclaredField("em");
        emField.setAccessible(true);
        emField.set(authService, em);
    }

    @Test
    @DisplayName("Should successfully authenticate active user with valid credentials")
    void testAuthenticateSuccess() throws Exception {
        String username = "admin1";
        String password = "pass123";
        String hashed = PasswordUtil.hashPassword(password);

        User mockUser = new User();
        mockUser.setId(1L);
        mockUser.setUsername(username);
        mockUser.setPasswordHash(hashed);
        mockUser.setFullName("System Administrator");
        mockUser.setEmail("admin@globaltrade.com");

        Role role = new Role();
        role.setId(1L);
        role.setName("ADMIN");
        mockUser.setRole(role);

        AccountStatus status = new AccountStatus();
        status.setName("ACTIVE");
        mockUser.setStatus(status);

        when(em.createQuery(anyString(), eq(User.class))).thenReturn(typedQuery);
        when(typedQuery.setParameter("username", username)).thenReturn(typedQuery);
        when(typedQuery.getResultList()).thenReturn(Collections.singletonList(mockUser));

        UserDTO result = authService.authenticate(username, password);

        assertNotNull(result);
        assertEquals(1L, result.getId());
        assertEquals("admin1", result.getUsername());
        assertEquals("ADMIN", result.getRole());
        assertEquals("ACTIVE", result.getStatus());
    }

    @Test
    @DisplayName("Should throw exception when wrong password is provided")
    void testAuthenticateWrongPassword() {
        String username = "whmgr1";
        String correctPassword = "CorrectPassword123";
        String wrongPassword = "IncorrectPassword456";
        String hashed = PasswordUtil.hashPassword(correctPassword);

        User mockUser = new User();
        mockUser.setId(2L);
        mockUser.setUsername(username);
        mockUser.setPasswordHash(hashed);

        AccountStatus status = new AccountStatus();
        status.setName("ACTIVE");
        mockUser.setStatus(status);

        when(em.createQuery(anyString(), eq(User.class))).thenReturn(typedQuery);
        when(typedQuery.setParameter("username", username)).thenReturn(typedQuery);
        when(typedQuery.getResultList()).thenReturn(Collections.singletonList(mockUser));

        Exception exception = assertThrows(Exception.class, () -> {
            authService.authenticate(username, wrongPassword);
        });

        assertTrue(exception.getMessage().toLowerCase().contains("invalid") || exception.getMessage().toLowerCase().contains("password"));
    }

    @Test
    @DisplayName("Should throw exception when username does not exist")
    void testAuthenticateUserNotFound() {
        String nonExistentUser = "ghost_user";

        when(em.createQuery(anyString(), eq(User.class))).thenReturn(typedQuery);
        when(typedQuery.setParameter("username", nonExistentUser)).thenReturn(typedQuery);
        when(typedQuery.getResultList()).thenReturn(Collections.emptyList());

        Exception exception = assertThrows(Exception.class, () -> {
            authService.authenticate(nonExistentUser, "anyPassword");
        });

        assertNotNull(exception);
    }
}