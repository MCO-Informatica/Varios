#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "rwmake.ch"

user function SHFIS001()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SFATA001  � Autor � Felipe Valenca     � Data �  30/03/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Regioes.                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/



//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "CFD"

dbSelectArea("CFD")
dbSetOrder(1)

AxCadastro(cString,"Consulta FCI",cVldExc,cVldAlt)

Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros

Return
