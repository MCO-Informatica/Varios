#Include "RWMAKE.CH"      
#Include "TOPCONN.CH"
#Include "Protheus.Ch"
#include "TbiConn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  TK271BOK  º Autor ³ Luiz Alberto    º Data ³ 10/06/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Antes de Gravar o Orcamento, Valida Valores dos Itens  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ 													          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function TK271FIMGR()// TK271BOK(_nOpc)
Local aAreaSUA	:= SUA->(GetArea())
Local aAreaSUB 	:= SUB->(GetArea())
Local _nPosTotal:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_VLRITEM"})
Local _nPosUnit := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VRUNIT"})
Local _nPosProd := aScan(aHeader,{|x| AllTrim(x[2])=="UB_PRODUTO"})
Local _nPosDesc := aScan(aHeader,{|x| AllTrim(x[2])=="UB_DESC"})
Local _nPosVlDes:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_VALDESC"})
Local _nPosQtdVe:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_QUANT"})
Local _nPosOpcio:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_OPC"})
Local _nPosTES  := aScan(aHeader,{|x| AllTrim(x[2])=="UB_TES"})
Local _nPosItem := aScan(aHeader,{|x| AllTrim(x[2])=="UB_ITEM"})
Local _nPosInic := aScan(aHeader,{|x| AllTrim(x[2])=="UB_XINIC"})
Local _nPosFim  := aScan(aHeader,{|x| AllTrim(x[2])=="UB_XFIM"})
Local _nPosPers := aScan(aHeader,{|x| AllTrim(x[2])=="UB_XLACRE"})
Local nPosDel	:= Len(aHeader)+1
Local _N        := N //Guarda posicao atual da GetDados
Local _lRet 		:= .T.
Local cOper		:= M->UA_OPER
Local cNumSc5   := M->UA_NUMSC5
Local _nOpc := paramixb[1]

If _nOpc == 1 // Telemarketing
	Return _lRet
Endif

lSenha := .t.
For nI := 1 to Len(aCols)
	nQuant	:= aCols[nI][_nPosQtdVe]    
	cProduto:= aCols[nI][_nPosProd]    
	cItem   := aCols[nI][_nPosItem]    
	nPrcVen	:= aCols[nI][_nPosUnit]    
	cOpcion := aCols[nI][_nPosOpcio]
	cTes	:= aCols[nI][_nPosTES]
	cLacre	:= aCols[nI][_nPosPers]
	nLacreIni	:= aCols[nI][_nPosInic]
	nLacreFim	:= aCols[nI][_nPosFim]

	n := nI
	If aCols[nI][nPosDel] .And. cOper == '1' .And. !Empty(cNumSc5)	// Se For Uma Exclusao do Item e Já Existir Pedido de Venda e Lacre
		dbSelectArea("Z00")
		Z00->(dbSetOrder(1))
		If Z00->(dbSeek(xFilial("Z00")+cLacre))
			cQuery := "SELECT Z01_PV "
			cQuery += "FROM "+RetSqlName("Z01")+" Z01 "
			cQuery += "WHERE Z01.Z01_FILIAL='"+xFilial("Z01")+"' AND "
			cQuery += "Z01.Z01_COD = '"+cLacre+"'  AND "
			cQuery += "Z01.Z01_INIC > " + AllTrim(Str(nLacreFim)) + " AND "
			cQuery += "Z01.D_E_L_E_T_<>'*' "

			cQuery := ChangeQuery( cQuery )
			dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), 'TMP' )
			lOk := .t.                   
			IF !TMP->(EOF())
				lOk := .f.
			ENDIF								
			TMP->(dbCloseArea())
										
			If lOk
				RecLock("Z00",.f.)
				Z00->Z00_LACRE  := Z00->Z00_LACRE - (nQuant)
				Z00->(MsUnlock())
			Endif
		
			dbselectarea("Z01")
			DBSETORDER(1)
			IF DBSEEK(XFILIAL("Z01") + cLacre + cNumSc5 + cItem)
				RECLOCK("Z01",.F.)
				Z01->(DBDELETE())
				Z01->(MSUNLOCK())
			ENDIF	
		
//			U_ChkLacre(cLacre)
		ENDIF									
    Endif
Next		
n := _N

RestArea(aAreaSUA)
RestArea(aAreaSUB)

Return _lRet

