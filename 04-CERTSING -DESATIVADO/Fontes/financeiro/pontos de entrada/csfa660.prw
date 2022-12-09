#Include 'Protheus.ch'

//--------------------------------------------------------------------------------
// Rotina | CSFAA660    | Autor | Robson Gonçalves             | Data | 01.07.2016
//--------------------------------------------------------------------------------
// Descr. | Rotina de importação das ocorrências SISPAG.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
User Function CSFA660()
	If MsgYesNo('Executar a rotina de importação de ocorrências SISPAG?')
		A660Param()
	Endif
Return

//--------------------------------------------------------------------------------
// Rotina | A660Param   | Autor | Robson Gonçalves             | Data | 01.07.2016
//--------------------------------------------------------------------------------
// Descr. | Rotina para solicitar os parâmetros de processamento.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
Static Function A660Param()
	Local aPar := {}
	Local aRet := {}
	Local aTipo := StrToKarr( Posicione( 'SX3', 2, 'EB_TIPO', 'X3CBox()' ), ';' )
	
	Local cTipArq := ''
	
	cTipoArq := 'TXT (formato texto) (*.txt) |*.txt"
	
	AAdd( aPar, { 6, 'Arquivo de dados', Space(99), '', '', '', 80, .T., cTipoArq, 'SERVIDOR\system\' } )
	AAdd( aPar, { 1, 'Código banco',Space(3),"","","SA6","",0,.F. } )
	AAdd( aPar, { 2, 'Tipo',1,aTipo,80,"",.F.})	
	
	If ParamBox(aPar,'Indicar o arquivo de dados',@aRet,,,,,,,,.F.,.F.)
		If File( RTrim( aRet[ 1 ] ) )
			Begin Transaction 
			Processa( {|| A660ProcFile( aRet, aTipo )},'Processamento','Aguarde...',.F.)
			End Transaction
		Else
			MsgAlert('Não localizei o arquivo: '+RTrim(aRet[1]))
		Endif
	Endif
Return

//--------------------------------------------------------------------------------
// Rotina | A660ProcFile | Autor | Robson Gonçalves            | Data | 01.07.2016
//--------------------------------------------------------------------------------
// Descr. | Rotina de processamento dos dados.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
Static Function A660ProcFile( aRet, aTipo )
	Local cFile := RTrim(aRet[1])
	Local cLine := ''
	Private cEB_FILIAL := xFilial( 'SEB' )
	Private cEB_BANCO  := aRet[2]
	Private cEB_REFBAN := ''
	Private cEB_TIPO   := ''
	Private cEB_DESCRI := ''
	
	ProcRegua(0)
	
	If ValType( aRet[ 3 ] ) == 'C'
		cEB_TIPO := SubStr( aRet[ 3 ], 1, 1 )
	Else 
		cEB_TIPO := SubStr( aTipo[ aRet[ 3 ] ], 1, 1 )
	Endif
	
	FT_FUSE( cFile )
	FT_FGOTOP()
	While .NOT. FT_FEOF()
		IncProc()
		cLine := FT_FREADLN()
		cEB_REFBAN := SubStr( cLine, 1, 2 )
		cEB_DESCRI := SubStr( cLine, 4 )
		A660Grava()
		FT_FSKIP()
	End
	FT_FUSE()	
Return

//--------------------------------------------------------------------------------
// Rotina | A660Grava | Autor | Robson Gonçalves               | Data | 01.07.2016
//--------------------------------------------------------------------------------
// Descr. | Rotina de gravação dos dados.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
Static Function A660Grava()
	SEB->( dbSetOrder( 1 ) )
	SEB->( RecLock( 'SEB', .T. ) )
	SEB->EB_FILIAL := cEB_FILIAL
	SEB->EB_BANCO  := cEB_BANCO
	SEB->EB_REFBAN := cEB_REFBAN
	SEB->EB_TIPO   := cEB_TIPO
	SEB->EB_OCORR  := cEB_REFBAN
	SEB->EB_DESCRI := cEB_DESCRI
	SEB->( MsUnLock() )
Return

//--------------------------------------------------------------------------------
// Rotina | A660VlDt | Autor | Robson Gonçalves                | Data | 01.07.2016
//--------------------------------------------------------------------------------
// Descr. | Rotina para criticar o mês e ano digitado.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
User Function A660VlDt()
	Local cVar	:= &(ReadVar())
	Local nMes	:= 0
	Local nAno	:= 0

	nMes := Val( SubStr( cVar, 1, 2 ) )
	nAno := Val( SubStr( cVar, 3, 4 ) )
	
	If nMes < 1 .Or. nMes > 12
		MsgAlert('Mês inválido, informe nos dois primeiro dígitos 01 (janeiro) até 12 (dezembro).','Validação do período')
		Return .F.
	Endif

	If nAno == 0 .Or. nAno < 2000
		MsgAlert('O ano informao não pode ser zero e deve ser maior que 2000.','Validação do período')
		Return .F.
	Endif
Return .T.

//--------------------------------------------------------------------------------
// Rotina | A660VlTr | Autor | Robson Gonçalves                | Data | 01.07.2016
//--------------------------------------------------------------------------------
// Descr. | Rotina para validar os dados relativos a tributos.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
User Function A660VlTr()
	Local cTitulo := 'Válidação de preenchimento'
	If .NOT. Empty( M->E2_XGPS01 )
		If Empty( M->E2_XGPS02 ) .OR. Empty( M->E2_XGPS03 ) .OR. Empty( M->E2_XGPS04 )
			MsgAlert('Todos os campos para o tributo GPS devem estar preenchidos.',cTitulo)
			Return .F. 
		Endif
	Endif
	If .NOT. Empty( M->E2_XDARF01 )
		If Empty( M->E2_XDARF02 ) .OR. Empty( M->E2_XDARF03 ) .OR. Empty( M->E2_XDARF04 )
			MsgAlert('Todos os campos para o tributo DARF devem estar preenchidos.',cTitulo)
			Return .F. 
		Endif
	Endif
	If .NOT. Empty( M->E2_XGARE01 )
		If Empty( M->E2_XGARE02 ) .OR. Empty( M->E2_XGARE03 )
			MsgAlert('Todos os campos para o tributo GARE devem estar preenchidos.',cTitulo)
			Return .F. 
		Endif
	Endif
	If .NOT. Empty( M->E2_XIPVA01 )
		If Empty( M->E2_XIPVA02 ) .OR. Empty( M->E2_XIPVA03 ) .OR. Empty( M->E2_XIPVA04 ) .OR. Empty( M->E2_XIPVA05 ) .OR. Empty( M->E2_XIPVA06 )
			MsgAlert('Todos os campos para o tributo IPVA/DPVAT devem estar preenchidos.',cTitulo)
			Return .F. 
		Endif
	Endif
	If .NOT. Empty( M->E2_XFGTS01 )
		If Empty( M->E2_XFGTS02 ) .OR. Empty( M->E2_XFGTS03 ) .OR. Empty( M->E2_XFGTS04 ) .OR. Empty( M->E2_XFGTS05 ) .OR. Empty( M->E2_XFGTS06 )
			MsgAlert('Todos os campos para o tributo FGTS devem estar preenchidos.',cTitulo)
			Return .F. 
		Endif
	Endif
Return .T.

//---------------------------------------------------------------------------------
// Rotina | UPD660     | Autor | Robson Gonçalves               | Data | 23.07/2015
//---------------------------------------------------------------------------------
// Descr. | Rotina de update p/ criar as estruturas no dicionário dados.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function UPD660()
	Local cModulo := 'FIN'
	Local bPrepar := {|| U_U660Ini() }
	Local nVersao := 1
	
	NGCriaUpd(cModulo,bPrepar,nVersao)
Return
//---------------------------------------------------------------------------------
// Rotina | U660Ini    | Autor | Robson Luiz - Rleg             | Data | 23/07/2015
//---------------------------------------------------------------------------------
// Descr. | Estrutura de dados para criar o dicionário de dados.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function U660Ini()
	aSXA := {}
	aSIX := {}
	aSX3 := {}
	aSXB := {}
	aHelp := {}
	
	AAdd( aSX3, { 'SE2',NIL,'E2_XGPS01' ,'C', 2,0,'Ident.GPS','Ident.GPS','Ident.GPS','Identificador do GPS','Identificador do GPS','Identificador do GPS','99','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','Vazio().OR.Pertence("01")','01=GPS','01=GPS','01=GPS','','','','','2','','','','','N','N','','' } )
	AAdd( aSX3, { 'SE2',NIL,'E2_XGPS02' ,'C', 4,0,'Codigo Pagto','Codigo Pagto','Codigo Pagto','Codigo do pagamento','Codigo do pagamento','Codigo do pagamento','9999','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','','','','','','','','','2','','','','','N','N','','' } )
	AAdd( aSX3, { 'SE2',NIL,'E2_XGPS03' ,'C', 6,0,'Mes/Ano Comp','Mes/Ano Comp','Mes/Ano Comp','Mes/Ano Competencia','Mes/Ano Competencia','Mes/Ano Competencia','@R 99/9999','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','U_A660VlDt()','','','','','','','','2','','','','','N','N','','' } )
	AAdd( aSX3, { 'SE2',NIL,'E2_XGPS04' ,'C',14,0,'Identificad.','Identificad.','Identificad.','Identificador do contrib.','Identificador do contrib.','Identificador do contrib.','99999999999999','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','Vazio() .OR. CGC(M->E2_XGPS04)','','','','','','','','2','','','','','N','N','','' } )
	AAdd( aSX3, { 'SE2',NIL,'E2_XGPS05' ,'N',12,2,'Vl.Base INSS','Vl.Base INSS','Vl.Base INSS','Valor base de INSS','Valor base de INSS','Valor base de INSS','@E 999,999,999.99','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','','','','','','','','','2','','','','','N','N','','' } )
	AAdd( aSX3, { 'SE2',NIL,'E2_XGPS06' ,'N',12,2,'Vlr.Outr.Ent','Vlr.Outr.Ent','Vlr.Outr.Ent','Valor outras entidades','Valor outras entidades','Valor outras entidades','@E 999,999,999.99','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','','','','','','','','','2','','','','','N','N','','' } )
	
	AAdd( aSX3, { 'SE2',NIL,'E2_XDARF01','C', 2,0,'Ident.DARF','Ident.DARF','Ident.DARF','Identificador DARF','Identificador DARF','Identificador DARF','99','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','Vazio().OR.Pertence("02")','02=DARF','02=DARF','02=DARF','','','','','3','','','','','N','N','','' } )
	AAdd( aSX3, { 'SE2',NIL,'E2_XDARF02','C', 4,0,'Cod. Receita','Cod. Receita','Cod. Receita','Codigo da receita','Codigo da receita','Codigo da receita','9999','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','','','','','','','','','3','','','','','N','N','','' } )
	AAdd( aSX3, { 'SE2',NIL,'E2_XDARF03','D', 8,0,'Per.Apuracao','Per.Apuracao','Per.Apuracao','Periodo de apuracao','Periodo de apuracao','Periodo de apuracao','@R 99/99/9999','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','','','','','','','','','3','','','','','N','N','','' } )
	AAdd( aSX3, { 'SE2',NIL,'E2_XDARF04','C',17,0,'Referencia','Referencia','Referencia','Numero de referencia','Numero de referencia','Numero de referencia','','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','','','','','','','','','3','','','','','N','N','','' } )
	
	AAdd( aSX3, { 'SE2',NIL,'E2_XGARE01','C', 2,0,'Ident.GARE','Ident.GARE','Ident.GARE','Identificador GARE','Identificador GARE','Identificador GARE','99','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','Vazio().OR.Pertence("05")','05=GARE','05=GARE','05=GARE','','','','','4','','','','','N','N','','' } )
	AAdd( aSX3, { 'SE2',NIL,'E2_XGARE02','C', 4,0,'Cod. Receita','Cod. Receita','Cod. Receita','Codigo da receita','Codigo da receita','Codigo da receita','9999','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','','','','','','','','','4','','','','','N','N','','' } )
	AAdd( aSX3, { 'SE2',NIL,'E2_XGARE03','C', 6,0,'Mes/Ano Ref.','Mes/Ano Ref.','Mes/Ano Ref.','Mes/Ano Referencia','Mes/Ano Referencia','Mes/Ano Referencia','@R 99/9999','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','U_A660VlDt()','','','','','','','','4','','','','','N','N','','' } )
	
	AAdd( aSX3, { 'SE2',NIL,'E2_XIPVA01','C', 2,0,'Id.IPVA/DPVA','Id.IPVA/DPVA','Id.IPVA/DPVA','Identificador IPVA/DPVAT','Identificador IPVA/DPVAT','Identificador IPVA/DPVAT','99','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','Vazio().OR.Pertence("0708")','07=IPVA;08=DPVAT','07=IPVA;08=DPVAT','07=IPVA;08=DPVAT','','','','','5','','','','','N','N','','' } )
	AAdd( aSX3, { 'SE2',NIL,'E2_XIPVA02','C', 9,0,'Renavam','Renavam','Renavam','Codigo do Renavam','Codigo do Renavam','Codigo do Renavam','999999999','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','','','','','','','','','5','','','','','N','N','','' } )
	AAdd( aSX3, { 'SE2',NIL,'E2_XIPVA03','C', 2,0,'UF Renavam','UF Renavam','UF Renavam','UF do Renavam','UF do Renavam','UF do Renavam','@!','','€€€€€€€€€€€€€€ ','','12',0,'þÀ','','','U','N','A','R','','','','','','','','','','5','','','','','N','N','','' } )
	AAdd( aSX3, { 'SE2',NIL,'E2_XIPVA04','C', 5,0,'Cod.Municip.','Cod.Municip.','Cod.Municip.','Codigo do Municipio','Codigo do Municipio','Codigo do Municipio','@!','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','','','','','','','','','5','','','','','N','N','','' } )
	AAdd( aSX3, { 'SE2',NIL,'E2_XIPVA05','C', 7,0,'Placa Veicul','Placa Veicul','Placa Veicul','Placa do veiculo','Placa do veiculo','Placa do veiculo','@R XXX-9999','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','','','','','','','','','5','','','','','N','N','','' } )
	AAdd( aSX3, { 'SE2',NIL,'E2_XIPVA06','C', 1,0,'Opcao Pagto.','Opcao Pagto.','Opcao Pagto.','Opcao de pagamento','Opcao de pagamento','Opcao de pagamento','9','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','Pertence("012345678")','0=DPVAT;1=Parc. Unica Com Desc.;2=Parc. Unica Sem Desc.;3=Parcela 1;4=Parcela 2;5=Parcela 3;6=Parcela 4;7=Parcela 5;8=Parcela 6','0=DPVAT;1=Parc. Unica Com Desc.;2=Parc. Unica Sem Desc.;3=Parcela 1;4=Parcela 2;5=Parcela 3;6=Parcela 4;7=Parcela 5;8=Parcela 6','0=DPVAT;1=Parc. Unica Com Desc.;2=Parc. Unica Sem Desc.;3=Parcela 1;4=Parcela 2;5=Parcela 3;6=Parcela 4;7=Parcela 5;8=Parcela 6','','','','','5','','','','','N','N','','' } )
	
	AAdd( aSX3, { 'SE2',NIL,'E2_XFGTS01','C', 2,0,'Ident.FGTS','Ident.FGTS','Ident.FGTS','Identificador do FGTS','Identificador do FGTS','Identificador do FGTS','99','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','Vazio().OR.Pertence("11")','11=FGTS','11=FGTS','11=FGTS','','','','','6','','','','','N','N','','' } )
	AAdd( aSX3, { 'SE2',NIL,'E2_XFGTS02','C', 4,0,'Cod.Receita','Cod.Receita','Cod.Receita','Codigo da Receita','Codigo da Receita','Codigo da Receita','9999','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','','','','','','','','','6','','','','','N','N','','' } )
	AAdd( aSX3, { 'SE2',NIL,'E2_XFGTS03','C',48,0,'Cod.Barras','Cod.Barras','Cod.Barras','Codigo de barras do FTGS','Codigo de barras do FTGS','Codigo de barras do FTGS','@!','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','','','','','','','','','6','','','','','N','N','','' } )
	AAdd( aSX3, { 'SE2',NIL,'E2_XFGTS04','C',17,0,'Identificad.','Identificad.','Identificad.','Codigo do identificador','Codigo do identificador','Codigo do identificador','@!','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','','','','','','','','','6','','','','','N','N','','' } )
	AAdd( aSX3, { 'SE2',NIL,'E2_XFGTS05','C', 9,0,'Lacre','Lacre','Lacre','Lacre do conectiv. social','Lacre do conectiv. social','Lacre do conectiv. social','@!','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','','','','','','','','','6','','','','','N','N','','' } )
	AAdd( aSX3, { 'SE2',NIL,'E2_XFGTS06','C', 2,0,'Digito Lacre','Digito Lacre','Digito Lacre','Digito do lacre','Digito do lacre','Digito do lacre','99','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','','','','','','','','','6','','','','','N','N','','' } )
	
	AAdd( aSX3, { 'SE2',NIL,'E2_XGNRE01','C', 6,0,'Cod. Receita','Cod. Receita','Cod. Receita','Codigo Receita GNRE','Codigo Receita GNRE','Codigo Receita GNRE','999999','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','','','','','','','','','7','','','','','N','N','','' } )
	
	AAdd( aHelp, { 'E2_XGPS01', 'Código identificador do tributo GPS.' } )
	AAdd( aHelp, { 'E2_XGPS02', 'Código do pagamento do tributo GPS.' } )
	AAdd( aHelp, { 'E2_XGPS03', 'Competência do tributo GPS (MMAAAA).' } )
	AAdd( aHelp, { 'E2_XGPS04', 'Código identificador do contribuinte.' } )
	AAdd( aHelp, { 'E2_XGPS05', 'Valor base do INSS.' } )
	AAdd( aHelp, { 'E2_XGPS06', 'Valor de outras entidades.' } )
	
	AAdd( aHelp, { 'E2_XDARF01', 'Código identificador do tributo DARF.' } )
	AAdd( aHelp, { 'E2_XDARF02', 'Código da receita do tributo DARF.' } )
	AAdd( aHelp, { 'E2_XDARF03', 'Período de apuração do tributo DARF (DDMMAAAA).' } )
	AAdd( aHelp, { 'E2_XDARF04', 'Número de referência do tributo DARF.' } )
		
	AAdd( aHelp, { 'E2_XGARE01', 'Código identificador do tributo GARE.' } )
	AAdd( aHelp, { 'E2_XGARE02', 'Código da receita do tributo GARE.' } )
	AAdd( aHelp, { 'E2_XGARE03', 'Mês e Ano de referência do tributo GARE.' } )
	
	AAdd( aHelp, { 'E2_XIPVA01', 'Código identificador do tributo IPVA/DPVAT.' } )
	AAdd( aHelp, { 'E2_XIPVA02', 'Código do Renavam.' } )
	AAdd( aHelp, { 'E2_XIPVA03', 'Unidade Federativa do Renavam.' } )
	AAdd( aHelp, { 'E2_XIPVA04', 'Código do munícipio.' } )
	AAdd( aHelp, { 'E2_XIPVA05', 'Placa do veículo.' } )
	AAdd( aHelp, { 'E2_XIPVA06', 'Código da opção do pagamento do tributo IPVA ou DPVAT.' } )
	
	AAdd( aHelp, { 'E2_XFGTS01', 'Código identificador do tributo FGTS.' } )
	AAdd( aHelp, { 'E2_XFGTS02', 'Código da receita do tributo FGTS.' } )
	AAdd( aHelp, { 'E2_XFGTS03', 'Código de barras do tributo FGTS.' } )
	AAdd( aHelp, { 'E2_XFGTS04', 'Código do identificador do tributo FGTS.' } )
	AAdd( aHelp, { 'E2_XFGTS05', 'Lacre do conectividade social do tributo FGTS.' } )
	AAdd( aHelp, { 'E2_XFGTS06', 'Dígito do lacre do conectividade social do tributo FGTS.' } )
	
	AAdd( aHelp, { 'E2_XNGRE01', 'Código da receita para tributos GNRE.' } )
	
	AAdd( aSXA, { 'SE2','1','Contas a Pagar'     ,'Contas a Pagar'     ,'Contas a Pagar'     ,'U' } )
	AAdd( aSXA, { 'SE2','2','Dados GPS'          ,'Dados GPS'          ,'Dados GPS'          ,'U' } )
	AAdd( aSXA, { 'SE2','3','Dados DARF'         ,'Dados DARF'         ,'Dados DARF'         ,'U' } )
	AAdd( aSXA, { 'SE2','4','Dados GARE'         ,'Dados GARE'         ,'Dados GARE'         ,'U' } )
	AAdd( aSXA, { 'SE2','5','Dados IPVA ou DPVAT','Dados IPVA ou DPVAT','Dados IPVA ou DPVAT','U' } )
	AAdd( aSXA, { 'SE2','6','Dados FGTS ou GFIP' ,'Dados FGTS ou GFIP' ,'Dados FGTS ou GFIP' ,'U' } )
	AAdd( aSXA, { 'SE2','7','Dados GNRE'         ,'Dados GNRE'         ,'Dados GNRE'         ,'U' } )
Return