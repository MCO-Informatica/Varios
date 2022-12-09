#INCLUDE "rwmake.ch"          
#INCLUDE "PROTHEUS.CH" 

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FOLA002  � Autor � Ricardo Felipelli  � Data �  10/03/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro Filiais MicroSiga X Socin                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � mp8 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FOLA002

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cPerg   := Padr("SZG010",len(SX1->X1_GRUPO)," ")
cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZG"

dbSelectArea("SZG")
dbSetOrder(1)


Pergunte(cPerg,.F.)
SetKey(123,{|| Pergunte(cPerg,.T.)}) // Seta a tecla F12 para acionamento dos parametros

AxCadastro(cString,"Cadastro Filiais MicroSiga X Socin - FOLA002",cVldExc,cVldAlt)

Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros


Return
