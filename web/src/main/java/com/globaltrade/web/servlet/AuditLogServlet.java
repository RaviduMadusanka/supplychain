package com.globaltrade.web.servlet;

import com.globaltrade.core.service.AuditLogService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "AuditLogServlet", urlPatterns = {"/monitoring"})
public class AuditLogServlet extends HttpServlet {

    @EJB
    private AuditLogService auditLogService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setAttribute("auditLogs", auditLogService.getRecentAuditLogs(300));
            req.setAttribute("exceptionLogs", auditLogService.getRecentExceptionLogs(100));
            req.getRequestDispatcher("/monitoring.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to load system monitoring & exception logs");
        }
    }
}