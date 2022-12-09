#INCLUDE "Protheus.ch"
#INCLUDE "Rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M185FGR     ºAutor  ³Felipe Valenca      º Data ³  26-04-12 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Pedido de Venda e Nota na baixa da requisição         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Jestec                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M185FGR

    Local _aArea 		:= GetArea()

    Private  _oDlg
    Private oCliFor
    Private oCli

    Private cTes 		:= Space(3)
    Private cMsg 		:= Space(200)
    Private cPad 		:= Space(3)
    Private cCliente 	:= Space(6)
    Private cTransp 	:= Space(6)
    Private cLoja	 	:= Space(2)
    Private aTipo 		:= {}
    Private	_cNum 		:= GetSXENum("SC5","C5_NUM")
    Private cClifor 	:= "Cliente"
    Private cCP			:= "SA1"
    Private cMsgX 		:= ""
    Private _cProjeto	:= ""
    Public cTipo 		:= Space(1)
    Private cPerg		:= "TELASA"
    Private aTes		:= {}

    aTipo := {"N=Normal","C=Comp.Preços","I=Comp.ICMS","P=Comp.IPI","D=Dev.Compras","B=Utiliza Fornecedor"}
    cTipo := "N"

    dbSelectArea("AFH")
    dbSetOrder(2)
    If dbSeek(xFilial("AFH")+aDadosCQ[1][2],.F.)
        _cProjeto := AFH->AFH_PROJET
    Endif
    RestArea(_aArea)

    If !Empty(_cProjeto)
        _aArea := GetArea()
        dbSelectArea("AF8")
        dbSetOrder(1)
        dbSeek(xFilial("AF8")+_cProjeto,.F.)
        cMsgX 		:= "LOCAL DA OBRA: "+Alltrim(AF8->AF8_END) +" - "+Alltrim(AF8->AF8_BAIRRO) +" - "+ Alltrim(AF8->AF8_MUN) +"-"+Alltrim(AF8->AF8_EST)+" - SITE "+AF8->AF8_SITE
        cCliente 	:= AF8->AF8_CLIENT
        cLoja		:= AF8->AF8_LOJA
        RestArea(_aArea)
    Endif

    ValidPerg()

    If !pergunte(cPerg,.T.)
        Return
    Endif

    If MV_PAR01 == 1
        cCliFor := "Fornecedor"
        cCP		:= "SA2"
        aTipo := {"D=Dev.Compras","B=Utiliza Fornecedor"}
        cTipo := "B"
    Else
        cCliFor	:= "Cliente"
        cCP		:= "SA1"
        aTipo := {"N=Normal","C=Comp.Preços","I=Comp.ICMS","P=Comp.IPI"}
        cTipo := "N"
    Endif
    aTes		:= {"540=REMESSA PARA INDUSTRIALIZACAO POR ENCOMENDA","541=REMESSA DE MATERIAL P/ APLICACAO EM OBRA"}

    DEFINE MSDIALOG _oDlg TITLE "Informações do Pedido" FROM 8,0 TO 30,80 of _oDlg

    @ 30,010 Say "Tipo do Pedido" Size 70,15 Pixel Of _oDlg
    @ 28,050 ComboBox cTipo Items aTipo  Size 60,10 Pixel Of _oDlg //VALID xCliFor(cTipo,@cCP)

    @ 30,160 Say cCliFor Size 60,15 Pixel Of _oDlg
    @ 28,200 MsGet cCliente F3 cCP Valid xGetCliFor(cCliente,@cLoja) SIZE 25,10 Pixel Of _oDlg
    @ 28,240 MsGet cLoja SIZE 15,10 Pixel Of _oDlg

    @ 50, 010 Say "Mensagem" Size 60,15 Pixel Of _oDlg
    @ 48, 050 MsGet cMsg Size 220,10 Pixel Of _oDlg

    @ 70, 010 Say "Mens.Pad." Size 60,15 Pixel Of _oDlg
    @ 68, 050 MsGet cPad F3 "SM4" SIZE 25,10 Pixel Of _oDlg

    @ 70,130 Say "Tipo Saida" Size 60,15 Pixel Of _oDlg
    @ 68,170 ComboBox cTes Items aTes SIZE 150,10 Pixel Of _oDlg

    @ 90,010 Say "Transporte" Size 60,15 Pixel Of _oDlg
    @ 88,050 MsGet cTransp F3 "SA4" SIZE 25,10 Pixel Of _oDlg


    ACTIVATE MSDIALOG _oDlg ON INIT EnchoiceBar( _oDlg, { || Processa( {|| xPedido()},"Gerando Pedido..."  ),_oDlg:End()}, {||_oDlg:End()},,) CENTERED


Return


Static Function xPedido

    Local	_aCabPv		:= {}
    Local 	_aItempv	:= {}
    Local	_aItens		:= {}
    Local 	_nPrcUni	:= 0
    Local   _cTipo		:=""
    Local 	_lPreco		:= .F.
    Private	lMSErroAuto	:= .F.

    If cTipo$"BD"
        _cTipo	:=	IIf(Posicione("SA2",1,xFilial("SA2")+cCliente+cLoja,"A2_TIPO")$"J","R","F")
    Else
        _cTipo	:=	Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_TIPO")
    EndIf

    _aCabPv := 	{{"C5_NUM"    ,_cNum			    									,Nil},; // Numero do pedido
    {"C5_TIPO"  , cTipo	                          									,Nil},; // Tipo do Pedido
    {"C5_CLIENTE", cCliente															,Nil},; // Cliente / Fornecedor
    {"C5_LOJACLI", cLoja													        ,Nil},; // Loja do cliente
    {"C5_TIPOCLI", _cTipo															,Nil},; // Tipo Cliente
    {"C5_TRANSP",  cTransp	                   										,Nil},; // Transportadora
    {"C5_CONDPAG", "001"	                   										,Nil},; // Condição de Pagamento
    {"C5_NATUREZ", "1010104"	               										,Nil},; // Natureza
    {"C5_MENPAD" , cPAD																,Nil},; // Mensagem Padrao
    {"C5_MENNOTA", Upper(cMsg)														,Nil},; // Mensagem Para Nota Fiscal
    {"C5_XMENNOT", Upper(cMsgx)														,Nil},; // Mensagem Para Nota Fiscal
    {"C5_TIPLIB" ,"1"         														,Nil},; // Tipo de Liberacao
    {"C5_LIBEROK","S"                           									,Nil},;
        {"C5_MOEDA"  ,1																	,Nil},;
        {"C5_XSOLICI",SCP->CP_NUM														,Nil}} // Requisicao


    For _nX := 1 to Len(aDadosCQ)

        If aDadosCQ[_nX][1] == .T.

            If Posicione("SB1",1,xFilial("SB1")+aDadosCQ[_nX][4],"B1_UPRC") <> 0
                _nPrcUni := A410Arred(Posicione("SB1",1,xFilial("SB1")+aDadosCQ[_nX][4],"B1_UPRC"),"C6_PRUNIT")
            Elseif Posicione("SB1",1,xFilial("SB1")+aDadosCQ[_nX][4],"B1_PRV1") <> 0
                _nPrcUni := A410Arred(Posicione("SB1",1,xFilial("SB1")+aDadosCQ[_nX][4],"B1_PRV1"),"C6_PRUNIT")
            Else
                MsgAlert("Verifique as movimentações e/ou cadastro do produto "+ALLTRIM(aDadosCQ[_nX][4])+", pois o mesmo não possui histórico de preço.")
                _nPrcUni := 1
                _lPreco := .T.
            Endif

            aAdd(_aItempv,{"C6_ITEM"     ,aDadosCQ[_nX][3]				,Nil})
            aAdd(_aItempv,{"C6_PRODUTO"  ,aDadosCQ[_nX][4]        		,Nil})
            aAdd(_aItempv,{"C6_QTDVEN"   ,Val(aDadosCQ[_nX][8])		    ,Nil})
            aAdd(_aItempv,{"C6_PRUNIT" 	 ,_nPrcUni						,Nil}) // PRECO DE LISTA
            aAdd(_aItempv,{"C6_PRCVEN"   ,_nPrcUni						,Nil})
            Aadd(_aItempv,{"C6_VALOR"	 ,A410Arred((Val(aDadosCQ[_nX][8])*_nPrcUni),"C6_VALOR")     ,Nil})    // Total
            aAdd(_aItempv,{"C6_ENTREG"   ,dDataBase						,Nil})//SIVA->EMISSAO
            aAdd(_aItempv,{"C6_UM"   	 ,aDadosCQ[_nX][7]				,Nil})
            aAdd(_aItempv,{"C6_TES"      ,cTes							,Nil})	//516
            aAdd(_aItempv,{"C6_LOCAL"    ,aDadosCQ[_nX][6]     			,Nil})
            aAdd(_aItempv,{"C6_DESCONT"	 ,0	           					,Nil})
            aAdd(_aItempv,{"C6_VALDESC"	 ,0	           					,Nil})
            aAdd(_aItempv,{"C6_CLI"      ,cCliente						,Nil}) // Cliente
            aAdd(_aItempv,{"C6_LOJA"     ,cLoja							,Nil}) // Loja do Cliente
            aAdd(_aItempv,{"C6_QTDLIB"   ,Val(aDadosCQ[_nX][8])			,Nil}) //Quantidade
            aAdd(_aItempv,{"C6_NUM"	     ,_cNum							,Nil}) //Num Pedido
            AADD(_aItens,aClone(_aItempv))
        Endif

    Next

    If Len(_aCabpv)>0 .And. Len(_aItens)>0
        MSExecAuto({|x,y,z|Mata410(x,y,z)},_aCabpv,_aItens,3)

        IF !lMSErroAuto
            ConfirmSX8()
            Iif(!_lPreco,xGeraNota(),Alert("Não Gerou Pedido de Venda."))
        Else
            Alert("Erro ao incluir o pedido")
            RollBackSX8()
            MostraErro()
            DisarmTransaction()
        Endif

    Endif

Return


Static  Function xGeraNota

    Local _aPvlNfs := {}
    Local _nPrcVen := 0

    dbSelectArea("SC5")
    SC5->(dbSetOrder(1))
    SC5->(MsSeek(xFilial("SC5")+_cNum))

    dbSelectArea("SC6")
    SC6->(dbSetOrder(1))
    SC6->(MsSeek(xFilial("SC6")+_cNum))

    While SC6->(!Eof() .And. C6_FILIAL == xFilial("SC6")) .And.;
            SC6->C6_NUM == _cNum

//	MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.T.,.T.) 
//	MaLiberOk({ SC5->C5_NUM },.T.) 

        SC9->(DbSetOrder(1))
        SC9->(MsSeek(xFilial("SC9")+SC6->(C6_NUM+C6_ITEM)))

        SE4->(DbSetOrder(1))
        SE4->(MsSeek(xFilial("SE4")+SC5->C5_CONDPAG))

        SB1->(DbSetOrder(1))
        SB1->(MsSeek(xFilial("SB1")+SC6->C6_PRODUTO))

        SB2->(DbSetOrder(1))
        SB2->(MsSeek(xFilial("SB2")+SC6->(C6_PRODUTO+C6_LOCAL)))

        SF4->(DbSetOrder(1))
        SF4->(MsSeek(xFilial("SF4")+SC6->C6_TES))

        Aadd(_aPvlNfs,{;
            SC9->C9_PEDIDO,;
            SC9->C9_ITEM,;
            SC9->C9_SEQUEN,;
            SC9->C9_QTDLIB,;
            SC9->C9_PRCVEN,;
            SC9->C9_PRODUTO,;
            .F.,;
            SC9->(RecNo()),;
            SC5->(RecNo()),;
            SC6->(RecNo()),;
            SE4->(RecNo()),;
            SB1->(RecNo()),;
            SB2->(RecNo()),;
            SF4->(RecNo())})

        SC6->(DbSkip())
    EndDo

    If ( Len(_aPvlNfs) >0)
        MaPvlNfs(_aPvlNfs,"1  ", .F., .F., .F., .T., .F., 0, 0, .F. ,.F.)
//	AutoNfeEnv(cEmpAnt,SF2->F2_FILIAL,"0","1",SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_DOC)
        Alert("Nota "+SF2->F2_DOC+" do pedido "+_cNum+" gerada! Transmita a nota.")
//	Alert("Nota "+SF2->F2_DOC+" do pedido "+_cNum+" transmitida com sucesso! Imprima a Danfe.")
        _aPvlNfs	:= {}
    EndIf

Return()

Static Function xCliFor(cTipo,cCP)

    If !cTipo$"BD"
        cCliFor := "Cliente"
        cCP		:= "SA1"
    Else
        cCliFor := "Fornecedor"
        cCP		:= "SA2"
    EndIf

    oCliFor:Refresh()
    _oDlg:Refresh()


Return .t.


Static Function xGetCliFor(cCliente)

    If cTipo$"BD"
        cCliente := SA2->A2_COD
        cLoja	 := SA2->A2_LOJA
    Else
        cCliente := SA1->A1_COD
        cLoja	 := SA1->A1_LOJA
    EndIf

Return .T.


    *---------------------------------*
Static Function ValidPerg()
    *---------------------------------*

    Local _sAlias := Alias()
    Local aRegs := {}
    Local i,j

    DBSelectArea("SX1") ; DBSetOrder(1)
    cPerg := PADR(cPerg,10)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
    AADD(aRegs,{cperg,"01","Utiliza Fornecedor ?"				,"","","mv_ch01","N", 1,0,0,"C","","mv_par01","Sim","Sim","Sim","Não","Não","Não","","","","","","","","","","","","","",""})

    For i:=1 to Len(aRegs)
        If !dbSeek(cPerg+aRegs[i,2])

            RecLock("SX1",.T.)
            For j:=1 to FCount()
                If j <= Len(aRegs[i])
                    FieldPut(j,aRegs[i,j])
                EndIf
            Next
            MsUnlock()


        EndIf
    Next

    dBSelectArea(_sAlias)

Return