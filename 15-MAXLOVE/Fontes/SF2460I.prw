#INCLUDE "rwmake.ch"

User Function SF2460I

_alias := alias()
_ind   := IndexOrd()
_sRec  := Recno()
_WBASEST := 0
_WVLRST  := 0

_indE1 := SE1->(IndexOrd())
_sReE1 := SE1->(Recno())

Setprvt("_alias,_ind,_sRec,_indE1,_sReE1,_Prefixo,_Num,_Filial,_Cliente,_Loja,_FormaPg,_WBASEST,_WVLRST")

_Prefixo := SF2->F2_SERIE
_Num     := SF2->F2_DOC
_Filial  := SF2->F2_FILIAL
_Cliente := SF2->F2_CLIENTE
_Loja    := SF2->F2_LOJA
_FormaPg := ""
_cTipoFat:= "M"

dbselectArea("SC6")
dbsetOrder(1) 
If dbSeek(xFilial("SC6")+SC5->C5_NUM,.F.)
	_cTipoFat := Iif(SC6->C6_LOCAL$"05","D","M")     	
EndIf
 

dbselectArea("SE1")
dbSetOrder(2)    // Cliente + Loja + Prefixo + Numero + Parcela + Tipo

If dbSeek(xFilial("SE1")+ _Cliente + _Loja + _Prefixo + _Num)
	
	While _Filial==SE1->E1_FILIAL .AND. _Prefixo == SE1->E1_PREFIXO .And. ;
	      _Num == SE1->E1_NUM .And. _Cliente == SF2->F2_CLIENTE .And. _Loja == SF2->F2_LOJA
	
		reclock("SE1",.F.)
		SE1->E1_X_FATUR := _cTipoFat
		msunlock()
		dbSkip()

	Enddo

Endif

DbSelectArea("SE1")
DbSetOrder(_indE1)
DbGoTo(_sReE1)

DbSelectArea(_alias)
dbSetOrder(_ind)
DbGoto(_sRec)

Return