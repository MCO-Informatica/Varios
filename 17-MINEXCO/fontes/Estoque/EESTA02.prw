#Include 'Protheus.ch'
 
//---------------------------------------------------------------------------------
// Rotina | EESTA02              | Autor | Lucas Baia          | Data |	01/08/2021		
//---------------------------------------------------------------------------------
// Descr. | Fonte Customizado para trazer o Número de Lote através do Doc. Saída.
//        | Referente a Nota Fiscal de Devolução.												
//---------------------------------------------------------------------------------
// Uso    | MINEXCO														
//---------------------------------------------------------------------------------
User Function EESTA02()

_cLoteDev       := ""
_cProdRastro    := Posicione("SB1",1,xFilial("SB1")+M->D1_COD,"B1_RASTRO")

DbSelectArea('SD2')
SD2->(DbSetOrder(3)) //D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA + D2_COD + D2_ITEM
SD2->(DbGoTop())


IF cTipo$"D/B" .AND. EMPTY(M->D1_NFORI)
    M->D1_LOTECTL := " "
ELSEIF cTipo$"D/B" .AND. !EMPTY(M->D1_NFORI)
    IF SD2->(DbSeek(xFilial('SD2') + M->D1_NFORI + M->D1_SERIORI + M->cA100For + M->cLoja + M->D1_COD + M->D1_ITEMORI))
        _cLoteDev := SD2->D2_LOTECTL
        return(_cLoteDev)
    ENDIF
ELSE
    dbSelectArea("SB1")
    dbSetOrder(1)
    IF !cTipo$"D/B"
        IF _cProdRastro == "N"
            _cLoteDev       := ""
            return(_cLoteDev)
        ELSE                                                                                                           
            _cLoteDev   := GETMV("MV_X_LOTE")
            return(_cLoteDev)
        ENDIF
    ENDIF        
ENDIF

return


//---------------------------------------------------------------------------------
// Rotina | EESTA03              | Autor | Lucas Baia          | Data |	01/08/2021		
//---------------------------------------------------------------------------------
// Descr. | Fonte Customizado para trazer a Data de Validade dos Lotes através do 
//        | Doc. Saída. Referente a Nota Fiscal de Devolução.											
//---------------------------------------------------------------------------------
// Uso    | MINEXCO														
//---------------------------------------------------------------------------------
User Function EESTA03()
 
_cDTLotDev      := ""
_cProdRastro    := Posicione("SB1",1,xFilial("SB1")+M->D1_COD,"B1_RASTRO")

DbSelectArea('SD2')
SD2->(DbSetOrder(3)) //D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA + D2_COD + D2_ITEM
SD2->(DbGoTop())

IF cTipo$"D/B" .AND. EMPTY(M->D1_NFORI)
    M->D2_DTVALID := CTOD(" ")
ELSEIF cTipo$"D/B" .AND. !EMPTY(M->D1_NFORI) 
    IF SD2->(DbSeek(xFilial('SD2') + M->D1_NFORI + M->D1_SERIORI + M->cA100For + M->cLoja + M->D1_COD + M->D1_ITEMORI))
        _cDTLotDev := SD2->D2_DTVALID
        return(_cDTLotDev)
    ENDIF
ELSE
    dbSelectArea("SB1")
    dbSetOrder(1)
    IF !cTipo$"D/B"
        IF _cProdRastro == "N"
            _cDTLotDev       := CTOD("")
            return(_cDTLotDev)
        ELSE                                                                                                           
            _cDTLotDev   := CTOD("31/12/49")
            return(_cDTLotDev)
        ENDIF
    ENDIF            
ENDIF

return
