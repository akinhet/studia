package com.example.invoiceapp.dao.jdbc;

import com.example.invoiceapp.Role;
import com.example.invoiceapp.dao.UserDao;
import com.example.invoiceapp.db.DatabaseManager;
import com.example.invoiceapp.model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDaoJdbc implements UserDao {
    private final DatabaseManager db = DatabaseManager.getInstance();

    private static final String INSERT_SQL = "INSERT INTO users(username, hash, role_id) VALUES(?, ?, (SELECT id FROM roles WHERE role = ?))";
    private static final String UPDATE_SQL = "UPDATE users SET username=?, hash=?, role_id=(SELECT id FROM roles WHERE role = ?) WHERE id=?";
    private static final String SELECT_BASE = "SELECT u.id, u.username, u.hash, r.role FROM users u JOIN roles r ON u.role_id = r.id";
    private static final String DELETE_SQL = "DELETE FROM users WHERE id = ?";

    public UserDaoJdbc() {}

    @Override
    public User save(User user) {
        try (Connection conn = db.getConnection()) {
            if (user.getId() == null) {

                try (PreparedStatement ps = conn.prepareStatement(INSERT_SQL, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, user.getUsername());
                    ps.setString(2, user.getHash());
                    ps.setString(3, user.getRole().name());

                    ps.executeUpdate();

                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            user.setId(rs.getInt(1));
                        }
                    }
                }
            } else {

                try (PreparedStatement ps = conn.prepareStatement(UPDATE_SQL)) {
                    ps.setString(1, user.getUsername());
                    ps.setString(2, user.getHash());
                    ps.setString(3, user.getRole().name());
                    ps.setInt(4, user.getId());

                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Błąd podczas zapisywania użytkownika: " + e.getMessage(), e);
        }
        return user;
    }

    @Override
    public User findById(int id) {
        String sql = SELECT_BASE + " WHERE u.id = ?";
        try (Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToUser(rs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    @Override
    public List<User> findByName(String str) {
        List<User> users = new ArrayList<>();
        String sql = SELECT_BASE + " WHERE u.username LIKE ?";

        try (Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + str + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(mapRowToUser(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Błąd podczas wyszukiwania użytkowników: " + e.getMessage(), e);
        }
        return users;
    }

    @Override
    public List<User> findByRole(Role role) {
        List<User> users = new ArrayList<>();

        String sql = SELECT_BASE + " WHERE r.role = ?";

        try (Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, role.name());

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(mapRowToUser(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Błąd podczas filtrowania po roli: " + e.getMessage(), e);
        }
        return users;
    }

    @Override
    public List<User> findAll() {
        List<User> users = new ArrayList<>();
        try (Connection conn = db.getConnection();
                Statement st = conn.createStatement();
                ResultSet rs = st.executeQuery(SELECT_BASE)) {

            while (rs.next()) {
                users.add(mapRowToUser(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return users;
    }

    @Override
    public boolean delete(User user) {
        if (user.getId() == null)
            return false;

        try (Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(DELETE_SQL)) {

            ps.setInt(1, user.getId());
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Błąd podczas usuwania użytkownika: " + e.getMessage(), e);
        }
    }

    @Override
    public User update(User user) {
        if (user.getId() == null)
            return null;

        User oldu = findById(user.getId());
        if (oldu == null)
            return null;

        if (user.getUsername() == null)
            user.setUsername(oldu.getUsername());
        if (user.getHash() == null)
            user.setHash(oldu.getHash());
        if (user.getRole() == null)
            user.setRole(oldu.getRole());

        user = save(user);

        if (user == null)
            return null;
        return user;
    }

    private User mapRowToUser(ResultSet rs) throws SQLException {
        return new User(
                rs.getInt("id"),
                rs.getString("username"),
                rs.getString("hash"),
                Role.valueOf(rs.getString("role"))
        );
    }
}
