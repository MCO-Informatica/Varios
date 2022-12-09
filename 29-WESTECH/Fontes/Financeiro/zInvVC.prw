#Include 'Protheus.ch'

User Function zInvVC()
	Local _cVlrCam
	Local dDTInv := dtos(M->ZZC_DTCOT)
	Local cMoeda 	:=  M->ZZC_MOEDIN


	dbSelectArea("SM2")
	SM2->( dbSetOrder(1) )

	If SM2->( dbSeek( dDTInv ) )

		IF cMoeda = "1"
			_cVlrCam := 0
		elseIF cMoeda = '2'
			_cVlrCam := SM2->M2_MOEDA2
		elseIF cMoeda = "3"
			_cVlrCam := SM2->M2_MOEDA3
		elseIF cMoeda = "4"
			_cVlrCam := SM2->M2_MOEDA4

		ENDIF
	ELSE·
			cVlrCam := 0
	END IF

Return _cVlrCam

