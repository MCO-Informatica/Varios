#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relat008()
	Local oReport := nil
	Local cPerg:= Padr("RELAT008",10)
	
	
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
	oReport := TReport():New(cNome,"Relat�rio Apontamento Horas - " + Substr(DTOS(MV_PAR03),7,2) + "/" + Substr(DTOS(MV_PAR03),5,2) + "/" + Substr(DTOS(MV_PAR03),1,4) + " at� " +  Substr(DTOS(MV_PAR04),7,2) + "/" + Substr(DTOS(MV_PAR04),5,2) + "/" + Substr(DTOS(MV_PAR04),1,4),cNome,{|oReport| ReportPrint(oReport)},"Descri��o do meu relat�rio")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.T.)
	oReport:lBold:= .T.
	oReport:nFontBody:=7
	//oReport:cFontBody:="Arial"
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
	oSection1:= TRSection():New(oReport, 	"NCM",	 	{"SZ4"}, 	, .F.	, 	.T.)
	TRCell():New(oSection1,"TMP_CONTRATO"	,"TRBAPT"	,"Contrato"		,"@!"	,	13)
	TRCell():New(oSection1,"TMP_QTDHRS"		,"TRBAPT"	,"Total Horas"	,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRFunction():New(oSection1:Cell("TMP_QTDHRS")	,NIL,"SUM",,,,,.F.,.T.)
	
	oReport:SetTotalInLine(.F.)
       
        //Aqui, farei uma quebra  por se��o
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
	
	cQuery := "SELECT Z4_ITEMCTA AS 'TMP_CONTRATO', " 
	cQuery += " SUM(Z4_QTDHRS) AS 'TMP_QTDHRS' " 
	cQuery += " FROM SZ4010 " 
	cQuery += " WHERE SZ4010.D_E_L_E_T_ <> '*' AND " 
	cQuery += " Z4_ITEMCTA    >= '" + MV_PAR01 + "' AND  " 
	cQuery += " Z4_ITEMCTA    <= '" + MV_PAR02 + "' AND  "
	cQuery += " Z4_DATA		  >= '" + DTOS(MV_PAR03) + "' AND  "
	cQuery += " Z4_DATA    	  <= '" + DTOS(MV_PAR04) + "' " 
	cQuery += " GROUP BY  Z4_ITEMCTA "
	cQuery += " ORDER BY  Z4_ITEMCTA "
	
	
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
					
		cNcm 	:= TRBAPT->TMP_CONTRATO
		IncProc("Imprimindo Apontamento Horas "+alltrim(TRBAPT->TMP_CONTRATO))
		
		//imprimo a primeira se��o				
		oSection1:Cell("TMP_CONTRATO"):SetValue(TRBAPT->TMP_CONTRATO)
		oSection1:Cell("TMP_QTDHRS"):SetValue(TRBAPT->TMP_QTDHRS)	
		oReport:ThinLine()
		oSection1:Printline()
		TRBAPT->(dbSkip())
 		
	Enddo
	
	//imprimo uma linha para separar uma NCM de outra
 		
 		//finalizo a primeira se��o
		oSection1:Finish()
Return

static function ajustaSx1(cPerg)
	//Aqui utilizo a fun��o putSx1, ela cria a pergunta na tabela de perguntas
	putSx1(cPerg, "01", "Item Conta de ?"	  , "", "", "mv_ch1", "C", 13, 0, 0, "G", "", "CTD", "", "", "mv_par01")
	putSx1(cPerg, "02", "Item Conta at�?"	  , "", "", "mv_ch2", "C", 13, 0, 0, "G", "", "CTD", "", "", "mv_par02")
	putSx1(cPerg, "03", "Data de?"	  	  , "", "", "mv_ch3", "D", 08, 0, 0, "G", "", "", "", "", "mv_par03")
	putSx1(cPerg, "04", "Data at�?"	  	  , "", "", "mv_ch4", "D", 08, 0, 0, "G", "", "", "", "", "mv_par04")
return







