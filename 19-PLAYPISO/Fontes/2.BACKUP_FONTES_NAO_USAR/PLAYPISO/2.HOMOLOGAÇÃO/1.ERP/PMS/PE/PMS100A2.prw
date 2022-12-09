#include "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PMS100A2  �Autor  �Alexandre Sousa     � Data �  09/20/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �P.E. na confirmacao da alteracao do cadastro de orcamento.  ���
���          �verifica a alteracao do status para perdido e solicita      ���
���          �o complemento da informacao.                                ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico LISONDA.                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PMS100A2()

	Private c_texto		:= Space(1)
	Private c_motivo	:= Space(6)
	Private mkwdlg		

	If AF1->AF1_FASE = '05' //NAO APROVADA

		//���������������������������������������������������������������������Ŀ
		//� Criacao da Interface                                                �
		//�����������������������������������������������������������������������
		@ 154,98 To 414,642 Dialog mkwdlg Title OemToAnsi("Informe os motivos do cancelamento do or�amento:")
		@ 10,14 Say OemToAnsi("Selecione o Motivo:") Size 50,8
		@ 23,14 Say OemToAnsi("Detalhes adicionais:") Size 51,8
		@ 33,14 Get c_texto MEMO Size 240,62
		@ 10,68 Get c_motivo F3 "SZ3" Size 41,10
		@ 105,218 BmpButton Type 1 Action Confirma()
		Activate Dialog mkwdlg
		
	EndIf

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Confirma  �Autor  �Microsiga           � Data �  09/20/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Confirmacao da tela de informacao do cancelamento.          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Confirma()
	
	If Empty(c_motivo) 
		msgAlert('Informe o motivo do cancelamento do or�amento!!!', "A T E N � � O")
		Return
	EndIf

	If Empty(c_texto)
		msgAlert('Informe os detalhes adicionais do cancelamento do or�amento!!!', "A T E N � � O")
		Return
	EndIf

	RecLock('AF1', .F.)
		AF1->AF1_XMTCAN := c_motivo
		AF1->AF1_XHIST	:= AF1->AF1_XHIST  + chr(10) + chr(13) + chr(10) + chr(13) +"==>>Contato em "+DtoC(dDataBase)+" por " + AllTrim(cusername) + ": " + c_texto
	MsUnLock()

	close(mkwdlg)
	
Return