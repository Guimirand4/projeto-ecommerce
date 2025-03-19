<%@ page import="java.sql.*, utils.ConexaoDB" %>
<%
    Connection conexao = null;
    try {
        conexao = ConexaoDB.getConnection();
        out.println("<h3 style='color: green;'>Conex�o bem-sucedida com o banco AWS RDS!</h3>");
    } catch (Exception e) {
        out.println("<h3 style='color: red;'>Erro na conex�o: " + e.getMessage() + "</h3>");
        e.printStackTrace(); // Exibe erro completo no log do servidor (�til para debug)
    } finally {
        if (conexao != null) {
            try {
                conexao.close(); // Fechar conex�o com seguran�a
            } catch (SQLException e) {
                out.println("<h3 style='color: red;'>Erro ao fechar conex�o: " + e.getMessage() + "</h3>");
            }
        }
    }
%>
