#INCLUDE "PROTHEUS.CH"

#DEFINE POS_OK			1
#DEFINE POS_NFDEV		2
#DEFINE POS_SERDEV		3
#DEFINE POS_FORNECE		4
#DEFINE POS_LOJA		5 
#DEFINE POS_FORBLQ		6
#DEFINE POS_NREDUZ		7
#DEFINE POS_PRODUTO		8
#DEFINE POS_NFORI       10
#DEFINE POS_SERORI      11
#DEFINE POS_SALDO       12
#DEFINE POS_VLREM    	13
#DEFINE POS_NUMSEQ    	14
#DEFINE POS_ITEMORI     15
#DEFINE POS_CHAVE		16

#DEFINE CHR_NFDEV		"XXXXXX"
#DEFINE CHR_SERDEV		"XXX"

/*
---------------------------------------------------------------------------
| Rotina    | CERNFDEV    | Autor | Gustavo Prudente | Data | 12.07.2013  |
|-------------------------------------------------------------------------|
| Descricao | Gera notas fiscais de devolucao para produtos com saldo na  |
|           | tabela SB3.                                                 |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
User Function CERNFDEV( lDebug )

Local oDlgNFD
Local oListNFD
Local oChkMar
                                    
Local oBtn1
Local oBtn2
Local oBtn3

Local oPanelList
Local oPanelBtn

Local oOk := LoadBitmap( GetResources(), "LBOK" )
Local oNo := LoadBitmap( GetResources(), "LBNO" )

Local aRetPar  := { CtoD( "  /  /  " ), CtoD( "31/05/13" ), "      ", "ZZZZZZ", Space(15), Replicate("Z",15) }
Local aSelTES  := { { .T., Space( 03 ), Space( 40 ) } }
Local aNFD     := { { .T., "  ", "  ", "  ", "  ", "  ", "  ", "  ", "  ", "  ", "  ", "  ", " " } }

Local lRet 	   := .T.
Local lTodos   := .T.

Default lDebug := .F.

If lDebug
	RpcSetType( 3 )
	RpcSetEnv( "01", "02" )
EndIf              

// Ativa diálogo centralizado
oDlgNFD := MSDialog():New( 180, 180, 700, 1200, "Geração de NF de Devolução - Poder Terceiros",,,,, CLR_BLACK, CLR_WHITE,,, .T. )  
             
oPanelBtn		:= tPanel():New( 01, 01, "", oDlgNFD,,.T.,,,, 1, 16, .F., .F. )
oPanelBtn:Align := CONTROL_ALIGN_BOTTOM

@ 005, 005 	LISTBOX oListNFD FIELDS HEADER 	" ", "NF Dev", "Série Dev", "Fornecedor", "Loja", "Bloq.", "Nome Reduzido", ;
											"Produto", "Emissão", "NF Orig", "Série Ori", "Saldo", "Valor Remessa" ;
			SIZE 500, 500 OF oDlgNFD PIXEL ON DblClick( Inverte( oListNFD, @aNFD ) ) .And. SetArray( @oListNFD, aNFD ) 
	                                      
oListNFD:SetArray( aNFD )
oListNFD:bLine := { || 	{ Iif( 	aNFD[ oListNFD:nAt, 01 ], oOk, oNo ) , ;
                          aNFD[ oListNFD:nAt, 02 ] , ;
  						  aNFD[ oListNFD:nAt, 03 ] , ;
  						  aNFD[ oListNFD:nAt, 04 ] , ;
  						  aNFD[ oListNFD:nAt, 05 ] , ;
  						  aNFD[ oListNFD:nAt, 06 ] , ;
  						  aNFD[ oListNFD:nAt, 07 ] , ;
  						  aNFD[ oListNFD:nAt, 08 ] , ;
  						  aNFD[ oListNFD:nAt, 09 ] , ;
  						  aNFD[ oListNFD:nAt, 10 ] , ;
  						  aNFD[ oListNFD:nAt, 11 ] , ;
  						  aNFD[ oListNFD:nAt, 12 ] , ;
  						  aNFD[ oListNFD:nAt, 13 ] } }

oListNFD:Align := CONTROL_ALIGN_ALLCLIENT

oBtn1 := TButton():New( 002, 344, "&Parametros", oPanelBtn, { || PergNFDev( @aRetPar ) .And. SelTES( @aSelTES ) }, 040, 013,,,, .T.,, "",,,, .F. )

oBtn2 := TButton():New( 002, 386, "&Consultar" , oPanelBtn, ;
					{ || Processa( { || aNFD := ProcNFDev( aRetPar, aSelTES ), SetArray( @oListNFD, aNFD ) }, ;
					"Geração de NF de Devolução - Poder de Terceiros", "", .F.  ) }, 040, 013,,,, .T.,, "",,,, .F. )
					
oBtn1 := TButton():New( 002, 428, "&Processar" , oPanelBtn, { || GeraNFD( @aNFD )				, ;
															SetArray( @oListNFD, aNFD ) }		, ;
															040, 013,,,, .T.,, "",,,, .F. )
															     
oBtn3 := TButton():New( 002, 470, "&Sair"      , oPanelBtn, { || lRet := .F., oDlgNFD:End() }, 040, 013,,,, .T.,, "",,,, .F. )        

@ 004, 002 CheckBox oChkMar Var lTodos Prompt "Inverte Seleção" Message Size 100, 010 Pixel Of oPanelBtn ;
	On Click { || MarcaTodos( oListNFD, @aNFD ), SetArray( @oListNFD, aNFD ) }

oDlgNFD:Activate( ,,, .T. )

Return
 

/*
---------------------------------------------------------------------------
| Rotina    | ProcNFDev   | Autor | Gustavo Prudente | Data | 12.07.2013  |
|-------------------------------------------------------------------------|
| Descricao | Realiza o processamento das notas de entrada (devolucao)    |
|           | a partir das perguntas e TES selecionadas.                  |
|-------------------------------------------------------------------------|
| Parametros| EXPA1 - Array com as perguntas informadas                   |
|           | EXPA2 - Array com as TES selecionadas.                      |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function ProcNFDev( aRetPar, aSelTES )
                                              
Local aNFD     	 := { { .T., "  ", "  ", "  ", "  ", "  ", "  ", "  ", "  ", "  ", "  ", "  ", " " } }
Local nTamSaldo  := TamSX3( "B6_SALDO"  )[ 1 ]
Local nTamPrcVen := TamSX3( "D2_PRCVEN" )[ 1 ]

Local nX := 0

Local cWhereTES := ""                  
Local cFornece  := ""            
Local cBloq		:= ""

Local cAlias	:= Alias()
              
// Adiciona filtro por TES
For nX := 1 To Len( aSelTES )
	cWhereTES += Iif( aSelTES[ nX, 1 ], "'" + AllTrim( aSelTES[ nX, 2 ] ) + "',", "" )
Next nX

cWhereTES := SubStr( cWhereTES, 1, Len( cWhereTES ) - 1 )

If At( ",", AllTrim( cWhereTES ) ) > 0
	cWhere := " SB6.B6_TES IN ( " + cWhereTES + " ) "
Else
	cWhere := " SB6.B6_TES = " + cWhereTES + " "
EndIf

// Filtro por Data
If Empty( aRetPar[ 1 ] )
	cWhere += " AND SB6.B6_EMISSAO <= '" + DtoS( aRetPar[ 2 ] ) + "' "
Else
	cWhere += " AND SB6.B6_EMISSAO BETWEEN '" + DtoS( aRetPar[ 1 ] ) + "' AND '" + DtoS( aRetPar[ 2 ] ) + "' "
EndIf             

// Filtro por Fornecedor
If ! Empty( aRetPar[ 3 ] ) .And. ! Empty( aRetPar[ 4 ] ) .And. aRetPar[ 3 ] == aRetPar[ 4 ] 
	cWhere += " AND SB6.B6_CLIFOR = '" + aRetPar[ 3 ] + "' "
Else                    
	If Empty( aRetPar[ 3 ] ) .And. ! Empty( aRetPar[ 4 ] ) .And. aRetPar[ 4 ] == Replicate( "Z", Len( aRetPar[ 4 ] ) )
		cWhere += ""
	Else
		cWhere += " AND SB6.B6_CLIFOR BETWEEN '" + aRetPar[ 3 ] + "' AND '" + aRetPar[ 4 ] + "' "	
	EndIf
EndIf        

// Filtro por Produto
If ! Empty( aRetPar[ 5 ] ) .And. ! Empty( aRetPar[ 6 ] ) .And. aRetPar[ 5 ] == aRetPar[ 6 ]
	cWhere += " AND SB6.B6_PRODUTO = '" + aRetPar[ 5 ] + "' "
Else
	If Empty( aRetPar[ 5 ] ) .And. ! Empty( aRetPar[ 6 ] ) .And. aRetPar[ 6 ] == Replicate( "Z", Len( aRetPar[ 6 ] ) )
		cWhere += ""
	Else            
		cWhere += " AND SB6.B6_PRODUTO BETWEEN '" + aRetPar[ 5 ] + "' AND '" + aRetPar[ 6 ] + "' "
	EndIf
EndIf	

cWhere := "%" + cWhere + "%"

cOrder := "%" + "SB6.B6_CLIFOR, SB6.B6_LOJA, SB6.B6_PRODUTO, SB6.B6_EMISSAO, SB6.B6_DOC, SB6.B6_SERIE, SD2.D2_NUMSEQ" + "%"
        
// Inicia processamento da Query
ProcRegua( 3 )

IncProc( "Executando a Query ... " )                                   

BeginSql Alias "TRBDEV"
    
	Column EMISSAO AS Date
	Column SALDO   AS Numeric( nTamSaldo, 2 )
	Column PRCVEN  AS Numeric( nTamPrcVen, 2 )

	SELECT DISTINCT SB6.B6_CLIFOR  AS FORNECE, SB6.B6_LOJA    AS LOJA   , SA2.A2_NREDUZ AS NREDUZ, SA2.A2_MSBLQL AS FORBLQ,
					SB6.B6_PRODUTO AS PRODUTO, SB6.B6_EMISSAO AS EMISSAO, SB6.B6_DOC    AS NFORI , SB6.B6_SERIE  AS SERIEORI, 
					SB6.B6_SALDO   AS SALDO  , SD2.D2_ITEM    AS ITEM   , SD2.D2_PRCVEN AS PRCVEN, SD2.D2_NUMSEQ AS NUMSEQ
	FROM %Table:SB6% SB6
	INNER JOIN %Table:SF4% SF4 ON
		SF4.F4_FILIAL = %xFilial:SF4% AND
		SF4.F4_CODIGO = SB6.B6_TES AND
		SF4.F4_TESDV > ' ' AND
		SF4.%notDel%
	INNER JOIN %Table:SD2% SD2 ON 
		SD2.D2_FILIAL = %xFilial:SD2% AND
		SD2.D2_NUMSEQ = SB6.B6_IDENT AND
		SD2.%notDel%
	INNER JOIN %Table:SA2% SA2 ON
		SA2.A2_FILIAL = %xFilial:SA2% AND
		SA2.A2_COD    = SB6.B6_CLIFOR AND
		SA2.A2_LOJA   = SB6.B6_LOJA AND
		SA2.%notDel% 
	WHERE
		SB6.B6_FILIAL = %xFilial:SB6% AND
		%Exp:cWhere% AND
		SB6.B6_PODER3 = 'R' AND
		SB6.B6_TPCF   = 'F' AND
		SB6.B6_SALDO  > 0 AND
		SB6.%notDel%
	ORDER BY %Exp:cOrder%
	
EndSql

TRBDEV->( dbGoTop() )

If TRBDEV->( EoF() )

	Aviso( "Geração de NF de Devolução - Poder Terceiros", "Não foram encontrados produtos com saldo para geração de NF de Devolução.", { "Ok" }, 2 )
	                  
Else	

	IncProc( "Processando Notas de Devolução ... " )                       
	
	aNFD := {}

	Do While TRBDEV->( ! EoF() )

		If TRBDEV->FORNECE + TRBDEV->LOJA <> cFornece
			
			cFornece := TRBDEV->FORNECE + TRBDEV->LOJA
			cBloq	 := Iif( TRBDEV->FORBLQ == "1", "Sim", "Não" )
			
			AAdd( aNFD, { 	.T., CHR_NFDEV, CHR_SERDEV, TRBDEV->FORNECE, TRBDEV->LOJA, ;
							cBloq, TRBDEV->NREDUZ, TRBDEV->PRODUTO, DtoC( TRBDEV->EMISSAO ) , ;
						  	TRBDEV->NFORI, TRBDEV->SERIEORI, TRBDEV->SALDO, TRBDEV->PRCVEN, ;
						  	TRBDEV->NUMSEQ, TRBDEV->ITEM , cFornece } )
		
		Else              
		
			AAdd( aNFD, { 	.T., "      ", "   ", "      ", "  ", " ", "      ", TRBDEV->PRODUTO, DtoC( TRBDEV->EMISSAO ), ;
						  TRBDEV->NFORI , TRBDEV->SERIEORI, TRBDEV->SALDO, TRBDEV->PRCVEN, TRBDEV->NUMSEQ, TRBDEV->ITEM, cFornece } )
		
		EndIf
	
	    TRBDEV->( DBSkip() )

	EndDo

EndIf                                                              

TRBDEV->( dbCloseArea() ) 

dbSelectArea( cAlias )
        
Return( aNFD )


/*
---------------------------------------------------------------------------
| Rotina    | PergNFDev   | Autor | Gustavo Prudente | Data | 12.07.2013  |
|-------------------------------------------------------------------------|
| Descricao | Monta grupo de perguntas e apresenta para preenchimento     |
|-------------------------------------------------------------------------|
| Parametros| EXPA1 - Array com as perguntas informadas                   |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function PergNFDev( aRetPar )

Local aPergs 	:= {}
Local lRet	 	:= .T.                   

aAdd( aPergs, { 1, "De"        	, CtoD( Space( 8 ) ), "@D", ".T.",, ".T.", 8, .F. } )
aAdd( aPergs, { 1, "Ate"       	, CtoD( "31/05/13" ), "@D", ".T.",, ".T.", 8, .T. } )
aAdd( aPergs, { 1, "Fornecedor"	, Space( 6 ), "@!", ".T.", "SA2", ".T.", 6, .F. } )
aAdd( aPergs, { 1, "Fornecedor"	, "ZZZZZZ"  , "@!", ".T.", "SA2", ".T.", 6, .F. } )
aAdd( aPergs, { 1, "Produto De"	, Space( 15 ), "@!", ".T.", "SB1", ".T.", 50, .F. } )
aAdd( aPergs, { 1, "Produto Ate", Replicate( "Z", 15 ), "@!", ".T.", "SB1", ".T.", 50, .F. } )

lRet := ParamBox( aPergs,"Gera NF de Devolução", @aRetPar )

Return lRet                                                          


/*
---------------------------------------------------------------------------
| Rotina    | SelTES      | Autor | Gustavo Prudente | Data | 12.07.2013  |
|-------------------------------------------------------------------------|
| Descricao | Monta tela para selecao das TES, de acordo com filtros      |
|           | necessarios passados na Query.                              |
|-------------------------------------------------------------------------|
| Parametros| EXPA1 - Array com as TES selecionadas                       |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/      
Static Function SelTES( aSelTES )

Local oDlgTES
Local oListTES
                                    
Local oBtn1
Local oBtn2

Local oPanelList
Local oPanelBtn

Local oOk    := LoadBitmap( GetResources(), "LBOK" )
Local oNo    := LoadBitmap( GetResources(), "LBNO" )
                        
Local lRet   := .F.

Local cAlias := Alias()

// Seleciona TES de acordo com os filtros da Query
If Len( aSelTES ) == 1 .And. Empty( aSelTES[ 1, 2 ] ) .And. Empty( aSelTES[ 1, 3 ] )

	aSelTES  := {}

	BeginSql Alias "TRBTES"

		SELECT SB6.B6_TES AS TES, SF4.F4_TEXTO AS DESCRI
		FROM %Table:SB6% SB6
		INNER JOIN %Table:SF4% SF4 ON
			SF4.F4_FILIAL = %xFilial:SF4% AND
			SF4.F4_CODIGO = SB6.B6_TES AND
			SF4.F4_TESDV > ' ' AND
			SF4.%notDel%
		WHERE
			SB6.B6_FILIAL = %xFilial:SB6% AND
			SB6.B6_PODER3 = 'R' AND
			SB6.B6_TPCF   = 'F' AND
			SB6.%notDel%
		GROUP BY SB6.B6_TES, SF4.F4_TEXTO

	EndSql
	                                 
	Do While TRBTES->( ! EoF() )
		AAdd( aSelTES, { .T., TRBTES->TES, SubStr( TRBTES->DESCRI, 1, 40 ) } )
		TRBTES->( dbSkip() )
	EndDo
                                                                         
	TRBTES->( dbCloseArea() )	
	DBSelectArea( cAlias )

EndIf

oDlgTES := MSDialog():New( 180, 180, 400, 600, "Geração de NF de Devolução - Poder Terceiros",,,,, CLR_BLACK, CLR_WHITE,,, .T. )  // Ativa diálogo centralizado
             
oPanelBtn		:= tPanel():New( 01, 01, "", oDlgTES,,.T.,,,, 1, 16, .F., .F. )
oPanelBtn:Align := CONTROL_ALIGN_BOTTOM

@ 005, 005 LISTBOX oListTES FIELDS HEADER " ", "TES", "Descrição", ;
	SIZE 100, 100 OF oDlgTES PIXEL ON dblClick( aSelTES[ oListTES:nAt, 1 ] := ! aSelTES[ oListTES:nAt, 1 ] )
	                                      
oListTES:SetArray( aSelTES )
oListTES:bLine := { || 	{ Iif( 	aSelTES[ oListTES:nAt, 1 ], oOk, oNo ) , ;
  								aSelTES[ oListTES:nAt, 2 ] , ;
								aSelTES[ oListTES:nAt, 3 ] } }

oListTES:Align := CONTROL_ALIGN_ALLCLIENT

oBtn1 := TButton():New( 003, 143, "&Ok"		 , oPanelBtn, { || lRet := .T., oDlgTES:End() }, 032, 011,,,, .T.,, "",,,, .F. )
oBtn1 := TButton():New( 003, 178, "&Cancelar", oPanelBtn, { || lRet := .F., oDlgTES:End() }, 032, 011,,,, .T.,, "",,,, .F. )

oDlgTES:Activate( ,,, .T. )

Return( lRet )


/*
----------------------------------------------------------------------------
| Rotina    | SetArray    | Autor | Gustavo Prudente | Data | 15.07.2013   |
|--------------------------------------------------------------------------|
| Descricao | Atualiza array com o resultado das notas fiscais encontradas |
|           | de acordo com a configuracao das perguntas.                  |
|--------------------------------------------------------------------------|
| Parametros| EXPO1 - Objeto de lista de notas fiscais                     |
|           | EXPA2 - Array com as notas fiscais de devolucao sugeridas    |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/      
Static Function SetArray( oListNFD, aNFD )
      
Local oOk := LoadBitmap( GetResources(), "LBOK" )
Local oNo := LoadBitmap( GetResources(), "LBNO" )

oListNFD:SetArray( aNFD )

oListNFD:bLine := { || 	{ Iif( 	aNFD[ oListNFD:nAt, 01 ], oOk, oNo ) , ;
  						  aNFD[ oListNFD:nAt, 02 ] , ;
  						  aNFD[ oListNFD:nAt, 03 ] , ;
  						  aNFD[ oListNFD:nAt, 04 ] , ;
  						  aNFD[ oListNFD:nAt, 05 ] , ;
  						  aNFD[ oListNFD:nAt, 06 ] , ;
  						  aNFD[ oListNFD:nAt, 07 ] , ;
  						  aNFD[ oListNFD:nAt, 08 ] , ;
  						  aNFD[ oListNFD:nAt, 09 ] , ;
  						  aNFD[ oListNFD:nAt, 10 ] , ;
						  aNFD[ oListNFD:nAt, 11 ] , ;
						  aNFD[ oListNFD:nAt, 12 ] , ;
						  aNFD[ oListNFD:nAt, 13 ] } }

oListNFD:Refresh()

Return .T.

      
/*
----------------------------------------------------------------------------
| Rotina    | Inverte     | Autor | Gustavo Prudente | Data | 15.07.2013   |
|--------------------------------------------------------------------------|
| Descricao | Inverte selecao das notas de devolucao para processamento    |
|--------------------------------------------------------------------------|
| Parametros| EXPO1 - Objeto de listbox das notas de devolucao             |
|           | EXPA2 - Array com os produtos e notas de devolucao           |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/                                                                            
Static Function Inverte( oListNFD, aNFD )

Local nPosNFD := oListNFD:nAt     

If 	aNFD[ nPosNFD, POS_SALDO ] > 0 .And. aNFD[ nPosNFD, POS_NFDEV ] == CHR_NFDEV

	aNFD[ nPosNFD, POS_OK ] := ! aNFD[ nPosNFD, POS_OK ]
	nPosNFD ++
	
	Do While nPosNFD <= Len( aNFD ) .And. Empty( aNFD[ nPosNFD, POS_NFDEV ] )
		aNFD[ nPosNFD, POS_OK ] := ! aNFD[ nPosNFD, POS_OK ]
		nPosNFD ++
	EndDo
	      
EndIf

Return .T.

                                            
/*
----------------------------------------------------------------------------
| Rotina    | MarcaTodos  | Autor | Gustavo Prudente | Data | 15.07.2013   |
|--------------------------------------------------------------------------|
| Descricao | Marca todas as notas de devolucao para processamento         |
|--------------------------------------------------------------------------|
| Parametros| EXPO1 - Objeto de listbox das notas de devolucao             |
|           | EXPA2 - Array com os produtos e notas de devolucao           |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/                                                                            
Static Function MarcaTodos( oListNFD, aNFD )

Local nX

For nX := 1 To Len( aNFD )
	aNFD[ nX, POS_OK ] := ! aNFD[ nX, POS_OK ]
Next nX
      
Return


/*
----------------------------------------------------------------------------
| Rotina    | GeraNFD     | Autor | Gustavo Prudente | Data | 17.07.2013   |
|--------------------------------------------------------------------------|
| Descricao | Processa chamada da rotina de gravacao das NFs de devolucao  |
|--------------------------------------------------------------------------|
| Parametros| EXPA2 - Array com os produtos e notas de devolucao           |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/                                                                            
Static Function GeraNFD( aNFD )

Private oProcess

oProcess := MsNewProcess():New( { || GrvNFDev( @aNFD ) }							, ;
								"Geração de NF de Devolução - Poder de Terceiros"	, ;
								"Aguarde a gravação das notas ...", .T. )
oProcess:Activate()

Return .T.
      


/*
----------------------------------------------------------------------------
| Rotina    | GrvNFDev    | Autor | Gustavo Prudente | Data | 15.07.2013   |
|--------------------------------------------------------------------------|
| Descricao | Gera notas fiscais de devolucao de acordo com a selecao      |
|           | dos produtos com saldo na SB6.                               |
|--------------------------------------------------------------------------|
| Parametros| EXPA2 - Array com os produtos e notas de devolucao           |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/                                                                            
Static Function GrvNFDev( aNFD )

Local aLinha	:= {}        
Local aItens	:= {}
Local aCabec	:= {}
             
Local cSerie	:= ""		// Serie da NF de Entrada - retorno terceiros
Local cTpNrNfs	:= ""    	// Serie da NF de Saida (param. para numeracao autom.)
Local cTesDev	:= ""		// Tes utilizado para devolucao de poder de terceiro
Local cTipoNF  	:= ""		// Tipo de documento de entrada referente a devolucao
Local cEspecie 	:= ""		// Especie na nota fiscal de entrada, referente a devolucao  

Local cNumDev	:= ""
Local cForAtu	:= ""
Local cLojAtu	:= ""
Local cChave	:= ""
Local cNReduz	:= ""

Local nX 		:= 1
Local nTamDoc	:= TamSX3( "F1_DOC" )[ 1 ]
                              
Private lMsErroAuto := .F.		// Controla erro retorno rotina

If Len( aNFD ) == 1 .And. Empty( aNFD[ 1, 2 ] )
	Aviso( "Geração de NF de Devolução - Poder Terceiros", "Não foram encontrados dados para processamento.", { "Ok" } )
	Return .T.
EndIf
                  
oProcess:SetRegua1( 1 )
oProcess:SetRegua2( Len( aNFD ) )

If Aviso( "Geração de NF de Devolução - Poder Terceiros", "Confirma a geração de NF de Devolução dos itens selecionados ?", { "Sim", "Não" }, 2 ) == 1

	oProcess:IncRegua1( "Aguarde a gravação das notas ..." )
	oProcess:IncRegua2( "Processando ... " )
	
	cSerie	 := GetMV( "MV_XSERDEV",, "2"    )		// Serie da NF de Entrada - retorno terceiros
	cTpNrNfs := GetMV( "MV_TPNRNFS",, "2"    )    	// Serie da NF de Saida (param. para numeracao autom.)
	cTesDev	 := SuperGetMV( "MV_XTESDEV",, "008"  )		// Tes utilizado para devolucao de poder de terceiro
	cTipoNF  := SuperGetMV( "MV_XTPDEVO",, "N"    )		// Tipo de documento de entrada referente a devolucao
	cEspecie := SuperGetMV( "MV_XESPECI",, "SPED" )		// Especie na nota fiscal de entrada, referente a devolucao  

	Do While nX <= Len( aNFD )
	                        
		If ! aNFD[ nX, 1 ] 

			oProcess:IncRegua2( "Processando ... " )
			nX ++
		
		ElseIf aNFD[ nX, POS_CHAVE ] <> cChave

			cChave  := aNFD[ nX, POS_CHAVE ]
			cForAtu	:= aNFD[ nX, POS_FORNECE ]
			cLojAtu	:= aNFD[ nX, POS_LOJA ] 
			aItens	:= {}
			aCabec  := {}		
			
			// Busca proxima numero de NF de Entrada                                                
			cNReduz := AllTrim( aNFD[ nX, POS_NREDUZ ] )
			
			oProcess:IncRegua2( "Processando ... " )

			AAdd( aCabec, { "F1_DOC"    , ""		, Nil } )	// Numero da NF
			AAdd( aCabec, { "F1_SERIE"  , cSerie	, Nil } )	// Serie da NF
			AAdd( aCabec, { "F1_FORMUL" , "S"		, Nil } )  	// Formulario proprio
			AAdd( aCabec, { "F1_EMISSAO", dDataBase	, Nil } )  	// Data emissao
			AAdd( aCabec, { "F1_FORNECE", cForAtu	, Nil } )	// Codigo do Fornecedor
			AAdd( aCabec, { "F1_LOJA"   , cLojAtu	, Nil } )	// Loja do Fornecedor
			AAdd( aCabec, { "F1_TIPO"   , cTipoNF	, Nil } )	// Tipo da NF
			AAdd( aCabec, { "F1_ESPECIE", cEspecie	, Nil } )	// Especie da NF
			              
			Do While nX <= Len( aNFD ) .And. aNFD[ nX, POS_CHAVE ] == cChave
				
	            aLinha := {}
	            
			  	AAdd( aLinha, { "D1_DOC"     , ""											, Nil } )
				AAdd( aLinha, { "D1_SERIE"   , cSerie										, Nil } )
				AAdd( aLinha, { "D1_FORNECE" , cForAtu										, Nil } )
				AAdd( aLinha, { "D1_LOJA"    , cLojAtu										, Nil } )
				AAdd( aLinha, { "D1_COD"     , aNFD[ nX, POS_PRODUTO ]						, Nil } )
				AAdd( aLinha, { "D1_NFORI"	 , aNFD[ nX, POS_NFORI ]						, Nil } )
				AAdd( aLinha, { "D1_SERIORI" , aNFD[ nX, POS_SERORI ]						, Nil } )
				AAdd( aLinha, { "D1_ITEMORI" , aNFD[ nX, POS_ITEMORI ]						, Nil } )
				AAdd( aLinha, { "D1_QUANT"	 , aNFD[ nX, POS_SALDO ]						, Nil } )
				AAdd( aLinha, { "D1_VUNIT"	 , aNFD[ nX, POS_VLREM ]						, Nil } )
				AAdd( aLinha, { "D1_TOTAL"	 , aNFD[ nX, POS_SALDO ] * aNFD[ nX, POS_VLREM ], Nil } )
				AAdd( aLinha, { "D1_TES"	 , cTesDev				 						, Nil } )
				AAdd( aLinha, { "D1_IDENTB6" , aNFD[ nX, POS_NUMSEQ ]  						, Nil } )
	
				AAdd( aItens, aLinha )
				
				nX ++
	
				oProcess:IncRegua2( "Processando ... " )
				
			EndDo
			
	        // Atualiza numero de NF de Devolucao antes de chamar a rotina automatica
	        cNumDev := ""
			Do While Empty( AllTrim( cNumDev ) )
				cNumDev	:= PadR( NxtSX5Nota( cSerie, .T., cTpNrNfs ), nTamDoc )
			EndDo

			Conout( "[CERNFDEV] INICIO: GERACAO NF DEVOLUCAO " + cSerie + " | " + cNumDev + " | " + cForAtu + " | " + cLojAtu + " [" + DToC( Date() ) + "-" + Time() + "]" )
			
			aCabec[ 1, 2 ] := cNumDev
			
			For nX := 1 To Len( aItens )
				aItens[ nX, 1, 2 ] := cNumDev
			Next nX		

			MSExecAuto( { |x, y, z| MATA103( x, y, z ) }, aCabec, aItens, 3 ) // ExecAuto para emissao da NFe de Entrada retorno de terceiros

			If 	lMsErroAuto
				
				Conout( "[CERNFDEV] INCONSISTENCIA NA DEVOLUCAO " + cSerie + " | " + cNumDev + " | " + cForAtu + " | " + cLojAtu + " [" + DToC( Date() ) + "-" + Time() + "]" )
				
				DisarmTransaction()
				MostraErro()
				
				Exit                    
				
			Else
				
				Conout( "[CERNFDEV] FIM: GERACAO COM SUCESSO DA NF DEVOLUCAO " + cSerie + " | " + cNumDev + " | " + cForAtu + " | " + cLojAtu + " | " + " [" + DToC( Date() ) + "-" + Time() + "]" )
				         
				AtualizaNFD( @aNFD, cChave, cNumDev, cSerie )
				
			EndIf                
	
		EndIf
		
	EndDo                    
	
EndIf

Return                                                   

             
/*
----------------------------------------------------------------------------
| Rotina    | AtualizaNFD | Autor | Gustavo Prudente | Data | 16.07.2013   |
|--------------------------------------------------------------------------|
| Descricao | Atualiza array de notas fiscais de devolucao com os numeros  |
|           | de notas fiscais jah gerados.                                |
|--------------------------------------------------------------------------|
| Parametros| EXPA1 - Array com os produtos e notas de devolucao           |
|           | EXPC2 - Chave de identificacao dos produtos na NF de Dev.    |
|           | EXPC3 - Numero da NF de Devolucao gerada.                    |
|           | EXPC4 - Serie da NF de Devolucao gerada.                     |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/                                                                            
Static Function AtualizaNFD( aNFD, cChave, cNumDev, cSerie )

Local nPosNFD  := 0
Local nPosMark := 0
                                                           
// Pesquisa chave que foi gerada a NF de devolucao
nPosMark := AScan( aNFD, { |x| x[ POS_CHAVE ] == cChave } )

If nPosMark > 0
	
	nPosNFD := nPosMark

	Do While nPosNFD <= Len( aNFD ) .And. ( Empty( aNFD[ nPosNFD, POS_NFDEV ] ) .Or. nPosNFD == nPosMark )
	
		aNFD[ nPosNFD, POS_OK      ] := ! aNFD[ nPosNFD, POS_OK ]
		aNFD[ nPosNFD, POS_NFDEV   ] := cNumDev
		aNFD[ nPosNFD, POS_SERDEV  ] := cSerie
		aNFD[ nPosNFD, POS_SALDO   ] := 0
		aNFD[ nPosNFD, POS_FORNECE ] := aNFD[ nPosMark, POS_FORNECE ]
		aNFD[ nPosNFD, POS_LOJA    ] := aNFD[ nPosMark, POS_LOJA    ]
		aNFD[ nPosNFD, POS_FORBLQ  ] := aNFD[ nPosMark, POS_FORBLQ	]
		aNFD[ nPosNFD, POS_NREDUZ  ] := aNFD[ nPosMark, POS_NREDUZ  ]
	
		nPosNFD ++
	
	EndDo

EndIf

Return( .T. )