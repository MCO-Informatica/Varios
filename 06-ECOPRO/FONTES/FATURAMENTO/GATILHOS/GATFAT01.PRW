#include 'topconn.ch'

User Function GARFAT01

	Local nValunit  := 0
	Local nValII    := 0
	Local nValRat   := 0
	Local nValtotal := 0
	Local _x        := 0
    Local nTotmerc  := 0
	Local cItem     := ""
    Local Aarea     := GetAreA()

	If MsgYesNo("Deseja Efetuar o Rateio dos Impostos de Importação?","Rateio de I.I")

		nValII := aCols[1,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_VLRII"})]

		For _x:=1 to Len(Acols)

			cItem := aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_ITEM"})]
			cQry := "SELECT D1_VUNIT, D1_TOTAL FROM  "+RETSQLNAME("SD1")+" WHERE D1_FILIAL = '"+xFilial("SD1")+"' "
			cQry += "AND D1_DOC = '"+ SF1->F1_DOC +"' AND D1_SERIE = '"+ SF1->F1_SERIE +"' "
			cQry += "AND D1_FORNECE = '"+ SF1->F1_FORNECE +"' AND D1_LOJA = '"+ SF1->F1_LOJA +"' AND D1_ITEM = '"+cItem+"' AND D_E_L_E_T_ = ' '"
			TCQUERY (cQry) ALIAS "TTMP" NEW

			IF !TTMP->(EOF())
				nValtotal := TTMP->D1_TOTAL
				nValunit := TTMP->D1_VUNIT
			ENDIF

			TTMP->(DbCloseArea())
            nTotmerc    := SF1->F1_VALMERC
			nValRat     := (nValII/nTotmerc)*nValtotal
			If _x>1

				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_TPIMP"})]   := aCols[_x-1,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_TPIMP"})]
				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_DOCIMP"})]  := aCols[_x-1,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_DOCIMP"})]
				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_UFDES"})]   := aCols[_x-1,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_UFDES"})]
				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_LOCAL"})]   := aCols[_x-1,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_LOCAL"})]
				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_NDI"})]     := aCols[_x-1,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_NDI"})]
				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_DTDI"})]    := aCols[_x-1,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_DTDI"})]
				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_LOCDES"})]  := aCols[_x-1,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_LOCDES"})]
				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_DTDES"})]   := aCols[_x-1,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_DTDES"})]
				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_CODEXP"})]  := aCols[_x-1,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_CODEXP"})]
				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_LOJEXP"})]  := aCols[_x-1,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_LOJEXP"})]
				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_NADIC"})]   := aCols[_x-1,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_NADIC"})]
				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_CODFAB"})]  := aCols[_x-1,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_CODFAB"})]
				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_LOJFAB"})]  := aCols[_x-1,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_LOJFAB"})]
				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_VTRANS"})]  := aCols[_x-1,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_VTRANS"})]
				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_INTERM"})]  := aCols[_x-1,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_INTERM"})]         //ULTIMO CAMPO A SER INSERIDO MANUALMENTE - CAMPO QUE IRA DISPARAR O GATILHO
				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_SQADIC"})]  := STRZERO(_x,3)
				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_VLRII"})]   := nValRat

			else

				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_TPIMP"})]   := aCols[1,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_TPIMP"})]
				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_UFDES"})]   := aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_UFDES"})]
				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_DOCIMP"})]  := aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_DOCIMP"})]
				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_LOCAL"})]   := aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_LOCAL"})]
				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_DTDI"})]    := aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_DTDI"})]
				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_LOCDES"})]  := aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_LOCDES"})]
				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_DTDES"})]   := aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_DTDES"})]
				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_CODEXP"})]  := aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_CODEXP"})]
				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_LOJEXP"})]  := aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_LOJEXP"})]
				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_NADIC"})]   := aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_NADIC"})]
				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_VTRANS"})]  := aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_VTRANS"})]
				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_INTERM"})]  := aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_INTERM"})]
				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_SQADIC"})]  := STRZERO(_x,3)
				aCols[_x,aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "CD5_VLRII"})]   := nValRat
			Endif

		Next
	Else
		Return .F.
	EndIf

RestArea(Aarea)
//Retorna Campo que Disparou o Gatilho 
Return M->CD5_INTERM

