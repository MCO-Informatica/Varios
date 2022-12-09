#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT100TOK  �Autor  �Roberta Alonso        � Data �  19/10/16 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para a valida�ao do Documento de Entrada. ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 12 - Especifico para Prozyn                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT100TOK()

Local _cAlias		:= Alias()
Local _nRecno		:= Recno()
Local _nIndex		:= IndexOrd()
Local _aSavSB1		:= SB1->(GetArea())
Local _aSavSF4		:= SF4->(GetArea())
Local _nPosProd		:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"   	})
Local _nPosTes		:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_TES"   	})
Local _nPosLote		:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_LOTECTL"   })
Local _nPosIt		:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEM"   	})
//Local _nPosDtvalid  := aScan(aHeader,{|x| Alltrim(x[2])=="D1_DTVALID"	})
//Local _dDatRef		:= Date()
Local _lRet     	:= .T.
Local _nCont		:= 1
Local _cRotina		:= "MT100TOK"

If Type("cEspecie")=="C"  
	If  (AllTrim(cEspecie) == "SPED" .AND. UPPER(AllTrim(cFormul)) == "N") .AND. Empty(aNFEDanfe[13])	//Validacao de preenchimento da chave NFE (aNFEDanfe[13]), para notas de especie SPED, quando nao se tratar de formulario proprio
		Alert("Aten�ao! Para notas fiscais eletr�nicas, informe obrigatoriamente a chave NFE!")
		_lRet := .F.
	EndIf
EndIf

//If _nPosDtvalid >= _dDatRef
//	Alert("Data de validade menor que a data atual.")
//EndIf


//In�cio - Trecho adicionado por Adriano Leonardo em 06/03/2017
dbSelectArea("SB1")
dbSetOrder(1)

dbSelectArea("SF4")
dbSetOrder(1)

If FunName()<>"SPEDNFE"
	For _nCont := 1 To Len(aCols)
		If !aCols[_nCont,Len(aCols[_nCont])]
			If SB1->(msSeek(xFilial("SB1")+aCols[_nCont,_nPosProd]))
				If SB1->B1_RASTRO=="L"
					If SF4->(msSeek(xFilial("SF4")+aCols[_nCont,_nPosTES]))
						If SF4->F4_ESTOQUE=="S"
							If Empty(aCols[_nCont,_nPosLote])
								MsgStop("Aten��o, o preenchimento do lote para o item: " + aCols[_nCont,_nPosIt] + " � obrigat�rio!",_cRotina+"_001")
								_lRet := .F.
								Exit
							EndIf
						EndIf
					EndIF
				EndIf
			EndIf
		EndIf
	Next
EndIf

RestArea(_aSavSB1)
RestArea(_aSavSF4)
//Final  - Trecho adicionado por Adriano Leonardo em 06/03/2017

dbSelectArea(_cAlias)
dbSetOrder(_nIndex)
dbGoTo(_nRecno)

Return(_lRet)   
