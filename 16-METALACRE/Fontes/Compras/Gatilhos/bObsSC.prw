#include 'protheus.ch'
#include 'parmtype.ch'
#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ bObsSC  ºAutor  ³ Luiz Alberto     º Data ³  05/03/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para preenchimento das observacoes originadas
				da solicitação de compras, validacao acrescentada
				no campo valor do pedido de compra
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
                      
user function bObsSC()
Local aArea    := GetArea()
Local _nPosCsl := AsCan(aHeader,{|x|Alltrim(x[2])=="C7_NUMSC"})
Local _nPosIsl := AsCan(aHeader,{|x|Alltrim(x[2])=="C7_ITEMSC"})
Local _nPosObs := AsCan(aHeader,{|x|Alltrim(x[2])=="C7_OBS"})
Local _nPosObm := AsCan(aHeader,{|x|Alltrim(x[2])=="C7_OBSM"})

If SC1->(FieldPos("C1_OBSM")) > 0
	If !Empty(_nPosCsl) .And. !Empty(_nPosIsl)
		cNumSol := aCols[n,_nPosCsl]
		cIteSol := aCols[n,_nPosIsl]
		
		If !Empty(cNumSol)
			If SC1->(dbSetOrder(1), dbSeek(xFilial("SC1")+cNumSol+cIteSol))
				If !Empty(SC1->C1_OBS)
					aCols[n,_nPosObs]:=	SC1->C1_OBS
				Endif
				If !Empty(SC1->C1_OBSM)
					aCols[n,_nPosObm]:= SC1->C1_OBSM
				Endif
			Endif
		Endif
	Endif
Endif

RestArea(aArea)
Return .T.
	
		
	
	
	
	


	
return