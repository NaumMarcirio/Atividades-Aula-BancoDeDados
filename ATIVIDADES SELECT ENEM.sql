-- LISTA DE ATIVIDADES SOBRE SELECT--
SELECT TOP 200 *
FROM MICRODADOS_ENEM_2021_SC

--1. Qual � a m�dia da nota em matem�tica dos alunos que estudaram numa escola em Santa Catarina?

SELECT ROUND(AVG(NU_NOTA_MT),2) AS 'M�DIA NOTAS MATEM�TICA SC'
FROM MICRODADOS_ENEM_2021_SC
WHERE SG_UF_ESC = 'SC'

--2. Qual � a m�dia da nota em Linguagens e C�digos dos alunos que estudaram numa escola em Santa Catarina?

SELECT ROUND(AVG(NU_NOTA_LC),2)
FROM MICRODADOS_ENEM_2021_SC
WHERE SG_UF_ESC = 'SC'

--3. Qual � a m�dia da nota em Ci�ncias Humanas dos alunos do sexo FEMININO que estudaram numa escola em Santa Catarina?

SELECT ROUND(AVG(NU_NOTA_CH),2) 
FROM MICRODADOS_ENEM_2021_SC
WHERE TP_SEXO = 'F' AND SG_UF_PROVA = 'SC'

--4. Qual � a soma das notas em Matem�tica dos alunos do sexo FEMININO que estudaram numa escola na cidade de Crici�ma?

SELECT SUM(NU_NOTA_MT) AS 'SOMAT�RIO NOTAS MATEM�TICA SC FEMININO'
FROM MICRODADOS_ENEM_2021_SC
WHERE NO_MUNICIPIO_ESC = 'Criciuma' AND TP_SEXO = 'F'

--5. Qual � a diferen�a da nota m�dia em matem�tica dos alunos que estudaram o ensino m�dio em escola p�blica e em escola privada?

SELECT ((SELECT AVG(NU_NOTA_MT) FROM MICRODADOS_ENEM_2021_SC WHERE TP_ESCOLA = 3)
-
(SELECT AVG(NU_NOTA_MT) FROM MICRODADOS_ENEM_2021_SC WHERE TP_ESCOLA = 2 )) 

AS 'M�DIA ESCOLA P�BLICA E PARTICULAR'


--6. Quantos alunos n�o quiseram declarar a cor/ra�a em 2020 em SC (Entenda a op��o "n�o declarado" nessa pergunta)?

SELECT COUNT(TP_COR_RACA) AS 'N�MERO DE PESSOAS QUE N�O DECLARARAM RA�A'
FROM MICRODADOS_ENEM_2021_SC
WHERE TP_COR_RACA = 0 AND SG_UF_PROVA = 'SC'

--7. Qual � o n�mero de alunos do sexo feminino que estudaram em escola no estado de Santa Catarina?

SELECT COUNT(TP_SEXO)
FROM MICRODADOS_ENEM_2021_SC
WHERE SG_UF_ESC = 'SC' AND TP_SEXO = 'F'

--8. Quantos alunos do sexo masculino que estudaram em escola no estado de Santa Catarina possuem EXATAMENTE uma geladeira em casa?

SELECT COUNT(TP_SEXO)
FROM MICRODADOS_ENEM_2021_SC
WHERE SG_UF_ESC = 'SC' AND TP_SEXO = 'M' AND Q012 = 'B'

--9. Quantos alunos que estudaram em escolas em zona rural de Santa Catarina possuem internet em casa?

SELECT COUNT(TP_LOCALIZACAO_ESC )
FROM MICRODADOS_ENEM_2021_SC
WHERE TP_LOCALIZACAO_ESC = 2 AND SG_UF_ESC = 'SC'

--10. Quantos alunos cuja resid�ncia possui AT� 2 carros que estudaram em uma escola de Blumenau?

SELECT COUNT(Q010)
FROM MICRODADOS_ENEM_2021_SC
WHERE Q010 IN('A','B','C') AND NO_MUNICIPIO_ESC = 'Blumenau'

--11. Qual � a segunda cidade catarinense (considere a coluna NO_MUNICIPIO_ESC) em que estudaram mais alunos no ENEM 2021?

SELECT NO_MUNICIPIO_ESC AS 'NOME MUNIC�PIO', COUNT(NO_MUNICIPIO_ESC) AS 'N�MERO DE ALUNOS' 
FROM MICRODADOS_ENEM_2021_SC
WHERE SG_UF_ESC = 'SC'
GROUP BY NO_MUNICIPIO_ESC
ORDER BY [N�MERO DE ALUNOS] DESC


--12. Qual � a cidade catarinense (considere a coluna NO_MUNICIPIO_ESC) possui o menor n�mero de alunos cuja m�e possui ensino superior completo?

SELECT NO_MUNICIPIO_ESC AS 'NOME MUNIC�PIO', COUNT(NO_MUNICIPIO_ESC) AS 'N�MERO DE ALUNOS'
FROM MICRODADOS_ENEM_2021_SC
WHERE Q002 = 'F'
GROUP BY NO_MUNICIPIO_ESC
ORDER BY [N�MERO DE ALUNOS]  ASC

--13. Qual � a segunda cidade catarinense (considere a coluna NO_MUNICIPIO_ESC) que possui o maior n�mero de pessoas na faixa �entre 26 e 30 anos�?

SELECT NO_MUNICIPIO_ESC AS 'NOME MUNIC�PIO', COUNT(NO_MUNICIPIO_ESC) AS 'N�MERO DE ALUNOS'
FROM MICRODADOS_ENEM_2021_SC
WHERE TP_FAIXA_ETARIA = 11
GROUP BY NO_MUNICIPIO_ESC
ORDER BY [N�MERO DE ALUNOS] DESC

--14. Qual � a cidade catarinense (considere a coluna NO_MUNICIPIO_ESC) que possui o TERCEIRO maior n�mero de alunos cuja resid�ncia possui PELO MENOS 2 banheiros?

SELECT NO_MUNICIPIO_ESC AS 'NOME MUNIC�PIO', COUNT(NO_MUNICIPIO_ESC) AS 'N�MERO DE ALUNOS'
FROM MICRODADOS_ENEM_2021_SC
WHERE Q008 IN('C','D','E')
GROUP BY NO_MUNICIPIO_ESC
ORDER BY [N�MERO DE ALUNOS] DESC