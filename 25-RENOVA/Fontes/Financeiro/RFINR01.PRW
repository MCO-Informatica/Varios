#Include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 02/08/01

#IFNDEF WINDOWS
   #DEFINE PSAY SAY
#ENDIF
                           		
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFINR01  ³ Autor ³ Antonio Maniero Jr.   ³ Data ³ 01.06.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Convertido para Rdmake por :   Luiz Vergari          ³ Data ³ 19.11.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Fluxo de Caixa Analitico por Natureza                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ RFINR01(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFINR01()        // incluido pelo assistente de conversao do AP5 IDE em 02/08/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CSAVSCR2")
SetPrvt("CBTXT,TITULO,CDESC1,CDESC2,CDESC3,CBCONT")
SetPrvt("CABEC1,CABEC2,WNREL,TAMANHO,LIMITE,CSTRING")
SetPrvt("LCONTINUA,J,NDIAS,CARQ,NDISPON,NEL")
SetPrvt("LIMPNAT,NTOTDISP,TRACO,CFOLHA,ACONTAS,DDATAVENC")
SetPrvt("LACHOU,DDATAIMP,NX,NY,NZ,CDIA")
SetPrvt("NREG,NSALDO,NW,ATOTGER,ATOTREC,ATOTPAG")
SetPrvt("ATOTNAT,NCOL,NFOL,LGRAVOU,NTOTREC,NTOTPAG")
SetPrvt("NTOTGER,NVALREC,NVALPAG,NSALDUP,NMULT,NANT")
SetPrvt("NATU,NCNT,CSAV7,CSAV20,NTREGS,CARQSE1")
SetPrvt("CARQSE2,CARQSEG,CARQSED,AFILTER,AMOEDA,ACAMPOS")
SetPrvt("ADIA,ARETURN,NOMEPROG,ALINHA,NLASTKEY,CPERG")
SetPrvt("ACOMPRAS,AVENDAS,XNVALOR,XNCOL,XCTIPO,XNFOL")
SetPrvt("XNDESLOC,LBH,LI,M_PAG,CSUF,MV_PAR01")
SetPrvt("WNTOT,CMASC,CTIPO,CFOL,WTMP,I")
SetPrvt("WNMULT,WCLINHA,WNCOLANT,WNCOLATU,WNCONT,CLINHA")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSavCur1  := ""
cSavRow1  := ""
cSavCol1  := ""
cSavCor1  := ""
cSavScr1  := ""
cSavScr2  := ""
CbTxt     := ""
titulo    := "Fluxo de Caixa Analitico por Natureza                        "
cDesc1    := "Este programa emite o Fluxo de Caixa, informando             "
cDesc2    := "ao usuário quais as suas contas a receber e a pagar dia a    "
cDesc3    := "dia e tambem seu disponível de acordo com os saldos bancarios"
cbCont    := 0
cabec1    := ""
cabec2    := ""
wnrel     := ""
tamanho   := "G"
limite    := 220
cString   := "SE1"
lContinua := .T.
j         := 0
nDias     := 0
cArq      := ""
nDispon   := 0
nEl       := 0
lImpNat   := .T.
nTotDisp  := 0
Traco     := ""
cFolha    := ""
aContas   := {}
dDataVenc := ctod("  /  /  ")
lAchou    := .F.
dDataImp  := ctod("  /  /  ")
nX        := 0
nY        := 0
nZ        := 0
cDia      := ""
nReg      := 0
nSaldo    := 0
nW        := 1
aTotGer   := {0,0,0,0,0,0,0,0,0,0}
aTotRec   := {0,0,0,0,0,0,0,0,0,0}
aTotPag   := {0,0,0,0,0,0,0,0,0,0}
aTotNat   := {0}
nCol      := 1
nFol      := 1
lGravou   := .F.
nTotRec   := 0
nTotPag   := 0
nTotGer   := 0
nValRec   := 0
nValPag   := 0
nSalDup   := 0
nMult     := 0
nAnt      := 4
nAtu      := 4
nCnt      := 0
cSav7     := ""
cSav20    := ""
nTregs    := 0
cArqSE1   := ""
cArqSE2   := ""
cArqSEG   := ""
cArqSED   := ""
aFilter   := { { "SE1" , "a Receber" } , { "SE2" , "a Pagar  " } }
aMoeda    := {{||SM2->M2_MOEDA1},{||SM2->M2_MOEDA2},{||SM2->M2_MOEDA3},{||SM2->M2_MOEDA4},{||SM2->M2_MOEDA5}}
aCampos   := {{"FOLHA","C",2,0},{"TIPO","C",1,0},{"NUM","C",2,0},{"NATUREZA","C",10,0},{"DIA","D",8,0},{"VALOR","N",15,0}}
aDia      := {"Domingo","Segunda","Terca  ","Quarta ","Quinta ","Sexta  ","Sabado "}
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nomeprog  := "RFINR01"
aLinha    := { }
nLastKey  := 0
cPerg     := "FIN640"
aCompras  := {}
aVendas   := {}

xnValor   := 0
xnCol     := 0
xcTipo    := 0
xnFol     := 0
xnDesloc  := 0
lBH       := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a Integridade dos dados de Entrada                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//cSavScr1 := SaveScreen(3,0,24,79)
//cSavCur1 := SetCursor(0)
//cSavRow1 := Row()
//cSavCol1 := Col()
//cSavCor1 := SetColor("bg+/b,,,")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
li    := 80
m_pag := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("FIN640",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        // Nro de Dias                               ³
//³ mv_par02        // Natureza De Receita                       ³
//³ mv_par03        // Natureza Ate Receita                      ³
//³ mv_par04        // Natureza De Despesa                       ³
//³ mv_par05        // Natureza Ate Despesa                      ³
//³ mv_par06        // Imprime por Filial ou Empresa             ³
//³ mv_par07        // Moeda                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cabec1 := ""
cabec2 := ""
traco  := "|------------------------------------------|---------------|---------------|---------------|---------------|---------------|---------------|---------------|---------------|---------------|---------------|---------------|"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "RFINR01"            //Nome Default do relatorio em Disco

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho,aFilter)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString,.F.)

If nLastKey == 27
	Return
Endif       

Processa({|| RFINR01IMP()})

RetIndex("SE1")
Set Filter to

RetIndex("SE2")
Set Filter to

RetIndex("SEG")
Set Filter to

RetIndex("SED")
Set Filter to

dbSelectArea("TRB")
dbCloseArea()

Ferase(cArqSE1+OrdBagExt())
Ferase(cArqSE2+OrdBagExt())
Ferase(cArqSEG+OrdBagExt())
Ferase(cArq+".DBF")
Ferase(cArq+OrdBagExt())

Set Device To Screen

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

RETURN
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFINR01IMPºAutor  ³RIcardo Nunes       º Data ³  07/27/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RFINR01IMP()   

// mv_par06 == 1, trata filial; 2-trata empresa

If Mv_Par06 != 1
    dbSelectArea("SE1")
    cArqSE1 := criatrab("",.f.)
    IndRegua("SE1",cArqSE1,"E1_NATUREZA+DTOS(E1_VENCREA)+E1_NOMCLI+E1_PREFIXO+E1_NUM+E1_PARCELA",,,"Selecionando Registros...")

    dbSelectArea("SE2")
    cArqSE2 := criatrab("",.f.)
    IndRegua("SE2",cArqSE2,"E2_NATUREZA+DTOS(E2_VENCREA)+E2_NOMFOR+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO",,,"Selecionando Registros...")

    dbSelectArea("SEG")
    cArqSEG := criatrab("",.f.)
    IndRegua("SEG",cArqSEG,"DTOS(EG_DATARES)+EG_BANCO+EG_AGENCIA+EG_CONTA",,,"Selecionando Registros...")

    dbSelectArea("SED")
    cArqSED := criatrab("",.f.)
    IndRegua("SED",cArqSED,"ED_CODIGO",,,"Selecionando Registros...")
Else
    dbSelectArea("SE1")
    cArqSE1 := criatrab("",.f.)
    IndRegua("SE1",cArqSE1,"E1_FILIAL+E1_NATUREZA+DTOS(E1_VENCREA)+E1_NOMCLI+E1_PREFIXO+E1_NUM+E1_PARCELA",,,"Selecionando Registros...")

    dbSelectArea("SE2")
    cArqSE2 := criatrab("",.f.)
    IndRegua("SE2",cArqSE2,"E2_FILIAL+E2_NATUREZA+DTOS(E2_VENCREA)+E2_NOMFOR+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO",,,"Selecionando Registros...")
Endif

Inkey( 1 )					//Tempo na cri‡„o, pois apresenta problema no AXS 3.2

cArq := CriaTrab(aCampos)
dbUseArea( .T.,, cArq, "TRB",.F.,.F.)

cSuf := Str(Mv_Par07,1)
Titulo := Titulo + " em "+GetMV("MV_MOEDA"+cSuf)

//IIF(Mv_Par07 != 1,SM2->(DbSeek(dDataBase)),Nil)

If Mv_Par07 != 1
	dbSelectArea("SM2")
	dbSeek(dDataBase)
Endif

Afill(aTotGer,0)
Afill(aTotRec,0)
Afill(aTotPag,0)

Mv_Par01 := Int(Mv_Par01/10+0.9)*10

dbSelectArea("SED")
WnTot := LastRec()

//BarraHorizontal()
//SED->(LastRec()))
//dbSelectArea("SED")

ProcRegua(WnTot)

If mv_par06 == 1
	dbSeek(xFilial()+Mv_par02,.T.)
Else
    dbseek(""+Mv_Par02,.T.)
Endif

// SED->(dbseek(Iif(mv_par06 == 1,cFilial,"")+Mv_Par02,.T.))

While !Eof()  .And. SED->ED_CODIGO <= Mv_Par03 .and. (Mv_Par06 != 1 .or. SED->ED_FILIAL == xFilial("SED")) .and. Inkey() != 286

   IncProc( "Processando Naturezas a Receber " + SED->ED_CODIGO )
   
//   BarraHorizontal()

   nX := 1
   nCol := 1
   
   While nFol*10 <= Mv_Par01
   
      nValRec := 0
      nValPag := 0
      
	  If nCol > 10
         nCol := 1
         nFol :=nFol + 1 
	  Endif
	  
	  If Dow(dDataBase+nX-1) != 1 .and. Dow(dDataBase+nX-1) != 7
	  
			dbSelectArea("SE1")
			
			If mv_par06 == 1
				dbSeek(Xfilial()+SED->ED_CODIGO+Dtos(dDataBase+nX-1) )
			Else
				dbSeek(""+SED->ED_CODIGO+Dtos(dDataBase+nX-1) )
 			Endif
 			
			// SE1->(DbSeek(Iif(mv_par06 == 1,cFilial,"")+SED->ED_CODIGO+Dtos(dDataBase+nX-1)))

			While !Eof() .And. SE1->E1_NATUREZ == SED->ED_CODIGO .and. SE1->E1_VENCREA == dDataBase+nX-1 .and. (Mv_Par06 != 1 .or. SE1->E1_FILIAL == xFilial("SE1"))

               If Substr(SE1->E1_TIPO,1,2) != "RA" .and. SE1->E1_SITUACA != "2"
                  nSalDup := xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,Mv_Par07,SE1->E1_VENCREA)
                  nValRec := nValRec + IIF(Substr(SE1->E1_TIPO,3,1) != "-",nSaldup,-nSalDup)
		       Endif
		       
			   dbSelectArea("SE1")	
			   dbSkip()
			   
			Enddo

			xnValor  := nValRec
			xnCol    := nCol
			xcTipo   := "1" 
			xnFol    := nFol
			xnDesloc := nX 
			
			Fa060Trab()
			
			// nValRec,nCol,"1",nFol,nX)

            lGravou := .T.
            
	  Endif
	  
	  Iif(lGravou,nCol:=nCol+1,Nil)
	  
      lGravou := .F.
      nX := nX + 1
      
   Enddo
   
   For nZ := 0 To 10-nCol
		xnValor  := 0
		xnCol    := nCol+nZ
		xcTipo   := "1" 
		xnFol    := nFol
		xnDesloc := nX-1 
		
		Fa060Trab()
		
		// 0,nCol+nZ,"1",nFol,nX-1)

		xnValor  := 0
		xnCol    := nCol + nZ
		xcTipo   := "2" 
		xnFol    := nFol
		xnDesloc := nX - 1 
		Fa060Trab()
		// 0,nCol+nZ,"2",nFol,nX-1)
        nX := nX + 1
   Next       
	
   dbSelectArea("SED")
   DbSkip()
   
   nFol := 1
   
Enddo

dbSelectArea("SED")
WnTot := LastRec()

//BarraHorizontal()
// SED->(LastRec()))

ProcRegua(WnTot)

If mv_par06 == 1
	dbSeek(XFilial()+Mv_par04,.T.)
Else
	dbSeek(""+Mv_Par04,.T.)
Endif

// SED->(dbseek(Iif(mv_par06 == 1,cFilial,"")+Mv_Par04,.T.))

While !Eof() .And. SED->ED_CODIGO <= Mv_Par05 .and. (Mv_Par06 != 1 .or. SED->ED_FILIAL == xFilial("SED")) .and. Inkey() != 286 

   IncProc( "Processando Naturezas a Pagar " + SED->ED_CODIGO )
   
//   BarraHorizontal()

   nX := 1
   nCol := 1
   
   While nFol*10 <= Mv_Par01
   
      nValRec := 0
      nValPag := 0
      
   	  If nCol > 10
         nCol := 1
         nFol := nFol + 1
	  Endif
	  
	  If Dow(dDataBase+nX-1) != 1 .and. Dow(dDataBase+nX-1) != 7
	  
         dbSelectArea("SE2")
         
		 If mv_par06 == 1
		    dbSeek(XFilial()+SED->ED_CODIGO+Dtos(dDataBase+nX-1) )
		 else
		    dbSeek(""+SED->ED_CODIGO+Dtos(dDataBase+nX-1) )
		 Endif
		 
		 // SE2->(DbSeek(Iif(mv_par06 == 1,cFilial,"")+SED->ED_CODIGO+Dtos(dDataBase+nX-1)))

		 While !Eof() .And. SE2->E2_NATUREZ == SED->ED_CODIGO .and. SE2->E2_VENCREA == dDataBase+nX-1 .and. ;
					(Mv_Par06 != 1 .or. SE2->E2_FILIAL == xFilial("SE2")) .and. (SE2->E2_NATUREZ >= MV_PAR04 .OR. SE2->E2_NATUREZ <= MV_PAR05)
					
			If Substr(SE2->E2_TIPO,1,2)!="RA" 
   			   nSalDup := xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,Mv_Par07,SE2->E2_VENCREA)
			   nValPag := nValPag + IIF(Substr(SE2->E2_TIPO,3,1) != "-",nSaldup,-nSalDup)
			Endif
			
			dbSelectArea("SE2")
			dbSkip()
			
		 Enddo

		 xnValor  := nValPag
		 xnCol    := nCol
		 xcTipo   := "2" 
		 xnFol    := nFol
		 xnDesloc := nX 
		 
	 	 Fa060Trab()
	 	 
		 // nValPag,nCol,"2",nFol,nX)

         lGravou := .T.
         
	  Endif
	  
	  Iif(lGravou,nCol:=nCol+1,Nil)
	  
      lGravou := .F.
      nX := nX + 1
      
   Enddo
   
   For nZ := 0 To 10-nCol
		xnValor  := 0
		xnCol    := nCol + nZ
		xcTipo   := "1" 
	    xnFol    := nFol
   	    xnDesloc := nX - 1 
   	    
		Fa060Trab()
		
		// 0,nCol+nZ,"1",nFol,nX-1)

		xnValor  := 0
		xnCol    := nCol + nZ
		xcTipo   := "2" 
		xnFol    := nFol
		xnDesloc := nX - 1 
		
		Fa060Trab()
		
		// 0,nCol+nZ,"2",nFol,nX-1)
		
		nX := nX + 1
   Next
   
   dbSelectArea("SED")
   DbSkip()
   
   nFol := 1
   
Enddo

dbSelectArea("TRB")
WnTot := LastRec()

//BarraHorizontal()

DbGoTop()
cMasc := TRB->NATUREZA
nY := 0

While !Eof() .and. Inkey() != 286 
//	BarraHorizontal()
	If cMasc != TRB->NATUREZA
      nReg := Recno()
      For nX := 1 To nY
		 DbSkip(-1)
         If TRB->TIPO == "1" .and. nTotRec == 0
			DbDelete()
		 Endif
         // Iif(TRB->TIPO == "1" .and. nTotRec == 0,TRB->(DbDelete()),Nil)

         If TRB->TIPO == "2" .and. nTotPag == 0
			DbDelete()
		 Endif
		 // Iif(TRB->TIPO == "2" .and. nTotPag == 0,TRB->(DbDelete()),Nil)
	  Next
	  DbGoto(nReg)
      nTotRec := 0
      nTotPag := 0
      nY := 0
	  cMasc := TRB->NATUREZA
	Endif		
	nY := nY + 1
    nTotRec := nTotRec + Iif(TRB->TIPO=="1",TRB->VALOR,0)
    nTotPag := nTotPag + Iif(TRB->TIPO=="2",TRB->VALOR,0)
	DbSelectArea("TRB")	
	DbSkip()
End

IndRegua("TRB",cArq,"FOLHA+TIPO+NATUREZA+Dtos(DIA)",,,"Selecionando Registros...")

nTotRec := 0
nTotPag := 0

DbSelectArea("TRB")
DbGoBottom()

cFolha := FOLHA

DbGotop()

dele all for DIA > (dDataBase+mv_par01)

Pack

dbGoTop( )

If Reccount() == 0
	Set Device To Screen
//	RestScreen(3,0,24,79,cSavScr1)
//	SetCursor(cSavCur1)
	Set Printer To
	dbCommitAll()
	If aReturn[5] == 1
		ourspool(wnrel)
		MS_FLUSH()
	Endif
    Return
Endif

ProcRegua(RecCount())

nZ := 1

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)

@li,00 PSAY Replicate("*",220)

li:=li+1

@li,00 PSAY "|              HISTORICO/DIAS              |"

For nY := 1 To 10
	If Dow(TRB->DIA+nZ-1) != 1 .and. Dow(TRB->DIA+nZ-1) != 7
                @ li,nY*16+28 PSAY "   "+Dtoc(TRB->DIA+nZ-1)+"    |"
	Else
      nY := nY - 1
	Endif
   nZ := nZ + 1
Next

@ li ,204 PSAY Iif(cFolha!=TRB->FOLHA,"  SUBTOTAL DA  |","   TOTAL DA    |")

li:=li+1

nZ := 1

@ li,00 PSAY "|                                          |"

For nY := 1 To 10
	If Dow(TRB->DIA+nZ-1) != 1 .and. Dow(TRB->DIA+nZ-1) != 7
       @ li,nY*16+28 PSAY "    "+aDia[Dow(TRB->DIA+nZ-1)]+"    |"
	Else
		nY := nY - 1
	Endif
   nZ := nZ + 1
Next

@li ,204 PSAY "   NATUREZA    |"

li:=li+1

@li ,00 PSAY Traco

li:=li+1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime disponibilidade Bancaria                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SA6")
dbSeek(xFilial())

While !Eof() .and. SA6->A6_FILIAL == xFilial("SA6")
	If Substr(SA6->A6_COD,1,2) == "CX"
      nDispon := nDispon + IIf(Mv_Par07 != 1,(SA6->A6_SALATU/Eval(aMOEDA[Val(cSuf)])),SA6->A6_SALATU)
	Endif
    dbSkip()
EndDO

@ li,00 PSAY "| SALDO EM CAIXA                           |"+Transform(nDispon,Tm(nDispon,15,0))+"|               |               |               |               |               |               |               |               |               |               |"
li:=li+1

nTotDisp := nTotDisp + nDispon
nDispon  := 0

dbSeek(XFilial())

While !Eof() .and. SA6->A6_FILIAL == xFilial("SA6")
	If Substr(SA6->A6_COD,1,2) != "CX"
      nDispon := nDispon + IIf(Mv_Par07 != 1,(SA6->A6_SALATU/Eval(aMOEDA[Val(cSuf)])),SA6->A6_SALATU)
	Endif
    dbSkip()
EndDO

@ li,00 PSAY "| SALDO EM BANCOS                          |"+Transform(nDispon,Tm(nDispon,15,0))+"|               |               |               |               |               |               |               |               |               |               |"
li:=li+1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existe aplica‡„o a ser resgatada no dia           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SEG")

nTotDisp := nTotDisp + nDispon
nDispon  := 0

If Mv_Par06 == 1
   dbSetOrder(2)
   dbSeek(XFilial()+Dtos(dDataBase),.t.)
Else
   dbSeek(Dtos(dDataBase),.t.)
Endif

While !Eof() .And. SEG->EG_DATARES<=dDataBase+Mv_Par01 .and. (Mv_Par06 != 1 .or. SEG->EG_FILIAL == xFilial("SEG"))
   nDispon := nDispon + IIF(Mv_Par07==1,SEG->EG_VALOR,SEG->EG_VALOR/Eval(aMOEDA[Val(cSuf)]))
   dbSkip()
EndDO

nTotDisp := nTotDisp + nDispon

@ li,00 PSAY "| SALDO EM APLICACOES                      |"+Transform(nDispon,Tm(nDispon,15,0))+"|               |               |               |               |               |               |               |               |               |               |"
li:=li+1

@ li,00 PSAY "| TOTAL DO DISPONIVEL                      |"+Transform(nTotDisp,Tm(nDispon,15,0))+"|               |               |               |               |               |               |               |               |               |               |"
nSaldo := nTotDisp

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Soma Contas a Receber pela Natureza e Vencimento              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")

WnTot := Lastrec()

//BarraHorizontal()

cMasc := "@@@@@@@@@@"
cTipo := "@"
cFol  := "@@"
nX    := 1

While !Eof() .and. Inkey() != 286 

   IncProc( "Imprimindo... " )
    
   //BarraHorizontal()

   IF li >= 58 .and. nX == 1
   
      If li < 80
          @Prow()+1,00 PSAY Traco
	  Endif
	  
      nZ := 1
      
	  cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	  
      @ li,00 PSAY Replicate("*",220)
	  li:=li+1
      @ li,00 PSAY "|              HISTORICO/DIAS              |"
      
      For nY := 1 To 10
	  	  If Dow(TRB->DIA+nZ-1) != 1 .and. Dow(TRB->DIA+nZ-1) != 7
              @ li,nY*16+28 PSAY "   "+Dtoc(TRB->DIA+nZ-1)+"    |"
	  	  Else
	    	  nY := nY - 1
		  Endif
		  nZ := nZ + 1
	  Next
	  
      @ li,204 PSAY Iif(cFolha!=TRB->FOLHA,"  SUBTOTAL DA  |","   TOTAL DA    |")
      li:=li+1
      nZ := 1
      @li,00 PSAY "|                                          |"
      
      For nY := 1 To 10
	 	  If Dow(TRB->DIA+nZ-1) != 1 .and. Dow(TRB->DIA+nZ-1) != 7
              @ li,nY*16+28 PSAY "    "+aDia[Dow(TRB->DIA+nZ-1)]+"    |"
		  Else
              nY := nY - 1
		  Endif
          nZ := nZ  + 1
	  Next
      
      @ li ,204 PSAY "   NATUREZA    |"
 	  li:=li+1
      @li,00 PSAY Traco
      
   Endif
   
   If cTipo != TRB->TIPO
  	  If TRB->TIPO == "1"
    	  li:=li+1
          @ li,00 PSAY "| RECEBIMENTOS                             |               |               |               |               |               |               |               |               |               |               |               |"
	  Else
		  li:=li+1
          @ li,00 PSAY "| PAGAMENTOS                               |               |               |               |               |               |               |               |               |               |               |               |"
	  Endif
	  cTipo:=TRB->TIPO
   Endif
   
   If cTipo+cMasc+cFol != TRB->TIPO+TRB->NATUREZA+TRB->FOLHA
	   li:=li+1	
	   
       dbSelectArea("SED")
       
       If Mv_Par06==1
           DbSeek(xFilial()+TRB->NATUREZA)
       Else  
           DbSeek(""+TRB->NATUREZA)
       Endif
       
       If Found()
           Wtmp:=SUBSTR(SED->ED_DESCRIC,1,23)
       Else
           Wtmp:="NATUREZA NAO ENCONTRADA !!!   "
       Endif
       
       @ Li,000 PSAY "| "+TRB->NATUREZA+Alltrim(Wtmp)
       @ Li,043 PSAY "|"
       //@ Li,000 PSAY "| "+TRB->NATUREZA+DescNat(Iif(Mv_Par06==1,xFilial("SED"),"")+TRB->NATUREZA)+" |"

   	   cMasc:=TRB->NATUREZA
	   cFol:=TRB->FOLHA
	   
   Endif
   
   @ Li,Val(TRB->NUM)*16+28 PSAY Transform(TRB->VALOR,Tm(TRB->VALOR,15,0))+"|"
   
   aTotNat[nW]:=aTotNat[nW] + TRB->VALOR
   aTotRec[Val(TRB->NUM)]:=aTotRec[Val(TRB->NUM)]+Iif(TRB->TIPO=="1",TRB->VALOR,0)
   aTotPag[Val(TRB->NUM)]:=aTotPag[Val(TRB->NUM)]+Iif(TRB->TIPO=="2",TRB->VALOR,0)
   aTotGer[Val(TRB->NUM)]:=aTotGer[Val(TRB->NUM)]+Iif(TRB->TIPO=="1",TRB->VALOR,-TRB->VALOR)
   
   nX := nX + 1
	
   dbSelectArea("TRB")
   dbSkip()  
	
   If cTipo+cMasc+cFol != TRB->TIPO+TRB->NATUREZA+TRB->FOLHA
	   For i:=nx to 10
            @ Li,i*16+28 PSAY Space(15)+"|"
	   Next
       @ Li,204 PSAY Transform(aTotNat[nW],Tm(aTotNat[nW],15,0))+"|"
	   Aadd(aTotNat,0)
	   nW := nW + 1
	   nX:=1
   Endif
   
   If cTipo != TRB->TIPO
   
	   If cTipo == "1"
           li:=li+1
           @ li,00 PSAY "| TOTAL DE RECEBIMENTOS                    |"
           For nY:=1 To 10
                 @ li,nY*16+28 PSAY Transform(aTotRec[nY],Tm(aTotRec[nY],15,0))+"|"
			     nTotRec:= nTotRec + aTotRec[nY]
		   Next
           @ li,204 PSAY Transform(nTotRec,Tm(nTotRec,15,0))+"|"
		   Afill(aTotRec,0)
		   nTotRec:=0
	   Else
		   li:=li+1
           @ li,00 PSAY "| TOTAL DE PAGAMENTOS                      |"
           For nY := 1 To 10
                  @ li,nY*16+28 PSAY Transform(aTotPag[nY],Tm(aTotPag[nY],15,0))+"|"
		    	  nTotPag:= nTotPag + aTotPag[nY]
		   Next
           @ li,204 PSAY Transform(nTotPag,Tm(nTotPag,15,0))+"|"
		   Afill(aTotPag,0)
		   nTotPag:=0
	  	   nW:=1
		   li:=li+1
           @ li,00 PSAY Traco
           @ Prow()+1,00 PSAY "| RESULTADO DO DIA                         |"
           For nY := 1 To 10
                  @ Prow(),nY*16+28 PSAY Transform(aTotGer[nY],Tm(aTotGer[nY],15,0))+"|"
                  nTotGer := nTotGer + aTotGer[nY]
		   Next
           @ Prow(),204  PSAY Transform(nTotGer,Tm(nTotGer,15,0))+"|"
           @ Prow()+1,00 PSAY Traco
           @ Prow()+1,00 PSAY "| SALDO DO DIA                             |"
           For nY := 1 To 10
                  @ Prow(),nY*16+28 PSAY Transform(nSaldo+aTotGer[nY],Tm(nSaldo+aTotGer[nY],15,0))+"|"
                  nSaldo := nSaldo + aTotGer[nY]
		   Next
           @ Prow(),204  PSAY Transform(nSaldo,Tm(nSaldo,15,0))+"|"
           @ Prow()+1,00 PSAY "+"+Replicate("-",218)+"+"
		   Afill(aTotGer,0)
           nTotGer := 0
           li := 80
	   Endif
   Endif
EndDO

//RetIndex("SE1")
//Set Filter to

//RetIndex("SE2")
//Set Filter to

//RetIndex("SEG")
//Set Filter to

//RetIndex("SED")
//Set Filter to

//dbSelectArea("TRB")
//dbCloseArea()

//Ferase(cArqSE1+OrdBagExt())
//Ferase(cArqSE2+OrdBagExt())
//Ferase(cArqSEG+OrdBagExt())
//Ferase(cArq+".DBF")
//Ferase(cArq+OrdBagExt())

//Set Device To Screen
//RestScreen(3,0,24,79,cSavScr1)
//SetCursor(cSavCur1)

//If aReturn[5] == 1
//	Set Printer TO
//	dbCommitAll()
//	ourspool(wnrel)
//Endif

//MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³BarraHoriz³ Autor ³ Antonio Maniero Jr.   ³ Data ³ 06/06/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Desenha a Barra Horizontal indicando progresso no relatorio ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³BarraHorizontal(WnTot)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 02/08/01 ==> Function BarraHorizontal
Static Function BarraHorizontal()
// (WnTot)

WnMult   := 0
WcLinha  := ""
WnColAnt := 0
WnColAtu := 0
WnCont   := 0

If WnTot != Nil
   nMult := IIF(WnTot>0,70/WnTot,1)
   WnCont := WnColAnt := WnColAtu := 0
//   cLinha:= SaveScreen(23,0,24,79)
Else
   WnCont := WnCont+ 1
   WnColAtu := 3+Int(WnCont*WnMult)
   If WnColAtu != WnColAnt
//  	  RestScreen(23,WnColAtu,24,WnColAtu+3,dCursor(3))
      WnColAnt := WnColAtu
   Endif
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Fa060Trab ³ Autor ³ Antonio Maniero Jr.   ³ Data ³ 06/06/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Grava dados no arquivo de trabalho                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Fa060Trab(nValor,nCol,cTipo,nFol,nDesloc                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 02/08/01 ==> Function Fa060Trab
Static Function Fa060Trab()
// nValor,nCol,cTipo,nFol,nDesloc

dbSelectArea("TRB")
RecLock("TRB",.T.)
Replace TIPO     With xcTipo
Replace NATUREZA With SED->ED_CODIGO
Replace NUM      With Str(xnCol,2)
Replace FOLHA    With Str(xnFol,2)
Replace DIA      With dDataBase+xnDesloc-1
Replace VALOR    With xnValor
MsUnlock( )
Return
