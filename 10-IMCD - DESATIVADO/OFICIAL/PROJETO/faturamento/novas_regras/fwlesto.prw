#INCLUDE "Rwmake.ch"
#INCLUDE "Average.ch"
#INCLUDE "TOPCONN.CH"

User Function FWLESTO()

Local aAlias := GETAREA()
Local vDeletar := .T.

//VALIDAÇÕES
     SW7->( DBSetOrder(1) )
     IF !SW7->(DBSEEK(xFilial()+SW6->W6_HAWB))
        vDeletar := .F.
     ELSE
        IF lValidaEIC //JAP 19/08/06
           EIC->(DBSETORDER(1))
           IF EIC->(DBSEEK(xFilial()+SW6->W6_HAWB))
				vDeletar := .F.
           ENDIF
        ENDIF
        
        SF1->(DBSETORDER(5))
        IF SF1->(DBSEEK(xFilial()+SW6->W6_HAWB))
			vDeletar := .F.
        ENDIF
        
        SX3->(DBSETORDER(2))
        IF lTem_ECO .AND. SX3->(DBSEEK("W6_CONTAB"))
           IF !EMPTY(SW6->W6_CONTAB)
			 vDeletar := .F.
           ENDIF
        ENDIF
        If lIntDraw  .And. !GETMV("MV_EDC0009",,.F.) //AOM 19/12/2011
           ED2->(dbSetOrder(4))
           If ED2->(dbSeek(cFilED2+SW6->W6_HAWB))
			vDeletar := .F.
           ElseIf cAntImp=="2" //GFC - 17/07/2003 - Anterioridade Drawback
              If  EDD->(dbSeek(cFilEDD+SW6->W6_HAWB))
                 Do While !EDD->(EOF()) .and. EDD->EDD_FILIAL==cFilEDD .and. EDD->EDD_HAWB==SW6->W6_HAWB
                    If (!Empty(EDD->EDD_PREEMB)  .Or. !Empty(EDD->EDD_PEDIDO) .Or. (lTpOcor .And. !Empty(EDD->EDD_CODOCO)) ) //AOM - 23/11/2011 - Tratamento para considerar Vendas para exportadores.
						vDeletar := .F.
                    EndIf
                    EDD->(dbSkip())
                 EndDo
              EndIf
           EndIf
        EndIf

		IF lCposAdto
		   lTemAdto := .F.
		   cFilSWB := xFilial("SWB")
		   SWB->(dbSetorder(1))
		   SWB->(DBSEEK(cFilSWB + SW6->W6_HAWB + "D"))
		   DO WHILE !SWB->(eof()) .AND. SWB->WB_FILIAL==cFilSWB .AND. SWB->WB_HAWB==SW6->W6_HAWB .AND. SWB->WB_PO_DI=="D"
		      IF SWB->WB_TIPOREG == "P"
		         vDeletar := .F.
		      ENDIF
		      SWB->(dbSkip())
		   ENDDO
		ENDIF

        IF !lFinanceiro
           SWA->(DBSETORDER(1))
            cFilSWA  := xFilial("SWA")
            cChavSWA := cFilSWA + SW6->W6_HAWB
           IF lCposAdto
              cChavSWA += "D"
           ENDIF

           IF SWA->(DBSEEK(cChavSWA))
			 vDeletar := .F.
           ENDIF
        ENDIF

        If lAvIntFinEIC
           SWD->(DBSETORDER(1))
           SWD->(DbSeek(xFilial()+SW6->W6_HAWB))
           DO WHILE xFilial('SWD') == SWD->WD_FILIAL .AND.;
                    SWD->WD_HAWB   == SW6->W6_HAWB .AND.;
                    !SWD->(EOF())

              If !Empty(SWD->WD_TITERP) .OR. Upper(Left(AllTrim(SWD->WD_CTRLERP),7)) == "ENVIADO"
 				vDeletar := .F.
              EndIf
              SWD->(DBSKIP())
           ENDDO

           If EW6->(dbSeek(xFilial("EW6")+'DRL'+SW6->W6_HAWB))
			 vDeletar := .F.
           EndIf
        EndIf
     
     Endif



If  vDeletar 

	dbselectarea("ZE1")
	dbgotop()
	
	dbselectarea("ZE1")
	dbsetorder(1)
	IF MsSeek(xFilial("ZE1")+SW6->W6_HAWB) 
	
		 While ZE1->ZE1_HAWB == SW6->W6_HAWB
			   	RECLOCK("ZE1",.F.)	
					ZE1->(dbDelete())		
				MSUNLOCK()  
			 dbselectarea("ZE1")
			 dbskip() 
		 Enddo
	 endif
	 
Endif
  
RestArea(aAlias)

Return()                        

