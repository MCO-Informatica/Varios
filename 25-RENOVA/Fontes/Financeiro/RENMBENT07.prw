#INCLUDE 'PROTHEUS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RENMBENT07  ºAutor  ³                				11/06/2017º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gatilhar entidades contabeis 07 pela natureza financeira.   º±±
±±           ³					                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Renova                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

// (09/09/2021) - Alterado por Luiz - Ajustadas retorno do gatilho conforme planilha recebida em 09/09/2021

User Function RENMBENT07(_cOpc)

Local _cEnt07 := ''

If ALLTRIM(M->E5_NATUREZ) $ "1204,2310,2311,2338,2412,2501,2508,2513,2514,2516,2521,2604"

	If !Empty(M->E5_ITEMD)
		If _cOpc = "1" .or. _cOpc = "2"    	
	   		_cEnt07 := SubStr(M->E5_EC05DB,3,5)	// Se executado pela Natureza ou pelo Projeto (Débito)
		Else 
			_cEnt07 := SubStr(M->E5_EC05CR,3,5)	// Se executado Projeto (Crédito)
		Endif 
	Endif

// (09/09/2021) Início do trecho comentado por Luiz 
/*	If _cOpc = '1' //Gatilho Executado pela Natureza
		If !Empty(M->E5_ITEMD)
			If ALLTRIM(M->E5_NATUREZ) = "2513"
				_cEnt07 := "27002"
			ElseIf ALLTRIM(M->E5_NATUREZ) = "2501"
				_cEnt07 := "27002"
			ElseIf ALLTRIM(M->E5_NATUREZ) = "2506"
				_cEnt07 := "27002"
			ElseIf ALLTRIM(M->E5_NATUREZ) = "2508"
				_cEnt07 := "27002"
			ElseIF ALLTRIM(M->E5_NATUREZ) = "2604"
				_cEnt07 := "27002"
			ElseIf ALLTRIM(M->E5_NATUREZ) = "1204"
				_cEnt07 := "27001"
			ElseIf ALLTRIM(M->E5_NATUREZ) = "2338"
				_cEnt07 := "06003"
			ElseIf ALLTRIM(M->E5_NATUREZ) = "2516"
				_cEnt07 := "27002"
			EndIF
		EndIf
		
	ElseIf _cOpc = '2'  //Gatilho Executado pelo Item Contabil (Projeto) Debito
		If ALLTRIM(M->E5_NATUREZ) = "2513"
			_cEnt07 := "27002"
		ElseIf ALLTRIM(M->E5_NATUREZ) = "2501"
			_cEnt07 := "27002"
		ElseIf ALLTRIM(M->E5_NATUREZ) = "2506"
			_cEnt07 := "27002"
		ElseIf ALLTRIM(M->E5_NATUREZ) = "2508"
			_cEnt07 := "27002"
		ElseIF ALLTRIM(M->E5_NATUREZ) = "2604"
			_cEnt07 := "27002"
		ElseIf ALLTRIM(M->E5_NATUREZ) = "1204"
			_cEnt07 := "27001"
		ElseIf ALLTRIM(M->E5_NATUREZ) = "2338"
			_cEnt07 := "06003"
		ElseIf ALLTRIM(M->E5_NATUREZ) = "2516"
			_cEnt07 := "27002"
		EndIF
	Else  //Gatilho Executado pelo Item Contabil (Projeto) Credito
		If ALLTRIM(M->E5_NATUREZ) = "2513"
			_cEnt07 := "27002"
		ElseIf ALLTRIM(M->E5_NATUREZ) = "2501"
			_cEnt07 := "27002"
		ElseIf ALLTRIM(M->E5_NATUREZ) = "2506"
			_cEnt07 := "27002"
		ElseIf ALLTRIM(M->E5_NATUREZ) = "2508"
			_cEnt07 := "27002"
		ElseIF ALLTRIM(M->E5_NATUREZ) = "2604"
			_cEnt07 := "27002"
		ElseIf ALLTRIM(M->E5_NATUREZ) = "1204"
			_cEnt07 := "27001"
		ElseIf ALLTRIM(M->E5_NATUREZ) = "2338"
			_cEnt07 := "06003"
		ElseIf ALLTRIM(M->E5_NATUREZ) = "2516"
			_cEnt07 := "27002"
		EndIF
	EndIf
*/	
// (09/09/2021) Final do trecho comentado por Luiz 

EndIf

Return(_cEnt07)
