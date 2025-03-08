<%@page import="java.sql.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String url = "jdbc:mysql://sql10.freesqldatabase.com:3306/sql10766514";
    String user = "sql10766514";
    String password = "swipjfdGjA";

    Connection conecta = null;
    PreparedStatement st = null;
    ResultSet rs = null;

    try {
        // Carregar o driver do MySQL
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Estabelecer a conexão
        conecta = DriverManager.getConnection(url, user, password);

        // Consulta SQL para selecionar os usuários
        String sql = "SELECT id, nome, email, grupo, status FROM usuarios";
        st = conecta.prepareStatement(sql);

        // Executar a consulta e obter os resultados
        rs = st.executeQuery();

        // Iterar sobre os resultados
        while (rs.next()) {
            int id = rs.getInt("id");
            String nome = rs.getString("nome");
            String email = rs.getString("email");
            String grupo = rs.getString("grupo");
            String status = rs.getInt("status") == 1 ? "Ativo" : "Inativo";

            out.println("<tr>");
            out.println("<td>" + nome + "</td>");
            out.println("<td>" + email + "</td>");
            out.println("<td>" + grupo + "</td>");
            out.println("<td>" + status + "</td>");
            out.println("<td>");
            // Botão para editar
            out.println("<button onclick='editarUsuario(" + id + ", \"" + nome + "\", \"" + email + "\", \"" + grupo + "\")'>Editar</button>");
            
            // Botão para alterar o status (Ativar/Desativar)
            out.println("<button onclick='alterarStatus(" + id + ", " + (status.equals("Ativo") ? "0" : "1") + ")'>" + (status.equals("Ativo") ? "Desativar" : "Ativar") + "</button>");
            out.println("</td>");
            out.println("</tr>");
        }
    } catch (Exception e) {
        out.println("<p>Erro: " + e.getMessage() + "</p>");
    } finally {
        // Fechar os recursos
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (st != null) try { st.close(); } catch (SQLException e) {}
        if (conecta != null) try { conecta.close(); } catch (SQLException e) {}
    }
%>
