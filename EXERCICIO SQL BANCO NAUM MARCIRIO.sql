-- 1. (objetiva) Uma store procedure suporta:
--  com os campos - cod_cliente, nome, cpf, qt_carros. (4 colunas)
--  Escreva tamb�m os comandos usados para execu��o da stored procedure.
--     tabela cliente, com os campos cod_cliente, nome, cpf, qt_carros (4 colunas)
--     O campo qt_carros � a chamada da fun��o.
BEGIN
  declare @qtd int

  SELECT @qtd  = COUNT(a.cod_cliente) FROM cliente c LEFT JOIN apolice a ON c.cod_cliente = a.cod_cliente WHERE c.cod_cliente = @cod_cliente

  return @qtd
END

select dbo.quant_carro(3)

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

