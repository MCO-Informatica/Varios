#include "Protheus.ch"
#include "TopConn.ch"

User Function DBIMPANP()
Private aArea	:= GetArea()  
Private _nSeqLin	:= 0
Private _nQtdReg	:= 1
Private _cLinAnp	:= ""
Private _aTotais    := {}
Private _aTotProd	:= {}
Private _aTotPad	:= {}
Private _aTPrdCons	:= {}
Private _aArrQtd	:= {}
Private nPos2		:= 0

Processa( {|| DScreen()} , "Aguarde... " )

RestArea(aArea)
Return .T.            
               
Static Function DScreen()
Local nLoop			:= 0
Local nPosPadrao	:= 1
Local aSize			:= MsAdvSize()
Local cTitDialog	:= "Dados ANP"
Local nOpcA			:= 0
Local aBotao		:= {}       
Local oDlgVis, oFldDados,  oFldTot, oFldOpPrd, oFldCrit, oCombo

//³Botões de visualizações das legendas.³
Local oBtnLSA1		:= Nil

//³Botões de pesquisa nos itens das getDados³
Local oPesqSA1		:= Nil

//³Variáveis da aba de ordens de serviço³
Private aColsANP 	:= {}
Private oGDSANP		:= Nil
Private aHeadANP	:= {}  

Private aColsTANP 	:= {}
Private oGDSTANP	:= Nil
Private aHeadTANP	:= {}  

Private aColsPCANP 	:= {}
Private oGDSPCANP	:= Nil
Private aHeadPCANP	:= {}   

Private aColsTeste 	:= {}
Private oGDSTeste	:= Nil
Private aHeadTeste	:= {}   

Private aTotPrd	 	:= {}  
Private aTotPrd2	 	:= {}  
Private cCboPT := ""
Private cCboPT2 := ""

//³cria os aHeaders e preenche todos os aCols³
DadosANP()

//cria os Header e Cols do Primeiro Totalizador ANP
aTotPrd  := getProdAnp()
aTotPrd2 := aTotPrd    
cCboPT   := aTotPrd[1]    
cCboPT2  := aTotPrd2[1]  

DadosTAnp()  
DadosPCAnp()  
DadosTeste()

//³Monta a tela principal³
oDlgVis := MSDIALOG():New(aSize[2],aSize[1],aSize[6]-50,aSize[5]-50,cTitDialog,,,,,,,,,.T.)

oFldDados := TFolder():New(015,005,{"Dados Arquivo ANP", "Totalizadores ANP", "Operações x Produtos", "Crítica Interna"},,oDlgVis,,,,.T.,.T.,(oDlgVis:NCLIENTWIDTH/2)-10,(oDlgVis:NCLIENTHEIGHT/2)-30)
//FOLDER - Dados Arquivo ANP
oGDSANP  := MsNewGetDados():New(000,000,(oFldDados:aDialogs[1]:nClientHeight/2)-20,oFldDados:aDialogs[1]:nClientWidth/2,GD_INSERT+GD_UPDATE+GD_DELETE,,,,{"CODOPERACAO","CODINST1","CODINST2","CODPRODOPER", "QTDEANP","QTDEKG","IDENTERCEIRO","CODPAIS","LI","DI"},,9999,,,,oFldDados:aDialogs[1],@aHeadANP,@aColsANP)

//FOLDER - Totalizadores ANP
oSay	 := TSay():New(015,010,{||'Cód. Produto ANP'},oFldDados:aDialogs[2],,,,,,.T.,,,200,20)
oCombo 	 := TComboBox():New(014,065,{|u|if(PCount()>0,cCboPT:=u,cCboPT)}, aTotPrd,100,100,oFldDados:aDialogs[2],,{||DadosTAnp()},,,,.T.,,,,,,,,,'cCombo')
oGDSTANP := MsNewGetDados():New(030,000,(oFldDados:aDialogs[2]:nClientHeight/2)-20,oFldDados:aDialogs[2]:nClientWidth/2,GD_INSERT+GD_UPDATE+GD_DELETE,,,,{"QtdeLT","QtdeKG"},,9999,,,,oFldDados:aDialogs[2],@aHeadTANP,@aColsTANP)
oGDSTANP:ForceRefresh()

//FOLDER - Produçao x Consumo Produto                                                                                                                        
oSay2	 := TSay():New(015,010,{||'Cód. Produto ANP'},oFldDados:aDialogs[3],,,,,,.T.,,,200,20)
oCombo2	 := TComboBox():New(014,065,{|u|if(PCount()>0,cCboPT2:=u,cCboPT2)}, aTotPrd2,100,100,oFldDados:aDialogs[3],,{||DadosFld3()},,,,.T.,,,,,,,,,'cCombo')
oGDSPCANP := MsNewGetDados():New(030,005,(oFldDados:aDialogs[2]:nClientHeight/2)-20,(oFldDados:aDialogs[3]:nClientWidth / 4) - 20,,,,,,,9999,,,,oFldDados:aDialogs[3],@aHeadPCANP,@aColsPCANP)
oGDSTeste := MsNewGetDados():New(030,(oFldDados:aDialogs[3]:nClientWidth / 4) - 5,(oFldDados:aDialogs[2]:nClientHeight/2)-20,(oFldDados:aDialogs[3]:nClientWidth / 2) - 5,,,,,,,9999,,,,oFldDados:aDialogs[3],@aHeadTeste,@aColsTeste)
oGDSTeste:ForceRefresh()
oGDSPCANP:ForceRefresh()

//FOLDER - Critica Interna      
oTButton1 := TButton():New( 010, (oFldDados:aDialogs[4]:nClientWidth/4)-50, "Gerar Criticas Prévia",oFldDados:aDialogs[4],{|| DBLDCRIT()}, 100,30,,,.F.,.T.,.F.,,.F.,,,.F. )   
                                                                                                                                   
ACTIVATE MSDIALOG oDlgVis CENTERED ON INIT EnchoiceBar(oDlgVis,{||nOpcA:=1, oDlgVis:End()},{||nOpcA:=0,oDlgVis:End()},,/*aBotao*/)    

If nOpcA==1
	//³ Colocar aqui qualquer processamento posterior à confirmação da tela ³
Endif
                                                                                                        
RestArea(aArea)
Return .T.   
         
Static Function DadosFld3()
	DadosPCAnp()
	DadosTeste()
Return .T.

Static Function DadosTANP()
         
aColsTANP := {}    

       
If Len(aHeadTAnp) == 0
	Aadd(aHeadTANP,{"Totalizador"	, "Totalizador"		,	"@!"				   , 100, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
	Aadd(aHeadTANP,{"Quantidade LT"	, "QtdeLT"			,	"@E 999,999,999,999.99", 15 , 2, "", "", "N", "", "",	"", "", "", "R", "", "", ""})
	Aadd(aHeadTANP,{"Quantidade KG"	, "QtdeKG"			,	"@E 999,999,999,999.99", 15 , 2, "", "", "N", "", "",	"", "", "", "R", "", "", ""})	
EndIf                                                                

For nX := 1 To Len(_aTotais)
	If AllTrim(_aTotais[nX][1]) == AllTrim(cCboPT)
		Aadd(aColsTANP, {_aTotais[nX][3], _aTotais[nX][4], _aTotais[nX][5], .F.})     

	EndIf
Next                               

If Len(aColsTANP) > 0 .AND. Type("oGDSTANP")=="O"
	oGDSTANP:aCols := aColsTANP     
	oGDSTANP:ForceRefresh()
EndIf

Return .T.      

Static Function DadosTeste()
Local nTotProd := 0, nTotCon := 0
aColsTeste := {}    
    
If Len(aHeadTeste) == 0
	Aadd(aHeadTeste,{"Produto"	, "codprod"		,	"@!"				   , 30, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
	Aadd(aHeadTeste,{"Grupo"	, "grpprod"		,	"@!"				   , 8, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
	Aadd(aHeadTeste,{"Producao"	, "QtdeLT"			,	"@E 999,999,999,999.99", 15 , 2, "", "", "N", "", "",	"", "", "", "R", "", "", ""})
	Aadd(aHeadTeste,{"Consumo"	, "QtdeKG"	,	"@E 999,999,999,999.99", 15 , 2, "", "", "N", "", "",	"", "", "", "R", "", "", ""})	
EndIf                                                                

For nX := 1 To Len(_aTPrdCons)
	If AllTrim(_aTPrdCons[nX][2]) == AllTrim(cCboPT2)
		Aadd(aColsTeste, {_aTPrdCons[nX][1], _aTPrdCons[nX][5],  _aTPrdCons[nX][3], _aTPrdCons[nX][4], .F.})  
		nTotProd += _aTPrdCons[nX][3]
		nTotCon  += _aTPrdCons[nX][4]   
	EndIf
Next               
                                                                                                      
Aadd(aColsTeste, {"", space(8), 0, 0, .F. })                                                   
Aadd(aColsTeste, {"TOTAL PRODUCAO/CONSUMO: " , space(8), nTotProd, nTotCon, .F. })                                                   
Aadd(aColsTeste, {"TOTAL GERAL ----------------->:", space(8), nTotProd - nTotCon,0, .F. })        

If Len(aColsTeste) > 0 .AND. Type("oGDSTeste")=="O"
	oGDSTeste:aCols := aColsTeste     
	oGDSTeste:ForceRefresh()
EndIf


Return .T.   

Static Function DadosPCAnp() 
Local nTotProd := 0, nTotCon := 0
aColsPCANP := {}       

If Len(aHeadPCAnp) == 0
	Aadd(aHeadPCANP,{"Produto"	,"CODPRDPC"	,"@!"				    , 30, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
	Aadd(aHeadPCANP,{"Grupo"	,"grpprod"	,	"@!"		   		, 8, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
	Aadd(aHeadPCANP,{"Producao"	,"PRODUCAO"	,"@E 999,999,999,999.99", 15, 2, "", "", "N", "", "",	"", "", "", "R", "", "", ""})
	Aadd(aHeadPCANP,{"Consumo"	,"CONSUMO"	,"@E 999,999,999,999.99", 15, 2, "", "", "N", "", "",	"", "", "", "R", "", "", ""})	
EndIf    

For nX := 1 To Len(_aTPrdCons)
	If AllTrim(_aTPrdCons[nX][2]) == AllTrim(cCboPT2)
		Aadd(aColsPCANP, {_aTPrdCons[nX][1], _aTPrdCons[nX][5],  _aTPrdCons[nX][3], _aTPrdCons[nX][4], .F.})  
		nTotProd += _aTPrdCons[nX][3]
		nTotCon  += _aTPrdCons[nX][4]   
	EndIf
Next                                                                                                                     
Aadd(aColsPCANP, {"", space(8), 0, 0, .F. })                                                   
Aadd(aColsPCANP, {"TOTAL PRODUCAO/CONSUMO: ", space(8),  nTotProd, nTotCon, .F. })                                                   
Aadd(aColsPCANP, {"TOTAL GERAL ----------------->:", space(8), nTotProd - nTotCon,0, .F. })           

If Len(aColsPCANP) > 0 .AND. Type("oGDSPCANP")=="O"
	oGDSPCANP:aCols := aColsPCANP     
	oGDSPCANP:ForceRefresh()
EndIf

Return .T.                

Static Function DadosANP()
Aadd(aHeadANP,{	"Linha"						, "SEQUENCIAL"			,	"@!"					, 10, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
Aadd(aHeadANP,{	"Agente Reg. Informante"	, "AGENTEINFORMANTE"	,	"@!"					, 10, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
Aadd(aHeadANP,{	"Mes Referencia"			, "MESREFERENCIA"		,	"@!"					,  6, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
Aadd(aHeadANP,{	"Cod.Operacao"				, "CODOPERACAO"			,	"@!"					,  7, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
Aadd(aHeadANP,{	"Cod.Instalacao 1"			, "CODINST1"			,	"@!"					,  7, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
Aadd(aHeadANP,{	"Cod.Instalacao 2"			, "CODINST2"			,	"@!"					,  7, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
Aadd(aHeadANP,{	"Cod.Produto"				, "CODPRODOPER"			,	"@!"					,  9, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
Aadd(aHeadANP,{	"Qtde.Unit.ANP"				, "QTDEANP"				,	"@E 999,999,999,999.99"	, 15, 2, "", "", "N", "", "",	"", "", "", "R", "", "", ""})
Aadd(aHeadANP,{	"Qtde.Unit.KG"				, "QTDEKG"				,	"@E 999,999,999,999.99"	, 15, 2, "", "", "N", "", "",	"", "", "", "R", "", "", ""})
Aadd(aHeadANP,{	"Cod.Modal"					, "CODMODAL"			,	"@!"					,  1, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
Aadd(aHeadANP,{	"Cod.Veiculo"				, "CODVEICULO"			,	"@!"					,  7, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
Aadd(aHeadANP,{	"Identificacao Terceiro"	, "IDENTERCEIRO"		,	"@!"					, 14, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
Aadd(aHeadANP,{	"Cod.Municipio"				, "CODMUNICIPIO"		,	"@!"					,  7, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
Aadd(aHeadANP,{	"Cod.Ativ.Economica"		, "CODATIVECON"			,	"@!"					,  5, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
Aadd(aHeadANP,{	"Cod.Pais"					, "CODPAIS"				,	"@!"					,  4, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
Aadd(aHeadANP,{	"Lic.Importacao"			, "LI"					,	"@!"					, 10, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
Aadd(aHeadANP,{	"Doc.Importacao"			, "DI"					,	"@!"					, 10, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
Aadd(aHeadANP,{	"Num.NF"					, "NUMNF"				,	"@!"					,  7, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
Aadd(aHeadANP,{	"Ser.NF"					, "SERNF"				,	"@!"					,  2, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
Aadd(aHeadANP,{	"Data NF"					, "DATANF"				,	"@!"					,  8, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
Aadd(aHeadANP,{	"Cod.Serv.Acordado"			, "CODSERVACORD"		,	"@!"					,  1, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
Aadd(aHeadANP,{	"Cod.Carac.Fis-Quim"		, "CODCARACFISQUIM"		,	"@!"					,  3, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
Aadd(aHeadANP,{	"Cod.Metodo"				, "CODMETODO"			,	"@!"					,  3, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
Aadd(aHeadANP,{	"Modalidade Frete"			, "MODFRETE"			,	"@!"					,  2, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
Aadd(aHeadANP,{	"Valor Caracteristica"		, "VLRCARAC"			,	"@!"					, 10, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
Aadd(aHeadANP,{	"Cod.Prod.Resultante"		, "CODPRDRESULT"		,	"@!"					,  9, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
Aadd(aHeadANP,{	"Valor Unitario"			, "VLRUNIT"				,	"@!"					,  7, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
Aadd(aHeadANP,{	"Recipiente GLP"			, "RCPGLP"				,	"@!"					,  2, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""})
Aadd(aHeadANP,{	"Chave NFe"					, "CHVNFE"				,	"@!"					, 44, 0, "", "", "C", "", "",	"", "", "", "R", "", "", ""}) 

cQry := "SELECT * FROM ( SELECT 	"
cQry += "'C' AS ESPECIE, 			"
cQry += "SF2.F2_TIPO AS TIPO, 		"                                                            
cQry += "SF2.F2_CLIENTE AS CLIFOR, 	"
cQry += "SF2.F2_LOJA AS LOJA, 		"
cQry += "SB5.B5_CODANP AS PRODUTO, 	"
cQry += "SUM(SD2.D2_QUANT) AS QTDKG,"
cQry += "SUM(SD2.D2_QTSEGUM) AS QTDLT,"
cQry += "SB1.B1_CONV AS DENSIDADE,  "
cQry += "SF2.F2_EMISSAO AS EMISSAO, "
cQry += "SF2.F2_CHVNFE AS CHAVENFE, "
cQry += "SF2.F2_DOC AS DOC, 	"
cQry += "SF2.F2_SERIE AS SERIE 	"
cQry += "FROM 					"
cQry += RetSQLName("SF2")+" SF2 "
cQry += "JOIN "+RetSQLName("SD2")+" SD2 ON  SF2.F2_DOC = SD2.D2_DOC "
cQry += "                				AND SF2.F2_SERIE = SD2.D2_SERIE "
cQry += "                				AND SF2.F2_CLIENTE = SD2.D2_CLIENTE "
cQry += "                				AND SF2.F2_LOJA = SD2.D2_LOJA "
cQry += "                				AND SD2.D_E_L_E_T_ <> '*' "
cQry += "JOIN "+RetSQLName("SB1")+" SB1 ON  SD2.D2_COD = SB1.B1_COD "
cQry += "                				AND SB1.D_E_L_E_T_ <> '*' "
cQry += "JOIN "+RetSQLName("SB5")+" SB5 ON  SB1.B1_COD = SB5.B5_COD "
cQry += "                				AND SB5.D_E_L_E_T_ <> '*' "
cQry += "                				AND SB5.B5_PRODANP = 'S' "
cQry += "JOIN "+RetSQLName("SF4")+" SF4 ON  SF4.F4_CODIGO = SD2.D2_TES "
cQry += "                				AND SF4.D_E_L_E_T_ <> '*' "
cQry += "                				AND SF4.F4_VQENTAN <> 'N' "
cQry += "WHERE "                                           
cQry += "SF2.D_E_L_E_T_ <> '*' "      
cQry += "AND SF2.F2_FILIAL = '" +xFilial("SF2")+ "' "
cQry += "AND SD2.D2_FILIAL = '" +xFilial("SD2")+ "' "
cQry += "AND SB1.B1_FILIAL = '" +xFilial("SB1")+ "' "
cQry += "AND SB5.B5_FILIAL = '" +xFilial("SB5")+ "' "
cQry += "AND SF4.F4_FILIAL = '" +xFilial("SF4")+ "' "
cQry += "AND SF2.F2_TIPO NOT IN ('C', 'I', 'P') "
cQry += "AND SF2.F2_EMISSAO BETWEEN '20160401' AND '20160430' "
cQry += "GROUP BY "
cQry += "SF2.F2_CLIENTE, "
cQry += "SF2.F2_LOJA, "
cQry += "SF2.F2_TIPO, "
cQry += "SB5.B5_CODANP, "
cQry += "SB1.B1_CONV, "                                                                   	
cQry += "SF2.F2_EMISSAO, "
cQry += "SF2.F2_CHVNFE, SF2.F2_DOC, SF2.F2_SERIE "

cQry += "UNION ALL "

cQry += "SELECT "
cQry += "'B' AS ESPECIE, "
cQry += "SF1.F1_TIPO AS TIPO, "
cQry += "SF1.F1_FORNECE AS CLIFOR, "
cQry += "SF1.F1_LOJA AS LOJA, "
cQry += "SB5.B5_CODANP AS PRODUTO, "
cQry += "SUM(SD1.D1_QUANT) AS QTDKG, "
cQry += "SUM(SD1.D1_QTSEGUM) AS QTDLT, "
cQry += "SB1.B1_CONV AS DENSIDADE, "
cQry += "SF1.F1_DTDIGIT AS EMISSAO, "
cQry += "SF1.F1_CHVNFE AS CHAVENFE, "
cQry += "SF1.F1_DOC AS DOC, "
cQry += "SF1.F1_SERIE AS SERIE "
cQry += "FROM "
cQry += RetSQLName("SF1")+" SF1 "
cQry += "JOIN "+RetSQLName("SD1")+" SD1 ON  SF1.F1_DOC = SD1.D1_DOC "
cQry += "                				AND SF1.F1_SERIE = SD1.D1_SERIE "
cQry += "                				AND SF1.F1_FORNECE = SD1.D1_FORNECE "
cQry += "                				AND SF1.F1_LOJA = SD1.D1_LOJA "
cQry += "                				AND SD1.D_E_L_E_T_ <> '*' "
cQry += "JOIN "+RetSQLName("SB1")+" SB1 ON  SD1.D1_COD = SB1.B1_COD "
cQry += "                				AND SB1.D_E_L_E_T_ <> '*' "
cQry += "JOIN "+RetSQLName("SB5")+" SB5 ON  SB1.B1_COD = SB5.B5_COD "
cQry += "                				AND SB5.D_E_L_E_T_ <> '*' "
cQry += "                				AND SB5.B5_PRODANP = 'S' "
cQry += "JOIN "+RetSQLName("SF4")+" SF4 ON  SF4.F4_CODIGO = SD1.D1_TES "
cQry += "                				AND SF4.D_E_L_E_T_ <> '*' "
cQry += "                				AND SF4.F4_VQENTAN <> 'N' "
cQry += "WHERE "
cQry += "SF1.D_E_L_E_T_ <> '*' "     
cQry += "AND SF1.F1_FILIAL = '" +xFilial("SF1")+ "' "
cQry += "AND SD1.D1_FILIAL = '" +xFilial("SD1")+ "' "
cQry += "AND SB1.B1_FILIAL = '" +xFilial("SB1")+ "' "
cQry += "AND SB5.B5_FILIAL = '" +xFilial("SB5")+ "' "
cQry += "AND SF4.F4_FILIAL = '" +xFilial("SF4")+ "' "
cQry += "AND SF1.F1_TIPO NOT IN ('C', 'I', 'P') "
cQry += "AND SF1.F1_DTDIGIT BETWEEN '20160401' AND '20160430' "
cQry += "GROUP BY "
cQry += "SF1.F1_FORNECE, "
cQry += "SF1.F1_LOJA, "
cQry += "SF1.F1_TIPO, "
cQry += "SB5.B5_CODANP, "
cQry += "SB1.B1_CONV, "
cQry += "SF1.F1_DTDIGIT, "
cQry += "SF1.F1_CHVNFE, SF1.F1_DOC , SF1.F1_SERIE"

cQry += "UNION ALL "

cQry += "SELECT "
cQry += "'A' AS ESPECIE, "
cQry += "'' AS TIPO, "
cQry += "'' AS CLIFOR, "
cQry += "'' AS LOJA, "
cQry += "SB5.B5_CODANP AS PRODUTO, "
cQry += "SUM(SB9.B9_QINI) AS QTDKG, "
cQry += "SUM(SB9.B9_QISEGUM) AS QTDLT, "
cQry += "SB1.B1_CONV AS DENSIDADE, "
cQry += "'20160401' AS EMISSAO, "
cQry += "RPAD('0', 44, '0') AS CHAVENFE, "
cQry += "RPAD('0', 9, '0') AS DOC, "
cQry += "RPAD('0', 3, '0') AS SERIE "
cQry += "FROM "
cQry += RetSQLName("SB9")+" SB9 "
cQry += "JOIN "+RetSQLName("SB1")+" SB1 ON  SB9.B9_COD = SB1.B1_COD "
cQry += "                				AND SB1.D_E_L_E_T_ <> '*' "
cQry += "JOIN "+RetSQLName("SB5")+" SB5 ON  SB1.B1_COD = SB5.B5_COD "
cQry += "                				AND SB5.D_E_L_E_T_ <> '*' "
cQry += "                				AND SB5.B5_PRODANP = 'S' "
cQry += "WHERE "
cQry += "SB9.D_E_L_E_T_ <> '*' "  
cQry += "AND SB9.B9_FILIAL = '" +xFilial("SB9")+ "' "
cQry += "AND SB1.B1_FILIAL = '" +xFilial("SB1")+ "' "
cQry += "AND SB5.B5_FILIAL = '" +xFilial("SB5")+ "' "
cQry += "AND SB9.B9_QINI > 0 "
cQry += "AND SB9.B9_DATA = '20160331' "
cQry += "GROUP BY "
cQry += "SB5.B5_CODANP, "
cQry += "SB1.B1_CONV, "
cQry += "SB9.B9_DATA "

cQry += "UNION ALL "

cQry += "SELECT "
cQry += "'D' AS ESPECIE, "
cQry += "'' AS TIPO, "
cQry += "'' AS CLIFOR, "
cQry += "'' AS LOJA, "
cQry += "SB5.B5_CODANP AS PRODUTO, "
cQry += "SUM(SB9.B9_QINI) AS QTDKG, "
cQry += "SUM(SB9.B9_QISEGUM) AS QTDLT, "
cQry += "SB1.B1_CONV AS DENSIDADE, "
cQry += "SB9.B9_DATA AS EMISSAO, "
cQry += "RPAD('0', 44, '0') AS CHAVENFE, "
cQry += "RPAD('0', 9, '0') AS DOC, "
cQry += "RPAD('0', 3, '0') AS SERIE "
cQry += "FROM " + RetSQLName("SB9") + " SB9 "
cQry += "JOIN " + RetSQLName("SB1") + " SB1 ON  SB9.B9_COD = SB1.B1_COD "
cQry += "                				AND SB1.D_E_L_E_T_ <> '*' "
cQry += "JOIN "+RetSQLName("SB5")+" SB5 ON  SB1.B1_COD = SB5.B5_COD "
cQry += "                				AND SB5.D_E_L_E_T_ <> '*' "
cQry += "                				AND SB5.B5_PRODANP = 'S' "
cQry += "WHERE "
cQry += "SB9.D_E_L_E_T_ <> '*' "   
cQry += "AND SB9.B9_FILIAL = '" +xFilial("SB9")+ "' "
cQry += "AND SB1.B1_FILIAL = '" +xFilial("SB1")+ "' "
cQry += "AND SB5.B5_FILIAL = '" +xFilial("SB5")+ "' "
cQry += "AND SB9.B9_QINI > 0 "
cQry += "AND SB9.B9_DATA = '20160430' "
cQry += "GROUP BY "
cQry += "SB5.B5_CODANP, "
cQry += "SB1.B1_CONV, "
cQry += "SB9.B9_DATA "
cQry += "ORDER BY "
cQry += "ESPECIE, "
cQry += "EMISSAO ) WHERE PRODUTO = '310101001' OR PRODUTO = '330101004'" 

cQry := ChangeQuery(cQry)

If Select("QRY") > 0
	QRY->(DbCloseArea())
EndIf

TcQuery cQry New Alias "QRY"      

DbSelectArea("QRY")
nTotalReg := Contar("QRY", "!Eof()")
QRY->(DbGoTop())    

ProcRegua(nTotalReg)     

DbSelectArea("SD2");DbSetOrder(3)
DbSelectArea("SD1");DbSetOrder(3)

While QRY->(!Eof())   
	IncProc("Preenchendo  " + cValToChar(_nSeqLin) + " de " + cValToChar(nTotalReg))
	//Dados dos clientes/fornecedores
	If _nSeqLin == 0   
		_cLinAnp += STRZERO(_nSeqLin,10)                            											//1. CONTADOR SEQUENCIAL  					/10
		_cLinAnp += "1043588060" 																				//2. AGENTE REGULADO INFORMANTE  			/10
		_cLinAnp += "072017"																					//3. MÊS DE REFERÊNCIA (MMAAAA)             /06
		_cLinAnp += STRZERO(_nQtdReg, 7) 
		_nSeqLin += 1
	EndIf
	
	If AllTrim(QRY->ESPECIE) == "C"
		//
		If !AllTrim(QRY->TIPO) $ "D/B"
			//
			DbSelectArea("SA1")
			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+QRY->CLIFOR+QRY->LOJA))
			//
			_cInst2 := SA1->A1_INSTANP
			_cInst1 := If(Empty(_cInst2),"1012002","1012001")
			_cCnpj  := If(Empty(_cInst2),AllTrim(SA1->A1_CGC),"")
			_cAtiv  := If(Empty(_cInst2),"46842","")
			_cLocal := If(Empty(_cInst2),Posicione("CC2",1,xFilial("CC2")+SA1->(A1_EST+A1_COD_MUN),"CC2_CODANP"),"")
			//
		Else
			//
			DbSelectArea("SA2")
			SA2->(DbSetOrder(1))
			SA2->(DbSeek(xFilial("SA2")+QRY->CLIFOR+QRY->LOJA))
			//
			_cInst2 := SA2->A2_T_INST
			_cInst1 := If(Empty(_cInst2),"1012005","1012004")
			_cCnpj  := If(Empty(_cInst2),AllTrim(SA2->A2_CGC),"")
			_cAtiv  := If(Empty(_cInst2),"46842","")
			_cLocal := If(Empty(_cInst2),Posicione("CC2",1,xFilial("CC2")+SA2->(A2_EST+A2_COD_MUN),"CC2_CODANP"),"")   
		EndIf
	ElseIf AllTrim(QRY->ESPECIE) == "B"
		If AllTrim(QRY->TIPO) $ "D/B"
			DbSelectArea("SA1")
			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+QRY->CLIFOR+QRY->LOJA))
			_cInst2 := SA1->A1_INSTANP
			_cInst1 := If(Empty(_cInst2),"1011005","1011004")
			_cCnpj  := If(Empty(_cInst2),AllTrim(SA1->A1_CGC),"")
			_cAtiv  := If(Empty(_cInst2),"46842","")
			_cLocal := If(Empty(_cInst2),Posicione("CC2",1,xFilial("CC2")+SA1->(A1_EST+A1_COD_MUN),"CC2_CODANP"),"")
		Else
			DbSelectArea("SA2")
			SA2->(DbSetOrder(1))
			SA2->(DbSeek(xFilial("SA2")+QRY->CLIFOR+QRY->LOJA))
			_cInst2 := SA2->A2_T_INST	
			If SA2->A2_EST = "EX"
				_cInst1 := "2011001"
			Else
				_cInst1 := If(Empty(_cInst2),"1011002","1011001")
			EndIf
			_cCnpj  := If(Empty(_cInst2),AllTrim(SA2->A2_CGC),"")
			_cAtiv  := If(Empty(_cInst2),"46842","")
			_cLocal := If(Empty(_cInst2),Posicione("CC2",1,xFilial("CC2")+SA2->(A2_EST+A2_COD_MUN),"CC2_CODANP"),"")	
		EndIf
	ElseIf AllTrim(QRY->ESPECIE) == "A"
		_cInst2 := "0"
		_cInst1 := "3010003"
		_cCnpj  := "00000000000000"
		_cAtiv  := "0"
		_cLocal := "0"
	ElseIf AllTrim(QRY->ESPECIE) == "D"
		_cInst2 := "0"
		_cInst1 := "3020003"
		_cCnpj  := "00000000000000"
		_cAtiv  := "0"
		_cLocal := "0"
	EndIf     	
	If SubStr(_cInst1,1,1) $ '1/2'          
		nPos2 := Ascan(_aArrQtd, {|x| x[1]+x[2] == QRY->PRODUTO+STRZERO(QRY->DENSIDADE*1000,7)  } )
		If nPos2 == 0
		     aadd(_aArrQtd, {QRY->PRODUTO,STRZERO(QRY->DENSIDADE*1000,7), 0, 0, 0, 0} ) //1=codigo produto anp / 2=densidade / 3=qtd lt arred cim / 4= qtd lt arred aba / 5 = qtd kg arred cim / 6 qtd arred kg aba
		EndIf
		    
		nPos2 := Ascan(_aArrQtd, {|x| x[1]+x[2] == QRY->PRODUTO+STRZERO(QRY->DENSIDADE*1000,7)  } )
		If QRY->QTDLT < 1
			_nQtdLt := 1       
			_aArrQtd[nPos2][3] += (QRY->QTDLT - 1 ) * -1
		Else                                                                                                                        	
			If(Round(QRY->QTDLT, 0) < QRY->QTDLT) 
				_nQtdLt := Ceiling(QRY->QTDLT)
				_aArrQtd[nPos2][4] += (QRY->QTDLT-Round(QRY->QTDLT, 0))
			Else    
				_nQtdLt := Round(QRY->QTDLT, 0)		
				_aArrQtd[nPos2][3] += ((QRY->QTDLT-Round(QRY->QTDLT, 0)) * -1)
			EndIf
		EndIf    		
		If QRY->QTDKG < 1
			_nQtdKg := 1       
			_aArrQtd[nPos2][5] += (1 - QRY->QTDKG)
		Else                                                                                                                        	
			If(QRY->QTDKG-Round(QRY->QTDKG, 0)) >= 0.5		
				_nQtdKg := Ceiling(QRY->QTDKG)
				_aArrQtd[nPos2][5] += (1 - (QRY->QTDKG-Round(QRY->QTDKG, 0)))
			Else
				_nQtdKg := Round(QRY->QTDKG, 0)		
				_aArrQtd[nPos2][6] += ((QRY->QTDKG-Round(QRY->QTDKG, 0)) * -1)
			EndIf
		EndIf                    
	EndIf
		
	If QRY->QTDLT < 1
		_nQtdLt := 1       
	Else                                                                                                                        	
		_nQtdLt := If(QRY->QTDLT-Round(QRY->QTDLT, 0) >= 0.5, Ceiling(QRY->QTDLT), Round(QRY->QTDLT, 0))		
	EndIf                                                                                                
	
	If QRY->QTDKG < 1	
		_nQtdKg := 1
	Else 
		_nQtdKg := If(QRY->QTDKG-Round(QRY->QTDKG, 0) >= 0.5, Ceiling(QRY->QTDKG), Round(QRY->QTDKG, 0))
	EndIf  
    /*	_nQtdLt := If(QRY->QTDLT-Round(QRY->QTDLT, 0) >= 0.5, Ceiling(QRY->QTDLT), Round(QRY->QTDLT, 0))  
	_nQtdKg := If(QRY->QTDKG-Round(QRY->QTDKG, 0) >= 0.5, Ceiling(QRY->QTDKG), Round(QRY->QTDKG, 0)) */	             

	Aadd(aColsANP, {STRZERO(_nSeqLin,10),;
				 	"1043588060" 			,;
	 "072017"								,;											
	 IIF(EMPTY(_cInst1),STRZERO(0,7),STRZERO(VAL(_cInst1),7))							,;
	 "1032993"						 			   										,;
	 IIF(EMPTY(_cInst2),STRZERO(0,7),STRZERO(VAL(_cInst2),7))							,;
	 AllTrim(QRY->PRODUTO)															   	,;
	 _nQtdLt/*STRZERO(_nQtdLt,15)*/		   												,;
	 _nQtdKg/*STRZERO(_nQtdKg,15)*/														,;
	 "1"					 						   									,;
	 STRZERO(0,7)			 															,;
	 IIF(EMPTY(_cCnpj) ,STRZERO(0, 14),STRZERO(VAL(_cCnpj),14))				  			,;
	 IIF(EMPTY(_cLocal),STRZERO(0, 7),STRZERO(VAL(_cLocal),7))				   			,;
	 IIF(EMPTY(_cAtiv) ,STRZERO(0, 5),STRZERO(VAL(_cAtiv), 5))	   						,;
	 STRZERO(0, 4)				 														,;
	 STRZERO(0, 10) 																	,;
	 STRZERO(0, 10) 									   								,;
	 STRZERO(0, 7)									   									,;
	 STRZERO(0, 2)									   									,;
	 Substr(DtoC(StoD(QRY->EMISSAO)),1,2)+Substr(DtoC(StoD(QRY->EMISSAO)),4,2)+Substr(DtoC(StoD(QRY->EMISSAO)),7,4),;
	 STRZERO(0, 1)									  				,;
	 STRZERO(0, 3)									   				,;
	 STRZERO(0, 3)									   				,;
	 STRZERO(0, 2)									   				,;
	 STRZERO(0, 10)									   				,;
	 STRZERO(0, 9)													,;
	 STRZERO(QRY->DENSIDADE*1000,7)									,;
	 STRZERO(0, 2)													,;
	 IIF(EMPTY(AllTrim(QRY->CHAVENFE)),STRZERO(0,44),AllTrim(QRY->CHAVENFE)),;
	 .F.})	  

	_nSeqLin +=  1                  
		
	nPos := Ascan(_aTotProd, { |x| Alltrim(x[1]) == AllTrim(QRY->PRODUTO)})      	
	If nPos == 0  
		Aadd(_aTotProd,{AllTrim(QRY->PRODUTO), 0, 0 } )
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "1011998", 	"TOTAL DE ENTRADAS COMERCIAIS NACIONAIS"			, 0 ,0 }) 
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "1012998",	"TOTAL DE SAÍDAS COMERCIAIS NACIONAIS"				, 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "1021998",	"TOTAL DE ENTRADAS OPERACIONAIS"					, 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "1022998",	"TOTAL DE SAÍDAS OPERACIONAIS"						, 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "1041998",	"TOTAL DE ENTRADAS DE PROCESSAMENTO EXTERNO"		, 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "1042998",	"TOTAL DE SAÍDAS PARA PROCESSAMENTO EXTERNO"		, 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "1051998",	"TOTAL DE ENTRADA DE TRANSFERÊNCIA ENTRE INSTALAÇÕES" , 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "1052998",	"TOTAL DE SAÍDA DE TRANSFERÊNCIA ENTRE INSTALAÇÕES"	  , 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "1061998",	"TOTAL DE ENTRADAS POR TRANSFERÊNCIA ENTRE PRODUTOS"  , 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "1062998",	"TOTAL DE SAÍDAS POR TRANSFERÊNCIA ENTRE PRODUTOS"	  , 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "1071998",	"TOTAL DE ENTRADAS EM TRANSPORTE DE DUTOS"			, 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "1072998",	"TOTAL DE SAÍDAS EM TRANSPORTE DE DUTOS"			, 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "2011998",	"TOTAL DE ENTRADAS COMERCIAIS INTERNACIONAIS"		, 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "2012998",	"TOTAL DE SAÍDAS COMERCIAIS INTERNACIONAIS"			, 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "2021998",	"TOTAL DE ENTRADAS OPERACIONAIS INTERNACIONAIS"		, 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "2022998",	"TOTAL DE SAÍDAS OPERACIONAIS INTERNACIONAIS"		, 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "4011998",	"TOTAL GERAL DE ENTRADAS"							, 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "4012998",	"TOTAL GERAL DE SAÍDAS"								, 0 ,0 })
	EndIf               
                                            
	If SubStr(_cInst1,1,1) <> '3'
		nPPrdOp := Ascan(_aTotais, {|x| x[1]+SubStr(x[2],1,4) == QRY->PRODUTO+SubStr(AllTrim(_cInst1),1,4)  } )
		If _aTotais[nPPrdOp][1] == QRY->PRODUTO .AND. SubStr(_aTotais[nPPrdOp][2],1,4) == SubStr(AllTrim(_cInst1),1,4)
			_aTotais[nPPrdOp][4] += _nQtdLt   
			_aTotais[nPPrdOp][5] += _nQtdKg                  		
			If SubStr(AllTrim(_cInst1),1,4) $ "1011/1021/1041/1051/1061/1071/2011/2021"
				nPPrdTOp := Ascan(_aTotais, {|x| AllTrim(x[1]+x[2]) == AllTrim(QRY->PRODUTO+"4011998")  } )
			 	_aTotais[nPPrdTOp][4] += _nQtdLt   
 				_aTotais[nPPrdTOp][5] += _nQtdKg                  		
			ElseIf SubStr(AllTrim(_cInst1),1,4) $ "1012/1022/1042/1052/1062/1072/2012/2022"  								
				nPPrdTOp := Ascan(_aTotais, {|x| AllTrim(x[1]+x[2]) == AllTrim(QRY->PRODUTO+"4012998")  } )
			 	_aTotais[nPPrdTOp][4] += _nQtdLt   
 				_aTotais[nPPrdTOp][5] += _nQtdKg                  		
			EndIf
		EndIf		
	EndIf		
		
	If SD2->(DbSeek(xFilial("SD2")+QRY->DOC+QRY->SERIE))   
	   	While( SD2->(!EoF()) .AND. SD2->D2_DOC == QRY->DOC .AND. SD2->D2_SERIE == QRY->SERIE)
	   			DbSelectArea("SB5"); DbSetOrder(1)       
	   			If(SB5->(DbSeek(xFilial("SB5")+SD2->D2_COD))) 
	   				If (!EMPTY(SB5->B5_CODANP) .AND. ALLTRIM(SB5->B5_CODANP) == ALLTRIM(QRY->PRODUTO))     
	   				      If( ASCAN(_aTPrdCons, {|X| X[1]+X[2] == ALLTRIM(SB5->B5_COD)+ALLTRIM(SB5->B5_CODANP)}) == 0 )
	   				      	AADD(_aTPrdCons, {ALLTRIM(SB5->B5_COD), ALLTRIM(SB5->B5_CODANP), MOVSD3(SB5->B5_COD, "PRO", "RESUMIDO"), MOVSD3(SB5->B5_COD, "CON", "RESUMIDO"), SD2->D2_GRUPO }) 
	   				      EndIf
	   				EndIf
	   			EndIf
	   	     SD2->(DbSkip())
	   	 EndDo
	EndIf      
	QRY->(DbSkip())               
EndDo    
  
ASORT(_aTotProd ,,, { |x, y| x[1] < y[1] } )  
ASORT(_aTPrdCons,,, { | x,y | x[2] < y[2]} )  
ASORT(_aArrQtd  ,,, { |x, y| x[1] < y[1] } )  

For nX := 1 To Len(_aTotProd)
	For nY := 1 To Len(_aTPrdCons)
		If _aTPrdCons[nY][2] == _aTotProd[nX][1]
			_aTotProd[nX][2] += _aTPrdCons[nY][3]
			_aTotProd[nX][3] += _aTPrdCons[nY][4]
		EndIf
	Next
Next          
              
//For nX := 1 To Len(_aTotais)
//	Aadd(aColsANP, {STRZERO(_nSeqLin,10),;
//				 	"1043588060" 			,;
//	 "072017"								,;										
//	 _aTotais[nX][2],;
//	 "1032993"		,;				 			   											
//	 STRZERO(0,7)	,;		
//	 AllTrim(_aTotais[nX][1]),;
//	 _aTotais[nX][4]/*STRZERO(_aTotais[nX][4],15)*/	,;
//	 _aTotais[nX][5]/*STRZERO(_aTotais[nX][5],15)*/	 ,;
//	 "0"			,;
//	 STRZERO(0,7),;
//	 STRZERO(0, 14),;
//	 STRZERO(0, 7),;
//	 STRZERO(0, 5),;
//	 STRZERO(0, 4)	,;			 																
//	 STRZERO(0, 10) ,;																				
//	 STRZERO(0, 10) ,;									   											
//	 STRZERO(0, 7)	,;								   											
//	 STRZERO(0, 2)	,;								   											
//	 STRZERO(0, 8),;
//	 STRZERO(0, 1),;
//	 STRZERO(0, 3),;
//	 STRZERO(0, 3),;
//	 STRZERO(0, 2),;
//	 STRZERO(0, 10),;
//	 STRZERO(0, 9),;
//	 STRZERO(0, 7),;
//	 STRZERO(0, 2),;
//	 STRZERO(0,44),;
//	  .F. })
//	
//	_nSeqLin += 1	
//Next

If Select("QRY") > 0
	QRY->(DbCloseArea())
EndIf


RestArea(aArea)

Return .T.
                             

Static Function MOVSD3(cProd,cTipo, cTipoRel)
Local _cQryD3a := ""
Local _nRetD3a := 0
If  cTipoRel == "RESUMIDO"
	_cQryD3a :=	" SELECT SUM(D3_QUANT) AS QUANT FROM "+RetSqlName("SD3")+" SD3 "
	_cQryD3a +=	" WHERE SD3.D_E_L_E_T_ = '' "                              
	_cQryD3a +=	" AND SD3.D3_FILIAL = '"+xFilial("SD3")+"' "
	_cQryD3a +=	" AND D3_EMISSAO between '20160401' and '20160430' "
	_cQryD3a +=	" AND D3_COD = '"+cProd+"'"
	_cQryD3a +=	" AND D3_ESTORNO = '' "
EndIf

If cTipo = "CON" 
	_cQryD3a +=	" AND D3_CF IN ('RE1','RE2') "
	_cQryD3a +=	" AND D3_OP <> '' "
ElseIf cTipo = "PRO" 	
	_cQryD3a +=	" AND D3_CF = 'PR0' "
	_cQryD3a +=	" AND D3_OP <> '' "
ElseIf cTipo = "REQ" 	
	_cQryD3a +=	" AND D3_CF IN ('RE1','RE2','RE4','RE6','RE7')"
	_cQryD3a +=	" AND D3_OP = '' "
ElseIf cTipo = "DEV" 	
	_cQryD3a +=	" AND D3_CF IN ('DE0','DE1','DE2','DE4','DE6','DE7')"
	_cQryD3a +=	" AND D3_OP = '' "
	
EndIf

_cQryD3a := ChangeQuery(_cQryD3a)
TCQUERY _cQryD3a NEW ALIAS "TRD3a"

DbSelectArea("TRD3a")

TRD3a->(DbGoTop())   
While !TRD3a->(Eof())
	_nRetD3a += TRD3a->QUANT
	DbSkip()
EndDo

TRD3a->(DbCloseArea())

Return(_nRetD3a)                        


Static Function getProdAnp()
aRet := {}

For nX := 1 To Len(_aTotProd)     
	aadd(aRet, _aTotProd[nX][1])
Next

Return aRet  


Static Function DBLDCRIT()
Local _cCrit 	:= ""                               
Local _aMtzRgrs := {}       
                              
MsgInfo("Erro no conteudo do array referente aos totalizadores...")

Return _cCrit  