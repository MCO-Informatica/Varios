#INCLUDE "PROTHEUS.CH"

////////////////////////////////////////////////////////////////////////////////////
//                                                                                //
//  Fun??o:    F240TDOK 										M?dulo: SIGAFIN   //
//                                                                                //
//  Autor:     Denis Guedes  							Data: 27/10/2013          //
//                                                                                //
//  Descri??o: Pontos de Entrada na gera??o do Border? a fim de alimentar vari?vel //
//             p?blica para ser utilizada pelo ponto de entrada F240TBOR           //
//                                                                                //
////////////////////////////////////////////////////////////////////////////////////

User Function F240TDOK()
Local peAliasSE2 := paramixb[2]
Local lRetorno := .t.
Public _nTotSelec := 0
//Public _cMarca  := GetMark()
Public &(__cuserid) := 0
Public _cMarcaAtu := GetMark() 

//Alert("1"+_cMarcaAtu)

While !(peAliasSE2)->(Eof())
	//If !Empty( paramixb[1] )
	If !Empty((peAliasSE2)->E2_OK)
		_nTotSelec++
	EndIf
  
	(peAliasSE2)->(dbSkip())
EndDo 

Return lRetorno 
