#Include "Protheus.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFAT001   บAutor  ณPaulo Sampaio		 บ Data ณ 08/12/2007  บฑฑ
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
User Function CFAT001()

Local aArea			:= GetArea()
Local oDlg			:= Nil
Local oGetSD2		:= Nil
Local oGetSE1		:= Nil
Local oFolder		:= Nil
Local aPages		:= {"HEADER"}
Local aTitles		:= {"Itens Nota","Contas a Receber"}
Local nOpc			:= 2
Local aObjects  	:= {}                        
Local aInfo 		:= {}	
Local aSize     	:= MsAdvSize( .F. )
Local aPosObj   	:= {} 
Local aPosGet 		:= {} 
Local aSD2Header	:= {}
Local aSD2Cols      := {}
Local aSE1Header	:= {}
Local aSE1Cols      := {}
Local nTamAux 		:= 0
Local bViewEnt 		:= { |x| IIf( oFolder:nOption == 1 , fViewEnt("SD2",oGetSD2) , fViewEnt("SE1",oGetSE1) ) }
Local cSavCad		:= IIf( Type("cCadastro")	== "C" 	, cCadastro , "" )	
Local aSavAhead		:= IIf(	Type("aHeader")		== "A"	, aClone(aHeader) , {} )
Local aSavAcol 		:= IIf(	Type("aCols")		== "A"	, aClone(aCols) ,{} )
Local nSavN    		:= IIf(	Type("n") 			== "N"	, n , 0 )
Local lOldInc		:= IIf(	Type("INCLUI")		== "L"	, INCLUI , .F. )
Local lOldAlt		:= IIf(	Type("ALTERA")		== "L"	, ALTERA , .F. )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณChama a Funcao que define cor na Leganda para ver se o Pedido possui Devolucao.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If	!U_ACORDFDE()
	MsgInfo("Esse pedido nใo possui devolu็ใo.","Devolu็ใo")
	Return()
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMontagem do aHeader e aCols dos Acessorios da Ficha.		ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
fIntGet("SD2",@aSD2Header,@aSD2Cols,"D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA"  ,xFilial("SD2")+SC5->(C5_NOTA+C5_SERIE+C5_CLIENTE+C5_LOJACLI),3,nOpc==3,"","","")
fIntGet("SE1",@aSE1Header,@aSE1Cols,"E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM",xFilial("SE1")+SC5->(C5_CLIENTE+C5_LOJACLI+C5_SERIE+C5_NOTA),2,nOpc==3,"","","")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Faz o calculo automatico de dimensoes de objetos     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
AAdd( aObjects, { 100, 100, .T., .T. } )
AAdd( aObjects, { 100, 020, .T., .F. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 0, 0 }
aPosObj := MsObjSize( aInfo, aObjects )

aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}} )

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 000,000 To aSize[6],aSize[5] OF oMainWnd PIXEL

@aPosObj[1,1],aPosObj[1,2] To aPosObj[1,3],aPosObj[1,4] LABEL "Dados do Cliente" OF oDlg PIXEL         

oFolder := TFolder():New(aPosObj[1,1],aPosObj[1,2],aTitles,aPages,oDlg,,,, .T., .F.,aPosObj[1,4]-aPosObj[1,2],aPosObj[1,3]-aPosObj[1,1],)
                         
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGetDados com Itens da NF.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oGetSD2	:= MsNewGetDados():New(2,2,aPosObj[1,3]-aPosObj[1,1]-15,aPosObj[1,4]-aPosObj[1,2]-5,0,/*linok*/,/*tudok*/,/*cInitCpo*/,/*cCpoAlt*/,/*freeze*/,100,/*fieldok*/,/*superdel*/,/*delok*/,oFolder:aDialogs[1],aSD2Header,aSD2Cols)
oGetSD2:oBrowse:bLDblClick := { || Eval(bViewEnt) }

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGetDados com Titulos a Receber.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oGetSE1	:= MsNewGetDados():New(2,2,aPosObj[1,3]-aPosObj[1,1]-15,aPosObj[1,4]-aPosObj[1,2]-5,0,/*linok*/,/*tudok*/,/*cInitCpo*/,/*cCpoAlt*/,/*freeze*/,100,/*fieldok*/,/*superdel*/,/*delok*/,oFolder:aDialogs[2],aSE1Header,aSE1Cols)
oGetSE1:oBrowse:bLDblClick := { || Eval(bViewEnt) }

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณLabel com os Botoes.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@aPosObj[2][1],aPosObj[2][2] To aPosObj[2][3],aPosObj[2][4] LABEL "" OF oDlg PIXEL

//ฺฤฤฤฤฤฤฤฟ
//ณBotoes.ณ
//ภฤฤฤฤฤฤฤู
nTamAux := 50
@aPosObj[2][1]+04 ,aPosObj[2][4] - nTamAux BUTTON "Sair"			SIZE 40,12 OF oDlg PIXEL ACTION oDlg:End() ; nTamAux += 50
@aPosObj[2][1]+04 ,aPosObj[2][4] - nTamAux BUTTON "Exp. Excel"		SIZE 40,12 OF oDlg PIXEL ACTION DlgToExcel({{"GETDADOS","Itens da Nota",oGetSD2:aHeader,oGetSD2:aCols} , {"GETDADOS","Contas a Receber",oGetSE1:aHeader,oGetSE1:aCols}}) ; nTamAux += 50
@aPosObj[2][1]+04 ,aPosObj[2][4] - nTamAux BUTTON "Visualizar"		SIZE 40,12 OF oDlg PIXEL ACTION Eval(bViewEnt) ;nTamAux += 50

oDlg:lMaximized := .T.

ACTIVATE MSDIALOG oDlg CENTERED
     
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRestaura a Integridade dos Dados                                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aHeader 	:= aClone(aSavAHead)
aCols   	:= aClone(aSavACol)
n       	:= nSavN
cCadastro	:= cSavCad
INCLUI		:= lOldInc
ALTERA		:= lOldAlt

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
Static Function fIntGet(cAliasAux,aHeaderAux,aColsAux,cCamChave,cChave,nOrderSix,lInclui,cCpoIncre,cOculta,cCpoCols)
           
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

While (  SX3->(!Eof()) .And. SX3->X3_ARQUIVO == cAliasAux )
	
	If 	X3USO(SX3->X3_USADO) 		.And. ;
		cNivel >= SX3->X3_NIVEL		//.And. ;
		//SX3->X3_BROWSE == "S"		
		
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

aAdd(aHeaderAux,{"Registro","XX_RECNO","",12,2,,,"N",,"V"})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o aCols.                                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

nUsado := Len(aHeaderAux)

If !lInclui // Visualizacao, edicao ou exclusao.
   
   aColsAux := {}
      
   DBSelectArea(cAliasAux)
   DBSetOrder(nOrderSix)
   DBSeek(cChave)

   While !Eof() .And. &cCamChave==cChave

   	    aADD(aColsAux, Array(nUsado+1))
   	    
   	    For nX := 1 To nUsado
			If 		AllTrim(aHeaderAux[nX,2]) == "XX_RECNO"
					aColsAux[Len(aColsAux)][nX] := Recno()
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

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณfViewEnt  บAutor  ณPaulo Sampaio       บ Data ณ 08/12/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณChama a rotina de visualizacao da Entidade passada como	  บฑฑ
ฑฑบ          ณparametro.					                              บฑฑ
ฑฑบ          ณPara funcionar o aHeader do obsejo precisa ter um campo	  บฑฑ
ฑฑบ          ณXX_RECNO armazenando o Recno da Entidade.                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SERCON MP8.11.											  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fViewEnt( cAliasEnt , oGetEnt )

Local nRegEnt	:= oGetEnt:aCols[oGetEnt:oBrowse:nAt][ aScan( oGetEnt:aHeader, { |x| AllTrim(x[02]) == "XX_RECNO" } ) ]
Local aArea		:= GetArea()

DBSelectArea(cAliasEnt)
MsGoTo(nRegEnt)
AxVisual(cAliasEnt,nRegEnt,2)

RestArea(aArea)

Return()