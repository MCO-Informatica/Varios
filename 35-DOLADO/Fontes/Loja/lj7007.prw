#INCLUDE 'rwmake.ch'

/*/{Protheus.doc} LJ7007
Ponto de entrada para acrescentar bot�es na forma de pagamento.
@type function
@version 12.1.33
@author Vladimir
@since 05/10/2022
@return variant, retorna bot�es criados
/*/

User Function LJ7007() 
Local aRet := {}

// Chama a fun��o para usar a condi��o de pagamento 'PX e DN
// Atualiza a variavel da tela
// Atualiza a descri��o da variavel.
aAdd( aRet, 'PIX TOTAL')  //-- Descri��o do bot�o.
aAdd( aRet, 'LJ7CondPg(2, "PX"), M->LQ_CONDPG := "PX", cDescCondPg := Posicione("SE4",1,xFilial("SE4")+M->LQ_CONDPG,"SE4->E4_DESCRI")')  //-- Fun��o que ser� executada para adicionar automaticamente a condi��o '005', atualizar o combo e a descri��o da condi��o de pagamento.
aAdd( aRet, 'R$ TOTAL')  //-- Descri��o do bot�o.
aAdd( aRet, 'LJ7CondPg(2, "DN"), M->LQ_CONDPG := "DN", cDescCondPg := Posicione("SE4",1,xFilial("SE4")+M->LQ_CONDPG,"SE4->E4_DESCRI")')  //-- Fun��o que ser� executada para adicionar automaticamente a condi��o '005', atualizar o combo e a descri��o da condi��o de pagamento.
Return aRet

