#INCLUDE "RWMAKE.CH"

User Function PAGAGDEST()

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_RETAG,")

////  PROGRAMA PARA SELECIONAR A AGENCIA DO NUMERO CNAB QUANDO NAO
////  NAO TIVER TEM QUE SER COLOCADO "0000000"

If SEA->EA_MODELO = "06"
   _RETAG := "0000000"
Else
//   _RETAG := "000"+(SA2->A2_AGENCIA)
	 _RETAG := StrZero(Val(SA2->A2_AGENCIA), 7) //Alterado por Nelson Junior - ARMI - 14/01/2015
EndIf

Return(_RETAG)