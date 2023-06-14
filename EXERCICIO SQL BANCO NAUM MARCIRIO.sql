-- 1. (objetiva) Uma store procedure suporta:-- c) Par�metros de entrada e sa�da.--2 (objetiva) Uma trigger suporta:-- a) Nenhum par�metro.--3. (objetiva) Uma fun��o suporta:-- b) Somente par�metros de entrada.--4. (m�ltipla escolha) Se considerarmos a assinatura da stored procedure a seguir, podemos afirmar que:-- a) A procedure retorna um valor inteiro ap�s sua execu��o.-- e) O nome da procedure � x; y e z s�o par�metros.--5. (m�ltipla escolha) Se considerarmos a assinatura da fun��o escalar a seguir, podemos afirmar que:--a) A fun��o retorna um valor inteiro ap�s sua execu��o.--c) A fun��o possui um par�metro.--e) O nome da fun��o � x; y � um par�metro; e retorna um valor inteiro.--6 Crie uma stored procedure que informe quantos carros possui cada cliente (a resposta deve ser uma lista
--  com os campos - cod_cliente, nome, cpf, qt_carros. (4 colunas)
--  Escreva tamb�m os comandos usados para execu��o da stored procedure.select * from apoliceselect * from clienteselect * from carroCREATE PROC quant_carros ASBEGIN	SELECT c.cod_cliente as 'C�digo do Cliente', c.nome as 'Nome', c.cpf as 'CPF', COUNT(a.cod_cliente) as 'QT_CARROS'	FROM cliente c LEFT JOIN apolice a ON c.cod_cliente = a.cod_cliente	GROUP BY c.cod_cliente,c.nome,c.cpfENDdrop proc if exists quant_carrosexec quant_carros--7	   Crie uma fun��o que informe a quantidade de carros de um determinado cliente. Monte um SELECT na
--     tabela cliente, com os campos cod_cliente, nome, cpf, qt_carros (4 colunas)
--     O campo qt_carros � a chamada da fun��o.CREATE FUNCTION quant_carro (@cod_cliente INT) RETURNS INT AS
BEGIN
  declare @qtd int

  SELECT @qtd  = COUNT(a.cod_cliente) FROM cliente c LEFT JOIN apolice a ON c.cod_cliente = a.cod_cliente WHERE c.cod_cliente = @cod_cliente

  return @qtd
END

select dbo.quant_carro(3)
-- 8. Dado o modelo abaixo, crie uma trigger que guarde todos os eventos de DELETE da tabela apolice, na
--    tabela apolice_log_exclusao. Use a fun��o suser_name() para capturar o nome do usu�rio.



select * from apolice


CREATE TABLE apolice_log_exclusao (
	dt_exclusao DATETIME NOT NULL,
	usuario_exclusao VARCHAR(100) NOT NULL,
	cod_apolice INT NOT NULL,
	cod_cliente INT NOT NULL,
	data_inicio_vigencia DATE NOT NULL,
	data_fim_vigencia DATE NOT NULL,
	valor_cobertura NUMERIC(10,2) NOT NULL,
	valor_franquia NUMERIC(10,2) NOT NULL,
	placa CHAR(10))



CREATE TRIGGER tr_apolice_delete
ON apolice
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @apolice_id INT;
    DECLARE @usuario NVARCHAR(100);
    DECLARE @data_exclusao DATETIME;

    DECLARE cur_exclusoes CURSOR FOR
        SELECT @apolice_id, SUSER_NAME(), GETDATE()
        FROM deleted;

    OPEN cur_exclusoes;

    FETCH NEXT FROM cur_exclusoes INTO @apolice_id, @usuario, @data_exclusao;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO apolice_log_exclusao 
        SELECT @data_exclusao, SUSER_NAME(),cod_apolice,cod_cliente,data_inicio_vigencia, data_fim_vigencia, valor_cobertura, valor_franquia, placa
		FROM deleted

        FETCH NEXT FROM cur_exclusoes INTO @apolice_id, @usuario, @data_exclusao;
    END;

    CLOSE cur_exclusoes;
    DEALLOCATE cur_exclusoes;
END;

select * from apolice_log_exclusao


