#Include "Protheus.ch"

/*/{Protheus.doc} M410LIOK

Ponto de Entrada executado no momento de alteração das linhas nos itens do pedido de venda. 
Será exibido aviso, caso o usuário preencha o TIPO DE OPERAÇÃO errado para clientes corporativos.
@author Luiz Suguiura
@since 30/03/2021

/*/



User Function M410LIOK()

Local _aAlias := Alias()
Local _cOper  := aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_OPER"})]
Local _cOrigPv:= M->C5_XORIGPV
Local _lRet	  := .t.

/* ORIGEM PV QUE NÃO PODE NOS CLIENTES CORPORATIVOS
2-varejo
3-hardware avulso
7-portal assinatura
8-cursos
9-portal ssl
0-ponto movel
A-varejo
B-SAC
C-PDA
*/

If !_cOrigPv$"0/2/3/7/8/9/A/B/C" .And. _cOper$"51/52/53/61/62"
	MsgStop("Tipo de Operação errada Cliente Corporativo.","Tipo Operação - Cliente Corporativo")
	//_lRet := .f.
EndIf
   	
Return(_lRet)
