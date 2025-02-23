package servlet;

import dao.AppointmentDAO;
import dao.UserDAO;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ajouter-rdv")
public class AddAppointmentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String telephone = request.getParameter("telephone");
        Date date = Date.valueOf(request.getParameter("date"));
        Time time = Time.valueOf(request.getParameter("heure") + ":00");
        String motif = request.getParameter("motif");

        try {
            // Save User
            User user = new User(username, email, telephone);
            UserDAO userDAO = new UserDAO();
            int userId = userDAO.saveUser(user);

            // Save Appointment
            Appointment appointment = new Appointment(userId, date, time, motif);
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            appointmentDAO.saveAppointment(appointment);

            response.sendRedirect("index.jsp?success=1");
        } catch (SQLException | IllegalArgumentException e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?error=1");
        }
    }
}