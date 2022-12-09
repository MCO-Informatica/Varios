#include "topconn.ch"
#include "rwmake.ch"
#include "protheus.ch"
#include "tbiconn.ch"                              
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EXPFIN02  ºAutor  ³Adriano da Silva    º Data ³  02/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exportação dos Dados do Financeiro/Notas Fiscais para o    º±±
±±º          ³ Sistema CLarity - Via Job 			                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Renova Energia                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EXPFIN02(aParam)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aRetFils	:= {}
Local cQuery 	:= ""
Local nX		:= 0
Local cEndLin 	:= Chr(13)+Chr(10)
Local cTexto 	:= ""
Local cEDTtar   := ""
Local aArchivos	:= {}

Private cCodEmp		:= aParam[1]
Private cCodFil		:= aParam[2]
Private nHdl		:= 0
Private nHdlFin		:= 0
Private cPath		:= GetSrvProfString("RootPath","")
Private cArqNfe 	:= "NFE"+".txt" 
Private cArqFin 	:= "FIN"+".txt"

ConOut("*************************************") 
ConOut("Funcao Job: " + FunName() )
ConOut("*************************************") 
ConOut("Empresa Inicial: " + cCodEmp)
ConOut("Filial Inicial:  " + cCodFil)
ConOut("Arquivo NFE: " +cArqNfe )
ConOut("Arquivo FIN: " +cArqFin )

RpcClearEnv()
RPCSetType(3)
RpcSetEnv( cCodEmp,cCodFil,,,,,,,,,)

cExpFin	:= GetMv("MV_XEXPFIN",.T.,"\development\saida\")		// Criar Diretorio Abaixo do RootPath

ConOut("Diretorio cExpFin: " +cExpFin )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Todas as Empresas e Filials do Sigamat                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SM0")
SM0->(DbSetOrder(1))
SM0->(DbGoTop())
While SM0->(!Eof())
	Aadd(aRetFils,{SM0->M0_CODIGO,SM0->M0_CODFIL,SM0->M0_CGC})
	SM0->(Dbskip())
EndDo

ConOut("Tamanho do aRetFils: " + AllTrim(Str(Len(aRetFils))))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o Arquivo de Notas Fiscais Já Existe                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aArchivos := Directory(cExpFin+"*.txt","D",,.F.)
If Len(aArchivos) > 0
	ConOut("Já existe arquivo na pasta "+cExpFin+". Favor mover o arquivo da pasta especificada!")		
	Return
EndIf

nHdl := FCreate(cExpFin+cArqNfe)

For nX:=1 To Len(aRetFils)
	
	RpcClearEnv()
	RPCSetType(3)
	RpcSetEnv( aRetFils[nX][1],aRetFils[nX][2],,,,,,,,,)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Query Para Verificar o Relacionamento com as Tabelas SF1/AFN/SA2    ³
	//³ Processo de Notas Fiscais - 001									    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "SELECT DISTINCT SF1.R_E_C_N_O_ AS RECSF1, AFN.R_E_C_N_O_ AS RECAFN, SA2.R_E_C_N_O_ AS RECSA2"
	cQuery += " FROM "+RetSqlName("SF1")+" SF1"
	cQuery += " INNER JOIN "+RetSqlName("AFN")+" AFN"
	cQuery += " ON SF1.F1_FILIAL = AFN.AFN_FILIAL"
	cQuery += " AND SF1.F1_SERIE = AFN.AFN_SERIE"
	cQuery += " AND SF1.F1_DOC = AFN.AFN_DOC"
	cQuery += " AND SF1.F1_FORNECE = AFN.AFN_FORNEC"
	cQuery += " AND SF1.F1_LOJA = AFN.AFN_LOJA"
	cQuery += " AND AFN.AFN_XEXPOR <> '1' "	
	cQuery += " AND AFN.D_E_L_E_T_ = ' ' "
	cQuery += " INNER JOIN "+RetSqlName("SA2")+" SA2"
	cQuery += " ON SF1.F1_FORNECE = SA2.A2_COD"
	cQuery += " AND SF1.F1_LOJA = SA2.A2_LOJA"
	cQuery += " AND SA2.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE SF1.F1_FILIAL = '"+xFilial("SF1")+"' "
	cQuery += " AND SF1.F1_EMISSAO BETWEEN '"+DtoS(Date())+"' AND '"+DtoS(Date())+"' "
	cQuery += " AND SF1.D_E_L_E_T_ = ' ' "
	nRet := TcSqlExec(cQuery)
	
	If nRet >= 0 // Verifica se a Query não tem erro para criar a TRB.
		ConOut("Query Processo 001 - NF: " + cQuery)
		If Select("TRBSF1") > 0
			DbSelectArea("TRBSF1")
			DbCloseArea()
		EndIf
		
		DBUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBSF1",.F.,.T.)
		
		DbSelectArea("TRBSF1")
		DbGoTop()
		While !Eof()
			
			cTexto := ""
			
			DbSelectArea("SF1")
			DbGoTo(TRBSF1->RECSF1)
			
			DbSelectArea("AFN")
			DbGoTo(TRBSF1->RECAFN)
			
			DbSelectArea("SA2")
			DbGoTo(TRBSF1->RECSA2)
			
			cTexto += AllTrim(AFN->AFN_PROJET)+";" 													//ID Projeto Clarity
			
			cEDTtar := Posicione("AF9",1,XFILIAL("AF9")+AFN->AFN_PROJET+"0001"+AFN->AFN_TAREFA, "AF9_EDTPAI")
			cTexto +=trim(cEDTtar)+";"
			cTexto += AllTrim(AFN->AFN_TAREFA)+";"													//ID Tarefa			 
			If SA2->A2_TIPO == "X" //Exportação
				cTexto += AllTrim(aRetFils[nX][1]+aRetFils[nX][2]+SA2->A2_COD+SA2->A2_LOJA)+";"		//CGC Fornecedor Exportacao
			Else
				cTexto += AllTrim(SA2->A2_CGC)+";"													//CGC Fornecedor			
			EndIf
			cTexto += AllTrim(AFN->AFN_DOC)+";"														//Numero
			cTexto += AllTrim(SubStr(DtoS(SF1->F1_DTDIGIT),1,4)+"-"+;
							  SubStr(DtoS(SF1->F1_DTDIGIT),5,2)+"-"+;
							  SubStr(DtoS(SF1->F1_DTDIGIT),7,2))+";"								//Data Competência
			cTexto += "1"+";"																		//Quantidade - Sempre o valor 1							  
			cTexto += AllTrim(StrTran(Transform(SF1->F1_VALBRUT,"@E 999999999.99"),",","."))+";"	//Valor Competência
			
			//Pesquisa Compra Direta no Pedido de Compra
			cCompDir := PesqComDir(aRetFils[nX][1],aRetFils[nX][2],AFN->AFN_DOC,AFN->AFN_SERIE,AFN->AFN_FORNEC,AFN->AFN_LOJA)
			
			cTexto += cCompDir+";"																	//Compra Direta
			cTexto += "   "+";"																		//Tipo do Titulo
			cTexto += cEndLin
									
			FWrite(nHdl,cTexto)
			
			cUpdate := "UPDATE "+"AFN"+aRetFils[nX][1]+"0"+" SET AFN_XEXPOR = '1' "
			cUpdate += " WHERE R_E_C_N_O_ = "+AllTrim(Str(TRBSF1->RECAFN))
			TcSqlExec(cUpdate)
			
			DbSelectArea("TRBSF1")
			DbSkip()
		
		Enddo
		
		If Select("TRBSF1") > 0
			DbSelectArea("TRBSF1")
			DbCloseArea()
		EndIf
    
    EndIf
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Query Para Verificar o Relacionamento com as Tabelas SE5/AFR/SA2    ³
	//³ Processo de Notas Fiscais - 002									    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "SELECT DISTINCT AFR.R_E_C_N_O_ AS RECAFR, SA2.R_E_C_N_O_ AS RECSA2"
	cQuery += " FROM "+RetSqlName("AFR")+" AFR"
	cQuery += " INNER JOIN "+RetSqlName("SA2")+" SA2"
	cQuery += " ON AFR.AFR_FORNEC = SA2.A2_COD"
	cQuery += " AND AFR.AFR_LOJA = SA2.A2_LOJA"
	cQuery += " AND SA2.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE AFR_FILIAL = '"+xFilial("AFR")+"' "
	cQuery += " AND AFR.AFR_TIPO = 'PA ' "	
	cQuery += " AND AFR.AFR_DATA BETWEEN '"+DtoS(Date())+"' AND '"+DtoS(Date())+"' "
	cQuery += " AND AFR.AFR_XEXPOR <> '1' "	
	cQuery += " AND AFR.D_E_L_E_T_ = ' ' "
	nRet := TcSqlExec(cQuery)
	
	If nRet >= 0 // Verifica se a Query não tem erro para criar a TRB.
		ConOut("Query Processo 002 - NF: " + cQuery)
		
		If Select("TRBSF1") > 0
			DbSelectArea("TRBSF1")
			DbCloseArea()
		EndIf
		
		DBUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBSF1",.F.,.T.)
		
		DbSelectArea("TRBSF1")
		DbGoTop()
		While !Eof()
			
			cTexto := ""
			
			DbSelectArea("AFR")
			DbGoTo(TRBSF1->RECAFR)
			
			DbSelectArea("SA2")
			DbGoTo(TRBSF1->RECSA2)
			
			cTexto += AllTrim(AFR->AFR_PROJET)+";" 													//ID Projeto Clarity
			cEDTtar := Posicione("AF9",1,XFILIAL("AF9")+AFR->AFR_PROJET+"0001"+AFR->AFR_TAREFA, "AF9_EDTPAI")
			cTexto +=trim(cEDTtar)+";"
			cTexto += AllTrim(AFR->AFR_TAREFA)+";"													//ID Tarefa			 
			If SA2->A2_TIPO == "X" //Exportação
				cTexto += AllTrim(aRetFils[nX][1]+aRetFils[nX][2]+SA2->A2_COD+SA2->A2_LOJA)+";"		//CGC Fornecedor Exportacao
			Else
				cTexto += AllTrim(SA2->A2_CGC)+";"													//CGC Fornecedor			
			EndIf
			cTexto += AllTrim(AFR->AFR_NUM)+";"														//Numero 			
			cTexto += AllTrim(SubStr(DtoS(AFR->AFR_DATA),1,4)+"-"+;
							  SubStr(DtoS(AFR->AFR_DATA),5,2)+"-"+;
							  SubStr(DtoS(AFR->AFR_DATA),7,2))+";"									//Data Competência
			cTexto += "1"+";"																		//Quantidade - Sempre o valor 1							  
			cTexto += AllTrim(StrTran(Transform(AFR->AFR_VALOR1,"@E 999999999.99"),",","."))+";"		//Valor Competência
			
			//Pesquisa Compra Direta no Pedido de Compra
			cCompDir := "0"	//Sempre Zero
			
			cTexto += cCompDir+";"																	//Compra Direta
			cTexto += AllTrim(AFR->AFR_TIPO)+";"													//Tipo do Titulo
			cTexto += cEndLin
			
			FWrite(nHdl,cTexto)
			
			cUpdate := "UPDATE "+"AFR"+aRetFils[nX][1]+"0"+" SET AFR_XEXPOR = '1' "
			cUpdate += " WHERE R_E_C_N_O_ = "+AllTrim(Str(TRBSF1->RECAFR))
			TcSqlExec(cUpdate)
			
			DbSelectArea("TRBSF1")
			DbSkip()
		
		Enddo
		
		If Select("TRBSF1") > 0
			DbSelectArea("TRBSF1")
			DbCloseArea()
		EndIf
    
    EndIf    

Next

If Empty(cTexto)
	FClose(nHdl)
	FErase(AllTrim(cExpFin+cArqNfe))
	ConOut("Arquivo de NFE em branco!!!!!!!")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha o arquivo TXT			                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nHdl > 0 .And. !Empty(cTexto)
	FClose(nHdl)
	ConOut("Depois de Fechar o Arquivo de NFE!!!!!!!!!")
EndIf 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Limpa a Variavel cTexto Para Geração do Arquivos do Financeiro      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTexto := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o Arquivo de Notas Fiscais 				                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHdl := FCreate(cExpFin+cArqFin)

For nX:=1 To Len(aRetFils)
    
	RpcClearEnv()
	RPCSetType(3)
	RpcSetEnv( aRetFils[nX][1],aRetFils[nX][2],,,,,,,,,)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Query Para Verificar o Relacionamento com as Tabelas SF1/AFN/SE5    ³
	//³ Processo de Titulos Baixados - 001								    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "SELECT DISTINCT SE5.R_E_C_N_O_ AS RECSE5, SF1.R_E_C_N_O_ AS RECSF1, AFN.R_E_C_N_O_ AS RECAFN, SA2.R_E_C_N_O_ AS RECSA2"
	cQuery += " FROM "+RetSqlName("SE5")+" SE5" 
	cQuery += " INNER JOIN "+RetSqlName("SF1")+" SF1" 
	cQuery += " ON  SE5.E5_PREFIXO = SF1.F1_SERIE"
	cQuery += " AND SE5.E5_NUMERO = SF1.F1_DOC "
	cQuery += " AND SE5.E5_CLIFOR = SF1.F1_FORNECE"
	cQuery += " AND SE5.E5_LOJA = SF1.F1_LOJA "
	cQuery += " AND SF1.D_E_L_E_T_ = ' ' "
	cQuery += " INNER JOIN "+RetSqlName("AFN")+" AFN" 
	cQuery += " ON SF1.F1_FILIAL = AFN.AFN_FILIAL"
	cQuery += " AND SF1.F1_DOC = AFN.AFN_DOC"
	cQuery += " AND SF1.F1_SERIE = AFN.AFN_SERIE"
	cQuery += " AND SF1.F1_FORNECE = AFN.AFN_FORNEC"
	cQuery += " AND SF1.F1_LOJA = AFN.AFN_LOJA"
	cQuery += " AND AFN.D_E_L_E_T_ = ' ' "
	cQuery += " INNER JOIN "+RetSqlName("SA2")+" SA2" 
	cQuery += " ON SF1.F1_FORNECE = SA2.A2_COD"
	cQuery += " AND SF1.F1_LOJA = SA2.A2_LOJA"
	cQuery += " AND SA2.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE E5_FILIAL = '"+xFilial("SE5")+"' "
	cQuery += " AND SE5.E5_DATA BETWEEN '"+DtoS(Date())+"' AND '"+DtoS(Date())+"' "
	cQuery += " AND SE5.E5_XEXPOR <> '1' "	
	cQuery += " AND SE5.D_E_L_E_T_ = ' ' "
	nRet := TcSqlExec(cQuery)

	If nRet >= 0 // Verifica se a Query não tem erro para criar a TRB.
		ConOut("Query Processo 001 - Financeiro: " + cQuery)
		
		If Select("TRBSF1") > 0
			DbSelectArea("TRBSF1")
			DbCloseArea()
		EndIf
		
		DBUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBSF1",.F.,.T.)
		
		DbSelectArea("TRBSF1")
		DbGoTop()
		While !Eof()
			
			cTexto := ""
			
			DbSelectArea("SE5")
			DbGoTo(TRBSF1->RECSE5)
			
   			DbSelectArea("SF1")
			DbGoTo(TRBSF1->RECSF1)
			
			DbSelectArea("AFN")
			DbGoTo(TRBSF1->RECAFN)
			
			DbSelectArea("SA2")
			DbGoTo(TRBSF1->RECSA2)
			
			cTexto += AllTrim(AFN->AFN_PROJET)+";" 													//ID Projeto Clarity
			cEDTtar := Posicione("AF9",1,XFILIAL("AF9")+AFN->AFN_PROJET+"0001"+AFN->AFN_TAREFA, "AF9_EDTPAI")
			cTexto +=trim(cEDTtar)+";"
			cTexto += AllTrim(AFN->AFN_TAREFA)+";"													//ID Tarefa			 
			If SA2->A2_TIPO == "X" //Exportação
				cTexto += AllTrim(aRetFils[nX][1]+aRetFils[nX][2]+SA2->A2_COD+SA2->A2_LOJA)+";"		//CGC Fornecedor Exportacao
			Else
				cTexto += AllTrim(SA2->A2_CGC)+";"													//CGC Fornecedor			
			EndIf
			cTexto += AllTrim(AFN->AFN_DOC)+";"														//Numero			
			cTexto += AllTrim(SubStr(DtoS(SE5->E5_DATA),1,4)+"-"+;
							  SubStr(DtoS(SE5->E5_DATA),5,2)+"-"+;
							  SubStr(DtoS(SE5->E5_DATA),7,2))+";"									//Data Competência
			cTexto += "1"+";"																		//Quantidade - Sempre o valor 1							  
			cTexto += AllTrim(StrTran(Transform(SE5->E5_VALOR,"@E 999999999.99"),",","."))+";"		//Valor Competência
			
			//Pesquisa Compra Direta no Pedido de Compra
			cCompDir := PesqComDir(aRetFils[nX][1],aRetFils[nX][2],AFN->AFN_DOC,AFN->AFN_SERIE,AFN->AFN_FORNEC,AFN->AFN_LOJA) 
			
			cTexto += cCompDir+";"																	//Compra Direta
			cTexto += "   "+";"																		//Tipo do Titulo
			cTexto += cEndLin
									
			FWrite(nHdl,cTexto)
			
			cUpdate := "UPDATE "+"SE5"+aRetFils[nX][1]+"0"+" SET E5_XEXPOR = '1' "
			cUpdate += " WHERE R_E_C_N_O_ = "+AllTrim(Str(TRBSF1->RECSE5))
			TcSqlExec(cUpdate)
			
			DbSelectArea("TRBSF1")
			DbSkip()
		
		Enddo
		
		If Select("TRBSF1") > 0
			DbSelectArea("TRBSF1")
			DbCloseArea()
		EndIf
    
    EndIf	

Next

If Empty(cTexto)
	FClose(nHdl)
	Ferase(AllTrim(cExpFin+cArqFin))
	ConOut("Arquivo Financeiro em Branco!!!!!!!")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha o arquivo TXT			                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nHdl > 0 .And. !Empty(cTexto)
	FClose(nHdl)
	ConOut("Depois de Fechar o Arquivo Financeiro !!!!!!!!!")
EndIf 

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PesqComDirºAutor  ³Microsiga           º Data ³  07/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Pesquisa Pedido de Compra e Verifica se Faz Parte de uma   º±±
±±º          ³ Compra Direta                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exporta()                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PesqComDir(cPar01,cPar02,cPar03,cPar04,cPar05,cPar06)

Local cQuery	:= ""
Local aArea		:= GetArea() 
Local cRet		:= "0"	//Não
Local nCont		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Query Para Pesquisa Pedido de Compra								³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT C7_NUM,C7_XCOMPD "
cQuery += " FROM "+"SD1"+cPar01+"0 SD1"
cQuery += " INNER JOIN "+"SC7"+cPar01+"0 SC7"
cQuery += " ON SD1.D1_FILIAL = SC7.C7_FILIAL"
cQuery += " AND SD1.D1_PEDIDO = SC7.C7_NUM"
cQuery += " AND SC7.D_E_L_E_T_ = ' ' "
cQuery += " WHERE SD1.D1_FILIAL = '"+cPar02+"' "
cQuery += " AND SD1.D1_DOC = '"+cPar03+"' "
cQuery += " AND SD1.D1_SERIE = '"+cPar04+"' "
cQuery += " AND SD1.D1_FORNECE = '"+cPar05+"' "
cQuery += " AND SD1.D1_LOJA = '"+cPar06+"' "
cQuery += " AND SD1.D_E_L_E_T_ = ' ' "
cQuery += " GROUP BY C7_NUM,C7_XCOMPD "
cQuery += " ORDER BY C7_NUM,C7_XCOMPD "
nCont := TcSqlExec(cQuery)

If nCont >= 0 // Verifica se a Query não tem erro para criar a TRB.
	
	If Select("TRBSC7") > 0
		DbSelectArea("TRBSC7")
		DbCloseArea()
	EndIf
	
	DBUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBSC7",.F.,.T.)
    
	DbSelectArea("TRBSC7")
	DbGoTop()
	While !Eof()
		
		cRet := IIf(AllTrim(TRBSC7->C7_XCOMPD) == "1","1","0")
		
		DbSelectArea("TRBSC7")
		DbSkip()
	
	Enddo
		
	If Select("TRBSC7") > 0
		DbSelectArea("TRBSC7")
		DbCloseArea()
	EndIf
	

EndIf

RestArea(aArea)

Return(cRet)