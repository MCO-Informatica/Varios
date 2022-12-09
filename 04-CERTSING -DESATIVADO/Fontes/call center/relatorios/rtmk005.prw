#include "protheus.ch"

/*
---------------------------------------------------------------------------
| Rotina    | RTMK005     | Autor | Gustavo Prudente | Data | 03.04.2014  |
|-------------------------------------------------------------------------|
| Descricao | Imprime a relacao de Atendimentos sem Interacao por Grupo   |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
User Function RTMK005()

Local oReport

oReport := ReportDef()
oReport:printDialog()
	
Return


/*
-----------------------------------------------------------------------------
| Rotina    | ReportDef   | Autor | Gustavo Prudente | Data | 03.04.2014    |
|---------------------------------------------------------------------------|
| Descricao | Definicao de secao do relatorio de atendimentos sem interacao |
|---------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                           |
-----------------------------------------------------------------------------
*/
Static Function ReportDef()

Local oReport
Local oSection1
Local oSection2
Local cTitulo		:= "@Atendimentos sem Interação por Grupo"
Local aRetPar		:= {}
Local aSelGrp		:= { { .T., Space( 02 ), Space( 40 ) } }
 
oReport := TReport():New( 'RTMK005', cTitulo,	{ || Iif( u_RTmkSelGrp( @aSelGrp, cTitulo ) ,;
										PergR005( @aRetPar, cTitulo ), .F. ) } ,;
										{ |oReport| PrintReport( oReport, @aRetPar, @aSelGrp ) 		}, ;
										"Este relatório irá imprimir atendimentos sem interação por grupo." )

oReport:SetLandScape()
oReport:SetTotalInLine( .F. )
oReport:ShowHeader()
 
oSection1 := TRSection():New( oReport, "Grupo", { "QRYTRB" } )
oSection1:SetTotalInLine( .F. )

TRCell():New( oSection1, "ADE_GRUPO" , "QRYTRB", "Grupo", PesqPict( "ADE", "ADE_GRUPO" ), TamSX3( "ADE_GRUPO" )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "ADE_DESGRP", "QRYTRB", "Descrição", "", TamSX3( "U0_NOME" )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
                             
oSection2 := TRSection():New( oSection1, "Detalhes", { "QRYTRB" } )
oSection2:SetTotalInLine( .F. )

TRCell():New( oSection2, "ADE_CODIGO", "QRYTRB", 	"Protocolo",	 	PesqPict( "ADE", "ADE_CODIGO" ),	TamSX3( "ADE_CODIGO" )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADE_DATA"  , "QRYTRB",	"Data",		 	PesqPict( "ADE", "ADE_DATA" ),	TamSX3( "ADE_DATA" )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADE_PEDGAR", "QRYTRB", 	"Pedido GAR",	 	PesqPict( "ADE", "ADE_PEDGAR" ),	TamSX3( "ADE_PEDGAR" )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADE_EMAIL2" , "QRYTRB", 	"Email",		 	PesqPict( "ADE", "ADE_EMAIL2" ),	TamSX3( "ADE_EMAIL2" )[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADE_ASSUNT", "QRYTRB", 	"Assunto"	, 	 	"", 10,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADE_DESASS", "QRYTRB", 	"Descrição",	 	"", 40,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "DATATRF"	, "",		"Dt. Transf.",	"@D", 8, /*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "HORATRF"	, "",		"Hr. Transf.", 	"@!", 5, /*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "GRPTRF"	, "",		"Grupo Origem",	PesqPict( "ADF", "ADF_CODSU0" ), TamSX3( "ADF_CODSU0" )[ 1 ], /*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "ADE_STATUS", "QRYTRB", 	"Status",		 	"", 15,/*lPixel*/,/*{|| code-block de impressao }*/)

oBreak := TRBreak():New( oSection1, oSection1:Cell( "ADE_GRUPO" ),, .F. )
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

Local oSection1	:= oReport:Section( 1 )            
Local oSection2	:= oReport:Section( 1 ):Section( 1 )
Local cWhereADE	:= ""
Local cWhereADF	:= ""
Local cWhereGrp	:= ""
Local cGrupo		:= ""
Local cCodADF		:= ""
Local dDataTrf	:= CtoD( "" )
Local cHoraTrf	:= ""
Local cGrpTrf		:= ""
Local cFilSU0		:= xFilial( "SU0" )
Local cFilADF		:= xFilial( "ADF" )
Local nTotRec		:= 0
Local lCabSection2	:= .T.

If Len( aRetPar ) == 0             
	AAdd( aRetPar, dDataBase )
	AAdd( aRetPar, dDataBase )
	AAdd( aRetPar, 1 )
EndIf

// Atualiza tabela de assuntos (T1) para consulta
u_RTmkRetAss( 1 )

// Cria string com grupos selecionados
AEval( aSelGrp, { |x| Iif( x[ 1 ], cWhereGrp += "'" + AllTrim( x[ 2 ] ) + "',", .T. ) } )

If Empty( cWhereGrp )
	cWhereGrp := u_RTmkRetGrp()
Else
	cWhereGrp := SubStr( cWhereGrp, 1, Len( cWhereGrp ) - 1 )
EndIf	

If At( ",", AllTrim( cWhereGrp ) ) > 0
	cWhereGrp := " ADF.ADF_CODSU0 IN ( " + cWhereGrp + " ) "
Else
	cWhereGrp := " ADF.ADF_CODSU0 = " + cWhereGrp + " "
EndIf

// Verifica filtro por status do atendimento
If ValType( aRetPar[ 3 ] ) == "N" .And. aRetPar[ 3 ] == 1
	cWhereADE += " ADE.ADE_STATUS IN ( '1', '2' ) AND "
ElseIf SubStr( aRetPar[ 3 ], 1, 1 ) == "2"
	cWhereADE += " ADE.ADE_STATUS = '3' AND "
EndIf

cWhereADF += " ADF.ADF_DATA BETWEEN '" + DtoS( aRetPar[ 1 ] ) + "' AND '" + DtoS( aRetPar[ 2 ] ) + "' AND "
cWhereADF += cWhereGRP
cWhereADE += StrTran( cWhereGrp, "ADF.ADF_CODSU0", "ADE.ADE_GRUPO" )

cWhereADE := "%" + cWhereADE + "%"
cWhereADF := "%" + cWhereADF + "%"

BeginSql Alias "TOTREC"

	SELECT	COUNT( ADE.R_E_C_N_O_ ) AS TOTAL
	FROM		%Table:ADE% ADE
    WHERE	ADE.ADE_FILIAL = %xFilial:ADE% AND 
			%Exp:cWhereADE% AND	          			
	    	ADE.%notDel% AND
	    	( SELECT COUNT( ADF.R_E_C_N_O_ )
	      		FROM %Table:ADF% ADF
	      		WHERE	ADF.ADF_FILIAL = %xFilial:ADF% AND
	          			ADF.ADF_CODIGO = ADE.ADE_CODIGO AND
	          			%Exp:cWhereADF% AND
	          			ADF.%notDel% ) = 0

EndSql

nTotRec := TOTREC->TOTAL

TOTREC->( dbCloseArea() )

// Somente atendimentos do grupo que não tem interação de nenhum analista do grupo
BeginSql Alias "QRYTRB"	

	Column 	ADE_DATA as Date
	
	SELECT	ADE.ADE_GRUPO  AS ADE_GRUPO		, ADE.ADE_CODIGO	AS ADE_CODIGO,
			ADE.ADE_PEDGAR AS ADE_PEDGAR	, ADE.ADE_DATA	AS ADE_DATA,
			ADE.ADE_ASSUNT AS ADE_ASSUNT	, ADE.ADE_EMAIL2	AS ADE_EMAIL2,
			( CASE	WHEN ADE.ADE_STATUS = '1' THEN 'Em Aberto' 
					WHEN ADE.ADE_STATUS = '2' THEN 'Pendente' 
					WHEN ADE.ADE_STATUS = '3' THEN 'Finalizado' END ) AS ADE_STATUS
	FROM 	%Table:ADE% ADE
	WHERE	ADE.ADE_FILIAL = %xFilial:ADE% AND
			%Exp:cWhereADE% AND	          			
	    	ADE.%notDel% AND
	    	( SELECT COUNT( ADF.R_E_C_N_O_ )
	      		FROM %Table:ADF% ADF
	      		WHERE	ADF.ADF_FILIAL = %xFilial:ADF% AND
	          			ADF.ADF_CODIGO = ADE.ADE_CODIGO AND
	          			%Exp:cWhereADF% AND	          			
	          			ADF.%notDel% ) = 0
	ORDER BY ADE.ADE_GRUPO, ADE.ADE_CODIGO

EndSql    

oSection1:SetHeaderSection( .T. )
oSection1:SetHeaderBreak( .T. )
oSection1:SetHeaderPage( .F. )

ADF->( dbSetOrder( 1 ) )

oSection1:Init()

oReport:SetMeter( nTotRec )

While QRYTRB->( ! EoF() )
        
	If oReport:Cancel()
		Exit
	EndIf

   	// Grupo atualmente posicionado para impressao dos protocolos 
	cGrupo := QRYTRB->ADE_GRUPO

 	oSection1:Cell( "ADE_DESGRP" ):SetValue( Posicione( "SU0", 1, cFilSU0 + cGrupo, "U0_NOME" ) )
	oSection1:PrintLine()
                    
	lCabSection2 := .T.
	oSection2:SetHeaderSection( .T. )
	
	oSection2:Init()
                                         
	// Percorre os itens do grupo 
	While QRYTRB->( ! EoF() ) .And. QRYTRB->ADE_GRUPO == cGrupo

		If oReport:Cancel()
			Exit
		EndIf
   		
   		oReport:IncMeter()                                    
   		
      	// Protocolo atualmente posicionado
      	cCodADE := QRYTRB->ADE_CODIGO

      	// Percorre os itens do protocolo atual
      	While QRYTRB->( ! EoF() ) .And. QRYTRB->ADE_CODIGO == cCodADE
      	
			If oReport:Cancel()
				Exit
			EndIf

			BeginSql Alias "QRYADF"	

				Column 	ADF_DATA as Date
	
				SELECT	ADF.ADF_CODSU0, SU0.U0_NOME, ADF.ADF_DATA, ADF.ADF_HORA
				FROM		%Table:ADF% ADF INNER JOIN
						%Table:SU0% SU0 ON
						SU0.U0_FILIAL = %xFilial:SU0% AND 
						SU0.U0_CODIGO = ADF.ADF_CODSU0 AND
						SU0.D_E_L_E_T_ = ' '
				WHERE	ADF.ADF_FILIAL = %xFilial:ADF% AND 
						ADF.ADF_CODIGO = %Exp:cCodADE% AND
						ADF.ADF_CODSU9 = 'TMK001' AND  
						ADF.%notDel% AND
						ADF.ADF_DATA || ADF.ADF_HORA = (
						SELECT MAX( ADFB.ADF_DATA || ADFB.ADF_HORA )
							FROM		%Table:ADF% ADFB
							WHERE	ADFB.ADF_FILIAL = %xFilial:ADF% AND 
									ADFB.ADF_CODIGO = %Exp:cCodADE% AND
									ADFB.ADF_CODSU9 = 'TMK001' AND  
									ADFB.%notDel% )

			EndSql

			// Preenche dados da transferencia
			oSection2:Cell( "DATATRF" ):SetValue( QRYADF->ADF_DATA )
			oSection2:Cell( "HORATRF" ):SetValue( QRYADF->ADF_HORA )
			oSection2:Cell( "GRPTRF"  ):SetValue( QRYADF->ADF_CODSU0 + " - " + QRYADF->U0_NOME )

			QRYADF->( dbCloseArea() )
			
			DbSelectArea( "QRYTRB" )

			oSection2:Cell( "ADE_DESASS" ):SetValue( u_RTmkRetAss( 2, QRYTRB->ADE_ASSUNT ) )

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
| Rotina    | PergR005    | Autor | Gustavo Prudente | Data | 03.04.2014  |
|-------------------------------------------------------------------------|
| Descricao | Cria grupo de perguntas para o relatorio                    |
|-------------------------------------------------------------------------|
| Parametros| EXPA1 - Grupo de perguntas do relatorio preenchido          |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/ 
Static Function PergR005( aRetPar, cTitulo )

Local aPergs	:= {}
Local lRet	:= .T.

AAdd( aPergs, { 1, "De" , CtoD( Space( 8 ) ), "@D", "","", "", 50, .T. } )
AAdd( aPergs, { 1, "Ate", CtoD( Space( 8 ) ), "@D", "","", "", 50, .T. } )
AAdd( aPergs, { 2, "Imprimir", 1, { "1-Pendente/Em aberto", "2-Finalizados", "3-Todos" }, 80, ".T.", .F. } )

lRet := ParamBox( aPergs, cTitulo, @aRetPar )

Return( lRet )