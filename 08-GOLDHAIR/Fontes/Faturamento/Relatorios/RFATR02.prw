#Include "Protheus.ch"
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATR02   º Autor ³ Anderson Goncalves º Data ³  24/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Impressao de duplicatas                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Goldhair                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFATR02(cAlias,nReg,nOpc)  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis da Rotina                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
Local cString   	:= "SE1"  
Local aAreaSE1		:= SE1->(GetArea())

Private Titulo   	:= "Impressão de Duplicatas"
Private nLastKey 	:= 0
Private cPerg    	:= "RFTR02"
Private NomeProg 	:= FunName()
Private nColMax  	:= 3400
Private nColMin  	:= 035
Private nLinMax  	:= 2200
Private nLin     	:= 100

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no registro                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
dbSelectArea("SE1")
Se1->(dbSetOrder(1))
SE1->(dbGoTo(nReg)) 

m_pag := 1
wnrel := FunName()            //Nome Default do Relatório em Disco   

If FunName() $ "FINA740/FINA040"
	Processa({|| CursorWait(),RFATR02a(Titulo),CursorArrow()},"Imprimindo Duplicatas, Aguarde...") 
Else
	RFATR02a(Titulo)
EndIf

RestArea(aAreaSE1)

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATR02a  º Autor ³ Anderson Goncalves º Data ³  24/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cria os Objetos para o Relatorio Grafico.                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Goldhair                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RFATR02a(Titulo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis da Rotina                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
Private i      := 1
Private x      := 0
Private nLin   := 3000

Private oFont06  := tFont():New("ARIAL",06,06,,.f.,,,,.t.,.f.)
Private oFont06N := tFont():New("ARIAL",06,06,,.t.,,,,.t.,.f.)
Private oFont08  := tFont():New("ARIAL",08,08,,.f.,,,,.t.,.f.)
Private oFont08N := tFont():New("ARIAL",08,08,,.t.,,,,.t.,.f.)
Private oFont09  := tFont():New("ARIAL",09,09,,.f.,,,,.t.,.f.)
Private oFont09N := tFont():New("ARIAL",09,09,,.t.,,,,.t.,.f.)
Private oFont10  := tFont():New("ARIAL",10,10,,.f.,,,,.t.,.f.)
Private oFont10N := tFont():New("ARIAL",10,10,,.t.,,,,.t.,.f.)
Private oFont11  := tFont():New("ARIAL",11,11,,.f.,,,,.t.,.f.)
Private oFont11N := tFont():New("ARIAL",11,11,,.t.,,,,.t.,.f.)
Private oFont12  := tFont():New("ARIAL",12,12,,.f.,,,,.t.,.f.)
Private oFont12N := tFont():New("ARIAL",12,12,,.t.,,,,.t.,.f.)
Private oFont14  := tFont():New("ARIAL",14,14,,.f.,,,,.t.,.f.)
Private oFont14N := tFont():New("ARIAL",14,14,,.t.,,,,.t.,.f.)
Private oFont16  := tFont():New("ARIAL",16,16,,.f.,,,,.t.,.f.)
Private oFont16N := tFont():New("ARIAL",16,16,,.t.,,,,.t.,.f.)
Private oFont18  := tFont():New("ARIAL",18,18,,.f.,,,,.t.,.f.)
Private oFont18N := tFont():New("ARIAL",18,18,,.t.,,,,.t.,.f.)    

If FunName() $ "FINA740/FINA040" 
	
	Private oPrint := Nil
	
	oPrint  := TMSPrinter():New(Titulo)
	//oPrint  :SetLandScape()					//Modo paisagem
	oPrint:SetPortrait()                   //Modo retrato

	If !oPrint:IsPrinterActive()
		oPrint:Setup()
	EndIf

	If !oPrint:IsPrinterActive()
		Aviso("Atenção","Não foi Possível Imprimir o Relatório, pois não há Nenhuma Impressora Conectada.",{"OK"})
		Return(Nil)
	EndIf    
	
	lEncerra := .T.
	
EndIf

nLin := RFATR02b(oPrint,i,Titulo)   

If FunName() $ "FINA740/FINA040" 
	oPrint:Preview() 
	//oPrint:SaveAllAsJPEG("TFATR09",1000,700,100)     
	Set Device To Screen
	MS_FLUSH()
	oPrint := Nil 
EndIf

//oPrint:SaveAllAsJPEG("\system2\TFATR09")
/*
SaveAllAsJPEG(<cArquivo>,<nLargura>,<nAltura>,<nZoom>), onde:

cArquivo --> Nome do Arquivo JPEG a ser Gerado
nLargura --> Largura da Imagem em Píxels (Padrão ==  700)
nAltura  --> Altura da Imagem em Píxels  (Padrão == 1000)
nZoom    --> % de Ampliação da Imagem    (Padrão ==  100)
*/

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATR02b  º Autor ³ Anderson Goncalves º Data ³  24/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Impressão do Detalhe do Relatorio                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Goldhair                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RFATR02b(oPrint,i,Titulo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis da Rotina                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
Local x
Local nConta := 0       

Private lFirstPage := .t.
Private _lOk       := .f.
Private nTime	    := Time()
Private acol       := {900,1100,1300,1600,1850}   

mv_par01 := SE1->E1_PREFIXO
mv_par02 := SE1->E1_NUM
mv_par03 := SE1->E1_NUM
mv_par04 := 2 
mv_par05 := SE1->E1_PARCELA

DbSelectArea("SE1")
DbSetOrder(1)
DbSeek(xFilial("SE1")+ mv_par01+mv_par02+mv_par05,.t.) 

nConta := val(mv_par03) - val(mv_par02)

If FunName() $ "FINA040/FINA740"
	ProcRegua(RecCount(nConta)) 
EndIf

While SE1->(!EOF()) .and. SE1->E1_PREFIXO == MV_PAR01 .and. SE1->E1_NUM <= mv_par03 .and. SE1->E1_PARCELA == mv_par05  

	If FunName() $ "FINA040/FINA740"
		IncProc(SE1->E1_NUM +" "+SE1->E1_PARCELA) 
	EndIf
		
	oPrint:StartPage()   // Inicia uma nova página
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Quadro da Duplicata                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	oPrint:Line(040,070,040,2330)
	oPrint:Line(040,070,1465,070)
	oPrint:Line(040,2330,1465,2330)
	oPrint:Line(1465,070,1465,2330)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Linha e divisao da empresa                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	oPrint:Line(420,070,420,2330)
	oPrint:Line(040,1510,420,1510) 
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Identificacao da empresa                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	cLogo 	:= "" 
	cAss	:= ""
	aAreaSM0 := SM0->(GetArea())
	dbSelectArea("SM0")
	SM0->(dbSetOrder(1)) 
	
	cLogo := "\system\logo_Goldhair.bmp" 
	cAss := "\system\assGoldhair.bmp"  
	cCnpj 	:= AllTrim(SM0->M0_CGC)
	cIE 	:= AllTrim(SM0->M0_INSC)
 	//oPrint:SayBitmap(050,120,cLogo,1210,370) 
	cRazao	:= AllTrim(SM0->M0_NOMECOM)
	
	RestArea(aAreaSM0)	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Assinatura do emitente                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	oPrint:SayBitMap(450,210,cAss,220,1000) 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Escurecer Campos                                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	oPrint:SayBitMap(550,890,"\system\escurecer.bmp",420,110)
	oPrint:SayBitMap(550,1570,"\system\escurecer.bmp",350,110)
	oPrint:SayBitMap(1070,670,"\system\escurecer.bmp",1250,150)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Quadro para uso da instituicao financeira                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	oPrint:Line(470,1930,470,2310)
	oPrint:Line(470,1930,820,1930)
	oPrint:Line(470,2310,820,2310)
	oPrint:Line(820,1930,820,2310)
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Dados do sacado e valor por extenso                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	oPrint:Line(700,480,700,1920)
	oPrint:Line(700,480,1220,480)
	oPrint:Line(700,1920,1220,1920)
	oPrint:Line(1220,480,1220,1920)
	oPrint:Line(1070,670,1220,670)
	oPrint:Line(1070,480,1070,1920)
	
  	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valor da duplicata e vencimento                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
  	oPrint:Line(470,480,470,1920)
  	oPrint:Line(470,480,660,480)
  	oPrint:Line(470,890,660,890)
  	oPrint:Line(470,1310,660,1310)
  	oPrint:Line(470,1570,660,1570)
  	oPrint:Line(470,1920,660,1920)
  	oPrint:Line(660,480,660,1920)
  	oPrint:Line(550,480,550,1920)
   
  	oPrint:Say(1240,480 ,OemToAnsi("RECONHECEREI A EXATIDÃO DESTA DUPLICATA DE VENDA MERCANTIL, NA IMPORTÂNCIA ACIMA, QUE PAGAREI(REMOS) À ") ,oFont08)
  	oPrint:Say(1280,480 ,OemToAnsi(cRazao+" OU A SUA ORDEM NA PRAÇA E VENCIMENTO(S) INDICADO(S).") ,oFont08)
  
  	oPrint:Say(490,530  ,OemToAnsi("N.F. Fatura Nº"),oFont14N)
  	oPrint:Say(470,930  ,OemToAnsi("N.F. Fatura Duplicata"),oFont10N)
	oPrint:Say(510,1030 ,OemToAnsi("Valor R$") ,oFont10N)
	oPrint:Say(470,1370 ,OemToAnsi("Duplicata"),oFont10N)
	oPrint:Say(510,1370 ,OemToAnsi("nº ordem"), oFont10N)
    oPrint:Say(490,1610 ,OemToAnsi("Vencimento"),oFont14N) 
	   
   	//oPrint:Say(070,100  ,OemToAnsi("RAUDI INDÚSTRIA E COMÉRCIO LTDA."),oFont16N)
   	//oPrint:Say(160,100  ,OemToAnsi("Estrada Divisória - Parte Ideal do Lote 29 - Juranda") ,oFont16N)
   	//oPrint:Say(250,100  ,OemToAnsi("São Carlos do Ivaí - PR - CEP 87770-000") ,oFont16N) 
   	//oPrint:Say(340,100  ,OemToAnsi("Fone (44) 3438-8300           FAX (44) 3438-8301") ,oFont16N) 
	   
   	oPrint:Say(1360,480 ,OemToAnsi("EM ______/______/______                                          ___________________________________"),oFont10N)
   	oPrint:Say(1400,480 ,OemToAnsi("       DATA DO ACEITE                                                           ASSINATURA DO SACADO") ,oFont10N) 
	   
   	oPrint:Say(480,2050 , OemToAnsi("PARA USO DA"),oFont08N)
   	oPrint:Say(510,2060 , OemToAnsi("INSTITUIÇÃO"),oFont08N)
   	oPrint:Say(540,2060 , OemToAnsi("FINANCEIRA") ,oFont08N)
	   
   	oPrint:Say(1100,500 , OemToAnsi("VALOR") ,oFont08N)
   	oPrint:Say(1140,500 , OemToAnsi("POR") ,oFont08N)
   	oPrint:Say(1180,500 , OemToAnsi("EXTENSO") ,oFont08N)
	   
   	oPrint:Say(740,500 	, OemToAnsi("NOME DO SACADO:"),oFont09N)
   	oPrint:Say(800,500  	, OemToAnsi("ENDEREÇO:")  ,oFont09N)
   	oPrint:Say(860,500  	, OemToAnsi("MUNICIPIO:") ,oFont09N)
   	oPrint:Say(860,1200 	, OemToAnsi("UF:")   ,oFont09N)
   	oPrint:Say(860,1350 	, OemToAnsi("CEP:")   ,oFont09N)
   	oPrint:Say(920,500  	, OemToAnsi("PRAÇA PAGTO.:")  ,oFont09N)
   	oPrint:Say(980,500  	, OemToAnsi("CNPJ:")   ,oFont09N)
   	oPrint:Say(980,1340 	, OemToAnsi("I.E.:")   ,oFont09N)   
      
 	nLin := 200
	
	DbSelectArea("SE1")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Informacoes do emitente e dados da fatura                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrint:Say(090,0110, OemToAnsi("Emitente: "),oFont10N)   
	oPrint:Say(090,0310, SM0->M0_NOMECOM,oFont10)
	oPrint:Say(145,0110, OemToAnsi("Endereço: ") ,oFont10N) 
	oPrint:Say(145,0310, AllTrim(SM0->M0_ENDCOB)+" - "+AllTrim(SM0->M0_BAIRCOB) ,oFont10)
	oPrint:Say(200,0110,OemToAnsi("Cep:"),oFont10N)
	oPrint:Say(200,0310,TransForm(SM0->M0_CEPCOB,"@R 99999-999")+" - "+AllTrim(SM0->M0_CIDCOB)+" - "+AllTrim(SM0->M0_ESTCOB),oFont10)
	oPrint:Say(255,0110 ,OemToAnsi("Tel:"),oFont10N)
	oPrint:Say(255,0310 ,SM0->M0_TEL,oFont10)
		
	oPrint:Say(090,1540, OemToAnsi("CNPJ: ")+TransForm(cCnpj,"@R 99.999.999/9999-99"),oFont12N)
	oPrint:Say(145,1540, OemToAnsi("I.E.: ")+TransForm(cIE,"@R 999.999.999.999") ,oFont12N)
	oPrint:Say(200,1540,OemToAnsi("Natureza da Operação:"),oFont12N)
	oPrint:Say(200,2030,OemToAnsi(""),oFont12)
	oPrint:Say(255,1540 ,OemToAnsi("Via de Transporte:"),oFont12N)
	oPrint:Say(255,1940 ,OemToAnsi("Rodoviário"),oFont12)
	nLin += 110
	oPrint:Say(310,1540,OemToAnsi("Data da Emissão:"),oFont12N)
	oPrint:Say(310,1920,OemToAnsi(Transform(SE1->E1_EMISSAO,"@D")),oFont12)
	nLin += 287
	oPrint:Say(nLin,620  ,OemToAnsi(SE1->E1_NUM),oFont11N)
	oPrint:Say(nLin,1020  ,OemToAnsi(Transform(SE1->E1_VALOR, "@E 999,999,999.99")),oFont11N)
	oPrint:Say(nLin,1320 ,OemToAnsi(SE1->E1_NUM+" "+SE1->E1_PARCELA),oFont11N)
	oPrint:Say(nLin,1650 ,OemToAnsi(Transform(SE1->E1_VENCTO, "@D")),oFont11N)

	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)

	nLin += 125
	oPrint:Say(740,820 ,OemToAnsi(SA1->A1_NOME),oFont08) 
	nLin += 60
	 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime dados do sacado                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	If !Empty (SA1->A1_ENDCOB)
		oPrint:Say(800,720  ,OemToAnsi(SA1->A1_ENDCOB),oFont08)
		nLin += 60
		oPrint:Say(860,690  ,OemToAnsi(SA1->A1_MUNC)  ,oFont08)
		oPrint:Say(860,1280 ,OemToAnsi(SA1->A1_ESTC)  ,oFont08)
		oPrint:Say(860,1440 ,OemToAnsi(Transform(SA1->A1_CEPC, "@R 99999-999")),oFont08)
		nLin += 60
		oPrint:Say(920,770  ,OemToAnsi(AllTrim(SA1->A1_MUNC)+" "+"/"+" "+SA1->A1_ESTC),oFont08)
	Else
		oPrint:Say(800,720  ,OemToAnsi(SA1->A1_END),oFont08)
		nLin += 60
		oPrint:Say(860,690  ,OemToAnsi(SA1->A1_MUN),oFont08)
		oPrint:Say(860,1280 ,OemToAnsi(SA1->A1_EST),oFont08)
		oPrint:Say(860,1440 ,OemToAnsi(Transform(SA1->A1_CEP, "@R 99999-999")),oFont08)
		nLin += 60
		oPrint:Say(920,770  ,OemToAnsi(SA1->A1_MUN+" "+"/"+" "+SA1->A1_EST),oFont08)
	Endif
	
	nLin += 60
	oPrint:Say(980,615 ,OemToAnsi(Transform(SA1->A1_CGC, "@R 99.999.999/9999-99")),oFont08)
	oPrint:Say(980,1410,OemToAnsi(SA1->A1_INSCR),oFont08)
	nLin += 129
	
	dbSelectArea("SE1")   
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do valor por extenso                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
	x := EXTENSO(SE1->E1_VALOR)                                                                        
	oPrint:Say(nLin,701,OemToAnsi(Subs(RTRIM(SUBS(x,1,60))+ Replicate ("*",59),1,59)),oFont09)
	nLin += 50
	oPrint:Say(nLin,701,OemToAnsi(Subs(RTRIM(SUBS(x,60,60))+ Replicate ("*",59),1,59)),oFont09)
	nLin += 50
	oPrint:Say(nLin,701,OemToAnsi(Subs(RTRIM(SUBS(x,120,60))+ Replicate ("*",59),1,59)),oFont09)
	nLin += 50
	
	oPrint:EndPage()				// Finaliza a Página
	dbSelectArea("SE1")
	SE1->(dbSkip())
           
Enddo
	
Return Nil