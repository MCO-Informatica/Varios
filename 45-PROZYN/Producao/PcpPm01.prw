#Include "Protheus.ch"
#Include "TbiConn.ch"
#Include "Topconn.ch"


/*  
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PCPPM01   �Autor  �Henio Brasil        � Data � 14/03/2018  ���
�������������������������������������������������������������������������͹��
���Descricao �Processo que executa a chamada da tela para gerar dados     ���
���          �na tabela de Previsao de Vendas.                            ���
�������������������������������������������������������������������������͹�� 
���Chamada   �                                                            ���
�������������������������������������������������������������������������͹��
���Empresa   �PROZYN                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/ 
User Function PCPPM01(cProg)  

Local nOpca		:= 0 
Local aSays 	:= {}
Local aButtons	:= {}
Local aParam	:= {}
Local aRegs    	:= {}
Local lCallProc	:= .T. 
Local cVersion	:= 'Vr. 1.02'	 
Local cMenProc	:= "Aguarde... Processando Movimentos de Previs�es!"  
Local cCadastro	:= "Integra��o PCP para cria��o de Previsao de Vendas" 
Local cPerg		:= Padr("PCPPM01",Len(SX1->X1_GRUPO))	// Len(SX1->X1_GRUPO)		10 
Local aAreaC4	:= GetArea() 			// Determina o sucesso do processamento 
Local cString	:= "SC4" 

Private lJob	:= (FunName() == "PCPJOB01") 
/* 
���������������������������������������������������������������������Ŀ
� Cria os parametros da rotina                                        �
�����������������������������������������������������������������������*/  
Aadd(aRegs,{cPerg,"01","De Produto :"		,"","","mv_ch1","C",15,0,1,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})	
Aadd(aRegs,{cPerg,"02","Ate Produto :"		,"","","mv_ch2","C",15,0,1,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})	
Aadd(aRegs,{cPerg,"03","De Data Prev.:"	    ,"","","mv_ch3","D",08,0,1,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})	
Aadd(aRegs,{cPerg,"04","Ate Data Prev.:"	,"","","mv_ch4","D",08,0,1,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})	

/*
���������������������������������������������������������������������Ŀ
�Chamada da funcao para criacao das perguntas                         �
�����������������������������������������������������������������������*/  
If !SX1->(DbSeek(cPerg,.F.)) 
	Pm01NewSx1(aRegs)		
Endif 	
Pergunte(cPerg,.F.) 
aParam	:= {Mv_Par01,Mv_Par02,Mv_Par03,Mv_Par04 } 

If lJob 
	Processa({|lEnd| Pm01Process(Mv_Par01,Mv_Par02,Mv_Par03,Mv_Par04)}, cMenProc)
 Else 	
	Aadd(aSays,OemToAnsi("Este programa tem como objetivo de gerar informacoes para o 	")) 
	Aadd(aSays,OemToAnsi("Cadastro de Previsao de Vendas para ser utilizado no MRP. 	"))
	Aadd(aSays,OemToAnsi(""))
	Aadd(aButtons, { 5,.T.,{|oObj| (Pergunte(cPerg,.T.), aParam	:= {Mv_Par01,Mv_Par02,Mv_Par03,Mv_Par05}, oObj:oWnd:Refresh())	}})
	Aadd(aButtons, { 1,.T.,{|oObj| nOpca := 1, Processa({|lEnd| Pm01Process(Mv_Par01,Mv_Par02,Mv_Par03,Mv_Par04)}, cMenProc)}}) 		// Pm01Process(aParam)
	Aadd(aButtons, { 2,.T.,{|oObj| FechaBatch() }} )  
	FormBatch( cCadastro, aSays, aButtons )
Endif 
RestArea(aAreaC4)
Return



/* 
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �Pm01Process  � Autor �                    � Data �17/09/2016���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Executa a regra de processamento da funcao de geracao da    ���
���          �tabela de previsao de vendas.                               ���
�������������������������������������������������������������������������Ĵ��
���Empresa   �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function Pm01Process(cPrdIni,cPrdFim,dDatIni,dDatFim)  		// cPrdIni,cPrdFim,dAnoPrc,dDatIni,dDatFim)  

Local nResp		:= 0 
Local nCusPrv	:= 0 
Local cQryPrv	:= ''  
Local cQryDel	:= ''  
Local cLocPad	:= ''
Local aPrvVen	:= {} 
Local aObjects  := {}			// Array para redimensionamento da tela
Local aPosObj   := {}			// Array para redimensionamento da tela
Local aSize     := {}			// Array para redimensionamento da tela
Local aItens  	:= {}			// Itens do PAN 
Local aTela   	:= {}	
Local lImport 	:= .T. 
Local lGeraC4 	:= .F. 
Local cEnvSys	:= CurDir() 		// Pasta do system mapeado no ambiente deste Programa 
Local cEnvPrv	:= "QryPrv" 
Local cEnvDel	:= "QryDel" 
Local aAreaSA 	:= GetArea()
Local cFunName	:= Procname()		// Substr(Procname(),3,Len(Procname()))  
Local dDatPrv	:= Ctod('//') 
Local cDocPad	:= '000000001' 
Local cMesIni	:= Str(Year(dDatIni),4)
Local cMesFim	:= Str(Year(dDatFim),4)
Local dDatProc	:= Dtoc(dDataBase)      
Local aMeses	:= {'QTJAN','QTFEV','QTMAR','QTABR','QTMAI','QTJUN','QTJUL','QTAGO','QTSET','QTOUT','QTNOV','QTDEZ'}   
Local cObserv	:= 'Gerado Rotina automat. PCPPM01' 
Local dDatMin	:= SuperGetMv("MV_SC4DATM",.T.,Stod('20170101')) 		// Data minima a ser considerada para processamento 
Local nDiaGer	:= SuperGetMv("ES_SC4GDIA",.T.,1) 		// Data minima a ser considerada para processamento 

/* 
�����������������������������������������������������������������Ŀ
�Alinha a variavel nome da pasta de Dicionario                    �
�������������������������������������������������������������������*/ 
nPosBar := At("\",cEnvSys)
cEnvSys	:= If( nPosBar<>0, Substr(cEnvSys,1,nPosBar-1), cEnvSys) 	

/* 
�����������������������������������������������������������������Ŀ
�Valida a data de trava para execucao do processo                 �
�������������������������������������������������������������������*/ 
If dDatIni < dDatMin
	If !lJob 
		MsgAlert("Erro","A data informada no 4� parametro referente � data de previs�o est� menor que a data permitida = "+Dtoc(dDatIni)) 
	Endif 
	Return .F. 
Endif 

/*  
������������������������������������������������������������������������Ŀ
�Executa a query para selecionar dados de Laudos - Temporary Table       �
��������������������������������������������������������������������������*/ 
ProcRegua(10000)
IncProc(10)     
If Select("QryPrv") > 0 
	QryPrv->(DbCloseArea()) 
Endif 
cQryPrv := "SELECT 	Z2_PRODUTO PRODUT, Z2_ANO ANOLAN, Z2_TOPICO, Z2_CLIENTE CODCLI, Z2_LOJA LOJACLI, SUM(Z2_QTM01) QTJAN, SUM(Z2_QTM02) QTFEV,  "		// Z2_DATA DATLAN, 
cQryPrv += " 		SUM(Z2_QTM03) QTMAR, SUM(Z2_QTM04) QTABR, SUM(Z2_QTM05) QTMAI, SUM(Z2_QTM06) QTJUN, "
cQryPrv += " 		SUM(Z2_QTM07) QTJUL, SUM(Z2_QTM08) QTAGO, SUM(Z2_QTM09) QTSET, SUM(Z2_QTM10) QTOUT, "
cQryPrv += " 		SUM(Z2_QTM11) QTNOV, SUM(Z2_QTM12) QTDEZ  FROM "+RetSqlName("SZ2")+" A "
cQryPrv += " WHERE 	A.D_E_L_E_T_ = ' ' AND Z2_FILIAL = '"+xFilial("SZ2")+"' " 
cQryPrv += "   AND 	Z2_PRODUTO BETWEEN '"+cPrdIni+"' AND '"+cPrdFim+"' "           
cQryPrv += "   AND 	Z2_TOPICO = 'F' AND Z2_DATA <> ' ' " 
cQryPrv += "   AND 	Z2_ANO BETWEEN '"+cMesIni+"' AND '"+cMesFim+"' " 
// cQryPrv += "   AND 	Z2_ANO BETWEEN '"+Dtos(dDatIni)+"' AND '"+Dtos(dDatFim)+"' "
cQryPrv += " 	AND (Z2_QTM01      "
cQryPrv += " 	+Z2_QTM02      "
cQryPrv += " 	+Z2_QTM03      "
cQryPrv += " 	+Z2_QTM04      "
cQryPrv += " 	+Z2_QTM05      "
cQryPrv += " 	+Z2_QTM06      "
cQryPrv += " 	+Z2_QTM07      "
cQryPrv += " 	+Z2_QTM08      "
cQryPrv += " 	+Z2_QTM09      "
cQryPrv += " 	+Z2_QTM10      "
cQryPrv += " 	+Z2_QTM11      "
cQryPrv += " 	+Z2_QTM12) != 0 " 
cQryPrv += " GROUP 	BY  Z2_FILIAL, Z2_PRODUTO, Z2_ANO, Z2_TOPICO, Z2_CLIENTE, Z2_LOJA " 
cQryPrv += " ORDER 	BY  A.Z2_PRODUTO, A.Z2_ANO, A.Z2_CLIENTE, A.Z2_LOJA " 
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryPrv),cEnvPrv,.T.,.T.)   

memowrite("querysz2.txt",cQryPrv)

TCSetField(cEnvPrv,"Z2_DATA","D",8,0) 		// "DATPRV"
If (cEnvPrv)->(Eof())   
	If !lJob 
		Aviso("1. Integra��o Previs�o PCP","N�o foi possivel gerar informa��es com os parametros informados, reveja!", {"Ok"},2,cFunName)  
	Endif 
	Return(.F.) 
	/*  
	������������������������������������������������������������������������Ŀ
	�Se tiver movimento limpa a tabela SC4 com base na range sugerida        �
	��������������������������������������������������������������������������*/ 	
 Else 
	If Select("QryDel") > 0 
		QryDel->(DbCloseArea()) 
	Endif 
	cQryDel := "DELETE 	FROM "+ RetSqlName('SC4')+" "
	cQryDel += " WHERE 	D_E_L_E_T_ = ' ' AND C4_FILIAL = '"+xFilial("SC4")+"' "
	cQryDel += "   AND ( ( C4_DATA BETWEEN '"+Dtos(dDatIni)+"' AND '"+Dtos(dDatFim)+"' ) OR "  
	cQryDel += "   ( C4_YDTREF BETWEEN '"+Dtos(dDatIni)+"' AND '"+Dtos(dDatFim)+"' ) ) " 
	TcSqlExec(cQryDel) 
Endif     
If !lJob 
	nResp 	:= Aviso("Confirma��o","Deseja realmente atualizar dados de Previs�o de Vendas ?", {"&Sim","&N�o"},2,"Decis�o")   
	lImport := (nResp == 1) 
Endif 
/* 
����������������������������������������������������������������Ŀ
�Inicia o processo de geracao de dados no SC4                    �
������������������������������������������������������������������*/
If lImport 
	(cEnvPrv)->(DbGoTop())
	While (cEnvPrv)->(!Eof()) 
			// Trata o mes de processamento 
   			nMesCor := Month(dDatIni) 		// mes = 03     
   			nMesAte := 12
   			
   			If Year(dDatIni) != Year(dDatFim) .And. Str(Year(dDatFim),4) == Str((cEnvPrv)->(ANOLAN),4)
   				nMesCor := 01   
   				nMesAte := Month(dDatFim)
   			EndIf
   			
      		cProdut := (cEnvPrv)->(PRODUT)
      		cAnoLan	:= Str((cEnvPrv)->(ANOLAN),4)		// Stod((cEnvPrv)->(DATLAN)) 
      		cCodCli := (cEnvPrv)->(CODCLI)
      		cLojCli := (cEnvPrv)->(LOJACLI)
			// Resgata Almoxarifado padrao 
			cLocPad	:= Posicione("SB1", 1, xFilial("SB1")+cProdut,"B1_LOCPAD")  
            For nM:= nMesCor To nMesAte         
				Do Case 
				   Case nM == 1
						nQtdPrv := (cEnvPrv)->(QTJAN)
				   Case nM == 2
						nQtdPrv := (cEnvPrv)->(QTFEV)
				   Case nM == 3
						nQtdPrv := (cEnvPrv)->(QTMAR)
				   Case nM == 4
						nQtdPrv := (cEnvPrv)->(QTABR)
				   Case nM == 5
						nQtdPrv := (cEnvPrv)->(QTMAI)
				   Case nM == 6
						nQtdPrv := (cEnvPrv)->(QTJUN)
				   Case nM == 7
						nQtdPrv := (cEnvPrv)->(QTJUL)
				   Case nM == 8
						nQtdPrv := (cEnvPrv)->(QTAGO)
				   Case nM == 9
						nQtdPrv := (cEnvPrv)->(QTSET)
				   Case nM == 10
						nQtdPrv := (cEnvPrv)->(QTOUT)
				   Case nM == 11
						nQtdPrv := (cEnvPrv)->(QTNOV)
				   Case nM == 12
						nQtdPrv := (cEnvPrv)->(QTDEZ)
			    EndCase 
			    // Formata da data da Previsao 
				//dDatPrv	:= Ctod('10/'+StrZero(nM,2)+'/'+cAnoLan)  		// Str(Year(dAnoLan),4) 
				dDatPrv	:= Ctod(StrZero(nDiaGer,2)+'/'+StrZero(nM,2)+'/'+cAnoLan)  		// Str(Year(dAnoLan),4)   
				dDtRef  := Ctod(StrZero(nDiaGer,2)+'/'+StrZero(nM,2)+'/'+cAnoLan)
				//Prazo Externo
				nPrzExt := 0 
				nPrzExt	:= Posicione("SA7", 2, xFilial("SA7")+cProdut+cCodCli+cLojCli,"A7_ANTEMPO") 
				
				dDatPrv := dDatPrv - nPrzExt 
				
				// Valida se a Qtd e Valor possuem informacoes, caso n�o passa para o proximo 
			    If nQtdPrv <> 0.0 		// .And. nCusPrv <> 0.0 			    
				    // Captura valor de custo do Produto 
				    Pm01CallCus(cProdut,cLocPad,nQtdPrv,@nCusPrv) 
					// Cria a numeracao Automatica 
				   	//cDocPad := GetSX8Num("SC4","C4_DOC") 
					//ConfirmSx8()                                 
				    // Chama Criacao da Previsao 
					lMsHelpAuto	:= .T. 
					lMsErroAuto	:= .F.    
					DbSelectArea("SC4")  
					aPrvVen	:= {{"C4_FILIAL"	,xFilial("SC4")		,Nil},; 
								{"C4_PRODUTO"	,cProdut 			,Nil},;	 
								{"C4_LOCAL"		,cLocPad			,Nil},; 
								{"C4_DOC"		,""					,Nil},; 
								{"C4_QUANT"		,nQtdPrv			,Nil},; 
								{"C4_VALOR"		,nCusPrv			,Nil},; 
								{"C4_DATA"		,dDatPrv			,Nil},; 
								{"C4_OBS"		,cObserv			,Nil},;  
								{"C4_YCLIENT"	,cCodCli			,Nil},;  
								{"C4_YLOJA"	    ,cLojCli			,Nil},;  
								{"C4_YDTREF"    ,dDtRef 			,Nil},; 
								{"C4_GERACAO"	,''					,Nil}} 			// Para geracao automatica 
					/* 
					����������������������������������������Ŀ
					�Executa MsExecAuto da Previsao de Vendas�
					������������������������������������������*/  
					MSExecAuto({|x| Mata700(x)}, aPrvVen, 3)   // Inclusao 			
					If lMsErroAuto
					 	MostraErro(cEnvSys,'Edi_ErroPrv.log')  
					Endif					
				Endif                   
			Next 		
			DbSelectArea(cEnvPrv)
			(cEnvPrv)->(DbSkip())  
	EndDo 
Endif 
Return(.T.) 



/* 
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �Pm01CallCus  � Autor �Henio Brasil        � Data �16/03/2018���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Busca o custo do produto para gerar valor de previsao       ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Direitos  �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function Pm01CallCus(cProdut,cLocal,nQtdPrv,nCusPrv) 
/*  
������������������������������������������������������Ŀ
�Posiciona na tabela de Custo para alimentar variavel  �
��������������������������������������������������������*/ 
DbSelectArea("SB2")
DbSetOrder(1) 
If DbSeek(xFilial("SB2")+cProdut+cLocal) 
	nCusPrv := (SB2->B2_CM1	* nQtdPrv)
Endif 
Return 


/* 
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �Pm01NewSx1   � Autor �Henio Brasil        � Data �15/01/2012���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Tratamento de Criacao de Perguntas de parametros no SX1     ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Empresa   �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function Pm01NewSx1(aPerg)		

Local nX := 0
Local aAreaAnt := GetArea()
Local aAreaSX1 := SX1->(GetArea())

DbSelectArea("SX1")
DbSetOrder(1)
For nX:= 1 to Len(aPerg) 
	aPerg[nX,1] := Padr(aPerg[nX,1],Len(SX1->X1_GRUPO))
	If !DbSeek(aPerg[nX,1]+aPerg[nX,2])
		RecLock("SX1", .T.)
		For j:=1 to Len(aPerg[nX])
			FieldPut(j ,aPerg[nX,j])
		Next j
		MsUnlock()
	EndIf
Next nX
RestArea(aAreaSX1)
RestArea(aAreaAnt)
Return Nil