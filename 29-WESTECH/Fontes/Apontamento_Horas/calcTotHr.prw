#Include 'Protheus.ch'

User Function calcTotHr()

	Local _cData 	:= 	SUBSTR(DTOC(dDatabase),4,7)
	Local _cIC		:= 	alltrim(M->Z4_ITEMCTA)
	Local nVLHR		:= 0
	Local nQTDHRS
	Local _nResult

	dbSelectArea("SZ5")
	SZ5->( dbSetOrder(4) )

	If alltrim(_cIC) == "PROPOSTA"
		If SZ5->( dbSeek( xFilial("SZ5")+_cDATA+"PROPOSTA") )
			nVLHR  		:= SZ5->Z5_VLRHR
		else
			nVLHR  		:=  0
		ENDIF
	elseif !alltrim(_cIC) $ ("ADMINISTRACAO'/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/ESTOQUE/OPERACOES")

		If SZ5->( dbSeek( xFilial("SZ5")+_cDATA+"CONTRATO") )
			nVLHR  		:= SZ5->Z5_VLRHR
		else
			nVLHR  		:=  0
		ENDIF
	//else
		//nVLHR  		:=  0
	Endif

	nQTDHRS	:= M->Z4_QTDHRS
	_nResult := nQTDHRS * nVLHR

Return _nResult

