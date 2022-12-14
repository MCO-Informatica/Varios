#Include "Protheus.ch"
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} Mata131
//TODO Ponto de Entrada padr?o MVC da rotina de Gera??o de Cota??es.
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
		//Chamada na valida??o total do modelo (MODELPOS).

	ElseIf cIdPonto == 'FORMPOS'
		//Chamada na valida??o total do formul?rio (FORMPOS).

	ElseIf cIdPonto == 'FORMLINEPRE'
		If aParam[5] == 'DELETE'
			//Chamada na pre valida??o da linha do formul?rio (FORMLINEPRE).' + CRLF
			//'Onde esta se tentando deletar uma linha' + CRLF

		EndIf
           
       ElseIf cIdPonto == 'FORMLINEPOS'
       		//Chamada na valida??o da linha do formul?rio (FORMLINEPOS).

       ElseIf cIdPonto == 'MODELCOMMITTTS'
       		//Chamada apos a grava??o total do modelo e dentro da transa??o (MODELCOMMITTTS).
            
       ElseIf cIdPonto == 'MODELCOMMITNTTS'
       		//Chamada apos a grava??o total do modelo e fora da transa??o (MODELCOMMITNTTS).' + CRLF + 'ID ' + cIdModel)
       		//Informa o numero da cota??o gerada.
       		MsgInfo("Numero da Cota??o: "+SC8->C8_NUM + CRLF+"Filial: "+SC8->C8_FILIAL, "Cota??o")
       
       ElseIf cIdPonto == 'FORMCOMMITTTSPRE'
            
       ElseIf cIdPonto == 'FORMCOMMITTTSPOS'
       		//Chamada apos a grava??o da tabela do formul?rio (FORMCOMMITTTSPOS).
       		RecLock("SC8", .F.)
       			SC8->C8_CODCOM := SC1->C1_CODCOMP
       		SC8->(MsUnlock())
       	
       ElseIf cIdPonto == 'MODELCANCEL'
       		//Chamada no Bot?o Cancelar (MODELCANCEL).' + CRLF + 'Deseja Realmente Sair ?'

       ElseIf cIdPonto == 'BUTTONBAR'
       		//Adicionando Botao na Barra de Botoes (BUTTONBAR).' + CRLF + 'ID ' + cIdModel )

       EndIf
EndIf

RestArea(aAreaSC8)
Return xRet