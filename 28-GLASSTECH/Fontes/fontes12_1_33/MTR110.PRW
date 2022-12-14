#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 09/04/03
#include "protheus.ch"

#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function MTR110()        // incluido pelo assistente de conversao do AP6 IDE em 09/04/03

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("WNREL,CDESC1,CDESC2,CDESC3,NBASEIPI,CSTRING")
SetPrvt("LEND,TAMANHO,TITULO,ARETURN,NOMEPROG,NLASTKEY")
SetPrvt("NBEGIN,ALINHA,ADRIVER,CPERG,ASENHAS,AUSUARIOS")
SetPrvt("NHDLALCA,NTAMALCA,NLIDOS,CREGISTRO,NREEM,NSAVREC")
SetPrvt("ASAVREC,LIMITE,LI,NTOTNOTA,NTOTIPI,NDESCPROD")
SetPrvt("NTOTAL,NUMPED,NORDEM,COBS01,COBS02,COBS03")
SetPrvt("COBS04,LLIBERADOR,NCW,CVAR,I,CDESC")
SetPrvt("NLINREF,CDESCRI,NLINHA,MV_PAR06,BBLOCO,BBLOCO1")
SetPrvt("BBLOCO2,UCONT,NK,NTOTDESC,CMENSAGEM,CALIAS")
SetPrvt("NREGISTRO,COBS,NTOTGERAL,CLIBERADOR,NPOSICAO,CSENHAA")
SetPrvt("NX,CRET,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 09/04/03 ==>     #DEFINE PSAY SAY
#ENDIF

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑uncao    ? MATR110  ? Autor ? Wagner Xavier         ? Data ? 05.09.91 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escricao ? Emissao do Pedido de Compras                               낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Uso      ? Generico                                                   낢?
굇쳐컴컴컴컴컵컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴쩡컴컴컴컴컴컴컴눙?
굇? Rdmake   ? Autor ? Tadeu Henrique Bruscato     ? Data ? Wed  15/09/99 낢?
굇읕컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴좔컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
/*/

wnrel     := "MATR110"
cDesc1    := "Emissao dos pedidos de compras ou autorizacoes de entrega"
cDesc2    := "cadastradados e que ainda nao foram impressos"
cDesc3    := " "
nBaseIPI  := 0
cString   := "SC7"
lEnd      := .F.
tamanho   := "P"
titulo    := "Emissao dos Pedidos de Compras ou Autorizacoes de Entrega"
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "MATR110"
nLastKey  := 0
nBegin    := 0
aLinha    := { }
aDriver   := ReadDriver()
cPerg     := "MTR110"
aSenhas   := {}
aUsuarios := {}
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Variaveis utilizadas para parametros                         ?
//? mv_par01               Do Pedido                             ?
//? mv_par02               Ate o Pedido                          ?
//? mv_par03               A partir da data de emissao           ?
//? mv_par04               Ate a data de emissao                 ?
//? mv_par05               Somente os Novos                      ?
//? mv_par06               Campo Descricao do Produto            ?
//? mv_par07               Unidade de Medida:Primaria ou Secund. ?
//? mv_par08               Imprime ? Pedido Compra ou Aut. Entreg?
//? mv_par09               Numero de vias                        ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

Pergunte("MTR110",.F.)

wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif

If mv_par08 == 1
	If File(cArqAlca) .And. GetMV("MV_ALCADA") == "S"
		aUsuarios := {}
        aSenhas   := {}
        nHdlAlca  := FOPEN(cArqAlca,2)
        nTamAlca  := FSEEK(nHdlAlca,0,2)
		FSEEK(nHdlAlca,0,0)
		nLidos := 0
		While nLidos < nTamAlca
			cRegistro := Space(82)
			FREAD(nHdlAlca,@cRegistro,82)
			AADD(aUsuarios,{ cRegistro } )
			AADD(aSenhas,{ SubStr(cRegistro,2,6) } )
            nLidos := nLidos + 82
		End
		FCLOSE(nHdlAlca)
	EndIf

	#IFDEF WINDOWS
        RptStatus({|| C110PC()},titulo)// Substituido pelo assistente de conversao do AP6 IDE em 09/04/03 ==>         RptStatus({|| Execute(C110PC)},titulo)
	#ELSE
        C110PC()
	#ENDIF
Else
	#IFDEF WINDOWS
        RptStatus({|| C110AE()},titulo)// Substituido pelo assistente de conversao do AP6 IDE em 09/04/03 ==>         RptStatus({|| Execute(C110AE)},titulo)
	#ELSE
        C110AE()
	#ENDIF
EndIf

Return





// Substituido pelo assistente de conversao do AP6 IDE em 09/04/03 ==> Function C110PC
Static Function C110PC()
nReem    := 0
nSavRec  := 0
aSavRec  := {}

limite   := 130
li       := 80
nTotNota := 0
nTotIpi  := 0
nDescProd:= 0
nTotal   := 0
NumPed   := Space(6)
ncw2 := 0

dbSelectArea("SC7")
dbSetOrder(1)
dbSeek(xFilial("SC7")+mv_par01,.T.)

SetRegua(RecCount())

#IFNDEF WINDOWS
    @ 0,0 PSAY AvalImp(Limite+2)
#ENDIF

While !Eof() .And. C7_FILIAL == xFilial("SC7") .And. C7_NUM >= mv_par01 .And. ;
		C7_NUM <= mv_par02
	
	nOrdem   := 1
	nReem    := 0
	cObs01   := " "
	cObs02   := " "
	cObs03   := " "
	cObs04   := " "
	
	If C7_EMITIDO == "S" .And. mv_par05 == 1
		dbSkip()
		Loop
	Endif
	
	If (C7_EMISSAO < mv_par03) .Or. (C7_EMISSAO > mv_par04)
		dbSkip()
		Loop
	Endif
	
	If C7_TIPO != 1
		dbSkip()
		Loop
	EndIf
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//? Verifica se Usuario definiu usar o Controle de Alcadas.  ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	lLiberador := .F.
	If GetMV("MV_ALCADA") == "S"
		If !File(cArqAlca)
			lLiberador := .F.
		Else
			lLiberador := .T.
			If Empty(C7_CODLIB)
				dbSkip()
				Loop
			EndIf
		EndIf
	EndIf
	
	If aReturn[4] == 1					// Comprimido
		@ 000,000 PSAY &(aDriver[1])
	ElseIf aReturn[4] == 2				// Normal
		@ 000,000 PSAY &(aDriver[2])
	EndIf
	
	if conditions
        
    endif ncw:= 1 To mv_par09		// Imprime o numero de vias informadas
		
		ImpCabec()
		
		nTotNota := 0
		nTotal   := 0
		nTotIpi  := 0
		nDescProd:= 0
        nTotNota := nTotNota + SC7->C7_FRETE
		nReem    := SC7->C7_QTDREEM + 1
		nSavRec  := SC7->(Recno())
		
		numPed   := SC7->C7_NUM
        While !Eof() .And. C7_FILIAL == xFilial("SC7") .And. C7_NUM == NumPed
		
			If Ascan(aSavRec,Recno()) == 0		// Guardo recno p/gravacao
				AADD(aSavRec,Recno())
			Endif
			#IFNDEF WINDOWS
                If LastKey() == 286    //ALT_A
					lEnd := .t.
				EndIf
			#ENDIF
			If lEnd
				@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
                dbGoBottom()
				Exit
			Endif
			
			IncRegua()
			
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//? Verifica se havera salto de formulario                       ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			If li > 56
                nOrdem := nOrdem + 1
				ImpRodape()			// Imprime rodape do formulario e salta para a proxima folha
				ImpCabec()
			Endif
			
            li := li + 1
			
			@ li,001 PSAY "|"
			@ li,002 PSAY C7_ITEM  		Picture PesqPict("SC7","c7_item")
			@ li,005 PSAY "|"
			@ li,006 PSAY C7_PRODUTO	Picture PesqPict("SC7","c7_produto")
			
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//? Pesquisa Descricao do Produto                                ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			ImpProd()
            nDescProd := CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
            nBaseIPI  := SC7->C7_TOTAL - IIF(SC7->C7_IPIBRUT=="L",nDescProd,0)
            nTotIpi   := nTotIpi+Round(nBaseIPI*SC7->C7_IPI/100,2)
			
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//? Inicializacao da Observacao do Pedido.                       ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			If SC7->C7_ITEM < "05"
                cVar := "cObs"+SC7->C7_ITEM
				Eval(MemVarBlock(cVar),SC7->C7_OBS)
			Endif
			
			dbSkip()
		End
		
		dbGoto(nSavRec)

		If li>38
            nOrdem := nOrdem + 1
			ImpRodape()		// Imprime rodape do formulario e salta para a proxima folha
			ImpCabec()
		End

		FinalPed()		// Imprime os dados complementares do PC
    ENDIF
	Next
	
	For i:=1 to Len(aSavRec)
		dbGoto(aSavRec[i])
		RecLock("SC7",.F.)  //Atualizacao do flag de Impressao
        SC7->C7_QTDREEM := SC7->C7_QTDREEM + 1
        SC7->C7_EMITIDO := "S"
		MsUnLock()
	Next

	dbGoto(aSavRec[Len(aSavRec)])		// Posiciona no ultimo elemento e limpa array
	aSavRec := {}
	
	dbSkip()
End


dbSelectArea("SC7")
Set Filter To
dbSetOrder(1)
dbSelectArea("SX3")
dbSetOrder(1)
Set device to Screen
If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
	Set Printer TO
    dbCommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()
Return










// Substituido pelo assistente de conversao do AP6 IDE em 09/04/03 ==> Function C110AE
Static Function C110AE()
nReem    := 0
nSavRec  := 0
aSavRec  := {}

limite   := 130
li       := 80
nTotNota := 0
nTotIpi  := 0
nDescProd:= 0
nTotal   := 0
NumPed   := Space(6)

dbSelectArea("SC7")
dbSetOrder(1)
dbSeek(xFilial("SC7")+mv_par01,.T.)

SetRegua(RecCount())

#IFNDEF WINDOWS
    @ 0,0 PSAY AvalImp(Limite+2)
#ENDIF

While C7_FILIAL == xFilial("SC7") .And. C7_NUM >= mv_par01 .And. C7_NUM <= mv_par02 .And. !Eof()
	
	nOrdem   := 1
	nReem    := 0
	cObs01   := " "
	cObs02   := " "
	cObs03   := " "
	cObs04   := " "
	
	If C7_EMITIDO == "S" .And. mv_par05 == 1
		dbSkip()
		Loop
	Endif
	
	If (SC7->C7_EMISSAO < mv_par03) .Or. (SC7->C7_EMISSAO > mv_par04)
		dbSkip()
		Loop
	Endif
	
	If SC7->C7_TIPO != 2
		dbSkip()
		Loop
	EndIf
	
	For ncw := 1 To mv_par09		// Imprime o numero de vias informadas
		
		ImpCabec()

		nTotNota := 0
		nTotal   := 0
		nTotIpi  := 0
		nDescProd:= 0
        nTotNota := nTotNota + SC7->C7_FRETE
		nReem    := SC7->C7_QTDREEM + 1
		nSavRec  := SC7->(Recno())
		NumPed   := SC7->C7_NUM

        While !Eof() .And. C7_FILIAL == xFilial("SC7") .And. C7_NUM == NumPed
			
			If Ascan(aSavRec,Recno()) == 0		// Guardo recno p/gravacao
				AADD(aSavRec,Recno())
			Endif
			
			#IFNDEF WINDOWS
                If LastKey() == 286    //ALT_A
					lEnd := .t.
				EndIf
			#ENDIF
			
			If lEnd
				@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
                dbGoBottom()
				Exit
			Endif
			
			IncRegua()
			
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//? Verifica se havera salto de formulario                       ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			If li > 56
                nOrdem := nOrdem + 1
				ImpRodape()		// Imprime rodape do formulario e salta para a proxima folha
				ImpCabec()
			Endif
            li := li + 1
			@ li,001 PSAY "|"
			@ li,002 PSAY SC7->C7_ITEM  	Picture PesqPict("SC7","C7_ITEM")
			@ li,005 PSAY "|"
			@ li,006 PSAY SC7->C7_PRODUTO	Picture PesqPict("SC7","C7_PRODUTO")
			
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//? Pesquisa Descricao do Produto                                ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			ImpProd()		// Imprime dados do Produto

            nDescProd := CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
            nBaseIPI  := SC7->C7_TOTAL - IIF(SC7->C7_IPIBRUT=="L",nDescProd,0)
            nTotIpi   := nTotIpi+Round(nBaseIPI*SC7->C7_IPI/100,2)
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//? Inicializacao da Observacao do Pedido.                       ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			If SC7->C7_ITEM < "05"
                cVar := "cObs"+SC7->C7_ITEM
				Eval(MemVarBlock(cVar),SC7->C7_OBS)
			Endif
			dbSkip()
		End
		
		dbGoto(nSavRec)
		If li>38
            nOrdem := nOrdem + 1
			ImpRodape()		// Imprime rodape do formulario e salta para a proxima folha
			ImpCabec()
		End
		
		FinalAE()		// dados complementares da Autorizacao de Entrega
	Next
	dbGoto(aSavRec[Len(aSavRec)])
	
	For i:=1 to Len(aSavRec)
		dbGoto(aSavRec[i])
		RecLock("SC7",.F.)  //Atualizacao do flag de Impressao
        SC7->C7_EMITIDO := "S"
        SC7->C7_QTDREEM := SC7->C7_QTDREEM + 1
		MsUnLock()
	Next
	aSavRec := {}
	
	dbSkip()
End

dbSelectArea("SC7")
Set Filter To
dbSetOrder(1)

dbSelectArea("SX3")
dbSetOrder(1)

Set device to Screen

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Se em disco, desvia para Spool                               ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
	Set Printer TO
    dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return










// Substituido pelo assistente de conversao do AP6 IDE em 09/04/03 ==> Function ImpProd
Static Function ImpProd()
cDesc   := ""
nLinRef := 1
nBegin  := 0
cDescri := ""
nLinha  := 0

If Empty(mv_par06)
	mv_par06 := "B1_DESC"
EndIf

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Impressao da descricao generica do Produto.                  ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If AllTrim(mv_par06) == "B1_DESC"
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek( xFilial()+SC7->C7_PRODUTO )
	cDescri := Alltrim(SB1->B1_DESC)
	dbSelectArea("SC7")
EndIf

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Impressao da descricao cientifica do Produto.                ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If AllTrim(mv_par06) == "B5_CEME"
	dbSelectArea("SB5")
	dbSetOrder(1)
	If dbSeek( xFilial()+SC7->C7_PRODUTO )
		cDescri := Alltrim(B5_CEME)
	EndIf
	dbSelectArea("SC7")
EndIf

dbSelectArea("SC7")
If AllTrim(mv_par06) == "C7_DESCRI"
	cDescri := Alltrim(SC7->C7_DESCRI)
EndIf

dbSelectArea("SA5")
dbSetOrder(1)
dbSeek(xFilial()+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_PRODUTO)
If Found() .And. !Empty(A5_CODPRF)
	cDescri := cDescri + " ("+Alltrim(A5_CODPRF)+")"
EndIf
dbSelectArea("SC7")

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Imprime da descricao selecionada                             ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
nLinha:= MLCount(cDescri,30)

@ li,021 PSAY "|"
//@ li,022 PSAY SubStr(cDescri,1,30)
@ li,022 PSAY MemoLine(cDescri,30,1)

ImpCampos()
For nBegin := 2 To nLinha
    li := li + 1
	@ li,001 PSAY "|"
	@ li,005 PSAY "|"
	@ li,021 PSAY "|"
	@ li,022 PSAY Memoline(cDescri,30,nBegin)
	@ li,053 PSAY "|"
	@ li,056 PSAY "|"
	@ li,070 PSAY "|"
	@ li,085 PSAY "|"
	If mv_par08 == 1
		@ li,089 PSAY "|"
		@ li,106 PSAY "|"
		@ li,115 PSAY "|"
		@ li,125 PSAY "|"
		@ li,132 PSAY "|"
	Else
		@ li,102 PSAY "|"
		@ li,111 PSAY "|"
		@ li,132 PSAY "|"
	EndIf
Next nBegin

Return












// Substituido pelo assistente de conversao do AP6 IDE em 09/04/03 ==> Function ImpCampos
Static Function ImpCampos()

bBloco  := {|ny| iif(ny==1,"SC7->C7_UM",iif(!Empty(SC7->C7_SEGUM),"SC7->C7_SEGUM","SC7->C7_UM"))}
bBloco1 := {|ny| iif(ny==1,"SC7->C7_QUANT",iif(!Empty(SC7->C7_QTSEGUM),"SC7->C7_QTSEGUM","SC7->C7_QUANT"))}
bBloco2 := {|ny| iif(ny==1,"SC7->C7_PRECO",iif(!Empty(SC7->C7_QTSEGUM),"SC7->C7_TOTAL/SC7->C7_QTSEGUM","SC7->C7_PRECO"))}

uCont := Eval(bBloco,mv_par07)
uCont := &uCont

@ li,053 PSAY "|"
@ li,054 PSAY uCont     Picture PesqPict("SC7","C7_UM")
@ li,056 PSAY "|"

uCont := Eval(bBloco1,mv_par07)
uCont := &uCont

dbSelectArea("SC7")
@ li,057 PSAY uCont    Picture PesqPictQt("C7_QUANT",13)
@ li,070 PSAY "|"

uCont := Eval(bBloco2,mv_par07)
uCont := &uCont

@ li,071 PSAY uCont    Picture PesqPict("SC7","C7_PRECO",14)
@ li,085 PSAY "|"

If mv_par08 == 1
	@ li,086 PSAY SC7->C7_IPI     				 Picture "99"
	@ li,088 PSAY "%"
	@ li,089 PSAY "|"
	@ li,090 PSAY SC7->C7_TOTAL   				 Picture PesqPict("SC7","C7_TOTAL",16)
	@ li,106 PSAY "|"
	@ li,107 PSAY SC7->C7_DATPRF  				 Picture PesqPict("SC7","C7_DATPRF")
	@ li,115 PSAY "|"
	@ li,116 PSAY SC7->C7_CC      				 Picture PesqPict("SC7","C7_CC")
	@ li,125 PSAY "|"
	@ li,126 PSAY SC7->C7_NUMSC
	@ li,132 PSAY "|"
Else
	@ li,086 PSAY SC7->C7_TOTAL   				 Picture PesqPict("SC7","C7_TOTAL",16)
	@ li,102 PSAY "|"
	@ li,103 PSAY SC7->C7_DATPRF  				 Picture PesqPict("SC7","C7_DATPRF")
	@ li,111 PSAY "|"
	//	@ li,112 PSAY Colocar numero da OP
	@ li,132 PSAY "|"
EndIf

nTotNota := nTotNota + SC7->C7_TOTAL
nTotal   := nTotal + SC7->C7_TOTAL

Return













// Substituido pelo assistente de conversao do AP6 IDE em 09/04/03 ==> Function FinalPed
Static Function FinalPed()
nk        := 1
nTotDesc  := SC7->C7_VLDESC
cMensagem := Formula(C7_Msg)

If !Empty(cMensagem)
    li := li + 1
	@ li,001 PSAY "|"
	@ li,002 PSAY Padc(cMensagem,129)
	@ li,132 PSAY "|"
Endif
li := li + 1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"
li := li + 1
While li<39
	@ li,001 PSAY "|"
	@ li,005 PSAY "|"
	@ li,021 PSAY "|"
	@ li,021 + nk PSAY "*"
	nk := IIf( nk == 32 , 1 , nk + 1 )
	@ li,053 PSAY "|"
	@ li,056 PSAY "|"
	@ li,070 PSAY "|"
	@ li,085 PSAY "|"
	@ li,089 PSAY "|"
	@ li,106 PSAY "|"
	@ li,115 PSAY "|"
	@ li,125 PSAY "|"
	@ li,132 PSAY "|"
    li := li + 1
EndDo
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"
li := li + 1
@ li,001 PSAY "|"
@ li,015 PSAY "D E S C O N T O S -->"
@ li,037 PSAY C7_DESC1 Picture "999.99"
@ li,046 PSAY C7_DESC2 Picture "999.99"
@ li,055 PSAY C7_DESC3 Picture "999.99"
If nTotDesc == 0.00
	nTotDesc:= CalcDesc(nTotal,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
EndIf
@ li,068 PSAY nTotDesc Picture tm(nTotDesc,14)
@ li,132 PSAY "|"
li := li + 1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Acessar o Endereco para Entrega do Arquivo de Empresa SM0.   ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cAlias := Alias()
dbSelectArea("SM0")
dbSetOrder(1)   // forca o indice na ordem certa
nRegistro := Recno()
dbSeek(SUBS(cNumEmp,1,2)+SC7->C7_FILENT)
li := li + 1
@ li,001 PSAY "|"
@ li,003 PSAY "LOCAL DE ENTREGA : " + "RUA SOLON, 1062/1068 - BOM RETIRO - CEP 01127-010 - S.PAULO/SP - CGC 61497186/0003-92 - IE 114475595118"
@ li,132 PSAY "|"
dbGoTo(nRegistro)
dbSelectArea( cAlias )
li := li + 1
@ li,001 PSAY "|"
@ li,003 PSAY "FATURAM/COBRANCA : " + SM0->M0_ENDCOB
@ li,057 PSAY "-"
@ li,061 PSAY SM0->M0_CIDCOB
@ li,083 PSAY "-"
@ li,085 PSAY SM0->M0_ESTCOB
@ li,088 PSAY "-"
@ li,090 PSAY "CEP :"
@ li,096 PSAY Alltrim(SM0->M0_CEPCOB)
@ li,132 PSAY "|"
li := li + 1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"

dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial()+SC7->C7_COND)
dbSelectArea("SC7")
li := li + 1
@ li,001 PSAY "|"
@ li,003 PSAY "Condicao de Pagto "+SubStr(SE4->E4_COND,1,15)
@ li,038 PSAY "|Data de Emissao|"
@ li,056 PSAY "Total das Mercadorias : "
@ li,094 PSAY nTotal Picture tm(nTotNota,14)
@ li,132 PSAY "|"
li := li + 1
@ li,001 PSAY "|"
@ li,003 PSAY SubStr(SE4->E4_DESCRI,1,34)
@ li,038 PSAY "|"
@ li,043 PSAY SC7->C7_EMISSAO
@ li,054 PSAY "|"
@ li,132 PSAY "|"
li := li + 1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",52)
@ li,054 PSAY "|"
@ li,055 PSAY Replicate("-",77)
@ li,132 PSAY "|"
li := li + 1
dbSelectArea("SM4")
dbSetOrder(1)
dbSeek(xFilial()+SC7->C7_REAJUST)
dbSelectArea("SC7")
@ li,001 PSAY "|"
@ li,003 PSAY "Reajuste :"
@ li,014 PSAY SC7->C7_REAJUST Picture PesqPict("SC7","c7_reajust")
@ li,018 PSAY SM4->M4_DESCR
@ li,054 PSAY " | IPI   :"
@ li,094 PSAY nTotIpi         Picture tm(nTotIpi,14)
@ li,132 PSAY "|"
li := li + 1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",52)
@ li,054 PSAY "| Frete :"
@ li,094 PSAY SC7->C7_FRETE   Picture tm(SC7->C7_FRETE,14)
@ li,132 PSAY "|"





//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Inicializar campos de Observacoes.                           ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If Empty(cObs02)
	If Len(cObs01) > 50
		cObs := cObs01
		cObs01 := Substr(cObs,1,50)
        cObs02 := Substr(cObs,(50*(1))+1,50)
        cObs03 := Substr(cObs,(50*(2))+1,50)
        cObs04 := Substr(cObs,(50*(3))+1,50)
	EndIf
Else
	cObs01:= Substr(cObs01,1,IIf(Len(cObs01)<50,Len(cObs01),50))
	cObs02:= Substr(cObs02,1,IIf(Len(cObs02)<50,Len(cObs01),50))
	cObs03:= Substr(cObs03,1,IIf(Len(cObs03)<50,Len(cObs01),50))
	cObs04:= Substr(cObs04,1,IIf(Len(cObs04)<50,Len(cObs01),50))
EndIf

li := li + 1
@ li,001 PSAY "| Observacoes"
@ li,054 PSAY "| Grupo :"
@ li,132 PSAY "|"
li := li + 1
@ li,001 PSAY "|"
@ li,003 PSAY cObs01
@ li,054 PSAY "|"+Replicate("-",77)
@ li,132 PSAY "|"
li := li + 1
@ li,001 PSAY "|"
@ li,003 PSAY cObs02
@ li,054 PSAY "| Total Geral : "
If nTotDesc == 0.00
	nTotDesc:= CalcDesc(nTotNota,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
EndIf
nTotGeral:=nTotNota+nTotIpi-nTotDesc
@ li,094 PSAY nTotGeral      Picture tm(nTotGeral,14)
@ li,132 PSAY "|"
li := li + 1
@ li,001 PSAY "|"
@ li,003 PSAY cObs03
@ li,054 PSAY "|"+Replicate("-",77)
@ li,132 PSAY "|"
li := li + 1
@ li,001 PSAY "|"
@ li,003 PSAY cObs04
@ li,054 PSAY "|"
@ li,061 PSAY "|           Liberacao do Pedido"
@ li,102 PSAY "| Obs. do Frete: "
@ li,119 PSAY IF( SC7->C7_TPFRETE $ "F","FOB",IF(SC7->C7_TPFRETE $ "C","CIF"," " ))
@ li,132 PSAY "|"
li := li + 1
@ li,001 PSAY "|"+Replicate("-",59)
@ li,061 PSAY "|"
@ li,102 PSAY "|"
@ li,132 PSAY "|"
li := li + 1
cLiberador := ""
nPosicao := 0
If lLiberador
	If SubStr(SC7->C7_CODLIB,1,6) == EnCript(cMestra,0)
		cLiberador := "Administrador"
	Else
		cSenhaA  := SubStr(SC7->C7_CODLIB,1,6)
		For nx := 1 To Len(aSenhas)
			If aSenhas[nx][1] == cSenhaA
				nPosicao := nx
				Exit
			EndIf
		Next
		If nPosicao > 0
			cLiberador := EnCript(SubStr(aUsuarios[nPosicao][1],8,30),1)
		EndIf
	EndIf
EndIf
@ li,001 PSAY "|"
@ li,007 PSAY "Comprador"
@ li,021 PSAY "|"
@ li,028 PSAY "Gerencia"
@ li,041 PSAY "|"
@ li,046 PSAY "Diretoria"
//@ li,061 PSAY "|     ------------------------------"
@ li,102 PSAY "|"
@ li,132 PSAY "|"
li := li + 1
@ li,001 PSAY "|"
@ li,021 PSAY "|"
@ li,041 PSAY "|"

cRet := Space((30-Len(AllTrim(cLiberador)))/2)+AllTrim(cLiberador)

@ li,061 PSAY "|     " + cRet
@ li,102 PSAY "|"
@ li,132 PSAY "|"
li := li + 1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"
li := li + 1
@ li,001 PSAY "| NOTA1: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero do PEDIDO DE COMPRA."
@ li,132 PSAY "|"
li := li + 1
@ li,001 PSAY "| NOTA2: Horario de recebimento: Seg a Qui - 08h00 as 16h30 / Sex - 08h00 as 15h30. Almoco - 12h00 as 13h00"
@ li,132 PSAY "|"
li := li + 1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"

Return













// Substituido pelo assistente de conversao do AP6 IDE em 09/04/03 ==> Function FinalAE
Static Function FinalAE()
nk        := 1
nTotDesc  := SC7->C7_VLDESC
cMensagem := Formula(C7_MSG)
if !empty(cMensagem)
    li := li + 1
	@ li,001 PSAY "|"
	@ li,002 PSAY Padc(cMensagem,129)
	@ li,132 PSAY "|"
Endif
li := li + 1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"
li := li + 1
While li<39
	@ li,001 PSAY "|"
	@ li,005 PSAY "|"
	@ li,021 PSAY "|"
	@ li,021 + nk PSAY "*"
	nk := IIf( nk == 32 , 1 , nk + 1 )
	@ li,053 PSAY "|"
	@ li,056 PSAY "|"
	@ li,070 PSAY "|"
	@ li,085 PSAY "|"
	@ li,102 PSAY "|"
	@ li,111 PSAY "|"
	@ li,132 PSAY "|"
    li := li + 1
End
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Acessar o Endereco para Entrega do Arquivo de Empresa SM0.   ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cAlias := Alias()
dbSelectArea("SM0")
dbSetOrder(1)   // forca o indice na ordem certa
nRegistro := Recno()
dbSeek(SUBS(cNumEmp,1,2)+SC7->C7_FILENT)
li := li + 1
@ li,001 PSAY "|"
@ li,003 PSAY "Local de Entrega  : " + SM0->M0_ENDENT
@ li,057 PSAY "-"
@ li,061 PSAY SM0->M0_CIDENT
@ li,083 PSAY "-"
@ li,085 PSAY SM0->M0_ESTENT
@ li,088 PSAY "-"
@ li,090 PSAY "CEP :"
@ li,096 PSAY Alltrim(SM0->M0_CEPENT)
@ li,132 PSAY "|"
dbGoto(nRegistro)
dbSelectArea( cAlias )
li := li + 1
@ li,001 PSAY "|"
@ li,003 PSAY "Local Fat/Cobranc : " + SM0->M0_ENDCOB
@ li,057 PSAY "-"
@ li,061 PSAY SM0->M0_CIDCOB
@ li,083 PSAY "-"
@ li,085 PSAY SM0->M0_ESTCOB
@ li,088 PSAY "-"
@ li,090 PSAY "CEP :"
@ li,096 PSAY Alltrim(SM0->M0_CEPCOB)
@ li,132 PSAY "|"
li := li + 1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"

dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial()+SC7->C7_COND)
dbSelectArea("SC7")
li := li + 1
@ li,001 PSAY "|"
@ li,003 PSAY "Condicao de Pagto "+SubStr(SE4->E4_COND,1,15)
@ li,038 PSAY "|Data de Emissao|"
@ li,056 PSAY "Total das Mercadorias : "
@ li,094 PSAY nTotal Picture tm(nTotNota,14)
@ li,132 PSAY "|"
li := li + 1
@ li,001 PSAY "|"
@ li,003 PSAY SubStr(SE4->E4_DESCRI,1,34)
@ li,038 PSAY "|"
@ li,043 PSAY SC7->C7_EMISSAO
@ li,054 PSAY "|"
@ li,132 PSAY "|"
li := li + 1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",52)
@ li,054 PSAY "|"
@ li,055 PSAY Replicate("-",77)
@ li,132 PSAY "|"
li := li + 1
dbSelectArea("SM4")
dbSeek(xFilial()+SC7->C7_REAJUST)
dbSelectArea("SC7")
@ li,001 PSAY "|"
@ li,003 PSAY "Reajuste :"
@ li,014 PSAY SC7->C7_REAJUST Picture PesqPict("SC7","c7_reajust")
@ li,018 PSAY SM4->M4_DESCR
@ li,054 PSAY "| Total Geral : "
If nTotDesc == 0.00
	nTotDesc:= CalcDesc(nTotNota,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
EndIf
nTotGeral:=nTotNota+nTotIpi-nTotDesc

@ li,094 PSAY nTotGeral      Picture tm(nTotGeral,14)
@ li,132 PSAY "|"
li := li + 1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"






//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Inicializar campos de Observacoes.                           ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If Empty(cObs02)
	If Len(cObs01) > 50
		cObs 	:= cObs01
        cObs01  := Substr(cObs,1,50)
        cObs02  := Substr(cObs,(50*(1))+1,50)
        cObs03  := Substr(cObs,(50*(2))+1,50)
        cObs04  := Substr(cObs,(50*(3))+1,50)
	EndIf
Else
	cObs01:= Substr(cObs01,1,IIf(Len(cObs01)<50,Len(cObs01),50))
	cObs02:= Substr(cObs02,1,IIf(Len(cObs02)<50,Len(cObs01),50))
	cObs03:= Substr(cObs03,1,IIf(Len(cObs03)<50,Len(cObs01),50))
	cObs04:= Substr(cObs04,1,IIf(Len(cObs04)<50,Len(cObs01),50))
EndIf

li := li + 1
@ li,001 PSAY "| Observacoes"
@ li,054 PSAY "| Comprador    "
@ li,070 PSAY "| Gerencia     "
@ li,085 PSAY "| Diretoria    "
@ li,132 PSAY "|"

li := li + 1
@ li,001 PSAY "|"
@ li,003 PSAY cObs01
@ li,054 PSAY "|"
@ li,070 PSAY "|"
@ li,085 PSAY "|"
@ li,132 PSAY "|"

li := li + 1
@ li,001 PSAY "|"
@ li,003 PSAY cObs02
@ li,054 PSAY "|"
@ li,070 PSAY "|"
@ li,085 PSAY "|"
@ li,132 PSAY "|"

li := li + 1
@ li,001 PSAY "|"
@ li,003 PSAY cObs03
@ li,054 PSAY "|"
@ li,070 PSAY "|"
@ li,085 PSAY "|"
@ li,132 PSAY "|"

li := li + 1
@ li,001 PSAY "|"
@ li,003 PSAY cObs04
@ li,054 PSAY "|"
@ li,070 PSAY "|"
@ li,085 PSAY "|"
@ li,132 PSAY "|"
li := li + 1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"
li := li + 1
@ li,001 PSAY "| NOTA1: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero do PEDIDO DE COMPRA."
@ li,132 PSAY "|"
li := li + 1
@ li,001 PSAY "| NOTA2: Horario de recebimento: Seg a Qui - 08h00 as 16h30 / Sex - 08h00 as 15h30. Almoco - 12h00 as 13h00"
@ li,132 PSAY "|"
li := li + 1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"

Return















// Substituido pelo assistente de conversao do AP6 IDE em 09/04/03 ==> Function ImpRodape
Static Function ImpRodape()
li := li + 1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"
li := li + 1
@ li,001 PSAY "|"
@ li,070 PSAY "Continua ..."
@ li,132 PSAY "|"
li := li + 1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"
li:=0
Return














// Substituido pelo assistente de conversao do AP6 IDE em 09/04/03 ==> Function ImpCabec
Static Function ImpCabec()
@ 01,001 PSAY "|"
@ 01,002 PSAY Replicate("-",limite)
@ 01,132 PSAY "|"
@ 02,001 PSAY "|"
If mv_par08 == 1
	@ 02,045 PSAY "| P E D I D O  D E  C O M P R A S"
Else
	@ 02,045 PSAY "| A U T.   D E   E N T R E G A   "
EndIf
@ 02,079 PSAY IIf(nOrdem>1," - continuacao"," ")
@ 02,096 PSAY "|"
@ 02,101 PSAY SC7->C7_NUM      Picture PesqPict("SC7","c7_num")
@ 02,107 PSAY "/"+Str(nOrdem,1)
@ 02,112 PSAY IIf(SC7->C7_QTDREEM>0,Str(SC7->C7_QTDREEM+1,2)+"a.Emissao "+Str(ncw,2)+"a.VIA","")
@ 02,132 PSAY "|"
@ 03,001 PSAY "|"
@ 03,003 PSAY SM0->M0_NOMECOM
@ 03,045 PSAY "|"+Replicate("-",86)
@ 03,132 PSAY "|"
@ 04,001 PSAY "|"
@ 04,003 PSAY SM0->M0_ENDENT
dbSelectArea("SA2")
dbSetOrder(1)
dbSeek(xFilial()+SC7->C7_FORNECE+SC7->C7_LOJA)
@ 04,045 PSAY "|"
@ 04,047 PSAY Substr(SA2->A2_NOME,1,40)+"  -  "+SA2->A2_COD+" I.E.: "+SA2->A2_INSCR
@ 04,132 PSAY "|"
@ 05,001 PSAY "|"
@ 05,003 PSAY "CEP: "+Trans(SM0->M0_CEPENT,"@R 99999-999")+" - "+Trim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT
@ 05,045 PSAY "|"
@ 05,047 PSAY SA2->A2_END    		Picture PesqPict("SA2","A2_END")
@ 05,089 PSAY "-  "+Trim(SA2->A2_BAIRRO)	Picture "@!"
@ 05,132 PSAY "|"
@ 06,001 PSAY "|"
@ 06,003 PSAY "TEL: "+SM0->M0_TEL
@ 06,023 PSAY "FAX: "+SM0->M0_FAX
@ 06,045 PSAY "|"
@ 06,047 PSAY Trim(SA2->A2_MUN)  Picture "@!"
@ 06,069 PSAY SA2->A2_EST    		Picture PesqPict("SA2","A2_EST")
@ 06,074 PSAY "CEP: "
@ 06,081 PSAY SA2->A2_CEP    		Picture PesqPict("SA2","A2_CEP")
@ 06,093 PSAY "CGC: "
@ 06,098 PSAY SA2->A2_CGC    		Picture PesqPict("SA2","A2_CGC")
@ 06,132 PSAY "|"
@ 07,001 PSAY "|"
@ 07,003 PSAY "CGC: "+ Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")
@ 07,027 PSAY "IE:"+ InscrEst()
@ 07,045 PSAY "|"
@ 07,047 PSAY SC7->C7_CONTATO Picture PesqPict("SC7","C7_CONTATO")
@ 07,069 PSAY "FONE: "
@ 07,075 PSAY SA2->A2_TEL     Picture PesqPict("SA2","A2_TEL")
@ 07,095 PSAY "FAX: "
@ 07,100 PSAY SA2->A2_FAX     Picture PesqPict("SA2","A2_FAX")
@ 07,132 PSAY "|"
@ 08,001 PSAY "|"
@ 08,002 PSAY Replicate("-",limite)
@ 08,132 PSAY "|"

If mv_par08 == 1
	@ 09,001 PSAY "|"
	@ 09,002 PSAY "Itm|"
	@ 09,009 PSAY "Codigo      "
	@ 09,021 PSAY "|Descricao do Material"
	@ 09,053 PSAY "|UM|  Quant."
	@ 09,070 PSAY " |Valor Unitario|IPI|  Valor Total   |Entrega |  C.C.   | S.C. |"
	@ 10,001 PSAY "|"
	@ 10,002 PSAY Replicate("-",limite)
	@ 10,132 PSAY "|"
Else
	@ 09,001 PSAY "|"
	@ 09,002 PSAY "Itm|"
	@ 09,009 PSAY "Codigo      "
	@ 09,021 PSAY "|Descricao do Material"
	@ 09,053 PSAY "|UM|  Quant."
	@ 09,070 PSAY "|Valor Unitario|  Valor Total   |Entrega | Numero da OP  "
	@ 09,132 PSAY "|"
	@ 10,001 PSAY "|"
	@ 10,002 PSAY Replicate("-",limite)
	@ 10,132 PSAY "|"
EndIf
dbSelectArea("SC7")
li := 10
Return
