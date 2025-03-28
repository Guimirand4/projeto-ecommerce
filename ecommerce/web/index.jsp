<%@page import="java.util.List"%>
<%@page import="utils.Produto"%>
<%@page import="java.sql.*, java.util.ArrayList"%>
<%@page import="utils.ConexaoDB"%>

<%
    // Obtendo os produtos da requisição
    List<Produto> produtos = (List<Produto>) request.getAttribute("produtos");
    
    // Conexão com o banco de dados para obter imagens
    Connection con = null;
    PreparedStatement psImg = null;
    ResultSet rsImg = null;

    try {
        con = ConexaoDB.getConnection();
        
        // Consulta para buscar as imagens do produto
        String sqlImg = "SELECT imagem FROM produto_imagens WHERE produto_id = ?";
        
        // Para cada produto, buscar as imagens associadas
        for (Produto produto : produtos) {
            List<String> imagens = new ArrayList<>(); // Lista de imagens para o produto atual
            
            psImg = con.prepareStatement(sqlImg);
            psImg.setInt(1, produto.getId());
            rsImg = psImg.executeQuery();
            
            while (rsImg.next()) {
                imagens.add(rsImg.getString("imagem")); // Adicionando as imagens à lista do produto
            }
            
            produto.setImagens(imagens);  // Setando as imagens no produto
        }
    } catch (Exception e) {
        out.println("Erro: " + e.getMessage());
    } finally {
        if (rsImg != null) try { rsImg.close(); } catch (SQLException ignore) {}
        if (psImg != null) try { psImg.close(); } catch (SQLException ignore) {}
        if (con != null) try { con.close(); } catch (SQLException ignore) {}
    }
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>McDonald's - Loja Virtual</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Bootstrap + FontAwesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <!-- CSS Custom -->
    <style>
        :root {
            --mcd-red: #DA291C;
            --mcd-yellow: #FFC72C;
            --mcd-dark: #27251F;
            --mcd-light: #FFFFFF;
        }

        body {
            background-color: #f4f4f4;
            font-family: 'Helvetica Neue', Arial, sans-serif;
        }

        .navbar {
            background-color: var(--mcd-red);
            padding: 10px 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .navbar-brand {
            color: var(--mcd-yellow);
            font-weight: bold;
            font-size: 28px;
            font-family: 'Helvetica Neue', Arial, sans-serif;
            display: flex;
            align-items: center;
        }

        .navbar-brand img {
            height: 40px;
            margin-right: 10px;
        }

        .nav-icons {
            display: flex;
            align-items: center;
        }

        .login-link {
            color: var(--mcd-light);
            text-decoration: none;
            margin-right: 15px;
            font-weight: 500;
        }

        .cart-icon {
            color: var(--mcd-light);
            font-size: 20px;
            position: relative;
        }

        .cart-count {
            position: absolute;
            top: -8px;
            right: -8px;
            background-color: var(--mcd-yellow);
            color: var(--mcd-dark);
            border-radius: 50%;
            width: 18px;
            height: 18px;
            font-size: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }

        .product-card {
            border: none;
            border-radius: 10px;
            overflow: hidden;
            transition: transform 0.3s;
            margin-bottom: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            background-color: var(--mcd-light);
            border: 1px solid #f0f0f0;
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(218, 41, 28, 0.2);
        }

        .product-img-container {
            height: 200px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #f8f9fa;
            padding: 15px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        }

        .product-img {
            max-height: 100%;
            max-width: 100%;
            object-fit: contain;
        }

        .product-name {
            font-weight: 600;
            color: var(--mcd-dark);
            margin: 10px 0;
            height: 50px;
            overflow: hidden;
            font-size: 16px;
        }

        .product-price {
            color: var(--mcd-red);
            font-weight: bold;
            font-size: 18px;
        }

        .btn-details, .btn-buy {
            width: 100%;
            padding: 10px;
            border-radius: 30px;
            margin-top: 10px;
            border: none;
            color: white;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all 0.3s;
        }

        .btn-details {
            background-color: var(--mcd-dark);
        }

        .btn-details:hover {
            background-color: #3a3833;
            color: white;
        }

        .btn-buy {
            background-color: var(--mcd-yellow);
            color: var(--mcd-dark);
        }

        .btn-buy:hover {
            background-color: #ffb700;
            color: var(--mcd-dark);
        }

        .page-title {
            color: var(--mcd-red);
            text-align: center;
            margin: 30px 0;
            font-weight: bold;
            text-transform: uppercase;
        }

        .mcd-footer {
            background-color: var(--mcd-dark);
            color: var(--mcd-light);
            padding: 30px 0;
            margin-top: 50px;
        }

        .mcd-logo-text {
            font-family: 'Helvetica Neue', Arial, sans-serif;
            font-weight: bold;
            font-size: 24px;
            color: var(--mcd-yellow);
        }
    </style>
</head>
<body>

<!-- Header -->
<nav class="navbar navbar-expand-lg">
    <div class="container">
        <a class="navbar-brand" href="inicio">
            <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/McDonald%27s_Golden_Arches.svg/1200px-McDonald%27s_Golden_Arches.svg.png" alt="McDonald's Logo">
            <span class="mcd-logo-text">McDonald's</span>
        </a>
        <div class="nav-icons">
            <a href="login.html" class="login-link">Faça login / Cadastre-se</a>
            <a href="carrinho.jsp" class="cart-icon">
                <i class="fas fa-shopping-cart"></i>
                <span class="cart-count" id="cart-count">0</span>
            </a>
        </div>
    </div>
</nav>

<!-- Conteúdo Principal -->
<div class="container my-5">
    <h1 class="page-title">Nossos Produtos</h1>
    <div class="row">
        <% if (produtos != null && !produtos.isEmpty()) {
            for (Produto produto : produtos) { %>
            <div class="col-md-4 col-lg-3">
                <div class="product-card card">
                    <div class="product-img-container">
                        <% 
                            List<String> imagens = produto.getImagens();
                            if (imagens != null && !imagens.isEmpty()) { 
                        %>
                            <img src="data:image/jpeg;base64,<%= imagens.get(0) %>" class="product-img" alt="<%= produto.getNome() %>">
                        <% 
                            } else { 
                        %>
                            <img src="https://via.placeholder.com/150" class="product-img" alt="<%= produto.getNome() %>">
                        <% 
                            } 
                        %>
                    </div>
                    <div class="card-body">
                        <h5 class="product-name"><%= produto.getNome()%></h5>
                        <p class="product-price">R$ <%= String.format("%.2f", produto.getValor())%></p>

                        <a href="visualizar_produto_loja.jsp?id=<%= produto.getId()%>" class="btn btn-details">Ver Detalhes</a>

                        <button class="btn btn-buy" onclick="addToCart(<%= produto.getId()%>, '<%= produto.getNome()%>', <%= produto.getValor()%>, 1)">
                            Comprar Agora
                        </button>
                    </div>
                </div>
            </div>
        <% }} else { %>
            <div class="col-12">
                <p class="text-center">Nenhum produto disponível no momento.</p>
            </div>
        <% } %>
    </div>
</div>

<!-- Rodapé -->
<footer class="mcd-footer">
    <div class="container text-center">
        <p>© 2023 McDonald's. Todos os direitos reservados.</p>
        <p>Siga-nos nas redes sociais:</p>
        <div class="social-icons">
            <a href="#" class="text-white mx-2"><i class="fab fa-facebook-f"></i></a>
            <a href="#" class="text-white mx-2"><i class="fab fa-instagram"></i></a>
            <a href="#" class="text-white mx-2"><i class="fab fa-twitter"></i></a>
        </div>
    </div>
</footer>

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
        
        // Notificação estilo McDonald's
        const notification = document.createElement('div');
        notification.style.position = 'fixed';
        notification.style.bottom = '20px';
        notification.style.right = '20px';
        notification.style.backgroundColor = '#FFC72C';
        notification.style.color = '#27251F';
        notification.style.padding = '15px 25px';
        notification.style.borderRadius = '30px';
        notification.style.boxShadow = '0 4px 8px rgba(0,0,0,0.2)';
        notification.style.zIndex = '1000';
        notification.style.fontWeight = 'bold';
        notification.innerHTML = `<i class="fas fa-check-circle"></i> ${nome} adicionado ao carrinho!`;
        
        document.body.appendChild(notification);
        
        setTimeout(() => {
            notification.style.transition = 'opacity 0.5s';
            notification.style.opacity = '0';
            setTimeout(() => notification.remove(), 500);
        }, 3000);
    }

    document.addEventListener('DOMContentLoaded', updateCartCount);
</script>

</body>
</html>