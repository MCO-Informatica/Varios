#include 'protheus.ch'

#DEFINE OP			1
#DEFINE IDIOMA		2
#DEFINE UNIDMEDIDA	3
#DEFINE ETIQUEDADE	4
#DEFINE ETIQUETAATE	5
#DEFINE EMBALAGDE	6
#DEFINE EMBALAGATE	7
#DEFINE PALLET	8

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณPZCVR003		บAutor  ณMicrosiga	     บ Data ณ  04/07/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio do rotulo x acd									  บฑฑ
ฑฑบ          ณ(Imprime o relatorio com base na tabela CB0)                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User function PZCVR003()
Local aArea		:= GetArea()
Local aParams	:= {}
Local nModuloOld  := nModulo

nModulo     := 4


If PergRel(@aParams)
	Processa( {|| RunProcRel(Alltrim(aParams[OP]), aParams[IDIOMA], aParams[UNIDMEDIDA],;
	aParams[ETIQUEDADE], aParams[ETIQUETAATE],;
	aParams[EMBALAGDE], aParams[EMBALAGATE],aParams[PALLET] ) },"Aguarde...","" )
EndIf

nModulo		:= nModuloOld
RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณRunProcRel	บAutor  ณMicrosiga	     บ Data ณ  18/07/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza o processamento do relatorio						  บฑฑ
ฑฑบ          ณ												              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunProcRel(cOp, cIdioma, cUnidMed, cEtiqDe, cEtiqAte, cEmbDe, cEmbAte, cPallet )

Local aArea		:= GetArea()
Local cQuery	:= ""
Local cArqTmp	:= GetNextAlias()
Local nQtdEti	:= 0
Local nX		:= 0
Local nQtdAux	:= 0
Local aEtiq		:= {}
Local nTotal 	:= 0
Local nPallet	:= 0
Local aPallet 	:= {}

Default cOp			:= ""
Default cIdioma		:= ""
Default cUnidMed	:= ""
Default cEtiqDe		:= ""
Default cEtiqAte	:= ""
Default cEmbDe		:= ""
Default cEmbAte		:= ""

DbSelectArea("CB3")
CB3->(DbSetOrder(1))
CB3->(DbSeek(xFilial("CB3")+cPallet))
nPallet := CB3->CB3_PESO


cQuery	:= " SELECT C2_NUM, C2_ITEM, C2_SEQUEN, C2_PRODUTO, C2_LOCAL, "+CRLF
cQuery	+= " C2_QUANT, C2_DTVALID, C2_LOTECTL, B1_QE, B1_PESO FROM "+RetSqlName("SC2")+" SC2 "+CRLF

cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 "+CRLF
cQuery	+= " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
cQuery	+= " AND SB1.B1_COD = SC2.C2_PRODUTO "+CRLF
cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

cQuery	+= " WHERE SC2.C2_FILIAL = '"+xFilial("SC2")+"' "+CRLF
cQuery	+= " AND SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN = '"+cOp+"' "+CRLF
cQuery	+= " AND SC2.D_E_L_E_T_ = ' ' "+CRLF

DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)


While (cArqTmp)->(!Eof())
	
	//Verifica a quantidade de etiquetas a serem impressas
	If (cArqTmp)->B1_QE > 0
		While nQtdAux < (cArqTmp)->C2_QUANT
			++nQtdEti
			nQtdAux	+= (cArqTmp)->B1_QE
		EndDo
	Else
		nQtdEti := 1
	EndIf
	
	
	//Verifica se Ja Existe Cadastro da tabela CB0. Senใo existir serแ criado.
	If !ExistCB0((cArqTmp)->(C2_NUM+C2_ITEM+C2_SEQUEN), (cArqTmp)->C2_PRODUTO, (cArqTmp)->C2_LOTECTL)
		
		For nX := 1 To nQtdEti //Gera a CB0 de acordo com a quantidade por embalagem
			GetSxeNum("CB0","CB0_CODETIQ")
			ConfirmSx8()
			
			//Realiza a grava็ใo da tabela CB0
			GravaCB0((cArqTmp)->C2_PRODUTO,;		//Produto
			(cArqTmp)->B1_QE,; 						//Quantidade
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
			"")										//Centro de custo
			
		Next
		
		//Grava a sequencia da embalagem na tabela CB0 se nใo existir
		GravaSeqEti((cArqTmp)->(C2_NUM+C2_ITEM+C2_SEQUEN), (cArqTmp)->C2_LOTECTL, (cArqTmp)->C2_PRODUTO)
	EndIf
	
	//Codigo das etiquetas a serem impressas
	aEtiq := GetCodEtiq((cArqTmp)->(C2_NUM+C2_ITEM+C2_SEQUEN),;
	(cArqTmp)->C2_LOTECTL,;
	(cArqTmp)->C2_PRODUTO,;
	cEtiqDe, cEtiqAte, cEmbDe, cEmbAte)
	
	//Preenche os parametro para emissใo do relatorio
	MV_PAR01	:= (cArqTmp)->(C2_NUM+C2_ITEM+C2_SEQUEN)
	MV_PAR02	:= (cArqTmp)->C2_LOTECTL
	MV_PAR03	:= Val(cIdioma)
	MV_PAR04	:= Len(aEtiq)
	MV_PAR05	:= ""
	MV_PAR06	:= (cArqTmp)->B1_QE
	MV_PAR07	:= ""//1
	MV_PAR08	:= ""//Len(aEtiq)
	MV_PAR09	:= Val(cUnidMed)
	
	//Gera็ใo dos Pallets
	If nPallet > 0
		aCodPallet := {}
		aCodPallet := PZPALLET(aEtiq,nPallet)
	EndIf
	
	If nPallet > 0
		
		For nPlt := 1 to len(aCodPallet)
  			
  			cCod := GetMv("MV_PLLCIMP")
		
			CB5SetImp(cCod)

			ExecBlock("IMG10",,,{aCodPallet[nPlt]})
			
			MSCBCLOSEPRINTER()
  		
  			
		Next nPlt
	EndIf
	
	(cArqTmp)->(DbSkip())
EndDo

If Select(cArqTmp) > 0
	(cArqTmp)->(DbCloseArea())
EndIf

	//Executa a impressใo do relatorio de rotulo
	U_RPCPR002(.T., aEtiq)


RestArea(aArea)
Return


//FUNวรO MONTAGEM DA CHAMADO DO MSCBPRINTER CUSTOMIZADO PARA ATENDER AS NECESSIDADES DA PALLETIZAวรO DURANTE A GERAวรO DAS ETIQUETAS DO PRODUTO - PRODUวรO

static Function CB5SetImp(cCod,lVerServer,nDensidade,nTam,cPorta)
Local cModelo,lTipo,nPortIP,cServer,cEnv,cFila,lDrvWin

If Empty(cCod)
	Return .f.
EndIf
If ! CB5->(DbSeek(xFilial("CB5")+cCod))
	Return .f.
EndIf
cModelo :=Trim(CB5->CB5_MODELO)
If cPorta ==NIL
	If CB5->CB5_TIPO == '4'
		cPorta:= "IP"
	Else
		IF CB5->CB5_PORTA $ "12345"
			cPorta  :='COM'+CB5->CB5_PORTA+':'+CB5->CB5_SETSER
		EndIf
		IF CB5->CB5_LPT $ "12345"
			cPorta  :='LPT'+CB5->CB5_LPT+':'
		EndIf
	EndIf
EndIf

lTipo   :=CB5->CB5_TIPO $ '12'
nPortIP :=Val(CB5->CB5_PORTIP)
cServer :=Trim(CB5->CB5_SERVER)
cEnv    :=Trim(CB5->CB5_ENV)
cFila   := NIL
If CB5->CB5_TIPO=="3"
	cFila := Alltrim(Tabela("J3",CB5->CB5_FILA,.F.))
EndIf
nBuffer := CB5->CB5_BUFFER
lDrvWin := (CB5->CB5_DRVWIN =="1")
MSCBPRINTER(cModelo,cPorta,nDensidade,nTam,lTipo,nPortIP,cServer,cEnv,nBuffer,cFila,lDrvWin,Trim(CB5->CB5_PATH))
MSCBCHKSTATUS(CB5->CB5_VERSTA =="1")

Return .t.




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณPZPALLET		บAutor  ณDenis Varella   บ Data ณ  10/09/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza a gera็ใo dos pallets de acordo com as etiquetas 	  บฑฑ
ฑฑบ          ณgeradas.     									              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PZPALLET(aEtiq,nPallet)
Local nQtd := 0
Local cIDPallet := ""
Local nUltLine := 1
Local aCodPallet := {}

DbSelectArea("CB0")
DbSetOrder(1)

For nEtiq := 1 to len(aEtiq)
	CB0->(DbGoTop())
	CB0->(DbSeek(xFilial("CB0")+aEtiq[nEtiq]))
	
	//Caso a quantidade exceda a quantidade do pallet
	If (nQtd + CB0->CB0_QTDE) > nPallet
		aAdd(aCodPallet,GeraPallet(aEtiq,(nEtiq-1),nUltLine))
		nUltLine := nEtiq
		nQtd := 0
		
	ElseIf nEtiq == len(aEtiq)
		aAdd(aCodPallet,GeraPallet(aEtiq,len(aEtiq),nUltLine))
	EndIf
	
	nQtd += CB0->CB0_QTDE
	
Next nEtiq
Return aCodPallet

Static Function GeraPallet(aEtiq,nFim,nInicio)

cIDPallet := GetSxeNum("CB0","CB0_CODETIQ")
ConfirmSx8()

aArea := getArea()

For nItens := nInicio to nFim
	CB0->(DbGoTop())
	If CB0->(DbSeek(xFilial("CB0")+aEtiq[nItens]))
		CB0->(RecLock("CB0",.F.))
		CB0->CB0_PALLET := cIDPallet
		CB0->(MsUnlock())
	EndIf
Next nItens

RestArea(aArea)
Return cIDPallet

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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณExistCB0		บAutor  ณMicrosiga	     บ Data ณ  18/07/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se existe CB0									  บฑฑ
ฑฑบ          ณ												              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ExistCB0(cOp, cCodPro, cLote)

Local aArea		:= GetArea()
Local cQuery	:= ""
Local cArqTmp	:= GetNextAlias()
Local lRet		:= .F.

Default cOp		:= ""
Default cCodPro	:= ""
Default cLote	:= ""

cQuery	:= " SELECT COUNT(*) CONTADOR FROM "+RetSqlName("CB0")+" CB0 "+CRLF
cQuery	+= " WHERE CB0_FILIAL = '"+xFilial("CB0")+"' "+CRLF
cQuery	+= " AND CB0_OP = '"+cOp+"' "+CRLF
cQuery	+= " AND CB0_LOTE = '"+cLote+"' "+CRLF
cQuery	+= " AND CB0_CODPRO = '"+cCodPro+"' "+CRLF
cQuery	+= " AND CB0.D_E_L_E_T_ = ' ' "+CRLF

DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

If (cArqTmp)->(!Eof()) .And. (cArqTmp)->CONTADOR > 0
	lRet := .T.
EndIf

If Select(cArqTmp) > 0
	(cArqTmp)->(DbCloseArea())
EndIf

RestArea(aArea)
Return lRet

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
Static Function GravaSeqEti(cOp, cLote, cProd)

Local aArea		:= GetArea()
Local cQuery	:= ""
Local cArqTmp	:= GetNextAlias()
Local aRet		:= {}
Local cSeq		:= "1"

Default cOp			:= ""
Default cLote		:= ""
Default cProd		:= ""

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

While (cArqTmp)->(!Eof())
	CB0->(DbGoTo((cArqTmp)->RECCB0))
	
	RecLock("CB0",.F.)
	CB0->CB0_YSEQEM := cSeq
	CB0->(MsUnLock())
	
	cSeq := Soma1(cSeq)
	
	(cArqTmp)->(DbSkip())
EndDo

If Select(cArqTmp) > 0
	(cArqTmp)->(DbCloseArea())
EndIf

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
Static Function GetCodEtiq(cOp, cLote, cProd, cEtiDe, cEtiAte, cSeqEmbDe, cSeqEmbAte)

Local aArea		:= GetArea()
Local cQuery	:= ""
Local cArqTmp	:= GetNextAlias()
Local aRet		:= {}

Default cOp			:= ""
Default cLote		:= ""
Default cProd		:= ""
Default cEtiDe		:= ""
Default cEtiAte	:= ""
Default cSeqEmbDe	:= ""
Default cSeqEmbAte	:= ""

cQuery	:= " SELECT CB0_CODETI FROM "+RetSqlName("CB0")+" CB0 "+CRLF
cQuery	+= " WHERE CB0_FILIAL = '"+xFilial("CB0")+"' "+CRLF
cQuery	+= " AND CB0_CODETI BETWEEN '"+cEtiDe+"' AND '"+cEtiAte+"' "+CRLF
cQuery	+= " AND CB0_OP = '"+cOp+"' "+CRLF
cQuery	+= " AND CB0_LOTE = '"+cLote+"' "+CRLF
cQuery	+= " AND CB0_CODPRO = '"+cProd+"' "+CRLF
cQuery	+= " AND CB0_YSEQEM BETWEEN '"+cSeqEmbDe+"' AND '"+cSeqEmbAte+"' "+CRLF
cQuery	+= " AND CB0.D_E_L_E_T_ = ' ' "+CRLF
cQuery	+= " ORDER BY CB0_CODETI "+CRLF

DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

While (cArqTmp)->(!Eof())
	
	aAdd(aRet, (cArqTmp)->CB0_CODETI)
	
	(cArqTmp)->(DbSkip())
EndDo

If Select(cArqTmp) > 0
	(cArqTmp)->(DbCloseArea())
EndIf

RestArea(aArea)
Return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณPergRel	บAutor  ณMicrosiga		     บ Data ณ  13/12/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Perguntas a serem utilizadas no filtro				      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PergRel(aParams)

Local aParamBox := {}
Local lRet      := .T.
Local cLoadArq	:= "PZCVR003X"+Alltrim(RetCodUsr())+Alltrim(cEmpAnt)
Local nTamOp	:= TAMSX3("C2_NUM")[1]+TAMSX3("C2_ITEM")[1]+TAMSX3("C2_SEQUEN")[1]

AADD(aParamBox,{1,"OP"				,Space(nTamOp)		,"","","SC2","",50,.T.})
AADD(aParamBox,{2,"Idioma"			,"1"	, {"1=Portugues","2=Ingles","3=Espanhol","Outros"}	, 70,""	,.T.})
AADD(aParamBox,{2,"Unidade Medida"	,"1"	, {"1=Primeira Unid","2=Segunda Unid"}				, 70,""	,.T.})
AADD(aParamBox,{1,"Etiqueta De"		,Space(TAMSX3("CB0_CODETI")[1])	,"","","","",50,.F.})
AADD(aParamBox,{1,"Etiqueta Ate"	,Space(TAMSX3("CB0_CODETI")[1])	,"","","","",50,.T.})
AADD(aParamBox,{1,"Embalag.De"		,Space(TAMSX3("CB0_YSEQEM")[1])	,"","","","",50,.F.})
AADD(aParamBox,{1,"Embalag.Ate"		,Space(TAMSX3("CB0_YSEQEM")[1])	,"","","","",50,.T.})
AADD(aParamBox,{1,"Pallet"			,Space(TAMSX3("CB3_CODEMB")[1])	,"","","CB3PLT","",70,.F.})

lRet := ParamBox(aParamBox, "Parโmetros", aParams, , /*alButtons*/, .T., /*nlPosx*/, /*nlPosy*/,, cLoadArq, .t., .T.)

Return lRet
