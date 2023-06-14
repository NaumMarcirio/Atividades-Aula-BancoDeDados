-- LISTA REVIS�O PROVA 2 BANCO DE DADOS 2 


--1 c) Par�metros de entrada e sa�da.
--( F ) Stored procedures s�o criadas por CREATE PROCEDURE e executados por EXECUTE (n�o obrigat�rio).
--( F ) Trigger s�o criadas por CREATE TRIGGER e executadas por EXECUTE (obrigat�rio).
--( V ) Fun��es s�o criadas por CREATE FUNCTION e executadas por SELECT.
--( V ) Stored procedures s�o criadas por CREATE PROCEDURE e executados por EXECUTE (obrigat�rio).
--( V ) Triggers s�o executadas automaticamente conforme o disparo de um evento no banco de dados.
--( F ) Fun��es s�o executadas automaticamente por um evento no banco de dados.
--( F ) Stored procedures s�o executadas automaticamente pelo disparo de um evento no banco de dados.
--( F ) Trigger s�o criadas por CREATE TRIGGER e executadas por EXECUTE (n�o obrigat�rio).
--( F ) Fun��es s�o criadas por CREATE FUNCTION e executadas por EXECUTE.
--     elas ficam dentro de um banco de dados.
	--(   ) A execu��o de uma stored procedure � feita por meio de chamada ao seu nome, podendo ser, inclusive,
	--dentro de outra stored procedure.
	--(   ) Uma trigger � uma stored procedure que � ativada por evento e executa uma ou mais a��es.
	--( X ) Transa��es (commit e rollback) n�o podem ser executadas em stored procedures e fun��es, somente em
	--triggers.
	--(   ) O uso de stored procedure diminui o tr�fego na rede em uma arquitetura client/server, pois os comandos
	--SQL ficam armazenados em um banco de dados.
alter proc x (@m int, @r datetime output) as
begin
select dateadd(MM, -1, getdate())
PRINT(@r)
end

returns int
as
begin
	declare @resultado int
	select @resultado = count(cod_apolice) from apolice where cod_cliente = @cod_cliente
	return @resultado
end
go
declare @c table (nome varchar(50),
 placa varchar(10),
 modelo varchar(50),
 marca varchar(50))

declare @nome varchar(50),
@modelo varchar(50),
@marca varchar(50),
@placa varchar(10)

insert into @c(placa)
select placa
from carro

declare cur_carros cursor
 for select placa from carro
open cur_carros
while 0=0
begin
	fetch cur_carros into @placa

	if @@FETCH_STATUS <> 0
		break
	select @marca = marca,
	@modelo = modelo
	from carro
	where placa = @placa

	select @nome = nome
	from cliente FULL join apolice
	on cliente.cod_cliente = apolice.cod_cliente
	where apolice.placa = @placa
	
	update @c
	set nome = @nome,
	marca = @marca,
	modelo = @modelo
	where placa = @placa
end

close cur_carros
deallocate cur_carros

select * from @c
go
RETURN (SELECT COUNT(ca.placa) as carros, c.nome as nome FROM cliente c
INNER JOIN apolice a ON a.cod_cliente = c.cod_cliente
INNER JOIN carro ca ON ca.placa = a.placa
GROUP BY c.nome)


create trigger deletaApolice on apolice for delete as 
begin
	if ROWCOUNT_BIG() = 0
	RETURN 

	insert into apolice_log_exclusao
	select
		GETDATE(),
		user_name(),
		cod_apolice,
		cod_cliente,
		data_inicio_vigencia,
		data_fim_vigencia,
		valor_cobertura,
		valor_franquia,
		placa
		from deleted 
BEGIN 
RETURN (SELECT COUNT(a.cod_cliente) FROM apolice a WHERE a.cod_cliente = @userCod)
END;
