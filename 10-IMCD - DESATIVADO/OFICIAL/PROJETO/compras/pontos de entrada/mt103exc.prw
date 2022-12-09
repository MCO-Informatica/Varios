#include "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT103EXC �Autor  � Junior Carvalho    � Data �  31/01/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � BLOQUEAR EXCLUSAO DE DOC. DE ENTRADA QUE GERARAM CUSTOS    ���
���          � PELA MOVIMENTACAO INTERNA                                  ���
�������������������������������������������������������������������������͹��
���Uso       � IMCD                                                       ���
�������������������������������������������������������������������������͹��
���REV� Programador   � Data     � Motivo da Alteracao                    ���
�������������������������������������������������������������������������͹��
��� 01|Junior Carvalho�10/05/2016� Nova valida��o para bloquear exclusao  ���
���   |               �          � dos Doc. gerados Pelo EIC              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT103EXC()
	lRet := .T.
	if !(isincallstack("EICDI158"))
		if !(isincallstack("EICDI154"))

			If !EMPTY(ALLTRIM(SD1->D1_XINTSD3))

				cMsg1:= "Nao � permitida exclus�o do documento."
				cMsg2:= "Esse Documento gerou custo de Importa��o."
				cMsg3:= "Solcicite o Desbloqueio ao Departamento de Custos."

				Aviso( "MT103EXC", cMsg1+CRLF+cMsg2+CRLF+cMsg3, { "Ok" }, 2 )

				lRet := .F.
			EndIf
			//REV 01 - Junior Carvalho - 10/05/2016
			If (!EMPTY(ALLTRIM(SD1->D1_CONHEC)) .AND. !(SD1->D1_TES $ '056|001' ) ) .AND. !(isincallstack("MATA140"))

				cMsg1:= "N�o � permitida exclus�o do documento Gerado Pelo Modulo de Importa��o SIGAEIC."
				cMsg2:= "Exclus�o somente pelo Modulo de Importa��o(SIGAEIC)."

				Aviso( "MT103EXC", cMsg1+CRLF+cMsg2, { "Ok" }, 2 )

				lRet := .F.
			EndIf
		EndIf
	EndIf
//REV 01 - Junior Carvalho - 10/05/2016

Return lRet
