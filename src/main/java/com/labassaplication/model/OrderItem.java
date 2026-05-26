package com.labassapplication.model;

/**
 * OrderItem — represents a row in the `order_items` table.
 * One order can have many OrderItems (one per product).
 */
public class OrderItem {

    private int     id;
    private int     orderId;
    private int     productId;
    private int     quantity;
    private double  unitPrice;
    private Product product;   // optional: populated by JOIN in DAO

    // ── Constructors ─────────────────────────────────────────────────

    public OrderItem() {}

    public OrderItem(int productId, int quantity, double unitPrice) {
        this.productId = productId;
        this.quantity  = quantity;
        this.unitPrice = unitPrice;
    }

    // ── Getters & Setters ────────────────────────────────────────────

    public int     getId()               { return id; }
    public void    setId(int id)         { this.id = id; }

    public int     getOrderId()          { return orderId; }
    public void    setOrderId(int v)     { this.orderId = v; }

    public int     getProductId()        { return productId; }
    public void    setProductId(int v)   { this.productId = v; }

    public int     getQuantity()         { return quantity; }
    public void    setQuantity(int v)    { this.quantity = v; }

    public double  getUnitPrice()        { return unitPrice; }
    public void    setUnitPrice(double v){ this.unitPrice = v; }

    public Product getProduct()          { return product; }
    public void    setProduct(Product v) { this.product = v; }

    /** Convenience: total price for this line item */
    public double getLineTotal() {
        return unitPrice * quantity;
    }
}
