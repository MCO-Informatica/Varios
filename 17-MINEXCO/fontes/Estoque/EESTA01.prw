#INCLUDE "protheus.ch"

User Function EESTA01()    

_aArea          := GetArea()
_cLote          := GETMV("MV_X_LOTE")         
_cLoteN         := GETMV("MV_X_LOTE")
_cProdRastro    := Posicione("SB1",1,xFilial("SB1")+M->D1_COD,"B1_RASTRO")
_cLoteVazio     := SPACE(TAMSX3("D1_LOTECTL")[1])

dbSelectArea("SB1")
dbSetOrder(1)
IF !cTipo$"D/B"
    IF _cProdRastro == "N"
        _cLoteVazio     := SPACE(TAMSX3("D1_LOTECTL")[1])
        return(_cLoteVazio)
    ELSE                                                                                                           
        PutMV("MV_X_LOTE",Soma1(_cLote))
        return(_cLoteN)
    ENDIF
ENDIF

RestArea(_aArea)

return (_cLoteVazio)


//---------------------------------------------------------------------------------
// Rotina | EESTA04             | Autor | Lucas Baia          | Data | 03/08/2021			
//---------------------------------------------------------------------------------
// Descr. | Gatilho de D3_COD para D1_LOTECTL											
//---------------------------------------------------------------------------------
// Uso    | MINEXCO														
//---------------------------------------------------------------------------------
User Function EESTA04()
 
_cLote := GETMV("MV_X_LOTE")         
_cLoteN:= GETMV("MV_X_LOTE")

PutMV("MV_X_LOTE",Soma1(_cLote))
 
Return(_cLoteN)
