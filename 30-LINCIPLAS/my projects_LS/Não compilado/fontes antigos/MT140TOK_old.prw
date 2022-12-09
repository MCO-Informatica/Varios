#Include "Protheus.ch"
#INCLUDE "RWMAKE.CH"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	MTA140TOK
// Autor 		Alexandre Dalpiaz
// Data 		23/02/2011
// Descricao  	ponto de entrada no MATA140 (valida��o da pr� nota de entrada)
//				Verifica se foi informada a data de entrada da nota fiscal no PE MT140CPO para gravar no PE SF1140I
// Uso         	LaSelva
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MT140TOK()
////////////////////////
Local aAlias	:= GetArea()
Local _lRet := .t.

If !l140Auto

	If ExistBlock('PE_ImpXmlNFe')
		ExecBlock('PE_ImpXmlNFe',.F.,.F.,{'MT140TOK'})
	EndIf
	RestArea(aAlias)
	
	Do While empty(__dDtRecebe) .and. (inclui .or. altera)
		
		If MsgBox('Data de recebimento da nota fiscal n�o informada. Corrigir?','ATEN��O!!!','YESNO')
			U_DlgDtRec()
			
		Else
			
			MsgBox('Data de recebimento da nota fiscal n�o informada. Pr�-nota n�o pode ser incluida sem essa informa��o. Corrija ou abandone a inclus�o da Pr�-Nota!!','ATEN��O!!!','ALERT')
			_lRet := .f.
			Exit
			
		EndIf
		
	EndDo
	
	//Acrescentado por Rodrigo: verificador de nfs j� existente no romaneio.
	                           
 	DbSelectArea('SD2')
 	DbSetOrder(3)
 	If DbSeek(cLoja + cNFiscal + cSerie,.f.)
 	
		DbSelectArea("PA6")
		DbSetOrder(1)
		If DbSeek(xFilial('PA6') + SD2->D2_PEDIDO + SD2->D2_FILIAL,.F.)
	
			MsgAlert("Pr�-nota pertence a um romaneio. Gerar NF pela rotina de encerramento do romaneio.", "ATEN��O!!!!")
			_lRet := .f.
			
		EndIf
		
	EndIf	
	
EndIf

Return(_lRet)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function DlgDtRec()
////////////////////////

Define MsDialog _oDlg Title iif(FunName() == 'MATA140',"Pr�-Nota de entrada" ,"Documento de entrada") From 000,000 to 120,200 of oMainWnd Pixel
@ 010,008 Say 'Data de recebimento da nota fiscal'	   Size 250,010 COLOR CLR_BLACK Pixel of _oDlg
@ 020,008 Get __dDtRecebe  size 40,10
@ 040,010 BmpButton Type 1 Action (_nOpcA:= 1, _oDlg:End())
Activate MsDialog _oDlg Centered Valid __dDtRecebe <= date()

Return()
