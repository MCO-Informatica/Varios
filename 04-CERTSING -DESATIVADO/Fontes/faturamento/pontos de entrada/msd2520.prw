#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFS002    ºAutor  ³Rodrigo Seiti Mitaniº Data ³  20/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Liberação de solicitação de atendimento CS                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CertiSign                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function MSD2520()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _AREA := GetArea()
Local _DOC
Local _SERIE
Local _NUMAR
Local _CODCLI
Local _LOJCLI
Local _SerieTit:= GetMv("MV_1DUPREF") 
Local _aTitulo := {}

_DOC		:= SD2->D2_DOC
_SERIE	:= SD2->D2_SERIE
_CODCLI	:= SD2->D2_CLIENTE
_LOJCLI 	:= SD2->D2_LOJA

DbSelectArea("SE1")
DbSetOrder(1)
// DbSeek(xFilial("SE1")+SM0->M0_ESTCOB+Substr(_SERIE,1,1)+_DOC+"0DP")
DbSeek(xFilial("SE1")+&_SerieTit+_Doc+"0DP")
If Found()
	
	lMsHelpAuto := .T.
	lMsErroAuto := .F.
	
	_aTitulo := {;
	{"E1_PREFIXO"	,&_SerieTit			,Nil},;
	{"E1_NUM"		,_Doc         		,Nil},;
	{"E1_PARCELA"	,"0"             	,Nil},;
	{"E1_TIPO"		,"DP "          	,Nil},;
	{"E1_NATUREZ"	,"FT010001"      	,Nil},;
	{"E1_CLIENTE"	,_CODCLI        	,Nil},;
	{"E1_LOJA"		,_LOJCLI          ,Nil},;
	{"E1_NUMREG"	,SC5->C5_AR      	,Nil},;
	{"E1_EMISSAO"	,dDataBase       	,Nil},;
	{"E1_VENCTO"	,GetAdvFVal("SE1","E1_VENCTO",xFilial("SE1")+SM0->M0_ESTCOB+Substr(_SERIE,1,1)+_DOC+" NF ",1,dDataBase)  	,Nil},;
	{"E1_VENCREA"	,GetAdvFVal("SE1","E1_VENCREA",xFilial("SE1")+SM0->M0_ESTCOB+Substr(_SERIE,1,1)+_DOC+" NF ",1,dDataBase) 	,Nil},;
	{"E1_VALOR"		,PA0->PA0_CUSTRA	,Nil},;
	{"E1_ORIGPV"	,'3'	,Nil}}
	
	MSExecAuto({|x,y| FINA040(x,y)},_aTitulo,5)
	If lMsErroAuto
		MostraErro()
		//break
	EndIf
	
EndIf   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0¿
//³Faz a deleção da movimentação do PD.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0Ù

DbSelectArea("SD2")
DbSetOrder(3)
If SD2->(DbSeek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE ))
	While !SD2->(Eof()) .AND. SD2->D2_DOC == SF2->F2_DOC .AND. SD2->D2_SERIE == SF2->F2_SERIE
		DbSelectArea("SZB")
		DbSetOrder(5)
		If DbSeek(xFilial("SZB") + "S" + SD2->D2_COD + SD2->D2_DOC + SD2->D2_SERIE)
			RecLock("SZB",.F.)
			SZB->(DBDelete())
			SZB->(MsUnlock())
		EndIf
		SD2->(DbSkip()) 
	End
EndIf


RestArea(_AREA)
Return