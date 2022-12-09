#include "protheus.ch"
#include "colors.ch"
#Include "Font.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMSRORCGF  บAutor  ณHermes Vieira Jr    บ Data ณ  27/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime relatorio de or็amento de acordo com os            บฑฑ
ฑฑบ          ณ parametros informados.   				  	              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MSRORCGF(lAuto,cNum)

	Local lReg				:= .F. 	&& Verifica a exist๊ncia de Registros
	Local nLastKey			:= 0
	Local titulo   			:= "Relat๓rio de Or็amento"
	Local cMens 			:= "Nใo hแ registros para os parametros informados !!"
	Local nCount			:= 0
	Local cPerg				:= "PERORC"

	Default lAuto := .F.
	Default cNum  := ""

	Private cOrc 	   		:= ""
	Private cEmissao		:= ""
	Private nQtdPag		:= 0
	Private oFont1 		:= TFont():New("Arial",09,14,		,.T.,,,,,.F.) &&Parametros TFonte ("Tipo Fonte", ,Tamanho Fonte , , ,Italico (.T./.F.))
	Private oFont2  		:= TFont():New("Arial",07,08,		,.F.,,,,,.F.) && Normal
	Private oFont3  		:= TFont():New("Arial",09,10,.T.	,.T.,,,,,.F.) && Negrito
	Private oFont4  		:= TFont():New("Arial",09,14,.T.	,.T.,,,,,.T.) && Negrito - Sublinhado
	Private oFont5  		:= TFont():New("Arial",09,10,   	,.F.,,,,,.F.) && Negrito
	Private oPrint


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

	&& Query que retorna os dados do orcamento e os dados dos itens.
	cQuery := "SELECT "
	cQuery += "		SCJ.CJ_NUM, SCJ.CJ_EMISSAO, SCJ.CJ_CONDPAG, SCJ.CJ_DESC1, SCJ.CJ_DESC2, SCJ.CJ_DESC3, SCJ.CJ_FRETE, SCJ.CJ_DESPESA, "
	cQuery += "		SCJ.CJ_DESC4, SCJ.CJ_DATA1, SCJ.CJ_DATA2, SCJ.CJ_DATA3, SCJ.CJ_DATA4, SCJ.CJ_PARC1, SCJ.CJ_PARC2,SCJ.CJ_COTCLI,CJ_ZZNIVEL, "
	cQuery += "		SCJ.CJ_PARC3, SCJ.CJ_PARC4, SCJ.CJ_CLIENTE, SCJ.CJ_LOJA, SCJ.CJ_VALIDA, SCJ.CJ_ZZTRANS,SCJ.CJ_VEND,SCJ.CJ_ZZOBS,SE4.E4_DESCRI, "
	cQuery += "		SCK.CK_ITEM, SCK.CK_NUM, SCK.CK_PRODUTO, SCK.CK_DESCRI, SCK.CK_UM, SCK.CK_TES,CK_ZZPRCD,CK_ZZPRCF,CK_PRUNIT, "
	cQuery += "		SCK.CK_QTDVEN, SCK.CK_PRCVEN, SCK.CK_VALOR,SCK.CK_OBS, SB1.B1_IPI, "
	cQuery += "		SA1.A1_COD,	SA1.A1_NOME, SA1.A1_EMAIL, SA1.A1_END, SA1.A1_MUN, SA1.A1_EST, SA1.A1_DDD, SA1.A1_TEL, SA1.A1_FAX, SA1.A1_CEP, SA1.A1_BAIRRO, SA1.A1_CONTATO, SA1.A1_HPAGE, SA1.A1_CGC, SA1.A1_INSCR, "
	cQuery += "		SA3.A3_NOME,"
	cQuery += "		SA4.A4_NOME "
	cQuery += "FROM " + RetSqlName("SCJ") + " AS SCJ "
	cQuery += "		INNER JOIN " + RetSqlName("SCK") + " AS SCK ON "
	cQuery += "			SCK.CK_FILIAL = '" + xFilial("SCK")+ "' AND SCJ.CJ_NUM = SCK.CK_NUM AND SCK.D_E_L_E_T_ = ' ' "
	cQuery += "		INNER JOIN " + RetSqlName("SA1") + " AS SA1 ON "
	cQuery += "				SA1.A1_FILIAL = '" + xFilial("SA1")+ "' AND SCJ.CJ_CLIENTE = SA1.A1_COD AND SCJ.CJ_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += "		LEFT JOIN " + RetSqlName("SE4") + " AS SE4 ON "
	cQuery += "				SE4.E4_FILIAL = '" + xFilial("SE4")+ "' AND SCJ.CJ_CONDPAG = SE4.E4_CODIGO AND SE4.D_E_L_E_T_ = ' ' "
	cQuery += "		LEFT JOIN " + RetSqlName("SB1") + " AS SB1 ON "
	cQuery += "				SB1.B1_FILIAL = '" + xFilial("SB1")+ "' AND SCK.CK_PRODUTO = SB1.B1_COD AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += "		LEFT JOIN " + RetSqlName("SA3") + " AS SA3 ON "
	cQuery += "				SA3.A3_FILIAL = '" + xFilial("SA3")+ "' AND SA3.A3_COD = SCJ.CJ_VEND AND SA3.D_E_L_E_T_ = ' ' "
	cQuery += "		LEFT JOIN " + RetSqlName("SA4") + " AS SA4 ON "
	cQuery += "				SA4.A4_FILIAL = '" + xFilial("SA4")+ "' AND SA4.A4_COD = SCJ.CJ_ZZTRANS AND SA4.D_E_L_E_T_ = ' ' "
	cQuery += "WHERE SCJ.CJ_FILIAL = '" + xFilial("SCJ")+ "' AND SCJ.D_E_L_E_T_ = ' ' AND SCJ.CJ_NUM >= '"+ mv_par01 +"' AND SCJ.CJ_NUM <= '"+ mv_par02 +"' "
	If !Empty(mv_par03) .AND. !Empty(mv_par04)
		cQuery += " AND CJ_EMISSAO BETWEEN '" + DtoS(mv_par03) + "' AND '" + DtoS(mv_par04) + "' "
	EndIf
	cQuery += "ORDER BY SCJ.CJ_NUM, SCK.CK_ITEM "

	TCQUERY cQuery NEW ALIAS "cAlias"

	Count to nCount

	cAlias->(dbgotop())

	While cAlias->(!Eof())

		cOrc 		:= cAlias->CJ_NUM
		TCSETFIELD("cAlias","CJ_EMISSAO","D")
		TCSETFIELD("cAlias","CJ_VALIDA","D")
		cEMISSAO 	:= cAlias->CJ_EMISSAO
		lReg 		:= .T.

		&& Query que retorna a Quantidade Total de itens em um orcamento
		cQuery := "SELECT COUNT(CK_ITEM) AS Total "
		cQuery += " FROM " + RetSqlName("SCK")
		cQuery += " WHERE CK_NUM = '" + cAlias->CJ_NUM + "'"
		cQuery += " AND CK_FILIAL = '" + xFilial("SCK")+ "'
		cQuery += " AND D_E_L_E_T_ = ' '"

		TCQUERY cQuery NEW ALIAS "cCount"

		&& Atribui a Quantidade Total de itens na Variavel nCount
		nCount := cCount->Total

		&& Controla a Quantidade de Paginas no Relatorio
		nQtdPag := STR((cCount->Total / 30)+ 1)
		nQtdPag := LEFT(nQtdPag, AT(".",nQtdPag)-1)

		cCount->(dbCloseArea())

		&&Inicia uma Nova Pagina para Impressao
		oPrint:StartPage()

		&&Define o modo de Impressao como Retrato
		oPrint:SetPortrait()  &&SetLandscape -> Para definir como modo Paisagem

		IMPCAB(cOrc, cEMISSAO)	&&Funcao para impressao do Cabecalho
		IMPCLI()	&&Funcao para impressao dos dados do Cliente
		IMPPRO(cOrc,nCount,nQtdPag)	&&Funcao para impressao dos Detalhes do Produto

	End

	cAlias->(dbCloseArea())

	If lReg = .F.
		MsgSTOP(cMens)
	Else
		&&ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		&&ณ MsDialog oDlg: exibi as opcoes para tratativa do relatorio.      ณ
		&&ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		Define MsDialog oDlg Title "relat๓rio de Or็amento" From 0, 0 To 090, 430 Pixel
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
Static Function IMPCAB(cOrc, cEMISSAO)

	Local nTopo			:= 0000  && Controle de Linhas
	Local nInicio		:= 0000  && Indica a posi็ใo da primeira coluna
	Local cEmail 		:= GetMV("ZZ_OREMAIL")
	Local cLogo		:= GetSrvProfString("Startpath","") + "\lgrl" + cFilAnt + ".BMP"


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
	oPrint:SayBitmap(nTopo + 0050, nInicio + 0040,cLogo, 700, 220)
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
	oPrint:Line(nTopo + 0350, nInicio + 0040,nTopo + 0350, nInicio + 2360)
	oPrint:Line(nTopo + 0353, nInicio + 0040,nTopo + 0353, nInicio + 2360)
	oPrint:Line(nTopo + 0450, nInicio + 0040,nTopo + 0450, nInicio + 2360)
	oPrint:Line(nTopo + 0453, nInicio + 0040,nTopo + 0453, nInicio + 2360)

	oPrint:Say(nTopo + 0385	, nInicio + 0040, "Or็amento Nฐ " + cOrc		,oFont1,100,,,0)
	oPrint:Say(nTopo + 0385	, nInicio + 2360,"Data: " + DTOC(cEMISSAO)			,oFont1,100,,,1)

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
	If LEN(ALLTRIM(cAlias->A1_CGC)) > 11
		oPrint:Say(nTopo + 0680	, nInicio + 0040, "CNPJ"  		,oFont3,100,,,0)
	ELSE
		oPrint:Say(nTopo + 0680	, nInicio + 0040, "CPF"  		,oFont3,100,,,0)
	ENDIF
	&&Texto Centralizado
	oPrint:Say(nTopo + 0430	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Site" 			,oFont3,100,,,0)
	oPrint:Say(nTopo + 0480	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Contato" 			,oFont3,100,,,0)
	oPrint:Say(nTopo + 0530	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Bairro" 			,oFont3,100,,,0)
	oPrint:Say(nTopo + 0580	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"CEP" 				,oFont3,100,,,0)
	oPrint:Say(nTopo + 0630	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"FAX"				,oFont3,100,,,0)
	oPrint:Say(nTopo + 0680	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"I.E."				,oFont3,100,,,0)

	&& Texto a Esquerda
	oPrint:Say(nTopo + 0430	, nInicio + 0190, " : " + cAlias->A1_COD + " - " + cAlias->A1_NOME		,oFont5,100,,,0)
	oPrint:Say(nTopo + 0480	, nInicio + 0190, " : " + cAlias->A1_EMAIL		,oFont5,100,,,0)
	oPrint:Say(nTopo + 0530	, nInicio + 0190, " : " + cAlias->A1_END			,oFont5,100,,,0)
	oPrint:Say(nTopo + 0580	, nInicio + 0190, " : " + AllTrim(cAlias->A1_MUN)+"/"+cAlias->A1_EST	,oFont5,100,,,0)
	oPrint:Say(nTopo + 0630	, nInicio + 0190, " : (" + cAlias->A1_DDD + ") " + LEFT(cAlias->A1_TEL,4) + "-" + SUBSTR(cAlias->A1_TEL,5,8)	 	,oFont5,100,,,0)

	If LEN(ALLTRIM(cAlias->A1_CGC)) > 11
		oPrint:Say(nTopo + 0680	, nInicio + 0190, " : " + AllTrim(Transform(cAlias->A1_CGC,"@R 99.999.999/9999-99"))	,oFont5,100,,,0)
	eLSE
		oPrint:Say(nTopo + 0680	, nInicio + 0190, " : " + AllTrim(Transform(cAlias->A1_CGC,"@R 999.999.999-99"))	,oFont5,100,,,0)
	ENDIF
	&&Texto Centralizado
	oPrint:Say(nTopo + 0430	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150," : " + cAlias->A1_HPAGE										,oFont5,100,,,0)
	oPrint:Say(nTopo + 0480	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150," : " + cAlias->A1_CONTATO										,oFont5,100,,,0)
	oPrint:Say(nTopo + 0530	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150," : " + cAlias->A1_BAIRRO										,oFont5,100,,,0)
	oPrint:Say(nTopo + 0580	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150," : " + LEFT(cAlias->A1_CEP,5) + "-" + RIGHT(cAlias->A1_CEP,3)	,oFont5,100,,,0)
	oPrint:Say(nTopo + 0630	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150," : (" + cAlias->A1_DDD + ") " + LEFT(cAlias->A1_FAX,4) + "-" + SUBSTR(cAlias->A1_FAX,5,8)	,oFont5,100,,,0)
	If LEN(ALLTRIM(cAlias->A1_INSCR)) > 6
		oPrint:Say(nTopo + 0680	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150," : " + AllTrim(Transform(cAlias->A1_INSCR,"@R 999.999.999.999")) ,oFont5,100,,,0)
	Else
		oPrint:Say(nTopo + 0680	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150," : " + AllTrim(cAlias->A1_INSCR) ,oFont5,100,,,0)
	EndIf

	Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณ IMPPRO   บ Autor ณHermes Vieira Jr.	   บ Data ณ  27/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao dos Dados de Detalhes dos Produtos.		  		บฑฑ
ฑฑบ		     ณ Parametros: cOrc - Numero do Pedido de Compra Corrente.		บฑฑ
ฑฑบ          ณ 			   nCount - Quantidade Total de Itens. 		  		บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function IMPPRO(cOrc, nCount, nQtdPag)
	Local nTopo          := 0800  && Controle de Linhas
	Local nInicio	       := 0000  && Indica a posi็ใo da primeira coluna
	Local nTotal	       := 0000  && Controle do Valor Total do Pedido
	Local nTotal2	       := 0000  && Controle do Valor Total do Pedido
	Local nFrete         := 0000  && Controle do Valor Total do Pedido
	Local nDespesa       := 0000  && Controle do Valor Total do Pedido
	Local nVTIpi	       := 0000  && Controle do Valor Total do Pedido com IPI
	Local nPag		       := 1
	Local nCont          := 1
	Local nContP	       := 0
	Local nTamDes	       := 0
	Local nTamStr	       := 0
	Local nItem          := 0
	Private nVlrTotal    := 0
	Private nVlrSol      := 0
	Private nTpag	       := 0
	Private nBasIPI      := 0
	Private nAlqIPI      := 0
	Private nValIPI      := 0
	Private nBasICM      := 0
	Private nAlqICM      := 0
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

	&&ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	&&ณ Box, Linhas Verticais e Dados do Cabecalho de Pedido.                                        ณ
	&&ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	&& Box
	oPrint:Box(nTopo, nInicio + 0040, nTopo + 0050, nInicio + 2360)

	&&Linhas Verticais
	oPrint:Line(nTopo,nInicio + 0180,nTopo + 0050,nInicio + 0180)
	oPrint:Line(nTopo,nInicio + 0400,nTopo + 0050,nInicio + 0400)
	oPrint:Line(nTopo,nInicio + 1200,nTopo + 0050,nInicio + 1200)
	oPrint:Line(nTopo,nInicio + 1290,nTopo + 0050,nInicio + 1290)
	oPrint:Line(nTopo,nInicio + 1450,nTopo + 0050,nInicio + 1450)
	oPrint:Line(nTopo,nInicio + 1750,nTopo + 0050,nInicio + 1750)
	oPrint:Line(nTopo,nInicio + 2050,nTopo + 0050,nInicio + 2050)
	oPrint:Line(nTopo,nInicio + 2220,nTopo + 0050,nInicio + 2220)
	&& Texto
	oPrint:Say(nTopo + 0007,nInicio + 0060,"Item"				   		,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 0200,"Produto"					,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 0420,"Descri็ใo do Componente"	,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 1220,"UM"							,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 1310,"Qtd."						,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 1470,"Pre็o Unitแrio"				,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 1770,"Pre็o Total"				,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 2070,"IPI"	   					,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 2240,"ICMS"	   					,oFont3,100,,,0)

	cNivel := Alltrim(cAlias->CJ_ZZNIVEL)

	While cAlias->(!Eof()) .AND. cAlias->CJ_NUM == cOrc
		nItem++

		IF cNivel == '1'
			nPrcLista := cAlias->CK_PRCVEN
			nValMerc  := cAlias->CK_QTDVEN * cAlias->CK_PRCVEN
		ElseIf cNivel == '2' .Or. cNivel == '3'
			nPrcLista := cAlias->CK_ZZPRCD
			nValMerc  := cAlias->CK_QTDVEN * cAlias->CK_ZZPRCD
		ElseIf cNivel == '4' .Or. cNivel == '6'
			nPrcLista := cAlias->CK_ZZPRCF
			nValMerc  := cAlias->CK_QTDVEN * cAlias->CK_ZZPRCF
		ElseIf cNivel == '8'
			nPrcLista := cAlias->CK_ZZPRCF
			nValMerc  := cAlias->CK_QTDVEN * cAlias->CK_ZZPRCF
		EndIF

		&&ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		&&ณ Testa se o limite da pagina para a impressao dos produtos.                                   ณ
		&&ณ Caso ultrapasse o limite gera uma Nova Pagina                              					 ณ
		&&ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If (nTopo + 0130) >= 2550

			&&LInhas Horizontais  -  FIM PEDIDO
			oPrint:Line(nTopo + 0040,nInicio + 0040,nTopo + 0040,nInicio + 2360)

			IMPROD(NPag, nTotal, nTopo)

			&&Inicia uma Nova Pagina para Impressao
			oPrint:StartPage()

			&&Define o modo de Impressใo como Retrato
			oPrint:SetPortrait()   &&SetLandscape -> Para definir como modo Paisagem

			&&Funcao para impressao do Cabecalho
			IMPCAB(cOrc, cEMISSAO)

			&& Incrementa o contador de Paginas
			nPag := nPag + 1

			nTopo := 0450

			&&ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			&&ณ Box, Linhas Verticais e Dados do Cabecalho de Pedido.                                        ณ
			&&ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			&& Box
			oPrint:Box(nTopo, nInicio + 0040, nTopo + 0050, nInicio + 2360)

			&&Linhas Verticais
			oPrint:Line(nTopo,nInicio + 0180,nTopo + 0050,nInicio + 0180)
			oPrint:Line(nTopo,nInicio + 0400,nTopo + 0050,nInicio + 0400)
			oPrint:Line(nTopo,nInicio + 1200,nTopo + 0050,nInicio + 1200)
			oPrint:Line(nTopo,nInicio + 1290,nTopo + 0050,nInicio + 1290)
			oPrint:Line(nTopo,nInicio + 1450,nTopo + 0050,nInicio + 1450)
			oPrint:Line(nTopo,nInicio + 1750,nTopo + 0050,nInicio + 1750)
			oPrint:Line(nTopo,nInicio + 2050,nTopo + 0050,nInicio + 2050)
			oPrint:Line(nTopo,nInicio + 2220,nTopo + 0050,nInicio + 2220)

			&& Texto
			oPrint:Say(nTopo + 0007,nInicio + 0060,"Item"				   		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 0200,"Produto"					,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 0420,"Descri็ใo do Componente"	,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 1220,"UM"							,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 1310,"Qtd."						,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 1470,"Pre็o Unitแrio"				,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 1770,"Pre็o Total"				,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 2070,"IPI"	   					,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 2240,"ICMS"	   					,oFont3,100,,,0)

		EndIF

		&&ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		&&ณ Box, Linhas Verticais, Linhas Horizontais e Dados do Pedido.                                  ณ
		&&ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		nTamDes := LEN(ALLTRIM(cAlias->CK_DESCRI)) / 30

		If nTamDes > 2

			&&Linhas Verticais - Divisao Colunas
			oPrint:Line(nTopo + 0030,nInicio + 0040,nTopo + 0090,nInicio + 0040)
			oPrint:Line(nTopo + 0030,nInicio + 2360,nTopo + 0090,nInicio + 2360)

			oPrint:Line(nTopo + 0030,nInicio + 0180,nTopo + 0090,nInicio + 0180)
			oPrint:Line(nTopo + 0030,nInicio + 0400,nTopo + 0090,nInicio + 0400)
			oPrint:Line(nTopo + 0030,nInicio + 1200,nTopo + 0090,nInicio + 1200)
			oPrint:Line(nTopo + 0030,nInicio + 1290,nTopo + 0090,nInicio + 1290)
			oPrint:Line(nTopo + 0030,nInicio + 1450,nTopo + 0090,nInicio + 1450)
			oPrint:Line(nTopo + 0030,nInicio + 1750,nTopo + 0090,nInicio + 1750)
			oPrint:Line(nTopo + 0030,nInicio + 2050,nTopo + 0090,nInicio + 2050)
			oPrint:Line(nTopo + 0030,nInicio + 2220,nTopo + 0090,nInicio + 2220)

			&& Impressao dos Campos dos Detalhes dos Produtos
			oPrint:Say(nTopo + 0057, nInicio + 0060, Ltrim(cAlias->CK_ITEM)		   		,oFont2,100,,,0)

			oPrint:Say(nTopo + 0057, nInicio + 0200, Alltrim(cAlias->CK_PRODUTO) ,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057, nInicio + 0500, SUBSTR(Ltrim(cAlias->CK_DESCRI),1,30)		   		,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057, nInicio + 1100, LTrim(cAlias->CK_UM)					,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057, nInicio + 1300, Alltrim(STR(cAlias->CK_QTDVEN))		,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057, nInicio + 1600, Alltrim(Transform(nPrcLista, PesqPict('SCK', 'CK_PRCVEN')))		,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057, nInicio + 1900, Alltrim(Transform(nValMerc, PesqPict('SCK', 'CK_VALOR')))		,oFont2,100,,,1)

			aRet:= {}
			aRet:= CalcImp()

			dbSelectArea("SF4")
			dbSetOrder(1)
			dbSeek(xFilial("SF4") + cAlias->CK_TES)
			If SF4->F4_IPI == "S"
				oPrint:Say(nTopo + 0057, nInicio + 2188, Alltrim(STR(aRet[2],4,1))		,oFont2,100,,,1)
			Else
				oPrint:Say(nTopo + 0057, nInicio + 2188, "0.0"		,oFont2,100,,,1)
			EndIf
			If SF4->F4_ICM == "S"
				oPrint:Say(nTopo + 0057, nInicio + 2338, Alltrim(STR(aRet[6],4,1)) 	 	,oFont2,100,,,1)
			Else
				oPrint:Say(nTopo + 0057, nInicio + 2338, "0.0"		,oFont2,100,,,1)
			EndIf
			SF4->(dbCloseArea())

			nTamStr := 31

			For nCon := 2 to Int(nTamDes) + 1

				nTopo := nTopo + 0050

				&&ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				&&ณ Testa se o limite da pagina para a impressao dos produtos.                                   ณ
				&&ณ Caso ultrapasse o limite gera uma Nova Pagina                              					 ณ
				&&ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If (nTopo + 0130) >= 2550

					&&LInhas Horizontais  -  FIM PEDIDO
					oPrint:Line(nTopo + 0040,nInicio + 0040,nTopo + 0040,nInicio + 2360)

					IMPROD(NPag, nTotal, nTopo)

					&&Inicia uma Nova Pagina para Impressao
					oPrint:StartPage()

					&&Define o modo de Impressใo como Retrato
					oPrint:SetPortrait()   &&SetLandscape -> Para definir como modo Paisagem

					&&Funcao para impressao do Cabecalho
					IMPCAB(cOrc, cEMISSAO)

					&& Incrementa o contador de Paginas
					nPag := nPag + 1

					nTopo := 0450

					&&ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					&&ณ Box, Linhas Verticais e Dados do Cabecalho de Pedido.                                        ณ
					&&ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					&& Box
					oPrint:Box(nTopo, nInicio + 0040, nTopo + 0050, nInicio + 2360)

					&&Linhas Verticais
					oPrint:Line(nTopo,nInicio + 0180,nTopo + 0050,nInicio + 0180)
					oPrint:Line(nTopo,nInicio + 0400,nTopo + 0050,nInicio + 0400)
					oPrint:Line(nTopo,nInicio + 1200,nTopo + 0050,nInicio + 1200)
					oPrint:Line(nTopo,nInicio + 1290,nTopo + 0050,nInicio + 1290)
					oPrint:Line(nTopo,nInicio + 1450,nTopo + 0050,nInicio + 1450)
					oPrint:Line(nTopo,nInicio + 1750,nTopo + 0050,nInicio + 1750)
					oPrint:Line(nTopo,nInicio + 2050,nTopo + 0050,nInicio + 2050)
					oPrint:Line(nTopo,nInicio + 2220,nTopo + 0050,nInicio + 2220)
					&& Texto
					oPrint:Say(nTopo + 0007,nInicio + 0060,"Item"				   		,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 0200,"Produto"					,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 0420,"Descri็ใo do Componente"	,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1220,"UM"							,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1310,"Qtd."						,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1470,"Pre็o Unitแrio"				,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1770,"Pre็o Total"				,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 2070,"IPI"	   					,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 2240,"ICMS"	   					,oFont3,100,,,0)
				EndIF

				&&Linhas Verticais - Divisao Colunas
				oPrint:Line(nTopo + 0030,nInicio + 0040,nTopo + 0090,nInicio + 0040)
				oPrint:Line(nTopo + 0030,nInicio + 2360,nTopo + 0090,nInicio + 2360)

				oPrint:Line(nTopo + 0030,nInicio + 0180,nTopo + 0090,nInicio + 0180)
				oPrint:Line(nTopo + 0030,nInicio + 0400,nTopo + 0090,nInicio + 0400)
				oPrint:Line(nTopo + 0030,nInicio + 1200,nTopo + 0090,nInicio + 1200)
				oPrint:Line(nTopo + 0030,nInicio + 1290,nTopo + 0090,nInicio + 1290)
				oPrint:Line(nTopo + 0030,nInicio + 1450,nTopo + 0090,nInicio + 1450)
				oPrint:Line(nTopo + 0030,nInicio + 1750,nTopo + 0090,nInicio + 1750)
				oPrint:Line(nTopo + 0030,nInicio + 2050,nTopo + 0090,nInicio + 2050)
				oPrint:Line(nTopo + 0030,nInicio + 2220,nTopo + 0090,nInicio + 2220)

				oPrint:Say(nTopo + 0057, nInicio + 0600, Substr(Ltrim(cAlias->CK_DESCRI),nTamStr,28)		,oFont2,100,,,0)

				nTamStr := nTamStr + 30

			Next

		Else

			&&Linhas Verticais - Divisao Colunas
			oPrint:Line(nTopo + 0030,nInicio + 0040,nTopo + 0090,nInicio + 0040)
			oPrint:Line(nTopo + 0030,nInicio + 2360,nTopo + 0090,nInicio + 2360)

			oPrint:Line(nTopo + 0030,nInicio + 0180,nTopo + 0090,nInicio + 0180)
			oPrint:Line(nTopo + 0030,nInicio + 0400,nTopo + 0090,nInicio + 0400)
			oPrint:Line(nTopo + 0030,nInicio + 1200,nTopo + 0090,nInicio + 1200)
			oPrint:Line(nTopo + 0030,nInicio + 1290,nTopo + 0090,nInicio + 1290)
			oPrint:Line(nTopo + 0030,nInicio + 1450,nTopo + 0090,nInicio + 1450)
			oPrint:Line(nTopo + 0030,nInicio + 1750,nTopo + 0090,nInicio + 1750)
			oPrint:Line(nTopo + 0030,nInicio + 2050,nTopo + 0090,nInicio + 2050)
			oPrint:Line(nTopo + 0030,nInicio + 2220,nTopo + 0090,nInicio + 2220)

			&& Impressao dos Campos dos Detalhes dos Produtos
			oPrint:Say(nTopo + 0057, nInicio + 0060, Ltrim(cAlias->CK_ITEM)		   		,oFont2,100,,,0)

			oPrint:Say(nTopo + 0057, nInicio + 0200, Alltrim(cAlias->CK_PRODUTO) ,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057, nInicio + 0420, Ltrim(cAlias->CK_DESCRI)		   		,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057, nInicio + 1220, LTrim(cAlias->CK_UM)					,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057, nInicio + 1430, Alltrim(STR(cAlias->CK_QTDVEN))		,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057, nInicio + 1740, Alltrim(Transform(nPrcLista, PesqPict('SCK', 'CK_PRCVEN')))		,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057, nInicio + 2040, Alltrim(Transform(nValMerc, PesqPict('SCK', 'CK_VALOR')))		,oFont2,100,,,1)

			aRet:= {}
			aRet:= CalcImp()

			dbSelectArea("SF4")
			dbSetOrder(1)
			dbSeek(xFilial("SF4") + cAlias->CK_TES)
			If SF4->F4_IPI == "S"
				oPrint:Say(nTopo + 0057, nInicio + 2188, Alltrim(STR(aRet[2],4,1))		,oFont2,100,,,1)
			Else
				oPrint:Say(nTopo + 0057, nInicio + 2188, "0.0"		,oFont2,100,,,1)
			EndIf
			If SF4->F4_ICM == "S"
				oPrint:Say(nTopo + 0057, nInicio + 2338, Alltrim(STR(aRet[6],4,1)) 	 	,oFont2,100,,,1)
			Else
				oPrint:Say(nTopo + 0057, nInicio + 2338, "0.0"		,oFont2,100,,,1)
			EndIf
			SF4->(dbCloseArea())


		Endif

		&& Calculo do Valor Total do Pedido de Compra
		nTotal += cAlias->CK_VALOR

		&&Calcula o Valor Total do Pedido de Compra com IPI
		&&nVTIpi += (((cAlias->C6_VALOR * cAlias->B1_IPI)/100) + cAlias->C6_VALOR)

		nTopo := nTopo + 0050

		&& IMPRESSรO DA OBSERVAวรO DO PEDIDO

		nTamDes := LEN(ALLTRIM(cAlias->CK_OBS)) / 30


		If nTamDes > 2
			&&ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			&&ณ Testa se o limite da pagina para a impressao dos produtos.                                   ณ
			&&ณ Caso ultrapasse o limite gera uma Nova Pagina                              					 ณ
			&&ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If (nTopo + 0130) >= 2550

				&&LInhas Horizontais  -  FIM PEDIDO
				oPrint:Line(nTopo + 0040,nInicio + 0040,nTopo + 0040,nInicio + 2360)

				IMPROD(NPag, nTotal, nTopo)

				&&Inicia uma Nova Pagina para Impressao
				oPrint:StartPage()

				&&Define o modo de Impressใo como Retrato
				oPrint:SetPortrait()   &&SetLandscape -> Para definir como modo Paisagem

				&&Funcao para impressao do Cabecalho
				IMPCAB(cOrc, cEMISSAO)

				&& Incrementa o contador de Paginas
				nPag := nPag + 1

				nTopo := 0450

				&&ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				&&ณ Box, Linhas Verticais e Dados do Cabecalho de Pedido.                                        ณ
				&&ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				&& Box
				oPrint:Box(nTopo, nInicio + 0040, nTopo + 0050, nInicio + 2360)

				&&Linhas Verticais
				oPrint:Line(nTopo,nInicio + 0180,nTopo + 0050,nInicio + 0180)
				oPrint:Line(nTopo,nInicio + 0400,nTopo + 0050,nInicio + 0400)
				oPrint:Line(nTopo,nInicio + 1200,nTopo + 0050,nInicio + 1200)
				oPrint:Line(nTopo,nInicio + 1290,nTopo + 0050,nInicio + 1290)
				oPrint:Line(nTopo,nInicio + 1450,nTopo + 0050,nInicio + 1450)
				oPrint:Line(nTopo,nInicio + 1750,nTopo + 0050,nInicio + 1750)
				oPrint:Line(nTopo,nInicio + 2050,nTopo + 0050,nInicio + 2050)
				oPrint:Line(nTopo,nInicio + 2220,nTopo + 0050,nInicio + 2220)
				&& Texto
				oPrint:Say(nTopo + 0007,nInicio + 0060,"Item"				   		,oFont3,100,,,0)
				oPrint:Say(nTopo + 0007,nInicio + 0200,"Produto"					,oFont3,100,,,0)
				oPrint:Say(nTopo + 0007,nInicio + 0420,"Descri็ใo do Componente"	,oFont3,100,,,0)
				oPrint:Say(nTopo + 0007,nInicio + 1220,"UM"							,oFont3,100,,,0)
				oPrint:Say(nTopo + 0007,nInicio + 1310,"Qtd."						,oFont3,100,,,0)
				oPrint:Say(nTopo + 0007,nInicio + 1470,"Pre็o Unitแrio"				,oFont3,100,,,0)
				oPrint:Say(nTopo + 0007,nInicio + 1770,"Pre็o Total"				,oFont3,100,,,0)
				oPrint:Say(nTopo + 0007,nInicio + 2070,"IPI"	   					,oFont3,100,,,0)
				oPrint:Say(nTopo + 0007,nInicio + 2240,"ICMS"	   					,oFont3,100,,,0)
			EndIF

			&&Linhas Verticais - Divisao Colunas
			oPrint:Line(nTopo + 0030,nInicio + 0040,nTopo + 0090,nInicio + 0040)
			oPrint:Line(nTopo + 0030,nInicio + 2360,nTopo + 0090,nInicio + 2360)

			oPrint:Line(nTopo + 0030,nInicio + 0180,nTopo + 0090,nInicio + 0180)
			oPrint:Line(nTopo + 0030,nInicio + 0400,nTopo + 0090,nInicio + 0400)
			oPrint:Line(nTopo + 0030,nInicio + 1200,nTopo + 0090,nInicio + 1200)
			oPrint:Line(nTopo + 0030,nInicio + 1290,nTopo + 0090,nInicio + 1290)
			oPrint:Line(nTopo + 0030,nInicio + 1450,nTopo + 0090,nInicio + 1450)
			oPrint:Line(nTopo + 0030,nInicio + 1750,nTopo + 0090,nInicio + 1750)
			oPrint:Line(nTopo + 0030,nInicio + 2050,nTopo + 0090,nInicio + 2050)
			oPrint:Line(nTopo + 0030,nInicio + 2220,nTopo + 0090,nInicio + 2220)

			&& Impressao dos Campos dos Detalhes dos Produtos
			oPrint:Say(nTopo + 0057, nInicio + 0600, SUBSTR(Ltrim(cAlias->CK_OBS),1,30)		   		,oFont2,100,,,0)

			nTamStr := 31

			For nCon := 2 to Int(nTamDes) + 1

				nTopo := nTopo + 0050

				&&ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				&&ณ Testa se o limite da pagina para a impressao dos produtos.                                   ณ
				&&ณ Caso ultrapasse o limite gera uma Nova Pagina                              					 ณ
				&&ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If (nTopo + 0130) >= 2550

					&&LInhas Horizontais  -  FIM PEDIDO
					oPrint:Line(nTopo + 0040,nInicio + 0040,nTopo + 0040,nInicio + 2360)

					IMPROD(NPag, nTotal, nTopo)

					&&Inicia uma Nova Pagina para Impressao
					oPrint:StartPage()

					&&Define o modo de Impressใo como Retrato
					oPrint:SetPortrait()   &&SetLandscape -> Para definir como modo Paisagem

					&&Funcao para impressao do Cabecalho
					IMPCAB(cOrc, cEMISSAO)

					&& Incrementa o contador de Paginas
					nPag := nPag + 1

					nTopo := 0450

					&&ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					&&ณ Box, Linhas Verticais e Dados do Cabecalho de Pedido.                                        ณ
					&&ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					&& Box
					oPrint:Box(nTopo, nInicio + 0040, nTopo + 0050, nInicio + 2360)

					&&Linhas Verticais
					oPrint:Line(nTopo,nInicio + 0180,nTopo + 0050,nInicio + 0180)
					oPrint:Line(nTopo,nInicio + 0400,nTopo + 0050,nInicio + 0400)
					oPrint:Line(nTopo,nInicio + 1200,nTopo + 0050,nInicio + 1200)
					oPrint:Line(nTopo,nInicio + 1290,nTopo + 0050,nInicio + 1290)
					oPrint:Line(nTopo,nInicio + 1450,nTopo + 0050,nInicio + 1450)
					oPrint:Line(nTopo,nInicio + 1750,nTopo + 0050,nInicio + 1750)
					oPrint:Line(nTopo,nInicio + 2050,nTopo + 0050,nInicio + 2050)
					oPrint:Line(nTopo,nInicio + 2220,nTopo + 0050,nInicio + 2220)
					&& Texto
					oPrint:Say(nTopo + 0007,nInicio + 0060,"Item"				   		,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 0200,"Produto"					,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 0420,"Descri็ใo do Componente"	,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1220,"UM"							,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1310,"Qtd."						,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1470,"Pre็o Unitแrio"				,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1770,"Pre็o Total"				,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 2070,"IPI"	   					,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 2240,"ICMS"	   					,oFont3,100,,,0)
				EndIF

				&&Linhas Verticais - Divisao Colunas
				oPrint:Line(nTopo + 0030,nInicio + 0040,nTopo + 0090,nInicio + 0040)
				oPrint:Line(nTopo + 0030,nInicio + 2360,nTopo + 0090,nInicio + 2360)

				oPrint:Line(nTopo + 0030,nInicio + 0180,nTopo + 0090,nInicio + 0180)
				oPrint:Line(nTopo + 0030,nInicio + 0400,nTopo + 0090,nInicio + 0400)
				oPrint:Line(nTopo + 0030,nInicio + 1200,nTopo + 0090,nInicio + 1200)
				oPrint:Line(nTopo + 0030,nInicio + 1290,nTopo + 0090,nInicio + 1290)
				oPrint:Line(nTopo + 0030,nInicio + 1450,nTopo + 0090,nInicio + 1450)
				oPrint:Line(nTopo + 0030,nInicio + 1750,nTopo + 0090,nInicio + 1750)
				oPrint:Line(nTopo + 0030,nInicio + 2050,nTopo + 0090,nInicio + 2050)
				oPrint:Line(nTopo + 0030,nInicio + 2220,nTopo + 0090,nInicio + 2220)

				oPrint:Say(nTopo + 0057, nInicio + 0600, Substr(Ltrim(cAlias->CK_OBS),nTamStr,30)		,oFont2,100,,,0)

				nTamStr := nTamStr + 30

			Next

			nTopo := nTopo + 0050

		EndIf

		&&Incrementa Contador da Quantidade de Itens no Pedido de Compra
		nCont ++

		&&Se o arquivo chegou ao fim, imprime rodape.
		If nCont > nCount

			nTotal := nTotal + cAlias->CJ_FRETE + cAlias->CJ_DESPESA

			&&Box e Dados - Despesas

			oPrint:Box(nTopo + 0060, nInicio + 0470, nTopo + 0160, nInicio + 0940)
			oPrint:Line(nTopo + 0060, nInicio + 0770,nTopo + 0160,nInicio + 0770)

			oPrint:Line(nTopo + 0110, nInicio + 0470,nTopo + 0110,nInicio + 0940)

			oPrint:Say(nTopo + 0067, nInicio + 0490, "Valor Frete"		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0067, nInicio + 0910, "R$ " + Alltrim(Transform(aRet[12], PesqPict('SCJ', 'CJ_FRETE')))	,oFont3,100,,,1)

			oPrint:Say(nTopo + 0117, nInicio + 0490, "Valor Despesa"		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0117, nInicio + 0910, "R$ " + Alltrim(Transform(aRet[13], PesqPict('SCJ', 'CJ_DESPESA')))	,oFont3,100,,,1)

			&&Box e Dados - Despesas

			oPrint:Box(nTopo + 0060, nInicio + 0950, nTopo + 0160, nInicio + 1420)
			oPrint:Line(nTopo + 0060, nInicio + 1170,nTopo + 0160,nInicio + 1170)

			oPrint:Line(nTopo + 0110, nInicio + 0950,nTopo + 0110,nInicio + 1420)

			oPrint:Say(nTopo + 0067, nInicio + 0970, "Total Merc."		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0067, nInicio + 1390, "R$ " + Alltrim(Transform(aRet[16], PesqPict('SCK', 'CK_VALOR')))	,oFont3,100,,,1)

			oPrint:Say(nTopo + 0117, nInicio + 0970, "Qtd Pe็as "		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0117, nInicio + 1390, Alltrim(Transform(QtdItem, PesqPict('SCK', 'CK_QTDVEN')))	,oFont3,100,,,1)


			&&Box e Dados - Impostos

			oPrint:Box(nTopo + 0060, nInicio + 1430, nTopo + 0160, nInicio + 1890)
			oPrint:Line(nTopo + 0060, nInicio + 1700,nTopo + 0160,nInicio + 1700)

			oPrint:Line(nTopo + 0110, nInicio + 1430,nTopo + 0110,nInicio + 1890)

			oPrint:Say(nTopo + 0067, nInicio + 1450, "Valor IPI"		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0067, nInicio + 1870, "R$ " + Alltrim(Transform(aRet[9], PesqPict('SCK', 'CK_VALOR')))	,oFont3,100,,,1)

			oPrint:Say(nTopo + 0117, nInicio + 1450, "Valor ICMS"		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0117, nInicio + 1870, "R$ " + Alltrim(Transform(aRet[10], PesqPict('SCK', 'CK_VALOR')))	,oFont3,100,,,1)


			&&Box e Dados - Valor Total
			oPrint:Box(nTopo + 0060, nInicio + 1900, nTopo + 0160, nInicio + 2360)
			oPrint:Line(nTopo + 0060, nInicio + 2120,nTopo + 0160,nInicio + 2120)

			oPrint:Line(nTopo + 0110, nInicio + 1900,nTopo + 0110,nInicio + 2360)


			oPrint:Say(nTopo + 0067, nInicio + 1920, "Valor ST"		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0067, nInicio + 2340, "R$ " + Alltrim(Transform(aRet[11], PesqPict('SCK', 'CK_VALOR')))	,oFont3,100,,,1)

			oPrint:Say(nTopo + 0117, nInicio + 1920, "Valor Total"		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0117, nInicio + 2340, "R$ " + Alltrim(Transform(aRet[15], PesqPict('SCK', 'CK_VALOR')))	,oFont3,100,,,1)


			&&	oPrint:Box(nTopo + 0120, nInicio + 1600, nTopo + 0170, nInicio + 2200)
			&&	oPrint:Line(nTopo + 0120, nInicio + 1900,nTopo + 0170,nInicio + 1900)

			&&	oPrint:Say(nTopo + 0127, nInicio + 1615, "Valor Total c/ IPI"		,oFont3,100,,,0)
			&&	oPrint:Say(nTopo + 0127, nInicio + 2190, "R$ " + Alltrim(Transform(nVTIpi,"@E 9,999,999.99"))	,oFont3,100,,,1)

			&&LInhas Horizontais  -  FIM PEDIDO
			oPrint:Line(nTopo + 0040,nInicio + 0040,nTopo + 0040,nInicio + 2360)


			&&Imprime o Numero de Paginas
			oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0150, nInicio + 2360,"Pแgina: " + str(nPag) + " / " + AllTrim(nQtdPag)  ,oFont3,100,,,1)

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
		oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0650, nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 0290, nInicio + 2360)

		&& Titulo Centralizado
		oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0630, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Informa็๕es Gerais"		,oFont1,100,,,2)

		&& Textos Posicionados เ Esquerda
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0550, nInicio + 0060,"Forma de Pagamento"  									,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0550, nInicio + 0450,": " + cAlias->CJ_CONDPAG + " - " + cAlias->E4_DESCRI	,oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0500, nInicio + 0060,"Transportadora" 				 			   						,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0500, nInicio + 0450,": (" + cAlias->CJ_ZZTRANS + ") " + cAlias->A4_NOME			,oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0450, nInicio + 0060,"Nบ do Or็amento Cliente" 				 				,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0450, nInicio + 0450,": " + cAlias->CJ_COTCLI								,oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0400, nInicio + 0060,"Classifica็ใo Emb. " 				 				   		,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0400, nInicio + 0450,": " + AllTrim(cAlias->CJ_ZZNIVEL)	,oFont5,100,,,0)

		&& Textos Posicionados เ Esquerda
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0550, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Validade" 				 				   						,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0550, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0250,": " + DTOC(cAlias->CJ_VALIDA) 					   			,oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0450, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Vendedor" 					 	   		,oFont3,100)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0450, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0250,": (" + cAlias->CJ_VEND + ") " + cAlias->A3_NOME 		   	,oFont5,100)

		&& Box para a Mensagem da Nota
		oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0270, nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 0170, nInicio + 2360)
		oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0260, nInicio + 0060,"Obs" 			   							,oFont3,100,,,0)
		oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0260, nInicio + 0200,".: " + SUBSTR(cAlias->CJ_ZZOBS,1,100) 		,oFont5,100,,,0)
		oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0210, nInicio + 0200,Space(03) + SUBSTR(cAlias->CJ_ZZOBS,101,100) 		,oFont5,100,,,0)

		&&Imprime o Numero de Paginas
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0150, nInicio + 2360,"Pแgina: " + str(nPag) + " / " + AllTrim(nQtdPag)   ,oFont3,100,,,1)

		oPrint:EndPage()

	Else

		&&Encerra a Pagina Atual
		oPrint:EndPage()

		&&Inicia uma Nova Pagina para Impressao
		oPrint:StartPage()

		&&Define o modo de Impressใo como Retrato
		oPrint:SetPortrait()  &&SetLandscape -> Para definir como modo Paisagem

		&&Funcao para impressao do Cabecalho
		IMPCAB(cOrc, cEMISSAO)
		nTopo := 0420

		NPag += 1

		&& Box Condicoes Gerais
		oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0650, nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 0290, nInicio + 2360)

		&& Titulo Centralizado
		oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0630, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Informa็๕es Gerais"		,oFont1,100,,,2)

		&& Textos Posicionados เ Esquerda
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0550, nInicio + 0060,"Forma de Pagamento"  									,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0550, nInicio + 0450,": " + cAlias->CJ_CONDPAG + " - " + cAlias->E4_DESCRI	,oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0500, nInicio + 0060,"Transportadora" 				 			   						,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0500, nInicio + 0450,": (" + cAlias->CJ_ZZTRANS + ") " + cAlias->A4_NOME				,oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0450, nInicio + 0060,"Nบ Or็amento Cliente" 				 				,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0450, nInicio + 0450,": " + cAlias->CJ_COTCLI								,oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0400, nInicio + 0060,"Descontos % " 				 				   		,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0400, nInicio + 0450,": " + AllTrim(STR(cAlias->CJ_DESC1, 10, 2)) + " + " + AllTrim(STR(cAlias->CJ_DESC2, 10, 2)) + " + " + AllTrim(STR(cAlias->CJ_DESC3, 10, 2)) + " + " + AllTrim(STR(cAlias->CJ_DESC4, 10, 2)) 	,oFont5,100,,,0)

		&& Textos Posicionados เ Esquerda
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0550, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Validade" 				 				   						,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0550, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0250,": " + DTOC(cAlias->CJ_VALIDA) 					   			,oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0450, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Vendedor" 					 	   		,oFont3,100)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0450, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0250,": (" + cAlias->CJ_VEND + ") " + cAlias->A3_NOME 		   	,oFont5,100)

		&& Box para a Mensagem da Nota
		oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0270, nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 0170, nInicio + 2360)
		oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0260, nInicio + 0060,"Obs" 			   							,oFont3,100,,,0)
		oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0260, nInicio + 0200,".: " + TRANSFORM(cAlias->CJ_ZZOBS,'@!S100') 		,oFont5,100,,,0)

		&&Imprime o Numero de Paginas
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0150, nInicio + 2360,"Pแgina: " + str(nPag) + " / " + AllTrim(nQtdPag)   ,oFont3,100,,,1)

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
	Local cTipoCli        := ""
	Local cTipoNF         := "N"
	Local nVlrTotItem     := cAlias->CK_VALOR
	Local nQuant         := cAlias->CK_QTDVEN
	Local nVlUnit         := cAlias->CK_PRCVEN

	&&ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	&&| Verifico o tipo da nota para efetuar o calculo                                          |
	&&ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If cTipoNF $ "DB"
		cTipoCli := IIf( Empty( cTipoCli ), SA2->A2_TIPO, cTipoCli )
		MaFisIni(SA2->A2_COD,SA2->A2_LOJA,"F",cTipoNF,cTipoCli,,,.F.,"SB1")
	Else
		cTipoCli := IIf( Empty( cTipoCli ), POSICIONE("SA1",1,xFilial("SA1") + cAlias->CJ_CLIENTE + cAlias->CJ_LOJA,"A1_TIPO"), cTipoCli )
		MaFisIni(cAlias->CJ_CLIENTE, cAlias->CJ_LOJA, "C", "S", cTipoCli,,, .F., "SB1")
	EndIf

//MaFisAdd(cAlias->CK_PRODUTO, cAlias->CK_TES, nQuant,nVlUnit, 0, "", "",, 0, 0, 0, 0, nVlrTotItem, 0, 0, 0)
	MaFisAdd(    cAlias->CK_PRODUTO                    ,;           // 1-Codigo do Produto ( Obrigatorio )
	cAlias->CK_TES                        ,;          // 2-Codigo do TES ( Opcional )
	cAlias->CK_QTDVEN                    ,;          // 3-Quantidade ( Obrigatorio )
	nPrcLista                    ,;          // 4-Preco Unitario ( Obrigatorio )
	0                                ,;           // 5-Valor do Desconto ( Opcional )
	""                                ,;          // 6-Numero da NF Original ( Devolucao/Benef )
	""                                ,;          // 7-Serie da NF Original ( Devolucao/Benef )
	""                                ,;          // 8-RecNo da NF Original no arq SD1/SD2
	0                                ,;          // 9-Valor do Frete do Item ( Opcional )
	0                                ,;          // 10-Valor da Despesa do item ( Opcional )
	0                                ,;        // 11-Valor do Seguro do item ( Opcional )
	0                                ,;          // 12-Valor do Frete Autonomo ( Opcional )
	(nPrcLista*cAlias->CK_QTDVEN)    ,;          // 13-Valor da Mercadoria ( Obrigatorio )
	0                                ,;          // 14-Valor da Embalagem ( Opiconal )
	0                                ,;          // 15-RecNo do SB1
	0                                )           // 16-RecNo do SF4

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


	nVlrSol += ntotSol
	nVlrTotal += ntotGer

	MaFisEnd()
	QtdItem += cAlias->CK_QTDVEN
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
	aAdd(aRegs, {cPerg, "01", "Or็amento de "        			,"" ,"" ,"mv_ch1", "C", 06, 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SCJ"})
	aAdd(aRegs, {cPerg, "02", "Or็amento at้ "        			,"" ,"" ,"mv_ch2", "C", 06, 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SCJ"})
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


	IF(SF4->F4_DUPLIC$"S".AND.!SD1->D1_CF$"1556 ,2556 ".AND.!SF4->F4_CODIGO$"045,044,056",SD1->(D1_CUSTO-D1_ICMSCOM),;
			IF(SF4->F4_CODIGO$"045,044,056",SD1->(D1_TOTAL+D1_VALIPI+D1_SEGURO+D1_VALFRE),;
			IF(SD1->D1_CF$"1556 ,2556 ",SD1->(D1_CUSTO+D1_VALIPI+D1_SEGURO+D1_VALFRE),0)))
