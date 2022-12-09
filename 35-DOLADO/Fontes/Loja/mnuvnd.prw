#include 'totvs.ch'
#include 'protheus.ch'

/*/{Protheus.doc} NextA1Lj
Fun��o utilizada para Selecionar a Tabela de pre�o antes da venda
@type function
@version  12.1.33
@author Vladimir
@since 05/10/2022
@return character, C�digo da pr�xima loja dispon�vel
@nota "CPERG" (SELTAB), tem que estar criada a sele��o s� funciona antes de entrar na rotina de venda assistida.
/*/ 

user function mnuvnd()

local cTab      := "" 
local cText     := "Selecione uma opcao v�lida"
Local cTitle    := "Atencao"

/*
    --------------------------------------------
    |                                          |
    |   MV_PAR01 = Informe a Tabela de Pre�o   |
    |                                          |
    --------------------------------------------
*/

Pergunte("SELTAB", .T.)

cTab := MV_PAR01

if cTab == 1
    Putmv("MV_TABPAD","003" ) //Atacado TABELA 002

elseif cTab == 2
    Putmv("MV_TABPAD","002" ) //Varejo TABELA 003
else
    MsgAlert(cText, cTitle)
endif

return LOJA701()
