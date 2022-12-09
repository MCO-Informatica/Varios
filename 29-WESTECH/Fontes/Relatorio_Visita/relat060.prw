#INCLUDE "FONT.CH"
#INCLUDE "TOTVS.CH"

User Function relat060()

Local oDlg       := NIL
Local cString	  := "SZ8"

Private titulo  	:= ""
Private nLastKey 	:= 0
Private cPerg	  	:= "relat060"
Private nomeProg 	:= FunName()



Private cCodRVA 	:= SZ8->Z8_IDRVA

SZ8->( dbSetOrder(1) )
SZ8->( dbSeek( xFilial("SZ8")+cCodRVA ) )

/*
AjustaSx1()
If ! Pergunte(cPerg,.T.)
	Return
Endif
*/

wnrel := FunName()            //Nome Default do relatorio em Disco

Private cTitulo  := "Impressão do Relatório de Visita"
Private oPrn     := NIL
Private oFont1   := NIL
Private oFont2   := NIL
Private oFont3   := NIL
Private oFont4   := NIL
Private oFont5   := NIL
Private oFont6   := NIL
Private nLin     := 1650 // Linha de inicio da impressao das clausulas contratuais

DEFINE FONT oFont1 NAME "Arial" SIZE 0,20 BOLD   Of oPrn
DEFINE FONT oFont2 NAME "Arial" SIZE 0,14 BOLD   Of oPrn
DEFINE FONT oFont3 NAME "Arial" SIZE 0,14        Of oPrn
DEFINE FONT oFont4 NAME "Arial" SIZE 0,14 ITALIC Of oPrn
DEFINE FONT oFont5 NAME "Calibri" SIZE 0,14        Of oPrn
DEFINE FONT oFont6 NAME "Calibri" SIZE 0,14        Of oPrn

oFont8	 	:= TFont():New("Arial",06,06,,.F.,,,,.T.,.F.)
oFont8	 	:= TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
oFont8n  	:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
oFont9	 	:= TFont():New("Arial",09,09,,.F.,,,,.T.,.F.)
oFont9n  	:= TFont():New("Arial",09,09,,.T.,,,,.T.,.F.)
oFont10	 	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont11   	:= TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)
oFont14	 	:= TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
oFont16	 	:= TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)
oFont10n  	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont12   	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont12n  	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont16n  	:= TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
oFont14n  	:= TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
oFont6		:= TFont():New("Arial",06,06,,.F.,,,,.T.,.F.)
oFont6n  	:= TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)
cFileLogo	:= GetSrvProfString('Startpath','') + 'LOGORECH02' + '.BMP';


oBrush := TBrush():NEW("",CLR_HGRAY)
oBrush2 := TBrush():NEW("",CLR_HGRAY)

nLastKey  := IIf(LastKey() == 27,27,nLastKey)

If nLastKey == 27

	Return( NIL )
	
Endif


oPrn := TMSPrinter():New( cTitulo )
oPrn:Setup()
oPrn:SetPortrait()                //SetPortrait() //SetLansCape()
oPrn:StartPage()

Imprimir()

oPrn:EndPage()
oPrn:End()

oPrn:Preview()

/*
DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL

@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

@ 015,017 SAY "Esta rotina tem por objetivo imprimir"	OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE
@ 030,017 SAY "o impresso customizado:"					OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE
@ 045,017 SAY "Relatório de Despesas de Viagem"			OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE

@ 06,167 BUTTON "&Imprime" 		SIZE 036,012 ACTION oPrn:Print()   	OF oDlg PIXEL
@ 28,167 BUTTON "Pre&view" 		SIZE 036,012 ACTION oPrn:Preview() 	OF oDlg PIXEL
@ 49,167 BUTTON "Sai&r"    		SIZE 036,012 ACTION oDlg:End()     	OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED
*/
oPrn:End()

Return( NIL )

//--------------------------------------------------------------------------------------------

Static Function Imprimir()

Despesas()
Ms_Flush()

Return( NIL )

//---------------------------------------------------------------------------------------------
Static Function Despesas()

	cDia := SubStr(DtoS(dDataBase),7,2)
	cMes := SubStr(DtoS(dDataBase),5,2)
	cAno := SubStr(DtoS(dDataBase),1,4)
	
	Private nLinha := 0
	Private nCont  := 0
	Private nCont1 := 1
	Private Cont   := 1
	Private Cont1  := 1
	Private cCodRVA 	:= SZ8->Z8_IDRVA
	cFileLogo := "lgrl" + cEmpAnt + ".bmp"
	/*
	cAssConf := cIDCONF + ".bmp"
	cAssAprov := cIDAPROV + ".bmp"
	*/
	oPrn:StartPage()
	
	nCont	:= 0
	/*
	If Cont > Cont1
		nCont1 := nCont1 + 1
		cabec()
		Cont := 1
	Endif
	Cont := Cont + 1
	*/
	lCrtPag	:= .T.
	nLinMax	:= 32
	nLinAtu	:= 1
  
	
  	If lCrtPag
		nCont := nCont
	Endif
	
	//**********
	
	nLinha :=  50
	
				
	SZ8->( dbSetOrder(1) )
	SZ8->( dbSeek( xFilial("SZ8")+cCodRVA ) )
	
	
	
While ! SZ8->( Eof() ) .AND. SZ8->Z8_IDRVA == cCodRVA
	
	
	
	nLin := 1320
		nLinhas := MLCount(SZ8->Z8_OBS,70)
		For nXi:= 1 To nLinhas
		
		        cTxtLinha := MemoLine(SZ8->Z8_OBS,140,nXi)
		        If ! Empty(cTxtLinha)
		              oPrn:Say(nLin+=40,0070,(cTxtLinha),oFont9)
		        EndIf
		        
		        if nLin > 3000 .OR. nLin == 0   
					if nLin <> 0	
					  	
					  	If lCrtPag
							nCont := nCont + 1
							nCont1 := nCont1 + 1
						Endif
						nLin := 1320
						cabec()
						oPrn:EndPage()
								
					endif
				End if
		        
		Next nXi
	
	/*
	cAssConf 	:= Alltrim(SZ2->Z2_IDCONF) + ".bmp"
	cAssAprov 	:= Alltrim(SZ2->Z2_IDAPROV) + ".bmp"
	*/
			
	
	SZ8->( dbSetOrder(1) )
	SZ8->( dbSeek(xFilial("SZ8")+cCodRVA) )

		//oPrn:Say  (0120,2000,"Página " + Transform(StrZero(ncont,3),"")  ,oFont9n)

		oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrn:Say  	( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n)
		
		
		
		// Dados da Colaborador
		oPrn:Box	(0190,0050,0280,0320) // 
		oPrn:Say  (0220,0070,"ID Usuario: " + SZ8->Z8_CODUSER,oFont8n)
		
		oPrn:Box	(0190,0320,0280,2300) //
		oPrn:Say  (0220,0340,"Emitido: " + SZ8->Z8_NUSER,oFont9n)
		
		oPrn:Box	(0280,0050,0360,1800) //
		oPrn:Say  (0300,0070,"E-mail: " + SZ8->Z8_EMAIL,oFont9n)
		
		oPrn:Box	(0280,1800,0360,2300) //
		oPrn:Say  (0300,1820,"Setor: " + SZ8->Z8_SETOR,oFont9n)
				
		oPrn:Box	(0360,0050,0440,1125) //
		oPrn:Say  (00380,0070,"Item Conta: " + SZ8->Z8_ITEMCTA,oFont9n)
		
		oPrn:Box	(0360,1125,0440,2300) //
		oPrn:Say  (00380,1145,"No. Proposta: " + SZ8->Z8_NPROP,oFont9n)
		
		IF SZ8->Z8_TIPOCF = "C"
			mTipoCF := "Cliente"
		ELSE
			mTipoCF := "Fornecedor"
		ENDIF
		
		oPrn:Box	(0440,0050,0520,2300) //
		oPrn:Say  (0460,0070, mTipoCF + ": " + ALLTRIM(SZ8->Z8_CODCF) + " - "  + SZ8->Z8_EMPRESA,oFont9n)
		
		oPrn:Box	(0520,0050,0600,2300) //
		oPrn:Say  (0540,0070, "Local: "  + SZ8->Z8_LOCAL,oFont9n)
		
		oPrn:Box	(0600,0050,0680,2300) //
		oPrn:Say  (0620,0070, "Projeto: "  + SZ8->Z8_PROJETO,oFont9n)
		
		oPrn:Box	(0680,0050,0760,2300) //
		oPrn:Say  (0700,0070, "Assunto: "  + SZ8->Z8_ASSUNTO,oFont9n)
		
		oPrn:Box	(0680,1500,0760,2300) //
		oPrn:Say  (0700,1520, "Material: "  + SZ8->Z8_TIPOMT,oFont9n)
		
		
		oPrn:Box	(0760,0050,0840,1150) //
		oPrn:Say  (0780,0070, "Participante 1: "  + SZ8->Z8_PARTIC1,oFont9n)
		
		oPrn:Box	(0760,1150,0840,2300) //
		oPrn:Say  (0780,1170, "E-mail 1: "  + SZ8->Z8_EMAIL1,oFont9n)
		
		oPrn:Box	(0840,0050,0920,1150) //
		oPrn:Say  (0860,0070, "Participante 2: "  + SZ8->Z8_PARTIC3,oFont9n)
		
		oPrn:Box	(0840,1150,0920,2300) //
		oPrn:Say  (0860,1170, "E-mail 2: "  + SZ8->Z8_EMAIL3,oFont9n)
		
		oPrn:Box	(0920,0050,1000,1150) //
		oPrn:Say  (0940,0070, "Participante 3: "  + SZ8->Z8_PARTIC2,oFont9n)
		
		oPrn:Box	(0920,1150,1000,2300) //
		oPrn:Say  (0940,1170, "E-mail 3: "  + SZ8->Z8_EMAIL2,oFont9n)
		
		oPrn:Box	(1000,0050,1080,1150) //
		oPrn:Say  (1020,0070, "Participante 4: "  + SZ8->Z8_PARTIC4,oFont9n)
		
		oPrn:Box	(1000,1150,1080,2300) //
		oPrn:Say  (1020,1170, "E-mail 4: "  + SZ8->Z8_EMAIL4,oFont9n)
		
		oPrn:Box	(1080,0050,1160,1150) //
		oPrn:Say  (1100,0070, "Participante 5: "  + SZ8->Z8_PARTIC5,oFont9n)
		
		oPrn:Box	(1080,1150,1160,2300) //
		oPrn:Say  (1100,1170, "E-mail 5: "  + SZ8->Z8_EMAIL5,oFont9n)
		
		oPrn:Box	(1160,0050,1240,1150) //
		oPrn:Say  (1180,0070, "Participante 6: "  + SZ8->Z8_PARTIC6,oFont9n)
		
		oPrn:Box	(1160,1150,1240,2300) //
		oPrn:Say  (1180,1170, "E-mail 6: "  + SZ8->Z8_EMAIL6,oFont9n)
		
		oPrn:FillRect({1240,0050,1320,2300},oBrush)
		oPrn:Box	(1240,0050,1320,2300)
		oPrn:Say  (1260,1000,"Observações ",oFont9n)
		
		oPrn:Box	(1320,0050,3150,2300)
		//oPrn:Say  (0070,1100, SZ8->Z8_OBS ,oFont9)
		
		
		// Resumo despesas
		oPrn:Box	(0050,0740,0190,2000) // Titulo Pedido
		oPrn:Say  (0100,1100,"Relatório de Visita - " +  SZ8->Z8_IDRVA ,oFont14)
		
		//oPrn:Box	(0050,1650,0190,2300) // Data Registro
		
		oPrn:Box	(0050,2000,0190,2300) // Data Registro
		oPrn:Say  (0070,2100,"Data Visita " ,oFont9n)
		oPrn:Say  (0120,2100,DTOC(SZ8->Z8_DTVISIT) ,oFont9n)
	
		
	
		nLinha +=0050

		//EndDo

SZ8->( dbSkip() )
		

EndDo			

oPrn:EndPage()

SZ8->( DbCloseArea() )

Return( NIL )

Static Function cabec()
		
		//oPrn:Say  (0120,2000,"Página " + Transform(StrZero(ncont,3),"")  ,oFont9n)

		oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrn:Say  	( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n)

		// Dados da Colaborador
		oPrn:Box	(0190,0050,0280,0320) // 
		oPrn:Say  (0220,0070,"ID Usuario: " + SZ8->Z8_CODUSER,oFont8n)
		
		oPrn:Box	(0190,0320,0280,2300) //
		oPrn:Say  (0220,0340,"Emitido: " + SZ8->Z8_NUSER,oFont9n)
		
		oPrn:Box	(0280,0050,0360,1800) //
		oPrn:Say  (0300,0070,"E-mail: " + SZ8->Z8_EMAIL,oFont9n)
		
		oPrn:Box	(0280,1800,0360,2300) //
		oPrn:Say  (0300,1820,"Setor: " + SZ8->Z8_SETOR,oFont9n)
				
		oPrn:Box	(0360,0050,0440,1125) //
		oPrn:Say  (00380,0070,"Item Conta: " + SZ8->Z8_ITEMCTA,oFont9n)
		
		oPrn:Box	(0360,1125,0440,2300) //
		oPrn:Say  (00380,1145,"No. Proposta: " + SZ8->Z8_NPROP,oFont9n)
		
		IF SZ8->Z8_TIPOCF = "C"
			mTipoCF := "Cliente"
		ELSE
			mTipoCF := "Fornecedor"
		ENDIF
		
		oPrn:Box	(0440,0050,0520,2300) //
		oPrn:Say  (0460,0070, mTipoCF + ": " + ALLTRIM(SZ8->Z8_CODCF) + " - "  + SZ8->Z8_EMPRESA,oFont9n)
		
		oPrn:Box	(0520,0050,0600,2300) //
		oPrn:Say  (0540,0070, "Local: "  + SZ8->Z8_LOCAL,oFont9n)
		
		oPrn:Box	(0600,0050,0680,2300) //
		oPrn:Say  (0620,0070, "Projeto: "  + SZ8->Z8_PROJETO,oFont9n)
		
		oPrn:Box	(0680,0050,0760,2300) //
		oPrn:Say  (0700,0070, "Assunto: "  + SZ8->Z8_ASSUNTO,oFont9n)
		
		oPrn:Box	(0680,1500,0760,2300) //
		oPrn:Say  (0700,1520, "Material: "  + SZ8->Z8_TIPOMT,oFont9n)
		
		
		oPrn:Box	(0760,0050,0840,1150) //
		oPrn:Say  (0780,0070, "Participante 1: "  + SZ8->Z8_PARTIC1,oFont9n)
		
		oPrn:Box	(0760,1150,0840,2300) //
		oPrn:Say  (0780,1170, "E-mail 1: "  + SZ8->Z8_EMAIL1,oFont9n)
		
		oPrn:Box	(0840,0050,0920,1150) //
		oPrn:Say  (0860,0070, "Participante 2: "  + SZ8->Z8_PARTIC3,oFont9n)
		
		oPrn:Box	(0840,1150,0920,2300) //
		oPrn:Say  (0860,1170, "E-mail 2: "  + SZ8->Z8_EMAIL3,oFont9n)
		
		oPrn:Box	(0920,0050,1000,1150) //
		oPrn:Say  (0940,0070, "Participante 3: "  + SZ8->Z8_PARTIC2,oFont9n)
		
		oPrn:Box	(0920,1150,1000,2300) //
		oPrn:Say  (0940,1170, "E-mail 3: "  + SZ8->Z8_EMAIL2,oFont9n)
		
		oPrn:Box	(1000,0050,1080,1150) //
		oPrn:Say  (1020,0070, "Participante 4: "  + SZ8->Z8_PARTIC4,oFont9n)
		
		oPrn:Box	(1000,1150,1080,2300) //
		oPrn:Say  (1020,1170, "E-mail 4: "  + SZ8->Z8_EMAIL4,oFont9n)
		
		oPrn:Box	(1080,0050,1160,1150) //
		oPrn:Say  (1100,0070, "Participante 5: "  + SZ8->Z8_PARTIC5,oFont9n)
		
		oPrn:Box	(1080,1150,1160,2300) //
		oPrn:Say  (1100,1170, "E-mail 5: "  + SZ8->Z8_EMAIL5,oFont9n)
		
		oPrn:Box	(1160,0050,1240,1150) //
		oPrn:Say  (1180,0070, "Participante 6: "  + SZ8->Z8_PARTIC6,oFont9n)
		
		oPrn:Box	(1160,1150,1240,2300) //
		oPrn:Say  (1180,1170, "E-mail 6: "  + SZ8->Z8_EMAIL6,oFont9n)
		
		oPrn:FillRect({1240,0050,1320,2300},oBrush)
		oPrn:Box	(1240,0050,1320,2300)
		oPrn:Say  (1260,1000,"Observações ",oFont9n)
		
		oPrn:Box	(1320,0050,3150,2300)
		
		// Resumo despesas
		oPrn:Box	(0050,0740,0190,2000) // Titulo Pedido
		oPrn:Say  (0100,1100,"Relatório de Visita - " +  SZ8->Z8_IDRVA ,oFont14)
		
		//oPrn:Box	(0050,1650,0190,2300) // Data Registro
		
		oPrn:Box	(0050,2000,0190,2300) // Data Registro
		oPrn:Say  (0070,2100,"Data Visita " ,oFont9n)
		oPrn:Say  (0120,2100,DTOC(SZ8->Z8_DTVISIT) ,oFont9n)
		
		DbSelectArea("SZ8")
		
Return ( Nil )

Static Function AjustaSX1()

putSx1(cPerg, "01", "Numero RDV:"	  , "", "", "mv_ch1", "C", 10, 0, 0, "G", "", "SZ2", "", "", "mv_par01")


Return( NIL )
