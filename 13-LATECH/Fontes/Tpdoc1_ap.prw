#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Tpdoc1()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CTPDOC,AARRAY,NASCAN,CDOC,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���ExecBlock � TPDOC1   � Autor � MARCOS GOMES          � Data � 02.02.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cnab a Receber BANCO DO BRASIL                             ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Exclusivo para Clientes Microsiga - Kenia                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

// Devido a falta de espaco no configurador para acomodar a expressao abaixo, 
// foi utilizado o ExecBlock abaixo. 

cTPDOC := SE1->E1_TIPO
aArray := {}
AADD( aArray, {"DP "})    // 1.DUPLICATA
AADD( aArray, {"NP "})    // 2.NOTA PROMISSORIA
AADD( aArray, {"   "})    // 3.NOTA DE SEGURO
AADD( aArray, {"   "})    // 4.COBRANCA SERIADA
AADD( aArray, {"REC"})    // 5.RECIBOS
AADD( aArray, {"   "})    // 6.NOTA DE SEGURO
AADD( aArray, {"   "})    // 7.COBRANCA SERIADA
AADD( aArray, {"   "})    // 8.NOTA DE SEGURO

nAscan := Ascan( aArray, cTPDOC )

If cTPDOC $"NF /DP /NDC" 
        cDOC  := "01" 
   Else
        cDOC := StrZero( Ascan( aArray, cTPDOC ), 2 )
EndIf

__RetProc( cDOC )

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

