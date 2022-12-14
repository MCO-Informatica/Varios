#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 03/10/01

User Function LIFAT07()        
SetPrvt("ACRA,CDELFUNC,CROTVIS,CROTINC,CROTALT,CROTFEM")
SetPrvt("CROTEXC,AROTINA,CCADASTRO,ACOR200,LRETORNO,_LRETORNO")

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噮o    矻INCIFAT07| Autor ? Rodrigo Demetrios     ? Data ? 26/06/06 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o ? Monta tela de Consulta de Pedidos Entregues ou Nao         潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros?                                                            潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砋so       ? Especifico da LINCIPLAS                                    潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
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
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噮o    矯a050Legenda? Autor ? Wagner Mobile Costa ? Data ? 20.09.01 潮?
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o ? Cria uma janela contendo a legenda da mBrowse ou retorna a 潮?
北?          ? para o BROWSE                                              潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso      ? CdaA050                                                    潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
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