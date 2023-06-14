-- 1. (objetiva) Uma store procedure suporta:-- c) Parâmetros de entrada e saída.--2 (objetiva) Uma trigger suporta:-- a) Nenhum parâmetro.--3. (objetiva) Uma função suporta:-- b) Somente parâmetros de entrada.--4. (múltipla escolha) Se considerarmos a assinatura da stored procedure a seguir, podemos afirmar que:-- a) A procedure retorna um valor inteiro após sua execução.-- e) O nome da procedure é x; y e z são parâmetros.--5. (múltipla escolha) Se considerarmos a assinatura da função escalar a seguir, podemos afirmar que:--a) A função retorna um valor inteiro após sua execução.--c) A função possui um parâmetro.--e) O nome da função é x; y é um parâmetro; e retorna um valor inteiro.--6 Crie uma stored procedure que informe quantos carros possui cada cliente (a resposta deve ser uma lista
--  com os campos - cod_cliente, nome, cpf, qt_carros. (4 colunas)
--  Escreva também os comandos usados para execução da stored procedure.select * from apoliceselect * from clienteselect * from carroCREATE PROC quant_carros ASBEGIN	SELECT c.cod_cliente as 'Código do Cliente', c.nome as 'Nome', c.cpf as 'CPF', COUNT(a.cod_cliente) as 'QT_CARROS'	FROM cliente c LEFT JOIN apolice a ON c.cod_cliente = a.cod_cliente	GROUP BY c.cod_cliente,c.nome,c.cpfENDdrop proc if exists quant_carrosexec quant_carros--7	   Crie uma função que informe a quantidade de carros de um determinado cliente. Monte um SELECT na
--     tabela cliente, com os campos cod_cliente, nome, cpf, qt_carros (4 colunas)
--     O campo qt_carros é a chamada da função.CREATE FUNCTION quant_carro (@cod_cliente INT) RETURNS INT AS
BEGIN
  declare @qtd int

  SELECT @qtd  = COUNT(a.cod_cliente) FROM cliente c LEFT JOIN apolice a ON c.cod_cliente = a.cod_cliente WHERE c.cod_cliente = @cod_cliente

  return @qtd
END

select dbo.quant_carro(3)
-- 8. Dado o modelo abaixo, crie uma trigger que guarde todos os eventos de DELETE da tabela apolice, na
--    tabela apolice_log_exclusao. Use a função suser_name() para capturar o nome do usuário.



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


