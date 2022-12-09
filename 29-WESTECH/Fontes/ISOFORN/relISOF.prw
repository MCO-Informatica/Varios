#include "rwmake.ch"
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relISOF()

	Local oReport := nil
	//Local cPerg:= Padr("relISO",10)
	Local cPerg:= Padr("relGC06",10)
	//Local oReport := nil
	//Local cPerg:= "relISO"
	//Incluo/Altero as perguntas na tabela SX1
	AjustaSX1(cPerg)
	//gero a pergunta de modo oculto, ficando dispon�vel no bot�o a��es relacionadas
	Pergunte(cPerg,.T.)

	oReport := RptDef(cPerg)
	oReport:PrintDialog()
Return

Static Function RptDef(cNome)
	Local oReport := Nil
	Local oSection1:= Nil

	Local oBreak
	Local oFunction

	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
	oReport := TReport():New(cNome,"Relatorio - Controle ISO Fornecedor " ,cNome,{|oReport| ReportPrint(oReport)},"Descricao do meu relatorio")
	oReport:SetLandScape()
	oReport:SetTotalInLine(.T.)
	oReport:lBold:= .T.
	oReport:nFontBody:=6
	//oReport:cFontBody:="Arial"
	oReport:SetLeftMargin(2)
	oReport:SetLineHeight(40)
	oReport:lParamPage := .F.
	//Monstando a primeira se��o

	oSection1:= TRSection():New(oReport, 	"NCM",	 	{"SA2"}, 	, .F.	, 	.T.)
	TRCell():New(oSection1,"TMP_COD"        ,"TRBSA2",	"Codigo"  		        ,"@!"	,	15)
    TRCell():New(oSection1,"TMP_NREDUZ"     ,"TRBSA2",	"Nome"  		        ,"@!"	,	40)
    TRCell():New(oSection1,"TMP_CGC"        ,"TRBSA2",	"CNPJ"  		        ,"@!"	,	25)
	TRCell():New(oSection1,"TMP_XDTISO"		,"TRBSA2",  "Data Cert.ISO"	        ,""	    ,	16,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XCFABR"     ,"TRBSA2",	"Cat.-Fabricante"       ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XCDISTRI"   ,"TRBSA2",	"Cat.-Distribuidor"     ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XCREV"      ,"TRBSA2",	"Cat.-Revendedor"       ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XPMP"       ,"TRBSA2",	"Pr.-Materia Prima"     ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XPIM"       ,"TRBSA2",	"Pr.-Itens Mecanicos"   ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XPIE"       ,"TRBSA2",	"Pr.-Itnes Eletricos"   ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XPINSTR"    ,"TRBSA2",	"Pr.-Instrumentos"      ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XPSERV"     ,"TRBSA2",	"Pr.-Servicos"          ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XPHIDR"     ,"TRBSA2",	"Pr.-Hidraulicos"       ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XPMISCE"    ,"TRBSA2",	"Pr.-Miscelaneous"      ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XRGTISO"    ,"TRBSA2",	"Rq.-Gestao ISO9001"    ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XREQTE"     ,"TRBSA2",	"Rq.-Requisitos Tecnicos","@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XREQCO"     ,"TRBSA2",	"Rq.-Complementares"    ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XNRNCA"     ,"TRBSA2",	"RNC- A - Nenhuma"      ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XNRNCB"     ,"TRBSA2",	"RMC- B - de 01 a 02"   ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XNRNCC"     ,"TRBSA2",	"RNC- C - de 03 a 04"   ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XNRNCD"     ,"TRBSA2",	"RNC- acima de 05"      ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XSTATUS"    ,"TRBSA2",	"Status"               ,"@!"	,	12,,,,,"CENTER")

	//TRFunction():New(oSection1:Cell("TMP_VUNITSI")	,NIL,"SUM",,,,,.F.,.T.)
	oReport:SetTotalInLine(.F.)

        //Aqui, farei uma quebra  por se��o
	oSection1:SetPageBreak(.F.)
	//oSection1:SetTotalText("Subtotal Contrato ")

Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)

	Local cQuery    := ""
	Local cNcm      := ""
	Local lPrim 	:= .T.

	//Monto minha consulta conforme parametros passado
	//Monto minha consulta conforme parametros passado
	// -- SELECT DE NF EMITIDAS REMOVENDO NFS CANCELADAS E DEVOLUCAO

    IF MV_PAR03 = 1 // ISO OK
        cQuery := " SELECT	A2_COD AS 'TMP_COD', A2_NREDUZ AS 'TMP_NREDUZ', A2_CGC AS 'TMP_CGC', "
        cQuery += "	convert(varchar(30),A2_XDTISO,102) AS 'TMP_XDTISO', A2_XCFABR AS 'TMP_XCFABR', A2_XCDISTR AS 'TMP_XCDISTRI' ,A2_XCREV AS 'TMP_XCREV' ,A2_XPMP AS 'TMP_XPMP' , "
        cQuery += "	A2_XPIM AS 'TMP_XPIM',A2_XPIE AS 'TMP_XPIE', A2_XPINSTR AS 'TMP_XPINSTR', A2_XPSERV AS 'TMP_XPSERV' ,A2_XPHIDR AS 'TMP_XPHIDR', "
        cQuery += "	A2_XPMISCE AS 'TMP_XPMISCE',A2_XRGTISO AS 'TMP_XRGTISO',A2_XREQTE AS 'TMP_XREQTE', "
        cQuery += "	A2_XREQCO AS 'TMP_XREQCO',A2_XNRNCA AS 'TMP_XNRNCA',A2_XNRNCB  AS 'TMP_XNRNCB',A2_XNRNCC  AS 'TMP_XNRNCC',A2_XNRNCD  AS 'TMP_XNRNCD', "
        cQuery += "	A2_XSTATUS AS 'TMP_XSTATUS' "
        cQuery += "FROM SA2010 WHERE D_E_L_E_T_ <> '*' " 
        cQuery += "	A2_COD >= '" + MV_PAR01 + "' AND A2_COD <= '" + MV_PAR02 + "' AND A2_XDTISO >= GETDATE() "
    elseif MV_PAR03 = 2 // ISO VENCIDOS
        cQuery := " SELECT	A2_COD AS 'TMP_COD', A2_NREDUZ AS 'TMP_NREDUZ', A2_CGC AS 'TMP_CGC', "
        cQuery += "	convert(varchar(30),A2_XDTISO,102) AS 'TMP_XDTISO', A2_XCFABR AS 'TMP_XCFABR', A2_XCDISTR AS 'TMP_XCDISTRI' ,A2_XCREV AS 'TMP_XCREV' ,A2_XPMP AS 'TMP_XPMP' , "
        cQuery += "	A2_XPIM AS 'TMP_XPIM',A2_XPIE AS 'TMP_XPIE', A2_XPINSTR AS 'TMP_XPINSTR', A2_XPSERV AS 'TMP_XPSERV' ,A2_XPHIDR AS 'TMP_XPHIDR', "
        cQuery += "	A2_XPMISCE AS 'TMP_XPMISCE',A2_XRGTISO AS 'TMP_XRGTISO',A2_XREQTE AS 'TMP_XREQTE', "
        cQuery += "	A2_XREQCO AS 'TMP_XREQCO',A2_XNRNCA AS 'TMP_XNRNCA',A2_XNRNCB  AS 'TMP_XNRNCB',A2_XNRNCC  AS 'TMP_XNRNCC',A2_XNRNCD  AS 'TMP_XNRNCD', "
        cQuery += "	A2_XSTATUS AS 'TMP_XSTATUS' "
        cQuery += "FROM SA2010 WHERE D_E_L_E_T_ <> '*' " 
        cQuery += "	A2_COD >= '" + MV_PAR01 + "' AND A2_COD <= '" + MV_PAR02 + "' AND A2_XDTISO < GETDATE() AND A2_XDTISO <> '' "
    elseif MV_PAR03 = 3
        cQuery := " SELECT	A2_COD AS 'TMP_COD', A2_NREDUZ AS 'TMP_NREDUZ', A2_CGC AS 'TMP_CGC', "
        cQuery += "	convert(varchar(30),A2_XDTISO,102) AS 'TMP_XDTISO', A2_XCFABR AS 'TMP_XCFABR', A2_XCDISTR AS 'TMP_XCDISTRI' ,A2_XCREV AS 'TMP_XCREV' ,A2_XPMP AS 'TMP_XPMP' , "
        cQuery += "	A2_XPIM AS 'TMP_XPIM',A2_XPIE AS 'TMP_XPIE', A2_XPINSTR AS 'TMP_XPINSTR', A2_XPSERV AS 'TMP_XPSERV' ,A2_XPHIDR AS 'TMP_XPHIDR', "
        cQuery += "	A2_XPMISCE AS 'TMP_XPMISCE',A2_XRGTISO AS 'TMP_XRGTISO',A2_XREQTE AS 'TMP_XREQTE', "
        cQuery += "	A2_XREQCO AS 'TMP_XREQCO',A2_XNRNCA AS 'TMP_XNRNCA',A2_XNRNCB  AS 'TMP_XNRNCB',A2_XNRNCC  AS 'TMP_XNRNCC',A2_XNRNCD  AS 'TMP_XNRNCD', "
        cQuery += "	A2_XSTATUS AS 'TMP_XSTATUS' "
        cQuery += "FROM SA2010 WHERE D_E_L_E_T_ <> '*' " 
        cQuery += "	A2_COD >= '" + MV_PAR01 + "' AND A2_COD <= '" + MV_PAR02 + "' AND  A2_XDTISO <> '' "
    ENDIF

	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRBSA2") <> 0
		DbSelectArea("TRBSA2")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "TRBSA2"

	dbSelectArea("TRBSA2")
	TRBSA2->(dbGoTop())

	oReport:SetMeter(TRBSA2->(LastRec()))

	oReport:SkipLine(3)
	oReport:FatLine()
	oReport:PrintText("Controle ISO Fornecedor")
	oReport:FatLine()

	//Irei percorrer todos os meus registros
	While !Eof()

		If oReport:Cancel()
			Exit
		EndIf

		//inicializo a primeira se��o
		oSection1:Init()

		oReport:IncMeter()

		cNcm 	:= TRBSA2->TMP_COD
		IncProc("Imprimindo Controle ISO Fornecedor  "+alltrim(TRBSA2->TMP_COD))

		//imprimo a primeira se��o

			oSection1:Cell("TMP_COD"):SetValue(TRBSA2->TMP_COD)
			oSection1:Cell("TMP_NREDUZ"):SetValue(TRBSA2->TMP_NREDUZ)
            oSection1:Cell("TMP_CGC"):SetValue(TRBSA2->TMP_CGC)

			IF TMP_XDTISO = ""
				oSection1:Cell("TMP_XDTISO"):SetValue("")
				oSection1:Cell("TMP_XDTISO"):SetAlign("CENTER")
			ELSE
				oSection1:Cell("TMP_XDTISO"):SetValue(Substr(TRBSA2->TMP_XDTISO,7,2) + "/" + Substr(TRBSA2->TMP_XDTISO,5,2) + "/" + Substr(TRBSA2->TMP_XDTISO,1,4))
				oSection1:Cell("TMP_XDTISO"):SetAlign("CENTER")
			ENDIF

			oSection1:Cell("TMP_XCFABR"):SetValue(TRBSA2->TMP_XCFABR)
			oSection1:Cell("TMP_XCFABR"):SetAlign("CENTER")

            oSection1:Cell("TMP_XCDISTRI"):SetValue(TRBSA2->TMP_XCDISTRI)
			oSection1:Cell("TMP_XCDISTRI"):SetAlign("CENTER")

            oSection1:Cell("TMP_XCREV"):SetValue(TRBSA2->TMP_XCREV)
			oSection1:Cell("TMP_XCREV"):SetAlign("CENTER")

            oSection1:Cell("TMP_XPMP"):SetValue(TRBSA2->TMP_XPMP)
			oSection1:Cell("TMP_XPMP"):SetAlign("CENTER")

            oSection1:Cell("TMP_XPIM"):SetValue(TRBSA2->TMP_XPIM)
			oSection1:Cell("TMP_XPIM"):SetAlign("CENTER")

            oSection1:Cell("TMP_XCFABR"):SetValue(TRBSA2->TMP_XCFABR)
			oSection1:Cell("TMP_XCFABR"):SetAlign("CENTER")

            oSection1:Cell("TMP_XPIE"):SetValue(TRBSA2->TMP_XPIE)
			oSection1:Cell("TMP_XPIE"):SetAlign("CENTER")

            oSection1:Cell("TMP_XPINSTR"):SetValue(TRBSA2->TMP_XPINSTR)
			oSection1:Cell("TMP_XPINSTR"):SetAlign("CENTER")

            oSection1:Cell("TMP_XPSERV"):SetValue(TRBSA2->TMP_XPSERV)
			oSection1:Cell("TMP_XPSERV"):SetAlign("CENTER")

            oSection1:Cell("TMP_XPHIDR"):SetValue(TRBSA2->TMP_XPHIDR)
			oSection1:Cell("TMP_XPHIDR"):SetAlign("CENTER")

            oSection1:Cell("TMP_XPMISCE"):SetValue(TRBSA2->TMP_XPMISCE)
			oSection1:Cell("TMP_XPMISCE"):SetAlign("CENTER")

            oSection1:Cell("TMP_XCFABR"):SetValue(TRBSA2->TMP_XCFABR)
			oSection1:Cell("TMP_XCFABR"):SetAlign("CENTER")

            oSection1:Cell("TMP_XRGTISO"):SetValue(TRBSA2->TMP_XRGTISO)
			oSection1:Cell("TMP_XRGTISO"):SetAlign("CENTER")

            oSection1:Cell("TMP_XREQTE"):SetValue(TRBSA2->TMP_XREQTE)
			oSection1:Cell("TMP_XREQTE"):SetAlign("CENTER")

            oSection1:Cell("TMP_XREQCO"):SetValue(TRBSA2->TMP_XREQCO)
			oSection1:Cell("TMP_XREQCO"):SetAlign("CENTER")

            oSection1:Cell("TMP_XNRNCA"):SetValue(TRBSA2->TMP_XNRNCA)
			oSection1:Cell("TMP_XNRNCA"):SetAlign("CENTER")

            oSection1:Cell("TMP_XNRNCB"):SetValue(TRBSA2->TMP_XNRNCB)
			oSection1:Cell("TMP_XNRNCB"):SetAlign("CENTER")

            oSection1:Cell("TMP_XNRNCC"):SetValue(TRBSA2->TMP_XNRNCC)
			oSection1:Cell("TMP_XNRNCC"):SetAlign("CENTER")

            oSection1:Cell("TMP_XNRNCD"):SetValue(TRBSA2->TMP_XNRNCD)
			oSection1:Cell("TMP_XNRNCD"):SetAlign("CENTER")

            oSection1:Cell("TMP_XSTATUS"):SetValue(TRBSA2->TMP_XSTATUS)
			oSection1:Cell("TMP_XSTATUS"):SetAlign("CENTER")
			
		oReport:ThinLine()
		oSection1:Printline()
		TRBSA2->(dbSkip())

	Enddo

	oSection1:Finish()

Return

static function ajustaSx1(cPerg)
    putSx1(cPerg, "01", "Fornecedor de ?"	  , "", "", "mv_ch1", "C", 10, 0, 0, "G", "", "SA2", "", "", "mv_par01")
    putSx1(cPerg, "02", "Fornecedor ate ?"	  , "", "", "mv_ch2", "C", 10, 0, 0, "G", "", "SA2", "", "", "mv_par01")
	PutSX1(cPerg, "02", "Controle ISO ?" 	  , "", "", "mv_ch3", "N", 01, 0, 0, "C", "", ""   , "", "", "mv_par03","ISO Ok","","","","Vencidos","","","","Todos","","","","","","","")

return
