#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relcdiv()
	Local oReport := nil
	Local cPerg:= Padr("relcdiv",10)
	
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
	oReport := TReport():New(cNome,"Custos Diversos - Contrato",cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
	oReport:SetLandScape()    
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
	oSection1:= TRSection():New(oReport, 	"NCM",	 	{"SE2"}, 			, .F.	, 	.T.)
	TRCell():New(oSection1,"TMP_CONTRATO",	"TRBFIN",	"Contrato"  		,"@!"	,	13)
	
	
	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas
	oSection2:= TRSection():New(oReport, "Custos Diversos - Contrato", {"SE2"}, NIL, .F., .T.)
	TRCell():New(oSection2,"TMP_NUM"		,"TRBFIN","Título"			,"@!"				,15)
	TRCell():New(oSection2,"TMP_TIPO"		,"TRBFIN","Tipo"			,"@!"				,6)
	TRCell():New(oSection2,"TMP_NATUREZA"	,"TRBFIN","Natureza"		,"@!"				,15)
	TRCell():New(oSection2,"TMP_VENCREA"	,"TRBFIN","Venc.Real"		,"@!"				,19)
	TRCell():New(oSection2,"TMP_BAIXA"		,"TRBFIN","Baixa"			,"@!"				,19)
	TRCell():New(oSection2,"TMP_VLCRUZ"		,"TRBFIN","Valor Real"		,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_SALDO"		,"TRBFIN","Saldo"			,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_FORNECE"	,"TRBFIN","Cod.Forn."		,"@!"				,15)
	TRCell():New(oSection2,"TMP_NOMFOR"		,"TRBFIN","Fornecedor"		,"@!"				,40)
	
	
			
	oBreak1 := TRBreak():New(oSection2,{|| (TRBFIN->TMP_CONTRATO) },"Subtotal:",.F.)
	TRFunction():New(oSection2:Cell("TMP_VLCRUZ")	,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_SALDO")	,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)
	
	
	
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
	// ------ CONTAS A RECEBER FULL
	
	
	
	cQuery := " SELECT E2_XXIC AS 'TMP_CONTRATO', E2_NUM AS 'TMP_NUM', E2_TIPO AS 'TMP_TIPO', E2_NATUREZ AS 'TMP_NATUREZA', "
	cQuery += "	CAST(E2_VENCREA AS DATE) AS 'TMP_VENCREA', CAST(E2_BAIXA AS DATE) AS 'TMP_BAIXA', E2_VLCRUZ AS 'TMP_VLCRUZ', E2_SALDO AS 'TMP_SALDO', "
	cQuery += "	E2_FORNECE AS 'TMP_FORNECE', E2_NOMFOR AS 'TMP_NOMFOR' "
	cQuery += " FROM SE2010 WHERE D_E_L_E_T_ <> '*' AND E2_TIPO NOT IN ('PR','PA','NF','TX','ISS','INV') AND "
	cQuery += " E2_XXIC		  >= '" + MV_PAR01 + "' AND  "
 	cQuery += " E2_XXIC    	  <= '" + MV_PAR02 + "' ORDER BY E2_VENCREA, E2_NOMFOR,  E2_VLCRUZ "
	
 

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
					
		cNcm 	:= TRBFIN->TMP_CONTRATO
		IncProc("Imprimindo Custos diversos - Contrato"+alltrim(TRBFIN->TMP_CONTRATO))
		
		//imprimo a primeira seção				
		oSection1:Cell("TMP_CONTRATO"):SetValue(TRBFIN->TMP_CONTRATO)
					
		oSection1:Printline()
		
		//inicializo a segunda seção
		oSection2:init()
		
		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While TRBFIN->TMP_CONTRATO == cNcm
			oReport:IncMeter()		
		
			IncProc("Imprimindo Custo diversos - Contrato "+alltrim(TRBFIN->TMP_CONTRATO))
			
			oSection2:Cell("TMP_NUM"):SetValue(TRBFIN->TMP_NUM)	
			oSection2:Cell("TMP_TIPO"):SetValue(TRBFIN->TMP_TIPO)
			oSection2:Cell("TMP_NATUREZA"):SetValue(TRBFIN->TMP_NATUREZA)	
			oSection2:Cell("TMP_VENCREA"):SetValue(TRBFIN->TMP_VENCREA)	
			oSection2:Cell("TMP_BAIXA"):SetValue(TRBFIN->TMP_BAIXA)		
			
			oSection2:Cell("TMP_VLCRUZ"):SetValue(TRBFIN->TMP_VLCRUZ)
			oSection2:Cell("TMP_VLCRUZ"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_SALDO"):SetValue(TRBFIN->TMP_SALDO)
			oSection2:Cell("TMP_SALDO"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_FORNECE"):SetValue(TRBFIN->TMP_FORNECE)	
			oSection2:Cell("TMP_NOMFOR"):SetValue(TRBFIN->TMP_NOMFOR)
			
	
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
	putSx1(cPerg, "01", "Item Conta de ?"	  , "", "", "mv_ch1", "C", 13, 0, 0, "G", "", "CTD", "", "", "mv_par01")
	putSx1(cPerg, "02", "Item Conta até?"	  , "", "", "mv_ch2", "C", 13, 0, 0, "G", "", "CTD", "", "", "mv_par02")
	
return











