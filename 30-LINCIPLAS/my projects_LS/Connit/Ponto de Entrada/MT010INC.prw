#include "rwmake.ch"
#include "vkey.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT010INC º Autor ³Edu Felipe/Marcelo Scibaº Data ³  08/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Envia e-mail para responsáveis de cada área alimentar o        º±±
±±º          ³ cadastro de produtos.					                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Livraria Laselva.              			                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT010INC()

Local aArea		:= GetArea()
Local _nMax		:= 0
Local _nCont	:= 0
Local _aCampos	:= {}

Local cCod		:= SB1->B1_COD
Local cDesc		:= SB1->B1_DESC
Local cLocPad	:= SB1->B1_LOCPAD
Local cGrupo	:= SB1->B1_GRUPO
Local cEdicao	:= SB1->B1_EDICAO
Local cPreco1	:= SB1->B1_PRV1
Local cPreco2	:= SB1->B1_PRV2
Local dEncalhe	:= SB1->B1_ENCALHE

DbSelectArea("SX5")
SX5->( DbSetOrder(1) )
DbSeek(xFilial('SX5') + "ZA")
Do While SX5->( !Eof() ) .and. Alltrim(SX5->X5_TABELA) == "ZA"
	Aadd(_aCampos,{AllTrim(X5_DESCRI)})
	SX5->( DbSkip() )
EndDo

If SB1->B1_GRUPO $ GetMv("MV_GRPISEN")
	_nMax := Len(_aCampos)-1
Else
	_nMax := Len(_aCampos)
EndIf

For _nI := 1 To _nMax
	If Empty(&(_aCampos[_nI,1]))
		_nCont++
	EndIf
Next _nI

_cMsg := ''

For _nI := 1 to len(_aCampos)
	// Alterado por Thiago Queiroz para que todos os grupos passem pela validação do Fiscal - 22/11/2013
	If empty(&(_aCampos[_nI,1])) //.and. !SB1->B1_GRUPO  $ GetMv("MV_GRPISEN")
		_cMsg += 'O campo ' + alltrim(Posicione('SX3',2,substr(_aCampos[_nI,1],6),'X3_TITULO')) + ' não foi informado, pasta '
		_cMsg += SX3->X3_FOLDER + ' - ' + Posicione('SXA',1,'SB1' + SX3->X3_FOLDER,'XA_DESCRIC') + _cEnter
	EndIf
Next
SX3->(DbSetOrder(1))

If !empty(_cMsg)
	_cMsg := 'Verifique o preenchimento dos campos abaixo' + _cEnter + _cEnter + _cMsg
	MsgBox(_cMsg,'Produto não liberado','STOP')
EndIf

If _nCont > 0
	U_CADP003(cCod,cDesc,"INCLUSAO")
	If lCopia
		MsgBox('Produto copiado BLOQUEADO. Solicitar desbloqueio ao depto Fiscal','ATENÇÃO!!!','ALERT')
	EndIf
	RecLock("SB1",.F.)
	Replace SB1->B1_MSBLQL With "1"
	SB1->( MsUnLock() )
EndIf

If LCOPIA
	
	RecLock("SB1",.F.)
	Replace SB1->B1_DTCAD With Date()
	SB1->( MsUnLock() )
	
EndIf

RestArea(aArea)

Return Nil

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ponto de entrada na copia de produtos: traz os campos B1_TS, B1_TE, B1_POSIPI, B1_CONTA, B1_GRTRIB (TABELA ZA DO SX5) em branco para preencimento pelo depto fiscal
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MTA010NC()
/////////////////////////
Local _aArea   := GetArea()
Local _aCampos := {}

DbSelectArea("SX5")
SX5->( DbSetOrder(1) )
DbSeek(xFilial('SX5') + "ZA")
Do While SX5->( !Eof() ) .and. Alltrim(SX5->X5_TABELA) == "ZA"
	aAdd(_aCampos,alltrim(substr(SX5->X5_DESCRI,6)))
	SX5->( DbSkip() )
EndDo

RestArea(_aArea)

Return(_aCampos)