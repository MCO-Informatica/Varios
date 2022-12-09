#INCLUDE "PROTHEUS.CH"


	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³MT120OK  ºAutor  ³Roberto Marques      º Data ³  02/28/12   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDesc.     ³ PONTO DE ENTRADA PARA VALIDAR PEDIDO DE COMPRAS COM PMS    º±±
	±±º          ³                                                            º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ AP                                                        º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/

User Function MT120OK()
    Local mSQL := ""
    Local nRet
    //mSQL := "Select COUNT(*)TOTAL FROM AJ7010


    If Select( "TMP" ) > 0
        TMP->( DbCloseArea() )
    EndIf

    mSQL := " SELECT COUNT(*)TOTAL "
    mSQL += " FROM "+ RetSQLName("AJ7")
    mSQL += " WHERE AJ7_NUMPC='"+ca120Num+"' AND AJ7_FILIAL='"+ xFilial ("AJ7") +"' AND D_E_L_E_T_ <>'*' "


    DbUseArea( .T., "TOPCONN", TCGENQRY(,,mSQL),"TMP", .F., .T.)
    TMP->( DbGoTop() )

    IF TMP->TOTAL >= 1
        nRet	:= .T.
    Else
        //Alert("Favor relacionar o Projeto e Tarefa para este Pedido de Compras."+CA120NUM )
        Alert("Projeto e Tarefa não relacionado para este Pedido de Compras."+CA120NUM )
        //nRet	:= .F.
        nRet	:=	.t.
    Endif


Return nRet