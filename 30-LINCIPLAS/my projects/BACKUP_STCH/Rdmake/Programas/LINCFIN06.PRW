#include "rwmake.ch"
#include "topconn.ch"
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLINCFIN06 บ Autor ณ RODRIGO DEMETRIOS  บ Data ณ  11/09/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ RELATORIO  A REALIZAR  ANALITICO POR GRUPO                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Financeiro                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function LIFIN06()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cDesc1       := "Este Programa Tem Como Objetivo Imprimir Relat๓rio "
cDesc2       := "De Acordo Com os Parametros Informados Pelo Usuario."
cDesc3       := "RELATORIO DE TITULOS A PAGAR POR GRUPO - ANALITICO"
cPict        := ""
titulo       := "RELATORIO DE TITULOS A PAGAR POR GRUPO - ANALITICO"
nLin         := 80
imprime      := .T.
lEnd         := .F.
lAbortPrint  := .F.
CbTxt        := ""
limite       := 220
tamanho      := "G"
nomeprog     := "LIFIN06"
nTipo        := 15
aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
nLastKey     := 0
_cPerg       := "LIFI06"
cbtxt        := Space(10)
cbcont       := 00
CONTFL       := 01
m_pag        := 01
wnrel        := "LIFIN06"
cString      := "SE2"
_nTotNcc     := 0
_nTotal      := 0
nOrdem       := 1
CABEC1       := "PRF  NUMERO  PC  TP   FORNEC  NOME FORNECEDOR       NATUREZA  GRUPO   HISTORICO                                  EMISSAO   VENCTO            VALOR   "
CABEC2       := ""

dbSelectArea("SE2")
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


RptStatus({|| RFIN06() },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRFIN06 บ    Autor ณ RODRIGO CORREA     บ Data ณ  11/09/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RFIN06()


_dVENCde  := mv_par01
_dVENCate := mv_par02   
_cGrupoDe := mv_par03
_cGrupote := mv_par04
_dEmisde  := mv_par05
_dEmisate := mv_par06   

dbSelectArea("SE2")
dbSetOrder(1)

cFilTrab   := CriaTrab(NIL,.F.)
cCondicao  := "(E2_NATUREZ != '12010709  ' .AND. E2_NATUREZ != '22010708  '.AND. E2_NATUREZ != 'DESCONT   ') .AND. "
cCondicao  += " DTOS(E2_VENCREA) >= '" +DTOS(MV_PAR01)+ "' .And. DTOS(E2_VENCREA) <= '"+DTOS(MV_PAR02)+ "'   .AND. "
cCondicao  += " DTOS(E2_EMISSAO) >= '" +DTOS(MV_PAR05)+ "' .And. DTOS(E2_EMISSAO) <= '"+DTOS(MV_PAR06)+ "'   .AND. E2_TIPO <> 'NDF' .AND. "
IF MV_PAR07 = "S"
cCondicao  += " E2_SALDO <> 0   .AND. "
ENDIF
cCondicao  += " E2_GRUPO >= '" +MV_PAR03+ "'.And.E2_GRUPO <= '"+MV_PAR04+ "'"
cChave := "E2_FILIAL+E2_GRUPO+E2_NATUREZ"
IndRegua("SE2",cFilTrab,cChave,,cCondicao,"Filtrando")    // "Selecionando Registros..."
dbSelectArea("SE2")
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
	
	_cGRUPO := SE2->E2_GRUPO
	_nTOTPAGGRU := 0
	
	DBSELECTAREA("SZ9")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SZ9")+_cGRUPO)
	cDescGRU := SZ9->Z9_DESCGRU
	
	DBSELECTAREA("SE2")
	
	While !Eof() .AND. SE2->E2_GRUPO == _cGRUPO
		
    	_cNATUREZ := SE2->E2_NATUREZ
		_nTOTPAGNAT := 0
	
		DBSELECTAREA("SED")
		DBSETORDER(1)
		DBSEEK(XFILIAL("SED")+_cNATUREZ)
		cDescNAT := SED->ED_DESCRIC
	
		DBSELECTAREA("SE2")

    	While !Eof() .AND. SE2->E2_GRUPO == _cGRUPO .AND. _cNATUREZ == SE2->E2_NATUREZ
			IncRegua()


			If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 10
			Endif

    		//DBSELECTAREA("SE2")
	    	//DBSETORDER(1)
		    //DBSEEK(XFILIAL("SE2")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_FORNECE+SE5->E5_LOJA)
	    	

//          1         2         3         4         5         6         7         8         9         0         11        12        13       14        15        16        17         18
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//PRF  NUMERO  PC  TP   FORNEC  NOME FORNECEDOR       NATUREZA  GRUPO   HISTORICO                                  EMISSAO   VENCTO            VALOR   
//999  999999  99  XXX  999999  XXXXXXXXXXXXXXXXXXXX  XXXXXXXX  XXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXX  XXXXXXXX   99,999,999.99  
	
			@nLin,000 PSAY SE2->E2_PREFIXO
			@nLin,005 PSAY SE2->E2_NUM 
			@nLin,013 PSAY SE2->E2_PARCELA 
			@nLin,017 PSAY SE2->E2_TIPO 
			@nLin,022 PSAY SE2->E2_FORNECE 
			@nLin,030 PSAY SUBSTR(SE2->E2_NOMFOR,1,20) 
			@nLin,052 PSAY SE2->E2_NATUREZ 
			@nLin,062 PSAY SE5->E5_GRUPO 
			@nLin,070 PSAY SUBSTR(SE2->E2_HIST,1,40) 
			@nLin,113 PSAY SE2->E2_EMISSAO 
			@nLin,123 PSAY SE2->E2_VENCREA 
			IF MV_PAR07 = "S"
            	@nLin,134 PSAY SE2->E2_SALDO PICTURE "@E 99,999,999.99"
	        ELSE
				@nLin,134 PSAY SE2->E2_VALOR PICTURE "@E 99,999,999.99"
	        ENDIF
			
			IF MV_PAR07 = "S"
            
            	_nTOTPAGGRU  += SE2->E2_SALDO
				_nTOTPAGNAT  += SE2->E2_SALDO
				_NTOTGERPAG  += SE2->E2_SALDO
			
            ELSE
            
            	_nTOTPAGGRU  += SE2->E2_VALOR
				_nTOTPAGNAT  += SE2->E2_VALOR
				_NTOTGERPAG  += SE2->E2_VALOR
			
			ENDIF
			nLin := nLin + 1
		
			dbSelectArea("SE2")
			dbSkip()
		EndDo
		@nLin,000 PSAY "TOTAL DA NATUREZA:  " + SUBSTR(_cNATUREZ,1,8) + " - " +  substr(cDescNAT,1,40) //NATUREZA/DESCRICAO
		@nLin,134 PSAY _nTOTPAGNAT PICTURE "@E 99,999,999.99"  
		nLin := nLin + 2
		
		DBSELECTAREA("SE5")
	ENdDo

	@nLin,000 PSAY "TOTAL DO GRUPO:  " + SUBSTR(_cGRUPO,1,6) + " - " +  substr(cDescGRU,1,40) //NATUREZA/DESCRICAO
	@nLin,134 PSAY _nTOTPAGGRU PICTURE "@E 99,999,999.99"  
	nLin := nLin + 1
	nLin := nLin + 1
	nLin := nLin + 1

	dbSelectArea("SE2")
EndDo


nLin := nLin + 1
nLin := nLin + 1

@nLin,000 PSAY "TOTAL GERAL" + " --------------------------------------------------> "
@nLin,134 PSAY _nTotGERPAG PICTURE "@E 9,999,999.99"

dbSelectArea("SE2")
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

Aadd(aRegs,{_cPerg,"01","Data Vencimento de    ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"02","Data Vencimento Ate   ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"03","Grupo de              ?","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SZ9",""})
Aadd(aRegs,{_cPerg,"04","Grupo Ate             ?","","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SZ9",""})
Aadd(aRegs,{_cPerg,"05","Data Emissao de       ?","","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"06","Data Emissao Ate      ?","","","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"07","Somente em Aberto     ?","","","mv_ch7","C",01,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

