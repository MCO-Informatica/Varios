#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RN00040  ºAutor  ³                				16/10/2015º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica na digitação da classe de valor a existência do    º±±
±±           ³projeto								                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Renova                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RN00040
Local _lRet := .T.
Local _cAreaSe5 := GetArea("SE5")
Local _cItemD := Alltrim(M->E5_ITEMD)
Local _cItemC := Alltrim(M->E5_ITEMC)
Local _cClasD := Alltrim(M->E5_EC05DB)
Local _cClasC := Alltrim(M->E5_EC05CR)
Local _cMens := ''
If Empty(_cClasD) .and. Empty(_cClasC)
	_lRet := .T.
Else
	If Empty(_cItemD) .or. Empty(_cItemC)
		if Empty(_cItemD) .and. Empty(_cItemC)
			_cMens := "Projetos Debito ou Crédito"
		Else
			if ! Empty(_cClasC) .and. Empty(_cItemC)
				_cMens := "Projeto Crédito"
			Endif
			
			if ! Empty(_cClasD) .and. Empty(_cItemD)
				_cMens := "Projeto Débito"
			Endif
			//
			//	_cMens := "Projeto Débito"
			//Endif
		Endif
		if _cMens <> ''
			ShowHelpDlg("RN00040",{"Sequencia de digitação na classificação contábil dever ser respeitada.",""},3,;
			{"Informe "+iif(Empty(_cItemD) .and. Empty(_cItemC),"os campos ","o campo ")+_cMens,""},3)
			_lRet := .F.
		Endif
	Endif
Endif
RestArea(_cAreaSe5)
Return(_lRet)
