#INCLUDE "rwmake.ch"
#include "protheus.ch"
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

User Function ETAIFF08()

Private lContinua := .T.

vSetImp := {}
vSetImp := ExParam()

if vSetImp == Nil
	RETURN()
endif

If Empty(vSetImp[1,3])
	MsgAlert("Informe um local de impressao valido")
	lContinua := .F.
EndIf

If !CB5SetImp(vSetImp[1,3])
	MsgAlert("Local de Impressใo "+vSetImp[1,2]+" nao Encontrado!")
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
Static Function ImpEti07(vDoc,vDoc1)

Local cQuery	:= ""
Local cAliasNew	:= GetNextAlias()
Local cTipoBar	:= 'MB07' //128
Local cCodBar	:= ''
Local sConteudo	:= ""
Local cForn := cProd := cCodProd := cCOdDCB := cDesDCB := cNfiscal := cLote := cFabrinte := cExport := " "
Local cUmidade := cLumin := cOrigem := cProced := " "
Local cPliq := cPBruto := cTemper := 0
Local cFabricao := cVal := " "
Local z := 0 
Private ENTERL     := CHR(13)+CHR(10)

//+-----------------------
//| Cria filtro temporario
//+-----------------------

cAliasNew:= GetNextAlias()

cQuery 	:= " SELECT * FROM SBF020 LOTE INNER JOIN SB1020 PRD ON BF_PRODUTO = B1_COD "
cQuery 	+= " WHERE "
cQuery	+= " LOTE.BF_LOCALIZ = '" +vDoc+"' "
//cQuery 	+= " BF_PRODUTO  = '" +vDoc+"' "
cQuery 	+= " AND PRD.D_E_L_E_T_ <> '*' "
cQuery 	+= " AND LOTE.D_E_L_E_T_ <> '*' "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNew,.T.,.T.)

(cAliasNew)->(dbGoTop())
DbGotop()
aPesos := {}
While (cAliasNew)->(!Eof())
	
	For z := 1 to vDoc1
		aPesos := BSCPESOS()
		
		if(empty(aPesos))
			LCONTINUA := .F.
			return()
		endif
		
		cCodBar:= ALLTRIM((cAliasNew)->BF_PRODUTO)
		cCodBar1:= ALLTRIM((cAliasNew)->BF_LOTECTL)
		FWLogMsg("INFO", "", "BusinessObject", "ETAIFF08" , "", "", cCodBar1 , 0, 0)
		MSCBBEGIN(1,6)
		
		//cabe็alho
		MSCBSAY(010,005,"IMCD","N","0","035,040")
		MSCBSAY(024,006,"Brasil Farma","N","0","025,025")
		
		MSCBSAY(050,003,"Fone: (11) 5591-2300","N","0","020,020")
		MSCBSAY(050,006,"CNPJ: 62.651.955/0001-66","N","0","020,020")
		
		MSCBLineH(01,10,100)
		
		//Fornecedor
		MSCBSAY(005,011, " " ,"N","0","028,028")
		
		MSCBSAY(005,014, " ","N","0","028,028")
		
		//Produto
		MSCBSAY(005,019, "Produto: ","N","0","028,028")
		
		MSCBSAY(019,019, substr((cAliasNew)->B1_DESC,1,25),"N","0","025,028")
		
		MSCBSAY(005,024, "DCB: " + ALLTRIM((cAliasNew)->B1_DCB),"N","0","025,028")
		
		MSCBSAY(030,024, "CAS: " + ALLTRIM((cAliasNew)->B1_CASNUM),"N","0","025,028")
		
		xDescDCB := " "
		xDescDCB := Posicione("ZDC",1,xFilial("ZDC")+(cAliasNew)->B1_DCB,"ZDC_DESC")
		
		MSCBSAY(005,028,ALLTRIM(xDescDCB),"N","0","025,028")
		
		MSCBSAY(005,033,"Endere็o: " + ALLTRIM((cAliasNew)->BF_LOCALIZ),"N","0","025,028")
		
		MSCBSAY(040,033,"P.Liquido: " + ALLTRIM(STR( aPesos[1]  )),"N","0","025,028")
		
		MSCBSAY(073,033,"P.Bruto: " + ALLTRIM(STR( aPesos[2] )),"N","0","025,028")
		
		MSCBSAY(005,040,"Lote Forn.: " + ALLTRIM((cAliasNew)->BF_LOTECTL),"N","0","025,028")
		
		MSCBSAY(005,045, "Cond. Armazenagem: " + ALLTRIM(strtran((cAliasNew)->B1_XTEMP, "ฐ", " ")),"N","0","020,020")
		
		MSCBSAY(005,048, "Umidade: " + ALLTRIM(strtran((cAliasNew)->B1_XDUMI, "ฐ", " ")),"N","0","020,020")
		
		MSCBSAY(005,051, "Luminosidade: " + ALLTRIM(strtran((cAliasNew)->B1_XDLUM, "ฐ", " ")),"N","0","020,020")
		
		//Rodap้
		
		MSCBSAY(015,071,"Farmac๊utico Responsแvel: Beatriz Fernandes Machado - CRF - SP 36.245 ","N","0","018,018")
		
		MSCBSAY(012,073,"Rua Arquiteto Olav Redig de Campos, 105 - Torre B - 25 Andar - Sใo Paulo/SP ","N","0","018,018")
		
		MSCBSAYBAR(067,012,cCodBar,"N",cTipoBar,9.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)
		
		MSCBSAYBAR(072,057,cCodBar1,"N",cTipoBar,9.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)
		
		//  Col, Lin,TEXTO,ROTACAO,TAMANHO
		//	MSCBSAYBAR(030,059,cCodBar,"N",cTipoBar,8.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)
		//	MSCBSAY(030,059,Alltrim((cAliasNew)->B8_LOTECTL)    ,"N","3","040,040")
		
		sConteudo:=MSCBEND()
	Next Z
	
	(cAliasNew)->(dbSkip())
EndDo

(cAliasNew)->(DbCloseArea())

If Empty(sConteudo)
	MsgAlert("Sem Dados para Impressใo! Verifique os Parametros!!!","A T E N ว ร O!!!")
	Return
Else
	Return sConteudo
EndIf


Static Function ExParam()
Local aPergs := {}
Local aRet := {}
Local xImp := space(06)
Local vConf := {}
xDoc := '000001'
xDoc2 := space(15)
aAdd( aPergs ,{1,"End. de :      ",xDoc  ,"@!",'.T.', ,'.T.',40,.T.})
aAdd( aPergs ,{1,"Qts Etiquetas  ",0,"@E 999",'.T.',"","",40,.F.})
aAdd( aPergs ,{1,"Impressora:    ",xImp  ,"@!",'.T.',"CB5",'.T.',40,.T.})


If ParamBox(aPergs ,"Parametros6 ",aRet)
	aAdd( vConf ,{aRet[1],aRet[2],aRet[3]})
Else
	Alert("Botใo Cancelar")
	Return()
EndIf

Return (vConf)

static function BSCPESOS()
Local aPergs := {}
Local aRet := {}

xDoc := xDoc2 := space(15)
aAdd( aPergs ,{1,"Peso Liq   : ",0,"@E 999,999.99",'.T.',"","",100,.F.})
aAdd( aPergs ,{1,"Peso Bruto : ",0,"@E 999,999.99",'.T.',"","",100,.F.})

If ParamBox(aPergs ,"Parametros6 ",aRet)
	aAdd( aRet ,{aRet[1],aRet[2] })
Else
	Alert("Botใo Cancelar")
EndIf

Return (aRet)
