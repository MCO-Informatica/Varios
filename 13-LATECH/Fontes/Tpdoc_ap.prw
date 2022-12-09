#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Tpdoc()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CTPDOC,AARRAY,NASCAN,CDOC,_CDOC,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���ExecBlock � TPDOC    � Autor � MARCOS GOMES          � Data � 02.02.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cnab a Receber BANCO DO BRASIL/BRADESCO                    ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Exclusivo para Clientes Microsiga - Kenia                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

// Devido a falta de espaco no configurador para acomodar a expressao abaixo, 
// foi utilizado o ExecBlock abaixo. 

_cTPDOC := SE1->E1_TIPO
//aArray := {}
//AADD( aArray, {"DP "})    // 1.DUPLICATA
//AADD( aArray, {"NP "})    // 2.NOTA PROMISSORIA
//AADD( aArray, {"   "})    // 3.NOTA DE SEGURO
//AADD( aArray, {"   "})    // 4.COBRANCA SERIADA
//AADD( aArray, {"REC"})    // 5.RECIBOS

//nAscan := Ascan( aArray, cTPDOC )

//If Empty(nAscan)
//		 cDOC  := StrZero( Ascan( aArray, cTPDOC ), 2 )
//	 ElseIf Empty(nAscan)
//		 cDOC  := "99"
//	 ElseIf nTPDOC == "NF "
//		 cDOC  := "01"
//EndIf

Do Case
   Case _cTPDOC == "DP "
	  _cDoc := "01"
   Case _cTPDOC == "NF "
	  _cDoc := "01"
   Case _cTPDOC == "NP "
	  _cDoc := "02"
   Case _cTPDOC == "REC"
	  _cDoc := "05"
   OtherWise
	  _cDoc := "01"
EndCase

__RetProc( _cDOC )


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

