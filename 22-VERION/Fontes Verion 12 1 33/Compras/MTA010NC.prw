//------------------------------------------------------------------------------------------------------------------------------//
//LOCALIZAÇÃO: Function A010LEREG - Função chamada na inclusão do Produto, quando ativado o botão Cópia.                        //
// EM QUE PONTO :  No início da Função, antes do processamento dos campos a serem copiados, deve ser utilizado para relacionar  //
// os campos que NÃO DEVEM SER COPIADOS na inclusão (acionando o botão CÓPIA), através do retorno de um array contendo a lista  //
// dos campos que não devem ser copiados do produto posicionado.                                                                //
//------------------------------------------------------------------------------------------------------------------------------//
User Function MTA010NC()
Local aCpoNC := {}
AAdd( aCpoNC, 'B1_PRV1   ')
AAdd( aCpoNC, 'B1_UCOM   ')
AAdd( aCpoNC, 'B1_PRATEL ')
AAdd( aCpoNC, 'B1_VERCOM ')
AAdd( aCpoNC, 'B1_VEREND ')
AAdd( aCpoNC, 'B1_UREV   ')
AAdd( aCpoNC, 'B1_DATREF ')
AAdd( aCpoNC, 'B1_DTREFP1')    
AAdd( aCpoNC, 'B1_UPRC   ')
AAdd( aCpoNC, 'B1_PESO   ')
AAdd( aCpoNC, 'B1_CODIMP ')    
AAdd( aCpoNC, 'B1_VERVEN ')          
AAdd( aCpoNC, 'B1_CONINI ') 
AAdd( aCpoNC, 'B1_FTLUCRO')          
AAdd( aCpoNC, 'B1_VLCUSTO')          
AAdd( aCpoNC, 'B1_VLBRUTO')
AAdd( aCpoNC, 'B1_VLFIM1 ')
AAdd( aCpoNC, 'B1_VLFIM2 ')
AAdd( aCpoNC, 'B1_VLFIM3 ')
AAdd( aCpoNC, 'B1_VLFIM4 ')
AAdd( aCpoNC, 'B1_VLFIM5 ')
AAdd( aCpoNC, 'B1_VLFIM6 ')
AAdd( aCpoNC, 'B1_VLFIM7 ')

Return (aCpoNC)