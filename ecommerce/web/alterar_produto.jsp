<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Alterar Produto</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
            }
            h1 {
                color: #333;
            }
            form {
                max-width: 500px;
                margin: 0 auto;
            }
            label {
                display: block;
                margin-bottom: 8px;
                font-weight: bold;
            }
            input[type="text"], input[type="number"], textarea {
                width: 100%;
                padding: 8px;
                margin-bottom: 12px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }
            button {
                padding: 10px 20px;
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }
            button:hover {
                background-color: #0056b3;
            }
        </style>
    </head>
    <body>
        <h1>Alterar Produto</h1>
        <%
            // Fazer conexão com o BD
            Connection conecta = null;
            PreparedStatement st = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conecta = DriverManager.getConnection("jdbc:mysql://sql10.freesqldatabase.com:3306/sql10766514", "sql10766514", "swipjfdGjA");

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
            <input type="number" id="preco" name="preco" step="0.01" value="<%= rs.getString("valor") %>" required>

            <label for="estoque">Quantidade em Estoque:</label>
            <input type="number" id="estoque" name="estoque" value="<%= rs.getString("quantidade_estoque") %>" required>

            <label for="descricao">Descrição:</label>
            <textarea id="descricao" name="descricao" required><%= rs.getString("descricao") %></textarea>

            <label for="avaliacao">Avaliação:</label>
            <input type="number" id="avaliacao" name="avaliacao" min="1" max="5" value="<%= rs.getString("avaliacao") %>" required>

            <button type="submit">Atualizar Produto</button>
        </form>
        <%
                } else {
                    out.print("Produto não encontrado.");
                }
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