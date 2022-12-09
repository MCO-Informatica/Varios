#include 'protheus.ch'

/*/{Protheus.doc} MA330TRB
LOCALIZAÇÃO   :  Function MATA330( ) - 
Função utilizada para realizar o recalculo 
do custo medio.
O Ponto de entrada e executado após a gravação de 
todas as partes do arquivo de trabalho que serão 
utilizadas na rotina de recalculo do custo medio, 
este ponto tem como objetivo a manipulacao deste 
arquivo antes do processamento.
@type function
@version 1.0
@author marcio.katsumata
@since 24/06/2020
@return return_type, return_description
/*/
user function MA330TRB ()
    local aProc as array
    local cFilProc as character
    local cProdProc as character
    local nInd  as numeric

    aProc := &("{"+superGetMv("ES_M330TRB", .F., "{'02','MR1068682TBY000'}, {'05','MRF493911SC8000'}")+"}")
    aProcD3 := &("{"+superGetMv("ES_M330TM1", .F., "{'02','MR7300472G01001'}, {'02','MRAM64780BBM000'}, {'02','MRN187930G01000'}, {'02','MRAM98480BBM000'}")+"}")


    TRB->(dbGoTop())
    TRB->(dbSetOrder(1))
     
    for nInd := 1 to len(aProc)

        cFilProc  := aProc[nInd][1]
        cProdProc := aProc[nInd][2]

        if TRB->(dbSeek(cFilProc+"300"+cProdProc+"  y")) 
            acertaNivel("SD1",,,cFilProc+"300"+cProdProc+"  y")
        endif

        if TRB->(dbSeek(cFilProc+"300"+cProdProc+"99y")) 
            acertaNivel("SD1",,,cFilProc+"300"+cProdProc+"99y")
        endif

        if TRB->(dbSeek(cFilProc+"300"+cProdProc+"  x")) 
            acertaNivel("SD2",,,cFilProc+"300"+cProdProc+"  x")
        endif

        if TRB->(dbSeek(cFilProc+"300"+cProdProc+"99x"))
            acertaNivel("SD2",,,cFilProc+"300"+cProdProc+"99x")
        endif
    
        if TRB->(dbSeek(cFilProc+"500"+cProdProc+"99 "))
            acertaNivel("SD2"," " ,"a",cFilProc+"500"+cProdProc+"99 ")
        endif

    next nInd

    for nInd := 1 to len(aProcD3)

        cFilProc  := aProcD3[nInd][1]
        cProdProc := aProcD3[nInd][2]

        if TRB->(dbSeek(cFilProc+"300"+cProdProc+"99 "))
            acertaNivel("SD3"," " ,"z")
        endif

    next nInd
    aSize(aProc,0)
 return

/*/{Protheus.doc} acertaNivel
Acerta nivel de calculo para ordernar de maneira
correta o calculo
@type function
@version 1.0
@author marcio.katsumata
@since 03/08/2020
@param cAliasNiv, character, alias SD1 ou SD2
@param cSubs, character, caractere a ser substituido
@param cNew, character, caractere novo
@return nil, nil
/*/
static function acertaNivel(cAliasNiv,cSubs, cNew, cChave )
    local cChave as character
    local nRecNumber as numeric
    local lDbGoTo as logical
    local nProxRec as numeric
    local nRecNumber as numeric
    
    default cSubs := ""
    default cNew  := ""

    cChave := TRB->(TRB_FILIAL+TRB_ORDEM+TRB_COD+TRB_NIVEL)
    
    while TRB->(!eof()) .and. cChave == TRB->(TRB_FILIAL+TRB_ORDEM+TRB_COD+TRB_NIVEL)

        lDbGoTo := .F.

        nRecNumber := TRB->(recno())
        TRB->(dbSkip())
        nProxRec   := TRB->(recno())
        TRB->(dbGoTo(nRecNumber))


        if TRB->TRB_ALIAS == cAliasNiv
            reclock("TRB", .F.)
            if !empty(cNew)
                TRB->TRB_NIVEL := strtran(TRB->TRB_NIVEL,cSubs, cNew)
            else
                TRB->TRB_NIVEL := iif (cAliasNiv == "SD1", strtran(TRB->TRB_NIVEL,"y", "x"), strtran(TRB->TRB_NIVEL,"x", "y"))
            endif
            TRB->(msUnlock())
            lDbGoTo := .T.

        endif
        
        TRB->(dbSkip())
        if lDbGoTo
            TRB->(dbGoTop())
            TRB->(dbSetOrder(1))
            TRB->(dbSeek(cChave))
            TRB->(dbGoTo(nProxRec))
        endif

    enddo

return 
