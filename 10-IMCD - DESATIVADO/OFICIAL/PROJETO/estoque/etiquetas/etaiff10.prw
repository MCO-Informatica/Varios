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
ฑฑบPrograma  ณETAIFF10  บAutor  Luiz Oliveira        บ Data ณ  10/08/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressao etiqueta de saida IMCD			                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ETAIFF10()

Local lContinua := .T.

vSetImp := {}
vSetImp := ExParam()

if vSetImp == Nil
	RETURN()
endif

If Empty(vSetImp[1,4])
	MsgAlert("Informe um local de impressao valido")
	lContinua := .F.
EndIf

If !CB5SetImp(vSetImp[1,4])
	MsgAlert("Local de Impressใo "+vSetImp[1,2]+" nao Encontrado!")
	lContinua := .F.
	Return
Endif

If lContinua
	ImpEti07(vSetImp[1,1],vSetImp[1,2],vSetImp[1,3])
	MSCBCLOSEPRINTER()
EndIf

Return
//////////////////////////////////////////
//Rotina de impressao de etiqueta      //
/////////////////////////////////////////
Static Function ImpEti07(vDoc,vDoc1,vDoc2)

Local cQuery	:= ""
Local ZQuery	:= ""
Local cAliasNew	:= GetNextAlias()
Local cCodBar	:= ''
Local sConteudo	:= ""
Local cForn := cProd := cCodProd := cCOdDCB := cDesDCB := cNfiscal := cLote := cFabrinte := cExport := " "
Local cUmidade := cLumin := cOrigem := cProced := " "
Local cPliq := cPBruto := cTemper := 0
Local cFabricao := cVal := " "
Local nX := 1
Private ENTERL     := CHR(13)+CHR(10)

//+-----------------------
//| Cria filtro temporario
//+-----------------------

cAliasNew:= GetNextAlias()


cQuery 	:= " SELECT D2_FILIAL,D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_LOCAL ,D2_COD,  D2_LOTECTL , SUM(D2_QUANT) D2_QUANT "
cQuery 	+= " FROM " +RetSqlName("SD2") + " WHERE D2_FILIAL = '"+ xFilial("SD2")+"' AND "
cQuery 	+= "  D2_DOC =   '" +vDoc+"' AND D2_LOTECTL BETWEEN '"+vDoc1+"' AND '"+vDoc2+"' "
cQuery 	+= "  AND D_E_L_E_T_<>'*'"
cQuery 	+= "  GROUP BY D2_FILIAL,D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_LOCAL ,D2_COD,  D2_LOTECTL "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNew,.T.,.T.)
(cAliasNew)->(dbGoTop())

If Select(cAliasNew) < 1
	Alert("Opera็ใo Cancelada.")
	Return()
EndIf



While (cAliasNew)->(!Eof())
	
	
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
	
	nQtdEtq := BSCQTETQ(cCodBar,cCodBar1 )
	
	For nX := 1 To nQtdEtq
		
		aPesos := BSCPESOS(cCodBar,cCodBar1 )
		
		if(empty(aPesos))
			LCONTINUA := .F.
			return()
		endif
		
		
		MSCBBEGIN(1,6)
		
		//cabe็alho
		MSCBSAY(010,005,"IMCD","N","0","035,040")
		MSCBSAY(024,006,"BRASIL FARMA" ,"N","0","025,025")
		
		MSCBSAY(050,003,"Fone..: "+SM0->M0_TEL,"N","0","020,020")
		MSCBSAY(050,006,"CNPJ..: "+	Transform(SM0->M0_CGC,"@r 99.999.999/9999-99") ,"N","0","020,020")
		
		MSCBSAY(090,006,alltrim(str(nX)) + "/" + alltrim(str(nQtdEtq)),"N","0","020,020")
		
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
		
		
		MSCBSAY(040,033,"P.Liquido: " + ALLTRIM(STR( aPesos[1]  ))+" "+ALLTRIM(SB1->B1_UM),"N","0","025,028")
		
		MSCBSAY(073,033,"P.Bruto: " + ALLTRIM(STR( aPesos[2] ))+" "+ALLTRIM(SB1->B1_UM),"N","0","025,028")
		
		DBSELECTAREA("SB8")
		dbsetorder(5)
		DBSEEK(xFilial("SB8")+(cAliasNew)->D2_COD + (cAliasNew)->D2_LOTECTL)
		
		MSCBSAY(005,037,"Lote Forn.: " + ALLTRIM(SB8->B8_LOTECTL),"N","0","025,028")
		
		MSCBSAY(073,037,"Fab.: " + DTOC(SB8->B8_DFABRIC) ,"N","0","025,028")
		
		MSCBSAY(073,041,"Val.: " + DTOC(SB8->B8_DTVALID) ,"N","0","025,028")
		
		MSCBSAY(005,042, "Cond. Armazenagem: " + ALLTRIM(strtran(SB1->B1_XTEMP, "ฐ", " ")),"N","0","020,020")
		
		MSCBSAY(005,047, "Umidade: " + ALLTRIM(strtran(SB1->B1_XDUMI, "ฐ", " ")),"N","0","020,020")
		
		MSCBSAY(005,052, "Luminosidade: " + ALLTRIM(strtran(SB1->B1_XDLUM, "ฐ", " ")),"N","0","020,020")
		
		If Select("RMIN3") > 0
			RMIN3->( dbCloseArea() )
		EndIf
		
		ZQuery 	:= " SELECT *  FROM " +RetSqlName("SD1") + " WHERE D1_FILIAL = '"+ xFilial("SD1")+"' AND "
		ZQuery 	+= " D1_COD = '"+SB1->B1_COD+"' AND D1_LOTEFOR = '"+SB8->B8_LOTEFOR+"' "
		ZQuery 	+= "  AND D_E_L_E_T_<>'*'"
		
		TCQUERY ZQuery  NEW ALIAS "RMIN3"
		
		DbSelectArea("RMIN3")
		DbGotop()
		
		xFabric := " "
		xFabric := Posicione("SA2",1,xFilial("SA2")+RMIN3->D1_FABRIC+RMIN3->D1_LOJFABR,"A2_NOME")
		
		MSCBSAY(005,057, "Fabricante: " + ALLTRIM(xFabric),"N","0","020,020")
		
		DBSELECTAREA("SA2")
		dbsetorder(1)
		DBSEEK(xFilial("SA2")+RMIN3->D1_FABRIC+RMIN3->D1_LOJFABR)
		
		DBSELECTAREA("SYA")
		dbsetorder(1)
		DBSEEK(xFilial("SYA")+SA2->A2_PAIS)
		
		MSCBSAY(073,057, "Origem: " + ALLTRIM(SYA->YA_DESCR),"N","0","020,020")
		
		DBSELECTAREA("SA2")
		dbsetorder(1)
		DBSEEK(xFilial("SA2")+RMIN3->D1_FORNECE+RMIN3->D1_LOJA)
		
		DBSELECTAREA("SYA")
		dbsetorder(1)
		DBSEEK(xFilial("SYA")+SA2->A2_PAIS)
		
		
		MSCBSAY(005,062, "Exportador: " + ALLTRIM(SA2->A2_NOME),"N","0","020,020")
		
		MSCBSAY(073,062, "Procedencia: " + ALLTRIM(SYA->YA_DESCR) ,"N","0","020,020")
		
		//	MSCBSAY(005,059, "ENTRADA" ,"N","0","032,032")
		//	MSCBSAY(005,063, "APROVADO" ,"N","0","038,038")
		
		//	MSCBSAY(083,064, ALLTRIM((cAliasNew)->B8_LOTECTL) ,"N","0","028,028")
		
		//Rodap้
		
		MSCBSAY(015,070,"Farmac๊utico Responsแvel: Beatriz Fernandes Machado - CRF - SP 36.245 ","N","0","018,018")
		
		MSCBSAY(012,073,"Rua Arquiteto Olav Redig de Campos, 105 - Torre B - 25 Andar - Sใo Paulo/SP ","N","0","018,018")
		
		//	MSCBSAYBAR(067,012,cCodBar,"N",cTipoBar,9.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)
		
		//	MSCBSAYBAR(072,057,cCodBar1,"N",cTipoBar,9.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)
		sConteudo:=MSCBEND()
		
	Next nx
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
Local lRet
Local xImp := '000001'
Local vConf := {}
IF FUNNAME() == 'MATA512'
	xDoc := SF2->F2_DOC
ELSE
	xDoc := SPACE( TamSX3( 'D2_DOC' )[1] )
ENDIF

xDoc1 := xDoc2 :=space(18)

aAdd( aPergs ,{1,"Nota de saida : ",xDoc  ,"@!",'.T.', ,'.T.',40,.T.})
aAdd( aPergs ,{1,"Lote Interno De : ",xDoc1  ,"@!",'.T.', ,'.T.',40,.F.})
aAdd( aPergs ,{1,"Lote Interno Ate : ",xDoc2  ,"@!",'.T.', ,'.T.',40,.T.})
aAdd( aPergs ,{1,"Impressora: ",xImp  ,"@!",'.T.',"CB5",'.T.',40,.T.})

If ParamBox(aPergs ,"Parametros4 ",aRet)
	lRet := .T.
Else
	lRet := .F.
EndIf
If lRet
	aAdd( vConf ,{aRet[1],aRet[2],aRet[3],aRet[4]})
Else
	Alert("Botใo Cancelar")
	Return()
Endif

Return (vConf)

Static Function BSCPESOS(cCodBar,cCodBar1 )
Local aPergs := {}
Local aRet := {}
Local aRet2 := {}

aAdd( aPergs ,{9,"Produto : " + Alltrim(cCodBar), 100 ,15 ,.F.})
aAdd( aPergs ,{9,"Lote.For : " + Alltrim(cCodBar1), 100 ,15 ,.F.})
aAdd( aPergs ,{1,"Peso Liq    : ",0,"@E 999,999.99",'.T.',"","",100,.F.})
aAdd( aPergs ,{1,"Peso Bruto  : ",0,"@E 999,999.99",'.T.',"","",100,.F.})

If ParamBox(aPergs ,"Parametros6 ",aRet)
	aRet2 := {aRet[3],aRet[4]}
Else
	Alert("Botใo Cancelar")
EndIf

Return (aRet2)

Static Function BSCQTETQ(cCodBar,cCodBar1 )
Local aPergs := {}
Local nRet := 0
Local aRet := {}

aAdd( aPergs ,{9,"Produto : " + Alltrim(cCodBar), 100 ,15 ,.F.})
aAdd( aPergs ,{9,"Lote.For : " + Alltrim(cCodBar1), 100 ,15 ,.F.})
aAdd( aPergs ,{1,"Qtd Etiqueta:",0,"@E 999",'.T.',"","",100,.T.})

If ParamBox(aPergs ,"Quantidade Etiquetas NF",aRet)
	nRet := aRet[3]
Else
	Alert("Botใo Cancelar")
EndIf

Return (nRet)
