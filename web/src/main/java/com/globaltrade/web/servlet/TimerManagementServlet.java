package com.globaltrade.web.servlet;

import com.globaltrade.core.service.TimerManagementService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(urlPatterns = {"/timers", "/timers/trigger", "/timers/toggle"})
public class TimerManagementServlet extends HttpServlet {

    @EJB
    private TimerManagementService timerService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setAttribute("timerJobs", timerService.getAllTimerJobs());
            req.getRequestDispatcher("/timer-jobs.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to load timer services");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        try {
            if ("/timers/trigger".equals(path)) {
                String jobType = req.getParameter("jobType");
                timerService.triggerJobNow(jobType);
                resp.sendRedirect(req.getContextPath() + "/timers?success="
                        + URLEncoder.encode("Timer job '" + jobType + "' triggered and executed successfully.", StandardCharsets.UTF_8.name()));
                return;
            } else if ("/timers/toggle".equals(path)) {
                Long jobId = Long.parseLong(req.getParameter("jobId"));
                timerService.toggleJobStatus(jobId);
                resp.sendRedirect(req.getContextPath() + "/timers?success="
                        + URLEncoder.encode("Timer job status updated successfully.", StandardCharsets.UTF_8.name()));
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/timers?error="
                    + URLEncoder.encode("Operation failed: " + e.getMessage(), StandardCharsets.UTF_8.name()));
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/timers");
    }
}