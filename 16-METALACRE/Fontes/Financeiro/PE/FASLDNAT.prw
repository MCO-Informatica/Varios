User Function FASLDNAT()
Local aArea	:= GetArea()
Local cOrigem	:= ParamIXB[1]
Local cAlias	:= ParamIXB[2]
Local nRecno	:= ParamIXB[3]
Local cOpcRot	:= ParamIXB[4]
Local lRet		:= .t.

//lAtuSldNat := ExecBlock("FASLDNAT",.F.,.F.,{cOrigem, cAlias, nRecno, nOpcRot})
//AtuSldNat(SE5->E5_NATUREZ, SE5->E5_DATA, "01", "3", "P", SE5->E5_VALOR,, If(lEstorno,"-","+"),,FunName(),"SE5", SE5->(Recno()),0)


If cOrigem $'FINA100*FINA110*FINA070' .And. cAlias$'SE5'  
	SE5->(dbGoTo(nRecno))
	If AllTrim(SE5->E5_NATUREZ)$GetNewPar("MV_NATDPBC",'DESP BANC')
		lRet := .t.
	Endif
Endif
RestArea(aArea)
Return(lRet)