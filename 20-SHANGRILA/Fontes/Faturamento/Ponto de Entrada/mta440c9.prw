/*
------------------------------------------------------------------------------
Programa : MTA440C9			| Tipo: Ponto de Entrada		| Rotina: MATA440
Data     : 19/03/07                                                        
Autor    : Gildesio Campos
------------------------------------------------------------------------------
Descricao: Na liberacao do PV deverá gravar o campo C9_X_TES 
------------------------------------------------------------------------------
*/
User Function MTA440C9()
SC9->C9_X_TES := SC6->C6_TES 
Return()              
