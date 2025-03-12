package utils;

 public  class Produto {
        private int id;
        private String nome;
        private int quantidadeEstoque;
        private double valor;
        private String status;

        public Produto(int id, String nome, int quantidadeEstoque, double valor, String status) {
            this.id = id;
            this.nome = nome;
            this.quantidadeEstoque = quantidadeEstoque;
            this.valor = valor;
            this.status = status;
        }

        public int getId() { return id; }
        public String getNome() { return nome; }
        public int getQuantidadeEstoque() { return quantidadeEstoque; }
        public double getValor() { return valor; }
        public String getStatus() { return status; }
    }
