//--------------------------------------------------------------------------
// Rotina | MA130QSC | Autor | Robson Goncalves          | Data | 09.05.2016
//--------------------------------------------------------------------------
// Descr. | Ponto de entrada para incluir c�digos para quebra de solicita��o 
//        | de compras. LOCALIZA��O : Function A130Proces() respons�vel pelo 
//        | processamento da solicitacoes de compra que devem gerar cotacao.
//        | EM QUE PONTO : O ponto de entrada 'MA130QSC'  � executado no 
//        | in�cio da rotina de processamento da solicitacoes de compra que 
//        | devem gerar cota��o, permitindo incluir um bloco de c�digo que 
//        | realizar� as quebras das solicita��es de compras.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function MA130QSC()
	Local bQuebra := {|| C1_FILENT+C1_GRADE+C1_FORNECE+C1_LOJA+C1_PRODUTO+C1_DESCRI+Dtos(C1_DATPRF)+C1_OBS+C1_CC}
Return( bQuebra )