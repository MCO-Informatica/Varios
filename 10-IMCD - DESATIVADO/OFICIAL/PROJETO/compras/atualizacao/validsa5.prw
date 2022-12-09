#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT103INC  �Autor  � Otacilio A. Junior � Data �  06/05/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Validar campos na Amarra��o Produto x Fornecedor           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Exclusivo Makeni    D1_COD - X3_VLDUSER                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER Function VALIDSA5()

Local lRet := .T.

If cTipo == "N" .and. INCLUI
	
	nPosCod:= aScan(aHeader,{ |x| Alltrim(x[2])=="D1_COD"})
	cMsg   := ""
	cMsg1  := ""
	cTipoCQ:= ""
	aArea  := GetArea()
	aAreaQE6	:= QE6->(GETAREA())
	
	//SD1->(DbSetOrder(1))
	//SD1->(xFilial("SD1")+M->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA))
	
	//While SD1->(!EOF()) .AND. SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == M->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
	cTipoCQ:= Posicione("SB1",1,xFilial("SB1")+aCols[n][nPosCod],"B1_TIPOCQ")
	If cTipoCQ == "Q"
		dbSelectArea("SA5")
		dbSetOrder(1)
		lAchou := MsSeek(xFilial("SA5")+CA100FOR+CLOJA+aCols[n][nPosCod],.F.)	//M->(F1_FORNECE+F1_LOJA)+aCols[n][nPosCod],.F.)
		If lAchou
			If EMPTY(SA5->A5_SITU)
				lRet:= .F.
				cMsg+= "Situa��o em Branco na Amarra��o Produto x Fornecedor" + Chr(13)+Chr(10)
			EndIf
			If EMPTY(SA5->A5_TEMPLIM)
				lRet:= .F.
				cMsg+= "Tempo Limite em Branco na Amarra��o Produto x Fornecedor" + Chr(13)+Chr(10)
			EndIf
			If EMPTY(SA5->A5_FABREV)
				lRet:= .F.
				cMsg+= "Fabricante/Revend/Permuta em Branco na Amarra��o Produto x Fornecedor" + Chr(13)+Chr(10)
			EndIf
			If EMPTY(SA5->A5_ATUAL)
				lRet:= .F.
				cMsg+= "Atualiza��o autom�tica em Branco na Amarra��o Produto x Fornecedor" + Chr(13)+Chr(10)
			EndIf
			If EMPTY(SA5->A5_TIPATU)
				lRet:= .F.
				cMsg+= "Tipo da Atualiza��o em Branco na Amarra��o Produto x Fornecedor" + Chr(13)+Chr(10)
			EndIf
		Else
			lRet:= .F.
			cMsg+= "N�o existe a Amarra��o Produto x Fornecedor" + Chr(13)+Chr(10)
		EndIf
		
		IF cEmpAnt == '01'
			
			IF !QE6->(DBSEEK(XFILIAL("QE6")+aCols[n][2])) .AND. POSICIONE("SB1",1,XFILIAL("SB1")+aCols[n][2],"ALLTRIM(B1_TIPOCQ)")== 'Q'
				lRet := .F.
				MsgAlert( 'Aten��o'+CRLF+'Para o Produto:'+alltrim(aCols[n][2])+' � necessario o cadastro da especifica��o do Produto' , "INFO")
			ENDIF
			
		ENDIF
		
		
		
	EndIf
	
	RestArea(aAreaQE6)
	
	RestArea(aArea)
	
EndIf

IF !Empty(cMsg)
	cMsg1 := aCols[n][nPosCod]+ " - "+POSICIONE("SB1",1,XFILIAL("SB1")+aCols[n][nPosCod],"B1_DESC") + Chr(13)+Chr(10) + Chr(13)+Chr(10)
	cMsg1 += cMsg
	MsgAlert( cMsg1, "INFO")
EndIf

RETURN(lRet)
