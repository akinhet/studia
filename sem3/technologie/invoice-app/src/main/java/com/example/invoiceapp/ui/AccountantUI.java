package com.example.invoiceapp.ui;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.Scanner;

import com.example.invoiceapp.dao.ArticleDao;
import com.example.invoiceapp.dao.ClientDao;
import com.example.invoiceapp.dao.InvoiceDao;
import com.example.invoiceapp.dao.jdbc.ArticleDaoJdbc;
import com.example.invoiceapp.dao.jdbc.ClientDaoJdbc;
import com.example.invoiceapp.dao.jdbc.InvoiceDaoJdbc;
import com.example.invoiceapp.model.Article;
import com.example.invoiceapp.model.Client;
import com.example.invoiceapp.model.Invoice;
import com.example.invoiceapp.model.InvoiceItem;
import com.example.invoiceapp.service.InvoiceService;

public class AccountantUI {
    private static final Scanner SCANNER = new Scanner(System.in);
    private static final InvoiceDao INVOICE_DAO = new InvoiceDaoJdbc();
    private static final ClientDao CLIENT_DAO = new ClientDaoJdbc();
    private static final ArticleDao ARTICLE_DAO = new ArticleDaoJdbc();
    private static final InvoiceService INVOICE_SERVICE = new InvoiceService(INVOICE_DAO);

    public static void accountingloop() {
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
                    case "show" -> handleShow(parts);
                    case "help" -> System.out.println("Komendy: list, add, show, help, exit");
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
        if (parts.length < 2) {
            System.out.println("Użycie: list [clients|articles|invoices]");
            return;
        }
        switch (parts[1]) {
            case "clients" -> CLIENT_DAO.findAll().forEach(c ->
                    System.out.printf("[%s] %s %s\n", c.getNip(), c.getName(), c.getAddress()));
            case "articles" -> ARTICLE_DAO.findAll().forEach(a ->
                    System.out.printf("[%d] %s - %.2f zł\n", a.getId(), a.getName(), a.getPrice()));
            case "invoices" -> INVOICE_DAO.findAll().forEach(i ->
                    System.out.printf("[%d] %s, %s, %.2f zł\n",
                            i.getId(), i.getClient().getName(), i.getDate(), i.getTotal()));
            default -> System.out.println("Nieznana kategoria.");
        }
    }

    private static void handleShow(String[] parts) {
        if (parts.length < 3 || !"invoice".equals(parts[1])) {
            System.out.println("Użycie: show invoice <id>");
            return;
        }
        int id = Integer.parseInt(parts[2]);
        Invoice inv = INVOICE_DAO.findById(id);
        if (inv == null) {
            System.out.println("Nie znaleziono faktury.");
            return;
        }
        System.out.printf("Faktura #%d - %s (%s)%n", inv.getId(), inv.getClient().getName(), inv.getDate());
        System.out.println("-------------------------------------------------");
        inv.getItems().forEach(it ->
                System.out.printf("%s x%d @ %.2f zł = %.2f zł%n",
                        it.getName(), it.getQuantity(), it.getPrice(),
                        it.getPrice() * it.getQuantity()));
        System.out.printf("RAZEM: %.2f zł%n", inv.getTotal());
    }


    private static void handleAdd(String[] parts) {
        System.out.print("NIP klienta: ");
        String clientNip = SCANNER.nextLine();
        Client client = CLIENT_DAO.findByNip(clientNip);
        if (client == null) {
            System.out.println("Nie znaleziono klienta.");
            return;
        }

        Invoice invoice = new Invoice(client, java.time.LocalDate.now().toString());

        while (true) {
            System.out.print("ID artykułu (lub 0 by zakończyć): ");
            int artId = Integer.parseInt(SCANNER.nextLine());
            if (artId == 0)
                break;

            Article art = ARTICLE_DAO.findById(artId);
            if (art == null) {
                System.out.println("Nie znaleziono artykułu.");
                continue;
            }

            System.out.print("Ilość: ");
            int qty = Integer.parseInt(SCANNER.nextLine());
            invoice.addItem(new InvoiceItem(art, qty));
        }

        INVOICE_SERVICE.createInvoice(invoice);
        System.out.println("Faktura zapisana.");
    }
}
