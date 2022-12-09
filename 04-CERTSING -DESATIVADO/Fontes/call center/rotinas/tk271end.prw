//-----------------------------------------------------------------------
// Rotina | TK271END     | Autor | Robson Gon�alves   | Data | 27.08.2014
//-----------------------------------------------------------------------
// Descr. | Ponto de entrada executado no final da gravacao, ao dar o OK 
//        | na tela de atendimento e ap�s a gravacao da campanha 
//        | (caso exista uma).
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function TK271END()
	If FindFunction('U_A110TKEND')
		// Rotina contida no arquivo de c�digo-fonte CSFA110 - Agenda do Operador Certisign.
		U_A110TKEnd()
	Endif
Return