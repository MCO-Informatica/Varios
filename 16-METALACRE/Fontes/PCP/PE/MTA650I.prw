#include 'Protheus.ch'
#INCLUDE "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO8     ºAutor  ³Microsiga           º Data ³  04/27/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTA650I()  
Local aAreaSC2    := SC2->(GetArea())
Local aAreaSC5    := SC5->(GetArea())
Local aAreaSC6    := SC6->(GetArea())
Local aAreaSC9    := SC9->(GetArea())
Local aAreaSB1    := SB1->(GetArea())
Local cNumOp 	  := SC2->C2_NUM
Local nI		  := 1

If cEmpAnt <> '01'
	Return
Endif


// Alimenta OP no Atendimento CALL CENTER - Luiz Alberto = 23-06-15
	
If SUB->(dbSetOrder(3), dbSeek(xFilial("SUB")+SC2->C2_NUM+SC2->C2_ITEM))
	If RecLock("SUB",.f.)
		SUB->UB_NUMOP	:=	SC2->C2_NUM
		SUB->UB_ITEMOP	:=	SC2->C2_ITEM
		SUB->(MsUnlock())
	Endif
Endif

// Muda Legenda no pedido de Vendas para Tem Ordem de Producao

If SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+SC2->C2_NUM))
	If RecLock("SC5",.F.)
		SC5->C5_TEMOP	:=	"S"
		SC5->(MsUnlock())
	Endif
Endif

If SC2->C2_XOP=="2" .AND. !Empty(Alltrim(SC2->C2_XLACRE ))
	&&	RptStatus( {||  Ajuste() }, "Aguarde...","Atualizando Lacres...", .T. )
	Ajuste()
Endif              

U_CargaPed(SC2->C2_NUM) // Ajusta Saldo Carga Fabrica Producao


// Grava Titulos Provisorios

If SC2->(dbSetOrder(1), dbSeek(xFilial("SC2")+cNumOP))
	cCond 		:= 	SC2->C2_XCONDPG
	cFornece	:=	SC2->C2_XFORNEC
	cLoja		:=	SC2->C2_XLOJA
	cDocto		:=	PadL(AllTrim(SC2->C2_NUM)+SC2->C2_ITEM,9,'0')
	dDtPrevi	:=	SC2->C2_DATPRF
	nTotal		:=	0.00
	
	SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
	
	While SC2->(!Eof()) .And. SC2->C2_FILIAL == xFilial("SC2") .And. SC2->C2_NUM == cNumOP
		If !Empty(SC2->C2_XFORNEC) .And. !Empty(SC2->C2_XPRSERV) .And. SC2->C2_SEQUEN = '001'
			// Ordem de Produção Beneficiamento, gera previas no contas a pagar
			nTotal		+=	Round(SC2->C2_QUANT * SC2->C2_XPRSERV,2)
		Endif
		
		SC2->(dbSkip(1))
	Enddo

	If !Empty(nTotal)
		If SE4->(dbSetOrder(1), dbSeek(xFilial("SE4")+cCond))
			aTitPar := Condicao( nTotal , cCond, 0,dDtPrevi,0.00)
			
			Begin Transaction
				
				cParc := Space(TamSX3("E2_PARCELA")[1])
				If Len(aTitPar) > 1
					cParc := StrZero(1,TamSX3("E2_PARCELA")[1])
				Endif
				
				For nI := 1 To Len(aTitPar)
					dbSelectArea("SE2")
					
					// Tratamento para Data de Vencimento
					// nao cair as segundas-feiras e dias 04,05,15,18,19 e 20
					
					dVencto := aTitPar[nI,1]
					nValor  := aTitPar[nI,2]
					
					// Geracao da Previa
					// Analista Thor
					
					If !SE2->(dbSetOrder(1), dbSeek(xFilial("SE2")+'PRE'+cDocto+cParc+'PRE'))
						If RecLock("SE2",.T.)
							SE2->E2_FILIAL	:=	xFilial("SE2")
							SE2->E2_PREFIXO	:= 'PRE'
							SE2->E2_NUM		:=	cDocto
							SE2->E2_PARCELA	:=	cParc
							SE2->E2_TIPO	:=	'PRE'
							SE2->E2_FORNECE	:=	cFornece
							SE2->E2_LOJA	:=	cLoja
							SE2->E2_EMIS1	:=	dDataBase
							SE2->E2_EMISSAO	:=	dDataBase
							SE2->E2_VENCTO	:=	dVencto
							SE2->E2_VENCREA	:=	dVencto
							SE2->E2_VENCORI	:=	dVencto
							SE2->E2_DATAAGE	:=	dVencto
							SE2->E2_CCUSTO	:=	Iif(Empty(SB1->B1_CC),SB1->B1_CC,'4.2.000.131')
							SE2->E2_HIST	:=	'PREV PREST.SERV.BEN.'
							SE2->E2_VALOR 	:= 	nValor
							SE2->E2_SALDO 	:= 	nValor
							SE2->E2_VLCRUZ	:= 	nValor
							SE2->E2_NOMFOR	:=	Posicione("SA2",1,xFilial("SA2")+cFornece+cLoja,"A2_NREDUZ")
							SE2->E2_MOEDA	:=	1
							SE2->E2_RATEIO	:=	'N'
							SE2->E2_OCORREN	:=	'01'
							SE2->E2_ORIGEM	:=	'FINA050 '
							SE2->E2_FLUXO	:=	'S'
							SE2->E2_DESDOBR	:=	'N'
							SE2->E2_FILORIG	:=	'01'
							SE2->E2_XAPROV	:=	'000040'
							SE2->E2_XCONAP	:=	'L'
							SE2->E2_NATUREZ	:=	'202015    '
							SE2->(MsUnlock())
						Endif
					Endif
					cParc := Soma1(cParc,TamSX3("E2_PARCELA")[1])
				Next
			
			End Transaction	
		Endif
	Endif
Endif

RestArea(aAreaSC2)
RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSC9)
RestArea(aAreaSB1)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA650I   ºAutor  ³Microsiga           º Data ³  05/15/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Ajuste()
Local cQry			:=''
Local aAreaSC2  	:= SC2->(GetArea())
Local nCont:=0
Local _cChave:=SC2->C2_XLACRE+SC2->C2_NUM+SC2->C2_ITEM

dbSelectArea("Z00")
Z00->(dbSetOrder(1))
If Z00->(dbSeek(xFilial("Z00")+Substr(_cChave,1,9) ))
	
	dbSelectArea("Z01")
	Z01->(dbSetOrder(1))
	If !Z01->(dbSeek(xFilial("Z01")+_cChave ))
		
		Z01->(RecLock("Z01",.T.))
		Z01->Z01_FILIAL	:= xFilial("Z01")
		Z01->Z01_COD	:= Substr(_cChave,1,9)
		Z01->Z01_PV		:= Substr(_cChave,10,6)
		Z01->Z01_ITEMPV	:= Substr(_cChave,16,2)
		Z01->Z01_INIC	:= Z00->Z00_LACRE
		Z01->Z01_FIM	:= Z00->Z00_LACRE + SC2->C2_QUANT -1
		Z01->Z01_STAT	:= "2"
		Z01->Z01_PROD	:=SC2->C2_PRODUTO
		Z01->Z01_OP		:=Substr(_cChave,10,6) 
		Z01->Z01_NUMERO := SOMA1(U_GETSOMA('Z01','Z01_NUMERO',,'Z01_FILIAL',XFILIAL("Z01"),,,,, 'M'))		
		If Z01->(FieldPos("Z01_LOGINT")) > 0
			Z01->Z01_LOGINT := UsrFullName(__cUserId)+' em '+DtoC(dDataBase)+' as '+Left(Time(),5)
		Endif
		Z01->(MsUnlock())
		
		Z00->(RecLock("Z00",.F.))
		Z00->Z00_LACRE := Z01->Z01_FIM +1
		Z00->(MsUnlock())
		
		If SC2->(dbSetOrder(1), dbSeek(xFilial("SC2")+Substr(_cChave,10,8)))
			If RecLock("SC2",.F.)
				SC2->C2_XLACINI:= Z01->Z01_INIC
				SC2->C2_XLACFIN := Z01->Z01_FIM
				SC2->(MsUnlock())
			Endif
		Endif
		
	Endif
	

Endif
//	IncRegua()

RestArea(aAreaSC2)
Return
