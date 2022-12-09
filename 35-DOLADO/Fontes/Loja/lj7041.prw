#INCLUDE 'protheus.ch'
#INCLUDE 'totvs.ch'
/*/{Protheus.doc} NextA1Lj
Ponto de entrada para alterar o armaz�n
@type function
@version  12.1.33
@author Vladimir
@since 05/10/2022
@return character, C�digo da pr�xima loja dispon�vel
/*/
 
User Function Lj7041()

Local _cLocal   := ParamIxb[1] // Recebe par�metro contendo almoxarifado
Local _aColsDet := ParamIxb[2] // Recebe par�metro contendo o array aColsDet

If Len(_aColsDet) < n // Verifica se � um novo item, para s� alterar o almoxarifado na inclus�o do item 
     _cLocal := "04" //C�digo do Armaz�m
Endif

Return _cLocal
