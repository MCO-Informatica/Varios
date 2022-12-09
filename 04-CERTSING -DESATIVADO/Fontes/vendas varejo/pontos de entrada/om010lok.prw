#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OM010LOK  ºAutor  ³Darcio R. Sporl     º Data ³  13/09/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada criado para fazer a validacao do item      º±±
±±º          ³da tabela de preco quando deletado, pois se tiver combo nao º±±
±±º          ³podera ser deletado.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Opvs x Certisign                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function OM010LOK()
Local aArea		:= GetArea()
Local nPosC		:= aScan(aHeader, {|x| alltrim(x[2]) == "DA1_CODCOB"})
Local nPosGar		:= aScan(aHeader, {|x| alltrim(x[2]) == "DA1_CODGAR"})
Local nPosAtivo	:= aScan(aHeader, {|x| alltrim(x[2]) == "DA1_ATIVO"})
Local nPosQtd		:= aScan(aHeader, {|x| alltrim(x[2]) == "DA1_QTDLOT"})

Local lRet	:= .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se a linha do aCols estiver deletada verifica se o combo esta preenchido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Renato Ruy - 18/04/2018
//Retirada Validação, o sistema não entra quando a linha esta deletada.
//If aCols[n][Len(aHeader) + 1]
//	If !Empty(aCols[n][nPosC])
//		MsgStop('Este item não pode ser excluído, por se tratar de um Combo.')
//		lRet := .F.
//	EndIf
//EndIf

If nPosGar > 0
	cProdGar := aCols[n][nPosGar] 
	nQtd	 := aCols[n][nPosQtd]
	If !Empty(cProdGar) 
		For nI := 1 to Len(aCols)
	    	If nI <> n .and. alltrim(aCols[nI,nPosGar]) == alltrim(cProdGar) .And. aCols[n,nPosAtivo] =='1' .And. aCols[nI,nPosAtivo] =='1' .and. aCols[nI,nPosQtd] == nQtd
	    		MsgStop('Produto GAR já existe para a tabela.')
				lRet := .F.  		
				exit
		    EndIf
		Next
	EndIf
EndIf

RestArea(aArea)
Return(lRet)