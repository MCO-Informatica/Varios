#Include 'Protheus.ch'

User Function calcVlrHr()

	Local _cData 	:= 	SUBSTR(DTOC(dDatabase),4,7)
	Local _cIC		:= 	alltrim(M->Z4_ITEMCTA)
	Local _nVLHR 	:= 0
	Local nQTDHRS
	Local _nResult

	dbSelectArea("SZ5")
	SZ5->( dbSetOrder(4) )

	If alltrim(_cIC) == "PROPOSTA"
		//msginfo ( _cData )
		If SZ5->( dbSeek( xFilial("SZ5")+_cDATA+"PROPOSTA") )
			_nVLHR  		:= SZ5->Z5_VLRHR
		else
			_nVLHR  		:=  0
		ENDIF
	elseif !alltrim(_cIC) $ ("ADMINISTRACAO'/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/ESTOQUE/OPERACOES")
		If SZ5->( dbSeek( xFilial("SZ5")+_cDATA+"CONTRATO") )
			_nVLHR  		:= SZ5->Z5_VLRHR
		else
			_nVLHR  		:=  0
		ENDIF
	else
		_nVLHR  		:=  0
	Endif



Return _nVLHR

