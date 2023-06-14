--EXERCICIOS FUNÇÕES


--QUESTAO 1 

create function fn_idade (@data datetime) returns int as
begin
declare @idade int
select @idade = floor(datediff(day, @data, getdate()) / 365.25)
return @idade
end
go





ALTER FUNCTION retorna_dia_da_semana (@data DATETIME) RETURNS VARCHAR(50) AS
BEGIN
	DECLARE @dia VARCHAR(50)
	SELECT @dia= datename (dw,@data)
	return @dia
END


SELECT dbo.retorna_dia_da_semana(2021-12-26)