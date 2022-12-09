#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CN120ENVL º Autor ³ Tatiana Pontes 	   º Data ³ 11/04/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada Encerramento da Medicao (CNTA120)	      º±±
±±º          ³ Criado para receber numero do empenho da medicao encerrada º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CN120ENVL()
   
	Local _cPvContr	:= Alltrim(GetMv("MV_PVCONTR")) // Gera pedido de venda atraves do modulo de gestao de contratos (S/N)
	Local _aArea 	:= GetArea()
	Local _lRet 	:= .F.   
	Local _nOpc	 	:= 0

	Public _cCodEmp	:= SPACE(10)  
	Public _cCodPrj	:= SPACE(10) 
	Public _cOportu := SPACE(10) 
//	Public _cNaturez := SPACE(10) //o contéudo será gerado através do novo campo AD1_XNATUR 
	Public _cItConta := SPACE(10)
	Public _cClaVal := SPACE(10)
	
	// 30/10/13 - Alterado por: Renato Ruy - Se posiciona no cabeçalho da planilha para retornar os valores e foram adicionados campos. 
	
	DbSelectArea("CNA")
	DbSetOrder(1)
	DbSeek( xFilial("CNA") + CND->CND_CONTRA + CND->CND_REVISA + CND->CND_NUMERO )
	
	_cCodEmp	:= SubStr(CNA->CNA_MDEMPE,1,10)
	_cCodPrj	:= CNA->CNA_MDPROJ
	_cOportu 	:= CN9->CN9_XOPORT
	_cItConta 	:= CNA->CNA_ITEMCT 
	_cClaVal	:= CNA->CNA_CLVL
	
	CN9->(DbSetOrder(1))
	CN9->(DbSeek( xFilial("CN9") + CND->CND_CONTRA))	
	                            
	CN1->(DbSetOrder(1))
	CN1->(DbSeek( xFilial("CN1") + CN9->CN9_TPCTO ))
	
	If _cPvContr == "S" .And. CN1->CN1_ESPCTR <> "1"
			
		DEFINE MSDIALOG oDlg TITLE "Informe os dados :" FROM 0,0 TO 230,250 OF oMainWnd PIXEL FONT oMainWnd:oFont
	   
		@008,05 Say " Cód. Empenho: " 	PIXEL SIZE 40,07 OF oDlg
		@007,45 MsGet _cCodEmp 			VALID NaoVazio(_cCodEmp) PIXEL SIZE 65,09 OF oDlg
		
		@023,05 Say " Cód. Projeto: " 	PIXEL SIZE 40,07 OF oDlg
		//@022,45 MsGet _cCodPrj 		VALID NaoVazio(_cCodPrj) PIXEL SIZE 65,09 OF oDlg WHEN Empty(CNA->CNA_MDPROJ) 
		@022,45 MsGet _cCodPrj 			PIXEL SIZE 65,09 F3 "SZ3_05" OF oDlg WHEN Empty(CNA->CNA_MDPROJ) 
		
		@038,05 Say "Item Contabil: " 	PIXEL SIZE 40,07 OF oDlg
		//@037,45 MsGet _cItConta 		VALID NaoVazio(_cItConta) PIXEL SIZE 65,09 F3 "CTD" OF oDlg WHEN Empty(CNA->CNA_ITEMCT) 
		@037,45 MsGet _cItConta 		PIXEL SIZE 65,09 F3 "CTD" OF oDlg WHEN Empty(CNA->CNA_ITEMCT) 
		
		@053,05 Say " Classe Valor: " 	PIXEL SIZE 40,07 OF oDlg
//		@052,45 MsGet _cClaVal 		VALID NaoVazio(_cClaVal) PIXEL SIZE 65,09 F3 "CTH" OF oDlg WHEN Empty(CNA->CNA_ITEMCT)  
		@052,45 MsGet _cClaVal 			PIXEL SIZE 65,09 F3 "CTH" OF oDlg WHEN Empty(CNA->CNA_ITEMCT)  
		
//		@068,05 Say "     Natureza: " 	PIXEL SIZE 40,07 OF oDlg
//		@067,45 MsGet _cNaturez 		VALID NaoVazio(_cNaturez) PIXEL SIZE 65,09  F3 "SED" OF oDlg When .F.
		
		@068,05 Say " Oportunidade: " 	PIXEL SIZE 40,07 OF oDlg
//		@082,45 MsGet _cOportu 		VALID NaoVazio(_cOportu) PIXEL SIZE 65,09 F3 "AD1" OF oDlg WHEN Empty(CNA->CNA_UOPORT) 
		@067,45 MsGet _cOportu 			PIXEL SIZE 65,09 F3 "AD1" OF oDlg WHEN Empty(CN9->CN9_XOPORT) 
					
		DEFINE SBUTTON FROM 100,40 TYPE  1 ENABLE OF oDlg ACTION (_nOpc := 1, oDlg:End())
		DEFINE SBUTTON FROM 100,70 TYPE  2 ENABLE OF oDlg ACTION (_nOpc := 2, oDlg:End())
			
		ACTIVATE MSDIALOG oDlg CENTERED
		
		If _nOpc == 1 
			_lRet := .T.
		Endif		                                    
		
		RestArea(_aArea)    
		
	Else
	
		_lRet 	:= .T.	
    
	Endif
	
Return(_lRet)