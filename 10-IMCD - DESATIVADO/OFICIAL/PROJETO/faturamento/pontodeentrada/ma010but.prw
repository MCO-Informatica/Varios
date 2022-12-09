#include 'protheus.ch'


//-------------------------------------------------------------------
/*/{Protheus.doc} MA010BUT
Inclus�o de Bot�es de usu�rio no Cadastro de Produtos
Ponto de Entrada para inclus�o de bot�es do usu�rio na barra de ferramentas
do cadastro de Produtos.
LOCALIZA��O: Este ponto est� localizado nas fun��es A010Visul (Visualiza��o 
do Produto), A010Inclui (Inclus�o do Produto), A010Altera (Altera��o do 
Produto) e A010Deleta (Dele��o do Produto).
EM QUE PONTO: No in�cio das fun��es citadas, antes de processar os dados de 
visualiza��o/edi��o do Produto; deve ser usado para adicionar bot�es do 
usu�rio na toolbar destas telas, atrav�s do retorno de um Array com a 
estrutura do bot�o a adicionar.
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
user function MA010BUT()
    Local aBotoes := {}

	aadd(aBotoes,{'BMPCPO'  ,{|| U_SFLOGSHW("SB1")},"Log Integ. SF"})

Return(aBotoes)
