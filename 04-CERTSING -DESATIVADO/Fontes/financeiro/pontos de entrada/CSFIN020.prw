#include 'totvs.ch'
#INCLUDE "FINR850.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE VALORPAGO 	3
Static lFWCodFil := FindFunction("FWCodFil")

//---------------------------------------------------------------------------------
// Rotina | CSFIN020  | Autor | Rafael Beghini            | Data | 03/08/2015
//---------------------------------------------------------------------------------
// Descr. | Rotina Sispag - Relat�rio para verificar o arquivo de retorno
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function CSFIN020()
	Local oReport
	oReport := ReportDef()
	oReport:PrintDialog()
Return

//---------------------------------------------------------------------------------
// Rotina | ReportDef  | Autor | Rafael Beghini            | Data | 03/08/2015
//---------------------------------------------------------------------------------
// Descr. | Rotina Sispag - Relat�rio para verificar o arquivo de retorno
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function ReportDef()
	Local oReport
	Local oSection1
	Local oSection2
	Local cReport   := "FINR850"          //Nome do relatorio
	Local cDescri   := STR0001 + " " + ; //"Este programa tem como objetivo imprimir o arquivo"
	                   STR0002 +;		//"Retorno da Comunica��o Banc�ria SISPAG, conforme"
	                   STR0003    		//"layout previamente configurado"
	Local cTitulo   := OemToAnsi(STR0004) 	//"Impressao do Retorno do SISPAG "
	Local cPerg     := "FIN850"					// Nome do grupo de perguntas
	
	Private lAchouTit:= .T.
	Private cNumtit  := ""
	
	//������������������������������������Ŀ
	//� Verifica as perguntas selecionadas �
	//��������������������������������������
	Pergunte("FIN850",.F.)
	
	
	oReport := TReport():New(cReport, cTitulo, cPerg, {|oReport| ReportPrint(oReport)}, cDescri) 
	
	oReport:SetPortrait()	//Imprime o relatorio no formato retrato
	
	//Secao 01
	oSection1 := TRSection():New(oReport, STR0035, "SE2")
	
	TRCell():New(oSection1, "PREFIXO", "SE2" , STR0028 ,PesqPict("SE2","E2_PREFIXO"), TamSX3("E2_PREFIXO")[1] ,/*lPixel*/,{ || SE2->E2_PREFIXO } )	//"PRF"
	TRCell():New(oSection1, "NUM"  	 , "SE2" , STR0029 ,PesqPict("SE2","E2_NUM")	 	, 10                       ,/*lPixel*/,{ || SE2->E2_NUM }  )	//"TITULO"
	TRCell():New(oSection1, "PARCELA", "SE2" , STR0030 ,PesqPict("SE2","E2_PARCELA"), TamSX3("E2_PARCELA")[1] ,/*lPixel*/,{ || SE2->E2_PARCELA } )	//"PC"
	TRCell():New(oSection1, "TIPO"   , "SE2" , STR0031 ,PesqPict("SE2","E2_TIPO")	, TamSX3("E2_TIPO")[1] 	   ,/*lPixel*/,{ || SE2->E2_TIPO 	 } )	//"TP"
	TRCell():New(oSection1, "FORNECE", "SE2" , STR0032 ,PesqPict("SE2","E2_FORNECE"), TamSX3("E2_FORNECE")[1] ,/*lPixel*/,{ || SE2->E2_FORNECE } )	//"FORNECEDOR"
	TRCell():New(oSection1, "VALOR"  , ""    , STR0033 , TM(0,13)  , 13 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")		//"VALOR"
	TRCell():New(oSection1, "OCORR"  , ""    , STR0034 ,/*Picture*/, 30 ,/*lPixel*/,/*CodeBlock*/)		//"OCORRENCIA"
	oSection1:SetNoFilter("SE2")
	
	//Secao 02
	oSection2 := TRSection():New(oSection1, STR0036, "")
	
	TRCell():New(oSection2, "TXTSTR"  , "" , STR0025 ,/*Picture*/, 32 ,/*lPixel*/,/*CodeBlock*/)	//"Totais do Relatorio"
	TRCell():New(oSection2, "TOTVLR"  , "" , STR0033 ,TM(0,13)   , 13 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")	//"VALOR"
	
	oSection2:SetHeaderSection(.F.)	//Nao imprime o cabe�alho da secao
	oSection2:SetNoFilter("")
Return oReport

//---------------------------------------------------------------------------------
// Rotina | ReportPrint  | Autor | Rafael Beghini            | Data | 03/08/2015
//---------------------------------------------------------------------------------
// Descr. | Rotina Sispag - Relat�rio para verificar o arquivo de retorno
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1) 
	Local oSection2 := oReport:Section(1):Section(1) 
	
	Local aHeadA  	:= {}, aHead1 := {}, aHead2   := {}
	Local aDetA   	:= {}, aDetB  := {}, aDetJ    := {}
	Local aTraiA  	:= {}, aTrai1 := {}, aTrai2   := {}
	Local nBytes  	:= 0 , nTamArq := 0 , nLidos  := 0
	Local cArqConf	:= "", cArqEnt := "", nHdlConf := 0
	Local xBuffer 	:= "", cTabela := "", cRegistro:= "", cRetorno := ""
	Local cSegmento   := "", cValpag := "", nRectit  := 0
	Local aDetN       := {}
	Local aDetO       := {}
	Local nTamTit 	:= TamSX3("E2_PREFIXO")[1]+TamSX3("E2_NUM")[1]+TamSX3("E2_PARCELA")[1]+;
							TamSX3("E2_TIPO")[1]+TamSX3("E2_FORNECE")[1]
	Local nAscan 	 := 0
	Local cTabRej  := GetMv("MV_TABREJ",,"")
	Local nValt 	 := 0      
	Local aCntOco  := {}     
	Local nX 		 := 0
	Local cDesc1 	 := "DATA" 
	Local cDesc2 	 := "PRINCIPAL"     
	Local cDesc3 	 := "MULTA"
	Local cDesc4 	 := "JUROS"			
	Local lDataGrv := .F.      
	Local lDifPag  := GetNewPar("MV_DIFPAG",.F.)
	Local lRejet   := .T.
	Local cDescRej := ""
	Local lPaMov   := .F.
	Local cKeySE5  := ""
	Local lNewIndice := FaVerInd()  //Verifica a existencia dos indices de IDCNAB sem filial
	Local nTamPre	:= TamSX3("E2_PREFIXO")[1]
	Local nTamNum	:= TamSX3("E2_NUM")[1] 
	Local lGestao	:= Iif( lFWCodFil, FWSizeFilial() > 2, .F. )	// Indica se usa Gestao Corporativa
	
	//��������������������������������������������������������������Ŀ
	//� Definicoes das secoes.			                                �
	//����������������������������������������������������������������
	oSection1:Cell("VALOR"):SetBlock ( { || nvalpag } )
	
	//��������������������������������������������������������������Ŀ
	//� Posiciona no Banco indicado                                  �
	//����������������������������������������������������������������
	SA6->(dbSeek(xFilial("SA6")+mv_par03+mv_par04+mv_par05))
	
	//��������������������������������������������������������������Ŀ
	//� Verifica configuracao Remota                                 �
	//����������������������������������������������������������������
	If !SEE->(dbSeek(xFilial("SEE")+mv_par03+mv_par04+mv_par05+mv_par06))
		Help(" ",1,"PAR150")
		Return .F.
	Endif
	
	//���������������������������������������Ŀ
	//� Verifica se a tabela existe           �
	//�����������������������������������������
	cTabela := Iif( Empty(SEE->EE_TABELA), "17" , SEE->EE_TABELA )
	If !SX5->(dbSeek(cFilial+cTabela))
		Help(" ",1,"PAR150")
		Return .F.
	Endif
	
	//��������������������������������Ŀ
	//� Leitura da Configuracao SISPAG �
	//����������������������������������
	cArqConf := alltrim(mv_par02)
	If !FILE(cArqConf)
		Help(" ",1,"NOARQPAR")
		Return .F.
	Endif
	nHdlConf := FOPEN(cArqConf,0)
	
	If nHdlConf < 0
		Help(" ",1,"NOARQUIVO",,cArqConf,5,1)
		Return .F.
	Endif
	
	nTamArq := FSEEK(nHdlConf,0,2)
	FSEEK(nHdlConf,0,0)
	xBuffer := Space(85)
	
	//���������������������������������������������������Ŀ
	//� Preenche os arrays de acordo com o Identificador  �
	//�����������������������������������������������������
	While nBytes < nTamArq
	
		FREAD(nHdlConf,@xBuffer,85)
		IF SubStr(xBuffer,1,1) == "A" .or. SubStr(xBuffer,1,1) == Chr(1)
	      AADD(aHeadA,{  SubStr(xBuffer,02,15),;
	                     SubStr(xBuffer,17,03),;
	                     SubStr(xBuffer,20,03),;
	                     SubStr(xBuffer,23,01),;
	                     SubStr(xBuffer,24,60)})
		ElseIf SubStr(xBuffer,1,1) == "B" .or. SubStr(xBuffer,1,1) == Chr(2)
			AADD(aHead1,{  SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
								SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
								SubStr(xBuffer,24,60 ) } )
		ElseIf SubStr(xBuffer,1,1) == "C" .or. SubStr(xBuffer,1,1) == Chr(3)
			AADD(aHead2,{  SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
								SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
								SubStr(xBuffer,24,60 ) } )
		Elseif SubStr(xBuffer,1,1) == "D" .or. SubStr(xBuffer,1,1) == Chr(4)
			AADD(aTrai1,{  SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
								SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
								SubStr(xBuffer,24,60) } )
		Elseif SubStr(xBuffer,1,1) == "E" .or. SubStr(xBuffer,1,1) == Chr(5)
			AADD(aTrai2,{  SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
								SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
								SubStr(xBuffer,24,60) } )
		Elseif SubStr(xBuffer,1,1) == "F" .or. SubStr(xBuffer,1,1) == Chr(6)
			AADD(aTraiA,{  SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
								SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
								SubStr(xBuffer,24,60) } )
		Elseif SubStr(xBuffer,1,1) == "G" .or. SubStr(xBuffer,1,1) == Chr(7)
			AADD(aDetA,{   SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
								SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
								SubStr(xBuffer,24,60) } )
		Elseif SubStr(xBuffer,1,1) == "H" .or. SubStr(xBuffer,1,1) == Chr(8)
			AADD(aDetB,{   SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
								SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
								SubStr(xBuffer,24,60) } )
		Elseif SubStr(xBuffer,1,1) == "J" .or. SubStr(xBuffer,1,1) == Chr(10)
			AADD(aDetJ,{   SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
								SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
								SubStr(xBuffer,24,60) } )
		Elseif SubStr(xBuffer,1,1) == "N" .or. SubStr(xBuffer,1,1) == Chr(16)
			AADD(aDetN,{   SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
				SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
				SubStr(xBuffer,24,60) } )
		Elseif SubStr(xBuffer,1,1) == "O" .or. SubStr(xBuffer,1,1) == Chr(17)
			AADD(aDetO,{   SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
				SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
				SubStr(xBuffer,24,60) } )
		Endif
		nBytes += 85
	Enddo
	fclose(nHdlConf)
	
	If Len(aHeadA) == 0  .And. Len(aHead1) == 0 .And. Len(aHead2) == 0 ;
			.And. Len(aTrai1) == 0 .And. Len(aTrai2) == 0 ;
			.And. Len(aDetA)  == 0 .And. Len(aDetB)  == 0 ;
			.And. Len(aDetJ)  == 0 .And. Len(aDetN)  == 0 ;
			.And. Len(aDetO)  == 0
		Help(" ",1,"AX044BCO")
		Return .F.
	Endif
	
	//���������������������������������Ŀ
	//� Abre arquivo enviado pelo banco �
	//�����������������������������������
	cArqEnt := mv_par01
	IF !FILE(cArqEnt)
		Help(" ",1,"NOARQENT")
		Return .F.
	Endif
	nHdlBco := FOPEN(cArqEnt,0)
	If nHdlBco < 0
		Help(" ",1,"NOARQUIVO",,cArqEnt,5,1)
		Return .F.
	Endif
	
	//�������������������������������Ŀ
	//� Le arquivo enviado pelo banco �
	//���������������������������������
	
	nLidos := 0
	nTamArq := FSEEK(nHdlBco,0,2)
	FSEEK(nHdlBco,0,0)
	xBuffer := Space(242)
	
	oReport:SetMeter(nTamArq / Len(xBuffer))
	
	While nLidos <= nTamArq
	
		//�����������������������������Ŀ
		//� Le linha do arquivo retorno �
		//�������������������������������
	
		FREAD(nHdlBco,@xBuffer,242)
		nLidos += 242
	  	oReport:IncMeter()   	
		
		//��������������������������������������Ŀ
		//� Registro:��0 - Header de Arquivo     �
		//�          ����1 - Header de Lote      �
		//�          ��    3 - Detalhes Variados �
		//�          ����5 - Trailler de Lote    �
		//�          ��9 - Trailler de Arquivo   �
		//����������������������������������������
		cRegistro := Subst( xBuffer , Val(aHeada[3,2]) , ;
								    1+Val(aHeada[3,3])-Val(aHeada[3,2]))
	
		IF cRegistro == "0"
			Loop
		Endif
		If cRegistro == "1"
			Loop
		Endif
		//�������������������������������������������������������������������������Ŀ
		//� Retornos: 00-Credito efetuado BD-Pagamento Agendado  TA-Lote nao aceito �
		//� Retornos: BE-Pagto Agendado c/Forma Alterada p/ OP   RJ-Pagto Rejeitado �
		//� Header de Lote - verificar se houve rejeicao                            �
		//���������������������������������������������������������������������������
	
		//�������������������������������������������������������������������������Ŀ
		//� Codigos de Rejeicao - TABELA=60                                         �
		//�                                                                         �
		//� AD - Forma de lancamento invalida (Forma X Segmento)                    �
		//� AH - Numero sequencial do registro no lote invalido                     �
		//� AJ - Tipo de movimento invalido                                         �
		//� AL - Codigo do Banco do favorecido ou depositario invalido              �
		//� AM - Agencia do cedente invalido                                        �
		//� AN - Conta corrente do cedente invalido                                 �
		//� AO - Nome do cedente invalido                                           �
		//� AP - Data de lancamento / pagamento invalida                            �
		//� BC - Nosso numero invalido                                              �
		//� IA - Remetente / Motivo invalido                                        �
		//� IB - Valor do titulo invalido                                           �
		//� IC - Valor do abatimento invalido                                       �
		//� ID - Valor do desconto invalido                                         �
		//� IE - Valor da mora invalido                                             �
		//� IF - Valor da multa invalido                                            �
		//� IG - Valor da deducao invalido                                          �
		//� IH - Valor do acrescimo invalido                                        �
		//� II - Data de vecnto invalida                                            �
		//� IJ - Sequencia invalida de segmento                                     �
		//� IK - Codigo de instrucao invalida                                       �
		//� IL - Uso banco invalido para unibanco                                   �
		//� IM - Tipo X Forma nao compativel                                        �
		//� IN - Banco / Agencia nao pertence as pracas de compensacao ITAU         �
		//� IO - Identificacao Tipo de Cheque invalido                              �
		//� IP - Rejeicao do DAC do codigo de barras                                �
		//�                                                                         �
		//���������������������������������������������������������������������������
		If cRegistro == "9"
			//������������������������������������������Ŀ
			//� Final do lote e arquivo - Sai da leitura �
			//��������������������������������������������
			Exit
		Endif
	
		If cRegistro != "3"
			LOOP
		Endif	
	
		//�������������������������������������������������������Ŀ
		//� Segmentos opcionais : B                               �
		//� Obs: Segmentos A e J possuem informacoes sobre o      �
		//� retorno.                                              �
		//���������������������������������������������������������
		cSegmento := Subst( xBuffer , Val(aDeta[5,2]) , 1+Val(aDeta[5,3])-Val(aDeta[5,2]) )
	
		If cSegmento == "A"
			cRetorno   := Subst( xBuffer, Val(aDeta[Len(aDeta),2]) , 1+Val(aDeta[Len(aDeta),3] )-Val(aDeta[Len(aDeta),2]))
			cNumTit    := Subst( xBuffer, Val(aDeta[11,2])         , 1+Val(aDeta[11,3] )-Val(aDeta[11,2]))
			cValPag    := Subst( xBuffer, Val(aDeta[15,2])         , 1+Val(aDeta[15,3] )-Val(aDeta[15,2]))
		ElseIf cSegmento == "J"
			cRetorno   := Subst( xBuffer, Val(aDetJ[Len(aDetJ),2]) , 1+Val(aDetJ[Len(aDetJ),3])-Val(aDetJ[Len(aDetJ),2]))
			cNumTit    := Subst( xBuffer, Val(aDetJ[20,2])         , 1+Val(aDetJ[20,3] )-Val(aDetJ[20,2]))
			cValPag    := Subst( xBuffer, Val(aDetJ[18,2])         , 1+Val(aDetJ[18,3] )-Val(aDetJ[18,2]))
		ElseIf cSegmento == "N"
			If !lDifPag
				cRetorno := Subst( xBuffer, Val(aDetN[Len(aDetN),2]) , 1+Val(aDetN[Len(aDetN),3])-Val(aDetN[Len(aDetN),2]))
			Else
				nAscan := Ascan(aDetN, {|e| AllTrim(Upper(e[1]))=="OCORRENCIAS"})                                                 
				If nAscan > 0
					cRetorno    := Subst( xBuffer, Val(aDetN[nAscan,2])         , 1+Val(aDetN[nAscan,3] )-Val(aDetN[nAscan,2]))		
				Else	
					ApMsgAlert(STR0026+ "OCORRENCIAS" + STR0027) //"Por favor, indique no registro detalhe do arquivo de configura��o segmento N, no nome do campo, o identificador OCORRENCIAS utilizado para localizar, no arquivo retorno, o valor dos campos.")
				EndIf
			EndIf
			
			// Procura a posicao do numero do titulo
			nAscan := Ascan(aDetN, {|e| AllTrim(Upper(e[1]))=="SEU NUMERO"})                                                 
			If nAscan > 0
				cNumTit    := Subst( xBuffer, Val(aDetN[nAscan,2])         , 1+Val(aDetN[nAscan,3] )-Val(aDetN[nAscan,2]))		
			Else	
				ApMsgAlert(STR0017) //"Por favor, indique no registro detalhe do arquivo de configura��o segmento N, no nome do campo, o identificador "SEU NUMERO" utilizado para localizar, no arquivo retorno,o t�tulo a ser baixado.") 
			EndIf
			
			//Retorno contem configuracao de campos de acordo com o tipo do tributo
			If lDifPag 
				//Verifico o tipo do imposto para saber qual posicao do array
				//contem as posicoes dos campos com os dados do tributo
				cTipoImp := Substr( xBuffer,Val(aDetN[07,2])         , 1+Val(aDetN[07,3] )-Val(aDetN[07,2]))		   
			   Do Case
					Case cTipoImp == "01"		// 01 - GPS
						cDesc1 := "DATA GPS" 
						cDesc2 := "PRINCIPAL GPS"     
						cDesc3 := "MULTA GPS"
						cDesc4 := "JUROS GPS"			
					Case cTipoImp == "02"		//02 - DARF
						cDesc1 := "DATA DARF"
						cDesc2 := "PRINCIPAL DARF"     
						cDesc3 := "MULTA DARF"
						cDesc4 := "JUROS DARF"
					Case cTipoImp == "03"	//03 - DARF Simples
						cDesc1 := "DATA SIMPLES"
						cDesc2 := "PRINC. SIMPLES"	
						cDesc3 := "MULTA SIMPLES"
						cDesc4 := "JUROS SIMPLES"
					Case cTipoImp == "04"	//04 - DARJ 
						cDesc1 := "DATA DARJ"
						cDesc2 := "PRINCIPAL DARJ"			
						cDesc3 := "MULTA DARJ"
						cDesc4 := "JUROS DARJ"
					Case cTipoImp == "05"	//05 - ICMS SP
						cDesc1 := "DATA ICMS"
						cDesc2 := "PRINCIPAL ICMS"			
						cDesc3 := "MULTA ICMS"
						cDesc4 := "JUROS ICMS"
					Case cTipoImp $ "07#08"	//07 - IPVA (SP e MG), 08 - DPVAT
						cDesc1 := "DATA IPVA"
						cDesc2 := "PRINCIPAL IPVA"			
						cDesc3 := "MULTA IPVA"
						cDesc4 := "JUROS IPVA"
					Case cTipoImp $ "11"	//11 - FGTS
						cDesc1 := "DATA FGTS"
						cDesc2 := "PRINCIPAL FGTS"								
				EndCase
			Else
				nPos := Ascan(aDetN, {|e| AllTrim(Upper(e[1]))=="DATA"})
				If nPos <= 0
					cTipoImp := Substr( xBuffer,Val(aDetN[07,2])         , 1+Val(aDetN[07,3] )-Val(aDetN[07,2]))		
					If cTipoImp == "01"			//GPS
						nPos := 15
					ElseIf cTipoImp == "02"		//DARF
						nPos := 18			
					ElseIf cTipoImp $ "03#04#05"	//03 - DARF Simples, 04 - DARJ e 05 - ICMS SP
						nPos := 20			
					Endif
				Else
					If Type("cTipoImp")== "U"
						cTipoImp := ""	
					EndIf
				Endif			
				//Verifico o tipo do imposto para saber qual posicao do array
				//contem as posicoes das datas de baixa.
				cData      := Substr( xBuffer,Val(aDetN[nPos,2])         , 1+Val(aDetN[nPos,3] )-Val(aDetN[nPos,2]))
				cData      := ChangDate(cData,SEE->EE_TIPODAT)
				dBaixa     := Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5),"ddmm"+Replicate("y",Len(Substr(cData,5))))
				lDataGrv   := .T.	   
		   	EndIF
			
			// Procura a posicao da data do tributo		
			If !lDataGrv .And. lDifPag 
				nAscan := Ascan(aDetN, {|e| AllTrim(Upper(e[1]))==cDesc1})
				If nAscan > 0
					cData := Substr( xBuffer, Val(aDetN[nAscan,2])         , 1+Val(aDetN[nAscan,3] )-Val(aDetN[nAscan,2]))
					cData      := ChangDate(cData,SEE->EE_TIPODAT)
					dBaixa     := Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5),"ddmm"+Replicate("y",Len(Substr(cData,5))))
				Else
					ApMsgAlert(STR0026+ cDesc1 + STR0027) //"Por favor, indique no registro detalhe do arquivo de configura��o segmento N, no nome do campo, o identificador "+ cDesc1 +" utilizado para localizar, no arquivo retorno, o valor da multa.")
				Endif	
			EndIf
		
			// Procura a posicao do valor principal do tributo		
			nAscan := Ascan(aDetN, {|e| AllTrim(Upper(e[1]))==cDesc2})
			If nAscan > 0
				cValPag    := Subst( xBuffer, Val(aDetN[nAscan,2])         , 1+Val(aDetN[nAscan,3] )-Val(aDetN[nAscan,2]))
			Else
				ApMsgAlert(STR0026+ cDesc2 + STR0027) //"Por favor, indique no registro detalhe do arquivo de configura��o segmento N, no nome do campo, o identificador "+ cDesc2 +" utilizado para localizar, no arquivo retorno, o valor da multa.")
			Endif	
	
			// Procura a posicao da multa do tributo
			nAscan := Ascan(aDetN, {|e| AllTrim(Upper(e[1]))==cDesc3})
			If cTipoImp $ "11" //FGTS
				nMulta := 0
			ElseIf nAscan > 0
				nMulta := Round(Val(Subst( xBuffer, Val(aDetN[nAscan,2])         , 1+Val(aDetN[nAscan,3] )-Val(aDetN[nAscan,2])))/100,2)
			Else
				ApMsgAlert(STR0026+ cDesc3 + STR0027) //"Por favor, indique no registro detalhe do arquivo de configura��o segmento N, no nome do campo, o identificador "+ cDesc3 +" utilizado para localizar, no arquivo retorno, o valor da multa.")
			Endif	
	
			// Procura a posicao do juros do tributo
			nAscan := Ascan(aDetN, {|e| AllTrim(Upper(e[1]))==cDesc4})
			If cTipoImp $ "11" //FGTS
				nJuros := 0
			ElseIf nAscan > 0
				cValJur    := Subst( xBuffer, Val(aDetN[nAscan,2])         , 1+Val(aDetN[nAscan,3] )-Val(aDetN[nAscan,2]))
				nJuros	  := Val(cValJur)/100       
			Else
				ApMsgAlert(STR0026+ cDesc4 + STR0027) //"Por favor, indique no registro detalhe do arquivo de configura��o segmento N, no nome do campo, o identificador "+ cDesc4 +" utilizado para localizar, no arquivo retorno, o valor da multa.")
			Endif	  
		ElseIf cSegmento == "O"
			cRetorno   := Subst( xBuffer, Val(aDetO[Len(aDetO),2]) , 1+Val(aDetO[Len(aDetO),3])-Val(aDetO[Len(aDetO),2]))
			cNumTit    := Subst( xBuffer, Val(aDetO[16,2])         , 1+Val(aDetO[16,3] )-Val(aDetO[16,2]))
			cValPag    := Subst( xBuffer, Val(aDetO[14,2])         , 1+Val(aDetO[14,3] )-Val(aDetO[14,2]))
		Else
			Loop
		Endif
	
		nvalpag := val(cvalpag)/100
		
		//Totalizador Geral do Arquivo de Retorno	
		nValT  += nValPag
	
		//���������������������������������������������������������������Ŀ
		//� Verifica se existe o titulo no SE2.                           �
		//�����������������������������������������������������������������
		dbSelectArea("SE2")
		lAchouTit := .T.
	
		If lNewIndice .and. !Empty( Iif( lGestao, FWFilial("SE2"), xFilial("SE2") ) )
			//Busca por IdCnab (sem filial)
			nRecTit := Recno()
			SE2->(dbSetOrder(13)) // IdCnab
			If SE2->(MsSeek(Substr(cNumTit,1,10)))
				cFilAnt	:= SE2->E2_FILIAL
			Endif
			mv_par09	:= 2  //Desligo contabilizacao on-line				
		Else
			//Busca por IdCnab
			nRecTit := Recno()
			SE2->(dbSetOrder(11)) // Filial+IdCnab
			SE2->(MsSeek(xFilial("SE2")+	Substr(cNumTit,1,10)))
		Endif
	
		//Se nao achou, utiliza metodo antigo (titulo)
		If SE2->(!Found())
			//Busca pela chave antiga como retornado pelo banco
			dbSetOrder(1)
			If !dbSeek(xFilial("SE2")+Pad(cNumTit,nTamTit))
				// Busca por chave antiga adaptada para o tamanho de 9 posicoes para numero de NF
		   	// Isto ocorre quando titulo foi enviado com 6 posicoes para numero de NF e retornou com o
		   	// campo ja atualizado para 9 posicoes
				cNumTit := SubStr(cNumTit,1,nTamPre)+Padr(Substr(cNumTit,4,6),nTamNum)+SubStr(cNumTit,10)
				If !dbSeek(xFilial("SE2")+Pad(cNumTit,nTamTit))
					lAchouTit := .F.	
				Endif
	      Endif
		Endif	      
	
		//Verifico existencia de movimento anterior (arquivo reprocessado)
		lPaMov = .F.
		dbSelectArea("SE5")
		SE5->(DBSETORDER(2))  //E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO                   
		cKeySe5 := xFilial("SE5")+IIF(SE2->E2_TIPO $ MVPAGANT,"PA","TX")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA)
		cKeySe5 += IIF(SE2->E2_TIPO $ MVPAGANT,"PA ","TXA")
		If SE5->(MsSeek(cKeySe5))
			While !SE5->(EOF()) .and. SE5->(E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO) == cKeySe5
				If SE2->(E2_FORNECE+E2_LOJA) == SE5->(E5_CLIFOR+E5_LOJA)
					lPaMov = .T. 
					Exit
				Else
					SE5->(dbSkip())
				Endif
			Enddo
		Endif
		dbSelectArea("SE2")
	
	   oSection1:Init()
	
		//���������������������������������������������������������������Ŀ
		//� Trata os titulos rejeitados e nao encontrados.                �
		//�����������������������������������������������������������������
		If "00" $ cRetorno
			//���������������������Ŀ
			//� 00-Credito efetuado �
			//�����������������������
			//���������������������������������������������������������������Ŀ
			//� Verifica se existe o titulo no SE2.                           �
			//�����������������������������������������������������������������
			If !lAchouTit
				oSection1:Cell("PREFIXO"):Hide()
				oSection1:Cell("NUM"):SetBlock ( { || cNumtit } )	         
				oSection1:Cell("PARCELA"):Hide()
				oSection1:Cell("TIPO"):Hide()
				oSection1:Cell("FORNECE"):Hide()
				oSection1:Cell("VALOR"):SetBlock ( { || nValPag } ) 
				oSection1:Cell("OCORR"):SetBlock ( { || OemToAnsi(STR0009) } )		//"TITULO NAO ENCONTRADO"
			   oSection1:PrintLine()
				//Totaliza Ocorrencia
				TotOcorr (cRetorno,STR0021,nValPag,aCntOco)	//"Titulos nao encontrados"
				oSection1:Cell("PREFIXO"):Show()
				oSection1:Cell("PARCELA"):Show()
				oSection1:Cell("TIPO"):Show()
				oSection1:Cell("FORNECE"):Show()
	
				dbGoTo(nRecTit)
				Loop
			ElseIf SE2->E2_SALDO == 0
				oSection1:Cell("OCORR"):SetBlock ( { || OemToAnsi(STR0011) } )	//"TITULO JA BAIXADO"
			   oSection1:PrintLine()
				//Totaliza Ocorrencia
				TotOcorr (cRetorno,STR0022,nValPag,aCntOco) //"Titulos ja baixados"
				dbGoTo(nRecTit)
				Loop
			ElseIf lPaMov .and. SE2->E2_TIPO $ MVPAGANT+"#"+MVTXA
				oSection1:Cell("OCORR"):SetBlock ( { || OemToAnsi(STR0037) } )	//"PA JA DEBITADO"
			   oSection1:PrintLine()
				//Totaliza Ocorrencia
				TotOcorr (cRetorno,STR0037,nValPag,aCntOco) //"PA ja Debitado"
				dbGoTo(nRecTit)
				Loop			
			Endif
			//�������������������������������Ŀ
			//� Verifica c�digo da ocorrencia �
			//���������������������������������
			dbSelectArea("SEB")
			dbSeek(xFilial("SEB")+mv_par03+Padr(Substr(cRetorno,1,3),3)+"P")
			If !LEFT(SEB->EB_OCORR,2) $ "06/07/08"  //Baixa do Titulo
				oSection1:Cell("OCORR"):SetBlock ( { || OemToAnsi(STR0008) } )	//"OCORRENCIA NAO ENCONTRADA"
			   oSection1:PrintLine()
				//Totaliza Ocorrencia
				TotOcorr (cRetorno,STR0008 ,nValPag,aCntOco) //"Ocorrencia nao encontrada"
				Loop
			Else
	
				nJuros		:= If(Type("nJuros") != "N"	,0,nJuros	)
				nMulta		:= IF(Type("nMulta") != "N"	,0,nMulta	)
				nDescont		:= If(Type("nDescont") != "N",0,nDescont	)
	
				nValPadrao := nValPag-(nJuros+nMulta-nDescont)
				nTotAbat	:= SumAbatPag(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_FORNECE,SE2->E2_MOEDA,"S",dDatabase,SE2->E2_LOJA)
				If Round(NoRound((SE2->E2_SALDO-nTotAbat),3),2) < Round(NoRound(nValPadrao,3),2)
					oSection1:Cell("OCORR"):SetBlock ( { || STR0038} ) //"VLR PAGO MAIOR"
				   oSection1:PrintLine()
					//Totaliza Ocorrencia
					TotOcorr (cRetorno,"",nValPag,aCntOco)
				ElseIf Round(NoRound((SE2->E2_SALDO-nTotAbat),3),2) > Round(NoRound(nValPadrao,3),2)
					oSection1:Cell("OCORR"):SetBlock ( { || STR0039} ) //"VLR PAGO MENOR"
				   oSection1:PrintLine()
					//Totaliza Ocorrencia
					TotOcorr (cRetorno,"",nValPag,aCntOco)
				Else
					oSection1:Cell("OCORR"):SetBlock ( { || OemToAnsi(STR0010)} )			//"TITULO OK"
				   oSection1:PrintLine()
					//Totaliza Ocorrencia
					TotOcorr (cRetorno,"",nValPag,aCntOco) 
				Endif
			EndIf	
	
		ElseIf ("BD" $ cRetorno) 
			//�����������������������Ŀ
			//� BD-Pagamento Agendado �
			//�������������������������
			oSection1:Cell("OCORR"):SetBlock ( { || STR0015 } )	//"PAGAMENTO AGENDADO"
		   oSection1:PrintLine()
			TotOcorr (cRetorno,STR0015,nValPag,aCntOco) //"PAGAMENTO AGENDADO"
		ElseIf ("BE" $ cRetorno) 
			//������������������������������������������Ŀ
			//� BE-Pagto Agendado c/Forma Alterada p/ OP �
			//��������������������������������������������
			oSection1:Cell("OCORR"):SetBlock ( { || STR0016 } )	//"PGTO AGENDADO ALTER. P/ OP"  
		   oSection1:PrintLine()
			TotOcorr (cRetorno,STR0016,nValPag,aCntOco) //"PGTO AGENDADO ALTER. P/ OP"
		Elseif !Empty(cTabRej)
	
				lRejet := .T.
				FOR nX := 1 to Len(Alltrim(cRetorno)) Step 2
					cDescRej := Left(Tabela(cTabRej,Substr(cRetorno,nX,2),.F.),30)
					If Empty(cDescRej) 
						cDescRej := STR0008
					EndIf
		  		Next
				  
			If lAchoutit
			   		oSection1:Cell("OCORR"):SetBlock ( { || cDescRej } )	//Imprime o conteudo da tabela de rejeicoes	
			  		oSection1:PrintLine()
			   		TotOcorr(cRetorno,cDescRej,nValPag,aCntOco)//Imprime o conteudo da tabela de rejeicoes     
			  	Else     
					oSection1:Cell("PREFIXO"):Hide()
					oSection1:Cell("NUM"):SetBlock ( { || cNumtit } )	         
					oSection1:Cell("PARCELA"):Hide()
					oSection1:Cell("TIPO"):Hide()
					oSection1:Cell("FORNECE"):Hide()
					oSection1:Cell("VALOR"):SetBlock ( { || nValPag } )
					oSection1:Cell("OCORR"):SetBlock ( { || OemToAnsi(STR0009) } )		//"TITULO NAO ENCONTRADO"
				    oSection1:PrintLine()
					//Totaliza Ocorrencia
					TotOcorr (cRetorno,STR0021,nValPag,aCntOco)	//"Titulos nao encontrados"
					oSection1:Cell("PREFIXO"):Show()
					oSection1:Cell("PARCELA"):Show()
					oSection1:Cell("TIPO"):Show()
					oSection1:Cell("FORNECE"):Show()
				Endif     
				Loop
		Else        
			    If lAchoutit
			   		dbSelectArea("SEB")
			  		dbSeek(xFilial("SEB")+mv_par03+Padr(Substr(cRetorno,1,3),3)+"P")
			  		cDescRej:= SEB->EB_DESCRI
		   	   		oSection1:Cell("OCORR"):SetBlock ( { || cDescRej } )	//Imprime o conteudo da tabela de rejeicoes	
			  		oSection1:PrintLine()
			   		TotOcorr(cRetorno,cDescRej,nValPag,aCntOco)//Imprime o conteudo da tabela de rejeicoes     
			  		cDescRej:="" 
				Else     
					oSection1:Cell("PREFIXO"):Hide()
					oSection1:Cell("NUM"):SetBlock ( { || cNumtit } )	         
					oSection1:Cell("PARCELA"):Hide()
					oSection1:Cell("TIPO"):Hide()
					oSection1:Cell("FORNECE"):Hide()
					oSection1:Cell("VALOR"):SetBlock ( { || nValPag } )
					oSection1:Cell("OCORR"):SetBlock ( { || OemToAnsi(STR0009) } )		//"TITULO NAO ENCONTRADO"
				    oSection1:PrintLine()
					//Totaliza Ocorrencia
					TotOcorr (cRetorno,STR0021,nValPag,aCntOco)	//"Titulos nao encontrados"
					oSection1:Cell("PREFIXO"):Show()
					oSection1:Cell("PARCELA"):Show()
					oSection1:Cell("TIPO"):Show()
					oSection1:Cell("FORNECE"):Show()
				
				Endif
		Endif
	
	Enddo
	
	oSection1:Finish()
	
	//�����������������������������������Ŀ
	//� Imprime Subtotais por ocorrencia  �
	//�������������������������������������
	oReport:SkipLine()
	oReport:SkipLine()
	oReport:PrintText(OemToAnsi(STR0024))	//"SubTotais do Relatorio"
	
	For nX :=1 to Len(aCntOco)         
		oSection2:Init()
		oSection2:Cell("TXTSTR"):SetBlock ( { || AllTrim(aCntOco[nX][1]) + " - " + Substr(aCntOco[nX][2],1,30) } )
		oSection2:Cell("TOTVLR"):SetBlock ( { || aCntOco[nX][VALORPAGO] } )
		oSection2:PrintLine()
	Next
	
	oSection2:Finish()
	
	//�������������������������������Ŀ
	//� Imprime Totais                �
	//���������������������������������
	oSection2:Init()
	oSection2:Cell("TXTSTR"):SetBlock ( { || OemToAnsi(STR0025) } )
	oSection2:Cell("TOTVLR"):SetBlock ( { || nValT } )
	oSection2:PrintLine()
	oSection2:Finish()
	
	//�������������������������Ŀ
	//� Fecha os Arquivos ASCII �
	//���������������������������
	FCLOSE(nHdlBco)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �TotOcorr  �Autor  �Ricardo A. Canteras � Data �  05/10/2005 ���
�������������������������������������������������������������������������͹��
���Desc.     �Acumula o valor pago por ocorrencia		                    ���
�������������������������������������������������������������������������͹��
���Uso       �FINR850                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function TotOcorr(cOcorr,cDescr,nValPag,aCntOco)
	Local aArea := GetArea()
	Local nCntOco := 0
	Default cDescr:=""                          
	//�������������������������������Ŀ
	//� Verifica codigo da ocorrencia �
	//���������������������������������
	dbSelectArea("SEB")
	
	//�����������������������������������������������Ŀ
	//� Efetua contagem dos SubTotais por ocorrencia  �
	//�������������������������������������������������    
	If (dbSeek(xFilial("SEB")+mv_par03+Pad(cOcorr,TamSX3("EB_REFBAN")[1])+"P"))
		nCntOco := Ascan(aCntOco, { |X| X[1] == SEB->EB_OCORR})	
		If nCntOco == 0
			Aadd(aCntOco,{SEB->EB_OCORR,Subs(SEB->EB_DESCRI,1,27),nValPAG})
		Else                                         
			aCntOco[nCntOco][VALORPAGO]+=nValPag
		Endif                     
	Else
		nCntOco := Ascan(aCntOco, { |X| X[1] == Pad(cOcorr,Len(SEB->EB_OCORR))})
		If nCntOco == 0
			Aadd(aCntOco,{Pad(cOcorr,Len(SEB->EB_OCORR)),Subs(cDescr,1,27),nValPAG})
		Else                                         
			aCntOco[nCntOco][VALORPAGO]+=nValPag
		Endif
	Endif
	
	RestArea (aArea)
Return 