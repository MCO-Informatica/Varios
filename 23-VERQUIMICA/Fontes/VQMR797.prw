#INCLUDE "FIVEWIN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR797  � Autor � Nelson Junior    		� Data � 13/03/13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ordens de Producao                                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
User Function VQMR797()

Local aOrdem 	:= {"Por Numero","Por Produto","Por Centro de Custo","Por Prazo de Entrega"}////////
Local aDevice 	:= {}
Local bParam	:= {|| Pergunte("MTR797", .T.)}
Local cAliasTop := "SC2"
Local cDevice   := ""
Local cPathDest := GetSrvProfString("StartPath","\system\")
Local cRelName  := "MATR797"
Local cSession  := GetPrinterSession()
Local lAdjust   := .F.
Local nFlags    := PD_ISTOTVSPRINTER//+PD_DISABLEPAPERSIZE
Local nLocal    := 1
Local nOrdem 	:= 1
Local nOrient   := 1
Local nPrintType:= 6
Local oPrinter 	:= Nil
Local oSetup    := Nil
Private aArray	:= {}
Private li		:= 15
Private nMaxLin	:= 0
Private nMaxCol	:= 0
Private lItemNeg := GetMv("MV_NEGESTR") .And. mv_par11 == 1

AjustaSX1()

AADD(aDevice,"DISCO") // 1
AADD(aDevice,"SPOOL") // 2
AADD(aDevice,"EMAIL") // 3
AADD(aDevice,"EXCEL") // 4
AADD(aDevice,"HTML" ) // 5
AADD(aDevice,"PDF"  ) // 6

cSession		:= GetPrinterSession()
// Obtem ultima configuracao de tipo de impress�o (spool ou pdf) gravada no arquivo de configuracao
cDevice			:= If(Empty(fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.)),"PDF",fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.))
// Obtem ultima configuracao de orientacao de papel (retrato ou paisagem) gravada no arquivo de configuracao
nOrient	:= If(fwGetProfString(cSession,"ORIENTATION","PORTRAIT",.T.)=="PORTRAIT",1,2)
// Obtem ultima configuracao de destino (cliente ou servidor) gravada no arquivo de configuracao
nLocal			:= If(fwGetProfString(cSession,"LOCAL","SERVER",.T.)=="SERVER",1,2 )
nPrintType  	:= aScan(aDevice,{|x| x == cDevice })     

oPrinter := FWMSPrinter():New(cRelName, nPrintType, lAdjust, /*cPathDest*/, .T.)

// Cria e exibe tela de Setup Customizavel - Utilizar include "FWPrintSetup.ch"

oSetup := FWPrintSetup():New (nFlags,cRelName)

oSetup:SetPropert(PD_PRINTTYPE   , nPrintType)
oSetup:SetPropert(PD_ORIENTATION , nOrient)
oSetup:SetPropert(PD_DESTINATION , nLocal)
oSetup:SetPropert(PD_MARGIN      , {0,0,0,0})
//oSetup:SetPropert(PD_PAPERSIZE   , 2)
oSetup:SetOrderParms(aOrdem,@nOrdem)
oSetup:SetUserParms(bParam)

If oSetup:Activate() == PD_OK 
	// Grava ultima configuracao de destino (cliente ou servidor) no arquivo de configuracao
	fwWriteProfString( cSession, "LOCAL"      , If(oSetup:GetProperty(PD_DESTINATION)==1 ,"SERVER"    ,"CLIENT"    ), .T. )
	// Grava ultima configuracao de tipo e impressao (spool ou pdf) no arquivo de configuracao
	fwWriteProfString( cSession, "PRINTTYPE"  , If(oSetup:GetProperty(PD_PRINTTYPE)==2   ,"SPOOL"     ,"PDF"       ), .T. )
	// Grava ultima configuracao de orientacao de papel (retrato ou paisagem) no arquivo de configuracao
	fwWriteProfString( cSession, "ORIENTATION", If(oSetup:GetProperty(PD_ORIENTATION)==1 ,"PORTRAIT"  ,"LANDSCAPE" ), .T. )
	// Atribui configuracao de destino (cliente ou servidor) ao objeto FwMsPrinter
	oPrinter:lServer := oSetup:GetProperty(PD_DESTINATION) == AMB_SERVER
	// Atribui configuracao de tipo de impressao (spool ou pdf) ao objeto FwMsPrinter
	oPrinter:SetDevice(oSetup:GetProperty(PD_PRINTTYPE))
	// Atribui configuracao de orientacao de papel (retrato ou paisagem) ao objeto FwMsPrinter
	If oSetup:GetProperty(PD_ORIENTATION) == 1
		oPrinter:SetPortrait()
		nMaxLin	:= 800
		nMaxCol	:= 600
	Else 
		oPrinter:SetLandscape()
		nMaxLin	:= 600
		nMaxCol	:= 800
	EndIf
	// Atribui configuracao de tamanho de papel ao objeto FwMsPrinter
	oPrinter:SetPaperSize(oSetup:GetProperty(PD_PAPERSIZE))
	oPrinter:setCopies(Val(oSetup:cQtdCopia))
	If oSetup:GetProperty(PD_PRINTTYPE) == IMP_SPOOL
		oPrinter:nDevice := IMP_SPOOL
		fwWriteProfString(GetPrinterSession(),"DEFAULT", oSetup:aOptions[PD_VALUETYPE], .T.)
		oPrinter:cPrinter := oSetup:aOptions[PD_VALUETYPE]
	Else 
		oPrinter:nDevice := IMP_PDF
		oPrinter:cPathPDF := oSetup:aOptions[PD_VALUETYPE]
		oPrinter:SetViewPDF(.T.)
	Endif
	
	RptStatus({|lEnd| VQM797Proc(@lEnd,nOrdem, @oPrinter)},"Imprimindo Relatorio...")
Else 
	MsgInfo("Relat�rio cancelado pelo usu�rio.")
	oPrinter:Cancel()
EndIf

oSetup:= Nil
oPrinter:= Nil

Return Nil

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Funcao    | Mtr797Proc � Autor � Anieli Rodrigues      � Data �22/03/2013���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Efetua o processamento do relatorio	                        ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � MATR797                                                      ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
Static Function VQM797Proc(lEnd, nOrdem, oPrinter)
            
Local i 	:= 0
Local nBegin:= 0

Pergunte("MTR797",.F.)

dbSelectArea("SC2")

#IFDEF TOP
	cAliasTop := GetNextAlias()
	cQuery := "SELECT SC2.C2_FILIAL, SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN, SC2.C2_ITEMGRD, SC2.C2_DATPRF, "
	cQuery += "SC2.C2_DATRF, SC2.C2_PRODUTO, SC2.C2_DESTINA, SC2.C2_PEDIDO, SC2.C2_ROTEIRO, SC2.C2_QUJE, "
	cQuery += "SC2.C2_PERDA, SC2.C2_QUANT, SC2.C2_DATPRI, SC2.C2_CC, SC2.C2_DATAJI, SC2.C2_DATAJF, "
	cQuery += "SC2.C2_STATUS, SC2.C2_OBS, SC2.C2_TPOP, "
	cQuery += "SC2.R_E_C_N_O_  SC2RECNO FROM "+RetSqlName("SC2")+" SC2 WHERE "
	cQuery += "SC2.C2_FILIAL='"+xFilial("SC2")+"' AND SC2.D_E_L_E_T_=' ' AND "
	If	Upper(TcGetDb()) $ 'ORACLE,DB2,POSTGRES,INFORMIX'
		cQuery += "SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN || SC2.C2_ITEMGRD >= '" + mv_par01 + "' AND "
		cQuery += "SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN || SC2.C2_ITEMGRD <= '" + mv_par02 + "' AND "
	Endif
	cQuery += "SC2.C2_DATPRF BETWEEN '" + Dtos(mv_par03) + "' AND '" + Dtos(mv_par04) + "' "
	If mv_par08 == 2
		cQuery += "AND SC2.C2_DATRF = ' '"
	Endif	
		If nOrdem == 4
		cQuery += "ORDER BY SC2.C2_FILIAL, SC2.C2_DATPRF"
	Else
		cQuery += "ORDER BY " + SqlOrder(SC2->(IndexKey(nOrdem)))
	EndIf
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
	aEval(SC2->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(cAliasTop,x[1],x[2],x[3],x[4]),Nil)})
	dbSelectArea(cAliasTop)
#ELSE
	If nOrdem == 4
		IndRegua("SC2",cIndSC2,"C2_FILIAL+DTOS(C2_DATPRF)",,,"Selecionando Registros...")	//
	Else
		dbSetOrder(nOrdem)
	EndIf
	dbSeek(xFilial("SC2"))
#ENDIF

SetRegua(SC2->(LastRec()))

While !Eof()
	IF lEnd
		oPrinter:StartPage()
		oPrinter:Say(li,25,"CANCELADO PELO OPERADOR")
		oPrinter:EndPage()
		oPrinter:Print()
		Exit
	EndIF
	IncRegua()
	If C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD < xFilial('SC2')+mv_par01 .or. C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD > xFilial('SC2')+mv_par02
		dbSkip()
		Loop
	EndIf   
	#IFNDEF TOP		
		If  C2_DATPRF < mv_par03 .Or. C2_DATPRF > mv_par04
			dbSkip()                                
			Loop
		Endif
		
		If !(Empty(C2_DATRF)) .And. mv_par08 == 2
			dbSkip()
			Loop
		Endif
	#ENDIF
	If !MtrAValOP(mv_par10,"SC2",cAliasTop)
		dbSkip()
		Loop
	EndIf
	cProduto  := C2_PRODUTO
	nQuant    := aSC2Sld(cAliasTop)
	dbSelectArea("SB1")
	dbSeek(xFilial()+cProduto)
	//��������������������������������������������������������������Ŀ
	//� Adiciona o primeiro elemento da estrutura , ou seja , o Pai  �
	//����������������������������������������������������������������
	AddAr797(nQuant)
	MontStruc((cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD),nQuant)
	If mv_par09 == 1
		aSort( aArray,2,, { |x, y| (x[1]+x[8]) < (y[1]+y[8]) } )
	Else
		aSort( aArray,2,, { |x, y| (x[8]+x[1]) < (y[8]+y[1]) } )
	EndIf
	//���������������������������������������������������������Ŀ
	//� Imprime cabecalho                                       �
	//�����������������������������������������������������������
	nPagina := 1
	cabecOp(nPagina,oPrinter)
	For I := 2 TO Len(aArray)
		oPrinter:Say(li,25,aArray[I][1]) // CODIGO PRODUTO
		For nBegin := 1 To Len(Alltrim(aArray[I][2])) Step 31
			oPrinter:Say(li,150,Substr(aArray[I][2],nBegin,31))
			li+=10
		Next nBegin
		Li-=10
		cQtd := Transform(aArray[I][5],PesqPictQt("D4_QUANT",TamSX3("D4_QUANT")[1]))
		oPrinter:Say(li,300,cQtd) 						// QUANTIDADE	
		oPrinter:Say(li,400,aArray[I][4])				// UNIDADE DE MEDIDA					
		oPrinter:Say(li,425,aArray[I][6]) 				// ALMOXARIFADO
		oPrinter:Say(li,450,Substr(aArray[I][7],1,12))  // LOCALIZACAO
		oPrinter:Say(li,500,aArray[I][8])				// SEQUENCIA        	
		If mv_par12 == 1
			oPrinter:Say(li,550,aArray[I][10])			// LOTE 
			oPrinter:Say(li,600,aArray[I][11])			// SUB-LOTE            	
		EndIf
		li+=10
		oPrinter:Line( li, 5, li, nMaxCol-10,, "-1")
		li+=10
		   
		//���������������������������������������������������������Ŀ
		//� Se nao couber, salta para proxima folha                 �
		//�����������������������������������������������������������
		IF li >= nMaxLin
			oPrinter:EndPage()
			Li := 15
			nPagina++
			CabecOp(nPagina,oPrinter)		// imprime cabecalho da OP
		EndIF
	Next I
	
	If mv_par05 == 1
		RotOper(oPrinter)   	// IMPRIME ROTEIRO DAS OPERACOES
	Endif
		
	oPrinter:EndPage()
	Li := 15					// linha inicial - ejeta automatico
	aArray:={}
	
	dbSelectArea(cAliasTop)
	dbSkip()

	EndDO

dbSelectArea("SH8")
dbCloseArea()

dbSelectArea("SC2")
#IFDEF TOP
	(cAliasTop)->(dbCloseArea())
#ELSE	
	If nOrdem == 4
		RetIndex("SC2")
		Ferase(cIndSC2+OrdBagExt())
	EndIf
#ENDIF

dbClearFilter()
dbSetOrder(1)
	
oPrinter:Print()

Return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � AddAr797 � Autor � Anieli Rodrigues      � Data � 25/03/13 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Adiciona um elemento ao Array                              ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � AddAr797(ExpN1)                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpN1 = Quantidade da estrutura                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR797                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function AddAr797(nQuantItem)
Local cDesc   := SB1->B1_DESC
Local cLocal  := ""
Local cKey    := ""
Local cRoteiro:= ""  

Local lVer116   := (VAL(GetVersao(.F.)) == 11 .And. GetRpoRelease() >= "R6" .Or. VAL(GetVersao(.F.))  > 11)
//�����������������������������������������������������������Ŀ
//� Verifica se imprime nome cientifico do produto. Se Sim    �
//� verifica se existe registro no SB5 e se nao esta vazio    �
//�������������������������������������������������������������
If mv_par07 == 1
	dbSelectArea("SB5")
	dbSeek(xFilial()+SB1->B1_COD)
	If Found() .and. !Empty(B5_CEME)
		cDesc := B5_CEME
	EndIf
ElseIf mv_par07 == 2
	cDesc := SB1->B1_DESC
Else
	//�����������������������������������������������������������Ŀ
	//� Verifica se imprime descricao digitada ped.venda, se sim  �
	//� verifica se existe registro no SC6 e se nao esta vazio    �
	//�������������������������������������������������������������
	If (cAliasTop)->C2_DESTINA == "P"
		dbSelectArea("SC6")
		dbSetOrder(1)
		dbSeek(xFilial()+(cAliasTop)->C2_PEDIDO+(cAliasTop)->C2_ITEM)
		If Found() .and. !Empty(C6_DESCRI) .and. C6_PRODUTO==SB1->B1_COD
			cDesc := C6_DESCRI
		ElseIf C6_PRODUTO # SB1->B1_COD
			dbSelectArea("SB5")
			dbSeek(xFilial()+SB1->B1_COD)
			If Found() .and. !Empty(B5_CEME)
				cDesc := B5_CEME
			EndIf
		EndIf
	EndIf
EndIf

//�����������������������������������������������������������Ŀ
//� Verifica se imprime ROTEIRO da OP ou PADRAO do produto    �
//�������������������������������������������������������������
If !Empty((cAliasTop)->C2_ROTEIRO)
	cRoteiro:=(cAliasTop)->C2_ROTEIRO
Else
	If !Empty(SB1->B1_OPERPAD)
		cRoteiro:=SB1->B1_OPERPAD
	Else
		dbSelectArea("SG2")
		If dbSeek(xFilial()+(cAliasTop)->C2_PRODUTO+"01")
			cRoteiro:="01"
		EndIf
	EndIf
EndIf
 
If lVer116
	dbSelectArea("NNR")
	dbSeek(xFilial()+SD4->D4_LOCAL)
Else
	dbSelectArea("SB2")
	dbSeek(xFilial()+SB1->B1_COD+SD4->D4_LOCAL) 
EndIf

dbSelectArea("SD4")
cKey:=SD4->D4_COD+SD4->D4_LOCAL+SD4->D4_OP+SD4->D4_TRT+SD4->D4_LOTECTL+SD4->D4_NUMLOTE
cLocal:=SB2->B2_LOCALIZ

DbSelectArea("SDC")
DbSetOrder(2)
DbSeek(xFilial("SDC")+cKey)
If !Eof() .And. SDC->(DC_PRODUTO+DC_LOCAL+DC_OP+DC_TRT+DC_LOTECTL+DC_NUMLOTE) == cKey
	cLocal:=DC_LOCALIZ
EndIf

dbSelectArea("SD4")

//If lVer116
//	AADD(aArray, {SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQuantItem,SD4->D4_LOCAL,NNR->NNR_DESCRI,SD4->D4_TRT,cRoteiro,If(mv_par12 == 1,SD4->D4_LOTECTL,""),If(mv_par12 == 1,SD4->D4_NUMLOTE,"") } )
//Else
	AADD(aArray, {SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQuantItem,SD4->D4_LOCAL,cLocal,SD4->D4_TRT,cRoteiro,If(mv_par12 == 1,SD4->D4_LOTECTL,""),If(mv_par12 == 1,SD4->D4_NUMLOTE,""),SB1->B1_CONV } )
//EndIf

Return

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � MontStruc� Autor � Anieli Rodrigues      � Data � 25/03/13 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Monta um array com a estrutura do produto                  ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � MontStruc(ExpC1,ExpN1)                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Codigo do produto a ser explodido                  ���
���          � ExpN1 = Quantidade base a ser explodida                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR797                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/
Static Function MontStruc(cOp,nQuant)

dbSelectArea("SD4")
dbSetOrder(2)
dbSeek(xFilial()+cOp)

While !Eof() .And. D4_FILIAL+D4_OP == xFilial()+cOp
	//���������������������������������������������������������Ŀ
	//� Posiciona no produto desejado                           �
	//�����������������������������������������������������������
	dbSelectArea("SB1")
	If dbSeek(xFilial()+SD4->D4_COD)
		If SD4->D4_QUANT > 0 .Or. (lItemNeg .And. SD4->D4_QUANT < 0)
			AddAr797(SD4->D4_QUANT)
		EndIf
	Endif
	dbSelectArea("SD4")
	dbSkip()
Enddo

dbSetOrder(1)

Return

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � CabecOp  � Autor � Anieli Rodrigues      � Data � 25/03/13 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Monta o cabecalho da Ordem de Producao                     ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � CabecOp()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR797                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/
Static Function CabecOp(nPagOp,oPrinter)

Local cTitulo := If(mv_par12 == 2,"ORDEM DE PRODUCAO NRO: ","ORDEM DE PRODUCAO NRO: ")+(cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)//
Local cCabec1 := "Empresa: "+RTrim(SM0->M0_NOME)+" / "+"Filial: "+Alltrim(SM0->M0_FILIAL)////
Local cCabec2 := "  C O M P O N E N T E S"
Local nBegin       
Local nAltura  := 0
Local nLarg    := 0
Local nLinha   := 0
Local nPixel   := 0
Local nomeprog := "MATR797"

Private oFontC
Private oFontT

oFontT := TFont():New('Courier new',,8,.T.)
oFontC := TFont():New('Courier new',,12,.T.)
oPrinter:StartPage()
oPrinter:Line( li, 5, li, nMaxCol,, "-1")
li+= 20
nAltura := 10//oPrinter:nPageHeight
nLargura:= 10//oPrinter:nPageWidth
oPrinter:Cmtr2Pix(nAltura,nLargura)
//oPrinter:Box(40,40,190,540)
oPrinter:SayAlign(li,0,cTitulo,oFontC,nMaxCol,200,,2) 
li += 15
oPrinter:SayAlign(li,25,cCabec1,oFontT,600,200,,0) 
li+= 15
oPrinter:Line( li, 5, li, nMaxCol,, "-1")
Li+=2
IF (mv_par06 == 1)
	//���������������������������������������������������������Ŀ
	//� Imprime o codigo de barras do numero da OP              �
	//�����������������������������������������������������������  
	cCode := (cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)
	li+=40
	oPrinter:Code128C(li,25 ,AllTrim(cCode),40) 
	li += 20
ENDIF

oPrinter:Say(li,25,"Produto: "+aArray[1][1]+" " +aArray[1][2],,600) //
li+=10 
oPrinter:Say(li,25,"Emissao: "+DTOC(dDatabase),,600)//
oPrinter:Say(li,120,"Fol: "+TRANSFORM(nPagOp,'999'))//
oPrinter:Say(li,220,"Densidade: "+AllTrim(Str(aArray[1][12])))
oPrinter:Say(li,500,"   Operador: _____________________________________")
li+=10

//���������������������������������������������������������Ŀ
//� Imprime nome do cliente quando OP for gerada            �
//� por pedidos de venda                                    �
//�����������������������������������������������������������
If (cAliasTop)->C2_DESTINA == "P"
	dbSelectArea("SC5")
	dbSetOrder(1)
	If dbSeek(xFilial()+(cAliasTop)->C2_PEDIDO,.F.)
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
		oPrinter:Say(li,25,"Cliente: ")//
		oPrinter:Say(li,42,SC5->C5_CLIENTE+"-"+SC5->C5_LOJACLI+" "+A1_NOME)
		dbSelectArea("SG1")
		li+=10
	EndIf
EndIf

//���������������������������������������������������������Ŀ
//� Imprime a quantidade original quando a quantidade da    �
//� Op for diferente da quantidade ja entregue              �
//�����������������������������������������������������������
If (cAliasTop)->C2_QUJE + (cAliasTop)->C2_PERDA > 0
	oPrinter:Say(li,25,"Qtde Prod.: ")
	oPrinter:Say(li,36,Transform(aSC2Sld(cAliasTop),PesqPictQt("C2_QUANT",TamSX3("C2_QUANT")[1])))
	oPrinter:Say(li,110,"Qtde Orig.:")
	oPrinter:Say(li,145,Transform((cAliasTop)->C2_QUANT,PesqPictQt("C2_QUANT",TamSX3("C2_QUANT")[1])))
Else
	oPrinter:Say(li,25,"Quantidade: ")
	oPrinter:Say(li,65,Transform((cAliasTop)->C2_QUANT - (cAliasTop)->C2_QUJE,PesqPictQt("C2_QUANT",TamSX3("C2_QUANT")[1])))
Endif

oPrinter:Say(li,220,"INICIO")
oPrinter:Say(li,305,"FIM")
Li+=10
oPrinter:Say(li,25,"Unid. Medida: "+aArray[1][4])//
oPrinter:Say(li,220,"Prev.: "+DTOC((cAliasTop)->C2_DATPRI))//
oPrinter:Say(li,305,"Prev.: "+DTOC((cAliasTop)->C2_DATPRF))//
oPrinter:Say(li,500,"Laboratorio: _____________________________________")
li+=10
oPrinter:Say(li,25,"C.Custo: "+(cAliasTop)->C2_CC)//
oPrinter:Say(li,220,"Ajuste: "+DTOC((cAliasTop)->C2_DATAJI))//
oPrinter:Say(li,305,"Ajuste: "+DTOC((cAliasTop)->C2_DATAJF))//"Ajuste: "
li+=10
If (cAliasTop)->C2_STATUS == "S"
	oPrinter:Say(li,25,"Status: OP Sacramentada")//
ElseIf (cAliasTop)->C2_STATUS == "U"
	oPrinter:Say(li,25,"Status: OP Suspensa")
ElseIf (cAliasTop)->C2_STATUS $ " N"
	oPrinter:Say(li,25,"Status: OP Normal")
EndIf
oPrinter:Say(li,220,"Real  :   /  / ")
oPrinter:Say(li,305,"Real  :   /  / ")
oPrinter:Say(li,500," Fechamento: _____________________________________")
li+=10  
If !(Empty((cAliasTop)->C2_OBS))
	oPrinter:Say(li,25,"Observacao: ")
	For nBegin := 1 To Len(Alltrim((cAliasTop)->C2_OBS)) Step 65
		oPrinter:Say(li,60,Substr((cAliasTop)->C2_OBS,nBegin,65))
		@li,012 PSay Substr((cAliasTop)->C2_OBS,nBegin,65)
		li+=10
	Next nBegin
EndIf

oPrinter:Line( li, 5, li, nMaxCol-10,, "-1")
li+=10
oPrinter:Say(li,25,cCabec2,oFontC)
li+=10
oPrinter:Say(li,25,"CODIGO",oFontT)//
oPrinter:Say(li,150,"DESCRICAO",oFontT)//
oPrinter:Say(li,300,"QUANTIDADE",oFontT)//
oPrinter:Say(li,400,"UM",oFontT)//
oPrinter:Say(li,425,"ARM",oFontT)//
oPrinter:Say(li,450,"ENDERECO",oFontT)//
oPrinter:Say(li,500,"SEQ",oFontT)//
li+=10
oPrinter:Line( li, 5, li, nMaxCol-10,, "-1")
li+=10 

Return()
/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � RotOper  � Autor � Anieli Rodrigues      � Data � 04/04/13 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Imprime Roteiro de Operacoes                               ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � RotOper()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR797                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function RotOper(oPrinter)
Local cSeekWhile := "SG2->(G2_FILIAL+G2_PRODUTO+G2_CODIGO)"
dbSelectArea("SG2")
If a630SeekSG2(1,aArray[1][1],xFilial("SG2")+aArray[1][1]+aArray[1][9],@cSeekWhile) 
	
	cRotOper(oPrinter)
	
	While !Eof() .And. Eval(&cSeekWhile)
		
		dbSelectArea("SH4")
		dbSeek(xFilial()+SG2->G2_FERRAM)
		
		dbSelectArea("SH8")
		dbSetOrder(1)
		dbSeek(xFilial()+(cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)+SG2->G2_OPERAC)
		lSH8 := IIf(Found(),.T.,.F.)
		
		If lSH8
			While !Eof() .And. SH8->H8_FILIAL+SH8->H8_OP+SH8->H8_OPER == xFilial()+(cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)+SG2->G2_OPERAC
				ImpRot(lSH8,oPrinter)
				dbSelectArea("SH8")
				dbSkip()
			End
		Else
			ImpRot(lSH8,oPrinter)
		Endif
		
		dbSelectArea("SG2")
		dbSkip()
		
	EndDo
	
Endif

Return Li

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � RotOper  � Autor � Anieli Rodrigues      � Data � 04/04/13 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Imprime Roteiro de Operacoes                               ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � RotOper()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR797                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function cRotOper(oPrinter)

Local cCabec1 := SM0->M0_NOME+" ROTEIRO DE OPERACOES NRO :"
li+=10
oPrinter:Line( li, 5, li, nMaxCol-10,, "-1")
li+=10
oPrinter:Say(li,25,cCabec1)
oPrinter:Say(li,200,(cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD))
li+=10
oPrinter:Line( li, 5, li, nMaxCol-10,, "-1")
li+=10
oPrinter:Say(li,25,"Produto: "+aArray[1][1])//
ImpDescr(aArray[1][2],oPrinter)

//���������������������������������������������������������Ŀ
//� Imprime a quantidade original quando a quantidade da    �
//� Op for diferente da quantidade ja entregue              �
//�����������������������������������������������������������
If (cAliasTop)->C2_QUJE + (cAliasTop)->C2_PERDA > 0
	oPrinter:Say(li,25,"Qtde Prod.: ")//
	oPrinter:Say(li,25,Transform(aSC2Sld(cAliasTop),PesqPictQt("C2_QUANT",TamSX3("C2_QUANT")[1])))
	oPrinter:Say(li,110,"Qtde Orig.:")//
	oPrinter:Say(li,145,Transform((cAliasTop)->C2_QUANT,PesqPictQt("C2_QUANT",TamSX3("C2_QUANT")[1])))
Else
	oPrinter:Say(li,25,"Quantidade: ")
	oPrinter:Say(li,65,Transform((cAliasTop)->C2_QUANT - (cAliasTop)->C2_QUJE,PesqPictQt("C2_QUANT",TamSX3("C2_QUANT")[1])))
Endif
li+=10
oPrinter:Say(li,25,"C.Custo: "+(cAliasTop)->C2_CC)//
li+=10
oPrinter:Line( li, 5, li, nMaxCol-10,, "-1")
li+=10
oPrinter:Say(li,25,"RECURSO")
oPrinter:Say(li,150,"FERRAMENTA")
oPrinter:Say(li,300,"OPERACAO")
li+=10
oPrinter:Line( li, 5, li, nMaxCol-10,, "-1")
li+=10

Return li
 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ImpDescr � Autor � Anieli Rodrigues      � Data � 05.04.13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprimir descricao do Produto.                             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ImpProd(Void)                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR797                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImpDescr(cDescri,oPrinter)
Local nBegin

For nBegin := 1 To Len(Alltrim(cDescri)) Step 50
	oPrinter:Say(li,300,Substr(cDescri,nBegin,50))
	li+=10
Next nBegin

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � ImpRot   � Autor � Anieli Rodrigues      � Data � 05/04/13 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Imprime Roteiro de Operacoes                               ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � ImpRot()                                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR797                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function ImpRot(lSH8,oPrinter)
Local nBegin

dbSelectArea("SH1")
dbSeek(xFilial()+IIf(lSH8,SH8->H8_RECURSO,SG2->G2_RECURSO))

Verilim(oPrinter)

oPrinter:Say(li,25,IIF(lSH8,SH8->H8_RECURSO,SG2->G2_RECURSO)+" "+SUBS(SH1->H1_DESCRI,1,25))
oPrinter:Say(li,150,SG2->G2_FERRAM+" "+SUBS(SH4->H4_DESCRI,1,20))
oPrinter:Say(li,300,SG2->G2_OPERAC)

For nBegin := 1 To Len(Alltrim(SG2->G2_DESCRI)) Step 32
	oPrinter:Say(li,350,Substr(SG2->G2_DESCRI,nBegin,32))	
	li+=10
	
	If li> nMaxLin-40
		li:= 0 
		oPrinter:EndPage()
		oPrinter:StartPage()
		cRotOper(oPrinter)
	EndIf
Next nBegin
li+=10

oPrinter:Say(li,25,"INICIO  DESIG: "+IIF(lSH8,DTOC(SH8->H8_DTINI),Space(8))+" "+IIF(lSH8,SH8->H8_HRINI,Space(5))+" "+" INICIO  REAL :"+" ____/ ____/____ ___:___")////
li+=10
oPrinter:Say(li,25,"TERMINO DESIG: "+IIF(lSH8,DTOC(SH8->H8_DTINI),Space(8))+" "+IIF(lSH8,SH8->H8_HRINI,Space(5))+" "+" INICIO  REAL :"+" ____/ ____/____ ___:___")//"TERMINO DESIG: "//
li+=10
oPrinter:Say(li,25,"Quantidade: ")                                                    //"Quantidade: "
oPrinter:Say(li,25,Transform(IIF(lSH8,SH8->H8_QUANT,aSC2Sld(cAliasTop)),PesqPictQt("H8_QUANT",14)))
oPrinter:Say(li,140,"Quantidade produzida: ")//"Quantidade produzida: "
oPrinter:Say(li,350,"Perdas: ")//"Perdas: "
li+=10
oPrinter:Line( li, 5, li, nMaxCol-10,, "-1")
li+=10

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � Verilim  � Autor � Anieli Rodrigues      � Data � 05/04/13 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � Verilim()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� 			                                          		  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR797                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function Verilim(oPrinter)

//����������������������������������������������������������������������Ŀ
//� Verifica a possibilidade de impressao da proxima operacao alocada na �
//� mesma folha.														 �
//� 7 linhas por operacao => (total da folha) 66 - 7 = 59				 �
//������������������������������������������������������������������������
IF li > nMaxLin						// Li > 55
	li := 15
	oPrinter:EndPage()
	oPrinter:StartPage()
	cRotOper(oPrinter)			// Imprime cabecalho roteiro de operacoes
Endif
Return Li

/*/
�����������������������������������������������������������������������������          	
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �AjustaSX1 � Autor � Anieli Rodrigues	    � Data �21/03/2013���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Cria pergunta para o grupo			                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR797                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function AjustaSX1()

Local aHelpPor
Local aHelpEng
Local aHelpSpa

aHelpPor := {'Nr OP inicial a ser considerado na','filtragem do cadastro de OPs (SC2)'}
aHelpEng := {'Nr OP inicial a ser considerado na','filtragem do cadastro de OPs (SC2)'}
aHelpSpa := {'Nr OP inicial a ser considerado na','filtragem do cadastro de OPs (SC2)'}

PutSx1("MTR797","01","Da O.P.","�De O. P. ?","From Product.Order ?",;
"MV_CH1","C",13,0,0,"G","","SC2","","","mv_par01",,,,,,,,"","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)    

aHelpPor := {'Nr OP final a ser considerado na','filtragem do cadastro de OPs (SC2)'}
aHelpEng := {'Nr OP final a ser considerado na','filtragem do cadastro de OPs (SC2)'}
aHelpSpa := {'Nr OP final a ser considerado na','filtragem do cadastro de OPs (SC2)'}

PutSx1("MTR797","02","Ate a O.P.","�A O. P. ?","To Production Order ?",;
"MV_CH2","C",13,0,0,"G","","SC2","","","mv_par02",,,,,,,,"","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa) 

aHelpPor := {'Data OP inicial a ser considerada na','filtragem do cadastro de OPs (SC2)'}
aHelpEng := {'Data OP inicial a ser considerada na','filtragem do cadastro de OPs (SC2)'}
aHelpSpa := {'Data OP inicial a ser considerada na','filtragem do cadastro de OPs (SC2)'}

PutSx1("MTR797","03","Da data","�A Fecha ?","From Date ?",;
"MV_CH3","D",8,0,0,"G","","","","","mv_par03",,,,,,,,"","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa) 

aHelpPor := {'Data OP inicial a ser considerada na','filtragem do cadastro de OPs (SC2)'}
aHelpEng := {'Data OP inicial a ser considerada na','filtragem do cadastro de OPs (SC2)'}
aHelpSpa := {'Data OP inicial a ser considerada na','filtragem do cadastro de OPs (SC2)'}

PutSx1("MTR797","04","Ate a data","�A Fecha ?","To Date ?",;
"MV_CH4","D",8,0,0,"G","","","","","mv_par04",,,,,,,,"","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa) 

aHelpPor := {'Lista o roteiro de opera��es juntamente','com as OPs?'}
aHelpEng := {'Lista o roteiro de opera��es juntamente','com as OPs?'}
aHelpSpa := {'Lista o roteiro de opera��es juntamente','com as OPs?'}

PutSx1("MTR797","05","Roteiro de Operacoes","�Proced.Operaciones ?","Operation Sequence ?",;
"MV_CH5","N",1,0,1,"C","","","","","mv_par05","Sim","Si","Yes",,"Nao","No","No","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa) 

aHelpPor := {'Considera a impressao do c�digo de','barras do n�mero da ordem de produ��o.'}
aHelpEng := {'Considera a impressao do c�digo de','barras do n�mero da ordem de produ��o.'}
aHelpSpa := {'Considera a impressao do c�digo de','barras do n�mero da ordem de produ��o.'}

PutSx1("MTR797","06","Imprime Cod. Barras","�Imprime Cod.Barras ?","Print Barcode ?",;
"MV_CH6","N",1,0,2,"C","","","","","mv_par06","Sim","Si","Yes",,"Nao","No","No","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)                

aHelpPor := {'Considera a descri��o do produto por','descri��o cientifica ou generica ou o','que foi cadastrado no pedido de venda.'}
aHelpEng := {'Considera a descri��o do produto por','descri��o cientifica ou generica ou o','que foi cadastrado no pedido de venda.'}
aHelpSpa := {'Considera a descri��o do produto por','descri��o cientifica ou generica ou o','que foi cadastrado no pedido de venda.'}

PutSx1("MTR797","07","Descricao Produto","�Descripcion Producto ?","Product Description ?",;
"MV_CH7","N",1,0,3,"C","","","","","mv_par07","Descr.Cient.","Descr.Cient.","Scient.Descr.",,"Descr.Generica","Descr.Generica","General Descr.","Pedido Venda","Pedido Venda","Pedido Venda","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa) 

aHelpPor := {'Imprime as Ordens de Producao','Encerradas.'}
aHelpEng := {'Imprime as Ordens de Producao','Encerradas.'}
aHelpSpa := {'Imprime as Ordens de Producao','Encerradas.'}

PutSx1("MTR797","08","Impr. Op Encerrada","�Imprime OP Cerrada ?","Print Finished Prod. Order ?",;
"MV_CH8","N",1,0,1,"C","","","","","mv_par08","Sim","Si","Yes",,"Nao","No","No","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa) 

aHelpPor := {'Define se o relatorio sera impresso por ','ordem de Produto ou de Sequencia na','Estrutura.'}
aHelpEng := {'Define se o relatorio sera impresso por ','ordem de Produto ou de Sequencia na','Estrutura.'}
aHelpSpa := {'Define se o relatorio sera impresso por ','ordem de Produto ou de Sequencia na','Estrutura.'}

PutSx1("MTR797","09","Impr. Por Ordem de","�Impr. por Orden de ?","Print by ?",;
"MV_CH9","N",1,0,1,"C","","","","","mv_par09","Codigo","Codigo","Code",,"Sequencia"," Secuencia","Sequence","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)   

aHelpPor := {'Considera as OPs firmes, previstas ou','ambas do cadastro de OPs (SC2).'}
aHelpEng := {'Considera as OPs firmes, previstas ou','ambas do cadastro de OPs (SC2).'}
aHelpSpa := {'Considera as OPs firmes, previstas ou','ambas do cadastro de OPs (SC2).'}

PutSx1("MTR797","10","Considera Ops","�Considera OPs ?","Consid.Prod.Orders ?",;
"MV_CHA","N",1,0,1,"C","","","","","mv_par10","Firmes","Firmes","Confirmed",,"Previstas","Previstas","Estimated","Ambas","Ambas","Both","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)      

aHelpPor := {'Indica se imprime ou n�o itens negativos','empenhados.','O parametro MV_NEGESTR tambem sera','avaliado.'}
aHelpEng := {'Indica se imprime ou n�o itens negativos','empenhados.','O parametro MV_NEGESTR tambem sera','avaliado.'}
aHelpSpa := {'Indica se imprime ou n�o itens negativos','empenhados.','O parametro MV_NEGESTR tambem sera','avaliado.'}

PutSx1("MTR797","11","Item Neg. na Estrut","�Item Neg. en la Estruct. ?","Neg. Item in Structure ?",;
"MV_CHB","N",1,0,2,"C","","","","","mv_par11","Imprime","Imprime","Print",,"Nao Imprime","No Imprime","Do not print","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa) 

aHelpPor := {'Op��o para a impressao do produto com','rastreabilidade por Lote ou Sub-Lote.'}
aHelpEng := {'Op��o para a impressao do produto com','rastreabilidade por Lote ou Sub-Lote.'}
aHelpSpa := {'Op��o para a impressao do produto com','rastreabilidade por Lote ou Sub-Lote.'}

PutSx1("MTR797","12","Imprime Lote/S.Lote","�Imprime Lote/S.Lote ?","Print Lot/S.Lot ?",;
"MV_CHC","N",1,0,2,"C","","","","","mv_par12","Sim","Si","Yes",,"Nao","No","No","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa) 


Return
