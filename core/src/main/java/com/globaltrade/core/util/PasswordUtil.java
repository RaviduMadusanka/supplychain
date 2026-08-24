package com.globaltrade.core.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

public class PasswordUtil {

    private static final String CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
    private static final SecureRandom RANDOM = new SecureRandom();

    public static String hashPassword(String plainText) {
        if (plainText == null) {
            throw new IllegalArgumentException("Password cannot be null");
        }
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(plainText.getBytes(StandardCharsets.UTF_8));
            return Base64.getEncoder().encodeToString(hash);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not found", e);
        }
    }

    public static boolean checkPassword(String plainText, String hashedPassword) {
        if (plainText == null || hashedPassword == null) {
            return false;
        }
        String newlyHashed = hashPassword(plainText);
        return newlyHashed.equals(hashedPassword);
    }

    public static boolean verifyPassword(String plainText, String hashedPassword) {
        return checkPassword(plainText, hashedPassword);
    }

    public static String generateRandomPassword(int length) {
        if (length < 6) length = 12;
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            sb.append(CHARACTERS.charAt(RANDOM.nextInt(CHARACTERS.length())));
        }
        return sb.toString();
    }

    public static String generateRandomPassword() {
        return generateRandomPassword(12);
    }
}