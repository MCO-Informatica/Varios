#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     ºAutor  ³Microsiga           º Data ³  09/20/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GeraDic()

Local cPath	:= "\data\20101210\"

If !MsgYesNo("Confirma criação do DD ???")
	Return(.F.)
Endif

RPCSetEnv("99","01")

DbSelectArea("SIX")
SIX->( DbSetOrder(1) )
SIX->( MsSeek( "U00" ) )
COPY TO &(cPath+"SIX.DTC") FOR SIX->INDICE >= "U00" .AND. SIX->INDICE <= "U99"

DbSelectArea("SX2")
SX2->( DbSetOrder(1) )
SX2->( MsSeek( "U00" ) )
COPY TO &(cPath+"SX2.DTC") FOR SX2->X2_CHAVE >= "U00" .AND. SX2->X2_CHAVE <= "U99"

DbSelectArea("SX3")
SX3->( DbSetOrder(1) )
SX3->( MsSeek( "U00" ) )
COPY TO &(cPath+"SX3.DTC") FOR SX3->X3_ARQUIVO >= "U00" .AND. SX3->X3_ARQUIVO <= "U99"

DbSelectArea("SX7")
SX7->( DbSetOrder(1) )
SX7->( MsSeek( "U00" ) )
COPY TO &(cPath+"SX7.DTC") FOR SubStr(SX7->X7_CAMPO,1,3) >= "U00" .AND. SubStr(SX7->X7_CAMPO,1,3) <= "U99" .AND. SubStr(SX7->X7_CAMPO,3,1) <> "_"

DbSelectArea("SX9")
SX9->( DbSetOrder(1) )
SX9->( MsSeek( "U00" ) )
COPY TO &(cPath+"SX9.DTC") FOR SX9->X9_DOM >= "U00" .AND. SX9->X9_DOM <= "U99"

DbSelectArea("SXA")
SXA->( DbSetOrder(1) )
SXA->( MsSeek( "U00" ) )
COPY TO &(cPath+"SXA.DTC") FOR SubStr(SXA->XA_ALIAS,1,3) >= "U00" .AND. SubStr(SXA->XA_ALIAS,1,3) <= "U99"

DbSelectArea("SXB")
SXB->( DbSetOrder(1) )
SXB->( MsSeek( "U00" ) )
COPY TO &(cPath+"SXB.DTC") FOR SubStr(SXB->XB_ALIAS,1,3) >= "U00" .AND. SubStr(SXB->XB_ALIAS,1,3) <= "U99"

MsgStop("Fim...")

Return(.T.)
