#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 03/10/01

User Function LIFAT07()        
SetPrvt("ACRA,CDELFUNC,CROTVIS,CROTINC,CROTALT,CROTFEM")
SetPrvt("CROTEXC,AROTINA,CCADASTRO,ACOR200,LRETORNO,_LRETORNO")

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �LINCIFAT07| Autor � Rodrigo Demetrios     � Data � 26/06/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Monta tela de Consulta de Pedidos Entregues ou Nao         ���
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
                     { OemToAnsi("Legenda")    ,"U_ISFI04Legenda"  ,0,3,0} }
                     

DbSelectArea("SC6")
//mBrowse( 6, 1,22,75,"SE2",,"!E2_MULTNAT='2'")  
mBrowse( 6, 1,22,75,"SC6",,,,,,U_ISFI07Legenda("SC6"))
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
User Function ISFI07Legenda(cAlias, nReg)

Local aLegenda := 	{ 	{"BR_VERDE"   , "ITEM DO PEDIDO NAO ENTREGUE"  },; 
						{"BR_VERMELHO", "ITEM DO PEDIDO ENTREGUE" }} 
Local uRetorno := .T.

If nReg = Nil	// Chamada direta da funcao onde nao passa, via menu Recno eh passado
	uRetorno := {}
	Aadd(uRetorno, { 'SC6->C6_NOTA  = "      " '  , aLegenda[1][1] } )
	Aadd(uRetorno, { 'SC6->C6_NOTA  <> "     " '  , aLegenda[2][1] } ) 
Else
	BrwLegenda("Situacao do Pedido de Vendas", "Legenda", aLegenda) //"Legenda"
Endif

Return uRetorno