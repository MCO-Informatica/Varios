/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FISTRFNFEº Autor ³ Ricardo Souza      º Data ³  28/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescriÇÃo ³ Ponto de Entrada para impressao da CC-e.                   º±±
±±º          ³ Layout nosso enquanto aguarda padrao da SEFAZ              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FISTRFNFE()
	
	aadd(aRotina,{'Imprime CC-e','U_CPRTCCE' , 0 , 3,0,NIL})

Return Nil

/////////////////////////////////////////////
User Function CPRTCCE()
/////////////////////////////////////////////
	#include "protheus.ch"
	#include "rwmake.ch"
	#include "font.ch"
	#include "colors.ch"
	#include "totvs.ch"
	#Include "TOPCONN.CH"
	#INCLUDE "XMLXFUN.CH"
	#INCLUDE "TBICONN.CH"
	#INCLUDE "FWPrintSetup.ch"


	Local   iw1,iw2,nLin
	Local   xBitMap   := FisxLogo("1")     ///Logotipo da empresa
	Local   MMEMO1    := MMEMO2 := ""
	Local   xCGC      := ""
	Local   aArea     := GetArea()

	Local lMv_Logod    := If(GetNewPar("MV_LOGOD", "N" ) == "S", .T., .F.   )
	Local cLogoD	    := ""
	Local cDescLogo		:= ""
	Local cGrpCompany	:= ""
	Local cCodEmpGrp	:= ""
	Local cUnitGrp		:= ""
	Local cFilGrp		:= ""

	Private cPerg     	:= "CPRNCCE   "
	
	ValidPerg()

	lRsp := Pergunte(cPerg,.T.)

	IF ( !lRsp )
		Return
	ENDIF

	If MV_PAR03 == 1

		dbSelectArea("SF2")
		dbSetOrder(1)
		dbSeek(xFilial("SF2")+mv_par02+mv_par01)

		cChvNfe  := SF2->F2_CHVNFE
		dEmissao := SF2->F2_EMISSAO
	Else
		dbSelectArea("SF1")
		dbSetOrder(1)
		dbSeek(xFilial("SF1")+mv_par02+mv_par01)

		cChvNfe  := SF1->F1_CHVNFE
		dEmissao := SF1->F1_EMISSAO
	EndIf

	IF ( EOF() .OR. EMPTY(cChvNfe) )
		MsgStop("Atenção! Nota Fiscal não existe ou Nota Fiscal Inutilizada.")
		RestArea(aArea)
		Return
	ENDIF

	If MV_PAR03 == 1
		IF SF2->F2_TIPO $ "B/D"		//Devolução

			dbSelectArea("SA2")
			dbSetOrder(1)
			dbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA)
			xDestinatario := SA2->A2_NOME
			IF ( !EMPTY(SA2->A2_CGC) )
				xCGC := IIF(LEN(AllTrim(SA2->A2_CGC)) > 11 , TRANSF(SA2->A2_CGC,"@R 99.999.999/9999-99") , TRANSF(SA2->A2_CGC,"@R 999.999.999-99") )
			ENDIF
			xEndDest := SA2->A2_END
			xBairDest:= SA2->A2_BAIRRO
			xCepDest := TRANSF(SA2->A2_CEP,"@R 99.999-999")
			xMunDest := SA2->A2_MUN
			xUFDest  := SA2->A2_EST
			xTelDest := AllTrim(SA2->A2_DDD) + AllTrim(SA2->A2_TEL)
			xTelDest := STRTRAN(xTelDest,"(","")
			xTelDest := STRTRAN(xTelDest,")","")
			xTelDest := STRTRAN(xTelDest,"-","")
			xTelDest := STRTRAN(xTelDest," ","")
			IF Len(AllTrim(xTelDest)) > 10
				xTelDest := TRANSF(xTelDest,"@R (99)99999-9999")
			Else
				xTelDest := TRANSF(xTelDest,"@R (99)9999-9999")
			EndIF
			xIEDest := SA2->A2_INSCR

		Else

			dbSelectArea("SA1")
			dbSetOrder(1)
			dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
			xDestinatario := SA1->A1_NOME
			IF ( !EMPTY(SA1->A1_CGC) )
				xCGC := IIF(LEN(AllTrim(SA1->A1_CGC)) > 11 , TRANSF(SA1->A1_CGC,"@R 99.999.999/9999-99") , TRANSF(SA1->A1_CGC,"@R 999.999.999-99") )
			ENDIF
			xEndDest := SA1->A1_END
			xBairDest:= SA1->A1_BAIRRO
			xCepDest := TRANSF(SA1->A1_CEP,"@R 99.999-999")
			xMunDest := SA1->A1_MUN
			xUFDest  := SA1->A1_EST
			xTelDest := AllTrim(SA1->A1_DDD) + AllTrim(SA1->A1_TEL)
			xTelDest := STRTRAN(xTelDest,"(","")
			xTelDest := STRTRAN(xTelDest,")","")
			xTelDest := STRTRAN(xTelDest,"-","")
			xTelDest := STRTRAN(xTelDest," ","")
			IF Len(AllTrim(xTelDest)) > 10
				xTelDest := TRANSF(xTelDest,"@R (99)99999-9999")
			Else
				xTelDest := TRANSF(xTelDest,"@R (99)9999-9999")
			EndIF
			xIEDest := SA1->A1_INSCR

		EndIF
	Else
		IF SF1->F1_TIPO $ "B/D"		//Devolução

			dbSelectArea("SA1")
			dbSetOrder(1)
			dbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA)
			xDestinatario := SA1->A1_NOME
			IF ( !EMPTY(SA1->A1_CGC) )
				xCGC := IIF(LEN(AllTrim(SA1->A1_CGC)) > 11 , TRANSF(SA1->A1_CGC,"@R 99.999.999/9999-99") , TRANSF(SA1->A1_CGC,"@R 999.999.999-99") )
			ENDIF
			xEndDest := SA1->A1_END
			xBairDest:= SA1->A1_BAIRRO
			xCepDest := TRANSF(SA1->A1_CEP,"@R 99.999-999")
			xMunDest := SA1->A1_MUN
			xUFDest  := SA1->A1_EST
			xTelDest := AllTrim(SA1->A1_DDD) + AllTrim(SA1->A1_TEL)
			xTelDest := STRTRAN(xTelDest,"(","")
			xTelDest := STRTRAN(xTelDest,")","")
			xTelDest := STRTRAN(xTelDest,"-","")
			xTelDest := STRTRAN(xTelDest," ","")
			IF Len(AllTrim(xTelDest)) > 10
				xTelDest := TRANSF(xTelDest,"@R (99)99999-9999")
			Else
				xTelDest := TRANSF(xTelDest,"@R (99)9999-9999")
			EndIF
			xIEDest := SA1->A1_INSCR

		Else

			dbSelectArea("SA2")
			dbSetOrder(1)
			dbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)
			xDestinatario := SA2->A2_NOME
			IF ( !EMPTY(SA2->A2_CGC) )
				xCGC := IIF(LEN(AllTrim(SA2->A2_CGC)) > 11 , TRANSF(SA2->A2_CGC,"@R 99.999.999/9999-99") , TRANSF(SA2->A2_CGC,"@R 999.999.999-99") )
			ENDIF
			xEndDest := SA2->A2_END
			xBairDest:= SA2->A2_BAIRRO
			xCepDest := TRANSF(SA2->A2_CEP,"@R 99.999-999")
			xMunDest := SA2->A2_MUN
			xUFDest  := SA2->A2_EST
			xTelDest := AllTrim(SA2->A2_DDD) + AllTrim(SA2->A2_TEL)
			xTelDest := STRTRAN(xTelDest,"(","")
			xTelDest := STRTRAN(xTelDest,")","")
			xTelDest := STRTRAN(xTelDest,"-","")
			xTelDest := STRTRAN(xTelDest," ","")
			IF Len(AllTrim(xTelDest)) > 10
				xTelDest := TRANSF(xTelDest,"@R (99)99999-9999")
			Else
				xTelDest := TRANSF(xTelDest,"@R (99)9999-9999")
			EndIF
			xIEDest := SA2->A2_INSCR

		EndIF

	EndIf
	If Type("_nTopProtheus") == "U"

		Public _nTopProtheus

		_nTopProtheus := AdvConnection() // obtém o ID da conexão atual

	EndIf

	If Type("_nTopTSS") == "U"

		Public _nTopTSS

		MsgRun("Conectando a TSS...","Conexão",;
			{|| _nTopTSS := TcLink("MSSQL/SHANGRILATSS","192.168.10.5",7890) })

		If _nTopTSS < 0

			MsgAlert("Não foi possível se conectar com TSS. "+;
				"Essa falha pode ocorrer devido ao número de licenças excedidas. "+;
				"Tente mais tarde ou contate o administrador do sistema.")

			Return .F.

		EndIf

	EndIf

	TcSetConn(_nTopTSS) // Utilize essa função para alternar entre as conexões





///
///TOP 1 - para pegar sempre a ultima carta de correcao da nf-e
///
	cQry := "SELECT TOP 1 ID_EVENTO,TPEVENTO,SEQEVENTO,AMBIENTE,DATE_EVEN,TIME_EVEN,VERSAO,VEREVENTO,VERTPEVEN,VERAPLIC,CORGAO,CSTATEVEN,CMOTEVEN,"
	cQry += "PROTOCOLO,NFE_CHV,ISNULL(CONVERT(VARCHAR(2024),CONVERT(VARBINARY(2024),XML_ERP)),'') AS TMEMO1,"
	cQry += "ISNULL(CONVERT(VARCHAR(2024),CONVERT(VARBINARY(2024),XML_RET)),'') AS TMEMO2 "
	cQry += "FROM SPED150 "
	cQry += "WHERE D_E_L_E_T_ = ' ' AND STATUS = 6 "
	cQry += "AND NFE_CHV = '"+cChvNfe+"' "
	cQry += "ORDER BY LOTE DESC"

	cQry := ChangeQuery(cQry)

	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)

	TcSetField("TMP","DATE_EVEN","D",08,0)

	dbSelectArea("TMP")
	dbGoTop()

	IF ( EOF() )
		MsgStop("Atenção! Não existe Carta de Correção para a Nota Fiscal informada.")
		TMP->(dbCloseArea())
		RestArea(aArea)

		TcSetConn(_nTopProtheus) // Utilize essa função para alternar entre as conexões

		Return
	ENDIF

	MMEMO1     := TMP->TMEMO1     ///Relativo ao envio
	MMEMO2     := TMP->TMEMO2     ///Retorno da SEFAZ
	MNFE_CHV   := TMP->NFE_CHV
	MID_EVENTO := TMP->ID_EVENTO
	MTPEVENTO  := STR(TMP->TPEVENTO,6)
	MSEQEVENTO := STR(TMP->SEQEVENTO,1)
	MAMBIENTE  := IIF(TMP->AMBIENTE==1,"AMBIENTE PRODUÇÃO", IIF(TMP->AMBIENTE==2,"AMBIENTE HOMOLOGAÇÃO" , ""))
	MDATE_EVEN := DTOC(TMP->DATE_EVEN)
	MTIME_EVEN := TMP->TIME_EVEN
	MVERSAO    := STR(TMP->VERSAO,4,2)
	MVEREVENTO := STR(TMP->VEREVENTO,4,2)
	MVERTPEVEN := STR(TMP->VERTPEVEN,4,2)
	MVERAPLIC  := TMP->VERAPLIC
//MCORGAO    := STR(TMP->CORGAO,2)+IIF(TMP->CORGAO==52 , " - GOIAS", "")
	MCSTATEVEN := STR(TMP->CSTATEVEN,3)
	MCMOTEVEN  := TMP->CMOTEVEN
	MPROTOCOLO := STR(TMP->PROTOCOLO,15)

	TMP->(dbCloseArea())

	RestArea(aArea)

	xFone := SUBSTR(RTRIM(SM0->M0_TEL),4,11)
	xFone := STRTRAN(xFone,"(","")
	xFone := STRTRAN(xFone,")","")
	xFone := STRTRAN(xFone,"-","")
	xFone := STRTRAN(xFone," ","")

	xRazSoc := RTRIM(SM0->M0_NOMECOM)
	xEnder  := RTRIM(SM0->M0_ENDENT)
	xCidade := RTRIM(SM0->M0_CIDENT) + " - " + SM0->M0_ESTENT
	xCep	:= RTRIM(SM0->M0_BAIRENT)+"  CEP: " + TRANSF(SM0->M0_CEPENT,"@R 99.999-999")
	xFone   := "Fone: " + TRANSF(xFone,"@R (99)9999-9999")
	xCnpj   := TRANSF(SM0->M0_CGC,"@R 99.999.999/9999-99")
	xIE     := SM0->M0_INSC

////
////Extrai dados do Memo
////
	MDHEVENTO := ""
	iw1 := AT("<dhRegEvento>" , MMEMO2 )
	iw2 := AT("</dhRegEvento>" , MMEMO2 )
	IF ( iw1 > 0 )
		iw3 := ( iw2 - iw1 )
		MDHEVENTO += SUBS(MMEMO2 , ( iw1+13 ) , ( iw2 - ( iw1 + 13 ) ) )
	ENDIF
	*
	MDESCEVEN := ""
	iw1 := AT("<xEvento>" , MMEMO2 )
	iw2 := AT("</xEvento>" , MMEMO2 )
	IF ( iw1 > 0 )
		iw3 := ( iw2 - iw1 )
		MDESCEVEN += SUBS(MMEMO2 , ( iw1+9 ) , ( iw2 - ( iw1 + 9 ) ) )
	ENDIF
	*
	aCorrec   := {}
	MCORRECAO := ""
	iw1 := AT("<xCorrecao>" , MMEMO1 )
	iw2 := AT("</xCorrecao>" , MMEMO1 )
	IF ( iw1 > 0 )
		iw3 := ( iw2 - iw1 )
		MCORRECAO += SUBS(MMEMO1 , ( iw1+11 ) , ( iw2 - ( iw1 + 11 ) ) )
		MCORRECAO += SPACE(10)
		iw1 := 1
		DO WHILE !EMPTY(SUBS(MCORRECAO,iw1,10))
			AADD(aCorrec , SUBS(MCORRECAO,iw1,130) )
			iw1 += 130     ///Nro de caracteres da linha - fica a criterio
		ENDDO
	ENDIF
	*
	aCondic   := {}
	MCONDICAO := ""
	iw1 := AT("<xCondUso>" , MMEMO1 )
	iw2 := AT("</xCondUso>" , MMEMO1 )
	IF ( iw1 > 0 )
		///As linha comentadas abaixo retirei pois nao achei bom qdo impressa
		///
		///iw3 := ( iw2 - iw1 )
		///MCONDICAO += SUBS(MMEMO1 , ( iw1+10 ) , ( iw2 - ( iw1 + 10 ) ) )
		///MCONDICAO += SPACE(10)
		///iw1 := 1
		///DO WHILE !EMPTY(SUBS(MCONDICAO,iw1,10))
		///	AADD(aCondic , SUBS(MCONDICAO,iw1,137) )
		///	iw1 += 137     ///Nro de caracteres da linha
		///ENDDO
		AADD(aCondic , "Nos termos da cláusula décima quarta-A do Ajuste SINIEF 07/2005, a carta de correção eletrônica pode ser utilizada               " )
		AADD(aCondic , "para a regularização de erro ocorrido na emissão de documento fiscal, desde que o erro não esteja relacionado com:               " )
		AADD(aCondic , "I - as variáveis que determinam o valor do imposto tais como: base de cálculo, alíquota, diferença de preço, quantidade, valor da" )
		AADD(aCondic , "operação ou da prestação;                                                                                                        " )
		AADD(aCondic , "II - a correção de dados cadastrais que implique mudança do remetente ou do destinatário;                                        " )
		AADD(aCondic , "III - a data de emissão ou de saída.                                                                                             " )
	ENDIF


// Cria um novo objeto para impressao
	oPrint := TMSPrinter():New("Impressão da Carta de Correção Eletronica - CC-e")

// Cria os objetos com as configuracoes das fontes
//                                         Negrito  Subl  Italico
	oFont08  := TFont():New( "Courier New",,08,,.F.,,,,,.F.,.F. )
	oFont08b := TFont():New( "Courier New",,08,,.T.,,,,,.F.,.F. )
	oFont09  := TFont():New( "Courier New",,09,,.F.,,,,,.F.,.F. )
	oFont09b := TFont():New( "Courier New",,09,,.T.,,,,,.F.,.F. )
	oFont10  := TFont():New( "Courier New",,10,,.F.,,,,,.F.,.F. )
	oFont10b := TFont():New( "Courier New",,10,,.T.,,,,,.F.,.F. )
	oFont11  := TFont():New( "Courier New",,11,,.F.,,,,,.F.,.F. )
	oFont11b := TFont():New( "Courier New",,11,,.T.,,,,,.F.,.F. )
	oFont12  := TFont():New( "Courier New",,12,,.F.,,,,,.F.,.F. )
	oFont12b := TFont():New( "Courier New",,12,,.T.,,,,,.F.,.F. )
	oFont13b := TFont():New( "Courier New",,13,,.T.,,,,,.F.,.F. )
	oFont14  := TFont():New( "Courier New",,14,,.F.,,,,,.F.,.F. )
	oFont24b := TFont():New( "Courier New",,24,,.T.,,,,,.F.,.F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Logotipo       							                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lMv_Logod
		cGrpCompany	:= AllTrim(FWGrpCompany())
		cCodEmpGrp	:= AllTrim(FWCodEmp())
		cUnitGrp	:= AllTrim(FWUnitBusiness())
		cFilGrp		:= AllTrim(FWFilial())

		If !Empty(cUnitGrp)
			cDescLogo	:= cGrpCompany + cCodEmpGrp + cUnitGrp + cFilGrp
		Else
			cDescLogo	:= cEmpAnt + cFilAnt
		EndIf

		cLogoD := GetSrvProfString("Startpath","") + "DANFE" + cDescLogo + ".BMP"
		If !File(cLogoD)
			cLogoD	:= GetSrvProfString("Startpath","") + "DANFE" + cEmpAnt + ".BMP"
			If !File(cLogoD)
				lMv_Logod := .F.
			EndIf
		EndIf
	EndIf

// Mostra a tela de Setup
	oPrint:Setup()

	oPrint:SetPaperSize(9)       ///(DMPAPER_A4)
	oPrint:SetPortrait()

// Inicia uma nova pagina
	oPrint:StartPage()

	oPrint:SetFont(oFont24b)

	oPrint:Box(100,100,170,1790)	//Caixa Recebemos
	oPrint:Say(110,110,"RECEBEMOS DE "+AllTrim(xRazSoc)+" A CARTA DE CORREÇÃO REFERENTE A NOTA FISCAL.",oFont08,150)

	oPrint:Box(170,100,350,500)	//Data Recebimento
	oPrint:Say(180,110,"DATA DO RECEBIMENTO",oFont08,150)

	oPrint:Box(170,500,350,1790)	//Assinatura recebedor
	oPrint:Say(180,510,"IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR",oFont08,150)
//oPrint:Say(320,000,PADC(AllTrim(xDestinatario),130),oFont08b)

	oPrint:Box(100,1790,350,2320)	//Caixa NFe
	oPrint:Say(104,2030,"NF-e",oFont10b ,160)
	oPrint:Say(170,1830,"SÉRIE: "+mv_par01,oFont10b ,100)
	oPrint:Say(220,1830,"NF-e: "+mv_par02,oFont10b ,100)
	oPrint:Say(270,1830,"EMISSÃO: "+DTOC(dEmissao),oFont10b ,100)

	oPrint:Box(370,100,750,1100)	//Identificacao Empresa
	If lMv_Logod
		oPrint:SayBitMap(450,116,cLogoD,300,200)
	Else
		oPrint:SayBitMap(450,116,xBitMap,300,200)
	EndIF
	oPrint:Say(400,450,"IDENTIFICAÇÃO DO EMITENTE",oFont09b ,160)
	oPrint:Say(480,450,AllTrim(xRazSoc),oFont08b,200)
	oPrint:Say(530,450,AllTrim(xEnder),oFont08b,200)
	oPrint:Say(580,450,AllTrim(xCidade),oFont08b,200)
	oPrint:Say(630,450,AllTrim(xCep),oFont08b,200)
	oPrint:Say(680,450,AllTrim(xFone),oFont08b,200)

	oPrint:Box(370,1100,750,1450)	//Identificacao CCE
	oPrint:Say(400,1160,"CC-e",oFont24b ,160)
	oPrint:Say(500,1190,"CARTA DE",oFont08 ,100)
	oPrint:Say(540,1190,"CORREÇÃO",oFont08 ,100)
	oPrint:Say(580,1175,"ELETRÔNICA",oFont08 ,100)
	oPrint:Say(650,1130,"SÉRIE: "+mv_par01,oFont10b ,100)
	oPrint:Say(700,1130,"NF-e: "+mv_par02,oFont10b ,100)

	oPrint:Box(370,1450,550,2320)	//Identificacao Codigo Barras
/*
+------------------------------------------------------------------+
| Parametros do MSBAR                                              |
+------------------------------------------------------------------+
| 01 cTypeBar String com o tipo do codigo de barras                |
|    "EAN13","EAN8","UPCA" ,"SUP5"   ,"CODE128"                    |
|    "INT25","MAT25,"IND25","CODABAR","CODE3_9"                    |
| 02 nRow           Numero p/ Linha em centimentros                |
| 03 nCol           Numero p/ coluna em centimentros               |
| 04 cCode          String com o conteudo do codigo                |
| 05 oPr            Objeto Printer                                 |
| 06 lcheck        Se calcula o digito de controle                 |
| 07 Cor            Numero da Cor, utilize a "common.ch"           |
| 08 lHort          Se imprime na Horizontal                       |
| 09 nWidth        Numero p/ largura da barra em centimetros       |
| 10 nHeigth        Numero p/ Altura da barra em milimetros        |
| 11 lBanner        Se imprime o linha em baixo do codigo          |
| 12 cFont          String com o tipo de fonte                     |
| 13 cMode          String com o modo do codigo de barras CODE128  |
+------------------------------------------------------------------+
*/
	MSBAR('INT25',4.0,12.9,MNFE_CHV,oPrint,.F.,,.T.,0.013,1,,,,.F.)

	oPrint:Box(550,1450,650,2320)	//Identificacao Chave NFe
	oPrint:Say(570,1460,"CHAVE DE ACESSO DA NF-E VINCULADA AO EVENTO",oFont08 ,100)
	oPrint:Say(610,1460,MNFE_CHV,oFont08b ,880)

	oPrint:Box(650,1450,750,2320)	//Protocolo CCe
	oPrint:Say(670,1460,"PROTOCOLO DE AUTORIZAÇÃO DE USO DA CC-E",oFont08 ,100)
	oPrint:Say(710,1460,MPROTOCOLO+"  "+MDATE_EVEN+"  "+MTIME_EVEN,oFont08b ,880)

	oPrint:Box(750,1450,920,2320)	//Mensagem de Autenticidade
	oPrint:Say(770,1460,"Consulte a autenticidade no portal nacional da",oFont08 ,100)
	oPrint:Say(820,1460,"NF-e www.nfe.fazenda.gov.br/portal ou no site da",oFont08 ,100)
	oPrint:Say(870,1460,"Sefaz Autorizadora",oFont08 ,100)

	oPrint:Box(750,100,850,750)	//CPF/CNPJ
	oPrint:Say(770,110,"CNPJ",oFont08 ,100)
	oPrint:Say(810,110,AllTrim(xCnpj),oFont08b,200)

	oPrint:Box(750,750,850,1450)	//IE
	oPrint:Say(770,760,"INSCRIÇÃO ESTADUAL",oFont08 ,100)
	oPrint:Say(810,760,AllTrim(xIE),oFont08b,200)

	oPrint:Say(880,110,"DESTINATÁRIO/REMETENTE",oFont09b ,100)
	oPrint:Box(920,100,1020,1400)	// Dados Destinatário
	oPrint:Say(940,110,"NOME / RAZÃO SOCIAL",oFont08 ,100)
	oPrint:Say(980,110,AllTrim(xDestinatario),oFont08b ,880)

	oPrint:Box(920,1400,1020,1850)
	oPrint:Say(940,1410,"CNPJ / CPF",oFont08 ,100)
	oPrint:Say(980,1410,AllTrim(xCGC),oFont08b ,880)

	oPrint:Box(920,1850,1020,2320)
	oPrint:Say(940,1860,"DATA DE EMISSÃO DA NF-e",oFont08 ,100)
	oPrint:Say(980,1860,DTOC(dEmissao),oFont08b ,880)

	oPrint:Box(1020,100,1120,1100)
	oPrint:Say(1040,110,"ENDEREÇO",oFont08 ,100)
	oPrint:Say(1080,110,AllTrim(xEndDest),oFont08b ,880)

	oPrint:Box(1020,1100,1120,1600)
	oPrint:Say(1040,1110,"BAIRRO",oFont08 ,100)
	oPrint:Say(1080,1110,AllTrim(xBairDest),oFont08b ,880)

	oPrint:Box(1020,1600,1120,1850)
	oPrint:Say(1040,1610,"CEP",oFont08 ,100)
	oPrint:Say(1080,1610,AllTrim(xCepDest),oFont08b ,880)

	oPrint:Box(1020,1850,1120,2320)
	oPrint:Say(1040,1860,"DATA DA CARTA DE CORREÇÃO",oFont08 ,100)
	_dDtEvento := SubStr(MDHEVENTO,9,2)+"/"+SubStr(MDHEVENTO,6,2)+"/"+SubStr(MDHEVENTO,3,2)
	oPrint:Say(1080,1860,_dDtEvento,oFont08b ,880)
//oPrint:Say(1080,1860,MDATE_EVEN,oFont08b ,880)

	oPrint:Box(1120,100,1220,850)
	oPrint:Say(1140,110,"MUNICIPIO",oFont08 ,100)
	oPrint:Say(1180,110,AllTrim(xMunDest),oFont08b ,880)

	oPrint:Box(1120,850,1220,950)
	oPrint:Say(1140,860,"UF",oFont08 ,100)
	oPrint:Say(1180,860,AllTrim(xUFDest),oFont08b ,880)

	oPrint:Box(1120,950,1220,1350)
	oPrint:Say(1140,960,"TELEFONE",oFont08 ,100)
	oPrint:Say(1180,960,AllTrim(xTelDest),oFont08b ,880)

	oPrint:Box(1120,1350,1220,1850)
	oPrint:Say(1140,1360,"INSCRIÇÃO ESTADUAL",oFont08 ,100)
	oPrint:Say(1180,1360,AllTrim(xIEDest),oFont08b ,880)

	oPrint:Box(1120,1850,1220,2320)
	oPrint:Say(1140,1860,"HORA DA CARTA DE CORREÇÃO",oFont08 ,100)
	_HrEvento := SubStr(MDHEVENTO,12,8)
	oPrint:Say(1180,1860,_HrEvento,oFont08b ,880)
//oPrint:Say(1180,1860,MTIME_EVEN,oFont08b ,880)

	oPrint:Say(1250,110,"CORREÇÕES",oFont09b ,100)
	oPrint:Box(1290,100,1750,2320)	//Correções
	nLin := 1290
	FOR _nPos := 1 TO LEN(aCorrec)
		nLin += 40
		oPrint:Say(nLin,110,aCorrec[_nPos],oFont08 ,2000)
	NEXT

///
///Deixei um gap de 4 linhas para o texto - se o texto for maior terá que alterar a linha onde comeca a Condicao de Uso
///
	oPrint:Say(1780,110,"CONDIÇÕES DE USO",oFont09b ,100)
	oPrint:Box(1820,100,2250,2320)	//Condições de Uso
	nLin := 1820
	FOR _nPos := 1 TO LEN(aCondic)
		nLin += 40
		oPrint:Say(nLin,110,aCondic[_nPos],oFont08 ,2000)
	NEXT

	oPrint:Say(3200,000,PADC(MAMBIENTE,140),oFont08)


	oPrint:EndPage()

	oPrint:Preview()


	TcSetConn(_nTopProtheus) // Utilize essa função para alternar entre as conexões


Return .F.

/////////////////////////////////////////////////////////
Static Function ValidPerg()
/////////////////////////////////////////////////////////
	_sAlias := Alias()
	DbSelectArea("SX1")
	DbSetOrder(1)
	aRegs :={} //Grupo|Ordem| Pegunt                         | perspa | pereng | VariaVL  | tipo| Tamanho|Decimal| Presel| GSC | Valid         |   var01   | Def01          | DefSPA1 | DefEng1 | CNT01 | var02 | Def02           | DefSPA2 | DefEng2 | CNT02 | var03 | Def03    | DefSPA3 | DefEng3 | CNT03 | var04 | Def04 | DefSPA4 | DefEng4 | CNT04 | var05 | Def05 | DefSPA5 | DefEng5 | CNT05 | F3    | GRPSX5 |
	aAdd(aRegs,{ cPerg,"01" , "Série NF ?                   ",   ""   ,  ""    , "mv_ch1" , "C" ,   03   ,   0   ,   0   , "G" , "          "  , "mv_par01", "            " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "      " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
	aAdd(aRegs,{ cPerg,"02" , "Nota Fiscal ?                ",   ""   ,  ""    , "mv_ch2" , "C" ,   09   ,   0   ,   0   , "G" , "          "  , "mv_par02", "            " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "      " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
	For i:=1 to Len(aRegs)
		If !DbSeek(cPerg+aRegs[i,2])
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
Return
