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


User Function ETAIFF05()

Local lContinua := .T.
vSetImp := {}
vSetImp := ExParam()

If Empty(vSetImp[1,1])
	MsgAlert("Informe o endere็o.")
	lContinua := .F.
EndIf
     
If Empty(vSetImp[1,2])
	MsgAlert("Informe o endere็o.")
	lContinua := .F.
EndIf

If !CB5SetImp(vSetImp[1,3])  
	MsgAlert("Local de Impressใo "+vSetImp[1,3]+" nao Encontrado!") 
	lContinua := .F.
	Return
Endif	

If lContinua
	ImpEti07(vSetImp[1,1],vSetImp[1,2])
	MSCBCLOSEPRINTER()             
EndIf

Return
//////////////////////////////////////////
//Rotina de impressao de etiqueta      //
/////////////////////////////////////////
Static Function ImpEti07(vDoc1,vDoc2)

Local cAliasNew	:= GetNextAlias()
Local cTipoBar	:= 'MB07' //128
Private ENTERL     := CHR(13)+CHR(10) 

//+-----------------------
//| Cria filtro temporario
//+-----------------------

cAliasNew:= GetNextAlias()


cQuery 	:= " SELECT *  FROM " +RetSqlName("SBE") + " WHERE BE_FILIAL = '02' AND " 
cQuery 	+= "  BE_LOCALIZ BETWEEN '"+vDoc1+"' AND '"+vDoc2+"'" + ENTERL   

cQuery 	+= "  AND D_E_L_E_T_<>'*'" 
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNew,.T.,.T.)
(cAliasNew)->(dbGoTop())

If Select(cAliasNew) < 1
	Alert("Opera็ใo Cancelada.")
	Return()
EndIf

While (cAliasNew)->(!Eof()) 

	MSCBBEGIN(1,6)
	vTexto := ALLTRIM((cAliasNew)->BE_LOCALIZ)
	
	MSCBSAYBAR(045,020,Alltrim(vTexto),"N",cTipoBar,30.50,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)
	
	(cAliasNew)->(dbSkip())
	sConteudo:=MSCBEND()

EndDo 

(cAliasNew)->(DbCloseArea())

Return sConteudo

	
Static Function ExParam()
Local aPergs := {}
Local aRet := {}
Local lRet  
Local vConf := {}
Local xImp := space(06)                            

		xDoc := xDoc2 := space(15)
		aAdd( aPergs ,{1,"Endere็o de : ",xDoc  ,"",'.T.', ,'.T.',40,.T.}) 
		aAdd( aPergs ,{1,"Endere็o ate : ",xDoc2  ,"",'.T.', ,'.T.',40,.T.})     
		aAdd( aPergs ,{1,"Impressora: ",xImp  ,"@!",'.T.',"CB5",'.T.',40,.T.}) 

	If ParamBox(aPergs ,"Parametros5 ",aRet)      
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
		aAdd( vConf ,{aRet[1],aRet[2],aRet[3]}) 
	Endif
Endif

Return (vConf)