export default function App() {
  const products = [
    {
      id: 1,
      name: "Wireless Headphones",
      price: "$89",
      image:
        "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500",
    },
    {
      id: 2,
      name: "Smart Watch",
      price: "$120",
      image:
        "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500",
    },
    {
      id: 3,
      name: "Sneakers",
      price: "$75",
      image:
        "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500",
    },
  ];

  return (
    <div
      style={{
        fontFamily: "Arial, sans-serif",
        backgroundColor: "#f5f5f5",
        minHeight: "100vh",
        margin: 0,
        padding: 0,
      }}
    >
      {/* Navbar */}
      <nav
        style={{
          backgroundColor: "#111827",
          color: "white",
          padding: "18px 40px",
          display: "flex",
          justifyContent: "space-between",
          alignItems: "center",
        }}
      >
        <h1 style={{ margin: 0, fontSize: "28px" }}>ShopEase</h1>

        <div style={{ display: "flex", gap: "25px" }}>
          <a href="#" style={navLink}>
            Home
          </a>
          <a href="#" style={navLink}>
            Products
          </a>
          <a href="#" style={navLink}>
            Contact
          </a>
        </div>
      </nav>

      {/* Hero Section */}
      <section
        style={{
          display: "flex",
          alignItems: "center",
          justifyContent: "space-between",
          padding: "80px 50px",
          flexWrap: "wrap",
          gap: "40px",
          backgroundColor: "white",
        }}
      >
        <div style={{ maxWidth: "500px" }}>
          <h2
            style={{
              fontSize: "52px",
              marginBottom: "20px",
              color: "#111827",
            }}
          >
             jayanta and he is good
          </h2>

          <p
            style={{
              fontSize: "18px",
              color: "#6b7280",
              lineHeight: "1.6",
            }}
          >
            Shop the latest gadgets, fashion, and accessories with the best
            quality and affordable prices.
          </p>

          <button
            style={{
              marginTop: "25px",
              padding: "14px 30px",
              backgroundColor: "#2563eb",
              color: "white",
              border: "none",
              borderRadius: "8px",
              cursor: "pointer",
              fontSize: "16px",
              fontWeight: "bold",
            }}
          >
            Shop Now
          </button>
        </div>

        <img
          src="https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=900"
          alt="shopping"
          style={{
            width: "450px",
            borderRadius: "20px",
            objectFit: "cover",
          }}
        />
      </section>

      {/* Products Section */}
      <section style={{ padding: "60px 40px" }}>
        <h2
          style={{
            textAlign: "center",
            fontSize: "40px",
            marginBottom: "40px",
            color: "#111827",
          }}
        >
          Featured Products
        </h2>

        <div
          style={{
            display: "grid",
            gridTemplateColumns: "repeat(auto-fit, minmax(250px, 1fr))",
            gap: "30px",
          }}
        >
          {products.map((product) => (
            <div
              key={product.id}
              style={{
                backgroundColor: "white",
                borderRadius: "16px",
                overflow: "hidden",
                boxShadow: "0 4px 12px rgba(0,0,0,0.1)",
                transition: "0.3s",
              }}
            >
              <img
                src={product.image}
                alt={product.name}
                style={{
                  width: "100%",
                  height: "250px",
                  objectFit: "cover",
                }}
              />

              <div style={{ padding: "20px" }}>
                <h3
                  style={{
                    margin: "0 0 10px 0",
                    color: "#111827",
                  }}
                >
                  {product.name}
                </h3>

                <p
                  style={{
                    color: "#2563eb",
                    fontWeight: "bold",
                    fontSize: "18px",
                  }}
                >
                  {product.price}
                </p>

                <button
                  style={{
                    width: "100%",
                    marginTop: "15px",
                    padding: "12px",
                    backgroundColor: "#111827",
                    color: "white",
                    border: "none",
                    borderRadius: "8px",
                    cursor: "pointer",
                    fontWeight: "bold",
                  }}
                >
                  Add to Cart
                </button>
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* Footer */}
      <footer
        style={{
          backgroundColor: "#111827",
          color: "white",
          textAlign: "center",
          padding: "20px",
          marginTop: "40px",
        }}
      >
        <p style={{ margin: 0 }}>
          © 2026 ShopEase. All rights reserved.
        </p>
      </footer>
    </div>
  );
}

const navLink = {
  color: "white",
  textDecoration: "none",
  fontSize: "16px",
};