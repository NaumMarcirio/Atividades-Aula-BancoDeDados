 -- EXERCICIOS SOBRE WINDOW FUNCTION

--1

SELECT cod_apolice
 ,(SELECT nome FROM cliente WHERE cliente.cod_cliente = apolice.cod_cliente) as nome
 ,data_inicio_vigencia
 ,data_fim_vigencia
 ,valor_cobertura
 ,valor_franquia
 ,placa
 FROM apolice
ORDER BY data_fim_vigencia ASC
GO


--2

SELECT a.cod_apolice
 ,c.nome
 ,a.data_inicio_vigencia
 ,a.data_fim_vigencia
 ,a.valor_cobertura
 ,a.valor_franquia
 ,a.placa
 FROM apolice a INNER JOIN cliente c on
 a.cod_cliente = c.cod_cliente
ORDER BY data_fim_vigencia ASC
GO


--3

select *, ROW_NUMBER() OVER(ORDER BY local_sinistro ASC) as ordem FROM sinistro 

--4 

select *, RANK() OVER(ORDER BY local_sinistro ASC) as ordem FROM sinistro 

--5

select *, DENSE_RANK() OVER(ORDER BY local_sinistro ASC) as ordem FROM sinistro 

--6

SELECT * FROM carro

with cte as (
  select DISTINCT c.[placa]
      ,c.[modelo]
      ,c.[chassi]
      ,c.[marca]
      ,c.[ano]
      ,c.[cor]
       ,COUNT(s.placa) over(partition by c.placa order by c.placa)  as qtde_sinistro
  from carro c inner join sinistro s ON c.placa = s.placa
)
select * from cte where qtde_sinistro > 1

--2opçao
select c.placa, modelo, chassi, marca, ano, cor, count(1) as qtde
from carro c inner join sinistro s ON c.placa = s.placa
group by c.placa, modelo, chassi, marca, ano, cor
having count(1) > 1
go


--7


--1a opcao
with cte as (
  select DISTINCT c.placa
      ,c.modelo
      ,c.chassi
      ,c.marca
      ,c.ano
      ,c.cor
      ,COUNT(s.placa) over (partition by c.placa order by c.placa)  as qtde_sinistro
      ,FIRST_VALUE(data_sinistro) OVER(PARTITION BY c.placa ORDER BY data_sinistro) as primeiro_sinistro
  from carro c inner join sinistro s ON c.placa = s.placa
)
select * from cte where qtde_sinistro > 1;
go

--2a opcao
with cte as (
  select c.placa, modelo, chassi, marca, ano, cor, count(1) as qtde
  from carro c inner join sinistro s ON c.placa = s.placa
  group by c.placa, modelo, chassi, marca, ano, cor
  having count(1) > 1
)
select distinct cte.placa, modelo, chassi, marca, ano, cor, qtde
      ,FIRST_VALUE(data_sinistro) OVER(PARTITION BY cte.placa ORDER BY data_sinistro) as primeiro_sinistro
FROM cte INNER JOIN sinistro ON cte.placa = sinistro.placa
go

--8
with cte as (
  select DISTINCT c.placa
      ,c.modelo
      ,c.chassi
      ,c.marca
      ,c.ano
      ,c.cor
      ,COUNT(s.placa) over (partition by c.placa order by c.placa)  as qtde_sinistro
      ,FIRST_VALUE(data_sinistro) OVER(PARTITION BY c.placa ORDER BY data_sinistro) as primeiro_sinistro
	  ,LAST_VALUE(data_sinistro) OVER(PARTITION BY c.placa ORDER BY data_sinistro ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as ultimo_sinistro
  from carro c inner join sinistro s ON c.placa = s.placa
)
select * from cte where qtde_sinistro > 1;
go

--9

--USANDO JOIN
SELECT r.nm_regiao,e.nm_estado
FROM regiao r INNER JOIN estado e
ON r.cd_regiao = e.cd_regiao
ORDER BY r.nm_regiao, e.nm_estado


SELECT nm_regiao, nm_estado
FROM estado
WHERE nm_regiao in (SELECT nm_regiao
				   FROM regiao
				   WHERE estado.cd_regiao = regiao.cd_regiao)
				   


SELECT (SELECT nm_regiao from regiao where estado.cd_regiao = regiao.cd_regiao) as nm_regiao
       ,nm_estado
FROM estado
WHERE estado.cd_regiao is not null
ORDER BY nm_regiao, nm_estado
go

--10

with cte as (
  SELECT nm_regiao, nm_estado, ROW_NUMBER() OVER (ORDER BY nm_regiao, nm_estado) as posicao
  FROM regiao inner join estado on regiao.cd_regiao = estado.cd_regiao
)
select * from cte where posicao = 5
go

--2a opcao
with cte as (
  SELECT (SELECT nm_regiao from regiao where estado.cd_regiao = regiao.cd_regiao) as nm_regiao
         ,nm_estado
  FROM estado
  WHERE estado.cd_regiao is not null
),
cte1 as (
  select * ,ROW_NUMBER() OVER (ORDER BY nm_regiao, nm_estado) as posicao
  from cte
)
select * from cte1 where posicao = 5
go

--3a opcao
with cte as (
  SELECT nm_regiao, nm_estado, RANK() OVER (ORDER BY nm_regiao, nm_estado) as posicao
  FROM regiao inner join estado on regiao.cd_regiao = estado.cd_regiao
)
select * from cte where posicao = 5
go

--4a opcao
with cte as (
  SELECT (SELECT nm_regiao from regiao where estado.cd_regiao = regiao.cd_regiao) as nm_regiao
         ,nm_estado
  FROM estado
  WHERE estado.cd_regiao is not null
),
cte1 as (
  select * ,RANK() OVER (ORDER BY nm_regiao, nm_estado) as posicao
  from cte
)
select * from cte1 where posicao = 5
go


--11

SELECT cod_apolice
      ,(SELECT nome FROM cliente WHERE cliente.cod_cliente = apolice.cod_cliente) as nome
      ,data_inicio_vigencia
      ,data_fim_vigencia
      ,valor_cobertura
      ,valor_franquia
      ,placa
	  ,SUM(valor_franquia) OVER (
		PARTITION BY (SELECT nome FROM cliente WHERE cliente.cod_cliente = apolice.cod_cliente)
		ORDER BY (SELECT nome FROM cliente WHERE cliente.cod_cliente = apolice.cod_cliente), cod_apolice) as valor_acumulado
  FROM apolice
GO

--2a opcao
with cte as (
  SELECT cod_apolice
      ,(SELECT nome FROM cliente WHERE cliente.cod_cliente = apolice.cod_cliente) as nome
      ,data_inicio_vigencia
      ,data_fim_vigencia
      ,valor_cobertura
      ,valor_franquia
      ,placa
  FROM apolice
)
select *
       ,SUM(valor_franquia) OVER (PARTITION BY nome ORDER BY nome, cod_apolice) as valor_acumulado
from cte