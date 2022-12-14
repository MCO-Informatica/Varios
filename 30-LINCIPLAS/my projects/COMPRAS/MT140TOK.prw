#Include "Protheus.ch"
#INCLUDE "RWMAKE.CH"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	MTA140TOK
// Autor 		Thiago Queiroz
// Data 		03/08/2017
// Descricao  	ponto de entrada no MATA140 (valida??o da pr? nota de entrada)
//				Verifica se foi informado o n?mero do lote do fornecedor PE MT140CPO para gravar no PE SF1140I
// Uso         	Linciplas
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MT140TOK()
////////////////////////
Local aAlias	:= GetArea()
Local _lRet := .t.

If !l140Auto

	//If ExistBlock('PE_ImpXmlNFe')
	//	ExecBlock('PE_ImpXmlNFe',.F.,.F.,{'MT140TOK'})
	//EndIf
	//RestArea(aAlias)
	/*               
	If inclui .and. cFormul == 'N' //.and. cA100For < '000010' .and. cLoja <> xFilial('SF1')
		
		DbSelectArea('SD2')
		DbSetOrder(3)                                                 
		If DbSeek(cLoja + cNFiscal + cSerie,.f.)
		
			DbSelectArea("PA6")
			DbSetOrder(1)
			If ca100for < '000009' .and. DbSeek(xFilial('PA6') + SD2->D2_PEDIDO + SD2->D2_FILIAL,.F.)
				
				MsgAlert("Nota pertence a um romaneio. Gerar Pr?-nota pela rotina de encerramento do romaneio.", "ATEN??O!!!!")
				_lRet := .f.
				
			EndIf
			
		Else
			MsgAlert('Nota fiscal entre filiais/coligadas n?o emitida na filial de origem','ATEN??O!!!','ALERT')
			_lRet := .f.
		EndIf
		
	EndIf
	*/
		
	Do While empty(__cLoteFor) .and. (inclui .or. altera)
		
		If MsgBox('Lote do fornecedor da nota fiscal n?o informado. Corrigir?','ATEN??O!!!','YESNO')
			U_DlgLtFor()
			
		Else
			
			MsgBox('Lote do fornecedor da nota fiscal n?o informado. Pr?-nota n?o pode ser incluida sem essa informa??o. Corrija ou abandone a inclus?o da Pr?-Nota!!','ATEN??O!!!','ALERT')
			_lRet := .f.
			Exit
			
		EndIf
		
	EndDo
	
EndIf

RestArea(aAlias)

Return(_lRet)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function DlgLtFor()
////////////////////////

Define MsDialog _oDlg Title iif(FunName() == 'MATA140',"Pr?-Nota de entrada" ,"Documento de entrada") From 000,000 to 120,200 of oMainWnd Pixel
@ 010,008 Say 'Informe o lote do fornecedor'	   Size 250,010 COLOR CLR_BLACK Pixel of _oDlg
@ 020,008 Get __cLoteFor  size 40,10
@ 040,010 BmpButton Type 1 Action (_nOpcA:= 1, _oDlg:End())
Activate MsDialog _oDlg Centered Valid __cLoteFor != ""

Return()
