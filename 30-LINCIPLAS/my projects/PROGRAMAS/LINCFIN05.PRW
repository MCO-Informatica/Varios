#include "rwmake.ch"
#include "topconn.ch"
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLINCFIN05 บ Autor ณ RODRIGO DEMETRIOS  บ Data ณ  11/09/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ RELATORIO REALIZADO ANALITICO POR GRUPO                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Financeiro                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function LIFIN05()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cDesc1       := "Este Programa Tem Como Objetivo Imprimir Relat๓rio "
cDesc2       := "De Acordo Com os Parametros Informados Pelo Usuario."
cDesc3       := "RELATORIO DE PAGAMENTOS REALIZADOS POR GRUPO - ANALITICO"
cPict        := ""
titulo       := "RELATORIO DE PAGAMENTOS REALIZADOS POR GRUPO - ANALITICO"
nLin         := 80
imprime      := .T.
lEnd         := .F.
lAbortPrint  := .F.
CbTxt        := ""
limite       := 220
tamanho      := "G"
nomeprog     := "LIFIN05"
nTipo        := 15
aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
nLastKey     := 0
_cPerg       := "LIFI05"
cbtxt        := Space(10)
cbcont       := 00
CONTFL       := 01
m_pag        := 01
wnrel        := "LIFIN05"
cString      := "SE5"
_nTotNcc     := 0
_nTotal      := 0
nOrdem       := 1
CABEC1       := "PRF  NUMERO  PC  TP  FORNEC  NOME FORNECEDOR  NATUREZA  GRUPO   HISTORICO                  EMISSAO   VENCTO    BAIXA       VALOR ORIG.  JUR/MULTA/COR    DESC./ABAT.     TOTAL PAGO"
CABEC2       := ""

dbSelectArea("SE5")
dbSetOrder(1)

ValidPerg() // Valida as Perguntas

pergunte(_cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,_cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif


RptStatus({|| RFIN05() },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRFIN05 บ Autor ณ RODRIGO CORREA     บ Data ณ  11/09/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RFIN05()


_dPAGde  := mv_par01
_dPAGate := mv_par02   
_cGruDe  := mv_par03
_cGruAte := mv_par04

dbSelectArea("SE5")
dbSetOrder(1)

cFilTrab   := CriaTrab(NIL,.F.)
cCondicao  := "(E5_TIPODOC != 'DC' .AND. E5_TIPODOC != 'JR' .AND. E5_TIPODOC != 'MT' .AND. E5_TIPODOC != 'CH' .AND. E5_TIPODOC != 'TR' .AND.  E5_TIPODOC != 'ES') .AND. E5_SITUACA != 'C' .AND. (E5_RECPAG = 'P' .OR. (E5_RECPAG = 'R' .AND. E5_MOEDA = 'M1')) .AND. "
cCondicao  += "(E5_NATUREZ != '12010709  ' .AND. E5_NATUREZ != '22010708  '.AND. E5_NATUREZ != 'DESCONT   ') .AND. "
cCondicao  += " DTOS(E5_DATA) >= '" +DTOS(MV_PAR01)+ "'.And.DTOS(E5_DATA) <= '"+DTOS(MV_PAR02)+ "'    .AND. E5_MOTBX != 'DAC' .AND. E5_MOTBX != 'FAT' .AND. E5_MOTBX != 'CMP' .AND. "
cCondicao  += " E5_GRUPO >= '" +MV_PAR03+ "'.And.E5_GRUPO <= '"+MV_PAR04+ "'"
cChave := "E5_FILIAL+E5_GRUPO+E5_NATUREZ"
IndRegua("SE5",cFilTrab,cChave,,cCondicao,"Filtrando")    // "Selecionando Registros..."
dbSelectArea("SE5")
DbGoTop()
SetRegua(RecCount())
_NTOTGERPAG := 0

While !Eof()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario...                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	_cGRUPO := SE5->E5_GRUPO
	_nTOTPAGGRU := 0
	
	DBSELECTAREA("SZ9")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SZ9")+_cGRUPO)
	cDescGRU := SZ9->Z9_DESCGRU
	
	DBSELECTAREA("SE5")
	
	While !Eof() .AND. SE5->E5_GRUPO == _cGRUPO
		
    	_cNATUREZ := SE5->E5_NATUREZ
		_nTOTPAGNAT := 0
	
		DBSELECTAREA("SED")
		DBSETORDER(1)
		DBSEEK(XFILIAL("SED")+_cNATUREZ)
		cDescNAT := SED->ED_DESCRIC
	
		DBSELECTAREA("SE5")

    	While !Eof() .AND. SE5->E5_GRUPO == _cGRUPO .AND. _cNATUREZ == SE5->E5_NATUREZ
			IncRegua()


			If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 10
			Endif

    		DBSELECTAREA("SE2")
	    	DBSETORDER(1)
		    DBSEEK(XFILIAL("SE2")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_FORNECE+SE5->E5_LOJA)
	    	

//          1         2         3         4         5         6         7         8         9         0         11        12        13       14        15        16        17         18
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//PRF  NUMERO  PC  TP  FORNEC  NOME FORNECEDOR  NATUREZA  GRUPO   HISTORICO                  EMISSAO   VENCTO    BAIXA       VALOR ORIG.  JUR/MULTA/COR    DESC./ABAT.     TOTAL PAGO
//999  999999  99  XX  999999  XXXXXXXXXXXXXXX  XXXXXXXX  XXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  99,999,999.99  99,999,999.99  99,999,999.99  99,999,999.99
	
			@nLin,000 PSAY SE5->E5_PREFIXO
			@nLin,005 PSAY SE5->E5_NUMERO 
			@nLin,013 PSAY SE5->E5_PARCELA 
			@nLin,017 PSAY SE5->E5_TIPO 
			@nLin,021 PSAY SE5->E5_FORNECE 
			@nLin,029 PSAY SUBSTR(SE5->E5_BENEF,1,15) 
			@nLin,046 PSAY SE5->E5_NATUREZ 
			@nLin,056 PSAY SE5->E5_GRUPO 
			IF !EMPTY(SE2->E2_HIST)
			@nLin,064 PSAY SUBSTR(SE2->E2_HIST,1,25) 
			ELSE
			@nLin,064 PSAY SUBSTR(SE5->E5_HISTOR,1,25)
			ENDIF
			@nLin,091 PSAY SE2->E2_EMISSAO 
			@nLin,101 PSAY SE2->E2_VENCREA 
			@nLin,111 PSAY SE5->E5_DATA 
			IF SE5->E5_RECPAG = 'P'
				_NVALOR :=  (SE5->E5_VALOR - SE5->E5_VLJUROS - SE5->E5_VLMULTA - SE5->E5_VLCORRE + SE5->E5_VLDESCO)
			ELSE
			    _NVALOR :=  ((SE5->E5_VALOR - SE5->E5_VLJUROS - SE5->E5_VLMULTA - SE5->E5_VLCORRE + SE5->E5_VLDESCO) * -1)
			ENDIF
			@nLin,121 PSAY _NVALOR PICTURE "@E 99,999,999.99"
			@nLin,136 PSAY SE5->E5_VLJUROS + SE5->E5_VLMULTA + SE5->E5_VLCORRE PICTURE "@E 99,999,999.99"
			@nLin,151 PSAY SE5->E5_VLDESCO PICTURE "@E 99,999,999.99"
			IF SE5->E5_RECPAG = 'P'
				@nLin,166 PSAY SE5->E5_VALOR PICTURE "@E 99,999,999.99"
			ELSE
				@nLin,166 PSAY 	(SE5->E5_VALOR * -1) PICTURE "@E 99,999,999.99"
			ENDIF
		
			_nTOTPAGGRU  += _NVALOR
			_nTOTPAGNAT  += _NVALOR
			_NTOTGERPAG  += _NVALOR
			nLin := nLin + 1
		
			dbSelectArea("SE5")
			dbSkip()
		EndDo
		@nLin,000 PSAY "TOTAL DA NATUREZA:  " + SUBSTR(_cNATUREZ,1,8) + " - " +  substr(cDescNAT,1,40) //NATUREZA/DESCRICAO
		@nLin,166 PSAY _nTOTPAGNAT PICTURE "@E 99,999,999.99"  
		nLin := nLin + 2
		
		DBSELECTAREA("SE5")
	ENdDo

	@nLin,000 PSAY "TOTAL DO GRUPO:  " + SUBSTR(_cGRUPO,1,6) + " - " +  substr(cDescGRU,1,40) //NATUREZA/DESCRICAO
	@nLin,166 PSAY _nTOTPAGGRU PICTURE "@E 99,999,999.99"  
	nLin := nLin + 1
	nLin := nLin + 1
	nLin := nLin + 1

	dbSelectArea("SE5")
EndDo


nLin := nLin + 1
nLin := nLin + 1

@nLin,000 PSAY "TOTAL GERAL" + " --------------------------------------------------> "
@nLin,166 PSAY _nTotGERPAG PICTURE "@E 9,999,999.99"

dbSelectArea("SE5")
retindex()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET PRINTER TO
OurSpool(wnrel)

MS_FLUSH()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFunao    ณ ValidPerg ณ Autor ณ Denilson Correa      ณ Data ณ          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescriao ณ Valida se existe as Perguntas no SX1                       ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg()

_cAlias := Alias()
DbSelectArea("SX1")
DbSetOrder(1)   
_cPerg := PADR(_cPerg,10)
aRegs :={}

Aadd(aRegs,{_cPerg,"01","Data Pagamento de     ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"02","Data Pagamento Ate    ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"03","Grupo de              ?","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SZ9",""})
Aadd(aRegs,{_cPerg,"04","Grupo Ate             ?","","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SZ9",""})

For i:=1 to Len(aRegs)
	If !dbSeek(_cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			EndIf
		Next
		MsUnlock()
	EndIf
Next
DbSelectArea(_cAlias)
Return

