#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
//-----------------------------------------------------------------------
// Rotina | FT300BUT | Autor | David Sobrinho       | Data | 22/09/2010
//-----------------------------------------------------------------------
// Descr. | Ponto de Entrada para Botoes na tela de Oportunidades
//-----------------------------------------------------------------------
// Update | Adequação do PE para nova versão em MVC
//		  | Rafael Beghini TSM - 02.10.2018
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function FT300BUT()
    Local oView := ParamIXB[01]
    Local aRet := {}

    aAdd(aRet,{"Concorrente", "", {|| U_CTSA040() }, "ViewVisual", , {MODEL_OPERATION_VIEW}})
    aAdd(aRet,{"Exp. Verba" , "", {|| U_CTSA041() }, "ViewVisual", , {MODEL_OPERATION_VIEW}})
Return aRet