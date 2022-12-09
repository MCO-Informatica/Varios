#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
  
/*
+------------+----------+--------+-----------------+-------+------------+
| Programa:  | FA070TIT	| Autor: | Silverio Bastos | Data: | Março/2010 |
+------------+----------+--------+-----------------+-------+------------+
| Descrição: | Ponto de Entrada para atualizar o campo A1_LC (limite de |
|            | credito).                                				|
+------------+----------------------------------------------------------+
| Uso:       | Verion Óleo Hidráulica Ltda.                             |
+------------+----------------------------------------------------------+
*/

User Function FA070TIT
// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+
Local _aArea  := GetArea()
Local _cDupli := _cLimite := _Nropag := 0


_cCliente := SE1->E1_CLIENTE 
_cLoja    := SE1->E1_LOJA
_cValor   := NVALREC
_ctitulo  := SE1->E1_NUM
_cprefix  := SE1->E1_PREFIXO
_CPARCEL  := SE1->E1_PARCELA

MSGSTOP(_cCliente + " - " + _cLoja + " - " + _ctitulo  + " - " + _cprefix + " - " + _CPARCEL)
	
DbSelectArea("SE1")
DbSetOrder(2)
DbSeek(xFilial("SE1") + _cCliente + _cLoja,.f.)

While !Eof() .AND. SE1->E1_CLIENTE == _cCliente .AND. SE1->E1_LOJA == _cLoja
	    
      If EMPTY(SE1->E1_BAIXA)
         DbSelectArea("SE1")
         DbSkip()
         loop               
      Else
      
         _cDupli := _cDupli + (SE1->E1_VALOR - SE1->E1_SALDO)

      Endif     
 
 	  DbSelectArea("SE1")
	  DbSkip()
	  loop
End
                       
DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1") + _cCliente + _cLoja,.f.) 

_cLimite := (_cDupli + _cValor) / (SA1->A1_NROPAG + 1)

While !RecLock("SA1",.F.)
End
SA1->A1_LC := _cLimite
MsUnLock("SA1")
                   

DbSelectArea("SE1")
DBSETORDER(2)
DBSEEK(XFILIAL("SE1") +_cCliente + _cLoja + _cprefix + _ctitulo + _CPARCEL)

// +----------------------------+
// | Restaura Ambiente Original |
// +----------------------------+
RestArea(_aArea)
Return(.t.)