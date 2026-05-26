package com.labassapplication.model;

/**
 * User — represents a row in the `users` table.
 * This is a plain Java bean (getters + setters only, no logic).
 */
public class User {

    private int    id;
    private String fullName;
    private String email;
    private String password;   // stored as SHA-256 hash
    private String phone;
    private String address;
    private String city;
    private String country;

    // ── Constructors ─────────────────────────────────────────────────

    public User() {}

    public User(String fullName, String email, String password) {
        this.fullName = fullName;
        this.email    = email;
        this.password = password;
    }

    // ── Getters & Setters ────────────────────────────────────────────

    public int    getId()       { return id; }
    public void   setId(int id) { this.id = id; }

    public String getFullName()              { return fullName; }
    public void   setFullName(String v)      { this.fullName = v; }

    public String getEmail()                 { return email; }
    public void   setEmail(String v)         { this.email = v; }

    public String getPassword()              { return password; }
    public void   setPassword(String v)      { this.password = v; }

    public String getPhone()                 { return phone; }
    public void   setPhone(String v)         { this.phone = v; }

    public String getAddress()               { return address; }
    public void   setAddress(String v)       { this.address = v; }

    public String getCity()                  { return city; }
    public void   setCity(String v)          { this.city = v; }

    public String getCountry()               { return country; }
    public void   setCountry(String v)       { this.country = v; }

    @Override
    public String toString() {
        return "User{id=" + id + ", email='" + email + "'}";
    }
}
