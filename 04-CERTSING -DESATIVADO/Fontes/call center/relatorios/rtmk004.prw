#include "protheus.ch"

/*
---------------------------------------------------------------------------
| Rotina    | RTMK004     | Autor | Gustavo Prudente | Data | 31.03.2014  |
|-------------------------------------------------------------------------|
| Descricao | Imprime a relacao de Atendimentos Com Intera��o             |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
User Function RTMK004()

Local oReport

oReport := ReportDef()
oReport:printDialog()
	
Return


/*
---------------------------------------------------------------------------
| Rotina    | reportDef   | Autor | Gustavo Prudente | Data | 31.03.2014  |
|-------------------------------------------------------------------------|
| Descricao | Definicao de secao da relacao de atendimentos com interacao |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function ReportDef()

Local oReport
Local oSection1
Local oSection2
Local cTitulo		:= "@Atendimentos Com Intera��o"
Local aRetPar		:= {}
Local aSelGrp		:= { { .T., Space( 02 ), Space( 40 ) } }
 
oReport := TReport():New( 'RTMK004', cTitulo,	{ || Iif( u_RTmkSelGrp( @aSelGrp, cTitulo ) ,;
										PergR004( @aRetPar, cTitulo ), .F. ) } ,;
										{ |oReport| PrintReport( oReport, @aRetPar, @aSelGrp ) 		}, ;
										"Este relat�rio ir� imprimir atendimentos com intera��o." )

oReport:SetLandScape()
oReport:SetTotalInLine( .F. )
oReport:ShowHeader()
 
oSection1 := TRSection():New( oReport, "Grupo", { "QRYTRB" } )
oSection1:SetTotalInLine( .F. )

TRCell():New( oSection1, "ADF_CODSU0", "QRYTRB", "Grupo"    , PesqPict( "ADF", "ADF_CODSU0" ), TamSX3( "ADF_CODSU0" )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "ADF_DESSU0", "QRYTRB", "Descri��o", ""                             , TamSX3( "U0_NOME"    )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
                             
oSection2 := TRSection():New( oSection1, "Detalhes", { "QRYTRB" } )
oSection2:SetTotalInLine( .F. )

TRCell():New( oSection2, "ADF_CODIGO", "QRYTRB", 	"Protocolo" 	,	PesqPict( "ADF", "ADF_CODIGO" ), TamSX3( "ADF_CODIGO" )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADF_CODSU9", "QRYTRB", 	"Ocorrencia"	,	PesqPict( "ADF", "ADF_CODSU9" ), TamSX3( "ADF_CODSU9" )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "U9_DESC"	, "QRYTRB", 	"Descri��o" 	,	"", TamSX3( "U9_DESC" )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADF_CODSUQ", "QRYTRB", 	"A��o"      	,	PesqPict( "ADF", "ADF_CODSUQ" ), TamSX3( "ADF_CODSUQ" )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "UQ_DESC"	, "QRYTRB", 	"Descri��o" 	,	"", TamSX3( "UQ_DESC" )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADE_ASSUNT", "QRYTRB", 	"Assunto"   	,	"", 10,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADE_DESASS", "QRYTRB", 	"Descri��o" 	,	"", 40,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADF_CODSU7", "QRYTRB", 	"Analista"  	,	PesqPict( "ADF", "ADF_CODSU9" ), TamSX3( "ADF_CODSU9" )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "U7_NOME"	, "QRYTRB", 	"Descri��o" 	,	"", 40,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADF_DATA"	, "QRYTRB", 	"Encerramento",	"@D"	, 10, /*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "DATATRF"	, "",		"Dt. Transf." ,	"@D", 8, /*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "HORATRF"	, "",		"Hr. Transf." , 	"@!", 5, /*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "GRPTRF"	, ""	,		"Grupo Origem",	PesqPict( "ADF", "ADF_CODSU0" ), TamSX3( "ADF_CODSU0" )[ 1 ], /*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADE_STATUS", "QRYTRB", 	"Status"    	,	""  , 15,/*lPixel*/,/*{|| code-block de impressao }*/)

oBreak := TRBreak():New( oSection1, oSection1:Cell( "ADF_CODSU0" ),, .F. )
oBreak:SetPageBreak( .F. )

Return( oReport )
         
/*
---------------------------------------------------------------------------
| Rotina    | PrintReport | Autor | Gustavo Prudente | Data | 31.03.2014  |
|-------------------------------------------------------------------------|
| Descricao | Processa impressao do relatorio de atendimentos por grupo   |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/ 
Static Function PrintReport( oReport, aRetPar, aSelGrp )

Local oSection1	:= oReport:Section( 1 )            
Local oSection2	:= oReport:Section( 1 ):Section( 1 )
Local cWhereADF	:= ""
Local cWhereGrp	:= ""
Local cGrupo		:= ""
Local cCodADF		:= ""
Local cDescSU0	:= ""
Local cItemAnt	:= ""
Local cFilADF		:= xFilial( "ADF" )
Local cFilSU0		:= xFilial( "SU0" )
Local nTamItem	:= TamSX3( "ADF_ITEM" )[ 1 ]
Local nPosSU0		:= 0
Local nTotRec		:= 0
Local nX			:= 0
Local aDescGrp	:= {}
Local lCabSection2	:= .T.

If Len( aRetPar ) == 0             
	AAdd( aRetPar, dDataBase 	)
	AAdd( aRetPar, dDataBase 	)
	AAdd( aRetPar, " "			)
	AAdd( aRetPar, "ZZZZZZ"	)
EndIf

For nX := 1 To Len( aSelGrp )
	If aSelGrp[ nX, 1 ]		// Grupo selecionado
		cWhereGrp += "'" + AllTrim( aSelGrp[ nX, 2 ] ) + "',"
	EndIf
Next nX        

If Empty( cWhereGrp )
	cWhereGrp := u_RTmkRetGrp()
Else
	cWhereGrp := SubStr( cWhereGrp, 1, Len( cWhereGrp ) - 1 )
EndIf	

If At( ",", AllTrim( cWhereGrp ) ) > 0
	cWhereADF += " AND ADF.ADF_CODSU0 IN ( " + cWhereGrp + " ) "
Else
	cWhereADF += " AND ADF.ADF_CODSU0 = " + cWhereGrp + " "
EndIf

cWhereADF += " AND ADF.ADF_DATA BETWEEN '" + DtoS( aRetPar[ 1 ] ) + "' AND '" + DtoS( aRetPar[ 2 ] ) + "' "

If ! ( Empty( aRetPar[ 3 ] ) .And. AllTrim( aRetPar[ 4 ] ) == Replicate( "Z", Len( AllTrim( aRetPar[ 4 ] ) ) ) )
	cWhereADF += " AND ADF.ADF_CODSU7 BETWEEN '" + AllTrim( aRetPar[ 3 ] ) + "' AND '" + AllTrim( aRetPar[ 4 ] ) + "' "
EndIf	

cWhereADF := "%" + cWhereADF + "%"

BeginSql Alias "TOTREC"

	SELECT	COUNT( ADF.R_E_C_N_O_ ) AS TOTAL
	FROM		%Table:ADF% ADF
    WHERE	ADF.ADF_FILIAL = %xFilial:ADF% AND 
    		ADF.%notDel% 
    		%Exp:cWhereADF% 

EndSql

nTotRec := TOTREC->TOTAL

TOTREC->( dbCloseArea() )

// Somente atendimentos no grupo que possuem ao menos uma intera��o de analista do grupo
BeginSql Alias "QRYTRB"

	Column ADF_DATA as Date

	SELECT ADF.ADF_CODSU0, ADF.ADF_CODIGO, 
		( CASE	WHEN ADE.ADE_STATUS = '1' THEN 'Em Aberto' 
				WHEN ADE.ADE_STATUS = '2' THEN 'Pendente' 
				WHEN ADE.ADE_STATUS = '3' THEN 'Finalizado' END ) AS ADE_STATUS,
		MAX( ADF.ADF_CODSU7 ) AS ADF_CODSU7, MAX( SU7.U7_NOME ) AS U7_NOME, 
		MAX( ADE.ADE_ASSUNT ) AS ADE_ASSUNT, MAX( ADF.ADF_CODSU9 ) AS ADF_CODSU9, 
		MAX( SU9.U9_DESC ) AS U9_DESC, MAX( ADF.ADF_CODSUQ ) AS ADF_CODSUQ, 
		MAX( SUQ.UQ_DESC ) AS UQ_DESC, MAX( ADF.ADF_DATA ) AS ADF_DATA
	FROM %Table:ADF% ADF
	INNER JOIN %Table:SU7% SU7 ON
	    SU7.U7_FILIAL = %xFilial:SU7% AND
	    SU7.U7_COD = ADF.ADF_CODSU7 AND
	    SU7.%notDel%
	INNER JOIN %Table:SU9% SU9 ON
		SU9.U9_FILIAL = %xFilial:SU9% AND
		SU9.U9_CODIGO = ADF.ADF_CODSU9 AND
		SU9.%notDel%    
	INNER JOIN %Table:SUQ% SUQ ON
		SUQ.UQ_FILIAL = %xFilial:SUQ% AND
		SUQ.UQ_SOLUCAO = ADF.ADF_CODSUQ AND
		SUQ.%notDel%
	INNER JOIN %Table:ADE% ADE ON
	    ADE.ADE_FILIAL = %xFilial:ADE% AND
	    ADE.ADE_CODIGO = ADF.ADF_CODIGO AND
	    ADE.%notDel%
	WHERE
	    ADF.ADF_FILIAL = %xFilial:ADF% AND
	    ADF.%notDel%
    	%Exp:cWhereADF%     	   	
	GROUP BY ADF.ADF_CODSU0, ADE.ADE_STATUS, ADF.ADF_CODIGO
	ORDER BY ADF.ADF_CODSU0, ADE.ADE_STATUS, ADF.ADF_CODIGO
	
EndSql	

oSection1:SetHeaderSection( .T. )
oSection1:SetHeaderBreak( .T. )
oSection1:SetHeaderPage( .F. )

// Atualiza tabela de assuntos (T1) para consulta
u_RTmkRetAss( 1 )

ADF->( dbSetOrder( 1 ) )

oSection1:Init()

oReport:SetMeter( nTotRec )

While QRYTRB->( ! EoF() )
        
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
	While QRYTRB->( ! EoF() ) .And. QRYTRB->ADF_CODSU0 == cGrupo

		If oReport:Cancel()
			Exit
		EndIf

      	// Protocolo atualmente posicionado
      	cCodADF := QRYTRB->ADF_CODIGO             

      	// Percorre os itens do protocolo atual
      	While QRYTRB->( ! EoF() ) .And. QRYTRB->ADF_CODIGO == cCodADF
      	
			If oReport:Cancel()
				Exit
			EndIf

			oReport:IncMeter()                                   

   			// Busca data e hora de transferencia para o grupo atual e o grupo de origem
			ADF->( DbSetOrder( 1 ) )
			ADF->( DbSeek( cFilADF + cCodADF ) )
			
			// Posiciona no primeiro item do atendimento do grupo 
			While ADF->( ! EoF() ) .And. ADF->ADF_FILIAL == cFilADF .And. ADF->ADF_CODIGO == cCodADF
				If ADF->ADF_CODSU0 == cGrupo
					Exit
				EndIf	
				ADF->( DbSkip() )
			EndDo

			// Busca o item do antendimento do grupo que originou a transferencia			
			cItemAnt := StrZero( Val( ADF->ADF_ITEM ) - 1, nTamItem )

			// Posiciona no item anterior a transferencia para pegar dados de data, hora de 
			// transferencia e grupo de origem
			ADF->( DbSeek( cFilADF + cCodADF + cItemAnt ) )
			
			nPosSU0 := AScan( aDescGrp, { |x| x[ 1 ] == ADF->ADF_CODSU0 } )

			// Monta array com a descricao dos grupos de origem			
			If nPosSU0 == 0
				AAdd( aDescGrp, { ADF->ADF_CODSU0, Posicione( "SU0", 1, cFilSU0 + ADF->ADF_CODSU0, "U0_NOME" ) } )
				nPosSU0 := Len( aDescGrp )
			EndIf
			
			// Preenche dados da transferencia
			oSection2:Cell( "DATATRF" ):SetValue( ADF->ADF_DATA )
			oSection2:Cell( "HORATRF" ):SetValue( ADF->ADF_HORA )
			oSection2:Cell( "GRPTRF" ):SetValue( aDescGrp[ nPosSU0, 1 ] + " - " + aDescGrp[ nPosSU0, 2 ] )

			oSection2:Cell( "ADE_DESASS" ):SetValue( u_RTmkRetAss( 2, QRYTRB->ADE_ASSUNT ) )

			If QRYTRB->ADE_STATUS <> "Finalizado"
				oSection2:Cell( "ADF_DATA" ):SetValue( CtoD( "" ) )
			Else
				oSection2:Cell( "ADF_DATA" ):SetValue( QRYTRB->ADF_DATA )
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
| Rotina    | PergR004    | Autor | Gustavo Prudente | Data | 31.03.2014  |
|-------------------------------------------------------------------------|
| Descricao | Cria grupo de perguntas para o relatorio                    |
|-------------------------------------------------------------------------|
| Parametros| EXPA1 - Grupo de perguntas do relatorio preenchido          |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/ 
Static Function PergR004( aRetPar, cTitulo )

Local aPergs	:= {}
Local lRet	:= .T.

aAdd( aPergs, { 1, "De", CtoD( Space( 8 ) ), "@D", ".T.",, ".T.", 50, .T. } )
aAdd( aPergs, { 1, "Ate", CtoD( Space( 8 ) ), "@D", ".T.",, ".T.", 50, .T. } )
aAdd( aPergs, { 1, "Do Analista", Space( 6 ), "@!", ".T.", "SU7", ".T.", 6, .F. } )
aAdd( aPergs, { 1, "Ate Analista", "ZZZZZZ"  , "@!", ".T.", "SU7", ".T.", 6, .F. } )

lRet := ParamBox( aPergs, cTitulo, @aRetPar )

Return( lRet )