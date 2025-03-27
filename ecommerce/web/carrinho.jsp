<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Carrinho de Compras - Loja Virtual</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #2c3e50;
            --secondary-color: #3498db;
            --accent-color: #e74c3c;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
        }
        
        .navbar {
            background-color: var(--primary-color);
            padding: 15px 0;
        }
        
        .navbar-brand {
            color: white;
            font-weight: bold;
            font-size: 24px;
        }
        
        .nav-icons a {
            color: white;
            margin-left: 15px;
            font-size: 20px;
        }
        
        .login-link {
            color: white;
            text-decoration: none;
            margin-right: 15px;
        }
        
        .cart-container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            padding: 30px;
            margin-top: 30px;
        }
        
        .cart-title {
            color: var(--primary-color);
            font-weight: bold;
            margin-bottom: 30px;
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
        }
        
        .cart-item {
            border-bottom: 1px solid #eee;
            padding: 20px 0;
        }
        
        .product-img {
            width: 80px;
            height: 80px;
            object-fit: contain;
            border: 1px solid #eee;
            border-radius: 5px;
        }
        
        .product-name {
            font-weight: 600;
            color: var(--primary-color);
        }
        
        .product-price {
            font-weight: bold;
            color: #555;
        }
        
        .quantity-control {
            display: flex;
            align-items: center;
        }
        
        .quantity-btn {
            width: 30px;
            height: 30px;
            border: 1px solid #ddd;
            background-color: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
        }
        
        .quantity-input {
            width: 50px;
            text-align: center;
            border: 1px solid #ddd;
            height: 30px;
            margin: 0 5px;
        }
        
        .remove-btn {
            color: var(--accent-color);
            cursor: pointer;
        }
        
        .summary-card {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
        }
        
        .summary-title {
            font-weight: bold;
            color: var(--primary-color);
            margin-bottom: 20px;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        
        .total-row {
            font-weight: bold;
            font-size: 18px;
            border-top: 1px solid #ddd;
            padding-top: 10px;
            margin-top: 10px;
        }
        
        .btn-checkout {
            background-color: var(--accent-color);
            color: white;
            width: 100%;
            padding: 10px;
            font-weight: bold;
            border: none;
            border-radius: 5px;
            margin-top: 20px;
        }
        
        .empty-cart {
            text-align: center;
            padding: 50px 0;
        }
        
        .empty-cart-icon {
            font-size: 50px;
            color: #ddd;
            margin-bottom: 20px;
        }
        
        .btn-continue {
            background-color: var(--secondary-color);
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <!-- Cabeçalho -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="inicio">
                <i class="fas fa-store"></i> Loja Virtual
            </a>
            
            <div class="ms-auto d-flex align-items-center">
                <a href="login.html" class="login-link">Faça login / Cadastre-se</a>
                <div class="nav-icons">
                    <a href="carrinho.jsp"><i class="fas fa-shopping-cart"></i></a>
                    <span class="badge bg-danger rounded-pill" id="cart-count">0</span>
                </div>
            </div>
        </div>
    </nav>

    <!-- Carrinho de Compras -->
    <div class="container my-5">
        <div class="row">
            <div class="col-lg-8">
                <div class="cart-container">
                    <h2 class="cart-title">Seu Carrinho</h2>
                    
                    <div id="cart-items">
                        <!-- Itens serão carregados via JavaScript -->
                    </div>
                </div>
            </div>
            
            <div class="col-lg-4">
                <div class="cart-container">
                    <div class="summary-card">
                        <h3 class="summary-title">Resumo do Pedido</h3>
                        
                        <div class="summary-row">
                            <span>Subtotal</span>
                            <span id="subtotal">R$ 0,00</span>
                        </div>
                        
                        <div class="summary-row">
                            <span>Frete</span>
                            <span id="frete">R$ 10,00</span>
                        </div>
                        
                        <div class="summary-row total-row">
                            <span>Total</span>
                            <span id="total">R$ 10,00</span>
                        </div>
                        
                        <button class="btn btn-checkout">Finalizar Compra</button>
                        <a href="inicio" class="btn btn-continue btn-block">Continuar Comprando</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            updateCartCount();
            renderCartItems();
        });
        
        function renderCartItems() {
            const cart = JSON.parse(localStorage.getItem('cart')) || [];
            const cartItemsContainer = document.getElementById('cart-items');
            
            if (cart.length === 0) {
                cartItemsContainer.innerHTML = `
                    <div class="empty-cart">
                        <div class="empty-cart-icon">
                            <i class="fas fa-shopping-cart"></i>
                        </div>
                        <h4>Seu carrinho está vazio</h4>
                        <p>Adicione produtos para continuar</p>
                        <a href="index.jsp" class="btn btn-continue">Continuar Comprando</a>
                    </div>
                `;
                updateSummary(0);
                return;
            }
            
            let html = '';
            let subtotal = 0;
            
            cart.forEach(item => {
                const itemTotal = item.preco * item.quantidade;
                subtotal += itemTotal;
                
                html += `
                    <div class="cart-item row align-items-center" data-id="${item.id}">
                        <div class="col-md-2">
                            <img src="https://via.placeholder.com/80" class="product-img" alt="${item.nome}">
                        </div>
                        <div class="col-md-4">
                            <div class="product-name">${item.nome}</div>
                            <div class="product-price">R$ ${item.preco.toFixed(2)}</div>
                        </div>
                        <div class="col-md-3">
                            <div class="quantity-control">
                                <div class="quantity-btn minus" onclick="updateQuantity(${item.id}, -1)">-</div>
                                <input type="text" class="quantity-input" value="${item.quantidade}" readonly>
                                <div class="quantity-btn plus" onclick="updateQuantity(${item.id}, 1)">+</div>
                            </div>
                        </div>
                        <div class="col-md-2 text-end">
                            <div class="product-price">R$ ${itemTotal.toFixed(2)}</div>
                        </div>
                        <div class="col-md-1 text-end">
                            <div class="remove-btn" onclick="removeItem(${item.id})">
                                <i class="fas fa-trash"></i>
                            </div>
                        </div>
                    </div>
                `;
            });
            
            cartItemsContainer.innerHTML = html;
            updateSummary(subtotal);
        }
        
        function updateQuantity(id, change) {
            let cart = JSON.parse(localStorage.getItem('cart')) || [];
            
            cart = cart.map(item => {
                if (item.id === id) {
                    const newQuantity = item.quantidade + change;
                    item.quantidade = newQuantity > 0 ? newQuantity : 1;
                }
                return item;
            });
            
            localStorage.setItem('cart', JSON.stringify(cart));
            renderCartItems();
            updateCartCount();
        }
        
        function removeItem(id) {
            let cart = JSON.parse(localStorage.getItem('cart')) || [];
            cart = cart.filter(item => item.id !== id);
            localStorage.setItem('cart', JSON.stringify(cart));
            renderCartItems();
            updateCartCount();
        }
        
        function updateSummary(subtotal) {
            const frete = 10.00; // Valor fixo de frete para exemplo
            const total = subtotal + frete;
            
            document.getElementById('subtotal').textContent = `R$ ${subtotal.toFixed(2)}`;
            document.getElementById('frete').textContent = `R$ ${frete.toFixed(2)}`;
            document.getElementById('total').textContent = `R$ ${total.toFixed(2)}`;
        }
        
        function updateCartCount() {
            let cart = JSON.parse(localStorage.getItem('cart')) || [];
            let count = 0;
            
            cart.forEach(item => {
                count += item.quantidade;
            });
            
            document.getElementById('cart-count').textContent = count;
            localStorage.setItem('cartCount', count);
        }
    </script>
</body>
</html>
