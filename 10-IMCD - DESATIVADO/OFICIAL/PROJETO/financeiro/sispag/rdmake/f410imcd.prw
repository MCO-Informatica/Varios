#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH" 

/*/
������������������������������������������������������������������������������?
���������������������������������������������������������������������������Ŀ�?
���Fun��o    ?FINA410    ?Autor ?Pilar S. Albaladejo   ?Data ?02.05.96 ��?
���������������������������������������������������������������������������Ĵ�?
���Descri��o ?Refaz acumulados de Clientes/Fornecedores                    ��?
���������������������������������������������������������������������������Ĵ�?
���Sintaxe   ?FINA410()                                                    ��?
���������������������������������������������������������������������������Ĵ�?
���Parametros?                                                             ��?
���������������������������������������������������������������������������Ĵ�?
��?Uso      ?SIGAFIN                                                      ��?
����������������������������������������������������������������������������ٱ?
������������������������������������������������������������������������������?
����������������������������������������������������������������������������?
/*/
User Function F410IMCD(lDireto)
//����������������������������������������������������������������������������?
//?Define Variaveis                                                          ?
//����������������������������������������������������������������������������?
Local nOpca     := 0
Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
LOCAL aSays:={}, aButtons:={}
Local nTempoIni:= 0
Local TempoFim	:=0
Local cTempo:=""
Private lFWCodFil := FindFunction("FWCodFil")
Private cCadastro := OemToAnsi("Refaz Dados Clientes/Fornecedores")  //"Refaz Dados Clientes/Fornecedores"

If IsBlind() .Or. lDireto
	BatchProcess( 	cCadastro, 	"  Este programa tem como objetivo recalcular os saldos acumulados de    " + Chr(13) + Chr(10) +;
								"clientes e/ou fornecedores. " , "AFI410",;
					{ || fa410Proce(.T.) }, { || .F. }) 
	Return .T.
Endif

Pergunte("AFI410",.f.)
AADD(aSays, OemToAnsi("  Este programa tem como objetivo recalcular os saldos acumulados de    "))  //"  Este programa tem como objetivo recalcular os saldos acumulados de    "
AADD(aSays, OemToAnsi("clientes e/ou fornecedores. " ))  //"clientes e/ou fornecedores.                                             "
If lPanelFin  //Chamado pelo Painel Financeiro			
	aButtonTxt := {}			
	If Len(aButtons) > 0
		AADD(aButtonTxt,{"Visualizar","Visualizar",aButtons[1][3]}) // Visualizar			
	Endif
	AADD(aButtonTxt,{"Parametros","Parametros", {||Pergunte("AFI410",.T. )}}) // Parametros						
	FaMyFormBatch(aSays,aButtonTxt,{||nOpca :=1},{||nOpca:=0})	
Else
	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
	AADD(aButtons, { 5,.T.,{|| Pergunte("AFI410",.T. ) } } )
	FormBatch( cCadastro, aSays, aButtons )
Endif

If  nOpcA == 1
	nTempoIni:=Seconds()
	Processa({|lEnd| fa410Proce()})  // Chamada da funcao de recalculos
	nTempoFim	:=Seconds()
	cTempo		:=StrZero((nTempoFim-nTempoIni)/60,5,0)
	MEnviaMail("044",{Substr(cUsuario,7,15),SubStr(cNumEmp,1,2),SubStr(cNumEmp,3,2),cTempo})
Endif


If lPanelFin  //Chamado pelo Painel Financeiro			
	dbSelectArea(FinWindow:cAliasFile)					
	ReCreateBrow(FinWindow:cAliasFile,FinWindow)      		
	INCLUI := .F.
	ALTERA := .F.	
Endif

Return

/*
������������������������������������������������������������������������������?
���������������������������������������������������������������������������Ŀ�?
���Fun��o    �fa410Process?Autor ?Pilar S. Albaladejo   ?Data ?02.05.96 ��?
���������������������������������������������������������������������������Ĵ�?
���Descri��o �Reprocessamento arquivos de cliente/fornecedor                ��?
���������������������������������������������������������������������������Ĵ�?
���Sintaxe   �fa410Processa()                                               ��?
���������������������������������������������������������������������������Ĵ�?
���Parametros�Nao ha'                                                       ��?
���������������������������������������������������������������������������Ĵ�?
��?Uso      ?SIGAFIN                                                      ��?
���������������������������������������������������������������������������Ĵ�?
��?PROGRAMADOR  ?DATA   ?BOPS ?MOTIVO DA ALTERACAO	  					��?
���������������������������������������������������������������������������Ĵ�?
��?Geronimo     ?6/02/06?93518�corre��o consiste em que nas vendas efe   ��?
��?             ?       ?     �tuadas pelo Sigaloja, nas formas de pgto  ��?
��?	         ?       ?     �CC ou CD?atualizo os dados do cliente e  ��?
��?         	 ?       ?     �n�o da administradora como anteriormente 	��?
����������������������������������������������������������������������������ٱ?
������������������������������������������������������������������������������?
������������������������������������������������������������������������������?
*/
static Function Fa410Proce(lBat)

// Variaveis utilizadas na chamada da stored procedure - TOP

Local nValForte := 0,nSaldoTit:=0
Local nMoeda  	:= Int(Val(GetMv("MV_MCUSTO")))
Local nMoedaF 	:= 0
Local cFilBusca := "  "
Local nTaxaM	:=0
Local lRet      := .T.
Local aBaixas
Local nMCusto	:=Val(GetMV("MV_MCUSTO"))
Local lE1MsFil := SE1->(FieldPos("E1_MSFIL") > 0)	
Local cFilSF2  := xFilial("SF2")

Local nMaiorVDA		:= 0
Local nMaiorVDAaux	:= 0
Local nMSaldo		:= 0 
Local cCliente   	:= " "
Local cNumPedVen 	:= ""
Local cCliPad  		:= SuperGetMv("MV_CLIPAD",,"")		// Cliente Padrao
Local cLojaPad  	:= SuperGetMv("MV_LOJAPAD",,"")		// Loja Padrao                                                                 
Local lGestao		:= Iif( lFWCodFil, FWSizeFilial() > 2, .F. )	// Indica se usa Gestao Corporativa
Local lFilExc		:= .T.
Local lRastro		:= If(FindFunction("FVerRstFin"),FVerRstFin(),.F.)
Local lFilSA1C		:= If( lGestao, FWModeAccess("SA1",3) == "C", FWModeAccess("SA1",1) == "C" )
Local lFilSA2C		:= If( lGestao, FWModeAccess("SA2",3) == "C", FWModeAccess("SA2",1) == "C" )
Local nRiscod	:= GetMV("MV_RISCOD")
Local nCtnumpag:= 0
Local nMetr := 0
Local cFornP :=""
 
#IFDEF TOP
	Local cProcNam := IIF(FindFunction("GetSPName"), GetSPName("FIN003","09"), "FIN003")
	Local cFilOld := cFilAnt
	Local cCliDe, cCliAte, cForDe, cForAte
	Local cCRNEG  := "/"+MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM+"/"+MVIRABT+"/"+MVFUABT+"/"+MVINABT+"/"+MVISABT+"/"+MVPIABT+"/"+MVCFABT
	Local cCRNEG1 := "/"+MVRECANT+"/"+MV_CRNEG
	Local cCPNEG  := "/"+MVPAGANT+"/"+MV_CPNEG+"/"+MVABATIM
	Local cTipoLC := "/"+MVPROVIS
	Local cArrayAux :=''
	Local iTamArray := 0, iTamFil := IIf( lFWCodFil, FWGETTAMFILIAL, 2 )
	Local iArray    := 0
	Local iX        := 0   
	Local Valor := 0 
	Local  Cont := 1
	Private cArrayFil1 :=''
	Private cArrayFil2 :=''
	Private cArrayFil3 :=''
	Private cArrayFil4 :=''
	Private cArrayFil5 :=''	
	Private cArrayFil6 :=''
	Private cArrayFil7 :=''	
	Private cArrayFil8 :=''
	Private cArrayFil9 :=''
#ENDIF
Private lFINA410FT := ExistBlock("FIN410FT")
 

// Fim das variaveis utilizadas na chamada da stored procedure
DEFAULT lBat	:= .F.
//��������������������������������������������������������������Ŀ
//?Verifica parametros informados                               ?
//����������������������������������������������������������������

#IFDEF TOP

If ExistProc( cProcNam, VerIDProc()) .and. ( TcSrvType() <> "AS/400" )
	cCRNEG     := Iif(Empty(cCRNEG),  ' ', cCRNEG)
	cCRNEG1    := Iif(Empty(cCRNEG1), ' ', cCRNEG1)
	cCPNEG     := Iif(Empty(cCPNEG),  ' ', cCPNEG)
	cTipoLC   := cTipoLC+"/"+GetSESTipos({ || ES_SALDUP == "2"},"1")
	cTipoLC   := Iif(Empty(cTipoLC)," ", cTipoLC)
	cCliDe    := Iif(Empty(mv_par03), ' ', Rtrim(mv_par03))
	cCliAte   := Rtrim(mv_par04)
	cForDe    := Iif(Empty(mv_par05), ' ', Rtrim(mv_par05))
	cForAte   := Rtrim(mv_par06)
	
	cArrayFil := ""
	cFilSA1 := xFilial("SA1")
	nFilLen := Len( AllTrim( cFilSA1 ) )  
	dbSelectArea("SM0")
	DbSeek(cEmpAnt)
	While !Eof() .and. cEmpAnt = SM0->M0_CODIGO
		cFilTMP := Iif( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
		If (!lGestao) .OR. (Substr(cFilTMP,1,nFilLen) = Substr(cFilSA1,1,nFilLen)) 
			cArrayFil += cFilTMP
		Endif
		DbSkip()
	EndDo
	cArrayFil1 := cArrayFil
	If lFWCodFil
		//����������������������������������������������������������������������������?
		//?			         	  Fil 01  Fil 02   Fil 03                         ?
		//?			         	 ������? ������? ������?                       ?
		//?			         	 X  X  X  Y  Y  Y  Z  Z  Z                        ?
		//�Posicao filiais na       236 ?238 ?240 ?242 ?                          ?
		//�na String                  237   239  * 241   243                          ?
		//?--------------------------------------------------------------------------?
		//�O Tam maximo a ser enviado em cada cArrayFilXX e 240, porem uma filial nao ?
		//�nao podera estar com um pedaco em cada array                               ?
		//����������������������������������������������������������������������������?
		cArrayFil1 := ''
		iArray := 1
		iX := 1
		cArrayAux := cArrayFil
		While iX <= Len(cArrayAux) 
			&('cArrayFil'+Str(iArray,1)) += Substr(cArrayAux, iX, iTamFil)
			If (Len(&('cArrayFil'+Str(iArray,1)))+iTamFil ) > 240 // Tamanho maximo da variavel aceita na procedure
				iArray := iArray + 1 // Muda variavel cArrayFilX
				iX := iX + iTamFil // Proxima filial
				Loop
			EndIf
			iX := iX + iTamFil // Proxima filial
		EndDo
	EndIf
    aResult := TCSPExec( xProcedures(cProcNam), ;
                        StrZero(mv_par01,1), StrZero(mv_par02,1),;
                        GetMv("MV_MCUSTO"),  dtos(dDatabase),;
                        cCRNEG,              cCRNEG1,;
                        cCPNEG,              cTipoLC,;
                        cCliDe,              cCliAte,;
                        cForDe,              cForAte,;
                        If(empty(cArrayFil1), ' ', cArrayFil1), If(Empty(cArrayFil2), ' ', cArrayFil2),;
                        If(Empty(cArrayFil3), ' ', cArrayFil3), If(Empty(cArrayFil4), ' ', cArrayFil4),;
                        If(Empty(cArrayFil5), ' ', cArrayFil5), If(Empty(cArrayFil6), ' ', cArrayFil6),;                        
                        If(Empty(cArrayFil7), ' ', cArrayFil7), If(Empty(cArrayFil8), ' ', cArrayFil8),;                        
                        If(Empty(cArrayFil9), ' ', cArrayFil9), iTamFil,;
                        nModulo, Rtrim(cCliPad), Rtrim(cLojaPad) ) 
	If Empty(aResult)
		MsgAlert(OemToAnsi("Erro na chamada do processo"))  //"Erro na chamada do processo"
	Elseif aResult[1] == "01" .or. aResult[1] == "1"
	   MsgAlert(OemToAnsi("Atualizacao OK"))  //"Atualizacao OK"
	Else
	  MsgAlert(OemToAnsi("Atualizacao com Erro"))  //"Atualizacao com Erro"
	Endif
	cFilAnt := cFilOld
Else
#ENDIF
	If !lBat
		If mv_par01 == 1
			ProcRegua(SA1->(RecCount())+SA2->(RecCount())+SE1->(RecCount())+SE2->(RecCount()))
		Elseif mv_par01 == 2
			ProcRegua(SA1->(RecCount())+SE1->(RecCount()))
		ElseIf mv_par01 == 3
			ProcRegua(SA2->(RecCount())+SE2->(RecCount()))
		EndIf
	EndIf
	//����������������������������������������������������������������������������?
	//?Cadastro de Clientes                                                      ?
	//����������������������������������������������������������������������������?
	If mv_par01 != 3
		DbSelectArea("SA1")
		If Empty(mv_par03)		
			dbGotop()
		Else
			dbSetOrder(1)		
			MsSeek(xFilial("SA1")+mv_par03,.T.)		
		EndIf
		While !Eof() .And. (SA1->A1_COD >= mv_par03 .And. SA1->A1_COD <= mv_par04)
			If !lBat		
				IncProc()
			EndIf
			If SA1->A1_COD >= mv_par03 .And. SA1->A1_COD <= mv_par04
		     	//����������������������������������������������������������������Ŀ
			   //�Ponto de entrada para filtro dos registros                      ?
		    	//������������������������������������������������������������������
		       If nModulo == 72
					lRet := KEXF130(mv_par01,"1")
			      If !lRet 
		     	      dbSkip()
						Loop
		     	   EndIf	
			   Endif	
			   If lFINA410FT
					lRet := ExecBlock("FIN410FT",.F.,.F.,{mv_par01,"1"})
			      If !lRet 
		     	      dbSkip()
						Loop
		     	   EndIf	
			   Endif				
				Reclock( "SA1" )
				SA1->A1_SALDUP := 0
				SA1->A1_SALDUPM:= 0
				SA1->A1_SALFIN := 0
				SA1->A1_SALFINM:= 0
		  		SA1->A1_VACUM  := 0
				If mv_par02 == 1 // Refaz dados historicos
					SA1->A1_METR   := 0
					SA1->A1_MATR   := 0
					SA1->A1_MAIDUPL:= 0
					SA1->A1_ATR    := 0
					SA1->A1_PAGATR := 0
					SA1->A1_NROPAG := 0
					SA1->A1_ULTCOM :=	CTOD("//")
					SA1->A1_MCOMPRA:= 0
					SA1->A1_MSALDO := 0
					SA1->A1_NROCOM := 0								
				Endif
				MsUnlock()
			Endif
			dbSkip()
		Enddo
	EndIf
	
	If mv_par01 != 2
		//����������������������������������������������������������������������������?
		//?Cadastro de Fornecedores                                                  ?
		//����������������������������������������������������������������������������?
		dbSelectArea( "SA2" )
		If Empty(mv_par05)		
			dbGotop()
		Else                 
			dbSetOrder(1)				
			MsSeek(xFilial("SA2")+mv_par05,.T.)		
		EndIf		
		While !Eof() .And. (SA2->A2_COD >= mv_par05 .And. SA2->A2_COD <= mv_par06)
			If !lBat		
				IncProc()
			EndIf
			If SA2->A2_COD >= mv_par05 .And. SA2->A2_COD <= mv_par06
		     	//����������������������������������������������������������������Ŀ
				//�Ponto de entrada para filtro dos registros                      ?
		    	//������������������������������������������������������������������
		       If nModulo == 72
					lRet := KEXF130(mv_par01,"2")
			      If !lRet 
		     	      dbSkip()
						Loop
		     	   EndIf	
			   Endif
			   If lFINA410FT
					lRet := ExecBlock("FIN410FT",.F.,.F.,{mv_par01,"2"})
					If !lRet 
						dbSkip()
						Loop
		     	   EndIf	
				Endif				
				Reclock( "SA2" )
				SA2->A2_SALDUP  := 0
				SA2->A2_SALDUPM := 0
				SA2->A2_MCOMPRA := 0 				
				If FieldPos("A2_MNOTA") <> 0
					SA2->A2_MNOTA   := 0
				EndIf                               
				If mv_par02 == 1
					SA2->A2_NROCOM := 0
					SA2->A2_MSALDO := 0
				EndIf
				MsUnlock()
			Endif	
			dbSkip( )
		Enddo
	EndIf	
	
	// Busca primeira filial do SIGAMAT
	DbSelectArea("SM0")
	DbGoTOp()
	DbSeek(cEmpAnt)
	cFirstFIL := Iif( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	
	//����������������������������������������������������������������������������?
	//?Titulos a Receber - Atualiza saldos clientes                              ?
	//����������������������������������������������������������������������������?
	If mv_par01 != 3
		dbSelectArea( "SE1" )
		dbSetOrder(2)
		If Empty(mv_par03)
			dbGotop()
		Else
			
			If lFilSA1C  // Se filial SA1 for totalmente compartilhada, varrer todas filiais da SE1
				MsSeek(xFilial("SE1",cFirstFIL)+mv_par03,.T.)
			Else
				MsSeek(xFilial("SE1")+mv_par03,.T.)
			EndiF
		
		EndIf
		
		nMaiorVDA := 0
		Cont := 0
		
		While !Eof() .And. (SE1->E1_CLIENTE >= mv_par03 .And. SE1->E1_CLIENTE <= mv_par04)
			If !lBat
				IncProc()
			EndIf
			If SE1->E1_CLIENTE >= mv_par03 .And. SE1->E1_CLIENTE <= mv_par04
				//��������������������������������������������������������?
				//?No caso dos modulos Sigaloja e Front Loja nao atualiza?
				//?os saldos de duplicatas para o cliente padrao	 	  ?
		    	//��������������������������������������������������������?
				If (nModulo == 12 ) .OR. ( nModulo == 72) 
					If cCliPad + cLojaPad == SE1->E1_ClIENTE + SE1->E1_LOJA 
						SE1->(DbSkip())
						Loop
					EndIf	
				EndIf
		     	//����������������������������������������������������������������Ŀ
				//�Ponto de entrada para filtro dos registros                      ?
		    	//������������������������������������������������������������������
		    	If nModulo == 72
					lRet := KEXF130(mv_par01,"3")
					If !lRet 
						dbSkip()
						Loop
		     	   EndIf	
			    Endif
				If lFINA410FT
					lRet := ExecBlock("FIN410FT",.F.,.F.,{mv_par01,"3"})
					If !lRet 
						dbSkip()
						Loop
					EndIf	
				Endif				
				//������������������������������������������������������������������������?
				//?Atualiza Saldo do Cliente                                             ?
				//������������������������������������������������������������������������?
				dbSelectArea( "SA1" )
				
				If lGestao
					lFilExc := ( !Empty( FWFilial("SA1") ) .and. !Empty( FWFilial("SE1") ) )
				Else	
					lFilExc := !Empty( xFilial( "SA1" ) ) .and. !Empty( xFilial( "SE1" ) )
				EndIf

				If lFilExc
					cFilBusca := SE1->E1_FILIAL		// Ambos exclusivos, neste caso
																// a filial serah 1 para 1
				Else
					cFilBusca := xFilial("SA1",SE1->E1_FILORIG)		// filial do cliente (SA1)
				Endif

				//�������������ADV��������������������������?
				//?Monta a chave de busca para o SA1    ?
				//���������������������������������������� 				
				cChaveSe1 := cFilBusca + SE1->E1_CLIENTE+ SE1->E1_LOJA
							
				dbSelectArea( "SA1" )
				If (dbSeek( cChaveSe1 ) )
					If !(SA1->(A1_FILIAL+A1_COD+A1_LOJA) ==  cCliente)
						cCliente     := SA1->(A1_FILIAL+A1_COD+A1_LOJA)
						nMaiorVDA    := 0
						nMaiorVDAaux := 0
						nMSaldo      := 0
					EndIf
  					nMoedaF		:= If(SA1->A1_MOEDALC > 0,SA1->A1_MOEDALC,nMoeda)
					nTaxaM:=Round(SE1->E1_VLCRUZ/SE1->E1_VALOR,3)
					If SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM+"/"+MVIRABT+"/"+MVFUABT+"/"+MVINABT+"/"+MVISABT+"/"+MVPIABT+"/"+MVCFABT
						AtuSalDup("-",SE1->E1_SALDO,SE1->E1_MOEDA,SE1->E1_TIPO,Iif(nTaxaM==1,Nil,nTaxaM),SE1->E1_EMISSAO)
					Else
						nSaldoTit := SE1->E1_SALDO
						nSaldoTit := Iif(nSaldoTit < 0, 0, nSaldoTit)
						IF !(SE1->E1_TIPO $ MVPROVIS)
							AtuSalDup("+",nSaldoTit,SE1->E1_MOEDA,SE1->E1_TIPO,Iif(nTaxaM==1,Nil,nTaxaM),SE1->E1_EMISSAO)
						Endif
		    			Reclock( "SA1" )
						SA1->A1_PRICOM  := Iif(SE1->E1_EMISSAO<A1_PRICOM.or.Empty(A1_PRICOM),SE1->E1_EMISSAO,A1_PRICOM)
						If mv_par02 == 1  //Refaz dados Historicos
							SA1->A1_ULTCOM  := Iif(A1_ULTCOM<SE1->E1_EMISSAO,SE1->E1_EMISSAO,A1_ULTCOM)
						Endif
						
						If Year(SE1->E1_EMISSAO) == Year(dDataBase) .And. !("FINA280" $ AllTrim(Upper(SE1->E1_ORIGEM)))
							If lRastro
								// Se for desdobramento por rastreamento (FI7/FI8), verifica se nao eh baixa por desdobramento
								FI7->( dbSetOrder( 1 ) )
								If !FI7->( MsSeek( xFilial("FI7") + SE1->( E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA ) ) )
									SA1->A1_VACUM += xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoedaF,SE1->E1_EMISSAO,3,SE1->E1_TXMOEDA)
								EndIf	
							Else										
								SA1->A1_VACUM += xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoedaF,SE1->E1_EMISSAO,3,SE1->E1_TXMOEDA)
							EndIf	
						Endif
	
						IF !(SE1->E1_TIPO $ MVPROVIS)					
						    						    
						    If AllTrim(Upper(SE1->E1_ORIGEM)) == "MATA460"
						       SF2->(dbSetOrder(2)) 							
							    cFilSF2 := If ( lE1Msfil .and. !Empty(xFilial("SF2")) .AND. !EMPTY(SE1->E1_MSFIL) , SE1->E1_MSFIL , xFilial("SF2"))
								If !SF2->( MsSeek(cFilSF2+SE1->(E1_CLIENTE+E1_LOJA+E1_NUM+E1_PREFIXO)))   
									// Se nao encontrou a nota, procura pela serie da nota ao inves do prefixo (MV_1DUPREF customizado)
									SF2->( MsSeek(cFilSF2+SE1->(E1_CLIENTE+E1_LOJA+E1_NUM+E1_SERIE)))
								Endif
								If SF2->(!EoF())
							      	nMaiorVDAaux := xMoeda(SF2->F2_VALFAT,SE1->E1_MOEDA,nMoedaF,SE1->E1_EMISSAO) 
								    If nMaiorVDA < nMaiorVDAaux
								        nMaiorVDA := nMaiorVDAaux
								    Endif
							   Endif
							Else
							   nMaiorVDA := xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoedaF,SE1->E1_EMISSAO,3,SE1->E1_TXMOEDA)
							Endif							   						    
						    
							nValForte := xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoedaF,SE1->E1_EMISSAO,3,SE1->E1_TXMOEDA)
							If nValForte > SA1->A1_MAIDUPL .and. mv_par02 == 1 //refaz dados historicos
								If lRastro
									// Se for desdobramento por rastreamento (FI7/FI8), verifica se nao eh baixa por desdobramento
									FI7->( dbSetOrder( 1 ) )
									If !FI7->( MsSeek( xFilial("FI7")+SE1->( E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA ) ) )
										SA1->A1_MAIDUPL := nValForte
									EndIf
								Else		
									SA1->A1_MAIDUPL := nValForte
								EndIf	
							EndIF
						
							//������������������������������������������������������������������Ŀ
							//?Atualiza Atrasos/Pagamentos em Atraso do Cliente  - 07/12/95     ?
							//��������������������������������������������������������������������
							aBaixas:=Baixas(SE1->E1_NATUREZ,SE1->E1_PREFIXO,SE1->E1_NUM,;
								SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_MOEDA,"R",SE1->E1_CLIENTE,;
								dDataBase,SE1->E1_LOJA,SE1->E1_FILIAL)
	
							If mv_par02 == 1 .and. (Empty(SE1->E1_FATURA) .Or. Substr(SE1->E1_FATURA,1,6) = "NOTFAT") .And.;
								STR(SE1->E1_SALDO,17,2) != STR(SE1->E1_VALOR,17,2)
								If lRastro
									// Se for desdobramento por rastreamento (FI7/FI8), verifica se nao eh baixa por desdobramento
									FI7->( dbSetOrder( 1 ) )
									If !FI7->( MsSeek( xFilial("FI7")+SE1->( E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA ) ) )
										SA1->A1_NROPAG += aBaixas[11]
									EndIf
								Else
									SA1->A1_NROPAG += aBaixas[11]								
								EndIf		
							Endif
							If SE1->E1_SALDO == 0
								If (Empty(SE1->E1_FATURA) .Or. Substr(SE1->E1_FATURA,1,6) = "NOTFAT")
									If (SE1->E1_BAIXA - SE1->E1_VENCREA) > 0 .and. mv_par02 == 1
										SA1->A1_PAGATR += SE1->E1_VALLIQ
									Endif
								Endif
							Else
								If SE1->E1_VENCREA < dDatabase .and. mv_par02 == 1
									If SA1->A1_RISCO = "D" 
										If dDatabase - SE1->E1_VENCREA > nRiscod
											SA1->A1_ATR += SE1->E1_SALDO
										EndIf
									Else
										SA1->A1_ATR += SE1->E1_SALDO
									EndIF
								Endif
							Endif
							
							//������������������������������������������������������������������Ŀ
							//?Atualiza Dados Historicos                                        ?
							//��������������������������������������������������������������������
				        	If mv_par02 == 1
				
								//A1_MSALDO - Maior saldo de duplicatas do Cliente
								//A1_METR - Media de atrasos do Cliente
								//A1_MATR - Maior atraso do Cliente
	  								  							
	  							If nMaiorVDA > SA1->A1_MCOMPRA
	  								SA1->A1_MCOMPRA := nMaiorVDA
	  							Endif
	  						 		  						 	
								// Nao incrementa faturas a receber (FINA280)
								If !("FINA280" $ AllTrim(Upper(SE1->E1_ORIGEM)))
		  							If !Empty(SE1->E1_PEDIDO) 
										// Se existe pedido de vendas, somente incrementa se for um pedido diferente do titulo anterior
		  								If cNumPedVen != SE1->E1_PEDIDO
			  						 		SA1->A1_NROCOM  += 1
			  						 	EndIf	
		  						 	Else	               
										If lRastro
											// Se for desdobramento por rastreamento (FI7/FI8), verifica se nao eh baixa por desdobramento
											FI7->( dbSetOrder( 1 ) )
											If !FI7->( MsSeek( xFilial("FI7")+SE1->( E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA ) ) )
												SA1->A1_NROCOM  += 1
											EndIf
										Else				  						 	
				  						 	// Se nao existe pedido, entao incrementa como titulo normal do Financeiro
			  						 		SA1->A1_NROCOM  += 1
			  						 	EndIf			  						 	
						         	EndIf
						        EndIf
                                      

								//LUIZ 
							    	
								   
							  	   If Cont = 0   
							  	   		cliente := SE1->E1_CLIENTE  
							  	   		Loja := SE1->E1_LOJA
							  	   		Cliloja := SE1->E1_CLIENTE+SE1->E1_LOJA  
							 	   		
							 	   		cont := 1
								   		nMSaldo := IMCDSaldo(SE1->E1_CLIENTE,nMoedaF,SE1->E1_LOJA)  
								   		
								   else                         
								   
								   		If Cliloja <> SE1->E1_CLIENTE+SE1->E1_LOJA
								   			nMSaldo := IMCDSaldo(SE1->E1_CLIENTE,nMoedaF,SE1->E1_LOJA)
							  	   	  		
							  	   	  		cliente := SE1->E1_CLIENTE  
							  	   	  		Loja := SE1->E1_LOJA
							  	   	 		Cliloja := SE1->E1_CLIENTE+SE1->E1_LOJA 
								   		Endif 
								   Endif		
								   		
								     
		   //						   If nMsaldo < valor
		  //						    nMsaldo := valor
		  //						   endif 
		 //						nMsaldo :=IMCDSaldo(SE1->E1_CLIENTE,nMoedaF) 

					         	If SA1->A1_SALDUPM > SA1->A1_MSALDO
						         	SA1->A1_MSALDO := SA1->A1_SALDUPM
								Else
						         	If nMSaldo > SA1->A1_MSALDO
										SA1->A1_MSALDO := nMSaldo
									EndIf
								EndIf	
								
								IF Empty(SE1->E1_FATURA) .Or. Substr(SE1->E1_FATURA,1,6) = "NOTFAT" 
									If (SE1->E1_BAIXA - SE1->E1_VENCREA) > SA1->A1_MATR
										SA1->A1_MATR := SE1->E1_BAIXA - SE1->E1_VENCREA
									EndIf
									If !Empty(SE1->E1_BAIXA)
										SA1->A1_METR := (SA1->A1_METR * (SA1->A1_NROPAG-1) + (SE1->E1_BAIXA - SE1->E1_VENCREA))/ SA1->A1_NROPAG
									Endif
								Endif	
							Endif
							MsUnlock( )
						Endif
						//������������������������������������������������Ŀ
						//�Funcao para ajustar os campos do SA1 para vendas?
						//�que possuem Administradora Financeira e         ?
						//�apenas para o modulo SIGALOJA                   ?
						//��������������������������������������������������
						F410AjusLj(nMaiorVDA,cNumPedVen,nMoedaF)
					Endif
				Endif
			Endif	
			cNumPedVen := SE1->E1_PEDIDO
			dbSelectArea( "SE1" )
			dbSkip()
		Enddo
	EndIf
	If mv_par01 != 2
		//����������������������������������������������������������������������������?
		//?Titulos a Pagar - atualiza saldos fornecedores                            ?
		//����������������������������������������������������������������������������?
		dbSelectArea( "SE2" )
		dbSetOrder(6)
		If Empty(mv_par05)	
			dbGotop()
		Else
			If lFilSA1C	// Se filial SA2 for totalmente compartilhada, varrer todas filiais da SE2
				MsSeek(xFilial("SE2",cFirstFIL)+mv_par05,.T.)
			Else
				MsSeek(xFilial("SE2")+mv_par05,.T.)
			EndIf
			 nCtnumpag:= 1
			 nMetr := 0		
		EndIf
		While !Eof() .And.(SE2->E2_FORNECE >= mv_par05 .And. SE2->E2_FORNECE<= mv_par06)
			If !lBat		
				IncProc()
			EndIf	
			IF cFornP != Alltrim (SE2->E2_FORNECE)
			   nCtnumpag:= 1
			   nMetr := 0
			ENDIF  
			    
			
			If SE2->E2_FORNECE >= mv_par05 .And. SE2->E2_FORNECE<= mv_par06
		     	//����������������������������������������������������������������Ŀ
		      //�Ponto de entrada para filtro dos registros                      ?
		    	//������������������������������������������������������������������
	    		If nModulo == 72
					lRet := KEXF130(mv_par01,"4")
					If !lRet 
						dbSkip()
						Loop
		     	   EndIf	
			    Endif
				If lFINA410FT
			   	lRet := ExecBlock("FIN410FT",.F.,.F.,{mv_par01,"4"})
					If !lRet 
						dbSkip()
						Loop
					EndIf	
				Endif				
				//������������������������������������������������������������������������?
				//?Atualiza Saldo do Fornecedor                                          ?
				//������������������������������������������������������������������������?
				dbSelectArea( "SA2" )
				                                                            
				If lGestao
					lFilExc := ( !Empty( FWFilial("SA2") ) .and. !Empty( FWFilial("SE2") ) )
				Else	
					lFilExc := ( !Empty( xFilial("SA2") ) .and. !Empty( xFilial("SE2") ) )
				EndIf
				
				If lFilExc
					cFilBusca := SE2->E2_FILIAL		// Ambos exclusivos, neste caso
																// a filial serah 1 para 1
				Else
					cFilBusca := xFilial("SA2",SE2->E2_FILORIG)		// filial do fornecedor (SA2)
				Endif
		
				If (dbSeek( cFilBusca+SE2->E2_FORNECE+SE2->E2_LOJA ) )
					Reclock( "SA2" )
					If  SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG+"/"+MVABATIM
						SA2->A2_SALDUP  -= xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,1,SE2->E2_EMISSAO)
						SA2->A2_SALDUPM -= xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,nMoeda,SE2->E2_EMISSAO)
						SA2->A2_MCOMPRA := Max(SA2->A2_MCOMPRA,Round(NoRound(xMoeda(SE2->E2_VALOR,1,nMCusto,SE2->E2_EMISSAO,3),3),2) )							
					Else
						SA2->A2_SALDUP  += xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,1,SE2->E2_EMISSAO)
						SA2->A2_SALDUPM += xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,nMoeda,SE2->E2_EMISSAO)
						SA2->A2_PRICOM  := Iif(SE2->E2_EMISSAO<A2_PRICOM .or. empty(A2_PRICOM),SE2->E2_EMISSAO,A2_PRICOM)
						SA2->A2_ULTCOM  := Iif(A2_ULTCOM<SE2->E2_EMISSAO,SE2->E2_EMISSAO,A2_ULTCOM)
						SA2->A2_MCOMPRA := Max(SA2->A2_MCOMPRA,Round(NoRound(xMoeda(SE2->E2_VALOR,1,nMCusto,SE2->E2_EMISSAO,3),3),2) )							
						IF ! EMPTY (SE2->E2_BAIXA)
					 	     nMetr += SE2->E2_BAIXA - SE2->E2_VENCREA  							
					        SA2->A2_METR := nMetr / nCtnumpag
					        nCtnumpag += 1
					        cFornP := Alltrim (SE2->E2_FORNECE)
						endif 
						
						If mv_par02 == 1
							If !("FINA290" $ AllTrim(Upper(SE2->E2_ORIGEM)))
								SA2->A2_NROCOM += 1
							EndIf	                  
							If SA2->A2_SALDUPM > SA2->A2_MSALDO
								SA2->A2_MSALDO := A2_SALDUPM
							EndIf	
						EndIf
					EndIf                                                      
					If FieldPos("A2_MNOTA") <> 0
						If SubStr(SE2->E2_ORIGEM,1,3) == "FIN"
							SA2->A2_MNOTA   := Max(SA2->A2_MNOTA,Round(NoRound(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,nMCusto,SE2->E2_EMISSAO,3),3),2) )													
						Else        
							DbSelectArea("SF1")
							DbSetOrder(1)
							DBSeek(xFilial("SF1")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)
							SA2->A2_MNOTA   := Max(SA2->A2_MNOTA,Round(NoRound(xMoeda(SF1->F1_VALBRUT,SF1->F1_MOEDA,nMCusto,SF1->F1_EMISSAO,3),3),2) )																				
						EndIf
					EndIf
					MsUnlock()
				EndIf
			Endif	
			dbSelectArea("SE2")
			SE2->( dbSkip())
		Enddo
	EndIf
	dbSelectArea( "SE1" )
	dbSetOrder(1)
	MsUnlockAll()
	
#IFDEF TOP
Endif
#ENDIF

Return
/*/
����������������������������������������������������������������������������?
����������������������������������������������������������������������������?
�������������������������������������������������������������������������Ŀ�?
���Funcao    �VerIDProc ?Autor ?Marcelo Pimentel      ?Data ?4.07.2007��?
�������������������������������������������������������������������������Ĵ�?
���Descri��o �Identifica a sequencia de controle do fonte ADVPL com a     ��?
��?         �stored procedure, qualquer alteracao que envolva diretamente��?
��?         �a stored procedure a variavel sera incrementada.            ��?
��?         �Procedure FIN003                                            ��?
�������������������������������������������������������������������������Ĵ�?
��?  DATA   ?Programador   �Manutencao Efetuada                         ��?
��������������������������������������������������������������������������ٱ?
����������������������������������������������������������������������������?
����������������������������������������������������������������������������?
/*/         
Static Function VerIDProc()
Return '010'

/*/
��������������������������������������������������������������������������������?
��������������������������������������������������������������������������������?
�����������������������������������������������������������������������������Ŀ�?
���Funcao    �F410AjusLj    ?Autor ?Vendas e CRM		    ?Data ?2.09.2008��?
�����������������������������������������������������������������������������Ĵ�?
���Descri��o �Faz algumas alteracoes para que os campos referentes ao         ��?
��?         �titulo/duplicata  que foram gravados no regostrp da             ��?
��?         �administradora financeira sejam gravados no registro do         ��?
��?         �cliente da venda                                                ��?
������������������������������������������������������������������������������ٱ?
���Parametros?ExpN1 - Maior Venda      					                  ��?
��?		 ?ExpC2 - Numero do Pedido                                       ��?
��?		 ?ExpN3 - Moeda Forte                                            ��?
�����������������������������������������������������������������������������Ĵ�?
���Retorno   ?Nil                                                            ��?
�����������������������������������������������������������������������������Ĵ�?
��?Uso      ?SigaLoja                                                       ��?
������������������������������������������������������������������������������ٱ?
��������������������������������������������������������������������������������?
����������������������������������������������������������������������������������
/*/         
Static Function F410AjusLj(nMaiorVDA,cNumPedVe,nMoedaF)

Local lE1MsFil 		:= SE1->(FieldPos("E1_MSFIL") > 0)	// Verifica se existe o campo E1_MSFIL
Local cFilSF2  		:= xFilial("SF2") 					// Filial do SF2
Local cFilBusca 	:= "  "								// Filial de busca a ser preenchida de acordo  com a condicao

DEFAULT nMaiorVDA   := 0
DEFAULT cNumPedVe   := ""
DEFAULT nMoedaF		:= Int(Val(SuperGetMv("MV_MCUSTO",,"") ))
//����������������������������������������������������������������������Ŀ
//�Caso pertenca a um dos tipos abaixo grava algumas informacoes         ?
//�no registro do cliente que efetuou a compra.                          ?
//�Cartao Credito, Vales, Convenio,Cartao de Debito,Financiamento Proprio?
//������������������������������������������������������������������������
If Upper(subs(SE1->E1_ORIGEM,1,3)) == "LOJ" .AND. ALLTRIM( SE1->E1_TIPO)  $ "CC;VA;CO;CD;FI"
	//��������������������������������������Ŀ
	//�Primeiramente busca se este titulo foi?
	//�gerado a partir de uma venda ( SF2 )  ?
	//����������������������������������������
	DbSelectArea("SF2") 
	DbSetOrder(1) 
	cFilSF2 := IIf(lE1Msfil .AND. !Empty(xFilial("SF2")),SE1->E1_MSFIL,xFilial("SF2"))
	If DbSeek(cFilSF2+SE1->E1_NUM +SE1->E1_PREFIXO)
		//������������������������������������������������������������Ŀ
		//�Caso o cliente do titulo seja diferente da venda siginifica ?
		//�que eh uma administradora e nao eh financiamento prorpio    ?
		//��������������������������������������������������������������
		If (SF2->F2_CLIENTE + SF2->F2_LOJA) <> (SE1->E1_CLIENTE + SE1->E1_LOJA)
			DbSelectArea("SA1")
			DbSetOrder(1)
			If !Empty(xFilial("SA1")) .AND. !Empty(xFilial("SE1"))
				cFilBusca := SE1->E1_FILIAL			// Ambos exclusivos, neste caso a filial serah 1 para 1
			Else
				cFilBusca := xFilial("SA1")			// filial do cliente (SA1)
			Endif
			//����������������������������������������������������������������������������Ŀ
			//�Posiciona o cliente da venda e faz a gravacao dos campos referentes a venda ?
			//������������������������������������������������������������������������������
			If DbSeek(cFilBusca + SF2->F2_CLIENTE+ SF2->F2_LOJA) 
				RecLock("SA1",.F.)
				If( SE1->E1_EMISSAO < SA1->A1_PRICOM .OR. Empty(SA1->A1_PRICOM) )
					REPLACE SA1->A1_PRICOM  WITH SE1->E1_EMISSAO
				EndIf	
				If MV_PAR02 == 1  					//Refaz dados Historicos
					If(SA1->A1_ULTCOM < SE1->E1_EMISSAO)
						REPLACE SA1->A1_ULTCOM  WITH SE1->E1_EMISSAO
					EndIf	
					If nMaiorVDA > SA1->A1_MCOMPRA
						REPLACE SA1->A1_MCOMPRA WITH nMaiorVDA
					EndIf
				Endif
				If Year(SE1->E1_EMISSAO) == Year(dDataBase) .AND. !("FINA280" $ AllTrim(Upper(SE1->E1_ORIGEM)))
					REPLACE SA1->A1_VACUM WITH SA1->A1_VACUM += xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoedaF,SE1->E1_EMISSAO)
				Endif 
				//����������������������������������������������������������Ŀ
				//?Numero de compras efetuadas pelo cliente na empresa.     ?
				//?O sistema soma auton�ticamente um a cada pedido de venda.?
				//������������������������������������������������������������
				If !("FINA280" $ AllTrim(Upper(SE1->E1_ORIGEM)))
			  		If !Empty(SE1->E1_PEDIDO)
			  			If cNumPedVe <> SE1->E1_PEDIDO
				   			REPLACE SA1->A1_NROCOM WITH SA1->A1_NROCOM += 1
				   		EndIf
				   	Else
			   			REPLACE SA1->A1_NROCOM WITH SA1->A1_NROCOM += 1
			   		EndIf
					MsUnlock()
				EndIf
		   	EndIf	
		EndIf	   		
	EndIf		   		
EndIf					

Return(Nil) 

/*
����������������������������������������������������������������������������?
����������������������������������������������������������������������������?
�������������������������������������������������������������������������ͻ�?
���Programa  ?IMCDSaldo �Autor  ?Luiz Oliveira  ?Data ? 02/02/16      ��?
�������������������������������������������������������������������������͹�?
���Descricao ?Refaz o maior saldo baseado no hist�rico do cliente        ��?
�������������������������������������������������������������������������͹�?
���Uso       ?IMCDSaldo                                                    ��?
�������������������������������������������������������������������������ͼ�?
����������������������������������������������������������������������������?
����������������������������������������������������������������������������?
*/


Static Function IMCDSaldo(cliente,nMoedaF,loja)
//query com todos titulos do cliente     base 1
cQ := "SELECT * FROM SE1010 WHERE E1_CLIENTE = '"+cliente+"' AND E1_FILIAL = '"+xFilial('SE1')+"' AND E1_LOJA = '"+loja+"' AND E1_TIPO <> 'RA' AND D_E_L_E_T_ <> '*' ORDER BY E1_EMISSAO "
TcQuery ChangeQuery(cQ) NEW ALIAS "XE1"
//query com todos titulos do cliente     base 2
cQ := "SELECT * FROM SE1010 WHERE E1_CLIENTE = '"+cliente+"'  AND E1_FILIAL = '"+xFilial('SE1')+"' AND E1_LOJA = '"+loja+"' AND E1_TIPO <> 'RA' AND D_E_L_E_T_ <> '*' ORDER BY E1_EMISSAO "
TcQuery ChangeQuery(cQ) NEW ALIAS "XE2"

dbSelectArea("XE2")
DbGoTop()

dbSelectArea("XE1")
DbGoTop()

ValTotal := 0 //soma total 
Inicio := 1  //variavel para primeira rodada de calculo
vValor := 0  //valor do titulo

While !eof()
ValTotal := 0	
	If Inicio = 1 

		vValor := xMoeda(XE1->E1_VALOR,XE1->E1_MOEDA,nMoedaF,date(),3,XE1->E1_TXMOEDA)  //data sem varia��o cambial
    	
    	Inicio := 2  //descartando primeira rodada
    	
    	Emissao := XE1->E1_EMISSAO
    	UltBx := XE1->E1_BAIXA
   
    	ValTotal := xMoeda(XE1->E1_VALOR,XE1->E1_MOEDA,nMoedaF,date(),3,XE1->E1_TXMOEDA)   
    	
    	Acumulado := 0 
   
    	Mvalor := xMoeda(XE1->E1_VALOR,XE1->E1_MOEDA,nMoedaF,date(),3,XE1->E1_TXMOEDA)
   		
   		vValor := xMoeda(XE1->E1_VALOR,XE1->E1_MOEDA,nMoedaF,date(),3,XE1->E1_TXMOEDA)
   
    	Totalacu := 0
    else 
    
        While !eof() .and. XE1->E1_EMISSAO >= UltBx .and. !empty(XE1->E1_BAIXA)  

	        ValTotal := xMoeda(XE1->E1_VALOR,XE1->E1_MOEDA,nMoedaF,date(),3,XE1->E1_TXMOEDA)	 
		    
			Ultbx := XE1->E1_BAIXA  
			Acumulado := 0
			Emissao := XE1->E1_EMISSAO
			
			If ValTotal > Mvalor 
		   		Mvalor := ValTotal
			Endif
			

			dbSelectArea("XE1")
			dbskip() 
        Enddo  
        
   
        If XE1->E1_EMISSAO <= UltBx .or. Empty(XE2->E1_BAIXA) 
		dbSelectArea("XE2")
		DbGoTop()
				Acumulado := 0
        		While !eof() .AND. XE2->E1_EMISSAO <= XE1->E1_EMISSAO 
        		    If XE2->E1_BAIXA >= XE1->E1_EMISSAO .or. (EMPTY(XE2->E1_BAIXA) .AND. XE1->E1_EMISSAO >= XE2->E1_EMISSAO) 

        	   		 		Acumulado += xMoeda(XE2->E1_VALOR,XE2->E1_MOEDA,nMoedaF,date(),3,XE2->E1_TXMOEDA)	 

        	   		Endif
        	   		
		 			dbSelectArea("XE2")
					dbskip() 
				Enddo       		  
        EndIf      
 

 			      	
    		If Acumulado > Mvalor
	    		Mvalor := Acumulado
	        Endif

    Endif
    
dbSelectArea("XE1")
dbskip() 
endDo	
	XE1->(DBCLOSEAREA())
	XE2->(DBCLOSEAREA())

Return(Mvalor)
                                                             