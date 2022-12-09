#include "protheus.ch"

/*
---------------------------------------------------------------------------
| Rotina    | RTMK006     | Autor | Gustavo Prudente | Data | 03.04.2014  |
|-------------------------------------------------------------------------|
| Descricao | Imprime a relacao do ranking de atendimentos                |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
User Function RTMK006()

Local oReport

oReport := ReportDef()
oReport:printDialog()
	
Return

/*
---------------------------------------------------------------------------
| Rotina    | reportDef   | Autor | Gustavo Prudente | Data | 03.04.2014  |
|-------------------------------------------------------------------------|
| Descricao | Definicao de secao da relacao de ranking por analista       |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function ReportDef()

Local oReport
Local oSection1
Local oSection2
Local oBreak
Local oBreak2
Local cTitulo		:= "@Ranking por Analista"
Local aRetPar		:= {}
Local aSelGrp		:= { { .T., Space( 02 ), Space( 40 ) } }
 
oReport := TReport():New( 'RTMK006', cTitulo,	{ || Iif( u_RTmkSelGrp( @aSelGrp, cTitulo ) ,;
										PergR006( @aRetPar, cTitulo ), .F. ) } ,;
										{ |oReport| PrintReport( oReport, @aRetPar, @aSelGrp ) }, ;
										"Este relatório irá imprimir o ranking de atendimentos por analista." )

oReport:SetLandScape()
oReport:SetTotalInLine( .F. )
oReport:ShowHeader()
 
oSection1 := TRSection():New( oReport, "Grupo", { "QRYTRB" } )
oSection1:SetTotalInLine( .F. )

TRCell():New( oSection1, "ADF_CODSU0", "QRYTRB", "Grupo"    , PesqPict( "ADF", "ADF_CODSU0" ), TamSX3( "ADF_CODSU0" )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "ADF_DESSU0", "QRYTRB", "Descrição", ""                             , TamSX3( "U0_NOME"    )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
                             
oSection2 := TRSection():New( oSection1, "Detalhes", { "QRYTRB" } )

TRCell():New( oSection2, "ADF_CODSU7", 	"QRYTRB", "Analista"  	,	PesqPict( "ADF", "ADF_CODSU9" ), TamSX3( "ADF_CODSU9" )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "U7_NOME", 		"QRYTRB", "Descrição" 	,	"",		40,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADF_DATA", 	"QRYTRB", "Data"      	,	"@D",	40,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "TOTAL", 		"QRYTRB", "Total"     	,	"",		15,/*lPixel*/,/*{|| code-block de impressao }*/)

oBreak := TRBreak():New( oSection1, oSection1:Cell( "ADF_CODSU0" ),, .F. )

oBreak:SetPageBreak( .F. )

Return( oReport )

/*
---------------------------------------------------------------------------
| Rotina    | PrintReport | Autor | Gustavo Prudente | Data | 03.04.2014  |
|-------------------------------------------------------------------------|
| Descricao | Processa impressao do relatorio de atendimentos por grupo   |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/ 
Static Function PrintReport( oReport, aRetPar, aSelGrp )

Local oBreak
Local oSection1	:= oReport:Section( 1 )            
Local oSection2	:= oReport:Section( 1 ):Section( 1 )
Local cWhereADF	:= ""
Local cWhereGrp	:= ""
Local cGrupo		:= ""
Local cCodADF		:= ""
Local cFilSU0		:= xFilial( "SU0" )
Local cCodOper	:= ""
Local nTotRec		:= 0
Local nX			:= 0
Local lCabSection2	:= .T.
Local lTotais		:= .T.

If Len( aRetPar ) == 0             
	AAdd( aRetPar, dDataBase 	)
	AAdd( aRetPar, dDataBase 	)
	AAdd( aRetPar, " "			)
	AAdd( aRetPar, "ZZZZZZ"	)
	AAdd( aRetPar, 1          )
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

	SELECT COUNT( ADF_CODSU7 ) AS TOTAL
	FROM (	SELECT	ADF.ADF_CODSU0,
					ADF.ADF_CODSU7,
					ADF.ADF_DATA
			FROM		%Table:ADF% ADF
		    WHERE	ADF.ADF_FILIAL = %xFilial:ADF% AND 
		    		ADF.%notDel% 
		    		%Exp:cWhereADF% 
			GROUP BY ADF.ADF_CODSU0,
					ADF.ADF_CODSU7,
					ADF.ADF_DATA )

EndSql

nTotRec := TOTREC->TOTAL
         
TOTREC->( dbCloseArea() )

// Somente atendimentos no grupo que possuem ao menos uma interação de analista do grupo
BeginSql Alias "QRYTRB"

	Column ADF_DATA as Date
	Column TOTAL as Numeric( 6, 0 )

	SELECT	ADF_CODSU0,
			ADF_CODSU7, 
			MAX( U7_NOME ) AS U7_NOME,
			ADF_DATA, 
			COUNT( ADF_CODIGO ) AS TOTAL
	FROM		( SELECT	ADF.ADF_CODSU0,
					ADF.ADF_CODSU7,
					MAX( SU7.U7_NOME ) AS U7_NOME,
					ADF.ADF_CODIGO,
					ADF.ADF_DATA
			FROM		%Table:ADF% ADF
					INNER JOIN %Table:SU7% SU7
							ON	SU7.U7_FILIAL = %xFilial:SU7% 
								AND SU7.U7_COD = ADF.ADF_CODSU7
								AND SU7.%notDel%
					INNER JOIN %Table:ADE% ADE
							ON	ADE.ADE_FILIAL = %xFilial:ADE%
								AND ADE.ADE_CODIGO = ADF.ADF_CODIGO
								AND ADE.%notDel%
	         WHERE	ADF.ADF_FILIAL = %xFilial:ADF%
					%Exp:cWhereADF%
					AND ADF.%notDel%
	         GROUP	BY	ADF.ADF_CODSU0,
	         			ADF.ADF_CODSU7,
						ADF.ADF_DATA,						
						ADF.ADF_CODIGO )
	GROUP BY ADF_CODSU0, ADF_CODSU7, ADF_DATA
	ORDER BY ADF_CODSU0, ADF_CODSU7, ADF_DATA	

EndSql	

lTotais := ( ValType( aRetPar[ 5 ] ) == "N" .And. aRetPar[ 5 ] == 1 )

If lTotais // Imprime total de atendimentos por analista no periodo
	oBreak2 := TRBreak():New( oSection2, oSection2:Cell( "ADF_CODSU7" ), "Total de atendimentos no período" )
	TRFunction():New( oSection2:Cell( "TOTAL" ), NIL, "SUM", oBreak2 )	
EndIf

oSection1:SetHeaderSection( .T. )
oSection1:SetHeaderBreak( .T. )
oSection1:SetHeaderPage( .F. )

// Atualiza tabela de assuntos (T1) para consulta
u_RTmkRetAss( 1 )

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
        
	cCodOper := ""
                                         
	// Percorre os itens do grupo 
	While QRYTRB->( ! EoF() ) .And. QRYTRB->ADF_CODSU0 == cGrupo

		If oReport:Cancel()
			Exit
		EndIf
                                    
   		oReport:IncMeter()
   		
   		If cCodOper <> QRYTRB->ADF_CODSU7
	   		cCodOper := QRYTRB->ADF_CODSU7
	   		If ! lTotais
	   			oReport:Skipline()
	   		EndIf
		 	oSection2:Cell( "ADF_CODSU7" ):Show()
		 	oSection2:Cell( "U7_NOME" ):Show()
		Else
		 	oSection2:Cell( "ADF_CODSU7" ):Hide()
		 	oSection2:Cell( "U7_NOME" ):Hide()
		EndIf	
		
		// Impressao da linha de total de atendimentos do analista
		oSection2:PrintLine()

		If lCabSection2
			oSection2:SetHeaderSection( .F. )
			lCabSection2 := .F.
		EndIf	
		 
		QRYTRB->( dbSkip() )

	EndDo

	oSection2:Finish()
	
EndDo

oSection1:Finish()

QRYTRB->( dbCloseArea() )

Return


/*
---------------------------------------------------------------------------
| Rotina    | PergR006    | Autor | Gustavo Prudente | Data | 03.04.2014  |
|-------------------------------------------------------------------------|
| Descricao | Cria grupo de perguntas para o relatorio                    |
|-------------------------------------------------------------------------|
| Parametros| EXPA1 - Grupo de perguntas do relatorio preenchido          |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/ 
Static Function PergR006( aRetPar, cTitulo )

Local aPergs	:= {}
Local lRet	:= .T.

AAdd( aPergs, { 1, "De", CtoD( Space( 8 ) ), "@D", ".T.",, ".T.", 50, .T. } )
AAdd( aPergs, { 1, "Ate", CtoD( Space( 8 ) ), "@D", ".T.",, ".T.", 50, .T. } )
AAdd( aPergs, { 1, "Do Analista", Space( 6 ), "@!", ".T.", "SU7", ".T.", 6, .F. } )
AAdd( aPergs, { 1, "Ate Analista", "ZZZZZZ"  , "@!", ".T.", "SU7", ".T.", 6, .F. } )
AAdd( aPergs, { 2, "Imprime Total", 1, { "1-Sim", "2-Não" }, 50, ".T.", .F. } )

lRet := ParamBox( aPergs, cTitulo, @aRetPar )

Return( lRet )