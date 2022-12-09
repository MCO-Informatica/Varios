#Include "rwmake.ch"
#Include "topconn.ch"
#Include "Protheus.ch"
#include "fileio.ch"
#INCLUDE "TBICONN.CH"
#Include "Fisa022.ch"

//---------------------------------------------------------------
// Rotina | CSJB05 | Autor | Rafael Beghini | Data | 06/08/2015 
//---------------------------------------------------------------
// Descr. | Rotina para gravar o Link de Hardware/Entrega 
//        | no Pedido em JOB.
//---------------------------------------------------------------
// Uso    | Certisign Certificadora Digital.
//---------------------------------------------------------------
User Function CSJB05( aParam )
	Local cEmp    := ''
	Local cFil    := ''
	
	cEmp := Iif( aParam == NIL, '01', aParam[ 1 ] )
	cFil := Iif( aParam == NIL, '02', aParam[ 2 ] )
	
	Conout("CSJB05 > === NFe - INICIO Rotina para gravar o Link de Hardware/Entrega no Pedido. === ["+Dtoc(Date())+" - "+TIME()+"]")
	
	RpcSetType( 3 )
	PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil TABLES "SF3","SF2","SD2","SC6","SC5"

		JB05Proce()
		
	RESET ENVIRONMENT
	
	Conout("CSJB05 > === NFe - FINAL Rotina para gravar o Link de Hardware/Entrega no Pedido. === ["+Dtoc(Date())+" - "+TIME()+"]")
Return

//----------------------------------------------------------------
// Rotina | JB05Proce | Autor | Rafael Beghini | Data | 06/08/2015 
//----------------------------------------------------------------
// Descr. | Rotina Cria a query e grava no pedido.
//        | 
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//---------------------------------------------------------------- 
Static Function JB05Proce()
	Local cTRB      := ''
	Local cQuery    := ''
	Local cMVpar01  := ''
	Local cRandom   := ''
	Local cOperacao := ''
	Local cXoper    := ''
	Local aRet      := {}
	Local aEspelho  := {}
	Local nDias     := 0
	Local nRecSF2   := 0
	Local lDeneg    := .T.
	Local cMV_XDIANF := 'MV_CSJB05'
	
	If .NOT. SX6->( ExisteSX6( cMV_XDIANF ) )
		CriarSX6( cMV_XDIANF, 'N', 'Numero de dias para retroceder e realizar a query. CSJB05.prw', '05' )
	Endif
	
	nDias   := GetMv( cMV_XDIANF )
	
	cMVpar01 := dTos(dDataBase - nDias)
	
	cQuery += "SELECT DISTINCT F3_ENTRADA," 
	cQuery += "                F3_NFISCAL,"
	cQuery += "                F3_SERIE,"
	cQuery += "                SF2.R_E_C_N_O_ AS F2RECNO," 
	cQuery += "                C6_XOPER," 
	cQuery += "                C5_NUM," 
	cQuery += "                CASE" 
	cQuery += "                  WHEN C6_XOPER = '53' THEN C5_XNFHRE" 
	cQuery += "                  ELSE C5_XNFHRD" 
	cQuery += "                END AS LINKNF" 
	cQuery += "FROM "+RetSqlName("SF3")+ " SF3 " 
	cQuery += "       INNER JOIN "+RetSqlName("SF2")+ " SF2 " 
	cQuery += "               ON F2_FILIAL = F3_FILIAL" 
	cQuery += "                  AND F2_DOC = F3_NFISCAL" 
	cQuery += "                  AND F2_SERIE = F3_SERIE" 
	cQuery += "                  AND F2_FIMP = 'D'" 
	cQuery += "                  AND SF2.D_E_L_E_T_ = ' '" 
	cQuery += "       INNER JOIN "+RetSqlName("SD2")+ " SD2 " 
	cQuery += "               ON D2_FILIAL = F2_FILIAL" 
	cQuery += "                  AND D2_DOC = F2_DOC" 
	cQuery += "                  AND D2_SERIE = F2_SERIE" 
	cQuery += "                  AND SD2.D_E_L_E_T_ = ' '" 
	cQuery += "       INNER JOIN "+RetSqlName("SC6")+ " SC6 " 
	cQuery += "               ON C6_FILIAL = '"+xFilial("SC6")+"'" 
	cQuery += "                  AND C6_NOTA = D2_DOC" 
	cQuery += "                  AND C6_SERIE = D2_SERIE" 
	cQuery += "                  AND SC6.D_E_L_E_T_ = ' '" 
	cQuery += "       INNER JOIN "+RetSqlName("SC5")+ " SC5 " 
	cQuery += "               ON C5_FILIAL = C6_FILIAL" 
	cQuery += "                  AND C5_NUM = C6_NUM" 
	cQuery += "                  AND SC5.D_E_L_E_T_ = ' '" 
	cQuery += "WHERE  SF3.D_E_L_E_T_ = ' ' "
	cQuery += "       AND F3_FILIAL   = '" + xFilial('SF3') + "' " 
	cQuery += "       AND F3_SERIE    = '2'" 
	cQuery += "       AND F3_ENTRADA >= '"+cMVpar01+"' " 
	cQuery += "       AND F3_CODRSEF  = '302'" 
	cQuery += "ORDER  BY F3_NFISCAL ASC" 

	
	cTRB   := GetNextAlias()
	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery ), cTRB, .F., .T. )
	
	If .NOT. (cTRB)->(EOF())
		While .NOT. (cTRB)->( EOF() )
			cXoper := (cTRB)->C6_XOPER
			cOperacao := IIF( cXoper=='53', 'Entrega', 'Hardware' )
			nRecSF2   := (cTRB)->F2RECNO
			IF Empty( (cTRB)->LINKNF )
				aRet:={}
				Aadd( aRet, .T. )
				Aadd( aRet, "000169")
				Aadd( aRet, (cTRB)->C5_NUM )
				Aadd( aRet, "Nfe Denegada processada")
				
				SF2->( DbGoto(nRecSF2) )
				
				SC6->( DbSetOrder(4) )	//C6_FILIAL+C6_NOTA+C6_SERIE
				SC6->( MsSeek( xFilial("SC6") + (cTRB)->F3_NFISCAL + (cTRB)->F3_SERIE ) )
				
				SC5->( DbSetOrder(1) )	//C5_FILIAL+C5_NUM
				SC5->( MsSeek( xFilial("SC5") + (cTRB)->C5_NUM ) )
			
						   //Gera o arquivo espelho da nota fiscal
				aEspelho := U_GARR010(aRet,@cRandom, lDeneg)
				IF Len(aEspelho) > 0 .AND. aEspelho[1]
					Conout('CSJB05 > Gravação de Link - ' + cOperacao + '. NF: ' + (cTRB)->F3_NFISCAL + ' [' + Dtoc(Date()) + ' - ' + TIME() + ']')	
				EndIF
			EndIF
			aEspelho := {}
			(cTRB)->( dbSkip() )
		End
	Else
		Conout('CSJB05 > Não localizou registros na query. ['+Dtoc(Date())+' - '+TIME()+']' )
	Endif
	(cTRB)->(dbCloseArea())
Return