package utils;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AlterarQuantidadeServlet")
public class AlterarQuantidadeServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection conn = null;
        PreparedStatement st = null;

        try {
            // Captura os parâmetros do request
            int id = Integer.parseInt(request.getParameter("id"));
            int quantidade = Integer.parseInt(request.getParameter("quantidade"));

            // Conectar ao banco de dados usando a classe ConexaoDB
            conn = ConexaoDB.getConnection();

            // Atualizar a quantidade do produto
            String sql = "UPDATE produtos SET quantidade_estoque = ? WHERE id = ?";
            st = conn.prepareStatement(sql);
            st.setInt(1, quantidade);
            st.setInt(2, id);

            int rowsUpdated = st.executeUpdate();

            if (rowsUpdated > 0) {
                response.setStatus(HttpServletResponse.SC_OK);
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
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
