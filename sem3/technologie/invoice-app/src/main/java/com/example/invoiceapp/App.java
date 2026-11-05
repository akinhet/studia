package com.example.invoiceapp;

import com.example.invoiceapp.ui.AccountantUI;
import com.example.invoiceapp.ui.AdminUI;
import com.example.invoiceapp.ui.SalesUI;
import com.example.invoiceapp.ui.WarehouseUI;

import java.util.*;

public class App {
    private static final Scanner SCANNER = new Scanner(System.in);

    public static void main(String[] args) {
        Role role = null;
        System.out.println("=== System faktur ===\n");
        while (true) {
            String login, passwd;
            System.out.print("login: ");
            try {
                login = SCANNER.nextLine().trim();
            } catch (NoSuchElementException e) {
                continue;
            }
            System.out.print("hasło: ");
            try {
                passwd = SCANNER.nextLine().trim();
            } catch (NoSuchElementException e) {
                continue;
            }

            Authenticator authenticator = new Authenticator();

            role = authenticator.getUserRole(login, passwd);
            if (role != null) {
                System.out.println("Witaj " + login + "!\n");
                break;
            }

            System.err.println("Niepoprawna nazwa użytkownika lub hasło.\n");
        }

        switch (role) {
            case ADMIN:
                AdminUI.adminLoop();
                break;
            case ACCOUNTANT:
                AccountantUI.accountingloop();
                break;
            case SALESMAN:
                SalesUI.salesloop();
                break;
            case WAREHOUSEMAN:
                WarehouseUI.warehouseLoop();
                break;

            default:
                break;
        }
    }
}
