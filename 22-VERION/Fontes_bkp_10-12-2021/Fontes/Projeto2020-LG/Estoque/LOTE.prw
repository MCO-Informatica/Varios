#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"


User Function LOTE()


Local Botao1
Local Botao2
Private Panel1
Private Exec    := .F.
Private cPedido := SPACE(6)
Private _NUMLOTE
Private _NUM
Public odlg_PEDX

//----------------------------------O USUARIO INCLUI O NUMRO DA NOTA

DEFINE MSDIALOG odlg_PEDX TITLE "DIGITE O NUMERO DA NOTA FISCAL" FROM 000, 000  TO 200, 300 PIXEL
@ 001, 001 MSPANEL Panel1        SIZE 300, 200 OF odlg_PEDX
@ 022, 005 SAY "NOTA FISCAL   :"   SIZE 030, 009 OF Panel1 PIXEL
@ 042, 055 MSGET cPedido    VALID !Vazio()  WHEN .T.  PICTURE "@!"  F3 "SF2"  SIZE 035, 010  PIXEL OF Panel1
@ 087, 050 BMPBUTTON TYPE 1 ACTION IIF(Empty(cPedido) ,Alert("O número da Nota Fiscal é obrigatório. Preencha um número válido!"),U_LOTE1(cPedido))
@ 087, 080 BMPBUTTON TYPE 2 ACTION Close(odlg_PEDX)
ACTIVATE MSDIALOG odlg_PEDX CENTERED

RETURN()
//----------------------------------O SISTEMA VERIFICA SE É PARA NUMERAR

USER FUNCTION LOTE1(cPedido)

PRIVATE _PRODUTO
PRIVATE NCONT
PRIVATE D2COD
NCONT := 0


DBSELECTAREA("SD2")                               
DBSETORDER (3)
DBSEEK(XFILIAL("SD2")+cPedido)

D2COD := SD2->D2_COD

DBSELECTAREA("SB1")
DBSETORDER (1)
DBSEEK(XFILIAL("SB1")+D2COD)


//-----------------caso seja kit
//IF SB1->B1_ESTRUT ="SK" .OR. SB1->B1_ESTRUT ="KT" .AND. SB1->B1_LOTE = "S"


CQUERY := "  SELECT B1_ESTRUT ,D2_QUANT, D2_COD, D2_DOC, B1_COD, B1_DESC,G1_COD, G1_COMP                   "
CQUERY += "  FROM SB1020, SG1020, SD2020                                                                   "
CQUERY += "   where D2_DOC = "+cPedido+" "                                                                      "
CQUERY += "  AND D2_COD = B1_COD                                                                           "
CQUERY += " AND G1_COD = B1_COD                                                                            "
CQUERY += " 	AND SG1020.D_E_L_E_T_ = ''                                                                 "
CQUERY += " 	AND SB1020.D_E_L_E_T_ = ''                                                                 "
CQUERY += " 	AND SD2020.D_E_L_E_T_ = ''                                                                 "
CQUERY += " 	AND B1_ESTRUT IN ('1', '2')                                                                "
CQUERY += " 	UNION ALL                                                                                  "
CQUERY += "  	SELECT B1_ESTRUT ,D2_QUANT, D2_COD, D2_DOC, B1_COD, B1_DESC, '' , ''                       "
CQUERY += "  FROM SB1020, SD2020                                                                           "
CQUERY += "   where D2_DOC = "+cPedido+" "                                                                      "
CQUERY += "  AND D2_COD = B1_COD                                                                           "
CQUERY += " 	AND SB1020.D_E_L_E_T_ = ''                                                                 "
CQUERY += " 	AND SD2020.D_E_L_E_T_ = ''                                                                 "
CQUERY += " 	AND B1_ESTRUT = '3'																		"



MEMOWRIT("TOXT.SQL", CQUERY)
TCQUERY CQUERY NEW ALIAS "TOX"

WHILE !EOF()
	FOR Nx := 1 TO 	TOX->D2_QUANT
		RECLOCK("SZL",.T.)
		SZL->ZL_FILIAL 		:= XFILIAL("SZL")
		SZL->ZL_NUMNF       := cPedido
		SZL->ZL_DATA 		:= DDATABASE
		//	SZL->ZL_SERIE       := SF2->F2_SERIE
		SZL->ZL_DESCPRO     := TOX->G1_COD
		SZL->ZL_ESTRUT      := TOX->G1_COMP
		SZL->ZL_DESC        := TOX->B1_DESC
		SZL->ZL_CODPROD     := TOX->B1_COD
		SZL->ZL_QTD         := 1
		
		MSUNLOCK()
		
		NCONT := NCONT+1
	NEXT
	dbSelectArea("TOX")
	DBSKIP()
END
//	SZL->ZL_ITEM        := NCONT

//MSGALERT(NCONT+" PRODUTOS NUMERADOS")
TOX->(DBCLOSEAREA())
/*/-------------------------------------------------------CASO SEJA PC


//ELSEIF SB1->B1_ESTRUT ="PC" .AND. SB1->B1_LOTE = "S"
ADMIN

CQUERY := " SELECT D2_QUANT,D2_COD, D2_DOC, B1_COD, B1_DESC"
CQUERY += " FROM SB1020, SD2020 "
CQUERY += " WHERE D2_COD = B1_COD "
CQUERY += " AND D2_DOC = "+cPedido+" "
CQUERY += "	AND SB1020.D_E_L_E_T_ = '' "
CQUERY += "	AND SD2020.D_E_L_E_T_ = '' "

MEMOWRIT("TOXT.SQL", CQUERY)
TCQUERY CQUERY NEW ALIAS "TOX"


WHILE !EOF()
	
	
	RECLOCK("SZL",.T.)
	SZL->ZL_FILIAL 		:= XFILIAL("SZL")
	SZL->ZL_NUMNF       := cPedido
	SZL->ZL_DATA 		:= DDATABASE
	//	SZL->ZL_SERIE       := SF2->F2_SERIE
	SZL->ZL_DESC      := TOX->B1_DESC
	SZL->ZL_CODPROD     := TOX->B1_COD
	//	SZL->ZL_ITEM        := NCONT
	SZL->ZL_QTD         := TOX->D2_QUANT
	MSUNLOCK()
	NCONT := NCONT+1
	DBSKIP()
END

TOX->(DBCLOSEAREA())

//ELSE
//	MSGALERT("Produto   "+SB1->B1_COD+" - "+SB1->B1_DESC+"  está sem cadastro estrutura (PC, KT, SK)")
//		return()
//ENDIF





//----------------------------------------------------------------------------------------------

NCONT := 1
                                       

SF2->(DBCLOSEAREA())

/*/
DBSELECTAREA("SZL")
DBSETORDER (1)
DBSEEK(XFILIAL("SZL")+cPedido)

WHILE !EOF()
	_PRODUTO := SZL->ZL_CODPROD  //------------------------------------------------------------PEGA O PRODUTO
	//---------------------------------------------------------------PROCURA O ULTIMO NUMERO SERIAL
	
	cQry	:= " SELECT TOP(1)ZL_LOTE  AS  _NUM"
	cQry	+= " FROM SZL020 "
	cQry	+= " WHERE ZL_CODPROD = '"+_PRODUTO+"' "
	cQry	+= " ORDER BY ZL_LOTE DESC "
	
	MEMOWRIT("TPPT.SQL", cQry)
	TCQUERY CQRY NEW ALIAS "TPP"
	DBSELECTAREA("TPP")
	_NUMLOTE := _NUM
	DBCLOSEAREA("TPP")


	IF _NUMLOTE < 000000001 //.OR. _NUMLOTE := ""
		_NUMLOTE := 000000001
	ELSE
		_NUMLOTE := _NUMLOTE + 000000001
	ENDIF
	
	RECLOCK("SZL",.F.)
	SZL->ZL_LOTE 		:= _NUMLOTE
	MSUNLOCK()
	DBSELECTAREA("SZL")
	DBSKIP()


	//	ENDIF
END
SZL->(DBCLOSEAREA())

IF NCONT >0
	MSGALERT("NUMERAÇÃO CONCLUIDA")
ELSE
	MSGALERT("NEHUM ITEM NUMERADO CONCLUIDA")
ENDIF

 ///   odlg_PEDX  ==> verificar 
RETURN()
