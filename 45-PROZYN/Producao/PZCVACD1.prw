#include 'protheus.ch'

#DEFINE INTEIRO 	1
#DEFINE FRAC_KG 	2
#DEFINE FRAC_DC 	3
#DEFINE AGLUT_FRAC 	4

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³PZCVACD1		ºAutor  ³Microsiga	     º Data ³  17/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza a ordem de separação com base na tabela SD4		  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PZCVACD1(cOp)

	Local aArea			:= GetArea()
	Local aOrdSep		:= {}

	Default cOp	:= ""

	//Recebe as ordens de separação antes de iniciar a exclusão
	aOrdSep := GetOrdSep(cOp)

	//Exclui a ordem de separação divergente  
	ExcOrdSDiv(cOp)

	//Atualiza a ordem de separação com base na SD4
	AtuOrdSep(cOp, aOrdSep)

	RestArea(aArea)	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ExcOrdSDiv	ºAutor  ³Microsiga	     º Data ³  17/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exclui ordem de separação divergente da SD4				  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
Static Function ExcOrdSDiv(cOp)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()

	Default cOp := ""

	cQuery	:= " SELECT SZT.R_E_C_N_O_ RECSZT FROM "+RetSqlName("SZT")+" SZT with (NOLOCK) "+CRLF
	cQuery	+= " WHERE SZT.ZT_FILIAL = '"+xFilial("SZT")+"' "+CRLF
	cQuery	+= " AND SZT.ZT_OP = '"+cOp+"' "+CRLF
	cQuery	+= " AND SZT.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " AND ( "+CRLF
	cQuery	+= " 	NOT EXISTS(SELECT 'x' FROM "+RetSqlName("SD4")+" SD4 with (NOLOCK) "+CRLF

	cQuery	+= " 				INNER JOIN "+RetSqlName("SB1")+" SB1 with (NOLOCK) "+CRLF
	cQuery	+= " 				ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " 				AND SB1.B1_COD = SD4.D4_COD "+CRLF
	cQuery	+= " 				AND SB1.B1_TIPO NOT IN('EM','MO') "+CRLF
	cQuery	+= " 				AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " 				WHERE SD4.D4_FILIAL = SZT.ZT_FILIAL "+CRLF
	cQuery	+= " 				AND SD4.D4_OP = SZT.ZT_OP "+CRLF
	cQuery	+= " 				AND SD4.D4_COD = SZT.ZT_PROD "+CRLF
	cQuery	+= " 				AND SD4.D4_LOTECTL = SZT.ZT_LOTECTL "+CRLF
	cQuery	+= " 				AND SD4.D_E_L_E_T_ = ' ') "+CRLF
	cQuery	+= " 	OR "+CRLF
	cQuery	+= " 	EXISTS(SELECT 'x' FROM "+RetSqlName("SD4")+" SD4 with (NOLOCK) "+CRLF

	cQuery	+= " 				INNER JOIN "+RetSqlName("SB1")+" SB1 with (NOLOCK) "+CRLF
	cQuery	+= " 				ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " 				AND SB1.B1_COD = SD4.D4_COD "+CRLF
	cQuery	+= " 				AND SB1.B1_TIPO NOT IN('EM','MO') "+CRLF
	cQuery	+= " 				AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " 				WHERE SD4.D4_FILIAL = SZT.ZT_FILIAL "+CRLF
	cQuery	+= " 				AND SD4.D4_OP = SZT.ZT_OP "+CRLF
	cQuery	+= " 				AND SD4.D4_COD = SZT.ZT_PROD "+CRLF
	cQuery	+= " 				AND (SD4.D4_LOTECTL != SZT.ZT_LOTECTL "+CRLF
	cQuery	+= " 					OR SD4.D4_QTDEORI != SZT.ZT_QTDORI) "+CRLF
	cQuery	+= " 				AND SD4.D_E_L_E_T_ = ' ') "+CRLF
	cQuery	+= " 	) "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	DbSelectArea("SZT")
	DbSetOrder(1)
	While (cArqTmp)->(!Eof())
		SZT->(DbGoTo((cArqTmp)->RECSZT))

		//Exclui ordem de separação de inteiro da tabela CB8
		ExcCB8Div(SZT->ZT_ORDSEP, SZT->ZT_OP, SZT->ZT_PROD, SZT->ZT_LOTECTL)

		//Exclui ordem de separação de fracionado da CB8 Kg
		ExcCB8Div(SZT->ZT_ORDSEP2, SZT->ZT_OP, SZT->ZT_PROD, SZT->ZT_LOTECTL)

		//Exclui ordem de separação de fracionado da CB8 Decimal
		ExcCB8Div(SZT->ZT_ORDSEP4, SZT->ZT_OP, SZT->ZT_PROD, SZT->ZT_LOTECTL)

		//Exclui ordem de separação de fracionado aglutinado da CB8
		ExcCB8Div(SZT->ZT_ORDSEP3,, SZT->ZT_PROD)

		RecLock("SZT",.F.)
		SZT->(DbDelete())
		SZT->(MsUnLock())

		(cArqTmp)->(DbSkip())
	EndDo

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	Restarea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ExcCB8Div		ºAutor  ³Microsiga	     º Data ³  04/07/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exclui dados da tabela CB8 que esteja divergente da SD4	  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
Static Function ExcCB8Div(cOrdSep, cOp, cProd, cLote)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()

	Default cOrdSep	:= "" 
	Default cOp		:= "" 
	Default cProd	:= "" 
	Default cLote	:= ""

	cQuery	:= " SELECT R_E_C_N_O_ RECSB8 FROM "+RetSqlName("CB8")+" CB8 with (NOLOCK) "+CRLF

	cQuery	+= " WHERE CB8.CB8_FILIAL = '"+xFilial("CB8")+"' "+CRLF
	cQuery	+= " AND CB8_ORDSEP = '"+cOrdSep+"' "+CRLF
	cQuery	+= " AND CB8.CB8_OP = '"+cOp+"' " +CRLF
	cQuery	+= " AND CB8_PROD = '"+cProd+"' "+CRLF

	If !Empty(cLote)
		cQuery	+= " AND CB8.CB8_LOTECT = '"+cLote+"' "+CRLF
	EndIf

	cQuery	+= " AND CB8.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	DbSelectArea("CB8")
	DbSetOrder(1)
	While (cArqTmp)->(!Eof())

		CB8->(DbGoTo((cArqTmp)->RECSB8))

		//Exclui itens separados antes da exclusão da ordem de separação
		ExcCB9Div(CB8->CB8_ORDSEP, CB8->CB8_PROD/*, CB8->CB8_LOTECT*/)


		CB8->(RecLock("CB8",.F.))
		CB8->(DbDelete())
		CB8->(MsUnLock())

		(cArqTmp)->(DbSkip())
	EndDo

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ExcCB8Div		ºAutor  ³Microsiga	     º Data ³  04/07/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exclui dados da tabela CB8 que esteja divergente da SD4	  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
Static Function ExcCB9Div(cOrdSep, cProd, cLote)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()

	Default cOrdSep	:= "" 
	Default cProd	:= "" 
	Default cLote	:= ""

	cQuery	:= " SELECT R_E_C_N_O_ RECSB9 FROM "+RetSqlName("CB9")+" CB9 with (NOLOCK) "+CRLF

	cQuery	+= " WHERE CB9.CB9_FILIAL = '"+xFilial("CB9")+"' "+CRLF
	cQuery	+= " AND CB9.CB9_ORDSEP = '"+cOrdSep+"' "+CRLF
	cQuery	+= " AND CB9.CB9_PROD = '"+cProd+"' "+CRLF

	If !Empty(cLote)
		cQuery	+= " AND CB9.CB9_LOTECT = '"+cLote+"' "+CRLF
	EndIf

	cQuery	+= " AND CB9.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	DbSelectArea("CB9")
	DbSetOrder(1)
	While (cArqTmp)->(!Eof())

		CB9->(DbGoTo((cArqTmp)->RECSB9))

		CB9->(RecLock("CB9",.F.))
		CB9->(DbDelete())
		CB9->(MsUnLock())

		(cArqTmp)->(DbSkip())
	EndDo

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³AtuOrdSep		ºAutor  ³Microsiga	     º Data ³  17/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza a ordem de separação nas tabela SZT e CB8		  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuOrdSep(cOp, aOrdSep)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()

	Default cOp		:= ""
	Default aOrdSep	:= {}

	cQuery	:= " SELECT D4_COD, D4_OP, D4_LOCAL, D4_QTDEORI, D4_QUANT, D4_LOTECTL, D4_NUMLOTE, "+CRLF
	cQuery	+= " B1_DESC, B1_QE, B1_TIPO " +CRLF
	cQuery	+= " FROM "+RetSqlName("SD4")+" SD4 with (NOLOCK) "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 with (NOLOCK) "+CRLF
	cQuery	+= " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF 
	cQuery	+= " AND SB1.B1_COD = SD4.D4_COD "+CRLF
	cQuery	+= " AND SB1.B1_TIPO NOT IN('EM','MO') "+CRLF
	cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " WHERE SD4.D4_FILIAL = '"+xFilial("SD4")+"' "+CRLF
	cQuery	+= " AND SD4.D4_OP = '"+cOp+"' "+CRLF
	cQuery	+= " AND SD4.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " AND NOT EXISTS(SELECT 'X' FROM "+RetSqlName("SZT")+" SZT with (NOLOCK) "+CRLF
	cQuery	+= " 				WHERE SZT.ZT_FILIAL = SD4.D4_FILIAL "+CRLF
	cQuery	+= " 				AND SZT.ZT_OP = SD4.D4_OP "+CRLF
	cQuery	+= " 				AND SZT.ZT_PROD = SD4.D4_COD "+CRLF
	cQuery	+= " 				AND SZT.ZT_LOTECTL = SD4.D4_LOTECTL "+CRLF
	cQuery	+= " 				AND SZT.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " 				) "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	While (cArqTmp)->(!Eof())

		If (cArqTmp)->B1_QE != 0

			//Grava os dados na tabela SZT
			GrvSZT((cArqTmp)->D4_COD, (cArqTmp)->D4_OP, (cArqTmp)->D4_LOCAL, (cArqTmp)->D4_QTDEORI,; 
			(cArqTmp)->D4_LOTECTL, (cArqTmp)->D4_NUMLOTE, (cArqTmp)->B1_QE, aOrdSep)

			//Atualiza a ordem de separação Inteiro
			GrvCB8(aOrdSep[INTEIRO], (cArqTmp)->D4_COD, (cArqTmp)->D4_LOCAL,; 
			INT((cArqTmp)->D4_QTDEORI/(cArqTmp)->B1_QE)*(cArqTmp)->B1_QE,; 
			(cArqTmp)->D4_LOTECTL, (cArqTmp)->D4_NUMLOTE, (cArqTmp)->D4_OP )

			//Atualiza a ordem de separação Fracionado Kg
			GrvCB8(aOrdSep[FRAC_KG], (cArqTmp)->D4_COD, (cArqTmp)->D4_LOCAL,; 
			INT((cArqTmp)->D4_QTDEORI-(INT((cArqTmp)->D4_QTDEORI/(cArqTmp)->B1_QE)*(cArqTmp)->B1_QE)),; 
			(cArqTmp)->D4_LOTECTL, (cArqTmp)->D4_NUMLOTE, (cArqTmp)->D4_OP )

			//Atualiza a ordem de separação Fracionado Decimal
			GrvCB8(aOrdSep[FRAC_DC], (cArqTmp)->D4_COD, (cArqTmp)->D4_LOCAL,; 
			((cArqTmp)->D4_QTDEORI-(INT((cArqTmp)->D4_QTDEORI/(cArqTmp)->B1_QE)*(cArqTmp)->B1_QE));
			-INT((cArqTmp)->D4_QTDEORI-(INT((cArqTmp)->D4_QTDEORI/(cArqTmp)->B1_QE)*(cArqTmp)->B1_QE)),;  
			(cArqTmp)->D4_LOTECTL, (cArqTmp)->D4_NUMLOTE, (cArqTmp)->D4_OP )


			//Atualiza a ordem de separação Aglutinado do Fracionado
			GrvCB8Agl(aOrdSep[AGLUT_FRAC], (cArqTmp)->D4_COD, (cArqTmp)->D4_LOCAL, (cArqTmp)->D4_LOTECTL, (cArqTmp)->D4_NUMLOTE)

		EndIf

		(cArqTmp)->(DbSkip())
	EndDo

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GrvSZT		ºAutor  ³Microsiga	     º Data ³  17/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza a ordem de separação nas tabela SZT e CB8		  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvSZT(cProd, cOp, cArmz, nQtdOri, cLote, cSubLote, nQtdEmb, aOrdSep, cEndLocz)

	Local aArea		:= GetArea()

	Default cProd		:= "" 
	Default cOp			:= "" 
	Default cArmz		:= "" 
	Default nQtdOri		:= 0 
	Default cLote		:= "" 
	Default cSubLote	:= "" 
	Default nQtdEmb		:= 0 
	Default aOrdSep		:= {}
	Default cEndLocz	:= ""

	DbSelectArea("SZT")
	DbSetOrder(1)

	RecLock("SZT",.T.)
	SZT->ZT_FILIAL  := xFilial("SZT")
	If Len(aOrdSep) > 0
		SZT->ZT_ORDSEP  := aOrdSep[INTEIRO]		//Ordem de separação inteiro
		SZT->ZT_ORDSEP2 := aOrdSep[FRAC_KG]		//Ordem de separação fracionado em Kg
		SZT->ZT_ORDSEP3 := aOrdSep[AGLUT_FRAC]  //Ordem de Separação algutinado
		SZT->ZT_ORDSEP4 := aOrdSep[FRAC_DC]		//Ordem de separação fracionado Decimal
	else
		SZT->ZT_ORDSEP  := ''		//Ordem de separação inteiro
		SZT->ZT_ORDSEP2 := ''		//Ordem de separação fracionado em Kg
		SZT->ZT_ORDSEP3 := ''  		//Ordem de Separação algutinado
		SZT->ZT_ORDSEP4 := ''		//Ordem de separação fracionado Decimal
	EndIf
	SZT->ZT_ITEM    := Soma1(GetItemSzt(cOp))
	SZT->ZT_PROD    := cProd
	SZT->ZT_LOCAL   := cArmz
	SZT->ZT_LOTECTL := cLote
	SZT->ZT_QTDORI  := nQtdOri
	SZT->ZT_LCALIZ	:= cEndLocz
	SZT->ZT_OBSERV	:= ""

	If nQtdEmb != 0
		SZT->ZT_QTDMUL  := Int(nQtdOri/nQtdEmb)*nQtdEmb
		SZT->ZT_QTDDIF  := nQtdOri % nQtdEmb
		SZT->ZT_QTDB01  := int(nQtdOri % nQtdEmb) 
		SZT->ZT_QTDB02  := (nQtdOri % nQtdEmb) - int(nQtdOri % nQtdEmb)  	
	EndIf

	SZT->ZT_DATA    := MsDate()
	SZT->ZT_HORA    := Time()
	SZT->ZT_USUARIO := cUserName
	SZT->ZT_OP		:= cOp
	SZT->(MsUnLock())

	RestArea(aArea)
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GetOrdSep		ºAutor  ³Microsiga	     º Data ³  17/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna o numero das ordens de separação					  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetOrdSep(cOp)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local aRet		:= {}

	Default cOp		:= ""

	cQuery := " SELECT ZT_ORDSEP ZTINTEIRO, ZT_ORDSEP2 ZTFRACIONKG, ZT_ORDSEP4 ZTFRACIONDC, "+CRLF
	cQuery += " ZT_ORDSEP3 ZTAGLUTFRAC FROM "+RetSqlName("SZT")+" SZT with (NOLOCK)"+CRLF
	cQuery += " WHERE SZT.ZT_FILIAL = '"+xFilial("SZT")+"' " +CRLF
	cQuery += " AND SZT.ZT_OP = '"+cOp+"' "+CRLF
	cQuery += " AND SZT.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += " GROUP BY ZT_ORDSEP, ZT_ORDSEP2, ZT_ORDSEP3, ZT_ORDSEP4 "+CRLF 

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	If (cArqTmp)->(!Eof())
		aRet := {(cArqTmp)->ZTINTEIRO, (cArqTmp)->ZTFRACIONKG, (cArqTmp)->ZTFRACIONDC, (cArqTmp)->ZTAGLUTFRAC}
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GrvCB8		ºAutor  ³Microsiga	     º Data ³  17/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava os dados da ordem de separação						  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvCB8(cOrdSep, cProd, cArmz, nQtdOri, cLote, cSubLote, cOp, cEndLocz )

	Local aArea	:= GetArea()

	Default cOrdSep		:= "" 
	Default cProd		:= "" 
	Default cArmz		:= "" 
	Default nQtdOri		:= 0 
	Default cLote		:= "" 
	Default cSubLote	:= "" 
	Default cOp			:= ""
	Default cEndLocz	:= ""

	DbSelectArea("CB8")
	DbSetOrder(1)

	If nQtdOri > 0
		RecLock("CB8", .T.)
		CB8->CB8_FILIAL	:= xFilial("CB8")
		CB8->CB8_ORDSEP	:= cOrdSep
		CB8->CB8_ITEM  	:= Soma1(GetItemCB8(cOrdSep))
		CB8->CB8_PROD  	:= cProd
		CB8->CB8_LOCAL 	:= cArmz
		CB8->CB8_QTDORI	:= nQtdOri
		CB8->CB8_SALDOS	:= nQtdOri
		CB8->CB8_LCALIZ	:= cEndLocz
		CB8->CB8_LOTECT	:= cLote
		CB8->CB8_NUMLOT	:= cSubLote
		CB8->CB8_CFLOTE	:= "1"
		CB8->CB8_OP    	:= cOp
		CB8->(MsUnLock())
	EndIf

	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GrvCB8Agl		ºAutor  ³Microsiga	     º Data ³  17/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava os dados da ordem de separação aglutinado			  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvCB8Agl(cOrdSep, cProd, cArmz, cLote, cSubLote, cEndLocz )

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()

	Default cOrdSep		:= "" 
	Default cProd		:= "" 
	Default cArmz		:= "" 
	Default cLote		:= "" 
	Default cSubLote	:= "" 
	Default cEndLocz	:= ""


	cQuery	:= " SELECT ZT_LOTECTL, SUM(ZT_QTDB01), SUM(ZT_QTDB02), (SUM(ZT_QTDB01)+SUM(ZT_QTDB02)) FRAC_AGLUT FROM "+RetSqlName("SZT")+" SZT "+CRLF
	cQuery	+= " WHERE SZT.ZT_FILIAL = '"+xFilial("SZT")+"' " +CRLF
	cQuery	+= " AND SZT.ZT_ORDSEP3 = '"+cOrdSep+"' "+CRLF
	cQuery	+= " AND SZT.ZT_PROD = '"+cProd+"' "+CRLF
	cQuery	+= " AND SZT.ZT_LOCAL = '"+cArmz+"' "+CRLF
	//cQuery	+= " AND SZT.ZT_LOTECTL = '"+cLote+"' " +CRLF
	cQuery	+= " AND SZT.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " GROUP BY ZT_LOTECTL "

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	DbSelectArea("CB8")
	DbSetOrder(1)

	While (cArqTmp)->(!Eof()) 
		If (cArqTmp)->FRAC_AGLUT > 0

			RecLock("CB8", .T.)
			CB8->CB8_FILIAL	:= xFilial("CB8")
			CB8->CB8_ORDSEP	:= cOrdSep
			CB8->CB8_ITEM  	:= Soma1(GetItemCB8(cOrdSep))
			CB8->CB8_PROD  	:= cProd
			CB8->CB8_LOCAL 	:= cArmz
			CB8->CB8_QTDORI	:= (cArqTmp)->FRAC_AGLUT
			CB8->CB8_SALDOS	:= (cArqTmp)->FRAC_AGLUT
			CB8->CB8_LCALIZ	:= cEndLocz
			CB8->CB8_LOTECT	:= (cArqTmp)->ZT_LOTECTL
			CB8->CB8_NUMLOT	:= cSubLote
			CB8->CB8_CFLOTE	:= "1"
			CB8->(MsUnLock())
		EndIf

		(cArqTmp)->(DbSkip())
	EndDo

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GetItemSzt	ºAutor  ³Microsiga	     º Data ³  17/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna o proximo item da tabela SZT						  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetItemSzt(cOp)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local cRet		:= ""

	cQuery := " SELECT MAX(ZT_ITEM) ZT_ITEM FROM "+RetSqlName("SZT")+" SZT with (NOLOCK) "+CRLF
	cQuery += " WHERE SZT.ZT_FILIAL = '"+xFilial("SZT")+"' " +CRLF
	cQuery += " AND SZT.ZT_OP = '"+cOp+"' "+CRLF
	cQuery += " AND SZT.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	If (cArqTmp)->(!Eof())
		cRet := (cArqTmp)->ZT_ITEM
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GetItemCB8	ºAutor  ³Microsiga	     º Data ³  17/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna o proximo item da tabela CB8						  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetItemCB8(cOrdSep)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local cRet		:= ""

	Default cOrdSep	:= ""

	cQuery := " SELECT MAX(CB8_ITEM) CB8_ITEM FROM "+RetSqlName("CB8")+" CB8 with (NOLOCK) "+CRLF
	cQuery += " WHERE CB8.CB8_FILIAL = '"+xFilial("SB8")+"' "+CRLF
	cQuery += " AND CB8.CB8_ORDSEP = '"+cOrdSep+"' " +CRLF
	cQuery += " AND CB8.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	If (cArqTmp)->(!Eof())
		cRet := (cArqTmp)->CB8_ITEM
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return cRet
