#Include "Protheus.CH"
#Include "TopConn.CH"
#Include "RwMake.CH"
#INCLUDE "FIVEWIN.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} MTA097MNU
Ponto de entrada utilizado para inclusão da funcinalidade de impressão 
da analise de cotação na rotina de liberação.

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
Função para informar o conteúdo dos parâmetros de impressão.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		29/09/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
User Function _fHDR002()

	Local _cPerg		:= "HCIMR02"
	Private cpTitulo	:= "Impressão de Relatório - Analise de Cotações"
	
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
			Aviso(OEMTOANSI("Atenção"),"O pedido selcionado não foi encontrado no sistema. Favor verificar!",{"Ok"},2)
		EndIf
	Else
		Aviso(OEMTOANSI("Atenção"),"O registro selecionado não se trata de pedido de compra. Favor verificar!",{"Ok"},2)
	EndIf

Return()