package utils;

import java.util.List;

public class Produto {
    private int id;
    private String nome;
    private int quantidadeEstoque;
    private double valor;
    private String status;
    private List<String> imagens; // Lista de imagens associadas ao produto

    // Construtor da classe Produto
    public Produto(int id, String nome, int quantidadeEstoque, double valor, String status) {
        this.id = id;
        this.nome = nome;
        this.quantidadeEstoque = quantidadeEstoque;
        this.valor = valor;
        this.status = status;
    }

    // Getters e Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public int getQuantidadeEstoque() { return quantidadeEstoque; }
    public void setQuantidadeEstoque(int quantidadeEstoque) { this.quantidadeEstoque = quantidadeEstoque; }

    public double getValor() { return valor; }
    public void setValor(double valor) { this.valor = valor; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    // Getter e Setter para as imagens
    public List<String> getImagens() {
        return imagens;
    }

    public void setImagens(List<String> imagens) {
        this.imagens = imagens;
    }
}
