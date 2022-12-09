#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

//-----------------------------------------------------------------------
// Rotina | CSGPE010  | Autor | Rafael Beghini       | Data | 10/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina de cadastro de Cargos publicos por funcionário.  
//        | Acionado no cadastro de funcionarios (Acoes relacionadas)
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CSGPE010()
	Private cCadastro := 'Funcionários - Cargos Publicos'
	
	IF SRA->RA_SITFOLH <> 'D'
		GPE10Mnt()	
	Else
		MsgStop('Atenção,' + CRLF + 'Opção não disponível para funcionários desligados e/ou transferidos!',cCadastro)
	EndIF
Return

//-----------------------------------------------------------------------
// Rotina | GPE10Mnt  | Autor | Rafael Beghini       | Data | 10/12/2015
//-----------------------------------------------------------------------
// Descr. | Execucao da rotina  
//        | 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function GPE10Mnt()	
	Local aRGB    := {72,145,145}
	Local aArea   := GetArea()
	Local cAliasA := 'ZZC'
	Local cNome   := ''
	Local dData   := ''
	Local nI      := 0
	Local nCOLS   := 0
	Local nOpc    := 0
	Local nOpcA   := 0
	Local oDlg
	Local oGet
	Local oPane1
	Local oPane2
	
	Private cCodigo  := ''
	Private nOpcImp  := 0 //-- 1
	Private aHeader  := {}
	Private aCOLS    := {}
	Private aButtons := {}
	
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cAliasA)

	While !EOF() .And. X3_ARQUIVO == cAliasA
		If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL .And. X3_CAMPO <> 'ZZC_MAT'
			aAdd( aHeader, { Trim(X3Titulo()),;
			X3_CAMPO,;
			X3_PICTURE,;
			X3_TAMANHO,;
			X3_DECIMAL,;
			X3_VALID,;
			X3_USADO,;
			X3_TIPO,;
			X3_ARQUIVO,;
			X3_CONTEXT})
		Endif
		dbSkip()
	End
	
	cCodigo := SRA->RA_MAT
	cNome   := SRA->RA_NOME
	dData   := SRA->RA_ADMISSA 
	
	dbSelectArea(cAliasA)
	dbSetOrder(1)
		//Se possui já cadastro do funcionario
	IF dbSeek(xFilial(cAliasA)+cCodigo)
		nOpc := 1
	Else
		nOpc := 2
	EndIF
	
	//Se for cadastro Novo inicia a aCOLS vazia
	If nOpc == 2
		nCOLS := 0
		aAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
		dbSelectArea("SX3")
		dbSetOrder(1)		
		dbSeek(cAliasA)
		While !EOF() .And. X3_ARQUIVO == cAliasA
			If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL .And. X3_CAMPO <> 'ZZC_MAT'
				nCOLS++
				aCOLS[1,nCOLS] := CriaVar(X3_CAMPO,.T.)
			Endif
			dbSkip()
		End
		aCOLS[1,nCOLS+1] := .F.
		aCOLS[1,GdFieldPos("ZZC_ITEM")] := "001"
	Else
		While !EOF() .And. ZZC->(ZZC_FILIAL+ZZC_MAT) == xFilial(cAliasA) + cCodigo
			aAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
			nCOLS++
			For nI := 1 To Len( aHeader )
				If aHeader[nI,10] == "V"
					aCOLS[nCOLS,nI] := CriaVar( aHeader[nI,2], .T. )
				Else
					aCOLS[nCOLS,nI] := FieldGet( FieldPos( aHeader[nI,2] ) )
				Endif
			Next nI
			aCOLS[ nCOLS, Len( aCOLS[ nCOLS ] ) ] := .F.
			dbSkip()
		End
	Endif
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From 0,0 To 500,1000 OF oMainWnd PIXEL 
	
		Aadd( aButtons, {"HISTORIC", {|| U_GPE10Imp(nOpcImp)}, "Relatório...", "Relatório" , {|| .T.}} ) 
		//oDlg:lMaximized := .T.
		
		oTPane1          := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
		oTPane1:Align    := CONTROL_ALIGN_TOP
		oTPane1:NCLRPANE := RGB(aRGB[1],aRGB[2],aRGB[3])
		
		@ 4, 006 SAY "Matrícula:"  SIZE 070,7 PIXEL OF oTPane1
		@ 4, 062 SAY "Nome:"       SIZE 100,7 PIXEL OF oTPane1
		@ 4, 205 SAY "Admissão:"   SIZE 070,7 PIXEL OF oTPane1

		@ 3, 030 MSGET cCodigo When .F.  SIZE 030,7 PIXEL OF oTPane1
		@ 3, 080 MSGET cNome   When .F.  SIZE 120,7 PIXEL OF oTPane1
		@ 3, 235 MSGET dData   When .F.  SIZE 040,7 PIXEL OF oTPane1

		oTPane2          := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
		oTPane2:Align    := CONTROL_ALIGN_BOTTOM
		oTPane2:NCLRPANE := RGB(aRGB[1],aRGB[2],aRGB[3])

		oGet := MSGetDados():New(0,0,0,0,4,"U_GPE10LOk()","U_GPE10TOk()","+ZZC_ITEM",.T.)
		oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar( oDlg, {|| IIF((nOpc==1.Or.nOpc==2),(nOpcA:=1,oDlg:End()),NIL)}, {|| oDlg:End() }, , @aButtons )

	// Se clicado em Ok
	IF nOpcA == 1
		IF nOpc == 1 .Or. nOpc == 2
			Begin Transaction
				U_GPE10Grv(cAliasA)
			End Transaction
		EndIF
	EndIF

	RestArea(aArea)
Return

//-----------------------------------------------------------------------
// Rotina | GPE10LOk  | Autor | Rafael Beghini       | Data | 10/12/2015
//-----------------------------------------------------------------------
// Descr. | Validacao da Linha no Tudo OK  
//        | 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function GPE10LOk()
	Local lRet := .T.
	Local lMsg := .F.
	Local cMsg := ""
	
	//Se a linha nao estiver deletada.
	If !aCOLS[n,Len(aHeader)+1]
		If Empty(aCOLS[n,GdFieldPos("ZZC_NOME")])
			cMsg += "Campo NOME preenchimento Obrigatorio." + CRLF
			lMsg := .T.
		Endif
		If Empty(aCOLS[n,GdFieldPos("ZZC_GRAUP")])
			cMsg += "Campo GRAU PARENTESCO preenchimento Obrigatorio." + CRLF
			lMsg := .T.
		Endif
		If Empty(aCOLS[n,GdFieldPos("ZZC_ORGAO")])
			cMsg += "Campo ORGAO PUBLICO preenchimento Obrigatorio." + CRLF
			lMsg := .T.
		Endif
		If Empty(aCOLS[n,GdFieldPos("ZZC_CARGO")])
			cMsg += "Campo CARGO PUBLICO preenchimento Obrigatorio." + CRLF
			lMsg := .T.
		Endif
		   
		IF lMsg
			MsgAlert('Atenção,' + CRLF + cMsg,'GPE10LOk | Validação Cargos Publicos')
			lRet := .F.
		Endif
	EndIF
Return( lRet )

//-----------------------------------------------------------------------
// Rotina | GPE10TOk  | Autor | Rafael Beghini       | Data | 10/12/2015
//-----------------------------------------------------------------------
// Descr. | Validacao no TUDO OK  
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function GPE10TOk()
	Local lRet := .T.
	lRet := GPE10LOk()
Return( lRet )

//-----------------------------------------------------------------------
// Rotina | GPE10Grv  | Autor | Rafael Beghini       | Data | 10/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina para gravacao dos Dados  
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function GPE10Grv(cAliasA)
	Local lRet := .T.
	Local lOk  := .T.
	Local nI   := 0
	Local nY   := 0
	Local cVar := ""
	Local cMsg := ""
	
	dbSelectArea(cAliasA)
	dbSetOrder(1)
	
	For nI := 1 To Len(aCols)
		dbSeek( xFilial(cAliasA) + cCodigo + aCOLS[nI,GdFieldPos("ZZC_ITEM")] )
		
		If !aCOLS[nI,Len(aHeader)+1]            
			If Found()
				RecLock(cAliasA,.F.)
			Else
				RecLock(cAliasA,.T.)
			Endif
		      
			ZZC->ZZC_FILIAL := xFilial(cAliasA)
			ZZC->ZZC_MAT    := cCodigo
			ZZC->ZZC_ITEM   := aCOLS[nI,GdFieldPos("ZZC_ITEM")]
			ZZC->ZZC_NOME   := aCOLS[nI,GdFieldPos("ZZC_NOME")]
			ZZC->ZZC_GRAUP  := aCOLS[nI,GdFieldPos("ZZC_GRAUP")]
			ZZC->ZZC_ORGAO  := aCOLS[nI,GdFieldPos("ZZC_ORGAO")]
			ZZC->ZZC_CARGO  := aCOLS[nI,GdFieldPos("ZZC_CARGO")]
		  
			For nY = 1 to Len(aHeader)
				If aHeader[nY][10] # "V"
					cVar := Trim(aHeader[nY][2])
					Replace &cVar. With aCOLS[nI][nY]
				Endif
			Next nY
			MsUnLock(cAliasA)      
		Else
			If !Found()
				Loop
			Endif
			//Fazer pesquisa para saber se o item poderar ser deletado e
			If lOk
				RecLock(cAliasA,.F.)
				dbDelete()
				MsUnLock(cAliasA)
			Endif
		Endif
	Next nI
Return( lRet )

//-----------------------------------------------------------------------
// Rotina | GPE10Imp  | Autor | Rafael Beghini       | Data | 10/12/2015
//-----------------------------------------------------------------------
// Descr. | Impressao do relatório  
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function GPE10Imp(nOpcImp)
	Private cPerg:= "CSGPE010"
	Private oReport  := Nil
	Private oBreak   := Nil
	Private oSecCab  := Nil
	Private oSecItem := Nil
	
	Default nOpcImp := 0
	
	IF nOpcImp == 0	
		//Incluo/Altero as perguntas na tabela SX1
		AjustaSX1(cPerg)	
		//gero a pergunta de modo oculto, ficando disponível no botão ações relacionadas
		Pergunte(cPerg,.F.)	          
	EndIF
	
	ReportDef(nOpcImp)
	oReport:PrintDialog()	
Return Nil

//+------------------------------------------------------------------+
//| Rotina | ReportDef | Autor | Rafael Beghini | Data | 10/12/2015  |
//+------------------------------------------------------------------+
//| Descr. | Definição da estrutura do relatório.			         |
//|        | 		                                                 |
//+------------------------------------------------------------------+
//| Uso    | Recursos Humanos			                             |
//+------------------------------------------------------------------+
Static Function ReportDef(nOpcImp)
	Local aOrd := {}
	
	aAdd( aOrd, "Matrícula + Item" )
	aAdd( aOrd, "Matrícula + Nome" )
	
	oReport := TReport():New("CSGPE010",'Funcionários - Cargos Publicos',IIF(nOpcImp==0,cPerg,),;
			   {|oReport| PrintReport(oReport, aOrd, nOpcImp)},;
			   "Este relatório irá imprimir o relatório de Cargos Públicos conforme funcionário posicionado.")
	
	oReport:cFontBody:= 'Consolas'
	oReport:nFontBody:= 7
	oReport:nLineHeight:= 30
	oReport:SetPortrait(.T.)  //Retrato - oReport:SetLandscape(.T.) //Paisagem
	
	oSecCab := TRSection():New( oReport , 'Funcionários - Cargos Publicos', {"QRY"}, aOrd, .F., .T.)

	TRCell():New( oSecCab, "ZZC_MAT"  , "QRY", 'Matrícula',"@!",015)
	TRCell():New( oSecCab, "RA_NOME"  , "QRY", 'Nome'     ,"@!",200)
	
	oSecItem := TRSection():New( oReport , 'Funcionários - Cargos Publicos', {"QRY"}, NIL, .F., .T.)
	
	TRCell():New( oSecItem, "ZZC_ITEM" , "QRY", 'Item'            ,"@!",010)
	TRCell():New( oSecItem, "ZZC_NOME" , "QRY", 'Nome do Familiar',"@!",100)
	TRCell():New( oSecItem, "ZZC_GRAUP", "QRY", 'Grau Parentesco' ,"@!",040)
	TRCell():New( oSecItem, "ZZC_ORGAO", "QRY", 'Órgão Público'   ,"@!",040)    
	TRCell():New( oSecItem, "ZZC_CARGO", "QRY", 'Cargo Público'   ,"@!",040)  

	oReport:SetTotalInLine(.F.)
	
	//Aqui, farei uma quebra  por seção
	oSecCab:SetPageBreak(.F.)
	oSecCab:SetTotalInLine(.F.)
	oSecCab:SetTotalText(" ")			

Return Nil

//+--------------------------------------------------------------------+
//| Rotina | PrintReport | Autor | Rafael Beghini | Data | 30/06/2014  |
//+--------------------------------------------------------------------+
//| Descr. | Executa a query para processamento do relatório.          |
//|        | 		                                                   |
//+--------------------------------------------------------------------+
//| Uso    | Recursos Humanos (Benefícios)                             |
//+--------------------------------------------------------------------+
Static Function PrintReport(oReport,aOrd, nOpcImp)
	Local cQuery     := ""
	Local cNcm      := ""
	
	cQuery += " SELECT " + CRLF 
	cQuery += "     ZZC_FILIAL " + CRLF 
	cQuery += "    ,ZZC_MAT " + CRLF 
	cQuery += "    ,RA_NOME " + CRLF 
	cQuery += "    ,ZZC_ITEM " + CRLF 
	cQuery += "    ,ZZC_NOME " + CRLF 
	cQuery += "    ,ZZC_GRAUP " + CRLF 
	cQuery += "    ,ZZC_ORGAO " + CRLF 
	cQuery += "    ,ZZC_CARGO " + CRLF
	cQuery += " FROM " + RetSqlName("ZZC") + " ZZC " + CRLF 
	
	cQuery += "  	LEFT JOIN " + RetSqlName("SRA") + " SRA " + CRLF 
	cQuery += "     ON RA_FILIAL = ZZC_FILIAL " + CRLF
	cQuery += "   	AND RA_MAT = ZZC_MAT " + CRLF 
	cQuery += "   	AND SRA.D_E_L_E_T_ = ' ' " + CRLF 
	
	cQuery += " WHERE " + CRLF
	IF nOpcImp == 1
		cQuery += " ZZC_MAT = '" + SRA->RA_MAT +  "' " + CRLF
	Else
		cQuery += " ZZC_MAT BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'" + CRLF
	EndIF
	cQuery += "   AND ZZC.D_E_L_E_T_ = ' ' " + CRLF             
	If oSecCab:GetOrder() == 1 
		cQuery += " ORDER BY ZZC_FILIAL, ZZC_MAT, ZZC_ITEM ASC " + CRLF
	Else
		cQuery += " ORDER BY ZZC_FILIAL, ZZC_MAT, ZZC_NOME ASC " + CRLF
	EndIF 
	cQuery := ChangeQuery(cQuery)
	
	
	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf
	
	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "QRY"	
	
	dbSelectArea("QRY")
	QRY->(dbGoTop())
	
	oReport:SetMeter(QRY->(LastRec()))	

	//Irei percorrer todos os meus registros
	While !Eof()
		
		If oReport:Cancel()
			Exit
		EndIf
	
		//inicializo a primeira seção
		oSecCab:Init()

		oReport:IncMeter()
					
		cNcm 	:= QRY->ZZC_MAT
		IncProc( "Imprimindo MATRÍCULA " + QRY->ZZC_MAT )
		
		//imprimo a primeira seção				
		oSecCab:Cell("ZZC_MAT"):SetValue(QRY->ZZC_MAT)
		oSecCab:Cell("RA_NOME"):SetValue(QRY->RA_NOME)				
		oSecCab:Printline()
		
		//inicializo a segunda seção
		oSecItem:init()
		
		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While QRY->ZZC_MAT == cNcm
			oReport:IncMeter()		
		
			//IncProc("Imprimindo produto "+alltrim(TRBNCM->B1_COD))
			oSecItem:Cell("ZZC_ITEM"):SetValue(QRY->ZZC_ITEM)
			oSecItem:Cell("ZZC_NOME"):SetValue(QRY->ZZC_NOME)
			oSecItem:Cell("ZZC_GRAUP"):SetValue(QRY->ZZC_GRAUP)			
			oSecItem:Cell("ZZC_ORGAO"):SetValue(QRY->ZZC_ORGAO)			
			oSecItem:Cell("ZZC_CARGO"):SetValue(QRY->ZZC_CARGO)			
			oSecItem:Printline()
	
 			QRY->(dbSkip())
 		EndDo		
 		//finalizo a segunda seção para que seja reiniciada para o proximo registro
 		oSecItem:Finish()
 		//imprimo uma linha para separar uma NCM de outra
 		oReport:ThinLine()
 		//finalizo a primeira seção
		oSecCab:Finish()
	Enddo
Return

//------------------------------------------------------------------
// Rotina | CSGPEUPD()  | Autor | Rafael Beghini | Data | 10/12/2015
//------------------------------------------------------------------
// Descr. | Rotina de update para criar as estruturas no dicionário
//        | de dados.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function CSGPEUPD()
	Local cModulo := 'GPE'
	Local bPrepar := {|| U_GPE10Ini() }
	Local nVersao := 01

	NGCriaUpd(cModulo,bPrepar,nVersao)
Return

//------------------------------------------------------------------
// Rotina | GPE10Ini   | Autor | Rafael Beghini | Data | 10/12/2015
//------------------------------------------------------------------
// Descr. | Estrutura de dados para criar o dicionário de dados.
//        | Tabela ZZC
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function GPE10Ini()
	aSX3 := {}
	aSX2 := {}
	aSIX := {}
	aHelp := {}
	
	// Criar a tabela.
	AAdd(aSX2,{'ZZC','','Cargos Publicos','Cargos Publicos','Cargos Publicos','E','',})
	
	// Criar índices.
	AAdd(aSIX,{'ZZC','1','ZZC_FILIAL+ZZC_MAT+ZZC_ITEM'         ,'Matricula + Item'  ,'Matricula + Item'  ,'Matricula + Item' ,'U','S'})
	AAdd(aSIX,{'ZZC','2','ZZC_FILIAL+ZZC_MAT+ZZC_NOME'         ,'Matricula + Nome'  ,'Matricula + Nome'  ,'Matricula + Nome' ,'U','S'})
	
	AAdd(aSX3,{	'ZZC',NIL,'ZZC_FILIAL','C',2,0,;                                                 //Alias,Ordem,Campo,Tipo,Tamanho,Decimais
					'Filial','Filial','Filial',;                                                //Tit. Port.,Tit.Esp.,Tit.Ing.
					'Filial do Sistema','Filial do Sistema','Filial do Sistema',;              //Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;                                                                                    //Picture
					'',;                                                                                      //Valid
					'€€€€€€€€€€€€€€€',;                                                                       //Usado
					'',;                                                                                      //Relacao
					'',0,'þA','','',;                                                                         //F3,Nivel,Reserv,Check,Trigger
					'U','N','V','R',' ',;                                                                     //Propri,Browse,Visual,Context,Obrigat
					'',;	                                                                                    //VldUser
					'','','',;                                                                                //Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                                                          //PictVar,When,Ini BRW,GRP SXG,Folder
					'N','','','',' ',' '})                                                                    //Pyme,CondSQL,ChkSQL,IdxSrv,Ortogra,IdxFld

	AAdd(aSX3,{	'ZZC',NIL,'ZZC_MAT','C',6,0,;                                                                  //Alias,Ordem,Campo,Tipo,Tamanho,Decimais
					'Matricula','Matricula','Matricula',;                                                     //Tit. Port.,Tit.Esp.,Tit.Ing.
					'Matricula do Funcionario','Matricula do Funcionario','Matricula do Funcionario',;        //Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;                                                                                      //Picture
					'',;                                                                                      //Valid
					'€€€€€€€€€€€€€€ ',;                                                                       //Usado
					'',;                                                                                      //Relacao
					'',0,'þA','','',;                                                                         //F3,Nivel,Reserv,Check,Trigger
					'U','S','V','R',' ',;                                                                     //Propri,Browse,Visual,Context,Obrigat
					'',;	                                                                                    //VldUser
					'','','',;                                                                                //Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                                                          //PictVar,When,Ini BRW,GRP SXG,Folder
					'N','','','','N','N'})                                                                    //Pyme,CondSQL,ChkSQL,IdxSrv,Ortogra,IdxFld

	AAdd(aSX3,{	'ZZC',NIL,'ZZC_ITEM','C',3,0,;                                                          //Alias,Ordem,Campo,Tipo,Tamanho,Decimais
					'Item','Item','Item',;                                          		            //Tit. Port.,Tit.Esp.,Tit.Ing.
					'Item','Item','Item',; 									                      //Desc. Port.,Desc.Esp.,Desc.Ing.
					'',;                                                                                      //Picture
					'',;                                                                                      //Valid
					'€€€€€€€€€€€€€€ ',;                                                                       //Usado
					'',;                                                                                      //Relacao
					'',0,'þA','','',;                                                                         //F3,Nivel,Reserv,Check,Trigger
					'U','S','V','R',' ',;                                                                     //Propri,Browse,Visual,Context,Obrigat
					'',;	                                                                                    //VldUser
					'','','',;                                                                                //Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                                                          //PictVar,When,Ini BRW,GRP SXG,Folder
					'N','','','','N','N'})                                                                    //Pyme,CondSQL,ChkSQL,IdxSrv,Ortogra,IdxFld

	AAdd(aSX3,{	'ZZC',NIL,'ZZC_NOME','C',40,0,;                                             	         //Alias,Ordem,Campo,Tipo,Tamanho,Decimais
					'Nome','Nome','Nome',;                                            //Tit. Port.,Tit.Esp.,Tit.Ing.
					'Nome do Familiar','Nome do Familiar','Nome do Familiar',;     //Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;                                                                                    //Picture
					'',;                                                                                      //Valid
					'€€€€€€€€€€€€€€ ',;                                                                       //Usado
					'',;                                                                                      //Relacao
					'',0,'þA','','',;                                                                         //F3,Nivel,Reserv,Check,Trigger
					'U','S','A','R',' ',;                                                                     //Propri,Browse,Visual,Context,Obrigat
					'',;	                                                                                    //VldUser
					'','','',;                                                                                //Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                                                          //PictVar,When,Ini BRW,GRP SXG,Folder
					'N','','','',' ',' '})                                                                    //Pyme,CondSQL,ChkSQL,IdxSrv,Ortogra,IdxFld

	AAdd(aSX3,{	'ZZC',NIL,'ZZC_GRAUP','C',20,0,;                                             	         //Alias,Ordem,Campo,Tipo,Tamanho,Decimais
					'Grau Parent.','Grau Parent.','Grau Parent.',;                                               //Tit. Port.,Tit.Esp.,Tit.Ing.
					'Grau Parentesco','Grau Parentesco','Grau Parentesco',;                                               //Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;			                                                                    //Picture
					'',;                                                                                   //Valid
					'€€€€€€€€€€€€€€ ',;                                                                       //Usado
					'',;                                                                                      //Relacao
					'',0,'þA','','',;                                                                         //F3,Nivel,Reserv,Check,Trigger
					'U','S','A','R',' ',;                                                                     //Propri,Browse,Visual,Context,Obrigat
					'',;	                                                                                    //VldUser
					'','','',;                                                                                //Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                                                          //PictVar,When,Ini BRW,GRP SXG,Folder
					'N','','','',' ',' '})                                                                    //Pyme,CondSQL,ChkSQL,IdxSrv,Ortogra,IdxFld

	AAdd(aSX3,{	'ZZC',NIL,'ZZC_ORGAO','C',30,0,;                                             	         //Alias,Ordem,Campo,Tipo,Tamanho,Decimais
					'Orgao','Orgao','Orgao',;                                               //Tit. Port.,Tit.Esp.,Tit.Ing.
					'Orgao Publico','Orgao Publico','Orgao Publico',;                                               //Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;			                                                                    //Picture
					'',;                                                                                   //Valid
					'€€€€€€€€€€€€€€ ',;                                                                       //Usado
					'',;                                                                                      //Relacao
					'',0,'þA','','',;                                                                         //F3,Nivel,Reserv,Check,Trigger
					'U','S','A','R',' ',;                                                                     //Propri,Browse,Visual,Context,Obrigat
					'',;	                                                                                    //VldUser
					'','','',;                                                                                //Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                                                          //PictVar,When,Ini BRW,GRP SXG,Folder
					'N','','','',' ',' '})                                                                    //Pyme,CondSQL,ChkSQL,IdxSrv,Ortogra,IdxFld	
	
	AAdd(aSX3,{	'ZZC',NIL,'ZZC_CARGO','C',30,0,;                                             	         //Alias,Ordem,Campo,Tipo,Tamanho,Decimais
					'Cargo','Cargo','Cargo',;                                               //Tit. Port.,Tit.Esp.,Tit.Ing.
					'Cargo Publico','Cargo Publico','Cargo Publico',;                                               //Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;			                                                                    //Picture
					'',;                                                                                   //Valid
					'€€€€€€€€€€€€€€ ',;                                                                       //Usado
					'',;                                                                                      //Relacao
					'',0,'þA','','',;                                                                         //F3,Nivel,Reserv,Check,Trigger
					'U','S','A','R',' ',;                                                                     //Propri,Browse,Visual,Context,Obrigat
					'',;	                                                                                    //VldUser
					'','','',;                                                                                //Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                                                          //PictVar,When,Ini BRW,GRP SXG,Folder
					'N','','','',' ',' '})                                                                    //Pyme,CondSQL,ChkSQL,IdxSrv,Ortogra,IdxFld
					
	aHelp := {}
	aAdd(aHelp,{'ZZC_FILIAL', 'Filial do sistema.'})
	aAdd(aHelp,{'ZZC_MAT'   , 'Matricula do Funcionario.'})	
	aAdd(aHelp,{'ZZC_ITEM'  , 'Item sequencial de cadastro.'})	
	aAdd(aHelp,{'ZZC_NOME'  , 'Informe o nome do familiar.'})	
	aAdd(aHelp,{'ZZC_GRAUP' , 'Grau de parentesco do familiar.'})
	aAdd(aHelp,{'ZZC_ORGAO' , 'Informe o Orgao Publico.'})
	aAdd(aHelp,{'ZZC_CARGO' , 'Informe o Cargo Publico.'})
Return(.T.)


//-----------------------------------------------------------------------
// Rotina | ajustaSx1  | Autor | Rafael Beghini       | Data | 10/12/2015
//-----------------------------------------------------------------------
// Descr. | Cria o pergunte  
//        | 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
static function ajustaSx1(cPerg)

Local aSx1Cab := { "X1_GRUPO",;   //1
                   "X1_ORDEM",;   //2
                   "X1_PERGUNT",; //3	
                   "X1_VARIAVL",; //4
                   "X1_TIPO",;    //5
                   "X1_TAMANHO",; //6
                   "X1_DECIMAL",; //7
                   "X1_PRESEL",;  //8
                   "X1_GSC",;     //9
                   "X1_VAR01",;   //10	
                   "X1_F3"}       //11
							
Local aSX1Resp := {}

Aadd( aSX1Resp, { cPerg,;               //1
                  '01',;                //2
                  'Matricula de ?',;    //3
                  'mv_ch1',;            //4
                  'C',;                 //5
                  tamSx3("RA_MAT")[1],; //6
                  0,;                   //7
                  0,;                   //8
                  'G',;                 //9	
                  'mv_par01',;          //10
                  'SRA'})               //11
                      
Aadd( aSX1Resp, { cPerg,;               //1
                  '02',;                //2
                  'Matricula Ate?',;    //3
                  'mv_ch2',;            //4
                  'C',;                 //5
                  tamSx3("RA_MAT")[1],; //6
                  0,;                   //7
                  0,;                   //8
                  'G',;                 //9	
                  'mv_par02',;          //10
                  'SRA'})               //11
	
	//-- Grava Perguntas				
	u_CSPutSX1( aSx1Cab, aSX1Resp, .F. /*lForceAtuSx1*/ )
    
/* O BLOCO ABAIXO SERVE PARA SITUAÇÕES ONDE VOCE PRECISA ESTABELECER PREDEFINIÇÕES NOS PERGUNTES, UTILIZANDO OS _DEF...	
	//-- Reseta as variaveis
	aSX1Resp := {}    						
	aSx1Cab  := { "X1_GRUPO",;   //1
                  "X1_ORDEM",;   //2
                  "X1_PERGUNT",; //3	
                  "X1_VARIAVL",; //4
                  "X1_TIPO",;    //5
                  "X1_TAMANHO",; //6
                  "X1_DECIMAL",; //7
                  "X1_PRESEL",;  //8
                  "X1_GSC",;     //9
                  "X1_VAR01",;   //10	
                  "X1_DEF01",;   //11
                  "X1_DEF02",;   //12
                  "X1_DEF03",;   //13
                  "X1_DEF04",;   //14
                  "X1_DEF05"}    //15
					
	Aadd( aSX1Resp, { cPerg,;         //1
                      '04',;          //2
                      'Modulo?',;     //3
                      'mv_ch4',;      //4
                      'N',;           //5
                      1,;             //6
                      0,;             //7
                      0,;             //8
                      'C',;           //9	
                      'mv_par04',;    //10
                      'Compras',;     //11
                      'Faturamento',; //12
                      'Financeiro',;  //13
                      '',;            //14
                      ''})            //15
 
	//-- Grava as perguntas				
	//-- u_CSPutSX1(aSx1Cab, aSX1Resp, .F.)
*/	
	
Return