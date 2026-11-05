package com.example.invoiceapp.model;

public class Client {
    private String name;
    private String nip;
    private String address;

    public Client(String name, String nip, String address) {
        this.name = name; this.nip = nip; this.address = address;
    }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getNip() { return nip; }
    public void setNip(String nip) { this.nip = nip; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
}
