package com.example.invoiceapp.dao;

import com.example.invoiceapp.model.Article;
import java.util.List;

public interface ArticleDao {
    Article save(Article article);
    Article findById(int id);
    List<Article> findByName(String str);
    List<Article> findAll();
    boolean delete(Article article);
}
