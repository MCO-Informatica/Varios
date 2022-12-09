#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"
                                                              
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	SF2520E
// Autor 		Alexandre Dalpiaz
// Data 		30/08/10
// Descricao  	Ponto de entrada na geração da nota fiscal de saida. Depende do PE CHGX5FI, onde é criada a variável pública _cNumNFX5F com o número correto da nota
//				fiscal, no caso da geração de NF atráves de romaneios. Foi constatado erro na numeração quando a série utilizada pela loja é igual ao inicio de alguma
//				outra série (no caso, a série 2 estava conflitando com a série 223 da loja 22, iguatemi)
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
