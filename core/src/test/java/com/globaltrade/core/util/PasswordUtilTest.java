package com.globaltrade.core.util;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class PasswordUtilTest {

    @Test
    @DisplayName("Should hash password to Base64-encoded SHA-256 string")
    void testHashPassword() {
        String plainPassword = "AdminSecurePassword123!";
        String hash1 = PasswordUtil.hashPassword(plainPassword);

        assertNotNull(hash1, "Hash should not be null");
        assertEquals(44, hash1.length(), "SHA-256 Base64 hash must be exactly 44 characters long");

        String hash2 = PasswordUtil.hashPassword(plainPassword);
        assertEquals(hash1, hash2, "Identical plain text passwords must generate matching hashes");
    }

    @Test
    @DisplayName("Should verify correct password matches stored hash")
    void testVerifyPasswordSuccess() {
        String password = "SecretWarehousePassword@2026";
        String hashed = PasswordUtil.hashPassword(password);

        boolean isValid = PasswordUtil.verifyPassword(password, hashed);
        assertTrue(isValid, "Verification must succeed for correct password");

        boolean checkValid = PasswordUtil.checkPassword(password, hashed);
        assertTrue(checkValid, "checkPassword must also succeed");
    }

    @Test
    @DisplayName("Should reject incorrect password against stored hash")
    void testVerifyPasswordFailure() {
        String originalPassword = "ValidPassword123";
        String wrongPassword = "WrongPassword456";
        String hashed = PasswordUtil.hashPassword(originalPassword);

        boolean isValid = PasswordUtil.verifyPassword(wrongPassword, hashed);
        assertFalse(isValid, "Verification must fail when wrong password is provided");
    }

    @Test
    @DisplayName("Should generate randomized secure passwords with specified length")
    void testGenerateRandomPassword() {
        int length = 12;
        String pwd1 = PasswordUtil.generateRandomPassword(length);
        String pwd2 = PasswordUtil.generateRandomPassword(length);

        assertNotNull(pwd1);
        assertEquals(length, pwd1.length(), "Generated password must match requested length");
        assertNotEquals(pwd1, pwd2, "Two randomly generated passwords should be unique");
    }
}