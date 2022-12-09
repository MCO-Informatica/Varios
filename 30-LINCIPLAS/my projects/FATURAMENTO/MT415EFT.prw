#INCLUDE 'RWMAKE.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT415EFT  �Autor  �Rodrigo Okamoto     � Data �  29/03/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Efetuar valida��o na efetiva��o do or�amento               ���
���          � MTA416BX - Autom�tico                                      ���
���          � MT415EFT - Manual                                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT415EFT

Local aArea416 	:= getarea()
Local cCliente	:= M->CJ_CLIENTE
Local cLoja		:= M->CJ_LOJA
Local cNumOrc	:= M->CJ_NUM
Local cUF	:= getadvfval("SA1","A1_EST",xFILIAL("SA1")+cCliente+cLoja,1,"")
lFil02	:= .F.
//considerando que num orcamento SPIDER contem apenas produtos SPIDER e nao Linciplas
//If alltrim(cUF) $ "RJ/PE/SP/TO/RS"
DbSelectArea("SCK")
DbSetOrder(1)
DbSeek(xFilial("SCK")+cNumOrc)
While SCK->(!eof()) .and. cNumOrc == SCK->CK_NUM
	If (SUBSTR(SCK->CK_PRODUTO,1,3) >= "S01" .AND. SUBSTR(SCK->CK_PRODUTO,1,3) <= "S08") .OR. SUBSTR(SCK->CK_PRODUTO,1,5) == "SPI35"
		lFil02	:= .T.
		Exit
	EndIf
	SCK->(DbSkip())
END

If lFil02
	DbSelectArea("SCK")
	dbGotop()
	DbSeek(xFilial("SCK")+cNumOrc)
	While SCK->(!eof()) .and. cNumOrc == SCK->CK_NUM
		reclock("SCK",.F.)
		SCK->CK_FILVEN	:= "02"
		SCK->CK_FILENT	:= "02"
		MSUNLOCK()
		SCK->(DbSkip())
	END
	alert("Faturamento do or�amento "+cNumOrc+" ser� pela filial 02!")
Else
	DbSelectArea("SCK")
	dbGotop()
	DbSeek(xFilial("SCK")+cNumOrc)
	While SCK->(!eof()) .and. cNumOrc == SCK->CK_NUM
		reclock("SCK",.F.)
		SCK->CK_FILVEN	:= "01"
		SCK->CK_FILENT	:= "01"
		MSUNLOCK()
		SCK->(DbSkip())
	END
EndIf


RestArea(aArea416)

Return .t.




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA416BX  �Autor  �Rodrigo Okamoto     � Data �  29/03/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Efetuar valida��o na efetiva��o do or�amento (Autom�tico)  ���
���          � MTA416BX - Autom�tico                                      ���
���          � MT415EFT - Manual                                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTA416BX

Local lRet 	 	:= .T.
Local cAliasQry := PARAMIXB[1]
Local aArea416 	:= getarea()
Local cCliente	:= (cAliasQry)->CJ_CLIENTE
Local cLoja		:= (cAliasQry)->CJ_LOJA
Local cNumOrc	:= (cAliasQry)->CJ_NUM
Local cUF	:= getadvfval("SA1","A1_EST",xFILIAL("SA1")+cCliente+cLoja,1,"")
lFil02	:= .F.

//If alltrim(cUF) $ "RJ/PE/SP/TO/RS"
DbSelectArea("SCK")
DbSetOrder(1)
DbSeek(xFilial("SCK")+cNumOrc)
While SCK->(!eof()) .and. cNumOrc == SCK->CK_NUM
	If (SUBSTR(SCK->CK_PRODUTO,1,3) >= "S01" .AND. SUBSTR(SCK->CK_PRODUTO,1,3) <= "S08") .OR. SUBSTR(SCK->CK_PRODUTO,1,5) == "SPI35"
		lFil02	:= .T.
		Exit
	EndIf
	SCK->(DbSkip())
END
//Caso tiver 1 item que seja SPIDER, todos os itens ser�o faturados pela filial 02
If lFil02
	DbSelectArea("SCK")
	dbGotop()
	DbSeek(xFilial("SCK")+cNumOrc)
	While SCK->(!eof()) .and. cNumOrc == SCK->CK_NUM
		reclock("SCK",.F.)
		SCK->CK_FILVEN	:= "02"
		SCK->CK_FILENT	:= "02"
		MSUNLOCK()
		SCK->(DbSkip())
	END
	alert("Faturamento do or�amento "+cNumOrc+" ser� pela filial 02!")
Else
	DbSelectArea("SCK")
	dbGotop()
	DbSeek(xFilial("SCK")+cNumOrc)
	While SCK->(!eof()) .and. cNumOrc == SCK->CK_NUM
		reclock("SCK",.F.)
		SCK->CK_FILVEN	:= "01"
		SCK->CK_FILENT	:= "01"
		MSUNLOCK()
		SCK->(DbSkip())
	END
EndIf

RestArea(aArea416)

Return lRet
