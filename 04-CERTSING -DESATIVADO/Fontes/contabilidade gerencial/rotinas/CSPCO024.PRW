#include 'protheus.ch'
#include 'parmtype.ch'
#include "rwmake.ch"
#include "topconn.ch"
#include "Ap5Mail.ch"
#Include 'rwmake.ch'
#include 'COLORS.CH'
#include 'tbiconn.ch'

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪目北
北矲uncao	 ? CSPCO024 ? Autor ? Joao Goncalves de Oliveira ? Data ? 11/08/14 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪拇北
北矰escri??o ? Atualiza玢o da Data de Fechamento Or鏰do e Realizado 		   潮?
泵哪哪哪哪哪拍哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe	 ? U_CSPCO024()                  				          		   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros? Nenhum 														   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
背 Retorno   ? Nenhum												   		   潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/

User Function CSPCO024()

Local aParamBox := {}
Local bConfGrav := {|| .T.}
Local aButtPara := {}
Local lCentPara := .T.
Local cTituRoti := "Par鈓etros de Fechamento - Or鏰do x Realizado"
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
	CriarSX6( cMV_PCOOI, 'C', 'Data de In韈io Or鏰mento no PCO da Certisign - Rotina CSPCO010.prw', '20160101' )
Endif
dInicOrca := STOD(GetMv(cMV_PCOOI))
                 
If ! GetMv( cMV_PCOOF, .T. )
	CriarSX6( cMV_PCOOF, 'C', 'Data Final Or鏰mento no PCO da Certisign - Rotina CSPCO010.prw', '20161231' )
Endif
dFinaOrca := STOD(GetMv(cMV_PCOOF))

If ! GetMv( cMV_PCORI, .T. )
	CriarSX6( cMV_PCORI, 'C', 'Data de In韈io Realizado no PCO da Certisign - Rotina CSPCO010.prw', '20160701' )
Endif
dInicReal := STOD(GetMv(cMV_PCORI))
                 

aAdd(aParamBox,{1,"In韈io Or鏰mento",dInicOrca,"","","","",50,.T.})  
aAdd(aParamBox,{1,"Final Or鏰mento",dFinaOrca,"","","","",50,.T.}) 
aAdd(aParamBox,{1,"In韈io Realizado",dInicReal,"","","","",50,.T.})

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