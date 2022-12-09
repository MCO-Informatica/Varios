#INCLUDE "PROTHEUS.CH"
#INCLUDE "APVT100.CH"
#INCLUDE "RWMAKE.CH" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ ACDHCI07 ³ Autor ³ Luiz Enrique          ³ Data ³ 22/01/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ GERA SALDO INICAL em SBJ/SB8  VIA RF					      ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß  
*/                                                                             

User Function ACDHCI07()

Local 	cEtiProd 	 
Local 	nQtde		:= 	1   

Private	cProduto	
Private	cEtilote
Private clotefor
Private cloteCtl
Private	cArmz 
Private cFornRi
Private cLojaRi
Private cOc 
Private nTraco
Private nCasas

While .t.
	cEtiProd	:=	Space(15)
	cEtilote	:= 	Space(20)
	clotefor	:=	Space(10)
	clotectl	:=	Space(10)
	cFornRi		:=  Space(6)
	cArmz		:= 	"01" 
	cLojaRi     :=  Space(2)
	cOc         :=  Space(6)
	nTraco:=1
	nCasas:=0  
	VtClearBuffer()	    
	VtClear()			
	@ 0,0 VTSay "Saldo por Lote."
	@ 1,0 VTSay "Armazem: "	VTGet cArmz pict "@!" VALID !Empty(cArmz) .or. VldArm(cArmz) 
	@ 2,0 VTSay "Leia o produto:" VTGet cEtiProd pict "@!" VALID VTLastkey() == 5 .or. VldProduto(cEtiProd)			
	@ 3,0 VTSay "Leia o H:" VTGet cEtilote pict "@!" VALID VTLastkey() == 5 .or. VldProLot(cEtilote)
	@ 4,0 VTSay "Leia a Corrida:" VTGet clotefor pict "@!" VALID VTLastkey() == 5 .or. VldLotfor(clotefor)	 
    @ 5,0 VTSay "Fornecedor:" VTGet cFornRi pict "@!" VALID VTLastkey() == 5  .or. !Empty(cFornRi)
    @ 6,0 VTSay "Digite Loja:" VTGet cLojaRi pict "@!" VALID VTLastkey() == 5 .or. VldLoja(cFornRi,cLojaRi)	
    @ 7,0 VTSay "Digite Oc:" VTGet cOc pict "@!" VALID VTLastkey() == 5 .or. !Empty(cOc)	
	VTRead 
		                                 
	If VTLastkey() == 27		
		exit		 		
	Endif 

	//	If !VtYesNo("Produto: " + Alltrim(cEtiProd) + " - Lote " + Alltrim(cEtilote) + " Gerar Saldo?","AVISO",.t.)  
	
	IF SUBSTR(cEtilote,1,3)<>"HHC" .AND. SUBSTR(cEtilote,1,4)<>"H1HC" .AND. SUBSTR(cEtilote,1,3)<>"HPT" .AND. SUBSTR(cEtilote,1,4)<>"H1MC" .AND. SUBSTR(cEtilote,1,4)<>"H2HC"
      	//cArmz:="01"
      	cLotectl:=cEtilote
    ENDIF
    IF SUBSTR(cEtilote,1,3)="HHC" 
      	cArmz:="15"
      	cLotectl:=SUBSTR(cEtilote,1,1)+SUBSTR(cEtilote,4,9)
    ENDIF
    IF SUBSTR(cEtilote,1,4)="H1HC" 
       	cArmz:="15"
       	cLotectl:=SUBSTR(cEtilote,1,1)+SUBSTR(cEtilote,5,9)
    ENDIF
    IF SUBSTR(cEtilote,1,4)="H2HC" 
       	cArmz:="16"
       	cLotectl:=SUBSTR(cEtilote,1,1)+SUBSTR(cEtilote,5,9)
    ENDIF
    IF SUBSTR(cEtilote,1,3)="HPT"  
       	cArmz:="15"
       	cLotectl:=SUBSTR(cEtilote,1,1)+SUBSTR(cEtilote,4,9)
	ENDIF
	IF SUBSTR(cEtilote,1,4)="H1MC" 
   		cArmz:="15"
   		cLotectl:=SUBSTR(cEtilote,1,1)+SUBSTR(cEtilote,5,9)
	ENDIF
   	For x:=1 to Len(cLotectl)
	  if substring(cLotectl,x,1)="-"
	    nTraco:=x
	  endif
	next
	nCasas:=LEN(TRIM(substring(cLotectl,ntraco+1,9)))
    if nCasas=1
      cLoteCtl:=substring(cLotectl,1,nTraco)+"00000"+substring(cLotectl,ntraco+1,1)
    endif
    if nCasas=2
      cLoteCtl:=substring(cLotectl,1,nTraco)+"0000"+substring(cLotectl,ntraco+1,2)
    endif 
    if nCasas=3
      cLoteCtl:=substring(cLotectl,1,nTraco)+"000"+substring(cLotectl,ntraco+1,3)
    endif
    if nCasas=4
      cLoteCtl:=substring(cLotectl,1,nTraco)+"00"+substring(cLotectl,ntraco+1,4)
    endif
    if nCasas=5
      cLoteCtl:=substring(cLotectl,1,nTraco)+"0"+substring(cLotectl,ntraco+1,5)
    endif
    
   //	VldProLot(cLotectl)
	
	VtAlert("Almox:" + Alltrim(cArmz) + "  Produto: " + Alltrim(cEtiProd) + "   RI (H)" + Alltrim(cLotectl) + "   Corrida " + Alltrim(clotefor)  + " Gerar Saldo?","A v i s o",.T.) 
	
	If VTLastkey() == 27 
		Loop 
	Else
		VtMsg("Gerando Saldo...")
		CriaSBJSB8()
   		VtAlert("Saldo Gerado.","Aviso",.t.)
	EndIf
				 						
Enddo  
	
Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ VldProLot ³ Autor ³ Luiz Enrique         ³ Data ³ 22/01/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica Fornecedor na SA2            @   			      ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function VldLoja(cFornRi,cLojaRi)   

If Empty(Alltrim(cFornRi))
	Return .F.
Endif
If Empty(Alltrim(cLojaRi))
	Return .F.
Endif  
VtClearBuffer()
DbSelectArea ("SA2")
SA2->(DbSetOrder (1))
if !SA2->(MsSeek (xFilial ("SA2")+cFornRi+cLojaRi))
	VtAlert("Fornecedor Não Encontrado","Atencao",.t.)
	VtClearGet("cFornRi")
	VtGetSetFocus("cFornRi")
	Return .F.
Endif 	
Return .T.  




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ VldProLot ³ Autor ³ Luiz Enrique         ³ Data ³ 22/01/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se Produto ja tem saldo em SB8  			      ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function VldProLot(cEtilote)   

If Empty(Alltrim(cEtilote))
	Return .F.
Endif  
  
VtClearBuffer()
SB8->(dbsetOrder(3)) //Filial+Produto+Armazem+Lote 
 
If SB8->(dbSeek(xFilial('SB8')+cProduto+cArmz+cEtilote))   
	VtAlert("Produto ja com Saldo por Lote.","Atencao",.t.)
	VtClearGet("cEtilote")
	VtGetSetFocus("cEtilote")
	Return .F.
Endif 	

Return .T.  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ VldLotfor³ Autor ³ Luiz Enrique          ³ Data ³ 22/01/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se Coletou Lote e Lote Fornecedor Iguais  	      ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function VldLotfor(clotefor)   

If Empty(Alltrim(clotefor))
	Return .F.
Endif  
  
VtClearBuffer() 
If clotefor == cEtilote  
	VtAlert("Verifique Etiqueta de Lote","Atencao",.t.)  
	VtClearGet("clotefor")
	VtGetSetFocus("clotefor")
	Return .F.
Endif 	

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CriaSBJSB8 ³ Autor ³ Luiz Enrique        ³ Data ³ 06/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gera saldo inicial no SBJ/SB8.							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ HCI                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/  
Static Function CriaSBJSB8() 

Local cNumLote	:=CriaVar("B8_NUMLOTE")                
//Local dDataFec:=GETMV("MV_ULMES")
//Local dDataFec		:=Dtoc(ddatabase)
//Local dDtVldLote	:=Dtoc(ddatabase + 365)  
Local dDataFec		:=ddatabase
Local dDtVldLote	:=ddatabase + 365

Begin Sequence
	
	SBJ->(dbsetOrder(1))
	
	If !SBJ->(dbSeek(xFilial('SBJ')+cProduto+cArmz+Alltrim(cLoteCtl))) //Filial+Produto+Local+Lote
		cNumLote:=NextLote(cProduto,"S")
		RecLock('SBJ',.T.)  
		Replace SBJ->BJ_FILIAL  With xFilial('SBJ')
		Replace SBJ->BJ_COD     With cProduto 	//Produto
		Replace SBJ->BJ_LOCAL   With cArmz	 	//Almoxarifado
		Replace SBJ->BJ_LOTECTL With cLotectl	//Rastreabilidade Interna RI - LOTE
		Replace SBJ->BJ_DTVALID With dDtVldLote	//Data de Validade do lote
		Replace SBJ->BJ_NUMLOTE With cNumLote	
		Replace SBJ->BJ_DATA    With dDataFec	//Data do Saldo - Data da Criacao do lote
        Replace SBJ->BJ_QINI    With SBJ->BJ_QINI + 1	//-- Quantidade inicial do lote
     	Replace SBJ->BJ_QISEGUM With SBJ->BJ_QISEGUM + ConvUm(cProduto,1,0,2)//-- Quantidade inicial 2UM
	    SBJ->(MsUnlock())
   		//Gera SB8
		CriaLote("SBJ",SBJ->BJ_COD,SBJ->BJ_LOCAL,SBJ->BJ_LOTECTL,SBJ->BJ_NUMLOTE,clotefor,cFornRi,cLojaRi,Nil,"MN","","","IMPLAN",;
					"","",SBJ->BJ_QINI,SBJ->BJ_QISEGUM,dDatabase,SBJ->BJ_DTVALID,.T.)
		
	Else
		RecLock('SBJ',.F.)
    	Replace SBJ->BJ_QINI    With SBJ->BJ_QINI + 1	//-- Quantidade inicial do lote
	    Replace SBJ->BJ_QISEGUM With SBJ->BJ_QISEGUM + ConvUm(cProduto,1,0,2)//-- Quantidade inicial 2UM
	    SBJ->(MsUnlock())
	EndIf
	// criando Redistro de Entrada se Não Houver
	SZI->(dbsetOrder(1))
	If !SZI->(dbSeek(xFilial('SZI')+Alltrim(cLoteCtl))) //Lote
		RecLock('SZI',.T.)  
		Replace SZI->ZI_FILIAL  With xFilial('SZI')
		Replace SZI->ZI_RI		With cLotectl
	   	Replace SZI->ZI_COMPRA  With cOc 	//Produto
		Replace SZI->ZI_ITEM    With POSICIONE("SC7",2,XFILIAL("SC7")+cProduto+cFornRi+cLojaRi+cOc,"C7_ITEM") 	//Produto
		Replace SZI->ZI_ALMOX	With cArmz	
		Replace SZI->ZI_RIDENT  With cEtilote 	//Produto
		Replace SZI->ZI_CORRIDA With cLotefor 	//Almoxarifado
		Replace SZI->ZI_COD     With cProduto	//Rastreabilidade Interna RI - LOTE
		Replace SZI->ZI_DESCRI  With POSICIONE("SB1",1,XFILIAL("SB1")+cProduto,"B1_DESC") 	//Produto
		Replace SZI->ZI_QTD     With 1	
		Replace SZI->ZI_DATA    With dDataFec	//Data do Saldo - Data da Criacao do lote
        Replace SZI->ZI_FORNECE With cFornRi	//-- Quantidade inicial do lote
     	Replace SZI->ZI_LOJA    With cLojaRi//-- Quantidade inicial 2UM
	    Replace SZI->ZI_NREDUZ  With POSICIONE("SA2",1,XFILIAL("SA2")+cFornRi+cLojaRi,"A2_NREDUZ") 	//Produto//-- Quantidade inicial 2UM
	    SZI->(MsUnlock())
    endif
End Sequence

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³VldProduto³ Autor ³ Luiz Enrique          ³ Data ³ 13/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Validacao da etiqueta de produto 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ HCI		                                                  ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function VldProduto(cEtiProd)

Local cProdut	:= Space(48) 
Local cEtiqueta
Local aEtiqueta := {}
Local cMsg      := ""
Local aSave 	

DEFAULT cEtiProd:= Space(48)

If Empty(cEtiProd)
	Return .f.
EndIf 

aSave 	:= VTSAVE()

cEtiqueta:= cEtiProd
		
If !CBLoad128(@cEtiqueta)
	cMsg:=""
	Break
EndIf

//Ponto de Entrada CBRETEAN ativo - Retorno: {cEti,0,cLote,0,0,cLoteFor}
aEtiqueta := CBRetEtiEan(cEtiqueta)

If len(aEtiqueta) == 0
	cMsgerro("Etiqueta invalida") 
	VtRestore(,,,,aSave) 
	Return .F.
EndIf 

cProduto	:=	aEtiqueta[1]

//Verifica Cadastro do Produto lido
If !SB1Prod (cProduto)
	cMsgerro("Produto: " + Alltrim(cProduto) + " nao Cadastrado.") 
	VtRestore(,,,,aSave) 
	Return .F.
Endif

/*  Retirado a Pedido do Robson 23/01/2008
If !Rastro(cProduto)
	cMsgerro("Produto nao controla Rastro.") 
	VtRestore(,,,,aSave) 
	Return .F.	
Endif
*/
					
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Vldarm   | Autor ³ Luiz Enrique          ³ Data ³ 22/01/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica esta no escopo de armazens              	      ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function VldArm(cArmz)   

If Empty(Alltrim(cArmz))
	Return .F.
Endif  
  
VtClearBuffer() 


If carmz != "01" .and. carmz != "14" .and. carmz != "15" .and. carmz != "16" .and. carmz != "17" .and. carmz != "18" .and. carmz != "19" .and. carmz != "60" .and. carmz != "90"

	VtAlert("Verifique Etiqueta de Lote","Atencao",.t.)  
	VtClearGet("cArmz")
	VtGetSetFocus("cArmz")
	Return .F.
Endif 	

Return .T.







/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ SB1Prod    ³ Autor ³ Luiz Enrique        ³ Data ³ 23/10/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se Codigo do Produto é valido                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ CodProduto    - COdigo do Produto                          ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function SB1Prod (CodProduto)
           
SB1->(dbsetOrder(1))
If ! SB1->(dbSeek(xFilial()+Trim(CodProduto))) 
   Return .f.
Endif 

Return .t. 

Static Function cMsgerro(cmem)
	VTAlert(cmem,"Atencao",.T.,3000,3)
	VtClearBuffer()
	VtClearGet("cEtiProd")
	VtGetSetFocus("cEtiProd")		
Return 
