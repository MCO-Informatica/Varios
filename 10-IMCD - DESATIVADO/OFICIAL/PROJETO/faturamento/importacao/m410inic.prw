#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "SET.CH"

User Function M410INIC()
Local  x := 1
Local _aArea := GetArea()
//Local xGrava := .T.
Local cMenNota := ""

IF FUNNAME() == "MATA416"
	
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xfilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA)
	
	DBSELECTAREA("SC5")
	
	
	M->C5_XMAILCO := SCJ->CJ_XMAILCO
	M->C5_XVENDOR := SCJ->CJ_XVENDOR
	M->C5_NOMECLI := SA1->A1_NREDUZ
	
	If !Empty(SCJ->CJ_XTPFRETE)
		M->C5_TPFRETE := SCJ->CJ_XTPFRETE
	Endif
	
	If !Empty(SCJ->CJ_XGRPVEN)
		M->C5_GRPVEN  := SCJ->CJ_XGRPVEN
		M->C5_DGRPVEN := POSICIONE("ACY",1,XFILIAL("ACY")+M->C5_GRPVEN,"ACY_DESCRI")
	Endif
	
	If !Empty(SCJ->CJ_XCODCON)
		M->C5_XCONTAT  := SCJ->CJ_XCODCON
		M->C5_XNOMCON := Posicione("SU5",1,xFilial("SU5") + SCJ->CJ_XCODCON,"U5_CONTAT")
	Endif
	
	IF LEN(ACOLS) > 0
		nPosEntr := AScan( aHeader, { |x| Alltrim(x[2]) == 'C6_ENTREG'})
		M->C5_XENTREG := ACOLS[1][nPosEntr]
	ENDIF
	
	M->C5_NATUREZ := Alltrim(GetMv("MV_XNATORC"))
	M->C5_XVRMARG := SCJ->CJ_XVRMARG
	M->C5_XMARGPR := SCJ->CJ_XMARGPR
	M->C5_CENT    := SCJ->CJ_XCLIENT
	M->C5_LENT    := SCJ->CJ_XLOJENT
	M->C5_TRANSP  := SCJ->CJ_XTRANSP
	M->C5_CLIENT  := SCJ->CJ_CLIENTE
	M->C5_LOJAENT := SCJ->CJ_LOJA
	M->C5_GRPVEN  := SCJ->CJ_XGRPVEN
	M->C5_VEND1 :=  SCJ->CJ_XVEND
	M->C5_XINTCOM := CJ_XINTCOM
	M->C5_XEXTCOM := CJ_XEXTCOM
	
	cMenNota += ALLTRIM(SA1->A1_OBSNF)
	nTam := TamSX3("C5_MENNOTA")[1]
	nTam := nTam - Len(cMenNota)
	M->C5_MENNOTA  := cMenNota + space(nTam)
	
	IF cEmpAnt == '04'
		IF M->C5_TIPO == 'N' .AND. SF4->F4_DUPLIC == 'S'
			M->C5_MENPAD := "ARM"
		ENDIF
	Endif

ENDIF
RestArea(_aArea)

Return ()
