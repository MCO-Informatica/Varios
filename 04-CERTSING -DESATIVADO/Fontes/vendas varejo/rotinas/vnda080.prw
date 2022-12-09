#INCLUDE "PROTHEUS.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "MSMGADD.CH"

#DEFINE XML_VERSION '<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VNDA080   ºAutor  ³David (Opvs)        º Data ³  09/02/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa para manipulaçao de Xml de Pedidos de Venda Site   º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VNDA080( cID, cNpSite, cPedGar, cType, nRecIn )
	Local cRootPath	 := ""
	Local cArquivo	 := ""
	Local cError	 := ""
	Local cWarning 	 := ""
	Local oXml				
	Local oXmlPed	
	Local oDlg
	Local nPed		 := 0 
	Local aButtons	 := {}
	Local aCoord	 := FwGetDialogSize( oMainWnd )
	Local nOpca		 := 2
	Local cParam	 := '"
	Local nY		 := 0
	Local cLinParam  := ""
	Local aInfoSE1	 := {}
	Local aInfoSC5	 := {}
	Local aInfoSC6	 := {}
	Local bConteudo	 := {|a|  SubStr(a , RAT ( "[",  a )+1,RAT ( "]",  cLinParam )-(RAT ( "[",  a )+1) )   }
	Local bTypeCtd	 := {|a|  Alltrim(SubStr(a , RAT ( "->",  a )+2, 3 ))   }
	Local cTypeCtd	 := ""
	Local cConteudo	 := ""
	Local lCtdA1	 := .F.
	Local lCtdC5	 := .F.
	Local lCtdC6	 := .F.
	Local lCtdE1	 := .F.
	Local nPosC5Cgc  := 0
	Local nPosE1Cgc  := 0
	Local aRet       := {}
	Local aParBox    := {}
	Local lParambox  := .F.
	Local nA1        := 0
	Local nJ         := 0
	Private aInfoSA1 := {}

	Default cID      := ""
	Default cPedGar	 := ""
	Default cType	 := ""
	Default nRecIn	 := 0
	Default cNpSite	 := ""

	If Empty( cID ) .and. Empty( cPedGar ) .and. Empty( cType ) .and. Empty( cNpSite ) .and. nRecIn == 0
		AAdd( aParBox, { 1, "Pedido Site", Space( 10 )       , "", "", "", "", 50, .T. } )
		AAdd( aParBox, { 1, "Data"       , Ctod( Space( 8 ) ), "", "", "", "", 50, .T. } )

		IF ParamBox( aParBox, "Ajuste XML", @aRet )
			cNpSite := aRet[1]

			if Select( "TRBID" ) > 0
				TRBID->( DbCloseArea() )
			Endif

			BeginSql Alias "TRBID"
				SELECT
				GT_ID,
				R_E_C_N_O_ RECIN
				FROM 
				GTIN
				WHERE
				GT_TYPE = 'F' AND
				GT_XNPSITE = %Exp:cNpSite%  AND
				GT_DATE = %Exp:DtoS( aRet[2] )%  AND
				D_E_L_E_T_ = ' '
			EndSql

			If !TRBID->( Eof() )
				cID := Alltrim( TRBID->GT_ID )
				nRecIn := TRBID->RECIN
			EndIf

			TRBID->( DbCloseArea() )
			lParambox := .T.
		Else
			MsgInfo("Operação cancelada.","Ajuste XML")
			Return( .F. )
		EndIF
	EndIf

	If cType = "P" .and. Empty( cNpSite ) .and. !Empty( cPedGar ) .and. nRecIn > 0
		USE GTIN ALIAS GTIN SHARED NEW VIA "TOPCONN"
		GTIN->(DbGoTo(nRecIn))	

		cParam := GTIN->GT_PARAM
		For nY := 1 to MlCount( cParam, 100 )

			cLinParam:= MemoLine( cParam, 100, nY ) 	

			cConteudo := Eval( bConteudo, cLinParam )
			cTypeCtd  := Eval( bTypeCtd , cLinParam ) 

			If "A1_" $ cConteudo .OR. "C5_" $ cConteudo .OR. "C6_" $ cConteudo .OR. "E1_" $ cConteudo
				If "A1_" $ cConteudo
					AADD( aInfoSA1, { cConteudo, "" } )
					lCtdA1 := .T.
				EndIf

				If "C5_" $ cConteudo
					AADD(aInfoSC5,{cConteudo,""})
					lCtdC5 := .T.
				EndIf

				If "C6_" $ cConteudo
					AADD( aInfoSC6, { cConteudo, "" } )
					lCtdC6 := .T.
				EndIf

				If "E1_" $ cConteudo
					AADD( aInfoSE1, { cConteudo, "" } )
					lCtdE1 := .T.
				EndIf
			Else 
				If cTypeCtd == "N"
					cConteudo := Val( cConteudo )	
				EndIf

				If cTypeCtd == "D"
					cConteudo := CtoD( cConteudo )	
				EndIf			

				If lCtdA1
					aInfoSA1[ Len( aInfoSA1 ), 2 ] := cConteudo
					lCtdA1 := .F.
				EndIf

				If lCtdC5
					aInfoSC5[ Len( aInfoSC5 ), 2 ] := cConteudo
					lCtdC5 := .F.
				EndIf

				If lCtdC6
					aInfoSC6[ Len( aInfoSC6 ), 2 ] := cConteudo
					lCtdC6 := .F.
				EndIf

				If lCtdE1
					aInfoSE1[ Len( aInfoSE1 ), 2 ] := cConteudo
					lCtdE1 := .F.
				EndIf
			EndIf
		Next

		USE

		aAux:= { aInfoSC6 }
		aInfoSC6:= {}
		aInfoSC6:= aClone( aAux )

		nPosC5Cgc := aScan( aInfoSC5, { |x| x[1] == "C5_CNPJ" } )	
		nPosE1Cgc := aScan( aInfoSE1, { |x| x[1] == "E1_CNPJ" } )	

		DbSelectArea( "SX3" )
		SX3->( DbSetOrder( 2 ) )

		DEFINE MSDIALOG oDlg TITLE "Manutenção Pedido Site" FROM aCoord[1], aCoord[2] TO aCoord[3], aCoord[4] PIXEL

		EnchoiceBar(oDlg, {|| nOpca := 1, oDlg:End() }, {|| nOpca := 2,oDlg:End() },,aButtons)

		// Cria Objeto de Layer
		oLayer := FWLayer():New()
		oLayer:Init( oDlg, .F., .T. ) 

		//Monta as Janelas
		oLayer:addLine( "LINHA1", 100, .F. )

		//FATURA
		oLayer:AddCollumn( "Jan1", 100, .F. ,"LINHA1" )
		oLayer:AddWindow(  "Jan1", "oJan1", "Dados do Pedido ", 100, .T., .F., { || }, "LINHA1", {|| } )
		oJan1 := oLayer:GetWinPanel("Jan1", "oJan1", "LINHA1" )  

		oTreePed 		:= xTree():New( 0, 0, 0, 0, oJan1 )
		oTreePed:Align 	:= CONTROL_ALIGN_ALLCLIENT

		oTreePed:AddTree( "Pedido " + cPedGar, "FOLDER5", "FOLDER6", "ID_PRINCIPAL",,,{||})

		//Dados de cliente
		oTreePed:TreeSeek( "Cliente" )
		oTreePed:AddTree( "Cliente", "BMPVISUAL", "BMPVISUAL", "cliente",,,)

		For nA1:=1 to Len(aInfoSA1)	
			If SX3->(DbSeek(aInfoSA1[nA1,1]))
				If aInfoSA1[nA1,1] $ "A1_CGC, A1_CEP, A1_INSCR,A1_INSCRM, A1_SUFRAMA"
					oTreePed:AddTreeItem(Alltrim(X3Titulo())+": "+Alltrim(aInfoSA1[nA1,2]),"CHECKED","1."+Alltrim(Str(nA1)),,,{ | |	cCrg := StrTran(oTreePed:GetCargo(),"1.","")   ,;
					SX3->(DbSeek(aInfoSA1[Val(cCrg),1])) ,;
					cCtd := oTreePed:GetPrompt() ,; 
					nSub := Rat(":",cCtd),; 
					aInfoSA1[Val(cCrg),2] := AltPrompt(	@oTreePed,;
					oTreePed:GetCargo(),;
					Alltrim(X3Titulo())+": " ,;
					aInfoSA1[Val(cCrg),2] ),;
					IIF(aInfoSA1[Val(cCrg),1]=="A1_CGC",aInfoSC5[nPosC5Cgc,2] := aInfoSA1[Val(cCrg),2],""),;
					IIF(aInfoSA1[Val(cCrg),1]=="A1_CGC",aInfoSE1[nPosE1Cgc,2] := aInfoSA1[Val(cCrg),2],"") 	} )
				Else
					oTreePed:AddTreeItem( Alltrim( X3Titulo() ) + ": " + Alltrim( aInfoSA1[nA1,2]), "CHECKED", "1."+Alltrim( Str(nA1) ),,,)
				EndIf
			EndIf
		Next
		oTreePed:EndTree() 

		//Dados do Pedido
		oTreePed:TreeSeek( "Pedido" )
		oTreePed:AddTree( "Pedido", "BMPVISUAL", "BMPVISUAL", "pedido",,,)

		For nY:=1 to Len(aInfoSC5)	
			If SX3->(DbSeek(aInfoSC5[nY,1]))
				oTreePed:AddTreeItem(Alltrim(X3Titulo())+": "+Alltrim(aInfoSC5[nY,2]),"CHECKED","2."+Alltrim(Str(nY)),,,)
			EndIf
		Next
		oTreePed:EndTree() 

		//Dados do Produto
		oTreePed:TreeSeek("Produto")
		oTreePed:AddTree("Produto","BMPVISUAL","BMPVISUAL","produto",,,)

		For nJ:=1 to Len(aInfoSC6)	
			For nY:=1 to Len(aInfoSC6[nJ])	
				If SX3->(DbSeek(aInfoSC6[nJ,nY,1]))
					oTreePed:AddTreeItem(Alltrim(X3Titulo())+": "+Alltrim(aInfoSC6[nJ,nY,2]),"CHECKED","3."+Alltrim(Str(nY)),,,)
				EndIf
			Next
		Next
		oTreePed:EndTree() 

		//Dados do Título
		oTreePed:TreeSeek("Titulo")
		oTreePed:AddTree("Titulo","BMPVISUAL","BMPVISUAL","titulo",,,)

		For nY:=1 to Len(aInfoSE1)	
			If SX3->(DbSeek(aInfoSE1[nY,1]))
				oTreePed:AddTreeItem(Alltrim(X3Titulo())+": "+Alltrim(aInfoSE1[nY,2]),"CHECKED","4."+Alltrim(Str(nY)),,,)
			EndIf
		Next
		oTreePed:EndTree() 
		oTreePed:EndTree()

		ACTIVATE MSDIALOG oDlg CENTERED

		If nOpca == 1

			StartJob( "U_VNDA080P", GetEnvServer(), .F., "01", "02", cID, cPedGar, aInfoSA1, aInfoSC5, aInfoSC6, aInfoSE1 )

			U_GTPutIN( cID, "P", cPedGar, .T., { "U_VNDA080", cPedGar, aInfoSA1, aInfoSC5, aInfoSC6, aInfoSE1 } )
		EndIf
	Else
		cRootPath	:= "\" + CurDir()	//Pega o diretorio do RootPath
		cRootPath	:= cRootPath + "vendas_site\"

		If Len(cID) <= 18
			cArquivo	:= "Pedidos_" + Left(cID,12) + ".XML"
			lIdant			:= .T.
		Else
			cArquivo	:= "Pedidos_" + Left(cID,17) + ".XML"
			lIdant			:= .F.
		EndIf

		cArquivo	:= cRootPath + cArquivo

		If !File(cArquivo) 
			MsgStop("Não Existe Arquivo XML para Registro Selecionado.")
			Return(.F.)
		EndIf

		oXml := XmlParserFile( cArquivo, "_", @cError, @cWarning )

		If !Empty(cError)
			MsgStop( "Foram Encontradas Inconsistência no Arquivo XML" )
			Aviso( "XML", cError , { "OK" }, 3 ) 
			Return( .F. )
		EndIf

		If Valtype( oXml:_LISTPEDIDOFULLTYPE:_PEDIDO ) <> "A"
			XmlNode2Arr( oXml:_LISTPEDIDOFULLTYPE:_PEDIDO, "_PEDIDO" )
		EndIf

		If lIdant
			nLenXml := Len( oXml:_LISTPEDIDOFULLTYPE:_PEDIDO )
			If nLenXml > 1
				For nPed := 1 to nLenXml
					If cNpSite == AllTrim( oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_NUMERO:TEXT )
						oXmlPed := oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]
						Exit	
					EndIf
				Next
			Else
				oXmlPed := oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[1] 
				nPed 	:= 1 
			EndIf
		Else
			nPed := Val( Right( alltrim( cID ), 6 ) )
			If Valtype(nPed) == "N" .and. nPed > 0
				oXmlPed := oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed] 
			Else
				MsgStop( "Foram Encontradas Inconsistência após abertura do Arquivo XML" )
				Return( .F. )
			EndIf
		EndIf
		DEFINE MSDIALOG oDlg TITLE "Manutenção Pedido Site" FROM aCoord[1],aCoord[2] TO aCoord[3], aCoord[4] PIXEL
		EnchoiceBar( oDlg, {|| nOpca := 1, oDlg:End() }, {|| nOpca := 2,oDlg:End() },, aButtons )

		// Cria Objeto de Layer
		oLayer := FWLayer():New()
		oLayer:Init( oDlg, .F., .T. ) 

		//Monta as Janelas
		oLayer:addLine( "LINHA1", 100, .F. )

		//FATURA
		oLayer:AddCollumn( "Jan1", 100, .F., "LINHA1")
		oLayer:AddWindow( "Jan1", "oJan1", "Dados do Pedido ", 100, .T., .F., { || }, "LINHA1", {|| })
		oJan1 := oLayer:GetWinPanel("Jan1","oJan1","LINHA1")  

		oTreePed 		:= xTree():New( 0, 0, 0, 0, oJan1 )
		oTreePed:Align 	:= CONTROL_ALIGN_ALLCLIENT

		oTreePed:AddTree( "Pedido " + cNpSite, "FOLDER5", "FOLDER6", "ID_PRINCIPAL",,,{||})

		//Dados de Contato
		oTreePed:TreeSeek( "Contato" )
		oTreePed:AddTree( "Contato", "BMPVISUAL", "BMPVISUAL", "contato",,,)
		oTreePed:AddTreeItem( "Cpf ou Cgc: " + oXmlPed:_CONTATO:_CPF:TEXT  , "CHECKED", "1.1",,, {|| oXmlPed:_CONTATO:_NOME:TEXT 	:= AltPrompt(@oTreePed,"1.1","Cpf ou Cgc: ", oXmlPed:_CONTATO:_CPF:TEXT)  , oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_CPF:TEXT   := oXmlPed:_CONTATO:_CPF:TEXT 	} )
		oTreePed:AddTreeItem( "Email: "      + oXmlPed:_CONTATO:_EMAIL:TEXT, "CHECKED", "1.2",,, {|| oXmlPed:_CONTATO:_EMAIL:TEXT 	:= AltPrompt(@oTreePed,"1.2","Email:"      , oXmlPed:_CONTATO:_EMAIL:TEXT), oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_EMAIL:TEXT := oXmlPed:_CONTATO:_EMAIL:TEXT	} )
		oTreePed:AddTreeItem( "Fone: "       + oXmlPed:_CONTATO:_FONE:TEXT , "CHECKED", "1.3",,, {|| oXmlPed:_CONTATO:_FONE:TEXT 	:= AltPrompt(@oTreePed,"1.3","Fone: "      , oXmlPed:_CONTATO:_FONE:TEXT) , oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_FONE:TEXT  := oXmlPed:_CONTATO:_FONE:TEXT	} )
		oTreePed:AddTreeItem( "Nome: "       + oXmlPed:_CONTATO:_NOME:TEXT , "CHECKED", "1.4",,, {|| oXmlPed:_CONTATO:_NOME:TEXT	:= AltPrompt(@oTreePed,"1.4","Nome: "      , oXmlPed:_CONTATO:_NOME:TEXT) , oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_NOME:TEXT  := oXmlPed:_CONTATO:_NOME:TEXT	} )
		oTreePed:EndTree() 

		//Dados de Faturamento
		oTreePed:TreeSeek("Fatura")
		oTreePed:AddTree("Fatura","BMPVISUAL","BMPVISUAL","fatura",,,)
		oTreePed:AddTreeItem( "Data: " + oXmlPed:_DATA:TEXT, "CHECKED", "2.1",,, { || oXmlPed:_DATA:TEXT := AltPrompt( @oTreePed, "2.1", "Data: ", oXmlPed:_DATA:TEXT ), oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_DATA:TEXT := oXmlPed:_DATA:TEXT } )		

		//Valida informações de PF ou PJ
		If "PF" $ oXmlPed:_FATURA:_XSI_TYPE:TEXT
			oTreePed:AddTreeItem( "Nome: " + oXmlPed:_FATURA:_NOME:TEXT, "CHECKED", "2.2",,, { || oXmlPed:_FATURA:_NOME:TEXT := AltPrompt( @oTreePed, "2.2", "Nome: ", oXmlPed:_FATURA:_NOME:TEXT ), oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_NOME:TEXT := oXmlPed:_FATURA:_NOME:TEXT } )		
			oTreePed:AddTreeItem( "Cpf: "  + oXmlPed:_FATURA:_CPF:TEXT , "CHECKED", "2.3",,, { || oXmlPed:_FATURA:_CPF:TEXT  := AltPrompt( @oTreePed, "2.3", "Cpf: " , oXmlPed:_FATURA:_CPF:TEXT  ), oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_CPF:TEXT  := oXmlPed:_FATURA:_CPF:TEXT  } )
		Else
			oTreePed:AddTreeItem( "Razão Social: " + oXmlPed:_FATURA:_RZSOCIAL:TEXT, "CHECKED", "2.2",,, { || oXmlPed:_FATURA:_RZSOCIAL:TEXT := AltPrompt( @oTreePed, "2.2", "Razão Social: "	, oXmlPed:_FATURA:_RZSOCIAL:TEXT) , oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_RZSOCIAL:TEXT := oXmlPed:_FATURA:_RZSOCIAL:TEXT } )
			oTreePed:AddTreeItem( "CNPJ: "		   + oXmlPed:_FATURA:_CNPJ:TEXT    , "CHECKED", "2.4",,, { || oXmlPed:_FATURA:_CNPJ:TEXT 	:= AltPrompt( @oTreePed, "2.4", "CNPJ: "			, oXmlPed:_FATURA:_CNPJ:TEXT	) , oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_CNPJ:TEXT 	  := oXmlPed:_FATURA:_CNPJ:TEXT   	} )
			oTreePed:AddTreeItem( "Inscr. Est.: "  + oXmlPed:_FATURA:_INSCEST:TEXT , "CHECKED", "2.5",,, { || oXmlPed:_FATURA:_INSCEST:TEXT 	:= AltPrompt( @oTreePed, "2.5", "Inscr. Est.: " , oXmlPed:_FATURA:_INSCEST:TEXT	) , oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_INSCEST:TEXT  := oXmlPed:_FATURA:_INSCEST:TEXT 	} )
			oTreePed:AddTreeItem( "Inscr. Mun.: "  + oXmlPed:_FATURA:_INSCMUN:TEXT , "CHECKED", "2.6",,, { || oXmlPed:_FATURA:_INSCMUN:TEXT 	:= AltPrompt( @oTreePed, "2.6", "Inscr. Mun.: " , oXmlPed:_FATURA:_INSCMUN:TEXT	) , oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_INSCMUN:TEXT  := oXmlPed:_FATURA:_INSCMUN:TEXT 	} )
			oTreePed:AddTreeItem( "Suframa: "      + oXmlPed:_FATURA:_SUFRAMA:TEXT , "CHECKED", "2.7",,, { || oXmlPed:_FATURA:_SUFRAMA:TEXT 	:= AltPrompt( @oTreePed, "2.7", "Suframa: "		, oXmlPed:_FATURA:_SUFRAMA:TEXT	) , oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_SUFRAMA:TEXT  := oXmlPed:_FATURA:_SUFRAMA:TEXT 	} )
		EndIf

		oTreePed:AddTreeItem( "Email: " 		+ oXmlPed:_FATURA:_EMAIL:TEXT						, "CHECKED", "2.8" ,,, {|| oXmlPed:_FATURA:_EMAIL:TEXT						 := AltPrompt( @oTreePed, "2.8" , "Email: "			, oXmlPed:_FATURA:_EMAIL:TEXT) 					  	, oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_EMAIL:TEXT					   := oXmlPed:_FATURA:_EMAIL:TEXT						})
		oTreePed:AddTreeItem( "Bairro: " 		+ oXmlPed:_FATURA:_ENDERECO:_BAIRRO:TEXT			, "CHECKED", "2.9" ,,, {|| oXmlPed:_FATURA:_ENDERECO:_BAIRRO:TEXT			 := AltPrompt( @oTreePed, "2.9" , "Bairro: "		, oXmlPed:_FATURA:_ENDERECO:_BAIRRO:TEXT) 			, oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_BAIRRO:TEXT			   := oXmlPed:_FATURA:_ENDERECO:_BAIRRO:TEXT			})
		oTreePed:AddTreeItem( "Numero: " 		+ oXmlPed:_FATURA:_ENDERECO:_NUMERO:TEXT			, "CHECKED", "2.10",,, {|| oXmlPed:_FATURA:_ENDERECO:_NUMERO:TEXT			 := AltPrompt( @oTreePed, "2.10", "Numero: "		, oXmlPed:_FATURA:_ENDERECO:_NUMERO:TEXT) 			, oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_NUMERO:TEXT			   := oXmlPed:_FATURA:_ENDERECO:_NUMERO:TEXT			})                                                                                                              
		oTreePed:AddTreeItem( "CEP: " 			+ oXmlPed:_FATURA:_ENDERECO:_CEP:TEXT				, "CHECKED", "2.11",,, {|| oXmlPed:_FATURA:_ENDERECO:_CEP:TEXT 				 := AltPrompt( @oTreePed, "2.11", "CEP: "			, oXmlPed:_FATURA:_ENDERECO:_CEP:TEXT) 			  	, oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_CEP:TEXT 			   := oXmlPed:_FATURA:_ENDERECO:_CEP:TEXT				})  
		oTreePed:AddTreeItem( "Cidade: " 		+ oXmlPed:_FATURA:_ENDERECO:_CIDADE:_NOME:TEXT		, "CHECKED", "2.12",,, {|| oXmlPed:_FATURA:_ENDERECO:_CIDADE:_NOME:TEXT 	 := AltPrompt( @oTreePed, "2.12", "Cidade: "		, oXmlPed:_FATURA:_ENDERECO:_CIDADE:_NOME:TEXT)  	, oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_CIDADE:_NOME:TEXT 	   := oXmlPed:_FATURA:_ENDERECO:_CIDADE:_NOME:TEXT		})
		oTreePed:AddTreeItem( "Estado: " 		+ oXmlPed:_FATURA:_ENDERECO:_CIDADE:_UF:_SIGLA:TEXT	, "CHECKED", "2.13",,, {|| oXmlPed:_FATURA:_ENDERECO:_CIDADE:_UF:_SIGLA:TEXT := AltPrompt( @oTreePed, "2.13", "Estado: "		, oXmlPed:_FATURA:_ENDERECO:_CIDADE:_UF:_SIGLA:TEXT), oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_CIDADE:_UF:_SIGLA:TEXT := oXmlPed:_FATURA:_ENDERECO:_CIDADE:_UF:_SIGLA:TEXT	})
		oTreePed:AddTreeItem( "Complemento: " 	+ oXmlPed:_FATURA:_ENDERECO:_COMPL:TEXT				, "CHECKED", "2.14",,, {|| oXmlPed:_FATURA:_ENDERECO:_COMPL:TEXT			 := AltPrompt( @oTreePed, "2.14", "Complemento: "	, oXmlPed:_FATURA:_ENDERECO:_COMPL:TEXT) 		  	, oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_COMPL:TEXT			   := oXmlPed:_FATURA:_ENDERECO:_COMPL:TEXT				})
		oTreePed:AddTreeItem( "Logradouro: " 	+ oXmlPed:_FATURA:_ENDERECO:_DESC:TEXT				, "CHECKED", "2.15",,, {|| oXmlPed:_FATURA:_ENDERECO:_DESC:TEXT				 := AltPrompt( @oTreePed, "2.15", "Logradouro: "	, oXmlPed:_FATURA:_ENDERECO:_DESC:TEXT) 			, oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_DESC:TEXT			   := oXmlPed:_FATURA:_ENDERECO:_DESC:TEXT				})
		oTreePed:AddTreeItem( "Fone: " 			+ oXmlPed:_FATURA:_ENDERECO:_FONE:TEXT				, "CHECKED", "2.16",,, {|| oXmlPed:_FATURA:_ENDERECO:_FONE:TEXT				 := AltPrompt( @oTreePed, "2.16", "Fone: "	 		, oXmlPed:_FATURA:_ENDERECO:_FONE:TEXT) 			, oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_FONE:TEXT			   := oXmlPed:_FATURA:_ENDERECO:_FONE:TEXT				})

		oTreePed:EndTree()

		//Dados de Pagamento
		oTreePed:TreeSeek("Pagamento")
		oTreePed:AddTree("Pagamento","BMPVISUAL","BMPVISUAL","pagamento",,,)

		//Forma de Pagamento
		If "cartao" $ oXmlPed:_PAGAMENTO:_XSI_TYPE:TEXT
			oTreePed:AddTreeItem("Cartão: "   + oXmlPed:_PAGAMENTO:_NUMERO:TEXT		   , "CHECKED", "3.1",,, {|| oXmlPed:_PAGAMENTO:_NUMERO:TEXT         := AltPrompt( @oTreePed, "3.1", "Cartão: "  , oXmlPed:_PAGAMENTO:_NUMERO:TEXT         ), oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_NUMERO:TEXT         := oXmlPed:_PAGAMENTO:_NUMERO:TEXT         } )
			oTreePed:AddTreeItem("Validade: " + oXmlPed:_PAGAMENTO:_DTVALID:TEXT	   , "CHECKED", "3.3",,, {|| oXmlPed:_PAGAMENTO:_DTVALID:TEXT        := AltPrompt( @oTreePed, "3.3", "Validade: ", oXmlPed:_PAGAMENTO:_DTVALID:TEXT        ), oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_DTVALID:TEXT        := oXmlPed:_PAGAMENTO:_DTVALID:TEXT        } )
			oTreePed:AddTreeItem("Tipo: "     + oXmlPed:_PAGAMENTO:_XSI_TYPE:TEXT	   , "CHECKED", "3.4",,, {|| oXmlPed:_PAGAMENTO:_XSI_TYPE:TEXT       := AltPrompt( @oTreePed, "3.4", "Tipo: "    , oXmlPed:_PAGAMENTO:_XSI_TYPE:TEXT       ), oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_XSI_TYPE:TEXT       := oXmlPed:_PAGAMENTO:_XSI_TYPE:TEXT       } )
		ElseIf "boleto" $ oXmlPed:_PAGAMENTO:_XSI_TYPE:TEXT
			oTreePed:AddTreeItem("Boleto: "   + oXmlPed:_PAGAMENTO:_LINHADIGITAVEL:TEXT, "CHECKED", "3.1",,, {|| oXmlPed:_PAGAMENTO:_LINHADIGITAVEL:TEXT := AltPrompt( @oTreePed, "3.1", "Boleto: "  , oXmlPed:_PAGAMENTO:_LINHADIGITAVEL:TEXT ), oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_LINHADIGITAVEL:TEXT := oXmlPed:_PAGAMENTO:_LINHADIGITAVEL:TEXT } )
		ElseIf "voucher" $ oXmlPed:_PAGAMENTO:_XSI_TYPE:TEXT
			oTreePed:AddTreeItem("Voucher: "  + oXmlPed:_PAGAMENTO:_NUMERO:TEXT	   	   , "CHECKED", "3.1",,, {|| oXmlPed:_PAGAMENTO:_NUMERO:TEXT         := AltPrompt( @oTreePed, "3.1", "Voucher: " , oXmlPed:_PAGAMENTO:_NUMERO:TEXT         ), oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_NUMERO:TEXT         := oXmlPed:_PAGAMENTO:_NUMERO:TEXT         } )
			oTreePed:AddTreeItem("Qtd: "      + oXmlPed:_PAGAMENTO:_QTCONSUMIDA:TEXT   , "CHECKED", "3.2",,, {|| oXmlPed:_PAGAMENTO:_QTCONSUMIDA:TEXT    := AltPrompt( @oTreePed, "3.2", "Qtd: "     , oXmlPed:_PAGAMENTO:_QTCONSUMIDA:TEXT    ), oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_QTCONSUMIDA:TEXT    := oXmlPed:_PAGAMENTO:_QTCONSUMIDA:TEXT    } )		
		EndIf
		oTreePed:EndTree()

		//Dados de Produto
		oTreePed:TreeSeek("Produto")
		oTreePed:AddTree("Produto","BMPVISUAL","BMPVISUAL","produto",,,)

		//Forma de Pagamento
		If valtype( oXmlPed:_PRODUTO ) == "O"
			oTreePed:AddTreeItem("Id: "             + oXmlPed:_PRODUTO:_ID:TEXT	        , "CHECKED", "4.01",,, {|| oXmlPed:_PRODUTO:_ID:TEXT          := AltPrompt( @oTreePed, "4.01", "Id: "            , oXmlPed:_PRODUTO:_ID:TEXT         ), oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO:_ID:TEXT          := oXmlPed:_PRODUTO:_ID:TEXT            } )
			oTreePed:AddTreeItem("Código Produto: " + oXmlPed:_PRODUTO:_CODPROD:TEXT	, "CHECKED", "4.02",,, {|| oXmlPed:_PRODUTO:_CODPROD:TEXT     := AltPrompt( @oTreePed, "4.02", "Código Produto: ", oXmlPed:_PRODUTO:_CODPROD:TEXT    ), oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO:_CODPROD:TEXT     := oXmlPed:_PRODUTO:_CODPROD:TEXT       } )
			oTreePed:AddTreeItem("Descrição: "      + oXmlPed:_PRODUTO:_DESCRICAO:TEXT  , "CHECKED", "4.03",,, {|| oXmlPed:_PRODUTO:_DESCRICAO:TEXT   := AltPrompt( @oTreePed, "4.03", "Descrição: "     , oXmlPed:_PRODUTO:_DESCRICAO:TEXT  ), oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO:_DESCRICAO:TEXT   := oXmlPed:_PRODUTO:_DESCRICAO:TEXT     } )
			oTreePed:AddTreeItem("Qtd: "            + oXmlPed:_PRODUTO:_QTD:TEXT		, "CHECKED", "4.04",,, {|| oXmlPed:_PRODUTO:_QTD:TEXT         := AltPrompt( @oTreePed, "4.04", "Qtd: "           , oXmlPed:_PRODUTO:_QTD:TEXT        ), oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO:_QTD:TEXT         := oXmlPed:_PRODUTO:_QTD:TEXT           } )
			oTreePed:AddTreeItem("Valor Unitário: " + oXmlPed:_PRODUTO:_VLUNITARIO:TEXT , "CHECKED", "4.05",,, {|| oXmlPed:_PRODUTO:_VLUNITARIO:TEXT  := AltPrompt( @oTreePed, "4.05", "Valor Unitário: ", oXmlPed:_PRODUTO:_VLUNITARIO:TEXT ), oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO:_VLUNITARIO:TEXT  := oXmlPed:_PRODUTO:_VLUNITARIO:TEXT    } )
			oTreePed:AddTreeItem("Valor  Total: "   + oXmlPed:_PRODUTO:_VLTOTAL:TEXT	, "CHECKED", "4.06",,, {|| oXmlPed:_PRODUTO:_VLTOTAL:TEXT     := AltPrompt( @oTreePed, "4.06", "Valor  Total: "  , oXmlPed:_PRODUTO:_VLTOTAL:TEXT    ), oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO:_VLTOTAL:TEXT     := oXmlPed:_PRODUTO:_VLTOTAL:TEXT       } )
			oTreePed:AddTreeItem("Tabela Preço: "   + oXmlPed:_PRODUTO:_TABELAPRECO:TEXT, "CHECKED", "4.07",,, {|| oXmlPed:_PRODUTO:_TABELAPRECO:TEXT := AltPrompt( @oTreePed, "4.07", "Tabela Preço: "  , oXmlPed:_PRODUTO:_TABELAPRECO:TEXT), oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO:_TABELAPRECO:TEXT := oXmlPed:_PRODUTO:_TABELAPRECO:TEXT   } )
			oTreePed:AddTreeItem("Código B Pag: "   + oXmlPed:_PRODUTO:_CODBPAG:TEXT    , "CHECKED", "4.08",,, {|| oXmlPed:_PRODUTO:_CODBPAG:TEXT     := AltPrompt( @oTreePed, "4.08", "Código B Pag: "  , oXmlPed:_PRODUTO:_CODBPAG:TEXT    ), oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO:_CODBPAG:TEXT     := oXmlPed:_PRODUTO:_CODBPAG:TEXT       } )
			oTreePed:AddTreeItem("Código Combo: "   + oXmlPed:_PRODUTO:_CODCOMBO:TEXT	, "CHECKED", "4.09",,, {|| oXmlPed:_PRODUTO:_CODCOMBO:TEXT    := AltPrompt( @oTreePed, "4.09", "Código Combo: "  , oXmlPed:_PRODUTO:_CODCOMBO:TEXT   ), oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO:_CODCOMBO:TEXT    := oXmlPed:_PRODUTO:_CODCOMBO:TEXT      } )
			oTreePed:AddTreeItem("Grupo: "          + oXmlPed:_PRODUTO:_GRUPO:TEXT	    , "CHECKED", "4.10",,, {|| oXmlPed:_PRODUTO:_GRUPO:TEXT       := AltPrompt( @oTreePed, "4.10", "Preço: "         , oXmlPed:_PRODUTO:_GRUPO:TEXT      ), oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO:_GRUPO:TEXT       := oXmlPed:_PRODUTO:_GRUPO:TEXT         } )
			oTreePed:AddTreeItem("Grupo Preço: "    + oXmlPed:_PRODUTO:_GRUPOPRECO:TEXT , "CHECKED", "4.11",,, {|| oXmlPed:_PRODUTO:_GRUPOPRECO:TEXT  := AltPrompt( @oTreePed, "4.11", "Grupo Preço: "   , oXmlPed:_PRODUTO:_GRUPOPRECO:TEXT ), oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO:_GRUPOPRECO:TEXT  := oXmlPed:_PRODUTO:_GRUPOPRECO:TEXT    } )
		EndIf
		oTreePed:EndTree()
		oTreePed:EndTree()

		ACTIVATE MSDIALOG oDlg CENTERED

		If nOpca == 1
			cArquivoBKP := SubStr(cArquivo,1,Len(cArquivo)-4)+"_"+DtoS(Date())+"_"+StrTran(Time(),":","")+".XML"
			If File(cArquivo) .and. _CopyFile(cArquivo,cArquivoBKP)
				U_GTPutIN(cID,"Y",cNpSite,.T.,{"VNDA080","","Alteração Manual de XML por "+Upper(Alltrim(cUserName)),MemoRead(cArquivoBKP)},cNpSite)
				Ferase(cArquivo)

				//SAVE oXml XMLFILE cArquivo
				cXml := XML_VERSION + CRLF
				cXml += XmlSaveStr(oXml,,.F.)

				MemoWrite(cArquivo,cXml)

				If nRecIn > 0 .AND. lParambox
					cUpd := "UPDATE GTIN SET GT_DATE = '"+DtoS(Date())+"', GT_SEND = 'F', GT_INPROC = 'F' WHERE R_E_C_N_O_ = "+Alltrim(Str(nRecIn))
					If TcSqlExec(cUpd) < 0
						MsgAlert("Alteração para processamento não realizado. Verifique GTIN")
					EndIf
				Endif

				U_GTPutOUT(cID,"Y",cNpSite,{"VNDA080",{.T.,"M00001",cNpSite,MemoRead(cArquivo)}},cNpSite)
			Else

				MsgStop("Inconsistências ao Salvar o arquivo XML")
				Return(.F.)	

			EndIf
		EndIf
	EndIf
Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AltPrompt ºAutor  ³David (Opvs)        º Data ³  09/02/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função que Altera do dados no objeto tree                   º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AltPrompt(oTree,cCargo,cSay,cGet)
	Local cRet 		:= ""
	Local cAux		:= ""
	Local nOpca		:= 2
	Local oSay
	Local oGet

	cGet := Padr(cGet,60)

	cAux := Alltrim(cGet)

	DEFINE MSDIALOG oDlg TITLE "Alteração de Dados" FROM 008.2,003.3 TO 016,055 OF GETWNDDEFAULT()

	@ 01,1 Say oSay Prompt cSay Size 160,10 of oDlg Color CLR_HBLUE
	@ 01,10 MsGet oGet var cGet Size 070,10 of oDlg 

	TButton():New( 38, 020, "Confirmar",, {|| nOpca:=1, oDlg:End() }, 040, 012,,,, .T. )
	TButton():New( 38, 140, "Cancelar" ,, {|| nOpca:=2, oDlg:End() }, 040, 012,,,, .T. )

	ACTIVATE MSDIALOG oDlg CENTERED

	If nOpca == 1
		cRet	:= Alltrim(cGet)
		oTree:ChangePrompt(cSay+cRet,cCargo) 
	Else
		cRet 	:= cAux
	EndIf

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VNDA190P    ºAutor  ³Microsiga           º Data ³  17/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faturamento de Pedidos Manualmente                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VNDA080P( cEmpP, cFilP, cID, cPedGar, aInfoSA1, aInfoSC5, aInfoSC6, aInfoSE1 )
	//Abre empresa para Faturamento	
	RpcSetType( 3 )
	RpcSetEnv( cEmpP, cFilP )

	U_GARA110J( cID, cPedGar, aInfoSA1, aInfoSC5, aInfoSC6, aInfoSE1 )
Return