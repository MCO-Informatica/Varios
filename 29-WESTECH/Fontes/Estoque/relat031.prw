#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relat031()
	Local oReport := nil
	Local cPerg:= Padr("RELAT031",10)
	
	/*
	//Incluo/Altero as perguntas na tabela SX1
	AjustaSX1(cPerg)	
	//gero a pergunta de modo oculto, ficando disponível no botão ações relacionadas
	Pergunte(cPerg,.T.)	
	 */         
		
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
	oReport := TReport():New(cNome,"Estoque" ,cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
	oReport:SetLandScape()    
	oReport:SetTotalInLine(.T.)
	oReport:lBold:= .T.
	oReport:nFontBody:=6
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
	oSection1:= TRSection():New(oReport, 	"NCM",	 	{"SD1"}, 	, .F.	, 	.T.)
	TRCell():New(oSection1,"TMP_COD"	,"TRBEST"	,"Código"		,"@!"	,	30)
	TRCell():New(oSection1,"TMP_DESC"	,"TRBEST"	,"Descrição"	,"@!",		80,,,,,,.T.)
	TRCell():New(oSection1,"TMP_DESCING","TRBEST"	,""				,"@!"	,	100,,,,,,.T.)
	//TRCell():New(oSection1,"TMP_ITEMCTA","TRBEST"	,"Item Conta"	,"@!"	,	20)
	TRCell():New(oSection1,"TMP_QUANT"	,"TRBEST"	,"Quantidade"	,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_CUSTO"	,"TRBEST"	,"Custo"		,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRFunction():New(oSection1:Cell("TMP_COD")	,NIL,"COUNT",,,,,.F.,.T.)
	
	oReport:SetTotalInLine(.F.)
       
        //Aqui, farei uma quebra  por seção
	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalText(" ")				
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)	 
	Local cQuery    := ""		
	Local cNcm      := ""   
	Local lPrim 	:= .T.	
	      

	//Monto minha consulta conforme parametros passado
	// -- SELECT DE NF EMITIDAS REMOVENDO NFS CANCELADAS E DEVOLUCAO
	
	cQuery := "SELECT D1_CUSTO AS 'TMP_CUSTO',D1_ITEMCTA AS 'TMP_ITEMCTA', D1_QUANT AS 'TMP_QUANT', "
	cQuery += " D1_COD AS 'TMP_COD', B1_DESC AS 'TMP_DESC', B1_XXDI AS 'TMP_DESCING' FROM SD1010 "
	cQuery += " INNER JOIN SB1010 ON SD1010.D1_COD = SB1010.B1_COD "
	cQuery += " WHERE D1_ITEMCTA = 'ESTOQUE' AND SD1010.D_E_L_E_T_ <> '*' AND D1_QUANT > 0 AND SB1010.D_E_L_E_T_ <> '*' "
	cQuery += " ORDER BY B1_DESC "
	
	
	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRBEST") <> 0
		DbSelectArea("TRBEST")
		DbCloseArea()
	ENDIF
	
	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "TRBEST"	
	
	dbSelectArea("TRBEST")
	TRBEST->(dbGoTop())
	
	oReport:SetMeter(TRBEST->(LastRec()))	

	//Irei percorrer todos os meus registros
	While !Eof()
		
		If oReport:Cancel()
			Exit
		EndIf
	
		//inicializo a primeira seção
		oSection1:Init()

		oReport:IncMeter()
					
		cNcm 	:= TRBEST->TMP_ITEMCTA
		IncProc("Imprimindo Estoque "+alltrim(TRBEST->TMP_ITEMCTA))
		
		//imprimo a primeira seção				
		oSection1:Cell("TMP_COD"):SetValue(TRBEST->TMP_COD)
		oSection1:Cell("TMP_DESC"):SetBlock( { ||TRBEST->TMP_DESC})
		oSection1:Cell("TMP_DESCING"):SetValue(TRBEST->TMP_DESCING)
		//oSection1:Cell("TMP_ITEMCTA"):SetValue(TRBEST->TMP_ITEMCTA)
		oSection1:Cell("TMP_QUANT"):SetValue(TRBEST->TMP_QUANT)
		oSection1:Cell("TMP_QUANT"):SetAlign("RIGHT") 
		oSection1:Cell("TMP_CUSTO"):SetValue(TRBEST->TMP_CUSTO)
		oSection1:Cell("TMP_CUSTO"):SetAlign("RIGHT") 
	
			
		oReport:ThinLine()
		oSection1:Printline()
		TRBEST->(dbSkip())
 		

	Enddo
	
	//imprimo uma linha para separar uma NCM de outra
 		
 		//finalizo a primeira seção
		oSection1:Finish()
Return
/*
static function ajustaSx1(cPerg)
	//Aqui utilizo a função putSx1, ela cria a pergunta na tabela de perguntas
	putSx1(cPerg, "01", "Item Conta de ?"	  , "", "", "mv_ch1", "C", 13, 0, 0, "G", "", "CTD", "", "", "mv_par01")
	putSx1(cPerg, "02", "Item Conta até?"	  , "", "", "mv_ch2", "C", 13, 0, 0, "G", "", "CTD", "", "", "mv_par02")
	putSx1(cPerg, "03", "Data de?"	  	  , "", "", "mv_ch3", "D", 08, 0, 0, "G", "", "", "", "", "mv_par03")
	putSx1(cPerg, "04", "Data até?"	  	  , "", "", "mv_ch4", "D", 08, 0, 0, "G", "", "", "", "", "mv_par04")
return
*/