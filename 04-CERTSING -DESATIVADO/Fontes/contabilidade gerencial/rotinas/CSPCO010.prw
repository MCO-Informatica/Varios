#include "rwmake.ch"
#include "topconn.ch"
#Include "Totvs.ch"
#include "Ap5Mail.ch"
#Include 'Protheus.ch'
#Include 'rwmake.ch'
#include 'COLORS.CH'
#include 'tbiconn.ch'

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪目北
北矲uncao	 ?CSPCO010 ?Autor Joao Goncalves de Oliveira ?Data ?10/07/15 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪拇北
北矰escri??o ?Gerador de Dados Planilha Or鏰mento x Realizado				   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砈intaxe	 ?U_CSPCO010()                  				          		   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros?ExpA1 := {Empresa,Filial}                                       潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
背 Retorno   ?Nenhum												   		   潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
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
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪目北
北矲uncao	 ?CSPCO10A ?Autor ?Joao Goncalves de Oliveira ?Data ?10/07/15 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪拇北
北矰escri??o ?Inicia Job Gerador de Dados Planilha Or鏰mento x Realizado      潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砈intaxe	 ?CSPCO10A(ExpA1)            				          		       潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros?ExpA1 := {Empresa,Filial,Data_Inicial,Data_Final,               潮?
北?         ?  Tipo_Conta_Resultado,Tipo_Movimento,Conta_Inicial,Conta_Final}潮?
北?         ?ExpL2 := Define se a execu玢o ?manual 						   潮?
北?         ?ExpC3 := Tabela de Grava玢o 									   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
背 Retorno   ?Nenhum												   		   潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
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
	
	Processa({|| U_CSPCO02A(.T.,cTabeOrca)},"Criando Estrutura da Tabela de Grava玢o...")
	Processa({|| U_CSPCO02L(.T.,cRefeInic)},"Apagando Tabelas Anteriormente Geradas ...")
	Processa({|| U_CSPCO02D(cEmpAnt,cFilAnt,DTOS(dDataInic),DTOS(dDataFina),.T.,cTabeGrav)},"Orcado x Real - Excluindo lan鏰mentos alterados ap髎 o processamento anterior... - De: " + DTOC(STOD(aListPara[nContItem,1])) + " a " + DTOC(STOD(aListPara[nContItem,2])))
	Processa({|| U_CSPCO02B(cTipoResu,DTOS(dDataInic),DTOS(dDataFina),cTipoMovi,cTabeOrca,.T.,cContInic,cContFina,@cQuryRela)},,"Selecionando Dados do Sistema ...")
	Processa({|| U_CSPCO02C(cEmpAnt,cFilAnt,DTOS(dDataInic),DTOS(dDataFina),.T.,cTabeOrca,cQuryRela,cTipoResu,cTipoMovi)},"Orcado x Real - Gerando Dados no Arquivo Tempor醨io ...")
	Processa({|| U_CSPCO02W(lExecManu,cTabeOrca,DTOS(dDataInic),DTOS(dDataFina))},"Orcado x Real - Atualizando Excecoes nas Entidades...")
	Processa({|| U_CSPCO02L(.T.,cRefeInic)},"Apagando Tabelas Tempor醨ias Geradas ...")
	
Else
	
	Conout('CSPCO10B - Orcado x Real - Criando Estrutura da Tabela de Log... ' + cDataInic + " / " + cDataFina + " " + Time())
	U_CSPCO10B(.F.,cTabeOrca)
	
	Conout('CSPCO02A - Orcado x Real - Criando Estrutura da Tabela de Grava玢o... ' + cDataInic + " / " + cDataFina + " " + Time())
	U_CSPCO02A(.F.,cTabeOrca)
	
	Conout('CSPCO02L - Orcado x Real - Apagando Tabelas Anteriormente Geradas... ' + cDataInic + " / " + cDataFina + " " + Time())
	U_CSPCO02L(.F.,cRefeIni)
	
	Conout('CSPCO02D - Orcado x Real - Excluindo lan鏰mentos alterados p髎 processamento anterior ... ' + cDataInic + " / " + cDataFina + " " + Time())  
	U_CSPCO02D(cEmpAnt,cFilAnt,DTOS(dDataInic),DTOS(dDataFina),.T.,cTabeGrav)

	Conout('CSPCO02B - Orcado x Real - Selecionados Dados do Sistema ... ' + cDataInic + " / " + cDataFina + " " + Time())
	U_CSPCO02B(cTipoResu,DTOS(dDataInic),DTOS(dDataFina),cTipoMovi,cTabeOrca,.F.,cContInic,cContFina,@cQuryRela)
	
	Conout('CSPCO02C - Orcado x Real - Gravando Dados na Tabelas de Or鏰do x Realizado ... ' + cDataInic + " / " + cDataFina + " " + Time())
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
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪目北
北矲uncao	 ?CSPCO10B ?Autor ?Joao Goncalves de Oliveira ?Data ?10/07/15 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪拇北
北矰escri??o ?Gera Estrutura da Tabela de Log de Gravacao dos Dados caso ainda潮?
北?         ?nao exista 													   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砈intaxe	 ?U_CSPCO10B(ExpL1,ExpC2)									       潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros?ExpL2 - Verifica se a execu玢o ?manual ou atrav閟 de Job 	   潮?
北?         ?ExpC2 - Tabela de Gravacao dos Dados 						   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
背 Retorno   ?Nenhum												   		   潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
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
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪目北
北矲uncao	 ?CSPCO10C ?Autor ?Joao Goncalves de Oliveira ?Data ?10/12/15 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪拇北
北矰escri??o ?Atualiza Log com Ultima Rotina Processada                       潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砈intaxe	 ?U_CSPCO10C(ExpC1,ExpC2,ExpC3,ExpC4,ExpC5,ExpC6,ExpC7,ExpC8	   幢?
北? 		 ?           ExpC9)											   幢?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros?ExpC1 - Data Inicio Processamento    	  					   潮?
北?		 ?ExpC1 - Data Final Processamento     	  					   潮?
北?		 ?ExpC3 - Tipo de Conta Resuldo  				                   潮?
北?		 ?ExpC4 - Tipo de Movimento  						   			   潮?
北?		 ?ExpC5 - Verifica se a execu玢o ?manual 			   			   潮?
北?		 ?ExpC6 - Hora de Inicio de Execu玢o 				   			   潮?
北?		 ?ExpC7 - Hora de Fim da Execu玢o					   			   潮?
北?		 ?ExpC8 - Data de Inicio de Execu玢o 				   			   潮?
北?		 ?ExpC9 - Data de Fim da Execu玢o					   			   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
背 Retorno   ?Nenhum 														   潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
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
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪目北
北矲uncao	 ?CSPCO10M ?Autor ?Joao Goncalves de Oliveira ?Data ?17/07/15 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪拇北
北矰escri??o ?Substitui ' ou , de string para grava玢o via SQL				   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砈intaxe	 ?U_CSPCO10M(Exp1)          				          		   	   	   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros?ExpC1 - Texto a ser substituido 								   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
背 Retorno   ?ExpC1 - Texto substituido 									   潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/

User Function CSPCO10M(cTextGrav)

cTextGrav := StrTran(cTextGrav,"'"," ")
cTextGrav := StrTran(cTextGrav,","," ")
cTextGrav := StrTran(cTextGrav,"&","E")


Return(cTextGrav)

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪目北
北矲uncao	 ?CSPCO10N ?Autor ?Joao Goncalves de Oliveira ?Data ?17/07/15 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪拇北
北矰escri??o ?Executa Update na Tabela de Referencia 						   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砈intaxe	 ?U_CSPCO10N(ExpC1,ExpC2) 				          		   	   	   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros?ExpC1 - Expressao para Atualizacao 							   潮?
北?         ?ExpC2 - Mensagem em Caso de Erro 							   潮?
北?	     ?ExpL3 - Define se a execu玢o ?manual 						   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
背 Retorno   ?ExpL1 - Variavel L骻ica que define se houve sucesso 				北
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
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
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪哪履哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪北
北砅rograma  ?CSPCO10P   矨utor ?Jo鉶 Gon鏰lves de Oliveira?Data ?8/10/2015  潮?
北媚哪哪哪哪哪拍哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪北
北矰escricao ?Apaga Registros Referentes ao Mes do Processamento 				  北
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪北
北砈intaxe	 ?U_CSPCO10P(ExpC1,ExpC2)						 		 			 潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪北
北砅arametros?ExpC1 - Data Inicial de Processamento 							 潮?
北?         ?ExpC2 - Data Final de Processamento 							 	 潮?
北?         ?ExpC3 - Define se a execu玢o ?manual 							 潮?
北?         ?ExpC4 - Tipo de Conta Resultado									 潮?
北?         ?ExpC5 - Tipo de Movimento 									     潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪北
北砇etorno   ?Nenhum															 潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
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