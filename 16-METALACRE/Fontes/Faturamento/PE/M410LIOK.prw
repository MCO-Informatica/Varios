#Include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M410LIOK  �Autor  �Bruno Abrigo        � Data �  08/02/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Permite validar a linha do Pedido de Venda.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Metalacre                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M410LIOK()

Local lRet		:=.T.
Local _cCliVal  := M->C5_CLIENT+M->C5_LOJACLI
Local nPosProd  := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO" })
Local nPosQtde  := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN" })
Local nPosEntr  := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_ENTREG" })
Local nPosLacre := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_XLACRE" })
Local nPosItem  := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_ITEM"   })
Local nPosQtde  := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN"   })

If !Inclui .and. !Altera // Exclui pedido retorna verdadeiro normalmente. . .
	Return lRet
Endif
If cEmpAnt <> "01"	                                                
	Return .T.
Endif

// Verifica Bloqueio de Personaliza��es

If !aCols[n,Len(aHeader)+1]
	If Z00->(dbSetOrder(1), dbSeek(xFilial("Z00")+aCols[n,nPosLacre]))
		If Z00->Z00_MSBLQL == '1'
			MsgStop("Aten��o a Personaliza��o " + aCols[n,nPosLacre] + " Encontra-se Bloqueada, Imposs�vel Sua Utiliza��o !")
			Return .F.
		Endif
		If !Empty(Z00->Z00_LIMITE) .And. (Z00->Z00_LACRE + aCols[n,nPosQtde]) > Z00->Z00_LIMITE
			MsgStop("Aten��o a Personaliza��o " + aCols[n,nPosLacre] + " Ira Superar o Limite de " + TransForm(Z00->Z00_LIMITE,'9,999,999,999') + ", Imposs�vel Sua Utiliza��o !")
			Return .F.
		Endif
	Endif
Endif

If SC5->(FieldPos("C5_XCONTRA")) > 0
	If !Empty(M->C5_XCONTRA)
//		U_CopyAcols()
	Endif
Endif
/*

	For i:=1 To len(aCols)
		
		If !Empty(aCols[i,nPosLacre]) .and. !aCols[i,Len(aHeader)+1] .and. lRet// Personalizacao preenchida e item nao deletado;
			
			dbSelectArea("Z02")
			// Z02_FILIAL+Z02_CODPER+Z02_CODCLI+Z02_LOJACL
			DbOrderNickName("Z02003") //indice 3
			/* Comentado temporariamente para funcionamento da altera��o do PV - Mateus/Mario - 11/12/13
			If !Z02->(DBSeek(xFilial("Z02")+aCols[i,nPosLacre]+_cCliVal))
				MsgAlert("O cliente ["+ _cCliVal +"] loja ["+M->C5_LOJACLI+"] n�o existe para a personaliza��o ["+ aCols[i,nPosLacre] +"] informada no item ["+aCols[i,nPosItem]+"] favor verificar o Cod. do Cliente novamente para prosseguir!","Aten��o")
				lRet:=.F.
			Endif
		Endif
	Next i
EndIf
  */
Return lRet