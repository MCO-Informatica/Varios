#Include 'Protheus.ch'

User Function AV150VPR()
//Local cTipo := paramixb[1] // Tipo da etiqueta
    Local cMsg := ""
    Local _nLoteM := SB1->B1_LOTEMUL
    Local _nResto := 0
    Local lRet := .T.
    cMsg := "Atencao, o Produto tem que ser Transferido por multiplos de "+ ALLTRIM(str(_nLoteM))

    if _nLoteM > 0
        _nResto := MOD( nQtdeProd ,_nLoteM)
        if _nResto > 0
            VTALERT(cMsg,"Aviso-P.E. AV150VPR",.T.,,3)
            lRet := .F.
        else
            VTGetSetFocus("cArmDes")
        endif
    endif

    If cEmpAnt $ '02|04'

        dbselectarea("SB8")
        dbsetorder(5)
        dbseek(xFilial("SB8")+CPRODUTO+CLOTE )

//nQtde := nQtde

    Endif

Return lRet
