#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 21/10/05

User Function atprprod()        // incluido pelo assistente de conversao do AP6 IDE em 21/10/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CALIAS,_NORDER,_NRECNO,CPERG,CODPED,CODTES")
SetPrvt("CODCF,_SALIAS,AREGS,I,J,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � ALTENTR  �Autor  �Paulo C T de Oliveira  � Data � 22/05/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Alteracao do Tipo Entrega da N.Fiscal                      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Faturamento                                                ���
�������������������������������������������������������������������������Ĵ��
���Arquivos  � SF2                                                        ���
���Utilizados�                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
_cAlias:=Alias()
_nOrder:=IndexOrd()
_nRecno:=Recno()
cPerg    := 'ALTENT    '
//�����������������������������������������������Ŀ
//� Verifica Perguntas Utilizadas para Parametros �
//� CodPed    := mv_par01                         �
//� CodTes    := mv_par02                         �
//� CodCf     := mv_par03                         �
//�������������������������������������������������
ValidPerg()

pergunte("ALTENT", .T.)

if MV_PAR03 == 2
   Return
endif

dbSelectArea("SF2")  // NOTA FISCAL DE VENDA  
dbSetOrder(1)
dbSeek(xfilial("SF2") + MV_PAR01)
*While ! Reclock("SF2",.T.)
*   Tone(4000,2)
*   Aviso("Atencao","Registro Bloqueado na Estacao "+ AllTrim(Str(AX_UserLockID())),{"Tenta Novamente ?"})
*End
While SF2->F2_DOC == MV_PAR01
   Reclock("SF2",.F.)
   Replace F2_ENTR With MV_PAR02
   MsUnlock()
   DbSkip()
End

dbSelectArea("SF2")  // CABECALHO DE NOTA FISCAL DE VENDA
dbSetOrder(1)

dbSelectArea(_cAlias)
dbSetOrder(_nOrder)
dbGoto(_nRecno)

// Substituido pelo assistente de conversao do AP6 IDE em 21/10/05 ==> __Return(nIL)
Return(nIL)        // incluido pelo assistente de conversao do AP6 IDE em 21/10/05


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �VALIDPERG � Autor �  Luiz Carlos Vieira   � Data � 03/07/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica as perguntas incluindo-as caso nao existam        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico - Figrot.prx                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 21/10/05 ==> Function ValidPerg
Static Function ValidPerg()

_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs:={}
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Numero N.F de Venda?","mv_cha","C",6,0,0,"G","","mv_par01","","025626","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Nota Entrega (S/N) ?","mv_chb","C",01,0,0,"G","","mv_par02","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Efetua a Troca     ?","mv_chc","N",01,0,1,"C","","mv_par03","Sim","","","Nao","","","","","","","","","",""})
For i:=1 to Len(aRegs)
   If !dbSeek(cPerg+aRegs[i,2])
      RecLock("SX1",.T.)
      For j:=1 to FCount()
         FieldPut(j,aRegs[i,j])
      Next
      MsUnlock()
   Endif
Next

dbSelectArea(_sAlias)

Return
