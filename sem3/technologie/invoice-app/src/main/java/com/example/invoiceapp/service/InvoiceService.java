package com.example.invoiceapp.service;

import com.example.invoiceapp.dao.InvoiceDao;
import com.example.invoiceapp.model.Invoice;

public class InvoiceService {
    private final InvoiceDao invoiceDao;

    public InvoiceService(InvoiceDao invoiceDao) {
        this.invoiceDao = invoiceDao;
    }

    public Invoice createInvoice(Invoice invoice) {
        return invoiceDao.save(invoice);
    }
}
