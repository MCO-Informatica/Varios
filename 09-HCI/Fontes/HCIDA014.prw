#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

User Function HCIDA014()

	Local _aParBox		:= {}
	
	aadd(_aParBox,{1,"Data De? "    ,Ctod(Space(8)) 				,"@D",".T.","",".T.",08,.T.})       
	aAdd(_aParBox,{1,"Data Ate? "	,Ctod(Space(8))					,"@D","MV_PAR02 >= MV_PAR01","",".T.",08,.T.})
	aadd(_aParBox,{1,"Nota De? "    ,Space(TAMSX3("D1_DOC")[1]) 	,"@!",".T.","",".T.",TAMSX3("D1_DOC")[1],.T.})       
	aadd(_aParBox,{1,"Serie De? "   ,Space(TAMSX3("D1_SERIE")[1]) 	,"@!",".T.","",".T.",TAMSX3("D1_SERIE")[1],.T.})       
	aAdd(_aParBox,{1,"Nota Ate? "	,Space(TAMSX3("D1_DOC")[1])		,"@!","MV_PAR05 >= MV_PAR03","",".T.",TAMSX3("D1_DOC")[1],.T.})
	aadd(_aParBox,{1,"Serie Ate? "  ,Space(TAMSX3("D1_SERIE")[1]) 	,"@!",".T.","",".T.",TAMSX3("D1_SERIE")[1],.T.})       
	                             	
	If ParamBox(_aParBox,"Grv CLASFIS",,,,,,,,,.T.,.T.)
		_fGrvFIS()
	EndIf

Return()


Static Function _fGrvFIS()

	Local _aArea	:= GetArea()
	Local _cQuery	:= ""
	Local _cAliasCF	:= GetNextAlias()
	
	_cQuery := "SELECT SD1.R_E_C_N_O_ AS CRECNO "
	_cQuery += " FROM " + RetSqlName("SD1") + " SD1 "
	_cQuery += " WHERE D1_FILIAL = '" + xFilial("SD1") + "' "
	
	If !Empty(MV_PAR01) .Or. !Empty(MV_PAR02)
		_cQuery += " AND D1_DTDIGIT BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "'"
	EndIf
	
	If !Empty(MV_PAR03) .Or. !Empty(MV_PAR04)
		_cQuery += " AND D1_DOC||D1_SERIE BETWEEN '" + MV_PAR03+MV_PAR05 + "' AND '" + MV_PAR04+MV_PAR06 + "'"
	EndIf
	
	_cQuery += " AND D_E_L_E_T_ = ' ' "
	TcQuery _cQuery New Alias &(_cAliasCF)

	If (_cAliasCF)->(!EOF())
		dbSelectArea("SD1")
		SD1->(DBSETORDER(1))
		
		dbSelectArea("SB1")
		SB1->(DBSETORDER(1))
		
		dbSelectArea("SF4")
		SF4->(DBSETORDER(1))
		
		While (_cAliasCF)->(!EOF())
			SD1->(dbGOTO((_cAliasCF)->CRECNO))
			If SD1->D1_DOC == (_cAliasCF)->D1_DOC .AND. SD1->D1_SERIE == (_cAliasCF)->D1_SERIE 
				If SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD))	
					If SF4->(dbSeek(xFilial("SF4")+SD1->D1_TES))
		    			If RecLock("SD1",.F.)
							SD1->D1_CLASFIS	:= ALLTRIM(SB1->B1_ORIGEM) + ALLTRIM(SF4->F4_SITTRIB)
							SD1->(MsUnLock())
						EndIf
						dbSelectArea("SFT") 
						SFT->(dbSetOrder(1))//FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_ITEM+FT_PRODUTO  
						If SFT->(dbSeek(xFilial("SFT") + PADR("E",TAMSX3("FT_TIPOMOV")[1]) + SD1->D1_SERIE + SD1->D1_DOC + SD1->D1_FORNECE + SD1->D1_LOJA + PADR(SD1->D1_ITEM,TAMSX3("FT_ITEM")[1]) + SD1->D1_COD))
							RecLock("SFT",.F.)
							SFT->FT_CLASFIS	  := SD1->D1_CLASFIS	
							MSUNLOCK()
						EndIf
						
						dbSelectArea("CD2") 
						CD2->(dbSetOrder(1))
						If CD2->(dbSeek(xFilial("CD2") + "E" + SD1->D1_SERIE + SD1->D2_DOC + SD1->D1_FORNECE + SD1->D1_LOJA + PADR(SD1->D1_ITEM,TAMSX3("CD2_ITEM")[1]) + SD1->D1_COD))//CD2_FILIAL+CD2_TPMOV+CD2_SERIE+CD2_DOC+CD2_CODCLI+CD2_LOJCLI+CD2_ITEM+CD2_CODPRO+CD2_IMP
							While SD1->D1_SERIE == CD2->CD2_SERIE .And. SD1->D1_DOC == CD2->CD2_DOC .And. SD1->D1_FORNECE == CD2->CD2_CODCLI .And. SD1->D1_LOJA == CD2->CD2_LOJCLI .And. ALLTRIM(SD1->D1_ITEM) == ALLTRIM(CD2->CD2_ITEM) .And. SD1->D1_COD == CD2->CD2_CODPRO .And. CD2->CD2_TPMOV == "E" .And. CD2->CD2_FILIAL == xFilial("CD2")
								If ALLTRIM(CD2->CD2_IMP) == "ICM" .OR. ALLTRIM(CD2->CD2_IMP) == "SOL"
									RecLock("CD2",.F.)
									CD2->CD2_ORIGEM	:= SUBSTRING(SD1->D1_CLASFIS,1,1)
									CD2->CD2_CST	:= SUBSTRING(SD1->D1_CLASFIS,2,2)
									MSUNLOCK()
								EndIf
								CD2->(DBSKIP())
							EndDo
						EndIF
					EndIf
				EndIF
			EndIf
			(_cAliasCF)->(dbSkip())
		EndDo		
	EndIf
	RestArea(_aArea)
	
Return()