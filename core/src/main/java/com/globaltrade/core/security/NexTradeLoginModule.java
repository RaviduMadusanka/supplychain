package com.globaltrade.core.security;

import javax.security.auth.Subject;
import javax.security.auth.callback.*;
import javax.security.auth.login.LoginException;
import javax.security.auth.spi.LoginModule;
import java.security.Principal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * NexTradeLoginModule -- Custom JAAS LoginModule for the NexTrade SCM System.
 *
 * Integrates with the Jakarta EE security architecture by delegating credential
 * verification to the application's own UserRepository. Extracts credentials via
 * the standard JAAS CallbackHandler mechanism, validates them against the application
 * database, and populates the JAAS Subject with application-specific Principal objects.
 *
 * GlassFish 7 Integration:
 *   Register in domain.xml as a custom JAAS realm. See DEPLOYMENT.md for full steps.
 *
 * Architectural Note:
 *   The system currently uses a custom UserContext ThreadLocal + AuthorizationInterceptor
 *   EJB interceptor chain for application-managed security. This NexTradeLoginModule
 *   was implemented to demonstrate JAAS compliance and can be activated as the primary
 *   authentication mechanism by wiring it into the GlassFish JAAS realm configuration.
 *   See DEPLOYMENT.md Section 6 for the architectural decision rationale.
 */
public class NexTradeLoginModule implements LoginModule {

    private static final Logger LOGGER = Logger.getLogger(NexTradeLoginModule.class.getName());

    private Subject subject;
    private CallbackHandler callbackHandler;
    @SuppressWarnings("unused")
    private Map<String, ?> sharedState;
    @SuppressWarnings("unused")
    private Map<String, ?> options;

    private boolean loginSucceeded  = false;
    private boolean commitSucceeded = false;

    private String username;
    private String resolvedRole;
    private final List<Principal> addedPrincipals = new ArrayList<>();

    // --- LoginModule Lifecycle ---

    @Override
    public void initialize(Subject subject, CallbackHandler callbackHandler,
                           Map<String, ?> sharedState, Map<String, ?> options) {
        this.subject         = subject;
        this.callbackHandler = callbackHandler;
        this.sharedState     = sharedState;
        this.options         = options;
        LOGGER.fine("[JAAS] NexTradeLoginModule initialized");
    }

    @Override
    public boolean login() throws LoginException {
        NameCallback     nameCallback = new NameCallback("NexTrade Username: ");
        PasswordCallback passCallback = new PasswordCallback("NexTrade Password: ", false);

        try {
            callbackHandler.handle(new Callback[]{nameCallback, passCallback});
        } catch (Exception e) {
            throw new LoginException("CallbackHandler error: " + e.getMessage());
        }

        username = nameCallback.getName();
        char[] passwordChars = passCallback.getPassword();
        passCallback.clearPassword();

        if (username == null || username.trim().isEmpty()) {
            throw new LoginException("Authentication failed: username must not be blank");
        }
        if (passwordChars == null || passwordChars.length == 0) {
            LOGGER.warning("[JAAS][SECURITY-VIOLATION] Empty password attempt for: " + username);
            throw new LoginException("Authentication failed: password must not be blank");
        }

        String password = new String(passwordChars);
        Arrays.fill(passwordChars, '\0'); // clear from heap

        resolvedRole = authenticateAgainstStore(username, password);

        if (resolvedRole == null) {
            LOGGER.warning("[JAAS][SECURITY-VIOLATION] Authentication FAILED for: " + username);
            loginSucceeded = false;
            throw new LoginException("Authentication failed: invalid credentials for '" + username + "'");
        }

        LOGGER.info("[JAAS] Authentication SUCCEEDED: " + username + " | Role: " + resolvedRole);
        loginSucceeded = true;
        return true;
    }

    @Override
    public boolean commit() throws LoginException {
        if (!loginSucceeded) return false;

        NexTradePrincipal userPrincipal = new NexTradePrincipal(username, "USER");
        NexTradePrincipal rolePrincipal = new NexTradePrincipal(resolvedRole, "ROLE");

        if (!subject.getPrincipals().contains(userPrincipal)) {
            subject.getPrincipals().add(userPrincipal);
            addedPrincipals.add(userPrincipal);
        }
        if (!subject.getPrincipals().contains(rolePrincipal)) {
            subject.getPrincipals().add(rolePrincipal);
            addedPrincipals.add(rolePrincipal);
        }

        LOGGER.info("[JAAS] Subject committed: " + username + " -> " + resolvedRole);
        commitSucceeded = true;
        return true;
    }

    @Override
    public boolean abort() throws LoginException {
        if (!loginSucceeded) return false;
        if (!commitSucceeded) { clearState(); } else { logout(); }
        return true;
    }

    @Override
    public boolean logout() throws LoginException {
        subject.getPrincipals().removeAll(addedPrincipals);
        LOGGER.info("[JAAS] Logout: removed principals for " + username);
        clearState();
        return true;
    }

    // --- Credential Verification ---

    /**
     * Authenticates against the application user store.
     *
     * Full JDBC implementation (for GlassFish JAAS realm activation):
     *
     *   DataSource ds = (DataSource) new InitialContext().lookup("jdbc/SupplyChainDS");
     *   try (Connection conn = ds.getConnection();
     *        PreparedStatement ps = conn.prepareStatement(
     *            "SELECT u.password_hash, r.role_name FROM users u " +
     *            "JOIN roles r ON u.role_id = r.id " +
     *            "WHERE u.username = ? AND u.status_id IN " +
     *            "(SELECT id FROM account_status WHERE name = 'ACTIVE')")) {
     *       ps.setString(1, username);
     *       try (ResultSet rs = ps.executeQuery()) {
     *           if (rs.next()) {
     *               String hash = rs.getString("password_hash");
     *               String role = rs.getString("role_name");
     *               if (PasswordUtil.verifyPassword(password, hash)) {
     *                   return role.toUpperCase();
     *               }
     *           }
     *       }
     *   }
     *   return null;
     *
     * This stub returns null (authentication deferred to application-managed layer).
     * Replace with the JDBC block above to activate full JAAS realm integration.
     */
    private String authenticateAgainstStore(String username, String password) {
        LOGGER.info("[JAAS] Credential verification invoked for: " + username);
        // Wire DataSource here for production JAAS realm activation -- see Javadoc above
        return null;
    }

    private void clearState() {
        loginSucceeded  = false;
        commitSucceeded = false;
        username        = null;
        resolvedRole    = null;
        addedPrincipals.clear();
    }

    // --- Inner Principal ---

    public static final class NexTradePrincipal implements Principal, java.io.Serializable {
        private static final long serialVersionUID = 1L;
        private final String name;
        private final String type;

        public NexTradePrincipal(String name, String type) {
            this.name = name;
            this.type = type;
        }

        @Override public String getName()  { return name; }
        public         String getType()    { return type; }

        @Override
        public boolean equals(Object o) {
            if (!(o instanceof NexTradePrincipal)) return false;
            NexTradePrincipal other = (NexTradePrincipal) o;
            return name.equals(other.name) && type.equals(other.type);
        }

        @Override public int    hashCode() { return 31 * name.hashCode() + type.hashCode(); }
        @Override public String toString() { return "NexTradePrincipal[" + type + "=" + name + "]"; }
    }
}