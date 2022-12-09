#Include "Protheus.ch"

/*
+==================+======================+==============+
|Programa: MA103BUT|Autor: Antonio Carlos |Data: 13/03/08|
+==================+======================+==============+
|Descricao: Ponto de Entrada utilizado para adicionar    |
|botoes na enchoice da rotina de Documento de Entrada.   |
+========================================================+
|Uso: Laselva                                            |
+========================================================+
*/

User Function MA140BUT()

Local _aMyBtn := {}
Local aAlias	:= GetArea()
If 	ExistBlock('PE_ImpXmlNFe')
	ExecBlock('PE_ImpXmlNFe',.F.,.F.,{'MA140BUT'})
EndIf
RestArea(aAlias)

AAdd(_aMyBtn,{"AUTOM" ,{||U_ESTP003()},"Leitor"})
If !inclui .and. SF1->F1_FORMUL == 'S'	
	AAdd( _aMyBtn, { "EDIT",	{ || U_LS_MSGNF('A') } , "Mensagem NFE", "Mensagem NFE" } )
	If SF1->F1_EST == 'EX'	// SOMENTE NA VISUALIZA��O E PARA NOTAS DE IMPORTA��O
		AAdd(_aMyBtn, { "NOTE", { || U_LS_103CD5('A') } , "Comp. Imp", "Complemento de Importa��o" } )
	EndIf	
EndIf

Return(_aMyBtn)
