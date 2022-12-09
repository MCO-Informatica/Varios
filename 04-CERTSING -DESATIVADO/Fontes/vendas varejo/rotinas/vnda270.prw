#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VNDA270  �Autor  �Opvs (David)        � Data �  19/07/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa de Inclus"ao de Titulo a Receber                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VNDA270(nOpc,cPrefix,cNumPed,cParcel,cTipo,cNaturez,cCliente,cLoja,dEmissao,dVencto,nValor,cNosso,cXnpsite,cId,cPedLog,cTipMov)

Local aTitulo	:= {}
Local cMsg		:= ""
Local aRet		:= {}

Private lMsErroAuto := .F.
Private lAutoErrNoFile	:= .T.	// variavel interna da rotina automatica MSExecAuto()

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
aAdd(aTitulo,	{"E1_VEND1"  	, ""	         					,Nil}) // Vendedor 1
aAdd(aTitulo,	{"E1_VEND2"  	, ""	         					,Nil}) // Vendedor 2
aAdd(aTitulo,	{"E1_VEND3"  	, ""	         					,Nil}) // Vendedor 3
aAdd(aTitulo,	{"E1_VEND4"  	, ""	         					,Nil}) // Vendedor 4
aAdd(aTitulo,	{"E1_VEND5"  	, ""	         					,Nil}) // Vendedor 5
aAdd(aTitulo,	{"E1_NUMBCO"  	, cNosso         					,Nil}) // Nosso N�mero do Boleto
aAdd(aTitulo,	{"E1_TIPMOV"  	, cTipMov         					,Nil}) // Tipo do Movimento
If cXnpsite <> cPedLog  
	aAdd(aTitulo,	{"E1_PEDGAR"  	, cPedLog         					,Nil}) // C�digo Pedido GAR
EndIf

U_GTPutIN(cID,"T",cPedLog,.T.,{"U_VNDA270",cPedLog,"Inclus�o de T�tulo",aTitulo},cXnpSite)

M->E1_VEND1	:= 	""
M->E1_VEND2	:=  ""
M->E1_VEND3	:=  ""
M->E1_VEND4	:=  ""
M->E1_VEND5	:=  ""

MSExecAuto({|x,y| FINA040(x,y)},aTitulo,nOpc)

If lMsErroAuto
 	MOSTRAERRO()
	cMsg := "Inconsist�ncia para Criar T�tulo" + CRLF + CRLF
	aAutoErr := GetAutoGRLog()
	For nI := 1 To Len(aAutoErr)
		cMsg += aAutoErr[nI] + CRLF
	Next nI   
	U_GTPutOUT(cID,"T",cPedlog,{"INC_TITULO",{.F.,"E00015",cPedLog,cMsg}},cXnpSite)
	aRet := {.F.,cMsg,aTitulo}
Else
	cMsg := "T�tulo Gerado com Sucesso"
	U_GTPutOUT(cID,"T",cPedLog,{"INC_TITULO",{.T.,"M00001",cPedLog,cMsg}},cXnpSite)
	aRet := {.T.,cMsg,aTitulo}
EndIf

Return(aRet)
