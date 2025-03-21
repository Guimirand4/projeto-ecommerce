package utils;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ListarProdutosServlet")
public class ListarProdutosServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        String busca = request.getParameter("busca");
        List<Produto> produtos = new ArrayList<>();

        try {
            // Conexão com o banco de dados utilizando a classe ConexaoDB
            conn = ConexaoDB.getConnection();

            // Query para buscar produtos pelo nome
            String sql = "SELECT * FROM produtos WHERE nome LIKE ? ORDER BY nome DESC";
            st = conn.prepareStatement(sql);
            st.setString(1, "%" + (busca != null ? busca : "") + "%");
            rs = st.executeQuery();

            // Adicionar produtos na lista
            while (rs.next()) {
                Produto produto = new Produto(
                        rs.getInt("id"),
                        rs.getString("nome"),
                        rs.getInt("quantidade_estoque"),
                        rs.getDouble("preco"),
                        rs.getString("status")
                );
                produtos.add(produto);
            }

            // Enviar a lista para a página JSP
            request.setAttribute("produtos", produtos);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/lista_produtos.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Erro ao buscar produtos: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
