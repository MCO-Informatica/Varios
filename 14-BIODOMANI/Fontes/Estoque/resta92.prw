#INCLUDE "PROTHEUS.CH"

User Function RESTA92()

    //CriaPerg()
    
    //Pergunte("RESTA92",.T.)

    processa({||RunProc()},"Ajusta Tabelas SDA/SDB")
return

Static Function RunProc()

    dbSelectArea("SB1")
    dbSetOrder(1)
    dbGoTop()
    While !Eof()

        IncProc("Processando o produto "+SB1->B1_COD+" - "+SB1->B1_DESC)

        If !SB1->B1_LOCALIZ$"S"

            DbSelectArea("SDA")
            DbSetOrder(1)
            If dbSeek(xFilial("SDA")+SB1->B1_COD,.F.)

                While Eof() == .f. .And. SDA->DA_PRODUTO == SB1->B1_COD

                    RecLock("SDA",.f.)
                    SDA->(dbDelete())
                    MsUnlock()
                    SDA->(dbSkip())

                EndDo

            EndIf
        
            DbSelectArea("SDB")
            DbSetOrder(1)
            If dbSeek(xFilial("SDB")+SB1->B1_COD,.F.)

                While Eof() == .f. .And. SDB->DB_PRODUTO == SB1->B1_COD

                    RecLock("SDB",.f.)
                    SDB->(dbDelete())
                    MsUnlock()
                    SDB->(dbSkip())

                EndDo

            EndIf

            DbSelectArea("SBF")
            DbSetOrder(2)
            If dbSeek(xFilial("SBF")+SB1->B1_COD,.F.)

                While Eof() == .f. .And. SBF->BF_PRODUTO == SB1->B1_COD

                    RecLock("SBF",.f.)
                    SBF->(dbDelete())
                    MsUnlock()
                    SBF->(dbSkip())

                EndDo

            EndIf

        EndIf 
        
        dbSelectArea("SB1")
        dbSkip()
    EndDo


Return

Static Function CriaPerg()

Local aEstrut := {}
Local aGrava  := {}
Local cTit    := "Qual Armazem?"
Local nI, nJ

dbSelectArea('SX1')
SX1->(dbSetOrder(1))
If SX1->(!dbSeek('RESTA92'))
	//::Monta a Estrutura do SX1
	aEstrut := {"X1_GRUPO"	,"X1_ORDEM"		,"X1_PERGUNT"	,"X1_PERSPA"	,"X1_PERENG"	,"X1_VARIAVL"	,;
				 "X1_TIPO"	,"X1_TAMANHO"	,"X1_DECIMAL"	,"X1_PRESEL"	,"X1_GSC"		,"X1_VALID"		,;
				 "X1_VAR01"	,"X1_DEF01"		,"X1_DEFSPA1"	,"X1_DEFENG1"	,"X1_CNT01"		,"X1_F3"		,;
				 "X1_PYME"	,"X1_GRPSXG"	,"X1_HELP"		,"X1_PICTURE"									}
	//::Adiciona os dados a gravar
	aADD(aGrava,{"RESTA92"	,"01"			,cTit	    	,cTit		    ,cTit	    	,"mv_ch1"		,;
				 "C"		,04				,0				,0				,"F"			,""				,;
				 "MV_PAR01"	,"56"				,""				,""				,""				,"NNR"		    ,;
				 ""			,""				,""				,""												})
    
    //::Grava no SX1
	For nI:= 1 to len(aGrava)
		RecLock("SX1",.T.)
		For nJ:=1 To Len(aGrava[nI])
			If FieldPos(aEstrut[nJ])>0 .And. aGrava[nI,nJ] != NIL
				FieldPut(FieldPos(aEstrut[nJ]),aGrava[nI,nJ])
			EndIf
		Next nJ
		SX1->(msUnLock())
        
	Next nI

EndIf

Return
