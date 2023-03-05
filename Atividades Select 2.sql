
--1. Qual(is) Carro(s) possui(em) mais sinistros cadastrados?

SELECT COUNT(s.cod_sinistro) as 'n�mero de sinistros', c.placa, c.modelo, c.chassi, c.marca, c.ano, c.cor
FROM carro c LEFT JOIN sinistro s ON c.placa = s.placa
GROUP BY c.placa, c.modelo, c.chassi, c.marca, c.ano, c.cor
ORDER BY 'n�mero de sinistros' DESC



-- 2. Quais clientes cadastrados possuem letra �a� no meio e n�o no final? 

SELECT *
FROM cliente
WHERE nome LIKE ('%a%') and nome NOT LIKE ('%a')

-- 3. Quais clientes n�o possuem ap�lice? 

SELECT c.nome, c.cpf, c.sexo, c.endereco, c.telefone_fixo, c.telefone_celular
FROM cliente c LEFT JOIN apolice a ON
c.cod_cliente = a.cod_cliente
WHERE a.cod_apolice IS NULL

-- 4. Quais carros n�o possuem ap�lice?

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


-- 7. Quais s�o os sinistros que ocorreram em 2022?

SELECT * 
FROM sinistro
WHERE data_sinistro LIKE ('2022%')

--8. Quais clientes n�o possuem telefone fixo E telefone celular cadastrados?SELECT * FROM clienteWHERE telefone_fixo IS NULL and telefone_celular IS NULL-- 9. Quais os clientes possuem ap�lice(s) vencida(s)? Utiliza data e hora atual como base.SELECT  * FROM cliente c LEFT JOIN apolice aon c.cod_cliente = a.cod_clienteWHERE data_fim_vigencia < GETDATE()-- 10. Quais carros possuem algum sinistro com data superior a data de fim da vig�ncia da ap�lice?SELECT *FROM sinistro s LEFT JOIN carro con s.placa = c.placa RIGHT JOIN apolice aon c.placa = a.placaWHERE s.data_sinistro > a.data_fim_vigencia-- 11. Em rela��o ao modelo abaixo, responda a quest�o: Quantas regi�es existem cadastradas?SELECT count(1) as 'N�mero de regi�es cadastradas'FROM regiao-- 12. Quantos estados existem cadastrados?SELECT count(cd_estado) as 'N�mero de estados cadastrados'FROM estado-- 13. Quantos munic�pios existem cadastrados?SELECT count(cd_municipio) as 'N�mero de munic�pios cadastrados'FROM municipio
--14. Quantos munic�pios existem por estado? Considere gerar uma lista com o nome do estado e a
--    quantidade de munic�pios por cada estado.

SELECT e.nm_estado as 'Nome do estado', count(e.cd_estado) as 'N�mero de Munic�pios'
FROM municipio m INNER JOIN estado e 
ON m.cd_estado = e.cd_estado
GROUP BY e.cd_estado, e.nm_estado


-- 15. Quais munic�pios existem na regi�o SUL?

SELECT m.nm_municipio as 'Nomes Munic�pios Regi�o Sul', e.sigla_uf as 'Unidade Federativa'
FROM regiao r INNER JOIN estado e
ON r.cd_regiao = e.cd_regiao INNER JOIN municipio m
ON e.cd_estado = m.cd_estado
WHERE r.cd_regiao = 4


-- 16. Quais munic�pios existem na regi�o SUL e que come�am com a letra C?

SELECT m.nm_municipio as 'Nomes Munic�pios Regi�o Sul', e.sigla_uf as 'Unidade Federativa'
FROM regiao r INNER JOIN estado e
ON r.cd_regiao = e.cd_regiao INNER JOIN municipio m
ON e.cd_estado = m.cd_estado
WHERE r.cd_regiao = 4 and m.nm_municipio LIKE ('c%')


--17. Quais munic�pios possuem mais de 10 letras no nome?

SELECT nm_municipio as 'nome municipio', cd_estado as 'c�digo estado'
FROM municipio
WHERE LEN(nm_municipio) > 10



-- 18. Quais os munic�pios existem na regi�o NORTE?

SELECT m.nm_municipio as 'Nomes Munic�pios Regi�o Sul', e.sigla_uf as 'Unidade Federativa'
FROM regiao r INNER JOIN estado e
ON r.cd_regiao = e.cd_regiao INNER JOIN municipio m
ON e.cd_estado = m.cd_estado
WHERE r.cd_regiao = 1




-- 19. Quais as regi�es que come�am com a letra S e quantos munic�pios existem em cada uma delas?

SELECT  r.nm_regiao as 'Nome da Regi�o', count(e.cd_estado) as 'N�mero de Munic�pios'
FROM regiao r INNER JOIN estado e
ON r.cd_regiao = e.cd_regiao INNER JOIN municipio m
ON e.cd_estado = m.cd_estado
WHERE r.nm_regiao LIKE ('s%')
GROUP BY r.nm_regiao


-- 20. Quantas avalia��es existem cadastradas? Considere as avalia��es modelo e n�o as --     avalia��es respondidas pelos alunos.