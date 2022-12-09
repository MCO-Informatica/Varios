//-----------------------------------------------------------------------
// Rotina | TKSU9FIL   | Autor | Robson Gonçalves     | Data | 15.05.2013
//-----------------------------------------------------------------------
// Descr. | Ponto de entrada acionado antes de apresentar as ocorrências
//        | para o usuário selecionar.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function TKSU9FIL()
	Local aDADOS := {}
	aDADOS := ParamIXB[1]
	If Len(aDADOS) > 0
		aDADOS := U_CSFA150(aDADOS)
		If ValType(aDADOS)<>'A'
			aDADOS := {}
		Endif
	Endif
Return(aDADOS)