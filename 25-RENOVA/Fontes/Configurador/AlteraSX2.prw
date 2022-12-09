// Este rdmake altera as propriedades do SX2

#INCLUDE "Protheus.ch"

User Function AlteraSX2 // U_AlteraSX2()
Local cX2Arquivo

dbSelectArea("SX2")
dbSetOrder(1)

If dbSeek("AK1")
	Do While ! Eof() .And. SX2->X2_CHAVE < "AM0"         
		cX2Arquivo := Alltrim(SX2->X2_CHAVE) + cEmpAnt + "0"

		RecLock("SX2", .F.)

		// informe aqui a alteração desejada

		If Alltrim(SX2->X2_CHAVE) $ "AK5/AK6/AK8/AK9/AKA/AKB/AKC/AKF/AKH/AKI/AKJ/AKK/AKL/AKM/AKN/AKO/AKP/AKQ/AKV/AKW/AL1/AL2/AL3/AL4/AL5/AL8/AL9"
			SX2->X2_ARQUIVO := Alltrim(SX2->X2_CHAVE) + "030"
			SX2->X2_MODO	:= "C"
			SX2->X2_MODOUN	:= "C"
			SX2->X2_MODOEMP	:= "C"

		Else
			SX2->X2_ARQUIVO := cX2Arquivo
		Endif

		MsUnlock()

		dbSkip()
	Enddo
Endif

Return