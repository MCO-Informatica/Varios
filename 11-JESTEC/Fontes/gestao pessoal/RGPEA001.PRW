#Include "Protheus.ch"
#Include "Rwmake.ch"



User Function RGPEA001

    Processa({|| RunProc()},"Processando...")
    Alert("FIM")

Return

//臼麺様様様様謡様様様様様瞥様様様詫様様様様様様様様様擁様様様詫様様様様様様恒?
//臼 						Chamada da Rotina.                              艮?
//臼麺様様様様謡様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様恒?

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
