package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class AppointmentDAO {
    public void saveAppointment(Appointment appointment) throws SQLException {
        String sql = "INSERT INTO appointments (user_id, date, heure, motif) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, appointment.getUserId());
            stmt.setDate(2, appointment.getDate());
            stmt.setTime(3, appointment.getHeure());
            stmt.setString(4, appointment.getMotif());
            
            stmt.executeUpdate();
        }
    }
}