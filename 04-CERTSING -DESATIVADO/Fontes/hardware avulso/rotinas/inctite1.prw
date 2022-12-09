#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �INCTITE1  �Autor  �Opvs (David)        � Data �  19/07/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa de Inclus"ao de Titulo a Receber                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function IncTitE1(nOpc,cPrefix,cNumPed,cParcel,cTipo,cNaturez,cCliente,cLoja,dEmissao,dVencto,nValor,cNosso,cXnpsite)

Local aTitulo	:= {}
Local cMsg		:= ""
Local aRet		:= {}

Private lMsErroAuto := .F.

Default cXnpsite = Space(TamSX3("E1_XNPSITE")[1])

// Dados da Tabela SE1 que ser�o preenchidos
aAdd(aTitulo,   {"E1_PREFIXO"   , cPrefix          					,Nil}) // Campo que permite ao usuario identificar um conjunto de titulos que pertencam a um mesmo grupo 
aAdd(aTitulo,   {"E1_NUM"	    , cNumPed          					,Nil}) // Numero do titulo
aAdd(aTitulo,   {"E1_PARCELA"   , cParcel          					,Nil}) // Parcela do Titulo
aAdd(aTitulo,	{"E1_TIPO"	    , cTipo                             ,Nil}) // Tipo(Boleto, Cartao, Cheque...)
aAdd(aTitulo,	{"E1_NATUREZ"   , cNaturez 		    			    ,Nil}) // Utilizado para identificar a procedencia dos titulos
aAdd(aTitulo,	{"E1_CLIENTE"   , cCliente  		    		    ,Nil}) // Codigo do Cliente
aAdd(aTitulo,	{"E1_LOJA"	    , cLoja            					,Nil}) // Lojas do Cliente
aAdd(aTitulo,	{"E1_EMISSAO"   , dEmissao       					,Nil}) // Data de Emissao
aAdd(aTitulo,	{"E1_VENCTO"	, dVencto      				    	,Nil}) // Data de Vencimento
aAdd(aTitulo,	{"E1_VENCREA"   , DataValida(dVencto)				,Nil}) // Venvimento Real
aAdd(aTitulo,	{"E1_VALOR"  	, nValor         					,Nil}) // Valor do Titulo
aAdd(aTitulo,	{"E1_PEDIDO"  	, cNumPed         					,Nil}) // Pedido de Venda
aAdd(aTitulo,	{"E1_XNPSITE"  	, cXnpsite         					,Nil}) // Pedido de Venda gerado pelo site
aAdd(aTitulo,	{"E1_NUMBCO"  	, cNosso         					,Nil}) // Nosso N�mero do Boleto

MSExecAuto({|x,y| FINA040(x,y)},aTitulo,nOpc)

If lMsErroAuto
 	MOSTRAERRO("\system\", "erro_titulo.txt")
	DisarmTransaction()
	aRet := {.F.,"Inconsist�ncia ao incluir o T�tulo",aTitulo}
Else
	aRet := {.T.,"T�tulo Inclu�do com sucesso",aTitulo}
EndIf

Return(aRet)
