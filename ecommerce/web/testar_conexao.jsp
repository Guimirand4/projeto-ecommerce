<%@ page import="java.sql.*, utils.ConexaoDB" %>
<%
    Connection conexao = null;
    try {
        conexao = ConexaoDB.getConnection();
        out.println("<h3 style='color: green;'>Conexão bem-sucedida com o banco AWS RDS!</h3>");
    } catch (Exception e) {
        out.println("<h3 style='color: red;'>Erro na conexão: " + e.getMessage() + "</h3>");
        e.printStackTrace(); // Exibe erro completo no log do servidor (útil para debug)
    } finally {
        if (conexao != null) {
            try {
                conexao.close(); // Fechar conexão com segurança
            } catch (SQLException e) {
                out.println("<h3 style='color: red;'>Erro ao fechar conexão: " + e.getMessage() + "</h3>");
            }
        }
    }
%>
