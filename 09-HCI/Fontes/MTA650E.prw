#INCLUDE "PROTHEUS.CH"
//-------------------------------------------------------------------
/*/{Protheus.doc} MTA650E
 Deleção de Ordem de Produção

@author		Jair Ribeiro 
@since		03/08/2015
@version	1.0
@obs		Rotina Especifica
/*/
//-------------------------------------------------------------------
User Function MTA650E()

Z00->(DbSetOrder(1))
While Z00->(DbSeek(xFilial("Z00")+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)))
	If File(Z00->Z00_LOCAL)
		If FERASE(Z00->Z00_LOCAL) != 0
			MsgInfo("Erro ao excluir arquivo no servidor!")
		EndIf
	EndIf
	If RecLock("Z00",.F.)
		Z00->(DbDelete())
		Z00->(MsUnlock())
	EndIf	
EndDo
Return .T.