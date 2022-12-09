#INCLUDE "PROTHEUS.CH"

Class PlanilhaContratoRemuneracao 

    Data cPlanilha
    Data cTipoPlanilha
    Data cDescTipoPlanilha
    Data lPlanilhaMedicaoEventual
    Data lPlanilhaMedicaoAutomatica
    Data lPlanilhaFixa
    Data nSaldoPlanilha

    Method New(cPlanilha, cTipoPlanilha, nSaldoPlanilha) Constructor
    Method carregaCampos()

EndClass

Method New(cPlanilha, cTipoPlanilha, nSaldoPlanilha) Class PlanilhaContratoRemuneracao

    ::cPlanilha := cPlanilha
    ::cTipoPlanilha := cTipoPlanilha
    ::cDescTipoPlanilha := ""
    ::lPlanilhaMedicaoEventual := .F.
    ::lPlanilhaMedicaoAutomatica := .F.
    ::lPlanilhaFixa := .F.
    ::nSaldoPlanilha := nSaldoPlanilha

    ::carregaCampos()

Return

Method carregaCampos() Class PlanilhaContratoRemuneracao

    dbSelectArea("CNL")
    CNL->(dbSetOrder(1)) //CNL_FILIAL + CNL_CODIGO
    If CNL->(dbSeek(xFilial("CNL") + ::cTipoPlanilha))
        ::cDescTipoPlanilha := CNL->CNL_DESCRI
        ::lPlanilhaMedicaoAutomatica := CNL->CNL_MEDAUT == "1"
        ::lPlanilhaMedicaoEventual := CNL->CNL_MEDEVE $ "1|0"
        ::lPlanilhaFixa := CNL->CNL_CTRFIX == "1"
    EndIf

Return
