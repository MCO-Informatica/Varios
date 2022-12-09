#include "rwmake.ch"
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function FornRISO()

	Local oReport := nil
	//Local cPerg:= Padr("relISO",10)
	Local cPerg:= Padr("zPergIso",10)
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
	Local cTipoRel := ''

	if MV_PAR03 = 1
		cTipoRel := "- ISO OK"
	elseif MV_PAR03 = 2
		cTipoRel := "- Vencidos"
	else
		cTipoRel := ""
	endif
	

	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
	oReport := TReport():New(cNome,"Relatorio - Controle ISO Fornecedor " + cTipoRel ,cNome,{|oReport| ReportPrint(oReport)},"Descricao do meu relatorio")
	oReport:SetLandScape()
	oReport:SetTotalInLine(.T.)
	oReport:lBold:= .T.
	oReport:nFontBody:=5
	//oReport:cFontBody:="Arial"
	oReport:SetLeftMargin(2)
	oReport:SetLineHeight(40)
	oReport:lParamPage := .F.
	//Monstando a primeira se��o

	oSection1:= TRSection():New(oReport, 	"NCM",	 	{"SA2"}, 	, .F.	, 	.T.)
	TRCell():New(oSection1,"TMP_COD"        ,"TRBSA2",	"Codigo"  		        ,"@!"	,	15)
    TRCell():New(oSection1,"TMP_NREDUZ"     ,"TRBSA2",	"Nome"  		        ,"@!"	,	40)
    //TRCell():New(oSection1,"TMP_CGC"        ,"TRBSA2",	"CNPJ"  		        ,"@!"	,	25)
	TRCell():New(oSection1,"TMP_XDTISO"		,"TRBSA2",  "Data"  	+ Chr(13) + Chr(10) + "Cert.ISO"      ,""	    ,	16,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XCFABR"     ,"TRBSA2",	"Categoria" + Chr(13) + Chr(10) + "Fabric."       ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XCDISTRI"   ,"TRBSA2",	"Categoria" + Chr(13) + Chr(10) + "Distrib."	  ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XCREV"      ,"TRBSA2",	"Categoria" + Chr(13) + Chr(10) + "Revend."       ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XPMP"       ,"TRBSA2",	"Produto" 	+ Chr(13) + Chr(10) + "Mat.Prima"     ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XPIM"       ,"TRBSA2",	"Produto"	+ Chr(13) + Chr(10) + "Itens Mec."    ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XPIE"       ,"TRBSA2",	"Produto"	+ Chr(13) + Chr(10) + "Itens" + Chr(13) + Chr(10) + "Eletricos"  ,"@!"	,	10,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XPINSTR"    ,"TRBSA2",	"Produto" 	+ Chr(13) + Chr(10) + "Instrum."      ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XPSERV"     ,"TRBSA2",	"Produto" 	+ Chr(13) + Chr(10) + "Servicos"      ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XPHIDR"     ,"TRBSA2",	"Produto"   + Chr(13) + Chr(10) + "Hidraul."      ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XPMISCE"    ,"TRBSA2",	"Produto"   + Chr(13) + Chr(10) + "Miscelan."     ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XRGTISO"    ,"TRBSA2",	"Requisito" + Chr(13) + Chr(10) + "Gestao" + Chr(13) + Chr(10) + "ISO9001"  ,"@!"	,	10,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XREQTE"     ,"TRBSA2",	"Requisito" + Chr(13) + Chr(10) + "Req."   + Chr(13) + Chr(10) + "Tecnicos,","@!"	,	10,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XREQCO"     ,"TRBSA2",	"Requisito" + Chr(13) + Chr(10) + "Complem."	  ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XNRNCA"     ,"TRBSA2",	"RNC A" 	+ Chr(13) + Chr(10) + "Nenhuma"	      ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XNRNCB"     ,"TRBSA2",	"RMC B" 	+ Chr(13) + Chr(10) + "de 01 a 02"	  ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XNRNCC"     ,"TRBSA2",	"RNC C"     + Chr(13) + Chr(10) + "de 03 a 04"    ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XNRNCD"     ,"TRBSA2",	"RNC D"  	+ Chr(13) + Chr(10) + "acima de 05"   ,"@!"	,	12,,,,,"CENTER")
    TRCell():New(oSection1,"TMP_XSTATUS"    ,"TRBSA2",	"Status"               ,"@!"	,	08,,,,,"CENTER")

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
		cQuery += "	convert(varchar(30),A2_XDTISO,102) AS 'TMP_XDTISO', " 
		cQuery += "	iif(A2_XCFABR = '1','X','') AS 'TMP_XCFABR',  "
		cQuery += "	iif(A2_XCDISTR = '1','X','') AS 'TMP_XCDISTRI' , "
		cQuery += "	iif(A2_XCREV = '1','X','') AS 'TMP_XCREV' , "
		cQuery += "	iif(A2_XPMP = '1','X','') AS 'TMP_XPMP' , " 
		cQuery += "	iif(A2_XPIM = '1','X','') AS 'TMP_XPIM', "
		cQuery += "	iif(A2_XPIE = '1','X','') AS 'TMP_XPIE',  "
		cQuery += "	iif(A2_XPINSTR = '1','X','') AS 'TMP_XPINSTR', " 
		cQuery += "	iif(A2_XPSERV = '1','X','') AS 'TMP_XPSERV' , "
		cQuery += "	iif(A2_XPHIDR = '1','X','') AS 'TMP_XPHIDR',  "
		cQuery += "	iif(A2_XPMISCE = '1','X','') AS 'TMP_XPMISCE', "
		cQuery += "	iif(A2_XRGTISO = '1','X','') AS 'TMP_XRGTISO', "
		cQuery += "	iif(A2_XREQTE = '1','X','') AS 'TMP_XREQTE',  "
		cQuery += "	iif(A2_XREQCO = '1','X','') AS 'TMP_XREQCO', "
		cQuery += "	iif(A2_XNRNCA = '1','X','') AS 'TMP_XNRNCA', "
		cQuery += "	iif(A2_XNRNCB = '1','X','')  AS 'TMP_XNRNCB', "
		cQuery += "	iif(A2_XNRNCC = '1','X','')  AS 'TMP_XNRNCC', "
		cQuery += "	iif(A2_XNRNCD = '1','X','')  AS 'TMP_XNRNCD',  "
		cQuery += "	iif(A2_XSTATUS = '1','A','I') AS 'TMP_XSTATUS'  "
        cQuery += "FROM SA2010 WHERE D_E_L_E_T_ <> '*' AND " 
        cQuery += "	A2_COD >= '" + MV_PAR01 + "' AND A2_COD <= '" + MV_PAR02 + "' AND A2_XDTISO >= GETDATE() "
    elseif MV_PAR03 = 2 // ISO VENCIDOS
        cQuery := " SELECT	A2_COD AS 'TMP_COD', A2_NREDUZ AS 'TMP_NREDUZ', A2_CGC AS 'TMP_CGC', " 
		cQuery += "	convert(varchar(30),A2_XDTISO,102) AS 'TMP_XDTISO', " 
		cQuery += "	iif(A2_XCFABR = '1','X','') AS 'TMP_XCFABR',  "
		cQuery += "	iif(A2_XCDISTR = '1','X','') AS 'TMP_XCDISTRI' , "
		cQuery += "	iif(A2_XCREV = '1','X','') AS 'TMP_XCREV' , "
		cQuery += "	iif(A2_XPMP = '1','X','') AS 'TMP_XPMP' , " 
		cQuery += "	iif(A2_XPIM = '1','X','') AS 'TMP_XPIM', "
		cQuery += "	iif(A2_XPIE = '1','X','') AS 'TMP_XPIE',  "
		cQuery += "	iif(A2_XPINSTR = '1','X','') AS 'TMP_XPINSTR', " 
		cQuery += "	iif(A2_XPSERV = '1','X','') AS 'TMP_XPSERV' , "
		cQuery += "	iif(A2_XPHIDR = '1','X','') AS 'TMP_XPHIDR',  "
		cQuery += "	iif(A2_XPMISCE = '1','X','') AS 'TMP_XPMISCE', "
		cQuery += "	iif(A2_XRGTISO = '1','X','') AS 'TMP_XRGTISO', "
		cQuery += "	iif(A2_XREQTE = '1','X','') AS 'TMP_XREQTE',  "
		cQuery += "	iif(A2_XREQCO = '1','X','') AS 'TMP_XREQCO', "
		cQuery += "	iif(A2_XNRNCA = '1','X','') AS 'TMP_XNRNCA', "
		cQuery += "	iif(A2_XNRNCB = '1','X','')  AS 'TMP_XNRNCB', "
		cQuery += "	iif(A2_XNRNCC = '1','X','')  AS 'TMP_XNRNCC', "
		cQuery += "	iif(A2_XNRNCD = '1','X','')  AS 'TMP_XNRNCD',  "
		cQuery += "	iif(A2_XSTATUS = '1','A','I') AS 'TMP_XSTATUS'  "
        cQuery += "FROM SA2010 WHERE D_E_L_E_T_ <> '*' AND " 
        cQuery += "	A2_COD >= '" + MV_PAR01 + "' AND A2_COD <= '" + MV_PAR02 + "' AND A2_XDTISO < GETDATE() AND A2_XDTISO <> '' "
    elseif MV_PAR03 = 3
        cQuery := " SELECT	A2_COD AS 'TMP_COD', A2_NREDUZ AS 'TMP_NREDUZ', A2_CGC AS 'TMP_CGC', " 
		cQuery += "	convert(varchar(30),A2_XDTISO,102) AS 'TMP_XDTISO', " 
		cQuery += "	iif(A2_XCFABR = '1','X','') AS 'TMP_XCFABR',  "
		cQuery += "	iif(A2_XCDISTR = '1','X','') AS 'TMP_XCDISTRI' , "
		cQuery += "	iif(A2_XCREV = '1','X','') AS 'TMP_XCREV' , "
		cQuery += "	iif(A2_XPMP = '1','X','') AS 'TMP_XPMP' , " 
		cQuery += "	iif(A2_XPIM = '1','X','') AS 'TMP_XPIM', "
		cQuery += "	iif(A2_XPIE = '1','X','') AS 'TMP_XPIE',  "
		cQuery += "	iif(A2_XPINSTR = '1','X','') AS 'TMP_XPINSTR', " 
		cQuery += "	iif(A2_XPSERV = '1','X','') AS 'TMP_XPSERV' , "
		cQuery += "	iif(A2_XPHIDR = '1','X','') AS 'TMP_XPHIDR',  "
		cQuery += "	iif(A2_XPMISCE = '1','X','') AS 'TMP_XPMISCE', "
		cQuery += "	iif(A2_XRGTISO = '1','X','') AS 'TMP_XRGTISO', "
		cQuery += "	iif(A2_XREQTE = '1','X','') AS 'TMP_XREQTE',  "
		cQuery += "	iif(A2_XREQCO = '1','X','') AS 'TMP_XREQCO', "
		cQuery += "	iif(A2_XNRNCA = '1','X','') AS 'TMP_XNRNCA', "
		cQuery += "	iif(A2_XNRNCB = '1','X','')  AS 'TMP_XNRNCB', "
		cQuery += "	iif(A2_XNRNCC = '1','X','')  AS 'TMP_XNRNCC', "
		cQuery += "	iif(A2_XNRNCD = '1','X','')  AS 'TMP_XNRNCD',  "
		cQuery += "	iif(A2_XSTATUS = '1','A','I') AS 'TMP_XSTATUS'  "
        cQuery += "FROM SA2010 WHERE D_E_L_E_T_ <> '*' AND " 
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
            //oSection1:Cell("TMP_CGC"):SetValue(TRBSA2->TMP_CGC)

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

	cAlias	:= Alias()
	_nPerg 	:= 1

	dbSelectArea("SX1")
	dbSetOrder(1)
	If dbSeek(cPerg)
		DO WHILE ALLTRIM(SX1->X1_GRUPO) == ALLTRIM(cPerg)
			_nPerg := _nPerg + 1
			DBSKIP()
		ENDDO
	ENDIF
	aRegistro:= {}
    

	//          Grupo/Ordem/Pergunt              		/SPA/ENG/Variavl/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSPA1/DefENG1/Cnt01/Var02/Def02/DefSPA2/DefENG2/Cnt02/Var03/Def03/DefSPA3/DefENG3/Cnt03/Var04/Def04/DefSPA4/DefENG4/Cnt04/Var05/Def05/DefSPA5/DefENG5/Cnt05/F3/Pyme/GRPSXG/HELP/PICTURE
	aAdd(aRegistro,{cPerg,"01","Fornecedor de ?	","","","mv_ch1","C",10,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","",""})
	aAdd(aRegistro,{cPerg,"02","Fornecedor ate ?","","","mv_ch2","C",10,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","",""})
	aAdd(aRegistro,{cPerg,"03","Controle ISO ?	","","","mv_ch3","N",01,00,2,"N","","mv_par11","ISO Ok","","","","","Vencidos","","","","","Todos","","","","","","","","","","","","","","   ","","","",""})
	
	IF Len(aRegistro) >= _nPerg
		For i:= _nPerg  to Len(aRegistro)
			Reclock("SX1",.t.)
			For j:=1 to FCount()
				If J<= LEN (aRegistro[i])
					FieldPut(j,aRegistro[i,j])
				Endif
			Next
			MsUnlock()
		Next
	EndIf
	dbSelectArea(cAlias)

return
