package listech.servlet;

import java.io.PrintWriter;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")
public class HelloServlet extends HttpServlet {
  public void doGet (HttpServletRequest req, HttpServletResponse res)
    throws ServletException, IOException {
    PrintWriter out;

    res.setContentType("text/html; charset=UTF8");
    out = res.getWriter();

    out.println("<!DOCTYPE html><html><body>");
    out.println("<head><title>The sum total of multiple of 5 or 7 from 1 to 100</title></head>");
    out.println("<body>");
    
    out.println("<h1>The sum total of multiple of 5 or 7 from 1 to 100</h1>");
    out.println("<p>HelloServlet.java works.</p>");
    out.println("</body></html>");
  }
}