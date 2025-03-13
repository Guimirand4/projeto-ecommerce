package utils;

import java.io.IOException;
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
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/AtivarDesativarProdutoServlet")
public class AtivarDesativarProdutoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conecta = DriverManager.getConnection("jdbc:mysql://sql10.freesqldatabase.com:3306/sql10766514",
                "sql10766514", "swipjfdGjA");

            String sql = "UPDATE produtos SET status = IF(status = 'Ativo', 'Inativo', 'Ativo') WHERE id = ?";
            PreparedStatement st = conecta.prepareStatement(sql);
            st.setString(1, id);
            st.executeUpdate();

            st.close();
            conecta.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}