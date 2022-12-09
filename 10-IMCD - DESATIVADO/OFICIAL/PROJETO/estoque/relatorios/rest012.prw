#include 'protheus.ch'


/*/{Protheus.doc} rest012
Relatorio de controle do lote em terceiros.
@type function
@version 1.0
@author marcio.katsumata
@since 21/08/2020
@return return_type, return_description
/*/
user function rest012()
    local oReport as object
    private cAliasRep  as character
    private cCodPrdIni as character
    private cCodPrdFim as character
    private cLoteIni   as character
    private cLoteFim   as character
    private nLoteEm    as numeric
    private cFornIni   as character
    private cLojaIni   as character
    private cFornFim   as character
    private cLojaFim   as character
    private lSaldZero  as logical

    cCodPrdIni:= ""
    cCodPrdFim:= replicate("Z", tamSx3("B1_COD")[1])
    cLoteIni  := ""
    cLoteFim  := replicate("Z", tamSx3("B8_LOTECTL")[1])
    nLoteEm   := 1
    cFornIni  := ""
    cLojaIni  := ""
    cFornFim  := replicate("Z", tamSx3("A2_COD")[1])
    cLojaFim  := replicate("Z", tamSx3("A2_LOJA")[1])
    lSaldZero :=  .F.

    parametros()

	oReport := ReportDef()
    cAliasRep := getNextAlias()
	If oReport == Nil
		return
	EndIf

	oReport:PrintDialog()  // Criando o relatorio.

    freeObj(oReport)
return

/*/{Protheus.doc} parametros
Tela de parâmetros do relatório
@type function
@version 1.0
@author marcio.katsumata
@since 04/06/2020
@return nil, nil
/*/
static function parametros()

    local aParamBox  as array
    local aRet       as array

    aParamBox := {}
    aRet      := {}

    //-------------------------------------------------------------------------
    //Definção dos parâmetros do parambox
    //------------------------------------------------------------------------
    aAdd(aParamBox,{9,"Informe os parâmetros do relatório:" ,150,7,.T.})
    aAdd(aParamBox,{1,"Cod.Prod. de",Space(TamSx3("B1_COD")[1]),"","","SB1","",100,.F.}) 
    aAdd(aParamBox,{1,"Cod.Prod. ate",Space(TamSx3("B1_COD")[1]),"","","SB1","",100,.F.}) 
    aAdd(aParamBox,{1,"Lote de",Space(TamSx3("B8_LOTECTL")[1]),"","","","",100,.F.}) 
    aAdd(aParamBox,{1,"Lote ate",Space(TamSx3("B8_LOTECTL")[1]),"","","","",100,.T.}) 
    aAdd(aParamBox,{2,"Lotes em",1,{"AMBOS","IMCD","TERCEIRO"},50,"",.F.})
    aAdd(aParamBox,{1,"Fornecedor de",Space(TamSx3("A2_COD")[1]),"","","SA2","",50,.F.}) 
    aAdd(aParamBox,{1,"Loja de",Space(TamSx3("A2_LOJA")[1]),"","","","",50,.F.}) 
    aAdd(aParamBox,{1,"Fornecedor até",Space(TamSx3("A2_COD")[1]),"","","SA2","",50,.T.}) 
    aAdd(aParamBox,{1,"Loja até",Space(TamSx3("A2_LOJA")[1]),"","","","",50,.T.}) 
    aAdd(aParamBox,{2,"Saldos Zerados",1,{"SIM","NAO"},50,"",.F.})



    If ParamBox(aParamBox,"Parâmetros",@aRet,,,,,,,"REST012"+__cUserID,.T., .T.)
        
        
        cCodPrdIni:= aRet[2]
        cCodPrdFim:= aRet[3]
        cLoteIni  := aRet[4]
        cLoteFim  := aRet[5]
        nLoteEm   := iif(ValType(aRet[6]) == "N", aRet[6], iif(aRet[6]=="AMBOS", 1, iif(aRet[6]=="IMCD", 2, 3)))
        cFornIni  := padr(aRet[7], tamSx3("D2_CLIENTE")[1], " ")
        cLojaIni  := padr(aRet[8], tamSx3("D2_LOJA")[1], " ")
        cFornFim  := padr(aRet[9], tamSx3("D2_CLIENTE")[1], " ")
        cLojaFim  := padr(aRet[10], tamSx3("D2_LOJA")[1], " ")
        lSaldZero := iif(ValType(aRet[11]) == "N", aRet[11] == 1, aRet[11]=="SIM" )

    endif


    aSize(aParambox,0)
    aSize(aRet,0)



return 

/*/{Protheus.doc} ReportDef
description
@type function
@version 
@author marcio.katsumata
@since 24/08/2020
@return return_type, return_description
/*/
static function ReportDef()

	Local oReport as object
	Local oSection1 as object
	local cHelp as character
    local cDefaultFile as character

    cDefaultFile := "LoteTerceiro_"+dtos(date())+strtran(time(),":", "")

	cHelp := " Relatório controle de lote em terceiros"+CRLF
	cHelp += " Para selecionar os filtros desejados, va em 'Outras Ações' e logo em seguida 'Parâmetros'."+CRLF
	cHelp += " Do lado esquerdo, escolha o tipo de relatorio que deseja."


	oReport := TReport():New(cDefaultFile,'Relatório controle de lote em terceiros',{||parametros()},{|oReport| ReportPrint( oReport ),'Relatório controle de lote em terceiros'},cHelp)

	oSection1 := TRSection():New( oReport, 'Relatório controle de lote em terceiros')

	TRCell():New( oSection1, 'B8_PRODUTO'	   		   ,cAliasRep, 	'Cod. Produto'		          , PesqPict("SB8","B8_PRODUTO"),tamSx3("B8_PRODUTO")[1],.F.,{||(cAliasRep)->B8_PRODUTO},"LEFT")
	TRCell():New( oSection1, 'B1_DESC'      		   ,cAliasRep, 	'Desc. Produto'				  , PesqPict("SB1","B1_DESC")   ,tamSx3("B1_DESC")[1]   ,.F.,{||(cAliasRep)->B1_DESC},"LEFT")
	TRCell():New( oSection1, 'B8_LOTECTL'     		   ,cAliasRep, 	'Lote'		                  , PesqPict("SB8","B8_LOTECTL"),tamSx3("B8_LOTECTL")[1],.F.,{||(cAliasRep)->B8_LOTECTL},"LEFT")
	TRCell():New( oSection1, 'B8_DFABRIC'              ,cAliasRep, 	'Dt. Fabricação'		      , PesqPict("SB8","B8_DFABRIC"),tamSx3("B8_DFABRIC")[1],.F.,{||(cAliasRep)->B8_DFABRIC},"LEFT")
	TRCell():New( oSection1, 'B8_DTVALID'              ,cAliasRep,  'Dt. Validade'			      , PesqPict("SB8","B8_DTVALID"),tamSx3("B8_DTVALID")[1],.F.,{||(cAliasRep)->B8_DTVALID},"LEFT")
	TRCell():New( oSection1, 'SALDO'                   ,cAliasRep, 	'Saldo'		          	      , PesqPict("SB8","B8_SALDO")  ,tamSx3("B8_SALDO")[1]  ,.F.,{||(cAliasRep)->SALDO}  ,"LEFT")
	TRCell():New( oSection1, 'LOCAL'                   ,cAliasRep, 	'Local'                       , PesqPict("SA2","A2_NOME")   ,tamSx3("A2_NOME")[1]   ,.F.,{||(cAliasRep)->LOCAL},"LEFT")
	TRCell():New( oSection1, 'NOTA_FISCAL' 	   		   ,cAliasRep, 	'Nota Fiscal(Serie+Nota+Item)', PesqPict("SD2","D2_DOC")   ,tamSx3("D2_DOC")[1]+tamSx3("D2_SERIE")[1] +tamSx3("D2_ITEM")[1]    ,.F.,{||(cAliasRep)->NOTA_FISCAL},"LEFT")

return oReport


/*/{Protheus.doc} ReportPrint
description
@type function
@version 
@author marcio.katsumata
@since 24/08/2020
@param oReport, object, param_description
@return return_type, return_description
/*/
static function ReportPrint( oReport )

    local cQuery    as character
	Local oSection1 as object


    cQuery := " SELECT B8_PRODUTO, B1_DESC, B8_LOTECTL, B8_DFABRIC, B8_DTVALID, SALDO, LOCAL, NOTA_FISCAL "
    cQuery += " FROM ( "

    if nLoteEm == 1 .or. nLoteEm == 2
        cQuery +=    " SELECT B8_PRODUTO, B1_DESC, B8_LOTECTL, B8_DFABRIC, B8_DTVALID, SUM(SALDO) AS SALDO, LOCAL, NOTA_FISCAL FROM ("
        cQuery +=    " SELECT B8_PRODUTO, B1_DESC, B8_LOTECTL, B8_DFABRIC, B8_DTVALID, B8_SALDO AS SALDO, 'IMCD' AS LOCAL, '' AS NOTA_FISCAL "
        cQuery +=    " FROM "+retSqlName("SB8")+" SB8 "
        cQuery +=    " INNER JOIN "+retSqlName("SB1")+" SB1 ON (SB1.B1_COD = SB8.B8_PRODUTO AND SB1.D_E_L_E_T_ = ' ')
        cQuery +=    " WHERE SB8.B8_PRODUTO BETWEEN '"+cCodPrdIni+"' AND '"+cCodPrdFim+"' AND "
        cQuery +=    "       SB8.B8_LOTECTL BETWEEN '"+cLoteIni+"'   AND '"+cLoteFim+"'   AND "
        cQuery +=    "       SB8.D_E_L_E_T_ = ' ' "
        if !lSaldZero
            cQuery +=    "       AND SB8.B8_SALDO >  0 "
        endif
        cQuery +=    ") TABSB8 GROUP BY B8_PRODUTO, B1_DESC, B8_LOTECTL, B8_DFABRIC, B8_DTVALID, LOCAL, NOTA_FISCAL "

        if nLoteEm == 1
            cQuery += " UNION ALL "
        endif

    endif

    if nLoteEm == 1 .or. nLoteEm == 3 

        cQuery +=" SELECT B8_PRODUTO, B1_DESC, B8_LOTECTL, B8_DFABRIC, B8_DTVALID, SUM(B6_SALDO) AS SALDO, A2_NOME AS LOCAL, D2_SERIE||' '||D2_DOC||' '||D2_ITEM AS NOTA_FISCAL "
        cQuery +=" FROM "+retSqlName("SB6")+" SB6 "
        cQuery +=" INNER JOIN "+retSqlName("SB1")+" SB1 ON (SB1.B1_COD = SB6.B6_PRODUTO AND SB1.D_E_L_E_T_ = ' ')
        cQuery +=" INNER JOIN "+retSqlName("SA2")+" SA2 ON (SA2.A2_COD = SB6.B6_CLIFOR AND "
        cQuery +="                                          SA2.A2_LOJA = SB6.B6_LOJA  AND "
        cQuery +="                                          SA2.D_E_L_E_T_ = ' ' )          "
        cQuery +=" INNER JOIN "+retSqlName("SD2")+" SD2 ON (SD2.D2_FILIAL  = SB6.B6_FILIAL AND "
        cQuery +="                                          SD2.D2_DOC     = SB6.B6_DOC    AND "
        cQuery +="                                          SD2.D2_SERIE   = SB6.B6_SERIE  AND "
        cQuery +="                                          SD2.D2_CLIENTE = SB6.B6_CLIFOR AND "
        cQuery +="                                          SD2.D2_LOJA    = SB6.B6_LOJA   AND "
        cQuery +="                                          SD2.D2_IDENTB6 = SB6.B6_IDENT  AND "
        cQuery +="                                          SD2.D_E_L_E_T_ = ' ') "
        cQuery +=" INNER JOIN "+retSqlName("SB8")+" SB8 ON (SB8.B8_FILIAL  = SD2.D2_FILIAL  AND "
        cQuery +="                                          SB8.B8_PRODUTO = SD2.D2_COD     AND "
        cQuery +="                                          SB8.B8_LOCAL   = SD2.D2_LOCAL   AND "
        cQuery +="                                          SB8.B8_LOTECTL = SD2.D2_LOTECTL AND "
        cQuery +="                                          SB8.D_E_L_E_T_ = ' ') "
        cQuery +=" WHERE SB6.B6_PRODUTO BETWEEN '"+cCodPrdIni+"' AND '"+cCodPrdFim+"' AND "
        cQuery +="       SD2.D2_LOTECTL BETWEEN '"+cLoteIni+"'   AND '"+cLoteFim+"'   AND "
        cQuery +="       SD2.D2_CLIENTE||SD2.D2_LOJA BETWEEN '"+cFornIni+cLojaIni+"'   AND '"+cFornFim+cLojaFim+"'   AND "
        cQuery +="       SB6.B6_TIPO = 'E' AND "
        cQuery +="       SB6.D_E_L_E_T_ = ' '  "
        if !lSaldZero
            cQuery +=    "       AND SB6.B6_SALDO >  0 "
        endif
        cQuery +=" GROUP BY B8_PRODUTO, B1_DESC, B8_LOTECTL, B8_DFABRIC, B8_DTVALID, A2_NOME, D2_SERIE||' '||D2_DOC||' '||D2_ITEM )"

    endif        


    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasRep,.T.,.T.)

    
	TcSetField(cAliasRep,'B8_DFABRIC','D',8,0)
	TcSetField(cAliasRep,'B8_DTVALID','D',8,0)

    oSection1 := oReport:Section(1)
	oSection1:Init()    
	oSection1:SetHeaderSection(.T.)

    oReport:setMeter(contar(cAliasRep, "!eof()"))

    (cAliasRep)->(dbGoTop())

	While (cAliasRep)->(!EOF()) 

		IF oReport:Cancel()
			Exit
		EndIf
		oReport:IncMeter()

		oSection1:PrintLine()

		(cAliasRep)->(dbSkip()) 
	enddo
	(cAliasRep)->(dbCloseArea())  

return
