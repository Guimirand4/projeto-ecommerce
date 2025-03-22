<%@page import="java.sql.*" %>
<%@page import="utils.ConexaoDB" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Alterar Status do Produto</title>
</head>
<body>
    <%
        int id = Integer.parseInt(request.getParameter("id"));
        int status = Integer.parseInt(request.getParameter("status"));

        Connection conecta = null;
        PreparedStatement st = null;

        try {
            // Usando a classe ConexaoDB para obter a conexão com o banco
            conecta = ConexaoDB.getConnection();

            // Atualiza o status do produto na tabela "produtos"
            String sql = "UPDATE produtos SET status = ? WHERE id = ?";
            st = conecta.prepareStatement(sql);
            st.setInt(1, status);
            st.setInt(2, id);

            int resultado = st.executeUpdate();
            if (resultado > 0) {
                out.println("<p>Status do produto alterado com sucesso!</p>");
            } else {
                out.println("<p>Erro ao alterar o status do produto.</p>");
            }
        } catch (Exception e) {
            out.println("<p>Erro: " + e.getMessage() + "</p>");
        } finally {
            // Fechando os recursos
            if (st != null) try { st.close(); } catch (SQLException e) {}
            if (conecta != null) try { conecta.close(); } catch (SQLException e) {}
        }
    %>

    <br>
    <a href="lista_produtos.jsp">Voltar para a lista de produtos</a>
</body>
</html>
