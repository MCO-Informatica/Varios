User Function MT105GRV()

//----> VERIFICA SE FOI CHAMADO INCLUSAO PELO PMS
    If !Alltrim(FunName())$"MATA105"

//	dbSelectArea("AFH")
//	dbSetOrder(1)
//	If !dbSeek(xFilial("AFH")+AF9->AF9_PROJET+AF9->AF9_REVISA+AF9->AF9_TAREFA+SCP->CP_NUM+SCP->CP_ITEM,.F.)
        If Alltrim(ProcName(3)) == "A105INCLUI"

            dbSelectArea("AFH")
            RecLock("AFH",.t.)
            AFH->AFH_FILIAL		:=	xFilial("AFH")
            AFH->AFH_PROJET		:=	AF9->AF9_PROJET
            AFH->AFH_TAREFA		:=	AF9->AF9_TAREFA
            AFH->AFH_QUANT		:=	SCP->CP_QUANT
            AFH->AFH_NUMSA		:=	SCP->CP_NUM
            AFH->AFH_ITEMSA		:=	SCP->CP_ITEM
            AFH->AFH_REVISA		:=	AF9->AF9_REVISA
            AFH->AFH_COD		:=	SCP->CP_PRODUTO
            MsUnLock()
        Elseif Alltrim(procname(3)) == "A105ALTERA"

            dbSelectArea("AFH")
            RecLock("AFH",.f.)
            AFH->AFH_QUANT		:=	SCP->CP_QUANT
            MsUnLock()
        Elseif Alltrim(ProcName(3)) == "A105DELETA"

//		Alert("EXCLUI")

        EndIf

    EndIf

Return
