//--------------------------------------------------------------------------
// Rotina | MA130QSC | Autor | Robson Goncalves          | Data | 09.05.2016
//--------------------------------------------------------------------------
// Descr. | Ponto de entrada para incluir códigos para quebra de solicitação 
//        | de compras. LOCALIZAÇÃO : Function A130Proces() responsável pelo 
//        | processamento da solicitacoes de compra que devem gerar cotacao.
//        | EM QUE PONTO : O ponto de entrada 'MA130QSC'  é executado no 
//        | início da rotina de processamento da solicitacoes de compra que 
//        | devem gerar cotação, permitindo incluir um bloco de código que 
//        | realizará as quebras das solicitações de compras.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function MA130QSC()
	Local bQuebra := {|| C1_FILENT+C1_GRADE+C1_FORNECE+C1_LOJA+C1_PRODUTO+C1_DESCRI+Dtos(C1_DATPRF)+C1_OBS+C1_CC}
Return( bQuebra )