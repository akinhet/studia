package com.example.invoiceapp.ui;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.Scanner;

import org.mindrot.jbcrypt.BCrypt;

import com.example.invoiceapp.Role;
import com.example.invoiceapp.dao.UserDao;
import com.example.invoiceapp.dao.jdbc.UserDaoJdbc;
import com.example.invoiceapp.model.User;

public class AdminUI {
    private static final Scanner SCANNER = new Scanner(System.in);
    private static final UserDao USER_DAO = new UserDaoJdbc();

    public static void adminLoop() {
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
                    case "update" -> handleUpdate(parts);
                    case "help" -> System.out.println("Komendy: list, add, delete, update, help, exit");
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
            System.out.println("Lista wszystkich użytkowników:");
            List<User> users = USER_DAO.findAll();
            users.forEach(u -> System.out.printf("[%d] %s: %s\n", u.getId(), u.getUsername(), u.getRole().toString()));
            return;
        }

        if (parts.length < 3) {
            System.out.println("Błędna składnia wyszukiwania.");
            System.out.println("Użycie: list <id|username|role> <wartość>");
            return;
        }

        String field = parts[1].toLowerCase();
        String value = parts[2];

        switch (field) {
            case "id" -> {
                System.out.println("Szukanie użytkownika o ID: " + value);
                try {
                    int id = Integer.parseInt(value);
                    User user = USER_DAO.findById(id);
                    if (user == null)
                        System.out.println("Nie znaleziono użytkownika");
                    else
                        System.out.printf("[%d] %s %s\n", user.getId(), user.getUsername(), user.getRole().toString());
                } catch (NumberFormatException e) {
                    System.out.println("ID musi być liczbą.");
                }
            }
            case "username" -> {
                System.out.println("Szukanie użytkowników z username zawierającym: " + value);
                List<User> users = USER_DAO.findByName(value);
                users.forEach(
                        u -> System.out.printf("[%d] %s: %s\n", u.getId(), u.getUsername(), u.getRole().toString()));
            }
            case "role" -> {
                System.out.println("Szukanie użytkowników z rolą: " + value);
                List<User> users = USER_DAO.findByRole(Role.valueOf(value));
                users.forEach(
                        u -> System.out.printf("[%d] %s: %s\n", u.getId(), u.getUsername(), u.getRole().toString()));
            }
            default -> System.out.println("Nieznane pole: " + field + ". Dostępne: id, username, role.");
        }
    }

    private static void handleAdd(String[] parts) {
        if (parts.length != 4) {
            System.out.println("Użycie: add <username> <password> <role>");
            return;
        }

        if (parts[2].length() > 72) {
            System.out.println("Hasło nie może być dłuższe niż 72 znaki");
            return;
        }

        String username = parts[1];
        String password = parts[2];
        String hash = BCrypt.hashpw(password, BCrypt.gensalt());
        Role role = Role.valueOf(parts[3]);

        System.out.println("Dodawanie użytkownika: " + username + " z rolą " + role);
        User u = new User(null, username, hash, role);
        u = USER_DAO.save(u);
    }

    private static void handleDelete(String[] parts) {
        if (parts.length < 2) {
            System.out.println("Użycie: delete <id>");
            return;
        }
        int id = Integer.parseInt(parts[1]);
        System.out.println("Usuwanie użytkownika o ID: " + id);
        if (!USER_DAO.delete(new User(id, null, null, null)))
            System.out.println("Użytkownik o takim id nie istnieje.");
    }

    private static void handleUpdate(String[] parts) {
        if (parts.length != 4) {
            System.out.println("Użycie: update <id> <username|password|role> <wartość>");
            return;
        }
        int id = Integer.parseInt(parts[1]);
        User newu = new User(id, null, null, null);
        switch (parts[2]) {
            case "username" -> newu.setUsername(parts[3]);
            case "password" -> newu.setHash(BCrypt.hashpw(parts[3], BCrypt.gensalt()));
            case "role" -> newu.setRole(Role.valueOf(parts[3]));
        }
        newu = USER_DAO.update(newu);
        if (newu == null)
            System.out.println("Nie udało się zupdateować użytkownika.");
    }
}
