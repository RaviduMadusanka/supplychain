package com.globaltrade.ejb;

import com.globaltrade.core.dto.UserDTO;
import com.globaltrade.core.entity.AccountStatus;
import com.globaltrade.core.entity.Role;
import com.globaltrade.core.entity.User;
import com.globaltrade.core.util.PasswordUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;

import java.lang.reflect.Field;
import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
public class AuthServiceBeanTest {

    @Mock
    private EntityManager em;

    @Mock
    private TypedQuery<User> typedQuery;

    @InjectMocks
    private AuthServiceBean authService;

    @BeforeEach
    void setUp() throws Exception {
        Field emField = AuthServiceBean.class.getDeclaredField("em");
        emField.setAccessible(true);
        emField.set(authService, em);

        when(em.createQuery(anyString(), eq(User.class))).thenReturn(typedQuery);
        when(typedQuery.setParameter(eq("username"), anyString())).thenReturn(typedQuery);
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
        mockUser.setCreatedAt(LocalDateTime.now());

        Role role = new Role();
        role.setId(1L);
        role.setName("ADMIN");
        mockUser.setRole(role);

        AccountStatus status = new AccountStatus();
        status.setName("ACTIVE");
        mockUser.setStatus(status);

        when(typedQuery.getSingleResult()).thenReturn(mockUser);

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

        when(typedQuery.getSingleResult()).thenReturn(mockUser);

        Exception exception = assertThrows(Exception.class, () -> {
            authService.authenticate(username, wrongPassword);
        });

        assertTrue(exception.getMessage().toLowerCase().contains("invalid") || exception.getMessage().toLowerCase().contains("password"));
    }

    @Test
    @DisplayName("Should throw exception when username does not exist")
    void testAuthenticateUserNotFound() {
        String nonExistentUser = "ghost_user";

        when(typedQuery.getSingleResult()).thenThrow(new NoResultException("User not found"));

        Exception exception = assertThrows(Exception.class, () -> {
            authService.authenticate(nonExistentUser, "anyPassword");
        });

        assertNotNull(exception);
        assertTrue(exception.getMessage().toLowerCase().contains("invalid") || exception.getMessage().toLowerCase().contains("password"));
    }
}