package utils;

public class CPFUtils {
    public static boolean validarCPF(String cpf) {
        cpf = cpf.replaceAll("[^0-9]", ""); // Remove caracteres não numéricos
        if (cpf.length() != 11 || cpf.matches("(\\d)\\1{10}")) return false;

        int soma = 0, resto;
        for (int i = 0; i < 9; i++) soma += (cpf.charAt(i) - '0') * (10 - i);
        resto = (soma * 10) % 11;
        if (resto == 10) resto = 0;
        if (resto != (cpf.charAt(9) - '0')) return false;

        soma = 0;
        for (int i = 0; i < 10; i++) soma += (cpf.charAt(i) - '0') * (11 - i);
        resto = (soma * 10) % 11;
        if (resto == 10) resto = 0;

        return resto == (cpf.charAt(10) - '0');
    }
}
