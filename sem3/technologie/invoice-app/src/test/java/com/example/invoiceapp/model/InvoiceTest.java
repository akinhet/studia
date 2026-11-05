package com.example.invoiceapp.model;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class InvoiceTest {

    private Invoice invoice;
    private Client client;
    private Article article1, article2;

    @BeforeEach
    void setUp() {
        client = new Client("Test Client", "123456789", "Testowa 1 Testowo");
        invoice = new Invoice(client, "2025-11-11");
        article1 = new Article(null, "Produkt A", 10);
        article2 = new Article(null, "Produkt B", 5);
    }

    @Test
    void shouldCreateInvoiceWithClientAndDate() {
        assertEquals(client, invoice.getClient());
        assertEquals("2025-11-11", invoice.getDate());
        assertTrue(invoice.getItems().isEmpty());
        assertEquals(0.0, invoice.getTotal());
    }

    @Test
    void shouldAddItemAndComputeTotal() {
        InvoiceItem item2 = new InvoiceItem(article1, 1);
        InvoiceItem item1 = new InvoiceItem(article2, 2);

        invoice.addItem(item1);
        invoice.addItem(item2);

        assertEquals(2, invoice.getItems().size());
        assertEquals(20.0, invoice.getTotal());
    }

    @Test
    void shouldRemoveItemAndUpdateTotal() {
        InvoiceItem item1 = new InvoiceItem(article1, 1);
        InvoiceItem item2 = new InvoiceItem(article2, 2);

        invoice.addItem(item1);
        invoice.addItem(item2);
        assertEquals(20.0, invoice.getTotal());

        invoice.removeItem(item1);
        assertEquals(1, invoice.getItems().size());
        assertEquals(10.0, invoice.getTotal());
    }

    @Test
    void computeTotalShouldSumAllItems() {
        invoice.addItem(new InvoiceItem(article1, 1));
        invoice.addItem(new InvoiceItem(article2, 2));

        assertEquals(20.0, invoice.getTotal());
    }

    @Test
    void shouldSetAndGetId() {
        invoice.setId(10);
        assertEquals(10, invoice.getId());
    }
}
