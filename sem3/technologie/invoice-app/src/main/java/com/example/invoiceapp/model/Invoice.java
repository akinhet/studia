package com.example.invoiceapp.model;

import java.util.ArrayList;
import java.util.List;

public class Invoice {
    private Integer id;
    private Client client;
    private String date;
    private final List<InvoiceItem> items = new ArrayList<>();

    public Invoice(Client client, String date) {
        this.client = client;
        this.date = date;
    }

    public void addItem(InvoiceItem item) {
        items.add(item);
    }

    public void removeItem(InvoiceItem item) {
        items.remove(item);
    }

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Client getClient() { return client; }
    public void setClient(Client client) { this.client = client; }
    public String getDate() { return date; }
    public void setDate(String date) { this.date = date; }
    public List<InvoiceItem> getItems() { return items; }
    public double getTotal() {
        return items.stream().mapToDouble(i -> i.getPrice() * i.getQuantity()).sum();
    }
}
