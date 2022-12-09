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


User Function ETAIFF01(xDoc)


Local lContinua := .T.
Local vDocumen := " "



IF Type ("xDoc") <> "U"
	vDocumen := xDoc
Endif

vSetImp := {}
vSetImp := ExParam(vDocumen)

If Empty(vSetImp[1,2])
	MsgAlert("Informe um local de impressao valido")
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
Static Function ImpEti07(vDoc)

Local cQuery	:= ""
Local dQuery	:= ""
Local cAliasNew	:= GetNextAlias()
Local cTipoBar	:= 'MB07' //128
Local cCodBar	:= ''
Local sConteudo	:= ""
local zDoc := vDoc
Local cForn := cProd := cCodProd := cCOdDCB := cDesDCB := cNfiscal := cLote := cFabrinte := cExport := " "
Local cUmidade := cLumin := cOrigem := cProced := " "
Local cPliq := cPBruto := cTemper := 0
Local cFabricao := cVal := " "

Private ENTERL     := CHR(13)+CHR(10)

//+-----------------------
//| Cria filtro temporario
//+-----------------------

cAliasNew:= GetNextAlias()


cQuery 	:= " SELECT *  FROM " +RetSqlName("SB8") + " WHERE B8_FILIAL = '"+ xFilial("SB8")+"' AND "
cQuery 	+= " B8_SALDO > 0 AND "  + ENTERL
If Len(zDoc) == 9
	cQuery 	+= "  B8_LOTEFOR =   '" +zDoc+"'" + ENTERL
Else
	cQuery 	+= "  B8_LOTEFOR =   '" +zDoc+"'" + ENTERL
Endif
cQuery 	+= "  AND D_E_L_E_T_<>'*'"
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNew,.T.,.T.)
(cAliasNew)->(dbGoTop())

If Select(cAliasNew) < 1
	Alert("Opera็ใo Cancelada.")
	Return()
EndIf

If Select("RMIN") > 0
	RMIN->( dbCloseArea() )
EndIf

dQuery 	:= " SELECT *  FROM " +RetSqlName("SD1") + " WHERE D1_FILIAL = '"+ xFilial("SD1")+"' AND D_E_L_E_T_ <> '*' AND "
dQuery 	+= "  D1_COD =   '" +(cAliasNew)->B8_PRODUTO+"' AND D1_LOTEFOR = '"+(cAliasNew)->B8_LOTEFOR+"' "
TCQUERY dQuery  NEW ALIAS "RMIN"
DbSelectArea("RMIN")
DbGotop()


If Select("RMIN2") > 0
	RMIN2->( dbCloseArea() )
EndIf

EQuery 	:= " SELECT COUNT(B8_PRODUTO) VTOTAL  FROM " +RetSqlName("SB8") + " WHERE B8_FILIAL = '"+ xFilial("SB8")+"' AND "
EQuery 	+= " B8_SALDO > 0 AND "  + ENTERL
If Len(zDoc) == 9
	EQuery 	+= "  B8_DOC =   '" +zDoc+"'" + ENTERL
Else
	EQuery 	+= "  B8_LOTEFOR =   '" +zDoc+"'" + ENTERL
Endif
EQuery 	+= "  AND D_E_L_E_T_<>'*'"
TCQUERY EQuery  NEW ALIAS "RMIN2"

DbSelectArea("RMIN2")
DbGotop()


Dbselectarea("SA2")
SA2->( dbSetOrder( 1 ) )
SA2->( DbSeek(xFilial("SA2")+ RMIN->D1_FORNECE + RMIN->D1_LOJA) )

Dbselectarea("SB1")
SB1->( dbSetOrder( 1 ) )
SB1->( DbSeek(xFilial("SB1")+ RMIN->D1_COD) )

Dbselectarea("SD1")
SD1->( dbSetOrder( 1 ) )
SD1->( DbSeek(xFilial("SD1")+ RMIN->D1_DOC+ RMIN->D1_SERIE+ RMIN->D1_FORNECE+ RMIN->D1_LOJA+ RMIN->D1_COD) )

vCTotal := 0
nCont := 1
vCTotal := RMIN2->VTOTAL

While (cAliasNew)->(!Eof())
	
	//Exemplos
	//ALLTRIM(POSICIONE("SB1",1,XFILIAL("SB1")+cProduto,"B1_CODBAR"))
	
	//MSCBSAY(058,003,"Quant :.","R","2","025,025")
	//MSCBSAY(048,022,alltrim(str(nQuant)),"R","3","035,035")
	//MSCBSAY(020,012,Dtoc(dData),"R","2","030,030")
	
	cCodBar:= ALLTRIM((cAliasNew)->B8_PRODUTO)
	cCodBar1:= ALLTRIM((cAliasNew)->B8_LOTECTL)
	
	MSCBBEGIN(1,6)
	
	//cabe็alho
	MSCBSAY(010,005,"IMCD","N","0","035,040")
	MSCBSAY(024,006,"Brasil Farma","N","0","025,025")
	
	MSCBSAY(050,003,"Fone: (11) 5591-2300","N","0","020,020")
	MSCBSAY(050,006,"CNPJ: 62.651.955/0001-66","N","0","020,020")
	
	MSCBSAY(090,006,alltrim(str(nCont)) + "/" + alltrim(str(vCTotal)),"N","0","020,020")
	
	MSCBLineH(01,10,100)
	
	//Fornecedor
	MSCBSAY(005,011, substr(SA2->A2_NOME,1,30) ,"N","0","028,028")
	
	MSCBSAY(005,014, ALLTRIM(SA2->A2_MUN) + " - " + ALLTRIM(SA2->A2_EST),"N","0","028,028")
	
	//Produto
	MSCBSAY(005,019, "Produto: ","N","0","028,028")
	
	MSCBSAY(019,019, substr(SB1->B1_DESC,1,25),"N","0","025,028")
	
	//	MSCBSAY(080,019, ALLTRIM(SB1->B1_COD),"N","0","025,028")
	
	MSCBSAY(005,024, "DCB: " + ALLTRIM(SB1->B1_DCB),"N","0","025,028")
	
	MSCBSAY(030,024, "CAS: " + ALLTRIM(SB1->B1_CASNUM),"N","0","025,028")
	
	xDescDCB := " "
	xDescDCB := Posicione("ZDC",1,xFilial("ZDC")+SB1->B1_DCB,"ZDC_DESC")
	
	MSCBSAY(005,028,ALLTRIM(xDescDCB),"N","0","025,028")
	
	MSCBSAY(005,033,"N.Fiscal: " + ALLTRIM(RMIN->D1_DOC),"N","0","025,028")
	
	MSCBSAY(040,033,"P.Liquido: " + ALLTRIM(STR((cAliasNew)->B8_SALDO))+" "+SB1->B1_UM,"N","0","025,028")
	
	IF SB1->B1_PESO <> (cAliasNew)->B8_SALDO
		nPesoEmb := Posicione("SZ2",1,xFilial("SZ2")+SB1->B1_EMB,"Z2_PESOEMB")
		MSCBSAY(073,033,"P.Bruto: " + ALLTRIM(STR( ROUND( (cAliasNew)->B8_SALDO+nPesoEmb,2) ))+" "+SB1->B1_UM,"N","0","025,028")
	ELSE
		
		If SB1->B1_PESBRU > 0 .and. SB1->B1_PESO > 0
			MSCBSAY(073,033,"P.Bruto: " + ALLTRIM(STR(ROUND( (cAliasNew)->B8_SALDO*(SB1->B1_PESBRU/SB1->B1_PESO),2)))+" "+SB1->B1_UM,"N","0","025,028")
		Else
			MSCBSAY(073,033,"P.Bruto: " + ALLTRIM(STR(ROUND((cAliasNew)->B8_SALDO,2)))+" "+SB1->B1_UM,"N","0","025,028")
		Endif
	Endif
	
	MSCBSAY(005,037,"Lote Forn.: " + ALLTRIM((cAliasNew)->B8_LOTEFOR),"N","0","025,028")
	
	MSCBSAY(073,037,"Fab.: " + SUBSTR((cAliasNew)->B8_DFABRIC,7,2)+"/"+SUBSTR((cAliasNew)->B8_DFABRIC,5,2)+"/"+SUBSTR((cAliasNew)->B8_DFABRIC,3,2) ,"N","0","025,028")
	
	MSCBSAY(073,041,"Val.: " + SUBSTR((cAliasNew)->B8_DTVALID,7,2)+"/"+SUBSTR((cAliasNew)->B8_DTVALID,5,2)+"/"+SUBSTR((cAliasNew)->B8_DTVALID,3,2) ,"N","0","025,028")
	
	MSCBSAY(005,042, "Cond. Armazenagem: " + ALLTRIM(strtran(SB1->B1_XTEMP, "ฐ", " ")),"N","0","020,020")
	
	MSCBSAY(005,045, "Umidade: " + ALLTRIM(strtran(SB1->B1_XDUMI, "ฐ", " ")),"N","0","020,020")
	
	MSCBSAY(005,048, "Luminosidade: " + ALLTRIM(strtran(SB1->B1_XDLUM, "ฐ", " ")),"N","0","020,020")
	
	
	xFabric := " "
	xFabric := Posicione("SA2",1,xFilial("SA2")+RMIN->D1_FABRIC+RMIN->D1_LOJFABR,"A2_NOME")
	
	MSCBSAY(005,051, "Fabricante: " + ALLTRIM(xFabric),"N","0","020,020")
	
	DBSELECTAREA("SA2")
	dbsetorder(1)
	DBSEEK(xFilial("SA2")+RMIN->D1_FABRIC+RMIN->D1_LOJFABR)
	
	DBSELECTAREA("SYA")
	dbsetorder(1)
	DBSEEK(xFilial("SYA")+SA2->A2_PAIS)
	
	MSCBSAY(073,051, "Origem: " + ALLTRIM(SYA->YA_DESCR),"N","0","020,020")
	
	DBSELECTAREA("SA2")
	dbsetorder(1)
	DBSEEK(xFilial("SA2")+RMIN->D1_FORNECE+RMIN->D1_LOJA)
	
	DBSELECTAREA("SYA")
	dbsetorder(1)
	DBSEEK(xFilial("SYA")+SA2->A2_PAIS)
	
	
	MSCBSAY(005,054, "Exportador: " + SUBSTR(SA2->A2_NOME,1,30),"N","0","020,020")
	
	MSCBSAY(073,054, "Procedencia: " + ALLTRIM(SYA->YA_DESCR) ,"N","0","020,020")
	
	MSCBSAY(005,059, "ENTRADA" ,"N","0","032,032")
	MSCBSAY(005,063, "APROVADO" ,"N","0","038,038")
	
	//	MSCBSAY(083,064, ALLTRIM((cAliasNew)->B8_LOTECTL) ,"N","0","028,028")
	
	//Rodap้
	
	MSCBSAY(015,071,"Farmac๊utico Responsแvel: Beatriz Fernandes Machado - CRF - SP 36.245 ","N","0","018,018")
	
	MSCBSAY(012,073,"Rua Arquiteto Olav Redig de Campos, 105 - Torre B - 25 Andar - Sใo Paulo/SP ","N","0","018,018")
	
	MSCBSAYBAR(067,012,cCodBar,"N",cTipoBar,9.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)
	
	MSCBSAYBAR(072,057,cCodBar1,"N",cTipoBar,9.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)
	
	//  Col, Lin,TEXTO,ROTACAO,TAMANHO
	//	MSCBSAYBAR(030,059,cCodBar,"N",cTipoBar,8.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)
	//	MSCBSAY(030,059,Alltrim((cAliasNew)->B8_LOTECTL)    ,"N","3","040,040")
	(cAliasNew)->(dbSkip())
	sConteudo:=MSCBEND()
	nCont := nCont +1
EndDo

(cAliasNew)->(DbCloseArea())

If Empty(sConteudo)
	MsgAlert("Sem Dados para Impressใo! Verifique os Parametros!!!","A T E N ว ร O!!!")
	Return
Else
	Return sConteudo
EndIf


Static Function ExParam(vDoc)
Local aPergs := {}
Local aRet := {}
Local lRet
Local xImp := space(06)
Local hDoc := vDoc
Local vConf := {}

If !Empty(hDoc)
	xDoc := space(09)
	xDoc := hDoc
	
	aAdd( aPergs ,{9,"Lote.For : " + Alltrim(xDoc), 100 ,15 ,.F.})
	aAdd( aPergs ,{1,"Impressora: ",xImp  ,"@!",'.T.',"CB5",'.T.',40,.T.})
Else
	xDoc := space(25)
	aAdd( aPergs ,{1,"Lote.For : ",xDoc  ,"@!",'.T.', ,'.T.',40,.T.})
	aAdd( aPergs ,{1,"Impressora: ",xImp  ,"@!",'.T.',"CB5",'.T.',40,.T.})
Endif

If ParamBox(aPergs ,"Parametros1 ",aRet)
	
	lRet := .T.
Else
	
	lRet := .F.
EndIf
If lRet := .F.
	Alert("Botใo Cancelar")
	Return()
Else
	
	If !Empty(xDoc)
		aAdd( vConf ,{xDoc,aRet[2]})
	Else
		aAdd( vConf ,{aRet[1],aRet[2]})
	Endif
Endif

Return (vConf)
