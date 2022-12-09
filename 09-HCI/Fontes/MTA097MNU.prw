#Include "Protheus.CH"
#Include "TopConn.CH"
#Include "RwMake.CH"
#INCLUDE "FIVEWIN.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} MTA097MNU
Ponto de entrada utilizado para inclus�o da funcinalidade de impress�o 
da analise de cota��o na rotina de libera��o.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		29/09/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
User Function MTA097MNU()
              
	Aadd(aRotina,{  "Rel. Analise Cot." ,"u__fHDR002"  , 0 , 8 })

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} _fHDR002
Fun��o para informar o conte�do dos par�metros de impress�o.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		29/09/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
User Function _fHDR002()

	Local _cPerg		:= "HCIMR02"
	Private cpTitulo	:= "Impress�o de Relat�rio - Analise de Cota��es"
	
	If SCR->CR_TIPO == "PC"
		dbSelectArea("SC7")
		SC7->(dbSetOrder(1))
		If SC7->(dbSeek(xFilial("SC7")+PADR(ALLTRIM(SCR->CR_NUM),TAMSX3("C7_NUM")[1])))
			Pergunte(_cPerg,.F.)
			MV_PAR01	:= SC7->C7_NUMCOT
			MV_PAR02	:= SC7->C7_NUMCOT
			MV_PAR03	:= 2
			MV_PAR04	:= 1
			MV_PAR05	:= "B1_DESC"
			MV_PAR06	:= 2
			MV_PAR07	:= ""
			MV_PAR08	:= ""
			MV_PAR09	:= ""
			MV_PAR10	:= 2
			MV_PAR11	:= 2
			
			Processa({|| StaticCall(HCIMR002,_fImpSpo)},cpTitulo,,.T.)
			
		Else
			Aviso(OEMTOANSI("Aten��o"),"O pedido selcionado n�o foi encontrado no sistema. Favor verificar!",{"Ok"},2)
		EndIf
	Else
		Aviso(OEMTOANSI("Aten��o"),"O registro selecionado n�o se trata de pedido de compra. Favor verificar!",{"Ok"},2)
	EndIf

Return()