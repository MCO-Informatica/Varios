#INCLUDE "protheus.ch"

/*
---------------------------------------------------------------------------
| Rotina    | RTMK002     | Autor | Gustavo Prudente | Data | 10.06.2013  |
|-------------------------------------------------------------------------|
| Descricao | Relacao de Atendimentos por Grupo e Analista.               |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
User Function RTMK002()

Local oReport
Local aRetPar 	:= {}
Local cCodUser	:= AllTrim( TkOperador() )

// Verifica se tem operador no Service-Desk
AG9->( dbSetOrder( 1 ) )
AG9->( dbSeek( xFilial( "AG9" ) + cCodUser ) )

If AG9->( ! EoF() ) .And. AG9->AG9_FILIAL == xFilial( "AG9" ) .And. AG9->AG9_CODSU7 == cCodUser
	oReport := ReportDef( @aRetPar )
	oReport:printDialog()
Else
	Help( " ",, "OPERADOR" )
EndIf

Return
         
/*
---------------------------------------------------------------------------
| Rotina    | reportDef   | Autor | Gustavo Prudente | Data | 10.06.2013  |
|-------------------------------------------------------------------------|
| Descricao | Definicao de secao do relatorio de atendimentos             |
|-------------------------------------------------------------------------|
| Parametros| EXPC1 - Grupo de perguntas                                  |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function ReportDef( aRetPar )

Local oReport
Local oSection1
Local oSection2
Local cTitulo 	:= "@Atendimentos por Grupo e Analista"
Local aRetPar	:= {}
Local aSelGrp	:= { { .F., Space( 02 ), Space( 40 ) } }
 
oReport := TReport():New( 'RTMK002', cTitulo, 	{ || Iif( u_RTmkSelGrp( @aSelGrp, cTitulo ), PergR002( @aRetPar ), .F. ) }, ;
												{ |oReport| PrintReport( oReport, @aRetPar, @aSelGrp ) }, ;
												"Este relatório irá imprimir a relação de atendimentos." )

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
TRCell():New( oSection2, "CALCTME"   , "QRYTRB", "TME"        	, ""                             , TamSX3( "ADE_HORA"   )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADE_CODCON", "QRYTRB", "Contato"   	, PesqPict( "ADE", "ADE_CODCON" ), TamSX3( "ADE_CODCON" )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADE_NOMCON", "QRYTRB", "Nome"      	, ""                             , 30                       ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADE_EMAIL2" , "QRYTRB", "E-mail"    	, PesqPict( "ADE", "ADE_EMAIL2"  ), TamSX3( "ADE_EMAIL2"  )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADE_TO"    , "QRYTRB", "Destinatario"	, PesqPict( "ADE", "ADE_TO"     ), TamSX3( "ADE_TO"     )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADE_PEDGAR", "QRYTRB", "Pedido GAR"	, PesqPict( "ADE", "ADE_PEDGAR" ), TamSX3( "ADE_PEDGAR" )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADF_ITEM"	 , "QRYTRB", "Item"   	 	, PesqPict( "ADF", "ADF_ITEM"   ), TamSX3( "ADF_ITEM"   )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADF_CODSU9", "QRYTRB", "Ocorrencia"	, PesqPict( "ADF", "ADF_CODSU9" ), TamSX3( "ADF_CODSU9" )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADF_DESSU9", ""      , "Descrição" 	, ""						     , TamSX3( "U9_DESC"    )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADF_CODASU", ""      , "Assunto"   	, ""						     , 10                       ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADF_DESASU", ""      , "Descrição" 	, ""						     , 30                       ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADF_CODSU7", "QRYTRB", "Analista"  	, PesqPict( "ADF", "ADF_CODSU9" ), TamSX3( "ADF_CODSU9" )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADF_DESSU7", ""      , "Nome"      	, ""						     , 30                       ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADF_DATA"	 , "QRYTRB", "Data"   	 	, PesqPict( "ADF", "ADF_DATA"   ), TamSX3( "ADF_DATA"   )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADF_HORA"	 , "QRYTRB", "Hora Inicial"	, PesqPict( "ADF", "ADF_HORA"   ), TamSX3( "ADF_HORA"   )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADF_HORAF" , "QRYTRB", "Hora Final"   , PesqPict( "ADF", "ADF_HORAF"  ), TamSX3( "ADF_HORAF"  )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "CALCTMA" 	 , ""      , "TMA"    	 	, ""                             , TamSX3( "ADF_HORA"   )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "TOTTMA"  	 , ""      , "Total TMA"	, ""                             , TamSX3( "ADF_HORA"   )[1],/*lPixel*/,/*{|| code-block de impressao }*/)

oBreak := TRBreak():New( oSection1, oSection1:Cell( "ADF_CODSU0" ),, .F. )
oBreak:SetPageBreak( .F. )
 
Return( oReport )

/*
---------------------------------------------------------------------------
| Rotina    | PrintReport | Autor | Gustavo Prudente | Data | 10.06.2013  |
|-------------------------------------------------------------------------|
| Descricao | Processa impressao do relatorio de atendimentos             |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/ 
Static Function PrintReport( oReport, aRetPar, aSelGrp )

Local oSection1 := oReport:Section( 1 )            
Local oSection2 := oReport:Section( 1 ):Section( 1 )
Local cTMA		:= ""            
Local cHoraIni	:= ""
Local cHoraFim	:= ""
Local cCodADF	:= ""                                                 
Local cWhereADE := ""
Local cWhereADF := ""
Local cWhereGrp	:= ""
Local cGrupo	:= ""
Local cCodADF	:= ""                              
Local cMaxItem	:= ""
Local cTME		:= ""
Local cFilSU9	:= xFilial( "SU9" )
Local cFilSU5	:= xFilial( "SU5" )
Local cFilSU7	:= xFilial( "SU7" )
Local cFilSU0	:= xFilial( "SU0" )
Local cFilADF	:= xFilial( "ADF" )
Local nTamItem	:= TamSX3( "ADF_ITEM" )[1]
Local aTotTMA	:= {}
              
If Len( aRetPar ) == 0             
	AAdd( aRetPar, dDataBase 	)
	AAdd( aRetPar, dDataBase 	)
	AAdd( aRetPar, "" 			)
	AAdd( aRetPar, "ZZZZZZ"		)
EndIf

// Cria string para where de grupos de atendimento na Query
cWhereGrp := ""
For nX := 1 To Len( aSelGrp )
	If aSelGrp[ nX, 1 ] 		// Grupo selecionado
		cWhereGrp += "'" + AllTrim( aSelGrp[ nX, 2 ] ) + "',"
	EndIf
Next nX        

If Empty( cWhereGrp )
	cWhereGrp := u_RTmkRetGrp()
Else
	cWhereGrp := SubStr( cWhereGrp, 1, Len( cWhereGrp ) - 1 )
EndIf	

cWhereADE := "     ADE.ADE_DATA BETWEEN '" + DtoS( aRetPar[ 1 ] ) + "' AND '" + DtoS( aRetPar[ 2 ] ) + "' "
cWhereADE += " AND ADE.ADE_CODIGO = ADF.ADF_CODIGO "
cWhereADE += " AND ADE.D_E_L_E_T_ = ' ' "                     
cWhereADE := "%" + cWhereADE + "%"
                                  
If At( ",", AllTrim( cWhereGrp ) ) > 0
	cWhereADF := "     ADF.ADF_CODSU0 IN ( " + cWhereGrp + " ) "
Else
	cWhereADF := "     ADF.ADF_CODSU0 = " + cWhereGrp + " "
EndIf

cWhereADF += " AND ADF.ADF_CODSU7 BETWEEN '" + AllTrim( aRetPar[ 3 ] ) + "' AND '" + AllTrim( aRetPar[ 4 ] ) + "' "   
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

	SELECT 	ADF.ADF_CODSU0, ADF.ADF_CODIGO, ADE.ADE_DATA  , ADE.ADE_HORA  , ADE.ADE_CODCON, 
			ADE.ADE_EMAIL2 , ADE.ADE_TO    , ADE.ADE_PEDGAR, ADF.ADF_ITEM  ,
	       	ADF.ADF_CODSU9, ADF.ADF_CODSU7, ADF.ADF_DATA  , ADF.ADF_HORA  , ADF.ADF_HORAF ,
	       	SU5.U5_CONTAT , SU7.U7_NOME   , SU9.U9_DESC   , SU9.U9_ASSUNTO
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
u_RTmkRetAss( 1 )

ADF->( dbSetOrder( 1 ) )

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
                                    
		aTotTMA	:= {}

      	// Protocolo atualmente posicionado
      	cCodADF := QRYTRB->ADF_CODIGO             
      	cTME	:= CalcTME( QRYTRB->ADF_CODIGO, QRYTRB->ADE_DATA, QRYTRB->ADE_HORA, nTamItem, cFilADF )

		// Calculo e impressao do TME
	 	oSection2:Cell( "CALCTME" ):SetValue( cTME )

  		// Retorna item maximo do protocolo atualmente posicionado
		cMaxItem := RetMaxItem( QRYTRB->ADF_CODIGO )         

      	// Percorre os itens do protocolo atual
      	Do While QRYTRB->( ! EoF() ) .And. QRYTRB->ADF_CODIGO == cCodADF
      	
			If oReport:Cancel()
				Exit
			EndIf

      		oReport:IncMeter()
		                     
		 	// Impressao de contato, ocorrencia, assunto e analista
			oSection2:Cell( "ADE_NOMCON" ):SetValue( QRYTRB->U5_CONTAT  )
			oSection2:Cell( "ADF_DESSU9" ):SetValue( QRYTRB->U9_DESC    )  
			oSection2:Cell( "ADF_CODASU" ):SetValue( QRYTRB->U9_ASSUNTO )
			oSection2:Cell( "ADF_DESASU" ):SetValue( u_RTmkRetAss( 2, QRYTRB->U9_ASSUNTO ) )		
		 	oSection2:Cell( "ADF_DESSU7" ):SetValue( QRYTRB->U7_NOME    )

			// Calculo e impressao do TMA
			cHoraIni := Iif( At( ":", QRYTRB->ADF_HORA  ) == 0, "00:00:00", AllTrim( QRYTRB->ADF_HORA  ) + ":00" )
			cHoraFim := Iif( At( ":", QRYTRB->ADF_HORAF ) == 0, "00:00:00", AllTrim( QRYTRB->ADF_HORAF ) + ":00" )

			cTMA := SubStr( ElapTime( cHoraIni, cHoraFim ), 1, 5 )

			AAdd( aTotTMA, { Val( SubStr( cTMA, 1, 2 ) ), Val( SubStr( cTMA, 4, 2 ) ) } )
                                 
		 	oSection2:Cell( "CALCTMA" ):SetValue( cTMA )         
		 	     
		 	// Imprime o total de TMA somente no ultimo item                                                      
		 	If QRYTRB->ADF_ITEM == cMaxItem
			 	oSection2:Cell( "TOTTMA" ):SetValue( TotalTMA( aTotTma ) )
			EndIf                                 

			// Impressao da linha do atendimento
			oSection2:PrintLine()
                            
			oSection2:Cell( "CALCTME" ):SetValue( "" )
			oSection2:Cell( "TOTTMA"  ):SetValue( "" )

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
| Rotina    | CalcTME     | Autor | Gustavo Prudente | Data | 20.06.2013  |
|-------------------------------------------------------------------------|
| Descricao | Calcula tempo medio de espera do atendimento                |
|-------------------------------------------------------------------------|
| Parametros| EXPC1 - Numero do Protocolo                                 |
|           | EXPC2 - Hora da criacao do atendimento                      |
|           | EXPD3 - Data de criacao do atendimento                      |
|           | EXPN4 - Tamanho do campo item do atendimento                |
|           | EXPC5 - Filial dos itens de atendimento                     |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/ 
Static Function CalcTME( cProtocolo, dDataADE, cHoraADE, nTamItem, cFilADF )

Local cRet    	:= ""
Local cHoraIni	:= ""
Local cHoraFim	:= ""
Local nDias		:= 0        
Local nX		:= 0
Local nHoraDias	:= 0

// Posiciona no 2o. item da interacao do chamado, pois o 1o. eh da geracao automatica
If ADF->( DbSeek( cFilADF + cProtocolo + StrZero( 2, nTamItem ) ) )
                                                         
	// Realiza o calculo da hora da abertura do chamado e a hora de inicio do atendimento do item
	cHoraIni := Iif( At( ":", cHoraADE      ) == 0, "00:00:00", AllTrim( cHoraADE )      + ":00" )
	cHoraFim := Iif( At( ":", ADF->ADF_HORA ) == 0, "00:00:00", AllTrim( ADF->ADF_HORA ) + ":00" )

	cRet := SubStr( ElapTime( cHoraIni, cHoraFim ), 1, 5 )

	// Realiza tratamento para conversao de dias em horas
	nDias := ( ADF->ADF_DATA - dDataADE )

	If nDias > 0
		For nX := 1 To nDias
			nHoraDias += 24
		Next nX
	EndIf
	
	If nHoraDias > 0
		nHoras := Val( SubStr( cRet, 1, 2 )	)
		nTotHoras := nHoras + nHoraDias
		cRet := AllTrim( Str( nTotHoras ) ) + SubStr( cRet, 3, Len( cRet ) )
	EndIf

EndIf	
          
Return( cRet )

/*
---------------------------------------------------------------------------
| Rotina    | PergR002    | Autor | Gustavo Prudente | Data | 21.06.2013  |
|-------------------------------------------------------------------------|
| Descricao | Cria grupo de perguntas para o relatorio                    |
|-------------------------------------------------------------------------|
| Parametros| EXPA1 - Grupo de perguntas do relatorio preenchido          |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/ 
Static Function PergR002( aRetPar )

Local aPergs 	:= {}
Local lRet	 	:= .T.

aAdd( aPergs, { 1, "De"          , dDataBase, "@D", ".T.",, ".T.", 50, .T. } )
aAdd( aPergs, { 1, "Ate"         , dDataBase, "@D", ".T.",, ".T.", 50, .T. } )
aAdd( aPergs, { 1, "Do Analista" , Space( 6 ), "@!", ".T.", "SU7", ".T.", 6, .F. } )
aAdd( aPergs, { 1, "Ate Analista", "ZZZZZZ"  , "@!", ".T.", "SU7", ".T.", 6, .F. } )

lRet := ParamBox( aPergs,"@Relacao de Atendimentos", @aRetPar )

Return lRet 



/*
---------------------------------------------------------------------------
| Rotina    | RetMaxItem  | Autor | Gustavo Prudente | Data | 10.07.2013  |
|-------------------------------------------------------------------------|
| Descricao | Retorna o ultimo item do atendimento                        |
|-------------------------------------------------------------------------|
| Parametros| EXPC1 - Codigo do atendimento                               |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/ 
Static Function RetMaxItem( cCodADF )

Local cRet := ""

BeginSql Alias "MAXITEM"

	SELECT MAX( ADF.ADF_ITEM ) AS ITEM
	FROM  %Table:ADF% ADF
    WHERE
    	ADF.ADF_FILIAL = %xFilial:ADF% AND          
    	ADF.ADF_CODIGO = %exp:cCodADF% AND
    	ADF.%notDel%

EndSql
                      
cRet := MAXITEM->ITEM

MAXITEM->( dbCloseArea() )

dbSelectArea( "QRYTRB" )

Return( cRet )

      
/*
---------------------------------------------------------------------------
| Rotina    | TotalTMA    | Autor | Gustavo Prudente | Data | 10.07.2013  |
|-------------------------------------------------------------------------|
| Descricao | Retorna o total de TMA calculado a partir do TMA dos itens  |
|-------------------------------------------------------------------------|
| Parametros| EXPA1 - Vetor com o total de TMA calculado por item         |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function TotalTMA( aTotTMA )

Local nX       := 0
Local nTotHora := 0
Local nTotMin  := 0
Local cRet     := ""

// Se tem somente uma linha de item e nao tem intervalo de tempo entre hora final e inicial, total de TMA é 00:00
If Len( aTotTMA ) == 1 .And. aTotTMA[ 1, 2 ] == 0 .And. aTotTMA[ 1, 1 ] == 0

	cRet := "00:00"

Else

	For nX := 1 To Len( aTotTMA )
	         
		nTotHora += aTotTMA[ nX, 1 ]
		
		If ( nTotMin + aTotTMA[ nX, 2 ] ) >= 60
			nTotHora += 1
			nTotMin  := 0
		Else
			nTotMin += aTotTMA[ nX, 2 ]
		EndIf
	
	Next nX                   
	
	cTotHora := AllTrim( StrZero( nTotHora, Iif( nTotHora > 99, 3, 2 ) ) )
	cTotMin  := AllTrim( StrZero( nTotMin,  2 ) )
	
	cRet	 := cTotHora + ":" + cTotMin

EndIf

Return( cRet )