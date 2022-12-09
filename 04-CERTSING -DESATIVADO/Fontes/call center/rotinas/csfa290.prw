#Include 'Protheus.ch'
STATIC oGrdPE 
User Function CSFA290()
Return(MsgInfo('Rotina não disponível para execução do usuário.','Sistemas Corporativos'))
//-----------------------------------------------------------------------
// Rotina | A290FolCNPJ | Autor | Robson Gonçalves    | Data | 16.10.2013
//-----------------------------------------------------------------------
// Descr. | Rotina p/ criar o Folder e Getdados no cadastro do contrato.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A290FolCNPJ()
	Local nI := 0
	Local nOpc := 0
	Local nGd3 := 0
	Local nGd4 := 0
	Local nElem := 0
	Local nLoop := 0
	Local nFolder := 0
	
	Local cX3_RELACAO := ''
	
	Local aSize := MsAdvSize()
	Local aPosObj := {}
	Local aObjects := {}
	
	Private aHeadPE := {}
	Private aCOLSPE := {}
	
	aAdd( aObjects, {   0, 119, .T., .T. } )
	aAdd( aObjects, { 120, 101, .T., .T. } )
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )

	nGd3 := aPosObj[2,3]-aPosObj[2,1]-15
	nGd4 := aPosObj[2,4]-aPosObj[2,2]-2

	nOpc := ParamIXB[1]
	
	aHeadPE := APBuildHeader( 'PAC' )
	
	If nOpc == 3
		AAdd( aCOLSPE, Array( Len( aHeadPE ) + 1 ) )
		For nI := 1 To Len( aHeadPE )
			aCOLSPE[1,nI] := CriaVar(aHeadPE[nI,2],.F.)
		Next nI
		aCOLSPE[ 1, GdFieldPos('PAC_ITEM',aHeadPE) ] := StrZero(1,Len(PAC->PAC_ITEM))
		aCOLSPE[ 1, Len( aHeadPE ) + 1 ] := .F.
	Else
		PAC->( dbSetOrder( 1 ) )
		If PAC->( dbSeek( xFilial( 'PAC' ) + CN9->CN9_NUMERO ) )
			While PAC->( .NOT. EOF() ) .And. PAC->PAC_FILIAL==xFilial('PAC') .And. PAC->PAC_NUMERO==M->CN9_NUMERO
				AAdd( aCOLSPE, Array( Len( aHeadPE ) + 1 ) )
				nElem := Len( aCOLSPE )
				For nI := 1 To Len( aHeadPE )
					If aHeadPE[ nI, 10 ] == 'V'
						cX3_RELACAO := Posicione('SX3',2,aHeadPE[nI,2],'X3_RELACAO')
						aCOLSPE[ nElem, nI ] := &(cX3_RELACAO)
					Else
						aCOLSPE[ nElem, nI ] := PAC->( FieldGet( FieldPos( aHeadPE[ nI, 2 ] ) ) )
					Endif
				Next nI
				aCOLSPE[ nElem, Len( aHeadPE ) + 1 ] := .F.
				PAC->( dbSkip() )
			End
		Else
			AAdd( aCOLSPE, Array( Len( aHeadPE ) + 1 ) )
			For nI := 1 To Len( aHeadPE )
				aCOLSPE[1,nI] := CriaVar(aHeadPE[nI,2],.F.)
			Next nI
			aCOLSPE[ 1, GdFieldPos('PAC_ITEM',aHeadPE) ] := StrZero(1,Len(PAC->PAC_ITEM))
			aCOLSPE[ 1, Len( aHeadPE ) + 1 ] := .F.
		Endif
	Endif
	
	RegToMemory('PAC')
	oFolder:AddItem('Relacionar CNPJ', .T.)
	nFolder := Len( oFolder:aDialogs )
	oGrdPE := MsNewGetDados():New(2,2,nGd3,nGd4,GD_INSERT+GD_UPDATE+GD_DELETE,,,'+PAC_ITEM',,,999,,,,oFolder:aDialogs[nFolder],aHeadPE,aCOLSPE)
Return
//-----------------------------------------------------------------------
// Rotina | A290GrvCNPJ | Autor | Robson Gonçalves    | Data | 16.10.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para carregar dados no aCOLS. Essa rotina é acionada
//        | pelo ponto de entrada CN100GRC depois da gravação dos dados
//        | do contrato.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A290GrvCNPJ( nOpc )
	Local nI := 0
	Local nJ := 0
	Local nCOLS := 0
	Local nCPOS := 0
	Local nPAC_ITEM := 0
	
	nCOLS := Len( oGrdPE:aCOLS )
	If nCOLS > 0	
		nCPOS := Len( oGrdPE:aHeader )
		nPAC_ITEM := GdFieldPos('PAC_ITEM',oGrdPE:aHeader)
		If nOpc==3
			For nI := 1 To nCOLS
				If .NOT. oGrdPE:aCOLS[nI,nCPOS+1]
					PAC->(RecLock('PAC',.T.))
					PAC->PAC_FILIAL := xFilial('PAC')
					PAC->PAC_NUMERO := M->CN9_NUMERO
					For nJ := 1 To nCPOS
						If oGrdPE:aHeader[nJ,10]<>'V'
							PAC->(FieldPut(FieldPos(oGrdPE:aHeader[nJ,2]),oGrdPE:aCOLs[nI,nJ]))
						Endif
					Next nJ
					PAC->(MsUnLock())
				Endif
			Next nI
		Elseif nOpc == 4
			PAC->(dbSetOrder(1))
			For nI := 1 To nCOLS
				If PAC->(dbSeek(xFilial('PAC')+M->CN9_NUMERO+oGrdPE:aCOLS[nI,nPAC_ITEM]))
					If .NOT. oGrdPE:aCOLS[nI,nCPOS+1]
						PAC->(RecLock('PAC',.F.))
						For nJ := 1 To nCPOS
							If oGrdPE:aHeader[nJ,10]<>'V'
								PAC->(FieldPut(FieldPos(oGrdPE:aHeader[nJ,2]),oGrdPE:aCOLs[nI,nJ]))
							Endif
						Next nJ
					Else
						PAC->(RecLock('PAC',.F.))
						PAC->(dbDelete())
					Endif
				Else
					If .NOT. oGrdPE:aCOLS[nI,nCPOS+1]
						PAC->(RecLock('PAC',.T.))
						PAC->PAC_FILIAL := xFilial('PAC')
						PAC->PAC_NUMERO := M->CN9_NUMERO
						For nJ := 1 To nCPOS
							If oGrdPE:aHeader[nJ,10]<>'V'
								PAC->(FieldPut(FieldPos(oGrdPE:aHeader[nJ,2]),oGrdPE:aCOLs[nI,nJ]))
							Endif
						Next nJ
					Endif
				Endif
				PAC->(MsUnLock())
			Next nI
		Elseif nOpc == 5
			PAC->(dbSetOrder(1))
			For nI := 1 To nCOLS
				If PAC->(dbSeek(xFilial('PAC')+M->CN9_NUMERO+oGrdPE:aCOLS[nI,nPAC_ITEM]))
					PAC->(RecLock('PAC',.F.))
					PAC->(dbDelete())
					PAC->(MsUnLock())
				Endif
			Next nI
		Endif
	Endif
Return
//-----------------------------------------------------------------------
// Rotina | A290NoRpt  | Autor | Robson Gonçalves     | Data | 16.10.2013
//-----------------------------------------------------------------------
// Descr. | Rotina p/ verificar se o dado informado já está na Getdados.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A290NoRpt(nCpo) //Can not repeat CNPJ.
	Local lRet := .T.
	Local nI :=0 
	Local nPAC_CNPJ := 0
	Local nPAC_CODIGO := 0
	
	If nCpo == 1 // CNPJ/CPF
		nPAC_CNPJ := GdFieldPos('PAC_CNPJ',oGrdPE:aHeader)
		For nI := 1 To Len(oGrdPE:aCOLS)
			If nI <> oGrdPE:nAt
				If M->PAC_CNPJ == oGrdPE:aCOLS[nI,nPAC_CNPJ]
					MsgAlert('O CNPJ/CPF informado já existe na linha: '+oGrdPE:aCOLS[nI,GdFieldPos('PAC_ITEM',oGrdPE:aHeader)]+'.','Checar CNPJ/CPF')
					lRet := .F.
					Exit
				Endif
			Endif
		Next nI
	Elseif nCpo == 2 // Código
		nPAC_CODIGO := GdFieldPos('PAC_CODIGO',oGrdPE:aHeader)
		nPAC_LOJA   := GdFieldPos('PAC_LOJA',oGrdPE:aHeader)
		For nI := 1 To Len(oGrdPE:aCOLS)
			If nI <> oGrdPE:nAt
				If M->PAC_CODIGO == oGrdPE:aCOLS[nI,nPAC_CODIGO]
					MsgAlert('O Código informado já existe na linha: '+oGrdPE:aCOLS[nI,GdFieldPos('PAC_ITEM',oGrdPE:aHeader)]+'.','Checar Código')
					lRet := .F.
					Exit
				Endif
			Endif
		Next nI
	Else
		MsgAlert('Opção inválida.')
		lRet := .F.
	Endif
Return(lRet)
//-----------------------------------------------------------------------
// Rotina | A290ExCp   | Autor | Robson Gonçalves     | Data | 08.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para verificar se o CNPJ existe no SA1, do contrário
//        | apenas avisa o usuário.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A290ExCp()
	Local aArea := {}
	aArea := SA1->(GetArea())
	SA1->(dbSetOrder(3))
	If .NOT. SA1->(dbSeek(xFilial('SA1')+U_CSFMTSA1(M->PAC_CNPJ)))
		MsgAlert('O CNPJ/CPF informado não foi localizado no cadastro de clientes e isso não impede de seguir com a informação.','Localizar CNPJ/CPF')
	Endif
	SA1->(RestArea(aArea))
Return(.T.)
//-----------------------------------------------------------------------
// Rotina | UPD290     | Autor | Robson Gonçalves     | Data | 16.10.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function UPD290()
	Local cModulo := 'GCT'
	Local bPrepar := {|| U_U290Ini() }
	Local nVersao := 01
	
	NGCriaUpd(cModulo,bPrepar,nVersao)
Return
//-----------------------------------------------------------------------
// Rotina | U290Ini    | Autor | Robson Gonçalves     | Data | 16.10.2013
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar do update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function U290Ini()
	aSIX := {}
	aSX2 := {}
	aSX3 := {}
	aSX7 := {}
	aHelp := {}

	AAdd(aSX2,{'PAC',NIL,'Relacao do CN9 com Outros CNPJ ','Relacao do CN9 com Outros CNPJ ','Relacao do CN9 com Outros CNPJ','E',''})
	
	AAdd(aSX3,{"PAC",NIL,"PAC_FILIAL","C",2,0,;
	           "Filial","Sucursal","Branch",;
	           "Filial do Sistema",;
	           "Sucursal",;
	           "Branch of the System",;
	           "@!",;
	           "",;
	           X3_NAOUSADO_USADO,;
	           "",;
	           "",1,X3_USADO_RESERV,"","",;
	           "U","N","","","",;
	           "",;
	           "",;
	           "",;
	           "",;
	           "","","","033","",;
	           "","","","","","","",""})
	
	AAdd(aHelp,{'PAC_FILIAL','Filial do sistema.'})
	
	AAdd(aSX3,{"PAC",NIL,"PAC_NUMERO","C",15,0,;
	           "Nº Contrato","Nº Contrato","Nº Contrato",;
	           "Numero do contrato",;
	           "Numero do contrato",;
	           "Numero do contrato",;
	           "@!",;
	           "",;
	           X3_NAOUSADO_USADO,;
	           "",;
	           "",0,X3_USADO_RESERV,"","",;
	           "U","N","V","R","",;
	           "",;
	           "",;
	           "",;
	           "",;
	           "","","","","",;
	           "","","","","N","N","",""})
	
	AAdd(aHelp,{'PAC_NUMERO','Numero relacionado com o contrato.'})

	AAdd(aSX3,{"PAC",NIL,"PAC_ITEM","C",3,0,;
	           "Item","Item","Item",;
	           "Item sequencial",;
	           "Item sequencial",;
	           "Item sequencial",;
	           "@!",;
	           "",;
	           X3_EMUSO_USADO,;
	           "",;
	           "",0,X3_USADO_RESERV,"","",;
	           "U","N","V","R","",;
	           "",;
	           "",;
	           "",;
	           "",;
	           "","","","","",;
	           "","","","","N","N","",""})
	
	AAdd(aHelp,{'PAC_ITEM','Item sequencial de CNPJ relacionados.'})

	AAdd(aSX3,{"PAC",NIL,"PAC_CNPJ","C",14,0,;
	           "CNPJ/CPF","CNPJ/CPF","CNPJ/CPF",;
	           "Numero do CNPJ/CPF",;
	           "Numero do CNPJ/CPF",;
	           "Numero do CNPJ/CPF",;
	           "@R 99.999.999/9999-99",;
	           "",;
	           X3_EMUSO_USADO,;
	           "",;
	           "DE4",0,X3_USADO_RESERV,"",;
	           "S","U","N","A","R","",;
	           "CGC(M->PAC_CNPJ).And.U_A290ExCp().And.U_A290NoRpt(1)",;
	           "",;
	           "",;
	           "",;
	           "",;
	           "","","","","",;
	           "","","","N","N","",""})
	
	AAdd(aHelp,{'PAC_CNPJ','Numero do CNPJ/CPF.'})

	AAdd(aSX3,{"PAC",NIL,"PAC_CODIGO","C",6,0,;
	          "Codigo","Codigo","Codigo",;
	          "Codigo do cliente",;
	          "Codigo do cliente",;
	          "Codigo do cliente",;
	          "@!",;
	          "",;
	          X3_EMUSO_USADO,;
	          "",;
	          "SA1",0,X3_USADO_RESERV,"",;
	          "S","U","N","A","R","",;
	          "ExistCpo('SA1',M->PAC_CODIGO,1).And.U_A290NoRpt(2)",;
	          "",;
	          "",;
	          "",;
	          "",;
	          "","","","","",;
	          "","","","N","N","",""})
	
	AAdd(aHelp,{'PAC_CODIGO','Codigo do cliente.'})

	AAdd(aSX3,{"PAC",NIL,"PAC_LOJA","C",2,0,;
	           "Loja","Loja","Loja",;
	           "Loja do cliente",;
	           "Loja do cliente",;
	           "Loja do cliente",;
	           "@!",;
	           "",;
	           X3_EMUSO_USADO,;
	           "",;
	           "",0,X3_USADO_RESERV,"",;
	           "","U","N","A","R","",;
	           "U_A290NoRpt(2)",;
	           "",;
	           "",;
	           "",;
	           "",;
	           "","","","","",;
	           "","","","N","N","",""})
	
	AAdd(aHelp,{'PAC_LOJA','Loja do cliente.'})

	AAdd(aSX3,{"PAC",NIL,"PAC_NOME","C",60,0,;
	           "Nome","Nome","Nome",;
	           "Nome do cliente",;
	           "Nome do cliente",;
	           "Nome do cliente",;
	           "@!",;
	           "",;
	           X3_EMUSO_USADO,;
	           "Iif(INCLUI,Space(Len(SA1->A1_NOME)),Posicione('SA1',1,xFilial('SA1')+PAC->(PAC_CODIGO+PAC_LOJA),'A1_NOME'))",;
	           "",0,X3_USADO_RESERV,"","",;
	           "U","N","A","R","",;
	           "",;
	           "",;
	           "",;
	           "",;
	           "","","","","","",;
	           "","","","N","N","",""})
	           
	AAdd(aHelp,{'PAC_NOME','Nome do cliente.'})

	aSIX := {}
	AAdd(aSIX,{"PAC","1","PAC_FILIAL+PAC_NUMERO+PAC_ITEM","Nº Contrato","Nº Contrato","Nº Contrato","U","","","S"})
	AAdd(aSIX,{"PAC","2","PAC_FILIAL+PAC_CNPJ"           ,"CNPJ/CPF"   ,"CNPJ/CPF"   ,"CNPJ/CPF"   ,"U","","","S"})
	AAdd(aSIX,{"PAC","3","PAC_FILIAL+PAC_CODIGO+PAC_LOJA","Codigo+Loja","Codigo+Loja","Codigo+Loja","U","","","S"})
	
	aSX7 := {}
	AAdd(aSX7,{"PAC_CNPJ"  ,"001","SA1->A1_COD" ,"PAC_CODIGO","P","S","SA1",3,"XFILIAL('SA1')+M->PAC_CNPJ"  ,"","U"})
	AAdd(aSX7,{"PAC_CNPJ"  ,"002","SA1->A1_LOJA","PAC_LOJA"  ,"P","S","SA1",3,"XFILIAL('SA1')+M->PAC_CNPJ"  ,"","U"})
	AAdd(aSX7,{"PAC_CNPJ"  ,"003","SA1->A1_NOME","PAC_NOME"  ,"P","S","SA1",3,"XFILIAL('SA1')+M->PAC_CNPJ"  ,"","U"})
	AAdd(aSX7,{"PAC_CODIGO","001","SA1->A1_LOJA","PAC_LOJA"  ,"P","S","SA1",1,"XFILIAL('SA1')+M->PAC_CODIGO","","U"})
	AAdd(aSX7,{"PAC_CODIGO","002","SA1->A1_CGC" ,"PAC_CNPJ"  ,"P","S","SA1",1,"XFILIAL('SA1')+M->PAC_CODIGO","","U"})
	AAdd(aSX7,{"PAC_CODIGO","003","SA1->A1_NOME","PAC_NOME"  ,"P","S","SA1",1,"XFILIAL('SA1')+M->PAC_CODIGO","","U"})
Return