#Include 'Protheus.ch'
//--------------------------------------------------------------------------
// Rotina | F050ISS    | Autor | Rafael Beghini        | Data | 08.05.2018
//--------------------------------------------------------------------------
// Descr. | PE - Realiza alterações na geração do título do tipo ISS
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function F050ISS()
	Local dDtVen := StoD( AnoMes( SE2->E2_VENCREA ) + '01' )
	Local cMV_F050ISS := GetNewPar('MV_F050ISS', '01|04')
	Local nDias := GetMv("MV_DIAISS",.F.)
	Local nL	:= 0
	//Para Filiais 01/04, deve-se avaliar dias úteis.
	IF SE2->E2_FILORIG $ cMV_F050ISS
		For nL := 1 To nDias
			dDtVen := DataValida( dDtVen, .T. )
			IF( nL < nDias, dDtVen := DaySum(dDtVen, 1), dDtVen )
		Next nL
		
		IF SE2->E2_VENCREA <> dDtVen
			RecLock("SE2",.F.)
			SE2->E2_VENCTO	:= dDtVen
			SE2->E2_VENCREA := dDtVen
			MsUnlock()
		EndIF
	EndIF
Return NIL