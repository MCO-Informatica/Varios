#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#include "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � EMP650 � Autor � Ricardo Correa de Souza� Data �19/09/2008 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Exclui o Empenho de Ordens de Producao Previstas           ���
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
User Function MA650EMP()

Local _aArea      := GetArea()

ALERT("MA650EMP")

//----> VARRE TODA A TELA DE EMPENHO PARA VERIFICAR SE TEMOS TECIDO CRU EMPENHADO
If Len(aCols) > 0
	For ny:=1 to Len(aCols)
		If Posicione("SB1",1,xFilial("SB1")+aCols[ny,ASCAN(aHEADER,{|x|upper(alltrim(x[2]))=="G1_COMP"})],"B1_TIPO") $"KCTC"
			Alert(Posicione("SB1",1,xFilial("SB1")+aCols[ny,ASCAN(aHEADER,{|x|upper(alltrim(x[2]))=="G1_COMP"})],"B1_TIPO"))
		Else
			Alert("NAO TEM CRU")
		EndIf
	Next ny
EndIf

RestArea(_aArea)
Return()

