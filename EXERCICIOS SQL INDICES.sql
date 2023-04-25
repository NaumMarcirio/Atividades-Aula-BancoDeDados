-- EXERCICIOS SOBRE INDICE

--1.
select * from dbo.MICRODADOS_ENEM_2021_SC

--3.
sp_helpindex MICRODADOS_ENEM_2021_SC
sp_spaceused MICRODADOS_ENEM_2021_SC

--4.
ALTER TABLE MICRODADOS_ENEM_2021_SC ALTER COLUMN NU_INSCRICAO bigint NOT NULL; -- FOI NECESSARIO MUDAR O CAMPO PARA NÃO ACEITAR VALOR NULO PARA CRIAR O INDICE
ALTER TABLE MICRODADOS_ENEM_2021_SC ADD CONSTRAINT pk_MICRODADOS_ENEM_2021_SC PRIMARY KEY (NU_INSCRICAO)
sp_helpindex MICRODADOS_ENEM_2021_SC

--5 
SELECT * FROM MICRODADOS_ENEM_2021_SC
-- VERIFICAÇÃO DE INDICE CLUSTERIZADO 

--6 

SELECT * FROM MICRODADOS_ENEM_2021_SC
WHERE  NO_MUNICIPIO_ESC = 'Treviso'


--7
SET STATISTICS TIME ON;
SET STATISTICS IO ON;


--8
-- SEM WHERE RETORNA 26394 REGISTROS, COM TEMPO DECORRIDO DE 886ms, Contagem de verificações 1, leituras lógicas 2977, leituras físicas 0, leituras de servidor de páginas 0, leituras antecipadas 0, leituras antecipadas de servidor de páginas 0, leituras lógicas de LOB 0, leituras físicas de LOB 0, leituras de servidor de páginas LOB 0, leituras antecipadas de LOB 0, leituras antecipadas do servidor de páginas LOB 0.
-- COM WHERE RETORNA 12 REGISTROS, COM TEMPPO DECORRIDO DE  12ms,   Contagem de verificações 1, leituras lógicas 2977, leituras físicas 0, leituras de servidor de páginas 0, leituras antecipadas 0, leituras antecipadas de servidor de páginas 0, leituras lógicas de LOB 0, leituras físicas de LOB 0, leituras de servidor de páginas LOB 0, leituras antecipadas de LOB 0, leituras antecipadas do servidor de páginas LOB 0.


--9 

CREATE NONCLUSTERED INDEX  idx_NO_MUNICIPIO_ESC ON MICRODADOS_ENEM_2021_SC (NO_MUNICIPIO_ESC)
sp_helpindex MICRODADOS_ENEM_2021_SC

--10

SELECT NO_MUNICIPIO_ESC, TP_ESCOLA
FROM MICRODADOS_ENEM_2021_SC WHERE NO_MUNICIPIO_ESC = 'Treviso'  --leituras lógicas 32, tempo decorrido = 0 ms.

SELECT NO_MUNICIPIO_ESC, TP_ESCOLA
FROM MICRODADOS_ENEM_2021_SC -- leituras lógicas 2977, tempo decorrido = 195 ms.

--11

SELECT NO_MUNICIPIO_ESC, TP_ESCOLA
FROM MICRODADOS_ENEM_2021_SC WHERE NO_MUNICIPIO_ESC = 'Treviso'

DROP INDEX MICRODADOS_ENEM_2021_SC.idx_NO_MUNICIPIO_ESC /*OU*/ DROP INDEX idx_NO_MUNICIPIO_ESC ON MICRODADOS_ENEM_2021_SC
CREATE INDEX idx_NO_MUNICIPIO_ESC on MICRODADOS_ENEM_2021_SC (NO_MUNICIPIO_ESC) INCLUDE (TP_ESCOLA);


--12

--opcao 1
select c.*
from carro c left join apolice a on c.placa = a.placa
where cod_apolice is null
go

--opcao 2
select *
from carro
where placa not in (select placa from apolice)
go

--opcao 2 com not exists select *
select *
from carro
where not exists (select *
                  from apolice
				  where carro.placa = apolice.placa)
go

--opcao 2 com not exists select 1
select *
from carro
where not exists (select 1
                  from apolice
				  where carro.placa = apolice.placa)
go