#Include "Protheus.ch"
#Include "Totvs.ch"
#Include "FwMvcDef.ch"
#Include "FileIo.ch"

// Para realizar a importação necessario informar alias no primeiro campo exemplo DA1
// e no final da importação colocar #
// funciona somente com planilhas CSV




User Function RESTA99()
    CriaPerg()
    
    Pergunte("CSVIMP",.T.)

    Processa( {|| Import() }, "Aguarde...", "Atualizando dados...",.F.)

    Alert("Processo Finalizado!", "Atenção")
    
Return

Static Function Import()

Local cLinha  := ""
Local aCabec  := {}
Local aDados  := {}
Local lCabec  := .F.
Local lTab    := .T.
Local nX, nPos, nPos2
Local nJ, nI
Local cGrava  := ""
Local cDados  := ""
Local lRet    := .F.
Local aIndice := {}
Local cIndice := ""
Local cTipo   := ""
Local aAux    := {}
Local nRegs, nY
Local nLin    := 3
Local cMsg    := ""
Local nCount  := 0
Private cTabela


Pergunte("CSVIMP",.F.)

FT_FUSE(MV_PAR01)
FT_FGOTOP()

While !FT_FEOF() 

     cLinha := Upper(FT_FREADLN())

    If lTab
        aTab := Separa(cLinha,";",.T.)
        lTab := .F.
    ElseIf lCabec
        aCabec := Separa(cLinha,";",.T.)
        lCabec := .F.
    Else
        If !"#" $ cLinha .And. !";;;" $ cLinha
            aAdd(aDados,Separa(cLinha,";",.T.))
            nCount++
        EndIf
    EndIf
    
    If Len(aCabec) <= 0
        lCabec := .T.
    EndIf
    
    FT_FSKIP()
EndDo

cTabela := aTab[1]
aAux := aClone(aTab)

ProcRegua(nCount)

DbSelectArea(aTab[1])

    For nX := 1 To Len(aDados)
        cDado := StrTran(AllTrim(aDados[nX][2]),'*','0' )
        nRegs := fPesquisar(aCabec,aDados[nX])
        If nRegs == 1
            RecLock((cTabela),.F.)
            For nY := 1 To Len(aDados[nX])
                nPos := aScan(aAux, {|x| "*" $ x})
                If nPos <> 0
	                aAux[nPos] := StrTran(aAux[nPos],"*","#")
	                cGrava := (cTabela)+"->"+(aCabec[nPos])
	                cTipo := Verify((aCabec[nPos]))
	                If cTipo $ "C"
	                	(cTabela)->&(aCabec[nPos]) := aDados[nX][nPos]
	                ElseIf cTipo $ "N"
	                	(cTabela)->&(aCabec[nPos]) := Val(aDados[nX][nPos])
	                Else
	                	(cTabela)->&(aCabec[nPos]) := cToD(aDados[nX][nPos])
	                EndIf
	            EndIf  
                If nY == Len(aDados[nX])               
                    Exit
                EndIf
            Next
            MsUnLock()
            aAux := aClone(aTab)
        ElseIf nRegs == 0
            DbSelectArea((cTabela))
            If RecLock((cTabela),.T.)
                For nJ := 1 To Len(aDados[nX])
                    cDado := StrTran(AllTrim(aDados[nX][nJ]),'*','0' )
                    cTipo := Verify((aCabec[nJ]))
                    cGrava := ""
                    cGrava := (cTabela)+"->"+aCabec[nJ]
                    If cTipo $ "C"
                        (cTabela)->&(aCabec[nJ]) := cDado
                    ElseIf cTipo $ "N"
                        (cTabela)->&(aCabec[nJ]) := Val(cDado)
                    Else
                        (cTabela)->&(aCabec[nJ]) := CToD(cDado)
                    EndIf
                    
                    If nJ == Len(aDados[nX])
                        Exit
                    EndIf
                Next
                MsUnLock()
            Else
                MsgInfo("não conseguiu dar LOCK.")
            Endif 
        Else
            cMsg += "Encontrado(s) ["+Alltrim(Str(nRegs))+"] registro(s) para a linha "+Alltrim(Str(nLin)) + CRLF   
        EndIf
        nLin++
        IncProc()
    Next

(cTabela)-(DbCloseArea())

	If !Empty(cMsg)
		cMsg := "Aumente os campos não alterados, de preferência campos chave para refinar a pesquisa e garantir a atualização. As linhas listadas abaixo não foram alteradas:" + CRLF + CRLF + cMsg
		Aviso("Problemas na atualização",cMsg,{"Ok"},3)
	EndIf

Return

Static Function CriaPerg()

Local aEstrut := {}
Local aGrava  := {}
Local cTit    := "Arquivo .CSV?"
Local nI, nJ

dbSelectArea('SX1')
SX1->(dbSetOrder(1))
If SX1->(!dbSeek('CSVIMP'))
	//::Monta a Estrutura do SX1
	aEstrut := {"X1_GRUPO"	,"X1_ORDEM"		,"X1_PERGUNT"	,"X1_PERSPA"	,"X1_PERENG"	,"X1_VARIAVL"	,;
				 "X1_TIPO"	,"X1_TAMANHO"	,"X1_DECIMAL"	,"X1_PRESEL"	,"X1_GSC"		,"X1_VALID"		,;
				 "X1_VAR01"	,"X1_DEF01"		,"X1_DEFSPA1"	,"X1_DEFENG1"	,"X1_CNT01"		,"X1_F3"		,;
				 "X1_PYME"	,"X1_GRPSXG"	,"X1_HELP"		,"X1_PICTURE"									}
	//::Adiciona os dados a gravar
	aADD(aGrava,{"CSVIMP"	,"01"			,cTit	    	,cTit		    ,cTit	    	,"mv_ch1"		,;
				 "C"		,75				,0				,0				,"F"			,""				,;
				 "MV_PAR01"	,"56"				,""				,""				,""				,""		    ,;
				 ""			,""				,""				,""												})
    
    //::Grava no SX1
	For nI:= 1 to len(aGrava)
		RecLock("SX1",.T.)
		For nJ:=1 To Len(aGrava[nI])
			If FieldPos(aEstrut[nJ])>0 .And. aGrava[nI,nJ] != NIL
				FieldPut(FieldPos(aEstrut[nJ]),aGrava[nI,nJ])
			EndIf
		Next nJ
		SX1->(msUnLock())
        
	Next nI

EndIf

Return

Static Function Verify(cCampo)

Local cTipo

DbSelectArea("SX3")
SX3->(DbSetOrder(2))

SX3->(DbSeek(cCampo))

cTipo := SX3->X3_TIPO

Return cTipo

Static Function fPesquisar(aCabec,aDados)

Local nQtd      := 0
Local cQuery    := ""
Local cAliasQry := GetNextAlias()
Local nI    
Local aAlt      := aClone(aTab)    

cQuery := "Select R_E_C_N_O_ RECORD from "+RetSqlName(cTabela)
cQuery += " Where D_E_L_E_T_ = ' '"
    For nI := 1 to Len(aCabec)
        If aAlt[nI] <> "*"
            cTipo := Verify((aCabec[nI]))
            cQuery += " And "
            cQuery += aCabec[nI]
            cQuery += " = "
            
            cDado  := StrTran( AllTrim(aDados[nI]), '*', '0' )
            If cTipo $ "C"
                cQuery += "'" + cDado + "'"
            Else
                cQuery += StrTran(cDado, ",", ".")
            EndIf
        EndIF
    Next

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)

While !(cAliasQry)->( EOF() )
    (cTabela)->(DbGoto((cAliasQry)->RECORD ))
    nQtd++
    (cAliasQry)->(DbSkip())
EndDo

(cAliasQry)->(DbCloseArea())

Return nQtd
