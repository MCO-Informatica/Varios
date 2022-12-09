#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function T_lote()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CLOTE,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � T_LOTE	� Autor � Luciano Lorenzetti	� Data � 05/09/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Tela para a digitacao do lote.							  ���
�������������������������������������������������������������������������Ĵ��
��� Uso 	 � KENIA													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/

If SM0->M0_CODIGO <> "80"
   Return
EndIF

//���������������������������������������������������������������������������Ŀ
//� Desenha a tela de apresentacao da rotina								  �
//�����������������������������������������������������������������������������
_cLote := Space(13)

@ 96,042 TO 333,510 DIALOG oDlg1 TITLE "Lote:"
@ 08,010 TO 084,222
@ 91,168 BMPBUTTON TYPE 1 ACTION CONFIRMA()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> @ 91,168 BMPBUTTON TYPE 1 ACTION Execute(CONFIRMA)
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
@ 39,100 GET _cLote Picture "@!" Object CodLote      // Valid !(Empty(_cProdEXC)) F3("SB1") Object CodEXC  //  Valid Valid_B1()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> @ 39,100 GET _cLote Picture "@!" Object CodLote      // Valid !(Empty(_cProdEXC)) F3("SB1") Object CodEXC  //  Valid Execute(Valid_B1)
@ 69,014 SAY "***  KENIA Ind. Texteis Ltda. ***"
ACTIVATE DIALOG oDlg1 Center

_cLote := Substr(_cLote,4,10)

Close(oDlg1)

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return(_cLote)
Return(_cLote)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � TROCA	� Autor � Luciano Lorenzetti	� Data � 19.06.00 ���
�������������������������������������������������������������������������Ĵ��
���    Essa rotina verifica e executa a troca dos codigos.				  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> FUNCTION CONFIRMA
Static FUNCTION CONFIRMA()


Return


