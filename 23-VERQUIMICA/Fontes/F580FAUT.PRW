/*/{Protheus.doc} F580FAut
//TODO 	Ponto de entrada acionado ap?s montar o filtro do padr?o, 
		apenas trazendo os titulos do campo customizado E2_VQ_LIBP = 'S'
@author		Roberto Ramos
@since		15/01/2020
@version 	v001.02
@type		Function
@history	15/01/2020, Roberto Ramos, Cria??o do Ponto de Entrada; 
/*/
User Function F580FAut()
	
	Local cFiltro := ""
	cFiltro := ParamIXB[1]
	cFiltro += " AND E2_VQ_LIBP = 'S' "
		
Return(cFiltro)