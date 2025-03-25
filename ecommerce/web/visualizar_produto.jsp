<%@ page import="java.sql.*, java.util.ArrayList, java.util.List" %>
<%@ page import="utils.ConexaoDB" %>
<%
    // Recupera o id do produto passado via parâmetro
    int id = Integer.parseInt(request.getParameter("id"));

    Connection con = null;
    PreparedStatement psProd = null;
    PreparedStatement psImg = null;
    ResultSet rsProd = null;
    ResultSet rsImg = null;

    // Variáveis para armazenar os dados do produto
    String nome = "";
    String descricao = "";
    double preco = 0;
    int quantidade = 0;
    double avaliacao = 0;
    int status = 0;
    List<String> imagens = new ArrayList<>();

    try {
        con = ConexaoDB.getConnection();

        // Consulta os dados do produto
        String sqlProd = "SELECT * FROM produtos WHERE id = ?";
        psProd = con.prepareStatement(sqlProd);
        psProd.setInt(1, id);
        rsProd = psProd.executeQuery();
        if (rsProd.next()){
            nome = rsProd.getString("nome");
            descricao = rsProd.getString("descricao");
            preco = rsProd.getDouble("preco");
            quantidade = rsProd.getInt("quantidade_estoque");
            avaliacao = rsProd.getDouble("avaliacao");
            status = rsProd.getInt("status");
        }

        // Consulta as imagens do produto (agora usando a coluna 'imagem')
        String sqlImg = "SELECT imagem FROM produto_imagens WHERE produto_id = ?";
        psImg = con.prepareStatement(sqlImg);
        psImg.setInt(1, id);
        rsImg = psImg.executeQuery();
        while (rsImg.next()){
            String img = rsImg.getString("imagem");
            imagens.add(img);
        }
    } catch (Exception e) {
        out.println("Erro: " + e.getMessage());
    } finally {
        if (rsImg != null) try { rsImg.close(); } catch (SQLException ignore) {}
        if (psImg != null) try { psImg.close(); } catch (SQLException ignore) {}
        if (rsProd != null) try { rsProd.close(); } catch (SQLException ignore) {}
        if (psProd != null) try { psProd.close(); } catch (SQLException ignore) {}
        if (con != null) try { con.close(); } catch (SQLException ignore) {}
    }
%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Visualizar Produto</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f9f9f9; margin: 20px; }
        .produto { background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .imagens img { margin: 10px; width: 200px; border: 1px solid #ddd; padding: 5px; }
    </style>
</head>
<body>
    <div class="produto">
        <h1><%= nome %></h1>
        <p><strong>Descrição:</strong> <%= descricao %></p>
        <p><strong>Preço:</strong> R$ <%= String.format("%.2f", preco) %></p>
        <p><strong>Quantidade em Estoque:</strong> <%= quantidade %></p>
        <p><strong>Avaliação:</strong> <%= avaliacao %></p>
        <p><strong>Status:</strong> <%= (status == 1 ? "Ativo" : "Inativo") %></p>
        
        <hr>
        <h2>Imagens do Produto</h2>
        <div class="imagens">
            <% 
            // Exibe cada imagem recuperada
            for (String img : imagens) { 
            %>
                <img src="data:image/jpeg;base64,<%= img %>" alt="Imagem do produto" />
            <% } %>
        </div>
        <br>
        <a href="ListarProdutosServlet">Voltar</a>
    </div>
</body>
</html>
