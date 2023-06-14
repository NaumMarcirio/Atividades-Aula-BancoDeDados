--1. 

CREATE PROC quant_sinistro (@placa VARCHAR(10), @qtd_sinistros INT OUTPUT) AS
BEGIN
	SELECT @qtd_sinistros = COUNT(placa) FROM sinistro WHERE placa = @placa
END
go

DECLARE @qtd_sinistro INT

EXEC quant_sinistro 'ALD3834', @qtd_sinistro OUTPUT
SELECT @qtd_sinistro

DROP proc if exists quant_sinistro 

select * from sinistro



--2. 


ALTER PROC renovaApolice ( @data DATE) AS
BEGIN
	CREATE TABLE #renovacao_Apolice (
		cod_apolice INT,
		nome VARCHAR(30), 
		placa VARCHAR(10), 
		marca VARCHAR(30), 
		modelo VARCHAR(30), 
		ano INT, 
		valor_cobertura NUMERIC(10,2), 
		valor_franquia NUMERIC(10,2),
	    data_inicio_vigencia DATE, 
		data_fim_vigencia DATE,
		qt_sinistro INT, 
		desconto_acrescimo NUMERIC (10,2), 
		tp_percentual_aplicado VARCHAR(30))

		
	DECLARE @placa VARCHAR(10), @cod_cliente INT
	DECLARE percorre_cursor cursor 
	for  SELECT placa, cod_cliente FROM  apolice WHERE data_fim_vigencia < @data
	OPEN percorre_cursor
	FETCH percorre_cursor into @placa, @cod_cliente
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @qtd_sinistro INT
		EXEC quant_sinistro @placa, @qtd_sinistro OUTPUT
		
		IF(@qtd_sinistro = 0 )
		BEGIN
			INSERT INTO #renovacao_Apolice
			VALUES ((SELECT cod_apolice FROM  apolice WHERE placa = @placa and cod_cliente = @cod_cliente),
					(SELECT c.nome FROM cliente c  INNER JOIN apolice a ON c.cod_cliente = a.cod_cliente WHERE a.placa = @placa and a.cod_cliente = @cod_cliente),
					(SELECT placa FROM  apolice WHERE placa = @placa and cod_cliente = @cod_cliente),
					(SELECT c.marca FROM  carro c INNER JOIN apolice a ON c.placa = a.placa WHERE a.placa = @placa and a.cod_cliente = @cod_cliente),
					(SELECT c.modelo FROM  carro c INNER JOIN apolice a ON c.placa = a.placa WHERE a.placa = @placa and a.cod_cliente = @cod_cliente),
					(SELECT c.ano FROM  carro c INNER JOIN apolice a ON c.placa = a.placa WHERE a.placa = @placa and a.cod_cliente = @cod_cliente),
					(SELECT valor_cobertura FROM  apolice WHERE placa = @placa and cod_cliente = @cod_cliente),
					(SELECT valor_franquia * 0.9 FROM  apolice WHERE placa = @placa and cod_cliente = @cod_cliente),
					GETDATE(),
					DATEADD ( MONTH,12, GETDATE()),
					@qtd_sinistro,
					'D',
					'10%')			
		END
		ELSE IF(@qtd_sinistro = 1 )
		BEGIN
			INSERT INTO #renovacao_Apolice
			VALUES ((SELECT cod_apolice FROM  apolice WHERE placa = @placa and cod_cliente = @cod_cliente),
					(SELECT c.nome FROM cliente c  INNER JOIN apolice a ON c.cod_cliente = a.cod_cliente WHERE a.placa = @placa and a.cod_cliente = @cod_cliente),
					(SELECT placa FROM  apolice WHERE placa = @placa and cod_cliente = @cod_cliente),
					(SELECT c.marca FROM  carro c INNER JOIN apolice a ON c.placa = a.placa WHERE a.placa = @placa and a.cod_cliente = @cod_cliente),
					(SELECT c.modelo FROM  carro c INNER JOIN apolice a ON c.placa = a.placa WHERE a.placa = @placa and a.cod_cliente = @cod_cliente),
					(SELECT c.ano FROM  carro c INNER JOIN apolice a ON c.placa = a.placa WHERE a.placa = @placa and a.cod_cliente = @cod_cliente),
					(SELECT valor_cobertura FROM  apolice WHERE placa = @placa and cod_cliente = @cod_cliente),
					(SELECT valor_franquia * 1.05 FROM  apolice WHERE placa = @placa and cod_cliente = @cod_cliente),
					GETDATE(),
					DATEADD ( MONTH,12, GETDATE()),
					@qtd_sinistro,
					'A',
					'5%')			
		END
		ELSE IF(@qtd_sinistro = 2 )
		BEGIN
			INSERT INTO #renovacao_Apolice
			VALUES ((SELECT cod_apolice FROM  apolice WHERE placa = @placa and cod_cliente = @cod_cliente),
					(SELECT c.nome FROM cliente c  INNER JOIN apolice a ON c.cod_cliente = a.cod_cliente WHERE a.placa = @placa and a.cod_cliente = @cod_cliente),
					(SELECT placa FROM  apolice WHERE placa = @placa and cod_cliente = @cod_cliente),
					(SELECT c.marca FROM  carro c INNER JOIN apolice a ON c.placa = a.placa WHERE a.placa = @placa and a.cod_cliente = @cod_cliente),
					(SELECT c.modelo FROM  carro c INNER JOIN apolice a ON c.placa = a.placa WHERE a.placa = @placa and a.cod_cliente = @cod_cliente),
					(SELECT c.ano FROM  carro c INNER JOIN apolice a ON c.placa = a.placa WHERE a.placa = @placa and a.cod_cliente = @cod_cliente),
					(SELECT valor_cobertura FROM  apolice WHERE placa = @placa and cod_cliente = @cod_cliente),
					(SELECT valor_franquia * 1.1 FROM  apolice WHERE placa = @placa and cod_cliente = @cod_cliente),
					GETDATE(),
					DATEADD ( MONTH,12, GETDATE()),
					@qtd_sinistro,
					'A',
					'10%')			
		END
		ELSE IF(@qtd_sinistro >= 3 )
		BEGIN
			INSERT INTO #renovacao_Apolice
			VALUES ((SELECT cod_apolice FROM  apolice WHERE placa = @placa and cod_cliente = @cod_cliente),
					(SELECT c.nome FROM cliente c  INNER JOIN apolice a ON c.cod_cliente = a.cod_cliente WHERE a.placa = @placa and a.cod_cliente = @cod_cliente),
					(SELECT placa FROM  apolice WHERE placa = @placa and cod_cliente = @cod_cliente),
					(SELECT c.marca FROM  carro c INNER JOIN apolice a ON c.placa = a.placa WHERE a.placa = @placa and a.cod_cliente = @cod_cliente),
					(SELECT c.modelo FROM  carro c INNER JOIN apolice a ON c.placa = a.placa WHERE a.placa = @placa and a.cod_cliente = @cod_cliente),
					(SELECT c.ano FROM  carro c INNER JOIN apolice a ON c.placa = a.placa WHERE a.placa = @placa and a.cod_cliente = @cod_cliente),
					(SELECT valor_cobertura FROM  apolice WHERE placa = @placa and cod_cliente = @cod_cliente),
					(SELECT valor_franquia * 1.15 FROM  apolice WHERE placa = @placa and cod_cliente = @cod_cliente),
					GETDATE(),
					DATEADD ( MONTH,12, GETDATE()),
					@qtd_sinistro,
					'A',
					'15%')
					
		END
	SELECT * FROM #renovacao_Apolice
	END
	CLOSE percorre_cursor
	DEALLOCATE percorre_cursor
END
go






--3. Crie uma store procedure que mova todos os dados de um cliente para outro cliente.
--A procedure deverá ter duas variáveis de entrada: código do cliente de origem e código do cliente de destino.
--Considere criar um controle transacional para que caso alguma operação de update falhe, todo o processo
--seja desfeito.



CREATE PROC move_Dados ( @cod_cliente_origem INT, @cod_cliente_destino INT) AS
BEGIN
	 DECLARE @nome VARCHAR(50),@cpf VARCHAR(11), @sexo char(1), @endereco VARCHAR(200), @telefone_fixo VARCHAR(50) , @telefone_celular VARCHAR(50)
	 DECLARE @nomeD VARCHAR(50),@cpfD VARCHAR(11), @sexoD char(1), @enderecoD VARCHAR(200), @telefone_fixoD VARCHAR(50) , @telefone_celularD VARCHAR(50)
		
		SELECT @nome = nome, @cpf= cpf, @sexo = sexo, @endereco = endereco, @telefone_fixo = telefone_fixo, @telefone_celular = telefone_celular 
		FROM cliente
		WHERE cod_cliente = @cod_cliente_origem
		
		SELECT @nomeD = nome, @cpfD = cpf, @sexoD = sexo, @enderecoD = endereco, @telefone_fixoD = telefone_fixo, @telefone_celularD = telefone_celular 
		FROM cliente
		WHERE cod_cliente = @cod_cliente_destino
		
		UPDATE cliente
		SET  nome = @nome,  cpf= @cpf, sexo= @sexo ,endereco = @endereco, telefone_fixo = @telefone_fixo, telefone_celular  = @telefone_celular
		WHERE cod_cliente = @cod_cliente_destino

		UPDATE cliente
		SET  nome = @nomeD,  cpf= @cpfD, sexo= @sexoD ,endereco = @enderecoD, telefone_fixo = @telefone_fixoD, telefone_celular  = @telefone_celularD
		WHERE cod_cliente = @cod_cliente_origem	 
END

select * from cliente
BEGIN TRAN
EXEC move_Dados 1, 5
commit
ROLLBACK
SELECT @@TRANCOUNT
DROP PROC IF EXISTS move_Dados







