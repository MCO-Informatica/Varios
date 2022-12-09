#INCLUDE 'protheus.ch'
#INCLUDE 'totvs.ch'
/*/{Protheus.doc} NextA1Lj
Ponto de entrada para alterar o armazén
@type function
@version  12.1.33
@author Vladimir
@since 05/10/2022
@return character, Código da próxima loja disponível
/*/
 
User Function Lj7041()

Local _cLocal   := ParamIxb[1] // Recebe parâmetro contendo almoxarifado
Local _aColsDet := ParamIxb[2] // Recebe parâmetro contendo o array aColsDet

If Len(_aColsDet) < n // Verifica se é um novo item, para só alterar o almoxarifado na inclusão do item 
     _cLocal := "04" //Código do Armazém
Endif

Return _cLocal
