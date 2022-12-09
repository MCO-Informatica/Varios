#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MA650TOK ³ Autor ³Ricardo Correa de Souza³ Data ³09/09/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Valida Somatoria de Pecas com Quantidade da OP             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Kenia Industrias Texteis Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/

User Function MA650TOK()

Local _aArea	:=	GetArea()
Local _lRet		:=	.T.
Local _nQtdPecas:=	0
Local _nSaldo	:=	0
Local _nEstrut	:=	0
Local _cMP1		:=	""
Local _cMP2		:=	""
Local _lGeraMSG	:=	.f.
Public _nProduto
Public _nArmazem

If !M->C2_TPOP $ "P"
	
	_nQtdPecas := (M->C2_QUANT_1 + M->C2_QUANT_2 + M->C2_QUANT_3 + M->C2_QUANT_4 + M->C2_QUANT_5 + M->C2_QUANT_6 + M->C2_QUANT_7 + M->C2_QUANT_8 + M->C2_QUANT_9 + M->C2_QUANT_A + M->C2_QUANT_B + M->C2_QUANT_C + M->C2_QUANT_D + M->C2_QUANT_E + M->C2_QUANT_F + M->C2_QUANT_G)
	
	//----> VERIFICA SOMATORIA DAS PECAS
	If  _nQtdPecas <> M->C2_QUANT
		
		MsgBox("A somatória das peças não bate com a quantidade da ordem de produção. Favor ajustar. ","Somatória Peças x Ordem Produção","Stop")
		_lRet	:=	.F.
	EndIf
	//----> RESTAURA AREA ANTERIOR
	RestArea(_aArea)
EndIf

If M->C2_TIPO == "06" .AND. Empty(M->C2_NF_TERC)
	Alert("Campo C2_NF_TERC é obrigatório quando o tipo for igual à 6!","Atenção!")
	_lRet	:=	.F.
EndIf

Return(_lRet)