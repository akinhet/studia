package com.example.invoiceapp.ui;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.Scanner;

import com.example.invoiceapp.dao.ClientDao;
import com.example.invoiceapp.dao.jdbc.ClientDaoJdbc;
import com.example.invoiceapp.model.Client;

public class SalesUI {
    private static final Scanner SCANNER = new Scanner(System.in);
    private static final ClientDao CLIENT_DAO = new ClientDaoJdbc();

    public static void salesloop() {
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
            System.out.println("Lista wszystkich klientów:");
            List<Client> clients = CLIENT_DAO.findAll();
            clients.forEach(c -> System.out.printf("[%s] %s: %s\n", c.getNip(), c.getName(), c.getAddress()));
            return;
        }

        if (parts.length < 3) {
            System.out.println("Błędna składnia wyszukiwania.");
            System.out.println("Użycie: list <nip|name> <wartość>");
            return;
        }

        String field = parts[1].toLowerCase();
        String value = parts[2];

        switch (field) {
            case "nip" -> {
                System.out.println("Szukanie klientów o NIP: " + value);
                try {
                    Client client = CLIENT_DAO.findByNip(value);
                    if (client == null)
                        System.out.println("Nie znaleziono klienta");
                    else
                        System.out.printf("[%s] %s: %s\n", client.getNip(), client.getName(), client.getAddress());
                } catch (NumberFormatException e) {
                    System.out.println("ID musi być liczbą.");
                }
            }
            case "name" -> {
                System.out.println("Szukanie klientów z name zawierającym: " + value);
                List<Client> clients = CLIENT_DAO.findByName(value);
                clients.forEach(c -> System.out.printf("[%s] %s: %s\n", c.getNip(), c.getName(), c.getAddress()));
            }
            default -> System.out.println("Nieznane pole: " + field + ". Dostępne: nip, name.");
        }
    }

    private static void handleAdd(String[] parts) {
        if (parts.length != 4) {
            System.out.println("Użycie: add <nip> <name> <address>");
            return;
        }

        String nip = parts[1];
        String name = parts[2];
        String address = parts[3];

        Client a = new Client(name, nip, address);
        a = CLIENT_DAO.save(a);
    }

    private static void handleDelete(String[] parts) {
        if (parts.length < 2) {
            System.out.println("Użycie: delete <id>");
            return;
        }
        String nip = parts[1];
        System.out.println("Usuwanie klienta o NIP: " + nip);
        if (!CLIENT_DAO.delete(new Client(null, nip, null)))
            System.out.println("Klient o takim id nie istnieje.");
    }
}
