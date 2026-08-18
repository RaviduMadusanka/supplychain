package com.globaltrade.ejb;

import com.globaltrade.core.entity.User;
import com.globaltrade.core.entity.Role;
import com.globaltrade.core.entity.AccountStatus;
import com.globaltrade.core.util.PasswordUtil;
import jakarta.annotation.PostConstruct;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.logging.Logger;

@Singleton
@Startup
public class DataInitializer {

    private static final Logger logger = Logger.getLogger(DataInitializer.class.getName());

    @PersistenceContext(unitName = "SupplyChainPU")
    private EntityManager em;

    @PostConstruct
    public void init() {
        logger.info("Initializing Default Users...");
        createUserIfNotFound("admin01", "ADMIN", "System Admin", "admin@nextrade.com");
        createUserIfNotFound("whmgr01", "WAREHOUSE_MANAGER", "Warehouse Manager", "whmgr@nextrade.com");
        createUserIfNotFound("vendor01", "VENDOR", "Apex Tech Components", "vendor@nextrade.com");
        createUserIfNotFound("cust01", "CUSTOMER", "Colombo Retail Hub", "customer@nextrade.com");
    }

    private void createUserIfNotFound(String username, String roleName, String fullName, String email) {
        long count = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.username = :username", Long.class)
                .setParameter("username", username)
                .getSingleResult();

        if (count == 0) {
            Role role;
            try {
                role = em.createQuery("SELECT r FROM Role r WHERE r.name = :name", Role.class)
                        .setParameter("name", roleName)
                        .getSingleResult();
            } catch (Exception e) {
                role = new Role();
                role.setName(roleName);
                em.persist(role);
            }
            
            AccountStatus status;
            try {
                status = em.createQuery("SELECT a FROM AccountStatus a WHERE a.name = 'ACTIVE'", AccountStatus.class)
                        .getSingleResult();
            } catch (Exception e) {
                status = new AccountStatus();
                status.setName("ACTIVE");
                em.persist(status);
            }

            User user = new User();
            user.setUsername(username);
            user.setPasswordHash(PasswordUtil.hashPassword("pass123")); // Default password for test users
            user.setRole(role);
            user.setFullName(fullName);
            user.setEmail(email);
            user.setStatus(status);
            em.persist(user);
            logger.info("Created user: " + username + " with role " + roleName);
        }
    }
}
