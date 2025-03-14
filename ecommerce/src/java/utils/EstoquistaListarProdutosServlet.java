package utils;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/EstoquistaListarProdutosServlet")
public class EstoquistaListarProdutosServlet extends HttpServlet {
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
            RequestDispatcher dispatcher = request.getRequestDispatcher("/estoquista_lista_produtos.jsp");
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

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement st = null;

        try {
            // Conexão com o banco de dados
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                    "jdbc:mysql://sql10.freesqldatabase.com:3306/sql10766514",
                    "sql10766514", "swipjfdGjA");

            // Atualizar a quantidade em estoque
            String[] ids = request.getParameterValues("id");
            String[] quantidades = request.getParameterValues("quantidade");

            if (ids != null && quantidades != null && ids.length == quantidades.length) {
                String sqlUpdate = "UPDATE produtos SET quantidade_estoque = ? WHERE id = ?";
                st = conn.prepareStatement(sqlUpdate);

                for (int i = 0; i < ids.length; i++) {
                    int id = Integer.parseInt(ids[i]);
                    int quantidade = Integer.parseInt(quantidades[i]);
                    st.setInt(1, quantidade);
                    st.setInt(2, id);
                    st.addBatch();
                }

                st.executeBatch();
            }

            // Redirecionar de volta para a página de listagem após atualização
            response.sendRedirect(request.getContextPath() + "/EstoquistaListarProdutosServlet");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Erro ao atualizar produtos: " + e.getMessage());
        } finally {
            try {
                if (st != null) st.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
