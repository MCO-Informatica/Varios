//------------------------------------------------------------------
// Rotina | TMKBARLA  | Autor | Robson Luiz - Rleg | Data | 26/04/13
//------------------------------------------------------------------
// Descr. | Ponto de entrada para adicionar bot�o na barra lateral 
//        | do atendimento Televendas.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function TMKBARLA(aBtnLat,aTitles)
	AAdd(aBtnLat,{'ORGIMG16'  ,{|| U_CSFA140(1)},'Busca c�digo produto GAR...'} )
	AAdd(aBtnLat,{'EDITWEB'   ,{|| U_CSFA140(2)},'Visualizar link da web relativo ao c�digo do produto GAR...'} )
	AAdd(aBtnLat,{'RADAR.PNG' ,{|| U_PESQCONT('TMK_SUC_SUD')},'Pesquisa global empresas e seus contatos...'} )
Return(aBtnLat)