#include "rwmake.ch" 
#define CRLF Chr(13)+Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSEC0009a  บAutor  ณRafael Rodrigues    บ Data ณ  21/jun/02  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRegra para emissao do documento Guia de Transferencia.      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParam.    ณNenhum.                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณExpL1 : Informando se obteve sucesso                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGestao Educacional - Requerimentos                          บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณProgramador ณ Data   ณ BOPS ณ  Motivo da Alteracao                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ            ณ        ณ      ณ                                          ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SEC0009a()

local aArea		:= GetArea()
local lRet		:= .F.
local lOk		:= .T.
local cNumRA	:= Left( JBH->JBH_CODIDE, TamSX3("JA2_NUMRA")[1] )
local aRet		:= ACScriptReq( JBH->JBH_NUM )
local aDados	:= {}
local aAss		:= {}
local cDataExt	:= "Sใo Paulo, "+Alltrim(Str(Day(dDatabase),2,0))+" de "+MesExtenso(Month(dDatabase))+" de "+StrZero(Year(dDatabase),4,0)+"."

private cPRO	:= Space(6)
private cSEC	:= Space(6)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Seleciona as assinaturas da pro-reitoria e da secretaria ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
U_AssReq()

JA2->(dbSetOrder(1))
JA2->(dbSeek(xFilial("JA2")+cNumRA))

JAH->(dbSetOrder(1))
JAH->(dbSeek(xFilial("JAH")+aRet[1]))

aAdd( aDados, {"NOME"		, Alltrim(JA2->JA2_NOME) } )
aAdd( aDados, {"CURSO"		, Alltrim(Posicione("JAF",1,xFilial("JAF")+JAH->JAH_CURSO+JAH->JAH_VERSAO,"JAF_DESMEC")) } )
aAdd( aDados, {"HABILI"     , Posicione("JDK",1,xFilial("JDK")+aRet[4],"JDK_DESC")} )
aAdd( aDados, {"INSTITUICAO", Alltrim(aRet[10]) } )
aAdd( aDados, {"HOJE"		, cDataExt } )
aAdd( aDados, {"ASSINATURA"	, "Profช. Luciene Fernandes de Souza" } )
aAdd( aDados, {"CARGO"		, "Secretแria de Registros Acad๊micos" } )

// Caso encontrar o campo 11 e 12 preenchidos no script da solicitacao do requerimento
if Len( aRet ) > 10
	aAdd( aDados, {"cNomSecr" , alltrim( aRet[11]  ) } )
	aAdd( aDados, {"cFuncSecr", alltrim( aRet[12] ) } )
endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Gerando variaveis para assinaturas ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAss := U_ACRetAss( cPRO )

aAdd( aDados, {"cAss1"  , aAss[1] } )
aAdd( aDados, {"cCargo1", aAss[2] } )
aAdd( aDados, {"cRg1"   , aAss[3] } )

aAss := U_ACRetAss( cSEC )

aAdd( aDados, {"cAss2"  , aAss[1] } )
aAdd( aDados, {"cCargo2", aAss[2] } )
aAdd( aDados, {"cRg2"   , aAss[3] } )

JBE->(dbSetOrder(1))

if JBE->(dbSeek(xFilial("JBE")+cNumRA+aRet[1]+aRet[3]+aRet[4]+aRet[6]))
                              
	if JBE->JBE_ATIVO $ "256789AB"	// Nao matriculado
		cSituacao	:=	"Atendendo ao que disp๕e a Portaria do MEC nบ 975/92, informamos que "+if(JA2->JA2_SEXO == "2", "a aluna", "o aluno")+" "+Alltrim(JA2->JA2_NOME)+" "+;
						"nใo renovou matrํcula para o semestre em curso, estando, portanto, sem vํnculo com este "+;
						"Centro Universitแrio, o que impossibilita a expedi็ใo da Guia de Transfer๊ncia."
		cConcl	:=	"  " 
		cConclus	:=	"Colocamo-nos เ disposi็ใo para quaisquer esclarecimentos."
		lOk := .F.
	elseif JBE->JBE_ATIVO == "4"	// Trancado
		cSituacao	:=	"Atendendo ao que disp๕e a Portaria do MEC nบ 975/92, informamos que de acordo com as normas regimentais deste Centro Universitแrio "+if(JA2->JA2_SEXO == "2", "a aluna", "o aluno")+" "+Alltrim(JA2->JA2_NOME)+" "+;
						"encontra-se com a matrํcula trancada no curso "+Alltrim(Posicione("JAF",1,xFilial("JAF")+JAH->JAH_CURSO+JAH->JAH_VERSAO,"JAF_DESMEC"))+" desde "+dtoc(JBE->JBE_DTSITU)+", "
		cConcl	:=	"Oportunamente, encaminharemos a Guia de Transfer๊ncia."   
		cConclus	:=	"Colocamo-nos เ disposi็ใo para quaisquer esclarecimentos."
	elseif JBE->JBE_ATIVO $ "13"	// Ativo;Transferido
		cSituacao	:=	"DECLARAMOS, para os devidos fins de direito, que "+if(JA2->JA2_SEXO == "2", "a aluna", "o aluno")+" "+Alltrim(JA2->JA2_NOME)+", "+;
						"requeriu, nesta secretaria, a TRANSFERสNCIA para "+alltrim(aRet[10])+", de conformidade com a declara็ใo de vaga apresentada."
		cConcl	:=	"DECLARAMOS tamb้m que encaminharemos a Guia de Transf๊rencia, via correio, atendendo ao que determina a Portaria nบ 975, de 25/06/92, D.O.U pแg. 8.161."
		cConclus	:=	" "

	endif
	
	aAdd( aDados, {"SITUACAO"	, cSituacao		} )
	aAdd( aDados, {"CONCL"	, cConcl	} )
	aAdd( aDados, {"cCONCLUSAO1"	, cConclus	} )
	ACImpDoc( JBG->JBG_DOCUM, aDados )

	if lOk
		
		lRet := U_Sec0009b()	// Emite a guia de transferencia
		
	else
		
		lRet := .T.
		
	endif
	
endif

RestArea(aArea)

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSEC0009b  บAutor  ณRafael Rodrigues    บ Data ณ  20/jun/02  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRegra para emissao do documento Guia de Transferencia.      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParam.    ณNenhum.                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณExpL1 : Informando se obteve sucesso                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGestao Educacional - Requerimentos                          บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณProgramador ณ Data   ณ BOPS ณ  Motivo da Alteracao                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ            ณ        ณ      ณ                                          ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SEC0009b()
local aASS 		:= {}
local aArea		:= GetArea()
local lRet		:= .T.
local cNumRA	:= Left( JBH->JBH_CODIDE, TamSX3("JA2_NUMRA")[1] )
local aScript	:= ACScriptReq( JBH->JBH_NUM )
local aDados	:= {}
local cDataExt	:= "Sใo Paulo, "+Alltrim(Str(Day(dDatabase),2,0))+" de "+MesExtenso(Month(dDatabase))+" de "+StrZero(Year(dDatabase),4,0)+"."

JA2->(dbSetOrder(1))
JA2->(dbSeek(xFilial("JA2")+cNumRA))

JAH->(dbSetOrder(1))
JAH->(dbSeek(xFilial("JAH")+aScript[1]))

aAdd( aDados, {"SEXO"		, if(JA2->JA2_SEXO == "2", "a aluna", "o aluno") } )
aAdd( aDados, {"NOME"		, Alltrim(JA2->JA2_NOME) } )
aAdd( aDados, {"CURSO"		, Alltrim(Posicione("JAF",1,xFilial("JAF")+JAH->JAH_CURSO+JAH->JAH_VERSAO,"JAF_DESMEC")) } )
aAdd( aDados, {"HABILI"     , Posicione("JDK",1,xFilial("JDK")+aScript[4],"JDK_DESC")})
aAdd( aDados, {"INSTITUICAO", Alltrim(aScript[10]) } )
aAdd( aDados, {"HOJE"		, cDataExt } )
aAdd( aDados, {"ASSINATURA"	, "Prof. Eduardo Stor๓poli" } )
aAdd( aDados, {"CARGO"		, "Reitor" } )
aAdd( aDados, {"RG"			, "RG nบ 10.633.686" } )
aAss := U_ACRetAss( cPRO )

aAdd( aDados, {"cAss1"  , aAss[1] } )
aAdd( aDados, {"cCargo1", aAss[2] } )
aAdd( aDados, {"cRg1"   , aAss[3] } )

aAss := U_ACRetAss( cSEC )

aAdd( aDados, {"cAss2"  , aAss[1] } )
aAdd( aDados, {"cCargo2", aAss[2] } )
aAdd( aDados, {"cRg2"   , aAss[3] } )

ACImpDoc( "\SEC0009b.dot", aDados )

RestArea(aArea)

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SEC0009c บ Autor ณ Gustavo Henrique   บ Data ณ 28/03/03    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Libera vaga do aluno ao deferir o requerimento, e se a     บฑฑ
ฑฑบ          ณ guia de transferencia foi emitida.                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SEC0009c()

local cNumRA	:= Left( JBH->JBH_CODIDE, TamSX3("JA2_NUMRA")[1] )
local aRet		:= ACScriptReq( JBH->JBH_NUM )
local aPrefixo	:= ACPrefixo()

JBE->(dbSetOrder(1))

if JBE->(dbSeek(xFilial("JBE")+cNumRA+aRet[1]+aRet[3]+aRet[4]+aRet[6]))

	if ! (JBE->JBE_ATIVO $ "356789AB")	// Nao matriculado
		If ExistBlock("ACAtAlu1")
			U_ACAtAlu1("JBE")
		EndIf

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Apaga reservas do aluno e libera vaga no curso, periodo, turma e em todas as disciplinas em que ele estแ matriculado. ณ
		//ณ Atualiza o status no curso e nas disciplinas para transferido e apaga todos os titulos em aberto.                     ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		U_ACLibVaga( cNumRA, aRet[1], aRet[3], aRet[6], aPrefixo, "008", "9", "B", aRet[4] )

		If ExistBlock("ACAtAlu2")
			U_ACAtAlu2("JBE")
		EndIf
     
	endif

endif

Return( .T. )
