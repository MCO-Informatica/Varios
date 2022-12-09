#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99
#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFIN003   ºAutor  ³CM                  º Data ³  26/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³DUPLICATA LASER                                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP 8.11 - ESPECIFICO MINEXCO                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function RFIN003()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private Tamanho  := "M"
Private titulo   := "Impressao de Fatura Laser"
Private cDesc1   := "Este programa destina-se a impressao da Fatura Laser."
Private cDesc2   := ""
Private cDesc3   := ""
Private cString  := "SE1"
Private wnrel    := "Fatura Laser"
Private cPerg     :="RFIN3"
Private aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }

//+--------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas                           ¦
//+--------------------------------------------------------------+
//+---------------------------------------------+
//¦ Variaveis utilizadas para parametros	    ¦
//¦ cPerg "RFIN3"                        	    ¦
//¦ mv_par01		// Duplicata		        ¦
//¦ mv_par02		// Prefixo                	¦
//¦ mv_par03		// Parcela                	¦
//+---------------------------------------------+

Pergunte("RFIN3",.T.)

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

dbSelectArea("SE1")
dbSetOrder(1)
If dbSeek(Xfilial("SE1") + mv_par02 + mv_par01 + mv_par03,.f. ) // Chave de Busca Filial + Prefixo + Numero + Parcela
//	If SE1->E1_FATURA <> "NOTFAT"
		
//		Alert ("Título " + mv_par02 + "-" + mv_par01 + "-" +  mv_par03 +" não é uma fatura! Verifique os parametros informados. ")
		
//	Else
		MontaRel()
//	Endif
	
EndIf


Return()


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MontaRel ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaRel()
Local oPrint
Local aDadosTit
Local aDatSacado
Local aDadosEmp
Local aTitFatura := {}

oPrint:= TMSPrinter():New( "Duplicata Laser" )
oPrint:SetPortrait() 							// ou SetLandscape()
oPrint:StartPage()   							// Inicia uma nova página

aDadosEmp    :={	SM0->M0_NOME,;									      		//[1]Nome da Empresa
SM0->M0_ENDCOB,; 																//[2]Endereço
AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB,; 	//[3]Complemento
"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3),; 				//[4]CEP
"PABX/FAX: "+SM0->M0_TEL,; 														//[5]Telefones
"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+; 				//[6]
Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+; 						//[6]
Subs(SM0->M0_CGC,13,2),; 														//[6]CGC
"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+; 				//[7]
Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }   //[7]I.E

aDadosTit	:={		AllTrim(E1_NUM)+ "-" +AllTrim(E1_PARCELA),;// [1] Número do título
E1_EMISSAO,;  								// [2] Data da emissão do título
E1_VENCTO,;  								// [3] Data do vencimento
E1_SALDO,;  								// [4] Valor do título
E1_PREFIXO,;  								// [5] Prefixo da NF
E1_TIPO	}   								// [6] Tipo do Titulo

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek( xFilial("SA1")+ SE1->E1_CLIENTE + SE1->E1_LOJA ,.f.)

If Empty(SA1->A1_ENDCOB)
	aDatSacado 	:={	AllTrim(SA1->A1_NOME),;      			// [1]Razão Social
	AllTrim(SA1->A1_COD )+" - "+SA1->A1_LOJA,;    			// [2]Código
	AllTrim(SA1->A1_END )+" - "+AllTrim(SA1->A1_BAIRRO),;	// [3]Endereço
	AllTrim(SA1->A1_MUN ),;  								// [4]Cidade
	SA1->A1_EST,;     										// [5]Estado
	SA1->A1_CEP,;      										// [6]CEP
	SA1->A1_CGC,;  											// [7]CGC
	SA1->A1_INSCR,;  										// [8]IE
	SA1->A1_PESSOA }       								   	// [9]PESSOA
Else
	aDatSacado	:={	AllTrim(SA1->A1_NOME),;				   	// [1]Razão Social
	AllTrim(SA1->A1_COD )+" - "+SA1->A1_LOJA,;			   	// [2]Código
	AllTrim(SA1->A1_ENDCOB)+" - "+AllTrim(SA1->A1_BAIRROC),;// [3]Endereço
	AllTrim(SA1->A1_MUNC),;								   	// [4]Cidade
	SA1->A1_ESTC,;											// [5]Estado
	SA1->A1_CEPC,;											// [6]CEP
	SA1->A1_CGC,;											// [7]CGC
	SA1->A1_INSCR,;											// [8]IE
	SA1->A1_PESSOA }										// [9]PESSOA
Endif

DbSelectArea("SE1")
DbSetOrder(1) //NickName

//Alterado para Compor os títulos que compoe a Fatura para serem impressos na Fatura 31/03/2007 por CM
If DbSeek(xFilial("SE1") +  mv_par02 + mv_par01 )
	Do While !Eof() .And. mv_par02 == SE1->E1_FATPREF .And. mv_par01 == SE1->E1_FATURA
		AADD(aTitFatura, SE1->E1_NUM +"/"+  SE1->E1_PARCELA )
		DbSkip()
		Loop
	EndDo
EndIF

Impress(oPrint,aDadosEmp,aDadosTit,aTitFatura,aDatSacado)

oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir

Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Impress ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³  														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aTitFatura,aDatSacado)
LOCAL oFont8
LOCAL oFont11c
LOCAL oFont10
LOCAL oFont14
LOCAL oFont16n
LOCAL oFont15
LOCAL oFont14n
LOCAL oFont24
Local cFiltro :=  "" + MV_PAR04 + ""
Private cLogo1  := "mlogo.bmp"
Private cLogo2  := "dados.bmp"
Private nNumFat := 0
Private nx      := 0


//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont8   := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe valor a ser cobrado na fatura                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aDadosTit[4] > 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicia pagina                                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrint:StartPage()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cabeçalho da Duplicata                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrint:Line ( 0150 , 0100 , 0150 , 2350 )
	oPrint:Line ( 0150 , 0100 , 0600 , 0100 )
	oPrint:Line ( 0150 , 2350 , 0600 , 2350 )
	oPrint:SayBitmap( 0160 , 0110 , cLogo1 , 1100 , 550)
	oPrint:SayBitmap( 0160 , 1200 , cLogo2 , 1100 , 450)
	oPrint:Line ( 0600 , 0100 , 0600 , 2350 )
	oPrint:Say  ( 0605 , 0100 , "www.minexco.com.br",oFont11c)	 //Site Minexco
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Corpo da Duplicata                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrint:Line ( 0650 , 0100 , 0650 , 2350 ) // --------
	oPrint:Line ( 0650 , 0100 , 0850 , 0100 ) // |
	oPrint:Line ( 0850 , 0100 , 0850 , 2350 ) // --------
	oPrint:Line ( 0650 , 2350 , 0850 , 2350 ) //         |
	oPrint:Line ( 0720 , 0100 , 0720 , 2350 ) // --------
	
	oPrint:Say  ( 0680 , 0115 , "NF Numero"                  ,oFont10)
	oPrint:Say  ( 0680 , 0410 , "Duplicata Valor(R$)"        ,oFont10)
	oPrint:Say  ( 0680 , 1050 , "Duplicata-Ordem"            ,oFont10)
	oPrint:Say  ( 0680 , 1700 , "Vencimento"			      ,oFont10)
	oPrint:Say  ( 0680 , 2050 , "Uso Inst. Finan."           ,oFont10)
	
	oPrint:Line ( 0650 , 0400 , 0850 , 0400 ) //  |
	oPrint:Line ( 0650 , 0800 , 0850 , 0800 ) //    |
	oPrint:Line ( 0650 , 1600 , 0850 , 1600 ) //      |
	oPrint:Line ( 0650 , 2000 , 0850 , 2000 ) //        |
	
	
	dbSelectArea("SE1")
	dbSetOrder(1)
	dbSeek(Xfilial("SE1") + mv_par02 + mv_par01 + mv_par03,.f. ) // Chave de Busca Filial + Prefixo + Numero + Parcela
	
	
	If SE1->E1_FATURA <> mv_par01
		oPrint:Say  ( 0760 , 0115 , cFiltro             ,oFont14)
	EndIf
	
	IF cFiltro = SE1->E1_FATURA
		
		oPrint:Say  ( 0760 , 0115 , SE1->E1_NUM             ,oFont14)
	EndIf
	
	
	
	oPrint:Say  ( 0760 , 0450 , "R$" + Alltrim(Transform(aDadosTit[4],"@E 99,999,999.99"))   ,oFont14)
	oPrint:Say  ( 0760 , 1050 , aDadosTit[1]                  ,oFont14)
	oPrint:Say  ( 0760 , 1700 , DTOC(aDadosTit[3])	           ,oFont14)
	
	oPrint:Line ( 0880 , 0100 , 0880 , 2350 ) // --------
	oPrint:Line ( 1000 , 0100 , 1000 , 2350 ) // --------
	oPrint:Line ( 0880 , 0100 , 1660 , 0100 ) // |
	oPrint:Line ( 0880 , 2350 , 1660 , 2350 ) //         |
	oPrint:Line ( 0880 , 0400 , 1660 , 0400 ) //   |
	
	oPrint:Say  ( 0910 , 0115 , "Nome Sacado"                 ,oFont10)
	oPrint:Say  ( 0900 , 0450 , aDatSacado[1]                 ,oFont14)
	
	oPrint:Say  ( 1100 , 0115 , "End. Sacado"                 ,oFont10)
	oPrint:Say  ( 1040 , 0450 , aDatSacado[3]                 ,oFont10) //End. Sacado
	oPrint:Say  ( 1100 , 0450 , aDatSacado[4] + "  " + aDatSacado[5] + "  " + Substr(aDatSacado[6],1,5) + "-" + Substr(aDatSacado[6],6,3) ,oFont10)  //Cidade , Estado e CEP
	oPrint:Line ( 1180 , 0100 , 1180 , 2350 ) // --------
	
	oPrint:Say  ( 1230 , 0115 , "CNPJ & IE"                   ,oFont10)
	oPrint:Say  ( 1210 , 0450 , "CNPJ : " + Iif(Alltrim(aDatSacado[9]) == "J",Alltrim(Transform(aDatSacado[7],"@R 99.999.999/9999-99")),Alltrim(Transform(aDatSacado[7],"@R 999.999.999-99")))+ "          Insc. Estadual : " + aDatSacado[8],oFont14)
	oPrint:Line ( 1300 , 0100 , 1300 , 2350 ) // --------
	
	oPrint:Say  ( 1350 , 0115 , "Valor p/ Extenso"                    ,oFont10)
	oPrint:Say  ( 1350 , 0450 , " ( " + Extenso(aDadosTit[4]) + " ) " ,oFont10)
	oPrint:Line ( 1400 , 0100 , 1400 , 2350 ) // --------
	
	oPrint:Say  ( 1450 , 0115 , "Observação"                           ,oFont10)
	oPrint:Say  ( 1410 , 0450 , "Reconheço a exatidão desta DUPLICATA de Venda Mercantil / Prestação de " ,oFont10)
	oPrint:Say  ( 1460 , 0450 , "Serviços na Importancia acima que pagarei a Minexco Com.Imp.Exp. Ltda. " ,oFont10)
	oPrint:Say  ( 1510 , 0450 , "a sua ordem na praça e vencimento acima indicados.                     " ,oFont10)
	oPrint:Line ( 1550 , 0100 , 1550 , 2350 ) // --------
	
	oPrint:Say  ( 1560 , 0115 , "Emitida em:"                           ,oFont10)
	oPrint:Say  ( 1600 , 0115 , DTOC(aDadosTit[2])                      ,oFont10)
	oPrint:Say  ( 1600 , 0450 , "Assinatura do Sacado:  "               ,oFont10)
	oPrint:Line ( 1660 , 0100 , 1660 , 2350 ) // --------
	oPrint:Say  ( 1670 , 1300 , "Minexco Comercial Importadora e Exportadora Ltda."  ,oFont10)
	oPrint:Say  ( 1710 , 1300 , " Assinatura do Emitente:                         "  ,oFont10)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza Pagina                                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	oPrint:EndPage()
	
Else
	Alert ("Fatura " + mv_par02 + "-" + mv_par01 + "-" + mv_par03 + " Já baixada !!!!")
EndIf

Return Nil

