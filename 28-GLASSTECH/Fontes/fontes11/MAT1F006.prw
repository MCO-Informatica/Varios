#include 'protheus.ch'

// Função responsável por fazer a regra para preenchimento do NCM
// Regra feita por Sidnei Vilela
// Usado no disparo do gatilho da regra de negócio
user function MAT1F006()
		
	local cRegraNegocio := M->B1_ITEMCC
	local nAreaBruta := M->B1_ZZBRUTA
	local nIpi := M->B1_IPI
	local cNcm := M->B1_POSIPI
	local aRegras := {}
	
	// Vincula a regra de negócio com o código NCM
	aRegras := {;
		'CML', '70072100';
		,'MML', '70072100';
		,'CMT', '70071100';
		,'CRT', '70071100';
		,'CRL', '70072100';
		,'MMT', '70071100';
		,'OML', '70072100';
		,'OMT', '70071100';
		,'INL', '70072100';
		,'INT', '70071100'; 
		,'LBF', '70071900';
		,'LBM', '70071900';
		,'ARL', '87082999';
		,'ART', '87082999';
		,'AMR', '70072100';	
		,'AMT', '70071100';
		,'LBQ', '70071900';
		,'OUT', '70071900';
		,'ORT', '87082999';
		,'ORL', '87082999';
		,'MRT', '70071100';
		,'MRL', '70072100';
		,'EM' , '99999999'}
	
	
	_nIndice = AScan(aRegras, {|cNcm| cNcm == AllTrim(cRegraNegocio)}) + 1
	cNcm := aRegras[_nIndice]
	
	M->B1_POSIPI := cNcm
	
	if (cNcm == '70072100')
		nIpi := 15
		
		if (U_NcmExc(nAreaBruta, .F.))
			nIpi := 3
		endif
	end else 
	if (cNcm == '70071100')
		nIpi := 15
		
		if (U_NcmExc(nAreaBruta, .T.))
			nIpi := 3
		endif
	end else 
	if (cNcm == '70071900')
		nIpi := 10
	end else 
	if (cNcm == '87082999')
		nIpi := 5
	endif
		
	M->B1_IPI := nIpi
	
return cNcm

// Verifica se a área está na exceção
user function NcmExc(nArea, bTemperado)

	local bReturn := .F.
	
	if (bTemperado == .F.)
		// 1.633 - 0.08165
		if (nArea >= 1.551 .and. nArea <= 1.715)
			bReturn := .T.
		endif
		// 1.56 - 0.078
		if (nArea >= 1.482 .and. nArea <= 1.638)
			bReturn := .T.
		endif
		// 1.44 - 0.072
		if (nArea >= 1.368 .and. nArea <= 1.512)
			bReturn := .T.
		endif
		// 0.97 - 0.048
		if (nArea >= 0.922 .and. nArea <= 1.018)
			bReturn := .T.
		endif
		// 1.6055 - 0.080
		if (nArea >= 1.53 .and. nArea <= 1.69)
			bReturn := .T.
		endif
	endif
	
	if (bTemperado == .T.)
		// 0.973 - 0.05
		if (nArea >= 0.923 .and. nArea <= 1.023)
			bReturn := .T.
		endif
		// 0.638 - 0.031
		if (nArea >= 0.607 .and. nArea <= 0.669)
			bReturn := .T.
		endif
		// 0.355 - 0.018
		if (nArea >= 0.337 .and. nArea <= 0.373)
			bReturn := .T.
		endif
		// 0.97 - 0.048
		if (nArea >= 0.922 .and. nArea <= 1.018)
			bReturn := .T.
		endif
		// 0.141 - 0.007
		if (nArea >= 0.134 .and. nArea <= 0.148)
			bReturn := .T.
		endif
		// 0.357 - 0.018
		if (nArea >= 0.339 .and. nArea <= 0.375)
			bReturn := .T.
		endif
	endif

return bReturn
