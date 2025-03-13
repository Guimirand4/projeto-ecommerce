package utils;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ExcluirProdutoServlet")
public class ExcluirProdutoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Captura o ID do produto a ser excluído
        String id = request.getParameter("id");

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // Conexão com o banco de dados
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                "jdbc:mysql://sql10.freesqldatabase.com:3306/sql10766514",
                "sql10766514", "swipjfdGjA");

            // Consulta SQL para excluir o produto
            String sql = "DELETE FROM produtos WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, id);

            // Executa a exclusão
            int rowsDeleted = stmt.executeUpdate();

            if (rowsDeleted > 0) {
                // Redireciona para a lista de produtos após a exclusão
                response.sendRedirect("ListarProdutosServlet");
            } else {
                // Se nenhum produto foi excluído, exibe uma mensagem de erro
                response.getWriter().println("Erro: Produto não encontrado.");
            }
        } catch (Exception e) {
            // Exibe uma mensagem de erro em caso de exceção
            response.getWriter().println("Erro ao excluir produto: " + e.getMessage());
        } finally {
            // Fechar os recursos
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
