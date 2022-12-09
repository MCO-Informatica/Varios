#Include 'Protheus.ch'
//---------------------------------------------------------------------
// Rotina | MA103OPC  | Autor | Rafael Beghini      | Data | 06.04.2018
//---------------------------------------------------------------------
// Descr. | PE - Inclusão de opções na mBrowse - Documento de entrada
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------
User Function MA103OPC()
	Local aRET := {}

	aADD( aRET, {'® Rastrear LP'  ,'U_CSCTB01("SF1",SF1->F1_DOC,SF1->F1_FORNECE,SF1->F1_LOJA,SF1->F1_DTLANC,SF1->(RECNO()))', 0, 7})
	aADD( aRET, {'® Alterar Série','U_CSMAT103("1",SF1->(RECNO()))', 0, 7} )
Return aRet