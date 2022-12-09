//--------------------------------------------------------------------------
// Rotina | GMMA410BUT | Autor | Robson Gonçalves        | Data | 27.03.2017
//--------------------------------------------------------------------------
// Descr. | Ponto de entrada para adicionar opções no botão Ações 
//        | Relacionadas no pedido de vendas.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function GMMA410BUT()
	Local aButton := {}
	Local aParam := {}
	Local nOpc := 0
	
	aParam := aClone( ParamIXB )
	
	nOpc := aParam[ 1 ]
	
	If ( aRotina[ nOpc, 4 ] == 2 .Or. aRotina[ nOpc, 4 ] == 6 )
		AAdd(aButton,{ "BMPVISUAL", {|| U_CSFA810() }, '® Docto Fiscal', '® Docto Fiscal' } )
	Endif
Return(aButton)