#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relat019()
	Local oReport := nil
	Local cPerg:= Padr("RELAT019",10)
	
	//Incluo/Altero as perguntas na tabela SX1
	AjustaSX1(cPerg)	
	//gero a pergunta de modo oculto, ficando disponível no botão ações relacionadas
	Pergunte(cPerg,.T.)	          
		
	oReport := RptDef(cPerg)
	oReport:PrintDialog()
Return

Static Function RptDef(cNome)
	Local oReport := Nil
	Local oSection1:= Nil
	Local oSection2:= Nil
	Local oBreak
	Local oFunction
	
	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
	oReport := TReport():New(cNome,"Tributos (Débitos - Documentos de Saída)",cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)
	oReport:lBold:= .T.
	oReport:nFontBody:=7
	//oReport:cFontBody:="Arial"
	oReport:SetLeftMargin(2)
	oReport:SetLineHeight(40)
	oReport:lParamPage := .F. 	
	
	
	//Monstando a primeira seção
	//Neste exemplo, a primeira seção será composta por duas colunas, código da NCM e sua descrição
	//Iremos disponibilizar para esta seção apenas a tabela SYD, pois quando você for em personalizar
	//e entrar na primeira seção, você terá todos os outros campos disponíveis, com isso, será
	//permitido a inserção dos outros campos
	//Neste exemplo, também, já deixarei definido o nome dos campos, mascara e tamanho, mas você
	//terá toda a liberdade de modificá-los via relatorio. 
	oSection1:= TRSection():New(oReport, 	"NCM",	 	{"SF2"}, 			, .F.	, 	.T.)
	TRCell():New(oSection1,"TMP_DTENT",	"TRBFIN",	"Ano/Mês Saída"  		,"@!"	,	16)
	
	
	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas
	oSection2:= TRSection():New(oReport, "Tributos (Créditos - Documentos de Saída)", {"SF2"}, NIL, .F., .T.)
	TRCell():New(oSection2,"TMP_DOC"		,"TRBFIN","NF"				,"@!"				,12)
	TRCell():New(oSection2,"TMP_DTENTRADA"	,"TRBFIN","Data Saída"		,"@!"				,12)
	TRCell():New(oSection2,"TMP_ICMS"		,"TRBFIN","ICMS"			,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_IPI"		,"TRBFIN","IPI"				,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_PIS"		,"TRBFIN","PIS"				,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_COFINS"		,"TRBFIN","COFINS"			,"@E 999,999,999.99",14,,,,,"RIGHT")

	oBreak1 := TRBreak():New(oSection2,{|| (TRBFIN->TMP_DTENT) },"Subtotal:",.F.)
	TRFunction():New(oSection2:Cell("TMP_DOC")		,NIL,"COUNT",oBreak1,,,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_ICMS")		,NIL,"SUM",oBreak1,,,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_IPI")		,NIL,"SUM",oBreak1,,,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_PIS")		,NIL,"SUM",oBreak1,,,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_COFINS")	,NIL,"SUM",oBreak1,,,,.F.,.T.)
	
	
	oReport:SetTotalInLine(.F.)
       
        //Aqui, farei uma quebra  por seção
	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalText(" ")				
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)	 
	Local cQuery    := ""		
	Local cNcm      := ""   
	Local lPrim 	:= .T.	
	oSection2:SetHeaderSection(.T.)
	      

	//Monto minha consulta conforme parametros passado
	// -- SELECT DE NF EMITIDAS REMOVENDO NFS CANCELADAS E DEVOLUCAO
	
	
	cQuery := "SELECT CONVERT(VARCHAR(4),YEAR(D2_EMISSAO))+'/'+CONVERT(VARCHAR(2),MONTH(D2_EMISSAO)) AS 'TMP_DTENT', CAST(D2_EMISSAO AS DATE) AS 'TMP_DTENTRADA', D2_DOC AS 'TMP_DOC',  "
    cQuery += "	   SUM(D2_VALIPI) AS 'TMP_IPI', "
	cQuery += "	   SUM(D2_VALICM) as 'TMP_ICMS', "
    cQuery += "	   SUM(D2_VALISS) AS 'TMP_ISS',  "
    cQuery += "	   SUM(D2_VALIMP6) AS 'TMP_PIS', "
	cQuery += "	   SUM(D2_VALIMP5) AS 'TMP_COFINS'   "
    cQuery += "	   FROM SD2010 "
	cQuery += "	WHERE D2_DOC NOT IN (SELECT F3_NFISCAL FROM SF3010 WHERE F3_DTCANC <> '') AND D2_DOC NOT IN (SELECT SUBSTRING(F3_OBSERV,16,6) AS NFDEV FROM SF3010 WHERE F3_TIPO = 'D') AND  "
	cQuery += "	D2_CF IN (SELECT D2_CF FROM SD2010 WHERE "
	cQuery += "										 D2_CF BETWEEN '6101' AND '6106' OR  "
	cQuery += "										 D2_CF BETWEEN '5101' AND '5125' OR "
	cQuery += "										 D2_CF BETWEEN '5551' AND '5551' OR  "
	cQuery += "										 D2_CF BETWEEN '5922' AND '5922' OR  "
	cQuery += "										 D2_CF BETWEEN '5933' AND '5933' OR "
	cQuery += "										 D2_CF BETWEEN '6109' AND '6120' OR "
	cQuery += "										 D2_CF BETWEEN '6122' AND '6125' OR  "
	cQuery += "										 D2_CF BETWEEN '7101' AND '7933' OR  "
	cQuery += "										 D2_CF BETWEEN '6551' AND '6551') AND "
	cQuery += " D2_EMISSAO    >= '" + DTOS(MV_PAR01) + "' AND  " 
	cQuery += " D2_EMISSAO    <= '" + DTOS(MV_PAR02) + "' AND  "
	cQuery += "	SD2010.D_E_L_E_T_ <> '*' GROUP BY D2_EMISSAO,D2_DOC ORDER BY D2_EMISSAO "
	
	
	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRBFIN") <> 0
		DbSelectArea("TRBFIN")
		DbCloseArea()
	ENDIF
	
	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "TRBFIN"	
	
	dbSelectArea("TRBFIN")
	TRBFIN->(dbGoTop())
	
	oReport:SetMeter(TRBFIN->(LastRec()))	

	//Irei percorrer todos os meus registros
	While !Eof()
		
		If oReport:Cancel()
			Exit
		EndIf
	
		//inicializo a primeira seção
		oSection1:Init()

		oReport:IncMeter()
					
		cNcm 	:= TRBFIN->TMP_DTENT
		IncProc("Tributos"+alltrim(TRBFIN->TMP_DTENT))
		
		//imprimo a primeira seção				
		oSection1:Cell("TMP_DTENT"):SetValue(TRBFIN->TMP_DTENT)
		

		oSection1:Printline()
		
		//inicializo a segunda seção
		oSection2:init()
		
		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While TRBFIN->TMP_DTENT == cNcm
			oReport:IncMeter()		
		
			IncProc("Imprimindo Tributos  "+alltrim(TRBFIN->TMP_DTENT))
			oSection2:Cell("TMP_DOC"):SetValue(TRBFIN->TMP_DOC)	
			oSection2:Cell("TMP_DTENTRADA"):SetValue(TRBFIN->TMP_DTENTRADA)	
			oSection2:Cell("TMP_IPI"):SetValue(TRBFIN->TMP_IPI)
			oSection2:Cell("TMP_COFINS"):SetAlign("RIGHT")
				
			oSection2:Cell("TMP_PIS"):SetValue(TRBFIN->TMP_PIS)
			oSection2:Cell("TMP_COFINS"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_PIS"):SetValue(TRBFIN->TMP_PIS)
			oSection2:Cell("TMP_PIS"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_COFINS"):SetValue(TRBFIN->TMP_COFINS)
			oSection2:Cell("TMP_COFINS"):SetAlign("RIGHT")
			
			oSection2:Printline()

 			TRBFIN->(dbSkip())
 		EndDo		
 		//finalizo a segunda seção para que seja reiniciada para o proximo registro
 		oSection2:Finish()
 		//imprimo uma linha para separar uma NCM de outra
 		oReport:ThinLine()
 		//finalizo a primeira seção
		oSection1:Finish()
	Enddo
Return

static function ajustaSx1(cPerg)
	//Aqui utilizo a função putSx1, ela cria a pergunta na tabela de perguntas
	putSx1(cPerg, "01", "Emissão de?"  	  	, "", "", "mv_ch3", "D", 08, 0, 0, "G", "", "", "", "", "mv_par01")
	putSx1(cPerg, "02", "Emissão até?"  	, "", "", "mv_ch4", "D", 08, 0, 0, "G", "", "", "", "", "mv_par02")

return
