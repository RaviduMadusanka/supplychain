package com.globaltrade.web.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

@WebServlet("/images/*")
public class ImageServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "C:\\Users\\ravid\\Documents\\SupplyChain_Images";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String filename = req.getPathInfo().substring(1);
        File file = new File(UPLOAD_DIR, filename);

        if (file.exists()) {
            resp.setContentType(getServletContext().getMimeType(filename));
            resp.setContentLength((int) file.length());
            Files.copy(file.toPath(), resp.getOutputStream());
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
