#INCLUDE "RWMAKE.CH"

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Para utilizar este RDMAKE, preencha no conteudo do parametro MV_LJFISMS    ?
//? com a seguinte expressao:                                                  ?
//? "&ExecBlock("LJMSGCUP",.F.,.F.,{lUsaRegime,lEntrega,lUsaCartao,lFuturoTef})?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿗JMsgCup  튍utor  쿑ernando Salvatori  ? Data ?  25/04/2003 볍?
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
굇튒esc.     ? Imprime a mensagem no cupom fiscal                         볍?
굇?          ? Utilizado no parametro MV_LJFISMS                          볍?
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
굇튧so       ? Rdmake Padrao                                              볍?
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
*/
User Function LJMSGCUP()
Local _lUsaRegime := ParamIXB[1] //Verifica se utiliza o Regime Especial
Local _lEntrega   := ParamIXB[2] //Verifica se utiliza Entrega 
Local _lUsaCartao := ParamIXB[3] //Verifica se a venda esta utilizando cartao de credito/debito
Local _lFuturoTef := ParamIXB[4] //Verifica se a venda esta utilizando cartao de credito/debito
Local _aAreaSA1   := SA1->( GetArea() )         //Area do arquivo SA1
Local _aArea      := GetArea()                  //Area atual do sistema
Local _cRet       := "Obrigado! Volte Sempre!"  //Mensagem de retorno

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿏ocumentacao das variaveis:                                         ?
//?                                                                    ?
//?_lUsaRegime:                                                        ?
//?     .F. -> Indica que a venda via TEF nao utiliza o Regime Especial?
//?     .T. -> Indica que a venda via TEF utiliza Regime Especial      ?
//?_lEntrega                                                           ?
//?     .T. -> Orcamento "Entrega"                                     ?
//?     .F. -> Orcamento "Retira"                                      ?
//?_lUsaCartao                                                         ?
//?     .T. -> Utiliza Cartao de Credito/Debito (CC,CD)                ?
//?     .F. -> Nao utiliza cartao                                      ?
//?_lFuturoTef                                                         ?
//?     .F. -> Caso utilize o Regime, sera impresso como forma         ?
//?            de pagamento a frase "FUTURO TEF"                       ?
//?     .T. -> Caso utilize o Regime, sera impresso como forma         ?
//?            de pagamento a frase "RECEPCAO TEF"                     ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
    
If _lUsaRegime .And. _lEntrega .And. _lUsaCartao .And. !_lFuturoTef	
	dbSelectArea( "SA1" )
	dbSetOrder( 1 )
	dbSeek( xFilial( "SA1" ) + SL1->L1_CLIENTE + SL1->L1_LOJA )
	
	_cRet := Trim(SA1->A1_NOME) + " " +Trim(SA1->A1_END) + " " +Trim(SA1->A1_CGC)
EndIf

SA1->( RestArea(_aAreaSA1) )   
RestArea( _aArea )

Return _cRet
