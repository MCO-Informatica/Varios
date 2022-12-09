#Include "Protheus.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"
//+-------------------------------------------------------------------+
//| Rotina | CSFAT030 | Autor | Rafael Beghini | Data | 20.05.2015 
//+-------------------------------------------------------------------+
//| Descr. | Geração de WorkFlow - Aceite de Proposta Final
//|        | 
//+-------------------------------------------------------------------+
//| Uso    | CertiSign Certificadora Digital - CRM Vendas
//+-------------------------------------------------------------------+
User function CSFAT030( cAD5_NROPOR, cAD5_VEND )
	
	Local cCabec   := 'Proposta Comercial: ' + cAD5_NROPOR + ' - '
	Local cInfo    := 'Informe o e-mail do contato para iniciar o processo de Workflow. Caso possua mais de 01 contato, separar por ;'
	Local cInfo2   := 'Selecione o modelo que será utilizado no WorkFlow'
	Local cDescricao := ''
	Local nOpc     := 0
	Local oDlg     := Nil
	Local oMsg     := Nil
	
	Local cContato := ''
	Local cConta   := ''
	Local cMailTo  := ''
	Local cMV_320MAIL := 'MV_320MAIL'
	Local lRet := .T.
	
	Private cTitulo := 'Geração do Aceite de Proposta Final'
	Private xTitulo := 'WorkFlow - Aceite de Proposta Final'
	Private cPara   := Space(200)
	Private cCopia  := Space(200)
	
	Private aModelo := {} 
	Private nRadio  := 0
	Private oRadio  := Nil
	
	aAdd( aModelo, "Modelo 1 - CertiSign" )
	aAdd( aModelo, "Modelo 2 - Governo" )
	
	If .NOT. SX6->( ExisteSX6( cMV_320MAIL ) )
		CriarSX6( cMV_320MAIL, 'L', 'Envia proposta por email para todos os contatos ou somente o primeiro. CSFA320.prw', '.F.' )
	Endif
	
	cDescricao := AD1->(Posicione( "AD1" , 1 , xFilial( "AD1" ) + cAD5_NROPOR , "AD1_DESCRI" ))
	cCabec += Alltrim(cDescricao)
	
	//Transforma parâmetros do tipo Range em expressão SQL para ser utilizadana query..
	MakeSqlExpr(cAD5_NROPOR)
	
	BeginSql Alias "cTRB"
		SELECT 
			AD9_FILIAL, AD9_NROPOR, AD9_REVISA, AD9_CODCON, U5_CODCONT, U5_CONTAT, U5_EMAIL, AD9.R_E_C_N_O_
		FROM %Table:AD9% AD9
			INNER JOIN %Table:SU5% SU5
			ON AD9_CODCON = U5_CODCONT AND SU5.%NOTDEL%
		WHERE
			AD9_NROPOR = %Exp:cAD5_NROPOR% AND
			AD9.%NOTDEL%
		ORDER BY AD9.R_E_C_N_O_	
	EndSql
		
	DbSelectArea("cTRB")
	DbGoTop()
	
	If GetMv( cMV_320MAIL ) //Pega somente o primeiro contato para enviar a proposta por e-mail.
		cContato := Alltrim(cTRB->U5_CONTAT) + ' - ' + Alltrim(cTRB->U5_EMAIL) + CRLF	
		cConta   := Alltrim(cTRB->U5_EMAIL) + ';'
	Else
		While !cTRB->(Eof())
			cContato += Alltrim(cTRB->U5_CONTAT) + ' - ' + Alltrim(cTRB->U5_EMAIL) + CRLF
			cConta   += Alltrim(cTRB->U5_EMAIL)+';' 
			cTRB->( dbSkip() )
		EndDo
	EndIf
	
	cTRB->( dbCloseArea() )
	
	If ! Empty(cContato)
		
		If MsgYesNo('Será iniciado o processo de WorkFlow para aprovação da Oportunidade ' + cAD5_NROPOR + CRLF + CRLF +;
			'O WorkFlow será enviado para o(s) seguinte(s) contato(s): ' + CRLF + cContato + CRLF + CRLF + 'Confirma o e-mail?', xTitulo)
			
			cPara := cConta
						
			DEFINE MSDIALOG oDlg TITLE xTitulo FROM 0,0 TO 250,600 OF oDlg PIXEL
	
			@  5,3 SAY cCabec      SIZE 250,7 PIXEL OF oDlg
			@ 20,3 SAY cInfo       SIZE 300,7 PIXEL OF oDlg
			@ 35,3 SAY "Para:"     SIZE 30,7  PIXEL OF oDlg
			@ 50,3 SAY "Cópia:"    SIZE 30,7  PIXEL OF oDlg
			
			@ 35,35 MSGET cPara    PICTURE "@" SIZE 248, 7 PIXEL OF oDlg
			@ 50,35 MSGET cCopia   PICTURE "@" SIZE 248, 7 PIXEL OF oDlg
			/*
			@ 65,3 SAY cInfo2      SIZE 250,7 PIXEL OF oDlg
			
			@ 80,2 RADIO oRadio VAR nRadio ITEMS aModelo[1],aModelo[2] SIZE 60,8 PIXEL OF oDlg ; 
			       ON CHANGE oRadio:Refresh()
			*/
			@ 100,210 BUTTON "&Gerar"     SIZE 36,13 PIXEL ACTION (lOpc:=Validar(),Iif(lOpc,Eval({||nOpc:=1,oDlg:End()}),NIL))
			@ 100,248 BUTTON "&Abandonar" SIZE 36,13 PIXEL ACTION oDlg:End()
		
			ACTIVATE MSDIALOG oDlg CENTERED
			cMailTo := cPara + Alltrim(cCopia)
		Else
			DEFINE MSDIALOG oDlg TITLE xTitulo FROM 0,0 TO 250,600 OF oDlg PIXEL
	
			@  5,3 SAY cCabec      SIZE 250,7 PIXEL OF oDlg
			@ 20,3 SAY cInfo       SIZE 300,7 PIXEL OF oDlg
			@ 35,3 SAY "Para:"     SIZE 30,7  PIXEL OF oDlg
			@ 50,3 SAY "Cópia:"    SIZE 30,7  PIXEL OF oDlg
			
			@ 35,35 MSGET cPara    PICTURE "@" SIZE 248, 7 PIXEL OF oDlg
			@ 50,35 MSGET cCopia   PICTURE "@" SIZE 248, 7 PIXEL OF oDlg
			/*
			@ 65,3 SAY cInfo2      SIZE 250,7 PIXEL OF oDlg
			
			@ 80,2 RADIO oRadio VAR nRadio ITEMS aModelo[1],aModelo[2] SIZE 60,8 PIXEL OF oDlg ; 
			       ON CHANGE oRadio:Refresh()
			*/
			@ 100,210 BUTTON "&Gerar"     SIZE 36,13 PIXEL ACTION (lOpc:=Validar(),Iif(lOpc,Eval({||nOpc:=1,oDlg:End()}),NIL))
			@ 100,248 BUTTON "&Abandonar" SIZE 36,13 PIXEL ACTION oDlg:End()
		
			ACTIVATE MSDIALOG oDlg CENTERED
			cMailTo := cPara + ';' + Alltrim(cCopia)
		EndIf
	Else
		MsgAlert('Oportunidade sem código de contato, por favor, informe o código do contato.',xTitulo)
		lRet := .F.
	EndIf
	
	If nOpc == 1
		FWMsgRun(,{|| U_WFFAT30( Nil, Nil,cAD5_NROPOR, cMailTo )}, cTitulo, 'Aguarde, iniciando processo de WorkFlow...')
	EndIf
	
Return(lRet)

//+-------------------------------------------------------------------+
//| Rotina | WFFAT30 | Autor | Rafael Beghini | Data | 20.05.2015 
//+-------------------------------------------------------------------+
//| Descr. | Inicia processo WorkFlow - Aceite de Proposta Final
//|        | 
//+-------------------------------------------------------------------+
//| Uso    | CertiSign Certificadora Digital
//+-------------------------------------------------------------------+
User Function WFFAT30( nOpcao, oProcess, cAD5_NROPOR, cPara )
    
    If ValType(nOpcao) = "A" 
      nOpcao := nOpcao[1]
    Endif  
    
	If nOpcao == NIL
		nOpcao := 0          
	End
    
    cstatus := 0
    
	If oProcess == NIL
		oProcess := TWFProcess():New( "APFCRM", "APROVACAO DE APF - CRM" )
	End

	Do Case
		Case nOpcao == 0
			WFFAT30Env( oProcess, @cAD5_NROPOR, @cPara )
		Case nOpcao == 1
			WFFAT30Ret( oProcess )
		Case nOpcao == 2
			WFFAT30Time( oProcess )
	End

	oProcess:Free()	
RETURN		

//+-------------------------------------------------------------------+
//| Rotina | WFFAT30Env | Autor | Rafael Beghini | Data | 20.05.2015 
//+-------------------------------------------------------------------+
//| Descr. | Envia o processo WorkFlow - Aceite de Proposta Final
//|        | 
//+-------------------------------------------------------------------+
//| Uso    | CertiSign Certificadora Digital
//+-------------------------------------------------------------------+
Static Function WFFAT30Env( oProcess, cAD5_NROPOR, cPara )
	Local cNum       := cAD5_NROPOR
	Local cCodCli    := ''
	Local cNomeCli   := ''
	Local cDescricao := ''
	Local cDescProd  := ''
	Local cUnidade   := ''
	Local cMailId    := ''
	Local cVersao    := ''
	Local cEmissao   := dToC( Date() )
	Local _cUser     := StrTran(StrTran(Alltrim(UsrRetName(__CUSERID)),".",""),"\","")
	Local cModWF1    := '' 
	Local cMV_APFWF1 := 'MV_APFWF1'
	Local cFileHTML  := 'ACEITE_APF'
	Local cCodMail   := cPara
	Local nTotal     := 0
	
	If .NOT. GetMv( cMV_APFWF1, .T. )
		CriarSX6( cMV_APFWF1, 'C', 'Arquivo modelo 1 HTML para geracao da APF - Proposta Final. CSFAT030.prw.', "\WORKFLOW\EVENTO\FAT030WF1.HTM" )
	Endif
	
	cModWF1 := GetMv( 'MV_APFWF1' )
	
	cCodCli    := Posicione( "AD1" , 1 , xFilial( "AD1" ) + cNum    , "AD1_CODCLI+AD1_LOJCLI" )
	cDescricao := Posicione( "AD1" , 1 , xFilial( "AD1" ) + cNum    , "AD1_DESCRI" )
	cNomeCli   := Posicione( "SA1" , 1 , xFilial( "SA1" ) + cCodCli , "A1_NOME" )
	
	oProcess:NewTask( "Solicitação", cModWF1 )
	oProcess:cSubject := "Aprovação - Aceite Proposta Final "
	oProcess:bReturn  := "U_WFFAT30( 1 )"
	oProcess:bTimeOut := {{"U_WFFAT30(2)", 0 ,0 ,2 }}

	oHTML := oProcess:oHTML	
	
	oHtml:ValByName( "CLIENTE"     , cNomeCli )
	oHtml:ValByName( "OPORTUNIDADE", cNum     ) 
	oHtml:ValByName( "MAILTO"      , cCodMail )
	
	oProcess:fDesc := "Proposta Comercial " + cNum
	
	dbSelectArea('SA1')
	dbSetOrder(1)
	If dbSeek(xFilial('SA1')+cCodCli)
		oHtml:ValByName( "Razao"   , SA1->A1_NOME   )
		oHtml:ValByName( "Endereco", SA1->A1_END    )
		oHtml:ValByName( "Cnpj"    , Transform(SA1->A1_CGC, '@R 99.999.999/9999-99') )
		oHtml:ValByName( "InscEst" , SA1->A1_INSCR  )
		oHtml:ValByName( "InscMun" , SA1->A1_INSCRM )
	EndIf
	    
    dbSelectArea('ADJ')
    dbSetOrder(1)
    dbSeek(xFilial('ADJ')+cNum)
    
    While !Eof() .and. ADJ_NROPOR == cNum
		nTotal := nTotal + ADJ_VALOR
		AAdd( (oHtml:ValByName( "it.item" )),ADJ_ITEM )		
		//AAdd( (oHtml:ValByName( "it.codigo" )),ADJ_PROD )		       
		DA1->( dbSetOrder( 1 ) )
		IF DA1->( dbSeek( xFilial( 'DA1' ) + AD1->AD1_TABELA + ADJ->ADJ_PROD ) )
			cDescProd := DA1->DA1_DESAMI
		Else
			cDescProd := Posicione( "SB1" , 1 , xFilial( "SB1" ) + ADJ_PROD , "B1_DESC" )
		EndIF
		cUnidade  := Posicione( "SB1" , 1 , xFilial( "SB1" ) + ADJ_PROD , "B1_UM" )
		   
		AAdd( (oHtml:ValByName( "it.descricao" )), Alltrim(cDescProd) )		              
		AAdd( (oHtml:ValByName( "it.quant"     )), TRANSFORM( ADJ_QUANT  , '@E 999,999.99' ) )		              
		AAdd( (oHtml:ValByName( "it.preco"     )), TRANSFORM( ADJ_PRUNIT , '@E 999,999.99' ) )		                     
		AAdd( (oHtml:ValByName( "it.total"     )), TRANSFORM( ADJ_VALOR  , '@E 999,999.99' ) )		                     
		AAdd( (oHtml:ValByName( "it.unid"      )), cUnidade )
		
		dbSkip()
    Enddo	              
       		                     
	oHtml:ValByName( "lbTotal" ,TRANSFORM( nTotal,'@E 999,999.99' ) )         	    
	oProcess:ClientName( Subs(cUsuario,7,15) )
	oProcess:cTo := _cUser
	
	oHtml:valByName('botoes', '<input type=submit name=B1 value=Enviar> <input type=reset name=B2 value=Limpar>')
    	
	cMailId := oProcess:Start()
	     
	FAT030Link(_cUser,cCodMail,@oProcess,@cNum,@cMailId)
       		       
	wfSendMail()
     
	Sleep(1000)     
Return 

//+-------------------------------------------------------------------+
//| Rotina | FAT030Link | Autor | Rafael Beghini | Data | 20.05.2015 
//+-------------------------------------------------------------------+
//| Descr. | Gera o link para acesso WorkFlow
//|        | 
//+-------------------------------------------------------------------+
//| Uso    | CertiSign Certificadora Digital
//+-------------------------------------------------------------------+
Static Function FAT030Link(_cUser,cCodMail,oWFlin,cAD5_NROPOR,cMailId)
	Local cNum       := cAD5_NROPOR
	Local cCodCli    := ''
	Local cNomeCli   := ''
	Local cUnidade   := ''
	Local cEmissao   := dToC( Date() )
	Local cLink      := GetNewPar("MV_XLINKWF", "http://192.168.16.10:1804/wf/")
	Local cModWF2    := '' 
	Local cMV_APFWF2 := 'MV_APFWF2'
	Local cMV_APFWF3 := 'MV_APFWF3'
	Local nTotal     := 0
	Local oHTML
	
	If .NOT. GetMv( cMV_APFWF2, .T. )
		CriarSX6( cMV_APFWF2, 'C', 'Arquivo modelo HTML para geracao da APF - Proposta Final - Link. CSFAT030.prw.', "\WORKFLOW\EVENTO\FAT030WF2.HTM" )
	Endif
	If .NOT. GetMv( cMV_APFWF3, .T. )
		CriarSX6( cMV_APFWF3, 'C', 'Arquivo modelo HTML para geracao da APF - Proposta Final - Retorno. CSFAT030.prw.', "\WORKFLOW\EVENTO\FAT030WF3.HTM" )
	Endif
	
	cModWF2 := GetMv( 'MV_APFWF2' )
	
	cLink += "emp"+ cEmpAnt +"/" 

	cCodCli   := Posicione( "AD1" , 1 , xFilial( "AD1" ) + cAD5_NROPOR , "AD1_CODCLI+AD1_LOJCLI" )
	cNomeCli  := Posicione( "SA1" , 1 , xFilial( "SA1" ) + cCodCli     , "A1_NOME" )

	oWFlin:NewTask( "LKAPF", cModWF2 )
	oWFlin:cSubject := "Aprovação - Aceite Proposta Final " + cAD5_NROPOR
	oWFlin:cTo := cCodMail

	// Cria objeto Html de acordo modelo
	oHTML := oWFlin:oHTML
	
	// Preenche os dados do cabecalho
	oHTML:ValByName( "cNomeCli"   , cNomeCli    )	
	oHtml:ValByName( "cAD5_NROPOR", cAD5_NROPOR )
	oHtml:ValByName( "titulo"     , cMailId     )
	oHtml:ValByName( "proc_link"  , cLink+_cUser+"/"+cMailId+".htm" )

	dbSelectArea('ADJ')
	dbSetOrder(1)
	dbSeek(xFilial('ADJ')+cNum)
	While !Eof() .and. ADJ_NROPOR == cNum
		nTotal := nTotal + ADJ_VALOR
		AAdd( (oHtml:ValByName( "it.item" )),ADJ_ITEM )		
		//AAdd( (oHtml:ValByName( "it.codigo" )),ADJ_PROD )		       

		cDescProd := Posicione( "SB1" , 1 , xFilial( "SB1" ) + ADJ_PROD , "B1_DESC" )
		cUnidade  := Posicione( "SB1" , 1 , xFilial( "SB1" ) + ADJ_PROD , "B1_UM" )

		AAdd( (oHtml:ValByName( "it.descricao" )), Alltrim(cDescProd) )		              
		AAdd( (oHtml:ValByName( "it.quant"     )), TRANSFORM( ADJ_QUANT  , '@E 999,999.99' ) )		              
		AAdd( (oHtml:ValByName( "it.preco"     )), TRANSFORM( ADJ_PRUNIT , '@E 999,999.99' ) )		                     
		AAdd( (oHtml:ValByName( "it.total"     )), TRANSFORM( ADJ_VALOR  , '@E 999,999.99' ) )		                     
		AAdd( (oHtml:ValByName( "it.unid"      )), cUnidade )

		dbSkip()
	Enddo	              

	oHtml:ValByName( "lbTotal" ,TRANSFORM( nTotal,'@E 999,999.99' ) )         	

	oWFlin:Start()

	oWFlin:Free()	
	
Return

//+-------------------------------------------------------------------+
//| Rotina | WFFAT30Ret | Autor | Rafael Beghini | Data | 20.05.2015 
//+-------------------------------------------------------------------+
//| Descr. | Retorna o processo WorkFlow - Aceite de Proposta Final
//|        | 
//+-------------------------------------------------------------------+
//| Uso    | CertiSign Certificadora Digital
//+-------------------------------------------------------------------+
Static Function WFFAT30Ret( oProcess )
	Local cCodOp    := ''
	Local cStatus   := ''
	Local cDirDoc   := MsDocPath()
	Local cFileHTML := 'ACEITE_APF'
	Local cArquivo  := ''
	Local cVerHtm   := ''
	Local lRet      := .F.
	Local cCredito  := ''
	Local cBoleto   := ''
	Local cDeposito := ''
	Local cEstAtu   := ''
	Local cEstNew   := ''
	Local cVendedor := ''
	
	cCodOp := oProcess:oHtml:RetByName('OPORTUNIDADE')
	
	cCredito  := oProcess:oHtml:RetByName('CREDITO')
	cBoleto   := oProcess:oHtml:RetByName('BOLETO')
	cDeposito := oProcess:oHtml:RetByName('DEPOSITO')  
	cMailId   := substr( rTrim( oProcess:oHtml:RetByName('WFMAILID') ) , 3 )  
	U_A603SAVE( cMailId, 'CSFAT030' )
	
	Do Case
		Case cCredito == '1'
			oProcess:oHTML:ValByName( "cCredito1"   , 'selected'    )	
		Case cCredito == '2'
			oProcess:oHTML:ValByName( "cCredito2"   , 'selected'    )	
		Case cCredito == '3'
			oProcess:oHTML:ValByName( "cCredito3"   , 'selected'    )	
	End
	
	Do Case
		Case cBoleto == '1'
			oProcess:oHTML:ValByName( "cBoleto1"   , 'selected'    )	
		Case cBoleto == '2'
			oProcess:oHTML:ValByName( "cBoleto2"   , 'selected'    )	
		Case cBoleto == '3'
			oProcess:oHTML:ValByName( "cBoleto3"   , 'selected'    )	
	End
	
	Do Case
		Case cDeposito == '1'
			oProcess:oHTML:ValByName( "cDeposito1"   , 'selected'    )	
		Case cDeposito == '2'
			oProcess:oHTML:ValByName( "cDeposito2"   , 'selected'    )	
		Case cDeposito == '3'
			oProcess:oHTML:ValByName( "cDeposito3"   , 'selected'    )	
	End
	
	ConOut('WFFAT30Ret - OPORTUNIDADE: ' + cCodOp)   
	
	If oProcess:oHtml:RetByName("Aprovacao") = "S"
		cStatus := 'Aprovada'
		
		ConOut("CSFAT030 > Oportunidade Aprovada: " + cCodOp)
		
		DBSelectarea("AD1")                   
		DBSetorder(1)
		If DBSeek(xFilial("AD1")+oProcess:oHtml:RetByName('OPORTUNIDADE'))    
			cEstAtu := AD1->AD1_STAGE
			cEstNew := '005APF'
			cVendedor := AD1->AD1_VEND
			
			AD1->( RecLock( 'AD1', .F. ) )
			AD1->AD1_STAGE := '005APF' 
			AD1->( MsUnLock() )
			
			FAT30Aviso( cEstAtu, cEstNew, cVendedor )
		Endif  
	Else
		cStatus := 'Reprovada'
		
		ConOut("CSFAT030 > Oportunidade Reprovada: " + cCodOp)
		
		DBSelectarea("AD1")
		DBSetorder(1)
		If DBSeek(xFilial("AD1")+oProcess:oHtml:RetByName('OPORTUNIDADE'))
			AD1->( RecLock( 'AD1', .F. ) )
			AD1->AD1_STAGE := '004APF' 
			AD1->( MsUnLock() )
		EndIf
	EndIf
	
	// Pesquisar no banco de conhecimento a próxima versão PDF.
	cVerHtm := A320Knowledge( cFileHTML , '.htm', cCodOp )
	
	//oProcess:oHTML:SaveFile( cPath + cFileHTML + '_v' + cVerHtm + '.htm' )
	oProcess:oHTML:SaveFile( cDirDoc + '\' + cFileHTML + '_' + cCodOp + '_V' + cVerHtm + '.htm' )
	
	//cArquivo := cRootPath + cPath + cFileHTML + '_v' + cVerHtm + '.htm'
	cArquivo := cDirDoc + '\' + cFileHTML + '_' + cCodOp +  '_V' + cVerHtm + '.htm'
	
	        // Anexar o arquivo no banco de conhecimento.
	lRet := FAT30Anexar(cFileHTML + '_' + cCodOp + '_V' + cVerHtm + '.htm', cArquivo, cCodOp)
	
	If lRet
		ConOut('Deleta o arquivo no temporário do WF - CSFAT030')
		Ferase(cArquivo)
	EndIf
		
Return 

Static Function WFFAT30Time(oProcess)
	ConOut('TimeOut executado - CSFAT030')
Return (.T.)

//-----------------------------------------------------------------------
// Rotina | Validar  | Autor | Rafael Beghini         | Data | 18/05/2015
//-----------------------------------------------------------------------
// Descr. | Verifica se o campo 'Para' foi preenchido para geração do 
//        | WorkFlow - proposta por e-mail. 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function Validar()
	Local lRet := .T.
	If Empty(cPara)
		MsgInfo("Campo 'Para' preenchimento obrigatório",xTitulo)
		lRet:=.F.
	Endif
	If lRet
		cPara := AllTrim(cPara)
	Endif
Return(lRet)

//-----------------------------------------------------------------------
// Rotina | A320Anexar | Autor | Rafael Beghini     | Data | 20/05/2015
//-----------------------------------------------------------------------
// Descr. | Rotina para anexar o documento ao registro de Oportunidade.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
// Tabelas| AC9 - Relacao de Objetos x Entidades
//          ACB - Bancos de Conhecimentos
//          ACC - Palavras-Chave
//-----------------------------------------------------------------------
Static Function FAT30Anexar( cAnexo, cFileName, cCodOp) 
	Local aArea       := GetArea()
	Local cDirDoc     := MsDocPath()
	Local cFile       := ''
	Local cACB_CODOBJ := ''
	Local lRet        := .F.
	
	cFile := Alltrim(cCodOp)+"_"+NoAcento(AnsiToOem(cAnexo))	
	
	lRet := __CopyFile(cFileName,cDirDoc + "\" + cFile )
	
	If lRet	
		cACB_CODOBJ := GetSXENum('ACB','ACB_CODOBJ')
	
		ACB->( RecLock( 'ACB', .T. ) )
		ACB->ACB_FILIAL	:= xFilial( 'ACB' )
		ACB->ACB_CODOBJ	:= cACB_CODOBJ
		ACB->ACB_OBJETO	:= cFile
		ACB->ACB_DESCRI	:= cAnexo
		
		ACB->( MsUnLock() )	
		ACB->( ConfirmSX8() )
		
		AC9->( RecLock( 'AC9', .T. ) )
		AC9->AC9_FILIAL	:= xFilial( 'AC9' )
		AC9->AC9_FILENT	:= xFilial( 'AD1' )
		AC9->AC9_ENTIDA	:= 'AD1'
		AC9->AC9_CODENT	:= cCodOp
		AC9->AC9_CODOBJ	:= cACB_CODOBJ
		AC9->AC9_DTGER    := dDataBase
		AC9->( MsUnLock() )
		
		ACC->( RecLock( 'ACC', .T. ) )
		ACC->ACC_FILIAL := xFilial( 'ACC' ) 
		ACC->ACC_CODOBJ := cACB_CODOBJ
		ACC->ACC_KEYWRD := cCodOp + ' ' + cAnexo
		ACC->( MsUnLock() )
	EndIf
	RestArea(aArea)
	
Return( lRet )

//-----------------------------------------------------------------------
// Rotina | A320Knowledge | Autor | Robson Gonçalves  | Data | 13.01.2014
//-----------------------------------------------------------------------
// Descr. | Rotina p/disponibilizar próximo nome como controle de versão.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A320Knowledge( cArq, cExt, cCodOp )
	Local cSeek := ''
	Local nCount := 1
	ACB->( dbSetOrder( 3 ) )
	While .T.
		cSeek := Upper( cArq ) + '_' + cCodOp + '_V' + cValToChar( nCount ) + cExt
		If ACB->( dbSeek( xFilial( 'ACB' ) + cSeek ) )
			nCount++
		Else
			Exit
		Endif
	End
	nVersaoDocto := nCount
Return( cValToChar( nCount ) )

Static Function FAT30Aviso( cEstAtu, cEstNew, cVendedor )
	Local cQuery := ''
	Local aPara  := {}
	
	cQuery :="SELECT R_E_C_N_O_ "
	cQuery +="FROM  "  + RetSQLName("ZCE")
	cQuery +=" WHERE ZCE_FILIAL = '"+xFilial("ZCE")+"' AND "
	cQuery +="ZCE_ESTATU = '" + cEstAtu + "' AND "
	cQuery +="ZCE_ESTNOV = '" + cEstNew + "'AND "
	cQuery +="D_E_L_E_T_ = ' ' "
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRBZCE",.F.,.T.)
	
	If  !TRBZCE->(eof())
		ZCE->(dbGoTo(TRBZCE->R_E_C_N_O_ ))
		aPara:= StrtoKarr(ZCE->ZCE_EMAIl,";")
		
		IF ( ZCE->ZCE_RESOPT == "S")
			cMailVe	:= Alltrim(Posicione("SA3",1,xFilial("SA3")+cVendedor,"A3_EMAIL"))
			aAdd(aPara,cMailVe)
		ENDIF

		ConOut("CSFAT030 > E-mail informando o estágio da Oportunidade")
		FAT30Email( cEstAtu, cEstNew, aPara )
	Endif
	TRBZCE->(dbCloseArea())  	
Return

Static Function FAT30Email( cEstAtu, cEstNew, aPara )
	Local lResulConn := .T.
	Local lResulSend := .T.
	Local lResult := .T.
	Local cError := ""
	Local cServer   := Trim(GetMV('MV_RELSERV'))   // Ex.: smtp.ig.com.br ou
	Local cConta    := Trim(GetMV('MV_RELACNT'))   // Conta Autenticacao Ex.: fuladetal@fulano.com.br
	Local cPsw      := Trim(GetMV('MV_RELAPSW'))   // Senha de acesso Ex.: 123abc
	Local lRelauth  := SuperGetMv("MV_RELAUTH",, .F.) // Parametro que indica se existe autenticacao no e-mail
	Local lRet     := .F.        // Se tem autorizacao para o envio de e-mail
	Local cDe := cConta
	Local cAssunto := ""
	Local cMsg := ""
	Local aArea := GetArea() 
	Local cPara := ""
	
	cAssunto := UPPER("CRM - Avanço / Etapa anterior  " + cEstAtu  + " Para etapa atual  " + cEstNew +" / Oportunidade "+ Alltrim( AD1->AD1_DESCRI ) + " / Cliente: " + IIF(Empty( Posicione( "SA1", 1, xFilial("SA1") + AD1->AD1_CODCLI + AD1->AD1_LOJCLI, "A1_NOME" )),Posicione("SUS",1,xFilial("SUS")+AD1->AD1_PROSPE+AD1->AD1_LOJPRO,"US_NOME"),Posicione( "SA1", 1, xFilial("SA1") + AD1->AD1_CODCLI + AD1->AD1_LOJCLI, "A1_NOME" )))
	
	//Transform(Val(AD3->AD3_PRECO),"@ze 999,999,999.99")
	cMsg := "Prezados," + CRLF + CRLF 
	cMsg += "Alertamos para alteração da oportunidade: " + AD1->AD1_NROPOR 
	cMsg += " cliente " + IIF(Empty( Posicione( "SA1", 1, xFilial("SA1") + AD1->AD1_CODCLI + AD1->AD1_LOJCLI, "A1_NOME" )),;
										Posicione("SUS",1,xFilial("SUS")+AD1->AD1_PROSPE+AD1->AD1_LOJPRO,"US_NOME"),;
										Posicione( "SA1", 1, xFilial("SA1") + AD1->AD1_CODCLI + AD1->AD1_LOJCLI, "A1_NOME" )) 
	cMsg += "-" +AD1->AD1_DESCRI  
	cMsg += " do estágio " + cEstAtu + " - " + Posicione( "AC2", 1, xFilial("AC2") + AD1->AD1_PROVEN + cEstAtu , "AC2_DESCRI" ) 
	cMsg += " para o " + cEstNew + " - " + Posicione( "AC2", 1, xFilial("AC2") + AD1->AD1_PROVEN + cEstNew , "AC2_DESCRI" )  
	cMsg += " na data " + dToC(ddatabase) + CRLF + CRLF 
	cMsg += "Obs. apontamento:" + CRLF + CRLF +MSMM(AD5->AD5_CODMEN) + CRLF + CRLF 
	cMsg += "Obs. oportunidade:" + CRLF + CRLF + MSMM(AD1->AD1_CODMEM) + CRLF + CRLF 
	
	cMsg += "Atc." + CRLF + CRLF + Posicione("SA3",1,xFilial("SA3")+AD5->AD5_VEND,"A3_NOME")
	
	lResulConn := MailSmtpOn( cServer, cConta, cPsw, 60)
	If !lResulConn // Exibe mensagem de erro de nao houver conexão
		cError := MailGetErr()
		                                                                                                                                                 
		MsgAlert("Falha na conexao "+cError)
		
		Return(.F.)
	Endif
	
	If lRelauth
		lResult := MailAuth(Alltrim(cConta), Alltrim(cPsw))
		
		If !lResult
			//	nA := At("@",cConta)
			//	cUser := If(nA>0,Subs(cConta,1,nA-1),cConta)
			lResult := MailAuth(Alltrim(cConta), Alltrim(cPsw))
		Endif
	Endif
	
	If lResult
		
		lResulSend:= MailSend(cConta,aPara,{},{},cAssunto,cMsg,{},.F.)
		IF !lResulSend
			cError := MailGetErr()
			MsgAlert("Falha no envio do e-mail " + cError)
		EndIf
	Else
		MsgAlert("Falha no envio do e-mail " + cError)
	Endif
	
	MailSmtpOff()
	
	IF lResulSend
		aeval(aPara,{|x| cPara += x+", "   })
		MsgInfo("E-mail enviado com sucesso para " + cPara + "." + cError)
		
	ENDIF
	
	RestArea(aArea)
Return lResulSend