#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 18/01/01

User Function shnfloja()        // incluido pelo assistente de conversao do AP5 IDE em 18/01/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CNUMORC,CRODATXT,NCNTIMPR,TAMANHO,TITULO,CDESC1")
SetPrvt("CDESC2,CDESC3,CSTRING,NTIPO,NOMEPROG,CPERG")
SetPrvt("ADUPL,CABR,CPAG,CTIT,CCAB1,CCAB2,cForma,cDescri")
SetPrvt("CPRG,CLARG,CCONTROLE,CKEY,CKEY3,CKEY2")
SetPrvt("NDUP,LCONTINUA,NTOTREGS,NMULT,NPOSANT,NPOSATU")
SetPrvt("NPOSCNT,ARETURN,NLASTKEY,LI,M_PAG,CNOMARQ")
SetPrvt("WNREL,AAREA,LCABEC,ACONDICOES,AFORMAPGTO,CONTA")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Registra o pagamento da venda                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aFormas := {}
aadd(aFormas,{"Dinheiro ", SL1->L1_DINHEIRO})
aadd(aFormas,{"Cheque   ", SL1->L1_CHEQUES})
aadd(aFormas,{"Cartao   ", SL1->L1_CARTAO})
aadd(aFormas,{"Convenio ", SL1->L1_CONVENI})
aadd(aFormas,{"Financ.  ", SL1->L1_FINANC})
aadd(aFormas,{"Vales    ", SL1->L1_VALES})
aadd(aFormas,{"Outros   ", SL1->L1_OUTROS})
cNumOrc:=SL1->L1_NUM
cRodaTxt := ""
nCntImpr := 0
Tamanho  := "M"
titulo   := "Emissao de Orcamentos"
cDesc1   := "O objetivo deste relatorio e' exibir detalhadamente os orcamentos"
cDesc2   := ""
cDesc3   := ""
cString  := "SL1"
nTipo    := 0
nomeprog := "NFSIGW"
cPerg    := PADR("NFSIGW",LEN(SX1->X1_GRUPO))
aDupl := {{"","",0,ctod("  /  /  ")},{"","",0,ctod("  /  /  ")},;
{"","",0,ctod("  /  /  ")},{"","",0,ctod("  /  /  ")},;
{"","",0,ctod("  /  /  ")},{"","",0,ctod("  /  /  ")},;
{"","",0,ctod("  /  /  ")},{"","",0,ctod("  /  /  ")},;
{"","",0,ctod("  /  /  ")}}

cAbr := "********************************************************************************"
cPag  := 0
cTit := "* O R C A M E N T O                              Data: "+DTOC(DATE())+" Folha..:"
//cCab1:= "                      O R C A M E N T O                      Folha..:"
//cCab2:= ""
cPrg:= "ORCAM"
cLarg:= "P"
cControle:= 18
cKey :=  xFilial("SL1") + cNumOrc
DbSelectArea("SL1")
nTotRegs := 0 ;nMult := 1 ;nPosAnt := 4 ;nPosAtu := 4 ;nPosCnt := 0
lContinua := .T.
aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
//aReturn   := {"Especial", 1, "Administracao", 1, 1, 1, "", 1}
nLastKey := 0
li := 0 ;m_pag := 1
cNomArq:=""

pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 wnrel:=SetPrint("SL1",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")

//wnRel := SetPrint(cString, NomeProg, cPerg, Titulo, cDesc1, cDesc2, cDesc3,;
//.T., {}, .T., Tamanho,.T., , , , , ,.T.)

If LastKey() == 27 .or. nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)
If LastKey() == 27 .or. nLastKey == 27
	Return
Endif

RptStatus({|| Shnfloj()})

Return (.T.)

///////////////////////
Static Function Shnfloj()
nTipo  := IIF(aReturn[4]==1,GetMV("MV_COMP"),GetMV("MV_NORM"))
aArea := GetArea()  // Grava a area atual
li         := 0
lCabec	   := .T.
aCondicoes := {}
aFormaPgto := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no arquivo cabe‡alho										  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea( "SL1" )
DbSeek(cKey)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no arquivo de Clientes									  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea( "SA1" )
DbSeek( xFilial("SA1")+SL1->L1_CLIENTE )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no arquivo de Vendedores 								  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea( "SA3" )
DbSeek( xFilial("SA3")+SL1->L1_VEND )
DbSelectArea("SL1")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no arquivo de Itens										  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For n:= 1 to 2
	IF n==2
		For i:= conta to 28
			li := li + 1
		Next
	Endif
	conta:= 33
	cPag  := 0
	dbSelectArea( "SL2" )
	DbSetOrder(1)
	dbSeek( xFilial("SL2")+cNumOrc )
	While !Eof( ) .and. SL2->L2_NUM == SL1->L1_NUM
		If conta >= 28
			cabor()
		EndIf
		DbSelectArea( "SB1" )
		dbSeek( xFilial("SB1")+SL2->L2_PRODUTO )
		cDescri := SB1->B1_DESC
		DbSelectArea( "SL2" )
		
		@ li,00 PSAY "|"
		@ li,01 PSAY SL2->L2_ITEM
		@ li,05 PSAY Substr(SL2->L2_PRODUTO,1,7)
		@ li,13 PSAY Substr(cDescri,1,30)    // SL2->L2_DESCRI
		@ li,43 PSAY SL2->L2_QUANT   Picture "@E 9,999.99"
		@ li,53 PSAY SL2->L2_UM
		@ li,55 PSAY SL2->L2_VRUNIT  Picture "@E 9,999.99"
		@ li,64 PSAY SL2->L2_VALDESC Picture "@E 999.99"
		@ li,70 PSAY SL2->L2_VLRITEM Picture "@E 99999.99"
		@ li,79 PSAY "|"
		li:=li+1
		conta := conta+1
		If conta >= 28 .and. .not. eof()
			@ li,00 PSAY "|------------------------------------------------------------------------------|"
			li:=li+1
			@ li,00 PSAY "|  C O N T I N U A ..."
			@ li,00 PSAY "|  C O N T I N U A ..."
			@ li,79 PSAY "|"
			li:=li+1
			@ li,00 PSAY "|------------------------------------------------------------------------------|"
		EndiF
		DbSkip()
	EndDo
	If conta>= 28
		cabor()
	EndIf
	@ li,00 PSAY "|------------------------------------------------------------------------------|"
	li:=li+1
	conta := conta+1
	@ li,00 PSAY "|T O T A L .................................................."
	@ li,63 PSAY SL1->L1_VLRTOT      Picture "@E 999,999,999.99"
	@ li,79 PSAY "|"
	li:=li+1
	nPago := 0
	For nF := 1 To Len(aFormas)
		If conta>= 28
			cabor()
		EndIf
		If aFormas[nF,2] > 0
			@ li,00 PSAY "|"+aFormas[nF,1]
			@ li,63 PSAY aFormas[nF,2]   Picture "@E 999,999,999.99"
			@ li,79 PSAY "|"
			nPago +=aFormas[nF,2]
			conta := conta+1
			li:=li+1
		EndIF
	Next
	__nTroco := SL1->L1_VLRTOT - nPago
	conta := conta+1
	@ li,00 PSAY "|T R O C O..................................................."
	@ li,63 PSAY  __nTroco Picture "@E 999,999,999.99"
	@ li,79 PSAY "|"
	li:=li+1
	@ li,00 PSAY "|------------------------------------------------------------------------------|"
	conta := conta+1
Next
RestArea( aArea ) // Restaura a area atual
//  Eject
SetPrc(0,0) // (Zera o Formulario)
cPag  := 0
//  DbCommitAll()

Set Device To Screen

If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif

Ms_FLush()

Return

Static function cabor()
cPag := cPag + 1
li := li + 5
If  n == 1 .And. cPag == 1
	li := 1
Endif

@ li,00 PSAY cAbr
li := li + 1
@ li,00 PSAY cTit
//  If  n == 1
//	@ li,25 PSAY "1a. Via   Fone: 223-1101"
//	@ li,25 PSAY "1a. Via   Fone: 223-1101"
//  Else
//  	@ li,25 PSAY "2a. Via   Fone: 223-1101"
//  	@ li,25 PSAY "2a. Via   Fone: 223-1101"
//  Endif
//  @ li,79 PSAY "*"
@ li,71 PSAY cPag PICTURE "@E 9999"
@ li,79 PSAY "*"
li := li + 1
@ li,00 PSAY cAbr
li := li + 1
@ li,00 PSAY "|Orcamento :"
@ li,17 PSAY SL1->L1_DOC
@ li,28 PSAY "Emissao :"
@ li,38 PSAY SL1->L1_EMISSAO
@ li,49 PSAY "Validade :"
@ li,60 PSAY SL1->L1_DTLIM
@ li,79 PSAY "|"
li := li + 1
@ li,00 PSAY "|Cliente       :"
@ li,17 PSAY SL1->L1_CLIENTE
@ li,25 PSAY "-"
@ li,28 PSAY SA1->A1_NOME
@ li,79 PSAY "|"
li := li + 1
@ li,00 PSAY "|Endereco      :"
@ li,25 PSAY "-"
@ li,28 PSAY SA1->A1_END
@ li,79 PSAY "|"
li := li + 1
@ li,00 PSAY "|Cidade        :"
@ li,28 PSAY SA1->A1_MUN+' - '+SA1->A1_EST+' CEP: '+SA1->A1_CEP
@ li,79 PSAY "|"
li := li + 1
@ li,00 PSAY "|Bairro        :"
@ li,28 PSAY SA1->A1_BAIRRO +' Tel:'+SA1->A1_TEL
@ li,79 PSAY "|"
li := li + 1
@ li,00 PSAY "|Vendedor      :"
@ li,17 PSAY SL1->L1_VEND
@ li,25 PSAY "-"
@ li,28 PSAY SA3->A3_NOME
@ li,79 PSAY "|"
li := li + 1
@ li,00 PSAY "|CGC           :"
@ li,17 PSAY SA1->A1_CGC
@ li,43 PSAY "I.Estadual/RG  :"
@ li,60 PSAY SA1->A1_INSCR
@ li,79 PSAY "|"
li := li + 1
@ li,00 PSAY "|------------------------------------------------------------------------------|"
li := li + 1
@ li,00 PSAY "|It  Cod.    Descricao do Produto           Qtde.    UN    Unit.  Desc.  Total |"
li := li + 1
conta := 16
Return
