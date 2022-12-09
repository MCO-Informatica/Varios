#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

//#DEFINE OP		 	1
#DEFINE IDIOMA 			4
//#DEFINE QTDETIQUETA	3
//#DEFINE PESO		4
//#DEFINE UNIDMEDIDA	5
//#DEFINE REIMPRIMIR	6
//#DEFINE ETIQUETADE	7
//#DEFINE ETIQUETAATE	8


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณPZCVR015	   บAutor  ณGustavo Gonzalezบ Data ณ  31/08/2020 บ ฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressao de etiqueta de sachet					 	      บฑฑ
ฑฑบ          ณ								                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PZCVR015()
	Local aArea		:= GetArea()
	Local aParam	:= {}

	If ExistBlock("PZROTSA")
	   ExecBlock("PZROTSA",.F.,.F.)
	EndIf

	//RpcClearEnv()
	//RpcSetEnv( "01","01", "Administrador", "sol", "CTB", "", {}, , , ,  )

	If PergRel(@aParam)
		Processa( {|| ProcRel(aParam) },"Aguarde...","" )

	EndIf
	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณProcRel		บAutor  ณMicrosiga	     บ Data ณ  21/11/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessamento do relatorio						 	      บฑฑ
ฑฑบ          ณ								                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
	Private _cOp		:= ""
	Default aParam 		:= {}

	//Dados do relatorio
	If _nOpc == 1
		_cOP := aParam[1]
	ElseIf _nOpc == 2
		_cOp := aParam[1]
	ElseIf _nOpc == 3
		_cOp := POSICIONE("CB0",1,xFilial("CB0")+aParam[1],"CB0_OP")
	ElseIf _nOpc == 5
		_cOp := aParam[1]
	Endif
	
	cArqTmp := GetCArqD(_cOP)

	If (cArqTmp)->(!Eof())

		//Quantidade de etiquetas a serem impressas
		nQtdEtiq := GetQtdEtiq(aParam, cArqTmp)

		//Verifica se ้ reimpressใo
		If _nOpc == 2
			nRotuloIni	:= aParam[2]
			nRotuloFin	:= aParam[3]

			//Atualiza as variaveis com o a impressใo do rotulo de/ate
			GetReimp((cArqTmp)->(C2_NUM+C2_ITEM+C2_SEQUEN), (cArqTmp)->C2_LOTECTL, (cArqTmp)->C2_PRODUTO, @nRotuloIni, @nRotuloFin)

			//Impressใo do rotulo at้
			nQtdEtiq 	:= nRotuloFin
			nMaxEtiq	:= GetQtdMax((cArqTmp)->(C2_NUM+C2_ITEM+C2_SEQUEN), (cArqTmp)->C2_LOTECTL, (cArqTmp)->C2_PRODUTO) //Quantidade maxima de etiquetas

			If nRotuloIni == 0 .And. nRotuloFin == 0
				Aviso("Aten็ใo","Nenhum item encontrado para reimpressใo.",{"Ok"},2)
				Return
			EndIf
		ElseIf _nOpc == 3
			nRotuloIni	:= 1
			nRotuloFin	:= 1

			//Atualiza as variaveis com o a impressใo do rotulo de/ate
			GetReimp((cArqTmp)->(C2_NUM+C2_ITEM+C2_SEQUEN), (cArqTmp)->C2_LOTECTL, (cArqTmp)->C2_PRODUTO, @nRotuloIni, @nRotuloFin)
			
			//Impressใo do rotulo at้
			nQtdEtiq 	:= nRotuloFin
			nMaxEtiq	:= GetQtdMax((cArqTmp)->(C2_NUM+C2_ITEM+C2_SEQUEN), (cArqTmp)->C2_LOTECTL, (cArqTmp)->C2_PRODUTO) //Quantidade maxima de etiquetas
			
			If nRotuloIni == 0 .And. nRotuloFin == 0
				Aviso("Aten็ใo","Nenhum item encontrado para reimpressใo.",{"Ok"},2)
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
			//Atualiza as variaveis com o a impressใo do rotulo de/ate
			//GetReimp((cArqTmp)->(C2_NUM+C2_ITEM+C2_SEQUEN), (cArqTmp)->C2_LOTECTL, (cArqTmp)->C2_PRODUTO, @nRotuloIni, @nRotuloFin)
			
			//Impressใo do rotulo at้
			//nQtdEtiq 	:= nRotuloIni + aParam[5] 
			//nMaxEtiq	:= GetQtdMax((cArqTmp)->(C2_NUM+C2_ITEM+C2_SEQUEN), (cArqTmp)->C2_LOTECTL, (cArqTmp)->C2_PRODUTO) //Quantidade maxima de etiquetas
			
			If nRotuloIni == 0 .And. nRotuloFin == 0
				Aviso("Aten็ใo","Nenhum item encontrado para reimpressใo.",{"Ok"},2)
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
					Aviso("Aten็ใo","Nenhum item encontrado para reimpressใo.",{"Ok"},2)
					Return
				EndIf
			EndIf
			//GetReimp((cArqTmp)->(C2_NUM+C2_ITEM+C2_SEQUEN), (cArqTmp)->C2_LOTECTL, (cArqTmp)->C2_PRODUTO, @nRotuloIni, @nRotuloFin)

		Else
			nRotuloIni	:= 1
			nMaxEtiq	:= GetQtdMax((cArqTmp)->(C2_NUM+C2_ITEM+C2_SEQUEN), (cArqTmp)->C2_LOTECTL, (cArqTmp)->C2_PRODUTO) //Quantidade maxima de etiquetas //Quantidade maxima de etiquetas
			
			If nMaxEtiq == 0 .Or. nMaxEtiq < nQtdEtiq
				nMaxEtiq := nQtdEtiq
			EndIf
	
		EndIf

		//Contador da barra de progresso
		ProcRegua(nQtdEtiq)

		If nRotuloIni == 0
		   nRotuloIni := 1
		EndIf


		//Impressใo das etiquetas
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

			If _nOpc == 3
				DbSelectArea("CB0")
				DbSetOrder(1)
				cCodEtiq := aParam[1]
				IF CB0->(DbSeek(xFilial("CB0")+cCodEtiq))
					RecLock("CB0", .F.)		
					CB0->CB0_QTDE := aParam[2]			
					MsUnLock() //Confirma e finaliza a opera็ใo
				EndIf	
			Endif

			//Imprime o layout do rotulo
			ImpLayout(@oPrint, aParam, cArqTmp, nX, nMaxEtiq, cCodEtiq)
		Next

	


		//Envia para impressora
		oPrint:print()

		//Libera o objeto da impressใo e encerra o processo
		FreeObj(oPrint)

	Else
		Aviso("Aten็ใo", "Nenhum registro encontrado",{"Ok"},2)
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGerCdEtAcd	บAutor  ณMicrosiga	     บ Data ณ  21/11/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera o codigo das etiquetas do ACD				 	      บฑฑ
ฑฑบ          ณ								                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GerCdEtAcd(cArqTmp, aParam, cSeq)

	Local aArea		:= GetArea()
	Local cRet		:= ""
	Local cCodEtiq	:= ""

	Default cArqTmp	:= ""
	Default aParam	:= {}
	Default cSeq	:= ""

	//Recupera o codigo da etiqueta se existir
	cCodEtiq := GetCodEti((cArqTmp)->(C2_NUM+C2_ITEM+C2_SEQUEN), (cArqTmp)->C2_PRODUTO, (cArqTmp)->C2_LOTECTL, cSeq)

	//Verifica se Ja Existe Cadastro da tabela CB0. Senใo existir serแ criado.
	If Empty(cCodEtiq)

		//Realiza a grava็ใo da tabela CB0
		GravaCB0((cArqTmp)->C2_PRODUTO,;		//Produto
		Iif(aParam[2]== 0,(cArqTmp)->B1_QE , aParam[2] ) ,; 
		"",; 									//Usuario
		"",; 									//Nf de Entrada
		"",; 									//Serie de Entrada
		"",; 									//Codigo do fornecedor
		"",; 									//Loja
		"",;									//Pedido compra
		"",; 									//Localiza็ใo
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

		//Grava a sequencia da embalagem na tabela CB0 se nใo existir
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGetIniObj		บAutor  ณMicrosiga	     บ Data ณ  30/10/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o objeto com os dados da impressora		 	      บฑฑ
ฑฑบ          ณ								                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetIniObj(cCodProd)

	Local aArea		:= GetArea()
	Local cNomeArq	:= "PZCVR015"+DtoS(MsDate())+STRTRAN(Time(), ":", "")
	Local oPrint	:= Nil
	Local cNomImp	:= ""
	Local cSession	:= GetPrinterSession()
	Local cImpres	:= GetMv("MV_IMPSAC")

	Default cCodProd := ""

	//Nome da impressora
	//cNomImp := GetNomeImp(cCodProd)
	
	cNomImp := cImpres
	//cNomImp		:= 'imageRUNNER1435'

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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณImpLayout		บAutor  ณMicrosiga	     บ Data ณ  30/10/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImprime o layout									 	      บฑฑ
ฑฑบ          ณ								                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpLayout(oPrint, aParam, cArqTmp, nEtiPos, nQtdEtiq, cCodEtiq)

	Local aArea		:= GetArea()
	Local oFnt8		:= TFont():New("Arial",,8 ,,.F.,,,,,.F.,.F.)
	//Local oFnt6		:= TFont():New("Arial",,6 ,,.F.,,,,,.F.,.F.)
	Local oFnt8n	:= TFont():New("Arial",,8 ,,.T.,,,,,.F.,.F.)
	//Local oFnt9	:= TFont():New("Arial",,9 ,,.F.,,,,,.F.,.F.)
	Local oFnt10n	:= TFont():New("Arial",,10 ,,.T.,,,,,.F.,.F.)
	Local oFnt18n	:= TFont():New("Arial",,18 ,,.T.,,,,,.F.,.F.)
	Local nLinha	:= -10
	Local nX		:= 0
	Local lPulaLin	:= .F.
	Local nEntrLin	:= 15
	//Local cFrAlert	:= ""

	Default aParam 		:= {}
	Default cArqTmp		:= ""
	Default nEtiPos		:= 0
	Default nQtdEtiq	:= 0
	Default cCodEtiq	:= ""

	//Inicia a pagina
	oPrint:StartPage()

	//Descri็ใo do produto
	oPrint:SayAlign(nLinha, 5, GetDXImp("1", cArqTmp, aParam)	, oFnt18n, 350 ,0050,,2,0)
	//oPrint:Line(  0,  0,  0,325,0,"-8")
	//oPrint:Line(211,  0,211,325,0,"-8")
	//oPrint:Line(  0,  0,211,  0,0,"-8")
	//oPrint:Line(  0,325,211,325,0,"-8")


	//Informa็ใo Fixa
	nLinha += 17
	oPrint:SayAlign(nLinha-10, 0000, "CONSULTAR FICHA TษCNICA E FICHA DE SEGURANวA", oFnt10n, 325 ,0060,,2,0)

	//Descri็ใo
	nLinha += (nEntrLin*2)
	oPrint:SayAlign(nLinha, 5,GetLabel("6", aParam)								, oFnt8n 	, 350,0030,,0,1)//Descri็ใo
	For nX := 1 To MLCount(GetDXImp("3", cArqTmp, aParam),60)
		oPrint:SayAlign(nLinha, 65,MemoLine(GetDXImp("3", cArqTmp, aParam),60,Nx)		, oFnt8 	, 350,0060,,0,1)//Dados da descri็ใo
		nLinha += nEntrLin
	Next
	
	//Lote
	//nLinha += nEntrLin
	oPrint:SayAlign(nLinha, 5,GetLabel("1", aParam)					, oFnt8n 	, 350,0060,,0,1)
	oPrint:SayAlign(nLinha, 65,Alltrim((cArqTmp)->C2_LOTECTL)		, oFnt8n 	, 350,0060,,0,1)

	//Fabrica็ใo
	nLinha += nEntrLin
	oPrint:SayAlign(nLinha, 5,GetLabel("4", aParam)     			, oFnt8n 	, 350,0060,,0,1)
	oPrint:SayAlign(nLinha, 63,DTOC(STOD((cArqTmp)->C2_EMISSAO))	, oFnt8 	, 350,0060,,0,1)

	//Validade
	oPrint:SayAlign(nLinha, 108,GetLabel("5", aParam)				, oFnt8n 	, 350,0060,,0,1)
	oPrint:SayAlign(nLinha, 165,DTOC(STOD((cArqTmp)->C2_DTVALID))	, oFnt8 	, 350,0060,,0,1)

	//Composi็ใo
	nLinha += nEntrLin
	oPrint:SayAlign(nLinha, 5,GetLabel("7", aParam)  				, oFnt8n 	, 350,0060,,0,1)

	//Dados da composi็ใo - Quebra de linha
	lPulaLin := .F.
	For nX := 1 To MLCount(Alltrim((cArqTmp)->ZO_DESC),50)
		oPrint:SayAlign(nLinha, 65,MemoLine(Alltrim((cArqTmp)->ZO_DESC),50,nX)	, oFnt8 	, 350,0060,,0,1)
		nLinha += nEntrLin
		lPulaLin := .T.
	Next

	If !lPulaLin
		nLinha += nEntrLin
		lPulaLin := .F.
	EndIF
/*
	//Codigo do produto
	oPrint:SayAlign(130, 85,GetLabel("2", aParam)     		, oFnt10 	, 800,0060,,0,1) //Label codigo do produto
	oPrint:SayAlign(140, 85,Alltrim((cArqTmp)->B1_COD)				, oFnt22n 	, 800,0060,,0,1) //Codigo do produto

	oPrint:SayAlign(130, 485,"#EMB"     						, oFnt10 	, 800,0060,,0,1)//Emabalem
	oPrint:SayAlign(140, 485,Alltrim(Str(nEtiPos))+"/"+Alltrim(Str(nQtdEtiq))	, oFnt22n 	, 800,0060,,0,1)//Etiqueta de/ate


	If !Empty((cArqTmp)->B1_HALAL)
		oPrint:SayAlign(nLinha, 0,GetLabel("8", aParam)     		, oFnt12n 	, 800,0060,,0,1)//Certificado HALAL
		oPrint:SayAlign(nLinha, 85,Alltrim((cArqTmp)->B1_HALAL)		, oFnt12n 	, 800,0060,,0,1)//Descri็ใo do certificado HALAL

		nLinha += nEntrLin
	EndIf
*/
	
	//Peso
	oPrint:SayAlign(nLinha,   5,GetLabel("3", aParam, cArqTmp)	, oFnt8n 	, 325,0060,,0,1)//Label Conteudo
	oPrint:SayAlign(nLinha,  65,GetDXImp("2", cArqTmp, aParam)	, oFnt8 	, 325,0060,,0,1)//Peso

	//Al้rgicos - Tํtulo
	nLinha += nEntrLin
	oPrint:SayAlign(nLinha, 5,GetLabel("9", aParam) , oFnt8n 	, 50,0060,,0,1)

	//Al้rgicos - Descri็ใo Quebra de linha
	lPulaLin := .F.
	cAlergicos := Alltrim(GetDXImp("4", cArqTmp, aParam)+"       "+GetDXImp("5", cArqTmp, aParam)) 	
	For nX := 1 To MLCount(Alltrim((cArqTmp)->ZO_DESC),50)
		oPrint:SayAlign(nLinha, 65,MemoLine(cAlergicos,50,nX)	, oFnt8 	, 325,0060,,0,1)
		nLinha += nEntrLin
		lPulaLin := .T.
	Next

	If !lPulaLin
		nLinha += nEntrLin
		lPulaLin := .F.
	EndIF

	/*
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
	*/


	//Codigo de barras do ACD
	oPrint:MSBAR("CODE128",13,10, cCodEtiq, oPrint,.T.,,.T.,0.025,1,.F.,NIL,NIL,.F.)
	oPrint:SayAlign(170, 0000, cCodEtiq, oFnt8, 325 ,0060,,2,0)


	//Codigo de barras do produto
	//oPrint:MSBAR("EAN13",35,0,(cArqTmp)->B1_CODBAR,oPrint,.T.,,.T.,0.021,0.7,.F.,NIL,NIL,.F.)


	//Finaliza a pagina
	oPrint:EndPage()


	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGetLabel		บAutor  ณMicrosiga	     บ Data ณ  21/11/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna a label do relatorio						 	      บฑฑ
ฑฑบ          ณ								                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
				cRet := "CONTEฺDO:"
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
				cRet := "CONTEฺDO:"
			EndIf
		EndIf

	ElseIf Alltrim(cCod) == "4"//Fabrica็ใo
		If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
			cRet := "FABRICAวรO:"
		ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
			cRet := "MANUFACTURE DATE:"
		ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
			cRet := "FECHA DE ELABORACIำN:"
		ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
			cRet := "FABRICAวรO:"
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

	ElseIf Alltrim(cCod) == "6"//Descri็ใo
		If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
			cRet := "DESCRIวรO: "
		ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
			cRet := "DESCRIPTION: "
		ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
			cRet := "DESCRIPCIำN: "
		ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
			cRet := "DESCRIวรO: "
		EndIf

	ElseIf Alltrim(cCod) == "7"//Composi็ใo
		If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
			cRet := "COMPOSIวรO: "
		ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
			cRet := "COMPOSITION: "
		ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
			cRet := "COMPOSICIำN: "
		ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
			cRet := "COMPOSIวรO: "
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

	ElseIf Alltrim(cCod) == "9"//Al้rgicos
		If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
			cRet := "ALษRGICOS: "
		ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
			cRet := "ALLERGIC: "
		ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
			cRet := "ALษRGICO: "
		ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
			cRet := "ALษRGICOS: "
		EndIf

	ElseIf Alltrim(cCod) == "10"//Manuseio
		If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
			cRet := "MANUSEIO: "
		ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
			cRet := "HANDLING: "
		ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
			cRet := "FORMA DE USO: "
		ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros37
			cRet := "MANUSEIO: "
		EndIf

	ElseIf Alltrim(cCod) == "11"//Emergencia
		If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
			cRet := "EMERGสNCIA: "
		ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
			cRet := "EMERGENCY: "
		ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
			cRet := "EMERGENCIA: "
		ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
			cRet := "EMERGสNCIA: "
		EndIf

	EndIf
	
		RestArea(aArea)
Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGetDXImp		บAutor  ณMicrosiga	     บ Data ณ  21/11/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna a descri็ใo a ser impressa				 	      บฑฑ
ฑฑบ          ณ								                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetDXImp(cCod, cArqTmp, aParam)

	Local aArea	:= GetArea()
	Local cRet	:= ""

	Default cCod 	:= ""
	Default cArqTmp	:= ""
	Default aParam	:= {}

	If Alltrim(cCod) == "1"//Descri็ใo do produto
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

		cUM := Alltrim((cArqTmp)->B1_UM)

		If _nOpc ==1
			If SubStr(aParam[3],1,1) == "1"//Primeira unidade de medida
				If aParam[2] == 0
					cRet := Alltrim(TRANSFORM((cArqTmp)->B1_PESO,"@E 9,999.999")+" "+cUM)
				Else
					cRet := Alltrim(TRANSFORM(aParam[2],"@E 9,999.999")+" "+cUM)
				EndIf
		
			ElseIf SubStr(aParam[3],1,1) == "2"//Segunda unidade de medida
				If aParam[2] == 0
					cRet := Alltrim(TRANSFORM((cArqTmp)->B1_PESO,"@E 9,999.999")+" "+Alltrim((cArqTmp)->B1_SEGUM))
				Else
					cRet := Alltrim(TRANSFORM(aParam[2],"@E 9,999.999")+" "+Alltrim((cArqTmp)->B1_SEGUM))
				EndIf
		
			EndIf

		EndIf

		If _nOpc == 3
			If LEFT(aParam[3],1) == "1"//Primeira unidade de medida
				If aParam[2] == 0
					cRet := Alltrim(TRANSFORM((cArqTmp)->B1_PESO,"@E 9,999.999")+" "+cUM)
				Else
					cRet := Alltrim(TRANSFORM(aParam[2],"@E 9,999.999")+" "+cUM)
				EndIf
		Else
			cRet := Alltrim(TRANSFORM((cArqTmp)->B1_QE,"@E 9,999.999")+" "+Alltrim((cArqTmp)->B1_SEGUM))
			EndIf
		Else
			cRet := Alltrim(TRANSFORM((cArqTmp)->B1_QE,"@E 9,999.999")+" "+cUM)		
		EndIf

		If _nOpc == 5
			If aParam[2] == 0
				cRet := Alltrim(TRANSFORM((cArqTmp)->B1_PESO,"@E 9,999.999")+" "+cUM)
			Else
				cRet := Alltrim(TRANSFORM(aParam[2],"@E 9,999.999")+" "+cUM)
			EndIf
		EndIf
		
		//Ajustado dia 18/04 para substituir toda a informa็ใo de UM quando o B1_XOBSETQ estiver preenchido. ~ [Denis Varella]
		If !Empty(Alltrim((cArqTmp)->B1_XOBSETQ))
			cRet := (cArqTmp)->B1_XOBSETQ
		EndIf

	ElseIf Alltrim(cCod) == "3"//Descri็ใo
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
				cRet := "CONTEM GLฺTEN"
			ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
				cRet := "CONTAIN GLUTEN"
			ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
				cRet := "CONTIENE GLUTEN"
			ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
				cRet := "CONTEM GLฺTEN"
			EndIf
		Else
			If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
				cRet := "NรO CONTEM GLฺTEN"
			ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
				cRet := "GLUTEN-FREE"
			ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
				cRet := "NO CONTIENE GLUTEN"
			ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
				cRet := "NรO CONTEM GLฺTEN"
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
			cRet := "Telefone de emerg๊ncia (11)3732-0000 - A ficha de informa็๕es de seguran็a de produtos quํmicos deste produto pode ser obtida no e-mail prozyn@prozyn.com.br"
		ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
			cRet := "Emergency phone number: + 55 11 3732-0000. The chemical product safety data sheet for this product can be obtained by the email prozyn@prozyn.com.br."
		ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
			cRet := "Tel้fono de emergencia: + 55 11 3732-0000. La ficha de informaci๓n de seguridad de productos quํmicos de este producto puede obtenerse en el correo electr๓nico prozyn@prozyn.com.br."
		ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
			cRet := "Telefone de emerg๊ncia (11)3732-0000 - A ficha de informa็๕es de seguran็a de produtos quํmicos deste produto pode ser obtida no e-mail prozyn@prozyn.com.br"
		EndIf

	ElseIf Alltrim(cCod) == "8"//Consumo humano
		If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
			cRet := "Produto nใo destinado para o consumo humano na forma como se apresenta."
		ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
			cRet := "Product not intended for human consumption in the way it is presented."
		ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
			cRet := "Producto no destinado al consumo humano en la forma en que se presenta."
		ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
			cRet := "Produto nใo destinado para o consumo humano na forma como se apresenta."
		EndIf

	ElseIf Alltrim(cCod) == "9"//Imagem transgenico
		If Substr(aParam[IDIOMA],1,1) == "1"//Portugues
			cRet := "\00-pictogramas\TRANSGสNICO.bmp"
		ElseIf Substr(aParam[IDIOMA],1,1) == "2"//Ingles
			cRet := "\00-pictogramas\TRANSGสNICOING.bmp"
		ElseIf Substr(aParam[IDIOMA],1,1) == "3"//Espanhol
			cRet := "\00-pictogramas\TRANSGสNICOESP.bmp"
		ElseIf Substr(aParam[IDIOMA],1,1) == "4"//Outros
			cRet := "\00-pictogramas\TRANSGสNICO.bmp"
		EndIf
	EndIf



	RestArea(aArea)
Return UPPER(Alltrim(cRet))


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGetNomeImp	บAutor  ณMicrosiga	     บ Data ณ  30/10/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o nome da impressora						 	      บฑฑ
ฑฑบ          ณ								                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPergRel  บAutor  ณMicrosiga	         บ Data ณ  01/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPergunta para selecionar o arquivo                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                               	                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PergRel(aParam)

	Local    aArea 		:= GetArea()
	Public   aParamBox	:= {} 
	Public   lRet		:= .F.
	Public   aIdioma	:= {"1-Portugu๊s","2-Ingl๊s","3-Espanhol","4-Outros"}
	Public   aUnidMed	:= {"1-Primeira Unidade","2-Segunda Unidade"}
	//Public   aReimpress	:= {"1-Nใo","2-Sim"}
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
		AADD(aParamBox,{1,"Rotulo"		,0	,"@E 9999","","","",50,.F.})	
		AADD(aParamBox,{1,"Rotulo Ate"		,0	,"@E 9999","","","",50,.F.})	
		AADD(aParamBox,{2,"Idioma"			,"1"	, aIdioma, 70,".T."				,.T.}	 )
	ElseIf _nOpc == 3
		AADD(aParamBox,{1,"Rotulo"			,Space(TamSx3("CB0_CODETI")[1])	,"","","","",50,.T.})
		AADD(aParamBox,{1,"Peso"		,0	,"@E 999,999,999.999","","","",50,.T.})
		AADD(aParamBox,{2,"Unid.de Medida"	,"1"	, aUnidMed, 70,".T."				,.T.})
		AADD(aParamBox,{2,"Idioma"			,"1"	, aIdioma, 70,".T."				,.T.})
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
		lRet := ParamBox(aParamBox, "Informe os Parโmetros", @aParam, , /*alButtons*/, .T., /*nlPosx*/, /*nlPosy*/,, cLoadArq, .t., .t.)
	Else 
		lRet := .F.
	EndIf
	

	RestArea(aArea)
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGetCArqD		บAutor  ณMicrosiga	     บ Data ณ  21/11/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o arquivo temporario						 	      บฑฑ
ฑฑบ          ณ								                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetCArqD(cOP)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()

	Default cOP	:= ""

	cQuery	:= " SELECT C2_NUM, C2_ITEM, C2_SEQUEN, C2_LOTECTL, C2_EMISSAO, C2_DTVALID, C2_QUANT, C2_PRODUTO, C2_LOCAL, "+CRLF
	cQuery	+= " 		B1_COD, B1_DESC, B1_DESCIN, B1_DESCES, B1_DESCOUT, B1_QE, B1_PESO, B1_TRANSGE, B1_PICTOG, "+CRLF
	cQuery	+= " 		B1_HALAL, B1_ALERGEN, B1_GLUTEN, B1_XDESTIN, B1_CODBAR, B1_UM, B1_XOBSETQ, B1_SEGUM, "+CRLF
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGetFrAlert		บAutor  ณMicrosiga   บ Data ณ  21/11/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna frase de alerta							 	      บฑฑ
ฑฑบ          ณ								                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGetQtdEtiq	บAutor  ณMicrosiga	     บ Data ณ  21/11/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna a quantidade de etiquetas					 	      บฑฑ
ฑฑบ          ณ								                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGetCodEti		บAutor  ณMicrosiga	     บ Data ณ  18/07/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o codigo da etiqueta								  บฑฑ
ฑฑบ          ณ												              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGravaCB0		บAutor  ณMicrosiga	     บ Data ณ  18/07/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza a rava็ใo dos dados na tabela CB0					  บฑฑ
ฑฑบ          ณ												              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

	If _nOpc <> 5
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
	EndIf

	CBGrvEti("01",aConteudo, Nil)

	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGetCodEtiq	บAutor  ณMicrosiga	     บ Data ณ  18/07/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna os codigos das etiquetas							  บฑฑ
ฑฑบ          ณ												              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGetReimp		บAutor  ณMicrosiga	     บ Data ณ  18/07/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna a reimpressใo de/ate								  บฑฑ
ฑฑบ          ณ												              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGetQtdMax		บAutor  ณMicrosiga	     บ Data ณ  18/07/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna a quantidade maxima da etiqueta					  บฑฑ
ฑฑบ          ณ												              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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


