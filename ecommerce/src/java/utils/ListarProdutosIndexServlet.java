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

@WebServlet("/inicio") // <-- Essa URL você chama no navegador
public class ListarProdutosIndexServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Produto> produtos = new ArrayList<>();

        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement st = conn.prepareStatement("SELECT * FROM produtos WHERE status = '1'");
             ResultSet rs = st.executeQuery()) {

            while (rs.next()) {
                Produto p = new Produto(
                    rs.getInt("id"),
                    rs.getString("nome"),
                    rs.getInt("quantidade_estoque"),
                    rs.getDouble("preco"),
                    rs.getString("status")
                );
                produtos.add(p);
            }

            request.setAttribute("produtos", produtos);
            request.getRequestDispatcher("/index.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Erro: " + e.getMessage());
        }
    }
}