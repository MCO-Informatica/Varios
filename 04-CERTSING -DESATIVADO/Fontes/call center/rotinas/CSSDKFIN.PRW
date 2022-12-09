#include "protheus.ch"
             
/*
---------------------------------------------------------------------------
| Rotina    | CSSDKFIN     | Autor | Gustavo Prudente | Data | 09.10.2013 |
|-------------------------------------------------------------------------|
| Descricao | Encerra atendimentos automaticamente                        |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/        
User Function CSSDKFIN( cParGrp )
             
Local cCodOco		:= GetNewPar( "MV_XOCOFIN", "007013" )
Local cCodAcao	:= GetNewPar( "MV_XACAFIN", "000272" )
Local cGrpProc	:= GetNewPar( "MV_XGRPFIN", "35" )
Local cDataProc	:= DtoS( GetNewPar( "MV_XDATF1", dDatabase ) )
Local cDataP2	:= DtoS( GetNewPar( "MV_XDATF2", dDatabase ) )
Local cCodAde		:= ""
Local cFilADE		:= xFilial( "ADE" )
Local cOper		:= TkOperador()
Local nHandle		:= 0

Private aHeader	:= {}
Private aCols	:= {}           

If cParGrp != Nil
	cGrpProc := cParGrp
EndIf

If MsgYesNo( "Confirma encerramento dos atendimentos do grupo: " + cGrpProc + " ?", "Encerramento em lote" )
	
	If ! u_CSGERLog( 1, @nHandle, "[Encerramento de Atendimentos - Service Desk] [Grupo: " + cGrpProc + "]", "\SDKLog", "\" + SubStr( cDataProc, 1, 6 ) )
		Return .F.
	EndIf
		
	// Seleciona todos os chamados do grupo do parâmetro, até a data informada, que não estao finalizados
	BeginSql Alias "TRBADE"
		
		SELECT  ADE.R_E_C_N_O_
		FROM 	%Table:ADE% ADE
		WHERE 	ADE.ADE_FILIAL = %XFilial:ADE% AND 
				ADE.ADE_GRUPO = %Exp:cGrpProc% AND
				ADE.ADE_STATUS <> '3' AND
				ADE.ADE_DATA BETWEEN %Exp:cDataProc% AND %Exp:cDataP2% AND
				ADE.%notDel%
	
	EndSql
	
	ADE->( dbSetOrder( 1 ) )
	
	Do While TRBADE->( ! EoF() )
	    
		dbSelectAreA( "ADE" )
		dbGoTo( TRBADE->R_E_C_N_O_ )
		
		TkUpdCall(	"", cCodAcao, "", "** Por favor, desconsidere este atendimento." + CRLF + CRLF + "Atendimento encerrado por homologação da ferramenta" , ;
					"", cOper, ADE->ADE_GRUPO, "" , ;
					NIL, Iif( !IsInCallStack( "GenRecurrence" ), Date(), dDatabase ), ADE->ADE_CODIGO, cCodOco ) 
		
		TK510UsrLock( "U", ADE->ADE_CODIGO, cOper )
	    
		If ADE->ADE_STATUS == "3"
			u_CSGERLog( 2, nHandle, "[OK][Código: " + AllTrim( ADE->ADE_CODIGO ) + "][Atendimento finalizado com sucesso][Recno: " + AllTrim( Str( ADE->( Recno() ) ) ) + "] " )
		Else
			u_CSGERLog( 2, nHandle, "[ERRO][Código: " + AllTrim( ADE->ADE_CODIGO ) + "][Atendimento não foi finalizado][Recno: " + AllTrim( Str( ADE->( Recno() ) ) )  + "] " )
		EndIf
		
		dbSelectArea( "TRBADE" )
		dbSkip()
		
	EndDo	
	
	u_CSGERLog( 3, nHandle )	// Fecha arquivo de log
	
	TRBADE->( dbCloseArea() )
	
	If !IsBlind()
		MsgInfo( "Processamento finalizado. Grupo: " + cGrpProc )
	EndIf	

EndIf

Return .T.