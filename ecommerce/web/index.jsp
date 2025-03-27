<%@page import="java.util.List"%>
<%@page import="utils.Produto"%>
<%
    List<Produto> produtos = (List<Produto>) request.getAttribute("produtos");
%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Loja Virtual</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Bootstrap + FontAwesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <!-- CSS Custom -->
    <style>
        :root {
            --primary-color: #2c3e50;
            --secondary-color: #3498db;
            --accent-color: #e74c3c;
        }

        body {
            background-color: #f4f4f4;
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

        .nav-icons {
            display: flex;
            align-items: center;
        }

        .login-link {
            color: white;
            text-decoration: none;
            margin-right: 15px;
        }

        .cart-icon {
            color: white;
            font-size: 20px;
            position: relative;
        }

        .cart-count {
            position: absolute;
            top: -8px;
            right: -8px;
            background-color: var(--accent-color);
            color: white;
            border-radius: 50%;
            width: 18px;
            height: 18px;
            font-size: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .product-card {
            border: none;
            border-radius: 10px;
            overflow: hidden;
            transition: transform 0.3s;
            margin-bottom: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            background-color: white;
        }

        .product-card:hover {
            transform: translateY(-5px);
        }

        .product-img-container {
            height: 200px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #f8f9fa;
            padding: 15px;
        }

        .product-img {
            max-height: 100%;
            max-width: 100%;
            object-fit: contain;
        }

        .product-name {
            font-weight: 600;
            color: var(--primary-color);
            margin: 10px 0;
            height: 50px;
            overflow: hidden;
        }

        .product-price {
            color: var(--accent-color);
            font-weight: bold;
            font-size: 18px;
        }

        .btn-details, .btn-buy {
            width: 100%;
            padding: 8px;
            border-radius: 5px;
            margin-top: 10px;
            border: none;
            color: white;
        }

        .btn-details {
            background-color: var(--secondary-color);
        }

        .btn-buy {
            background-color: var(--accent-color);
        }
    </style>
</head>
<body>

<!-- Header -->
<nav class="navbar navbar-expand-lg">
    <div class="container">
        <a class="navbar-brand" href="inicio"><i class="fas fa-store"></i> Loja Virtual</a>
        <div class="nav-icons">
            <a href="login.html" class="login-link">Faça login / Cadastre-se</a>
            <a href="carrinho.jsp" class="cart-icon">
                <i class="fas fa-shopping-cart"></i>
                <span class="cart-count" id="cart-count">0</span>
            </a>
        </div>
    </div>
</nav>

<!-- Produtos -->
<div class="container my-5">
    <div class="row">
        <% if (produtos != null && !produtos.isEmpty()) {
            for (Produto produto : produtos) { %>
            <div class="col-md-4 col-lg-3">
                <div class="product-card card">
                    <div class="product-img-container">
                        <img src="ObterImagemServlet?id=<%= produto.getId() %>" class="product-img" alt="<%= produto.getNome() %>">
                    </div>
                        <div class="card-body">
                            <h5 class="product-name"><%= produto.getNome()%></h5>
                            <p class="product-price">R$ <%= String.format("%.2f", produto.getValor())%></p>

                            <!-- BOTÃO DE DETALHES AJUSTADO -->
                            <a href="visualizar_produto.jsp?id=<%= produto.getId()%>" class="btn btn-details">Ver Detalhes</a>

                            <!-- BOTÃO COMPRAR -->
                            <button class="btn btn-buy" onclick="addToCart(<%= produto.getId()%>, '<%= produto.getNome()%>', <%= produto.getValor()%>, 1)">
                                Comprar
                            </button>
                        </div>
                    
                </div>
            </div>
        <% }} else { %>
            <p class="text-center">Nenhum produto disponível no momento.</p>
        <% } %>
    </div>
</div>

<!-- Scripts -->
<script>
    function updateCartCount() {
        let cart = JSON.parse(localStorage.getItem('cart')) || [];
        let count = 0;
        cart.forEach(item => count += item.quantidade);
        document.getElementById('cart-count').textContent = count;
    }

    function addToCart(id, nome, preco, quantidade) {
        let cart = JSON.parse(localStorage.getItem('cart')) || [];
        let produtoExistente = cart.find(item => item.id === id);

        if (produtoExistente) {
            produtoExistente.quantidade += quantidade;
        } else {
            cart.push({id, nome, preco, quantidade});
        }

        localStorage.setItem('cart', JSON.stringify(cart));
        updateCartCount();
        alert('Produto adicionado ao carrinho!');
    }

    document.addEventListener('DOMContentLoaded', updateCartCount);
</script>

</body>
</html>