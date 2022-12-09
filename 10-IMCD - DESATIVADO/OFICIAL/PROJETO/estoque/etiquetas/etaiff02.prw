#INCLUDE "topconn.ch"
#INCLUDE "SHELL.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณETAIFF01  บAutor  Luiz Oliveira        บ Data ณ  10/08/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressao etiqueta de endere็amento TAIFF                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function ETAIFF02()

Local lContinua := .T.
vSetImp := {}
vSetImp := ExParam()

If Empty(vSetImp[1,1])
	MsgAlert("Informe um texto para impressใo.")
	lContinua := .F.
EndIf

If !CB5SetImp(vSetImp[1,2])  
	MsgAlert("Local de Impressใo "+vSetImp[1,2]+" nao Encontrado!") 
	lContinua := .F.
	Return
Endif	

If lContinua
	ImpEti07(vSetImp[1,1])
	MSCBCLOSEPRINTER()             
EndIf

Return
//////////////////////////////////////////
//Rotina de impressao de etiqueta      //
/////////////////////////////////////////
Static Function ImpEti07(vTexto)

Local cAliasNew	:= GetNextAlias()
Local cTipoBar	:= 'MB07' //128
Private ENTERL     := CHR(13)+CHR(10)

	MSCBBEGIN(1,6)

	MSCBSAYBAR(025,020,Alltrim(vTexto),"N",cTipoBar,25.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)
	
	sConteudo:=MSCBEND()

Return sConteudo

	
Static Function ExParam()
Local aPergs := {}
Local aRet := {}
Local lRet  
Local vConf := {}
Local xImp := space(06)                            

		xDoc := space(30)
		aAdd( aPergs ,{1,"TEXTO : ",xDoc  ,"",'.T.', ,'.T.',40,.T.})   
		aAdd( aPergs ,{1,"Impressora: ",xImp  ,"@!",'.T.',"CB5",'.T.',40,.T.}) 

	If ParamBox(aPergs ,"Parametros2 ",aRet)      
		lRet := .T.   
	Else      
		lRet := .F.   
	EndIf 

If lRet := .F. 
	Alert("Botใo Cancelar")
	Return()
Else
	If Empty(aRet[1])
		Alert("Opera็ใo Cancelada.")
		Return()
	Else
		aAdd( vConf ,{aRet[1],aRet[2]}) 
	Endif
Endif

Return (vConf)