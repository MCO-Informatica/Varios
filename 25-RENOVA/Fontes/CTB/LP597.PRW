#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LP597     ºAutor  ³Microsiga           º Data ³  04/24/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ UTILIZADO PARA COMPENSACAO DE TITULOS COM PA               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


// Centro de Custo
User Function LP597001()

Local _xCusto	:= "" 
Local aArea		:= {} // Area
Local aAreaSA2	:= {} // Area SA2
Local aAreaSE2	:= {} // Area SE2


If ALLTRIM(SE5->E5_TIPO)=='PA'
	
	dbSelectArea("SE2")
	dbSetOrder(1)
	dbSeek(xFilial("SE2")+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA))
	
	
	_xCusto		:= SE2->E2_CCD
	
Else
	
	aAreaSE2	:= SE2->(GetArea())
	
	dbSelectArea("SE2")
	dbSetOrder(1)
	dbSeek(xFilial("SE2") + SUBSTR(SE5->E5_DOCUMEN,1,18) + SE5->(E5_FORNADT + E5_LOJAADT))

	_xCusto		:= SE2->E2_CCD
	
	RestArea(aAreaSE2)
	
Endif

Return(_xCusto)


// Item Contabil
User Function LP597002()

Local _xItemc	:= "" 
Local aArea		:= {} // Area
Local aAreaSA2	:= {} // Area SA2
Local aAreaSE2	:= {} // Area SE2


If ALLTRIM(SE5->E5_TIPO)=='PA'
	
	dbSelectArea("SE2")
	dbSetOrder(1)
	dbSeek(xFilial("SE2")+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA))
	
	_xItemc 		:= SE2->E2_ITEMD
	
Else
	
	aAreaSE2	:= SE2->(GetArea())
	
	dbSelectArea("SE2")
	dbSetOrder(1)
	dbSeek(xFilial("SE2") + SUBSTR(SE5->E5_DOCUMEN,1,18) + SE5->(E5_FORNADT + E5_LOJAADT))
	

	_xItemc 		:= SE2->E2_ITEMD
	
	RestArea(aAreaSE2)
	
Endif
Return(_xItemc)

//Classe de Valor
User Function LP597003()
Local _xClassv:= ""
Local aArea		:= {} // Area
Local aAreaSA2	:= {} // Area SA2
Local aAreaSE2	:= {} // Area SE2

If ALLTRIM(SE5->E5_TIPO)=='PA'
	
	dbSelectArea("SE2")
	dbSetOrder(1)
	dbSeek(xFilial("SE2")+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA))
	
	_xClassv		:= SE2->E2_CLVLDB
	
Else
	
	aAreaSE2	:= SE2->(GetArea())
	
	dbSelectArea("SE2")
	dbSetOrder(1)
	dbSeek(xFilial("SE2") + SUBSTR(SE5->E5_DOCUMEN,1,18) + SE5->(E5_FORNADT + E5_LOJAADT))
	
	_xClassv		:= SE2->E2_CLVLDB
	
	RestArea(aAreaSE2)
	
Endif
Return(_xClassv)

//Classe OrCamentaria - ENTIDADE 05 CV0

User Function LP597004()
Local _xClasOrc := ""
Local aArea		:= {} // Area
Local aAreaSA2	:= {} // Area SA2
Local aAreaSE2	:= {} // Area SE2

If ALLTRIM(SE5->E5_TIPO)=='PA'
	
	dbSelectArea("SE2")
	dbSetOrder(1)
	dbSeek(xFilial("SE2")+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA))
	
	_xClasOrc		:= SE2->E2_EC05DB
	
Else
	
	aAreaSE2	:= SE2->(GetArea())
	
	dbSelectArea("SE2")
	dbSetOrder(1)
	dbSeek(xFilial("SE2") + SUBSTR(SE5->E5_DOCUMEN,1,18) + SE5->(E5_FORNADT + E5_LOJAADT))
	
	_xClasOrc		:= SE2->E2_EC05DB
	
	RestArea(aAreaSE2)
	
Endif
Return(_xClasOrc)


//Tipo de Custo - Entidade 07 CV0
User Function LP597005()
Local _xTpCust := ""
Local aArea		:= {} // Area
Local aAreaSA2	:= {} // Area SA2
Local aAreaSE2	:= {} // Area SE2

If ALLTRIM(SE5->E5_TIPO)=='PA'
	
	dbSelectArea("SE2")
	dbSetOrder(1)
	dbSeek(xFilial("SE2")+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA))
	
	_xTpCust		:= SE2->E2_EC07DB
	
Else
	
	aAreaSE2	:= SE2->(GetArea())
	
	dbSelectArea("SE2")
	dbSetOrder(1)
	dbSeek(xFilial("SE2") + SUBSTR(SE5->E5_DOCUMEN,1,18) + SE5->(E5_FORNADT + E5_LOJAADT))
	
	_xTpCust		:= SE2->E2_EC07DB
	
	RestArea(aAreaSE2)
	
Endif
Return(_xTpCust)
