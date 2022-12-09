#INCLUDE 'rwmake.ch'

/*/{Protheus.doc} LJ7007
Ponto de entrada para acrescentar botões na forma de pagamento.
@type function
@version 12.1.33
@author Vladimir
@since 05/10/2022
@return variant, retorna botões criados
/*/

User Function LJ7007() 
Local aRet := {}

// Chama a função para usar a condição de pagamento 'PX e DN
// Atualiza a variavel da tela
// Atualiza a descrição da variavel.
aAdd( aRet, 'PIX TOTAL')  //-- Descrição do botão.
aAdd( aRet, 'LJ7CondPg(2, "PX"), M->LQ_CONDPG := "PX", cDescCondPg := Posicione("SE4",1,xFilial("SE4")+M->LQ_CONDPG,"SE4->E4_DESCRI")')  //-- Função que será executada para adicionar automaticamente a condição '005', atualizar o combo e a descrição da condição de pagamento.
aAdd( aRet, 'R$ TOTAL')  //-- Descrição do botão.
aAdd( aRet, 'LJ7CondPg(2, "DN"), M->LQ_CONDPG := "DN", cDescCondPg := Posicione("SE4",1,xFilial("SE4")+M->LQ_CONDPG,"SE4->E4_DESCRI")')  //-- Função que será executada para adicionar automaticamente a condição '005', atualizar o combo e a descrição da condição de pagamento.
Return aRet

