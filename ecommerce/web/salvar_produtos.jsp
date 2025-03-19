<%@ page import="java.util.List, java.util.ArrayList" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="java.io.InputStream, java.util.Base64" %>
<%@ page import="java.sql.*, java.net.URLEncoder, utils.ConexaoDB" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%
    // Variáveis do produto
    String nome = "", descricao = "";
    double preco = 0, avaliacao = 0;
    int quantidade = 0;
    List<String> imagensBase64 = new ArrayList<>();

    Connection conexao = null;
    PreparedStatement stProduto = null;
    PreparedStatement stImagem = null;
    ResultSet rs = null;

    try {
        // Configuração do upload de arquivos
        DiskFileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);
        List<FileItem> items = upload.parseRequest(request);

        // Processando os campos do formulário
        for (FileItem item : items) {
            if (item.isFormField()) { // Se for um campo normal
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
            } else { // Se for um arquivo (imagem)
                if (!item.getName().isEmpty()) {
                    InputStream inputStream = item.getInputStream();
                    byte[] imageBytes = inputStream.readAllBytes();
                    String base64Image = Base64.getEncoder().encodeToString(imageBytes);
                    imagensBase64.add(base64Image);
                }
            }
        }

        // Obtém a conexão através da classe utilitária
        conexao = ConexaoDB.getConnection();

        // Inserir Produto
        String sqlProduto = "INSERT INTO produtos (nome, descricao, preco, quantidade_estoque, avaliacao, status) VALUES (?, ?, ?, ?, ?, 'Ativo')";
        stProduto = conexao.prepareStatement(sqlProduto, PreparedStatement.RETURN_GENERATED_KEYS);
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

        // Inserir imagens Base64 no banco
        if (!imagensBase64.isEmpty()) {
            String sqlImagem = "INSERT INTO produto_imagens (produto_id, imagem_base64) VALUES (?, ?)";
            stImagem = conexao.prepareStatement(sqlImagem);
            for (String imagemBase64 : imagensBase64) {
                stImagem.setInt(1, produtoId);
                stImagem.setString(2, imagemBase64);
                stImagem.executeUpdate();
            }
        }

        // Redirecionamento para listar produtos
        response.sendRedirect("listar_produtos.jsp");

    } catch (Exception e) {
        response.sendRedirect("erro.jsp?mensagem=" + URLEncoder.encode("Erro ao cadastrar produto: " + e.getMessage(), "UTF-8"));
    } finally {
        try {
            if (rs != null) rs.close();
            if (stProduto != null) stProduto.close();
            if (stImagem != null) stImagem.close();
            if (conexao != null) conexao.close();
        } catch (SQLException se) {
            response.sendRedirect("erro.jsp?mensagem=" + URLEncoder.encode("Erro ao fechar conexão: " + se.getMessage(), "UTF-8"));
        }
    }
%>
