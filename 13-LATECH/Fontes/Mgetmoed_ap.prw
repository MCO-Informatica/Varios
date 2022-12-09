#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

User Function MGETMOED()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MGETMOED � Autor �Ricardo Correa de Souza� Data �13/09/2001���
�������������������������������������������������������������������������Ĵ��
���Descricao � No Primeiro Acesso do Dia Executa a Rotina do Risco Cliente���
�������������������������������������������������������������������������Ĵ��
���Uso       � Kenia Industrias Texteis Ltda                              ���
�������������������������������������������������������������������������Ĵ��
���            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ���
�������������������������������������������������������������������������Ĵ��
���   Analista   �  Data  �             Motivo da Alteracao               ���
�������������������������������������������������������������������������Ĵ��
���              �        �                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

If date() == dDataBase
    If MsgBox("Atencao Sr(a) "+Alltrim(Subs(cUsuario,7,14))+", � necess�rio atualizar o Risco de Cr�dito dos Clientes. Para isso voc� deve confirmar o processamento. Deseja processar agora ???","Atualiza��o do Risco de Cr�dito","YesNo")
        ExecBlock("KFIN21M",.F.,.F.)
    EndIf
EndIf
  
cQuery := " UPDATE "+ RetSQLName("SE1")+" SET E1_LA = 'N' WHERE E1_LA <> 'N' "
TCSQLExec(cQuery)

cQuery := " UPDATE "+ RetSQLName("SE2")+" SET E2_LA = 'N' WHERE E2_LA <> 'N' "
TCSQLExec(cQuery)

cQuery := " UPDATE "+ RetSQLName("SE5")+" SET E5_LA = 'N' WHERE E5_LA <> 'N' "
TCSQLExec(cQuery)

Return
