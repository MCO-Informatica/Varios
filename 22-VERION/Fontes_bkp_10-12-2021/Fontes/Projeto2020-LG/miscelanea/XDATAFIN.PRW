
#include "Protheus.ch"       
#include "TopConn.ch"       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XDATAFIN  ºAutor  ³Fernando Macieira   º Data ³ 15/Mar/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Interface que gerencia o fechamento do ambiente financeiro. º±±
±±º          ³MV_DATAFIN                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Verion                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function XDATAFIN()

Local oDlgTit
Local cParam	:= "MV_DATAFIN"
Local aAreaAtu	:= GetArea()
Local aAreaSX6	:= SX6->(GetArea())
Local cTitulo	:= "Atualização do Parâmetro "+AllTrim(cParam)
Local cTexto1	:= ""
Local cTexto2	:= ""
Local cTexto3	:= ""
Local uConteudo	:= ""

dbSelectArea("SX6")
dbSetOrder(1)
If !MsSeek(xFilial("SX6")+cParam)
	Aviso(	cTitulo,;
			"O parâmetro informado não foi localizado no cadastro! Contate o Administrador.",;
			{"&Ok"},,;
			"Parâmetro: "+AllTrim(cParam) )
Else
	cTexto1		:= SX6->X6_DESCRIC
	cTexto2		:= SX6->X6_DESC1
	cTexto3		:= SX6->X6_DESC2
	cTipo		:= SX6->X6_TIPO
	If cTipo == "D"
		uConteudo	:= SToD(AllTrim(SX6->X6_CONTEUDO))
	ElseIf cTipo == "N"
		uConteudo	:= Val(AllTRim(SX6->X6_CONTEUDO))
	Else
		uConteudo	:= AllTrim(SX6->X6_CONTEUDO)
	EndIf
EndIf

DEFINE FONT oFont NAME "Arial" SIZE 0, -12 BOLD

DEFINE MSDIALOG oDlgTit TITLE cTitulo FROM 0,0 TO 160,500 OF oMainWnd PIXEL
	@ 003,007 SAY cTexto1 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
	@ 013,007 SAY cTexto2 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
	@ 023,007 SAY cTexto3 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
	@ 040,007 SAY "Informe a data de fechamento do Financeiro:" OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
	@ 037,135 GET uConteudo Valid(!Empty(uConteudo)) SIZE 110,10 OF oDlgTit PIXEL
	DEFINE SBUTTON oBut2 FROM 060,175 TYPE 1 ENABLE OF oDlgTit PIXEL ACTION(AtuDtFin(uConteudo,cTipo), oDlgTit:End())
	DEFINE SBUTTON oBut3 FROM 060,215 TYPE 2 ENABLE OF oDlgTit PIXEL ACTION(oDlgTit:End())
ACTIVATE MSDIALOG oDlgTit CENTERED

RestArea(aAreaSX6)
RestArea(aAreaAtu)

Return(Nil)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
Static Function AtuDtFin(uConteudo)
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

dbSelectArea("SX6")
RecLock("SX6",.f.)

If cTipo == "D"
	SX6->X6_CONTEUD := DtoS(uConteudo)
ElseIf cTipo == "N"
	SX6->X6_CONTEUD := Str(uConteudo)
Else
	SX6->X6_CONTEUD	:= AllTrim(uConteudo)
Endif

msUnlock()

Return(Nil)
