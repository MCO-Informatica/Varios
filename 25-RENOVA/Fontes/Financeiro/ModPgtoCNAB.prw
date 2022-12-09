#include "rwmake.ch"
#include "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o de  �ModPgtoCNAB  �Autor  �Marcus Vinicius    �Data  �20/08/2013���
���Usuario    �             �       �  Barros           �      |          ���
�������������������������������������������������������������������������Ĵ��
���Programa  �FINA050                                                     ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao �Ponto de Entrada para Alterar a modalidade de pagamento     ���
���          �nos titulos do Contas a Pagar, quando incluido um c�digo de ���
���          �Barras													  ���
�������������������������������������������������������������������������Ĵ��
���Utilizacao�Chamada de rotinas                                          ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Observac. � CLIENTE RENOVA ENERGIA                                     ���
�������������������������������������������������������������������������Ĵ��
���           Atualizacoes sofridas desde a constru�ao inicial            ���
�������������������������������������������������������������������������Ĵ��
���Programador �Data      �Motivo da Altera�ao                            ���
�������������������������������������������������������������������������Ĵ��
���	     	   |          |	                                              ���
���	     	   |          |	                                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function ModPgtoCNAB(cVerifica)

Local 	aArea		:= GetArea()
//Local	cBancoCD	:= SUBSTR(ALLTRIM(M->E2_CODBAR),1,3)
//Local	cBancoSA2	:= ALLTRIM(SA2->A2_BANCO)
Local	cRet		:=""

Private nParam	:= GetNewPar("MV_X_TETO",.F.)
Private nTotal	:= M->E2_VALOR

IF cVerifica == 2
	IF EMPTY(M->E2_CODBAR)
		IF !EMPTY(SA2->A2_BANCO) .AND. !EMPTY(SA2->A2_AGENCIA) .AND. !EMPTY(SA2->A2_NUMCON)
			IF nTotal >= nParam
				cRet := "41"
			ELSE
				cRet := "03"
			ENDIF
		ELSE
			cRet := "03"
   	 		MSGALERT("FORNECEDOR NAO POSSUI BANCO/AG/CONTA CORRENTE CADASTRADOS. PARA BOLETOS, FAVOR PREENCHER O C�DIGO DE BARRAS ")
   	 	ENDIF
	ELSE
		cRet := "31"
	ENDIF
ENDIF

RestArea(aArea)

RETURN cRet
