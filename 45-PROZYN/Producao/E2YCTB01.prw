#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
#INCLUDE "protheus.ch"

#DEFINE DATAMOVIMENTO	1
#DEFINE CTADEBITO		2
#DEFINE CTACREDITO		3
#DEFINE VALOR			4
#DEFINE HISTORICOPADRAO	5
#DEFINE COMPLEMENTO		6
#DEFINE CENTROCUSTODEB	7
#DEFINE CENTROCUSTOCRED	8
#DEFINE ITEMDEB			9
#DEFINE ITEMCRED		10
#DEFINE CLVLDEB			11
#DEFINE CLVLCRED		12


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณE2YCTB01  บAutor  ณMicrosiga           บ Data ณ  13/01/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImporta็ใo de lan็amento contabil                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function E2YCTB01()
Local aBotoes		:= {}
Local aSays		:= {}
Local nOpcao		:= 0   
Local aPerg		:= {}


//Tela de aviso e acesso aos parametros
AAdd(aSays,"[Importa็ใo de planilha]")
AAdd(aSays,"Esse programa efetuara a importa็ใo de dados  ")
AAdd(aSays,"referente os lan็amentos contabeis")


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
ฑฑบUso       ณ AP                                                        บฑฑ
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


AADD(aParamBox	,{1,"Numero do Lote"	,Space(TAMSX3("CT2_LOTE")[1])		,"@!"	,"","","",70,.T.})
AADD(aParamBox	,{1,"Sub Lote"			,"001"									,"@!"	,"","","",70,.T.})
AADD(aParamBox	,{1,"Moeda"				,"01"									,"@!"	,"","CTO","",70,.T.})
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
Local lRetImp			:= .T.
Local cLote			:= aParam[2][1]//Lote
Local cSbLote		:= aParam[2][2]//Sub lote
Local cMoedLcto		:= aParam[2][3]//Moeda
Local cArqImp 		:= aParam[2][4]//Local do Arquivo
Local aMsgErr			:= {}
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
    Else
    	++nCont
    EndIf
    
    
    
    //Inicia as variaveis com vazio
	cLinha 	:= ""
	aLinha 	:= {}
	
	cLinha   	:= FT_FReadLn()   
	aLinha		:= Separa(StrTran(cLinha,'"',""),";") //Quebra a linha em colunas de acordo com o delimitador ';'
	
	//Verifica se o arquivo esta com a quantidade de colunas correta
	If (Len(aLinha) >= 9) 
	
		//Adiciona a linha ao arquivo
		aAdd(aArquivo,aLinha )
	
	Else
		Aviso("ERROLAYOUT","Formato de arquivo inesperado, verifique se o layout estแ correto"+CRLF+;
				"Data|Cta.D้bito|Cta.Cr้dito|Valor|Hist๓rico Padrใo|Complemento|CCDB|CCCR"+" - Linha: "+Alltrim(Str(nCont-1)),{"Ok"},3)
		lRetImp := .F.
		
		Exit
		Return
	EndIf
	
	FT_FSkip()
EndDo 

If Len(aArquivo) > 0 .And. lRetImp

	If VldArq(aArquivo, @aMsgErr)	
		PrepLctoCtb(aArquivo, cLote, cSbLote, cMoedLcto)
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
ฑฑบPrograma  ณVldArq	 บAutor  ณMicrosiga           บ Data ณ  14/01/2018  	บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPre-valida็ใo do arquivo                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        	บฑฑ
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
Local cDtAux		:= ""

Default aMsgErr := {}

For nX := 1 To Len(aArquivo)
	
	cLinAux		:= "Linha: "+Alltrim(Str(nX+1))+"->"
	cMsgAux		:= ""
	
	//Valida็ใo da data
	If Empty(Alltrim(aArquivo[nX][DATAMOVIMENTO]))
		cMsgAux	+= cLinAux+"#Data nใo preenchida;"+CRLF
		lRet		:= .F.			
	ElseIf Empty(CTOD(Alltrim(aArquivo[nX][DATAMOVIMENTO])))
		cMsgAux	+= cLinAux+"#Data invแlida;"+CRLF
		lRet		:= .F.			
	EndIf

	If nX == 1 
		cDtAux		:=  Alltrim(aArquivo[nX][DATAMOVIMENTO])
	EndIf
	
	If Alltrim(cDtAux) != Alltrim(aArquivo[nX][DATAMOVIMENTO])
		cMsgAux	+= cLinAux+"#Data ("+Alltrim(aArquivo[nX][DATAMOVIMENTO])+") do lan็amento diferente da primeira linha;"+CRLF
		lRet		:= .F.			
	EndIf

	
	//Valida็ใo da conta credito e debito
	If Empty(aArquivo[nX][CTACREDITO]) .And. Empty(aArquivo[nX][CTADEBITO])
		cMsgAux	+= cLinAux+"#Conta contแbil debito e credito nใo preenchida;"+CRLF
		lRet		:= .F.	
	EndIf
	
	//Valida็ใo da conta credito
	DbSelectArea("CT1")
	DbSetOrder(1)
	If !Empty(aArquivo[nX][CTACREDITO]) .And. CT1->(!DbSeek(xFilial("CT1") + PADR(Alltrim(aArquivo[nX][CTACREDITO]), TAMSX3("CT1_CONTA")[1]) ))
		cMsgAux	+= cLinAux+"#Conta cr้dito ("+Alltrim(aArquivo[nX][CTACREDITO])+") nใo encontrada;"+CRLF
		lRet		:= .F.			
	EndIf

	//Valida็ใo da conta debito
	If !Empty(aArquivo[nX][CTADEBITO]) .And. CT1->(!DbSeek(xFilial("CT1") + PADR(Alltrim(aArquivo[nX][CTADEBITO]), TAMSX3("CT1_CONTA")[1]) ))
		cMsgAux	+= cLinAux+"#Conta debito ("+Alltrim(aArquivo[nX][CTADEBITO])+") nใo encontrada;"+CRLF
		lRet		:= .F.			
	EndIf
	
	//Valida็ใo do valor
	If NCONVVAL(aArquivo[nX][VALOR]) <= 0
		cMsgAux	+= cLinAux+"#O valor deve ser maior que zero;"+CRLF
		lRet		:= .F.			
	EndIf

	//Valida็ใo do historico
	If Empty(aArquivo[nX][HISTORICOPADRAO]) .And. Empty(aArquivo[nX][COMPLEMENTO]) 
		cMsgAux	+= cLinAux+"#Hist๓rico padrใo e complemento nใo preenchido;"+CRLF
		lRet		:= .F.			
	EndIf
	
	//Valida็ใo do historico padrao 
	If !Empty(aArquivo[nX][HISTORICOPADRAO])
		
		DbSelectArea("CT8")
		DbSetOrder(1)
		
		If CT8->(!DbSeek(xFilial("CT8") + Padr(aArquivo[nX][HISTORICOPADRAO],TAMSX3("CT8_HIST")[1]) ))
			cMsgAux	+= cLinAux+"#Hist๓rico padrใo ("+Alltrim(aArquivo[nX][HISTORICOPADRAO])+") nใo encontrado;"+CRLF
			lRet		:= .F.						
		EndIf
	
	ElseIf Empty(aArquivo[nX][COMPLEMENTO])
		cMsgAux	+= cLinAux+"#Hist๓rico complemento nใo preenchido;"+CRLF
		lRet		:= .F.											
	EndIf
	
	
	DbSelectArea("CTT")
	DbSetOrder(1)
	
	//Valida็ใo do Centro de Custo Debito
	If !Empty(aArquivo[nX][CENTROCUSTODEB])
		If CTT->(!DbSeek(xFilial("CTT") + PADR(Alltrim(aArquivo[nX][CENTROCUSTODEB]),TAMSX3("CTT_CUSTO")[1]) ))
			cMsgAux	+= cLinAux+"#Centro de Custo debito ("+Alltrim(aArquivo[nX][CENTROCUSTODEB])+") nใo encontrado;"+CRLF
			lRet		:= .F.																
		EndIf		
	EndIf


	//Valida็ใo do Centro de Custo Credito
	If !Empty(aArquivo[nX][CENTROCUSTOCRED])
		If CTT->(!DbSeek(xFilial("CTT") + PADR(Alltrim(aArquivo[nX][CENTROCUSTOCRED]),TAMSX3("CTT_CUSTO")[1]) ))
			cMsgAux	+= cLinAux+"#Centro de Custo credito ("+Alltrim(aArquivo[nX][CENTROCUSTOCRED])+") nใo encontrado;"+CRLF
			lRet		:= .F.																
		EndIf		
	EndIf             
	              
	
	DbSelectArea("CTD")
	DbSetOrdeR(1)
	
	//Valida็ใo do Item Contabil Debito
	If !Empty(aArquivo[nX][ITEMDEB])
		If CTD->(!DbSeek(xFilial("CTD") + PADR(Alltrim(aArquivo[nX][ITEMDEB]),TAMSX3("CTD_ITEM")[1]) ))
			cMsgAux	+= cLinAux+"#Item Contabil Debito("+Alltrim(aArquivo[nX][ITEMCRED])+") nใo encontrado;"+CRLF
			lRet		:= .F.																
		EndIf		
	EndIf             
	
	//Valida็ใo do Item Contabil Credito
	If !Empty(aArquivo[nX][ITEMCRED])
		If CTD->(!DbSeek(xFilial("CTD") + PADR(Alltrim(aArquivo[nX][ITEMCRED]),TAMSX3("CTD_ITEM")[1]) ))
			cMsgAux	+= cLinAux+"#Item Contabil Credito("+Alltrim(aArquivo[nX][ITEMCRED])+") nใo encontrado;"+CRLF
			lRet		:= .F.																
		EndIf		
	EndIf             
	 
	
	DbSelectArea("CTH")
	DbSetOrder(1)

	//Valida็ใo da Classe de Valor debito
	If !Empty(aArquivo[nX][CLVLDEB])
		If CTH->(!DbSeek(xFilial("CTH") + PADR(Alltrim(aArquivo[nX][CLVLDEB]),TAMSX3("CTH_CLVL")[1]) ))
			cMsgAux	+= cLinAux+"#Classe de Valor debito ("+Alltrim(aArquivo[nX][CLVLDEB])+") nใo encontrado;"+CRLF
			lRet		:= .F.																
		EndIf		
	EndIf             

	//Valida็ใo da Classe de Valor debito
	If !Empty(aArquivo[nX][CLVLCRED])
		If CTH->(!DbSeek(xFilial("CTH") + PADR(Alltrim(aArquivo[nX][CLVLCRED]),TAMSX3("CTH_CLVL")[1]) ))
			cMsgAux	+= cLinAux+"#Classe de Valor debito ("+Alltrim(aArquivo[nX][CLVLCRED])+") nใo encontrado;"+CRLF
			lRet		:= .F.																
		EndIf		
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
ฑฑบPrograma  ณPrepLctoCtb บAutor  ณMicrosiga      บ Data ณ  05/14/15      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrepara็ใo dos dados para realiza็ใo do lan็amento contแbil บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrepLctoCtb(aArquivo, cNumLote, cNumSubLot, cMoedaMov) 

Local aArea 		:= GetArea()
Local aCab 		:= {}
Local aItens  	:= {}
Local aItenAux	:= {}
Local cNumDoc		:= "000001"
Local CTF_LOCK	:= 0
Local cMsgLog		:= ""
Local nX			:= 0
Local dDtLancto	:= CTOD('')
Local nLinMov		:= 0

Default aArquivo 		:= {}
Default cNumLote		:= "" 
Default cNumSubLot	:= "" 
Default cMoedaMov		:= ""

ProcRegua(Len(aArquivo))                    

For nX := 1 To Len(aArquivo)
	
	IncProc("Contabilizando...")
	
	aItenAux 	:= {}

	//Preenchimento do cabe็alho
	If nX	== 1		
		
		dDtLancto := CTOD(aArquivo[nX][DATAMOVIMENTO])
		
		//Preenchimento do cabe็alho
		Aadd(aCab ,{"dDataLanc"	,dDtLancto		,	Nil})
		Aadd(aCab ,{"cLote"		,cNumLote		,	Nil})
		Aadd(aCab ,{"cSubLote"	,cNumSubLot	,	Nil})
					
			//Verifica o proximo documento
		ProxDoc(dDtLancto, cNumLote, cNumSubLot, @cNumDoc,@CTF_LOCK)
		Aadd(aCab ,{"cDoc"		,cNumDoc,	Nil})
	EndIf			
				
		//Preenchimento dos itens			
	++nLinMov
	Aadd(aItenAux,{"CT2_FILIAL"	,xFilial("CT2")		, NIL})
	Aadd(aItenAux,{"CT2_LINHA"	,StrZero(nLinMov,3)	, NIL})
	Aadd(aItenAux,{"CT2_MOEDLC"	,cMoedaMov				, NIL})
				
				
	If Empty(aArquivo[nX][CTACREDITO]) .And. !Empty(aArquivo[nX][CTADEBITO])//Debito
		Aadd(aItenAux,	{"CT2_DC"		, "1"														, NIL})//Tipo Movimento Debito
		Aadd(aItenAux,	{"CT2_DEBITO"	, Alltrim(aArquivo[nX][CTADEBITO])							, NIL})//Conta Debito
		Aadd(aItenAux,	{"CT2_CREDIT"	, ""														, NIL})//Conta Credito
		Aadd(aItenAux,	{"CT2_CCD"		, Alltrim(aArquivo[nX][CENTROCUSTODEB])						, NIL})//Centro de Custo Debito
		Aadd(aItenAux,	{"CT2_ITEMD"	, Alltrim(aArquivo[nX][ITEMDEB])							, NIL})//Item Debito
		Aadd(aItenAux,	{"CT2_CLVLDB"	, Alltrim(aArquivo[nX][CLVLDEB])							, NIL})//Classe de valor Debito
		Aadd(aItenAux,	{"CT2_VALOR"	, NCONVVAL(aArquivo[nX][VALOR]) 		 					, NIL})//Valor do lan็amento
	
	ElseIf !Empty(aArquivo[nX][CTACREDITO]) .And. Empty(aArquivo[nX][CTADEBITO])//Credito
		Aadd(aItenAux,	{"CT2_DC"		, "2"														, NIL})//Tipo Movimento Credito
		Aadd(aItenAux,	{"CT2_DEBITO"	, ""														, NIL})//Conta Debito
		Aadd(aItenAux,	{"CT2_CREDIT"	, Alltrim(aArquivo[nX][CTACREDITO])							, NIL})//Conta Credito
		Aadd(aItenAux,	{"CT2_CCC"		, Alltrim(aArquivo[nX][CENTROCUSTOCRED])					, NIL})//Centro de Custo Credito
		Aadd(aItenAux,	{"CT2_ITEMC"	, Alltrim(aArquivo[nX][ITEMCRED])							, NIL})//Item Credito
		Aadd(aItenAux,	{"CT2_CLVLCR"	, Alltrim(aArquivo[nX][CLVLCRED])							, NIL})//Classe de valor credito		
		Aadd(aItenAux,	{"CT2_VALOR"	, NCONVVAL(aArquivo[nX][VALOR])								, NIL})//Valor do lan็amento
	
	Else//Partida Dobrada

		Aadd(aItenAux,	{"CT2_DC"		, "3"												, NIL})//Tipo de Movimento Partida Dobrada
		Aadd(aItenAux,	{"CT2_DEBITO"	, Alltrim(aArquivo[nX][CTADEBITO])					, NIL})//Conta Debito
		Aadd(aItenAux,	{"CT2_CREDIT"	, Alltrim(aArquivo[nX][CTACREDITO])					, NIL})//Conta Credito
		Aadd(aItenAux,	{"CT2_CCD"		, Alltrim(aArquivo[nX][CENTROCUSTODEB])				, NIL})//Centro de Custo Debito
		Aadd(aItenAux,	{"CT2_CCC"		, Alltrim(aArquivo[nX][CENTROCUSTOCRED])			, NIL})//Centro de Custo Credito
		Aadd(aItenAux,	{"CT2_ITEMD"	, Alltrim(aArquivo[nX][ITEMDEB])					, NIL})//Item Debito
		Aadd(aItenAux,	{"CT2_ITEMC"	, Alltrim(aArquivo[nX][ITEMCRED])					, NIL})//Item Credito
		Aadd(aItenAux,	{"CT2_CLVLDB"	, Alltrim(aArquivo[nX][CLVLDEB])					, NIL})//Classe de valor Debito
		Aadd(aItenAux,	{"CT2_CLVLCR"	, Alltrim(aArquivo[nX][CLVLCRED])					, NIL})//Classe de valor credito			   
		Aadd(aItenAux,	{"CT2_VALOR"	, NCONVVAL(aArquivo[nX][VALOR])						, NIL})//Valor do lan็amento
	
	EndIf
				
	If !Empty(aArquivo[nX][HISTORICOPADRAO])
		Aadd(aItenAux,	{"CT2_HP"		, aArquivo[nX][HISTORICOPADRAO]	, NIL})
	Else
		Aadd(aItenAux,	{"CT2_HIST"	, aArquivo[nX][COMPLEMENTO]		, NIL})
	EndIf
	
	Aadd(aItenAux,	{"CT2_TPSALD"	, "1"		, NIL})
				
	Aadd(aItens,aItenAux)
		
		
Next

//Grava็ใo do lan็amento contabil
cMsgLog := RunMovCont(aCab, aItens, 3 )
If !Empty(cMsgLog)
	Aviso("Erro","Erro ao tentar contabilizar o documento: "+cNumDoc+CRLF+cMsgLog,{"Ok"},3)
EndIf


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
Static Function RunMovCont(aCab, aItens, nOpc )

Local aArea 	:= GetArea()
Local cRet		:= ""
Local cMsgErro	:= ""

Private lMsErroAuto := .F.

Default aCab 	:= {}
Default aItens:= {} 
Default nOpc	:= 3//Inclusใo

//Inicio da transa็ใo
Begin Transaction

//Verifica se os dados foram informados
If Len(aCab) > 0 .And. Len(aItens) > 0 
	
	//Chama a rotina automatica para gravar os dados
	MSExecAuto({|x,y,Z| Ctba102(x,y,Z)},aCab,aItens,nOpc)

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


