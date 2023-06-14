-- LISTA REVIS�O PROVA 2 BANCO DE DADOS 2 


--1 c) Par�metros de entrada e sa�da.--2 a) Nenhum par�metro.--3 b) Somente par�metros de entrada.--4 Considere VERDADEIRO ou FALSO para as afirmativas abaixo:
--( F ) Stored procedures s�o criadas por CREATE PROCEDURE e executados por EXECUTE (n�o obrigat�rio).
--( F ) Trigger s�o criadas por CREATE TRIGGER e executadas por EXECUTE (obrigat�rio).
--( V ) Fun��es s�o criadas por CREATE FUNCTION e executadas por SELECT.
--( V ) Stored procedures s�o criadas por CREATE PROCEDURE e executados por EXECUTE (obrigat�rio).
--( V ) Triggers s�o executadas automaticamente conforme o disparo de um evento no banco de dados.
--( F ) Fun��es s�o executadas automaticamente por um evento no banco de dados.
--( F ) Stored procedures s�o executadas automaticamente pelo disparo de um evento no banco de dados.
--( F ) Trigger s�o criadas por CREATE TRIGGER e executadas por EXECUTE (n�o obrigat�rio).
--( F ) Fun��es s�o criadas por CREATE FUNCTION e executadas por EXECUTE.--5 b) � executada de acordo com um evento; � chamada para ser executada; � chamada para ser executada e
--     elas ficam dentro de um banco de dados.--6 a) A procedure retorna um valor inteiro ap�s sua execu��o.--	e) O nome da procedure � x; y e z s�o par�metros.--7 a) A fun��o retorna um valor inteiro ap�s sua execu��o.--  c) A fun��o possui um par�metro.--  e) O nome da fun��o � x; y � um par�metro; e retorna um valor inteiro.--8 MARQUE AS ALTERNATIVAS FALSAS	--( X ) Uma trigger � equivalente a uma fun��o, inclusive pelo fato de retornar um valor.
	--(   ) A execu��o de uma stored procedure � feita por meio de chamada ao seu nome, podendo ser, inclusive,
	--dentro de outra stored procedure.
	--(   ) Uma trigger � uma stored procedure que � ativada por evento e executa uma ou mais a��es.
	--( X ) Transa��es (commit e rollback) n�o podem ser executadas em stored procedures e fun��es, somente em
	--triggers.
	--(   ) O uso de stored procedure diminui o tr�fego na rede em uma arquitetura client/server, pois os comandos
	--SQL ficam armazenados em um banco de dados.--9 e) Triggers--10 ENCONTRE OS ERROS-- b) IS_NULL , deveria ser escrito dessa forma IS NULL-- f) DECLARE @placa int, pois o tipo de dado correto deveria ser alfanum�rico tipo varchar.--11 e) Informar uma data (com base na data atual), acrescida ou diminu�da de @m m�s(es), atrav�s de @r.
alter proc x (@m int, @r datetime output) as
begin
select dateadd(MM, -1, getdate())
PRINT(@r)
end
declare @R datetimeEXEC x 2, @R OUTPUT--12 R: N�o tem porque criar a variavel @result tipo varchar, pois ela n�o � usada em lugar nenhum, ou seja ela n�o vai retornar nada.create function fn_count_apolices (@cod_cliente int)
returns int
as
begin
	declare @resultado int
	select @resultado = count(cod_apolice) from apolice where cod_cliente = @cod_cliente
	return @resultado
end
go--13  
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
go--14 Atualizar a coluna senha_anterior da tabela  usuario--15 select * from apoliceselect * from clienteselect * from carroALTER PROC lista_carros asbegin	--SELECT @cod_cliente = a.cod_cliente from apolice a where a.cod_cliente = @cod_cliente	Select count(car.placa) as 'N�mero de Carros', c.nome	FROM cliente c INNER JOIN apolice a on c.cod_cliente = a.cod_cliente				   INNER JOIN carro car on car.placa = a.placa	GROUP BY c.nome		enddrop proc if exists lista_carrosexec lista_carros --16 ALTER FUNCTION fn_test() RETURNS TABLE AS
RETURN (SELECT COUNT(ca.placa) as carros, c.nome as nome FROM cliente c
INNER JOIN apolice a ON a.cod_cliente = c.cod_cliente
INNER JOIN carro ca ON ca.placa = a.placa
GROUP BY c.nome)
SELECT * from dbo.fn_test()--17 

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
		from deleted --18 alter FUNCTION fn_apolice_user(@userCod int) RETURNS INT AS
BEGIN 
RETURN (SELECT COUNT(a.cod_cliente) FROM apolice a WHERE a.cod_cliente = @userCod)
END;
SELECT c.nome as nome, dbo.fn_apolice_user(c.cod_cliente) as apolices FROM cliente c--19 select * from apoliceselect * from clienteCREATE PROC retorna (@cod_cliente INT, @apolicesRetornadas INT OUTPUT) ASBEGIN		SELECT @apolicesRetornadas = Count(cod_cliente)	FROM apolice 	WHERE cod_cliente = @cod_cliente	ENDdeclare @a INT  exec retorna 2, @a OUTPUTselect * from apolice