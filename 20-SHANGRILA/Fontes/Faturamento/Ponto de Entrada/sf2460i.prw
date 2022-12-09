#INCLUDE "protheus.ch"

/////////////////////////////////////////////////////////////////////////////////////
//+-------------------------------------------------------------------------------+//
//| PROGRAMA  | SF2460I.PRW           | AUTOR | Marcos Floridi  | DATA | 09/12/2020//
//+-------------------------------------------------------------------------------+//
//| DESCRICAO | Ponto de Entrada - SF2460I()                                      |//
//|           | Grava Volume no Cadastro das NF de Saida.                         |//
//|           |                                                                   |//
//|           |                                                                   |//
//+-------------------------------------------------------------------------------+//
/////////////////////////////////////////////////////////////////////////////////////
User Function SF2460I()

//SF2->F2_VOLUME1 := SC5->C5_VOLUME1
//SF2->F2_XVALFRR := SC5->C5_XVALFRR
//SF2->F2_X_BOX   := SC5->C5_X_BOX
//SF2->F2_DESCONT := 0
//SF2->F2_X_NOMRD := POSICIONE("SA4",1,xFilial("SA4") + SC5->C5_REDESP, "A4_NREDUZ")

//SF2->F2_PLIQUI := SC5->C5_PESOL
//SF2->F2_PBRUTO := SC5->C5_PBRUTO

	_cDoc   := SF2->F2_DOC
	_cSerie := SF2->F2_SERIE
	_cCodCli:= SF2->F2_CLIENTE
	_cCodLj := SF2->F2_LOJA

//_cNumPV := SC5->C5_NUM
	_cQry := "SELECT SUM(D2_QUANT * B1_PESO) PLIQ, SUM(D2_QUANT * B1_PESBRU)  PBRU "
	_cQry += "FROM SD2010 "
	_cQry += "LEFT JOIN SB1010 ON B1_COD = D2_COD AND SB1010.D_E_L_E_T_ = '' "
	_cQry += "WHERE SD2010.D_E_L_E_T_ = '' AND D2_DOC = '"+_cDoc+"' AND D2_SERIE = '"+_cSerie+"' AND D2_CLIENTE = '"+_cCodCli+"' AND D2_LOJA = '"+_cCodLj+"'  "

	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQry),"_PVLIB",.F.,.T.)

	DbSelectArea("_PVLIB")
	_PVLIB->(dbGoTop())

//M->C5_PESOL := _PVLIB->PLIQ //nPesoLiqT
//M->C5_PBRUTO:= _PVLIB->PBRU //nPesoBrtT

	SF2->F2_PLIQUI := _PVLIB->PLIQ //nPesoLiqT
	SF2->F2_PBRUTO := _PVLIB->PBRU //nPesoBrtT

	DBCloseArea("_PVLIB")

	If SF2->F2_VOLUME1 = 0

		Alert("NF-"+SF2->F2_DOC + " Volume está sem preenchimento, Favor Verificar!!!!")

	Elseif Empty(SF2->F2_X_BOX)

		Alert("NF-"+SF2->F2_DOC + " Box está sem preenchimento, Favor Verificar!!!!")

	Endif

Return()

