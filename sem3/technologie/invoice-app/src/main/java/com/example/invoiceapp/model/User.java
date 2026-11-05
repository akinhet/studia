package com.example.invoiceapp.model;

import com.example.invoiceapp.Role;

public class User {
    private Integer id;
    private String username,
            hash;
    private Role role;

    public User(Integer id, String username, String hash, Role role) {
        this.id = id;
        this.username = username;
        this.hash = hash;
        this.role = role;
    }

    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }
    public String getUsername() {
        return username;
    }
    public void setUsername(String username) {
        this.username = username;
    }
    public String getHash() {
        return hash;
    }
    public void setHash(String hash) {
        this.hash = hash;
    }
    public Role getRole() {
        return role;
    }
    public void setRole(Role role) {
        this.role = role;
    }

}
