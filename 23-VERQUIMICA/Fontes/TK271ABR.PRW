#Include "Protheus.Ch"
/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: TK271ABR  | Autor: Danilo Alves Del Busso | Data: 18/08/2015 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | PE ativado quando clicar em alterar um orçamento/pedido    |||
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
	if !Empty(SUA->UA_EMISNF)   //Se a data de Emissão da NF estiver preenchida, é um pedido já faturado.
		if SUA->UA_OPER == '1'  //Confirma se o pedido é faturado (dupla verificação) 
				SM2->(DbSeek(SUA->UA_EMISNF))
				RecLock("SUA", .F.)          
				SUA->UA_VQ_TXDO := SM2->M2_MOEDA2
				SUA->(MsUnlock())  
		EndIf
	Else  //Se o pedido não tiver a data de emissão da NF logo, ele pegara a cotação atual do dólar.
		SM2->(DbSeek(cDtAtual)) 
		RecLock("SUA", .F.)          
		SUA->UA_VQ_TXDO := SM2->M2_MOEDA2
		SUA->(MsUnlock())
	EndIf     	
endif
                     
SUA->(RestArea(cAreaSUA))  
SM2->(RestArea(cAreaSM2))    

Return()