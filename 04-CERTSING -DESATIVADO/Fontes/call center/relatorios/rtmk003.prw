#INCLUDE "protheus.ch"

/*
---------------------------------------------------------------------------
| Rotina    | RTMK003     | Autor | Gustavo Prudente | Data | 22.10.2013  |
|-------------------------------------------------------------------------|
| Descricao | Impressao de atendimentos por grupo sem informações de TMA  |
|           | e TME.                                                      |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
User Function RTMK003()

Local oReport

oReport := ReportDef()
oReport:printDialog()
	
Return
         
/*
---------------------------------------------------------------------------
| Rotina    | reportDef   | Autor | Gustavo Prudente | Data | 22.10.2013  |
|-------------------------------------------------------------------------|
| Descricao | Definicao de secao do relatorio de detalhes de atendimentos |
|-------------------------------------------------------------------------|
| Parametros| EXPC1 - Grupo de perguntas                                  |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function ReportDef()

Local oReport
Local oSection1
Local oSection2
Local cTitulo 	:= "@Atendimentos por Grupo"
Local aRetPar	:= {}
Local aSelGrp	:= { { .T., Space( 02 ), Space( 40 ) } }
 
oReport := TReport():New( 'RTMK003', cTitulo, 	{ || Iif( SelGrupos( @aSelGrp ), PergR003( @aRetPar ), .F. ) }, ;
												{ |oReport| PrintReport( oReport, @aRetPar, @aSelGrp ) }, ;
												"Este relatório irá imprimir detalhes dos atendimentos." )

oReport:SetLandScape()
oReport:SetTotalInLine( .F. )
oReport:ShowHeader()
 
oSection1 := TRSection():New( oReport, "Grupo", { "QRYTRB" } )
oSection1:SetTotalInLine( .F. )

TRCell():New( oSection1, "ADF_CODSU0", "QRYTRB", "Grupo"    , PesqPict( "ADF", "ADF_CODSU0" ), TamSX3( "ADF_CODSU0" )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "ADF_DESSU0", "QRYTRB", "Descrição", ""                             , TamSX3( "U0_NOME"    )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
                             
oSection2 := TRSection():New( oSection1, "Detalhes", { "QRYTRB" } )
oSection2:SetTotalInLine( .F. )

TRCell():New( oSection2, "ADF_CODIGO", "QRYTRB", "Protocolo" 	, PesqPict( "ADF", "ADF_CODIGO" ), TamSX3( "ADF_CODIGO" )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADE_DATA"  , "QRYTRB", "Abertura"   	, PesqPict( "ADE", "ADE_DATA"   ), TamSX3( "ADE_DATA"   )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADE_HORA"  , "QRYTRB", "Hora"       	, PesqPict( "ADE", "ADE_HORA"   ), TamSX3( "ADE_HORA"   )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADE_DESTIP", "QRYTRB", "Comunicação" 	, ""							 , 20                       ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADE_CODCON", "QRYTRB", "Contato"   	, PesqPict( "ADE", "ADE_CODCON" ), TamSX3( "ADE_CODCON" )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADE_NOMCON", "QRYTRB", "Nome"      	, ""                             , 30                       ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADE_PEDGAR", "QRYTRB", "Pedido GAR"	, PesqPict( "ADE", "ADE_PEDGAR" ), TamSX3( "ADE_PEDGAR" )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADE_CODSB1", "QRYTRB", "Produto"   	, PesqPict( "ADE", "ADE_CODSB1" ), TamSX3( "ADE_CODSB1" )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADE_DESSB1", ""      , "Descrição" 	,                                , 30                       ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADE_ENTIDA", "QRYTRB", "Entidade"  	, PesqPict( "ADE", "ADE_ENTIDA" ), TamSX3( "ADE_ENTIDA" )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADE_DESENT", ""      , "Descrição" 	,                                , 40                       ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADF_ITEM"	 , "QRYTRB", "Item"   	 	, PesqPict( "ADF", "ADF_ITEM"   ), TamSX3( "ADF_ITEM"   )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADF_CODSU9", "QRYTRB", "Ocorrencia"	, PesqPict( "ADF", "ADF_CODSU9" ), TamSX3( "ADF_CODSU9" )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADF_DESSU9", ""      , "Descrição" 	, ""						     , TamSX3( "U9_DESC"    )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADF_CODSUQ", "QRYTRB", "Ação"      	, PesqPict( "ADF", "ADF_CODSUQ" ), TamSX3( "ADF_CODSUQ" )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADF_DESSUQ", ""      , "Descrição" 	, ""						     , TamSX3( "UQ_DESC"    )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADF_CODASU", ""      , "Assunto"   	, ""						     , 10                       ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADF_DESASU", ""      , "Descrição" 	, ""						     , 30                       ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADF_CODSU7", "QRYTRB", "Analista"  	, PesqPict( "ADF", "ADF_CODSU9" ), TamSX3( "ADF_CODSU9" )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADF_DESSU7", ""      , "Nome"      	, ""						     , 30                       ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADF_DATA"	 , "QRYTRB", "Data"   	 	, PesqPict( "ADF", "ADF_DATA"   ), TamSX3( "ADF_DATA"   )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADF_HORA"	 , "QRYTRB", "Hora Inicial"	, PesqPict( "ADF", "ADF_HORA"   ), TamSX3( "ADF_HORA"   )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADF_HORAF" , "QRYTRB", "Hora Final"   , PesqPict( "ADF", "ADF_HORAF"  ), TamSX3( "ADF_HORAF"  )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "Z3_CODAC"	 , ""	  	  , "Grupo/Rede"   , PesqPict( "SZ3", "Z3_CODAC"  ), TamSX3( "Z3_CODAC"  )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "Z3_DESAC"  , ""		  , "Descrição"    , PesqPict( "SZ3", "Z3_DESAC"  ), TamSX3( "Z3_DESAC"  )[1],/*lPixel*/,/*{|| code-block de impressao }*/)

oBreak := TRBreak():New( oSection1, oSection1:Cell( "ADF_CODSU0" ),, .F. )
oBreak:SetPageBreak( .F. )
 
Return( oReport )

/*
---------------------------------------------------------------------------
| Rotina    | PrintReport | Autor | Gustavo Prudente | Data | 22.10.2013  |
|-------------------------------------------------------------------------|
| Descricao | Processa impressao do relatorio de atendimentos por grupo   |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/ 
Static Function PrintReport( oReport, aRetPar, aSelGrp )

Local oSection1 := oReport:Section( 1 )            
Local oSection2 := oReport:Section( 1 ):Section( 1 )
Local cHoraIni	:= ""
Local cHoraFim	:= ""
Local cCodADF	:= ""                                                 
Local cWhereADE := ""
Local cWhereADF := ""
Local cWhereGrp	:= ""
Local cGrupo	:= ""
Local cCodADF	:= ""                              
Local cDesProd	:= ""
Local cDesEnt	:= ""
Local cDesTipo	:= ""
Local cDesAcao	:= ""
Local cFilSU9	:= xFilial( "SU9" )
Local cFilSU5	:= xFilial( "SU5" )
Local cFilSU7	:= xFilial( "SU7" )
Local cFilSU0	:= xFilial( "SU0" )
Local cFilADF	:= xFilial( "ADF" )                            
Local cFilSB1	:= xFilial( "SB1" )
Local cFilSUQ	:= xFilial( "SUQ" )
Local cFilSUL	:= xFilial( "SUL" )

Local nTamItem	:= TamSX3( "ADF_ITEM" )[1]

If Len( aRetPar ) == 0             
	AAdd( aRetPar, dDataBase 	)
	AAdd( aRetPar, dDataBase 	)
	AAdd( aRetPar, "" 			)
	AAdd( aRetPar, "ZZZZZZ"		)
EndIf
                                                               
// Cria string para where de grupos de atendimento na Query
cWhereGrp := ""
For nX := 1 To Len( aSelGrp )
	If aSelGrp[ nX, 1 ]		// Grupo selecionado
		cWhereGrp += "'" + AllTrim( aSelGrp[ nX, 2 ] ) + "',"
	EndIf
Next nX        

If Empty( cWhereGrp )
	cWhereGrp := RetGrupo()
Else
	cWhereGrp := SubStr( cWhereGrp, 1, Len( cWhereGrp ) - 1 )
EndIf	

cWhereADE := "     ADE.ADE_DATA BETWEEN '" + DtoS( aRetPar[ 1 ] ) + "' AND '" + DtoS( aRetPar[ 2 ] ) + "' "
cWhereADE += " AND ADE.ADE_CODIGO = ADF.ADF_CODIGO "
If At( ",", AllTrim( cWhereGrp ) ) > 0
	cWhereADE += " AND ADE.ADE_GRUPO IN ( " + cWhereGrp + " ) "
Else
	cWhereADE += " AND ADE.ADE_GRUPO = " + cWhereGrp + " "
EndIf
cWhereADE += " AND ADE.D_E_L_E_T_ = ' ' "
cWhereADE := "%" + cWhereADE + "%"

cWhereADF := "     ADF.ADF_CODSU7 BETWEEN '" + AllTrim( aRetPar[ 3 ] ) + "' AND '" + AllTrim( aRetPar[ 4 ] ) + "' "   
cWhereADF += " AND ADF.D_E_L_E_T_ = ' ' "
cWhereADF := "%" + cWhereADF + "%"

BeginSql Alias "TOTREC"

	SELECT COUNT( ADF.R_E_C_N_O_ ) AS TOTAL
	FROM  %Table:ADF% ADF
 	INNER JOIN %Table:ADE% ADE ON
 		ADE.ADE_FILIAL = %xFilial:ADE% AND
		%Exp:cWhereADE% 
    WHERE
    	ADF.ADF_FILIAL = %xFilial:ADF% AND
    	%Exp:cWhereADF% 

EndSql

nTotRec := TOTREC->TOTAL
         
TOTREC->( dbCloseArea() )

BeginSql Alias "QRYTRB"
     
	Column ADE_DATA as Date
	Column ADF_DATA as Date

	SELECT 	ADF.ADF_CODSU0	, ADF.ADF_CODIGO, ADE.ADE_DATA	, ADE.ADE_HORA	, ADE.ADE_CODCON, ADE.ADE_PEDGAR, 
			ADE.ADE_CODSB1	, ADE.ADE_ENTIDA, ADE.ADE_CHAVE	, ADE.ADE_TIPO  , ADF.ADF_ITEM	, ADF.ADF_CODSU9, 
			ADF.ADF_CODSU7  , ADF.ADF_DATA	, ADF.ADF_HORA	, ADF.ADF_HORAF , ADF.ADF_CODSUQ,
	       	SU5.U5_CONTAT	, SU7.U7_NOME   , SU9.U9_DESC 	, SU9.U9_ASSUNTO
	FROM  %Table:ADF% ADF
 	INNER JOIN %Table:ADE% ADE ON
 		ADE.ADE_FILIAL = %xFilial:ADE% AND
		%Exp:cWhereADE% 
	INNER JOIN %Table:SU5% SU5 ON
		SU5.U5_FILIAL = %xFilial:SU5% AND
		SU5.U5_CODCONT = ADE.ADE_CODCON AND
		SU5.%notDel%
	INNER JOIN %Table:SU7% SU7 ON
		SU7.U7_FILIAL = %xFilial:SU7% AND
		SU7.U7_COD = ADF.ADF_CODSU7 AND
		SU7.%notDel%                              
	INNER JOIN %Table:SU9% SU9 ON
		SU9.U9_FILIAL = %xFilial:SU9% AND
		SU9.U9_CODIGO = ADF.ADF_CODSU9 AND
		SU9.%notDel%
    WHERE
    	ADF.ADF_FILIAL = %xFilial:ADF% AND
    	%Exp:cWhereADF% 
 	ORDER BY ADF.ADF_CODSU0, ADF.ADF_CODIGO, ADF.ADF_ITEM
 	
EndSql

oSection1:SetHeaderSection( .T. )
oSection1:SetHeaderBreak( .T. )
oSection1:SetHeaderPage( .F. )

oSection1:Init()

oReport:SetMeter( nTotRec )

// Atualiza tabela de assuntos (T1) para consulta
RetAssunto( 1 )

ADF->( DbSetOrder( 1 ) )
SB1->( DbSetOrder( 1 ) )
SUQ->( DbSetOrder( 1 ) )
SUL->( DbSetOrder( 1 ) )

Do While QRYTRB->( ! EoF() )
        
	If oReport:Cancel()
		Exit
	EndIf

   	// Grupo atualmente posicionado para impressao dos protocolos 
	cGrupo := QRYTRB->ADF_CODSU0

 	oSection1:Cell( "ADF_DESSU0" ):SetValue( Posicione( "SU0", 1, cFilSU0 + cGrupo, "U0_NOME" ) )
	oSection1:PrintLine()
                    
	lCabSection2 := .T.
	oSection2:SetHeaderSection( .T. )
	
	oSection2:Init()
                                         
	// Percorre os itens do grupo 
	Do While QRYTRB->( ! EoF() ) .And. QRYTRB->ADF_CODSU0 == cGrupo

		If oReport:Cancel()
			Exit
		EndIf
                                    
      	// Protocolo atualmente posicionado
      	cCodADF := QRYTRB->ADF_CODIGO             

      	// Percorre os itens do protocolo atual
      	Do While QRYTRB->( ! EoF() ) .And. QRYTRB->ADF_CODIGO == cCodADF
      	
			If oReport:Cancel()
				Exit
			EndIf

      		oReport:IncMeter()
      		
      		// Inicializa descricoes
      		cDesProd := ""
      		cDesEnt  := ""
      		cDesAcao := ""
      		
      		// Pesquisa descricao do produto, descricao da ocorrência, descricao da ocorrencia e ação do item do atendimento
			SUL->( DbSeek( cFilSUL + QRYTRB->ADE_TIPO   ) )
			
      		If ! Empty( QRYTRB->ADE_CODSB1 )
	      		SB1->( DbSeek( cFilSB1 + QRYTRB->ADE_CODSB1 ) )
	      		cDesProd := SB1->B1_DESC
	      	EndIf
	      	
	      	If ! Empty( QRYTRB->ADF_CODSUQ )
	      		SUQ->( DbSeek( cFilSUQ + QRYTRB->ADF_CODSUQ ) ) 
	      		cDesAcao := SUQ->UQ_DESC
	      	EndIf
	      		
			If ! Empty( QRYTRB->ADE_ENTIDA )
				cDesEnt := RetDesEnt( QRYTRB->ADE_ENTIDA, QRYTRB->ADE_CHAVE )
			EndIf

		 	// Impressao de contato, ocorrencia, assunto e analista      
			If Empty( cDesEnt )                                   
				oSection2:Cell( "ADE_ENTIDA" ):SetValue( "" )
			Else
				oSection2:Cell( "ADE_DESENT" ):SetValue( cDesEnt )
				oSection2:Cell( "ADE_ENTIDA" ):SetValue( QRYTRB->ADE_ENTIDA )
			EndIf	
			
		 	oSection2:Cell( "ADE_DESTIP" ):SetValue( SUL->UL_DESC		)
		 	oSection2:Cell( "ADE_DESSB1" ):SetValue( cDesProd		    )
			oSection2:Cell( "ADE_NOMCON" ):SetValue( QRYTRB->U5_CONTAT  )
			oSection2:Cell( "ADF_DESSU9" ):SetValue( QRYTRB->U9_DESC    )
			oSection2:Cell( "ADF_CODASU" ):SetValue( QRYTRB->U9_ASSUNTO )
			oSection2:Cell( "ADF_DESASU" ):SetValue( RetAssunto( 2, QRYTRB->U9_ASSUNTO ) )
		 	oSection2:Cell( "ADF_DESSU7" ):SetValue( QRYTRB->U7_NOME    )
			oSection2:Cell( "ADF_DESSUQ" ):SetValue( cDesAcao			)
			
			If QRYTRB->ADE_ENTIDA == "SZ3"	 
				oSection2:Cell( "Z3_CODAC" ):SetValue( POSICIONE("SZ3",1,xFilial("SZ3")+QRYTRB->ADE_CHAVE,"Z3_CODAC") )
			 	oSection2:Cell( "Z3_DESAC" ):SetValue( POSICIONE("SZ3",1,xFilial("SZ3")+QRYTRB->ADE_CHAVE,"Z3_DESAC") )
			Else
				oSection2:Cell( "Z3_CODAC" ):SetValue( "" )
			 	oSection2:Cell( "Z3_DESAC" ):SetValue( "" )
			EndIf
			
			// Impressao da linha do atendimento
			oSection2:PrintLine()
                            
			If lCabSection2
				oSection2:SetHeaderSection( .F. )
				lCabSection2 := .F.
			EndIf	
		 
			QRYTRB->( dbSkip() )

		EndDo

		oReport:SkipLine()

	EndDo
	
	oSection2:Finish()
	
EndDo

oSection1:Finish()

QRYTRB->( dbCloseArea() )

Return


/*
---------------------------------------------------------------------------
| Rotina    | PergR003    | Autor | Gustavo Prudente | Data | 22.10.2013  |
|-------------------------------------------------------------------------|
| Descricao | Cria grupo de perguntas para o relatorio                    |
|-------------------------------------------------------------------------|
| Parametros| EXPA1 - Grupo de perguntas do relatorio preenchido          |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/ 
Static Function PergR003( aRetPar )

Local aPergs := {}
Local lRet	 := .T.

aAdd( aPergs, { 1, "De"          , CtoD( Space( 8 ) ), "@D", ".T.",, ".T.", 8, .T. } )
aAdd( aPergs, { 1, "Ate"         , CtoD( Space( 8 ) ), "@D", ".T.",, ".T.", 8, .T. } )
aAdd( aPergs, { 1, "Do Analista" , Space( 6 ), "@!", ".T.", "SU7", ".T.", 6, .F. } )
aAdd( aPergs, { 1, "Ate Analista", "ZZZZZZ"  , "@!", ".T.", "SU7", ".T.", 6, .F. } )

lRet := ParamBox( aPergs,"@Atendimentos por Grupo", @aRetPar )

Return lRet 


/*
---------------------------------------------------------------------------
| Rotina    | SelGrupos   | Autor | Gustavo Prudente | Data | 22.10.2013  |
|-------------------------------------------------------------------------|
| Descricao | Cria grupo de perguntas para o relatorio                    |
|-------------------------------------------------------------------------|
| Parametros| EXPA1 - Array com os grupos de atendimento do operador      |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/ 
Static Function SelGrupos( aSelGrp )

Local oDlgGrp      
Local oListGrp
                                    
Local oBtn1
Local oBtn2

Local oPanelList
Local oPanelBtn

Local oOk := LoadBitmap( GetResources(), "LBOK" )
Local oNo := LoadBitmap( GetResources(), "LBNO" )

Local lRet		:= .F.
Local cFilAG9	:= xFilial( "AG9" )
Local cFilSU0	:= xFilial( "SU0" )
Local cCodUser	:= ""

// Seleciona grupos de atendimento do usuario logado no Service Desk
If Len( aSelGrp ) == 1 .And. Empty( aSelGrp[ 1, 2 ] ) .And. Empty( aSelGrp[ 1, 3 ] )

	cCodUser := AllTrim( TkOperador() )                     
	aSelGrp  := {}

	SU0->( dbSetOrder( 1 ) )	        
	AG9->( dbSetOrder( 1 ) )
	AG9->( MsSeek( cFilAG9 + cCodUser ) )

	// Monta array com os grupos do usuario logado, para permitir seleção de grupos
	Do While AG9->( ! EoF() .And. AG9_FILIAL + AG9_CODSU7 == cFilAG9 + cCodUser )
		SU0->( MsSeek( cFilSU0 + AG9->AG9_CODSU0 ) )
		AAdd( aSelGrp, { .T., AG9->AG9_CODSU0, SubStr( SU0->U0_NOME, 1, 40 ) } )
		AG9->( dbSkip() )
	EndDo

EndIf

oDlgGrp := MSDialog():New( 180, 180, 400, 600,,,,,, CLR_BLACK, CLR_WHITE,,, .T. )  // Ativa diálogo centralizado
             
oPanelBtn		:= tPanel():New( 01, 01, "", oDlgGrp,,.T.,,,, 1, 16, .F., .F. )
oPanelBtn:Align := CONTROL_ALIGN_BOTTOM

@ 005, 005 LISTBOX oListGrp FIELDS HEADER " ", "Grupo", "Descrição", ;
	SIZE 100, 100 OF oDlgGrp PIXEL ON dblClick( aSelGrp[ oListGrp:nAt, 1 ] := ! aSelGrp[ oListGrp:nAt, 1 ] )
	                                      
oListGrp:SetArray( aSelGrp )
oListGrp:bLine := { || 	{ Iif( 	aSelGrp[ oListGrp:nAt, 1 ], oOk, oNo ) , ;
  								aSelGrp[ oListGrp:nAt, 2 ] , ;
								aSelGrp[ oListGrp:nAt, 3 ] } }

oListGrp:Align := CONTROL_ALIGN_ALLCLIENT

oBtn1 := TButton():New( 003, 143, "&Ok"		 , oPanelBtn, { || Iif( ValGrp( aSelGrp ), ( lRet := .T., oDlgGrp:End() ), .T. ) }, 032, 011,,,, .T.,, "",,,, .F. )
oBtn1 := TButton():New( 003, 178, "&Cancelar", oPanelBtn, { || lRet := .F., oDlgGrp:End() }, 032, 011,,,, .T.,, "",,,, .F. )

oDlgGrp:Activate( ,,, .T. )

Return lRet

/*
---------------------------------------------------------------------------
| Rotina    | ValGrp      | Autor | Gustavo Prudente | Data | 22.10.2013  |
|-------------------------------------------------------------------------|
| Descricao | Valida selecao de grupos de atendimento                     |
|-------------------------------------------------------------------------|
| Parametros| EXPA1 - Array com os grupos de atendimento do operador      |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/ 
Static Function ValGrp( aSelGrp )

Local lRet 	:= .F.
Local nX	:= 0              
            
For nX := 1 To Len( aSelGrp )
	If aSelGrp[ nX, 1 ]
		lRet := .T.
		Exit
	EndIf	
Next nX

If ! lRet
	Aviso( "@Atendimentos por Grupo", "Selecione um grupo de atendimento para continuar.", { "Ok" }, 1 )
EndIf

Return( lRet )


/*
---------------------------------------------------------------------------
| Rotina    | RetAssunto  | Autor | Gustavo Prudente | Data | 22.10.2013  |
|-------------------------------------------------------------------------|
| Descricao | Cria/Consulta descricao dos assuntos da tabela T1           |
|-------------------------------------------------------------------------|
| Parametros| EXPN1 - 1 - Cria vetor com os assuntos da tabela T1         |
|           |         2 - Consulta descricao do assunto passado como      |
|           |             parametro.                                      |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function RetAssunto( nTipo, cAssunto )

Static aTabAssunto
                                                         
Local nPos 		:= 0
Local cRet 		:= ""   
Local cFilSX5 	:= ""
          
Default nTipo	 := 2
Default cAssunto := ""

If nTipo == 1
                         
	aTabAssunto := {}
	cFilSX5		:= xFilial( "SX5" )
             
	SX5->( dbSetOrder( 1 ) )
	SX5->( dbSeek( cFilSX5 + "T1" ) )
                      
	Do While SX5->( ! EoF() ) .And. SX5->X5_FILIAL == cFilSX5 .And. SX5->X5_TABELA == "T1"
		AAdd( aTabAssunto, { AllTrim( SX5->X5_CHAVE ), SX5->X5_DESCRI } ) 
		SX5->( dbSkip() )                
	EndDo

Else                                                     

	If !Empty( cAssunto )
		cAssunto := AllTrim( cAssunto )
		nPos := AScan( aTabAssunto, { |x| AllTrim( x[1] ) == cAssunto } )
		If nPos > 0
			cRet := SubStr( aTabAssunto[ nPos, 2 ], 1, 40 )
		EndIf
	EndIf

EndIf

Return( cRet )


/*
-------------------------------------------------------------------------------
| Rotina     | RetGrupo       | Autor | Gustavo Prudente | Data | 24.10.2013  |
|-----------------------------------------------------------------------------|
| Descricao  | Retorna o grupo do usuario logado no Call Center               |
|-----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                            |
-------------------------------------------------------------------------------
*/
Static Function RetGrupo()

Local cCodUser	:= AllTrim( TkOperador() )
Local cGrupo	:= ""                      
Local cFilAG9	:= xFilial( "AG9" )

Default lTodos := .F.
             
SU7->( DbSetOrder( 1 ) )
SU7->( DbSeek( xFilial() + cCodUser ) )

cGrupo := SU7->U7_POSTO

Return( cGrupo )
      

/*
-------------------------------------------------------------------------------
| Rotina     | RetDesEnt      | Autor | Gustavo Prudente | Data | 24.10.2013  |
|-----------------------------------------------------------------------------|
| Descricao  | Retorna a descricao da entidade do atendimento                 |
|-----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                            |
-------------------------------------------------------------------------------
*/
Static Function RetDesEnt( cAlias, cChave )

Local cRet	:= ""
Local cArea := Alias()
                                
cRet := AllTrim( TKEntidade( cAlias, cChave, 1 ) )
			
If Empty( cRet )

	DbSelectArea( cAlias )
	DbSetOrder( 1 )
	
	If DbSeek( xFilial( cAlias ) + cChave )
		
		If cAlias == "SU5" 
			cRet := AllTrim( SU5->U5_CONTAT ) 

		ElseIf cAlias == "SZ3"
			cRet := AllTrim( SZ3->Z3_DESENT )

		EndIf	
	
	EndIf
	
EndIf		

DbSelectArea( cArea )

Return( cRet )