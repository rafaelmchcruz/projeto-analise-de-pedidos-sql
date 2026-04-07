-- Projeto 3

USE restaurante;

-- View (resumo_pedido) do join entre as tabelas: pedidos: id, quantidade e data; clientes: nome e email; funcionarios: nome; produtos: nome, preco.

CREATE VIEW resumo_pedido AS 
SELECT
	pe.id_pedido,
    pe.quantidade,
    pe.data_pedido, 
    cl.nome AS nome_cliente,
    cl.email AS email_cliente,
    f.nome AS nome_funcionario,
    pr.nome AS nome_produto,
    pr.preco 
    FROM pedidos pe
    JOIN clientes cl ON pe.id_cliente = cl.id_clientes
	JOIN funcionarios f ON pe.id_cliente = f.id_funcionario
    JOIN produtos pr ON pe.id_produto = pr.id_produto;
    
    SELECT * FROM resumo_pedido; -- Consultar a view (teste).
    
    -- Id do pedido, nome do cliente e o total (quantidade * preco) de cada pedido da view resumo_pedido. 
    
    SELECT 
		id_pedido,
        nome_cliente,
        (quantidade * preco) AS total
	FROM resumo_pedido;
    
    -- Atualizar o view resumo pedido, adicionando campo total.
    
CREATE OR REPLACE VIEW resumo_pedido AS 
SELECT
	pe.id_pedido,
    pe.quantidade,
    pe.data_pedido, 
    cl.nome AS nome_cliente,
    cl.email AS email_cliente,
    f.nome AS nome_funcionario,
    pr.nome AS nome_produto,
    pr.preco,
    (pe.quantidade * pr.preco) AS total
    FROM pedidos pe
    JOIN clientes cl ON pe.id_cliente = cl.id_clientes
	JOIN funcionarios f ON pe.id_cliente = f.id_funcionario
    JOIN produtos pr ON pe.id_produto = pr.id_produto;
    
    SELECT * FROM resumo_pedido; -- Consultar a view (teste).
    
    -- Consulta da questão 3, utilizando o campo total adicionado.
    
    SELECT 
		id_pedido,
        nome_cliente,
        total
	FROM resumo_pedido;
    
    -- Consulta da pergunta anterior, com uso do EXPLAIN para verificar e compreender o JOIN que está oculto na query.
    
	EXPLAIN
	SELECT 
		id_pedido,
        nome_cliente,
        total
	FROM resumo_pedido;
    
    -- Função chamada ‘BuscaIngredientesProduto’, que irá retornar os ingredientes da tabela info produtos, quando passar o id de produto como argumento (entrada) da função.
    
    DELIMITER //
    CREATE FUNCTION BuscaIngredientesProduto(p_id_produto INT)
    RETURNS VARCHAR(255)
    DETERMINISTIC
    BEGIN
		DECLARE ingredientes_produto VARCHAR(255);
        SELECT ingredientes
        INTO ingredientes_produto
        FROM info_produtos
        WHERE id_produto = p_id_produto;
        RETURN ingredientes_produto;
	END //
    DELIMITER ;
    
    -- Função ‘BuscaIngredientesProduto’ com o id de produto 10.
    
    SELECT BuscaIngredientesProduto(10);
    
    -- Função chamada ‘mediaPedido’ que irá retornar uma mensagem dizendo que o total do pedido é acima, abaixo ou igual a média de todos os pedidos, quando passar o id do pedido como argumento da função.
    
 DELIMITER //
 
 CREATE FUNCTION mediaPedido(p_id_pedido INT)
 RETURNS VARCHAR(100)
 DETERMINISTIC
 BEGIN
	DECLARE	total_pedido DECIMAL(10, 2);
    DECLARE media_geral DECIMAL(10, 2);
    
    -- Total do pedido específico
    SELECT total
    INTO total_pedido
    FROM resumo_pedido
    WHERE id_pedido = p_id_pedido;
    
    -- Média de todos os pedidos
    SELECT AVG(total)
    INTO media_geral
    FROM resumo_pedido;
    
    IF total_pedido > media_geral THEN
		RETURN 'Total do pedido é acima da média';
	ELSEIF total_pedido < media_geral THEN
		RETURN 'Total do pedido abaixo da média';
	ELSE
		RETURN 'Total do pedido igual a média';
	END IF;
END //
DELIMITER ;

-- Função ‘mediaPedido’ com o id de pedido 5 e depois 6.

SELECT mediaPedido(5);
SELECT mediaPedido(6);




    
    
    
    
    
    
    
    
    