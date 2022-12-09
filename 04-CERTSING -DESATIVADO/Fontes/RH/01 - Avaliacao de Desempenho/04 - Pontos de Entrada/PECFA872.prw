#Include "Totvs.ch"
#Include "FwMvcDef.ch"


//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |PECFA872 |Autor: |David Alves dos Santos |Data: |08/03/2018   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Ponto de entrada para rotina Usu�rio x Atributo do dom�nio.   |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
User Function PECFA872()

	Local aParam     := PARAMIXB
	Local oObj       := aParam[1]
	Local cIdPonto   := aParam[2]
	Local cIdObj     := oObj:GetId()
	Local cClasse    := oObj:ClassName()
	Local nQtdLinhas := 0
	Local nLinha     := 0
	Local xRet       := .T.

	If cClasse == "FWFORMGRID"
		nQtdLinhas := oObj:GetQtdLine()
		nLinha     := oObj:nLine
	EndIf

	Do Case
	
		//-- Antes da altera��o de qualquer campo do modelo. (requer retorno l�gico)
		Case	cIdPonto	==	"MODELPRE"
				
		//-- Na valida��o total do modelo (requer retorno l�gico)
		Case	cIdPonto	==	"MODELPOS"
				
		//-- Antes da altera��o de qualquer campo do formul�rio. (requer retorno l�gico)
		Case	cIdPonto	==	"FORMPRE"
		
		//-- Na valida��o total do formul�rio (requer retorno l�gico)		
		Case	cIdPonto	==	"FORMPOS"
			
			dbSelectArea("ZZM")
			ZZM->(dbSetOrder(1))
			ZZM->(dbGoTop())
			If ZZM->( MsSeek( xFilial("ZZM") + M->ZZM_ATRIB + M->ZZM_CPF ) )
				xRet := .F.
				MsgStop("Registro j� cadastrado, favor informar um novo registro.")
			EndIf
			
		//-- Antes da altera��o da linha do formul�rio GRID. (requer retorno l�gico)
		Case	cIdPonto	==	"FORMLINEPRE"
			
		//-- Na valida��o total da linha do formul�rio GRID. (requer retorno l�gico)
		Case	cIdPonto	==	"FORMLINEPOS"
			
		//-- Apos a grava��o total do modelo e dentro da transa��o
		Case	cIdPonto	==	"MODELCOMMITTTS"
			
		//-- Apos a grava��o total do modelo e fora da transa��o
		Case	cIdPonto	==	"MODELCOMMITNTTS"
			
		//-- Antes da grava��o da tabela do formul�rio
		Case	cIdPonto	==	"FORMCOMMITTTSPRE"
			
		//-- Apos a grava��o da tabela do formul�rio
		Case	cIdPonto	==	"FORMCOMMITTTSPOS"
			
		//-- Na ativa��o do modelo.
		Case	cIdPonto	==	"MODELVLDACTIVE"
			
		//-- No cancelamento do bot�o.(Modelo) (Retorno Logico)
		Case	cIdPonto	==	"MODELCANCEL"
			
		//-- No cancelamento do bot�o (Formulario) (Retorno Logico).
		Case	cIdPonto	==	"FORMCANCEL"
			
		//-- Para acrescentar botoes a ControlBar
		Case	cIdPonto	==	"BUTTONBAR"
			
	EndCase
	
Return( xRet )