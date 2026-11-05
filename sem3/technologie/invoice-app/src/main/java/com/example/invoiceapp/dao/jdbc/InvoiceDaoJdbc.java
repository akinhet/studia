package com.example.invoiceapp.dao.jdbc;

import com.example.invoiceapp.dao.InvoiceDao;
import com.example.invoiceapp.db.DatabaseManager;
import com.example.invoiceapp.model.*;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InvoiceDaoJdbc implements InvoiceDao {
    private final DatabaseManager db = DatabaseManager.getInstance();
    private final ArticleDaoJdbc articleDao = new ArticleDaoJdbc();
    private final ClientDaoJdbc clientDao = new ClientDaoJdbc();

    public InvoiceDaoJdbc() {}

    @Override
    public Invoice save(Invoice invoice) {
        String invoiceSql = "INSERT INTO invoices(client_nip,date) VALUES(?,?)";
        String itemSql = "INSERT INTO invoice_items(invoice_id,name,price,quantity) VALUES(?,?,?,?)";

        try (Connection conn = db.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement psInv = conn.prepareStatement(invoiceSql, Statement.RETURN_GENERATED_KEYS)) {
                psInv.setString(1, invoice.getClient().getNip());
                psInv.setDate(2, Date.valueOf(invoice.getDate()));
                psInv.executeUpdate();
                ResultSet rs = psInv.getGeneratedKeys();
                if (rs.next())
                    invoice.setId(rs.getInt(1));
            }

            try (PreparedStatement psItem = conn.prepareStatement(itemSql)) {
                for (InvoiceItem item : invoice.getItems()) {
                    psItem.setInt(1, invoice.getId());
                    psItem.setString(2, item.getName());
                    psItem.setDouble(3, item.getPrice());
                    psItem.setInt(4, item.getQuantity());
                    psItem.addBatch();
                }
                psItem.executeBatch();
            }

            conn.commit();
        } catch (SQLException e) {
            throw new RuntimeException("Error saving invoice: " + e.toString(), e);
        }
        return invoice;
    }

    @Override
    public Invoice findById(int id) {
        String sql = "SELECT * FROM invoices WHERE id=?";
        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (!rs.next())
                return null;
            Invoice invoice = new Invoice(clientDao.findByNip(rs.getString("client_nip")), rs.getDate("date").toString());
            invoice.setId(rs.getInt("id"));
            invoice.getItems().clear();
            String itemSql = "SELECT * FROM invoice_items WHERE invoice_id=?";
            try (PreparedStatement psItem = conn.prepareStatement(itemSql)) {
                psItem.setInt(1, id);
                ResultSet its = psItem.executeQuery();
                while (its.next()) {
                    InvoiceItem item = new InvoiceItem(its.getString("name"), its.getDouble("price"), its.getInt("quantity"));
                    item.setId(its.getInt("id"));
                    invoice.getItems().add(item);
                }
            }
            return invoice;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public List<Invoice> findAll() {
        List<Invoice> out = new ArrayList<>();
        String sql = "SELECT * FROM invoices ORDER BY date DESC";
        try (Connection conn = db.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Invoice inv = new Invoice(clientDao.findByNip(rs.getString("client_nip")), rs.getDate("date").toString());
                inv.setId(rs.getInt("id"));
                inv.getItems().clear();
                String itemSql = "SELECT * FROM invoice_items WHERE invoice_id=?";
                try (PreparedStatement psItem = conn.prepareStatement(itemSql)) {
                    psItem.setInt(1, inv.getId());
                    ResultSet its = psItem.executeQuery();
                    while (its.next()) {
                        InvoiceItem item = new InvoiceItem(its.getString("name"), its.getDouble("price"), its.getInt("quantity"));
                        item.setId(its.getInt("id"));
                        inv.getItems().add(item);
                    }
                }
                out.add(inv);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return out;
    }
}
