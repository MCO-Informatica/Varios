#Include "RWMAKE.CH"
#Include "TOPCONN.CH" 
#Include "Protheus.Ch"
#INCLUDE 'COLORS.CH'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VldCarga Autor ³ Luiz Alberto        ³ Data ³ 15/04/19 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo  ³ Funcao para validacao antes de confirmar a gravacao do 
				Pedido de vendas.
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ METALACRE                                        ³±±
±±                                                                        ³±±
±±                                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
User Function VldCarga(cProduto,nQtde,dData,cItem,lInclui)
Local aArea := GetArea()
Local lRet  := .T.

DEFAULT lInclui := .F.

If cEmpAnt <> '01'
	Return .T.
Endif

SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+cProduto))

cGrupoProd	:= Iif(!Empty(SB1->B1_XGRUPO),SB1->B1_XGRUPO,SB1->B1_GRUPO)

SBM->(dbSetOrder(1), dbSeek(xFilial("SBM")+cGrupoProd))

cQuery:= " SELECT ZH_DATA, ZH_GRUPO, ZH_CAPGRP, ZH_GRPUSO, ZH_GRPAPR, ZH_SLDGRP "
cQuery+= " FROM " + RetSqlName("SZH") + " ZH "
cQuery+= " INNER JOIN " + RetSqlName("SBM") + " BM "
cQuery+= " ON BM_GRUPO = ZH_GRUPO AND BM.D_E_L_E_T_ = '' "
cQuery+= " WHERE ZH_DATA = '" + DtoS(dData) + "'"
cQuery+= " AND ZH_GRUPO = '" + cGrupoProd + "' "

DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), 'TMPSZH', .F., .T. )
  
If INCLUI .Or. lInclui
	lRet := (nQtde <= TMPSZH->ZH_SLDGRP)
ElseIf ALTERA   
	If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+M->C5_NUM+cItem+cProduto))
		nQtdAtual	:=	(TMPSZH->ZH_GRPAPR - SC6->C6_QTDVEN)
		
		lRet := ((nQtdAtual + nQtde) <= TMPSZH->ZH_CAPGRP)
	Else
		lRet := .t.
	Endif
Endif

//ZH_FILIAL	ZH_DATA	ZH_GRUPO	ZH_CAPGRP	ZH_GRPUSO	D_E_L_E_T_	R_E_C_N_O_	R_E_C_D_E_L_	ZH_SLDGRP	ZH_GRPAPR
//		  	20190809	609 	35000		9000	 				24081		0				4000		22000

              
TMPSZH->(dbCloseArea())


//Alert("Data da Entrega Não Disponivel, pois irá ultrapassar capacidade diária !")
lRet := .t.
RestArea(aArea)
Return lRet
