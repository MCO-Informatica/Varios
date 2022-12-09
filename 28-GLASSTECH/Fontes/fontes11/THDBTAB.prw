#include "protheus.ch"

user function ThDbTab()

	Local cArquivoAnterior := ""
	
	SX2->(dbSelectArea("SX2"))
	SX2->(dbgotop())
	
	while !SX2->(eof())
		if SX2->X2_CHAVE == "SX2"
			SX2->(dbskip())
		endif
	
		if cArquivoAnterior != SX2->X2_CHAVE
			ChkFile(SX2->X2_CHAVE)
			cArquivoAnterior := SX2->X2_CHAVE
		endif
		SX2->(dbskip())
	end
	
	Alert("Concluido")

return