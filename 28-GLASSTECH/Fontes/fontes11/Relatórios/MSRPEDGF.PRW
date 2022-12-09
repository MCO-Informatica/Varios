#include "protheus.ch"
#include "colors.ch"
#Include "Font.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMSRFATGF  บAutor  ณHermes Vieira Jr    บ Data ณ  27/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime relatorio de Pedido de vendas de acordo com os     บฑฑ
ฑฑบ          ณ parametros informados.   					              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MSRPEDLI(lAuto,cNum)

	Local lReg				:= .F. 	&& Verifica a exist๊ncia de Registros
	Local nLastKey			:= 0
	Local titulo   			:= "Relat๓rio de Pedido Liberado"
	Local cMens 			:= "Nใo hแ registros para os parametros informados !!"
	Local nCount			:= 0
	Local cPerg				:= "PERFAT"
	Private cNPv 	   		:= ""
	Private cEmissao		:= ""
	Private nQtdPag			:= 0
	Private oFont1 			:= TFont():New("Arial",09,14,		,.T.,,,,,.F.) &&Parametros TFonte ("Tipo Fonte", ,Tamanho Fonte , , ,Italico (.T./.F.))
	Private oFont2  		:= TFont():New("Arial",06,07,		,.F.,,,,,.F.) && Normal
	Private oFont3  		:= TFont():New("Arial",09,10,.T.	,.T.,,,,,.F.) && Negrito
	Private oFont4  		:= TFont():New("Arial",09,14,.T.	,.T.,,,,,.T.) && Negrito - Sublinhado
	Private oFont5  		:= TFont():New("Arial",09,10,   	,.F.,,,,,.F.) && Negrito
	Private oPrint
	Private cPedido


	&& Instโncia็ใo do Objeto OPrint
	oPrint := TMSPrinter():New()
	oPrint:SetPage(9)       && Define papel A4
	oPrint:setPaperSize(10) && Define A4 Small 210 x 297 mm

	ValidPerg(cPerg)

	If lAuto
		mv_par01 := cNum
		mv_par02 := cNum
		mv_par03 := Ctod("01/01/1990")
		mv_par04 := Ctod("31/12/2060")
	Else
		If !(Pergunte(cPerg,.T.))
			Return
		Endif
	Endif

	If lastKey() == 27 .or. nLastKey == 27 .or. nLastKey == 286
		return
	Endif

	&& Query que retorna os dados do pedido de compra e os dados dos itens.
	cQuery := "SELECT "
	cQuery += "		SC5.C5_NUM, SC5.C5_EMISSAO, SC5.C5_DESC1, SC5.C5_DESC2, SC5.C5_DESC3, SC5.C5_DESC4,SC5.C5_FRETE, SC5.C5_DESPESA, "
	cQuery += "		SC5.C5_TPFRETE, SC5.C5_ESPECI1, SC5.C5_VEND1, SC5.C5_MENNOTA, SC5.C5_ZZNIVEL , SC5.C5_MENPAD, SC5.C5_CONDPAG, SC5.C5_TRANSP,SC5.C5_VOLUME1, SC5.C5_ZZVALID,  "
	cQuery += "		SA1.A1_COD, SA1.A1_LOJA,SA1.A1_NOME, SA1.A1_EMAIL, SA1.A1_END, SA1.A1_MUN, SA1.A1_EST, SA1.A1_DDD, SA1.A1_TEL, SA1.A1_FAX, SA1.A1_CEP, SA1.A1_BAIRRO, SA1.A1_EST, SA1.A1_CONTATO, SA1.A1_HPAGE,SA1.A1_CGC, SA1.A1_INSCR,"
	cQuery += "		SC6.C6_NUM, SC6.C6_ITEM, SC6.C6_PRODUTO, SC6.C6_DESCRI, SC6.C6_UM, SC6.C6_QTDVEN, SC6.C6_PRCVEN, SC6.C6_VALOR, SC6.C6_ENTREG, SC6.C6_TES,SC6.C6_PEDCLI,"
	cQuery += "		SB1.B1_IPI, SB1.B1_DESC, SE4.E4_DESCRI, SA4.A4_NOME, SA3.A3_NOME, SUM(SC9.C9_QTDLIB) C9_QTDLIB, C9_BLCRED, C9_ORDSEP,C5_ZZCOTCL "
	cQuery += "FROM " + RetSqlName("SC5") + " AS SC5 "
	cQuery += "		LEFT JOIN " + RetSqlName("SA1") + " AS SA1 ON "
	cQuery += "			SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND SC5.C5_CLIENTE = A1_COD AND SC5.C5_LOJACLI = A1_LOJA AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += "		INNER JOIN " + RetSqlName("SC6") + " AS SC6 ON "
	cQuery += "			SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND SC5.C5_NUM = SC6.C6_NUM AND SC6.D_E_L_E_T_ = ' ' "
	cQuery += "		LEFT JOIN " + RetSqlName("SB1") + " AS SB1 ON "
	cQuery += "			SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SC6.C6_PRODUTO = SB1.B1_COD AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += "		LEFT JOIN " + RetSqlName("SE4") + " AS SE4 ON "
	cQuery += "			SE4.E4_FILIAL = '" + xFilial("SE4") + "' AND SC5.C5_CONDPAG = SE4.E4_CODIGO AND SE4.D_E_L_E_T_ = ' ' "
	cQuery += "		LEFT JOIN " + RetSqlName("SA4") + " AS SA4 ON "
	cQuery += "			SA4.A4_FILIAL = '" + xFilial("SA4") + "' AND SC5.C5_TRANSP = SA4.A4_COD AND SA4.D_E_L_E_T_ = ' ' "
	cQuery += "		LEFT JOIN " + RetSqlName("SA3") + " AS SA3 ON "
	cQuery += "			SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SC5.C5_VEND1 = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' "
	cQuery += "		LEFT JOIN " + RetSqlName("SC9") + " AS SC9 ON "
	cQuery += "				SC9.C9_FILIAL = '" + xFilial("SC9")+ "' AND SC6.C6_NUM = SC9.C9_PEDIDO AND SC6.C6_PRODUTO = SC9.C9_PRODUTO AND SC6.C6_ITEM = SC9.C9_ITEM AND SC9.D_E_L_E_T_ = ' ' AND SC9.C9_BLEST = '' "
	cQuery += "	WHERE SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND SC5.D_E_L_E_T_ = ' ' AND SC5.C5_NUM >= '"+ mv_par01 +"' AND SC5.C5_NUM <= '"+ mv_par02 +"' AND C9_ORDSEP = ''"
	If !Empty(mv_par03) .AND. !Empty(mv_par04)
		cQuery += " AND C5_EMISSAO BETWEEN '" + DtoS(mv_par03) + "' AND '" + DtoS(mv_par04) + "' "
	EndIf
	cQuery += " Group by SC5.C5_NUM, SC5.C5_EMISSAO, SC5.C5_DESC1, SC5.C5_DESC2, SC5.C5_DESC3, SC5.C5_DESC4,SC5.C5_FRETE, SC5.C5_DESPESA,SC5.C5_ZZNIVEL,SC5.C5_TPFRETE, SC5.C5_ESPECI1, SC5.C5_VEND1, SC5.C5_MENNOTA, SC5.C5_MENPAD, SC5.C5_CONDPAG, SC5.C5_TRANSP,SC5.C5_VOLUME1, SC5.C5_ZZVALID,  		SA1.A1_COD, SA1.A1_LOJA,SA1.A1_NOME, SA1.A1_EMAIL, SA1.A1_END, SA1.A1_MUN, SA1.A1_EST, SA1.A1_DDD, SA1.A1_TEL, SA1.A1_FAX, SA1.A1_CEP, SA1.A1_BAIRRO, SA1.A1_EST, SA1.A1_CONTATO, SA1.A1_HPAGE,SA1.A1_CGC, SA1.A1_INSCR,		SC6.C6_NUM, SC6.C6_ITEM, SC6.C6_PRODUTO, SC6.C6_DESCRI, SC6.C6_UM, SC6.C6_QTDVEN, SC6.C6_PRCVEN, SC6.C6_VALOR, SC6.C6_ENTREG, SC6.C6_TES,SC6.C6_PEDCLI,		SB1.B1_IPI, SB1.B1_DESC, SE4.E4_DESCRI, SA4.A4_NOME, SA3.A3_NOME,C9_BLCRED,C9_ORDSEP,C5_ZZCOTCL "
	cQuery += " ORDER BY SC5.C5_NUM, SC6.C6_ITEM"

	TCQUERY cQuery NEW ALIAS "cAlias"

	TCSETFIELD("cAlias","C5_EMISSAO","D",08,00)

	Count to nCount

	cAlias->(dbgotop())

	While cAlias->(!Eof())

		If cAlias->C5_CONDPAG = '001' .And. cAlias->C9_BLCRED <> '01'
			cAlias->(DbSkip())
			Loop
		EndIf

		If !Empty(Alltrim(cAlias->C9_ORDSEP))
			cAlias->(DbSkip())
			Loop
		EndIf

		cNPv 		:= cAlias->C5_NUM
		TCSETFIELD("cAlias","C5_EMISSAO","D")
		TCSETFIELD("cAlias","C5_ZZVALID","D")
		cEMISSAO 	:= cAlias->C5_EMISSAO
		lReg 		:= .T.
		cPedido     :=  Alltrim(cAlias->C5_ZZCOTCL)


		&& Query que retorna a Quantidade Total de itens em um Pedido de Venda
		cQuery := "SELECT COUNT(C6_ITEM) AS Total "
		cQuery += " FROM " + RetSqlName("SC6")
		cQuery += " WHERE C6_NUM = '" + cAlias->C5_NUM + "' AND D_E_L_E_T_ = ' '"
		cQuery += " AND C6_FILIAL = '" + xFilial("SC6")+ "'

		TCQUERY cQuery NEW ALIAS "cCount"

		&& Atribui a Quantidade Total de itens na Variavel nCount
		&&nCount := cCount->Total

		&& Controla a Quantidade de Paginas no Relatorio
		nQtdPag := STR((cCount->Total / 30)+ 1)
		nQtdPag := LEFT(nQtdPag, AT(".",nQtdPag)-1)

		cCount->(dbCloseArea())
		oPrint:setpapersize(9)
		&&Inicia uma Nova Pagina para Impressao
		oPrint:StartPage()

		&&Define o modo de Impressao como Retrato
		oPrint:SetPortrait()  &&SetLandscape -> Para definir como modo Paisagem


		IMPCAB(cNPv, cEMISSAO)	&&Funcao para impressao do Cabecalho
		IMPCLI()	&&Funcao para impressao dos dados do Cliente
		IMPPRO(cNPv,nCount,nQtdPag)	&&Funcao para impressao dos Detalhes do Produto

	End

	cAlias->(dbCloseArea())

	oPrint:Preview()
	FreeObj(oPrint)

/*	If lReg = .F.
MsgSTOP(cMens)
Else
&&ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
&&ณ MsDialog oDlg: exibi as opcoes para tratativa do relatorio.      ณ
&&ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Define MsDialog oDlg Title "Pedido de Venda" From 0, 0 To 090, 430 Pixel
Define Font oBold Name "Arial" Size 0, -13 Bold
@ 000, 000 Bitmap oBmp ResName "LOGIN" Of oDlg Size 30, 120 NoBorder When .f. Pixel
@ 003, 040 Say Titulo Font oBold Pixel
@ 014, 030 To 016, 400 Label '' Of oDlg  Pixel
@ 020, 040 Button "Configurar" 	Size 40, 13 Pixel Of oDlg Action oPrint:Setup()
@ 020, 082 Button "Imprimir"   	Size 40, 13 Pixel Of oDlg Action oPrint:Print()
@ 020, 124 Button "Visualizar" 	Size 40, 13 Pixel Of oDlg Action oPrint:Preview()
@ 020, 166 Button "Sair"       	Size 40, 13 Pixel Of oDlg Action oDlg:End()
Activate MsDialog oDlg Centered
Endif
*/
	Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณ IMPCAB   บ Autor ณHermes Vieira Jr.	   บ Data ณ  27/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao do cabecalho do relatorio.	  						บฑฑ
ฑฑบ          ณ Informacao: Cabecalho - Dados da Empresa;					บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IMPCAB(cNPv, cEMISSAO)

	Local nTopo			:= 0000  && Controle de Linhas
	Local nInicio		:= 0000  && Indica a posi็ใo da primeira coluna
	Local cEmail 		:= GetMV("ZZ_OREMAIL")
	Local cLogo			:= GetSrvProfString("Startpath","") + "Logo\lgrl" + cFilAnt + ".BMP"

	&&ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	&&ณRetorna o tamanho Horizontal e Vertical da pagina.                                          ณ
	&&ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nVertSize := oPrint:nVertSize()
	nHorzSize := oPrint:nHorzSize()

	&&ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	&&ณImpressao do cabe็alho do Relatorio.															ณ
	&&ณObs.: O Logo pode ser colocado na pasta System do Protheus, no caso s๓ referencia o nome.    ณ
	&&ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	&& oPrint:SayBitmap(Coluna, Linha, Caminho, Largura, Altura)
	oPrint:SayBitmap(nTopo + 0050, nInicio + 0040, cLogo, 314, 235)

	dbSelectArea("SM0")
	SM0->(dbseek(cEmPant + cFilant))

	&& oPrint:Say(Coluna, Linha, Texto, Fonte, Num de Caracteres, , ,Alinhamento - 0=Left, 1=Right e 2=Center)
	oPrint:Say(nTopo + 0050, nInicio + 1500, RTrim(SM0->M0_NOMECOM)												   		,oFont1,100,,,0)
	oPrint:Say(nTopo + 0100, nInicio + 1500, AllTrim(SM0->M0_ENDENT) ,oFont5,100,,,0)
	oPrint:Say(nTopo + 0150, nInicio + 1500, AllTrim(SM0->M0_CIDENT) + "/" + AllTrim(SM0->M0_ESTENT) + "-" + " Cep: " + LEFT(AllTrim(SM0->M0_CEPENT),5) + "-" + RIGHT(AllTrim(SM0->M0_CEPENT),3)		,oFont5,100,,,0)
	oPrint:Say(nTopo + 0200, nInicio + 1500, "E-mail: " + Alltrim(cEmail)								   			,oFont3,100,,,0)
	oPrint:Say(nTopo + 0250, nInicio + 1500, "Fone: " + AllTrim(SM0->M0_TEL) + " FAX: " + AllTrim(SM0->M0_FAX)	   		,oFont5,100,,,0)
	oPrint:Say(nTopo + 0300, nInicio + 1500, "CNPJ: " + AllTrim(Transform(SM0->M0_CGC, "@R 99.999.999/9999-99")) + " - IE: " +  AllTrim(Transform(SM0->M0_INSC, "@R 999.999.999.999"))	,oFont5,100,,,0)

	&& oPrint:Line(Coluna, Linha, Coluna, Linha)
	oPrint:Line(nTopo + 0350, nInicio + 0040,nTopo + 0350, nInicio + 2330)
	oPrint:Line(nTopo + 0353, nInicio + 0040,nTopo + 0353, nInicio + 2330)
	oPrint:Line(nTopo + 0450, nInicio + 0040,nTopo + 0450, nInicio + 2330)
	oPrint:Line(nTopo + 0453, nInicio + 0040,nTopo + 0453, nInicio + 2330)

	oPrint:Say(nTopo + 0385	, nInicio + 0040, "Pedido de Venda LIBERADO Nฐ " + cNPv		,oFont1,100,,,0)
	oPrint:Say(nTopo + 0385	, nInicio + 2330,"Data: " + DTOC(cEMISSAO)			,oFont1,100,,,1)

	Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณ IMPCLI   บ Autor ณHermes Vieira Jr.	   บ Data ณ  27/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao dos Dados do Cliente.								บฑฑ
ฑฑบ          ณ Informacoes: Nome, E-mail, Endereco, Cidade, CEP, Tel, FAX,	บฑฑ
ฑฑบ			 ณ				Contato e Bairro.								บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function IMPCLI()
	Local nTopo			:= 0050  && Controle de Linhas
	Local nInicio		:= 0000  && Indica a posicao da primeira coluna

	&&ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	&&ณ Impressใo da Estrutura dos Dados do Cliente.                                                 ณ
	&&ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	&& Texto a Esquerda
	oPrint:Say(nTopo + 0430	, nInicio + 0040, "Cliente" 	,oFont3,100,,,0)
	oPrint:Say(nTopo + 0480	, nInicio + 0040, "E-mail"		,oFont3,100,,,0)
	oPrint:Say(nTopo + 0530	, nInicio + 0040, "Endere็o"	,oFont3,100,,,0)
	oPrint:Say(nTopo + 0580	, nInicio + 0040, "Cidade"	  	,oFont3,100,,,0)
	oPrint:Say(nTopo + 0630	, nInicio + 0040, "TEL"  		,oFont3,100,,,0)
	oPrint:Say(nTopo + 0680	, nInicio + 0040, "CNPJ"  		,oFont3,100,,,0)

	&&Texto Centralizado
	oPrint:Say(nTopo + 0430	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Site" 			,oFont3,100,,,0)
	oPrint:Say(nTopo + 0480	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Contato" 			,oFont3,100,,,0)
	oPrint:Say(nTopo + 0530	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Bairro" 			,oFont3,100,,,0)
	oPrint:Say(nTopo + 0580	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"CEP" 				,oFont3,100,,,0)
	oPrint:Say(nTopo + 0630	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"FAX"				,oFont3,100,,,0)
	oPrint:Say(nTopo + 0680	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"I.E."				,oFont3,100,,,0)

	&& Texto a Esquerda
	oPrint:Say(nTopo + 0430	, nInicio + 0210, ": " + cAlias->A1_COD + " - " + cAlias->A1_NOME		,oFont5,100,,,0)
	oPrint:Say(nTopo + 0480	, nInicio + 0210, ": " + cAlias->A1_EMAIL		,oFont5,100,,,0)
	oPrint:Say(nTopo + 0530	, nInicio + 0210, ": " + cAlias->A1_END			,oFont5,100,,,0)
	oPrint:Say(nTopo + 0580	, nInicio + 0210, ": " + AllTrim(cAlias->A1_MUN)+"/"+cAlias->A1_EST	   		,oFont5,100,,,0)
	oPrint:Say(nTopo + 0630	, nInicio + 0210, ": (" + cAlias->A1_DDD + ") " + LEFT(cAlias->A1_TEL,4) + "-" + SUBSTR(cAlias->A1_TEL,5,8)	 	,oFont5,100,,,0)
	If LEN(ALLTRIM(cAlias->A1_CGC)) > 11
		oPrint:Say(nTopo + 0680	, nInicio + 0210, ": " + AllTrim(Transform(cAlias->A1_CGC,"@R 99.999.999/9999-99"))	,oFont5,100,,,0)
	eLSE
		oPrint:Say(nTopo + 0680	, nInicio + 0210, ": " + AllTrim(Transform(cAlias->A1_CGC,"@R 999.999.999-99"))	,oFont5,100,,,0)
	ENDIF

	&&Texto Centralizado
	oPrint:Say(nTopo + 0430	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + cAlias->A1_HPAGE										,oFont5,100,,,0)
	oPrint:Say(nTopo + 0480	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + cAlias->A1_CONTATO										,oFont5,100,,,0)
	oPrint:Say(nTopo + 0530	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + cAlias->A1_BAIRRO										,oFont5,100,,,0)
	oPrint:Say(nTopo + 0580	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + LEFT(cAlias->A1_CEP,5) + "-" + RIGHT(cAlias->A1_CEP,3)	,oFont5,100,,,0)
	oPrint:Say(nTopo + 0630	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": (" + cAlias->A1_DDD + ") " + LEFT(cAlias->A1_FAX,4) + "-" + SUBSTR(cAlias->A1_FAX,5,8)	,oFont5,100,,,0)
	If LEN(ALLTRIM(cAlias->A1_INSCR)) > 6
		oPrint:Say(nTopo + 0680	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + AllTrim(Transform(cAlias->A1_INSCR,"@R 999.999.999.999")) ,oFont5,100,,,0)
	Else
		oPrint:Say(nTopo + 0680	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + AllTrim(cAlias->A1_INSCR) ,oFont5,100,,,0)
	EndIf


	Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณ IMPPRO   บ Autor ณHermes Vieira Jr.	   บ Data ณ  27/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao dos Dados de Detalhes dos Produtos.		  		บฑฑ
ฑฑบ		     ณ Parametros: cNPv - Numero do Pedido de Compra Corrente.		บฑฑ
ฑฑบ          ณ 			   nCount - Quantidade Total de Itens. 		  		บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function IMPPRO(cNPv, nCount, nQtdPag)
	Local nTopo		 := 0800  && Controle de Linhas
	Local nInicio	 := 0000  && Indica a posi็ใo da primeira coluna
	Local nTotal	 := 0000  && Controle do Valor Total do Pedido
	Local nfrete	 := 0000  && Controle do Valor Total do Pedido
	Local ndespesa	 := 0000  && Controle do Valor Total do Pedido
	Local nVTIpi	 := 0000  && Controle do Valor Total do Pedido com IPI
	Local nPag		 := 1
	Local nCont		 := 1
	Local nContP	 := 0
	Local nTamDes	 := 0
	Local nTamStr	 :=0
	Private nTpag	 := 0
	Private nVlrTotal := 0
	Private nVlrSol := 0
	Private nTpag	 := 0
	Private nBasIPI        := 0
	Private nAlqIPI        := 0
	Private nValIPI       := 0
	Private nBasICM        := 0
	Private nAlqICM        := 0
	Private nValICM      := 0
	Private ntotIpi 		:= 0
	Private ntotIcm 		:= 0
	Private ntotSol 		:= 0
	Private ntotFrt 		:= 0
	Private ntotGer 		:= 0
	Private QtdItem      := 0
	Private ntotMerc     := 0
	Private nPrcLista    := 0
	Private cNivel       := ''
	Private nValMerc     := 0
	Private nDescZF := 0

	&&ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	&&ณ Box, Linhas Verticais e Dados do Cabecalho de Pedido.                                        ณ
	&&ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	&& Box
	oPrint:Box(nTopo, nInicio + 0040, nTopo + 0050, nInicio + 2330)

	&&Linhas Verticais
	oPrint:Line(nTopo,nInicio + 0160,nTopo + 0050,nInicio + 0160)
	oPrint:Line(nTopo,nInicio + 0430,nTopo + 0050,nInicio + 0430)
	oPrint:Line(nTopo,nInicio + 1290,nTopo + 0050,nInicio + 1290)
	oPrint:Line(nTopo,nInicio + 1370,nTopo + 0050,nInicio + 1370)
	oPrint:Line(nTopo,nInicio + 1500,nTopo + 0050,nInicio + 1500)
	oPrint:Line(nTopo,nInicio + 1750,nTopo + 0050,nInicio + 1750)
	oPrint:Line(nTopo,nInicio + 2000,nTopo + 0050,nInicio + 2000)
	oPrint:Line(nTopo,nInicio + 2080,nTopo + 0050,nInicio + 2080)
	oPrint:Line(nTopo,nInicio + 2170,nTopo + 0050,nInicio + 2170)

	&& Texto
	oPrint:Say(nTopo + 0007,nInicio + 0050,"Item"				   		,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 0180,"Produto"					,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 0450,"Descri็ใo do Produto"		,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 1300,"Um"							,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 1390,"Qtd.Lib"						,oFont3,100,,,0)
	//oPrint:Say(nTopo + 0007,nInicio + 1580,"Prc Unit."					,oFont3,100,,,0)
	//oPrint:Say(nTopo + 0007,nInicio + 1830,"Prc Total"					,oFont3,100,,,0)
	//oPrint:Say(nTopo + 0007,nInicio + 2030,"Ipi"	  					,oFont3,100,,,0)
	//oPrint:Say(nTopo + 0007,nInicio + 2085,"Icms" 					,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 2180,"Entrega"				,oFont3,100,,,0)

	While cAlias->(!Eof()) .AND. cAlias->C5_NUM == cNPv

		&&ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		&&ณ Testa se o limite da pagina para a impressao dos produtos.                                   ณ
		&&ณ Caso ultrapasse o limite gera uma Nova Pagina                              					 ณ
		&&ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If (nTopo + 0130) >= 2550

			&&LInhas Horizontais  -  FIM PEDIDO
			oPrint:Line(nTopo + 0040,nInicio + 0040,nTopo + 0040,nInicio + 2330)

			IMPROD(NPag, nTotal, nTopo)

			&&Inicia uma Nova Pagina para Impressao
			oPrint:StartPage()

			&&Define o modo de Impressใo como Retrato
			oPrint:SetPortrait()   &&SetLandscape -> Para definir como modo Paisagem

			&&Funcao para impressao do Cabecalho
			IMPCAB(cNPv, cEMISSAO)

			&& Incrementa o contador de Paginas
			nPag := nPag + 1

			nTopo := 0450

			&&ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			&&ณ Box, Linhas Verticais e Dados do Cabecalho de Pedido.                                        ณ
			&&ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			&& Box
			oPrint:Box(nTopo, nInicio + 0040, nTopo + 0050, nInicio + 2330)

			&&Linhas Verticais
			oPrint:Line(nTopo,nInicio + 0160,nTopo + 0050,nInicio + 0160)
			oPrint:Line(nTopo,nInicio + 0430,nTopo + 0050,nInicio + 0430)
			oPrint:Line(nTopo,nInicio + 1290,nTopo + 0050,nInicio + 1290)
			oPrint:Line(nTopo,nInicio + 1370,nTopo + 0050,nInicio + 1370)
			oPrint:Line(nTopo,nInicio + 1500,nTopo + 0050,nInicio + 1500)
			oPrint:Line(nTopo,nInicio + 1750,nTopo + 0050,nInicio + 1750)
			oPrint:Line(nTopo,nInicio + 2000,nTopo + 0050,nInicio + 2000)
			oPrint:Line(nTopo,nInicio + 2080,nTopo + 0050,nInicio + 2080)
			oPrint:Line(nTopo,nInicio + 2170,nTopo + 0050,nInicio + 2170)

			&& Texto
			oPrint:Say(nTopo + 0007,nInicio + 0050,"Item"				   		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 0180,"Produto"					,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 0450,"Descri็ใo do Produto"		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 1300,"Um"							,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 1390,"Qtd.Lib"						,oFont3,100,,,0)
			//oPrint:Say(nTopo + 0007,nInicio + 1580,"Prc Unit."					,oFont3,100,,,0)
			//oPrint:Say(nTopo + 0007,nInicio + 1830,"Prc Total"					,oFont3,100,,,0)
			//oPrint:Say(nTopo + 0007,nInicio + 2030,"Ipi"	  					,oFont3,100,,,0)
			//oPrint:Say(nTopo + 0007,nInicio + 2085,"Icms" 					,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 2180,"Entrega"				,oFont3,100,,,0)
		EndIF

		&&ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		&&ณ Box, Linhas Verticais, Linhas Horizontais e Dados do Pedido.                                  ณ
		&&ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		nTamDes := LEN(ALLTRIM(cAlias->C6_DESCRI)) / 30



		If nTamDes > 2
			&&Linhas Verticais - Divisao Colunas
			oPrint:Line(nTopo + 0030,nInicio + 0040,nTopo + 0090,nInicio + 0040)
			oPrint:Line(nTopo + 0030,nInicio + 2330,nTopo + 0090,nInicio + 2220)

			oPrint:Line(nTopo + 0030,nInicio + 0160,nTopo + 0090,nInicio + 0160)
			oPrint:Line(nTopo + 0030,nInicio + 0430,nTopo + 0090,nInicio + 0430)
			oPrint:Line(nTopo + 0030,nInicio + 1290,nTopo + 0090,nInicio + 1290)
			oPrint:Line(nTopo + 0030,nInicio + 1370,nTopo + 0090,nInicio + 1370)
			oPrint:Line(nTopo + 0030,nInicio + 1500,nTopo + 0090,nInicio + 1500)
			oPrint:Line(nTopo + 0030,nInicio + 1750,nTopo + 0090,nInicio + 1750)
			oPrint:Line(nTopo + 0030,nInicio + 2000,nTopo + 0090,nInicio + 2000)
			oPrint:Line(nTopo + 0030,nInicio + 2080,nTopo + 0090,nInicio + 2080)
			oPrint:Line(nTopo + 0030,nInicio + 2170,nTopo + 0090,nInicio + 2170)

			TCSETFIELD("cAlias","C6_ENTREG","D")

			&& Impressao dos Campos dos Detalhes dos Produtos
			oPrint:Say(nTopo + 0057, nInicio + 0060, Ltrim(cAlias->C6_ITEM)				,oFont2,100,,,0)

			oPrint:Say(nTopo + 0057, nInicio + 0180, Alltrim(cAlias->C6_PRODUTO)			,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057, nInicio + 0450, Substr(Ltrim(cAlias->C6_DESCRI),1,30) + If(!Empty(cAlias->C6_PEDCLI),'-Ped.Cli:' + Alltrim(cAlias->C6_PEDCLI),'')	,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057, nInicio + 1300, LTrim(cAlias->C6_UM)					,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057, nInicio + 1480, Alltrim(STR(cAlias->C9_QTDLIB))		,oFont2,100,,,1)
			//oPrint:Say(nTopo + 0057, nInicio + 1730, Alltrim(Transform(cAlias->C6_PRCVEN, PesqPict('SC6', 'C6_PRCVEN'))),oFont2,100,,,1)
			//oPrint:Say(nTopo + 0057, nInicio + 1980, Alltrim(Transform(cAlias->C6_PRCVEN*cAlias->C9_QTDLIB, PesqPict('SC6', 'C6_VALOR')))  ,oFont2,100,,,1)


			aRet:= {}
			aRet:= CalcImp()

			/*dbSelectArea("SF4")
			dbSetOrder(1)
			dbSeek(xFilial("SF4") + cAlias->C6_TES)
			If SF4->F4_IPI == "S"
				oPrint:Say(nTopo + 0057, nInicio + 2070,Alltrim(STR(aRet[2],4,1))								,oFont2,100,,,1)
			Else
				oPrint:Say(nTopo + 0057, nInicio + 2070, "0.0"	,oFont2,100,,,1)
			EndIf
			If SF4->F4_ICM == "S"
				oPrint:Say(nTopo + 0057, nInicio + 2160, Alltrim(STR(aRet[6],4,1))	 	,oFont2,100,,,1)
			Else
				oPrint:Say(nTopo + 0057, nInicio + 2160, "0.0"		,oFont2,100,,,1)
			EndIf
			SF4->(dbCloseArea())*/

			oPrint:Say(nTopo + 0057, nInicio + 2190, DTOC(cAlias->C6_ENTREG) ,oFont2,100,,,0)

			nTamStr := 31

			For nCon := 2 to Int(nTamDes) + 1

				nTopo := nTopo + 0050

				&&ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				&&ณ Testa se o limite da pagina para a impressao dos produtos.                                   ณ
				&&ณ Caso ultrapasse o limite gera uma Nova Pagina                              					 ณ
				&&ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If (nTopo + 0130) >= 2550

					&&LInhas Horizontais  -  FIM PEDIDO
					oPrint:Line(nTopo + 0040,nInicio + 0040,nTopo + 0040,nInicio + 2330)

					IMPROD(NPag, nTotal, nTopo)

					&&Inicia uma Nova Pagina para Impressao
					oPrint:StartPage()

					&&Define o modo de Impressใo como Retrato
					oPrint:SetPortrait()   &&SetLandscape -> Para definir como modo Paisagem

					&&Funcao para impressao do Cabecalho
					IMPCAB(cNPv, cEMISSAO)

					&& Incrementa o contador de Paginas
					nPag := nPag + 1

					nTopo := 0450

					&&ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					&&ณ Box, Linhas Verticais e Dados do Cabecalho de Pedido.                                        ณ
					&&ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					&& Box
					oPrint:Box(nTopo, nInicio + 0040, nTopo + 0050, nInicio + 2330)

					&&Linhas Verticais
					oPrint:Line(nTopo,nInicio + 0160,nTopo + 0050,nInicio + 0160)
					oPrint:Line(nTopo,nInicio + 0430,nTopo + 0050,nInicio + 0430)
					oPrint:Line(nTopo,nInicio + 1290,nTopo + 0050,nInicio + 1290)
					oPrint:Line(nTopo,nInicio + 1370,nTopo + 0050,nInicio + 1370)
					oPrint:Line(nTopo,nInicio + 1500,nTopo + 0050,nInicio + 1500)
					oPrint:Line(nTopo,nInicio + 1750,nTopo + 0050,nInicio + 1750)
					oPrint:Line(nTopo,nInicio + 2000,nTopo + 0050,nInicio + 2000)
					oPrint:Line(nTopo,nInicio + 2080,nTopo + 0050,nInicio + 2080)
					oPrint:Line(nTopo,nInicio + 2170,nTopo + 0050,nInicio + 2170)

					&& Texto
					oPrint:Say(nTopo + 0007,nInicio + 0050,"Item"				   		,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 0180,"Produto"					,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 0450,"Descri็ใo do Produto"		,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1300,"Um"							,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1390,"Qtd.Lib"						,oFont3,100,,,0)
					//oPrint:Say(nTopo + 0007,nInicio + 1580,"Prc Unit."					,oFont3,100,,,0)
					//oPrint:Say(nTopo + 0007,nInicio + 1830,"Prc Total"					,oFont3,100,,,0)
					//oPrint:Say(nTopo + 0007,nInicio + 2030,"Ipi"	  					,oFont3,100,,,0)
					//oPrint:Say(nTopo + 0007,nInicio + 2085,"Icms" 					,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 2180,"Entrega"				,oFont3,100,,,0)

				EndIF

				&&Linhas Verticais - Divisao Colunas
				oPrint:Line(nTopo + 0030,nInicio + 0040,nTopo + 0090,nInicio + 0040)
				oPrint:Line(nTopo + 0030,nInicio + 2330,nTopo + 0090,nInicio + 2330)

				oPrint:Line(nTopo + 0030,nInicio + 0160,nTopo + 0090,nInicio + 0160)
				oPrint:Line(nTopo + 0030,nInicio + 0430,nTopo + 0090,nInicio + 0430)
				oPrint:Line(nTopo + 0030,nInicio + 1290,nTopo + 0090,nInicio + 1290)
				oPrint:Line(nTopo + 0030,nInicio + 1370,nTopo + 0090,nInicio + 1370)
				oPrint:Line(nTopo + 0030,nInicio + 1500,nTopo + 0090,nInicio + 1500)
				oPrint:Line(nTopo + 0030,nInicio + 1750,nTopo + 0090,nInicio + 1750)
				oPrint:Line(nTopo + 0030,nInicio + 2000,nTopo + 0090,nInicio + 2000)
				oPrint:Line(nTopo + 0030,nInicio + 2080,nTopo + 0090,nInicio + 2080)
				oPrint:Line(nTopo + 0030,nInicio + 2170,nTopo + 0090,nInicio + 2170)


				oPrint:Say(nTopo + 0057, nInicio + 0600, Substr(Ltrim(cAlias->C6_DESCRI),nTamStr,30)		,oFont2,100,,,0)

				nTamStr := nTamStr + 30

			Next

		Else

			&&Linhas Verticais - Divisao Colunas
			oPrint:Line(nTopo + 0030,nInicio + 0040,nTopo + 0090,nInicio + 0040)
			oPrint:Line(nTopo + 0030,nInicio + 2330,nTopo + 0090,nInicio + 2330)

			oPrint:Line(nTopo + 0030,nInicio + 0160,nTopo + 0090,nInicio + 0160)
			oPrint:Line(nTopo + 0030,nInicio + 0430,nTopo + 0090,nInicio + 0430)
			oPrint:Line(nTopo + 0030,nInicio + 1290,nTopo + 0090,nInicio + 1290)
			oPrint:Line(nTopo + 0030,nInicio + 1370,nTopo + 0090,nInicio + 1370)
			oPrint:Line(nTopo + 0030,nInicio + 1500,nTopo + 0090,nInicio + 1500)
			oPrint:Line(nTopo + 0030,nInicio + 1750,nTopo + 0090,nInicio + 1750)
			oPrint:Line(nTopo + 0030,nInicio + 2000,nTopo + 0090,nInicio + 2000)
			oPrint:Line(nTopo + 0030,nInicio + 2080,nTopo + 0090,nInicio + 2080)
			oPrint:Line(nTopo + 0030,nInicio + 2170,nTopo + 0090,nInicio + 2170)


			TCSETFIELD("cAlias","C6_ENTREG","D")

			&& Impressao dos Campos dos Detalhes dos Produtos
			oPrint:Say(nTopo + 0057, nInicio + 0060, Ltrim(cAlias->C6_ITEM)				,oFont2,100,,,0)

			oPrint:Say(nTopo + 0057, nInicio + 0180, Alltrim(cAlias->C6_PRODUTO)			,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057, nInicio + 0450, Substr(Ltrim(cAlias->C6_DESCRI),1,30)	,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057, nInicio + 1300, LTrim(cAlias->C6_UM)					,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057, nInicio + 1480, Alltrim(STR(cAlias->C9_QTDLIB))		,oFont2,100,,,1)
			//oPrint:Say(nTopo + 0057, nInicio + 1730, Alltrim(Transform(cAlias->C6_PRCVEN, PesqPict('SC6', 'C6_PRCVEN'))),oFont2,100,,,1)
			//oPrint:Say(nTopo + 0057, nInicio + 1980, Alltrim(Transform(cAlias->C6_PRCVEN*cAlias->C9_QTDLIB, PesqPict('SC6', 'C6_VALOR')))  ,oFont2,100,,,1)


			aRet:= {}
			aRet:= CalcImp()

			/*dbSelectArea("SF4")
			dbSetOrder(1)
			dbSeek(xFilial("SF4") + cAlias->C6_TES)
			If SF4->F4_IPI == "S"
				oPrint:Say(nTopo + 0057, nInicio + 2070,Alltrim(STR(aRet[2],4,1))								,oFont2,100,,,1)
			Else
				oPrint:Say(nTopo + 0057, nInicio + 2070, "0.0"	,oFont2,100,,,1)
			EndIf
			If SF4->F4_ICM == "S"
				oPrint:Say(nTopo + 0057, nInicio + 2160, Alltrim(STR(aRet[6],4,1))	 	,oFont2,100,,,1)
			Else
				oPrint:Say(nTopo + 0057, nInicio + 2160, "0.0"		,oFont2,100,,,1)
			EndIf
			SF4->(dbCloseArea())*/

			oPrint:Say(nTopo + 0057, nInicio + 2190, DTOC(cAlias->C6_ENTREG) ,oFont2,100,,,0)

		ENDIF

		&& Calculo do Valor Total do Pedido de Compra
		nTotal += cAlias->C6_VALOR


		&&Calcula o Valor Total do Pedido de Compra com IPI
		&&nVTIpi += (((cAlias->C6_VALOR * cAlias->B1_IPI)/100) + cAlias->C6_VALOR)

		nTopo := nTopo + 0050

		&&Incrementa Contador da Quantidade de Itens no Pedido de Compra
		nCont ++

		&&Se o arquivo chegou ao fim, imprime rodape.
		If nCont > nCount
			&&ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			&&ณ Testa se o limite da pagina para a impressao dos produtos.                                   ณ
			&&ณ Caso ultrapasse o limite gera uma Nova Pagina                              					 ณ
			&&ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If (nTopo + 0130) >= 2550

				&&LInhas Horizontais  -  FIM PEDIDO
				oPrint:Line(nTopo + 0040,nInicio + 0040,nTopo + 0040,nInicio + 2330)

				IMPROD(NPag, nTotal, nTopo)

				&&Inicia uma Nova Pagina para Impressao
				oPrint:StartPage()

				&&Define o modo de Impressใo como Retrato
				oPrint:SetPortrait()   &&SetLandscape -> Para definir como modo Paisagem

				&&Funcao para impressao do Cabecalho
				IMPCAB(cNPv, cEMISSAO)

				&& Incrementa o contador de Paginas
				nPag := nPag + 1

				nTopo := 0450

				&&ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				&&ณ Box, Linhas Verticais e Dados do Cabecalho de Pedido.                                        ณ
				&&ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				&& Box
				oPrint:Box(nTopo, nInicio + 0040, nTopo + 0050, nInicio + 2330)

				&&Linhas Verticais
				oPrint:Line(nTopo,nInicio + 0160,nTopo + 0050,nInicio + 0160)
				oPrint:Line(nTopo,nInicio + 0430,nTopo + 0050,nInicio + 0430)
				oPrint:Line(nTopo,nInicio + 1290,nTopo + 0050,nInicio + 1290)
				oPrint:Line(nTopo,nInicio + 1370,nTopo + 0050,nInicio + 1370)
				oPrint:Line(nTopo,nInicio + 1500,nTopo + 0050,nInicio + 1500)
				oPrint:Line(nTopo,nInicio + 1750,nTopo + 0050,nInicio + 1750)
				oPrint:Line(nTopo,nInicio + 2000,nTopo + 0050,nInicio + 2000)
				oPrint:Line(nTopo,nInicio + 2080,nTopo + 0050,nInicio + 2080)
				oPrint:Line(nTopo,nInicio + 2170,nTopo + 0050,nInicio + 2170)

				&& Texto
				oPrint:Say(nTopo + 0007,nInicio + 0050,"Item"				   		,oFont3,100,,,0)
				oPrint:Say(nTopo + 0007,nInicio + 0180,"Produto"					,oFont3,100,,,0)
				oPrint:Say(nTopo + 0007,nInicio + 0450,"Descri็ใo do Produto"		,oFont3,100,,,0)
				oPrint:Say(nTopo + 0007,nInicio + 1300,"Um"							,oFont3,100,,,0)
				oPrint:Say(nTopo + 0007,nInicio + 1390,"Qtd.Lib"						,oFont3,100,,,0)
				//oPrint:Say(nTopo + 0007,nInicio + 1580,"Prc Unit."					,oFont3,100,,,0)
				//oPrint:Say(nTopo + 0007,nInicio + 1830,"Prc Total"					,oFont3,100,,,0)
				//oPrint:Say(nTopo + 0007,nInicio + 2030,"Ipi"	  					,oFont3,100,,,0)
				//oPrint:Say(nTopo + 0007,nInicio + 2085,"Icms" 					,oFont3,100,,,0)
				oPrint:Say(nTopo + 0007,nInicio + 2180,"Entrega"				,oFont3,100,,,0)
			EndIF

			nFrete += cAlias->C5_FRETE
			ndespesa += cAlias->C5_DESPESA

			nTotal := nTotal + nFrete + nDespesa


			&&Box e Dados - Despesas

			oPrint:Box(nTopo + 0060, nInicio + 0040,nTopo + 0160,nInicio + 0600)
			oPrint:Line(nTopo + 0060,nInicio + 0300,nTopo + 0160,nInicio + 0300)

			oPrint:Line(nTopo + 0110, nInicio + 0040,nTopo + 0110,nInicio + 0600)

			//oPrint:Say(nTopo + 0067, nInicio + 0060, "Valor Frete"		,oFont3,100,,,0)
			//oPrint:Say(nTopo + 0067, nInicio + 0570, "R$ " + Alltrim(Transform(aRet[12], PesqPict('SC5', 'C5_FRETE')))	,oFont3,100,,,1)

			//oPrint:Say(nTopo + 0117, nInicio + 0060, "Valor Despesa"		,oFont3,100,,,0)
			//oPrint:Say(nTopo + 0117, nInicio + 0570, "R$ " + Alltrim(Transform(aRet[13],PesqPict('SC5', 'C5_DESPESA')))	,oFont3,100,,,1)


			&&Box e Dados - Despesas

			oPrint:Box(nTopo + 0060, nInicio + 0610, nTopo + 0160, nInicio + 1170)
			oPrint:Line(nTopo + 0060, nInicio + 0870,nTopo + 0160,nInicio + 0870)

			oPrint:Line(nTopo + 0110, nInicio + 0610,nTopo + 0110,nInicio + 1170)

			//oPrint:Say(nTopo + 0067, nInicio + 0630, "Total Merc."		,oFont3,100,,,0)
			//oPrint:Say(nTopo + 0067, nInicio + 1150, "R$ " + Alltrim(Transform(aRet[16], PesqPict('SC6', 'C6_VALOR')))	,oFont3,100,,,1)

			oPrint:Say(nTopo + 0117, nInicio + 0630, "Qtd Pe็as "		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0117, nInicio + 1150, Alltrim(Transform(QtdItem, PesqPict('SC6', 'C6_QTDVEN')))	,oFont3,100,,,1)

			&&Box e Dados - Impostos

			oPrint:Box(nTopo + 0060, nInicio + 1190, nTopo + 0160, nInicio + 1730)
			oPrint:Line(nTopo + 0060, nInicio + 1450,nTopo + 0160,nInicio + 1450)

			oPrint:Line(nTopo + 0110, nInicio + 1190,nTopo + 0110,nInicio + 1730)

			//oPrint:Say(nTopo + 0067, nInicio + 1210, "Valor IPI"		,oFont3,100,,,0)
			//oPrint:Say(nTopo + 0067, nInicio + 1700, "R$ " + Alltrim(Transform(aRet[9], PesqPict('SC6', 'C6_VALOR')))	,oFont3,100,,,1)

			//oPrint:Say(nTopo + 0117, nInicio + 1210, "Valor ICMS"		,oFont3,100,,,0)
			//oPrint:Say(nTopo + 0117, nInicio + 1700, "R$ " + Alltrim(Transform(aRet[10], PesqPict('SC6', 'C6_VALOR')))	,oFont3,100,,,1)


			&&Box e Dados - Valor Total
			oPrint:Box(nTopo + 0060, nInicio + 1750, nTopo + 0160, nInicio + 2330)
			oPrint:Line(nTopo + 0060, nInicio + 2010,nTopo + 0160,nInicio + 2010)

			oPrint:Line(nTopo + 0110, nInicio + 1750,nTopo + 0110,nInicio + 2330)


			//oPrint:Say(nTopo + 0067, nInicio + 1780, "Valor ST"		,oFont3,100,,,0)
			//oPrint:Say(nTopo + 0067, nInicio + 2300, "R$ " + Alltrim(Transform(aRet[11], PesqPict('SC6', 'C6_VALOR')))	,oFont3,100,,,1)

			&&If nDescZF >0
			&&	aRet[15]:= aRet[15] - nDescZF
			&&EndIF

			//oPrint:Say(nTopo + 0117, nInicio + 1780, "Valor Total"		,oFont3,100,,,0)
			//oPrint:Say(nTopo + 0117, nInicio + 2300, "R$ " + Alltrim(Transform(aRet[15], PesqPict('SC6', 'C6_VALOR')))	,oFont3,100,,,1)

			&&LInhas Horizontais  -  FIM PEDIDO
			oPrint:Line(nTopo + 0040,nInicio + 0040,nTopo + 0040,nInicio + 2330)


			&&Imprime o Numero de Paginas
			oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0100, nInicio + 2330,"Pแgina: " + str(nPag) + " / " + AllTrim(nQtdPag)  ,oFont3,100,,,1)

			&& Funcao de Impressao do Rodape. Parametro: Numero da linha atual
			IMPROD(NPag, nTotal, nTopo)
		EndIf

		cAlias->(dbskip())

	EndDo

	Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณ IMPROD	บ Autor ณ Hermes Vieira Jr.	   บ Data ณ  27/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para impressao do Rodape.								บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function IMPROD(nPag, nTotal, nTopo)

	Local nInicio		:= 0000  && Indica a posicao da primeira coluna

	If nTopo <= (Mm2Pix(oPrint, oPrint:nVertSize()) - 0600)

		&& Box Condicoes Gerais
		oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0650, nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 0240, nInicio + 2330)

		&& Titulo Centralizado
		oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0630, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Informa็๕es Gerais"		,oFont1,100,,,2)

		&& Textos Posicionados เ Esquerda
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0550, nInicio + 0060,"Forma de Pagamento"  							,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0550, nInicio + 0450,": " + cAlias->C5_CONDPAG + " - " + cAlias->E4_DESCRI	,oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0500, nInicio + 0060,"Transportadora" 				 				   	,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0500, nInicio + 0450,": (" + cAlias->C5_TRANSP + ") " + cAlias->A4_NOME							,oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0450, nInicio + 0060,"Pedido Cliente " 				 				   		,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0450, nInicio + 0450,": " + cPedido 	,oFont5,100,,,0)

		&& Textos Posicionados เ Esquerda

		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0400, nInicio + 0060,"Tipo Frete"  							,oFont3,100,,,0)
		If AllTrim(cAlias->C5_TPFRETE) = "C"
			oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0400, nInicio + 0450,": CIF" 		,oFont5,100,,,0)
		ELSE
			oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0400, nInicio + 0450,": FOB" 		,oFont5,100,,,0)
		ENDIF

		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0350, nInicio + 0060,"Vendedor" 					 	   		,oFont3,100)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0350, nInicio + 0450,": (" + cAlias->C5_VEND1 + ") " + cAlias->A3_NOME 		   	,oFont5,100)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0300, nInicio + 0060,"Classifica็ใo Emb. " 				 				   		,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0300, nInicio + 0450,": " + AllTrim(cAlias->C5_ZZNIVEL)	,oFont5,100,,,0)

		&& Box para a Mensagem da Nota
		oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0220, nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 0120, nInicio + 2330)
		oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0210, nInicio + 0060,"Mensagem" 			   							,oFont3,100,,,0)
		oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0210, nInicio + 0250,": " + TRANSFORM(cAlias->C5_MENNOTA,'@!S100') 	,oFont5,100,,,0)

		dbSelectArea("SM4")
		dbSetOrder(1)
		dbSeek(xFilial("SM4") + cAlias->C5_MENPAD)

		oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0160, nInicio + 0250,"  " + ALLTRIM(TRANSFORM(SM4->M4_DESCR,'@!S100')) 	,oFont5,100,,,0)

		SM4->(dbCloseArea())

		&&Imprime o Numero de Paginas
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0100, nInicio + 2330,"Pแgina: " + str(nPag) + " / " + AllTrim(nQtdPag)   ,oFont3,100,,,1)

		oPrint:EndPage()

	Else

		&&Encerra a Pagina Atual
		oPrint:EndPage()

		&&Inicia uma Nova Pagina para Impressao
		oPrint:StartPage()

		&&Define o modo de Impressใo como Retrato
		oPrint:SetPortrait()  &&SetLandscape -> Para definir como modo Paisagem

		&&Funcao para impressao do Cabecalho
		IMPCAB(cNPv, cEMISSAO)
		nTopo := 0420

		NPag += 1

		&& Box Condicoes Gerais
		oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0650, nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 0290, nInicio + 2330)

		&& Titulo Centralizado
		oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0630, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Informa็๕es Gerais"		,oFont1,100,,,2)

		&& Textos Posicionados เ Esquerda
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0550, nInicio + 0060,"Forma de Pagamento"  							,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0550, nInicio + 0450,": " + cAlias->C5_CONDPAG + " - " + cAlias->E4_DESCRI	,oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0500, nInicio + 0060,"Transportadora" 				 				   	,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0500, nInicio + 0450,": (" + cAlias->C5_TRANSP + ") " + cAlias->A4_NOME							,oFont5,100,,,0)

		&& Textos Posicionados เ Esquerda

		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0450, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Tipo Frete"  							,oFont3,100,,,0)
		If AllTrim(cAlias->C5_TPFRETE) = "C"
			oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0450, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0200,": CIF" 		,oFont5,100,,,0)
		ELSE
			oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0450, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0200,": FOB" 		,oFont5,100,,,0)
		ENDIF
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0400, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Vendedor" 					 	   		,oFont3,100)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0400, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0200,": (" + cAlias->C5_VEND1 + ") " + cAlias->A3_NOME 		   	,oFont5,100)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0350, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Validade" 					 	   		,oFont3,100)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0350, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0200,": " + DTOC(cAlias->C5_ZZVALID) 		   	,oFont5,100)

		&& Box para a Mensagem da Nota
		oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0270, nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 0170, nInicio + 2330)
		oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0260, nInicio + 0060,"Mensagem" 			   							,oFont3,100,,,0)
		oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0260, nInicio + 0250,": " + TRANSFORM(cAlias->C5_MENNOTA,'@!S100') 	,oFont5,100,,,0)

		dbSelectArea("SM4")
		dbSetOrder(1)
		dbSeek(xFilial("SM4") + cAlias->C5_MENPAD)

		oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0210, nInicio + 0250,"  " + TRANSFORM(SM4->M4_DESCR,'@!S100') 	,oFont5,100,,,0)

		SM4->(dbCloseArea())

		&&Imprime o Numero de Paginas
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0100, nInicio + 2330,"Pแgina: " + str(nPag) + " / " + AllTrim(nQtdPag)   ,oFont3,100,,,1)

		oPrint:EndPage()

	EndIf

	Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณ Mm2Pix   บ Autor ณWaldir Baldin		   บ Data ณ  27/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna a Largura da Pagina em Pixel.						บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Mm2Pix(oPrint, nMm)
/*Retirado metodo oPrint:nLogPixelX(), pois estava ocorrendo casos em clientes
em que a linha impressa que utliza a funcao MM2PIX saia desconfigurada*/
	&&Local nValor := (nMm * oPrint:nLogPixelX()) / 25.4
	Local nValor := (nMm * 300) / 25.4
	Return nValor

Static Function CalcImp()
	Local aArea           := GetArea()
	Local cTipoCli        := POSICIONE("SA1",1,xFilial("SA1") + cAlias->A1_COD + cAlias->A1_LOJA,"A1_TIPO")
	Local cTipoNF         := "N"
	Local nVlrTotItem     := cAlias->C6_VALOR
	Local nQuant         := cAlias->C9_QTDLIB
	Local nVlUnit         := cAlias->C6_PRCVEN
	&&ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	&&| Verifico o tipo da nota para efetuar o calculo                                          |
	&&ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	MaFisSave()
	MaFisEnd()

	MaFisIni(cAlias->A1_COD,;&& 1-Codigo Cliente/Fornecedor
	cAlias->A1_LOJA,;		&& 2-Loja do Cliente/Fornecedor
	"C",;				&& 3-C:Cliente , F:Fornecedor
	"N",;				&& 4-Tipo da NF
	cTipoCli,;		&& 5-Tipo do Cliente/Fornecedor
	Nil,;
		Nil,;
		Nil,;
		Nil,;
		"MATA461")

	&&Na argentina o calculo de impostos depende da serie.
	If cPaisLoc == 'ARG'
		MaFisAlt('NF_SERIENF',LocXTipSer('SA1',MVNOTAFIS))
	Endif

//MaFisAdd(cAlias->CK_PRODUTO, cAlias->CK_TES, nQuant,nVlUnit, 0, "", "",, 0, 0, 0, 0, nVlrTotItem, 0, 0, 0)
	MaFisAdd(    cAlias->C6_PRODUTO                    ,;           // 1-Codigo do Produto ( Obrigatorio )
	cAlias->C6_TES                        ,;          // 2-Codigo do TES ( Opcional )
	cAlias->C9_QTDLIB                    ,;          // 3-Quantidade ( Obrigatorio )
	cAlias->C6_PRCVEN                    ,;          // 4-Preco Unitario ( Obrigatorio )
	0                                ,;           // 5-Valor do Desconto ( Opcional )
	""                                ,;          // 6-Numero da NF Original ( Devolucao/Benef )
	""                                ,;          // 7-Serie da NF Original ( Devolucao/Benef )
	""                                ,;          // 8-RecNo da NF Original no arq SD1/SD2
	0                                ,;          // 9-Valor do Frete do Item ( Opcional )
	0                                ,;          // 10-Valor da Despesa do item ( Opcional )
	0                                ,;        // 11-Valor do Seguro do item ( Opcional )
	0                                ,;          // 12-Valor do Frete Autonomo ( Opcional )
	(cAlias->C6_PRCVEN*cAlias->C9_QTDLIB)    ,;          // 13-Valor da Mercadoria ( Obrigatorio )
	0                                ,;          // 14-Valor da Embalagem ( Opiconal )
	0                                ,;          // 15-RecNo do SB1
	0                                )           // 16-RecNo do SF4

	MaFisWrite(1)
	nBasIPI := MaFisRet(1,'IT_BASEIPI')
	nValIPI := MaFisRet(1,'IT_VALIPI')
	nAlqIPI := MaFisRet(1,'IT_ALIQIPI')
	nBasICM := MaFisRet(1,'IT_BASEICM')
	nValICM := MaFisRet(1,'IT_VALICM')
	nAlqICM := MaFisRet(1,'IT_ALIQICM')
	nBasSol := MaFisRet(1,'IT_BASESOL')
	nValSol := MaFisRet(1,'IT_VALSOL')

	ntotIpi  += nValIPI
	ntotIcm  += nValICM
	ntotSol  := MaFisRet(,"NF_VALSOL")
	ntotFrt  := MaFisRet(,"NF_FRETE")
	ntotDesp := MaFisRet(,"NF_DESPESA")
	ntotDesc := MaFisRet(,"NF_DESCONTO")
	ntotGer  := MaFisRet(,"NF_TOTAL")
	ntotMerc += MaFisRet(,"NF_VALMERC")
	nDescZF := MaFisRet(,"NF_DESCZF")

	nVlrSol += ntotSol
	nVlrTotal += ntotGer

	MaFisEnd()
	QtdItem += cAlias->C9_QTDLIB
	RestArea( aArea )
	Return ({nBasIPI,nAlqIPI,nValIPI,nBasICM,nValICM,nAlqICM,nBasSol,nValSol,ntotIpi,ntotIcm,nVlrSol,ntotFrt,ntotDesp,ntotDesc,nVlrTotal,ntotMerc})


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณHermes Vieira Jr.   บ Data ณ  15/01/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida se existe um grupo de perguntas caso contrario o    บฑฑ
ฑฑบ          ณ o grupo de perguntas e criado.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8 - DB2                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidPerg(cPerg)

	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j

	dbSelectArea("SX1")
	dbSetOrder(1)
	&&cPerg := PADR(cPerg,6)
	cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

	&& Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs, {cPerg, "01", "Pedido de "        			,"" ,"" ,"mv_ch1", "C", 06, 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SC5"})
	aAdd(aRegs, {cPerg, "02", "Pedido at้ "        			,"" ,"" ,"mv_ch2", "C", 06, 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SC5"})
	aAdd(aRegs, {cPerg, "03", "Data de "        			,"" ,"" ,"mv_ch3", "D", 08, 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "04", "Data at้ "        			,"" ,"" ,"mv_ch4", "D", 08, 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	&&aAdd(aRegs, {cPerg, "05", "Produto de "     			,"" ,"" ,"mv_ch5", "C", 06, 0, 0, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	&&aAdd(aRegs, {cPerg, "06", "Produto at้ "     			,"" ,"" ,"mv_ch6", "C", 06, 0, 0, "G", "", "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	&&aAdd(aRegs, {cPerg, "03", "Onde Criar?"  			,"" ,"" ,"mv_ch3", "C", 08, 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next

	dbSelectArea(_sAlias)

	Return .T.

