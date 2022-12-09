#include "protheus.ch"
#include "rwmake.ch"
#INCLUDE "Ap5Mail.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

#DEFINE __cCarteira "109"
#DEFINE __cMoeda    "9"
/*
+-----------+----------+-------+--------------------+------+-------------+
| Programa  |BOLITAU   |Autor  |Felipe Zago Zechini | Data |  21/11/05   |
+-----------+----------+-------+--------------------+------+-------------+
| Desc.     |Impressao de boleto Itau                                    |
|           |                                                            |
+-----------+------------------------------------------------------------+
| Uso       | Transilva LOG                                              |
+-----------+------------------------------------------------------------+
*/
User Function BLTITAU(cPrefixo,cNota,cParcela,cCliente,cLoja)
Local	aPergs := {}
Private lExec    := .F.
Private cIndexName := ''
Private cIndexKey  := ''
Private cFilter    := ''
Private lAutoEMA   := .f.
	
DEFAULT	cNota := Space(09)
DEFAULT cPrefixo := Space(03)
DEFAULT cParcela := Space(03)
DEFAULT cCliente := Space(06)
DEFAULT cLoja	 := Space(02)
	
Tamanho  := "M"
titulo   := "Impressao de Boleto com Codigo de Barras"
cDesc1   := "Este programa destina-se a impressao do Boleto com Codigo de Barras."
cDesc2   := ""
cDesc3   := ""
cString  := /*"SEE" */   "SE1"
wnrel    := "BOLETO"
lEnd     := .F.
cPerg     := Padr("BOLTITAU",10)
aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nLastKey := 0
	
cNf	:= cNota
	
dbSelectArea("SE1")

AjustaSX1(cPerg)

If !Pergunte (cPerg,Empty(cNota))
	Return ''
Endif

If !Empty(cNota)
	RetIndex("SE1")        
	If !SE1->(dbSetOrder(1), dbSeek(xFilial("SE1")+cPrefixo+cNota+cParcela))
		MsgStop("Nota Não Encontrada!")
		Return ''
	Endif
	
	MV_PAR01 := cPrefixo
	MV_PAR02 := cPrefixo
	MV_PAR03 := cNota
	MV_PAR04 := cNota
	MV_PAR05 := cParcela
	MV_PAR06 := cParcela
	MV_PAR07 := SE1->E1_PORTADO
	MV_PAR08 := SE1->E1_PORTADO
	MV_PAR09 := cCliente
	MV_PAR10 := cCliente
	MV_PAR11 := cLoja
	MV_PAR12 := cLoja
	MV_PAR13 := SE1->E1_EMISSAO
	MV_PAR14 := SE1->E1_EMISSAO
	MV_PAR15 := SE1->E1_VENCREA
	MV_PAR16 := SE1->E1_VENCREA
	MV_PAR17 := Space(06)
	MV_PAR18 := PadR("ZZZ",6)  
	MV_PAR19 := Space(03)
	MV_PAR22 := 1
	lAutoEMA := .t.
Else
	lAutoEMA := .f.
Endif


cIndexName	:= Criatrab(Nil,.F.)
cIndexKey	:= "E1_PORTADO+E1_CLIENTE+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"
cFilter		+= "E1_FILIAL=='"+xFilial("SE1")+"'.And.E1_SALDO>0.And."
cFilter		+= "E1_PREFIXO>='" + MV_PAR01 + "'.And.E1_PREFIXO<='" + MV_PAR02 + "'.And."
cFilter		+= "E1_NUM>='" + MV_PAR03 + "'.And.E1_NUM<='" + MV_PAR04 + "'.And."
cFilter		+= "E1_PARCELA>='" + MV_PAR05 + "'.And.E1_PARCELA<='" + MV_PAR06 + "'.And."
cFilter		+= "E1_CLIENTE>='" + MV_PAR09 + "'.And.E1_CLIENTE<='" + MV_PAR10 + "'.And."
cFilter		+= "E1_LOJA>='" + MV_PAR11 + "'.And.E1_LOJA<='"+MV_PAR12+"'.And."
cFilter		+= "DTOS(E1_EMISSAO)>='"+DTOS(mv_par13)+"'.and.DTOS(E1_EMISSAO)<='"+DTOS(mv_par14)+"'.And."
cFilter		+= "DTOS(E1_VENCREA)>='"+DTOS(mv_par15)+"'.and.DTOS(E1_VENCREA)<='"+DTOS(mv_par16)+"'.And."
cFilter		+= "E1_NUMBOR>='" + MV_PAR17 + "'.And.E1_NUMBOR<='" + MV_PAR18 + "'.And."
cFilter		+= "!(E1_TIPO$MVABATIM)"
/*If Empty(MV_PAR19)
	cFilter		+= ".And. E1_PORTADO>='" + MV_PAR07 + "'.And.E1_PORTADO<='" + MV_PAR08 + "' "
	cFilter		+= ".And. E1_PORTADO<>'   '"
Endif
*/
IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
DbSelectArea("SE1")
#IFNDEF TOP
	DbSetIndex(cIndexName + OrdBagExt())
#ENDIF
dbGoTop()

If !lAutoEMA
	@ 001,001 TO 400,700 DIALOG oDlg TITLE "Seleção de Titulos"
	@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"
	@ 180,310 BMPBUTTON TYPE 01 ACTION (lExec := .T.,Close(oDlg))
	@ 180,280 BMPBUTTON TYPE 02 ACTION (lExec := .F.,Close(oDlg))
	ACTIVATE DIALOG oDlg CENTERED
Endif
cArquivo := ''
If lExec .Or. lAutoEMA
	Processa({|lEnd|cArquivo := MontaRel()})
Endif
RetIndex("SE1")
Ferase(cIndexName+OrdBagExt())
Return cArquivo

/*
+-----------+----------+-------+--------------------+------+-------------+
| Programa  |BOLITAU   |Autor  |Microsiga           | Data |  11/21/05   |
+-----------+----------+-------+--------------------+------+-------------+
| Desc.     |                                                            |
|           |                                                            |
+-----------+------------------------------------------------------------+
| Uso       | AP                                                         |
+-----------+------------------------------------------------------------+
*/
Static Function MontaRel()
	Local oPrint
	Local nX		:= 0
	Local cNroDoc 	:= " "
	Local aDadosEmp    := {	SM0->M0_NOMECOM                                    ,;                                //[1]Nome da Empresa
	SM0->M0_ENDCOB                                     ,;                        //[2]Endereço
	AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
	"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
	"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
	"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          ;     //[6]
	Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
	Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
	"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
	Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E
	
	Local aDadosBanco := {}
	Local aDatSacado  := {}
	Local aBolText    := {	"APÓS O VENCIMENTO COBRAR MULTA DE.......... 2,00%",;
							"APÓS O VENCIMENTO COBRAR JUROS DE.......... 0.33% AO MÊS",""}
	
	Local nI          := 1
	Local nVlrAbat	  := 0
	
	Private cStartPath  := GetSrvProfString("Startpath","")
	Private cFilename   := Criatrab(Nil,.F.)
	Private aDadosTit   := {}
	Private aCB_RN_NN   := {}
	
	If MV_PAR22 == 2	// Se FOr Por Email então o Inicio da COnfiguracao é por folha
		MAKEDIR('C:\TEMP')
		
		lAdjustToLegacy := .T.   //.F.
		lDisableSetup  := .T.
		oPrint := FWMSPrinter():New(cFilename, IMP_PDF, lAdjustToLegacy, , lDisableSetup)
		//	oPrint:Setup()
		oPrint:SetResolution(78)
		oPrint:SetPortrait() // ou SetLandscape()
		oPrint:SetPaperSize(DMPAPER_A4)
		oPrint:SetMargin(10,10,10,10) // nEsquerda, nSuperior, nDireita, nInferior
		oPrint:cPathPDF := "C:\TEMP\" // Caso seja utilizada impressão em IMP_PDF
		cDiretorio := oPrint:cPathPDF
	Endif
	
	DbGoTop()
	ProcRegua(RecCount())
	Do While SE1->(!EOF())
		
		If Marked("E1_OK") .Or. lAutoEMA
			
			If Empty(MV_PAR19)
				//Posiciona o SA6 (Bancos)
				DbSelectArea("SA6")
				DbSetOrder(1)
				DbSeek(xFilial("SA6")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA,.T.)
				
				
				//Posiciona na Arq de Parametros CNAB
				DbSelectArea("SEE")
				DbSetOrder(1)
				DbSeek(xFilial("SEE")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA),.T.)
			Else
				//Posiciona o SA6 (Bancos)
				
				DbSelectArea("SA6")
				DbSetOrder(1)
				DbSeek(xFilial("SA6")+MV_PAR19+MV_PAR20+MV_PAR21,.T.)
				
				
				//Posiciona na Arq de Parametros CNAB
				DbSelectArea("SEE")
				DbSetOrder(1)
				//DbSeek("01"+"341"+"6083 "+"62525     "+"000")
				DbSeek(xFilial("SEE")+MV_PAR19+MV_PAR20+MV_PAR21,.T.)
			Endif
			/*
			//inserido por raul em 28/08/12
			//posiciona no pedido
			DbSelectArea("SC5")
			DbSetOrder(1)
			DbSeek(xFilial("SC5")+SE1->E1_PEDIDO,.T.)
			
			If !empty(SC5->C5_CLIENTC+SC5->C5_LOJACOB).and.(SC5->C5_FILIAL+SC5->C5_NUM==SE1->E1_FILIAL+SE1->E1_PEDIDO)
				DbSelectArea("SA1")
				DbSetOrder(1)
				DbSeek(xFilial()+SC5->C5_CLIENTC+SC5->C5_LOJACOB,.T.)
			Else
				*/
				//Posiciona o SA1 (Cliente)
				DbSelectArea("SA1")
				DbSetOrder(1)
				DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
				//Endif
				
				// Luiz Alberto - 06-02-2012 - Athena
				// Efetua o Preenchimento do Campo E1_NUMBCO com
				// o Numero Sequencial da Tabela EE_FAXATU.
				
				DbSelectArea("SE1")
				
				If Empty(SE1->E1_NUMBCO)
					
					NossoNum()
					
				Endif
				
				/*		DbSelectArea("SE1")
				RecLock("SE1",.F.)
				SE1->E1_NUMBCO 	:=	NossoNum() //aCB_RN_NN[3]   // Nosso número (Ver fórmula para calculo)
				MsUnlock() */
				
				
				
				//aAdd(aDadosBanco, Alltrim(SA6->A6_COD))             // [1]Numero do Banco
				aAdd(aDadosBanco, Alltrim(SEE->EE_CODIGO))            // [1]Numero do Banco
				aAdd(aDadosBanco, Alltrim(SA6->A6_NOME))              // [2]Nome do Banco
				//aAdd(aDadosBanco, Left(Alltrim(SA6->A6_AGENCIA),4)) // [3]Agência
				aAdd(aDadosBanco, Left(Alltrim(SEE->EE_AGENCIA),4))   // [3]Agência
				aAdd(aDadosBanco, Left(Alltrim(SEE->EE_CONTA),5))     // [4]Conta Corrente
				//aAdd(aDadosBanco, Alltrim(SA6->A6_NUMCON))          // [4]Conta Corrente
				//aAdd(aDadosBanco, Right(Alltrim(SA6->A6_DVCTA),1))  // [5]Dígito da conta corrente
				aAdd(aDadosBanco, Right(Alltrim(SEE->EE_DVCTA),1))    // [5]Dígito da conta corrente
				aAdd(aDadosBanco, Alltrim(__cCarteira))               // [6]Codigo da Carteira
				
				If Empty(SA1->A1_ENDCOB)
					aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;      	// [1]Razão Social
					AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;      	// [2]Código
					AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;      	// [3]Endereço
					AllTrim(SA1->A1_MUN )                            ,;  		// [4]Cidade
					SA1->A1_EST                                      ,;     	// [5]Estado
					SA1->A1_CEP                                      ,;      	// [6]CEP
					SA1->A1_CGC										 ,;         // [7]CGC
					SA1->A1_PESSOA									  }         // [8]PESSOA
				Else
					aDatSacado   := {AllTrim(SA1->A1_NOME)            	,;   	// [1]Razão Social
					AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   	// [2]Código
					AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   	// [3]Endereço
					AllTrim(SA1->A1_MUNC)	                            ,;   	// [4]Cidade
					SA1->A1_ESTC	                                    ,;   	// [5]Estado
					SA1->A1_CEPC                                        ,;   	// [6]CEP
					SA1->A1_CGC											,;		// [7]CGC
					SA1->A1_PESSOA										 }		// [8]PESSOA
				Endif
				
				nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
				/*
				--------------------------------------------------------------
				Parte do Nosso Numero. Sao 8 digitos para identificar o titulo
				--------------------------------------------------------------
				*/
				cNroDoc	:= StrZero(	Val(Alltrim(SE1->E1_NUM)+Alltrim(SE1->E1_PARCELA)),8)
				/*
				----------------------
				Monta codigo de barras
				----------------------
				*/
				
				nSaldo	:= Round((SALDOTIT(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,1,DDatabase,,SE1->E1_LOJA) - nVlrAbat),2)
				
				//DbSelectArea("SE1")
				aCB_RN_NN := fLinhaDig(aDadosBanco[1]      ,; // Numero do Banco
				__cMoeda            ,; // Codigo da Moeda
				aDadosBanco[6]      ,; // Codigo da Carteira
				aDadosBanco[3]      ,; // Codigo da Agencia
				aDadosBanco[4]      ,; // Codigo da Conta
				aDadosBanco[5]      ,; // DV da Conta
				nSaldo ,; // Valor do Titulo
				E1_VENCTO           ,; // Data de Vencimento do Titulo
				cNroDoc              ) // Numero do Documento no Contas a Receber
				
				
				aDadosTit	:= {AllTrim(E1_NUM)+AllTrim(E1_PARCELA)	,;  // [1] Número do título
				E1_EMISSAO                          ,;  // [2] Data da emissão do título
				dDataBase                    		,;  // [3] Data da emissão do boleto
				E1_VENCTO                           ,;  // [4] Data do vencimento
				nSaldo               ,;  // [5] Valor do título
				aCB_RN_NN[3]                        ,;  // [6] Nosso número (Ver fórmula para calculo)
				E1_PREFIXO                          ,;  // [7] Prefixo da NF
				E1_TIPO	                           	}   // [8] Tipo do Titulo
				
				cArquivo := Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
				nX := nX + 1
			EndIf
			SE1->(dbSkip())
			IncProc()
			nI++
		EndDo
		If MV_PAR22 == 2
			oPrint:Preview()     // Visualiza antes de imprimir
		Endif
		
		//cJPEG := Iif(Empty(AllTrim(SE1->E1_NUM)),CriaTrab(,.f.),AllTrim(SE1->E1_NUM))
		//oPrint:SaveAllAsJPEG(cStartPath+cJPEG,1000,1400,140)
		Return cArquivo
		
		
		/*
		+-----------+----------+-------+--------------------+------+-------------+
		| Programa  |Impress   |Autor  |Microsiga           | Data |  21/11/05   |
		+-----------+----------+-------+--------------------+------+-------------+
		| Desc.     |Impressao dos dados do boleto em modo grafico               |
		|           |                                                            |
		+-----------+------------------------------------------------------------+
		| Uso       | AP                                                         |
		+-----------+------------------------------------------------------------+
		*/
	Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
		Local oFont8
		Local oFont11c
		Local oFont10
		Local oFont14
		Local oFont16n
		Local oFont15
		Local oFont14n
		Local oFont24
		Local nI := 0
		Local cStartPath := GetSrvProfString("StartPath","")
		Local cBmp := 030
		Local cMailAdc := ""
		
		cBmp := cStartPath + "341.BMP" //Logo do Banco Itau
		
		SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
		
		Private cFilename := 'BOL'+ALLTRIM(SA1->A1_COD+SA1->A1_LOJA)+'_'+AllTrim(SE1->E1_NUM)+AllTrim(E1_PARCELA)	//Criatrab(Nil,.F.)
		
		If MV_PAR22 == 1	// Se FOr Por Email então o Inicio da COnfiguracao é por folha
			MAKEDIR('C:\TEMP')
			lAdjustToLegacy := .T.   //.F.
			lDisableSetup  := .T.
			oPrint := FWMSPrinter():New(cFilename, IMP_PDF, lAdjustToLegacy, , lDisableSetup)
			//	oPrint:Setup()
			oPrint:SetResolution(78)
			oPrint:SetPortrait() // ou SetLandscape()
			oPrint:SetPaperSize(DMPAPER_A4)
			oPrint:SetMargin(10,10,10,10) // nEsquerda, nSuperior, nDireita, nInferior
			oPrint:cPathPDF := "C:\TEMP\" // Caso seja utilizada impressão em IMP_PDF
			If MV_PAR22 = 1
				oPrint:linjob:=.T.
				oPrint:lViewPdf:=.F.
			Endif
			cDiretorio := oPrint:cPathPDF
		Endif
		
		//Parametros de TFont.New()
		//1.Nome da Fonte (Windows)
		//3.Tamanho em Pixels
		//5.Bold (T/F)
		oFont8   := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
		oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
		oFont11  := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
		oFont9  := TFont():New("Arial",9,8,.T.,.T.,5,.T.,5,.T.,.F.)
		oFont10  := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
		oFont14  := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
		oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
		oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
		oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
		oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
		oFont15n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
		oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
		oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)
		
		oPrint:StartPage()   // Inicia uma nova página
		
		/******************/
		/* PRIMEIRA PARTE */
		/******************/
		
		nRow1 := 10
		
		oPrint:Line (nRow1+0150,100,nRow1+0150,2300)
		oPrint:Line (nRow1+0150,500,nRow1+0070, 500)
		oPrint:Line (nRow1+0150,710,nRow1+0070, 710)
		
		If File(cBmp)
			oPrint:SayBitmap(nRow1+0070,100,cBmp,300,65)
		Endif
		
		//oPrint:Say  (nRow1+0084,100,aDadosBanco[2],oFont11 )	        // [2]Nome do Banco
		oPrint:Say  (nRow1+0125,513,aDadosBanco[1]+"-7",oFont21 )		// [1]Numero do Banco
		
		oPrint:Say  (nRow1+0114,1900,"Comprovante de Entrega",oFont10)
		
		oPrint:Say  (nRow1+0180,100 ,"Beneficiário",oFont8)
		oPrint:Say  (nRow1+0180,250 ,aDadosEmp[1],oFont9)				//Nome + CNPJ

		oPrint:Say  (nRow1+0210,250 ,Capital(AllTrim(SM0->M0_ENDCOB)),oFont9)				//Nome + CNPJ
		oPrint:Say  (nRow1+0240,250 ,Capital(AllTrim(AllTrim(SM0->M0_BAIRCOB)+' '+AllTrim(SM0->M0_COMPCOB)+' '+AllTrim(SM0->M0_CIDCOB)+"/"+Trim(SM0->M0_ESTCOB)+" "+Transform(SM0->M0_CEPCOB,"@R 99999-999"))),oFont9)				//Nome + CNPJ
		
		oPrint:Say  (nRow1+0180,1060,"Agência/Código Beneficiário",oFont8)
		oPrint:Say  (nRow1+0240,1060,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
		//oPrint:Say  (nRow1+0200,1060,aDadosBanco[3]+"/"+aDadosBanco[4],oFont10) //+"-"+aDadosBanco[5]
		
		oPrint:Say  (nRow1+0180,1510,"Nro.Documento",oFont8)
		oPrint:Say  (nRow1+0240,1510,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela
		
		oPrint:Say  (nRow1+0280,100 ,"Pagador",oFont8)
		oPrint:Say  (nRow1+0340,100 ,aDatSacado[1],oFont9)				//Nome
		
		oPrint:Say  (nRow1+0280,1060,"Vencimento",oFont8)
		oPrint:Say  (nRow1+0340,1080,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)
		
		oPrint:Say  (nRow1+0280,1510,"Valor do Documento",oFont8)
		oPrint:Say  (nRow1+0340,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)
		
		oPrint:Say  (nRow1+0430,0100,"Recebi(emos) o bloqueto/título",oFont10)
		oPrint:Say  (nRow1+0490,0100,"com as características acima.",oFont10)
		oPrint:Say  (nRow1+0380,1060,"Data",oFont8)
		oPrint:Say  (nRow1+0380,1410,"Assinatura",oFont8)
		oPrint:Say  (nRow1+0480,1060,"Data",oFont8)
		oPrint:Say  (nRow1+0480,1410,"Entregador",oFont8)
		
		oPrint:Line (nRow1+0250, 100,nRow1+0250,1900 )
		oPrint:Line (nRow1+0350, 100,nRow1+0350,1900 )
		oPrint:Line (nRow1+0450,1050,nRow1+0450,1900 ) //---
		oPrint:Line (nRow1+0550, 100,nRow1+0550,2300 )
		
		oPrint:Line (nRow1+0550,1050,nRow1+0150,1050 )
		oPrint:Line (nRow1+0550,1400,nRow1+0350,1400 )
		oPrint:Line (nRow1+0350,1500,nRow1+0150,1500 ) //--
		oPrint:Line (nRow1+0550,1900,nRow1+0150,1900 )
		
		oPrint:Say  (nRow1+0165,1910,"(  )Mudou-se"                                	,oFont8)
		oPrint:Say  (nRow1+0205,1910,"(  )Ausente"                                    ,oFont8)
		oPrint:Say  (nRow1+0245,1910,"(  )Não existe nº indicado"                  	,oFont8)
		oPrint:Say  (nRow1+0285,1910,"(  )Recusado"                                	,oFont8)
		oPrint:Say  (nRow1+0325,1910,"(  )Não procurado"                              ,oFont8)
		oPrint:Say  (nRow1+0365,1910,"(  )Endereço insuficiente"                  	,oFont8)
		oPrint:Say  (nRow1+0405,1910,"(  )Desconhecido"                            	,oFont8)
		oPrint:Say  (nRow1+0445,1910,"(  )Falecido"                                   ,oFont8)
		oPrint:Say  (nRow1+0485,1910,"(  )Outros(anotar no verso)"                  	,oFont8)
		
		/*****************/
		/* SEGUNDA PARTE */
		/*****************/
		
		nRow2   := 10
		
		//Pontilhado separador
		/*
		For nI := 100 to 2300 step 50
			oPrint:Line(nRow2+0580, nI,nRow2+0580, nI+30)
		Next nI
		*/
		
		
		oPrint:Line (nRow2+0710,100,nRow2+0710,2300)
		oPrint:Line (nRow2+0710,500,nRow2+0630, 500)
		oPrint:Line (nRow2+0710,710,nRow2+0630, 710)
		
		If File(cBmp)
			oPrint:SayBitmap(nRow2+0634,100,cBmp,300,65)
		Endif
		
		//oPrint:Say  (nRow2+0644,100,aDadosBanco[2],oFont14 )		// [2]Nome do Banco
		oPrint:Say  (nRow2+0685,513,aDadosBanco[1]+"-7",oFont21 )	// [1]Numero do Banco
		oPrint:Say  (nRow2+0694,1800,"Recibo do Pagador",oFont10)
		
		oPrint:Line (nRow2+0810,100,nRow2+0810,2300 )
		oPrint:Line (nRow2+0910,100,nRow2+0910,2300 )
		oPrint:Line (nRow2+0980,100,nRow2+0980,2300 )
		oPrint:Line (nRow2+1050,100,nRow2+1050,2300 )
		
		oPrint:Line (nRow2+0910,500,nRow2+1050,500)
		oPrint:Line (nRow2+0980,750,nRow2+1050,750)
		oPrint:Line (nRow2+0910,1000,nRow2+1050,1000)
		oPrint:Line (nRow2+0910,1300,nRow2+0980,1300)
		oPrint:Line (nRow2+0910,1480,nRow2+1050,1480)
		
		oPrint:Say  (nRow2+0730,100 ,"Local de Pagamento",oFont8)
		oPrint:Say  (nRow2+0755,400 ,"ATE O VENCIMENTO PAGUE PREFERENCIALMENTE NO ITAU",oFont10)
		oPrint:Say  (nRow2+0795,400 ,"APOS O VENCIMENTO PAGUE SOMENTE NO ITAU",oFont10)
		
		oPrint:Say  (nRow2+0730,1810,"Vencimento"                                     ,oFont8)
		cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
		nCol := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow2+0790,nCol,cString,oFont11c)
		
		oPrint:Say  (nRow2+0830,100 ,"Beneficiário"                                        ,oFont8)
		oPrint:Say  (nRow2+0830,250 ,aDadosEmp[1]+"       - "+aDadosEmp[6]	,oFont9) //Nome + CNPJ

		oPrint:Say  (nRow2+0860,250 ,Capital(AllTrim(SM0->M0_ENDCOB)),oFont9)				//Nome + CNPJ
		oPrint:Say  (nRow2+0890,250 ,Capital(AllTrim(AllTrim(SM0->M0_BAIRCOB)+' '+AllTrim(SM0->M0_COMPCOB)+' '+AllTrim(SM0->M0_CIDCOB)+"/"+Trim(SM0->M0_ESTCOB)+" "+Transform(SM0->M0_CEPCOB,"@R 99999-999"))),oFont9)				//Nome + CNPJ

		oPrint:Say  (nRow2+0830,1810,"Agência/Código Beneficiário",oFont8)
		cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
		//cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]) //+"-"+aDadosBanco[5]
		nCol := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow2+0890,nCol,cString,oFont11c)
		
		oPrint:Say  (nRow2+0930,100 ,"Data do Documento"                              ,oFont8)
		oPrint:Say  (nRow2+0970,100, StrZero(Day(dDataBase),2) +"/"+ StrZero(Month(dDataBase),2) +"/"+ Right(Str(Year(dDataBase)),4),oFont10)
		//oPrint:Say  (nRow2+0940,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)
		
		oPrint:Say  (nRow2+0930,505 ,"Nro.Documento"                                  ,oFont8)
		oPrint:Say  (nRow2+0970,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela
		
		oPrint:Say  (nRow2+0930,1005,"Espécie Doc."                                   ,oFont8)
		oPrint:Say  (nRow2+0970,1050,"FS"										,oFont10) //  aDadosTit[8] Tipo do Titulo
		
		oPrint:Say  (nRow2+0930,1305,"Aceite"                                         ,oFont8)
		oPrint:Say  (nRow2+0970,1400,"N"                                             ,oFont10)
		
		oPrint:Say  (nRow2+0930,1485,"Data do Processamento"                          ,oFont8)
		oPrint:Say  (nRow2+0970,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao
		
		
		//alert(Alltrim(SEE->EE_AGENCIA)+Alltrim(SEE->EE_CONTA)+__cCarteira+Right(AllTrim(SE1->E1_NUMBCO),8))
		//alert(modulo10(Alltrim(SEE->EE_AGENCIA)+Alltrim(SEE->EE_CONTA)+__cCarteira+Right(AllTrim(SE1->E1_NUMBCO),8)))
		
		oPrint:Say  (nRow2+0930,1810,"Nosso Número"                                   ,oFont8)
		cString :=  Alltrim(Substr(aDadosBanco[6],1,3)+"/"+ Right(AllTrim(SE1->E1_NUMBCO),8))+"-"+ Str(modulo10(Alltrim(SEE->EE_AGENCIA)+Alltrim(SEE->EE_CONTA)+__cCarteira+Right(AllTrim(SE1->E1_NUMBCO),8)),1)// nosso numero com DV
		nCol 	:=  1810+(374-(len(cString)*22))
		oPrint:Say  (nRow2+0970,nCol,cString,oFont11c)
		
		oPrint:Say  (nRow2+1000,100 ,"Uso do Banco"                                   ,oFont8)
		
		oPrint:Say  (nRow2+1000,505 ,"Carteira"                                       ,oFont8)
		oPrint:Say  (nRow2+1040,555 ,aDadosBanco[6]                                   ,oFont10)
		
		oPrint:Say  (nRow2+1000,755 ,"Espécie"                                        ,oFont8)
		oPrint:Say  (nRow2+1040,805 ,"R$"                                             ,oFont10)
		
		oPrint:Say  (nRow2+1000,1005,"Quantidade"                                     ,oFont8)
		oPrint:Say  (nRow2+1040,1485,"Valor"                                          ,oFont8)
		
		oPrint:Say  (nRow2+1000,1810,"Valor do Documento"                          	,oFont8)
		cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
		nCol := 1830+(374-(len(cString)*22))   // nCol := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow2+1040,nCol,cString ,oFont11c)  // alinhando com nosso numero - susgetao do banco Itau.
		
		oPrint:Say  (nRow2+1080,100 ,"Instruções de responsabilidade do BENEFICIÁRIO. Qualquer dúvida sobre esse boleto, contate o BENEFICIÁRIO.",oFont8)
		//oPrint:Say  (nRow2+1150,100 ,aBolText[1]+" "+AllTrim(Transform((aDadosTit[5]*0.02),"@E 99,999.99"))       ,oFont10)
		oPrint:Say  (nRow2+1190,100 ,aBolText[1],oFont10) //+" "+AllTrim(Transform(((aDadosTit[5]*(10/30))/100),"@E 99,999.99"))+" AO DIA"  
		oPrint:Say  (nRow2+1240,100 ,aBolText[2]   ,oFont10)
		If SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+SE1->E1_PEDIDO)) .And. !Empty(SC5->C5_NUMOSN)
			oPrint:Say  (nRow2+1290,100 ,AllTrim(SC5->C5_NUMOSN) ,oFont10)
		Endif
		
		oPrint:Say  (nRow2+1080,1810,"(-)Desconto/Abatimento"                         ,oFont8)
		oPrint:Say  (nRow2+1150,1810,"(-)Outras Deduções"                             ,oFont8)
		oPrint:Say  (nRow2+1220,1810,"(+)Mora/Multa"                                  ,oFont8)
		oPrint:Say  (nRow2+1290,1810,"(+)Outros Acréscimos"                           ,oFont8)
		oPrint:Say  (nRow2+1360,1810,"(=)Valor Cobrado"                               ,oFont8)
		
		//Temp
		oPrint:Say  (nRow2+1380,100,"APOS VCTO ACESSE WWW.ITAU.COM.BR/BOLETOS PARA ATUALIZAR SEU BOLETO"                               ,oFont10)
		
		
		oPrint:Say  (nRow2+1430,100 ,"Pagador"                                         ,oFont8)
		oPrint:Say  (nRow2+1470,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
		oPrint:Say  (nRow2+1523,400 ,aDatSacado[3]                                    ,oFont10)
		oPrint:Say  (nRow2+1576,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
		
		if aDatSacado[8] = "J"
			oPrint:Say  (nRow2+1629,400 ,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
		Else
			oPrint:Say  (nRow2+1629,400 ,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
		EndIf
		
		//oPrint:Say  (nRow2+1589,1850,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont10)
		
		oPrint:Say  (nRow2+1635,100 ,"Pagador/Avalista",oFont8)
		oPrint:Say  (nRow2+1675,1500,"Autenticação Mecânica",oFont8)
		
		oPrint:Line (nRow2+0710,1800,nRow2+1400,1800 )
		oPrint:Line (nRow2+1120,1800,nRow2+1120,2300 )
		oPrint:Line (nRow2+1190,1800,nRow2+1190,2300 )
		oPrint:Line (nRow2+1260,1800,nRow2+1260,2300 )
		oPrint:Line (nRow2+1330,1800,nRow2+1330,2300 )
		oPrint:Line (nRow2+1400,100 ,nRow2+1400,2300 )
		oPrint:Line (nRow2+1640,100 ,nRow2+1640,2300 )
		
		/******************/
		/* TERCEIRA PARTE */
		/******************/
		
		nRow3 := 10
		
		For nI := 100 to 2300 step 50
			oPrint:Line(nRow3+1880, nI, nRow3+1880, nI+30)
		Next nI
		
		oPrint:Line (nRow3+2000,100,nRow3+2000,2300)
		oPrint:Line (nRow3+2000,500,nRow3+1920, 500)
		oPrint:Line (nRow3+2000,710,nRow3+1920, 710)
		
		// Nao é obrigatorio a logo marca na ficha de compensacao somente o nome do banco.
		//If File(cBmp)
		//   oPrint:SayBitmap(nRow3+1934,100,cBmp,215,65)
		//Endif
		
		oPrint:Say  (nRow3+1984,100,"Banco Itaú S.A.",oFont14 )		// 	[2]Nome do Banco
		//oPrint:Say  (nRow3+1934,100,aDadosBanco[2],oFont14 )		// 	[2]Nome do Banco
		oPrint:Say  (nRow3+1975,513,aDadosBanco[1]+"-7",oFont21 )	// 	[1]Numero do Banco
		oPrint:Say  (nRow3+1984,755,aCB_RN_NN[2],oFont15n)			//	Linha Digitavel do Codigo de Barras
		
		oPrint:Line (nRow3+2100,100,nRow3+2100,2300 )
		oPrint:Line (nRow3+2200,100,nRow3+2200,2300 )
		oPrint:Line (nRow3+2270,100,nRow3+2270,2300 )
		oPrint:Line (nRow3+2340,100,nRow3+2340,2300 )
		
		oPrint:Line (nRow3+2200,500 ,nRow3+2340,500 )
		oPrint:Line (nRow3+2270,750 ,nRow3+2340,750 )
		oPrint:Line (nRow3+2200,1000,nRow3+2340,1000)
		oPrint:Line (nRow3+2200,1300,nRow3+2270,1300)
		oPrint:Line (nRow3+2200,1480,nRow3+2340,1480)
		
		oPrint:Say  (nRow3+2030,100 ,"Local de Pagamento",oFont8)
		oPrint:Say  (nRow3+2045,400 ,"ATE O VENCIMENTO PAGUE PREFERENCIALMENTE NO ITAU",oFont10)
		oPrint:Say  (nRow3+2085,400 ,"APOS O VENCIMENTO PAGUE SOMENTE NO ITAU",oFont10)
		
		oPrint:Say  (nRow3+2030,1810,"Vencimento",oFont8)
		cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
		nCol	 	 := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow3+2080,nCol,cString,oFont11c)
		
		oPrint:Say  (nRow3+2130,100 ,"Beneficiário",oFont8)
		oPrint:Say  (nRow3+2180,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
		
		oPrint:Say  (nRow3+2130,1810,"Agência/Código Beneficiário",oFont8)
		cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
		//cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]) //+"-"+aDadosBanco[5]
		nCol 	 := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow3+2180,nCol,cString ,oFont11c)
		
		oPrint:Say (nRow3+2220,100 ,"Data do Documento"                             ,oFont8)
		oPrint:Say (nRow3+2260,100, StrZero(Day(dDataBase),2) +"/"+ StrZero(Month(dDataBase),2) +"/"+ Right(Str(Year(dDataBase)),4), oFont10)
		
		oPrint:Say (nRow3+2220,505 ,"Nro.Documento"                                 ,oFont8)
		oPrint:Say (nRow3+2260,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela
		
		oPrint:Say (nRow3+2220,1005,"Espécie Doc."                                  ,oFont8)
		oPrint:Say (nRow3+2260,1050,"FS"									,oFont10) //  aDadosTit[8] Tipo do Titulo
		
		oPrint:Say (nRow3+2220,1305,"Aceite"                                        ,oFont8)
		oPrint:Say (nRow3+2260,1400,"N"                                             ,oFont10)
		
		oPrint:Say  (nRow3+2220,1485,"Data do Processamento"                        ,oFont8)
		oPrint:Say  (nRow3+2260,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao
		
		
		oPrint:Say  (nRow3+2220,1810,"Nosso Número"                                 ,oFont8)
		cString :=  Alltrim(Substr(aDadosBanco[6],1,3)+"/"+ Right(AllTrim(SE1->E1_NUMBCO),8))+"-"+ Str(modulo10(Alltrim(SEE->EE_AGENCIA)+Alltrim(SEE->EE_CONTA)+__cCarteira+Right(AllTrim(SE1->E1_NUMBCO),8)),1)// nosso numero com DV
		//cString := Alltrim(Substr(aDadosTit[6],1,3)+"/"+ Right(AllTrim(SE1->E1_NUMBCO),8))+"-"+ Right(Substr(aDadosTit[6],4),1)
		nCol := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow3+2260,nCol,cString,oFont11c)
		
		
		oPrint:Say  (nRow3+2290,100 ,"Uso do Banco"                                 ,oFont8)
		
		oPrint:Say  (nRow3+2290,505 ,"Carteira"                                     ,oFont8)
		oPrint:Say  (nRow3+2330,555 ,aDadosBanco[6]                                 ,oFont10)
		
		oPrint:Say  (nRow3+2290,755 ,"Espécie"                                      ,oFont8)
		oPrint:Say  (nRow3+2330,805 ,"R$"                                           ,oFont10)
		
		oPrint:Say  (nRow3+2290,1005,"Quantidade"                                   ,oFont8)
		oPrint:Say  (nRow3+2290,1485,"Valor"                                        ,oFont8)
		
		oPrint:Say  (nRow3+2290,1810,"Valor do Documento"                          	,oFont8)
		cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
		nCol 	 := 1830+(374-(len(cString)*22))    // alinhamento com nosso numero - susgestao do banco Itau.
		oPrint:Say  (nRow3+2330,nCol,cString,oFont11c)
		
		oPrint:Say  (nRow3+2370,100 ,"Instruções de responsabilidade do BENEFICIÁRIO. Qualquer dúvida sobre esse boleto, contate o BENEFICIÁRIO.",oFont8)
		//oPrint:Say  (nRow3+2440,100 ,aBolText[1]+" "+AllTrim(Transform((aDadosTit[5]*0.02),"@E 99,999.99"))      ,oFont10)
		//oPrint:Say  (nRow3+2490,100 ,aBolText[2]+" "+AllTrim(Transform(((aDadosTit[5]*0.01)/30),"@E 99,999.99"))  ,oFont10)
		//oPrint:Say  (nRow3+2540,100 ,aBolText[3]                                    ,oFont10)
		oPrint:Say  (nRow3+2480,100 ,aBolText[1]+" "+AllTrim(Transform(((aDadosTit[5]*(10/30))/100),"@E 99,999.99"))+" AO DIA"  ,oFont10)
		oPrint:Say  (nRow3+2530,100 ,aBolText[2]   ,oFont10)
		
		If SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+SE1->E1_PEDIDO)) .And. !Empty(SC5->C5_NUMOSN)
			oPrint:Say  (nRow3+2580,100 ,AllTrim(SC5->C5_NUMOSN) ,oFont10)
		Endif
		
		oPrint:Say  (nRow3+2370,1810,"(-)Desconto/Abatimento"                       ,oFont8)
		oPrint:Say  (nRow3+2440,1810,"(-)Outras Deduções"                           ,oFont8)
		oPrint:Say  (nRow3+2510,1810,"(+)Mora/Multa"                                ,oFont8)
		oPrint:Say  (nRow3+2580,1810,"(+)Outros Acréscimos"                         ,oFont8)
		oPrint:Say  (nRow3+2650,1810,"(=)Valor Cobrado"                             ,oFont8)
		
		// TEMP
		oPrint:Say  (nRow2+2670,100,"APOS VCTO ACESSE WWW.ITAU.COM.BR/BOLETOS PARA ATUALIZAR SEU BOLETO"                               ,oFont10)
		
		oPrint:Say  (nRow3+2720,100 ,"Pagador"                                       ,oFont8)
		oPrint:Say  (nRow3+2740,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"           ,oFont10)
		
		if aDatSacado[8] = "J"
			oPrint:Say  (nRow3+2730,1750,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
		Else
			oPrint:Say  (nRow3+2730,1750,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
		EndIf
		
		oPrint:Say  (nRow3+2793,400 ,aDatSacado[3]                                  ,oFont10)
		oPrint:Say  (nRow3+2846,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
		//oPrint:Say  (nRow3+2806,1750,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont10)
		
		oPrint:Say  (nRow3+2845,100 ,"Pagador/Avalista"                             ,oFont8)
		oPrint:Say  (nRow3+2885,1500,"Autenticação Mecânica - Ficha de Compensação" ,oFont8)
		
		oPrint:Line (nRow3+2000,1800,nRow3+2690,1800 )
		oPrint:Line (nRow3+2410,1800,nRow3+2410,2300 )
		oPrint:Line (nRow3+2480,1800,nRow3+2480,2300 )
		oPrint:Line (nRow3+2550,1800,nRow3+2550,2300 )
		oPrint:Line (nRow3+2620,1800,nRow3+2620,2300 )
		oPrint:Line (nRow3+2690,100 ,nRow3+2690,2300 )
		
		oPrint:Line (nRow3+2850,100,nRow3+2850,2300  )
		
		//oPrint:FwMSBAR("INT25",68,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.020,0.95,Nil,Nil,"A",.F.) //modali
		
		//FWMsPrinter():FwMSBAR("INT25",24.5,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.022,1.5,Nil,Nil,"A",.F.) //datasupri
		
		oPrint:FwMSBAR("INT25" ,68,3   ,aCB_RN_NN[1],oPrint,.F.   ,Nil  ,Nil  ,0.017     ,1   ,Nil    ,Nil,"A"  ,.F. ) //datasupri
		//FWMsPrinter():FWMsBar(cTypeBar,nRow,nCol,cCode       ,oPrint,lCheck,Color,lHorz,   nWidth,nHeigth,lBanner,cFont   ,cMode,lPrint,nPFWidth,nPFHeigth,lCmtr2Pix)
		
		
		//	DbSelectArea("SEE")
		//	If SEE->(dbSetOrder(1), DbSeek(xFilial("SEE")+MV_PAR19+MV_PAR20+MV_PAR21,.T.))
		//		If RecLock("SEE",.F.)
		//SEE->EE_FAXATU := Soma1(Strzero(Val(Substr(SE1->E1_NUMBCO,4,11)),12))
		//			SEE->EE_FAXATU := Strzero(Val(Substr(SE1->E1_NUMBCO,4,11)),12)
		//			MsUnlock()
		//		Endif
		//	Endif
		
		oPrint:EndPage() // Finaliza a página
		
		If MV_PAR22 == 1 .And. !lAutoEMA           // saida por email do cliente
			oPrint:Preview()     // Visualiza antes de imprimir
			
			SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
			//		oPrint:SaveAllAsJPEG('\system\bol'+SE1->E1_NUM,1400,1800,200)
			
			cArquivo := 'C:\TEMP\'+cFilename+'.PDF' //AllTrim('\system\bol'+SE1->E1_NUM+"_pag1.jpg")
			cPara		:= SA1->A1_EMAIL

			If !Empty(MV_PAR23)
				cPara := AllTrim(MV_PAR23)
			Endif
			
			If Empty(cPara)	.And. MV_PAR24 <> 1 // Campo Email de Cobrança Vazio, Solicita email ao Cliente
				nOpc   		:= 	0
				bOk    		:= 	{||nOpc:=1,_PedCom:End()}
				bCancel		:= 	{||nOpc:=0,_PedCom:End()}
				cTitulo	 	:= 	SE1->E1_NUM
				_cCliente 	:= 	SA1->A1_COD+'/'+SA1->A1_LOJA+' - '+SA1->A1_NOME
				_cPara		:=  cPara
				
				Define MsDialog _PedCom Title "Envio Boleto por Email - Cliente Sem Email Cadastrado" From 127,037 To 262,774 Pixel
				@ 013,006 To 053,357 Title OemToAnsi("  Dados do Cliente ")
				@ 020,010 Say "Titulo:" Color CLR_HBLUE // Size 25,8
				@ 020,040 Get cTitulo Picture "@!" When .F.
				@ 030,010 Say "Cliente: " Color CLR_HBLUE
				@ 030,042 Say _cCliente Color CLR_HRED Object oCliente //Size 19,8
				@ 040,010 Say "Email:" Color CLR_HBLUE //Size 25,8
				@ 040,042 Get _cPara Picture "@" Size 150,08
				
				Activate MsDialog _PedCom On Init EnchoiceBar(_PedCom,bOk,bCancel,,) Centered
				If nOpc == 1
					If RecLock("SA1",.f.)
						SA1->A1_EMAIL	:= _cPara
						SA1->(MsUnlock())
					Endif
				Else
					Return Nil
				EndIf
				cPara	:= _cPara
			Endif
			
			// Envia Email apenas se realmente estiver preenchido
			If !Empty(cPara) .And. MV_PAR24 <> 1
				aAnexos := {cArquivo}
				
				cAccount	:= RTrim(SuperGetMV("MV_RELACNT"))	// emissao-nfe@gaveteiro.com.br
				cDe			:= RTrim(SuperGetMV("MV_RELACNT"))
				
				cPassword	:= Rtrim(SuperGetMv("MV_RELAPSW"))  // DN7*h8JQ
				cServer   	:= Rtrim(SuperGetMv("MV_RELSERV"))	// smtp.gmail.com:587
				If File(cArquivo)
					EnvMail(cAccount	,cPassword	,cServer	,cDe,;
						cPara,'Boleto - Cliente: ' + Capital(AllTrim(SA1->A1_NOME)) + ' - Referente seu RPS Nº ' + SE1->E1_NUM,'', aAnexos)
				Endif
			Endif
			//		FErase(cArquivo)
		ElseIf lAutoEMA
			oPrint:Preview()     // Visualiza antes de imprimir
			SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
			cArquivo := 'C:\TEMP\'+cFilename+'.PDF'
			Return cArquivo
		Endif
		Return ''
		
		/*
		+-----------+----------+-------+--------------------+------+-------------+
		| Programa  |BOLITAU   |Autor  |Microsiga           | Data |  11/21/05   |
		+-----------+----------+-------+--------------------+------+-------------+
		| Desc.     |Obtenção da linha digitavel/codigo de barras                |
		|           |                                                            |
		+-----------+------------------------------------------------------------+
		| Uso       | AP                                                         |
		+-----------+------------------------------------------------------------+
		*/
	Static Function fLinhaDig (cCodBanco, ; // Codigo do Banco (341)
		cCodMoeda, ; // Codigo da Moeda (9)
		cCarteira, ; // Codigo da Carteira
		cAgencia , ; // Codigo da Agencia
		cConta   , ; // Codigo da Conta
		cDvConta , ; // Digito verificador da Conta
		nValor   , ; // Valor do Titulo
		dVencto  , ; // Data de vencimento do titulo
		cNroDoc   )  // Numero do Documento Ref ao Contas a Receber
		
		Local cValorFinal   := StrZero(int(nValor*100),10)
		Local cFator        := StrZero(dVencto - CtoD("07/10/97"),4)   // Local cFator        := StrZero(dVencto - CtoD("07/10/97"),4)
		Local cCodBar   	:= Replicate("0",43)
		Local cCampo1   	:= Replicate("0",05)+"."+Replicate("0",05)
		Local cCampo2   	:= Replicate("0",05)+"."+Replicate("0",06)
		Local cCampo3   	:= Replicate("0",05)+"."+Replicate("0",06)
		Local cCampo4   	:= Replicate("0",01)
		Local cCampo5   	:= Replicate("0",14)
		Local cTemp     	:= ""
		Local cNossoNum 	:= Right(AllTrim(SE1->E1_NUMBCO),8) // Nosso numero
		Local cDV			:= "" // Digito verificador dos campos
		Local cLinDig		:= ""
		/*
		-------------------------
		Definicao do NOSSO NUMERO
		-------------------------
		*/
		If At("-",cConta) > 0
			cDig   := Right(AllTrim(cConta),1)
			cConta := AllTrim(Str(Val(Left(cConta,At('-',cConta)-1) + cDig)))
			//Else
			//	cConta := AllTrim(Str(Val(cConta)))
		Endif
		cNossoNum   := Alltrim(cAgencia) + Left(Alltrim(cConta),5) + cDvConta + cCarteira + Right(AllTrim(SE1->E1_NUMBCO),8) //cNroDoc
		xNossoNum	:= Alltrim(cAgencia) + Left(Alltrim(cConta),5) + cCarteira + Right(AllTrim(SE1->E1_NUMBCO),8) //cNroDoc
		cDvNN		:= Alltrim(Str(Modulo10(xNossoNum)))
		
		//cNossoNum   := cCarteira + cNroDoc + cDvNN
		//cNossoNum   := cCarteira + cNroDoc + '-' + cDvNN
		/*
		-----------------------------
		Definicao do CODIGO DE BARRAS
		-----------------------------
		*/
		//Alltrim(cNroDoc)              + ; // 23 a 30
		
		cTemp := Alltrim(cCodBanco)            + ; // 01 a 03
		Alltrim(cCodMoeda)            + ; // 04 a 04
		Alltrim(cFator)               + ; // 06 a 09
		Alltrim(cValorFinal)          + ; // 10 a 19
		Alltrim(cCarteira)            + ; // 20 a 22
		Right(AllTrim(SE1->E1_NUMBCO),8) +; // 23 A 30
		Alltrim(cDvNN)                + ; // 31 a 31
		Alltrim(cAgencia)             + ; // 32 a 35
		Alltrim(Left(cConta,5))       + ; // 36 a 40
		Alltrim(cDvConta)             + ; // 41 a 41
		"000"                             // 42 a 44
		cDvCB  := Alltrim(Str(modulo11(cTemp)))	// Digito Verificador CodBarras
		cCodBar:= SubStr(cTemp,1,4) + cDvCB + SubStr(cTemp,5)// + cDvNN + SubStr(cTemp,31)
		
		/*
		-----------------------------------------------------
		Definicao da LINHA DIGITAVEL (Representacao Numerica)
		-----------------------------------------------------
		
		Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
		AAABC.CCDDX		DDDDD.DDFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV
		
		CAMPO 1:
		AAA = Codigo do banco na Camara de Compensacao
		B = Codigo da moeda, sempre 9
		CCC = Codigo da Carteira de Cobranca
		DD = Dois primeiros digitos no nosso numero
		X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
		*/
		cTemp   := cCodBanco + cCodMoeda + cCarteira + Substr(Right(AllTrim(SE1->E1_NUMBCO),8),1,2)
		cDV		:= Alltrim(Str(Modulo10(cTemp)))
		cCampo1 := SubStr(cTemp,1,5) + '.' + Alltrim(SubStr(cTemp,6)) + cDV + Space(2)
		/*
		CAMPO 2:
		DDDDDD = Restante do Nosso Numero
		E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
		FFF = Tres primeiros numeros que identificam a agencia
		Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
		*/
		cTemp	:= Substr(Right(AllTrim(SE1->E1_NUMBCO),8),3) + cDvNN + Substr(cAgencia,1,3)
		//cDV		:= Str(modulo10(Alltrim(SEE->EE_AGENCIA)+Alltrim(SEE->EE_CONTA)+__cCarteira+Right(AllTrim(SE1->E1_NUMBCO),8)),1)
		cDV		:= Alltrim(Str(Modulo10(cTemp)))
		cCampo2 := Substr(cTemp,1,5) + '.' + Substr(cTemp,6) + cDV + Space(3)
		/*
		CAMPO 3:
		F = Restante do numero que identifica a agencia
		GGGGGG = Numero da Conta + DAC da mesma
		HHH = Zeros (Nao utilizado)
		Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
		*/
		cTemp   := Substr(cAgencia,4,1) + Left(cConta,5) + Alltrim(cDvConta) + "000"
		cDV		:= Alltrim(Str(Modulo10(cTemp)))
		cCampo3 := Substr(cTemp,1,5) + '.' + Substr(cTemp,6) + cDV + Space(2)
		/*
		CAMPO 4:
		K = DAC do Codigo de Barras
		*/
		cCampo4 := cDvCB + Space(2)
		/*
		CAMPO 5:
		UUUU = Fator de Vencimento
		VVVVVVVVVV = Valor do Titulo
		*/
		cCampo5 := cFator + StrZero(int(nValor * 100),14 - Len(cFator))
		cLinDig := cCampo1 + cCampo2 + cCampo3 + cCampo4 + cCampo5
		Return {cCodBar, cLinDig, cNossoNum}
		

		/*
		+-----------+----------+-------+--------------------+------+-------------+
		| Programa  |MODULO10  |Autor  |Microsiga           | Data |  21/11/05   |
		+-----------+----------+-------+--------------------+------+-------------+
		| Desc.     |Cálculo do Modulo 10 para obtenção do DV dos campos do      |
		|           |Codigo de Barras                                            |
		+-----------+------------------------------------------------------------+
		| Uso       | Financeiro Transilva LOG                                   |
		+-----------+------------------------------------------------------------+
		*/
		
	Static Function Modulo10(cData)
		Local  L,D,P := 0
		Local B     := .F.
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
		Return D
		
		/*
		+-----------+----------+-------+--------------------+------+-------------+
		| Programa  |MODULO11  |Autor  |Microsiga           | Data |  21/11/05   |
		+-----------+----------+-------+--------------------+------+-------------+
		| Desc.     |Calculo do Modulo 11 para obtencao do DV do Codigo de Barras|
		|           |                                                            |
		+-----------+------------------------------------------------------------+
		| Uso       | Financeiro Transilva LOG                                   |
		+-----------+------------------------------------------------------------+
		*/
	Static Function Modulo11(cData)
		Local L, D, P := 0
		L := Len(cdata)
		D := 0
		P := 1
		// Some o resultado de cada produto efetuado e determine o total como (D);
			While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
		If P = 9
			P := 1
		End
		L := L - 1
	End
	// DAC = 11 - Mod 11(D)
	D := 11 - (mod(D,11))
	// OBS: Se o resultado desta for igual a 0, 1, 10 ou 11, considere DAC = 1.
	If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
		D := 1
	End
Return D



Static Function EnvMail(cAccount	,cPassword	,cServer	,cFrom,;
		cEmail		,cAssunto	,cMensagem	,aAttach)
	
	Local cEmailTo := ""							// E-mail de destino
	Local cEmailBcc:= ""							// E-mail de copia
	Local lResult  := .F.							// Se a conexao com o SMPT esta ok
	Local cError   := ""							// String de erro
	Local lRelauth := SuperGetMv("MV_RELAUTH")		// Parametro que indica se existe autenticacao no e-mail
	Local lRet	   := .F.							// Se tem autorizacao para o envio de e-mail
	Local cConta   := GetMV("MV_RELACNT") //ALLTRIM(cAccount)				// Conta de acesso
	Local cSenhaTK := GetMV("MV_RELPSW") //ALLTRIM(cPassword)	        // Senha de acesso
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envia o mail para a lista selecionada. Envia como BCC para que a pessoa pense³
	//³que somente ela recebeu aquele email, tornando o email mais personalizado.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cEmailTo := cEmail
	If At(";",cEmail) > 0 // existe um segundo e-mail.
		cEmailBcc:= SubStr(cEmail,At(";",cEmail)+1,Len(cEmail))
	Endif
	
	CONNECT SMTP SERVER cServer ACCOUNT cConta PASSWORD cSenhaTK RESULT lResult
	
	// Se a conexao com o SMPT esta ok
	If lResult
		
		// Se existe autenticacao para envio valida pela funcao MAILAUTH
		If lRelauth
			lRet := Mailauth(cConta,cSenhaTK)
		Else
			lRet := .T.
		Endif
		
		
		cAnexos := ''
		For nI:=1 to Len(aAttach)
			If At(":",aAttach[nI])>0
				CPYT2S(aAttach[nI],GetSrvProfString("Startpath", "")+'\',.T.)
				aAttach[nI] := GetSrvProfString("Startpath", "")+'\'+SubStr(AllTrim(aAttach[nI]),RAT('\',AllTrim(aAttach[nI]))+1)
				
				cAnexos+=GetSrvProfString("Startpath", "")+'\'+SubStr(AllTrim(aAttach[nI]),RAT('\',AllTrim(aAttach[nI]))+1)+";"
			Endif
		Next
		cAnexos:=Left(cAnexos,Len(cAnexos)-1)
		
		cMensagem := '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'
		cMensagem += '<html>'
		cMensagem += '<head>'
		cMensagem += '  <meta http-equiv="Content-Type"'
		cMensagem += ' content="text/html;charset=UTF-8">'
		cMensagem += '  <title>Boleto</title>'
		cMensagem += '</head>'
		cMensagem += '<body>'
		cMensagem += '<table'
		cMensagem += ' style="font-family: Helvetica,Arial,Verdana,Sans-Serif; font-style: normal; font-variant: normal; font-weight: normal; font-size: 14px; line-height: 1.5; font-size-adjust: none; font-stretch: normal;"'
		cMensagem += ' align="center" bgcolor="#f5f5f5" border="0"'
		cMensagem += ' cellpadding="0" cellspacing="0" width="600">'
		cMensagem += '  <tbody>'
		cMensagem += '    <tr>'
		cMensagem += '      <td =""><img'
		cMensagem += ' style="width: 600px; height: 122px;" alt=""'
		cMensagem += ' src=""></td>'
		cMensagem += '    </tr>'
		cMensagem += '  </tbody>'
		cMensagem += '</table>'
		cMensagem += '<table'
		cMensagem += ' style="font-family: Helvetica,Arial,Verdana,Sans-Serif; font-style: normal; font-variant: normal; font-weight: normal; font-size: 14px; line-height: 1.5; font-size-adjust: none; font-stretch: normal; background-color: rgb(255, 255, 255);"'
		cMensagem += ' align="center" border="7" bordercolor="#edeff3"'
		cMensagem += ' cellpadding="10" cellspacing="0" width="600">'
		cMensagem += '  <tbody>'
		cMensagem += '    <tr>'
		cMensagem += '      <td =""><img'
		cMensagem += ' style="width: 600px; height: 95px;" alt=""'
		cMensagem += ' src=""></td>'
		cMensagem += '    </tr>'
		cMensagem += '    <tr>'
		cMensagem += '      <td>'
		cMensagem += '      <p>Prezado cliente '
		cMensagem += AllTrim(SA1->A1_NOME)
		cMensagem += '      </p>'
		cMensagem += '      <p>'
		cMensagem += 'Segue anexo o boleto referente a sua compra.'
		cMensagem += '      </p>'
		cMensagem += '      </td>'
		cMensagem += '    </tr>'
		cMensagem += '    <tr>'
		cMensagem += '      <td>'
		cMensagem += '      <table'
		cMensagem += ' style="background-color: rgb(255, 255, 255);" align="center"'
		cMensagem += ' border="1" bordercolor="#000000" cellpadding="0"'
		cMensagem += ' cellspacing="0" width="536">'
		cMensagem += '        <thead>'
		cMensagem += '        <tr>'
		cMensagem += '          <td style="padding: 10px 15px;"'
		cMensagem += ' bgcolor="#ededed">'
		cMensagem += '          <strong>Detalhes do '
		cMensagem += 'Boleto</strong>'
		cMensagem += '          </td>'
		cMensagem += '        </tr>'
		cMensagem += '        </thead>'
		cMensagem += '        <tbody>'
		cMensagem += '          <tr>'
		cMensagem += '            <td>'
		cMensagem += '            <ul'
		cMensagem += ' style="padding: 0pt 15px; list-style-type: none; line-height: 1.5;">'
		cMensagem += '              <li>'
		cMensagem += '                <strong>Valor: </strong>'
		cMensagem += '									<span>R$ ' + TransForm(aDadosTit[5],"@E 9,999,999,999.99")+'</span>'
		cMensagem += '              </li>'
		cMensagem += '              <li>  '
		cMensagem += '                <strong>Vencimento:'
		cMensagem += '                </strong><span>'+DtoC(aDadosTit[4])+'</span>'
		cMensagem += '              </li>'
		cMensagem += '              <li>'
		cMensagem += '                <strong>Linha Digitável: </strong>'
		cMensagem += '									<span>'+aCB_RN_NN[2]+'</span>'
		cMensagem += '              </li>'
		cMensagem += '              <li>  '
		cMensagem += '                <strong>Linha Copiável: </strong>'
		cMensagem += '									<span>'+aCB_RN_NN[1]+'</span>'
		cMensagem += '              </li>'
		cMensagem += '            </ul>'
		cMensagem += '            </td>'
		cMensagem += '          </tr>'
		cMensagem += '        </tbody>'
		cMensagem += '      </table>'
		cMensagem += '      </td>'
		cMensagem += '    </tr>'
		cMensagem += '    <tr>'
		cMensagem += '      <td>'
		cMensagem += '      <center><strong>Esta é uma mensagem automática. Favor não responda.<strong></strong></strong></center>'
		cMensagem += '      </td>'
		cMensagem += '    </tr>'
		cMensagem += '    <tr>'
		cMensagem += '      <td>'
		cMensagem += '      <p>Em caso de dúvidas, entre em contato com nosso departamento financeiro:<br>'
		cMensagem += '      <strong>Telefone:</strong>'
		cMensagem += '(12) <br>'
		cMensagem += '      <strong>E-Mail:</strong>'
		cMensagem += '      <a'
		cMensagem += ' href="mailto:financeiro@nitidezsecurity.com.br">financeiro@nitidezsecurity.com.br</a>'
		cMensagem += '      </p>'
		cMensagem += '      <p>'
		cMensagem += 'Atenciosamente,<br>'
		cMensagem += '      <strong>Equipe Nitidez</strong>'
		cMensagem += '      </p>'
		cMensagem += '      </td>'
		cMensagem += '    </tr>'
		cMensagem += '  </tbody>'
		cMensagem += '</table>'
		cMensagem += '</body>'
		cMensagem += '</html>'
		
		If lRet
			SEND MAIL FROM cFrom ;
				TO      	cEmailTo;
				SUBJECT 	cAssunto;
				BODY    	cMensagem;
				ATTACHMENT  cAnexos  ;
				RESULT lResult
			//danfe_000055024_000055024.pdf
			If !lResult
				//Erro no envio do email
				GET MAIL ERROR cError
//				Help(" ",1,'Erro no Envio do Email',,cError+ " " + cEmailTo,4,5)	//Atenção
			Endif
			
		Else
			GET MAIL ERROR cError
//			Help(" ",1,'Autenticação',,cError,4,5)  //"Autenticacao"
//			MsgStop('Erro de Autenticação','Verifique a conta e a senha para envio') 		 //"Erro de autenticação","Verifique a conta e a senha para envio"
		Endif
		
		DISCONNECT SMTP SERVER
		
/*		For nI:=1 To Len(aAttach)
			FErase(aAttach[nI])
		Next*/
	Else
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		Help(" ",1,'Erro no Envio do Email',,cError,4,5)      //Atencao
	Endif
	
Return(lResult)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AjustaSX1ºAutor ³Luis Henrique Robustoº Data ³  25/10/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ajusta o SX1 - Arquivo de Perguntas..                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Funcao Principal                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustaSX1(cPerg)
Local	aRegs   := {},;
		_sAlias := Alias(),;
		nX

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Campos a serem grav. no SX1³
		//³aRegs[nx][01] - X1_GRUPO   ³
		//³aRegs[nx][02] - X1_ORDEM   ³
		//³aRegs[nx][03] - X1_PERGUNTE³
		//³aRegs[nx][04] - X1_PERSPA  ³
		//³aRegs[nx][05] - X1_PERENG  ³
		//³aRegs[nx][06] - X1_VARIAVL ³
		//³aRegs[nx][07] - X1_TIPO    ³
		//³aRegs[nx][08] - X1_TAMANHO ³
		//³aRegs[nx][09] - X1_DECIMAL ³
		//³aRegs[nx][10] - X1_PRESEL  ³
		//³aRegs[nx][11] - X1_GSC     ³
		//³aRegs[nx][12] - X1_VALID   ³
		//³aRegs[nx][13] - X1_VAR01   ³
		//³aRegs[nx][14] - X1_DEF01   ³
		//³aRegs[nx][15] - X1_DEF02   ³
		//³aRegs[nx][16] - X1_DEF03   ³
		//³aRegs[nx][17] - X1_F3      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Cria uma array, contendo todos os valores...³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		aAdd(aRegs,{cPerg,'01','Prefixo De         ?' ,'Prefixo De         ?','Prefixo De         ?','mv_ch1','C', 3,0,0,'G','' ,'mv_par01','','','','','','',''})
        aAdd(aRegs,{cPerg,'02','Prefixo Ate        ?' ,'Prefixo Ate        ?','Prefixo Ate        ?','mv_ch2','C', 3,0,0,'G','' ,'mv_par02','','','','','','',''})
		aAdd(aRegs,{cPerg,'03','Titulo De          ?' ,'Titulo De          ?','Titulo De          ?','mv_ch3','C', 9,0,0,'G','' ,'mv_par03','','','','','','',''})
        aAdd(aRegs,{cPerg,'04','Titulo Ate         ?' ,'Titulo Ate         ?','Titulo Ate         ?','mv_ch4','C', 9,0,0,'G','' ,'mv_par04','','','','','','',''})
		aAdd(aRegs,{cPerg,'05','Parcela De         ?' ,'Parcela De         ?','Parcela De         ?','mv_ch5','C', 1,0,0,'G','' ,'mv_par05','','','','','','',''})
        aAdd(aRegs,{cPerg,'06','Parcela Ate        ?' ,'Parcela Ate        ?','Parcela Ate        ?','mv_ch6','C', 1,0,0,'G','' ,'mv_par06','','','','','','',''})
		aAdd(aRegs,{cPerg,'07','Portador De        ?' ,'Portador De        ?','Portador De        ?','mv_ch7','C', 3,0,0,'G','' ,'mv_par07','','','','','','',''})
        aAdd(aRegs,{cPerg,'08','Portador Ate       ?' ,'Portador Ate       ?','Portador Ate       ?','mv_ch8','C', 3,0,0,'G','' ,'mv_par08','','','','','','',''})
		aAdd(aRegs,{cPerg,'09','Cliente De         ?' ,'Cliente De         ?','Cliente De         ?','mv_ch9','C', 6,0,0,'G','' ,'mv_par09','','','','SA1','','',''})
        aAdd(aRegs,{cPerg,'10','Cliente Ate        ?' ,'Cliente Ate        ?','Cliente Ate        ?','mv_chA','C', 6,0,0,'G','' ,'mv_par10','','','','SA1','','',''})
		aAdd(aRegs,{cPerg,'11','Loja De            ?' ,'Loja De            ?','Loja De            ?','mv_chB','C', 2,0,0,'G','' ,'mv_par11','','','','','','',''})
        aAdd(aRegs,{cPerg,'12','Loja Ate           ?' ,'Loja Ate           ?','Loja Ate           ?','mv_chC','C', 2,0,0,'G','' ,'mv_par12','','','','','','',''})
		aAdd(aRegs,{cPerg,'13','Emissao De         ?' ,'Emissao De         ?','Emissao De         ?','mv_chD','D', 8,0,0,'G','' ,'mv_par13','','','','','','',''})
        aAdd(aRegs,{cPerg,'14','Emissao Ate        ?' ,'Emissao Ate        ?','Emissao Ate        ?','mv_chE','D', 8,0,0,'G','' ,'mv_par14','','','','','','',''})
		aAdd(aRegs,{cPerg,'15','Vencimento De      ?' ,'Vencimento De      ?','Vencimento De      ?','mv_chF','D', 8,0,0,'G','' ,'mv_par15','','','','','','',''})
        aAdd(aRegs,{cPerg,'16','Vencimento Ate     ?' ,'Vencimento Ate     ?','Vencimento Ate     ?','mv_chG','D', 8,0,0,'G','' ,'mv_par16','','','','','','',''})
		aAdd(aRegs,{cPerg,'17','Bordero De         ?' ,'Bordero De         ?','Bordero De         ?','mv_chH','C', 6,0,0,'G','' ,'mv_par17','','','','','','',''})
        aAdd(aRegs,{cPerg,'18','Bordero Ate        ?' ,'Bordero Ate        ?','Bordero Ate        ?','mv_chI','C', 6,0,0,'G','' ,'mv_par18','','','','','','',''})
		aAdd(aRegs,{cPerg,'19','Banco              ?' ,'Banco              ?','Banco              ?','mv_chJ','C', 3,0,0,'G','' ,'mv_par19','','','','SA6','','',''})
        aAdd(aRegs,{cPerg,'20','Agencia            ?' ,'Agencia            ?','Agencia            ?','mv_chK','C', 5,0,0,'G','' ,'mv_par20','','','','','','',''})
        aAdd(aRegs,{cPerg,'21','Conta              ?' ,'Conta              ?','Conta              ?','mv_chL','C',10,0,0,'G','' ,'mv_par21','','','','','','',''})
        aAdd(aRegs,{cPerg,'22','Envio Por Email    ?' ,'Envio Por Email    ?','Envio Por Email    ?','mv_chM','N', 1,0,0,'C','' ,'mv_par22','Sim','Nao','','','','',''})
        aAdd(aRegs,{cPerg,'23','Email Destinatario ?' ,'Envio Por Email    ?','Envio Por Email    ?','mv_chN','C',60,0,0,'G','' ,'mv_par23','','','','','','',''})
        aAdd(aRegs,{cPerg,'24','Salva c:\temp      ?' ,'Envio Por Email    ?','Envio Por Email    ?','mv_chO','N', 1,0,0,'C','' ,'mv_par24','Sim','Nao','','','','',''})
        
		DbSelectArea('SX1')
		SX1->(DbSetOrder(1))

		For nX:=1 to Len(aRegs)
			If !SX1->(DbSeek(aRegs[nx][01]+aRegs[nx][02]))
				RecLock('SX1',.t.)
				Replace SX1->X1_GRUPO		With aRegs[nx][01]
				Replace SX1->X1_ORDEM   	With aRegs[nx][02]
				Replace SX1->X1_PERGUNTE	With aRegs[nx][03]
				Replace SX1->X1_PERSPA		With aRegs[nx][04]
				Replace SX1->X1_PERENG		With aRegs[nx][05]
				Replace SX1->X1_VARIAVL		With aRegs[nx][06]
				Replace SX1->X1_TIPO		With aRegs[nx][07]
				Replace SX1->X1_TAMANHO		With aRegs[nx][08]
				Replace SX1->X1_DECIMAL		With aRegs[nx][09]
				Replace SX1->X1_PRESEL		With aRegs[nx][10]
				Replace SX1->X1_GSC			With aRegs[nx][11]
				Replace SX1->X1_VALID		With aRegs[nx][12]
				Replace SX1->X1_VAR01		With aRegs[nx][13]
				Replace SX1->X1_DEF01		With aRegs[nx][14]
				Replace SX1->X1_DEF02		With aRegs[nx][15]
				Replace SX1->X1_DEF03		With aRegs[nx][16]
				Replace SX1->X1_F3   		With aRegs[nx][17]
				Replace SX1->X1_PICTURE		With aRegs[nx][18]
				Replace SX1->X1_DEF04		With aRegs[nx][16]
				Replace SX1->X1_DEF05		With aRegs[nx][16]
				MsUnlock('SX1')
			Endif
		Next nX

Return

User Function VlrCnab()

nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
nSaldo		:= Round((SALDOTIT(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,1,DDatabase,,SE1->E1_LOJA) - nVlrAbat),2)

Return nSaldo
