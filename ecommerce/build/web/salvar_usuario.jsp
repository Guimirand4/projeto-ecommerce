<%@page import="java.sql.*, org.mindrot.jbcrypt.BCrypt, utils.CPFUtils" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Cadastro de Usuário</title>
</head>
<body>
    <%
        String nome = request.getParameter("nome");
        String cpf = request.getParameter("cpf");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        String grupo = request.getParameter("grupo");

        // Verificar se o CPF é válido antes de continuar
        if (!CPFUtils.validarCPF(cpf)) {
            out.println("<p style='color: red;'>CPF inválido! Insira um CPF válido.</p>");
            return;
        }

        // Hash da senha usando Bcrypt
        String senhaHash = BCrypt.hashpw(senha, BCrypt.gensalt());

        String url = "jdbc:sqlite:" + application.getRealPath("/WEB-INF/ecommerce.sqlite");
        Connection conecta = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            Class.forName("org.sqlite.JDBC");
            conecta = DriverManager.getConnection(url);
            conecta.setAutoCommit(false);

            // Verificar se o CPF já existe no banco de dados
            String sqlCheck = "SELECT COUNT(*) FROM usuarios WHERE cpf = ?";
            st = conecta.prepareStatement(sqlCheck);
            st.setString(1, cpf);
            rs = st.executeQuery();
            rs.next();
            int count = rs.getInt(1);

            if (count > 0) {
                out.println("<p style='color: red;'>Erro: CPF já cadastrado!</p>");
                return;
            }

            // Fechar a consulta anterior
            rs.close();
            st.close();

            // Inserir o novo usuário no banco de dados
            String sqlInsert = "INSERT INTO usuarios (nome, cpf, email, senha, grupo) VALUES (?, ?, ?, ?, ?)";
            st = conecta.prepareStatement(sqlInsert);
            st.setString(1, nome);
            st.setString(2, cpf);
            st.setString(3, email);
            st.setString(4, senhaHash);
            st.setString(5, grupo);

            int resultado = st.executeUpdate();
            conecta.commit();

            if (resultado > 0) {
                out.println("<p style='color: green;'>Usuário cadastrado com sucesso!</p>");
            } else {
                out.println("<p style='color: red;'>Erro ao cadastrar usuário.</p>");
            }
        } catch (Exception e) {
            out.println("<p style='color: red;'>Erro: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (st != null) try { st.close(); } catch (SQLException e) {}
            if (conecta != null) try { conecta.close(); } catch (SQLException e) {}
        }
    %>
    <a href="cadastro.html">Voltar</a>
</body>
</html>
