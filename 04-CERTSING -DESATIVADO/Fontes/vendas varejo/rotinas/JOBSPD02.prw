#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "topconn.ch"
/*
Nome			: JOBSPD02
Descrição		: Atualizacao Automatica de Livros Fiscais - F3_CODRSEF
Autor			: Gesse Santos   
Ambiente		: Fiscal 
Data Criação	: 15/05/2014
*/   
//Rotina para chamar a partir do Schedule
User Function JOBSPD02( aParam )
	Local lJob 		:= ( Select( "SX6" ) == 0 )
	Local cJobEmp	:= Iif( aParam == NIL, '01' , aParam[ 1 ] )
	Local cJobFil	:= Iif( aParam == NIL, '02' , aParam[ 2 ] )
	Local cSerieNF	:= Iif( aParam == NIL, '2  ', aParam[ 3 ] )
	
	If lJob
		RpcSetType( 3 )
		RpcSetEnv( cJobEmp, cJobFil )
	EndIf 
	
	Conout("Job U_JOBSPD02 F3_codrsef - Begin Emp("+cJobEmp+"/"+cJobFil+") - "+time() ) 
	
	U_JOBSPD01( @cSerieNF )  
	
	Conout("Job  U_JOBSPD02 F3_codrsef - end Emp("+cJobEmp+"/"+cJobFil+") - "+time() )

Return

//Rotina funcional - Atualiza F3_CODRSEF 
User Function JOBSPD01(cSerieNF) 
	Local cQuery   := ''
	Local cNota    := ''
	Local _nDPer   := '' //GetNewPar("MV_XDIANFS", 30)	 
	Local _cSEFNfs := '' //GetNewPar("MV_XSEFNFS", '210,232,234')
	Local cMV_XDIANFS := 'MV_XDIANFS'
	Local cMV_XSEFNFS := 'MV_XSEFNFS' 
	Local cAliasA  := GetNextAlias()
	
	//Private bFiltraBRW := {||.T.}
	
	If .NOT. SX6->( ExisteSX6( cMV_XDIANFS ) )
		CriarSX6( cMV_XDIANFS, 'N', 'Numero de dias para retroceder e realizar a query. JBSPD02.prw', '05' )
	Endif
	
	If .NOT. SX6->( ExisteSX6( cMV_XSEFNFS ) )
		CriarSX6( cMV_XSEFNFS, 'C', 'Códigos de retorno da SEFAZ que irá utilizar na query. JBSPD02.prw', '210,232,234,656' )
	Endif
	
	_nDPer   := GetMv( cMV_XDIANFS )
	_cSEFNfs := GetMv( cMV_XSEFNFS )
				
	MV_PAR01 := Date() - _nDPer
	MV_PAR02 := Date()
	MV_PAR03 := cSerieNF
	MV_PAR04 := Space(9)
	MV_PAR05 := "ZZZZZZZZZ"   
	
	_cSEFNfs := "'"+StrTran(Alltrim(_cSEFNfs),",","','")+"'"
	
	// Seleciona registros SF3 sem retorno sefaz ou critica que podem ser ajustadas
	cQuery := "SELECT " + CRLF 
	cQuery += "  F3_NFISCAL, F3_SERIE, F3_CODRSEF " + CRLF
	
	cQuery += " FROM " + RetSqlName("SF3") + " SF3 " + CRLF
	
	cQuery += " WHERE" + CRLF
	cQuery += "       F3_FILIAL   = '" + xFilial('SF3') + "' AND " + CRLF
	cQuery += "       F3_ENTRADA >= '" + dTos(Mv_par01) + "' AND " + CRLF
	cQuery += "       F3_ENTRADA <= '" + dTos(Mv_par02) + "' AND " + CRLF
	cQuery += "       F3_SERIE    = '" + MV_PAR03 + "' AND " + CRLF
	cQuery += "       F3_NFISCAL  BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' AND " + CRLF
	cQuery += "       F3_ESPECIE  = 'SPED' AND " + CRLF
	cQuery += "       F3_CODRSEF  IN  ('   ',"+_cSEFNfs+")  AND " + CRLF
	cQuery += "     ( F3_CFO >= '5'   OR (  F3_CFO < '5' AND F3_FORMUL = 'S' )  ) AND " + CRLF
	cQuery += "		SF3.D_E_L_E_T_= ' ' " + CRLF
	
	cQuery += "  GROUP BY F3_NFISCAL, F3_SERIE, F3_CODRSEF " + CRLF
	cQuery += "  ORDER BY F3_NFISCAL" + CRLF
	
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasA) > 0
		(cAliasA)->(DbCloseArea())
	Endif
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasA, .F., .T.) 
	
	DbSelectArea(cAliasA)
	(cAliasA)->(dbGoTop())
		
	While (cAliasA)->(!EoF())
		cNota := (cAliasA)->F3_NFISCAL
		
		If (cAliasA)->F3_CODRSEF == '656'
			dbSelectArea("SF2")
			dbSetorder(1)
			If dbSeek( xFilial('SF2') + (cAliasA)->F3_NFISCAL + (cAliasA)->F3_SERIE)
				//Transmite a nota eletronica para o SEFAZ e aguarda a resposta da efetivacao
				U_Transmitenfe(SF2->F2_DOC,SF2->F2_SERIE,'00001')
			Endif
		Else
			//Executa a rotina de Monitor
			U_GTNFeMnt( , 1, {MV_PAR03,cNota,cNota} )
		EndIf
		
		(cAliasA)->(DbSkip())
	EndDo
	(cAliasA)->(DbCloseArea())
Return

//Rotina para chamar a partir do menu ou formulas
User Function JOBSPD03(aParam) 
	Local cJobEmp	:= Iif( aParam == NIL, '01' , aParam[ 1 ] )
	Local cJobFil	:= Iif( aParam == NIL, '01' , aParam[ 2 ] )
	Local cSerieNF	:= Iif( aParam == NIL, '3  ', aParam[ 3 ] )
   	
	U_JOBSPD02( { cJobEmp, cJobFil, cSerieNF } )
   	MsgInfo("Processo executado com sucesso!","JOBSPD02")
Return( .T. )