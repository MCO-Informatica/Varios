//--------------------------------------------------------------------------
// Rotina | MTALCALT   | Autor | Robson Goncalves        | Data | 18.01.2016
//--------------------------------------------------------------------------
// Descr. | Ponto de Entrada utilizado para alteração da tabela SCR 
//        | (Documentos com alçada) após operação de inclusão.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function MTALCALT()
	Local aArea := {}
	//-------------------------------------------------------------------------------
	// Rotina com o objetivo de verificar no vínculo funcional o status do aprovador.
	If SAK->( FieldPos( 'AK_VINCULO' ) ) > 0
		aArea := GetArea()
		U_A610VFun()
		RestArea( aArea )
	Endif
Return