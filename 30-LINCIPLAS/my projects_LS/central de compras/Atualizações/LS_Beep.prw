#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa		LS_BEEP
// Autor		ALEXANDRE DALPIAZ
// Data			10/10/2012
// Descricao	BEEP NO TOQUE DE ROMANEIO (OU OUTRA ROTINA)
// Uso			Laselva S/A
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 1 = quantidade de vezes
// 2 = wav.exe
// 3 = produto nao cadastrado 			(naocad.wav)
// 4 = produto nao consta no romaneio   (naotanoroma.wav)
// 5 = produto excedeu quantidade		(excedeu.wav)
// 6 = ok								(ok.wav)
// 7 = ok2								(ok2.wav)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User function LS_Beep(_nBeep)
/////////////////////////////
Default _nBeep := 0
_aSons := GetMv('LS_QTDBEEP')
_aSons := &_aSons

If _nBeep > 2 .and. _nBeep < 8 .and. !empty(_aSons[_nBeep])
	For _nI := 1 to _aSons[1]
		//waitrun('c:\spool\wav.exe ' + _aSons[_nBeep], 0)
		waitrun(__RelDir + 'wav.exe ' + __RelDir + _aSons[_nBeep], 0)
	Next
EndIf

Return( Nil )


