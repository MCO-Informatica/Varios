#include 'protheus.ch'


//-------------------------------------------------------------------
/*/{Protheus.doc} MA010BUT
Inclusão de Botões de usuário no Cadastro de Produtos
Ponto de Entrada para inclusão de botões do usuário na barra de ferramentas
do cadastro de Produtos.
LOCALIZAÇÃO: Este ponto está localizado nas funções A010Visul (Visualização 
do Produto), A010Inclui (Inclusão do Produto), A010Altera (Alteração do 
Produto) e A010Deleta (Deleção do Produto).
EM QUE PONTO: No início das funções citadas, antes de processar os dados de 
visualização/edição do Produto; deve ser usado para adicionar botões do 
usuário na toolbar destas telas, através do retorno de um Array com a 
estrutura do botão a adicionar.
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
user function MA010BUT()
    Local aBotoes := {}

	aadd(aBotoes,{'BMPCPO'  ,{|| U_SFLOGSHW("SB1")},"Log Integ. SF"})

Return(aBotoes)
