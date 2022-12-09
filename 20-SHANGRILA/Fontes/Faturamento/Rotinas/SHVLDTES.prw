#include "rwmake.ch"
//If(Alltrim(Upper(GetVersao())) == 'VALIDACAO',SHVLDTES(aCols[n,GdFieldPos('C6_PRODUTO')],aCols[n,GdFieldPos('C6_TES')]),.T.)
User Function SHVLDTES(cProduto,cTes)
Local lRet := .T.

If Substr(cProduto,1,1) = 'Z' .And. !Substr(cTes,1,1) $ SuperGetMv('ZZ_TESSNF',,'2|6')
	lRet := .F.
EndIf

If Substr(cProduto,1,1) <> 'Z' .And. Substr(cTes,1,1) $ SuperGetMv('ZZ_TESSNF',,'2|6')
	lRet := .F.
EndIf

Return lRet
