#include "rwmake.ch"
#define CRLF Chr(13)+Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0010a  ºAutor  ³Rafael Rodrigues    º Data ³  21/jun/02  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Regra para emissao do documento Certidao de Estudos.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParam.    ³Nenhum.                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ExpL1 : Informando se obteve sucesso                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Gestao Educacional - Requerimentos                          º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0010a()
local aArea		:= GetArea()
local lRet		:= .T.
local cNumRA	:= Left( JBH->JBH_CODIDE, TamSX3("JA2_NUMRA")[1] )
local aScript	:= ACScriptReq( JBH->JBH_NUM )
local aDados	:= {} 
Local aAss		:= {}
local cDataExt	:= "São Paulo, "+Alltrim(Str(Day(dDatabase),2,0))+" de "+MesExtenso(Month(dDatabase))+" de "+StrZero(Year(dDatabase),4,0)+"."
local cQuando, cPerLet 
Local OBS		:= ""  
local cFunSecr   := (SRA->RA_NOME) 
local cNomSecr   := (JBJ->JBJ_DESC)

cPRO := Space(6)
cSEC := Space(6)  
cVar := ""

Processa({||U_ASSREQ(cVar) })

OBS  := msmm( JBH->JBH_MEMO1 )

JA2->(dbSetOrder(1))
JA2->(dbSeek(xFilial("JA2")+cNumRA)) 

SRA->(dbSetOrder(1))
SRA->(dbSeek(xFilial("SRA")+cFunSecr)) 

JBJ->(dbSetOrder(1))
JBJ->(dbSeek(xFilial("JBJ")+cNomSecr))

JAH->(dbSetOrder(1))
JAH->(dbSeek(xFilial("JAH")+aScript[1]))

JBE->(dbSetOrder(1))
JBE->(dbSeek(xFilial("JBE")+cNumRA))
while !eof() .and. JBE->JBE_NUMRA == cNumRA
	cPerLet	:= JBE->JBE_PERLET
	dbSkip()
end

JAR->(dbSetOrder(1))
JAR->(dbSeek(xFilial("JAR")+aScript[1]+cPerlet+aScript[4]))

cQuando	:= Alltrim(Str(Val(JAR->JAR_PERIOD), 2, 0))+"º semestre de "+JAR->JAR_ANOLET

aAdd( aDados, {"SEXO"		, if(JA2->JA2_SEXO == "2", "a aluna", "o aluno") } )
aAdd( aDados, {"NOME"		, Alltrim(JA2->JA2_NOME) } )
aAdd( aDados, {"CURSO"		, Alltrim(Posicione("JAF",1,xFilial("JAF")+JAH->JAH_CURSO+JAH->JAH_VERSAO,"JAF_DESMEC")) } )
aAdd( aDados, {"HABILI"     , aScript[5] } )
aAdd( aDados, {"INSTITUICAO", Alltrim(aScript[10]) } )
aAdd( aDados, {"HOJE"		, cDataExt } )   
aAdd( aDados, {"cOBS"		, OBS } )
aAdd( aDados, {"ASSINATURA"	, "Profª. Luciene Fernandes de Souza" } )
aAdd( aDados, {"CARGO"		, "Secretária de Registros Acadêmicos" } )
aAdd( aDados, {"QUANDO"		, cQuando } )
aAdd( aDados, {"cFuncSecr"	, cFunSecr } )
aAdd( aDados, {"cNomSecr"	, cNomSecr } )

aAss := U_ACRetAss( cSEC )

AAdd( aDados, { "cAss1"  , aAss[1] } )
AAdd( aDados, { "cCargo1", aAss[2] } )

aAss := U_ACRetAss( cPRO )

AAdd( aDados, { "cAss2"  , aAss[1] } )
AAdd( aDados, { "cCargo2", aAss[2] } )

ACImpDoc( JBG->JBG_DOCUM, aDados)

RestArea(aArea)
Return lRet
