--QUESTAO 1

CREATE PROC soma (@valor1 NUMERIC(14,2), @valor2 NUMERIC(14,2)) AS
BEGIN
	SELECT @valor1 + @valor2
END
go


--QUESTAO 2

CREATE PROC imc (@massa NUMERIC(14,2), @altura NUMERIC(14,2), @imc NUMERIC(14,2) OUTPUT) AS
BEGIN
	SET @imc = @massa/POWER(@altura,2)
END
go



--QUESTAO 3

CREATE PROC media (@num1 NUMERIC(14,2), @num2 NUMERIC(14,2), @num3 NUMERIC(14,2), @num4 NUMERIC(14,2), @media NUMERIC(14,2) OUTPUT) AS
BEGIN
	IF (@num1 IS NULL or @num2 IS NULL or @num3 IS NULL or @num4
	BEGIN
		SELECT 'TESTE'
	END
	ELSE
	BEGIN
		SET @media = (@num1 + @num2 + @num3 + @num4)/4
	END
END
go

DECLARE @media NUMERIC(14,2) 






--QUESTAO 4


CREATE PROC renovaApolice AS
BEGIN
	SELECT a.cod_apolice, cl.nome, cr.placa, cr.marca, cr.modelo, cr.ano, a.valor_cobertura,
		   a.valor_cobertura * 1.05 as 'valor_cobertura_5%', a.valor_franquia * 1.05 as 'valor_franquia_5%',
	       getdate() as 'data_inicio_vigencia', GETDATE() AS 'data_fim_vigencia'
	FROM  apolice a INNER JOIN cliente cl ON a.cod_cliente = cl.cod_cliente INNER JOIN carro cr ON cr.placa = a.placa
	WHERE data_fim_vigencia < GETDATE()
END
go









--QUESTAO 5
CREATE PROC verifica_apolice (@cod_apolice INT) AS
BEGIN
	IF EXISTS(SELECT * FROM apolice a WHERE cod_apolice = @cod_apolice)
	BEGIN
		IF(SELECT data_fim_vigencia from apolice WHERE cod_apolice = @cod_apolice) < GETDATE()
		BEGIN
			PRINT 'VENCIDA'
		END
		ELSE
		BEGIN
			PRINT 'ATIVA'
		END
	END
	ELSE
	BEGIN
		PRINT 'INEXISTENTE'
	END
END
go
EXEC verifica_apolice 202200001

DROP PROC verifica_apolice



-- QUESTAO 6

	
 ALTER PROC verifica_placa (@placa VARCHAR(10)) AS 
BEGIN
	DECLARE @cliente VARCHAR(30),
			@marca VARCHAR (30),
			@modelo VARCHAR (30),
			@ano VARCHAR(30),
			@cor VARCHAR(30),
			@sinistro VARCHAR(30)

	SELECT @cliente = cl.nome,@marca = cr.marca, @modelo = cr.modelo, @ano = cr.ano, @cor = cr.cor, @sinistro = count(s.placa) OVER(PARTITION BY s.placa)
	FROM 
	cliente cl INNER JOIN apolice a ON cl.cod_cliente = a.cod_cliente 
	INNER JOIN carro cr ON a.placa = cr.placa 
	LEFT JOIN sinistro s ON cr.placa = s.placa
	WHERE cr.placa = @placa
	IF EXISTS(SELECT * FROM apolice WHERE placa = @placa)
	BEGIN
		PRINT '--------------------------------------------------'
		PRINT 'CLIENTE: ' + @cliente + ' ALUNO DA SATC'
		PRINT 'CARRO: ' +  @modelo + ' | '+ @marca + ' | ' + @ano + ' | ' + @cor
		PRINT 'SINISTROS: ' + @sinistro
		PRINT '--------------------------------------------------'
	END
	ELSE
	BEGIN
		PRINT '--------------------------------------------------'
		PRINT 'PLACA NÃO LOCALIZADA'
		PRINT '--------------------------------------------------'
	END
END
go
EXEC verifica_placa NEM51X16
select * from carro

DROP PROC  IF EXISTS verifica_placa

--QUESTAO 7

SELECT * FROM carro

CREATE PROC insere_Carro (@placa VARCHAR(10), @modelo VARCHAR(30), @chassi VARCHAR(30), @marca VARCHAR(30), @ano INT, @cor VARCHAR(30)) AS
BEGIN
	INSERT INTO carro
	values (@placa,@modelo,@chassi,@marca,@ano,@cor)
	SELECT * FROM carro
END
go

DROP PROC IF EXISTS insere_Carro
exec insere_Carro 'QJK1233', 'CHEVETTE', '28910381231', 'CHEVROLET', 1975, 'AZULESCURO'




--QUESTAO 8

create proc conta_sinistros (@placa varchar(10), @nome varchar(30), @sinistros int output) as
begin
	if @placa is null
	begin 
		if @nome is not null
		begin
			set @nome = '%'+@nome+'%'
			select @sinistros = COUNT(s.placa)
  				from sinistro s inner join apolice a on s.placa = a.placa 
				inner join cliente c on a.cod_cliente = c.cod_cliente
				where c.nome like upper(@nome)
		end
		else print 'nenhum parametro passado'
	end

	if @nome is null
	begin 
		if @placa is not null
		begin
			select @sinistros = COUNT(placa)
  				from sinistro 
				where placa = @placa
		end
		else print 'nenhum parametro passado'
	end
end
go

declare @qtd_sinistro int
exec conta_sinistros 'MZT1826', null, @qtd_sinistro output 
select @qtd_sinistro



--QUESTAO 9


CREATE PROC adiciona_Sinistro (@cod_sinistro INT, @placa VARCHAR(10),@local_sinistro VARCHAR(100), @condutor CHAR(100)) AS 
BEGIN
	IF EXISTS (SELECT * FROM sinistro WHERE @placa = placa)
	BEGIN
		INSERT INTO sinistro
		VALUES(@cod_sinistro, @placa, GETDATE(), CONVERT (VARCHAR,GETDATE(),108),@local_sinistro,@condutor)
	END 
	ELSE
	BEGIN
		PRINT 'CARRO NÃO ENCONTRADO'
	END
END
go 
DROP PROC adiciona_Sinistro
SELECT * FROM sinistro 
	

EXEC adiciona_Sinistro  202255509, MZT1122, URUSSANGA, RAFAEL



--QUESTAO 10


create proc clientes_sinistro (@n int) as
begin
	SELECT top (@n) c.nome, ROW_NUMBER() OVER (ORDER BY COUNT(s.placa) DESC) AS posicao_ranking,
		COUNT(s.placa) AS qt_sinistros
        FROM sinistro s
        INNER JOIN carro ca ON s.placa = ca.placa
        INNER JOIN apolice a ON ca.placa = a.placa
		INNER JOIN CLIENTE c ON a.cod_cliente = c.cod_cliente
        GROUP BY c.nome
end
go

exec clientes_sinistro 3



