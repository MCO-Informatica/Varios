#Include "Ctbr040.Ch"
#Include "PROTHEUS.Ch"       

#DEFINE 	COL_SEPARA1			1
#DEFINE 	COL_CONTA 			2
#DEFINE 	COL_SEPARA2			3
#DEFINE 	COL_DESCRICAO		4
#DEFINE 	COL_SEPARA3			5
#DEFINE 	COL_SALDO_ANT    	6
#DEFINE 	COL_SEPARA4			7
#DEFINE 	COL_VLR_DEBITO   	8
#DEFINE 	COL_SEPARA5			9 
#DEFINE 	COL_VLR_CREDITO  	10
#DEFINE 	COL_SEPARA6			11
#DEFINE 	COL_MOVIMENTO 		12
#DEFINE 	COL_SEPARA7			13                                                                                       
#DEFINE 	COL_SALDO_ATU 		14
#DEFINE 	COL_SEPARA8			15   
#DEFINE 	TAM_VALOR			20   

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � Ctbr040	� Autor � Pilar S Albaladejo	� Data � 12.09.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Balancete Analitico Sintetico Modelo 1			 		  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Ctbr040()                               			 		  ���
�������������������������������������������������������������������������Ĵ��
���Retorno	 � Nenhum       											  ���
�������������������������������������������������������������������������Ĵ��
���Uso    	 � Generico     											  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function LS_Ctbr040()

Local lImpBalR4		:= FindFunction( "TRepInUse" ) .And. TRepInUse()

Private titulo		:= ""
Private nomeprog	:= "CTBR040" 

Conout("*** La Selva - User Function LS_CTBR040 - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

CtAjustSx1('CTR040')    

If lImpBalR4
	CTBR040R4()
Else
	CTBR040R3()
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � CTBR040R4 � Autor� Daniel Sakavicius		� Data � 01/08/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Balancete Analitico Sintetico Modelo 1 - R4                ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � CTBR040R4												  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � SIGACTB                                    				  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function CTBR040R4()

Local nQuadro

//������������������������������������������������������������������������Ŀ
//�Interface de impressao                                                  �
//��������������������������������������������������������������������������

Private aQuadro 	:= { "","","","","","","",""}              
Private aSelFil		:= {} 

Conout("*** La Selva - Static Function CTBR040R4 - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

For nQuadro :=1 To Len(aQuadro)
	aQuadro[nQuadro] := Space(Len(CriaVar("CT1_CONTA")))
Next	

CtbCarTxt()

Pergunte("CTR040",.F.)

oReport := ReportDef()

If Valtype( oReport ) == 'O'
	If ! Empty( oReport:uParam )
		Pergunte( oReport:uParam, .F. )
	EndIf	
	
	oReport:PrintDialog()      
Endif
	
oReport := Nil

Return                                

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor � Daniel Sakavicius		� Data � 28/07/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Esta funcao tem como objetivo definir as secoes, celulas,   ���
���          �totalizadores do relatorio que poderao ser configurados     ���
���          �pelo relatorio.                                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � SIGACTB                                    				  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

local aArea	   		:= GetArea()   
Local CREPORT		:= "CTBR040"
Local CTITULO		:= STR0006				   			// "Emissao do Relat. Conf. Dig. "
Local CDESC			:= OemToAnsi(STR0001)+OemToAnsi(STR0002)+OemToAnsi(STR0003)			// "Este programa ira imprimir o Relatorio para Conferencia"
Local cPerg	   		:= "CTR040" 
Local CCOLBAR		:= "|"                   
Local aTamConta		:= TAMSX3("CT1_CONTA")    
Local aTamVal		:= TAMSX3("CT2_VALOR")
Local aTamDesc		:= {40}  
Local cPictVal 		:= PesqPict("CT2","CT2_VALOR")
Local nDecimais
Local cMascara		:= ""
Local cSeparador	:= ""
Local nTamConta		:= 20
Local aSetOfBook
Local nMaskFator 	:= 1 

Conout("*** La Selva - Static Function REPORTDEF - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

// Efetua a pergunta antes de montar a configura��o do relatorio, afim de poder definir o layout a ser impresso
Pergunte( "CTR040" , .T. )


//���������������������������������������������Ŀ
//�Tatiane alterou a parte comentada do programa�
//�n�o sei quem comentou anteriormente          �
//�Rejane pediu para aterar                     �
//�14/04/2016                                   �
//�����������������������������������������������

/*
If mv_par30 == 1 .And. Len( aSelFil ) <= 0  .And. !IsBlind()
	aSelFil := AdmGetFil()
	If Len( aSelFil ) <= 0
		Return
	EndIf 
EndIf
*/
aSelFil := U_LS_SelFil()

If Len( aSelFil ) <= 0
	Return
EndIf
	

//��������������������������������������������������������������Ŀ
//� Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano�
//� Gerencial -> montagem especifica para impressao)	    	  �
//����������������������������������������������������������������
If ! ct040Valid( mv_par06 )
	Return .F.
Else
   aSetOfBook := CTBSetOf( mv_par06 )
Endif

cMascara := RetMasCtb( aSetOfBook[2], @cSeparador )

If ! Empty( cMascara )
	nTamConta := aTamConta[1] + ( Len( Alltrim( cMascara ) ) / 2 )
Else
	nTamConta := aTamConta[1]
EndIf

cPicture := aSetOfBook[4]

//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//��������������������������������������������������������������������������

//"Este programa tem o objetivo de emitir o Cadastro de Itens Classe de Valor "
//"Sera impresso de acordo com os parametros solicitados pelo"
//"usuario"
oReport	:= TReport():New( cReport,Capital(CTITULO),cPerg, { |oReport| Pergunte(cPerg , .F. ), If(! ReportPrint( oReport ), oReport:CancelPrint(), .T. ) }, CDESC ) 
oReport:ParamReadOnly()

IF GETNEWPAR("MV_CTBPOFF",.T.)
	oReport:SetEdit(.F.)
ENDIF	

//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da se�ao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a se��o.                   �
//�ExpA4 : Array com as Ordens do relat�rio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
oSection1  := TRSection():New( oReport, STR0027, {"cArqTmp","CT1"},, .F., .F.,,,,,,,,,0 ) //"Plano de contas"

TRCell():New( oSection1, "CONTA"	,,STR0028/*Titulo*/	,/*Picture*/, nTamConta /*Tamanho*/, /*lPixel*/, /*CodeBlock*/, /*"LEFT"*/,,/*"LEFT"*/,,,.F.)
TRCell():New( oSection1, "DESCCTA"  ,,STR0029/*Titulo*/	,/*Picture*/, aTamDesc[1]/*Tamanho*/, /*lPixel*/,/*CodeBlock*/,  /*"LEFT"*/,.T.,/*"LEFT"*/,,,.F.)
TRCell():New( oSection1, "SALDOANT" ,,STR0030/*Titulo*/	,/*Picture*/, TAM_VALOR+2 /*Tamanho*/, /*lPixel*/, /*CodeBlock*/, /*"RIGHT"*/,,"RIGHT",,,.F.)
TRCell():New( oSection1, "SALDODEB" ,,STR0031/*Titulo*/	,/*Picture*/, TAM_VALOR+2 /*Tamanho*/, /*lPixel*/, /*CodeBlock*/, /*"RIGHT"*/,,"RIGHT",,,.F.)
TRCell():New( oSection1, "SALDOCRD" ,,STR0032/*Titulo*/	,/*Picture*/, TAM_VALOR+2 /*Tamanho*/, /*lPixel*/, /*CodeBlock*/, /*"RIGHT"*/,,"RIGHT",,,.F.)
TRCell():New( oSection1, "MOVIMENTO",,STR0033/*Titulo*/	,/*Picture*/, TAM_VALOR+2 /*Tamanho*/, /*lPixel*/, /*CodeBlock*/, /*"RIGHT"*/,,"RIGHT",,,.F.)
TRCell():New( oSection1, "SALDOATU" ,,STR0034/*Titulo*/	,/*Picture*/, TAM_VALOR+2 /*Tamanho*/, /*lPixel*/, /*CodeBlock*/, /*"RIGHT"*/,,"RIGHT",,,.F.)
                                                                                 
TRPosition():New( oSection1, "CT1", 1, {|| xFilial( "CT1" ) + cArqTMP->CONTA })

oSection1:Cell("CONTA"):lHeaderSize		:= .F.
oSection1:Cell("DESCCTA"):lHeaderSize	:= .F.
oSection1:Cell("SALDOANT"):lHeaderSize	:= .F.
oSection1:Cell("SALDODEB"):lHeaderSize	:= .F.
oSection1:Cell("SALDOCRD"):lHeaderSize	:= .F.
oSection1:Cell("MOVIMENTO"):lHeaderSize	:= .F.
oSection1:Cell("SALDOATU"):lHeaderSize	:= .F.  

oSection1:SetTotalInLine(.F.)          
oSection1:SetTotalText('') //STR0011) //"T O T A I S  D O  P E R I O D O: "
oSection1:SetEdit(.F.)

Return( oReport )

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint� Autor � Daniel Sakavicius	� Data � 28/07/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Imprime o relatorio definido pelo usuario de acordo com as  ���
���          �secoes/celulas criadas na funcao ReportDef definida acima.  ���
���          �Nesta funcao deve ser criada a query das secoes se SQL ou   ���
���          �definido o relacionamento e filtros das tabelas em CodeBase.���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ReportPrint(oReport)                                       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �EXPO1: Objeto do relat�rio                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ReportPrint( oReport )  

Local oSection1 	:= oReport:Section(1) 
Local lExterno		:= .F.   
Local aSetOfBook
Local dDataFim 		:= mv_par02
Local lFirstPage	:= .T.
Local lJaPulou		:= .F.
Local lRet			:= .T.
Local lPrintZero	:= (mv_par18==1)
Local lPula			:= (mv_par17==1) 
Local lNormal		:= (mv_par19==1)
Local lVlrZerado	:= (mv_par07==1)
Local lQbGrupo		:= (mv_par11==1) 
Local lQbConta		:= (mv_par11==2)
Local l132			:= .T.
Local nDecimais
Local nDivide		:= 1
Local nTotDeb		:= 0
Local nTotCrd		:= 0
Local nTotMov		:= 0
Local nGrpDeb		:= 0
Local nGrpCrd		:= 0                     
Local cSegAte   	:= mv_par21
Local nDigitAte		:= 0
Local lImpAntLP		:= (mv_par22 == 1)
Local dDataLP		:= mv_par23
Local lImpSint		:= Iif(mv_par05=1 .Or. mv_par05 ==3,.T.,.F.)
Local lRecDesp0		:= (mv_par25 == 1)
Local lImpMov		:= (mv_par16 == 1)
Local cRecDesp		:= mv_par26
Local dDtZeraRD		:= mv_par27
Local n
Local oMeter
Local oText
Local oDlg
Local oBreak
Local lImpPaisgm	:= .F.	
Local nMaxLin   	:= mv_par28
Local cMoedaDsc		:= mv_par29
Local aCtbMoeda		:= {}
Local aCtbMoedadsc	:= {}
Local CCOLBAR		:= "|"                   
Local cTipoAnt		:= ""
Local cGrupoAnt		:= ""
Local cArqTmp		:= ""
Local Tamanho		:= "M"
Local cSeparador	:= ""
Local aTamVal		:= TAMSX3("CT2_VALOR")
Local oTotGerDeb		
Local oTotGerCrd 
Local oTotGerMov
Local oTotGrpMov
Local cPicture
Local cContaSint
Local cBreak		:= "2"
Local cGrupo		:= ""
Local nTotGerDeb	:= 0
Local nTotGerCrd	:= 0
Local nTotGerMov	:= 0
Local nCont			:= 0
Local cFilUser		:= ""
Local nMasc			:= 0
Local cMasc			:= ""  
Local lEnd

Private nLinReport	:= 9

Conout("*** La Selva - Static Function REPORTPRINT - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

If oReport:nDevice == 5 .OR. oReport:nDevice == 3 
	oSection1:Cell("SALDOANT"):SetAlign("RIGHT")  
	oSection1:Cell("SALDODEB"):SetAlign("RIGHT")
	oSection1:Cell("SALDOCRD"):SetAlign("RIGHT")
	oSection1:Cell("MOVIMENTO"):SetAlign("RIGHT")  
	oSection1:Cell("SALDOATU"):SetAlign("RIGHT")     
Endif 


//��������������������������������������������������������������Ŀ
//� Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano�
//� Gerencial -> montagem especifica para impressao)	    	  �
//����������������������������������������������������������������
If ! ct040Valid( mv_par06 )
	Return .F.
Else
   aSetOfBook := CTBSetOf(mv_par06)
Endif

If mv_par20 == 2			// Divide por cem
	nDivide := 100
ElseIf mv_par20 == 3		// Divide por mil
	nDivide := 1000
ElseIf mv_par20 == 4		// Divide por milhao
	nDivide := 1000000
EndIf	     

If lRet
	aCtbMoeda := CtbMoeda( mv_par08 , nDivide )

	If Empty(aCtbMoeda[1])                       
		Help(" ",1,"NOMOEDA")
		lRet := .F.
		Return lRet
	Endif

    // valida��o da descri��o da moeda
	if lRet .And. ! Empty( mv_par29 ) .and. mv_par29 <> nil
		aCtbMoedadsc := CtbMoeda( mv_par29 , nDivide )

		If Empty( aCtbMoedadsc[1] )                       
    		Help( " " , 1 , "NOMOEDA")
	        lRet := .F.
    	    Return lRet
	    Endif
	Endif
Endif

If lRet
	If (mv_par25 == 1) .and. ( Empty(mv_par26) .or. Empty(mv_par27) )
		cMensagem	:= STR0025	//"Favor preencher os parametros Grupos Receitas/Despesas e "
		cMensagem	+= STR0026	//"Data Sld Ant. Receitas/Desp. "
		MsgAlert(cMensagem,STR0035)	 //"Ignora Sl Ant.Rec/Des"
		lRet    	:= .F.	
	    Return lRet
    EndIf
EndIf

aCtbMoeda  	:= CtbMoeda(mv_par08,nDivide)                

cDescMoeda 	:= Alltrim(aCtbMoeda[2])
nDecimais 	:= DecimalCTB(aSetOfBook,mv_par08)

If Empty(aSetOfBook[2])
	cMascara := GetMv("MV_MASCARA")
Else
	cMascara 	:= RetMasCtb(aSetOfBook[2],@cSeparador)
EndIf
cPicture 		:= aSetOfBook[4]

lPrintZero	:= Iif(mv_par18==1,.T.,.F.)

If oReport:Title() == oReport:cRealTitle
	IF mv_par05 == 1
		Titulo:=	OemToAnsi(STR0009)	//"BALANCETE DE VERIFICACAO SINTETICO DE "
	ElseIf mv_par05 == 2
		Titulo:=	OemToAnsi(STR0006)	//"BALANCETE DE VERIFICACAO ANALITICO DE "
	ElseIf mv_par05 == 3
		Titulo:=	OemToAnsi(STR0017)	//"BALANCETE DE VERIFICACAO DE "
	EndIf
	Titulo += 	DTOC(mv_par01) + OemToAnsi(STR0007) + Dtoc(mv_par02) + ;
			OemToAnsi(STR0008) + cDescMoeda + CtbTitSaldo(mv_par10)           
Else
	Titulo := oReport:Title()
Endif

oReport:SetPageNumber( mv_par09 )
oReport:SetCustomText( {|| nCtCGCCabTR(dDataFim,titulo,oReport)})  


cFilUser := oSection1:GetAdvplExpr("CT1")    
If Empty(cFilUser)
	cFilUser := ".T."
EndIf	

//��������������������������������������������������������������Ŀ
//� Monta Arquivo Temporario para Impressao			  		     �
//����������������������������������������������������������������
            


If lExterno  .or. IsBlind()
	CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
				mv_par01,mv_par02,"CT7","",mv_par03,mv_par04,,,,,,,mv_par08,;
				mv_par10,aSetOfBook,mv_par12,mv_par13,mv_par14,mv_par15,;
				.F.,.F.,mv_par11,,lImpAntLP,dDataLP,nDivide,lVlrZerado,,,,,,,,,,,,,,lImpSint,cFilUser,lRecDesp0,;
				cRecDesp,dDtZeraRD,,,,,,,cMoedaDsc,,aSelFil) 
				
Else
	MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
					CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
					mv_par01,mv_par02,"CT7","",mv_par03,mv_par04,,,,,,,mv_par08,;
					mv_par10,aSetOfBook,mv_par12,mv_par13,mv_par14,mv_par15,;
					.F.,.F.,mv_par11,,lImpAntLP,dDataLP,nDivide,lVlrZerado,,,,,,,,,,,,,,lImpSint,cFilUser,lRecDesp0,;
					cRecDesp,dDtZeraRD,,,,,,,cMoedaDsc,,aSelFil)},;
					OemToAnsi(OemToAnsi(STR0015)),;  //"Criando Arquivo Tempor�rio..."
					OemToAnsi(STR0003))  				//"Balancete Verificacao"
EndIf                                                          
                
nCount := cArqTmp->(RecCount())

oReport:SetMeter(nCont)

lRet := !(nCount == 0 .And. !Empty(aSetOfBook[5]))

If lRet
	      
	// Verifica Se existe filtragem Ate o Segmento
  	If ! Empty( cSegAte )
		
		//Efetua tratamento da mascara para consegui efetuar o controle do segmento 
		For nMasc := 1 to Len( cMascara )
			
			cMasc += SubStr( cMascara,nMasc,1 )
			
		Next nMasc
	
	
		nDigitAte := CtbRelDig( cSegAte, cMasc ) 	

		oSection1:SetFilter( 'Len(Alltrim(cArqTmp->CONTA)) <= ' + alltrim( Str( nDigitAte )) )  
	EndIf	 

	cArqTmp->(dbGoTop())
	
	If lNormal
		oSection1:Cell("CONTA"):SetBlock( {|| EntidadeCTB(cArqTmp->CONTA,000,000,030,.F.,cMascara,cSeparador,,,.F.,,.F.)} )
	Else
		oSection1:Cell("CONTA"):SetBlock( {|| cArqTmp->CTARES } )
	EndIf	
	
	oSection1:Cell("DESCCTA"):SetBlock( { || cArqTMp->DESCCTA } )
	
  	oSection1:Cell("SALDOANT"):SetBlock( { || ValorCTB(cArqTmp->SALDOANT,,,TAM_VALOR-2,nDecimais,.T.,cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.) } )
  	oSection1:Cell("SALDODEB"):SetBlock( { || ValorCTB(cArqTmp->SALDODEB,,,TAM_VALOR,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) } )
  	oSection1:Cell("SALDOCRD"):SetBlock( { || ValorCTB(cArqTmp->SALDOCRD,,,TAM_VALOR,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) } )
    oSection1:Cell("SALDOATU"):SetBlock( { || ValorCTB(cArqTmp->SALDOATU,,,TAM_VALOR-2,nDecimais,.T.,cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.) } )

//	 Imprime Movimento
  	If !lImpMov   
  		oSection1:Cell("MOVIMENTO"):SetSize(0)
 		oSection1:Cell("MOVIMENTO"):Disable()
 	Else	
 		oSection1:Cell("MOVIMENTO"):SetBlock( { || ValorCTB(cArqTmp->MOVIMENTO,,,TAM_VALOR-2,nDecimais,.T.,cPicture,cArqTmp->NORMAL,,,,,, lPrintZero,.F.) } )
 	EndIf

	If lQbGrupo

		//*********************************
		// Total por Grupo do relatorio   *
		//*********************************
	
		oBrkGrupo := TRBreak():New(oSection1, { || cArqTmp->GRUPO },{|| STR0020+" "+ RTrim( Upper(AllTrim(cGrupo) )) + " )" },,,.T.)	//	" T O T A I S "
	  	oBrkGrupo:OnBreak( { |x| cGrupo := x, If(cArqTmp->(Eof()),oBrkGrupo:lPageBreak := .F.,.T.)} )
	
		oTotGrpDeb := TRFunction():New(oSection1:Cell("SALDODEB"),,"SUM",oBrkGrupo/*oBreak*/,/*Titulo*/,/*cPicture*/,;
			{ || Iif(cArqTmp->TIPOCONTA="1",0,cArqTmp->SALDODEB) },.F.,.F.,.F.,oSection1)
		oTotGrpDeb:Disable()		
				
		oTotGrpCrd := TRFunction():New(oSection1:Cell("SALDOCRD"),,"SUM",oBrkGrupo/*oBreak*/,/*Titulo*/,/*cPicture*/,;
			{ || Iif(cArqTmp->TIPOCONTA="1",0,cArqTmp->SALDOCRD) },.F.,.F.,.F.,oSection1)
		oTotGrpCrd:Disable() 
		
		TRFunction():New(oSection1:Cell("SALDODEB"),,"ONPRINT",oBrkGrupo/*oBreak*/,/*Titulo*/,/*cPicture*/,;
			{ || ValorCTB(oTotGrpDeb:GetValue(),,,TAM_VALOR,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1 )

		TRFunction():New(oSection1:Cell("SALDOCRD"),,"ONPRINT",oBrkGrupo/*oBreak*/,/*Titulo*/,/*cPicture*/,;
			{ || ValorCTB(oTotGrpCrd:GetValue(),,,TAM_VALOR,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1 )
                                                             
	 	If !lImpMov   
	 	
	 	 	oTotGrpMov := TRFunction():New(oSection1:Cell("MOVIMENTO"),,"SUM", oBrkGrupo,/*Titulo*/,/*cPicture*/,;
			{ || Iif(cArqTmp->TIPOCONTA="1",0,(cArqTmp->SALDOCRD - cArqTmp->SALDODEB)) },.F.,.F.,.F.,oSection1)
		   	oTotGrpMov:Disable()  
   	  
	 		TRFunction():New(oSection1:Cell("MOVIMENTO"),,"ONPRINT",oBrkGrupo/*oBreak*/,/*Titulo*/,/*cPicture*/,;
 			{ || ValorCTB(oTotGrpMov:GetValue(),,,TAM_VALOR-2,nDecimais,.T.,cPicture,If(Round(NoRound(oTotGrpMov:GetValue(),3),2) < 0, "1","2"),,,,,,lPrintZero,.F.)},.F.,.F.,.F.,oSection1) 
 			
		Endif
		
	EndIf

	//******************************
	// Total Geral do relatorio    *
	//******************************
	oBrkGeral := TRBreak():New(oSection1, { || cArqTmp->(!Eof()) },{|| STR0011 },,,.F.)	//	" T O T A I S "

	// Totaliza
	oTotGerDeb := TRFunction():New(oSection1:Cell("SALDODEB"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
		{ || Iif(cArqTmp->TIPOCONTA="1",0,cArqTmp->SALDODEB) },.F.,.F.,.F.,oSection1)
   	oTotGerDeb:Disable()

	oTotGerCrd := TRFunction():New(oSection1:Cell("SALDOCRD"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
		{ || Iif(cArqTmp->TIPOCONTA="1",0,cArqTmp->SALDOCRD) },.F.,.F.,.F.,oSection1)
   	oTotGerCrd:Disable()     

                    
    TRFunction():New(oSection1:Cell("SALDODEB"),,"ONPRINT",oBrkGeral/*oBreak*/,/*Titulo*/,/*cPicture*/,;
  		{ || ValorCTB(oTotGerDeb:GetValue(),,,TAM_VALOR,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1)
	                    
	
 	TRFunction():New(oSection1:Cell("SALDOCRD"),,"ONPRINT",oBrkGeral/*oBreak*/,/*Titulo*/,/*cPicture*/,;
 		{ || ValorCTB(oTotGerCrd:GetValue(),,,TAM_VALOR,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.)},.F.,.F.,.F.,oSection1) 


 	If lImpMov  
 	
	 	oTotGerMov := TRFunction():New(oSection1:Cell("MOVIMENTO"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
			{ || Iif(cArqTmp->TIPOCONTA="1",0,(cArqTmp->SALDOCRD - cArqTmp->SALDODEB)) },.F.,.F.,.F.,oSection1)
	   	oTotGerMov:Disable()  
   	  
 		TRFunction():New(oSection1:Cell("MOVIMENTO"),,"ONPRINT",oBrkGeral/*oBreak*/,/*Titulo*/,/*cPicture*/,;
 		{ || ValorCTB(oTotGerMov:GetValue(),,,TAM_VALOR-2,nDecimais,.T.,cPicture,If(Round(NoRound(oTotGerMov:GetValue(),3),2) < 0, "1","2"),,,,,,lPrintZero,.F.)},.F.,.F.,.F.,oSection1) 
 		
    Endif

	oSection1:OnPrintLine( {|| 	CTR040OnPrint( lPula, lQbConta, nMaxLin, @cTipoAnt, @nLinReport, @cGrupoAnt ) } )
           
	oSection1:Print()

	If mv_par24 ==1     
	    oReport:Section(1):SetHeaderSection(.F.)                                                       
		ImpQuadro(Tamanho,X3USO("CT2_DCD"),dDataFim,mv_par08,aQuadro,cDescMoeda,oReport:ClassName(),(If (lImpAntLP,dDataLP,cTod(""))),cPicture,nDecimais,lPrintZero,mv_par10,oReport)
	EndIf	

EndIf     

dbSelectArea("cArqTmp")
Set Filter To
dbCloseArea()
If Select("cArqTmp") == 0
	FErase(cArqTmp+GetDBExtension())
	FErase(cArqTmp+OrdBagExt())
EndIF	

Return .T.

  
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTR040OnPrint �Autor � Gustavo Henrique � Data � 07/02/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Executa acoes especificadas nos parametros do relatorio,   ���
���          � antes de imprimir cada linha.                              ���
�������������������������������������������������������������������������͹��
���Parametros� EXPL1 - Indicar se deve saltar linha entre conta sintetica ���
���          � EXPL2 - Indicar se deve quebrar pagina por conta           ���
���          � EXPN3 - Informar o total de linhas por pagina do balancete ���
���          � EXPC4 - Guardar o tipo da conta impressa (sint./analitica) ���
���          � EXPN5 - Guardar linha atual do relatorio para validacao    ���
���          �         com o valor do parametro EXPN3.                    ���
�������������������������������������������������������������������������͹��
���Retorno   � EXPL1 - Indicar se deve imprimir a linha (.T.)             ���
�������������������������������������������������������������������������͹��
���Uso       � Contabilidade Gerencial                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CTR040OnPrint( lPula, lQbConta, nMaxLin, cTipoAnt, nLinReport )

Local lRet := .T.           

Conout("*** La Selva - Static Function CTR040ONPRINT - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

// Verifica salto de linha para conta sintetica (mv_par17)
If lPula .And. (cTipoAnt == "1" .Or. (cArqTmp->TIPOCONTA == "1" .And. cTipoAnt == "2"))
	oReport:SkipLine()
EndIf	

// Verifica quebra de pagina por conta (mv_par11)
If lQbConta .And. cArqTmp->NIVEL1
	oReport:EndPage()
	nLinReport := 9
	Return
EndIf	

// Verifica numero maximo de linhas por pagina (mv_par28)
If ! Empty(nMaxLin)
	CTR040MaxL(nMaxLin,@nLinReport)
EndIf	

cTipoAnt := cArqTmp->TIPOCONTA

If mv_par05 == 1		// Apenas sinteticas
	lRet := (cArqTmp->TIPOCONTA == "1")
ElseIf mv_par05 == 2	// Apenas analiticas
	lRet := (cArqTmp->TIPOCONTA == "2")
EndIf

Return lRet


/*
------------------------------------------------------------------------- RELEASE 3 -------------------------------------------------------------------------------
*/



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � Ctbr040R3� Autor � Pilar S Albaladejo	� Data � 12.09.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Balancete Analitico Sintetico Modelo 1			 		  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Ctbr040()                               			 		  ���
�������������������������������������������������������������������������Ĵ��
���Retorno	 � Nenhum       											  ���
�������������������������������������������������������������������������Ĵ��
���Uso    	 � Generico     											  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function CtbR040R3(wnRel)

Local aSetOfBook
Local aCtbMoeda		:= {}
LOCAL cDesc1 		:= OemToAnsi(STR0001)	//"Este programa ira imprimir o Balancete de Verificacao Modelo 1 (80 Colunas), a"
LOCAL cDesc2 		:= OemToansi(STR0002)   //"conta eh impressa limitando-se a 20 caracteres e sua descricao 30 caracteres,"
LOCAL cDesc3		:= OemToansi(STR0016)   //"os valores impressao sao saldo anterior, debito, credito e saldo atual do periodo."
LOCAL cString		:= "CT1"
Local cTitOrig		:= ""
Local lRet			:= .T.
Local nDivide		:= 1
Local lExterno 		:= .F.
Local nQuadro
Local lPerg			:= .T.
PRIVATE nLastKey 	:= 0
PRIVATE cPerg	 	:= "CTR040"
PRIVATE aLinha		:= {}
PRIVATE nomeProg  	:= "CTBR040"
PRIVATE titulo 		:= OemToAnsi(STR0003) 	//"Balancete de Verificacao"
Private aSelFil		:= {} 

Default wnRel 		:= ""

lExterno 			:= !Empty(wnRel)

Conout("*** La Selva - Static Function CTBR040R3 - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

If ! lExterno
	PRIVATE Tamanho		:= "M"
	PRIVATE aReturn 	:= { OemToAnsi(STR0013), 1,OemToAnsi(STR0014), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
EndIf

cTitOrig	:= titulo

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

li	:= 60 //80 



Private aQuadro := { "","","","","","","",""}              

For nQuadro :=1 To Len(aQuadro)
	aQuadro[nQuadro] := Space(Len(CriaVar("CT1_CONTA")))
Next	

CtbCarTxt()

Pergunte("CTR040",.F.)


//�����������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros								  �
//� mv_par01				// Data Inicial                  	  		  �
//� mv_par02				// Data Final                        		  �
//� mv_par03				// Conta Inicial                         	  �
//� mv_par04				// Conta Final  							  �
//� mv_par05				// Imprime Contas: Sintet/Analit/Ambas   	  �
//� mv_par06				// Set Of Books				    		      �
//� mv_par07				// Saldos Zerados?			     		      �
//� mv_par08				// Moeda?          			     		      �
//� mv_par09				// Pagina Inicial  		     		    	  �
//� mv_par10				// Saldos? Reais / Orcados	/Gerenciais   	  �
//� mv_par11				// Quebra por Grupo Contabil?		    	  �
//� mv_par12				// Filtra Segmento?					    	  �
//� mv_par13				// Conteudo Inicial Segmento?		   		  �
//� mv_par14				// Conteudo Final Segmento?		    		  �
//� mv_par15				// Conteudo Contido em?				    	  �
//� mv_par16				// Imprime Coluna Mov ?				    	  �
//� mv_par17				// Salta linha sintetica ?			    	  �
//� mv_par18				// Imprime valor 0.00    ?			    	  �
//� mv_par19				// Imprimir Codigo? Normal / Reduzido  		  �
//� mv_par20				// Divide por ?                   			  �
//� mv_par21				// Imprimir Ate o segmento?			   		  �
//� mv_par22				// Posicao Ant. L/P? Sim / Nao         		  �
//� mv_par23				// Data Lucros/Perdas?                 		  �
//� mv_par24				// Imprime Quadros Cont�beis?				  �		
//� mv_par25				// Rec./Desp. Anterior Zeradas?				  �		
//� mv_par26				// Grupo Receitas/Despesas?      			  �		
//� mv_par27				// Data de Zeramento Receita/Despesas?		  �		
//� mv_par28                // Num.linhas p/ o Balancete Modelo 1		  � 
//� mv_par29				// Descricao na moeda?						  �		
//�������������������������������������������������������������������������

If ! lExterno  	
	Pergunte("CTR040",.T.)  
    /*
	If mv_par30 == 1 .And. Len( aSelFil ) <= 0 .And. !IsBlind()
		aSelFil := AdmGetFil()
		If Len( aSelFil ) <= 0
			Return
		EndIf 
	EndIf
	*/
	aSelFil := U_LS_SelFil()
	
	If Len( aSelFil ) <= 0
		Return
	EndIf

	wnrel	:= "LS_CTBR040"            //Nome Default do relatorio em Disco
	wnrel := SetPrint(cString,wnrel,,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)  

Endif 

If "CTBR110" $ wnRel 
	/*
	If mv_par30 == 1 .And. Len( aSelFil ) <= 0 .And. !IsBlind()
		aSelFil := AdmGetFil()
		If Len( aSelFil ) <= 0
			Return
		EndIf 
	EndIf
	*/
	aSelFil := U_LS_SelFil()
	
	If Len( aSelFil ) <= 0
		Return
	EndIf

Endif

If nLastKey == 27
	Set Filter To
	Return
Endif

//��������������������������������������������������������������Ŀ
//� Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano�
//� Gerencial -> montagem especifica para impressao)		     �
//����������������������������������������������������������������
If !ct040Valid(mv_par06)
	lRet := .F.
Else
   aSetOfBook := CTBSetOf(mv_par06)
Endif

If mv_par20 == 2			// Divide por cem
	nDivide := 100
ElseIf mv_par20 == 3		// Divide por mil
	nDivide := 1000
ElseIf mv_par20 == 4		// Divide por milhao
	nDivide := 1000000
EndIf	

If lRet
	aCtbMoeda  	:= CtbMoeda(mv_par08,nDivide)
	If Empty(aCtbMoeda[1])                       
      Help(" ",1,"NOMOEDA")
      lRet := .F.
   Endif
Endif

If lRet
	If (mv_par25 == 1) .and. ( Empty(mv_par26) .or. Empty(mv_par27) )
		cMensagem	:= STR0025	//"Favor preencher os parametros Grupos Receitas/Despesas e "
		cMensagem	+= STR0026	//"Data Sld Ant. Receitas/Desp. "
		MsgAlert(cMensagem,"Ignora Sl Ant.Rec/Des")	
		lRet    	:= .F.	
    EndIf
EndIf

If !lRet
	Set Filter To
	Return
EndIf


If !lExterno .And. ( mv_par16 == 1 .Or. ( mv_par16 == 2 .And.	aReturn[4] == 2 ))	//Se nao imprime coluna mov. e eh paisagem
	tamanho := "G"
EndIf	

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| CTR040Imp(@lEnd,wnRel,cString,aSetOfBook,aCtbMoeda,nDivide,lExterno,cTitorig)})

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Program   �CTR040IMP � Autor � Pilar S. Albaladejo   � Data � 24.07.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime relatorio -> Balancete Verificacao Modelo 1        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �CTR040Imp(lEnd,WnRel,cString,aSetOfBook,aCtbMoeda)          ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd       - A�ao do Codeblock                             ���
���          � WnRel      - T�tulo do relat�rio                           ���
���          � cString    - Mensagem                                      ���
���          � aSetOfBook - Matriz ref. Config. Relatorio                 ���
���          � aCtbMoeda  - Matriz ref. a moeda                           ���
���          � nDivide    - Valor para divisao de valores                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function CTR040Imp(lEnd,WnRel,cString,aSetOfBook,aCtbMoeda,nDivide,lExterno,cTitOrig)

Local aColunas		:= {}
LOCAL CbTxt			:= Space(10)
Local CbCont		:= 0
LOCAL limite		:= 132
Local cabec1   		:= ""
Local cabec2   		:= ""
Local cSeparador	:= ""
Local cPicture
Local cDescMoeda
Local cCodMasc
Local cMascara
Local cGrupo		:= ""
Local cArqTmp
Local dDataFim 		:= mv_par02
Local lFirstPage	:= .T.
Local lJaPulou		:= .F.
Local lPrintZero	:= Iif(mv_par18==1,.T.,.F.)
Local lPula			:= Iif(mv_par17==1,.T.,.F.) 
Local lNormal		:= Iif(mv_par19==1,.T.,.F.)
Local lVlrZerado	:= Iif(mv_par07==1,.T.,.F.)
Local l132			:= .T.
Local nDecimais
Local nTotDeb		:= 0
Local nTotCrd		:= 0
Local nTotMov		:= 0
Local nGrpDeb		:= 0
Local nGrpCrd		:= 0                     
Local cSegAte   	:= mv_par21
Local nDigitAte		:= 0
Local lImpAntLP		:= Iif(mv_par22 == 1,.T.,.F.)
Local dDataLP		:= mv_par23
Local lImpSint		:= Iif(mv_par05=1 .Or. mv_par05 ==3,.T.,.F.)
Local lRecDesp0		:= Iif(mv_par25==1,.T.,.F.)
Local cRecDesp		:= mv_par26
Local dDtZeraRD		:= mv_par27
Local n
Local oMeter
Local oText
Local oDlg
Local lImpPaisgm	:= .F.	
Local nMaxLin   	:= iif( mv_par28 > 58 , 58 , mv_par28 )
Local cMoedaDsc		:= mv_par29
Local nMasc			:= 0 
Local cMasc			:= ""

cDescMoeda 			:= Alltrim(aCtbMoeda[2])
nDecimais 			:= DecimalCTB(aSetOfBook,mv_par08)

Conout("*** La Selva - Static Function CTR040IMP - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

If Empty(aSetOfBook[2])
	cMascara := GetMv("MV_MASCARA")
Else
	cMascara 	:= RetMasCtb(aSetOfBook[2],@cSeparador)
EndIf
cPicture 		:= aSetOfBook[4]

If mv_par16 == 2 .And. !lExterno .And. 	aReturn[4] == 2	//Se nao imprime coluna mov. e eh paisagem
	lImpPaisgm	:= .T.
	limite		:= 220
EndIf

//��������������������������������������������������������������Ŀ
//� Carrega titulo do relatorio: Analitico / Sintetico			  �
//����������������������������������������������������������������
If Alltrim(Titulo) == Alltrim(cTitorig) // Se o titulo do relatorio nao foi alterado pelo usuario
	IF mv_par05 == 1
		Titulo:=	OemToAnsi(STR0009)	//"BALANCETE DE VERIFICACAO SINTETICO DE "
	ElseIf mv_par05 == 2
		Titulo:=	OemToAnsi(STR0006)	//"BALANCETE DE VERIFICACAO ANALITICO DE "
	ElseIf mv_par05 == 3
		Titulo:=	OemToAnsi(STR0017)	//"BALANCETE DE VERIFICACAO DE "
	EndIf
EndIf	
Titulo += 	DTOC(mv_par01) + OemToAnsi(STR0007) + Dtoc(mv_par02) + ;
			OemToAnsi(STR0008) + cDescMoeda + CtbTitSaldo(mv_par10)
			
If nDivide > 1			
	Titulo += " (" + OemToAnsi(STR0021) + Alltrim(Str(nDivide)) + ")"
EndIf	

If mv_par16 == 1 .And. ! lExterno		// Se imprime saldo movimento do periodo
	cabec1 := OemToAnsi(STR0004)  //"|  CODIGO              |   D  E  S  C  R  I  C  A  O    |   SALDO ANTERIOR  |    DEBITO     |    CREDITO   | MOVIMENTO DO PERIODO |   SALDO ATUAL    |"
	tamanho := "G"
	limite	:= 220        
	l132	:= .F.
Else	  
	If lImpPaisgm		//Se imprime em formato paisagem
		cabec1 := STR0022  //"|  CODIGO                     |      D E S C R I C A O                          |        SALDO ANTERIOR             |           DEBITO             |            CREDITO                |         SALDO ATUAL               |"
	Else	
		cabec1 := OemToAnsi(STR0005)  //"|  CODIGO               |   D  E  S  C  R  I  C  A  O    |   SALDO ANTERIOR  |      DEBITO    |      CREDITO   |   SALDO ATUAL     |"
	EndIf
Endif

If ! lExterno
	ferase(__RelDir + wnrel + '.##r')
	SetDefault(aReturn,cString,,,Tamanho,If(Tamanho="G",2,1))
Endif

If l132
	If lImpPaisgm
		aColunas := { 000,001, 030, 032, 080,086, 116, 118, 147, 151, 183, , ,187,219}
	Else	
		aColunas := { 000,001, 024, 025, 057,058, 077, 078, 094, 095, 111, , , 112, 131 }
	EndIf
Else                   
	aColunas := { 000,001, 030, 032, 080,082, 112, 114, 131, 133, 151, 153, 183,185,219}
Endif

If ! lExterno
	m_pag := mv_par09
Endif

//��������������������������������������������������������������Ŀ
//� Monta Arquivo Temporario para Impressao							  �
//����������������������������������������������������������������
If lExterno  .or. IsBlind()
	CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
				mv_par01,mv_par02,"CT7","",mv_par03,mv_par04,,,,,,,mv_par08,;
				mv_par10,aSetOfBook,mv_par12,mv_par13,mv_par14,mv_par15,;
				.F.,.F.,mv_par11,,lImpAntLP,dDataLP,nDivide,lVlrZerado,,,,,,,,,,,,,,lImpSint,aReturn[7],lRecDesp0,;
				cRecDesp,dDtZeraRD,,,,,,,cMoedaDsc,,aSelFil)
Else
	MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
					CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
					mv_par01,mv_par02,"CT7","",mv_par03,mv_par04,,,,,,,mv_par08,;
					mv_par10,aSetOfBook,mv_par12,mv_par13,mv_par14,mv_par15,;
					.F.,.F.,mv_par11,,lImpAntLP,dDataLP,nDivide,lVlrZerado,,,,,,,,,,,,,,lImpSint,aReturn[7],lRecDesp0,;
					cRecDesp,dDtZeraRD,,,,,,,cMoedaDsc,,aSelFil)},;
					OemToAnsi(OemToAnsi(STR0015)),;  //"Criando Arquivo Tempor�rio..."
					OemToAnsi(STR0003))  				//"Balancete Verificacao"
EndIf

// Verifica Se existe filtragem Ate o Segmento
If !Empty(cSegAte)
	
	//Efetua tratamento da mascara para consegui efetuar o controle do segmento 
	For nMasc := 1 to Len( cMascara )
			
		cMasc += SubStr( cMascara,nMasc,1 )
			
	Next nMasc


	nDigitAte := CtbRelDig(cSegAte,cMasc) 	
	
EndIf				

dbSelectArea("cArqTmp")
dbGoTop()

SetRegua(RecCount())

cGrupo := GRUPO

While !Eof()

	If lEnd
		@Prow()+1,0 PSAY OemToAnsi(STR0010)   //"***** CANCELADO PELO OPERADOR *****"
		Exit
	EndIF

	IncRegua()

	******************** "FILTRAGEM" PARA IMPRESSAO *************************

	If mv_par05 == 1					// So imprime Sinteticas
		If TIPOCONTA == "2"
			dbSkip()
			Loop
		EndIf
	ElseIf mv_par05 == 2				// So imprime Analiticas
		If TIPOCONTA == "1"
			dbSkip()
			Loop
		EndIf
	EndIf

	//Filtragem ate o Segmento ( antigo nivel do SIGACON)		
	If !Empty(cSegAte)
		If Len(Alltrim(CONTA)) > nDigitAte
			dbSkip()
			Loop
		Endif
	EndIf
	

	************************* ROTINA DE IMPRESSAO *************************

	If mv_par11 == 1 							// Grupo Diferente - Totaliza e Quebra
		If cGrupo != GRUPO
			@li,00 PSAY REPLICATE("-",limite)
			li+=2
			@li,00 PSAY REPLICATE("-",limite)
			li++
			@li,aColunas[COL_SEPARA1] PSAY "|"
			@li,39 PSAY OemToAnsi(STR0020) + cGrupo + ") : "  		//"T O T A I S  D O  G R U P O: "       
			@li,aColunas[COL_SEPARA4] PSAY "|"
			ValorCTB(nGrpDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
			@li,aColunas[COL_SEPARA5] PSAY "|"
			ValorCTB(nGrpCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
			@li,aColunas[COL_SEPARA6] PSAY "|"
			@li,aColunas[COL_SEPARA8] PSAY "|"
			li++      
			li		:= 60
			cGrupo	:= GRUPO
			nGrpDeb	:= 0
			nGrpCrd	:= 0		
		EndIf		

	ElseIf  mv_par11 == 2
		If NIVEL1				// Sintetica de 1o. grupo
			li := 60
		EndIf
	EndIf

	IF li > nMaxLin
		If !lFirstPage
			@Prow()+1,00 PSAY	Replicate("-",limite)
		EndIf
		CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
		lFirstPage := .F.
	EndIf

	@ li,aColunas[COL_SEPARA1] 		PSAY "|"
	If lNormal
		If TIPOCONTA == "2" 		// Analitica -> Desloca 2 posicoes
			If l132
				EntidadeCTB(CONTA,li,aColunas[COL_CONTA]+2,21,.F.,cMascara,cSeparador)			
			Else
				EntidadeCTB(CONTA,li,aColunas[COL_CONTA]+2,27,.F.,cMascara,cSeparador)
			EndIf
		Else	                                              
			If l132
				EntidadeCTB(CONTA,li,aColunas[COL_CONTA],23,.F.,cMascara,cSeparador)
			Else                                                                     
				EntidadeCTB(CONTA,li,aColunas[COL_CONTA],29,.F.,cMascara,cSeparador)
			EndIf			
		EndIf	
	Else
		If TIPOCONTA == "2"		// Analitica -> Desloca 2 posicoes
			@li,aColunas[COL_CONTA] PSAY Alltrim(CTARES)
		Else
			@li,aColunas[COL_CONTA] PSAY Alltrim(CONTA)
		EndIf						
	EndIf	

	@ li,aColunas[COL_SEPARA2] 		PSAY "|"

	If !l132
		@ li,aColunas[COL_DESCRICAO] 	PSAY Substr(DESCCTA,1,48)
	Else		
		@ li,aColunas[COL_DESCRICAO] 	PSAY Substr(DESCCTA,1,30)
	Endif	

	@ li,aColunas[COL_SEPARA3]		PSAY "|"
	ValorCTB(SALDOANT,li,aColunas[COL_SALDO_ANT],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)

	@ li,aColunas[COL_SEPARA4]		PSAY "|"
	ValorCTB(SALDODEB,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,NORMAL, , , , , ,lPrintZero)

	@ li,aColunas[COL_SEPARA5]		PSAY "|"
	ValorCTB(SALDOCRD,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,NORMAL, , , , , ,lPrintZero)
	
	@ li,aColunas[COL_SEPARA6]		PSAY "|"

	If !l132
		ValorCTB(MOVIMENTO,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA7] PSAY "|"	
	Endif
	ValorCTB(SALDOATU,li,aColunas[COL_SALDO_ATU],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)

	@ li,aColunas[COL_SEPARA8] PSAY "|"
	
	lJaPulou := .F.
	
	If lPula .And. TIPOCONTA == "1"				// Pula linha entre sinteticas
		li++
		@ li,aColunas[COL_SEPARA1] PSAY "|"
		@ li,aColunas[COL_SEPARA2] PSAY "|"
		@ li,aColunas[COL_SEPARA3] PSAY "|"	
		@ li,aColunas[COL_SEPARA4] PSAY "|"
		@ li,aColunas[COL_SEPARA5] PSAY "|"
		@ li,aColunas[COL_SEPARA6] PSAY "|"
		If !l132  
			@ li,aColunas[COL_SEPARA7] PSAY "|"
			@ li,aColunas[COL_SEPARA8] PSAY "|"
		Else
			@ li,aColunas[COL_SEPARA8] PSAY "|"
		EndIf	
		li++
		lJaPulou := .T.
	Else
		li++
	EndIf			

	************************* FIM   DA  IMPRESSAO *************************

	If mv_par05 == 1					// So imprime Sinteticas - Soma Sinteticas
		If TIPOCONTA == "1"
			If NIVEL1
				nTotDeb += SALDODEB
				nTotCrd += SALDOCRD
				nGrpDeb += SALDODEB
				nGrpCrd += SALDOCRD
			EndIf
		EndIf
	Else									// Soma Analiticas
		If Empty(cSegAte)				//Se nao tiver filtragem ate o nivel
			If TIPOCONTA == "2"
				nTotDeb += SALDODEB
				nTotCrd += SALDOCRD
				nGrpDeb += SALDODEB
				nGrpCrd += SALDOCRD
			EndIf
		Else							//Se tiver filtragem, somo somente as sinteticas
			If TIPOCONTA == "1"
				If NIVEL1
					nTotDeb += SALDODEB
					nTotCrd += SALDOCRD
					nGrpDeb += SALDODEB
					nGrpCrd += SALDOCRD
				EndIf
			EndIf	
    	Endif			
	EndIf

	dbSkip()       
	If lPula .And. TIPOCONTA == "1" 			// Pula linha entre sinteticas
		If !lJaPulou
			@ li,aColunas[COL_SEPARA1] PSAY "|"
			@ li,aColunas[COL_SEPARA2] PSAY "|"
			@ li,aColunas[COL_SEPARA3] PSAY "|"	
			@ li,aColunas[COL_SEPARA4] PSAY "|"
			@ li,aColunas[COL_SEPARA5] PSAY "|"
			@ li,aColunas[COL_SEPARA6] PSAY "|"
			If !l132  
				@ li,aColunas[COL_SEPARA7] PSAY "|"
				@ li,aColunas[COL_SEPARA8] PSAY "|"
			Else
				@ li,aColunas[COL_SEPARA8] PSAY "|"
			EndIf	
			li++
		EndIf	
	EndIf		
EndDO

//IF li != 80 .And. !lEnd
IF li <= 58 .OR. li >= 58 .And. !lEnd
	IF li > nMaxLin
		@Prow()+1,00 PSAY	Replicate("-",limite)
		CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
		li++
	End
	If mv_par11 == 1							// Grupo Diferente - Totaliza e Quebra
		If cGrupo != GRUPO .Or. Eof()
			@li,00 PSAY REPLICATE("-",limite)
			li++
			@li,aColunas[COL_SEPARA1] PSAY "|"
			@li,39 PSAY OemToAnsi(STR0020) + cGrupo + ") : "  		//"T O T A I S  D O  G R U P O: "
			@li,aColunas[COL_SEPARA4] PSAY "|"
			ValorCTB(nGrpDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
			@li,aColunas[COL_SEPARA5] PSAY "|"
			ValorCTB(nGrpCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
			@li,aColunas[COL_SEPARA6] PSAY "|"
			If !l132
				nTotMov := nTotMov + (nGrpCrd - nGrpDeb)
				If Round(NoRound(nTotMov,3),2) < 0
					ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"1", , , , , ,lPrintZero)
				ElseIf Round(NoRound(nTotMov,3),2) > 0
					ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"2", , , , , ,lPrintZero)
                EndIf
				@ li,aColunas[COL_SEPARA7] PSAY "|"	
			Endif
			@li,aColunas[COL_SEPARA8] PSAY "|"
			li++
			@li,00 PSAY REPLICATE("-",limite)
			li+=2
		EndIf		
	EndIf

	@li,00 PSAY REPLICATE("-",limite)
	li++
	@li,aColunas[COL_SEPARA1] PSAY "|"
	@li,39 PSAY OemToAnsi(STR0011)  		//"T O T A I S  D O  M E S : "
	@li,aColunas[COL_SEPARA4] PSAY "|"
	ValorCTB(nTotDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
	@li,aColunas[COL_SEPARA5] PSAY "|"
	ValorCTB(nTotCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
	@li,aColunas[COL_SEPARA6] PSAY "|"
 	If !l132	
		nTotMov := nTotMov + (nTotCrd - nTotDeb)
		If Round(NoRound(nTotMov,3),2) < 0
			ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"1", , , , , ,lPrintZero)
		ElseIf Round(NoRound(nTotMov,3),2) > 0
			ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"2", , , , , ,lPrintZero)
		EndIf
		@li,aColunas[COL_SEPARA7] PSAY "|"	
	EndIf		                                
	@li,aColunas[COL_SEPARA8] PSAY "|"
	li++
	@li,00 PSAY REPLICATE("-",limite)
	li++
	@li,0 PSAY " "

	IF lExterno 
		If (li + 3) < 60 
			@57,00 PSAY __PrtfatLine()
  		  	@58,01 Psay STR0023   //  "Microsiga Software S/A"
 		   	If Tamanho == "M"
   		 		@58,100 Psay STR0024 + " " + Time()      //"Hora Termino: "
   	 		ElseIf Tamanho == "G"
	   		 	@58,190 Psay STR0024 + " "+ Time()  //"Hora Termino: "
    		Else
	    		@58,050 Psay STR0024 + " "+ Time()	   //"Hora Termino: "
			EndIf               
			@59,00 PSAY __PrtfatLine()
		EndIf	
	Endif
	Set Filter To
EndIF

If mv_par24 ==1
	ImpQuadro(Tamanho,X3USO("CT2_DCD"),dDataFim,mv_par08,aQuadro,cDescMoeda,nomeprog,(If (lImpAntLP,dDataLP,cTod(""))),cPicture,nDecimais,lPrintZero,mv_par10)
EndIf	
	
If aReturn[5] = 1 .And. ! lExterno
	Ourspool(wnrel)
EndIf

dbSelectArea("cArqTmp")
Set Filter To
dbCloseArea() 
If Select("cArqTmp") == 0
	FErase(cArqTmp+GetDBExtension())
	FErase(cArqTmp+OrdBagExt())
EndIF	
dbselectArea("CT2")

If ! lExterno
	MS_FLUSH()
Endif

Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �CT040Valid� Autor � Pilar S. Albaladejo   � Data � 24.07.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida Perguntas                                           ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �Ct040Valid(cSetOfBook)                                      ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T./.F.                                                    ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Codigo da Config. Relatorio                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Ct040Valid(cSetOfBook)

Local aSaveArea	:= GetArea()
Local lRet		:= .T.	

Conout("*** La Selva - Static Function CT040VALID - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

If !Empty(cSetOfBook)
	dbSelectArea("CTN")
	dbSetOrder(1)
	If !dbSeek(xfilial()+cSetOfBook)
		aSetOfBook := ("","",0,"","")
		Help(" ",1,"NOSETOF")
		lRet := .F.
	EndIf
EndIf
	
RestArea(aSaveArea)

Return lRet


/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������ͻ��
���Programa  � CTR040MAXL �Autor � Eduardo Nunes Cirqueira � Data �  31/01/07 ���
�����������������������������������������������������������������������������͹��
���Desc.     � Baseado no parametro MV_PAR28 ("Num.linhas p/ o Balancete      ���
���          � Modelo 1"), cujo conteudo esta na variavel "nMaxLin", controla ���
���          � a quebra de pagina no TReport                                  ���
�����������������������������������������������������������������������������͹��
���Uso       � AP                                                             ���
�����������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/
Static Function CTR040MaxL(nMaxLin,nLinReport)
Conout("*** La Selva - Static Function CTR040MAXL - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

nLinReport++

If nLinReport > nMaxLin
	oReport:EndPage()
	nLinReport := 10
EndIf

Return Nil
                                                                          

/*
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������ͻ��
���Programa  � nCtCGCCabTR  � Autor � Fabio Jadao Caires      � Data � 31/01/07���
������������������������������������������������������������������������������͹��
���Desc.     � Chama a funcao padrao CtCGCCabTR reiniciando o contador de      ���
���          � linhas para o controle do relatorio.                            ���
���          �                                                                 ���
������������������������������������������������������������������������������͹��
���Uso       � AP                                                              ���
������������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
*/
STATIC FUNCTION nCtCGCCabTR(dDataFim,titulo,oReport)
Conout("*** La Selva - Static Function NCTCGCCABTR - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

nLinReport := 10

RETURN CtCGCCabTR(,,,,,dDataFim,titulo,,,,,oReport)
