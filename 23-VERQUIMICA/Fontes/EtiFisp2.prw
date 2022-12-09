#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#DEFINE DMPAPER_A4 9 //PAPEL A4

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ETIFISPQ  ºAutor  ³Nelson Junior    s   º Data ³  14/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impresão da etiqueta FISPQ.                                 º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EtiFisp2()

Private	cPerg := "ETIFISPQ"
Private oDlg  := Nil

PutSX1(cPerg,"01","Origem"	,"","","MV_CH1","N",01,0,1,"C",""							 ,""   ,"","","MV_PAR01","Producao","","","","Produto","","","OP","","","Manual","","","","","","","","")
PutSX1(cPerg,"02","OP"		,"","","MV_CH2","C",13,0,0,"G","Vazio() .Or. ExistCpo('SC2')","SC2","","","MV_PAR02",""		   ,"","","",""	      ,"","",""  ,"","",""		,"","","","","","","","")
PutSX1(cPerg,"03","Produto"	,"","","MV_CH3","C",15,0,0,"G","Vazio() .Or. ExistCpo('SB1')","SB1","","","MV_PAR03",""	  	   ,"","","",""	      ,"","",""  ,"","",""		,"","","","","","","","")
PutSX1(cPerg,"04","Lote"	,"","","MV_CH4","C",10,0,0,"G",""							 ,""   ,"","","MV_PAR04",""   	   ,"","","",""	      ,"","",""  ,"","",""		,"","","","","","","","")
PutSX1(cPerg,"05","Dt.Embal","","","MV_CH5","D",08,0,0,"G",""							 ,""   ,"","","MV_PAR05",""   	   ,"","","",""	      ,"","",""  ,"","",""		,"","","","","","","","")
PutSX1(cPerg,"06","Dt.Valid","","","MV_CH6","D",08,0,0,"G",""							 ,""   ,"","","MV_PAR06",""   	   ,"","","",""	      ,"","",""  ,"","",""		,"","","","","","","","")

Pergunte(cPerg,.T.)

DEFINE MSDIALOG oDlg FROM 200,001 TO 365,380 TITLE OemToAnsi("Impressão de Etiqueta - FISPQ") OF oDlg PIXEL
@ 002,002 TO 080,190 OF oDlg PIXEL

@ 001,002 SAY OemToAnsi("Este relatório faz a impressão da etiqueta FISPQ.")

@ 065,098 BMPBUTTON TYPE 01 ACTION (Close(oDlg),U_ImpFisp2(MV_PAR01, MV_PAR02, MV_PAR03, MV_PAR04, MV_PAR05, MV_PAR06, "M", .T., .T.))
@ 065,128 BMPBUTTON TYPE 02 ACTION Close(oDlg)
@ 065,158 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

ACTIVATE MSDIALOG oDlg CENTERED

Return()

User Function ImpFisp2(MV_PAR01, MV_PAR02, MV_PAR03, MV_PAR04, MV_PAR05, MV_PAR06, _cTipo, _lPri, _lUlt)

Local aStr1	:= {}
Local aStr2	:= {}
Local aStr3	:= {}
Local aStr4	:= {}
Local aStr5	:= {}  

Local lNcmProd := .F.
Local lNcm	   := .F.

Local _cProd	:= "" 
Local _cLote	:= ""
Local _cDtEmis	:= ""
Local _cDtVali	:= ""

Private cPath	 := GetSrvProfString("StartPath", "")

Private oPrint	 := TMSPrinter():New(OemToAnsi('Etiqueta FISPQ'))

Private oFont12n := TFont():New("Arial",,12,,.F.,,,,,.F.,.F.)
Private oFnt12nn := TFont():New("Arial",,12,,.T.,,,,,.F.,.F.) // 12 com negrito
Private oFont13n := TFont():New("Arial",,13,,.F.,,,,,.F.,.F.)
Private oFont16n := TFont():New("Arial",,16,,.F.,,,,,.F.,.F.)
Private oFont19n := TFont():New("Arial",,19,,.F.,,,,,.F.,.F.)
Private oFont22n := TFont():New("Arial",,22,,.F.,,,,,.F.,.F.)
Private oFont26n := TFont():New("Arial",,26,,.F.,,,,,.F.,.F.)

Private nLinha1 := 325
Private nLinha2 := 920
Private nLinha3 := 430
Private _cCtrPF := ""

If MV_PAR01 == 1 .And. Empty(MV_PAR02)
	MsgInfo("Quando a origem é a Ordem de Produção, seu código é obrigatório para a impressão da FISPQ.")
	Return()
ElseIf MV_PAR01 == 2 .And. Empty(MV_PAR03)
	MsgInfo("Quando a origem é o Produto, seu código é obrigatório para a impressão da FISPQ.")
	Return()
ElseIf MV_PAR01 == 2 .And. (AllTrim(Posicione("SB1",1,xFilial("SB1")+MV_PAR03,"B1_RASTRO")) == "L" .And. Empty(MV_PAR04))
	MsgInfo("Quando a origem é o Produto e o mesmo utiliza Lote, seu número é obrigatório para a impressão da FISPQ.")
	Return()
EndIf

If MV_PAR01 == 1
	_cProd 	 := Posicione("SC2",1,xFilial("SC2")+Left(MV_PAR02, 6),"C2_PRODUTO")
	_cVqMp	 := Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_VQ_MP")
	 
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+_cProd))
	
	_cMatPri := SB1->B1_VQ_MP
	_cNcm	 := AllTrim(SB1->B1_POSIPI)
	
	_cProDes := AllTrim(Posicione("SB1",1,xFilial("SB1")+_cMatPri,"B1_DESC"))
	_cCompos := AllTrim(Posicione("SB1",1,xFilial("SB1")+_cMatPri,"B1_VQ_COMP"))
	_cNrOnu  := AllTrim(Posicione("SB5",1,xFilial("SB5")+_cMatPri,"B5_ONU"))
	_cDesTec := AllTrim(Posicione("SB5",1,xFilial("SB5")+_cMatPri,"B5_CEME"))
	_nPesLiq := AllTrim(Str(Posicione("SG1",1,xFilial("SG1")+_cProd+_cMatPri,"G1_QUANT")))
	_nPesArr := AllTrim(Str(NoRound(Posicione("SG1",1,xFilial("SG1")+_cProd+_cMatPri,"G1_QUANT"), 1)))
	_cCtrPF  := AllTrim(Posicione("SB5",1,xFilial("SB5")+_cProd,"B5_PRODPF"))
	
	_cNrOp	 := MV_PAR02
	
	SD3->(DbSetOrder(1))
	SD3->(DbSeek(xFilial("SD3")+_cNrOp))
	
	While !SD3->(EoF()) .And. AllTrim(SD3->D3_COD) == AllTrim(_cProd)
		If AllTrim(SD3->D3_ESTORNO) <> "S"
			_cLote	 := SD3->D3_LOTECTL
			_cDtEmis := DtoC(SD3->D3_EMISSAO)
			_cDtVali := DtoC(SD3->D3_DTVALID)
		EndIf
		SD3->(DbSkip())
	EndDo
	//
	If Empty(_cDtEmis)
		MsgInfo("Não existe produção para essa OP.")
		Return()
	EndIf
	//
ElseIf MV_PAR01 == 2
	//
	_cProd := MV_PAR03
	_cVqMp	 := Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_VQ_MP")
	//
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+_cProd))
	//
	If AllTrim(SB1->B1_TIPO) == "MP"
		_cMatPri := SB1->B1_COD
	Else
		_cMatPri := SB1->B1_VQ_MP
	EndIf
	//
	_cNcm	 := AllTrim(SB1->B1_POSIPI)
	//
	_cProDes := AllTrim(Posicione("SB1",1,xFilial("SB1")+_cMatPri,"B1_DESC"))
	_cCompos := AllTrim(Posicione("SB1",1,xFilial("SB1")+_cMatPri,"B1_VQ_COMP"))
	_cNrOnu  := AllTrim(Posicione("SB5",1,xFilial("SB5")+_cMatPri,"B5_ONU"))
	_cDesTec := AllTrim(Posicione("SB5",1,xFilial("SB5")+_cMatPri,"B5_CEME"))
	_nPesLiq := AllTrim(Str(Posicione("SG1",1,xFilial("SG1")+_cProd+_cMatPri,"G1_QUANT")))
	_nPesArr := AllTrim(Str(NoRound(Posicione("SG1",1,xFilial("SG1")+_cProd+_cMatPri,"G1_QUANT"), 1)))
	_cCtrPF  := AllTrim(Posicione("SB5",1,xFilial("SB5")+_cProd,"B5_PRODPF"))
	_cNrOp	 := ""
	//
	If _cTipo == "M"
		//
		DbSelectArea("SB8")
		DbSetOrder(5)
		IF DbSeek(xFilial("SB8")+_cProd+MV_PAR04)
		
			While !SB8->(EoF()) .And. AllTrim(SB8->B8_PRODUTO) == AllTrim(_cProd) .And. AllTrim(SB8->B8_LOTECTL) == AllTrim(MV_PAR04)
				_cLote	 := SB8->B8_LOTECTL
				If !Empty(_cDtVali)				
					_cDtVali := DtoC(SB8->B8_DTVALID)
				EndIf
				SB8->(DbSkip())
			EndDo
			//
		Else                        
			// Alimenta o lote quando a etiqueta for manual e não existir o lote no sistema
			IF SB1->B1_RASTRO <> "N"
				_cLote	 := MV_PAR04
				_cDtVali := DtoC(MV_PAR06)
		    EndIf
		    //
		EndIf
		//
	Else
		//
		_cLote	 := MV_PAR04
		_cDtEmis := DtoC(MonthSub(MV_PAR06,_cPrzVal))
		_cDtVali := DtoC(MV_PAR06)
		//
	EndIf
	//
ElseIf MV_PAR01 == 3
	//
	_cProd := Posicione("SC2",1,xFilial("SC2")+Left(MV_PAR02, 6),"C2_PRODUTO")
	_cVqMp	 := Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_VQ_MP")
	
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+_cProd))
	
	_cMatPri := SB1->B1_VQ_MP
	_cNcm	 := AllTrim(SB1->B1_POSIPI)
	
	_cProDes := AllTrim(Posicione("SB1",1,xFilial("SB1")+_cMatPri,"B1_DESC"))
	_cCompos := AllTrim(Posicione("SB1",1,xFilial("SB1")+_cMatPri,"B1_VQ_COMP"))
	_cNrOnu  := AllTrim(Posicione("SB5",1,xFilial("SB5")+_cMatPri,"B5_ONU"))
	_cDesTec := AllTrim(Posicione("SB5",1,xFilial("SB5")+_cMatPri,"B5_CEME"))
	_nPesLiq := AllTrim(Str(Posicione("SG1",1,xFilial("SG1")+_cProd+_cMatPri,"G1_QUANT")))
	_nPesArr := AllTrim(Str(NoRound(Posicione("SG1",1,xFilial("SG1")+_cProd+_cMatPri,"G1_QUANT"), 1)))
	_cCtrPF  := AllTrim(Posicione("SB5",1,xFilial("SB5")+_cProd,"B5_PRODPF"))
	_cNrOp	 := MV_PAR02
	
	//
	_cLote	 := U_gNjrOpLt(1, _cNrOp)
	_cDtVali := U_gNjrOpLt(2, _cNrOp)
	_cDtEmis := U_gNjrOpLt(3, _cNrOp)
	//
	//_cDtEmis := If(Empty(_cDtEmis), "", DtoC(_cDtEmis))
	_cDtVali := If(Empty(_cDtVali), "", DtoC(_cDtVali))
	//_cDtVali := DtoC(_cDtVali)
			
	//
ElseIf MV_PAR01 == 4
	//
	_cProd := MV_PAR03
	_cVqMp	 := Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_VQ_MP")
	
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+_cProd))
	
	_cMatPri := SB1->B1_VQ_MP
	_cNcm	 := AllTrim(SB1->B1_POSIPI)
	
	_cProDes := AllTrim(Posicione("SB1",1,xFilial("SB1")+_cMatPri,"B1_DESC"))
	_cCompos := AllTrim(Posicione("SB1",1,xFilial("SB1")+_cMatPri,"B1_VQ_COMP"))
	_cNrOnu  := AllTrim(Posicione("SB5",1,xFilial("SB5")+_cMatPri,"B5_ONU"))
	_cDesTec := AllTrim(Posicione("SB5",1,xFilial("SB5")+_cMatPri,"B5_CEME"))
	_nPesLiq := AllTrim(Str(Posicione("SG1",1,xFilial("SG1")+_cProd+_cMatPri,"G1_QUANT")))
	_nPesArr := AllTrim(Str(NoRound(Posicione("SG1",1,xFilial("SG1")+_cProd+_cMatPri,"G1_QUANT"), 1)))
	_cCtrPF  := AllTrim(Posicione("SB5",1,xFilial("SB5")+_cProd,"B5_PRODPF"))
	_cNrOp	 := MV_PAR02
	//
	_cLote	 := MV_PAR04
	_cDtEmis := If(Empty(MV_PAR05), "", DtoC(MV_PAR05))
	_cDtVali := If(Empty(MV_PAR06), "", DtoC(MV_PAR06))

	//
EndIf

DbSelectArea("Z08")
DbSelectArea("Z09")
DbSelectArea("Z10")

Z08->(DbSetOrder(1))
Z09->(DbSetOrder(1))
Z10->(DbSetOrder(1))

If Z09->(DbSeek(xFilial("Z09")+_cNcm+_cProd))
	lNcmProd := .T.
ElseIf (!Empty(_cNcm) .And. Z09->(DbSeek(xFilial("Z09")+_cNcm)))
	lNcm := .T.
EndIf

If lNcmProd .Or. lNcm

	If(!Empty(Z09->Z09_IMG1),oPrint:SayBitmap(040,1950,Z09->Z09_IMG1,350,350),"")
	If(!Empty(Z09->Z09_IMG2),oPrint:SayBitmap(040,2300,Z09->Z09_IMG2,350,350),"")
	If(!Empty(Z09->Z09_IMG3),oPrint:SayBitmap(040,2650,Z09->Z09_IMG3,350,350),"")
	If(!Empty(Z09->Z09_IMG4),oPrint:SayBitmap(040,3000,Z09->Z09_IMG4,350,350),"")

	If(lNcmProd, Z10->(DbSeek(xFilial("Z10")+_cNcm+_cProd)), Z10->(DbSeek(xFilial("Z10")+_cNcm)))
	
	While !Z10->(EoF()) .And. If(lNcmProd, Z10->Z10_NCM == _cNcm .And. Z10->Z10_PRODUT == _cProd, Z10->Z10_NCM == _cNcm .And. Empty(Z10->Z10_PRODUT))
		//
		Z08->(DbSeek(xFilial("Z08")+Z10->Z10_CODIGO+Z10->Z10_ITEMCO))
		//
		If Z08->Z08_TIPO == "1"
			AAdd(aStr1, {AllTrim(Z08->Z08_CODIGO), AllTrim(Z08->Z08_DESCRI)+Space(1)})
		ElseIf Z08->Z08_TIPO == "2"
			AAdd(aStr2, {AllTrim(Z08->Z08_CODIGO), AllTrim(Z08->Z08_DESCRI)+Space(1)})
		ElseIf Z08->Z08_TIPO == "3"
			AAdd(aStr3, {AllTrim(Z08->Z08_CODIGO), AllTrim(Z08->Z08_DESCRI)+Space(1)})
		ElseIf Z08->Z08_TIPO == "4"
			AAdd(aStr4, {AllTrim(Z08->Z08_CODIGO), AllTrim(Z08->Z08_DESCRI)+Space(1)})
		ElseIf Z08->Z08_TIPO == "5"
			AAdd(aStr5, {AllTrim(Z08->Z08_CODIGO), AllTrim(Z08->Z08_DESCRI)+Space(1)})
		EndIf
		//
		Z10->(DbSkip())
		//
	EndDo
	
	If _lPri
		oPrint:SetLandScape()
		oPrint:SetPaperSize(DMPAPER_A4)
		oPrint:Setup()
	EndIf
	
	oPrint:StartPage() 
  
	cLogoD	:= GetSrvProfString("Startpath","") + "logo.BMP"

	oPrint:SayBitmap(040,100,cLogoD,409,240)

	oPrint:Say(40,550,AllTrim(SM0->M0_NOMECOM),oFont12n) 
	oPrint:Say(85,550,AllTrim(SM0->M0_ENDCOB) + " - " + AllTrim(SM0->M0_BAIRCOB),oFont12n) 	
	oPrint:Say(130,550,AllTrim(SM0->M0_CEPCOB) + " - " + AllTrim(SM0->M0_CIDCOB) + " - " + AllTrim(SM0->M0_ESTCOB) + " - FONE: " + AllTrim(SM0->M0_TEL),oFont12n) 
	oPrint:Say(175,550,"E-MAIL: VERQUIMICA@VERQUIMICA.COM.BR",oFont12n) 
	oPrint:Say(215,550,"INSCR. EST. 336.125.845.118",oFont12n) 
	oPrint:Say(260,550,"CNPJ: 43.588.060/0001-80",oFont12n)

	oPrint:Box(nLinha1,100,475,2040)
	oPrint:Box(nLinha1,100,475,550)
	oPrint:Say(nLinha1+10,150,"NOME DO",oFont19n) 
	oPrint:Say(nLinha1+80,150,"PRODUTO", oFont19n) 	
	oPrint:Say(nLinha1+10,580,_cProDes,If(Len(_cProDes) > 18, oFont19n, oFont22n))
	
	oPrint:Box(nLinha1,1570,475,1800)
	oPrint:Say(nLinha1+10,1670,"Nº",oFont19n)
	oPrint:Say(nLinha1+80,1630,"ONU",oFont19n)
	oPrint:Say(nLinha1+10,1824,_cNrOnu,oFont19n)       
	
	oPrint:Box(nLinha1+190,100,680,2040)  //BOX
	oPrint:Box(nLinha1+190,100,680,485)   //BOX PESO LIQUIDO
	oPrint:Box(nLinha1+190,485,680,735)  //BOX OE
	oPrint:Box(nLinha1+190,735,680,1185)  //BOX N LOTE
	oPrint:Box(nLinha1+190,1185,680,1630) //BOX DATA EMB  
	oPrint:Box(nLinha1+190,1630,680,2040) //BOX VALIDADE                                              
	oPrint:Say(nLinha1+200,120,"PESO LÍQUIDO",oFont12n)
	oPrint:Say(nLinha1+275,180,_nPesArr+" KG",oFont16n)
	oPrint:Say(nLinha1+200,505,"OE",oFont12n)
	oPrint:Say(nLinha1+275,505,Left(_cNrOp, 6),oFont19n)
	oPrint:Say(nLinha1+200,745,"Nº DO LOTE",oFont12n)
	oPrint:Say(nLinha1+275,745,_cLote,oFont19n)        
	oPrint:Say(nLinha1+200,1195,"DATA EMB",oFont12n)
	oPrint:Say(nLinha1+275,1195,IIF(VALTYPE(_cDtEmis)=="D",DTOC(_cDtEmis),_cDtEmis),oFont19n)
	oPrint:Say(nLinha1+200,1640,"VALIDADE",oFont12n)
	oPrint:Say(nLinha1+275,1640,_cDtVali,oFont19n)   
	
	oPrint:Say(nLinha1+410,100,"A FISPQ (Ficha de Informações de Segurança de Produto Químico) deste produto está",oFont12n) 
	oPrint:Say(nLinha1+465,100,"disponível no site: wwww.verquimica.com.br",oFont12n) 
	oPrint:Say(nLinha1+515,100,"Telefone de emergência: SUATRANS : 0800-707-7022",oFont12n) 

	oPrint:Say(nLinha1+1785,100,"SOMENTE PARA USO INDUSTRIAL." ,oFont12n)
	If _cCtrPF == 'S'
		oPrint:Say(nLinha1+1785,850,"     [ PRODUTO CONTROLADO PELA POLÍCIA FEDERAL ] " ,oFnt12nn)
	EndIf	
	oPrint:Say(nLinha1+1835,100,"O usuário deve ser informado dos riscos antes da utilização.",oFont12n)	
	oPrint:Say(nLinha1+1885,100,"Químico Responsável: ",oFont12n)
	oPrint:Say(nLinha1+1885,570,AllTrim(GetMV("MV_NOMQUIM", .F.)),oFont12n)
	oPrint:Say(nLinha1+1945,100,"INDÚSTRIA BRASILEIRA",oFont12n)	
	oPrint:Say(nLinha1+1995,100,"VENDA PROIBIDA PARA MENORES DE 18 ANOS",oFont12n)
	
	//Código de barra do lote
	If(Empty(_cLote), "", MSBAR("CODE128",7,11.75,AllTrim(_cLote),oPrint,.F.,,.T.,0.04,1.5,Nil,Nil,Nil,.F.))
	
	//Código de barra do produto
	MSBAR("CODE128",18.6,14,AllTrim(_cProd),oPrint,.F.,,.T.,0.04,1.5,Nil,Nil,Nil,.F.)
	oPrint:Say(nLinha1+2055,1680,AllTrim(_cProd),oFont12n)

	MSBAR("CODE128",18.6,21.35,AllTrim(_nPesLiq),oPrint,.F.,,.T.,0.06,1.5,Nil,Nil,Nil,.F.)  

	oPrint:Say(nLinha1+2057,2880,AllTrim(_nPesLiq),oFont12n)
                                                               	
/*
// bkp	
	//Código de barra do produto
	MSBAR("CODE128",18.7,18.5,AllTrim(_cProd),oPrint,.F.,,.T.,0.04,1.5,Nil,Nil,Nil,.F.)
	oPrint:Say(nLinha1+1965,2200,AllTrim(_cProd),oFont12n)
*/
/*
//         			 1		  2	 3		 4		 5		  6      7		 8	    9	     10     11      12    13     14      15       16
Function MSBAR(cTypeBar,nRow,nCol,cCode,oPrint,lCheck,Color,lHorz,nWidth,nHeigth,lBanner,cFont,cMode,lPrint,nPFWidth,nPFHeigth,lCmtr2Pix)


±±?Parametros? 01 cTypeBar String com o tipo do codigo de barras           ?±± 
±±?          ? 				"EAN13","EAN8","UPCA" ,"SUP5"   ,"CODE128"     ?±±
±±?          ? 				"INT25","MAT25,"IND25","CODABAR","CODE3_9"     ?±±
±±?          ? 				"EAN128"                                       ?±±
±±?          ? 02 nRow		Numero da Linha em centimentros                ?±±
±±?          ? 03 nCol		Numero da coluna em centimentros			   ?±±
±±?          ? 04 cCode		String com o conteudo do codigo                ?±±
±±?          ? 05 oPr		Obejcto Printer                                ?±±
±±?          ? 06 lcheck	Se calcula o digito de controle                ?±±
±±?          ? 07 Cor 		Numero  da Cor, utilize a "common.ch"          ?±±
±±?          ? 08 lHort		Se imprime na Horizontal                       ?±±
±±?          ? 09 nWidth	Numero do Tamanho da barra em centimetros      ?±±
±±?          ? 10 nHeigth	Numero da Altura da barra em milimetros        ?±±
±±?          ? 11 lBanner	Se imprime o linha em baixo do codigo          ?±±
±±?          ? 12 cFont		String com o tipo de fonte                     ?±±
±±?          ? 13 cMode		String com o modo do codigo de barras CODE128  ?±±
±±?          ? 14 lPrint	Logico que indica se imprime ou nao            ?±±
±±?          ? 15 nPFWidth	Numero do indice de ajuste da largura da fonte ?±±
±±?          ? 16 nPFHeigth Numero do indice de ajuste da altura da fonte  ?±± 

*/


	
	//Lado Direito
	oPrint:Say(nLinha3 := nLinha3,2120,"Nome comercial:",oFont12n)
	oPrint:Say(nLinha3,2470,_cProDes,oFont12n)
	//
	oPrint:Say(nLinha3 := nLinha3+100,2120,"Nome técnico:",oFont12n)
	oPrint:Say(nLinha3,2420,_cDesTec,oFont12n)
	//
	oPrint:Say(nLinha3 := nLinha3+50,2120,"Composição:",oFont12n)
	oPrint:Say(nLinha3,2420,_cCompos,oFont12n)
	//
	oPrint:Say(nLinha3 := nLinha3+100,2120,"PALAVRA DE ADVERTÊNCIA:",oFont12n)
	oPrint:Say(nLinha3,2720,If(AllTrim(Z09->Z09_PALAVR) == "1", "Perigo", "Atenção"),oFont12n)

	If !Empty(aStr5)
		//
		aStr5 := ASort(aStr5,,,{|x,y| x[1] < y[1]})
		//
		oPrint:Say(nLinha3 := nLinha3+100,2120,"FRASES DE PERIGO",oFont12n)
		//
		For i := 1 To Len(aStr5)
			//
			cString := aStr5[i][1]+" - "+aStr5[i][2]
			//
			nCol := 1
			//
			For j := 1 To Int(Len(cString)/60)+1
				nCol2 := Rat(" ", SubStr(cString, nCol, 60))

				If !Empty(nCol2)
					oPrint:Say(nLinha3 := nLinha3+50,2120,SubStr(cString, nCol, nCol2),oFont12n)
					If(Int(Len(cString)/60)+1 == j, j--, j)
				EndIf

				nCol := nCol+nCol2
			Next
			//
		Next
		//
	EndIf
	//
	If(nLinha3 >= 1000, nLinha3 := nLinha3 - 1000, nLinha3 := 0) //Tratar a quebra das frases de perigo x frases de precaução
	
	oPrint:Say(nLinha2,100,"FRASES DE PRECAUÇÃO",oFont12n)
	
	If !Empty(aStr1)
		//
		aStr1 := ASort(aStr1,,,{|x,y| x[1] < y[1]})
		//
		oPrint:Say(nLinha2 := nLinha2+50,100,"Prevenção",oFont12n)
		//
		cString := ""
		//
		For i := 1 To Len(aStr1)
			cString += aStr1[i][1]+" - "+aStr1[i][2]
		Next
		// 
		nCol := 1
		//
		For j := 1 To Int(Len(cString)/130)+1
			nCol2 := Rat(" ", If(nLinha3 > 0, SubStr(cString, nCol, 130-29), SubStr(cString, nCol, 130)))

			If !Empty(nCol2)
				oPrint:Say(nLinha2 := nLinha2+50,100,If(nLinha3 > 0, SubStr(cString, nCol, nCol2), SubStr(cString, nCol, nCol2)),oFont12n)
				If(Int(Len(cString)/130)+2 == j, j--, j)
			EndIf

			nCol := nCol+nCol2
			If(nLinha3 > 0, nLinha3 := nLinha3-40, 0)
		Next
		//
	EndIf
	
	If !Empty(aStr2)
		//
		aStr2 := ASort(aStr2,,,{|x,y| x[1] < y[1]})
		//
		oPrint:Say(nLinha2 := nLinha2+50,100,"Resposta à emergência",oFont12n)
		//
		cString := ""
		//
		For i := 1 To Len(aStr2)
			cString += aStr2[i][1]+" - "+aStr2[i][2]
		Next
		// 
		nCol := 1
		//
		For j := 1 To Int(Len(cString)/140)+1
			nCol2 := Rat(" ", If(nLinha3 > 0, SubStr(cString, nCol, 140-50), SubStr(cString, nCol, 140)))

			If !Empty(nCol2)
				oPrint:Say(nLinha2 := nLinha2+50,100,If(nLinha3 > 0, SubStr(cString, nCol, nCol2), SubStr(cString, nCol, nCol2)),oFont12n)
				If(Int(Len(cString)/140)+1 == j, j--, j)
			EndIf

			nCol := nCol+nCol2
			If(nLinha3 > 0, nLinha3 := nLinha3-50, 0)
		Next
		//
	EndIf
	
	If !Empty(aStr3)
		//
		aStr3 := ASort(aStr3,,,{|x,y| x[1] < y[1]})
		//
		oPrint:Say(nLinha2 := nLinha2+50,100,"Armazenamento",oFont12n)
		//
		cString := ""
		//
		For i := 1 To Len(aStr3)
			cString += aStr3[i][1]+" - "+aStr3[i][2]
		Next
		// 
		nCol := 1
		//
		For j := 1 To Int(Len(cString)/140)+1
			nCol2 := Rat(" ", If(nLinha3 > 0, SubStr(cString, nCol, 140-50), SubStr(cString, nCol, 140)))

			If !Empty(nCol2)
				oPrint:Say(nLinha2 := nLinha2+50,100,If(nLinha3 > 0, SubStr(cString, nCol, nCol2), SubStr(cString, nCol, nCol2)),oFont12n)
				If(Int(Len(cString)/140)+1 == j, j--, j)
			EndIf

			nCol := nCol+nCol2
			If(nLinha3 > 0, nLinha3 := nLinha3-50, 0)
		Next
		//
	EndIf
	
	If !Empty(aStr4)
		//
		aStr4 := ASort(aStr4,,,{|x,y| x[1] < y[1]})
		//
		oPrint:Say(nLinha2 := nLinha2+50,100,"Disposição",oFont12n)
		//
		cString := ""
		//
		For i := 1 To Len(aStr4)
			cString += aStr4[i][1]+" - "+aStr4[i][2]
		Next
		//
		nCol := 1
		//
		For j := 1 To Int(Len(cString)/140)+1
			nCol2 := Rat(" ", If(nLinha3 > 0, SubStr(cString, nCol, 140-50), SubStr(cString, nCol, 140)))

			If !Empty(nCol2)
				oPrint:Say(nLinha2 := nLinha2+50,100,If(nLinha3 > 0, SubStr(cString, nCol, nCol2), SubStr(cString, nCol, nCol2)),oFont12n)
				If(Int(Len(cString)/140)+1 == j, j--, j)
			EndIf

			nCol := nCol+nCol2
			If(nLinha3 > 0, nLinha3 := nLinha3-50, 0)
		Next
		//
	EndIf
	//
	oPrint:EndPage()
	
	oPrint:End()
	//
	If _lUlt
		oPrint:Preview()
	EndIf
	//
Else
	MsgInfo("Este produto não contém ficha de informação cadastrada.")
EndIf

Return()
//
//
User Function EntFisp2()

Local lPri := .T.
Local lUlt := .F.

For nX := 1 To Len(aCols)
	//
	MV_PAR01 := 2
	MV_PAR02 := ""
	MV_PAR03 := GdFieldGet("D1_COD", nX)
	MV_PAR04 := GdFieldGet("D1_LOTECTL", nX)
	MV_PAR05 := GdFieldGet("D1_DTDIGIT", nX)
	MV_PAR06 := GdFieldGet("D1_DTVALID", nX)
	//
	If nX == Len(aCols)
		lUlt := .T.
	EndIf
	//
	U_ImpFisp2(MV_PAR01, MV_PAR02, MV_PAR03, MV_PAR04, MV_PAR05, MV_PAR06, "A", lPri, lUlt)
	//
	lPri := .F.
	//
Next

Return()
