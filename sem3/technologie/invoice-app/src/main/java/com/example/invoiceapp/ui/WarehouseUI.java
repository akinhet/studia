package com.example.invoiceapp.ui;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.Scanner;

import com.example.invoiceapp.dao.ArticleDao;
import com.example.invoiceapp.dao.jdbc.ArticleDaoJdbc;
import com.example.invoiceapp.model.Article;

public class WarehouseUI {
    private static final Scanner SCANNER = new Scanner(System.in);
    private static final ArticleDao ARTICLE_DAO = new ArticleDaoJdbc();

    public static void warehouseLoop() {
        while (true) {
            System.out.print("\n> ");
            String input;
            try {
                input = SCANNER.nextLine().trim();
            } catch (NoSuchElementException e) {
                return;
            }
            if (input.isEmpty())
                continue;
            String[] parts = input.split("\\s+");
            String command = parts[0].toLowerCase();

            try {
                switch (command) {
                    case "list" -> handleList(parts);
                    case "add" -> handleAdd(parts);
                    case "delete" -> handleDelete(parts);
                    case "help" -> System.out.println("Komendy: list, add, delete, help, exit");
                    case "exit" -> {
                        return;
                    }
                    default -> System.out.println("Nieznane polecenie.");
                }
            } catch (Exception e) {
                System.err.println("Błąd: " + e.getMessage());
            }
        }
    }

    private static void handleList(String[] parts) {
        if (parts.length == 1) {
            System.out.println("Lista wszystkich artykułów:");
            List<Article> articles = ARTICLE_DAO.findAll();
            articles.forEach(a -> System.out.printf("[%d] %s: %.2f zł\n", a.getId(), a.getName(), a.getPrice()));
            return;
        }

        if (parts.length < 3) {
            System.out.println("Błędna składnia wyszukiwania.");
            System.out.println("Użycie: list <id|name> <wartość>");
            return;
        }

        String field = parts[1].toLowerCase();
        String value = parts[2];

        switch (field) {
            case "id" -> {
                System.out.println("Szukanie artykułów o ID: " + value);
                try {
                    int id = Integer.parseInt(value);
                    Article article = ARTICLE_DAO.findById(id);
                    if (article == null)
                        System.out.println("Nie znaleziono artykułu");
                    else
                        System.out.printf("[%d] %s: %.2f zł\n", article.getId(), article.getName(), article.getPrice());
                } catch (NumberFormatException e) {
                    System.out.println("ID musi być liczbą.");
                }
            }
            case "name" -> {
                System.out.println("Szukanie artykułów z name zawierającym: " + value);
                List<Article> articles = ARTICLE_DAO.findByName(value);
                articles.forEach(
                        a -> System.out.printf("[%d] %s: %.2f zł\n", a.getId(), a.getName(), a.getPrice()));
            }
            default -> System.out.println("Nieznane pole: " + field + ". Dostępne: id, name.");
        }
    }

    private static void handleAdd(String[] parts) {
        if (parts.length != 3) {
            System.out.println("Użycie: add <name> <price>");
            return;
        }

        String name = parts[1];
        Double price = Double.parseDouble(parts[2]);

        Article a = new Article(null, name, price);
        a = ARTICLE_DAO.save(a);
    }

    private static void handleDelete(String[] parts) {
        if (parts.length < 2) {
            System.out.println("Użycie: delete <id>");
            return;
        }
        int id = Integer.parseInt(parts[1]);
        System.out.println("Usuwanie artykułu o ID: " + id);
        if (!ARTICLE_DAO.delete(new Article(id, null, 0)))
            System.out.println("Artykuł o takim id nie istnieje.");
    }

}
