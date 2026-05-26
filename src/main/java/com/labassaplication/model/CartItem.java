package com.labassapplication.model;

/**
 * CartItem — represents a row in the `cart_items` table.
 * Links a user to a product they've added to their cart.
 */
public class CartItem {

    private int     id;
    private int     userId;
    private int     productId;
    private int     quantity;
    private Product product;   // populated by JOIN in CartDAO

    // ── Constructors ─────────────────────────────────────────────────

    public CartItem() {}

    public CartItem(int userId, int productId, int quantity) {
        this.userId    = userId;
        this.productId = productId;
        this.quantity  = quantity;
    }

    // ── Getters & Setters ────────────────────────────────────────────

    public int     getId()               { return id; }
    public void    setId(int id)         { this.id = id; }

    public int     getUserId()           { return userId; }
    public void    setUserId(int v)      { this.userId = v; }

    public int     getProductId()        { return productId; }
    public void    setProductId(int v)   { this.productId = v; }

    public int     getQuantity()         { return quantity; }
    public void    setQuantity(int v)    { this.quantity = v; }

    public Product getProduct()          { return product; }
    public void    setProduct(Product v) { this.product = v; }

    /** Convenience: subtotal for this cart line */
    public double getLineTotal() {
        if (product == null) return 0;
        return product.getPrice() * quantity;
    }
}
