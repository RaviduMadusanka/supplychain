package com.globaltrade.ejb;

import com.globaltrade.core.service.EmailService;
import jakarta.ejb.Asynchronous;
import jakarta.ejb.Stateless;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

@Stateless
public class EmailServiceBean implements EmailService {

    private static final Logger LOGGER = Logger.getLogger(EmailServiceBean.class.getName());

    private static final String SMTP_USER = "ravidumadusanka338@gmail.com";
    private static final String SMTP_PASS = "h j m h j e m f a i u t s o s z";

    @Asynchronous
    @Override
    public void sendCredentialsEmail(String toEmail, String fullName, String username, String plainPassword) {
        
        String subject = "Welcome to NexTrade SCM - Your Login Credentials";
        String body = String.format(
            "Dear %s,\n\n" +
            "Your account for the NexTrade SCM portal has been created successfully.\n\n" +
            "Please find your login credentials below:\n" +
            "Username: %s\n" +
            "Password: %s\n\n" +
            "For security reasons, please do not share these credentials.\n\n" +
            "Best Regards,\n" +
            "NexTrade System Admin", 
            fullName, username, plainPassword
        );

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USER, SMTP_PASS);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_USER, "NexTrade Admin"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setText(body);
            Transport.send(message);
            LOGGER.info(">>> Email sent successfully to: " + toEmail);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, ">>> Failed to send email to " + toEmail, e);
        }
    }
}