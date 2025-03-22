<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="utils.ConexaoDB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Alterar Produto</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 400px;
        }
        h1 {
            font-size: 24px;
            margin-bottom: 20px;
            color: #333;
            text-align: center;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
        }
        input[type="text"], input[type="number"], textarea {
            width: 100%;
            padding: 8px;
            margin-bottom: 12px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
        }
        textarea {
            resize: vertical;
            height: 80px;
        }
        button {
            width: 100%;
            padding: 10px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
        .cancel-button {
            background-color: #dc3545;
            margin-top: 10px;
        }
        .cancel-button:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Alterar Produto</h1>
        <%
            Connection conecta = null;
            PreparedStatement st = null;
            ResultSet rs = null;

            try {
                // Obter conexão utilizando a classe ConexaoDB
                conecta = ConexaoDB.getConnection();

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

            <label for="nome">NOME DO PRODUTO:</label>
            <input type="text" id="nome" name="nome" value="<%= rs.getString("nome") %>" required>

            <label for="preco">PREÇO:</label>
            <input type="number" id="preco" name="preco" step="0.01" value="<%= rs.getString("preco") %>" required>

            <label for="estoque">EM ESTOQUE:</label>
            <input type="number" id="estoque" name="estoque" value="<%= rs.getString("quantidade_estoque") %>" required>

            <label for="descricao">DESCRIÇÃO DETALHADA:</label>
            <textarea id="descricao" name="descricao" required><%= rs.getString("descricao") %></textarea>

            <label for="avaliacao">AVALIAÇÃO:</label>
            <input type="number" id="avaliacao" name="avaliacao" min="1" max="5" value="<%= rs.getString("avaliacao") %>" required>

            <button type="submit">Atualizar Produto</button>
            <button type="button" class="cancel-button" onclick="window.location.href='lista_produtos.jsp'">Cancelar</button>
        </form>
        <%
                } else {
                    out.print("Produto não encontrado.");
                }
            } catch (Exception e) {
                out.print("Erro: " + e.getMessage());
            } finally {
                if (rs != null) rs.close();
                if (st != null) st.close();
                if (conecta != null) conecta.close();
            }
        %>
    </div>
</body>
</html>
