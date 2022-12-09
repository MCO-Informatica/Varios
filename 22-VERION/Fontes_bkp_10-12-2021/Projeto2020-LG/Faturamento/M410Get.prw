#include "rwmake.ch" 

User Function M410Get()
Public _cUser, _cLocal

//alert("m410get")

_cLocal  := GetArea()
_lLib    := .F.
_cVerTe1a := "COM A ALTERACAO DO PEDIDO DE VENDA, OS PRODUTOS ESTARAO DISPONIVEIS PARA O ESTOQUE. "
_cVerTe2b := "SENDO  NECESSARIO APOS A SUA ALTERACAO, ENTRAR NOVAMENTE NO PEDIDO E  TECLAR ENTER "
_cVerTe3c := "NO CAMPO QUANTIDADE PARA RESERVAR NO ESTOQUE.Deseja continuar ?"
_cVerTexd := _cVerTe1a + _cVerTe2b + _cVerTe3c       

// ROTINA DE GERACAO DE PEDIDO DE VENDAS NO CASO DE MEDICAO DE CONTRATOS..... 
If ALLTRIM(FUNNAME()) == "CNTA120"
     return()
endif

M->C5_VRTIMER := TIME()
M->C5_EMISSAO := DDATABASE

If MSGYESNO(_cVerTexd)      
   _lLib    := .T.
Else  
   _lLib    := .F.
Endif

_cverlib := SC5->C5_VRLIB

IF _CVERLIB $ "F"
	MSGALERT("O Pedido se encontra com o status de Faturamento. Qualquer alteração de Condicao de Pagamento,Transportadora,Quantidade,Produto,Inclusao ou Exclusao de Itens,etc. Favor avisar o ALMOXARIFADO !!!","ATENCAO !!!") 
ENDIF

RestArea(_cLocal)
Return
