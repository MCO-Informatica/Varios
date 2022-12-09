#include "protheus.ch"
#include "colors.ch"
#Include "Font.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MSRCOMGF	ºAutor  ³Hermes Vieira Jr    º Data ³  27/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime relatorio de Pedido de Compra de acordo com os     º±±
±±º          ³ parametros informados.   					              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MSRCOMGF(lAuto,cPedNum)

	Local lReg				:= .F. 	&& Verifica a existência de Registros
	Local nLastKey			:= 0
	Local titulo   			:= "Pedido de Compra"
	Local cMens 			:= "Não há registros para os parametros informados !!"
	Local nCount			:= 0
	Local cPerg				:= "ALRCOM"
	Private cNPc 	   		:= ""
	Private cEmail 	   		:= ""
	Private cEmissao		:= ""
	Private nQtdPag			:= 0
	Private oFont1 			:= TFont():New("Arial",09,14,		,.T.,,,,,.F.) &&Parametros TFonte ("Tipo Fonte", ,Tamanho Fonte , , ,Italico (.T./.F.))
	Private oFont2  		:= TFont():New("Arial",07,08,		,.F.,,,,,.F.) && Normal
	Private oFont3  		:= TFont():New("Arial",09,10,.T.	,.T.,,,,,.F.) && Negrito
	Private oFont4  		:= TFont():New("Arial",09,14,.T.	,.T.,,,,,.T.) && Negrito - Sublinhado
	Private oFont5  		:= TFont():New("Arial",09,10,   	,.F.,,,,,.F.) && Negrito
	Private oPrint


	&& Instânciação do Objeto OPrint
	oPrint := TMSPrinter():New()
	oPrint:SetPortrait()   && Define como Paisagem
	oPrint:SetPage(9)       && Define papel A4

	&& Faz a chamada do grupo de perguntas, caso a chamada seja feita a partir do menu
	If !lAuto
		ValidPerg(cPerg)
		If !(Pergunte(cPerg,.T.))
			Return
		Endif
	Endif

	If lastKey() == 27 .or. nLastKey == 27 .or. nLastKey == 286
		return
	Endif

	&& Query que retorna os dados do pedido de compra e os dados dos itens.
	cQuery := "SELECT "
	cQuery += 	 "C7_EMISSAO,C7_NUM,C7_DATPRF,C7_ITEM,C7_PRODUTO,C7_DESCRI,C7_UM,C7_QUANT,C7_IPI,C7_PRECO,C7_TOTAL,"
	cQuery += 	 "C7_VALIPI,C7_VALFRE,C7_SEGURO,C7_VALICM,C7_DESPESA,C7_VLDESC,C7_TPFRETE,C7_CC,C7_OBS,C7_CONAPRO,C7_USER,C7_IPI,"
	cQuery += 	 "C7_MSG,C7_DESC1,C7_DESC2,C7_DESC3,C7_COND,C7_VALFRE,C7_ZZVALID, C7_TES, C7_ZZTRANS,C7_FILENT, "
	cQuery += 	 "A2_COD,A2_LOJA, A2_HPAGE, A2_NOME,A2_END,A2_CEP,A2_DDD,A2_TEL,A2_FAX,A2_EMAIL,A2_CGC,A2_INSCR,A2_MUN, A2_EST,A2_CONTATO, A2_BAIRRO,"
	cQuery +=    "E4_DESCRI,"
	cQuery +=    "CTT_DESC01,"
	&&cQuery +=    "AL_NOME, "
	cQuery +=    "A4_NOME "
	cQuery += "FROM "
	cQuery +=    RetSqlName("SC7") + " AS SC7 "
	cQuery += "INNER JOIN "
	cQuery +=    RetSqlName("SA2") + " AS SA2 ON A2_FILIAL = '" + xFilial("SA2") + "' AND C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ = ' ' "
	cQuery += "LEFT JOIN "
	cQuery +=    RetSqlName("SA4") + " AS SA4 ON A4_FILIAL = '" + xFilial("SA4") + "' AND C7_ZZTRANS = A4_COD AND SA4.D_E_L_E_T_ = ' ' "
	cQuery += "LEFT JOIN "
	cQuery +=    RetSqlName("SE4") + " AS SE4 ON E4_FILIAL = '" + xFilial("SE4") + "' AND C7_COND = E4_CODIGO AND SE4.D_E_L_E_T_ = ' ' "
	cQuery += "LEFT JOIN "
	cQuery +=    RetSqlName("CTT") + " AS CTT ON CTT_FILIAL = '" + xFilial("CTT") + "' AND C7_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ' ' "
	&&cQuery += "LEFT JOIN "
	&&cQuery +=    RetSqlName("SAL") + " AS SAL ON AL_FILIAL = '" + xFilial("SAL") + "' AND C7_APROV = AL_COD AND SAL.D_E_L_E_T_ = ' ' "
	cQuery += "WHERE "
	cQuery +=    "C7_FILIAL = '" + xFilial("SC7") + "' "
	If !lAuto
		cQuery +=    "AND C7_NUM BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
		If !Empty(mv_par03) .AND. !Empty(mv_par04)
			cQuery +=    "AND C7_EMISSAO BETWEEN '" + DtoS(mv_par03) + "' AND '" + DtoS(mv_par04) + "' "
		EndIf
		cQuery +=    "AND C7_PRODUTO BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' "
	Else
		cQuery +=    "AND C7_NUM = '" + cPedNum + "' "
	Endif
	cQuery +=    "AND SC7.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY C7_NUM, C7_ITEM "

	TCQUERY cQuery NEW ALIAS "cAlias"

	TCSETFIELD("cAlias","C7_EMISSAO","D",08,00)
	TCSETFIELD("cAlias","C7_DATPRF","D",08,00)
	TCSETFIELD("cAlias","C7_ZZVALID","D",08,00)

	Count to nCount

	cAlias->(dbgotop())

	While cAlias->(!Eof())

		cNPc := cAlias->C7_NUM
		TCSETFIELD("cAlias","C7_EMISSAO","D")
		cEmissao := cAlias->C7_EMISSAO
		lReg := .T.

		&& Query que retorna a Quantidade Total de itens do Pedido de Compra
		cQuery := "SELECT COUNT(C7_ITEM) AS Total "
		cQuery += " FROM " + RetSqlName("SC7")
		cQuery += " WHERE C7_NUM = '" + cAlias->C7_NUM + "' AND D_E_L_E_T_ = ' '"

		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "cCount", .T., .T. )

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

		IMPCAB(cNPc, cEMISSAO)	&&Funcao para impressao do Cabecalho
		IMPCLI()	&&Funcao para impressao dos dados do Cliente
		IMPPRO(cNPc,nCount,nQtdPag)	&&Funcao para impressao dos Detalhes do Produto

		cAlias->(dbSkip())

	End

	cAlias->(dbCloseArea())

	If lReg = .F.
		MsgSTOP(cMens)
	Else
		&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		&&³ MsDialog oDlg: exibi as opcoes para tratativa do relatorio.      ³
		&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		Define MsDialog oDlg Title "Pedido de Compra" From 0, 0 To 090, 430 Pixel
		Define Font oBold Name "Arial" Size 0, -13 Bold
		@ 000, 000 Bitmap oBmp ResName "LOGIN" Of oDlg Size 30, 120 NoBorder When .F. Pixel
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³ IMPCAB   º Autor ³Hermes Vieira Jr.	   º Data ³  27/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao do cabecalho do relatorio.	  						º±±
±±º          ³ Informacao: Cabecalho - Dados da Empresa;					º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IMPCAB(cNPc, cEMISSAO)

	Local nTopo	  := 0000  && Controle de Linhas
	Local nInicio := 0000  && Indica a posição da primeira coluna
	Local cEmail  := UsrRetMail(oApp:cUserId)//GetMV("ZZ_SCEMAIL")
	Local cLogo	  := GetSrvProfString("Startpath","") + "\Logo\lgrl" + cFilAnt + ".BMP"
	Local cLogoD  := GetSrvProfString("Startpath","") + "\Logo\lgrl" + cFilAnt + ".BMP"

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³Retorna o tamanho Horizontal e Vertical da pagina.                                          ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nVertSize := oPrint:nVertSize()
	nHorzSize := oPrint:nHorzSize()

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³Impressao do cabeçalho do Relatorio.															³
	&&³Obs.: O Logo pode ser colocado na pasta System do Protheus, no caso só referencia o nome.    ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	&& oPrint:SayBitmap(Coluna, Linha, Caminho, Largura, Altura)
	oPrint:SayBitmap(nTopo + 0050, nInicio + 0040,cLogo, 314, 235)

	dbSelectArea("SM0")
	SM0->(dbseek(cEmPant + cFilant))

	&& oPrint:Say(Coluna, Linha, Texto, Fonte, Num de Caracteres, , ,Alinhamento - 0=Left, 1=Right e 2=Center)
	oPrint:Say(nTopo + 0050, nInicio + 2360,RTrim(SM0->M0_NOMECOM)												   		,oFont1,100,,,1)
	oPrint:Say(nTopo + 0100, nInicio + 2360, AllTrim(SM0->M0_ENDENT) + " " + AllTrim(SM0->M0_CIDENT) + "/" + AllTrim(SM0->M0_ESTENT) + " " + LEFT(AllTrim(SM0->M0_CEPENT),5) + "-" + RIGHT(AllTrim(SM0->M0_CEPENT),3)		,oFont5,100,,,1)
	oPrint:Say(nTopo + 0150, nInicio + 2360, "E-mail: " + Alltrim(cEmail)								   			,oFont3,100,,,1)&&							   			,oFont3,100,,,1)
	oPrint:Say(nTopo + 0200, nInicio + 2360, "Fone: " + AllTrim(SM0->M0_TEL) + " FAX: " + AllTrim(SM0->M0_FAX)	   		,oFont5,100,,,1)
	oPrint:Say(nTopo + 0250, nInicio + 2360, "CNPJ: " + AllTrim(Transform(SM0->M0_CGC, "@R 99.999.999/9999-99")) + " - IE: " +  AllTrim(Transform(SM0->M0_INSC, "@R 999.999.999.999"))	,oFont5,100,,,1)

	&& oPrint:Line(Coluna, Linha, Coluna, Linha)
	oPrint:Line(nTopo + 0310, nInicio + 0040,nTopo + 0310, nInicio + 2360)
	oPrint:Line(nTopo + 0313, nInicio + 0040,nTopo + 0313, nInicio + 2360)
	oPrint:Line(nTopo + 0410, nInicio + 0040,nTopo + 0410, nInicio + 2360)
	oPrint:Line(nTopo + 0413, nInicio + 0040,nTopo + 0413, nInicio + 2360)

	oPrint:Say(nTopo + 0335	, nInicio + 0040, "Pedido de Compra N° " + cNPc		,oFont1,100,,,0)
	oPrint:Say(nTopo + 0335	, nInicio + 2360,"Data: " + DTOC(cEMISSAO)			,oFont1,100,,,1)

	Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³ IMPCLI   º Autor ³Hermes Vieira Jr.	   º Data ³  27/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao dos Dados do Cliente.								º±±
±±º          ³ Informacoes: Nome, E-mail, Endereco, Cidade, CEP, Tel, FAX,	º±±
±±º			 ³				Contato e Bairro.								º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function IMPCLI()
	Local nTopo			:= 0000  && Controle de Linhas
	Local nInicio		:= 0000  && Indica a posicao da primeira coluna

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Impressão da Estrutura dos Dados do Cliente.                                                 ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	&& Texto a Esquerda
	oPrint:Say(nTopo + 0430	, nInicio + 0040, "Fornecedor" 	,oFont3,100,,,0)
	oPrint:Say(nTopo + 0480	, nInicio + 0040, "E-mail"		,oFont3,100,,,0)
	oPrint:Say(nTopo + 0530	, nInicio + 0040, "Endereço"	,oFont3,100,,,0)
	oPrint:Say(nTopo + 0580	, nInicio + 0040, "Cidade"	  	,oFont3,100,,,0)
	oPrint:Say(nTopo + 0630	, nInicio + 0040, "TEL"  		,oFont3,100,,,0)
	If LEN(ALLTRIM(cAlias->A2_CGC)) > 11
		oPrint:Say(nTopo + 0680	, nInicio + 0040, "CNPJ"  		,oFont3,100,,,0)
	Else
		oPrint:Say(nTopo + 0680	, nInicio + 0040, "CPF"  		,oFont3,100,,,0)
	EndIF
	oPrint:Say(nTopo + 0730	, nInicio + 0040, "Site"  		,oFont3,100,,,0)

	&&Texto Centralizado
	oPrint:Say(nTopo + 0480	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Contato" 			,oFont3,100,,,0)
	oPrint:Say(nTopo + 0530	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Bairro" 			,oFont3,100,,,0)
	oPrint:Say(nTopo + 0580	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"CEP" 				,oFont3,100,,,0)
	oPrint:Say(nTopo + 0630	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"FAX"				,oFont3,100,,,0)
	oPrint:Say(nTopo + 0680	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"IE"				,oFont3,100,,,0)

	&& Texto a Esquerda
	oPrint:Say(nTopo + 0430	, nInicio + 0240, ": " + cAlias->A2_COD + " - " + cAlias->A2_NOME		,oFont5,100,,,0)
	oPrint:Say(nTopo + 0480	, nInicio + 0240, ": " + cAlias->A2_EMAIL		,oFont5,100,,,0)
	oPrint:Say(nTopo + 0530	, nInicio + 0240, ": " + cAlias->A2_END			,oFont5,100,,,0)
	oPrint:Say(nTopo + 0580	, nInicio + 0240, ": " + AllTrim(cAlias->A2_MUN)+"/"+cAlias->A2_EST	   		,oFont5,100,,,0)
	oPrint:Say(nTopo + 0630	, nInicio + 0240, ": (" + cAlias->A2_DDD + ") " + LEFT(cAlias->A2_TEL,4) + "-" + SUBSTR(cAlias->A2_TEL,5,8)	 	,oFont5,100,,,0)
	If LEN(ALLTRIM(cAlias->A2_CGC)) > 11
		oPrint:Say(nTopo + 0680	, nInicio + 0240, ": " + AllTrim(Transform(cAlias->A2_CGC,"@R 99.999.999/9999-99")) ,oFont5,100,,,0)
	Else
		oPrint:Say(nTopo + 0680	, nInicio + 0240, ": " + AllTrim(Transform(cAlias->A2_CGC,"@R 999.999.999-99")) ,oFont5,100,,,0)
	EndIf
	oPrint:Say(nTopo + 0730	, nInicio + 0240, ": " + cAlias->A2_HPAGE ,oFont5,100,,,0)

	&&Texto Centralizado
	oPrint:Say(nTopo + 0480	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + cAlias->A2_CONTATO										,oFont5,100,,,0)
	oPrint:Say(nTopo + 0530	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + cAlias->A2_BAIRRO										,oFont5,100,,,0)
	oPrint:Say(nTopo + 0580	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + LEFT(cAlias->A2_CEP,5) + "-" + RIGHT(cAlias->A2_CEP,3)	,oFont5,100,,,0)
	oPrint:Say(nTopo + 0630	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": (" + cAlias->A2_DDD + ") " + LEFT(cAlias->A2_FAX,4) + "-" + SUBSTR(cAlias->A2_FAX,5,8)	,oFont5,100,,,0)
	If LEN(ALLTRIM(cAlias->A2_INSCR)) > 6
		oPrint:Say(nTopo + 0680	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150, ": " + AllTrim(Transform(cAlias->A2_INSCR,"@R 999.999.999.999")) ,oFont5,100,,,0)
	Else
		oPrint:Say(nTopo + 0680	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150, ": " + AllTrim(cAlias->A2_INSCR) ,oFont5,100,,,0)
	EndiF
	Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³ IMPPRO   º Autor ³Hermes Vieira Jr.	   º Data ³  27/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao dos Dados de Detalhes dos Produtos.		  		º±±
±±º		     ³ Parametros: cNPc - Numero do Pedido de Compra Corrente.		º±±
±±º          ³ 			   nCount - Quantidade Total de Itens. 		  		º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function IMPPRO(cNPc, nCount, nQtdPag)
	Local nTopo		 := 0800  && Controle de Linhas
	Local nInicio	 := 0000  && Indica a posição da primeira coluna
	Local nTotal	 := 0000  && Controle do Valor Total do Pedido
	Local nVTIpi	 := 0000  && Controle do Valor Total do Pedido com IPI
	Local nPag		 := 1
	Local nCont		 := 1
	Local nContP	 := 0
	Local nTotal2	 := 0
	Local nDespesa   := 0
	Local nFrete     := 0
	Local nTamDes	 := 0
	Local nTamStr	 :=0
	Local nCon		 := 0

	Private nTpag		 := 0
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
	Private nDescZF := 0

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Box, Linhas Verticais e Dados do Cabecalho de Pedido.                                        ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	&& Box
	oPrint:Box(nTopo, nInicio + 0040, nTopo + 0050, nInicio + 2360)

	&&Linhas Verticais
	oPrint:Line(nTopo,nInicio + 0180,nTopo + 0050,nInicio + 0180)
	oPrint:Line(nTopo,nInicio + 0480,nTopo + 0050,nInicio + 0480)
	oPrint:Line(nTopo,nInicio + 1080,nTopo + 0050,nInicio + 1080)
	oPrint:Line(nTopo,nInicio + 1180,nTopo + 0050,nInicio + 1180)
	oPrint:Line(nTopo,nInicio + 1320,nTopo + 0050,nInicio + 1320)
	oPrint:Line(nTopo,nInicio + 1620,nTopo + 0050,nInicio + 1620)
	oPrint:Line(nTopo,nInicio + 1920,nTopo + 0050,nInicio + 1920)
	oPrint:Line(nTopo,nInicio + 2050,nTopo + 0050,nInicio + 2050)

	&& Texto
	oPrint:Say(nTopo + 0007,nInicio + 0060,"Item"				   		,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 0200,"Produto"					,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 0500,"Descrição do Produto"		,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 1100,"UM"							,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 1200,"Qtd."						,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 1340,"Prc Unit."					,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 1640,"Prc Total"					,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 1940,"IPI"	  					,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 2070,"Data Entrega"				,oFont3,100,,,0)

	While cAlias->(!Eof()) .AND. cAlias->C7_NUM == cNPc

		&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		&&³ Testa se o limite da pagina para a impressao dos produtos.                                   ³
		&&³ Caso ultrapasse o limite gera uma Nova Pagina                              					 ³
		&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (nTopo + 0130) >= 2550

			&&	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0150, nInicio + 2360,"Página: " + STR(nPag) + " / " + AllTrim(nQtdPag)		,oFont3,100,,,1)

			IMPROD(NPag, nTotal, nTopo)

			&&Inicia uma Nova Pagina para Impressao
			oPrint:StartPage()

			&&Define o modo de Impressão como Retrato
			oPrint:SetPortrait()   &&SetLandscape -> Para definir como modo Paisagem

			&&Funcao para impressao do Cabecalho
			IMPCAB(cNPc, cEMISSAO)

			&& Incrementa o contador de Paginas
			nPag := nPag + 1

			nTopo := 0450

			&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			&&³ Box, Linhas Verticais e Dados do Cabecalho de Pedido.                                        ³
			&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			&& Box
			oPrint:Box(nTopo, nInicio + 0040, nTopo + 0050, nInicio + 2360)

			&&Linhas Verticais
			oPrint:Line(nTopo,nInicio + 0180,nTopo + 0050,nInicio + 0180)
			oPrint:Line(nTopo,nInicio + 0480,nTopo + 0050,nInicio + 0480)
			oPrint:Line(nTopo,nInicio + 1080,nTopo + 0050,nInicio + 1080)
			oPrint:Line(nTopo,nInicio + 1180,nTopo + 0050,nInicio + 1180)
			oPrint:Line(nTopo,nInicio + 1320,nTopo + 0050,nInicio + 1320)
			oPrint:Line(nTopo,nInicio + 1620,nTopo + 0050,nInicio + 1620)
			oPrint:Line(nTopo,nInicio + 1920,nTopo + 0050,nInicio + 1920)
			oPrint:Line(nTopo,nInicio + 2050,nTopo + 0050,nInicio + 2050)

			&& Texto
			oPrint:Say(nTopo + 0007,nInicio + 0060,"Item"				   		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 0200,"Produto"					,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 0500,"Descrição do Produto"		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 1100,"UM"							,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 1200,"Qtd."						,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 1340,"Prc Unit."					,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 1640,"Prc Total"					,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 1940,"IPI"	  					,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 2070,"Data Entrega"			   	,oFont3,100,,,0)

		EndIF

		&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		&&³ Box, Linhas Verticais, Linhas Horizontais e Dados do Pedido.                                  ³
		&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		nTamDes := LEN(ALLTRIM(cAlias->C7_DESCRI)) / 30

		If nTamDes > 2

			&&Linhas Verticais - Divisao Colunas
			oPrint:Line(nTopo + 0030,nInicio + 0040,nTopo + 0090,nInicio + 0040)
			oPrint:Line(nTopo + 0030,nInicio + 2360,nTopo + 0090,nInicio + 2360)

			oPrint:Line(nTopo + 0030,nInicio + 0180,nTopo + 0090,nInicio + 0180)
			oPrint:Line(nTopo + 0030,nInicio + 0480,nTopo + 0090,nInicio + 0480)
			oPrint:Line(nTopo + 0030,nInicio + 1080,nTopo + 0090,nInicio + 1080)
			oPrint:Line(nTopo + 0030,nInicio + 1180,nTopo + 0090,nInicio + 1180)
			oPrint:Line(nTopo + 0030,nInicio + 1320,nTopo + 0090,nInicio + 1320)
			oPrint:Line(nTopo + 0030,nInicio + 1620,nTopo + 0090,nInicio + 1620)
			oPrint:Line(nTopo + 0030,nInicio + 1920,nTopo + 0090,nInicio + 1920)
			oPrint:Line(nTopo + 0030,nInicio + 2050,nTopo + 0090,nInicio + 2050)

			TCSETFIELD("cAlias","C7_DATPRF","D")

			&& Impressao dos Campos dos Detalhes dos Produtos
			oPrint:Say(nTopo + 0057, nInicio + 0060, Ltrim(cAlias->C7_ITEM)		,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057, nInicio + 0200, Ltrim(cAlias->C7_PRODUTO)		,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057, nInicio + 0500, SubStr(Ltrim(cAlias->C7_DESCRI),1,30)		,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057, nInicio + 1100, LTrim(cAlias->C7_UM)			,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057, nInicio + 1300, Alltrim(STR(cAlias->C7_QUANT))  								,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057, nInicio + 1600, Alltrim(Transform(cAlias->C7_PRECO, PesqPict('SC7', 'C7_PRECO')))		,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057, nInicio + 1900, Alltrim(Transform(cAlias->C7_TOTAL, PesqPict('SC7', 'C7_TOTAL')))		,oFont2,100,,,1)

			aRet:= {}
			aRet:= CalcImp()

			oPrint:Say(nTopo + 0057, nInicio + 2030, Alltrim(STR(aRet[2],4,1))								,oFont2,100,,,1)

			oPrint:Say(nTopo + 0057, nInicio + 2070, DTOC(cAlias->C7_DATPRF)		,oFont2,100,,,0)

			nTamStr := 31

			For nCon := 2 to Int(nTamDes) + 1

				nTopo := nTopo + 0050

				&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				&&³ Testa se o limite da pagina para a impressao dos produtos.                                   ³
				&&³ Caso ultrapasse o limite gera uma Nova Pagina                              					 ³
				&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If (nTopo + 0130) >= 2550

					&&	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0150, nInicio + 2360,"Página: " + STR(nPag) + " / " + AllTrim(nQtdPag)		,oFont3,100,,,1)

					IMPROD(NPag, nTotal, nTopo)

					&&Inicia uma Nova Pagina para Impressao
					oPrint:StartPage()

					&&Define o modo de Impressão como Retrato
					oPrint:SetPortrait()   &&SetLandscape -> Para definir como modo Paisagem

					&&Funcao para impressao do Cabecalho
					IMPCAB(cNPc, cEMISSAO)

					&& Incrementa o contador de Paginas
					nPag := nPag + 1

					nTopo := 0450

					&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					&&³ Box, Linhas Verticais e Dados do Cabecalho de Pedido.                                        ³
					&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					&& Box
					oPrint:Box(nTopo, nInicio + 0040, nTopo + 0050, nInicio + 2360)

					&&Linhas Verticais
					oPrint:Line(nTopo,nInicio + 0180,nTopo + 0050,nInicio + 0180)
					oPrint:Line(nTopo,nInicio + 0480,nTopo + 0050,nInicio + 0480)
					oPrint:Line(nTopo,nInicio + 1080,nTopo + 0050,nInicio + 1080)
					oPrint:Line(nTopo,nInicio + 1180,nTopo + 0050,nInicio + 1180)
					oPrint:Line(nTopo,nInicio + 1320,nTopo + 0050,nInicio + 1320)
					oPrint:Line(nTopo,nInicio + 1620,nTopo + 0050,nInicio + 1620)
					oPrint:Line(nTopo,nInicio + 1920,nTopo + 0050,nInicio + 1920)
					oPrint:Line(nTopo,nInicio + 2050,nTopo + 0050,nInicio + 2050)

					&& Texto
					oPrint:Say(nTopo + 0007,nInicio + 0060,"Item"				   		,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 0200,"Produto"					,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 0500,"Descrição do Produto"		,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1100,"UM"							,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1200,"Qtd."						,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1340,"Prc Unit."					,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1640,"Prc Total"					,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1940,"IPI"	  					,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 2070,"Data Entrega"			   	,oFont3,100,,,0)

				EndIF


				&&Linhas Verticais - Divisao Colunas
				oPrint:Line(nTopo + 0030,nInicio + 0040,nTopo + 0090,nInicio + 0040)
				oPrint:Line(nTopo + 0030,nInicio + 2360,nTopo + 0090,nInicio + 2360)

				oPrint:Line(nTopo + 0030,nInicio + 0180,nTopo + 0090,nInicio + 0180)
				oPrint:Line(nTopo + 0030,nInicio + 0480,nTopo + 0090,nInicio + 0480)
				oPrint:Line(nTopo + 0030,nInicio + 1080,nTopo + 0090,nInicio + 1080)
				oPrint:Line(nTopo + 0030,nInicio + 1180,nTopo + 0090,nInicio + 1180)
				oPrint:Line(nTopo + 0030,nInicio + 1320,nTopo + 0090,nInicio + 1320)
				oPrint:Line(nTopo + 0030,nInicio + 1620,nTopo + 0090,nInicio + 1620)
				oPrint:Line(nTopo + 0030,nInicio + 1920,nTopo + 0090,nInicio + 1920)
				oPrint:Line(nTopo + 0030,nInicio + 2050,nTopo + 0090,nInicio + 2050)


				oPrint:Say(nTopo + 0057, nInicio + 0500, Substr(Ltrim(cAlias->C7_DESCRI),nTamStr,30)		,oFont2,100,,,0)

				nTamStr := nTamStr + 30
			Next

		Else

			&&Linhas Verticais - Divisao Colunas
			oPrint:Line(nTopo + 0030,nInicio + 0040,nTopo + 0090,nInicio + 0040)
			oPrint:Line(nTopo + 0030,nInicio + 2360,nTopo + 0090,nInicio + 2360)

			oPrint:Line(nTopo + 0030,nInicio + 0180,nTopo + 0090,nInicio + 0180)
			oPrint:Line(nTopo + 0030,nInicio + 0480,nTopo + 0090,nInicio + 0480)
			oPrint:Line(nTopo + 0030,nInicio + 1080,nTopo + 0090,nInicio + 1080)
			oPrint:Line(nTopo + 0030,nInicio + 1180,nTopo + 0090,nInicio + 1180)
			oPrint:Line(nTopo + 0030,nInicio + 1320,nTopo + 0090,nInicio + 1320)
			oPrint:Line(nTopo + 0030,nInicio + 1620,nTopo + 0090,nInicio + 1620)
			oPrint:Line(nTopo + 0030,nInicio + 1920,nTopo + 0090,nInicio + 1920)
			oPrint:Line(nTopo + 0030,nInicio + 2050,nTopo + 0090,nInicio + 2050)

			TCSETFIELD("cAlias","C7_DATPRF","D")

			&& Impressao dos Campos dos Detalhes dos Produtos
			oPrint:Say(nTopo + 0057, nInicio + 0060, Ltrim(cAlias->C7_ITEM)		,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057, nInicio + 0200, Ltrim(cAlias->C7_PRODUTO)		,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057, nInicio + 0500, Ltrim(cAlias->C7_DESCRI)		,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057, nInicio + 1100, LTrim(cAlias->C7_UM)			,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057, nInicio + 1300, Alltrim(STR(cAlias->C7_QUANT))  								,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057, nInicio + 1600, Alltrim(Transform(cAlias->C7_PRECO,PesqPict('SC7', 'C7_PRECO')))		,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057, nInicio + 1900, Alltrim(Transform(cAlias->C7_TOTAL,PesqPict('SC7', 'C7_TOTAL')))		,oFont2,100,,,1)

			aRet:= {}
			aRet:= CalcImp()

			dbSelectArea("SF4")
			dbSetOrder(1)
			dbSeek(xFilial("SF4") + cAlias->C7_TES)
			If SF4->F4_IPI == "S"
				oPrint:Say(nTopo + 0057, nInicio + 2030, Alltrim(STR(aRet[2],4,1))								,oFont2,100,,,1)
			Else
				oPrint:Say(nTopo + 0057, nInicio + 2030, "0.0"								,oFont2,100,,,1)
			EndIf
			SF4->(dbCloseArea())

			oPrint:Say(nTopo + 0057, nInicio + 2070, DTOC(cAlias->C7_DATPRF)		,oFont2,100,,,0)

		endif
		&& Calculo do Valor Total do Pedido de Compra
		nTotal += cAlias->C7_TOTAL
		nFrete += cAlias->C7_VALFRE
		nDespesa += cAlias->C7_DESPESA

		&&Calcula o Valor Total do Pedido de Compra com IPI
		&&nVTIpi += (((cAlias->C6_VALOR * cAlias->B1_IPI)/100) + cAlias->C6_VALOR)

		nTopo := nTopo + 0050

		&&Incrementa Contador da Quantidade de Itens no Pedido de Compra
		nCont ++

		&&Se o arquivo chegou ao fim, imprime rodape.
		If nCont > nCount

/*nTotal2 := nTotal + nFrete + nDespesa + MafisRet(,'NF_VALIPI')

oPrint:Box(nTopo + 0060, nInicio + 0480, nTopo + 0110, nInicio + 1300)
oPrint:Line(nTopo + 0060, nInicio + 0970,nTopo + 0110,nInicio + 0970)

oPrint:Say(nTopo + 0067, nInicio + 0500, "Frete"		,oFont3,100,,,0)
oPrint:Say(nTopo + 0067, nInicio + 1280, "R$ " + Alltrim(Transform(nFrete,PesqPict('SC7', 'C7_VALFRE')))	,oFont3,100,,,1)

oPrint:Box(nTopo + 0110, nInicio + 0480, nTopo + 0160, nInicio + 1300)
oPrint:Line(nTopo + 0110, nInicio + 0970,nTopo + 0160,nInicio + 0970)

oPrint:Say(nTopo + 0117, nInicio + 0500, "Outras Despesas"		,oFont3,100,,,0)
oPrint:Say(nTopo + 0117, nInicio + 1280, "R$ " + Alltrim(Transform(nDespesa,PesqPict('SC7', 'C7_DESPESA')))	,oFont3,100,,,1)


&&Box e Dados - Valor Total
oPrint:Box(nTopo + 0060, nInicio + 1320, nTopo + 0110, nInicio + 1920)
oPrint:Line(nTopo + 0060, nInicio + 1620,nTopo + 0110,nInicio + 1620)

oPrint:Say(nTopo + 0067, nInicio + 1340, "Valor Total Ped."		,oFont3,100,,,0)
oPrint:Say(nTopo + 0067, nInicio + 1900, "R$ " + Alltrim(Transform(nTotal,PesqPict('SC7', 'C7_TOTAL')))	,oFont3,100,,,1)

oPrint:Box(nTopo + 0110, nInicio + 1320, nTopo + 0160, nInicio + 1920)
oPrint:Line(nTopo + 0110, nInicio + 1620,nTopo + 0160,nInicio + 1620)

oPrint:Say(nTopo + 0117, nInicio + 1340, "Valor Total"		,oFont3,100,,,0)
oPrint:Say(nTopo + 0117, nInicio + 1900, "R$ " + Alltrim(Transform(nTotal2,PesqPict('SC7', 'C7_TOTAL')))	,oFont3,100,,,1)


/* IMPRIME TOTAL COM IPI

oPrint:Box(nTopo + 0120, nInicio + 1600, nTopo + 0170, nInicio + 2200)
oPrint:Line(nTopo + 0120, nInicio + 1900,nTopo + 0170,nInicio + 1900)

oPrint:Say(nTopo + 0127, nInicio + 1615, "Valor Total c/ IPI"		,oFont3,100,,,0)
oPrint:Say(nTopo + 0127, nInicio + 2190, "R$ " + Alltrim(Transform(nVTIpi,"@E 9,999,999.99"))	,oFont3,100,,,1)
*/

			&&LInhas Horizontais  -  FIM PEDIDO
			oPrint:Line(nTopo + 0040,nInicio + 0040,nTopo + 0040,nInicio + 2360)
			*/

			&&Box e Dados - Despesas

			oPrint:Box(nTopo + 0060, nInicio + 0610, nTopo + 0160, nInicio + 1170)
			oPrint:Line(nTopo + 0060, nInicio + 0870,nTopo + 0160,nInicio + 0870)

			oPrint:Line(nTopo + 0110, nInicio + 0610,nTopo + 0110,nInicio + 1170)

			oPrint:Say(nTopo + 0067, nInicio + 0630, "Valor Frete"		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0067, nInicio + 1150, "R$ " + Alltrim(Transform(aRet[12], PesqPict('SC5', 'C5_FRETE')))	,oFont3,100,,,1)

			oPrint:Say(nTopo + 0117, nInicio + 0630, "Valor Despesa "		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0117, nInicio + 1150, "R$ " + Alltrim(Transform(aRet[13],PesqPict('SC5', 'C5_DESPESA')))	,oFont3,100,,,1)

			&&Box e Dados - Impostos

			oPrint:Box(nTopo + 0060, nInicio + 1190, nTopo + 0160, nInicio + 1730)
			oPrint:Line(nTopo + 0060, nInicio + 1450,nTopo + 0160,nInicio + 1450)

			oPrint:Line(nTopo + 0110, nInicio + 1190,nTopo + 0110,nInicio + 1730)

			oPrint:Say(nTopo + 0067, nInicio + 1210, "Total Ped."		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0067, nInicio + 1700, "R$ " + Alltrim(Transform(aRet[16], PesqPict('SC6', 'C6_VALOR')))	,oFont3,100,,,1)

			oPrint:Say(nTopo + 0117, nInicio + 1210, "Qtd Peças"		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0117, nInicio + 1700, Alltrim(Transform(QtdItem, PesqPict('SC6', 'C6_QTDVEN')))	,oFont3,100,,,1)


			&&Box e Dados - Valor Total
			oPrint:Box(nTopo + 0060, nInicio + 1750, nTopo + 0160, nInicio + 2360)
			oPrint:Line(nTopo + 0060, nInicio + 2010,nTopo + 0160,nInicio + 2010)

			oPrint:Line(nTopo + 0110, nInicio + 1750,nTopo + 0110,nInicio + 2360)


			oPrint:Say(nTopo + 0067, nInicio + 1780, "Valor IPI"		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0067, nInicio + 2300, "R$ " + Alltrim(Transform(aRet[9], PesqPict('SC6', 'C6_VALOR')))	,oFont3,100,,,1)

			If nDescZF >0
				aRet[15]:= aRet[15] - nDescZF
			EndIF

			oPrint:Say(nTopo + 0117, nInicio + 1780, "Valor Total"		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0117, nInicio + 2300, "R$ " + Alltrim(Transform(aRet[15], PesqPict('SC6', 'C6_VALOR')))	,oFont3,100,,,1)

			&&LInhas Horizontais  -  FIM PEDIDO
			oPrint:Line(nTopo + 0040,nInicio + 0040,nTopo + 0040,nInicio + 2330)

			&&Imprime o Numero de Paginas
			&&	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0150, nInicio + 2360,"Página: " + str(nPag) + " / " + AllTrim(nQtdPag)  ,oFont3,100,,,1)

			&& Funcao de Impressao do Rodape. Parametro: Numero da linha atual
			IMPROD(NPag, nTotal, nTopo)
		EndIf

		cAlias->(dbskip())

	End

	Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³ IMPROD	º Autor ³ Hermes Vieira Jr.	   º Data ³  27/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para impressao do Rodape.								º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function IMPROD(nPag, nTotal, nTopo)

	Local nInicio		:= 0000  && Indica a posicao da primeira coluna
	&&Local cLogo			:= GetMV("MV_ZZLOGO")
	Local cLogo	:= GetSrvProfString("Startpath","") + "\Logo\lgrl" + cFilAnt + ".BMP"
	Local cLogoD  := GetSrvProfString("Startpath","") + "\Logo\lgrl" + cFilAnt + ".BMP"
	Local cEntrega    := ""
	Local cEndEnt := Posicione("SM0",1,cEmpAnt +cAlias->C7_FILENT, "M0_ENDENT" )
	Local cBaiEnt := Posicione("SM0",1,cEmpAnt +cAlias->C7_FILENT, "M0_BAIRENT" )       
	Local cCidEnt := Posicione("SM0",1,cEmpAnt +cAlias->C7_FILENT, "M0_CIDENT" )       
	Local cEstEnt := Posicione("SM0",1,cEmpAnt +cAlias->C7_FILENT, "M0_ESTENT" )       

	cEntrega:= "     " + AllTrim(cEndEnt) + ", " + AllTrim(cBaiEnt) + " / " + AllTrim(cCidEnt) + " - " + AllTrim(cEstEnt)
	
	If nTopo <= (Mm2Pix(oPrint, oPrint:nVertSize()) - 0540)

		&& Box Condicoes Gerais
		oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0740, nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 490, nInicio + 2360)

		&& Titulo Centralizado
		oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0720, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Informações Gerais"		,oFont1,100,,,2)

		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0640, nInicio + 0060,"Forma de Pagamento"  						  		,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0640, nInicio + 0450,": " + cAlias->C7_COND + " - " + cAlias->E4_DESCRI	,oFont5,100,,,0)

		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0640, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Tipo Frete"  								,oFont3,100,,,0)
		If AllTrim(cAlias->C7_TPFRETE) = "C"
			oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0640, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0200,": CIF"	,oFont5,100,,,0)
		Else
			oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0640, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0200,": FOB"	,oFont5,100,,,0)
		EndIf

		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0590, nInicio + 0060,"Descontos %" 				 				   	   		,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0590, nInicio + 0450,": " + AllTrim(TRANSFORM(cAlias->C7_DESC1,PesqPict('SC7', 'C7_DESC1'))) + " + " + AllTrim(TRANSFORM(cAlias->C7_DESC2,PesqPict('SC7', 'C7_DESC2'))) + " + " + AllTrim(TRANSFORM(cAlias->C7_DESC3,PesqPict('SC7', 'C7_DESC3')))	,oFont5,100,,,0)

		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0590, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Validade" 				 			   		,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0590, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0200,": " + DtoC(cAlias->C7_ZZVALID)				,oFont5,100,,,0)

		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0540, nInicio + 0060,"Transpotadora" 				 				   	   					,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0540, nInicio + 0450,": (" + cAlias->C7_ZZTRANS + " )" + cAlias->A4_NOME					,oFont5,100,,,0)

		&&Box para a Mensagem da Nota
		oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0480, nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 400, nInicio + 2360)
		oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0480, nInicio + 0060,"Observação" 			   		,oFont3,100,,,0)
		oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0480, nInicio + 0250,": " + Transform(cAlias->C7_OBS,'@!S150')  		,oFont5,100,,,0)

		/*dbSelectArea("SM0")             //especie
		dbSetOrder(1)                 //filial,codigo
		If dbSeek("99"+ SC8->C8_FILENT)
			cEntrega:= "Empresa:" + SM0->M0_NOME + " - End. " + SM0->M0_ENDENT + ", Bairro.:" + SM0->M0_BAIRENT + ", Cidade.:" + SM0->M0_CIDENT
		Endif*/
		/*dbSelectArea("SM0")             //especie
		SM0->(dbSetOrder(1))                 //filial,codigo
		If SM0->(dbSeek(Substr(cAlias->C7_FILENT,1,2) + cAlias->C7_FILENT))
			cEntrega:= "Empresa:" + SM0->M0_NOME + " - End. " + SM0->M0_ENDENT + ", Bairro.:" + SM0->M0_BAIRENT + ", Cidade.:" + SM0->M0_CIDENT
		Endif*/

		&&Box para o Local de Entrega
		oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0390, nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 310, nInicio + 2360)
		oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0375, nInicio + 0060,"Local Entrega: " 			   		,oFont3,100,,,0)
		oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0375, nInicio + 0280,cEntrega  		,oFont5,100,,,0)

		&&Assinatura Digital
		&& oPrint:SayBitmap(Coluna, Linha, Caminho, Largura, Altura)

		oPrint:Line(Mm2Pix(oPrint, oPrint:nVertSize()) - 0100,nInicio + 1500,Mm2Pix(oPrint, oPrint:nVertSize()) - 100, nInicio + 2360)        && HORIZONTAL
		oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0105, nInicio + 1510,"Assinatura Responsável: "		,oFont5,100,,,0)

		&&Imprime o Numero de Paginas
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 010, nInicio + 2360,"Página: " + str(nPag) + " / " + AllTrim(nQtdPag)   ,oFont3,100,,,1)

		oPrint:EndPage()


	Else

		&&Encerra a Pagina Atual
		oPrint:EndPage()

		&&Inicia uma Nova Pagina para Impressao
		oPrint:StartPage()

		&&Define o modo de Impressão como Retrato
		oPrint:SetPortrait()  &&SetLandscape -> Para definir como modo Paisagem

		&&Funcao para impressao do Cabecalho
		IMPCAB(cNPc, cEMISSAO)
		nTopo := 0420

		NPag += 1

		&& Box Condicoes Gerais
		oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0540, nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 0190, nInicio + 2360)

		&& Titulo Centralizado
		oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0520, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Informações Gerais"		,oFont1,100,,,2)

		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0440, nInicio + 0060,"Forma de Pagamento"  						  		,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0440, nInicio + 0450,": " + cAlias->C7_COND + " - " + cAlias->E4_DESCRI	,oFont5,100,,,0)

		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0440, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Tipo Frete"  								,oFont3,100,,,0)
		If AllTrim(cAlias->C7_TPFRETE) = "C"
			oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0440, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0200,": CIF"	,oFont5,100,,,0)
		Else
			oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0440, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0200,": FOB"	,oFont5,100,,,0)
		EndIf

		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0390, nInicio + 0060,"Descontos %" 				 				   	   		,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0390, nInicio + 0450,": " + AllTrim(TRANSFORM(cAlias->C7_DESC1,"@E 9,999,999.99")) + " + " + AllTrim(TRANSFORM(cAlias->C7_DESC2,"@E 9,999,999.99")) + " + " + AllTrim(TRANSFORM(cAlias->C7_DESC3,"@E 9,999,999.99"))	,oFont5,100,,,0)

		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0390, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Validade" 				 			   		,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0390, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0200,": " + DtoC(cAlias->C7_ZZVALID)		,oFont5,100,,,0)

		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0340, nInicio + 0060,"Transpotadora" 				 				   	   					,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0340, nInicio + 0450,": (" + cAlias->C7_ZZTRANS + " )" + cAlias->A4_NOME					,oFont5,100,,,0)

		&&Box para a Mensagem da Nota
		oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0480, nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 400, nInicio + 2360)
		oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0480, nInicio + 0060,"Observação" 			   		,oFont3,100,,,0)
		oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0480, nInicio + 0250,": " + Transform(cAlias->C7_OBS,'@!S150')  		,oFont5,100,,,0)

		/*dbSelectArea("SM0")
		dbSetOrder(1)                 //filial,codigo
		If dbSeek(xFilial("SM0") + SC7->C7_FILENT)
			cEntrega:= "Empresa:" + SM0->M0_NOME + " - End. Rua" + SM0->M0_ENDENT + ", Bairro.:" + SM0->M0_BAIRENT + ", Cidade.:" + SM0->M0_CIDENT
		Endif*/
		/*dbSelectArea("SM0")             //especie
		SM0->(dbSetOrder(1))                 //filial,codigo
		If SM0->(dbSeek(Substr(cAlias->C7_FILENT,1,2) + cAlias->C7_FILENT))
			cEntrega:= "Empresa:" + SM0->M0_NOME + " - End. " + SM0->M0_ENDENT + ", Bairro.:" + SM0->M0_BAIRENT + ", Cidade.:" + SM0->M0_CIDENT
		Endif*/
		&&Box para o Local de Entrega
		oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0390, nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 310, nInicio + 2360)
		oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0395, nInicio + 0060,"Local Entrega: " 			   		,oFont3,100,,,0)
		oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0395, nInicio + 0280,cEntrega  		,oFont5,100,,,0)

		&&Assinatura Digital
		&& oPrint:SayBitmap(Coluna, Linha, Caminho, Largura, Altura)
		oPrint:SayBitmap(Mm2Pix(oPrint, oPrint:nVertSize()) - 0305, nInicio + 1500,cLogo, 314, 235)
		oPrint:Line(Mm2Pix(oPrint, oPrint:nVertSize()) - 0100,nInicio + 1500,Mm2Pix(oPrint, oPrint:nVertSize()) - 100, nInicio + 2360)        && HORIZONTAL
		oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0105, nInicio + 1510,"Assinatura Responsável: "		,oFont5,100,,,0)

		&&Imprime o Numero de Paginas
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 010, nInicio + 2360,"Página: " + str(nPag) + " / " + AllTrim(nQtdPag)   ,oFont3,100,,,1)

		oPrint:EndPage()

	EndIf

	Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³ Mm2Pix   º Autor ³Waldir Baldin		   º Data ³  27/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna a Largura da Pagina em Pixel.						º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Mm2Pix(oPrint, nMm)
/*Retirado metodo oPrint:nLogPixelX(), pois estava ocorrendo casos em clientes
em que a linha impressa que utliza a funcao MM2PIX saia desconfigurada*/
	&&Local nValor := (nMm * oPrint:nLogPixelX()) / 25.4
	Local nValor := (nMm * 300) / 25.4
	Return nValor


Static Function CalcImp()
	Local aArea           := GetArea()
	Local cTipoCli        := POSICIONE("SA2",1,xFilial("SA2") + cAlias->A2_COD + cAlias->A2_LOJA,"A2_TIPO")
	Local cTipoNF         := "N"
	Local nVlrTotItem     := cAlias->C7_TOTAL
	Local nQuant         := cAlias->C7_QUANT
	Local nVlUnit         := cAlias->C7_PRECO

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&| Verifico o tipo da nota para efetuar o calculo                                          |
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	MaFisSave()
	MaFisEnd()

	MaFisIni(cAlias->A2_COD,;&& 1-Codigo Cliente/Fornecedor
	cAlias->A2_LOJA,;		&& 2-Loja do Cliente/Fornecedor
	"C",;				&& 3-C:Cliente , F:Fornecedor
	"N",;				&& 4-Tipo da NF
	cTipoCli,;		&& 5-Tipo do Cliente/Fornecedor
	Nil,;
		Nil,;
		Nil,;
		Nil,;
		"MATA120")

	&&Na argentina o calculo de impostos depende da serie.
	If cPaisLoc == 'ARG'
		MaFisAlt('NF_SERIENF',LocXTipSer('SA2',MVNOTAFIS))
	Endif

	MaFisAdd(    cAlias->C7_PRODUTO                    ,;           // 1-Codigo do Produto ( Obrigatorio )
	cAlias->C7_TES                        ,;          // 2-Codigo do TES ( Opcional )
	cAlias->C7_QUANT                    ,;          // 3-Quantidade ( Obrigatorio )
	nVlUnit                    ,;          // 4-Preco Unitario ( Obrigatorio )
	0                                ,;           // 5-Valor do Desconto ( Opcional )
	""                                ,;          // 6-Numero da NF Original ( Devolucao/Benef )
	""                                ,;          // 7-Serie da NF Original ( Devolucao/Benef )
	""                                ,;          // 8-RecNo da NF Original no arq SD1/SD2
	0                                ,;          // 9-Valor do Frete do Item ( Opcional )
	0                                ,;          // 10-Valor da Despesa do item ( Opcional )
	0                                ,;        // 11-Valor do Seguro do item ( Opcional )
	0                                ,;          // 12-Valor do Frete Autonomo ( Opcional )
	(nVlUnit*cAlias->C7_QUANT)    ,;          // 13-Valor da Mercadoria ( Obrigatorio )
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
	nDescZF  := MaFisRet(,"NF_DESCZF")
	ntotSol  := MaFisRet(,"NF_VALSOL")
	ntotFrt  := MaFisRet(,"NF_FRETE")
	ntotDesp := MaFisRet(,"NF_DESPESA")
	ntotDesc := MaFisRet(,"NF_DESCONTO")
	ntotGer  := MaFisRet(,"NF_TOTAL")
	ntotMerc += MaFisRet(,"NF_VALMERC")



	nVlrSol += ntotSol

	nVlrTotal += ntotGer

	MaFisEnd()
	QtdItem += cAlias->C7_QUANT
	RestArea( aArea )
	Return ({nBasIPI,nAlqIPI,nValIPI,nBasICM,nValICM,nAlqICM,nBasSol,nValSol,ntotIpi,ntotIcm,nVlrSol,ntotFrt,ntotDesp,ntotDesc,nVlrTotal,ntotMerc})


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidPerg ºAutor  ³Hermes Vieira Jr.   º Data ³  15/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida se existe um grupo de perguntas caso contrario o    º±±
±±º          ³ o grupo de perguntas e criado.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8 - DB2                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidPerg(cPerg)

	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j

	dbSelectArea("SX1")
	dbSetOrder(1)
	&&cPerg := PADR(cPerg,6)
	cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

	&& Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/	Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs, {cPerg, "01", "Pedido de "        			,"" ,"" ,"mv_ch1", "C", 06, 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SC7"})
	aAdd(aRegs, {cPerg, "02", "Pedido até "        			,"" ,"" ,"mv_ch2", "C", 06, 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SC7"})
	aAdd(aRegs, {cPerg, "03", "Data de "        			,"" ,"" ,"mv_ch3", "D", 08, 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "04", "Data até "        			,"" ,"" ,"mv_ch4", "D", 08, 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "05", "Produto de "     			,"" ,"" ,"mv_ch5", "C", 15, 0, 0, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1"})
	aAdd(aRegs, {cPerg, "06", "Produto até "     			,"" ,"" ,"mv_ch6", "C", 15, 0, 0, "G", "", "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1"})
	&&
	aAdd(aRegs, {cPerg, "03", "Onde Criar?"  			,"" ,"" ,"mv_ch3", "C", 08, 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})

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

