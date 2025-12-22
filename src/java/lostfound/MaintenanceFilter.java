package lostfound;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebFilter("/*")
public class MaintenanceFilter implements Filter {
/*True= maintenance mode*/
    private static final boolean SITE_UNDER_MAINTENANCE = false;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String uri = req.getRequestURI();

        if (SITE_UNDER_MAINTENANCE && !uri.endsWith("maintenance.jsp")) {
            res.sendRedirect("maintenance.jsp");
            return;
        }

        chain.doFilter(request, response);
    }
}
