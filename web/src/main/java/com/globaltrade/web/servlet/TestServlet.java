package com.globaltrade.web.servlet;

import com.globaltrade.core.service.InventoryService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "TestServlet", urlPatterns = {"/test"})
public class TestServlet extends HttpServlet {

    @EJB
    private InventoryService inventoryService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        out.println("<html><body>");
        out.println("<h2>EJB Injection Test</h2>");

        if (inventoryService != null) {
            out.println("<p style='color:green;'>SUCCESS: InventoryService EJB was successfully injected!</p>");
            out.println("<p>The application is wired correctly to Payara.</p>");

        } else {
            out.println("<p style='color:red;'>FAILED: InventoryService EJB is NULL.</p>");
        }

        out.println("</body></html>");
    }
}
