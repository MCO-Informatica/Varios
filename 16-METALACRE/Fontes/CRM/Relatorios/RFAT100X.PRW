#include 'fivewin.ch'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "AP5MAIL.CH"
#include "topconn.ch"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"

#DEFINE VBOX      080
#DEFINE VSPACE    100
#DEFINE HSPACE    010
#DEFINE SAYVSPACE 008
#DEFINE SAYHSPACE 008
#DEFINE HMARGEM   100
#DEFINE HMARGEMT  040
#DEFINE VMARGEM   100
#DEFINE VMARGEMT  040
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFAT100   ºAutor  ³Mateus Hengle       º Data ³  17/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Alteracao do fonte de impressao de relatorio customizado   º±±
±±º          ³ do Orcamento                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MetaLacre - Protheus 11                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFAT100X()
Local cFilename := 'RelEst'
Local cQuery := ""

AjustaSX1("RFAT100")

Pergunte("RFAT100", !IsInCallStack("TMKA271") )

If IsInCallStack("TMKA271")
	MV_PAR01 := SUA->UA_NUM

	If Type("M->UA_DTLIM") <> "U"
		If SUA->UA_DTLIM <> M->UA_DTLIM
			RecLock("SUA",.F.)
			SUA->UA_DTLIM   := M->UA_DTLIM 
			MsUnlock()
		Endif
	Endif
Else
	SUA->(dbSetOrder(1), dbSeek(xFilial("SUA")+MV_PAR01))
Endif

lEmail := .f.
If msgyesno("Deseja Mandar o Orçamento por Email ?","Email Orçamento")
	lEmail := .t.
Endif
	
nRegSCJ:=SUA->(Recno())

MsAguarde({|| U_RFat1Pdf()},'Aguarde Gerando Orçamento em PDF...')

Return .t.

User Function RFAT1PDF()
Local aArea := GetArea()
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
Private nLinMax	:= 2280  // Número máximo de Linhas  A4 - 2250 // Oficio - 2800
Private nColMax	:= 3310  // Número máximo de Colunas A4 - 3310 // Oficio - 3955
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
Private cEmaFin		:= 'financeiro@metalacre.com.br'

Private cLogo:=GetSrvProfString("Startpath","")+"logo_metalacre.gif" //verificar 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definir as pictures                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCepPict:=PesqPict("SA1","A1_CEP")
cCGCPict:=PesqPict("SA1","A1_CGC")


cFilename := Criatrab(Nil,.F.)

SUB->(DbSetOrder(1))
If (SUB->(DbSeek(xFilial("SUB")+SUA->UA_NUM)))

	lAdjustToLegacy := .T.   //.F.
	lDisableSetup  := .T.
	oPrint := FWMSPrinter():New(cFilename, IMP_PDF, lAdjustToLegacy, , lDisableSetup)
//	oPrint:Setup()
	oPrint:SetResolution(78)
	oPrint:SetPortrait() // ou SetLandscape()
	oPrint:SetPaperSize(DMPAPER_A4) 
	oPrint:SetMargin(10,10,10,10) // nEsquerda, nSuperior, nDireita, nInferior 
	oPrint:cPathPDF := "C:\TEMP\" // Caso seja utilizada impressão em IMP_PDF 
	If lEmail
//		oPrint:linjob:=.T.
//		oPrint:lViewPdf:=.F.
	Endif
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
	nRecSUB	  := SUB->(Recno())
	
	nPagD:=1
	nNrItem:=0
	While SUB->(!Eof()) .And. SUB->UB_FILIAL = xFilial("SUB") .And. SUB->UB_NUM == SUA->UA_NUM
		nNritem+=1
	  	SUB->(dbSkip())
	Enddo         

	SUB->(dbGoTo(nRecSUB))
	nPagD := (nNRItem/6)
	nPagD := Iif(nPagD<1,1,Int(++nPagD))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria as variaveis para armazenar os valores do pedido        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOrdem   := 1
	nReem    := 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra Tipo de SCs Firmes ou Previstas                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
  
    ImpCabec()
  
	nTotal   := 0
	nTotMerc	:= 0
	nDescProd:= 0
    li       := 960        
    nTotDesc := SUA->UA_DESCONT
    cCliente := SUA->(UA_CLIENTE+UA_LOJA)

	//+-----------------------------------------------------------------------------------+
    //| MAFIS()  -> Função que calcula os impostos                                        |
    //+-----------------------------------------------------------------------------------+
    nDesconto:=SUA->UA_DESCONT
    nItem := 1
    nValIcmSt := 0
    DbSelectArea("SUB") 
    DbSetOrder(1)
    dbSeek(xFilial("SUB")+SUA->UA_NUM)

	MaFisSave()//Renato Ikeda - 03/02/2014 - inicializa função fiscal
	MaFisEnd() //Renato Ikeda - 03/02/2014 - inicializa função fiscal
	
	IF SUA->UA_CLIPROS == '1' 
   		MaFisIni(cCodCli,cLojCli,"C","N",cTipCli,MaFisRelImp("MTR700",{"SUA","SUB"}),,,"SB1","MTR700",,,)
	ElseIf SUA->UA_CLIPROS == '2' 
   		MaFisIni('','',"C","N",cTipCli,MaFisRelImp("MTR700",{"SUA","SUB"}),,,"SB1","MTR700",,,cCodCli+cLojCli,)
   	Endif

    While !Eof() .And. SUB->UB_FILIAL = xFilial("SUB") .And. SUB->UB_NUM == SUA->UA_NUM
			
	  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  //³ Verifica se havera salto de formulario                       ³
	  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	  If li > 2000
		  nOrdem++
		  ImpRodape()			// Imprime rodape do formulario e salta para a proxima folha
		  ImpCabec()
		  li  := 960
	  Endif
			
	  li:=li+60
			
      oPrint:Say( li, 0050, UPPER(SUB->UB_PRODUTO),oFont9,100 )
      
			MaFisAdd(SUB->UB_PRODUTO,;   	   // 1-Codigo do Produto ( Obrigatorio )
					SUB->UB_TES,;		       // 2-Codigo do TES ( Opcional )
					SUB->UB_QUANT,;		   // 3-Quantidade ( Obrigatorio )
					SUB->UB_VRUNIT,;	       // 4-Preco Unitario ( Obrigatorio )
					Iif(nDesconto>0,nDesconto/nNritem,0),;                // 5-Valor do Desconto ( Opcional )
					nil,;		               // 6-Numero da NF Original ( Devolucao/Benef )
					nil,;		               // 7-Serie da NF Original ( Devolucao/Benef )
					nil,;			       	   // 8-RecNo da NF Original no arq SD1/SD2
					SUA->UA_FRETE/nNritem,;	   // 9-Valor do Frete do Item ( Opcional )
					SUA->UA_DESPESA/nNritem,;  // 10-Valor da Despesa do item ( Opcional )
					0,;   // 11-Valor do Seguro do item ( Opcional )
					0,;						   // 12-Valor do Frete Autonomo ( Opcional )
					SUB->UB_VLRITEM+Iif(nDesconto>0,nDesconto/nNritem,0),;  // 13-Valor da Mercadoria ( Obrigatorio )
					0,;						   // 14-Valor da Embalagem ( Opcional )
					0,;		     			   // 15-RecNo do SB1
					0) 	           	           // 16-RecNo do SF4     

				//_nValIcm  := MaFisRet(1,"IT_VALICM" )
				//_nBaseIcm := MaFisRet(1,"IT_BASEICM")
				//_nValIpi  := MaFisRet(1,"IT_VALIPI" )
				//_nBaseIpi := MaFisRet(1,"IT_BASEICM")
				//_nValMerc := MaFisRet(1,"IT_VALMERC")
				//_nValSol  := MaFisRet(1,"IT_VALSOL" )
				//_nValDesc := MaFisRet(1,"IT_DESCONTO" )
				//_nPrVen   := MaFisRet(1,"IT_PRCUNI")

      nIPI        := MaFisRet(nItem,"IT_ALIQIPI")
      nICM        := MaFisRet(nItem,"IT_ALIQICM")
      nICMDIF     := Iif(GetEnvServer()$"VALIDACAO",20,0)

/*      If SUA->UA_CLIENTE=='011404'
	      nIPI        := 0
    	  nICM        := 0
      	  MaFisAlt("IT_ALIQIPI",0,nItem)
      	  MaFisAlt("IT_ALIQICM",0,nItem)
      Endif         */
      
      nValIcm     	:= MaFisRet(nItem,"IT_VALICM")	           
      nValIpi     	:= MaFisRet(nItem,"IT_VALIPI")
      nValDzf		:= MaFisRet(nItem,"IT_DESCZF")	      
      nTotIpi	  	:= MaFisRet(,'NF_VALIPI')
      nTotIcms		:= MaFisRet(,'NF_VALICM')        
      nTotDesp 		:= MaFisRet(,'NF_DESPESA')
      nTotFrete		:= MaFisRet(,'NF_FRETE')
      nTotDzf 		:= MaFisRet(,'NF_DESCZF')
      nTotalNF 		:= MaFisRet(,'NF_TOTAL')
      nTotDesc 		:= MaFisRet(,'NF_DESCONTO')
      nTotSeguro  	:= MaFisRet(,'NF_SEGURO')
      aValIVA     	:= MaFisRet(,"NF_VALIMP")
      nTotMerc    	:= MaFisRet(,"NF_TOTAL")
      nTotIcmSol  	:= MaFisRet(nItem,'NF_VALSOL')
      
	  ImpProd()

      oPrint:Box( li+30, 0050, li+30,2350)

	  dbSelectArea("SUB")
					
      SUB->(DbSkip())  
      nItem++
   EndDo 
   MaFisEnd()//Termino
		
	FinalPed()		// Imprime os dados complementares do PC

EndIf	

SUA->(dbGoTo(nRegSCJ))

oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir
cAnexo := 'C:\TEMP\'+cFilename+'.PDF'
EnvDrMail(cAnexo, MV_PAR01)
If lEmail
	EnvMail(cAnexo, MV_PAR01)
	FErase(cFilename)
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX1 ºAutor  ³Microsiga           º Data ³  12/16/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MetaLacre - Protheus 11                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static Function AjustaSX1(cPerg)

Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->( GetArea() )

PutSx1(	cPerg, "01", "Orçamento de Venda ? ", "" , "","Mv_ch1","C"                     ,TAMSX3("CJ_NUM")[1]  ,                       0 , 2,"G","",   "SCJ","","","Mv_par01","","","","","","","","","","","","","","","","",{"Informe o numero do orçamento para impressao",""},{""},{""},"")

RestArea( aAreaSX1 )
RestArea( aAreaAtu )

Return() 


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MyGetEnd  ³ Autor ³ Liber De Esteban             ³ Data ³ 19/03/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se o participante e do DF, ou se tem um tipo de endereco ³±±
±±³          ³ que nao se enquadra na regra padrao de preenchimento de endereco  ³±±
±±³          ³ por exemplo: Enderecos de Area Rural (essa verificção e feita     ³±±
±±³          ³ atraves do campo ENDNOT).                                         ³±±
±±³          ³ Caso seja do DF, ou ENDNOT = 'S', somente ira retornar o campo    ³±±
±±³          ³ Endereco (sem numero ou complemento). Caso contrario ira retornar ³±±
±±³          ³ o padrao do FisGetEnd                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Obs.     ³ Esta funcao so pode ser usada quando ha um posicionamento de      ³±±
±±³          ³ registro, pois será verificado o ENDNOT do registro corrente      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS                                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function MyGetEnd(cEndereco,cAlias)

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



Static Function EnvMail(cAnexo,cOrc)
Private cCorpo       := ''
Private mCorpo       := ''
Private cAssunto     := 'Orçamento de Lacres - ' + AllTrim(cRazao) + ' - No. ' + SUA->UA_NUM
Private nLineSize    := 60
Private nTabSize     := 3
Private lWrap        := .T. 
Private nLine        := 0
Private cTexto       := ""
Private lServErro	   := .T.
Private cServer  := Trim(GetMV("MV_RELSERV")) // smtp.tecnotron.ind.br
Private cDe 	:= Trim(GetMV("MV_RELACNT"))
Private cPass    := Trim(GetMV("MV_RELPSW"))  // 
Private lAutentic	:= GetMv("MV_RELAUTH",,.F.)
Private aTarget  :={cAnexo}
Private nTarget := 0
Private lCheck1 := .F.
Private lCheck2 := .f.
Private cPara      := PadR(SA1->A1_XMAIL,120)
Private cCC        := PadR(Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND,"A3_EMAIL"),120)
Private cBCC		:= SuperGetMV('MV_EMADIR', .F., 'luiz.carlis@metalacre.com.br;paulo.morsani@metalacre.com.br;marcelo.carlis@metalacre.com.br;lalberto@3lsystems.com.br') 

_cDe   := If(!Empty(UsrRetMail(RetCodUsr())),UsrRetMail(RetCodUsr()),'')

mCorpo := ''

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Interface                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 122,67 To 531,733 Dialog maildlg Title OemToAnsi("Envio de E-Mail ")
@ 2,4 To 78,324
@ 11,15 Say OemToAnsi("De :") Size 30,8
@ 23,15 Say OemToAnsi("Para :") Size 25,8
@ 35,15 Say OemToAnsi("CC :") Size 30,8
@ 47,15 Say OemToAnsi("Assunto :") Size 30,8
@ 59,15 Say OemToAnsi("Anexos :") Size 30,8
@ 10,40 Get cDe Size 270,10  When .F.
@ 22,40 Get cPara Size 270,10 Object oPara
@ 34,40 Get cCC Size 270,10   Object oCC
@ 46,40 Get cAssunto Size 270,10
@ 58,40 Get cAnexo  Size 270,10  When .f.    
@ 70,40 CHECKBOX "Receber Cópia " VAR lCheck1
//@ 70,200 CHECKBOX "Confirmação de Leitura" VAR lCheck2 

@ 093,004 ListBox nTarget Items aTarget Size 100,090 Object oTarget
@ 080,004 Button OemToAnsi("_Anexar...")      Size 36,12 Action FAbreArq()
@ 080,045 Button OemToAnsi("_Remover..")      Size 36,12 Action FRemovArq()

nOpc := 0
@ 80,110 To 182,324
@ 88,115 Get mCorpo MEMO Size 200,90
@ 187,236 Button OemToAnsi("_Sair") Size 36,16 Action (nOpc := 0, Close(maildlg))
@ 187,276 Button OemToAnsi("_Enviar") Size 36,16 Action (nOpc := 1,IIF(!Empty(cPara),Close(maildlg),MsgAlert("E-Mail sem destinatario !!")))
Activate Dialog maildlg centered

If nOpc==0
	Return .t.
Endif

cAnexos := ''//AllTrim(cAnexo)+';
For nI:=1 to Len(aTarget)
	If At(":",aTarget[nI])>0
		CPYT2S(aTarget[nI],GetSrvProfString("Startpath", "")+'emailanexos\',.T.)
		aTarget[nI] := GetSrvProfString("Startpath", "")+'emailanexos\'+SubStr(AllTrim(aTarget[nI]),RAT('\',AllTrim(aTarget[nI]))+1)  
	
	  	cAnexos+=GetSrvProfString("Startpath", "")+'emailanexos\'+SubStr(AllTrim(aTarget[nI]),RAT('\',AllTrim(aTarget[nI]))+1)+";"  
	Endif
Next
cAnexos:=Left(cAnexos,Len(cAnexos)-1)
lServERRO 	:= .F.
                    
CONNECT SMTP                         ;
SERVER 	 GetMV("MV_RELSERV"); 	// Nome do servidor de e-mail
ACCOUNT  GetMV("MV_RELACNT"); 	// Nome da conta a ser usada no e-mail
PASSWORD GetMV("MV_RELPSW") ; 	// Senha
Result lConectou    

lRet := .f.
lEnviado := .f.
If lAutentic
	lRet := Mailauth(cDe,cPass)
Endif
If lRet  
	If lCheck2
		ConfirmMailRead(.T.)
	Endif
	
	cPara   := Rtrim(cPara)+Iif(lCheck1,';'+_cDe,'')
	cCC		:= Rtrim(cCC)    
	cAssunto:= Rtrim(cAssunto)  
	
	cCorpo := '<html>'
	cCorpo += '<body>'
	cCorpo += '<p>'
	nLinhas := MlCount( mCorpo, 80 ) 	
	
	For nLin := 1 To nLinhas
		cCorpo += "<br>"+AllTRim(Memoline(mCorpo,80,nLin))
	Next
	cCorpo += '<br>'
	cCorpo += '<br>'
	cCorpo += '<br>'
	cCorpo += 'Em Anexo Orçamento de Lacres: ' + SUA->UA_NUM 
	cCorpo += '<br>'
	cCorpo += '<br>'
	cCorpo += 'No Aguardo de Sua Confirmação, ficamos a disposição.'
	cCorpo += '<br>'
	cCorpo += '<br>'
	cCorpo += 'Atenciosamente, '
	cCorpo += '<br>'
	cCorpo += '<br>'
	cCorpo += Capital(Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND,'A3_NOME'))
	cCorpo += '<br>'
	cCorpo += '<br>'
	cCorpo += SA3->A3_EMAIL
	cCorpo += '<br>'
	cCorpo += '<br>'
	cCorpo += 'Depto.Comercial'
	cCorpo += '<br>'
	cCorpo += 'METALACRE IND. COM. DE LACRES LTDA.'
	cCorpo += '<br>'
	cCorpo += 'Fone: 011 2884-3600'
	cCorpo += '<br>'
	cCorpo += 'Fone: 011 2884-3636'
	cCorpo += '<br>'
	cCorpo += 'E-Mail: vendas@metalacre.com.br'
	cCorpo += '<br>'
	cCorpo += 'Site: www.metalacre.com.br'
	cCorpo += '<br>'
	cCorpo += '</p>'
	cCorpo += '</body>'
	cCorpo += '</html>'

	SEND MAIL 	FROM cDe ;
		 		To cPara ;
	    	    CC cCc;
		 		SUBJECT	cAssunto ; 
		 		Body cCorpo;		
		 		ATTACHMENT cAnexos;
		 		RESULT lEnviado


	SEND MAIL 	FROM cDe ;
		 		To cBCC;
		 		SUBJECT	cAssunto ; 
		 		Body cCorpo;		
		 		ATTACHMENT cAnexos;
		 		RESULT lEnviado

	If lCheck2
		ConfirmMailRead(.F.)
	Endif
	DISCONNECT SMTP SERVER
Endif
If !(lConectou .AND. lEnviado)
	cMensagem := ""
	GET MAIL ERROR cMensagem 
Endif          
FERASE(cAnexo)
For nI:=1 to Len(aTarget)
	FERASE(aTarget[nI])
Next
Return                      


*--------------------------*
Static Function FAbreArq()
*--------------------------*
cFOpen := cGetFile("Todos os Arquivos|*.*|Arquivos DOC|*.DOC|Arquivos PDF|*.PDF|Arquivos XLS|*.XLS",OemToAnsi("Abrir Arquivo..."),,,,,.f.)
If !Empty(cFOpen)
    aAdd(aTarget,cFOpen)
    ObjectMethod(oTarget,"SetItems(aTarget)")
Endif

Return (cFoPen)

*--------------------------*
Static Function FRemovArq()
*--------------------------*
If nTarget != 0
      nNewTam := Len(aTarget) - 1
      aTarget := aSize(aDel(aTarget,nTarget), nNewTam)
      ObjectMethod(oTarget,"SetItems(aTarget)")
Endif
Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Altair Teixeira       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o Cabecalho do Pedido de Compra                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpCabec(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpCabec()
Local nOrden, cCGC
LOCAL cMoeda
Local cComprador:=""
LOcal cAlter	:=""
Local cAprova	:=""
Local cCompr	:=""
Local cDe       :=""
Local _aDados   :={}   // Array de 2 dimensões.

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
oPrint:Box( 0020, 0040, 0410,2350)
//oPrint:Box( 0250, 1800, 0410,2350)
oPrint:Box( 0410, 0040, 0900,2350)
oPrint:Box( 0900, 0040, 2390,2350)


IF SUA->UA_CLIPROS == '1'

	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA))
	
	SU5->(dbSetOrder(1), dbSeek(xFilial("SU5")+SUA->UA_CODCONT))

	cCodCli	:= SA1->A1_COD
	cLojCli := SA1->A1_LOJA
	cTipCli := SA1->A1_TIPO
	cRazao:= SA1->A1_NOME
	cEnd:= SA1->A1_END
	cBairro:= SA1->A1_BAIRRO
	cCidade:= SA1->A1_MUN
	cContato:= Alltrim(SUA->UA_DESCNT)
	cTel	:= "(DDD):" + Alltrim(SA1->A1_DDD)+ " / " + Alltrim(SA1->A1_TEL) // verificar
	cFax	:= "(DDD):" + Alltrim(SA1->A1_DDD)+ " / " + Alltrim(SA1->A1_FAX) // verificar
	cCNPJ:= SA1->A1_CGC
	cIE:=SA1->A1_INSCR
	cNr:= IIF(MyGetEnd(SA1->A1_END,"SA1")[2]<>0,Str(MyGetEnd(SA1->A1_END,"SA1")[2]),"SN")
	cEstado:= SA1->A1_EST
	cCep:= SA1->A1_CEP     
	cEmail	:= Iif(Empty(SU5->U5_EMAIL),SA1->A1_EMAIL,SU5->U5_EMAIL)

ElseIf SUA->UA_CLIPROS == '2' 

	SUS->(DbSetOrder(1))
	SUS->(DbSeek(xFilial("SUS")+SUA->UA_CLIENTE+SUA->UA_LOJA))  
	
	SU5->(dbSetOrder(1), dbSeek(xFilial("SU5")+SUA->UA_CODCONT))
	
	cCodCli	:= SUS->US_COD
	cLojCli := SUS->US_LOJA
	cTipCli := SUS->US_TIPO
	cRazao:= SUS->US_NOME
	cEnd:= SUS->US_END
	cBairro:= SUS->US_BAIRRO
	cCidade:= SUS->US_MUN
	cContato:= Alltrim(SUA->UA_DESCNT)
	cTel	:= "(DDD):" + Alltrim(SUS->US_DDD)+ " / " + Alltrim(SUS->US_TEL) // verificar
	cFax	:= "(DDD):" + Alltrim(SUS->US_DDD)+ " / " + Alltrim(SUS->US_FAX) // verificar
	cCNPJ:= SUS->US_CGC
	cIE:=SUS->US_INSCR
	cNr:= IIF(MyGetEnd(SUS->US_END,"SUS")[2]<>0,Str(MyGetEnd(SUS->US_END,"SUS")[2]),"SN")
	cEstado:= SUS->US_EST
	cCep:= SUS->US_CEP
    cEmail	:= Iif(Empty(SU5->U5_EMAIL),SUS->US_EMAIL,SU5->U5_EMAIL)
ENDIF

If !Empty(SUA->UA_CLIMTS)
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+SUA->UA_CLIMTS+SUA->UA_LOJMTS))
	
	SU5->(dbSetOrder(1), dbSeek(xFilial("SU5")+SUA->UA_CODCONT))

	cCodCli	:= SA1->A1_COD
	cLojCli := SA1->A1_LOJA
	cTipCli := SA1->A1_TIPO
	cRazao:= SA1->A1_NOME
	cEnd:= SA1->A1_END
	cBairro:= SA1->A1_BAIRRO
	cCidade:= SA1->A1_MUN
	cContato:= Alltrim(SUA->UA_DESCNT)
	cTel	:= "(DDD):" + Alltrim(SA1->A1_DDD)+ " / " + Alltrim(SA1->A1_TEL) // verificar
	cFax	:= "(DDD):" + Alltrim(SA1->A1_DDD)+ " / " + Alltrim(SA1->A1_FAX) // verificar
	cCNPJ:= SA1->A1_CGC
	cIE:=SA1->A1_INSCR
	cNr:= IIF(MyGetEnd(SA1->A1_END,"SA1")[2]<>0,Str(MyGetEnd(SA1->A1_END,"SA1")[2]),"SN")
	cEstado:= SA1->A1_EST
	cCep:= SA1->A1_CEP     
	cEmail	:= Iif(Empty(SU5->U5_EMAIL),SA1->A1_EMAIL,SU5->U5_EMAIL)
Endif

// Dados do Cliente

oPrint:Say( 0440, 0060, "No. Orçamento:",oFont3c,100 )
oPrint:Say( 0440, 1500, "Emissao:",oFont3c,100 )

oPrint:Say( 0280, 1850, "Página(s):",oFont3c,100 )
oPrint:Say( 0330, 1850, "Data Impressão:",oFont3c,100 )
oPrint:Say( 0380, 1850, "Hora Impressão:",oFont3c,100 )

oPrint:Say( 0280, 2100, StrZero(++nPag,3)+" de "+StrZero(nPagD,3), oFont3,100 )
oPrint:Say( 0330, 2100, DtoC(Date()), oFont3,100 )
oPrint:Say( 0380, 2100, Time(), oFont3,100 )

oPrint:Say( 0480, 0060, "Cliente:",oFont3c,100 )
oPrint:Say( 0480, 1400, "Validade Prop: ",oFont3c,100 )
oPrint:Say( 0520, 0060, "Endereço:",oFont3c,100 )
oPrint:Say( 0560, 0060, "Cidade/UF:",oFont3c,100 )
oPrint:Say( 0560, 1400, "CEP:",oFont3c,100 )
oPrint:Say( 0600, 0060, "CNPJ:",oFont3c,100 )
oPrint:Say( 0600, 1400, "Insc.Est.:",oFont3c,100 )
oPrint:Say( 0640, 0060, "Fone:",oFont3c,100 )
oPrint:Say( 0640, 1400, "Fax:",oFont3c,100 )
oPrint:Say( 0680, 0060, "Contato:",oFont3c,100 )
//oPrint:Say( 0680, 1000, "PEDIDO CLIENTE: ",oFont5,100 )
oPrint:Say( 0680, 1400, "Email:",oFont3c,100 )

oPrint:Say( 0440, 0320, SUA->UA_NUM,oFont3,100 )
oPrint:Say( 0440, 1700, DtoC(SUA->UA_EMISSAO),oFont3,100 )
oPrint:Say( 0480, 0320, SUA->UA_CLIENTE+'/'+SUA->UA_LOJA + ' - ' +cRazao,oFont3,100 )
oPrint:Say (0480, 1700, DTOC(SUA->UA_DTLIM),oFont3,100 )
oPrint:Say( 0520, 0320, AllTrim(cEnd)+" - "+cBairro,oFont3,100 )
oPrint:Say( 0560, 0320, AllTrim(cCidade)+"-"+cEstado,oFont3,100 )
oPrint:Say( 0560, 1700, TransForm(cCep,"@R 99999-999") ,oFont3,100 )
oPrint:Say( 0600, 0320, TransForm(AllTrim(cCNPJ),cCGCPict),oFont3,100 )
oPrint:Say( 0600, 1700, cIE,oFont3,100 )

oPrint:Say( 0640, 0320, cTel,oFont3,100 )
oPrint:Say( 0640, 1700, cFax,oFont3,100 )
oPrint:Say( 0680, 0320, cContato, oFont3,100 )
oPrint:Say( 0680, 1700, cEmail, oFont3,100 )

oPrint:Box( 0730, 0040, 0730,2350)

oPrint:Say( 0760, 0060, "Forma Pagto:",oFont3c,100 )
oPrint:Say( 0760, 1200, "Moeda :",oFont3c,100 ) 
oPrint:Say( 0800, 0060, "Representante:",oFont3c,100 )
oPrint:Say( 0840, 0060, "Transportadora:",oFont3c,100 )
oPrint:Say( 0840, 1200, "Tipo Frete:",oFont3c,100 )
oPrint:Say( 0880, 0060, "Numeração Lacre:",oFont3c,100 )
oPrint:Say( 0880, 1200, "PRAZO FABRICAÇÃO:",oFont3c,100 )

oPrint:Say( 0760, 1350, "R$-Real",oFont3,100 ) 

oPrint:Say( 0760, 0320, SUA->UA_CONDPG + ' - ' + Posicione("SE4",1,xFilial("SE4")+SUA->UA_CONDPG,"E4_DESCRI"),oFont3,100 )
oPrint:Say( 0840, 0320, SUA->UA_TRANSP + ' - ' + Posicione("SA4",1,xFilial("SA4")+SUA->UA_TRANSP,"A4_NOME"),oFont3,100 )
oPrint:Say( 0840, 1450, IIF(SUA->UA_TPFRETE=="F","Por Conta do Destinatário","Por conta do Remetente"),oFont3,100 )
oPrint:Say( 0880, 0320,"SEQUENCIAL",oFont3,100 )
oPrint:Say( 0880, 1550,cValToChar(SUA->UA_XPRAZO)+" DIAS ÚTEIS APÓS CONFIRMACAO DO PEDIDO",oFont3,100 )


oPrint:Say( 0020, 0060, "ORÇAMENTO DE VENDA",oFont1,100 )


cEmail	:= Iif(!Empty(SA3->A3_EMAIL),SA3->A3_EMAIL,'vendas@metalacre.com.br')
cVendedor	:= ''

nRegSM0 := SM0->(Recno())

If !Empty(SUA->UA_CLIMTS)
	If SUA->UA_CLIENTE=='001320'	// MetalSeal
		SM0->(dbSeek('02'))
		//Cabecalho Produto do Pedido
		
//		cBitmap      := FisxLogo("1")
//		oPrint:SayBitmap( 0050,1800,"logotipopng.bmp",0500,0180 )

	ElseIf SUA->UA_CLIENTE=='011404'	// MPM
		SM0->(dbSeek('04'))

		//Cabecalho Produto do Pedido
		
		cBitmap      := FisxLogo("1")
		oPrint:SayBitmap( 0050,1800,"LOGOTIPOMPM.bmp",0500,0180 )

		cEmail		:= 'vendas@mpmdistribuicao.com.br '
		cEmaFin		:= 'admin@mpmdistribuicao.com.br'
		cVendedor	:= 'Pâmella Sobral'
	Endif
	// Dados da Empresa/Filial
	
	if (SM0->M0_ESTCOB == "SP")
	   	inscEst           := Alltrim(Transform(SM0->M0_INSC,"@R 999.999.999.999"))
	elseif (SM0->M0_ESTCOB == "RJ")
	   	inscEst           := Alltrim(Transform(SM0->M0_INSC,"@R 99.999999"))
	Else                                                                    
		inscEst           := Alltrim(Transform(SM0->M0_INSC,"@R 99.999999"))	
	endif

	oPrint:Say( 0130, 0060, SM0->M0_NOMECOM,oFont7,100 )
	oPrint:Say( 0180, 0060, AllTrim(SM0->M0_ENDCOB)+" - "+AllTrim(SM0->M0_BAIRCOB),oFont8,100 )
	oPrint:Say( 0230, 0060, AllTrim(SM0->M0_CIDCOB)+" - "+ SM0->M0_ESTCOB+" "+"CEP: " + Transform(SM0->M0_CEPCOB,'@R 99999-999'), oFont8,100 )
	oPrint:Say( 0280, 0060, "CNPJ: "+TransForm(AllTrim(SM0->M0_CGC),cCGCPict)+ " INSCR.EST.: " + inscEst ,oFont8,100 )
	oPrint:Say( 0330, 0060, "FONE: "+AllTrim(SM0->M0_TEL) + " | " + AllTrim(SM0->M0_FAX) + " | " + AllTrim(SM0->M0_TEL_PO) + " Email: " + cEmail,oFont8,100 )
Else
	//Cabecalho Produto do Pedido
	
	cBitmap      := FisxLogo("1")
	oPrint:SayBitmap( 0050,1800,"logotipopng.bmp",0500,0180 )

	// Dados da Empresa/Filial
	
	if (SM0->M0_ESTCOB == "SP")
	   	inscEst           := Alltrim(Transform(SM0->M0_INSC,"@R 999.999.999.999"))
	elseif (SM0->M0_ESTCOB == "RJ")
	   	inscEst           := Alltrim(Transform(SM0->M0_INSC,"@R 99.999999"))
	Else                                                                    
		inscEst           := Alltrim(Transform(SM0->M0_INSC,"@R 99.999999"))	
	endif
	oPrint:Say( 0130, 0060, SM0->M0_NOMECOM,oFont7,100 )
	oPrint:Say( 0180, 0060, AllTrim(SM0->M0_ENDCOB)+" - "+AllTrim(SM0->M0_BAIRCOB),oFont8,100 )
	oPrint:Say( 0230, 0060, AllTrim(SM0->M0_CIDCOB)+" - "+ SM0->M0_ESTCOB+" "+"CEP: " + Transform(SM0->M0_CEPCOB,'@R 99999-999'), oFont8,100 )
	oPrint:Say( 0280, 0060, "CNPJ: "+TransForm(AllTrim(SM0->M0_CGC),cCGCPict)+ " INSCR.EST.: " + inscEst ,oFont8,100 )
	oPrint:Say( 0330, 0060, "FONE: "+AllTrim(SM0->M0_TEL) + " | " + AllTrim(SM0->M0_FAX) + " | " + AllTrim(SM0->M0_TEL_PO) + " Email: " + cEmail,oFont8,100 )
Endif
SM0->(dbGoTo(nRegSM0))


oPrint:Say( 0800, 0320, Iif(Empty(cVendedor),SUA->UA_VEND + ' - ' + Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND,"A3_NOME"),cVendedor),oFont3,100 )

oPrint:FillRect({0903,0043,0949,2348},oBrush)
oBrush:End()

oPrint:Say( 0935, 0050, "Código" ,oFont3,100 )
oPrint:Say( 0935, 0250, "Material" ,oFont3,100 )
//oPrint:Say( 0935, 0950, "Personal." ,oFont3,100 )
//oPrint:Say( 0935, 1200, "Comp" ,oFont3,100 )
//oPrint:Say( 0935, 1320, "Aplicação" ,oFont3,100 )
oPrint:Say( 0935, 1500, "Quant."  ,oFont3,100 )
oPrint:Say( 0935, 1650, "Vlr.Unitário" ,oFont3,100 )
oPrint:Say( 0935, 1850, "%IPI" ,oFont3,100 )
oPrint:Say( 0935, 1950, "%ICM" ,oFont3,100 )
oPrint:Say( 0935, 2040, "%ICDIF" ,oFont3,100 )
oPrint:Say( 0935, 2170, "Valor Total" ,oFont3,100 )

oPrint:Box( 0950, 0040, 0950,2350)
oPrint:Box( 0955, 0040, 0955,2350)


Return .T.


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpProd  ³ Autor ³ Altair Teixeira       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pesquisar e imprimir  dados Cadastrais do Produto.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpProd(Void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpProd()
LOCAL cDesc, nLinRef := 1, nBegin := 0, cDescri := "", nLinha:=0,;
		nTamDesc := 50 , aColuna := Array(8)   
Local cCompriX := SUB->UB_OPC
Local cCompri  := SUBSTR(cCompriX, 4, 4)
	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao generica do Produto.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial()+SUB->UB_PRODUTO)

oPrint:Say( li, 0250, Iif(!Empty(SUB->UB_XDESCR),SUB->UB_XDESCR,SB1->B1_DESC),oFont9,100 )
oPrint:Say( li, 1440, Transform(SUB->UB_QUANT,'@E 9999999,999') ,oFont10c,100 )
oPrint:Say( li, 1630, Transform(SUB->UB_VRUNIT,'@E 999,999.99') ,oFont10c,100 )
oPrint:Say( li, 1850, Transform(nIPI,'@E 99.9') ,oFont10c,100 )
oPrint:Say( li, 1950, Transform(nICM,'@E 99.9') ,oFont10c,100 )
oPrint:Say( li, 2050, Transform(nICMDIF,'@E 99.9') ,oFont10c,100 )
oPrint:Say( li, 2110, Transform(SUB->UB_VLRITEM,'@E 9,999,999.99') ,oFont10c,100 )


cPerso := POSICIONE("Z00",1,xFilial("Z00")+SUB->UB_XLACRE,"Z00->Z00_DESC")
li+=40
oPrint:Say( li, 0270, 'Personalização:',oFont8,100 )
If !Empty(cPerso)
	oPrint:Say( li, 0500, cPerso,oFont9,100 )
Else
	oPrint:Say( li, 0500, '** Favor Informar **',oFont9,100 )
Endif
If !Empty(cCompri)
	li+=40
	oPrint:Say( li, 0270, 'Comprimento:',oFont8,100 )
	oPrint:Say( li, 0500, AllTrim(cCompri)+Iif(!Empty(cCompri)," M",''),oFont9,100 )
Endif
If !Empty(SUB->UB_XAPLICA)
	li+=40
	oPrint:Say( li, 0270, 'Aplicação:',oFont8,100 )
	oPrint:Say( li, 0500, SUB->UB_XAPLICA,oFont9,100 )
Endif

// Observacao do ITEM

If !Empty(SUB->UB_OBSITEM)  
	li+=40
	oPrint:Say( li, 0270,'Obs Item:',oFont8,100 )
	oPrint:Say( li, 0500,Substr(SUB->UB_OBSITEM,1,60),oFont9,100 )
	If !Empty(Substr(SUB->UB_OBSITEM,61,60))
		li+=40
		oPrint:Say( li, 0500,Substr(SUB->UB_OBSITEM,61,60),oFont9,100 )
	Endif
Endif
nTotal  :=nTotal+SUB->UB_VLRITEM

Return .T.  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpRodape³ Autor ³ Altair Teixeira       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o rodape do formulario e salta para a proxima folha³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpRodape(Void)   			         					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 					                     				      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpRodape()

oPrint:Say( 2350, 0090, "CONTINUA ..." ,oFont3,100 )

Return .T. 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FinalPed ³ Autor ³ Altair Teixeira       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime os dados complementares do Pedido de Compra        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FinalPed(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FinalPed()

Local nk 		:= 1,nG
Local nQuebra	:= 0
Local lNewAlc	:= .F.
Local lLiber 	:= .F.
Local lImpLeg	:= .T.
Local cComprador:=""
LOcal cAlter	:=""
Local cAprova	:=""
Local cCompr	:=""
Local aColuna   := Array(8), nTotLinhas 
Local _cTexto := " "
//Rodape
//oPrint:Box( 1380, 0010, 1460,2550)
//oPrint:Box( 1380, 2550, 1460,3375)


oPrint:Say( 2100, 0060, 'Condições Gerais de Fornecimento:',oFont9,100 )
oPrint:Say( 2130, 0060, "1. Confirmação do pedido: Pedidos verbais não serão aceitos. O pedido somente será confirmado por formulário próprio do cliente ou através da retransmissão do orçamento enviado com a aprovação do responsável pela compra;",oFont6,100 )
oPrint:Say( 2160, 0060, "2. Cadastro: Endereços de entrega, faturamento;  cobrança  e e-mail para envio do arquivo XML da Nota Fiscal Eletrônica, devem ser informados corretamente. Não nos responsabilizaremos por produtos enviados ao endereço errado, ",oFont6,100 )
oPrint:Say( 2190, 0060, "   caso o mesmo não tenha sido informado corretamente pelo cliente na ordem de compra/pedido;",oFont6,100 )
oPrint:Say( 2220, 0060, "3. Para condição de pagamento antecipado, feitos via depósito em conta: mandar comprovante via  e-mail, junto com o pedido;. ",oFont6,100 )
oPrint:Say( 2250, 0060, "4. Pagamentos via boleto bancário: Informamos que este é enviado pelo correio no prazo de até 07 dias úteis, a contar da data de emissão da NF(e). Caso não ocorra o recebimento no prazo estabelecido, contatar o Depto Financeiro",oFont6,100 )
oPrint:Say( 2280, 0060, "   da empresa, para solicitar o envio da segunda via do  boleto através do e-mail: "+cEmaFin+";",oFont6,100 )
oPrint:Say( 2310, 0060, "5. Personalização: Em caso de personalização de logotipo, enviar arquivo em formato jpeg ou em Coreldraw.",oFont6,100 )

oPrint:Box( 2390, 0040, 3000,2350)   

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Acessar o Endereco para Entrega do Arquivo de Empresa SM0.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cAlias := Alias()

oPrint:FillRect({2393,0043,2549,2348},oBrush)
oBrush:End()

oPrint:Say( 2420, 0060, "Descontos:" ,oFont3,100 )
oPrint:Say( 2420, 0320, Transform(nTotDesc+nTotDzf,tm(nTotDesc,14,MsDecimais(1))) ,oFont4c,100 )
oPrint:Say( 2420, 0800, "ICMS :" ,oFont3,100 )
oPrint:Say( 2420, 1100, Transform(nTotIcms,tm(nTotIcms,14,MsDecimais(1))) ,oFont4c,100 )
oPrint:Say( 2420, 1750, "Total Mercadoria: " ,oFont3,100 )
oPrint:Say( 2420, 2070, Transform(nTotal,tm(nTotal,14,MsDecimais(1))) ,oFont4c,100 )

oPrint:Say( 2460, 0060, "Frete :" ,oFont3,100 )
oPrint:Say( 2460, 0320, Transform(nTotFrete,tm(nTotFrete,14,MsDecimais(1))) ,oFont4c,100 )
oPrint:Say( 2460, 0800, "IPI :" ,oFont3,100 )
oPrint:Say( 2460, 1100, Transform(nTotIPI,tm(nTotIpi,14,MsDecimais(2))) ,oFont4c,100 )
oPrint:Say( 2460, 1750, "ICMS Solid.:" ,oFont3,100 )
oPrint:Say( 2460, 2070, Transform(nTotIcmSol,tm(nTotIcmSol,14,MsDecimais(1))) ,oFont4c,100 )

oPrint:Say( 2500, 0060, "Seguro :" ,oFont3,100 )
oPrint:Say( 2500, 0320, Transform(nTotSeguro,tm(nTotSeguro,14,MsDecimais(1))) ,oFont4c,100 )
oPrint:Say( 2500, 0800, "Despesas :" ,oFont3,100 )
oPrint:Say( 2500, 1100, Transform(nTotDesp,tm(nTotDesp,14,MsDecimais(1))) ,oFont4c,100 )

oPrint:Say( 2500, 1750, "Valor Total: ",oFont9,100 )
oPrint:Say( 2500, 2045, Transform((nTotal+nTotFrete+nTotIPI+nTotIcmSol+nTotSeguro+nTotDesp-(nTotDesc+nTotDzf)),tm((nTotal+nTotFrete+nTotIPI+nTotIcmSol+nTotSeguro+nTotDesp-(nTotDesc+nTotDzf)),14,MsDecimais(1))),oFont9c,100 )

oPrint:Box( 2550, 0040, 2550,2350)   
oPrint:Box( 2640, 0040, 2640,2350)   

oPrint:Say( 2660, 0070, "Observações: ",oFont3,100 )
aLinha := Tk3AMemo(SUA->UA_CODOBS, 100)

// Caso Condicao de pagamento seja antecipada então adiciona mensagem padrão na nota fiscal.
					
If SE4->(dbSetOrder(1), dbSeek(xFilial("SE4")+SUA->UA_CONDPG)) .And. SE4->E4_CTRADT == '1'
	AAdd(aLinha, AllTrim(FORMULA(AllTrim(GetNewPar("MV_FRMBCO",'002')))) )
Endif

li:=2680
For nBegin := 1 To Len(aLinha)
	li+=40              
	oPrint:Say( li, 0080, aLinha[nBegin] ,oFont5,100 )
Next nBegin 

/*oPrint:Box( 2800, 0040, 3000,0450)                  
oPrint:Box( 2800, 0450, 3000,0950)                  
oPrint:Box( 2800, 0950, 3000,1450)                  
oPrint:Box( 2800, 1450, 3000,1950)                  
oPrint:Box( 2800, 1950, 3000,2350)                  
  */
//oPrint:Say( 2820, 0200, "Peso:",oFont3,100 )
//oPrint:Say( 2820, 0600, "Volumes:",oFont3,100 )
//oPrint:Say( 2820, 1130, "Visto Vendas:",oFont3,100 )
//oPrint:Say( 2820, 1600, "Visto Expedição:",oFont3,100 )
//oPrint:Say( 2820, 2000, "Visto Dp Crédito:",oFont3,100 )

Return .T.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Tk3AMemo  ºAutor  ³Armando M. Tessaroliº Data ³  25/03/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta o texto conforme foi digitado pelo operador e quebra  º±±
±±º          ³as linhas no tamanho especificado sem cortar palavras e     º±±
±±º          ³devolve um array com os textos a serem impressos.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Call Center                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Tk3AMemo(cCodigo,nTam)

Local cString	:= ''//MSMM(cCodigo,nTam)		// Carrega o memo da base de dados
Local nI		:= 0    					// Contador dos caracteres	
Local nL		:= 0						// Contador das linhas 
Local cLinha	:= ""						// Guarda a linha editada no campo memo
Local aLinhas	:= {}						// Array com o memo dividido em linhas

cString := AllTrim(cString)+' '+AllTrim(SUA->UA_OBSORC)

For nI := 1 TO Len(cString)
	If (nL < nTam) //(Ascii(SubStr(cString,nI,1)) <> 13) .AND. 
		// Enquanto não houve enter na digitacao e a linha nao atingiu o tamanho maximo
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

// Se o nL > 0, eh porque o usuario nao deu enter no fim do memo e eu adiciono a linha no array.
If nL >= 0
	cLinha := SubStr(cLinha,1,nL)
	AAdd(aLinhas, cLinha)
	cLinha := ""
	nL := 0
Endif	

Return(aLinhas)



Static Function EnvDRMail(cAnexo,cOrc)
Private cCorpo       := ''
Private mCorpo       := ''
Private cAssunto     := 'Orçamento de Lacres - ' + AllTrim(cRazao) + ' - No. ' + SUA->UA_NUM
Private nLineSize    := 60
Private nTabSize     := 3
Private lWrap        := .T. 
Private nLine        := 0
Private cTexto       := ""
Private lServErro	   := .T.
Private cServer  := Trim(GetMV("MV_RELSERV")) // smtp.tecnotron.ind.br
Private cDe 	:= Trim(GetMV("MV_RELACNT"))
Private cPass    := Trim(GetMV("MV_RELPSW"))  // 
Private lAutentic	:= GetMv("MV_RELAUTH",,.F.)
Private aTarget  :={cAnexo}
Private nTarget := 0
Private lCheck1 := .F.
Private lCheck2 := .f.
Private cPara      := PadR(SA1->A1_XMAIL,120)
Private cCC        := PadR(Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND,"A3_EMAIL"),120)
Private cBCC		:= SuperGetMV('MV_EMADIR', .F., 'luiz.carlis@metalacre.com.br;paulo.morsani@metalacre.com.br;marcelo.carlis@metalacre.com.br') 

_cDe   := If(!Empty(UsrRetMail(RetCodUsr())),UsrRetMail(RetCodUsr()),'')

mCorpo := ''


cAnexos := ''//AllTrim(cAnexo)+';
For nI:=1 to Len(aTarget)
	If At(":",aTarget[nI])>0
		CPYT2S(aTarget[nI],GetSrvProfString("Startpath", "")+'emailanexos\',.T.)
		aTarget[nI] := GetSrvProfString("Startpath", "")+'emailanexos\'+SubStr(AllTrim(aTarget[nI]),RAT('\',AllTrim(aTarget[nI]))+1)  
	
	  	cAnexos+=GetSrvProfString("Startpath", "")+'emailanexos\'+SubStr(AllTrim(aTarget[nI]),RAT('\',AllTrim(aTarget[nI]))+1)+";"  
	Endif
Next
cAnexos:=Left(cAnexos,Len(cAnexos)-1)
lServERRO 	:= .F.
                    
CONNECT SMTP                         ;
SERVER 	 GetMV("MV_RELSERV"); 	// Nome do servidor de e-mail
ACCOUNT  GetMV("MV_RELACNT"); 	// Nome da conta a ser usada no e-mail
PASSWORD GetMV("MV_RELPSW") ; 	// Senha
Result lConectou    

lRet := .f.
lEnviado := .f.
If lAutentic
	lRet := Mailauth(cDe,cPass)
Endif
If lRet  
	If lCheck2
		ConfirmMailRead(.T.)
	Endif
	
	cPara   := Rtrim(cPara)+Iif(lCheck1,';'+_cDe,'')
	cCC		:= Rtrim(cCC)    
	cAssunto:= Rtrim(cAssunto)  
	
	cCorpo := '<html>'
	cCorpo += '<body>'
	cCorpo += '<p>'
	nLinhas := MlCount( mCorpo, 80 ) 	
	
	For nLin := 1 To nLinhas
		cCorpo += "<br>"+AllTRim(Memoline(mCorpo,80,nLin))
	Next
	cCorpo += '<br>'
	cCorpo += '<br>'
	cCorpo += '<br>'
	cCorpo += 'Em Anexo Orçamento de Lacres: ' + SUA->UA_NUM 
	cCorpo += '<br>'
	cCorpo += '<br>'
	cCorpo += 'No Aguardo de Sua Confirmação, ficamos a disposição.'
	cCorpo += '<br>'
	cCorpo += '<br>'
	cCorpo += 'Atenciosamente, '
	cCorpo += '<br>'
	cCorpo += '<br>'
	cCorpo += Capital(Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND,'A3_NOME'))
	cCorpo += '<br>'
	cCorpo += '<br>'
	cCorpo += SA3->A3_EMAIL
	cCorpo += '<br>'
	cCorpo += '<br>'
	cCorpo += 'Depto.Comercial'
	cCorpo += '<br>'
	cCorpo += 'METALACRE IND. COM. DE LACRES LTDA.'
	cCorpo += '<br>'
	cCorpo += 'Fone: 011 2884-3600'
	cCorpo += '<br>'
	cCorpo += 'Fone: 011 2884-3636'
	cCorpo += '<br>'
	cCorpo += 'E-Mail: vendas@metalacre.com.br'
	cCorpo += '<br>'
	cCorpo += 'Site: www.metalacre.com.br'
	cCorpo += '<br>'
	cCorpo += '</p>'
	cCorpo += '</body>'
	cCorpo += '</html>'

	SEND MAIL 	FROM cDe ;
		 		To cBCC;
		 		SUBJECT	cAssunto ; 
		 		Body cCorpo;		
		 		ATTACHMENT cAnexos;
		 		RESULT lEnviado

	If lCheck2
		ConfirmMailRead(.F.)
	Endif
	DISCONNECT SMTP SERVER
Endif
If !(lConectou .AND. lEnviado)
	cMensagem := ""
	GET MAIL ERROR cMensagem 
Endif          
/*FERASE(cAnexo)
For nI:=1 to Len(aTarget)
	FERASE(aTarget[nI])
Next */
Return                      
