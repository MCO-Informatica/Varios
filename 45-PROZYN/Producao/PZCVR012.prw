#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

//#DEFINE OP		 	1
#DEFINE IDIOMA 		4
/*#DEFINE QTDETIQUETA	3
#DEFINE PESO		4
#DEFINE UNIDMEDIDA	5
#DEFINE REIMPRIMIR	6
#DEFINE ETIQUETADE	7
#DEFINE ETIQUETAATE	8*/


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �PZCVR012		�Autor  �Microsiga	     � Data �  21/11/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Impressao do novo Rotulo							 	      ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PZCVR012()

	Local aArea		:= GetArea()
	Local aParam	:= {}

	If ExistBlock("PZROTNO")
	   ExecBlock("PZROTNO",.F.,.F.)
	EndIf

	If PergRel(@aParam)
		Processa( {|| ProcRel(aParam) },"Aguarde...","" )

	EndIf
	RestArea(aArea)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �ProcRel		�Autor  �Microsiga	     � Data �  21/11/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Processamento do relatorio						 	      ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ProcRel(aParam)

	Local aArea			:= GetArea()
	Local oPrint 		:= Nil
	Local cArqTmp		:= ""
	Local nX			:= 0
	Local nQtdEtiq		:= 0
	Local cCodEtiq		:= ""
	Local nRotuloIni	:= 1
	Local nRotuloFin	:= 1
	Local lIniObj		:= .F.
	Local nMaxEtiq		:= 0
	Local cQuery		:= ""
	Private _cOp 		:= ""
	Default aParam 		:= {}
	
	
	//Dados do relatorio

	If _nOpc == 1
		_cOP := aParam[1]
	ElseIf _nOpc == 2
		_cOp := aParam[1]
	ElseIf _nOpc == 3
		_cOp := POSICIONE("CB0",1,xFilial("CB0")+aParam[1],"CB0_OP")
	ElseIf _nOpc == 4
		_cOp := aParam[1]
	ElseIf _nOpc == 5
		_cOp := aParam[1]
	Endif
	
	cArqTmp := GetCArqD(_cOP)
	
	If (cArqTmp)->(!Eof())

		//Quantidade de etiquetas a serem impressas
		nQtdEtiq := GetQtdEtiq(aParam, cArqTmp)

		//Verifica se � reimpress�o
		If _nOpc == 2 
			nRotuloIni	:= aParam[2]
			nRotuloFin	:= aParam[3]

			//Atualiza as variaveis com o a impress�o do rotulo de/ate
			GetReimp((cArqTmp)->(C2_NUM+C2_ITEM+C2_SEQUEN), (cArqTmp)->C2_LOTECTL, (cArqTmp)->C2_PRODUTO, @nRotuloIni, @nRotuloFin)
			
			//Impress�o do rotulo at�
			nQtdEtiq 	:= nRotuloFin
			nMaxEtiq	:= GetQtdMax((cArqTmp)->(C2_NUM+C2_ITEM+C2_SEQUEN), (cArqTmp)->C2_LOTECTL, (cArqTmp)->C2_PRODUTO) //Quantidade maxima de etiquetas
			
			If nRotuloIni == 0 .And. nRotuloFin == 0
				Aviso("Aten��o","Nenhum item encontrado para reimpress�o.",{"Ok"},2)
				Return
			EndIf

		ElseIf _nOpc == 3
			nRotuloIni	:= aParam[5]
			nRotuloFin	:= aParam[6]
			cCodEtiq	:= aParam[1]

			//Atualiza as variaveis com o a impress�o do rotulo de/ate
			//GetReimp((cArqTmp)->(C2_NUM+C2_ITEM+C2_SEQUEN), (cArqTmp)->C2_LOTECTL, (cArqTmp)->C2_PRODUTO, @nRotuloIni, @nRotuloFin)
			
			//Impress�o do rotulo at�
			nQtdEtiq 	:= 1
			nMaxEtiq	:= 1						//GetQtdMax((cArqTmp)->(C2_NUM+C2_ITEM+C2_SEQUEN), (cArqTmp)->C2_LOTECTL, (cArqTmp)->C2_PRODUTO) //Quantidade maxima de etiquetas
			
			If nRotuloIni == 0 .And. nRotuloFin == 0
				Aviso("Aten��o","Nenhum item encontrado para reimpress�o.",{"Ok"},2)
				Return
			EndIf
		
		ElseIf _nOpc == 4
			nRotuloIni	:= 1
			nRotuloFin	:= 1

			cQuery	:= " SELECT MAX(CB0_YSEQEM) AS CB0_YSEQEN FROM "+RetSqlName("CB0")+" CB0 "+CRLF
			cQuery	+= " WHERE CB0_FILIAL = '"+xFilial("CB0")+"' "+CRLF
			cQuery	+= " AND CB0_OP = '"+_cOp+"' "+CRLF
			cQuery	+= " AND CB0.D_E_L_E_T_ = ' ' "+CRLF

			DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , "nSeq",.T.,.T.)
			
			If nSeq->( !Eof())
        		nRotuloIni := nSeq->CB0_YSEQEN  
    		EndIf
			nSeq->(dbCloseArea())
			
			nRotuloFin 	:= nRotuloIni + aParam[5]
			nQtdEtiq 	:= nRotuloIni + aParam[5]
			nMaxEtiq	:= nQtdEtiq
			//Atualiza as variaveis com o a impress�o do rotulo de/ate
			//GetReimp((cArqTmp)->(C2_NUM+C2_ITEM+C2_SEQUEN), (cArqTmp)->C2_LOTECTL, (cArqTmp)->C2_PRODUTO, @nRotuloIni, @nRotuloFin)
			
			//Impress�o do rotulo at�
			//nQtdEtiq 	:= nRotuloIni + aParam[5] 
			//nMaxEtiq	:= GetQtdMax((cArqTmp)->(C2_NUM+C2_ITEM+C2_SEQUEN), (cArqTmp)->C2_LOTECTL, (cArqTmp)->C2_PRODUTO) //Quantidade maxima de etiquetas
			
			If nRotuloIni == 0 .And. nRotuloFin == 0
				Aviso("Aten��o","Nenhum item encontrado para reimpress�o.",{"Ok"},2)
				Return
			EndIf
		ElseIf _nOpc == 5
			nRotuloIni	:= aParam[6]
			nRotuloFin	:= aParam[7]
			nQtdEtiq	:= aParam[5]

			If nMaxEtiq == 0 .Or. nMaxEtiq < nQtdEtiq
				nMaxEtiq := nQtdEtiq
				nMaxEtiq := GetQtdMax((cArqTmp)->(C2_NUM+C2_ITEM+C2_SEQUEN), (cArqTmp)->C2_LOTECTL, (cArqTmp)->C2_PRODUTO) //Quantidade maxima de etiquetas

				If nRotuloIni == 0 .And. nRotuloFin == 0
					Aviso("Aten��o","Nenhum item encontrado para reimpress�o.",{"Ok"},2)
					Return
				EndIf
			EndIf
		Else
			nRotuloIni	:= 1
			nMaxEtiq	:= GetQtdMax((cArqTmp)->(C2_NUM+C2_ITEM+C2_SEQUEN), (cArqTmp)->C2_LOTECTL, (cArqTmp)->C2_PRODUTO) //Quantidade maxima de etiquetas //Quantidade maxima de etiquetas
			
			If nMaxEtiq == 0 .Or. nMaxEtiq < nQtdEtiq
				nMaxEtiq := nQtdEtiq
			EndIf
	
		EndIf
		

		//Contador da barra de progresso
		ProcRegua(nQtdEtiq)
		If _nOpc <> 3
			If  nRotuloIni == 0
		   		nRotuloIni := 1
			EndIf 
			//Impress�o das etiquetas
			For nX := nRotuloIni To nQtdEtiq

				IncProc("Processando...")

				If !lIniObj
					lIniObj := .T.
					//Inicia o objeto de impressao
					oPrint := GetIniObj((cArqTmp)->C2_PRODUTO)
				EndIf

				//Codio da etiqueta do ACD
				If _nOpc == 5
					cCodEtiq := Substr(((cArqTmp)->B1_CODBAR),1, 10)
					//ImpLayout(@oPrint, aParam, cArqTmp, nX, nMaxEtiq, cCodEtiq)
				Else
					cCodEtiq := ""
					cCodEtiq := GerCdEtAcd(cArqTmp, aParam, Alltrim(Str(nX)))
				EndIf

				//Imprime o layout do rotulo
				ImpLayout(@oPrint, aParam, cArqTmp, nX, nMaxEtiq, cCodEtiq)
			Next
		Else
			If _nOpc == 3
			DbSelectArea("CB0")
			DbSetOrder(1)
				IF CB0->(DbSeek(xFilial("CB0")+cCodEtiq))
					RecLock("CB0", .F.)
					oPrint := GetIniObj((cArqTmp)->C2_PRODUTO)
					cCodEtiq := aParam[1]
					CB0->CB0_QTDE := aParam[2]
					MsUnLock() //Confirma e finaliza a opera��o
					ImpLayout(@oPrint, aParam, cArqTmp, nX, nMaxEtiq, cCodEtiq)
				EndIf	
			Endif
		EndIf

		//Envia para impressora 
		oPrint:print()

		//Libera o objeto da impress�o e encerra o processo
		FreeObj(oPrint)	

	Else
		Aviso("Aten��o", "Nenhum registro encontrado",{"Ok"},2)
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GerCdEtAcd	�Autor  �Microsiga	     � Data �  21/11/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Gera o codigo das etiquetas do ACD				 	      ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GerCdEtAcd(cArqTmp, aParam, cSeq)

	Local aArea		:= GetArea()
	Local cRet		:= ""
	Local cCodEtiq	:= ""
	Local nQtdEtiq 	:= 0

	Default cArqTmp	:= "" 
	Default aParam	:= {}
	Default cSeq	:= ""

	//cCodEtiq := GerCdEtAcd(cArqTmp, aParam, Alltrim(Str(nX)))

	
	//Recupera o codigo da etiqueta se existir
	cCodEtiq := GetCodEti((cArqTmp)->(C2_NUM+C2_ITEM+C2_SEQUEN), (cArqTmp)->C2_PRODUTO, (cArqTmp)->C2_LOTECTL, cSeq) 

	//Verifica se Ja Existe Cadastro da tabela CB0. Sen�o existir ser� criado.
	If Empty(cCodEtiq)
		If LEFT(aParam[3],1) == "1"
			If aParam[2] == 0
				nQtdEtiq := (cArqTmp)->B1_PESO
			Else
				nQtdEtiq := aParam[2]
			EndIf
		Else
			nQtdEtiq := (cArqTmp)->B1_QE
		EndIf
		//Realiza a grava��o da tabela CB0

		//(cArqTmp)->B1_QE, ; 					//Quantidade
		GravaCB0((cArqTmp)->C2_PRODUTO,;		//Produto 
		nQtdEtiq,; 								//Quantidade
		"",; 									//Usuario
		"",; 									//Nf de Entrada
		"",; 									//Serie de Entrada
		"",; 									//Codigo do fornecedor
		"",; 									//Loja
		"",;									//Pedido compra
		"",; 									//Localiza��o
		(cArqTmp)->C2_LOCAL, ;					//Armazem
		(cArqTmp)->(C2_NUM+C2_ITEM+C2_SEQUEN),; //Codigo da OP
		"",; 									//Sequencia
		"",; 									//Nf de Saida
		"",; 									//Serie de Saida
		"",; 									//Etiqueta do cliente
		(cArqTmp)->C2_LOTECTL,; 				//Lote
		"",;									//Sub lote
		STOD((cArqTmp)->C2_DTVALID),; 			//Data de validade
		"")									//Centro de custo 

		//Grava a sequencia da embalagem na tabela CB0 se n�o existir
		GravaSeqEti((cArqTmp)->(C2_NUM+C2_ITEM+C2_SEQUEN), (cArqTmp)->C2_LOTECTL, (cArqTmp)->C2_PRODUTO, Val(cSeq))

		//Recupera o codigo da etiqueta
		cCodEtiq := GetCodEti((cArqTmp)->(C2_NUM+C2_ITEM+C2_SEQUEN), (cArqTmp)->C2_PRODUTO, (cArqTmp)->C2_LOTECTL, cSeq) 
		EndIf
	

	If !Empty(cCodEtiq)
		cRet := cCodEtiq
	EndIf 



	RestArea(aArea)
Return cRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GetIniObj		�Autor  �Microsiga	     � Data �  30/10/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna o objeto com os dados da impressora		 	      ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetIniObj(cCodProd)

	Local aArea		:= GetArea()
	Local cNomeArq	:= "PZCVR012"+DtoS(MsDate())+STRTRAN(Time(), ":", "")
	Local oPrint	:= Nil
	Local cNomImp	:= ""
	Local cSession	:= GetPrinterSession()

	Default cCodProd := ""

	//Nome da impressora
	cNomImp := GetNomeImp(cCodProd)
	//cNomImp 	:= "CutePDF Writer"//Retirar

	If !Empty(cNomImp)

		fwWriteProfString( cSession, "LOCAL"    	,"CLIENT"    , .T. )
		fwWriteProfString( cSession, "PRINTTYPE"	,"SPOOL" 	 , .T. )
		fwWriteProfString( cSession, "ORIENTATION"	,"LANDSCAPE" , .T. )
		fwWriteProfString( cSession, "DEFAULT"		, cNomImp, .T.)	

		oPrint 	:= FWMSPrinter():New(cNomeArq,,.F.,,.T.,,,)
		oPrint:SetLandscape()	
	EndIf

	RestArea(aArea)
Return oPrint

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �ImpLayout		�Autor  �Microsiga	     � Data �  30/10/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Imprime o layout									 	      ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImpLayout(oPrint, aParam, cArqTmp, nEtiPos, nQtdEtiq, cCodEtiq)

	Local aArea		:= GetArea()
	Local oFnt32n	:= TFont():New("Arial Black",,32 ,,.T.,,,,,.F.,.F.)
	Local oFnt10	:= TFont():New("Arial",,10 ,,.F.,,,,,.F.,.F.)
	Local oFnt12	:= TFont():New("Arial",,12 ,,.F.,,,,,.F.,.F.)
	Local oFnt12n	:= TFont():New("Arial",,12 ,,.T.,,,,,.F.,.F.)
	//Local oFnt22n	:= TFont():New("Arial",,17 ,,.T.,,,,,.F.,.F.)
	Local oFnt22n	:= TFont():New("Arial",,22 ,,.T.,,,,,.F.,.F.)
	Local nLinha	:= 140
	Local nX		:= 0
	Local lPulaLin	:= .F.
	Local nEntrLin	:= 15
	Local cFrAlert	:= ""
	
	Default nPesTdo		:= POSICIONE("CB0",7,xFilial("CB0")+aParam[1],"CB0_QTDE")
	Default aParam 		:= {}
	Default cArqTmp		:= ""
	Default nEtiPos		:= 0
	Default nQtdEtiq	:= 0
	Default cCodEtiq	:= ""

	//Inicia a pagina
	oPrint:StartPage()

	//Descri��o do produto
	//oPrint:Box( 98, 0, 360, 800, "-8")
	cNomImp := GetNomeImp((cArqTmp)->C2_PRODUTO)
	If Upper('Branca') $ Upper(Trim(cNomImp))
		cProduto := GetDXImp("1", cArqTmp, aParam)
		If len(cProduto) > 36
			oPrint:SayAlign(50, 0000, 	cProduto, oFnt32n, 800 ,0090,,2,1)//Descri��o do produto
		Else
			oPrint:SayAlign(80, 0000, 	cProduto, oFnt32n, 800 ,0060,,2,0)//Descri��o do produto
		EndIf
	Else
	oPrint:SayAlign(80, 0000, GetDXImp("1", cArqTmp, aParam)	, oFnt32n, 800 ,0060,,2,0)//Descri��o do produto
	EndIf
	oPrint:Line(123, 0, 123, 800,0,"-8")

	//Lote
	oPrint:SayAlign(130, 0,GetLabel("1", aParam), oFnt10 	, 800,0060,,0,1)//Label Lote
	oPrint:SayAlign(140, 0,Alltrim((cArqTmp)->C2_LOTECTL)			, oFnt22n 	, 800,0060,,0,1)//Lote

	//Codigo do produto
	oPrint:SayAlign(130, 85,GetLabel("2", aParam)     		, oFnt10 	, 800,0060,,0,1) //Label codigo do produto
	oPrint:SayAlign(140, 85,Alltrim((cArqTmp)->B1_COD)				, oFnt22n 	, 800,0060,,0,1) //Codigo do produto

	//Conteudo
	oPrint:SayAlign(130, 170,GetLabel("3", aParam, cArqTmp)	, oFnt10 	, 800,0060,,0,1)//Label Conteudo
	If _nOpc <> 2
		oPrint:SayAlign(140, 170,GetDXImp("2", cArqTmp, aParam)	, oFnt22n 	, 800,0060,,0,1)//Peso
	Else
		oPrint:SayAlign(140, 170,GetDXImp("2", nPesTdo)	, oFnt22n 	, 800,0060,,0,1)//Peso
	EndIf

	oPrint:SayAlign(130, 275,GetLabel("4", aParam)     			, oFnt10 	, 800,0060,,0,1)//Fabrica��o
	oPrint:SayAlign(140, 275,DTOC(STOD((cArqTmp)->C2_EMISSAO))	, oFnt22n 	, 800,0060,,0,1)//Data de fabrica��o

	oPrint:SayAlign(130, 385,GetLabel("5", aParam)				, oFnt10 	, 800,0060,,0,1)//Validade
	oPrint:SayAlign(140, 385,DTOC(STOD((cArqTmp)->C2_DTVALID))	, oFnt22n 	, 800,0060,,0,1)//Data de validade 
	
	If _nOpc == 3
		nEtiPos  := aParam[5]
		nQtdEtiq := aParam[6]
		oPrint:SayAlign(130, 485,"#EMB"     						, oFnt10 	, 800,0060,,0,1)//Emabalem
		oPrint:SayAlign(140, 485,Alltrim(Str(nEtiPos))+"/"+Alltrim(Str(nQtdEtiq))	, oFnt22n 	, 800,0060,,0,1)//Etiqueta de/ate
	Else
		oPrint:SayAlign(130, 485,"#EMB"     						, oFnt10 	, 800,0060,,0,1)//Emabalem
		oPrint:SayAlign(140, 485,Alltrim(Str(nEtiPos))+"/"+Alltrim(Str(nQtdEtiq))	, oFnt22n 	, 800,0060,,0,1)//Etiqueta de/ate
	EndIf

	nLinha += 30
	oPrint:SayAlign(nLinha, 0,GetLabel("6", aParam)								, oFnt12n 	, 800,0060,,0,1)//Descri��o
	oPrint:SayAlign(nLinha, 85,GetDXImp("3", cArqTmp, aParam)					, oFnt12 	, 800,0060,,0,1)//Dados da descri��o

	nLinha += nEntrLin
	oPrint:SayAlign(nLinha, 0,GetLabel("7", aParam)     								, oFnt12n 	, 800,0060,,0,1)//Composi��o

	//Dados da composi��o - Quebra de linha
	For nX := 1 To MLCount(Alltrim((cArqTmp)->ZO_DESC),70)
		oPrint:SayAlign(nLinha, 85,MemoLine(Alltrim((cArqTmp)->ZO_DESC),70,nX)	, oFnt12 	, 800,0060,,0,1)//Descri��o da composi��o
		nLinha += nEntrLin
		lPulaLin := .T.
	Next

	If !lPulaLin
		nLinha += nEntrLin
		lPulaLin := .F.
	EndIF

	If !Empty((cArqTmp)->B1_HALAL)
		oPrint:SayAlign(nLinha, 0,GetLabel("8", aParam)     		, oFnt12n 	, 800,0060,,0,1)//Certificado HALAL
		oPrint:SayAlign(nLinha, 105,Alltrim((cArqTmp)->B1_HALAL)		, oFnt12n 	, 800,0060,,0,1)//Descri��o do certificado HALAL

		nLinha += nEntrLin
	EndIf

	oPrint:SayAlign(nLinha, 0,GetLabel("9", aParam) , oFnt12n 	, 800,0060,,0,1)//Alergicos
	oPrint:SayAlign(nLinha, 85,Alltrim(GetDXImp("4", cArqTmp, aParam)+"       ";
	+GetDXImp("5", cArqTmp, aParam)) 	, oFnt12n 	, 800,0060,,0,1)//Descri��o dos alergicos / Gluten


	nLinha += nEntrLin
	oPrint:SayAlign(nLinha, 0,GetLabel("10", aParam)     		, oFnt12n 	, 800,0060,,0,1)//Manuseio
	oPrint:SayAlign(nLinha, 85,GetDXImp("6", cArqTmp, aParam)	, oFnt12 	, 800,0060,,0,1)//Dados do manuseio


	nLinha += nEntrLin
	oPrint:SayAlign(nLinha, 0,GetLabel("11", aParam)  			, oFnt12n 	, 800,0060,,0,1)//Emergencia

	//Dados da emergencia com quebra de linha
	For nX := 1 To MLCount(GetDXImp("7", cArqTmp, aParam),80)
		oPrint:SayAlign(nLinha, 85,MemoLine(GetDXImp("7", cArqTmp, aParam),80,nX)	, oFnt12 	, 800,0060,,0,1)//Dados da emergencia
		nLinha += nEntrLin
	Next

	//Consumo Humano
	If Alltrim((cArqTmp)->B1_XDESTIN) == "1"
		nLinha += nEntrLin
		oPrint:SayAlign(nLinha, 85,GetDXImp("8", cArqTmp, aParam)	, oFnt12 	, 800,0060,,0,1)
	EndIf

	//Frases de alerta
	cFrAlert	:= ""
	cFrAlert	:= Alltrim(GetFrAlert((cArqTmp)->B1_COD, aParam))
	If !Empty(cFrAlert)
		nLinha += nEntrLin

		For nX := 1 To MLCount(cFrAlert,80)
			oPrint:SayAlign(nLinha, 85,MemoLine(cFrAlert,80,nX)	, oFnt12 	, 800,0060,,0,1)//Dados das frases de alerta.
			nLinha += nEntrLin
		Next	
	EndIf


	//Imagens
	If Alltrim((cArqTmp)->B1_TRANSGE) == "1"//Verifica se o produto e transgenico
		oPrint:SayBitmap(0130,550, GetDXImp("9", cArqTmp, aParam), 100, 100)//Imagem do transgenico
	EndIf

	oPrint:SayBitmap(0130,675, Alltrim((cArqTmp)->B1_PICTOG), 100, 100)//Imagem diversos



	//Codigo de barras do ACD
	oPrint:MSBAR("CODE128",25.5,56.3, cCodEtiq, oPrint,.T.,,.T.,0.021,0.7,.F.,NIL,NIL,.F.)
	oPrint:Say(338, 685,cCodEtiq, oFnt12)

	//Codigo de barras do produto
	oPrint:MSBAR("EAN13",35,0,(cArqTmp)->B1_CODBAR,oPrint,.T.,,.T.,0.021,0.7,.F.,NIL,NIL,.F.)


	//Finaliza a pagina
	oPrint:EndPage()


	RestArea(aArea)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GetLabel		�Autor  �Microsiga	     � Data �  21/11/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna a label do relatorio						 	      ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetLabel(cCod, aParam, cArqTmp)

	Local aArea	:= GetArea()
	Local cRet	:= ""
	
	Default cCod 	:= ""
	Default aParam	:= {}
	Default cArqTmp	:= ""

	If Alltrim(cCod) == "1"//Lote
		If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
			cRet := "LOTE:"
		ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
			cRet := "BATCH NUMBER:"
		ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
			cRet := "LOTE:"
		ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
			cRet := "LOTE:"
		EndIf 

	ElseIf Alltrim(cCod) == "2"//Codigo do produto
		If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
			cRet := "COD.PROD:"
		ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
			cRet := "PROD.CODE:"
		ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
			cRet := "COD.PROD:"
		ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
			cRet := "COD.PROD:"
		EndIf 

	ElseIf Alltrim(cCod) == "3"//Conteudo	
		If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
			If UPPER(Alltrim((cArqTmp)->B1_UM)) == "KG" 
				cRet := "PESO LIQ:"
			Else
				cRet := "CONTE�DO:"
			EndIf
		ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
			If UPPER(Alltrim((cArqTmp)->B1_UM)) == "KG" 
				cRet := "NET WEIGHT:"
			Else
				cRet := "CONTENT:"
			EndIf
		ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
			If UPPER(Alltrim((cArqTmp)->B1_UM)) == "KG" 
				cRet := "PESO NETO:"
			Else
				cRet := "CONTENIDO:"
			EndIf
		ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
			If UPPER(Alltrim((cArqTmp)->B1_UM)) == "KG" 
				cRet := "PESO LIQ:"
			Else
				cRet := "CONTE�DO:"
			EndIf
		EndIf 

	ElseIf Alltrim(cCod) == "4"//Fabrica��o
		If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
			cRet := "FABRICA��O:"
		ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
			cRet := "MANUFACTURE DATE:"
		ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
			cRet := "FECHA DE ELABORACI�N:"
		ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
			cRet := "FABRICA��O:"
		EndIf 

	ElseIf Alltrim(cCod) == "5"//Validade
		If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
			cRet := "VALIDADE:" 
		ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
			cRet := "EXPIRATION DATE:" 
		ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
			cRet := "VALIDEZ:"
		ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
			cRet := "VALIDADE:" 
		EndIf 

	ElseIf Alltrim(cCod) == "6"//Descri��o
		If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
			cRet := "DESCRI��O: " 
		ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
			cRet := "DESCRIPTION: " 
		ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
			cRet := "DESCRIPCI�N: " 
		ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
			cRet := "DESCRI��O: "
		EndIf 	

	ElseIf Alltrim(cCod) == "7"//Composi��o			
		If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
			cRet := "COMPOSI��O: " 
		ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
			cRet := "COMPOSITION: "
		ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
			cRet := "COMPOSICI�N: " 
		ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
			cRet := "COMPOSI��O: "
		EndIf 	

	ElseIf Alltrim(cCod) == "8"//Certificado HALAL			
		If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
			cRet := "CERTIFICADO HALAL: " 
		ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
			cRet := "CERTIFIED HALAL: "
		ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
			cRet := "CERTIFICADO HALAL: " 
		ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
			cRet := "CERTIFICADO HALAL: "
		EndIf 	

	ElseIf Alltrim(cCod) == "9"//Al�rgicos			
		If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
			cRet := "AL�RGICOS: " 
		ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
			cRet := "ALLERGIC: "
		ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
			cRet := "AL�RGICO: " 
		ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
			cRet := "AL�RGICOS: "
		EndIf 

	ElseIf Alltrim(cCod) == "10"//Manuseio			
		If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
			cRet := "MANUSEIO: " 
		ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
			cRet := "HANDLING: "
		ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
			cRet := "FORMA DE USO: " 
		ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
			cRet := "MANUSEIO: "
		EndIf 

	ElseIf Alltrim(cCod) == "11"//Emergencia			
		If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
			cRet := "EMERG�NCIA: " 
		ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
			cRet := "EMERGENCY: "
		ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
			cRet := "EMERGENCIA: " 
		ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
			cRet := "EMERG�NCIA: "
		EndIf 

	EndIf

	RestArea(aArea)
Return cRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GetDXImp		�Autor  �Microsiga	     � Data �  21/11/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna a descri��o a ser impressa				 	      ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetDXImp(cCod, cArqTmp, aParam)

	Local 	aArea		:= GetArea()
	Local	cRet		:= ""

	Default cCod 	:= ""
	Default cArqTmp	:= ""
	Default aParam	:= {}

	   

	If Alltrim(cCod) == "1"//Descri��o do produto
		If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
			cRet := (cArqTmp)->B1_DESC
		ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
			cRet := (cArqTmp)->B1_DESCIN
		ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
			cRet := (cArqTmp)->B1_DESCES
		ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
			cRet := (cArqTmp)->B1_DESC
		EndIf 



	ElseIf Alltrim(cCod) == "2"//Peso
		/*If _nOpc == 1
			If LEFT(aParam[3],1) == "1"//Primeira unidade de medida
				If aParam[2] == 0
					cRet := Alltrim(TRANSFORM((cArqTmp)->B1_PESO,"@E 9,999.999")+" "+Alltrim((cArqTmp)->B1_UM))
				Else
					cRet := Alltrim(TRANSFORM(aParam[2],"@E 9,999.999")+" "+Alltrim((cArqTmp)->B1_UM))
				EndIf
			Else
				cRet := Alltrim(TRANSFORM((cArqTmp)->B1_PESO,"@E 9,999.999")+" "+Alltrim((cArqTmp)->B1_SEGUM))
			EndIf
		ElseIf _nOpc == 3
			If LEFT(aParam[3],1) == "1"//Primeira unidade de medida
				If aParam[2] == 0
					cRet := Alltrim(TRANSFORM((cArqTmp)->B1_PESO,"@E 9,999.999")+" "+Alltrim((cArqTmp)->B1_UM))
				Else
					cRet := Alltrim(TRANSFORM(aParam[2],"@E 9,999.999")+" "+Alltrim((cArqTmp)->B1_UM))
				EndIf
			Else
				cRet := Alltrim(TRANSFORM((cArqTmp)->B1_QE,"@E 9,999.999")+" "+Alltrim((cArqTmp)->B1_SEGUM))
			EndIf
		Else
				cRet := Alltrim(TRANSFORM((cArqTmp)->B1_QE,"@E 9,999.999")+" "+Alltrim((cArqTmp)->B1_UM))		
		EndIf*/

		If _nOpc == 1 
			If SubStr(aParam[3],1,1) == "1"//Primeira unidade de medida
				If aParam[2] == 0
					cRet := Alltrim(TRANSFORM((cArqTmp)->B1_PESO,"@E 9,999.999")+" "+Alltrim((cArqTmp)->B1_UM))
				Else
					cRet := Alltrim(TRANSFORM(aParam[2],"@E 9,999.999")+" "+Alltrim((cArqTmp)->B1_UM))
				EndIf
		
			ElseIf SubStr(aParam[3],1,1) == "2"//Segunda unidade de medida
				If aParam[2] == 0
					cRet := Alltrim(TRANSFORM((cArqTmp)->B1_PESO,"@E 9,999.999")+" "+Alltrim((cArqTmp)->B1_SEGUM))
				Else
					cRet := Alltrim(TRANSFORM(aParam[2],"@E 9,999.999")+" "+Alltrim((cArqTmp)->B1_SEGUM))
				EndIf
		
			EndIf

		EndIf

		If _nOpc == 3 .OR. _nOpc == 4
			If LEFT(aParam[3],1) == "1"//Primeira unidade de medida
				If aParam[2] == 0
					cRet := Alltrim(TRANSFORM((cArqTmp)->B1_PESO,"@E 9,999.999")+" "+Alltrim((cArqTmp)->B1_UM))
				Else
					cRet := Alltrim(TRANSFORM(aParam[2],"@E 9,999.999")+" "+Alltrim((cArqTmp)->B1_UM))
				EndIf
			Else
				cRet := Alltrim(TRANSFORM((cArqTmp)->B1_QE,"@E 9,999.999")+" "+Alltrim((cArqTmp)->B1_SEGUM))
			EndIf
		//Else
			//cRet := Alltrim(TRANSFORM((cArqTmp)->B1_QE,"@E 9,999.999")+" "+Alltrim((cArqTmp)->B1_UM))		
		EndIf

		If _nOpc == 5
			If aParam[3] == "1-Primeira Unidade"
				cRet := Alltrim(TRANSFORM(aParam[2],"@E 9,999.999")+" KG")
			Else
				cRet := Alltrim(TRANSFORM(aParam[2],"@E 9,999.999")+" L")
			EndIf
		EndIf

		If _nOpc == 2
			cRet := TRANSFORM(nPesTdo,"@E 9,999.999")+"  KG"
		EndIf
		
	ElseIf Alltrim(cCod) == "3"//Descri��o
		If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
			cRet := (cArqTmp)->Z9_CLASPO
		ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
			cRet := (cArqTmp)->Z9_CLASIN
		ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
			cRet := (cArqTmp)->Z9_CLASES
		ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
			cRet := (cArqTmp)->Z9_CLASOU
		EndIf 

	ElseIf Alltrim(cCod) == "4"//Alergicos
		If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
			cRet := (cArqTmp)->ZB_ALERPO
		ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
			cRet := (cArqTmp)->ZB_ALERIN
		ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
			cRet := (cArqTmp)->ZB_ALERES
		ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
			cRet := (cArqTmp)->ZB_ALEROU
		EndIf 	

	ElseIf Alltrim(cCod) == "5"//Glutem
		If Alltrim((cArqTmp)->B1_GLUTEN) == "1"
			If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
				cRet := "CONTEM GL�TEN"
			ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
				cRet := "CONTAIN GLUTEN" 
			ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
				cRet := "CONTIENE GLUTEN"
			ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
				cRet := "CONTEM GL�TEN"
			EndIf 		
		Else
			If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
				cRet := "N�O CONTEM GL�TEN"
			ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
				cRet := "GLUTEN-FREE" 
			ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
				cRet := "NO CONTIENE GLUTEN"
			ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
				cRet := "N�O CONTEM GL�TEN"
			EndIf 	
		EndIf

	ElseIf Alltrim(cCod) == "6"//Manuseio
		If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
			cRet := (cArqTmp)->ZA_MANUPO
		ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
			cRet := (cArqTmp)->ZA_MANUIN
		ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
			cRet := (cArqTmp)->ZA_MANUES
		ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
			cRet := (cArqTmp)->ZA_MANUOU
		EndIf 		

	ElseIf Alltrim(cCod) == "7"//Emergencia
		If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
			cRet := "Telefone de emerg�ncia (11)3732-0000 - A ficha de informa��es de seguran�a de produtos qu�micos deste produto pode ser obtida no e-mail prozyn@prozyn.com.br"
		ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
			cRet := "Emergency phone number: + 55 11 3732-0000. The chemical product safety data sheet for this product can be obtained by the email prozyn@prozyn.com.br."
		ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
			cRet := "Tel�fono de emergencia: + 55 11 3732-0000. La ficha de informaci�n de seguridad de productos qu�micos de este producto puede obtenerse en el correo electr�nico prozyn@prozyn.com.br."
		ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
			cRet := "Telefone de emerg�ncia (11)3732-0000 - A ficha de informa��es de seguran�a de produtos qu�micos deste produto pode ser obtida no e-mail prozyn@prozyn.com.br"
		EndIf 	

	ElseIf Alltrim(cCod) == "8"//Consumo humano
		If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
			cRet := "Produto n�o destinado para o consumo humano na forma como se apresenta."
		ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
			cRet := "Product not intended for human consumption in the way it is presented."
		ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
			cRet := "Producto no destinado al consumo humano en la forma en que se presenta."
		ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
			cRet := "Produto n�o destinado para o consumo humano na forma como se apresenta."
		EndIf 	

	ElseIf Alltrim(cCod) == "9"//Imagem transgenico
		If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
			cRet := "\00-pictogramas\TRANSG�NICO.bmp"
		ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
			cRet := "\00-pictogramas\TRANSG�NICOING.bmp"
		ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
			cRet := "\00-pictogramas\TRANSG�NICOESP.bmp"
		ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
			cRet := "\00-pictogramas\TRANSG�NICO.bmp"
		EndIf 			
	EndIf



	RestArea(aArea)
Return UPPER(Alltrim(cRet))


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GetNomeImp	�Autor  �Microsiga	     � Data �  30/10/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna o nome da impressora						 	      ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetNomeImp(cCodProd)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local cRet		:= ""

	Default cCodProd := ""

	cQuery := " SELECT PZ1_NOME FROM "+RetSqlName("SB5")+" SB5 "+CRLF

	cQuery += " INNER JOIN "+RetSqlName("PZ1")+" PZ1 "+CRLF
	cQuery += " ON PZ1.PZ1_FILIAL = '"+xFilial("PZ1")+"' "+CRLF
	cQuery += " AND PZ1.PZ1_COD = SB5.B5_YCODIMP "+CRLF
	cQuery += " AND PZ1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery += " WHERE SB5.B5_FILIAL = '"+xFilial("SB5")+"' "+CRLF
	cQuery += " AND SB5.B5_COD = '"+cCodProd+"' "+CRLF 
	cQuery += " AND SB5.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	If (cArqTmp)->(!Eof())
		cRet := (cArqTmp)->PZ1_NOME
	EndIf

	If Select(cArqTmp) > 0 
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return cRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PergRel  �Autor  �Microsiga	         � Data �  01/08/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Pergunta para selecionar o arquivo                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                               	                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function PergRel(aParam)

	Local    aArea 		:= GetArea()
	Public   aParamBox	:= {} 
	Public   lRet		:= .F.
	Public   aIdioma	:= {"1-Portugu�s","2-Ingl�s","3-Espanhol","4-Outros"}
	Public   aUnidMed	:= {"1-Primeira Unidade","2-Segunda Unidade"}
	//Public   aReimpress	:= {"1-N�o","2-Sim"}
	Public   cLoadArq	:= "pzcvr012"+Alltrim(RetCodUsr())+Alltrim(cEmpAnt)
	Public   nTamOP		:= TamSx3("C2_NUM")[1]+TamSx3("C2_ITEM")[1]+TamSx3("C2_SEQUEN")[1]+TamSx3("C2_ITEMGRD")[1]



	If _nOpc == 1
		AADD(aParamBox,{1,"OP"				,Space(nTamOP)	,"","","SC2","",50,.T.})
		AADD(aParamBox,{1,"Peso"		,0	,"@E 999,999,999.999","","","",50,.T.})
		AADD(aParamBox,{2,"Unid.de Medida"	,"1"	, aUnidMed, 70,".T."				,.T.})
		AADD(aParamBox,{2,"Idioma"			,"1"	, aIdioma, 70,".T."				,.T.})
		AADD(aParamBox,{1,"Qtd.Etiqueta",0	,"@E 9999","","","",50,.T.})
		AADD(aParamBox,{1,"Rotulo De"		,0	,"@E 9999","","","",50,.F.})	
		AADD(aParamBox,{1,"Rotulo Ate"		,0	,"@E 9999","","","",50,.F.})
	ElseIf _nOpc == 2
		AADD(aParamBox,{1,"OP"				,Space(nTamOP)	,"","","SC2","",50,.T.})
		//AADD(aParamBox,{1,"Rotulo"			,Space(TamSx3("CB0_CODETI")[1])	,"","","","",50,.T.})
		AADD(aParamBox,{1,"Rotulo"		,0	,"@E 9999","","","",50,.F.})	
		AADD(aParamBox,{1,"Rotulo Ate"		,0	,"@E 9999","","","",50,.F.})	
		AADD(aParamBox,{2,"Idioma"			,"1"	, aIdioma, 70,".T."				,.T.}	 )
	ElseIf _nOpc == 3
		AADD(aParamBox,{1,"Rotulo"			,Space(TamSx3("CB0_CODETI")[1])	,"","","","",50,.T.})
		AADD(aParamBox,{1,"Peso"		,0	,"@E 999,999,999.999","","","",50,.T.})
		AADD(aParamBox,{2,"Unid.de Medida"	,"1"	, aUnidMed, 70,".T."				,.T.})
		AADD(aParamBox,{2,"Idioma"			,"1"	, aIdioma, 70,".T."				,.T.})
		AADD(aParamBox,{1,"Rotulo De"		,0	,"@E 9999","","","",50,.F.})	
		AADD(aParamBox,{1,"Rotulo Ate"		,0	,"@E 9999","","","",50,.F.})
	ElseIf _nOpc == 4
		AADD(aParamBox,{1,"OP"				,Space(nTamOP)	,"","","SC2","",50,.T.})
		AADD(aParamBox,{1,"Peso"		,0	,"@E 999,999,999.999","","","",50,.T.})
		AADD(aParamBox,{2,"Unid.de Medida"	,"1"	, aUnidMed, 70,".T."				,.T.})
		AADD(aParamBox,{2,"Idioma"			,"1"	, aIdioma, 70,".T."				,.T.})
		AADD(aParamBox,{1,"Qtd.Etiqueta",0	,"@E 9999","","","",50,.T.})
	ElseIf _nOpc == 5
		AADD(aParamBox,{1,"OP"				,Space(nTamOP)	,"","","SC2","",50,.T.})
		AADD(aParamBox,{1,"Peso"		,0	,"@E 999,999,999.999","","","",50,.T.})
		AADD(aParamBox,{2,"Unid.de Medida"	,"1"	, aUnidMed, 70,".T."				,.T.})
		AADD(aParamBox,{2,"Idioma"			,"1"	, aIdioma, 70,".T."				,.T.})
		AADD(aParamBox,{1,"Qtd.Etiqueta",0	,"@E 9999","","","",50,.T.})
		AADD(aParamBox,{1,"Rotulo De"		,0	,"@E 9999","","","",50,.F.})	
		AADD(aParamBox,{1,"Rotulo Ate"		,0	,"@E 9999","","","",50,.F.})
	EndIf

	//AADD(aParamBox,{1,"Produto"			,Space(TamSx3("B1_COD")[1])	,"","","SB1","",50,.T.})
	//AADD(aParamBox,{1,"Lote"			,Space(TamSx3("B8_LOTECTL")[1])	,"","","","",50,.T.})
	//AADD(aParamBox,{1,"OP"				,Space(nTamOP)	,"","","SC2","",50,.T.})
	//AADD(aParamBox,{2,"Idioma"			,"1"	, aIdioma, 70,".T."				,.T.})
	//AADD(aParamBox,{1,"Qtd.Etiqueta",0	,"@E 9999","","","",50,.T.})
	//AADD(aParamBox,{1,"Peso"		,0	,"@E 999,999,999.999","","","",50,.T.})
	//AADD(aParamBox,{2,"Unid.de Medida"	,"1"	, aUnidMed, 70,".T."				,.T.})
	//AADD(aParamBox,{2,"Reimprimir "		,"2"	, aReimpress, 70,".T."				,.T.})
	//AADD(aParamBox,{1,"Rotulo"		,0	,"@E 9999","","","",50,.F.})	
	//AADD(aParamBox,{1,"Rotulo Ate"		,0	,"@E 9999","","","",50,.F.})

	//Monta a pergunta
	If _nOpc <> 0
		lRet := ParamBox(aParamBox, "Informe os Par�metros", @aParam, , /*alButtons*/, .T., /*nlPosx*/, /*nlPosy*/,, cLoadArq, .t., .t.)
	Else 
		lRet := .F.
	EndIf
	

	RestArea(aArea)
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GetCArqD		�Autor  �Microsiga	     � Data �  21/11/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna o arquivo temporario						 	      ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetCArqD(cOP)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()

	Default cOP	:= "" 
	
	cQuery	:= " SELECT C2_NUM, C2_ITEM, C2_SEQUEN, C2_LOTECTL, C2_EMISSAO, C2_DTVALID, C2_QUANT, C2_PRODUTO, C2_LOCAL, "+CRLF 
	cQuery	+= " 		B1_COD, B1_DESC, B1_DESCIN, B1_DESCES, B1_DESCOUT, B1_QE, B1_PESO, B1_TRANSGE, B1_PICTOG, "+CRLF 
	cQuery	+= " 		B1_HALAL, B1_ALERGEN, B1_GLUTEN, B1_XDESTIN, B1_CODBAR, B1_UM, B1_SEGUM, "+CRLF
	cQuery	+= " 		Z9_CLASPO, Z9_CLASIN, Z9_CLASES, Z9_CLASOU, "+CRLF
	cQuery	+= " 		ZO_DESC, "+CRLF
	cQuery	+= " 		ZB_ALERIN, ZB_ALERES, ZB_ALEROU, ZB_ALERPO, "+CRLF
	cQuery	+= " 		ZA_MANUPO, ZA_MANUIN, ZA_MANUES, ZA_MANUOU "+CRLF

	cQuery	+= " FROM "+RetSqlName("SC2")+" SC2 "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 "+CRLF
	cQuery	+= " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " AND SB1.B1_COD = SC2.C2_PRODUTO "+CRLF
	cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " LEFT JOIN "+RetSqlName("SZ9")+" SZ9 "+CRLF
	cQuery	+= " ON SZ9.Z9_FILIAL = '"+xFilial("SZ9")+"' "+CRLF
	cQuery	+= " AND SZ9.Z9_CODIGO =  SB1.B1_DESCETI "+CRLF
	cQuery	+= " AND SZ9.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " LEFT JOIN "+RetSqlName("SZO")+" SZO "+CRLF
	cQuery	+= " ON SZO.ZO_FILIAL = '"+xFilial("SZO")+"' "+CRLF
	cQuery	+= " AND SZO.ZO_CODIGO = SB1.B1_CODCOM "+CRLF
	cQuery	+= " AND SZO.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " LEFT JOIN "+RetSqlName("SZB")+" SZB "+CRLF
	cQuery	+= " ON SZB.ZB_FILIAL = '"+xFilial("SZB")+"' "+CRLF
	cQuery	+= " AND SZB.ZB_CODIGO = SB1.B1_ALERGEN "+CRLF
	cQuery	+= " AND SZB.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " LEFT JOIN "+RetSqlName("SZA")+" SZA "+CRLF
	cQuery	+= " ON SZA.ZA_FILIAL = '"+xFilial("SZA")+"' "+CRLF
	cQuery	+= " AND SZA.ZA_CODIGO = SB1.B1_MANUSEI "+CRLF
	cQuery	+= " AND SZA.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " WHERE SC2.C2_FILIAL = '"+xFilial("SC2")+"' "+CRLF
	cQuery	+= " AND (LTRIM(RTRIM(SC2.C2_NUM)) + LTRIM(RTRIM(SC2.C2_ITEM)) + "
	cQuery	+= " LTRIM(RTRIM(SC2.C2_SEQUEN)) + LTRIM(RTRIM(SC2.C2_ITEMGRD))) = '"+Alltrim(cOP)+"' "+CRLF
	cQuery	+= " AND SC2.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	RestArea(aArea)
Return cArqTmp

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GetFrAlert		�Autor  �Microsiga   � Data �  21/11/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna frase de alerta							 	      ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetFrAlert(cCodProd, aParam)

	Local aArea		:= GetArea()
	Local cRet		:= ""
	Local cArqTmp	:= GetNextAlias()
	local cQuery	:= ""

	Default cCodProd	:= "" 
	Default aParam		:= {}


	cQuery	:= " SELECT Z7_DESCIN, Z7_DESCES, Z7_DESCOUT, Z7_DESC FROM "+RetSqlName("SZ8")+" SZ8 "

	cQuery	+= " LEFT JOIN "+RetSqlName("SZ7")+" SZ7 "
	cQuery	+= " ON SZ7.Z7_FILIAL = '"+xFilial("SZ7")+"' "
	cQuery	+= " AND SZ7.Z7_COD = SZ8.Z8_CODFRA "
	cQuery	+= " AND SZ7.D_E_L_E_T_ = ' ' "

	cQuery	+= " WHERE SZ8.Z8_FILIAL = '"+xFilial("SZ8")+"' "
	cQuery	+= " AND SZ8.Z8_CODPRO = '"+cCodProd+"' "
	cQuery	+= " AND SZ8.D_E_L_E_T_ = ' ' "

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	While (cArqTmp)->(!Eof())

		If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
			cRet += (cArqTmp)->Z7_DESC+"."
		ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
			cRet += (cArqTmp)->Z7_DESCIN+"." 
		ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
			cRet += (cArqTmp)->Z7_DESCES+"."
		ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
			cRet += (cArqTmp)->Z7_DESCOUT+"."
		EndIf

		(cArqTmp)->(DbSkip()) 	
	EndDo
	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf


	RestArea(aArea)
Return cRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GetQtdEtiq	�Autor  �Microsiga	     � Data �  21/11/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna a quantidade de etiquetas					 	      ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetQtdEtiq(aParam, cArqTmp)

	Local aArea	:= GetArea()
	Local nRet	:= 0

	 If _nOpc == 1 .OR. _nOpc == 4
		If aParam[5] > 0
			nRet := aParam[5] 
		ElseIf aParam[2] > 0 .And. (cArqTmp)->B1_QE > 0
			nRet := INT(aParam[2] / (cArqTmp)->B1_QE)
		Else
			nRet := INT((cArqTmp)->C2_QUANT / (cArqTmp)->B1_QE)
		EndIf
	Else
		nRet := INT((cArqTmp)->C2_QUANT / (cArqTmp)->B1_QE)
	EndIf
	RestArea(aArea)
Return nRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GetCodEti		�Autor  �Microsiga	     � Data �  18/07/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna o codigo da etiqueta								  ���
���          �												              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetCodEti(cOp, cCodPro, cLote, cSeq)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local cRet		:= ""

	Default cOp		:= "" 
	Default cCodPro	:= "" 
	Default cLote	:= ""
	Default cSeq	:= ""

	cQuery	:= " SELECT CB0_CODETI FROM "+RetSqlName("CB0")+" CB0 "+CRLF
	cQuery	+= " WHERE CB0_FILIAL = '"+xFilial("CB0")+"' "+CRLF
	cQuery	+= " AND CB0_OP = '"+cOp+"' "+CRLF
	cQuery	+= " AND CB0_LOTE = '"+cLote+"' "+CRLF
	cQuery	+= " AND CB0_CODPRO = '"+cCodPro+"' "+CRLF
	cQuery	+= " AND CB0_YSEQEM = '"+cSeq+"' "+CRLF
	cQuery	+= " AND CB0.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	If (cArqTmp)->(!Eof())
		cRet := (cArqTmp)->CB0_CODETI
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return cRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GravaCB0		�Autor  �Microsiga	     � Data �  18/07/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a grava��o dos dados na tabela CB0				  ���
���          �												              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GravaCB0(cProd, nQtd, cUsr, cNfEntr, cSerieEntr, cCodFor, cLoja, cPedCom,cLocaliz, cArmaz, ;
	cOp, cNumSeq, cNfSaida, cSerieSaid, cEtiqCli, cLote, cSbLote, dDtValid, cCentroCust)

	Local aArea 		:= GetArea()
	Local aConteudo		:= {}

	Default cProd 		:= ""
	Default nQtd		:= 0
	Default cUsr		:= ""
	Default cNfEntr		:= ""
	Default cSerieEntr	:= ""
	Default cCodFor		:= ""
	Default cLoja		:= ""
	Default cLocaliz	:= ""
	Default cArmaz		:= ""
	Default cOp			:= ""
	Default cNumSeq		:= ""
	Default cNfSaida	:= ""
	Default cSerieSaid	:= ""
	Default cEtiqCli	:= ""
	Default cLote		:= ""
	Default cSbLote		:= ""
	Default dDtValid	:= ""
	Default cCentroCust	:= ""

	aConteudo := {cProd,; 
	nQtd,; 
	cUsr,; 
	cNfEntr,; 
	cSerieEntr,; 
	cCodFor,; 
	cLoja,;
	cPedCom,; 
	cLocaliz,; 
	cArmaz, ;
	cOp,; 
	cNumSeq,; 
	cNfSaida,; 
	cSerieSaid,; 
	cEtiqCli,; 
	cLote,; 
	cSbLote,; 
	dDtValid,; 
	cCentroCust,;
	Nil,Nil,Nil,Nil,Nil,Nil}

	CBGrvEti("01",aConteudo, Nil)

	RestArea(aArea)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GetCodEtiq	�Autor  �Microsiga	     � Data �  18/07/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna os codigos das etiquetas							  ���
���          �												              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GravaSeqEti(cOp, cLote, cProd, nSeq)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()

	Default cOp			:= "" 
	Default cLote		:= "" 
	Default cProd		:= ""
	Default nSeq		:= ""



	cQuery	:= " SELECT R_E_C_N_O_ RECCB0 FROM "+RetSqlName("CB0")+" CB0 "+CRLF
	cQuery	+= " WHERE CB0_FILIAL = '"+xFilial("CB0")+"' "+CRLF
	cQuery	+= " AND CB0_OP = '"+cOp+"' "+CRLF
	cQuery	+= " AND CB0_LOTE = '"+cLote+"' "+CRLF
	cQuery	+= " AND CB0_CODPRO = '"+cProd+"' "+CRLF
	cQuery	+= " AND CB0_YSEQEM = '' "+CRLF	
	cQuery	+= " AND CB0.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " ORDER BY CB0_CODETI "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	DbSelectArea("CB0")
	DbSetOrder(1)


	If (cArqTmp)->(!Eof())
		CB0->(DbGoTo((cArqTmp)->RECCB0))
		RecLock("CB0",.F.)
		CB0->CB0_YSEQEM := nSeq 
		CB0->(MsUnLock())
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GetReimp		�Autor  �Microsiga	     � Data �  18/07/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna a reimpress�o de/ate								  ���
���          �												              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetReimp(cOp, cLote, cProd, nImpDe, nImpAte)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()

	Default cOp			:= "" 
	Default cLote		:= "" 
	Default cProd		:= ""
	Default nImpDe		:= 0 
	Default nImpAte		:= 0

	cQuery	:= " SELECT MIN(CB0_YSEQEM) ETIQINI, MAX(CB0_YSEQEM) ETIQFINAL FROM "+RetSqlName("CB0")+" CB0 "+CRLF
	cQuery	+= " WHERE CB0_FILIAL = '"+xFilial("CB0")+"' "+CRLF
	cQuery	+= " AND CB0_OP = '"+cOp+"' "+CRLF
	cQuery	+= " AND CB0_LOTE = '"+cLote+"' "+CRLF
	cQuery	+= " AND CB0_CODPRO = '"+cProd+"' "+CRLF
	cQuery	+= " AND CB0_YSEQEM BETWEEN '"+Alltrim(Str(nImpDe))+"' AND '"+Alltrim(Str(nImpAte))+"' "+CRLF	
	cQuery	+= " AND CB0.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)
	
	If (cArqTmp)->(!Eof())
		nImpDe 	:= (cArqTmp)->ETIQINI
		nImpAte	:= (cArqTmp)->ETIQFINAL
	EndIf

	If Select(cArqTmp) > 0 
		(cArqTmp)->(DbCloseArea())
	EndIf
	RestArea(aArea)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GetQtdMax		�Autor  �Microsiga	     � Data �  18/07/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna a quantidade maxima da etiqueta					  ���
���          �												              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetQtdMax(cOp, cLote, cProd)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local nRet		:= 0

	Default cOp			:= "" 
	Default cLote		:= "" 
	Default cProd		:= ""

	cQuery	:= " SELECT ISNULL(MAX(CB0_YSEQEM),0) ETIQFINAL FROM "+RetSqlName("CB0")+" CB0 "+CRLF
	cQuery	+= " WHERE CB0_FILIAL = '"+xFilial("CB0")+"' "+CRLF
	cQuery	+= " AND CB0_OP = '"+cOp+"' "+CRLF
	cQuery	+= " AND CB0_LOTE = '"+cLote+"' "+CRLF
	cQuery	+= " AND CB0_CODPRO = '"+cProd+"' "+CRLF
	cQuery	+= " AND CB0.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)
	
	If (cArqTmp)->(!Eof())
		nRet	:= (cArqTmp)->ETIQFINAL
	EndIf

	If Select(cArqTmp) > 0 
		(cArqTmp)->(DbCloseArea())
	EndIf
	RestArea(aArea)
Return nRet
