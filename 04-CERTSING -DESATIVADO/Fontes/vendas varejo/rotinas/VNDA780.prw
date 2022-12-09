#Include "Protheus.ch"
#Include "topconn.ch"
#Include "TbiConn.ch"

/*{Protheus.doc} VNDA780
SEM DESCRICAO
@author UPDUO
@since 21/07/2021
*/
User Function VNDA780()
    local oDlg 
    local oLista
    local cTitulo  := "Status dos pedidos"
    local aCabec   := {}
    local aColsEx  := {}
    local aACampos := {}
    local lJob	   := (Select('SX6')==0)   //se o ambiente protheus esta aberto ou não
    local lBlind   := IsBlind()		    //se esta rodando um job ou não
    local lCont    := .t.
    local aRet     := {}
    local aPar     := {}
    local cPedGar  := space(10)
    local cPedSit  := space(10)
    local cPedEco  := space(16)
    local nPedSit  := 0

    Private oAzul  	  := LoadBitmap( GetResources(), "BR_AZUL")
    Private oVermelho := LoadBitmap( GetResources(), "BR_VERMELHO")

    if lJob
        RpcClearEnv()
        RpcSetType( 3 )
        RpcSetEnv( '01', '02', , , "FAT" )
    endif

    if lBlind
        aColsEx := PopulaPed(cPedGar,cPedSit,cPedEco)
    else

        //dInicio := Date()-30
        //dFim    := Date()
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

        aAdd(aPar,{1,"Pedido Gar :",cPedGar,"","" ,"",".T.",0,.F.})
        aAdd(aPar,{1,"Pedido Site:",cPedSit,"","" ,"",".T.",0,.F.})
        aAdd(aPar,{1,"Pedido eCom:",cPedEco,"","" ,"",".T.",0,.F.})

        While lCont

            if ParamBox(aPar,"Parâmetros...",@aRet)
                cPedGar := aPar[1,3] := aRet[1]
                cPedSit := aPar[2,3] := aRet[2]
                cPedEco := aPar[3,3] := aRet[3]

                if Empty(cPedGar) .and. empty(cPedSit) .and. empty(cPedEco)
                    MsgInfo("Favor preencher um dos parâmetros: pedidos Gar, eCommerce ou Site !")
                    Loop
                endif

                aColsEx := PopulaPed(cPedGar,cPedSit,cPedEco)

                if len(aColsEx) > 0

                    DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000, 000  TO 400, 1200  PIXEL

                        //EnchoiceBar(oDlg, {|| oDlg:End() }, {|| oDlg:End() },,aBotoes)
                        @ 10,010 BUTTON "&Ver Eventos" SIZE 35,13 PIXEL ACTION verAcoes(oLista:acols[oLista:nAt,nPedSit])
                        @ 10,060 BUTTON "&Sair"        SIZE 35,13 PIXEL ACTION (oDlg:End(),lCont:=.f.)
                        @ 10,110 BUTTON "&Legenda"     SIZE 35,13 PIXEL ACTION Legenda()

                        oLista:=MsNewGetDados():New( 030, 001, 200, 600, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", aACampos,1, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aCabec, aColsEx)
                        oLista:SetArray(aColsEx,.T.)
                        oLista:Refresh()
                        oLista:oBrowse:SetFocus()

                    ACTIVATE MSDIALOG oDlg CENTERED
                else
                    verAcoes(cPedSit,cPedEco,cPedGar)
                endif
            else
                lCont := .f.
            endif
        end
    endif
Return

/*{Protheus.doc} Legenda
SEM DESCRICAO
@author UPDUO
@since 21/07/2021
*/
Static function Legenda()
    local aLegenda := {}
		
	aAdd( aLegenda,{"BR_VERMELHO" ,"   Pedido não processado."	})
	aAdd( aLegenda,{"BR_AZUL"     ,"   Pedido processado.    " 	})    
	BrwLegenda("Legenda pedidos", "Legenda", aLegenda)
Return Nil

/*{Protheus.doc} Legacao
SEM DESCRICAO
@author UPDUO
@since 21/07/2021
*/
Static function Legacao()
    local aLegenda := {}
		
	aAdd( aLegenda,{"BR_VERMELHO" ,"   Ação com problemas."	})
	aAdd( aLegenda,{"BR_AZUL"     ,"   Ação executada s/ problemas." 	})    
	BrwLegenda("Legenda ações", "Legenda", aLegenda)
Return Nil

/*{Protheus.doc} PopulaPed
SEM DESCRICAO
@author UPDUO
@since 21/07/2021
*/
Static Function PopulaPed(cPedGar,cPedSit,cPedEco)
    local cSql    := ""
    local aColsEx := {}
    local cTrb    := ''
    local oObjCor

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
	cSql := "SELECT C5_NUM,C5_EMISSAO,C5_CLIENTE,C5_LOJACLI,C5_XNPARCE,C5_XNPSITE,C5_XNPECOM,C5_CHVBPAG," + CRLF
	cSql += "C6_ITEM,C6_XOPER,C6_XNUMVOU,C6_PRODUTO,C6_PROGAR,C6_XPEDORI,C6_XNPECOM,C6_PEDGAR " + CRLF
	cSql += "FROM "+RetSqlName("SC5")+" SC5 " + CRLF
    cSql += "INNER JOIN "+RetSqlName("SC6")+" SC6 ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND SC6.D_E_L_E_T_ = ' ' " + CRLF
    cSql += "WHERE C5_FILIAL = '"+xFilial("SC5")+"' AND SC5.D_E_L_E_T_ = ' ' " + CRLF

    if !empty(cPedSit)
        cSql += "AND C5_XNPSITE = '"+cPedSit+"' " + CRLF
    endif
    if !empty(cPedEco)
        cSql += "AND C5_XNPECOM = '"+cPedEco+"' " + CRLF
    endif
    if !empty(cPedGar)
        cSql += "AND (C5_CHVBPAG = '"+cPedGar+"' OR C6_PEDGAR = '"+cPedGar+"') " + CRLF
    endif
    cSql += "ORDER BY C5_EMISSAO,C5_NUM,C6_ITEM "

    cSql := ChangeQuery( cSql )
	cTrb := GetNextAlias()

	dbUseArea(.t.,"TOPCONN",TcGenQry(,,cSql),cTrb,.f.,.t.)
    TcSetField( cTrb, "C5_EMISSAO" , "D",  8, 0 ) 

	While !(cTrb)->( Eof() )
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

/*{Protheus.doc} verAcoes
SEM DESCRICAO
@author UPDUO
@since 21/07/2021
*/
Static function verAcoes(cXNPSITE,cXNPECOM,cPEDGAR)
    local oDlg 
    local oLista
    local oGet
    local cTitulo := iif(!empty(cXNPSITE),"Eventos do pedido Site",iif(!empty(cXNPECOM),"Eventos do pedido eCom",iif(!empty(cPEDGAR),"Eventos do pedido Gar","")))
    local cPedido := iif(!empty(cXNPSITE),cXNPSITE,iif(!empty(cXNPECOM),cXNPECOM,iif(!empty(cPEDGAR),cPEDGAR,"")))
    local aCabec  := {}
    local aColsEx := {}
    local aACampos:= {}
    local cLabelText := ""
    local nLabelPos  := 1
    local lHasButton := .F.
    local lNoButton  := .T.
    local ntype      := 0
    local nDate      := 0
    local nCodMsg    := 0
    local nReturn    := 0

		        //X3Titulo()	X3_CAMPO		X3_PICTURE	X3_TAMANHO	X3_DECIMAL	X3_VALID   X3_USADO    X3_TIPO     X3_F3   X3_CONTEXT  X3_CBOX X3_RELACAO  X3_WHEN
   	Aadd(aCabec, {""            ,"IMAGEM"       ,"@BMP"     ,03         ,0          ,".F."     ,""         ,"C",	   "",	   "V",		   "",	   "",	       ""      ,	"V"})
	Aadd(aCabec, {"TYPE"        ,"GT_TYPE"      ,"@!"       ,01         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
    Aadd(aCabec, {"DATE"        ,"GT_DATE"      ,"@D"       ,08         ,0          ,""        ,""         ,"D",       "",     "R",        "",     "",         ""})
    Aadd(aCabec, {"TIME"        ,"GT_TIME"      ,"@!"       ,08         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
    Aadd(aCabec, {"PEDGAR"      ,"GT_PEDGAR"    ,"@!"       ,10         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
    Aadd(aCabec, {"CODMSG"      ,"GT_CODMSG"    ,"@!"       ,06         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
    Aadd(aCabec, {"MSG"         ,"Z7_DESMEN"    ,"@!"       ,60         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
    Aadd(aCabec, {"STATUS"      ,"GT_STATUS"    ,"@!"       ,01         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
    Aadd(aCabec, {"ULTIMO"      ,"GT_ULTIMO"    ,"@!"       ,01         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
	Aadd(aCabec, {"SEND"        ,"GT_SEND"      ,"@!"       ,07         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})
	Aadd(aCabec, {"RETURN"      ,"GT_RETURN"    ,"@!"       ,10         ,0          ,""        ,""         ,"C",       "",     "R",        "",     "",         ""})

    ntype   := aScan(aCabec,{|x| AllTrim(x[2]) == "GT_TYPE" })
    nDate   := aScan(aCabec,{|x| AllTrim(x[2]) == "GT_DATE" })
    nCodMsg := aScan(aCabec,{|x| AllTrim(x[2]) == "GT_CODMSG" })
    nReturn := aScan(aCabec,{|x| AllTrim(x[2]) == "GT_RETURN" })

    aColsEx := PopulaAcoes(cXNPSITE,cXNPECOM,cPEDGAR)

    if len(aColsEx) > 0

       DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000, 000  TO 400, 900  PIXEL

           cLabelText := "PEDIDO"
           oGet := TGet():New(003,005,{|u|If(PCount()==0,cPedido ,cPedido := u)},oDlg,040,010,"@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"cPedido",,,, lHasButton , lNoButton,, cLabelText, nLabelPos)

           @ 10,060 BUTTON "&Ver Ação" SIZE 35,13 PIXEL ACTION verReturn(cPedido,oLista:acols[oLista:nAt,ntype],oLista:acols[oLista:nAt,nDate],oLista:acols[oLista:nAt,nCodMsg],oLista:acols[oLista:nAt,nReturn])
           @ 10,110 BUTTON "&Sair"     SIZE 35,13 PIXEL ACTION oDlg:End()
           @ 10,160 BUTTON "&Legenda"  SIZE 35,13 PIXEL ACTION Legacao()

           oLista:=MsNewGetDados():New( 030, 001, 190, 450, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", aACampos,1, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aCabec, aColsEx)
           oLista:SetArray(aColsEx,.T.)
           oLista:Refresh()
           oLista:oBrowse:SetFocus()

       ACTIVATE MSDIALOG oDlg CENTERED

    else

       MsgInfo("Sem ações para o pedido "+cPedido+" !")

    endif

return nil

/*{Protheus.doc} PopulaAcoes
SEM DESCRICAO
@author UPDUO
@since 21/07/2021
*/
Static Function PopulaAcoes(cXNPSITE,cXNPECOM,cPEDGAR)
    local cSql     := ""
    local aColsEx  := {}
    local aColsTmp := {}
    local aFArray  := {}
    local aPArray  := {}
    local cTrb     := ''
    local cReturn  := ''
    local nIni     := 0
    local ni       := 0
    local oObjCor

	cSql := "SELECT OU.GT_TYPE,OU.GT_DATE,OU.GT_TIME,OU.GT_PEDGAR,OU.GT_CODMSG,OU.GT_STATUS,"
    cSql += "OU.GT_ULTIMO,OU.GT_SEND,OU.GT_XNPSITE,"
    cSql += "utl_raw.cast_to_varchar2(dbms_lob.substr(OU.GT_RETURN,5000,1)) GT_RETURN "
    cSql += "FROM GTOUT OU WHERE D_E_L_E_T_ = ' ' "
    if !empty(cXNPSITE)
        cSql += "AND OU.GT_XNPSITE = '"+cXNPSITE+"' "
    endif
    if !empty(cXNPECOM)
        cSql += "AND OU.GT_XNPECOM = '"+cXNPECOM+"' "
    endif
    if !empty(cPEDGAR)
        cSql += "AND OU.GT_PEDGAR = '"+cPEDGAR+"' "
    endif
    cSql += "AND OU.GT_TYPE IN ('F','P') AND substr(OU.GT_CODMSG,1,1) = 'E' "
    cSql += "ORDER BY OU.GT_DATE, OU.GT_TIME, OU.GT_TYPE, OU.GT_PEDGAR "
    cSql := ChangeQuery( cSql )
	cTrb := GetNextAlias()

	dbUseArea(.t.,"TOPCONN",TcGenQry(,,cSql),cTrb,.f.,.t.)
    TcSetField( cTrb, "GT_DATE" , "D",  8, 0 ) 

    sz7->( DbSetOrder(1) )

	While !(cTrb)->( Eof() )

        cReturn := EncodeUTF8((cTrb)->GT_RETURN, "cp1252")
        cReturn := DecodeUTF8(cReturn, "cp1252")

        if (cTrb)->GT_TYPE != 'F' .or. !("lockbyname" $ lower(cReturn))

            oObjCor := Iif( substr((cTrb)->GT_CODMSG,1,1) == "E", oVermelho, oAzul )

            sz7->( MsSeek( xFilial("SZ7")+(cTrb)->GT_CODMSG ) )

            nIni := at(lower(cReturn),"ajuda")
            if nIni > 0
               cReturn := substr(cReturn,nIni,len(cReturn))
            endif

            aadd(aColsTmp, { ++ni,;
                            oObjCor, ;
                            (cTrb)->GT_TYPE,;
                            (cTrb)->GT_DATE,;
                            (cTrb)->GT_TIME,;
                            (cTrb)->GT_PEDGAR,;
                            (cTrb)->GT_CODMSG,;
                            SZ7->Z7_DESMEN,;
                            (cTrb)->GT_STATUS,;
                            (cTrb)->GT_ULTIMO,;
                            iif((cTrb)->GT_SEND=="T","ACEITO","NEGADO"),;
                            cReturn,;
                            .f. })
            
		endif		
		(cTrb)->( dbSkip() )
	
    End

    (cTrb)->( dbCloseArea() )
	FErase( cTrb + GetDBExtension() )

    For ni := 1 to len(aColsTmp)
      if aColsTmp[ni,3] == 'F'
         aadd( aFArray, aColsTmp[ni] )
      elseif aColsTmp[ni,3] == 'P'
         aadd( aPArray, aColsTmp[ni] )
      Endif
    Next
    aColsTmp := {}
    nIni := 1
    if len(aFArray) > 3
       nIni := len(aFArray)-2
    endif
    for ni := nIni to len(aFArray)
      aadd( aColsTmp, aFArray[ni] )
    next
    nIni := 1
    if len(aPArray) > 3
       nIni := len(aPArray)-2
    endif
    for ni := nIni to len(aPArray)
      aadd( aColsTmp, aPArray[ni] )
    next
    //Ordena o Array por Nome (Array multidimensional) - Crescente
    aSort(aColsTmp, , , {|x, y| x[1] < y[1]})
    for ni := 1 to len(aColsTmp)
      aadd(aColsEx, { aColsTmp[ni,2], ;
                      aColsTmp[ni,3],;
                      aColsTmp[ni,4],;
                      aColsTmp[ni,5],;
                      aColsTmp[ni,6],;
                      aColsTmp[ni,7],;
                      aColsTmp[ni,8],;
                      aColsTmp[ni,9],;
                      aColsTmp[ni,10],;
                      aColsTmp[ni,11],;
                      aColsTmp[ni,12],;
                      aColsTmp[ni,13] ;
                    })
    next

Return aColsEx

/*{Protheus.doc} verReturn
SEM DESCRICAO
@author 
@since 21/07/2021
*/
Static function verReturn(cPedido, cType, dDate, cCodMsg, cReturn)
    local oDlg 
    local oGet
    local cTitulo    := "Ação executada para o pedido"
    local oReturn
    local cLabelText := ""
    local nLabelPos  := 1
    local lHasButton := .F.
    local lNoButton  := .T.
    local cDate      := dtoc(dDate)

       DEFINE MSDIALOG oDlg TITLE cTitulo FROM 350, 600 TO 750, 1137  PIXEL

        cLabelText := "PEDIDO"
        oGet := TGet():New(004,005,{|u|If(PCount()==0,cPedido  ,cPedido  := u)},oDlg,040,010,"@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"cPedido",,,, lHasButton , lNoButton,, cLabelText, nLabelPos)
        cLabelText := "TYPE"
        oGet := TGet():New(004,055,{|u|If(PCount()==0,cType    ,cType    := u)},oDlg,040,010,"@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"cType"  ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos)
        cLabelText := "DATE"
        oGet := TGet():New(004,105,{|u|If(PCount()==0,cDate    ,cDate    := u)},oDlg,040,010,"@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"cDate"  ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos)
        cLabelText := "CÓD. MENSAGEM"
        oGet := TGet():New(004,155,{|u|If(PCount()==0,cCodMsg  ,cCodMsg  := u)},oDlg,040,010,"@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"cCodMsg",,,, lHasButton , lNoButton,, cLabelText, nLabelPos)

        //EnchoiceBar(oDlg, {|| .t. }, {|| oDlg:End() },,aBotoes)
        @ 10,205 BUTTON "&Sair"     SIZE 35,13 PIXEL ACTION oDlg:End()

        cLabelText := "Ação efetuada no Evento"
        oReturn := tMultiget():new( 30, 05, {| u | if( pCount() > 0, cReturn := u, cReturn ) }, oDlg, 260, 160, , , , , , .t., , , , , , .t., , , , , , cLabelText, nLabelPos )

       ACTIVATE MSDIALOG oDlg
Return nil
