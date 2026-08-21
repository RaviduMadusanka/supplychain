package com.globaltrade.core.service;

import jakarta.ejb.Local;

@Local
public interface EmailService {
    void sendCredentialsEmail(String toEmail, String fullName, String username, String plainPassword);
}