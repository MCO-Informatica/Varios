#include 'protheus.ch'


/*/{Protheus.doc} CtrlCrdR
Relatório de controle de crédito de clientes
@type function
@version 1.0
@author marcio.katsumata
@since 04/06/2020
@return nil, nil
/*/
user function CtrlCrdR()
    local oReport as object
    private cAliasRep as character
    private dDtVldIni  as date
    private dDtVldFim  as date
    private cCodCliIni as character
    private cLojCliIni as character
    private cCodCliFim as character
    private cLojCliFim as character
    private cBuIni     as character
    private cBuFim     as character
    private cFilIni    as character
    private cFilFim    as character

    parCtrlCrd()

	oReport := ReportDef()
    cAliasRep := getNextAlias()
	If oReport == Nil
		return
	EndIf

	oReport:PrintDialog()  // Criando o relatorio.

return

/*/{Protheus.doc} parCtrlCrd
Tela de parâmetros do relatório
@type function
@version 1.0
@author marcio.katsumata
@since 04/06/2020
@return nil, nil
/*/
static function parCtrlCrd()

    local aParamBox  as array
    local aRet       as array

    aParamBox := {}
    aRet      := {}

    //-------------------------------------------------------------------------
    //Definção dos parâmetros do parambox
    //------------------------------------------------------------------------
    aAdd(aParamBox,{9,"Informe os parâmetros do relatório:" ,150,7,.T.})
    aAdd(aParamBox,{1,"Cliente de",Space(TamSx3("A1_COD")[1]),"","","SA1","",50,.F.}) 
    aAdd(aParamBox,{1,"Loja de",Space(TamSx3("A1_LOJA")[1]),"","","","",50,.F.}) 
    aAdd(aParamBox,{1,"Cliente até",Space(TamSx3("A1_COD")[1]),"","","SA1","",50,.T.}) 
    aAdd(aParamBox,{1,"Loja até",Space(TamSx3("A1_LOJA")[1]),"","","","",50,.T.}) 
    aAdd(aParamBox,{1,"BU de",Space(TamSx3("ACY_GRPVEN")[1]),"","","ACY","",50,.F.}) 
    aAdd(aParamBox,{1,"BU até",Space(TamSx3("ACY_GRPVEN")[1]),"","","ACY","",50,.F.}) 
    aAdd(aParamBox,{1,"Validade LC de",stod(""),"","","","",50,.F.}) 
    aAdd(aParamBox,{1,"Validade LC até",stod(""),"","","","",50,.F.}) 
    aAdd(aParamBox,{1,"Filial de" ,space(FwSizeFilial(cEmpAnt)),"","","SM0","",50,.F.}) 
    aAdd(aParamBox,{1,"Filial até",space(FwSizeFilial(cEmpAnt)),"","","SM0","",50,.T.}) 

    If ParamBox(aParamBox,"Parâmetros",@aRet,,,,,,,,.T., .T.)
        
        
        cCodCliIni:= aRet[2]
        cLojCliIni:= aRet[3]
        cCodCliFim:= aRet[4]
        cLojCliFim:= aRet[5]
        cBuIni    := aRet[6]
        cBuFim    := aRet[7]
        dDtVldIni := aRet[8]
        dDtVldFim := aRet[9]
        cFilIni   := aRet[10]
        cFilFim   := aRet[11]
    endif


    aSize(aParambox,0)
    aSize(aRet,0)



return 

/*/{Protheus.doc} ReportDef
Definição do layout do relatório 
@type function
@version 1.0
@author marcio.katsumata
@since 04/06/2020
@return object, TReport
/*/
static function ReportDef()

	Local oReport as object
	Local oSection1 as object
	local cHelp as character
    local cDefaulFile as character

    cDefaultFile := "CreditControlReport_"+dtos(date())+time()

	cHelp := " Relatorio de controle de crédito cliente"+CRLF
	cHelp += " Para selecionar os filtros desejados, va em 'Outras Ações' e logo em seguida 'Parâmetros'."+CRLF
	cHelp += " Do lado esquerdo, escolha o tipo de relatorio que deseja."


	oReport := TReport():New(cDefaultFile,'Relatorio de controle credito',{||parCtrlCrd()},{|oReport| ReportPrint( oReport ),'Relatório de Controle crédito cliente'},cHelp)

	oSection1 := TRSection():New( oReport, 'Relatório controle de crédito')

	TRCell():New( oSection1, 'A1_COD'	   			   ,cAliasRep, 	'Code'		     		      , PesqPict("SA1","A1_COD")    ,tamSx3("A1_COD")[1]+5    ,.F.,{||(cAliasRep)->A1_COD+"-"+(cAliasRep)->A1_LOJA},"LEFT")
	TRCell():New( oSection1, 'A1_NOME'      		   ,cAliasRep, 	'Customer'				      , PesqPict("SA1","A1_NOME")   ,tamSx3("A1_NOME")[1]   ,.F.,{||(cAliasRep)->A1_NOME},"LEFT")
	TRCell():New( oSection1, 'A1_CGC'     			   ,cAliasRep, 	'CNPJ(Tax ID)'		          , PesqPict("SA1","A1_CGC")    ,tamSx3("A1_CGC")[1]+9    ,.F.,{||(cAliasRep)->A1_CGC},"LEFT")
	TRCell():New( oSection1, 'ACY_DESCRI'              ,cAliasRep, 	'Business Unit'		          , PesqPict("ACY","ACY_DESCRI"),tamSx3("ACY_DESCRI")[1],.F.,{||(cAliasRep)->ACY_DESCRI},"LEFT")
	TRCell():New( oSection1, 'A1_LC'                   ,cAliasRep, 	'Credit Limit'			      , PesqPict("SA1","A1_LC")     ,tamSx3("A1_LC")[1]     ,.F.,{||(cAliasRep)->A1_LC},"RIGHT")
	TRCell():New( oSection1, 'A1_MOEDALC'              ,cAliasRep, 	'Curr'		          	      , "@!"                        ,3                      ,.F.,{||superGetMv("MV_SIMB"+STRZERO((cAliasRep)->A1_MOEDALC,1), .F.,"")},"LEFT")
	TRCell():New( oSection1, 'A1_VENCLC' 	   		   ,cAliasRep, 	'Expiry Date' 				  , PesqPict("SA1","A1_VENCLC") ,tamSx3("A1_VENCLC")[1]+9 ,.F.,{||(cAliasRep)->A1_VENCLC},"LEFT")
	TRCell():New( oSection1, 'E1_SALDO'      		   ,cAliasRep, 	'Actual (Accounts Receivable)', PesqPict("SE1","E1_SALDO")  ,tamSx3("E1_SALDO")[1]  ,.F.,{||(cAliasRep)->E1_SALDO},"RIGHT")
	TRCell():New( oSection1, 'USED'              	   ,cAliasRep, 	'Used %'		              , "@E 999.99"          		,6                      ,.F.,{||((cAliasRep)->E1_SALDO * 100)  / (cAliasRep)->A1_LC},"RIGHT")
	TRCell():New( oSection1, 'A1_MSALDO'   	           ,cAliasRep, 	'Max Exposure'		          , PesqPict("SA1","A1_MSALDO") ,tamSx3("A1_MSALDO")[1] ,.F.,{||(cAliasRep)->A1_MSALDO},"RIGHT")
	TRCell():New( oSection1, 'E4_DESCRI'	    	   ,cAliasRep, 	'Payment Terms' 			  , PesqPict("SE4","E4_DESCRI") ,tamSx3("E4_DESCRI")[1]-23 ,.F.,{||(cAliasRep)->E4_DESCRI},"LEFT")

return oReport

/*/{Protheus.doc} ReportPrint
Realiza a impressão do relatório.
@type function
@version 1.0
@author marcio.katsumata
@since 04/06/2020
@param oReport, object, objeto TReport
@return nil, nil
/*/
Static Function ReportPrint( oReport )

	Local oSection1 as object
    local cWhere    as character

    cWhere := ""

    if !empty(dDtVldFim)
        cWhere := " SA1.A1_VENCLC BETWEEN '"+dtos(dDtVldIni)+"' AND '"+dtos(dDtVldFim)+"' AND "
    else
        if !empty(dDtVldIni) 
            cWhere := " SA1.A1_VENCLC >= '"+dtos(dDtVldIni)+"' AND "
        endif
    endif

    if !empty(cBuFim)
        cWhere += " ACY.ACY_GRPVEN BETWEEN '"+dtos(cBuIni)+"' AND '"+dtos(cBuFim)+"' AND "
    else
        if !empty(dDtVldIni) 
            cWhere += " ACY.ACY_GRPVEN >= '"+dtos(cBuIni)+"' AND "
        endif
    endif

    cWhere += " SA1.D_E_L_E_T_ = ' '"
    cWhere := "% "+cWhere+" %"

    oSection1 := oReport:Section(1)
	oSection1:Init()    
	oSection1:SetHeaderSection(.T.)

    beginSql alias cAliasRep

        SELECT SA1.A1_COD,SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_CGC, ACY.ACY_DESCRI,
               SA1.A1_LC,  SA1.A1_MOEDALC, SA1.A1_VENCLC, SUM(SE1.E1_SALDO) AS E1_SALDO,
               SA1.A1_MSALDO, SE4.E4_DESCRI
        FROM %table:SA1% SA1
        LEFT JOIN %table:SE1% SE1 ON(SE1.E1_FILIAL BETWEEN %exp:cFilIni% AND %exp:cFilFim% AND
                                      SE1.E1_TIPO = 'NF'             AND
                                      SE1.E1_CLIENTE = SA1.A1_COD    AND
                                      SE1.E1_LOJA    = SA1.A1_LOJA   AND
                                      SE1.E1_SALDO > 0               AND
                                      SE1.%notDel%)
        LEFT JOIN %table:ACY% ACY ON(ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND
                                      ACY.%notDel%)
        LEFT JOIN %table:SE4% SE4 ON(SE4.E4_CODIGO = SA1.A1_COND    AND
                                      SE4.%notDel%)

        WHERE SA1.A1_COD || SA1.A1_LOJA BETWEEN %exp:cCodCliIni+cLojCliIni% AND %exp:cCodCliFim+cLojCliFim%  AND
              %exp:cWhere%

        GROUP BY SA1.A1_COD,SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_CGC, ACY.ACY_DESCRI,
                SA1.A1_LC,  SA1.A1_MOEDALC, SA1.A1_VENCLC,SA1.A1_MSALDO, SE4.E4_DESCRI

        ORDER BY SA1.A1_COD
    endSql


	TcSetField(cAliasRep,'A1_VENCLC','D',8,0)

    oReport:setMeter(contar(cAliasRep, "!eof()"))

    (cAliasRep)->(dbGoTop())

	While (cAliasRep)->(!EOF()) // Enquanta a tabela não não retornar EOF (End Of File)

		IF oReport:Cancel()
			Exit
		EndIf
		oReport:IncMeter()

		oSection1:PrintLine()

		(cAliasRep)->(dbSkip()) // pulando para o proximo registro na tabela
	enddo
	(cAliasRep)->(dbCloseArea())  // Fechando a tabela

return


    

