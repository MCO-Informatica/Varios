#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Kfat15r()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CDESC1,CDESC2,CDESC3,WNREL,TAMANHO,LIMITE")
SetPrvt("CSTRING,ARETURN,NOMEPROG,ALINHA,NLASTKEY,CPERG")
SetPrvt("CVOLPICT,TITULO,CBTXT,CBCONT,LI,M_PAG")
SetPrvt("NNUMNOTA,NTOTVOL,NTOTQTDE,NTOTPESO,NTOTVAL,NQUANT")
SetPrvt("LCONTINUA,NTAMNF,CCOND,CABEC1,CABEC2,NTIPO")
SetPrvt("CINDICE,CTRANSP,CNOTA,AREGS,I,J")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa ³ KFAT15R  ³ Autor ³                       ³ Data ³ 30.08.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³ Relacao de Notas Fiscais Entrada/Saida por Transportadora  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Kenia Industrias Texteis Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Autor        ³  Data  ³              Motivo da Alteracao              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

cDesc1  :=  "Este programa ira emitir a relacao de notas fiscais"
cDesc2  :=  "de entrada e saida por ordem de transportadora."
cDesc3  :=  ""
Wnrel   :=  ""
Tamanho :=  "M"
Limite  :=  132
cString :=  "SF2"

aReturn :=  { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog:=  "KFAT15R"
aLinha  :=  { }
nLastKey:=  0
cPerg   :=  "FAT15R    "
cVolPict:=  PesqPict("SF2","F2_VOLUME1",8)

titulo  :=  "Relacao das Notas Fiscais por Transportadora"
cbtxt   :=  SPACE(10)
cbcont  :=  0
li      :=  80
m_pag   :=  1

ValidPerg()

Pergunte("FAT15R",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // Da Transportadora                     ³
//³ mv_par02            // Ate a Transportadora                  ³
//³ mv_par03            // Da Data                               ³
//³ mv_par04            // Ate a Data                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:="KFAT15R"

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey==27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Set Filter to
	Return
Endif

RptStatus({|| C650Imp()},Titulo)// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> RptStatus({|| Execute(C650Imp)},Titulo)

Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function C650Imp
Static Function C650Imp()

nNumNota    :=  0
nTotVol     :=  0
nTotQtde    :=  0
nTotPeso    :=  0
nTotVal     :=  0
nQuant      :=  0
nValor      :=  0
lContinua   :=  .T.
nTamNF      :=  TamSX3("F2_DOC")
cCond       :=  ""

titulo := "RELACAO DAS NOTAS FISCAIS POR TRANSPORTADORA"
cabec1 := "     TP   NOTA FISCAL    DATA NF             VALOR NF    ORIGEM        MUNICIPIO     UF    DESTINO       MUNICIPIO     UF PESO BRUTO "
*****      012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*****      0         1         2         3         4         5         6         7         8         9        10        11        12        13        14
cabec2 := ""

nTipo  := IIF(aReturn[4]==1,15,18)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Imporessao do Cabecalho e Rodape   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       :=80
m_pag    :=1

//----> NOTAS FISCAIS DE SAIDA

dbSelectArea("SF1")
cIndice := criatrab("",.f.)
cCond   := "Dtos(F1_DTDIGIT)>='"+Dtos(mv_par03)+"'.And.Dtos(F1_DTDIGIT)<='"+Dtos(mv_par04)+"'"
IndRegua("SF1",cIndice,"F1_FILIAL+F1_X_TRANS+F1_DOC+F1_SERIE",,cCond,"Selecionando Registros...")

dbSelectArea("SF2")
cIndice := criatrab("",.f.)
cCond   := "Dtos(F2_EMISSAO)>='"+Dtos(mv_par03)+"'.And.Dtos(F2_EMISSAO)<='"+Dtos(mv_par04)+"'"
IndRegua("SF2",cIndice,"F2_FILIAL+F2_TRANSP+F2_DOC+F2_SERIE",,cCond,"Selecionando Registros...")

dbSeek(xFilial("SF2")+mv_par01,.T.)
SetRegua(RecCount())		// Total de Elementos da regua

While !Eof() .And. xFilial("SF2")==F2_FILIAL .And. F2_TRANSP >= mv_par01 .And. F2_TRANSP <= mv_par02 .And. lContinua
	
	IF lEnd
		@PROW()+1,001 Psay "CANCELADO PELO OPERADOR"
		EXIT
	ENDIF
	IncRegua()
	
	li := 80
	cTransp := F2_TRANSP
	
	dbSelectArea("SA4")
	dbSetOrder(1)
	dbSeek(xFilial("SA4")+cTransp)
	
	dbSelectArea("SF2")
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	
	li  :=  li  +   2
	@ li,000    Psay "TRANSPORTADORA:     "+Alltrim(F2_TRANSP) + ' - ' + SA4->A4_NOME
	li  :=  li  +   1
	
	While !EOF() .AND. xFilial("SF2")==F2_FILIAL .And. F2_TRANSP==cTransp
		
		IF lEnd
			@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
			lContinua := .F.
			Exit
		Endif
		
		If Alltrim(SF2->F2_SERIE) $"1/12/21/33/44"
			dbSelectArea("SF2")
			dbSkip()
			Loop
		EndIf
		
		//----> SOMENTE NOTAS DA KENIA
		If MV_PAR05 == 1
			If Alltrim(SF2->F2_SERIE) $"ONIEMBKEK"
				dbSelectArea("SF2")
				dbSkip()
				Loop
			EndIf
			//----> SOMENTE NOTAS DA ONITEX
		ElseIf MV_PAR05 == 2
			If Alltrim(SF2->F2_SERIE) $"UNIEMBKEK"
				dbSelectArea("SF2")
				dbSkip()
				Loop
			EndIf
			//----> SOMENTE NOTAS DA EMBROIDERY
		ElseIf MV_PAR05 == 3
			If Alltrim(SF2->F2_SERIE) $"ONIUNIKEK"
				dbSelectArea("SF2")
				dbSkip()
				Loop
			EndIf
		//----> SOMENTE NOTAS DA KEK
		ElseIf MV_PAR05 == 4
			If Alltrim(SF2->F2_SERIE) $"ONIUNIEMB"
				dbSelectArea("SF2")
				dbSkip()
				Loop
			EndIf
		EndIf
		
		IncRegua()
		
		dbSelectArea("SD2")
		dbSetorder(3)
		dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE)
		cNota := SF2->F2_DOC+SF2->F2_SERIE
		
		While xFilial("SD2")==D2_FILIAL .And. !Eof() .And. D2_DOC+D2_SERIE == cNota
			
			dbSelectArea("SC5")
			dbSetOrder(1)
			If dbSeek(xFilial("SC5")+SD2->D2_PEDIDO,.F.)
				
				If Alltrim(SC5->C5_NATUREZ)$"0015"
					
					nValor	:=	nValor	+	Iif(SD2->D2_TES$"600" .Or. Alltrim(SD2->D2_COD)$"2207/2221",SD2->D2_TOTAL,0)
					nQuant 	:=	nQuant 	+ 	Iif(SD2->D2_TES$"600" .Or. Alltrim(SD2->D2_COD)$"2207/2221",SD2->D2_QUANT,0)
					
				Else
					nValor	:=	nValor	+	SD2->D2_TOTAL
					nQuant 	:=	nQuant 	+ 	SD2->D2_QUANT
					
				EndIf
			EndIf
			
			dbSelectArea("SD2")
			dbSkip()
		End
		
		If li > 53
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIf
		
		li  :=  li  +   1
		dbSelectArea("SF2")
		@ li,005        Psay "S"
		@ li,Pcol()+004 Psay Substr(cNota,1,6) +"-"+Substr(cNota,7,3)
		@ li,Pcol()+005 Psay F2_EMISSAO
		
		
		//@ li,Pcol()+009 Psay F2_VOLUME1   PicTure cVolPict
		
		If SF2->F2_TIPO$"D/B"
			dbSelectArea("SA2")
			dbSetOrder(1)
			dbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA,.f.)
			//    @ li,Pcol()+002  Psay Subs(A2_NOME,1,30)
		Else
			dbSelectArea("SA1")
			dbSetOrder(1)
			dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,.f.)
			//    @ li,Pcol()+002  Psay Subs(A1_NOME,1,30)
		EndIf
		
		dbSelectArea("SF2")
		//@ li,Pcol()     Psay nQuant        PicTure tm(nQuant,11)
		
		
		@ li,Pcol()+008 Psay nValor        PicTure TM(F2_VALBRUT,12)
		@ li,Pcol()+004 Psay Subs(SM0->M0_BAIRENT,1,10)+" - "
		@ li,Pcol()+001 Psay Subs(SM0->M0_CIDENT,1,10)+" - "
		@ li,Pcol()+001 Psay SM0->M0_ESTENT
		@ li,Pcol()+004 Psay Iif(SF2->F2_TIPO$"D/B",Subs(SA2->A2_BAIRRO,1,10),Subs(SA1->A1_BAIRRO,1,10))+" - "
		@ li,Pcol()+001 Psay Iif(SF2->F2_TIPO$"D/B",Subs(SA2->A2_MUN,1,10),Subs(SA1->A1_MUN,1,10))+" - "
		@ li,Pcol()+001 Psay Iif(SF2->F2_TIPO$"D/B",SA2->A2_EST,SA1->A1_EST)
		@ li,Pcol()+002 Psay F2_PLIQUI Picture TM(F2_PLIQUI,9)
		
		dbSelectArea("SF2")
		
		nNumNota    :=  nNumNota + 1
		nTotVol     :=  nTotVol  + F2_VOLUME1
		nTotQtde    :=  nTotQtde + nQuant
		nTotVal     :=  nTotVal  + nValor
		nTotPeso    :=  nTotPeso + F2_PLIQUI
		nQuant      :=  0
		nValor      :=  0
		
		dbSkip()
	EndDo
	
	//----> NOTAS FISCAIS DE ENTRADA
	dbSelectArea("SF1")
	If dbSeek(xFilial("SF1")+cTransp,.f.)
		While !EOF() .AND. xFilial("SF1")==F1_FILIAL .And. F1_X_TRANS==cTransp
			
			IF lEnd
				@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
				lContinua := .F.
				Exit
			Endif
			
			If Alltrim(SF1->F1_SERIE) $"1/12/21/33/44"
				dbSkip()
				Loop
			EndIf
			
			//----> SOMENTE NOTAS DA KENIA
			If MV_PAR05 == 1
				If Alltrim(SF1->F1_SERIE) $"ONIEMBKEK"
					dbSelectArea("SF1")
					dbSkip()
					Loop
				EndIf
				//----> SOMENTE NOTAS DA ONITEX
			ElseIf MV_PAR05 == 2
				If Alltrim(SF1->F1_SERIE) $"UNIEMBKEK"
					dbSelectArea("SF1")
					dbSkip()
					Loop
				EndIf
				//----> SOMENTE NOTAS DA EMBROIDERY
			ElseIf MV_PAR05 == 3
				If Alltrim(SF1->F1_SERIE) $"ONIUNIKEK"
					dbSelectArea("SF1")
					dbSkip()
					Loop
				EndIf
				//----> SOMENTE NOTAS DA KEK
			ElseIf MV_PAR05 == 4
				If Alltrim(SF1->F1_SERIE) $"ONIUNIEMB"
					dbSelectArea("SF1")
					dbSkip()
					Loop
				EndIf
			EndIf
			
			IncRegua()
			
			dbSelectArea("SD1")
			dbSetorder(1)
			dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE,.f.)
			cNota := SF1->F1_DOC+SF1->F1_SERIE
			
			dbSelectArea("SD1")
			While xFilial("SD1")==D1_FILIAL .And. !Eof() .And. D1_DOC+D1_SERIE == cNota
				nQuant := nQuant + D1_QUANT
				dbSkip()
			End
			
			If li > 53
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			EndIf
			
			li  :=  li  +   1
			dbSelectArea("SF1")
			@ li,005        Psay "E"
			@ li,Pcol()+004 Psay Substr(cNota,1,6) +"-"+Substr(cNota,7,3)
			@ li,Pcol()+005 Psay F1_EMISSAO
			
			
			//@ li,Pcol()+009 Psay F1_X_VOLUM   PicTure cVolPict
			
			If SF1->F1_TIPO$"D/B"
				dbSelectArea("SA1")
				dbSetOrder(1)
				dbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,.f.)
				//    @ li,Pcol()+002  Psay Subs(A1_NOME,1,30)
			Else
				dbSelectArea("SA2")
				dbSetOrder(1)
				dbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,.f.)
				//    @ li,Pcol()+002  Psay Subs(A2_NOME,1,30)
			EndIf
			
			dbSelectArea("SF1")
			//@ li,Pcol()     Psay nQuant        PicTure tm(nQuant,11)
			
			
			@ li,Pcol()+008 Psay F1_VALBRUT    PicTure TM(F1_VALBRUT,12)
			@ li,Pcol()+004 Psay Iif(SF1->F1_TIPO$"D/B",Subs(SA1->A1_BAIRRO,1,10),Subs(SA2->A2_BAIRRO,1,10))+" - "
			@ li,Pcol()+001 Psay Iif(SF1->F1_TIPO$"D/B",Subs(SA1->A1_MUN,1,10),Subs(SA2->A2_MUN,1,10))+" - "
			@ li,Pcol()+001 Psay Iif(SF1->F1_TIPO$"D/B",SA1->A1_EST,SA2->A2_EST)
			@ li,Pcol()+004 Psay Subs(SM0->M0_BAIRENT,1,10)+" - "
			@ li,Pcol()+001 Psay Subs(SM0->M0_CIDENT,1,10)+" - "
			@ li,Pcol()+001 Psay SM0->M0_ESTENT
			@ li,Pcol()+002 Psay F1_X_PESOB Picture TM(F1_X_PESOB,9)
			
			nNumNota    :=  nNumNota + 1
			nTotVol     :=  nTotVol  + F1_X_VOLUM
			nTotQtde    :=  nTotQtde + nQuant
			nTotVal     :=  nTotVal  + F1_VALBRUT
			nTotPeso    :=  nTotPeso + F1_X_PESOB
			nQuant      :=  0
			
			dbSkip()
		EndDo
	EndIf
	
	li  :=  li  +   2
	@ li,000        Psay Replicate("-",Limite)
	li  :=  li  +   1
	@ li,000        Psay "TOTAIS --->"
	@ li,Pcol()     Psay Transform(nNumNota,'999')+" NF(s)"
	//    @ li,Pcol()+009 Psay nTotVol   PicTure cVolPict
	//    @ li,Pcol()+032 Psay nTotQtde  PicTure tm(nTotQtde,11)
	@ li,Pcol()+021 Psay nTotVal   PicTure tm(nTotVal,12)
	@ li,Pcol()+070 Psay nTotPeso  PicTure TM(nTotPeso,9)
	li  :=  li  +   1
	@ li,000        Psay Replicate("-",Limite)
	dbSelectArea("SF2")
	nNumNota    := 0
	nTotVol     := 0
	nTotQtde    := 0
	nTotVal     := 0
	nTotPeso    := 0
EndDo

If li != 80
	roda(cbcont,cbtxt)
Endif

RetIndex("SF2")
Set Filter to
fErase(cIndice+OrdBagExt())

RetIndex("SF1")
Set Filter to
fErase(cIndice+OrdBagExt())

dbSelectArea("SD2")
dbSetOrder(1)

dbSelectArea("SD1")
dbSetOrder(1)

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)

aRegs :={}

Aadd(aRegs,{cPerg,"01","Da Transportadora       ?","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","SA4"})
Aadd(aRegs,{cPerg,"02","Ate a Transportadora    ?","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","SA4"})
Aadd(aRegs,{cPerg,"03","Da Data                 ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Ate a Data              ?","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	EndIf
Next

Return

