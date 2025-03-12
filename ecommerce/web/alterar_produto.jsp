<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Alterar Produto</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* Estilos CSS omitidos para brevidade */
    </style>
</head>
<body>
    <div class="container">
        <h1>Alterar Produto</h1>
        <%
            // Conexão com o banco de dados
            Connection conecta = null;
            PreparedStatement st = null;
            ResultSet rs = null;

            try {
                // Carregar o driver do MySQL
                Class.forName("com.mysql.cj.jdbc.Driver");

                // Conectar ao banco de dados
                conecta = DriverManager.getConnection("jdbc:mysql://sql10.freesqldatabase.com:3306/sql10766514", "sql10766514", "swipjfdGjA");

                // Capturar o ID do produto passado como parâmetro
                String id = request.getParameter("id");

                // Consulta SQL para buscar o produto pelo ID
                String sql = "SELECT * FROM produtos WHERE id = ?";
                st = conecta.prepareStatement(sql);
                st.setString(1, id);
                rs = st.executeQuery();

                if (rs.next()) {
        %>
        <form method="post" action="atualizar_produto.jsp">
            <input type="hidden" name="id" value="<%= rs.getString("id") %>">

            <label for="nome">Nome do Produto:</label>
            <input type="text" id="nome" name="nome" value="<%= rs.getString("nome") %>" required>

            <label for="preco">Preço:</label>
            <input type="number" id="preco" name="preco" step="0.01" value="<%= rs.getString("preco") %>" required>

            <label for="estoque">Quantidade em Estoque:</label>
            <input type="number" id="estoque" name="estoque" value="<%= rs.getString("quantidade_estoque") %>" required>

            <label for="descricao">Descrição:</label>
            <textarea id="descricao" name="descricao" required><%= rs.getString("descricao") %></textarea>

            <label for="avaliacao">Avaliação:</label>
            <input type="number" id="avaliacao" name="avaliacao" min="1" max="5" value="<%= rs.getString("avaliacao") %>" required>

            <button type="submit">Atualizar Produto</button>
            <button type="button" class="cancel-button" onclick="window.location.href='index.jsp'">Cancelar</button>
        </form>
        <%
                } else {
                    out.print("Produto não encontrado.");
                }
            } catch (Exception e) {
                out.print("Erro: " + e.getMessage());
            } finally {
                // Fechar os recursos
                if (rs != null) rs.close();
                if (st != null) st.close();
                if (conecta != null) conecta.close();
            }
        %>
    </div>
</body>
</html>