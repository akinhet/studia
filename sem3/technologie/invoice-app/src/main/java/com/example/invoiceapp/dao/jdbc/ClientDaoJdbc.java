package com.example.invoiceapp.dao.jdbc;

import com.example.invoiceapp.dao.ClientDao;
import com.example.invoiceapp.db.DatabaseManager;
import com.example.invoiceapp.model.Client;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClientDaoJdbc implements ClientDao {
    private final DatabaseManager db = DatabaseManager.getInstance();

    public ClientDaoJdbc() {}

    @Override
    public Client save(Client client) {
        String sqlSelect = "SELECT 1 FROM clients WHERE nip = ?";
        String sqlInsert = "INSERT INTO clients(nip, name, address) VALUES(?,?,?)";
        String sqlUpdate = "UPDATE clients SET name = ?, address = ? WHERE nip = ?";

        try (Connection conn = db.getConnection()) {
            boolean exists = false;
            try (PreparedStatement ps = conn.prepareStatement(sqlSelect)) {
                ps.setString(1, client.getNip());
                try (ResultSet rs = ps.executeQuery()) {
                    exists = rs.next();
                }
            }

            if (!exists) {
                try (PreparedStatement ps = conn.prepareStatement(sqlInsert)) {
                    ps.setString(1, client.getNip());
                    ps.setString(2, client.getName());
                    ps.setString(3, client.getAddress());
                    ps.executeUpdate();
                }
            } else {
                try (PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
                    ps.setString(1, client.getName());
                    ps.setString(2, client.getAddress());
                    ps.setString(3, client.getNip());
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Błąd podczas zapisywania klienta: " + e.getMessage(), e);
        }
        return client;
    }

    @Override
    public Client findByNip(String nip) {
        String sql = "SELECT name, nip, address FROM clients WHERE nip = ?";
        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nip);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return new Client(rs.getString("name"), rs.getString("nip"), rs.getString("address"));
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    @Override
    public List<Client> findByName(String str) {
        List<Client> clients = new ArrayList<>();
        String sql = "SELECT nip, name, address FROM clients WHERE name LIKE ?";

        try (Connection conn = db.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + str + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    clients.add(new Client(rs.getString("name"), rs.getString("nip"), rs.getString("address")));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Błąd podczas wyszukiwania klientów: " + e.getMessage(), e);
        }
        return clients;
    }

    @Override
    public List<Client> findAll() {
        List<Client> out = new ArrayList<>();
        String sql = "SELECT name, nip, address FROM clients";
        try (Connection conn = db.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                out.add(new Client(rs.getString("name"), rs.getString("nip"), rs.getString("address")));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return out;
    }

    @Override
    public boolean delete(Client client) {
        if (client.getNip() == null)
            return false;

        try (Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement("DELETE FROM clients WHERE nip = ?")) {

            ps.setString(1, client.getNip());
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Błąd podczas usuwania klienta: " + e.getMessage(), e);
        }
    }
}
