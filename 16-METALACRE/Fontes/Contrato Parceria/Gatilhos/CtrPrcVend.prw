#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Protheus.Ch" 
#INCLUDE "AP5MAIL.CH"     
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CtrPrcVend º Autor ³ Luiz Alberto     º Data ³ 14/04/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±                                                 	
±±ºDescricao ³ Gatilho Para Preenchimento dos Campos de Vendedores 2 e 3  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Contrato de Parceria ADA_CODCLI U_CTRPRCVEND()             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/   
User Function CtrPrcVend()
Local aArea := GetArea()
Local cVend1
Local cVend2
Local cVend3

If !Empty(SA1->A1_VEND)
	SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+SA1->A1_VEND))
	cVend1 := SA1->A1_VEND
	nComi1 := SA3->A3_COMIS
	nComi2 := 0
	nComi3 := 0
	cVend2 := SA3->A3_SUPER
	cVend3 := SA3->A3_GEREN
				
	If !Empty(cVend2)
		If SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+cVend2))
			nComi2 := SA3->A3_COMIS
		Endif
	Endif

	If !Empty(cVend3)
		If SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+cVend3))
			nComi3 := SA3->A3_COMIS
		Endif
	Endif
								
	M->ADA_VEND1 := cVend1
	M->ADA_COMIS1:= nComi1
	M->ADA_VEND2 := cVend2
	M->ADA_COMIS2:= nComi2
	M->ADA_VEND3 := cVend3
	M->ADA_COMIS3:= nComi3
Endif

RestArea(aArea)
Return .t.
