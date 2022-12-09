#Include "Protheus.ch"
#Include "topconn.ch"
#Include "TbiConn.ch"

User Function vnda760()

Local oDlg 
Local oLista
Local cTitulo := "Status dos pedidos"
Local aCabec 	:= {}
Local aColsEx   := {}
Local aACampos  := {}
//Local aBotoes 	:= {}

Local lJob	:= (Select('SX6')==0)   //se o ambiente protheus esta aberto ou não
Local lBlind  := IsBlind()		    //se esta rodando um job ou não

Local lCont := .t.
Local aRet  := {}
Local aPar  := {}
Local dInicio := Date()-2
Local dFim    := Date()
Local cPedGar := space(10)
Local cPedSit := space(10)
Local cPedEco := space(16)

Local nPedSit := 0

Private oAzul  	  := LoadBitmap( GetResources(), "BR_AZUL")
Private oVermelho := LoadBitmap( GetResources(), "BR_VERMELHO")

	if lJob
		RpcClearEnv()
		RpcSetType(3)
		RpcSetEnv( '01', '02', , , "FAT" )
    endif

    if lBlind

        aColsEx := PopulaPed(dInicio,dFim,cPedGar,cPedSit,cPedEco)
        //for nI : 1 to len(aColsEx)
        //next

    else

        dInicio := Date()-15
        dFim    := Date()
/*
			        //X3Titulo()	X3_CAMPO		X3_PICTURE	X3_TAMANHO	X3_DECIMAL	X3_VALID   X3_USADO    X3_TIPO     X3_F3   X3_CONTEXT  X3_CBOX X3_RELACAO  X3_WHEN
    	Aadd(aCabec, {""            ,"IMAGEM"       ,"@BMP"     ,03         ,0          ,".F."     ,""         ,"C",	   "",	   "V",		   "",	   "",	       ""      ,	"V"})
		Aadd(aCabec, {"ID"          ,"GT_ID"        ,"@!"       ,24         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
		Aadd(aCabec, {"TYPE"        ,"GT_TYPE"      ,"@!"       ,01         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
	    Aadd(aCabec, {"DATE"        ,"GT_DATE"      ,"@D"       ,08         ,0          ,""        ,""         ,"D",       "",     "R",        "",     "",         ""})
        Aadd(aCabec, {"TIME"        ,"GT_TIME"      ,"@!"       ,08         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
		Aadd(aCabec, {"SEND"        ,"GT_SEND"      ,"@!"       ,01         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
		Aadd(aCabec, {"EM PROCESSO" ,"GT_INPROC"    ,"@!"       ,01         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
		Aadd(aCabec, {"Ped.SITE"    ,"GT_XNPSITE"   ,"@!"       ,10         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
		Aadd(aCabec, {"CNPJ CON"    ,"GT_CNPJCON"   ,"@!"       ,14         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
		Aadd(aCabec, {"CNPJ FAT"    ,"GT_CNPJFAT"   ,"@!"       ,14         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
		Aadd(aCabec, {"ORIGEM"      ,"GT_ORIGVEN"   ,"@!"       ,01         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
		Aadd(aCabec, {"PED ECOM"    ,"GT_XNPECOM"   ,"@!"       ,16         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})

        nPedSit := aScan(aCabec,{|x| AllTrim(x[2]) == "GT_XNPSITE" })
*/

			        //X3Titulo()	X3_CAMPO		X3_PICTURE	X3_TAMANHO	X3_DECIMAL	X3_VALID   X3_USADO    X3_TIPO     X3_F3   X3_CONTEXT  X3_CBOX X3_RELACAO  X3_WHEN
    	Aadd(aCabec, {""            ,"IMAGEM"       ,"@BMP"     ,03         ,0          ,".F."     ,""         ,"C",	   "",	   "V",		   "",	   "",	       ""      ,	"V"})
		Aadd(aCabec, {"Ped.Erp"     ,"C5_NUM"       ,"@!"       ,06         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
		Aadd(aCabec, {"Emissão"     ,"C5_EMISSAO"   ,"@D"       ,08         ,0          ,""        ,""         ,"D",       "",     "R",        "",     "",         ""})
	    Aadd(aCabec, {"Cliente"     ,"C5_CLIENTE"   ,"@!"       ,09         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
        Aadd(aCabec, {"No.Parc"     ,"C5_XNPARCE"   ,"@!"       ,02         ,0          ,""        ,""         ,"N",       "",     "R",        "",     "",         ""})
		Aadd(aCabec, {"Ped.Site"    ,"C5_XNPSITE"   ,"@!"       ,10         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
		Aadd(aCabec, {"Ped.eCom"    ,"C5_XNPECOM"   ,"@!"       ,16         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
        Aadd(aCabec, {"Item"        ,"C6_ITEM"      ,"@!"       ,02         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
		Aadd(aCabec, {"Operação"    ,"C6_XOPER"     ,"@!"       ,02         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
		Aadd(aCabec, {"Voucher"     ,"C6_XNUMVOU"   ,"@!"       ,14         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
		Aadd(aCabec, {"Produto"     ,"C6_PRODUTO"   ,"@!"       ,01         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
        Aadd(aCabec, {"Pro.Gar"     ,"C6_PROGAR"    ,"@!"       ,15         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
		Aadd(aCabec, {"Ped.Gar"     ,"C6_PEDGAR"    ,"@!"       ,10         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})

        nPedSit := aScan(aCabec,{|x| AllTrim(x[2]) == "C5_XNPSITE" })

        //aAdd(aPar,{9,"Informe parÃ¢metros",200,7,.T.})
        aAdd(aPar,{1,"Emissão de :",dInicio,"","" ,"",".T.",0,.T.})
        aAdd(aPar,{1,"Emissão até:",dFim   ,"","" ,"",".T.",0,.T.})
        aAdd(aPar,{1,"Pedido Gar :",cPedGar,"","" ,"",".T.",0,.F.})
        aAdd(aPar,{1,"Pedido Site:",cPedSit,"","" ,"",".T.",0,.F.})
        aAdd(aPar,{1,"Pedido eCom:",cPedEco,"","" ,"",".T.",0,.F.})

        //aadd(aBotoes,{"BMPCONS"       , {|| verAcoes(oLista:acols[oLista:nAt,7]) } ,"Eventos do Pedido","Eventos do Pedido"})
        //aadd(aBotoes,{"NG_ICO_LEGENDA", {|| Legenda() }                            ,"Legenda"          ,"Legenda"})

        While lCont

            if ParamBox(aPar,"Parâmetros...",@aRet)

                dInicio := aPar[1,3] := aRet[1]
                dFim    := aPar[2,3] := aRet[2]
                cPedGar := aPar[3,3] := aRet[3]
                cPedSit := aPar[4,3] := aRet[4]
                cPedEco := aPar[5,3] := aRet[5]
                
                if dFim - dInicio > 60
                    MsgInfo("Este programa somente executará um limite de 60 dias por perí­odo definido !")
                    Loop
                elseif dFim - dInicio < 0
                    MsgInfo("Verifique os parametros de data !")
                    Loop
                endif

                aColsEx := PopulaPed(dInicio,dFim,cPedGar,cPedSit,cPedEco)

                if len(aColsEx) > 0

                    DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000, 000  TO 400, 1200  PIXEL

                        //EnchoiceBar(oDlg, {|| oDlg:End() }, {|| oDlg:End() },,aBotoes)
                        @ 10,010 BUTTON "&Ver Eventos" SIZE 32,10 PIXEL ACTION verAcoes(oLista:acols[oLista:nAt,nPedSit])
                        @ 10,060 BUTTON "&Sair"        SIZE 32,10 PIXEL ACTION (oDlg:End(),lCont:=.f.)
                        @ 10,110 BUTTON "&Legenda"     SIZE 32,10 PIXEL ACTION Legenda()

                        oLista:=MsNewGetDados():New( 030, 001, 200, 600, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", aACampos,1, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aCabec, aColsEx)
                        oLista:SetArray(aColsEx,.T.)
                        oLista:Refresh()
                        oLista:oBrowse:SetFocus()

                    ACTIVATE MSDIALOG oDlg CENTERED

                else

                    MsgInfo("Sem Política de Garantia neste perí­odo !")

                endif

            else
                lCont := .f.
            endif

        end

	endif

Return

Static function Legenda()

local aLegenda := {}
		
	aAdd( aLegenda,{"BR_VERMELHO" ,"   Pedido não processado."	})
	aAdd( aLegenda,{"BR_AZUL"     ,"   Pedido processado.    " 	})    
	BrwLegenda("Legenda pedidos", "Legenda", aLegenda)

Return Nil

Static function Legacao()

local aLegenda := {}
		
	aAdd( aLegenda,{"BR_VERMELHO" ,"   Ação com problemas."	})
	aAdd( aLegenda,{"BR_AZUL"     ,"   Ação executada s/ problemas." 	})    
	BrwLegenda("Legenda ações", "Legenda", aLegenda)

Return Nil

Static Function PopulaPed(dInicio,dFim,cPedGar,cPedSit,cPedEco)
Local cSql := ""
Local aColsEx := {}
Local cTrb  := ''
Local oObjCor
/*
	cSql := "SELECT GT.GT_ID,GT.GT_TYPE,GT.GT_DATE,GT.GT_TIME,GT.GT_SEND,GT.GT_INPROC,GT.GT_XNPSITE,GT.GT_CNPJCON," + CRLF
    cSql += "GT.GT_CNPJFAT,GT.GT_ORIGVEN,GT.GT_XNPECOM " + CRLF
    cSql += "FROM GTIN GT " + CRLF
    cSql += "WHERE GT.GT_DATE >= '"+DtoS(dInicio)+"' AND GT.GT_DATE <= '"+DtoS(dFim)+"' AND GT.GT_TYPE = 'F' AND GT.D_E_L_E_T_ = ' ' AND GT.GT_XNPSITE = GT.GT_PEDGAR " + CRLF
    if !empty(cPedGar)
       cSql += "AND GT.GT_PEDGAR = '"+cPedGar+"' " + CRLF
    endif
    if !empty(cPedSit)
       cSql += "AND GT.GT_XNPSITE = '"+cPedSit+"' " + CRLF
    endif
    if !empty(cPedEco)
       cSql += "AND GT.GT_XNPECOM = '"+cPedEco+"' " + CRLF
    endif
    cSql += "ORDER BY GT.GT_DATE, GT.GT_TIME, GT.GT_TYPE "
*/
	cSql := "SELECT C5_NUM,C5_EMISSAO,C5_CLIENTE,C5_LOJACLI,C5_XNPARCE,C5_XNPSITE,C5_XNPECOM,C5_CHVBPAG,"
	cSql += "C6_ITEM,C6_XOPER,C6_XNUMVOU,C6_PRODUTO,C6_PROGAR,C6_XPEDORI,C6_XNPECOM,C6_PEDGAR "
	cSql += "FROM "+RetSqlName("SC5")+" SC5 "
    cSql += "INNER JOIN "+RetSqlName("SC6")+" SC6 ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND SC6.D_E_L_E_T_ = ' ' "
    cSql += "WHERE C5_FILIAL = '"+xFilial("SC5")+"' AND SC5.D_E_L_E_T_ = ' ' "
    cSql += "AND C5_EMISSAO >= '"+DtoS(dInicio)+"' AND C5_EMISSAO <= '"+DtoS(dFim)+"' "
    cSql += "AND C5_XNPSITE != ' ' "
    if !empty(cPedSit)
        cSql += "AND C5_XNPSITE = '"+cPedSit+"' "
    endif
    if !empty(cPedEco)
        cSql += "AND C5_XNPECOM = '"+cPedEco+"' "
    endif
    if !empty(cPedGar)
        cSql += "AND C6_PEDGAR = '"+cPedGar+"' "
    endif

    cSql := ChangeQuery( cSql )
	cTrb := GetNextAlias()

	dbUseArea(.t.,"TOPCONN",TcGenQry(,,cSql),cTrb,.f.,.t.)
    //TcSetField( cTrb, "GT_DATE" , "D",  8, 0 ) 
    TcSetField( cTrb, "C5_EMISSAO" , "D",  8, 0 ) 

	While !(cTrb)->( Eof() )

/*
		oObjCor := Iif( (cTrb)->GT_INPROC == "T", oAzul, oVermelho )
				
		aadd(aColsEx, { oObjCor, ;
                        (cTrb)->GT_ID,;
                        (cTrb)->GT_TYPE,;
                        (cTrb)->GT_DATE,;
                        (cTrb)->GT_TIME,;
                        (cTrb)->GT_SEND,;
                        (cTrb)->GT_INPROC,;
                        (cTrb)->GT_XNPSITE,;
                        (cTrb)->GT_CNPJCON,;
                        (cTrb)->GT_CNPJFAT,;
                        (cTrb)->GT_ORIGVEN,;
                        (cTrb)->GT_XNPECOM,;
                        .f. })
*/
		oObjCor := oAzul
				
		aadd(aColsEx, { oObjCor, ;
                        (cTrb)->C5_NUM,;
                        (cTrb)->C5_EMISSAO,;
                        (cTrb)->C5_CLIENTE+"/"+(cTrb)->C5_LOJACLI,;
                        (cTrb)->C5_XNPARCE,;
                        (cTrb)->C5_XNPSITE,;
                        (cTrb)->C5_XNPECOM,;
                        (cTrb)->C6_ITEM,;
                        (cTrb)->C6_XOPER,;
                        (cTrb)->C6_XNUMVOU,;
                        (cTrb)->C6_PRODUTO,;
                        (cTrb)->C6_PROGAR,;
                        (cTrb)->C6_PEDGAR,;
                        .f. })
		(cTrb)->( dbSkip() )
	
    End

	(cTrb)->( dbCloseArea() )
	FErase( cTrb + GetDBExtension() )

Return aColsEx

Static function verAcoes(cXNPSITE)
Local oDlg 
Local oLista
Local oGet
Local cTitulo := "Eventos do pedido Site"
Local aCabec  := {}
Local aColsEx := {}
Local aACampos:= {}
//Local aBotoes := {}

Local cLabelText := ""
Local nLabelPos  := 1
Local lHasButton := .F.
Local lNoButton  := .T.

Local ntype   := 0
Local nDate   := 0
Local nCodMsg := 0
Local nReturn := 0

		        //X3Titulo()	X3_CAMPO		X3_PICTURE	X3_TAMANHO	X3_DECIMAL	X3_VALID   X3_USADO    X3_TIPO     X3_F3   X3_CONTEXT  X3_CBOX X3_RELACAO  X3_WHEN
   	Aadd(aCabec, {""            ,"IMAGEM"       ,"@BMP"     ,03         ,0          ,".F."     ,""         ,"C",	   "",	   "V",		   "",	   "",	       ""      ,	"V"})
	Aadd(aCabec, {"TYPE"        ,"GT_TYPE"      ,"@!"       ,01         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
    Aadd(aCabec, {"DATE"        ,"GT_DATE"      ,"@D"       ,08         ,0          ,""        ,""         ,"D",       "",     "R",        "",     "",         ""})
    Aadd(aCabec, {"TIME"        ,"GT_TIME"      ,"@!"       ,08         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
    Aadd(aCabec, {"PEDGAR"      ,"GT_PEDGAR"    ,"@!"       ,10         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
    Aadd(aCabec, {"CODMSG"      ,"GT_CODMSG"    ,"@!"       ,06         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
    Aadd(aCabec, {"STATUS"      ,"GT_STATUS"    ,"@!"       ,01         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
    Aadd(aCabec, {"ULTIMO"      ,"GT_ULTIMO"    ,"@!"       ,01         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
	Aadd(aCabec, {"SEND"        ,"GT_SEND"      ,"@!"       ,01         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
	Aadd(aCabec, {"RETURN"      ,"GT_RETURN"    ,"@!"       ,40         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})

    ntype   := aScan(aCabec,{|x| AllTrim(x[2]) == "GT_TYPE" })
    nDate   := aScan(aCabec,{|x| AllTrim(x[2]) == "GT_DATE" })
    nCodMsg := aScan(aCabec,{|x| AllTrim(x[2]) == "GT_CODMSG" })
    nReturn := aScan(aCabec,{|x| AllTrim(x[2]) == "GT_RETURN" })

    aColsEx := PopulaAcoes(cXNPSITE)

    if len(aColsEx) > 0

       //aadd(aBotoes,{"BMPCONS"       , {|| verReturn(cXNPSITE,oLista:acols[oLista:nAt,9]) } ,"Ação do evento","Ação do evento"})

       DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000, 000  TO 400, 700  PIXEL

           cLabelText := "PEDIDO SITE"
           oGet := TGet():New(003,005,{|u|If(PCount()==0,cXNPSITE ,cXNPSITE := u)},oDlg,040,010,"@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"cXNPSITE",,,, lHasButton , lNoButton,, cLabelText, nLabelPos)

           //EnchoiceBar(oDlg, {|| oDlg:End() }, {|| oDlg:End() },,aBotoes)
           @ 10,060 BUTTON "&Ver Ação" SIZE 32,10 PIXEL ACTION verReturn(cXNPSITE,oLista:acols[oLista:nAt,ntype],oLista:acols[oLista:nAt,nDate],oLista:acols[oLista:nAt,nCodMsg],oLista:acols[oLista:nAt,nReturn])
           @ 10,110 BUTTON "&Sair"     SIZE 32,10 PIXEL ACTION oDlg:End()
           @ 10,160 BUTTON "&Legenda"  SIZE 32,10 PIXEL ACTION Legacao()

           oLista:=MsNewGetDados():New( 030, 001, 190, 350, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", aACampos,1, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aCabec, aColsEx)
           oLista:SetArray(aColsEx,.T.)
           oLista:Refresh()
           oLista:oBrowse:SetFocus()

       ACTIVATE MSDIALOG oDlg CENTERED

    else

       MsgInfo("Sem ações para o pedido "+cXNPSITE+" !")

    endif

return nil

Static Function PopulaAcoes(cXNPSITE)
Local cSql := ""
Local aColsEx := {}
Local cTrb  := ''
Local oObjCor

	cSql := "SELECT OU.GT_TYPE,OU.GT_DATE,OU.GT_TIME,OU.GT_PEDGAR,OU.GT_CODMSG,OU.GT_STATUS,"
    cSql += "OU.GT_ULTIMO,OU.GT_SEND,OU.GT_XNPSITE,"
    cSql += "utl_raw.cast_to_varchar2(dbms_lob.substr(OU.GT_RETURN,5000,1)) GT_RETURN "
    cSql += "FROM GTOUT OU WHERE OU.GT_XNPSITE = '"+cXNPSITE+"' AND D_E_L_E_T_ = ' ' "
    cSql += "ORDER BY OU.GT_DATE, OU.GT_TIME, OU.GT_TYPE, OU.GT_PEDGAR "

    cSql := ChangeQuery( cSql )
	cTrb := GetNextAlias()

	dbUseArea(.t.,"TOPCONN",TcGenQry(,,cSql),cTrb,.f.,.t.)
    TcSetField( cTrb, "GT_DATE" , "D",  8, 0 ) 

	While !(cTrb)->( Eof() )

		oObjCor := Iif( substr((cTrb)->GT_CODMSG,1,1) == "E", oVermelho, oAzul )

        aadd(aColsEx, { oObjCor, ;
                        (cTrb)->GT_TYPE,;
                        (cTrb)->GT_DATE,;
                        (cTrb)->GT_TIME,;
                        (cTrb)->GT_PEDGAR,;
                        (cTrb)->GT_CODMSG,;
                        (cTrb)->GT_STATUS,;
                        (cTrb)->GT_ULTIMO,;
                        (cTrb)->GT_SEND,;
                        (cTrb)->GT_RETURN,;
                        .f. })
				
		(cTrb)->( dbSkip() )
	
    End

	(cTrb)->( dbCloseArea() )
	FErase( cTrb + GetDBExtension() )

Return aColsEx

Static function verReturn(cXNPSITE, cType, dDate, cCodMsg, cReturn)
Local oDlg 
Local oGet
Local cTitulo := "Ação executada para o pedido Site"
//Local aBotoes := {}
Local oReturn

Local cLabelText := ""
Local nLabelPos  := 1
Local lHasButton := .F.
Local lNoButton  := .T.

Local cDate := dtoc(dDate)

       DEFINE MSDIALOG oDlg TITLE cTitulo FROM 350, 600 TO 750, 1137  PIXEL

        cLabelText := "PEDIDO SITE"
        oGet := TGet():New(004,005,{|u|If(PCount()==0,cXNPSITE ,cXNPSITE := u)},oDlg,040,010,"@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"cXNPSITE",,,, lHasButton , lNoButton,, cLabelText, nLabelPos)
        cLabelText := "TYPE"
        oGet := TGet():New(004,055,{|u|If(PCount()==0,cType    ,cType    := u)},oDlg,040,010,"@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"cType"   ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos)
        cLabelText := "DATE"
        oGet := TGet():New(004,105,{|u|If(PCount()==0,cDate    ,cDate    := u)},oDlg,040,010,"@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"cDate"   ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos)
        cLabelText := "CÓD. MENSAGEM"
        oGet := TGet():New(004,155,{|u|If(PCount()==0,cCodMsg  ,cCodMsg  := u)},oDlg,040,010,"@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"cCodMsg" ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos)

        //EnchoiceBar(oDlg, {|| .t. }, {|| oDlg:End() },,aBotoes)
        @ 10,205 BUTTON "&Sair"     SIZE 32,10 PIXEL ACTION oDlg:End()

        //cReturn := EncodeUTF8(cReturn, "cp1252")
        //cReturn := DecodeUTF8(cReturn, "cp1252")
        cLabelText := "Ação efetuada no Evento"
        oReturn := tMultiget():new( 30, 05, {| u | if( pCount() > 0, cReturn := u, cReturn ) }, oDlg, 260, 160, , , , , , .t., , , , , , .t., , , , , , cLabelText, nLabelPos )

       ACTIVATE MSDIALOG oDlg
Return nil
