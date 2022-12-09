#INCLUDE 'protheus.ch'
#INCLUDE 'totvs.ch'
/*/{Protheus.doc} NextA1Lj
Gatilho para preencher Armazém e endereço
@type function
@version  12.1.33
@author Vladimir
@since 05/10/2022
@return character, Código do armazém e código do endereço
/*/

//ARMAZEM 

User Function GTL2TGRT()
Local _nPosLocal := aScan( aHeaderDet, { |x| Trim(x[2]) == 'LR_LOCAL' })
Local _cLocal    := "04" //Código do Armazém



If Len(aColsDet) >= n
     aColsDet[n][_nPosLocal] := _cLocal //Código do Armazém
Endif

Return _cLocal


//ENDEREÇO

User Function GTL3TGRT()
Local _nPosEnd   := aScan( aHeaderDet, { |x| Trim(x[2]) == 'LR_LOCALIZ' })
Local _cEnd      := "PAGE" //Código do Endereço


If Len(aColsDet) >= n
     aColsDet[n][_nPosEnd]   := _cEnd   //Código do Endereço
Endif

Return _cEnd

