#Include 'Protheus.ch'

User Function zCTDVCamb()

	Local _cVlrCamb
	Local dDTInv := dtos(M->CTD_XDTCB)
	Local cMoeda 	:=  M->CTD_XTPMOE


	dbSelectArea("SM2")
	SM2->( dbSetOrder(1) )

	If SM2->( dbSeek( dDTInv ) )

		IF cMoeda = "1"
			_cVlrCamb := 0
		elseIF cMoeda = '2'
			_cVlrCamb := SM2->M2_MOEDA2
		elseIF cMoeda = "3"
			_cVlrCamb := SM2->M2_MOEDA3
		elseIF cMoeda = "4"
			_cVlrCamb := SM2->M2_MOEDA4

		ENDIF
	ELSE·
			cVlrCamb := 0
	END IF

Return _cVlrCamb

