package utils;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.DriverManager;
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
            // Conexão com o banco de dados
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                    "jdbc:mysql://sql10.freesqldatabase.com:3306/sql10766514",
                    "sql10766514", "swipjfdGjA");

            // Se não houver parâmetro de busca, traz todos os produtos
            String sql = "SELECT * FROM produtos WHERE nome LIKE ? ORDER BY id DESC";
            st = conn.prepareStatement(sql);
            st.setString(1, "%" + (busca != null ? busca : "") + "%");
            rs = st.executeQuery();

            // Adicionar os produtos na lista
            while (rs.next()) {
                Produto produto = new Produto(
                        rs.getInt("id"),
                        rs.getString("nome"),
                        rs.getInt("quantidade_estoque"),
                        rs.getDouble("valor"),
                        rs.getDouble("avaliacao"),
                        rs.getString("status")
                );
                produtos.add(produto);
            }

            // Armazenar a lista de produtos na request
            request.setAttribute("produtos", produtos);

            // Enviar para o JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/lista_produtos.jsp");
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

    private static class Produto {

        public Produto() {
        }

        private Produto(int aInt, String string, int aInt0, double aDouble, double aDouble0, String string0) {
            throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
        }
    }
}
