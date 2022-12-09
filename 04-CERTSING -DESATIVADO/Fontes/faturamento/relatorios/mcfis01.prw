#include "PROTHEUS.CH"
#include "RWMAKE.CH"
#include "MATR968.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MATR968   ºAutor  ³                    º Data ³  03/08/2006 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao do RPS - Recibo Provisorio de Servicos - referenteº±±
±±º          ³ao processo da Nota Fiscal Eletronica de Sao Paulo.         º±±
±±º          ³Impressao grafica - sem integracao com word.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Sigafis                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MCFIS01()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local wnrel
Local tamanho		:= "G"
Local titulo		:= STR0001 //"Impressão RPS"
Local cDesc1		:= STR0002 //"Impressão do Recibo Provisório de Serviços - RPS"
Local cDesc2		:= " "
Local cDesc3		:= " "
Local cTitulo		:= ""
Local cErro			:= ""
Local cSolucao		:= ""

Local lPrinter		:= .T.
Local lOk			:= .F.
Local aSays     	:= {}, aButtons := {}, nOpca := 0

Private nomeprog 	:= "MATR968"
Private nLastKey 	:= 0
Private cPerg

Private oPrint

cString := "SF2"
wnrel   := "MATR968"
cPerg   := "MTR968"

AjustaSX1()
Pergunte(cPerg,.F.)

AADD(aSays,STR0002) //"Impressão do Recibo Provisório de Serviços - RPS"

AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
AADD(aButtons, { 1,.T.,{|| nOpca := 1, FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|| nOpca := 0, FechaBatch() }} )

FormBatch( Titulo, aSays, aButtons,, 160 )

If nOpca == 0
   Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Configuracoes para impressao grafica³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint := TMSPrinter():New(STR0001)		//"Impressão RPS"
oPrint:SetPortrait()					// Modo retrato
oPrint:SetPaperSize(9)					// Papel A4

If nLastKey = 27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| Mt968Print(@lEnd,wnRel,cString)},Titulo)

oPrint:Preview()  		// Visualiza impressao grafica antes de imprimir

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Mt968Print³ Autor ³ Mary C. Hergert       ³ Data ³ 03/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Chamada do Processamento do Relatorio                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATR968                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Mt968Print(lEnd,wnRel,cString)

Local aAreaRPS		:= {}
Local aPrintServ	:= {}
Local aPrintObs		:= {}
Local aTMS			:= {}

Local cServ			:= ""
Local cDescrServ	:= ""
Local cCNPJCli		:= ""
Local cTime			:= ""
Local cNfeServ		:= SuperGetMv("MV_NFESERV",.F.,"")
Local cLogo			:= ""
Local cServPonto	:= ""
Local cObsPonto		:= ""
Local cAliasSF3		:= "SF3"
Local cCli			:= ""
Local cIMCli		:= ""
Local cEndCli		:= ""
Local cBairrCli		:= ""
Local cCepCli		:= ""
Local cMunCli		:= ""
Local cUFCli		:= ""
Local cEmailCli		:= ""
Local cCampos		:= ""

Local lIssMat		:= (cAliasSF3)->(FieldPos("F3_ISSMAT")) > 0
Local lDescrNFE		:= ExistBlock("MTDESCRNFE")
Local lObsNFE		:= ExistBlock("MTOBSNFE")
Local lCliNFE		:= ExistBlock("MTCLINFE")

Local nValDed		:= 0
Local nCopias		:= mv_par07
Local nLinIni		:= 225
Local nColIni		:= 225
Local nColFim		:= 2175
Local nLinFim		:= 2975
Local nX			:= 1
Local nY			:= 1
Local nLinha		:= 0

Local oFont10 	:= TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)	//Normal s/negrito
Local oFont10n	:= TFont():New("Courier New",10,10,,.T.,,,,.T.,.F.)	//Negrito
Local oFont12n	:= TFont():New("Courier New",12,12,,.T.,,,,.T.,.F.)	//Negrito

#IFDEF TOP
	Local cQuery    := ""
#ELSE
	Local cChave    := ""
	Local cFiltro   := ""
#ENDIF

dbSelectArea("SF3")
dbSetOrder(6)

#IFDEF TOP

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Campos que serao adicionados a query somente se existirem na base³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lIssMat
    	cCampos := " ,F3_ISSMAT "
	Endif

	If Empty(cCampos)
		cCampos := "%%"
	Else
		cCampos := "% " + cCampos + " %"
	Endif

    If TcSrvType()<>"AS/400"

		lQuery 		:= .T.
		cAliasSF3	:= GetNextAlias()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se imprime ou nao os documentos cancelados³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par08 == 2
			cQuery := "% SF3.F3_DTCANC = '' AND %"
		Else
			cQuery := "%%"
		Endif

		BeginSql Alias cAliasSF3
			COLUMN F3_ENTRADA AS DATE
			COLUMN F3_EMISSAO AS DATE
			COLUMN F3_DTCANC AS DATE
			COLUMN F3_EMINFE AS DATE
			SELECT F3_FILIAL,F3_ENTRADA,F3_EMISSAO,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_PDV,
				F3_LOJA,F3_ALIQICM,F3_BASEICM,F3_VALCONT,F3_TIPO,F3_VALICM,F3_ISSSUB,F3_ESPECIE,
				F3_DTCANC,F3_CODISS,F3_OBSERV,F3_NFELETR,F3_EMINFE,F3_CODNFE,F3_CREDNFE
				%Exp:cCampos%

			FROM %table:SF3% SF3

			WHERE SF3.F3_FILIAL = %xFilial:SF3% AND
				SF3.F3_CFO >= '5' AND
				SF3.F3_ENTRADA >= %Exp:mv_par01% AND
				SF3.F3_ENTRADA <= %Exp:mv_par02% AND
				SF3.F3_TIPO = 'S' AND
				SF3.F3_CODISS <> %Exp:Space(TamSX3("F3_CODISS")[1])% AND
				SF3.F3_CLIEFOR >= %Exp:mv_par03% AND
				SF3.F3_CLIEFOR <= %Exp:mv_par04% AND
				SF3.F3_NFISCAL >= %Exp:mv_par05% AND
				SF3.F3_NFISCAL <= %Exp:mv_par06% AND
				%Exp:cQuery%
				SF3.%NotDel%

			ORDER BY SF3.F3_ENTRADA,SF3.F3_SERIE,SF3.F3_NFISCAL,SF3.F3_TIPO,SF3.F3_CLIEFOR,SF3.F3_LOJA
		EndSql

		dbSelectArea(cAliasSF3)
	Else

#ENDIF
		cArqInd	:=	CriaTrab(NIL,.F.)
		cChave	:=	"DTOS(F3_ENTRADA)+F3_SERIE+F3_NFISCAL+F3_TIPO+F3_CLIEFOR+F3_LOJA"
		cFiltro := "F3_FILIAL == '" + xFilial("SF3") + "' .And. "
		cFiltro += "F3_CFO >= '5" + SPACE(LEN(F3_CFO)-1) + "' .And. "
		cFiltro += "DtOs(F3_ENTRADA) >= '" + Dtos(mv_par01) + "' .And. "
		cFiltro	+= "DtOs(F3_ENTRADA) <= '" + Dtos(mv_par02) + "' .And. "
		cFiltro	+= "F3_TIPO == 'S' .And. F3_CODISS <> '" + Space(Len(F3_CODISS)) + "' .And. "
		cFiltro	+= "F3_CLIEFOR >= '" + mv_par03 + "' .And. F3_CLIEFOR <= '" + mv_par04 + "' .And. "
		cFiltro	+= "F3_NFISCAL >= '" + mv_par05 + "' .And. F3_NFISCAL <= '" + mv_par06 + "'"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se imprime ou nao os documentos cancelados³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par08 == 2
			cFiltro	+= " .And. Empty(F3_DTCANC)"
		Endif

		IndRegua(cAliasSF3,cArqInd,cChave,,cFiltro,STR0006)  //"Selecionando Registros..."
		#IFNDEF TOP
			DbSetIndex(cArqInd+OrdBagExt())
		#ENDIF
		(cAliasSF3)->(dbGotop())
		SetRegua(LastRec())

#IFDEF TOP
	Endif
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime os RPS gerados de acordo com o numero de copias selecionadas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While (cAliasSF3)->(!Eof())

	ProcRegua()
	If Interrupcao(@lEnd)
	    Exit
 	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Analisa Deducoes do ISS  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nValDed += (cAliasSF3)->F3_ISSSUB

	If lIssMat
		nValDed += (cAliasSF3)->F3_ISSMAT
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Busca o SF2 para verificar o horario de emissao do documento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SF2->(dbSetOrder(1))
	cTime := ""
	If SF2->(dbSeek(xFilial("SF2")+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA))
		cTime := Transform(SF2->F2_HORA,"@R 99:99")

		// NF Cupom nao sera processada
		If !Empty(SF2->F2_NFCUPOM)
			(cAliasSF3)->(dbSKip())
			Loop
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Busca a descricao do codigo de servicos³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cDescrServ := ""
	SX5->(dbSetOrder(1))
	If SX5->(dbSeek(xFilial("SX5")+"60"+(cAliasSF3)->F3_CODISS))
		cDescrServ := SX5->X5_DESCRI
	Endif
	cCodServ := Alltrim((cAliasSF3)->F3_CODISS) + " - " + cDescrServ

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Busca o pedido para discriminar os servicos prestados no documento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cServ := ""
	If cNfeServ == "1"
		SC6->(dbSetOrder(4))
		SC5->(dbSetOrder(1))
		If SC6->(dbSeek(xFilial("SC6")+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE))
			If SC5->(dbSeek(xFilial("SC5")+SC6->C6_NUM))
				cServ := SC5->C5_MENNOTA
			Endif
		Endif
	Endif
	If Empty(cServ)
		cServ := cDescrServ
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ponto de entrada para compor a descricao a ser apresentada³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAreaRPS	:= (cAliasSF3)->(GetArea())
	cServPonto	:= ""
	If lDescrNFE
		cServPonto := Execblock("MTDESCRNFE",.F.,.F.,{(cAliasSF3)->F3_NFISCAL,(cAliasSF3)->F3_SERIE,(cAliasSF3)->F3_CLIEFOR,(cAliasSF3)->F3_LOJA})
	Endif
	RestArea(aAreaRPS)
	If !(Empty(cServPonto))
		cServ := cServPonto
	Endif
	aPrintServ	:= Mtr968Mont(cServ,13,999)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ponto de entrada para complementar as observacoes a serem apresentadas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cObserv 	:= Alltrim((cAliasSF3)->F3_OBSERV) + Iif(!Empty((cAliasSF3)->F3_OBSERV)," | ","")
	cObserv 	+= Iif(!Empty((cAliasSF3)->F3_PDV) .And. Alltrim((cAliasSF3)->F3_ESPECIE) == "CF",STR0042 + " | ","")
	aAreaRPS 	:= (cAliasSF3)->(GetArea())
	cObsPonto	:= ""
	If lObsNFE
		cObsPonto := Execblock("MTOBSNFE",.F.,.F.,{(cAliasSF3)->F3_NFISCAL,(cAliasSF3)->F3_SERIE,(cAliasSF3)->F3_CLIEFOR,(cAliasSF3)->F3_LOJA})
	Endif
	RestArea(aAreaRPS)
	cObserv 	:= cObserv + cObsPonto
	aPrintObs	:= Mtr968Mont(cObserv,11,675)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica o cLiente/fornecedor do documento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cCNPJCli := ""
	SA1->(dbSetOrder(1))
	If SA1->(dbSeek(xFilial("SA1")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA))
		If RetPessoa(SA1->A1_CGC) == "F"
			cCNPJCli := Transform(SA1->A1_CGC,"@R 999.999.999-99")
		Else
			cCNPJCli := Transform(SA1->A1_CGC,"@R 99.999.999/9999-99")
		Endif
		cCli		:= SA1->A1_NOME
		cIMCli		:= ''//SA1->A1_INSCRM
		cEndCli		:= ''//SA1->A1_END
		cBairrCli	:= ''//SA1->A1_BAIRRO
		cCepCli		:= ''//SA1->A1_CEP
		cMunCli		:= ''//SA1->A1_MUN
		cUFCli		:= ''//SA1->A1_EST
		cEmailCli	:= ''//SA1->A1_EMAIL
	Else
		(cAliasSF3)->(dbSKip())
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Funcao que retorna o endereco do solicitante quando houver integracao com TMS³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If IntTms()
		aTMS := TMSInfSol((cAliasSF3)->F3_FILIAL,(cAliasSF3)->F3_NFISCAL,(cAliasSF3)->F3_SERIE)
		If Len(aTMS) > 0
			cCli		:= aTMS[04]
			If RetPessoa(Alltrim(aTMS[01])) == "F"
				cCNPJCli := Transform(Alltrim(aTMS[01]),"@R 999.999.999-99")
			Else
				cCNPJCli := Transform(Alltrim(aTMS[01]),"@R 99.999.999/9999-99")
			Endif
			cIMCli		:= ''//aTMS[02]
			cEndCli		:= ''//aTMS[05]
			cBairrCli	:= ''//aTMS[06]
			cCepCli		:= ''//aTMS[09]
			cMunCli		:= ''//aTMS[07]
			cUFCli		:= ''//aTMS[08]
			cEmailCli	:= ''//aTMS[10]
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ponto de entrada para trocar o cliente a ser impresso.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lCliNFE
		aMTCliNfe := Execblock("MTCLINFE",.F.,.F.,{SF3->F3_NFISCAL,SF3->F3_SERIE,SF3->F3_CLIEFOR,SF3->F3_LOJA})
		// O ponto de entrada somente e utilizado caso retorne todas as informacoes necessarias
		If Len(aMTCliNfe) >= 12
			cCli		:= aMTCliNfe[01]
			cCNPJCli	:= aMTCliNfe[02]
			If RetPessoa(cCNPJCli) == "F"
				cCNPJCli := Transform(cCNPJCli,"@R 999.999.999-99")
			Else
				cCNPJCli := Transform(cCNPJCli,"@R 99.999.999/9999-99")
			Endif
			cIMCli		:= ''//aMTCliNfe[03]
			cEndCli		:= ''//aMTCliNfe[04]
			cBairrCli	:= ''//aMTCliNfe[05]
			cCepCli		:= ''//aMTCliNfe[06]
			cMunCli		:= ''//aMTCliNfe[07]
			cUFCli		:= ''// aMTCliNfe[08]
			cEmailCli	:= ''//aMTCliNfe[09]
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Relatorio Grafico:                                                                                      ³
	//³* Todas as coordenadas sao em pixels	                                                                   ³
	//³* oPrint:Line - (linha inicial, coluna inicial, linha final, coluna final)Imprime linha nas coordenadas ³
	//³* oPrint:Say(Linha,Coluna,Valor,Picture,Objeto com a fonte escolhida)		                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 to nCopias

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Box no tamanho do RPS³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oPrint:Line(nLinIni,nColIni,nLinIni,nColFim)
		oPrint:Line(nLinIni,nColIni,nLinFim,nColIni)
		oPrint:Line(nLinIni,nColFim,nLinFim,nColFim)
		oPrint:Line(nLinFim,nColIni,nLinFim,nColFim)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Dados da empresa emitente do documento³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cLogo := FisxLogo("1")
		oPrint:SayBitmap(375,nColIni+10,cLogo,400,090) // o arquivo com o logo deve estar abaixo do rootpath (mp8\system)
		oPrint:Line(nLinIni,1800,612,1800)
		oPrint:Line(354,1800,354,nColFim)
		oPrint:Line(483,1800,483,nColFim)
		oPrint:Line(612,nColIni,612,nColFim)
		oPrint:Say(245,730,PadC(Alltrim(SM0->M0_NOMECOM),40),oFont12n)
		oPrint:Say(305,680,PadC(Alltrim(SM0->M0_ENDENT),50),oFont10)
		oPrint:Say(355,680,PadC(Alltrim(Alltrim(SM0->M0_BAIRENT) + " - " + Transform(SM0->M0_CEPENT,"@R 99.999-999")),50),oFont10)
		oPrint:Say(405,680,PadC(Alltrim(SM0->M0_CIDENT) + " - " + Alltrim(SM0->M0_ESTENT),50),oFont10)
		oPrint:Say(455,680,PadC(Alltrim(STR0013) + Alltrim(SM0->M0_TEL),50),oFont10) // Telefone:
		oPrint:Say(505,680,PadC(Alltrim(STR0014) + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"),50),oFont10) // C.N.P.J.::
		oPrint:Say(555,680,PadC(Alltrim(STR0015) + Alltrim(SM0->M0_INSC),50),oFont10) // I.E.:

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Informacoes sobre a emissao do RPS³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oPrint:Say(250,1830,PadC(Alltrim(STR0016),15),oFont10n) // "Número/Série RPS"
		oPrint:Say(295,1830,PadC(Alltrim(Alltrim((cAliasSF3)->F3_NFISCAL) + Iif(!Empty((cAliasSF3)->F3_SERIE)," / " + Alltrim((cAliasSF3)->F3_SERIE),"")),15),oFont10)
		oPrint:Say(375,1830,PadC(Alltrim(STR0017),15),oFont10n) // "Data Emissão"
		oPrint:Say(420,1830,PadC((cAliasSF3)->F3_EMISSAO,15),oFont10)
		oPrint:Say(510,1830,PadC(Alltrim(STR0018),15),oFont10n) // "Hora Emissão"
		oPrint:Say(555,1830,PadC(Alltrim(cTime),15),oFont10)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Dados do destinatario³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oPrint:Say(625,nColIni,PadC(Alltrim(STR0019),75),oFont12n) // "DADOS DO DESTINATÁRIO"
		oPrint:Say(685,250,STR0020,oFont10n) // "Nome/Razão Social:"
		oPrint:Say(745,250,STR0021,oFont10n) // "C.P.F./C.N.P.J.:"
		oPrint:Say(805,250,STR0022,oFont10n) // "Inscrição Municipal:"
		oPrint:Say(865,250,STR0024,oFont10n) // "Endereço:"
		oPrint:Say(925,250,STR0025,oFont10n) // "CEP:"
		oPrint:Say(985,250,STR0026,oFont10n) // "Município:"
		oPrint:Say(985,1800,STR0028,oFont10n) // "UF:"
		oPrint:Say(1045,250,STR0027,oFont10n) // "E-mail:"
		oPrint:Say(685,750,Alltrim(cCli),oFont10)
		oPrint:Say(745,750,Alltrim(cCNPJCli),oFont10)
		oPrint:Say(805,750,Alltrim(cIMCli),oFont10)
		oPrint:Say(865,750,Alltrim(cEndCli) + " - " + Alltrim(cBairrCli) ,oFont10)
		oPrint:Say(925,750,Transform(cCepCli,"@R 99.999-999"),oFont10)
		oPrint:Say(985,750,Alltrim(cMunCli),oFont10)
		oPrint:Say(985,1900,Alltrim(cUFCli),oFont10)
		oPrint:Say(1045,750,Alltrim(cEmailCli),oFont10)
		oPrint:Line(1105,nColIni,1105,nColFim)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Discriminacao dos Servicos ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oPrint:Say(1118,nColIni,PadC(Alltrim(STR0029),75),oFont12n) // "DISCRIMINAÇÃO DOS SERVIÇOS"
		nLinha	:= 1178
		For nY := 1 to Len(aPrintServ)
			If nY > 15
				Exit
			Endif
			oPrint:Say(nLinha,250,Alltrim(aPrintServ[nY]),oFont10)
			nLinha 	:= nLinha + 45
		Next
		oPrint:Line(1850,nColIni,1850,nColFim)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Valores da prestacao de servicos³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oPrint:Say(1880,nColIni,PadC(Alltrim(STR0030),50),oFont12n) // "VALOR TOTAL DA PRESTAÇÃO DE SERVIÇOS"
		oPrint:Say(1885,1700,"R$ " + Transform((cAliasSF3)->F3_VALCONT,"@E 999,999,999.99"),oFont10)
		oPrint:Line(1950,nColIni,1950,nColFim)
		oPrint:Say(1965,250,Alltrim(STR0031),oFont10n) // "Código do Serviço"
		oPrint:Say(2005,250,Alltrim(cCodServ),oFont10)
		oPrint:Line(2050,nColIni,2050,nColFim)
		oPrint:Line(2050,712,2150,712)
		oPrint:Line(2050,1199,2150,1199)
		oPrint:Line(2050,1686,2150,1686)
		oPrint:Say(2065,250,Alltrim(STR0032),oFont10n) // "Total deduções (R$)"
		oPrint:Say(2105,370,Transform(nValDed,"@E 999,999,999.99"),oFont10)
		oPrint:Say(2065,737,Alltrim(STR0033),oFont10n) // "Base de cálculo (R$)"
		oPrint:Say(2105,857,Transform((cAliasSF3)->F3_BASEICM,"@E 999,999,999.99"),oFont10)
		oPrint:Say(2065,1224,Alltrim(STR0034),oFont10n) // "Alíquota (%)"
		oPrint:Say(2105,1344,Transform((cAliasSF3)->F3_ALIQICM,"@E 999,999,999.99"),oFont10)
		oPrint:Say(2065,1711,Alltrim(STR0035),oFont10n) // "Valor do ISS (R$)"
		oPrint:Say(2105,1831,Transform((cAliasSF3)->F3_VALICM,"@E 999,999,999.99"),oFont10)
		oPrint:Line(2150,nColIni,2150,nColFim)
		oPrint:Say(2180,nColIni,PadC(Alltrim(STR0036),75),oFont12n) // "INFORMAÇÕES SOBRE A NOTA FISCAL ELETRÔNICA"
		oPrint:Line(2250,nColIni,2250,nColFim)
		oPrint:Line(2250,712,2350,712)
		oPrint:Line(2250,1199,2350,1199)
		oPrint:Line(2250,1686,2350,1686)
		oPrint:Say(2265,250,Alltrim(STR0037),oFont10n) // "Número"
		oPrint:Say(2305,370,Padl((cAliasSF3)->F3_NFELETR,14),oFont10)
		oPrint:Say(2265,737,Alltrim(STR0038),oFont10n) // "Emissão"
		oPrint:Say(2305,857,Padl(Transform(dToC((cAliasSF3)->F3_EMINFE),"@d"),14),oFont10)
		oPrint:Say(2265,1224,Alltrim(STR0039),oFont10n) // "Código Verificação"
		oPrint:Say(2305,1334,Padl(Transform((cAliasSF3)->F3_CODNFE,"@R !!!!-!!!!"),14),oFont10)
		oPrint:Say(2265,1711,Alltrim(STR0040),oFont10n) // "Crédito IPTU"
		oPrint:Say(2305,1831,Transform((cAliasSF3)->F3_CREDNFE,"@E 999,999,999.99"),oFont10)
		oPrint:Line(2350,nColIni,2350,nColFim)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Outras Informacoes³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oPrint:Say(2363,nColIni,PadC(Alltrim(STR0041),75),oFont12n) // "OUTRAS INFORMAÇÕES"
		nLinha	:= 2423
		For nY := 1 to Len(aPrintObs)
			If nY > 11
				Exit
			Endif
			oPrint:Say(nLinha,250,Alltrim(aPrintObs[nY]),oFont10)
			nLinha 	:= nLinha + 50
		Next
		oPrint:Line(1850,nColIni,1850,nColFim)

		If nCopias > 1 .And. nX < nCopias
			oPrint:EndPage()
		Endif

	Next
	(cAliasSF3)->(dbSkip())

	If !((cAliasSF3)->(Eof()))
		oPrint:EndPage()
	Endif

Enddo

If !lQuery
	RetIndex("SF3")
	dbClearFilter()
	Ferase(cArqInd+OrdBagExt())
Else
	dbSelectArea(cAliasSF3)
	dbCloseArea()
Endif

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTR948Str ºAutor  ³                    º Data ³ 03/08/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Montar o array com as strings a serem impressas na descr.   º±±
±±º          ³dos servicos e nas observacoes.                             º±±
±±º          ³Se foi uma quebra forcada pelo ponto de entrada, e          º±±
±±º          ³necessario manter a quebra. Caso contrario, montamos a linhaº±±
±±º          ³de cada posicao do array a ser impressa com o maximo de     º±±
±±º          ³caracteres permitidos.                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³Array com os campos da query                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³cString: string completa a ser impressa                     º±±
±±º          ³nLinhas: maximo de linhas a serem impressas                 º±±
±±º          ³nTotStr: tamanho total da string em caracteres              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³MATR968                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Mtr968Mont(cString,nLinhas,nTotStr)

Local aAux		:= {}
Local aPrint	:= {}

Local cMemo 	:= ""
Local cAux		:= ""

Local nX		:= 1
Local nY 		:= 1
Local nPosi		:= 1

cString := SubStr(cString,1,nTotStr)

For nY := 1 to Min(MlCount(cString,86),nLinhas)

	cMemo := MemoLine(cString,86,nY)

	// Monta a string a ser impressa ate a quebra
	Do While .T.
		nPosi 	:= At("|",cMemo)
		If nPosi > 0
			Aadd(aAux,{SubStr(cMemo,1,nPosi-1),.T.})
			cMemo 	:= SubStr(cMemo,nPosi+1,Len(cMemo))
		Else
			If !Empty(cMemo)
				Aadd(aAux,{cMemo,.F.})
			Endif
			Exit
		Endif
	Enddo
Next

For nY := 1 to Len(aAux)
	cMemo := ""
	If aAux[nY][02]
		Aadd(aPrint,aAux[nY][01])
	Else
		cMemo += Alltrim(aAux[nY][01]) + Space(01)
		Do While !aAux[nY][02]
			nY += 1
			If nY > Len(aAux)
				Exit
			Endif
			cMemo += Alltrim(aAux[nY][01]) + Space(01)
		Enddo
		For nX := 1 to Min(MlCount(cMemo,86),nLinhas)
			cAux := MemoLine(cMemo,86,nX)
		   	Aadd(aPrint,cAux)
		Next
	Endif
Next

Return(aPrint)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AjustaSX1 ³ Autor ³                       ³ Data ³05/07/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria as perguntas necessarias a impressao do RPS            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATR968                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1()
Local 	aAreaSX1	:= SX1->(GetArea())

SX1->(dbSetOrder(1))
If SX1->(dbSeek("MTR968    05"))
	If SX1->X1_TAMANHO <> TamSx3("F3_NFISCAL")[1]
    	RecLock("SX1",.F.)
		SX1->X1_TAMANHO := TamSx3("F3_NFISCAL")[1]
    	SX1->(MSUnlock())
	Endif
Endif

If SX1->(dbSeek("MTR968    06"))
	If SX1->X1_TAMANHO <> TamSx3("F3_NFISCAL")[1]
    	RecLock("SX1",.F.)
	    SX1->X1_TAMANHO := TamSx3("F3_NFISCAL")[1]
    	SX1->(MSUnlock())
	Endif
Endif

RestArea(aAreaSX1)
Return(.T.)
