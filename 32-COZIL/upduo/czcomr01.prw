#include "MATR110.CH"
#Include "Totvs.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ HICOMR01 º Autor ³  Eduardo Patriani  º Data ³  19/08/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Emite pedido de compra.                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CZCOMR01()

Local xSC7Alias			:= SC7->(GetArea())
Local xAlias 			:= GetArea()

Private oObjPrint		:= TMSPrinter():New("Pedido de Compra - Real")
Private lPedido			:= IF(FunName() == 'MATA121',.T.,.F.)
Private lAutoriza       := IF(FunName() == 'MATA122',.T.,.F.)
Private lAuto           := IF(!FunName() $ 'MATA121|MATA122',.T.,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01               Do Pedido                             ³
//³ mv_par02               Ate o Pedido                          ³
//³ mv_par03               A partir da data de emissao           ³
//³ mv_par04               Ate a data de emissao                 ³
//³ mv_par05               Somente os Novos                      ³
//³ mv_par06               Campo Descricao do Produto    	     ³
//³ mv_par07               Unidade de Medida:Primaria ou Secund. ³
//³ mv_par08               Imprime ? Pedido Compra ou Aut. Entreg³
//³ mv_par09               Numero de vias                        ³
//³ mv_par10               Pedidos ? Liberados Bloqueados Ambos  ³
//³ mv_par11               Impr. SC's Firmes, Previstas ou Ambas ³
//³ mv_par12               Qual a Moeda ?                        ³
//³ mv_par13               Endereco de Entrega                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//IF lAuto
	Pergunte("MTR110",.T.)                                           
//EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecao da impressora.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oObjPrint:SetLandsCape()
oObjPrint:SetSize( 210, 297 )
oObjPrint:Setup()

LjMsgRun("Por Favor Aguarde, Imprimindo Pedido de Compra...",,{|| Imp_Pedido() })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mostra relatorio para imprimir. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oObjPrint:SetLandsCape()
oObjPrint:SetSize( 210, 297 )
oObjPrint:Preview()

RestArea(xSC7Alias)
RestArea(xAlias)

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Imp_PedidoºAutor  ³ Eduardo Patriani   º Data ³  19/08/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao do pedido em modo grafico.                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Imp_Pedido()

Local nLinhaAtual	  	:= 0
Local nNumPagina	  	:= 0
Local nFimLinha       	:= 2300 
Local nFimItem       	:= 1480
Local cUser         	:= ""
Local cDescri           := ""
Local aSavRec           := {}
Local nSaveRec          := 0
Local nDescProd         := 0

Private oFonte01	:= Nil
Private oFonte02	:= Nil
Private oFonte03	:= Nil
Private oFonte04	:= Nil
Private oFonte05	:= Nil
Private oFonte06	:= Nil
Private lFirst, cFornLj, dEmissao, cVendedor, cPedido, dEntrega, lImpRoda
                          
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializa objetos da classe TMSPrinter.			³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFonte01	:= TFont():New("ARIAL",12,16,,.T.,,,16,.F.)
//oFonte02	:= TFont():New("ARIAL",06,08,,.T.,,,08,.F.)
oFonte02	:= TFont():New("ARIAL",06,10,,.T.,,,08,.F.)
oFonte03	:= TFont():New("ARIAL",10,12,,.T.,,,08,.F.)
oFonte04	:= TFont():New("ARIAL",10,12,,.F.,,,08,.F.)
oFonte05	:= TFont():New("ARIAL",08,09,,.T.,,,08,.F.)
oFonte06	:= TFont():New("ARIAL",06,09,,.T.,,,08,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime cabecalho do pedido de compra. 		    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ            
lFirst   := .T.                                                    

//Chamada do relatorio via rotinas.             
If lPedido    
	dbSelectArea("SC7")
	mv_par01 := SC7->C7_NUM
	mv_par02 := SC7->C7_NUM
	mv_par03 := SC7->C7_EMISSAO
	mv_par04 := SC7->C7_EMISSAO
	mv_par05 := 2
	mv_par08 := 1
	mv_par09 := 1
	mv_par10 := 3
	mv_par11 := 3
	mv_par12 := 1
ElseIF lAutoriza   
	dbSelectArea("SC7")
	mv_par01 := SC7->C7_NUM
	mv_par02 := SC7->C7_NUM
	mv_par03 := SC7->C7_EMISSAO
	mv_par04 := SC7->C7_EMISSAO
	mv_par05 := 2
	mv_par08 := 2
	mv_par09 := 1
	mv_par10 := 3
	mv_par11 := 3
	mv_par12 := 1
EndIF

If ( cPaisLoc$"ARG|POR|EUA" )
	cCondBus	:= "1"+strzero(val(mv_par01),6)
	nOrder		:= 10
	nTipo		:= 1 
Else
	cCondBus	:=mv_par01
	nOrder		:=	1
EndIf

//Posiciona no PC ou AE 
IF lPedido .Or. Mv_Par08 == 1         
	dbSelectArea("SC7")
	dbSetOrder(nOrder)
	ProcRegua(RecCount())
	dbSeek(xFilial("SC7")+cCondBus,.T.)
ELSEIF lAutoriza .Or. Mv_Par08 == 2
	dbSelectArea("SC7")
	dbSetOrder(10)
	dbSeek(xFilial("SC7")+"2"+mv_par01,.T.)
EndIF	

While !Eof() .And. C7_FILIAL = xFilial("SC7") .And. C7_NUM >= mv_par01 .And. C7_NUM <= mv_par02
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria as variaveis para armazenar os valores do pedido        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOrdem    := 1
	nReem     := 0  
	lContinua := .F.
	cObs01    := " "
	cObs02    := " "
	cObs03    := " "
	cObs04    := " "
	
	If C7_EMITIDO == "S" .And. mv_par05 == 1
		dbSkip()
		Loop
	Endif
	
	If (C7_CONAPRO == "B" .And. mv_par10 == 1) .Or.;
		(C7_CONAPRO != "B" .And. mv_par10 == 2)
		dbSkip()
		Loop
	Endif
	
	If (C7_EMISSAO < mv_par03) .Or. (C7_EMISSAO > mv_par04)
		dbSkip()
		Loop
	Endif
	
	If C7_TIPO == 2
		dbSkip()
		Loop
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra Tipo de SCs Firmes ou Previstas                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !MtrAValOP(mv_par11, 'SC7')
		dbSkip()
		Loop
	EndIf
		
	MaFisEnd()             
	R110FIniPC(SC7->C7_NUM)	
//	MaFisIniPC(SC7->C7_NUM)
	
	For i := 1 To mv_par09		
		
		cPedido   	:= SC7->C7_NUM
		cFornLj   	:= SC7->C7_FORNECE+SC7->C7_LOJA
		dEmissao  	:= SC7->C7_EMISSAO
		dEntrega  	:= SC7->C7_DATPRF
		cVendedor 	:= SC7->C7_CONTATO
		cUser     	:= SC7->C7_USER
		nReem    	:= SC7->C7_QTDREEM + 1
		NumPed   	:= SC7->C7_NUM
		nSavRec  	:= SC7->( Recno() )
		aSaveRec    := {}
		nTotal   	:= 0
		nTotMerc 	:= 0
		nDescProd 	:= 0
		nLinObs  	:= 0
		nItem       := 0
		nOrdem    	:= 1 
		lImpRoda    := .T.
				
		// Imprime cabecalho
		Imp_Cabec(@nNumPagina,@nLinhaAtual,cUser,i)
		
		oObjPrint:Box( nLinhaAtual+50 , 0015 , nLinhaAtual+1160 , 3268)
		
		While !Eof() .And. SC7->C7_FILIAL == xFilial("SC7") .And. SC7->C7_NUM == NumPed
									
			IF Mv_Par08 == 1			
				//Item
				oObjPrint:Say( nLinhaAtual+55  , 0035 , SC7->C7_ITEM 	 , oFonte02 , 100 )
				//Produto
				oObjPrint:Say( nLinhaAtual+55  , 0150 , SC7->C7_PRODUTO , oFonte02 , 100 )
				//Produto Fornecedor
				//oObjPrint:Say( nLinhaAtual+55  , 0410 , Posicione("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"B1_CODPRF") 	 , oFonte02 , 100 )
				//Descricao do Material
				ImpProd(@cDescri)
				oObjPrint:Say( nLinhaAtual+55  , 0750 , cDescri , oFonte02 , 100 )				
				//Unidade de Medida
				IF Mv_Par07 == 2 .And. !Empty(SC7->C7_SEGUM)
					oObjPrint:Say( nLinhaAtual+55  , 2220 , SC7->C7_SEGUM 	 , oFonte02 , 100 )
				Else
					oObjPrint:Say( nLinhaAtual+55  , 2220 , SC7->C7_UM 	 , oFonte02 , 100 )
				EndIf
				//Quantidade
				IF Mv_Par07 == 2 .And. !Empty(SC7->C7_QTSEGUM)
					oObjPrint:Say( nLinhaAtual+55  , 2320 , Transform(SC7->C7_QTSEGUM,"@E 99999.99") , oFonte02 , 100 )
				Else
					oObjPrint:Say( nLinhaAtual+55  , 2320 , Transform(SC7->C7_QUANT,"@E 99999.99") 	 , oFonte02 , 100 )
				EndIf
				//Valor Unitario
				IF Mv_Par07 == 2 .And. !Empty(SC7->C7_QTSEGUM)
					oObjPrint:Say( nLinhaAtual+55  , 2520 , Transform(xMoeda((SC7->C7_TOTAL/SC7->C7_QTSEGUM),SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),"@E 99999.99") , oFonte02 , 100 )
				Else
					oObjPrint:Say( nLinhaAtual+55  , 2520 , Transform(xMoeda(SC7->C7_PRECO,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),"@E 99999.99") , oFonte02 , 100 )
				EndIf
				//IPI
				oObjPrint:Say( nLinhaAtual+55  , 2710 , Transform(SC7->C7_IPI,"@E 99.99") 	 , oFonte02 , 100 )
				//Val Total
				oObjPrint:Say( nLinhaAtual+55  , 2800 , Transform(xMoeda(SC7->C7_TOTAL,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),"@E 999999.99") , oFonte02 , 100 )
				//Entrega
				oObjPrint:Say( nLinhaAtual+55  , 3020 , Dtoc(SC7->C7_DATPRF) , oFonte02 , 100 )						
			Else 
				//Item
				oObjPrint:Say( nLinhaAtual+55  , 0035 , SC7->C7_ITEM 	 , oFonte02 , 100 )
				//Produto
				oObjPrint:Say( nLinhaAtual+55  , 0160 , SC7->C7_PRODUTO , oFonte02 , 100 )
				//Descricao do Material
				ImpProd(@cDescri)
				oObjPrint:Say( nLinhaAtual+55  , 0520 , cDescri 	 , oFonte06 , 100 )

				//Unidade de Medida
				IF Mv_Par07 == 2 .And. !Empty(SC7->C7_SEGUM)
					oObjPrint:Say( nLinhaAtual+55  , 1350 , SC7->C7_SEGUM 	 , oFonte02 , 100 )
				Else
					oObjPrint:Say( nLinhaAtual+55  , 1350 , SC7->C7_UM 	 , oFonte02 , 100 )
				EndIf
				//Quantidade
				IF Mv_Par07 == 2 .And. !Empty(SC7->C7_QTSEGUM)
					oObjPrint:Say( nLinhaAtual+55  , 1600 , Transform(SC7->C7_QTSEGUM,"@E 99999.99") , oFonte02 , 100 )
				Else                         
					oObjPrint:Say( nLinhaAtual+55  , 1600 , Transform(SC7->C7_QUANT,"@E 99999.99") 	 , oFonte02 , 100 )
				EndIf
				//Valor Unitario
				IF Mv_Par07 == 2 .And. !Empty(SC7->C7_QTSEGUM)
					oObjPrint:Say( nLinhaAtual+55  , 2000 , Transform(xMoeda((SC7->C7_TOTAL/SC7->C7_QTSEGUM),SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),"@E 99999.99") , oFonte02 , 100 )
				Else
					oObjPrint:Say( nLinhaAtual+55  , 2000 , Transform(xMoeda(SC7->C7_PRECO,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),"@E 99999.99") , oFonte02 , 100 )
				EndIf
				//IPI
				oObjPrint:Say( nLinhaAtual+55  , 2230 , Transform(SC7->C7_IPI,"@E 99.99") 	 , oFonte02 , 100 )
				//Val Total
				oObjPrint:Say( nLinhaAtual+55  , 2550 , Transform(xMoeda(SC7->C7_TOTAL,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),"@E 999999.99") , oFonte02 , 100 )
				//Entrega
				oObjPrint:Say( nLinhaAtual+55  , 2820 , Dtoc(SC7->C7_DATPRF) , oFonte02 , 100 )
				//Numero de OP
				oObjPrint:Say( nLinhaAtual+55  , 3100 , SC7->C7_OP , oFonte02 , 100 )				
								
			EndIF
				
			nTotal 	 := nTotal+SC7->C7_TOTAL
			nTotMerc := MaFisRet(,"NF_TOTAL")
			
			If SC7->C7_DESC1 != 0 .or. SC7->C7_DESC2 != 0 .or. SC7->C7_DESC3 != 0
				nDescProd+= CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
			Else
				nDescProd+=SC7->C7_VLDESC
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicializacao da Observacao do Pedido.                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !EMPTY(Alltrim(SC7->C7_OBS)) .And. nLinObs < 5
				nLinObs++
				cVar:="cObs"+StrZero(nLinObs,2)
				Eval(MemVarBlock(cVar),Alltrim(SC7->C7_OBS))
			Endif			
			nLinhaAtual += 040       
			
            // Guardo recno p/gravacao                       
			If Ascan(aSavRec, SC7->( Recno() ) ) == 0		
				AADD(aSavRec, SC7->( Recno() ) )
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Continuacao do Pedido.                                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			IF nLinhaAtual >= nFimItem 
				nLinhaAtual := 1600				
				nOrdem++           
				dbSkip() 
				IF SC7->C7_NUM != cPedido
					nLinhaAtual := 1600
					Imp_Roda(@nLinhaAtual,nFimLinha,nDescProd,nTotal,nTotMerc,cPedido)
                Else 
                	lContinua := .T.                	
					oObjPrint:Box( nLinhaAtual , 0015 , nLinhaAtual+130 , 3268)
					oObjPrint:Say( nLinhaAtual+50 , 1500 , "C O N T I N U A ........." , oFonte03 , 100 )
					//lFirst := .T.  
					//nLinhaAtual := 0
					IF nOrdem == 1
						lImpRoda := .F.
					Else                  
						lImpRoda := .T.
					EndIF
					Imp_Cabec(@nNumPagina,@nLinhaAtual,cUser,i)				
					oObjPrint:Box( nLinhaAtual+50 , 0015 , nLinhaAtual+1160 , 3268)			
                EndIF
			EndIF
			dbSkip()
		EndDo
		
		dbGoto(nSavRec)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprimime rodape                       			³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF lImpRoda
			nLinhaAtual := 1600
			Imp_Roda(@nLinhaAtual,nFimLinha,nDescProd,nTotal,nTotMerc,cPedido)
		EndIF
		
	Next
	MaFisEnd()    
	
	If Len(aSavRec)>0
		For i:=1 to Len(aSavRec)
			dbGoto(aSavRec[i])      
			RecLock("SC7",.F.)  
			Replace C7_QTDREEM With (C7_QTDREEM+1)
			Replace C7_EMITIDO With "S"
			MsUnLock()
		Next i
		dbGoto(aSavRec[Len(aSavRec)])		
	Endif	
	aSavRec := {}

	dbSkip()	
EndDo

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Imp_Cabec ºAutor  ³   Eduardo Patriani º Data ³  19/08/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao do cabecalho da pagina do relatorio               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Imp_Cabec(nNumPagina,nLinhaAtual,cUser,nVias)

LOCAL cMoeda

cMoeda := Iif(mv_par12<10,Str(mv_par12,1),Str(mv_par12,2))
                                
nNumPagina += 1

if !lFirst
	oObjPrint:EndPage()
	oObjPrint:StartPage()
endif

oObjPrint:Line(0050, 0015, 0050, 3268) 
oObjPrint:Box( 0050, 0015, 0420, 1380) 
oObjPrint:Box( 0050, 1380, 0420, 3268)                          
oObjPrint:Line(0150, 1380, 0150, 3268)                            

IF mv_par08 == 1 
	oObjPrint:Say( 0070, 1400, "Pedido de Compra - "+GetMV("MV_MOEDA"+cMoeda),oFonte03,100 )
Else                                                               
	oObjPrint:Say( 0070, 1400, "Aut. de Entrega - "+GetMV("MV_MOEDA"+cMoeda),oFonte03,100 )
EndiF
//oObjPrint:Say( 0070, 2170, "No. "+cPedido+"/"+Str(nOrdem,1),oFonte03,100 )
//oObjPrint:Say( 0070, 2600, IIF(SC7->C7_QTDREEM > 0,Str(SC7->C7_QTDREEM+1,2)+"a.Emissao "+Str(nVias,2)+"a.VIA"," "), oFonte03, 100 )
oObjPrint:Say( 0070, 2170, "No. "+cPedido,oFonte03,100 )
oObjPrint:Say( 0070, 2600, Str(nVias,2)+"a.VIA", oFonte03, 100 )

dbSelectArea("SA2")
dbSetOrder(1)
dbSeek(xFilial()+cFornLj)

//Itens das Empresas
oObjPrint:Say( 0175, 0030, "EMPRESA",oFonte03,100 )
oObjPrint:Say( 0175, 1400, "FORNECEDOR",oFonte03,100 )

oObjPrint:Say( 0220, 0030, Posicione("SM0",1,cNumEmp,"M0_NOMECOM") ,oFonte02,100 )
oObjPrint:Say( 0220, 1400, Alltrim(Substr(SA2->A2_NOME,1,28))+" - ("+SA2->A2_COD+")" ,oFonte02,100 )

oObjPrint:Say( 0255, 0030, UPPER(SM0->M0_ENDENT) ,oFonte02,100 )
oObjPrint:Say( 0255, 1400, UPPER(Substr(SA2->A2_END,1,30)+ Substr(SA2->A2_BAIRRO,1,10)) ,oFonte02,100 )

oObjPrint:Say( 0290, 0030, UPPER("CEP: "+Trans(SM0->M0_CEPENT,PesqPict("SA1","A1_CEP"))),oFonte02,100 )
oObjPrint:Say( 0290, 0950, UPPER(Trim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT) ,oFonte02,100 )
oObjPrint:Say( 0290, 1400, Upper(Trim(SA2->A2_MUN)+"   "+SA2->A2_EST+" "+"CEP: "+Trans(SA2->A2_CEP,PesqPict("SA1","A1_CEP"))) ,oFonte02,100 )
oObjPrint:Say( 0290, 2170, "FAX: " + "("+Substr(SA2->A2_DDD,1,3)+") "+SA2->A2_FAX ,oFonte02,100 )

oObjPrint:Say( 0325, 0030, "TEL: " + SM0->M0_TEL ,oFonte02,100 )
oObjPrint:Say( 0325, 0950, "FAX: " + SM0->M0_FAX ,oFonte02,100 )
oObjPrint:Say( 0325, 1400, "VENDEDOR: " + Upper(Substr(cVendedor,1,10)),oFonte02,100 )
oObjPrint:Say( 0325, 2170, "FONE: " + "("+Substr(SA2->A2_DDD,1,3)+") "+Substr(SA2->A2_TEL,1,15) ,oFonte02,100 )

oObjPrint:Say( 0360, 0030, "CNPJ/CPF: "+ Trans(SM0->M0_CGC,PesqPict("SA1","A1_CGC")),oFonte02,100 )
oObjPrint:Say( 0360, 0950, "IE:" + InscrEst() ,oFonte02,100 )

oObjPrint:Say( 0360, 1400, "CNPJ: " + Alltrim(SA2->A2_CGC) ,oFonte02,100 )
oObjPrint:Say( 0360, 2170, "IE: " + SA2->A2_INSCR ,oFonte02,100 )

oObjPrint:Box( 0420, 0015, 0500, 3268)

IF Mv_Par08 == 1

	oObjPrint:Box( 0420, 0015, 0500, 0140)
	oObjPrint:Say( 0425, 0035, "Item" ,oFonte02,100 )
	oObjPrint:Box( 0420, 0140, 0500, 0400)//500
	oObjPrint:Say( 0425, 0150, "Codigo" ,oFonte02,100 )
	//oObjPrint:Box( 0420, 0500, 0500, 0740)
	//oObjPrint:Say( 0425, 0500, "Prod x Forn" ,oFonte02,100 )//520 
	oObjPrint:Box( 0420, 0400, 0500, 0740)
	oObjPrint:Say( 0425, 0410, "Prod x Forn" ,oFonte02,100 )//520
	oObjPrint:Box( 0420, 0740, 0500, 2200) //740
	oObjPrint:Say( 0425, 0750, "Descricao do Material" ,oFonte02,100 )	
	oObjPrint:Box( 0420, 2200, 0500, 2300)
	oObjPrint:Say( 0425, 2220, "UM" ,oFonte02,100 )
	oObjPrint:Box( 0420, 2300, 0500, 2500)
	oObjPrint:Say( 0425, 2320, "Quant." ,oFonte02,100 )	
	oObjPrint:Box( 0420, 2500, 0500, 2700)
	oObjPrint:Say( 0425, 2520, "Vlr Unit." ,oFonte02,100 )
	oObjPrint:Box( 0420, 2700, 0500, 2780)
	oObjPrint:Say( 0425, 2720, "IPI" ,oFonte02,100 )
	oObjPrint:Box( 0420, 2780, 0500, 3000)
	oObjPrint:Say( 0425, 2800, "Val Total" ,oFonte02,100 )
	oObjPrint:Box( 0420, 3000, 0500, 3268)
	oObjPrint:Say( 0425, 3020, "Entrega" ,oFonte02,100 )

Else 

	oObjPrint:Box( 0420, 0015, 0500, 0140)
	oObjPrint:Say( 0425, 0035, "Item" ,oFonte02,100 )
	oObjPrint:Box( 0420, 0140, 0500, 0500)
	oObjPrint:Say( 0425, 0160, "Codigo" ,oFonte02,100 )
	oObjPrint:Box( 0420, 0500, 0500, 1300)
	oObjPrint:Say( 0425, 0520, "Descricao do Material" ,oFonte02,100 )
	oObjPrint:Box( 0420, 1300, 0500, 1430)
	oObjPrint:Say( 0425, 1320, "UM" ,oFonte02,100 )
	oObjPrint:Box( 0420, 1430, 0500, 1800)
	oObjPrint:Say( 0425, 1450, "Quant." ,oFonte02,100 )
	oObjPrint:Box( 0420, 1800, 0500, 2200)
	oObjPrint:Say( 0425, 1820, "Valor Unitario" ,oFonte02,100 )
	oObjPrint:Box( 0420, 2200, 0500, 2350)
	oObjPrint:Say( 0425, 2220, "IPI" ,oFonte02,100 )
	oObjPrint:Box( 0420, 2350, 0500, 2750)
	oObjPrint:Say( 0425, 2370, "Val Total" ,oFonte02,100 )
	oObjPrint:Box( 0420, 2750, 0500, 3000)
	oObjPrint:Say( 0425, 2770, "Entrega" ,oFonte02,100 )
	oObjPrint:Box( 0420, 3000, 0500, 3268)
	oObjPrint:Say( 0425, 3020, "Numero da OP" ,oFonte02,100 )

EndIF	

nLinhaAtual := 0445
lFirst := .F.

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Imp_Roda  ºAutor  ³ Eduardo Patriani   º Data ³  19/08/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao do rodape da pagina do relatorio                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Imp_Roda(nLinhaAtual,nFimLinha,nDescProd,nTotal,nTotMerc,cPedido)

Local lNewAlc	 := .F.
Local lLiber 	 := .F.
Local lImpLeg	 := .T.
Local cComprador := ""
LOcal cAlter	 := ""
Local cAprov	 := ""
Local nTotIpi := nTotIcms := nTotDesp := nTotFrete := nTotalNF := nTotSeguro := 0
Local nTotalNF2 := 0

nTotDesc 	:= nDescProd  

WHILE SC7->(!EOF()) .AND. C7_FILIAL = xFilial("SC7") .And. C7_NUM == cPedido

	nTotIpi		+= SC7->C7_VALIPI
	nTotIcms	+= SC7->C7_VALICM
	nTotDesp	+= SC7->C7_DESPESA
	nTotFrete	+= SC7->C7_VALFRE
	nTotalNF	+= SC7->C7_TOTAL
	nTotSeguro	+= SC7->C7_SEGURO

	SC7->(DbSkip())

ENDDO
/*
nTotIpi		:= MaFisRet(,'NF_VALIPI',SC7->C7_VALIPI)
nTotIcms	:= MaFisRet(,'NF_VALICM',SC7->C7_VALICM)
nTotDesp	:= MaFisRet(,'NF_DESPESA',SC7->C7_DESPESA)
nTotFrete	:= MaFisRet(,'NF_FRETE',SC7->C7_VALFRE)
nTotalNF	:= MaFisRet(,'NF_TOTAL',SC7->C7_TOTAL)
nTotSeguro	:= MaFisRet(,'NF_SEGURO',SC7->C7_SEGURO)*/
nTotalNF2	:= (nTotIpi + nTotFrete + nTotalNF)

//Mensagem da Formula
cMensagem:= Formula(SC7->C7_MSG)
If !Empty(cMensagem)            
	nLinhaAtual-=40
	oObjPrint:Say( nLinhaAtual , 1000 , cMensagem ,oFonte02,100 )
	nLinhaAtual+=40
Endif                                               

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Descontos.                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oObjPrint:Box( nLinhaAtual 		, 0015 , nLinhaAtual+90 , 3268) 
oObjPrint:Say( nLinhaAtual+35 	, 0700, "D E S C O N T O S -->" ,oFonte02,100 )
oObjPrint:Say( nLinhaAtual+35 	, 1200, Transform(SC7->C7_DESC1,"@E 999.99") ,oFonte02,100 )
oObjPrint:Say( nLinhaAtual+35 	, 1400, Transform(SC7->C7_DESC2,"@E 999.99") ,oFonte02,100 )
oObjPrint:Say( nLinhaAtual+35 	, 1600, Transform(SC7->C7_DESC3,"@E 999.99") ,oFonte02,100 )
oObjPrint:Say( nLinhaAtual+35 	, 2000, Transform(xMoeda(nTotDesc,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),"@E 999,999,999.99") ,oFonte02,100 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona o Arquivo de Empresa SM0.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLinhaAtual+=90                                                 
oObjPrint:Box( nLinhaAtual 		, 0015 , nLinhaAtual+110 , 3268) //-10 

cAlias := Alias()
dbSelectArea("SM0")
dbSetOrder(1)   // forca o indice na ordem certa
nRegistro := Recno()
dbSeek(SUBS(cNumEmp,1,2)+SC7->C7_FILENT)

//Observacoes
/*
If Empty(cObs02)
	If Len(cObs01) > 50
		cObs := cObs01
		cObs01 := Substr(cObs,1,50)
		For nX := 2 To 4
			cVar  := "cObs"+StrZero(nX,2)
			&cVar := Substr(cObs,(50*(nX-1))+1,50)
		Next
	EndIf
Else
	cObs01:= Substr(cObs01,1,IIf(Len(cObs01)<50,Len(cObs01),50))
	cObs02:= Substr(cObs02,1,IIf(Len(cObs02)<50,Len(cObs01),50))
	cObs03:= Substr(cObs03,1,IIf(Len(cObs03)<50,Len(cObs01),50))
	cObs04:= Substr(cObs04,1,IIf(Len(cObs04)<50,Len(cObs01),50))
EndIf

oObjPrint:Say( nLinhaAtual+15 	, 0035, " Observacoes: "+Alltrim(cObs01)+Alltrim(cObs02)  ,oFonte02,100 )
oObjPrint:Say( nLinhaAtual+40 	, 0035, Alltrim(cObs03)+Alltrim(cObs04)	  				  ,oFonte02,100 )
*/
                        
cObs := "Observacoes: " 
For nX := 1 To 4
	cVar := "cObs"+StrZero(nX,2)
	cObs += Iif(!Empty( &(cVar) ), &(cVar)+". ", "")
Next
nLinhas := MlCount(cObs, 160)

For nX := 1 To nLinhas                 
	If nX == 1
		oObjPrint:Say(nLinhaAtual + 15, 0020, MeMoLine(cObs, 160, nX) ,oFonte02,100 )
	Else                                                                             
		oObjPrint:Say(nLinhaAtual + (25 * nX), 0020, MeMoLine(cObs, 160, nX) ,oFonte02,100 )
	EndIf
Next nX


/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime endereco de entrega do SM0 somente se o MV_PAR13 =" "³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF Empty(Mv_Par13)
	oObjPrint:Say( nLinhaAtual+20 , 0050, 	"Local de Entrega  : " + SM0->M0_ENDENT 				,oFonte02,100 )
	oObjPrint:Say( nLinhaAtual+20 , 1400, "-" 													,oFonte02,100 )
	oObjPrint:Say( nLinhaAtual+20 , 1450, SM0->M0_CIDENT										,oFonte02,100 )
	oObjPrint:Say( nLinhaAtual+20 , 1800, SM0->M0_ESTENT										,oFonte02,100 )
	oObjPrint:Say( nLinhaAtual+20 , 2200, "CEP :" + Transform(SM0->M0_CEPENT,"@R 99999-999")	,oFonte02,100 )
Else
	oObjPrint:Say( nLinhaAtual+20 , 0050, "Local de Entrega  : " + Mv_Par13       				,oFonte02,100 )	
EndIF

dbGoto(nRegistro)
dbSelectArea( cAlias )
oObjPrint:Say( nLinhaAtual+55 , 0050, "Local de Cobranca : " + SM0->M0_ENDCOB 				,oFonte02,100 )
oObjPrint:Say( nLinhaAtual+55 , 1400, "-" 													,oFonte02,100 )
oObjPrint:Say( nLinhaAtual+55 , 1450, SM0->M0_CIDCOB										,oFonte02,100 )
oObjPrint:Say( nLinhaAtual+55 , 1800, SM0->M0_ESTCOB										,oFonte02,100 )
oObjPrint:Say( nLinhaAtual+55 , 2200, "CEP :" + Transform(SM0->M0_CEPCOB,"@R 99999-999")	,oFonte02,100 )

*/
//Condicao de Pagto.
nLinhaAtual+=110                                                
oObjPrint:Box( nLinhaAtual 		, 0015 , nLinhaAtual+110 , 1000) 
oObjPrint:Box( nLinhaAtual 		, 0015 , nLinhaAtual+110 , 1634) 
oObjPrint:Box( nLinhaAtual 		, 1634 , nLinhaAtual+110 , 3268) 

dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial()+SC7->C7_COND)
dbSelectArea("SC7")     
                      
oObjPrint:Say( nLinhaAtual+20 , 0035, "Condicao de Pagto "+SubStr(SE4->E4_COND,1,15)	,oFonte02,100 )
oObjPrint:Say( nLinhaAtual+20 , 1050, "Data de Emissao"									,oFonte02,100 )
oObjPrint:Say( nLinhaAtual+20 , 1700, "Total das Mercadorias : "						,oFonte02,100 )
oObjPrint:Say( nLinhaAtual+20 , 2300, Transform(xMoeda(nTotalNF,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),"@E 999,999,999.99")	,oFonte02,100 )
//oObjPrint:Say( nLinhaAtual+20 , 2300, Transform(xMoeda(nTotal,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),"@E 999,999,999.99")	,oFonte02,100 )

oObjPrint:Say( nLinhaAtual+65 , 0035, Substr(SE4->E4_DESCRI,1,34)						,oFonte02,100 )
oObjPrint:Say( nLinhaAtual+65 , 1050, Dtoc(SC7->C7_EMISSAO)							,oFonte02,100 )
oObjPrint:Say( nLinhaAtual+65 , 1700, "Total com Impostos : "							,oFonte02,100 )
oObjPrint:Say( nLinhaAtual+65 , 2300, Transform(xMoeda(nTotalNF2,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),"@E 999,999,999.99"),oFonte02,100 )

nLinhaAtual+=110    
oObjPrint:Box( nLinhaAtual 		, 0015 , nLinhaAtual+240 , 3268)                                             
oObjPrint:Box( nLinhaAtual 		, 0015 , nLinhaAtual+240 , 1634)                                             
oObjPrint:Box( nLinhaAtual 		, 0015 , nLinhaAtual+70  , 1634)                                             

//Reajuste
dbSelectArea("SM4")
dbSetOrder(1)
dbSeek(xFilial()+SC7->C7_REAJUST)
dbSelectArea("SC7")

//Reajuste
oObjPrint:Say( nLinhaAtual+20 , 0035, "Reajuste :"			,oFonte02,100 )
oObjPrint:Say( nLinhaAtual+20 , 0400, SC7->C7_REAJUST		,oFonte02,100 )
oObjPrint:Say( nLinhaAtual+20 	, 0800, SM4->M4_DESCR		,oFonte02,100 )

//Impostos
oObjPrint:Say( nLinhaAtual+20 , 1700, " IPI   :"			,oFonte02,100 )
oObjPrint:Say( nLinhaAtual+20 , 2000, Transform(xMoeda(nTotIPI,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),"@E 999,999,999.99"),oFonte02,100 )
oObjPrint:Say( nLinhaAtual+20 , 2300, " ICMS  :"			,oFonte02,100 )
oObjPrint:Say( nLinhaAtual+20 , 2600, Transform(xMoeda(nTotIcms,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),"@E 999,999,999.99"),oFonte02,100 )

//Despesas
oObjPrint:Say( nLinhaAtual+55 	, 1700, " Frete :"			,oFonte02,100 )
oObjPrint:Say( nLinhaAtual+55 	, 2000, Transform(xMoeda(nTotFrete,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),"@E 999,999,999.99"),oFonte02,100 )
oObjPrint:Say( nLinhaAtual+55 	, 2300, " Despesas :"		,oFonte02,100 )
oObjPrint:Say( nLinhaAtual+55 	, 2600, Transform(xMoeda(nTotDesp,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),"@E 999,999,999.99"),oFonte02,100 )

//Pedido Bloqueado ou Aprovado
dbSelectArea("SC7")
If !Empty(C7_APROV)
	lNewAlc := .T.
	cComprador := UsrFullName(SC7->C7_USER)
	If C7_CONAPRO != "B"
		lLiber := .T.
	EndIf
	dbSelectArea("SCR")
	dbSetOrder(1)
	dbSeek(xFilial()+"PC"+SC7->C7_NUM)
	While !Eof() .And. SCR->CR_FILIAL+Alltrim(SCR->CR_NUM)==xFilial("SCR")+SC7->C7_NUM .And. SCR->CR_TIPO == "PC"
	  cAprov += AllTrim(UsrFullName(SCR->CR_USER))+" ["+;
	 	  IF(SCR->CR_STATUS=="03","Ok",IF(SCR->CR_STATUS=="04","BLQ","??"))+"] - "
	  dbSelectArea("SCR")
	  dbSkip()
	Enddo
	If !Empty(SC7->C7_GRUPCOM)
		dbSelectArea("SAJ")
		dbSetOrder(1)
		dbSeek(xFilial()+SC7->C7_GRUPCOM)
		While !Eof() .And. SAJ->AJ_FILIAL+SAJ->AJ_GRCOM == xFilial("SAJ")+SC7->C7_GRUPCOM
			If SAJ->AJ_USER != SC7->C7_USER
				cAlter += AllTrim(UsrFullName(SAJ->AJ_USER))+"/"
			EndIf
			dbSelectArea("SAJ")
			dbSkip()
		EndDo
	EndIf
EndIf

//Observacaoes
//oObjPrint:Say( nLinhaAtual+90 	, 0035, " Observacoes"		,oFonte02,100 )
//oObjPrint:Say( nLinhaAtual+130	, 0035, cObs01				,oFonte02,100 )
//oObjPrint:Say( nLinhaAtual+170	, 0035, cObs02				,oFonte02,100 )
//oObjPrint:Say( nLinhaAtual+210	, 0035, cObs03				,oFonte02,100 )
//oObjPrint:Say( nLinhaAtual+240	, 0035, cObs04				,oFonte02,100 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime endereco de entrega do SM0 somente se o MV_PAR13 =" "³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF Empty(Mv_Par13)
	oObjPrint:Say( nLinhaAtual+90 , 0035, "Local Entrega: "+AllTrim(SM0->M0_ENDENT)+" - "+AllTrim(SM0->M0_CIDENT)+"/"+AllTrim(SM0->M0_ESTENT)+" CEP :" + Transform(SM0->M0_CEPENT,"@R 99999-999")		,oFonte02,100 )	
Else
	oObjPrint:Say( nLinhaAtual+90 , 0035, "Local Entrega: " + Mv_Par13,oFonte02,100 )	
EndIF

dbGoto(nRegistro)
dbSelectArea( cAlias )
oObjPrint:Say( nLinhaAtual+130 , 0035, "Local Cobranca: "+AllTrim(SM0->M0_ENDCOB)+" - "+AllTrim(SM0->M0_CIDCOB)+"/"+AllTrim(SM0->M0_ESTCOB)+" CEP :" + Transform(SM0->M0_CEPCOB,"@R 99999-999") 				,oFonte02,100 )

//Despesas
oObjPrint:Say( nLinhaAtual+90 	, 1700, " Grupo :"			,oFonte02,100 )
oObjPrint:Say( nLinhaAtual+90 	, 2000, ""					,oFonte02,100 )
oObjPrint:Say( nLinhaAtual+90 	, 2300, " SEGURO   :"		,oFonte02,100 )
oObjPrint:Say( nLinhaAtual+90 	, 2600, Transform(xMoeda(nTotSeguro,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),"@E 999,999,999.99"),oFonte02,100 )

//Total Geral
oObjPrint:Box( nLinhaAtual+135 	, 1634 , nLinhaAtual+240  	,3268)     
oObjPrint:Say( nLinhaAtual+160	, 1700, " Total Geral: " 	,oFonte02,100 )

IF !lNewAlc
	oObjPrint:Say( nLinhaAtual+160 	, 2600, Transform(xMoeda(nTotalNF2,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),"@E 999,999,999.99"),oFonte02,100 )
Else
	IF lLiber
		oObjPrint:Say( nLinhaAtual+160 	, 2600, Transform(xMoeda(nTotalNF2,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),"@E 999,999,999.99"),oFonte02,100 )
	Else
		oObjPrint:Say( nLinhaAtual+160 	, 2300, "P E D I D O   B L O Q U E A D O !!!" ,oFonte03,100 )
	EndIf
EndIF

If !lNewAlc           
	nLinhaAtual+=240        
	oObjPrint:Box( nLinhaAtual 		, 0015 , nLinhaAtual+170		, 0545) 
	oObjPrint:Say( nLinhaAtual+30 	, 0110 , "Comprador"			,oFonte02,100 )
	oObjPrint:Box( nLinhaAtual 		, 0545 , nLinhaAtual+170	 	, 1090) 
	oObjPrint:Say( nLinhaAtual+30 	, 0645 , "Gerencia" 			,oFonte02,100 )
	oObjPrint:Box( nLinhaAtual 		, 1090 , nLinhaAtual+170	 	, 1634) 
	oObjPrint:Say( nLinhaAtual+30 	, 1190 , "Diretoria"			,oFonte02,100 )
	//oObjPrint:Box( nLinhaAtual 		, 1634 , nLinhaAtual+210 		, 0700)
	oObjPrint:Say( nLinhaAtual+30 	, 1854 , "Liberacao do Pedido" 	,oFonte02,100 )
	//oObjPrint:Say( nLinhaAtual+150 	, 1754 , Replicate("-",50) 		,oFonte02,100 )
	oObjPrint:Box( nLinhaAtual 		, 2451 , nLinhaAtual+170 		, 3268)                             
	oObjPrint:Say( nLinhaAtual+30 	, 2461, "Obs. do Frete: " 		,oFonte02,100 )
	oObjPrint:Say( nLinhaAtual+30 	, 2800, IF( SC7->C7_TPFRETE $ "F","FOB",IF(SC7->C7_TPFRETE $ "C","CIF"," " ))	,oFonte02,100 )                                                                               
	
Else
	//RODAPE
	nLinhaAtual+=240  
	oObjPrint:Box( nLinhaAtual , 0015 , nLinhaAtual+170 ,2300)                                                                    
	oObjPrint:Box( nLinhaAtual , 2300 , nLinhaAtual+170 ,3268)     
	oObjPrint:Say( nLinhaAtual+30 , 0020, "Comprador Responsavel :"	,oFonte02,100 )
	oObjPrint:Say( nLinhaAtual+30 , 0400, Substr(cComprador,1,60)	,oFonte02,100 )
	oObjPrint:Say( nLinhaAtual+30 , 2050, "BLQ:Bloqueado"			,oFonte02,100 )
	oObjPrint:Say( nLinhaAtual+30 , 2350, "Obs. do Frete: " 		,oFonte02,100 )
	oObjPrint:Say( nLinhaAtual+30 , 2800, IF( SC7->C7_TPFRETE $ "F","FOB",IF(SC7->C7_TPFRETE $ "C","CIF"," " ))	,oFonte02,100 )                                                                               
	
	nAuxLin := Len(cAlter)
	oObjPrint:Say( nLinhaAtual+70 , 0020, "Compradores Alternativos :"	,oFonte02,100 )                                                                               
	While nAuxLin > 0 .oR. lImpLeg   
		nColuna := 0250
		oObjPrint:Say( nLinhaAtual+70 , nColuna , Substr(cAlter,Len(cAlter)-nAuxLin+1,60)	,oFonte02,100 )
		IF lImpLeg 
				oObjPrint:Say( nLinhaAtual+70 , 2050 , "Ok:Liberado"	,oFonte02,100 )
			lImpLeg := .F.
		EndIf    
		nAuxLin 	-=60
	EndDo		
	
	nAuxLin := Len(cAprov)
	lImpLeg := .T.
	oObjPrint:Say( nLinhaAtual+110 , 0020 ,"Aprovador(es) :"	,oFonte02,100 )
	While nAuxLin > 0	.Or. lImpLeg
		nColuna := 0350
		oObjPrint:Say( nLinhaAtual+110 , nColuna , Substr(cAprov,Len(cAprov)-nAuxLin+1,70)	,oFonte02,100 )
		If lImpLeg   
			oObjPrint:Say( nLinhaAtual+110 , 2050 , "??:Aguar.Lib"	,oFonte02,100 )
			lImpLeg := .F.
		EndIf
		nAUxLin -=70
	EndDo
EndIF	

//Mensagem do Rodape.
nLinhaAtual+=170 
oObjPrint:Line (nLinhaAtual, 0015, nLinhaAtual, 3268)                                                                                  
//oObjPrint:Box( nLinhaAtual 		, 0015 , nLinhaAtual+130		, 3268)        
oObjPrint:Say( nLinhaAtual+10 	, 0035, "NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero do nosso Pedido de Compras." 		,oFonte03,100 )
oObjPrint:Say( nLinhaAtual+60   , 0035, "NOTA: Não aceitamos Factoring."   ,oFonte03,100 )

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpProd  ³ Autor ³ Eduardo Patriani      ³ Data ³ 19/08/07 ³±±
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
Static Function ImpProd(cDescri)

cDescri := " "

If Empty(mv_par06)
	mv_par06 := "B1_DESC"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao generica do Produto.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(mv_par06) == "B1_DESC"
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek( xFilial()+SC7->C7_PRODUTO )
	cDescri := Alltrim(SB1->B1_DESC)
	dbSelectArea("SC7")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao cientifica do Produto.                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(mv_par06) == "B5_CEME"
	dbSelectArea("SB5")
	dbSetOrder(1)
	If dbSeek( xFilial()+SC7->C7_PRODUTO )
		cDescri := Alltrim(B5_CEME)
	EndIf
	dbSelectArea("SC7")
EndIf

dbSelectArea("SC7")
If AllTrim(mv_par06) == "C7_DESCRI"
	cDescri := Alltrim(SC7->C7_DESCRI)
EndIf

If Empty(cDescri)
	dbSelectArea("SB1")
	dbSetOrder(1)
	MsSeek( xFilial()+SC7->C7_PRODUTO )
	cDescri := Alltrim(SB1->B1_DESC)
	dbSelectArea("SC7")
EndIf

dbSelectArea("SA5")
dbSetOrder(1)
If dbSeek(xFilial()+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_PRODUTO).And. !Empty(SA5->A5_CODPRF)
	cDescri := cDescri + " ("+Alltrim(A5_CODPRF)+")"
EndIf
dbSelectArea("SC7")

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³R110FIniPC³ Autor ³ Edson Maricate        ³ Data ³20/05/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Inicializa as funcoes Fiscais com o Pedido de Compras      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R110FIniPC(ExpC1,ExpC2)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 := Numero do Pedido                                  ³±±
±±³          ³ ExpC2 := Item do Pedido                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR110,MATR120,Fluxo de Caixa                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R110FIniPC(cPedido,cItem,cSequen,cFiltro)

Local aArea		:= GetArea()
Local aAreaSC7	:= SC7->(GetArea())
Local cValid		:= ""
Local nPosRef		:= 0
Local nItem		:= 0
Local cItemDe		:= IIf(cItem==Nil,'',cItem)
Local cItemAte	:= IIf(cItem==Nil,Repl('Z',Len(SC7->C7_ITEM)),cItem)
Local cRefCols	:= ''
DEFAULT cSequen	:= ""
DEFAULT cFiltro	:= ""

dbSelectArea("SC7")
dbSetOrder(1)
If dbSeek(xFilial("SC7")+cPedido+cItemDe+Alltrim(cSequen))
	MaFisEnd()
	MaFisIni(SC7->C7_FORNECE,SC7->C7_LOJA,"F","N","R",{})
	While !Eof() .AND. SC7->C7_FILIAL+SC7->C7_NUM == xFilial("SC7")+cPedido .AND. ;
			SC7->C7_ITEM <= cItemAte .AND. (Empty(cSequen) .OR. cSequen == SC7->C7_SEQUEN)

		// Nao processar os Impostos se o item possuir residuo eliminado  
		If &cFiltro
			dbSelectArea('SC7')
			dbSkip()
			Loop
		EndIf
            
		// Inicia a Carga do item nas funcoes MATXFIS  
		nItem++
		MaFisIniLoad(nItem)
		dbSelectArea("SX3")
		dbSetOrder(1)
		dbSeek('SC7')
		While !EOF() .AND. X3_ARQUIVO == 'SC7'
			cValid	:= StrTran(UPPER(SX3->X3_VALID)," ","")
			cValid	:= StrTran(cValid,"'",'"')
			If "MAFISREF" $ cValid
				nPosRef  := AT('MAFISREF("',cValid) + 10
				cRefCols := Substr(cValid,nPosRef,AT('","MT120",',cValid)-nPosRef )
				// Carrega os valores direto do SC7.           
				//MaFisLoad(cRefCols,&("SC7->"+ SX3->X3_CAMPO),nItem)
			EndIf
			dbSkip()
		End
		MaFisEndLoad(nItem,2)
		dbSelectArea('SC7')
		dbSkip()
	End
EndIf

RestArea(aAreaSC7)
RestArea(aArea)

Return .T.
