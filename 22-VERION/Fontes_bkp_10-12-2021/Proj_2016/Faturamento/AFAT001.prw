#Include "Protheus.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAFAT001   บAutor  ณPaulo Sampaio		 บ Data ณ 08/12/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para registrar os Itens que serao devolvidos da NF.  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณTabelas:												      บฑฑ
ฑฑบ          ณ PA0 - Devolucao Intes NF.							      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SERCON MP8.11.											  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AFAT001()

Local aArea			:= GetArea()
Local oDlg			:= Nil
Local oEncSF2		:= Nil
Local oGetPA0		:= Nil
Local nOpcA			:= 0
Local aObjects  	:= {}                        
Local aInfo 		:= {}	
Local aSize     	:= MsAdvSize( .T. )
Local aPosObj   	:= {} 
Local aPosEnc		:= {}
Local aPosGet 		:= {} 
Local aButtons		:= {}            
Local aPA0Header	:= {}
Local aPA0Cols      := {}
Local bOk 			:= {|| nOpcA:=1, oDlg:End() }
Local bCancel 		:= {|| nOpcA:=0, oDlg:End() }
Local nOpc			:= 3
Local lGravou		:= .F.
Local lEditDev		:= .T.
Local cSavCad		:= IIf( Type("cCadastro")	== "C" 	, cCadastro 		, "" )	
Local oTodos  	, lTodos 	:= .F.
Local oInverte 	, lInverte 	:= .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a entrada de dados do arquivo.                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private aTela[0][0]
Private aGets[0]

INCLUI	:= .T.
ALTERA  := .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe ja existir a Devolucao, o sistema trata como alteracao.  								ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DBSelectArea("PA0")
PA0->(DBSetOrder(1)) // PA0_FILIAL+PA0_DOC+PA0_SERIE+PA0_CODCLI+PA0_LOJA+PA0_ITEM
//If	PA0->( MsSeek( xFilial("PA0")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA) ) )
If	PA0->( MsSeek( xFilial("PA0")+SC5->(C5_NOTA+C5_SERIE+C5_CLIENTE+C5_LOJACLI)))
	If	nOpc <> 2
		nOpc := 4
		INCLUI	:= .F.
		ALTERA  := .T.
	Else
		INCLUI	:= .F.
		ALTERA  := .F.
	EndIf
Else
	If	nOpc == 2
		MsgInfo("Nใo existe registro de devolu็ใo para a Nota ["+SC5->(C5_NOTA+C5_SERIE)+"].","Devolu็ใo Itens da Nota")
		Return()
	EndIf
EndIf
                          
cCadastro := "Devolu็ใo Itens Nota Fiscal - "+IIf(nOpc==3,"Inclusใo",(IIf(nOpc==4,"Altera็ใo","Vizualiza็ใo") ))

//ฺฤฤฤฤฤฤฤฟ
//ณBotoes.ณ
//ภฤฤฤฤฤฤฤู
aAdd(aButtons,{"S4WB011N",{|| GdSeek(oGetPA0,"Pesquisar",,,.F.)},"Pesquisar","Pesquisar"})

If FindFunction("RemoteType") .And. RemoteType() == 1
	aAdd(aButtons   , {PmsBExcel()[1],{|| DlgToExcel({ {"ENCHOICE","Cabe็alho",aGets,aTela},{"GETDADOS",OemToAnsi("Itens"),oGetPA0:aHeader,oGetPA0:aCols}})},PmsBExcel()[2],PmsBExcel()[3]})
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPosiciona no Cliente para Funcionar a Posicao do Cliente.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DBSelectArea("SA1")
SA1->(DBSetOrder(1)) // A1_FILIAL+A1_COD+A1_LOJA
SA1->( MsSeek( xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI)))
aAdd(aButtons,{"POSCLI"  ,{|| IIf(!Empty(M->C5_CLIENTE),a450F4Con(),.F.),Pergunte("MTA410",.F.)},"Posi็ใo do Cliente","Cliente" })

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMontagem do aHeader e aCols dos Acessorios da Ficha.		ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
fIntGet("PA0",@aPA0Header,@aPA0Cols,"PA0_FILIAL+PA0_DOC+PA0_SERIE+PA0_CODCLI+PA0_LOJA",xFilial("PA0")+SC5->(C5_NOTA+C5_SERIE+C5_CLIENTE+C5_LOJACLI),nOpc==3,"","PA0_FILIALณPA0_DOCณPA0_SERIEณPA0_CODCLIณPA0_LOJA","")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Faz o calculo automatico de dimensoes de objetos     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
AAdd( aObjects, { 100, 060, .T., .F. } )
AAdd( aObjects, { 100, 100, .T., .T. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

aPosEnc	:= { aPosObj[1,1] , aPosObj[1,2] , aPosObj[1,3] , aPosObj[1,4] }
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}} )

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 000,000 To aSize[6],aSize[5] OF oMainWnd PIXEL

@aPosObj[1,1],aPosObj[1,2] To aPosObj[1,3],aPosObj[1,4] LABEL "Dados do Cliente" OF oDlg PIXEL         
                         
DBSELECTAREA("SF2")
DBSETORDER(1)
DBSEEK(xFilial("SF2")+SC5->(C5_NOTA+C5_SERIE+C5_CLIENTE+C5_LOJACLI))
RegToMemory("SF2",.F.)

oEncSF2 := MsMGet():New("SF2",SF2->(Recno()),2,,,,,aPosEnc,,,,,,oDlg,,.T.,,,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAcessorios.		  		  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@aPosObj[2,1],aPosObj[2,2] To aPosObj[2,3],aPosObj[2,4] LABEL "Itens da Nota" OF oDlg PIXEL         

oGetPA0	:= MsNewGetDados():New(aPosObj[2,1]+7,aPosObj[2,2]+5,aPosObj[2,3]-20,aPosObj[2,4]-5,IIf( lEditDev , GD_UPDATE, 0),/*linok*/,/*tudok*/,/*cInitCpo*/,/*cCpoAlt*/,/*freeze*/,100,/*fieldok*/,/*superdel*/,/*delok*/,oDlg,aPA0Header,aPA0Cols)
oGetPA0:AddAction("MARCA",{|| IIf( lEditDev , fMarkGet(M->MARCA) , Nil ) })

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณControle de Marcacao.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@ aPosObj[2,3]-15,010 CheckBox oTodos 	Var lTodos 		Size 090,9 Pixel Of oDlg Prompt "Marca e Desmarca Todos" 	On Change fSelMark(1, @oGetPA0, lTodos)  When lEditDev
@ aPosObj[2,3]-15,100 CheckBox oInverte Var lInverte 	Size 090,9 Pixel Of oDlg Prompt "Inverte e Retorna Sele็ใo" On Change fSelMark(2, @oGetPA0, lInverte)When lEditDev


oDlg:lMaximized := .T.

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg , bOk , bCancel , , aButtons )

If ( nOpcA == 1 )

	Begin Transaction
		lGravou := fGravaDv( nOpc - 2  , oGetPA0 )
		If lGravou
			EvalTrigger()
		EndIf
	End Transaction

EndIf
      
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRestaura a Integridade dos Dados                                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cCadastro	:= cSavCad
RestArea(aArea)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณfIntGet   บAutor  ณPaulo Sampaio       บ Data ณ 08/12/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta o aHeader e aCols.                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณcAliasH    : Alias da tabela trabalhada.                    บฑฑ
ฑฑบ          ณaHeaderAux : Cabecalho do Get.                              บฑฑ
ฑฑบ          ณaColsAux   : Colunas do Get.                                บฑฑ
ฑฑบ          ณcCamChave  : Campos Chaves da tabela. Deve ser Concatenado. บฑฑ
ฑฑบ          ณcChave     : Chave que deve ser comparada a cCamChave.      บฑฑ
ฑฑบ          ณlInclui    : Indica se e uma inclusao ou nao.               บฑฑ
ฑฑบ          ณcCpoIncre  : Campo que deve ser auto incrementado.          บฑฑ
ฑฑบ          ณcOculta    : Campos que nao devem aparecer no cabecalho.    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SERCON MP8.11.											  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fIntGet(cAliasAux,aHeaderAux,aColsAux,cCamChave,cChave,lInclui,cCpoIncre,cOculta,cCpoCols)
          
Local	nUsado 		:= 0
Local 	nX			:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o aHeader.                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aHeaderAux := {}
aColsAux   := {}

DBSelectArea("SX3")
SX3->(DBSetOrder(1))
SX3->(DBSeek(cAliasAux,.T.))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณQuando monto os Acessorios da Ficha tenho que adicionar um campo para marcacao.	ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If	cAliasAux == "PA0"
	aAdd(aHeaderAux,{" ","MARCA","@BMP",2,0,,,"C",,"V",,"LBTIK",".T."})
EndIf

While (  SX3->(!Eof()) .And. SX3->X3_ARQUIVO == cAliasAux )
	
	If 	X3USO(SX3->X3_USADO) 		.And. cNivel >= SX3->X3_NIVEL		.And. ;
		IIf( !Empty(cOculta)  , !(AllTrim(SX3->X3_CAMPO)	$ cOculta) , .T. ) .And. ;
		IIf( !Empty(cCpoCols) , AllTrim(SX3->X3_CAMPO)	$ cCpoCols , .T. )
		
		 aAdd(aHeaderAux,{ 	AllTrim(X3Titulo()),;
							SX3->X3_CAMPO,;
							SX3->X3_PICTURE,;
							SX3->X3_TAMANHO,;
							SX3->X3_DECIMAL,;
							SX3->X3_VALID,;
							SX3->X3_USADO,;
							SX3->X3_TIPO,;
							SX3->X3_F3,;
							SX3->X3_CONTEXT } )
	EndIf              
	
SX3->(DBSkip())
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o aCols.                                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nUsado := Len(aHeaderAux)

If !lInclui // Visualizacao, edicao ou exclusao.
                                                                        
   aColsAux := {}
      
   DBSelectArea(cAliasAux)
   DBSetOrder(1)
   DBSeek(cChave)

   While !Eof() .And. &cCamChave==cChave

   	    aADD(aColsAux, Array(nUsado+1))
   	    
   	    For nX := 1 To nUsado
   	    	If 		(aHeaderAux[nX,2] == "MARCA") 
   	    			aColsAux[Len(aColsAux)][nX] := IIf(PA0->PA0_QTDDEV > 0 , "LBTIK" , "LBNO" ) 
   	    	ElseIf (aHeaderAux[nX,10] != "V")
   	    			aColsAux[Len(aColsAux)][nX] := FieldGet(FieldPos(aHeaderAux[nX,2]))
   	    	Else
   	    			aColsAux[Len(aColsAux)][nX] := CriaVar(aHeaderAux[nX,2],.T.)
   	    	EndIf
   	    Next

   	    aColsAux[Len(aColsAux)][nUsado+1] := .F.

	DBSelectArea(cAliasAux)
 	DBSkip()
   	EndDo
EndIf

If 	Empty(aColsAux)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSe for inclusao, alimenta a PA0 com os itens da Nota.				ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If	cAliasAux == "PA0"
	
		DBSelectArea("SD2")
		SD2->(DBSetOrder(3)) // D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
		SD2->(DBSeek(cChave))
		While	!SD2->(Eof()) .And.	SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == cChave

				aAdd(aColsAux, Array(nUsado+1))
				
				For nX := 1 To nUsado
					If 	AllTrim(aHeaderAux[nX,2]) == "MARCA"
					    aColsAux[Len(aColsAux)][nX]:= "LBNO"
					ElseIf AllTrim(aHeaderAux[nX,2]) == "PA0_ITEM"
					    aColsAux[Len(aColsAux)][nX]:= SD2->D2_ITEM
					ElseIf AllTrim(aHeaderAux[nX,2]) == "PA0_CODPRO"
					    aColsAux[Len(aColsAux)][nX]:= SD2->D2_COD
					ElseIf AllTrim(aHeaderAux[nX,2]) == "PA0_DESPRO"
					    aColsAux[Len(aColsAux)][nX]:= Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_DESC")
					ElseIf AllTrim(aHeaderAux[nX,2]) == "PA0_UM"
					    aColsAux[Len(aColsAux)][nX]:= SD2->D2_UM
					ElseIf AllTrim(aHeaderAux[nX,2]) == "PA0_QTDNF"
					    aColsAux[Len(aColsAux)][nX]:= SD2->D2_QUANT
					Else
						aColsAux[Len(aColsAux)][nX]:= CriaVar(aHeaderAux[nX,2],.T.)
					EndIf
				Next nX
				aColsAux[Len(aColsAux)][nUsado+1] := .F.  // Campo D_E_L_E_T_
			
		SD2->(DBSkip())
		EndDo
            
	Else
    	aAdd(aColsAux, Array(nUsado+1))
    	
		For nX := 1 To nUsado
			If AllTrim(aHeaderAux[nX,2]) == cCpoIncre
			    aColsAux[Len(aColsAux)][nX]:= StrZero(1,aHeaderAux[nX,4])
			Else
				aColsAux[Len(aColsAux)][nX]:= CriaVar(aHeaderAux[nX,2],.T.)
			EndIf
		Next nX
		aColsAux[Len(aColsAux)][nUsado+1] := .F.  // Campo D_E_L_E_T_
	
	EndIf
	
EndIf

Return()
                  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณfMarkGet  บAutor  ณPaulo Sampaio       บ Data ณ 08/12/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMarca/Desmarca um Item dos Acessorios.					  บฑฑ
ฑฑบ          ณ														      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SERCON MP8.11.											  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fMarkGet( cMarca )

Local uRetorno	:= IIf( AllTrim( cMarca ) == "LBNO", M->MARCA := "LBTIK", M->MARCA := "LBNO" ) //A variavel uRetorno determina se o campo sera ou nao desmarcado.
Local nPosQtdNF	:= aScan( aHeader , {|x| AllTrim(x[02]) == "PA0_QTDNF"})
Local nPosQtdDv	:= aScan( aHeader , {|x| AllTrim(x[02]) == "PA0_QTDDEV"})

If	AllTrim(M->MARCA) <> "LBTIK"
	aCols[n][nPosQtdDv] := 0
Else
	aCols[n][nPosQtdDv] := aCols[n][nPosQtdNF]
EndIf

Return( uRetorno )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณfSelMark  บAutor  ณPaulo Sampaio		 บ Data ณ 08/12/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMarca/Inverte Itens da Nota Fiscal.						  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SERCON MP8.11.											  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fSelMark( nTipo, oGetPA0, lCheck)

Local nI		:= 0		// Variavel de Controle
Local nPosQtdNF	:= aScan( oGetPA0:aHeader , {|x| AllTrim(x[02]) == "PA0_QTDNF"})
Local nPosQtdDv	:= aScan( oGetPA0:aHeader , {|x| AllTrim(x[02]) == "PA0_QTDDEV"})

If nTipo == 1
	If lCheck
		For nI := 1 To Len(oGetPA0:aCols)
			oGetPA0:aCols[nI][1] := "LBTIK"
			oGetPA0:aCols[nI][nPosQtdDv] := oGetPA0:aCols[nI][nPosQtdNF]
		Next nI
	Else
		For nI := 1 To Len(oGetPA0:aCols)
			oGetPA0:aCols[nI][1] := "LBNO"
			oGetPA0:aCols[nI][nPosQtdDv] := 0
		Next nI
	Endif
Else
	For nI := 1 To Len(oGetPA0:aCols)
		If 	oGetPA0:aCols[nI][1] == "LBTIK"
			oGetPA0:aCols[nI][1] := "LBNO"
			oGetPA0:aCols[nI][nPosQtdDv] := 0
		Else
			oGetPA0:aCols[nI][1] := "LBTIK"
			oGetPA0:aCols[nI][nPosQtdDv] := oGetPA0:aCols[nI][nPosQtdNF]
		EndIf
	Next nI
EndIf

oGetPA0:Refresh()

Return(.T.)
                
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณfGravaDv  บAutor  ณPaulo Sampaio       บ Data ณ 08/12/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGrava a Ficha de Ativacao.								  บฑฑ
ฑฑบ          ณ														      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SERCON MP8.11.											  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGravaDv( nOpcGrv , oGetPA0 )

Local aArea     := GetArea()
Local aRegNo    := {}
Local lGravou   := .F.
Local lTravou   := .T.
Local nX        := 0
Local nY        := 0                   
Local nUsadoAux	:= 0
Local bCampo 	:= {|nCpo| Field(nCpo) }
Local nPosPro	:= 0
 
Do	Case

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInclusao ou Alteracao.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Case nOpcGrv <> 3

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณItens Devolucao (PA0).	 ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		aRegNo 		:= {}
		nUsadoAux	:= Len(oGetPA0:aHeader)
		nPosPro		:= aScan( oGetPA0:aHeader , {|x| AllTrim(x[02]) == "PA0_CODPRO"})

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณGuarda os registros para reaproveita-los                      ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		DBSelectArea("PA0")
		PA0->(DBSetOrder(1)) // PA0_FILIAL+PA0_DOC+PA0_SERIE+PA0_CODCLI+PA0_LOJA+PA0_ITEM
//		PA0->(MsSeek(xFilial("PA0")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
		PA0->(MsSeek(xFilial("PA0")+SC5->(C5_NOTA+C5_SERIE+C5_CLIENTE+C5_LOJACLI)))
//				PA0->(PA0_FILIAL+PA0_DOC+PA0_SERIE+PA0_CODCLI+PA0_LOJA) ==  xFilial("PA0")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA) )
		While ( PA0->(!Eof()) .And. ;
				PA0->(PA0_FILIAL+PA0_DOC+PA0_SERIE+PA0_CODCLI+PA0_LOJA) ==  xFilial("PA0")+SC5->(C5_NOTA+C5_SERIE+C5_CLIENTE+C5_LOJACLI))
			aAdd(aRegNo,PA0->(RecNo()))
		PA0->(DBSkip())
		EndDo
		
		For nX := 1 To Len(oGetPA0:aCols)

			lTravou := .F.

			If nX <= Len(aRegNo)
				DBSelectArea("PA0")
				PA0->(DBGoto(aRegNo[nX]))
				PA0->(RecLock("PA0"))
				lTravou := .T.
			EndIf
			If ( !oGetPA0:aCols[nX][nUsadoAux+1] ) .And. !Empty(oGetPA0:aCols[nX][nPosPro])
				If !lTravou
					PA0->(RecLock("PA0",.T.))
				EndIf
				For nY := 1 to Len(oGetPA0:aHeader)
					If oGetPA0:aHeader[nY][10] <> "V"
						PA0->(FieldPut(FieldPos(oGetPA0:aHeader[nY][2]),oGetPA0:aCols[nX][nY]))
					EndIf
				Next nY
				// Campos chaves com valores pre-definidos.
				PA0->PA0_FILIAL	:= xFilial("PA0")
				PA0->PA0_DOC   	:= SC5->C5_NOTA
				PA0->PA0_SERIE 	:= SC5->C5_SERIE
				PA0->PA0_CODCLI := SC5->C5_CLIENTE
				PA0->PA0_LOJA	:= SC5->C5_LOJACLI
				PA0->(MsUnLock())
				lGravou := .T.
			Else
				If lTravou
					PA0->(DBDelete()) 
				EndIf
			EndIf
			PA0->(MsUnLock())
		
			Next nX
		
EndCase

Return(lGravou)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณAFAT01VL  บAutor  ณPaulo Sampaio       บ Data ณ 08/12/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValidacao dos campos da Devolucao dos Itens da NF.		  บฑฑ
ฑฑบ          ณ														      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SERCON MP8.11.											  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AFAT01VL()

Local lRet := .T.
Local nPosMark		:= aScan( aHeader , {|x| AllTrim(x[02]) == "MARCA"})
Local nPosQuantNF	:= aScan( aHeader , {|x| AllTrim(x[02]) == "PA0_QTDNF"})

If	AllTrim(ReadVar()) == "M->PA0_QTDDEV"       
	If	M->PA0_QTDDEV <= 0                                            
		aCols[n][nPosMark] := "LBNO"
	Else 
		If	M->PA0_QTDDEV > aCols[n][nPosQuantNF]
			MsgAlert("A quantidade devolvida nใo pode ser maior que a quantidade da nota.","Devolu็ใo Itens NF")
			Return(.F.)
		Else		
			aCols[n][nPosMark] := "LBTIK"
		EndIf
	EndIf
EndIf

Return(lRet)