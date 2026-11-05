package com.example.invoiceapp;

import com.example.invoiceapp.Role;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;
import org.mindrot.jbcrypt.BCrypt;


public class Authenticator {
    private final Connection connection;
    private final String url;
    private final String user;
    private final String password;

    public Authenticator() {
        try (InputStream in = getClass().getResourceAsStream("/db.properties")) {
            Properties p = new Properties();
            p.load(in);
            url = p.getProperty("auth.url").trim();
            user = p.getProperty("auth.user").trim();
            password = p.getProperty("auth.passwd").trim();
            connection = DriverManager.getConnection(url, user, password);
        } catch (SQLException e) {
            throw new RuntimeException("Unable to connect to database", e);
        } catch (Exception e) {
            throw new RuntimeException("Unable to load DB properties", e);
        }
    }

    public Role getUserRole(String username, String password) {
        String sql = "SELECT r.role, u.hash " +
                     "FROM users u " +
                     "JOIN roles r ON u.role_id = r.id " +
                     "WHERE u.username = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, username);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("hash");
                    String roleName = rs.getString("role");

                    if (BCrypt.checkpw(password, storedHash)) {
                        return Role.valueOf(roleName);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null; 
    }

}
