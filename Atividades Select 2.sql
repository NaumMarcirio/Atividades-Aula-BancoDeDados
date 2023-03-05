
--1. Qual(is) Carro(s) possui(em) mais sinistros cadastrados?

SELECT COUNT(s.cod_sinistro) as 'número de sinistros', c.placa, c.modelo, c.chassi, c.marca, c.ano, c.cor
FROM carro c LEFT JOIN sinistro s ON c.placa = s.placa
GROUP BY c.placa, c.modelo, c.chassi, c.marca, c.ano, c.cor
ORDER BY 'número de sinistros' DESC



-- 2. Quais clientes cadastrados possuem letra “a” no meio e não no final? 

SELECT *
FROM cliente
WHERE nome LIKE ('%a%') and nome NOT LIKE ('%a')

-- 3. Quais clientes não possuem apólice? 

SELECT c.nome, c.cpf, c.sexo, c.endereco, c.telefone_fixo, c.telefone_celular
FROM cliente c LEFT JOIN apolice a ON
c.cod_cliente = a.cod_cliente
WHERE a.cod_apolice IS NULL

-- 4. Quais carros não possuem apólice?

SELECT *
FROM carro c LEFT JOIN apolice a ON
c.placa = a.placa
WHERE a.cod_apolice IS NULL


--5. Quais clientes temos hoje na base de dados? 

SELECT * 
FROM cliente


--6. Quais carros possuem a placa iniciando com as letras L ou M
SELECT * 
FROM carro
WHERE placa LIKE ('L%') OR placa LIKE ('M%')


-- 7. Quais são os sinistros que ocorreram em 2022?

SELECT * 
FROM sinistro
WHERE data_sinistro LIKE ('2022%')

--8. Quais clientes não possuem telefone fixo E telefone celular cadastrados?SELECT * FROM clienteWHERE telefone_fixo IS NULL and telefone_celular IS NULL-- 9. Quais os clientes possuem apólice(s) vencida(s)? Utiliza data e hora atual como base.SELECT  * FROM cliente c LEFT JOIN apolice aon c.cod_cliente = a.cod_clienteWHERE data_fim_vigencia < GETDATE()-- 10. Quais carros possuem algum sinistro com data superior a data de fim da vigência da apólice?SELECT *FROM sinistro s LEFT JOIN carro con s.placa = c.placa RIGHT JOIN apolice aon c.placa = a.placaWHERE s.data_sinistro > a.data_fim_vigencia-- 11. Em relação ao modelo abaixo, responda a questão: Quantas regiões existem cadastradas?SELECT count(1) as 'Número de regiões cadastradas'FROM regiao-- 12. Quantos estados existem cadastrados?SELECT count(cd_estado) as 'Número de estados cadastrados'FROM estado-- 13. Quantos municípios existem cadastrados?SELECT count(cd_municipio) as 'Número de municípios cadastrados'FROM municipio
--14. Quantos municípios existem por estado? Considere gerar uma lista com o nome do estado e a
--    quantidade de municípios por cada estado.

SELECT e.nm_estado as 'Nome do estado', count(e.cd_estado) as 'Número de Municípios'
FROM municipio m INNER JOIN estado e 
ON m.cd_estado = e.cd_estado
GROUP BY e.cd_estado, e.nm_estado


-- 15. Quais municípios existem na região SUL?

SELECT m.nm_municipio as 'Nomes Municípios Região Sul', e.sigla_uf as 'Unidade Federativa'
FROM regiao r INNER JOIN estado e
ON r.cd_regiao = e.cd_regiao INNER JOIN municipio m
ON e.cd_estado = m.cd_estado
WHERE r.cd_regiao = 4


-- 16. Quais municípios existem na região SUL e que começam com a letra C?

SELECT m.nm_municipio as 'Nomes Municípios Região Sul', e.sigla_uf as 'Unidade Federativa'
FROM regiao r INNER JOIN estado e
ON r.cd_regiao = e.cd_regiao INNER JOIN municipio m
ON e.cd_estado = m.cd_estado
WHERE r.cd_regiao = 4 and m.nm_municipio LIKE ('c%')


--17. Quais municípios possuem mais de 10 letras no nome?

SELECT nm_municipio as 'nome municipio', cd_estado as 'código estado'
FROM municipio
WHERE LEN(nm_municipio) > 10



-- 18. Quais os municípios existem na região NORTE?

SELECT m.nm_municipio as 'Nomes Municípios Região Sul', e.sigla_uf as 'Unidade Federativa'
FROM regiao r INNER JOIN estado e
ON r.cd_regiao = e.cd_regiao INNER JOIN municipio m
ON e.cd_estado = m.cd_estado
WHERE r.cd_regiao = 1




-- 19. Quais as regiões que começam com a letra S e quantos municípios existem em cada uma delas?

SELECT  r.nm_regiao as 'Nome da Região', count(e.cd_estado) as 'Número de Municípios'
FROM regiao r INNER JOIN estado e
ON r.cd_regiao = e.cd_regiao INNER JOIN municipio m
ON e.cd_estado = m.cd_estado
WHERE r.nm_regiao LIKE ('s%')
GROUP BY r.nm_regiao


-- 20. Quantas avaliações existem cadastradas? Considere as avaliações modelo e não as --     avaliações respondidas pelos alunos.