/* 
    Ponto de entrada para citar os campos que não devem ser copiados no cadastro de Produto 
    Denis Varella ~ 06/04/2022
*/

User Function MTA010NC()
    Local aCpoNC := {}
    AAdd( aCpoNC, 'B1_COMOD' )
Return aCpoNC
