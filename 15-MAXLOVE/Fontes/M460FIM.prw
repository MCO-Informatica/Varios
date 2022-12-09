#include "rwmake.ch"
#include "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao   ³ Tratamento de Prioridade 						            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ MaxLove                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M460FIM()
Local aDados		:=	{}
Local cCNPJ         := ''
Local nValor		:= 0
Local cPedido		:= ""
Local _nVlrPri		:= 0
Local cPrf			:= ""
Local nItem
lOCAL nX
Local _cIdEnt
Private _nVlrPri	:= 0
Private aPArc		:= {}
Private cParcela	:= " "
Private	lMsErroAuto	:= .F.
Private lMsHelpAuto	:= .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Salva Areas de Trabalho        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aArea := _aAreaSF2 := _aAreaSD2 := _aAreaSA1 := _aAreaSA2 := _aAreaSC5 := _aAreaSB1 := {}

_aArea    := GetArea()
_aAreaSB1 := SB1->(GetArea())
_aAreaSF2 := SF2->(GetArea())
_aAreaSD2 := SD2->(GetArea())
_aAreaSA1 := SA1->(GetArea())
_aAreaSA2 := SA2->(GetArea())
_aAreaSC5 := SC5->(GetArea())
_aAreaSC6 := SC6->(GetArea())
_aAreaSF4 := SF4->(GetArea())
_aAreaSE1 := SE1->(GetArea())

cPedido := SC5->C5_NUM
cNota	:= SF2->F2_DOC
cSerie	:= SF2->F2_SERIE


If SC5->C5_XPRIORI <> "A"//== "B"  .OR. SC5->C5_XPRIORI == "C" .OR. SC5->C5_XPRIORI == "D"
	
	If cFilAnt == "0101"
		cPrf := "AT"
	Elseif cFilAnt == "0102"
		cPrf := "MA"
	ElseIf cFilAnt == "0103"
		cPrf := "DR"
	ElseIf cFilAnt == "0104"
		cPrf := "LK"
	ElseIf cFilAnt == "0105"
		cPrf := "EV"
	Endif
	
	_aArea := GetArea()
	aDadosSE1 := {}
	dbSelectArea("SE1")
	dbSetOrder(1)
	If dbSeek(xFilial("SE1")+SF2->F2_SERIE + SF2->F2_DOC)
		While !Eof() .And. SE1->E1_FILIAL == xFilial("SE1") .And. SE1->E1_NUM == SF2->F2_DOC .And.;
			SE1->E1_PREFIXO == SF2->F2_SERIE .And. SE1->E1_CLIENTE == SF2->F2_CLIENTE .And. SE1->E1_LOJA == SF2->F2_LOJA
			cSerie := SF2->F2_SERIE
			
			AAdd(aDadosSE1,{cPrf,;  	// 1
			SF2->F2_DOC,;				// 2
			SF2->F2_CLIENTE,;			// 3
			SF2->F2_LOJA,;				// 4
			SE1->E1_NATUREZ,;			// 5
			SE1->E1_EMISSAO,;			// 6
			SE1->E1_VENCTO,;			// 7
			SE1->E1_VENCREA,;			// 8
			SE1->E1_VALOR,;				// 9
			"VL ",;				        // 10
			SE1->E1_PARCELA,;			// 11
			SE1->E1_VEND1,;         	// 12
			SE1->E1_BASCOM1,;	        // 13
			SE1->E1_VALCOM1,;	        // 14
			SE1->E1_PEDIDO,;	        // 15
			SE1->E1_NOMCLI,;         	// 16
			SE1->E1_COMIS1})        	// 17
			
			dbSelectArea("SE1")
			dbSkip()
		End
	Endif
	RestArea(_aArea)
	
	If !Empty(Len(aDadosSE1))
		
		For nItem := 1 To Len(aDadosSE1)
			
			_nVlrPri:= xPreco(cPedido,cNota,cSerie)
			
			aPArc	:= Condicao(_nVlrPri,SF2->F2_COND,,dDataBase)
			
			If nItem <= Len(aParc)
				
				aDados := {}
				AADD( aDados, { "E1_FILIAL" 	, xFilial("SE1")		, Nil } )
				AADD( aDados, { "E1_PREFIXO" 	, cPrf					, Nil } )
				AADD( aDados, { "E1_NUM"     	, aDadosSE1[nItem,2]	, Nil } )
				AADD( aDados, { "E1_PARCELA"   	, aDadosSE1[nItem,11]	, Nil } )
				AADD( aDados, { "E1_TIPO"    	, aDadosSE1[nItem,10]	, Nil } )
				AADD( aDados, { "E1_CLIENTE"	, aDadosSE1[nItem,3]	, Nil } )
				AADD( aDados, { "E1_LOJA"    	, aDadosSE1[nItem,4]	, Nil } )
				AADD( aDados, { "E1_NATUREZ"    , aDadosSE1[nItem,5]	, Nil } )
				AADD( aDados, { "E1_EMISSAO"   	, aDadosSE1[nItem,6]	, Nil } )
				AADD( aDados, { "E1_VENCTO"    	, aPArc[nItem,1]			, Nil } )
				AADD( aDados, { "E1_VENCREA"   	, aPArc[nItem,1]			, Nil } )
				
				AADD( aDados, { "E1_VALOR"    	, aPArc[nItem,2] 			, nIL})//nValor , Nil } )
				AADD( aDados, { "E1_SALDO"    	, aPArc[nItem,2] 			, nIL})//nValor , Nil } )
				AADD( aDados, { "E1_PEDIDO"     , aDadosSE1[nItem,15]	, Nil } )
				AADD( aDados, { "E1_ORIGEM"   	, "PRIORI", Nil } )
				AADD( aDados, { "E1_HIST"    	, "B -> "+aDadosSE1[nItem,2]+"/"+aDadosSE1[nItem,1]	, Nil } )
				AADD( aDados, { "E1_VEND1"    	, aDadosSE1[nItem,12]	, Nil } )
				
				/* DESATIVADO TEMPORARIAMENTE 15/11/2021 RICARDO SOUZA
				lMsErroAuto 	:= .F.
				MSExecAuto({|x, y| FINA040(x,y)}, aDados, 3)
				
				If lMsErroAuto
					MostraErro()
				EndIf

				DESATIVADO TEMPORARIAMENTE 15/11/2021 RICARDO SOUZA*/

				_aAreaSE1 := GetArea()
				RecLock("SE1",.t.)
				SE1->E1_FILIAL		:=	xFilial("SE1")
				SE1->E1_PREFIXO		:=	cPrf
				SE1->E1_NUM			:=	aDadosSE1[nItem,2]
				SE1->E1_PARCELA		:=	aDadosSE1[nItem,11]
				SE1->E1_TIPO		:=	aDadosSE1[nItem,10]
				SE1->E1_NATUREZ		:=	aDadosSE1[nItem,5]
				SE1->E1_CLIENTE		:=	aDadosSE1[nItem,3]
				SE1->E1_LOJA		:=	aDadosSE1[nItem,4]
				SE1->E1_NOMCLI		:=	Posicione("SA1",1,xFilial("SA1")+aDadosSE1[nItem,3]+aDadosSE1[nItem,4],"A1_NREDUZ")
				SE1->E1_EMISSAO		:=	aDadosSE1[nItem,6]
				SE1->E1_VENCTO		:=	aParc[nItem,1]
				SE1->E1_VENCREA		:=	aParc[nItem,1]
				SE1->E1_VALOR		:=	aParc[nItem,2]
				SE1->E1_EMIS1		:=	aDadosSE1[nItem,6]
				SE1->E1_HIST		:=	"B -> "+aDadosSE1[nItem,2]+"/"+aDadosSE1[nItem,1]
				SE1->E1_SITUACA		:=	"0"
				SE1->E1_SALDO		:=	aParc[nItem,2]
				SE1->E1_VENCORI		:=	aParc[nItem,1]
				SE1->E1_MOEDA		:=	1
				SE1->E1_OCORREN		:=	"01"
				SE1->E1_PEDIDO		:=	aDadosSE1[nItem,15]
				SE1->E1_VLCRUZ		:=	aParc[nItem,2]
				SE1->E1_STATUS		:=	"A"
				SE1->E1_ORIGEM		:=	"PRIORI"
				SE1->E1_FLUXO		:=	"S"
				SE1->E1_TIPODES		:=	"1"
				SE1->E1_FILORIG		:=	cFilAnt
				SE1->E1_MULTNAT		:=	"2"
				SE1->E1_MSFIL		:=	cFilAnt
				SE1->E1_MSEMP		:=	"01"
				SE1->E1_PROJPMS		:=	"2"
				SE1->E1_DESDOBR		:=	"2"
				SE1->E1_MODSPB		:=	"1"
				SE1->E1_SCORGP		:=	"2"
				SE1->E1_RELATO		:=	"2"
				SE1->E1_TPDESC		:=	"C"
				SE1->E1_VLMINIS		:=	"1"
				SE1->E1_APLVLMN		:=	"1"
				SE1->E1_TCONHTL		:=	"3"
				SE1->E1_RATFIN		:=	"2"
				MsUnlock()

				RestArea(_aAreaSE1)
			EndIf
		Next
	Endif
Endif

cPedido := SC5->C5_NUM
cNota	:= SF2->F2_DOC
cSerie	:= SF2->F2_SERIE


//Gerar Bonus Vendas
If !Empty(SF2->F2_DUPL)
	U_GeraBonus(cFilAnt,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA)
EndIf

//---> Transmissão Automática 20/09/2022 - Lucas Baía (UPDUO)
If cFilAnt $ "0106"

	_cIdEnt := RetIdEnti() //RETORNA A ENTIDADE DE NF DE ACORDO COM A FILIAL.

	SpedNFeTrf("SF2",SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_DOC,_cIdEnt,"1","1","4.00",,,) // FUNÇÃO QUE TRANSMITE AUTOMÁTICA.

	MsgInfo("NOTA FISCAL acabou de ser transmitida!!! Por favor verifique no MONITOR FAIXA","ATENÇÃO") //EXIBE A MENSAGEM DIZENDO QUE A NOTA FOI TRANSMITIDA.

	U_MonitNFE( SF2->F2_SERIE, SF2->F2_DOC, SF2->F2_DOC,"SF2") //EXIBE A CONSULTA NFE DIZENDO QUE A NOTA FOI TRANSMITIDA OU NÃO.

	If SF2->F2_FIMP$"S" //----> NOTA AUTORIZADA
		Processa( {|| U_zGerDanfe("SF2")}, "Impressão DANFE", "Imprimindo DANFE...", .f.)
	else
		MsgInfo("Faça a impressão da DANFE daqui alguns minutos, pois a nota fiscal "+SF2->F2_SERIE+SF2->F2_DOC+" ainda não foi autorizada na SEFAZ.","ATENÇÃO") //EXIBE A MENSAGEM DIZENDO QUE A NOTA FOI TRANSMITIDA.    
	EndIf
ENDIF
//--->Fim da Customização

RestArea(_aAreaSF2)
RestArea(_aAreaSD2)
RestArea(_aAreaSA1)
RestArea(_aAreaSA2)
RestArea(_aAreaSC6)
RestArea(_aAreaSC5)
RestArea(_aAreaSB1)
RestArea(_aAreaSF4)
RestArea(_aArea)

Return

//Busca Condicao de
Static Function xPreco(cNum,cNota,cSerie)

Local _nQtdParc:= 0
Local _nVlrTot := 0
Local nX

//cQuery := "SELECT C6_QTDVEN,C6_PRCVEN2,C6_QTDVEN*C6_PRCVEN2 AS PRIORI FROM "+RetSqlName("SC6")+" C6 "
//cQuery += "Where C6.D_E_L_E_T_ = '' And C6_FILIAL = '"+xFilial("SC6")+"' And C6_NUM = '"+cNum+"' "


cQuery := "SELECT D2_QUANT,C6_QTDVEN,C6_PRCVEN2,D2_QUANT*C6_PRCVEN2 AS PRIORI FROM "+RetSqlName("SD2")+" D2 "
cQuery += "INNER JOIN "+RetSqlName("SC6")+" C6 ON D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM AND D2_FILIAL = C6_FILIAL AND C6.D_E_L_E_T_ = '' "
cQuery += "WHERE D2.D_E_L_E_T_ = '' And D2_FILIAL = '"+xFilial("SD2")+"' AND D2_PEDIDO = '"+cNum+"' AND D2_DOC = '"+cNota+"' AND D2_SERIE = '"+cSerie+"' "

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
Endif

TcQuery cQuery New Alias "TRB"

dbSelectArea("TRB")

While !Eof()
	
	_nVlrTot:=_nVlrTot+TRB->PRIORI
	
	dbSkip()
	
END

TRB->(DbCloseArea())


Return (_nVlrTot)
