package com.example.invoiceapp.dao;

import com.example.invoiceapp.model.Client;
import java.util.List;

public interface ClientDao {
    Client save(Client client);
    Client findByNip(String nip);
    List<Client> findByName(String str);
    List<Client> findAll();
    boolean delete(Client client);
}
