#Include 'Protheus.ch'
//+-------------------------------------------------------------------+
//| Rotina | MSDOCVST | Autor | Rafael Beghini | Data | 17.05.2019 
//+-------------------------------------------------------------------+
//| Descr. | PE - Rotina Banco conhecimento
//+-------------------------------------------------------------------+
User Function MSDOCVST()
    Local cTable := ParamIxb[1]
    Local nRECNO := ParamIxb[2]
    Local lRet   := .T.
    Local nOpc   := 0
    Local cMsg   := 'Banco de Conhecimento'

    IF INCLUI .OR. ALTERA
        nOpc := Aviso(cMsg,'Existem duas maneiras para anexar documentos, unitário ou em lote, qual deseja utilizar?',;
                            {'Visualizar','Em lote', 'Unitário','Cancelar'},2)
        
        IF nOpc == 2 //Em lote
            lRet := U_CSxACB(cTable,nRECNO)
        ElseIF nOpc == 4
            lRet := .F.
        EndIF
    EndIF
    
Return( lRet )