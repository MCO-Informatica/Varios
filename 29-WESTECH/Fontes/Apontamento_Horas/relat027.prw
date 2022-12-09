#Include 'Protheus.ch'
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relat027()
	Local oReport := nil
	Local cPerg:= Padr("RELAT027",10)
	
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
	Local oSection2:= Nil
	Local oBreak
	Local oFunction
	
	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
	oReport := TReport():New(cNome,"Relat�rio Apontamento Horas por Usu�rio (Geral) " + Substr(DTOS(MV_PAR05),7,2) + "/" + Substr(DTOS(MV_PAR05),5,2) + "/" + Substr(DTOS(MV_PAR05),1,4) + " at� " +  Substr(DTOS(MV_PAR06),7,2) + "/" + Substr(DTOS(MV_PAR06),5,2) + "/" + Substr(DTOS(MV_PAR06),1,4),cNome,{|oReport| ReportPrint(oReport)},"Descri��o do meu relat�rio")
	oReport:SetLandScape()    
	oReport:SetTotalInLine(.T.)
	oReport:lBold:= .T.
	oReport:nFontBody:=6
	//oReport:cFontBody:="Courier New"
	oReport:SetLeftMargin(2)
	oReport:SetLineHeight(40)
	oReport:lParamPage := .F. 	
	
	
	//Monstando a primeira se��o
	//Neste exemplo, a primeira se��o ser� composta por duas colunas, c�digo da NCM e sua descri��o
	//Iremos disponibilizar para esta se��o apenas a tabela SYD, pois quando voc� for em personalizar
	//e entrar na primeira se��o, voc� ter� todos os outros campos dispon�veis, com isso, ser�
	//permitido a inser��o dos outros campos
	//Neste exemplo, tamb�m, j� deixarei definido o nome dos campos, mascara e tamanho, mas voc�
	//ter� toda a liberdade de modific�-los via relatorio. 
	oSection1:= TRSection():New(oReport, 	"NCM",	 	{"SZ4"}, 		, .F.	, 	.T.)
	TRCell():New(oSection1,"TMP_COLAB",	"TRBAPT",	"Colaborador"  	,"@!"	,	60)
	TRCell():New(oSection1,"TMP_CC",	"TRBAPT",	"Centro de Custo"  	,"@!"	,	13)
	
	
	//A segunda se��o, ser� apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb�m a tabela de NCM, com isso, voc� poderia incluir os campos da tabela
	//SYD.Semelhante a se��o 1, defino o titulo e tamanho das colunas
	oSection2:= TRSection():New(oReport, "Apontamento de Horas", {"SZ4"}, NIL, .F., .T.)
	//TRCell():New(oSection2,"TMP_ID"   		,"TRBAPT","ID Apt.Hrs."			,"@!"				,20)
	TRCell():New(oSection2,"TMP_DATA"   	,"TRBAPT","Data"				,"@!"				,15)
	TRCell():New(oSection2,"TMP_CONTRATO"   ,"TRBAPT","Contrato"			,"@!"				,15)
	//TRCell():New(oSection2,"TMP_CODCLI"     ,"TRBAPT","Cod.Cli."			,"@!"				,15)
	TRCell():New(oSection2,"TMP_CLIENTE"   	,"TRBAPT","Cliente"				,"@!"				,40)
	TRCell():New(oSection2,"TMP_TAREFA"     ,"TRBAPT","Tarefa"				,"@!"				,30)
	
	TRCell():New(oSection2,"TMP_QTDHRS"		,"TRBAPT","Horas"				,"@E 999,999.99",10,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_TOTVLR"		,"TRBAPT","Vlr. Total"			,"@E 99,999,999.99",15,,,,,"RIGHT")	
	TRCell():New(oSection2,"TMP_DESCR"     ,"TRBAPT","Descricao"			,"@!"				,80)
	
	
		
	oBreak1 := TRBreak():New(oSection2,{|| (TRBAPT->TMP_COLAB) },"Subtotal",.F.)
	TRFunction():New(oSection2:Cell("TMP_DATA")		,NIL,"COUNT",oBreak1,,,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_QTDHRS")	,NIL,"SUM",oBreak1,,,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_TOTVLR")	,NIL,"SUM",oBreak1,,,,.F.,.T.)


	
	oReport:SetTotalInLine(.F.)
       
        //Aqui, farei uma quebra  por se��o
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
	cQuery += "	Z4_XXCLVL AS 'TMP_CLVL', Z4_ITEM AS 'TMP_ITEM', Z4_TAREFA AS 'TMP_CODTAREFA', Z4_DESCR AS 'TMP_DESCR', "
	cQuery += "	CASE "
	cQuery += "		WHEN Z4_TAREFA = 'AD' THEN 'ADMINISTRACAO' WHEN Z4_TAREFA = 'CE' THEN 'COORDENACAO DE ENGENHARIA' "
	cQuery += "		WHEN Z4_TAREFA = 'CP' THEN 'COORDENACAO DE CONTRATO' WHEN Z4_TAREFA = 'CR' THEN 'COMPRAS' "
	cQuery += "		WHEN Z4_TAREFA = 'DC' THEN 'OUTROS DOCUMENTOS' WHEN Z4_TAREFA = 'DI' THEN 'DILIGENCIAMENTO / INSPECAO' "
	cQuery += "		WHEN Z4_TAREFA = 'DT' THEN 'DETALHAMENTO' WHEN Z4_TAREFA = 'EE' THEN 'ESTUDO DE ENGENHARIA' "
	cQuery += "		WHEN Z4_TAREFA = 'EX' THEN 'EXPEDICAO' WHEN Z4_TAREFA = 'LB' THEN 'TESTE DE LABORATORIO / PILOTO' "
	cQuery += "		WHEN Z4_TAREFA = 'MDB' THEN 'MANUAL / DATABOOK' WHEN Z4_TAREFA = 'OP' THEN 'OPERACOES' "
	cQuery += "		WHEN Z4_TAREFA = 'PB' THEN 'PROJETO BASICO' WHEN Z4_TAREFA = 'SC' THEN 'SERVICO DE CAMPO' "
	cQuery += "		WHEN Z4_TAREFA = 'TR' THEN 'TESTE DE LABORATORIO / PILOTO' WHEN Z4_TAREFA = 'VA' THEN 'VERIFICACAO / APROVACAO' "
	cQuery += "		WHEN Z4_TAREFA = 'VD' THEN 'VENDAS' "  
	cQuery += " 	WHEN Z4_TAREFA = 'AP' THEN 'ASSUNTOS PARTICULARES'  "
	cQuery += " 	WHEN Z4_TAREFA = 'VD' THEN 'CONSULTA MEDICA/DOENCA'  "
	cQuery += " 	WHEN Z4_TAREFA = 'OU' THEN 'OUTROS'  "
	cQuery += "	END AS 'TMP_TAREFA', "
	cQuery += "	Z4_DESCR AS 'TMP_DESCR', Z4_QTDHRS AS 'TMP_QTDHRS', Z4_TOTVLR AS 'TMP_TOTVLR', Z4_CLIENTE AS 'TMP_CODCLI', Z4_NOMECLI AS 'TMP_CLIENTE', Z4_STATUS "
	cQuery += "	FROM SZ4010 "
	cQuery += "	WHERE SZ4010.D_E_L_E_T_ <> '*' AND " 
	cQuery += " Z4_COLAB      >= '" + MV_PAR01 + "' AND  "
	cQuery += " Z4_COLAB	  <= '" + MV_PAR02 + "' AND  "
	cQuery += " Z4_ITEMCTA    >= '" + MV_PAR03 + "' AND  "
	cQuery += " Z4_ITEMCTA    <= '" + MV_PAR04 + "' AND  "
	cQuery += " Z4_DATA 	  >= '" + DTOS(MV_PAR05) + "' AND  "
	cQuery += " Z4_DATA 	  <= '" + DTOS(MV_PAR06) + "' AND  "
	cQuery += " Z4_CLIENTE	  >= '" + MV_PAR07 + "' AND  "
	cQuery += " Z4_CLIENTE	  <= '" + MV_PAR08 + "' AND  " 
	cQuery += " Z4_TAREFA	  >= '" + MV_PAR09 + "' AND  "
	cQuery += " Z4_TAREFA	  <= '" + MV_PAR10 + "' " 
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
	
		//inicializo a primeira se��o
		oSection1:Init()

		oReport:IncMeter()
					
		cNcm 	:= TRBAPT->TMP_COLAB
		IncProc("Imprimindo Apontamento de Horas (GERAL) "+alltrim(TRBAPT->TMP_COLAB))
		
		//imprimo a primeira se��o				
		oSection1:Cell("TMP_COLAB"):SetValue(TRBAPT->TMP_COLAB)
		oSection1:Cell("TMP_CC"):SetValue(TRBAPT->TMP_CC)	
	
						
		oSection1:Printline()
		
		//inicializo a segunda se��o
		oSection2:init()
		
		//verifico se o codigo da NCM � mesmo, se sim, imprimo o produto
		While TRBAPT->TMP_COLAB == cNcm
			oReport:IncMeter()		
		

			IncProc("Imprimindo apontamento horas "+alltrim(TRBAPT->TMP_COLAB))
			//oSection2:Cell("TMP_ID"):SetValue(TRBAPT->TMP_ID)
			
			
			oSection2:Cell("TMP_DATA"):SetValue(TRBAPT->TMP_DATA)
			oSection2:Cell("TMP_CONTRATO"):SetValue(TRBAPT->TMP_CONTRATO)
			//oSection2:Cell("TMP_CODCLI"):SetValue(TRBAPT->TMP_CODCLI)
			oSection2:Cell("TMP_CLIENTE"):SetValue(TRBAPT->TMP_CLIENTE)
			oSection2:Cell("TMP_TAREFA"):SetValue(TRBAPT->TMP_TAREFA)
			
			
			oSection2:Cell("TMP_QTDHRS"):SetValue(TRBAPT->TMP_QTDHRS)
			oSection2:Cell("TMP_QTDHRS"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_TOTVLR"):SetValue(TRBAPT->TMP_TOTVLR)
			oSection2:Cell("TMP_TOTVLR"):SetAlign("RIGHT")		
			
			oSection2:Cell("TMP_DESCR"):SetValue(TRBAPT->TMP_DESCR)			
			oSection2:Printline()
			

 			TRBAPT->(dbSkip())
 		EndDo		
 		//finalizo a segunda se��o para que seja reiniciada para o proximo registro
 		oSection2:Finish()
 		//imprimo uma linha para separar uma NCM de outra
 		oReport:ThinLine()
 		//finalizo a primeira se��o
		oSection1:Finish()
	Enddo
Return

static function ajustaSx1(cPerg)
	//Aqui utilizo a fun��o putSx1, ela cria a pergunta na tabela de perguntas
	putSx1(cPerg, "01", "Colaborador de ?"	  , "", "", "mv_ch1", "C", 30, 0, 0, "G", "", "SZ4", "", "", "mv_par01")
	putSx1(cPerg, "02", "Colaborador at�?"	  , "", "", "mv_ch2", "C", 30, 0, 0, "G", "", "SZ4", "", "", "mv_par02")
	putSx1(cPerg, "03", "Item Conta de ?"	  , "", "", "mv_ch3", "C", 13, 0, 0, "G", "", "CTD", "", "", "mv_par03")
	putSx1(cPerg, "04", "Item Conta at�?"	  , "", "", "mv_ch4", "C", 13, 0, 0, "G", "", "CTD", "", "", "mv_par04")
	putSx1(cPerg, "05", "Data Registro de?"	  , "", "", "mv_ch5", "D", 08, 0, 0, "G", "", "", "", "", "mv_par05")
	putSx1(cPerg, "06", "Data Registro at�?"  , "", "", "mv_ch6", "D", 08, 0, 0, "G", "", "", "", "", "mv_par06")
	putSx1(cPerg, "07", "Cliente de ?"	  	  , "", "", "mv_ch7", "C", 10, 0, 0, "G", "", "SA1", "", "", "mv_par07")
	putSx1(cPerg, "08", "Cliente at�?"	  	  , "", "", "mv_ch8", "C", 10, 0, 0, "G", "", "SA1", "", "", "mv_par08")
	putSx1(cPerg, "09", "Tarefa de ?"	  	  , "", "", "mv_ch9", "C", 02, 0, 0, "G", "", "ZZ", "", "", "mv_par09")
	putSx1(cPerg, "10", "Tarefa at�?"	  	  , "", "", "mv_ch10", "C", 02, 0, 0, "G", "", "ZZ", "", "", "mv_par10")
	
return
