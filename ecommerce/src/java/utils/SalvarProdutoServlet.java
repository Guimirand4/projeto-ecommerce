package utils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet; // IMPORTANTE: Adicione esta linha
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/SalvarProdutoServlet") // Define o caminho para acessar o servlet
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // 5MB máximo
public class SalvarProdutoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String nome = request.getParameter("nome");
        String descricao = request.getParameter("descricao");
        double preco = Double.parseDouble(request.getParameter("preco"));
        int quantidade = Integer.parseInt(request.getParameter("quantidade"));
        double avaliacao = Double.parseDouble(request.getParameter("avaliacao"));

        // Obtém o arquivo enviado
        Part filePart = request.getPart("imagem");
        InputStream fileContent = filePart.getInputStream(); // Obtém o conteúdo da imagem

        Connection conn = null;
        PreparedStatement stProduto = null;
        PreparedStatement stImagem = null;

        try {
            // Conexão com o banco de dados
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                "jdbc:mysql://sql10.freesqldatabase.com:3306/sql10766514",
                "sql10766514", "swipjfdGjA");

            // Inserir produto na tabela "produtos"
           String sqlProduto = "INSERT INTO produtos (nome, descricao, preco, quantidade_estoque, avaliacao, status) VALUES (?, ?, ?, ?, ?, ?)";
stProduto = conn.prepareStatement(sqlProduto, PreparedStatement.RETURN_GENERATED_KEYS);
stProduto.setString(1, nome);
stProduto.setString(2, descricao);
stProduto.setDouble(3, preco);
stProduto.setInt(4, quantidade);
stProduto.setDouble(5, avaliacao);
stProduto.setInt(6, 1); // 1 = Ativo

            stProduto.executeUpdate();

            // Obtém o ID gerado do produto
            int produtoId = 0;
            var rs = stProduto.getGeneratedKeys();
            if (rs.next()) {
                produtoId = rs.getInt(1);
            }

            // Inserir a imagem na tabela "produto_imagens"
            String sqlImagem = "INSERT INTO produto_imagens (produto_id, imagem) VALUES (?, ?)";
            stImagem = conn.prepareStatement(sqlImagem);
            stImagem.setInt(1, produtoId);
            stImagem.setBlob(2, fileContent); // Salva o arquivo como BLOB
            stImagem.executeUpdate();

            response.sendRedirect("lista_produtos.jsp");
        } catch (Exception e) {
            response.getWriter().println("Erro ao cadastrar produto: " + e.getMessage());
        } finally {
            try {
                if (stProduto != null) stProduto.close();
                if (stImagem != null) stImagem.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                response.getWriter().println("Erro ao fechar conexão: " + e.getMessage());
            }
        }
    }
}
