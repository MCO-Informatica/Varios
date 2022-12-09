#Include "Totvs.ch"
#Include "FwMvcDef.ch"


//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |PECFA872 |Autor: |David Alves dos Santos |Data: |08/03/2018   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Ponto de entrada para rotina Usuário x Atributo do domínio.   |
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
	
		//-- Antes da alteração de qualquer campo do modelo. (requer retorno lógico)
		Case	cIdPonto	==	"MODELPRE"
				
		//-- Na validação total do modelo (requer retorno lógico)
		Case	cIdPonto	==	"MODELPOS"
				
		//-- Antes da alteração de qualquer campo do formulário. (requer retorno lógico)
		Case	cIdPonto	==	"FORMPRE"
		
		//-- Na validação total do formulário (requer retorno lógico)		
		Case	cIdPonto	==	"FORMPOS"
			
			dbSelectArea("ZZM")
			ZZM->(dbSetOrder(1))
			ZZM->(dbGoTop())
			If ZZM->( MsSeek( xFilial("ZZM") + M->ZZM_ATRIB + M->ZZM_CPF ) )
				xRet := .F.
				MsgStop("Registro já cadastrado, favor informar um novo registro.")
			EndIf
			
		//-- Antes da alteração da linha do formulário GRID. (requer retorno lógico)
		Case	cIdPonto	==	"FORMLINEPRE"
			
		//-- Na validação total da linha do formulário GRID. (requer retorno lógico)
		Case	cIdPonto	==	"FORMLINEPOS"
			
		//-- Apos a gravação total do modelo e dentro da transação
		Case	cIdPonto	==	"MODELCOMMITTTS"
			
		//-- Apos a gravação total do modelo e fora da transação
		Case	cIdPonto	==	"MODELCOMMITNTTS"
			
		//-- Antes da gravação da tabela do formulário
		Case	cIdPonto	==	"FORMCOMMITTTSPRE"
			
		//-- Apos a gravação da tabela do formulário
		Case	cIdPonto	==	"FORMCOMMITTTSPOS"
			
		//-- Na ativação do modelo.
		Case	cIdPonto	==	"MODELVLDACTIVE"
			
		//-- No cancelamento do botão.(Modelo) (Retorno Logico)
		Case	cIdPonto	==	"MODELCANCEL"
			
		//-- No cancelamento do botão (Formulario) (Retorno Logico).
		Case	cIdPonto	==	"FORMCANCEL"
			
		//-- Para acrescentar botoes a ControlBar
		Case	cIdPonto	==	"BUTTONBAR"
			
	EndCase
	
Return( xRet )