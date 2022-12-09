/////  PROGRAMA PARA ACERTAR POSICAO DE 21 A 37 DO DETALHE BANCO BRADESCO
/////  CNAB - POSICOES ( 021 - 037 )

#Include "RwMake.Ch"
User Function Cedente()

_Linha  := "00090"+Subst(SA6->A6_AGENCIA,1,4) + STRZERO(VAL(SUBST(SA6->A6_NUMCON,1,8)),8)

Return(_Linha)


User Function EndCob(wPar)

Local wRet

If wPar = 1 // Endereco
	If !Empty(SA1->A1_ENDCOB)
		wRet := Subs(SA1->A1_ENDCOB,1,40)
	Else
		wRet := Subs(SA1->A1_END,1,40)
	Endif
Elseif wPar = 2 // Bairro
	If !Empty(SA1->A1_BAIRROC)
		wRet := Subs(SA1->A1_BAIRROC,1,40)
	Else
		wRet := Subs(SA1->A1_BAIRRO,1,40)
	Endif
Elseif wPar = 3 // Cidade
	If !Empty(SA1->A1_MUNC)
		wRet := Subs(SA1->A1_MUNC,1,40)
	Else
		wRet := Subs(SA1->A1_MUN,1,40)
	Endif
Elseif wPar = 4 // Estado
	If !Empty(SA1->A1_ESTC)
		wRet := SA1->A1_ESTC
	Else
		wRet := SA1->A1_EST
	Endif
Elseif wPar = 5 // CEP
	If !Empty(SA1->A1_CEPC)
		wRet := SA1->A1_CEPC
	Else
		wRet := SA1->A1_CEP
	Endif
Else
	wRet := ""
Endif
Return(wRet)