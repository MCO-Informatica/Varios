#INCLUDE "rwmake.ch"

// Programa: LS_NATDBCR
// Autor   : Alexandre Dalpiaz
// Data    : 04/06/2012
// Função  : x3_relacao campos CTJ_DEBITO / CTJ_CREDITO
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_NATDBCR(_xDC)
//////////////////////////////
Local _cConta := ''
//If FunName() $ 'FINA750/FINA050' .and. (_xDC == 'DB' .and.!(alltrim(M->E2_NATUREZ) $ Formula('R01')) .or. (_xDC == 'CR' .and. (alltrim(M->E2_NATUREZ) $ Formula('R01'))))

If FunName() $ 'FINA750/FINA050' .and. ((_xDC == 'DB' .and. !(alltrim(M->E2_NATUREZ) $ Formula('R01'))) .or. (_xDC == 'CR' .and. (alltrim(M->E2_NATUREZ) $ Formula('R01'))))
	_cConta := Posicione('SED',1,xFilial('SED') + M->E2_NATUREZ,'ED_CONTA')
EndIf                    
 
Return(_cConta)               


//(_xDC == 'DB' .and.!(alltrim(M->E2_NATUREZ) $ Formula('R01')) .or. (_xDC == 'CR' .and. (alltrim(M->E2_NATUREZ) $ Formula('R01'))
