<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Listagem de Produtos</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
            }
            h1 {
                color: #333;
            }
            .search-container {
                margin-bottom: 20px;
            }
            .search-container input[type="text"] {
                padding: 8px;
                width: 300px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }
            .search-container button {
                padding: 8px 12px;
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }
            .search-container button:hover {
                background-color: #0056b3;
            }
            .new-product-link {
                display: inline-block;
                margin-bottom: 20px;
                padding: 8px 12px;
                background-color: #28a745;
                color: white;
                text-decoration: none;
                border-radius: 4px;
            }
            .new-product-link:hover {
                background-color: #218838;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 20px;
            }
            table, th, td {
                border: 1px solid #ddd;
            }
            th, td {
                padding: 12px;
                text-align: left;
            }
            th {
                background-color: #f8f9fa;
            }
            tr:nth-child(even) {
                background-color: #f9f9f9;
            }
            tr:hover {
                background-color: #f1f1f1;
            }
            .actions a {
                margin-right: 10px;
                color: #007bff;
                text-decoration: none;
            }
            .actions a:hover {
                text-decoration: underline;
            }
            .pagination {
                margin-top: 20px;
            }
            .pagination a {
                margin: 0 5px;
                text-decoration: none;
                color: #007bff;
            }
            .pagination a.active {
                font-weight: bold;
                color: #000;
            }
        </style>
    </head>
    <body>
        <h1>Lista de Produtos</h1>
        <div class="search-container">
            <form method="get" action="">
                <input type="text" name="busca" placeholder="Buscar por nome..." value="<%= request.getParameter("busca") != null ? request.getParameter("busca") : "" %>">
                <button type="submit">Buscar</button>
            </form>
        </div>
        <a href="cadastroProdutos.html" class="new-product-link">+ Novo Produto</a>
        <%
            // Fazer conexão com o BD
            Connection conecta = null;
            PreparedStatement st = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conecta = DriverManager.getConnection("jdbc:mysql://sql10.freesqldatabase.com:3306/sql10766514", "sql10766514", "swipjfdGjA");

                // Parâmetros de paginação e busca
                int paginaAtual = 1;
                int produtosPorPagina = 10;
                String busca = request.getParameter("busca");

                if (request.getParameter("pagina") != null) {
                    paginaAtual = Integer.parseInt(request.getParameter("pagina"));
                }

                // Consulta SQL com busca e paginação
                String sql = "SELECT * FROM produtos WHERE nome LIKE ? ORDER BY id DESC LIMIT ?, ?";
                st = conecta.prepareStatement(sql);
                st.setString(1, "%" + busca + "%");
                st.setInt(2, (paginaAtual - 1) * produtosPorPagina);
                st.setInt(3, produtosPorPagina);
                rs = st.executeQuery();
        %>
        <table>
            <tr>
                <th>Código</th>
                <th>Nome</th>
                <th>Quantidade em Estoque</th>
                <th>Valor</th>
                <th>Status</th>
                <th>Opções</th>
            </tr>
            <%
                while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getString("id") %></td>
                <td><%= rs.getString("nome") %></td>
                <td><%= rs.getString("quantidade_estoque") %></td>
                <td><%= rs.getString("valor") %></td>
                <td><%= rs.getString("status") %></td>
                <td class="actions">
                    <a href="alterar_produto.jsp?id=<%= rs.getString("id") %>"><i class="fas fa-edit"></i> Alterar</a>
                    <a href="visualizar_produto.jsp?id=<%= rs.getString("id") %>"><i class="fas fa-eye"></i> Visualizar</a>
                    <a href="inativar_produto.jsp?id=<%= rs.getString("id") %>"><i class="fas fa-ban"></i> Inativar</a>
                </td>
            </tr>
            <%
                }
            %>
        </table>

        <!-- Paginação -->
        <div class="pagination">
            <%
                // Contar total de produtos para paginação
                String sqlCount = "SELECT COUNT(*) AS total FROM produtos WHERE nome LIKE ?";
                PreparedStatement stCount = conecta.prepareStatement(sqlCount);
                stCount.setString(1, "%" + busca + "%");
                ResultSet rsCount = stCount.executeQuery();
                rsCount.next();
                int totalProdutos = rsCount.getInt("total");
                int totalPaginas = (int) Math.ceil((double) totalProdutos / produtosPorPagina);

                for (int i = 1; i <= totalPaginas; i++) {
                    if (i == paginaAtual) {
                        out.print("<a class='active' href='?pagina=" + i + "&busca=" + busca + "'>" + i + "</a>");
                    } else {
                        out.print("<a href='?pagina=" + i + "&busca=" + busca + "'>" + i + "</a>");
                    }
                }
            %>
        </div>
        <%
            } catch (Exception x) {
                out.print("Mensagem de erro: " + x.getMessage());
            } finally {
                // Fechar os recursos
                if (rs != null) rs.close();
                if (st != null) st.close();
                if (conecta != null) conecta.close();
            }
        %>
    </body>
</html>