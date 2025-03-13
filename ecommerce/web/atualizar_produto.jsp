<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Atualizar Produto</title>
</head>
<body>
    <%
        // Conexão com o banco de dados
        Connection conecta = null;
        PreparedStatement st = null;

        try {
            // Carregar o driver do MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Conectar ao banco de dados
            conecta = DriverManager.getConnection("jdbc:mysql://sql10.freesqldatabase.com:3306/sql10766514", "sql10766514", "swipjfdGjA");

            // Capturar os dados do formulário
            String id = request.getParameter("id");
            String nome = request.getParameter("nome");
            String preco = request.getParameter("preco");
            String estoque = request.getParameter("estoque");
            String descricao = request.getParameter("descricao");
            String avaliacao = request.getParameter("avaliacao");

            // Consulta SQL para atualizar o produto
            String sql = "UPDATE produtos SET nome = ?, preco = ?, quantidade_estoque = ?, descricao = ?, avaliacao = ? WHERE id = ?";
            st = conecta.prepareStatement(sql);
            st.setString(1, nome);
            st.setString(2, preco);
            st.setString(3, estoque);
            st.setString(4, descricao);
            st.setString(5, avaliacao);
            st.setString(6, id);

            // Executar a atualização
            int rowsUpdated = st.executeUpdate();

            if (rowsUpdated > 0) {
                out.print("Produto atualizado com sucesso!");
            } else {
                out.print("Falha ao atualizar o produto.");
            }
        } catch (Exception e) {
            out.print("Erro: " + e.getMessage());
        } finally {
            // Fechar os recursos
            if (st != null) st.close();
            if (conecta != null) conecta.close();
        }
    %>
    <br>
    <a href="lista_produtos.jsp">Voltar para a lista de produtos</a>
</body>
</html>
