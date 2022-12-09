#INCLUDE "Protheus.ch"
#INCLUDE "RwMake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F050INC   ºAutor  ³                    º Data ³  04/10/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para vincular projeto ao titulo           º±±
±±º          ³ financeiro.                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function F050INC

    Local _aArea := GetArea()
    Local nValAFR := 0
    Local _lRet := .t.
    Private lPassou := .F.


//PmsDlgSC(3,cA110Num)

    dbSelectArea("AFR")
    dbSetOrder(2)

    If !dbSeek(xFilial("AFR")+M->E2_PREFIXO+M->E2_NUM+M->E2_PARCELA+M->E2_TIPO+M->E2_FORNECE+M->E2_LOJA,.F.)
        PMSPROJFI(3,M->E2_PREFIXO,M->E2_NUM,M->E2_PARCELA,M->E2_TIPO,M->E2_FORNECE,M->E2_LOJA)
    Else
        lPassou := .T.
    Endif

    nValAFR := 0
    For nX := 1 to Len(aRatAFR[1][2])
        nValAFR += aRatAFR[1][2][nX][4]
    Next

    If nValAFR <> M->E2_VALOR
        Alert("Valor Total diferente")
        _lRet := .F.
    Endif

/*If nValAFR <> M->E2_VALOR
	Alert("Valor Total diferente")
	PMSPROJFI(3,M->E2_PREFIXO,M->E2_NUM,M->E2_PARCELA,M->E2_TIPO,M->E2_FORNECE,M->E2_LOJA)
	
	nValAFR := 0
    For nX := 1 to Len(aRatAFR[1][2])
		nValAFR += aRatAFR[1][2][nX][4]
    Next
	
    If nValAFR <> M->E2_VALOR
		Alert("Valor Total diferente")
		PMSPROJFI(3,M->E2_PREFIXO,M->E2_NUM,M->E2_PARCELA,M->E2_TIPO,M->E2_FORNECE,M->E2_LOJA)
		
        For nX := 1 to Len(aRatAFR[1][2])
			nValAFR += aRatAFR[1][2][nX][4]
        Next
		
        If nValAFR <> M->E2_VALOR
			Alert("Valor Total diferente")
			PMSPROJFI(3,M->E2_PREFIXO,M->E2_NUM,M->E2_PARCELA,M->E2_TIPO,M->E2_FORNECE,M->E2_LOJA)
			
			nValAFR := 0
            For nX := 1 to Len(aRatAFR[1][2])
				nValAFR += aRatAFR[1][2][nX][4]
            Next
			
            If nValAFR <> M->E2_VALOR
				Alert("Valor Total diferente")
				PMSPROJFI(3,M->E2_PREFIXO,M->E2_NUM,M->E2_PARCELA,M->E2_TIPO,M->E2_FORNECE,M->E2_LOJA)
				
				nValAFR := 0
                For nX := 1 to Len(aRatAFR[1][2])
					nValAFR += aRatAFR[1][2][nX][4]
                Next
				
                If nValAFR <> M->E2_VALOR
					Alert("Valor Total diferente")
					PMSPROJFI(3,M->E2_PREFIXO,M->E2_NUM,M->E2_PARCELA,M->E2_TIPO,M->E2_FORNECE,M->E2_LOJA)
					
					nValAFR := 0
                    For nX := 1 to Len(aRatAFR[1][2])
						nValAFR += aRatAFR[1][2][nX][4]
                    Next
					
                    If nValAFR <> M->E2_VALOR
						Alert("Valor Total diferente")
						PMSPROJFI(3,M->E2_PREFIXO,M->E2_NUM,M->E2_PARCELA,M->E2_TIPO,M->E2_FORNECE,M->E2_LOJA)
						
						nValAFR := 0
                        For nX := 1 to Len(aRatAFR[1][2])
							nValAFR += aRatAFR[1][2][nX][4]
                        Next
                        If nValAFR <> M->E2_VALOR
							Alert("Valor Total diferente")
							PMSPROJFI(3,M->E2_PREFIXO,M->E2_NUM,M->E2_PARCELA,M->E2_TIPO,M->E2_FORNECE,M->E2_LOJA)
							
							nValAFR := 0
                            For nX := 1 to Len(aRatAFR[1][2])
								nValAFR += aRatAFR[1][2][nX][4]
                            Next
							
                            If nValAFR <> M->E2_VALOR
								Alert("Valor Total diferente")
								PMSPROJFI(3,M->E2_PREFIXO,M->E2_NUM,M->E2_PARCELA,M->E2_TIPO,M->E2_FORNECE,M->E2_LOJA)
								
								nValAFR := 0
                                For nX := 1 to Len(aRatAFR[1][2])
									nValAFR += aRatAFR[1][2][nX][4]
                                Next
                            EndIf
							
                        EndIf
						
                    EndIf
					
                EndIf
				
            EndIf

        EndIf

    EndIf

Endif
*/

RestArea(_aArea)

Return(_lRet)


Static Function PMSPROJFI(nOpcao,cPrefixo,cNum,cParcela,cTipo,cFornece,cLoja,lDlg)

    Local bSavSetKey	:= SetKey(VK_F4,Nil)
    Local bSavKeyF5   := SetKey(VK_F5,Nil)
    Local bSavKeyF6   := SetKey(VK_F6,Nil)
    Local bSavKeyF7   := SetKey(VK_F7,Nil)
    Local bSavKeyF8   := SetKey(VK_F8,Nil)
    Local bSavKeyF9   := SetKey(VK_F9,Nil)
    Local bSavKeyF10  := SetKey(VK_F10,Nil)
    Local oGetDados
    Local lOk         := .T.
    Local oDlg,oBold
    Local nPosRat		:= aScan(aRatAFR,{|x| x[1] == "01"})
    Local lGetDados	:= .T.
    Local nY          := 0
    Local nLenCols		:= 0
    Local nLenHeader	:= 0
    Local lValido		:= .T.
    Local lFA050PMS	:= ExistBlock("FA050PMS")
    Local aAlter      := {"AFR_PROJET","AFR_TAREFA", "AFR_TIPOD", "AFR_VALOR1" }
    Local lPmsAFRCpo := ExistBlock("PmsAFRCpo",.F.,.F.,{aAlter})

    PRIVATE aCols	:= {}
    PRIVATE aHeader	:= {}
    DEFAULT lDlg := .T.

    If lPmsAFRCpo
        aAlter := ExecBlock("PmsAFRCpo", .F., .F., {aAlter})
    EndIf


    If !PmsVldtit(2)  // Funçao que validará se o titulo foi gerado via NFE.
        Aviso("Atenção!" , "Este título não poderá ser novamente amarrado a um projeto pois foi originado de uma nota fiscal de entrada já com amarração a um projeto e tarefa." ,{"OK"},2) //"Atenção!", "Este título não poderá ser novamente amarrado a um projeto pois foi originado de uma nota fiscal de entrada já com amarração a um projeto e tarefa."

        lValido := .F.
    Endif

    If lValido .and. lFA050PMS // ponto de entrada existente somente para a rotina FINA050 (CP)
        lValido := Execblock("FA050PMS",.F.,.F.)
    Endif

    If lValido
        If nOpcao == 3
            //³ Montagem do aHeader                                          ³
            FillGetDados(nOpcao,"AFR",1,,,,,,,,{||.T.},.T.,aHeader)
            aHeaderAFR	:= aClone(aHeader)
            If nPosRat > 0
                aCols	:= aClone(aRatAFR[nPosRat,2])
            Else
                //³ Faz a montagem de uma linha em branco no aCols.              ³
                nLenHeader := Len(aHeader)
                aadd(aCols,Array(nLenHeader+1))
                For ny := 1 to nLenHeader
                    If Trim(aHeader[ny,2]) == "AFR_ITEM"
                        aCols[1,ny]	:= "01"
                    ElseIf AllTrim(aHeader[ny,2]) $ "AFR_ALI_WT | AFR_REC_WT"
                        If AllTrim(aHeader[ny,2]) == "AFR_ALI_WT"
                            aCols[1,ny] := "AFR"
                        ElseIf AllTrim(aHeader[ny,2]) == "AFR_REC_WT"
                            aCols[1,ny] := 0
                        EndIf
                    Else
                        aCols[1,ny] := CriaVar(aHeader[ny,2])
                    EndIf
                    aCols[1,nLenHeader+1] := .F.
                Next ny
            EndIf
        Else
            //³ Montagem do aHeader                                          ³
            FillGetDados(nOpcao,"AFR",1,,,,,,,,{||.T.},.T.,aHeader)
            aHeaderAFR	:= aClone(aHeader)
            dbSelectArea("AFR")
            dbSetOrder(2)
            If nPosRat == 0
                nLenHeader := Len(aHeader)
                If MsSeek(xFilial()+cPrefixo+cNum+cParcela+cTipo+cFornece+cLoja)
                    While !Eof() .And. xFilial()+cPrefixo+cNum+cParcela+cTipo+cFornece+cLoja==;
                            AFR_FILIAL+AFR_PREFIX+AFR_NUM+AFR_PARCEL+AFR_TIPO+AFR_FORNEC+AFR_LOJA
                        If AFR->AFR_REVISA==PmsAF8Ver(AFR->AFR_PROJET)
                            aADD(aCols,Array(nLenHeader+1))
                            nLenCols := Len(aCols)
                            For ny := 1 to nLenHeader
                                If ( aHeader[ny,10] != "V")
                                    aCols[nLenCols,ny] := FieldGet(FieldPos(aHeader[ny,2]))
                                ElseIf AllTrim(aHeader[ny,2]) $ "AFR_ALI_WT | AFR_REC_WT"
                                    If AllTrim(aHeader[ny,2]) == "AFR_ALI_WT"
                                        aCols[1,ny] := "AFR"
                                    ElseIf AllTrim(aHeader[ny,2]) == "AFR_REC_WT"
                                        aCols[1,ny] := AFR->(Recno())
                                    EndIf
                                Else
                                    aCols[nLenCols,ny] := CriaVar(aHeader[ny,2])
                                EndIf
                                aCols[nLenCols,nLenHeader+1] := .F.
                            Next ny
                        EndIf
                        dbSkip()
                    End
                EndIf
                If Empty(aCols)
                    //³ Faz a montagem de uma linha em branco no aCols.              ³
                    aadd(aCols,Array(nLenHeader+1))
                    For ny := 1 to nLenHeader
                        If Trim(aHeader[ny,2]) == "AFR_ITEM"
                            aCols[1,ny] 	:= "01"
                        ElseIf AllTrim(aHeader[ny,2]) $ "AFR_ALI_WT | AFR_REC_WT"
                            If AllTrim(aHeader[ny,2]) == "AFR_ALI_WT"
                                aCols[1,ny] := "AFR"
                            ElseIf AllTrim(aHeader[ny,2]) == "AFR_REC_WT"
                                aCols[1,ny] := 0
                            EndIf
                        Else
                            aCols[1,ny] := CriaVar(aHeader[ny,2])
                        EndIf
                        aCols[1,nLenHeader+1] := .F.
                    Next ny
                EndIf
            Else
                aCols := aClone(aRatAFR[nPosRat][2])
            EndIf
        EndIf

        If lGetDados .And. lDlg
            DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
            DEFINE MSDIALOG oDlg FROM 88,22  TO 350,619 TITLE 'Assistente de Apontamentos : Gerenciamento de Projetos - Despesas' Of oMainWnd PIXEL Style 128 //oDlg:lEscClose := .F. //'Assistente de Apontamentos : Gerenciamento de Projetos - Despesas'
            @ 16 ,3   TO 18 ,310 LABEL '' OF oDlg PIXEL
            @ 6,10 SAY "Documento : "+cPrefixo+"-"+cNum+cParcela SIZE 150,7 OF oDlg PIXEL //"Documento : "
            oGetDados := MSGetDados():New(23,3,112,296,nOpcao,'PMSAFRLOK','PMSAFRTOK','+AFR_ITEM',.T.,aAlter,,,GetNewPar("MV_NUMLIN", 9999),'PMSAFRFOK')
            @ 118,249 BUTTON 'Confirma' SIZE 35 ,9   FONT oDlg:oFont ACTION {||If(oGetDados:TudoOk(),(lOk:=.T.,oDlg:End()),(lOk:=.F.))}  OF oDlg PIXEL  //'Confirma'
            //			@ 118,210 BUTTON STR0028 SIZE 35 ,9   FONT oDlg:oFont ACTION (lOk:=.F., oDlg:End() ) OF oDlg PIXEL  //'Cancelar'
            //	      If ExistBlock("PMSFISCR")
            //	         ExecBlock("PMSFISCR",.F.,.F.,{oDlg,nOpcao})
            //	      Endif
            ACTIVATE MSDIALOG oDlg CENTERED
        EndIf

        If nOpcao <> 2 .And. lOk
            If nPosRat > 0
                aRatAFR[nPosRat][2]	:= aClone(aCols)
            Else
                aADD(aRatAFR,{"01",aClone(aCols)})
            EndIf

            //		If ExistBlock("PMSDLGFI")
            //			U_PMSDLGFI(aCols,aHeader)
            //		EndIf
            lPassou := .T.
        EndIf
    Endif

    SetKey(VK_F4,bSavSetKey)
    SetKey(VK_F5,bSavKeyF5)
    SetKey(VK_F6,bSavKeyF6)
    SetKey(VK_F7,bSavKeyF7)
    SetKey(VK_F8,bSavKeyF8)
    SetKey(VK_F9,bSavKeyF9)
    SetKey(VK_F10,bSavKeyF10)

Return
