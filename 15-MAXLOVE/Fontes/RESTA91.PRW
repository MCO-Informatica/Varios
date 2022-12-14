#INCLUDE "PROTHEUS.CH"

User Function RESTA91()

    CriaPerg()
    
    Pergunte("RESTA91",.T.)

    processa({||RunProc()},"Saldo Inventário Zerado")
return

Static Function RunProc()

    dbSelectArea("SB1")
    dbSetOrder(1)
    dbGoTop()
    While !Eof()

        IncProc("Processando o produto "+SB1->B1_COD+" - "+SB1->B1_DESC)

        If Rastro(SB1->B1_COD)

            dbSelectArea("SB8")
            dbSetOrder(1)
            If dbSeek(xFilial("SB8")+SB1->B1_COD+MV_PAR01,.f.)

                While Eof() == .f. .and. SB8->B8_FILIAL+SB8->B8_PRODUTO+SB8->B8_LOCAL == xFilial("SB8")+SB1->B1_COD+MV_PAR01

                    If SB8->B8_SALDO <=0
                        dbSelectArea("SB8")
                        dbSkip()
                        Loop
                    EndIf

                    dbSelectArea("SB7")
                    Reclock("SB7",.t.)
                    SB7->B7_FILIAL		:=	xFilial("SB7")
                    SB7->B7_COD			:=	SB8->B8_PRODUTO
                    SB7->B7_LOCAL		:=	SB8->B8_LOCAL
                    SB7->B7_TIPO		:=	SB1->B1_TIPO
                    SB7->B7_DOC			:=	'IV-'+MV_PAR01
                    SB7->B7_QUANT		:=	0
                    SB7->B7_DATA		:=	dDataBase
                    SB7->B7_LOTECTL		:=	SB8->B8_LOTECTL
                    SB7->B7_DTVALID		:=	SB8->B8_DTVALID
                    SB7->B7_CONTAGE		:=	'001'
                    SB7->B7_STATUS		:=	'1'
                    SB7->B7_ORIGEM		:=	'MATA270'
                    MsUnLock()

                    dbSelectArea("SB8")
                    dbSkip()
                EndDo
            Else
                dbSelectArea("SB2")
                dbSetOrder(1)
                If dbSeek(xFilial("SB2")+SB1->B1_COD+MV_PAR01,.f.)

                    While Eof() == .f. .and. SB2->B2_FILIAL+SB2->B2_COD+SB2->B2_LOCAL == xFilial("SB2")+SB1->B1_COD+"MVPAR01"

                        If SB2->B2_QATU <= 0
                            dbSelectArea("SB2")
                            dbSkip()
                            Loop
                        EndIf

                        dbSelectArea("SB7")
                        Reclock("SB7",.t.)
                        SB7->B7_FILIAL		:=	xFilial("SB7")
                        SB7->B7_COD			:=	SB2->B2_COD
                        SB7->B7_LOCAL		:=	SB2->B2_LOCAL
                        SB7->B7_TIPO		:=	SB1->B1_TIPO
                        SB7->B7_DOC			:=	'IV-'+MV_PAR01
                        SB7->B7_QUANT		:=	0
                        SB7->B7_DATA		:=	dDataBase
                        SB7->B7_CONTAGE		:=	'001'
                        SB7->B7_STATUS		:=	'1'
                        SB7->B7_ORIGEM		:=	'MATA270'
                        MsUnLock()

                        dbSelectArea("SB2")
                        dbSkip()
                    EndDo
                EndIf
            EndIf
        EndIf

        If Localiza(SB1->B1_COD)
            dbSelectArea("SBF")
            dbSetOrder(2)
            If dbSeek(xFilial("SBF")+SB1->B1_COD+MV_PAR01,.f.)

                While Eof() == .f. .and. SBF->BF_FILIAL+SBF->BF_PRODUTO+SBF->BF_LOCAL == xFilial("SBF")+SB1->B1_COD+MV_PAR01

                    If SBF->BF_QUANT <= 0
                        dbSelectArea("SBF")
                        dbSkip()
                        Loop
                    EndIf

                    dbSelectArea("SB7")
                    Reclock("SB7",.t.)
                    SB7->B7_FILIAL		:=	xFilial("SB7")
                    SB7->B7_COD			:=	SBF->BF_PRODUTO
                    SB7->B7_LOCAL		:=	SBF->BF_LOCAL
                    SB7->B7_TIPO		:=	SB1->B1_TIPO
                    SB7->B7_DOC			:=	'IV-'+MV_PAR01
                    SB7->B7_QUANT		:=	0
                    SB7->B7_DATA		:=	dDataBase
                    SB7->B7_LOCALIZ		:=	SBF->BF_LOCALIZ
                    SB7->B7_CONTAGE		:=	'001'
                    SB7->B7_STATUS		:=	'1'
                    SB7->B7_ORIGEM		:=	'MATA270'
                    MsUnLock()

                    dbSelectArea("SBF")
                    dbSkip()
                EndDo
            Else
                dbSelectArea("SB2")
                dbSetOrder(1)
                If dbSeek(xFilial("SB2")+SB1->B1_COD+MV_PAR01,.f.)

                    While Eof() == .f. .and. SB2->B2_FILIAL+SB2->B2_COD+SB2->B2_LOCAL == xFilial("SB2")+SB1->B1_COD+MV_PAR01

                        If SB2->B2_QATU <= 0
                            dbSelectArea("SB2")
                            dbSkip()
                            Loop
                        EndIf

                        dbSelectArea("SB7")
                        Reclock("SB7",.t.)
                        SB7->B7_FILIAL		:=	xFilial("SB7")
                        SB7->B7_COD			:=	SB2->B2_COD
                        SB7->B7_LOCAL		:=	SB2->B2_LOCAL
                        SB7->B7_TIPO		:=	SB1->B1_TIPO
                        SB7->B7_DOC			:=	'IV-'+MV_PAR01
                        SB7->B7_QUANT		:=	0
                        SB7->B7_DATA		:=	dDataBase
                        SB7->B7_CONTAGE		:=	'001'
                        SB7->B7_STATUS		:=	'1'
                        SB7->B7_ORIGEM		:=	'MATA270'
                        MsUnLock()

                        dbSelectArea("SB2")
                        dbSkip()
                    EndDo
                EndIf
            EndIf
        EndIf

        If !Rastro(SB1->B1_COD) .and. !Localiza(SB1->B1_COD)
            dbSelectArea("SB2")
            dbSetOrder(1)
            If dbSeek(xFilial("SB2")+SB1->B1_COD+MV_PAR01,.f.)

                While Eof() == .f. .and. SB2->B2_FILIAL+SB2->B2_COD+SB2->B2_LOCAL == xFilial("SB2")+SB1->B1_COD+MV_PAR01

                    If SB2->B2_QATU <= 0
                        dbSelectArea("SB2")
                        dbSkip()
                        Loop
                    EndIf

                    dbSelectArea("SB7")
                    Reclock("SB7",.t.)
                    SB7->B7_FILIAL		:=	xFilial("SB7")
                    SB7->B7_COD			:=	SB2->B2_COD
                    SB7->B7_LOCAL		:=	SB2->B2_LOCAL
                    SB7->B7_TIPO		:=	SB1->B1_TIPO
                    SB7->B7_DOC			:=	'IV-'+MV_PAR01
                    SB7->B7_QUANT		:=	0
                    SB7->B7_DATA		:=	dDataBase
                    SB7->B7_CONTAGE		:=	'001'
                    SB7->B7_STATUS		:=	'1'
                    SB7->B7_ORIGEM		:=	'MATA270'
                    MsUnLock()

                    dbSelectArea("SB2")
                    dbSkip()
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
If SX1->(!dbSeek('RESTA91'))
	//::Monta a Estrutura do SX1
	aEstrut := {"X1_GRUPO"	,"X1_ORDEM"		,"X1_PERGUNT"	,"X1_PERSPA"	,"X1_PERENG"	,"X1_VARIAVL"	,;
				 "X1_TIPO"	,"X1_TAMANHO"	,"X1_DECIMAL"	,"X1_PRESEL"	,"X1_GSC"		,"X1_VALID"		,;
				 "X1_VAR01"	,"X1_DEF01"		,"X1_DEFSPA1"	,"X1_DEFENG1"	,"X1_CNT01"		,"X1_F3"		,;
				 "X1_PYME"	,"X1_GRPSXG"	,"X1_HELP"		,"X1_PICTURE"									}
	//::Adiciona os dados a gravar
	aADD(aGrava,{"RESTA91"	,"01"			,cTit	    	,cTit		    ,cTit	    	,"mv_ch1"		,;
				 "C"		,02				,0				,0				,"F"			,""				,;
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
