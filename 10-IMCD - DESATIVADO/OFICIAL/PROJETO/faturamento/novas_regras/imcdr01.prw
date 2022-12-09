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

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ PV     ³ Autor ³ Luiz A. Oliveira        ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressão de PEDIDO                                      ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#DEFINE IMP_SPOOL 2

User Function IMCDR01()

Local nX := 0 

//Pergunta
//Local cPerg := 'CNTR01'
Local aArea := GetArea()
local nOpc    := 0
Private oPrn
Private lMargem := .F.
//Fontes
Private oFont0 := TFont():New( "Arial",,07,,.F.,,,,,.F.)
Private oFont0N := TFont():New( "Arial",,07,,.T.,,,,,.F.)
Private oFont1 := TFont():New( "Arial",,08,,.F.,,,,,.F.)
Private oFont1N := TFont():New( "Arial",,08,,.T.,,,,,.F.)
Private oFont2 := TFont():New( "Arial",,10,,.F.,,,,,.F.)
Private oFont2N := TFont():New( "Arial",,10,,.T.,,,,,.F.)
Private oFont3 := TFont():New( "Arial"  ,,12,,.F.,,,,,.F.)
Private oFont3N := TFont():New( "Arial" ,,12,,.T.,,,,,.F.)
Private oFont4 := TFont():New( "Arial"  ,,14,,.F.,,,,,.F.)
Private oFont4N := TFont():New( "Arial" ,,14,,.T.,,,,,.F.)

Private	nPosCod		:=	0010
Private	nPosDesc	:=	0060
Private	nPosDtEnt	:=	0280
Private	nPosQtPed	:=	0330
Private	nPosTpMoe	:=	0380
Private	nPosPrcNet	:=	0440
Private	nPosPrcUni	:=	0510
Private	nPosVlrTot	:=	0570
Private	nPosVlrIcm	:=	0640
Private	nPosVlrIPI	:=	0690
Private	nPosMarg	:=	730
Private nMargDir	:=	850
Private nCentroPag	:=	0450

//	If ! Pergunte(cPerg,.T.)
//		Return
//	Endif

If oPrn == Nil
	nOpc := Aviso("RELATÓRIO PEDIDO - IMCDR01", "Selecione abaixo se a impressão do "+;
												"relatório deve ser realizada com margem "+;
												"ou sem margem",;
					{"MARGEM", "S/ MARGEM", "CANCELAR"},2)
	if nOpc < 3
		lMargem := iif(nOpc==1, .T., .F.)
		cFilePrint	:= "PEDIDO_DE_VENDA_"+Dtos(MSDate())+StrTran(Time(),":","")+'.pdf'
		lPreview := .T.
		cNome := substr(Time(),7,2)+substr(Time(),4,2)
		oPrn  := FWMSPrinter():New(cFilePrint,6,.F.,,.T.)
		oPrn:Setlandscape()
		//	oPrn:SetPortrait()
		//	oPrn:SetPaperSize(9)
		oPrn:SetPaperSize(DMPAPER_A4)
		oPrn:Setup()
		oPrn:SetMargin(20,20,20,20)
		oPrn:cPathPDF :="C:\TEMP\"
		
		lRet := oPrn:Canceled()
		if lRet
			alert("Relatorio Cancelado!!!")
		Endif
	else
		return()		
	endif

EndIf

If Select("RMIN") > 0
	RMIN->( dbCloseArea() )
EndIf

oPrn:StartPage()

cQueryP := " SELECT * "
cQueryP += " FROM "+RetSqlName("SC5")+" SC5 "
cQueryP += " WHERE SC5.C5_NUM = '" + SC5->C5_NUM + "' "
cQueryP += " AND C5_FILIAL = '"+XFILIAL("SC5")+"' "
cQueryP += " ORDER BY C5_NUM "

TCQUERY cQueryP NEW ALIAS "RMIN"

DbSelectArea("RMIN")
DbGotop()

//CLIENTE
dbselectarea("SA1")
dbsetorder(1)
dbgotop()
dbseek(xfilial("SA1")+ RMIN->C5_CLIENTE+ RMIN->C5_LOJACLI )

//vendedor
dbselectarea("SA3")
dbsetorder(1)
dbgotop()
dbseek(xfilial("SA3")+ SA1->A1_VEND )

//DADOS DO MUNICIPIO
dbselectarea("CC2")
dbsetorder(2)
dbgotop()
dbseek(xfilial("CC2")+ SA1->A1_CODMUNE )

//CONDIÇÃO DE PAGAMENTO
dbselectarea("SE4")
dbsetorder(1)
dbgotop()
dbseek(xfilial("SE4")+ RMIN->C5_CONDPAG )

//TRANSPORTADORA
dbselectarea("SA4")
dbsetorder(1)
dbgotop()
dbseek(xfilial("SA4")+ RMIN->C5_TRANSP )

nLin := PRINTCABEC( 1 )

dbselectarea("SC6")
dbsetorder(1)
dbgotop()
dbseek(xfilial("SC6")+ RMIN->C5_NUM )

_nValIcm := _nValIpi := _nValPis := _nValCof := 0

vTotProd := vTotIpi := vTotICM := vTotLiq := vTotserv := vTotPis := vTotCof := Taxamoe := 0

While RMIN->C5_NUM == SC6->C6_NUM
	
	// Calculo ST e Outros Impostos
	MaFisIni(SC5->C5_CLIENTE,SC5->C5_LOJACLI,"C","N",SC5->C5_TIPOCLI,MaFisRelImp("MTR700",{"SC5","SC6"}),,,"SB1","MTR700")
	MaFisAdd(        SC6->C6_PRODUTO,;
	SC6->C6_TES,;
	SC6->C6_QTDVEN,;
	SC6->C6_PRUNIT,;
	SC6->C6_VALDESC,;
	"",;
	"",;
	0,;
	0,;
	0,;
	0,;
	0,;
	(SC6->C6_QTDVEN*SC6->C6_PRUNIT),;
	0,;
	0,;
	0)
	
	_nAliqIcm	:= MaFisRet(1,"IT_ALIQICM")
	_nValIcm	+= MaFisRet(1,"IT_VALICM" )
	_nAliqIpi	:= MaFisRet(1,"IT_ALIQIPI")
	_nValIpi	+= MaFisRet(1,"IT_VALIPI")
	_nValPis	+= MaFisRet(1,"IT_VALPS2")
	_nValCof	+= MaFisRet(1,"IT_VALCF2")
	
	MaFisEnd()
	
	oPrn:Say(nLin,nPosCod	, alltrim(SC6->C6_PRODUTO) ,oFont0)
	
	oPrn:Say(nLin,nPosDesc	, alltrim(SC6->C6_DESCRI) ,oFont0)
	
	oPrn:Say(nLin,nPosDtEnt	, DTOC(SC6->C6_ENTREG ) ,oFont0)
	
	oPrn:Say(nLin,nPosQtPed , Transform(SC6->C6_QTDVEN,"@E 999,999.99" ) + " " + SC6->C6_UM ,oFont0)
	
	oPrn:Say(nLin,nPosTpMoe+10	,  IF(SC6->C6_XMOEDA = 1,"R$",IF(SC6->C6_XMOEDA = 4,"EUR","US$"))   ,oFont0,100)
	
	Taxamoe := IF(SC6->C6_XMOEDA = 1,1, SC6->C6_XTAXA )
	
	oPrn:Say(nLin,nPosPrcNet, Transform(SC6->C6_XVLRINF ,"@E 999,999.99" ) ,oFont0)
	
	oPrn:Say(nLin,nPosPrcUni,  Transform(SC6->C6_PRCVEN /Taxamoe,"@E 999,999.99" ) ,oFont0)
	
	oPrn:Say(nLin,nPosVlrTot, Transform(SC6->C6_VALOR / Taxamoe,"@E 999,999.99" ) ,oFont0)
	
	oPrn:Say(nLin,nPosVlrIcm,   Transform(_nAliqIcm ,"@E 999,999.99" ) ,oFont0)
	
	oPrn:Say(nLin,nPosVlrIPI,   Transform(_nAliqIpi ,"@E 999,999.99" ) ,oFont0)
	
	if lMargem
		oPrn:Say(nLin,nPosMarg	,   Transform(SC6->C6_XPRMARG,"@E 999.99" )+" %" ,oFont0)
	endif
	
	vTotProd += SC6->C6_VALOR
	vTotIpi += _nValIpi
	vTotICM := _nValIcm
	vTotLiq := SC6->C6_VALOR
	vTotserv := 0.0
	vTotCof := _nValCof
	vTotPis := _nValPis
	
	nLin += 12
	
	dbselectarea("SB1")
	dbsetorder(1)
	dbgotop()
	dbseek(xfilial("SB1")+ SC6->C6_PRODUTO )
	
	If nLin > 650
		PRINTRODAPE()
		oPrn:EndPage()
		oPrn:StartPage()
		nLin := PRINTCABEC( 2 )
	Endif
	
	
	cFabr := ""
	cOrigem := ""
	
	BSCFABR(SB1->B1_COD,@cFabr,@cOrigem)
	
	cEmb := Alltrim(POSICIONE("SZ2", 1, xFilial("SB1") + SB1->B1_EMB , "Z2_DESC" ))
	
	oPrn:Say(nLin,nPosCod,"Fabricante:  "+ cFabr +" - Origem:  "+cOrigem   ,oFont1,100)
	oPrn:Say(nLin,0350	, "Embalagem: "+ cEmb +" "+  Transform(SB1->B1_QE,"@E 999,999.99" )  ,oFont1,100)
	If !Empty(SC6->C6_NUMPCOM)
		oPrn:Say(nLin,0550	, "Pedido do Cliente:  " + Alltrim(SC6->C6_NUMPCOM) + " Item: " + Alltrim(SC6->C6_ITEMPC)  ,oFont1,100)
	else
		oPrn:Say(nLin,0550	, "Pedido do Cliente:  " + Alltrim(SC6->C6_PEDCLI) + " Item: " + Alltrim(SC6->C6_ITEMPED)  ,oFont1,100)
	ENDIF

	nLin += 5
	oPrn:Line(nLin, nPosCod, nLin, nMargDir, 0, "-1")
	nLin += 10
	
	DbSelectArea("SC6")
	dbSkip()
Enddo

nLin += 12

If nLin > 650
	PRINTRODAPE()
	oPrn:EndPage()
	oPrn:StartPage()
	nLin := PRINTCABEC(2)
Endif

oPrn:SayAlign(nLin,nPosCod, "Valor Produtos.........: " ,oFont1N,100,12, CLR_BLACK, 0, 0 )
oPrn:SayAlign(nLin,0180, Transform(vTotProd / Taxamoe,"@E 999,999.99" ) ,oFont1N,100, 12, CLR_BLACK, 1, 0 )

oPrn:SayAlign(nLin,nCentroPag, "Valor Servico..........: " ,oFont1N,100, 12, CLR_BLACK, 0, 0 )
oPrn:SayAlign(nLin,nCentroPag+150, Transform(vTotServ ,"@E 999,999.99" ) ,oFont1N, 100, 12, CLR_BLACK, 1, 0 )

nLin += 12
oPrn:SayAlign(nLin,nPosCod, "Valor IPI....................: " ,oFont1N,100, 12, CLR_BLACK, 0, 0 )
oPrn:SayAlign(nLin,0180, Transform(vTotIpi / Taxamoe,"@E 999,999.99" ) ,oFont1N, 100, 12, CLR_BLACK, 1, 0 )

oPrn:SayAlign(nLin,nCentroPag, "Valor PIS..............: " ,oFont1N,100, 12, CLR_BLACK, 0, 0 )
oPrn:SayAlign(nLin,nCentroPag+150, Transform(vTotPis / Taxamoe,"@E 999,999.99" ) ,oFont1N,100, 12, CLR_BLACK, 1, 0 )

nLin += 12
oPrn:SayAlign(nLin,nPosCod, "Valor ICM..................: " ,oFont1N,100, 12, CLR_BLACK, 0, 0 )
oPrn:SayAlign(nLin,0180, Transform(vTotIcm / Taxamoe,"@E 999,999.99" ) ,oFont1N,100, 12, CLR_BLACK, 1, 0 )

oPrn:SayAlign(nLin,nCentroPag, "Valor COFINS...........: " ,oFont1N,100, 12, CLR_BLACK, 0, 0 )
oPrn:SayAlign(nLin,nCentroPag+150, Transform(vTotCof / Taxamoe,"@E 999,999.99" ) ,oFont1N, 100, 12, CLR_BLACK, 1, 0 )

nLin += 12
oPrn:SayAlign(nLin,nPosCod, "Valor Liquido.............: " ,oFont1N,100, 12, CLR_BLACK, 0, 0 )
oPrn:SayAlign(nLin,0180, Transform(vTotLiq / Taxamoe,"@E 999,999.99" ) ,oFont1N,100, 12, CLR_BLACK, 1, 0 )

oPrn:SayAlign(nLin,nCentroPag, "Taxa Moeda.............: " ,oFont1N,100, 12, CLR_BLACK, 0, 0 )
oPrn:SayAlign(nLin,nCentroPag+150, Transform(TaxaMoe,"@E 999,999.9999" ) ,oFont1N,100, 100, CLR_BLACK, 1, 0 )

nLin += 20
oPrn:Say(nLin,nPosCod, "Obs/Cliente............: ",oFont1N,100)
cObs := CAPITAL(Alltrim(SA1->A1_XOBSMTG))
nLinObs := MLCOUNT(cObs,200)

For nX := 1 To nLinObs
	oPrn:Say(nLin,0100, MemoLine(cObs,200,nX ,2,.T.) ,oFont1)
	nLin += 12
next nX

nLin += 12
oPrn:Say(nLin,nPosCod, "Nr.Importacao:____________________________________________________  Taxa: __________________ R$: ____________________" ,oFont1N,100)
nLin := nLin + 15
oPrn:Say(nLin,nPosCod, "Lote:_____________________________________________________________  N.F: ___________________ Data: __________________" ,oFont1N,100)
nLin := nLin + 15
cMargem := TRANSFORM (SuperGetMV("MV_XMARGEM", ,1000),"@E 99,999.99")

oPrn:Say(nLin,nPosCod, "Faturamento:** Minimo de US$ "+cMargem+" ou agrupar com outro item **" ,oFont1N,100 )

nLin := nLin + 15

DbSelectArea("RMIN")
DbGotop()

PRINTRODAPE()

oPrn:EndPage()
RestArea(aArea)

If lPreview
	oPrn:Preview()
EndIf

FreeObj(oPrn)
oPrn := Nil

Return


Static Function PRINTCABEC( nTipo )
Local cStartPath := GetSrvProfString("Startpath","")
Local nLinObs2 := 0
Local nX := 0 
Local cQuery := ""
Default nTipo := 1

oPrn:SayBitmap(50, nPosCod+20 ,cStartPath+"FLWIMCDLG.bmp", 090, 0030)    //LOGO DA EMPRESA

oPrn:Say(0050,0150, AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ,oFont4N,100)
oPrn:Say(0065,0150, Capital( SM0->M0_ENDCOB ) ,oFont3N,100)
oPrn:Say(0078,0150, "CEP.......: "+SM0->M0_CEPCOB ,oFont3N,100)
oPrn:Say(0091,0150, "CNPJ..: "+	Transform(SM0->M0_CGC,"@r 99.999.999/9999-99")  ,oFont3N,100)
oPrn:Say(0104,0150, "Fone..: "+SM0->M0_TEL ,oFont3N,100)

oPrn:Say(0065,0420, Alltrim(SM0->M0_CIDCOB) + " - "+SM0->M0_ESTCOB ,oFont3N,100)
oPrn:Say(0078,0420, Alltrim(SM0->M0_CIDCOB) + " - "+SM0->M0_ESTCOB ,oFont3N,100)
oPrn:Say(0091,0420, "Inscr.Est.: "+Transform(SM0->M0_INSC,"@r 999.999.999.99") ,oFont3N,100)
//oPrn:Say(0104,0420, "Fax.......: "+SM0->M0_TEL ,oFont3N,100)

oPrn:Line( 00110, nPosCod, 0110, nMargDir, 0, "-1")

oPrn:Say(0125,0150, "PEDIDO Nº.: " + ALLTRIM(SC5->C5_NUM) ,oFont3N,100)
oPrn:Say(0125,0420, "Emissão:  " + DTOC(SC5->C5_EMISSAO) ,oFont3N,100)
oPrn:FWMSBAR("CODE128",0125 /*nRow*/,600/*nCol*/,ALLTRIM(SC5->C5_NUM),oPrn,,,, 0.049,1.0,,,,.F.,,,)
oPrn:Line( 00130, nPosCod, 0130, nMargDir, 0, "-1")

nLin := 00130

if nTipo == 1

If Select("TSA1") > 0
	TSA1->( dbCloseArea() )
EndIf

cQuery := " SELECT * "
cQuery += " FROM "+RetSqlName("SC5")+" SC5 JOIN "+RetSqlName("SA1")+" SA1 " 
cQuery += " ON A1_COD = C5_CENT AND A1_LOJA = C5_LENT AND SA1.D_E_L_E_T_ <> '*' "
cQuery += " WHERE SC5.C5_NUM = '" + SC5->C5_NUM + "' "
cQuery += " AND C5_FILIAL = '"+XFILIAL("SC5")+"' "
cQuery += " ORDER BY C5_NUM "

TCQUERY cQuery NEW ALIAS "TSA1"

	//BLOCO 1 PAGINA 1
	nLin += 010
	oPrn:Say(nLin ,nPosCod, "Cliente       :    [" +SA1->A1_COD+"-"+SA1->A1_LOJA+"] "+Alltrim(SA1->A1_NOME) ,oFont2,100)
	oPrn:Say(nLin,nCentroPag , "CNPJ     :    " + Alltrim(SA1->A1_CGC) ,oFont2,100)
	nLin += 10
	oPrn:Say(nLin,nPosCod, "Endereço   :    " + Alltrim(SA1->A1_END)  ,oFont2,100)
	oPrn:Say(nLin,nCentroPag, "BAIRRO :    " + Alltrim(SA1->A1_BAIRRO)  ,oFont2,100)
	nLin += 10
	oPrn:Say(nLin,nPosCod, "Cidade       :    " + Alltrim(SA1->A1_MUN)  ,oFont2,100)
	oPrn:Say(nLin,nCentroPag, "CEP       :    " + Alltrim(SA1->A1_CEP)+ " - "+ "ESTADO :" + Alltrim(SA1->A1_EST)  ,oFont2,100)
	nLin += 10
	
	oPrn:Say(nLin,nPosCod, "Fone          :    " + Alltrim(SA1->A1_DDD)+ "-" + Alltrim(SA1->A1_TEL)  ,oFont2,100)
	nLin += 10
	oPrn:Say(nLin,nPosCod, "Vendedor   :    " + Alltrim(SA3->A3_NOME) ,oFont2,100)
	nLin += 10
	oPrn:Say(nLin,nPosCod, "Cond.Pagto:    " + Alltrim(SE4->E4_DESCRI) ,oFont2,100)
	nLin += 10
	oPrn:Say(nLin,nPosCod, "Cobrança    :   " + If(!empty(SA1->A1_ENDCOB),Alltrim(SA1->A1_ENDCOB)+", " + Alltrim(SA1->A1_BAIRROC)+ ", " + Alltrim(SA1->A1_MUNC) + "-" + Alltrim(SA1->A1_ESTC)+", "+ Alltrim(SA1->A1_CEPC)," ") ,oFont2,100)
	nLin += 10
	oPrn:Say(nLin,nPosCod, "Local de Entrega  : " + Alltrim(TSA1->A1_END)+", "+ Alltrim(TSA1->A1_BAIRRO)+", "+ Alltrim(TSA1->A1_MUN)+"-"+Alltrim(TSA1->A1_EST)+", "+ Alltrim(TSA1->A1_CEP) ,oFont2,100)
	nLin += 10
	oPrn:Say(nLin,nPosCod, "Transportadora    : ["+SA4->A4_COD+"] "+ Alltrim(SA4->A4_NOME),oFont2,100)
	nLin += 10
	//	oPrn:Say(nLin,nPosCod, "Pedido do Cliente : " + Alltrim(SC5->C5_XPEDCLI),oFont2,100)
	//	nLin += 10
	oPrn:Say(nLin,nPosCod, "Obs/Pedido............: ",oFont2,100)
	
	cMsg := Alltrim( SC5->C5_MENNOTA)+" "+ALLTRIM(SC5->C5_OBSFAT)
	
	nLinObs2 := MLCOUNT( cMsg ,200)
	For nX := 1 To nLinObs2
		oPrn:Say(nLin,nPosCod+60, MemoLine( cMsg ,200,nX) ,oFont1,100)
		nLin += 12
	Next
	
	oPrn:Line( nLin, nPosCod, nLin, nMargDir, 0, "-1")
	
	nLin += 10
	oPrn:Say(nLin,nPosCod	, "Codigo" ,oFont1N,100)
	oPrn:Say(nLin,nPosDesc	, "Descrição" ,oFont1N,100)
	oPrn:Say(nLin,nPosDtEnt	, "Previsão Entrega" ,oFont1N,100)
	oPrn:Say(nLin,nPosQtPed	, "Qtde Produto" ,oFont1N,100)
	oPrn:Say(nLin,nPosTpMoe	, "Tipo Moeda" ,oFont1N,100)
	oPrn:Say(nLin,nPosPrcNet, "Preço Net" ,oFont1N,100)
	oPrn:Say(nLin,nPosPrcUni, "Preço Unitario" ,oFont1N,100)
	oPrn:Say(nLin,nPosVlrTot, "Valor Produto" ,oFont1N,100)
	oPrn:Say(nLin,nPosVlrIcm, "ICMS %" ,oFont1N,100)
	oPrn:Say(nLin,nPosVlrIPI, "IPI %" ,oFont1N,100)
	if lMargem
		oPrn:Say(nLin,nPosMarg	, "Lucro S/Venda" ,oFont1N,100)
	endif
	
	nLin += 05
	oPrn:Line(nLin, nPosCod, nLin, nMargDir, 0, "-1")
	nLin += 8
Endif
RETURN(nLin)


Static Function PRINTRODAPE()
nLin := 0780
oPrn:Say( nLin ,nPosCod, "Vendas/Pedido - "+ dtoc(DATE()) +" - "+ TIME() + SPACE(30) + "Usuário: " + LogUserName() ,oFont0,100)

Return()

Static Function	BSCFABR( cPrd,cFabr,cOrigem)
Local cAlias := GetNextAlias()

BeginSql Alias cAlias
	
	SELECT
	A5_FABR,A5_FALOJA, A2_COD,A2_LOJA , A2_NREDUZ ,A2_PAIS, YA_DESCR
	FROM %Table:SA5% PRDFAB, %Table:SA2% FAB
	LEFT JOIN %Table:SYA% PAIS ON  YA_FILIAL = %xFilial:SYA% AND YA_CODGI = A2_PAIS AND PAIS.%NotDel%
	WHERE A5_FILIAL = %xFilial:SA5%
	AND A5_PRODUTO = %Exp:cPrd%
	AND PRDFAB.%NotDel%
	AND A2_FILIAL = %xFilial:SA2%
	AND A2_COD||A2_LOJA = A5_FABR||A5_FALOJA
	AND FAB.%NotDel%
	
EndSql

dbSelectArea(cAlias)
dbGoTop()

cFabr := (cAlias)->A2_NREDUZ
cOrigem := (cAlias)->YA_DESCR

If Select(cAlias) > 0
	(cAlias)->(DbCloseArea())
EndIf

Return Nil
