#Include "Protheus.Ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: MTA103OK  | Autor: Celso Ferrone Martins  | Data: 29/10/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | PE Validacao na entrada de nota de CTE                     |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
User Function MTA103OK()

Local lRet := .T.
Local cEol := CHR(13)+CHR(10)
Local aAreaSc7 := SC7->(GetArea())
Local aSc7Num  := {}

DbSelectArea("SC7") ; DbSetOrder(1)

//Local nPD1Pedido := aScan(aHeader,{|x| Alltrim(x[2])=="D1_PEDIDO"})

If AllTrim(cEspecie) $ "CTE" .And. cTipo == "N"

	If Len(aCfmDaCte) == 0
		lRet := .F.
		MsgAlert("Tipo da Nota -> Normal e Espec.Docum. -> CTE ou NFS"+cEol+cEol+;
		"Nenhuma NFe de saida Selecionada." +cEol  ;
		,"Atencao!!!")  
	Else 
		cNFMarcada := "" 
		cNFNMarcada := ""
		For nX := 1 To Len(aCfmDaCte[2])
			If !Empty(aCfmDaCte[2][nX][1])
				cNFMarcada 	+= "" + cValToChar(aCfmDaCte[2][nX][2]) + CRLF 
			 Else
				cNFNMarcada	+= "" + cValToChar(aCfmDaCte[2][nX][2]) + CRLF 
			EndIf
		Next nX       
		
		If Empty(cNFMarcada)
			lRet := .F.
			MsgAlert("Tipo da Nota -> Normal e Espec.Docum. -> CTE ou NFS"+cEol+cEol+;
			"Nenhuma NFe de saida Selecionada." +cEol  ;
			,"Atencao!!!")  
		EndIf
	EndIf
EndIf

/*
If lRet

	For nX := 1 To Len(aCols)
		nPos := aScan(aSc7Num,{|x|x[1]==aCols[nX][nPD1Pedido]})
		If nPos == 0
			aAdd(aSc7Num,{aCols[nX][nPD1Pedido]})
		EndIf
	Next nX
	fOR nS
	SC7->(DbSeek(xFilial("SC7")+))
EndIf
*/
Return(lRet)