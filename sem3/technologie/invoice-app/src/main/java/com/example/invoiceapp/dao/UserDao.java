package com.example.invoiceapp.dao;

import com.example.invoiceapp.Role;
import com.example.invoiceapp.model.User;
import java.util.List;

public interface UserDao {
    User save(User user);
    User findById(int id);
    List<User> findByName(String str);
    List<User> findByRole(Role role);
    List<User> findAll();
    boolean delete(User user);
    public User update(User user);
}
