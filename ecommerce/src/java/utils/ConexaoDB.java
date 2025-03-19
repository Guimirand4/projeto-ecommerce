package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexaoDB {
    // Configuração do banco
    private static final String URL = "jdbc:mysql://ecommerce.clom2co2gkyc.us-east-2.rds.amazonaws.com:3306/ecommerce?useSSL=false&serverTimezone=UTC";
    private static final String USUARIO = "root";
    private static final String SENHA = "adspi2025";

    // Método para obter conexão
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USUARIO, SENHA);
    }
}
