package com.example.invoiceapp.db;

import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

final public class DatabaseManager {
    private static DatabaseManager instance;
    private final String url;
    private final String user;
    private final String password;

    private DatabaseManager() {
        try (InputStream in = getClass().getResourceAsStream("/db.properties")) {
            Properties p = new Properties();
            p.load(in);
            url = p.getProperty("db.url").trim();
            user = p.getProperty("db.user").trim();
            password = p.getProperty("db.password").trim();
        } catch (Exception e) {
            throw new RuntimeException("Unable to load DB properties", e);
        }
    }

    public static synchronized DatabaseManager getInstance() {
        if (instance == null)
            instance = new DatabaseManager();
        return instance;
    }

    public Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, user, password);
    }
}
