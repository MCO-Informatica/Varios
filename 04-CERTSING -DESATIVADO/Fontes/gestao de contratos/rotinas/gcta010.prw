#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GCTA010    � Autor � Tatiana Pontes 	   � Data � 11/04/13  ���
�������������������������������������������������������������������������͹��
���Descricao � Liberacao de Pedido de Vendas                              ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign x Opvs                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GCTA010(cAlias,nReg,nOpc)

	Local oDlg
	Local aButtons		:= {}
	Local aCpos			:= {}    
	Local aIndex		:= {}
	Local nRegSC5		:= 0 
	Local nRegCNA		:= 0
	Local nHeight		:= oMainWnd:nClientHeight*.90
	Local nWidth		:= oMainWnd:nClientWidth*.98

	Private cNumPed		:= CND->CND_PEDIDO
  	Private lInverte 	:= .F. 
	Private cMarca 		:= GetMark(,"SC6","C6_OK")    
	Private aRecSC6		:= {}
	Private nTotMark 	:= 0
	Private oMarkSC6

	/*
	���������������������������������������������������������������������Ŀ
	� Verifica se existe pedido/itens para serem liberados                �
	�����������������������������������������������������������������������*/
		
	SC5->(dbSelectArea("SC5"))
	SC5->(dbSetOrder(1))
	If SC5->( MsSeek( xFilial("SC5")+cNumPed ) )
		nRegSC5 := SC5->(Recno())
	Else
	    MsgStop("N�o existe pedido de venda gerado para esta medi��o.")
	    Return
    Endif                                      
    
    If !Empty(SC5->C5_LIBEROK)
    	MsgStop("Pedido de venda "+cNumPed+" j� encontra-se liberado.")
	    Return
	Endif

	CN9->(dbSelectArea("CN9"))
	CN9->(dbSetOrder(1))
	If CN9->( MsSeek( xFilial("CN9")+CND->CND_CONTRA+CND->CND_REVISA ) )
		nRegCN9 := CNA->(Recno())
	Else
	    MsgStop("Contrato referente a esta medi��o n�o encontrado.")
	    Return
    Endif                                      
    
	/*
	���������������������������������������������������������������������Ŀ
	� Monta vetor para markbrowse                                         �
	�����������������������������������������������������������������������*/

	aAdd(aCpos,{"C6_OK",,,})
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SC6")
	While !Eof() .And. X3_ARQUIVO = "SC6"
		If X3_BROWSE=="S" .And. X3_CONTEXT != "V"
			AADD(aCpos,{X3_CAMPO,"",AllTrim(X3Titulo()),X3_PICTURE})
		EndIf
		dbSkip()
	End

	/*
	���������������������������������������������������������������������Ŀ
	� Filtra itens do pedido de vendas que nao foram liberados            �
	�����������������������������������������������������������������������*/
 
	GCT010Filtro()

	/*
	���������������������������������������������������������������������Ŀ
	� Tela de liberacao de itens do pedido de venda                       �
	�����������������������������������������������������������������������*/
	
	DEFINE MSDIALOG oDlg TITLE "Libera��o de Pedidos" FROM 0,0 TO nHeight, nWidth OF oMainWnd PIXEL
	
	Aadd(aButtons,{ "PEDIDO",{|| A410Visual("SC5",nRegSC5,1), GCT010Filtro() },,"Pedido" } )
		
	MsMGet():New("CN9",nRegCN9,nOpc,,,,,{15,0,(nHeight/4),(nWidth/2)},,3,,,,oDlg)

 	oMarkSC6 := MsSelect():New("SC6","C6_OK",,aCpos,@lInverte,@cMarca,{(nHeight/4),0,(nHeight/2)-15,(nWidth/2)})
	oMarkSC6:oBrowse:lCanAllMark	:=.T.
	oMarkSC6:oBrowse:lHasMark	 	:=.T.
	oMarkSC6:bMark 			 		:= {| | GCT010Mark()}
	oMarkSC6:oBrowse:bAllMark	 	:= {| | GCT010Inv()}

	ACTIVATE DIALOG oDlg ON INIT EnchoiceBar( oDlg, { || If(GCT010TOK(aRecSC6),oDlg:End(),Nil) },	;
					   													{ || oDlg:End() },,aButtons	 )
	/*
	���������������������������������������������������������������������Ŀ
	� Desfaz filtro e fecha tabelas                                       �
	�����������������������������������������������������������������������*/

	dbSelectArea("SC6")                                               
	RetIndex("SC6")
	dbClearFilter()
	AEval(aIndex,{|x| Ferase(x[1]+OrdBagExt())})

	dbCloseArea("SC5")
	dbCloseArea("SC6")	
	dbCloseArea("CND")
	
Return      

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GCT010INV  � Autor � Tatiana Pontes 	   � Data � 11/04/13  ���
�������������������������������������������������������������������������͹��
���Descricao � Inverte marcacao                                           ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign x Opvs                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GCT010Inv()

	Local nReg   := SC6->(Recno())
	Local cMarca := ThisMark()

	nTotMark := 0
	aRecSC6  := {}
		
	SC6->(DbGoTop())
	
	While !SC6->(Eof())
		RecLock("SC6",.F.)
		If C6_OK == cMarca
			SC6->C6_OK := "  "
		Else
			SC6->C6_OK := cMarca
			aAdd(aRecSC6,SC6->(Recno()))
			nTotMark ++
		Endif
	    SC6->(MsUnlock())
		SC6->(DbSkip())
	Enddo
	
	SC6->(DbGoTo(nReg))
	
	oMarkSC6:oBrowse:Refresh(.T.)    
	
Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GCT010MARK � Autor � Tatiana Pontes 	   � Data � 11/04/13  ���
�������������������������������������������������������������������������͹��
���Descricao � Marca itens selecionados                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign x Opvs                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GCT010Mark()

	Local nPosRec	:= 0
	
	If SC6->(IsMark("C6_OK",ThisMark(),ThisInv()))
		nTotMark ++
		aAdd(aRecSC6,SC6->(Recno()))
	Else
		nTotMark --
		nPosRec := aScan(aRecSC6,SC6->(Recno()))
		If nPosRec > 0
			aDel(aRecSC6,nPosRec)
			aSize(aRecSC6,Len(aRecSC6)-1)
		EndIf
	EndIf
	
	SC6->(MsUnlock())
		
	oMarkSC6:oBrowse:Refresh(.T.)
	
Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GCT010TOK  � Autor � Tatiana Pontes 	   � Data � 11/04/13  ���
�������������������������������������������������������������������������͹��
���Descricao � Valida processamento de itens selecionados                 ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign x Opvs                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GCT010Tok()

	Local lRet := .T.

	If nTotMark == 0
		MsgStop("N�o h� itens selecionados para serem liberados.")
		lRet := .F.
	EndIf

	/*
	���������������������������������������������������������������������Ŀ
	� Nao houve problemas com validacoes, chama a funcao de gravacao      �
	�����������������������������������������������������������������������*/

	If lRet 
		Begin Transaction
			lRet := GCT010Proc()
		End Transaction
	EndIf
	
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GCT010PROC � Autor � Tatiana Pontes 	   � Data � 11/04/13  ���
�������������������������������������������������������������������������͹��
���Descricao � Processa itens selecionados                                ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign x Opvs                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GCT010Proc()

 
	Local cReg 		:= ""
	Local nI 		:= 0
	Local lRet		:= .F.

	Local nQtdLib	:= 0
	Local lCredito	:= .T.
	Local lEstoque	:= .T.
	Local lLiber	:= .T.
	Local lTransf 	:= .F.      

	Local lAvEst
		
	If !MsgYesNo("Confirma o processamento dos registros marcados?")
		Return
	Endif

    If GetMv("MV_ESTNEG") == "S" // Aceita saldo em estoque negativo (S/N)
      lAvEst := .F.
    Else
      lAvEst := .T.
    Endif

	For nI := 1 to Len(aRecSC6)

		SC6->(dbSelectArea("SC6"))
		SC6->(dbGoTo(aRecSC6[nI]))

	    dbSelectArea("SC9")
		If !dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)
	        nQtdLib := SC6->C6_QTDVEN
	        nQtdLib := MaLibDoFat(SC6->(RecNo()),nQtdLib,@lCredito,@lEstoque,.F.,lAvEst,lLiber,lTransf)  
			cReg += "Pedido: " + SC6->C6_NUM + " - Item: " + SC6->C6_ITEM + Chr(13) + Chr(10)
	        lRet := .T.
		Endif

	Next nI

	If lRet
		Begin Transaction
			SC6->(MaLiberOk({SC6->C6_NUM},.F.))
		End Transaction
		MsgInfo("Os itens processados foram: "+Chr(13)+Chr(10)+cReg)
	Endif
		     
Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GCT010PROC � Autor � Tatiana Pontes 	   � Data � 11/04/13  ���
�������������������������������������������������������������������������͹��
���Descricao � Filtro na tabela de itens de pedido de vendas              ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign x Opvs                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GCT010Filtro()

	Local aIndex 		:= {}
	Local cFiltro 		:= ""

	cFiltro	:= "C6_NUM == '"+cNumPed+"' .AND. "
	cFiltro	+= "C6_QTDVEN > (C6_QTDEMP + C6_QTDENT)"
	bFiltraBrw := {|| FilBrowse("SC6",@aIndex,@cFiltro)}
	Eval(bFiltraBrw)
			
Return