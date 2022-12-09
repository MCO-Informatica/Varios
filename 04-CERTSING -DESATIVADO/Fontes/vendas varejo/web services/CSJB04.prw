#Include "rwmake.ch"
#Include "topconn.ch"
#Include "Protheus.ch"
#include "fileio.ch"
#INCLUDE "TBICONN.CH"

//+--------------------------------------------------------------+
//| Rotina | CSJB04 | Autor | Rafael Beghini | Data | 27/04/2015 |
//+--------------------------------------------------------------+
//| Descr. | Rotina para Gravação da RPS com link de             |
//|        | consulta da NFSe                                    |
//+--------------------------------------------------------------+
//| Uso    | CertiSign - Faturamento                             |
//+--------------------------------------------------------------+
User Function CSJB04( aParam )
	Local lJob 		:= ( Select( "SX6" ) == 0 )
	Local cJobEmp	:= Iif( aParam == NIL, '01' , aParam[ 1 ] )
	Local cJobFil	:= Iif( aParam == NIL, '02' , aParam[ 2 ] )
	Local cSQL		:= ''
	Local cTRB		:= ''
	Local cMVJB04A  := 'MV_CSJB04A'
	Local cMVJB04B  := 'MV_CSJB04B'
	Local Mv_par01	:= ''
	Local Mv_par02	:= ''
	Local nDias		:= 0
	Local nROWNUM	:= 0
	Local nTime		:= 0
	Local nWait		:= 0
	
	If lJob
		RpcSetType( 3 )
		RpcSetEnv( cJobEmp, cJobFil )
	EndIf

	Conout( "[ CSJB04 - " + Dtoc( Date() ) + " - " + Time() + " ] INICIO" )

	If .NOT. SX6->( ExisteSX6( cMVJB04A ) )
		CriarSX6( cMVJB04A, 'N', 'Numero de dias para retroceder e realizar a query. CSJB04.prw', '05' )
	Endif

	If .NOT. SX6->( ExisteSX6( cMVJB04B ) )
		CriarSX6( cMVJB04B, 'N', 'Quantidade de registros por execução na query. CSJB04.prw', '200' )
	Endif
	
	nDias 	:= GetMv( cMVJB04A )
	nROWNUM := GetMv( cMVJB04B )
	
	Mv_par01 := dDataBase - nDias
	Mv_par02 := dDataBase - 1
	
	Conout( "[ CSJB04 - " + Dtoc( Date() ) + " - " + Time() + " ] Parâmetros de data: " + dToC(Mv_par01) + ' - ' + dToC(Mv_par02) )

	cSQL += "SELECT C6_NOTA " + CRLF
	cSQL += "FROM " + RetSqlName("SC6") + " SC6 " + CRLF
	cSQL += "       INNER JOIN " + RetSqlName("SC5") + " SC5 " + CRLF
	cSQL += "               ON SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND C5_FILIAL = C6_FILIAL " + CRLF
	cSQL += "                  AND C5_NUM = C6_NUM " + CRLF
	cSQL += "                  AND C5_XNPSITE > ' ' " + CRLF
	cSQL += "                  AND C5_XNFSFW > ' ' " + CRLF
	cSQL += "                  AND C5_LINKNFS = ' ' " + CRLF
	cSQL += "WHERE  SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND C6_FILIAL = '" + xFilial('SC6') + "' " + CRLF
	cSQL += "       AND C6_NOTA > ' ' " + CRLF
	cSQL += "       AND C6_SERIE = 'RP2' " + CRLF
	cSQL += "       AND C6_DATFAT >= '" + dTos(Mv_par01) + "' " + CRLF
	cSQL += "       AND C6_DATFAT <= '" + dTos(Mv_par02) + "' " + CRLF
	cSQL += "       AND EXISTS ( SELECT F3.R_E_C_N_O_" + CRLF
	cSQL += "                   FROM " + RetSqlName("SF3") + " F3 " + CRLF
	cSQL += "                          INNER JOIN " + RetSqlName("SF2") + " F2 " + CRLF
	cSQL += "                                  ON F2.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                                     AND F2_FILIAL = F3_FILIAL " + CRLF
	cSQL += "                                     AND F2_DOC = F3_NFISCAL " + CRLF
	cSQL += "                                     AND F2_SERIE = F3_SERIE " + CRLF
	cSQL += "                                     AND F2_NFELETR > ' ' " + CRLF
	cSQL += "                                     AND F2_CODNFE > ' ' " + CRLF
	cSQL += "                   WHERE  F3.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                          AND F3_FILIAL = '" + xFilial('SF3') + "' " + CRLF
	cSQL += "                          AND F3_NFISCAL = C6_NOTA " + CRLF
	cSQL += "                          AND F3_SERIE = 'RP2' " + CRLF
	cSQL += "                          AND F3_CODRSEF = ANY ( 'S', 'C' ) ) " + CRLF
	cSQL += "	    AND ROWNUM <= " + cValToChar(nROWNUM) + "" + CRLF

	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)

	IF .NOT. (cTRB)->( EOF() )
		While .NOT. (cTRB)->( EOF() )
			//Conout( "[ CSJB04 - " + Dtoc( Date() ) + " - " + Time() + " ] NOTA: " + (cTRB)->C6_NOTA )
			U_CSJob04( (cTRB)->C6_NOTA + 'RP2' )
			/*
			nTime := Seconds()
			While .T.
				If U_Send2Proc( (cTRB)->C6_NOTA + 'RP2', "U_CSJob04", NIL )
					Conout( "[ CSJB04 - " + Dtoc( Date() ) + " - " + Time() + " ] NOTA: " + (cTRB)->C6_NOTA )
					Exit
				Else
					nWait := Seconds() - nTime
					If nWait < 0
						nWait += 86400
					Endif

					If nWait > 15
						Conout( "[ CSJB04 - " + Dtoc( Date() ) + " - " + Time() + " ] NÃO DISTRIBUIDO" )
						EXIT
					Endif
					
					// Espera um pouco ( 5 segundos ) para tentar novamente
					Sleep(5000)
				EndIf
			EndDo
			*/
			(cTRB)->( dbSkip() )
		End
	Else
		Conout( "[ CSJB04 - " + Dtoc( Date() ) + " - " + Time() + " ] NÃO PROCESSOU REGISTROS" )
	EndIF

    (cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )		
	
	Conout( "[ CSJB04 - " + Dtoc( Date() ) + " - " + Time() + " ] FINAL" )	
Return

User Function CSJob04( cNOTA, aParam )
	Local lJob 		:= ( Select( "SX6" ) == 0 )
	Local cJobEmp	:= Iif( aParam == NIL, '01' , aParam[ 1 ] )
	Local cJobFil	:= Iif( aParam == NIL, '02' , aParam[ 2 ] )
	Local aRet	:= {}

	If lJob
		RpcSetType( 3 )
		RpcSetEnv( cJobEmp, cJobFil )
	EndIf

	Aadd( aRet, .T. )
	Aadd( aRet, '000135' )

	dbSelectArea('SF2')
	SF2->( DbSetOrder(1) )
	IF SF2->( MsSeek( xFilial("SF2") + cNOTA ) )
								
		SC6->( DbSetOrder(4) )	//C6_FILIAL+C6_NOTA+C6_SERIE
		SC6->( MsSeek( xFilial("SC6") + SF2->(F2_DOC + F2_SERIE) ) )
					
		SC5->( DbSetOrder(1) )	//C5_FILIAL+C5_NUM
		SC5->( MsSeek( xFilial("SC5") + SC6->C6_NUM ) )
		
		aRet := U_GARR020( aRet, .T. )
	EndIF
	
Return( .T. )
