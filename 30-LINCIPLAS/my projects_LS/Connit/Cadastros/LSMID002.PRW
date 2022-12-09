#Include "Protheus.ch"	
#Include "rwmake.ch"	

/*
+=========================================================+
|Programa: LSMID002 |Autor: Antonio Carlos |Data: 15/03/11|
+=========================================================+
|Descrição: Cadastro de Espaços/Midia                     |
+=========================================================+
|Uso: Especifico Laselva                                  |
+=========================================================+
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LSMID002()
////////////////////////

Local aArea  	:= GetArea()
Local cAlias  	:= "PAB"
Local aCores  	:= {}

Private aLegenda := {;
{'BR_VERDE'		,'Disponivel', },;
{'BR_VERMELHO'	,'Ocupado'	 , }}

Aadd(aCores,{ "Empty(PAB_NUM) " , 'BR_VERDE'	}) // Processando
Aadd(aCores,{ "!Empty(PAB_NUM)" , 'BR_VERMELHO'	}) // Encerrado

Private aRotina    := {}
Private cCadastro  := "Cadastro de Espacos"

Aadd(aRotina,{"Pesquisar" 			,"AxPesqui"	   		,0,1 })
Aadd(aRotina,{"Visualizar"  		,"U_LsMid02" 		,0,2 })
Aadd(aRotina,{"Incluir"  			,"U_LsMid02"		,0,3 })
Aadd(aRotina,{"Alterar"  			,"U_LsMid02" 		,0,4 })
Aadd(aRotina,{"Excluir"  			,"U_LsMid02" 		,0,5 })
Aadd(aRotina,{"Mapa da Loja"		,"U_LsMidMap('B')"	,0,4, 0, nil})
Aadd(aRotina,{"Legenda"  			,"U_LsMidLe"		,0,6 })

mBrowse( 7, 4,20,74,cAlias,,,,,,aCores)

//Restaura a integridade da rotina
DbSelectArea(cAlias)
RestArea(aArea)               

Return          

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LsMid02(cAlias,nReg,nOpc)
///////////////////////////////////////

Local aArea	   	:= GetArea()
Local cAlias   	:= Alias()
Local nStyle   	:= 0
Local oEnchoice
Local aButtons := { {"S4WB011N"	, {||LsMidI()	},"Mapa"}, {"OBJETIVO"	, {||U_LsMidLe()	},"Legenda"}, {"EDITABLE"	, {||VisuCtr()	},"Contrato"} }
Local aPosObj  := {}
Local aObjects := {}
Local aSize    := {}
Local aPosGet  := {}
Local aInfo    := {}

Private nOpca	 	:= nOpc
Private aHeader   	:= {}
Private aCols     	:= {}
Private oDlg
Private oGetDados
Private aTela[0][0]
Private aGets[0]

Private oLoja
Private _cLoja := Space(2)
Private oDesc
Private _cDesc := Space(150)
Private oImage
Private _cImage := Space(8)
Private oImage
Private _dPrazo := ctod('')

aSize	:= MsAdvSize(,.F.,400)
		
aObjects := {}

AAdd( aObjects, { 0,    90, .T., .F. } )
AAdd( aObjects, { 100, 100, .T., .T. } )
AAdd( aObjects, { 0,    50, .T., .F. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

RegToMemory(cAlias,IIF(nOpc==3,.T.,.F.))

If nOpc <> 3
	Aadd( aHeader, { '', 'CHECKBOL', '@BMP', 10, 0,,, 'C',, 'V' ,  ,  , 'BR_VERDE', 'V', 'S' } )
EndIf	

DbSelectArea("SX3")
SX3->( DbSetorder(1) )
MsSeek("PAB")                         
While SX3->( !Eof() ) .And. (X3_ARQUIVO == "PAB")
	
	If Alltrim(X3_CAMPO) $ "PAB_CODESP/PAB_DESCR/PAB_MEDIDA/PAB_NUM"
		
		If X3Uso(X3_USADO) .And. (cNivel >= X3_NIVEL)
			Aadd(aHeader,{Alltrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,;
			SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO,".T."})
		EndIf
	
	EndIf	
	
	SX3->( DbSkip() )
	
EndDo

If nOpca <> 3
	_cLoja	:= M->PAB_CODFIL
	_cDesc	:= Posicione("SM0",1,cEmpAnt+_cLoja,"M0_FILIAL")
	_cImage	:= M->PAB_IMAGEM            
	_dPrazo := M->PAB_DTLOJA
EndIf
	
DbSelectArea("PAB")
PAB->( DbSetorder(1) )
PAB->( DbSeek( xFilial("PAB")+M->PAB_CODFIL ) )
While PAB->( !Eof() ) .And. ( PAB->PAB_CODFIL == M->PAB_CODFIL )
	
	Aadd( aCols,Array(Len(aHeader)+1) )
	
	For nY	:= 1 To Len(aHeader)
		If aHeader[nY,2] == "CHECKBOL"
			If Empty(PAB->PAB_NUM)
				aCols[Len(aCols)][nY] := "BR_VERDE"
			Else
				aCols[Len(aCols)][nY] := "BR_VERMELHO"
			EndIf	
		ElseIf ( aHeader[nY][10] != "V" )
			aCols[Len(aCols)][nY] := FieldGet(FieldPos(aHeader[nY][2]))
		Else
			aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2])
		EndIf
	Next nY
	
	aCols[Len(aCols)][Len(aHeader)+1] := .F.
	
	PAB->( DbSkip() )
	
EndDo

If Len(aCols) == 0
	aCols := {}
	Aadd(aCols,Array(Len(aHeader)+1))
	For nY := 1 To Len(aHeader)
		aCols[Len(aCols),nY] := CriaVar(aHeader[nY][2])
	Next nY
	aCols[Len(aCols),Len(aHeader)+1] := .F.
EndIf 

Do Case
	Case nOpc == 3
		nStyle := GD_INSERT+GD_UPDATE+GD_DELETE
	Case nOpc == 4
		nStyle := GD_INSERT+GD_UPDATE+GD_DELETE
	OtherWise
		nStyle := 0
EndCase   

DEFINE MSDIALOG oDlg FROM 0,0 TO aSize[6],aSize[5] TITLE cCadastro Of oMainWnd PIXEL

DEFINE FONT oFontBold   NAME 'Times New Roman' SIZE 12, 14 Bold

oPanel:= TPanel():New(0, 0, "", oDlg, NIL, .T., .F., NIL, NIL, 0,095, .T., .F. )
oPanel:Align:=CONTROL_ALIGN_TOP

@ 010,010 SAY "Loja: " PIXEL OF oPanel
@ 020,010 MSGET oLoja VAR _cLoja SIZE 30,10 F3 "SM0EMP"  when inclui VALID ( PsqLoja() ) PIXEL OF oPanel

@ 010,060 SAY "Nome: " PIXEL OF oPanel
@ 020,060 MSGET oDesc VAR _cDesc SIZE 150,10 WHEN .F. PIXEL OF oPanel

@ 010,220 SAY "Vencimento contrato Loja: " PIXEL OF oPanel
@ 020,220 MSGET oPrazo VAR _dPrazo SIZE 50,10 PIXEL OF oPanel

@ 050,010 SAY "Imagem: " PIXEL OF oPanel
@ 060,010 MSGET oImage VAR _cImage SIZE 50,10 PIXEL OF oPanel

//oGetDados:= MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nStyle,,"AllWaysTrue",,,,9999,,,"U_LsMiLOk",oDlg,aHeader,aCols)
oGetDados:= MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"U_LsMiLOk",,,.T.,,,,,,,,,oDlg)

ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{|| GrvDados(@nOpc) },{||oDlg:End()},,aButtons))

RestArea(aArea)

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function PsqLoja()
/////////////////////////

_cDesc := Posicione("SM0",1,cEmpAnt+_cLoja,"M0_FILIAL")

If Empty(_cDesc)
	_cLoja := Space(2)
	oLoja:Refresh()
	oLoja:SetFocus()
EndIf

DbSelectArea("PAB")
PAB->( DbSetOrder(1) )
If PAB->( DbSeek( xFilial("PAB")+_cLoja ) )
	MsgStop("Loja já cadastrada!")
	_cLoja := Space(2)
	oLoja:Refresh()
	oLoja:SetFocus()	
EndIf

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LsMidI()
////////////////////////

Local oDlgI
Local oBmpRes, oBmpVis

If Empty(_cImage)

	MsgInfo("Não há imagem para exibir.", "Sem Imagem")

Else
				
	@ 000, 000 REPOSITORY oBmpRes SIZE 200, 200 OF oMainWnd PIXEL NOBORDER
	oBmpRes:LoadBmp(_cImage)
	oBmpRes:lAutoSize := .T.
                
	DEFINE MSDIALOG oDlgI FROM 000, 000 TO   oBmpRes:nClientHeight, oBmpRes:nClientWidth PIXEL;
    TITLE "Visualizador de Imagem" OF oMainWnd
                
	@ 001, 001 REPOSITORY oBmpVis SIZE oBmpRes:nClientHeight, oBmpRes:nClientWidth OF oDlgI PIXEL
	oBmpVis:LoadBmp(_cImage)
	oBmpVis:lAutoSize := .T.
                
	ACTIVATE MSDIALOG oDlgI CENTERED
	
EndIf

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GrvDados(nOpc)
//////////////////////////////

Local nPosEsp	:= aScan(aHeader,{|x| AllTrim(x[2])=="PAB_CODESP"})
Local nPosDes	:= aScan(aHeader,{|x| AllTrim(x[2])=="PAB_DESCR"})
Local nPosMed	:= aScan(aHeader,{|x| AllTrim(x[2])=="PAB_MEDIDA"})

If Empty(_cLoja) .Or. !oGetDados:TudoOk()
	MsgStop("Preencha os campos corretamente!")
	Return(.F.)
EndIf	

If nOpc == 3 .Or. nOpc == 4 .Or. nOpc == 5 

	If nOpc == 5
		MsgStop("Opcao indisponivel!")
		Return(.F.)
	EndIf	
	
	Begin Transaction
	
	If nOpc == 5
	
		//Quando exclusao.                                      
		/*
		DbSelectArea("SZU")
		SZU->( DbSetOrder(1) )
		SZU->( DbSeek( xFilial("SZU")+M->PAC_NUM ) )
		While SZU->( !Eof() ) .And. SZU->ZU_FILIAL+SZU->ZU_NUM == xFilial("SZU")+M->PAC_NUM
		
			RecLock("SZU",.F.)
			SZU->( DbDelete() )
			SZU->( MsUnLock() )
			
			SZU->( DbSkip() )
			
		EndDo	
	    */
	Else
		//Quando Inclusao/Alteracao.                           		
		DbSelectArea("PAB")
		PAB->( DbSetOrder(1) )
		For nX := 1 To Len(aCols)
			
			lAchou := PAB->( DbSeek( xFilial("PAB")+_cLoja+aCols[nX,nPosEsp]) )
			
			If aCols[nX,Len(aHeader)+1]
				
				If lAchou   
				
					RecLock("PAB",.F.)
					PAB->( DbDelete() )
					PAB->( MsUnLock() )
				
				EndIf
				
			Else
				
				If lAchou
					RecLock("PAB",.F.)
				Else
					RecLock("PAB",.T.)
				EndIf
								
				PAB->PAB_FILIAL	:= xFilial("PAB")
				PAB->PAB_CODFIL	:= _cLoja
				PAB->PAB_CODESP	:= aCols[nX,nPosEsp]
				PAB->PAB_DESCR	:= aCols[nX,nPosDes]
				PAB->PAB_MEDIDA	:= aCols[nX,nPosMed]
				PAB->PAB_IMAGEM	:= _cImage
				PAB->PAB_DTLOJA	:= _dPrazo
							
				PAB->( MsUnLock() )
			
			EndIf
			
		Next nX
								
	EndIf
	
	End Transaction
		
EndIf

oDlg:End()
	
Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LsMiLOk()
///////////////////////

Local nPosNum := aScan(aHeader,{|x| AllTrim(x[2])=="PAB_NUM"})
Local _lRet := .T.

If !Empty(aCols[n,nPosNum]) .And. aCols[n,Len(aHeader)+1]
	MsgStop("Espaço não pode ser excluido, pois encontra-se em contrato!")
	_lRet := .F.
EndIf

Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LsMidLe()
///////////////////////

BrwLegenda("Cadastro de Espacos",'Legenda',;
	{{'BR_VERDE'	,'Disponivel'	},;
	{'BR_VERMELHO'	,'Ocupado'	}})

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function VisuCtr()
/////////////////////////

Local	oDlgCtr 
Local	oEnchoice 
Local	oListVen
Local	oListEsp
Local	nOpc		:= 2
Local	_aListEsp	:= {}
Local	_aDtVenc	:= {}
Local	aListVen	:= {}
Local	aFolder		:= { 'Espacos', 'Parcelas' }
Local	nPosNum		:= aScan(aHeader,{|x| AllTrim(x[2])=="PAB_NUM"})
Local	oAb			:= LoadBitmap( GetResources(), "BR_VERDE" 	)	
Local	oFi			:= LoadBitmap( GetResources(), "BR_VERMELHO")	

Aadd(aListVen, { oAb,Space(3),Space(8),Space(6),Space(9),Space(3),Space(8) } )

DbSelectArea("PAD")
PAD->( DbSetOrder(1) )
PAD->( DbSeek( xFilial("PAD")+aCols[n,nPosNum] ) )
While PAD->( !Eof() ) .And. PAD->PAD_FILIAL+PAD->PAD_NUM == xFilial("PAD")+aCols[n,nPosNum]
	
	Aadd(_aListEsp, {PAD->PAD_LOJA, FBUSCACPO("SM0",1,CEMPANT+PAD->PAD_LOJA,"M0_FILIAL"),;
					PAD->PAD_ESPA,Alltrim(Posicione("PAB",1,xFilial("PAB")+PAD->PAD_LOJA+PAD->PAD_ESPA,"PAB_DESCR")),;
					Transform(PAD->PAD_PRECO,"@E 999,999,999.99") } )
	PAD->( DbSkip() )
	
EndDo

DbSelectArea("PAC")
PAC->( DbSetOrder(1) )
PAC->( DbSeek( xFilial("PAC")+aCols[n,nPosNum] ) )

If Empty(aCols[n,nPosNum])
	MsgStop("Espaco não utilizado em contrato!")
	Return(.F.)
EndIf

_nW := 1

DbSelectArea("PAE")
PAE->( DbSetorder(1) )
PAE->( DbSeek( xFilial("PAE")+aCols[n,nPosNum] ) )
While PAE->( !Eof() ) .And. ( PAE->PAE_FILIAL+PAE->PAE_NUMCON == xFilial("PAC")+aCols[n,nPosNum] )

	_aDtVenc := {}
	_aDtVenc := Condicao(PAC->PAC_VALOR,PAC->PAC_PAGTO,,PAE->PAE_DATA,,,,,,)
	
	If _nW == 1	
		If Empty(PAE->PAE_PEDVEN)
			aListVen[1,1] := oAb		
		Else
			aListVen[1,1] := oFi					
		EndIf	
		aListVen[1,2] := PAE->PAE_PARCEL
		aListVen[1,3] := Substr(DTOS(PAE->PAE_DATA),7,2)+"/"+Substr(DTOS(PAE->PAE_DATA),5,2)+"/"+Substr(DTOS(PAE->PAE_DATA),3,2)
		aListVen[1,4] := PAE->PAE_PEDVEN
		aListVen[1,5] := Posicione("SC5",1,PAE->PAE_FILIAL+PAE->PAE_PEDVEN,"C5_NOTA")
		aListVen[1,6] := Posicione("SC5",1,PAE->PAE_FILIAL+PAE->PAE_PEDVEN,"C5_SERIE")
		aListVen[1,7] := _aDtVenc[1,1]		
	Else		
		Aadd(aListVen, {If( Empty(PAE->PAE_PEDVEN), oAb,oFi ),PAE->PAE_PARCEL,Substr(DTOS(PAE->PAE_DATA),7,2)+"/"+Substr(DTOS(PAE->PAE_DATA),5,2)+"/"+Substr(DTOS(PAE->PAE_DATA),3,2),PAE->PAE_PEDVEN,Posicione("SC5",1,PAE->PAE_FILIAL+PAE->PAE_PEDVEN,"C5_NOTA"),Posicione("SC5",1,PAE->PAE_FILIAL+PAE->PAE_PEDVEN,"C5_SERIE"),_aDtVenc[1,1] } )		
	EndIf
	
	PAE->( DbSkip() )
	_nW++
		
EndDo                                                              

DEFINE MSDIALOG oDlgCtr TITLE cCadastro FROM 0,0 To 450,680 OF oMainWnd PIXEL
	
oPanel1:= TPanel():New(0, 0, "", oDlgCtr, NIL, .T., .F., NIL, NIL, 0,80, .T., .F. )
oPanel1:Align:=CONTROL_ALIGN_TOP

@ 010,010 SAY "Contrato:" OF oPanel1 PIXEL
@ 010,035 SAY PAC->PAC_NUM OF oPanel1 PIXEL

@ 025,010 SAY "Cliente:" OF oPanel1 PIXEL
@ 025,035 SAY PAC->PAC_CLIENT OF oPanel1 PIXEL

@ 025,010 SAY "Loja:" OF oPanel1 PIXEL
@ 025,035 SAY PAC->PAC_LOJACL OF oPanel1 PIXEL

@ 025,010 SAY "Loja:" OF oPanel1 PIXEL
@ 025,035 SAY PAC->PAC_LOJACL OF oPanel1 PIXEL
	
oFolder := TFolder():New( 0, 0, aFolder, aFolder, oDlgCtr,,,, .T., , 0,0 )
oFolder:Align:=CONTROL_ALIGN_ALLCLIENT

@ 001,001 LISTBOX oListEsp FIELDS HEADER "Loja","Nome","Espaco","Nome Espaco","Preco" SIZE 270,100 OF oFolder:aDialogs[1] PIXEL
oListEsp:SetArray(_aListEsp)
oListEsp:bLine	:= {|| {	_aListEsp[oListVen:nAT,01],;
							_aListEsp[oListVen:nAT,02],;
							_aListEsp[oListVen:nAT,03],;
							_aListEsp[oListVen:nAT,04],;
							_aListEsp[oListVen:nAT,05]}}

@ 001,001 LISTBOX oListVen FIELDS HEADER "","Parcela","Data", "Pedido", "Nota","Serie","Vencimento" SIZE 255,100 OF oFolder:aDialogs[2] PIXEL
oListVen:SetArray(aListVen)
oListVen:bLine	:= {|| {	aListVen[oListVen:nAT,01],;
							aListVen[oListVen:nAT,02],;
							aListVen[oListVen:nAT,03],;
							aListVen[oListVen:nAT,04],;
							aListVen[oListVen:nAT,05],;
							aListVen[oListVen:nAT,06],;
							aListVen[oListVen:nAT,07]}}							
			
ACTIVATE MSDIALOG oDlgCtr ON INIT (EnchoiceBar(oDlgCtr,{|| GrvDados(@nOpc) },{||oDlgCtr:End()},,))
	
Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LsMidMap(_cPar)
////////////////////////////
_cAlias := alias()
                       
If _cPar == 'B'
	_cFilial := PAB->PAB_CODFIL
Else
	_cFilial := aCols[n,1]
EndIf

DbSelectArea('ACB')                              
DbSetOrder(2)
If DbSeek(xFilial('ACB') + 'LOJA_' + _cFilial ,.F.)
	Do While  xFilial('ACB') + 'LOJA_' + _cFilial == ACB->ACB_FILIAL + left(ACB->ACB_OBJETO,7) .and. !eof()
	 	MsDocView( ACB->ACB_OBJETO, {}, "" )    
	 	DbSkip()
	EndDo
Else
	MsgBox('Mapa não localizado','Atenção!!!','ALERT')
EndIf               

DbSelectArea(_cAlias)
Return() 

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FTMSREL()
///////////////////////
Local _aRet := {}

AAdd( _aRet, { "PAB", { "PAB_CODFIL" }, { || PAB->PAB_DESCR } } )


Return(_aRet)
