#include 'protheus.ch'
#include 'topconn.ch'

/*/{Protheus.doc} nomeFunction
    (long_description)
    @type  Function
    @author Gustavo
    @since 10/03/2021
    @version version
    @param lInicia (.T. Para zerar o parâmetro na primeira chamada.)
    @return nSeg
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function INCCNAB(lInicia)
	Local _aArea    := GetArea()
    Local cMV       := "PZ_INCCNAB"

    //Cria o Parâmetro se ele não existir
	dbSelectArea( "SX6" )
	dbSetOrder(1)
	If !dbSeek( xFilial("SX6") + cMV )
		RecLock("SX6", .T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := cMV
		SX6->X6_TIPO    := "N"
		SX6->X6_DESCRIC := "Usado para controle de numeracao CNAB"
		SX6->X6_CONTEUD := "0"
		SX6->X6_CONTSPA := "0"
		SX6->X6_CONTENG := "0"
		SX6->X6_PROPRI  := "U"
		SX6->X6_PYME    := "S"
		MsUnlock()
	EndIf

	RestArea( _aArea )

    nReg    :=	GetMv(cMv)

	If lInicia
		cReg := '0000'
		PutMv(cMv,1)
	else
		cReg := StrZero(nReg,5)
		PutMv(cMv,nReg+1)
	EndIf

Return cReg
