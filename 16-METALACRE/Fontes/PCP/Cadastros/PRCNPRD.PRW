#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"  
#Include "Rwmake.ch"

/*/
???????????????????????????????????????
???????????????????????????????????????
??un?o    ?PRCNPRD  ?utor  ?Luiz Alberto        ?Data ?24.12.2015 ??
???????????????????????????????????????
??         ?otina de processamento da Nova Codifica?o de Produtos      ??
??         ?NTERCARTA                                                   ??
???????????????????????????????????????
??etorno   ?enhum                                                       ??
??         ?                                                            ??
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
/*/
User Function PrcNPrd()
Local cCadastro := 'Processa SERV em Estruturas'
Local aSays		:= {}
Local aButtons	:= {}
LOCAL nOpca 	:= 0
LOCAL aCAP		:= {'Confirma','Abandona','Parametros'}  //"Confirma"###"Abandona"###"Par?etros"
LocaL cTitulo	:=	'SERV Para Estruturas'
Local cText1	:=	"Este programa faz o Processamento dos Codigos SERV para Estruturas "
Local cText2	:=	"informados pelo usuario."
Private cPerg		:=	PadR("PRCNPRD",10)
Private oProcess


AjustaSX1()                         
Pergunte(cPerg,.F.)
//????????????????????????????????
//?Janela Principal                                             ?
//????????????????????????????????
While .T.
	AADD(aSays,OemToAnsi( ctext1 ) )
	AADD(aSays,OemToAnsi( cText2 ) )
	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
	AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
	FormBatch( cCadastro, aSays, aButtons )

	Do Case
		Case nOpca ==1
		    oProcess := MsNewProcess():New( { || aPNPProcessa() } , "Processando Estruturas" , "Aguarde..." , .F. )
		    oProcess:Activate()
		Case nOpca==3
			Pergunte(cPerg,.t.)
			Loop
	EndCase
	Exit
EndDo
RETURN


/*/
???????????????????????????????????????
???????????????????????????????????????
??un?o    ?aPNPProcessa  ?utor  ?Luiz Alberto    ?Data ?24.12.2015 ??
???????????????????????????????????????
??         ?Fun?o que efetua o Processamento dos Produtos Antigos      ??
??         ?INTERCARTA                                                  ??
???????????????????????????????????????
??etorno   ?enhum                                                       ??
??         ?                                                            ??
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
/*/
Static Function aPNPProcessa()
Local aArea := GetArea()
Private aServ := {}

Aadd(aServ,{'CRP401933','SERVINJCRP40 ',1})
Aadd(aServ,{'TMP40ZMK1934','SERVINJCTESF',1})
Aadd(aServ,{'CTESF1935','SERVINJTMP40 ',1})
Aadd(aServ,{'B31MZMK2100','SERVINJB31M',1})
Aadd(aServ,{'B30MZMK','SERVINJB30M',1})
Aadd(aServ,{'FEC1.8ZMK2526','SERVINJFEC1.8',1})
Aadd(aServ,{'CRP54ZMK','SERVINJCRP54',1})
Aadd(aServ,{'S28BASE-BRAWAL','SERVINJBASE28',1})
Aadd(aServ,{'CRP38ZMK1313','SERVINJCRP38ZMK',1})
Aadd(aServ,{'TMP38ZMK1314','SERVINJTMP38ZMK',1})
Aadd(aServ,{'CONEZMK1850','SERVINJCONE38ZMK',1})
Aadd(aServ,{'CRP38ZMK','SERVINJCRP38.3ZMK',1})
Aadd(aServ,{'FEC1.8ZMKT','SERVINJFEC1.8T',1})
Aadd(aServ,{'B191756','SERVINJB19',1})
Aadd(aServ,{'CRP40AM2667','SERVPINT',1})
Aadd(aServ,{'CRP40AZ2670','SERVPINT',1})
Aadd(aServ,{'CRP40BG2669','SERVPINT',1})
Aadd(aServ,{'CRP40BR2114','SERVPINT',1})
Aadd(aServ,{'CRP40LR2666','SERVPINT',1})
Aadd(aServ,{'CRP40VDESC3313','SERVPINT',1})
Aadd(aServ,{'CRP40VERM2668','SERVPINT',1})
Aadd(aServ,{'B31MAM','SERVPINT',1})
Aadd(aServ,{'B31MAZ','SERVPINT',1})
Aadd(aServ,{'B31MBG','SERVPINT',1})
Aadd(aServ,{'B31MBR','SERVPINT',1})
Aadd(aServ,{'B31MLR','SERVPINT',1})
Aadd(aServ,{'B31MVD','SERVPINT',1})
Aadd(aServ,{'B31MVM','SERVPINT',1})
Aadd(aServ,{'B30MAM','SERVPINT',1})
Aadd(aServ,{'B30MAZ','SERVPINT',1})
Aadd(aServ,{'B30MBG','SERVPINT',1})
Aadd(aServ,{'B30MBR','SERVPINT',1})
Aadd(aServ,{'B30MLR','SERVPINT',1})
Aadd(aServ,{'B30MVD','SERVPINT',1})
Aadd(aServ,{'B30MVM','SERVPINT',1})
Aadd(aServ,{'CRP40ZP2117','SERVZIN',1})
Aadd(aServ,{'B31M-ZP','SERVZIN',1})
Aadd(aServ,{'B30MZP','SERVZIN',1})
Aadd(aServ,{'B19ZP2779','SERVZIN',1})
Aadd(aServ,{'FEC1.8ACO31','SERVUSIFEC1.8',1})
Aadd(aServ,{'T1933','SERVUSIT19/31.19',1})
Aadd(aServ,{'T31.19524','SERVUSIT19/31.20',1})
Aadd(aServ,{'S28RODA','SERVUSIRODA28',1})
Aadd(aServ,{'S29MTLINJ-AM150MM','SERVINJPLAST',1})
Aadd(aServ,{'S29MTLINJ-AM200MM','SERVINJPLAST',1})
Aadd(aServ,{'S29MTLINJ-AM300MM','SERVINJPLAST',1})
Aadd(aServ,{'S29MTLINJ-AM400MM','SERVINJPLAST',1})
Aadd(aServ,{'S29MTLINJ-AM800MM','SERVINJPLAST',1})
Aadd(aServ,{'S29MTLINJ-AZ','SERVINJPLAST',1})
Aadd(aServ,{'S29MTLINJ-AZ150MM','SERVINJPLAST',1})
Aadd(aServ,{'S29MTLINJ-AZ200MM','SERVINJPLAST',1})
Aadd(aServ,{'S29MTLINJ-AZ300MM','SERVINJPLAST',1})
Aadd(aServ,{'S29MTLINJ-AZ400MM','SERVINJPLAST',1})
Aadd(aServ,{'S29MTLINJ-AZ600MM','SERVINJPLAST',1})
Aadd(aServ,{'S29MTLINJ-BR150MM','SERVINJPLAST',1})
Aadd(aServ,{'S29MTLINJ-BR200MM','SERVINJPLAST',1})
Aadd(aServ,{'S29MTLINJ-BR300MM','SERVINJPLAST',1})
Aadd(aServ,{'S29MTLINJ-BR400MM','SERVINJPLAST',1})
Aadd(aServ,{'S29MTLINJ-CZ200MM','SERVINJPLAST',1})
Aadd(aServ,{'S29MTLINJ-CZ300MM','SERVINJPLAST',1})
Aadd(aServ,{'S29MTLINJ-CZ400MM','SERVINJPLAST',1})
Aadd(aServ,{'S29MTLINJ-VDCL150MM','SERVINJPLAST',1})
Aadd(aServ,{'S29MTLINJ-VDCL200MM','SERVINJPLAST',1})
Aadd(aServ,{'S29MTLINJ-VDCL300MM','SERVINJPLAST',1})
Aadd(aServ,{'S29MTLINJ-VDCL400MM','SERVINJPLAST',1})
Aadd(aServ,{'S29MTLINJ-VM200MM','SERVINJPLAST',1})
Aadd(aServ,{'S29MTLINJ-VM300MM','SERVINJPLAST',1})
Aadd(aServ,{'S29MTLINJ-VM400MM','SERVINJPLAST',1})
Aadd(aServ,{'S29MTLINJ-VD200MM','SERVINJPLAST',1})
Aadd(aServ,{'S29.8MTLINJ-AM150MM','SERVINJPLAST',1})
Aadd(aServ,{'S29.8MTLINJ-AM200MM','SERVINJPLAST',1})
Aadd(aServ,{'S29.8MTLINJ-AZ150MM','SERVINJPLAST',1})
Aadd(aServ,{'S29.8MTLINJ-AZ200MM','SERVINJPLAST',1})
Aadd(aServ,{'S29.8MTLINJ-AZ250MM','SERVINJPLAST',1})
Aadd(aServ,{'S29.8MTLINJ-AZ500MM','SERVINJPLAST',1})
Aadd(aServ,{'S29.8MTLINJ-BR150MM','SERVINJPLAST',1})
Aadd(aServ,{'S29.8MTLINJ-BR200MM','SERVINJPLAST',1})
Aadd(aServ,{'S29.8MTLINJ-BR500MM','SERVINJPLAST',1})
Aadd(aServ,{'S29.8MTLINJ-CZ1000MM','SERVINJPLAST',1})
Aadd(aServ,{'S29.8MTLINJ-CZ130MM','SERVINJPLAST',1})
Aadd(aServ,{'S29.8MTLINJ-VD200MM','SERVINJPLAST',1})
Aadd(aServ,{'S29.8MTLINJ-VD500MM','SERVINJPLAST',1})
Aadd(aServ,{'S29.8MTLINJ-VDCL150MM','SERVINJPLAST',1})
Aadd(aServ,{'S29.8MTLINJ-VDCL200MM','SERVINJPLAST',1})
Aadd(aServ,{'S29.8MTLINJ-VDCL500MM','SERVINJPLAST',1})
Aadd(aServ,{'S29.8MTLINJ-VM150MM','SERVINJPLAST',1})
Aadd(aServ,{'S29MTLINJ-LR','SERVINJPLAST29LR',1})
Aadd(aServ,{'S29MTLINJ-LR150MM','SERVINJPLAST29LR',1})
Aadd(aServ,{'S29MTLINJ-LR200MM','SERVINJPLAST29LR',1})
Aadd(aServ,{'S29MTLINJ-LR300MM','SERVINJPLAST29LR',1})
Aadd(aServ,{'S29MTLINJ-LR400MM','SERVINJPLAST29LR',1})
Aadd(aServ,{'S29.8MTLINJ-LR150MM','SERVINJPLAST29LR',1})
Aadd(aServ,{'S29.8MTLINJ-LR200MM','SERVINJPLAST29LR',1})
Aadd(aServ,{'S29.8MTLINJ-LR500MM','SERVINJPLAST29LR',1})
Aadd(aServ,{'S29.8MTLINJ-LS200MM','SERVINJPLAST29LR',1})
Aadd(aServ,{'S29.8MTLINJ-LS500MM','SERVINJPLAST29LR',1})

// Inicio de Processamento dos Produtos Antigos
// Apenas Produtos Antigos com o Campo B1_PRCNEW Igual a Vazio ou N? se Estiver como Sim
// Quer Dizer que J?foi Processado.
// E Campo B1_CODANT Vazio pois Produtos Novos Ter? este campo Preenchido com o Codigo
// do Produto Antigo Origem.


// Cria Arquivo Tempor?io com a Mesma Estrutura da Tabela de Produtos Para Adicionar os Novos C?igos
// e Ao Final do Processamento Inseri-los

// Verifica se o Parametro 1 Produto De esta Preenchido, se Estiver Posiciona no Produto, Sen? Vai Para Inicio
// da tabela SB1

oProcess:SetRegua1( Len(aServ) ) //Alimenta a primeira barra de progresso
For nMao := 1 To Len(aServ)
	//processamento da primeira barra de progresso
        	
	If !SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+aServ[nMao,2]))
		MsAguarde({||Inkey(1)}, "", "Produto " + aServ[nMao,2] + " Não Localizado !", .T.)
		Loop
	Endif

	If !SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+aServ[nMao,1]))
		MsAguarde({||Inkey(1)}, "", "Produto " + aServ[nMao,1] + " Não Localizado !", .T.)
		Loop
	Endif
	
	
	cProd := SB1->B1_COD
	cDesc := Capital(Left(SB1->B1_DESC,30))

	If !SG1->(dbSetOrder(1), dbSeek(xFilial("SG1")+aServ[nMao,1]))
		oProcess:IncRegua1("Prod:"+AllTrim(cProd) + " " + cDesc)
		Loop
	Endif

	cProduto := SG1->G1_COD
	nQuant	 := SG1->G1_QUANT
	
	// Grava a Nova Estrutura
		
	NESTRU := 1
	aEstrutura := {}
	lOk := .f.		
	aStru := Estrut(cProduto,1,.F.,.F.)

	oProcess:SetRegua2( (Len(aServ)-nMao) ) //Alimenta a segunda barra de progresso
	For nContinua := nMao To Len(aServ)

		oProcess:IncRegua2("PI: "+AllTrim(cProduto) + " - Serv.: " + AllTrim(aServ[nContinua,2]))

		If AllTrim(aServ[nContinua,1])==AllTrim(cProduto) .And. ;
			Ascan(aStru,{|x| AllTrim(x[2])==AllTrim(aServ[nContinua,1]) .And. AllTrim(x[3])==AllTrim(aServ[nContinua,2]) })==0
			
			oProcess:IncRegua1("Prod:"+AllTrim(cProd) + " " + cDesc)
			
			AADD(aStru,{nESTRU,aServ[nContinua,1],aServ[nContinua,2],aServ[nContinua,3],'','',''})

			nMao := nContinua
			lOk  := .t.

		Endif

	Next

	// Cria Nova Estrutura
				
	If lOk	// Se Adicionou algo a Estrutura então Altera
		begin transaction
	
		aCab := {}
		aCab := {	{"G1_COD"		, cProduto			,NIL},;
					{"ATUREVSB1"	, "S"		, NIL},;
					{"NIVEL1"		, "S"		, NIL},;
					{"NIVALT"		, "S"				,NIL},; //A variavel NIVALT eh utilizada pra recalcular ou nao a estrutura
					{"G1_QUANT"		, nQuant		,NIL}}
					
		aItem := {}
		
		For nStru := 1 To Len(aStru)
			aGets := {}                           
			aadd(aGets,	{"G1_COD"		,aStru[nStru,2]   	,NIL})
			aadd(aGets,	{"G1_COMP"		,aStru[nStru,3]		,NIL})
			aadd(aGets,	{"G1_TRT"		,Space(3)			,NIL})
			aadd(aGets,	{"G1_QUANT"		,aStru[nStru,4]		,NIL})
			aadd(aGets,	{"G1_PERDA"		,0					,NIL})
			aadd(aGets,	{"G1_INI"		,dDataBase			,NIL})
			aadd(aGets,	{"G1_FIM"		,CTOD("31/12/49")	,NIL})
			aadd(aItem,aGets)
		Next
			
		lMsErroAuto := .f.
		MSExecAuto({|x,y,z| mata200(x,y,z)},aCab,aItem,4) //Inclusao
		If lMsErroAuto
			MsAguarde({||Inkey(5)}, "", 'Erro na Alteração do Produto [' + AllTrim(cProduto) + '] - Verifique !', .T.)
	//		MostraErro()
			DisarmTransaction()
		Endif      
		End Transaction
	Endif
Next
RestArea(aArea)
Return .t.


/*/
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
??uncao    ?justaSX1 ?Autor ?Marcelo Alexandre     ?Data ?1.05.2008??
???????????????????????????????????????
??escri?o ?ria as perguntas necesarias para o programa                ??
???????????????????????????????????????
??etorno   ?enhum                                                      ??
???????????????????????????????????????
??arametros?enhum                                                      ??
??         ?                                                           ??
???????????????????????????????????????
??  DATA   ?Programador   ?anutencao Efetuada                         ??
???????????????????????????????????????
??         ?              ?                                           ??
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 25/06/12 ==> Static Function AjustaSX1()
Static Function AjustaSX1()
Local	aHelpPor := {}
Local	aHelpEng := {}                                     
Local	aHelpSpa := {}

dbSelectArea("SX1")
dbSetOrder(1)

PutSx1(cPerg,"01","Produto De  ?","Produto De  ?","Produto De  ?","mv_ch1","C",30,0,0,"G","","","","","mv_par01",'','','',"",'','','',"","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)	//"Gera Titulo ICMS Complem"###"Sim"###"Nao"
PutSx1(cPerg,"02","Produto Ate ?","Produto Ate ?","Produto Ate ?","mv_ch2","C",30,0,0,"G","","","","","mv_par02",'','','',"",'','','',"","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)	//"Gera Titulo ICMS Complem"###"Sim"###"Nao"

Return NIL

