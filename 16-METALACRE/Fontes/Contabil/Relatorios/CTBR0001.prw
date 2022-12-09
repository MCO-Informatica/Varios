#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
 
#DEFINE CRLF CHR(13)+CHR(10)    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ CTBR0001 ºAutor  ³ ASR Sistemas       º Data ³ 21.06.2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Gera realtório por grupo contábil                           º±±
±±º          ³															  º±±  
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ormazabal                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CTBR0001

Local aArea	:= GetArea()
Local cPerg	:= "CTBR0001"

AjustaSx1() 

If Pergunte( cPerg, .T. )
	dDataIni :=MV_PAR01
	dDataFim :=MV_PAR02 
	cGrupoIni:=MV_PAR03
	cGrupoFim:=MV_PAR04
	MsgRun("Gerando Relatório","A g u a r d e . . .",{||CursorWait(),CTBRel(dDataIni,dDataFim,cGrupoIni,cGrupoFim),CursorArrow()})
Endif

RestArea(aArea) 

Return()

/*
+-----------------------------------------------------------------------------+
| PROGRAMA: CTBRel       | AUTOR: ASR Sistemas              DATA: 21/06/2017  |
+-----------------------------------------------------------------------------+
| DESCRICAO:  Geraçao do Relatório em excel                                   |
+-----------------------------------------------------------------------------+
| USO: Ormazabal             				                                  |
+-----------------------------------------------------------------------------+   
*/ 

Static Function CTBRel(dDataIni,dDataFim,cGrupoIni,cGrupoFim)

Local aArea     := GetArea()
Local nAux      := 0
Local oFWMsExcel
Local oExcel
Local cArquivo	:= GetTempPath()+'CTBR0001.xml'
Local cWorkSheet:= "PyG"
Local cTable    := "CUENTA  DE  RESULTADOS MENSUAL O. BRASIL " 
Local aColunas  := {}
Local aLinhaAux := {} 
Local aLinhaTot := {}   
Local aLinhaPag := {}
Local aMeses	:= {} 
Local aPeriodos	:= {}
Local nMeses	:= 0
Local cMoeda	:= Iif (Empty(MV_PAR05),"01",MV_PAR05)

aPeriodos := ctbPeriodos(cMoeda, MV_PAR01, MV_PAR02, .T., .F.)

For nCont := 1 to len(aPeriodos)       
	//Se a Data do periodo eh maior ou igual a data inicial solicitada no relatorio.
	If aPeriodos[nCont][1] >= mv_par01 .And. aPeriodos[nCont][2] <= mv_par02 
		If nMeses <= 12
			AADD(aMeses,{StrZero(nMeses,2),aPeriodos[nCont][1],aPeriodos[nCont][2]})	
			nMeses += 1           					
		EndIf
	EndIf
Next                                                                   

If nMeses == 1
	cMensagem := "Por favor, verifique se o calend.contabil e a amarracao moeda/calendario "	
	cMensagem += "foram cadastrados corretamente..."			
	MsgAlert(cMensagem)
	Return
EndIf  
/*
Tipo de Saldo (cTpSaldo)
1 - Real
2 - Previsto
3 - Gerencial
4 - Empenhado
*/

GeraQry(dDataIni,dDataFim,"1",cMoeda,cGrupoIni,cGrupoFim,,,.T.,aMeses,,,.F.,)  
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Compondo as colunas do relatório                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aColunas, " ")
For  nX :=1 to Len(aMeses) 
	If Month(aMeses[nX][2]) == 1  
    	aAdd(aColunas, "Jan/" + cValToChar(Year(aMeses[nX][2])) ) 
 	Elseif Month(aMeses[nX][2]) == 2
  		aAdd(aColunas, "Fev/" + cValToChar(Year(aMeses[nX][2])) ) 
  	Elseif Month(aMeses[nX][2]) == 3
  		aAdd(aColunas, "Mar/" + cValToChar(Year(aMeses[nX][2])) ) 
  	Elseif Month(aMeses[nX][2]) == 4
  		aAdd(aColunas, "Abr/" + cValToChar(Year(aMeses[nX][2])) ) 
  	Elseif Month(aMeses[nX][2]) == 5
  		aAdd(aColunas, "Mai/" + cValToChar(Year(aMeses[nX][2])) ) 
  	Elseif Month(aMeses[nX][2]) == 6
  		aAdd(aColunas, "Jun/" + cValToChar(Year(aMeses[nX][2])) ) 
  	Elseif Month(aMeses[nX][2]) == 7
  		aAdd(aColunas, "Jul/" + cValToChar(Year(aMeses[nX][2])) ) 
  	Elseif Month(aMeses[nX][2]) == 8
  		aAdd(aColunas, "Ago/" + cValToChar(Year(aMeses[nX][2])) ) 
  	Elseif Month(aMeses[nX][2]) == 9
  		aAdd(aColunas, "Set/" + cValToChar(Year(aMeses[nX][2])) ) 
  	Elseif Month(aMeses[nX][2]) == 10
  		aAdd(aColunas, "Out/" + cValToChar(Year(aMeses[nX][2])) )
  	Elseif Month(aMeses[nX][2]) == 11
  		aAdd(aColunas, "Nov/" + cValToChar(Year(aMeses[nX][2])) )
  	Elseif Month(aMeses[nX][2]) == 12
  		aAdd(aColunas, "Dez/" + cValToChar(Year(aMeses[nX][2])) ) 
  	Endif
Next nX

aAdd(aColunas, "TOTAL") 
     
//Criando o objeto que irá gerar o conteudo do Excel
oFWMsExcel := FWMSExcel():New()  
     
//Aba 01 - PyG
oFWMsExcel:AddworkSheet(cWorkSheet) 
         
//Criando a Tabela
oFWMsExcel:AddTable(cWorkSheet, cTable)
         
//Criando Colunas
aLinhaTot:= Array(Len(aColunas))
aLinhaPag:= Array(Len(aColunas))
For nAux := 1 To Len(aColunas)
	oFWMsExcel:AddColumn(cWorkSheet, cTable, aColunas[nAux],1,2) 
	aLinhaTot[nAux] := Iif(nAux == 1,"TOTAL",0)
	aLinhaPag[nAux] := ""  
Next

TRBTMP->(dbGoTop()) 
While TRBTMP->(!Eof())
    aLinhaAux := Array(Len(aColunas))
    For nAux := 2 To Len(aColunas)
    	If Left(aColunas[nAux],3) == 'Jan'
    		aLinhaAux[1] := TRBTMP->CRT_DESC 
    		aLinhaAux[nAux] := 	TRBTMP->COLUNA1 
    	   	aLinhaTot[nAux] += TRBTMP->COLUNA1  
       	Elseif Left(aColunas[nAux],3) == 'Fev' 
       		aLinhaAux[1] := TRBTMP->CRT_DESC 
         	aLinhaAux[nAux] := TRBTMP->COLUNA2
    		aLinhaTot[nAux] += TRBTMP->COLUNA2
        Elseif Left(aColunas[nAux],3) == 'Mar' 
        	aLinhaAux[1] := TRBTMP->CRT_DESC 
        	aLinhaAux[nAux] := 	TRBTMP->COLUNA3
   			aLinhaTot[nAux] += TRBTMP->COLUNA3
      	Elseif Left(aColunas[nAux],3) == 'Abr' 
      		aLinhaAux[1] := TRBTMP->CRT_DESC 
        	aLinhaAux[nAux] := 	TRBTMP->COLUNA4
        	aLinhaTot[nAux] += TRBTMP->COLUNA4
       	Elseif Left(aColunas[nAux],3) == 'Mai' 
       		aLinhaAux[1] := TRBTMP->CRT_DESC 
        	aLinhaAux[nAux] := 	TRBTMP->COLUNA5
        	aLinhaTot[nAux] += TRBTMP->COLUNA5
        Elseif Left(aColunas[nAux],3) == 'Jun'
        	aLinhaAux[1] := TRBTMP->CRT_DESC
        	aLinhaAux[nAux] := 	TRBTMP->COLUNA6
        	aLinhaTot[nAux] += TRBTMP->COLUNA6
       	Elseif Left(aColunas[nAux],3) == 'Jul' 
       		aLinhaAux[1] := TRBTMP->CRT_DESC
        	aLinhaAux[nAux] := 	TRBTMP->COLUNA7
        	aLinhaTot[nAux] += TRBTMP->COLUNA7  
       	Elseif Left(aColunas[nAux],3) == 'Ago'
       		aLinhaAux[1] := TRBTMP->CRT_DESC
        	aLinhaAux[nAux] := 	TRBTMP->COLUNA8
        	aLinhaTot[nAux] += TRBTMP->COLUNA8
       	Elseif Left(aColunas[nAux],3) == 'Set'
       		aLinhaAux[1] := TRBTMP->CRT_DESC 
        	aLinhaAux[nAux] := 	TRBTMP->COLUNA9
        	aLinhaTot[nAux] += TRBTMP->COLUNA9
       	Elseif Left(aColunas[nAux],3) == 'Out'
       		aLinhaAux[1] := TRBTMP->CRT_DESC 
        	aLinhaAux[nAux] := 	TRBTMP->COLUNA10
        	aLinhaTot[nAux] += TRBTMP->COLUNA10
       	Elseif Left(aColunas[nAux],3) == 'Nov' 
       		aLinhaAux[1] := TRBTMP->CRT_DESC
        	aLinhaAux[nAux] := 	TRBTMP->COLUNA11
        	aLinhaTot[nAux] += TRBTMP->COLUNA11
       	Elseif Left(aColunas[nAux],3) == 'Dez'
       	 	aLinhaAux[1] := TRBTMP->CRT_DESC
        	aLinhaAux[nAux] := 	TRBTMP->COLUNA12
        	aLinhaTot[nAux] += TRBTMP->COLUNA12 
        Elseif aColunas[nAux] == "TOTAL"        
        	aLinhaAux[nAux] := 0
        	aLinhaTot[nAux] += 0
       	Endif 
 	Next nAux 
	//Adiciona a linha no Excel
	oFWMsExcel:AddRow(cWorkSheet, cTable, aLinhaAux)
    TRBTMP->(DbSkip())
EndDo                  

// TOTALIZADOR DA LINHA            
oFWMsExcel:CBGCOLORLINE:= ("#FFFFFF")
oFWMsExcel:AddRow(cWorkSheet, cTable, aLinhaTot)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VISAO POR CENTRO DE CUSTO    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
//Adiciona uma linha vazia no Excel separando do relatorio por receita
//oFWMsExcel:AddRow(cWorkSheet, cTable, aLinhaPag)
//oFWMsExcel:AddRow(cWorkSheet, cTable, aLinhaPag)

       
//Ativando o arquivo e gerando o xml
oFWMsExcel:Activate()
oFWMsExcel:GetXMLFile(cArquivo)
         
//Abrindo o excel e abrindo o arquivo xml
oExcel := MsExcel():New()          	//Abre uma nova conexão com Excel
oExcel:WorkBooks:Open(cArquivo)    	//Abre uma planilha
oExcel:SetVisible(.T.)             	//Visualiza a planilha
oExcel:Destroy()                   	//Encerra o processo do gerenciador de tarefas
     
TRBTMP->(DbCloseArea())
RestArea(aArea)   
    
Return 



/*/ 
+----------------------------------------------------------------------- 
| Funcao | GeraQry   | Autor | ASR Sistemas   | Data | 21/06/2017      | 
+-----------------------------------------------------------------------
| Descric| Query Receita Total                                         | 
+-----------------------------------------------------------------------  
| Uso    | Ormazabal                                                   | 
+----------------------------------------------------------------------- 
/*/ 
Static Function GeraQry(dDataIni,dDataFim,cTpSaldo,cMoeda,cGrupoIni,cGrupoFim,aSetOfBook,lVlrZerado,lMeses,aMeses,cString,cFILUSU,lAcum)                                                           

Local aSaveArea	:= GetArea()
Local cQuery	:= ""
Local nColunas	:= 0
Local aTamVlr	:= TAMSX3("CT7_DEBITO")
Local nStr		:= 1
Local lCT1EXDTFIM := CtbExDtFim("CT1") 

DEFAULT lVlrZerado	:= .F.
DEFAULT lAcum		:= .F. 

cQuery := " SELECT CT1_GRUPO, CRT_DESC " 
If lMeses
	For nX := 1 to Len(aMeses)
		cQuery += ", SUM(COLUNA" + Str(nX,Iif(nX>9,2,1)) +")" + "  COLUNA" + Str(nX,Iif(nX>9,2,1)) 
	Next                                                                                           
EndIf

cQuery += " "+ CRLF
cQuery += " FROM " + CRLF  
cQuery += " ( " + CRLF 
cQuery += " SELECT  CT1_GRUPO, (SELECT CTR_DESC FROM CTR010 CTR WHERE ARQ.CT1_GRUPO	= CTR_GRUPO ) CRT_DESC," + CRLF 
cQuery += " CT1_CONTA CONTA,CT1_NORMAL NORMAL, CT1_RES CTARES, CT1_DESC"+cMoeda+" DESCCTA, " + CRLF
If lCT1EXDTFIM 
	cQuery += " CT1_DTEXSF CT1DTEXSF, " + CRLF
EndIf
cQuery += " 	CT1_CLASSE TIPOCONTA, CT1_CTASUP CTASUP, " + CRLF


/*/
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ TRATAMENTO PARA O FILTRO DE USUÁRIO NO RELATORIO          ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/
cCampUSU  := ""										// Declara a variavel com os campos do filtro de usuario
If !Empty(cFILUSU)									// Se o filtro de usuario nao estiver vazio
	aStrSTRU := (cString)->(dbStruct())			// Obtem a estrutura da tabela usada na filtragem 
	nStruLen := Len(aStrSTRU)						
	For nStr := 1 to nStruLen                       // Le a estrutura da tabela 
		cCampUSU += aStrSTRU[nStr][1]+","			// Adicionando os campos para filtragem 
	Next
Endif
cQuery += cCampUSU									//Adiciona os campos na query


If lMeses
	For nColunas := 1 to Len(aMeses)
		cQuery += " 	(SELECT SUM(CT7_CREDIT) - SUM(CT7_DEBITO) "+ CRLF
		cQuery += "			 	FROM "+RetSqlName("CT7")+" CT7 "+ CRLF
		cQuery += " 			WHERE CT7.CT7_FILIAL = '"+xFilial("CT7")+"' "+ CRLF
		cQuery += " 			AND ARQ.CT1_CONTA	= CT7_CONTA "+ CRLF
		cQuery += " 			AND CT7_MOEDA = '"+cMoeda+"' " + CRLF
		cQuery += " 			AND CT7_TPSALD = '"+cTpSaldo+"' "  + CRLF
		If lAcum 			// Saldo Acumulado
			cQuery += " 		AND CT7_DATA <= '"+DTOS(aMeses[nColunas][3])+"' "  + CRLF
		Else				// Movimentacao do oeriodo
			cQuery += " 		AND CT7_DATA BETWEEN '"+DTOS(aMeses[nColunas][2])+"' AND '"+DTOS(aMeses[nColunas][3])+"' "  + CRLF
		Endif
		cQuery += " 			AND CT7.D_E_L_E_T_ <> '*') COLUNA"+Str(nColunas,Iif(nColunas>9,2,1))+" "+ CRLF		
		If nColunas <> Len(aMeses)
			cQuery += ", "
		EndIf		
	Next	
EndIf
	
cQuery += " 	FROM "+RetSqlName("CT1")+" ARQ "+ CRLF
cQuery += " 	WHERE ARQ.CT1_FILIAL 	= '"+xFilial("CT1")+"' "+ CRLF 
cQuery += "		AND ARQ.CT1_GRUPO <>' '   "
cQuery += " 	AND ARQ.CT1_GRUPO BETWEEN '"+cGrupoIni+"' AND '"+cGrupoFim+"' "+ CRLF
cQuery += " 	AND ARQ.CT1_CLASSE = '2' "+ CRLF
cQuery += " 	AND ARQ.D_E_L_E_T_ <> '*' "+ CRLF
  
If !lVlrZerado
	If lMeses
		cQuery += " 	AND ( "+ CRLF
		For nColunas := 1 to Len(aMeses)
			cQuery += "	(SELECT ROUND(SUM(CT7_CREDIT),2) - ROUND(SUM(CT7_DEBITO),2) " + CRLF
			cQuery += " FROM "+RetSqlName("CT7")+" CT7 "  + CRLF 
			cQuery += "	WHERE CT7.CT7_FILIAL = '"+xFilial("CT7")+"' "   + CRLF
		   	cQuery += "	AND ARQ.CT1_GRUPO <>' ' 
			cQuery += " AND ARQ.CT1_CONTA	= CT7_CONTA "  + CRLF
			cQuery += " AND CT7_MOEDA = '"+cMoeda+"' "+ CRLF
			cQuery += " AND CT7_TPSALD = '"+cTpSaldo+"' "  + CRLF
			If lAcum 
				cQuery += " AND CT7_DATA <= '"+DTOS(aMeses[nColunas][3])+"' "	 + CRLF		
			Else
				cQuery += " AND CT7_DATA BETWEEN '"+DTOS(aMeses[nColunas][2])+"' AND '"+DTOS(aMeses[nColunas][3])+"' "+ CRLF
			EndIf
			cQuery += " 	AND CT7.D_E_L_E_T_ <> '*') <> 0 " + CRLF
			If nColunas <> Len(aMeses)
				cQuery += " 	OR " + CRLF
			EndIf
		Next
		cQuery += " ) " + CRLF  
		cQuery += "  ) DADOS " + CRLF   
		cQuery += "GROUP BY CT1_GRUPO,CRT_DESC " + CRLF 
	EndIf
Endif
cQuery := ChangeQuery(cQuery)		   

If Select("TRBTMP") > 0
	dbSelectArea("TRBTMP")
	dbCloseArea()
Endif	

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBTMP",.T.,.F.)
If lMeses
	For nColunas := 1 to Len(aMeses)
		TcSetField("TRBTMP","COLUNA"+Str(nColunas,Iif(nColunas>9,2,1)),"N",aTamVlr[1],aTamVlr[2])
	Next                                                                                           
	If lCT1EXDTFIM 
		TcSetField("TRBTMP","CT1DTEXSF","D",8,0)	
	EndIf
EndIf


RestArea(aSaveArea)

Return


/*/ 
+----------------------------------------------------------------------- 
| Funcao | AjustaSX1 | Autor | ASR Sistemas   | Data | 21/06/2017      | 
+----------------------------------------------------------------------- 
| Uso | Ormazabal                                                      | 
+----------------------------------------------------------------------- 
/*/ 

Static Function AjustaSX1()

Local cHelp			:= ""
Local aRegs			:= {}
Local aHelpPor		:= {}
Local aHelpSpa		:= {}
Local aHelpEng		:= {}      
Local lUpDate		:= .T. 
                                         
/*/
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³DATA INICIAL    											³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/
aHelpPor := aHelpSpa := aHelpEng := { "Informe a Data Inicial a partir da qual ",;
                                      "se deseja o relatório. " }    
cHelp := "CTBR0101"
PutSX1Help("P"+cHelp,aHelpPor,aHelpEng,aHelpSpa,lUpDate)
Aadd(aRegs,{"CTBR0001","01","Data Inicial?"       ,"Data Inicial?"       ,"Data Inicial?"       ,"MV_CHA","D",08, 0, 0, "G", ""          ,"MV_PAR01", "", "", "","","","","","","","","","","","","","","","","","","","","","",""   ,"","S",aHelpPor, aHelpEng, aHelpSpa, cHelp})
/*/
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³DATA FINAL      											³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/
aHelpPor := aHelpSpa := aHelpEng := { "Informe a Data Final até a qual se ",;
                                       "deseja o relatório. " }    
cHelp := "CTBR0102"
PutSX1Help("P"+cHelp,aHelpPor,aHelpEng,aHelpSpa,lUpDate)                       
Aadd(aRegs,{"CTBR0001","02","Data Final?"      ,"Data Final?"      ,"Data Final?"      ,"MV_CHB","D",08, 0, 0, "G", ""          ,"MV_PAR02", "", "", "",Dtos(LastDate(dDataBase)),"","","","","","","","","","","","","","","","","","","","",""   ,"","S",aHelpPor, aHelpEng, aHelpSpa, cHelp})
/*/
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³GRUPO CONTABIL   											³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/
aHelpPor := aHelpSpa := aHelpEng := { "Informe o grupo contábil inicial a partir da ",;
                                       " qual deseja imprimir o relatório. " }    
cHelp := "CTBR0103"                                     
PutSX1Help("P"+cHelp,aHelpPor,aHelpEng,aHelpSpa,lUpDate)         
Aadd(aRegs,{"CTBR0001","03","Grupo De?"    ,"Grupo De?"    ,"Grupo De?"    ,"MV_CHC","C",8, 0, 0, "G", ""          ,"MV_PAR03", "", "", "","","","","","","","","","","","","","","","","","","","","","","CTR","","S",aHelpPor, aHelpEng, aHelpSpa, cHelp})

aHelpPor := aHelpSpa := aHelpEng := { "Informe o grupo contábil final ate a qual ",;
                                       " se deseja imprimir o relatório. " }    
cHelp := "CTBR0104"                                     
PutSX1Help("P"+cHelp,aHelpPor,aHelpEng,aHelpSpa,lUpDate)         
Aadd(aRegs,{"CTBR0001","04","Grupo Ate?"    ,"Grupo Ate?"    ,"Grupo Ate?"    ,"MV_CHD","C",8, 0, 0, "G", ""          ,"MV_PAR04", "", "", "","","","","","","","","","","","","","","","","","","","","","","CTR","","S",aHelpPor, aHelpEng, aHelpSpa, cHelp})

/*/
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³MOEDA          											³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/
aHelpPor := aHelpSpa := aHelpEng := { "Informe o código da moeda na qual ",;
                                       "deseja imprimir o relatório. " }    
cHelp := "CTBR0105"                                     
PutSX1Help("P"+cHelp,aHelpPor,aHelpEng,aHelpSpa,lUpDate)         
Aadd(aRegs,{"CTBR0001","05","Moeda?"    ,"Moeda?"    ,"Moeda?"    ,"MV_CHE","C",2, 0, 0, "G", ""          ,"MV_PAR05", "", "", "","","","","","","","","","","","","","","","","","","","","","","CTO","","S",aHelpPor, aHelpEng, aHelpSpa, cHelp})


ValidPerg(aRegs,"CTBR0001",.T.)    

Return
