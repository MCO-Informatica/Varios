#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"
                                                              
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	SF2520E
// Autor 		Alexandre Dalpiaz
// Data 		30/08/10
// Descricao  	Ponto de entrada na gera��o da nota fiscal de saida. Depende do PE CHGX5FI, onde � criada a vari�vel p�blica _cNumNFX5F com o n�mero correto da nota
//				fiscal, no caso da gera��o de NF atr�ves de romaneios. Foi constatado erro na numera��o quando a s�rie utilizada pela loja � igual ao inicio de alguma
//				outra s�rie (no caso, a s�rie 2 estava conflitando com a s�rie 223 da loja 22, iguatemi)
// Uso         	LaSelva
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function _M460NUM()
///////////////////////

DbSelectArea('SM0')
_cCnpj := SM0->M0_CGC
Set Filter to  SM0->M0_CGC == _cCnpj .and. SM0->M0_CODIGO == cEmpAnt
_cFiliais := ''
Do While !eof()
	_cFiliais += SM0->M0_CODFIL + ','
	DbSkip()
EndDo
Set Filter To
DbSeek(cEmpAnt+cFilAnt)
_cFiliais := FormatIn(left(_cFiliais,len(_cFiliais)-1),',')

_cSerie     := left(alltrim(cSerie) + '    ',3)
_cNumNFX5F := alltrim(Posicione('SX5',1,cFilAnt + '01' + _cSerie,'X5_DESCRI'))

DbSelectArea('SX5')
_xFilial := strtran(strtran(strtran(strtran(_cFiliais,"'",""),"(",""),")",""),",","")
For _nI := 1 to len(_xFilial) step 2
	If DbSeek(substr(_xFilial,_nI,2) + '01' + _cSerie,.f.)
		Do While !RecLock('SX5',.f.)
			SX5->X5_DESCRI  := _cNumNFX5F
			SX5->X5_DESCSPA := _cNumNFX5F
			SX5->X5_DESCENG := _cNumNFX5F
		EndDo    
		MsUnLock() 
	EndIf
Next
Return()
