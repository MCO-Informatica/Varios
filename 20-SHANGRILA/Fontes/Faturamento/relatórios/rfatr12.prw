#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFATR12  ³ Autor ³ Genilson Moreira Lucas  ³ Data ³ 01/04/2010 ³±±
±±³          ³          ³       ³ MVG Consultoria Ltda    ³      ³            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Faturamento por Produto                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ Quebra por Grupo/Estado/Vendedor                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                                ³±±
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

User Function RFATR12()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relacao de Faturamento por Produto"
Local cPict          := ""
Local titulo         := "Relacao de Faturamento por Produto"
Local nLin         	 := 80
Local Cabec1       	 := ""
Local Cabec2       	 := ""
Local imprime      	 := .T.

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RFATR12"
Private nTipo        := 18
Private aOrd         := {"Por Grupo Produto"}//,"Por Estado","Por Vendedor"}
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RFATR12"
Private cString 	 := "SF2"
Private cPerg   	 := Pad("FATR10",Len(SX1->X1_GRUPO))
Private nOrdem

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_aRegs := {}

AAdd(_aRegs,{cPerg,"01","Data Inicial ?   ","Data Inicial ?   ","Data Inicial ?   ","mv_ch0","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"02","Data Final ?     ","Data Final ?     ","Data Final ?     ","mv_ch0","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"03","Do Grupo ?       ","Do Grupo ?     ? ","Do Grupo ?       ","mv_ch0","C",04,0,0,"G","","mv_par03","","","","","","","","","","","","","","SBM","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"04","Ate o Grupo ?    ","Ate o Grupo ?    ","Ate o Grupo ?    ","mv_ch0","C",04,0,0,"G","","mv_par04","","","","","","","","","","","","","","SBM","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"05","Do Produto ?     ","Do Produto ?     ","Do Produto ?     ","mv_ch0","C",15,0,0,"G","","mv_par05","","","","","","","","","","","","","","SB1","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"06","Ate o Produto ?  ","Ate o Produto ?  ","Ate o Produto ?  ","mv_ch0","C",15,0,0,"G","","mv_par06","","","","","","","","","","","","","","SB1","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"07","Do Estado ?      ","Do Estado ?      ","Do Estado ?      ","mv_ch0","C",02,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"08","Ate o Estado ?   ","Ate o Estado ?   ","Ate o Estado ?   ","mv_ch0","C",02,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"09","Do Vendedor ?    ","Do Vendedor ?    ","Do Vendedor ?    ","mv_ch0","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","SA3","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"10","Ate o Vendedor ? ","Ate o Vendedor ? ","Ate o Vendedor ? ","mv_ch0","C",06,0,0,"G","","mv_par10","","","","","","","","","","","","","","SA3","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"11","Moeda ?		  ","Moeda ? 		  ","Moeda ? 		  ","mv_ch0","N",01,0,0,"C","","mv_par11","Real","Real","Real","Dolar","Dolar","Dolar","","","","","","","","","","","","","","","","","","",""})
ValidPerg(_aRegs,cPerg)

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


Cabec1       	 := "PRODUTO         DESCRICAO                                         PRECO         QTDE         QTDE         QTDE          VALOR          VALOR          VALOR        "
Cabec2       	 := "                                                                M VENDA        BRUTA        DEVOL        LIQUI          BRUTO          DEVOL          LIQUI        "
	
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


_nQtdBru := 0
_nQtdDev := 0
_nQtdLiq := 0
_nValBru := 0
_nValDev := 0
_nValLiq := 0
_eQtdBru := 0
_eQtdDev := 0
_eQtdLiq := 0
_eValBru := 0
_eValDev := 0
_eValLiq := 0
_tQtdBru := 0
_tQtdDev := 0
_tQtdLiq := 0
_tValBru := 0
_tValDev := 0
_tValLiq := 0  
_nMediaP := 0


Titulo += Iif(MV_PAR11 == 1, " - em Real"," - em Dolar")
//----> POR GRUPO
If nOrdem == 1
	
	BuscaGrupo()	//----> query para busca dos dados de faturamento
	
	dbSelectArea("QUERY")
	SetRegua(RecCount())
	dbGoTop()
	
	While !Eof()
		
		If lAbortPrint
			@nLin,000		 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		If !Empty(aReturn[7]) .And. !&(aReturn[7])
			dbSelectArea("QUERY")
			dbSkip()
			Loop
		EndIf
		
		dbSelectArea("QUERY")
		
		_cGrupo		:=	QUERY->B1_GRUPO
		
		@ nLin, 000		PSAY "Grupo: "+_cGrupo+" "+Posicione("SBM",1,xFilial("SBM")+_cGrupo,"BM_DESC")
		
		nLin++
		nLin++
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		While Eof() == .f. .And. _cGrupo	==	QUERY->B1_GRUPO
			
			If !Empty(aReturn[7]) .And. !&(aReturn[7])
				dbSelectArea("QUERY")
				dbSkip()
				Loop
			EndIf
			
			BuscaDevGru()
			dbSelectArea("DEVOL")
			
			BusDevGruQ()
			dbSelectArea("DEVOLQ")
			
			BGrupoQ()
			dbSelectArea("QUERYQ")
			
			@ nLin, 000			PSAY QUERY->D2_COD
			@ nLin, pCol()+001	PSAY SUBS(QUERY->B1_DESC,1,50)   
			@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,(QUERY->D2_TOTAL-DEVOL->D1_TOTAL) / (QUERYQ->D2_QUANT-DEVOLQ->D1_QUANT),xMoeda((QUERY->D2_TOTAL-DEVOL->D1_TOTAL) / (QUERYQ->D2_QUANT-DEVOLQ->D1_QUANT),1,2)) Picture(PesqPict("SD2","D2_TOTAL"))
			@ nLin, pCol()+001	PSAY QUERYQ->D2_QUANT						Picture(PesqPict("SD2","D2_QUANT"))
			@ nLin, pCol()+001	PSAY DEVOLQ->D1_QUANT						Picture(PesqPict("SD2","D2_QUANT"))
			@ nLin, pCol()+001	PSAY QUERYQ->D2_QUANT-DEVOLQ->D1_QUANT		Picture(PesqPict("SD2","D2_QUANT"))
			@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,QUERY->D2_TOTAL,xMoeda(QUERY->D2_TOTAL,1,2))						Picture(PesqPict("SD2","D2_TOTAL"))
			@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,DEVOL->D1_TOTAL,xMoeda(DEVOL->D1_TOTAL,1,2))						Picture(PesqPict("SD2","D2_TOTAL"))
			@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,QUERY->D2_TOTAL-DEVOL->D1_TOTAL,xMoeda(QUERY->D2_TOTAL-DEVOL->D1_TOTAL,1,2))		Picture(PesqPict("SD2","D2_TOTAL"))
			
			nLin++
			
			If nLin > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			
			_nQtdBru += QUERYQ->D2_QUANT
			_nQtdDev += DEVOLQ->D1_QUANT
			_nQtdLiq += (QUERYQ->D2_QUANT - DEVOLQ->D1_QUANT )
			
			_nValBru += QUERY->D2_TOTAL
			_nValDev += DEVOL->D1_TOTAL
			_nValLiq += (QUERY->D2_TOTAL - DEVOL->D1_TOTAL )
			
			_tQtdBru += QUERYQ->D2_QUANT
			_tQtdDev += DEVOLQ->D1_QUANT
			_tQtdLiq += (QUERYQ->D2_QUANT - DEVOLQ->D1_QUANT )
			
			_tValBru += QUERY->D2_TOTAL
			_tValDev += DEVOL->D1_TOTAL
			_tValLiq += (QUERY->D2_TOTAL - DEVOL->D1_TOTAL )
			
			
			dbSelectArea("DEVOL")
			dbCloseArea()     
			
			dbSelectArea("DEVOLQ")
			dbCloseArea()     
			
			dbSelectArea("QUERYQ")
			dbCloseArea()
			
			dbSelectArea("QUERY")
			dbSkip()
		EndDo
		
		nLin++
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		
		@ nLin, 000			PSAY "Total Grupo "+_cGrupo+" "+Posicione("SBM",1,xFilial("SBM")+_cGrupo,"BM_DESC")+Space(55-Len("Total Grupo "+_cGrupo+" "+Posicione("SBM",1,xFilial("SBM")+_cGrupo,"BM_DESC")))
		@ nLin, pCol()+001	PSAY ""   
		@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_nValLiq / _nQtdLiq,xMoeda(_nValLiq / _nQtdLiq,1,2)) Picture(PesqPict("SD2","D2_TOTAL"))
		@ nLin, pCol()+001	PSAY _nQtdBru			Picture(PesqPict("SD2","D2_QUANT"))
		@ nLin, pCol()+001	PSAY _nQtdDev			Picture(PesqPict("SD2","D2_QUANT"))
		@ nLin, pCol()+001	PSAY _nQtdLiq			Picture(PesqPict("SD2","D2_QUANT"))
		@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_nValBru,xMoeda(_nValBru,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
		@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_nValDev,xMoeda(_nValDev,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
		@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_nValLiq,xMoeda(_nValLiq,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
		
		nLin++
		
		@ nLin, 000 PSAY __PrtThinLine()

		nLin++

		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		
		_nQtdBru := 0
		_nQtdDev := 0
		_nQtdLiq := 0
		
		_nValBru := 0
		_nValDev := 0
		_nValLiq := 0
		
		dbSelectArea("QUERY")
	EndDo
	
	nLin ++
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	@ nLin, 000			PSAY "Total Geral "+Space(55-Len("Total Geral "))
	@ nLin, pCol()+001	PSAY ""  
	@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_tValLiq / _tQtdLiq,xMoeda(_tValLiq / _tQtdLiq,1,2)) Picture(PesqPict("SD2","D2_TOTAL"))
	@ nLin, pCol()+001	PSAY _tQtdBru			Picture(PesqPict("SD2","D2_QUANT"))
	@ nLin, pCol()+001	PSAY _tQtdDev			Picture(PesqPict("SD2","D2_QUANT"))
	@ nLin, pCol()+001	PSAY _tQtdLiq			Picture(PesqPict("SD2","D2_QUANT"))
	@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_tValBru,xMoeda(_tValBru,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
	@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_tValDev,xMoeda(_tValDev,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
	@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_tValLiq,xMoeda(_tValLiq,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
	
	dbSelectArea("QUERY")
	dbCloseArea("QUERY")
	
	//----> POR ESTADO
ElseIf nOrdem == 2
	
	BuscaEstado()	//----> query para busca dos dados de faturamento
	
	dbSelectArea("QUERY")
	SetRegua(RecCount())
	dbGoTop()
	
	While !Eof()
		
		If lAbortPrint
			@nLin,000		 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		If !Empty(aReturn[7]) .And. !&(aReturn[7])
			dbSelectArea("QUERY")
			dbSkip()
			Loop
		EndIf
		
		
		dbSelectArea("QUERY")
		
		_cEstado :=	QUERY->F2_EST
		
		dbSelectArea("QUERY")
		
		@ nLin, 000		PSAY "Estado: "+_cEstado
		
		nLin++
		nLin++
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		While Eof() == .f. .And. _cEstado	==	QUERY->F2_EST
			
			If !Empty(aReturn[7]) .And. !&(aReturn[7])
				dbSelectArea("QUERY")
				dbSkip()
				Loop
			EndIf
			
			
			
			dbSelectArea("QUERY")
			
			_cGrupo		:=	QUERY->B1_GRUPO
			
			dbSelectArea("QUERY")
			
			@ nLin, 000		PSAY "Grupo: "+_cGrupo+" "+Posicione("SBM",1,xFilial("SBM")+_cGrupo,"BM_DESC")
			
			nLin++
			nLin++
			
			If nLin > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			
			While Eof() == .f. .And. _cEstado+_cGrupo	==	QUERY->F2_EST+QUERY->B1_GRUPO
				
				If !Empty(aReturn[7]) .And. !&(aReturn[7])
					dbSelectArea("QUERY")
					dbSkip()
					Loop
				EndIf
				
				@ nLin, 000			PSAY QUERY->D2_COD
				@ nLin, pCol()+001	PSAY SUBS(QUERY->B1_DESC,1,50) 
				@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,QUERY->D2_TOTAL / QUERY->D2_QUANT,xMoeda(QUERY->D2_TOTAL / QUERY->D2_QUANT,1,2)) Picture(PesqPict("SD2","D2_TOTAL")) 
				@ nLin, pCol()+001	PSAY QUERY->D2_QUANT			Picture(PesqPict("SD2","D2_QUANT"))
				@ nLin, pCol()+001	PSAY 0							Picture(PesqPict("SD2","D2_QUANT"))
				@ nLin, pCol()+001	PSAY QUERY->D2_QUANT			Picture(PesqPict("SD2","D2_QUANT"))
				@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,QUERY->D2_TOTAL,xMoeda(QUERY->D2_TOTAL,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
				@ nLin, pCol()+001	PSAY 0							Picture(PesqPict("SD2","D2_TOTAL"))
				@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,QUERY->D2_TOTAL,xMoeda(QUERY->D2_TOTAL,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
				
				nLin++
				
				If nLin > 60
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 9
				Endif
				
				_nQtdBru += QUERY->D2_QUANT
				_nQtdDev += 0
				_nQtdLiq += (QUERY->D2_QUANT - 0 )
				
				_nValBru += QUERY->D2_TOTAL
				_nValDev += 0
				_nValLiq += (QUERY->D2_TOTAL - 0 )
				
				_eQtdBru += QUERY->D2_QUANT
				_eQtdDev += 0
				_eQtdLiq += (QUERY->D2_QUANT - 0 )
				
				_eValBru += QUERY->D2_TOTAL
				_eValDev += 0
				_eValLiq += (QUERY->D2_TOTAL - 0 )
				
				_tQtdBru += QUERY->D2_QUANT
				_tQtdDev += 0
				_tQtdLiq += (QUERY->D2_QUANT - 0 )
				
				_tValBru += QUERY->D2_TOTAL
				_tValDev += 0
				_tValLiq += (QUERY->D2_TOTAL - 0 )
				
				
				dbSelectArea("QUERY")
				dbSkip()
			EndDo
			
			nLin++
			
			If nLin > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			
			
			@ nLin, 000			PSAY "Total Grupo "+_cGrupo+" "+Posicione("SBM",1,xFilial("SBM")+_cGrupo,"BM_DESC")+Space(55-Len("Total Grupo "+_cGrupo+" "+Posicione("SBM",1,xFilial("SBM")+_cGrupo,"BM_DESC")))
			@ nLin, pCol()+001	PSAY ""                
			@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_nValLiq / _nQtdLiq,xMoeda(_nValLiq / _nQtdLiq,1,2)) Picture(PesqPict("SD2","D2_TOTAL"))
			@ nLin, pCol()+001	PSAY _nQtdBru			Picture(PesqPict("SD2","D2_QUANT"))
			@ nLin, pCol()+001	PSAY _nQtdDev			Picture(PesqPict("SD2","D2_QUANT"))
			@ nLin, pCol()+001	PSAY _nQtdLiq			Picture(PesqPict("SD2","D2_QUANT"))
			@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_nValBru,xMoeda(_nValBru,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
			@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_nValDev,xMoeda(_nValDev,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
			@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_nValLiq,xMoeda(_nValLiq,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
			
			nLin++
			
			@ nLin, 000 PSAY __PrtThinLine()

			nLin++

			If nLin > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			
			
			_nQtdBru := 0
			_nQtdDev := 0
			_nQtdLiq := 0
			
			_nValBru := 0
			_nValDev := 0
			_nValLiq := 0
			
			dbSelectArea("QUERY")
			
		EndDo

		nLin++
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		
		@ nLin, 000			PSAY "Total Estado "+_cEstado+Space(55-Len("Total Estado "+_cEstado))
		@ nLin, pCol()+001	PSAY ""
		@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_eValLiq / _eQtdLiq,xMoeda(_eValLiq / _eQtdLiq,1,2)) Picture(PesqPict("SD2","D2_TOTAL"))
		@ nLin, pCol()+001	PSAY _eQtdBru			Picture(PesqPict("SD2","D2_QUANT"))
		@ nLin, pCol()+001	PSAY _eQtdDev			Picture(PesqPict("SD2","D2_QUANT"))
		@ nLin, pCol()+001	PSAY _eQtdLiq			Picture(PesqPict("SD2","D2_QUANT"))
		@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_eValBru,xMoeda(_eValBru,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
		@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_eValDev,xMoeda(_eValDev,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
		@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_eValLiq,xMoeda(_eValLiq,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
		
		nLin++

		@ nLin, 000 PSAY __PrtThinLine()

		nLin++
	
		@ nLin, 000 PSAY __PrtThinLine()

		nLin++

		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		
		_eQtdBru := 0
		_eQtdDev := 0
		_eQtdLiq := 0
		
		_eValBru := 0
		_eValDev := 0
		_eValLiq := 0
		
		dbSelectArea("QUERY")
	EndDo
	
	nLin ++
	
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	@ nLin, 000			PSAY "Total Geral "+Space(55-Len("Total Geral "))
	@ nLin, pCol()+001	PSAY ""
	@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_tValLiq / _tQtdLiq,xMoeda(_tValLiq / _tQtdLiq,1,2)) Picture(PesqPict("SD2","D2_TOTAL"))
	@ nLin, pCol()+001	PSAY _tQtdBru			Picture(PesqPict("SD2","D2_QUANT"))
	@ nLin, pCol()+001	PSAY _tQtdDev			Picture(PesqPict("SD2","D2_QUANT"))
	@ nLin, pCol()+001	PSAY _tQtdLiq			Picture(PesqPict("SD2","D2_QUANT"))
	@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_tValBru,xMoeda(_tValBru,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
	@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_tValDev,xMoeda(_tValDev,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
	@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_tValLiq,xMoeda(_tValLiq,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
	
	dbSelectArea("QUERY")
	dbCloseArea("QUERY")
Else

	BuscaVendedor()	//----> query para busca dos dados de faturamento
	
	dbSelectArea("QUERY")
	SetRegua(RecCount())
	dbGoTop()
	
	While !Eof()
		
		If lAbortPrint
			@nLin,000		 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		If !Empty(aReturn[7]) .And. !&(aReturn[7])
			dbSelectArea("QUERY")
			dbSkip()
			Loop
		EndIf
		
		
		dbSelectArea("QUERY")
		
		_cVendedor :=	QUERY->F2_VEND1
		
		dbSelectArea("QUERY")
		
		@ nLin, 000		PSAY "Vendedor: "+_cVendedor+" "+Posicione("SA3",1,xFilial("SA3")+_cVendedor,"A3_NREDUZ")
		
		nLin++
		nLin++
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		While Eof() == .f. .And. _cVendedor	==	QUERY->F2_VEND1
			
			If !Empty(aReturn[7]) .And. !&(aReturn[7])
				dbSelectArea("QUERY")
				dbSkip()
				Loop
			EndIf
			
			
			
			dbSelectArea("QUERY")
			
			_cGrupo		:=	QUERY->B1_GRUPO
			
			dbSelectArea("QUERY")
			
			@ nLin, 000		PSAY "Grupo: "+_cGrupo+" "+Posicione("SBM",1,xFilial("SBM")+_cGrupo,"BM_DESC")
			
			nLin++
			nLin++
			
			If nLin > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			
			While Eof() == .f. .And. _cVendedor+_cGrupo	==	QUERY->F2_VEND1+QUERY->B1_GRUPO
				
				If !Empty(aReturn[7]) .And. !&(aReturn[7])
					dbSelectArea("QUERY")
					dbSkip()
					Loop
				EndIf
				
				@ nLin, 000			PSAY QUERY->D2_COD
				@ nLin, pCol()+001	PSAY SUBS(QUERY->B1_DESC,1,50)     
				@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,QUERY->D2_TOTAL / QUERY->D2_QUANT,xMoeda(QUERY->D2_TOTAL / QUERY->D2_QUANT,1,2)) Picture(PesqPict("SD2","D2_TOTAL"))
				@ nLin, pCol()+001	PSAY QUERY->D2_QUANT			Picture(PesqPict("SD2","D2_QUANT"))
				@ nLin, pCol()+001	PSAY 0							Picture(PesqPict("SD2","D2_QUANT"))
				@ nLin, pCol()+001	PSAY QUERY->D2_QUANT			Picture(PesqPict("SD2","D2_QUANT"))
				@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,QUERY->D2_TOTAL,xMoeda(QUERY->D2_TOTAL,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
				@ nLin, pCol()+001	PSAY 0							Picture(PesqPict("SD2","D2_TOTAL"))
				@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,QUERY->D2_TOTAL,xMoeda(QUERY->D2_TOTAL,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
				
				nLin++
				
				If nLin > 60
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 9
				Endif
				
				_nQtdBru += QUERY->D2_QUANT
				_nQtdDev += 0
				_nQtdLiq += (QUERY->D2_QUANT - 0 )
				
				_nValBru += QUERY->D2_TOTAL
				_nValDev += 0
				_nValLiq += (QUERY->D2_TOTAL - 0 )
				
				_eQtdBru += QUERY->D2_QUANT
				_eQtdDev += 0
				_eQtdLiq += (QUERY->D2_QUANT - 0 )
				
				_eValBru += QUERY->D2_TOTAL
				_eValDev += 0
				_eValLiq += (QUERY->D2_TOTAL - 0 )
				
				_tQtdBru += QUERY->D2_QUANT
				_tQtdDev += 0
				_tQtdLiq += (QUERY->D2_QUANT - 0 )
				
				_tValBru += QUERY->D2_TOTAL
				_tValDev += 0
				_tValLiq += (QUERY->D2_TOTAL - 0 )
				
				
				dbSelectArea("QUERY")
				dbSkip()
			EndDo
			
			nLin++
			
			If nLin > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			
			
			@ nLin, 000			PSAY "Total Grupo "+_cGrupo+" "+Posicione("SBM",1,xFilial("SBM")+_cGrupo,"BM_DESC")+Space(55-Len("Total Grupo "+_cGrupo+" "+Posicione("SBM",1,xFilial("SBM")+_cGrupo,"BM_DESC")))
			@ nLin, pCol()+001	PSAY ""  
			@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_nValLiq / _nQtdLiq,xMoeda(_nValLiq / _nQtdLiq,1,2)) Picture(PesqPict("SD2","D2_TOTAL"))
			@ nLin, pCol()+001	PSAY _nQtdBru			Picture(PesqPict("SD2","D2_QUANT"))
			@ nLin, pCol()+001	PSAY _nQtdDev			Picture(PesqPict("SD2","D2_QUANT"))
			@ nLin, pCol()+001	PSAY _nQtdLiq			Picture(PesqPict("SD2","D2_QUANT"))
			@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_nValBru,xMoeda(_nValBru,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
			@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_nValDev,xMoeda(_nValDev,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
			@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_nValLiq,xMoeda(_nValLiq,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
			
			nLin++
			
			@ nLin, 000 PSAY __PrtThinLine()

			nLin++

			If nLin > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			
			
			_nQtdBru := 0
			_nQtdDev := 0
			_nQtdLiq := 0
			
			_nValBru := 0
			_nValDev := 0
			_nValLiq := 0
			
			dbSelectArea("QUERY")
			
		EndDo
		nLin++
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		
		@ nLin, 000			PSAY "Total Vendedor "+_cVendedor+" "+Posicione("SA3",1,xFilial("SA3")+_cVendedor,"A3_NREDUZ")+Space(55-Len("Total Vendedor "+_cVendedor+" "+Posicione("SA3",1,xFilial("SA3")+_cVendedor,"A3_NREDUZ")))
		@ nLin, pCol()+001	PSAY ""
		@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_eValLiq / _eQtdLiq,xMoeda(_eValLiq / _eQtdLiq,1,2)) Picture(PesqPict("SD2","D2_TOTAL"))
		@ nLin, pCol()+001	PSAY _eQtdBru			Picture(PesqPict("SD2","D2_QUANT"))
		@ nLin, pCol()+001	PSAY _eQtdDev			Picture(PesqPict("SD2","D2_QUANT"))
		@ nLin, pCol()+001	PSAY _eQtdLiq			Picture(PesqPict("SD2","D2_QUANT"))
		@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_eValBru,xMoeda(_eValBru,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
		@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_eValDev,xMoeda(_eValDev,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
		@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_eValLiq,xMoeda(_eValLiq,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
		
		nLin++
		
		@ nLin, 000 PSAY __PrtThinLine()

		nLin++

		@ nLin, 000 PSAY __PrtThinLine()

		nLin++

		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		
		_eQtdBru := 0
		_eQtdDev := 0
		_eQtdLiq := 0
		
		_eValBru := 0
		_eValDev := 0
		_eValLiq := 0
		
		dbSelectArea("QUERY")
	EndDo
	
	nLin ++
	
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	@ nLin, 000			PSAY "Total Geral "+Space(55-Len("Total Geral "))
	@ nLin, pCol()+001	PSAY ""
	@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_tValLiq / _tQtdLiq,xMoeda(_tValLiq / _tQtdLiq,1,2)) Picture(PesqPict("SD2","D2_TOTAL"))
	@ nLin, pCol()+001	PSAY _tQtdBru			Picture(PesqPict("SD2","D2_QUANT"))
	@ nLin, pCol()+001	PSAY _tQtdDev			Picture(PesqPict("SD2","D2_QUANT"))
	@ nLin, pCol()+001	PSAY _tQtdLiq			Picture(PesqPict("SD2","D2_QUANT"))
	@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_tValBru,xMoeda(_tValBru,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
	@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_tValDev,xMoeda(_tValDev,1,2))			Picture(PesqPict("SD2","D2_TOTAL"))
	@ nLin, pCol()+001	PSAY Iif(MV_PAR11 == 1,_tValLiq,xMoeda(_tValLiq,1,2))			Picture(PesqPict("SD2","D2_TOTAL")) 
	nLin++                
	@ nLin, 000	PSAY "OBS: Valor da devolução por item, não considerando frete e desconto no total da NF. Comparado com relatório EstFat."
	dbSelectArea("QUERY")
	dbCloseArea("QUERY")
	
EndIf

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return


Static Function BuscaGrupo()

Local _cQuery := ""

_cQuery += "SELECT SD2010.D2_COD, SB1010.B1_DESC, SB1010.B1_GRUPO, SUM(SD2010.D2_QUANT) AS D2_QUANT, SUM(SD2010.D2_TOTAL) AS D2_TOTAL "
_cQuery += "FROM SD2010 INNER JOIN "
_cQuery += "SB1010 ON SD2010.D2_COD = SB1010.B1_COD INNER JOIN "
_cQuery += "SF4010 ON SD2010.D2_TES = SF4010.F4_CODIGO INNER JOIN "
_cQuery += "SF2010 ON SD2010.D2_FILIAL = SF2010.F2_FILIAL AND SD2010.D2_CLIENTE = SF2010.F2_CLIENTE AND "
_cQuery += "SD2010.D2_LOJA = SF2010.F2_LOJA AND SD2010.D2_DOC = SF2010.F2_DOC AND "
_cQuery += "SD2010.D2_SERIE = SF2010.F2_SERIE INNER JOIN "
_cQuery += "SA3010 ON SF2010.F2_VEND1 = SA3010.A3_COD "
_cQuery += "WHERE(SD2010.D_E_L_E_T_ = '') AND (SB1010.D_E_L_E_T_ = '') AND (SA3010.D_E_L_E_T_ = '') AND (SF2010.D_E_L_E_T_ = '') AND "
_cQuery += "(SF4010.D_E_L_E_T_ = '') "
_cQuery += "AND (SD2010.D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"')"
_cQuery += "AND (SD2010.D2_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"') "
_cQuery += "AND (SB1010.B1_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') "
_cQuery += "AND (SF2010.F2_EST BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"') "    
_cQuery += "AND (SF2010.F2_VEND1 BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"') "  
_cQuery += "AND (SF2010.F2_VALFAT > 0)"
_cQuery += "AND SF4010.F4_DUPLIC = 'S' AND SF2010.F2_TIPO = 'N' "
_cQuery += "GROUP BY SB1010.B1_GRUPO, SD2010.D2_COD, SB1010.B1_DESC "
_cQuery += "ORDER BY SB1010.B1_GRUPO, SD2010.D2_COD, SB1010.B1_DESC "

_cQuery	:=	ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QUERY",.T.,.T.)

TcSetField("QUERY","D2_TOTAL"  ,"N",TamSX3("D2_TOTAL"  )[1],TamSX3("D2_TOTAL"  )[2])
TcSetField("QUERY","D2_QUANT"  ,"N",TamSX3("D2_QUANT"  )[1],TamSX3("D2_QUANT"  )[2])
//TcSetField("QUERY","D2_EMISSAO"  ,"D",TamSX3("D2_EMISSAO"  )[1],TamSX3("D2_EMISSAO"  )[2])

Return

Static Function BGrupoQ()

Local _cQuery := ""

_cQuery += "SELECT SUM(SD2010.D2_QUANT) AS D2_QUANT "
_cQuery += "FROM SD2010 INNER JOIN "
_cQuery += "SB1010 ON SD2010.D2_COD = SB1010.B1_COD INNER JOIN "
_cQuery += "SF4010 ON SD2010.D2_TES = SF4010.F4_CODIGO INNER JOIN "
_cQuery += "SF2010 ON SD2010.D2_FILIAL = SF2010.F2_FILIAL AND SD2010.D2_CLIENTE = SF2010.F2_CLIENTE AND "
_cQuery += "SD2010.D2_LOJA = SF2010.F2_LOJA AND SD2010.D2_DOC = SF2010.F2_DOC AND "
_cQuery += "SD2010.D2_SERIE = SF2010.F2_SERIE INNER JOIN "
_cQuery += "SA3010 ON SF2010.F2_VEND1 = SA3010.A3_COD "
_cQuery += "WHERE(SD2010.D_E_L_E_T_ = '') AND (SB1010.D_E_L_E_T_ = '') AND (SA3010.D_E_L_E_T_ = '') AND (SF2010.D_E_L_E_T_ = '') AND "
_cQuery += "(SF4010.D_E_L_E_T_ = '') "
_cQuery += "AND (SD2010.D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"')"
_cQuery += "AND SD2010.D2_COD = '"+QUERY->D2_COD+"' "
_cQuery += "AND SB1010.B1_GRUPO = '"+QUERY->B1_GRUPO+"' "
_cQuery += "AND (SF2010.F2_EST BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"') "    
_cQuery += "AND (SF2010.F2_VEND1 BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"') "  
_cQuery += "AND SF4010.F4_ESTOQUE = 'S' " //SF4010.F4_DUPLIC = 'S' AND // SOLICITADO PELO SR. ACHILES PARA LISTAR PRODUTOS COM F4_DUPLIC = 'N' ** 03/06/212 ** - FELIPE VALENCA (MVG CONSULTORIA)
_cQuery += "GROUP BY SB1010.B1_GRUPO, SD2010.D2_COD, SB1010.B1_DESC "
_cQuery += "ORDER BY SB1010.B1_GRUPO, SD2010.D2_COD, SB1010.B1_DESC "

_cQuery	:=	ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QUERYQ",.T.,.T.)

TcSetField("QUERYQ","D2_QUANT"  ,"N",TamSX3("D2_QUANT"  )[1],TamSX3("D2_QUANT"  )[2])

Return


Static Function BuscaEstado()

Local _cQuery := ""

_cQuery += "SELECT SF2010.F2_EST, SD2010.D2_COD, SB1010.B1_DESC, SB1010.B1_GRUPO, SUM(SD2010.D2_QUANT) AS D2_QUANT, SUM(SD2010.D2_TOTAL) AS D2_TOTAL "
_cQuery += "FROM SD2010 INNER JOIN "
_cQuery += "SB1010 ON SD2010.D2_COD = SB1010.B1_COD INNER JOIN "
_cQuery += "SF4010 ON SD2010.D2_TES = SF4010.F4_CODIGO INNER JOIN "
_cQuery += "SF2010 ON SD2010.D2_FILIAL = SF2010.F2_FILIAL AND SD2010.D2_CLIENTE = SF2010.F2_CLIENTE AND "
_cQuery += "SD2010.D2_LOJA = SF2010.F2_LOJA AND SD2010.D2_DOC = SF2010.F2_DOC AND "
_cQuery += "SD2010.D2_SERIE = SF2010.F2_SERIE INNER JOIN "
_cQuery += "SA3010 ON SF2010.F2_VEND1 = SA3010.A3_COD "
_cQuery += "WHERE(SD2010.D_E_L_E_T_ = '') AND (SB1010.D_E_L_E_T_ = '') AND (SA3010.D_E_L_E_T_ = '') AND (SF2010.D_E_L_E_T_ = '') AND "
_cQuery += "(SF4010.D_E_L_E_T_ = '') "
_cQuery += "AND (SD2010.D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"')"
_cQuery += "AND (SD2010.D2_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"')"
_cQuery += "AND (SB1010.B1_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"')"
_cQuery += "AND (SF2010.F2_EST BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"')"
_cQuery += "AND (SF2010.F2_VEND1 BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"')"
_cQuery += "AND (SF2010.F2_VALFAT > 0)"
_cQuery += "GROUP BY SF2010.F2_EST, SB1010.B1_GRUPO, SD2010.D2_COD, SB1010.B1_DESC "
_cQuery += "ORDER BY SF2010.F2_EST, SB1010.B1_GRUPO, SD2010.D2_COD, SB1010.B1_DESC "

_cQuery	:=	ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QUERY",.T.,.T.)

TcSetField("QUERY","D2_TOTAL"  ,"N",TamSX3("D2_TOTAL"  )[1],TamSX3("D2_TOTAL"  )[2])
TcSetField("QUERY","D2_QUANT"  ,"N",TamSX3("D2_QUANT"  )[1],TamSX3("D2_QUANT"  )[2])

Return


Static Function BuscaVendedor()

Local _cQuery := ""

_cQuery += "SELECT SF2010.F2_VEND1, SD2010.D2_COD, SB1010.B1_DESC, SB1010.B1_GRUPO, SUM(SD2010.D2_QUANT) AS D2_QUANT, SUM(SD2010.D2_TOTAL) AS D2_TOTAL, D2_EMISSAO "
_cQuery += "FROM SD2010 INNER JOIN "
_cQuery += "SB1010 ON SD2010.D2_COD = SB1010.B1_COD INNER JOIN "
_cQuery += "SF4010 ON SD2010.D2_TES = SF4010.F4_CODIGO INNER JOIN "
_cQuery += "SF2010 ON SD2010.D2_FILIAL = SF2010.F2_FILIAL AND SD2010.D2_CLIENTE = SF2010.F2_CLIENTE AND "
_cQuery += "SD2010.D2_LOJA = SF2010.F2_LOJA AND SD2010.D2_DOC = SF2010.F2_DOC AND "
_cQuery += "SD2010.D2_SERIE = SF2010.F2_SERIE INNER JOIN "
_cQuery += "SA3010 ON SF2010.F2_VEND1 = SA3010.A3_COD "
_cQuery += "WHERE(SD2010.D_E_L_E_T_ = '') AND (SB1010.D_E_L_E_T_ = '') AND (SA3010.D_E_L_E_T_ = '') AND (SF2010.D_E_L_E_T_ = '') AND "
_cQuery += "(SF4010.D_E_L_E_T_ = '') "
_cQuery += "AND (SD2010.D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"')"
_cQuery += "AND (SD2010.D2_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"')"
_cQuery += "AND (SB1010.B1_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"')"
_cQuery += "AND (SF2010.F2_EST BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"')"
_cQuery += "AND (SF2010.F2_VEND1 BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"')"
_cQuery += "AND (SF2010.F2_VALFAT > 0)"
_cQuery += "GROUP BY SF2010.F2_VEND1, SB1010.B1_GRUPO, SD2010.D2_COD, SB1010.B1_DESC, SD2010.D2_EMISSAO "
_cQuery += "ORDER BY SF2010.F2_VEND1, SB1010.B1_GRUPO, SD2010.D2_COD, SB1010.B1_DESC, SD2010.D2_EMISSAO "

_cQuery	:=	ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QUERY",.T.,.T.)

TcSetField("QUERY","D2_TOTAL"  ,"N",TamSX3("D2_TOTAL"  )[1],TamSX3("D2_TOTAL"  )[2])
TcSetField("QUERY","D2_QUANT"  ,"N",TamSX3("D2_QUANT"  )[1],TamSX3("D2_QUANT"  )[2])
TcSetField("QUERY","D2_EMISSAO"  ,"D",TamSX3("D2_EMISSAO"  )[1],TamSX3("D2_EMISSAO"  )[2])

Return


Static Function BuscaDevGru()

Local _cQuery := ""

_cQuery += "SELECT SB1010.B1_GRUPO, SD1010.D1_COD, SUM(SD1010.D1_QUANT) AS D1_QUANT, SUM(SD1010.D1_TOTAL - SD1010.D1_VALDESC) AS D1_TOTAL "
_cQuery += "FROM SD1010 INNER JOIN "
_cQuery += "SF4010 ON SD1010.D1_TES = SF4010.F4_CODIGO INNER JOIN "
_cQuery += "SB1010 ON SD1010.D1_COD = SB1010.B1_COD "
_cQuery += "WHERE (SD1010.D_E_L_E_T_ = '') AND (SF4010.D_E_L_E_T_ = '') AND (SB1010.D_E_L_E_T_ = '') AND "
_cQuery += "(SD1010.D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') AND "
_cQuery += "SD1010.D1_COD = '"+QUERY->D2_COD+"' AND SB1010.B1_GRUPO = '"+QUERY->B1_GRUPO+"' AND " 
_cQuery += "SD1010.D1_TIPO = 'D' " 
_cQuery += "GROUP BY SB1010.B1_GRUPO, SD1010.D1_COD "
_cQuery += "ORDER BY SB1010.B1_GRUPO, SD1010.D1_COD "

_cQuery	:=	ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"DEVOL",.T.,.T.)

TcSetField("DEVOL","D1_TOTAL"  ,"N",TamSX3("D1_TOTAL"  )[1],TamSX3("D1_TOTAL"  )[2])
TcSetField("DEVOL","D1_DTDIGIT"  ,"D",TamSX3("D1_DTDIGIT"  )[1],TamSX3("D1_DTDIGIT"  )[2])

Return

Static Function BusDevGruQ()

Local _cQuery := ""

_cQuery += "SELECT SB1010.B1_GRUPO, SD1010.D1_COD, SUM(SD1010.D1_QUANT) AS D1_QUANT, SUM(SD1010.D1_TOTAL - SD1010.D1_VALDESC) AS D1_TOTAL, D1_DTDIGIT "
_cQuery += "FROM SD1010 INNER JOIN "
//_cQuery += "SD2010 ON SD1010.D1_NFORI = SD2010.D2_DOC AND SD1010.D1_SERIORI = SD2010.D2_SERIE AND " 
//_cQuery += "SD1010.D1_FILIAL = SD2010.D2_FILIAL AND SD1010.D1_FORNECE = SD2010.D2_CLIENTE AND " 
//_cQuery += "SD1010.D1_LOJA = SD2010.D2_LOJA INNER JOIN "
_cQuery += "SF4010 ON SD1010.D1_TES = SF4010.F4_CODIGO INNER JOIN "
//_cQuery += "SF2010 ON SD2010.D2_FILIAL = SF2010.F2_FILIAL AND SD2010.D2_DOC = SF2010.F2_DOC AND "
//_cQuery += "SD2010.D2_SERIE = SF2010.F2_SERIE INNER JOIN "
_cQuery += "SB1010 ON SD1010.D1_COD = SB1010.B1_COD "
//_cQuery += "SA3010 ON SF2010.F2_VEND1 = SA3010.A3_COD "
_cQuery += "WHERE (SD1010.D_E_L_E_T_ = '') AND (SF4010.D_E_L_E_T_ = '') AND (SB1010.D_E_L_E_T_ = '') AND "
_cQuery += "(SD1010.D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') AND "
_cQuery += "SD1010.D1_COD = '"+QUERY->D2_COD+"' AND SB1010.B1_GRUPO = '"+QUERY->B1_GRUPO+"' AND " 
_cQuery += "SD1010.D1_TIPO = 'D' "     
_cQuery += "AND SF4010.F4_ESTOQUE = 'S' "
_cQuery += "GROUP BY SB1010.B1_GRUPO, SD1010.D1_COD, SD1010.D1_DTDIGIT  "
_cQuery += "ORDER BY SB1010.B1_GRUPO, SD1010.D1_COD, SD1010.D1_DTDIGIT  "

_cQuery	:=	ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"DEVOLQ",.T.,.T.)

TcSetField("DEVOLQ","D1_QUANT"  ,"N",TamSX3("D1_QUANT"  )[1],TamSX3("D1_QUANT"  )[2])
TcSetField("DEVOLQ","D1_DTDIGIT"  ,"D",TamSX3("D1_DTDIGIT"  )[1],TamSX3("D1_DTDIGIT"  )[2])

MemoWrite("RFATR12.TXT",_cQuery)
Return

Static Function BuscaDevEst()

Local _cQuery := ""

_cQuery += "SELECT SF1010.F1_EST, SB1010.B1_GRUPO, SD1010.D1_COD, SUM(SD1010.D1_QUANT) AS D1_QUANT, SUM(SD1010.D1_TOTAL - SD1010.D1_VALDESC) AS D1_TOTAL, SB1010.B1_DESC, D1_DTDIGIT "
_cQuery += "FROM SD1010 INNER JOIN "
_cQuery += "SD2010 ON SD1010.D1_NFORI = SD2010.D2_DOC AND SD1010.D1_SERIORI = SD2010.D2_SERIE AND SD1010.D1_ITEMORI = SD2010.D2_ITEM AND " 
_cQuery += "SD1010.D1_FILIAL = SD2010.D2_FILIAL AND SD1010.D1_FORNECE = SD2010.D2_CLIENTE AND " 
_cQuery += "SD1010.D1_LOJA = SD2010.D2_LOJA INNER JOIN "
_cQuery += "SF4010 ON SD1010.D1_TES = SF4010.F4_CODIGO INNER JOIN "
_cQuery += "SF2010 ON SD2010.D2_FILIAL = SF2010.F2_FILIAL AND SD2010.D2_DOC = SF2010.F2_DOC AND "
_cQuery += "SD2010.D2_SERIE = SF2010.F2_SERIE INNER JOIN "
_cQuery += "SB1010 ON SD1010.D1_COD = SB1010.B1_COD INNER JOIN "
_cQuery += "SA3010 ON SF2010.F2_VEND1 = SA3010.A3_COD "
_cQuery += "WHERE (SD1010.D_E_L_E_T_ = '') AND (SD1010.D1_TIPO IN ('B', 'D')) AND (SD2010.D_E_L_E_T_ = '') AND (SF4010.D_E_L_E_T_ = '') AND "
_cQuery += "(SF2010.D_E_L_E_T_ = '') AND (SB1010.D_E_L_E_T_ = '') AND (SA3010.D_E_L_E_T_ = '') AND (SD1010.D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') AND "
_cQuery += "SF1010.F1_EST = '"+QUERY->F1_EST+"' AND SD1010.D1_COD = '"+QUERY->D2_COD+"' AND SB1010.B1_GRUPO = '"+QUERY->B1_GRUPO+"' "
_cQuery += "GROUP BY SF1010.F1_EST, SB1010.B1_GRUPO, SD1010.D1_COD, SB1010.B1_DESC, SD1010.D1_DTDIGIT "
_cQuery += "ORDER BY SF1010.F1_EST, SB1010.B1_GRUPO, SD1010.D1_COD, SB1010.B1_DESC, SD1010.D1_DTDIGIT "

_cQuery	:=	ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"DEVOL",.T.,.T.)

TcSetField("DEVOL","D1_TOTAL"  ,"N",TamSX3("D1_TOTAL"  )[1],TamSX3("D1_TOTAL"  )[2])
TcSetField("DEVOL","D1_QUANT"  ,"N",TamSX3("D1_QUANT"  )[1],TamSX3("D1_QUANT"  )[2])
TcSetField("DEVOL","D1_DTDIGIT"  ,"D",TamSX3("D1_DTDIGIT"  )[1],TamSX3("D1_DTDIGIT"  )[2])

Return