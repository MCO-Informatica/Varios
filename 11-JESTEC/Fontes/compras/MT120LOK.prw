#include "rwmake.ch"
#include "protheus.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT120LOK  �Autor  �                    � Data �  08-10-12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Abre a tela para amarrar o projeto ao Pedido de Compras    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function MT120LOK()

    Local nPosAJ7 := 0
    Local nQtdAJ7 := 0
    Local _aArea := GetArea()
    Private lPassou := .F.

    _lRet 		:= .t.

    PMSPROJPC(3,cA120Num)

    nPosAJ7 := aScan(aRatAJ7,{|aRatAJ7| aRatAJ7[1] == aCols[n][1]})
    For nX := 1 to Len(aRatAJ7[nPosAJ7][2])
        nQtdAJ7 += aRatAJ7[nPosAJ7][2][nX][3]
    Next
    If aCols[n][8] <> nQtdAJ7
        _lRet := .F.
        Alert("Quantidade do Item diferente da Quantidade distribuida no(s) projeto(s)")
    Endif

Return(_lRet)


/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    �PMSPROJPC� Autor � 				        � Data � 22-12-2005 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Esta funcao cria uma janela para configuracao e utilizacao    ���
���          �do Pedido de Compras a um dterminado projeto.                 ���
���������������������������������������������������������������������������Ĵ��
��� Uso      �MATA120,SIGAPMS                                               ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function PMSPROJPC(nOpcao,cNumPC)

    Local oDlg
    Local nPosPerc		:= 0
    Local nPosItem		:= aScan(aHeader,{|x| Alltrim(x[2]) == "C7_ITEM"})
    Local cItemPC		:= aCols[n][nPosItem]
    Local cNumSC		:= aCols[n][aScan(aHeader,{|x| Alltrim(x[2]) == "C7_NUMSC"})]
    Local cItemSC		:= aCols[n][aScan(aHeader,{|x| Alltrim(x[2]) == "C7_ITEMSC"})]
    Local nQuantPC		:= aCols[n][aScan(aHeader,{|x| Alltrim(x[2]) == "C7_QUANT"})]
    Local nVlrTotal	:= aCols[n][aScan(aHeader,{|x| Alltrim(x[2]) == "C7_TOTAL"})]
    Local nPosProj		:=	aScan(aHeader,{|x| Alltrim(x[2]) == "C7_PROJET"})
    Local nPosVersao	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "C7_REVISA"})
    Local nPosTaref	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "C7_TAREFA"})
    Local nPosTrt		:=	aScan(aHeader,{|x| Alltrim(x[2]) == "C7_TRT"})
    Local nPosRat		:= aScan(aRatAJ7,{|x| x[1] == aCols[n][nPosItem]})
    Local aSavCols		:= {}
    Local aSavHeader	:= {}
    Local nSavN			:= 1
    Local lGetDados   := .T.
    Local oGetDados
    Local nY          := 0
    Local nOpcMsg		:= 0
    Local cScOk       := "OK"
    Local cProduto    := ""
    Local cNumSA      := ""
    Local lPmsAj7Cols := ExistBlock("PMSAJ7COLS")
    Local aAlter      := {"AJ7_PROJET","AJ7_TAREFA", "AJ7_QUANT", "AJ7_QTSEGU" }

    Private lOk
//Verifica se o PC teve origem de uma Solicitacao de Compra
    If !Empty(cNumSC) .And. !Empty(cItemSC)
        dbSelectArea("AFG")
        dbSetOrder(2)
        If MsSeek(xFilial()+cNumSC+cItemSC)
            //cScOk := "ORIGEM_SC"
            cScOk := "OK"
        Else
            //Verifica se a SC teve origem de uma Solicitacao de Armazem
            SCP->(dbSetOrder(2)) //utilizado o indice 2 pois nao existe o indice no campo SCP->(CP_NUMSC+CPITSC)
            If SCP->(DbSeek(xFilial("SCP")+aCols[n,2]))
                cProduto := SCP->(CP_FILIAL+CP_PRODUTO)
                While cScOk=="OK" .And. !SCP->(Eof()) .And. SCP->(CP_FILIAL+CP_PRODUTO)==cProduto
                    If SCP->(CP_NUMSC+CP_ITSC)==cNumSC+cItemSC
                        cScOk  := "ORIGEM_SA"
                        cNumSA := SCP->CP_NUM
                    EndIf
                    cProduto := SCP->(CP_FILIAL+CP_PRODUTO)
                    SCP->(DbSkip())
                EndDo
            EndIf
        EndIf
    EndIf

//Verifica se o Contrato que est� amarrado a AE, se ja esta amarrado ao PMS
    If !Empty(cNumSC) .And. !Empty(cItemSC) .And. cScOk=="OK"
        dbSelectArea("AFL")
        dbSetOrder(2)
        If MsSeek(xFilial()+cNumSC+cItemSC)
            cScOk := "ORIGEM_CP"
        EndIf
    EndIf

// Salva ambiente da rotina de pedido de compra
    aSavCols   := aClone(aCols)
    aSavHeader := aClone(aHeader)
    nSavN      := n

    n       := 1
    aCols   := {}
    aHeader := {}

    If cScOk =="OK"
        nQtMaxSC:= nQuantPC

        If nOpcao == 3
            //��������������������������������������������������������������Ŀ
            //� Montagem do aHeader                                          �
            //����������������������������������������������������������������
            dbSelectArea("SX3")
            dbSetOrder(1)
            MsSeek("AJ7")
            While !EOF() .And. (x3_arquivo == "AJ7")
                IF X3USO(x3_usado) .AND. cNivel >= x3_nivel
                    AADD(aHeader,{ TRIM(x3titulo()), x3_campo, x3_picture,;
                        x3_tamanho, x3_decimal, x3_valid,;
                        x3_usado, x3_tipo, x3_arquivo,x3_context } )
                Endif
                If AllTrim(x3_campo) == "AJ7_QUANT"
                    nPosPerc	:= Len(aHeader)
                EndIf
                dbSkip()
            End
            aHeaderAJ7	:= aClone(aHeader)
            If nPosRat > 0
                aCols	:= aClone(aRatAJ7[nPosRat][2])
                If Len(aCols) == 1
                    aCols[1][Len(aHeader)+1] := .F.
                Endif
            Else
                //��������������������������������������������������������������Ŀ
                //� Faz a montagem de uma linha em branco no aCols.              �
                //����������������������������������������������������������������
                aadd(aCols,Array(Len(aHeader)+1))
                For ny := 1 to Len(aHeader)
                    If Trim(aHeader[ny][2]) == "AJ7_ITEM"
                        aCols[1][ny] 	:= "01"
                    Else
                        aCols[1][ny] := CriaVar(aHeader[ny][2])
                    EndIf
                    aCols[1][Len(aHeader)+1] := .F.
                Next ny
            EndIf
        Else
            //��������������������������������������������������������������Ŀ
            //� Montagem do aHeader                                          �
            //����������������������������������������������������������������
            dbSelectArea("SX3")
            dbSetOrder(1)
            MsSeek("AJ7")
            While !EOF() .And. (x3_arquivo == "AJ7")
                IF X3USO(x3_usado) .And. cNivel >= x3_nivel
                    AADD(aHeader,{ TRIM(x3titulo()), x3_campo, x3_picture,;
                        x3_tamanho, x3_decimal, x3_valid,;
                        x3_usado, x3_tipo, x3_arquivo,x3_context } )
                Endif
                If AllTrim(x3_campo) == "AJ7_QUANT"
                    nPosPerc	:= Len(aHeader)
                EndIf
                dbSkip()
            End
            aHeaderAJ7	:= aClone(aHeader)
            dbSelectArea("AJ7")
            dbSetOrder(2)
            If nPosRat == 0
                If MsSeek(xFilial()+cNumPC+cITEMPC)
                    While !Eof() .And. xFilial()+cNumPC+cITEMPC==;
                            AJ7_FILIAL+AJ7_NUMPC+AJ7_ITEMPC
                        If AJ7->AJ7_REVISA==PmsAF8Ver(AJ7->AJ7_PROJET)
                            aADD(aCols,Array(Len(aHeader)+1))
                            For ny := 1 to Len(aHeader)
                                If ( aHeader[ny][10] != "V")
                                    aCols[Len(aCols)][ny] := FieldGet(FieldPos(aHeader[ny][2]))
                                Else
                                    aCols[Len(aCols)][ny] := CriaVar(aHeader[ny][2])
                                EndIf
                                aCols[Len(aCols)][Len(aHeader)+1] := .F.
                            Next ny
                        EndIf
                        dbSkip()
                    End
                EndIf
                If Empty(aCols)
                    //��������������������������������������������������������������Ŀ
                    //� Faz a montagem de uma linha em branco no aCols.              �
                    //����������������������������������������������������������������
                    aadd(aCols,Array(Len(aHeader)+1))
                    For ny := 1 to Len(aHeader)
                        If Trim(aHeader[ny][2]) == "AJ7_ITEM"
                            aCols[1][ny] 	:= "01"
                        Else
                            aCols[1][ny] := CriaVar(aHeader[ny][2])
                        EndIf
                        aCols[1][Len(aHeader)+1] := .F.
                    Next ny
                EndIf
            Else
                aCols := aClone(aRatAJ7[nPosRat][2])
            EndIf
        EndIf

        If lPmsAj7Cols
            aUserCols := Execblock("PMSAJ7COLS", .F.,.F.,{cItemPC,cNumSC,cItemSC,nQuantPC,nVlrTotal,aHeader,aCols})
            If ValType(aUserCols) == "A"
                aCols := aClone(aUserCols)
            Endif
        Endif

        If lGetDados
            DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
            DEFINE MSDIALOG oDlg FROM 88 ,22  TO 350,619 TITLE "Gerenciamento de Projetos - PC" Of oMainWnd PIXEL Style 128 //"Gerenciamento de Projetos - PC"
            oGetDados := MSGetDados():New(23,3,112,296,nOpcao,'PMSAJ7LOK','PMSAJ7TOK','+AJ7_ITEM',.T.,aAlter,,,100,'PMSAJ7FOK')
            @ 16 ,3   TO 18 ,310 LABEL '' OF oDlg PIXEL
            @ 6  ,10   SAY "Num. PC" Of oDlg PIXEL SIZE 27 ,9   //"Num. PC"
            @ 5  ,35  SAY  cNumPC+"/"+cITEMPC Of oDlg PIXEL SIZE 40,9 FONT oBold
            @ 6  ,190 SAY "Quantidade" Of oDlg PIXEL SIZE 30 ,9   //"Quantidade"
            @ 5  ,230 MSGET nQuantPC Picture "@E 999,999,999.99" When .F. PIXEL SIZE 65,9
            @ 118,249 BUTTON 'Confirma' SIZE 35 ,9   FONT oDlg:oFont ACTION {||If(oGetDados:TudoOk(),(lOk:=.T.,oDlg:End()),(lOk:=.F.))}  OF oDlg PIXEL
//			@ 118,210 BUTTON 'Cancelar' SIZE 35 ,9   FONT oDlg:oFont ACTION (oDlg:End())  OF oDlg PIXEL  
            If ExistBlock("PMSPCSCR")
                ExecBlock("PMSPCSCR",.F.,.F.,{oDlg,nOpcao})
            Endif
            ACTIVATE MSDIALOG oDlg
        EndIf

        If nOpcao <> 2 .And. lOk
            If nPosRat > 0
                aRatAJ7[nPosRat][2]	:= aClone(aCols)
            Else
                aADD(aRatAJ7,{aSavCols[nSavN][nPosItem],aClone(aCols)})
            EndIf

            If ExistBlock("PMSDLGPC")
//			U_PMSDLGPC(aCols,aHeader,aSavCols,aSavHeader,nSavN)
            EndIf
            lPassou := .T. //Incluido por Felipe
        EndIf

        If lOk
            If nPosProj>0 .And. nPosVersao>0 .And. nPosTaref>0
                aSavCols[n][nPosProj]:=SPACE(TAMSX3("C7_PROJET")[1])
                aSavCols[n][nPosVersao]:=SPACE(TAMSX3("C7_REVISA")[1])
                aSavCols[n][nPosTaref]:=SPACE(TAMSX3("C7_TAREFA")[1])
            EndIf
            If nPosTrt>0
                aSavCols[n][nPosTrt]:=	SPACE(TAMSX3("C7_TRT")[1])
            EndIf
            lPassou := .T. //Incluido por Felipe
        EndIf
    ElseIf cScOk == "ORIGEM_SC"
        //"Aten��o!"###"Este item do pedido de compras esta relacionado a uma solicit��o de compras amarrado a um projeto/tarefa e n�o poder� ser alterada. Utilize a rotina de manuten��o de solicita��es de compras ou verifique o item selecionado"###"Fechar"###"Visualiza SC"
//	nOpcMsg := Aviso("Aten��o!","Este item do pedido de compras esta relacionado a uma solicit��o de compras amarrado a um projeto/tarefa e n�o poder� ser alterada. Utilize a rotina de manuten��o de solicita��es de compras ou verifique o item selecionado",If(nOpcao==2,{"Fechar","Visualiza SC"},{"Fechar"}),2)
        nOpcMsg := Aviso("Aten��o!","Este item do pedido de compras esta relacionado a uma solicit��o de compras amarrado a um projeto/tarefa e n�o poder� ser alterada. Utilize a rotina de manuten��o de solicita��es de compras ou verifique o item selecionado",If(nOpcao<>1,{"Fechar","Visualiza SC"},{"Fechar"}),2)

        If nOpcMsg == 2		// Visualiza SC
            MaViewSC(cNumSC)
            //If IntePms()	// Se usa PMS integrado com o ERP
            //	aBut105 := { {'PROJETPMS',{||Eval(bPmsDlgSA)},STR0014,STR0026 } } //"Gerenciamento de Projetos"##"Ger. de Projetos"
            //EndIf
            //PmsWriteSA(2,"SCP")
        EndIf
    ElseIf cScOk == "ORIGEM_SA"
        //"Aten��o!"###"Este item do pedido de compras esta relacionado a Solicit��o de Compras que est� relacionado a uma Solicit��o ao Armaz�m amarrado a um projeto/tarefa e n�o poder� ser alterada. Utilize a rotina de manuten��o de solicita��es ao armaz�m ou verifique o item selecionado"###"Fechar"###"Visualiza SA"
        //nOpcMsg := Aviso(STR0020,STR0054,If(nOpcao==2,{STR0022,STR0055},{STR0022}),2)
        nOpcMsg := Aviso("Aten��o!","Este item do pedido de compras esta relacionado a Solicit��o de Compras que est� relacionado a uma Solicit��o ao Armaz�m amarrado a um projeto/tarefa e n�o poder� ser alterada. Utilize a rotina de manuten��o de solicita��es ao armaz�m ou verifique o item selecionado",If(nOpcao<>1,{"Fechar","Visualiza SA"},{"Fechar"}),2)
        If nOpcMsg == 2		// Visualiza SA
            MaViewSA(cNumSA)
        EndIf
    ElseIf cScOk == "ORIGEM_CP"
        //"Aten��o!"###"Este item da autoriza��o de entrega esta relacionado a um contrato de parceria amarrado a um projeto/tarefa e n�o poder� ser alterado. Utilize a rotina de manuten��o do contrato de parceria ou verifique o item selecionado"###"Fechar"###"Visualiza Contrato"
        //nOpcMsg := Aviso(STR0020,STR0125,If(nOpcao==2,{STR0022,STR0126},{STR0022}),2)
        nOpcMsg := Aviso("Aten��o!","Este item da autoriza��o de entrega esta relacionado a um contrato de parceria amarrado a um projeto/tarefa e n�o poder� ser alterado. Utilize a rotina de manuten��o do contrato de parceria ou verifique o item selecionado",If(nOpcao<>1,{"Fechar","Visualiza Contrato"},{"Fechar"}),2)
        If nOpcMsg == 2		// Visualiza Contrato
            If FindFunction("MaViewCT")
                MaViewCT(cNumSC)
            EndIf
        EndIf
    EndIf

// Restaura ambiente do pedido de compras
    aCols	:= aClone(aSavCols)
    aHeader	:= aClone(aSavHeader)
    n		:= nSavN

Return
