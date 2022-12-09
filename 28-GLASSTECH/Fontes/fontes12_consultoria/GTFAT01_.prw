#Include "Protheus.ch"
#INCLUDE "FWMVCDEF.CH"
#Include "TopConn.ch"

/*/{Protheus.doc} User Function GTFAT01
    (long_description)
    @type  Function
    @author Douglas SIlva
    @since 04/10/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example Esta rotina tem como objetivo criar a tela de triagem de pedido de venda
    (examples)
    @see (links_or_references)
    /*/

User Function GTFAT01()
    
    Local aArea     := GetArea()
    Local aPosObj   := {}
    Local aObjects  := {}
    Local aSize     := MsAdvSize()
    //Local nOpcA     := 0
    Local oDlg
    Local nUsado    := 0
    Local aStruSC6 := {}
    Local nX
    Local aSaldoGT  := {}
    
    Private oGetDad
    Private N := 1
    Private aHeader := {}
    Private aCols   := {}

    //Fontes
    Private    cFontUti   := "Tahoma"
    Private    oFontAno   := TFont():New(cFontUti,,-38)
    Private    oFontSub   := TFont():New(cFontUti,,-20)
    Private    oFontSubN  := TFont():New(cFontUti,,-20,,.T.)
    Private    oFontBtn   := TFont():New(cFontUti,,-14)
    Private   _cProduto

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Montagem do aHeadFor                                 ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    dbSelectArea("SX3")
    dbSetOrder(1)
    dbSeek("SC6")
    Do While !Eof() .And. SX3->X3_ARQUIVO == "SC6"
        If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
            If Alltrim(SX3->X3_CAMPO) $ "C6_FILIAL|C6_ITEM|C6_PRODUTO|C6_QTDVEN|C6_QTDLIB|"
                nUsado++
                aAdd(aHeader, { AllTrim(X3Titulo()),;
                    SX3->X3_CAMPO,;
                    SX3->X3_PICTURE,;
                    SX3->X3_TAMANHO,;
                    SX3->X3_DECIMAL,;
                    "",;
                    SX3->X3_USADO,;
                    SX3->X3_TIPO,;
                    SX3->X3_ARQUIVO,;
                    SX3->X3_CONTEXT,;
                    SX3->X3_CBOX    ,;
                    SX3->X3_RELACAO,;
                    "",;
                    IIF(Alltrim(SX3->X3_CAMPO) $ "C6_QTDLIB", "A","V") } )
            EndIf
        EndIf
        dbSelectArea("SX3")
        dbSkip()
    EndDo

    //Incluir Campos fora SC6
    aAdd(aHeader, {"Sld Gestoq","SLDGETOQ","@E 999,999,999,999,999,999",018,0,".T.",".T.", "N", "","","","","","V"} )
    aAdd(aHeader, {"SC6 Recno","SC6RECNO" ,"@E 999,999,999,999,999,999",018,0,".T.",".T.", "N", "","","","","","V"} )

    //Montagem do acols de dados
    SC6->(DbSetOrder(1))

	cArqQry := "TMP"
	aStruSC6:= SC6->(dbStruct())

    cQuery := "SELECT SC6.*,SC6.R_E_C_N_O_ SC6RECNO "
	cQuery += "FROM "+RetSqlName("SC6")+" SC6 "
	cQuery += "WHERE "
	cQuery += "SC6.C6_FILIAL='"+SC5->C5_FILIAL+"' AND "
	cQuery += "SC6.C6_NUM='"+SC5->C5_NUM+"' AND "
	cQuery += "SC6.D_E_L_E_T_=' ' "
	cQuery += "ORDER BY "+SqlOrder(SC6->(IndexKey()))

	cQuery := ChangeQuery(cQuery)

    Iif(Select("TMP")>0, TMP->(DbCloseArea()) , Nil ) 
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqQry,.T.,.T.)
    
    For nX := 1 To Len(aStruSC6)
		If	aStruSC6[nX,2] <> "C"
			TcSetField(cArqQry,aStruSC6[nX,1],aStruSC6[nX,2],aStruSC6[nX,3],aStruSC6[nX,4])
		EndIf
	Next nX

    
    Do While (cArqQry)->(!Eof())
        
        aAdd(aCols,Array(Len(aHeader) + 1))	    

        For nX := 1 To Len(aHeader)
		
			If ( aHeader[nX][10] <> "V" )
				aCols[Len(aCols)][nX] := (cArqQry)->(FieldGet(FieldPos(aHeader[nX][2])))
			Else
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2])
			EndIf
		Next

        //Adicona coluna para não ficar deletado
        aCols[Len(aCols)][Len(aHeader) + 1 ] := .f.

        dbSelectArea(cArqQry)
        dbSkip()
	EndDo 

    //Fonte para consulta saldo de produtos via Rest-Gestoq
    nPosCod  := aScan(aHeader, {|x| Alltrim(x[2]) == "C6_PRODUTO"})
    nPosSGT  := aScan(aHeader, {|x| Alltrim(x[2]) == "SLDGETOQ"})
    For nX := 1 To Len(aCols)
        _cProduto := (aCols[nX][nPosCod])
        aSaldoGT := AClone( U_APIGTSLD(_cProduto) )

        //Inclui saldo array
        aCols[nX][nPosSGT] := aSaldoGT[4][2]

    Next

    aAdd( aObjects, { 100, 100, .t., .t. } )

    aSize[ 3 ] -= 50
    aSize[ 4 ] -= 50 	

    aSize[ 5 ] -= 100
    aSize[ 6 ] -= 100

    aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }
    aPosObj := MsObjSize( aInfo, aObjects )

    //Criação da tela com os dados que serão informados
    DEFINE MSDIALOG oDlg TITLE OemToAnsi("Pedido Venda " + SC5->C5_NUM) FROM 000, 000  TO aSize[6],aSize[5] COLORS 0, 16777215 PIXEL 

        //Labels gerais
        @ 004, 003 SAY "PDV"                SIZE 200, 030 FONT oFontAno  OF oDlg COLORS RGB(149,179,215) PIXEL
        @ 004, 050 SAY "Triagem"            SIZE 200, 030 FONT oFontSub  OF oDlg COLORS RGB(031,073,125) PIXEL
        @ 014, 050 SAY "Pedido de Venda"    SIZE 200, 030 FONT oFontSubN OF oDlg COLORS RGB(031,073,125) PIXEL

        //Botões
        @ 006, (aSize[5]/2-001)-(0052*01) BUTTON oBtnFech  PROMPT "Fechar"        SIZE 050, 018 OF oDlg ACTION (oDlg:End()) FONT oFontBtn PIXEL
        @ 006, (aSize[5]/2-001)-(0052*02) BUTTON oBtnLege  PROMPT "Legenda"       SIZE 050, 018 OF oDlg ACTION (fLegenda()) FONT oFontBtn PIXEL
        @ 006, (aSize[5]/2-001)-(0052*02) BUTTON oBtnSalv  PROMPT "Romaneio"      SIZE 050, 018 OF oDlg ACTION (fSalvar())  FONT oFontBtn PIXEL

         oGetDad := MsNewGetDados():New(    029,;                   //nTop      - Linha Inicial
                                            003,;                   //nLeft     - Coluna Inicial
                                            (aSize[5]/2)-3,;        //nBottom   - Linha Final
                                            (aSize[5]/2)-3,;        //nRight    - Coluna Final
                                            GD_UPDATE + GD_DELETE,; //nStyle    - Estilos para edição da Grid (GD_INSERT = Inclusão de Linha; GD_UPDATE = Alteração de Linhas; GD_DELETE = Exclusão de Linhas)
                                            "U_GTFAT1LOK()",;       //cLinhaOk  - Validação da linha
                                            ,;                      //cTudoOk   - Validação de todas as linhas
                                            "",;                    //cIniCpos  - Função para inicialização de campos
                                            ,;                      //aAlter    - Colunas que podem ser alteradas
                                            ,;                      //nFreeze   - Número da coluna que será congelada
                                            9999,;                  //nMax      - Máximo de Linhas
                                            ,;                      //cFieldOK  - Validação da coluna
                                            ,;                      //cSuperDel - Validação ao apertar '+'
                                            ,;                      //cDelOk    - Validação na exclusão da linha
                                            oDlg,;                  //oWnd      - Janela que é a dona da grid
                                            aHeader,;               //aHeader   - Cabeçalho da Grid
                                            aCols)                  //aCols     - Dados da Grid

    ACTIVATE MSDIALOG oDlg CENTERED

    RestArea(aArea)

Return(.T.)    

/*/{Protheus.doc} GTFAT1LOK
    (long_description)
    @type  Static Function
    @author user
    @since 04/10/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/

User Function GTFAT1LOK()
    
    Local lRet := .T.
    Local aColsAux := oGetDad:aCols

    Local nPosQVen  := aScan(aHeader, {|x| Alltrim(x[2]) == "C6_QTDVEN"})
    Local nPosQLib  := aScan(aHeader, {|x| Alltrim(x[2]) == "C6_QTDLIB"})

    //Verifica se foi digitado uma quantidade maior que a solicitada
    If aColsAux[n][nPosQLib] != 0
        If ( aColsAux[n][nPosQLib]  > aColsAux[n][nPosQVen] )
            Alert("ATENÇÃO: Verifique a quantidade liberada, está maior que solicitada!")
            lRet := .F.
        EndIf
    EndIf    

Return lRet

/*/{Protheus.doc} GTFAT1TOK
    (long_description)
    @type  Static Function
    @author user
    @since 04/10/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/

User Function GTFAT1TOK(param_name)
    
    Local lRet := .T.

Return lRet

/*/{Protheus.doc} GTFAT1TOK
    (long_description)
    @type  Static Function
    @author user
    @since 04/10/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/

Static Function fSalvar()
    
    Local lRet := .T.
    Local aColsAux := oGetDad:aCols
    Local nLinha   := 0
    
    For nLinha := 1 To Len(aColsAux)

        If aColsAux[nLinha][nPosRec] != 0
            SBM->(DbGoTo(aColsAux[nLinha][nPosRec]))
        EndIf

        //Se a linha estiver excluída
        If aColsAux[nLinha][nPosDel]
        


        EndIf

    Next

    MsgInfo("Romaneio gerado com sucesso " , "Atenção")
    oDlg:End()

Return(lRet)


