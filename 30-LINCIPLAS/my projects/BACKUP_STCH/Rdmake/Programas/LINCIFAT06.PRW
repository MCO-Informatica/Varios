#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 03/10/01

User Function LIFAT06()        
SetPrvt("ACRA,CDELFUNC,CROTVIS,CROTINC,CROTALT,CROTFEM")
SetPrvt("CROTEXC,AROTINA,CCADASTRO,ACOR200,LRETORNO,_LRETORNO")

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �LINCIFAT06| Autor � Rodrigo Demetrios     � Data � 26/06/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Monta tela de Saldos de Terceiros em nosso Poder           ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico da LINCIPLAS                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


PRIVATE cCadastro := OemToAnsi("Consulta Pedidos de Vendas") 
PRIVATE aRotina := { { OemToAnsi("Pesquisar")  ,"AxPesqui"         ,0,1},;		//"Pesquisar"
                     { OemToAnsi("Visual")     ,"AxVisual"         ,0,2},;		//"Visual"
                     { OemToAnsi("Incluir")    ,"AxInclui"         ,0,3},;
                     { OemToAnsi("Alterar")    ,"AxAltera"         ,0,4},;
                     { OemToAnsi("Legenda")    ,"U_ISFA06Legenda"  ,0,5,0} }
                     

DbSelectArea("SB6")
mBrowse( 6, 1,22,75,"SB6",,,,,,U_ISFA06Legenda("SB6"))
Return


/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Ca050Legenda� Autor � Wagner Mobile Costa � Data � 20.09.01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cria uma janela contendo a legenda da mBrowse ou retorna a ���
���          � para o BROWSE                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CdaA050                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function ISFA06Legenda(cAlias, nReg)

Local aLegenda := 	{ 	{"BR_VERDE"   , "NOTA COM SALDO"  },; 
						{"BR_VERMELHO", "NOTA SEM SALDO" }} 
Local uRetorno := .T.

If nReg = Nil	// Chamada direta da funcao onde nao passa, via menu Recno eh passado
	uRetorno := {}
	Aadd(uRetorno, { 'SB6->B6_ATEND  = " " '  , aLegenda[1][1] } )
	Aadd(uRetorno, { 'SB6->B6_ATEND  <>" " '  , aLegenda[2][1] } ) 
Else
	BrwLegenda("Situacao Poder de Terceiros", "Legenda", aLegenda) //"Legenda"
Endif

Return uRetorno