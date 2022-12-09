//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"

//Constantes
#Define STR_PULA        Chr(13)+Chr(10)

/*/{Protheus.doc} CpPdvC2
Função de exemplo de consulta de dados via Array (zConsArr)
@type function
@author Atilio
@since 30/07/2016
@version 1.0
/*/

User Function CpPdvC2()
	Local lOk     := .F.
	//Local aDados  := {}
	Local _aDados := {}
	Local nX      := 0

	//Adicionando os dados no array
    /*aAdd(aDados, {"0001", "Daniel", 23})
    aAdd(aDados, {"0002", "Hudson", 33})
    aAdd(aDados, {"0003", "Atilio", 43})*/

    
    cQuery := " SELECT DISTINCT C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO, C6_DESCRI, C6_QTDVEN, C6_ACAB, C6_TON, C6_CODCOR, C6_TABCOR, C6_OBS "
    cQuery += " FROM "+RetSQLName("SC6") + " AS SC6 " //WITH (NOLOCK)
    cQuery += " WHERE C6_PRODUTO  = '" + M->C2_PRODUTO + "' "
    cQuery += " AND SC6.D_E_L_E_T_= ' ' "
    cQuery += " ORDER BY C6_FILIAL, C6_NUM, C6_ITEM "

    If Empty(M->C2_PRODUTO)
        MsgAlert("Preencha o produto antes de selecionar o pedido de venda","Atenção")
        Return lOk
    EndIf

    cTabela:= CriaTrab(Nil,.F.)
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cTabela, .F., .T.)
     
    (cTabela)->(DbGoTop())
    If (cTabela)->(Eof())
        MsgStop("Não há registros para serem exibidos!","Atenção")
        Return .T.
    Endif
   
    Do While (cTabela)->(!Eof())
        /*Cria o array conforme a quantidade de campos existentes na consulta SQL*/
        cCampos    := ""
        aCampos     := {}
        For nX := 1 TO FCount()
            bCampo := {|nX| Field(nX) }
            If ValType((cTabela)->&(EVAL(bCampo,nX)) ) <> "M" .OR. ValType((cTabela)->&(EVAL(bCampo,nX)) ) <> "U"
                if ValType((cTabela)->&(EVAL(bCampo,nX)) )=="C"
                    cCampos += "'" + StrTran(StrTran((cTabela)->&(EVAL(bCampo,nX)),'"',''),"'","") + "',"
                ElseIf ValType((cTabela)->&(EVAL(bCampo,nX)) )=="D"
                    cCampos +=  DTOC((cTabela)->&(EVAL(bCampo,nX))) + ","
                Else
                    cCampos +=  Str((cTabela)->&(EVAL(bCampo,nX))) + ","
                Endif
                    
                aadd(aCampos,{EVAL(bCampo,nX),Alltrim(RetTitle(EVAL(bCampo,nX))),"LEFT",30})
            Endif
        Next
     
         If !Empty(cCampos) 
             cCampos     := Substr(cCampos,1,len(cCampos)-1)
             aAdd( _aDados,&("{"+cCampos+"}"))
         Endif
         
        (cTabela)->(DbSkip())     
    Enddo
   
    (cTabela)->(DbCloseArea())
    
    If Len(_aDados) == 0
        MsgInfo("Não há dados para exibir!","Aviso")
        Return .T.
    Endif
     
    //Chamando a consulta
    lOk := u_zConsArr(_aDados, 2, 11, {"Filial","Pedido","Item","CodPro","Produto","Qtde","Acabamento","Tonalidade","CodCor","TabCor","Obs"}, {6, 6, 3, 15, 10, 20, 20, 20, 20, 20, 50})
    //C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO, C6_DESCRI, C6_QTDVEN, C6_ACAB, C6_TON, C6_CODCOR, C6_TABCOD, C6_OBS
     
     //Se foi confirmado, mostra mensagem
     // If lOk
     //    MsgInfo("O escolhido foi: "+__cRetorn+"!", "Atenção")
     // EndIf
Return .T.  //lOk
 
/*/{Protheus.doc} zConsArr
Função para consulta genérica
@author Daniel Atilio
@since 05/06/2015
@version 1.0
    @param aDadosM, Array, Array multidimensional que tem o retorno
    @param nPosRetM, Numérico, Posição de retorno
    @param nColsM, Numérico, Quantidade de colunas
    @param aTitulosM, Array, Array com os títulos dos campos
    @return lRetorn, retorno se a consulta foi confirmada ou não
    @example
    u_zConsArr(aDados, 1, 3, {"Campo1","Campo2","Campo3"}, {10, 10, 20})
    @obs O retorno da consulta é pública (__cRetorn) para ser usada em consultas específicas
/*/
 
User Function zConsArr(aDadosM, nPosRetM, nColsM, aTitulosM, aTamanM)
    Local aArea := GetArea()
    Local nTamBtn := 50
    //Defaults
    Default aDadosM := {}
    Default nPosRetM := 0
    Default nColsM := 0
    Default aTitulosM := {}
    Default aTamanM := {}
    //Privates
    Private aCampos := aDadosM
    Private nPosRet := nPosRetM
    Private nCols    := nColsM
    Private aTitulos := aTitulosM
    Private aTaman := aTamanM
    //MsNewGetDados
    Private oMsNew
    Private aHeadAux := {}
    Private aColsAux := {}
    //Tamanho da janela
    Private nJanLarg := 0800
    Private nJanAltu := 0500
    //Gets e Dialog
    Private oDlgEspe
    Private oGetPesq, cGetPesq := Space(100)
    //Retorno
    Private lRetorn := .F.
    Private nTamanRet :=  Iif(Len(aDadosM) >= 1, Len(aDadosM[1][nPosRet]), 18) //Iif(Len(aDadosM) >= 1, Len(aDadosM[1][nPosRet]), 18)
    Public  __cRetorn := ""
     
    //Se tiver o alias em branco ou não tiver campos
    If Len(aDadosM) <= 0 .Or. (nPosRetM == 0) .Or. (nColsM == 0)
        MsgStop("Sem campos!", "Atenção")
        Return Nil //lRetorn
    EndIf
     
    //Criando a estrutura para a MsNewGetDados
    fCriaMsNew()
     
    //Criando a janela
    DEFINE MSDIALOG oDlgEspe TITLE "Consulta de Dados" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
        //Pesquisar
        @ 003, 003 GROUP oGrpPesqui TO 025, (nJanLarg/2)-3 PROMPT "Pesquisar: "    OF oDlgEspe COLOR 0, 16777215 PIXEL
            @ 010, 006 MSGET oGetPesq VAR cGetPesq SIZE (nJanLarg/2)-12, 010 OF oDlgEspe COLORS 0, 16777215  VALID (fVldPesq())      PIXEL
         
        //Dados
        @ 028, 003 GROUP oGrpDados TO (nJanAltu/2)-28, (nJanLarg/2)-3 PROMPT "Dados: "    OF oDlgEspe COLOR 0, 16777215 PIXEL
            oMsNew := MsNewGetDados():New(    035,;                                        //nTop
                                                006,;                                        //nLeft
                                                (nJanAltu/2)-31,;                            //nBottom
                                                (nJanLarg/2)-6,;                            //nRight
                                                GD_INSERT+GD_DELETE+GD_UPDATE,;            //nStyle
                                                "AllwaysTrue()",;                            //cLinhaOk
                                                ,;                                            //cTudoOk
                                                "",;                                        //cIniCpos
                                                ,;                                            //aAlter
                                                ,;                                            //nFreeze
                                                999,;                                        //nMax
                                                ,;                                            //cFieldOK
                                                ,;                                            //cSuperDel
                                                ,;                                            //cDelOk
                                                oDlgEspe,;                                    //oWnd
                                                aHeadAux,;                                    //aHeader
                                                aColsAux)                                    //aCols                                    
            oMsNew:lActive := .F.
            oMsNew:oBrowse:blDblClick := {|| fConfirm()}
         
            //Populando os dados da MsNewGetDados
            fPopula()
         
        //Ações
         @ (nJanAltu/2)-25, 003 GROUP oGrpAcoes TO (nJanAltu/2)-3, (nJanLarg/2)-3 PROMPT "Ações: "    OF oDlgEspe COLOR 0, 16777215 PIXEL
            @ (nJanAltu/2)-19, (nJanLarg/2)-((nTamBtn*1)+06) BUTTON oBtnConf PROMPT "Confirmar" SIZE nTamBtn, 013 OF oDlgEspe ACTION(fConfirm())     PIXEL
            //@ (nJanAltu/2)-19, (nJanLarg/2)-((nTamBtn*2)+09) BUTTON oBtnLimp PROMPT "Limpar" SIZE nTamBtn, 013 OF oDlgEspe ACTION(fLimpar())     PIXEL
            @ (nJanAltu/2)-19, (nJanLarg/2)-((nTamBtn*3)+12) BUTTON oBtnCanc PROMPT "Cancelar" SIZE nTamBtn, 013 OF oDlgEspe ACTION(fCancela())     PIXEL
         
        oMsNew:oBrowse:SetFocus()
    //Ativando a janela
    ACTIVATE MSDIALOG oDlgEspe CENTERED
     
    RestArea(aArea)
Return Nil //lRetorn
 
/*---------------------------------------------------------------------*
 | Func:  fCriaMsNew                                                   |
 | Autor: Daniel Atilio                                                |
 | Data:  05/06/2015                                                   |
 | Desc:  Função para criar a estrutura da MsNewGetDados               |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function fCriaMsNew()
    Local cCampoAtu := "XX_CAMP000"
    Local nTamanAtu := 0
    Local nAtual    := 0
     
    //Percorrendo os campos
    For nAtual := 1 To nCols
        cCampoAtu := Soma1(cCampoAtu)
        nTamanAtu := 10
         
        //Se tiver título
        If ! (nAtual > Len(aTitulos))
            cTituloAux := aTitulos[nAtual]
        Else
            cTituloAux := Capital(StrTran(cCampoAtu, "XX_", ""))
        EndIf
 
        //Se tiver tamanho
        If nAtual >= Len(aTaman)
            nTamanAtu := aTaman[nAtual]
        EndIf
         
        //Cabeçalho ...    Titulo            Campo            Mask        Tamanho    Dec        Valid    Usado    Tip        F3    CBOX
        aAdd(aHeadAux,{    cTituloAux,    cCampoAtu,        "",            nTamanAtu,            0,        ".F.",    ".F.",    "C",    "",    ""})
    Next
Return
 
/*---------------------------------------------------------------------*
 | Func:  fPopula                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  05/06/2015                                                   |
 | Desc:  Função que popula a tabela auxiliar da MsNewGetDados         |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function fPopula()
    Local xAux := ""
    Local nColuna := 0
    Local nLinha := 0
    Local nAtual := 0
    aColsAux :={}
     
    //Percorrendo linhas
    For nLinha := 1 To Len(aCampos)
        lFiltro := .F.
         
        //Se tiver filtro, verifica um a um se tem a expressão
        If !Empty(cGetPesq)
            //percorrendo colunas
            For nColuna := 1 To nCols
                xAux := aCampos[nLinha][nColuna]
                If ValType(xAux) != 'C'
                    xAux := cValToChar(xAux)
                EndIf
                 
                //Se tiver na pesquisa
                If Alltrim(Lower(cGetPesq)) $ Lower(xAux)
                    lFiltro := .T.
                EndIf
            Next
         
        //Se não tiver filtro, traz tudo
        Else
            lFiltro := .T.
        EndIf
         
         
        //Se tiver filtrado ok
        If lFiltro
            aAux := {}
            //percorrendo colunas
            For nColuna := 1 To nCols
                aAdd(aAux, aCampos[nLinha][nColuna])
            Next
            aAdd(aAux, .F.)
            aAdd(aColsAux, aClone(aAux))
        EndIf
    Next
     
    //Se não tiver dados, adiciona linha em branco
    If Len(aColsAux) == 0
        aAux := {}
        //Percorrendo os campos e adicionando no acols (junto com o recno e com o delet
        For nAtual := 1 To nCols
            aAdd(aAux, '')
        Next
        aAdd(aAux, .F.)
     
        aAdd(aColsAux, aClone(aAux))
    EndIf
     
    //Posiciona no topo e atualiza grid
    oMsNew:SetArray(aColsAux)
    oMsNew:oBrowse:Refresh()
Return
 
/*---------------------------------------------------------------------*
 | Func:  fConfirm                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  05/06/2015                                                   |
 | Desc:  Função de confirmação da rotina                              |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function fConfirm()
    Local cAux := ""
    Local aColsNov := oMsNew:aCols
    Local nLinAtu  := oMsNew:nAt
    Local cFilx    := ""
    lRetorn := .T.


    cFilx         := aColsNov[nLinAtu][1]
    M->C2_PEDIDO  := aColsNov[nLinAtu][2]
    M->C2_ITEMPV  := aColsNov[nLinAtu][3]
    M->C2_XACAB   := aColsNov[nLinAtu][7]
    M->C2_XTON    := aColsNov[nLinAtu][8]
    M->C2_XCODCOR := aColsNov[nLinAtu][9]
    M->C2_XTABCOR := aColsNov[nLinAtu][10]
    M->C2_XOBS    := aColsNov[nLinAtu][11]

    M->C2_XNOMEV  := Posicione("SC5",1,cFilx+M->C2_PEDIDO,"C5_USUARIO")
	M->C2_CLIPV1  := Posicione("SC5",1,cFilx+M->C2_PEDIDO,"C5_RAZSOCI")
	M->C2_QTDPV1  := QtdPdv1(M->C2_PEDIDO,M->C2_PRODUTO,M->C2_ITEMPV,cFilx)

	nProdTot 	  := Round(M->C2_QUANT / M->C2_PRODHOR,2)

    If Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO,"B1_XHRTING") > 0 
		nProdTot += Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO,"B1_XHRTING")
	EndIf

	M->C2_PRODTOT := noRound(nProdTot,0)+Val(Right(Str(nProdTot*100),2))*0.006

    //M->C2_LOCAL := IIf(cFilx == "90","90",M->C2_LOCAL)
     
    oDlgEspe:End()
Return
 
/*---------------------------------------------------------------------*
 | Func:  fLimpar                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  05/06/2015                                                   |
 | Desc:  Função que limpa os dados da rotina                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function fLimpar()
    //Zerando gets
    cGetPesq := Space(100)
    oGetPesq:Refresh()
 
    //Atualiza grid
    fPopula()
     
    //Setando o foco na pesquisa
    oGetPesq:SetFocus()
Return
 
/*---------------------------------------------------------------------*
 | Func:  fCancela                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  05/06/2015                                                   |
 | Desc:  Função de cancelamento da rotina                             |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function fCancela()
    //Setando o retorno em branco e finalizando a tela
    lRetorn := .F.
    __cRetorn := Space(nTamanRet)
    oDlgEspe:End()
Return
 
/*---------------------------------------------------------------------*
 | Func:  fVldPesq                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  05/06/2015                                                   |
 | Desc:  Função que valida o campo digitado                           |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function fVldPesq()
    Local lRet := .T.
     
    //Se tiver apóstrofo ou porcentagem, a pesquisa não pode prosseguir
    If "'" $ cGetPesq .Or. "%" $ cGetPesq
        lRet := .F.
        MsgAlert("<b>Pesquisa inválida!</b><br>A pesquisa não pode ter <b>'</b> ou <b>%</b>.", "Atenção")
    EndIf
     
    //Se houver retorno, atualiza grid
    If lRet
        fPopula()
    EndIf
Return lRet




/*
RETORNA A QUANTIDADE SOMADA DE TODOS OS ITENS DO PEDIDO DE VENDA
*/
Static Function QtdPdv1(cNum,cProd,cItem,cFilx)
	Local nVal := 0
	Local cSql := ""

	Default cNum  := ""
	Default cProd := ""
	Default cItem := ""
    Default cFilx := xFilial("SC6")

	cSql := "SELECT SUM(SC6.C6_QTDVEN) QTDE FROM "+RetSqlName("SC6")+ " SC6 WHERE SC6.C6_FILIAL = '"+cFilx+"' AND SC6.C6_NUM = '"+cNum+"' AND SC6.D_E_L_E_T_<>'*' AND SC6.C6_PRODUTO = '"+cProd+"' "+IIf(!Empty(cItem),"AND C6_ITEM = '"+cItem+"' ","")

	If Select("QC6") > 0
		QC6->(DbCloseArea())
	EndIf

	TcQuery ChangeQuery(cSql) New Alias "QC6"

	nVal := QC6->QTDE

	If Select("QC6") > 0
		QC6->(DbCloseArea())
	EndIf

Return nVal
