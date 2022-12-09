//--------------------------------------------------------------------------
// Rotina | MTALCALT   | Autor | Robson Goncalves        | Data | 18.01.2016
//--------------------------------------------------------------------------
// Descr. | Ponto de Entrada utilizado para altera��o da tabela SCR 
//        | (Documentos com al�ada) ap�s opera��o de inclus�o.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function MTALCALT()
	Local aArea := {}
	//-------------------------------------------------------------------------------
	// Rotina com o objetivo de verificar no v�nculo funcional o status do aprovador.
	If SAK->( FieldPos( 'AK_VINCULO' ) ) > 0
		aArea := GetArea()
		U_A610VFun()
		RestArea( aArea )
	Endif
Return