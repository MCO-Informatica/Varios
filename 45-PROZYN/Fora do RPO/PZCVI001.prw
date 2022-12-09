#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
#INCLUDE "protheus.ch"

//Cabe็alho
#DEFINE CBASE		1
#DEFINE ITEM        2
#DEFINE AQUISIC     3
#DEFINE DESCRIC     4
#DEFINE QUANTD      5
#DEFINE CHAPA       6
#DEFINE PATRIM      7
#DEFINE GRUPO       8
#DEFINE NFISCAL		9

//Itens
#DEFINE TIPO        10
#DEFINE BAIXA       11
#DEFINE HISTOR      12
#DEFINE CCONTAB     13
#DEFINE CUSTBEM     14
#DEFINE CDEPREC     15
#DEFINE CDESP       16
#DEFINE CCORREC     17
#DEFINE CCUSTO      18
#DEFINE DINDEPR     19
#DEFINE VORIG1      20
#DEFINE TXDEPR1     21
#DEFINE VORIG2      22
#DEFINE TXDEPR2     23
#DEFINE VORIG3      24
#DEFINE TXDEPR      25
#DEFINE VORIG4      26
#DEFINE TXDEPR4     27
#DEFINE VORIG5      28
#DEFINE TXDEPR5     29
#DEFINE PERDEPR		30 
#DEFINE VRDACM1		31


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPZCVI001  บAutor  ณMicrosiga           บ Data ณ  28/11/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImporta็ใo de ativo imobilizado			                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PZCVI001()
	Local aBotoes		:= {}
	Local aSays		:= {}
	Local nOpcao		:= 0   
	Local aPerg		:= {}


	//Tela de aviso e acesso aos parametros
	AAdd(aSays,"[Importa็ใo de planilha]")
	AAdd(aSays,"Esse programa efetuara a importa็ใo de dados  ")
	AAdd(aSays,"referente o ativo.")


	AAdd(aBotoes,{ 5,.T.,{|| aPerg := PergFile() 		}} )
	AAdd(aBotoes,{ 1,.T.,{|| nOpcao := 1, FechaBatch() 	}} )
	AAdd(aBotoes,{ 2,.T.,{|| FechaBatch() 				}} )        
	FormBatch( "[Importa็ใo]", aSays, aBotoes )

	//Verifica se o parametro com o endere็o do arquivo foi preenchido
	If Len(aPerg) > 0

		If aPerg[1]
			If nOpcao == 1
				Processa( {|| ImpArqPla(aPerg) },"","" )
			EndIf
		Else
			Aviso("Erro","Erro ao ler arquivo...",{"Ok"},2)
		EndIf
	Else
		Aviso("Aten็ใo","O parโmetro com o nome do arquivo nใo foi preenchido ! ",{"Ok"},2) 
	EndIf

Return(Nil) 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPergFile  บAutor  ณMicrosiga           บ Data ณ  13/01/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ	
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PergFile()

	Local aArea 		:= GetArea()
	Local aRetPath  	:= {}
	Local aParamBox	:= {} 
	Local lRet			:= .F.
	Local aRet			:= {}		

	aAdd(aParamBox 	,{6,"Local do arquivo","","","File(&(ReadVar()))","",100,.T.,"Arquivos .CSV |*.CSV","",GETF_LOCALHARD+GETF_NETWORKDRIVE})


	//Monta a pergunta
	lRet := ParamBox(aParamBox ,"Parametros",@aRetPath,,,.T.,50,50,				,			,.T.			,.T.)

	aRet := {lRet, aRetPath}

	RestArea(aArea)
Return aRet  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpArqPla บAutor  ณMicrosiga           บ Data ณ  05/14/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpArqPla(aParam)

	Local aArquivo 		:= {}
	Local cLinha   		:= "" 
	Local aLinha  		:= {}
	Local lRetImp		:= .T.
	Local cArqImp 		:= aParam[2][1]//Local do Arquivo
	Local aMsgErr		:= {}
	Local nCont			:= 1

	FT_FUse(cArqImp)
	FT_FGoTop()
	ProcRegua(FT_FLastRec())
	FT_FGoTop()

	While !FT_FEof() 

		IncProc("Efetuando a leitura do arquivo...")

		//Pula a primeira linha do arquivo (Cabe็alho)
		If nCont == 1
			++nCont
			FT_FSkip()
			loop
		EndIf



		//Inicia as variaveis com vazio
		cLinha 	:= ""
		aLinha 	:= {}

		cLinha   	:= FT_FReadLn()   
		aLinha		:= Separa(StrTran(cLinha,'"',""),";") //Quebra a linha em colunas de acordo com o delimitador ';'

		//Verifica se o arquivo esta com a quantidade de colunas correta
		If (Len(aLinha) >= 11) 

			//Adiciona a linha ao arquivo
			aAdd(aArquivo,aLinha )

		Else
			Aviso("ERROLAYOUT","Formato de arquivo inesperado, verifique se o layout estแ correto.",{"Ok"},3)
			lRetImp := .F.

			Exit
			Return
		EndIf

		FT_FSkip()
	EndDo 

	If Len(aArquivo) > 0

		If VldArq(aArquivo, @aMsgErr)	
			PrepArqProc(aArquivo, aMsgErr)

			If Len(aMsgErr) > 0
				If Aviso("Log Erro", "Erro ao realizar a importa็ใo do arquivo. Deseja visualizar o log de processamento ?", {"Sim","Nใo"},2) == 1
					//Log de processamento
					GetMsgErr(aMsgErr)	
				EndIf				
			EndIf
		Else
			If Aviso("Log Erro", "Erro ao realizar a importa็ใo do arquivo. Deseja visualizar o log de processamento ?", {"Sim","Nใo"},2) == 1
				//Log de processamento
				GetMsgErr(aMsgErr)	
			EndIf	
		EndIf
	Else
		Aviso("ARQVAZIO", "Nใo existe dados a serem importados", {"Ok"},2)
		lRetImp := .F.
	EndIf

Return lRetImp  



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldArq	 บAutor  ณMicrosiga           บ Data ณ  13/11/2019บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPre-valida็ใo do arquivo                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VldArq(aArquivo, aMsgErr)

	Local aArea 		:= GetArea()
	Local lRet			:= .T.
	Local cMsgAux		:= ""
	Local nX			:= 0
	Local cLinAux		:= ""

	Default aMsgErr := {}

	
	DbSelectArea("CT1")
	DbSetOrder(1)

	DbSelectArea("CTT")
	DbSetOrder(1)

	For nX := 1 To Len(aArquivo)

		cLinAux		:= "Linha: "+Alltrim(Str(nX+1))+"->"
		cMsgAux		:= ""


		//Valida็ใo do codigo base
		If Empty(aArquivo[nX][CBASE])
			cMsgAux	+= cLinAux+"#Cod Base do Bem nใo preenchido;"+CRLF
			lRet		:= .F.			
		EndIf
		
		//Valida็ใo do item
		If Empty(aArquivo[nX][ITEM])
			cMsgAux	+= cLinAux+"#Item nใo preenchido;"+CRLF
			lRet		:= .F.			
		EndIf

		//Valida็ใo da data de aquisi็ใo
		If Empty(aArquivo[nX][AQUISIC])
			cMsgAux	+= cLinAux+"#Data de aquisi็ใo nใo preenchida;"+CRLF
			lRet		:= .F.			
		EndIf

		//Valida็ใo da descri็ใo do bem
		If Empty(aArquivo[nX][DESCRIC])
			cMsgAux	+= cLinAux+"#Descri็ใo do bem nใo preenchida;"+CRLF
			lRet		:= .F.			
		EndIf

		//Valida็ใo quantidade
		If Empty(aArquivo[nX][QUANTD]) .Or. NCONVVAL(aArquivo[nX][QUANTD])<=0  
			cMsgAux	+= cLinAux+"#Quantidade do bem nใo preenchido ou com valor zero;"+CRLF
			lRet		:= .F.			
		EndIf

		//Valida็ใo quantidade
		If Empty(aArquivo[nX][CHAPA])  
			cMsgAux	+= cLinAux+"#Num.Plaqueta nใo preenchido;"+CRLF
			lRet		:= .F.			
		EndIf

		//Valida็ใo tipo
		If Empty(aArquivo[nX][TIPO])  
			cMsgAux	+= cLinAux+"#Tipo nใo preenchido;"+CRLF
			lRet		:= .F.			
		EndIf
		
		//Valida็ใo historico da baixa
		/*If Empty(aArquivo[nX][HISTOR])  
			cMsgAux	+= cLinAux+"#Historico nใo preenchido;"+CRLF
			lRet		:= .F.			
		EndIf*/

		
		If Empty(aArquivo[nX][GRUPO])
			//Valida็ใo historico da baixa
			If Empty(aArquivo[nX][CCONTAB])  
				cMsgAux	+= cLinAux+"#Conta nใo preenchida;"+CRLF
				lRet		:= .F.
			ElseIf CT1->(!DbSeek(xFilial("CT1") + aArquivo[nX][CCONTAB] ))
				cMsgAux	+= cLinAux+"#Conta nใo encontrada;"+CRLF
				lRet		:= .F.
			EndIf
		EndIf
		
		If !Empty(aArquivo[nX][CUSTBEM]) .And. CTT->(!DbSeek(xFilial("CTT") + aArquivo[nX][CUSTBEM] ))  
			cMsgAux	+= cLinAux+"#C.Custo Bem nใo encontrada;"+CRLF
			lRet		:= .F.
		EndIf

		If !Empty(aArquivo[nX][CDEPREC]) .And. CT1->(!DbSeek(xFilial("CT1") + aArquivo[nX][CDEPREC] ))  
			cMsgAux	+= cLinAux+"#Cta Desp Dep nใo encontrada;"+CRLF
			lRet		:= .F.
		EndIf
		
		If Empty(aArquivo[nX][VORIG1]) .Or. NCONVVAL(aArquivo[nX][VORIG1])<=0  
			cMsgAux	+= cLinAux+"#Val Orig M1 nใo preenchido ou com valor zero;"+CRLF
			lRet		:= .F.			
		EndIf		

		If Empty(aArquivo[nX][TXDEPR1]) //.Or. NCONVVAL(aArquivo[nX][TXDEPR1])<=0  
			cMsgAux	+= cLinAux+"#Tx.An.Depr.1 nใo preenchido ou com valor zero;"+CRLF
			lRet		:= .F.			
		EndIf		


		If !lRet .And. !Empty(cMsgAux) 
			//Log de processamento
			Aadd(aMsgErr,"------------------------------------------------------------"+CRLF+cMsgAux)
		EndIf

	Next

	RestArea(aArea)
Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrepArqProc บAutor  ณMicrosiga      บ Data ณ  13/11/19      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrepara็ใo dos dados a serem importados pelo execauto		  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrepArqProc(aArquivo, aMsgErr) 

	Local aArea 		:= GetArea()
	Local cMsgLog	:= ""
	Local nX		:= 0
	Local aCab		:= {}
	Local aItens	:= {}
	Local aLinha	:= {}


	Default aArquivo 	:= {}

	ProcRegua(Len(aArquivo))                    

	For nX := 1 To Len(aArquivo)
		
		aCab 	:= {}
		aItens 	:= {}
		aLinha	:= {}
		
		IncProc("Importando...")

		//Preenchimento do cabe็alho
		If Len(aCab) == 0 
			
			//Cabe็alho
			Aadd(aCab, {"N1_CBASE"		 , Alltrim(aArquivo[nX][CBASE])		, NIL})
			Aadd(aCab, {"N1_ITEM"        , Alltrim(aArquivo[nX][ITEM]) 		, NIL})
			Aadd(aCab, {"N1_AQUISIC"     , CTOD( Alltrim(aArquivo[nX][AQUISIC]))	, NIL})
			Aadd(aCab, {"N1_DESCRIC"     , UPPER(Alltrim(aArquivo[nX][DESCRIC]))	, NIL})
			Aadd(aCab, {"N1_QUANTD"      , NCONVVAL(Alltrim(aArquivo[nX][QUANTD ]))	, NIL})
			Aadd(aCab, {"N1_CHAPA"       , Alltrim(aArquivo[nX][CHAPA  ])	, NIL})
			Aadd(aCab, {"N1_PATRIM"      , Alltrim(aArquivo[nX][PATRIM ])	, NIL})
			Aadd(aCab, {"N1_GRUPO"       , Alltrim(aArquivo[nX][GRUPO  ])	, NIL})
			Aadd(aCab, {"N1_NFISCAL"     , Alltrim(aArquivo[nX][NFISCAL  ])	, NIL})
		EndIf

		//Itens
		Aadd(aLinha, {"N3_CBASE"	, Alltrim(aArquivo[nX][CBASE])		, NIL})
		Aadd(aLinha, {"N3_ITEM"     , Alltrim(aArquivo[nX][ITEM]) 		, NIL})		
		Aadd(aLinha, {"N3_TIPO"     , Alltrim(aArquivo[nX][TIPO])		, NIL})
		Aadd(aLinha, {"N3_BAIXA"    , Alltrim(aArquivo[nX][BAIXA])		, NIL})
		Aadd(aLinha, {"N3_HISTOR"   , UPPER(Alltrim(aArquivo[nX][HISTOR]))		, NIL})
		Aadd(aLinha, {"N3_CCONTAB"  , Alltrim(aArquivo[nX][CCONTAB])	, NIL})
		Aadd(aLinha, {"N3_CUSTBEM"  , Alltrim(aArquivo[nX][CUSTBEM])	, NIL})
		Aadd(aLinha, {"N3_CDEPREC"  , Alltrim(aArquivo[nX][CDEPREC])	, NIL})
		Aadd(aLinha, {"N3_CDESP"    , Alltrim(aArquivo[nX][CDESP])		, NIL})
		Aadd(aLinha, {"N3_CCORREC"  , Alltrim(aArquivo[nX][CCORREC])	, NIL})
		Aadd(aLinha, {"N3_CCUSTO"   , Alltrim(aArquivo[nX][CCUSTO])		, NIL})
		Aadd(aLinha, {"N3_DINDEPR"  , CTOD(Alltrim(aArquivo[nX][DINDEPR]))		, NIL})
		Aadd(aLinha, {"N3_VORIG1"   , NCONVVAL(Alltrim(aArquivo[nX][VORIG1]))	, NIL})
		Aadd(aLinha, {"N3_TXDEPR1"  , NCONVVAL(Alltrim(aArquivo[nX][TXDEPR1]))	, NIL})
		Aadd(aLinha, {"N3_VORIG2"   , NCONVVAL(Alltrim(aArquivo[nX][VORIG2]))	, NIL})
		Aadd(aLinha, {"N3_TXDEPR2"  , NCONVVAL(Alltrim(aArquivo[nX][TXDEPR2]))	, NIL})
		Aadd(aLinha, {"N3_VORIG3"   , NCONVVAL(Alltrim(aArquivo[nX][VORIG3]))	, NIL})
		Aadd(aLinha, {"N3_TXDEPR3"  , NCONVVAL(Alltrim(aArquivo[nX][TXDEPR]))	, NIL})
		Aadd(aLinha, {"N3_VORIG4"   , NCONVVAL(Alltrim(aArquivo[nX][VORIG4]))	, NIL})
		Aadd(aLinha, {"N3_TXDEPR4"  , NCONVVAL(Alltrim(aArquivo[nX][TXDEPR4]))	, NIL})
		Aadd(aLinha, {"N3_VORIG5"   , NCONVVAL(Alltrim(aArquivo[nX][VORIG5]))	, NIL})
		Aadd(aLinha, {"N3_TXDEPR5"  , NCONVVAL(Alltrim(aArquivo[nX][TXDEPR5]))	, NIL})
		Aadd(aLinha, {"N3_PERDEPR"  , NCONVVAL(Alltrim(aArquivo[nX][PERDEPR]))	, NIL})
		Aadd(aLinha, {"N3_VRDACM1"  , NCONVVAL(Alltrim(aArquivo[nX][VRDACM1]))	, NIL})		
		Aadd(aLinha, {"N3_VRDACM2"  , 0	, NIL})
		Aadd(aLinha, {"N3_VRDACM3"  , 0	, NIL})
		Aadd(aLinha, {"N3_VRDACM4"  , 0	, NIL})
		Aadd(aLinha, {"N3_VRDACM5"  , 0	, NIL})
		
			
		
		AaDD(aItens, aLinha)
		
		//Grava็ใo do lan็amento contabil
		cMsgLog := RunArq(aCab, aItens, 3 )

		If !Empty(cMsgLog)
			Aadd(aMsgErr,"------------------------------------------------------------"+CRLF)
			Aadd(aMsgErr,"Linha '"+Alltrim(Str(nX+1))+"'-> Erro ao importar o ativo '"+Alltrim(aArquivo[nX][CBASE]))

			Aadd(aMsgErr,cMsgLog+CRLF)				
			Aadd(aMsgErr,"------------------------------------------------------------"+CRLF)
		EndIf

	Next


	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRunMovContบAutor  ณMicrosiga           บ Data ณ  14/01/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExecuta a gera็ใo do movimento contabil atraves de rotina   บฑฑ
ฑฑบ          ณautomatica                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 				                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunArq(aCab, aItem, nOpc )

	Local aArea 	:= GetArea()
	Local cRet		:= ""
	Local cMsgErro	:= ""

	Private lMsErroAuto := .F.

	Default aCab	:= {} 
	Default aItem 	:= {}
	Default nOpc	:= 3

	//Inicio da transa็ใo
	Begin Transaction

		//Verifica se os dados foram informados
		If Len(aCab) > 0 .And. Len(aItem) > 0  

			//Chama a rotina automatica para gravar os dados
			MSExecAuto({|x,y,Z| ATFA012(x,y,Z)},aCab,aItem,nOpc)

			//Verifica se ocorreru algum erro no processamento
			If lMSErroAuto

				//Captura a mensagem de erro
				cMsgErro := AllTrim(MemoRead(NomeAutoLog()))
				MemoWrite(NomeAutoLog()," ")

				cRet := cMsgErro

				//Rollback da transa็ใo
				DisarmTransaction()

			EndIf

		Else
			cRet := "Dados nใo informados"
		EndIf

		//Finalisa a transa็ใo
	End Transaction

	RestArea(aArea)
Return cRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNCONVVAL บAutor  ณMicrosiga      		 บ Data ณ  14/01/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function NCONVVAL(cValor)

	Local aArea 	:= GetArea()
	Local nRet		:= ""
	Local cValorAux	:= ""

	Default cValor := ""

	cValorAux := STRTRAN(cValor,"R$","")
	cValorAux := STRTRAN(cValorAux,".","")
	cValorAux := STRTRAN(cValorAux,",",".")

	nRet := Val(cValorAux)

	RestArea(aArea)
Return nRet 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetMsgErr	บAutor  ณMicrosiga			บ Data ณ  05/11/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para apresentar as mensagens de log        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetMsgErr(aMsg)

	Default aMsg := {}


	If !Empty(aMsg)

		//Imprime o relatorio com os erros da importa็ใo
		CtRConOut(aMsg)

	EndIf

Return 


