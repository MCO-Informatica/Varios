#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Pedpap()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("NPOSCODIGO,CCODIGO,CPAPELETA,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���ExecBlock � PEDPAP   � Autor � ALEXANDRE MIGUEL      � Data � 23/11/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Pedido de Venda - Matriz(Cheio) para Outros(Filial)        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Exclusivo para Clientes Microsiga - Kenia                  ���
���          � Nao permite informar produto com codigo diferente          ���
���          � de inicio 1, quando a papeleta for OUTROS                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

nPosCodigo := ASCAN(aHEADER,{|x| Upper(AllTrim(x[2])) == "C6_PRODUTO" })
cCodigo := Acols[N,nPosCodigo]

cPapeleta:= M->C5_PAPELETA

If Len(Alltrim(cCodigo)) < 7 .And. cPapeleta == "O"
   MsgBox("Atencao Sr(a) "+Subs(cUsuario,7,14)+", o codigo do produto deve iniciar com 1","Validacao do Produto","Stop") 
   cCodigo := ""
EndIf

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return(cCodigo)
Return(cCodigo)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
