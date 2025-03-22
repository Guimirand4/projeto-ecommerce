<%@page import="utils.Produto"%>
<%@page import="java.util.List"%>
<%
    // Verificar se a lista de produtos já foi passada. Se não, redirecionar para o servlet.
    List<Produto> produtos = (List<Produto>) request.getAttribute("produtos");
    if (produtos == null || produtos.isEmpty()) {
        response.sendRedirect("ListarProdutosServlet");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Produtos</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #eaf7f7;
            text-align: center;
        }
        .container {
            width: 80%;
            margin: 20px auto;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            color: #FFC107;
        }
        .search-container {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
        }
        .search-container input {
            width: 300px;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .search-container button {
            background-color: #FFC107;
            border: none;
            padding: 10px 15px;
            margin-left: 5px;
            cursor: pointer;
            border-radius: 4px;
        }
        .search-container button i {
            color: white;
        }
        .btn-novo-produto {
            background-color: #28a745;
            border: none;
            padding: 10px 15px;
            margin-left: 5px;
            cursor: pointer;
            border-radius: 4px;
            color: white;
            text-decoration: none;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px;
            text-align: left;
            border: 1px solid #ddd;
        }
        th {
            background-color: #00A5A5;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #ddd;
        }
        .btn {
            padding: 5px 10px;
            border-radius: 4px;
            text-decoration: none;
            color: white;
            font-size: 14px;
            margin-right: 5px;
        }
        .btn-alterar {
            background-color: #FFC107;
        }
        .btn-visualizar {
            background-color: #00A5A5;
        }
        .btn-ativar-desativar {
            background-color: #dc3545;
        }
        .btn-excluir {
            background-color: #dc3545;
        }
        .btn-excluir:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Lista de Produtos</h1>

        <div class="search-container">
            <form method="get" action="ListarProdutosServlet">
                <input type="text" name="busca" placeholder="Buscar por nome...">
                <button type="submit"><i class="fas fa-search"></i></button>
            </form>
            <a href="cadastroProdutos.html" class="btn-novo-produto">+ Novo Produto</a>
        </div>

        <table>
            <thead>
                <tr>
                    <th>Código</th>
                    <th>Nome</th>
                    <th>Quantidade</th>
                    <th>Valor</th>
                    <th>Status</th>
                    <th>Opções</th>
                </tr>
            </thead>
            <tbody>
                <% if (produtos != null && !produtos.isEmpty()) {
                    for (Produto produto : produtos) { %>
                        <tr>
                            <td><%= produto.getId() %></td>
                            <td><%= produto.getNome() %></td>
                            <td><%= produto.getQuantidadeEstoque() %></td>
                            <td>R$ <%= String.format("%.2f", produto.getValor()) %></td>
                            <td><%= produto.getStatus() %></td>
                            <td>
                                <a href="alterar_produto.jsp?id=<%= produto.getId() %>" class="btn btn-alterar">Alterar</a>
                                <a href="visualizar_produto.jsp?id=<%= produto.getId() %>" class="btn btn-visualizar">Visualizar</a>
                                <!-- Botão para alterar o status: se o produto está ativo (1) mostra "Inativar", caso contrário "Ativar" -->
                         <a href="alterar_status_produto.jsp?id=<%= produto.getId() %>&status=<%= (produto.getStatus().equals("1") ? 0 : 1) %>" class="btn btn-ativar-desativar">
    <%= (produto.getStatus().equals("1") ? "Inativar" : "Ativar") %>
</a>

                            </td>
                        </tr>
                <% }} else { %>
                    <tr>
                        <td colspan="6">Nenhum produto encontrado.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>
