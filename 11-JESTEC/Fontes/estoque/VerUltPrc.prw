#Include "TOTVS.ch"
//#Include "RwMake.ch"
//#Include "TbiConn.ch"
//#Include "TbiCode.ch"
#Include "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �VERULTPRC �Autor  �Ricardo Tavares     � Data �  28/05/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica a Ultima Compra ou Movimenta��o do Produto         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Manuten��o�01/06/2015 - Melhoria de pesquisa e WorkFlow                ���
�������������������������������������������������������������������������͹��
���Uso       �SIGA                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function VerUltPrc( nPSD, _cTipoMov )

    Local oDlg                := NIL

    Local cTexto             := ""
    Local cQuery            := ""
    Local _cMsgMail      := ""

    Local _cFornce          := ""
    Local  _cLoja              := ""

    Local lMsg                 := .F.

    Private npPSD
    Private _cProd          := ""
    Private _cUltPrc        := ""
    Private _cUltDtMov

    Private nPrcCustReal  := 0.00
    Private _nlQuant           // Quantidade
    Private _nlPrcUnit         // Preco Unitario
    Private _nlValTot           // Valor Total

    npPSD := nPSD


    If Select("TRB01") > 0
        TRB01->(DbCloseArea())
    EndIf


    If ( ( nPSD == 1 ) .Or. ( nPSD == 3 ) )  // Compras

        _cProd        := SB1->B1_COD
        //DBSelectArea("SD1")  // CRIAR INDICE
        //SD1->(DBSetOrder(X)) // M->D1_FILIAL + M->D1_FORNECE + M->D1_LOJA + M->D1_COD + D1_DTDIGIT
        //If ( SD1->(DBSeek(M->D1_FILIAL + M->D1_FORNECE + M->D1_LOJA + M->D1_COD) )

        cQuery := "SELECT SD1.D1_FORNECE, SD1.D1_LOJA, MAX(SD1.D1_DTDIGIT) D1_DTDIGIT, SD1.D1_VUNIT "
        cQuery += "FROM " + RetSqlName("SD1") + " SD1, " + RetSqlName("SF4") + " SF4 "
        cQuery += "WHERE SD1.D_E_L_E_T_<> '*' "
        cQuery += "AND SD1.D1_FILIAL = '" + xFilial("SD1") + "' "
        cQuery += "AND SD1.D1_COD = '" + _cProd + "' "
        cQuery += "AND SF4.F4_CODIGO = SD1.D1_TES "
        cQuery += "AND SF4.F4_DUPLIC = 'S' "
        cQuery += "GROUP BY D1_FORNECE, D1_LOJA, D1_COD, D1_VUNIT "
        cQuery += "ORDER BY D1_DTDIGIT DESC"

    EndIf


    cQuery := ChangeQuery(cQuery)

    dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB01", .F., .T.)

    TCSETFIELD("TRB01","D1_VUNIT" ,"N",15,2)

    DbSelectArea("TRB01")
    TRB01->(DbGoTop())

    If ( TRB01->(Recno()) >= 1 )

        If ( ( nPSD == 1 ) .Or. ( nPSD == 3 ) )  // Compras

            // Fornecedor
            _cFornce   := TRB01->D1_FORNECE
            _cLoja        := TRB01->D1_LOJA

            DBSelectArea("SA2")
            SA2->(DBSetOrder(1))
            SA2->(DbSeek(xFilial("SA2") + _cFornce + _cLoja))

            cTexto  := "Fornecedor - "               + SA2->A2_COD + " / "+ SA2->A2_LOJA + " - " + SA2->A2_NOME + CHR(13)+CHR(10)
            cTexto += "Produto - "                    + AllTrim(SB1->B1_COD) + " - " + SB1->B1_DESC + CHR(13)+CHR(10)
            cTexto += "�ltima Dt. Compra - " + DToC(SToD(TRB01->D1_DTDIGIT)) + CHR(13)+CHR(10)
            cTexto += "�ltimo Pre�o - "           + "R$ " + Transform(TRB01->D1_VUNIT, '@E 999,999,999,999.99')

            _cUltDtMov      := DToC(SToD(TRB01->D1_DTDIGIT))
            _cUltPrc            := Transform(TRB01->D1_VUNIT, '@E 999,999,999,999.99')
            nPrcCustReal   := TRB01->D1_VUNIT //D1_CUSTO

        EndIf

    Else

        //
        cTexto  := "Fornecedor - "               + SA2->A2_NOME + CHR(13)+CHR(10)
        cTexto += "Produto - "                    + AllTrim(SB1->B1_COD) + " - " + SB1->B1_DESC + CHR(13)+CHR(10)
        cTexto += "�ltima Dt. Compra - " + "INEXISTENTE" + CHR(13)+CHR(10)
        cTexto += "�ltimo Pre�o - "           + "INEXISTENTE"

    EndIf

    If (  nPSD == 1  )

        // Verifica se o Valor Unitario Digitado e Diferente da Ultima Compra
        For nI :=1 To Len(aCols)

            _nlQuant   := aCols[nI, aScan(aHeader,{|x|AllTrim(x[2])=="D1_QUANT"})]  // Quantidade
            _nlPrcUnit := aCols[nI, aScan(aHeader,{|x|AllTrim(x[2])=="D1_VUNIT"})] // Preco Unitario
            _nlValTot  := aCols[nI, aScan(aHeader,{|x|AllTrim(x[2])=="D1_TOTAL"})]  // Valor Total

        Next nI

        If ( _nlPrcUnit <> TRB01->D1_VUNIT )
            lMsg := .T.
        EndIf

    ElseIf ( nPSD == 3 )

        If ( _cTipoMov == "S" ) // Movimentacao Simples

            // Verifica se o Valor Unitario Digitado e Diferente da Ultima Compra
            _nlQuant   := M->D3_QUANT           // Quantidade
            _nlPrcUnit := M->D3_CUSTO1          // Preco Unitario
            _nlValTot  := _nlPrcUnit * _nlQuant  // Valor Total

        ElseIf ( _cTipoMov == "M" ) // Movimentacao Multipla

            // Verifica se o Valor Unitario Digitado e Diferente da Ultima Compra
            For nI :=1 To Len(aCols)

                _nlQuant   := aCols[nI, aScan(aHeader,{|x|AllTrim(x[2])=="D3_QUANT" })]  // Quantidade
                _nlPrcUnit := aCols[nI, aScan(aHeader,{|x|AllTrim(x[2])=="D3_CUSTO1"})] // Preco Unitario
                //_nlValTot  := aCols[nI, 8]  // Valor Total

            Next nI

        EndIf

        If ( _nlPrcUnit <> TRB01->D1_VUNIT )
            lMsg := .T.
        EndIf

    EndIf

// Alteracao Sergio Junior 22/02/16 

    //If ( lMsg )
    //    MsgAlert( cTexto, "�ltima Compra" )
    //EndIf

// Fim Alteracao Sergio Junior 22/02/16

    //If ( TRB01->(Recno()) > 0 )


    /*
    If ( nPSD == 3 )
        
        DEFINE MSDIALOG oDlg TITLE "�ltima Compra" FROM 0,0 TO 90,220 OF oDlg PIXEL
                
        @  03,03 Say "Pre�o Atual"   SIZE 30,7 PIXEL OF oDlg
        @  02, 35 MsGet nPrcCustReal      PICTURE "@E 999,999,999.99" SIZE 50, 7 PIXEL OF oDlg
                
        @ 20,21 BUTTON "&Gravar"    SIZE 36,13 PIXEL ACTION (lOpc:=Validar(),Iif(lOpc,Eval({||Gravar(nPSD),oDlg:End()}),NIL))
        @ 20,64 BUTTON "&Abandonar" SIZE 36,13 PIXEL ACTION oDlg:End()
                
        ACTIVATE MSDIALOG oDlg CENTERED
                               
    EndIf
    */

// Aciona o Envio do E-mail para o Gestor
/*
"Movimenta��o de Produto" + CHR(13)+CHR(10)
"" + CHR(13)+CHR(10)
"Produto - " + AllTrim(SB1->B1_COD) + " - " + SB1->B1_DESC + CHR(13)+CHR(10)
"" + CHR(13)+CHR(10) 
"    Movimentado por " + SubStr(cUsuario,7,15) + CHR(13)+CHR(10)
"" + CHR(13)+CHR(10)         
"       Dt. �ltima Movimenta��o - " + _cUltDtMov + CHR(13)+CHR(10)
"       Fornecedor - " + SA2->A2_COD + " / "+ SA2->A2_LOJA + " - " + SA2->A2_NOME + CHR(13)+CHR(10)
"       �ltimo Pre�o - " + _cUltPrc 
*/
//
    _cMsgMail := "Movimenta��o de Produto" + CHR(13)+CHR(10) + "" + CHR(13)+CHR(10) + "Produto - " + AllTrim(SB1->B1_COD) + " - " + SB1->B1_DESC + CHR(13)+CHR(10) +                            "" + CHR(13)+CHR(10)  + "    Movimentado por " + SubStr(cUsuario,7,15) + CHR(13)+CHR(10) + "" + CHR(13)+CHR(10) + "       Dt. �ltima Movimenta��o - " + _cUltDtMov + CHR(13)+CHR(10) + "       Fornecedor - " + SA2->A2_COD + " / "+ SA2->A2_LOJA + " - " + SA2->A2_NOME + CHR(13)+CHR(10) + "       �ltimo Pre�o - " + _cUltPrc

//    If ( lMsg )
//        U_MEmail( _cMsgMail )
//    EndIf

Return(.T.)

// Ricardo Tavares
// Valida os valores digitados
// 10/06/2015
Static Function Validar()

    Local lRet := .T.
    Local cTitulo  := "�ltima Compra"

    If ( Empty(nPrcCustReal) )
        MsgInfo("Campo 'Pre�o Atual' preenchimento obrigat�rio",cTitulo)
        lRet:=.F.
    Endif

    If ( ValType((nPrcCustReal)) <> "N" )
        MsgInfo("Campo 'Pre�o Atual' precisa ser n�merico",cTitulo)
        lRet:=.F.
    Endif

Return(lRet)

// Ricardo Tavares
// Grava o Preco unitario
// 10/06/2015
Static Function Gravar( nPSD)

    If ( nPSD == 1 )

        // Verifica se o Valor Unitario Digitado e Diferente da Ultima Compra
        For nI :=1 To Len(aCols)

            aCols[nI, 5] := _nlQuant  // Quantidade
            aCols[nI, 6] := nPrcCustReal // Preco Unitario
            aCols[nI, 7] := nPrcCustReal * _nlQuant  // Valor Total

        Next nI

        RecLock("SD1",.F.)
        SD1->D1_CUSTO := nPrcCustReal * _nlQuant
        SD1->(MSUnLock())

    ElseIf ( nPSD == 3 )

        If ( _cTipoMov == "S" ) // Movimentacao Simples

            // Verifica se o Valor Unitario Digitado e Diferente da Ultima Compra
            M->D3_QUANT := _nlQuant           // Quantidade
            M->D3_CUSTO1 := _nlPrcUnit          // Preco Unitario
            //_nlValTot  := _nlPrcUnit * _nlQuant  // Valor Total

        ElseIf ( _cTipoMov == "M" ) // Movimentacao Multipla

            // Verifica se o Valor Unitario Digitado e Diferente da Ultima Compra
            For nI :=1 To Len(aCols)

                aCols[nI, aScan(aHeader,{|x|AllTrim(x[2])=="D3_QUANT" })] := _nlQuant  // Quantidade
                aCols[nI, aScan(aHeader,{|x|AllTrim(x[2])=="D3_CUSTO1"})] := _nlPrcUnit // Preco Unitario
                //_nlValTot  := aCols[nI, 8]  // Valor Total

            Next nI

        EndIf

        RecLock("SD3",.F.)
        SD3->D3_CUSTO1 := nPrcCustReal * _nlQuant
        SD3->(MSUnLock())

    EndIf

Return(.T.)