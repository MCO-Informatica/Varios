/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MT110GRV  � Autor � Thiago Comelli        � Data � 21/06/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada apos grava��o da SC.                      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � MP8                                                        ���
���          � Necessario Criar Campo                                     ���
���          � Nome			Tipo	Tamanho	Titulo			OBS           ���
���          � C1_CODAPROV   C         6    Cod Aprovador                 ���
���          �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT110GRV() //MT120APV()

Local aArea     := GetArea()
Local cRet := .T.

//GRAVA O NOME DA FUNCAO NA Z03
//U_CFGRD001(FunName())
//
//
//   RETIRADO EM 05/10/2018 - ESTA COM ERRO NO PROTHEUS12 - POS VIRADA.
//
//��������������������������������������������������������Ŀ
//�Envia Workflow para aprovacao da Solicitacao de Compras �
//����������������������������������������������������������
//If INCLUI .OR. ALTERA //Verifica se e Inclusao ou Alteracao da Solicitacao
//	MsgRun("Enviando Workflow para Aprovador da Solicita��o, Aguarde...","",{|| CursorWait(), U_COMRD003() ,CursorArrow()})
//EndIf
RestArea(aArea)

Return cRet