#include "protheus.ch"
#INCLUDE "TOPCONN.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} RDIEXCLU
Rotina para exclusão da DI ou Fatura.
@author  weskley.silva
@since   26/12/2019
@version 1.0
/*/
//-------------------------------------------------------------------

User Function rdiexclu()

Local aParamBox := {}
Local aRetPar   := {}
Local OPNLPARAM 
Local cTempAlias 
Local cNum      := " "
Local cOpcao    := " "
Local cProcess  := " "
Local cQuery    := " "
Local cFile     := " "
Local cCodProc  := " "
Local lStatus := .F.
Local lVerifica 
Local lContinua := .T.
Local lCancel   := .T.

aAdd(aParamBox,{1,"Processo"  ,Space(10),"","","SW6","",50,.T.}) 
aAdd(aParamBox,{2,"Selecione Opção",1,{"","DI","Fatura"},50,"",.T.})

If ParamBox(aParamBox,"Parâmetros...",@aRetPar,,,,,,oPnlParam)
    cProcess := AllTrim(aRetPar[1])
    cOpcao   := Alltrim(aRetPar[2])
Else 
    MsgInfo("Rotina cancelada","IMCD")
    lCancel := .F.
endif

IF lCancel 
    if !EMPTY(cProcess) .and.  !EMPTY(cOpcao)

        lVerifica := CheckNF(cProcess)

        IF lVerifica
            if cOpcao == "DI"
                Begin Transaction

                cTempAlias := GetNextAlias()

                cQuery := " SELECT WD_HAWB, SWD.* FROM "+RetSqlName("SWD")+" SWD WHERE WD_HAWB = '"+cProcess+"' AND WD_FILIAL = '"+xFilial("SWD")+"' "
                cQuery += " AND D_E_L_E_T_ <> '*'  " 

                dbUseArea(.T.,"TOPCONN", TcGenQry(,,cQuery ), cTempAlias, .T., .F.)

                dbSelectArea("SWD")
                dbSetOrder(1)
                IF dbSeek(xFilial("SWD")+ALLTRIM((cTempAlias)->WD_HAWB))
                    while !(cTempAlias)->(EOF()) .and. (cTempAlias)->WD_HAWB = SWD->WD_HAWB
                        RECLOCK("SWD",.F.)	
			                SWD->(dbDelete())		
			            SWD->(MSUNLOCK())
                        SWD->(dbskip())
			            (cTempAlias)->(dbskip()) 
                        lStatus := .T.
                    enddo

                    cTempAlias := GetNextAlias()
                    cQuery := " SELECT E2_NUM,SE2.* FROM "+RetSqlName("SE2")+" SE2 WHERE E2_NUM = '"+cProcess+"' AND E2_FILIAL = '"+xFilial("SE2")+"' "
                    cQuery += " AND D_E_L_E_T_ <> '*' "

                    dbUseArea(.T.,"TOPCONN", TcGenQry(,,cQuery ), cTempAlias, .T., .F.)

                    dbSelectArea("SE2")
                    dbSetOrder(1)
                    IF dbSeek(xFilial("SE2")+"EIC"+ALLTRIM((cTempAlias)->E2_NUM))
                        while !(cTempAlias)->(EOF()) .AND. (cTempAlias)->E2_NUM = SE2->E2_NUM
                        // Verifica se o titulo foi baixado total ou parcial, se estiver baixado não realiza o estorno
                            if EMPTY(SE2->E2_BAIXA) .AND. SE2->E2_VALOR = SE2->E2_SALDO .AND. lContinua
                                RECLOCK("SE2",.F.)	
			                        SE2->(dbDelete())		
			                    SE2->(MSUNLOCK()) 
                                SE2->(dbskip()) 
			                    (cTempAlias)->(dbskip())
                                lStatus := .T.
                            ELSE
                                MsgInfo("Existe titulos baixados, por esse motivo não é possivel realizar o estorno","IMCD")
                                DisarmTransaction()
                                SE2->(dbskip()) 
			                    (cTempAlias)->(dbskip())  
                                lContinua := .F.    
                            ENDIF     
                        enddo
                    ENDIF
                    IF lStatus .and. lContinua
                        cLOGZNT(cProcess,"RDI")
                        MsgInfo("DI do Processo "+cProcess+" excluido com sucesso!","IMCD")
                    endif     
                ELSE
                    MsgInfo("Processo não encontrado","IMCD")    
                ENDIF
                end Transaction
            ELSEIF cOpcao == "Fatura"
                    Begin Transaction
                    cTempAlias := GetNextAlias()
                    cQuery := " SELECT W9_HAWB,SW9.* FROM "+RetSqlName("SW9")+" SW9 WHERE W9_HAWB = '"+cProcess+"' AND W9_FILIAL = '"+XFilial("SW9")+"'  "
                    cQuery += " AND D_E_L_E_T_ <> '*' "
         
                    dbUseArea(.T.,"TOPCONN", TcGenQry(,,cQuery ), cTempAlias, .T., .F.)

                    dbSelectArea("SW9")
                    dbSetOrder(3)
                    IF dbSeek(xFilial("SW9")+ALLTRIM((cTempAlias)->W9_HAWB))
                        while !(cTempAlias)->(EOF()) .AND. (cTempAlias)->W9_HAWB = SW9->W9_HAWB
                            cNum += "'"+SW9->W9_NUM+"',"
                            RECLOCK("SW9",.F.)	
			                    SW9->(dbDelete())		
			                SW9->(MSUNLOCK()) 
                            SW9->(dbskip()) 
			                (cTempAlias)->(dbskip()) 
                            lStatus := .T.
                        enddo

                        cTempAlias := GetNextAlias()
                        cQuery := " SELECT W8_HAWB,SW8.* FROM "+RetSqlName("SW8")+" SW8 WHERE W8_HAWB = '"+cProcess+"' AND W8_FILIAL = '"+XFilial("SW8")+"'  "
                        cQuery += " AND D_E_L_E_T_ <> '*' "

                        dbUseArea(.T.,"TOPCONN", TcGenQry(,,cQuery ), cTempAlias, .T., .F.)

                        dbSelectArea("SW8")
                        dbSetOrder(1)
                        IF dbSeek(xFilial("SW8")+ALLTRIM((cTempAlias)->W8_HAWB))
                            while !(cTempAlias)->(EOF()) .AND. (cTempAlias)->W8_HAWB = SW8->W8_HAWB
                                RECLOCK("SW8",.F.)	
			                        SW8->(dbDelete())		
			                    SW8->(MSUNLOCK()) 
                                SW8->(dbskip()) 
			                    (cTempAlias)->(dbskip()) 
                                lStatus := .T.
                            enddo
                        ENDIF

                        cTempAlias := GetNextAlias()
                        cQuery := " SELECT WA_HAWB,SWA.* FROM "+RetSqlName("SWA")+" SWA WHERE WA_HAWB = '"+cProcess+"' AND WA_FILIAL = '"+XFilial("SWA")+"'  "
                        cQuery += " AND D_E_L_E_T_ <> '*' "

                        dbUseArea(.T.,"TOPCONN", TcGenQry(,,cQuery ), cTempAlias, .T., .F.)

                        dbSelectArea("SWA")
                        dbSetOrder(1)
                        IF dbSeek(xFilial("SWA")+ALLTRIM((cTempAlias)->WA_HAWB))
                            while !(cTempAlias)->(EOF()) .AND. (cTempAlias)->WA_HAWB = SWA->WA_HAWB
                                RECLOCK("SWA",.F.)	
			                        SWA->(dbDelete())		
			                    SWA->(MSUNLOCK()) 
                                SWA->(dbskip()) 
			                    (cTempAlias)->(dbskip()) 
                                lStatus := .T.
                            enddo
                        ENDIF
                    
                        cTempAlias := GetNextAlias()
                        cQuery := " SELECT WB_HAWB,SWB.* FROM "+RetSqlName("SWB")+" SWB WHERE WB_HAWB = '"+cProcess+"' AND WB_FILIAL = '"+XFilial("SWB")+"'  "
                        cQuery += " AND D_E_L_E_T_ <> '*' "

                        dbUseArea(.T.,"TOPCONN", TcGenQry(,,cQuery ), cTempAlias, .T., .F.)

                        dbSelectArea("SWB")
                        dbSetOrder(1)
                        IF dbSeek(xFilial("SWB")+ALLTRIM((cTempAlias)->WB_HAWB))
                            while !(cTempAlias)->(EOF()) .AND. (cTempAlias)->WB_HAWB = SWB->WB_HAWB
                                RECLOCK("SWB",.F.)	
			                        SWB->(dbDelete())		
			                    SWB->(MSUNLOCK()) 
                                SWB->(dbskip()) 
			                    (cTempAlias)->(dbskip()) 
                                lStatus := .T.
                            enddo
                        ENDIF 

                        cNum := SubStr(cNum,1,Len(cNum)-1)

                        if !Empty(cNum)
                            cTempAlias := GetNextAlias()
                            cQuery := " SELECT E2_NUM,SE2.* FROM "+RetSqlName("SE2")+" SE2 WHERE E2_NUM in ("+cNum+") AND E2_FILIAL = '"+XFilial("SE2")+"'  "
                            cQuery += " AND D_E_L_E_T_ <> '*' AND E2_TIPO = 'INV' AND E2_ORIGEM = 'SIGAEIC'  "

                            dbUseArea(.T.,"TOPCONN", TcGenQry(,,cQuery ), cTempAlias, .T., .F.)

                            dbSelectArea("SE2")
                            dbSetOrder(1)
                            IF dbSeek(xFilial("SE2")+"EIC"+ALLTRIM((cTempAlias)->E2_NUM))
                                while !(cTempAlias)->(EOF()) .AND. (cTempAlias)->E2_NUM = SE2->E2_NUM
                                // Verifica se o titulo foi baixado total ou parcial, se estiver baixado não realiza o estorno
                                    if EMPTY(SE2->E2_BAIXA) .AND. SE2->E2_VALOR = SE2->E2_SALDO .AND. lContinua
                                        RECLOCK("SE2",.F.)	
			                                SE2->(dbDelete())		
			                            SE2->(MSUNLOCK()) 
                                        SE2->(dbskip()) 
			                            (cTempAlias)->(dbskip())
                                        lStatus := .T.
                                    ELSE
                                        MsgInfo("Existe titulos baixados, por esse motivo não é possivel realizar o estorno","IMCD")
                                        DisarmTransaction()
                                        SE2->(dbskip()) 
			                            (cTempAlias)->(dbskip())  
                                        lContinua := .F.
                                    ENDIF    
                                enddo
                            ENDIF
                        endif
                        If lStatus .and. lContinua
                            cLOGZNT(cProcess,"RFT")
                            MsgInfo("Fatura do Processo "+cProcess+" excluida com sucesso!","IMCD") 
                        endif                    
                    ELSE
                        MsgInfo("Processo não encontrado","IMCD") 
                    ENDIF 
                    end Transaction                  
            ENDIF
        ELSE
            MsgInfo("Processo possui nota fiscal já gerada. Não é possivel a exclusão","IMCD")          
        ENDIF
    ELSE
        MsgInfo("Informe o processo e a opção de estorno","IMCD")   
    ENDIF
ENDIF
return

Static Function CheckNF(_cprocess)

Local cQuery 
Local cTempAlias
Local lChekNF 

cTempAlias := GetNextAlias()

cQuery := " SELECT WN_HAWB,SWN.* FROM "+RetSqlName("SWN")+" SWN WHERE WN_FILIAL = '"+XFILIAL("SWN")+"' " 
cQuery += " AND WN_HAWB = '"+Alltrim(_cprocess)+"' AND ROWNUM = 1 AND D_E_L_E_T_ <> '*' "

dbUseArea(.T.,"TOPCONN", TcGenQry(,,cQuery ), cTempAlias, .T., .F.)

iF !Empty((cTempAlias)->WN_HAWB)
    lChekNF := .F.
else
    lChekNF := .T.
EndIF

return lChekNF

Static Function cLOGZNT(_cprocess,_cEtapa)

Local cQuery 
Local cTempAlias
Local lChekFin 
Local cFile
Local cCodProc

cTempAlias := GetNextAlias()

    cQuery := " SELECT ZNT_FILE,ZNT.* FROM "+RetSqlName("ZNT")+" ZNT WHERE ZNT_NUMPO = '"+_cprocess+"' AND ZNT_FILIAL = '"+XFILIAL("ZNT")+"' "
    cQuery += " AND ZNT_ETAPA = '"+_cEtapa+"' AND ZNT_STATUS = '2' AND ROWNUM = 1 AND D_E_L_E_T_ <> '*'  ORDER BY R_E_C_N_O_ DESC "

    dbUseArea(.T.,"TOPCONN", TcGenQry(,,cQuery ), cTempAlias, .T., .F.)

    cFile := (cTempAlias)->ZNT_FILE
    cCodProc := GETSXENUM("ZNT","ZNT_CODPRC")

    dbSelectArea("ZNT")
    DbSetOrder(2)
    RecLock("ZNT",.T.)
        ZNT->ZNT_FILIAL := XFilial("ZNT")
        ZNT->ZNT_NUMPO  := _cprocess
        ZNT->ZNT_CODPRC := cCodProc
        ZNT->ZNT_ETAPA  := _cEtapa
        ZNT->ZNT_STATUS := "4"
        ZNT->ZNT_FILE   := cFile
        ZNT->ZNT_RCDATE := Date() 
        ZNT->ZNT_RCHOUR := Time()
    MsUnlock()
return 
