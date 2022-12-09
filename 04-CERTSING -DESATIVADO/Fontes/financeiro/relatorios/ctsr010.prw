#INCLUDE "PRTOPDEF.CH" 
#INCLUDE "RWMAKE.CH"      

User Function CTSR010()

LOCAL	aPergs := {}
LOCAL   aMarked    := {}
PRIVATE lExec    := .F.
PRIVATE cIndexName := ''
PRIVATE cIndexKey  := ''
PRIVATE cFilter    := ''
Private _cNossoNum := "00000000"
Private cCart      := ""

Tamanho  := "M"
titulo   := "Impressao de Boleto com Codigo de Barras"
cDesc1   := "Este programa destina-se a impressao do Boleto com Codigo de Barras."
cDesc2   := ""
cDesc3   := ""
cString  := "SE1"
wnrel    := "BOLETO"
lEnd     := .F.
cPerg     :="BLTBAR"
aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nLastKey := 0

dbSelectArea("SE1")

Aadd(aPergs,{"De Prefixo","","","mv_ch1","C",3,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Prefixo","","","mv_ch2","C",3,0,0,"G","","MV_PAR02","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Numero","","","mv_ch3","C",9,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Numero","","","mv_ch4","C",9,0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Parcela","","","mv_ch5","C",1,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Parcela","","","mv_ch6","C",1,0,0,"G","","MV_PAR06","","","","Z","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Portador","","","mv_ch7","C",3,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
Aadd(aPergs,{"Ate Portador","","","mv_ch8","C",3,0,0,"G","","MV_PAR08","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
Aadd(aPergs,{"De Cliente","","","mv_ch9","C",6,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","SE1","","","",""})
Aadd(aPergs,{"Ate Cliente","","","mv_cha","C",6,0,0,"G","","MV_PAR10","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SE1","","","",""})
Aadd(aPergs,{"De Loja","","","mv_chb","C",2,0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Loja","","","mv_chc","C",2,0,0,"G","","MV_PAR12","","","","ZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Emissao","","","mv_chd","D",8,0,0,"G","","MV_PAR13","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Emissao","","","mv_che","D",8,0,0,"G","","MV_PAR14","","","","31/12/03","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Vencimento","","","mv_chf","D",8,0,0,"G","","MV_PAR15","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Vencimento","","","mv_chg","D",8,0,0,"G","","MV_PAR16","","","","31/12/03","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Do Bordero","","","mv_chh","C",6,0,0,"G","","MV_PAR17","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Bordero","","","mv_chi","C",6,0,0,"G","","MV_PAR18","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
//Aadd(aPergs,{"Imprimi Sacador:","","","mv_ch19","C",1,0,0,"G","","MV_PAR19","","","","N","","","","","","","","","","","","","","","","","","","","","","","","",""})

//AjustaSx1("BLTBAR",aPergs)

Pergunte (cPerg,.F.)

Wnrel := SetPrint(cString,Wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,)

If nLastKey == 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif

cIndexName	:= Criatrab(Nil,.F.)
cIndexKey	:= "E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"
cFilter		+= "E1_FILIAL=='"+xFilial("SE1")+"'.And.E1_SALDO>0.And."
cFilter		+= "E1_PREFIXO>='" + MV_PAR01 + "'.And.E1_PREFIXO<='" + MV_PAR02 + "'.And."
cFilter		+= "E1_NUM>='" + MV_PAR03 + "'.And.E1_NUM<='" + MV_PAR04 + "'.And."
cFilter		+= "E1_PARCELA>='" + MV_PAR05 + "'.And.E1_PARCELA<='" + MV_PAR06 + "'.And."
cFilter		+= "E1_PORTADO>='" + MV_PAR07 + "'.And.E1_PORTADO<='" + MV_PAR08 + "'.And."
cFilter		+= "E1_CLIENTE>='" + MV_PAR09 + "'.And.E1_CLIENTE<='" + MV_PAR10 + "'.And."
cFilter		+= "E1_LOJA>='" + MV_PAR11 + "'.And.E1_LOJA<='"+MV_PAR12+"'.And."
cFilter		+= "DTOS(E1_EMISSAO)>='"+DTOS(mv_par13)+"'.and.DTOS(E1_EMISSAO)<='"+DTOS(mv_par14)+"'.And."
cFilter		+= 'DTOS(E1_VENCREA)>="'+DTOS(mv_par15)+'".and.DTOS(E1_VENCREA)<="'+DTOS(mv_par16)+'".And.'
cFilter		+= "E1_NUMBOR>='" + MV_PAR17 + "'.And.E1_NUMBOR<='" + MV_PAR18 + "'.And."
cFilter		+= "!(E1_TIPO$MVABATIM).And."
cFilter		+= "E1_PORTADO<>'   '"

IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
DbSelectArea("SE1")
#IFNDEF TOP
	DbSetIndex(cIndexName + OrdBagExt())
#ENDIF
dbGoTop()
@ 001,001 TO 400,700 DIALOG oDlg TITLE "Seleção de Titulos"
@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"
@ 180,310 BMPBUTTON TYPE 01 ACTION (lExec := .T.,Close(oDlg))
@ 180,280 BMPBUTTON TYPE 02 ACTION (lExec := .F.,Close(oDlg))
ACTIVATE DIALOG oDlg CENTERED

dbGoTop()
If lExec
	Processa({|lEnd|MontaRel()})
Endif
RetIndex("SE1")
Ferase(cIndexName+OrdBagExt())

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MontaRel³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO ITAU COM CODIGO DE BARRAS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaRel()
LOCAL oPrint
LOCAL nX := 0
Local cNroDoc :=  " " 
Local cCNPJ :=  ""   
LOCAL aDadosEmp    := {} 


LOCAL aDadosTit
LOCAL aDatSacado
LOCAL aBolText     := {"Após o vencimento cobrar R$ "               }
//								"Mora Diaria de R$ "}

LOCAL nI           := 1
LOCAL aCB_RN_NN    := {}
LOCAL nVlrAbat	   := 0
Local _nDgit       := ""
PRIVATE aDadosBanco

oPrint:= TMSPrinter():New( "Boleto Laser" )
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova página    




dbGoTop()
ProcRegua(RecCount())
DbSelectArea("SA6")
DbSetOrder(1)
DbSeek(xFilial("SA6")+SE1->E1_PORTADO+SE1->E1_AGEDEP,.T.)
	
 
	cCNPJ := "CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."
	cCNPJ +=Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"
	cCNPJ +=Subs(SM0->M0_CGC,13,2)                                         



aDadosEmp    := {	SM0->M0_NOMECOM ,; //[1]Nome da Empresa
SM0->M0_ENDCOB                                     ,; //[2]Endereço
AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
cCNPJ                                                                     ,; //[6]
"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E

Do While !SE1->(EOF())
	//Posiciona o SA6 (Bancos)
	DbSelectArea("SA6")
	DbSetOrder(1)
	DbSeek(xFilial("SA6")+SE1->E1_PORTADO+SE1->E1_AGEDEP,.T.)
	
	//Posiciona na Arq de Parametros CNAB
	DbSelectArea("SEE")
	DbSetOrder(1)
	If SEE->(DbSeek(xFilial("SEE")+SE1->(E1_PORTADO+E1_AGEDEP)))
		cDVCta	:=alltrim(SEE->EE_SUBCTA)	//Digito da conta
		
		If Empty(SE1->E1_NUMBCO)
			_cNossoNum := StrZero(Val(Alltrim(SEE->EE_FAXATU))+1,8)
			RecLock("SEE",.f.)
			SEE->EE_FAXATU     :=	_cNossoNum
			MsUnlock()
			
			RecLock("SE1",.f.)
			SE1->E1_NUMBCO :=	_cNossoNum
			MsUnlock()
			
		Else
			_cNossoNum := Right(AllTrim(SE1->E1_NUMBCO),8)
		Endif
		
	else
		aOp:= {"OK"}
		cTit:= "Atencao!"
		cMsg:= "Arquivo de Banco nao configurado!"
		nOp:= Aviso(cTit,cMsg,aOp)
		If nOp == 1 // Sim
	 		return
		Endif
		
	endif
	//Posiciona o SA1 (Cliente)
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
	
	DbSelectArea("SE1")
	aDadosBanco  := {"341"                         ,;   //[1]Numero do Banco
	SA6->A6_NOME      	       ,;   //[2]Nome do Banco
	SUBSTR(SA6->A6_AGENCIA, 1,4) ,;   //[3]Agência
	SUBSTR(SA6->A6_NUMCON,1,5)   ,;   //[4]Conta Corrente
	SUBSTR(SA6->A6_NUMCON,7,1)   ,;   //[5]Dígito da conta corrente
	IIF(SE1->E1_NUMBCO <> "" , "175","112")}    //[6]Codigo da Carteira
	
	If Empty(SA1->A1_ENDCOB)
		aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;      	// [1]Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;      	// [2]Código
		AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;      	// [3]Endereço
		AllTrim(SA1->A1_MUN )                            ,;   	    // [4]Cidade
		SA1->A1_EST                                      ,;     	// [5]Estado
		SA1->A1_CEP                                      ,;      	// [6]CEP
		SA1->A1_CGC										 ,;  		// [7]CGC
		SA1->A1_PESSOA								     }        // [8]PESSOA
	Else
		aDatSacado   := {AllTrim(SA1->A1_NOME)            	 ,;   	// [1]Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA               ,;   	// [2]Código
		AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC) ,;   	// [3]Endereço
		AllTrim(SA1->A1_MUNC)	                             ,;   	// [4]Cidade
		SA1->A1_ESTC	                                     ,;   	// [5]Estado
		SA1->A1_CEPC                                         ,;   	// [6]CEP
		SA1->A1_CGC											 ,;		// [7]CGC
		SA1->A1_PESSOA										 }	// [8]PESSOA  
	Endif
	
	nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
	
	//Aqui defino parte do nosso numero. Sao 8 digitos para identificar o titulo.
	//Abaixo apenas uma sugestao
	cNroDoc	:= StrZero(	Val(Alltrim(SE1->E1_NUM)+Alltrim(SE1->E1_PARCELA)),8)
	
	aDadosTit	:= {AllTrim(E1_NUM)+AllTrim(E1_PARCELA)		    ,;  // [1] Número do título
	E1_EMISSAO                               					,;  // [2] Data da emissão do título
	dDataBase                    			 					,;  // [3] Data da emissão do boleto
	E1_VENCREA                                					,;  // [4] Data do vencimento Real
	(E1_SALDO - nVlrAbat - E1_DESCFIN + E1_ACRESC - E1_DECRESC ),;  // [5] Valor do título
	_cNossoNum                               					,;  // [6] Nosso número (Ver fórmula para calculo)
	E1_PREFIXO                               					,;  // [7] Prefixo da NF
	E1_TIPO	                           		 					,;  // [8] Tipo do Titulo
	E1_ACRESC						}  								//[9] Valor Acrescimo  
	
	//(E1_SALDO - nVlrAbat - E1_DESCFIN + E1_ACRESC - E1_DECRESC )                  	 ,;  // [5] Valor do título - 29/10/2013 - Renato Ruy - Solicitado pela Ana Paula -Alterado para buscar o valor total do Título no aDadosTit[5]
	//SE1->E1_SALDO                  	 			 									 ,;  // [5] Valor do título - 02/04/2014 - Renato Ruy - Solicitado pelo Valdinei -Alterado para buscar o valor líquido do Título no aDadosTit[5]
	nVal1 := aDadosTit[9]
	nVal2 := aDadosTit[5]
	
	cValCobr := nVal1 + nVal2
	//Monta codigo de barras
	//[1]Numero do Banco
	//[2]Nome do Banco
	//[3]Agência
	//[4]Conta Corrente
	//[5]Dígito da conta corrente
	//[6]Codigo da Carteira
	
	//_nDgit := Alltrim(str(Modulo10(aDadosBAnco[3]+aDadosBanco[4]+aDadosBanco[6]+aDadosTit[6]))) //Digito Verificador                                  
	
	//aCB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],aDadosTit[6],(E1_VALOR -nVlrAbat),E1_VENCTO)
	
	//Renato Ruy - 29/10/2013 - Solicitante: Ana Paula - Alteração do tratamento do valor
	//aCB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],aDadosTit[6],(E1_SALDO -nVlrAbat- E1_DESCFIN + E1_ACRESC - E1_DECRESC),E1_VENCTO)
	//Renato Ruy - 02/04/2014 - Solicitante: Valdinei - Alteração do tratamento do valor bruto para valor liquido.
	//aCB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],aDadosTit[6],SE1->E1_SALDO,SE1->E1_VENCTO)
	aCB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],aDadosTit[6],(E1_SALDO -nVlrAbat- E1_DESCFIN + E1_ACRESC - E1_DECRESC),E1_VENCREA)								//Numero do Banco       //Agencia      //Conta       //Digito da Conta
	
	
	If Marked("E1_OK")
		Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
		nX := nX + 1
	EndIf
	SE1->(dbSkip())
	IncProc()
	nI := nI + 1
EndDo
oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir
Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Impress ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASERDO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
LOCAL oFont8
LOCAL oFont11c
LOCAL oFont10
LOCAL oFont14
LOCAL oFont16n
LOCAL oFont15
LOCAL oFont14n
LOCAL oFont24
LOCAL nI := 0
LOCAL _Dig := Alltrim(str(Modulo10(aDadosBAnco[3]+aDadosBanco[4]+aDadosBanco[6]+aDadosTit[6]))) //Digito Verificador
Local nDV  :=Alltrim(str(Modulo10(aDadosBAnco[3]+aDadosBanco[4]+aDadosBanco[6]+aDadosTit[6]))) //Digito Verificador
Local nLin := 0
Local nX   := 0   
Local cNF  := "" 
local cProd:= ""    
Local cMsg := ""
aBitmap_new :=  "\system\logitau2.bmp"
//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont8  := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14  := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oPrint:StartPage()   // Inicia uma nova página

/******************/
/* PRIMEIRA PARTE */
/******************/

nRow1 := 0

oPrint:Line (nRow1+0150,500,nRow1+0070, 500)
oPrint:Line (nRow1+0150,710,nRow1+0070, 710)
oPrint:Say  (nRow1+0084,100,"Banco Itau SA",oFont14 )
oPrint:Say  (nRow1+0075,513,aDadosBanco[1]+"-7",oFont21 )		// [1]Numero do Banco

oPrint:Say  (nRow1+0084,1900,"Comprovante de Entrega",oFont10)
oPrint:Line (nRow1+0150,100,nRow1+0150,2300)

oPrint:Say  (nRow1+0150,100 ,"Cedente",oFont8)
oPrint:Say  (nRow1+0200,100 ,aDadosEmp[1],oFont10)				//Nome + CNPJ

oPrint:Say  (nRow1+0150,1060,"Agência/Código Cedente",oFont8)
oPrint:Say  (nRow1+0200,1060,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)

oPrint:Say  (nRow1+0150,1510,"Nro.Documento",oFont8)
oPrint:Say  (nRow1+0200,1510,aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow1+0250,100 ,"Sacado",oFont8)
oPrint:Say  (nRow1+0300,100 ,SUBSTR(aDatSacado[1],1,43),oFont10)				//Nome

oPrint:Say  (nRow1+0250,1060,"Vencimento",oFont8)
oPrint:Say  (nRow1+0300,1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)

oPrint:Say  (nRow1+0250,1510,"Valor do Documento",oFont8)
oPrint:Say  (nRow1+0300,1550,AllTrim(Transform(aDadosTit[5],"@E 99,999,999.99")),oFont10)

oPrint:Say  (nRow1+0400,0100,"Recebi(emos) o bloqueto/título",oFont10)
oPrint:Say  (nRow1+0450,0100,"com as características acima.",oFont10)
oPrint:Say  (nRow1+0350,1060,"Data",oFont8)
oPrint:Say  (nRow1+0350,1410,"Assinatura",oFont8)
oPrint:Say  (nRow1+0450,1060,"Data",oFont8)
oPrint:Say  (nRow1+0450,1410,"Entregador",oFont8)

oPrint:Line (nRow1+0250, 100,nRow1+0250,1900 )
oPrint:Line (nRow1+0350, 100,nRow1+0350,1900 )
oPrint:Line (nRow1+0450,1050,nRow1+0450,1900 ) //---
oPrint:Line (nRow1+0550, 100,nRow1+0550,2300 )
oPrint:Line (nRow1+0550,1050,nRow1+0150,1050 )
oPrint:Line (nRow1+0550,1400,nRow1+0350,1400 )
oPrint:Line (nRow1+0350,1500,nRow1+0150,1500 ) //--
oPrint:Line (nRow1+0550,1900,nRow1+0150,1900 )

oPrint:Say  (nRow1+0165,1910,"(  )Mudou-se"                                	,oFont8)
oPrint:Say  (nRow1+0205,1910,"(  )Ausente"                                  ,oFont8)
oPrint:Say  (nRow1+0245,1910,"(  )Não existe nº indicado"                  	,oFont8)
oPrint:Say  (nRow1+0285,1910,"(  )Recusado"                                	,oFont8)
oPrint:Say  (nRow1+0325,1910,"(  )Não procurado"                            ,oFont8)
oPrint:Say  (nRow1+0365,1910,"(  )Endereço insuficiente"                  	,oFont8)
oPrint:Say  (nRow1+0405,1910,"(  )Desconhecido"                            	,oFont8)
oPrint:Say  (nRow1+0445,1910,"(  )Falecido"                                 ,oFont8)
oPrint:Say  (nRow1+0485,1910,"(  )Outros(anotar no verso)"                 	,oFont8)


/*****************/
/* SEGUNDA PARTE */
/*****************/

nRow2 := 0

//Pontilhado separador
For nI := 100 to 2300 step 50
	oPrint:Line(nRow2+0580, nI,nRow2+0580, nI+30)
Next nI

oPrint:Line (nRow2+0710,100,nRow2+0710,2300)
oPrint:Line (nRow2+0710,500,nRow2+0630, 500)
oPrint:Line (nRow2+0710,710,nRow2+0630, 710)
oPrint:Say  (nRow2+0644,100,"Banco Itau SA",oFont14 )		// [2]Nome do Banco
oPrint:Say  (nRow2+0635,513,aDadosBanco[1]+"-7",oFont21 )	// [1]Numero do Banco
oPrint:Say  (nRow2+0644,1800,"Recibo do Sacado",oFont10)
oPrint:Line (nRow2+0810,100,nRow2+0810,2300 )
oPrint:Line (nRow2+0910,100,nRow2+0910,2300 )
oPrint:Line (nRow2+0980,100,nRow2+0980,2300 )
oPrint:Line (nRow2+1050,100,nRow2+1050,2300 )
oPrint:Line (nRow2+0910,500,nRow2+1050,500)
oPrint:Line (nRow2+0980,750,nRow2+1050,750)
oPrint:Line (nRow2+0910,1000,nRow2+1050,1000)
oPrint:Line (nRow2+0910,1300,nRow2+0980,1300)
oPrint:Line (nRow2+0910,1480,nRow2+1050,1480)

oPrint:Say  (nRow2+0710,100 ,"Local de Pagamento",oFont8)
oPrint:Say  (nRow2+0725,400 ,"ATÉ O VENCIMENTO, PREFERENCIALMENTE NO ITAÚ.",oFont10)
oPrint:Say  (nRow2+0765,400 ,"APÓS O VENCIMENTO, SOMENTE NO ITAÚ.",oFont10)

oPrint:Say  (nRow2+0710,1810,"Vencimento"                                     ,oFont8)
cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0750,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0810,100 ,"Cedente"                                        ,oFont8)
oPrint:Say  (nRow2+0850,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (nRow2+0810,1810,"Agência/Código Cedente",oFont8)
cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0850,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0910,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say  (nRow2+0940,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

oPrint:Say  (nRow2+0910,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (nRow2+0940,605 ,aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela
oPrint:Say  (nRow2+0910,1005,"Espécie Doc."                                   ,oFont8)
oPrint:Say  (nRow2+0940,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo
oPrint:Say  (nRow2+0910,1305,"Aceite"                                         ,oFont8)
oPrint:Say  (nRow2+0940,1400,"N"                                             ,oFont10)

oPrint:Say  (nRow2+0910,1485,"Data do Processamento"                          ,oFont8)
oPrint:Say  (nRow2+0940,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao



oPrint:Say  (nRow2+0910,1810,"Nosso Número"                                   ,oFont8)
cString := aDadosBanco[6]+"/"+aDadosTit[6]+"-"+_Dig
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0940,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0980,100 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (nRow2+0980,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (nRow2+1010,555 ,aDadosBanco[6]                                  	,oFont10)

oPrint:Say  (nRow2+0980,755 ,"Espécie"                                        ,oFont8)
oPrint:Say  (nRow2+1010,805 ,"R$"                                             ,oFont10)

oPrint:Say  (nRow2+0980,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (nRow2+0980,1485,"Valor"                                          ,oFont8)

oPrint:Say  (nRow2+0980,1810,"Valor do Documento"                          	,oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+1010,nCol,cString ,oFont11c)

oPrint:Say  (nRow2+1050,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
oPrint:Say  (nRow2+1100,100 ,"       ",oFont10)
oPrint:Say  (nRow2+1100,100 ,"Após o vencimento cobrar mora diária de R$ "+AllTrim(Transform(((aDadosTit[5]*0.1)/30),"@E 99,999.99"))+". Protestar após  5 dias corridos do vencimento." ,oFont10)

//oPrint:Say  (nRow2+1150,100 ,"Protestar após  5 dias corridos do vencimento.",oFont10) // 29/10/2013- Renato Ruy - Solicitado por: Ana Paula - Alterar a disposição do texto.
//oPrint:Say  (nRow2+1200,100 ,"Cobrança Escritural",oFont10) // 29/10/2013- Renato Ruy - Solicitado por: Ana Paula - Alterar a disposição do texto.

DbSelectArea("SD2")
DbSetOrder(8)
If SD2->(DbSeek(xFilial("SD2") + SE1->E1_PEDIDO ) )
	cNF := SD2->D2_DOC + SD2->D2_SERIE
	nLin := nRow2+1300
	nX   := 1
	While !SD2->(Eof()) .AND. SE1->E1_PEDIDO == SD2->D2_PEDIDO .AND. nX <= 2
		cProd += AllTRim(StrZero(nX,3) + " " + Posicione("SB1",1,xFilial("SB1") + SD2->D2_COD, "B1_DESC")) + "|"
		SD2->(DbSkip())
	End 
	oPrint:Say  (nLin ,100 ,cProd,oFont8)
EndIf            

oPrint:Say  (nRow2+1150,100 ,"Nota Fiscal Eletrônica: " + SubStr(Posicione("SF2",1,xFilial("SF2") + cNf, "F2_NFELETR"),1,90) ,oFont8)
oPrint:Say  (nRow2+1200,100 ,"Favor atentar-se as retenções de impostos IR, PIS, COFINS e CSLL conforme demonstrado na nota",oFont10)
oPrint:Say  (nRow2+1250,100 ,"fiscal.",oFont10)                                                                                                          
//oPrint:Say  (nRow2+1250,100 ,"fiscal e quando houver incidência lançar no campo (-) outras deduções.",oFont10)                                                                                                          
oPrint:Say  (nRow2+1350,100 ,"Msg.: " + SUBSTR(AllTrim(Posicione("SC5",1,xFilial("SC5") + SE1->E1_PEDIDO, "C5_MENNOTA")),1,93) ,oFont8)

//oPrint:Say  (nRow2+1300,100 ,"",oFont10)
//oPrint:Say  (nRow2+1350,100 ,"",oFont10)

oPrint:Say  (nRow2+1050,1810,"(-)Desconto/Abatimento"                         ,oFont8)
oPrint:Say  (nRow2+1120,1810,"(-)Outras Deduções"                             ,oFont8)
oPrint:Say  (nRow2+1190,1810,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (nRow2+1260,1810,"(+)Outros Acréscimos"                           ,oFont8) 
//cString_ := Alltrim(Transform(aDadosTit[9],"@E 99,999,999.99"))
//nCol := 1810+(374-(len(cString_)*22))
//oPrint:Say  (nRow2+1290,nCol,cString_ ,oFont11c)

oPrint:Say  (nRow2+1330,1810,"(=)Valor Cobrado"                               ,oFont8)   

/*If nVal1 > 0 
	cValCobr := nVal1 + nVal2
	cValCobr := Alltrim(Transform(cValCobr,"@E 99,999,999.99"))
	nCol := 1810+(374-(len(cValCobr)*22))
	oPrint:Say  (nRow2+1360,nCol,cValCobr ,oFont11c)
Else*/ 
cString_ := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol := 1810+(374-(len(cString)*22))
//oPrint:Say  (nRow2+1330,nCol,cString_ ,oFont11c)	 // 29/10/2013 - Renato Ruy - Comentado por requisição da Ana Paula na OTRS
//Endif


oPrint:Say  (nRow2+1400,100 ,"Sacado"                                         ,oFont8)
//oPrint:Say  (nLin	,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (nRow2+1430,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont8)
oPrint:Say  (nRow2+1470,400 ,aDatSacado[3]                                    ,oFont8)
oPrint:Say  (nRow2+1520,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont8) // CEP+Cidade+Estado

if aDatSacado[8] = "J"
	oPrint:Say  (nRow2+1570,400 ,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont8) // CGC
Else
	oPrint:Say  (nRow2+1570,400 ,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont8) 	// CPF
EndIf 


oPrint:Say  (nRow2+1570,1850,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont10)

nLin += 215
//oPrint:Say  (nLin,100 ,"Sacador/Avalista: "                               ,oFont8)   
oPrint:Say  (nRow2+1665,100 ,"Sacador/Avalista: "                               ,oFont8)   
oPrint:Say  (nRow2+1665,1800,"Autenticação Mecânica",oFont8)

oPrint:Line (nRow2+0710,1800,nRow2+1400,1800 )
oPrint:Line (nRow2+1120,1800,nRow2+1120,2300 )
oPrint:Line (nRow2+1190,1800,nRow2+1190,2300 )
oPrint:Line (nRow2+1260,1800,nRow2+1260,2300 )
oPrint:Line (nRow2+1330,1800,nRow2+1330,2300 )

oPrint:Line (nRow2+1400,100 ,nRow2+1400,2300 )
oPrint:Line (nRow2+1650,100 ,nRow2+1650,2300 )

//oPrint:Line (nLin,100 ,nRow2+1400,2300 )
//oPrint:Line (nLin,100 ,nLin,2300 )
//oPrint:Line (nLin + 250,100 ,nRow2+1650,2300 )
//oPrint:Line (nLin + 250,100 ,nLin + 250,2300 )


/******************/
/* TERCEIRA PARTE */
/******************/

nRow3 := 0

For nI := 100 to 2300 step 50
	oPrint:Line(nRow3+1880, nI, nRow3+1880, nI+30)
Next nI

oPrint:Line (nRow3+2000,100,nRow3+2000,2300)
oPrint:Line (nRow3+2000,500,nRow3+1920, 500)
oPrint:Line (nRow3+2000,710,nRow3+1920, 710)

oPrint:Say  (nRow3+1934,100,"Banco Itau SA",oFont14 )		// 	[2]Nome do Banco
oPrint:Say  (nRow3+1925,513,aDadosBanco[1]+"-7",oFont21 )	// 	[1]Numero do Banco
oPrint:Say  (nRow3+1934,755,aCB_RN_NN[2],oFont15n)			//		Linha Digitavel do Codigo de Barras

oPrint:Line (nRow3+2100,100,nRow3+2100,2300 )
oPrint:Line (nRow3+2200,100,nRow3+2200,2300 )
oPrint:Line (nRow3+2270,100,nRow3+2270,2300 )
oPrint:Line (nRow3+2340,100,nRow3+2340,2300 )

oPrint:Line (nRow3+2200,500 ,nRow3+2340,500 )
oPrint:Line (nRow3+2270,750 ,nRow3+2340,750 )
oPrint:Line (nRow3+2200,1000,nRow3+2340,1000)
oPrint:Line (nRow3+2200,1300,nRow3+2270,1300)
oPrint:Line (nRow3+2200,1480,nRow3+2340,1480)

oPrint:Say  (nRow3+2000,100 ,"Local de Pagamento",oFont8)
oPrint:Say  (nRow3+2015,400 ,"ATÉ O VENCIMENTO, PREFERENCIALMENTE NO ITAÚ.",oFont10)
oPrint:Say  (nRow3+2055,400 ,"APÓS O VENCIMENTO, SOMENTE NO ITAÚ.",oFont10)


oPrint:Say  (nRow3+2000,1810,"Vencimento",oFont8)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol	 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2040,nCol,cString,oFont11c)

oPrint:Say  (nRow3+2100,100 ,"Cedente",oFont8)
oPrint:Say  (nRow3+2140,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ    

oPrint:Say  (nRow3+2100,1810,"Agência/Código Cedente",oFont8)
cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2140,nCol,cString ,oFont11c)


oPrint:Say  (nRow3+2200,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say (nRow3+2230,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)


oPrint:Say  (nRow3+2200,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (nRow3+2230,605 ,aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow3+2200,1005,"Espécie Doc."                                   ,oFont8)
oPrint:Say  (nRow3+2230,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo

oPrint:Say  (nRow3+2200,1305,"Aceite"                                         ,oFont8)
oPrint:Say  (nRow3+2230,1400,"N"                                             ,oFont10)

oPrint:Say  (nRow3+2200,1485,"Data do Processamento"                          ,oFont8)
oPrint:Say  (nRow3+2230,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

//Calcula o Digito Verificador


oPrint:Say  (nRow3+2200,1810,"Nosso Número"                                   ,oFont8)
cString  :=  aDadosBanco[6]+"/"+aDadosTit[6]+"-"+_Dig
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2230,nCol,cString,oFont11c)

oPrint:Say  (nRow3+2270,100 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (nRow3+2270,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (nRow3+2300,555 ,aDadosBanco[6]                                  	,oFont10)

oPrint:Say  (nRow3+2270,755 ,"Espécie"                                        ,oFont8)
oPrint:Say  (nRow3+2300,805 ,"R$"                                             ,oFont10)

oPrint:Say  (nRow3+2270,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (nRow3+2270,1485,"Valor"                                          ,oFont8)

oPrint:Say  (nRow3+2270,1810,"Valor do Documento"                          	,oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2300,nCol,cString,oFont11c)

oPrint:Say  (nRow3+2350,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
oPrint:Say  (nRow3+2400,100 ,"       ",oFont10)
oPrint:Say  (nRow3+2400,100 ,"Após o vencimento cobrar mora diária de R$ "+AllTrim(Transform(((aDadosTit[5]*0.1)/30),"@E 99,999.99"))+". Protestar após  5 dias corridos do vencimento.",oFont10)
//oPrint:Say  (nRow3+2450,100 ,"Protestar após  5 dias corridos do vencimento.",oFont10)
//oPrint:Say  (nRow3+2500,100 ,"Cobrança Escritural",oFont10)
   
/*
DbSelectArea("SD2")
DbSetOrder(8)      
SD2->(DbGoTop())
If SD2->(DbSeek(xFilial("SD2") + SE1->E1_PEDIDO ) )
	nLin := nRow3+2600
	nX   := 1
	While !SD2->(Eof()) .AND. SE1->E1_PEDIDO == SD2->D2_PEDIDO
		oPrint:Say  (nLin ,100 ,StrZero(nX,3) + " " + Posicione("SB1",1,xFilial("SB1") + SD2->D2_COD, "B1_DESC"),oFont8)
		nLin += 050
		nX ++
		SD2->(DbSkip())
	End
EndIf*/
nLin := nRow3+2600
oPrint:Say  (nLin ,100 ,cProd,oFont8)   
oPrint:Say  (nRow2+2650,100 ,"Msg. do Pedido: " + SUBSTR(AllTrim(Posicione("SC5",1,xFilial("SC5") + SE1->E1_PEDIDO, "C5_MENNOTA")),1,83) ,oFont8)
//oPrint:Say  (nRow2+2550,100 ,"Nota Fiscal Eletrônica: " + Posicione("SF2",1,xFilial("SF2") + cNf, "F2_NFELETR") ,oFont8)

oPrint:Say  (nRow2+2450,100 ,"Nota Fiscal Eletrônica: " + SubStr(Posicione("SF2",1,xFilial("SF2") + cNf, "F2_NFELETR"),1,90) ,oFont8)
oPrint:Say  (nRow2+2500,100 ,"Favor atentar-se as retenções de impostos IR, PIS, COFINS e CSLL conforme demonstrado na nota",oFont10)
oPrint:Say  (nRow2+2550,100 ,"fiscal.",oFont10)  


//oPrint:Say  (nRow3+2600,100 ,"",oFont10)
//oPrint:Say  (nRow3+2650,100 ,"",oFont10)

oPrint:Say  (nRow3+2340,1810,"(-)Desconto/Abatimento"                         ,oFont8)
oPrint:Say  (nRow3+2410,1810,"(-)Outras Deduções"                             ,oFont8)
oPrint:Say  (nRow3+2480,1810,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (nRow3+2550,1810,"(+)Outros Acréscimos"                           ,oFont8) 
//cString_ := Alltrim(Transform(aDadosTit[9],"@E 99,999,999.99"))
//nCol := 1810+(374-(len(cString_)*22))
//oPrint:Say  (nRow2+2580,nCol,cString_ ,oFont11c)


oPrint:Say  (nRow3+2620,1810,"(=)Valor Cobrado"                               ,oFont8)
/*If nVal1 > 0 
	cValCobr := nVal1 + nVal2
	cValCobr := Alltrim(Transform(cValCobr,"@E 99,999,999.99"))
	nCol := 1810+(374-(len(cValCobr)*22))
	oPrint:Say  (nRow2+2650,nCol,cValCobr ,oFont11c)
Else */
cString_ := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol := 1810+(374-(len(cString)*22))
//oPrint:Say  (nRow2+2650,nCol,cString_ ,oFont11c)	
//Endif

oPrint:Say  (nRow3+2690,100 ,"Sacado"                                         ,oFont8)
//oPrint:Say  (nLin,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (nRow3+2700,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont8)

if aDatSacado[8] = "J"
	oPrint:Say  (nRow3+2700,1750,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont8) // CGC
Else
	oPrint:Say  (nRow3+2700,1750,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont8) 	// CPF
EndIf

oPrint:Say  (nRow3+2740,400 ,aDatSacado[3]                                    ,oFont8)
oPrint:Say  (nRow3+2780,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont8) // CEP+Cidade+Estado
oPrint:Say  (nRow3+2780,1750,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont8)

nLin += 135
//oPrint:Say  (nRow3+2825,100 ,"Sacador/Avalista: "                                ,oFont8)
oPrint:Say  (nLin,100 ,"Sacador/Avalista: "                                ,oFont8)
oPrint:Say  (nRow3+2870,1500,"Autenticação Mecânica - Ficha de Compensação"                        ,oFont8)

oPrint:Line (nRow3+2000,1800,nRow3+2690,1800 )
oPrint:Line (nRow3+2410,1800,nRow3+2410,2300 )
oPrint:Line (nRow3+2480,1800,nRow3+2480,2300 )
oPrint:Line (nRow3+2550,1800,nRow3+2550,2300 )
oPrint:Line (nRow3+2620,1800,nRow3+2620,2300 )

oPrint:Line (nRow3+2690,100 ,nRow3+2690,2300 )
oPrint:Line (nRow3+2860,100,nRow3+2860,2300  )

//MSBAR("INT25",14.80,1,aCB_RN_NN[2],oPrint,.F.,nil,nil,0.0140,0.79,NIL,NIL,NIL,.F.)0.029629,1.65
//MSBAR("INT25",15.2,1.7,aCB_RN_NN[2],oPrint,.F.,nil,nil,0.022,1.40,NIL,NIL,NIL,.F.)
//MSBAR("INT25",13.20,1,aCB_RN_NN[2],oPrint,.F.,nil,nil,0.0140,0.79,NIL,NIL,NIL,.F.)
MSBAR( "INT25",25  ,1.5 ,aCB_RN_NN[1],oPrint,.F.   ,     ,     ,      ,1.3    ,      ,      ,     ,.F.)
//MSBAR( "INT25",27  ,1.5 ,aCB_RN_NN[1],oPrint,.F.   ,     ,     ,      ,1.3    ,      ,      ,     ,.F.)
oPrint:EndPage() // Finaliza a página

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo10 ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo10(cData)
LOCAL L,D,P := 0
LOCAL B     := .F.
L := Len(cData)
B := .T.
D := 0
While L > 0
	P := Val(SubStr(cData, L, 1))
	If (B)
		P := P * 2
		If P > 9
			P := P - 9
		End
	End
	D := D + P
	L := L - 1
	B := !B
End
D := 10 - (Mod(D,10))
If D = 10
	D := 0
End
Return(D)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo11 ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO ITAU COM CODIGO DE BARRAS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11(cData)
LOCAL L, D, P := 0
L := Len(cdata)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End
D := 11 - (mod(D,11))
If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
	D := 1
End
Return(D)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Ret_cBarra³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto)

LOCAL cValorFinal := strzero(nValor*100,10)
LOCAL nDvnn			:= 0
LOCAL nDvcb			:= 0
LOCAL nDv			:= 0
LOCAL cNN			:= ''
LOCAL cRN			:= ''
LOCAL cCB			:= ''
LOCAL cS			:= ''
LOCAL cFator        := strzero(dVencto - ctod("07/10/97"),4)
Local cCart         := aDadosBanco[6]
//-----------------------------
// Definicao do NOSSO NUMERO
// ----------------------------
cS    :=  cAgencia + cConta + cCart + cNroDoc
nDvnn := modulo10(cS) // digito verifacador Agencia + Conta + Carteira + Nosso Num
cNN   := cCart + cNroDoc + '-' + AllTrim(Str(nDvnn))

//----------------------------------
//	 Definicao do CODIGO DE BARRAS
//----------------------------------
cS:= cBanco + cFator +  cValorFinal + Subs(cNN,1,11) + Subs(cNN,13,1) + cAgencia + cConta + cDacCC + '000'
nDvcb := modulo11(cS)
cCB   := SubStr(cS, 1, 4) + AllTrim(Str(nDvcb)) + SubStr(cS,5,25) + AllTrim(Str(nDvnn))+ SubStr(cS,31)

//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.CCDDX		DDDDD.DDFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV

// 	CAMPO 1:
//	AAA	= Codigo do banco na Camara de Compensacao
//	  B = Codigo da moeda, sempre 9
//	CCC = Codigo da Carteira de Cobranca
//	 DD = Dois primeiros digitos no nosso numero
//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

cS    := cBanco + cCart + SubStr(cNroDoc,1,2)
nDv   := modulo10(cS)
cRN   := SubStr(cS, 1, 5) + '.' + SubStr(cS, 6, 4) + AllTrim(Str(nDv)) + '  '

// 	CAMPO 2:
//	DDDDDD = Restante do Nosso Numero
//	     E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
//	   FFF = Tres primeiros numeros que identificam a agencia
//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

cS :=Subs(cNN,6,6) + Alltrim(Str(nDvnn))+ Subs(cAgencia,1,3)
nDv:= modulo10(cS)
cRN := Subs(cBanco,1,3) + "9" + Subs(cCart,1,1)+'.'+ Subs(cCart,2,3) + Subs(cNN,4,2) + SubStr(cRN,11,1)+ ' '+  Subs(cNN,6,5) +'.'+ Subs(cNN,11,1) + Alltrim(Str(nDvnn))+ Subs(cAgencia,1,3) +Alltrim(Str(nDv)) + ' '

// 	CAMPO 3:
//	     F = Restante do numero que identifica a agencia
//	GGGGGG = Numero da Conta + DAC da mesma
//	   HHH = Zeros (Nao utilizado)
//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
cS    := Subs(cAgencia,4,1) + Subs(cConta,1,4) +  Subs(cConta,5,1)+Alltrim(cDacCC)+'000'
nDv   := modulo10(cS)
cRN   := cRN + Subs(cAgencia,4,1) + Subs(cConta,1,4) +'.'+ Subs(cConta,5,1)+Alltrim(cDacCC)+'000'+ Alltrim(Str(nDv))

//	CAMPO 4:
//	     K = DAC do Codigo de Barras
cRN   := cRN + ' ' + AllTrim(Str(nDvcb)) + '  '

// 	CAMPO 5:
//	      UUUU = Fator de Vencimento
//	VVVVVVVVVV = Valor do Titulo
cRN   := cRN + cFator + StrZero(nValor * 100,14-Len(cFator))

Return({cCB,cRN,cNN})


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSx1    ³ Autor ³ Microsiga            	³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica/cria SX1 a partir de matriz para verificacao          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                    	  		³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1(cPerg, aPergs)

Local _sAlias	:= Alias()
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local nCondicao
Local cKey		:= ""
Local nJ			:= 0

aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aPergs)
	lAltera := .F.
	If MsSeek(cPerg+Right(aPergs[nX][11], 2))
		If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
			Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif
	Endif
	
	If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]
		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
	Endif
	
	If ! Found() .Or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(aPergs[nX][11], 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
		cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."
		
		If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
			aHelpSpa := aPergs[nx][Len(aPergs[nx])]
		Else
			aHelpSpa := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
			aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
		Else
			aHelpEng := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
			aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
		Else
			aHelpPor := {}
		Endif
		
		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	Endif
Next
