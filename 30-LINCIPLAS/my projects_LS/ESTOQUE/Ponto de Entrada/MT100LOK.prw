#Include "rwmake.ch"
#Include "Protheus.ch"
#DEFINE _cEnter CHR(13)+CHR(10)

/*
+=============================================================+
|Programa: MT100LOK |Autor: Antonio Carlos  |Data: 10/08/09   |
+=============================================================+
|Descrição: PE utilizado para validar o preenchimento do campo|
|Serie na rotina de Documento de Entrada.                     |
+=============================================================+
|Uso: Laselva                                                 |
+=============================================================+
*/

User Function MT100LOK()

Local aArea		:= GetArea()
Local _lRet		:= .T.
Local nPosCod	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})
Local nPosTes	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_TES"})
Local nPosPC	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_PEDIDO"})
Local _nCont	:= 0
Local _cGrupo
Local _cSubAs
Local nSaldo    := 0

_lSped := .f.

If Empty(cSerie) .and. cFormul == "N"
	
	MsgStop("Favor informar a serie!")
	_lRet := .F.
	
ElseIf cFormul == 'S'
	
	If at('-9-',GetMv('MV_SERIE01')) <> 0 .and. alltrim(cEspecie) <> 'SPED' .and. alltrim(cSerie) $ '-9-'
		MsgBox('Espécie do documento informada inválida. Alterado automaticamente para espécie SPED')
		cEspecie := 'SPED '
	EndIf
	
ElseIf Len(AllTrim(cNFiscal)) < 9
	
	M->cNFiscal := Strzero(Val(Alltrim(cNFiscal)), 9)
	
EndIf

// ADICIONADO POR THIAGO QUEIROZ - SUPERTECH EM 08/12/2015
IF EMPTY(ALLTRIM(cEspecie))
	MsgStop("Favor informar a Espécie do Documento!")
	_lRet := .F.
ENDIF

If ca100For >= "000009"              
	_cGrupos      := ''
	_cSubAssuntos := ''
	For _nI := 1 To Len(aCols)
		If !aCols[_nI,Len(aHeader)+1]
			
			_cGrupo := Posicione("SB1",1,xFilial("SB1")+aCols[_nI,nPosCod],"B1_GRUPO")
			_cSubAs := Posicione("SB1",1,xFilial("SB1")+aCols[_nI,nPosCod],"B1_CODSA")
			If at(_cGrupo,_cGrupos) == 0
				_cGrupos += _cGrupo + '/'
			EndIf
			If at(_cSubAs,_cSubAssuntos) == 0
				_cSubAssuntos += _cSubAs + '/'
			EndIf
			// GRUPOS: "0001-0002-0003-0004-0006-0007-0008-0010-0016-0017-0018-0019-0029-0031"
			// SUBASSUNTOS: "3802-4104"   
			If _cGrupo $ GetMv("LS_GRUPOPC") .And. !Alltrim(_cSubAs) $ GetMv("LS_SUBASPC")
				If Empty(aCols[_nI,nPosPC])
					_nCont++
				EndIf
			EndIf
			
		EndIf
	Next _nI
EndIf
/*
//____________________________________________________________ Retirado por Ilidio a pedido de Mauricio, para testes !
If _nCont > 0 .and. !l103Auto
	_cTexto := "Não é possível realizar a entrada de itens para a revenda" + _cEnter
	_cTexto += "sem Pedido de Compra, favor providenciar!" + _cEnter + _cEnter
	_cTexto += "Regra: produtos dos grupos " + alltrim(GetMv("LS_GRUPOPC")) + _cEnter
	_cTexto += "exceto sub-assuntos " + alltrim(GetMv("LS_SUBASPC")) + ' exigirão pedidos de compras' + _cEnter + _cEnter
	_cTexto += "Neste pedido: Grupos ("  + _cGrupos + ") e sub-assuntos (" + _cSubAssuntos+ ")"	
	
	MsgBox(_cTexto,'ATENÇÃO!!!','ALERT')
	_lRet := .F.
EndIf
*/
RestArea(aArea)

Return(_lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ExecutaPE³ Autor ³                       ³ Data ³ 23.02.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ PE para validar                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacoes                                                            ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß                             ¢
/*/
************************************************************
User Function ExecutaPE()
************************************************************
Local aPontos := {}

If 	ExistBlock('MT100LOK')
	Aadd( aPontos, 'MT100LOK' )
EndIf

Return(aPontos)