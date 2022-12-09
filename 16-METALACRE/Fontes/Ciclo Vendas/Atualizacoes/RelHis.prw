#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RelHis   ºAutor  ³ Luiz     º Data ³  27/10/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatórios de Historico de Ciclo de Vendas  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Metalacre - Protheus 11                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RelHis()
Local aArea    := GetArea()
Local oReport   
Private cPerg := PadR('RELHIS',10)
cAlias := "QRYCNF"
	
AjustaSX1()
Pergunte(cPerg,.F.)

oReport := ReportDef()
oReport:PrintDialog()
RestArea(aArea) 
Return
    
Static Function ReportDef() 
Local oReport
Local oSection
Local oBreak
Local cTitulo	:= "Relatorio de Historico do Ciclo de Clientes"



oReport := TReport():New("RelLog",cTitulo,cPerg,{|oReport| PrintReport(oReport)},cTitulo,.t.,,,,,,2)
oReport:cFontBody := 'Courier New'
oReport:nFontBody := 9
oReport:SetLandscape()    
oReport:LPARAMPAGE := .T.	// Pagina de Parametros Impressao


oSection := TRSection():New(oReport,"Historico",{"SZ3"})

	TRCell():New(oSection,"Z3_DATA",cAlias)
	TRCell():New(oSection,"Z3_HORA",cAlias)
	TRCell():New(oSection,"Z3_CLIENTE",cAlias)
	TRCell():New(oSection,"Z3_LOJA",cAlias)
	TRCell():New(oSection,"A1_NOME",cAlias)
//	TRCell():New(oSection,"Z3_USER",cAlias)
	TRCell():New(oSection,"Z3_NMUSER",cAlias)
	TRCell():New(oSection,"Z4_MCICLO",cAlias)
	TRCell():New(oSection,"Z4_CICLO",cAlias)
	TRCell():New(oSection,"Z4_VENCICL",cAlias,'Salto')
	TRCell():New(oSection,"Z3_HISTM",cAlias)

	oSection:Cell("Z3_CLIENTE"):lHeaderSize := .F.
	oSection:Cell("Z3_LOJA"):lHeaderSize := .F.
	oSection:Cell("Z3_DATA"):lHeaderSize := .F.
	oSection:Cell("Z3_HORA"):lHeaderSize := .F.
//	oSection:Cell("Z3_USER"):lHeaderSize := .F.
//	oSection:Cell("Z4_MCICLO"):lHeaderSize := .F.
	oSection:Cell("Z4_CICLO"):lHeaderSize := .F.
//	oSection:Cell("Z4_VENCICL"):lHeaderSize := .F.

	oSection:Cell("Z3_CLIENTE"):nSize := 10
	oSection:Cell("Z3_LOJA"):nSize := 4
	oSection:Cell("Z3_DATA"):nSize := 12
	oSection:Cell("Z3_HORA"):nSize := 14
	oSection:Cell("Z4_CICLO"):nSize := 12
//	oSection:Cell("Z3_USER"):nSize := 12
//	oSection:Cell("Z4_MCICLO"):nSize := 15

//oSection:SetLineStyle()     
Return oReport

    
Static Function PrintReport(oReport)
Local oSection := oReport:Section(1)
Local cPart
Local cFiltro   := ""

#IFDEF TOP

	//Transforma parametros do tipo Range em expressao SQL para ser utilizada na query 
	MakeSqlExpr(cPerg)

	oSection:BeginQuery()
	
	
	
	BeginSql alias cAlias
		SELECT Z3_DATA, Z3_HORA, Z3_CLIENTE, Z3_LOJA, A1_NOME, CONVERT(VARCHAR(8000),CONVERT(BINARY(8000), Z3_HISTM)) AS Z3_HISTM, Z3_USER, Z3_NMUSER, Z4_MCICLO, Z4_CICLO
		FROM %table:SZ3% SZ3, %table:SA1% SA1, %table:SZ4% SZ4
		WHERE Z3_FILIAL = %xfilial:SZ3%
		AND A1_FILIAL = %xfilial:SA1%
		AND Z4_FILIAL = %xfilial:SZ4%
		AND SA1.%notDel%
		AND SZ3.%notDel%
		AND SZ4.%notDel%
		AND Z3_DATA 	BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		AND Z3_HORA 	BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
		AND Z3_USER		BETWEEN %Exp:mv_par05% AND %Exp:mv_par06%
		AND Z3_CLIENTE	BETWEEN %Exp:mv_par07% AND %Exp:mv_par08%
		AND Z3_LOJA		BETWEEN %Exp:mv_par09% AND %Exp:mv_par10%
		AND Z4_ATIVO = 'S'
		AND SA1.A1_COD = SZ3.Z3_CLIENTE 
		AND SA1.A1_LOJA = SZ3.Z3_LOJA
		AND Z4_CLIENTE = SZ3.Z3_CLIENTE
		AND Z4_LOJA = SZ3.Z3_LOJA
		ORDER BY Z3_DATA, Z3_HORA, Z3_CLIENTE, Z3_LOJA
	EndSql
	oSection:EndQuery()
	
	oReport:SetTitle('Relatorio de Acoes de Ciclo de Clientes - Periodo de ' + DtoC(MV_PAR01) + ' Ate ' + DtoC(MV_PAR02))

	/*
	Prepara relatorio para executar a query gerada pelo Embedded SQL passando como 
	parametro a pergunta ou vetor com perguntas do tipo Range que foram alterados 
	pela funcao MakeSqlExpr para serem adicionados a query
	*/

    oSection:SetTotalInLine(.F.)
    oReport:SetMeter(RecCount())
    
    
    dbGoTop()
    oReport:IncMeter()      
    oSection:Init()
    While !Eof()
        If oReport:Cancel()
            Exit
        EndIf
        oReport:IncMeter()      
        oReport:SkipLine(1)

        oSection:Cell("Z3_DATA"):SetValue((cAlias)->Z3_DATA)
        oSection:Cell("Z3_HORA"):SetValue((cAlias)->Z3_HORA)
        oSection:Cell("Z3_CLIENTE"):SetValue((cAlias)->Z3_CLIENTE)
        oSection:Cell("Z3_LOJA"):SetValue((cAlias)->Z3_LOJA)
        oSection:Cell("A1_NOME"):SetValue((cAlias)->A1_NOME)
//        oSection:Cell("Z3_USER"):SetValue((cAlias)->Z3_USER)
        oSection:Cell("Z3_NMUSER"):SetValue((cAlias)->Z3_NMUSER)
        oSection:Cell("Z4_MCICLO"):SetValue((cAlias)->Z4_MCICLO)
        oSection:Cell("Z4_CICLO"):SetValue((cAlias)->Z4_CICLO)
        oSection:Cell("Z4_VENCICL"):SetValue(((cAlias)->Z4_CICLO-(cAlias)->Z3_DATA))
        oSection:Cell("Z3_HISTM"):SetValue((cAlias)->Z3_HISTM)

        oSection:PrintLine()        
        oReport:ThinLine()
        oReport:SkipLine(1)
        
        dbSkip(1)
    Enddo

    oSection:Finish()
#ELSE
#ENDIF	

        

Return





//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function AjustaSX1()                                                                                                                                       
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local aHelpPor01 := {}
Local aHelpPor02 := {}
Local aHelpPor03 := {}
Local aHelpPor04 := {}
Local aHelpPor05 := {}
Local aHelpPor06 := {}
Local aHelpPor07 := {}

PutSx1(cPerg,'01','Data De        ?','','','mv_ch1','D',08, 0, 0,'G','',''   ,'','','mv_par01'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor01,aHelpPor01,aHelpPor01)
PutSx1(cPerg,'02','Data Ate       ?','','','mv_ch2','D',08, 0, 0,'G','',''   ,'','','mv_par02'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor02,aHelpPor02,aHelpPor02)
PutSx1(cPerg,'03','Hora De        ?','','','mv_ch3','C',05, 0, 0,'G','',''   ,'','','mv_par03'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor01,aHelpPor01,aHelpPor01)
PutSx1(cPerg,'04','Hora Ate       ?','','','mv_ch4','C',05, 0, 0,'G','',''   ,'','','mv_par04'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor02,aHelpPor02,aHelpPor02)
PutSx1(cPerg,'05','Vendedor De    ?','','','mv_ch5','C',06, 0, 0,'G','','USR','','','mv_par05'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor01,aHelpPor01,aHelpPor01)
PutSx1(cPerg,'06','Vendedor Ate   ?','','','mv_ch6','C',06, 0, 0,'G','','USR','','','mv_par06'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor02,aHelpPor02,aHelpPor02)
PutSx1(cPerg,'07','Cliente de     ?','','','mv_ch7','C',06, 0, 0,'G','','SA1','','','mv_par07'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor03,aHelpPor03,aHelpPor03)                               
PutSx1(cPerg,'08','Cliente Ate    ?','','','mv_ch8','C',06, 0, 0,'G','','SA1','','','mv_par08'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor04,aHelpPor04,aHelpPor04)                               
PutSx1(cPerg,'09','Loja de        ?','','','mv_ch9','C',02, 0, 0,'G','',''   ,'','','mv_par09'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor03,aHelpPor03,aHelpPor03)                               
PutSx1(cPerg,'10','Loja Ate       ?','','','mv_ch0','C',02, 0, 0,'G','',''   ,'','','mv_par10'			 ,'','','',''		  ,'','','','','','','','','','','','',aHelpPor04,aHelpPor04,aHelpPor04)                               
Return NIL