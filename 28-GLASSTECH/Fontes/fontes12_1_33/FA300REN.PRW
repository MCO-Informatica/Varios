/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออ?อออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFA300REN  บAutor  ณS้rgio Santana      บ Data ณ  21/08/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ         r
ฑฑบDesc.     ณ Rotina para mover o arquivo  processado para a pasta Lidos บฑฑ
ฑฑบ          ณ de acordo com ultima pasta selecionada.                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Glastech                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#Include 'Protheus.ch'

User Function FA300REN()

	Local _nPos := 0
	Local _cMoveArq := ''
	
	_nPos := rAt( '\', mv_par04 )
	_cMoveArq := Substr( mv_par04, 1, _nPos )
	_cMoveArq += 'Lidos\'
	_nPos ++
	_cMoveArq += rTrim( Substr( mv_par04, _nPos ) )
	

   If fRenameEx( rTrim( mv_par04 ), _cMoveArq ) = -1

      MsgStop('Falha na opera็ใo 3 : fError ' + Str( fError(),4 ) )

   End

   If ValType( _oProcess ) <> 'U'

      aAdd( ( _oHtml:ValByName( "t1.1" ) ), ' ' )
      aAdd( ( _oHtml:ValByName( "t1.b" ) ), ' ' )
      aAdd( ( _oHtml:ValByName( "t1.2" ) ), ' ' )
      aAdd( ( _oHtml:ValByName( "t1.3" ) ), ' ' )
      aAdd( ( _oHtml:ValByName( "t1.4" ) ), 'TOTAL' )
      aAdd( ( _oHtml:ValByName( "t1.5" ) ), ' ' )
      aAdd( ( _oHtml:ValByName( "t1.6" ) ), ' ' )
      aAdd( ( _oHtml:ValByName( "t1.7" ) ), TRANSFORM( _nValPagto, '@E 99,999,999.99' ) )
      aAdd( ( _oHtml:ValByName( "t1.8" ) ), ' ' )		                     
      aAdd( ( _oHtml:ValByName( "t1.9" ) ), ' ' )
      aAdd( ( _oHtml:ValByName( "t1.a" ) ), ' ' )
      aAdd( ( _oHtml:ValByName( "t1.c" ) ), ' ' )	

	  //Desabilitado temporariamente at้ que o WF seja normalizado.
	  //return

	  _oProcess:cPriority := ' '
	  _oProcess:cTo := 'iovanne@thermoglass.com.br;pedropaulo@thermoglass.com.br;sergio.santana@thermoglass.com.br'
	  _oProcess:Start()           
	  _oProcess:Finish()
	  _oProcess:Free()
	  _oProcess := NIL
	  
   End

Return()