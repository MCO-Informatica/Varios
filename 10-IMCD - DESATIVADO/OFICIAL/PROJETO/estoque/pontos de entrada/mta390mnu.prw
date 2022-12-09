#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA390MNU�Autor  �Microsiga           � Data �  04/06/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MATA390 - Manuten��o de lotes                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MTA390MNU()

aAdd( aRotina, {"Alt.Vld.Esp." ,"U_ALTVLDL"  ,0 , 4, 0 , nil }	)
AAdd( aRotina, { "Observa��o Lote", "U_IMCDOBSLOTE", 0, 4,0,nil} )  //"Observa��o Lote"

Return()


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MCFGXFUN  �Autor  �Microsiga           � Data �  04/06/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ALTVLDL(cAlias,nReg,nOpc,dNewDtVld,lBxCQ)

Local nOrder     := IndexOrd()
Local dDataValid := dDatabase
Local lUsaLote   := IIf(GetMV("MV_RASTRO")== "S",.T.,.F.)
Local lUnlock    := .F.
Local lRet       := .T.
Local lRetPE     := .T.
Local nSaldoB8   := 0
Local aObjects   := {}
Local aPosObj    :={}
Local aSize      := MsAdvSize()
Local aInfo      := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
Local lEmpPrev   := If(SuperGetMV("MV_QTDPREV")== "S",.T.,.F.)
Local bCompSBF, bCompSDC, bCompSDC2
Local bComparaSBF, cChaveSBF
Local nTotEmpSDD, nTotSaldoSB8
Local oDlg,oQual, nOpca
Local cCampo, nInd, oGet

//���������������������������������������������������������������Ŀ
//� MV_A175VLD - Parametro utilizado para verificar se o usuario  |
//|              podera realizar a altera��o da data de validade  |
//|              do lote atraves da rotina de Baixas do CQ.       |
//�����������������������������������������������������������������
Local lA175Vld   :=	SuperGetMv("MV_A175VLD",.F.,.F.)	.And.;
SD7->(FieldPos("D7_DTVALID")) > 0
//���������������������������������������������������������������Ŀ
//� Walk-Thru						                              �
//�����������������������������������������������������������������
Local aYesFields := {	"B8_LOTECTL","B8_PRODUTO",;
"B8_LOCAL"  ,"B8_DTVALID",;
"B8_SALDO"  ,"B8_EMPENHO",;
"B8_QTDORI" }
Local bSeekWhile := {} //Condicao While para montar o aCols
Local cSeek		 := ""

Private aLotes     := {}
Private aRecno     := {}
Private aRecnoSDD  := {}
Private aRecnoSDC  := {}
Private aRecnoSBF  := {}
Private aHeader    := {}
Private aCols      := {}
Private CurLen     := 0
Private nPosAtu    := 0
Private nPosAnt    := 9999
Private nColAnt    := 9999
Private cSavScrVT,cSavScrVP,cSavScrHT,cSavScrHP

Default dNewDtVld:= CTOD("  /  /  ")

If !lUsaLote
	Help(" ", 1,"NAOLOTE")
EndIf

If !Rastro(SD5->D5_PRODUTO)
	Help(" ",1,"NAORASTRO")
	Return
EndIf

//���������������������������������������������������������������Ŀ
//� MV_A175VLD - Parametro utilizado para verificar se o usuario  |
//|              podera realizar a altera��o da data de validade  |
//|              do lote atraves da rotina de Baixas do CQ.       |
//�����������������������������������������������������������������
If lA175Vld .And. !lBxCQ
	Help( " ", 1, "A390DTVAL" )
	Return(.T.)
EndIf

Set Key VK_F12 To

Pergunte("MTA390",.F.)

// ** Recupera rastreabilidade por lote ou sublote
If Rastro(SD5->D5_PRODUTO,"S")
	If mv_par01 == 1
		cSeek 	   := xFilial( "SB8" ) + SD5->D5_PRODUTO + SD5->D5_LOCAL + SD5->D5_LOTECTL + SD5->D5_NUMLOTE
		bSeekWhile := { || B8_FILIAL + B8_PRODUTO + B8_LOCAL + B8_LOTECTL + B8_NUMLOTE }
	Else
		cSeek	   := xFilial( "SB8" ) + SD5->D5_PRODUTO + SD5->D5_LOTECTL + SD5->D5_NUMLOTE
		bSeekWhile := { || B8_FILIAL + B8_PRODUTO + B8_LOTECTL + B8_NUMLOTE }
	EndIf
ElseIf Rastro(SD5->D5_PRODUTO,"L")
	If mv_par01 == 1
		cSeek	   := xFilial( "SB8" ) + SD5->D5_PRODUTO + SD5->D5_LOCAL + SD5->D5_LOTECTL
		bSeekWhile := { || B8_FILIAL + B8_PRODUTO + B8_LOCAL + B8_LOTECTL }
	Else
		cSeek	   := xFilial( "SB8" ) + SD5->D5_PRODUTO + SD5->D5_LOTECTL
		bSeekWhile := { || B8_FILIAL + B8_PRODUTO + B8_LOTECTL }
	EndIf
EndIf
dbSelectArea("SB8")
If mv_par01 == 1
	dbSetOrder(3)
Else
	dbSetOrder(5)
EndIf

If dbSeek(cSeek)
	//�����������������������������Ŀ
	//� Acerta a data de validade   |
	//�������������������������������
	If lBxCQ
		dDataValid:= dNewDtVld
	Else
		dDataValid:=SB8->B8_DTVALID
	EndIF
	//����������������������������������������������������������������������������������������Ŀ
	//� Monta aHeader e aCols utilizando a funcao FillGetDados c/ lotes a serem reavaliados    �
	//������������������������������������������������������������������������������������������
	
	//����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ
	//� Sintaxe da FillGetDados( nOpcx, cAlias, nOrder, cSeekKey, bSeekWhile, uSeekFor, aNoFields, aYesFields, lOnlyYes, cQuery, bMontCols, lEmpty, aHeaderAux, aColsAux, bAfterCols, bBeforeCols, bAfterHeader, cAliasQry ) |
	//������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
	FillGetDados(2,"SB8",If(mv_par01==1,3,5),cSeek,bSeekWhile,{||.T.},,aYesFields,,,,,,,{|| a390AfterC(nOpc,@nSaldoB8,lEmpPrev,@aRecno)} )
	
EndIf

If Len(aCols) = 0
	Help( " ", 1, "VAZIO" )
Else
	If Rastro(SD5->D5_PRODUTO,"S")
		If mv_par01 == 1
			cSeekDD  := xFilial( "SDD" ) + SD5->D5_PRODUTO + SD5->D5_LOCAL + SD5->D5_LOTECTL + SD5->D5_NUMLOTE
			bBlockDD := { || DD_FILIAL + DD_PRODUTO + DD_LOCAL + DD_LOTECTL + DD_NUMLOTE == cSeekDD }
		Else
			cSeekDD  := xFilial( "SDD" ) + SD5->D5_PRODUTO + SD5->D5_LOTECTL + SD5->D5_NUMLOTE
			bBlockDD := { || DD_FILIAL + DD_PRODUTO + DD_LOTECTL + DD_NUMLOTE == cSeekDD }
		EndIf
	ElseIf Rastro(SD5->D5_PRODUTO,"L")
		If mv_par01 == 1
			cSeekDD  := xFilial( "SDD" ) + SD5->D5_PRODUTO + SD5->D5_LOCAL + SD5->D5_LOTECTL
			bBlockDD := { || DD_FILIAL + DD_PRODUTO + DD_LOCAL + DD_LOTECTL == cSeekDD }
		Else
			cSeekDD  := xFilial( "SDD" ) + SD5->D5_PRODUTO + SD5->D5_LOCAL + SD5->D5_LOTECTL
			bBlockDD := { || DD_FILIAL + DD_PRODUTO + DD_LOCAL + DD_LOTECTL == cSeekDD }
		EndIf
	EndIf
	dbSelectArea("SDD")
	dbSetOrder(If(mv_par01==1,2,3))
	dbSeek(cSeekDD)
	nTotSaldoDD := 0
	While !Eof() .And. Eval(bBlockDD)
		If DD_MOTIVO = "VV"
			nTotSaldoDD += DD_SALDO
			//��������������������Ŀ
			//� Faz a trava do SDC �
			//����������������������
			dbSelectArea( "SDC" )
			dbSetOrder( 1 )
			cChaveSDC:=xFilial("SDC")+SDD->DD_PRODUTO+SDD->DD_LOCAL+"SDD"+SDD->DD_DOC+CriaVar("DC_ITEM")
			bCompSDC:={|| cChaveSDC == DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+DC_ITEM}
			If Rastro( SDD->DD_PRODUTO, "S" )
				bCompSDC2 := { || SDD->DD_NUMLOTE == DC_NUMLOTE }
			Elseif Rastro( SDD->DD_PRODUTO, "L" )
				bCompSDC2 := { || SDD->DD_LOTECTL == DC_LOTECTL }
			EndIf
			dbSeek(cChaveSDC)
			While !Eof() .And. Eval( bCompSDC )
				If Eval( bCompSDC2 )
					RecLock( "SDC", .f. )
					AAdd( aRecnoSDC, Recno() )
				EndIf
				//�������������������������������������������������Ŀ
				//� Se mudou o lote faz a trava de registros no SBF �
				//���������������������������������������������������
				cChaveSBF  := xFilial("SBF")+DC_PRODUTO+DC_LOCAL+DC_LOTECTL+If(Rastro(DC_PRODUTO,"S"),DC_NUMLOTE,"")
				bComparaSBF:= { || cChaveSBF ==	BF_FILIAL+BF_PRODUTO+BF_LOCAL+BF_LOTECTL+IF(Rastro(SDC->DC_PRODUTO,"S"),BF_NUMLOTE,"")}
				dbSelectArea( "SBF" )
				dbSetOrder( 2 )
				dbSeek( cChaveSBF )
				While !Eof() .And. Eval( bComparaSBF )
					RecLock("SBF",.F.)
					AADD(aRecnoSBF, Recno() )
					dbSkip()
				EndDo
				dbSelectArea("SDC")
				dbSkip()
			EndDo
			DbSelectArea("SDD")
		EndIf
		AADD(aRecnoSDD,Recno())
		DbSelectArea("SDD")
		dbSkip()
	EndDo
	dbSelectArea("SB8")
	
	lUnlock := .T.
	
	If lBxCQ
		nOpca := 2
	Else
		AADD(aObjects,{100,100,.T.,.T.,.F.})
		AADD(aObjects,{100,030,.T.,.F.,.F.})
		aPosObj:=MsObjSize(aInfo,aObjects)
		
		cCadastro := "Alteracao de lotes"
		nOpca := 0
		DEFINE MSDIALOG oDlg TITLE cCadastro OF oMainWnd PIXEL FROM aSize[7],0 TO aSize[6],aSize[5]
		@ 0.5 , 00 TO aPosObj[1,3],aPosObj[1,4] LABEL OemtoAnsi("  Lotes afetados  ") OF oDlg
		@ aPosObj[2,1]+2.8,10 SAY OemtoAnsi("Data Validade")  SIZE 63, 9 OF oDlg PIXEL
		@ aPosObj[2,1]+2,75 MSGET dDataValid SIZE 40,  9 OF oDlg PIXEL
		oGet := MSGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],2,"Allwaystrue","Allwaystrue","",.F.,{})
		
		DEFINE SBUTTON FROM aPosObj[2,1]+2,aPosObj[2,4]-60 TYPE 1 ACTION (nOpca :=2,oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM aPosObj[2,1]+2,aPosObj[2,4]-30 TYPE 2 ACTION (nOpca :=1,oDlg:End()) ENABLE OF oDlg
		
		ACTIVATE MSDIALOG oDlg
		
	EndIf
	
	//�������������������������������������������������������������������Ŀ
	//� Execblock MT390VLV para Validar a Validade (O Ret.pode ser L�gico)�
	//���������������������������������������������������������������������
	If nOpcA == 2 .And. ExistTemplate('MT390VLV')
		lRet  := If(ValType(lRetPE:=ExecTemplate('MT390VLV',.F.,.F.))=='L',lRetPE,.T.)
		nOpcA := If(lRet,2,1)
	EndIf
	
	If nOpcA == 2 .And. ExistBlock('MT390VLV')
		lRet  := If(ValType(lRetPE:=ExecBlock('MT390VLV',.F.,.F.))=='L',lRetPE,.T.)
		nOpcA := If(lRet,2,1)
	EndIf
	
	If nOpca == 2
		A390PrcVal(dDataValid,nTotSaldoDD)
	EndIf
	
EndIf

If lUnLock
	nInd := 1
	While nInd <= Len(aRecno)
		dbSelectArea("SB8")
		dbGoTO(aRecno[nInd])
		MSUnLock()
		nInd++
	EndDo
EndIf

If !lBxCQ
	Set Key VK_F12 To MTA390PERG()
EndIf

dbSelectArea(cAlias)
dbSetOrder(nOrder)
dbGoTo(nReg)
Return (.T.)



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �a390AfterC� Autor � Ricardo Berti         � Data � 02/01/07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Tratamento de excecoes na montagem automatica do aCols pela���
���          � FillGetDados, executada APOS gerar cada elemento do aCols. ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �ExpL1 := a390AfterC(ExpN1,ExpN2,ExpL2,ExpA1)				  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpN1 = Numero da opcao selecionada                        ���
���          � ExpN2 = Var. para carga do saldo do produto			 	  ���
���          � ExpL2 = .T. se parametro "MV_QTDPREV" ativado			  ���
���          � ExpA1 = Array contendo os registros do SB8  	              ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � ExpL1 = .F. aborta a FillGetDados (montagem do aCols)  	  ���
���          �         .T. continua a montagem do aCols pela FillGetDados ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA390                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function a390AfterC(nOpc,nSaldoB8,lEmpPrev,aRecno)

Local lRet := (nOpc<>2)
If lRet
	Reclock("SB8",.F.)
	AADD(aRecno,Recno())
	nSaldoB8 += SB8SALDO(,,,,,lEmpPrev,,,.T.)
EndIf
Return (lRet)
