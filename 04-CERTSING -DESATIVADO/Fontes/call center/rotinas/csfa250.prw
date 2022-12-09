//-----------------------------------------------------------------------
// Rotina | CSFA250    | Autor | Robson Gonçalves     | Data | 06.05.2014
//-----------------------------------------------------------------------
// Descr. | Rotina que pergunta ao usuário qual processo do CRM Vendas
//        | quer utilizar.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
#Include 'Protheus.ch'
#Include 'FWMVCDEF.CH'
STATIC oGrdPE 
STATIC cAD1PROVEN := ''
User Function CSFA250()
	Local cMVCSFA250 := 'MV_CSFA250'
   Local cAD1_PROVEN := ''
	Local cAD1_STAGE  := ''
	If INCLUI
		If .NOT. GetMv( cMVCSFA250, .T. )
			CriarSX6( cMVCSFA250, 'C', 'PARAMETRO QUE SOLICITA AO USUÁRIO QUAL PROCESSO DO CRM VENDAS QUER USAR. PARAMETRO ACIONADO PELA ROTINA CSFA250.prw', 'N' )
		Endif
		cMVCSFA250 := GetMv( cMVCSFA250, .F., 'N' )
		If cMVCSFA250 == 'S'
			nOpc := Aviso('CRM Vendas',;
			              'Existem dois processo para o CRM Vendas, 000001 processo ATUAL ou 000002 processo NOVO, qual deseja utilizar?',;
			              {'Atual','Novo'},3,'CSFA250 | MV_CSFA250')
			If nOpc == 1
				cAD1_PROVEN := '000001'
				cAD1_STAGE  := '000PRO'
			Else
				cAD1_PROVEN := '000002'
				cAD1_STAGE  := '000SUS'
			Endif
		Else
			cAD1_PROVEN := '000002'
			cAD1_STAGE  := '000SUS'
		Endif
		M->AD1_PROVEN := cAD1_PROVEN
		M->AD1_STAGE  := cAD1_STAGE
	Endif
Return(.T.)


//-----------------------------------------------------------------------
// Rotina | A250FAC5   | Autor | Robson Gonçalves     | Data | 06.05.2014
//-----------------------------------------------------------------------
// Descr. | Rotina para montar filtro na consulta padrão (SXB) para o 
//        | evento conforme o código do CRM Vendas informado na 
//        | Oportunidade.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A250FAC5()
	Local cRet := "@#.T.@#"
	Local cAD1_PROVEN := ""
	If ReadVar()=="M->AD5_EVENTO"
		If M->AD5_NROPOR == AD1->AD1_NROPOR
			cAD1_PROVEN := AD1->AD1_PROVEN
		Else
			cAD1_PROVEN := Posicione("AD1",1,xFilial("AD1")+M->AD5_NROPOR,"AD1_PROVEN")
		Endif
		cRet := "@#AC5_FILIAL == '"+xFilial("AC5")+"' .And. AC5_PROCES == '"+cAD1_PROVEN+"'@#"
	Endif
Return( cRet )


//-----------------------------------------------------------------------
// Rotina | A250Key    | Autor | Robson Gonçalves     | Data | 06.05.2014
//-----------------------------------------------------------------------
// Descr. | Rotina para criticar se o evento pertence ao processo CRM.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A250Key()
	Local lAchou := .F.
	Local cAD1_PROVEN := ''
	If M->AD5_NROPOR == AD1->AD1_NROPOR
		cAD1_PROVEN := AD1->AD1_PROVEN
	Else
		cAD1_PROVEN := Posicione("AD1",1,xFilial("AD1")+M->AD5_NROPOR,"AD1_PROVEN")
	Endif
	AC2->( dbSetOrder( 1 ) )
	lAchou := AC2->( dbSeek( xFilial( 'AC2' ) + cAD1_PROVEN + M->AD5_EVENTO ) )
	If .NOT. lAchou
		MsgAlert( 'O código de evento informado não pertence ao código do Processo CRM Vendas '+cAD1_PROVEN+', por favor, verifique!','CSFA250 | A250Key' )
	Endif
Return(lAchou)


//-----------------------------------------------------------------------
// Rotina | A250NrOp   | Autor | Robson Gonçalves     | Data | 30.04.2014
//-----------------------------------------------------------------------
// Descr. | Rotina para alimentar a variável cAD1PROVEN. Esta rotina é
//        | acionada no X3_VLDUSER do campo AD5_NROPOR.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A250NrOp()
	
	Local cBlq      := "" 
	Local cCli      := ""
	Local cLoj		:= ""
	Local lRet      := .T.
	Local lLock     := .T. 
    Local lIsLocked := .T.
    
	//-- Posicionamento de registro.
	dbSelectArea("AD1")
	dbSetOrder(1)
	
	If AD1->(dbSeek(xFilial("AD1") + M->AD5_NROPOR))
		cCli := AD1->AD1_CODCLI
		cLoj := AD1->AD1_LOJCLI
	EndIf
	
	lLock := AD1->( MsRLock( AD1->(RecNo()) ) )
	If lLock
		AD1->( MsRUnLock( AD1->(RecNo()) ) )
		lIsLocked := .F.
	Else
		lIsLocked := .T.
	Endif
	
	If lIsLocked
		lRet := .F.
		MsgStop("<b>[Problema]</b> - Essa oportunidade esta em uso." + Chr(13) + Chr(10) + Chr(13) + Chr(10) +; 
				"<b>[Solução]</b> - Feche a oportunidade antes de realizar o apontamento", "[A250NrOp]" )
	Else
		cBlq := Posicione( "SA1" ,1 ,xFilial("SA1") + cCli + cLoj ,"A1_MSBLQL"  )
	
		//-- Verifica se o cliente está bloqueado para evitar error.log MVC.
		If cBlq == "1"
			lRet := .F.
			MsgStop("[Problema] - O cliente desta Oportunidade está bloqueado para uso." + Chr(13) + Chr(10) + Chr(13) + Chr(10) +; 
					"[Solução] - Entre em contato com o setor financeiro para verificação do campo Status (A1_MSBLQL) no cadastro de cliente.", "[A250NrOp]" )
		Else
			AD1->( dbSetOrder( 1 ) )
			If AD1->( MsSeek( xFilial( 'AD1' ) + M->AD5_NROPOR ) )
				cAD1PROVEN := AD1->AD1_PROVEN
			Endif
			lRet := .NOT. Empty( cAD1PROVEN ) 
		EndIf
	EndIf
	
Return( lRet )


//-----------------------------------------------------------------------
// Rotina | A250Nome   | Autor | Robson Gonçalves     | Data | 12.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para retornar o nome do cliente/prospects dependendo
//        | do código informado.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A250Nome()
	Local cRet := Space(Len(SA1->A1_NOME))
	If .NOT. INCLUI
		If Empty(AD5->(AD5_CODCLI+AD5_LOJA))
			cRet := Posicione('SUS',1,xFilial('SUS')+AD5->(AD5_PROSPE+AD5_LOJPRO),'US_NOME')
		Else
			cRet := Posicione('SA1',1,xFilial('SA1')+AD5->(AD5_CODCLI+AD5_LOJA),'A1_NOME')
		Endif
	Endif
Return(cRet)


//-----------------------------------------------------------------------
// Rotina | A250HaCNPJ   | Autor | Robson Gonçalves     | Data | 16.10.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para verificar se tem CNPJ informado na oportunidade. 
//        | Caso não houver solicitar a digitação e verificar se existe
//        | oportunidade com o mesmo CNPJ.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A250HaCNPJ()
	Local lRet := .T.
	
	Local aPar := {}
	Local aRet := {}
	
	Local cNom := ''
	Local cTab := ''
	Local cKey := ''
	Local cTit := ''
	Local cCpoCNPJ := ''
	
	Local cTitulo := 'Informar CNPJ/CPF'
	
	Local bOk := {|| MsgYesNo( 'Confirma a gravação do CNPJ/CPF informado?', cTitulo ) }
	
	If Left( M->AD5_EVENTO, 3 ) >= '002' .And. cAD1PROVEN $ '000001|000002'
		AD1->( dbSetOrder( 1 ) )
		If AD1->( dbSeek( xFilial( 'AD1' ) + M->AD5_NROPOR ) )
			If Empty( AD1->AD1_CNPJ )
				If Empty(AD1->AD1_CODCLI) .And. Empty(AD1->AD1_LOJCLI)
					cNom := 'Suspect'
					cTab := 'SUS'
					cKey := AD1->( AD1_PROSPE + AD1_LOJPRO )
					cCpoCNPJ := 'US_CGC'
				Else
					cNom := 'Cliente
					cTab := 'SA1'
					cKey := AD1->( AD1_CODCLI + AD1_LOJCLI )
					cCpoCNPJ := 'A1_CGC'
				Endif
				cTit := RTrim( SX3->(RetTitle( cCpoCNPJ ) ) )
				aRet := (cTab)->( GetAdvFVal( cTab, { cCpoCNPJ }, xFilial( cTab ) + cKey, 1 ) )
				MsgInfo('A Oportunidade em questão está sem CNPJ/CPF, por gentileza, clique em OK para inserir esta informação agora.')
				AAdd( aPar, { 1, 'CNPJ/CPF', Space(14), X3Picture(cCpoCNPJ), 'CGC(mv_par01).And.U_A250CNPJ(mv_par01)', '', '',70 , .T. } )
				If ParamBox( aPar, cTitulo, @aRet, bOk, , , , , , , .F., .F. )
					If M->AD5_NROPOR <> AD1->AD1_NROPOR
						AD1->( dbSeek( xFilial( 'AD1' ) + M->AD5_NROPOR ) )
					Endif
					If AD1->(Found())
						AD1->( RecLock( 'AD1', .F. ) )
						AD1->AD1_CNPJ := aRet[ 1 ] 
						AD1->( MsUnLock() )
					Endif
				Else
					lRet := .F.
				Endif
			Endif
		Endif
	Endif
Return(lRet)


//-----------------------------------------------------------------------
// Rotina | A250CNPJ   | Autor | Robson Gonçalves     | Data | 16.10.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para verificar se o CNPJ informado na oportunidade 
//        | existe. O retorno é .T. pois ainda não deve-se bloquear.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A250CNPJ( cCNPJ )
	Local lRet := .T.
	Local lCNPJ := .F.
	Local cSQL := ''
	Local cTRB := ''
	Local cAD1_NROPOR := ''
	Local cCampo := ''
	Local cAux := ''
	Local cTexto := ''
	Local aArea := {}
	aArea := GetArea()
	cCampo := ReadVar()
	If 'AD1_CNPJ' $ cCampo .Or. .NOT. Empty( cCNPJ )
		If .NOT. Empty( cCampo )
			cAux := &( cCampo )
			If Len( cAux ) == 14
				lCNPJ := .T.
				cAux := Left( cAux, 8 ) + '%'
			Endif
			cSQL := "SELECT AD1_NROPOR, AD1_CNPJ "
			cSQL += "FROM   "+RetSqlName("AD1")+" AD1 "
			cSQL += "WHERE  AD1_FILIAL = "+ValToSql( xFilial( "AD1" ) )+" "
			If lCNPJ
				cSQL += "       AND AD1_CNPJ LIKE "+ValToSql( cAux )+" "
			Else
				cSQL += "       AND AD1_CNPJ = "+ValToSql( cAux )+" "
			Endif
			cSQL += "       AND AD1.D_E_L_E_T_ = ' ' "
			cSQL += "ORDER  BY AD1_NROPOR "
			cSQL := ChangeQuery( cSQL )
			cTRB := GetNextAlias()
			dbUseArea( .T., 'TOPCONN', TCGENQRY( , , cSQL ), cTRB, .F., .T. )
			If (cTRB)->( .NOT. BOF() ) .And. (cTRB)->( .NOT. EOF() )
				While (cTRB)->( .NOT. EOF() )
					cAD1_NROPOR += 'Oportunidade: ' + (cTRB)->(AD1_NROPOR) + ' CNPJ: ' + TransForm((cTRB)->(AD1_CNPJ),'@R 99.999.999/9999-99') + Chr(13) + Chr(10)
					(cTRB)->( dbSkip() )
				End
				If lCNPJ
					cTexto := 'Abaixo Oportunidade(s) com este prefixo de CNPJ ' + Left(TransForm(&(cCampo),'@R 99.999.999/9999-99'),10) + Chr(13)+Chr(10)
				Else
					cTexto := 'Abaixo Oportunidade(s) com este CNPJ/CPF ' + &(cCampo) + Chr(13)+Chr(10)
				Endif
				xMagHelpFis ('Aviso de validação',cTexto + cAD1_NROPOR,'Verifique a duplicidade. Contate o responsável.')
			Endif
			(cTRB)->( dbCloseArea() )
		Endif
	Endif
	RestArea( aArea )
Return( lRet )


//-----------------------------------------------------------------------
// Rotina | A250Gat    | Autor | Robson Gonçalves     | Data | 16.10.2013
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar do gatilho acionado pelo campo AD5_SEQUEN.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A250Gat( cCampo )
	Local aArea := {}
	Local cRet := ''
	aArea := GetArea()
	
	If cCampo == 'AD5_SEQUENC'
		cRet := A250AD5Seq()
	Elseif cCampo == 'AD5_NROPOR'	
		cRet := A250AD5NrO()
	Endif
	
	RestArea( aArea )
Return( cRet )


//-----------------------------------------------------------------------
// Rotina | A250AD5Seq | Autor | Robson Gonçalves     | Data | 16.10.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para tratar o retorno do gatilho AD5_SEQUENC.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A250AD5Seq()
	Local cRet := ''
	Local cAD5_NROPOR := ''
	Local cAD5_VEND   := ''
	Local cSQL := ''
	Local cTRB := ''
	Local cAD5_SEQUEN := ''
	
	Local dAD5_DATA   := Ctod(Space(8))

	Local nAD5_SEQUEN := 0

	cAD5_NROPOR := M->AD5_NROPOR
	dAD5_DATA   := M->AD5_DATA
	cAD5_VEND   := M->AD5_VEND
	
	If Empty(cAD5_NROPOR) .And. Empty(cAD5_VEND) .And. Empty(dAD5_DATA)
		MsgInfo('Por gentileza, informe os campos Vendedor, Oportunidade e Data para o sistema inserir a Sequência automaticamente.','Apontamentos')
		cRet := Space( Len( AD5->AD5_SEQUEN ) )
	Else
		nAD5_SEQUEN := Len( AD5->AD5_SEQUEN )
		
		cAD5_SEQUEN := Replicate( '0', nAD5_SEQUEN )
		
		//+----------------------------------------------------------------------------------------+
		//| As chaves única das tabelas são: AD5_FILIAL+AD5_VEND+AD5_DATA                          |
		//|                                  AD6_FILIAL+AD6_VEND+AD6_DATA+AD6_ITEM                 |
		//|                                                                                        |
		//| Importande saber isto p/ não correr problemas de chave duplicada nas duas tabelas.     |
		//|                                                                                        |
		//| Verificar qual é a última sequencia do vendedor na data e sugerir a próxima sequencia. |
		//+----------------------------------------------------------------------------------------+
		
		cSQL := "SELECT ISNULL( MAX( AD5_SEQUEN ), "+ValToSql( cAD5_SEQUEN )+" ) AS AD5_SEQUEN "
		cSQL += "FROM   "+RetSqlName("AD5")+" AD5 "
		cSQL += "WHERE  AD5_FILIAL = "+ValToSql(xFilial("AD5"))+" "
		cSQL += "       AND AD5_VEND = "+ValToSql(cAD5_VEND)+" "
		cSQL += "       AND AD5_DATA = "+ValToSql(dAD5_DATA)+" "
		cSQL += "       AND AD5.D_E_L_E_T_ =  ' ' "
		
		cSQL := ChangeQuery( cSQL )
		cTRB := GetNextAlias()
		dbUseArea( .T., 'TOPCONN', TCGENQRY( , , cSQL ), cTRB, .F., .T. )
		
		If (cTRB)->( BOF() ) .And. (cTRB)->( EOF() )
			cAD5_SEQUEN := StrZero( 1, nAD5_SEQUEN )
		Else
			cAD5_SEQUEN := Soma1( (cTRB)->AD5_SEQUEN,  nAD5_SEQUEN )
		Endif
		(cTRB)->( dbCloseArea() )
		
		cRet := cAD5_SEQUEN
	Endif
Return( cRet )


//-----------------------------------------------------------------------
// Rotina | A250AD5NrO | Autor | Robson Gonçalves     | Data | 16.10.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para tratar o retorno do gatilho AD5_NROPOR.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A250AD5NrO()
	Local cRet := ''
	Local cTab := ''
	Local cKey := ''
	Local cCpoNome := ''
	Local aRet := {}

	AD1->( dbSetOrder( 1 ) )
	If AD1->( dbSeek( xFilial( 'AD1' ) + M->AD5_NROPOR ) )
		If Empty(AD1->AD1_CODCLI) .And. Empty(AD1->AD1_LOJCLI)
			cTab := 'SUS'
			cKey := AD1->( AD1_PROSPE + AD1_LOJPRO )
			cCpoNome := 'US_NOME'
		Else
			cTab := 'SA1'
			cKey := AD1->( AD1_CODCLI + AD1_LOJCLI )
			cCpoNome := 'A1_NOME'
		Endif
		aRet := (cTab)->( GetAdvFVal( cTab, { cCpoNome }, xFilial( cTab ) + cKey, 1 ) )
		M->AD5_NOME := aRet[ 1 ] 
	Endif
	cRet := Iif(Empty(M->AD5_EVENTO),Space( Len( AD5->AD5_EVENTO ) ),M->AD5_EVENTO)
Return( cRet )


//-----------------------------------------------------------------------
// Rotina | A250CalV   | Autor | Robson Gonçalves     | Data | 16.10.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para calcular a data fim quando informar a validade.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A250Validade()
	Local lOK := .F.
	Local lRet := .T.
	
	Local cTitulo := 'Validade da Oportunidade'
	Local cTitCpo := ''
	Local cAD1_VALIDA := ''
	Local nAD1_VALIDA := ''
	
	Local nDias := 0
	
	Local aPar := {}
	Local aRet := {}
	Local aAD1_VALIDA := {}
	
	Local bOk := {|| .T. }
	
	// Procedimento para calcular a data fim quando informar a validade no parâmetro (Parambox).
	bOk := {|| nV:=0,nD:=0,;
	nV:=Val(Iif(ValType(mv_par01)=='C',mv_par01,LTrim(Str(mv_par01,1,0)))),;
	nD:=Val(SubStr(aAD1_VALIDa[nV],At('=',aAD1_VALIDa[nV])+1,At(' ',aAD1_VALIDa[nV])-1)),;
	MsgYesNo('A Oportunidade terá sua validade até a data fim '+Dtoc(AD1->AD1_DTINI+nD)+'. Confirma a gravação?',cTitulo)}

	// Localizar a Oportunidade.
	AD1->( dbSetOrder( 1 ) )
	If AD1->( dbSeek( xFilial( 'AD1' ) + M->AD5_NROPOR ) )
		// Está no estágio 004 e está sendo modificado para o estágio maior que 004 para o processo de CRM 000001.
		// ou
		// Está no estágio 002 e está sendo modificado para o estágio maior ou igual a 003 para o processo de CRM 000002.
		If ( Left( AD1->AD1_STAGE, 3 ) == '004' .And. Left( M->AD5_EVENTO, 3 ) > '004' .And. cAD1PROVEN == '000001' ) .Or.;
		   ( Left( AD1->AD1_STAGE, 3 ) == '003' .And. Left( M->AD5_EVENTO, 3 ) >='004' .And. cAD1PROVEN == '000002' )
			lOK := .T.
		Endif
		If lOK 
			// Se a validade não estiver sido informada, solicitar neste momento.
			If Empty( AD1->AD1_VALIDA )
				// Avisar usuário.
				MsgInfo('A Oportunidade em questão está sem validade, por gentileza, clique em OK para inserir esta informação agora.',cTitulo)
				cTitCpo := 'Informe a ' + RTrim( SX3->(RetTitle( 'AD1_VALIDA' ) ) )
				aAD1_VALIDA := StrToKarr( Posicione( 'SX3', 2, 'AD1_VALIDA', 'X3CBox()' ), ';' )	
				// Solicitar a validade.
				AAdd( aPar, { 2, cTitCpo, 1, aAD1_VALIDA, 60, '', .T. } )
				If ParamBox( aPar, cTitulo, @aRet, bOk, , , , , , , .F., .F. )
					cAD1_VALIDA := Iif( ValType( aRet[ 1 ] ) == 'C', aRet[ 1 ], LTrim( Str( aRet[ 1 ], 1, 0 ) ) )
					nAD1_VALIDA := Val( cAD1_VALIDA )
					nDias := Val(SubStr(aAD1_VALIDa[nAD1_VALIDA],At('=',aAD1_VALIDa[nAD1_VALIDA])+1,At(' ',aAD1_VALIDa[nAD1_VALIDA])-1))
					If M->AD5_NROPOR <> AD1->AD1_NROPOR
						AD1->( dbSeek( xFilial( 'AD1' ) + M->AD5_NROPOR ) )
					Endif
					AD1->( RecLock( 'AD1', .F. ) )
					AD1->AD1_DTFIM := AD1->AD1_DTINI + nDias
					AD1->AD1_VALIDA := cAD1_VALIDA
					AD1->( MsUnLock() )
				Else
					lRet := .F.
				Endif
		   Endif
		Endif
	Endif
Return( lRet )


//-----------------------------------------------------------------------
// Rotina | A250VlEst  | Autor | Robson Gonçalves     | Data | 08.10.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para validar se o campo Feeling no apontamento está ou
//        | foi preenchido.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A250VlEst()
	Local lOK := .F.
	Local lRet := .T.
	Local cTitCpo := ''
	Local cTitulo := 'Informar Feeling'
	
	Local cAD5_FEELIN := ''
	
	Local aPar := {}
	Local aRet := {}
	Local aAD1_FEELIN := {}
	
	If Empty( M->AD5_FEELIN )
		If Left(M->AD5_EVENTO,3) $ '003|004|005|006' .And. cAD1PROVEN == '000001'
			lOK := .T.
			MsgAlert('A mudança de estágio entre 003 e 006 obriga o preenchimento do campo Feeling, por favor, informe este dado agora.','A250VLEST')
		Endif
		If Left(M->AD5_EVENTO,3) == '004' .And. cAD1PROVEN == '000002'
			lOK := .T.
			MsgAlert('A mudança de estágio para 004 obriga o preenchimento do campo Feeling, por favor, informe este dado agora.','A250VLEST')
		Endif
		If lOK
			cTitCpo := 'Informe o ' + RTrim( SX3->(RetTitle( 'AD1_FEELIN' ) ) )
			aAD1_FEELIN := StrToKarr( Posicione( 'SX3', 2, 'AD1_FEELIN', 'X3CBox()' ), ';' )	
			AAdd( aPar, { 2, cTitCpo, 1, aAD1_FEELIN, 60, '', .T. } )
			If ParamBox( aPar, cTitulo, @aRet, , , , , , , , .F., .F. )
				If ValType(aRet[ 1 ])=='N'
					cAD5_FEELIN := LTrim(Str(aRet[1],1,0))
				Else
					cAD5_FEELIN := aRet[ 1 ]
				Endif
				M->AD5_FEELIN := cAD5_FEELIN
				If M->AD5_NROPOR <> AD1->AD1_NROPOR
					AD1->( dbSeek( xFilial( 'AD1' ) + M->AD5_NROPOR ) )
				Endif
				If AD1->(Found())
					AD1->( RecLock( 'AD1', .F. ) )
					AD1->AD1_FEELIN := cAD5_FEELIN
					AD1->( MsUnLock() )
				Endif
			Else
				lRet := .F.
			Endif
		Endif
	EndIF
	
Return(lRet)


//-----------------------------------------------------------------------
// Rotina | A250CalV   | Autor | Robson Gonçalves     | Data | 16.10.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para calcular a data fim quando informar a validade.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A250CalV()
	Local nDias := 0
	Local nAD1_VALIDA := 0
	aAD1_VALIDA := StrToKarr( Posicione( 'SX3', 2, 'AD1_VALIDA', 'X3CBox()' ), ';' )	
	nAD1_VALIDA := Val( M->AD1_VALIDA )
	nDias := Val(SubStr(aAD1_VALIDa[nAD1_VALIDA],At('=',aAD1_VALIDa[nAD1_VALIDA])+1,At(' ',aAD1_VALIDa[nAD1_VALIDA])-1))
	M->AD1_DTFIM := M->AD1_DTINI + nDias
Return(.T.)


//-----------------------------------------------------------------------
// Rotina | A250ExpV   | Autor | Robson Gonçalves     | Data | 16.10.2013
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar acionada pelo ponto de entrada FT310LOK.
//-----------------------------------------------------------------------
// Update | Alterações na validação de expectativa de verba, e verifica
//        | se há produto cadastrado - Rafael Beghini 28.03.2016
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A250ExpV()
	Local lRet := .T.
	
	Local nZE_VALOR   := 0
	Local nADJ_PROD   := 0
	Local nAD9_CODCON := 0
	
	Local aPar := {}
	Local aret := {}
	
	Local cTitulo := 'Apontamento - A250ExpV'
	
	AD1->( dbSetOrder( 1 ) )
	AD1->( dbSeek( xFilial( 'AD1' ) + M->AD5_NROPOR ) )
	
	If AD1->(Found())
		//Critica se não tiver Produto e/ou Contato cadastrado na oportunidade
		If Left(M->AD5_EVENTO,3) >= '004' .And. cAD1PROVEN $ '000001|000002'
			If M->AD5_NROPOR <> AD1->AD1_NROPOR
				AD1->( dbSeek( xFilial( 'AD1' ) + M->AD5_NROPOR ) )
			Endif
			
			//Verifica produtos na Oportunidade
			If M->AD5_NROPOR <> ADJ->ADJ_NROPOR
				ADJ->( dbSeek( xFilial( 'ADJ' ) + M->AD5_NROPOR ) )
			Endif
			While .NOT. ADJ->( EOF() ) .And. ADJ->ADJ_FILIAL == xFilial('ADJ') .And. ADJ->ADJ_NROPOR == M->AD5_NROPOR
				nADJ_PROD++
				ADJ->( dbSkip() )
			End
			
			//Verifica contatos na Oportunidade
			IF M->AD5_NROPOR <> AD9->AD9_NROPOR
				AD9->( dbSeek( xFilial( 'AD9' ) + M->AD5_NROPOR ) )
			EndIF
			While .NOT. AD9->( EOF() ) .And. AD9->AD9_FILIAL == xFilial('AD9') .And. AD9->AD9_NROPOR == M->AD5_NROPOR
				nAD9_CODCON++
				AD9->( dbSkip() )
			End
			
			If nADJ_PROD == 0 .OR. nAD9_CODCON == 0
				MsgInfo('A oportunidade está sem produto e/ou contato cadastrado, por favor, informe os dados para evoluir o estágio.',cTitulo)
				FwMsgRun(,{|| IIF( A250Prod( M->AD5_NROPOR ), lRet := .T., lRet := .F. ) },cTitulo,;
							'Aguarde, carregando a oportunidade de venda para informar os dados...')
			Endif
			
			// Verificar se a verba não está informada indo para o estágio maior que 002 nos processos CRM 000001|000002.
			/*
			If lRet
				If M->AD5_VERBA == 0
					MsgInfo('Por gentileza, informar o valor da verba no Apontamento da Oportunidade.',cTitulo)
					AAdd( aPar, { 1, 'Verba', 0.00, '@E 999,999,999.99', 'Positivo()', '', '',70 , .T. } )
					If ParamBox( aPar, 'Informe o valor da verba', @aRet, , , , , , , , .F., .F. )
						M->AD5_VERBA := aRet[ 1 ] 
						If M->AD5_NROPOR <> AD1->AD1_NROPOR
							AD1->( dbSeek( xFilial( 'AD1' ) + M->AD5_NROPOR ) )
						Endif
						If AD1->(Found())
							AD1->( RecLock( 'AD1', .F. ) )
							AD1->AD1_VERBA := aRet[ 1 ]
							AD1->( MsUnLock() )
						Endif
					Else
						lRet := .F.
					Endif
				Endif
			Endif*/
		Endif
		// Está sendo modificado do estágio 004 para 005 com feeling >= 60% (2 ou 3), obrigar o preenchimento da expectativa para o processo CRM 000001
		// Está sendo modificado do estágio 004 para 005 com qualquer feeling, obrigar o preenchimento da expectativa para o processo CRM 000002
		If lRet .And. Left( AD1->AD1_STAGE, 3 ) >= '004' .And. Left( M->AD5_EVENTO, 3 ) == '005' .And. cAD1PROVEN $ '000001|000002'
			nZE_VALOR := A250SZE( M->AD5_NROPOR )
			// Feeling está em 2=60% ou 3=90% no processo CRM 000001
			// Processo CRM 000002 com qualquer feeling?
			If (M->AD5_FEELIN $ '2|3' .And. cAD1PROVEN == '000001') .Or. cAD1PROVEN == '000002'
				If nZE_VALOR == 0
					lRet := .F.
					MsgInfo('Não há valor na expectativa mensal de verba, por gentileza clique em OK para informar agora.',cTitulo)
					lRet := U_CTSA041()
				Endif
				If lRet
					If nZE_VALOR > AD1->AD1_VERBA
						lRet := .F.
						MsgInfo('Por gentileza, a relação da expectativa mensal de verba informada deve ser menor ou igual a expectativa de verba.',cTitulo)
					Endif
				Endif
			Endif
		ElseIF lRet
			// Está sendo modificado para os estágios 006|008|010 para o processo CRM 000001, obrigar o preenchimento da expectativa.
			// Está sendo modificado para estágios >= 005 para o processo CRM 000002, obrigar o preenchimento da expectativa.
			If ( Left( M->AD5_EVENTO, 3 ) $ '006|008|010' .And. cAD1PROVEN == '000001' ) .Or. ( Left( M->AD5_EVENTO, 3 ) >= '005' .And. cAD1PROVEN == '000002')
				IF .NOT. ( M->AD5_EVENTO $ '006PER|006NPA' )
					nZE_VALOR := A250SZE( M->AD5_NROPOR )
					If nZE_VALOR == 0
						lRet := .F.
						MsgInfo('Não há valor na expectativa mensal de verba, por gentileza clique em OK para informar agora.',cTitulo)
						lRet := U_CTSA041()
					Endif
					If lRet
						If nZE_VALOR > AD1->AD1_VERBA
							lRet := .F.
							MsgInfo('Por gentileza, a relação da expectativa mensal de verba informada deve ser menor ou igual a expectativa de verba.',cTitulo)
						Endif
					Endif
				EndIF
			Endif
		Endif
	Endif
		
	// Se todas as regras acima estiverem OK, verificar se a verba e o feeling estão diferentes, se estiverem atribuir o novo valor.
	If lRet
		If M->AD5_NROPOR <> AD1->AD1_NROPOR
			AD1->( dbSeek( xFilial( 'AD1' ) + M->AD5_NROPOR ) )
		Endif
		AD1->( RecLock( 'AD1', .F. ) )
		/*If AD1->AD1_VERBA <> M->AD5_VERBA
			AD1->AD1_VERBA  := M->AD5_VERBA
		Endif*/
		If AD1->AD1_FEELIN <> M->AD5_FEELIN
			AD1->AD1_FEELIN := M->AD5_FEELIN
		Endif
		AD1->( MsUnLock() )
	Endif
Return(lRet)


//-----------------------------------------------------------------------
// Rotina | A250SumVlr | Autor | Robson Gonçalves     | Data | 26.05.2014
//-----------------------------------------------------------------------
// Descr. | Rotina para atualizar o total dos produtos em AD1.
//        | Rotina executada pelo ponto de entrada FT300VLD e pelo 
//        | gatilho ADJ_QUANT - 001.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A250SumVlr()

	Local nI          := 0
	Local nAD1_VERBA  := 0
	Local oModelx     := FWModelActive()
	Local oGetDad5    := oModelx:GetModel('ADJDETAIL')
	Local oDetAD1     := oModelx:GetModel('AD1MASTER')
	Local isDeleted   := .F. 
	Local cQuant      := ""
	Local nLinha      := 0
	
	cQuant := oModelx:GetValue('ADJDETAIL','ADJ_QUANT')
	nLinha := oGetDad5:nLine
	
	For nI := 1 To oGetDad5:Length()
		oGetDad5:GoLine(nI)
		isDeleted := oGetDad5:aDataModel[nI,3]
		
		If !isDeleted
			nAD1_VERBA += oModelx:GetValue('ADJDETAIL','ADJ_VALOR')
		Endif
	Next nI
	
	oGetDad5:GoLine(nLinha)
	oGetDad5:SetValue('ADJ_QUANT', cQuant)
	
	If nAD1_VERBA > 0
		oDetAD1:SetValue('AD1_VERBA', nAD1_VERBA)
	EndIf
	
Return( .T. )


//-----------------------------------------------------------------------
// Rotina | A250SZE    | Autor | Robson Gonçalves     | Data | 27.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para apurar o valor da expectativa mensal de verba.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A250SZE( cAD5_NROPOR)
	Local cSQL := ''
	Local cTRB := ''
	Local nZE_VALOR := 0
	cSQL := "SELECT ISNULL( SUM( ZE_VALOR ), 0 ) ZE_VALOR "
	cSQL += "FROM   "+RetSqlName('SZE')+" SZE "
	cSQL += "WHERE  ZE_FILIAL = "+ValToSql( xFilial( 'SZE' ) )+" "
	cSQL += "       AND ZE_NROPOR = "+ValToSql( cAD5_NROPOR )+" "
	cSQL += "       AND SZE.D_E_L_E_T_ = ' ' "
	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	dbUseArea( .T., 'TOPCONN', TCGENQRY( , , cSQL ), cTRB, .F., .T. )
	If (cTRB)->( .NOT. BOF() ) .And. (cTRB)->( .NOT. EOF() )
		nZE_VALOR := (cTRB)->ZE_VALOR
	Endif
	(cTRB)->( dbCloseArea() )
Return(nZE_VALOR)


//-----------------------------------------------------------------------
// Rotina | A250Picture| Autor | Robson Gonçalves     | Data | 16.10.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para dinamizar a picture do campo AD1_CNPJ.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A250Picture()
	Local cPic := ''
	Local cTab := ''
	Local cKey := ''
	Local cCpo := ''
	Local cCNPJ := ''
	Local aRet := {'',''}
	
	If Empty(M->AD1_CODCLI) .And. Empty(M->AD1_LOJCLI)
		cTab := 'SUS'
		cKey := M->AD1_PROSPE + M->AD1_LOJPRO
		cCpo := 'US_PESSO'
		cCNPJ := 'US_CGC'
	Else
		cTab := 'SA1'
		cKey := M->AD1_CODCLI + M->AD1_LOJCLI
		cCpo := 'A1_PESSOA'
		cCNPJ := 'A1_CGC'
	Endif
	If cTab <> '' .And. cCpo <> '' .And. cCNPJ <> '' .And. cKey <> ''
		aRet := (cTab)->( GetAdvFVal( cTab, { cCpo, cCNPJ }, xFilial( cTab ) + cKey, 1 ) )
	Endif
	If aRet[ 1 ] == 'F'
		cPic := '@R 999.999.999-99'
	Else
		cPic := '@R 99.999.999/9999-99'
	Endif
	cPic := cPic + '%C'
Return( cPic )


//-----------------------------------------------------------------------
// Rotina | A250Prec   | Autor | Robson Gonçalves     | Data | 23.06.2014
//-----------------------------------------------------------------------
// Descr. | Rotina que avalia a possibilidade de edição dos campos
//        | ADJ_PRUNIT e ADJ_VALOR. Esta rotina é acionada no X3_WHEN
//        | dos campos mencionados.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A250Prec()
	Local cX6_PRC1  := ''
	Local cX6_PRC2  := ''
	Local cMV250PR1 := 'MV_250PREC'
	Local cMV250PR2 := 'MV_250PRCB'
	Local cCODUSR   := RetCodUsr()
	Local lRet      := .F.
	
	cX6_PRC1 := '000554|000908|000208|000776|000222|000948|000979|000683|000773'
	cX6_PRC2 := '002727'
	//              |      |      |      |      |      |      |      |      |
	//              |      |      |      |      |      |      |      |      +----> Maria Bortolan
	//              |      |      |      |      |      |      |      +-----------> Beatriz 
	//              |      |      |      |      |      |      +------------------> Hugo Cesário
	//              |      |      |      |      |      +-------------------------> Irian
	//              |      |      |      |      +--------------------------------> Milene
	//              |      |      |      +---------------------------------------> Natalia
	//              |      |      +----------------------------------------------> Camila
	//              |      +-----------------------------------------------------> Bruna Morais
	//              +------------------------------------------------------------> Luiz Eduardo Coelho
		
	If .NOT. GetMv( cMV250PR1, .T. )
		CriarSX6( cMV250PR1, 'C', 'CODIGO DE USUÁRIOS PERMITIDOS ALTERAR O PRECO NA OPORTUNIDADE. CSFA250.prw.', cX6_PRC1 )
	Endif
	cX6_PRC1 := GetMv( cMV250PR1, .F. )
	////////////////////////////////////////////////////////////
	If .NOT. GetMv( cMV250PR2, .T. )
		CriarSX6( cMV250PR2, 'C', 'CODIGO DE USUÁRIOS PERMITIDOS ALTERAR O PRECO NA OPORTUNIDADE. CSFA250.prw.', cX6_PRC2 )
	Endif
	cX6_PRC2 := GetMv( cMV250PR2, .F. )
	////////////////////////////////////////////////////////////
	IF cCODUSR $ cX6_PRC1 .OR. cCODUSR $ cX6_PRC2
		lRet := .T.
	EndIF
	
Return( lRet )


//-----------------------------------------------------------------------
// Rotina | A250Tabela | Autor | Robson Gonçalves     | Data | 23.06.2014
//-----------------------------------------------------------------------
// Descr. | Rotina para criar e retornar o código da tabela de preço
//        | no cadastro de oportunidade.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A250Tabela()
	Local cMV_250TABP := 'MV_250TABP'
	If .NOT. GetMv( cMV_250TABP, .T. )
		CriarSX6( cMV_250TABP, 'C', 'PARAMETRO COM O CODIGO DA TABELA DE PRECO UTILIZADO NA OPORTUNIDADES CSFA250.prw','038')
	Endif
	cMV_250TABP := GetMv( cMV_250TABP, .F. )
	If Empty( cMV_250TABP )
		cMV_250TABP := Space( Len( AD1->AD1_TABELA ) )
	Endif
Return( cMV_250TABP )


//-----------------------------------------------------------------------
// Rotina | A250TrF3   | Autor | Robson Gonçalves     | Data | 23.06.2014
//-----------------------------------------------------------------------
// Descr. | Rotina para determinar qual consulta padrão será chamada.
//        | Funcionalidade acionada pelo gatilho do campo AD1_TABELA-001.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A250TrF3()
	Local cVar := &( ReadVar() )
	Local cMV_250F3 := 'MV_250F3'
	Local lA250F3   := .F.
	
	If .NOT. SX6->( ExisteSX6( cMV_250F3 ) )
		CriarSX6( cMV_250F3, 'L', 'Utiliza consulta padrão Descrição amigavel do produto. CSFA250.prw', '.T.' )
	Endif
	
	// Capturar o conteúdo do parâmetro.
	lA250F3 := GetMv( cMV_250F3 )
	
	If .NOT. Empty( M->AD1_TABELA )
		IF lA250F3
			A250ChF3( 'ADJ_PROD', 'ADJ01' )		
		Else
			A250ChF3( 'ADJ_PROD', '250DA1' )
		EndIF
	Else
		A250ChF3( 'ADJ_PROD', Posicione( 'SX3', 2, 'ADJ_PROD', 'X3_F3' ) )
	Endif
	
Return( cVar )


//-----------------------------------------------------------------------
// Rotina | A250ChF3   | Autor | Robson Gonçalves     | Data | 23.06.2014
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar que contempla a funcionalidade da rotina 
//        | A250TrF3, seu objetivo é atribuir a variável aTrocaF3 o alias 
//        | da tabela conforme tabela de preço informada.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A250ChF3( cFieldF3, cXB_ALIAS )
	Local nP := 0
	//-------------------------------------------------------
	// Declara variável caso a aTrocaF3 não esteja declarada.
	//-------------------------------------------------------
	If Type( 'aTrocaF3' ) <> 'A'
		_SetNamedPrvt( 'aTrocaF3', {}, '__EXECUTE' )
	Endif
	//-------------------------------------------------
	// Localiza na aTrocaF3 se o campo já possui troca.
	//-------------------------------------------------
	nP := AScan( aTrocaF3, {|p| p[ 1 ] == cFieldF3 } )
	//----------------------------------------
	// Caso não esteja da array, cria posição.
	//----------------------------------------
	If nP == 0
		AAdd( aTrocaF3, { , } )
		nP := Len( aTrocaF3 )
		aTrocaF3[ nP, 1 ] := cFieldF3
	Endif
	//------------------------
	// Modifica o F3 do campo.
	//------------------------
	aTrocaF3[ nP, 2 ] := cXB_ALIAS
Return


//-----------------------------------------------------------------------
// Rotina | A250Stru   | Autor | Robson Gonçalves     | Data | 23.06.2014
//-----------------------------------------------------------------------
// Descr. | Rotina para descarregar a estrutura do produto na oportuni-
//        | dade. Rotina acionada pelo X3_VLDUSER do campo ADJ_PROD
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A250Stru()
	
	Local nADJ_PROD   := 0
	Local nADJ_QUANT  := 0
	Local nADJ_PRUNIT := 0
	Local aArea       := {}
	Local lFirst      := .T.
	Local oModelx     := FWModelActive()
	Local oGetDad5    := oModelx:GetModel('ADJDETAIL')
	
	If !IsInCallStack("U_CSFA110")
		//---------------------
		// Salvar a área atual.
		//---------------------
		aArea := GetArea()
		//--------------------------------
		// Capcturar a posição dos campos.
		//--------------------------------
		nADJ_PROD   := AScan( oGetDad5:aHeader, { |p| RTrim( p[ 2 ] ) == 'ADJ_PROD'   } )
		nADJ_QUANT  := AScan( oGetDad5:aHeader, { |p| RTrim( p[ 2 ] ) == 'ADJ_QUANT'  } )
		nADJ_PRUNIT := AScan( oGetDad5:aHeader, { |p| RTrim( p[ 2 ] ) == 'ADJ_PRUNIT' } )
		//------------------------------------------------------------------------------------------------------------
		// Verificar se a linha atual há código de produto, havendo, executar o processo, do contrário não fazer nada.
		//------------------------------------------------------------------------------------------------------------
		If Empty( oModelx:GetValue('ADJDETAIL','ADJ_PROD') )
			//-------------------------------------------------------------------------------------
			// Verificar se o código do produto é produto principal na Sugestão de Orçamento (SBH).
			//-------------------------------------------------------------------------------------
			If .NOT. A250Main( M->ADJ_PROD, nADJ_QUANT, nADJ_PRUNIT, lFirst )
				//---------------------------------------------------------------------------------------
				// Verificar se o código do produto é um único componente na Sugestão de Orçamento (SBH).
				//---------------------------------------------------------------------------------------
				If .NOT. A250OneComponent( M->ADJ_PROD, nADJ_QUANT, nADJ_PRUNIT, lFirst ) 
					//-----------------------------------------------------------------------------------------------------------
					// Verificar se o código do produto é componene em vários produtos principais na Sugestão de Orçamento (SBH).
					//-----------------------------------------------------------------------------------------------------------
					A250MoreThanOne( M->ADJ_PROD, nADJ_QUANT, nADJ_PRUNIT, lFirst )
				Endif
			Endif
		Endif
		//------------------
		// Restaurar a área.
		//------------------
		RestArea( aArea )
	EndIf
	
Return( .T. )


//-----------------------------------------------------------------------
// Rotina | A250Main   | Autor | Robson Gonçalves     | Data | 23.06.2014
//-----------------------------------------------------------------------
// Descr. | Rotina para descarregar a estrutura do produto quando o 
//        | produto informado for o principal da estrutura.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A250Main( cADJ_PROD, nADJ_QUANT, nADJ_PRUNIT, lFirst )
	Local lFound := .F.
	//--------------------------------------
	// Veriricar se o produto é o principal.
	//--------------------------------------
	SBH->( dbSetOrder( 1 ) )
	lFound := SBH->( dbSeek( xFilial( 'SBH' ) + cADJ_PROD ) )
	If lFound
		//--------------------------------------------------------------------
		// Sendo o produto principal carregar ele e seus componentes no aCOLS.
		//--------------------------------------------------------------------
		A250LoadGD( SBH->BH_PRODUTO, 1, nADJ_QUANT, nADJ_PRUNIT, @lFirst )
		While .NOT. SBH->( EOF() ) .And. SBH->BH_FILIAL == xFilial( 'SBH' ) .And. SBH->BH_PRODUTO == cADJ_PROD
			A250LoadGD( SBH->BH_CODCOMP, SBH->BH_QUANT, nADJ_QUANT, nADJ_PRUNIT, @lFirst )
			SBH->( dbSkip() )
		End		
	Endif	
Return(lFound)


//-----------------------------------------------------------------------
// Rotina | A250OneComponent | Autor | Robson Gonçalves|Data | 23.06.2014
//-----------------------------------------------------------------------
// Descr. | Rotina para descarregar a estrutura do produto quando o 
//        | produto informado não for o principal e possuir em uma única
//        | estrutura.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A250OneComponent( cADJ_PROD, nADJ_QUANT, nADJ_PRUNIT, lFirst )
	Local cSQL := ''
	Local cBH_PRODUTO := ''
	Local lSeparado := .F.
	Local nSQL_COUNT := 0
	//---------------------------------------------------------------------------------------------------
	// O produto já foi avaliado e não é principal, então verificar se ele está em somente uma estrutura.
	//---------------------------------------------------------------------------------------------------
	cSQL := "SELECT COUNT(*) nHowMany "
	cSQL += "FROM   "+RetSqlName("SBH")+" SBH_2 "
	cSQL += "WHERE  SBH_2.BH_FILIAL = "+ValToSql( xFilial("SBH") ) + " "
	cSQL += "       AND SBH_2.BH_CODCOMP = "+ValToSql( cADJ_PROD ) + " "
	cSQL += "       AND SBH_2.D_E_L_E_T_ = ' ' "

	cSQL := ChangeQuery( cSQL )
	dbUseArea( .T., "TOPCONN", TCGENQRY(,, cSQL ), "SQLCOUNT", .F., .T. )
	nSQL_COUNT := SQLCOUNT->nHowMany
	SQLCOUNT->( dbCloseArea() )
   //-------------------------------------------------------------------------------------------------------------------
   // Se caso o produto fizer parte de uma única estrutura, descarregar o produto principal e seus componentes no aCOLS.
   //-------------------------------------------------------------------------------------------------------------------
	If nSQL_COUNT == 1
		//-------------------------------------------------------------------------
		// Posicionar no produto informado e captura o código do produto principal.
		//-------------------------------------------------------------------------
		SBH->( dbSetOrder( 2 ) )
		SBH->( dbSeek( xFilial( 'SBH' ) + cADJ_PROD ) )
		cBH_PRODUTO := SBH->BH_PRODUTO
		//---------------------------------------------------------------------------
		// Verificar se o produto informado pode ser oferecido separado da estrutura.
		//---------------------------------------------------------------------------
		If SBH->BH_INDEPEN == 'S'
			lSeparado := MsgYesNo('O produto '+RTrim( cADJ_PROD )+'-'+RTrim( Posicione( 'SB1', 1, xFilial('SB1') + cADJ_PROD, 'B1_DESC' ) )+' '+;
			'pode ser oferecido independente da sua estrutura. Você deseja ofertá-lo separadamente?', cCadastro )
		Endif 
		If .NOT. lSeparado
			//------------------------------------------------------------------------
			// Agora com o produto principal carregar ele e seus componentes no aCOLS.
			//------------------------------------------------------------------------
			A250LoadGD( SBH->BH_PRODUTO, 1, nADJ_QUANT, nADJ_PRUNIT, @lFirst )
			SBH->( dbSetOrder( 1 ) )
			SBH->( dbSeek( xFilial( 'SBH' ) + cBH_PRODUTO ) )
			While .NOT. SBH->( EOF() ) .And. SBH->BH_FILIAL == xFilial( 'SBH' ) .And. SBH->BH_PRODUTO == cBH_PRODUTO
				A250LoadGD( SBH->BH_CODCOMP, SBH->BH_QUANT, nADJ_QUANT, nADJ_PRUNIT, @lFirst )
				SBH->( dbSkip() )
			End
		Endif
	Endif
Return( nSQL_COUNT == 1 )


//-----------------------------------------------------------------------
// Rotina | A250MoreThanOne | Autor | Robson Gonçalves |Data | 23.06.2014
//-----------------------------------------------------------------------
// Descr. | Rotina para descarregar a estrutura do produto quando o 
//        | produto informado não for o principal e possuir em mais de
//        | uma estrutura.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A250MoreThanOne( cADJ_PROD, nADJ_QUANT, nADJ_PRUNIT, lFirst )
	Local cTRB := ''
	Local cSQL := ''
	Local cPesq := Space( Len( SBH->BH_PRODUTO ) )
	Local cCargo := ''
	
	Local lSeparado := .F.
	
	Local oDlg 
	Local oTree
	Local oPanel
	
	Local nOpc := 0
	
	//-------------------------------------------------------------------------------------------------------------------------------------------------
	// O produto informado não sendo principal e não existindo somente em uma estrutura, pegar o código principal de todas estruturas que ele pertence.
	//-------------------------------------------------------------------------------------------------------------------------------------------------
	cSQL := "SELECT BH_PRODUTO, BH_CODCOMP, B1_DESC "
	cSQL += "FROM   "+RetSqlName("SBH")+" SBH "
	cSQL += "       INNER JOIN "+RetSqlName("SB1")+" SB1 "
	cSQL += "               ON B1_FILIAL = "+ValToSql( xFilial( "SB1" ) ) + " "
	cSQL += "              AND B1_COD = BH_CODCOMP "
	cSQL += "              AND SB1.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE BH_FILIAL = "+ValToSql( xFilial( "SBH" ) ) + " "
	cSQL += "      AND BH_PRODUTO IN (SELECT SBH_2.BH_PRODUTO "
	cSQL += "                        FROM   "+RetSqlName("SBH")+" SBH_2 "
	cSQL += "                        WHERE SBH_2.BH_FILIAL = "+ValToSql( xFilial( "SBH" ) ) + " "
	cSQL += "                              AND SBH_2.BH_CODCOMP = "+ValToSql( cADJ_PROD ) + " "
	cSQL += "                              AND SBH_2.D_E_L_E_T_ = ' ') "
	cSQL += "      AND SBH.D_E_L_E_T_ = ' ' "
	cSQL += "ORDER BY BH_PRODUTO, BH_CODCOMP "
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	PLSQuery( cSQL, cTRB )
	
	If .NOT. (cTRB)->( BOF() ) .And. .NOT. (cTRB)->( EOF() )
		SBH->( dbSetOrder( 2 ) )
		SBH->( dbSeek( xFilial( 'SBH' ) + cADJ_PROD ) )
		If SBH->BH_INDEPEN == 'S'
			lSeparado := MsgYesNo('O produto '+RTrim( cADJ_PROD )+'-'+RTrim( Posicione( 'SB1', 1, xFilial('SB1') + cADJ_PROD, 'B1_DESC' ) )+' '+;
			'pode ser oferecido independente da sua estrutura. Você deseja ofertá-lo separadamente?', cCadastro )
		Endif
		If .NOT. lSeparado
			DEFINE MSDIALOG oDlg TITLE 'Estrutura de Produto' FROM 0,0 TO 300,550 PIXEL STYLE DS_MODALFRAME STATUS
				oDlg:lEscClose := .F.
				
				oPanel := TPanel():New(1,1,,oDlg,,,,,,0,17)
				oPanel:Align := CONTROL_ALIGN_BOTTOM
				
				oTree := xTree():New( 0, 0, 0, 0, oDlg, {|| cCargo := oTree:GetCargo() } )
				oTree:Align := CONTROL_ALIGN_ALLCLIENT
				
				@ 3,03 MsGet cPesq Picture "@!" SIZE 114,10 PIXEL OF oPanel
				@ 3,120 BUTTON "&Pesquisar" SIZE 36,12 OF oPanel PIXEL ACTION A250Pesq( @oTree, cPesq )
				@ 3,200 BUTTON "&Confirmar" SIZE 36,12 OF oPanel PIXEL ACTION Iif( A250Ok( @oTree, cCargo ),( nOpc:=1, oDlg:End() ), NIL )
				@ 3,240 BUTTON "&Sair"      SIZE 36,12 OF oPanel PIXEL ACTION oDlg:End()
			ACTIVATE MSDIALOG oDlg CENTER ON INIT FwMsgRun(,{|| A250Tree( cTRB, @oTree, @cCargo ) },,'Aguarde, carregando estrutura de produtos.')
			If nOpc == 1
				SBH->( dbSetOrder( 1 ) )
				SBH->( dbSeek( xFilial( 'SBH' ) + cCargo ) )
				//------------------------------------------------------------------------------
				// Com o produto principal selecionado carregar ele e seus componentes no aCOLS.
				//------------------------------------------------------------------------------
				A250LoadGD( SBH->BH_PRODUTO, 1, nADJ_QUANT, nADJ_PRUNIT, @lFirst )
				While .NOT. SBH->( EOF() ) .And. SBH->BH_FILIAL == xFilial( 'SBH' ) .And. SBH->BH_PRODUTO == cCargo
					A250LoadGD( SBH->BH_CODCOMP, SBH->BH_QUANT, nADJ_QUANT, nADJ_PRUNIT, @lFirst )
					SBH->( dbSkip() )
				End
			Endif
		Endif
	Endif
	(cTRB)->( dbCloseArea() )
Return


//-----------------------------------------------------------------------
// Rotina | A250Tree   | Autor | Robson Gonçalves     | Data | 23.06.2014
//-----------------------------------------------------------------------
// Descr. | Rotina para montar a estrutura xTree conforme os dados.
//        | 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A250Tree( cTRB, oTree, cCargo )
	Local cBH_PRODUTO
	Local cB1_DESC
	cCargo := (cTRB)->BH_PRODUTO
	While .NOT. (cTRB)->( EOF() )
		cBH_PRODUTO := (cTRB)->BH_PRODUTO
		cB1_DESC := Posicione( 'SB1', 1, xFilial( 'SB1' ) + cBH_PRODUTO, 'B1_DESC' )				
		oTree:AddTree( cBH_PRODUTO + ' - ' + RTrim( cB1_DESC ), 'PMSEDT3', 'PMSDOC', cBH_PRODUTO, {|| .T.}, {|| .T.}, {|| .T.} )
		While .NOT. (cTRB)->( EOF() ) .And. (cTRB)->BH_PRODUTO == cBH_PRODUTO
			oTree:AddTreeItem( (cTRB)->BH_CODCOMP + ' - ' + RTrim( (cTRB)->B1_DESC ), 'NEXT_PQ.PNG', '#@#@#'+(cTRB)->BH_CODCOMP, {||.T.}, {||.T.}, {||.T.} )
			(cTRB)->( dbSkip() )
		End
		oTree:EndTree()
	End		
	oTree:EndTree()
Return(.T.)


//-----------------------------------------------------------------------
// Rotina | A250Pesq   | Autor | Robson Gonçalves     | Data | 23.06.2014
//-----------------------------------------------------------------------
// Descr. | Rotina para pesquisar o produto na estrutura XTree.
//        | 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A250Pesq( oTree, cPesq )
	If .NOT. oTree:TreeSeek( cPesq )
		If .NOT. oTree:TreeSeek( '#@#@#' + cPesq )
			MsgAlert( 'Código de produto não localizado.', 'Pesquisar' )
		Endif
	Endif
Return


//-----------------------------------------------------------------------
// Rotina | A250Ok     | Autor | Robson Gonçalves     | Data | 23.06.2014
//-----------------------------------------------------------------------
// Descr. | Rotina para validar o botão confirma.
//        | 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A250Ok( oTree, cCargo )
	Local lRet := .T.
	If Left( cCargo, 5 ) == '#@#@#'
		lRet := .F.
		MsgAlert( 'Por favor, selecione o produto principal para descarregar a estrutura de produtos.', 'Validar seleção')
	Endif
Return(lRet)


//-----------------------------------------------------------------------
// Rotina | A250LoadGD | Autor | Robson Gonçalves     | Data | 23.06.2014
//-----------------------------------------------------------------------
// Descr. | Rotina para descarregar os produtos na MsNewGetDados da 
//        | oportunidades.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A250LoadGD( cCodProd, nQuant, nADJ_QUANT, nADJ_PRUNIT, lFirst )
	Local nI := 0
	Local nElem := 0
	
	Local cTab := ''
	Local cRet := ''
	Local cKey := ''
	Local cCpo := ''
	
	If Empty( M->AD1_TABELA )
		cTab := 'SB1'
		cRet := 'B1_PRV1'
	Else
		cTab := 'DA1'
		cRet := 'DA1_PRCVEN'
		cKey := M->AD1_TABELA
	Endif
	
	If lFirst
		lFirst := .F.
		nElem  := oGetDad5:nAt
	Else
		AAdd( oGetDad5:aCOLS, Array( Len( oGetDad5:aHeader )+1 ) )
		nElem := Len( oGetDad5:aCOLS )
	Endif
	
	For nI := 1 To Len( oGetDad5:aHeader )
		cCpo := RTrim( oGetDad5:aHeader[ nI, 2 ] )
		If     cCpo == 'ADJ_ITEM'   ; oGetDad5:aCOLS[ nElem, nI ] := StrZero( nElem, 3, 0 )
		Elseif cCpo == 'ADJ_PROD'   ; oGetDad5:aCOLS[ nElem, nI ] := cCodProd
		Elseif cCpo == 'ADJ_DPROD'  ; oGetDad5:aCOLS[ nElem, nI ] := Posicione( 'SB1', 1, xFilial( 'SB1' ) + cCodProd, 'B1_DESC')
		Elseif cCpo == 'ADJ_QUANT'  ; oGetDad5:aCOLS[ nElem, nI ] := nQuant
		Elseif cCpo == 'ADJ_PRUNIT' ; oGetDad5:aCOLS[ nElem, nI ] := Posicione( cTab, 1, xFilial( cTab ) + cKey + cCodProd, cRet )
		Elseif cCpo == 'ADJ_VALOR'  ; oGetDad5:aCOLS[ nElem, nI ] := oGetDad5:aCOLS[ nElem, nADJ_QUANT ]*oGetDad5:aCOLS[ nElem, nADJ_PRUNIT ]
		Elseif cCpo == 'ADJ_REVISA' ; oGetDad5:aCOLS[ nElem, nI ] := '01'
		Elseif cCpo == 'ADJ_ALI_WT' ; oGetDad5:aCOLS[ nElem, nI ] := 'ADJ'
		Elseif cCpo == 'ADJ_REC_WT' ; oGetDad5:aCOLS[ nElem, nI ] := 0
		Else
			oGetDad5:aCOLS[ nElem, nI ] := CriaVar( RTrim( oGetDad5:aHeader[ nI, 2 ] ) )
		Endif
	Next nI
	oGetDad5:aCOLS[ nElem, Len( oGetDad5:aHeader )+1 ] := .F.
	oGetDad5:Refresh()
Return


//-----------------------------------------------------------------------
// Rotina | A250Obrig  | Autor | Robson Gonçalves     | Data | 29.06.2015
//-----------------------------------------------------------------------
// Descr. | Rotina para criticar no apontamento se há campo obrigatório 
//        | não preenchido na Oportunidade.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
#DEFINE cFNT_ALERT  '<b><font size="4" color="red"><b><u>'
#DEFINE cFNT_DADOS  '<font size="4" color="blue" font face="courier new, monospace">'
#DEFINE cNOFONT     '</b></font></u></b> '
User Function A250Obrig()
	Local lRet := .T.
	Local aCpos := {}
	Local aArea := {}
	Local aNoFill := {}
	Local cField := ''
	Local nI := 0
	aArea := { AD1->( GetArea() ), SX3->( GetArea() ), SXA->( GetArea() ) }
	SX3->(DbSetOrder(1))
	SX3->(DbSeek('AD1'))
	While SX3->(!EOF()) .And. SX3->X3_ARQUIVO == 'AD1'
		If ( X3USO(SX3->X3_USADO) .AND. ;
			cNivel >= SX3->X3_NIVEL .AND. ;
			.NOT. Empty(SX3->X3_OBRIGAT) .AND. ;
			SX3->X3_CONTEXT <> 'V' .AND.;
			.NOT.AllTrim(SX3->X3_CAMPO) $ "AD1_VISTEC|AD1_CODVIS|AD1_SITVIS|AD1_FCS|AD1_FCI|AD1_XORIG|AD1_XQTDPR|AD1_XLOGQP|AD1_CODCLI|AD1_PROSPE")
			AAdd(aCpos,{RTrim(SX3->X3_CAMPO),RTrim(SX3->X3_TITULO),Iif(Empty(SX3->X3_FOLDER),'Outros',RTrim(SXA->(Posicione('SXA',1,'AD1'+SX3->X3_FOLDER,'XA_DESCRIC'))))})
		Endif
		SX3->(dbSkip())
	End
	AD1->(DbSetOrder(1))
	If AD1->(DbSeek(xFilial('AD1')+M->AD5_NROPOR))
		For nI := 1 To Len(aCpos)
			cField := 'AD1->'+aCpos[nI,1]
			If Empty(&(cField))
				AAdd(aNoFill,{aCpos[nI,1],aCpos[nI,2],aCpos[nI,3]})
			Endif
		Next nI
	Endif
	cField := ''
	For nI := 1 To Len(aNoFill)
		cField += 'campo: '+PadR(aNoFill[nI,2],12) + ' na pasta: ' + aNoFill[nI,3] + '<br>'
	Next nI
	If .NOT. Empty( cField )
		lRet := .F.
		MsgAlert(cFNT_ALERT+'ATENÇÃO'+cNOFONT+'<br><br>Não será possível efetuar o apontamento.'+;
		         '<br>A Oportunidade está com campo(s) vazio(s) e o preenchimento é obrigatório.'+;
		         '<br><br>Verifique o(s) campo(s) abaixo:'+;
		         '<br>'+cFNT_DADOS+cField+cNOFONT,;
		         'A250Obrig | Validação de apontamento')
	Endif
	AEval( aArea, {|xArea| RestArea( xArea ) } )
Return( lRet )


//-----------------------------------------------------------------------
// Rotina | A250Prod  | Autor | Rafael Beghini     | Data | 04.03.2016
//-----------------------------------------------------------------------
// Descr. | Rotina para validar se há produto e contato 
//        | cadastrado na oportunidade
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A250Prod()
	Local lRet  := .T.
	Local nItem := 0
	Local nCont := 0
	Local nValor := 0
		
	Private cCadastro 	 := "Oportunidade de Venda"
	Private aRotina 	 := {}
	Private lFt300Auto := .F.
	
	AAdd( aRotina, {'','',0,1})
	AAdd( aRotina, {'','',0,2})
	AAdd( aRotina, {'','',0,3})
	AAdd( aRotina, {'','',0,4})
	AAdd( aRotina, {'','',0,5})
	
	INCLUI := .F.
	ALTERA := .T.
	
	Sleep(50)
	AD1->( DBGOTO(RecNo()) )
	Ft300Alter('AD1',AD1->( RecNo() ),4)
	
	//Verifica produtos na Oportunidade
	ADJ->( dbSeek( xFilial('ADJ') + M->AD5_NROPOR ) )			
	While .NOT. ADJ->( EOF() ) .And. ADJ->ADJ_FILIAL == xFilial('ADJ') .And. ADJ->ADJ_NROPOR == M->AD5_NROPOR
		ADJ->ADJ_VALOR += nValor 
		nItem++
		ADJ->( dbSkip() )
	End
	
	M->AD5_VERBA := nValor
	
	If nItem == 0
		lRet := .F.
	Endif
	
	//Verifica contatos na Oportunidade
	AD9->( dbSeek( xFilial( 'AD9' ) + M->AD5_NROPOR ) )
	While .NOT. AD9->( EOF() ) .And. AD9->AD9_FILIAL == xFilial('AD9') .And. AD9->AD9_NROPOR == M->AD5_NROPOR
		nCont++
		AD9->( dbSkip() )
	End
	If nCont == 0
		lRet := .F.
	Endif
	
Return( lRet )


//-----------------------------------------------------------------------
// Rotina | A250FCSI  | Autor | Rafael Beghini     | Data | 28.03.2016
//-----------------------------------------------------------------------
// Descr. | Rotina para validar se os campos Fator Critico Sucesso 
//        | e Insucesso estão preenchidos na oportunidade
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A250FCSI()
	Local lRet  := .T.
	Local lOK   := .F.
	Local aRet  := {}
	Local aPar  := {}
	Local cAD1_FCS := ''
	Local cAD1_FCI := ''
	Local cTitulo := 'Fator crítico Sucesso/Insucesso'
	
	AD1->( dbSeek( xFilial( 'AD1' ) + M->AD5_NROPOR ) )
	cAD1_FCS := AD1->AD1_FCS
	cAD1_FCI := AD1->AD1_FCI
	
	IF Left(M->AD5_EVENTO,3) == '005' .OR. M->AD5_EVENTO == '006GAN' //Fator critico de sucesso
		IF Empty( cAD1_FCS )
			lOK := .T.
			MsgAlert('A mudança de estágio neste momento obriga o preenchimento do campo fator crítico de sucesso, por favor, informe este dado agora.','A250FCSI')
		Endif
		If lOK
			cTitCpo := 'Informe o ' + RTrim( SX3->(RetTitle( 'AD1_FCS' ) ) )
			AAdd( aPar, { 1, cTitCpo, Space(06),"@!",'ExistCpo("SX5","ZQ"+Mv_par01)',"ZQ","",0,.T.}) 
			If ParamBox( aPar, cTitulo, @aRet, , , , , , , , .F., .F. )
				cAD1_FCS := aRet[ 1 ]
				If AD1->(Found())
					AD1->( RecLock( 'AD1', .F. ) )
					AD1->AD1_FCS := cAD1_FCS
					AD1->( MsUnLock() )
				Endif
			Else
				lRet := .F.
			Endif
		Endif
	ElseIF M->AD5_EVENTO == '006PER' //Fator critico de insucesso
		IF Empty( cAD1_FCI )
			lOK := .T.
			MsgAlert('A mudança de estágio neste momento obriga o preenchimento do campo fator crítico de insucesso, por favor, informe este dado agora.','A250FCSI')
		Endif
		If lOK
			cTitCpo := 'Informe o ' + RTrim( SX3->(RetTitle( 'AD1_FCI' ) ) )
			AAdd( aPar, { 1, cTitCpo, Space(06),"@!",'ExistCpo("SX5","ZQ"+Mv_par01)',"ZQ","",0,.T.}) 
			If ParamBox( aPar, cTitulo, @aRet, , , , , , , , .F., .F. )
				cAD1_FCI := aRet[ 1 ]
				If AD1->(Found())
					AD1->( RecLock( 'AD1', .F. ) )
					AD1->AD1_FCI := cAD1_FCI
					AD1->( MsUnLock() )
				Endif
			Else
				lRet := .F.
			Endif
		Endif
	EndIF
Return( lRet )


//-----------------------------------------------------------------------
// Rotina | UpdD250    | Autor | Robson Gonçalves     | Data | 23.06.2014
//-----------------------------------------------------------------------
// Descr. | Rotina update de dicionário de dados.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function UpdD250()
	If MsgYesNo('Confirma a manutenção no dicionário de dados?','UPD250D')
		SX3->( dbSetOrder( 2 ) ) 
		If SX3->( dbSeek( 'AD1_TABELA' ) )
			If .NOT. ( 'U_A250TABELA' $ Upper( RTrim( SX3->X3_RELACAO ) ) )
				SX3->( RecLock( 'SX3', .F. ) )
				SX3->X3_RELACAO := 'U_A250Tabela()'
				SX3->( MsUnLock() )
				MsgInfo('Update executado com sucesso.')
			Else
				MsgInfo('Update já executado.')
			Endif
		Endif
	Endif
Return


//-----------------------------------------------------------------------
// Rotina | UpdC250    | Autor | Robson Gonçalves     | Data | 02.07.2014
//-----------------------------------------------------------------------
// Descr. | Rotina de carga de dados.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function UpdC250()
	If MsgYesNo('Confirma a carga de dados que será feita na tabela de preço (DA1)?','UPD250C')
		FwMsgRun(,{|| A250UpdC() },,'Aguarde a carga de dados.')
	Endif
Return


//-----------------------------------------------------------------------
// Rotina | A250UpdC   | Autor | Robson Gonçalves     | Data | 02.07.2014
//-----------------------------------------------------------------------
// Descr. | Rotina de execução da carga de dados.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A250UpdC()
	Local cSQL := ''
	If DA1->( FieldPos("DA1_DESCRI") ) > 0
		cSQL := "UPDATE "+RetSqlName("DA1")+" DA1 "
		cSQL += "SET DA1_DESCRI = NVL(( SELECT B1_DESC "
		cSQL += "                   FROM   "+RetSqlName("SB1")+" SB1 "
		cSQL += "                   WHERE  B1_FILIAL = "+ValToSql(xFilial("SB1"))+" "
		cSQL += "                          AND B1_COD = DA1_CODPRO "
		cSQL += "                          AND SB1.D_E_L_E_T_ = ' ' ),' ') "
		cSQL += "WHERE  DA1_FILIAL = "+ValToSql(xFilial("DA1"))+" "
		cSQL += "       AND DA1.D_E_L_E_T_ = ' ' "
		TcSqlExec( cSQL )
		TcSqlExec( "COMMIT" )
		MsgInfo("Update de carga de dados na tabela de preço executado com sucesso.","A250UpdC")
	Else
		MsgAlert("Não foi possível executar o update de carga de dados na tabela de preço, pois não existe o campo DA1_DESCRI.","A250UpdC")
	Endif
Return


//-----------------------------------------------------------------------
// Rotina | UpdB250    | Autor | Robson Gonçalves     | Data | 23.06.2014
//-----------------------------------------------------------------------
// Descr. | Rotina update de dicionário de dados.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function UpdB250()
	If MsgYesNo('Confirma a manutenção no dicionário de dados?','UPD250B')
		FwMsgRun(,{|| A250UpdB() },,'Aguarde a manutenção no dicionário de dados.')
	Endif
Return


//-----------------------------------------------------------------------
// Rotina | A250UpdB   | Autor | Robson Gonçalves     | Data | 23.06.2014
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar que contempla a funcionalidade UpdB250.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A250UpdB()
	Local nI := 0
	Local nJ := 0
	Local cMsg := ''
	Local cX3_WHEN := ''
	Local cXB_ALIAS := ''
	Local cX3_VLDUSER := ''
	Local aSX7 := {}
	Local aSXB := {}
	Local aCpoXB := {}
	
	SX3->( dbSetOrder( 2 ) )
	If SX3->( dbSeek( 'AD1_TABELA' ) )
		If Empty( SX3->X3_TRIGGER )
			SX3->( RecLock( 'SX3', .F. ) ) 
			SX3->X3_TRIGGER := 'S'
			SX3->( MsUnLock() )
			cMsg += 'X3_TRIGGER para o campo AD1_TABELA criado.' + CRLF
		Endif
	Else
		cMsg += 'X3_TRIGGER para o campo AD1_TABELA já existe.' + CRLF 
	Endif
	
	If SX3->( dbSeek( 'ADJ_PROD' ) )
		If .NOT. ('A250STRU' $ Upper( RTrim( SX3->X3_VLDUSER ) ) )
			cX3_VLDUSER := RTrim( SX3->X3_VLDUSER )
			SX3->( RecLock( 'SX3', .F. ) )
			SX3->X3_VLDUSER := cX3_VLDUSER + Iif( Empty( cX3_VLDUSER ), '', '.And.' ) + 'U_A250Stru()'
			SX3->( MsUnLock() )
			cMsg += 'X3_VLDUSER para o campo ADJ_PROD com a função A250Stru criado.' + CRLF 
		Else
			cMsg += 'X3_VLDUSER para o campo ADJ_PROD já existe.' + CRLF 
		Endif
	Endif
	
	If SX3->( dbSeek( 'ADJ_PRUNIT' ) )
		If .NOT. ('A250PREC' $ Upper( RTrim( SX3->X3_WHEN ) ) )
			cX3_WHEN := RTrim( SX3->X3_WHEN )
			SX3->( RecLock( 'SX3', .F. ) )
			SX3->X3_WHEN := cX3_WHEN + Iif( Empty( cX3_WHEN ), '', '.And.' ) + 'U_A250Prec()'
			SX3->( MsUnLock() )
			cMsg += 'X3_WHEN para o campo ADJ_PRUNIT com a função A250Prec criado.' + CRLF 
		Else
			cMsg += 'X3_WHEN para o campo ADJ_PRUNIT já existe.' + CRLF 
		Endif
	Endif
		
	If SX3->( dbSeek( 'ADJ_VALOR' ) )
		If .NOT. ('A250PREC' $ Upper( RTrim( SX3->X3_WHEN ) ) )
			cX3_WHEN := RTrim( SX3->X3_WHEN )
			SX3->( RecLock( 'SX3', .F. ) )
			SX3->X3_WHEN := cX3_WHEN + Iif( Empty( cX3_WHEN ), '', '.And.' ) + 'U_A250Prec()'
			SX3->( MsUnLock() )
			cMsg += 'X3_WHEN para o campo ADJ_VALOR com a função A250Prec criado.' + CRLF 
		Else
			cMsg += 'X3_WHEN para o campo ADJ_VALOR já existe.' + CRLF 
		Endif
	Endif
	
	If SX3->( dbSeek( 'DA1_DESCRI' ) )
		If SX3->X3_CONTEXT <> 'R'
			SX3->( RecLock( 'SX3', .F. ) )
			SX3->X3_CONTEXT := 'R'
			SX3->( MsUnLock() )
			cMsg += 'Alterado de V (virtual) p/ R (real) o X3_CONTEXT do campo DA1_DESCRI.' + CRLF 
		Else
			cMsg += 'Não foi preciso alterar o X3_CONTEXT do campo DA1_DESCRI.' + CRLF 
		Endif
	Endif

	AAdd( aSX7, { 'AD1_TABELA', '001', 'U_A250TrF3()', 'AD1_TABELA', 'P', 'N', 'U' } )
	AAdd( aSX7, { 'AD1_DESCRI', '001', 'U_A250TrF3()', 'AD1_DESCRI', 'P', 'N', 'U' } )

	SX7->( dbSetOrder( 1 ) )
	For nI := 1 To Len( aSX7 )
		If .NOT. SX7->( dbSeek( aSX7[ nI, 1 ] + aSX7[ nI, 2 ] ) )
			SX7->( RecLock( 'SX7', .T. ) )
			SX7->X7_CAMPO  := aSX7[ nI, 1 ]
			SX7->X7_SEQUENC:= aSX7[ nI, 2 ]
			SX7->X7_REGRA  := aSX7[ nI, 3 ]
			SX7->X7_CDOMIN := aSX7[ nI, 4 ]
			SX7->X7_TIPO   := aSX7[ nI, 5 ]
			SX7->X7_SEEK   := aSX7[ nI, 6 ]
			SX7->X7_PROPRI := aSX7[ nI, 7 ]
			SX7->( MsUnLock() )
			
			SX3->( dbSetOrder( 2 ) )
			If SX3->( dbSeek( aSX7[ nI, 1 ] ) )
				If SX3->X3_TRIGGER <> 'S'
					SX3->( RecLock( 'SX3', .F. ) )
					SX3->X3_TRIGGER := 'S'
					SX3->( MsUnLock() )
				Endif
			Endif
			cMsg += 'Gatilho para o campo ' + aSX7[ nI, 1 ] + ' sequencia ' + aSX7[ nI, 2 ] + ' criado.' + CRLF
		Else
			cMsg += 'Gatilho para o campo ' + aSX7[ nI, 1 ] + ' sequencia ' + aSX7[ nI, 2 ] + ' já existe.' + CRLF
		Endif
	Next nI
	
	SIX->( dbSetOrder( 1 ) )
	If .NOT. SIX->( dbSeek( 'DA1' + '7' ) )
		SIX->( RecLock( 'SIX', .T. ) )
		SIX->INDICE    := 'DA1'
		SIX->ORDEM     := '7'
		SIX->CHAVE     := 'DA1_FILIAL+DA1_CODTAB+DA1_DESCRI'
		SIX->DESCRICAO := 'Tabela + Descricao produto'
		SIX->DESCSPA   := 'Tabela + Descricao produto'
		SIX->DESCENG   := 'Tabela + Descricao produto'
		SIX->PROPRI    := 'U'
		SIX->NICKNAME  := 'DA1_DESCRI'
		SIX->SHOWPESQ  := 'S'
		SIX->( MsUnLock() )
		cMsg += 'Índice 7 criado para a tabela DA1.' + CRLF
	Else
		cMsg += 'Índice 7 localizado para a tabela DA1.' + CRLF
	Endif

	aCpoXB := {'XB_ALIAS','XB_TIPO','XB_SEQ','XB_COLUNA','XB_DESCRI','XB_DESCSPA','XB_DESCENG','XB_CONTEM','XB_WCONTEM'}
	
	cXB_ALIAS := '250DA1'
	
	AAdd( aSXB, { cXB_ALIAS, '1', '01', 'DB', 'Tabela de preco'     , 'Tabla del precio'   , 'Table price'       , 'DA1'       , '' } )
	AAdd( aSXB, { cXB_ALIAS, '2', '01', '01', 'Tabela + Produto'    , 'Tabela + Produto'   , 'Tabela + Produto'  , ''          , '' } )
	AAdd( aSXB, { cXB_ALIAS, '2', '02', '07', 'Tabela + Descricao'  , 'Tabela + Descricao' , 'Tabela + Descricao', ''          , '' } )
	AAdd( aSXB, { cXB_ALIAS, '4', '01', '01', 'Tabela'              , 'Tabela'             , 'Tabela'            , 'DA1_CODTAB', '' } )
	AAdd( aSXB, { cXB_ALIAS, '4', '01', '02', 'Produto'             , 'Produto'            , 'Produto'           , 'DA1_CODPRO', '' } )
	AAdd( aSXB, { cXB_ALIAS, '4', '01', '03', 'Descricao'           , 'Descricao'          , 'Descricao '        , 'DA1_DESCRI', '' } )
	AAdd( aSXB, { cXB_ALIAS, '4', '01', '04', 'Preco Venda'         , 'Preco Venta'        , 'Preco Venda'       , 'TransForm(DA1->DA1_PRCVEN,"@E 99,999,999.99")', '' } )
	AAdd( aSXB, { cXB_ALIAS, '4', '02', '01', 'Tabela'              , 'Tabela'             , 'Tabela'            , 'DA1_CODTAB', '' } )
	AAdd( aSXB, { cXB_ALIAS, '4', '02', '02', 'Descricao'           , 'Descricao'          , 'Descricao'         , 'DA1_DESCRI', '' } )
	AAdd( aSXB, { cXB_ALIAS, '4', '02', '03', 'Produto'             , 'Produto'            , 'Produto'           , 'DA1_CODPRO', '' } )
	AAdd( aSXB, { cXB_ALIAS, '4', '02', '04', 'Preco Venda'         , 'Preco Venda'        , 'Preco Venda'       , 'TransForm(DA1->DA1_PRCVEN,"@E 99,999,999.99")', '' } )
	AAdd( aSXB, { cXB_ALIAS, '5', '01', ''  , ''                    , ''                    , ''                 , 'DA1->DA1_CODPRO'          , '' } )
	AAdd( aSXB, { cXB_ALIAS, '6', '01', ''  , ''                    , ''                    , ''                 , 'DA1->DA1_CODTAB==M->AD1_TABELA.AND.DA1->DA1_ATIVO=="1"', '' } )

	SXB->( dbSetOrder( 1 ) )
	For nI := 1 To Len( aSXB )
		If .NOT. SXB->( dbSeek( aSXB[ nI, 1 ] + aSXB[ nI, 2 ] + aSXB[ nI, 3 ] + aSXB[ nI, 4 ] ) ) 
			SXB->( RecLock( 'SXB', .T. ) )
			For nJ := 1 To Len( aSXB[ nI ] )
				SXB->( FieldPut( FieldPos( aCpoXB[ nJ ] ), aSXB[ nI, nJ ] ) )
			Next nJ
			SXB->( MsUnLock() )
			If nI == 1
				cMsg += 'Consulta padrão (SXB) ' + aSXB[ nI, 1 ] + ' criado.' + CRLF
			Endif
		Else
			If nI == 1
				cMsg += 'Consulta padrão (SXB) ' + aSXB[ nI, 1 ] + ' já existe.' + CRLF
			Endif		
		Endif
	Next nI
	If Empty( cMsg )
		cMsg := 'Não consegui executar nada.'
	Endif
	MsgInfo( cMsg, 'Update de dicionário.' )
Return


//-----------------------------------------------------------------------
// Rotina | UPD250A    | Autor | Robson Gonçalves     | Data | 16.10.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function UPDA250()
	If MsgYesNo('Confirma a manutenção no dicionário de dados?','UPD250A')
		FwMsgRun(,{|| A250UpdA() },,'Aguarde a manutenção no dicionário de dados.')
	Endif
Return


//-----------------------------------------------------------------------
// Rotina | A250UpdA   | Autor | Robson Gonçalves     | Data | 16.10.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A250UpdA()
	Local nI := 0
	Local aSX3 := {}
	
	AAdd( aSX3, { 'SX3', 'AD5_NOME'  , 2, 'X3_RELACAO', 'U_A250Nome()' } )
	AAdd( aSX3, { 'SX3', 'AD5_VEND'  , 2, 'X3_RELACAO', 'Iif(INCLUI,Posicione("SA3",7,xFilial("SA3")+__cUserID,"A3_COD"),AD5->AD5_VEND)' } )
	AAdd( aSX3, { 'SX3', 'AD5_NOMVEN', 2, 'X3_RELACAO', 'Posicione("SA3",1,xFilial("SA3")+M->AD5_VEND,"A3_NOME")' } )
	AAdd( aSX3, { 'SX3', 'AD5_SEQUEN', 2, 'X3_VISUAL' , 'V' } )
	AAdd( aSX3, { 'SX3', 'AD1_DTFIM' , 2, 'X3_VISUAL' , 'V' } )
	AAdd( aSX3, { 'SX3', 'AD5_EVENTO', 2, 'X3_VLDUSER', 'U_A250HaCNPJ()' } )
	
	For nI := 1 To Len( aSX3 )
		NGAltConteu( aSX3[ nI, 1 ], aSX3[ nI, 2 ], aSX3[ nI, 3 ], aSX3[ nI, 4 ], aSX3[ nI, 5 ] )
	Next nI
		
	aSX3 := {}
	AAdd( aSX3, { 'AD5_DESCRI', '09' } )
	AAdd( aSX3, { 'AD5_EVENTO', '10' } )
	AAdd( aSX3, { 'AD5_DESEVE', '11' } )
	AAdd( aSX3, { 'AD5_PROSPE', '12' } )
	AAdd( aSX3, { 'AD5_LOJPRO', '13' } )
	AAdd( aSX3, { 'AD5_NOME'  , '14' } )
	AAdd( aSX3, { 'AD5_FEELIN', '15' } )
	AAdd( aSX3, { 'AD5_VERBA' , '16' } )
	AAdd( aSX3, { 'AD5_XCC'   , '17' } )
	AAdd( aSX3, { 'AD5_OBS'   , '18' } )
	AAdd( aSX3, { 'AD5_CODMEN', '19' } )
	AAdd( aSX3, { 'AD5_XHAPTO', '20' } )
	AAdd( aSX3, { 'AD5_IMPPRP', '21' } )
	AAdd( aSX3, { 'AD5_CONTIM', '22' } )
	AAdd( aSX3, { 'AD5_VERSAO', '23' } )
	
	For nI := 1 To Len( aSX3 )
		NGAltConteu( 'SX3', aSX3[ nI, 1 ], 2, 'X3_ORDEM', aSX3[ nI, 2 ] )
	Next nI
Return


//-----------------------------------------------------------------------
// Rotina | UPD250     | Autor | Robson Gonçalves     | Data | 16.10.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function UPD250()
	Local cModulo := 'FAT'
	Local bPrepar := {|| }
	Local nVersao := 2
	
	If nVersao == 1
		bPrepar := {|| U_U250Ini() }
	Elseif nVersao == 2
		bPrepar := {|| U_U250Ini2() }
	Endif
	
	NGCriaUpd(cModulo,bPrepar,nVersao)
Return


//-----------------------------------------------------------------------
// Rotina | U250Ini    | Autor | Robson Gonçalves     | Data | 16.10.2013
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar do update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function U250Ini()
	aSIX := {}
	aSX2 := {}
	aSX3 := {}
	aSX7 := {}
	aHelp := {}

	AAdd( aSX3    ,{	'AD1',NIL,'AD1_CNPJ','C',14,0,;                       //Alias,NIL,Campo,Tipo,Tamanho,Decimais
							'CNPJ/CPF','CNPJ/CPF','CNPJ/CPF',;                    //Tit. Port.,Tit.Esp.,Tit.Ing.
							'CNPJ/CPF',;                                          //Desc.Port.
							'CNPJ/CPF',;                                          //Desc.Esp.
							'CNPJ/CPF',;                                          //Desc.Ing.
							'@R 99.999.999/9999-99',;                             //Picture
							'',;                                                  //Valid
							X3_EMUSO_USADO,;                                      //Usado
							'',;                                                  //Relacao
							'',1,X3_USADO_RESERV,'','',;                          //F3,Nivel,Reserv,Check,Trigger
							'U','N','A','R','',;                                  //Propri,Browse,Visual,Context,Obrigat
							'CGC(M->AD1_CNPJ).And.U_A250CNPJ()',;                 //VldUser
							'',;                                                  //Box Port.
							'',;                                                  //Box Esp.
							'',;                                                  //Box Ing.
							'U_A250Picture()','','','','',;                       //PictVar,When,Ini BRW,GRP SXG,Folder
							'N','',''})                                           //Pyme,CondSQL,ChkSQL

	AAdd(aHelp,{'AD1_CNPJ','Número do CNPJ ou CPF.'})

	AAdd( aSX3    ,{	'AD1',NIL,'AD1_VALIDA','C',1,0,;                       //Alias,NIL,Campo,Tipo,Tamanho,Decimais
							'Validade','Validade','Validade',;                     //Tit. Port.,Tit.Esp.,Tit.Ing.
							'Validade da oportunidade',;                           //Desc.Port.
							'Validade da oportunidade',;                           //Desc.Esp.
							'Validade da oportunidade',;                           //Desc.Ing.
							'@!',;                                                 //Picture
							'',;                                                   //Valid
							X3_EMUSO_USADO,;                                       //Usado
							'',;                                                   //Relacao
							'',1,X3_USADO_RESERV,'','',;                           //F3,Nivel,Reserv,Check,Trigger
							'U','N','A','R','',;                                   //Propri,Browse,Visual,Context,Obrigat
							'Pertence("123")',;                                    //VldUser
							'1=30 dias;2=60 dias;3=90 dias',;                      //Box Port.
							'1=30 dias;2=60 dias;3=90 dias',;                      //Box Esp.
							'1=30 dias;2=60 dias;3=90 dias',;                      //Box Ing.
							'','','','','',;                                       //PictVar,When,Ini BRW,GRP SXG,Folder
							'N','',''})                                            //Pyme,CondSQL,ChkSQL

	AAdd(aHelp,{'AD1_VALIDA','Validade da oportunidade.'})

	AAdd( aSX3    ,{	'AD5',NIL,'AD5_FEELIN','C',1,0,;                      //Alias,NIL,Campo,Tipo,Tamanho,Decimais
							'Feeling','Feeling','Feeling',;                       //Tit. Port.,Tit.Esp.,Tit.Ing.
							'Feeling da oportunidade',;                           //Desc.Port.
							'Feeling da oportunidade',;                           //Desc.Esp.
							'Feeling da oportunidade',;                           //Desc.Ing.
							'@!',;                                                //Picture
							'',;                                                  //Valid
							X3_EMUSO_USADO,;                                      //Usado
							'',;                                                  //Relacao
							'',1,X3_USADO_RESERV,'','',;                          //F3,Nivel,Reserv,Check,Trigger
							'U','N','A','R','',;                                  //Propri,Browse,Visual,Context,Obrigat
							'Pertence("123")',;	                                 //VldUser
							'1=30%;2=60%;3=90%',;                                 //Box Port.
							'1=30%;2=60%;3=90%',;                                 //Box Esp.
							'1=30%;2=60%;3=90%',;                                 //Box Ing.
							'','','','','',;                                      //PictVar,When,Ini BRW,GRP SXG,Folder
							'N','',''})                                           //Pyme,CondSQL,ChkSQL

	AAdd(aHelp,{'AD5_FEELIN','Percentual do feeling do negócio.'})

	AAdd( aSX3    ,{	'AD5',NIL,'AD5_VERBA','N',12,2,;                      //Alias,NIL,Campo,Tipo,Tamanho,Decimais
							'Verba','Verba','Verba',;                             	//Tit. Port.,Tit.Esp.,Tit.Ing.
							'Valor da verba',;                                    //Desc.Port.
							'Valor da verba',;                                    //Desc.Esp.
							'Valor da verba',;                                    //Desc.Ing.
							'@E 999,999,999.99',;                                 //Picture
							'',;                                                  //Valid
							X3_EMUSO_USADO,;                                      //Usado
							'',;                                                  //Relacao
							'',1,X3_USADO_RESERV,'','',;                          //F3,Nivel,Reserv,Check,Trigger
							'U','N','A','R','',;                                  //Propri,Browse,Visual,Context,Obrigat
							'Positivo()',;                                        //VldUser
							'',;                                                  //Box Port.
							'',;                                                  //Box Esp.
							'',;                                                  //Box Ing.
							'','','','','',;                                      //PictVar,When,Ini BRW,GRP SXG,Folder
							'N','',''})                                           //Pyme,CondSQL,ChkSQL

	AAdd(aHelp,{'AD5_VERBA','Verba que o prospect destinou ao seu projeto ou o valor total da oportunidade de negócio.'})

	AAdd( aSX3    ,{	'AD5',NIL,'AD5_DESCRI','C',30,0,;                     //Alias,NIL,Campo,Tipo,Tamanho,Decimais
							'Descricao','Descricao','Descricao',;                 //Tit. Port.,Tit.Esp.,Tit.Ing.
							'Descricao da oportunidade',;                         //Desc.Port.
							'Descricao da oportunidade',;                         //Desc.Esp.
							'Descricao da oportunidade',;                         //Desc.Ing.
							'@!',;                                                //Picture
							'',;                                                  //Valid
							X3_EMUSO_USADO,;                                      //Usado
							'IIF(INCLUI,Space(Len(AD1->AD1_DESCRI)),Posicione("AD1",1,xFilial("AD1")+AD5->AD5_NROPOR,"AD1_DESCRI"))',;//Relacao
							'',1,X3_USADO_RESERV,'','',;                          //F3,Nivel,Reserv,Check,Trigger
							'U','N','V','V','',;                                  //Propri,Browse,Visual,Context,Obrigat
							'',;                                                  //VldUser
							'',;                                                  //Box Port.
							'',;                                                  //Box Esp.
							'',;                                                  //Box Ing.
							'','','','','',;                                      //PictVar,When,Ini BRW,GRP SXG,Folder
							'N','',''})                                           //Pyme,CondSQL,ChkSQL

	AAdd(aHelp,{'AD5_DESCRI','Descrição da oportunidade de negócio.'})

	AAdd( aSX3    ,{	'AD5',NIL,'AD5_NOME','C',30,0,;                       //Alias,NIL,Campo,Tipo,Tamanho,Decimais
							'Nome','Nome','Nome',;                                //Tit. Port.,Tit.Esp.,Tit.Ing.
							'Nome cliente/prospects',;                            //Desc.Port.
							'Nome cliente/prospects',;                            //Desc.Esp.
							'Nome cliente/prospects',;                            //Desc.Ing.
							'@!',;                                                //Picture
							'',;                                                  //Valid
							X3_EMUSO_USADO,;                                      //Usado
							'U_250Nome()',;                                       //Relacao
							'',1,X3_USADO_RESERV,'','',;                          //F3,Nivel,Reserv,Check,Trigger
							'U','N','V','V','',;                                  //Propri,Browse,Visual,Context,Obrigat
							'',;                                                  //VldUser
							'',;                                                  //Box Port.
							'',;                                                  //Box Esp.
							'',;                                                  //Box Ing.
							'','','','','',;                                      //PictVar,When,Ini BRW,GRP SXG,Folder
							'N','',''})                                           //Pyme,CondSQL,ChkSQL

	AAdd(aHelp,{'AD5_NOME','Nome do cliente ou prospect.'})
		
	AAdd( aSX3    ,{	'SBH',NIL,'BH_INDEPEN','C',1,0,;                      //Alias,NIL,Campo,Tipo,Tamanho,Decimais
							'Independente','Independente','Independente',;        //Tit. Port.,Tit.Esp.,Tit.Ing.
							'Independente da estrutura',;                         //Desc.Port.
							'Independente da estrutura',;                         //Desc.Esp.
							'Independente da estrutura',;                         //Desc.Ing.
							'@!',;                                                //Picture
							'',;                                                  //Valid
							X3_EMUSO_USADO,;                                      //Usado
							'"N"',;                                               //Relacao
							'',1,X3_USADO_RESERV,'','',;                          //F3,Nivel,Reserv,Check,Trigger
							'U','N','A','R','',;                                  //Propri,Browse,Visual,Context,Obrigat
							'',;                                                  //VldUser
							'N=Nao;S=Sim',;                                       //Box Port.
							'N=No;S=Si',;                                         //Box Esp.
							'N=No;S=Yes',;                                        //Box Ing.
							'','','','','',;                                      //PictVar,When,Ini BRW,GRP SXG,Folder
							'N','',''})                                           //Pyme,CondSQL,ChkSQL

	AAdd(aHelp,{'BH_INDEPEN','Produto pode ser oferecido independente da estrutura completa.'})

	AAdd(aSX7,{'AD5_NROPOR','001','AD1->AD1_VERBA'          ,'AD5_VERBA' ,'P','S','AD1',1,'xFilial("AD1")+M->AD5_NROPOR', '', 'U', } )
	AAdd(aSX7,{'AD5_NROPOR','002','U_A250GAT("AD5_SEQUENC")','AD5_SEQUEN','P','N',''   ,0,''                            , '', 'U', } )	
	AAdd(aSX7,{'AD5_NROPOR','003','AD1->AD1_DESCRI'         ,'AD5_DESCRI','P','S','AD1',1,'xFilial("AD1")+M->AD5_NROPOR', '', 'U', } )	
	AAdd(aSX7,{'AD5_NROPOR','004','U_A250GAT("AD5_NROPOR")' ,'AD5_EVENTO','P','N',''   ,0,''                            , '', 'U', } )	
	AAdd(aSX7,{'AD5_NROPOR','005','AD1->AD1_FEELIN'         ,'AD5_FEELIN','P','S','AD1',1,'xFilial("AD1")+M->AD5_NROPOR', '', 'U', } )
Return


//-----------------------------------------------------------------------
// Rotina | UPD250a    | Autor | Robson Gonçalves     | Data | 06.05.2014
//-----------------------------------------------------------------------
// Descr. | Rotina de update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function UPD250a()
	Local cModulo := 'FAT'
	Local bPrepar := {|| U_U250IniA() }
	Local nVersao := 02
	
	NGCriaUpd(cModulo,bPrepar,nVersao)
Return


//-----------------------------------------------------------------------
// Rotina | U250IniA   | Autor | Robson Gonçalves     | Data | 06.05.2014
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar do update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function U250IniA()
	aSX3 := {}
	aHelp := {}
	
	AAdd( aSX3    ,{	'AC5',NIL,'AC5_PROCES','C',6,0,;                     //Alias,NIL,Campo,Tipo,Tamanho,Decimais
							'Processo CRM','Processo CRM','Processo CRM',;       //Tit. Port.,Tit.Esp.,Tit.Ing.
							'Processo do CRM Vendas',;                           //Desc.Port.
							'Processo do CRM Vendas',;                           //Desc.Esp.
							'Processo do CRM Vendas',;                           //Desc.Ing.
							'@!',;                                               //Picture
							'',;                                                 //Valid
							'€€€€€€€€€€€€€€ ',;                                  //Usado
							'',;                                                 //Relacao
							'AC1',1,'þA','','',;                                 //F3,Nivel,Reserv,Check,Trigger
							'U','S','A','R','',;                                 //Propri,Browse,Visual,Context,Obrigat
							'ExistCpo("AC1")',;                                  //VldUser
							'',;                                                 //Box Port.
							'',;                                                 //Box Esp.
							'',;                                                 //Box Ing.
							'','','','','',;                                     //PictVar,When,Ini BRW,GRP SXG,Folder
							'N','',''})                                          //Pyme,CondSQL,ChkSQL

	AAdd(aHelp,{'AC5_PROCES','Código do processo CRM Vendas.'})
Return


//-----------------------------------------------------------------------
// Rotina | A250UpdCpo | Autor | Robson Gonçalves     | Data | 06.05.2014
//-----------------------------------------------------------------------
// Descr. | Rotina para atualizar o dicionário de dados.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A250UpdCpo()
	Local cX3_VLDUSER := ''
	Local cOperador := ' .And. '
	Local cMsg := ''
	If MsgYesNo('Confirma a manutenção no dicionário de dados?','CSFA250 | A250UpdCpo')
		SX3->( dbSetOrder( 2 ) )
		If SX3->( dbSeek( 'AD1_DESCRI' ) )
			If .NOT. ('CSFA250' $ Upper( RTrim( SX3->X3_VLDUSER ) ) )
				cX3_VLDUSER := RTrim( SX3->X3_VLDUSER )
				SX3->( RecLock( 'SX3', .F. ) )
				SX3->X3_VLDUSER := cX3_VLDUSER + Iif( Empty( cX3_VLDUSER ), '', cOperador ) + 'U_CSFA250()'
				SX3->( MsUnLock() )
				cMsg += 'Validador de usuário U_CSFA250 para o campo AD1_DESCRI inserido com sucesso.' + CRLF
			Else
				cMsg += 'Validador de usuário U_CSFA250 para o campo AD1_DESCRI já aplicado.'  + CRLF
			Endif
		Endif
		If SX3->( dbSeek( 'AD5_NROPOR' ) )
			If .NOT. ('A250NROP' $ Upper( RTrim( SX3->X3_VLDUSER ) ) )
				cX3_VLDUSER := RTrim( SX3->X3_VLDUSER )
				SX3->( RecLock( 'SX3', .F. ) )
				SX3->X3_VLDUSER := cX3_VLDUSER + Iif( Empty( cX3_VLDUSER ), '', cOperador ) + 'U_A250NrOp()'
				SX3->( MsUnLock() )
				cMsg += 'Validador de usuário U_A250NrOp para o campo AD5_NROPOR inserido com sucesso.'  + CRLF
			Else
				cMsg += 'Validador de usuário U_A250NrOp para o campo AD5_NROPOR já aplicado.'  + CRLF
			Endif
		Endif
		If SX3->( dbSeek( 'AD5_EVENTO' ) )
			If .NOT. ('A250KEY' $ Upper( RTrim( SX3->X3_VLDUSER ) ) )
				cX3_VLDUSER := RTrim( SX3->X3_VLDUSER )
				SX3->( RecLock( 'SX3', .F. ) )
				SX3->X3_VLDUSER := cX3_VLDUSER + Iif( Empty( cX3_VLDUSER ), '', cOperador ) + 'U_A250Key()'
				SX3->( MsUnLock() )
				cMsg += 'Validador de usuário U_A250Key para o campo AD5_EVENTO inserido com sucesso.'  + CRLF
			Else
				cMsg += 'Validador de usuário U_A250Key para o campo AD5_EVENTO já aplicado.'  + CRLF
			Endif
		Endif
		If SX3->( dbSeek( 'ADJ_QUANT' ) )
			If SX3->X3_TRIGGER <> 'S'
				SX3->( RecLock( 'SX3', .F. ) )
				SX3->X3_TRIGGER := 'S'
				SX3->( MsUnLock() )
				cMsg += 'Trigger no SX3 para o ADJ_QUANT criado.'  + CRLF
			Else
				cMsg += 'Trigger no SX3 para o ADJ_QUANT já aplicado.'  + CRLF
			Endif
			SX7->( dbSetOrder( 1 ) )
			If .NOT. SX7->( dbSeek( 'ADJ_QUANT ' + '001' ) )
				SX7->( RecLock( 'SX7', .T. ) )
				SX7->X7_CAMPO   :='ADJ_QUANT'
				SX7->X7_SEQUENC :='001'
				SX7->X7_REGRA   := 'U_A250SumVlr()'
				SX7->X7_CDOMIN  := 'ADJ_QUANT'
				SX7->X7_TIPO    := 'P'
				SX7->X7_SEEK    := 'N'
				SX7->X7_PROPRI  := 'U'
				SX7->( MsUnLock() )
				cMsg += 'Gatilho do ADJ_QUANT-001 criado'  + CRLF
			Else
				cMsg += 'Gatilho do ADJ_QUANT-001 já aplicado.'  + CRLF
			Endif
		Endif
		SXB->( dbSetOrder( 1 ) )
		If .NOT. SXB->( dbSeek( PadR('AC5',Len(SXB->XB_ALIAS)," ") + "6" + "01" + "  " ) )
			SXB->( RecLock( 'SXB', .T. ) )
			SXB->XB_ALIAS   := 'AC5'
			SXB->XB_TIPO    := '6'
			SXB->XB_SEQ     := '01'
			SXB->XB_CONTEM  := '@#U_A250FAC5()'
			SXB->( MsUnLock() )
			cMsg += 'Filtro para o SXB alias AC5 criado com sucesso.' + CRLF
		Else
			cMsg += 'Filtro para o SXB alias AC5 já aplicado.' + CRLF
		Endif
		MsgAlert( cMsg, 'CSFA250 | A250UpdCpo' )
	Endif	
Return


User Function A250Clear()
	If MsgYesNo("Deletar os registros da tabela AC5, ACZ e ZCE?")
		If MsgYesNo("Tem certeza? Vou apagar mesmo...")
			A250Apagar()
		Endif
	Endif
Return


Static Function A250Apagar()
	Local cAC5_FILIAL := xFilial( 'AC5' )
	Local cACZ_FILIAL := xFilial( 'ACZ' )
	Local cZCE_FILIAL := xFilial( 'ZCE' )
	
	AC5->( dbSetOrder( 1 ) )
	AC5->( dbGoTop() )
	While .T.
		If AC5->( dbSeek( cAC5_FILIAL ) )
			AC5->( RecLock( 'AC5', .F. ) )
			AC5->AC5_FILIAL := 'XX'
			AC5->( MsUnLock() )
			AC5->( RecLock( 'AC5', .F. ) )
			AC5->( dbDelete() )
			AC5->( MsUnLock() )
		Else
			Exit
		Endif
	End
	
	ACZ->( dbSetOrder( 1 ) )
	ACZ->( dbGoTop() )
	While .T.
		If ACZ->( dbSeek( cACZ_FILIAL ) )
			ACZ->( RecLock( 'ACZ', .F. ) )
			ACZ->ACZ_FILIAL := 'XX'
			ACZ->( MsUnLock() )
			ACZ->( RecLock( 'ACZ', .F. ) )
			ACZ->( dbDelete() )
			ACZ->( MsUnLock() )
		Else
			Exit
		Endif
	End

	ZCE->( dbSetOrder( 1 ) )
	ZCE->( dbGoTop() )
	While .T.
		If ZCE->( dbSeek( cZCE_FILIAL ) )
			ZCE->( RecLock( 'ZCE', .F. ) )
			ZCE->ZCE_FILIAL := 'XX'
			ZCE->( MsUnLock() )
			ZCE->( RecLock( 'ZCE', .F. ) )
			ZCE->( dbDelete() )
			ZCE->( MsUnLock() )
		Else
			Exit
		Endif
	End
	MsgAlert("Ufa!!! Terminei, apaguei tudo, pode fazer append em AC5, ACZ, ZCE")
Return


//-----------------------------------------------------------------------
// Rotina | U250Ini2   | Autor | Rafael Beghini     | Data | 19.07.2016
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar do update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function U250Ini2()
	aSIX := {}
	aSX2 := {}
	aSX3 := {}
	aSX7 := {}
	aHelp := {}

	AAdd( aSX3    ,{	'AD1',NIL,'AD1_CAMPAN','C',06,0,;                         //Alias,NIL,Campo,Tipo,Tamanho,Decimais
							'Cod.Campanha','Cod.Campanha','Cod.Campanha',;        //Tit. Port.,Tit.Esp.,Tit.Ing.
							'Codigo da Campanha',;                                //Desc.Port.
							'Codigo da Campanha',;                                //Desc.Esp.
							'Codigo da Campanha',;                                //Desc.Ing.
							'@!',;                                                //Picture
							'',;                                                  //Valid
							X3_EMUSO_USADO,;                                      //Usado
							'',;                                                  //Relacao
							'SUH',1,X3_USADO_RESERV,'','S',;                       //F3,Nivel,Reserv,Check,Trigger
							'U','N','A','R','',;                                  //Propri,Browse,Visual,Context,Obrigat
							'ExistCpo("SUH")',;                                   //VldUser
							'',;                                                  //Box Port.
							'',;                                                  //Box Esp.
							'',;                                                  //Box Ing.
							'','','','','1',;                                     //PictVar,When,Ini BRW,GRP SXG,Folder
							'N','',''})                                           //Pyme,CondSQL,ChkSQL

	AAdd(aHelp,{'AD1_CAMPAN','Selecione o código da campanha.'})

	
	AAdd( aSX3    ,{	'AD1',NIL,'AD1_DCAMPA','C',40,0,;                         //Alias,NIL,Campo,Tipo,Tamanho,Decimais
							'Descricao','Descricao','Descricao',;                 //Tit. Port.,Tit.Esp.,Tit.Ing.
							'Descricao da campanha',;                             //Desc.Port.
							'Descricao da campanha',;                             //Desc.Esp.
							'Descricao da campanha',;                             //Desc.Ing.
							'@!',;                                                //Picture
							'',;                                                  //Valid
							X3_EMUSO_USADO,;                                      //Usado
							'IIF(INCLUI,"",Posicione("SUH",1,xFilial("SUH")+AD1->AD1_CAMPAN,"UH_DESC"))',;//Relacao
							'',1,X3_USADO_RESERV,'','',;                          //F3,Nivel,Reserv,Check,Trigger
							'U','N','V','V','',;                                  //Propri,Browse,Visual,Context,Obrigat
							'',;                                                  //VldUser
							'',;                                                  //Box Port.
							'',;                                                  //Box Esp.
							'',;                                                  //Box Ing.
							'','','','','1',;                                     //PictVar,When,Ini BRW,GRP SXG,Folder
							'N','',''})                                           //Pyme,CondSQL,ChkSQL

	AAdd(aHelp,{'AD1_DCAMPA','Descrição da campanha.'})
	
	AAdd( aSX3    ,{	'AD1',NIL,'AD1_CODVIS','C',06,0,;                         //Alias,NIL,Campo,Tipo,Tamanho,Decimais
							'Vistoria Tec','Vistoria Tec','Vistoria Tec',;        //Tit. Port.,Tit.Esp.,Tit.Ing.
							'Codigo da Vist. Tecnica',;                           //Desc.Port.
							'Codigo da Vist. Tecnica',;                           //Desc.Esp.
							'Codigo da Vist. Tecnica',;                           //Desc.Ing.
							'@!',;                                                //Picture
							'',;                                                  //Valid
							X3_EMUSO_USADO,;                                      //Usado
							'',;                                                  //Relacao
							'',1,X3_USADO_RESERV,'','',;                          //F3,Nivel,Reserv,Check,Trigger
							'U','N','V','R','',;                                  //Propri,Browse,Visual,Context,Obrigat
							'',;                                                  //VldUser
							'',;                                                  //Box Port.
							'',;                                                  //Box Esp.
							'',;                                                  //Box Ing.
							'','','','','',;                                      //PictVar,When,Ini BRW,GRP SXG,Folder
							'N','',''})                                           //Pyme,CondSQL,ChkSQL

	AAdd(aHelp,{'AD1_CODVIS','Codigo da Vist. Tecnica'})

	AAdd(aSX7,{'AD1_CAMPAN','001','SUH->UH_DESC'          ,'AD1_DCAMPA' ,'P','S','SUH',1,'xFilial("SUH")+M->AD1_CAMPAN', '', 'U', } )
Return

//-----------------------------------------------------------------------
// Rotina | A250Vend   | Autor | Rafael Beghini     | Data | 13.04.2018
//-----------------------------------------------------------------------
// Descr. | Gatilho - AD2_VEND := AD1_VEND (Time de Vendas)
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A250Vend()
	Local oModel	:= FwModelActive()
	Local oMdlAD1	:= oModel:GetModel("AD1MASTER")
	Local oMdlAD2	:= oModel:GetModel("AD2DETAIL")
	Local cAD1Fil	:= xFilial("AD1")
	Local cNROPOR	:= oMdlAD1:GetValue("AD1_NROPOR")
	Local cREVISA	:= oMdlAD1:GetValue("AD1_REVISA")
	Local cVEND		:= oMdlAD1:GetValue("AD1_VEND")
	Local nL		:= 1
	
	IF INCLUI
		oMdlAD2:SetValue("AD2_FILIAL", cAD1Fil	)
		oMdlAD2:SetValue("AD2_NROPOR", cNROPOR	)
		oMdlAD2:SetValue("AD2_REVISA", cREVISA	)
		oMdlAD2:SetValue("AD2_VEND  ", cVEND	)
		oMdlAD2:SetValue("AD2_PERC  ", 100		)
	Else
		oMdlAD2:GoLine(nL)
		While oMdlAD2:IsDeleted()
			nL := nL + 1
			oMdlAD2:GoLine(nL)
		End
		oMdlAD2:SetValue("AD2_VEND  ", cVEND )
	EndIF
	
Return