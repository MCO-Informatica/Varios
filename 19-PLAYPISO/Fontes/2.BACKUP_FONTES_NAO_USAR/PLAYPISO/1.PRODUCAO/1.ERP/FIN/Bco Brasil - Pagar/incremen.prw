#include "rwmake.ch"

User Function INCREMEN()

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("NTAMLIN,CARQ,NHDL,CBUFFER,NBYTES,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � INCREMENTA � Autor � Paulo H. R. Mata      � Data � 16/10/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Incremento de Numero de Registro para CNAB a RECEBER       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/       

Processa({|| AcrTxt()},"Incremento de Numero de Registro para CNAB a RECEBER","Aguarde...")

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � ACRTXT   � Autor � Paulo H. R. Mata      � Data � 16/10/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Incremento de Numero de Registro para CNAB a RECEBER       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/       

Static Function ACRTXT

//���������������������������������������������������Ŀ
//� Declara variaveis                                 �
//�����������������������������������������������������
//cArq     := "C:\AP7\AP_DATA\SIGAADV\"+Mv_Par04
cArq     := "C:\AP7\AP_DATA\SIGAADV\"+Mv_ARQ
_cFil01  := _cFil03 := _cFiller := ""
_nSoma   := 1
_nQtde   := 0

If !File(cArq)
   Alert("Arquivo Inexistente !!!")
   Return
Endif   

//�������������������������Ŀ
//� Cria arquivo Tempor�rio �
//���������������������������
aCampos := {}

//��������������������������������������������������������������Ŀ
//� Cria arquivo de trabalho                                     �
//����������������������������������������������������������������
AADD(aCampos,{"FILLER","C",240,0 } )

_cNomTrb := CriaTrab(aCampos)

dbSelectArea(0)
dbUseArea( .T.,,_cNomTRB,"TRB", if(.F. .OR. .F., !.F., NIL), .F. )
dbSelectArea("TRB")
Append From &cArq SDF

dbGoTop()
ProcRegua(RecCount())

While !Eof()
   IncProc()
   
   If SubStr(TRB->FILLER,8,1) == "3"
      _cFil01 := SubStr(TRB->FILLER,1,8)
      _cFil03 := SubStr(TRB->FILLER,14,226)

      RecLock("TRB",.f.)
      TRB->FILLER := _cFil01+StrZero(_nSoma,5)+_cFil03
      MsUnLock()
      _nSoma++
   Endif
   _nQtde++
      
   If SubStr(TRB->FILLER,8,1) != "5"
      dbSkip()
   Else
      _cFil01 := SubStr(TRB->FILLER,1,17)
      _cFil03 := SubStr(TRB->FILLER,24,216)
      RecLock("TRB",.f.)
      TRB->FILLER := _cFil01+StrZero(_nSoma+1,6)+_cFil03
      MsUnLock()
      _nQtde := _nQtde + 1
      dbSkip()
      If SubStr(TRB->FILLER,8,1) == "9"
         _cFil01 := SubStr(TRB->FILLER,1,23)
         _cFil03 := SubStr(TRB->FILLER,30,210)
         RecLock("TRB",.f.)
         TRB->FILLER := _cFil01+StrZero(_nQtde,6)+_cFil03
         MsUnLock()
      Endif
      Exit
   Endif
Enddo

Copy to &cArq SDF

dbSelectArea("TRB")
dbCloseArea()

Ferase(_cNomTrb+".DBF")
Ferase(_cNomTrb+".MEM")

Return