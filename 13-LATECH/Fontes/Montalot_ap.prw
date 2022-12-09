#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Montalot()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_AAREA,_CLOTECTL,")

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Cliente   � Kenia Industrias Texteis Ltda.                             ���
��������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������Ŀ��
���Programa:#� MONTALOT.PRW                                               ���
�������������������������������������������������������������������������Ĵ��
���Descricao:� Execblock que gera a numeracap de lotes de producao.       ���
�������������������������������������������������������������������������Ĵ��
���Data:     � 03/08/00    � Implantacao: � 11/08/00                      ���
�������������������������������������������������������������������������Ĵ��
���Programad:� Sergio Oliveira                                            ���
��������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������Ŀ��
���Objetivos:� Este programa gera a numeracao automatica dos lotes de pro-���
���          � ducao. Ex.: 0000000001, 00000000002...                     ���
��������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������Ŀ��
���Arquivos :� SM4.                                                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


dbSelectArea("SD3")
_aAreaSD3 	:= GetArea()
_cProduto 	:= M->D3_COD 
_cLocal		:= M->D3_LOCAL
_cLotectl	:= SUBS(M->D3_OP,1,6)
_cSeq		:= "0001"

dbSetOrder(19)
If dbSeek(xFilial("SD3")+_cProduto+_cLocal+_cLotectl,.f.)

	While !Eof() .And. SD3->(D3_COD+D3_LOCAL+SUBS(D3_OP,1,6)) == _cProduto+_cLocal+_cLotectl
	     
		_cSeq	:=	Subs(SD3->D3_LOTECTL,7,4)
		
		dbSelectArea("SD3")
		dbSkip()
	EndDo
	
	_cSeq	:=	StrZero(Val(_cSeq)+1,4)
Else
	_cSeq	:=	"0001"
EndIf

RestArea(_aAreaSD3)

Return(_cLoteCtl+_cSeq)
