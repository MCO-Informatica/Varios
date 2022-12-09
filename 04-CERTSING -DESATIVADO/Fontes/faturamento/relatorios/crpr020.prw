#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao    ³ CRPR020   ³ Autor ³ Tatiana Pontes      ³ Data ³ 08/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao ³ Relatorio de Inconsistencia Cadastro Entidades/Produtos	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ Certisign		                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function CRPR020()

	Local oReport
	Local cPerg 	:= 'CRPR20'
	Local cAlias 	:= 	GetNextAlias()
	
	AjustaSX1(cPerg)
	Pergunte(cPerg, .T.)

	oReport := ReportDef(cAlias, cPerg)

	oReport:PrintDialog()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao    ³ ReportPrint ³ Autor ³ Tatiana Pontes    ³ Data ³ 08/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao ³ Rotina para montagem dos dados do relatorio				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ Certisign		                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ReportPrint(oReport,cAlias)

	Local oSecao1 := oReport:Section(1)

	oSecao1:BeginQuery()
	
	If MV_PAR01 == 1 // Entidades
	
		BeginSQL Alias cAlias
	
			SELECT 	SZ3.Z3_CODGAR,	SZ3.Z3_CODENT,	SZ3.Z3_DESENT,	SZ3.Z3_CLASSI,	SZ3.Z3_MUNICI,	SZ3.Z3_ESTADO
			
			FROM %Table:SZ3% SZ3                                                                       
			
			WHERE NOT EXISTS 
			
				(SELECT SZ4.Z4_CODENT FROM %Table:SZ4% SZ4 WHERE  SZ3.Z3_CODENT = SZ4.Z4_CODENT AND SZ4.%notDel%)
			
			AND SZ3.%notDel%
				
		EndSQL
	
	Else // Produtos
	
		BeginSQL Alias cAlias
	
			SELECT PA8.PA8_CODBPG, PA8.PA8_DESBPG, PA8.PA8_CLAPRO, PA8.PA8_CATPRO 
			
			FROM %Table:PA8% PA8
			
			WHERE PA8.PA8_FILIAL = %xFilial:PA8% 
			
			AND PA8.PA8_CATPRO = '  '      
			
			AND PA8.%notDel%
			
		EndSQL
		
	Endif
		
	oSecao1:EndQuery()
	
	oReport:SetMeter((cAlias)->(RecCount()))
	
	oSecao1:Print()
	
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao    ³ ReportDef	³ Autor ³ Tatiana Pontes    ³ Data ³ 08/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao ³ Funcao para criacao da estrutura do relatorio			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ Certisign		                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ReportDef(cAlias,cPerg)

	Local cTitle
	Local cHelp
	
	Local oReport
	Local oSection1                  
	Local aOrdem  
	
	If mv_par01 == 1 // Entidades
		
		cTitle 	:= "Relatório de Entidades sem Regras"
		cHelp 	:= "Permite gerar relatório de entidades sem regras de remuneração cadastradas."        
		
		aOrdem  := { "Por Cód. Entidade" }
	
		oReport := TReport():New('CRPR20',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)
		
		oSection1 := TRSection():New(oReport,"Entidades",{"SZ3"},aOrdem)
		
		TRCell():New(oSection1,"Z3_CODGAR", "SZ3", "Cód.Gar")
		TRCell():New(oSection1,"Z3_CODENT", "SZ3", "Cód.Protheus")
   		TRCell():New(oSection1,"Z3_DESENT", "SZ3", "Descrição")
		TRCell():New(oSection1,"Z3_CLASSI", "SZ3", "Rede")
		TRCell():New(oSection1,"Z3_MUNICI", "SZ3", "Cidade")
		TRCell():New(oSection1,"Z3_ESTADO", "SZ3", "Estado")

	Else // Produtos

		cTitle 	:= "Relatório de Produtos sem Categoria"
		cHelp 	:= "Permite gerar relatório de produtos sem categoria de remuneração cadastradas."
 
		aOrdem  := { "Por Cód. Gar" }
				
		oReport := TReport():New('CRPR20',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)

		oSection1 := TRSection():New(oReport,"Produtos",{"PA8"},aOrdem)

		TRCell():New(oSection1,"PA8_CODBPG", "PA8", "Prod.Gar")
		TRCell():New(oSection1,"PA8_DESBPG", "PA8", "Desc.Gar")
		TRCell():New(oSection1,"PA8_CLAPRO", "PA8", "Classificação")
		TRCell():New(oSection1,"PA8_CATPRO", "PA8", "Cat.Rem.")

	Endif
			
Return(oReport)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao    ³ ReportDef	³ Autor ³ Tatiana Pontes    ³ Data ³ 08/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao ³ Funcao para criacao da estrutura do relatorio			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ Certisign		                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function AjustaSX1(cPerg)

	Local aHlpPor := {}

	aHlpPor := {}
	aAdd(aHlpPor,"Selecione Entidades")
	aAdd(aHlpPor,"ou Produtos")
	PutSx1(cPerg,	"01","Qual cadastro?","","","mv_ch1","C",1,0,1,;   
					"C","","","","S","Mv_Par01","Entidades","","","","Produtos","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)
	
Return(.T.)