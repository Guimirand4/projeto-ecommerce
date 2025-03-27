<%@ page import="java.sql.*, java.util.ArrayList, java.util.List" %>
<%@ page import="utils.ConexaoDB" %>
<%
    // Recupera o id do produto passado via parâmetro
    int id = Integer.parseInt(request.getParameter("id"));

    Connection con = null;
    PreparedStatement psProd = null;
    PreparedStatement psImg = null;
    ResultSet rsProd = null;
    ResultSet rsImg = null;

    // Variáveis para armazenar os dados do produto
    String nome = "";
    String descricao = "";
    double preco = 0;
    int quantidade = 0;
    double avaliacao = 0;
    int status = 0;
    List<String> imagens = new ArrayList<>();

    try {
        con = ConexaoDB.getConnection();

        // Consulta os dados do produto
        String sqlProd = "SELECT * FROM produtos WHERE id = ?";
        psProd = con.prepareStatement(sqlProd);
        psProd.setInt(1, id);
        rsProd = psProd.executeQuery();
        if (rsProd.next()){
            nome = rsProd.getString("nome");
            descricao = rsProd.getString("descricao");
            preco = rsProd.getDouble("preco");
            quantidade = rsProd.getInt("quantidade_estoque");
            avaliacao = rsProd.getDouble("avaliacao");
            status = rsProd.getInt("status");
        }

        // Consulta as imagens do produto (coluna 'imagem')
        String sqlImg = "SELECT imagem FROM produto_imagens WHERE produto_id = ?";
        psImg = con.prepareStatement(sqlImg);
        psImg.setInt(1, id);
        rsImg = psImg.executeQuery();
        while (rsImg.next()){
            String img = rsImg.getString("imagem");
            imagens.add(img);
        }
    } catch (Exception e) {
        out.println("Erro: " + e.getMessage());
    } finally {
        if (rsImg != null) try { rsImg.close(); } catch (SQLException ignore) {}
        if (psImg != null) try { psImg.close(); } catch (SQLException ignore) {}
        if (rsProd != null) try { rsProd.close(); } catch (SQLException ignore) {}
        if (psProd != null) try { psProd.close(); } catch (SQLException ignore) {}
        if (con != null) try { con.close(); } catch (SQLException ignore) {}
    }
%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Detalhes do Produto</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Bundle com JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        body {
            background-color: #f0f2f5;
        }
        .product-details {
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        /* Tratamento para as imagens do carrossel */
        .carousel-item img {
            max-height: 350px;
            width: auto;
            max-width: 100%;
            object-fit: contain;
            margin: auto;
        }
        .btn-voltar {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
       <div class="row justify-content-center">
            <div class="col-md-10">
                <!-- Dados do Produto -->
                <div class="product-details mb-4">
                    <h1 class="mb-3"><%= nome %></h1>
                    <p><strong>Descrição:</strong> <%= descricao %></p>
                    <p><strong>Preço:</strong> R$ <%= String.format("%.2f", preco) %></p>
                    <p><strong>Quantidade em Estoque:</strong> <%= quantidade %></p>
                    <p><strong>Avaliação:</strong> <%= avaliacao %> / 5</p>
                    <p><strong>Status:</strong> <%= (status == 1 ? "Ativo" : "Inativo") %></p>
                </div>

                <!-- Carrossel de Imagens -->
                <div id="produtoCarousel" class="carousel slide mb-4" data-bs-ride="carousel">
                    <div class="carousel-indicators">
                        <% for (int i = 0; i < imagens.size(); i++) { %>
                            <button type="button" data-bs-target="#produtoCarousel" data-bs-slide-to="<%= i %>" class="<%= (i == 0 ? "active" : "") %>" aria-current="<%= (i == 0 ? "true" : "") %>" aria-label="Slide <%= (i + 1) %>"></button>
                        <% } %>
                    </div>
                    <div class="carousel-inner">
                        <% for (int i = 0; i < imagens.size(); i++) {
                             String img = imagens.get(i);
                        %>
                            <div class="carousel-item <%= (i == 0 ? "active" : "") %>">
                                <img src="data:image/jpeg;base64,<%= img %>" class="d-block w-100" alt="Imagem do produto">
                            </div>
                        <% } %>
                    </div>
                    <button class="carousel-control-prev" type="button" data-bs-target="#produtoCarousel" data-bs-slide="prev">
                        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                        <span class="visually-hidden">Anterior</span>
                    </button>
                    <button class="carousel-control-next" type="button" data-bs-target="#produtoCarousel" data-bs-slide="next">
                        <span class="carousel-control-next-icon" aria-hidden="true"></span>
                        <span class="visually-hidden">Próximo</span>
                    </button>
                </div>

                <!-- Botão Comprar com função addToCart -->
                <div class="mb-4">
                    <button type="button" class="btn btn-primary"
                        onclick="addToCart(<%= id %>, '<%= nome %>', <%= preco %>, 1)">
                        Comprar
                    </button>
                </div>

                <!-- Botão Voltar -->
                <div class="btn-voltar">
                    <a href="inicio" class="btn btn-secondary">Voltar</a>
                </div>
            </div>
       </div>
    </div>

    <!-- Funções JavaScript para o carrinho -->
    <script>
        function updateCartCount() {
            let cart = JSON.parse(localStorage.getItem('cart')) || [];
            let count = 0;
            cart.forEach(item => count += item.quantidade);
            // Se houver um elemento para exibir a contagem do carrinho, atualize-o aqui
            // Exemplo: document.getElementById('cart-count').textContent = count;
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
