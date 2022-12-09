#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFATR03  ³ Autor ³ GENILSON M LUCAS        ³ Data ³ 07/11/2010 ³±±
±±³          ³          ³       ³ MVG Consultoria Ltda    ³      ³            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Pedidos por Vendedor x Cliente (Consolidado)        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Polimet Industria Metalurgica Ltda                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador   ³  Data  ³              Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATR17()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatório de Estoque Diário"
Local cPict          := ""
Local titulo         := "Relatório de Estoque Diário"
Local nLin         	 := 80
Local imprime      	 := .T.
Local aOrd 			 := {"Por Grupo"}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RFATR17"
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RFATR17"
Private cString 	 := "SC6"
Private cPerg   	 := PADR("FATR17",LEN(SX1->X1_GRUPO))
Private nOrdem

Private Cabec1       	 := "CODIGO         DESCRIÇÃO                                 UM       SALDO      PEDIDO     PEDIDOS     PEDIDOS  DISPONIVEL     VENDIDO    FATURADO     VENDIDO        MEDIA    PREVISÃO      META X"
Private Cabec2       	 := "                                                                ESTOQUE      VENDAS   ATRASADOS  BLOQUEADOS    P/ VENDA      NO MÊS      NO MES    ENTR FUT      6 MESES      VENDAS   FATUR MES "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

dbSelectArea(cString)
dbSetOrder(1)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)
nOrdem:= aReturn[8]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  23/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

_Saldo := 0
//----> JANEIRO
If Month(DDATABASE) == 1
	
	_nDia  :=     1
	_nMes :=      2
	_nAno :=      Year(DDATABASE)
	
	_nMes2 :=	7
	_nAno2 :=   Year(DDATABASE) - 1
	_nDia3 :=   31
	_nMes3 :=	12
	_nAno3 :=   Year(DDATABASE) - 1
	
	//----> FEVEREIRO
ElseIf Month(DDATABASE) == 2
	
	_nDia  :=     1
	_nMes :=      3
	_nAno :=      Year(DDATABASE)
	
	_nMes2 :=	8
	_nAno2 :=   Year(DDATABASE) - 1
	_nDia3 :=   31
	_nMes3 :=	1
	_nAno3 :=   Year(DDATABASE)
	
	//----> MARCO
ElseIf Month(DDATABASE) == 3
	
	_nDia  :=     1
	_nMes :=      4
	_nAno :=      Year(DDATABASE)
	
	_nMes2 :=	9
	_nAno2 :=   Year(DDATABASE) - 1
	_nDia3 :=   28
	_nMes3 :=	2
	_nAno3 :=   Year(DDATABASE)
	
	//----> ABRIL
ElseIf Month(DDATABASE) == 4
	_nDia  :=     1
	_nMes :=      5
	_nAno :=      Year(DDATABASE)
	
	_nMes2 :=	10
	_nAno2 :=   Year(DDATABASE) - 1
	_nDia3 :=   31
	_nMes3 :=	3
	_nAno3 :=   Year(DDATABASE)
	
	//----> MAIO
ElseIf Month(DDATABASE) == 5
	_nDia  :=     1
	_nMes :=      6
	_nAno :=      Year(DDATABASE)
	
	_nMes2 :=	11
	_nAno2 :=   Year(DDATABASE) - 1
	_nDia3 :=   30
	_nMes3 :=	4
	_nAno3 :=   Year(DDATABASE)
	
	//----> JUNHO
ElseIf Month(DDATABASE) == 6
	_nDia  :=     1
	_nMes :=      7
	_nAno :=      Year(DDATABASE)
	
	_nMes2 :=	12
	_nAno2 :=   Year(DDATABASE) - 1
	_nDia3 :=   31
	_nMes3 :=	5
	_nAno3 :=   Year(DDATABASE)
	
	//----> JULHO
ElseIf Month(DDATABASE) == 7
	_nDia  :=     1
	_nMes :=      8
	_nAno :=      Year(DDATABASE)
	
	_nMes2 :=	1
	_nAno2 :=   Year(DDATABASE)
	_nDia3 :=   30
	_nMes3 :=	6
	_nAno3 :=   Year(DDATABASE)
	
	//----> AGOSTO
ElseIf Month(DDATABASE) == 8
	_nDia  :=     1
	_nMes :=      9
	_nAno :=      Year(DDATABASE)
	
	_nMes2 :=	2
	_nAno2 :=   Year(DDATABASE)
	_nDia3 :=   31
	_nMes3 :=	7
	_nAno3 :=   Year(DDATABASE)
	
	//----> SETEMBRO
ElseIf Month(DDATABASE) == 9
	_nDia  :=     1
	_nMes :=      10
	_nAno :=      Year(DDATABASE)
	
	_nMes2 :=	3
	_nAno2 :=   Year(DDATABASE)
	_nDia3 :=   31
	_nMes3 :=	8
	_nAno3 :=   Year(DDATABASE)
	
	//----> OUTUBRO
ElseIf Month(DDATABASE) == 10
	_nDia  :=     1
	_nMes :=      11
	_nAno :=      Year(DDATABASE)
	
	_nMes2 :=	4
	_nAno2 :=   Year(DDATABASE)
	_nDia3 :=   30
	_nMes3 :=	9
	_nAno3 :=   Year(DDATABASE)
	
	//----> NOVEMBRO
ElseIf Month(DDATABASE) == 11
	_nDia  :=     1
	_nMes :=      12
	_nAno :=      Year(DDATABASE)
	
	_nMes2 := 	5
	_nAno2 :=   Year(DDATABASE)
	_nDia3 :=   31
	_nMes3 :=	10
	_nAno3 :=   Year(DDATABASE)
	
	//----> DEZEMBRO
ElseIf Month(DDATABASE) == 12
	_nDia :=     1
	_nMes :=      1
	_nAno :=      Year(DDATABASE) + 1
	
	_nMes2 :=	6
	_nAno2 :=   Year(DDATABASE)
	_nDia3 :=   30
	_nMes3 :=   11
	_nAno3 :=   Year(DDATABASE)
EndIf

_cDataIni     	:= StrZero(_nAno,4)+StrZero(_nMes,2)+StrZero(_nDia,2)
_cDataMedi     	:= StrZero(_nAno2,4)+StrZero(_nMes2,2)+StrZero(_nDia,2)
_cDataMedf		:= StrZero(_nAno3,4)+StrZero(_nMes3,2)+StrZero(_nDia3,2)

_DataB		:= Ddatabase
_DataBini	:= transform(year(ddatabase), "@E 9999") + substr(dtoc(ddatabase),4,2) + "01"
_DataVen	:= Ddatabase - 180

_TSaldo		:= 0
_TVenda		:= 0
_Tatraso	:= 0
_TBloq		:= 0
_TVendido	:= 0
_TFaturado	:= 0
_TEFutura	:= 0
_TMediaF	:= 0
_TMeta		:= 0

_UMV		:= {}
_TSaldoV	:= {}
_TVendaV	:= {}
_TatrasoV	:= {}
_TBloqV		:= {}
_TVendidoV	:= {}
_TFaturadV	:= {}
_TEFuturaV	:= {}
_TMediaFV	:= {}
_TMetaV		:= {}
_Flag		:= .F.

DbSelectArea("SB1")
DbSetOrder(4)
DbSeek(xFilial("SB1") + MV_PAR14)
While !Eof()
	
	If  SB1->B1_GRUPO < MV_PAR14 .OR. SB1->B1_GRUPO > MV_PAR15 .OR. SB1->B1_TAB_IN <> "S" .or. SB1->B1_MSBLQL = "1"
		dbSelectArea("SB1")
		DBSkip()
		Loop
	EndIf
	
	If lAbortPrint
		@nLin,000		 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	_cChave1	:=	SB1->B1_GRUPO
	
	@ nLin, 000			PSAY "GRUPO ----> "+_cChave1+" - " +Posicione("SBM",1,xFilial("SBM")+_cChave1,"BM_DESC")
	nLin += 2
	
	While !Eof() .and. SB1->B1_GRUPO = _cChave1
		
		If  SB1->B1_GRUPO < MV_PAR14 .OR. SB1->B1_GRUPO > MV_PAR15 .OR. SB1->B1_TAB_IN <> "S" .or. SB1->B1_MSBLQL = "1"
			dbSelectArea("SB1")
			DBSkip()
			Loop
		EndIf
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		_cChave2	:= SB1->B1_COD
		
		DbSelectArea("SB2")
		DbSetOrder(1)
		DbSeek(xFilial("SB2")+_cChave2)
		While !Eof() .and. SB2->B2_COD = _cChave2 //.and. SB2->B2_LOCAL >= MV_PAR12 .AND. SB2->B2_LOCAL <= MV_PAR13
			
			_Saldo	+= SB2->B2_QATU
			
			DbSelectArea("SB2")
			DbSkip()
		EndDo
		
		@ nLin, 000			PSAY _cChave2
		@ nLin, Pcol()+001	PSAY Subs(SB1->B1_DESC,1,40)
		@ nLin, Pcol()+001	PSAY SB1->B1_UM
		@ nLin, Pcol()+003	PSAY _Saldo							Picture "@E 99,999.99"
		
		// BUSCA INFORMAÇÕES SOBRE A VENDA
		BuscaVenda()
		@ nLin, Pcol()+003  PSAY VENDA->C6_QTDVEN				Picture "@E 99,999.99"
		
		//ATRASO
		ATRASO()
		@ nLin, Pcol()+003  PSAY ATRASO->C6_QTDVEN							Picture "@E 99,999.99"
		
		//----  //CREDITO()
		BLOQ()
		@ nLin, Pcol()+003  PSAY BLOQ->C6_QTDVEN							Picture "@E 99,999.99"
		
		//DISPONVIEL PARA VENDA
		@ nLin, Pcol()+003  PSAY _Saldo - VENDA->C6_QTDVEN		Picture "@E 99,999.99"
		
		VENDIDO()
		@ nLin, Pcol()+003  PSAY VENDIDO->C6_QTDVEN 			Picture "@E 99,999.99"
		
		FATURADO()
		@ nLin, Pcol()+003  PSAY FATURADO->D2_QTDVEN 			Picture "@E 99,999.99"
		
		// ENTRAGA FUTURA
		EFUTURA()
		@ nLin, Pcol()+003  PSAY EFUTURA->C6_QTDVEN							Picture "@E 99,999.99"
		
		//MEDIA DOA ÚLTIMOS 6 MESES
		MEDIAF()
		@ nLin, Pcol()+003  PSAY MEDIAF->D2_QTDVEN / 3 			Picture "@E 99,999,999"
		
		//PREVISÃO DE VENDAS
		*&&DbSelectArea("SCT")
		&&DbOrderNickName("RFATR16X")
		&&DbSeek(xFilial("SCT") + dtos(Mv_Par11) + _cChave1  + _cChave2 )
		SC4->(DBSetOrder(1))
		If SC4->(DbSeek(xFilial('SC4') + _cChave2 + dTos(FirstDate(Mv_Par11))))
			@ nLin, Pcol()+003  PSAY SC4->C4_QUANT 			Picture "@E 99,999.99"
		Else
			@ nLin, Pcol()+003  PSAY 0 			Picture "@E 99,999.99"
		EndIf
		
		@ nLin, Pcol()+009  PSAY (FATURADO->D2_QTDVEN / SCT->CT_QUANT ) * 100 			Picture "@E 999"
		@ nLin, Pcol()+000  PSAY " %"
		
		nLin++
		
		//SOMA TOTAL DO GRUPO
		_TSaldo		+= _Saldo
		_TVenda		+= VENDA->C6_QTDVEN
		_Tatraso	+= ATRASO->C6_QTDVEN
		_TBloq		+= BLOQ->C6_QTDVEN
		_TVendido	+= VENDIDO->C6_QTDVEN
		_TFaturado	+= FATURADO->D2_QTDVEN
		_TEFutura	+= EFUTURA->C6_QTDVEN
		_TMediaF	+= MEDIAF->D2_QTDVEN
		_TMeta		+= SCT->CT_QUANT
		
		// FAZ QUEBRA DA SEGUNDA UM
		If alltrim(SB1->B1_SEGUM) <> ""
			_TConv	:= SB1->B1_TIPCONV  // DIVISOR OU MULTIPLICADOR
			_FConv	:= SB1->B1_CONV    // FATOR
			If _TConv == "D"
				//_Vseg := SD4->D4_QUANT / _FConv
				@ nLin, 057			PSAY SB1->B1_SEGUM
				@ nLin, Pcol()+003	PSAY _Saldo	/ _FConv					   			Picture "@E 99,999.99"
				@ nLin, Pcol()+003  PSAY VENDA->C6_QTDVEN / _FConv						Picture "@E 99,999.99"
				@ nLin, Pcol()+003  PSAY ATRASO->C6_QTDVEN / _FConv						Picture "@E 99,999.99"
				@ nLin, Pcol()+003  PSAY BLOQ->C6_QTDVEN / _FConv						Picture "@E 99,999.99"
				@ nLin, Pcol()+003  PSAY _Saldo - VENDA->C6_QTDVEN / _FConv				Picture "@E 99,999.99"
				@ nLin, Pcol()+003  PSAY VENDIDO->C6_QTDVEN  / _FConv					Picture "@E 99,999.99"
				@ nLin, Pcol()+003  PSAY FATURADO->D2_QTDVEN  / _FConv					Picture "@E 99,999.99"
				@ nLin, Pcol()+003  PSAY EFUTURA->C6_QTDVEN	/ _FConv					Picture "@E 99,999.99"
				@ nLin, Pcol()+003  PSAY (MEDIAF->D2_QTDVEN / 6) / _FConv 				Picture "@E 99,999,999"
				@ nLin, Pcol()+003  PSAY SCT->CT_QUANT / _FConv 		  				Picture "@E 99,999.99"
				@ nLin, Pcol()+009  PSAY ((FATURADO->D2_QTDVEN/ _FConv) / (SCT->CT_QUANT/ _FConv) ) * 100 			Picture "@E 999"
				@ nLin, Pcol()+000  PSAY " %"
				nLin++
				
				// VERIFICA SE JÁ EXISTE REGISTRO DA UM
				For i := 1 To Len(_UMV)
					If _UMV[i] = SB1->B1_SEGUM
						_Flag	:= .T.
						_TempI	:= i
					EndIf
				Next I
				If _Flag  // totaliza a UM
					_TSaldoV[_TempI]	+= _Saldo	/ _FConv
					_TVendaV[_TempI]	+= VENDA->C6_QTDVEN / _FConv
					_TatrasoV[_TempI]	+= ATRASO->C6_QTDVEN / _FConv
					_TBloqV[_TempI]		+= BLOQ->C6_QTDVEN / _FConv
					_TVendidoV[_TempI]	+= VENDIDO->C6_QTDVEN  / _FConv
					_TFaturadV[_TempI]	+= FATURADO->D2_QTDVEN  / _FConv
					_TEFuturaV[_TempI]	+= EFUTURA->C6_QTDVEN	/ _FConv
					_TMediaFV[_TempI]	+= (MEDIAF->D2_QTDVEN / 6) / _FConv
					_TMetaV[_TempI]		+= SCT->CT_QUANT / _FConv
				Else  // ADD NOVA UM
					Aadd(_UMV,			SB1->B1_SEGUM)
					Aadd(_TSaldoV,		_Saldo	/ _FConv)
					Aadd(_TVendaV,		VENDA->C6_QTDVEN / _FConv)
					Aadd(_TatrasoV,		ATRASO->C6_QTDVEN / _FConv )
					Aadd(_TBloqV,		BLOQ->C6_QTDVEN / _FConv )
					Aadd(_TVendidoV,	VENDIDO->C6_QTDVEN  / _FConv)
					Aadd(_TFaturadV,	FATURADO->D2_QTDVEN  / _FConv )
					Aadd(_TEFuturaV,	EFUTURA->C6_QTDVEN	/ _FConv )
					Aadd(_TMediaFV,		(MEDIAF->D2_QTDVEN / 6) / _FConv  )
					Aadd(_TMetaV,		SCT->CT_QUANT / _FConv )
				EndIf
			Else
				//_Vseg := SD4->D4_QUANT * _FConv
				@ nLin, 058			PSAY SB1->B1_SEGUM
				@ nLin, Pcol()+002	PSAY _Saldo * _FConv						   		Picture "@E 99,999.99"
				@ nLin, Pcol()+003  PSAY VENDA->C6_QTDVEN * _FConv						Picture "@E 99,999.99"
				@ nLin, Pcol()+003  PSAY ATRASO->C6_QTDVEN * _FConv						Picture "@E 99,999.99"
				@ nLin, Pcol()+003  PSAY BLOQ->C6_QTDVEN * _FConv						Picture "@E 99,999.99"
				@ nLin, Pcol()+003  PSAY (_Saldo - VENDA->C6_QTDVEN) * _FConv			Picture "@E 99,999.99"
				@ nLin, Pcol()+003  PSAY VENDIDO->C6_QTDVEN * _FConv 					Picture "@E 99,999.99"
				@ nLin, Pcol()+003  PSAY FATURADO->D2_QTDVEN * _FConv 					Picture "@E 99,999.99"
				@ nLin, Pcol()+003  PSAY EFUTURA->C6_QTDVEN * _FConv					Picture "@E 99,999.99"
				@ nLin, Pcol()+003  PSAY (MEDIAF->D2_QTDVEN / 6) * _FConv 				Picture "@E 99,999,999"
				@ nLin, Pcol()+003  PSAY SCT->CT_QUANT * _FConv 		  				Picture "@E 99,999.99"
				@ nLin, Pcol()+009  PSAY ((FATURADO->D2_QTDVEN * _FConv) / (SCT->CT_QUANT * _FConv) ) * 100 			Picture "@E 999"
				@ nLin, Pcol()+000  PSAY " %"
				nLin++
				
				
				// VERIFICA SE JÁ EXISTE REGISTRO DA UM
				For i := 1 To Len(_UMV)
					If _UMV[i] = SB1->B1_SEGUM
						_Flag	:= .T.
						_TempI	:= i
					EndIf
				Next I
				If _Flag
					_TSaldoV[_TempI]	+= _Saldo	* _FConv
					_TVendaV[_TempI]	+= VENDA->C6_QTDVEN * _FConv
					_TatrasoV[_TempI]	+= ATRASO->C6_QTDVEN * _FConv
					_TBloqV[_TempI]		+= BLOQ->C6_QTDVEN * _FConv
					_TVendidoV[_TempI]	+= VENDIDO->C6_QTDVEN  * _FConv
					_TFaturadV[_TempI]	+= FATURADO->D2_QTDVEN  * _FConv
					_TEFuturaV[_TempI]	+= EFUTURA->C6_QTDVEN	* _FConv
					_TMediaFV[_TempI]	+= (MEDIAF->D2_QTDVEN / 6) * _FConv
					_TMetaV[_TempI]		+= SCT->CT_QUANT * _FConv
				Else
					Aadd(_UMV,			SB1->B1_SEGUM)
					Aadd(_TSaldoV,		_Saldo	* _FConv)
					Aadd(_TVendaV,		VENDA->C6_QTDVEN * _FConv)
					Aadd(_TatrasoV,		ATRASO->C6_QTDVEN * _FConv )
					Aadd(_TBloqV,		BLOQ->C6_QTDVEN * _FConv )
					Aadd(_TVendidoV,	VENDIDO->C6_QTDVEN  * _FConv)
					Aadd(_TFaturadV,	FATURADO->D2_QTDVEN  * _FConv )
					Aadd(_TEFuturaV,	EFUTURA->C6_QTDVEN	* _FConv )
					Aadd(_TMediaFV,		(MEDIAF->D2_QTDVEN  / 6) * _FConv  )
					Aadd(_TMetaV,		SCT->CT_QUANT * _FConv )
				EndIf
			EndIf
		EndIf
		
		// FECHA TODAS AS CONSULTAS
		dbSelectArea("VENDA")
		dbCloseArea("VENDA")
		
		dbSelectArea("ATRASO")
		dbCloseArea("ATRASO")
		
		dbSelectArea("BLOQ")
		dbCloseArea("BLOQ")
		
		dbSelectArea("VENDIDO")
		dbCloseArea("VENDIDO")
		
		dbSelectArea("FATURADO")
		dbCloseArea("FATURADO")
		
		dbSelectArea("EFUTURA")
		dbCloseArea("EFUTURA")
		
		dbSelectArea("MEDIAF")
		dbCloseArea("MEDIAF")
		
		_Saldo 		:= 0
		
		dbSelectArea("SB1")
		dbSkip()
	EndDo
	
	nLin++
	// IMPRIME O TOTAL DO GRUPO
	@ nLin, 001			PSAY "-----> TOTAL DO GRUPO"
	@ nLin, Pcol()+039	PSAY _TSaldo						Picture "@E 999,999.99"
	@ nLin, Pcol()+002  PSAY _TVenda						Picture "@E 999,999.99"
	@ nLin, Pcol()+002  PSAY _Tatraso						Picture "@E 999,999.99"
	@ nLin, Pcol()+002  PSAY _TBloq							Picture "@E 999,999.99"
	@ nLin, Pcol()+002  PSAY _TSaldo - _TVenda				Picture "@E 999,999.99"
	@ nLin, Pcol()+002  PSAY _TVendido		   				Picture "@E 999,999.99"
	@ nLin, Pcol()+002  PSAY _TFaturado 		   			Picture "@E 999,999.99"
	@ nLin, Pcol()+002  PSAY _TEFutura						Picture "@E 999,999.99"
	@ nLin, Pcol()+002  PSAY _TMediaF / 6 					Picture "@E 999,999,999"
	@ nLin, Pcol()+002  PSAY _TMeta 	  					Picture "@E 999,999.99"
	@ nLin, Pcol()+009  PSAY (_TFaturado / _TMeta ) * 100	Picture "@E 999"
	@ nLin, Pcol()+000  PSAY " %"
	
	nLin++
	if len(_UMV) > 0
		For i=1 to len(_UMV)
			@ nLin, 001			PSAY "-----> TOTAL DO GRUPO SEG UM"
			@ nLin, Pcol()+029	PSAY _UMV[I]
			@ nLin, Pcol()+001	PSAY _TSaldoV[i]						Picture "@E 999,999.99"
			@ nLin, Pcol()+002  PSAY _TVendaV[i]						Picture "@E 999,999.99"
			@ nLin, Pcol()+002  PSAY _TatrasoV[i]						Picture "@E 999,999.99"
			@ nLin, Pcol()+002  PSAY _TBloqV[i]							Picture "@E 999,999.99"
			@ nLin, Pcol()+002  PSAY _TSaldoV[i] - _TVendaV[i]			Picture "@E 999,999.99"
			@ nLin, Pcol()+002  PSAY _TVendidoV[i]		   				Picture "@E 999,999.99"
			@ nLin, Pcol()+002  PSAY _TFaturadV[i] 		   		  		Picture "@E 999,999.99"
			@ nLin, Pcol()+002  PSAY _TEFuturaV[i]						Picture "@E 999,999.99"
			@ nLin, Pcol()+002  PSAY _TMediaFV[i] / 6 					Picture "@E 999,999,999"
			@ nLin, Pcol()+002  PSAY _TMetaV[i] 	  					Picture "@E 999,999.99"
			@ nLin, Pcol()+009  PSAY (_TFaturadV[i] / _TMetaV[i] ) * 100	Picture "@E 999"
			@ nLin, Pcol()+000  PSAY " %"
			nLin++
		Next i
	EndIf
	
	@ nLin, 000 PSAY __PrtThinLine()
	nLin+= 1
	
	_TSaldo		:= 0
	_TVenda		:= 0
	_Tatraso	:= 0
	_TBloq		:= 0
	_TVendido	:= 0
	_TFaturado	:= 0
	_TEFutura	:= 0
	_TMediaF	:= 0
	_TMeta		:= 0
	
	_UMV		:= {}
	_TSaldoV	:= {}
	_TVendaV	:= {}
	_TatrasoV	:= {}
	_TBloqV		:= {}
	_TVendidoV	:= {}
	_TFaturadV	:= {}
	_TEFuturaV	:= {}
	_TMediaFV	:= {}
	_TMetaV		:= {}
	_Flag		:= .F.
	
	dbSelectArea("SB1")
EndDo

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function BuscaVenda()
_cQryVenda	:=	"SELECT DISTINCT "
_cQryVenda	+=	"                      SUM(SC6010.C6_QTDVEN - SC6010.C6_QTDENT) AS C6_QTDVEN "
_cQryVenda	+=	"FROM         SC6010 INNER JOIN "
_cQryVenda	+=	"                      SC5010 ON SC6010.C6_FILIAL = SC5010.C5_FILIAL AND SC6010.C6_NUM = SC5010.C5_NUM INNER JOIN "
_cQryVenda	+=	"                      SB1010 ON SC6010.C6_PRODUTO = SB1010.B1_COD INNER JOIN "
_cQryVenda	+=	"                      SF4010 ON SC6010.C6_TES = SF4010.F4_CODIGO "
_cQryVenda	+=	"WHERE        (SC6010.C6_BLQ NOT IN ('R','S')) AND  "
_cQryVenda	+=	"                       SC6010.C6_PRODUTO = '"+_cChave2+"' AND "
_cQryVenda	+=	"                      (SC5010.C5_TIPO = 'N') AND "
_cQryVenda	+=	"                      (SC5010.C5_VEND1 BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"') AND "
_cQryVenda	+=	"                      (SC6010.C6_CLI BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR05+"') AND "
_cQryVenda	+=	"                      (SC6010.C6_LOJA BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR06+"') AND "
_cQryVenda	+=	"                      (SC6010.C6_FILIAL BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"') AND "
_cQryVenda	+=	"                      (SC5010.C5_EMISSAO >= '"+DTOS(_DataVen)+"' ) AND "
_cQryVenda	+= "						(SC6010.C6_QTDVEN > SC6010.C6_QTDENT) AND "

//----> ATUALIZA ESTOQUE
If MV_PAR09 == 1
	_cQryVenda	+=	"                  (SF4010.F4_ESTOQUE IN ('S')) AND "
	//----> NAO ATUALIZA ESTOQUE
ElseIf MV_PAR09 == 2
	_cQryVenda	+=	"                  (SF4010.F4_ESTOQUE IN ('N')) AND "
EndIf

//----> GERA FINANCEIRO
If MV_PAR10 == 1
	_cQryVenda	+=	"                  (SF4010.F4_DUPLIC IN ('S')) AND "
	//----> NAO GERA FINANCEIRO
ElseIf MV_PAR10 == 2
	_cQryVenda	+=	"                  (SF4010.F4_DUPLIC IN ('N')) AND "
EndIf

_cQryVenda	+=	"                      (SC5010.D_E_L_E_T_ = '') AND (SC6010.D_E_L_E_T_ = '') AND (SB1010.D_E_L_E_T_ = '') AND (SF4010.D_E_L_E_T_ = '') "

_cQryVenda	:=	ChangeQuery(_cQryVenda)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryVenda),"VENDA",.T.,.T.)

//TcSetField("VENDA","C5_EMISSAO","D",TamSX3("C5_EMISSAO")[1],TamSX3("C5_EMISSAO")[2])
//TcSetField("VENDA","C6_ENTREG" ,"D",TamSX3("C6_ENTREG" )[1],TamSX3("C6_ENTREG" )[2])
Return()


Static Function BLOQ()
_cQryVenda	:=	"SELECT DISTINCT "
_cQryVenda	+=	"                      SUM(SC6010.C6_QTDVEN - SC6010.C6_QTDENT) AS C6_QTDVEN "
_cQryVenda	+=	"FROM         SC6010 INNER JOIN "
_cQryVenda	+=	"                      SC5010 ON SC6010.C6_FILIAL = SC5010.C5_FILIAL AND SC6010.C6_NUM = SC5010.C5_NUM INNER JOIN "
_cQryVenda	+=	"                      SB1010 ON SC6010.C6_PRODUTO = SB1010.B1_COD INNER JOIN "
_cQryVenda	+=	"                      SF4010 ON SC6010.C6_TES = SF4010.F4_CODIGO "
_cQryVenda	+=	"WHERE        (SC6010.C6_BLQ NOT IN ('R')) AND SC6010.C6_BLQ = 'S' AND "
_cQryVenda	+=	"                       SC6010.C6_PRODUTO = '"+_cChave2+"' AND "
_cQryVenda	+=	"                      (SC5010.C5_TIPO = 'N') AND "
_cQryVenda	+=	"                      (SC5010.C5_VEND1 BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"') AND "
_cQryVenda	+=	"                      (SC6010.C6_CLI BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR05+"') AND "
_cQryVenda	+=	"                      (SC6010.C6_LOJA BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR06+"') AND "
_cQryVenda	+=	"                      (SC6010.C6_FILIAL BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"') AND "
_cQryVenda	+=	"                      (SC5010.C5_EMISSAO >= '"+DTOS(_DataVen)+"' ) AND "
_cQryVenda	+= "						(SC6010.C6_QTDVEN > SC6010.C6_QTDENT) AND "

//----> ATUALIZA ESTOQUE
If MV_PAR09 == 1
	_cQryVenda	+=	"                  (SF4010.F4_ESTOQUE IN ('S')) AND "
	//----> NAO ATUALIZA ESTOQUE
ElseIf MV_PAR09 == 2
	_cQryVenda	+=	"                  (SF4010.F4_ESTOQUE IN ('N')) AND "
EndIf

//----> GERA FINANCEIRO
If MV_PAR10 == 1
	_cQryVenda	+=	"                  (SF4010.F4_DUPLIC IN ('S')) AND "
	//----> NAO GERA FINANCEIRO
ElseIf MV_PAR10 == 2
	_cQryVenda	+=	"                  (SF4010.F4_DUPLIC IN ('N')) AND "
EndIf
_cQryVenda	+=	"                      (SC5010.D_E_L_E_T_ = '') AND (SC6010.D_E_L_E_T_ = '') AND (SB1010.D_E_L_E_T_ = '') AND (SF4010.D_E_L_E_T_ = '') "

_cQryVenda	:=	ChangeQuery(_cQryVenda)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryVenda),"BLOQ",.T.,.T.)

Return()

Static Function Atraso()
_cQryVenda	:=	"SELECT DISTINCT "
_cQryVenda	+=	"                      SUM(SC6010.C6_QTDVEN - SC6010.C6_QTDENT) AS C6_QTDVEN "
_cQryVenda	+=	"FROM         SC6010 INNER JOIN "
_cQryVenda	+=	"                      SC5010 ON SC6010.C6_FILIAL = SC5010.C5_FILIAL AND SC6010.C6_NUM = SC5010.C5_NUM INNER JOIN "
_cQryVenda	+=	"                      SB1010 ON SC6010.C6_PRODUTO = SB1010.B1_COD INNER JOIN "
_cQryVenda	+=	"                      SF4010 ON SC6010.C6_TES = SF4010.F4_CODIGO "
_cQryVenda	+=	"WHERE        (SC6010.C6_BLQ NOT IN ('R','S')) AND  "
_cQryVenda	+=	"                       SC6010.C6_PRODUTO = '"+_cChave2+"' AND "
_cQryVenda	+=	"                      (SC5010.C5_TIPO = 'N') AND "
_cQryVenda	+=	"                      (SC5010.C5_VEND1 BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"') AND "
_cQryVenda	+=	"                      (SC6010.C6_CLI BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR05+"') AND "
_cQryVenda	+=	"                      (SC6010.C6_LOJA BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR06+"') AND "
_cQryVenda	+=	"                      (SC6010.C6_FILIAL BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"') AND "
_cQryVenda	+=	"                      (SC6010.C6_ENTREG < '"+DTOS(_DataB)+"') AND "
_cQryVenda	+= "						(SC6010.C6_QTDVEN > SC6010.C6_QTDENT) AND "

//----> ATUALIZA ESTOQUE
If MV_PAR09 == 1
	_cQryVenda	+=	"                  (SF4010.F4_ESTOQUE IN ('S')) AND "
	//----> NAO ATUALIZA ESTOQUE
ElseIf MV_PAR09 == 2
	_cQryVenda	+=	"                  (SF4010.F4_ESTOQUE IN ('N')) AND "
EndIf

//----> GERA FINANCEIRO
If MV_PAR10 == 1
	_cQryVenda	+=	"                  (SF4010.F4_DUPLIC IN ('S')) AND "
	//----> NAO GERA FINANCEIRO
ElseIf MV_PAR10 == 2
	_cQryVenda	+=	"                  (SF4010.F4_DUPLIC IN ('N')) AND "
EndIf
_cQryVenda	+=	"                      (SC5010.D_E_L_E_T_ = '') AND (SC6010.D_E_L_E_T_ = '') AND (SB1010.D_E_L_E_T_ = '') AND (SF4010.D_E_L_E_T_ = '') "

_cQryVenda	:=	ChangeQuery(_cQryVenda)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryVenda),"ATRASO",.T.,.T.)

Return()


Static Function VENDIDO()
_cQryVenda	:=	"SELECT DISTINCT "
_cQryVenda	+=	"                      SUM(SC6010.C6_QTDVEN) AS C6_QTDVEN "
_cQryVenda	+=	"FROM         SC6010 INNER JOIN "
_cQryVenda	+=	"                      SC5010 ON SC6010.C6_FILIAL = SC5010.C5_FILIAL AND SC6010.C6_NUM = SC5010.C5_NUM INNER JOIN "
_cQryVenda	+=	"                      SB1010 ON SC6010.C6_PRODUTO = SB1010.B1_COD INNER JOIN "
_cQryVenda	+=	"                      SF4010 ON SC6010.C6_TES = SF4010.F4_CODIGO "
_cQryVenda	+=	"WHERE        (SC6010.C6_BLQ NOT IN ('R','S')) AND  "
_cQryVenda	+=	"                       SC6010.C6_PRODUTO = '"+_cChave2+"' AND "
_cQryVenda	+=	"                      (SC5010.C5_TIPO = 'N') AND "
_cQryVenda	+=	"                      (SC5010.C5_VEND1 BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"') AND "
_cQryVenda	+=	"                      (SC6010.C6_CLI BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR05+"') AND "
_cQryVenda	+=	"                      (SC6010.C6_LOJA BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR06+"') AND "
_cQryVenda	+=	"                      (SC6010.C6_FILIAL BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"') AND "
_cQryVenda	+=	"                      (SC5010.C5_EMISSAO BETWEEN '"+_DataBini+"' AND '"+DTOS(_DataB)+"') AND "
_cQryVenda	+= "						(SC6010.C6_QTDVEN > SC6010.C6_QTDENT) AND "

//----> ATUALIZA ESTOQUE
If MV_PAR09 == 1
	_cQryVenda	+=	"                  (SF4010.F4_ESTOQUE IN ('S')) AND "
	//----> NAO ATUALIZA ESTOQUE
ElseIf MV_PAR09 == 2
	_cQryVenda	+=	"                  (SF4010.F4_ESTOQUE IN ('N')) AND "
EndIf

//----> GERA FINANCEIRO
If MV_PAR10 == 1
	_cQryVenda	+=	"                  (SF4010.F4_DUPLIC IN ('S')) AND "
	//----> NAO GERA FINANCEIRO
ElseIf MV_PAR10 == 2
	_cQryVenda	+=	"                  (SF4010.F4_DUPLIC IN ('N')) AND "
EndIf
_cQryVenda	+=	"                      (SC5010.D_E_L_E_T_ = '') AND (SC6010.D_E_L_E_T_ = '') AND (SB1010.D_E_L_E_T_ = '') AND (SF4010.D_E_L_E_T_ = '') "

_cQryVenda	:=	ChangeQuery(_cQryVenda)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryVenda),"VENDIDO",.T.,.T.)

Return()

Static Function FATURADO()
_cQryVenda	:=	"SELECT DISTINCT "
_cQryVenda	+=	"        SUM(SD2010.D2_QUANT) AS D2_QTDVEN "
_cQryVenda	+=	" FROM   SD2010 INNER JOIN "
_cQryVenda  +=  " SF2010 ON SD2010.D2_FILIAL = SF2010.F2_FILIAL AND SD2010.D2_CLIENTE = SF2010.F2_CLIENTE AND "
_cQryVenda  +=  " SD2010.D2_LOJA = SF2010.F2_LOJA AND SD2010.D2_DOC = SF2010.F2_DOC AND "
_cQryVenda  +=  " SD2010.D2_SERIE = SF2010.F2_SERIE INNER JOIN "
_cQryVenda	+=	" SF4010 ON SD2010.D2_TES = SF4010.F4_CODIGO "
_cQryVenda	+=	" WHERE        "
_cQryVenda	+=	"                      SD2010.D2_COD = '"+_cChave2+"' AND "
_cQryVenda	+=	"                      (SD2010.D2_TIPO = 'N') AND "
_cQryVenda	+=	"                      (SF2010.F2_VEND1 BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"') AND "
_cQryVenda	+=	"                      (SD2010.D2_CLIENTE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR05+"') AND "
_cQryVenda	+=	"                      (SD2010.D2_LOJA BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR06+"') AND "
_cQryVenda	+=	"                      (SD2010.D2_FILIAL BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"') AND "
_cQryVenda	+=	"                      (SD2010.D2_EMISSAO BETWEEN '"+_DataBini+"' AND '"+DTOS(_DataB)+"') AND "

//----> ATUALIZA ESTOQUE
If MV_PAR09 == 1
	_cQryVenda	+=	"                  (SF4010.F4_ESTOQUE IN ('S')) AND "
	//----> NAO ATUALIZA ESTOQUE
ElseIf MV_PAR09 == 2
	_cQryVenda	+=	"                  (SF4010.F4_ESTOQUE IN ('N')) AND "
EndIf

//----> GERA FINANCEIRO
If MV_PAR10 == 1
	_cQryVenda	+=	"                  (SF4010.F4_DUPLIC IN ('S')) AND "
	//----> NAO GERA FINANCEIRO
ElseIf MV_PAR10 == 2
	_cQryVenda	+=	"                  (SF4010.F4_DUPLIC IN ('N')) AND "
EndIf
_cQryVenda	+=	"      (SD2010.D_E_L_E_T_ = '') AND (SF2010.D_E_L_E_T_ = '') AND (SF4010.D_E_L_E_T_ = '') "

_cQryVenda	:=	ChangeQuery(_cQryVenda)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryVenda),"FATURADO",.T.,.T.)

Return()


Static Function EFUTURA()
_cQryVenda	:=	"SELECT DISTINCT "
_cQryVenda	+=	"                      SUM(SC6010.C6_QTDVEN - SC6010.C6_QTDENT) AS C6_QTDVEN "
_cQryVenda	+=	"FROM         SC6010 INNER JOIN "
_cQryVenda	+=	"                      SC5010 ON SC6010.C6_FILIAL = SC5010.C5_FILIAL AND SC6010.C6_NUM = SC5010.C5_NUM INNER JOIN "
_cQryVenda	+=	"                      SB1010 ON SC6010.C6_PRODUTO = SB1010.B1_COD INNER JOIN "
_cQryVenda	+=	"                      SF4010 ON SC6010.C6_TES = SF4010.F4_CODIGO "
_cQryVenda	+=	"WHERE        (SC6010.C6_BLQ NOT IN ('R','S')) AND  "
_cQryVenda	+=	"                       SC6010.C6_PRODUTO = '"+_cChave2+"' AND "
_cQryVenda	+=	"                      (SC5010.C5_TIPO = 'N') AND "
_cQryVenda	+=	"                      (SC5010.C5_VEND1 BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"') AND "
_cQryVenda	+=	"                      (SC6010.C6_CLI BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR05+"') AND "
_cQryVenda	+=	"                      (SC6010.C6_LOJA BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR06+"') AND "
_cQryVenda	+=	"                      (SC6010.C6_FILIAL BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"') AND "
_cQryVenda	+=	"                      (SC5010.C5_EMISSAO BETWEEN '"+_DataBini+"' AND '"+DTOS(_DataB)+"') AND "
_cQryVenda	+=	"                      (SC6010.C6_ENTREG >= '"+_cDataIni+"') AND "
_cQryVenda	+= "						(SC6010.C6_QTDVEN > SC6010.C6_QTDENT) AND "

//----> ATUALIZA ESTOQUE
If MV_PAR09 == 1
	_cQryVenda	+=	"                  (SF4010.F4_ESTOQUE IN ('S')) AND "
	//----> NAO ATUALIZA ESTOQUE
ElseIf MV_PAR09 == 2
	_cQryVenda	+=	"                  (SF4010.F4_ESTOQUE IN ('N')) AND "
EndIf

//----> GERA FINANCEIRO
If MV_PAR10 == 1
	_cQryVenda	+=	"                  (SF4010.F4_DUPLIC IN ('S')) AND "
	//----> NAO GERA FINANCEIRO
ElseIf MV_PAR10 == 2
	_cQryVenda	+=	"                  (SF4010.F4_DUPLIC IN ('N')) AND "
EndIf
_cQryVenda	+=	"                      (SC5010.D_E_L_E_T_ = '') AND (SC6010.D_E_L_E_T_ = '') AND (SB1010.D_E_L_E_T_ = '') AND (SF4010.D_E_L_E_T_ = '') "

_cQryVenda	:=	ChangeQuery(_cQryVenda)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryVenda),"EFUTURA",.T.,.T.)

Return()


Static Function MEDIAF()
_cQryVenda	:=	"SELECT DISTINCT "
_cQryVenda	+=	"        SUM(SD2010.D2_QUANT) AS D2_QTDVEN "
_cQryVenda	+=	" FROM   SD2010 INNER JOIN "
_cQryVenda  +=  " SF2010 ON SD2010.D2_FILIAL = SF2010.F2_FILIAL AND SD2010.D2_CLIENTE = SF2010.F2_CLIENTE AND "
_cQryVenda  +=  " SD2010.D2_LOJA = SF2010.F2_LOJA AND SD2010.D2_DOC = SF2010.F2_DOC AND "
_cQryVenda  +=  " SD2010.D2_SERIE = SF2010.F2_SERIE INNER JOIN "
_cQryVenda	+=	" SF4010 ON SD2010.D2_TES = SF4010.F4_CODIGO "
_cQryVenda	+=	" WHERE        "
_cQryVenda	+=	"                      SD2010.D2_COD = '"+_cChave2+"' AND "
_cQryVenda	+=	"                      (SD2010.D2_TIPO = 'N') AND "
_cQryVenda	+=	"                      (SF2010.F2_VEND1 BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"') AND "
_cQryVenda	+=	"                      (SD2010.D2_CLIENTE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR05+"') AND "
_cQryVenda	+=	"                      (SD2010.D2_LOJA BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR06+"') AND "
_cQryVenda	+=	"                      (SD2010.D2_FILIAL BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"') AND "
_cQryVenda	+=	"                      (SD2010.D2_EMISSAO BETWEEN '"+_cDataMedi+"' AND '"+_cDataMedf+"') AND "

//----> ATUALIZA ESTOQUE
If MV_PAR09 == 1
	_cQryVenda	+=	"                  (SF4010.F4_ESTOQUE IN ('S')) AND "
	//----> NAO ATUALIZA ESTOQUE
ElseIf MV_PAR09 == 2
	_cQryVenda	+=	"                  (SF4010.F4_ESTOQUE IN ('N')) AND "
EndIf

//----> GERA FINANCEIRO
If MV_PAR10 == 1
	_cQryVenda	+=	"                  (SF4010.F4_DUPLIC IN ('S')) AND "
	//----> NAO GERA FINANCEIRO
ElseIf MV_PAR10 == 2
	_cQryVenda	+=	"                  (SF4010.F4_DUPLIC IN ('N')) AND "
EndIf
_cQryVenda	+=	"      (SD2010.D_E_L_E_T_ = '') AND (SF2010.D_E_L_E_T_ = '') AND (SF4010.D_E_L_E_T_ = '') "

_cQryVenda	:=	ChangeQuery(_cQryVenda)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryVenda),"MEDIAF",.T.,.T.)

Return()
