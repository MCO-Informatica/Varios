//-----------------------------------------------------------------------
// Rotina | TK271END     | Autor | Robson Gonçalves   | Data | 27.08.2014
//-----------------------------------------------------------------------
// Descr. | Ponto de entrada executado no final da gravacao, ao dar o OK 
//        | na tela de atendimento e após a gravacao da campanha 
//        | (caso exista uma).
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function TK271END()
	If FindFunction('U_A110TKEND')
		// Rotina contida no arquivo de código-fonte CSFA110 - Agenda do Operador Certisign.
		U_A110TKEnd()
	Endif
Return