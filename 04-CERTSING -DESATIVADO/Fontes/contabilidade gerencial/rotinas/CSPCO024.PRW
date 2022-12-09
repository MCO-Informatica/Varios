#include 'protheus.ch'
#include 'parmtype.ch'
#include "rwmake.ch"
#include "topconn.ch"
#include "Ap5Mail.ch"
#Include 'rwmake.ch'
#include 'COLORS.CH'
#include 'tbiconn.ch'

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ CSPCO024 ³ Autor ³ Joao Goncalves de Oliveira ³ Data ³ 11/08/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Atualização da Data de Fechamento Orçado e Realizado 		   ³±±
±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ U_CSPCO024()                  				          		   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum 														   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±³ Retorno   ³ Nenhum												   		   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CSPCO024()

Local aParamBox := {}
Local bConfGrav := {|| .T.}
Local aButtPara := {}
Local lCentPara := .T.
Local cTituRoti := "Parâmetros de Fechamento - Orçado x Realizado"
Local nPosiHori
Local nPosiVert
Local cLoadPerg := "CSPCO024"
Local lSalvPara := .T.
Local lUserSave := .T.                 
Local cMV_PCOOI := "MV_PCO10OI"
Local cMV_PCOOF := "MV_PCO10OF"
Local cMV_PCORI := "MV_PCO10RI"

Static aPergReto := {}  

If ! GetMv( cMV_PCOOI, .T. )
	CriarSX6( cMV_PCOOI, 'C', 'Data de Início Orçamento no PCO da Certisign - Rotina CSPCO010.prw', '20160101' )
Endif
dInicOrca := STOD(GetMv(cMV_PCOOI))
                 
If ! GetMv( cMV_PCOOF, .T. )
	CriarSX6( cMV_PCOOF, 'C', 'Data Final Orçamento no PCO da Certisign - Rotina CSPCO010.prw', '20161231' )
Endif
dFinaOrca := STOD(GetMv(cMV_PCOOF))

If ! GetMv( cMV_PCORI, .T. )
	CriarSX6( cMV_PCORI, 'C', 'Data de Início Realizado no PCO da Certisign - Rotina CSPCO010.prw', '20160701' )
Endif
dInicReal := STOD(GetMv(cMV_PCORI))
                 

aAdd(aParamBox,{1,"Início Orçamento",dInicOrca,"","","","",50,.T.})  
aAdd(aParamBox,{1,"Final Orçamento",dFinaOrca,"","","","",50,.T.}) 
aAdd(aParamBox,{1,"Início Realizado",dInicReal,"","","","",50,.T.})

If ParamBox(aParamBox, cTituRoti, aPergReto, bConfGrav, aButtPara, lCentPara, nPosiHori,nPosiVert,, cLoadPerg, lSalvPara, lUserSave)
	For nContItem := 1 to Len(aParamBox)
		If aParamBox[nContItem,1] == 2 .And. ValType(&("mv_par"+StrZero(nContItem,2))) <> "N"
			&("mv_par"+StrZero(nContItem,2)) := aScan(aParamBox[nContItem,4],&("mv_par"+StrZero(nContItem,2)))
		EndIf
	Next                  
	PutMv(cMV_PCOOI,DTOS(mv_par01))
	PutMv(cMV_PCOOF,DTOS(mv_par02))
	PutMv(cMV_PCORI,DTOS(mv_par03))
	
EndIf	

Return