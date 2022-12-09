//-----------------------------------------------------------------------
// Rotina | CSFA150    | Autor | Robson Gonçalves     | Data | 15.05.2013
//-----------------------------------------------------------------------
// Descr. | Rotina acionada pelo Ponto de entrada TKSU9FIL, o objetivo e
//        | apresentar a descrição do tipo da ocorrência junto com o 
//        | código da ocorrência.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CSFA150(aDADOS)
	Local nI := 0
	Local nP := 0
	Local cAssunto := ''
	If ValType(aHeader) == 'A'
		nP := AScan( aHeader,{|p| p[2]=='UD_ASSUNTO'})
		If nP > 0
			If ValType(N) == 'N'
				If ValType(aCOLS) == 'A'
					cAssunto := aCOLS[ N, nP ]
					SUX->(dbSetOrder(1))
					SU9->(dbSetOrder(1))
					For nI := 1 To Len(aDADOS)
						If SU9->(dbSeek(xFilial('SU9')+cAssunto+aDADOS[nI,1]))
							If SUX->(dbSeek(xFilial('SUX')+SU9->U9_TIPOOCO))
								If !Empty(SUX->UX_DESTOC)
									aDADOS[nI,2] := RTrim(aDADOS[nI,2])+' - '+RTrim(SUX->UX_DESTOC)
								Endif
							Endif
						Endif
					Next nI
				Endif
			Endif
		Endif
	Endif
Return(aDADOS)