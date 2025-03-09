<%@page import="java.io.File"%>
<%@page import="java.util.UUID"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Configurações de upload
    String uploadPath = getServletContext().getRealPath("/uploads");
    File uploadDir = new File(uploadPath);
    if (!uploadDir.exists()) uploadDir.mkdir();

    DiskFileItemFactory factory = new DiskFileItemFactory();
    ServletFileUpload upload = new ServletFileUpload(factory);

    // Processar o formulário
    String nome = "", descricao = "";
    double preco = 0, avaliacao = 0;
    int quantidade = 0;
    List<String> imagens = new ArrayList<>();

    try {
        List<FileItem> items = upload.parseRequest(request);
        for (FileItem item : items) {
            if (item.isFormField()) {
                // Campos do formulário
                switch (item.getFieldName()) {
                    case "nome":
                        nome = item.getString("UTF-8");
                        break;
                    case "descricao":
                        descricao = item.getString("UTF-8");
                        break;
                    case "preco":
                        preco = Double.parseDouble(item.getString("UTF-8"));
                        break;
                    case "quantidade":
                        quantidade = Integer.parseInt(item.getString("UTF-8"));
                        break;
                    case "avaliacao":
                        avaliacao = Double.parseDouble(item.getString("UTF-8"));
                        break;
                }
            } else {
                // Upload de imagens
                if (!item.getName().isEmpty()) {
                    String fileName = UUID.randomUUID().toString() + "_" + new File(item.getName()).getName();
                    File storeFile = new File(uploadPath + File.separator + fileName);
                    item.write(storeFile);
                    imagens.add(fileName);
                }
            }
        }

        // Salvar no banco de dados
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conecta = DriverManager.getConnection("jdbc:mysql://sql10.freesqldatabase.com:3306/sql10766514", "sql10766514", "swipjfdGjA");

        // Inserir produto
        String sqlProduto = "INSERT INTO produtos (nome, descricao, preco, quantidade_estoque, avaliacao, status) VALUES (?, ?, ?, ?, ?, 'Ativo')";
        PreparedStatement stProduto = conecta.prepareStatement(sqlProduto, PreparedStatement.RETURN_GENERATED_KEYS);
        stProduto.setString(1, nome);
        stProduto.setString(2, descricao);
        stProduto.setDouble(3, preco);
        stProduto.setInt(4, quantidade);
        stProduto.setDouble(5, avaliacao);
        stProduto.executeUpdate();

        // Obter o ID do produto inserido
        ResultSet rs = stProduto.getGeneratedKeys();
        int produtoId = 0;
        if (rs.next()) {
            produtoId = rs.getInt(1);
        }

        // Inserir imagens
        if (!imagens.isEmpty()) {
            String sqlImagem = "INSERT INTO produto_imagens (produto_id, caminho_imagem) VALUES (?, ?)";
            PreparedStatement stImagem = conecta.prepareStatement(sqlImagem);
            for (String imagem : imagens) {
                stImagem.setInt(1, produtoId);
                stImagem.setString(2, imagem);
                stImagem.executeUpdate();
            }
        }

        response.sendRedirect("listar_produtos.jsp");
    } catch (Exception e) {
        out.print("Erro ao cadastrar produto: " + e.getMessage());
    }
%>