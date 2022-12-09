#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Conslot()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_NSALDO,_AAREA,NPOSCODIGO,NPOSQTDLIB,NPOSLOTCTL,_CINDSB8")
SetPrvt("_CREGSB8,ACOLS,")

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Cliente   � Kenia Industrias Texteis Ltda.                             ���
��������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������Ŀ��
���Programa:#� CONSLOT.prw                                                ���
�������������������������������������������������������������������������Ĵ��
���Descricao:� Gatilho para verificar lote.                               ���
�������������������������������������������������������������������������Ĵ��
���Data:     � 08/09/00    � Implantacao: � 08/09/00                      ���
�������������������������������������������������������������������������Ĵ��
���Programad:� Sergio Oliveira                                            ���
��������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������Ŀ��
���Objetivos:�     Este excblock recebe como parametro o numero do lote   ���
���          � obtido na leitura do codigo de barras e verifica se a eti- ���
���          � queta confere com o produto indicado. Caso nao confira, se-���
���          � ra acionado um alerta ao usuario.                          ���
��������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������Ŀ��
���Arquivos :�                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

_nSaldo  := 0
_aArea   := GetArea()

nPosCodigo := ASCAN(aHEADER,{|x| Upper(AllTrim(x[2])) == "C6_PRODUTO" })
nPosQtdLib := ASCAN(aHEADER,{|x| Upper(AllTrim(x[2])) == "C6_QTDLIB" })
nPosLotCtl := ASCAN(aHEADER,{|x| Upper(AllTrim(x[2])) == "C6_LOTECTL" })

DbSelectArea("SB8")
_cIndSB8 := IndexOrd()
_cRegSB8 := Recno()
   
DbSelectArea("SB8")
DbSetOrder(3)                  
Set SoftSeek Off   
If !DbSeek(xFilial()+Acols[N,nPosCodigo]+"01"+Acols[N,nPosLotCtl])
   
   MsgBox("Lote x Produto nao confere. Verifique.","Atencao","ALERT")
   
Else

   Set SoftSeek on
   While !Eof() .and. SB8->B8_LOCAL   == "01" .and.;
                      SB8->B8_PRODUTO == Acols[N,nPosCodigo] .and.;
                      SB8->B8_LOTECTL == Acols[N,nPosLotCtl]

          _nSaldo := _nSaldo + SB8->B8_SALDO

          DbSkip()

   End
   
EndIf

If _nSaldo == 0
   MsgBox("Este lote nao contem saldo no sistema. Verifique.","Atencao","ALERT")
Else
   Acols[n,nPosQtdLib] := _nSaldo       
EndIf

DbselectArea("SB8")
DbSetOrder(_cIndSB8)
DbGoTo(_cRegSB8)

RestArea(_aArea)

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

