<%@page import="java.sql.*, org.mindrot.jbcrypt.BCrypt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Autenticação</title>
</head>
<body>
    <%
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

     String url = "jdbc:mysql://sql10.freesqldatabase.com:3306/sql10766514";
        String user = "sql10766514";
        String password = "swipjfdGjA";

        Connection conecta = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            // Carrega o driver do MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
             conecta = DriverManager.getConnection(url, user, password);
            // Buscar o usuário pelo email
            String sql = "SELECT senha, grupo FROM usuarios WHERE email = ?";
            st = conecta.prepareStatement(sql);
            st.setString(1, email);
            rs = st.executeQuery();

            if (rs.next()) {
                String senhaHash = rs.getString("senha");
                String grupo = rs.getString("grupo");

                // Verificar se a senha digitada corresponde ao hash armazenado
                if (BCrypt.checkpw(senha, senhaHash)) {
                    // Redireciona para a página conforme o grupo
                    if ("admin".equals(grupo)) {
                        response.sendRedirect("admin.html");
                    } else if ("estoquista".equals(grupo)) {
                        response.sendRedirect("estoquista.html");
                    } else {
                        out.println("<p style='color: red;'>Erro: Grupo desconhecido!</p>");
                    }
                } else {
                    out.println("<p style='color: red;'>Senha incorreta! Tente novamente.</p>");
                }
            } else {
                out.println("<p style='color: red;'>Email não encontrado!</p>");
            }
        } catch (Exception e) {
            out.println("<p style='color: red;'>Erro: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (st != null) try { st.close(); } catch (SQLException e) {}
            if (conecta != null) try { conecta.close(); } catch (SQLException e) {}
        }
    %>
    <a href="login.html">Voltar ao Login</a>
</body>
</html>
