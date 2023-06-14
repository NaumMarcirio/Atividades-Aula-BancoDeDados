-- EXERCICIOS TRIGGERS


CREATE TABLE conta (
	cod_conta INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	nome VARCHAR(50) NOT NULL,
	status_conta INT NOT NULL
	)


CREATE TABLE lancamento (
	data_operacao DATE NOT NULL,
	cod_conta INT NOT NULL FOREIGN KEY references conta(cod_conta),
	desc_op VARCHAR(100) NOT NULL,
	tipo_op CHAR NOT NULL,
	valor NUMERIC(14,2) NOT NULL
	)

	
CREATE TABLE saldo (
	data_saldo DATE NOT NULL,
	cod_conta INT NOT NULL FOREIGN KEY references conta(cod_conta),
	valor_saldo NUMERIC(14,2) NOT NULL
	)









--QUESTAO 1

--1. Criar uma procedure que adicione um lançamento.
--Considerar que esta operação de lançamento deverá atualizar o saldo da conta através de uma trigger (insert).
--Caso exista o registro de saldo do dia do lançamento, atualizar o saldo, senão, inserir o saldo.
--Utilize throw para gerar as mensagens ao usuário (ao invés de PRINT) e as demais melhores práticas citadas
--em aula.

SELECT * FROM lancamento
Select * from conta
select * from saldo

CREATE PROC add_lancamento(@cod_conta INT, @desc_op VARCHAR(100), @tipo_op CHAR, @valor NUMERIC(14,2)) AS
BEGIN
	IF (SELECT valor_saldo from saldo where cod_conta = @cod_conta > @valor)
	BEGIN
		INSERT INTO lancamento
		VALUES (GETDATE(),@cod_conta,@desc_op,@tipo_op,@valor)
	END
	ELSE
	BEGIN
		THROW 666, 'SALDO INSUFICIENTE', 1; 
	END
END
go

CREATE TRIGGER att_saldo ON (saldo) FOR INSERT AS
BEGIN
	IF (SELECT data_saldo FROM saldo WHERE cod_conta = @cod_conta) = GETDATE()
	BEGIN
		UPDATE saldo SET valor_saldo = (SELECT valor_saldo FROM saldo WHERE cod_conta = @cod_conta and data_saldo = GETDATE()) + @valor
	END
	ELSE
	BEGIN
		INSERT INTO saldo
		VALUES (GETDATE(),@cod_conta,@valor)
	END
END
