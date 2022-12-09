#include "rwmake.ch"
#include "protheus.ch"
#INCLUDE "COLORS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao	 � CODBCO	� Autor � Thiago Queiroz        � Data � 24/11/11 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Programa para alterar o parametro MV_CODBCO                ���
���			 � Utilizado para definir em qual banco sera                  ���
���          � o faturamento dos PVs e a impress�o dos Boletos            ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Linciplas                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

USER FUNCTION CODBCO()

Local oCombo
Local cAutent	:= SPACE(15)
Local aArea		:= GetArea()
Local cNomeBco	:= SuperGetMV("MV_CODBCO", ," ")
Local cCodBco	:= "                "
Local aCodBco	:= {"237 - BRADESCO", "341 - ITAU"}

@ 200,001 TO 500,500 DIALOG oDlg TITLE OemToAnsi("Informe o codigo do banco")
@ 001,001 TO 010,026
@ 001,002 Say " Informe em qual banco ser� realizado o Faturamento			"
@ 002,002 Say " dos Pedidos de Venda e impress�o dos Boletos				"
@ 003,002 Say " ----------------------------------------------------------	"
@ 004,002 Say cNomeBco
@ 004,012 Say "Codigo do banco atual"
@ 065,015 ComboBox cCodBco Items aCodBco Size 085,09 Of oDlg Pixel OF oDlg //ON CHANGE oCombo:Refresh()
@ 100,128 BMPBUTTON TYPE 01 ACTION Close(oDlg)
//@ 100,158 BMPBUTTON TYPE 02 ACTION Close(oDlg)

Activate Dialog oDlg Centered

//MSGBOX(cCodBco +" - "+ substr(cCodBco,1,3) )
PutMv("MV_CODBCO",substr(cCodBco,1,3))

RestArea(aArea)

RETURN