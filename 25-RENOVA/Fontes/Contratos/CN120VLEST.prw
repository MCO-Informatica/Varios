#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CN120VLESTºAutor  ³Wellington Mendes  º Data ³  Jun/2016    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.³Ponto de entrada que valida se permite ou não estorno medicao.   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RENOVA                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CN120VLEST()

Local _CndMed := CND->CND_NUMERO
Local _cDtIncMed := CND->CND_DTINIC
Local _lret
Local _TipoDup := '' //Gravar quando o tipo do contrato for para gerar titulo
Local aArea		:= GetArea()


dbSelectArea("CN9")
dbSetOrder(1)
dbSeek(xFilial("CN9") + CND->CND_CONTRA + CND->CND_REVISA)

dbSelectArea("CN1")
dbSetOrder(1)
dbSeek(xFilial("CN1") + CN9->CN9_TPCTO)
_TipoDup := CN1->CN1_CTRMED

IF DTOS(_cDtIncMed) <= '20160523'  // Data da globalizacao - compartilhamento da CN9 e tabelas relacionadas.
	MsgStop("A medição: "+_CndMed+" foi incluída antes (Data de Corte 23/05/2016) do processo de globalização dos contratos, a mesma não poderá ser estornada.")
	_lret:=.F.
Elseif DTOS(_cDtIncMed) <= '20180318' .AND. _TipoDup == '2'
	MsgStop("A medição: "+_CndMed+" foi incluída antes de 18/03/2018, Medições de contratos do tipo PC NÂO anterior a essa data não poderão ser estornadas.")
	_lret:=.F.
Else
	_lret:= .T.
Endif

RestArea(aArea)

RETURN(_lret)
