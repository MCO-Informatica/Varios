#include "rwmake.ch"
#include "protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT110LOK  บAutor  ณ                    บ Data ณ  08-10-12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Abre a tela para amarrar o projeto ao Solicitacao de Comprasบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function MT110LOK()

    Local nQtdAFG	:= 0
    Local _aArea := GetArea()
    Local nPosAFG := 0
    Private lPassou := .F.
    _lRet 		:= .t.

//PmsDlgSC(3,cA110Num)
    PMSPROJSC(3,cA110Num)

    nPosAFG := aScan(aRatAFG,{|aRatAFG| aRatAFG[1] == aCols[n][1]})
    For nX := 1 to Len(aRatAFG[nPosAFG][2])
        nQtdAFG += aRatAFG[nPosAFG][2][nX][3]
    Next
    If aCols[n][7] <> nQtdAFG//aRatAFG[n-1][2][1][3]
        _lRet := .F.
        Alert("Quantidade do Item diferente da Quantidade distribuida no(s) projeto(s)")
    Endif

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPMSPROJSC บAutor  ณ                    บ Data ณ  08-10-12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑณDescri…o ณEsta funcao cria uma janela para configuracao e utilizacao   ณฑฑ
ฑฑณ          ณdo Solocitacao de Compras a um dterminado projeto.           ณฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function PMSPROJSC(nOpcao,cNumSC,lGetDados)

    Local oDlg
    Local nPosPerc		:= 0
    Local nPosItem		:= aScan(aHeader,{|x| Alltrim(x[2]) == "C1_ITEM"})
    Local nQuantSC		:= aCols[n][aScan(aHeader,{|x| Alltrim(x[2]) == "C1_QUANT"})]
    Local cItemSC		:= aCols[n][nPosItem]
    Local nPosRat		:= aScan(aRatAFG,{|x| x[1] == aCols[n][nPosItem]})
    Local aSavCols		:= {}
    Local aSavHeader	:= {}
    Local nSavN			:= n
    Local oGetDados
    Local nY			:= 0
    Local nPosProj		:= aScan(aHeader,{|x| Alltrim(x[2]) == "C1_PROJET"})
    Local nPosVersao	:= aScan(aHeader,{|x| Alltrim(x[2]) == "C1_REVISA"})
    Local nPosTaref		:= aScan(aHeader,{|x| Alltrim(x[2]) == "C1_TAREFA"})
    Local nPosTrt		:= aScan(aHeader,{|x| Alltrim(x[2]) == "C1_TRT"})
    Local bSavKeyF10	:= SetKey(VK_F10,Nil)
    Local lMsFilAFG		:= AFG->(FieldPos("AFG_MSFIL")) > 0
    Local cProduto		:= ""
    Local lPcOk			:= .T.
    Local nOpcMsg		:= 0
    Local cNumSA		:= ""
    Local aAlter		:= {"AFG_PROJET","AFG_TAREFA", "AFG_QUANT", "AFG_QTSEGU" }
    Local lPmsAFGCpo  := ExistBlock("PmsAFGCpo")
    Private aSC1Itens	:= {}
    Private lOk
    DEFAULT lGetDados	:= .T.

//Verifica se a SC teve origem de uma Solicitacao de Armazem
    SCP->(dbSetOrder(2)) //utilizado o indice 2 pois nao existe o indice no campo SCP->(CP_NUMSC+CPITSC)
    If nOpcao!=6 .And. SCP->(DbSeek(xFilial("SCP")+aCols[n,2]))
        cProduto := SCP->(CP_FILIAL+CP_PRODUTO)
        While !SCP->(Eof()) .And. SCP->(CP_FILIAL+CP_PRODUTO)==cProduto
            If SCP->(CP_NUMSC+CP_ITSC)==cNumSC+aCols[n,1]
                lPcOk  := .F.
                cNumSA := SCP->CP_NUM
            EndIf
            cProduto := SCP->(CP_FILIAL+CP_PRODUTO)
            SCP->(DbSkip())
        EndDo
    EndIf
    If lPcOk
        // Array aSC1Itens criado como private para uso da fun็ใo PMSAvalEmp (PMSXFUNA)
        // onde precisarei do produto e local da linha da SC para verificar possivel
        // existencia de empenho perneta e amarra-lo com a nova SC
        aadd(aSC1Itens, {"C1_PRODUTO", aCols[n][aScan(aHeader,{|x| Alltrim(x[2]) == "C1_PRODUTO"})]})
        aadd(aSC1Itens, {"C1_LOCAL", aCols[n][aScan(aHeader,{|x| Alltrim(x[2]) == "C1_LOCAL"})]})
        aSavCols	:= aClone(aCols)
        aSavHeader	:= aClone(aHeader)
        nSavN		:= n
        n			:= 1
        aCols		:= {}
        aHeader		:= {}

        nQtMaxSC	:= nQuantSC

        If nOpcao == 3 //Inclusao do registro no AFG
            //ณ Montagem do aHeader											ณ

            FillGetDados(nOpcao,"AFG",1,,,,,,,,{||.T.},.T.,aHeader)
            nPosPerc	:= aScan(aHeader,{|x|Alltrim(x[2])=="AFG_QUANT"})

            aHeaderAFG	:= aClone(aHeader)
            If nPosRat > 0
                aCols	:= aClone(aRatAFG[nPosRat,2])
            Else
                //ณ Faz a montagem de uma linha em branco no aCols.				ณ
                nLenHeader := Len(aHeader)
                aadd(aCols,Array(nLenHeader+1))
                For ny := 1 to nLenHeader
                    If Trim(aHeader[ny,2]) == "AFG_ITEM"
                        aCols[1,ny] 	:= "01"
                    ElseIf AllTrim(aHeader[ny,2]) $ "AFG_ALI_WT | AFG_REC_WT"
                        If AllTrim(aHeader[ny,2]) == "AFG_ALI_WT"
                            aCols[1,ny] := "AFG"
                        ElseIf AllTrim(aHeader[ny,2]) == "AFG_REC_WT"
                            aCols[1,ny] := 0
                        EndIf
                    Else
                        aCols[1,ny] := CriaVar(aHeader[ny,2])
                    EndIf
                    aCols[1,nLenHeader+1] := .F.
                Next ny
            EndIf
        Else //Alteracao do registro no AFG
            //ณ Montagem do aHeader											ณ
            FillGetDados(nOpcao,"AFG",1,,,,,,,,{||.T.},.T.,aHeader)
            nPosPerc	:= aScan(aHeader,{|x|Alltrim(x[2])=="AFG_QUANT"})

            aHeaderAFG	:= aClone(aHeader)
            dbSelectArea("AFG")
            dbSetOrder(2)
            If nPosRat == 0
                nLenHeader := Len(aHeader)
                If MsSeek(xFilial()+cNumSC+cItemSC)
                    While !Eof() .And. xFilial()+cNumSC+cItemSC==;
                            AFG_FILIAL+AFG_NUMSC+AFG_ITEMSC
                        If !lMsFilAFG .Or. (lMsFilAFG .And. AFG->AFG_MSFIL == cFilAnt)
                            If AFG->AFG_REVISA==PmsAF8Ver(AFG->AFG_PROJET)
                                aADD(aCols,Array(nLenHeader+1))
                                nLenCols := Len(aCols)
                                For ny := 1 to nLenHeader
                                    If ( aHeader[ny,10] != "V")
                                        aCols[nLenCols,ny] := FieldGet(FieldPos(aHeader[ny,2]))
                                    ElseIf AllTrim(aHeader[ny,2]) $ "AFG_ALI_WT | AFG_REC_WT"
                                        If AllTrim(aHeader[ny,2]) == "AFG_ALI_WT"
                                            aCols[nLenCols,ny] := "AFG"
                                        ElseIf AllTrim(aHeader[ny,2]) == "AFG_REC_WT"
                                            aCols[nLenCols,ny] := AFG->(Recno())
                                        EndIf
                                    Else
                                        aCols[nLenCols,ny] := CriaVar(aHeader[ny,2])
                                    EndIf
                                    aCols[nLenCols,nLenHeader+1] := .F.
                                Next ny
                            EndIf
                        EndIf
                        dbSkip()
                    End
                EndIf
                If Empty(aCols)
                    //ณ Faz a montagem de uma linha em branco no aCols.				ณ
                    aadd(aCols,Array(nLenHeader+1))
                    For ny := 1 to nLenHeader
                        If Trim(aHeader[ny,2]) == "AFG_ITEM"
                            aCols[1,ny] 	:= "01"
                        ElseIf AllTrim(aHeader[ny,2]) $ "AFG_ALI_WT | AFG_REC_WT"
                            If AllTrim(aHeader[ny,2]) == "AFG_ALI_WT"
                                aCols[1,ny] := "AFG"
                            ElseIf AllTrim(aHeader[ny,2]) == "AFG_REC_WT"
                                aCols[1,ny] := 0
                            EndIf
                        Else
                            aCols[1,ny] := CriaVar(aHeader[ny,2])
                        EndIf
                        aCols[1,nLenHeader+1] := .F.
                    Next ny
                Else
                    aADD(aRatAFG,{aSavCols[nSavN,nPosItem],aClone(aCols)})
                EndIf
            Else
                aCols := aClone(aRatAFG[nPosRat,2])
            EndIf
        EndIf
        If lPmsAFGCpo
            aAlter := aClone(Execblock("PmsAFGCpo", .F.,.F.,{aAlter,aHeader,aCols}))
        Endif
        //Grava na variavel privada para ser utilizada na rotina chamadora
        aHdrAFG	:=	aClone(aHeaderAFG)
        If lGetDados
            DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
            DEFINE MSDIALOG oDlg FROM 88 ,22  TO 350,619 TITLE "Gerenciamento de Projetos - SC" Of oMainWnd PIXEL Style 128 //"Gerenciamento de Projetos - SC"
            oGetDados := MSGetDados():New(23,3,112,296,nOpcao,"PMSAFGLOK","PMSAFGTOK",'+AFG_ITEM',.T.,aAlter,1,,100,"PMSAFGFOK()",,,"PMSAFGDEL("+str(nopcao)+")",oDlg)
            @ 16 ,3   TO 18 ,310 LABEL '' OF oDlg PIXEL
            @ 6  ,10   SAY "Num. SC" Of oDlg PIXEL SIZE 27 ,9  //"Num. SC"
            @ 5  ,35  SAY  cNumSC+"/"+cItemSC Of oDlg PIXEL SIZE 40,9 FONT oBold
            @ 6  ,190 SAY "Quantidade" Of oDlg PIXEL SIZE 30 ,9  //"Quantidade"
            @ 5  ,230 MSGET nQuantSC Picture "@E 999,999,999.99" When .F. PIXEL SIZE 65,9
            @ 118,249 BUTTON 'Confirma' SIZE 35 ,9   FONT oDlg:oFont ACTION {||If(oGetDados:TudoOk(),(lOk:=.T.,oDlg:End()),(lOk:=.F.))}  OF oDlg PIXEL  //'Confirma'
//			@ 118,210 BUTTON STR0028 SIZE 35 ,9   FONT oDlg:oFont ACTION (oDlg:End())  OF oDlg PIXEL  //'Cancelar'
            If ExistBlock("PMSSCSCR")
                ExecBlock("PMSSCSCR",.F.,.F.,{oDlg,nOpcao})
            Endif
            ACTIVATE MSDIALOG oDlg CENTERED
        EndIf

        If nOpcao <> 2 .And. lOk
            nPosRat := aScan(aRatAFG,{|x| x[1] == AllTrim(cItemSC)})
            If nPosRat > 0
                aRatAFG[nPosRat][2]	:= aClone(aCols)
            Else
                aADD(aRatAFG,{aSavCols[nSavN][nPosItem],aClone(aCols)})
            EndIf
//		If ExistBlock("PMSDLGSC")
//			U_PMSDLGSC(aCols,aHeader,aSavCols,aSavHeader,nSavN)
//		EndIf
            lPassou := .T. //Incluido por Felipe
        EndIf
        // Restaura ambiente do pedido de compras
        aCols	:= aClone(aSavCols)
        aHeader	:= aClone(aSavHeader)
        n		:= nSavN
        If nPosProj>0 .and. lOk
            acols[n][nPosProj]	:=	SPACE(TAMSX3("C1_PROJET")[1])
            acols[n][nPosVersao]	:=	SPACE(TAMSX3("C1_REVISA")[1])
            acols[n][nPosTaref]	:=	SPACE(TAMSX3("C1_TAREFA")[1])
            acols[n][nPosTrt]		:=	SPACE(TAMSX3("C1_TRT")[1])
        EndIf
    Else
        //"Este item da Solicita็ใo de Compras esta relacionado a uma Solicita็ใo ao Armaz้m amarrado a um projeto/tarefa e nใo poderแ ser alterada. Utilize a rotina de manuten็ใo de solicita็๕es ao armaz้m ou verifique o item selecionado"###"Fechar"###"Visualiza SA"
//	nOpcMsg := Aviso(STR0143,STR0375,If(nOpcao<>1,{STR0006,STR0415},{STR0006}),2)  
        If nOpcMsg == 2
            MaViewSA(cNumSA)
        EndIf
    EndIf

    SetKey(VK_F10,bSavKeyF10)

Return ()