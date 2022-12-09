#Include "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CNABBRAD  �Autor  �Thiago Queiroz      � Data �  02/09/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � Realiza o calculo do digito verificador do arquivo CNAB    ���
���          � e do Boleto Bradesco                                       ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 10 - LINCIPLAS                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CNABBRAD

//Public _cDig := ""
//MSGBOX(ALLTRIM(SE1->E1_PORTADO), ALLTRIM(SE1->E1_AGEDEP), ALLTRIM(SE1->E1_CONTA))
IF ALLTRIM(SE1->E1_PORTADO) == "237" .AND. ALLTRIM(SE1->E1_AGEDEP) == "2501" .AND. ALLTRIM(SE1->E1_CONTA) == "331750" //BRADESCO CARTEIRA 02 - GARANTIA
//Alert("garantia")	
	xcpo := "0200"+SE1->E1_NUMBCO
	_cDig := U_MOD11(xcpo,2,7)
	IF val(_cDig) == 10
		_cDig := "P"
	ELSE
		_cDig := SUBSTR(_cDig,2,1)
	ENDIF
ELSEIF ALLTRIM(SE1->E1_PORTADO) == "237" .AND. ALLTRIM(SE1->E1_AGEDEP) == "2501" .AND. ALLTRIM(SE1->E1_CONTA) == "33175" //BRADESCO CARTEIRA 09 - C.CORRENTE
	//	_cDig := SUBSTR(SE1->E1_NUMBCO,12,1)
//Alert("corrente")	
	xcpo := "0900"+SE1->E1_NUMBCO
	_cDig := U_MOD11(xcpo,2,7)
	IF val(_cDig) == 10
		_cDig := "P"
	ELSE
		_cDig := SUBSTR(_cDig,2,1)
	ENDIF
	
//ELSE
//Alert("n�o gerou arquivo")	
	
ENDIF



Return(_cDig)
