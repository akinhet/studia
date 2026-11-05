package com.example.invoiceapp.dao.jdbc;

import com.example.invoiceapp.dao.ArticleDao;
import com.example.invoiceapp.db.DatabaseManager;
import com.example.invoiceapp.model.Article;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ArticleDaoJdbc implements ArticleDao {
    private final DatabaseManager db = DatabaseManager.getInstance();

    public ArticleDaoJdbc() {}

    @Override
    public Article save(Article article) {
        String sqlInsert = "INSERT INTO articles(name,price) VALUES(?,?)";
        String sqlUpdate = "UPDATE articles SET name=?,price=? WHERE id=?";
        try (Connection conn = db.getConnection()) {
            if (article.getId() == null) {
                try (PreparedStatement ps = conn.prepareStatement(sqlInsert, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, article.getName());
                    ps.setDouble(2, article.getPrice());
                    ps.executeUpdate();
                    ResultSet rs = ps.getGeneratedKeys();
                    if (rs.next())
                        article.setId(rs.getInt(1));
                }
            } else {
                try (PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
                    ps.setString(1, article.getName());
                    ps.setDouble(2, article.getPrice());
                    ps.setInt(3, article.getId());
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return article;
    }

    @Override
    public Article findById(int id) {
        String sql = "SELECT * FROM articles WHERE id = ?";
        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return new Article(rs.getInt("id"), rs.getString("name"), rs.getDouble("price"));
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    @Override
    public List<Article> findByName(String str) {
        List<Article> articles = new ArrayList<>();
        String sql = "SELECT id, name, price FROM articles WHERE name LIKE ?";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + str + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    articles.add(new Article(rs.getInt("id"), rs.getString("name"), rs.getDouble("price")));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Błąd podczas wyszukiwania artykułów: " + e.getMessage(), e);
        }
        return articles;
    }

    @Override
    public List<Article> findAll() {
        List<Article> out = new ArrayList<>();
        String sql = "SELECT * FROM articles";
        try (Connection conn = db.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                out.add(new Article(rs.getInt("id"), rs.getString("name"), rs.getDouble("price")));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return out;
    }

    @Override
    public boolean delete(Article article) {
        if (article.getId() == null)
            return false;

        try (Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement("DELETE FROM articles WHERE id = ?")) {

            ps.setInt(1, article.getId());
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Błąd podczas usuwania artykułu: " + e.getMessage(), e);
        }
    }
}
