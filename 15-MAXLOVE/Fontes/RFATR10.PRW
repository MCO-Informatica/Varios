#INCLUDE "rwmake.ch"
/*
?????????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????Ŀ??
???Programa  ? RFATR10  ? Autor ? Ricardo Correa de Souza ? Data ? 01/04/2010 ???
???          ?          ?       ? MVG Consultoria Ltda    ?      ?            ???
?????????????????????????????????????????????????????????????????????????????Ĵ??
???Descricao ? Relatorio de Faturamento por Produto                           ???
?????????????????????????????????????????????????????????????????????????????Ĵ??
???Observacao? Quebra por Grupo/Estado/Vendedor                               ???
?????????????????????????????????????????????????????????????????????????????Ĵ??
???Uso       ?                                                                ???
?????????????????????????????????????????????????????????????????????????????Ĵ??
???             ATUALIZACOES SOFRIDAS DESDE A CONSTRU?AO INICIAL              ???
?????????????????????????????????????????????????????????????????????????????Ĵ??
???Programador   ?  Data  ?              Motivo da Alteracao                  ???
?????????????????????????????????????????????????????????????????????????????Ĵ??
???              ?        ?                                                   ???
??????????????????????????????????????????????????????????????????????????????ٱ?
?????????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????????
*/

User Function RFATR10()


//?????????????????????????????????????????????????????????????????????Ŀ
//? Declaracao de Variaveis                                             ?
//???????????????????????????????????????????????????????????????????????

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
Private nomeprog     := "RFATR10"
Private nTipo        := 18
Private aOrd         := {"Por Grupo Produto","Por Estado","Por Vendedor"}
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RFATR10"
Private cString 	 := "SF2"
Private cPerg   	 := "FATR10"
Private nOrdem

//??????????????????????????????????????????????????????????????Ŀ
//? Verifica as perguntas selecionadas                           ?
//????????????????????????????????????????????????????????????????

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


Cabec1       	 := "PRODUTO         DESCRICAO                                          QUANTIDADE     QUANTIDADE     QUANTIDADE     VALOR        VALOR        VALOR        "
Cabec2       	 := "                                                                   BRUTA          DEVOL          LIQUIDA        BRUTO        DEVOL        LIQUIDO      "
	
//?????????????????????????????????????????????????????????????????????Ŀ
//? Processamento. RPTSTATUS monta janela com a regua de processamento. ?
//???????????????????????????????????????????????????????????????????????

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Fun??o    ?RUNREPORT ? Autor ? AP6 IDE            ? Data ?  23/05/05   ???
?????????????????????????????????????????????????????????????????????????͹??
???Descri??o ? Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ???
???          ? monta a janela com a regua de processamento.               ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Programa principal                                         ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
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
		
		dbSelectArea("QUERY")
		
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
			
			@ nLin, 000			PSAY QUERY->D2_COD
			@ nLin, pCol()+001	PSAY SUBS(QUERY->B1_DESC,1,50)
			@ nLin, pCol()+001	PSAY QUERY->D2_QUANT						Picture(PesqPict("SD2","D2_QUANT"))
			@ nLin, pCol()+001	PSAY DEVOL->D1_QUANT						Picture(PesqPict("SD2","D2_QUANT"))
			@ nLin, pCol()+001	PSAY QUERY->D2_QUANT-DEVOL->D1_QUANT		Picture(PesqPict("SD2","D2_QUANT"))
			@ nLin, pCol()+001	PSAY QUERY->D2_TOTAL						Picture(PesqPict("SD2","D2_TOTAL"))
			@ nLin, pCol()+001	PSAY DEVOL->D1_TOTAL						Picture(PesqPict("SD2","D2_TOTAL"))
			@ nLin, pCol()+001	PSAY QUERY->D2_TOTAL-DEVOL->D1_TOTAL		Picture(PesqPict("SD2","D2_TOTAL"))
			
			nLin++
			
			If nLin > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			
			_nQtdBru += QUERY->D2_QUANT
			_nQtdDev += DEVOL->D1_QUANT
			_nQtdLiq += (QUERY->D2_QUANT - DEVOL->D1_QUANT )
			
			_nValBru += QUERY->D2_TOTAL
			_nValDev += DEVOL->D1_TOTAL
			_nValLiq += (QUERY->D2_TOTAL - DEVOL->D1_TOTAL )
			
			_tQtdBru += QUERY->D2_QUANT
			_tQtdDev += DEVOL->D1_QUANT
			_tQtdLiq += (QUERY->D2_QUANT - DEVOL->D1_QUANT )
			
			_tValBru += QUERY->D2_TOTAL
			_tValDev += DEVOL->D1_TOTAL
			_tValLiq += (QUERY->D2_TOTAL - DEVOL->D1_TOTAL )
			
			
			dbSelectArea("DEVOL")
			dbCloseArea()
			
			dbSelectArea("QUERY")
			dbSkip()
		EndDo
		
		nLin++
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		
		@ nLin, 000			PSAY "Total Grupo "+_cGrupo+" "+Posicione("SBM",1,xFilial("SBM")+_cGrupo,"BM_DESC")+Space(65-Len("Total Grupo "+_cGrupo+" "+Posicione("SBM",1,xFilial("SBM")+_cGrupo,"BM_DESC")))
		@ nLin, pCol()+001	PSAY ""
		@ nLin, pCol()+001	PSAY _nQtdBru			Picture(PesqPict("SD2","D2_QUANT"))
		@ nLin, pCol()+001	PSAY _nQtdDev			Picture(PesqPict("SD2","D2_QUANT"))
		@ nLin, pCol()+001	PSAY _nQtdLiq			Picture(PesqPict("SD2","D2_QUANT"))
		@ nLin, pCol()+001	PSAY _nValBru			Picture(PesqPict("SD2","D2_TOTAL"))
		@ nLin, pCol()+001	PSAY _nValDev			Picture(PesqPict("SD2","D2_TOTAL"))
		@ nLin, pCol()+001	PSAY _nValLiq			Picture(PesqPict("SD2","D2_TOTAL"))
		
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
	
	@ nLin, 000			PSAY "Total Geral "+Space(65-Len("Total Geral "))
	@ nLin, pCol()+001	PSAY ""
	@ nLin, pCol()+001	PSAY _tQtdBru			Picture(PesqPict("SD2","D2_QUANT"))
	@ nLin, pCol()+001	PSAY _tQtdDev			Picture(PesqPict("SD2","D2_QUANT"))
	@ nLin, pCol()+001	PSAY _tQtdLiq			Picture(PesqPict("SD2","D2_QUANT"))
	@ nLin, pCol()+001	PSAY _tValBru			Picture(PesqPict("SD2","D2_TOTAL"))
	@ nLin, pCol()+001	PSAY _tValDev			Picture(PesqPict("SD2","D2_TOTAL"))
	@ nLin, pCol()+001	PSAY _tValLiq			Picture(PesqPict("SD2","D2_TOTAL"))
	
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
				@ nLin, pCol()+001	PSAY QUERY->D2_QUANT			Picture(PesqPict("SD2","D2_QUANT"))
				@ nLin, pCol()+001	PSAY 0							Picture(PesqPict("SD2","D2_QUANT"))
				@ nLin, pCol()+001	PSAY QUERY->D2_QUANT			Picture(PesqPict("SD2","D2_QUANT"))
				@ nLin, pCol()+001	PSAY QUERY->D2_TOTAL			Picture(PesqPict("SD2","D2_TOTAL"))
				@ nLin, pCol()+001	PSAY 0							Picture(PesqPict("SD2","D2_TOTAL"))
				@ nLin, pCol()+001	PSAY QUERY->D2_TOTAL			Picture(PesqPict("SD2","D2_TOTAL"))
				
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
			
			
			@ nLin, 000			PSAY "Total Grupo "+_cGrupo+" "+Posicione("SBM",1,xFilial("SBM")+_cGrupo,"BM_DESC")+Space(65-Len("Total Grupo "+_cGrupo+" "+Posicione("SBM",1,xFilial("SBM")+_cGrupo,"BM_DESC")))
			@ nLin, pCol()+001	PSAY ""
			@ nLin, pCol()+001	PSAY _nQtdBru			Picture(PesqPict("SD2","D2_QUANT"))
			@ nLin, pCol()+001	PSAY _nQtdDev			Picture(PesqPict("SD2","D2_QUANT"))
			@ nLin, pCol()+001	PSAY _nQtdLiq			Picture(PesqPict("SD2","D2_QUANT"))
			@ nLin, pCol()+001	PSAY _nValBru			Picture(PesqPict("SD2","D2_TOTAL"))
			@ nLin, pCol()+001	PSAY _nValDev			Picture(PesqPict("SD2","D2_TOTAL"))
			@ nLin, pCol()+001	PSAY _nValLiq			Picture(PesqPict("SD2","D2_TOTAL"))
			
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
		
		
		@ nLin, 000			PSAY "Total Estado "+_cEstado+Space(65-Len("Total Estado "+_cEstado))
		@ nLin, pCol()+001	PSAY ""
		@ nLin, pCol()+001	PSAY _eQtdBru			Picture(PesqPict("SD2","D2_QUANT"))
		@ nLin, pCol()+001	PSAY _eQtdDev			Picture(PesqPict("SD2","D2_QUANT"))
		@ nLin, pCol()+001	PSAY _eQtdLiq			Picture(PesqPict("SD2","D2_QUANT"))
		@ nLin, pCol()+001	PSAY _eValBru			Picture(PesqPict("SD2","D2_TOTAL"))
		@ nLin, pCol()+001	PSAY _eValDev			Picture(PesqPict("SD2","D2_TOTAL"))
		@ nLin, pCol()+001	PSAY _eValLiq			Picture(PesqPict("SD2","D2_TOTAL"))
		
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
	
	@ nLin, 000			PSAY "Total Geral "+Space(65-Len("Total Geral "))
	@ nLin, pCol()+001	PSAY ""
	@ nLin, pCol()+001	PSAY _tQtdBru			Picture(PesqPict("SD2","D2_QUANT"))
	@ nLin, pCol()+001	PSAY _tQtdDev			Picture(PesqPict("SD2","D2_QUANT"))
	@ nLin, pCol()+001	PSAY _tQtdLiq			Picture(PesqPict("SD2","D2_QUANT"))
	@ nLin, pCol()+001	PSAY _tValBru			Picture(PesqPict("SD2","D2_TOTAL"))
	@ nLin, pCol()+001	PSAY _tValDev			Picture(PesqPict("SD2","D2_TOTAL"))
	@ nLin, pCol()+001	PSAY _tValLiq			Picture(PesqPict("SD2","D2_TOTAL"))
	
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
				@ nLin, pCol()+001	PSAY QUERY->D2_QUANT			Picture(PesqPict("SD2","D2_QUANT"))
				@ nLin, pCol()+001	PSAY 0							Picture(PesqPict("SD2","D2_QUANT"))
				@ nLin, pCol()+001	PSAY QUERY->D2_QUANT			Picture(PesqPict("SD2","D2_QUANT"))
				@ nLin, pCol()+001	PSAY QUERY->D2_TOTAL			Picture(PesqPict("SD2","D2_TOTAL"))
				@ nLin, pCol()+001	PSAY 0							Picture(PesqPict("SD2","D2_TOTAL"))
				@ nLin, pCol()+001	PSAY QUERY->D2_TOTAL			Picture(PesqPict("SD2","D2_TOTAL"))
				
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
			
			
			@ nLin, 000			PSAY "Total Grupo "+_cGrupo+" "+Posicione("SBM",1,xFilial("SBM")+_cGrupo,"BM_DESC")+Space(65-Len("Total Grupo "+_cGrupo+" "+Posicione("SBM",1,xFilial("SBM")+_cGrupo,"BM_DESC")))
			@ nLin, pCol()+001	PSAY ""
			@ nLin, pCol()+001	PSAY _nQtdBru			Picture(PesqPict("SD2","D2_QUANT"))
			@ nLin, pCol()+001	PSAY _nQtdDev			Picture(PesqPict("SD2","D2_QUANT"))
			@ nLin, pCol()+001	PSAY _nQtdLiq			Picture(PesqPict("SD2","D2_QUANT"))
			@ nLin, pCol()+001	PSAY _nValBru			Picture(PesqPict("SD2","D2_TOTAL"))
			@ nLin, pCol()+001	PSAY _nValDev			Picture(PesqPict("SD2","D2_TOTAL"))
			@ nLin, pCol()+001	PSAY _nValLiq			Picture(PesqPict("SD2","D2_TOTAL"))
			
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
		
		
		@ nLin, 000			PSAY "Total Vendedor "+_cVendedor+" "+Posicione("SA3",1,xFilial("SA3")+_cVendedor,"A3_NREDUZ")+Space(65-Len("Total Vendedor "+_cVendedor+" "+Posicione("SA3",1,xFilial("SA3")+_cVendedor,"A3_NREDUZ")))
		@ nLin, pCol()+001	PSAY ""
		@ nLin, pCol()+001	PSAY _eQtdBru			Picture(PesqPict("SD2","D2_QUANT"))
		@ nLin, pCol()+001	PSAY _eQtdDev			Picture(PesqPict("SD2","D2_QUANT"))
		@ nLin, pCol()+001	PSAY _eQtdLiq			Picture(PesqPict("SD2","D2_QUANT"))
		@ nLin, pCol()+001	PSAY _eValBru			Picture(PesqPict("SD2","D2_TOTAL"))
		@ nLin, pCol()+001	PSAY _eValDev			Picture(PesqPict("SD2","D2_TOTAL"))
		@ nLin, pCol()+001	PSAY _eValLiq			Picture(PesqPict("SD2","D2_TOTAL"))
		
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
	
	@ nLin, 000			PSAY "Total Geral "+Space(65-Len("Total Geral "))
	@ nLin, pCol()+001	PSAY ""
	@ nLin, pCol()+001	PSAY _tQtdBru			Picture(PesqPict("SD2","D2_QUANT"))
	@ nLin, pCol()+001	PSAY _tQtdDev			Picture(PesqPict("SD2","D2_QUANT"))
	@ nLin, pCol()+001	PSAY _tQtdLiq			Picture(PesqPict("SD2","D2_QUANT"))
	@ nLin, pCol()+001	PSAY _tValBru			Picture(PesqPict("SD2","D2_TOTAL"))
	@ nLin, pCol()+001	PSAY _tValDev			Picture(PesqPict("SD2","D2_TOTAL"))
	@ nLin, pCol()+001	PSAY _tValLiq			Picture(PesqPict("SD2","D2_TOTAL"))
	
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

_cQuery += "SELECT SD2010.D2_COD, SB1010.B1_DESC, SB1010.B1_GRUPO, SUM(SD2010.D2_QUANT) AS D2_QUANT, SUM(SD2010.D2_TOTAL+SD2010.D2_VALIPI+SD2010.D2_VALFRE+SD2010.D2_DESPESA+SD2010.D2_SEGURO+SD2010.D2_ICMSRET) AS D2_TOTAL "
_cQuery += "FROM SD2010 INNER JOIN "
_cQuery += "SB1010 ON SD2010.D2_COD = SB1010.B1_COD INNER JOIN "
_cQuery += "SF4010 ON SD2010.D2_TES = SF4010.F4_CODIGO INNER JOIN "
_cQuery += "SF2010 ON SD2010.D2_FILIAL = SF2010.F2_FILIAL AND SD2010.D2_CLIENTE = SF2010.F2_CLIENTE AND "
_cQuery += "SD2010.D2_LOJA = SF2010.F2_LOJA AND SD2010.D2_DOC = SF2010.F2_DOC AND "
_cQuery += "SD2010.D2_SERIE = SF2010.F2_SERIE INNER JOIN "
_cQuery += "SA3010 ON SF2010.F2_VEND1 = SA3010.A3_COD "
_cQuery += "WHERE(SD2010.D_E_L_E_T_ = '') AND (SB1010.D_E_L_E_T_ = '') AND (SA3010.D_E_L_E_T_ = '') AND (SF2010.D_E_L_E_T_ = '') AND "
_cQuery += "(SF4010.D_E_L_E_T_ = '') AND (SD2010.D2_EMISSAO BETWEEN '20100301' AND '20100331') "
_cQuery += "GROUP BY SB1010.B1_GRUPO, SD2010.D2_COD, SB1010.B1_DESC "
_cQuery += "ORDER BY SB1010.B1_GRUPO, SD2010.D2_COD, SB1010.B1_DESC "

_cQuery	:=	ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QUERY",.T.,.T.)

TcSetField("QUERY","D2_TOTAL"  ,"N",TamSX3("D2_TOTAL"  )[1],TamSX3("D2_TOTAL"  )[2])
TcSetField("QUERY","D2_QUANT"  ,"N",TamSX3("D2_QUANT"  )[1],TamSX3("D2_QUANT"  )[2])

Return


Static Function BuscaEstado()

Local _cQuery := ""

_cQuery += "SELECT SF2010.F2_EST, SD2010.D2_COD, SB1010.B1_DESC, SB1010.B1_GRUPO, SUM(SD2010.D2_QUANT) AS D2_QUANT, SUM(SD2010.D2_TOTAL+SD2010.D2_VALIPI+SD2010.D2_VALFRE+SD2010.D2_DESPESA+SD2010.D2_SEGURO+SD2010.D2_ICMSRET) AS D2_TOTAL "
_cQuery += "FROM SD2010 INNER JOIN "
_cQuery += "SB1010 ON SD2010.D2_COD = SB1010.B1_COD INNER JOIN "
_cQuery += "SF4010 ON SD2010.D2_TES = SF4010.F4_CODIGO INNER JOIN "
_cQuery += "SF2010 ON SD2010.D2_FILIAL = SF2010.F2_FILIAL AND SD2010.D2_CLIENTE = SF2010.F2_CLIENTE AND "
_cQuery += "SD2010.D2_LOJA = SF2010.F2_LOJA AND SD2010.D2_DOC = SF2010.F2_DOC AND "
_cQuery += "SD2010.D2_SERIE = SF2010.F2_SERIE INNER JOIN "
_cQuery += "SA3010 ON SF2010.F2_VEND1 = SA3010.A3_COD "
_cQuery += "WHERE(SD2010.D_E_L_E_T_ = '') AND (SB1010.D_E_L_E_T_ = '') AND (SA3010.D_E_L_E_T_ = '') AND (SF2010.D_E_L_E_T_ = '') AND "
_cQuery += "(SF4010.D_E_L_E_T_ = '') AND (SD2010.D2_EMISSAO BETWEEN '20100301' AND '20100331') "
_cQuery += "GROUP BY SF2010.F2_EST, SB1010.B1_GRUPO, SD2010.D2_COD, SB1010.B1_DESC "
_cQuery += "ORDER BY SF2010.F2_EST, SB1010.B1_GRUPO, SD2010.D2_COD, SB1010.B1_DESC "

_cQuery	:=	ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QUERY",.T.,.T.)

TcSetField("QUERY","D2_TOTAL"  ,"N",TamSX3("D2_TOTAL"  )[1],TamSX3("D2_TOTAL"  )[2])
TcSetField("QUERY","D2_QUANT"  ,"N",TamSX3("D2_QUANT"  )[1],TamSX3("D2_QUANT"  )[2])

Return


Static Function BuscaVendedor()

Local _cQuery := ""

_cQuery += "SELECT SF2010.F2_VEND1, SD2010.D2_COD, SB1010.B1_DESC, SB1010.B1_GRUPO, SUM(SD2010.D2_QUANT) AS D2_QUANT, SUM(SD2010.D2_TOTAL+SD2010.D2_VALIPI+SD2010.D2_VALFRE+SD2010.D2_DESPESA+SD2010.D2_SEGURO+SD2010.D2_ICMSRET) AS D2_TOTAL "
_cQuery += "FROM SD2010 INNER JOIN "
_cQuery += "SB1010 ON SD2010.D2_COD = SB1010.B1_COD INNER JOIN "
_cQuery += "SF4010 ON SD2010.D2_TES = SF4010.F4_CODIGO INNER JOIN "
_cQuery += "SF2010 ON SD2010.D2_FILIAL = SF2010.F2_FILIAL AND SD2010.D2_CLIENTE = SF2010.F2_CLIENTE AND "
_cQuery += "SD2010.D2_LOJA = SF2010.F2_LOJA AND SD2010.D2_DOC = SF2010.F2_DOC AND "
_cQuery += "SD2010.D2_SERIE = SF2010.F2_SERIE INNER JOIN "
_cQuery += "SA3010 ON SF2010.F2_VEND1 = SA3010.A3_COD "
_cQuery += "WHERE(SD2010.D_E_L_E_T_ = '') AND (SB1010.D_E_L_E_T_ = '') AND (SA3010.D_E_L_E_T_ = '') AND (SF2010.D_E_L_E_T_ = '') AND "
_cQuery += "(SF4010.D_E_L_E_T_ = '') AND (SD2010.D2_EMISSAO BETWEEN '20100301' AND '20100331') "
_cQuery += "GROUP BY SF2010.F2_VEND1, SB1010.B1_GRUPO, SD2010.D2_COD, SB1010.B1_DESC "
_cQuery += "ORDER BY SF2010.F2_VEND1, SB1010.B1_GRUPO, SD2010.D2_COD, SB1010.B1_DESC "

_cQuery	:=	ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QUERY",.T.,.T.)

TcSetField("QUERY","D2_TOTAL"  ,"N",TamSX3("D2_TOTAL"  )[1],TamSX3("D2_TOTAL"  )[2])
TcSetField("QUERY","D2_QUANT"  ,"N",TamSX3("D2_QUANT"  )[1],TamSX3("D2_QUANT"  )[2])

Return



Static Function BuscaDevGru()

Local _cQuery := ""

_cQuery += "SELECT SB1010.B1_GRUPO, SD1010.D1_COD, SUM(SD1010.D1_QUANT) AS D1_QUANT, SUM(SD1010.D1_TOTAL - SD1010.D1_VALDESC + SD1010.D1_VALIPI + SD1010.D1_ICMSRET + SD1010.D1_DESPESA + SD1010.D1_SEGURO) AS D1_TOTAL, SB1010.B1_DESC "
_cQuery += "FROM SD1010 INNER JOIN "
_cQuery += "SD2010 ON SD1010.D1_NFORI = SD2010.D2_DOC AND SD1010.D1_SERIORI = SD2010.D2_SERIE AND " 
_cQuery += "SD1010.D1_FILIAL = SD2010.D2_FILIAL AND SD1010.D1_FORNECE = SD2010.D2_CLIENTE AND " 
_cQuery += "SD1010.D1_LOJA = SD2010.D2_LOJA INNER JOIN "
_cQuery += "SF4010 ON SD1010.D1_TES = SF4010.F4_CODIGO INNER JOIN "
_cQuery += "SF2010 ON SD2010.D2_FILIAL = SF2010.F2_FILIAL AND SD2010.D2_DOC = SF2010.F2_DOC AND "
_cQuery += "SD2010.D2_SERIE = SF2010.F2_SERIE INNER JOIN "
_cQuery += "SB1010 ON SD1010.D1_COD = SB1010.B1_COD INNER JOIN "
_cQuery += "SA3010 ON SF2010.F2_VEND1 = SA3010.A3_COD "
_cQuery += "WHERE (SD1010.D_E_L_E_T_ = '') AND (SD1010.D1_TIPO IN ('B', 'D')) AND (SD2010.D_E_L_E_T_ = '') AND (SF4010.D_E_L_E_T_ = '') AND "
_cQuery += "(SF2010.D_E_L_E_T_ = '') AND (SB1010.D_E_L_E_T_ = '') AND (SA3010.D_E_L_E_T_ = '') AND (SD1010.D1_DTDIGIT BETWEEN '20100301' AND '20100331') AND "
_cQuery += "SD1010.D1_COD = '"+QUERY->D2_COD+"' AND SB1010.B1_GRUPO = '"+QUERY->B1_GRUPO+"' "
_cQuery += "GROUP BY SB1010.B1_GRUPO, SD1010.D1_COD, SB1010.B1_DESC "
_cQuery += "ORDER BY SB1010.B1_GRUPO, SD1010.D1_COD, SB1010.B1_DESC "

_cQuery	:=	ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"DEVOL",.T.,.T.)

TcSetField("DEVOL","D1_TOTAL"  ,"N",TamSX3("D1_TOTAL"  )[1],TamSX3("D1_TOTAL"  )[2])
TcSetField("DEVOL","D1_QUANT"  ,"N",TamSX3("D1_QUANT"  )[1],TamSX3("D1_QUANT"  )[2])

Return


Static Function DevEstE()

Local _cQuery := ""

_cQuery += "SELECT SF1010.F1_EST, SB1010.B1_GRUPO, SD1010.D1_COD, SUM(SD1010.D1_QUANT) AS D1_QUANT, SUM(SD1010.D1_TOTAL - SD1010.D1_VALDESC + SD1010.D1_VALIPI + SD1010.D1_ICMSRET + SD1010.D1_DESPESA + SD1010.D1_SEGURO) AS D1_TOTAL, SB1010.B1_DESC "
_cQuery += "FROM SD1010 INNER JOIN "
_cQuery += "SD2010 ON SD1010.D1_NFORI = SD2010.D2_DOC AND SD1010.D1_SERIORI = SD2010.D2_SERIE AND " 
_cQuery += "SD1010.D1_FILIAL = SD2010.D2_FILIAL AND SD1010.D1_FORNECE = SD2010.D2_CLIENTE AND " 
_cQuery += "SD1010.D1_LOJA = SD2010.D2_LOJA INNER JOIN "
_cQuery += "SF4010 ON SD1010.D1_TES = SF4010.F4_CODIGO INNER JOIN "
_cQuery += "SF2010 ON SD2010.D2_FILIAL = SF2010.F2_FILIAL AND SD2010.D2_DOC = SF2010.F2_DOC AND "
_cQuery += "SD2010.D2_SERIE = SF2010.F2_SERIE INNER JOIN "
_cQuery += "SB1010 ON SD1010.D1_COD = SB1010.B1_COD INNER JOIN "
_cQuery += "SA3010 ON SF2010.F2_VEND1 = SA3010.A3_COD "
_cQuery += "WHERE (SD1010.D_E_L_E_T_ = '') AND (SD1010.D1_TIPO IN ('B', 'D')) AND (SD2010.D_E_L_E_T_ = '') AND (SF4010.D_E_L_E_T_ = '') AND "
_cQuery += "(SF2010.D_E_L_E_T_ = '') AND (SB1010.D_E_L_E_T_ = '') AND (SA3010.D_E_L_E_T_ = '') AND (SD1010.D1_DTDIGIT BETWEEN '20100301' AND '20100331') AND "
_cQuery += "SF1010.F1_EST = '"+QUERY->F1_EST+"' AND SD1010.D1_COD = '"+QUERY->D2_COD+"' AND SB1010.B1_GRUPO = '"+QUERY->B1_GRUPO+"' "
_cQuery += "GROUP BY SF1010.F1_EST, SB1010.B1_GRUPO, SD1010.D1_COD, SB1010.B1_DESC "
_cQuery += "ORDER BY SF1010.F1_EST, SB1010.B1_GRUPO, SD1010.D1_COD, SB1010.B1_DESC "

_cQuery	:=	ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"DEVOL",.T.,.T.)

TcSetField("DEVOL","D1_TOTAL"  ,"N",TamSX3("D1_TOTAL"  )[1],TamSX3("D1_TOTAL"  )[2])
TcSetField("DEVOL","D1_QUANT"  ,"N",TamSX3("D1_QUANT"  )[1],TamSX3("D1_QUANT"  )[2])

Return

Static Function DevEstS()

Local _cQuery := ""

_cQuery += "SELECT SF2010.F2_VEND1, SB1010.B1_GRUPO, SD1010.D1_COD, SUM(SD1010.D1_QUANT) AS D1_QUANT, SUM(SD1010.D1_TOTAL - SD1010.D1_VALDESC + SD1010.D1_VALIPI + SD1010.D1_ICMSRET + SD1010.D1_DESPESA + SD1010.D1_SEGURO) AS D1_TOTAL, SB1010.B1_DESC "
_cQuery += "FROM SD1010 INNER JOIN "
_cQuery += "SD2010 ON SD1010.D1_NFORI = SD2010.D2_DOC AND SD1010.D1_SERIORI = SD2010.D2_SERIE AND " 
_cQuery += "SD1010.D1_FILIAL = SD2010.D2_FILIAL AND SD1010.D1_FORNECE = SD2010.D2_CLIENTE AND " 
_cQuery += "SD1010.D1_LOJA = SD2010.D2_LOJA INNER JOIN "
_cQuery += "SF4010 ON SD1010.D1_TES = SF4010.F4_CODIGO INNER JOIN "
_cQuery += "SF2010 ON SD2010.D2_FILIAL = SF2010.F2_FILIAL AND SD2010.D2_DOC = SF2010.F2_DOC AND "
_cQuery += "SD2010.D2_SERIE = SF2010.F2_SERIE INNER JOIN "
_cQuery += "SB1010 ON SD1010.D1_COD = SB1010.B1_COD INNER JOIN "
_cQuery += "SA3010 ON SF2010.F2_VEND1 = SA3010.A3_COD "
_cQuery += "WHERE (SD1010.D_E_L_E_T_ = '') AND (SD1010.D1_TIPO IN ('B', 'D')) AND (SD2010.D_E_L_E_T_ = '') AND (SF4010.D_E_L_E_T_ = '') AND "
_cQuery += "(SF2010.D_E_L_E_T_ = '') AND (SB1010.D_E_L_E_T_ = '') AND (SA3010.D_E_L_E_T_ = '') AND (SD1010.D1_DTDIGIT BETWEEN '20100301' AND '20100331') AND "
_cQuery += "SF2010.F2_VEND1 = '"+QUERY->F2_VEND1+"' AND SD1010.D1_COD = '"+QUERY->D2_COD+"' AND SB1010.B1_GRUPO = '"+QUERY->B1_GRUPO+"' "
_cQuery += "GROUP BY SF2010.F2_VEND1, SB1010.B1_GRUPO, SD1010.D1_COD, SB1010.B1_DESC "
_cQuery += "ORDER BY SF2010.F2_VEND1, SB1010.B1_GRUPO, SD1010.D1_COD, SB1010.B1_DESC "

_cQuery	:=	ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"DEVOL",.T.,.T.)

TcSetField("DEVOL","D1_TOTAL"  ,"N",TamSX3("D1_TOTAL"  )[1],TamSX3("D1_TOTAL"  )[2])
TcSetField("DEVOL","D1_QUANT"  ,"N",TamSX3("D1_QUANT"  )[1],TamSX3("D1_QUANT"  )[2])

Return