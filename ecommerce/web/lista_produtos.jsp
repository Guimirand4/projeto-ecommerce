<%@page import="utils.Produto"%>
<%@ page import="java.util.List" %>
<%@ page import="servlet.Produto" %>

<%
    // Recuperar a lista de produtos passada pelo servlet
    List<Produto> produtos = (List<Produto>) request.getAttribute("produtos");
%>

<!-- Tabela de produtos -->
<table id="produtos-table">
    <thead>
        <tr>
            <th>ID</th>
            <th>Nome</th>
            <th>Quantidade</th>
            <th>Valor</th>
            <th>Avaliação</th>
            <th>Status</th>
            <th>Ações</th>
        </tr>
    </thead>
    <tbody>
        <%-- Iterar sobre os produtos --%>
        <%
            for (Produto produto : produtos) {
        %>
        <tr>
            <td><%= produto.getId() %></td>
            <td><%= produto.getNome() %></td>
            <td><%= produto.getQuantidadeEstoque() %></td>
            <td><%= produto.getValor() %></td>
            <td><%= produto.getAvaliacao() %></td>
            <td><%= produto.getStatus() %></td>
            <td class="actions">
                <a href="alterar_produto.jsp?id=<%= produto.getId() %>">Alterar</a> |
                <a href="inativar_produto.jsp?id=<%= produto.getId() %>">Inativar</a>
            </td>
        </tr>
        <% } %>
    </tbody>
</table>
