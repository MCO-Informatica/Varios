#include 'protheus.ch'
#include 'parmtype.ch'

user function PONAPO3()
	local aMarc 	 := PARAMIXB[1] //Array com marca??es
	local aTabCalend := PARAMIXB[2] //Array com calendario padrao

	U_CSRHPE01(aMarc, aTabCalend, cPerAponta)
return