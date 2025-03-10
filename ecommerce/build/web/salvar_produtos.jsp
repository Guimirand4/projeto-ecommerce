<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.io.File"%>
<%@page import="java.util.UUID"%>
<%@page import="java.sql.*"%>
<%@page import="java.net.URLEncoder"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Configurações de upload
    String uploadPath = getServletContext().getRealPath("/uploads");
    if (uploadPath != null) {
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();
    } else {
        response.sendRedirect("erro.jsp?mensagem=" + URLEncoder.encode("Caminho de upload inválido.", "UTF-8"));
        return;
    }

    DiskFileItemFactory factory = new DiskFileItemFactory();
    ServletFileUpload upload = new ServletFileUpload(factory);

    // Variáveis do formulário
    String nome = "", descricao = "";
    double preco = 0, avaliacao = 0;
    int quantidade = 0;
    List<String> imagens = new ArrayList<>();

    Connection conecta = null;
    PreparedStatement stProduto = null;
    PreparedStatement stImagem = null;
    ResultSet rs = null;

    try {
        List<FileItem> items = upload.parseRequest(request);

        for (FileItem item : items) {
            if (item.isFormField()) {
                switch (item.getFieldName()) {
                    case "nome":
                        nome = item.getString("UTF-8");
                        break;
                    case "descricao":
                        descricao = item.getString("UTF-8");
                        break;
                    case "preco":
                        try {
                            preco = Double.parseDouble(item.getString("UTF-8"));
                        } catch (NumberFormatException e) {
                            preco = 0;
                        }
                        break;
                    case "quantidade":
                        try {
                            quantidade = Integer.parseInt(item.getString("UTF-8"));
                        } catch (NumberFormatException e) {
                            quantidade = 0;
                        }
                        break;
                    case "avaliacao":
                        try {
                            avaliacao = Double.parseDouble(item.getString("UTF-8"));
                        } catch (NumberFormatException e) {
                            avaliacao = 0;
                        }
                        break;
                }
            } else {
                if (!item.getName().isEmpty()) {
                    String fileName = UUID.randomUUID().toString() + "_" + new File(item.getName()).getName();
                    File storeFile = new File(uploadPath + File.separator + fileName);
                    item.write(storeFile);
                    imagens.add(fileName);
                }
            }
        }

        Class.forName("com.mysql.cj.jdbc.Driver");
        conecta = DriverManager.getConnection("jdbc:mysql://sql10.freesqldatabase.com:3306/sql10766514", "sql10766514", "swipjfdGjA");

        String sqlProduto = "INSERT INTO produtos (nome, descricao, preco, quantidade_estoque, avaliacao, status) VALUES (?, ?, ?, ?, ?, 'Ativo')";
        stProduto = conecta.prepareStatement(sqlProduto, PreparedStatement.RETURN_GENERATED_KEYS);
        stProduto.setString(1, nome);
        stProduto.setString(2, descricao);
        stProduto.setDouble(3, preco);
        stProduto.setInt(4, quantidade);
        stProduto.setDouble(5, avaliacao);
        stProduto.executeUpdate();

        rs = stProduto.getGeneratedKeys();
        int produtoId = 0;
        if (rs.next()) {
            produtoId = rs.getInt(1);
        }

        if (!imagens.isEmpty()) {
            String sqlImagem = "INSERT INTO produto_imagens (produto_id, caminho_imagem) VALUES (?, ?)";
            stImagem = conecta.prepareStatement(sqlImagem);
            for (String imagem : imagens) {
                stImagem.setInt(1, produtoId);
                stImagem.setString(2, imagem);
                stImagem.executeUpdate();
            }
        }

        response.sendRedirect("listar_produtos.jsp");
    } catch (Exception e) {
        response.sendRedirect("erro.jsp?mensagem=" + URLEncoder.encode("Erro ao cadastrar produto: " + e.getMessage(), "UTF-8"));
    } finally {
        try {
            if (rs != null) rs.close();
            if (stProduto != null) stProduto.close();
            if (stImagem != null) stImagem.close();
            if (conecta != null) conecta.close();
        } catch (SQLException se) {
            response.sendRedirect("erro.jsp?mensagem=" + URLEncoder.encode("Erro ao fechar conexão: " + se.getMessage(), "UTF-8"));
        }
    }
%>
