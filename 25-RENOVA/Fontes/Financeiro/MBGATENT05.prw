#INCLUDE 'PROTHEUS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MBGATENT05  ºAutor  ³                				25/08/2015º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gatilhar entidades contabeis 05 pela natureza financeira.   º±±
±±           ³					                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Renova                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

// (09/09/2021) - Alterado por Luiz - Ajustadas retorno do gatilho conforme planilha recebida em 09/09/2021

User Function MBGATENT05(_cOpc)

Local _cEnt05 := ''

If ALLTRIM(M->E5_NATUREZ) $ "1204,2310,2311,2338,2412,2501,2508,2513,2514,2516,2521,2604"

	If _cOpc = '1' //Gatilho Executado pela Natureza
		If !Empty(M->E5_ITEMD)
			If ALLTRIM(M->E5_NATUREZ) = "1204"
				_cEnt05 := SUBSTR(M->E5_ITEMD,1,2)+"270010001"
			ElseIf ALLTRIM(M->E5_NATUREZ) = "2310"
				_cEnt05 := SUBSTR(M->E5_ITEMD,1,2)+"150030007"
			ElseIf ALLTRIM(M->E5_NATUREZ) = "2311"
				_cEnt05 := SUBSTR(M->E5_ITEMD,1,2)+"150030006"
			ElseIf ALLTRIM(M->E5_NATUREZ) = "2338"
				_cEnt05 := SUBSTR(M->E5_ITEMD,1,2)+"060030002"
			ElseIF ALLTRIM(M->E5_NATUREZ) = "2412"
				_cEnt05 := SUBSTR(M->E5_ITEMD,1,2)+"310020001"
			ElseIF ALLTRIM(M->E5_NATUREZ) = "2501"
				_cEnt05 := SUBSTR(M->E5_ITEMD,1,2)+"270020013"
			ElseIf ALLTRIM(M->E5_NATUREZ) = "2508"
				_cEnt05 := SUBSTR(M->E5_ITEMD,1,2)+"270020015" 
			ElseIF ALLTRIM(M->E5_NATUREZ) = "2513"
				_cEnt05 := SUBSTR(M->E5_ITEMD,1,2)+"270020012"
			ElseIf ALLTRIM(M->E5_NATUREZ) = "2514"
				_cEnt05 := SUBSTR(M->E5_ITEMD,1,2)+"270020005"	
			ElseIf ALLTRIM(M->E5_NATUREZ) = "2516"
				_cEnt05 := SUBSTR(M->E5_ITEMD,1,2)+"270020016"
			ElseIf ALLTRIM(M->E5_NATUREZ) = "2521"
				_cEnt05 := SUBSTR(M->E5_ITEMD,1,2)+"270020003"				
			ElseIf ALLTRIM(M->E5_NATUREZ) = "2604"
				_cEnt05 := SUBSTR(M->E5_ITEMD,1,2)+"270020001"				
			EndIF
		EndIf
		
	ElseIf _cOpc = '2'  //Gatilho Executado pelo Item Contabil (Projeto) Debito
		If ALLTRIM(M->E5_NATUREZ) = "1204"
			_cEnt05 := SUBSTR(M->E5_ITEMD,1,2)+"270010001"
		ElseIf ALLTRIM(M->E5_NATUREZ) = "2310"
			_cEnt05 := SUBSTR(M->E5_ITEMD,1,2)+"150030007"
		ElseIf ALLTRIM(M->E5_NATUREZ) = "2311"
			_cEnt05 := SUBSTR(M->E5_ITEMD,1,2)+"150030006"
		ElseIf ALLTRIM(M->E5_NATUREZ) = "2338"
			_cEnt05 := SUBSTR(M->E5_ITEMD,1,2)+"060030002"
			ElseIF ALLTRIM(M->E5_NATUREZ) = "2412"
				_cEnt05 := SUBSTR(M->E5_ITEMD,1,2)+"310020001"			
		ElseIF ALLTRIM(M->E5_NATUREZ) = "2501"
			_cEnt05 := SUBSTR(M->E5_ITEMD,1,2)+"270020013"
		ElseIf ALLTRIM(M->E5_NATUREZ) = "2508"
			_cEnt05 := SUBSTR(M->E5_ITEMD,1,2)+"270020015" 
		ElseIF ALLTRIM(M->E5_NATUREZ) = "2513"
			_cEnt05 := SUBSTR(M->E5_ITEMD,1,2)+"270020012"
		ElseIf ALLTRIM(M->E5_NATUREZ) = "2514"
			_cEnt05 := SUBSTR(M->E5_ITEMD,1,2)+"270020005"	
		ElseIf ALLTRIM(M->E5_NATUREZ) = "2516"
			_cEnt05 := SUBSTR(M->E5_ITEMD,1,2)+"270020016"
		ElseIf ALLTRIM(M->E5_NATUREZ) = "2521"
			_cEnt05 := SUBSTR(M->E5_ITEMD,1,2)+"270020003"				
		ElseIf ALLTRIM(M->E5_NATUREZ) = "2604"
			_cEnt05 := SUBSTR(M->E5_ITEMD,1,2)+"270020001"					
		EndIF
	Else  //Gatilho Executado pelo Item Contabil (Projeto) Credito
		If ALLTRIM(M->E5_NATUREZ) = "1204"
			_cEnt05 := SUBSTR(M->E5_ITEMC,1,2)+"270010001"
		ElseIf ALLTRIM(M->E5_NATUREZ) = "2310"
			_cEnt05 := SUBSTR(M->E5_ITEMC,1,2)+"150030007"
		ElseIf ALLTRIM(M->E5_NATUREZ) = "2311"
			_cEnt05 := SUBSTR(M->E5_ITEMC,1,2)+"150030006"
		ElseIf ALLTRIM(M->E5_NATUREZ) = "2338"
			_cEnt05 := SUBSTR(M->E5_ITEMC,1,2)+"060030002"
		ElseIF ALLTRIM(M->E5_NATUREZ) = "2412"
			_cEnt05 := SUBSTR(M->E5_ITEMC,1,2)+"310020001"			
		ElseIF ALLTRIM(M->E5_NATUREZ) = "2501"
			_cEnt05 := SUBSTR(M->E5_ITEMC,1,2)+"270020013"
		ElseIf ALLTRIM(M->E5_NATUREZ) = "2508"
			_cEnt05 := SUBSTR(M->E5_ITEMC,1,2)+"270020015" 
		ElseIF ALLTRIM(M->E5_NATUREZ) = "2513"
			_cEnt05 := SUBSTR(M->E5_ITEMC,1,2)+"270020012"
		ElseIf ALLTRIM(M->E5_NATUREZ) = "2514"
			_cEnt05 := SUBSTR(M->E5_ITEMC,1,2)+"270020005"	
		ElseIf ALLTRIM(M->E5_NATUREZ) = "2516"
			_cEnt05 := SUBSTR(M->E5_ITEMC,1,2)+"270020016"
		ElseIf ALLTRIM(M->E5_NATUREZ) = "2521"
			_cEnt05 := SUBSTR(M->E5_ITEMC,1,2)+"270020003"				
		ElseIf ALLTRIM(M->E5_NATUREZ) = "2604"
			_cEnt05 := SUBSTR(M->E5_ITEMC,1,2)+"270020001"					
		EndIF
	EndIf
EndIf

Return(_cEnt05)
