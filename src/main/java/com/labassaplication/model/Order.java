package com.labassapplication.model;

import java.util.ArrayList;
import java.util.List;

/**
 * Order — represents a row in the `orders` table.
 * Each Order has a list of OrderItems.
 */
public class Order {

    private int    id;
    private int    userId;
    private double totalAmount;
    private String shippingName;
    private String shippingAddress;
    private String shippingCity;
    private String shippingCountry;
    private String postalCode;
    private String phone;
    private String paymentMethod;    // "card", "paypal", "gpay"
    private String status;           // "pending", "confirmed", "shipped", "delivered"
    private List<OrderItem> items = new ArrayList<>();

    // ── Constructors ─────────────────────────────────────────────────

    public Order() {}

    // ── Getters & Setters ────────────────────────────────────────────

    public int    getId()                    { return id; }
    public void   setId(int id)              { this.id = id; }

    public int    getUserId()                { return userId; }
    public void   setUserId(int v)           { this.userId = v; }

    public double getTotalAmount()           { return totalAmount; }
    public void   setTotalAmount(double v)   { this.totalAmount = v; }

    public String getShippingName()          { return shippingName; }
    public void   setShippingName(String v)  { this.shippingName = v; }

    public String getShippingAddress()       { return shippingAddress; }
    public void   setShippingAddress(String v){ this.shippingAddress = v; }

    public String getShippingCity()          { return shippingCity; }
    public void   setShippingCity(String v)  { this.shippingCity = v; }

    public String getShippingCountry()       { return shippingCountry; }
    public void   setShippingCountry(String v){ this.shippingCountry = v; }

    public String getPostalCode()            { return postalCode; }
    public void   setPostalCode(String v)    { this.postalCode = v; }

    public String getPhone()                 { return phone; }
    public void   setPhone(String v)         { this.phone = v; }

    public String getPaymentMethod()         { return paymentMethod; }
    public void   setPaymentMethod(String v) { this.paymentMethod = v; }

    public String getStatus()                { return status; }
    public void   setStatus(String v)        { this.status = v; }

    public List<OrderItem> getItems()        { return items; }
    public void   setItems(List<OrderItem> v){ this.items = v; }
}
