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

public class NexTradeLoginModule implements LoginModule {

    private static final Logger LOGGER = Logger.getLogger(NexTradeLoginModule.class.getName());

    private Subject subject;
    private CallbackHandler callbackHandler;
    private Map<String, ?> sharedState;
    private Map<String, ?> options;

    private boolean loginSucceeded  = false;
    private boolean commitSucceeded = false;

    private String username;
    private String resolvedRole;
    private final List<Principal> addedPrincipals = new ArrayList<>();

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
        Arrays.fill(passwordChars, '\0');

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

    private String authenticateAgainstStore(String username, String password) {
        LOGGER.info("[JAAS] Credential verification invoked for: " + username);
        return null;
    }

    private void clearState() {
        loginSucceeded  = false;
        commitSucceeded = false;
        username        = null;
        resolvedRole    = null;
        addedPrincipals.clear();
    }

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