#Include "Protheus.ch"
#Include "Rwmake.ch"



User Function RGPEA001

    Processa({|| RunProc()},"Processando...")
    Alert("FIM")

Return

//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑ 						Chamada da Rotina.                              บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ

Static Function RunProc()


    dbSelectArea("SRD")
    dbSetOrder(1)
    dbGoTop()

    While Eof() == .f.
    /*
        If SRD->RD_DATARQ $ '201305'
		Reclock("SRD",.F.)
		RD_DEPTO	:= "MAIO"
   		MsUnlock()
        Endif
    
    
        If SRD->RD_DATARQ $ '201306'
		Reclock("SRD",.F.)
		RD_DEPTO	:= "JUNHO"
   		MsUnlock()
        EndIf
	*/
        If SRD->RD_DATARQ $ '201307'
            Reclock("SRD",.F.)
            RD_DEPTO	:= "JULHO"
            MsUnlock()
        EndIf


        dbSkip()
    EndDo

Return
