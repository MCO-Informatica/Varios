#Include "Protheus.ch"
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} Mata131
//TODO Ponto de Entrada padrão MVC da rotina de Geração de Cotações.
@author Pirolo
@since 05/08/2020
@return return, return_description
@see (links_or_references)
/*/
User Function Mata131()
Local aParam     	:= PARAMIXB
Local xRet       	:= .T.
Local oObj       	:= ''
Local cIdPonto   	:= ''
Local cIdModel   	:= ''
Local lIsGrid    	:= .F.
Local nLinha     	:= 0
Local nQtdLinhas 	:= 0
Local aAreaSC8		:= SC8->(GetArea())

If aParam <> NIL
      
	oObj       := aParam[1]
	cIdPonto   := aParam[2]
	cIdModel   := aParam[3]
	lIsGrid    := ( Len( aParam ) > 3 )
	
	If /*cIdPonto $ "FORMPRE|FORMLINEPRE|FORMLINEPOS|FORMPOS|"*/ lIsGrid .AND. cIdModel <> "XXXMASTER" 
		nQtdLinhas := oObj:GetQtdLine()
		nLinha     := oObj:nLine
	EndIf
      
	If cIdPonto == 'MODELPOS'
		//Chamada na validação total do modelo (MODELPOS).

	ElseIf cIdPonto == 'FORMPOS'
		//Chamada na validação total do formulário (FORMPOS).

	ElseIf cIdPonto == 'FORMLINEPRE'
		If aParam[5] == 'DELETE'
			//Chamada na pre validação da linha do formulário (FORMLINEPRE).' + CRLF
			//'Onde esta se tentando deletar uma linha' + CRLF

		EndIf
           
       ElseIf cIdPonto == 'FORMLINEPOS'
       		//Chamada na validação da linha do formulário (FORMLINEPOS).

       ElseIf cIdPonto == 'MODELCOMMITTTS'
       		//Chamada apos a gravação total do modelo e dentro da transação (MODELCOMMITTTS).
            
       ElseIf cIdPonto == 'MODELCOMMITNTTS'
       		//Chamada apos a gravação total do modelo e fora da transação (MODELCOMMITNTTS).' + CRLF + 'ID ' + cIdModel)
       		//Informa o numero da cotação gerada.
       		MsgInfo("Numero da Cotação: "+SC8->C8_NUM + CRLF+"Filial: "+SC8->C8_FILIAL, "Cotação")
       
       ElseIf cIdPonto == 'FORMCOMMITTTSPRE'
            
       ElseIf cIdPonto == 'FORMCOMMITTTSPOS'
       		//Chamada apos a gravação da tabela do formulário (FORMCOMMITTTSPOS).
       		RecLock("SC8", .F.)
       			SC8->C8_CODCOM := SC1->C1_CODCOMP
       		SC8->(MsUnlock())
       	
       ElseIf cIdPonto == 'MODELCANCEL'
       		//Chamada no Botão Cancelar (MODELCANCEL).' + CRLF + 'Deseja Realmente Sair ?'

       ElseIf cIdPonto == 'BUTTONBAR'
       		//Adicionando Botao na Barra de Botoes (BUTTONBAR).' + CRLF + 'ID ' + cIdModel )

       EndIf
EndIf

RestArea(aAreaSC8)
Return xRet