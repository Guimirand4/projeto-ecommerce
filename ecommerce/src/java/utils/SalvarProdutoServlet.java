package utils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Base64;

@WebServlet("/SalvarProdutoServlet")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // 5MB máximo
public class SalvarProdutoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Connection conn = null;
        PreparedStatement stProduto = null;
        PreparedStatement stImagem = null;
        ResultSet rs = null;

        try {
            // Captura os parâmetros do formulário
            String nome = request.getParameter("nome");
            String descricao = request.getParameter("descricao");
            double preco = Double.parseDouble(request.getParameter("preco"));
            int quantidade = Integer.parseInt(request.getParameter("quantidade"));
            double avaliacao = Double.parseDouble(request.getParameter("avaliacao"));

            // Obtém o arquivo de imagem enviado
            Part filePart = request.getPart("imagem");
            InputStream fileContent = filePart.getInputStream();
            byte[] imageBytes = fileContent.readAllBytes();
            String base64Image = Base64.getEncoder().encodeToString(imageBytes);

            // Conectar ao banco de dados AWS RDS
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                "jdbc:mysql://ecommerce.clom2co2gkyc.us-east-2.rds.amazonaws.com:3306/ecommerce",
                "root", "adspi2025"
            );

            // Inserir Produto
            String sqlProduto = "INSERT INTO produtos (nome, descricao, preco, quantidade_estoque, avaliacao) VALUES (?, ?, ?, ?, ?)";

            stProduto = conn.prepareStatement(sqlProduto, PreparedStatement.RETURN_GENERATED_KEYS);
            stProduto.setString(1, nome);
            stProduto.setString(2, descricao);
            stProduto.setDouble(3, preco);
            stProduto.setInt(4, quantidade);
            stProduto.setDouble(5, avaliacao);
            stProduto.executeUpdate();

            // Obtém o ID do produto inserido
            rs = stProduto.getGeneratedKeys();
            int produtoId = 0;
            if (rs.next()) {
                produtoId = rs.getInt(1);
            }

            // Inserir a imagem no banco
            if (produtoId > 0) {
                String sqlImagem = "INSERT INTO produto_imagens (produto_id, imagem) VALUES (?, ?)";
                stImagem = conn.prepareStatement(sqlImagem);
                stImagem.setInt(1, produtoId);
                stImagem.setString(2, base64Image);
                stImagem.executeUpdate();
            }

            // Redireciona para listar os produtos
            response.sendRedirect("lista_produtos.jsp");

        } catch (Exception e) {
            response.getWriter().println("Erro ao cadastrar produto: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (stProduto != null) stProduto.close();
                if (stImagem != null) stImagem.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                response.getWriter().println("Erro ao fechar conexão: " + e.getMessage());
            }
        }
    }
}
