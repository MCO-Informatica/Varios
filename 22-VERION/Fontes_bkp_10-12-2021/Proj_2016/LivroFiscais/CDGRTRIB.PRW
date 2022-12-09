#include "rwmake.ch"        
#include "topconn.ch"       
/*------------------------------------------------------------------------
Programa: CDGRTRIB 										Data: 23/10/13
--------------------------------------------------------------------------
Objetivo: Tela de manutencao da tabela 21 do SX5
--------------------------------------------------------------------------
Uso: Fiscal
------------------------------------------------------------------------*/
User Function CDGRTRIB()

cCadastro   := "Grupo Tributario"
aAutoCab    := {}
aAutoItens  := {}
PRIVATE aRotina := { { "Pesquisar" , "AxPesqui"  , 0 , 1},;  
       				 { "Visualizar", "C160Visual", 0 , 2},;  
					 { "Incluir"   , "C160Inclui", 0 , 3},;  
					 { "Alterar"   , "C160Altera", 0 , 4},;  
					 { "Excluir"   , "C160Deleta", 0 , 5} }  

DbSelectArea("SX5")           
DbSetOrder(1)
If !DbSeek(xFilial("SX5")+"21",.F.)
   MsgAlert("Nao foi possivel localizar a tabela 21 no cadastro de tabelas (SX5) !")
Else   
   c160altera("SX5",,3)
Endif       

Return()         