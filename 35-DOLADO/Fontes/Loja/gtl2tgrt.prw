#INCLUDE 'protheus.ch'
#INCLUDE 'totvs.ch'
/*/{Protheus.doc} NextA1Lj
Gatilho para preencher Armaz�m e endere�o
@type function
@version  12.1.33
@author Vladimir
@since 05/10/2022
@return character, C�digo do armaz�m e c�digo do endere�o
/*/

//ARMAZEM 

User Function GTL2TGRT()
Local _nPosLocal := aScan( aHeaderDet, { |x| Trim(x[2]) == 'LR_LOCAL' })
Local _cLocal    := "04" //C�digo do Armaz�m



If Len(aColsDet) >= n
     aColsDet[n][_nPosLocal] := _cLocal //C�digo do Armaz�m
Endif

Return _cLocal


//ENDERE�O

User Function GTL3TGRT()
Local _nPosEnd   := aScan( aHeaderDet, { |x| Trim(x[2]) == 'LR_LOCALIZ' })
Local _cEnd      := "PAGE" //C�digo do Endere�o


If Len(aColsDet) >= n
     aColsDet[n][_nPosEnd]   := _cEnd   //C�digo do Endere�o
Endif

Return _cEnd

