#Include "RwMake.Ch"
#Include "Protheus.Ch"
#Include "TopConn.Ch"

#DEFINE CRLF CHR(13)+CHR(10) 
/*
=============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+-------------------+--------------------------------+------------------+||
||| Programa: TKGRPED | Autor: Celso Ferrone Martins   | Data: 02/10/2014 |||
||+----------+--------+--------------------------------+------------------+||
|||Descricao | Ponto de Entrada executado antes da gravacao do atendimento|||
|||          | na rotina de TeleVendas. Validacoes especificas antes da   |||
|||          | gravacao do Atendimento.                                   |||
||+----------+------------------------------------------------------------+||
|||Parametros| nLiq      = Valor Liquido                                  |||
|||          | aParc     = Array com os dados das parcelas de pagamento   |||
|||          | cOper     = Tipo de operacao (1 = Faturamento, 2=Orcamento)|||
|||          | cNum      = Numero do Atendimento (UA_NUM)                 |||
|||          | cCodLig   = Codigo da Ligacao (UA_CODLIG)                  |||
|||          | cCodPagto = Codigo da Condicao de Pagamento(UA_CONDPG)     |||
||+----------+------------------------------------------------------------+||
|||Retorno   | .T.       = Continua a Gravacao                            |||
|||          | .F.       = Cancela a Gravacao                             |||
||+----------+------------------------------------------------------------+||
|||Alteracao |                                                            |||
||+----------+------------------------------------------------------------+||
|||Uso       |                                                            |||
||+----------+------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
=============================================================================
*/

User Function TKGRPED(nLiq,aParc,cOper,cNum,cCodLig,cCodPgto)

Local lRet     := .T.
Local cPara    := "ti@verquimica.com.br"
Local cAssunto := "Orcamento efetivado como pedido com pendencia. "+cNum
Local MsgMail  := ""
Local nPosProd := aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})
Local nPosDtEn := aScan(aHeader,{|x| Alltrim(x[2])=="UB_DTENTRE"})
Local cMotivo := CRLF +  "DIVERGÊNCIAS IDENTIFICADAS NOS ITENS DO ORÇAMENTO/PEDIDO: " +  CRLF 
 

If M->UA_OPER == "1" // 1 = Faturamento , 2 = Orcamento
	DbSelectArea("SB1");DbSetOrder(1)
	For nX := 1 To Len(aCols)
		If !aCols[nX][Len(aCols[nX])]
			If SB1->(DbSeek(xFilial("SB1")+aCols[nX][nPosProd]))
				If SB1->B1_MSBLQL == '1' 
					cMotivo += CRLF + "O Produto [ "+ aCols[nX][nPosProd]+"] encontra-se bloqueado e não é possível prosseguir com a gravação do orçamento/faturamento" + CRLF  
					lRet := .F.
				EndIf
			EndIf
			
			If aCols[nX][nPosDtEn] < Date()
					cMotivo += CRLF + "O Produto [ "+ aCols[nX][nPosProd]+"] encontra-se com DATA DE ENTREGA INFERIOR À DATA DE HOJE, ajuste para prosseguir. *Data de entrega impacta no Lote selecionado!" + CRLF  
					lRet := .F.
			EndIf
		EndIf
	Next

	If !lRet
		Define Font oFont Name "Mono AS" Size 0, 15
		If !Empty(Alltrim(cMotivo))
			Define MsDialog oDlg Title "Atenção" From 3, 0 to 440, 417 Pixel
				@ 5, 5 Get oMemo Var cMotivo Memo Size 200, 195 Of oDlg Pixel
				oMemo:bRClicked := { || AllwaysTrue() }
				oMemo:oFont     := oFont
				Define SButton From 205, 175 Type  1 Action oDlg:End() Enable Of oDlg Pixel // Apaga
			Activate MsDialog oDlg Center
		EndIf	
	Else
		lRet := U_CfmPendencia(.T.,@MsgMail)
	EndIf

EndIf

Return(lRet)