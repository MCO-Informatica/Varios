#Include "Totvs.ch"

//Funcao para atualizar status(Z6_TIPO) dos pedidos de periodos anteriores.
User Function CSUPDDA1()

Local cUpdate1 := "" //Abate 10 porcento do preco de venda e grava renovacao
Local cUpdate2 := "" //Replica valor de venda para renovacao
Local cUpdate3 := "" //Produto que tem ASS, Replica os valores
Local cUpdate4 := "" //Produto que não tem ASS, Desconta 10%
Local cUpdate5 := "" //Tabela 11, produto especifico, copia valores
Local cUpdate6 := "" //Tabela 11, produto nao especifico, desconta 10%

RpcSetType(3)
RpcSetEnv("01","02")

CONOUT("=================================================")
CONOUT("=== CSUPDDA1 - GERACAO DO VALOR DE RENOVACAO ====")
CONOUT("=================================================")

CONOUT("=================================================")
CONOUT("=== UPDATE 1 - GERA RENOVACAO COM 10% DESCONTO ==")
CONOUT("=================================================")

//1.	Tabelas que sofrerão ajustes de valores na coluna de renovação
cUpdate1 := " UPDATE DA1010 "
cUpdate1 += " SET "
cUpdate1 += " DA1_XPRCRE = TRUNC(DA1_PRCVEN-(DA1_PRCVEN*0.10),0) "
cUpdate1 += " WHERE "
cUpdate1 += " DA1_FILIAL = ' ' AND "
cUpdate1 += " DA1_ATIVO = '1' AND "
cUpdate1 += " DA1_CODTAB IN ('016','017','045','085','097','100','105','113','136','153','158','159','160') AND "
cUpdate1 += " D_E_L_E_T_ = ' ' "

if (TCSqlExec(cUpdate1) < 0)
	conout("Erro na atualizacao 1: " + TCSQLError())
Else
	conout("Atualizacao 1 efetuada com sucesso!")
Endif

//2.	Tabelas de Renovação que terão seu valor “repetido” na coluna de valor renovação.
CONOUT("=================================================")
CONOUT("== UPDATE 2 - COPIA PRECO VENDA PARA RENOVACAO ==")
CONOUT("=================================================")

cUpdate2 := " UPDATE DA1010 "
cUpdate2 += " SET "
cUpdate2 += " DA1_XPRCRE = DA1_PRCVEN "
cUpdate2 += " WHERE "
cUpdate2 += " DA1_FILIAL = ' ' AND "
cUpdate2 += " DA1_ATIVO = '1' AND "
cUpdate2 += " DA1_CODTAB IN ('001','002','012','013','014','015','018','019','020','021','022','025','026','027','028','029','030','031','032','033','034', "
cUpdate2 += " 				 '035','036','037','038','041','043','044','046','047','049','050','051','052','053','054','055','056','057','058','059','061', "
cUpdate2 += " 				 '062','063','064','065','066','067','068','069','070','071','072','073','074','075','076','077','078','079','080','081','082', "
cUpdate2 += " 				 '083','084','087','088','090','091','092','093','094','095','096','098','099','101','102','103','104','106','107','108','109', "
cUpdate2 += " 				 '110','111','112','114','115','116','117','118','119','120','121','122','123','124','125','126','127','128','129','130','131', "
cUpdate2 += " 				 '132','133','134','135','137','138','139','140','141','142','143','144','145','146','147','148','149','150','151','152','154', "
cUpdate2 += " 				 '155','156','157','161','162','163','164','166','167','168','169','170','171','172','173','174','175','176','178','179','180', "
cUpdate2 += " 				 '181','182','183','184','185','186','187','188','190','193') AND "
cUpdate2 += " D_E_L_E_T_ = ' ' "

if (TCSqlExec(cUpdate2) < 0)
	conout("Erro na atualizacao 2: " + TCSQLError())
Else
	conout("Atualizacao 2 efetuada com sucesso!")
Endif

//3.	Aplicar condição diferenciada: Repetir valor de venda para produtos cujo código GAR contém "ASS" e cadastrar 10% desconto na renovação para os demais produtos
CONOUT("=================================================")
CONOUT("===== UPDATE 3 - Produto ASS, copia valores =====")
CONOUT("=================================================")
cUpdate3 := " UPDATE DA1010 "
cUpdate3 += " SET "
cUpdate3 += " DA1_XPRCRE = DA1_PRCVEN "
cUpdate3 += " WHERE "
cUpdate3 += " DA1_FILIAL = ' ' AND " 
cUpdate3 += " DA1_ATIVO = '1' AND "
cUpdate3 += " DA1_CODTAB IN ('010','177','195','196','197','198','199','200','201','202') AND " 
cUpdate3 += " DA1_CODGAR LIKE '%ASS%' AND "
cUpdate3 += " D_E_L_E_T_ = ' ' " 

if (TCSqlExec(cUpdate3) < 0)
	conout("Erro na atualizacao 3: " + TCSQLError())
Else
	conout("Atualizacao 3 efetuada com sucesso!")
Endif

CONOUT("=================================================")
CONOUT("==== UPDATE 4 - Produto Sem ASS, desconta 10% ===")
CONOUT("=================================================")
cUpdate4 := " UPDATE DA1010 "
cUpdate4 += " SET "
cUpdate4 += " DA1_XPRCRE = TRUNC(DA1_PRCVEN-(DA1_PRCVEN*0.10),0) "
cUpdate4 += " WHERE "
cUpdate4 += " DA1_FILIAL = ' ' AND " 
cUpdate4 += " DA1_ATIVO = '1' AND "
cUpdate4 += " DA1_CODTAB IN ('010','177','195','196','197','198','199','200','201','202') AND " 
cUpdate4 += " DA1_CODGAR NOT LIKE '%ASS%' AND "
cUpdate4 += " D_E_L_E_T_ = ' ' " 

if (TCSqlExec(cUpdate4) < 0)
	conout("Erro na atualizacao 4: " + TCSQLError())
Else
	conout("Atualizacao 4 efetuada com sucesso!")
Endif

// Tabela 11
//4. Repetir valor de venda na coluna renovação para produtos cujo código GAR contém "ASS", "PRH", "5P", "10P", "15P", "18P", "DESC", "ACJ", "PMH", "ITAU", "UNI", "WL", "OZ", "INF".
//4.1 Os produtos que não estiverem dentro dos critérios acima, pode calcular 10% de desconto sobre o preço de renovação.

CONOUT("=================================================")
CONOUT("== UPDATE 5 - Tabela 11, copia preco de venda  ==")
CONOUT("=================================================")

cUpdate5 := " UPDATE DA1010 "
cUpdate5 += " SET "
cUpdate5 += " DA1_XPRCRE = DA1_PRCVEN "
cUpdate5 += " WHERE "
cUpdate5 += " DA1_FILIAL = ' ' AND "
cUpdate5 += " DA1_ATIVO = '1' AND "
cUpdate5 += " DA1_CODTAB = '011' AND "
cUpdate5 += " (DA1_CODGAR LIKE '%ASS%' OR DA1_CODGAR LIKE '%PRH%' OR DA1_CODGAR LIKE '%5P%'  OR DA1_CODGAR LIKE '%10P%' OR "
cUpdate5 += " DA1_CODGAR LIKE '%15P%' OR DA1_CODGAR LIKE '%18P%' OR DA1_CODGAR LIKE '%DESC%' OR DA1_CODGAR LIKE '%ACJ%' OR "
cUpdate5 += " DA1_CODGAR LIKE '%PMH%' OR DA1_CODGAR LIKE '%ITAU%' OR DA1_CODGAR LIKE '%UNI%' OR DA1_CODGAR LIKE '%WL%'  OR "
cUpdate5 += " DA1_CODGAR LIKE '%OZ%'  OR DA1_CODGAR LIKE '%INF%') AND "
cUpdate5 += " D_E_L_E_T_ = ' ' " 

if (TCSqlExec(cUpdate5) < 0)
	conout("Erro na atualizacao 5: " + TCSQLError())
Else
	conout("Atualizacao 5 efetuada com sucesso!")
Endif

CONOUT("=================================================")
CONOUT("= UPDATE6 - Tabela 11, desconta 10% preco Venda =")
CONOUT("=================================================")

cUpdate6 := " UPDATE DA1010 "
cUpdate6 += " SET "
cUpdate6 += " DA1_XPRCRE = TRUNC(DA1_PRCVEN-(DA1_PRCVEN*0.10),0) "
cUpdate6 += " WHERE "
cUpdate6 += " DA1_FILIAL = ' ' AND "
cUpdate6 += " DA1_ATIVO = '1' AND "
cUpdate6 += " DA1_CODTAB = '011' AND "
cUpdate6 += " (DA1_CODGAR NOT LIKE '%ASS%' AND DA1_CODGAR NOT LIKE '%PRH%' AND DA1_CODGAR NOT LIKE '%5P%'  AND DA1_CODGAR NOT LIKE '%10P%' AND "
cUpdate6 += " DA1_CODGAR NOT LIKE '%15P%' AND DA1_CODGAR NOT LIKE '%18P%' AND DA1_CODGAR NOT LIKE '%DESC%' AND DA1_CODGAR NOT LIKE '%ACJ%' AND "
cUpdate6 += " DA1_CODGAR NOT LIKE '%PMH%' AND DA1_CODGAR NOT LIKE '%ITAU%' AND DA1_CODGAR NOT LIKE '%UNI%' AND DA1_CODGAR NOT LIKE '%WL%'  AND "
cUpdate6 += " DA1_CODGAR NOT LIKE '%OZ%'  AND DA1_CODGAR NOT LIKE '%INF%') AND "
cUpdate6 += " D_E_L_E_T_ = ' ' " 

if (TCSqlExec(cUpdate6) < 0)
	conout("Erro na atualizacao 6: " + TCSQLError())
Else
	conout("Atualizacao 6 efetuada com sucesso!")
Endif

CONOUT("======================================")
CONOUT("=== FINALIZA PROCESSO DE RENOVACAO ===")
CONOUT("======================================")

return