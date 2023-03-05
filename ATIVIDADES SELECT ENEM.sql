-- LISTA DE ATIVIDADES SOBRE SELECT--
SELECT TOP 200 *
FROM MICRODADOS_ENEM_2021_SC

--1. Qual é a média da nota em matemática dos alunos que estudaram numa escola em Santa Catarina?

SELECT ROUND(AVG(NU_NOTA_MT),2) AS 'MÉDIA NOTAS MATEMÁTICA SC'
FROM MICRODADOS_ENEM_2021_SC
WHERE SG_UF_ESC = 'SC'

--2. Qual é a média da nota em Linguagens e Códigos dos alunos que estudaram numa escola em Santa Catarina?

SELECT ROUND(AVG(NU_NOTA_LC),2)
FROM MICRODADOS_ENEM_2021_SC
WHERE SG_UF_ESC = 'SC'

--3. Qual é a média da nota em Ciências Humanas dos alunos do sexo FEMININO que estudaram numa escola em Santa Catarina?

SELECT ROUND(AVG(NU_NOTA_CH),2) 
FROM MICRODADOS_ENEM_2021_SC
WHERE TP_SEXO = 'F' AND SG_UF_PROVA = 'SC'

--4. Qual é a soma das notas em Matemática dos alunos do sexo FEMININO que estudaram numa escola na cidade de Criciúma?

SELECT SUM(NU_NOTA_MT) AS 'SOMATÓRIO NOTAS MATEMÁTICA SC FEMININO'
FROM MICRODADOS_ENEM_2021_SC
WHERE NO_MUNICIPIO_ESC = 'Criciuma' AND TP_SEXO = 'F'

--5. Qual é a diferença da nota média em matemática dos alunos que estudaram o ensino médio em escola pública e em escola privada?

SELECT ((SELECT AVG(NU_NOTA_MT) FROM MICRODADOS_ENEM_2021_SC WHERE TP_ESCOLA = 3)
-
(SELECT AVG(NU_NOTA_MT) FROM MICRODADOS_ENEM_2021_SC WHERE TP_ESCOLA = 2 )) 

AS 'MÉDIA ESCOLA PÚBLICA E PARTICULAR'


--6. Quantos alunos não quiseram declarar a cor/raça em 2020 em SC (Entenda a opção "não declarado" nessa pergunta)?

SELECT COUNT(TP_COR_RACA) AS 'NÚMERO DE PESSOAS QUE NÃO DECLARARAM RAÇA'
FROM MICRODADOS_ENEM_2021_SC
WHERE TP_COR_RACA = 0 AND SG_UF_PROVA = 'SC'

--7. Qual é o número de alunos do sexo feminino que estudaram em escola no estado de Santa Catarina?

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

--10. Quantos alunos cuja residência possui ATÉ 2 carros que estudaram em uma escola de Blumenau?

SELECT COUNT(Q010)
FROM MICRODADOS_ENEM_2021_SC
WHERE Q010 IN('A','B','C') AND NO_MUNICIPIO_ESC = 'Blumenau'

--11. Qual é a segunda cidade catarinense (considere a coluna NO_MUNICIPIO_ESC) em que estudaram mais alunos no ENEM 2021?

SELECT NO_MUNICIPIO_ESC AS 'NOME MUNICÍPIO', COUNT(NO_MUNICIPIO_ESC) AS 'NÚMERO DE ALUNOS' 
FROM MICRODADOS_ENEM_2021_SC
WHERE SG_UF_ESC = 'SC'
GROUP BY NO_MUNICIPIO_ESC
ORDER BY [NÚMERO DE ALUNOS] DESC


--12. Qual é a cidade catarinense (considere a coluna NO_MUNICIPIO_ESC) possui o menor número de alunos cuja mãe possui ensino superior completo?

SELECT NO_MUNICIPIO_ESC AS 'NOME MUNICÍPIO', COUNT(NO_MUNICIPIO_ESC) AS 'NÚMERO DE ALUNOS'
FROM MICRODADOS_ENEM_2021_SC
WHERE Q002 = 'F'
GROUP BY NO_MUNICIPIO_ESC
ORDER BY [NÚMERO DE ALUNOS]  ASC

--13. Qual é a segunda cidade catarinense (considere a coluna NO_MUNICIPIO_ESC) que possui o maior número de pessoas na faixa “entre 26 e 30 anos”?

SELECT NO_MUNICIPIO_ESC AS 'NOME MUNICÍPIO', COUNT(NO_MUNICIPIO_ESC) AS 'NÚMERO DE ALUNOS'
FROM MICRODADOS_ENEM_2021_SC
WHERE TP_FAIXA_ETARIA = 11
GROUP BY NO_MUNICIPIO_ESC
ORDER BY [NÚMERO DE ALUNOS] DESC

--14. Qual é a cidade catarinense (considere a coluna NO_MUNICIPIO_ESC) que possui o TERCEIRO maior número de alunos cuja residência possui PELO MENOS 2 banheiros?

SELECT NO_MUNICIPIO_ESC AS 'NOME MUNICÍPIO', COUNT(NO_MUNICIPIO_ESC) AS 'NÚMERO DE ALUNOS'
FROM MICRODADOS_ENEM_2021_SC
WHERE Q008 IN('C','D','E')
GROUP BY NO_MUNICIPIO_ESC
ORDER BY [NÚMERO DE ALUNOS] DESC