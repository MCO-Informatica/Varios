#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 03/10/01

User Function LIFAT06()        
SetPrvt("ACRA,CDELFUNC,CROTVIS,CROTINC,CROTALT,CROTFEM")
SetPrvt("CROTEXC,AROTINA,CCADASTRO,ACOR200,LRETORNO,_LRETORNO")

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噮o    矻INCIFAT06| Autor ? Rodrigo Demetrios     ? Data ? 26/06/06 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o ? Monta tela de Saldos de Terceiros em nosso Poder           潮?
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
                     { OemToAnsi("Incluir")    ,"AxInclui"         ,0,3},;
                     { OemToAnsi("Alterar")    ,"AxAltera"         ,0,4},;
                     { OemToAnsi("Legenda")    ,"U_ISFA06Legenda"  ,0,5,0} }
                     

DbSelectArea("SB6")
mBrowse( 6, 1,22,75,"SB6",,,,,,U_ISFA06Legenda("SB6"))
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