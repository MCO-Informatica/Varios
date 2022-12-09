#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function K0001()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Cliente   � Kenia Industrias Texteis Ltda.                             ���
��������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������Ŀ��
���Programa:#� K0001.prw                                                  ���
�������������������������������������������������������������������������Ĵ��
���Descricao:� Programa para efetuar inventario automatico.               ���
�������������������������������������������������������������������������Ĵ��
���Data:     � 01/09/00    � Implantacao: � 04/09/00                      ���
�������������������������������������������������������������������������Ĵ��
���Programad:� Sergio Oliveira                                            ���
��������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������Ŀ��
���Objetivos:� Este programa          grava cada registro do SB8 no arqui-���
���          � vo de lancamentos de inventario.                           ���
��������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������Ŀ��
���Observacao� Os lancamentos de inventario com a mesma data tem efeito   ���
���          � cumulativo.                                                ���
��������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������Ŀ��
���Arquivos :� SB1, SB8 e SD7.                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

MSGBOX("Esta rotina devera ser executada com o maximo de atencao","ATENCAO","ALERT")

If SM0->M0_CODIGO != "01"
   
   MsgBox("Somente na Empresa Oficial","ATENCAO","ALERT")
   __RetProc()

EndIf

   Processa( {|| ATUB7() }, "Inventariando automaticamente...")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>    Processa( {|| Execute(ATUB7) }, "Inventariando automaticamente...")
   __RetProc()


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>    FUNCTION ATUB7
Static FUNCTION ATUB7()

   DbSelectArea("SB1")
   DbSetOrder(1)

   DbSelectArea("SB7")
   DbSetOrder(1)
/*
  �������������������������������������������������������������������������Ŀ  
  � Localizar  todos os lotes.                                              �  
  ���������������������������������������������������������������������������  
*/
   DbSelectArea("SB8")
   DbGoTop()
   ProcRegua(LastRec())
   While !Eof() .and. SB8->B8_FILIAL == xFilial()
/*
  �������������������������������������������������������������������������Ŀ  
  �     Os lotes de n� 003 pra baixo nao entram no inventario.              �  
  ���������������������������������������������������������������������������  
*/
	 IncProc("Aguarde, Selecionando os Lotes")
	 
	 If SB8->B8_LOTECTL == "0000000003" .or. SB8->B8_LOTECTL == "0000000002" .or.;
	    SB8->B8_LOTECTL == "0000000001" .or. SB8->B8_ORIGLAN != "MN"

	    DbSelectArea("SB8")
	    DbSkip()
	    Loop
	 EndIf
/*
  �������������������������������������������������������������������������Ŀ  
  �     Continuando normalmente para os D+ e retirar a rastreabilidade.     �  
  ���������������������������������������������������������������������������  
*/
	 DbSelectArea("SB1")
	 DbSeek(xFilial()+SB8->B8_PRODUTO,.F.)

	 RecLock("SB1",.F.)
	 SB1->B1_RASTRO := "N"
	 MsUnLock()
/*
  �������������������������������������������������������������������������Ŀ  
  � Agora e so        lancar os registros no arquivo de lancamentos de inv. �  
  ���������������������������������������������������������������������������  
*/ 
	 DbSelectArea("SB7")
	 RecLock("SB7",.T.)
	 SB7->B7_FILIAL  := xFilial()
	 SB7->B7_COD	 := SB8->B8_PRODUTO
	 SB7->B7_LOCAL	 := SB8->B8_LOCAL
	 SB7->B7_TIPO	 := SB1->B1_TIPO
	 SB7->B7_DOC	 := SUBSTR(SB8->B8_LOTECTL,6)
	 SB7->B7_QUANT	 := SB8->B8_SALDO
	 SB7->B7_DATA	 := CTOD("02/09/00")
	 MsUnLock()

	 DbSelectArea("SB8")
	 DbSkip()

   End

__RetProc()


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

