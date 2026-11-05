package com.example.invoiceapp.dao;

import com.example.invoiceapp.model.Invoice;
import java.util.List;

public interface InvoiceDao {
    Invoice save(Invoice invoice);
    Invoice findById(int id);
    List<Invoice> findAll();
}
