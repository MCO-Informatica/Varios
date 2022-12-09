#include "rwmake.ch"
#include "topconn.ch"
#Include "Totvs.ch"
#include "Ap5Mail.ch"
#Include 'Protheus.ch'
#Include 'rwmake.ch'
#include 'COLORS.CH'
#include 'tbiconn.ch'

/*/
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Funcao	 ?CSPCO010 ?Autor Joao Goncalves de Oliveira ?Data ?10/07/15 ��?
������������������������������������������������������������������������������Ĵ��
���Descri??o ?Gerador de Dados Planilha Or�amento x Realizado				   ��?
������������������������������������������������������������������������������Ĵ��
���Sintaxe	 ?U_CSPCO010()                  				          		   ��?
������������������������������������������������������������������������������Ĵ��
���Parametros?ExpA1 := {Empresa,Filial}                                       ��?
������������������������������������������������������������������������������Ĵ��
�� Retorno   ?Nenhum												   		   ��?
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/


User Function CSPCO010(aParams)

Local lExecManu := .F.
Local cTabeLogG := "CSPCO010_LOG"
Local aListPara := {}
Local cQuryRela := ""               
Local cTabeOrca := "CSPCO010"

If aParams == NIL
	aParams := {cEmpAnt,cFilAnt}
	lExecManu := .T.
EndIf

//  aParams := {Empresa,Filial,Data_Inicial,Data_Final,Tipo_Conta_Resultado,Tipo_Movimento,Conta_Inicial,Conta_Final}
// nome da view do bi: mvw_orcado_realizado
               
If lExecManu 
	Processa({|| U_CSPCO10B(.T.,cTabeLogG)},"Criando Estrutura da Tabela de Log...")
Else
	Conout('CSPCO10B - Orcado x Real - Criando Estrutura da Tabela de Log...  ' + Time())
	U_CSPCO10B(.F.,cTabeLogG)
EndIf

aListPara := {} 
 
dDataInic := GetMv("MV_PCO10RI")                  
dDataFina := DTOS(dDataBase)                                                                                              

For nContItem := dDataInic to dDataFina 
	aAdd(aListPara,{aParams[1],aParams[2],dDataInic,dDataInic,"T","R","120601001        ","130455002           "})
	dDataInic ++ 
Next	

dDataInic := GetMv("MV_PCO10OI")                  
dDataFina := GetMv("MV_PCO10OF")                                                                                          

aAdd(aListPara,{aParams[1],aParams[2],dDataInic,dDataFina,"T","O","120601001        ","130455002           "})

For nContList := 1 to Len(aListPara)
	aParams := aListPara[nContList]

	cQuryRela := "SELECT * FROM " + cTabeLogG
	cQuryRela += " WHERE DATAINI >= '" + aParams[3] + "'"
	cQuryRela += " AND DATAFIM <= '" + aParams[4] + "'"
	cQuryRela += " AND HORAFIM <> '" + Space(Len(Time())) + "'"
	TcQuery cQuryRela NEW ALIAS "TRB_010"
	
	TRB_010->(dbGoTop())
	If TRB_010->(Eof())
		cTabeOrca := "CSPCO010_" + StrZero(Year(STOD(aParams[3])),4)
		U_CSPCO10C(aParams[3],aParams[4],aParams[5],aParams[6],lExecManu,Time(),Space(Len(Time())),cTabeLogG,DTOS(Date()),Space(8))
		If lExecManu
			Processa({|| CSPCO10A(aParams,lExecManu,cTabeOrca)},"Iniciando Job CSPCO10A...")
		Else
			CSPCO10A(aParams,lExecManu,cTabeOrca)
		EndIf	    
		                 
		U_CSPCO10C(aParams[3],aParams[4],aParams[5],aParams[6],lExecManu,Space(Len(Time())),Time(),cTabeLogG,Space(8),DTOS(Date()))
	EndIf	          
	TRB_010->(dbCloseArea())
Next                                 
Return

/*/
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Funcao	 ?CSPCO10A ?Autor ?Joao Goncalves de Oliveira ?Data ?10/07/15 ��?
������������������������������������������������������������������������������Ĵ��
���Descri??o ?Inicia Job Gerador de Dados Planilha Or�amento x Realizado      ��?
������������������������������������������������������������������������������Ĵ��
���Sintaxe	 ?CSPCO10A(ExpA1)            				          		       ��?
������������������������������������������������������������������������������Ĵ��
���Parametros?ExpA1 := {Empresa,Filial,Data_Inicial,Data_Final,               ��?
��?         ?  Tipo_Conta_Resultado,Tipo_Movimento,Conta_Inicial,Conta_Final}��?
��?         ?ExpL2 := Define se a execu��o ?manual 						   ��?
��?         ?ExpC3 := Tabela de Grava��o 									   ��?
������������������������������������������������������������������������������Ĵ��
�� Retorno   ?Nenhum												   		   ��?
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/


Static Function CSPCO10A(aParams,lExecManu,cTabeOrca)

// aParams := {Empresa,Filial,Data_Inicial,Data_Final,Tipo_Conta_Resultado,Tipo_Movimento,Conta_Inicial,Conta_Final}

Local cEmprRoti := aParams[1]
Local cFiliRoti := aParams[2]
Local dDataInic := STOD(aParams[3])           
Local dDataFina := STOD(aParams[4])
Local cTipoResu := aParams[5]
Local cTipoMovi := aParams[6]
Local cContInic := aParams[7]
Local cContFina := aParams[8]
Local cArquDado, cQuryCons := ""
Local cTabeLogG := "CSPCO010_LOG"
Local cQuryRela := ""       
Local cRefeInic := "CSPCO10"

If ! lExecManu
	Conout('Iniciando Job CSPCO10A' + Time())
	RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA cEmprRoti FILIAL cFiliRoti MODULO "CTB"
EndIf

If lExecManu
	
	Processa({|| U_CSPCO02A(.T.,cTabeOrca)},"Criando Estrutura da Tabela de Grava��o...")
	Processa({|| U_CSPCO02L(.T.,cRefeInic)},"Apagando Tabelas Anteriormente Geradas ...")
	Processa({|| U_CSPCO02D(cEmpAnt,cFilAnt,DTOS(dDataInic),DTOS(dDataFina),.T.,cTabeGrav)},"Orcado x Real - Excluindo lan�amentos alterados ap�s o processamento anterior... - De: " + DTOC(STOD(aListPara[nContItem,1])) + " a " + DTOC(STOD(aListPara[nContItem,2])))
	Processa({|| U_CSPCO02B(cTipoResu,DTOS(dDataInic),DTOS(dDataFina),cTipoMovi,cTabeOrca,.T.,cContInic,cContFina,@cQuryRela)},,"Selecionando Dados do Sistema ...")
	Processa({|| U_CSPCO02C(cEmpAnt,cFilAnt,DTOS(dDataInic),DTOS(dDataFina),.T.,cTabeOrca,cQuryRela,cTipoResu,cTipoMovi)},"Orcado x Real - Gerando Dados no Arquivo Tempor�rio ...")
	Processa({|| U_CSPCO02W(lExecManu,cTabeOrca,DTOS(dDataInic),DTOS(dDataFina))},"Orcado x Real - Atualizando Excecoes nas Entidades...")
	Processa({|| U_CSPCO02L(.T.,cRefeInic)},"Apagando Tabelas Tempor�rias Geradas ...")
	
Else
	
	Conout('CSPCO10B - Orcado x Real - Criando Estrutura da Tabela de Log... ' + cDataInic + " / " + cDataFina + " " + Time())
	U_CSPCO10B(.F.,cTabeOrca)
	
	Conout('CSPCO02A - Orcado x Real - Criando Estrutura da Tabela de Grava��o... ' + cDataInic + " / " + cDataFina + " " + Time())
	U_CSPCO02A(.F.,cTabeOrca)
	
	Conout('CSPCO02L - Orcado x Real - Apagando Tabelas Anteriormente Geradas... ' + cDataInic + " / " + cDataFina + " " + Time())
	U_CSPCO02L(.F.,cRefeIni)
	
	Conout('CSPCO02D - Orcado x Real - Excluindo lan�amentos alterados p�s processamento anterior ... ' + cDataInic + " / " + cDataFina + " " + Time())  
	U_CSPCO02D(cEmpAnt,cFilAnt,DTOS(dDataInic),DTOS(dDataFina),.T.,cTabeGrav)

	Conout('CSPCO02B - Orcado x Real - Selecionados Dados do Sistema ... ' + cDataInic + " / " + cDataFina + " " + Time())
	U_CSPCO02B(cTipoResu,DTOS(dDataInic),DTOS(dDataFina),cTipoMovi,cTabeOrca,.F.,cContInic,cContFina,@cQuryRela)
	
	Conout('CSPCO02C - Orcado x Real - Gravando Dados na Tabelas de Or�ado x Realizado ... ' + cDataInic + " / " + cDataFina + " " + Time())
	U_CSPCO02C(cEmpAnt,cFilAnt,DTOS(dDAtaInic),DTOS(dDataFina),.F.,cTabeOrca,cQuryRela,cTipoResu,cTipoMovi)
	
	Conout('CSPCO02W - Orcado x Real - Atualizando Excecoes nas Entidades... ' + cDataInic + " / " + cDataFina + " " + Time()) 
	U_CSPCO02W(.F.,cTabeOrca,DTOS(dDataInic),DTOS(dDataFina))
	
	Conout('CSPCO10L - Orcado x Real - Apagando Tabelas Anteriormente Geradas... ' + cDataInic + " / " + cDataFina + " " + Time())
	U_CSPCO02L(.F.,cRefeInic)
	
EndIf

If ! lExecManu
	Conout('CSPCO010 - FIM - Processamento Executado com Sucesso ! ' + Time())
EndIf


Return

/*/
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Funcao	 ?CSPCO10B ?Autor ?Joao Goncalves de Oliveira ?Data ?10/07/15 ��?
������������������������������������������������������������������������������Ĵ��
���Descri??o ?Gera Estrutura da Tabela de Log de Gravacao dos Dados caso ainda��?
��?         ?nao exista 													   ��?
������������������������������������������������������������������������������Ĵ��
���Sintaxe	 ?U_CSPCO10B(ExpL1,ExpC2)									       ��?
������������������������������������������������������������������������������Ĵ��
���Parametros?ExpL2 - Verifica se a execu��o ?manual ou atrav�s de Job 	   ��?
��?         ?ExpC2 - Tabela de Gravacao dos Dados 						   ��?
������������������������������������������������������������������������������Ĵ��
�� Retorno   ?Nenhum												   		   ��?
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/

User Function CSPCO10B(lExecManu,cTabeGrav)

Local aCampos := {}

If ! TcCanOpen(cTabeGrav)
	
	aAdd( aCampos,{'DATAINI'   ,'D',TamSX3('CV1_DTFIM') [1],0}) //8
	aAdd( aCampos,{'DATAFIM'   ,'D',TamSX3('CV1_DTFIM') [1],0}) //8
	aAdd( aCampos,{'TIPORESU'  ,'C',1,0})
	aAdd( aCampos,{'TIPOMOVI'  ,'C',1,0})
	aAdd( aCampos,{'HORAINI'   ,'C',Len(Time()),0})
	aAdd( aCampos,{'HORAFIM'   ,'C',Len(Time()),0})
	aAdd( aCampos,{'DTLOGINI'  ,'D',TamSX3('CV1_DTFIM') [1],0})
	aAdd( aCampos,{'DTLOGFIM'  ,'D',TamSX3('CV1_DTFIM') [1],0})
	
	MsCreate( cTabeGrav, aCampos)
	Sleep(1000)
	
EndIf
Return

/*/
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Funcao	 ?CSPCO10C ?Autor ?Joao Goncalves de Oliveira ?Data ?10/12/15 ��?
������������������������������������������������������������������������������Ĵ��
���Descri??o ?Atualiza Log com Ultima Rotina Processada                       ��?
������������������������������������������������������������������������������Ĵ��
���Sintaxe	 ?U_CSPCO10C(ExpC1,ExpC2,ExpC3,ExpC4,ExpC5,ExpC6,ExpC7,ExpC8	   ��?
��? 		 ?           ExpC9)											   ��?
������������������������������������������������������������������������������Ĵ��
���Parametros?ExpC1 - Data Inicio Processamento    	  					   ��?
��?		 ?ExpC1 - Data Final Processamento     	  					   ��?
��?		 ?ExpC3 - Tipo de Conta Resuldo  				                   ��?
��?		 ?ExpC4 - Tipo de Movimento  						   			   ��?
��?		 ?ExpC5 - Verifica se a execu��o ?manual 			   			   ��?
��?		 ?ExpC6 - Hora de Inicio de Execu��o 				   			   ��?
��?		 ?ExpC7 - Hora de Fim da Execu��o					   			   ��?
��?		 ?ExpC8 - Data de Inicio de Execu��o 				   			   ��?
��?		 ?ExpC9 - Data de Fim da Execu��o					   			   ��?
������������������������������������������������������������������������������Ĵ��
�� Retorno   ?Nenhum 														   ��?
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/

User Function CSPCO10C(cDataInic,cDataFina,cTipoCont,cTipoMovi,lExecManu,cHoraInic,cHoraFina,cTabeLogG,cDataLogI,cDataLogF)

Local cUpdaGera := ""
Local cQuryRegi := ""
Local nContRegi := 0

cQuryRegi := " SELECT MAX(R_E_C_N_O_) REGISTRO FROM " + cTabeLogG
TcQuery cQuryRegi NEW ALIAS "TRB_002"
TRB_002->(dbGoTop())
If ! TRB_002->(Eof())
	nContRegi := TRB_002->REGISTRO
EndIf
TRB_002->(dbCloseARea())
nContRegi ++

cUpdaGera := " INSERT INTO " + cTabeLogG
cUpdaGera += " (DATAINI, DATAFIM, TIPORESU, TIPOMOVI,HORAINI,HORAFIM,DTLOGINI,DTLOGFIM"
cUpdaGera += " , D_E_L_E_T_, R_E_C_N_O_)"
cUpdaGera += " VALUES ('" + cDataInic + "','" + cDataFina + "','" + cTipoCont + "'"
cUpdaGera += " ,'" + cTipoMovi  + "','" + cHoraInic  + "','" + cHoraFina + "','" + cDataLogI + "','" + cDataLogF + "'" 
cUpdaGera += " ,'" + Space(1) + "','" + AllTrim(Str(nContRegi)) + "')"

If ! U_CSPCO10N(cUpdaGera,"da inclusao dos registros na tabela de log",lExecManu)
	TRB->(dbCloseARea())
	Return
EndIf
Return

/*/
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Funcao	 ?CSPCO10M ?Autor ?Joao Goncalves de Oliveira ?Data ?17/07/15 ��?
������������������������������������������������������������������������������Ĵ��
���Descri??o ?Substitui ' ou , de string para grava��o via SQL				   ��?
������������������������������������������������������������������������������Ĵ��
���Sintaxe	 ?U_CSPCO10M(Exp1)          				          		   	   	   ��?
������������������������������������������������������������������������������Ĵ��
���Parametros?ExpC1 - Texto a ser substituido 								   ��?
������������������������������������������������������������������������������Ĵ��
�� Retorno   ?ExpC1 - Texto substituido 									   ��?
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/

User Function CSPCO10M(cTextGrav)

cTextGrav := StrTran(cTextGrav,"'"," ")
cTextGrav := StrTran(cTextGrav,","," ")
cTextGrav := StrTran(cTextGrav,"&","E")


Return(cTextGrav)

/*/
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Funcao	 ?CSPCO10N ?Autor ?Joao Goncalves de Oliveira ?Data ?17/07/15 ��?
������������������������������������������������������������������������������Ĵ��
���Descri??o ?Executa Update na Tabela de Referencia 						   ��?
������������������������������������������������������������������������������Ĵ��
���Sintaxe	 ?U_CSPCO10N(ExpC1,ExpC2) 				          		   	   	   ��?
������������������������������������������������������������������������������Ĵ��
���Parametros?ExpC1 - Expressao para Atualizacao 							   ��?
��?         ?ExpC2 - Mensagem em Caso de Erro 							   ��?
��?	     ?ExpL3 - Define se a execu��o ?manual 						   ��?
������������������������������������������������������������������������������Ĵ��
�� Retorno   ?ExpL1 - Variavel L�gica que define se houve sucesso 				��
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/

User Function CSPCO10N(cQuryUpda,cTextMens,lExecManu)

MemoWrite("cQuryUpda.SQL",cQuryUpda)
lErroGrav := TcSqlExec(cQuryUpda) <> 0
If lErroGrav
	If lExecManu
		cTextMens := TCSQLError()
		Aviso("Atencao","Ocorreu um erro na atualizacao " + cTextMens + " - " + TcSqlError(),{"Ok"})
	Else
		ConOut("CSPCO10ERRO - Ocorreu um erro na atualizacao " + cTextMens + " - " + TcSqlError())
	EndIf
EndIf

Return(! lErroGrav)

/*/
������������������������������������������������������������������������������������
������������������������������������������������������������������������������������
���������������������������������������������������������������������������������ı�
���Programa  ?CSPCO10P   �Autor ?Jo�o Gon�alves de Oliveira?Data ?8/10/2015  ��?
���������������������������������������������������������������������������������ı�
���Descricao ?Apaga Registros Referentes ao Mes do Processamento 				  ��
���������������������������������������������������������������������������������ı�
���Sintaxe	 ?U_CSPCO10P(ExpC1,ExpC2)						 		 			 ��?
���������������������������������������������������������������������������������ı�
���Parametros?ExpC1 - Data Inicial de Processamento 							 ��?
��?         ?ExpC2 - Data Final de Processamento 							 	 ��?
��?         ?ExpC3 - Define se a execu��o ?manual 							 ��?
��?         ?ExpC4 - Tipo de Conta Resultado									 ��?
��?         ?ExpC5 - Tipo de Movimento 									     ��?
���������������������������������������������������������������������������������ı�
���Retorno   ?Nenhum															 ��?
���������������������������������������������������������������������������������ı�
������������������������������������������������������������������������������������
������������������������������������������������������������������������������������
/*/

User Function CSPCO10P(cDataInic,cDataFina,lExecManu,cTipoResu,cTipoMovi)

cQuryUpda := " DELETE CSPCO010 WHERE DATALCT >= '" + cDataInic + "'"
cQuryUpda += " AND DATALCT <= '" + cDataFina + "'"
If cTipoMovi == "O"
	cQuryUpda += " AND CLAS = 'Orcado'"
EndIf
If cTipoMovi == "R"
	cQuryUpda += " AND CLAS = 'Realizado'"
EndIf
If cTipoResu == "D"
	cQuryUpda += " AND MODELO = 'Despesas'"
EndIf
If cTipoResu == "R"
	cQuryUpda += " AND MODELO = 'Receitas'"
EndIf
cQuryUpda += " AND D_E_L_E_T_ = ' '"

If ! U_CSPCO10N(cQuryUpda," dos registros a serem excluidos no periodo ",lExecManu)
	Return
EndIf

Return