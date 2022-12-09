#INCLUDE "PROTHEUS.CH"
#INCLUDE "PARMTYPE.CH"
#INCLUDE "MATR777.ch" 
#INCLUDE "FIVEWIN.Ch"

USER FUNCTION VQPICKL()
Local wnrel   := "MATR777"
Local tamanho := "M"
Local titulo  := OemToAnsi(STR0001) //"Pick-List  (Expedicao)"
Local cDesc1  := OemToAnsi(STR0002) //"Emissao de produtos a serem separados pela expedicao, para"
Local cDesc2  := OemToAnsi(STR0003) //"determinada faixa de pedidos."
Local cDesc3  := ""
Local cString := "SC9"
Local cPerg   := "VQPICKL"

PRIVATE aReturn  := {STR0004, 1,STR0005, 2, 2, 1, "",0 } //"Zebrado"###"Administracao"
PRIVATE nomeprog := "MATR777"
PRIVATE nLastKey := 0
PRIVATE nBegin   := 0
PRIVATE aLinha   := {}
PRIVATE li       := 80
PRIVATE limite   := 132
PRIVATE lRodape  := .F.
PRIVATE m_pag    := 1
PRIVATE cCodCli  := ""
PRIVATE cLojCli	 := ""
PRIVATE cCondPg  := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                      ³
//³ mv_par01  De Pedido                                       ³
//³ mv_par02  Imprime pedidos ? 1 - Estoque                   ³
//³                             2 - Credito                   ³
//³                             3 - Estoque/Credito           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,.T.)

If nLastKey == 27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C777Imp(@lEnd,wnRel,cString,cPerg,tamanho,@titulo,@cDesc1,@cDesc2,@cDesc3)},Titulo)
	
return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C777IMP  ³ Autor ³ Flavio Luiz Vicco     ³ Data ³ 30.06.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR777                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C777Imp(lEnd,WnRel,cString,cPerg,tamanho,titulo,cDesc1,cDesc2,cDesc3)

Local cFilterUser := aReturn[7]
Local lUsaLocal  := (SuperGetMV("MV_LOCALIZ") == "S")
Local cbtxt      := SPACE(10)
Local cbcont	 := 0
Local lQuery     := .F.
Local lRet       := .F.
Local cEndereco  := ""
Local nQtde      := 0
Local cAliasNew  := "SC9"
Local aStruSC9   := {}
Local cName      := ""
Local cQryAd     := ""
Local nX         := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
li := 80
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := OemToAnsi(STR0007) //"PICK-LIST"

// "Codigo          Desc. do Material              UM Quantidade  Amz Endereco       Lote      SubLote  Dat.de Validade Potencia"
//            1         2         3         4         5         6         7         8         9        10        11        12        13
//  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
cAliasNew:= GetNextAlias()
aStruSC9 := SC9->(dbStruct())
lQuery := .T.
cQuery := "SELECT SC9.R_E_C_N_O_ SC9REC,"
cQuery += "SC9.C9_PEDIDO,SC9.C9_FILIAL,SC9.C9_QTDLIB,SC9.C9_PRODUTO, "
cQuery += "SC9.C9_LOCAL,SC9.C9_LOTECTL,SC9.C9_POTENCI,"
cQuery += "SC9.C9_NUMLOTE,SC9.C9_DTVALID,SC9.C9_NFISCAL, SC9.C9_CLIENTE, SC9.C9_LOJA, SC5.C5_CONDPAG"
If cPaisLOC <> "BRA" 	
	cQuery += ",SC9.C9_REMITO " 
EndIf	

If lUsaLocal
	cQuery += ",SDC.DC_LOCALIZ,SDC.DC_QUANT,SDC.DC_QTDORIG"
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Esta rotina foi escrita para adicionar no select os campos do SC9 usados no filtro do usuario ³
//³quando houver, a rotina acrecenta somente os campos que forem adicionados ao filtro testando  ³
//³se os mesmo ja existem no selec ou se forem definidos novamente pelo o usuario no filtro.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(aReturn[7])
	For nX := 1 To SC9->(FCount())
		cName := SC9->(FieldName(nX))
		If AllTrim( cName ) $ aReturn[7]
			If aStruSC9[nX,2] <> "M"
				If !cName $ cQuery .And. !cName $ cQryAd
					cQryAd += ",SC9."+ cName
				EndIf
			EndIf
		EndIf
	Next nX
EndIf 
		
cQuery += cQryAd
cQuery += " FROM "
cQuery += RetSqlName("SC9") + " SC9 "
If lUsaLocal
	cQuery += "LEFT JOIN "+RetSqlName("SDC") + " SDC "
	cQuery += "ON SDC.DC_PEDIDO=SC9.C9_PEDIDO AND SDC.DC_ITEM=SC9.C9_ITEM AND SDC.DC_SEQ=SC9.C9_SEQUEN AND SDC.D_E_L_E_T_ = ' '"
EndIf
cQuery += "LEFT JOIN "+RetSqlName("SC5") + " SC5 "
cQuery += "ON SC5.C5_NUM=SC9.C9_PEDIDO AND SC5.D_E_L_E_T_ = ' '"


cQuery += "WHERE SC9.C9_FILIAL  = '"+xFilial("SC9")+"'"
cQuery += " AND  SC9.C9_PEDIDO = '"+mv_par01+"'"

If MV_PAR02 == 1 .Or. MV_PAR02 == 3
	cQuery += " AND SC9.C9_BLEST  = '  '"
EndIf
If MV_PAR02 == 2 .Or. MV_PAR02 == 3
	cQuery += " AND SC9.C9_BLCRED = '  '"
EndIf
If cPaisLOC <> "BRA"
	cQuery += " AND SC9.C9_REMITO = '" +Space(Len(SC9->C9_REMITO))+"' "
EndIf	
cQuery += " AND SC9.D_E_L_E_T_ = ' '"
cQuery += "ORDER BY SC9.C9_FILIAL,SC9.C9_PEDIDO,SC9.C9_CLIENTE,SC9.C9_LOJA,SC9.C9_PRODUTO,SC9.C9_LOTECTL,"
cQuery += "SC9.C9_NUMLOTE,SC9.C9_DTVALID"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNew,.T.,.T.)
For nX := 1 To Len(aStruSC9)
	If aStruSC9[nX][2] <> "C" .and.  FieldPos(aStruSC9[nX][1]) > 0
		TcSetField(cAliasNew,aStruSC9[nX][1],aStruSC9[nX][2],aStruSC9[nX][3],aStruSC9[nX][4])
	EndIf
Next nX

SetRegua(RecCount())
(cAliasNew)->(dbGoTop())
While (cAliasNew)->(!Eof())
	cCodCli := (cAliasNew)->C9_CLIENTE
	cLojCli := (cAliasNew)->C9_LOJA
	cCondPg := (cAliasNew)->C5_CONDPAG

	If!Empty(cFilterUser) .AND. !(&cFilterUser)
		dbSelectArea(cAliasNew)
		dbSkip()
		Loop
	EndIf

	If lUsaLocal
		cEndereco := (cAliasNew)->DC_LOCALIZ
		nQtde     := Iif((cAliasNew)->DC_QUANT>0,(cAliasNew)->DC_QUANT,(cAliasNew)->C9_QTDLIB)
	Else
		cEndereco := ""
		nQtde     := (cAliasNew)->C9_QTDLIB
	EndIf
	
	lRet := C777ImpDet(cAliasNew,lQuery,nQtde,cEndereco,@lEnd,titulo,cDesc1,cDesc2,cDesc3,tamanho)

	If !lRet
		Exit
	EndIf
	(cAliasNew)->(dbSkip())
EndDo

	imprObsCli() //Imprime dados do cliente

If lRodape
	roda(cbcont,cbtxt,"M")
EndIf

If lQuery
	dbSelectArea(cAliasNew)
	dbCloseArea()
	dbSelectArea("SC9")
Else
	RetIndex("SC9")
	Ferase(cIndexSC9+OrdBagExt())
	dbSelectArea("SC9")
	dbClearFilter()
	dbSetOrder(1)
	dbGotop()
EndIf

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	OurSpool(wnrel)
EndIf
MS_FLUSH()
Return NIL

Static Function C777ImpDet(cAliasNew,lQuery,nQtde,cEndereco,lEnd,titulo,cDesc1,cDesc2,cDesc3,tamanho)
Local cabec1 := OemToAnsi(STR0006) //"Codigo          Desc. do Material              UM Quantidade  Amz Endereco       Lote      SubLote  Validade   Potencia    Pedido"
Local cabec2 := ""
Static lFirst := .T.

If li > 55 .or. lFirst
	lFirst  := .F.
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	lRodape := .T.
EndIf

SB1->(dbSeek(xFilial("SB1")+(cAliasNew)->C9_PRODUTO))
// ----
@ li, 00 Psay ">" + (cAliasNew)->C9_PRODUTO	Picture "@!"
@ li, 16 Psay Subs(SB1->B1_DESC,1,30)	Picture "@!"
@ li, 47 Psay SB1->B1_UM   				Picture "@!"
@ li, 50 Psay nQtde						Picture "@E 999,999.99"
@ li, 62 Psay (cAliasNew)->C9_LOCAL
@ li, 66 Psay cEndereco
@ li, 81 Psay (cAliasNew)->C9_LOTECTL	Picture "@!"
@ li, 91 Psay (cAliasNew)->C9_NUMLOTE	Picture "@!"
@ li,101 Psay (cAliasNew)->C9_DTVALID	Picture PesqPict("SC9","C9_DTVALID")
@ li,116 PSay (cAliasNew)->C9_POTENCI	Picture PesqPict("SC9","C9_POTENCI")
@ li,123 Psay (cAliasNew)->C9_PEDIDO	Picture "@!"
li++
	
Return .T.


Static Function imprObsCli()
Local cNom 		:= ""
Local cMunEUF 	:= ""
Local cObs 		:= ""
Local cObsPg	:= ""
local d := 0

If lEnd
	@PROW()+1,001 Psay STR0009 //"CANCELADO PELO OPERADOR"
	Return .F.
EndIf

If SA1->(DbSeek(xFilial("SA1")+cCodCli+cLojCli))
	cNom 	:= TRIM(SA1->A1_NOME)
	cMunEUF := TRIM(SA1->A1_MUN) + "-" + TRIM(SA1->A1_EST)
	cObs	:= TRIM(SA1->A1_VQ_OBSO)
	If SE4->(DbSeek(xFilial("SE4")+cCondPg))
		cObsPg := "Cond. Pagamento: " + cCondPg + " - " + TRIM(SE4->E4_DESCRI)
	EndIf
End
li := li + 3
@ li, 00 Psay "CLIENTE: " 	+ cNom	Picture "@!"
li++
@ li, 00 Psay "Cidade-UF: " + cMunEUF	Picture "@!"
li++
@ li, 00 Psay cObsPg		Picture "@!"
li++

nQtdLin := mlcount(cObs,100)
@ li, 00 Psay "Observações: " Picture "@!"
For nX := 1 to nQtdLin
	@ li, 14 Psay memoline(cObs,100,nX)	Picture "@!"
	li++
Next nX
li := li + 3

@ li, 00 Psay "----------------------------------------------------------------------------------------------------------------------------------" Picture "@!"
li := li + 3

Return