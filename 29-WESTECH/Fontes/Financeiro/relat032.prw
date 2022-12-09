
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relat032()
	Local oReport := nil
	Local cPerg:= Padr("RELAT032",10)
	
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
	oReport := TReport():New(cNome,"Contas a Receber - Geral",cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
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
	oSection1:= TRSection():New(oReport, 	"NCM",	 	{"SE1"}, 			, .F.	, 	.T.)
	TRCell():New(oSection1,"TMP_VENCREAL"	,"TRBFIN","Vencto.Real"		,""					,19)
		
	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas
	oSection2:= TRSection():New(oReport, "Contas a Receber - Geral", {"SE1"}, NIL, .F., .T.)
	TRCell():New(oSection2,"TMP_TITULO"		,"TRBFIN","Título"			,"@!"				,09)
	TRCell():New(oSection2,"TMP_TIPO"		,"TRBFIN","Tipo"			,"@!"				,06)
	TRCell():New(oSection2,"TMP_NATUREZA"	,"TRBFIN","Natureza"		,"@!"				,10)
	TRCell():New(oSection2,"TMP_CODCLI"		,"TRBFIN","Código"			,"@!"				,10)
	TRCell():New(oSection2,"TMP_CLIENTE"	,"TRBFIN","Cliente"			,"@!"				,40)
	TRCell():New(oSection2,"TMP_VENCTO"		,"TRBFIN","Vencimento"		,""					,16)
	
	TRCell():New(oSection2,"TMP_VALOR"		,"TRBFIN","Valor"			,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_SALDO"		,"TRBFIN","Saldo"			,"@E 999,999,999.99",22,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_BAIXA"		,"TRBFIN","Baixa"			,""					,20)
	TRCell():New(oSection2,"TMP_CONTRATO"	,"TRBFIN","Contrato"  	,"@!"				,20)
	TRCell():New(oSection2,"TMP_HIST"		,"TRBFIN","Histórico"		,""					,100)

		
	oBreak1 := TRBreak():New(oSection2,{|| (TRBFIN->TMP_VENCREAL) },"Subtotal:",.F.)
	TRFunction():New(oSection2:Cell("TMP_VALOR")	,NIL,"SUM",oBreak1,"@E 999,999,999.99",,,.F.,.T.)
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
	
	cQuery := "SELECT	E1_XXIC as 'TMP_CONTRATO', E1_NUM as 'TMP_TITULO', E1_TIPO as 'TMP_TIPO', E1_NATUREZ as 'TMP_NATUREZA', E1_CLIENTE as 'TMP_CODCLI', "
	cQuery += "		E1_NOMCLI as 'TMP_CLIENTE',CAST(E1_EMISSAO as Date) as 'TMP_EMISSAO', CAST(E1_VENCTO as Date) as 'TMP_VENCTO', CAST(E1_VENCREA as Date) as 'TMP_VENCREAL', " 
	cQuery += "		IIF(E1_TIPO = 'RA' AND E1_BAIXA <> '', -E1_VALOR, E1_VALOR)  as 'TMP_VALOR', "
	cQuery += "		E1_SALDO AS 'TMP_SALDO', "
	cQuery += "		E1_HIST AS 'TMP_HIST', E1_BAIXA AS 'TMP_BAIXA' "
	cQuery += "	FROM SE1010 "
	cQuery += "	WHERE SE1010.D_E_L_E_T_ <> '*' AND "
	cQuery += " E1_XXIC		  >= '" + MV_PAR01 + "' AND  "
	cQuery += " E1_XXIC    	  <= '" + MV_PAR02 + "' AND  "
	cQuery += " E1_VENCREA    >= '" + DTOS(MV_PAR03) + "' AND  "
	cQuery += " E1_VENCREA    <= '" + DTOS(MV_PAR04) + "' AND  "
	cQuery += " E1_CLIENTE    >= '" + MV_PAR05 + "' AND  "
	cQuery += " E1_CLIENTE    <= '" + MV_PAR06 + "' "
	cQuery += "	ORDER BY E1_VENCREA, E1_EMISSAO,E1_XXIC "
	


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
					
		cNcm 	:= TRBFIN->TMP_VENCREAL
		IncProc("Imprimindo Contas a Receber"+alltrim(TRBFIN->TMP_VENCREAL))
		
		//imprimo a primeira seção
		oSection1:Cell("TMP_VENCREAL"):SetValue(TRBFIN->TMP_VENCREAL)				
		
					
		oSection1:Printline()
		
		//inicializo a segunda seção
		oSection2:init()
		
		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While TRBFIN->TMP_VENCREAL == cNcm
			oReport:IncMeter()		
		
			IncProc("Imprimindo Contas a Receber "+alltrim(TRBFIN->TMP_VENCREAL))
			oSection2:Cell("TMP_TIPO"):SetValue(TRBFIN->TMP_TIPO)	
			oSection2:Cell("TMP_NATUREZA"):SetValue(TRBFIN->TMP_NATUREZA)	
			oSection2:Cell("TMP_CODCLI"):SetValue(TRBFIN->TMP_CODCLI)
			oSection2:Cell("TMP_CLIENTE"):SetValue(TRBFIN->TMP_CLIENTE)
			oSection2:Cell("TMP_VENCTO"):SetValue(TRBFIN->TMP_VENCTO)
			
			
			oSection2:Cell("TMP_VALOR"):SetValue(TRBFIN->TMP_VALOR)
			oSection2:Cell("TMP_VALOR"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_SALDO"):SetValue(TRBFIN->TMP_SALDO)
			oSection2:Cell("TMP_SALDO"):SetAlign("RIGHT")
			
			IF TMP_BAIXA = ""
				oSection2:Cell("TMP_BAIXA"):SetValue("")
			ELSE
				oSection2:Cell("TMP_BAIXA"):SetValue(Substr(TRBFIN->TMP_BAIXA,7,2) + "/" + Substr(TRBFIN->TMP_BAIXA,5,2) + "/" + Substr(TRBFIN->TMP_BAIXA,1,4))
			ENDIF
			oSection2:Cell("TMP_CONTRATO"):SetValue(TRBFIN->TMP_CONTRATO)
			oSection2:Cell("TMP_HIST"):SetValue(TRBFIN->TMP_HIST)

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
	putSx1(cPerg, "03", "Venc. Real de?"  	  , "", "", "mv_ch3", "D", 08, 0, 0, "G", "", "", "", "", "mv_par03")
	putSx1(cPerg, "04", "Venc. Real até?"  	  , "", "", "mv_ch4", "D", 08, 0, 0, "G", "", "", "", "", "mv_par04")
	putSx1(cPerg, "05", "Cliente de ?"	  , "", "", "mv_ch5", "C", 10, 0, 0, "G", "", "SA1", "", "", "mv_par05")
	putSx1(cPerg, "06", "Cliente até?"	  , "", "", "mv_ch6", "C", 10, 0, 0, "G", "", "SA1", "", "", "mv_par06")

return

