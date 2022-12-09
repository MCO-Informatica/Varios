#include "topconn.ch"
#include "protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BTSFINA001ºAutor  ³Microsiga           º Data ³  09/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para calcular o valor liquido dos titulos no CNAB.º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function BTSFINA001()

_nAliasRec := Recno()

Private nValor := SE1->E1_VALOR
Private nAbat  := 0
Private ndecs  := Msdecimais(1)
Private cBusca := SEA->(EA_PREFIXO+EA_NUM+EA_PARCELA)
Private aAux   := {}
Private _cQuery	:= ""

//Posiciona SE1
_cQuery	+= "SELECT * FROM " + RetSQLName("SE1") + " WHERE E1_PREFIXO = '" + Substring(cBusca,1,3) + "' AND "
_cQuery	+= "E1_NUM = '" + Substring(cBusca,4,9) + "' AND E1_PARCELA = '" + Substring(cBusca,13,3) + "' AND D_E_L_E_T_ = '' "
TcQuery _cQuery New Alias "QRYSE1"

While !Eof() .and. QRYSE1->(E1_PREFIXO+E1_NUM+E1_PARCELA) == cBusca
	If QRYSE1->E1_TIPO $ MVABATIM
		nAbat += xMoeda(QRYSE1->E1_SALDO,QRYSE1->E1_MOEDA,1,,ndecs+1)
	Endif
	QRYSE1->(dbSkip())
EndDo

nValor := nValor-nAbat

dbCloseArea("QRYSE1")

dbSelectArea("SEA")
SEA->(dbGoto(_nAliasRec))

nValor := STRZERO( (nValor * 100) ,13 )

Return nValor