#Include 'Protheus.ch'
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relat026()
	Local oReport := nil
	Local cPerg:= Padr("RELAT026",10)
	
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
	oReport := TReport():New(cNome,"Relatório Apontamento Horas por Usuário (APROVADAS)",cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
	oReport:SetLandScape()    
	oReport:SetTotalInLine(.T.)
	oReport:lBold:= .T.
	oReport:nFontBody:=8
	//oReport:cFontBody:="Courier New"
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
	oSection1:= TRSection():New(oReport, 	"NCM",	 	{"SZ4"}, 		, .F.	, 	.T.)
	TRCell():New(oSection1,"TMP_COLAB",	"TRBAPT",	"Colaborador"  	,"@!"	,	40)
	TRCell():New(oSection1,"TMP_CC",	"TRBAPT",	"Centro de Custo"  	,"@!"	,	13)
	
	
	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas
	oSection2:= TRSection():New(oReport, "Apontamento de Horas", {"SZ4"}, NIL, .F., .T.)
	TRCell():New(oSection2,"TMP_ID"   		,"TRBAPT","ID Apt.Hrs."			,"@!"				,20)
	TRCell():New(oSection2,"TMP_DATA"   	,"TRBAPT","Data"				,"@!"				,15)
	TRCell():New(oSection2,"TMP_CONTRATO"   ,"TRBAPT","Contrato"			,"@!"				,15)
	TRCell():New(oSection2,"TMP_CODCLI"     ,"TRBAPT","Cod.Cli."			,"@!"				,15)
	TRCell():New(oSection2,"TMP_CLIENTE"   	,"TRBAPT","Cliente"				,"@!"				,30)
	TRCell():New(oSection2,"TMP_TAREFA"     ,"TRBAPT","Tarefa"				,"@!"				,30)
	TRCell():New(oSection2,"TMP_QTDHRS"		,"TRBAPT","Horas"				,"@E 999,999,999.99",14,,,,,"RIGHT")	

		
	oBreak1 := TRBreak():New(oSection2,{|| (TRBAPT->TMP_COLAB) },"Subtotal",.F.)
	TRFunction():New(oSection2:Cell("TMP_DATA")		,NIL,"COUNT",oBreak1,,,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_QTDHRS")	,NIL,"SUM",oBreak1,,,,.F.,.T.)


	
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
	
	
	cQuery := "SELECT Z4_IDAPTHR AS 'TMP_ID', Z4_COLAB AS 'TMP_COLAB', CAST(Z4_DATA AS DATE) AS 'TMP_DATA', Z4_ITEMCTA AS 'TMP_CONTRATO', Z4_XXCC AS 'TMP_CC', "
	cQuery += "	Z4_XXCLVL AS 'TMP_CLVL', Z4_ITEM AS 'TMP_ITEM', Z4_TAREFA AS 'TMP_CODTAREFA', "
	cQuery += "	CASE "
	cQuery += "		WHEN Z4_TAREFA = 'AD' THEN 'ADMINISTRACAO' WHEN Z4_TAREFA = 'CE' THEN 'COORDENACAO DE ENGENHARIA' "
	cQuery += "		WHEN Z4_TAREFA = 'CP' THEN 'COORDENACAO DE CONTRATO' WHEN Z4_TAREFA = 'CR' THEN 'COMPRAS' "
	cQuery += "		WHEN Z4_TAREFA = 'DC' THEN 'OUTROS DOCUMENTOS' WHEN Z4_TAREFA = 'DI' THEN 'DILIGENCIAMENTO / INSPECAO' "
	cQuery += "		WHEN Z4_TAREFA = 'DT' THEN 'DETALHAMENTO' WHEN Z4_TAREFA = 'EE' THEN 'ESTUDO DE ENGENHARIA' "
	cQuery += "		WHEN Z4_TAREFA = 'EX' THEN 'EXPEDICAO' WHEN Z4_TAREFA = 'LB' THEN 'TESTE DE LABORATORIO / PILOTO' "
	cQuery += "		WHEN Z4_TAREFA = 'MDB' THEN 'MANUAL / DATABOOK' WHEN Z4_TAREFA = 'OP' THEN 'OPERACOES' "
	cQuery += "		WHEN Z4_TAREFA = 'PB' THEN 'PROJETO BASICO' WHEN Z4_TAREFA = 'SC' THEN 'SERICO DE CAMPO' "
	cQuery += "		WHEN Z4_TAREFA = 'TR' THEN 'TESTE DE LABORATORIO / PILOTO' WHEN Z4_TAREFA = 'VA' THEN 'VERIFICACAO / APROVACAO' "
	cQuery += "		WHEN Z4_TAREFA = 'VD' THEN 'VENDAS' "  
	cQuery += " 	WHEN Z4_TAREFA = 'AP' THEN 'ASSUNTOS PARTICULARES'  "
	cQuery += " 	WHEN Z4_TAREFA = 'VD' THEN 'CONSULTA MEDICA/DOENCA'  "
	cQuery += " 	WHEN Z4_TAREFA = 'OU' THEN 'OUTROS'  "
	cQuery += "	END AS 'TMP_TAREFA', "
	cQuery += "	Z4_DESCR AS 'TMP_DESCR', Z4_QTDHRS AS 'TMP_QTDHRS', Z4_CLIENTE AS 'TMP_CODCLI', Z4_NOMECLI AS 'TMP_CLIENTE', Z4_STATUS "
	cQuery += "	FROM SZ4010 "
	cQuery += "	WHERE SZ4010.D_E_L_E_T_ <> '*' AND Z4_STATUS = '2' AND " 
	cQuery += " Z4_COLAB      >= '" + MV_PAR01 + "' AND  "
	cQuery += " Z4_COLAB	  <= '" + MV_PAR02 + "' AND  "
	cQuery += " Z4_ITEMCTA    >= '" + MV_PAR03 + "' AND  "
	cQuery += " Z4_ITEMCTA    <= '" + MV_PAR04 + "' AND  "
	cQuery += " Z4_DATA 	  >= '" + DTOS(MV_PAR05) + "' AND  "
	cQuery += " Z4_DATA 	  <= '" + DTOS(MV_PAR06) + "' AND  "
	cQuery += " Z4_CLIENTE	  >= '" + MV_PAR07 + "' AND  "
	cQuery += " Z4_CLIENTE	  <= '" + MV_PAR08 + "' " 
	cQuery += "	ORDER BY Z4_COLAB, Z4_DATA, Z4_ITEMCTA,  Z4_NOMECLI  "
	
 
	
	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRBAPT") <> 0
		DbSelectArea("TRBAPT")
		DbCloseArea()
	ENDIF
	
	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "TRBAPT"	
	
	dbSelectArea("TRBAPT")
	TRBAPT->(dbGoTop())
	
	oReport:SetMeter(TRBAPT->(LastRec()))	

	//Irei percorrer todos os meus registros
	While !Eof()
		
		If oReport:Cancel()
			Exit
		EndIf
	
		//inicializo a primeira seção
		oSection1:Init()

		oReport:IncMeter()
					
		cNcm 	:= TRBAPT->TMP_COLAB
		IncProc("Imprimindo Apontamento de Horas (APROVADAS) "+alltrim(TRBAPT->TMP_COLAB))
		
		//imprimo a primeira seção				
		oSection1:Cell("TMP_COLAB"):SetValue(TRBAPT->TMP_COLAB)
		oSection1:Cell("TMP_CC"):SetValue(TRBAPT->TMP_CC)	
	
						
		oSection1:Printline()
		
		//inicializo a segunda seção
		oSection2:init()
		
		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While TRBAPT->TMP_COLAB == cNcm
			oReport:IncMeter()		
		

			IncProc("Imprimindo apontamento horas "+alltrim(TRBAPT->TMP_COLAB))
			oSection2:Cell("TMP_ID"):SetValue(TRBAPT->TMP_ID)
			
			
			oSection2:Cell("TMP_DATA"):SetValue(TRBAPT->TMP_DATA)
			oSection2:Cell("TMP_CONTRATO"):SetValue(TRBAPT->TMP_CONTRATO)
			oSection2:Cell("TMP_CODCLI"):SetValue(TRBAPT->TMP_CODCLI)
			oSection2:Cell("TMP_CLIENTE"):SetValue(TRBAPT->TMP_CLIENTE)
			oSection2:Cell("TMP_TAREFA"):SetValue(TRBAPT->TMP_TAREFA)
			
			oSection2:Cell("TMP_QTDHRS"):SetValue(TRBAPT->TMP_QTDHRS)
			oSection2:Cell("TMP_QTDHRS"):SetAlign("RIGHT")
			
				
						
			oSection2:Printline()
			

 			TRBAPT->(dbSkip())
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
	putSx1(cPerg, "01", "Colaborador de ?"	  , "", "", "mv_ch1", "C", 30, 0, 0, "G", "", "SZ4", "", "", "mv_par01")
	putSx1(cPerg, "02", "Colaborador até?"	  , "", "", "mv_ch2", "C", 30, 0, 0, "G", "", "SZ4", "", "", "mv_par02")
	putSx1(cPerg, "03", "Item Conta de ?"	  , "", "", "mv_ch3", "C", 13, 0, 0, "G", "", "CTD", "", "", "mv_par03")
	putSx1(cPerg, "04", "Item Conta até?"	  , "", "", "mv_ch4", "C", 13, 0, 0, "G", "", "CTD", "", "", "mv_par04")
	putSx1(cPerg, "05", "Data Registro de?"	  , "", "", "mv_ch5", "D", 08, 0, 0, "G", "", "", "", "", "mv_par05")
	putSx1(cPerg, "06", "Data Registro até?"  , "", "", "mv_ch6", "D", 08, 0, 0, "G", "", "", "", "", "mv_par06")
	putSx1(cPerg, "07", "Cliente de ?"	  	  , "", "", "mv_ch7", "C", 10, 0, 0, "G", "", "SA1", "", "", "mv_par07")
	putSx1(cPerg, "08", "Cliente até?"	  	  , "", "", "mv_ch8", "C", 10, 0, 0, "G", "", "SA1", "", "", "mv_par08")
return


