#INCLUDE "protheus.ch"

/*/


-¿
³Funao    ³GH        ³ Autor ³ MICROSIGA             ³ Data ³ 08/05/13 ³
-´
³Descriao ³ Funcao Principal                                           ³
-´
³Uso       ³ Gestao Hospitalar                                          ³
-Ù


/*/
User Function UPD1GCT()

cArqEmp 					:= "SigaMat.Emp"
__cInterNet 	:= Nil

PRIVATE cMessage
PRIVATE aArqUpd	 := {}
PRIVATE aREOPEN	 := {}
PRIVATE oMainWnd
Private nModulo 	:= 51 // modulo SIGAHSP

Set Dele On

lEmpenho				:= .F.
lAtuMnu					:= .F.

Processa({|| ProcATU()},"Processando [GH]","Aguarde , processando preparaço dos arquivos")

Return()


/*

¿
³Fun…o    ³ProcATU   ³ Autor ³                       ³ Data ³  /  /    ³
´
³Descri…o ³ Funcao de processamento da gravacao dos arquivos           ³
´
³ Uso      ³ Baseado na funcao criada por Eduardo Riera em 01/02/2002   ³
Ù

*/
Static Function ProcATU()
Local cTexto    	:= ""
Local cFile     	:= ""
Local cMask     	:= "Arquivos Texto (*.TXT) |*.txt|"
Local nRecno    	:= 0
Local nI        	:= 0
Local nX        	:= 0
Local aRecnoSM0 	:= {}
Local lOpen     	:= .F.

ProcRegua(1)
IncProc("Verificando integridade dos dicionrios....")
If (lOpen := IIF(Alias() <> "SM0", MyOpenSm0Ex(), .T. ))

	dbSelectArea("SM0")
	dbGotop()
	While !Eof()
  		If Ascan(aRecnoSM0,{ |x| x[2] == M0_CODIGO}) == 0
			Aadd(aRecnoSM0,{Recno(),M0_CODIGO})
		EndIf			
		dbSkip()
	EndDo	

	If lOpen
		For nI := 1 To Len(aRecnoSM0)
			SM0->(dbGoto(aRecnoSM0[nI,1]))
			RpcSetType(2)
			RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
 		nModulo := 51 // modulo SIGAHSP
			lMsFinalAuto := .F.
			cTexto += Replicate("-",128)+CHR(13)+CHR(10)
			cTexto += "Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME+CHR(13)+CHR(10)

			ProcRegua(8)

			Begin Transaction

			//¿
			//³Atualiza o dicionario de dados.³
			//Ù
			IncProc("Analisando Dicionario de Dados...")
			cTexto += GeraSX3()
			//¿
			//³Atualiza os parametros.        ³
			//Ù
			IncProc("Analisando Paramêtros...")
 		cTexto += GeraSX6()
			//¿
			//³Atualiza os gatilhos.          ³
			//Ù
			IncProc("Analisando Gatilhos...")
			cTexto += GeraSX7()

			End Transaction
	
			__SetX31Mode(.F.)
			For nX := 1 To Len(aArqUpd)
				IncProc("Atualizando estruturas. Aguarde... ["+aArqUpd[nx]+"]")
				If Select(aArqUpd[nx])>0
					dbSelecTArea(aArqUpd[nx])
					dbCloseArea()
				EndIf
				X31UpdTable(aArqUpd[nx])
				If __GetX31Error()
					Alert(__GetX31Trace())
					Aviso("Atencao!","Ocorreu um erro desconhecido durante a atualizacao da tabela : "+ aArqUpd[nx] + ". Verifique a integridade do dicionario e da tabela.",{"Continuar"},2)
					cTexto += "Ocorreu um erro desconhecido durante a atualizacao da estrutura da tabela : "+aArqUpd[nx] +CHR(13)+CHR(10)
				EndIf
				dbSelectArea(aArqUpd[nx])
			Next nX		

			RpcClearEnv()
			If !( lOpen := MyOpenSm0Ex() )
				Exit
		 EndIf
		Next nI
		
		If lOpen
			
			cTexto 				:= "Log da atualizacao " + CHR(13) + CHR(10) + cTexto
			__cFileLog := MemoWrite(Criatrab(,.f.) + ".LOG", cTexto)
			
			DEFINE FONT oFont NAME "Mono AS" SIZE 5,12
			DEFINE MSDIALOG oDlg TITLE "Atualizador [GH] - Atualizacao concluida." From 3,0 to 340,417 PIXEL
				@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
				oMemo:bRClicked := {||AllwaysTrue()}
				oMemo:oFont:=oFont
				DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
				DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."
			ACTIVATE MSDIALOG oDlg CENTER
	
		EndIf
		
	EndIf
		
EndIf 	

Return(Nil)


/*

¿
³Fun…o    ³MyOpenSM0Ex³ Autor ³Sergio Silveira       ³ Data ³07/01/2003³
´
³Descri…o ³ Efetua a abertura do SM0 exclusivo                         ³
´
³ Uso      ³ Atualizacao FIS                                            ³
Ù

*/
Static Function MyOpenSM0Ex()

Local lOpen := .F.
Local nLoop := 0

For nLoop := 1 To 20
	dbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .F., .F. )
	If !Empty( Select( "SM0" ) )
		lOpen := .T.
		dbSetIndex("SIGAMAT.IND")
		Exit	
	EndIf
	Sleep( 500 )
Next nLoop

If !lOpen
	Aviso( "Atencao !", "Nao foi possivel a abertura da tabela de empresas de forma exclusiva !", { "Ok" }, 2 )
EndIf

Return( lOpen )




/*/


¿
³Funao    ³ GeraSX3  ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³
´
³Descriao ³ Funcao generica para copia de dicionarios                  ³
´
³Uso       ³ Generico                                                   ³
Ù


/*/
Static Function GeraSX3()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"CNB","01","CNB_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","Sucursaldelsistema","SystemBranch","@!","","€€€€€€€€€€€€€€€","","",01,"„€","","","","N","","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","02","CNB_NUMERO","C",06,00,"NrPlanilha","NrPlanilla","Works.Nr","NumerodaPlanilha","NumerodelaPlanilla","WorksheetNumber","@!","","€€€€€€€€€€€€€€ ","","",01,"†€","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","03","CNB_REVISA","C",03,00,"Revisao","Revision","Review","Revisao","Revision","Review","@!","","€€€€€€€€€€€€€€ ","","",01,"†€","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","04","CNB_ITEM","C",03,00,"NrdoItem","NrdelItem","Itemnumber","NumerodoItem","NumerodelItem","Itemnumber","@!","","€€€€€€€€€€€€€€ ","","",01,"†€","","","","S","V","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","05","CNB_PROGAR","C",32,00,"Prod.GAR","Prod.GAR","Prod.GAR","ProdutoGar","ProdutoGar","ProdutoGar","","","€€€€€€€€€€€€€€ ","","PA8",00,"þ","","S","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"CNB","06","CNB_DESGAR","C",128,00,"Desc.GAR","Desc.GAR","Desc.GAR","Desc.Prod.GAR","Desc.Prod.GAR","Desc.Prod.GAR","","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"CNB","07","CNB_PRODUT","C",15,00,"Produto","Producto","Product","Produto","Producto","Product","@!","ExistCpo('SB1')","€€€€€€€€€€€€€€ ","","SB1",01,"€","","S","","S","A","R","","","","","","","","","030","","N","","","N","N","N","","N","N","N"})
AADD(aRegs,{"CNB","08","CNB_DESCRI","C",30,00,"Descricao","Descripcion","Description","Descricao","Descripcion","Description","@!","","€€€€€€€€€€€€€€ ","","",01,"Ö","","","","S","V","R","","","","","","","","","","","N","","","N","N","N","","N","N","N"})
AADD(aRegs,{"CNB","09","CNB_UM","C",02,00,"Unidade","Unidad","Unit","UnidadedoProduto","UnidaddelProducto","ProductUnit","@!","ExistCpo('SAH')","€€€€€€€€€€€€€€ ","","SAH",01,"€","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","10","CNB_QUANT","N",12,04,"Quantidade","Cantidad","Quantity","Quantidade","Cantidad","Quantity","@E999,999.9999","Positivo().And.CN140VldQtd()","€€€€€€€€€€€€€€ ","","",01,"Ÿ€","","S","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","11","CNB_VLUNIT","N",18,02,"Vl.Unitario","Vl.Unitario","UnitValue","ValorUnitario","ValorUnitario","UnitValue","@E999,999,999,999.99","Positivo()","€€€€€€€€€€€€€€ ","","",01,"Ÿ€","","S","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","12","CNB_VLTOT","N",18,02,"ValorTotal","ValorTotal","Totalamount","ValorTotal","ValorTotal","Totalamount","@E999,999,999,999.99","Positivo()","€€€€€€€€€€€€€€ ","","",01,"ž€","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","13","CNB_DESC","N",05,02,"Desconto%","Descuento","Discount%","Desconto%","Descuento","Discount%","@E999.99","Positivo().And.M->CNB_DESC<=100","€€€€€€€€€€€€€€ ","","",01,"š€","","S","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","14","CNB_VLDESC","N",14,02,"Vl.Desconto","Vl.Dcto.","DiscountAmt","ValordoDesconto","ValordeDescuento","DiscountAmount","@E999,999,999.99","","€€€€€€€€€€€€€€ ","","",01,"ž€","","","","S","V","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","15","CNB_CODMEN","C",06,00,"CodigoMemo","CodigoMemo","Memocode","CodigoMemo","CodigoMemo","Memocode","@!","","€€€€€€€€€€€€€€€","","",01,"†€","","","","N","V","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","16","CNB_DTANIV","D",08,00,"DtAnivers","Fc.Anivers","BirthDate","DatadeAniversario","FechadeAniversario","BirthDate","","","€€€€€€€€€€€€€€ ","","",01,"†€","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","17","CNB_CONORC","C",20,00,"ContaOrcam","CuentaPres.","BudgetAcc.","ContaOrcamentaria","CuentaPresupuestaria","BudgetAccount","@!","","€€€€€€€€€€€€€€ ","","",01,"†€","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","18","CNB_CONTRA","C",15,00,"NrContrato","NrContrato","ContractNbr","NumerodoContrato","NumerodeContrato","ContractNumber","@!","","€€€€€€€€€€€€€€ ","","",01,"†€","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","19","CNB_DTCAD","D",08,00,"DtCadastro","Fc.Registro","FileDate","DatadoCadastro","FechadeRegistro","FileDate","","","€€€€€€€€€€€€€€ ","","",01,"†€","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","20","CNB_DTPREV","D",08,00,"DtEntrega","Fc.Entrega","Deliv.Date","DataPrevistadeEntrega","FechaPrevistadeEntrega","EstimatedDeliveryDate","","","€€€€€€€€€€€€€€ ","","",01,"†€","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","21","CNB_QTDMED","N",12,04,"Qtd.Medida","Ctd.Medida","Measur.Qty.","QuantidadeMedida","CantidadMedida","MeasuredQuantity","@E999,999.9999","","€€€€€€€€€€€€€€ ","","",01,"ž€","","","","S","V","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","22","CNB_CONTA","C",18,00,"ContaContab","CuentaContb","LedgerAcc.","ContaContabil","CuentaContable","LedgerAccount","@!","","€€€€€€€€€€€€€€ ","","",01,"†","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","23","CNB_PERC","N",05,02,"Percentual","Porcentaje","Percentage","PercentualdoItem","PorcentajedelItem","Percentageofitem","@E999,99","Positivo().And.(M->CNB_PERC<=100)","€€€€€€€€€€€€€€ ","","",01,"†€","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","24","CNB_RATEIO","C",01,00,"Rateio?S/N","Prorrateo","ApportY/N","Rateio?S/N","Prorrateo","ApportionmentY/N","@!","Pertence('12')","€€€€€€€€€€€€€€ ","","",01,"†€","","","","S","A","R","","","1=Sim;2=Nao","1=Si;2=No","1=Yes;2=No","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","25","CNB_TIPO","C",01,00,"TipoItem","TipoItem","Itemtype","TipodoItem","TipodelItem","Itemtype","@!","","€€€€€€€€€€€€€€ ","","",01,"†€","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","26","CNB_ITSOMA","C",01,00,"ItemSoma","ItemSuma","AdditionItem","ItemSoma","ItemSuma","Additionitem","@!","","€€€€€€€€€€€€€€ ","","",01,"†€","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","27","CNB_PRCORI","N",18,02,"VlrOriginal","VlrOriginal","OriginalVal","ValorUnitarioOriginal","ValorUnitarioOriginal","OriginalValue","@E999,999,999,999.99","","€€€€€€€€€€€€€€ ","","",01,"ž€","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","28","CNB_QTDORI","N",12,04,"QtdOriginal","CtdOriginal","OriginalQty","QuantidadeOriginal","CantidadOriginal","OriginalQuantity","@E999,999.9999","","€€€€€€€€€€€€€€ ","","",01,"ž€","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","29","CNB_QTRDAC","N",12,04,"QtAcrescida","Ctd.aum.","AddedQty.","QuantidadeAcrescida","Cantidadaumentada","AddedQuantity","@E999,999.9999","","€€€€€€€€€€€€€€ ","","",01,"ž€","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","30","CNB_QTRDRZ","N",12,04,"QtReduzida","Ctd.Reducid","ReducedQty.","QuantidadeReduzida","CantidadReducida","ReducedQuantity","@E999,999.9999","","€€€€€€€€€€€€€€ ","","",01,"ž€","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","31","CNB_QTREAD","N",12,04,"QtReadequad","Ctd.readec.","Refitt.Qty.","QuantidadeReadequada","CantidadReadecuada","RefittedQuantity","@E999,999.9999","","€€€€€€€€€€€€€€ ","","",01,"ž€","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","32","CNB_VLREAD","N",18,02,"VlReadequad","VlReadec.","RefittedVal","ValorReadequado","ValorReadecuado","RefittedValue","@E999,999,999,999.99","","€€€€€€€€€€€€€€ ","","",01,"ž€","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","33","CNB_VLRDGL","N",18,02,"ValorGlobal","ValorGlobal","GlobalValue","ValorGlobalReadequado","ValorGlobalReadecuado","GlobalValueRefitted","@E999,999,999,999.99","","€€€€€€€€€€€€€€ ","","",01,"ž€","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","34","CNB_PERCAL","N",12,04,"%Calculo","%Calculo","%Calculat.","%Calculo","%Calculo","%Calculation","@E99999.99","","€€€€€€€€€€€€€€ ","","",01,"ž€","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","35","CNB_FILHO","N",05,00,"IndicaPai","IndicaPrinc","Indic.parent","IndicaoPai","Indicaprincipal","Indicatesparent","@E99999","","€€€€€€€€€€€€€€ ","","",01,"ž€","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","36","CNB_SLDMED","N",12,04,"Saldo","Saldo","Balance","SaldoparaserMedido","Saldoparamedirse","Balancetomeasure","@E999,999.9999","","€€€€€€€€€€€€€€ ","","",01,"ž€","","","","S","V","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","37","CNB_NUMSC","C",06,00,"NumerodaSC","NumerodeSC","PRNumber","Numerodasolicita.compra","Numerodesolicit.compra","PurchaseRequisit.Number","@!","","€€€€€€€€€€€€€€ ","","SC1",01,"†€","","","","N","V","","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","38","CNB_ITEMSC","C",04,00,"ItemdaSC","ItemdeSX","PRItem","Itemdasolic.compra","Itemdesolic.compra","PurchaseRequestItem","@!","","€€€€€€€€€€€€€€ ","","",01,"†€","","","","N","V","","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","39","CNB_QTDSOL","N",12,02,"QtSolicita","Ctd.Solicitu","Requir.Qty.","QuantidadeSolicitada","CantidadSolicitada","RequiredQuantity","@!9,999,999.99","","€€€€€€€€€€€€€€ ","","",01,"†€","","","","N","V","","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","40","CNB_SLDREC","N",12,04,"SldReceber","SldCobrar","Blnce.rcvbl","SaldoaReceber","SaldoporCobrar","Balancereceivable","@E999,999.9999","","€€€€€€€€€€€€€€ ","","",01,"ž€","","","","N","V","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","41","CNB_REALI","N",18,02,"VlRealinhad","VlRealinhad","VlRealinhad","ValorRealinhado","ValorRealinhado","ValorRealinhado","@E999,999,999,999.99","CN140VldRel()","€€€€€€€€€€€€€€ ","","",01,"ƒ€","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","42","CNB_DTREAL","D",08,00,"DtRealinham","DtRealinham","DtRealinham","DtBasedeRealinhamento","DtBasedeRealinhamento","DtBasedeRealinhamento","","CN140VldDtR()","€€€€€€€€€€€€€€ ","","",01,"€","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","43","CNB_VLTOTR","N",18,02,"VlTotReali","VlTotReali","VlTotReali","ValorTotalRealinhado","ValorTotalRealinhado","ValorTotalRealinhado","@E999,999,999,999.99","","€€€€€€€€€€€€€€ ","","",01,"€","","","","S","V","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CNB","44","CNB_FLGCMS","C",01,00,"Ctr.Com.","Contr.Com.","Ctrl.comm.","ControlaComissao","ControlaComision","Controlcommission","@!","Pertence('12')","€€€€€€€€€€€€€€ ","'1'","",01,"€","","","","S","A","R","","","1=Sim;2=Nao","1=Si;2=No","1=Yes;2=No","","","","","","N","","","N","N","N","","N","N","N"})
AADD(aRegs,{"CNB","45","CNB_TE","C",03,00,"TipoEntrada","TipoEntrada","EntryType","TipodeEntradadaNota","TipodeEntr.deFactura","NotaFiscalEntryType","@!","(Vazio().Or.ExistCPO('SF4')).And.CN200VldTE()","€€€€€€€€€€€€€€ ","","SF4",01,"†€","","","","N","A","R","N","","","","","","","","","","S","","","","","","","N","N","N"})
AADD(aRegs,{"CNB","46","CNB_TS","C",03,00,"TipoSaida","TipoSalida","OutflowType","TipodeSaidadaNota","TipodeSalidadeFactura","NotaFiscalOutflowType","@!","CN200VldTS()","€€€€€€€€€€€€€€ ","","SF4",01,"†€","","","","N","A","R","N","","","","","","","","","","S","","","","","","","N","N","N"})
AADD(aRegs,{"CNB","47","CNB_COPMED","C",01,00,"ItMdGrCop","ItMdGrCop","ItMdGrCop","It.Med.gerouCopia-SNO","It.Med.gen.Copia-SNO","It.Mea.gen.Copie-YNO","@!","","€€€€€€€€€€€€€€ ","","",01,"†€","","","","N","A","R","N","","","","","","","","","","S","","","","","","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"CND","01","CND_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","Sucursaldelsistema","SystemBranch","@!","","€€€€€€€€€€€€€€€","","",01,"„€","","","","N","","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","02","CND_NUMMED","C",06,00,"NrMedicao","NrMedicion","Measur.Nbr.","NumerodaMedicao","NumerodeMedicion","MeasurementNumber","@!","","€€€€€€€€€€€€€€ ","CN130NumMd()","ExistC",01,"€","","","","S","V","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","03","CND_DTINIC","D",08,00,"DtInclusao","Fc.Inclus.","InsertionDt","DatadaIncluso","FechadelaInclusion","InsertionDate","","","€€€€€€€€€€€€€€ ","dDatabase","",01,"†€","","","","S","V","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","04","CND_DTVENC","D",08,00,"Vencimento","Vencimiento","DueDate","DatadeVencimento","FechadeVencimiento","DueDate","","","€€€€€€€€€€€€€€ ","","",01,"†€","","","","S","V","R","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","05","CND_DTFIM","D",08,00,"DataFinal","FechaFinal","Finaldate","DataFinal","FechaFinal","Finaldate","","","€€€€€€€€€€€€€€ ","","",01,"†€","","","","S","V","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","06","CND_VLMEAC","N",18,02,"MedAcum","MedAcum","Accr.Measurm","MedicoesAcumuladas","MedicionesAcumuladas","AccruedMeasurement","@E999,999,999,999.99","","€€€€€€€€€€€€€€ ","","",01,"ž€","","","","S","V","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","07","CND_VLTOT","N",18,02,"ValorTotal","ValorTotal","TotalValue","ValorTotaldaMedicao","ValorTotaldeMedicion","Measurm.ofTotalValue","@E999,999,999,999.99","","€€€€€€€€€€€€€€ ","","",01,"ž€","","","","S","V","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","08","CND_VLSALD","N",18,02,"SaldoMed","SaldoMed","Measur.Bal.","SaldodaMedicao","SaldodelaMedicion","MeasurementBalance","@E999,999,999,999.99","","€€€€€€€€€€€€€€ ","","",01,"ž€","","","","S","V","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","09","CND_ZERO","C",01,00,"Zero?S/N","Cero","Zero?Y/N","Zero?S/N","Cero","Zero?Y/N","@!","Pertence('12')","€€€€€€€€€€€€€€ ","'2'","",01,"€","","","","S","A","R","","","1=Sim;2=Nao","1=Si;2=No","1=Yes;2=No","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","10","CND_CODOBS","C",06,00,"Cod.Obs.","Cod.Obs.","Rem.Code","CodigodaObservacao","CodigodelaObservacion","RemarksCode","@!","","€€€€€€€€€€€€€€€","","",01,"†€","","","","N","V","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","11","CND_OBS","M",254,00,"Observacao","Observacion","Remarks","Observacao","Observacion","Remarks","@!","","€€€€€€€€€€€€€€ ","","",01,"†€","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","12","CND_DATAIN","D",08,00,"InicioMedic","InicioMedic","IniMeasure","DataIniciodaMedicao","FechaIniciodeMedic.","InitialMeasurementDate","","","€€€€€€€€€€€€€€ ","","",01,"†€","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","13","CND_DATAFI","D",08,00,"FimMedicao","FinMedic.","MeasureFin","DataFinaldaMedicao","FechaFinaldeMedicion","FinalMeasurementDate","","","€€€€€€€€€€€€€€ ","","",01,"†€","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","14","CND_FORNEC","C",06,00,"Fornecedor","Proveedor","Supplier","CodigodoFornecedor","CodigodelProveedor","SupplierCode","@!","ExistCpo('SA2')","€€€€€€€€€€€€€€ ","","CNC001",01,"€","","S","","S","A","R","","","","","","","","","001","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","15","CND_LJFORN","C",02,00,"Loja","Tienda","Shop","LojadoFornecedor","TiendadelProveedor","SupplierShop","@!","ExistCpo('SA2',M->CND_FORNEC+M->CND_LJFORN)","€€€€€€€€€€€€€€ ","","",01,"€","","","","S","A","R","","","","","","","","","002","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","16","CND_CONTRA","C",15,00,"NrContrato","NrContrato","ContractNr","NumerodoContrato","NumerodelContrato","ContractNumber","@!","ExistCpo('CN9')","€€€€€€€€€€€€€€ ","","CN9",01,"†€","","","","S","V","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","17","CND_REVISA","C",03,00,"NrRevisao","NrRevision","ReviewNr","NumerodaRevisao","NumerodeRevision","ReviewNumber","@!","","€€€€€€€€€€€€€€ ","","",01,"†€","","","","S","V","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","18","CND_COMPET","C",07,00,"Competencia","Competencia","Competence","Competencia","Competencia","Competence","@!","","€€€€€€€€€€€€€€ ","","",01,"†€","","","","S","V","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","19","CND_CONDPG","C",03,00,"CondPagto","CondPago","PaytTerm","CondicaodePagamento","CondiciondePago","PaymentTerm","@!","ExistCpo('SE4')","€€€€€€€€€€€€€€ ","","SE4",01,"†€","","S","","S","V","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","20","CND_DESCCP","C",15,00,"DescCond","DescCond","Paym.Term","DescriçoCondPagamento","Descrip.CondPago","PaymentTermDescription","@!","","€€€€€€€€€€€€€€ ","IF(INCLUI,'',Posicione('SE4',1,xFilial('SE4')+CND->CND_CONDPG,'E4_DESCRI'))","",01,"†","","","","N","V","V","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","21","CND_VLCONT","N",18,02,"VlContrato","VlContrato","ContractAmt","ValordoContrato","ValordelContrato","ContractAmount","@E999,999,999,999.99","","€€€€€€€€€€€€€€ ","","",01,"ž€","","","","S","V","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","22","CND_VLADIT","N",18,02,"VlAditivo","VlAditivo","Addit.Amt","ValordoAditivo","ValordelAditivo","AdditionAmount","@E999,999,999,999.99","","€€€€€€€€€€€€€€ ","","",01,"ž€","","","","S","V","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","23","CND_VLREAJ","N",18,02,"VlReajuste","VlReajuste","Readj.Amt","ValordoReajuste","ValordelReajuste","ReadjustmentAmount","@E999,999,999,999.99","","€€€€€€€€€€€€€€ ","","",01,"ž€","","","","S","V","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","24","CND_VLGER","N",18,02,"VlTotContr","VlTotContr","TotContAmt","ValorTotaldoContrato","ValorTotaldelContrato","TotalContractAmount","@E999,999,999,999.99","","€€€€€€€€€€€€€€ ","","",01,"ž€","","","","S","V","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","25","CND_NUMERO","C",06,00,"NrPlanilha","NrPlanilla","WorksNr","NumerodaPlanilha","NumerodelaPlanilla","WorksheetNumber","@!","","€€€€€€€€€€€€€€ ","","",01,"†€","","","","S","V","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","26","CND_TIPPLA","C",03,00,"Tipo","Tipo","Type","TipodaPlanilha","TipodelaPlanilla","Worksheettype","@!","Pertence('123')","€€€€€€€€€€€€€€ ","IF(INCLUI,'',Posicione('CNA',1,xFilial('CNA')+CND->CND_CONTRA+CND->CND_REVISA+CND->CND_NUMERO,'CNA_TIPPLA'))","CNL",01,"†€","","","","S","V","V","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","27","CND_DESCTP","C",30,00,"DescTipPla","DescTp.Pl.","Wst.Tp.Desc.","DescTipodePlanilha","DescTipodePlanilla","WorksheetTypeDescrip.","@!","","€€€€€€€€€€€€€€ ","CN120RetTip()","",01,"†","","","","N","V","V","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","28","CND_MEDRET","C",06,00,"MedicaoOrig","Medic.Orig.","Sourc.Measur","MedicaoRetificada","MedicionRectificada","RectifiedMeasurement","@!","","€€€€€€€€€€€€€€ ","","",01,"†€","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","29","CND_RETIFI","C",01,00,"Retificada?","Rectificada","Rectified","Retificada?S/N","Rectificada","RectifiedY/N","@!","Pertence('12')","€€€€€€€€€€€€€€ ","","",01,"†€","","","","S","A","R","","","1=Sim;2=Nao","1=Si;2=No","1=Yes;2=No","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","30","CND_FLREAJ","C",01,00,"Reajuste","Reajuste","Readjustment","FlagReajuste","FlagReajuste","ReadjustmentFlag","@!","","€€€€€€€€€€€€€€ ","","",01,"†€","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","31","CND_VLPREV","N",18,02,"VlPrevisto","VlPrevisto","Estim.Value","ValorPrevisto","ValorPrevisto","EstimatedValue","@E999,999,999,999.99","","€€€€€€€€€€€€€€ ","","",01,"†€","","","","S","V","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","32","CND_DESCME","N",18,02,"DescontoMed","Descuento","Discount","DescontodaMedicao","Descuento","Discount","@E999,999,999,999.99","","€€€€€€€€€€€€€€ ","","",01,"†€","","","","S","A","R","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"CND","33","CND_CLIENT","C",06,00,"Cliente","Cliente","CustomerCode","CodigodoCliente","CodigodelCliente","Customercode","@!","ExistCpo('SA1')","€€€€€€€€€€€€€€ ","","SA1",01,"–€","","","","S","V","R","","","","","","","","","001","","N","","","N","N","N","","N","N","N"})
AADD(aRegs,{"CND","34","CND_LOJACL","C",02,00,"Lj.Cliente","Tda.Cliente","CustomerStor","LojadoCliente","TiendadelCliente","Customerstore","@!","ExistCpo('SA1',M->CND_CLIENT+M->CND_LOJACL)","€€€€€€€€€€€€€€ ","","",01,"–€","","","","S","A","R","","","","","","","","","002","","N","","","N","N","N","","N","N","N"})
AADD(aRegs,{"CND","35","CND_TOTADT","N",18,02,"ValorAdiant","ValorAntic.","Adv.amnt.","ValordoAdiantamento","ValordelAnticipo","Advanceamount","@E999,999,999,999.99","","€€€€€€€€€€€€€€ ","","",01,"ž€","","","","S","V","R","","","","","","","","","","","N","","","N","N","N","","N","N","N"})
AADD(aRegs,{"CND","37","CND_MOEDA","N",02,00,"Moeda","Moneda","Currency","MoedadaMedicao","MonedadelaMedicion","Measurementcurrency","99","M->CND_MOEDA>0.AND.M->CND_MOEDA<=MOEDFIN().AND.CN130MOEDA()","€€€€€€€€€€€€€€ ","","",01,"–€","","","","S","A","R","","","","","","","","","","","N","","","N","N","N","","N","N","N"})
AADD(aRegs,{"CND","38","CND_ALCAPR","C",01,00,"Sit.Alcada","Sit.Compet.","Comp.Status","SituaçodaAlçada","Situaciondecompetencia","CompetenceStatus","@!","","€€€€€€€€€€€€€€ ","'L'","",01,"Ö","","","","N","V","R","","","B=Bloqueada;L=Liberada","B=Bloqueada;L=Liberada","B=Blocked;L=Released","","","","","","N","","","N","N","N","","N","N","N"})
AADD(aRegs,{"CND","39","CND_APROV","C",06,00,"Aprovadores","Aprobadores","Approvers","GrupodeAprovadores","Grupodeaprobadores","GroupofApprovers","@!","ExistCpo('SAL')","€€€€€€€€€€€€€€ ","CN130RetGrp()","SAL",01,"Ö","","","","N","V","R","","","","","","","","","","","N","","","N","N","N","","N","N","N"})
AADD(aRegs,{"CND","40","CND_PARCEL","C",02,00,"NumParcela","Numcuota","Install.Nbr","NumerodaParcela","Numerodelacuota","InstallmentNumber","@!","","€€€€€€€€€€€€€€ ","","",01,"†€","","","","N","V","R","","","","","","","","","011","","N","","","N","N","N","","N","N","N"})
AADD(aRegs,{"CND","41","CND_AUTFRN","C",01,00,"Aut.Fornec.","Aut.Suminis","SupplyAuth.","Autori.deFornecimento","Autoriz.deSuministro","SypplyAuthorization","@!","","€€€€€€€€€€€€€€ ","","",01,"†","","","","N","V","R","","","1=Nao;2=Sim","1=No;2=Si","1=No;2=Yes","","","","","","N","","","N","N","N","","N","N","N"})
AADD(aRegs,{"CND","42","CND_PEDIDO","C",06,00,"PEDIDO","PEDIDO","PEDIDO","PEDIDO","PEDIDO","PEDIDO","@!","","€€€€€€€€€€€€€€ ","","",01,"†A","","","","N","A","R","","","","","","","","","","","N","","","N","N","N","","N","N","N"})
AADD(aRegs,{"CND","44","CND_RETCAC","N",15,02,"Ret.Caucao","","","ValorRetido","","","@E9999,999,999.99","","€€€€€€€€€€€€€€ ","'1'","",01,"€","","","","S","A","R","","","","","","","","","","","N","","","N","N","N","","N","N","N"})
AADD(aRegs,{"CND","45","CND_PARC1","N",12,02,"Parcela1","Cuota1","Istallment1","ValordaParcela1","ValordelaCuota1","ValueofInstallment1","@E999,999,999.99","Positivo().Or.Vazio()","€€€€€€€€€€€€€€ ","","",01,"†€","","","","N","A","R","N","","","","","","","","","","S","","","","","","","N","N","N"})
AADD(aRegs,{"CND","46","CND_DATA1","D",08,00,"Vencimento1","Vencimiento","MaturityDt1","VencimentodaParcela1","VencimientodelaParcela","InstallmentDueDate1","","cn120VTip9()","€€€€€€€€€€€€€€ ","","",01,"†€","","","","N","A","R","N","","","","","","","","","","S","","","","","","","N","N","N"})
AADD(aRegs,{"CND","47","CND_PARC2","N",12,02,"Parcela2","Cuota2","Istallment2","ValordaParcela2","ValordelaCuota2","ValueofInstallment2","@E999,999,999.99","Positivo().Or.Vazio()","€€€€€€€€€€€€€€ ","","",01,"†€","","","","N","A","R","N","","","","","","","","","","S","","","","","","","N","N","N"})
AADD(aRegs,{"CND","48","CND_DATA2","D",08,00,"Vencimento2","Vencimiento","MaturityDt2","VencimentodaParcela2","VencimientodelaParcela","InstallmentDueDate2","","cn120VTip9()","€€€€€€€€€€€€€€ ","","",01,"†€","","","","N","A","R","N","","","","","","","","","","S","","","","","","","N","N","N"})
AADD(aRegs,{"CND","49","CND_PARC3","N",12,02,"Parcela3","Cuota3","Istallment3","ValordaParcela3","ValordelaCuota3","ValueofInstallment3","@E999,999,999.99","Positivo().Or.Vazio()","€€€€€€€€€€€€€€ ","","",01,"†€","","","","N","A","R","N","","","","","","","","","","S","","","","","","","N","N","N"})
AADD(aRegs,{"CND","50","CND_DATA3","D",08,00,"Vencimento3","Vencimiento","MaturityDt3","VencimentodaParcela3","VencimientodelaParcela","InstallmentDueDate3","","cn120VTip9()","€€€€€€€€€€€€€€ ","","",01,"†€","","","","N","A","R","N","","","","","","","","","","S","","","","","","","N","N","N"})
AADD(aRegs,{"CND","51","CND_PARC4","N",12,02,"Parcela4","Cuota4","Istallment4","ValordaParcela4","ValordelaCuota4","ValueofInstallment4","@E999,999,999.99","Positivo().Or.Vazio()","€€€€€€€€€€€€€€ ","","",01,"†€","","","","N","A","R","N","","","","","","","","","","S","","","","","","","N","N","N"})
AADD(aRegs,{"CND","52","CND_DATA4","D",08,00,"Vencimento4","Vencimiento","MaturityDt4","VencimentodaParcela4","VencimientodelaParcela","InstallmentDueDate4","","cn120VTip9()","€€€€€€€€€€€€€€ ","","",01,"†€","","","","N","A","R","N","","","","","","","","","","S","","","","","","","N","N","N"})
AADD(aRegs,{"CND","53","CND_CODPRJ","C",06,00,"Cod.Projeto","Cod.Projeto","Cod.Projeto","Cod.Projeto","Cod.Projeto","Cod.Projeto","","","€€€€€€€€€€€€€€ ","","SZ3_05",00,"þ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SC5","01","C5_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","SucursaldelSistema","SystemBranch","@!","","€€€€€€€€€€€€€€€","","",01,"€€","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","02","C5_NUM","C",06,00,"Numero","Numero","Number","NumerodoPedido","NumerodelPedido","OrderNumber","@X","NaoVazio().And.ExistChav('SC5')","€€€€€€€€€€€€€€°","GetSXENum('SC5','C5_NUM')","",01,"†€","","","","S","","","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","03","C5_TIPO","C",01,00,"TipoPedido","TipoPedido","OrderType","TipodePedido","TipodePedido","TypeofOrder","@!","Pertence('NCIPDB').and.A410Limpa()","€€€€€€€€€€€€€€°","","",01,"ƒ€","","","","N","A","R","","","&N=Normal;C=Compl.Precos;I=Compl.ICMS;P=Compl.IPI;D=Dev.Compras;B=UtilizaFornecedor","&N=Normal;C=Compl.Precios;I=Compl.ICMS;P=Compl.IPI;D=Dev.Compras;B=UsaProveedor","&N=Normal;C=PriceCompl.;I=ICMSCompl.;P=IPICompl.;D=PurchasesReturn;B=Supplier","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"SC5","04","C5_CHVBPAG","C",10,00,"No.PedGAR","No.PedGAR","No.PedGAR","No.PedidodoGAR","No.PedidodoGAR","No.PedidodoGAR","","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","S","A","R","","","","","","","INCLUI","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","05","C5_ATDTLV","C",06,00,"Atend.TLV.","Atend.TLV.","Atend.TLV.","Atend.TLV.","Atend.TLV.","Atend.TLV.","@!","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","06","C5_XNPSITE","C",10,00,"NumPedSite","NumPedSite","NumPedSite","Numerodopedidonosite","Numerodopedidonosite","Numerodopedidonosite","9999999999","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","07","C5_LOJAENT","C",02,00,"LojaEntrega","Tda.Entrega","Deliv.Unit","CodigodaLojadeEntrega","CodigoTiendadeEntrega","CodeofDeliveryUnit","@!","A410Loja().And.A410ReCalc()","€€€€€€€€€€€€€€ ","","",01,chr(65533),"","","","N","A","R","","","","","","","IIF(M->C5_TIPO$'DB',.F.,.T.)","","002","","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"SC5","08","C5_XORIGPV","C",01,00,"OrigemP.V.","OrigemP.V.","OrigemP.V.","OrigemPedidodeVenda","OrigemPedidodeVenda","OrigemPedidodeVenda","@!","","€€€€€€€€€€€€€€ ","'1'","",00,"þ","","","U","S","V","R","","","1=Manual;2=VendaVarejo;3=VendaHardwareAvulso;4=Televendas;5=AtendimentoExterno;6=Contratos","1=Manual;2=VendaVarejo;3=VendaHardwareAvulso;4=Televendas;5=AtendimentoExterno;6=Contratos","1=Manual;2=VendaVarejo;3=VendaHardwareAvulso;4=Televendas;5=AtendimentoExterno;6=Contratos","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","09","C5_EMISSAO","D",08,00,"DTEmissao","FchEmision","IssueDate","DatadaEmissao","FechadelaEmision","IssueDate","","MaVldTabPrc(M->C5_TABELA,M->C5_CONDPAG,,M->C5_EMISSAO)","€€€€€€€€€€€€€€ ","ddatabase","",01,"’€","","","","S","A","R","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","10","C5_CLIENTE","C",06,00,"Cliente","Cliente","Customer","CodigodoCliente","CodigodelCliente","CustomerCode","@!","A410Cli().And.A410ReCalc()","€€€€€€€€€€€€€€ ","","SA1",01,"ƒ€","","","","S","","","","","","","","","","","001","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","11","C5_LOJACLI","C",02,00,"Loja","Tienda","Unit","LojadoCliente","TiendadelCliente","Customer'sUnit","@!","A410Loja().And.A410ReCalc()","€€€€€€€€€€€€€€ ","","",01,"ƒ€","","","","S","","","","","","","","","","","002","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","12","C5_CLIENT","C",06,00,"Cli.Entrega","Cli.Entrega","Cus.Delivery","ClientedaEntrega","Clientedelaentrega","CustomerDelivery","@!","Vazio().Or.(A410Cli().And.A410ReCalc())","€€€€€€€€€€€€€€ ","","SA1",01,"‚€","","","","N","","","","","","","","","IIF(M->C5_TIPO$'DB',.F.,.T.)","","001","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","13","C5_TRANSP","C",06,00,"Transp.","Transp.","Carrier","CodigodaTransportadora","CodigodelTransportador","CarrierCode","@X","vazio().or.existcpo('SA4')","€€€€€€€€€€€€€€ ","","SA4",01,"‚","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","14","C5_TIPOCLI","C",01,00,"TipoCliente","TipoCliente","CustomerTy.","TipodoCliente","TipodeCliente","TypeofCustomer","@!","","€€€€€€€€€€€€€€ ","","",01,"ƒ€","","","","N","","","","pertence('FLRSX')","F=Cons.Final;L=Prod.Rural;R=Revendedor;S=Solidario;X=Exportacao/Importacao","F=Cons.Final;L=Prod.Rural;R=Revendedor;S=Solidario;X=Exportacion/Importacion","F=FinalCons.;L=RuralProd.;R=Reseller;S=Solidary;X=Export/Import","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","15","C5_CONDPAG","C",03,00,"Cond.Pagto","Cond.Pago","PaymentTerm","CondicaodePagamento","CondiciondePago","PaymentTerm","@!","ExistCpo('SE4').And.A410AcrFin().And.MaVldTabPrc(M->C5_TABELA,M->C5_CONDPAG,,M->C5_EMISSAO).AND.A410Recalc()","€€€€€€€€€€€€€€ ","","SE4",01,"ƒ€","","","","N","","","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","16","C5_XNATURE","C",10,00,"Natureza","Natureza","Natureza","Natureza","Natureza","Natureza","@!","MaFisGet('NF_NATUREZA').And.MaFisAlt('NF_NATUREZA',M->C5_XNATURE)","€€€€€€€€€€€€€€ ","","SED",00,"þ","","","U","S","A","R","€","ExistCpo('SED',M->C5_XNATURE)","","","","","","","","1","","","","","","","","N","N","N"})
AADD(aRegs,{"SC5","17","C5_TABELA","C",03,00,"Tabela","Tabla","Table","CodigodaTabeladePreco","CodigoTabladePrecios","PriceListCode","","MaVldTabPrc(M->C5_TABELA,M->C5_CONDPAG,,M->C5_EMISSAO).And.A410ReCalc()","€€€€€€€€€€€€€€ ","","DA0",01,"‚€","","","","N","","","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","18","C5_VEND1","C",06,00,"Vendedor1","Vendedor1","Seller1","CodigodoVendedor1","CodigodelVendedor1","SellerCode1","@X","(A410VEND().OR.VAZIO())","€€€€€€€€€€€€€€ ","","SA3",01,"‚","","S","","N","A","R","€","ExistCpo('SA3',M->C5_VEND1)","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","19","C5_COMIS1","N",05,02,"Comissao1","Comision1","Commission1","ComissaodoVendedor1","ComisiondelVendedor1","CommissionofSeller1","@E99.99","positivo().or.vazio()","€€€€€€€€€€€€€€ ","","",01,"š","","","","N","V","R","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","20","C5_VEND2","C",06,00,"Vendedor2","Vendedor2","Seller2","CodigodoVendedor2","CodigodelVendedor2","SellerCode2","@X","(A410VEND().OR.VAZIO())","€€€€€€€€€€€€€€ ","","SA3",01,"‚","","","","N","","","","ExistCpo('SA3',M->C5_VEND2)","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","21","C5_COMIS2","N",05,02,"Comissao2","Comision2","Commission2","ComissaodoVendedor2","ComisiondelVendedor2","CommissionofSeller2","@E99.99","positivo().or.vazio()","€€€€€€€€€€€€€€ ","","",01,"š","","","","N","V","R","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","22","C5_VEND3","C",06,00,"Vendedor3","Vendedor3","Seller3","CodigodoVendedor3","CodigodelVendedor3","SellerCode3","@X","(A410VEND().OR.VAZIO())","€€€€€€€€€€€€€€ ","","SA3",01,"‚","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","23","C5_COMIS3","N",05,02,"Comissao3","Comision3","Commission3","ComissaodoVendedor3","ComisiondelVendedor3","CommissionofSeller3","@E99.99","positivo().or.vazio()","€€€€€€€€€€€€€€ ","","",01,"š","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","24","C5_VEND4","C",06,00,"Vendedor4","Vendedor4","Seller4","CodigodoVendedor4","CodigodelVendedor4","SellerCode4","@X","(A410VEND().OR.VAZIO())","€€€€€€€€€€€€€€ ","","SA3",01,"‚","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","25","C5_COMIS4","N",05,02,"Comissao4","Comision4","Commission4","ComissaodoVendedor4","ComisiondelVendedor4","CommissionofSeller4","@E99.99","positivo().or.vazio()","€€€€€€€€€€€€€€ ","","",01,"š","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","26","C5_VEND5","C",06,00,"Vendedor5","Vendedor5","Seller5","CodigodoVendedor5","CodigodelVendedor5","SellerCode5","@X","(A410VEND().OR.VAZIO())","€€€€€€€€€€€€€€ ","","SA3",01,"‚","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","27","C5_COMIS5","N",05,02,"Comissao5","Comision5","Commission5","ComissaodoVendedor5","ComisiondelVendedor5","CommissionofSeller5","@E99.99","positivo().or.vazio()","€€€€€€€€€€€€€€ ","","",01,"š","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","28","C5_DESC1","N",05,02,"Desconto1","Descuento1","Discount1","Desconto1","Descuento1","Discount1","@E99.99","(Positivo().or.vazio()).and.a410Recalc()","€€€€€€€€€€€€€€ ","","",01,"š","","","","N","","","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","29","C5_DESC2","N",05,02,"Desconto2","Descuento2","Discount2","Desconto2","Descuento2","Discount2","@E99.99","(Positivo().or.vazio()).and.a410Recalc()","€€€€€€€€€€€€€€ ","","",01,"š","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","30","C5_DESC3","N",05,02,"Desconto3","Descuento3","Discount3","Desconto3","Descuento3","Discount3","@E99.99","(Positivo().or.vazio()).and.a410Recalc()","€€€€€€€€€€€€€€ ","","",01,"š","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","31","C5_DESC4","N",05,02,"Desconto4","Descuento4","Discount4","Desconto4","Descuento4","Discount4","@E99.99","(Positivo().or.vazio()).and.a410Recalc()","€€€€€€€€€€€€€€ ","","",01,"š","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","32","C5_BANCO","C",03,00,"Banco","Banco","Bank","CodigodoBanco","CodigodelBanco","BankCode","@!","Vazio().or.Existcpo('SA6')","€€€€€€€€€€€€€€ ","","BCO",01,"‚","","","","N","","","","","","","","","","","007","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","33","C5_DESCFI","N",05,02,"Desc.Financ.","Dsct.Financ.","Financ.Disc.","DescontoFinanceiro","DescuentoFinanciero","FinancialDiscount","@E99.99","positivo().or.vazio()","€€€€€€€€€€€€€€ ","","",01,"š","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","34","C5_COTACAO","C",06,00,"Licitacao","Licitacion","Bidding","NumerodaLicitacao","NumerodelaLicitacion","BiddingNumber","@X","","€€€€€€€€€€€€€€ ","","AH9",01,"’","","","","N","","","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","35","C5_PARC1","N",12,02,"Parcela1","Cuota1","Installment1","ValordaParcela1","ValordelaCuota1","ValueofInstallment1","@E999,999,999.99","positivo().or.vazio()","€€€€€€€€€€€€€€ ","","",01,"š","","","","N","","","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","36","C5_DATA1","D",08,00,"Vencimento1","Vencimiento1","MaturityDt1","VencimentodaParcela1","VencimientodelaCuota1","InstallmentDueDate1","","A410Venc()","€€€€€€€€€€€€€€ ","","",01,"’","","","","N","","","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","37","C5_PARC2","N",12,02,"Parcela2","Cuota2","Installment2","ValordaParcela2","ValordelaCuota2","ValueofInstallment2","@E999,999,999.99","positivo().or.vazio()","€€€€€€€€€€€€€€ ","","",01,"š","","","","N","","","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","38","C5_DATA2","D",08,00,"Vencimento2","Vencimiento2","MaturityDt2","VencimentodaParcela2","VencimientodelaCuota2","InstallmentDueDate2","","A410Venc()","€€€€€€€€€€€€€€ ","","",01,"’","","","","N","","","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","39","C5_PARC3","N",12,02,"Parcela3","Cuota3","Installment3","ValordaParcela3","ValordelaCuota3","ValueofInstallment3","@E999,999,999.99","positivo().or.vazio()","€€€€€€€€€€€€€€ ","","",01,"š","","","","N","","","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","40","C5_DATA3","D",08,00,"Vencimento3","Vencimiento3","MaturityDt3","VencimentodaParcela3","VencimientodelaCuota3","InstallmentDueDate3","","A410Venc()","€€€€€€€€€€€€€€ ","","",01,"’","","","","N","","","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","41","C5_DESPESA","N",14,02,"Despesa","Gastos","Expense","ValorDespesaAcessoria","ValordeGastoMiscelanea","AdditionalExpenseValue","@E999,999,999.99","","€€€€€€€€€€€€€€ ","","",01,"˜€","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","42","C5_FRETAUT","N",12,02,"FreteAuton.","FleteAuto.","Ind.Freight","FreteAutonomo","FleteAutonomo","IndependentFreight","@E999,999,999.99","positivo()","€€€€€€€€€€€€€€ ","","",01,"˜","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","43","C5_REAJUST","C",03,00,"TipoReajust","TipoReajust","Adjust.Type","TipodeReajusteUsado","TipodeReajusteUsado","TypeofAdjustmentUsed","@X","Vazio().Or.ExistCpo('SM4')","€€€€€€€€€€€€€€ ","","SM4",01,chr(65533),"","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","44","C5_MOEDA","N",01,00,"Moeda","Moneda","Currency","MoedadoPedidodeVenda","MonedadelPedid.deVenta","CurrencyofSalesOrder","@E9","M->C5_MOEDA>0.AND.M->C5_MOEDA<=MOEDFIN().And.a410Recalc()","€€€€€€€€€€€€€€ ","1","",01,"˜€","","S","","N","","","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","45","C5_PARC4","N",12,02,"Parcela4","Cuota4","Installment4","ValordaParcela4","ValordelaCuota4","ValueofInstallment4","@E999,999,999.99","positivo().or.vazio()","€€€€€€€€€€€€€€ ","","",01,"š","","","","N","","","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","46","C5_DATA4","D",08,00,"Vencimento4","Vencimiento4","MaturityDt4","VencimentodaParcela4","VencimientodelaCuota4","InstallmentDueDate4","","A410Venc()","€€€€€€€€€€€€€€ ","","",01,"’","","","","N","","","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","47","C5_PARC5","N",12,02,"Parcela5","Parcela5","Parcela5","Parcela5","Parcela5","Parcela5","@E999,999,999.99","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","A","R","","Positivo().or.Vazio()","","","","","","","","1","","","","","","","","N","N","N"})
AADD(aRegs,{"SC5","48","C5_DATA5","D",08,00,"Data5","Data5","Data5","Data5","Data5","Data5","@D","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","A","R","","","","","","","","","","1","","","","","","","","N","N","N"})
AADD(aRegs,{"SC5","49","C5_TPFRETE","C",01,00,"TipoFrete","Tipoflete","FreightType","TipodoFreteUtilizado","TipodefleteUtiliz.","TypeofFreightUsed","X","pertence('CFTS')","€€€€€€€€€€€€€€ ","","",01,"‚","","","","N","","","","pertence('CFTS')","C=CIF;F=FOB;T=Porcontaterceiros;S=Semfrete","C=CIF;F=FOB;T=Porcontaterceiros;S=Semfrete","C=CIF;F=FOB;T=Porcontaterceiros;S=Semfrete","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","50","C5_FRETE","N",12,02,"Frete","Flete","Freight","ValordoFrete","ValordelFlete","FreightValue","@E999,999,999.99","positivo().or.vazio()","€€€€€€€€€€€€€€ ","","",01,"š","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","51","C5_SEGURO","N",12,02,"Seguro","Seguro","Insurance","ValordoSeguro","ValordelSeguro","InsuranceValue","@E999,999,999.99","positivo().or.vazio()","€€€€€€€€€€€€€€ ","","",01,"š","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","52","C5_PESOL","N",11,04,"PesoLiquido","PesoNeto","NetWeight","PesoLiquido","PesoNeto","NetWeight","@E999,999.9999","positivo().or.vazio()","€€€€€€€€€€€€€€ ","","",01,"š","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","53","C5_PBRUTO","N",11,04,"PesoBruto","PesoBruto","GrossWeight","PesoBruto","PesoBruto","GrossWeight","@E999,999.9999","positivo().or.vazio()","€€€€€€€€€€€€€€ ","","",01,"š","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","54","C5_REIMP","N",01,00,"QtPre-Notas","Ctd.Pre-Fact","No.Pre-inv.","Quant.Pre-NotasImpr.","Ctd.Pre-FacturasImpr.","No.ofPrintedPre-inv.","9","","€€€€€€€€€€€€€€€","","",01,"‚","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","55","C5_REDESP","C",06,00,"Redespacho","Redespacho","Redelivery","CodigoTransp.Redespacho","CodigoTrans.Redespacho","RedeliveryCarrierCode","@X","Vazio().Or.ExistCpo('SA4')","€€€€€€€€€€€€€€ ","","SA4",01,"‚","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","56","C5_VOLUME1","N",05,00,"Volume1","Volumen1","Package1","QtdedeVolumestipo1","Ctd.deVolumenesTipo1","Qty.oftype1packages","99999","positivo().or.vazio()","€€€€€€€€€€€€€€ ","","",01,"š","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","57","C5_VOLUME2","N",05,00,"Volume2","Volumen2","Package2","QtdedeVolumestipo2","Ctd.deVolumenesTipo2","Qty.oftype2packages","99999","positivo().or.vazio()","€€€€€€€€€€€€€€ ","","",01,"š","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","58","C5_VOLUME3","N",05,00,"Volume3","Volumen3","Package3","QtdedeVolumestipo3","Ctd.deVolumenesTipo3","Qty.oftype3packages","99999","positivo().or.vazio()","€€€€€€€€€€€€€€ ","","",01,"š","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","59","C5_VOLUME4","N",05,00,"Volume4","Volumen4","Package4","QtdedeVolumestipo4","Ctd.deVolumenesTipo4","Quant.oftype4packages","99999","positivo().or.vazio()","€€€€€€€€€€€€€€ ","","",01,"š","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","60","C5_INCISS","C",01,00,"ISSIncluso","Incl.ISS","ISSIncluded","ISSinclusonoPreço","ISSIncluidoenPrecio","PriceincludingISS","@!","","€€€€€€€€€€€€€€ ","","",01,chr(65533),"","","","N","","","","Pertence('SN')","S=Sim;N=Nao","S=Si;N=No","S=Yes;N=No","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","61","C5_LIBEROK","C",01,00,"Liber.Total","ApruebaTot.","TotalReleas","PedidoLiberadoTotal","PedidoTotalAprobado","OrderTotallyApproved","@!","","€€€€€€€€€€€€€€€","","",01,chr(65533),"","","","N","","","","pertence('S')","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","62","C5_OK","C",02,00,"OK","OK","OK","OK","OK","OK","","","€€€€€€€€€€€€€€€","","",01,chr(65533),"","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","63","C5_ESPECI1","C",10,00,"Especie1","Especie1","Class1","EspeciedoVolumetipo1","EspeciedeVolumenTipo1","PackingType1","@X","","€€€€€€€€€€€€€€ ","","",01,"’","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","64","C5_ESPECI2","C",10,00,"Especie2","Especie2","Class2","EspeciedoVolumetipo2","EspeciedeVolumenTipo2","PackingType2","@X","","€€€€€€€€€€€€€€ ","","",01,"’","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","65","C5_ESPECI3","C",10,00,"Especie3","Especie3","Class3","EspeciedoVolumetipo3","EspeciedeVolumenTipo3","PackingType3","@X","","€€€€€€€€€€€€€€ ","","",01,"’","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","66","C5_XMENSUG","C",03,00,"Mensagem","Mensagem","Mensagem","Mensagem","Mensagem","Mensagem","@!","","€€€€€€€€€€€€€€ ","","SM4",01,"þ","","S","U","N","A","R","","Vazio().Or.ExistCpo('SM4')","","","","","","","","1","","","","","","","","N","N","N"})
AADD(aRegs,{"SC5","67","C5_OS","C",06,00,"Geradop/OS","Nr.OSGenera","Gen.f/S.O.","NumerodaOSgeradora","Nro.delaOSGeneradora","MainServiceOrderNumber","@!","","€‰€€€‚€€€€€€€ƒ€","","",01,chr(65533),"","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","68","C5_NOTA","C",09,00,"NotaFiscal","Factura","Invoice","NumerodaNotaFiscal","NumerodelaFactura","Invoicenumber","@!","","€€€€€€€€€€€€€€€","","",01,"„€","","","","N","","","","","","","","","","","018","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","69","C5_SERIE","C",03,00,"Serie","Serie","Series","SeriedaNotaFiscal","SeriedelaFactura","InvoiceSeries","","","€€€€€€€€€€€€€€€","","",01,"„€","","","","N","","","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","70","C5_TXMOEDA","N",11,04,"TaxaMoeda","TasaMoneda","Currenc.Rate","TaxadaMoeda","TasadelaMoneda","CurrencyRate","@E999999.9999","","€€€€€€€€€€€€€€€","1","",01,"€","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","71","C5_ESPECI4","C",10,00,"Especie4","Especie4","Class4","EspeciedoVolumetipo4","EspeciedeVolumenTipo4","PackingType4","@X","","€€€€€€€€€€€€€€ ","","",01,"’","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","72","C5_MENNOTA","C",250,00,"Mens.p/Nota","Mens.p.Fact.","NFMessage","MensagemparaNotaFiscal","MensajeparalaFactura","MessageforInvoice","@!","texto().Or.Vazio()","€€€€€€€€€€€€€€ ","","",01,"’","","","","N","A","R","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","73","C5_MENPAD","C",03,00,"Mens.Padrao","Mens.Estand.","StdMessage","MensagemPadrao1","MensajeEstandar1","StandardMessage1","@!","Vazio().Or.ExistCpo('SM4')","€€€€€€€€€€€€€€ ","","SM4",01,"‚","","S","","N","","","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","74","C5_KITREP","C",06,00,"KitReparo","KitArreglo","RepairKit","CodigodoKitdeReparo","Cod.delKitdeArreglos","CodeforRepairKit","@!","A410KitRep(M->C5_KITREP)","€‰€€€‚€€€€€€€ƒ€","","SO4",01,"’","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","75","C5_TIPLIB","C",01,00,"TpLiberaço","Tp.Aprobac.","Approb.Type","TipodeLiberaço","TipodeAprobacion","TypeofAprobation","@!","Pertence('12')","€€€€€€€€€€€€€€ ","'1'","",01,"‚","","","","N","","","","","1=LiberaporItem;2=LiberaporPedido","1=ApruebaporÍtem;2=ApruebaporPedido","1=ApprovebyItem;2=ApprovebyOrder","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","76","C5_DESCONT","N",14,02,"Indenizacao","Indemnizac.","Indemnity","DescontodeIndenizacao","DescuentodeIndemnizac.","IndemnityDicount","@E999,999,999.99","","€€€€€€€€€€€€€€ ","","",01,"š","","","","","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","77","C5_PEDEXP","C",20,00,"Proc.Export.","Proc.Export.","ExportProc.","ProcessodeExportacao","ProcesodeExportacion","ExportProcess","@!","","€€€€€€€€€€€€€€ ","","",01,"’","","","","S","V","","","","","","","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","78","C5_TPCARGA","C",01,00,"Carga","Carga","Cargo","Carga","Carga","Cargo","@!","Pertence('12')","€€€€€€€€€€€€€€ ","'2'","",01,"‚","","","","N","","","","","1=Utiliza;2=Naoutiliza","1=Utiliza;2=Noutiliza","1=Use;2=Doesnotuse","","","","","","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","79","C5_PDESCAB","N",05,02,"%Indenizacao","%Indemnizac.","%Indemn.","Percentualdeindenizacao","Porcentajedeindemnizac.","Indemnitypercentage","@e99.99","Positivo()","€€€€€€€€€€€€€€ ","","",01,"ž","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","80","C5_BLQ","C",01,00,"Blq.Regras","Blq.Reglas","Rul.Lock","BloqueiodeRegras","BloqueodeReglas","RuleLock","@!","","€€€€€€€€€€€€€€€","","",01,"†€","","","","N","V","R","","","","","","","","","","1","N","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","81","C5_FORNISS","C",06,00,"Forn.ISS","Proveed.ISS","ISSSupplier","FornecedordeISS","ProveedordeISS","ISSSupplier","@!","ExistCpo('SA2',M->C5_FORNISS+'00')","€€€€€€€€€€€€€€ ","","SA2",01,"†€","","","","","","","","","","","","","","","001","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","82","C5_CONTRA","C",10,00,"Contrato","Contrato","Contract","Numerodocontrato","Numerodelcontrato","ContractNumber","@!","","€€€€€€€€€€€€€€€","","",01,"†","","","","N","","","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","83","C5_USERLGI","C",17,00,"LogdeInclu","LogdeInclu","LogdeInclu","LogdeInclusao","LogdeInclusao","LogdeInclusao","","","€€€€€€€€€€€€€€€","","",09,"þ","","","L","N","V","R","","","","","","","","","","","","","","","","","","N","N","N"})
AADD(aRegs,{"SC5","84","C5_USERLGA","C",17,00,"LogdeAlter","LogdeAlter","LogdeAlter","LogdeAlteracao","LogdeAlteracao","LogdeAlteracao","","","€€€€€€€€€€€€€€€","","",09,"þ","","","L","N","V","R","","","","","","","","","","","","","","","","","","N","N","N"})
AADD(aRegs,{"SC5","85","C5_MSBLQL","C",01,00,"Bloqueado?","Bloqueado?","Bloqueado?","Registrobloqueado","Registrobloqueado","Registrobloqueado","","","€€€€€€€€€€€€€€ ","'2'","",09,"‚€","","","L","N","A","R","","","1=Sim;2=No","1=Si;2=No","1=Yes;2=No","","","","","","","","","","","","","N","N","N"})
AADD(aRegs,{"SC5","86","C5_KM","N",07,00,"Dist.Entrega","Dist.Entrega","Deliv.dist.","DistanciadeEntrega","DistanciadeEntrega","Deliverydistance","@E9,999,999","Positivo().And.a410FreteP()","€€€€€€€€€€€€€€ ","","",01,"–","","","","N","A","V","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","87","C5_VLR_FRT","N",12,02,"FretePauta","FletePauta","TariffFrght","ValordoFretedePauta","ValordelFletedePauta","TariffFreightValue","@E999,999,999.99","Positivo().Or.Vazio()","€€€€€€€€€€€€€€ ","","",01,"ž","","","","N","A","R","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","88","C5_DESCMUN","C",30,00,"Desc.Mun.","Desc.Prest.","Desc.Prest.","DescricoMun.Prest.","DescricoMun.Prest.","DescricoMun.Prest.","@!","","€€€€€€€€€€€€€€ ","","",01,"þ","","","S","S","A","R","","","","","","","","","","","","","","","","","","N","N","N"})
AADD(aRegs,{"SC5","89","C5_AR","C",06,00,"A.R.","A.R.","A.R.","","","","@!","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","A","R","","","","","","","","","","","","","","","","","","N","N","N"})
AADD(aRegs,{"SC5","90","C5_RECISS","C",01,00,"RecolheISS?","¿PagaISS?","PayISS","Ind.sehouverecolh.ISS","¿PagaISS?","PayISS","@!","Pertence('12').And.MaFisGet('NF_RECISS')","€€€€€€€€€€€€€€ ","","",01,"Æ","","","","N","","","","Pertence('12').And.MaFisGet('NF_RECISS')","1=Sim;2=No","1=Si;2=No","1=Yes;2=No","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","91","C5_RECFAUT","C",01,00,"PagtoFr.Aut","Pag.Flet.Aut","Fre.Fr.Pay","Pagtodofreteautonomo","Pagodefleteautonomo","FreelancerFreightPymt.","@!","Pertence('12')","€€€€€€€€€€€€€€ ","","",01,"†","","","","N","","","","Pertence('12').And.MaFisGet('NF_RECFAUT')","1=Emitente;2=Transportador","1=Emitente;2=Transportador","1=Drawer;2=Carrier","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","92","C5_ACRSFIN","N",06,02,"Acr.Financ","Aumto.Financ","Fin.Increase","AcrescimoFinanceiro","AumentoFinanciero","FinancialIncrease","@E999.99","positivo().or.vazio()","€€€€€€€€€€€€€€ ","","",01,"š","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SC5","93","C5_MDCONTR","C",15,00,"Num.Contrato","Num.Contrato","Contractnbr","NumerodoContrato","NumerodelContrato","Contractnumber","@!","","€€€€€€€€€€€€€€ ","","",01,"Ö","","","","N","V","R","","","","","","","","","","","N","","","N","N","N","","N","N","N"})
AADD(aRegs,{"SC5","94","C5_ORCRES","C",06,00,"Num.Orcam.","NºPresup.","Quot.Nbr.","NumerodoOrcamento","NumerodelPresupuesto","QuotationNumber","","","€€€€€€€€€€€€€€€","","",01,"€€","","","","N","A","R","","","","","","","","","","","N","","","N","N","N","","N","N","N"})
AADD(aRegs,{"SC5","95","C5_GERAWMS","C",01,00,"GeraOS.WMS","Gen.OS.WMS","Gen.WMS/SO","GeraO.S./WMS","GeneraO.S./WMS","GenerateWMS/SO","@!","Pertence('123')","€€€€€€€€€€€€€€ ","'1'","",01,"†","","","","N","A","","","","1=noPedido;2=naMontagemdaCarga;3=naUnitizacaodaCarga","1=enelPedido;2=enelMontajedeCarga;3=enlaUnitizacion","1=inSalesOrder;2=inAssembleLoad;3=inUnitization","","","","","","N","","","N","N","N","","N","N","N"})
AADD(aRegs,{"SC5","96","C5_MDNUMED","C",06,00,"Num.Medicao","Num.Medicion","Measur.nbr.","NumerodaMedicao","NumerodeMedicion","Measur.number","@!","","€€€€€€€€€€€€€€ ","","",01,"Ö","","","","N","V","R","","","","","","","","","","","N","","","N","N","N","","N","N","N"})
AADD(aRegs,{"SC5","97","C5_MDPLANI","C",06,00,"Num.Planilha","Num.Planilla","Wrkshtnbr.","NumerodaPlanilha","NumerodePlanilla","Worksheetnumber","@!","","€€€€€€€€€€€€€€ ","","",01,"Ö","","","","N","V","R","","","","","","","","","","","N","","","N","N","N","","N","N","N"})
AADD(aRegs,{"SC5","98","C5_SOLFRE","C",02,00,"Sol.Frete","Sol.Flete","FreightReq.","SolicitaçodeFrete","Solicituddeflete","FreightRequest","@!","","€€€€€€€€€€€€€€€","","",01,"ž","","","","","","","","","","","","","","","","","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"SC5","99","C5_XCARTAO","C",16,00,"Cod.Cartao","Cod.Cartao","Cod.Cartao","Cod.Cartao","Cod.Cartao","Cod.Cartao","@!","","€€€€€€€€€€€€€€ ","","",09,"þ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","A0","C5_XPARCEL","C",03,00,"Parcela","Parcela","Parcela","Parcela","Parcela","Parcela","@!","","€€€€€€€€€€€€€€ ","","",09,"þ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","A1","C5_XCODSEG","C",04,00,"CodSegCart","CodSegCart","CodSegCart","CodigodeSeg.Cartao","CodigodeSeg.Cartao","CodigodeSeg.Cartao","9999","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","A2","C5_XVALIDA","C",07,00,"Validade","Validade","Validade","Validade","Validade","Validade","@!","","€€€€€€€€€€€€€€ ","","",09,"þ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","A3","C5_XCODAUT","C",20,00,"Cod.Aut.","Cod.Aut.","Cod.Aut.","Cod.Aut.","Cod.Aut.","Cod.Aut.","@!","","€€€€€€€€€€€€€€ ","","",05,"þ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","A4","C5_XCOMNAM","C",50,00,"Comm.Name","Comm.Name","Comm.Name","Comm.Name","Comm.Name","Comm.Name","@!","","€€€€€€€€€€€€€€ ","","",05,"þ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","A5","C5_XBANDEI","C",10,00,"Bandeira","Bandeira","Bandeira","Bandeira","Bandeira","Bandeira","@!","","€€€€€€€€€€€€€€ ","","",09,"þ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","A6","C5_CNPJ","C",14,00,"CPF/CNPJ","CPF/CNPJ","CPF/CNPJ","CPF/CNPJenviadopeloGAR","CPF/CNPJenviadopeloGAR","CPF/CNPJenviadopeloGAR","@!","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","A7","C5_TIPMOV","C",01,00,"FormaPagto","FormaPagto","FormaPagto","Formadepagamento","Formadepagamento","Formadepagamento","9","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","A","R","","","1=Boleto;2=CartaoCredito;3=CartaoDebito;4=DA;5=DDA;6=Voucher","1=Boleto;2=CartaoCredito;3=CartaoDebito;4=DA;5=DDA;6=Voucher","1=Boleto;2=CartaoCredito;3=CartaoDebito;4=DA;5=DDA;6=Voucher","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","A8","C5_TIPMOV2","C",01,00,"FormPgComp","FormPgComp","FormPgComp","Formapagtocomplementar","Formapagtocomplementar","Formapagtocomplementar","9","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","V","R","","","1=Boleto;2=CartaoCredito;3=CartaoDebito;4=DA;5=DDA","1=Boleto;2=CartaoCredito;3=CartaoDebito;4=DA;5=DDA","1=Boleto;2=CartaoCredito;3=CartaoDebito;4=DA;5=DDA","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","A9","C5_TOTORI","N",12,02,"VlrOriginal","VlrOriginal","VlrOriginal","ValortotalOriginal","ValortotalOriginal","ValortotalOriginal","@E999,999,999.99","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","B0","C5_TOTPED","N",12,02,"TotalPedido","TotalPedido","TotalPedido","TotalPedidoenviadoGAR","TotalPedidoenviadoGAR","TotalPedidoenviadoGAR","@E999,999,999.99","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","B1","C5_TIPVOU","C",01,00,"TipoVoucher","TipoVoucher","TipoVoucher","Tipodovoucherdepagto","Tipodovoucherdepagto","Tipodovoucherdepagto","9","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","V","R","","","1=Corporativo;2=Sup.Garantia;3=SACSubstituicao;4=Cortesia;5=Funcionario;6=Teste","1=Corporativo;2=Sup.Garantia;3=SACSubstituicao;4=Cortesia;5=Funcionario;6=Teste","1=Corporativo;2=Sup.Garantia;3=SACSubstituicao;4=Cortesia;5=Funcionario;6=Teste","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","B2","C5_CODVOU","C",20,00,"Cod.Voucher","Cod.Voucher","Cod.Voucher","Codigodovoucher","Codigodovoucher","Codigodovoucher","","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","B3","C5_STATUS","C",01,00,"Status","Status","Status","Status","Status","Status","9","","€€€€€€€€€€€€€€ ","'1'","",00,"þ","","","U","N","A","R","","","1=Validacao;2=Renovacao","1=Validacao;2=Renovacao","1=Validacao;2=Renovacao","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","B4","C5_GARANT","C",10,00,"PedAnteGAR","PedAnteGAR","PedAnteGAR","PedAnteGAR","PedAnteGAR","PedAnteGAR","","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","B5","C5_MOTVOU","C",100,00,"MotivoVouch","MotivoVouch","MotivoVouch","MotivoVoucher","MotivoVoucher","MotivoVoucher","@!","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","B6","C5_EMAIL","C",40,00,"Email","Email","Email","Email","Email","Email","@x","","€€€€€€€€€€€€€€ ","","",01,"þ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","B7","C5_XARQCC","C",130,00,"Arq.Cart.Cr","Arq.Cart.Cr","Arq.Cart.Cr","Arq.Cart.Cr","Arq.Cart.Cr","Arq.Cart.Cr","@!","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","B8","C5_XOBS","M",10,00,"Obs.Pedido","Obs.Pedido","Obs.Pedido","Obs.Pedido","Obs.Pedido","Obs.Pedido","","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","B9","C5_XRVCC","C",09,00,"Res.VendaCC","Res.VendaCC","Res.VendaCC","Res.VendaCC","Res.VendaCC","Res.VendaCC","@!","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","C0","C5_XTIDCC","C",20,00,"TIDCIELO","TIDCIELO","TIDCIELO","TIDCIELO","TIDCIELO","TIDCIELO","@!","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","C1","C5_ARQVTEX","C",130,00,"Arq.VTEX","Arq.VTEX","Arq.VTEX","Arq.VTEX","Arq.VTEX","Arq.VTEX","@!","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","C2","C5_PARC6","N",12,02,"Parcela6","Parcela6","Parcela6","ValordaParcela6","ValordaParcela6","ValordaParcela6","@E999,999,999.99","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","A","R","","positivo().or.vazio()","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","C3","C5_MUNPRES","C",07,00,"Mun.Prest.","Mun.Prest.","Mun.Prest.","Mun.Prest.","Mun.Prest.","Mun.Prest.","@9","","€€€€€€€€€€€€€€ ","","",01,"þ","","","S","S","A","R","","","","","","","","","","","","","","","","","","N","N","N"})
AADD(aRegs,{"SC5","C4","C5_DATA6","D",08,00,"Vencimento6","Vencimento6","Vencimento6","VencimentoParcela6","VencimentoParcela6","VencimentoParcela6","","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","C5","C5_NFSUBST","C",09,00,"NFSubst.","NFSubst.","NFSubst.","NFSubstituida","NFSubstituida","NFSubstituida","@!","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","C6","C5_SERSUBS","C",03,00,"SerieSubst.","SerieSubst.","SerieSubst.","SeriedaNFSubstituida","SeriedaNFSubstituida","SeriedaNFSubstituida","@!","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","C7","C5_VEICULO","C",08,00,"Veic.Transp","Veic.Transp","Veic.Transp","VeiculodoTransporte","VeiculodoTransporte","VeiculodoTransporte","@!","Vazio().Or.ExistCPO('DA3')","€€€€€€€€€€€€€€ ","","DA3",01,"þ","","","S","S","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","C8","C5_XFORPGT","C",01,00,"FormaPagto","FormaPagto","FormaPagto","FormadePagamento","FormadePagamento","FormadePagamento","@!","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","S","V","R","","Pertence('123')","1=Cartao;2=Boleto;3=Voucher","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","C9","C5_XNUMCAR","C",16,00,"NumCartao","NumCartao","NumCartao","NumCartaodeCredito","NumCartaodeCredito","NumCartaodeCredito","9999999999999999","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D0","C5_XNOMTIT","C",20,00,"NomTitular","NomTitular","NomTitular","NomedoTitularCartao","NomedoTitularCartao","NomedoTitularCartao","@!","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D1","C5_XNPARCE","C",02,00,"NumParcelas","NumParcelas","NumParcelas","NumerodeParcelas","NumerodeParcelas","NumerodeParcelas","99","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D2","C5_XDTVALI","D",08,00,"DtValCart","DtValCart","DtValCart","DataValidadeCartao","DataValidadeCartao","DataValidadeCartao","@D","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D3","C5_XTIPCAR","C",01,00,"TipoCartao","TipoCartao","TipoCartao","TipoCartaodeCredito","TipoCartaodeCredito","TipoCartaodeCredito","@!","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","S","V","R","","Pertence('123')","1=Visa;2=MasterCard;3=AmericanExpress","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D4","C5_XNUMVOU","C",15,00,"NumVoucher","NumVoucher","NumVoucher","NumerodoVoucher","NumerodoVoucher","NumerodoVoucher","@!","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D5","C5_XQTDVOU","N",09,02,"QtdVoucher","QtdVoucher","QtdVoucher","QuantidadedoVoucher","QuantidadedoVoucher","QuantidadedoVoucher","@E999999,99","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D6","C5_XNFHRD","C",80,00,"LinkNFHRD","LinkNFHRD","LinkNFHRD","LinkNotaFiscalHardware","LinkNotaFiscalHardware","LinkNotaFiscalHardware","","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D7","C5_XNFSFW","C",80,00,"LinkNFSFW","LinkNFSFW","LinkNFSFW","LinkNotaFiscalSoftware","LinkNotaFiscalSoftware","LinkNotaFiscalSoftware","","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D8","C5_XNFHRE","C",80,00,"LinkNFHRE","LinkNFHRE","LinkNFHRE","LinkNFHRDEntrega","LinkNFHRDEntrega","LinkNFHRDEntrega","","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D9","C5_XFLAGEN","C",01,00,"FlagEnvSit","FlagEnvSit","FlagEnvSit","FlagEnvioSite","FlagEnvioSite","FlagEnvioSite","@!","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","E0","C5_STENTR","C",01,00,"StatEntrega","StatEntrega","StatEntrega","StatusdaEntrega","StatusdaEntrega","StatusdaEntrega","@!","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","E1","C5_XLINDIG","C",48,00,"LinhaDigita","LinhaDigita","LinhaDigita","LinhaDigitavelBoleto","LinhaDigitavelBoleto","LinhaDigitavelBoleto","@!","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","E1","C5_XGARORI","C",01,00,"PedGarOri","PedGarOri","PedGarOri","PedidoGAROrigem","PedidoGAROrigem","PedidoGAROrigem","@!","","€€€€€€€€€€€€€€","","",00,"þ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","E2","C5_XPOSTO","C",06,00,"Posto","Posto","Posto","PostodeEntrega","PostodeEntrega","PostodeEntrega","@!","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","E3","C5_TXREF","N",05,02,"TaxaCambial","TaxaCambial","TaxaCambial","TaxaCambial","TaxaCambial","TaxaCambial","@E99.99","Positivo()","€€€€€€€€€€€€€€ ","","",00,"þ","","","S","S","V","R","","","","","","","","","","","","","","","","","","N","N","N"})
AADD(aRegs,{"SC5","E3","C5_XDOCUME","C",20,00,"Nro.DocCar","Nro.DocCar","Nro.DocCar","Nro.DocCartao","Nro.DocCartao","Nro.DocCartao","@!","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","E4","C5_DTTXREF","D",08,00,"Dt.R.Cambial","Dt.R.Cambial","Dt.R.Cambial","DataReferenciaCambial","DataReferenciaCambial","DataReferenciaCambial","@D","","€€€€€€€€€€€€€€ ","","",00,"þ","","","S","S","V","R","","","","","","","","","","","","","","","","","","N","N","N"})
AADD(aRegs,{"SC5","E4","C5_XENTREG","C",01,00,"EntregaHD","EntregaHD","EntregaHD","EntregaHardware","EntregaHardware","EntregaHardware","@!","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","A","R","","","0=Nao;1=Sim","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","E5","C5_MOEDTIT","N",02,00,"MoedaTitulo","MoedaTitulo","MoedaTitulo","MoedadoTitulo","MoedadoTitulo","MoedadoTitulo","@E99","","€€€€€€€€€€€€€€ ","","",00,"þ","","","S","S","A","R","","","","","","","","","","","","","","","","","","N","N","N"})
AADD(aRegs,{"SC5","E6","C5_ESTPRES","C",02,00,"UFPrestacao","UFPrestacao","UFPrestacao","UFPrestacao","UFPrestacao","UFPrestacao","@!","","€€€€€€€€€€€€€€ ","","12",01,"","","","S","S","A","R","","","","","","","","","","","S","","","","","","","N","N","N"})
AADD(aRegs,{"SC5","E7","C5_XFLUVOU","C",07,00,"FluxoVouche","FluxoVouche","FluxoVouche","FluxoVoucher","FluxoVoucher","FluxoVoucher","@!","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","E8","C5_MDPROJE","C",06,00,"Cod.Projeto","Cod.Projeto","Cod.Projeto","Cod.Projeto","Cod.Projeto","Cod.Projeto","","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","E9","C5_MDEMPE","C",20,00,"Cod.Empenho","Cod.Empenho","Cod.Empenho","Cod.Empenho","Cod.Empenho","Cod.Empenho","","","€€€€€€€€€€€€€€ ","","",00,"þ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


RestArea(aArea)
Return('SX3 : ' + cTexto  + CHR(13) + CHR(10))
/*/


¿
³Funao    ³ GeraSX6  ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³
´
³Descriao ³ Funcao generica para copia de dicionarios                  ³
´
³Uso       ³ Generico                                                   ³
Ù


/*/
Static Function GeraSX6()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"","MV_PVCONTR","C","Gerapedidodevendaporatravesdomodulode","Gerapedidodevendaporatravesdomodulode","Gerapedidodevendaporatravesdomodulode","gestaodecontratos?(S/N)","gestaodecontratos?(S/N)","gestaodecontratos?(S/N)","","","","S","S","S","U","","","","","",""})

dbSelectArea("SX6")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 cTexto += IIf( aRegs[i,1] + aRegs[i,2] $ cTexto, "", aRegs[i,1] + aRegs[i,2] + "\")

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX6", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


RestArea(aArea)
Return('SX6 : ' + cTexto  + CHR(13) + CHR(10))
/*/


¿
³Funao    ³ GeraSX7  ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³
´
³Descriao ³ Funcao generica para copia de dicionarios                  ³
´
³Uso       ³ Generico                                                   ³
Ù


/*/
Static Function GeraSX7()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"CNB_PROGAR","001","PA8->PA8_DESBPG","CNB_DESGAR","P","N","PA8",01,"xFilial('PA8')+M->CNB_PROGAR","","U"})
AADD(aRegs,{"CNB_PROGAR","002","PA8->PA8_CODMP8","CNB_PRODUT","P","S","PA8",01,"XFILIAL('PA8')+M->CNB_PROGAR","","U"})
AADD(aRegs,{"CNB_PROGAR","003","PA8->PA8_DESMP8","CNB_DESCRI","P","S","PA8",01,"XFILIAL('PA8')+M->CNB_PROGAR","","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


RestArea(aArea)
Return('SX7 : ' + cTexto  + CHR(13) + CHR(10))
/*/


¿
³Funao    ³ GeraSXB  ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³
´
³Descriao ³ Funcao generica para copia de dicionarios                  ³
´
³Uso       ³ Generico                                                   ³
Ù


/*/
Static Function GeraSXB()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"","","","","","","","",""})

dbSelectArea("SXB")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2] + aRegs[i, 3] + aRegs[i, 4])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SXB", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


RestArea(aArea)
Return('SXB : ' + cTexto  + CHR(13) + CHR(10))
