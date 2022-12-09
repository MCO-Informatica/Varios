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
ฑฑบDesc.     ณImpressao etiqueta de saida IMCD			                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function ETAIFF07()

Local lContinua := .T.

vSetImp := {}
vSetImp := ExParam()

if vSetImp == Nil
	RETURN()
endif

If Empty(vSetImp[1,5])
	MsgAlert("Informe um local de impressao valido")
	lContinua := .F.
EndIf

If !CB5SetImp(vSetImp[1,5])
	MsgAlert("Local de Impressใo "+vSetImp[1,2]+" nao Encontrado!")
	lContinua := .F.
	Return
Endif

If lContinua
	ImpEti07(vSetImp[1,1],vSetImp[1,2],vSetImp[1,3],vSetImp[1,4])
	MSCBCLOSEPRINTER()
EndIf

Return
//////////////////////////////////////////
//Rotina de impressao de etiqueta      //
/////////////////////////////////////////
Static Function ImpEti07(vDoc,vDoc1,vDoc2,vDoc3)

Local cQuery	:= ""
Local cAliasNew	:= GetNextAlias()
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


cQuery 	:= " SELECT *  FROM " +RetSqlName("SD2") + " WHERE D2_FILIAL = '"+ xFilial("SD2")+"' AND "
cQuery 	+= "  D2_DOC =   '" +vDoc+"' AND D2_COD = '"+vDoc1+"' "
cQuery 	+= "  AND D_E_L_E_T_<>'*'"

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNew,.T.,.T.)
(cAliasNew)->(dbGoTop())

If Select(cAliasNew) < 1
	Alert("Opera็ใo Cancelada.")
	Return()
EndIf


While (cAliasNew)->(!Eof())
	
	For Z:= 1 to vDoc2
		
		Dbselectarea("SA1")
		SA1->( dbSetOrder( 1 ) )
		SA1->( DbSeek(xFilial("SA1")+ (cAliasNew)->D2_CLIENTE + (cAliasNew)->D2_LOJA) )
		
		Dbselectarea("SB1")
		SB1->( dbSetOrder( 1 ) )
		SB1->( DbSeek(xFilial("SB1")+ (cAliasNew)->D2_COD) )
		
		Dbselectarea("SD2")
		SD2->( dbSetOrder( 3 ) )
		SD2->( DbSeek(xFilial("SD2")+ (cAliasNew)->D2_DOC+ (cAliasNew)->D2_SERIE+ (cAliasNew)->D2_CLIENTE+ (cAliasNew)->D2_LOJA+ (cAliasNew)->D2_COD) )
		
		
		cCodBar:= ALLTRIM((cAliasNew)->D2_COD)
		cCodBar1:= ALLTRIM((cAliasNew)->D2_LOTECTL)
		
		MSCBBEGIN(1,6)
		
		//cabe็alho
		MSCBSAY(010,005,"IMCD","N","0","035,040")
		MSCBSAY(024,006,"Brasil Farma","N","0","025,025")
		
		MSCBSAY(050,003,"Fone: (11) 5591-2300","N","0","020,020")
		MSCBSAY(050,006,"CNPJ: 62.651.955/0001-66","N","0","020,020")
		
		MSCBLineH(01,10,100)
		
		//Fornecedor
		MSCBSAY(005,011, substr(SA1->A1_NOME,1,37) ,"N","0","028,028")
		
		MSCBSAY(005,014, ALLTRIM(SA1->A1_MUN) + " - " + ALLTRIM(SA1->A1_EST),"N","0","028,028")
		
		//Produto
		MSCBSAY(005,019, "Produto: ","N","0","028,028")
		
		MSCBSAY(019,019, substr(SB1->B1_DESC,1,25),"N","0","025,028")
		
		MSCBSAY(005,024, "DCB: " + ALLTRIM(SB1->B1_DCB),"N","0","025,028")
		
		MSCBSAY(030,024, "CAS: " + ALLTRIM(SB1->B1_CASNUM),"N","0","025,028")
		
		xDescDCB := " "
		xDescDCB := Posicione("ZDC",1,xFilial("ZDC")+SB1->B1_DCB,"ZDC_DESC")
		
		MSCBSAY(005,028,ALLTRIM(xDescDCB),"N","0","025,028")
		
		MSCBSAY(005,033,"N.Fiscal: " + ALLTRIM((cAliasNew)->D2_DOC),"N","0","025,028")
		
		MSCBSAY(040,033,"P.Liquido: " + ALLTRIM(STR(vDoc3))+ ALLTRIM(SB1->B1_UM),"N","0","025,028")
		
		If SB1->B1_PESBRU > 0 .and. SB1->B1_PESO > 0
			MSCBSAY(073,033,"P.Bruto: " + ALLTRIM(STR(vDoc3*(SB1->B1_PESBRU/SB1->B1_PESO))) + ALLTRIM(SB1->B1_UM),"N","0","025,028")
		Else
			MSCBSAY(073,033,"P.Bruto: " + ALLTRIM(STR(vDoc3))+ ALLTRIM(SB1->B1_UM),"N","0","025,028")
		Endif
		
		DBSELECTAREA("SB8")
		dbsetorder(5)
		DBSEEK(xFilial("SB8")+(cAliasNew)->D2_COD + (cAliasNew)->D2_LOTECTL)
		
		MSCBSAY(005,037,"Lote Forn.: " + ALLTRIM(SB8->B8_LOTEFOR),"N","0","025,028")
		
		MSCBSAY(073,037,"Fab.: " + DTOC(SB8->B8_DFABRIC) ,"N","0","025,028")
		
		MSCBSAY(073,041,"Val.: " + DTOC(SB8->B8_DTVALID) ,"N","0","025,028")
		
		MSCBSAY(005,042, "Cond. Armazenagem: " + ALLTRIM(strtran(SB1->B1_XTEMP, "ฐ", " ")),"N","0","020,020")
		
		MSCBSAY(005,047, "Umidade: " + ALLTRIM(strtran(SB1->B1_XDUMI, "ฐ", " ")),"N","0","020,020")
		
		MSCBSAY(005,052, "Luminosidade: " + ALLTRIM(strtran(SB1->B1_XDLUM, "ฐ", " ")),"N","0","020,020")
		
		//Rodap้
		
		MSCBSAY(015,070,"Farmac๊utico Responsแvel: Beatriz Fernandes Machado - CRF - SP 36.245 ","N","0","018,018")
		
		MSCBSAY(012,073,"Rua Arquiteto Olav Redig de Campos, 105 - Torre B - 25 Andar - Sใo Paulo/SP ","N","0","018,018")
		
		(cAliasNew)->(dbSkip())
		sConteudo:=MSCBEND()
	next Z
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
Local lRet
Local xImp := space(06)
Local vConf := {}

xDoc := xDoc1 := xDoc2 := xDoc3 := space(18)
aAdd( aPergs ,{1,"Nota de saida : ",xDoc  ,"@!",'.T.', ,'.T.',40,.T.})
aAdd( aPergs ,{1,"Produto : ",xDoc1  ,"@!",'.T.', ,'.T.',40,.T.})
aAdd( aPergs ,{1,"Qnt de copias : ",xDoc2  ,"@!",'.T.', ,'.T.',40,.T.})
aAdd( aPergs ,{1,"Peso Liquido : ",xDoc3  ,"@!",'.T.', ,'.T.',40,.T.})
aAdd( aPergs ,{1,"Impressora: ",xImp  ,"@!",'.T.',"CB5",'.T.',40,.T.})

If ParamBox(aPergs ,"Parametros4 ",aRet)
	lRet := .T.
Else
	
	lRet := .F.
EndIf
If lRet
	aAdd( vConf ,{aRet[1],aRet[2],aRet[3],aRet[4],aRet[5]})
ELSE
	Alert("Botใo Cancelar")
	Return()
Endif

Return (vConf)
