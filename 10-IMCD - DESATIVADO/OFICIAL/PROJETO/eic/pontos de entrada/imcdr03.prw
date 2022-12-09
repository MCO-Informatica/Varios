#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH" 
#INCLUDE "SET.CH" 

User Function IMCDR03()

	Local lConf := .F.

	Local aArea    := GetArea()
	Local aParam   := {}
	Local aStruct  := {}
	Local cTitulo  := "Shipping Instructions"
	Local cCodPro  := ""
	Local cLotPro  := ""
	Local cArmPro  := ""
	Local cPathCli := ""
	Local cPathSrv := ""
	Local cOrdemP	:= ""
	Local nCopias	 := 0
	Local oWord    := Nil
	Local j := 0
	Local cQuery 	:= ""  
	Local i := 0
	Local nX := 0

  	cPathSrv := "\comex\" //GetMv("MV_PATHETQ")

	If Select("WK_SW2") > 0
		WK_SW2->( dbCloseArea() )
	EndIf

	cQueryP :=  " select SA2FORN.A2_CONTATO ,   "
	cQueryP += " SYTIMP.YT_NOME, SYTIMP.YT_CGC, SYTIMP.YT_ENDE, SYTIMP.YT_CIDADE, SYTIMP.YT_ESTADO, SYTIMP.YT_PAIS , "
	cQueryP += " SW2.W2_REFCLI, SW2.W2_PO_NUM, SW2.W2_INCOTER, Y9DEST.Y9_DESCR AS DESCDEST, Y9ORIG.Y9_DESCR AS DESCORIG , SW2.W2_PO_DT, "
	cQueryP += " SY6.Y6_DESC_I,"
	cQueryP += " SW3.W3_QTDE, SW3.W3_TEC, SW3.W3_QTDE, SW3.W3_UM, B1_ANUENTE, SW3.W3_POSICAO, SW3.W3_XWEEK, SB1.B1_CASNUM," 
	cQueryP += " SB1.B1_DESC "
	cQueryP += " from "+RetSqlName("SW2")+" SW2 "
	cQueryP += " LEFT JOIN "+RetSqlName("SA2")+" SA2FORN ON SW2.W2_FORN = SA2FORN.A2_COD   "
	cQueryP += " LEFT JOIN "+RetSqlName("SYT")+" SYTIMP ON SW2.W2_IMPORT = SYTIMP.YT_COD_IMP"
	cQueryP += " LEFT JOIN "+RetSqlName("SW3")+" SW3 ON SW2.W2_PO_NUM = SW3.W3_PO_NUM "
	cQueryP += " LEFT JOIN "+RetSqlName("SB1")+" SB1 ON SW3.W3_COD_I = SB1.B1_COD        "
	cQueryP += " LEFT JOIN "+RetSqlName("SY6")+" SY6 ON SW2.W2_COND_PA = SY6.Y6_COD "                                  
	cQueryP += " LEFT JOIN "+RetSqlName("SYR")+" SYR ON SYR.YR_VIA = SW2.W2_TIPO_EM AND SW2.W2_ORIGEM = SYR.YR_ORIGEM AND SW2.W2_DEST = SYR.YR_DESTINO "
	cQueryP += " LEFT JOIN "+RetSqlName("SY9")+" Y9ORIG ON SYR.YR_ORIGEM = Y9ORIG.Y9_SIGLA   "
	cQueryP += " LEFT JOIN "+RetSqlName("SY9")+" Y9DEST ON SYR.YR_DESTINO = Y9DEST.Y9_SIGLA  "                             
	cQueryP += " WHERE SW2.W2_PO_NUM = '" + SW2->W2_PO_NUM + "' AND SW3.W3_SEQ = '1' "
	cQueryP += " ORDER BY SW3.W3_POSICAO "
	TCQUERY Changequery(cQueryP) NEW ALIAS "WK_SW2"

	DbSelectArea("WK_SW2")
	DbGotop()

	cPathCli := GetTempPath(.T.)
	cFileName := "SHIPPING.docm"  
	cPathSrv += cFileName 

		If File(cPathCli + cFileName) .And. fErase(cPathCli + cFileName) <> 0
			MsgAlert("Não foi possível excluir o arquivo temporário. Feche todos os documentos word.", cTitulo)
			Return()
		ElseIf !CpyS2T(cPathSrv, cPathCli)
			MsgAlert("Não foi possível copiar o modelo do servidor. Verifique o parametro." + cPathSrv, cTitulo)
			Return()
		Else
		Endif

	oWord := OLE_CreateLink('TMsOleWord97')
	OLE_SetProperty(oWord, 206, .F.)  // SetProperty 206 visibilidade da janela
	OLE_OpenFile(oWord, cPathCli + cFileName)

    While WK_SW2->(!EOF())
    	j++             
    	aParam   := {}
		aAdd(aParam, {"dDatabase", DtoC(dDatabase), "D"})
//			aAdd(aParam, {"nTotItens", Len(aStruct), "N"})			
		aStruct := WK_SW2->(DbStruct())
		For i := 1 To Len(aStruct)
			IF substr(aStruct[i,1],4,15) == "PAIS"
				chkfile("SYA")
				aAdd(aParam, {aStruct[i,1], ALLTRIM(GetAdvFVal("SYA","YA_PAIS_I",xFilial("SYA")+WK_SW2->YT_PAIS,1 )) }) 
			Elseif substr(aStruct[i,1],4,15) == "ANUENTE"
				aAdd(aParam, {aStruct[i,1], iif(WK_SW2->(FieldGet(FieldPos(aStruct[i,1])))='1',"Yes","No") }) 	                                     	
			Else
				aAdd(aParam, {aStruct[i,1], WK_SW2->(FieldGet(FieldPos(aStruct[i,1]))) })
			ENdif
		Next   	

		for nX := 1 to Len(aParam)
    	    if !(aParam[nX,1] $ "W3_POSICAO/B1_DESC/W3_TEC/B1_ANUENTE/B1_CASNUM/W2_PO_DT")
				OLE_SetDocumentVar(oWord, aParam[nX,1], aParam[nX,2])            
			Elseif aParam[nX,1] $ "W2_PO_DT"
				OLE_SetDocumentVar(oWord, aParam[nX,1], alltrim(dtoc(stod( aParam[nX,2] )))  )            
			Endif	
        Next nX

		OLE_SetDocumentVar(oWord,"W3_POSICAO"+AllTrim(Str(j)),aParam[aScan(aParam, {|x| x[1] == "W3_POSICAO"}),2])
   		OLE_SetDocumentVar(oWord,"B1_DESC"+AllTrim(Str(j))   ,aParam[aScan(aParam, {|x| x[1] == "B1_DESC"}),2])
		OLE_SetDocumentVar(oWord,"W3_TEC"+AllTrim(Str(j))    ,aParam[aScan(aParam, {|x| x[1] == "W3_TEC"}),2])
		OLE_SetDocumentVar(oWord,"B1_ANUENTE"+AllTrim(Str(j)),aParam[aScan(aParam, {|x| x[1] == "B1_ANUENTE"}),2])
		OLE_SetDocumentVar(oWord,"B1_CASNUM"+AllTrim(Str(j)) ,aParam[aScan(aParam, {|x| x[1] == "B1_CASNUM"}),2])		

     	WK_SW2->(dbSkip())
	Enddo     	
	OLE_SetDocumentVar(oWord,"nTotItens",j)
	OLE_ExecuteMacro(oWord,"tabitens")

	OLE_UpDateFields(oWord)
	If Aviso("Impressão do shipping instruction", "Deseja visualizar ou imprimir?", {"Visualizar", "Imprimir"}, 1) == 2
		OLE_PrintFile(oWord,"ALL",,, nCopias)
		Sleep(1000)
		OLE_CloseFile(oWord)
		OLE_CloseLink(oWord)
	Else
		OLE_SaveFile(oWord)
		OLE_CloseFile(oWord)
		OLE_CloseLink(oWord)
		ShellExecute("Open", cFileName ,"", cPathCli, 3)
	EndIf

Return

