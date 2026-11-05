package com.example.invoiceapp.model;

public class InvoiceItem {
    private int id,
                quantity;
    private double price;
    private String name;

    public InvoiceItem(Article article, int quantity) {
        this.price = article.getPrice();
        this.name = article.getName();
        this.quantity = quantity;
    }

    public InvoiceItem(String name, double price, int quantity) {
        this.price = price;
        this.name = name;
        this.quantity = quantity;
    }

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public void copyArticle(Article article) { this.price = article.getPrice(); this.name = article.getName(); }
    public String getName() { return name; }
    public double getPrice() { return price; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}
