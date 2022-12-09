#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function kfin26m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_cPrefixo")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � KFIN26M  � Autor �Ricardo Correa de Souza� Data �11/01/2001���
�������������������������������������������������������������������������Ĵ��
���Descricao � Retorna o Prefixo Cobranca Cnab                            ���
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

If SE1->E1_PREFIXO$"12 "
	_cPrefixo	:=	"X  "+SE1->E1_NUM+SE1->E1_PARCELA
ElseIf SE1->E1_PREFIXO$"UNI"
	_cPrefixo	:=	"   "+SE1->E1_NUM+SE1->E1_PARCELA
Else
	_cPrefixo	:=	SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA
EndIf

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return(_cCepCob)
Return(_cPrefixo)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05