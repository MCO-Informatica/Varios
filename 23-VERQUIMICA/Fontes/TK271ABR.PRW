#Include "Protheus.Ch"
/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: TK271ABR  | Autor: Danilo Alves Del Busso | Data: 18/08/2015 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | PE ativado quando clicar em alterar um or?amento/pedido    |||
|||				callcenter 											       |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/      

User Function TK271ABR()

Local cAreaSUA := SUA->(GetArea())      
Local cAreaSM2 := SM2->(GetArea())      
Local cDtAtual := DATE() 

lDesconto := .F.

DbSelectArea("SM2"); DbSetOrder(1)  
DbSelectArea("SUA"); DbSetOrder(4) 

if (altera) .OR. (!altera .AND. !inclui)  
	if !Empty(SUA->UA_EMISNF)   //Se a data de Emiss?o da NF estiver preenchida, ? um pedido j? faturado.
		if SUA->UA_OPER == '1'  //Confirma se o pedido ? faturado (dupla verifica??o) 
				SM2->(DbSeek(SUA->UA_EMISNF))
				RecLock("SUA", .F.)          
				SUA->UA_VQ_TXDO := SM2->M2_MOEDA2
				SUA->(MsUnlock())  
		EndIf
	Else  //Se o pedido n?o tiver a data de emiss?o da NF logo, ele pegara a cota??o atual do d?lar.
		SM2->(DbSeek(cDtAtual)) 
		RecLock("SUA", .F.)          
		SUA->UA_VQ_TXDO := SM2->M2_MOEDA2
		SUA->(MsUnlock())
	EndIf     	
endif
                     
SUA->(RestArea(cAreaSUA))  
SM2->(RestArea(cAreaSM2))    

Return()