#INCLUDE "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOMEEMP   �Autor  �Ronaldo L. Rocha    � Data �  18/06/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para trazer o nome da empresa da filal de origem    ���
���          � no momento da gera��o do CNAB                              ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function NOMEEMP()


Local cNomeRet  := ""


If Alltrim(SE1->E1_PREFIXO) = "001"

	cNomeRet  := "KENIA INDUSTRIAS TEXTEIS "
	
	Elseif Alltrim(SE1->E1_PREFIXO) = "002"

	cNomeRet  := "ONITEX TINTURARIA  "
	
	Elseif Alltrim(SE1->E1_PREFIXO) = "003"

	cNomeRet  := "KONIA TEXTIL  "

Endif


Return(cNomeRet)