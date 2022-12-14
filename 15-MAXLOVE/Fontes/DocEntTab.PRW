#Include "Protheus.ch"
#Include "TopConn.ch"


User Function DocEntTab()
	Local lRet   := .T.
	Local cSql   := ""
	Local aArea  := GetArea()

	If c103TP <> "N"
		Return .T.
	EndIf

	dbSelectArea("SA2")
	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial("SA2")+CA100FOR+cLoja,.f.))

	If SA2->A2_X_TABPR$"S" .AND. M->D1_COD <> "GENERICO"

		cSql := "SELECT * FROM "+RetSqlName("AIB")+" AIB WHERE AIB.D_E_L_E_T_=' ' AND AIB.AIB_CODFOR = '"+CA100FOR+"' AND AIB.AIB_LOJFOR = '"+cLoja+"' AND AIB.AIB_CODPRO = '"+IIF(ValType(M->D1_COD)=="U",aCols[n][2],M->D1_COD)+"' AND AIB.AIB_CODTAB IN ('NF','VL') "

		TCQuery cSql New Alias "QRY"

		If Eof() == .F.
			While Eof() == .F.
			
				If (QRY->AIB_XSTATS <> "S") 
					MsgAlert("Tabela de pre?o n?o aprovada pela Diretoria. N?o ser? permitido digitar o pedido de compra.")
					lRet         := .F.
					aCols[N,Ascan(aHeader, {|x| Alltrim(x[2]) == "D1_TES"   })] := ""
					aCols[N,Ascan(aHeader, {|x| Alltrim(x[2]) == "D1_CF"    })] := ""
					aCols[N,Ascan(aHeader, {|x| Alltrim(x[2]) == "D1_COD"   })] := ""
					Exit
				EndIf
			
				QRY->(dbSkip())
			EndDo
		Else
			MsgAlert("N?o existe nenhuma tabela de pre?o para o produto "+Alltrim(IIF(ValType(M->D1_COD)=="U",aCols[n][2],M->D1_COD))+". N?o ser? permitido digitar o pedido de compra.")
			lRet         := .F.
			aCols[N,Ascan(aHeader, {|x| Alltrim(x[2]) == "D1_TES"   })] := ""
			aCols[N,Ascan(aHeader, {|x| Alltrim(x[2]) == "D1_CF"    })] := ""
			aCols[N,Ascan(aHeader, {|x| Alltrim(x[2]) == "D1_COD"   })] := ""
		EndIf
	
		QRY->(DbCloseArea())

	Else
		MsgAlert("Este produto nao ? controlado por tabela de pre?o!","Aten??o")
		lRet := .T.
	EndIF

	RestArea(aArea)
Return lRet
