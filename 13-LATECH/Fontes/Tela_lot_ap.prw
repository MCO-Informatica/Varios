#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Tela_lot()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CALIAS,_NRECNO,_NORDEM,_CPRODEXC,_CPRODINC,_NCONTA")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � K_ESTRUT � Autor � Luciano Lorenzetti	� Data � 19/06/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Troca codigo de produto da estrutura.					  ���
�������������������������������������������������������������������������Ĵ��
��� Uso 	 � KENIA													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/


//���������������������������������������������������������������������������Ŀ
//� Guarda Ambiente 														  �
//�����������������������������������������������������������������������������
_cAlias := ALIAS()
_nRecno := RECNO()
_nOrdem := INDEXORD()


//���������������������������������������������������������������������������Ŀ
//� Desenha a tela de apresentacao da rotina								  �
//�����������������������������������������������������������������������������
_cProdEXC := Space(15)
_cProdINC := Space(15)
@ 96,042 TO 333,510 DIALOG oDlg1 TITLE "Troca de produto :"
@ 08,010 TO 084,222
@ 91,168 BMPBUTTON TYPE 1 ACTION TROCA()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> @ 91,168 BMPBUTTON TYPE 1 ACTION Execute(TROCA)
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
@ 24,014 SAY "Esta rotina tem como objetivo executar a troca de produtos no cadastro de estrutura."
@ 39,014 SAY "Digite o produto a ser excluido : "
@ 39,100 GET _cProdEXC Picture "@!" Valid !(Empty(_cProdEXC)) F3("SB1") Object CodEXC  //  Valid Valid_B1()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> @ 39,100 GET _cProdEXC Picture "@!" Valid !(Empty(_cProdEXC)) F3("SB1") Object CodEXC  //  Valid Execute(Valid_B1)
@ 54,014 SAY "Digite o produto a ser incluido : "
@ 54,100 GET _cProdINC Picture "@!" Valid !(Empty(_cProdINC)) F3("SB1") Object CodINC  //  Valid Valid_B1()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> @ 54,100 GET _cProdINC Picture "@!" Valid !(Empty(_cProdINC)) F3("SB1") Object CodINC  //  Valid Execute(Valid_B1)
@ 69,014 SAY "***  KENIA Ind. Texteis Ltda. ***"
ACTIVATE DIALOG oDlg1 Center

//���������������������������������������������������������������������������Ŀ
//� Retorna Ambiente														  �
//�����������������������������������������������������������������������������
dbSelectArea(_cAlias)
dbSetOrder(_nOrdem)
dbGoto(_nRecno)

RETURN


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
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> FUNCTION TROCA
Static FUNCTION TROCA()

dbSelectArea("SG1")
dbSetOrder(1)
If dbSeek(xFilial("SG1")+_cProdEXC)
   MSGBOX(" O produto a ser excluido nao e' uma materia prima, pois possui estrutura !")
   Return
EndIf
If dbSeek(xFilial("SG1")+_cProdINC)
   MSGBOX(" O produto a ser incluido nao e' uma materia prima, pois possui estrutura !")
   Return
EndIf


dbSelectArea("SG1")
dbSetOrder(2)
If dbSeek(xFilial("SG1")+_cProdEXC)
   MSGBOX(" O produto a ser excluido nao faz parte da estrutura de nenhum produto!")
   Return
EndIf


Processa({|| PROC_SG1()})// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({|| Execute(PROC_SG1)})

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � Proc_SG1 � Autor � Luciano Lorenzetti	� Data � 19.06.00 ���
�������������������������������������������������������������������������Ĵ��
���    Essa rotina verifica e executa a troca dos codigos.				  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> FUNCTION PROC_SG1
Static FUNCTION PROC_SG1()

_nConta := 0
dbSelectArea("SG1")
dbSetOrder(2)
dbGoTop()
ProcRegua(RECCOUNT())
While !EOF()
   IncProc(OEMtoAnsi("Verificando estruturas "))
   //��������������������������������������������������������������Ŀ
   //� Movimenta Regua Processamento								�
   //����������������������������������������������������������������
   If SG1->G1_COMP == _cProdEXC
	  _nConta := _nConta + 1
//		RecLock("SG1",.F.)
//		SG1->G1_COMP := _cProdINC
//		MsUnLock()
   Else
	  If Eof()
		 MSGBOX(STR(_nConta))
		 Exit
		 Close(oDlg1)
	  EndIf
   EndIf
   dbSkip()
EndDo

RETURN


