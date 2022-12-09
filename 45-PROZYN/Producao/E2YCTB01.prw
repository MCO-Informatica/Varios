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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �E2YCTB01  �Autor  �Microsiga           � Data �  13/01/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa��o de lan�amento contabil                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function E2YCTB01()
Local aBotoes		:= {}
Local aSays		:= {}
Local nOpcao		:= 0   
Local aPerg		:= {}


//Tela de aviso e acesso aos parametros
AAdd(aSays,"[Importa��o de planilha]")
AAdd(aSays,"Esse programa efetuara a importa��o de dados  ")
AAdd(aSays,"referente os lan�amentos contabeis")


AAdd(aBotoes,{ 5,.T.,{|| aPerg := PergFile() 		}} )
AAdd(aBotoes,{ 1,.T.,{|| nOpcao := 1, FechaBatch() 	}} )
AAdd(aBotoes,{ 2,.T.,{|| FechaBatch() 				}} )        
FormBatch( "[Importa��o]", aSays, aBotoes )

//Verifica se o parametro com o endere�o do arquivo foi preenchido
If Len(aPerg) > 0

	If aPerg[1]
		If nOpcao == 1
			Processa( {|| ImpArqPla(aPerg) },"","" )
		EndIf
	Else
		Aviso("Erro","Erro ao ler arquivo...",{"Ok"},2)
	EndIf
Else
	Aviso("Aten��o","O par�metro com o nome do arquivo n�o foi preenchido ! ",{"Ok"},2) 
EndIf

Return(Nil) 


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PergFile  �Autor  �Microsiga           � Data �  13/01/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ImpArqPla �Autor  �Microsiga           � Data �  05/14/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

    //Pula a primeira linha do arquivo (Cabe�alho)
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
		Aviso("ERROLAYOUT","Formato de arquivo inesperado, verifique se o layout est� correto"+CRLF+;
				"Data|Cta.D�bito|Cta.Cr�dito|Valor|Hist�rico Padr�o|Complemento|CCDB|CCCR"+" - Linha: "+Alltrim(Str(nCont-1)),{"Ok"},3)
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
		If Aviso("Log Erro", "Erro ao realizar a importa��o do arquivo. Deseja visualizar o log de processamento ?", {"Sim","N�o"},2) == 1
			//Log de processamento
			GetMsgErr(aMsgErr)	
		EndIf	
	EndIf
Else
	Aviso("ARQVAZIO", "N�o existe dados a serem importados", {"Ok"},2)
	lRetImp := .F.
EndIf

Return lRetImp  



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VldArq	 �Autor  �Microsiga           � Data �  14/01/2018  	���
�������������������������������������������������������������������������͹��
���Desc.     �Pre-valida��o do arquivo                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        	���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	
	//Valida��o da data
	If Empty(Alltrim(aArquivo[nX][DATAMOVIMENTO]))
		cMsgAux	+= cLinAux+"#Data n�o preenchida;"+CRLF
		lRet		:= .F.			
	ElseIf Empty(CTOD(Alltrim(aArquivo[nX][DATAMOVIMENTO])))
		cMsgAux	+= cLinAux+"#Data inv�lida;"+CRLF
		lRet		:= .F.			
	EndIf

	If nX == 1 
		cDtAux		:=  Alltrim(aArquivo[nX][DATAMOVIMENTO])
	EndIf
	
	If Alltrim(cDtAux) != Alltrim(aArquivo[nX][DATAMOVIMENTO])
		cMsgAux	+= cLinAux+"#Data ("+Alltrim(aArquivo[nX][DATAMOVIMENTO])+") do lan�amento diferente da primeira linha;"+CRLF
		lRet		:= .F.			
	EndIf

	
	//Valida��o da conta credito e debito
	If Empty(aArquivo[nX][CTACREDITO]) .And. Empty(aArquivo[nX][CTADEBITO])
		cMsgAux	+= cLinAux+"#Conta cont�bil debito e credito n�o preenchida;"+CRLF
		lRet		:= .F.	
	EndIf
	
	//Valida��o da conta credito
	DbSelectArea("CT1")
	DbSetOrder(1)
	If !Empty(aArquivo[nX][CTACREDITO]) .And. CT1->(!DbSeek(xFilial("CT1") + PADR(Alltrim(aArquivo[nX][CTACREDITO]), TAMSX3("CT1_CONTA")[1]) ))
		cMsgAux	+= cLinAux+"#Conta cr�dito ("+Alltrim(aArquivo[nX][CTACREDITO])+") n�o encontrada;"+CRLF
		lRet		:= .F.			
	EndIf

	//Valida��o da conta debito
	If !Empty(aArquivo[nX][CTADEBITO]) .And. CT1->(!DbSeek(xFilial("CT1") + PADR(Alltrim(aArquivo[nX][CTADEBITO]), TAMSX3("CT1_CONTA")[1]) ))
		cMsgAux	+= cLinAux+"#Conta debito ("+Alltrim(aArquivo[nX][CTADEBITO])+") n�o encontrada;"+CRLF
		lRet		:= .F.			
	EndIf
	
	//Valida��o do valor
	If NCONVVAL(aArquivo[nX][VALOR]) <= 0
		cMsgAux	+= cLinAux+"#O valor deve ser maior que zero;"+CRLF
		lRet		:= .F.			
	EndIf

	//Valida��o do historico
	If Empty(aArquivo[nX][HISTORICOPADRAO]) .And. Empty(aArquivo[nX][COMPLEMENTO]) 
		cMsgAux	+= cLinAux+"#Hist�rico padr�o e complemento n�o preenchido;"+CRLF
		lRet		:= .F.			
	EndIf
	
	//Valida��o do historico padrao 
	If !Empty(aArquivo[nX][HISTORICOPADRAO])
		
		DbSelectArea("CT8")
		DbSetOrder(1)
		
		If CT8->(!DbSeek(xFilial("CT8") + Padr(aArquivo[nX][HISTORICOPADRAO],TAMSX3("CT8_HIST")[1]) ))
			cMsgAux	+= cLinAux+"#Hist�rico padr�o ("+Alltrim(aArquivo[nX][HISTORICOPADRAO])+") n�o encontrado;"+CRLF
			lRet		:= .F.						
		EndIf
	
	ElseIf Empty(aArquivo[nX][COMPLEMENTO])
		cMsgAux	+= cLinAux+"#Hist�rico complemento n�o preenchido;"+CRLF
		lRet		:= .F.											
	EndIf
	
	
	DbSelectArea("CTT")
	DbSetOrder(1)
	
	//Valida��o do Centro de Custo Debito
	If !Empty(aArquivo[nX][CENTROCUSTODEB])
		If CTT->(!DbSeek(xFilial("CTT") + PADR(Alltrim(aArquivo[nX][CENTROCUSTODEB]),TAMSX3("CTT_CUSTO")[1]) ))
			cMsgAux	+= cLinAux+"#Centro de Custo debito ("+Alltrim(aArquivo[nX][CENTROCUSTODEB])+") n�o encontrado;"+CRLF
			lRet		:= .F.																
		EndIf		
	EndIf


	//Valida��o do Centro de Custo Credito
	If !Empty(aArquivo[nX][CENTROCUSTOCRED])
		If CTT->(!DbSeek(xFilial("CTT") + PADR(Alltrim(aArquivo[nX][CENTROCUSTOCRED]),TAMSX3("CTT_CUSTO")[1]) ))
			cMsgAux	+= cLinAux+"#Centro de Custo credito ("+Alltrim(aArquivo[nX][CENTROCUSTOCRED])+") n�o encontrado;"+CRLF
			lRet		:= .F.																
		EndIf		
	EndIf             
	              
	
	DbSelectArea("CTD")
	DbSetOrdeR(1)
	
	//Valida��o do Item Contabil Debito
	If !Empty(aArquivo[nX][ITEMDEB])
		If CTD->(!DbSeek(xFilial("CTD") + PADR(Alltrim(aArquivo[nX][ITEMDEB]),TAMSX3("CTD_ITEM")[1]) ))
			cMsgAux	+= cLinAux+"#Item Contabil Debito("+Alltrim(aArquivo[nX][ITEMCRED])+") n�o encontrado;"+CRLF
			lRet		:= .F.																
		EndIf		
	EndIf             
	
	//Valida��o do Item Contabil Credito
	If !Empty(aArquivo[nX][ITEMCRED])
		If CTD->(!DbSeek(xFilial("CTD") + PADR(Alltrim(aArquivo[nX][ITEMCRED]),TAMSX3("CTD_ITEM")[1]) ))
			cMsgAux	+= cLinAux+"#Item Contabil Credito("+Alltrim(aArquivo[nX][ITEMCRED])+") n�o encontrado;"+CRLF
			lRet		:= .F.																
		EndIf		
	EndIf             
	 
	
	DbSelectArea("CTH")
	DbSetOrder(1)

	//Valida��o da Classe de Valor debito
	If !Empty(aArquivo[nX][CLVLDEB])
		If CTH->(!DbSeek(xFilial("CTH") + PADR(Alltrim(aArquivo[nX][CLVLDEB]),TAMSX3("CTH_CLVL")[1]) ))
			cMsgAux	+= cLinAux+"#Classe de Valor debito ("+Alltrim(aArquivo[nX][CLVLDEB])+") n�o encontrado;"+CRLF
			lRet		:= .F.																
		EndIf		
	EndIf             

	//Valida��o da Classe de Valor debito
	If !Empty(aArquivo[nX][CLVLCRED])
		If CTH->(!DbSeek(xFilial("CTH") + PADR(Alltrim(aArquivo[nX][CLVLCRED]),TAMSX3("CTH_CLVL")[1]) ))
			cMsgAux	+= cLinAux+"#Classe de Valor debito ("+Alltrim(aArquivo[nX][CLVLCRED])+") n�o encontrado;"+CRLF
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PrepLctoCtb �Autor  �Microsiga      � Data �  05/14/15      ���
�������������������������������������������������������������������������͹��
���Desc.     �Prepara��o dos dados para realiza��o do lan�amento cont�bil ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

	//Preenchimento do cabe�alho
	If nX	== 1		
		
		dDtLancto := CTOD(aArquivo[nX][DATAMOVIMENTO])
		
		//Preenchimento do cabe�alho
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
		Aadd(aItenAux,	{"CT2_VALOR"	, NCONVVAL(aArquivo[nX][VALOR]) 		 					, NIL})//Valor do lan�amento
	
	ElseIf !Empty(aArquivo[nX][CTACREDITO]) .And. Empty(aArquivo[nX][CTADEBITO])//Credito
		Aadd(aItenAux,	{"CT2_DC"		, "2"														, NIL})//Tipo Movimento Credito
		Aadd(aItenAux,	{"CT2_DEBITO"	, ""														, NIL})//Conta Debito
		Aadd(aItenAux,	{"CT2_CREDIT"	, Alltrim(aArquivo[nX][CTACREDITO])							, NIL})//Conta Credito
		Aadd(aItenAux,	{"CT2_CCC"		, Alltrim(aArquivo[nX][CENTROCUSTOCRED])					, NIL})//Centro de Custo Credito
		Aadd(aItenAux,	{"CT2_ITEMC"	, Alltrim(aArquivo[nX][ITEMCRED])							, NIL})//Item Credito
		Aadd(aItenAux,	{"CT2_CLVLCR"	, Alltrim(aArquivo[nX][CLVLCRED])							, NIL})//Classe de valor credito		
		Aadd(aItenAux,	{"CT2_VALOR"	, NCONVVAL(aArquivo[nX][VALOR])								, NIL})//Valor do lan�amento
	
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
		Aadd(aItenAux,	{"CT2_VALOR"	, NCONVVAL(aArquivo[nX][VALOR])						, NIL})//Valor do lan�amento
	
	EndIf
				
	If !Empty(aArquivo[nX][HISTORICOPADRAO])
		Aadd(aItenAux,	{"CT2_HP"		, aArquivo[nX][HISTORICOPADRAO]	, NIL})
	Else
		Aadd(aItenAux,	{"CT2_HIST"	, aArquivo[nX][COMPLEMENTO]		, NIL})
	EndIf
	
	Aadd(aItenAux,	{"CT2_TPSALD"	, "1"		, NIL})
				
	Aadd(aItens,aItenAux)
		
		
Next

//Grava��o do lan�amento contabil
cMsgLog := RunMovCont(aCab, aItens, 3 )
If !Empty(cMsgLog)
	Aviso("Erro","Erro ao tentar contabilizar o documento: "+cNumDoc+CRLF+cMsgLog,{"Ok"},3)
EndIf


RestArea(aArea)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RunMovCont�Autor  �Microsiga           � Data �  14/01/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �Executa a gera��o do movimento contabil atraves de rotina   ���
���          �automatica                                                  ���
�������������������������������������������������������������������������͹��
���Uso       � 				                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RunMovCont(aCab, aItens, nOpc )

Local aArea 	:= GetArea()
Local cRet		:= ""
Local cMsgErro	:= ""

Private lMsErroAuto := .F.

Default aCab 	:= {}
Default aItens:= {} 
Default nOpc	:= 3//Inclus�o

//Inicio da transa��o
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
		
		//Rollback da transa��o
		DisarmTransaction()
		
	EndIf
	
Else
	cRet := "Dados n�o informados"
EndIf

//Finalisa a transa��o
End Transaction

RestArea(aArea)
Return cRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NCONVVAL �Autor  �Microsiga      		 � Data �  14/01/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GetMsgErr	�Autor  �Microsiga			� Data �  05/11/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o utilizada para apresentar as mensagens de log        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �			                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetMsgErr(aMsg)

Default aMsg := {}


If !Empty(aMsg)

    //Imprime o relatorio com os erros da importa��o
	CtRConOut(aMsg)

EndIf

Return 


