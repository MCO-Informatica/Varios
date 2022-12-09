#include 'protheus.ch'
#include 'parmtype.ch'
#include "rwmake.ch"
#include "topconn.ch"
#Include "Totvs.ch"
#include "Ap5Mail.ch"
#Include 'rwmake.ch'
#include 'COLORS.CH'
#include 'tbiconn.ch'

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ CSPCO013 ³ Autor ³ Joao Goncalves de Oliveira ³ Data ³ 11/08/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Exclui Dados do Relatório Razão Orçado x Realizado 			   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ U_CSPCO013()                  				          		   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum 														   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±³ Retorno   ³ Nenhum												   		   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CSPCO013()

Local aParamBox := {}
Local bConfGrav := {|| .T.}
Local aButtPara := {}
Local lCentPara := .T.
Local cTituRoti := "Exclusao de Dados - Orçado x Realizado"
Local nPosiHori
Local nPosiVert
Local cLoadPerg := "CSPCO013"
Local lSalvPara := .T.
Local lUserSave := .T.
Local cTipoMovi := ""
Local cTipoResu := ""
Local lExecManu := .T.
Local cTabeGrav := "CSPCO010"
Local cQuryUPda := ""        
Local lExecManu := .T.

Static aPergReto := {}

aAdd(aParamBox,{1,"Data Inicial",CTOD(Space(8)),"","","","",50,.F.}) // Tipo data
aAdd(aParamBox,{1,"Data Final " ,CTOD(Space(8)),"","","","",50,.F.}) // Tipo data
aAdd(aParamBox,{2,"Contas Resultado",1, {"Despesas","Receitas","Capex","Todas"} , 50, '.T.', .T.})
aAdd(aParamBox,{2,"Tipo Movimento",2, {"Orçado","Realizado","Ambos"}  , 50, '.T.', .T.})
aAdd(aParamBox,{1,"Tabela de Gravacao",Space(13),"","","","",50,.F.})


If ParamBox(aParamBox, cTituRoti, aPergReto, bConfGrav, aButtPara, lCentPara, nPosiHori,nPosiVert,, cLoadPerg, lSalvPara, lUserSave)
	For nContItem := 1 to Len(aParamBox)
		If aParamBox[nContItem,1] == 2 .And. ValType(&("mv_par"+StrZero(nContItem,2))) <> "N"
			&("mv_par"+StrZero(nContItem,2)) := aScan(aParamBox[nContItem,4],&("mv_par"+StrZero(nContItem,2)))
		EndIf
	Next
	                           
	cTabeGrav := AllTrim(mv_par05)         
	cTipoResu := IIf(mv_par03==1,"D",IIf(mv_par03==2,"R",IIf(mv_par03 == 3,"C","T")))
	cTipoMovi := IIf(mv_par04==2,"R",IIf(mv_par04==1,"O","A"))

	cQuryUpda := " DELETE FROM " + cTabeGrav 
	cQuryUpda += " WHERE DATALCT BETWEEN '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + "'"
	If cTipoMovi == "R"
		cQuryUpda += " AND CLAS = 'Realizado'"
	EndIf
	If cTipoMovi == "O"
		cQuryUpda += " AND CLAS = 'Orcado'"
	EndIf          
	If cTipoResu == "D"                     
		cQuryUpda += " AND MODELO = 'Despesas'" 
	EndIf	
	If cTipoResu == "R"                     
		cQuryUpda += " AND MODELO = 'Receitas'" 
	EndIf	
	If cTipoResu == "C"                     
		cQuryUpda += " AND MODELO = 'Capex'" 
	EndIf	
	
	
	If ! U_CSPCO10N(cQuryUpda,"na exclusao dos registros de planejamento",lExecManu)
		Return
	EndIf

EndIf                                                    
Return