//#Include "CTBA995.CH"
#Include "PROTHEUS.CH"


// 17/08/2009 -- Filial com mais de 2 caracteres

STATIC nTamCta	:= Len(CriaVar("CT1_CONTA"))
STATIC nTamCC	:= Len(CriaVar("CTT_CUSTO"))
STATIC nTamItem	:= Len(CriaVar("CTD_ITEM"))
STATIC nTamClVl	:= Len(CriavAr("CTH_CLVL"))

STATIC cArqTrb	:= ""
STATIC cArqIND1	:= ""
STATIC cArqIND2	:= ""

STATIC nMAX_LINHA := CtbLinMax(GetMv("MV_NUMLIN"))

// TRADU??O RELEASE P10 1.2 - 21/07/08
/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?CTBA995   ?Autor  ?Marcos S. Lobo      ? Data ?  05/24/05   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Rotina de Limpeza Anual - SIGACTB                           ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP                                                         ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
USER FUNCTION RCTBA99()

Local aSays 		:= {}
Local aButtons		:= {}
LOCAL nOpca    		:= 0
Local cMens			:= ""
Local oProcess

Local aStruCT2		:= {}
Local aStruCV6		:= {}

Private cCadastro 	:= OemToAnsi("Limpeza Anual de Base de Dados - SIGACTB")
PRIVATE cString   	:= "CT2"
PRIVATE cDesc1    	:= OemToAnsi("Esta rotina faz a limpeza da tabela de lan?amentos contabeis gerando lote")
PRIVATE cDesc2    	:= OemToAnsi("de documentos como saldo inicial do exerc?cio seguinte. ? fortemente RECOMENDADO")
PRIVATE cDesc3    	:= OemToAnsi("O BACKUP DA TABELA DE LANCAMENTOS antes de executar esta rotina.")
PRIVATE titulo    	:= OemToAnsi("XxxXxxX")  
PRIVATE cCancel   	:= OemToAnsi("***** CANCELADO PELO OPERADOR *****")
PRIVATE nomeprog  	:= "CTBA995"
PRIVATE aLinha    	:= { }
PRIVATE nLastKey 	:= 0

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf         

If !ChkFile("CV6")
	MsgAlert("Deve ser criada a tabela CV6 antes da execu??o desta rotina")
	//Return
EndIf

dbSelectArea("CT2")
aStruCT2 := dbStruct()
dbSelectArea("CV6")
aStruCV6 := dbStruct()

If Len(aStruCT2)+1 <> Len(aStruCV6)
	ALERT(Len(aStruCT2))
	ALERT(Len(aStruCV6))
	
	MsgAlert("Estrutura das tabelas CT2 e CV6 n?o est?o coerentes")
	//Return
EndIf

//??????????????????????????????????????????????????????????????Ŀ
//? Variaveis utilizadas para parametros                         ?
//? mv_par01 // Exerc?cio p/ Limpeza							 ?
//? mv_par02 // Numero do Lote			                         ?
//? mv_par03 // Numero do SubLote		                         ?
//? mv_par04 // Numero do Documento                              ?
//? mv_par05 // Cod. Historico Padrao                            ?
//? mv_par06 // Limpa Contra-Prova ?                             ?
//????????????????????????????????????????????????????????????????

Pergunte("CTB995",.f.)

cMens := OemToAnsi("Certifique-se de que o per?odo est? com os saldos atualizados,")+chr(13)  //"Certifique-se de que o per?odo est? com os saldos atualizados,"
cMens += OemToAnsi("e com o(s) calend?rio(s) Encerrado(s) (com status 'Fechado').")+chr(13)  //"e com o(s) calend?rio(s) Encerrado(s) (com status 'Fechado')."
cMens += OemToAnsi("Todas moedas e tipos de saldos ser?o transportados ! Continua ?")			 //"Todas moedas e tipos de saldos ser?o transportados ! Continua ?"

AADD(aSays,OemToAnsi( cDesc1 ) )	//"Esta rotina faz a limpeza da tabela de lan?amentos contabeis"
AADD(aSays,OemToAnsi( cDesc2 ) )	//"gerando lote de documentos como saldo inicial do exerc?cio "
AADD(aSays,OemToAnsi( cDesc3 ) )	//"seguinte."

AADD(aButtons, { 5,.T.,{|| Pergunte("CTB995",.T. ) } } )
AADD(aButtons, { 1,.T.,{|| nOpca:= 1, If(MsgYesNo(cMens,OemToAnsi("STR0009")), FechaBatch(), nOpca:=0 ) }} )
AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )
	                                    
If nOpca == 1
	oProcess := MsNewProcess():New({|lEnd| CTB995Proc(oProcess)},"STR0001","",.F.)
	oProcess:Activate()		
Endif
	
CT2->(DBCloseArea())
CT6->(DBCloseArea()) 
CT1->(DBCloseArea())
CT3->(DBCloseArea())
CT4->(DBCloseArea())
CT5->(DBCloseArea())
CT8->(DBCloseArea())
CTF->(DBCloseArea())
CTD->(DBCloseArea())
CTE->(DBCloseArea())
CTC->(DBCloseArea())
CTI->(DBCloseArea())
CT7->(DBCloseArea())
Return
	
/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????Ŀ??
???Fun??o    ?CTB995Proc? Autor ? Marcos S. Lobo        ? Data ? 05/24/05 ???
?????????????????????????????????????????????????????????????????????????Ĵ??
???Descri??o ?Processameto da Limpeza Anual SIGACTB                       ???
?????????????????????????????????????????????????????????????????????????Ĵ??
???Sintaxe   ? CTB995Proc()                                               ???
?????????????????????????????????????????????????????????????????????????Ĵ??
??? Uso      ? CTBA995                                                    ???
??????????????????????????????????????????????????????????????????????????ٱ?
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/
STATIC FUNCTION CTB995Proc(oObj)

Local lClVl		:=	CtbMovSaldo("CTH")
Local lItem		:=	CtbMovSaldo("CTD")
Local lCusto	:= 	CtbMovSaldo("CTT")

Local lObj		:= ValType(oObj) == "O"
Local nTotal 	:= 5

Local nSeqLin	:= 0
Local nIndTmp	:= 0

Local cExerc	:= STR(mv_par01,4)
Local cLote		:= mv_par02
Local cSubLote 	:= If(Empty(GetMV("MV_SUBLOTE")), mv_par03, GetMV("MV_SUBLOTE"))// Sub-Lote somente eh informado se estiver em branco
Local cDoc		:= mv_par04
Local cHP		:= mv_par05
Local cDescHP	:= ""

Local lDelCTK	:= If(mv_par06 == 1,.T.,.F.)
Local lExecPack	:= If(mv_par07 == 1,.T.,.F.)
Local lFazBack	:= If(mv_par08 == 1,.T.,.F.)
Local aTabsCtb := {"CT2","CTK","CT3","CT4","CT7","CTI","CT6","CTC"}

Local lPergOk	:= .T.

Local cFilCTG	:= ""
Local lCTGAbe	:= .F.
Local cCalAbe	:= ""
Local nRegCTG	:= 0

Local nMoed		:= 1
Local cMoed		:= "01"

Local aCTOxCTE 	:= {}
Local nCalend	:= 1
Local aTpSaldos	:= {}
Local nTpSld	:= 1

Local nCpo
Local lJaProc 	:= .F.			/// SE A ROTINA J? COMECOU A TRANSFERIR REGISTROS P/ CV6 OU N?O
Local lCriaTRB	:= .T.			/// SE DEVE OU NAO CRIAR UM TRB NOVO
Local lNovoTRB	:= .T.			/// SE FOI CRIA

Local lGravaCV6	:= .T.

Local lOutMoed	:= __nQuantas > 1
Local dMaiorDT	:= CTOD("  /  /  ")
Local dMenorDT	:= CTOD("  /  /  ")
Local lOutDTMen := .F.

Local nNxtCT2Reg
Local dMenorCT2	:= CTOD("01/01/80")

Local cTpSldAnt	:= ""
Local cMoedAnt	:= ""
Local CTF_LOCK	:= 0
Local lFirst	:= .T.
Local nLinha	:= 0
Local cLinha	:= "001"
Local cSeqLan	:= "001"

Local nForaCols	:= 0
PRIVATE aCols 		:= {} // Utilizada na conversao das moedas
Private cSeqCorr  := ""

If cPaisLoc == 'CHI' .and. Val(cLinha) < 2  // a partir da segunda linha do lanc., o correlativo eh o mesmo
	cSeqCorr := CTBSqCor( CTBSubToPad(cSubLote) )
EndIf

If lExecPack
	aTabsCtb := {"CT2"				,"CTK",					"CT3",					"CT4",						"CT7",				"CTI",				"CT6",						"CTC"}
	If !(MA280FLock("CT2") .And. MA280FLock("CTK") .And. MA280FLock("CT3") .And. MA280FLock("CT4") .And. MA280FLock("CT7")  .And. MA280FLock("CTI") .And. MA280FLock("CT6") .And. MA280FLock("CTC") )
		MsgAlert("Para eliminar registros deletados ? necess?rio acesso exclusivo ! Execute a limpeza sem eliminar "+"STR0043","STR0044") ///"Para eliminar registros deletados ? necess?rio acesso exclusivo ! Execute a limpeza sem eliminar "#"registros exclu?dos ou tente acesso exclusivo."#"Concorr?ncia de usu?rios..."
		lPergOk := .F.		
	EndIf
EndIf

If lObj
	If lDelCtk    
		nTotal++  
	EndIf
	If lExecPack
		nTotal++
	EndIf
	oObj:SetRegua1(nTotal)			 				
EndIf 

If lObj
	oObj:IncRegua1(OemToAnsi("STR0045"))
EndIf

/// ANTES DE INICIAR O PROCESSAMENTO, VERIFICO OS PARAMETROS.
If Empty(cExerc) .or. ALLTRIM(cExerc) == "0"
	Help(,,"CT995EXE",,"Exerc?cio inv?lido/n?o preenchido.",1,1)		///"Exerc?cio inv?lido/n?o preenchido."
	lPergOk := .F.
ElseIf cExerc >= STR(Year(dDataBase),4)
	/// N?o deve ser efetuada limpeza do exerc?cio corrente / exerc?cio futuro.
	Help(,,"CT995EXF",,"N?o permitido p/ exerc. futuro/corrente.",1,1)		///"N?o permitido p/ exerc. futuro/corrente."
	lPergOk := .F.
EndIf

//Lote nao preenchido.
If Empty(cLote)
	Help(" ",1,"NOCT995LOT",,"STR0048",1,1)	///"Lote n?o preenchido."
	lPergOk := .F.
Endif
	
//Sub Lote nao preenchido.
If Empty(cSubLote)
	Help(" ",1,"NOCTSUBLOT",,"STR0049",1,1)
	lPergOk := .F.
Endif
	
//Documento nao preenchido.
If Empty(cDoc)
	Help(" ",1,"NOCT995DOC",,"STR0050",1,1)
	lPergOk := .F.
EndIf

//Historico Padrao nao preenchido.
If Empty(cHP)	
	Help(" ",1,"CTHPVAZIO")
	lPergOk := .F.
Else
	dbSelectArea("CT8")
	dbSetOrder(1)
	If MsSeek(xFilial("CT8")+cHP)
		If CT8->CT8_IDENT == "I"
			Help(" ",1,"CT8HISINT",,"STR0051",1,1)
			lPergOk := .F.
		Else		
			cDescHP 	:= CT8->CT8_DESC
		EndIf
	Else            
		//Historico Padrao nao existe no cadastro.
		Help(" ",1,"Ct995NOHP",,"STR0052",1,1)
		lPergOk := .F.
	Endif
Endif                             

/// Caso haja alguma inconsist?ncia nos par?metros aborta processo.
If !lPergOk
	Return
EndIf

///////////////////////////////////////////////////////////////////////////////////////////////////////
/// OBTEM AS DATAS FINAIS DOS CALENDARIOS QUE SOFRERAO A LIMPEZA E MUDAN?A DE STATUS
///////////////////////////////////////////////////////////////////////////////////////////////////////
dbSelectArea("CTG")
dbSetOrder(1)
cFilCTG := xFilial("CTG")
dbSelectArea("CTE")
dbSetOrder(1)
cFilCTE := xFilial("CTE")

For nMoed := 1 to __nQuantas

	cMoed := STRZERO(nMoed,2)

	CTE->(dbSeek(cFilCTE+cMoed,.T.))
	While CTE->(!Eof()) .and. CTE->CTE_FILIAL == cFilCTE .and. CTE->CTE_MOEDA == cMoed
		dbSelectArea("CTG")
		dbSetOrder(1)
		If dbSeek(cFilCTG+CTE->CTE_CALEND+cExerc,.F.)			/// VERIFICA SE O CALENDARIO PERTENCE AO EXERCICIO DA LIMPEZA

			CTG->(dbSeek(cFilCTG+Soma1(CTE->CTE_CALEND),.T.))		
			CTG->(dbSkip(-1))								/// LOCALIZA O ULTIMO PERIODO DO CALENDARIO CORRENTE
			If CTG->CTG_FILIAL == cFilCTG .and. CTG->CTG_CALEND == CTE->CTE_CALEND .and. CTG->CTG_STATUS == "2" 
				If Ascan(aCTOxCTE,{|x| x[1] == cMoed } ) <= 0
					aAdd(aCTOxCTE,{cMoed,CTG->CTG_CALEND,CTG->CTG_DTFIM})
				EndIf
			EndIf

			Exit
		Else
			CTE->(dbSkip())
		EndIf
	EndDo
Next

If Len(aCTOxCTE) <> __nQuantas
	/// SE HOUVEREM CALENDARIOS EM ABERTO NAO PERMITE O PROCESSAMENTO.
	MsgInfo("Verique se as moedas e calendarios estao amarrados e encerrados","Moedas x Calend?rios Encerrados") ///"Verique se as moedas e calendarios estao amarrados e encerrados"#"Moedas x Calend?rios Encerrados"
	Return
EndIf

////////////////////////////////////////////////////////////////////////////////////////////////////
//// DETERMINA OS TIPOS DE SALDO QUE FORAM UTILIZADOS
////////////////////////////////////////////////////////////////////////////////////////////////////
dbSelectArea("CT6")
For nTpSld := 1 To 9
	SET FILTER TO &("CT6_FILIAL = '"+xFilial("CT6")+"' .and. CT6_TPSALD = '"+STRZERO(nTpSld,1)+"'")
	If dbSeek(xFilial("CT6"),.F.)
		aAdd(aTpSaldos,STRZERO(nTpSld,1))
	EndIf
Next
dbClearFilter()

dbSelectArea("CV6")
dbSetOrder(1)
If dbSeek(xFilial("CV6")+cExerc,.F.)
	lJaProc := .T.
	nRetMsg := Aviso("A T E N C ? O !!!","Exercicio ja teve a limpeza iniciada ! Processamento...", { "Novo","Continuar","Sair" } )/// "A T E N C ? O !!!"#"Exercicio ja teve a limpeza iniciada ! Processamento..."#"Novo"#"Continuar" #"Sair"
	If nRetMsg == 1
		lCriaTRB := .T.
	ElseIf nRetMsg == 2
		lCriaTRB := .F.
	Else
		Return 
	EndIf
EndIf

cArqTRB := cEmpAnt+cFilAnt+cExerc
/// CRIACAO DE ARQUIVO TEMPORARIO.
If !Ct995CrTrb(cEmpAnt+cFilAnt+cExerc,lJaProc,lCriaTRB,@lNovoTRB)
	Return
EndIf

If lObj
	oObj:IncRegua1(OemToAnsi("Obtendo Saldos - Montando Arquivo de Trabalho (Saldos Finais)..."))///"Obtendo Saldos - Montando Arquivo de Trabalho (Saldos Finais)..."
EndIf

/// VERIFICO OS SALDOS DA CLASSE DE VALOR (CTI) GRAVANDO NO TRB.
If lNovoTRB
	If lClvl
		CTB995GTRB('CTI',aCTOxCTE,aTpSaldos,oObj,lCusto,lItem,lClvl)
	EndIf
	/// VERIFICO OS SALDOS DO ITEM CONTABIL (CT4) GRAVANDO NO TRB.
	If lItem
		CTB995GTRB('CT4',aCTOxCTE,aTpSaldos,oObj,lCusto,lItem,lClvl)
	EndIf
	/// VERIFICO OS SALDOS DO CENTRO DE CUSTO(CT3) GRAVANDO NO TRB.
	If lCusto
		CTB995GTRB('CT3',aCTOxCTE,aTpSaldos,oObj,lCusto,lItem,lClvl)
	EndIf
	/// VERIFICO OS SALDOS DA CONTA.(CT7) GRAVANDO NO TRB.
	CTB995GTRB('CT7',aCTOxCTE,aTpSaldos,oObj,lCusto,lItem,lClvl)
EndIf

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// EFETUA A COPIA DO CT2 PARA O CV6 E APAGA REGISTROS NO CT2 DE ORIGEM
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
If lObj
	oObj:IncRegua1(OemToAnsi("Movendo registros de lan?amentos..."))///"Movendo registros de lan?amentos..."
EndIf

ALERT(LEN(aCTOxCTE))
dMenorDT := aCTOxCTE[1][3]
dMaiorDT := aCTOxCTE[1][3]
lOutDTMen := .F.
For nMoed := 2 to Len(aCTOxCTE)
	If aCTOxCTE[nMoed][3] > dMaiorDT
		dMaiorDT := aCTOxCTE[nMoed][3]				/// DETERMINA A MAIOR DATA FINAL ENTE OS CALEND?RIOS
	EndIf
	If aCTOxCTE[nMoed][3] < aCTOxCTE[1][3]
		lOutDTMen := .T.							/// DATA FINAL DE OUTRA MOEDA MENOR QUE A MOEDA 1
		If aCTOxCTE[nMoed][3] < dMenorDT
			dMenorDT := aCTOxCTE[nMoed][3]			/// DETERMINA A MENOR DATA FINAL ENTRE OS CALEND?RIOS
		EndIf
	EndIf
Next

dbSelectArea("CV6")
dbSetOrder(1)
cFilCV6 := xFilial("CV6")

dbSelectArea("CT2")
dbSetOrder(1)
cFilCT2		:= xFilial("CT2")
aStruCT2	:= dbStruct()
dbSeek(cFilCT2,.T.)
dMenorCT2 	:= CT2->CT2_DATA

If lObj
	oObj:SetRegua2(CT2->(RecCount()))			 				
EndIf 

While CT2->(!Eof()) .and. CT2->CT2_FILIAL == cFilCT2 .and. CT2->CT2_DATA <= dMaiorDT
	
	nNxtCT2Reg := 0
	
	If lObj
		oObj:IncRegua2(OemToAnsi("Movendo lan?amentos..."+DTOC(CT2->CT2_DATA)))///"Movendo lan?amentos..."
	EndIf

	If lJaProc	//// NO CASO DE CONTINUAR O PROCESSAMENTO
		/// SE FOR O LOTE J? GERADO PELA LIMPEZA PASSA PARA OS PR?XIMOS REGISTROS
		If CT2->CT2_LOTE == cLote .AND. (CT2->CT2_DATA == aCTOxCTE[val(CT2->CT2_MOEDLC)][3] .OR. CT2->CT2_VALOR == 0  ) 
			CT2->(dbSkip())
			Loop
		EndIf
	EndIf

	If lFazBack
		lGravaCV6 := .T.
		    
		// SE J? GRAVOU O REGISTRO NO BACKUP PASSA PARA O PR?XIMO.
		If lJaProc .and. CV6->(dbSeek(cFilCV6+cExerc+CT2->(DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_TPSALD+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC),.F.))
			lGravaCV6 := .F.
		EndIf
	EndIf
		
	BEGIN TRANSACTION		
	
	If lFazBack	
		If lGravaCV6
			RecLock("CV6",.T.)
			Field->CV6_FILIAL	:= cFilCV6
			Field->CV6_EXERC	:= cExerc
			For nCpo := 1 to Len(aStruCT2)
				If aStruCT2[nCpo][1] <> "CT2_FILIAL"
					&("Field->CV6_"+SubStr(aStruCT2[nCpo][1],5,8)) := &("CT2->"+aStruCT2[nCpo][1])
				EndIf
			Next
			CV6->(MsUnlock())		
		EndIf
	EndIf
	
	If CT2->CT2_DATA <= aCTOxCTE[val(CT2->CT2_MOEDLC)][3]
		
		dbSelectArea("CT2")
		If lOutMoed .and. CT2->CT2_MOEDLC == "01"			/// SE HOUVER OUTRAS MOEDAS E FOR LANCAMENTO NA MOEDA 01
			If lOutDTMen .and. CT2->CT2_DATA > dMenorDT 	/// DT.FIM OUTRA MENOR QUE MOEDA 01 E A DATA ATUAL MAIOR QUE A MENOR DATA EM OUTRA MOEDA
				If CT2->CT2_VALOR <> 0
					RecLock("CT2",.F.)
					CT2->CT2_VALOR := 0							/// DEVE MANTER O REGISTRO DA MOEDA 01 COM VALOR ZERADO.
					CT2->(MsUnlock())
				EndIf
			Else
				CT2->(dbSkip())
				nNxtCT2Reg := CT2->(Recno())
				CT2->(dbSkip(-1))

				RecLock("CT2",.F.)
				dbDelete()									/// APAGA O REGISTRO TRANSPORTADO.
				CT2->(MsUnlock())
			EndIf
		Else												/// SE N?O HOUVER OUTRAS MOEDAS OU FOR REG. DE OUTRA MOEDA
			CT2->(dbSkip())
			nNxtCT2Reg := CT2->(Recno())
			CT2->(dbSkip(-1))

			RecLock("CT2",.F.)
			dbDelete()										/// APAGA O REGISTRO TRANSPORTADO.
			CT2->(MsUnlock())
		EndIf
	EndIf	

	END TRANSACTION

	If nNxtCT2Reg <> 0
		CT2->(dbGoTo(nNxtCT2Reg))
	Else	
		CT2->(dbSkip())
	EndIf
EndDo

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// LE ARQUIVO DE TRABALHO COM OS SALDOS E REGRAVA NO CT2 ATUAL COM OS SALDOS FINAIS
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
If lObj
	oObj:IncRegua1(OemToAnsi("Gravando Lote de Saldos Finais..."))	///"Gravando Lote de Saldos Finais..."
EndIf

dbSelectArea("TRB")
dbSetOrder(1)
dbGoTop()

If lObj
	oObj:SetRegua2(TRB->(RecCount()))			 				
EndIf 

While TRB->(!Eof())

	If lObj
		oObj:IncRegua2(OemToAnsi("Gravando saldos finais exerc?cio... Moeda "+TRB->MOEDA+" Saldo "+TRB->TPSALDO))///"Gravando saldos finais exerc?cio... Moeda "#" Saldo "
	EndIf

	If lJaProc
		If TRB->JAPROC == "S"
			TRB->(dbSkip())
			Loop			
		EndIf
	EndIf
    
   	nSaldo := TRB->SALDOC - TRB->SALDOD
	
	If nSaldo == 0
		TRB->(dbSkip())
		Loop
	EndIf
    	
	If lFirst .or. nLinha > nMAX_LINHA .or. TRB->TPSALDO <> cTpSldAnt .or. TRB->MOEDA <> cMoedAnt
		cMoedAnt	:= TRB->MOEDA
		cTpSldAnt	:= TRB->TPSALDO
	
		Do While !ProxDoc(aCTOxCTE[VAL(TRB->MOEDA)][3],cLote,cSubLote,@cDoc,@CTF_LOCK)
			//??????????????????????????????????????????????????????Ŀ
			//? Caso o N? do Doc estourou, incrementa o lote         ?
			//????????????????????????????????????????????????????????
			cLote := Soma1(cLote)
			DbSelectArea("SX5")
			If MsSeek(xFilial("SX5")+"09CTB",.F.)
				RecLock("SX5")
				SX5->X5_DESCRI := Substr(cLote,3,4)
				MsUnlock()
			EndIf
		Enddo
		lFirst := .F.
		cLinha := "001"
		nLinha := 0
		cSeqLan:= "001"
	Else
		cSeqLan	:= Soma1(cSeqLan)
	EndIf

	If nSaldo > 0	
		cTipo		:= "2"		/// LANCAMENTO A CREDITO
		cDebito		:= ""
		cCustoDeb	:= ""
		cItemDeb	:= ""
		cClVlDeb	:= ""

		cCredito	:= TRB->CONTA
		cCustoCrd	:= TRB->CUSTO
		cItemCrd	:= TRB->ITEM
		cClVlCrd	:= TRB->CLVL			
	Else
		cTipo := "1"		/// LANCAMENTO A CREDITO
		cDebito		:= TRB->CONTA
		cCustoDeb	:= TRB->CUSTO
		cItemDeb	:= TRB->ITEM	
		cClVlDeb	:= TRB->CLVL
		
		cCredito	:= ""
		cCustoCrd	:= ""
		cItemCrd	:= ""
		cClVlCrd	:= ""
	EndIf 

	BEGIN TRANSACTION
	//Grava lancamento na moeda 01
	nSaldo 		:= ABS(nSaldo)	
	nMoedAtu	:= VAL(TRB->MOEDA)

	If TRB->MOEDA == "01"
		aCols := { { "01", " ", nSaldo, "2", .F., nSaldo } }
		GravaLanc(aCTOxCTE[nMoedAtu][3],cLote,cSubLote,cDoc,@cLinha,cTipo,'01',cHP,cDebito,cCredito,;
			  cCustoDeb,cCustoCrd,cItemDeb,cItemCrd,cClVlDeb,cClVlCrd,nSaldo,cDescHP,;
			  TRB->TPSALDO,@cSeqLan,3,.F.,aCols,cEmpAnt,cFilAnt,,,,,,,.F.)
	Else	/// Grava Lancamento na moeda 02 com valor zerado na moeda 01
		aCols := { { "01", " ", 0.00, "2", .F., 0 },{ TRB->MOEDA, "4", nSaldo, "2", .F., nSaldo } }
		If val(TRB->MOEDA) > 2
			nForaCols	:= VAL(TRB->MOEDA)-2
		Else                
			nForaCols	:= 0
		EndIf
		
		GravaLanc(aCTOxCTE[nMoedAtu][3],cLote,cSubLote,cDoc,cLinha,cTipo,'01',cHP,cDebito,cCredito,;
			  cCustoDeb,cCustoCrd,cItemDeb,cItemCrd,cClVlDeb,cClVlCrd,0,cDescHP,;
			  TRB->TPSALDO,cSeqLan,3,.F.,aCols,cEmpAnt,cFilAnt,0,,,,,,.F.)
			  
		GravaLanc(aCTOxCTE[nMoedAtu][3],cLote,cSubLote,cDoc,@cLinha,cTipo,TRB->MOEDA,cHP,cDebito,cCredito,;
			  cCustoDeb,cCustoCrd,cItemDeb,cItemCrd,cClVlDeb,cClVlCrd,0,cDescHP,;
			  TRB->TPSALDO,cSeqLan,3,.F.,aCols,cEmpAnt,cFilAnt,nForaCols,,,,,,.F.)						  				
	EndIf
	 
	RecLock("TRB",.F.)
	Field->JAPROC := "S"
	TRB->(MsUnlock())
	
	END TRANSACTION

	nLinha := Val(cLinha)

	TRB->(dbSkip())
EndDo

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Efetua reprocessamento de saldos do per?odo (transportando saldos para os lan?amentos de saldos finais)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
If lObj
	oObj:IncRegua1(OemToAnsi("Reprocessando Saldos..."))///"Reprocessando Saldos..."
	oObj:SetRegua2(0)			 				
	oObj:IncRegua2("")
EndIf 

For nTPSLD := 1 to Len(aTpSaldos)
	CTBA190(.T.,dMenorCT2,dMaiorDT,cFilAnt,cFilAnt,STR(nTPSLD,1),.F.,"")
Next

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// MUDA STATUS DOS CALEND?RIOS PARA 3=TRANSPORTADO
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
dbSelectArea("CTG")
dbSetOrder(1)
dbSeek(cFilCTG,.T.)
While CTG->(!Eof()) .and. CTG->CTG_FILIAL == cFilCTG
	If CTG->CTG_STATUS <> "3" .and. CTG_EXERC <= cExerc
		RecLock("CTG",.F.)
		CTG->CTG_STATUS := "3"
		CTG->(MsUnlock())
	EndIf
	dbSkip()
EndDo

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// LIMPA O ARQUIVO DE CONTRA-PROVA
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
If lDelCTK
	If lObj
		oObj:IncRegua1(OemToAnsi("Eliminando registros Contra-Prova..."))///"Eliminando registros Contra-Prova..."
	EndIf

	dbSelectArea("CTK")
	dbSetOrder(3)
	cFilCTK := xFilial("CTK")
	dbSeek(cFilCTK,.T.)

	If lObj
		oObj:SetRegua2(CTK->(RecCount()))			 				
	EndIf 
	
	While CTK->(!Eof()) .and. CTK->CTK_FILIAL == cFilCTK .and. CTK->CTK_DATA <= dMaiorDT
		If lObj
			oObj:IncRegua2(OemToAnsi("Eliminando registros Contra-Prova..."+DTOC(CTK->CTK_DATA)))///"Apagando Contra-Prova..."
		EndIf

		RecLock("CTK",.F.)
		dbDelete()
		CTK->(MsUnlock())
		CTK->(dbSkip())
	EndDo
	
EndIf

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// APAGA OS REGISTROS DELETADOS FISICAMENTE (SE SELECIONADO PELO USU?RIO
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
If lExecPack
	If !MsgYesNo("STR0101","STR0102")	//"Limpeza de Lan?amentos conclu?da. Apaga definitivamente registros marcados para dele??o ?"#"Necessario acesso exclusivo."
		Return
	EndIf
		
	If lObj
		oObj:IncRegua1(OemToAnsi("STR0069"))
	EndIf
	
	If lObj
		oObj:SetRegua2(Len(aTabsCtb))
	EndIf
	
	For nTPSLD := 1 to Len(aTabsCTB)
		If lObj
			oObj:IncRegua2(OemToAnsi("STR0069"+aTabsCTB[nTPSLD]))
		EndIf
		dbSelectArea(aTabsCTB[nTPSLD])
		dbCloseArea() 

		#IFDEF TOP		
			dbUseArea(.T.,"TOPCONN",RetSqlName(aTabsCTB[nTPSLD]),aTabsCTB[nTPSLD],.F.,.F.)
		#ENDIF 
				
		dbSelectArea(aTabsCTB[nTPSLD])   
		
		#IFNDEF TOP	
			ABREEXCL(aTabsCTB[nTPSLD])		
		#ENDIF
		
		PACK
        
	Next
EndIf
   
///	APAGA O ARQUIVO DE TRABALHO
dbSelectArea("TRB")
dbCloseArea()
If MsgYesNo("Apaga o arquivo "+cArqTRB+GetDbExtension()+"STR0071","STR0072")///"Apaga o arquivo "
	FErase(cArqIND1+OrdBagExt())
	FErase(cArqIND2+OrdBagExt())
	FErase(cArqTrb+GetDbExtension())
EndIf

Return

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????Ŀ??
???Fun??o    ?Ct995CrTrb? Autor ? Marcos S. Lobo        ? Data ? 04.02.02 ???
?????????????????????????????????????????????????????????????????????????Ĵ??
???Descri??o ?Cria arquivo de trabalho									  ???
?????????????????????????????????????????????????????????????????????????Ĵ??
???Sintaxe   ?Ct995CrTrb()                                                ???
?????????????????????????????????????????????????????????????????????????Ĵ??
??? Uso      ?Ct995CrTrb()                                                ???
??????????????????????????????????????????????????????????????????????????ٱ?
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/
STATIC Function Ct995CrTrb(cNomeArq,lJaProc,lCriaTRB,lNovoTRB)

Local cTrb		:= ""
Local aCampos	:=  {}
Local aTamVlr	:= {}

Local cTitMsg := ""
Local cMsg	  := ""

aTamVlr := TamSX3("CT7_DEBITO")

aCampos := {{"IDENT"	,"C",3			,0},;
 		    {"CONTA" 	,"C",nTamCta	,0},;
 		    {"CUSTO" 	,"C",nTamCC		,0},;
 			{"ITEM"  	,"C",nTamItem	,0},;
 			{"CLVL" 	,"C",nTamClvl	,0},;
   			{"SALDOD"	,"N",aTamVlr[1]+2,aTamVlr[2]},;
   			{"SALDOC"	,"N",aTamVlr[1]+2,aTamVlr[2]},;
   			{"TPSALDO"	,"C",1			,0},;
			{"MOEDA"	,"C",2			,0},;
			{"JAPROC"	,"C",1			,0}}					 					 

If Empty(cArqTRB)
	cArqTRB := cNomeArq
EndIf
				
If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
Endif

cArqIND1 := Left(cArqTRB,5)+Right(cArqTRB,2)+"A"
cArqIND2 := Left(cArqTRB,5)+Right(cArqTRB,2)+"B"

If lCriaTRB
	If File(cArqTrb+GetDbExtension())		/// SE ENCONTROU O ARQUIVO DE SALDOS FINAIS 
		cTitMsg := "Arquivo de saldos finais j? existe."			///"Arquivo de saldos finais j? existe."
		cMsg	:= "Arquivo encontrado: "+cArqTRB+GetDbExtension()+CHR(13)+CHR(10)         ///"Arquivo encontrado: "
		cMsg	+= "STR0075"
		If lJaProc					/// SE JA COME?OU A TRANSFERIR LAN?AMENTOS
			cTitMsg += " (Recomendado N?o)"		///" (Recomendado N?o)"
			cMsg +=	CHR(13)+CHR(10)+"STR0077"
		Else
			cTitMsg += " Sem mover lan?amentos !"		///" Sem mover lan?amentos !"	
			cMsg +=	CHR(13)+CHR(10)+" (Recomendado SIM, use N?O somente com certeza que o arquivo de saldos finais esta coerente.)"	///" (Recomendado SIM, use N?O somente com certeza que o arquivo de saldos finais esta coerente.)"
		EndIf

		nRetMsg := Aviso(cTitMsg,cMsg, { "Sim","Nao","Sair" } )///"Sim"#"N?o"#"Sair"

		If nRetMsg == 1
			/// CASO A TRANSFER?NCIA DE LANCAMENTOS J? TENHA SIDO INICIADA
			If lJaProc .and. !MsgNoYes("Recalcular os saldos pode afetar os valores de saldo inicial para o per?odo seguinte (caso j? existam lan?amentos do saldo final)."+"Deseja Realmente continuar ?"+chr(13)+chr(10)+"STR0084","STR0055")///"Recalcular os saldos pode afetar os valores de saldo inicial para o per?odo seguinte (caso j? existam lan?amentos do saldo final)."#"Deseja Realmente continuar ?"#"A T E N C ? O !!!"
				Return .F.
			EndIf

			If FErase(cArqTrb+GetDbExtension()) < 0
				MsgAlert("STR0085"+cArqTRB+GetDbExtension(),"STR0086")
				Return .F.
			EndIf			
			
			lNovoTRB := .T.					/// UTILIZA O ARQUIVO DE SALDOS J? CALCULADO (RECOMENDADO SE N?O TRANSFERIU LANCAMENTOS)
		ElseIf nRetMsg == 2	
			lNovoTRB := .F.
		Else 
			Return .F.
		EndIf
	EndIf
Else	
	If !File(cArqTrb+GetDbExtension())	
        
		cMsg := "Arquivo de Saldos"#" n?o encontrado ! "+cArqTRB+GetDbExtension()+"STR0088"+CHR(13)+CHR(10)+"STR0089"///"Arquivo de Saldos"#" n?o encontrado ! "
		
		If lJaProc
			cMsg += CHR(13)+CHR(10)+"STR0090"
		EndIf

		nRetMsg := Aviso("STR0055",cMsg, { "STR0080","STR0081" } )
		
		If nRetMsg == 1
			lNovoTRB := .T.
		Else
			Return .F.
		EndIf
	Else
		lNovoTRB := .F.
	EndIf
EndIf

If File(cArqIND1+OrdBagExt())
	FErase(cArqIND1+OrdBagExt())
EndIf
If File(cArqIND2+OrdBagExt())
	FErase(cArqIND2+OrdBagExt())
EndIf

//?????????????????????????11??????????????????????????????????Ŀ
//? Crio arq. de trab. p/ gravar as inconsistencias.           ?
//??????????????????????????????????????????????????????????????                                        
If lNovoTRB
	cTrb	:= CriaTrab(aCampos,.T.)
	
	While FRename(cTrb+GetDbExtension(),cArqTRB+GetDbExtension()) < 0
		If !MsgNoYes("N?o foi possivel criar o arquivo: "+cArqTRB+GetDbExtension()+CHR(13)+"STR0092","STR0086")///"N?o foi possivel criar o arquivo: "#" Tentar novamente ?"#"Erro - Arquivo em uso ou travado."
			Return .F.
		EndIf
	EndDo
EndIf

dbUseArea(.T.,,cArqTrb,"TRB",.T.,.F.)

IndRegua("TRB", cArqIND1, "TPSALDO+MOEDA+CONTA+CUSTO+ITEM+CLVL+IDENT",,, "Index...")
IndRegua("TRB", cArqIND2, "TPSALDO+MOEDA+IDENT+CONTA+CUSTO+ITEM+CLVL",,, "Index...")
dbClearIndex()
dbSetIndex(cArqIND1+OrdBagExt())
dbSetIndex(cArqIND2+OrdBagExt())

Return .T.

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????Ŀ??
???Fun??o    ?CTB995GTRB? Autor ? Marcos S. Lobo        ? Data ? 21.12.01 ???
?????????????????????????????????????????????????????????????????????????Ĵ??
???Descri??o ?Verifico os Saldos e Grava no Arquivo de Trabalho			  ???
?????????????????????????????????????????????????????????????????????????Ĵ??
???Sintaxe   ?CTB995GTRB()                                                ???
?????????????????????????????????????????????????????????????????????????Ĵ??
??? Uso      ? CTBA995                                                    ???
??????????????????????????????????????????????????????????????????????????ٱ?
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/
STATIC FUNCTION CTB995GTRB(cAlias,aCTOxCTE,aTpSaldos,oObj,lCusto,lItem,lClvl)

Local lObj := ValType(oObj) == "O"

Local nRecno	:=	0
Local nTotRegua	:= ((cAlias)->(Reccount()))
Local cConta 	:= SPACE(nTamCta)
Local cCusto 	:= SPACE(nTamCC)
Local cItem  	:= SPACE(nTamItem)
Local cClVl		:= SPACE(nTamClVl)

Local nMoedAtu	:= 1
Local cMoedAtu	:= "01"
Local nTpSldAtu	:= 1
Local cTpSldAtu	:= "1"

Local aSldAtu	:= {}
Local nDebTrb	:= 0 
Local nCrdTrb	:= 0
Local nTrbSlD	:= 0
Local nTrbSlC	:= 0
Local cKeyAtu	:= ""

dbSelectArea(cAlias)
dbSetOrder(2)
cFilAlias := xFilial(cAlias)

//// FAZ O PROCESSAMENTO PARA TODAS AS MOEDAS
For nMoedAtu := 1 to Len(aCTOxCTE)
	cMoedAtu := STRZERO(nMoedAtu,2)

	//// FAZ O PROCESSAMENTO PARA TODOS OS TIPOS DE SALDOS
	For nTpSldAtu := 1 to Len(aTpSaldos)
		cTpSldAtu := STRZERO(nTpSldAtu,1)

		If lObj
			oObj:SetRegua2(nTotRegua)			 				
		EndIf
		
		MsSeek(cFilAlias,.T.) //Procuro pela primeira conta a ser zerada
		While (cAlias)->(!Eof()) .And. (cAlias)->&(cAlias+"_FILIAL") == cFilAlias
		
			If lObj
				oObj:IncRegua2(OemToAnsi("Obtendo Saldos Finais - Moeda "+cMoedAtu+" Saldo "+cTpSldAtu))//"Obtendo Saldos Finais - Moeda " #" Saldo "
			EndIf
				
			If cAlias == 'CTI'
				cChave := CTI->(CTI_CONTA+CTI_CUSTO+CTI_ITEM+CTI_CLVL)
				cConta := CTI->CTI_CONTA
				cCusto := CTI->CTI_CUSTO
				cItem  := CTI->CTI_ITEM
				cClVl  := CTI->CTI_CLVL
			ElseIf cAlias == 'CT4'
				cChave := CT4->(CT4_CONTA+CT4_CUSTO+CT4_ITEM)
				cConta := CT4->CT4_CONTA
				cCusto := CT4->CT4_CUSTO
				cItem  := CT4->CT4_ITEM
			ElseIf cAlias == 'CT3'       
				cChave := CT3->(CT3_CONTA+CT3_CUSTO)
				cConta := CT3->CT3_CONTA
				cCusto := CT3->CT3_CUSTO
			ElseIf cAlias == 'CT7'
				cChave := CT7->CT7_CONTA
				cConta := CT7->CT7_CONTA
			EndIf

			cNxtChav:= IncLast(alltrim(cChave))		/// DETERMINA A PROXIMA CHAVE DE PESQUISA COM O CODIGO DAS ENTIDADES
			 
			If cAlias == 'CTI'
				aSldAtu	:= SaldoCTI(cConta,cCusto,cItem,cClVL,aCTOxCTE[nMoedAtu][3],cMoedAtu,cTpSldAtu,'CTBXFUN',.F.)	
			ElseIf cAlias == 'CT4'
				aSldAtu	:= SaldoCT4(cConta,cCusto,cItem,aCTOxCTE[nMoedAtu][3],cMoedAtu,cTpSldAtu,'CTBXFUN',.F.)	
			ElseIf cAlias == 'CT3'
				aSldAtu	:= SaldoCT3(cConta,cCusto,aCTOxCTE[nMoedAtu][3],cMoedAtu,cTpSldAtu,'CTBXFUN',.F.)		
			ElseIf cAlias == 'CT7'
				aSldAtu	:= SaldoCT7(cConta,aCTOxCTE[nMoedAtu][3],cMoedAtu,cTpSldAtu,'CTBXFUN',.F.)		
			EndIf			

			nTrbSlD := 0
			nTrbSlC := 0
			dbSelectArea("TRB")
			dbSetOrder(2)

			If aSldAtu[1] <> 0						/// SE HOUVER SALDO
				If cAlias == "CT4" //.or. (cAlias == "CT3" .and. !lItem)
					If lClvl
						cKeyAtu := cTpSldAtu+cMoedAtu+"CTI"+cConta+cCusto+cItem
						If dbSeek(cKeyAtu,.F.)
							While TRB->(!Eof()) .and. cKeyAtu == TRB->(TPSALDO+MOEDA+IDENT+CONTA+CUSTO+ITEM)
								nTrbSlD += TRB->SALDOD
								nTrbSlC += TRB->SALDOC
								TRB->(dbSkip())
							EndDo					
						EndIf					
					EndIf
				ElseIf cAlias == "CT3" //.or. (cAlias == "CT7" .and. !lCusto)
					If lItem
						cKeyAtu := cTpSldAtu+cMoedAtu+"CT4"+cConta+cCusto
						If dbSeek(cKeyAtu,.F.)
							While TRB->(!Eof()) .and. cKeyAtu == TRB->(TPSALDO+MOEDA+IDENT+CONTA+CUSTO)
								nTrbSlD += TRB->SALDOD
								nTrbSlC += TRB->SALDOC
								TRB->(dbSkip())
							EndDo					
						EndIf
					EndIf

					/// SE N?O LOCALIZOU CHAVE NO CT4 VERIFICA SE H? NO CTI
					If lClvl
						cKeyAtu := cTpSldAtu+cMoedAtu+"CTI"+cConta+cCusto
						If dbSeek(cKeyAtu,.F.)
							While TRB->(!Eof()) .and. cKeyAtu == TRB->(TPSALDO+MOEDA+IDENT+CONTA+CUSTO)
								nTrbSlD += TRB->SALDOD
								nTrbSlC += TRB->SALDOC
								TRB->(dbSkip())
							EndDo					
						EndIf										
					EndIf
				ElseIf cAlias == "CT7"				
					If lCusto
						cKeyAtu := cTpSldAtu+cMoedAtu+"CT3"+cConta
						If dbSeek(cKeyAtu,.F.)
							While TRB->(!Eof()) .and. cKeyAtu == TRB->(TPSALDO+MOEDA+IDENT+CONTA)
								nTrbSlD += TRB->SALDOD
								nTrbSlC += TRB->SALDOC
								TRB->(dbSkip())
							EndDo					
						EndIf
					EndIf
					/// SE N?O LOCALIZOU CHAVE NO CT3 VERIFICA SE H? NO CT4
					If lItem
						cKeyAtu := cTpSldAtu+cMoedAtu+"CT4"+cConta
						If dbSeek(cKeyAtu,.F.)
							While TRB->(!Eof()) .and. cKeyAtu == TRB->(TPSALDO+MOEDA+IDENT+CONTA)
								nTrbSlD += TRB->SALDOD
								nTrbSlC += TRB->SALDOC
								TRB->(dbSkip())
							EndDo					
						EndIf
					EndIf
					
					/// SE N?O LOCALIZOU CHAVE NO CT4 VERIFICA SE H? NO CTI
					If lClvl
						cKeyAtu := cTpSldAtu+cMoedAtu+"CTI"+cConta
						If dbSeek(cKeyAtu,.F.)
							While TRB->(!Eof()) .and. cKeyAtu == TRB->(TPSALDO+MOEDA+IDENT+CONTA)
								nTrbSlD += TRB->SALDOD
								nTrbSlC += TRB->SALDOC
								TRB->(dbSkip())
							EndDo					
						EndIf					
					EndIf
				EndIf

				nDebTrb := aSldAtu[4] - nTrbSlD
				nCrdTrb := aSldAtu[5] - nTrbSlC

				dbSelectArea("TRB")
				dbSetOrder(1)
				If (nDebTrb <> 0 .or. nCrdTrb <> 0) .and. !dbSeek(cTpSldAtu+cMoedAtu+cConta+cCusto+cItem+cClvl+cAlias,.F.)
					dbSetOrder(2)
					RecLock("TRB",.T.)
					Field->TPSALDO	:= cTpSldAtu
					Field->MOEDA	:= cMoedAtu
					Field->CONTA	:= cConta
					Field->CUSTO	:= cCusto
					Field->ITEM		:= cItem
					Field->CLVL		:= cClVL
					Field->IDENT	:= cAlias
					Field->SALDOD	:= nDebTrb
					Field->SALDOC	:= nCrdTrb
					TRB->(MsUnlock())
				EndIf
			EndIf
	
			dbSelectArea(cAlias)
			(cAlias)->(MsSeek(cFilAlias+cNxtChav,.T.))		
		EndDo
	Next nTpSldAtu
Next nMoedAtu

Return
