#Include 'Protheus.ch'
#include 'TopConn.CH'

/*/{Protheus.doc} RlnfVol
relatorio em advpl
@type function
@author Curso Desenvolvendo relatórios com ADVPL 
@since 2021
@version 1.0

/*/

User Function RlNfVol()

	Local oReport := Nil
	Local cPerg   := PADr("RlNfVol",10)
	
	Pergunte(cPerg,.F.) //SX1                                                                                                                      
	
	oReport:= RptStruc(cPerg)
	oReport:PrintDialog()
Return

Static Function RPTPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local cQuery  := ""
	Local cNumCod := ""
        
	cQuery :=  " SELECT F2_CLIENTE AS COD_CLIENTE, A1_NOME AS CLIENTE,F2_DOC AS NF," + CRLF
      cQuery +=  " F2_SERIE AS SERIE, F2_EMISSAO AS EMISSAO, COUNT(F2_FILIAL) AS TOTAL_EMITIDAS , SUM (F2_VALFAT) TOTAL_FATURADO, SUM(F2_VOLUME1)TOTAL_VOLUME " + CRLF
       cQuery +=  "  FROM " + RetSQLName('SF2') + " F2 " + CRLF
         cQuery +=  " INNER JOIN "+ RetSQLName('SA1') + " A1 ON A1_COD=F2_CLIENTE " + CRLF
       cQuery +=  " AND A1.D_E_L_E_T_ =f2.D_E_L_E_T_ " + CRLF
      cQuery +=  " AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " + CRLF
    cQuery +=  " GROUP BY F2_CLIENTE,A1_NOME, F2_DOC, F2_SERIE, F2_EMISSAO, F2_FILIAL, F2_VALFAT, F2_VOLUME1" + CRLF


	
		//Verifica se a tabela ja está aberta.
			If Select("TEMP") <> 0
				DbSelectArea("TEMP")
				DbCloseArea()
			EndIf
			
		TCQUERY cQuery NEW ALIAS "TEMP" //envia Cquery para Alias -> Temp
			
			DbSelectArea("TEMP")//Seleciona a área
			TEMP->(dbGoTop())// comando para leitura a partir da topo da tabela
			
			oReport:SetMeter(TEMP->(LastRec()))
			
		While !EOF()
			If oReport:Cancel()
				Exit
			EndIf
			//Iniciando a primeira seção
			oSection1:Init()
			oReport:IncMeter()
			
			cNumCod := TEMP->COD_CLIENTE
			IncProc("Imprimindo Cliente "+ Alltrim(TEMP->COD_CLIENTE))
			
	//Imprimindo primeira seção:
		oSection1:Cell("F2_CLIENTE"):SetValue(TEMP->COD_CLIENTE)
		oSection1:Cell("A1_NOME"):SetValue(TEMP->CLIENTE)				
		oSection1:Printline()
		
		
			//Iniciar a impressão da seção 2
		oSection2:Init()
		
			//verifica se o codigo do cliente é o mesmo, se sim, imprime os dados do pedido
		While TEMP->COD_CLIENTE == cNumCod
			oReport:IncMeter()
			
		IncProc("Imprimindo Notas Fiscais..."+ Alltrim(TEMP->NF))
			oSection2:Cell("COD_CLIENTE"):SetValue(TEMP->COD_CLIENTE)
			oSection2:Cell("F2_DOC"):SetValue(TEMP->NF)
			oSection2:Cell("F2_SERIE"):SetValue(TEMP->SERIE)			
			oSection2:Cell("F2_EMISSAO"):SetValue(TEMP->EMISSAO)
            oSection2:Cell("F2_FILIAL"):SetValue(TEMP->TOTAL_EMITIDAS)	
            oSection2:Cell("F2_VALFAT"):SetValue(TEMP->TOTAL_FATURADO)
            oSection2:Cell("F2_VOLUME1"):SetValue(TEMP->TOTAL_VOLUME)
			oSection2:Printline()
			
			TEMP->(dbSkip())
			
		EndDo
			oSection2:Finish()
			oReport:ThinLine()
			
			oSection1:Finish()
			
		EndDo
			
Return


Static Function RPTStruc(cNome)
	Local oReport   := Nil
	Local oSection1 := Nil
	Local oSection2 := Nil
    Local cHelp     := "Imprime relacao de notas fiscais por data com total de volumes"
    Local ctitulo   := "Relatorio de Nf x Data X Volumes " 
	
	oReport := TReport():New(cNome,ctitulo,cNome,{|oReport| RPTPRINT(oReport)},cHelp)
	
	oReport:SetPortrait() //Definindo a orientação como retrato
	
	oSection1 := TRSection():New(oReport, "Clientes",{"SA1"}, NIL,.F.,.T.)
	TRCell():New(oSection1,"F2_CLIENTE"		,"TEMP","CODIGO"  		,"@!",40)
	TRCell():New(oSection1,"A1_NOME"  ,"TEMP","CLIENTE"	,"@!",200)
	
	oSection2 := TRSection():New(oReport, "NOTAS FISCAIS",{"SF2"}, NIL,.F.,.T.)
	TRCell():New(oSection2,"F2_CLIENTE"   	,"TEMP","COD_CLIENTE"	,"@!",30)
	TRCell():New(oSection2,"F2_DOC"  	,"TEMP","NF"	,"@!",100)
    TRCell():New(oSection2,"F2_SERIE"  	,"TEMP","SERIE"	,"@!",100)
	TRCell():New(oSection2,"F2_EMISSAO"	,"TEMP","EMISSAO"	,"@E 99999999",20)	
	TRCell():New(oSection2,"F2_FILIAL"	,"TEMP","TOTAL_EMITIDAS","@!",30)
    TRCell():New(oSection2,"F2_VALFAT"	,"TEMP","TOTAL_FATURADO","@E 999999.99",20)
    TRCell():New(oSection2,"F2_VOLUME1"	,"TEMP","TOTAL_VOLUME"	,"@!" , 20)

	
	oSection1:SetPageBreak(.F.) //Quebra de seção
	

Return (oReport)
