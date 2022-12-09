#include 'totvs.ch'
//-------------------------------------------------------------------------
// Rotina | CN130PGRV     | Autor | Rafael Beghini      | Data | 11/09/2015
//-------------------------------------------------------------------------
// Descr. |Ponto de entrada acionado no término da gravação da Medição. 
// 		  |Atualiza o campo CNE_VLDESC com o valor do desconto. 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
User Function CN130PGRV()
	Local nOpcao    := ParamIxb[1]
	Local cMV_650PROC := 'MV_650PROC'
	
	Local aCABEC := {CND->CND_FILIAL,CND->CND_CONTRA,CND->CND_REVISA,CND->CND_NUMMED,CND->CND_COMPET,Date()}
	Local aITENS := {}
	Local cPROD  := ''
	Local nOpcao     := ParamIxb[1]
	Local n          
	Local _nValTotal := ""
	Local _nVlDesc	 := ""
	Local _nTotMed 	 := 0
	Local _nDesCab 	 := CND->CND_DESCME
	
	IF nOpcao == 3 .And. !lAuto
		SB1->( dbSetOrder(1) )
		CNE->( dbSetOrder(1) )
		CNE->( dbSeek( CND->(CND_FILIAL+CND_CONTRA+CND_REVISA+CND_NUMERO+CND_NUMMED) ) )
		While CNE->( !Eof() ) .And. CNE->CNE_FILIAL == CND->CND_FILIAL .And. CNE->CNE_NUMMED == CND->CND_NUMMED
			IF CNE->CNE_QUANT > 0
				SB1->( MsSeek(CNE->CNE_FILIAL + CNE->CNE_PRODUT) )
				cPROD := rTrim( SB1->B1_DESC )
					
				aADD( aITENS, {CNE->CNE_ITEM, CNE->CNE_PRODUT, cPROD, CNE->CNE_QUANT, CNE->CNE_VLUNIT, CNE->CNE_VLTOT} )
			EndIF
		CNE->( dbSkip() )
		End
		IF Len( aITENS ) > 0
			IF GetMv( cMV_650PROC, .F. ) == '1' //Parâmetro habilitado para envio de e-mail
				//Rotina que envia e-mail sobre medição
				U_A650Med( aCABEC, aITENS, .F. )
			EndIF
		EndIF

		CNE->( dbSeek( CND->(CND_FILIAL+CND_CONTRA+CND_REVISA+CND_NUMERO+CND_NUMMED) ) )

		FOR n := 1 to Len(aCols)
		_nValTotal := aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "CNE_VLTOT" })]
		_nVlDesc   := aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "CNE_VLDESC" })]
		IF !aCols[n][Len(aHeader)+1]
			IF aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "CNE_QUANT" })] > 0
				_nTotMed += _nValTotal
			ENDIF
				//_nTotMed := _nTotMed - _nDesCab
		ENDIF
		NEXT n
		
		
    	While CNE->( !Eof() ) .And. CNE->CNE_FILIAL == CND->CND_FILIAL .And. CNE->CNE_NUMMED == CND->CND_NUMMED
			
			RecLock("CNE",.F.)
			CNE->CNE_VLDESC := Round((_nDesCab*((CNE->CNE_VLTOT/_nTotMed)*100)/100),2)
			CNE->CNE_PDESC	:= Round(((_nDesCab/_nTotMed)*100),2)
			MsUnLock()
				
			CNE->( dbSkip() )
		End
	EndIF
	
	IF EMPTY(M->CND_COMPET)
		M->CND_COMPET := StrZero(Month(dDatabase),02)+'/'+StrZero(Year(ddatabase),4)
	EndIF    
		
Return
