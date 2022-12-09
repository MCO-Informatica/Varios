//#include 'fivewin.ch'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
//#INCLUDE "AP5MAIL.CH"
#include "topconn.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#DEFINE VMARGEM   200


/*/{Protheus.doc} IMPRPV
//TODO Descri��o auto-gerada.
@author rickson.oliveira
@since 15/11/2020
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

User Function IMPRPV ()

	Local cPerg := Padr('IMPRPVE',10)

	AjustaSX1(cPerg)

	Pergunte(cPerg,.t.)

	Private	cPedido  	:= SC5->C5_NUM		
	Private	nTitulo 	:= MV_PAR01			

	DbSelectArea('SC5')
	SC5->(DbSetOrder(1))

	If	( ! SC5->(DbSeek(xFilial('SC5') + cPedido)) )
		Help('',1,'IMPRPV',,OemToAnsi('Pedido n�o encontrado.'),1)
		Return .F.
	EndIf

	Private nRegSC5 := SC5->(Recno())

	// Executa a rotina de impress?o
	Processa({||RPed1PDF(),OemToAnsi('Gerando o relat�rio.')}, OemToAnsi('Aguarde...'))

Return

	********************************

Static Function AjustaSX1(cPerg)

	********************************

	Local   arrSX1 := {},;
		nX

	//Campos a serem grav. no SX1
	//arrSX1[nX][01] - X1_GRUPO
	//arrSX1[nX][02] - X1_ORDEM
	//arrSX1[nX][03] - X1_PERGUNTE
	//arrSX1[nX][04] - X1_PERSPA
	//arrSX1[nX][05] - X1_PERENG
	//arrSX1[nX][06] - X1_VARIAVL
	//arrSX1[nX][07] - X1_TIPO
	//arrSX1[nX][08] - X1_TAMANHO
	//arrSX1[nX][09] - X1_DECIMAL
	//arrSX1[nX][10] - X1_PRESEL
	//arrSX1[nX][11] - X1_GSC
	//arrSX1[nX][12] - X1_VALID
	//arrSX1[nX][13] - X1_VAR01
	//arrSX1[nX][14] - X1_DEF01
	//arrSX1[nX][15] - X1_DEF02
	//arrSX1[nX][16] - X1_DEF03
	//arrSX1[nX][17] - X1_F3

	aAdd(arrSX1,{cPerg,'01','Titulo do Relat�rio ?','Titulo do Relat�rio ?','Titulo do Relat�rio ?','MV_CH1','N', 1,0,1,'C','','MV_PAR01','Pedido de Venda',OemToAnsi('Or�amento'),'',''})

	DbSelectArea('SX1')
	SX1->(DbSetOrder(1))

	For nX:=1 to Len(arrSX1)
		If !SX1->(DbSeek(arrSX1[nX][1]+arrSX1[nX][2]))
			RecLock('SX1',.t.)
			Replace SX1->X1_GRUPO		With arrSX1[nX][1]
			Replace SX1->X1_ORDEM   	With arrSX1[nX][2]
			Replace SX1->X1_PERGUNTE	With arrSX1[nX][3]
			Replace SX1->X1_PERSPA		With arrSX1[nX][4]
			Replace SX1->X1_PERENG		With arrSX1[nX][5]
			Replace SX1->X1_VARIAVL		With arrSX1[nX][6]
			Replace SX1->X1_TIPO		With arrSX1[nX][7]
			Replace SX1->X1_TAMANHO		With arrSX1[nX][8]
			Replace SX1->X1_DECIMAL		With arrSX1[nX][9]
			Replace SX1->X1_PRESEL		With arrSX1[nX][10]
			Replace SX1->X1_GSC			With arrSX1[nX][11]
			Replace SX1->X1_VALID		With arrSX1[nX][12]
			Replace SX1->X1_VAR01		With arrSX1[nX][13]
			Replace SX1->X1_DEF01		With arrSX1[nX][14]
			Replace SX1->X1_DEF02		With arrSX1[nX][15]
			Replace SX1->X1_DEF03		With arrSX1[nX][16]
			Replace SX1->X1_F3   		With arrSX1[nx][17]
			MsUnlock('SX1')
		EndIf

	Next nX

Return

	********************************

Static Function RPed1PDF()

	********************************

	Private oFont, cCode, oPrn
	Private cCGCPict, cCepPict
	Private lPrimPag :=.t.
	Private  nPag  := 0

	Private nTotalGeral := 0
	Private lIpi:=.F.
	Private nIpi:= 0
	Private nVlrIpi:= 0
	Private nTotal:= 0
	Private cRazao := ""

	Private nPosV       := VMARGEM
	Private ncw     	:= 0
	Private li      	:= 1
	Private nLinMax	:= 2280  // N�mero m�ximo de Linhas  A4 - 2250 // Oficio - 2800
	Private nColMax	:= 3310  // N�mero m�ximo de Colunas A4 - 3310 // Oficio - 3955
	Private oPrint

	Private oFont1
	Private oFont2
	Private oFont3
	Private oFont4
	Private oFont5
	Private oFont6
	Private oFont7
	Private oFont8
	Private oFont9
	Private oFont10
	Private oFont11
	Private oFont12

	Private oFont1c
	Private oFont2c
	Private oFont3c
	Private oFont4c
	Private oFont5c
	Private oFont6c
	Private oFont7c
	Private oFont8c
	Private oFont9c
	Private oFont10c
	Private oBrush
	Private cCodCli := Space(06)
	Private cLojCli := Space(02)
	Private cTipCli := ''

	If Alltrim(cFilAnt)$"0101"
		cLogo := GetSrvProfString('Startpath','') + "logo01.bmp"
	elseif Alltrim(cFilAnt)$"0102"
		cLogo := GetSrvProfString('Startpath','') + "logo02.bmp"
	elseif Alltrim(cFilAnt)$"0103"
		cLogo := GetSrvProfString('Startpath','') + "logo03.bmp"
	else
		cLogo := GetSrvProfString('Startpath','') + "logo04.bmp"
	EndIf

	If MsgYesNo("Deseja Enviar Pedido de Venda por Email ?")
		lEmail := .t.
	Else
		lEmail := .f.
	Endif

	//????????????????????????????????????????????????????????????????



	//?Definir as pictures                                           ?
	//????????????????????????????????????????????????????????????????
	cCepPict:=PesqPict("SA1","A1_CEP")
	cCGCPict:=PesqPict("SA1","A1_CGC")


	cFilename := Criatrab(Nil,.F.)

	SC6->(DbSetOrder(1))
	If (SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM)))

		lAdjustToLegacy := .T.   //.F.
		lDisableSetup  := .T.
		oPrint := FWMSPrinter():New(cFilename, IMP_PDF, lAdjustToLegacy, , lDisableSetup)
		//	oPrint:Setup()
		oPrint:SetResolution(78)
		//oPrint:SetPortrait() // ou SetLandscape()
		oPrint:SetLandscape()
		oPrint:SetPaperSize(DMPAPER_A4)
		oPrint:SetMargin(10,10,10,10) // nEsquerda, nSuperior, nDireita, nInferior
		oPrint:cPathPDF := "" // Caso seja utilizada impress?o em IMP_PDF

		oPrint:cPathPDF := "C:\TEMP\" // Caso seja utilizada impress�o em IMP_PDF
		cDiretorio := oPrint:cPathPDF

		oFont1 := TFont():New( "Arial",,16,,.t.,,,,,.f. )
		oFont2 := TFont():New( "Arial",,16,,.f.,,,,,.f. )
		oFont3 := TFont():New( "Arial",,10,,.t.,,,,,.f. )
		oFont4 := TFont():New( "Arial",,10,,.f.,,,,,.f. )
		oFont5 := TFont():New( "Arial",,10,,.t.,,,,,.f. )
		oFont6 := TFont():New( "Arial",,08,,.f.,,,,,.f. )
		oFont7 := TFont():New( "Arial",,12,,.t.,,,,,.f. )
		oFont8 := TFont():New( "Arial",,12,,.f.,,,,,.f. )
		oFont9 := TFont():New( "Arial",,12,,.t.,,,,,.f. )
		oFont10:= TFont():New( "Arial",,12,,.f.,,,,,.f. )
		oFont11:= TFont():New( "Arial",,07,,.t.,,,,,.f. )
		oFont12:= TFont():New( "Arial",,07,,.f.,,,,,.f. )

		oFont1c := TFont():New( "Courier New",,16,,.t.,,,,,.f. )
		oFont2c := TFont():New( "Courier New",,16,,.f.,,,,,.f. )
		oFont3c := TFont():New( "Courier New",,10,,.t.,,,,,.f. )
		oFont4c := TFont():New( "Courier New",,10,,.f.,,,,,.f. )
		oFont5c := TFont():New( "Courier New",,09,,.t.,,,,,.f. )
		oFont6c := TFont():New( "Courier New",,10,,.T.,,,,,.f. )
		oFont7c := TFont():New( "Courier New",,14,,.t.,,,,,.f. )
		oFont8c := TFont():New( "Courier New",,14,,.f.,,,,,.f. )
		oFont9c := TFont():New( "Courier New",,12,,.t.,,,,,.f. )
		oFont10c:= TFont():New( "Courier New",,12,,.t.,,,,,.f. )
		oBrush	:= TBrush():NEW("",CLR_HGRAY)

		nDescProd := 0
		nTotal    := 0
		nTotMerc  := 0
		nOrder	  := 1
		nItem     := 0
		nTotIcmSol:= 0
		nRecSC6	  := SC6->(Recno())

		nPagD:=1
		nNrItem:=0

		While SC6->(!Eof()) .And. SC6->C6_FILIAL = xFilial("SC6") .And. SC6->C6_NUM == SC5->C5_NUM
			nNritem+=1
			SC6->(dbSkip())
		Enddo

		SC6->(dbGoTo(nRecSC6))
		nPagD := (nNRItem/6)
		nPagD := Iif(nPagD<1,1,Int(++nPagD))

		//????????????????????????????????????????????????????????????????
		//? Cria as variaveis para armazenar os valores do pedido        ?
		//????????????????????????????????????????????????????????????????
		nOrdem   := 1
		nReem    := 0

		//????????????????????????????????????????????????????????????????
		//? Filtra Tipo de SCs Firmes ou Previstas                       ?
		//????????????????????????????????????????????????????????????????

		ImpCabec()

		nTotal   := 0
		nTotMerc	:= 0
		nDescProd:= 0
		li       := 840
		nTotDesc := 0
		cCliente := SC5->(C5_CLIENTE+C5_LOJACLI)
		//    SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+cCliente))


		//+-----------------------------------------------------------------------------------+
		//| MAFIS()  -> Fun??o que calcula os impostos                                        |
		//+-----------------------------------------------------------------------------------+
		nDesconto:=0


		nDesconto:=0
		nItem := 1
		nValIcmSt := 0
		DbSelectArea("SC6")
		DbSetOrder(1)
		dbSeek(xFilial("SC6")+SC5->C5_NUM)

		MaFisSave()//Renato Ikeda - 03/02/2014 - inicializa fun??o fiscal
		MaFisEnd() //Renato Ikeda - 03/02/2014 - inicializa fun??o fiscal

		MaFisIni(cCodCli,cLojCli,"C","N",cTipCli,MaFisRelImp("MTR700",{"SC5","SC6"}),,,"SB1","MTR700",,,)

		While !Eof() .And. SC6->C6_FILIAL = xFilial("SC6") .And. SC6->C6_NUM == SC5->C5_NUM

			//????????????????????????????????????????????????????????????????
			//? Verifica se havera salto de formulario                       ?
			//????????????????????????????????????????????????????????????????
			//If li > 1900
			If li > 1500
				nOrdem++
				ImpRodape()			// Imprime rodape do formulario e salta para a proxima folha
				ImpCabec()
				li  := 840
			Endif

			li:=li+140

			SF4->(dbSetOrder(1), dbSeek(xFilial("SF4")+SC6->C6_TES))

			//oPrint:Say( li, 0050, SC6->C6_ITEM,oFont9,100 )
			//oPrint:Say( li, 0125, UPPER(SC6->C6_PRODUTO),oFont5,100 )

			////////////////////////////////////////////////////////////


			oPrint:Say( li, 0170, SC6->C6_ITEM,oFont9,100 )
			oPrint:Say( li, 0250, UPPER(SC6->C6_PRODUTO),oFont5,100 )

			MaFisAdd(SC6->C6_PRODUTO,;   	   	// 1-Codigo do Produto ( Obrigatorio )
			SC6->C6_TES,;		       			// 2-Codigo do TES ( Opcional )
			SC6->C6_QTDVEN,;		   			// 3-Quantidade ( Obrigatorio )
			SC6->C6_PRCVEN,;	       			// 4-Preco Unitario ( Obrigatorio )
			nDesconto,;                			// 5-Valor do Desconto ( Opcional )
			nil,;		               			// 6-Numero da NF Original ( Devolucao/Benef )
			nil,;		               			// 7-Serie da NF Original ( Devolucao/Benef )
			nil,;			       	   			// 8-RecNo da NF Original no arq SD1/SD2
			SC5->C5_FRETE/nNritem,;	  	 		// 9-Valor do Frete do Item ( Opcional )
			SC5->C5_DESPESA/nNritem,;  			// 10-Valor da Despesa do item ( Opcional )
			0,;   								// 11-Valor do Seguro do item ( Opcional )
			0,;						   			// 12-Valor do Frete Autonomo ( Opcional )
			SC6->C6_VALOR+nDesconto,;  			// 13-Valor da Mercadoria ( Obrigatorio )
			0,;						   			// 14-Valor da Embalagem ( Opcional )
			0,;		     			   			// 15-RecNo do SB1
			0) 	           	           			// 16-RecNo do SF4

			If SC6->(FieldPos("C6_IPI"))>0			
				If !Empty(SC6->C6_IPI)
					MaFisAlt("IT_ALIQIPI",SC6->C6_IPI,nItem)
				Endif
			Endif
			If SC6->(FieldPos("C6_ALIQISS"))>0
				If !Empty(SC6->C6_ALIQISS)
					MaFisAlt("IT_ALIQISS",SC6->C6_ALIQISS,nItem)
				Endif
			Endif

			nIPI        := MaFisRet(nItem,"IT_ALIQIPI")
			nICM        := MaFisRet(nItem,"IT_ALIQICM")
			nISS        := MaFisRet(nItem,"IT_ALIQISS")
			nPIS		:= MaFisRet(nItem,"IT_ALIQPIS")
			nCOFINS		:= MaFisRet(nItem,"IT_ALIQCOF")
			nValIcm     := MaFisRet(nItem,"IT_VALICM")
			nBasICM	  	:= MaFisRet(1,"IT_BASEICM")

			If !Empty(SF4->F4_BASEICM)	// Se Houver Redu??o da Base do ICMS ent?o Reduz a Aliquota Tamb?m
				nIcm		  := Ceiling(round(((SF4->F4_BASEICM*nIcm)/100),2))
			Endif

			nValIpi     := MaFisRet(nItem,"IT_VALIPI")
			nValIss     := MaFisRet(nItem,"IT_VALISS")
			nValPis     := MaFisRet(nItem,"IT_VALPS2")
			nValCof     := MaFisRet(nItem,"IT_VALCF2")
			nTotalItem  := MaFisRet(nItem,"IT_TOTAL")
			nTotIpi	  	:= MaFisRet(,'NF_VALIPI')
			nTotIss	  	:= MaFisRet(,'NF_VALISS')
			nTotPis	  	:= MaFisRet(,"NF_VALPS2")
			nTotCof	  	:= MaFisRet(,"NF_VALCF2")
			nTotIcms 	:= MaFisRet(,'NF_VALICM')
			nTotDesp	:= MaFisRet(,'NF_DESPESA')
			nTotFrete	:= MaFisRet(,'NF_FRETE')
			nTotalNF	:= MaFisRet(,'NF_TOTAL')
			nTotSeguro  := MaFisRet(,'NF_SEGURO')
			aValIVA     := MaFisRet(,"NF_VALIMP")
			nTotMerc    := MaFisRet(,"NF_TOTAL")
			nTotIcmSol  := MaFisRet(nItem,'NF_VALSOL')

			ImpProd()

			oPrint:Box( li+110, 0050, li+110,3150)

			dbSelectArea("SC6")

			SC6->(DbSkip())
			nItem++
		EndDo
		MaFisEnd()		//Termino

		FinalPed()		// Imprime os dados complementares do PC

	EndIf

	SC5->(dbGoTo(nRegSC5))

	oPrint:EndPage()     // Finaliza a pagina
	oPrint:Preview()     // Visualiza antes de imprimir


	CpyT2S( 'C:\TEMP\'+cFilename+'.PDF', "\system\spool", .F. )

	cAnexo  := '/system/spool/'+Lower(cFilename)+'.pdf'

	If lEmail
		U_MailV(cAnexo)		
	EndIf

Return

***************************

Static Function ImpCabec()

***************************


	cMoeda := "1"

	If !lPrimPag
		oPrint:EndPage()
		oPrint:StartPage()
	Else
		lPrimPag := .f.
		lEnc     := .t.
		oPrint:StartPage()
	EndIF
	oPrint:Say( 0020, 0040, " ",oFont,100 ) // startando a impressora

	//Cabecalho (Enderecos da Empresa e Fornecedor)
	oPrint:Box( 0020, 0040, 0410,3150)
	//oPrint:Box( 0250, 1800, 0410,3150)
	oPrint:Box( 0410, 0040, 0900,3150)
	oPrint:Box( 0900, 0040, 2390,3150)

	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))

	cCodCli		:= SA1->A1_COD
	cLojCli 	:= SA1->A1_LOJA
	cTipCli 	:= SA1->A1_TIPO
	cRazao		:= SA1->A1_NOME
	cEnd		:= SA1->A1_END
	cBairro		:= SA1->A1_BAIRRO
	cCidade		:= SA1->A1_MUN
	cNreduz 	:= SA1->A1_NREDUZ
	cTel		:= "("+Alltrim(SA1->A1_DDD)+")"+" "+Alltrim(SA1->A1_TEL) 
	cFax		:= Alltrim(SA1->A1_DDD)+" "+Alltrim(SA1->A1_FAX)
	cCNPJ		:= SA1->A1_CGC
	cIE			:=SA1->A1_INSCR
	cNr			:= IIF(MyGetEnd(SA1->A1_END,"SA1")[2]<>0,Str(MyGetEnd(SA1->A1_END,"SA1")[2]),"SN")
	cEstado		:= SA1->A1_EST
	cCep		:= SA1->A1_CEP
	cEmail		:= SA1->A1_EMAIL

	//Se for Retorno
	If SC5->C5_XTIPO == "R" 
	
		cLojCli		:= POSICIONE("SA2",1,XFILIAL("SA2")+SC5->C5_CLIENTE+ SC5->C5_LOJACLI,"A2_LOJA")
		cTipCli		:= POSICIONE("SA2",1,XFILIAL("SA2")+SC5->C5_CLIENTE+ SC5->C5_LOJACLI,"A2_TIPO")
		cNreduz 	:= POSICIONE("SA2",1,XFILIAL("SA2")+SC5->C5_CLIENTE+ SC5->C5_LOJACLI,"A2_NREDUZ")
		cRazao		:= POSICIONE("SA2",1,XFILIAL("SA2")+SC5->C5_CLIENTE+ SC5->C5_LOJACLI,"A2_NOME")
		cCidade 	:= POSICIONE("SA2",1,XFILIAL("SA2")+SC5->C5_CLIENTE+ SC5->C5_LOJACLI,"A2_MUN")
		cEstado		:= POSICIONE("SA2",1,XFILIAL("SA2")+SC5->C5_CLIENTE+ SC5->C5_LOJACLI,"A2_EST")	
		cBairro  	:= POSICIONE("SA2",1,XFILIAL("SA2")+SC5->C5_CLIENTE+ SC5->C5_LOJACLI,"A2_BAIRRO")
		cEnd		:= POSICIONE("SA2",1,XFILIAL("SA2")+SC5->C5_CLIENTE+ SC5->C5_LOJACLI,"A2_END")
		cTel		:= "(" + Alltrim(POSICIONE("SA2",1,XFILIAL("SA2")+SC5->C5_CLIENTE+ SC5->C5_LOJACLI,"A2_DDD")) + " " +  Alltrim(POSICIONE("SA2",1,XFILIAL("SA2")+SC5->C5_CLIENTE+ SC5->C5_LOJACLI,"A2_TEL"))
		cFax		:= Alltrim(POSICIONE("SA2",1,XFILIAL("SA2")+SC5->C5_CLIENTE+ SC5->C5_LOJACLI,"A2_DDD")) + " " + Alltrim(POSICIONE("SA2",1,XFILIAL("SA2")+SC5->C5_CLIENTE+ SC5->C5_LOJACLI,"A2_FAX"))
		cCNPJ		:= POSICIONE("SA2",1,XFILIAL("SA2")+SC5->C5_CLIENTE+ SC5->C5_LOJACLI,"A2_CGC")
		cIE			:= POSICIONE("SA2",1,XFILIAL("SA2")+SC5->C5_CLIENTE+ SC5->C5_LOJACLI,"A2_INSCR")
		cNr			:= " "	
		cCep		:= 	POSICIONE("SA2",1,XFILIAL("SA2")+SC5->C5_CLIENTE+ SC5->C5_LOJACLI,"A2_CEP")
		cEmail		:= 	POSICIONE("SA2",1,XFILIAL("SA2")+SC5->C5_CLIENTE+ SC5->C5_LOJACLI,"A2_EMAIL")
	EndIf


	// Dados do Cliente
	oPrint:Say( 0440, 0060, "N do Pedido:",oFont3c,100 )
	oPrint:Say( 0440, 0700, "Emissao:",oFont3c,100 )
	oPrint:Say( 0440, 1400, "Validade Prop:",oFont3c,100 )

	oPrint:Say( 0280, 2750, "Pagina(s):",oFont3c,100 )
	oPrint:Say( 0330, 2750, "Data Impressao:",oFont3c,100 )
	oPrint:Say( 0380, 2750, "Hora Impressao:",oFont3c,100 )

	oPrint:Say( 0280, 2900, StrZero(++nPag,3)+" de "+StrZero(nPagD,3), oFont3,100 )
	oPrint:Say( 0330, 2990, DtoC(Date()), oFont3,100 )
	oPrint:Say( 0380, 2990, Time(), oFont3,100 )

	oPrint:Say( 0480, 0060, "Cliente:",oFont3c,100 )
	oPrint:Say( 0480, 1400, "Nome Fantasia: ",oFont3c,100 )
	oPrint:Say( 0520, 0060, "Endereco:",oFont3c,100 )
	oPrint:Say( 0560, 0060, "Cidade/UF:",oFont3c,100 )
	oPrint:Say( 0560, 1400, "CEP:",oFont3c,100 )
	oPrint:Say( 0600, 0060, "CNPJ:",oFont3c,100 )
	oPrint:Say( 0600, 1400, "Insc.Est.:",oFont3c,100 )
	oPrint:Say( 0640, 0060, "Fone:",oFont3c,100 )
	oPrint:Say( 0640, 1400, "Fax:",oFont3c,100 )
	oPrint:Say( 0680, 0060, "Contato:",oFont3c,100 )
	oPrint:Say( 0680, 1400, "Email:",oFont3c,100 )

	oPrint:Say( 0440, 0450, SC5->C5_NUM,oFont3,100 )
	oPrint:Say( 0440, 0820, DtoC(SC5->C5_EMISSAO),oFont3,100 )
	oPrint:Say( 0480, 0320, SC5->C5_CLIENTE + ' - ' +cRazao,oFont3,100 )
	oPrint:Say (0480, 1700, cNreduz,oFont3,100 ) 
	oPrint:Say( 0520, 0320, AllTrim(cEnd)+" - "+cBairro,oFont3,100 )
	oPrint:Say( 0560, 0320, AllTrim(cCidade)+"-"+cEstado,oFont3,100 )
	oPrint:Say( 0560, 1700, TransForm(cCep,"@R 99999-999") ,oFont3,100 )
	oPrint:Say( 0600, 0320, TransForm(AllTrim(cCNPJ),cCGCPict),oFont3,100 )
	oPrint:Say( 0600, 1700, cIE,oFont3,100 )

	oPrint:Say( 0640, 0325, cTel,oFont3,100 )
	oPrint:Say( 0640, 1700, cFax,oFont3,100 )
	oPrint:Say( 0680, 1700, cEmail, oFont3,100 )

	oPrint:Box( 0730, 0040, 0730,3150)

	oPrint:Say( 0760, 0060, "Forma Pagto:",oFont3c,100 )
	oPrint:Say( 0800, 0060, "Tipo Frete:",oFont3c,100 )
	oPrint:Say( 0840, 0060, "Volume:",oFont3c,100 )
	oPrint:Say( 0760, 1400, "Peso L�quido:",oFont3c,100 )
	oPrint:Say( 0800, 1400, "Peso Bruto:",oFont3c,100 )
	oPrint:Say( 0840, 1400, "Transportadora:",oFont3c,100 )

	//oPrint:Say( 0880, 0060, "Numera??o Lacre:",oFont3c,100 )
	//oPrint:Say( 0880, 1200, "PRAZO FABRfwICA??O:",oFont3c,100 )

	//oPrint:Say( 0760, 1350, "R$-Real",oFont3,100 )

	oPrint:Say( 0760, 0320, Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_DESCRI"),oFont3,100 )    //Cond.Pgt
	oPrint:Say( 0800, 0320, SC5->C5_TPFRETE,oFont3,100 ) 												  //Tp.Frete.
	oPrint:Say( 0840, 0320, ALLTRIM(TransForm(SC5->C5_VOLUME1,PesqPict("SC5","C5_VOLUME1"))),oFont3,100 ) //Volume

	oPrint:Say( 0760, 1700, ALLTRIM(Transform(SC5->C5_PESOL,"@E 999,999.9999")),oFont3c,100 )    //Peso Liq.
	oPrint:Say( 0800, 1700,ALLTRIM(Transform(SC5->C5_PBRUTO,"@E 999,999.9999")),oFont3c,100 )   //Peso Bruto.
	oPrint:Say( 0840, 1700,SC5->C5_TRANSP + " - " + Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_NOME") ,oFont3c,100 )		//Transportadora


	//If SCJ->(FieldPos("CJ_XVEND")) > 0 .And. !Empty(SCJ->CJ_XVEND)
	//	oPrint:Say( 0800, 0450, Posicione("SA3",1,xFilial("SA3")+SCJ->CJ_XVEND,"A3_NOME"),oFont3,100 )
	//Endif
	//If SCJ->(FieldPos("CJ_XTPFRET")) > 0
	//	oPrint:Say( 0840, 0450, IIF(SCJ->CJ_XTPFRET=="F","Responsabilidade do Cliente","Responsabilidade do Fornecedor"),oFont3,100 )
	//Endif

	//Cabecalho Produto do Pedido

	oPrint:SayBitmap( 0025,2880,cLogo,0230,0230)
	//1960

	If nTitulo == 1
		oPrint:Say( 0010, 0060, "PEDIDO DE VENDA",oFont1,100 )
	Else
		oPrint:Say( 0010, 0060, "OR�AMENTO",oFont1,100 )
	EndIf

	// Dados da Empresa/Filial

	if (SM0->M0_ESTCOB == "SP")
		inscEst           := Alltrim(Transform(SM0->M0_INSC,"@R 999.999.999.999"))
	elseif (SM0->M0_ESTCOB == "RJ")
		inscEst           := Alltrim(Transform(SM0->M0_INSC,"@R 99.999999"))
	Else
		inscEst           := Alltrim(Transform(SM0->M0_INSC,"@R 99.999999"))
	endif

	cEmail	:= 'vendas@hgrextrusoras.com.br'

	oPrint:Say( 0130, 0060, SM0->M0_NOMECOM,oFont7,100 )
	oPrint:Say( 0180, 0060, AllTrim(SM0->M0_ENDCOB)+" - "+AllTrim(SM0->M0_BAIRCOB),oFont8,100 )
	oPrint:Say( 0230, 0060, AllTrim(SM0->M0_CIDCOB)+" - "+ SM0->M0_ESTCOB+" "+"CEP: " + Transform(SM0->M0_CEPCOB,'@R 99999-999'), oFont8,100 )
	oPrint:Say( 0280, 0060, "CNPJ: "+TransForm(AllTrim(SM0->M0_CGC),cCGCPict)+ " INSCR.EST.: " + inscEst ,oFont8,100 )
	oPrint:Say( 0330, 0060, "FONE: "+AllTrim(SM0->M0_TEL) + " | " + AllTrim(SM0->M0_FAX) + " | " + AllTrim(SM0->M0_TEL_PO) + " Email: " + cEmail,oFont8,100 )

	oPrint:FillRect({0903,0043,0949,3145},oBrush)
	oBrush:End()

	oPrint:Say( 0935, 0050, "Emp Fat" ,oFont3,100 )
	oPrint:Say( 0935, 0170, "Item" ,oFont3,100 )
	oPrint:Say( 0935, 0250, "Codigo" ,oFont3,100 )
	oPrint:Say( 0935, 0410, "Produto" ,oFont3,100 )
	oPrint:Say( 0935, 1250, "Quant."  ,oFont3,100 )
	oPrint:Say( 0935, 1500, "%ICMS" ,oFont3,100 )
	oPrint:Say( 0935, 1610, "%PIS" ,oFont3,100 )
	oPrint:Say( 0935, 1710, "%Cofins" ,oFont3,100 )
	oPrint:Say( 0935, 1855, "%IPI" ,oFont3,100 )
	oPrint:Say( 0935, 2010, "Vlr.Unit�rio" ,oFont3,100 )
	oPrint:Say( 0935, 2230, "Valor Total" ,oFont3,100 )
	//oPrint:Say( 0935, 2330, "%IPI" ,oFont3,100 )
	//oPrint:Say( 0935, 2330, "Emp Fat" ,oFont3,100 )
	oPrint:Say( 0935, 2400, "Cod. Fiscal" ,oFont3,100 )
	oPrint:Say( 0935, 2560, "Entrega" ,oFont3,100 )
	oPrint:Say( 0935, 2785, "Prod Final" ,oFont3,100 )
	oPrint:Say( 0935, 2990, "Classe Valor" ,oFont3,100 )

	oPrint:Box( 0950, 0040, 0950,3150)
	oPrint:Box( 0955, 0040, 0955,3150)


Return .T.

***************************

Static Function ImpProd()

***************************
	Local c_EOL		:= chr(13)+chr(10)
	Local  cDescri := ""
	Local n_ := 0

	//???????????????????????????????????????????????????????????????
	//? Impressao da descricao generica do Produto.                  ?
	//????????????????????????????????????????????????????????????????

	//cDescri := Trim(Posicione("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"SB1->B1_DESC"))
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial()+SC6->C6_PRODUTO)

	If SC6->C6_PRODUTO <> '999999999999999'
		cDescri := Capital(AllTrim(SB1->B1_DESC))
	Else
		cDescri := Capital(AllTrim(SC6->C6_DESCRI))
	Endif
	oPrint:Say( li   , 0410, cDescri ,oFont5,100 )

	If SC6->(FieldPos("C6_ZZPN")) <> 0
		oPrint:Say( li+30, 0400, 'Part Number: '+SC6->C6_ZZPN,oFont9,100 ) 
	Endif

	oPrint:Say( li,	0050, SC6->C6_X_EMPFA,oFont10c,100 ) //Empresa de Faturamento

	If SC6->C6_PRODUTO <> '999999999999999'
		If !Empty(SB1->B1_CODISS)	// Servi?o
			oPrint:Say( li+90, 0400, 'CS: '+SB1->B1_CODISS,oFont9,100 )
		Else
			oPrint:Say( li+90, 0400, 'NCM: '+TransForm(SB1->B1_POSIPI,PesqPict("SB1","B1_POSIPI")),oFont9,100 )
		Endif
	Else
		If !Empty(SC6->C6_CODISS)	// Servi?o
			oPrint:Say( li+90, 0400, 'CS: '+SC6->C6_CODISS,oFont9,100 )
		Else
			oPrint:Say( li+90, 0400, 'NCM: '+TransForm(SC6->C6_POSIPI,PesqPict("SB1","B1_POSIPI")),oFont9,100 )
		Endif
	Endif
	If SC6->(FieldPos("C6_XPRZENT")) > 0
		oPrint:Say( li+90, 0400, '('+AllTrim(Str(SC6->C6_XPRZENT,3))+") Dia(s) Apos a emiss?o da P.O.",oFont9,100 )
	Endif

	/*nValCusto	:= Round(SC6->C6_PRCVEN - 	(((nValIcm+nValIss+nValPis+nValCof))/SC6->C6_QTDVEN),2)*/

	//oPrint:Say( li, 0050, SC6->C6_ITEM,oFont9,100 )
	//oPrint:Say( li,	0050, SC6->C6_X_EMPFA,oFont10c,100 ) //Empresa de Faturamento
	oPrint:Say( li, 1150, Transform(SC6->C6_QTDVEN,'@E 999,999.999') ,oFont10c,100 )
	oPrint:Say( li, 1500, Transform(nICM,'@E 99.9') ,oFont10c,100 )
	oPrint:Say( li, 1600, Transform(Iif(nValPis>0,nPIS,0),'@E 99.99') ,oFont10c,100 )
	oPrint:Say( li, 1710, Transform(Iif(nValCof>0,nCOFINS,0),'@E 99.99') ,oFont10c,100 )
	oPrint:Say( li, 1833, Transform(nIPI,'@E 99.9') ,oFont10c,100 )
	//oPrint:Say( li, 1820, Transform(SC6->C6_PRCVEN,'@E 999,999.99') ,oFont10c,100 ) //Valor Unit
	//oPrint:Say( li, 2230, Transform(nIPI,'@E 99.9') ,oFont10c,100 )
	oPrint:Say( li, 1975, Transform(SC6->C6_PRCVEN,'@E 999,999.99') ,oFont10c,100 ) //Valor Unit
	oPrint:Say( li, 2147, Transform(nTotalItem,PesqPict("SC6","C6_VALOR",14,2)) ,oFont10c,100 )//Valor Total
	//oPrint:Say( li, 2330, SC6->C6_X_EMPFA,oFont10c,100 ) //Empresa de Faturamento
	oPrint:Say( li, 2410, SC6->C6_CF,oFont10c,100 ) //Cod. Fiscal
	oPrint:Say( li, 2560, Dtoc(SC6->C6_ENTREG),oFont10c,100 ) //Entrega
	oPrint:Say( li, 2773, SC6->C6_PRODFIN,oFont10c,100 ) //Produto Final
	oPrint:Say( li, 2995, SC6->C6_CLVL,oFont10c,100 ) //Classe Valor

	//////////////////////////160
	li:= li+100
	For n_ := 1 to mlcount(SC6->C6_VDOBS,170)
		//oPrint:Say( li+60, 0400,UPPER(SC6->C6_VDOBS),oFont9,100 )
		li:= li+40
		oPrint:Say( li, 170,UPPER(memoline(SC6->C6_VDOBS,170,n_)),oFont9,100 )	
	Next

	/////////////////////////
	//oPrint:Say( li, 2330, Transform(nTotalItem,PesqPict("SC6","C6_X_EMPFA",14,2)) ,oFont10c,100 )*/

	// Observacao do ITEM

	//If !Empty(SC6->C6_OBS)
	//	li+=40
	//	oPrint:Say( li, 0270,'Obs Item:',oFont8,100 )
	//	oPrint:Say( li, 0500,SubStr(SC6->C6_OBS,1,60),oFont9,100 )
	//	If !Empty(SubStr(SC6->C6_OBS,61,60))
	//		li+=40
	//		oPrint:Say( li, 0500,SubStr(SC6->C6_OBS,61,60),oFont9,100 )
	//	Endif
	//Endif
	nTotal  :=nTotal+SC6->C6_VALOR
	nTotDesc+=SC6->C6_VALDESC

Return .T.

Static Function FinalPed()
	Local nBegin
	Local nG

	//oPrint:Say( 2080, 0060, 'Condi��es Gerais de Fornecimento:',oFont9,100 )
	oPrint:Say( 1780, 0060, 'Condicoes Gerais de Fornecimento:',oFont9,100 )
	oPrint:Say( 1810, 0060, "1. Confirmacao do pedido: Pedidos verbais n�o serao aceitos. O pedido somente ser confirmado por formulario proprio do cliente ou atraves da retransmiss�o do orcamento enviado com a aprova��o do responsavel pela compra;",oFont7,100 )
	//oPrint:Say( 1840, 0060, "   retransmiss�o do or�amento enviado com a aprova��o do respons�vel pela compra;",oFont7,100 )
	oPrint:Say( 1840, 0060, "2. Cadastro: Enderecos de entrega, faturamento;  cobranca  e e-mail para envio do arquivo XML da Nota Fiscal Eletronica, devem ser informados corretamente.",oFont7,100 )
	//oPrint:Say( 1900, 0060, "   corretamente. ",oFont7,100 )
	oPrint:Say( 1870, 0060, "3. Para condicao de pagamento antecipado, feitos via dep�sito em conta: mandar comprovante via  e-mail, junto com o pedido;. ",oFont7,100 )
	oPrint:Say( 1900, 0060, "4. Pagamentos via boleto bancario: Informamos que este e enviado pelo email, ou juntamente com o produto, a contar da data de emissao da NF(e). Caso nao ocorra o recebimento no prazo estabelecido, contatar o Dept Financeiro",oFont7,100 )
	//oPrint:Say( 1990, 0060, "   Caso n�o ocorra o recebimento no prazo estabelecido, contatar o Dept Financeiro da empresa, para solicitar o envio da segunda via do boleto",oFont7,100 )
	oPrint:Say( 1930, 0060, "   da empresa, para solicitar o envio da segunda via do boleto atraves do e-mail: financeiro@hgrextrusoras.com.br;",oFont7,100 )
	oPrint:Say( 1960, 0060, "5. O Pedido de Compra deve citar o N� Proposta/Revis�o para que todo o processo possa ser rastreado.;",oFont7,100 )

	//diferen�a de 20 do ultimo

	oPrint:Box( 2070, 0040, 3000,3150)
	//oPrint:Box( 2390, 0040, 3000,3150)

	If cPaisLoc <> "BRA" .And. !Empty(aValIVA)
		For nG:=1 to Len(aValIVA)
			nValIVA+=aValIVA[nG]
		Next
	Endif

	/*
	cMensagem:= Formula(C5_MSG)

	If !Empty(cMensagem)
	li++
	@ li,002 PSAY Padc(cMensagem,129)
	Endif
	*/

	//oPrint:Say( 1400, 0420, "D E S C O N T O S -->" ,oFont3,100 )
	//oPrint:Say( 1400, 0950, Transform(SC6->C6_DESC1,"@E999.99") ,oFont4,100 )
	//oPrint:Say( 1400, 1170, Transform(SC6->C6_DESC2,"@E999.99") ,oFont4,100 )
	//oPrint:Say( 1400, 1400, Transform(SC6->C6_DESC3,"@E999.99") ,oFont4,100 )
	//oPrint:Say( 1400, 1750, Transform(xMoeda(nTotDesc,SC6->C6_MOEDA,1,SC6->C6_DATPRF),PesqPict("SC6","C6_VLDESC",14, 1)) ,oFont4,100 )

	//???????????????????????????????????????????????????????????????
	//? Acessar o Endereco para Entrega do Arquivo de Empresa SM0.   ?
	//????????????????????????????????????????????????????????????????
	cAlias := Alias()

	//oPrint:FillRect({2393,0043,2549,3145},oBrush)
	//oPrint:FillRect({2073,0043,2549,3145},oBrush)

	oBrush:End()

	oPrint:Say( 2100, 0060, "Descontos:" ,oFont3,100 )
	oPrint:Say( 2100, 0320, Transform(nTotDesc,tm(nTotDesc,14,MsDecimais(1))) ,oFont4c,100 )

	oPrint:Say( 2100, 0800, "Frete: ",oFont9,100 )
	oPrint:Say( 2100, 1100, Transform(nTotFrete,'@E 999,999.999') ,oFont4c,100 )

	oPrint:Say( 2140, 0060, "Seguro :" ,oFont3,100 )
	oPrint:Say( 2140, 0320, Transform(nTotSeguro,tm(nTotSeguro,14,MsDecimais(1))) ,oFont4c,100 )
	oPrint:Say( 2140, 0800, "Despesas :" ,oFont3,100 )
	oPrint:Say( 2140, 1040, Transform(nTotDesp,tm(nTotDesp,14,MsDecimais(1))) ,oFont4c,100 )

	oPrint:Say( 2100, 2700, "Total: ",oFont9,100 )
	oPrint:Say( 2100, 2930, Transform((nTotal+nTotFrete/*+nTotIcms*/+nTotSeguro+nTotDesp),tm((nTotal+nTotFrete+nTotIPI/*+nTotIcms*/+nTotSeguro+nTotDesp),14,MsDecimais(1))),oFont4c,100 )


	oPrint:Say( 2100, 1750, "ICMS :" ,oFont3,100 )
	oPrint:Say( 2100, 2010, Transform(nTotIcms,tm(nTotIcms,14,MsDecimais(1))) ,oFont4c,100 )









	oPrint:Say( 2140, 2700, "Total c/ IPI: ",oFont9,100 )





	oPrint:Say( 2140, 2930, Transform((nTotal+nTotFrete+nTotIPI/*+nTotIcms*/+nTotSeguro+nTotDesp),tm((nTotal+nTotFrete+nTotIPI/*+nTotIcms*/+nTotSeguro+nTotDesp),14,MsDecimais(1))),oFont4c,100 )




	oPrint:Say( 2140, 1750, "IPI: ",oFont9,100 )


	oPrint:Say( 2140, 2045, Transform(nTotIPI,'@E 999,999.999') ,oFont4c,100 )






	//oPrint:Box( 2550, 0040, 2550,3150)
	oPrint:Box( 2550, 0040, 2550,3150)
	oPrint:Box( 2640, 0040, 2640,3150)
	oPrint:Say( 2140, 0060, "Seguro :" ,oFont3,100 )
	oPrint:Say( 2190, 0060, "Observacoes: ",oFont3,100 )
	oPrint:Say( 2230, 0060, SC5->C5_OBS,oFont5,100 )
	oPrint:Say( 2290, 0060, "Dados do Vendedor (a): ",oFont3,100 )
	oPrint:Say( 2330, 0060, SC5->C5_VEND1 + " - ",oFont5,100 )
	oPrint:Say( 2330, 0165, Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_NOME"),oFont5,100 )

	aLinha := Tk3AMemo('', 100)
	li:=2680
	For nBegin := 1 To Len(aLinha)
		li+=40
		oPrint:Say( li, 0080, aLinha[nBegin] ,oFont5,100 )
	Next nBegin
Return .T.

***************************

Static Function ImpRodape()

***************************

	oPrint:Say( 3150, 0090, "CONTINUA ..." ,oFont3,100 )

Return .T.

**********************************************

Static Function MyGetEnd(cEndereco,cAlias)

***********************************************

	Local cCmpEndN	:= SubStr(cAlias,2,2)+"_ENDNOT"
	Local cCmpEst	:= SubStr(cAlias,2,2)+"_EST"
	Local aRet		:= {"",0,"",""}

	//Campo ENDNOT indica que endereco participante mao esta no formato <logradouro>, <numero> <complemento>
	//Se tiver com 'S' somente o campo de logradouro sera atualizado (numero sera SN)
	If (&(cAlias+"->"+cCmpEst) == "DF") .Or. ((cAlias)->(FieldPos(cCmpEndN)) > 0 .And. &(cAlias+"->"+cCmpEndN) == "1")
		aRet[1] := cEndereco
		aRet[3] := "SN"
	Else
		aRet := FisGetEnd(cEndereco)
	EndIf
Return aRet

***********************************************

Static Function Tk3AMemo(cCodigo,nTam)

***********************************************

	Local cString	:= ''//MSMM(cCodigo,nTam)		// Carrega o memo da base de dados
	Local nI		:= 0    					// Contador dos caracteres
	Local nL		:= 0						// Contador das linhas
	Local nJ
	Local cLinha	:= ""						// Guarda a linha editada no campo memo
	Local aLinhas	:= {}						// Array com o memo dividido em linhas

	cString := AllTrim(cString)+' '+Iif(SC5->(FieldPos("C5_OBS1"))>0,AllTrim(SC5->C5_OBS1),'')

	For nI := 1 TO Len(cString)
		If (nL < nTam) //(Ascii(SubStr(cString,nI,1)) <> 13) .AND.
			// Enquanto n?o houve enter na digitacao e a linha nao atingiu o tamanho maximo
			cLinha+=SubStr(cString,nI,1)
			nL++
		Else
			// Se a linha atingiu o tamanho maximo ela vai entrar no array
			//		If Ascii(SubStr(cString,nI,1)) <> 13
			nI--
			For nJ := Len(cLinha) To 1 Step -1
				// Verifica se a ultima palavra da linha foi quebrada, entao retira e passa pra frente
				If SubStr(cLinha,nJ,1) <> " "
					nI--
					nL--
				Else
					Exit
				Endif
			Next nJ
			// Se a palavra for maior que o tamanho maximo entao ela vai ser quebrada
			If nL <=0
				nL := Len(cLinha)
			Endif
			//		Endif

			// Testa o valor de nL para proteger o fonte e insere a linha no array
			If nL >= 0
				cLinha := SubStr(cLinha,1,nL)
				AAdd(aLinhas, cLinha)
				cLinha := ""
				nL := 0
			Endif
		Endif
	Next nI

	// Se o nL > 0, eh porque o uSCJrio nao deu enter no fim do memo e eu adiciono a linha no array.
	If nL >= 0
		cLinha := SubStr(cLinha,1,nL)
		AAdd(aLinhas, cLinha)
		cLinha := ""
		nL := 0
	Endif

Return(aLinhas)

	**************************************************

User Function MailV(cAnexo)

	***************************************************


	Local aArea        := GetArea()
	Local nAtual       := 0
	Local lRet         := .T.
	Local oMsg         := Nil
	Local oSrv         := Nil
	Local nRet         := 0
	Local cFrom        := Alltrim(GetMV("MV_RELACNT"))
	Local cUser        := SubStr(cFrom, 1, At('@', cFrom)-1)
	Local cPass        := Alltrim(GetMV("MV_RELPSW"))
	Local cSrvFull     := Alltrim(GetMV("MV_RELSERV"))
	Local cPara			:= Alltrim(GetMV("MV_XENDMAI"))
	Local cServer      := ""
	Local nPort        	:= 0
	Local cEmailCc		:= UsrRetMail(RetCodUsr())
	Local nTimeOut     := GetMV("MV_RELTIME")
	Local cLog         := ""
	Local cContaAuth   := ""
	Local cPassAuth    := ""
	Local nAtu         := 0
	Local cError		:= ""
	Local aAnexos    := {cAnexo}
	Local cMensagem		:= "Pedido encaminhado por: <b>"+cUserName+"</b>"
	Local cAssunto		:= 'Pedido de Vendas - No. ' + SC5->C5_NUM
	Local cAssinatu		:= ""
	Local cProcessos   := ""
	Default _cPara      := ""	
	Default cCorpo     := ""	
	Default lMostraLog := .F.
	Default lUsaTLS    := .T.
	Default lNovo      := .F.

	GetSrvProfString("Startpath","") 


	u_envMail(cPara ,cEmailCc ,cAssunto ,cMensagem ,aAnexos , cAssinatu, @cError, .f.)

	
	/*If lRet
		If lNovo
			cContaAuth := Alltrim(GetMV("MV_X_NCNT"))
			cPassAuth  := Alltrim(GetMV("MV_X_NPSW"))
			cSrvFull   := Alltrim(GetMV("MV_X_NSRV"))
		Else
			cContaAuth := cFrom
			cPassAuth  := cPass
		EndIf
		cServer      := Iif(':' $ cSrvFull, SubStr(cSrvFull, 1, At(':', cSrvFull)-1), cSrvFull)
		nPort        := Iif(':' $ cSrvFull, Val(SubStr(cSrvFull, At(':', cSrvFull)+1, Len(cSrvFull))), 587)
		//Cria a nova mensagem
		oMsg := TMailMessage():New()
		oMsg:Clear()
		//Define os atributos da mensagem
		//oMsg:cDate    := cValToChar(Date())
		oMsg:cFrom    := cFrom
		oMsg:cTo      := cPara
		oMsg:cSubject := cAssunto
		oMsg:cBody    := "Pedido de Venda gerado por: <b>"+cUserName+"</b>"
		
		oMsg:AttachFile(cAnexo)
		
		
		//Define se ir� utilizar o TLS
		If lUsaTLS
			oSrv:SetUseTLS(.T.)
		EndIf
		//Inicializa conex�o
		nRet := oSrv:Init("", cServer, cUser, cPass, 0, nPort)
		If nRet != 0
			cLog += "004 - Nao foi possivel inicializar o servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
			lRet := .F.
		EndIf
		If lRet
			//Define o time out
			nRet := oSrv:SetSMTPTimeout(nTimeOut)
			If nRet != 0
				cLog += "005 - Nao foi possivel definir o TimeOut '"+cValToChar(nTimeOut)+"'" + CRLF
			EndIf
			//Conecta no servidor
			nRet := oSrv:SMTPConnect()
			If nRet <> 0
				cLog += "006 - Nao foi possivel conectar no servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
				lRet := .F.
			EndIf
			If lRet
				//Realiza a autentica��o do usu�rio e senha
				nRet := oSrv:SmtpAuth(cContaAuth, cPassAuth)
				If nRet <> 0
					cLog += "007 - Nao foi possivel autenticar no servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
					lRet := .F.
				EndIf
				If lRet
					//Envia a mensagem
					nRet := oMsg:Send(oSrv)
					If nRet <> 0
						cLog += "008 - Nao foi possivel enviar a mensagem: " + oSrv:GetErrorString(nRet) + CRLF
						lRet := .F.
					EndIf
				EndIf
				//Disconecta do servidor
				nRet := oSrv:SMTPDisconnect()
				If nRet <> 0
					cLog += "009 - Nao foi possivel disconectar do servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
				EndIf
			EndIf
		EndIf
	EndIf
	//Se tiver log de avisos/erros
	If !Empty(cLog)
		//Busca todas as fun��es
		nAtu := 0
		 := ""
        /*
        While ! (ProcName(nAtu) == '')
            cProcessos += ProcName(nAtu) + "; "
            nAtu++
        EndDo
        
		cLog := "+======================= zEnvMail =======================+" + CRLF + ;
			"zEnvMail  - "+dToC(Date())+ " " + Time() + CRLF + ;
			"Funcao    - " + FunName() + CRLF + ;
			"Processos - " + cProcessos + CRLF + ;
			"Para      - " + _cPara + CRLF + ;
			"Assunto   - " + cAssunto + CRLF + ;
			"Corpo     - " + cCorpo + CRLF + ;
			"Existem mensagens de aviso: "+ CRLF +;
			cLog + CRLF +;
			"+======================= zEnvMail =======================+"
		//ConOut(cLog)
		//Se for para mostrar o log visualmente e for processo com interface com o usu�rio, mostra uma mensagem na tela
		If lMostraLog .And. ! IsBlind()
			Aviso("Log", cLog, {"Ok"}, 2)
		EndIf
	EndIf
	RestArea(aArea)*/

Return lRet
