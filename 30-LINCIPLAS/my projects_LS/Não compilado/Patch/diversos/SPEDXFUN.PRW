#INCLUDE "PROTHEUS.CH"
#INCLUDE "SPEDXFUN.CH"  
#INCLUDE "TOPCONN.CH"
#INCLUDE "SPEDPISCOF.CH"  

//*** ATENCAO!!! Este array aExistBloc deve ser igual nos fontes SPEDFISCAL e SPEDXFUN
STATIC aExistBloc	:= {	ExistBlock("SPDFIS02"),; // 01
							ExistBlock("SPDFIS06"),; // 02
							ExistBlock("SPEDRTMS"),; // 03
							ExistBlock("SPDFIS08"),; // 04
							ExistBlock("SPEDPROD"),; // 05
							ExistBlock("SPEDPTMS"),; // 06 
							ExistBlock("SPED1300"),; // 07 
							ExistBlock("SPED1390"),; // 08
							ExistBlock("SPEDREGD"),; // 09
							ExistBlock("SPDFIS001"),;// 10
							ExistBlock("SPDFIS05"),; // 11	
							ExistBlock("SPDFIS04"),; // 12	
							ExistBlock("SPEDR450"),; // 13	
							ExistBlock("SPEDR460"),; // 14
							ExistBlock("SPEDG126"),; // 15
							ExistBlock("SPDFIS07"),; // 16
							ExistBlock("SPDFIS10",.T.,.T.),; // 17
							ExistBlock("SPDPISIC"),; // 18 
							ExistBlock("SPDFIS09"),; // 19
							ExistBlock("SPED0205")}  // 20

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³InfPartDoc| Autor ³Gustavo G. Rueda              ³ Data ³03.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ATRIBUICAO DOS DADOS DO PARTICIPANTE NO ARRAY                      ³±±
±±³          ³                                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ExpN1 := InfPartDoc(cAlsSA,dDataDe,dDataAte,cAliasSFT,lCadParti)   ³±±
±±³          ³                                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±         
±±³Parametros|cAlsSA -> Alias da tabela SA1, SA2 ou SA4.                         ³±±
±±³          |dDataDe -> Data inicial para utilizar os dados cadastrais do       ³±±
±±³          | periodo de processamento.                                         ³±±
±±³          |dDataAte -> Data final  para utilizar os dados cadastrais do       ³±±
±±³          | periodo de processamento.                                         ³±±
±±³          |cAliasSFT -> Alias da query com join quando houver                 ³±±
±±³          |lCadParti -> Flag de existencia do PE SPDFIS06                     ³±±
±±³          |aHistSA   -> Array com os historicos de alteracoes do SA1/SA2      ³±±
±±³          |lHistTab  ->                                                       ³±±
±±³          |lExtratTAF-> Indica se foi chamado pelo Extrator TAF               ³±±
±±ÃÄÄÄÄÄÄÄÄÄ ÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpA1 - Array com as informacoes do participante do documento      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function InfPartDoc(cAlsSA,dDataDe,dDataAte,cAliasSFT,lCadParti,aHistSA,lHistTab,lExtratTAF)

Local	aA1A2		:=	{}
Local	cA1A2		:=	SubStr (cAlsSA, 3, 1)
Local	cCodMun		:=	""
Local	cCmpCod		:=	""
Local	cCmpLoja	:=	""
Local	cCmpNome	:=	""
Local	cCmpTipo	:=	""
Local	cCmpCgc		:=	""                            
Local	cCmpEst		:=	""
Local	cCmpInsc	:=	""
Local	cCmpCodM	:=	""
Local	cCmpEnd		:=	""
Local	cCmpBairro	:=	""
Local	cCmpCdPais	:=	""
Local	cCmpSuframa	:=	""
Local 	cCmpInscM	:= 	""
Local	cCmpPessoa	:=	""
Local	cContCampo	:=	""
Local	nX			:=	0
Local	aMod		:= {}
Local	aPart	    := {}
Local	lTop 		:= .F.
Local 	lConcFil	:= SuperGetMv("MV_COFLSPD",.F.,.T.)
Local 	cInscricao	:= "" 
Local	lInscPar	:= SuperGetMv("MV_INSCPAR",.F.,.T.)

Default cAliasSFT	:=	""     
Default lHistTab	:=	SuperGetMv("MV_HISTTAB",,.F.) .And. AliasIndic("AIF")
Default lExtratTAF  := .F.

#IFDEF TOP
	If TcSrvType() <> "AS/400"
		lTop 	:= .T.		
	Endif
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para quando jah vier por parametro, com isso evito³
//³  de chamar a funcao novamente                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lHistTab	:=	Iif(aHistSA==Nil,lHistTab,.F.)
aMod		:=	Iif(aHistSA==Nil,aMod,aHistSA)

//Tratamento para utilizar os campos do SELECT quando for TOP ao inves de posicionar a tabela
If lTop .And. !Empty(cAliasSFT)
	cAlsCorr	:=	cAliasSFT
Else
	cAlsCorr	:=	cAlsSA
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Campos do cadastro a serem considerados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCmpCod		:=	cAlsCorr+"->A"+cA1A2+"_COD"
cCmpLoja	:=	cAlsCorr+"->A"+cA1A2+"_LOJA"
cCmpNome	:=	cAlsCorr+"->A"+cA1A2+"_NOME"
cCmpTipo	:=	cAlsCorr+"->A"+cA1A2+Iif ("2"$cA1A2, "_TIPO", "_PESSOA")
cCmpCgc		:=	cAlsCorr+"->A"+cA1A2+"_CGC"
cCmpEst		:=	cAlsCorr+"->A"+cA1A2+"_EST"
cCmpInsc	:= IIF(cA1A2=="4",cAlsCorr+"->A"+cA1A2+"_INSEST" ,cAlsCorr+"->A"+cA1A2+"_INSCR")
cCmpCodM	:=	cAlsCorr+"->A"+cA1A2+"_COD_MUN"
cCmpEnd		:=	cAlsCorr+"->A"+cA1A2+"_END"
cCmpBairro	:=	cAlsCorr+"->A"+cA1A2+"_BAIRRO"
cCmpCdPais	:=	Iif(&(cAlsSA)->(FieldPos("A"+cA1A2+"_CODPAIS")) > 0,cAlsCorr+"->A"+cA1A2+"_CODPAIS","")
cCmpSuframa	:=	Iif(&(cAlsSA)->(FieldPos("A"+cA1A2+"_SUFRAMA")) > 0,cAlsCorr+"->A"+cA1A2+"_SUFRAMA","")
cCmpInscM	:= 	cAlsCorr+"->A"+cA1A2+"_INSCRM"
cCmpPessoa	:= 	cAlsCorr+"->A"+cA1A2+"_PESSOA"

IF	lInscPar
	cInscricao:= RetCmpHist(cCmpInsc,aMod,dDataAte)
EndIf
If cAlsSA == "SA4"

	If lHistTab .And. dDataDe<>Nil
		aMod 	:= MsConHist(cAlsSA,,,dDataDe,,,&(cCmpCod))
	EndIf

	aAdd (aA1A2, "SA4"+Iif(lConcFil,cFilAnt,"")+(cAlsCorr)->A4_COD+cInscricao)						   		//01	-	COD_PART
	
	cContCampo 	:= RetCmpHist(cCmpNome,aMod,dDataAte)														
	aAdd (aA1A2, cContCampo)																			  		//02	-	NOME

	If !Empty(cCmpCdPais)
		cContCampo 	:= RetCmpHist(cCmpCdPais,aMod,dDataAte)
		aAdd (aA1A2, AllTrim(cContCampo))																 	 	//03	-	COD_PAIS
	Else                                                                                                 	
		aAdd (aA1A2, "01058")				  															 		//03	-	COD_PAIS
	EndIf

	aAdd (aA1A2, "")																		  			 		//04	-	CNPJ
	aAdd (aA1A2, "")																			 		 		//05	-	CPF
	aAdd (aA1A2, "")																			 				//06	-	IE
	aAdd (aA1A2, "")																			  				//07	-	COD_MUN
	aAdd (aA1A2, "")																			  		  		//08	-	Inscricao SUFRAMA
	//                                                                                                      	
	If "01058" $ aA1A2[3]
		cContCampo 	:= RetCmpHist(cCmpCgc,aMod,dDataAte)
		If Len(AllTrim(cContCampo))>=14 .And. &(cCmpEst)<>"EX"
			aA1A2[04] :=  SPEDConType(SPEDVldIE(cContCampo,,.F.))									   	   		//04	-	CNPJ

		ElseIf Len(AllTrim(cContCampo))<14 .And. &(cCmpEst)<>"EX"
			aA1A2[05] := SPEDConType(SPEDVldIE(cContCampo,,.F.))											   	//05	-	CPF
		EndIf
		
		aA1A2[06] := SPEDConType(SPEDVldIE((cAlsCorr)->A4_INSEST))											  	//06	-	IE
		
		If SA4->(FieldPos("A4_COD_MUN"))>0
			//Tratamento para o codigo de municipio, se nao possuir o codigo do estado, tenho de colocar
			cContCampo 	:= RetCmpHist(cCmpCodM,aMod,dDataAte)
			If Upper((cAlsCorr)->A4_EST) == "EX"
				aA1A2[07]	:=	"9999999"																  	 	//07	-	COD_MUN
				                                                                                         	
			ElseIf Len(Alltrim(cContCampo))<=5
				aA1A2[07]	:=	UfCodIBGE((cAlsCorr)->A4_EST)+Alltrim(cContCampo)						 		//07	-	COD_MUN
			Else
				aA1A2[07]	:=	Alltrim(cContCampo)														 		//07	-	COD_MUN
			EndIf			
		EndIf
		
		If SA4->(FieldPos("A4_SUFRAMA"))>0
			cContCampo 	:= RetCmpHist(cCmpSuframa,aMod,dDataAte)
			aA1A2[08] := SPEDConType(cContCampo)																//08    -   SUFRAMA
		EndIf
	Else
		aA1A2[07] := "9999999"
	EndIf

	cContCampo 	:= RetCmpHist(cCmpEnd,aMod,dDataAte)
	aEnd	:=	MyGetEnd(cContCampo,cAlsSA,cAlsCorr)		
	aAdd (aA1A2, SPEDConType(aEnd[1]))											 								//09	-	END
	aAdd (aA1A2, Iif (!Empty(aEnd[2]),aEnd[3],"SN"))	 												  		//10	-	NUM
	aAdd (aA1A2, SPEDConType(aEnd[4])) 	 																		//11	-	COMPL
	cContCampo 	:= RetCmpHist(cCmpBairro,aMod,dDataAte)
	aAdd (aA1A2, SPEDConType(cContCampo))														  				//12	-	BAIRRO

	aAdd (aA1A2, (cAlsCorr)->A4_EST)														  					//13	-	UF
	aAdd (aA1A2, "")																  							//14	-	InscMun
Else

	If lHistTab .And. dDataDe<>Nil
		aMod 	:= MsConHist(cAlsSA,&(cCmpCod),&(cCmpLoja),dDataDe)
	EndIf

	If !lExtratTAF
   		aAdd (aA1A2, cAlsSA+Iif(lConcFil,cFilAnt,"")+&(cCmpCod)+&(cCmpLoja)+cInscricao) 							//01	-	COD_PART
	Else
		aAdd (aA1A2, cAlsSA+&(cCmpCod))																				//01	-	COD_PART
	EndIf

	cContCampo 	:= RetCmpHist(cCmpNome,aMod,dDataAte)														
	aAdd (aA1A2, cContCampo)        		 																	//02	-	NOME
	
	If !Empty(cCmpCdPais)
		cContCampo 	:= RetCmpHist(cCmpCdPais,aMod,dDataAte)
		aAdd(aA1A2,cContCampo)																					//03	-	COD_PAIS
	Else                                                                                                 	
		aAdd (aA1A2, "01058")				  															 		//03	-	COD_PAIS
	EndIf
	
	//No cadastro do cliente quem determina se o cliente é uma pessoa fisica ou juridica
	//seria o campo A1_PESSOA, no caso do Fornecedor seria o campo A2_TIPO.
	cContCampo 	:= RetCmpHist(cCmpCgc,aMod,dDataAte)
	If cAlsSA=="SA1"
		aAdd (aA1A2, IIF(&(cCmpPessoa)=="J" .And. (cAlsCorr)->A1_TIPO <>"X",SPEDConType(SPEDVldIE(cContCampo,,.F.)),""))			//04	-	CNPJ
		aAdd (aA1A2, IIF(&(cCmpPessoa)=="F" .And. (cAlsCorr)->A1_TIPO <>"X",SPEDConType(SPEDVldIE(cContCampo,,.F.)),""))			//05	-	CPF
	Else
		aAdd (aA1A2, IIF(&(cCmpTipo)=="J",SPEDConType(SPEDVldIE(cContCampo,,.F.)),""))	 	  				//04	-	CNPJ
		aAdd (aA1A2, IIF(&(cCmpTipo)=="F",SPEDConType(SPEDVldIE(cContCampo,,.F.)),""))	 	 				//05	-	CPF
	Endif
	
	cContCampo 	:= RetCmpHist(cCmpInsc,aMod,dDataAte)
	aAdd(aA1A2, SPEDConType(SPEDVldIE(cContCampo)))															//06	-	IE
	
	If !"01058"$aA1A2[3] .And. AllTrim(aA1A2[3])<>""
		aAdd (aA1A2, "9999999")																				   	//07	-	COD_MUN
	Else
		//Tratamento para o codigo de municipio, se nao possuir o codigo do estado, tenho de colocar
		cContCampo 	:= RetCmpHist(cCmpCodM,aMod,dDataAte)
		If Len(Alltrim(cContCampo))<=5
			aAdd (aA1A2, UfCodIBGE(&(cCmpEst))+Alltrim(cContCampo))											//07	-	COD_MUN
			//Se possuir, considero como esta, desde que o estado nao seja "EX"
		Else
			aAdd (aA1A2, Iif (Upper(&(cCmpEst)) == "EX","9999999", cContCampo))								//07	-	COD_MUN
		EndIf
	EndIf
	
	cContCampo 	:= RetCmpHist(cCmpSuframa,aMod,dDataAte)
	aAdd (aA1A2,cContCampo)																						//08	-	SUFRAMA

	cContCampo 	:= RetCmpHist(cCmpEnd,aMod,dDataAte)
	aEnd		:=	MyGetEnd(cContCampo,cAlsSA,cAlsCorr)		
	aAdd (aA1A2, SPEDConType(aEnd[1]))										  									//09	-	END
	aAdd (aA1A2, Iif (!Empty(aEnd[2]),aEnd[3],"SN")) 											            	//10	-	NUM
 	aAdd (aA1A2, SPEDConType(aEnd[4]))                                                                         	//11	-	COMPL                               	
	//Ponto de entrada para gerar informacoes do endereco e numero. 
	If lCadParti
	 	aPart := ExecBlock("SPDFIS06", .F., .F., {cAlsSA}) 
		aA1A2[09] := aPart[01]
		aA1A2[10] := aPart[02]
	Endif	
	cContCampo 	:= RetCmpHist(cCmpBairro,aMod,dDataAte)
	aAdd (aA1A2,cContCampo)																						//12	-	BAIRRO

	aAdd (aA1A2, &(cCmpEst))													   					   			//13	-	UF
	aAdd (aA1A2, &(cCmpInscM))																		   			//14	-	InscMun
EndIf
Return (aA1A2)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³RetCmpHist| Autor ³Gustavo G. Rueda 			   ³ Data ³02.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Funcao que retorna uma informacao de um campo conforme data de     ³±±
±±³          ³ alteracao do controle de historico de alteracoes.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ExpC1 := RetCmpHist(cPar1,aPar2,dPar3,lPar4)                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cPar1 - Campo a ser avaliado o conteudo.                          ³±±
±±³          ³ aPar2 - Array retornado pela funcao MsConHist com as informacoes  ³±±
±±³          ³         sobre a alteracao.                                        ³±±
±±³          ³         [1]: Campo que sofreu alteracao                           ³±±
±±³          ³         [2]: Conteudo do campo antes da alteracao                 ³±±
±±³          ³         [3]: Data da alteracao                                    ³±±
±±³          ³         [4]: Hora da alteracao                                    ³±±
±±³          ³ dPar3 - Data base para analise da informacao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpC1 - Informacao a ser processada                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function RetCmpHist(cCmp,aMod,dData)
Local	cRet		:=	""
Local	nX			:=	0
Local	lMVSPEDHIS		:=	GetNewPar("MV_SPEDHIS", .F.)	//NAO DIVULGAR - Parametro criado para contornar o historica cadastral caso haja urgente.

For nX := 1 To Len(aMod)
	If aMod[nX,3]>dData .And. AllTrim(aMod[nX,1])$cCmp
		cRet	:=	aMod[nX][2]
		Exit	
	EndIf
Next nX
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se for vazio o cadastro de historico, retorno o proprio campo passado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (Empty(cRet) .And. !Empty(cCmp)) .Or. lMVSPEDHIS
	cRet	:=	&(cCmp)
EndIf
Return cRet
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |SPEDSitDoc| Autor ³Gustavo G. Rueda              ³ Data ³03.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³SITUACAO DO DOCUMENTO FISCAL                                       ³±±
±±³          ³                                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ExpN1 := SPEDSitDoc (cAliasSFT)                                    ³±±
±±³          ³                                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³cSituaDoc -> Situacao do documento                                 ³±±
±±³          ³ onde:                                                             ³±±
±±³          ³ 00=Normal                                                         ³±±
±±³          ³ 02=Cancelado                                                      ³±±
±±³          ³ 04=Uso Denegado                                                   ³±±
±±³          ³ 05=Inutilizacao                                                   ³±±
±±³          ³ 06=Complemento                                                    ³±±
±±³          ³ 08=Regime especial ou norma especifica                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|NaoUsar   -> Nao utilizar este parametro, pois trata-se de uma com-³±±
±±³          ³             patibilidade com outras chamadas desta funcao         ³±±
±±³          ³cAliasSFT -> Alias da tabela SFT filtrada e posicionada            ³±±
±±³          ³             na funcao principal                                   ³±±
±±³          ³cAliasSA  -> Alias da tabela SA1 ou SA2, filtrada e posicionada    ³±±
±±³          ³             na funcao principal                                   ³±±
±±³          ³cCmpSimpN -> Indica se o cliente ou fornecedor é optante pelo      ³±±
±±³          ³             Simples Nacional.                                     ³±±
±±³          ³dDataDe   -> Data inicial do período de geração do arquivo         ³±±
±±³          ³             informada ma wizard pelo usuário.                     ³±±
±±³          ³dDataAte  -> Data final  do período de geração do arquivo          ³±±
±±³          ³             informada ma wizard pelo usuário.                     ³±± 
±±³          ³lRegEsp   -> Verifica se ( MV_ESTADO $ MV_UFRESPD) Assim, deve     ³±±
±±³          ³             considerar como Regime Especial os clientes/fornec.   ³±±
±±³          ³             optantes pelo Simples Nacional (A?_SIMPNAC)==1        ³±±
±±³          ³lSitDocCDT-> Situação do Documento extemporânea                    ³±±
±±³          ³cSitExt	-> Campo da tabela CDT(CDT_SITEXT)que identifica a       ³±± 
±±³          ³			   opção da escrituração extemporânea.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPEDSitDoc(NaoUsar,cAliasSFT,cAliasSA,cCmpSimpN,dDataDe,dDataAte,lRegEsp,lSitDocCDT,cSitExt,cAliasSF3)
Local	cSituaDoc	:=	""
Local 	dDtCanc   	:= 	(cAliasSFT)->FT_DTCANC	
Local	cOriglan	:=  "" 
Local	cModNot		:= AModNot((cAliasSFT)->FT_ESPECIE)

Default dDataDe		:= Ctod("  /  /    ")
Default dDataAte 	:= Ctod("  /  /    ")   
Default lRegEsp	 	:= .F. 
Default lSitDocCDT  := .F. 
Default cSitExt     := ""
Default cAliasSF3 	:= "SF3"
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posicionamento realizado para encontrar os itens das Notas Fiscais ³
//³ de Frete incluidas atraves da rotina MATA116.                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SD1")			
SD1->(dbSetOrder(1))
	If SD1->(MsSeek(xFilial("SD1")+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA+(cAliasSFT)->FT_PRODUTO+(cAliasSFT)->FT_ITEM))		
		cOriglan := SD1->D1_ORIGLAN
	EndIf

//Situacao da NF
If lSitDocCDT .And. cSitExt == "P" .And. (cAliasSFT)->FT_TIPOMOV =="E" .And.;
   ((cAliasSFT)->FT_TIPO$"ICP") .And. !cOriglan$"FR|F |FD"
	cSituaDoc	:=	"07"	//Escrituração extemporânea de documento complementar
elseIf ((cAliasSFT)->FT_TIPO$"ICP") .And. !cOriglan$"FR|F |FD"
	cSituaDoc	:=	"06"	//Complemento de IPI, Complemento de ICMS, Complemento de Preco e Beneficiamento			
EndIf

If !(Empty (dDtCanc))                                    		
	// Como o cancelamento de NF-e pode ser feito apenas até 24 horas após a emissão, 
	// não precisaremos fazer o controle da data de cancelamento para depois gerar ajuste.
	If !(Alltrim(cModNot)=="55") .And. !Empty(dDataDe) .And. !Empty(dDataAte)
		If dDtCanc >= dDataDe .And. dDtCanc <= dDataAte
			cSituaDoc	:=	"02"
		Else
			cSituaDoc	:=	"00"
		EndIf
	Else
		cSituaDoc	:=	"02"	//Cancelado
	EndIf
Elseif Empty(cSituaDoc)
	If lSitDocCDT .And. cSitExt == "R" .And. (cAliasSFT)->FT_TIPOMOV =="E"
		cSituaDoc	:=	"01"	//Escrituração extemporânea de documento regular    		
	Else
		cSituaDoc	:=	"00"	//Normal
	EndIf		
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para notas fiscais eletronicas³    			
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
If SF3->(FieldPos("F3_CODRSEF"))<>0 .And. !Empty((cAliasSF3)->F3_CODRSEF)

	//NFe - Uso denegado
	If Alltrim((cAliasSF3)->F3_CODRSEF) $ XFUNCodSef({"D"})
		cSituaDoc := "04"
		
	//NFe - Numeracao Inutilizada
	ElseIf Alltrim((cAliasSF3)->F3_CODRSEF) $ XFUNCodSef({"I"})
		cSituaDoc := "05"	
	EndIf
EndIf
            
If !(Alltrim(cSituaDoc)$"02|04|05")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Campo do livro fiscal que determina Regime Especial ou Norma Especifica para ST ou CIAP.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ((cAliasSFT)->(FieldPos("FT_RGESPST"))>0 .And. (cAliasSFT)->FT_RGESPST=="1") .Or. ((cAliasSFT)->(FieldPos("F4_RGESPCI"))>0 .And. (cAliasSFT)->F4_RGESPCI=="1")
		cSituaDoc := "08"
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Considera como Reg. Especial se o cliente/fornecedor for optante pelo Simples Nacional  ³
	//³e ( MV_ESTADO $ MV_UFRESPD ) -> (lRegEsp)                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cAliasSA<>Nil .AND. (cAliasSA)->(&(cCmpSimpN))=="1" .AND. lRegEsp
		cSituaDoc := "08"
	EndIF
	              
	
	If ((cAliasSFT)->(FieldPos("FT_NORESP"))>0 .And. (cAliasSFT)->FT_NORESP=="1")
		cSituaDoc := "08"
	Endif   
	
	IF ((cAliasSFT)->(FieldPos("FT_SERIE"))>0 .And.(cAliasSFT)->FT_SERIE >= "890" .And.(cAliasSFT)->FT_SERIE <="899" )
		cSituaDoc := "08"
	Endif
		
	If ((cAliasSFT)->FT_TIPO == "C" .And. (AllTrim((cAliasSFT)->FT_ESPECIE) == "NFS" .Or. AllTrim((cAliasSFT)->FT_ESPECIE) == "RPS"))
		cSituaDoc := "00"	
	EndIf
EndIf

 Return cSituaDoc
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |GrvRegTrS ³ Autor ³Gustavo G. Rueda       ³ Data ³16.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³              GRAVACAO DO REGISTRO NO TRB                   ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Gravacao do registro passado como parametro (aReg) no TRB   ³±±
±±³          ³ que sera posteiormente lido e gerado o TXT.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAlias -> Alias do TRB gerado na funcao principal           ³±±
±±³          ³nRelac -> Codigo de indicacao de relacionamento com outros  ³±±
±±³          ³ registros.                                                 ³±±
±±³          ³aReg -> Registro a ser gravado no TRB.                      ³±±
±±³          ³nItem -> Identificador de itens para um mesmo relacionamento³±±
±±³          ³nFlag -> Flag de controle de grupo que antecede o           ³±±
±±³          ³ relacionamento entre registros. Ex:                        ³±±
±±³          ³ Se o FLAG nao for passado o codigo fica ...2...2, se for   ³±±
±±³          ³ passado por exemplo 3, o codigo fiscal ...3...2            ³±±
±±³          ³l4Casas -> Indica se a funcao devera formatar com 4 casas os³±±
±±³          ³ campos definidos neste formato segundo o layout.           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function GrvRegTrS(cAlias,nRelac,aReg,nItem,nFlag,l4Casas)
Local	nX			:=	0
Local	lRet		:=	.T.
Local	cDelimit	:=	"|"
Local	nZ			:=	0
Local	cLinha		:=	"" 
Local	cReg		:=	""
Local	nTamTRBIt	:=	Len((cAlias)->TRB_RELAC)/2	//Efetuo divisao por dois porque faco dois controles em um mesmo campo. O relacionamento e sequencia. Ex: ...0001...1, ...0001...2
Local	cRegNoGr	:=  SuperGetMv("MV_REGSPED",.F.,"")		//Parametro para identificar quais registros nao devem ser gerados pelo SPEDFISCAL
Local 	llDecim		:= .F.  
Local 	llDecim3	:= .F.  

Default	nRelac	:=	0
Default	nFlag	:=	Nil
Default l4Casas	:= .F.

If nFlag==Nil
	cFlag	:=	Iif(Valtype(nRelac)=="N",StrZero (nRelac, nTamTRBIt, 0),nRelac)
Else
	cFlag	:=	StrZero (nFlag, nTamTRBIt, 0)
EndIf

For nZ := 1 To Len (aReg)
	cLinha	:=	cDelimit
	//Monto cLinha para gravar no TRB
	For nX := 1 To Len (aReg[nZ])

		llDecim	 := .F.
		llDecim3 := .F.
		
		// Se for para formatar campos com 4 casas decimais na função SPDGet4Dec
		IF l4Casas 
			llDecim  := SPDGet4Dec(aReg[nZ,1],nX) 
			llDecim3 := SPDGet3Dec(aReg[nZ,1],nX) 								
		EndIF
		
		If (ValType (aReg[nZ][nX])="A")
			cLinha	+=	RetStr (aReg[nZ][nX][1], aReg[nZ][nX][2])+cDelimit
		Else
			cLinha	+=	RetStr (aReg[nZ][nX],Iif(llDecim,4,If(llDecim3,3,NIL)))+cDelimit
		EndIf
	Next (nX)   
		 
	cReg := SubStr (cLinha, 2, 4)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Conteudo do parametro MV_REGSPED para identificar quais registros nao devem ser gerados pelo SPEDFISCAL³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (cReg$cRegNoGr)
		Return (lRet)
	EndIf
	
	//Tratamento para nao permitir gerar uma string maior que o tamanho do campo TRB_CONT. Se acontecer, somente serah no registro 0450.
	If Len(cLinha)>Len((cAlias)->TRB_CONT)
		cLinha	:=	AllTrim(Left(cLinha,Len((cAlias)->TRB_CONT)-1))+cDelimit
	EndIf
	//
	//Monto TRB
	RecLock (cAlias, .T.)
		(cAlias)->TRB_TPREG		:=	cReg
		(cAlias)->TRB_RELAC		:=	cFlag+Iif(Valtype(nRelac)=="N",StrZero (nRelac, nTamTRBIt, 0),nRelac)
		(cAlias)->TRB_CONT		:=	cLinha
		(cAlias)->TRB_ITEM		:=	nItem
	MsUnLock ()
Next nZ
Return(lRet)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |SPEDSitFrt| Autor ³Gustavo G. Rueda              ³ Data ³03.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Define o Tipo de Frete do Documento Fiscal conforme os pedidos caso³±±
±±³          ³ existam                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ExpN1 := SPEDSitFrt(cAliasSFT,cAlsSD,lTop)                         ³±±
±±³          ³                                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Retorna o Tipo de Frete,onde:                                      ³±±
±±³          ³ 9 - Sem Frete                                                     ³±±
±±³          ³ 2 - Emitente                                                      ³±±
±±³          ³ Para frete 0-Terceiro e 1-Destinatario nao ha informacoes         ³±±
±±³          ³ e o retorno padrao iremos definir que toda NFS ou NFE nao         ³±± 
±±³          ³ possui Frete                                                      ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAliasSFT -> Alias da tabela SFT filtrada e posicionada            ³±±
±±³          ³             na funcao principal                                   ³±±
±±³          ³cAlsSD    -> Alias da tabela SD1 ou SD2 caso nao seja utilizado    ³±±
±±³          ³             query                                                 ³±±
±±³          ³lTop      -> Flag que indica se estah utilizando TOP ou nao        ³±±
±±³          ³cAlsSF    -> Alias da tabela SF1 ou SF2 caso nao seja utilizado    ³±±
±±³          ³             query                                                 ³±±
±±³          ³cCmpFrete -> Conteudo do campo F1_FRETE                            ³±±
±±³          ³lAchSFSD  -> Flag de posicionamento das tabelas SF? e SD?          ³±±
±±³          ³lJOIN     -> Variavel lJOIN determina se quando TOP as tabelas que ³±±
±±³          ³             serao utilizadas (SFT, SD? e SF?) estao no mesmo JOIN ³±±       
±±³          ³lF1TpFrete-> FiledPos do campo F1_TPFRETE                          ³±±  
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL / SPEDPISCOF                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPEDSitFrt(cAliasSFT,cAlsSD,lTop,cAlsSF,cCmpFrete,lAchSFSD,lJOIN,lF1TpFrete)
Local 	cSitFrt		:=	"9"	//Definir por Padrao Nota Fiscal sem Frete
Local	cChvSeek	:=	""
Local	cAlsCorr	:=	"" 
Local 	lNewIndic	:=  ((cAliasSFT)->FT_EMISSAO >= CtoD("01/01/2012"))   

Default	lF1TpFrete 	:= SF1->(FieldPos("F1_TPFRETE"))>0                                                             	
Default	lAchSFSD	:=	.T.
Default	lJOIN		:=	.T.     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Como as informacoes abaixo sao utilizadas da tabela SF?/SD?, a mesma precisa estar posicionada.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lAchSFSD
                                    
	//Tratamento para utilizar os campos Co SELECT quando for TOP ao inves de posicionar a tabela
	If lTop .And. lJOIN		//Variavel lJOIN determina se quando TOP as tabelas que serao utilizadas (SFT, SD? e SF?) estao no mesmo JOIN
		cAlsCorr	:=	cAliasSFT
		cAlsSF		:=	cAliasSFT
	Else
		cAlsCorr	:=	cAlsSD	
	EndIf
	
    If (cAliasSFT)->FT_TIPOMOV=="E"	.And. !Empty((cAlsCorr)->(D1_PEDIDO+D1_ITEM))
		cChvSeek	:=	xFilial("SC7")+(cAlsCorr)->(D1_PEDIDO+D1_ITEM)  

		//C-CIF - Por conta do emitente
		If lF1TpFrete .And. (cAlsSF)->F1_TPFRETE=="C"
    			cSitFrt		:=	Iif(lNewIndic,"0","1")
		
		//F-FOB - Por conta do destinatario
		ElseIf lF1TpFrete .And. (cAlsSF)->F1_TPFRETE=="F"
	    		cSitFrt		:=	Iif(lNewIndic,"1","2")	
 		
 		//T-Por Conta Terceiros
 		ElseIf lF1TpFrete .And. (cAlsSF)->F1_TPFRETE=="T"
	    	cSitFrt		:=	Iif(lNewIndic,"2","0") 	    	

		//S-Sem Frete
		ElseIf lF1TpFrete .And. (cAlsSF)->F1_TPFRETE=="S"
	    	cSitFrt		:=	Iif(lNewIndic,"9","0") 	    		
		
	 	//Se nao encontrar na SF1 pega a informacao da SC7
	 	ElseIf  SC7->(MsSeek(cChvSeek))   
   			//Sem Frete			
    		If Empty(SC7->C7_TPFRETE)
    			cSitFrt	:=	"9"                                             	
    			
    		//Por conta do emitente
    		ElseIf Alltrim(SC7->C7_TPFRETE)=="C"
    			cSitFrt	:=	Iif(lNewIndic,"0","1") 
    			
    		//Por conta do destinatario
    		ElseIf Alltrim(SC7->C7_TPFRETE)=="F"
    			cSitFrt	:=	Iif(lNewIndic,"1","2") 
    			
    		//Por conta de terceiros
    		ElseIf Alltrim(SC7->C7_TPFRETE)=="T"
    			cSitFrt	:= Iif(lNewIndic,"2","0") 
    		EndIf	
	    				
	   	//Caso tenha Valor de Frete
	   	ElseIf (cAlsSF)->(&(cCmpFrete))>0
   			cSitFrt		:=	"2"							
		Endif	
    
	ElseIf (cAliasSFT)->FT_TIPOMOV=="S" .And. !Empty((cAlsCorr)->D2_PEDIDO)
		SC5->(dbSetOrder(1))
		cChvSeek := xFilial("SC5")+Alltrim((cAlsCorr)->D2_PEDIDO)
		If 	SC5->(MsSeek(cChvSeek))
		
			//Sem Frete		
			If Empty(SC5->C5_TPFRETE) .or. Alltrim(SC5->C5_TPFRETE)== "S"
				cSitFrt	:= "9" 
				
			//Frete por conta Emitente	
			ElseIf Alltrim(SC5->C5_TPFRETE)=="C" 
				cSitFrt	:=	Iif(lNewIndic,"0","1")
				
			//Frete por conta do destinatario  
			ElseIf Alltrim(SC5->C5_TPFRETE)=="F"
			 	cSitFrt	:=	Iif(lNewIndic,"1","2")
			 	
			//Frete por conta de Terceiros			
			ElseIf Alltrim(SC5->C5_TPFRETE)=="T"
			 	cSitFrt	:=	Iif(lNewIndic,"2","0") 
			EndIf 	
		Endif
	Endif
EndIf
Return cSitFrt    
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |GrRegDep  ³ Autor ³Gustavo G. Rueda       ³ Data ³16.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³              GRAVO REGISTROS DEPENDENTES                   ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Suponhamos o cabecalho e os itens do documento fiscal, onde ³±±
±±³          ³ o cabecalho eh o pai e os itens eh o filho, portanto tenho ³±±
±±³          ³ varios itens para um pai. Para que esta funcao interprete  ³±±
±±³          ³ este caso, a primeira posicao do registro filho indica a   ³±±
±±³          ³ posicao do registro pai, ou seja, leio a primeira posicao  ³±±
±±³          ³ do array pai e procuro todos os registros itens que possuem³±±
±±³          ³ na primeira posicao a posicao lida do registro pai.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAlias -> Alias do TRB criado atraves da funcao principal.  ³±±
±±³          |aRegPai -> Registro Pai.                                    ³±±
±±³          |aRegFilho -> Registro tipo filho (1:N) Varios para cada Pai.³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function GrRegDep(cAlias,aRegPai,aRegFilho,lRegPaiDup,nRegEcf,lCtdtem,nFlag,lOrdena,cMensagem)
Local	aReg		:=	{}
Local	nCtd		:=	1
Local	nZ			:=	0
Local	nX			:=	0
Local 	bRblSort	:= 	{|x,y|x[1]<y[1]}
Local 	nTamReg1	:= 	0
Local	nRegsProc	:=	0
Local	cTimeDocs	:=	Time()
Local	nDocsXTime	:=	0

DEFAULT lRegPaiDup 	:= .F.
DEFAULT nRegEcf		:=  0
DEFAULT lCtdtem		:=	.T.	//Tratamento para quando se tem mais de uma ocorrencia no subnivel. Ex. Registro 1100, 1105 e 1110
DEFAULT nFlag		:=	Nil
DEFAULT lOrdena		:=	.T.
DEFAULT	cMensagem	:=	""


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Para o C405 precisa acrescentar a posicao 3 (data) no bloco de ordenacao ³
//³ Para o C420 precisa ordenar tambem pela legenda							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nRegEcf == 405
	If Len(aRegFilho) > 0 .AND. Len(aRegFilho[1]) > 0
		nTamReg1 := Len(STR(aRegFilho[1][1]))	// Pega a quantidade total de casas para depois acrescentar zeros
	EndIf	
	bRblSort:= {|x,y| AllTrim( StrZero(x[1],nTamReg1)+DTOS(x[3])) < AllTrim(StrZero(y[1],nTamReg1)+DTOS(y[3])) }
ElseIf nRegEcf == 420
	If Len(aRegFilho) > 0 .AND. Len(aRegFilho[1]) > 0
		nTamReg1 := Len(STR(aRegFilho[1][1]))	// Pega a quantidade total de casas para depois acrescentar zeros
	EndIf
	bRblSort:= {|x,y| AllTrim(StrZero(x[1],nTamReg1)+x[3]) < AllTrim(StrZero(y[1],nTamReg1)+y[3]) }
EndIf	
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se o registro PAI tiver somente 1 item, nao precisa ordenar, pois o filho somente terah ³
//³ um codigo de relacionamento, o que corresponde ao PAI                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lOrdena
	aRegFilho  := Asort(aRegFilho,,,bRblSort)	
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³No caso de o objeto oProcess existir, significa que a nova barra  ³
//³ de processamento (CLASSE Fiscal) estah em uso pela rotina,       |
//| portanto deve ser efetuado os controles para demonstrar o        |
//| resultado do processamento.                                      |
//|                                                                  |
//|O tratamento da nova regua serah efetuada em particular nesta     |
//| funcao, quando o parametro "cMensagem" vier preenchido, pois com |
//| ele identificamos qual gravacao do TRB pode ser realmente        |
//| demorada, caso contrario nao precisa, eh muito rapido            |
//||                                                                 |
//|Definicao do tamanho das reguas e atualizacao dos detalhes de     |
//| processamento, pois como o caso da funcao OrgTxt, este tambem    |
//| deve ser tratado isoladamente do movimento.                      |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cMensagem) .And. Type("oProcess")=="O"
	oProcess:Set1Progress(Len(aRegFilho))

	//Neste caso nao eh necessario o controle da segunda regua, basta somente a primeira
	oProcess:Set2Progress(1)
	oProcess:Inc2Progress("","")

	oProcess:SetDetProgress("Total de registros do periodo solicitado",Len(aRegFilho),;
				"Total de registros processados por segundo",0,;
				"Total de registros pendentes para processamento",0,;
				"Tempo estimado para termino do processamento (Seg.)",0)
EndIf

For nZ := 1 To Len(aRegPai)
	
	If !lRegPaiDup
		GrvRegTrS(cAlias,nZ,{aRegPai[nZ]},,nFlag)
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³nCod e a posicao lida do C420(Cabecalho) que se relaciona com o conteudo da posicao 1 do array c425(Itens)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aRegFilho)>=1  .AND. nCtd <= Len(aRegFilho)
		Do While nCtd<=Len (aRegFilho) .And. (aRegFilho[nCtd][1]==nZ)
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³No caso de o objeto oProcess existir, significa que a nova barra  ³
			//³ de processamento (CLASSE Fiscal) estah em uso pela rotina,       |
			//| portanto deve ser efetuado os controles para demonstrar o        |
			//| resultado do processamento.                                      |
			//|                                                                  |
			//|Incremento da primeira regua, somente a mensagem, pois os numeros |
			//| neste caso nao sao sequenciais e fica confuso a demonstracao em  |
			//| tela.                                                            |
			//|Tambem estah sendo efetuada a atualizacao dos detalhes.           |
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(cMensagem) .And. Type("oProcess")=="O"
				nRegsProc	+=	1		
				oProcess:Inc1Progress("Processamento secundário: Gravando estruturas "+cMensagem,StrZero(nRegsProc,4)+"/"+StrZero(Len(aRegFilho),4))
	
				If cTimeDocs<>Time()
					oProcess:SetDetProgress("Total de registros do periodo solicitado",Len(aRegFilho),;
							"Total de registros processados por segundo",nDocsXTime,;
							"Total de registros pendentes para processamento",Len(aRegFilho)-nRegsProc,;
							"Tempo estimado para termino do processamento (Seg.)",Round((Len(aRegFilho)-nRegsProc)/nDocsXTime,0))
	
					cTimeDocs	:=	Time()
					nDocsXTime	:=	1
				Else
					nDocsXTime	+=	1
				EndIf		
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Controle do cancelamento da rotina³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If oProcess:Cancel()
					Exit
				EndIf
			EndIf
		
			aReg	:=	{}

			For nX := 2 To Len (aRegFilho[nCtd])
				aAdd (aReg, aRegFilho[nCtd][nX])
			Next (nX)

			GrvRegTrS(cAlias,nZ,{aReg},Iif(lCtdtem,nCtd,aRegFilho[nCtd][1]),nFlag)

			nCtd++
		EndDo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³No caso de o objeto oProcess existir, significa que a nova barra  ³
		//³ de processamento (CLASSE Fiscal) estah em uso pela rotina,       |
		//| portanto deve ser efetuado os controles para demonstrar o        |
		//| resultado do processamento.                                      |
		//|                                                                  |
		//|Tratamento para o cancelamento de execucao da rotina              |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(cMensagem) .And. Type("oProcess")=="O" .And. oProcess:Cancel()
			Exit
		EndIf
	EndIf
Next (nZ)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³No caso de o objeto oProcess existir, significa que a nova barra    ³
//³ de processamento (CLASSE Fiscal) estah em uso pela rotina,         |
//| portanto deve ser efetuado os controles para demonstrar o          |
//| resultado do processamento.                                        |
//|                                                                    |
//³Condicao implementada para controlar os numeros apresentadas na tela³
//³  de processamento da rotina, os detalhes.                          ³
//³Ao final do processamento, para este caso da funcao, atualizo altero³
//³  o tratamento de registros lidos, pois a funcao utiliza bastante   |		
//³  a funcao SPDRePorNf e ela nao tem o controle de soma da variavel  ³		
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cMensagem) .And. Type("oProcess")=="O"
	oProcess:SetDetProgress("Total de registros do periodo solicitado",Len(aRegFilho),;
			"Total de registros processados por segundo",nDocsXTime,;
			"Total de registros pendentes para processamento",0,;
			"Tempo estimado para termino do processamento (Seg.)",0)
EndIf		
Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |UfCodIBGE ³ Autor ³Gustavo G. Rueda       ³ Data ³16.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que retorna o codigo da UF do participante, de acordo³±±
±±³          ³com a tabela disponibilizada pelo IBGE.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³cCod -> Codigo da UF                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cUf  -> Sigla da UF do cliente/fornecedor                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function UfCodIBGE(cUf,lForceUF)
Local nX         := 0
Local cRetorno   := ""
Local aUF        := {}

DEFAULT lForceUF := .T.

aadd(aUF,{"RO","11"})
aadd(aUF,{"AC","12"})
aadd(aUF,{"AM","13"})
aadd(aUF,{"RR","14"})
aadd(aUF,{"PA","15"})
aadd(aUF,{"AP","16"})
aadd(aUF,{"TO","17"})
aadd(aUF,{"MA","21"})
aadd(aUF,{"PI","22"})
aadd(aUF,{"CE","23"})
aadd(aUF,{"RN","24"})
aadd(aUF,{"PB","25"})
aadd(aUF,{"PE","26"})
aadd(aUF,{"AL","27"})
aadd(aUF,{"SE","28"})
aadd(aUF,{"BA","29"})
aadd(aUF,{"MG","31"})
aadd(aUF,{"ES","32"})
aadd(aUF,{"RJ","33"})
aadd(aUF,{"SP","35"})
aadd(aUF,{"PR","41"})
aadd(aUF,{"SC","42"})
aadd(aUF,{"RS","43"})
aadd(aUF,{"MS","50"})
aadd(aUF,{"MT","51"})
aadd(aUF,{"GO","52"})
aadd(aUF,{"DF","53"})

If !Empty(cUF)
	nX := aScan(aUF,{|x| x[1] == cUF})
	If nX == 0
		nX := aScan(aUF,{|x| x[2] == cUF})
		If nX <> 0
			cRetorno := aUF[nX][1]
		EndIf
	Else
		cRetorno := aUF[nX][2]
	EndIf
Else
	cRetorno := IIF(lForceUF,"",aUF)
EndIf

Return(cRetorno)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³SPLancCDA ³ Autor ³Gustavo G. Rueda       ³ Data ³04.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que verifica os lancamentos de documentos fiscais    ³±±
±±³          ³ criados durante sua inclusão no sistema de forma manual ou ³±±
±±³          ³ automatica atraves das amarracoes no TES                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Se trata de Function porque eh chamada de outros programas, ³±±
±±³          ³ Exemplo: AUDITFIS.PRW                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1 -> Flag de movimento, .T. = tem movimento e .F. = nao ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAliasSFT -> Alias da tabela SFT posicionada no momento     ³±±
±±³          ³cFlag		-> Variavel nao utilizada pela rotina, mais deve  ³±±
±±³          ³             estar nos parametros da funcao porque ela estah³±±
±±³          ³             sendo utilizada por outros programas neste     ³±±
±±³          ³             formato de chamada                             ³±±
±±³          ³aLanCDA  -> Retorna por referencia os lancamentos encontra- ³±±
±±³          ³             dos para o documento fiscal.                   ³±±
±±³          ³cMVEstado -> Conteudo do paramentro MV_ESTADO               ³±±
±±³          ³lAchouCDT -> Flag de localizacao da tabela CDT              ³±±
±±³          ³cAliasCDT -> Alias da tabela CDT em processamento,TOP ou DBF³±±
±±³			 ³cPartDoc -> Codigo do Participante do documento.			  ³±±
±±³          ³aLanCDA2 -> Retorna por referencia os lancamentos encontra- ³±±
±±³          ³             dos para o documento fiscal. (Totalizador)     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPLancCDA(cAliasSFT,cFlag,aLanCDA,cMVEstado,lAchouCDT,cAliasCDT,cPartDoc,aLanCDA2,lOldLan)
Local 	cFormul		:= 	Iif(Empty((cAliasSFT)->FT_FORMUL),Iif((cAliasSFT)->FT_TIPOMOV == "S","S"," "),(cAliasSFT)->FT_FORMUL)
Local 	cCodPad		:= 	""
Local	cCodAj		:=	""
Local 	cCodLanc	:= 	""
Local 	aLancIt		:= 	{}
Local 	lAntSys		:= 	.T.
Local 	lRet		:= 	.F.
Local 	nX			:= 	0
Local 	cAliasCDA	:=	"CDA"
Local	cAliasCC6	:=	"CC6"
Local	cAliasCDO	:=	"CDO"
Local	aPar		:=	{}
Local	lTop		:=	.F.
Local	cAliasCCE	:=	"CCE"
Local	lForSeek	:=	lAchouCDT==Nil .And. cAliasCDT==Nil
Local	cDescAj		:=	""
Local   cLancVazio  := GetNewPar("MV_CDATPL", "2") //Tratamento para CDA_TPLANC = Vazio. MV_CDATPL: 1 = Apuracao, 2 = Nota, padrao = Nota
Local   cCodObs     := ""
Local   cDesObs     := ""

Default	cFlag		:=	""	//Variavel para manter a compatibilidade com outras chamadas de outros fontes.
Default	lAchouCDT	:=	CDT->(dbSetOrder(1),MsSeek(xFilial("CDT")+(cAliasSFT)->(FT_TIPOMOV+FT_NFISCAL+FT_SERIE+FT_CLIEFOR+FT_LOJA)))
Default	cAliasCDT	:=	"CDT"
Default	cMVEstado	:=	GetMv("MV_ESTADO")   
Default lOldLan		:= 	(AliasIndic("CC6") .And. CC6->(FieldPos("CC6_TIPOAJ"))>0)

dbSelectArea("CDO")
dbSetOrder(1)

If (lAchouCDT .And. !Empty((cAliasCDT)->CDT_IFCOMP)) .Or.;
	(!lAchouCDT .And. CDA->(FieldPos("CDA_IFCOMP"))>0)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Para ambiiente TOP, a query eh um JOIN da CDT eh o mesmo da CCE³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	#IFDEF TOP
		If TcSrvType()<>"AS/400"
			lTop  		:=	.T.
			
			If !lForSeek .And. lAchouCDT	//lForSeek eh tratamento legado, para forcar quando chamado de outra funcao, fazer o SEEK na CCE. Ex: AUDITFIS
				cAliasCCE	:=	cAliasCDT
			EndIf
		EndIf
	#ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posicionamento da tabela CCE caso não seja TOP, pois TOP eh feito um JOIN na query³
	//|                                                                                  |
	//|lForSeek eh tratamento legado, para forcar quando chamado de outra funcao, fazer o|
	//|  SEEK na CCE. Ex: AUDITFIS                                                       |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lAchouCDT .And. (!lTop .Or. lForSeek)
		CCE->(MsSeek(xFilial("CCE")+(cAliasCDT)->CDT_IFCOMP))
	EndIf
	
	aAdd(aPar,(cAliasSFT)->FT_TIPOMOV)
	aAdd(aPar,(cAliasSFT)->FT_ESPECIE)
	aAdd(aPar,cFormul)
	aAdd(aPar,(cAliasSFT)->FT_NFISCAL)
	aAdd(aPar,(cAliasSFT)->FT_SERIE)
	aAdd(aPar,(cAliasSFT)->FT_CLIEFOR)
	aAdd(aPar,(cAliasSFT)->FT_LOJA)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query que sera utilizada para montar os lancamentos provenientes do       ³
	//| documento fiscal, sendo eles:                                            |
	//³CDO - Lancamento de Apuracao                                              ³
	//³CC6 - Lancamento de Notas Fiscais                                         ³
	//³A SPEDFILTRO retorna um JOIN do lancamento com a CC6 e/ou CDO dependendo  ³
	//| do campo CDA_TPLANC.                                                     |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SPEDFFiltro(1,"CDA",@cAliasCDA,aPar)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Para ambiiente TOP, a query eh um JOIN da CDA com a CC6 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lTop	.And. !lForSeek
			cAliasCC6	:=	cAliasCDA
			cAliasCDO	:=	cAliasCDA
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se o campo existir na base e for ambiente TOP, a tabela CCE serah³
			//³  um JOIN na query.                                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If CDA->(FieldPos("CDA_IFCOMP"))>0 .And. !Empty((cAliasCDA)->CDA_IFCOMP)
				cAliasCCE	:=	cAliasCDA
			EndIf
		EndIf

		lRet 	:= .T.
		aLancIt	:= {}
		lAntSys	:= .T.
		
		While !(cAliasCDA)->(Eof())	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Validacao de Tipo de Lancamento A = Apuracao e N = Notas Fiscais. ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If CDA->(FieldPos("CDA_TPLANC"))>0 .And. ( (cAliasCDA)->CDA_TPLANC == '1' .Or. ( (cAliasCDA)->CDA_TPLANC == ' ' .And. cLancVazio == "1" ) )

				If lTop .Or. (cAliasCDO)->(MsSeek(xFilial("CDO")+AllTrim((cAliasCDA)->CDA_CODLAN)))
			     	AADD(aLanCDA2,{AllTrim((cAliasCDA)->CDA_CODLAN),;		//01
							(cAliasCDO)->CDO_DESCR,;          				//02
							(cAliasCDA)->CDA_BASE,;        					//03
							(cAliasCDA)->CDA_ALIQ,;        					//04
							If (SubStr(cCodLanc,3,1) == "9", 0,(cAliasCDA)->CDA_VALOR),;	//05
							If (SubStr(cCodLanc,3,1) == "9", (cAliasCDA)->CDA_VALOR,0),;  //06
							"",;		 				  					//07
							(cAliasCDA)->CDA_ESPECIE,;     					//08
							(cAliasCDA)->CDA_SERIE,;       					//09
							(cAliasCDA)->CDA_NUMERO,;      					//10
							(cAliasCDA)->CDA_TPMOVI,;      					//11
							(cAliasCDA)->CDA_CODLAN,;      					//12
							"",;                           					//13
							(cAliasCDA)->CDA_NUMITE,;      					//14
							cPartDoc,;					   					//15
			       		    (cAliasSFT)->FT_ENTRADA})						//16
			    EndIf
			Else
				//Quando encontrado lancamento de usuario deve desconsiderar os lancamentos de sistema
				If (cAliasCDA)->CDA_CALPRO == "2" .And. lAntSys
					aLancIt	:= {}
					lAntSys	:= .F.
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³lForSeek eh tratamento legado, para forcar quando chamado de outra funcao, fazer o SEEK na CCE. Ex: AUDITFIS³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lForSeek
					(cAliasCC6)->(MsSeek(xFilial("CC6")+AllTrim((cAliasCDA)->CDA_CODLAN)))
				EndIf
				
				If lTop .Or. (cAliasCC6)->(MsSeek(xFilial("CC6")+AllTrim((cAliasCDA)->CDA_CODLAN)))
				
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Implementacao do novo tratamento para o codigo de lancamento fiscal do documento    |
					//|  atraves da amarracao de lancamento de apuracao no TES.                            ³
					//³Sem este tratamento, considera-se o formato antigo, onde somente 1 por documento era³
					//³  utilizado para gerar o C195.                                                      ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If CDA->(FieldPos("CDA_IFCOMP"))>0 .And. !Empty((cAliasCDA)->CDA_IFCOMP)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Posicionamento da tabela CCE caso não seja TOP, pois TOP eh feito um JOIN na query³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If !lTop
							CCE->(MsSeek(xFilial("CCE")+(cAliasCDA)->CDA_IFCOMP))
						EndIf
						cCodObs 	:= (cAliasCCE)->CCE_COD
						cDesObs     := (cAliasCCE)->CCE_DESCR
					ElseIf lAchouCDT
						cCodObs 	:= (cAliasCDT)->CDT_IFCOMP
						CCE->(MsSeek(xFilial("CCE")+cCodObs))  
						cDesObs     := CCE->CCE_DESCR
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Monto o codigo de lancamento no formato antigo, a primeira criada logo no inicio do sped fiscal³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lOldLan
						If (cAliasCC6)->CC6_TIPOAJ=="1"
							If CC6->(FieldPos("CC6_STUF"))>0 .And. !Empty((cAliasCC6)->CC6_STUF)
								cCodLanc += (cAliasCC6)->CC6_STUF
							Else
								cCodLanc += cMVEstado
							EndIf
	
							Do Case
							Case (cAliasCC6)->CC6_REFLEX == "001" ; cCodLanc += "3"
							Case (cAliasCC6)->CC6_REFLEX == "002" ; cCodLanc += "4"		//	Outros debitos
							Case (cAliasCC6)->CC6_REFLEX == "003" ; cCodLanc += "5"
							Case (cAliasCC6)->CC6_REFLEX == "005" ; cCodLanc += "0"
							Case (cAliasCC6)->CC6_REFLEX == "006" ; cCodLanc += "1"		//	Outros creditos
							Case (cAliasCC6)->CC6_REFLEX == "007" ; cCodLanc += "2"
							Case (cAliasCC6)->CC6_REFLEX == "012" ; cCodLanc += "6"
							Case (cAliasCC6)->CC6_REFLEX == "999" ; cCodLanc += "9"
							EndCase
	
							cCodLanc += SubStr(STRZERO(Val(Alltrim((cAliasCC6)->CC6_TPAPUR)),3),3,1)
							cCodLanc += SubStr(STRZERO(Val(Alltrim((cAliasCC6)->CC6_RESPON)),3),3,1)
							cCodLanc += SubStr(STRZERO(Val(Alltrim((cAliasCC6)->CC6_INFLUE)),3),3,1)
							cCodLanc += SubStr(STRZERO(Val(Alltrim((cAliasCC6)->CC6_ORIGEM)),3),3,1)
	
							cCodAj 		:= SubStr((cAliasCC6)->CC6_CODAJU,4,3)
	
							cCodPad	:= cCodAj			// 000-Operacao Normal/001-Diferencial de aliquota/002-Transf. Credito
							If cCodAj > "002"
								If cCodAj <= "007" 		// Credito Presumido
									cCodPad := "009"
								ElseIf cCodAj $ "009" 	// Ativo Fixo
									cCodPad := "008"
								ElseIf cCodAj $ "012" 	// Diferencial de aliquota
									cCodPad := "008"
								Else					// Outros Ajustes
									cCodPad := "999"
								EndIf
							EndIf
	
							cCodLanc += cCodPad
							
							cDescAj := MSMM((cAliasCC6)->CC6_DESCR2)
							cDescAj := IIF(Empty(cDescAj),(cAliasCC6)->CC6_DESCR,cDescAj)
						Endif	
					Endif
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Este eh o tratamento para utilizar o codigo conforme o cadastro caso esteja³
					//³ com os lancamentos atualizados, os novos codigos e novas estruturas       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !lOldLan
						cCodLanc := (cAliasCC6)->CC6_CODLAN
						cDescAj   := MSMM((cAliasCC6)->CC6_DESCR2)
						cDescAj   := IIF(Empty(cDescAj),(cAliasCC6)->CC6_DESCR,cDescAj)
					EndIf
							
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Monto o array a ser retornado com as informacoes dos lancamentos.   ³
					//³Obs: A posica 13 estah sendo retornada como BRANCO, porem serah     ³
					//³     atualizada a medida que os itens forem sendo passando, pois    ³
					//³     preciso deste codigo para montar o C197 por nfe. Como neste    ³
					//³     momento nao tenho a variavel cProd para todos os itens,        |
					//|     necessito atualizar depois, jah que a query vai apenas uma vez |
					//|     por documento no BD e retorna todos os lancamentos.            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !Empty(cCodLanc) .And. !Empty(cCodObs)
						AADD(aLancIt,{cCodLanc,;					//01
								cDescAj,;       				//02
								(cAliasCDA)->CDA_BASE,;        	//03
								(cAliasCDA)->CDA_ALIQ,;        	//04
								If (SubStr(cCodLanc,3,1) == "9", 0,(cAliasCDA)->CDA_VALOR),;       	//05
								If (SubStr(cCodLanc,3,1) == "9", (cAliasCDA)->CDA_VALOR,0),;                            	//06
								cCodObs,;	 				  	//07
								(cAliasCDA)->CDA_ESPECIE,;     	//08
								(cAliasCDA)->CDA_SERIE,;       	//09
								(cAliasCDA)->CDA_NUMERO,;      	//10
								(cAliasCDA)->CDA_TPMOVI,;      	//11
								(cAliasCDA)->CDA_CODLAN,;      	//12
								"",;                           	//13
								(cAliasCDA)->CDA_NUMITE,;      	//14
								cPartDoc,;						//15
			       			    (cAliasSFT)->FT_ENTRADA,;		//16
			       			    cDesObs ,;		                //17
			       			    (cAliasSFT)->FT_ESTADO ,;  		//18 
			       			    "" }) 							//19
				    EndIf
				EndIf
			EndIf
			(cAliasCDA)->(dbSkip())		
		EndDo
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Fecho query ou indregua criada³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SPEDFFiltro(2,"",cAliasCDA)
	EndIf
	For nX := 1 to len(aLancIt)
		aAdd(aLanCDA,aLancIt[nX])
	Next
EndIf
Return lRet
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³TotalizSFI³ Autor ³ Vendas e CRM				   ³ Data ³ 24/04/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica todas as tributacoes que foram registradas nos campos    ³±±
±±³          ³ da tabela SFI ( Resumo da Reducao Z )                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS                                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function TotalizSFI( nRecSFI, lISS , lCodAliq )
                           
Local cCampo	:= ""      	// Utilizada para armazenar o campo encotrad no SF3
Local aTotaliz	:= {}		// Array com o codigo e os valores dos totalizadores
Local cCodAliq	:= ""		// Codigo dos totalizadores das aliquotas
Local nCount	:= 0        // Contador
Local cAliqISS  := cValToChar(SuperGetMv("MV_ALIQISS",,0))
Local cLegTrib	:= "T"		// Legenda de Tributado
Local cCampoCod	:= ""      	// Utilizada para armazenar o campo referente ao código da aliquota( Utilizado para validação do PAF-ECF )
Local cValorCod	:= ""		// Armazena o valor da alíquota, utilizada no Menu Fiscal(Movimento por ECF-LOJXFUND) para o PAF-ECF
Local lTrataISS	:= .F.

DEFAULT nRecSFI := 0		// Recno do registro d SFI
DEFAULT lISS    := .F.
DEFAULT lCodAliq:= .F.

DbSelectArea("SFI")			// Seleciono a Area do arquivo SFI
DbGoto(nRecSFI)				// Posiciona no Registro DO SFI 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existe um valor no totalizador de Cancelamento 		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SFI->FI_CANCEL > 0
	aAdd(aTotaliz,{ "Can-T", SFI->FI_CANCEL,""})
EndIf

If (SFI->(FieldPos("FI_CANISS")) > 0) .AND. (SFI->FI_CANISS > 0)
	aAdd(aTotaliz,{ "Can-S", SFI->FI_CANISS,""})
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existe um valor no totalizador de Desconto 	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SFI->FI_DESC > 0
	aAdd(aTotaliz,{"DT", SFI->FI_DESC,""})	
EndIf

If (SFI->(FieldPos("FI_DESISS")) > 0) .AND. (SFI->FI_DESISS > 0) 
	aAdd(aTotaliz,{"DS", SFI->FI_DESISS , ""})
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existe um valor no totalizador de Subistuicao Tributaria³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SFI->FI_SUBTRIB > 0
	aAdd(aTotaliz,{"F1", SFI->FI_SUBTRIB,""})
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existe um valor no totalizador de Isento                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SFI->FI_ISENTO > 0
	aAdd(aTotaliz,{"I1",SFI->FI_ISENTO,""})
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existe um valor no totalizador de Nao Tributado 		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SFI->FI_NTRIB > 0
	aAdd(aTotaliz,{ "N1", SFI->FI_NTRIB,""})
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica a aliquota de ISS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Verifica se está preparado para tratar as aliquotas de ISS que devem ser mostradas e tratadas separadamente
lTrataISS := (SFI->(FieldPos("FI_BIS0300") > 0 ) .OR. SFI->(FieldPos("FI_BIS0500") > 0 ) .OR. SFI->(FieldPos("FI_BIS0700") > 0 ))
  
If !lTrataISS .AND. lISS .AND. SFI->FI_ISS > 0  
    cAliqISS := AllTrim( StrTran(cAliqISS, ",", ".") )
    cAliqISS := TransForm(cAliqISS, "@E 99.99")  
    nAliqIss := Val(SubStr(cAliqISS , 1, At(".", cAliqISS))) 
    cAliqISS := StrTran(cAliqISS, ".")
    cAliqISS := AllTrim(cAliqISS)
    If nAliqIss >= 10
	    cAliqISS := "S" + PadR(cAliqISS, 4, "0")
	Else
		cAliqISS := "S0" + PadR(cAliqISS, 3, "0")		    
    EndIf
	aAdd(aTotaliz,{ cAliqISS, SFI->FI_ISS, "00"})
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica todos os tipos de aliquotas existentes  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SX3")
DbSetOrder(2)
DbSeek("FI_BAS" , .T.)
Do While !SX3->(Eof()) .AND. SubStr(SX3->X3_CAMPO,1,6) == "FI_BAS"
	cCampo := SX3->X3_CAMPO
	If SFI->(&cCampo) > 0
		nCount++
		If Len(AllTrim(cCampo)) == 7 .OR. Len(AllTrim(cCampo)) == 9
			cLegTrib	:= "T0"		// Acrescenta um zero para entrar no padrao do arquivo
		Else
			cLegTrib	:= "T"
		EndIf
		cCodAliq := Subs(cLegTrib + PadR(AllTrim(StrTran(Subs(cCampo,7,Len(cCampo)) , ",", ".")) , 4 ,"0" ),0,5)
		
	    cCampoCod	:= "FI_COD" + Substr( cCampo, 7, Len(cCampo)-6)
	    
		If lCodAliq .AND. SFI->(FieldPos(cCampoCod))>0
		    cValorCod := SFI->(&cCampoCod)
		Else             
			cValorCod := ""
		EndIf
	    
		aAdd(aTotaliz,{ cCodAliq , SFI->(&cCampo),StrZero(nCount,2),cValorCod})
	Endif
	SX3->(dbSkip())
Enddo

If lTrataISS
	//Tratamento para alíquotas de ISS
	DbSelectArea("SX3")
	DbSetOrder(2)
	DbSeek("FI_BIS" , .T.)
	Do While !SX3->(Eof()) .AND. SubStr(SX3->X3_CAMPO,1,6) == "FI_BIS"
		cCampo := SX3->X3_CAMPO
		If SFI->(&cCampo) > 0
			nCount++
			cCodAliq := Substr(cCampo,6,Len(cCampo))

			cCampoCod	:= "FI_ICOD" + AllTrim(Str(Val(substr(cCampo,7,Len(cCampo)))/100))

			If lISS .AND.	(SFI->(FieldPos(cCampoCod)) > 0)
			    cValorCod := SFI->(&cCampoCod)
			Else             
				cValorCod := ""
			EndIf
		    
			aAdd(aTotaliz,{ cCodAliq , SFI->(&cCampo),StrZero(nCount,2),cValorCod})
		Endif
		SX3->(dbSkip())
	Enddo
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso possua apenas uma aliquota de tributacao grava    ³
//³ "00" o campo referente ao numero do totalizador  	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nCount == 1 
	aTotaliz[Len(aTotaliz)][3] := "00"
ElseIf nCount > 1 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caso ter adicionado mais de uma aliquota Tributado ,deve  		³
	//³ordernar para que os registros filhos sejam gerados corretamentes³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aTotaliz  := Asort(aTotaliz,,,{|x,y|x[1]<y[1]})
EndIf	
           
DbSelectArea("SFI")			// Seleciono a Area do arquivo SFI
DbGoto(nRecSFI)				// Posiciona no Registro DO SFI ( Garantir o posicionamento)

Return(aTotaliz) 
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³TMSCodMun | Autor ³Gustavo G. Rueda              ³ Data ³11.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Esta função tem como objetivo tratar o processo de Importacao e    ³±±
±±³          ³Exportacao referente ao envio do Codigo do Municipio (Estado=EX)   ³±±
±±³          ³                                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³1) Para utilizar esta funcao a tabela SA1 deve SEMPRE estar        ³±±
±±³          ³   posicionada.                                                    ³±±
±±³          ³2) Se trata de uma function porque eh utilizada em outros programas³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ExpC1 := TMSCodMun(cRegiao)                                        ³±±
±±³          ³                                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC1 -> Codigo do municipio conforme DUY ou "9999999" para 'EX'   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cPar1 -> Regiao de calculo conforme regra TMS                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function TMSCodMun(cRegiao)
Local cCodMun:= ""
Local cUF    := ""

If Upper(SA1->A1_EST) == "EX" 
	If DUY->(FieldPos("DUY_CODMUN")) > 0
		If DUY->(MsSeek(xFilial('DUY')+cRegiao)) .And. !Empty(DUY->DUY_CODMUN)
			cCodMun := DUY->DUY_CODMUN
			If Len(cCodMun)<=5
				cUF := UFCodIBGE(DUY->DUY_EST)
				If Empty(cUF)
					cUf := '99'
				EndIf
				cCodMun := cUF+cCodMun
			EndIf
		Else
			cCodMun := '9999999'
		EndIf
	Else
		cCodMun := '9999999'
	EndIf
Else
	cCodMun := SA1->A1_COD_MUN
	If Len(cCodMun)<=5
		cCodMun := UFCodIBGE(SA1->A1_EST)+cCodMun
	EndIf
EndIf

Return(cCodMun)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ConvType  ³ Autor ³Gustavo G. Rueda       ³ Data ³22.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcoes de tratamento de caracteres especiais copiadas do   ³±±
±±³          ³ NFESEFAZ                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC1 -> Retorna a string convertida                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³xValor -> String a ser convertida                           ³±±
±±³          ³nTam	 -> Tamanho da string                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPEDConType(xValor,nTam)

Local cNovo := ""

If nTam==Nil
	xValor := AllTrim(xValor)
EndIf
DEFAULT nTam := 60
cNovo := AllTrim(EnCodeUtf8(NoAcento(SubStr(xValor,1,nTam))))

Return(cNovo)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³SPEDVldIE ³ Autor ³Gustavo G. Rueda       ³ Data ³22.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcoes de validacao da IE do contribuinte                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC1 -> Retorna a string convertida                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cInsc -> Inscricao                                          ³±±
±±³          ³lContr-> Indica se retorna a palavra isento                 ³±±
±±³          ³lIsent-> Indica se trata isento                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPEDVldIE(cInsc,lContr,lIsent)

Local 		cRet	:=	""
Local 		nI		:=	1
Default 	lContr  :=	.T.
Default		lIsent	:=	.T.

For nI:=1 To Len(cInsc)
	If Isdigit(Subs(cInsc,nI,1)) .Or. IsAlpha(Subs(cInsc,nI,1))
		cRet+=Subs(cInsc,nI,1)
	Endif
Next
cRet := AllTrim(cRet)

If lIsent
	If "ISENT"$Upper(cRet)
		cRet := ""
	EndIf
	If !(lContr) .And. !Empty(cRet)
		cRet := "ISENTA"
	EndIf
EndIf
Return(cRet)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³SPEDFFiltr| Autor ³Gustavo G. Rueda  			   ³ Data ³02.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Funcao que efetua filtros em tabelas, indregua em dbf e query em   ³±±
±±³          ³ top. Ela deve ser chamada como 1 para criar e 2 para fechar a area³±±
±±³          ³ criada.                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ExpL1 := SPEDFFiltro(nPar,cPar,cPar,aPar)                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³nPar - Parametro que define se criara o filtro ou feche um filtro  ³±±
±±³          ³       jah criado. 1=Criar, 2=Fechar.                              ³±±
±±³          ³cPar - Se trata de um flag atraves do nome da tabela a ser criada o³±±
±±³          ³       o filtro. No caso de haver mais de um filtro para a mesma   ³±±
±±³          ³       tabela em situacoes diferentes, basta acrescentar um identi-³±±
±±³          ³       ficador na quarta posicao do nome. Ex: SFT, SFT1, SF2, etc..³±±
±±³          ³cPar - Variavel passada por referencia para retornar o alias criado³±±
±±³          ³       para a tabela em questao.                                   ³±±
±±³          ³aPar - Parametros para execucao dos filtros                        ³±±
±±³          ³nPar - Se esta variavel for passada diferente de NIL, significa que³±±
±±³          ³       a query deve retornar a quantidade de registros. Utilizado  ³±±
±±³          ³       para montar a regua de processamento mais precisa. O retorno³±±
±±³          ³       serah nesta mesma variavel que deve ser passada como        ³±±
±±³          ³       referencia. O retorno da funcao ainda continua sendo .T.    ³±±
±±³          ³       quando tiver registros ou .F. quando nao tiver.             ³±±
±±³          ³nPar - Indica o indice a ser usado (base Codebase)                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1 - Booleano para identificar se a tabela possui registros ou  ³±±
±±³          ³        nao. No caso de retornar .F., nao eh necessário chamar a   ³±±
±±³          ³        funcao com o primeiro parametro igual a 2, pois se nao     ³±±
±±³          ³        houver movimento, ela fecha o alias automaticamente.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPEDFFiltro(nOpc,cTabela,cAlias,aPar,nRecCount,nOrdDBF)
Local	cFiltro		:=	""
Local	cIndex		:=	""
Local	nIndex		:=	0
Local	lRet		:=	.F.
Local	lCountReg	:=	nRecCount<>Nil
Local   cLancVazio  := GetNewPar("MV_CDATPL", "2")

#IFDEF TOP
	Local	aSetField	:=	{}
	Local	nI			:=	0
	Local	cOrderBy	:=	""
#ENDIF
Default nOrdDBF     := 0                  
	
If nOpc==1
	If cTabela=="CVB"
		#IFDEF TOP
			If (TcSrvType ()<>"AS/400")
				//Select padrao (legado), sem campos de inicio e fim de vinculo
				cSelect	:=	"%CVB.CVB_CPF,CVB.CVB_CGC,CVB.CVB_NOME,CVB.CVB_CRC,CVB.CVB_END,CVB.CVB_UF,CVB.CVB_BAIRRO,CVB.CVB_CEP,CVB.CVB_CODMUN,CVB.CVB_TEL,CVB.CVB_FAX,CVB.CVB_EMAIL,CVB.CVB_COMPL%"				
				//Order by padrao
				cOrderBy := "%"
				cFrom	:=	"%"+RetSqlName("CVB")+" CVB%"
				cWhere	:=	"%CVB.CVB_FILIAL='"+xFilial("CVB")+"'"
				If CVB->(FieldPos("CVB_DTINI"))>0 .And. CVB->(FieldPos("CVB_DTFIM"))>0
					//Caso tenha campos de inicio e fim de vinculo, muda o select
					cSelect	:=	"%CVB.CVB_DTFIM,CVB.CVB_DTINI,CVB.CVB_CPF,CVB.CVB_CGC,CVB.CVB_NOME,CVB.CVB_CRC,CVB.CVB_END,CVB.CVB_UF,CVB.CVB_BAIRRO,CVB.CVB_CEP,CVB.CVB_CODMUN,CVB.CVB_TEL,CVB.CVB_FAX,CVB.CVB_EMAIL,CVB.CVB_COMPL%"				
					cWhere	+=	" AND (CVB.CVB_DTINI<='" + aPar[2]	+ "' OR CVB.CVB_DTINI='') "
					cWhere	+=	" AND ((CVB.CVB_DTFIM>='" + aPar[1]	+"' AND CVB.CVB_DTFIM<='" + aPar[2] + "') "
					cWhere	+=	" OR (CVB.CVB_DTFIM>'" + aPar[2]	+"' OR CVB.CVB_DTFIM = ' ')) "					
					//Sempre ordena pela maior data fim
					cOrderBy := " ORDER BY 1 DESC%"
				EndIf
				If CVB->(FieldPos("CVB_ASSIN"))>0
					cWhere	+=  " AND (CVB_ASSIN = '' OR CVB_ASSIN = '900') "
				EndIf
				If !Empty(aPar[3]) .And. CVB->(FieldPos("CVB_CPF"))>0
					cWhere	+=  " AND CVB.CVB_CPF = '" + aPar[3] + "'"
				EndIf
				If !Empty(aPar[4])	.And. CVB->(FieldPos("CVB_CGC"))>0			
					 cWhere	+=  " AND CVB.CVB_CGC = '" + aPar[4] + "'"
				EndIf
				cWhere	+=	" AND CVB.D_E_L_E_T_=''"
			Else
		#ENDIF			
				cFiltro	:= 	"CVB_FILIAL=='"+xFilial("CVB")+"' .And. "
				If CVB->(FieldPos("CVB_DTINI"))>0 .And. CVB->(FieldPos("CVB_DTFIM"))>0				
					cFiltro	+= 	" (DToS(CVB_DTINI)<='"+aPar[2]+"' .Or. DToS(CVB_DTINI)==' ') "
					cFiltro	+= 	" .And. ((DToS(CVB_DTFIM)>='"+aPar[1]+"' .And. DToS(CVB_DTFIM)<='"+aPar[2]+"') " 
					cFiltro	+= 	".Or. (DToS(CVB_DTFIM)>'"+aPar[2]+"' .Or. DToS(CVB_DTFIM)==' ')) "
				EndIf	
				If 	CVB->(FieldPos("CVB_ASSIN"))>0
					cFiltro	+=  " .And. ( Empty(CVB_ASSIN) .Or. CVB_ASSIN == '900') "  
				EndIf
				If !Empty(aPar[3]) .And. CVB->(FieldPos("CVB_CPF"))>0
					cFiltro	+=  " .And. CVB_CPF == '" + aPar[3] + "'"  
				EndIf
				If !Empty(aPar[4]) .And. CVB->(FieldPos("CVB_CGC"))>0
					cFiltro	+=  " .And. CVB_CGC == '" + aPar[4] + "'"
				EndIf
		#IFDEF TOP
			EndIf
		#ENDIF

	ElseIf cTabela=="SFT"
	
		#IFDEF TOP
			If (TcSrvType ()<>"AS/400")	
				cSelect	:=	"%SFT.FT_FILIAL,SFT.FT_TIPOMOV,SFT.FT_SERIE,SFT.FT_NFISCAL,SFT.FT_CLIEFOR,SFT.FT_LOJA,SFT.FT_ITEM,SFT.FT_PRODUTO,SFT.FT_CFOP,SFT.FT_EMISSAO,"
				cSelect	+=	IIf(SFT->(FieldPos("FT_CHVNFE"))>0,"SFT.FT_CHVNFE,","")
				cSelect	+=	"SFT.FT_ESPECIE, "
				cSelect	+=	"SB1.B1_UM,      SB1.B1_SELO,    SB1.B1_TAB_IPI, SB1.B1_VLR_IPI, SB1.B1_TIPO,    SB1.B1_DESC, "
				cSelect	+=	"SB1.B1_CODBAR,  SB1.B1_CODANT,  SB1.B1_POSIPI,  SB1.B1_EX_NCM,  SB1.B1_CODISS,  SB1.B1_PICM, "
				cSelect	+=	"SB1.B1_FECP,    SB1.B1_DATREF,  SB1.B1_SEGUM,   SB1.B1_TIPCONV, SB1.B1_CONV,    SB1.B1_VLR_PIS, "
				cSelect	+=	"SB1.B1_VLR_COF, SB1.B1_CLASSE,  SB1.B1_CONTA,   SB1.B1_ORIGEM,  SB1.B1_IMPORT,  SB1.B1_CC%"
				cFrom	:=	"%"+RetSqlName("SFT")+" SFT "
				cFrom	+=	"LEFT JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL='"+xFilial("SB1")+"' AND SFT.FT_PRODUTO=SB1.B1_COD AND SB1.D_E_L_E_T_=' '%"
		        cWhere	:=	"%SFT.FT_FILIAL='"+xFilial("SFT")+"' AND "
				cWhere	+=	"SFT.FT_TIPOMOV='"+aPar[1]+"' AND "
				cWhere	+=	"SFT.FT_SERIE='"+aPar[2]+"' AND "
				cWhere	+=	"SFT.FT_NFISCAL='"+aPar[3]+"' AND "
				cWhere	+=	"SFT.FT_CLIEFOR='"+aPar[4]+"' AND "
				cWhere	+=	"SFT.FT_LOJA='"+aPar[5]+"' AND "
				If Len(aPar) >= 6 .And. !Empty(aPar[6])
					cWhere	+=	"SFT.FT_ITEM='"+aPar[6]+"' AND "
				EndIf
				cWhere	+=	"SFT.D_E_L_E_T_=' '%"

				aAdd(aSetField,{"FT_EMISSAO","D",8,0})
			Else
		#ENDIF
				cFiltro	:= 	"FT_FILIAL=='"+xFilial("SFT")+"' .And. "
				cFiltro	+= 	"FT_TIPOMOV=='"+aPar[1]+"' .And. " 
				cFiltro	+= 	"FT_SERIE=='"+aPar[2]+"' .And. " 
				cFiltro	+= 	"FT_NFISCAL=='"+aPar[3]+"' .And. " 
				cFiltro	+= 	"FT_CLIEFOR=='"+aPar[4]+"' .And. " 
				If Len(aPar) >= 6 .And. !Empty(aPar[6])
					cFiltro	+=	"FT_ITEM=='"+aPar[6]+"' .And. "				
				EndIf				                            
				cFiltro	+= 	"FT_LOJA=='"+aPar[5]+"'"
		#IFDEF TOP
			EndIf
		#ENDIF
		
	ElseIf cTabela=="SFT2" // Uso do SPEDPISCOF
	
		#IFDEF TOP
			If (TcSrvType ()<>"AS/400")	
	        	cSelect :=	"%SFT.FT_FILIAL,SFT.FT_ENTRADA,SFT.FT_DTCANC,SFT.FT_CFOP,SFT.FT_TIPO,SFT.FT_BASEPIS,SFT.FT_CSTPIS,SFT.FT_BASECOF,"
    			cSelect	+=	"SFT.FT_CSTCOF,SFT.FT_ESPECIE,SFT.FT_NRLIVRO,SFT.FT_NFISCAL,SFT.FT_SERIE,SFT.FT_ITEM,SFT.FT_CLIEFOR,SFT.FT_LOJA,"
    			cSelect	+=	"SFT.FT_TIPOMOV,SFT.FT_VALPIS,SFT.FT_BASEPIS,SFT.FT_VALCOF,SFT.FT_BASECOF,SFT.FT_EMISSAO,SFT.FT_ALIQPIS,SFT.FT_ALIQCOF,"
    			cSelect	+=	"SFT.FT_CFOP,SFT.FT_CSTPIS,SFT.FT_CSTCOF,SFT.FT_PAUTPIS,SFT.FT_PAUTCOF"
				If SFT->(FieldPos("FT_MALQCOF")) > 0 .And. SFT->(FieldPos("FT_MVALCOF")) > 0
					cSelect += ", SFT.FT_MVALCOF , SFT.FT_MALQCOF "	
				EndIf
    			cFrom	:=	"%"+RetSqlName("SFT")+" SFT "
    			cWhere	:=	"%SFT.FT_FILIAL='"+xFilial("SFT")+"' AND "
				cWhere	+=	"SFT.FT_TIPOMOV='S' AND "
				cWhere	+=	"SFT.FT_ENTRADA<'"+aPar[1]+"' AND "
				cWhere	+=	"SFT.FT_ENTRADA>='"+aPar[3]+"' AND "
				cWhere	+=	"SFT.FT_DTCANC>='"+aPar[1]+"' AND "
				cWhere	+=	"SFT.FT_DTCANC<='"+aPar[2]+"' AND "
				cWhere	+=	"((SFT.FT_CFOP NOT LIKE '000' AND SFT.FT_CFOP NOT LIKE '999') OR SFT.FT_TIPO='"+aPar[7]+"') AND "
				cWhere	+=	"(SFT.FT_BASEPIS > 0   OR  SFT.FT_BASECOF > 0   OR SFT.FT_CFOP LIKE '7') AND SFT.FT_ESPECIE <> 'CF' AND "
				If (aPar[5]<>"*")
		        	cWhere += " SFT.FT_NRLIVRO = '" +aPar[5]+"' AND "
		  		EndiF
		  		cWhere	+=	"SFT.D_E_L_E_T_=''%"
		  		
		  		If aPar[4]$"3"
		  			If aPar[6]==1  .And. SF4->(FieldPos("F4_TPREG"))>0 .And. SB1->(FieldPos("B1_TPREG"))>0
						cSelect	+=	" ,SF4.F4_TPREG,SB1.B1_TPREG%"
						cFrom	+=	" LEFT JOIN "+RetSqlName("SD1")+" SD1 ON SD1.D1_FILIAL='"+xFilial("SD1")+"' AND SD1.D1_DOC=SFT.FT_NFISCAL AND SD1.D1_SERIE=SFT.FT_SERIE AND "
						cFrom	+=	" SD1.D1_FORNECE=SFT.FT_CLIEFOR AND SD1.D1_LOJA=SFT.FT_LOJA AND SD1.D1_ITEM=SFT.FT_ITEM AND SD1.D_E_L_E_T_='' "
						cFrom	+=	" LEFT JOIN "+RetSqlName("SF4")+" SF4 ON SF4.F4_FILIAL='"+xFilial("SF4")+"' AND SF4.F4_CODIGO=SD1.D1_TES AND SF4.D_E_L_E_T_='' "
						cFrom	+=	" LEFT JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL='"+xFilial("SB1")+"' AND SB1.B1_COD=SFT.FT_PRODUTO AND SB1.D_E_L_E_T_=''%"
					Elseif aPar[6]==2 .And. SB1->(FieldPos("B1_TPREG"))>0
						cSelect	+=	" ,SB1.B1_TPREG%"
						cFrom	+=	" LEFT JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL='"+xFilial("SB1")+"' AND SB1.B1_COD=SFT.FT_PRODUTO AND SB1.D_E_L_E_T_=''%"   
					Elseif aPar[6]==3 .And. SA1->(FieldPos("A1_TPREG")) > 0
						cSelect	+=	" ,SA1.A1_TPREG%"
						cFrom	+=	" LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL='"+xFilial("SA1")+"' AND SA1.A1_COD=SFT.FT_CLIEFOR AND "
						cFrom	+=	" SA1.A1_LOJA=SFT.FT_LOJA AND SA1.D_E_L_E_T_=''%" 
					Else
						cFrom   +=  "%"
						cSelect	+=	"%"
					Endif
				Else
					cFrom   +=  "%"
					cSelect	+=	"%"
				Endif
		  		
		  		aAdd(aSetField,{"FT_EMISSAO","D",8,0})
		  		aAdd(aSetField,{"FT_ENTRADA","D",8,0})
		  		aAdd(aSetField,{"FT_DTCANC","D",8,0})
		  Else
		#ENDIF
				cFiltro	:= 'FT_FILIAL=="'+xFilial ("SFT")+'" .And. '
			   	cFiltro += 'DTOS(FT_ENTRADA)<"'+aPar[1]+'" .And. '
			   	cFiltro	+= 'DTOS(FT_ENTRADA)>="'+aPar[3]+'" .And. '
			   	cFiltro	+= 'DTOS(FT_DTCANC)>="'+aPar[1]+'" .And. '
			   	cFiltro	+= 'DTOS(FT_DTCANC)<="'+aPar[2]+'" .And. '
				cFiltro += '(!SubStr (FT_CFOP,1,3)$"999/000" .Or. FT_TIPO=="'+aPar[7]+'") .And. '
				cFiltro	+= '(FT_VALPIS > 0 .OR. FT_VALCOF > 0) .And. '
				cFiltro	+= 'FT_ESPECIE <> "CF" '			
				If (aPar[5]<>"*")
				    cFiltro	+=	'.And. FT_NRLIVRO ="'+aPar[5]+'" '
			   	EndIf
		#IFDEF TOP
			EndIf
		#ENDIF
		

	ElseIf cTabela="SFT3" // Uso do SPEDPISCOF
	
		#IFDEF TOP
			If (TcSrvType ()<>"AS/400")	
	        	cSelect :=	"%SFT.FT_FILIAL,SFT.FT_VALCONT,SFT.FT_CSTPIS,SFT.FT_BASEPIS,SFT.FT_ALIQPIS,SFT.FT_CSTCOF,SFT.FT_BASECOF,SFT.FT_ALIQCOF,SFT.FT_TIPO,"
    			cSelect	+=	"SFT.FT_ESPECIE,SFT.FT_CFOP ,SFT.FT_CONTA,SFT.FT_TNATREC,SFT.FT_CNATREC,SFT.FT_GRUPONC, SFT.FT_DTFIMNT,SFT.FT_PAUTPIS,SFT.FT_PAUTCOF,"
    			cSelect	+=  "SFT.FT_NFISCAL,SFT.FT_CLIEFOR,SFT.FT_PRODUTO,SFT.FT_TIPOMOV,SFT.FT_SERIE,SFT.FT_LOJA,SFT.FT_ENTRADA,SFT.FT_QUANT,SFT.FT_VALPIS,SFT.FT_VALCOF,"    			
    			cSelect	+=  "SFT.FT_SERORI,SFT.FT_NFORI,SFT.FT_ITEMORI,SFT.FT_ITEM,"
				cSelect	+=	"SB1.B1_COD, SB1.B1_TIPO, SB1.B1_CODISS, SB1.B1_POSIPI, SB1.B1_DESC,    SB1.B1_CODBAR, "
				cSelect	+=	"SB1.B1_CODANT, SB1.B1_UM, SB1.B1_EX_NCM,SB1.B1_PICM, SB1.B1_FECP, SB1.B1_DATREF, SB1.B1_VLR_PIS, SB1.B1_VLR_COF, SB1.B1_TNATREC, "
				cSelect	+=	"SB1.B1_CNATREC, SB1.B1_GRPNATR, SF2.F2_VALBRUT "
    			cFrom	:=	"%"+RetSqlName("SFT")+" SFT "
				cFrom	+=	" LEFT JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL='"+xFilial("SB1")+"' AND SB1.B1_COD=SFT.FT_PRODUTO AND SB1.D_E_L_E_T_=''"   
				cFrom	+=	" LEFT JOIN "+RetSqlName("SF2")+" SF2 ON(SF2.F2_FILIAL='"+xFilial("SF2")+"'  AND SF2.F2_DOC=SFT.FT_NFISCAL AND SF2.F2_SERIE=SFT.FT_SERIE AND SF2.F2_CLIENTE=SFT.FT_CLIEFOR AND SF2.F2_LOJA=SFT.FT_LOJA AND SF2.D_E_L_E_T_=' ') "
				IF aPar[7]=="01"
			   		cSelect	+= " ,SA1.A1_CGC "
			   		cFrom += " LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL='"+xFilial("SA1")+"' AND SA1.A1_COD=SFT.FT_CLIEFOR AND "
			   		cFrom += " SA1.A1_LOJA=SFT.FT_LOJA AND SA1.D_E_L_E_T_=''"    
				EndIF 
				
    			cWhere	:=	"%SFT.FT_FILIAL='"+xFilial("SFT")+"' AND "
				cWhere	+=	"SFT.FT_TIPOMOV='S' AND "
				cWhere	+=	"SFT.FT_ENTRADA='"+aPar[1]+"' AND "
				cWhere	+=	"SFT.FT_SERIE='"+aPar[2]+"' AND "				
				cWhere	+=	"SFT.FT_NFISCAL='"+aPar[3]+"' AND "				
				cWhere	+=	"SFT.FT_CLIEFOR='"+aPar[4]+"' AND "				
				cWhere	+=	"SFT.FT_LOJA='"+aPar[5]+"' AND "				
				cWhere	+=	"(SFT.FT_BASEPIS > 0 OR SFT.FT_BASEPS3 > 0 OR  SFT.FT_BASECOF > 0 OR SFT.FT_BASECF3 > 0 OR SFT.FT_CSTPIS IN ('07','08','09','49') OR SFT.FT_CSTCOF IN ('07','08','09','49')) AND "
				If (aPar[6]<>"*")
		        	cWhere += " SFT.FT_NRLIVRO = '" +aPar[6]+"' AND "
		  		EndiF
		  		cWhere	+=	"SFT.D_E_L_E_T_=''%"
		  		
				cFrom   +=  "%"
				cSelect	+=	"%"      				
			  		
		  		aAdd(aSetField,{"FT_EMISSAO","D",8,0})
		  		aAdd(aSetField,{"FT_ENTRADA","D",8,0})
		  		aAdd(aSetField,{"FT_DTCANC","D",8,0})
		  Else
		#ENDIF
				cFiltro	:= 'FT_FILIAL=="'+xFilial ("SFT")+'" .And. '
			   	cFiltro += ' FT_TIPOMOV = "S" .AND. DTOS(FT_ENTRADA)="'+aPar[1]+'" .And. FT_SERIE == "' + aPar[2]  + '" .AND.  '
				cFiltro += 'FT_NFISCAL =="'+aPar[3]+'" .And. FT_CLIEFOR =="'+aPar[4]+'"  .AND. FT_LOJA =="'+aPar[5]+'"'
				cFiltro	+= '(FT_BASEPIS > 0 .OR. FT_BASEPS3 > 0 .OR. FT_VALCOF > 0 .OR. FT_BASECF3 > 0 .OR. FT_CSTPIS $"07#08#09#49" .OR. FT_CSTCOF $"07#08#09#49") .And. '
				If (aPar[6]<>"*")
				    cFiltro	+=	'.And. FT_NRLIVRO ="'+aPar[6]+'" '
			   	EndIf
		#IFDEF TOP
			EndIf
		#ENDIF

	ElseIf cTabela=="SFTDEV"
	
		#IFDEF TOP
			If (TcSrvType ()<>"AS/400")	
	        	cSelect :=	"%SFT.FT_FILIAL,SFT.FT_TIPOMOV,SFT.FT_NFORI,SFT.FT_SERORI,SFT.FT_ITEMORI,SFT.FT_NFISCAL,SFT.FT_CLIEFOR,"
				cSelect	+=	"SFT.FT_LOJA,SFT.FT_ITEM,SFT.FT_VALCOF,SFT.FT_VALPIS,SFT.FT_PRODUTO,SFT.FT_QUANT,SFT.FT_BASEPIS,SFT.FT_BASECOF"
				cFrom	:=	"%"+RetSqlName("SFT")+" SFT "
	            cWhere	:=	"%SFT.FT_FILIAL='"+xFilial("SFT")+"' AND "
				cWhere	+=	"SFT.FT_TIPOMOV='"+aPar[4]+"' AND "
				cWhere	+=	"SFT.FT_ENTRADA>='"+aPar[1]+"' AND "
				cWhere	+=	"SFT.FT_ENTRADA<='"+aPar[2]+"' AND "
				cWhere	+=	"SFT.FT_DTCANC='' AND "
				cWhere	+=	"SFT.FT_TIPO='D' AND "
				If aPar[3]<>"*"
		        	cWhere += " SFT.FT_NRLIVRO = '"+aPar[3]+"' AND "
		  		Endif
		  		cWhere	+=	"SFT.D_E_L_E_T_=''"
  				cOrderBy:=	" ORDER BY 1,2,3,4,5,6,7,8%"
  				
  				If aPar[6]$"3"
		  			If aPar[5]==1 						
						If aPar[4]=="E" .And. SF4->(FieldPos("F4_TPREG"))>0 .And. SB1->(FieldPos("B1_TPREG"))>0
							cSelect	+=	" ,SF4.F4_TPREG ,SB1.B1_TPREG"
							cFrom	+=	" LEFT JOIN "+RetSqlName("SD1")+" SD1 ON SD1.D1_FILIAL='"+xFilial("SD1")+"' AND SD1.D1_DOC=SFT.FT_NFISCAL AND SD1.D1_SERIE=SFT.FT_SERIE AND "
							cFrom	+=	" SD1.D1_FORNECE=SFT.FT_CLIEFOR AND SD1.D1_LOJA=SFT.FT_LOJA AND SD1.D1_ITEM=SFT.FT_ITEM AND SD1.D_E_L_E_T_='' "
							cFrom	+=	" LEFT JOIN "+RetSqlName("SF4")+" SF4 ON SF4.F4_FILIAL='"+xFilial("SF4")+"' AND SF4.F4_CODIGO=SD1.D1_TES AND SF4.D_E_L_E_T_='' "
							cWhere	+=	" AND ((SF4.F4_TPREG='2') OR (SF4.F4_TPREG='3' AND SB1.B1_TPREG='2') OR (SFT.FT_FORMUL='S' AND (SFT.FT_CSTPIS IN ('98','99') OR SFT.FT_CSTCOF IN ('98','99')) ) )"
						ElseIf  SF4->(FieldPos("F4_TPREG"))>0 .And. SB1->(FieldPos("B1_TPREG"))>0
					 	  	cSelect	+=	" ,SF4.F4_TPREG ,SB1.B1_TPREG"
							cFrom	+=	" LEFT JOIN "+RetSqlName("SD2")+" SD2 ON SD2.D2_FILIAL='"+xFilial("SD2")+"' AND SD2.D2_DOC=SFT.FT_NFISCAL AND SD2.D2_SERIE=SFT.FT_SERIE AND "
							cFrom	+=	" SD2.D2_CLIENTE=SFT.FT_CLIEFOR AND SD2.D2_LOJA=SFT.FT_LOJA AND SD2.D2_ITEM=SFT.FT_ITEM  AND SD2.D_E_L_E_T_='' "
							cFrom	+=	" LEFT JOIN "+RetSqlName("SF4")+" SF4 ON SF4.F4_FILIAL='"+xFilial("SF4")+"' AND SF4.F4_CODIGO=SD2.D2_TES AND SF4.D_E_L_E_T_='' "
							cWhere	+=	" AND ((SF4.F4_TPREG='1') OR (SF4.F4_TPREG='3' AND SB1.B1_TPREG='1'))"
						Endif
						
						cFrom	+=	" LEFT JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL='"+xFilial("SB1")+"' AND SB1.B1_COD=SFT.FT_PRODUTO AND SB1.D_E_L_E_T_=''"
						
					Elseif aPar[5]==2 .And. SB1->(FieldPos("B1_TPREG"))>0
						cSelect	+=	" ,SB1.B1_TPREG"
						cFrom	+=	" LEFT JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL='"+xFilial("SB1")+"' AND SB1.B1_COD=SFT.FT_PRODUTO AND SB1.D_E_L_E_T_=''"   
						
						If aPar[4]=="E"
							cWhere	+=	" AND ((SB1.B1_TPREG='2') OR (SFT.FT_FORMUL='S' AND (SFT.FT_CSTPIS IN ('98','99') OR SFT.FT_CSTCOF IN ('98','99')) )  )"
						Else
							cWhere	+=	" AND SB1.B1_TPREG='1'"
						Endif
					
					Elseif aPar[5]==3  
				  		If aPar[4]=="E" .And. SA1->(FieldPos("A1_TPREG"))>0
				  			cSelect	+=	" ,SA1.A1_TPREG"
							cFrom	+=	" LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL='"+xFilial("SA1")+"' AND SA1.A1_COD=SFT.FT_CLIEFOR AND "
							cFrom	+=	" SA1.A1_LOJA=SFT.FT_LOJA AND SA1.D_E_L_E_T_=''" 
							cWhere	+=	" AND ((SA1.A1_TPREG='2') OR (SFT.FT_FORMUL='S' AND (SFT.FT_CSTPIS IN ('98','99') OR SFT.FT_CSTCOF IN ('98','99')) )  )"
						Elseif SA2->(FieldPos("A2_TPREG"))>0
							cSelect	+=	" ,SA2.A2_TPREG"
							cFrom	+=	" LEFT JOIN "+RetSqlName("SA2")+" SA2 ON SA2.A2_FILIAL='"+xFilial("SA2")+"' AND SA2.A2_COD=SFT.FT_CLIEFOR AND "
							cFrom	+=	" SA2.A2_LOJA=SFT.FT_LOJA AND SA2.D_E_L_E_T_=''" 
							cWhere	+=	" AND SA2.A2_TPREG='1'"
						Endif
					Endif
		   	ElseIf aPar[6]$"1" .And. aPar[4]=="E"      			   	
				  	If SF4->(FieldPos("F4_OPERGAR"))>0		   
						cFrom		+=	" LEFT JOIN "+RetSqlName("SD1")+" SD1 ON SD1.D1_FILIAL='"+xFilial("SD1")+"' AND SD1.D1_DOC=SFT.FT_NFISCAL AND SD1.D1_SERIE=SFT.FT_SERIE AND "
						cFrom		+=	" SD1.D1_FORNECE=SFT.FT_CLIEFOR AND SD1.D1_LOJA=SFT.FT_LOJA AND SD1.D1_ITEM=SFT.FT_ITEM AND SD1.D_E_L_E_T_='' "
						cFrom		+=	" LEFT JOIN "+RetSqlName("SF4")+" SF4 ON SF4.F4_FILIAL='"+xFilial("SF4")+"' AND SF4.F4_CODIGO=SD1.D1_TES AND SF4.D_E_L_E_T_='' "
						cWhere	+=	" AND (SFT.FT_FORMUL='S' AND SF4.F4_OPERGAR<>'1') AND (SFT.FT_CSTPIS IN ('98','99') OR SFT.FT_CSTCOF IN ('98','99')) "
					Else
						cWhere	+=	" AND SFT.FT_FORMUL='S' AND (SFT.FT_CSTPIS IN ('98','99') OR SFT.FT_CSTCOF IN ('98','99')) "
					Endif	
				Endif
				cFrom   +=  "%"
				cSelect	+=	"%"
			Else		
		#ENDIF
				cFiltro	:= 'FT_FILIAL=="'+xFilial ("SFT")+'" .And. '
			   	cFiltro += 'DTOS(FT_ENTRADA)>="'+aPar[1]+'" .And. '
			   	cFiltro	+= 'DTOS(FT_ENTRADA)<="'+aPar[2]+'" .And. '
			   	cFiltro	+= 'DTOS(FT_DTCANC)=="" .And. '
				cFiltro += 'FT_TIPO == "D" .And. '
				If (aPar[3]<>"*")
				    cFiltro	+=	'FT_NRLIVRO =="'+aPar[3]+'" .And. '
			   	EndIf
				cFiltro	+= 'FT_TIPOMOV == "'+aPar[4]+'"'			
				
		#IFDEF TOP
			EndIf
		#ENDIF
	
	ElseIf cTabela=="CDA"
	
		#IFDEF TOP
			If (TcSrvType ()<>"AS/400")	
				cSelect	:=	"%CDA.CDA_FILIAL,CDA.CDA_TPMOVI,CDA.CDA_ESPECI,CDA.CDA_FORMUL,CDA.CDA_NUMERO,CDA.CDA_SERIE,CDA.CDA_CLIFOR,CDA.CDA_LOJA,CDA.CDA_NUMITE,"
				cSelect	+=	"CDA.CDA_CALPRO,CDA.CDA_CODLAN,CDA.CDA_BASE,CDA.CDA_ALIQ,CDA.CDA_VALOR"
				If CDA->(FieldPos("CDA_TPLANC"))>0	//Campo que determina se o lancamento eh de Apuracao (1) ou de NF (2)
					cSelect	+=	",CDA.CDA_TPLANC"
				EndIf
				If CDA->(FieldPos("CDA_IFCOMP"))>0
					cSelect	+=	",CDA.CDA_IFCOMP,CCE.CCE_COD,CCE.CCE_DESCR"
				EndIf

				//TRATAMENTO PARA LANCAMENTO DE NOTA FISCAL
				cSelect	+=	",CC6.CC6_FILIAL,CC6.CC6_CODLAN,CC6.CC6_REFLEX,CC6.CC6_TPAPUR,CC6.CC6_RESPON,CC6.CC6_INFLUE,CC6.CC6_ORIGEM,CC6.CC6_CODAJU,"
				cSelect	+=	"CC6.CC6_DESCR2,CC6.CC6_DESCR"
				If CC6->(FieldPos("CC6_STUF"))>0
					cSelect	+=	",CC6.CC6_STUF"
				EndIf
				If CC6->(FieldPos("CC6_TIPOAJ"))>0
					cSelect	+=	",CC6.CC6_TIPOAJ"
				EndIf

				//TRATAMENTO PARA LANCAMENTO DE APURACAO
				If CDA->(FieldPos("CDA_TPLANC"))>0	//Campo que determina se o lancamento eh de Apuracao (1) ou de NF (2)
					cSelect	+=	",CDO.CDO_FILIAL,CDO.CDO_CODAJU,CDO.CDO_UTILI,CDO.CDO_TPAPUR,CDO.CDO_SEQUEN,CDO.CDO_DESCR2,CDO.CDO_DESCR"
					cSelect	+=	",CDO.CDO_UF,CDO.CDO_TPAPUR"
				EndIf
				cSelect	+=	"%"
				cFrom	:=	"%"+RetSqlName("CDA")+" CDA "
				cFrom	+=	"LEFT JOIN "+RetSqlName("CC6")+" CC6 ON CC6.CC6_FILIAL='"+xFilial("CC6")+"' AND CC6.CC6_CODLAN=CDA.CDA_CODLAN AND CC6.D_E_L_E_T_=' ' "
				If CDA->(FieldPos("CDA_TPLANC"))>0	//Campo que determina se o lancamento eh de Apuracao (1) ou de NF (2)
					//Tratamento para CDA_TPLANC = Vazio. MV_CDATPL: 1 = Apuracao, 2 = Nota, padrao = Nota
					If cLancVazio == "1"
						cFrom	+=	" AND CDA.CDA_TPLANC='2' "
					Else
						cFrom	+=	" AND (CDA.CDA_TPLANC='2' OR CDA.CDA_TPLANC=' ') "
					EndIf					
					cFrom	+=  "LEFT JOIN "+RetSqlName("CDO")+" CDO ON CDO.CDO_FILIAL='"+xFilial("CDO")+"' AND CDO.CDO_CODAJU=CDA.CDA_CODLAN AND "
					If cLancVazio == "1"				
						cFrom	+= " (CDA.CDA_TPLANC='1' OR CDA.CDA_TPLANC=' ') AND CDO.D_E_L_E_T_=' ' "
					Else
						cFrom	+= " CDA.CDA_TPLANC='1' AND CDO.D_E_L_E_T_=' ' "
					EndIf
				EndIf
				
				//TRATAMENTO PARA OBSERVACAO DO LANCAMENTO ATRAVES DO DOCUMENTO
				If CDA->(FieldPos("CDA_IFCOMP"))>0
					cFrom	+=	"LEFT JOIN "+RetSqlName("CCE")+" CCE ON CCE.CCE_FILIAL='"+xFilial("CCE")+"' AND CCE.CCE_COD=CDA.CDA_IFCOMP AND CCE.D_E_L_E_T_=' ' "
				EndIf
				cFrom	+=	"%"
			    cWhere	:=	"%CDA.CDA_FILIAL='"+xFilial("CDA")+"' AND "
				cWhere	+=	"CDA.CDA_TPMOVI='"+aPar[1]+"' AND "
				cWhere	+=	"CDA.CDA_ESPECI='"+aPar[2]+"' AND "
				cWhere	+=	"CDA.CDA_FORMUL='"+aPar[3]+"' AND "
				cWhere	+=	"CDA.CDA_NUMERO='"+aPar[4]+"' AND "
				cWhere	+=	"CDA.CDA_SERIE='"+aPar[5]+"' AND "
				cWhere	+=	"CDA.CDA_CLIFOR='"+aPar[6]+"' AND "
				cWhere	+=	"CDA.CDA_LOJA='"+aPar[7]+"' AND "
				cWhere	+=	"CDA.D_E_L_E_T_=''%"
			Else
		#ENDIF
			    cFiltro	:=	"CDA_FILIAL=='"+xFilial("CDA")+"' .AND. "
				cFiltro	+=	"CDA_TPMOVI=='"+aPar[1]+"' .AND. "
				cFiltro	+=	"CDA_ESPECI=='"+aPar[2]+"' .AND. "
				cFiltro	+=	"CDA_FORMUL=='"+aPar[3]+"' .AND. "
				cFiltro	+=	"CDA_NUMERO=='"+aPar[4]+"' .AND. "
				cFiltro	+=	"CDA_SERIE=='"+aPar[5]+"' .AND. "
				cFiltro	+=	"CDA_CLIFOR=='"+aPar[6]+"' .AND. "
				cFiltro	+=	"CDA_LOJA=='"+aPar[7]+"'"
		#IFDEF TOP
			EndIf
		#ENDIF
								
	ElseIf cTabela=="CDG2" // Uso do SPEDPISCOF
	
		#IFDEF TOP
			If (TcSrvType ()<>"AS/400")	
				cSelect	:=	"%CDG.CDG_FILIAL,CDG.CDG_TPMOV,CDG.CDG_DOC,CDG.CDG_SERIE,CDG.CDG_CLIFOR,CDG.CDG_LOJA,CDG.CDG_PROCES,CDG.CDG_TPPROC,CDG.CDG_IFCOMP,CDG.CDG_PROCES,CDG.CDG_TPPROC,"
				cSelect +=  "CCF.CCF_NUMERO, CCF.CCF_IDSEJU,CCF.CCF_IDVARA, CCF.CCF_NATJU,CCF.CCF_DESCJU, CCF.CCF_DTSENT,CCF.CCF_NATAC, CCF.CCF_DTADM,CCF.CCF_TPCOMP  %"
				cFrom	:=	"%"+RetSqlName("CDG")+" CDG "		
				cFrom	+=	"LEFT JOIN "+RetSqlName("CCF")+" CCF ON CCF.CCF_FILIAL='"+xFilial("CCF")+"' AND CDG.CDG_PROCES=CCF.CCF_NUMERO AND CDG.CDG_TPPROC=CCF.CCF_TIPO AND CCF.D_E_L_E_T_=' '%"
				cWhere	:=	"%CDG.CDG_FILIAL='"+xFilial("CDG")+"' AND "
				cWhere	+=	"CDG.CDG_TPMOV='"+aPar[1]+"' AND "
				cWhere	+=	"CDG.CDG_DOC='"+aPar[2]+"' AND "
				cWhere	+=	"CDG.CDG_SERIE='"+aPar[3]+"' AND "
				cWhere	+=	"CDG.CDG_CLIFOR='"+aPar[4]+"' AND "
				cWhere	+=	"CDG.CDG_LOJA='"+aPar[5]+"' AND "
				cWhere	+=	"CDG.D_E_L_E_T_=' '%"
				
				aAdd(aSetField,{"CCF_DTSENT","D",8,0})
				aAdd(aSetField,{"CCF_DTADM","D",8,0})
				
			Else
		#ENDIF
				cFiltro	:=	"CDG_FILIAL=='"+xFilial("CDG")+"' .AND. "
				cFiltro	+=	"CDG_TPMOV=='"+aPar[1]+"' .AND. "
				cFiltro	+=	"CDG_DOC=='"+aPar[2]+"' .AND. "
				cFiltro	+=	"CDG_SERIE=='"+aPar[3]+"' .AND. "
				cFiltro	+=	"CDG_CLIFOR=='"+aPar[4]+"' .AND. "
				cFiltro	+=	"CDG_LOJA=='"+aPar[5]+"' "
		#IFDEF TOP
			EndIf
		#ENDIF
		
	ElseIf cTabela=="CD5"  // Uso do SPEDPISCOF/SPEDFISCAL
	
		#IFDEF TOP
			If (TcSrvType ()<>"AS/400")	
				cSelect	:=	"%CD5.CD5_FILIAL,CD5.CD5_DOC,CD5.CD5_SERIE,CD5.CD5_FORNEC,CD5.CD5_LOJA,CD5.CD5_DOCIMP,CD5.CD5_ESPEC,CD5.CD5_TPIMP,CD5.CD5_BSPIS,CD5.CD5_ALPIS,CD5.CD5_VLPIS,CD5.CD5_BSCOF,CD5.CD5_ALCOF,CD5.CD5_VLCOF"
				If CD5->(FieldPos("CD5_ACDRAW"))>0
					cSelect	+=	",CD5.CD5_ACDRAW"
				EndIf
				If CD5->(FieldPos("CD5_DTPPIS"))>0
					cSelect	+=	",CD5.CD5_DTPPIS"
				EndIf
				If CD5->(FieldPos("CD5_DTPCOF"))>0
					cSelect	+=	",CD5.CD5_DTPCOF"
				EndIf
				If CD5->(FieldPos("CD5_LOCAL"))>0
					cSelect	+=	",CD5.CD5_LOCAL"
				EndIf
				If CD5->(FieldPos("CD5_ITEM"))>0
					cSelect	+=	",CD5.CD5_ITEM"
				EndIf
				cSelect	+=	"%"
				cFrom	:=	"%"+RetSqlName("CD5")+" CD5 %"						
				cWhere	:=	"%CD5.CD5_FILIAL='"+xFilial("CD5")+"' AND "
				cWhere	+=	"CD5.CD5_DOC='"+aPar[2]+"' AND "
				cWhere	+=	"CD5.CD5_SERIE='"+aPar[3]+"' AND "
				cWhere	+=	"CD5.CD5_FORNEC='"+aPar[4]+"' AND "
				cWhere	+=	"CD5.CD5_LOJA='"+aPar[5]+"' AND "  

				// Utilizado para Registro C199 do SPED PIS COFINS  
				If (Len(aPar)>5) .AND. !Empty(aPar[6])
					cWhere	+=	"CD5.CD5_ITEM='"+aPar[6]+"' AND "  
				EndIf                                               
				
				cWhere	+=	"CD5.D_E_L_E_T_=' '%"
			Else
		#ENDIF
				cFiltro	:=	"CD5_FILIAL=='"+xFilial("CD5")+"' .AND. "
				cFiltro	+=	"CD5_DOC=='"+aPar[2]+"' .AND. "
				cFiltro	+=	"CD5_SERIE=='"+aPar[3]+"' .AND. "
				cFiltro	+=	"CD5_FORNEC=='"+aPar[4]+"' .AND. "     
				
				// Utilizado para Registro C199 do SPED PIS COFINS  
				If (Len(aPar)>5) .AND. !Empty(aPar[6])     
					cFiltro	+=	"CD5_ITEM =='"+aPar[6]+"' .AND. "  
				EndIf 
				cFiltro	+=	"CD5_LOJA=='"+aPar[5]+"' "
				
		#IFDEF TOP
			EndIf
		#ENDIF
				
	ElseIf cTabela=="SFA" // Uso do SPEDFISCAL
	
		#IFDEF TOP
			If (TcSrvType ()<>"AS/400")	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Quando lCountReg estiver como .T., significa que a query deve retornar a quantidade³
				//³ de registros. Utilizado para montar a regua de processamento mais precisa.        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lCountReg
					cSelect	:=	"%COUNT(*) COUNTREG%"
				Else
					cSelect	:=	"%SFA.FA_FILIAL,SFA.FA_CODIGO,SFA.FA_TIPO,SFA.FA_MOTIVO,SFA.FA_DATA,SFA.FA_FATOR,SFA.FA_VALOR,SFA.FA_ROTINA,SFA.FA_BAIXAPR,"
			
					If SFA->(FieldPos("FA_TOTSAI"))>0
						cSelect	+=	"SFA.FA_TOTSAI,"
					EndIf
					If SFA->(FieldPos("FA_TOTTRIB"))>0
						cSelect	+=	"SFA.FA_TOTTRIB,"
					EndIf
					
					cSelect	+=	"SF9.R_E_C_N_O_ SF9RECNO, SFT.R_E_C_N_O_ SFTRECNO, SFT2.R_E_C_N_O_ SFT2RECNO, SD1.R_E_C_N_O_ SD1RECNO, SD2.R_E_C_N_O_ SD2RECNO, SA1.R_E_C_N_O_ SA1RECNO, SA2.R_E_C_N_O_ SA2RECNO, SB1.R_E_C_N_O_ SB1RECNO, SB12.R_E_C_N_O_ SB12RECNO,SN1.R_E_C_N_O_ SN1RECNO,SN3.R_E_C_N_O_ SN3RECNO,SFT3.R_E_C_N_O_ FTRECDEVOL,SD23.R_E_C_N_O_ D2RECDEVOL,SA23.R_E_C_N_O_ A2RECDEVOL,SB13.R_E_C_N_O_ B1RECDEVOL%"
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Tratamento retirado devido a um problema de JOIN em ambiente ORACLE, bug da versao 10G.                 ³
					//³Como estas duas informacoes nao estao sendo utilizadas no momento, estou desativando.                   ³
					//³                                                                                                        ³
					//³Error : 1445 - ORA-01445: cannot select ROWID from, or sample, a join view without a key-preserved table³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					//cSelect	+=	"(SELECT COUNT(*) FROM "+RetSqlName("SFA")+" SFAX WHERE SFAX.FA_FILIAL='"+xFilial("SFA")+"' AND SFAX.FA_CODIGO=SFA.FA_CODIGO AND SFAX.FA_DATA<='"+aPar[2]+"' AND SFAX.D_E_L_E_T_='') QTDAPR,"
					//cSelect	+=	"(SELECT COUNT(*) FROM "+RetSqlName("SFA")+" SFAY WHERE SFAY.FA_FILIAL='"+xFilial("SFA")+"' AND SFAY.FA_CODIGO=SFA.FA_CODIGO AND SFAY.FA_DATA>'"+aPar[2]+"' AND SFAY.D_E_L_E_T_='') QTDAPRPOST,"
					//cSelect	+=	"(SELECT COUNT(*) FROM "+RetSqlName("SF9")+" SF9X WHERE SF9X.F9_FILIAL='"+xFilial("SF9")+"' AND SF9X.F9_DTENTNE=SF9.F9_DTENTNE AND SF9X.F9_DOCNFE=SF9.F9_DOCNFE AND SF9X.F9_SERNFE=SF9.F9_SERNFE AND SF9X.F9_FORNECE=SF9.F9_FORNECE AND SF9X.F9_LOJAFOR=SF9.F9_LOJAFOR AND SF9X.F9_ITEMNFE=SF9.F9_ITEMNFE AND SF9X.D_E_L_E_T_=' ') QTDSF9%"
				EndIf
				
				cFrom	:=	"%"+RetSqlName("SFA")+" SFA "		
				cFrom	+=	"JOIN "+RetSqlName("SF9")+" SF9 ON SF9.F9_FILIAL='"+xFilial("SF9")+"' AND SF9.F9_CODIGO=SFA.FA_CODIGO AND SF9.D_E_L_E_T_=' ' "
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Relacionamento com o documento de ENTRADA³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cFrom	+=	"LEFT JOIN "+RetSqlName("SFT")+" SFT ON SFT.FT_FILIAL='"+xFilial("SFT")+"' AND SFT.FT_TIPOMOV='E' AND SFT.FT_SERIE=SF9.F9_SERNFE AND SFT.FT_NFISCAL=SF9.F9_DOCNFE AND SFT.FT_CLIEFOR=SF9.F9_FORNECE AND SFT.FT_LOJA=SF9.F9_LOJAFOR AND SFT.FT_ITEM=SF9.F9_ITEMNFE AND SFT.D_E_L_E_T_=' ' "
				cFrom	+=	"LEFT JOIN "+RetSqlName("SD1")+" SD1 ON SD1.D1_FILIAL='"+xFilial("SD1")+"' AND SD1.D1_DOC=SFT.FT_NFISCAL AND SD1.D1_SERIE=SFT.FT_SERIE AND SD1.D1_FORNECE=SFT.FT_CLIEFOR AND SD1.D1_LOJA=SFT.FT_LOJA AND SD1.D1_COD=SFT.FT_PRODUTO AND SD1.D1_ITEM=SFT.FT_ITEM AND SD1.D_E_L_E_T_=' ' "
				cFrom	+=	"LEFT JOIN "+RetSqlName("SA2")+" SA2 ON SA2.A2_FILIAL='"+xFilial("SA2")+"' AND SA2.A2_COD=SF9.F9_FORNECE AND SA2.A2_LOJA=SF9.F9_LOJAFOR AND SA2.D_E_L_E_T_=' ' "
				cFrom	+=	"LEFT JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL='"+xFilial("SB1")+"' AND SB1.B1_COD=SFT.FT_PRODUTO AND SB1.D_E_L_E_T_=' ' "
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Relacionamento com o documento de SAIDA³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cFrom	+=	"LEFT JOIN "+RetSqlName("SFT")+" SFT2 ON SFT2.FT_FILIAL='"+xFilial("SFT")+"' AND SFT2.FT_TIPOMOV='S' AND SFT2.FT_SERIE=SF9.F9_SERNFS AND SFT2.FT_NFISCAL=SF9.F9_DOCNFS AND SFT2.FT_CLIEFOR=SF9.F9_CLIENTE AND SFT2.FT_LOJA=SF9.F9_LOJACLI AND SFT2.FT_ITEM="+Iif(SF9->(FieldPos("F9_ITEMNFS"))>0,"SF9.F9_ITEMNFS","''")+" AND SFT2.D_E_L_E_T_=' ' "
				cFrom	+=	"LEFT JOIN "+RetSqlName("SD2")+" SD2  ON SD2.D2_FILIAL='"+xFilial("SD2")+"' AND SD2.D2_DOC=SFT2.FT_NFISCAL AND SD2.D2_SERIE=SFT2.FT_SERIE AND SD2.D2_CLIENTE=SFT2.FT_CLIEFOR AND SD2.D2_LOJA=SFT2.FT_LOJA AND SD2.D2_COD=SFT2.FT_PRODUTO AND SD2.D2_ITEM=SFT2.FT_ITEM AND SD2.D_E_L_E_T_=' ' "
				cFrom	+=	"LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL='"+xFilial("SA1")+"' AND SA1.A1_COD=SF9.F9_CLIENTE AND SA1.A1_LOJA=SF9.F9_LOJACLI AND SA1.D_E_L_E_T_=' ' "
				cFrom	+=	"LEFT JOIN "+RetSqlName("SB1")+" SB12 ON SB12.B1_FILIAL='"+xFilial("SB1")+"' AND SB12.B1_COD=SFT2.FT_PRODUTO AND SB12.D_E_L_E_T_=' ' "
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Relacionamento com o documento de SAIDA DEVOLUCAO³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cFrom	+=	"LEFT JOIN "+RetSqlName("SFT")+" SFT3 ON SFT3.FT_FILIAL='"+xFilial("SFT")+"' AND SFT3.FT_TIPOMOV='S'         AND SFT3.FT_SERIE=SF9.F9_SERNFS AND SFT3.FT_NFISCAL=SF9.F9_DOCNFS   AND SFT3.FT_CLIEFOR=SF9.F9_FORNECE AND SFT3.FT_LOJA=SF9.F9_LOJAFOR AND SFT3.FT_ITEM="+Iif(SF9->(FieldPos("F9_ITEMNFS"))>0,"SF9.F9_ITEMNFS","''")+" AND SFT3.D_E_L_E_T_=' ' "
				cFrom	+=	"LEFT JOIN "+RetSqlName("SD2")+" SD23 ON SD23.D2_FILIAL='"+xFilial("SD2")+"' AND SD23.D2_DOC=SFT3.FT_NFISCAL AND SD23.D2_SERIE=SFT3.FT_SERIE AND SD23.D2_CLIENTE=SFT3.FT_CLIEFOR AND SD23.D2_LOJA=SFT3.FT_LOJA      AND SD23.D2_COD=SFT3.FT_PRODUTO AND SD23.D2_ITEM=SFT3.FT_ITEM AND SD23.D_E_L_E_T_=' ' "
				cFrom	+=	"LEFT JOIN "+RetSqlName("SA2")+" SA23 ON SA23.A2_FILIAL='"+xFilial("SA2")+"' AND SA23.A2_COD=SF9.F9_FORNECE  AND SA23.A2_LOJA=SF9.F9_LOJAFOR AND SA23.D_E_L_E_T_=' ' "
				cFrom	+=	"LEFT JOIN "+RetSqlName("SB1")+" SB13 ON SB13.B1_FILIAL='"+xFilial("SB1")+"' AND SB13.B1_COD=SFT3.FT_PRODUTO AND SB13.D_E_L_E_T_=' ' "				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Relacionamento com o cadastro de ativo (SN1/SN3)³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cFrom	+=	"LEFT JOIN "+RetSqlName("SN1")+" SN1 ON SN1.N1_FILIAL='"+xFilial("SN1")+"' AND SN1.N1_CODCIAP=SF9.F9_CODIGO AND SN1.D_E_L_E_T_=' ' "
				cFrom	+=	"LEFT JOIN "+RetSqlName("SN3")+" SN3 ON SN3.N3_FILIAL='"+xFilial("SN3")+"' AND SN3.N3_CBASE=SN1.N1_CBASE AND SN3.N3_ITEM=SN1.N1_ITEM AND SN3.D_E_L_E_T_=' '%"
				
				cWhere	:= 	"%SFA.FA_FILIAL='"+xFilial("SFA")+"' AND "
				cWhere	+= 	"SFA.FA_DATA>='"+aPar[1]+"' AND "
				cWhere	+= 	"SFA.FA_DATA<='"+aPar[2]+"' AND "
				cWhere	+= 	"SFA.D_E_L_E_T_ = ' ' %"
				
				
				aAdd(aSetField,{"FA_DATA","D",8,0})
				aAdd(aSetField,{"F9_DTENTNE","D",8,0})
				aAdd(aSetField,{"F9_DTEMINE","D",8,0})
				aAdd(aSetField,{"F9_DTEMINS","D",8,0})
			Else
		#ENDIF
				cFiltro	:=	"FA_FILIAL=='"+xFilial("SFA")+"' .AND. "
				cFiltro	+= 	"DToS(FA_DATA)>='"+aPar[1]+"' .AND. "
				cFiltro	+= 	"DToS(FA_DATA)<='"+aPar[2]+"' "
		#IFDEF TOP
			EndIf
		#ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento criado isoladamente da condicao anterior (cTabela=="SFA") devido a um problema de JOIN em    ³
	//|  ambiente ORACLE, bug da versao 10G.                                                                   |
	//³Como estas duas informacoes nao estao sendo utilizadas no momento, estou desativando.                   ³
	//³                                                                                                        ³
	//³Error : 1445 - ORA-01445: cannot select ROWID from, or sample, a join view without a key-preserved table³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf cTabela=="SFA2" // Uso do SPEDFISCAL
	
		#IFDEF TOP
			If (TcSrvType ()<>"AS/400")			
				cSelect	:=	"%COUNT(*) QTDAPR%"
				cFrom	:=	"%"+RetSqlName("SFA")+" SFAX%"
				cWhere	:=	"%SFAX.FA_FILIAL='"+xFilial("SFA")+"' AND "
				cWhere	+=	"SFAX.FA_CODIGO='"+aPar[1]+"' AND "
				cWhere	+=	"SFAX.FA_DATA<='"+aPar[2]+"' AND "
				cWhere	+=	"SFAX.D_E_L_E_T_=''%"
			Else
		#ENDIF
				cFiltro	:=	"FA_FILIAL=='"+xFilial("SFA")+"' .AND. "
				cFiltro	+=	"FA_CODIGO=='"+aPar[1]+"' .AND. "
				cFiltro	+=	"DToS(FA_DATA)<='"+aPar[2]+"' "
		#IFDEF TOP
			EndIf
		#ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento criado isoladamente da condicao anterior (cTabela=="SFA") devido a um problema de JOIN em    ³
	//|  ambiente ORACLE, bug da versao 10G.                                                                   |
	//³Como estas duas informacoes nao estao sendo utilizadas no momento, estou desativando.                   ³
	//³                                                                                                        ³
	//³Error : 1445 - ORA-01445: cannot select ROWID from, or sample, a join view without a key-preserved table³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	ElseIf cTabela=="SFA3" // Uso do SPEDFISCAL
	
		#IFDEF TOP
			If (TcSrvType ()<>"AS/400")			
				cSelect	:=	"%COUNT(*) QTDAPRPOST%"
				cFrom	:=	"%"+RetSqlName("SFA")+" SFAY%"
				cWhere	:=	"%SFAY.FA_FILIAL='"+xFilial("SFA")+"' AND "
				cWhere	+=	"SFAY.FA_CODIGO='"+aPar[1]+"' AND "
				cWhere	+=	"SFAY.FA_DATA>'"+aPar[2]+"' AND "
				cWhere	+=	"SFAY.FA_TIPO='1' AND "
				cWhere	+=	"SFAY.D_E_L_E_T_=''%"

			Else
		#ENDIF
				cFiltro	:=	"FA_FILIAL=='"+xFilial("SFA")+"' .AND. "
				cFiltro	+=	"FA_CODIGO=='"+aPar[1]+"' .AND. "
				cWhere	+=	"FA_TIPO=='1' .AND. "
				cFiltro	+=	"DToS(FA_DATA)>'"+aPar[2]+"' "
		#IFDEF TOP
			EndIf
		#ENDIF
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento nao foi criado como uma subquery na condicao anterior (cTabela=="SFA") devido a um problema  ³
	//|  de JOIN em ambiente ORACLE, bug da versao 10G.                                                        |
	//³Como estas duas informacoes nao estao sendo utilizadas no momento, estou desativando.                   ³
	//³                                                                                                        ³
	//³Error : 1445 - ORA-01445: cannot select ROWID from, or sample, a join view without a key-preserved table³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	ElseIf cTabela=="SFA4" // Uso do SPEDFISCAL
	
		#IFDEF TOP
			If (TcSrvType ()<>"AS/400")			
				cSelect	:=	"%SUM(SFA4.FA_VALOR) VLRBAIXA%"
				cFrom	:=	"%"+RetSqlName("SFA")+" SFA4%"
				cWhere	:=	"%SFA4.FA_FILIAL='"+xFilial("SFA")+"' AND "
				cWhere	+=	"SFA4.FA_CODIGO='"+aPar[1]+"' AND "
				cWhere	+=	"SFA4.FA_DATA<='"+aPar[2]+"' AND "
				cWhere	+=	"SFA4.FA_TIPO='2' AND "
				cWhere	+=	"SFA4.FA_BAIXAPR='1' AND "
				cWhere	+=	"SFA4.D_E_L_E_T_=''%"

			Else
		#ENDIF
		
				//PARA DBF NAO NECESSITA DE FILTRO, POIS EH UM IF DIFERENTE NA CHAMADA DA FUNCAO
				
		#IFDEF TOP
			EndIf
		#ENDIF
		
	ElseIf cTabela=="SF9" // Uso do SPEDFISCAL
	
		#IFDEF TOP
			If (TcSrvType ()<>"AS/400")	
			
				cSelect :=	"%COUNT(*) QTDSF9%"
				cFrom	:=	"%"+RetSqlName("SF9")+" SF9X %"
				cWhere	:=	"%SF9X.F9_FILIAL='"+xFilial("SF9")+"' AND "
				cWhere	+=	"SF9X.F9_DTENTNE='"+aPar[1]+"' AND "
				cWhere	+=	"SF9X.F9_DOCNFE='"+aPar[2]+"' AND "
				cWhere	+=	"SF9X.F9_SERNFE='"+aPar[3]+"' AND "
				cWhere	+=	"SF9X.F9_FORNECE='"+aPar[4]+"' AND "
				cWhere	+=	"SF9X.F9_LOJAFOR='"+aPar[5]+"' AND "
				cWhere	+=	"SF9X.F9_ITEMNFE='"+aPar[6]+"' AND "
				cWhere	+=	"SF9X.D_E_L_E_T_=' ' %"
			Else
		#ENDIF
				cFiltro	:=	"F9_FILIAL=='"+xFilial("SF9")+"' .AND. "
				cFiltro	+=	"DToS(F9_DTENTNE)=='"+aPar[1]+"' .AND. "
				cFiltro	+=	"F9_DOCNFE=='"+aPar[2]+"' .AND. "
				cFiltro	+=	"F9_SERNFE=='"+aPar[3]+"' .AND. "
				cFiltro	+=	"F9_FORNECE=='"+aPar[4]+"' .AND. "
				cFiltro	+=	"F9_LOJAFOR=='"+aPar[5]+"' .AND. "
				cFiltro	+=	"F9_ITEMNFE=='"+aPar[6]+"' "

		#IFDEF TOP
			EndIf
		#ENDIF
		
	ElseIf cTabela=="CDH" // Uso do SPEDFISCAL
	
		#IFDEF TOP
			If (TcSrvType ()<>"AS/400")	
				cSelect :=	"%A.*,SF6.R_E_C_N_O_ SF6RECNO%"
				cFrom	:=	"%"+RetSqlName("CDH")+" A "
				cFrom	+=	" LEFT JOIN "+RetSqlName("SF6")+" SF6 ON SF6.F6_FILIAL='"+xFilial("SF6")+"' AND A.CDH_ESTGNR=SF6.F6_EST AND A.CDH_GNRE=SF6.F6_NUMERO AND SF6.D_E_L_E_T_=' '%"
				cWhere	:=	"%A.CDH_FILIAL='"+xFilial("CDH")+"' AND "
				cWhere	+=	"A.CDH_TIPOIP='"+aPar[1]+"' AND "
				cWhere	+=	"A.CDH_TIPOPR='"+aPar[2]+"' AND "
				cWhere	+=	"A.CDH_PERIOD='"+aPar[3]+"' AND "
				cWhere	+=	"A.CDH_DTINI='"+aPar[4]+"' AND "
				cWhere	+=	"A.CDH_LIVRO='"+aPar[5]+"' AND "
				cWhere	+=	"A.CDH_SEQUEN=(SELECT MAX(B.CDH_SEQUEN) FROM "+RetSqlName("CDH")+" B WHERE B.CDH_FILIAL=A.CDH_FILIAL AND B.CDH_TIPOIP=A.CDH_TIPOIP AND B.CDH_TIPOPR=A.CDH_TIPOPR AND B.CDH_PERIOD=A.CDH_PERIOD AND B.CDH_DTINI=A.CDH_DTINI AND B.CDH_LIVRO=A.CDH_LIVRO AND B.D_E_L_E_T_='') AND "
				cWhere	+=	"A.D_E_L_E_T_=''%"
			Else
		#ENDIF
				cFiltro	:=	"CDH_FILIAL=='"+xFilial("CDH")+"' .AND. "
				cFiltro	+=	"CDH_TIPOIP=='"+aPar[1]+"' .AND. "
				cFiltro	+=	"CDH_TIPOPR=='"+aPar[2]+"' .AND. "
				cFiltro	+=	"CDH_PERIOD=='"+aPar[3]+"' .AND. "
				cFiltro	+=	"DToS(CDH_DTINI)=='"+aPar[4]+"' .AND. "
				cFiltro	+=	"CDH_LIVRO=='"+aPar[5]+"' .AND. "
				cFiltro	+=	"CDH_SEQUEN=='"+aPar[6]+"' "
		#IFDEF TOP
			EndIf
		#ENDIF
		
	ElseIf cTabela=="CDP" // Uso do SPEDFISCAL
	
		#IFDEF TOP
			If (TcSrvType ()<>"AS/400")	
				cSelect :=	"%CDP.*,CCK.R_E_C_N_O_ CCKRECNO%"
				cFrom	:=	"%"+RetSqlName("CDP")+" CDP "
				cFrom	+=	" LEFT JOIN "+RetSqlName("CCK")+" CCK ON CCK.CCK_FILIAL='"+xFilial("CCK")+"' AND CCK.CCK_CODAJU=CDP.CDP_CODLAN AND CCK.D_E_L_E_T_=' '%"
						
				cWhere	:=	"%CDP.CDP_FILIAL='"+xFilial("CDP")+"' AND "
				cWhere	+=	"CDP.CDP_TIPOIP='"+aPar[1]+"' AND "
				cWhere	+=	"CDP.CDP_TIPOPR='"+aPar[2]+"' AND "
				cWhere	+=	"CDP.CDP_PERIOD='"+aPar[3]+"' AND "
				cWhere	+=	"CDP.CDP_DTINI='"+aPar[4]+"' AND "
				cWhere	+=	"CDP.CDP_LIVRO='"+aPar[5]+"' AND "
				cWhere	+=	"CDP.CDP_SEQUEN=(SELECT MAX(B.CDP_SEQUEN) FROM "+RetSqlName("CDP")+" B WHERE B.CDP_FILIAL=CDP.CDP_FILIAL AND B.CDP_TIPOIP=CDP.CDP_TIPOIP AND B.CDP_TIPOPR=CDP.CDP_TIPOPR AND B.CDP_PERIOD=CDP.CDP_PERIOD AND B.CDP_DTINI=CDP.CDP_DTINI AND B.CDP_LIVRO=CDP.CDP_LIVRO AND B.D_E_L_E_T_=' ') AND "
				cWhere	+=	"CDP.D_E_L_E_T_=' '%"
			Else
		#ENDIF		
				cFiltro	:=	"CDP_FILIAL=='"+xFilial("CDP")+"' .AND. "
				cFiltro	+=	"CDP_TIPOIP=='"+aPar[1]+"' .AND. "
				cFiltro	+=	"CDP_TIPOPR=='"+aPar[2]+"' .AND. "
				cFiltro	+=	"CDP_PERIOD=='"+aPar[3]+"' .AND. "
				cFiltro	+=	"DToS(CDP_DTINI)=='"+aPar[4]+"' .AND. "
				cFiltro	+=	"CDP_LIVRO=='"+aPar[5]+"' .AND. "
				cFiltro	+=	"CDP_SEQUEN=='"+aPar[6]+"' "
		#IFDEF TOP
			EndIf
		#ENDIF

	ElseIf cTabela=="CDL" // Uso do SPEDFISCAL
	
		#IFDEF TOP
			If (TcSrvType ()<>"AS/400")	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Quando lCountReg estiver como .T., significa que a query deve retornar a quantidade³
				//³ de registros. Utilizado para montar a regua de processamento mais precisa.        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lCountReg
					cSelect	:=	"%COUNT(*) COUNTREG%"
				Else
					cSelect :=	"%*%"
				EndIf
				cFrom	:=	"%"+RetSqlName("CDL")+" CDL%"
				cWhere	:=	"%CDL.CDL_FILIAL='"+xFilial("CDL")+"' AND "
				cWhere	+=	"CDL.CDL_DTAVB>='"+aPar[1]+"' AND "
				cWhere	+=	"CDL.CDL_DTAVB<='"+aPar[2]+"' AND "
				cWhere	+=	"CDL.D_E_L_E_T_=''%"
			Else
		#ENDIF
				cFiltro	:=	"CDL_FILIAL=='"+xFilial("CDL")+"' .AND. "
				cFiltro	+=	"DToS(CDL_DTAVB)>='"+aPar[1]+"' .AND. "
				cFiltro	+=	"DToS(CDL_DTAVB)<='"+aPar[2]+"' "
		#IFDEF TOP
			EndIf
		#ENDIF

	ElseIf cTabela=="EEC" // Uso do SPEDFISCAL 
	
		#IFDEF TOP
			If (TcSrvType ()<>"AS/400")	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Quando lCountReg estiver como .T., significa que a query deve retornar a quantidade³
				//³ de registros. Utilizado para montar a regua de processamento mais precisa.        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lCountReg
					cSelect	:=	"%COUNT(*) COUNTREG%"
				Else
					cSelect :=	"%*%"
				EndIf
				cFrom	:=	"%"+RetSqlName("EEC")+" EEC "
				cFrom	+=	"JOIN "+RetSqlName("EE9")+" EE9 "
				cFrom	+=	"ON EE9.EE9_FILIAL='"+xFilial("EE9")+"' AND EE9.EE9_PREEMB=EEC.EEC_PREEMB AND EE9.D_E_L_E_T_=''%"
		      	cWhere	:=	"%EEC.EEC_FILIAL='"+xFilial("EEC")+"' AND "
		        cWhere	+=	"EEC.EEC_DTEMBA>='"+aPar[1]+"' AND "
		        cWhere	+=	"EEC.EEC_DTEMBA<='"+aPar[2]+"' AND "
				cWhere	+=	"EEC.D_E_L_E_T_=''%"
			Else
		#ENDIF		
		      	cFiltro	:=	"EEC_FILIAL=='"+xFilial("EEC")+"' .AND. "
		        cFiltro	+=	"DToS(EEC_DTEMBA)>='"+aPar[1]+"' .AND. "
		        cFiltro	+=	"DToS(EEC_DTEMBA)<='"+aPar[2]+"' "
		#IFDEF TOP
			EndIf
		#ENDIF

	ElseIf cTabela=="SFI" // Uso do SPEDFISCAL       

		#IFDEF TOP
			If (TcSrvType ()<>"AS/400")	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Quando lCountReg estiver como .T., significa que a query deve retornar a quantidade³
				//³ de registros. Utilizado para montar a regua de processamento mais precisa.        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lCountReg
					cSelect	:=	"%COUNT(*) COUNTREG%"
				Else
					cSelect := "%SFI.FI_DTMOVTO,SFI.R_E_C_N_O_ SFIRECNO%"			
				EndIf
				cFrom	:=	"%"+RetSqlName("SFI")+" SFI %"
		      	cWhere	:=	"%SFI.FI_FILIAL='"+xFilial("SFI")+"' AND "
		        cWhere	+=	"SFI.FI_DTMOVTO>='"+aPar[1]+"' AND "
		        cWhere	+=	"SFI.FI_DTMOVTO<='"+aPar[2]+"' AND "
		        cWhere	+=	"SFI.FI_PDV='"+aPar[3]+"' AND "
		        cWhere	+=	"SFI.FI_SERPDV='"+aPar[4]+"' AND "
		        cWhere	+=	"( (SFI.FI_VALCON > 0 ) OR (FI_ISS > 0) ) AND "
				cWhere	+=	"SFI.D_E_L_E_T_=''"
				If !lCountReg
					cOrderBy := " ORDER BY 1%"
				Else 
					cOrderBy := "%"
				EndIf	
			Else
		#ENDIF			
		      	cFiltro	:=	"FI_FILIAL=='"+xFilial("SFI")+"' .AND. "
		        cFiltro	+=	"DToS(FI_DTMOVTO)>='"+aPar[1]+"' .AND. "
		        cFiltro	+=	"DToS(FI_DTMOVTO)<='"+aPar[2]+"' .AND. "
		        cFiltro	+=	"FI_PDV=='"+aPar[3]+"' .AND. "
		        cFiltro	+=	"FI_SERPDV=='"+aPar[4]+"' .AND. "    
		        cFiltro	+=	"( (FI_VALCON > 0 ) .OR. (FI_ISS > 0) )  "
		#IFDEF TOP
			EndIf
		#ENDIF
	
    Elseif cTabela=="CE6" // Uso do SPEDFISCAL 
    
    	#IFDEF TOP
			If (TcSrvType ()<>"AS/400")
				If lCountReg
					cSelect	:=	"%COUNT(*) COUNTREG%"
				Else
					cSelect :=	"%CE6.*, CE5.*%"
				EndIf
				cFrom	:=	"%"+RetSqlName("CE6")+" CE6 "
				cFrom	+=	" LEFT JOIN "+RetSqlName("CE5")+" CE5 ON CE5.CE5_FILIAL='"+xFilial("CE6")+"' AND CE5.CE5_CODLAN=CE6.CE6_CODLAN AND "
				cFrom	+=	"CE5.CE5_PERIOD=CE6.CE6_PERIOD%"
				cWhere	:=	"%CE6.CE6_FILIAL='"+xFilial("CE6")+"' AND "
				cWhere	+=	"CE6.CE6_PERIOD='"+aPar[1]+"' AND "
				cWhere	+=	"CE5.CE5_TPMOV='U' AND "
				cWhere	+=	"CE6.D_E_L_E_T_=''%"
			Else
		#ENDIF
				cFiltro	:=	"CE6_FILIAL=='"+xFilial("CE6")+"' .AND. "
				cFiltro	+=	"CE6_PERIOD=='"+aPar[1]+"' "
		#IFDEF TOP
			EndIf
		#ENDIF
		
	Elseif cTabela=="CF5" // Uso do SPEDPISCOF 
	
		#IFDEF TOP
			If (TcSrvType ()<>"AS/400")
				cSelect :=	"%CF5.*%"
				cFrom	:=	"%"+RetSqlName("CF5")+" CF5 %"
				cWhere	:=	"%CF5.CF5_FILIAL='"+xFilial("CF5")+"' AND "
				cWhere	+=	"CF5.CF5_DTREF>='"+aPar[1]+"' AND "
				cWhere	+=	"CF5.CF5_DTREF<='"+aPar[2]+"' AND "
				cWhere	+=	"CF5.CF5_PISCOF='"+aPar[4] +"' AND "
				If CF5->(FieldPos("CF5_CODCRE")) > 0
					cWhere	+=	"CF5.CF5_CODCRE='"+aPar[3] +"' AND "
				Endif
				cWhere	+=	"CF5.D_E_L_E_T_=''%"
				aAdd(aSetField,{"CF5_DTREF","D",8,0})												
			Else
		#ENDIF
				cFiltro	:= 'CF5_FILIAL=="'+xFilial ("CF5")+'" .And. '
	   			cFiltro += 'DTOS(CF5_DTREF)>="'+aPar[1]+'" .And. '
	   			cFiltro += 'DTOS(CF5_DTREF)<="'+aPar[2]+'" .And. '
	   			If CF5->(FieldPos("CF5_CODCRE")) > 0
	   				cFiltro += 'CF5_CODCRE=="'+aPar[3]+'" .And. '
	   			Endif
	   			cFiltro += 'CF5_PISCOF=="'+aPar[4]+'" '
		#IFDEF TOP
			EndIf
		#ENDIF
	
    Elseif cTabela=="CF6" // Uso do SPEDPISCOF
    
    	#IFDEF TOP
			If (TcSrvType ()<>"AS/400")
				cSelect	:=	"%CF6.*%"
				cFrom	:=	"%"+RetSqlName("CF6")+" CF6 %"
				cWhere	:=	"%CF6.CF6_FILIAL='"+xFilial("CF6")+"' AND "
				cWhere	+=	"CF6.CF6_DTOPER>='"+aPar[1]+"' AND "
				cWhere	+=	"CF6.CF6_DTOPER<='"+aPar[2]+"' AND "
				cWhere	+=	"CF6.D_E_L_E_T_=''%"  
				
				aAdd(aSetField,{"CF6_DTOPER","D",8,0})
			Else
		#ENDIF
				cFiltro	:= 'CF6_FILIAL=="'+xFilial("CF6")+'" .And. '
	   			cFiltro += 'DTOS(CF6_DTOPER)>="'+aPar[1]+'" .And. '
	   			cFiltro	+= 'DTOS(CF6_DTOPER)<="'+aPar[2]+'" '
		#IFDEF TOP
			EndIf
		#ENDIF
    
    Elseif cTabela=="CF8" // Uso do SPEDPISCOF

    	#IFDEF TOP
			If (TcSrvType ()<>"AS/400")
				cSelect	:=	"%CF8.*%"
				cFrom	:=	"%"+RetSqlName("CF8")+" CF8 %"
				cWhere	:=	"%CF8.CF8_FILIAL='"+xFilial("CF8")+"' AND "
				cWhere	+=	"CF8.CF8_DTOPER>='"+aPar[1]+"' AND "
				cWhere	+=	"CF8.CF8_DTOPER<='"+aPar[2]+"' AND "
				cWhere	+=	"CF8.D_E_L_E_T_=''%"
				aAdd(aSetField,{"CF8_DTOPER","D",8,0})
				If CF8->(FieldPos("CF8_DTFIMN"))>0
					aAdd(aSetField,{"CF8_DTFIMN","D",8,0})
				Endif	
			Else
		#ENDIF
				cFiltro	:= 'CF8_FILIAL=="'+xFilial("CF8")+'" .And. '
	   			cFiltro += 'DTOS(CF8_DTOPER)>="'+aPar[1]+'" .And. '
	   			cFiltro	+= 'DTOS(CF8_DTOPER)<="'+aPar[2]+'" '
		#IFDEF TOP
			EndIf
		#ENDIF		
		
	Elseif cTabela=="CF2" // Uso do SPEDPISCOF
    
    	#IFDEF TOP
			If (TcSrvType ()<>"AS/400")
				cSelect	:=	"%CF2.*%"
				cFrom	:=	"%"+RetSqlName("CF2")+" CF2 %"
				cWhere	:=	"%CF2.CF2_FILIAL='"+xFilial("CF2")+"' AND "
				If !Empty(aPar[1])
					cWhere	+=	"CF2.CF2_INDNAT='"+aPar[1]+"' AND "
				Endif
				cWhere	+=	"CF2.CF2_PER='"+aPar[2]+"' AND "
				cWhere	+=	"CF2.D_E_L_E_T_=''%"
			Else
		#ENDIF
				cFiltro	:= 'CF2_FILIAL=="'+xFilial("CF2")+'" .And. '
	   			If !Empty(aPar[1])
	   				cFiltro += 'CF2_INDNAT=="'+aPar[1]+'" .And. '
	   			Endif
	   			cFiltro	+= 'CF2_PER=="'+aPar[2]+'" '
		#IFDEF TOP
			EndIf
		#ENDIF
    
    Elseif cTabela=="CF3" // Uso do SPEDPISCOF
    
    	#IFDEF TOP
			If (TcSrvType ()<>"AS/400")
				cSelect	:=	"%CF3.CF3_PERORI, CF3.CF3_REGIME, CF3.CF3_VLRPIS, CF3.CF3_VLRCOF, CF3.CF3_ORIGEM"
				cSelect	+=	Iif(aPar[1],",CF3.CF3_NFDEV, CF3.CF3_NFORI%","%")
				cFrom	:=	"%"+RetSqlName("CF3")+" CF3 %"
				cWhere	:=	"%CF3.CF3_FILIAL='"+xFilial("CF3")+"' AND "
				cWhere	+=	"CF3.CF3_PERUTI='"+aPar[2]+"' AND "
				cWhere	+=	"CF3.CF3_ORIGEM IN ('D','E','A','C') AND "
				cWhere	+=	"CF3.D_E_L_E_T_=''%"
				
				aAdd(aSetField,{"CF3_PERORI","D",8,0})
			Else
		#ENDIF
				cFiltro	:= 'CF3_FILIAL=="'+xFilial("CF3")+'" .And. '
	   			cFiltro += 'CF3_PERUTI =="'+ aPar[2] + '" .And. '
		   		cFiltro	+= '(CF3_ORIGEM$ "D#E#A#C")'	
		#IFDEF TOP
			EndIf
		#ENDIF
    
    Elseif cTabela=="CFA"
    
    	#IFDEF TOP
			If (TcSrvType ()<>"AS/400")
				cSelect	:=	"%CFA.CFA_CODCON, CFA.CFA_TPCON, CFA.CFA_CNPJ, CFA.CFA_TOTVEN, CFA.CFA_VLNREC, CFA.CFA_CONDIF, "
				cSelect	+=	"CFA.CFA_PERAPU, CFA.CFA_ALIQ, CFA_CREDIF, CFA_CODCRE%"
				cFrom	:=	"%"+RetSqlName("CFA")+" CFA %"
				cWhere	:=	"%CFA.CFA_FILIAL='"+xFilial("CFA")+"' AND "
				cWhere	+=	"CFA.CFA_PERAPU='"+aPar[1]+"' AND "
				cWhere	+=	"CFA.CFA_TPCON='"+aPar[2]+"' AND "
				cWhere	+=	"CFA.D_E_L_E_T_=''%"
			Else
		#ENDIF
				cFiltro	:= 'CFA_FILIAL=="'+xFilial("CFA")+'" .And. '
	   			cFiltro += 'CFA_PERAPU =="'+ aPar[1] + '" .And. '
	   			cFiltro += 'CFA_TPCON =="'+ aPar[2] + '"'	
		#IFDEF TOP
			EndIf
		#ENDIF	
    
    Elseif cTabela=="CFA2"
    
    	#IFDEF TOP
			If (TcSrvType ()<>"AS/400")
				cSelect	:=	"%CFA.CFA_PERAPU, CFA.CFA_ALIQ, CFA_CREDIF,CFA_TPCON, CFA_CODCRE%"
				cFrom	:=	"%"+RetSqlName("CFA")+" CFA %"
				cWhere	:=	"%CFA.CFA_FILIAL='"+xFilial("CFA")+"' AND "
				cWhere	+=	"CFA.CFA_PERAPU='"+aPar[1]+"' AND "
				cWhere	+=	"CFA.D_E_L_E_T_=''%"
			Else
		#ENDIF
				cFiltro	:= 'CFA_FILIAL=="'+xFilial("CFA")+'" .And. '
	   			cFiltro += 'CFA_PERAPU =="'+ aPar[1] + '"'
		#IFDEF TOP
			EndIf
		#ENDIF
    Elseif cTabela=="CFB"
    
    	#IFDEF TOP
			If (TcSrvType ()<>"AS/400")
				cSelect	:=	"%CFB.CFB_CODCON, CFB.CFB_TPCON, CFB.CFB_DTPGTO, CFB.CFB_PERDIF, CFB.CFB_CONREC, "
				cSelect	+=	"CFB.CFB_PERAPU, CFB.CFB_ALIQ,CFB.CFB_NATCRE, CFB.CFB_CREDES%"
				cFrom	:=	"%"+RetSqlName("CFB")+" CFB %"
				cWhere	:=	"%CFB.CFB_FILIAL='"+xFilial("CFB")+"' AND "
				cWhere	+=	"CFB.CFB_PERAPU='"+aPar[1]+"' AND "
				cWhere	+=	"CFB.CFB_TPCON='"+aPar[2]+"' AND "
				cWhere	+=	"CFB.D_E_L_E_T_=''%"
			Else
		#ENDIF
				cFiltro	:= 'CFB_FILIAL=="'+xFilial("CFB")+'" .And. '
	   			cFiltro += 'CFB_PERAPU =="'+ aPar[1] + '" .And. '
	   			cFiltro += 'CFB_TPCON =="'+ aPar[2] + '"'	
		#IFDEF TOP
			EndIf
		#ENDIF	
    
    EndIf

	#IFDEF TOP
    	If (TcSrvType ()<>"AS/400")
    		cAlias	:=	SPEDGetAlias(cTabela)
			BeginSql Alias cAlias
			
				SELECT 
					%Exp:cSelect%
			
				FROM 
					%Exp:cFrom%
			
				WHERE 
					%Exp:cWhere+cOrderBy%

				//%Exp:cOrderBy%
			EndSql
			
			If !lCountReg
				For nI := 1 To Len(aSetField)
					TcSetField(cAlias,aSetField[nI,1],aSetField[nI,2],aSetField[nI,3],aSetField[nI,4])
				Next
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se o retorno deve ser a quantidade de registros, armazeno em uma variavel para retornar³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lCountReg
				nRecCount	:=	(cAlias)->COUNTREG
			EndIf
		Else
	#ENDIF	
		    cIndex	:= 	CriaTrab(Nil,.F.)
		    cTabela	:=	SubStr(cTabela,1,3)
		
		    IndRegua (cAlias,cIndex,(cTabela)->(IndexKey (nOrdDBF)),,cFiltro,,.F.)
		    nIndex := RetIndex(cAlias)
		
			#IFNDEF TOP
				DbSetIndex(cIndex+OrdBagExt())
			#ENDIF
			
			DbSelectArea (cAlias)
		    DbSetOrder (nIndex+1)
			(cAlias)->(DbGoTop ())
		    
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se o retorno deve ser a quantidade de registros, armazeno em uma variavel para retornar³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lCountReg
				nRecCount	:=	(cAlias)->(RecCount())
			EndIf
	#IFDEF TOP
		EndIf
	#ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Como jah armazenei em uma variavel o valor da quantidade de registros, ³
	//³  posso fechar a area. O retorno da quantidade eh atraves de um        ³
	//³  parametro passado por referencia. O retorno da funcao ainda continua ³
	//³  sendo .T. quando tiver registros ou .F. quando nao tiver.            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lCountReg
		SPEDFFiltro(2,"",cAlias)	
		
		lRet	:=	nRecCount>0

	ElseIf !(cAlias)->(Eof())
		lRet	:=	.T.
		
	Else
		SPEDFFiltro(2,"",cAlias)
	EndIf
	
Else  

	#IFDEF TOP
		If (TcSrvType ()<>"AS/400")
			If Select(cAlias)<>0
				(cAlias)->(DbCloseArea())
			EndIf
		Else
	#ENDIF
			RetIndex(cAlias)
	#IFDEF TOP
		EndIf
	#ENDIF

EndIf

Return lRet
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³MyGetEnd  ³ Autor ³Gustavo G. Rueda              ³ Data ³22.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se o participante e do DF, ou se tem um tipo de endereco ³±±
±±³          ³ que nao se enquadra na regra padrao de preenchimento de endereco  ³±±
±±³          ³ por exemplo: Enderecos de Area Rural (essa verificção e feita     ³±±
±±³          ³ atraves do campo ENDNOT).                                         ³±±
±±³          ³ Caso seja do DF, ou ENDNOT = 'S', somente ira retornar o campo    ³±±
±±³          ³ Endereco (sem numero ou complemento). Caso contrario ira retornar ³±±
±±³          ³ o padrao do FisGetEnd                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Obs.     ³ Esta funcao so pode ser usada quando ha um posicionamento de      ³±±
±±³          ³ registro, pois será verificado o ENDNOT do registro corrente      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS                                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MyGetEnd(cEndereco,cAlias,cAlsQry)

Local cCmpEndN	:= SubStr(cAlias,2,2)+"_ENDNOT"
Local cCmpEst	:= SubStr(cAlias,2,2)+"_EST"
Local aRet		:= {"",0,"",""}

Default	cAlsQry	:=	""

//Tratamento para quando os campos base estiverem no select
If Empty(cAlsQry)
	cAlsQry	:=	cAlias
EndIf

//Campo ENDNOT indica que endereco participante mao esta no formato <logradouro>, <numero> <complemento>
//Se tiver com 'S' somente o campo de logradouro sera atualizado (numero sera SN)
If (&(cAlsQry+"->"+cCmpEst) == "DF") .Or. ((cAlias)->(FieldPos(cCmpEndN)) > 0 .And. &(cAlsQry+"->"+cCmpEndN) == "1")
	aRet[1] := cEndereco
	aRet[3] := "SN"
Else
	aRet := FisGetEnd(cEndereco,&(cAlsQry+"->"+cCmpEst))
EndIf

Return aRet
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RetStr    ³ Autor ³Gustavo G. Rueda       ³ Data ³16.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³  RECEBE, TRANSFORMA E RETORNA A STRING NO FORMATO EXIGIDO  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Transforma a string ou valor passado para o padrao exigido  ³±±
±±³          ³ pelo leyout.                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³xRet -> A string ou valor no padrao do layout               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|xValor -> Conteudo a ser padronizado                        ³±±
±±³          ³nDec   -> Quantidade de decimais para valores numericos     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RetStr(xValor,nDec)
Local	xRet

If (ValType (xValor)=="N")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Todas as variaveis numericas que nao tiverem definicao de casas decimais     |
	//³serao convertidas para apresentarem 2 decimais                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (xValor==0)
		xRet	:=	"0"
	ElseIf nDec == NIL
		xRet	:=	AllTrim (StrTran (Str (xValor,,2), ".", ","))
	Else
		xRet	:=	AllTrim (StrTran (Str (xValor,,nDec), ".", ","))
	EndIf
	
ElseIf (ValType (xValor)=="C")
	xRet	:=	AllTrim (xValor)

ElseIf (ValType (xValor)=="D")
	xRet	:=	StrZero (Day(xValor),2)+StrZero(Month(xValor),2)+StrZero(Year(xValor),4)
	
Else
	xRet	:=	""
	
EndIf
Return(xRet)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³NoAcento  ³ Autor ³Gustavo G. Rueda       ³ Data ³22.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retira acentos das strings                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC1 -> Retorna a string convertida                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cString -> String a ser convertida                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function NoAcento(cString)
Local cChar  := ""
Local nX     := 0 
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
Local cTrema := "äëïöü"+"ÄËÏÖÜ"
Local cCrase := "àèìòù"+"ÀÈÌÒÙ" 
Local cTio   := "ãõ"
Local cCecid := "çÇ"

For nX:= 1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
		nY:= At(cChar,cAgudo)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCircu)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTrema)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCrase)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf		
		nY:= At(cChar,cTio)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("ao",nY,1))
		EndIf		
		nY:= At(cChar,cCecid)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("cC",nY,1))
		EndIf
	Endif
Next
For nX:=1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	If Asc(cChar) < 32 .Or. Asc(cChar) > 123 .Or. cChar $ '&'
		cString:=StrTran(cString,cChar,".")
	Endif
Next nX
cString := _NoTags(cString)
Return cString

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³FSModeloP7| Autor ³Gustavo G. Rueda  			   ³ Data ³29.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Recupera as informacoes do registro de inventario Mod. P7 contidas³±±
±±³          ³ no arquivo temporario.                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cArquivo - Nome do arquivo a ser importado                        ³±±
±±³          ³ nTipo    - Tipo de Saldo a Ser Considerado:                       ³±±
±±³          ³            1 - Saldo em Estoque                                   ³±±
±±³          ³            2 - Saldo em Processo                                  ³±±
±±³          ³            4 - Saldo De Terceiros                                 ³±±
±±³          ³            5 - Saldo Em Terceiros                                 ³±±
±±³          ³ aRetInv  - Array de retorno contendo as informacoes do Sped Fiscal³±±
±±³          ³            Array[n,1] - Codigo do produto                         ³±±
±±³          ³            Array[n,2] - Unidade de Medida                         ³±±
±±³          ³            Array[n,3] - Quantidade                                ³±±
±±³          ³            Array[n,4] - Valor Unitario                            ³±±
±±³          ³            Array[n,5] - Valor Total                               ³±±
±±³          ³            Array[n,6] - Cliente/Fornecedor                        ³±±
±±³          ³            Array[n,7] - Loja                                      ³±±
±±³          ³lExtTaf   -> Indica que a chamada da funcao eh o Extrator   	     ³±±
±±³          ³			   TAF											         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS                                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function FSModeloP7(cArquivo,nTipo,aRetInv,aWizard,lExtTaf)
Local aAreaAnt := GetArea()
Local cAlias   := ""
Local cIndTmp1 := "" 
Local lAglH010 := GetNewPar("MV_AGLH010",.F.)
Local cProd	   := ""
Local cArmazem := "" 
Local lArmazem := .F.      
Local nWiz     := 0

Default cArquivo := ""
Default nTipo    := ""
Default aRetInv  := {}
Default aWizard  := {}
Default lExtTaf  := .F.

If !lExtTaf
	nWiz := 4
Else
	nWiz := 2
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifico se o arquivo base da movimentacao foi passado para processamento³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cArquivo)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Somente os tipos permitidos³
	//³                           ³
	//³1 - Saldo em Estoque       ³
	//³2 - Saldo em Processo      ³
	//³4 - Saldo De Terceiros     ³
	//³5 - Saldo Em Terceiros     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nTipo==1 .Or. nTipo==2 .Or. nTipo==4 .Or. nTipo==5

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifico a existencia do arquivo gerado pelo MATR460³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If MSFile(cArquivo+GetDBExtension(),,__LocalDriver)
			
			cFiltro		:=	"SITUACAO=='"+Str(nTipo,1)+"'"  	
			cAlias   := GetNextAlias()
			cIndTmp1 := CriaTrab(Nil,.F.)             	
			dbUseArea(.T.,__LocalDriver,cArquivo,cAlias)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Tratamento para comportar o processamento de muti-filiais³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !(cAlias)->(FieldPos("FILIAL"))>0
				Alert("Bloco H: Houveram mudanças no layout do relatório Modelo P7 referente ao processamento de filiais. Favor atualizar o repositório e gerar os arquivos novamente.")
			Else
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Monto o filtro do arquivo solicitado conforme tipo passado³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	   		
				IndRegua(cAlias,cIndTmp1,"FILIAL+PRODUTO+SITUACAO+CLIFOR+LOJA	",,cFiltro)
				dbClearIndex()
				dbSetIndex(cIndTmp1+OrdBagExt())
				dbSetOrder(1)
				
				lArmazem := (cAlias)->(Fieldpos("ARMAZEM")) > 0
				
				While !(cAlias)->(Eof())   	 
				
					cProd	 :=	PadR(Alltrim((cAlias)->PRODUTO),TamSX3("B1_COD")[1])
					
					If Len(aWizard) > 0					                                 
		                If lArmazem 	                
	   						cArmazen := PadR(Alltrim((cAlias)->ARMAZEM),TamSX3("B1_LOCPAD")[1])   											
							If (!Empty(aWizard[nWiz][1]+aWizard[nWiz][2]) .And. ;
							   (cProd < aWizard[nWiz][1] .Or. cProd > aWizard[nWiz][2])) .Or. ;
							   (!Empty(aWizard[nWiz][3]+aWizard[nWiz][4]) .And. ;
							   (cArmazen < aWizard[nWiz][3] .Or. cArmazen > aWizard[nWiz][4]))						   							   
							   	(cAlias)->(dbSkip())
							   	Loop						   							   	
							EndIf          	
						Else
							SB1->(DbSetOrder(1))
							SB1->(MsSeek(xFilial("SB1")+cProd))
							If (!Empty(aWizard[nWiz][1]+aWizard[nWiz][2]) .And. ;
							   (cProd < aWizard[nWiz][1] .Or. cProd > aWizard[nWiz][2])) .Or. ;
							   (!Empty(aWizard[nWiz][3]+aWizard[nWiz][4]) .And. ;
							   (SB1->B1_LOCPAD < aWizard[nWiz][3] .Or. SB1->B1_LOCPAD > aWizard[nWiz][4]))																												
							   	(cAlias)->(dbSkip())
							   	Loop						   							   	
							EndIf
						EndIf
		            EndIf
			            
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Efetuo o processamento do arquivo solicitado conforme tipo passado³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			    	If 	lAglH010 .And.;
			    		((cAlias)->SITUACAO == "4" .Or. (cAlias)->SITUACAO == "5") .And.;
						aScan(aRetInv,{|x|x[1] == cProd}) > 0
						
							nPos := Ascan(aRetInv,{|x|x[1] == (cAlias)->PRODUTO})
							aRetInv[nPos][3] += (cAlias)->QUANTIDADE
							aRetInv[nPos][4] += (cAlias)->VALOR_UNIT
							aRetInv[nPos][5] += (cAlias)->TOTAL			
		   			Else    
					     aAdd(aRetInv,{cProd,;				// 01 - Produto.
					                (cAlias)->UM,;         // 02 - Unidade. 
					                (cAlias)->QUANTIDADE,; // 03 - Quantidade.
					                (cAlias)->VALOR_UNIT,; // 04 - Valor Unidade.
					                (cAlias)->TOTAL,;      // 05 - Valor Total.
					                (cAlias)->CLIFOR,;     // 06 - Codigo do Cliente/Fornecedor.
					                (cAlias)->LOJA,;       // 07 - Codigo da loja Cliente/Fornecedor.
	 				                (cAlias)->SITUACAO,;   // 08 - Situacao do estoque.
					                (cAlias)->TPCF,;       // 09 - Cliente/Fornecedor.																
				    	            (cAlias)->FILIAL})		// 10 - Filial.																
					EndIF
					(cAlias)->(dbSkip())																				
				End
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Fecho o alias criado para o arquivo de trabalho³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Select(cAlias) > 0 
				(cAlias)->(dbCloseArea())
			EndIf	
		EndIf
	EndIf
EndIf                                                                                

RestArea(aAreaAnt)
Return 
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³SPEDOpenEn³ Autor ³Gustavo G. Rueda       ³ Data ³31.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de inicializacao de ambiente de processamento.       ³±±
±±³          ³Abre todas as tabelas a serem utilizadas e valida os campos ³±±
±±³          ³ criados pelo UPDFIS                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nil                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³lTabComp -> Flag de existencias das tabelas de complementos ³±±
±±³          ³lTabCDT  -> Flag de existencia da tabela CDT                ³±±
±±³          ³lTabCD0  -> Flag de existencia da tabela CD0                ³±±
±±³          ³lIntTMS  -> Flag como retorno da funcao INTTMS()            ³±±
±±³          ³lCmpsVld -> Flag de validacao dos campos criados pelo UPDFIS³±±
±±³          ³lTabCE5  -> Flag de existencia da tabela CE5                ³±±
±±³          ³lTabCD1  -> Flag de existencia da tabela CD1                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPEDOpenEnv(lTabComp,lTabCDT,lTabCD0,lIntTMS,lCmpsVld,lTabCE5,lTabCD1)
Local	nX			:=	0
Local	cAlsUpd		:=	""
Local	cCmpUpd		:=	""
Local	cCmpsNaoEx	:=	""
Local	aCmpsUpd	:=	{"SF4->F4_VLAGREG",	"SFT->FT_CSTPIS",	"SFT->FT_CSTCOF",	"SF6->F6_AUTENT",	"SFT->FT_CHVNFE",	"CD5->CD5_ACDRAW",;
				   		"CD6->CD6_UFPLAC",	"SF4->F4_MOVFIS",	"SF4->F4_CSOSN",	"SFT->FT_PAUTPIS",	"SFT->FT_PAUTCOF",	"SFT->FT_PAUTIPI",;
				   		"SFU->FU_GRUPT",	"SFU->FU_TIPLIGA",	"SFU->FU_CLASSIF",	"SFX->FX_TPASSIN",	"SF9->F9_QTDPARC",	"SF9->F9_SLDPARC",;
				   		"SFA->FA_TOTSAI",	"SFA->FA_TOTTRIB",	"CDL->CDL_DOCORI",	"CDL->CDL_SERORI",	"CDL->CDL_NFEXP",	"CDL->CDL_SEREXP",;
				   		"CDL->CDL_ESPEXP",	"CDL->CDL_EMIEXP",	"CDL->CDL_CHVEXP",	"CDL->CDL_QTDEXP",	"CDL->CDL_FORNEC",	"CDL->CDL_LOJFOR",;
				   		"SF3->F3_CHVNFE",	"SFU->FU_GRUPT",	"SA4->A4_COD_MUN",	"SA1->A1_REGPB",	"SA4->A4_SUFRAMA",	"SF3->F3_CODRSEF",;
				   		"SF9->F9_ITEMNFS",	"SFT->FT_RGESPST",	"CDH->CDH_GNREF3",	"SF6->F6_NUMPROC",	"SF6->F6_INDPROC",	"SF6->F6_DESCOMP",;
				   		"SA1->A1_SIMPNAC",	"SA2->A2_SIMPNAC", 	"SF4->F4_COMPONE", 	"SF9->F9_TIPO", 	"SF9->F9_CODBAIX",  "CC6->CC6_CLANAP",;
				   		"CDA->CDA_IFCOMP",	"CC7->CC7_IFCOMP",	"SF3->F3_CLASCO",	"SF1->F1_TPCTE", 	"SF4->F4_CODOBSE",  "CDT->CDT_SITEXT",;
				   		"CDT->CDT_DTAREC",  "CDL->CDL_ITEMNF",  "CDL->CDL_PRODNF",  "CDL->CDL_ITEORI",  "CDL->CDL_PRDORI", "SF4->F4_CONSUMO",;
				   		"SFT->FT_NATOPER"}

				 	
lTabCDT		:= 	AliasIndic("CDT")	
lTabCD0		:=	AliasIndic("CD0")
lTabCD1		:=	AliasIndic("CD1")
lTabCE5		:=	AliasIndic("CE5") .And. AliasIndic("CE6") .And. AliasIndic("CE7")
lIntTMS		:=	IntTms()
lCmpsVld	:=	.T.
lTabComp	:=	AliasIndic("SFU") .And. AliasIndic("SFX") .And. AliasIndic("CD3") .And. AliasIndic("CD4") .And. ;
				AliasIndic("CD5") .And. AliasIndic("CD6") .And. AliasIndic("CD7") .And. AliasIndic("CD8") .And. ;
				AliasIndic("CD9") .And. AliasIndic("CDB") .And. AliasIndic("CDC") .And. AliasIndic("CDD") .And. ;
				AliasIndic("CDE") .And. AliasIndic("CDF") .And. AliasIndic("CDG") .And. AliasIndic("CDL") .And. ;
				AliasIndic("CDA") .And. AliasIndic("CDO") .And. AliasIndic("CC6")
				
IF lTabCD1	
	aAdd(aCmpsUpd,"CD1->CD1_FILIAL")
 	aAdd(aCmpsUpd,"CD1->CD1_CODNAT")	
  	aAdd(aCmpsUpd,"CD1->CD1_DESCR")	
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³DEFINICAO DE ORDEM DAS TABELAS³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea ("SFT")	//Livro Fiscal por item
SFT->(DbSetOrder (1))
DbSelectArea ("SX5")	//Tabelas Genericas
SX5->(DbSetOrder (1))
DbSelectArea ("SA1")	//Cadastro do Cliente/Fornecedor
SA1->(DbSetOrder (1))
DbSelectArea ("SA2")	//Cadastro do Cliente/Fornecedor
SA2->(DbSetOrder (1))		
DbSelectArea ("SA4")	//Cadastro do Transportadoras
SA4->(DbSetOrder (1))
DbSelectArea ("SF1")	//Cabecalho das Notas Fiscais de Entrada/Saida
SF1->(DbSetOrder (1))		
DbSelectArea ("SF2")	//Cabecalho das Notas Fiscais de Entrada/Saida
SF2->(DbSetOrder (1))				
DbSelectArea ("SF3")	//Posicionando Livros Fiscais
SF3->(DbSetOrder (1))
DbSelectArea ("SF4")	//Cadastro de TES
SF4->(DbSetOrder (1))
DbSelectArea ("SF6")	//GNRE
SF6->(DbSetOrder (1))
DbSelectArea ("SD1")	//Itens das NF´s de Entrada
SD1->(DbSetOrder (1))
DbSelectArea ("SD2")	//Itens das NF´s de Saida
SD2->(DbSetOrder (3))
DbSelectArea ("SB1")	//Cadastro de Produtos
SB1->(DbSetOrder (1))
DbSelectArea ("SB5")	//Complemento de Produto
SB5->(DbSetOrder (1))	
DbSelectArea ("SB8")	//Saldos por Lote
SB8->(DbSetOrder (3))
DbSelectArea ("SAH")	//Unidades de Medida
SAH->(DbSetOrder (1))	
DbSelectArea ("SX6")
SX6->(DbSetOrder (1))
dbSelectArea("SFA")     //Apropriacoes CIAP         
SFA->(dbSetOrder(1))
dbSelectArea("SF9")     //Cadastro CIAP
SF9->(dbSetOrder(1))

If lTabComp
	DbSelectArea ("CC6")	//Lançamentos de apuração de ICMS
	CC6->(DbSetOrder (1))
	DbSelectArea ("CD3")	//Complemento de Gas
	CD3->(DbSetOrder (1))
	DbSelectArea ("CD4")	//Complemento de Agua Canalizada
	CD4->(DbSetOrder (1))
	DbSelectArea ("CD5")	//Complemento de Importação
	CD5->(DbSetOrder (1))
	DbSelectArea ("CD6")	//Complemento de Combustiveis
	CD6->(DbSetOrder (1))
	DbSelectArea ("CD7")	//Complemento de Medicamentos
	CD4->(DbSetOrder (1))
	DbSelectArea ("CD8")	//Complemento de Armas de Fogo
	CD5->(DbSetOrder (1))
	DbSelectArea ("CD9")	//Complemento de Veiculo Automotor
	CD6->(DbSetOrder (1))
	DbSelectArea ("CDA")	//Lancamentos de apuracao por Documento Fiscal
	CDA->(DbSetOrder (1))
	DbSelectArea ("CDH")	//Arquivo de apuracoes de ICMS
	CDH->(DbSetOrder (1))
	DbSelectArea ("CDG")	//Processos referenciados no documento
	CDG->(DbSetOrder (1))
	DbSelectArea ("CDC")	//Guias de Recolhimento Referenciada no documento
	CDC->(DbSetOrder (1))
	DbSelectArea ("CDD")	//Documentos Referenciados
	CDD->(DbSetOrder (1))
	DbSelectArea ("CDE")	//Cupom Fiscal Referenciado
	CDE->(DbSetOrder (1))
	DbSelectArea ("CDF")	//Local de Coleta Entrega
	CDF->(DbSetOrder (1))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caso o campo CDL_ITEMNF exista no banco de dados deve ser utilizado na composicao      ³
	//³da ordem de exibicao dos registros devido a implementacao da amarracao do documento de ³
	//³exportacao ao item da nota fiscal                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	    				
	DbSelectArea ("CDL")	//Complemento de Exportacao
 	SIX->(DbSetOrder(1))
    If SIX->(DbSeek("CDL2"))
		CDL->(DbSetOrder(2))
    Else
	   	CDL->(DbSetOrder(1))
    EndIf    
	DbSelectArea ("CCE")	//Informacoes Complementares
	CCE->(DbSetOrder (1))
	DbSelectArea ("SFU")	//Informacoes complementares das NF de Energia Eletrica
	SFU->(DbSetOrder (1))
	DbSelectArea ("SFX")	//Informacoes complementares das NF de Comunicacao/Telecomunicacao
	SFX->(DbSetOrder (1))
	If AliasIndic("CDO")
		DbSelectArea ("CDO")//Ajustes manuais de apuração de ICMS
		CDO->(DbSetOrder (1))
	EndIf
	If AliasIndic("CDP")
		DbSelectArea ("CDP")//Tabela da apuração de IPI
		CDP->(DbSetOrder(1))
	EndIf
	If AliasIndic("CCK")
		DbSelectArea ("CCK")//Ajustes da apuração de IPI
		CCK->(DbSetOrder (1))
	EndIf
EndIf
If AliasIndic("AIF")
	DbSelectArea ("AIF")	//Historico de ALteracoes SA1/SA2/SB1
	AIF->(DbSetOrder (1))
EndIf

If lIntTMS
	DbSelectArea ("DT6")	//Documentos de Transporte
	DT6->(DbSetOrder (1))	
	DbSelectArea ("DTC")	//Notas Fiscais do Cliente
	DTC->(DbSetOrder (3))	
	DbSelectArea ("DUD")	//Movimento da Viagem
	DUD->(DbSetOrder (1))		
	DbSelectArea ("DTQ")	//Viagem
	DTQ->(DbSetOrder (2))		
	DbSelectArea ("DTR")	//Veiculos da viagem
	DTR->(DbSetOrder (1))
	DbSelectArea ("DT8")	//Composicao do frete
	DT8->(DbSetOrder (2))
	DbSelectArea ("DUY")	//Grupos de Regioes
	DUY->(DbSetOrder(1))	
EndIf

DbSelectArea ("DA3")	//Cadastro de Veiculos
DA3->(DbSetOrder (1))		
DbSelectArea ("DB2")	//Aviso de recebimento de carga
DB2->(DbSetOrder (1))	
DbSelectArea ("DB1")	//Cabecalho do documento de recebimento
DB1->(DbSetOrder (1))
DbSelectArea ("DB3")	//Itens do documento de recebimento
DB3->(DbSetOrder (1))
DbSelectArea("SC7")		//Pedido de Compra
SC7->(DbSetOrder(1))
DbselectArea("SC5")		//Pedido de venda
SC5->(DbSetOrder(1))	
DbselectArea("SN1")		//Cadastro Ativo
SN1->(DbSetOrder(4))	
DbselectArea("SN3")		//Ativo X Classificacao
SN3->(DbSetOrder(1))	

If lTabCE5
	DbSelectArea("CE5")		//Controle de Crédito de ICMS
	CE5->(DbSetOrder(2))
	DbSelectArea("CE6")		//Saldo de Crédito de ICMS
	CE6->(DbSetOrder(1))
Endif	

If CtbInUse()
	dbSelectArea("CT1")		//Cadastro de conta contabil quando CTB
	CT1->(dbSetOrder(1))
	dbSelectArea("CTT")		//Cadastro de centro de custo quando CTB
	CTT->(dbSetOrder(1))		
Else
	dbSelectArea("SI1")		//Cadastro de conta contabil quando SIGACON
	SI1->(dbSetOrder(1))
	dbSelectArea("SI3") 	//Cadastro de centro de custo quando SIGACON
	SI3->(dbSetOrder(1))		
EndIf

If lTabCD0
	dbSelectarea("CD0")	//Complemento de ressarcimento
	dbSetOrder(1)
EndIF

If lTabCD1
	dbSelectarea("CD1")	//Natureza da Operacao/Prestacao
	dbSetOrder(1)
EndIF

If AliasIndic("CDV")	
	DbSelectArea("CDV")		//Informacoes adicionais a Apuracao de ICMS
	CDV->(DbSetOrder(1))
EndIf

dbSelectArea("SLG")
SLG->(dbSetOrder(1))

dbSelectArea("SFI")
If SIX->(dbSeek("SFI"+"3"))
	SFI->(DbSetorder(3))
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³TODOS OS CAMPOS NOVOS DEVEM ESTAR NESTA CONDICAO E DEVEM SER TRATADOS EXISTINDO OU³
//³         NAO NA BASE DE DADOS, DEVE TER UM CONTEUDO PADRAO CASO NAO EXISTA        ³
//³                                                                                  ³
//³Flag de existencia dos campos criados pelo UPDFIS e que sao utilizados pela rotina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 To Len(aCmpsUpd)
	cAlsUpd	:=	AllTrim(SubStr(aCmpsUpd[nX],1,3))
	cCmpUpd	:=	AllTrim(SubStr(aCmpsUpd[nX],6))

	If (cAlsUpd)->(FieldPos(cCmpUpd))==0
		cCmpsNaoEx	+=	cAlsUpd+"->"+cCmpUpd+", "
	EndIf
Next nX
cCmpsNaoEx	:=	Iif(!Empty(cCmpsNaoEx),Left(cCmpsNaoEx, Len(cCmpsNaoEx)-2),cCmpsNaoEx)
lCmpsVld	:=	Empty(cCmpsNaoEx)
				
Return cCmpsNaoEx

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³SPEDSeek  | Autor ³Gustavo G. Rueda 			   ³ Data ³02.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Funcao de posicionamento de tabelas especifica para o SPED Fiscal. ³±±
±±³          ³ Onde ora posiciono pelo RECNO e ora pelo Seek.                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cAlias - Alias da tabela que serah efetuado o posicionamento      ³±±
±±³          ³ nOrder - Ordem da tabela que serah utilizada para posicionamento. ³±±
±±³          ³ cSeek  - Chave de seek para a ordem selecionada. (QUANDO FOR EFE- ³±±
±±³          ³          TUAR O MSSEEK)                                           ³±±
±±³          ³ nRecno - RECNO da tabela em caso de DBGOTO()                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPEDSeek(cAlias,nOrder,cSeek,nRecno)
Local	lRet		:=	.F.
Local	lTop		:=	.F.
Local	lProcSeek	:=	.T.

Default	nOrder	:=	0

#IFDEF TOP
	If TcSrvType() <> "AS/400"
		lTop 		:= 	.T.		
		lProcSeek	:=	.F.
	Endif
#ENDIF

If lTop
	If nRecno<>Nil .And. nRecno>0
		If (cAlias)->(Recno())<>nRecno
			(cAlias)->(dbGoTo(nRecno))
		EndIf
		lRet	:=	.T.

	ElseIf nRecno==Nil
		lProcSeek	:=	.T.
	EndIf
EndIf

If lProcSeek .And. cSeek<>Nil	
	If nOrder==0
		nOrder	:=	(cAlias)->(IndexOrd())
	EndIf

	(cAlias)->(dbSetOrder(nOrder))

	lRet	:=	(cAlias)->(MSSeek(cSeek))
EndIf

Return lRet
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |SPEDGrvLin³ Autor ³Gustavo G. Rueda       ³ Data ³16.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³      GRAVACAO DE UM REGISTRO E MARCA COMO GRAVADO          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Gravo o registro posicionado do TRB e marco ele como ja gra-³±±
±±³          ³ vado evitanto duplicidade.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nil                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|nHandle -> Handle do arquivo txt aberto.                    ³±±
±±³          |cAlias -> Alias do TRB criado atraves da funcao principal.  ³±±
±±³          |cTpReg -> Tipo de registro que compoe a chave de pesquisa.  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPEDGrvLin(nHandle, cAlias)	
	Local	cConteudo := AllTrim ((cAlias)->TRB_CONT)+Chr (13)+Chr (10)	//+"**"+(cAlias)->TRB_RELAC+"**"

	FWrite (nHandle, cConteudo, Len (cConteudo))

	RecLock (cAlias, .F.)
		(cAlias)->TRB_FLAG	:=	"*"
	MsUnLock ()
Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³SPEDQryPri| Autor ³Gustavo G. Rueda  			   ³ Data ³24.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Funcao que retorna o valor de reducao da base de calculo do ICMS   ³±±
±±³          ³ utilizando a regra convencional (SENTO/OUTROS/BASE) ou recalcu-   ³±±
±±³          ³ conforme percentual de reducao gravada na tabela CD2              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                                   ³±±
±±³          ³nOpc      -> Opcao de utilizacao da funcao, 1 eh para retornar um  ³±±
±±³          ³             reccount de registros e dieferente de 1 eh para retor-³±±
±±³          ³             nar as informacoes.                                   ³±±
±±³          ³cTpMov    -> Tipo de movimentacao, E=Entrada, S=Saida              ³±±
±±³          ³dDataDe   -> Data inicial do periodo                               ³±±
±±³          ³dDataAte  -> Data final do periodo                                 ³±±
±±³          ³lCstPis   -> Flag de existencia de campo FT_CSTPIS                 ³±±
±±³          ³lCstCof   -> Flag de existencia do campo FT_CSTCOF                 ³±±
±±³          ³aF2EspVol -> Array com os campos da tabela F2 de volume/especie    ³±±
±±³          ³lTabComp  -> Flag de existencia das tabelas do SPED Fiscal         ³±±
±±³          ³lIntTMS   -> Flag que identifica a integracao com o TMS            ³±±
±±³          ³cNrLivro  -> Numero do livro de processamento selecionado no wizard³±±
±±³          ³cAliasSFT -> Alias da tabela SFT a ser retornada por referencia    ³±±
±±³          ³lTabCD0   -> Flag de existencia da tabela CD0 - Compl Ressarcimento³±±
±±³          ³lTabCD1   -> Flag de existencia da tabela CD1 - Natureza Oper/Prest³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpN1 - 0=Nao tem movimento e maior que ZERO identifica com movimto³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPEDQryPri(nOpc,cTpMov,dDataDe,dDataAte,lCstPis,lCstCof,aF2EspVol,lTabComp,lIntTMS,cNrLivro,cAliasSFT,lTabCD0,lTabCD1)
Local	cFiltro			:=	""
Local	cSlctSFT 		:=	""
Local	cSlctF1F2		:=	""
Local	cScan 			:= 	"1"
Local	cSlctD1D2		:=	""
Local	cSlctA1			:=	""
Local	cSlctA2			:=	""
Local	cSlctA4			:=	""
Local	cSlctF4			:=	""
Local	cSlct			:=	""
Local	cSlctAll		:=	""
Local	cJoinF3			:=	""
Local	cJoinD1D2		:=	""
Local	cJoinF1F2		:=	""
Local	cJoinSF4		:=	""
Local	cJoinSA4		:=	""
Local	cJoinCompl		:=	""
Local	nRecCount		:=	0
Local	cOrderBy		:=	"%%"
Local	cSlvAlias		:=	cAliasSFT
Local 	cMVDTINCB1		:= AllTrim(GetNewPar("MV_DTINCB1","B1_DATREF"))
Local	cPRDPRIB5		:= AllTrim(GetNewPar("MV_PRDPRI",""))
Local	aFieldDt		:=	{}
Local	nX				:=	0
Local 	cApurSep		:=	Alltrim(SuperGetMv("MV_APUSEP",.F.,""))
Local	aApurSep		:=	{}
Local	nPos			:=	0
Local	cApur			:=	""

For nPos := 1 to Len(cApurSep)
	cApur := Substr(cApurSep,nPos,1)
	If cApur$"123456789" .And. aScan(aApurSep, {|x| x==cApur})==0
		aAdd(aApurSep, cApur)
	EndIf
Next nPos

DbSelectArea (cAliasSFT)
(cAliasSFT)->(DbSetOrder(2))

#IFDEF TOP
    If (TcSrvType ()<>"AS/400")
    	cFiltro := "%"
		If cNrLivro <> "*"
			If Len(aApurSep)>0
				cFiltro += " ( "
				For nX := 1 To Len(aApurSep)
					cFiltro += " SFT.FT_NRLIVRO = '" +%Exp:(aApurSep[nX])% +"' OR "
				Next nX
				cFiltro += " SFT.FT_NRLIVRO = '" +%Exp:(cNrLivro)% +"' ) AND "
			Else
				cFiltro += " SFT.FT_NRLIVRO = '" +%Exp:(cNrLivro)% +"' AND "
			EndIf
		EndIf
		cFiltro += "%"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Montagem do SELECT FULL em uma unica variavel, pois hora pode ser o SELECT³
		//³  normal e hora pode ser um SELECT COUNT()                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nOpc==1
			cSlctAll	:=	"COUNT(*) SFTCOUNT"
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Campos da tabela SFT³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cSlctSFT := "SFT.FT_FILIAL,  SFT.FT_TIPOMOV,	SFT.FT_ENTRADA, SFT.FT_SERIE,   SFT.FT_NFISCAL, SFT.FT_CLIEFOR,"
			cSlctSFT += "SFT.FT_LOJA,    SFT.FT_ITEM,   	SFT.FT_PRODUTO, SFT.FT_NRLIVRO, SFT.FT_CFOP,    SFT.FT_ESPECIE, "
			cSlctSFT += "SFT.FT_TIPO,    SFT.FT_EMISSAO,	SFT.FT_DTCANC,  SFT.FT_FORMUL,  SFT.FT_ALIQPIS, SFT.FT_VALPIS, "
			cSlctSFT += "SFT.FT_ALIQCOF, SFT.FT_VALCOF, 	SFT.FT_VALCONT, SFT.FT_BASEICM, SFT.FT_VALICM,  SFT.FT_ISSST, "
			cSlctSFT += "SFT.FT_BASERET, SFT.FT_ICMSRET,	SFT.FT_VALIPI,  SFT.FT_ISENICM, SFT.FT_QUANT,   SFT.FT_DESCONT, "
			cSlctSFT += "SFT.FT_TOTAL,   SFT.FT_FRETE,  	SFT.FT_SEGURO,  SFT.FT_DESPESA, SFT.FT_OUTRICM, SFT.FT_BASEIPI, "
			cSlctSFT += "SFT.FT_ISENIPI, SFT.FT_OUTRIPI,	SFT.FT_ICMSCOM, SFT.FT_RECISS,  SFT.FT_BASEIRR, SFT.FT_ALIQICM, "
			cSlctSFT += "SFT.FT_ALIQIPI, SFT.FT_CTIPI,  	SFT.FT_POSIPI,  SFT.FT_CLASFIS, SFT.FT_PRCUNIT, SFT.FT_CFPS, "
			cSlctSFT += "SFT.FT_OBSERV,  SFT.FT_ESTADO, 	SFT.FT_CODISS,  SFT.FT_ALIQIRR, SFT.FT_VALIRR,  SFT.FT_BASEINS, "
			cSlctSFT += "SFT.FT_VALINS,  SFT.FT_PDV,    	SFT.FT_ISSSUB,  SFT.FT_CREDST,  SFT.FT_ISENRET, SFT.FT_OUTRRET, "
			cSlctSFT += "SFT.FT_CONTA,   SFT.FT_BASEPIS,	SFT.FT_BASECOF, SFT.FT_PESO,    SFT.FT_SOLTRIB, SFT.FT_NFORI, "
			cSlctSFT += "SFT.FT_SERORI,  SFT.FT_ITEMORI,	SFT.FT_IDENTF3, SFT.FT_OBSSOL, 	SFT.FT_FORMULA"
			If SFT->(FieldPos("FT_CHVNFE")) > 0
				cSlctSFT += ", SFT.FT_CHVNFE"
			Endif
			If lCstPis
				cSlctSFT += ", SFT.FT_CSTPIS"
			EndIf
			If lCstCof
				cSlctSFT += ", SFT.FT_CSTCOF"
			EndIf
			If SFT->(FieldPos("FT_PAUTPIS")) > 0
				cSlctSFT += ", SFT.FT_PAUTPIS"
			Endif
			If SFT->(FieldPos("FT_PAUTCOF")) > 0
				cSlctSFT += ", SFT.FT_PAUTCOF"
			Endif
			If SFT->(FieldPos("FT_VALPS3")) > 0
				cSlctSFT += ", SFT.FT_VALPS3"
			Endif
			If SFT->(FieldPos("FT_VALCF3")) > 0
				cSlctSFT += ", SFT.FT_VALCF3"
			Endif
			If SFT->(FieldPos("FT_RGESPST"))>0
				cSlctSFT += ", SFT.FT_RGESPST"
			EndIf
			If SFT->(FieldPos("FT_PAUTIPI"))>0
				cSlctSFT += ", SFT.FT_PAUTIPI"
			EndIF
			If SFT->(FieldPos("FT_DESCZFR"))>0
				cSlctSFT += ", SFT.FT_DESCZFR"
			Endif
			If SFT->(FieldPos("FT_AGREG"))>0
				cSlctSFT += ", SFT.FT_AGREG"
			Endif
			If SFT->(FieldPos("FT_DESCICM"))>0
				cSlctSFT += ", SFT.FT_DESCICM"
			Endif
			If SFT->(FieldPos("FT_NORESP"))>0
				cSlctSFT += ", SFT.FT_NORESP"
			Endif
			If SFT->(FieldPos("FT_NATOPER"))>0
				cSlctSFT += ", SFT.FT_NATOPER"
			Endif			
			If SFT->(FieldPos("FT_MALQCOF")) > 0 .And. SFT->(FieldPos("FT_MVALCOF")) > 0
				cSlctSFT += ", SFT.FT_MVALCOF , SFT.FT_MALQCOF "	
			EndIf

			cSlctSFT 	+= ","
			
			aAdd(aFieldDt,"FT_EMISSAO")
			aAdd(aFieldDt,"FT_ENTRADA")
			aAdd(aFieldDt,"FT_DTCANC")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Campos para o SELECT da tabela SB1³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cSlctSB1	:=	"SB1.B1_UM,      SB1.B1_SELO,    SB1.B1_TAB_IPI, SB1.B1_VLR_IPI, SB1.B1_TIPO,    SB1.B1_DESC, "
			cSlctSB1	+=	"SB1.B1_CODBAR,  SB1.B1_CODANT,  SB1.B1_POSIPI,  SB1.B1_EX_NCM,  SB1.B1_CODISS,  SB1.B1_PICM, "
			cSlctSB1	+=	"SB1.B1_FECP,    SB1.B1_CC,		 SB1.B1_SEGUM,   SB1.B1_TIPCONV, SB1.B1_CONV,    SB1.B1_VLR_PIS, "
			cSlctSB1	+=	"SB1.B1_VLR_COF, SB1.B1_CLASSE,  SB1.B1_CONTA,   SB1.B1_ORIGEM, SB1.B1_IMPORT,"
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Tratamento para um campo da tabela SB1 que podera ser utilizado no processamento, ³
			//³  este campo deve estar na query                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If "B1_"$cMVDTINCB1
				If SB1->(FieldPos(cMVDTINCB1))>0
					cSlctSB1	+=	cMVDTINCB1+","
					aAdd(aFieldDt,cMVDTINCB1)
				EndIf
			EndIf
			
			If !Empty(cPRDPRIB5)
				If SB5->(FieldPos(cPRDPRIB5))>0
					cSlctSB1	+=	"SB5."+cPRDPRIB5+","
				Endif
			Endif		
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Campos para o SELECT da tabela SF2 ou SF1³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aF2EspVol	:=	{}
			cSlctF1F2	:=	""
			If cTpMov=="E"				
				cSlctF1F2	+=	"SF1.F1_FRETE, SF1.F1_COND, SF1.F1_TIPO, SF1.F1_FORMUL, SF1.F1_ESPECIE, SF1.F1_DOC, SF1.F1_SERIE, "
				cSlctF1F2	+=	"SF1.F1_FORNECE, SF1.F1_LOJA, SF1.F1_EMISSAO, SF1.F1_PREFIXO, SF1.F1_DUPL, SF1.F1_CHVNFE, SF1.F1_HAWB "
				If SF1->(FieldPos("F1_TRANSP"))>0
					cSlctF1F2	+=	", SF1.F1_TRANSP "
				EndIf
				If SF1->(FieldPos("F1_TPFRETE"))>0
					cSlctF1F2	+=	", SF1.F1_TPFRETE "
				EndIf
				If SF1->(FieldPos("F1_TPCTE"))>0
					cSlctF1F2	+=	", SF1.F1_TPCTE "
				EndIf
				If SF1->(FieldPos("F1_MENNOTA"))>0
					cSlctF1F2	+=	", SF1.F1_MENNOTA "
				EndIf				
			Else
				cSlctF1F2	+=	"SF2.F2_FRETE, SF2.F2_COND, SF2.F2_TIPO, SF2.F2_FORMUL, SF2.F2_ESPECIE, SF2.F2_EMISSAO, SF2.F2_CLIENTE, "
				cSlctF1F2	+=	"SF2.F2_LOJA, SF2.F2_NFCUPOM, SF2.F2_PDV, SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_TRANSP, SF2.F2_VEICUL1, "
				cSlctF1F2	+=	"SF2.F2_VEICUL2, SF2.F2_VEICUL3, SF2.F2_PBRUTO, SF2.F2_PLIQUI, SF2.F2_PREFIXO, SF2.F2_DUPL, SF2.F2_ECF, "
				cSlctF1F2	+=	"SF2.F2_VALPIS, SF2.F2_VALCOFI, SF2.F2_FILIAL, SF2.F2_CHVNFE"
				
				If SF2->(FieldPos("F2_MENNOTA"))>0
					cSlctF1F2	+=	", SF2.F2_MENNOTA "
				EndIf
				
				cScan 		:= 	"1"
				While SF2->(FieldPos("F2_ESPECI"+cScan))>0 .Or. SF2->(FieldPos("F2_VOLUME"+cScan))>0
					If SF2->(FieldPos("F2_ESPECI"+cScan))>0
						cSlctF1F2	+=	",F2_ESPECI"+cScan
					EndIf
					If SF2->(FieldPos("F2_VOLUME"+cScan))>0
						cSlctF1F2	+=	",F2_VOLUME"+cScan
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Campos de volume utilizado no registro C160 e que estarao na query³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aAdd(aF2EspVol,{"F2_ESPECI"+cScan,,"F2_VOLUME"+cScan,})
	
					cScan := Soma1(cScan,1)
				EndDo
			EndIf
			cSlctF1F2 += ","
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Campos para o SELECT da tabela SD2 ou SD1³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If cTpMov=="E"
				cSlctD1D2	:=	"SD1.D1_TES,SD1.D1_TIPO,SD1.D1_UM,SD1.D1_PEDIDO,SD1.D1_ITEM,SD1.D1_SEGUM,SD1.D1_QTSEGUM,SD1.D1_DOC,"
				If SD1->(FieldPos("D1_DESCICM"))>0
					cSlctD1D2+="SD1.D1_DESCICM,"
				EndIf
			Else
				cSlctD1D2	:=	"SD2.D2_TES,SD2.D2_TIPO,SD2.D2_UM,SD2.D2_PEDIDO,SD2.D2_SEGUM,SD2.D2_QTSEGUM,SD2.D2_DOC,"
				If SD2->(FieldPos("D2_DESCICM"))>0
					cSlctD1D2+="SD2.D2_DESCICM,"
				EndIf
			EndIf
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Campos para o SELECT da tabela SA1, SA2 e SA4³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//Tabela SA1
			cSlctA1	:=	"SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_PESSOA, SA1.A1_CGC, SA1.A1_EST, SA1.A1_INSCR, SA1.A1_COD_MUN, "
			cSlctA1	+=	"SA1.A1_END, SA1.A1_BAIRRO, SA1.A1_INSCRM, SA1.A1_TIPO"
			If SA1->(FieldPos("A1_CODPAIS"))>0
				cSlctA1	+=	", SA1.A1_CODPAIS"
			EndIf
			If SA1->(FieldPos("A1_SUFRAMA"))>0
				cSlctA1	+=	", SA1.A1_SUFRAMA"
			EndIf
			If SA1->(FieldPos("A1_ENDNOT"))>0
				cSlctA1	+=	", SA1.A1_ENDNOT"
			EndIf
			If SA1->(FieldPos("A1_SIMPNAC"))>0
				cSlctA1	+=	", SA1.A1_SIMPNAC"
			EndIf
			If SA1->(FieldPos("A1_REGPB"))>0
				cSlctA1	+=	", SA1.A1_REGPB"
			EndIf			
			cSlctA1 += ","
			
			//Tabela SA2
			cSlctA2	:=	"SA2.A2_COD, SA2.A2_LOJA, SA2.A2_NOME, SA2.A2_TIPO, SA2.A2_CGC, SA2.A2_EST, SA2.A2_INSCR, SA2.A2_COD_MUN, "
			cSlctA2	+=	"SA2.A2_END, SA2.A2_BAIRRO, SA2.A2_INSCRM"
			If SA2->(FieldPos("A2_CODPAIS"))>0
				cSlctA2	+=	", SA2.A2_CODPAIS"
			EndIf
			If SA2->(FieldPos("A2_SUFRAMA"))>0
				cSlctA2	+=	", SA2.A2_SUFRAMA"
			EndIf
			If SA2->(FieldPos("A2_ENDNOT"))>0
				cSlctA2	+=	", SA2.A2_ENDNOT"
			EndIf
			If SA2->(FieldPos("A2_SIMPNAC"))>0
				cSlctA2	+=	", SA2.A2_SIMPNAC"
			EndIf
			cSlctA2 += ","
	
			//Tabela SA4
			cSlctA4	:=	"A4_COD, A4_NOME, A4_CGC, A4_INSEST, A4_EST, A4_END, A4_BAIRRO"
			If SA4->(FieldPos("A4_CODPAIS"))>0
				cSlctA4	+=	", SA4.A4_CODPAIS"
			EndIf
			If SA4->(FieldPos("A4_COD_MUN"))>0
				cSlctA4	+=	", SA4.A4_COD_MUN"
			EndIf
			If SA4->(FieldPos("A4_SUFRAMA"))>0
				cSlctA4	+=	", SA4.A4_SUFRAMA"
			EndIf
			If SA4->(FieldPos("A4_ENDNOT"))>0
				cSlctA4	+=	", SA4.A4_ENDNOT"
			EndIf
			cSlctA4 	+= ","
			
			//Tabela SF4
			cSlctF4	:=	"SF4.F4_VLAGREG, SF4.F4_SELO, SF4.F4_TEXTO, SF4.F4_ESTOQUE, SF4.F4_BASEICM, SF4.F4_SITTRIB, SF4.F4_CSTPIS, SF4.F4_CSTCOF, SF4.F4_ICM, SF4.F4_LFICM"
			If SF4->(FieldPos("F4_PISDSZF"))>0
				cSlctF4	+=	", SF4.F4_PISDSZF"
			EndIf
			If SF4->(FieldPos("F4_COFDSZF"))>0
				cSlctF4	+=	", SF4.F4_COFDSZF"
			EndIf
			If SF4->(FieldPos("F4_MOVFIS"))>0
				cSlctF4	+=	", SF4.F4_MOVFIS"
			EndIf
			If SF4->(FieldPos("F4_CSOSN"))>0
				cSlctF4	+=	", SF4.F4_CSOSN"
			EndIf
			If SF4->(FieldPos("F4_RGESPCI"))>0
				cSlctF4	+=	", SF4.F4_RGESPCI"
			Endif
			If SF4->(FieldPos("F4_OBSSOL"))>0
				cSlctF4	+=	", SF4.F4_OBSSOL"
			Endif
			If SF4->(FieldPos("F4_AGREG"))>0
				cSlctF4	+=	", SF4.F4_AGREG"
			Endif
			If SF4->(FieldPos("F4_CODOBSE"))>0
				cSlctF4	+=	", SF4.F4_CODOBSE"
			Endif
			If SF4->(FieldPos("F4_CONSUMO"))>0
				cSlctF4	+=	", SF4.F4_CONSUMO"
			Endif
			If SF4->(FieldPos("F4_OPERGAR"))>0  
				cSlctF4	+=	", SF4.F4_OPERGAR"
			Endif                        				
			cSlctF4 	+= 	","
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Campos do SELECT caso as tabelas estejam criadas na base de dados³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cSlct	:=	""
			If lTabComp
				cSlct	:=	"SFU.R_E_C_N_O_ SFURECNO"
				cSlct	+=	",SFX.R_E_C_N_O_ SFXRECNO"
				cSlct	+=	",CD3.R_E_C_N_O_ CD3RECNO"
				cSlct	+=	",CD7.R_E_C_N_O_ CD7RECNO"
				cSlct	+=	",CD8.R_E_C_N_O_ CD8RECNO"
				cSlct	+=	",CD9.R_E_C_N_O_ CD9RECNO"
				If SF4->(FieldPos("F4_CODOBSE"))>0
					cSlct	+=	",CCE.R_E_C_N_O_ CCERECNO"
				EndIf
			EndIf

			If lTabCD0
				cSlct	+=	",CD0.R_E_C_N_O_ CD0RECNO"
			EndIf
			
			If lTabCD1
				If SFT->(FieldPos("FT_NATOPER"))>0
					cSlct	+=	",CD1.R_E_C_N_O_ CD1RECNO"
				Endif	
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se houver integracao com o TMS, trago o recno do conhecimento³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lIntTMS
				cSlct	+=	",DT6.R_E_C_N_O_ DT6RECNO"			
			EndIf
			//cSlct	+=	","
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Concateno todas as variaveis individuais de SELECT para formar uma³
			//³  soh a ser utilizada no EMBEDED SQL                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cSlctAll	:=	cSlctSFT+cSlctSB1+cSlctD1D2+cSlctF4+cSlctF1F2+cSlctA1+cSlctA2+cSlctA4		
			cSlctAll	+=	"SF3.R_E_C_N_O_ SF3RECNO,"
			cSlctAll	+=	cSlct
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Tratamento retirado devido a um problema de JOIN em ambiente ORACLE, bug da versao 10G.                 ³
			//³Como estas duas informacoes nao estao sendo utilizadas no momento, estou desativando.                   ³
			//³                                                                                                        ³
			//³Error : 1445 - ORA-01445: cannot select ROWID from, or sample, a join view without a key-preserved table³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//cSlctAll	+=	"(SELECT COUNT(*) FROM "+RetSqlName("SF3")+" SF3A WHERE SF3A.F3_FILIAL='"+xFilial("SF3")+"' AND SF3A.F3_ENTRADA=SFT.FT_ENTRADA AND SF3A.F3_NFISCAL=SFT.FT_NFISCAL AND SF3A.F3_SERIE=SFT.FT_SERIE AND SF3A.F3_CLIEFOR=SFT.FT_CLIEFOR AND SF3A.F3_LOJA=SFT.FT_LOJA AND SF3A.F3_TIPO='S' AND SF3A.D_E_L_E_T_=' ') F3CTDTPS,"
			//cSlctAll	+=	"(SELECT COUNT(*) FROM "+RetSqlName("SF3")+" SF3B WHERE SF3B.F3_FILIAL='"+xFilial("SF3")+"' AND SF3B.F3_ENTRADA=SFT.FT_ENTRADA AND SF3B.F3_NFISCAL=SFT.FT_NFISCAL AND SF3B.F3_SERIE=SFT.FT_SERIE AND SF3B.F3_CLIEFOR=SFT.FT_CLIEFOR AND SF3B.F3_LOJA=SFT.FT_LOJA AND SF3B.F3_TIPO=' ' AND SF3B.D_E_L_E_T_=' ') F3CTDTPN
			
			cOrderBy	:=	"%ORDER BY 1,2,3,4,5,6,7,8,9%"
		EndIf
		cSlctAll	:=	"%"+cSlctAll+"%" 
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento para campos de tabelas que variam quando ENTRADA ou SAIDA³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		//JOIN SF3
		If cTpMov=="E"
			cJoinF3	:=	"SF3.F3_CFO<'5'"
		Else
			cJoinF3	:=	"SF3.F3_CFO>'4'"
		EndIf
		cJoinF3 := "%" + cJoinF3 + "%"
		
		//JOIN SD1 e SD2
		If cTpMov=="E"
			cJoinD1D2	:=	"LEFT JOIN "+RetSqlName("SD1")+" SD1 ON(SD1.D1_FILIAL='"+xFilial("SD1")+"'  AND SD1.D1_DOC=SFT.FT_NFISCAL AND SD1.D1_SERIE=SFT.FT_SERIE AND SD1.D1_FORNECE=SFT.FT_CLIEFOR AND SD1.D1_LOJA=SFT.FT_LOJA AND SD1.D1_COD=SFT.FT_PRODUTO AND SD1.D1_ITEM=SFT.FT_ITEM AND SD1.D_E_L_E_T_=' ') "
		Else
			cJoinD1D2	:=	"LEFT JOIN "+RetSqlName("SD2")+" SD2 ON(SD2.D2_FILIAL='"+xFilial("SD2")+"'  AND SD2.D2_DOC=SFT.FT_NFISCAL AND SD2.D2_SERIE=SFT.FT_SERIE AND SD2.D2_CLIENTE=SFT.FT_CLIEFOR AND SD2.D2_LOJA=SFT.FT_LOJA AND SD2.D2_COD=SFT.FT_PRODUTO AND SD2.D2_ITEM=SFT.FT_ITEM AND SD2.D_E_L_E_T_=' ') "
		EndIf
		cJoinD1D2 := "%" + cJoinD1D2 + "%"
		
		//JOIN SF1 e SF2
		If cTpMov=="E"
			cJoinF1F2	:=	"LEFT JOIN "+RetSqlName("SF1")+" SF1 ON(SF1.F1_FILIAL='"+xFilial("SF1")+"'  AND SF1.F1_DOC=SFT.FT_NFISCAL AND SF1.F1_SERIE=SFT.FT_SERIE AND SF1.F1_FORNECE=SFT.FT_CLIEFOR AND SF1.F1_LOJA=SFT.FT_LOJA AND SF1.D_E_L_E_T_=' ') "
		Else
			cJoinF1F2	:=	"LEFT JOIN "+RetSqlName("SF2")+" SF2 ON(SF2.F2_FILIAL='"+xFilial("SF2")+"'  AND SF2.F2_DOC=SFT.FT_NFISCAL AND SF2.F2_SERIE=SFT.FT_SERIE AND SF2.F2_CLIENTE=SFT.FT_CLIEFOR AND SF2.F2_LOJA=SFT.FT_LOJA AND SF2.D_E_L_E_T_=' ') "
		EndIf
		cJoinF1F2 := "%" + cJoinF1F2 + "%"
		
		//JOIN SF4
		If cTpMov=="E"
			cJoinSF4	:=	"SF4.F4_CODIGO=SD1.D1_TES"
		Else
			cJoinSF4	:=	"SF4.F4_CODIGO=SD2.D2_TES"
		EndIf
		cJoinSF4 := "%" + cJoinSF4 + "%"

		//JOIN SA4
		If cTpMov=="E"
			If SF1->(FieldPos("F1_TRANSP"))>0
				cJoinSA4	:=	"SA4.A4_COD=SF1.F1_TRANSP"
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Se nao existir o campo referente a transportadora nao trago nada.           ³
				//³Esta condicao (='') eh soh para nao ter que ficar tratando a existencia     ³
				//³  deste campo para ora montar o join ou nao. Este " ='' " faz com que       ³
				//³  a query nao retorne nada, pois nao eh possivel cadastrar codigo em branco.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cJoinSA4	:=	"SA4.A4_COD=''"
			EndIf
		Else
			cJoinSA4	:=	"SA4.A4_COD=SF2.F2_TRANSP"
		EndIf
		cJoinSA4 := "%" + cJoinSA4 + "%"
		 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tabelas do JOIN caso as mesmas estejam criadas no dicionario de dados³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lTabComp
			cJoinCompl	:=	"LEFT JOIN "+RetSqlName("SFU")+" SFU ON(SFU.FU_FILIAL='"+xFilial("SFU")+"' AND SFU.FU_TIPOMOV=SFT.FT_TIPOMOV AND SFU.FU_SERIE=SFT.FT_SERIE AND SFU.FU_DOC=SFT.FT_NFISCAL AND SFU.FU_CLIFOR=SFT.FT_CLIEFOR AND SFU.FU_LOJA=SFT.FT_LOJA AND SFU.FU_ITEM=SFT.FT_ITEM AND SFU.FU_COD=SFT.FT_PRODUTO AND SFU.D_E_L_E_T_='')"
			cJoinCompl	+=	"LEFT JOIN "+RetSqlName("SFX")+" SFX ON(SFX.FX_FILIAL='"+xFilial("SFX")+"'  AND SFX.FX_TIPOMOV=SFT.FT_TIPOMOV AND SFX.FX_SERIE=SFT.FT_SERIE AND SFX.FX_DOC=SFT.FT_NFISCAL AND SFX.FX_CLIFOR=SFT.FT_CLIEFOR AND SFX.FX_LOJA=SFT.FT_LOJA AND SFX.FX_ITEM=SFT.FT_ITEM AND SFX.FX_COD=SFT.FT_PRODUTO AND SFX.D_E_L_E_T_='') "
			cJoinCompl	+=	"LEFT JOIN "+RetSqlName("CD3")+" CD3 ON(CD3.CD3_FILIAL='"+xFilial("CD3")+"' AND CD3.CD3_TPMOV=SFT.FT_TIPOMOV AND CD3.CD3_SERIE=SFT.FT_SERIE AND CD3.CD3_DOC=SFT.FT_NFISCAL AND CD3.CD3_CLIFOR=SFT.FT_CLIEFOR AND CD3.CD3_LOJA=SFT.FT_LOJA AND CD3.CD3_ITEM=SFT.FT_ITEM AND CD3.CD3_COD=SFT.FT_PRODUTO AND CD3.D_E_L_E_T_='') "
			cJoinCompl	+=	"LEFT JOIN "+RetSqlName("CD7")+" CD7 ON(CD7.CD7_FILIAL='"+xFilial("CD7")+"' AND CD7.CD7_TPMOV=SFT.FT_TIPOMOV AND CD7.CD7_SERIE=SFT.FT_SERIE AND CD7.CD7_DOC=SFT.FT_NFISCAL AND CD7.CD7_CLIFOR=SFT.FT_CLIEFOR AND CD7.CD7_LOJA=SFT.FT_LOJA AND CD7.CD7_ITEM=SFT.FT_ITEM AND CD7.CD7_COD=SFT.FT_PRODUTO AND CD7.D_E_L_E_T_='') "
			cJoinCompl	+=	"LEFT JOIN "+RetSqlName("CD8")+" CD8 ON(CD8.CD8_FILIAL='"+xFilial("CD8")+"' AND CD8.CD8_TPMOV=SFT.FT_TIPOMOV AND CD8.CD8_SERIE=SFT.FT_SERIE AND CD8.CD8_DOC=SFT.FT_NFISCAL AND CD8.CD8_CLIFOR=SFT.FT_CLIEFOR AND CD8.CD8_LOJA=SFT.FT_LOJA AND CD8.CD8_ITEM=SFT.FT_ITEM AND CD8.CD8_COD=SFT.FT_PRODUTO AND CD8.D_E_L_E_T_='') "
			cJoinCompl	+=	"LEFT JOIN "+RetSqlName("CD9")+" CD9 ON(CD9.CD9_FILIAL='"+xFilial("CD9")+"' AND CD9.CD9_TPMOV=SFT.FT_TIPOMOV AND CD9.CD9_SERIE=SFT.FT_SERIE AND CD9.CD9_DOC=SFT.FT_NFISCAL AND CD9.CD9_CLIFOR=SFT.FT_CLIEFOR AND CD9.CD9_LOJA=SFT.FT_LOJA AND CD9.CD9_ITEM=SFT.FT_ITEM AND CD9.CD9_COD=SFT.FT_PRODUTO AND CD9.D_E_L_E_T_='') "
			If SF4->(FieldPos("F4_CODOBSE"))>0
				cJoinCompl	+=	"LEFT JOIN "+RetSqlName("CCE")+" CCE ON(CCE.CCE_FILIAL='"+xFilial("CCE")+"' AND CCE.CCE_COD=SF4.F4_CODOBSE AND CCE.D_E_L_E_T_='') "
			EndIf
		EndIf

		If lTabCD0
			cJoinCompl	+=	"LEFT JOIN "+RetSqlName("CD0")+" CD0 ON(CD0.CD0_FILIAL='"+xFilial("CD0")+"' AND CD0.CD0_TPMOV=SFT.FT_TIPOMOV AND CD0.CD0_SERIE=SFT.FT_SERIE AND CD0.CD0_DOC=SFT.FT_NFISCAL AND CD0.CD0_CLIFOR=SFT.FT_CLIEFOR AND CD0.CD0_LOJA=SFT.FT_LOJA AND CD0.CD0_ITEM=SFT.FT_ITEM AND CD0.CD0_COD=SFT.FT_PRODUTO AND CD0.D_E_L_E_T_='') "
		EndIf
		
		If lTabCD1
			If SFT->(FieldPos("FT_NATOPER"))>0
		  		cJoinCompl	+=	"LEFT JOIN "+RetSqlName("CD1")+" CD1 ON(CD1.CD1_FILIAL='"+xFilial("CD1")+"' AND CD1.CD1_CODNAT=SFT.FT_NATOPER AND CD1.D_E_L_E_T_='') "
		    Endif
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se houver integracao com o TMS, faco o JOIN das tabelas      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lIntTMS
			cJoinCompl	+=	"LEFT JOIN "+RetSqlName("DT6")+" DT6 ON(SFT.FT_TIPOMOV='S' AND DT6_FILIAL='"+xFilial("DT6")+"' AND DT6_FILDOC=SFT.FT_FILIAL AND DT6_DOC=SFT.FT_NFISCAL AND DT6_SERIE=SFT.FT_SERIE AND DT6.D_E_L_E_T_='') "
		EndIf
		
		//Se utilizar informacao de produto primario incluo JOIN com tabela SB5
		If !Empty(cPRDPRIB5)
			If SB5->(FieldPos(cPRDPRIB5))>0
				 cJoinCompl +=  "LEFT JOIN "+RetSqlName("SB5")+" SB5 ON(SB5.B5_FILIAL ='"+xFilial("SB5")+"' AND SB5.B5_COD=SB1.B1_COD AND SB5.D_E_L_E_T_='') "
				
			Endif
		Endif
		
		cJoinCompl := "%" + cJoinCompl + "%"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³SELECT COUNT() utilizado para pegar o numero real de registros para montar a barra de progressao corretametne³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³SELECT real para a execucao da rotina³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    	cAliasSFT		:=	GetNextAlias()

    	BeginSql Alias cAliasSFT
	    	
	    	SELECT			    	 
				%Exp:cSlctAll%			

			FROM 
				%Table:SFT% SFT				
				/*
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ”•VD¿
				//³Inserida condicao para desconsiderar itens de notas ³
				//³conjugadas que possuam o campo observacao           ³
				//³igual a NOTA DE SERVICO que se enquadram            ³
				//³na seguinte situacao:                               ³
				//³                                                    ³
				//³TES Produto 1, ISS                                  ³
				//³                                                    ³
				//³F4_ICM = Nao                                        ³
				//³F4_LFICM = Isento                                   ³
				//³F4_ISS = Sim                                        ³
				//³F4_SITRIB = 41                                      ³
				//³F4_CFO = 5933                                       ³
				//³                                                    ³
				//³TES Produto 2, ICMS                                 ³
				//³                                                    ³
				//³F4_ICM = Sim                                        ³
				//³F4_LFICM = Tributado                                ³
				//³F4_ISS = Nao                                        ³
				//³F4_SITRIB = 00                                      ³
				//³F4_CFO = 5102                                       ³
				//³                                                    ³
				//³Como a escrituracao gera um item na tabela SF3      ³
				//³para o ICMS Isento da nota de servico, este item    ³
				//³deve ser desconsiderado na geracao do SpedFiscal    ³
				//³pois sua inclusao recorria em valores duplicados    ³
				//³no arquivo                                          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ”•VDÙ
				*/								
				LEFT JOIN %Table:SF3% SF3 ON(SF3.F3_FILIAL=%xFilial:SF3%  AND %Exp:cJoinF3% AND SF3.F3_SERIE=SFT.FT_SERIE AND SF3.F3_NFISCAL=SFT.FT_NFISCAL AND SF3.F3_CLIEFOR=SFT.FT_CLIEFOR AND SF3.F3_LOJA=SFT.FT_LOJA AND SF3.F3_IDENTFT=SFT.FT_IDENTF3 AND SF3.F3_ENTRADA=SFT.FT_ENTRADA AND SF3.F3_OBSERV NOT LIKE('NOTA FISCAL DE SERVICO%') AND SF3.%NotDel%)
				%Exp:cJoinD1D2%
				LEFT JOIN %Table:SB1% SB1 ON(SB1.B1_FILIAL=%xFilial:SB1%  AND SB1.B1_COD=SFT.FT_PRODUTO AND SB1.%NotDel%)
				LEFT JOIN %Table:SF4% SF4 ON(SF4.F4_FILIAL=%xFilial:SF4%  AND %Exp:cJoinSF4% AND SF4.%NotDel%)
				%Exp:cJoinCompl%

				LEFT JOIN %Table:SA1% SA1 ON(SA1.A1_FILIAL=%xFilial:SA1%  AND SA1.A1_COD=SFT.FT_CLIEFOR AND SA1.A1_LOJA=SFT.FT_LOJA AND SA1.%NotDel%)
				LEFT JOIN %Table:SA2% SA2 ON(SA2.A2_FILIAL=%xFilial:SA2%  AND SA2.A2_COD=SFT.FT_CLIEFOR AND SA2.A2_LOJA=SFT.FT_LOJA AND SA2.%NotDel%)						
				%Exp:cJoinF1F2%
				LEFT JOIN %Table:SA4% SA4 ON(SA4.A4_FILIAL=%xFilial:SA4%  AND %Exp:cJoinSA4% AND SA4.%NotDel%)
			
			WHERE 
				SFT.FT_FILIAL=%xFilial:SFT% AND 
				SFT.FT_TIPOMOV = %Exp:cTpMov% AND 
				SFT.FT_ENTRADA>=%Exp:DToS (dDataDe)% AND 
				SFT.FT_ENTRADA<=%Exp:DToS (dDataAte)% AND 
				((SFT.FT_CFOP NOT LIKE '000%' AND SFT.FT_CFOP NOT LIKE '999%') OR SFT.FT_TIPO='S') AND 
				SFT.FT_ESPECIE <> 'CF' AND 
				%Exp:cFiltro%
				SFT.%NotDel% 
        
			%Exp:cOrderBy%
		EndSql
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se o objetivo for soh para retornar o COUNT, posso salvar em uma variavel ³
		//³  e fechar o alias, pois nao serah mais utilizado                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nOpc==1
			nRecCount	:=	(cAliasSFT)->SFTCOUNT
			
			(cAliasSFT)->(DbCloseArea())
			cAliasSFT	:=	cSlvAlias
		Else
            For nX := 1 To Len(aFieldDt)
				TcSetField(cAliasSFT,aFieldDt[nX],"D",8,0)
			Next nX
		EndIf
	Else
#ENDIF
	    cIndex	:= CriaTrab(NIL,.F.)
	    cFiltro	:= 'FT_FILIAL=="'+xFilial ("SFT")+'".And.'
	    cFiltro += 'FT_TIPOMOV=="'+cTpMov+'" .And. '
	    cFiltro += 'DToS (FT_ENTRADA)>="'+DToS (dDataDe)+'".And.DToS (FT_ENTRADA)<="'+DToS (dDataAte)+'" '
		cFiltro += '.And. (!SubStr (FT_CFOP,1,3)$"999/000" .Or. FT_TIPO=="S")'
		cFiltro += '.And. FT_ESPECIE <> "CF"'

	    If (cNrLivro<>"*")
		    cFiltro	+=	'.And.FT_NRLIVRO ="'+cNrLivro+'" '
	   	EndIf

	    IndRegua (cAliasSFT, cIndex, SFT->(IndexKey ()),, cFiltro)
	    nIndex := RetIndex(cAliasSFT)

		#IFNDEF TOP
			DbSetIndex(cIndex+OrdBagExt ())
		#ENDIF
		
		DbSelectArea(cAliasSFT)
	    DbSetOrder(nIndex+1)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se o objetivo for soh para retornar o COUNT, posso salvar em uma variavel ³
		//³  e fechar o alias, pois nao serah mais utilizado                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nOpc==1
			nRecCount	:=	(cAliasSFT)->(RecCount ())
			
			(cAliasSFT)->(DbCloseArea())
			Ferase(cIndex+GetDBExtension())
			Ferase(cIndex+OrdBagExt())
			cAliasSFT	:=	cSlvAlias			
		EndIf	    
	    
		DbSelectArea (cAliasSFT)
		(cAliasSFT)->(DbGoTop ())
		
#IFDEF TOP
	Endif
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para quando nao for um SELECT de registros, retornar ZERO ³
//³  quando nao tiver movimento no periodo, e UM para quando tiver.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpc<>1 .And. !(cAliasSFT)->(Eof())
	nRecCount	:=	1
EndIf

Return nRecCount

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |SpedMntWiz³ Autor ³Gustavo G. Rueda       ³ Data ³16.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³                    MONTAGEM DO WIZARD                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Funcao que monta o Wizard em tela para processamento.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T. se o wizard foi finalizado com sucesso ou .F. se³±±
±±³          ³ foi cancelado.                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cNomWiz  -> Nome do arquivo que sera gravado com as confi-  ³±±
±±³			 | guracoes da Wizard.			  							  ³±±
±±³          ³cPerfil  -> Perfil informado no parametro MV_PRFSPED		  ³±±
±±³          ³cNomeAnt -> Arquivo .cfp que ja possui as configuracoes da  ³±±
±±³			 | Wizard.                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SpedMntWiz ( cNomWiz , cPerfil , cNomeAnt , cSped )
Local	aTxtApre	:=	{}
Local	aPaineis	:=	{}
Local	aItens1		:=	{}
Local	aItens2		:=	{}
Local	cTitObj1	:=	""
Local	cTitObj2	:=	""
Local	cTamProd 	:=	TamSx3("B1_COD")[1]
Local	lRet		:=	.T.
Local	nPos		:=	0   
Default	cNomeAnt	:= ""
Default	cSped		:=	"FISCAL"

If cSped == "FISCAL"

	aAdd (aTxtApre, "Parâmetros necessários.")
	aAdd (aTxtApre, "")	
	aAdd (aTxtApre, "Preencha corretamente as informações solicitadas.")
	aAdd (aTxtApre, "Informações necessárias para a geração do meio-magnético SPED FISCAL.")
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³                                                                     PAINEL 0     															   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd (aPaineis, {})
	nPos	:=	Len (aPaineis)
	aAdd (aPaineis[nPos], "Preencha corretamente as informações solicitadas.")
	aAdd (aPaineis[nPos], "Parâmetros para Geração")
	aAdd (aPaineis[nPos], {})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"Data de";								   			cTitObj2	:=	"Data até"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	//
	aAdd (aPaineis[nPos][3], {2,,,3,,,,});							aAdd (aPaineis[nPos][3], {2,,,3,,,,}) 
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"Livro"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//
	cTitObj1	:=	Replicate ("X", 1)
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,1,,,,{"xMagGetCon",4}})
	
	aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"Diretório do Arquivo Destino";						cTitObj2	:=	"Nome do Arquivo Destino"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	//
	cTitObj1	:=	Replicate ("X", 50);								cTitObj2	:=	Replicate ("X", 20)
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,50});					aAdd (aPaineis[nPos][3], {2,,cTitObj2,1,,,,20})
	
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"Gera Inventário";									cTitObj2	:=	"Gera Registros Complementares de Frete"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	
	aItens1	:=	{};														aItens2	:=	{}
	aAdd (aItens1, "1-Sim");											aAdd (aItens2, "1-Sim")
	aAdd (aItens1, "2-Não");											aAdd (aItens2, "2-Não")
	aAdd (aPaineis[nPos][3], {3,,,,,aItens1,,});						aAdd (aPaineis[nPos][3], {3,,,,,aItens2,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	aItens2	:=	{}
	aItens2	:=	{"1-Sim","2-Nao"}	
	cTitObj1	:=	"Data de fechamento do estoque";					cTitObj2	:=	"Gera Registros de ECF"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	aAdd (aPaineis[nPos][3], {2,,,3,,,,});							aAdd (aPaineis[nPos][3], {3,,,,,aItens2,,})
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {1,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"QUANTO A APURAÇÃO DO ICMS"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"Arq. periodo anterior";							cTitObj2	:=	"Imprime Credito ST"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	//
	aItens1	:=	{}
	aAdd (aItens1, "1-Sim")
	aAdd (aItens1, "2-Não")
	//
	cTitObj1	:=	Replicate ("X", 50)
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,50});					aAdd (aPaineis[nPos][3], {3,,,,,aItens2,,})
	//
	aAdd (aPaineis[nPos][3], {1,"",,,,,,});							aAdd (aPaineis[nPos][3], {1,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"QUANTO A APURAÇÃO DO IPI";							cTitObj2	:=	"Seleciona Filiais ?"							
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	
	cTitObj1	:=	"Período de Apuração";								aItens2	:=	{"1-Sim","2-Nao"}
	
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {3,,,,,aItens2,,})
	
	aItens1	:=	{"0 - Mensal","1 - Decendial"}				
	aAdd (aPaineis[nPos][3], {3,,,,,aItens1,,});						aAdd (aPaineis[nPos][3], {1,"",,,,,,})						
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"Permite gerar os blocos G130 e G140 para "                    
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, "",,,,,,}) 
	//
	cTitObj1    := " todos os bens que tiveram movimentação "
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, "",,,,,,}) 
	//
	cTitObj1    := "do ativo imobilizado quando o campo "
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, "",,,,,,}) 
	//
	cTitObj1    := "TIPO_MOV do registro G125(Movimentação de "
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, "",,,,,,}) 
	//
	cTitObj1    := "Bem ou componente do ativo imobilizado)"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, "",,,,,,}) 
	//
	cTitObj1    := "for igual  a 'SI'"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, "",,,,,,}) 
	
	//
	aAdd (aPaineis[nPos][3], {1,"",,,,,,});							aAdd (aPaineis[nPos][3], {1,"",,,,,,})
	
	//
	cTitObj1	:=	"Inicio Obrigação Escrituração Fiscal CIAP";	    cTitObj2	:=	"Considera Valores de Pis/Cofins?"					
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,});
	
	// 
	aItens1	:=	{"1-Sim","2-Não"};										aItens2	:=	{"1-Sim","2-Não"}
	aAdd (aPaineis[nPos][3], {3,,,,,aItens1,,,{.F.,"2-Não",.T.}});	aAdd (aPaineis[nPos][3], {3,,,,,aItens2,,})
	aAdd (aPaineis[nPos][3], {1,"",,,,,,});          					aAdd (aPaineis[nPos][3], {1,"",,,,,,})
	
	aAdd (aPaineis[nPos][3], {1,"",,,,,,});							aAdd (aPaineis[nPos][3], {1,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³                                                                     PAINEL 1     															   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd (aPaineis, {})
	nPos	:=	Len (aPaineis)
	aAdd (aPaineis[nPos], "Preencha corretamente as informações solicitadas.")
	aAdd (aPaineis[nPos], "Identificação do Contribuinte")
	aAdd (aPaineis[nPos], {})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"Código da Finalidade do Arquivo";		   			cTitObj2	:=	""
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {0, cTitObj2,,,,,,})
	//
	aItens1	:=	{}
	aAdd (aItens1, "0-Remessa regular de arquivo")
	aAdd (aItens1, "1-Remessa de arquivo substituto")
	//
	aAdd (aPaineis[nPos][3], {3,,,,,aItens1,,});						aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"Filial de";										cTitObj2	:=	"Filial ate"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	//
	cTitObj1	:=	Replicate ("X", FWGETTAMFILIAL);				    cTitObj2	:=	Replicate ("X", FWGETTAMFILIAL)
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,FWGETTAMFILIAL});		aAdd (aPaineis[nPos][3], {2,,cTitObj2,1,,,,FWGETTAMFILIAL})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"Perfil de Apresentação";							cTitObj2	:=	"Tipo de Atividade"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	//
	aItens1	:=	{};														aItens2	:=	{}
	aAdd (aItens1, "A - Perfil A");										aAdd (aItens2, "0 - Industrial ou Equiparado")
	aAdd (aItens1, "B - Perfil B");										aAdd (aItens2, "1 - Outros")
	aAdd (aItens1, "C - Perfil C");	
	//
	If Empty(cPerfil)
		aAdd (aPaineis[nPos][3], {3,,,,,aItens1,,})
	Else
		aAdd(aPaineis[nPos][3],{2,,cPerfil,1,,,,2,{.T.,cPerfil}})
	EndIf
																		aAdd (aPaineis[nPos][3], {3,,,,,aItens2,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"INFORMAÇÕES CADASTRAIS"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"E-Mail"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//
	cTitObj1	:=	Replicate ("X", 50)
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,50});					aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//
	aAdd (aPaineis[nPos][3], {1,"",,,,,,});							aAdd (aPaineis[nPos][3], {1,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³                                                                     PAINEL 2     															   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd (aPaineis, {})
	nPos	:=	Len (aPaineis)
	aAdd (aPaineis[nPos], "Preencha corretamente as informações solicitadas.")
	aAdd (aPaineis[nPos], "Dados do contabilista")
	aAdd (aPaineis[nPos], {})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"Nome"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//
	cTitObj1	:=	Replicate ("X", 40)
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,40,,,,{"xMagGetCon",2}})					
	
	aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"CNPJ";												cTitObj2	:=	"CPF"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	//
	cTitObj1	:=	Replicate ("X", 14);								cTitObj2	:=	Replicate ("X", 11)
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,14});					aAdd (aPaineis[nPos][3], {2,,cTitObj2,1,,,,11})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"CRC"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//
	cTitObj1	:=	Replicate ("X", 15)
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,15});					aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"CEP" ;												cTitObj2	:=	"Cod. Município"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	//
	cTitObj1	:=	Replicate ("X", 8);									cTitObj2	:=	"@E 9999999"
	
	//----CEP
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,8,,,,{"xMagGetCon",3}})
	
	//----Cod. Municipio
	aAdd (aPaineis[nPos][3], {2,,cTitObj2,2,0,,,7,,,,{"xMagGetCon",3}})
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"Endereço";											cTitObj2	:=	"Número"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	//
	cTitObj1	:=	Replicate ("X", 50);								cTitObj2	:=	Replicate ("X", 5)
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,50});					aAdd (aPaineis[nPos][3], {2,,cTitObj2,1,,,,5})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"Complemento";										cTitObj2	:=	"Bairro"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	//
	cTitObj1	:=	Replicate ("X", 20);								cTitObj1	:=	Replicate ("X", 20)
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,20});					aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,20})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"Fone";												cTitObj2	:=	"Fax"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	
	cTitObj1	:=	Replicate ("X", 10);								cTitObj2	:=	Replicate ("X", 10)
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,10});					aAdd (aPaineis[nPos][3], {2,,cTitObj2,1,,,,10})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"E-Mail"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//
	cTitObj1	:=	Replicate ("X", 50)
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,50});					aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//
	aAdd (aPaineis[nPos][3], {1,"",,,,,,});							aAdd (aPaineis[nPos][3], {1,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³                                                                     PAINEL 3     															   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd (aPaineis, {})
	nPos	:=	Len (aPaineis)
	aAdd (aPaineis[nPos], "Preencha corretamente as informacoes solicitadas.")
	aAdd (aPaineis[nPos], "Informacoes para processamento do Inventario")
	aAdd (aPaineis[nPos], {})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"Produto Inicial";										   cTitObj2	:=	"Produto Final"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});						   aAdd (aPaineis[nPos][3], {1,cTitObj2,,,,,,})
	//
	cTitObj1	:=	Replicate ("X", cTamProd);								   cTitObj2	:=	Replicate ("X", cTamProd)
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,cTamProd});			       aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,cTamProd})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});						   	       aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"Armazem Inicial";										   cTitObj2	:=	"Armazem Final"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});						   aAdd (aPaineis[nPos][3], {1,cTitObj2,,,,,,})
	//
	cTitObj1	:=	Replicate ("X", TamSx3("B1_LOCPAD")[1]);				   cTitObj2	:=	Replicate ("X", TamSx3("B1_LOCPAD")[1])
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,TamSx3("B1_LOCPAD")[1]});	   aAdd (aPaineis[nPos][3], {2,,cTitObj2,1,,,,TamSx3("B1_LOCPAD")[1]})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});								   aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"Considera o saldo De/Em poder de Terceiros";       	   cTitObj2    :=  "Considera saldo em processo"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});						   aAdd (aPaineis[nPos][3], {1,cTitObj2,,,,,,})
	//
	aItens2	:=	{}
	aItens2	:=	{"1-Sim","2-Nao"}
	//
	aItens1	:=	{}													    
	aAdd (aItens1, "1-Sim")                                           	
	aAdd (aItens1, "2-Não")											         
	aAdd (aItens1, "3-De Terceiros")									
	aAdd (aItens1, "4-Em Terceiros")
	aAdd (aPaineis[nPos][3], {3,,,,,aItens1,,});						aAdd (aPaineis[nPos][3], {3,,,,,aItens2,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})     
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"Lista MOD em Processo";                            cTitObj2	:=	"Nome arq. Gerado no Reg. Inv. Mod.7"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1,cTitObj2,,,,,,})
	//
	aItens1	:=	{};													    cTitObj2	:=	Replicate ("X", 8)
	aAdd (aItens1, "1-Sim")                                           	
	aAdd (aItens1, "2-Não")											
	//
	aAdd (aPaineis[nPos][3], {3,,,,,aItens1,,});						aAdd (aPaineis[nPos][3], {2,,cTitObj2,1,,,,8})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})     
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"Motivo do Inventário"
	aItens1	:=	{}
	aAdd (aItens1, "01-Final do período")
	aAdd (aItens1, "02-Mudança de trib. da mercadoria (ICMS)")
	aAdd (aItens1, "03-Solic. da baixa cad., paral. temp. e outras")
	aAdd (aItens1, "04-Na alteração de regime de pagamento")
	aAdd (aItens1, "05-Por determinação dos fiscos")
	
	aAdd (aPaineis[nPos][3], {1,cTitObj1,,,,,,})
	//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});
	//
	aAdd (aPaineis[nPos][3], {3,,,,,aItens1,,,,,})
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³                                                                     PAINEL 4     															   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd (aPaineis, {})
	nPos	:=	Len (aPaineis)
	aAdd (aPaineis[nPos], "Preencha corretamente as informacoes solicitadas.")
	aAdd (aPaineis[nPos], "Informacoes para processamento do Bloco 1")
	aAdd (aPaineis[nPos], {})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	aItens1		:=	{}
	aAdd (aItens1, "1 - Sim")
	aAdd (aItens1, "2 - Não")
	aItens2		:=	{}
	aAdd (aItens2, "1 - Sim")
	aAdd (aItens2, "2 - Não")
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"Gera Registro 1100 - Exportação?"
	cTitObj2	:=	"Gera Registro 1200 - Créditos Fiscais?"
	
	aAdd (aPaineis[nPos][3], {1,cTitObj1,,,,,,})
	aAdd (aPaineis[nPos][3], {1,cTitObj2,,,,,,})
	
	aAdd (aPaineis[nPos][3], {3,,,,,aItens1,,,,,})
	aAdd (aPaineis[nPos][3], {3,,,,,aItens2,,,,,})
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});						   	       	aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"Gera Registro 1300 - Combustíveis?"
	cTitObj2	:=	"Gera Registro 1390 - Usina de açúcar/álcool?"
	
	aAdd (aPaineis[nPos][3], {1,cTitObj1,,,,,,})
	aAdd (aPaineis[nPos][3], {1,cTitObj2,,,,,,})
	
	aAdd (aPaineis[nPos][3], {3,,,,,aItens1,,,,,})
	aAdd (aPaineis[nPos][3], {3,,,,,aItens2,,,,,})
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});						   	       	aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"Gera Registro 1400 - Valores Agregados?"
	cTitObj2	:=	"Gera Registro 1500 - Energia Elétrica?"
	
	aAdd (aPaineis[nPos][3], {1,cTitObj1,,,,,,})
	aAdd (aPaineis[nPos][3], {1,cTitObj2,,,,,,})
	
	aAdd (aPaineis[nPos][3], {3,,,,,aItens1,,,,,})
	aAdd (aPaineis[nPos][3], {3,,,,,aItens2,,,,,})
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});						   	       	aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"Gera Registro 1600 - Cartão de Crédito/Débito?"
	cTitObj2	:=	"Gera Registro 1700 - Documentos Fiscais?"
	
	aAdd (aPaineis[nPos][3], {1,cTitObj1,,,,,,})
	aAdd (aPaineis[nPos][3], {1,cTitObj2,,,,,,})
	
	aAdd (aPaineis[nPos][3], {3,,,,,aItens1,,,,,})
	aAdd (aPaineis[nPos][3], {3,,,,,aItens2,,,,,})
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});						   	       	aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	cTitObj1	:=	"Gera Registro 1800 - Transporte Aéreo?"
	
	aAdd (aPaineis[nPos][3], {1,cTitObj1,,,,,,})
	//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});
	//
	aAdd (aPaineis[nPos][3], {3,,,,,aItens1,,,,,})
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});						   	       	aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//--------------------------------------------------------------------------------------------------------------------------------------------------//

Elseif cSped == "PISCOF"

	//
	aAdd (aTxtApre, STR0004)
	aAdd (aTxtApre, "")	
	aAdd (aTxtApre, STR0005)
	aAdd (aTxtApre, STR0006)
	
	//³Painel 0³ 	
	aAdd (aPaineis, {})
	nPos	:=	Len (aPaineis)
	aAdd (aPaineis[nPos], STR0005)
	aAdd (aPaineis[nPos], "")
	aAdd (aPaineis[nPos], {})
	//
	cTitObj1	:=	STR0007 ;								   			cTitObj2	:=	STR0008 //Data de - Data Ate 
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	//
	aAdd (aPaineis[nPos][3], {2,,,3,,,,});							aAdd (aPaineis[nPos][3], {2,,,3,,,,}) 
	//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//
	cTitObj1	:=	STR0009 //Livro
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//
	cTitObj1	:=	Replicate ("X", 1)
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,1});					aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//
	cTitObj1	:=	STR0010 ;					   					    cTitObj2	:=	STR0011   //Diretorio do Arquivo Destino / Nome arquivo Destino
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	//
	cTitObj1	:=	Replicate ("X", 50);								cTitObj2	:=	Replicate ("X", 20)
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,50});					aAdd (aPaineis[nPos][3], {2,,cTitObj2,1,,,,20})
	
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	
	cTitObj1	:=	STR0059;											cTitObj2	:= STR0062  //	"Indicador de apuração:"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	
	aItens1	:=	{}; 													aItens2	:=	{}
	aAdd (aItens1, STR0060); 											aAdd (aItens2, "") //"1-Base nos registros de consolidação"
	aAdd (aItens1, STR0061);											aAdd (aItens2, STR0063) //"2-Base nos registros de individualização"
																		aAdd (aItens2, STR0064) //"2-Base nos registros de individualização"
	aAdd (aPaineis[nPos][3], {3,,,,,aItens1,,,,,});				    aAdd (aPaineis[nPos][3], {3,,,,,aItens2,,,,,})
	
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	
	cTitObj1	:=	STR0098									
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});			   aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	
	aItens1	:=	{} 												
	aAdd (aItens1, STR0060) //1-Sim										
	aAdd (aItens1, STR0061)	 //2-não									 
	
	aAdd (aPaineis[nPos][3], {3,,,,,aItens1,,,,,});				aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	
	aAdd (aPaineis[nPos][3], {1,"",,,,,,}); 					aAdd (aPaineis[nPos][3], {1,"",,,,,,})
	
	aItens2	:=	{} 												
	aAdd (aItens2, STR0061) //2-Não
	aAdd (aItens2, STR0060)	//1-Sim
	aAdd (aItens2, "3-Exclusivamente")	 //3-Exclusivamente
	
	aAdd (aPaineis[nPos][3], {1,"Gera informações da Apuração da Contribuição",,,,,,}); aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	aAdd (aPaineis[nPos][3], {1,"Previdenciária sobre Receita Bruta (Bloco P) ?",,,,,,}); aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	
	aAdd (aPaineis[nPos][3], {3,,,,,aItens2,,,,,});				aAdd (aPaineis[nPos][3], {1,"",,,,,,})			
	
	aAdd (aPaineis[nPos][3], {1,"",,,,,,});                      aAdd (aPaineis[nPos][3], {1,"",,,,,,})
	
	cTitObj1	:=	"Cód. da Receita para prestação de serviços"
	cTitObj2	:=	"Cód. da Receita para demais operações"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	//
	cTitObj1	:=	Replicate ("X", 6)
	cTitObj2	:=	Replicate ("X", 6)
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,6});					aAdd (aPaineis[nPos][3], {2,,cTitObj2,1,,,,6})
	
	aItens2	:=	{}
    aAdd (aItens2, "1 – Receita Bruta") //1 – Exclusivamente com base na Receita Bruta
	aAdd (aItens2, "2 – Receita Bruta/Remunerações")	//Com base na Receita Bruta e nas Remunerações pagas  
	aAdd (aItens2, "")// em branco
	aAdd (aPaineis[nPos][3], {1,"",,,,,,}); 					aAdd (aPaineis[nPos][3], {1,"",,,,,,})
	aAdd (aPaineis[nPos][3], {1,"Cód. indicador da incidência tributária:",,,,,,}); aAdd (aPaineis[nPos][3], {0,"",,,,,,}) 
	aAdd (aPaineis[nPos][3], {3,,,,,aItens2,,,,,});				aAdd (aPaineis[nPos][3], {1,"",,,,,,})
	aAdd (aPaineis[nPos][3], {1,"",,,,,,});                      aAdd (aPaineis[nPos][3], {1,"",,,,,,})
	
	
	//³Painel 1³
	aAdd (aPaineis, {})
	nPos	:=	Len (aPaineis)
	aAdd (aPaineis[nPos], STR0005)
	aAdd (aPaineis[nPos], "")  
	aAdd (aPaineis[nPos], {})
	//
	cTitObj1:=	STR0013 ;		   		           				     	cTitObj2:=	STR0014     //Código do Tipo de escrituração / Indicador de situação especial
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	//
	aItens1	:=	{};													    aItens2	:=	{}
	aAdd (aItens1, STR0015);                                       		aAdd (aItens2, "")																	
	aAdd (aItens1, STR0016);							       			aAdd (aItens2, STR0017)
																    	aAdd (aItens2, STR0018 )
																    	aAdd (aItens2, STR0019)
																	    aAdd (aItens2, STR0020)
																	    aAdd (aItens2, STR0021)
	//
	aAdd (aPaineis[nPos][3], {3,,,,,aItens1,,});						aAdd (aPaineis[nPos][3], {3,,,,,aItens2,,})
	//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});						   	aAdd (aPaineis[nPos][3], {0,"",,,,,,})			
	    
	
	cTitObj1:=	STR0022; 										        cTitObj2:=	STR0023   //Indicador da natureza da pessoa jurídica / Indicador de tipo de atividade preponderante
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	//
	aItens1	:=	{};													    aItens2	:=	{}
	aAdd (aItens1, STR0024);                     						aAdd (aItens2, STR0027)
	aAdd (aItens1, STR0025);							    			aAdd (aItens2,STR0028)
	aAdd (aItens1, STR0026);   											aAdd (aItens2, STR0029)
																		aAdd (aItens2, STR0030 )
																	    aAdd (aItens2, STR0031 )
																	    aAdd (aItens2, STR0032 )
	aAdd (aPaineis[nPos][3], {3,,,,,aItens1,,});						aAdd (aPaineis[nPos][3], {3,,,,,aItens2,,})
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});						   	aAdd (aPaineis[nPos][3], {0,"",,,,,,})		
	    
	cTitObj1:=	STR0033  ;		   		           				     	cTitObj2:=	STR0090     //Código do Tipo de escrituração / Indicador de situação especial
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	//
	aItens1	:=	{};													 	aItens2	:=	{}
	cTitObj1	:=	Replicate ("X", 41);                             	aAdd (aItens2, "")																	
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,41});					aAdd (aItens2, STR0083)
																    	aAdd (aItens2, STR0084)
																    	aAdd (aItens2, STR0085)
																	    aAdd (aItens2, STR0086)
																	    aAdd (aItens2, STR0087)
																	    aAdd (aItens2, STR0088)
																	    aAdd (aItens2, STR0089)
																	    aAdd (aPaineis[nPos][3], {3,,,,,aItens2,,})//
	
	 
	//³Painel 2³ 
	aAdd (aPaineis, {})
	nPos	:=	Len (aPaineis)
	aAdd (aPaineis[nPos], STR0005)
	aAdd (aPaineis[nPos], STR0012 ) //Identificação do Contribuinte
	aAdd (aPaineis[nPos], {})
	//
	cTitObj1	:=	STR0035  //Nome
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//
	cTitObj1	:=	Replicate ("X", 40)
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,40});					aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//
	cTitObj1	:=	STR0036 ;											cTitObj2	:=	STR0037   //CNPJ / CPF
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	//
	cTitObj1	:=	Replicate ("X", 14);								cTitObj2	:=	Replicate ("X", 11)
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,14});					aAdd (aPaineis[nPos][3], {2,,cTitObj2,1,,,,11})
	//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//
	cTitObj1	:=	STR0038 //CRC 
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//
	cTitObj1	:=	Replicate ("X", 11)
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,11});					aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//
	cTitObj1	:=	STR0039  ;											cTitObj2	:=	STR0040 //CEP / Cod. Municipio
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	//
	cTitObj1	:=	Replicate ("X", 8);									cTitObj2	:=	"@E 9999999"
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,8});					aAdd (aPaineis[nPos][3], {2,,cTitObj2,2,0,,,7})
	//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//
	cTitObj1	:=	STR0041 ;											cTitObj2	:=	STR0042      //Endereco / Cod. Municipio
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	//
	cTitObj1	:=	Replicate ("X", 50);								cTitObj2	:=	Replicate ("X", 5)
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,50});					aAdd (aPaineis[nPos][3], {2,,cTitObj2,1,,,,5})
	//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//
	cTitObj1	:=	STR0043 ;										    cTitObj2	:=	STR0044   //Complemento / Bairro
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	//
	cTitObj1	:=	Replicate ("X", 20);								cTitObj1	:=	Replicate ("X", 20)
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,20});					aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,20})
	//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//
	cTitObj1	:=	STR0045 ;											cTitObj2	:=	STR0046 //Fone / Fax
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	//
	cTitObj1	:=	Replicate ("X", 10);								cTitObj2	:=	Replicate ("X", 10)
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,10});					aAdd (aPaineis[nPos][3], {2,,cTitObj2,1,,,,10})
	//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//
	cTitObj1	:=	STR0047  //E-Mail
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//
	cTitObj1	:=	Replicate ("X", 50)
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,50});					aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//
	aAdd (aPaineis[nPos][3], {1,"",,,,,,});							aAdd (aPaineis[nPos][3], {1,"",,,,,,})
		
	 
	//³Painel 3³ 	
	aAdd (aPaineis, {})
	nPos	:=	Len (aPaineis)
	aAdd (aPaineis[nPos], STR0005)
	aAdd (aPaineis[nPos], STR0048 )  //Dados sobre Regimes de Apuração
	aAdd (aPaineis[nPos], {})
	//
	cTitObj1	:=	STR0049  ;		   		           					cTitObj2	:=	STR0056     //Código do Tipo de escrituração / Indicador de situação especial
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	//
	aItens1	:=	{};													    aItens2	:=	{}
	aAdd (aItens1, STR0050);                                       		aAdd (aItens2, STR0057)
	aAdd (aItens1, STR0051);							       			aAdd (aItens2, STR0058)
	aAdd (aItens1, STR0052)									    	
																	    
	//
	aAdd (aPaineis[nPos][3], {3,,,,,aItens1,,});						aAdd (aPaineis[nPos][3], {3,,,,,aItens2,,})
	//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});						   	aAdd (aPaineis[nPos][3], {0,"",,,,,,})	
	
	//
	cTitObj1	:= STR0077 ;					 		   		         cTitObj2	:=	""
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});				     aAdd (aPaineis[nPos][3], {1,,,,,,,})	    
	//
	aItens1	:=	{}
	aAdd (aItens1, STR0060) //1-Sim
	aAdd (aItens1, STR0061) //2-não						       			
	//
	aAdd (aPaineis[nPos][3], {3,,,,,aItens1,,});						aAdd (aPaineis[nPos][3], {0,"",,,,,,}) 		
	//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});						    aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	//
	//
	cTitObj1	:= STR0091;										 		 cTitObj2	:= "Indicador do Regime Exclusivamente Cumulativo"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});				     aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	//
	aItens1	:=	{};														aItens2	:=	{}
	aAdd (aItens1, "2-Não");											aAdd (aItens2, "1-Regime de Caixa")
	aAdd (aItens1, "1-Sim");											aAdd (aItens2, "2-Regime Competência - Consolidada")
																	    aAdd (aItens2, "9-Regime Competência - Detalhada")	
																		
	aAdd (aPaineis[nPos][3], {3,,,,,aItens1,,});						aAdd (aPaineis[nPos][3], {3,,,,,aItens2,,})
	
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});						    aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	
	
	cTitObj1	:= "Indicador de Composição da Receita" ;			cTitObj2	:= "Indicador Bloco I"	 	
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});				aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})				
	
	//
	aItens1	:=	{};													aItens2	:=	{}		
	aAdd (aItens1, "01-Clientes");									aAdd (aItens2, " ")
	aAdd (aItens1, "03-Título/Duplicata");							aAdd (aItens2, "01-Instituições Financeiras e Assemelhadas")						
	aAdd (aItens1, "04-Documento Fiscal");							aAdd (aItens2, "02-Seguros Privados")
	aAdd (aItens1, "05-Item Vendido(Produtos e Serviços)");		aAdd (aItens2, "03-Previdência Complementar")
																		aAdd (aItens2, "04-Capitalização")
																		aAdd (aItens2, "05-Planos de Assistência à Saúde")	
																		aAdd (aItens2, "06-Mais de um dos indicadores acima")
																		
	aAdd (aPaineis[nPos][3], {3,,,,,aItens1,,});					aAdd (aPaineis[nPos][3], {3,,,,,aItens2,,})							
	//
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});						aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	

Endif

lRet	:=	xMagWizard (aTxtApre, aPaineis, cNomWiz, cNomeAnt)
Return(lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A905ValCa ºAutor  ³ Vitor Felipe       º Data ³  08/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validar campos necessarios para rotina de componente.      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function SPEDValC()

Local lValid	:= .F. 

If SF4->(FieldPos("F4_COMPONE"))>0 .And. SF9->(FieldPos("F9_TIPO"))>0 .And. SF9->(FieldPos("F9_CODBAIX"))>0;
		 .And. SD1->(FieldPos("D1_CODBAIX"))>0 
	lValid := .T.
EndIf

Return(lValid) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³SPEDRegs  | Autor ³Gustavo G. Rueda  			   ³ Data ³28.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Funcao que efetua a gravacao de registros dependentes de forma     ³±±
±±³          ³ herarquica no TRB utilizando uma formatacao diferenciada do campo ³±±
±±³          ³ TRB_RELAC, onde o mesmo eh dividido em dois e o primeiro grupo    ³±±
±±³          ³ corresponde ao PAI e o segundo ao FILHO. Exemplo:                 ³±±
±±³          ³                                                                   ³±±
±±³          ³E200 --> E210 --> E220, nesta hierarquia, a gravacao eh efetuada da³±±
±±³          ³ segunite forma:                                                   ³±±
±±³          ³ Reg. E200 -> TRB_RELAC = 0000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000002
±±³          ³ Reg. E210 -> TRB_RELAC = 0000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000003
±±³          ³ Reg. E220 -> TRB_RELAC = 0000000000000000000000000000000000000000000000000300000000000000000000000000000000000000000000000001
±±³          ³                                                                   ³±±
±±³          ³ onde:                                                             ³±±   
±±³          ³                                                                   ³±±
±±³          ³ O segundo grupo do E200 (...0002) corresponde ao primeiro do E210 ³±±
±±³          ³ (...0002) e o segundo do E210 corresponde ao primeiro do E220     ³±±
±±³          ³ (...0003)                                                         ³±±
±±³          ³                                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³1) Os array a serem passados devem seguir a ordem hierarquica de   ³±±
±±³          ³   gracao.                                                         ³±±
±±³          ³2) Para os registros que estiverem na sequencia mais nao correspon-³±±
±±³          ³   derem a hierarquia informada, deve ser passado no seguinte for- ³±±
±±³          ³   mato. Ex: (aReg,2}                                              ³±±
±±³          ³   a) O primeiro nivel corresponde ao registro;                    ³±±
±±³          ³   b) O segundo corresponde ao pai deste registro que nao eh o     ³±±
±±³          ³      antecessor. Um exemplo de utilizacao eh a geracao do bloco E.³±±
±±³          ³                                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³SPEDRegs(cAlias,aRegs)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias    -> Alias do TRB em processamento para gravar as informa- ³±±
±±³          ³             coes                                                  ³±±
±±³          ³aRegs     -> Array com as informacoes dos registros a serem grava- ³±±
±±³          ³             dos.                                                  ³±±
±±³          ³aRegs     ->                                                       ³±±
±±³          ³lSpedC    -> Indica se está processando registro do SPED           ³±±
±±³          ³             Contribuições (PIS/COFINS).                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nil                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPEDRegs(cAlias,aRegs,cMensagem,lSpedC)
Local	aAux		:=	{}
Local	nAux		:=	0
Local	nI1			:=	0
Local	nI2			:=	0
Local	nI3			:=	0
Local	aPai		:=	{}
Local	lProc		:=	.T.
Local	nRegsProc	:=	0
Local	cTimeDocs	:=	Time()
Local	nDocsXTime	:=	0
Local	nSvnI3		:=	0

Default	cMensagem	:=	""
Default lSpedC	:= .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem de um array de hierarquias como base para leitura dos arrays pela funcao.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nI1 := 1 To Len(aRegs)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³O primeiro sempre serah o pai de todos, portanto nao tem um PAI³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nI1==1
		aAdd(aPai,{nI1,0})	//Sem pai, eh o pai de todos
	Else

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento para verificar o registro cujo pai NA0 estah na sequencia. ³
		//³  Ex: E200 eh pai do E210 que eh pai do E220 que eh pai do E230 e E240³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ValType(aRegs[nI1])=="A" .And. Len(aRegs[nI1])>=2 .And. ValType(aRegs[nI1,2])=="N"
			aAdd(aPai,{nI1,aRegs[nI1,2]})
		Else
			aAdd(aPai,{nI1,nI1-1})
		EndIf
	EndIf

Next nI1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processamento da estrutura hierarquica³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nI1 := 2 To Len(aPai)	//A primeira posicao sempre eh o pai de todos
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Localizo o registro PAI e utilizo as informacoes³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aRegsPai	:=	aRegs[aPai[nI1,2]]
	If ValType(aRegsPai)=="A" .And. Len(aRegsPai)>=2 .And. ValType(aRegsPai[2])=="N"	//Tratamento para verificar o registro cujo pai nao eh o antecessor
   		aRegsPai	:=	aRegsPai[1]
 	EndIf
 	
	aRegsFil	:=	aRegs[aPai[nI1,1]]
 	If ValType(aRegsFil)=="A" .And. Len(aRegsFil)>=2 .And. ValType(aRegsFil[2])=="N"	//Tratamento para verificar o registro cujo pai nao eh o antecessor
		aRegsFil	:=	aRegsFil[1]
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³No caso de o objeto oProcess existir, significa que a nova barra  ³
	//³ de processamento (CLASSE Fiscal) estah em uso pela rotina,       |
	//| portanto deve ser efetuado os controles para demonstrar o        |
	//| resultado do processamento.                                      |
	//|                                                                  |
	//|O tratamento da nova regua serah efetuada em particular nesta     |
	//| funcao, quando o parametro "cMensagem" vier preenchido, pois com |
	//| ele identificamos qual gravacao do TRB pode ser realmente        |
	//| demorada, caso contrario nao precisa, eh muito rapido            |
	//|                                                                  |
	//|Definicao do tamanho das reguas e atualizacao dos detalhes de     |
	//| processamento, pois como o caso da funcao OrgTxt, este tambem    |
	//| deve ser tratado isoladamente do movimento.                      |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cMensagem) .And. Type("oProcess")=="O"
		oProcess:Set1Progress(Len(aRegsPai))

		//Neste caso nao eh necessario o controle da segunda regua, basta somente a primeira
		oProcess:Set2Progress(1)
		oProcess:Inc2Progress("","")

		oProcess:SetDetProgress(STR0001,Len(aRegsFil),;		//"Total de registros do periodo solicitado"
					STR0002,0,;		//"Total de registros processados por segundo"
					STR0003,0,;		//"Total de registros pendentes para processamento"
					STR0004,0)		//"Tempo estimado para termino do processamento (Seg.)"
	EndIf
	
	For nI2 := 1 To Len(aRegsPai)

		lProc	:=	.T.

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³No caso de o objeto oProcess existir, significa que a nova barra  ³
		//³ de processamento (CLASSE Fiscal) estah em uso pela rotina,       |
		//| portanto deve ser efetuado os controles para demonstrar o        |
		//| resultado do processamento.                                      |
		//|                                                                  |
		//|Incremento da segunda  regua, somente a mensagem, pois os numeros |
		//| neste caso nao sao sequenciais e fica confuso a demonstracao em  |
		//| tela.                                                            |
		//|Tambem estah sendo efetuada a atualizacao dos detalhes.           |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(cMensagem) .And. Type("oProcess")=="O"
			nRegsProc	+=	1		
			oProcess:Inc1Progress("Processamento secundário: Gravando estruturas "+cMensagem,StrZero(nRegsProc,4)+"/"+StrZero(Len(aRegsPai),4))
		
			If cTimeDocs<>Time()
				oProcess:SetDetProgress(STR0001,Len(aRegsPai),;	 			//"Total de registros do periodo solicitado"
						STR0002,nDocsXTime,;	  								//"Total de registros processados por segundo"
						STR0003,Len(aRegsPai)-nRegsProc,;						//"Total de registros pendentes para processamento"
						STR0004,Round((Len(aRegsPai)-nRegsProc)/nDocsXTime,0))	//"Tempo estimado para termino do processamento (Seg.)"
		
				cTimeDocs	:=	Time()
				nDocsXTime	:=	1
			Else
				nDocsXTime	+=	1
			EndIf		
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Controle do cancelamento da rotina³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If oProcess:Cancel()
				Exit
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se nao existir filho para este PAI, deve gerar as informacoes doo PAI independente³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If aScan(aRegsFil,{|aX| aX[1]==nI2})==0 .And. nI1==2
			aAux		:=	{}
			For nAux := 1 To Len(aRegsPai[nI2])
				aAdd(aAux,aRegsPai[nI2,nAux])
			Next nAux
			GrvRegTrS(cAlias,0,{aAux},,nI2)		
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Variavel de controle do flag de relacionamento dos filhos com o pai³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nSvnI3	:=	0
		For nI3 := 1 To Len(aRegsFil)
		
			If aRegsFil[nI3,1]==nI2
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Para cada pai, efetuo a gravacao do PAI e do FILHO³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nI1==2 .And. lProc 
					lProc		:=	.F.

					aAux		:=	{}
					For nAux := Iif(nI1==2,1,2) To Len(aRegsPai[nI2])
						aAdd(aAux,aRegsPai[nI2,nAux])
					Next nAux
					GrvRegTrS(cAlias,nI3,{aAux},,nI2,lSpedC)
					
					aAux		:=	{}
					For nAux := 2 To Len(aRegsFil[nI3])
						aAdd(aAux,aRegsFil[nI3,nAux])
					Next nAux
					GrvRegTrS(cAlias,nI3,{aAux},,nI3,lSpedC)
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Variavel utilizada para salvar a posicao do nI3 para utilizar quando existir mais de um filho³
					//³  para o mesmo pai (else abaixo).                                                            ³
					//³                                                                                             ³
					//³Quando sair do FOR (processamento de todos os filhos do mesmo pai), devo ZERAR a             ³
					//³  variavel para manter o controle que havia antes, "nI2"                                     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nSvnI3	:=	nI3

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Quando o processamento ainda estiver no loop, gravo o pai somente para o³
				//³  primeiro registro e para os outros, somente os filhos                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Else

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Atribuicao do nI2 para quando o nivel hierarquico for acima de 2 (nI1>2)³
					//³  nao entrando no if acima, somente neste else, e neste momento devo    ³
					//³  considerar o nI2.                                                     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nSvnI3==0
						nSvnI3	:=	nI2
					EndIf
					
					aAux		:=	{}
					For nAux := 2 To Len(aRegsFil[nI3])
						aAdd(aAux,aRegsFil[nI3,nAux])
					Next nAux
					GrvRegTrS(cAlias,nI3,{aAux},,nSvnI3,lSpedC)
					
				EndIf
			
			EndIf
			
		Next nI3

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³No caso de o objeto oProcess existir, significa que a nova barra  ³
		//³ de processamento (CLASSE Fiscal) estah em uso pela rotina,       |
		//| portanto deve ser efetuado os controles para demonstrar o        |
		//| resultado do processamento.                                      |
		//|                                                                  |
		//|Tratamento para o cancelamento de execucao da rotina              |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(cMensagem) .And. Type("oProcess")=="O" .And. oProcess:Cancel()
			Exit
		EndIf
	Next nI2
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³No caso de o objeto oProcess existir, significa que a nova barra  ³
	//³ de processamento (CLASSE Fiscal) estah em uso pela rotina,       |
	//| portanto deve ser efetuado os controles para demonstrar o        |
	//| resultado do processamento.                                      |
	//|                          	                                        |
	//|Tratamento para o cancelamento de execucao da rotina              |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cMensagem) .And. Type("oProcess")=="O" .And. oProcess:Cancel()
		Exit
	EndIf
Next nI1                                       
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³No caso de o objeto oProcess existir, significa que a nova barra    ³
//³ de processamento (CLASSE Fiscal) estah em uso pela rotina,         |
//| portanto deve ser efetuado os controles para demonstrar o          |
//| resultado do processamento.                                        |
//|                                                                    |
//³Condicao implementada para controlar os numeros apresentadas na tela³
//³  de processamento da rotina, os detalhes.                          ³
//³Ao final do processamento, para este caso da funcao, atualizo altero³
//³  o tratamento de registros lidos, pois a funcao utiliza bastante   |		
//³  a funcao RegPorNf e ela nao tem o controle de soma da variavel    ³		
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cMensagem) .And. Type("oProcess")=="O"
	oProcess:SetDetProgress(STR0001,Len(aRegsPai),;		//"Total de registros do periodo solicitado"
			STR0002,nDocsXTime,;		//"Total de registros processados por segundo"
			STR0003,0,;					//"Total de registros pendentes para processamento"
			STR0004,0)					//"Tempo estimado para termino do processamento (Seg.)"
EndIf		

Return  	
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³SPEDGetAli| Autor ³Gustavo G. Rueda  			   ³ Data ³19.10.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Funcao parecia com a GetNextAlias(), que gera um alias aleatorio   ³±±
±±³          ³ para a query com um limite maior. A GETNEXTALIAS() estava chegando³±±
±±³          ³ ao limite e reiniciando a numeracao, apresentando erro de alias in³±±
±±³          ³ use                                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Os array aA GETNEXTALIAS() estava chegando ao limite e reiniciando ³±±
±±³          ³ a numeracao, apresentando erro de alias in use                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³SPEDGetAlias(ExpC)                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC -> PARAMETRO NAO OBRIGATORIO: Flag de controle para tornar o  ³±±
±±³          ³ alias mais exclusivo.                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC -> Retorna o alias a ser utilizado e que não esteja aberto    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPEDGetAlias(cTabela)
Local	cArq		:=	"000000000"

Default	cTabela	:=	""

cTabela	:=	AllTrim(cTabela)
While Select("SF_"+cTabela+cArq)<>0
	cArq	:=	SOMA1(cArq)
End

Return "SF_"+cTabela+cArq


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³SPEDLeRegs| Autor ³Gustavo G. Rueda  			   ³ Data ³28.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Funcao efetua a leitura das informacoes gravadas pela funcao       ³±±
±±³          ³ SPEDRegs, conforme seu criterio de gravacao                       ³±±
±±³          ³                                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³1) Os array a serem passados devem seguir a ordem hierarquica de   ³±±
±±³          ³   gracao.                                                         ³±±
±±³          ³2) Para os registros que estiverem na sequencia mais nao correspon-³±±
±±³          ³   derem a hierarquia informada, deve ser passado no seguinte for- ³±±
±±³          ³   mato. Ex: (aReg,2}                                              ³±±
±±³          ³   a) O primeiro nivel corresponde ao registro;                    ³±±
±±³          ³   b) O segundo corresponde ao pai deste registro que nao eh o     ³±±
±±³          ³      antecessor. Um exemplo de utilizacao eh a geracao do bloco E.³±±
±±³          ³                                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³SPEDRegs(cAlias,aRegs)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³nHandle   -> Handle do arquivo texto                               ³±±
±±³          ³cAlias    -> Alias do TRB em processamento para gravar as informa- ³±±
±±³          ³             coes                                                  ³±±
±±³          ³aRegs     -> Array com os codigos de registros a serem tratados    ³±±
±±³          ³cRelac    -> Conteudo do campo TRB_RELAC do registro PAI gravado   ³±±
±±³          ³             fora desta funcao para relacionamento com seus filhos ³±±
±±³          ³nFor      -> Controle da recursividade (NAO USAR)                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nil                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPEDLeRegs(nHandle,cAlias,aRegs,cRelac,nFor)
Local	nTamTRBIt	:=	Len((cAlias)->TRB_RELAC)/2	//Efetuo divisao por dois porque faco dois controles em um mesmo campo. O relacionamento e sequencia. Ex: ...0001...1, ...0001...2
Local	nX			:=	0
Local	nRecno		:=	0
Local	nPai		:=	0
Local	aAux  		:=	aClone(aRegs)
Local	lTemFil		:=	.T.
Local	nPosFil		:=	0
Local	cReg		:=	""
Local	cRelacPai	:=	""
Local	cRelacFil	:=	""

Default	nFor		:=	1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Percorrendo os registros a serem gerados segundo sua hierarquia (conforme passado no array).³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := nFor To Len(aRegs)
	cRelacPai	:=	SubStr(cRelac,1,nTamTRBIt)
	cRelacFil	:=	SubStr(cRelac,nTamTRBIt+1)
	nRecno		:=	(cAlias)->(Recno())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³No array aRegs, a hierarquia pode ser construida de duas formas:            ³
	//³1) Ordem dos registros formatados no array, ou;                             ³
	//³2) Cada determinado registro apesar de estar na sequencia, nao              ³
	//³    faz parte dela, pois seu pai correspondente eh outro de outro nivel     ³
	//³   da cadeia.                                                               ³
	//³                                                                            ³
	//³Ex:                                                                         ³
	//³1) {"C300","C310","C320","C321"}  --> Neste temos a sequencia correta       ³
	//³                                      a seguir, pois o array jah estah no   ³
	//³                                      ordem hierarquica correta.            ³
	//³                                                                            ³
	//³2) {"E210","E220","E230",{"E240",2},{"E250",1}} --> Neste exemplo,          ³
	//³                                     temos uma ordem ateh o registro E230,  ³
	//³                                     depois disso, a sequencia eh quebrada, ³
	//³                                     pois o pai do E240 nao eh o E230 e sim ³
	//³                                     o E220, cuja a indicacao eh o segundo  ³
	//³                                     nivel do array. O mesmo acontece com   ³
	//³                                     o E250, cujo pai e a primeira posicao, ³
	//³                                     o E210                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ValType(aRegs[nX])=="A"
		cReg	:=	aRegs[nX,1]
		nPai	:=	aRegs[nX,2]
	Else
		cReg	:=	aRegs[nX]
		nPai	:=	nX-1
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Este eh um tratamento para retornar a posicao, se tiver na cadeia,                 ³
	//³  outro registro fora da sequencia que seja filho deste em processamento.          ³
	//³                                                                                   ³
	//³Este tratamento eh necessario para que se nao encontrar o registro filho,          ³
	//³  seja verificado se pode abandonar o processamento, jah que nao tem mais          ³
	//³  filhos a verificar, ou se o filho estah fora da sequencia, neste caso vou direto ³
	//³  a ele no ELSEIF abaixo.                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nPosFil	:=	aScan(aRegs,{|aX| ValType(aX)<>"C" .And. aX[2]==nPai},nX+1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento de buscao do filho correspondente ao pai em processamento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lTemFil .And. (lTemFil := (cAlias)->(MsSeek(cReg+cRelacFil)))

		While !(cAlias)->(Eof()) .And. (cAlias)->TRB_TPREG==cReg .And. SubStr((cAlias)->TRB_RELAC,1,nTamTRBIt)==cRelacFil

			If (cAlias)->TRB_FLAG<>"*"
				SPEDGrvLin(nHandle,cAlias)
		
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Para que se procure um registro filho, deve-se fazer as seguintes verificacoes:               ³
				//³1) O array deve ter o tamanho compativel com o proximo nivel a ser processado;                ³
				//³2) Este proximo registro(filho) deve ter como ordem hierarquica a sequencia do array passado; ³
				//³3) Ou, no caso de array, o segundo indice que indica o Pai, deve ser o registro corrente, pois³
				//³    caso seja um que jah foi processado, nao preciso chamar a funcao recursica, pois nao irah ³
				//³    encontrar a correspondencia.                                                              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Len(aAux)>=nX+1 .And. (ValType(aAux[nX+1])<>"A" .Or. (ValType(aAux[nX+1])=="A" .And. aAux[nX+1,2]>=nX))
					nRecno	:=	(cAlias)->(Recno())
					SPEDLeRegs(nHandle,cAlias,aAux,(cAlias)->TRB_RELAC,nX+1)
					(cAlias)->(dbGoTo(nRecno))
				EndIf
			EndIf
			
			(cAlias)->(dbSkip())
		End
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Este eh um tratamento para retornar a posicao, se tiver na cadeia,                 ³
		//³  outro registro fora da sequencia que seja filho deste em processamento.          ³
		//³                                                                                   ³
		//³Este tratamento eh necessario para que se nao encontrar o registro filho,          ³
		//³  seja verificado se pode abandonar o processamento, jah que nao tem mais          ³
		//³  filhos a verificar, ou se o filho estah fora da sequencia, neste caso vou direto ³
		//³  a ele no ELSEIF abaixo.                                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (nPosFil := aScan(aRegs,{|aX| ValType(aX)<>"C" .And. aX[2]==nPai},nX+1))==0
			Exit
		Else
			nX		:=	nPosFil-1
		EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento para seguir com o processamento. Ele se dah em duas situacoes:               ³
	//³1) Caso o registro PAI nao esteja na cadeia (nPai===0), isso significa que o registro   ³
	//³    principal (Nivel 1) nao foi encontrado, entao nao tem o que gerar, portanto continuo³
	//³    o processamento caso existam outros para serem gerados;                             ³
	//³                                                                                        ³
	//³2) No caso de o filho nao estar na sequencia passada, mas se referir a algum fora da    ³
	//³    sequencia, neste caso, deve-se posicionar no referido e processa-lo                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf nPai==0 .Or. (!lTemFil .And. nPosFil>0)
			
		(cAlias)->(dbGoTo(nRecno))

		If nPai<>0 .And. !lTemFil .And. nPosFil>0
			nX		:=	nPosFil-1
		EndIf
		
		lTemFil	:=	.T.
	Else
		Exit
	EndIf	

Next nX

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³SPEDVlBSRD| Autor ³Gustavo G. Rueda  			   ³ Data ³16.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Funcao que retorna o valor de reducao da base de calculo do ICMS   ³±±
±±³          ³ utilizando a regra convencional (SENTO/OUTROS/BASE) ou recalcu-   ³±±
±±³          ³ conforme percentual de reducao gravada na tabela CD2              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ExpN1 := SPEDVlBSRD(lAchouCD2,cAliasCD2,lAchouSF4,cAliasSF4,;      ³±±
±±³          ³                    cAliasSFT,lCalcCD2)                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³lPar1 - Flag de registro valido para a tabela CD2                  ³±±
±±³          ³cPar2 - Alias da tabela CD2 para processamento                     ³±±
±±³          ³lPar3 - Flag de registro valido para a tabela SF4                  ³±±
±±³          ³cPar4 - Alias da tabela SF4 para processamento                     ³±±
±±³          ³cPar5 - Alias da tabela SFT para processamento                     ³±±
±±³          ³lPar6 - Flag que determina o tipo de tratamento para retorno do    ³±±
±±³          ³        valor de reducao. (.T.) conforme tabela CD2, (.F.) conforme³±±
±±³          ³        gravacao dos campos ISENTO/OUTROS/BASE                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpN1 - Valor de reducao da base de calculo                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPEDVlBSRD(lAchouCD2,cAliasCD2,lAchouSF4,cAliasSF4,cAliasSFT,lCalcCD2)
Local	nRedBSICM	:=	0
Local	lAtvPerm 	:= .F.
Local	lConsumo 	:= .F.
Local	nVlrRed		:=	0
Local	lNRPRBIC	:=  SuperGetMv("MV_NRPRBIC",,.F.)		//Parâmetro indicando para não recalcular a parcelo referente a redução de base de cálculo de ICMS.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Identificacao de material de uso e consumo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Substr(Alltrim((cAliasSFT)->FT_CFOP),2,3)$"97 " .Or.;
	(Substr(Alltrim((cAliasSFT)->FT_CFOP),2,3)$"556" .And. Substr(Alltrim((cAliasSFT)->FT_CLASFIS),2,2)<>"40") 
   	lConsumo := .T.             
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Identificacao de ativo permanente³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Substr(Alltrim((cAliasSFT)->FT_CFOP),2,3)$"91 " .Or. Substr(Alltrim((cAliasSFT)->FT_CFOP),2,3)$"551"
	lAtvPerm := .T.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Leitura da tabela de imposto quebrada por IMPOSTO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lAchouCD2
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³While na tabela CD2 JAH FILTRADA para achar o percentual de reducao        ³
	//³  da base de calculo do ICM, pois eh utilizado em varios registros e nao eh³
	//³ correto utilizar do TES, pois pode nao existir SF4 ou nao corresponder ao ³
	//³ documento gerado, pois eh um cadastro e pode sofrer alteracoes.           ³
	//|Depois da nota gerada a informacao nao pode ser alterada, somente se       |
	//| excluir a NF e gerar de novo                                              |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nRedBSICM	:=	(cAliasCD2)->CD2_PREDBC

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se nao existir CD2, ae nao tem como, tem que pegar do TES³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf lAchouSF4
	nRedBSICM	:=	(cAliasSF4)->F4_BASEICM

EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se houver reducao de base de calculo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nRedBSICM>0

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³Se o produto estiver amarrado a uma excecao fiscal e o TES nao ³
  //³calcula ICMS e livros Fiscais = ISENTO, Red. de Base retorna 0 ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If (cAliasSF4)->F4_LFICM == "I" .And. (cAliasSF4)->F4_ICM == "N"
  	nVlrRed	:= 0
  Else
  
  	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se efetuar o tratamento de reducao via CD2, refaco o calculo utilizando³
	//³ o % gravado na tabela.                                                ³
	//³                                                                       ³
	//³Se NAO efetuar o tratamento via CD2, faco o processamento utilizando   ³
	//³ os valores gravados em OUTROS/ISENTO/BASE                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lCalcCD2
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³As reducoes de base se comportam diferente para Ativo Fixo/Mat. de uso/consumo³
		//³ que o restante das operacoes.                                                ³
		//³                                                                              ³
		//³Para Ativo Fixo e/ou Material de Uso e Consumo, sempre a base do ICMS eh      ³
		//³ escriturado como outros, e quando cabe reducao de base de calculo, uma       ³
		//³ parte fica em outros e o valor da reducao vai para isento.                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		If lAtvPerm .Or. lConsumo
			nVlrRed	:=	(cAliasSFT)->(FT_OUTRICM+FT_ISENICM)
			nVlrRed	-=	(cAliasSFT)->(FT_OUTRICM+FT_ISENICM)*nRedBSICM/100
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Caso a base de calculo do ICMS seja zero, deve-se realizar o calculo da reducao de base pelos livros 			   ³
			//³Outros/Isento, pois a variavel nRedBSICM indica que existe reducao na nf,e a mesma deve ser levada para o campo 10  ³
			//³do registro C190 do Sped Fiscal                                                                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
			If (cAliasSFT)->FT_BASEICM == 0
				If (cAliasSFT)->FT_OUTRICM > 0
					nVlrRed	:=	(cAliasSFT)->FT_OUTRICM					
				ElseIf (cAliasSFT)->FT_ISENICM > 0			
					nVlrRed	:=	(cAliasSFT)->FT_ISENICM	
				EndIf               
				//Irá fazer cálculo se parâmetro MV_NRPRBIC estiver igual a .F.
				If !lNRPRBIC
					nVlrRed := nVlrRed - (nVlrRed * (nRedBSICM/100))
				EndIF
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Se o parâmetro MV_NRPRBIC estiver como .T. não irá refazer o cálculo da parcela de ICMS referente a redução de base de cálculo,³ 
				//³	e sim irá considerar o valor jpa gravado na SFT no campo FT_OUTRICM ou FT_ISENICM.                                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lNRPRBIC 
					If (cAliasSFT)->FT_ISENICM > 0			
						nVlrRed	:=	(cAliasSFT)->FT_ISENICM	
					ElseIf (cAliasSFT)->FT_OUTRICM > 0
						nVlrRed	:=	(cAliasSFT)->FT_OUTRICM				
					EndIF
				Else
					nVlrRed	:=	((cAliasSFT)->FT_BASEICM*100)/nRedBSICM
					nVlrRed	-=	(cAliasSFT)->FT_BASEICM
				EndIF
			EndIf
		EndIf

	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³As reducoes de base se comportam diferente para Ativo Fixo/Mat. de uso/consumo³
		//³ que o restante das operacoes.                                                ³
		//³                                                                              ³
		//³Para Ativo Fixo e/ou Material de Uso e Consumo, sempre a base do ICMS eh      ³
		//³ escriturado como outros, e quando cabe reducao de base de calculo, uma       ³
		//³ parte fica em outros e o valor da reducao vai para isento.                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lAtvPerm .Or. lConsumo
			If (cAliasSFT)->FT_OUTRICM>0 .And. (cAliasSFT)->FT_ISENICM>0
				nVlrRed	:=	(cAliasSFT)->FT_ISENICM
			EndIf		
		
		Else				
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Caso a base de calculo do ICMS seja zero, deve-se realizar o calculo da reducao de base pelos livros 			   ³
			//³Outros/Isento, pois a variavel nRedBSICM indica que existe reducao na nf,e a mesma deve ser levada para o campo 10  ³
			//³do registro C190 do Sped Fiscal                                                                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
			If (cAliasSFT)->FT_BASEICM == 0
				If (cAliasSFT)->FT_OUTRICM > 0
					nVlrRed	:=	(cAliasSFT)->FT_OUTRICM					
				ElseIf (cAliasSFT)->FT_ISENICM > 0			
					nVlrRed	:=	(cAliasSFT)->FT_ISENICM	
				EndIf               
				//Irá fazer cálculo se parâmetro MV_NRPRBIC estiver igual a .F.
				If !lNRPRBIC
					nVlrRed := nVlrRed - (nVlrRed * (nRedBSICM/100))
				EndIf
			Else						
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Para os casos de reducao normal de base de calculo, uma parte eh  ³
				//³ tributado e outra (reducao) vai para a coluna OUTROS ou ISENTO   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If (cAliasSFT)->FT_BASEICM>0 .And. (cAliasSFT)->FT_OUTRICM>0
					nVlrRed	:=	(cAliasSFT)->FT_OUTRICM	
				EndIf
				
				If (cAliasSFT)->FT_BASEICM>0 .And. (cAliasSFT)->FT_ISENICM>0			
					nVlrRed	:=	(cAliasSFT)->FT_ISENICM	
				EndIf
			EndIf
		EndIf
	EndIf
  EndIf
EndIf
Return nVlrRed
         
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³SpedCkApST³ Autor ³Gustavo G. Rueda       ³ Data ³22.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao utilizada processar alguns valores de ICMS/ST por UF,³±±
±±³          ³ baseado no array aApuracao passado por parametro que eh o  ³±±
±±³          ³ resultado da chamada da RESUMEF3.                          ³±±
±±³          ³Estas informacoes irao compor o registro E210               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpA1 -> Retorna um array com as informacoes necessarias    ³±±
±±³          ³         para gerar alguns campos do registro E210:         ³±±
±±³          ³         [1] Valor a ser levado no campo 3 do registro E210 ³±±
±±³          ³         [2] Valor a ser levado no campo 4 do registro E210 ³±±
±±³          ³         [3] Valor a ser levado no campo 6 do registro E210 ³±±
±±³          ³         [4] Valor a ser levado no campo 8 do registro E210 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³aApuracao -> Array com o retorno da cahamada da RESUMEF3    ³±±
±±³          ³nApuracao	-> Variavel que define o tipo de apuracao. Padrao ³±±
±±³          ³             = 3 = Mensal                                   ³±±
±±³          ³nPeriodo  -> Identifica o periodo, Padrao 1 = 1. periodo    ³±±
±±³          ³cNrLivro  -> Numero do livro a ser tratado                  ³±±
±±³          ³cArqAnt   -> Arquivo do periodo anterior caso seja informado³±±
±±³          ³cMVEstado -> Conteudo do paramentro MV_ESTADO               ³±±
±±³          ³cUF       -> UF a ser considerado no processamento          ³±±
±±³          ³cMVSUBTRIB-> Conteudo do parametro MV_SUBTRIB               ³±±
±±³          ³dDataRef  -> Data final do periodo selecionado              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SpedCkApST(aApuracao,nApuracao,nPeriodo,cNrLivro,cArqAnt,cMVEstado,cUF,cMVSUBTRIB,dDataRef)
Local	nX			:=	0
Local	nMes 		:=	Month(dDataRef)
Local	nAno		:=	Year(dDataRef)
Local	lArqAnt		:=	SuperGetMv("MV_APURANT",,"")
Local	cMVCFE210	:=	SpedPrSeq("MV_CFE210","1410,1411,1414,1415,1660,1661,1662,2410,2411,2414,2415,2660,2661,2662")
Local	cMVCFERES	:=	SpedPrSeq("MV_CFERES","1603,2603")
Local	aRetorno	:=	{0,0,0,0,0}

For nX := 1 to len(aApuracao)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Processa entradas e devolucoes³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aApuracao[nX,1]==cUF .And. SubStr(AllTrim(aApuracao[nX,2]),1,1)$"1256"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento para as entradas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Val(SubStr(AllTrim(aApuracao[nX,2]),1,1))<=2
			If AllTrim(aApuracao[nX,2])$cMVCFERES
				aRetorno[5]	+= 	aApuracao[nX,3] 	//Ressarcimento ICMS
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Para as notas fiscais de entrada tipo devolucao, apos retorno da SEFAZ e analise das regras do layout e validacao do PVA,³
			//³  chegou-se a seguinte conclusao:                                                                                        ³
			//³                                                                                                                         ³
			//³Para as notas fiscais de entrada tipo devolucao, o valor de ICMS/ST somente deverah ser considerado nos registro C100,   ³
			//³  C170, C190 e E210, quando o contribuinte tiver IE no estado emitente do documento (FT_ESTADO estah contido no          ³
			//³  SUBTRIB), caso contrario deverah levar ZERO nos respectivos campos, pois a NF original, a de saida, teve o ICMS/ST     ³
			//³  recolhido antecipadamente, nao tendo como compensar o credito. Quando houver IE no estado do emitente, segue o fluxo   ³
			//³  normal, pois como o valor do ICMS/ST serah recolhido via Auracao, terah com compensar o debito pelo credito.           ³
			//³                                                                                                                         ³
			//³Base legal: Alteracao efetuada conforme FNC 00000001419/2011, que contem uma consulta da SEFAZ embasando o entendimento  ³
			//|  acmia.                                                                                                                 |
			//³                                                                                                                         ³
			//³ Alteracao 19.08.2011 - FNC 00000016165/2011-01                                                                          ³
			//³ Tratamento para acordo entre os estados preenchidos no parametro MV_STNIEUF, quando em um movimento com ICMS-ST NAO e'  ³
			//³ necessario ter Incsc.Est. (MV_SUBTRIB NAO preenchido) Este tratamento foi feit a partir da necessidade das UF d MG p/ PR³
			//³ onde existe esse acordo. PROTOCOLO ICMS CONSELHO NACIONAL DE POLÍTICA FAZENDÁRIA - CONFAZ Nº 191 DE 11.12.2009          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			ElseIf (aApuracao[nX,1]==cMVEstado .Or. (!aApuracao[nX,1]==cMVEstado .And. (aApuracao[nX,1]$cMVSUBTRIB .OR. ((cMVEstado+aApuracao[nX,1])$AllTrim(SUPERGETMV("MV_STNIEUF",.F.,""))) )  )   ) .And. AllTrim(aApuracao[nX,2])$cMVCFE210
		 		aRetorno[2] += aApuracao[nX,3]		//Valor ICMS - ST
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Mesmo estado do contribuinte³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		 	Elseif aApuracao[nX,1]==cMVEstado .And. aApuracao[nX,1]==cUF
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Credito de ST por entrada soh sera considerado quando do mesmo estado do contribuinte ³
				//³ Conforme descrito no MATA953 (consulta IOB em 01/11/2006)                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		 		aRetorno[3]	+= 	aApuracao[nX,3] 	//Valor ICMS - ST
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Outros estados que ele tambem tem inscricao, mais que nao eh³
			//³  o mesmo dele                                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Else
		   		aRetorno[3] += aApuracao[nX,4] 	//Valor ICMS - ST
			EndIf			
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Mesmo estado do contribuinte³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aApuracao[nX,1]==cMVEstado
				aRetorno[4] 	+= aApuracao[nX,3] 	//Valor ICMS - ST
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Outros estados que ele tambem tem inscricao, mais que nao eh³
			//³  o mesmo dele                                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Else
				aRetorno[4] += aApuracao[nX,5] 	//Valor ICMS - ST
            EndIf
	 	EndIf
	EndIf
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso o parametro indique, o nome do arquivo do periodo anterior³
//³sera montado automaticamente pela rotina.                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cArqAnt)
	If lArqAnt
		If nMes == 1
			nAno := nAno - 1
			nMes := 12
		Else 
			nMes := nMes - 1
		Endif 
		
		cArqAnt := NmArqApur("ST",nAno,nMes,nApuracao,nPeriodo,cNrLivro)
	Endif
EndIf

// Se o nome foi preenchido ou montado
If !Empty(cArqAnt)
	cArqAnt := AllTrim(cArqAnt) 
   	nValor := LoadAnt(substr(cArqAnt,1,Len(cArqAnt)-3)+"ST"+substr(cArqAnt,Len(cArqAnt),1),"1"+cUF)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³So' soma se o valor retornado na variavel nValor for negativo, ³
	//³pois assim sabemos que se trata de um cre'dito do periodo      ³
	//³anterior. Nao somando os valores de de'bito ST.                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aRetorno[1]	+= Iif(nValor<0,Abs(nValor),0)
EndIf 

Return aRetorno

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± 
±±³ÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ±±
±±³Programa  ³SpedApDoc ³ Autor ³Gustavo G. Rueda       ³ Data ³31.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao utilizada para obter alguns valores de de apuracao   ³±±
±±³          ³ durante o processamento dos documentos fiscais.            ³±±
±±³          ³Os calculos abaixos foram copiados do programa FISXAPUR,    ³±±
±±³          ³ portanto qualquer alteracao que haja lah ou aqui, ela deve ³±±
±±³          ³ ser replicada, pois ambas devem chegar ao mesmo VALOR      ³±±
±±³          ³Ela foi replicada para economizar processamento, pois se    ³±±
±±³          ³ chamassemos a RESUMEF3, processaria o livro fiscal duas    ³±±
±±³          ³ vezes, tornando a rotina muito lenta.                      ³±±
±±³          ³                                                            ³±±
±±³          ³O array aApuracao desta rotina corresponde ao array         ³±±
±±³          ³ aApuracao da RESUMEF3 da seguinte forma:                   ³±±
±±³          ³                                                            ³±±
±±³          ³aApuracao[1](SPEDFISCAL) eh igual ao aApuracao[08](FISXAPUR)³±±
±±³          ³aApuracao[2](SPEDFISCAL) eh igual ao aApuracao[12](FISXAPUR)³±±
±±³          ³aApuracao[3](SPEDFISCAL) eh igual ao aApuracao[13](FISXAPUR)³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpA1 -> Retorna um array com as informacoes necessarias    ³±±
±±³          ³         para gerar alguns campos do registro E210:         ³±±
±±³          ³         [1] UF do documento                                ³±±
±±³          ³         [1] CFOP do item do documento                      ³±±
±±³          ³         [2] Valor total de ICMS/ST das devolucoes          ³±±
±±³          ³         [3] Valor total de ajustes Outros Creditos e/ou    ³±±
±±³          ³             Estorno de debitos                             ³±±
±±³          ³         [4] Valor total de ICMS Retido por ST              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cEntSai   -> Flag de entrada=1,saida=2                      ³±±
±±³          ³cMv_StUfS	-> Conteudo do parametro MV_STUFS                 ³±±
±±³          ³cMv_StUf	-> Conteudo do parametro MV_STUF                  ³±±
±±³          ³lResF3FT  -> Conteudo do parametro MV_RESF3FT               ³±±
±±³          ³cAliasSFT -> Alias para a tabela SFT (QUERY)                ³±±
±±³          ³lUsaSped  -> Conteudo do parametro MV_USASPED               ³±±
±±³          ³lImpCrdST -> Opcao configurada no WIZARD da rotina          ³±±
±±³          ³aCmpAntSFT-> Campos de cabecalho do documento               ³±±
±±³          ³cMVEstado -> Conteudo do parametro MV_ESTADO                ³±±
±±³          ³aRetorno -> Variavel a ser retornada por referencia         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SpedApDoc(cEntSai,cMv_StUfS,cMv_StUf,lResF3FT,cAliasSFT,lUsaSped,lImpCrdST,aCmpAntSFT,cMVEstado,aRetorno)
Local	lSTSaida 	:= .F.
Local	lProcST		:= .T.
Local	aApuracao	:=	{0,0,0}
Local	nPos		:=	0

//----------------------------------- INICIO DO TRECHO COPIADO DO FISXAPUR ----------------------------------//

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Trecho copiado do FISXAPUR, se houver alteracao lah, ela deve refletir aqui. O inverso tambem.³
//|                                                                                              ³
//³Tratamento para os valores de ICMS Retido na SAIDA                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cEntSai=="2"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica a existencia do parametro para ICMS Retido na saida.³
	//³Caso esteja preenchido, apenas as UFs indicadas no mesmo     ³
	//³devem ser processadas na saida. Caso contrario, a regra do   ³
	//³MV_STUF foi mantida (tanto para entradas como para saidas),  ³
	//|codigo mais abaixo                                           |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cMv_StUfS) 

		If (cAliasSFT)->FT_ESTADO $ cMv_StUfS

			If lResF3FT
				If lUsaSped
					aApuracao[1]	+=	(cAliasSFT)->(Iif(FT_ICMSRET>0,FT_ICMSRET,FT_OBSSOL)) 	//ICMSRET
				Else
					If cMvEstado$"RJ"
						If (cAliasSFT)->FT_ESTADO$"RJ"
							aApuracao[1]	+=	(cAliasSFT)->(Iif(FT_ICMSRET>0,FT_ICMSRET,FT_OBSSOL)) 	//ICMSRET
						EndIf
					Else
						aApuracao[1]	+=	(cAliasSFT)->(Iif(FT_ICMSRET>0,FT_ICMSRET,FT_OBSSOL)) 		//ICMSRET
					EndIf
				EndIf
				lSTSaida := .T.

			Else
				If lUsaSped
					aApuracao[1]	+= SF3->F3_ICMSRET 
				Else
					If cMvEstado$"RJ"							
						aApuracao[1]	+=	Iif(SF3->F3_ESTADO$cMvEstado,SF3->F3_ICMSRET,0) 	//ICMSRET
					Else
						aApuracao[1]	+=	SF3->F3_ICMSRET 	//ICMSRET
					EndIf
				EndIf
				lSTSaida := .T.
			Endif
		Else
			lProcST := .F.
		Endif
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Trecho copiado do FISXAPUR, se houver alteracao lah, ela deve refletir aqui. O inverso tambem.³
//|                                                                                              ³
//³Tratamento para os valores de ICMS Retido das ENTRADAS e SAIDAS                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (!Empty(cMv_StUf) .And. (cAliasSFT)->FT_ESTADO$cMv_StUf) .Or. Empty(cMv_StUf)

	If !lSTSaida .And. lProcST                            

		If lResF3FT
			If lUsaSped
				aApuracao[1]	+= (cAliasSFT)->(Iif(FT_ICMSRET>0,FT_ICMSRET,FT_OBSSOL)) 	//ICMSRET
			Else
				If cMvEstado$"RJ"
					If (cAliasSFT)->FT_ESTADO$cMvEstado
						aApuracao[1]	+=	(cAliasSFT)->(Iif(FT_ICMSRET>0,FT_ICMSRET,FT_OBSSOL)) 	//ICMSRET
					EndIf
				Else
					aApuracao[1]	+=	(cAliasSFT)->(Iif(FT_ICMSRET>0,FT_ICMSRET,FT_OBSSOL)) 		//ICMSRET
				EndIf
			EndIf
		Else
			If lUsaSped
				aApuracao[1] += SF3->F3_ICMSRET 	
			Else
				If cMvEstado$"RJ"							
					aApuracao[1]	+=	Iif(SF3->F3_ESTADO$cMvEstado,SF3->F3_ICMSRET,0) 	//ICMSRET
				Else
					aApuracao[1]	+=	SF3->F3_ICMSRET 	//ICMSRET
				EndIf
			EndIf
		Endif
	Endif
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para o ICMS Solidario conforme configuracao do CredST.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lResF3FT .And. (cAliasSFT)->FT_SOLTRIB>0
	If (cAliasSFT)->FT_CREDST$" #1"
		If lImpCrdSt .And. (((!Empty(cMv_StUf) .And. (cAliasSFT)->FT_ESTADO$cMv_StUf) .Or. Empty(cMv_StUf)) .And.lProcST) .Or. lSTSaida
   	    	If lUsaSped
				aApuracao[1]	-=	(cAliasSFT)->FT_SOLTRIB    
			Else
		   		If cMvEstado$"RJ"
		   			If (cAliasSFT)->FT_ESTADO$cMvEstado
			   			aApuracao[1]	-=	(cAliasSFT)->FT_SOLTRIB
		   			EndIf
		   		Else
		   			aApuracao[1]	-=	(cAliasSFT)->FT_SOLTRIB
		   		EndIf
			EndIf
		EndIf

	ElseIf (cAliasSFT)->FT_CREDST=="3"
		If lUsaSped
			aApuracao[1]	-=	IIf(lImpCrdSt,(cAliasSFT)->FT_SOLTRIB,(cAliasSFT)->(Iif(FT_ICMSRET>0,FT_ICMSRET,FT_OBSSOL)))  
		Else
	   		If cMvEstado$"RJ"
	   			If (cAliasSFT)->FT_ESTADO$cMvEstado
					aApuracao[1]	-=	IIf(lImpCrdSt,(cAliasSFT)->FT_SOLTRIB,(cAliasSFT)->(Iif(FT_ICMSRET>0,FT_ICMSRET,FT_OBSSOL)))  
				EndIf
			Else
				aApuracao[1]	-=	IIf(lImpCrdSt,(cAliasSFT)->FT_SOLTRIB,(cAliasSFT)->(Iif(FT_ICMSRET>0,FT_ICMSRET,FT_OBSSOL)))  
			EndIf   
		EndIf
	EndIf

ElseIf SF3->F3_SOLTRIB>0
	If SF3->F3_CREDST$" #1"
		If lImpCrdSt .And. (((!Empty(cMv_StUf) .And. SF3->F3_ESTADO$cMv_StUf) .Or. Empty(cMv_StUf)) .And. lProcST) .Or. lSTSaida
			If lUsaSped
				aApuracao[1]	-=	SF3->F3_SOLTRIB 
			Else
		   		If cMvEstado$"RJ"
		   			If SF3->F3_ESTADO$cMvEstado
						aApuracao[1]	-=	SF3->F3_SOLTRIB 
		   			EndIf
		   		Else
					aApuracao[1]	-=	SF3->F3_SOLTRIB 
				EndIf
			EndIf
		EndIf
	EndIf
		
ElseIf SF3->F3_CREDST=="3" 
	If lUsaSped
		aApuracao[1]	-=	SF3->(IIf(lImpCrdSt,F3_SOLTRIB,F3_ICMSRET))
	Else
   		If cMvEstado$"RJ"
   			If SF3->F3_ESTADO$cMvEstado
				aApuracao[1]	-=	SF3->(IIf(lImpCrdSt,F3_SOLTRIB,F3_ICMSRET))
			EndIf
		Else
			aApuracao[1]	-=	SF3->(IIf(lImpCrdSt,F3_SOLTRIB,F3_ICMSRET))
		EndIf

	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ICMS Retido Fonte - PB-RICMS Anexo 46                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cEntSai=="2"
	If cMvEstado$"PB" .And. SA1->(FieldPos("A1_REGPB")) > 0  
		If aCmpAntSFT[37]=="1"
   			aApuracao[1] -= (cAliasSFT)->FT_ICMSRET
   		Endif	
	EndIf	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processamento das notas fiscais de entrada tipo DEVOLUCAO. Devolucao de vendas com ICMS Retido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cEntSai=="1" .And. (cAliasSFT)->FT_TIPO=="D"
	If lResF3FT 
		If (cAliasSFT)->FT_CREDST<>"4"
			aApuracao[2]	+=	(cAliasSFT)->(Iif(FT_ICMSRET>0,FT_ICMSRET,FT_OBSSOL))	//ICMSRET
		Endif

	Else
		If SF3->F3_CREDST<>"4"
			aApuracao[2]	+=	SF3->F3_ICMSRET
		Endif
	Endif
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processamento das Notas Fiscais de SAIDA tipo NORMAL para obter o valor do ICMS Retido na SAIDA³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf cEntSai=="2" .And. (cAliasSFT)->FT_TIPO!="D"
	If lResF3FT
		aApuracao[3]	+=	(cAliasSFT)->(Iif(FT_ICMSRET>0,FT_ICMSRET,FT_OBSSOL))	//ICMSRET
	Else
		aApuracao[3]	+=	SF3->F3_ICMSRET
	Endif
EndIf			


//----------------------------------- FIM DO TRECHO COPIADO DO FISXAPUR ----------------------------------//

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para cumulatividade de valor por UF+CFOP³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (nPos := aScan(aRetorno,{|aX|aX[1]==(cAliasSFT)->FT_ESTADO .And. aX[2]==(cAliasSFT)->FT_CFOP}))==0
	aAdd(aRetorno,{(cAliasSFT)->FT_ESTADO,(cAliasSFT)->FT_CFOP,aApuracao[1],aApuracao[2],aApuracao[3]})
Else
	aRetorno[nPos,3]	+=	aApuracao[1]
	aRetorno[nPos,4]	+=	aApuracao[2]
	aRetorno[nPos,5]	+=	aApuracao[3]
EndIf

Return
      
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³SpedBGCIAP| Autor ³Gustavo G. Rueda 			   ³ Data ³18.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Funcao utilizada para montar um array com as informacoes dos       ³±±
±±³          ³ documentos de acordo com o tipo de movimento para gerar os        ³±±
±±³          ³ registro G130 e G140                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³lTop       -> Flag que indica processamento em ambiente TOP        ³±±
±±³          ³lAchouSN3  -> Flag de SEEK da tabela SN1 e SN3                     ³±±
±±³          ³lAchouSD1  -> Flag que indica posicionamento da tabela SD1 para o  ³±±
±±³          ³  documento de entrada                                             ³±±
±±³          ³cMVF9CTBCC -> Conteudo do parametro MV_F9CTBCC                     ³±±
±±³          ³aCmpsSF9   -> Informacoes processadas atraves de parametros para   ³±±
±±³          ³   dados dos documentos de entrada que nao existam no sistema      ³±±
±±³          ³lCtbInUse  -> Flag que determina se eh CTB ou SIGACON              ³±±
±±³          ³cMVF9GENCC -> Conteudo do parametro MV_F9GENCC, centro de custo    ³±±
±±³          ³              generico para quando o fluxo padrao do sistema não   ³±±
±±³          ³              encontrar no cadastro.                               ³±±
±±³          ³cMVF9GENCT -> Conteudo do parametro MV_F9GENCT, conta contabil     ³±±
±±³          ³              generico para quando o fluxo padrao do sistema não   ³±±
±±³          ³              encontrar no cadastro.                               ³±±
±±³          ³lF9SKPNF   -> Conteudo do paramentro MV_F9SKPNF                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SpedBGCIAP(lAchouSB1,lAchouSN3,lAchouSD1,cMVF9CTBCC,aCmpsSF9,lCtbInUse,cMVF9GENCC,cMVF9GENCT,lF9SKPNF,lConcFil)
Local	cCContab	:=	""
Local	cCCusto		:=	""
Local	cFuncaoBem	:=	""
Local   cFilConta	:=  ""	
Local   cFilCCusto	:=  ""

Default	lF9SKPNF	:= .F.
DEFAULT 	lConcFil	:= .T.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para obter a filial da tabela³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lConcFil
	If lCtbInUse	
		cFilConta	:=	xFilial("CT1")
		cFilCCusto	:=	xFilial("CTT")
	Else
		cFilConta	:=	xFilial("SI1")
		cFilCCusto	:=	xFilial("SI3")
	EndIf
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Faco a seguinte ordem de pesquisa:                                      ³
//³                                                                        ³
//³Primeiro procuro SN3;                                                   ³
//³Se nao encontrar, localizo a NF;                                        ³
//³Se nao encontrar, conforme parametro MV_F9CTBCC, utilizo a informacao do³
//³  produto (se tiver) ou do proprio SF9                                  ³
//³                                                                        ³
//³Porém caso o parâmetro MV_F9SKPNF estiver habilitado, toda a ordem      ³
//³ de pesquisa deve ser ignorada, assim buscando todas as informações da  ³
//³ tabela SF9                                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lAchouSN3
	cCContab	:=	SN3->N3_CCONTAB
	cCCusto		:=	SN3->N3_CUSTBEM
	cFuncaoBem	:=	SN3->N3_HISTOR

ElseIf lAchouSD1 .And. Len(Alltrim(SD1->D1_CONTA))>0 .And. Len(Alltrim(SD1->D1_CC))>0 	
	cCContab	:=	SD1->D1_CONTA
	cCCusto		:=	SD1->D1_CC


Else
	If cMVF9CTBCC=="1" .And. lAchouSB1
		cCContab	:=	SB1->B1_CONTA
		cCCusto		:=	SB1->B1_CC
	Else
		cCContab	:=	aCmpsSF9[14]
		cCCusto		:=	aCmpsSF9[12]
	EndIf 
	
EndIf     

if !lAchouSN3 .And. !empty(aCmpsSF9[10]) 
	cFuncaoBem	:=	aCmpsSF9[10]  
Elseif 	!lAchouSN3 .And. empty(aCmpsSF9[10])
    cFuncaoBem	:= SF9->F9_FUNCIT	
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para quando for setado atraves do parametro para nao utilizar³
//³  as informacoes do documento fiscal                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lF9SKPNF
	cCContab	:=	aCmpsSF9[14]
	cCCusto		:=	aCmpsSF9[12]
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento dos parametro abaixo para quando o tratamento acima retornar BRANCO, ou seja,       ³
//³  nao encontrar a informacoes atraves das amarracoes do sistema. Estes parametros possibilitam ³
//³  um tratamento generico para o centro de custo e a conta contabil.                            ³
//³                                                                                               ³
//³cMVF9GENCC -> Conteudo do parametro MV_F9GENCC                                                 ³
//³cMVF9GENCT -> Conteudo do parametro MV_F9GENCT                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cCContab)
	cCContab	:=	PadR(&cMVF9GENCT,TamSx3("B1_CONTA")[1])
EndIf
If Empty(cCCusto)
	cCCusto		:=	PadR(&cMVF9GENCC,TamSx3("B1_CC")[1])
EndIf
cCContab	:=	cCContab+cFilConta
cCCusto		:=	cCCusto+cFilCCusto

Return{cCContab,cCCusto,cFuncaoBem}

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³SpedBGQf9 | Autor ³Gustavo G. Rueda 			   ³ Data ³17.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Funcao para retornar a quantidade de registros na tabela SF9 de    ³±±
±±³          ³ determinado item de entrada, nos casos de desmembramento de bens. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cNumnota - Numero da NF de entrada                                 ³±±
±±³          ³dtDigit  - Data de digitacao da NF de entrada                      ³±±
±±³          ³cSerie   - Serie da NF de entrada                                  ³±±
±±³          ³cFor     - Fornededor da NF de entrada                             ³±±
±±³          ³cLojaFor - Loja do Fornecedor da NF de entrada                     ³±±
±±³          ³cItem    - Item da NF de entrada                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SpedBGQf9(cNumnota,dtDigit,cSerie,cFor,cLojaFor,cItem)
Local	nCont		:=	0 
Local	aAreaSF9	:=	SF9->(GetArea())

dbSelectArea("SF9")			
SF9->(dbSetOrder(2))
If SF9->(dbSeek(xFilial("SF9")+DToS(dtDigit)+cNumnota+cSerie+cFor+cLojaFor)) 
	While SF9->(!Eof() .And. F9_ITEMNFE==cItem .And. F9_DTENTNE==dtDigit .And. F9_DOCNFE==cNumnota .And. F9_SERNFE==cSerie .And. F9_FORNECE==cFor .And. F9_LOJAFOR==cLojaFor)
		nCont += 1
		SF9->(dbskip())
	EndDo      
EndIf 

RestArea(aAreaSF9)
Return nCont
         
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³SpedPrSeq | Autor ³Gustavo G. Rueda              ³ Data ³03.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Funcao para ler varios paramentros que se iniciam com o mesmo      |±±
±±³          ³ nome. Ex: MV_DCTF??? onde pode ser MV_DCTF000, MV_DCTF001,        ³±±
±±³          ³etc...                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ExpN1 := SpedPrSeq(cPar,cContPad)                                   ³±±
±±³          ³                                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³cRet -> Conteudo do parametro                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cPar -> Nome do parametro                                          ³±±
±±³          ³cContPad -> Conteudo padrao a ser retornado caso o mesmo nao       ³±±
±±³          ³ exista.                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SpedPrSeq(cPar,cContPad)
Local	cRet	:=	""

Default	cPar	:=	""

cPar	:=	AllTrim(cPar)

//Leitura exclusiva
If SX6->(DbSeek (cFilAnt+cPar))
	Do While !SX6->(Eof ()) .And. (cPar$SX6->X6_VAR) .And. (cFilAnt==SX6->X6_FIL)
		If !Empty(SX6->X6_CONTEUD)
			cRet	+=	"/"+AllTrim (SX6->X6_CONTEUD)
		EndIf
		SX6->(DbSkip ())
	EndDo
EndIf	
	
//Leitura Compartilhada
If SX6->(DbSeek (PadR("",FWGETTAMFILIAL)+cPar))
	Do While !SX6->(Eof ()) .And. (cPar$SX6->X6_VAR) .And. Empty(SX6->X6_FIL)
		If !Empty(SX6->X6_CONTEUD)
			cRet	+=	"/"+AllTrim (SX6->X6_CONTEUD)
		EndIf
		SX6->(DbSkip ())
	EndDo
EndIf

If Empty(cRet)
	cRet	:=	Iif(cContPad<>Nil,cContPad,"")
EndIf

Return cRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |SpedProSE1 ³ Autor ³Gustavo G. Rueda       ³ Data ³15.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³            PROCESSAMENTO DO CONTAS A RECEBER               ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Filtro os titulos do documento fiscal                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³aParc -> Array com as parcelas do documento fiscal, onde:   ³±±
±±³          ³ [1]=Tipo                                                   ³±±
±±³          ³ [2]=Historico                                              ³±±
±±³          ³ [3]=Numero                                                 ³±±
±±³          ³ [4]=Parcela                                                ³±±
±±³          ³ [5]=Vencimento Real                                        ³±±
±±³          ³ [6]=Valor                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|aCmpAntSFT -> Informacoes do cabecalho do documento         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SpedProSE1(aCmpAntSFT, lSeek)
	Local	aParc		:=	{}
	Local	cPrefixo	:= 	aCmpAntSFT[27]
	Local 	cTipoTit	:=	SuperGetMV ("MV_C140TIT",.F.,"")
	Local	cNum		:=	aCmpAntSFT[28]
	Local	cCli		:=	aCmpAntSFT[3]
	Local	cLoj		:=	aCmpAntSFT[4]
	Local	cAliasSE1	:=	"SE1"    
	
	Default lSeek       := .F.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento para quando o PREFIXO nao estiver gravado no documento fiscal³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(cPrefixo)
		aAreaSF2	:=	SF2->(GetArea())
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se o prefixo nao estiver gravado no documento fiscal, tenho que utilizar o parametro MV_1DUPREF,³
		//³ porem o parametro eh uma macro e pode abranger ateh um rdmake, para isso, temos que manter     ³
		//³ o padrao de chamada da mesma forma do MATA461, o SF2 deve estar posicionado.                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SF2->(MsSeek(xFilial("SF2")+aCmpAntSFT[1]+aCmpAntSFT[2]+aCmpAntSFT[3]+aCmpAntSFT[4]))
		
		cPrefixo	:= 	&(SuperGetMV ("MV_1DUPREF"))
		
		RestArea(aAreaSF2)
	EndIf

	#IFDEF TOP
		If TcSrvType()<>"AS/400" .And. !lSeek
			cAliasSE1	:=	GetNextAlias()

			BeginSql Alias cAliasSE1

			COLUMN E1_VENCTO AS DATE
			COLUMN E1_VENCREA AS DATE

			SELECT 
				SE1.E1_FILIAL,SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_TIPO,SE1.E1_CLIENTE,SE1.E1_LOJA,
				SE1.E1_HIST,SE1.E1_VENCREA,SE1.E1_VALOR,SE1.E1_VLCRUZ,SE1.E1_VENCTO
			FROM 
				%Table:SE1% SE1
			WHERE 
				SE1.E1_FILIAL=%xFilial:SE1% AND
				SE1.E1_PREFIXO=%Exp:cPrefixo% AND
				SE1.E1_NUM=%Exp:cNum% AND
				SE1.E1_CLIENTE=%Exp:cCli% AND
				SE1.E1_LOJA=%Exp:cLoj% AND
				SE1.%NotDel%
			ORDER BY
				1,2,3,4,5
			EndSql
		Else
	#ENDIF
			SE1->(DbSetOrder (2))
			SE1->(dbSeek (xFilial("SE1")+cCli+cLoj+cPrefixo+cNum))
	#IFDEF TOP
		EndIf
	#ENDIF

	Do While (!(cAliasSE1)->(Eof ()) .And.;
		xFilial("SE1")==(cAliasSE1)->E1_FILIAL .And.;
		cCli==(cAliasSE1)->E1_CLIENTE .And.;
		cLoj==(cAliasSE1)->E1_LOJA .And.;
		cPrefixo==(cAliasSE1)->E1_PREFIXO .And.;
		cNum==(cAliasSE1)->E1_NUM )

		If !(AllTrim ((cAliasSE1)->E1_TIPO)$MVTAXA+"|"+MVTXA+"|"+MVABATIM+"|"+cTipoTit) .And. (Substr((cAliasSE1)->E1_TIPO,1,2) <> "NC")
			aAdd (aParc, {(cAliasSE1)->E1_TIPO, (cAliasSE1)->E1_HIST, (cAliasSE1)->E1_NUM, (cAliasSE1)->E1_PARCELA, (cAliasSE1)->E1_VENCREA, (cAliasSE1)->E1_VLCRUZ, (cAliasSE1)->E1_VENCTO})
		EndIf

		DbSelectArea (cAliasSE1)
		(cAliasSE1)->(DbSkip ())
	EndDo
	
	#IFDEF TOP
		DbSelectArea (cAliasSE1)
		(cAliasSE1)->(DbCloseArea ())
	#ENDIF

Return (aParc)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |SpedProSE2³ Autor ³Gustavo G. Rueda       ³ Data ³15.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³            PROCESSAMENTO DO CONTAS A PAGAR                 ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Filtro os titulos do documento fiscal. Copiado do MATA103x  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³aParc -> Array com as parcelas do documento fiscal, onde:   ³±±
±±³          ³ [1]=Tipo                                                   ³±±
±±³          ³ [2]=Historico                                              ³±±
±±³          ³ [3]=Numero                                                 ³±±
±±³          ³ [4]=Parcela                                                ³±±
±±³          ³ [5]=Vencimento Real                                        ³±±
±±³          ³ [6]=Valor                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|aCmpAntSFT -> Informacoes do cabecalho do documento         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SpedProSE2(aCmpAntSFT, lSeek)	//Copiado do MATA103x
	Local	aParc		:=	{}
	Local	cPrefixo	:= 	aCmpAntSFT[27]
	Local 	cTipoTit	:=	GetNewPar ("MV_C140TIT","")
	Local	cAliasSE2	:=	"SE2"
	Local	cNum		:=	aCmpAntSFT[28]
	Local	cFor		:=	aCmpAntSFT[3]
	Local	cLoj		:=	aCmpAntSFT[4]
	Local	aAreaSF1	:=	{}                           
	
	Default lSeek := .F.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento para quando o PREFIXO nao estiver gravado no documento fiscal³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(cPrefixo)
		aAreaSF1	:=	SF1->(GetArea())
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se o prefixo nao estiver gravado no documento fiscal, tenho que utilizar o parametro MV_2DUPREF,³
		//³ porem o parametro eh uma macro e pode abranger ateh um rdmake, para isso, temos que manter     ³
		//³ o padrao de chamada da mesma forma do MATA103, o SF1 deve estar posicionado.                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SF1->(MsSeek(xFilial("SF1")+aCmpAntSFT[1]+aCmpAntSFT[2]+aCmpAntSFT[3]+aCmpAntSFT[4]))
		
		cPrefixo	:= 	&(SuperGetMV ("MV_2DUPREF"))
		
		RestArea(aAreaSF1)
	EndIf

	#IFDEF TOP
		If TcSrvType()<>"AS/400" .And. !lSeek
			cAliasSE2	:=	GetNextAlias()
			
			BeginSql Alias cAliasSE2
			
			COLUMN E2_VENCTO AS DATE
			COLUMN E2_VENCREA AS DATE
			
			SELECT 
				SE2.E2_FILIAL,SE2.E2_PREFIXO,SE2.E2_NUM,SE2.E2_PARCELA,SE2.E2_TIPO,SE2.E2_FORNECE,SE2.E2_LOJA,
				SE2.E2_HIST,SE2.E2_VENCREA,SE2.E2_VALOR,SE2.E2_VLCRUZ,SE2.E2_VENCTO
			FROM 
				%Table:SE2% SE2
			WHERE 
				SE2.E2_FILIAL=%xFilial:SE2% AND
				SE2.E2_FORNECE=%Exp:cFor% AND
				SE2.E2_LOJA=%Exp:cLoj% AND
				SE2.E2_PREFIXO=%Exp:cPrefixo% AND "
				SE2.E2_NUM=%Exp:cNum% AND "
				SE2.%NotDel%
			ORDER BY
				1,2,3,4,5,6,7
			EndSql
		Else
	#ENDIF
			SE2->(DbSetOrder (6))
			SE2->(dbSeek (xFilial("SE2")+cFor+cLoj+cPrefixo+cNum))
	#IFDEF TOP
		EndIf
	#ENDIF

	Do While (!(cAliasSE2)->(Eof ()) .And.;
		xFilial("SE2")==(cAliasSE2)->E2_FILIAL .And.;
		cFor==(cAliasSE2)->E2_FORNECE .And.;
		cLoj==(cAliasSE2)->E2_LOJA .And.;
		cPrefixo==(cAliasSE2)->E2_PREFIXO .And.;
		cNum==(cAliasSE2)->E2_NUM )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Montando as parcelas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !(AllTrim ((cAliasSE2)->E2_TIPO)$MVTAXA+"|"+MVTXA+"|"+MVABATIM+"|"+cTipoTit) .And. (Substr((cAliasSE2)->E2_TIPO,1,2) <> "NC")
			aAdd (aParc, {(cAliasSE2)->E2_TIPO, (cAliasSE2)->E2_HIST, (cAliasSE2)->E2_NUM, (cAliasSE2)->E2_PARCELA, (cAliasSE2)->E2_VENCREA, (cAliasSE2)->E2_VLCRUZ, (cAliasSE2)->E2_VENCTO})
		EndIf

		(cAliasSE2)->(DbSkip())
	EndDo
	#IFDEF TOP
		(cAliasSE2)->(DbCloseArea ())
	#ENDIF

Return (aParc)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³SpedPCCG1 | Autor ³Caio César M. oliveira        ³ Data ³18.04.2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Funcao para retornar a alíquota cadastrada na tabela CG1 de acordo ³±±
±±³          ³ com o código e data informados                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cCodigo  - Código da tabela 5.1.1                                  ³±±
±±³          ³dtDigit  - Data de vigência                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDPISCOF                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SpedPCCG1(cCodigo,dtData)
Local 	lCG1 		:= AliasIndic("CG1")
Local	cCG1Alias	:= "CG1"
Local 	nAliq     	:= 0
Local 	aArea		:= GetArea()
Local 	dLastDt		:= CtoD("//")   
Local 	clIndex		:= ""     
Local 	clFiltro	:= "" 
Local 	nlIndex		:= 0  

Local 	aSetField	:= {}
Local   nI			:= 0
Local   lCg1DtIni	:= CG1->(FieldPos("CG1_DTINI"))>0    

Default cCodigo		:= ""	  
Default dtData		:= CtoD("//")

If lCG1
	DbSelectArea(cCG1Alias)
	(cCG1Alias)->( DbSetOrder(1))
	
	#IFDEF TOP
		If (TcSrvType ()<>"AS/400")
	    	
	    	cCG1Alias	:= GetNextAlias() 
	    	
	 		cSlctCG1	:= "CG1.CG1_CODIGO,	CG1.CG1_ALIQ, CG1.CG1_DTFIM"		
			If lCg1DtIni
				cSlctCG1 += ", CG1.CG1_DTINI"
				aAdd(aSetField,{"CG1_DTINI","D",8,0})    
			Endif
			
			cSlctCG1 := "%" + cSlctCG1 + "%"	
	    	
	    	BeginSql Alias cCG1Alias  
	    		
	    		COLUMN CG1_DTFIM AS DATE
	    		
	    		SELECT 
					%Exp:cSlctCG1%
					

	    		FROM 
	    			%Table:CG1% CG1 
	    		WHERE 
	    			CG1.%NotDel%   
	    			AND CG1.CG1_FILIAL	= %xFilial:CG1% 
	    			AND CG1.CG1_CODIGO	= %Exp:cCodigo%
	    		ORDER BY    
	    			CG1.CG1_DTFIM
	    	EndSql		    	
	    	
			For nI := 1 To Len(aSetField)
				TcSetField(cCG1Alias,aSetField[nI,1],aSetField[nI,2],aSetField[nI,3],aSetField[nI,4])
			Next
	
		Else
	#ENDIF              
	
	clIndex		:= CriaTrab(NIL,.F.)   
	clFiltro    := " CG1_FILIAL=='"+ xFilial("CG1") + "' "
	clFiltro    += " .AND. CG1_CODIGO=='"		+ cCodigo		+"' "
	
	IndRegua(cCG1Alias,clIndex,CG1->(IndexKey()),,clFiltro)
	nlIndex := RetIndex(cCG1Alias)
	
	#IFNDEF TOP
		dbSetIndex(clIndex+OrdBagExt())
	#ENDIF          
	
	dbSelectArea(cCG1Alias)
	dbSetOrder(nlIndex+1)
	   
	#IFDEF TOP
		Endif
	#ENDIF      
	
	While (cCG1Alias)->(!Eof())
		If lCg1DtIni		
			If !Empty((cCG1Alias)->CG1_DTINI)
		    	If (dtData>=(cCG1Alias)->CG1_DTINI) .AND. (dtData<=(cCG1Alias)->CG1_DTFIM) .AND. !Empty(dtData)
		 			nAliq := (cCG1Alias)->CG1_ALIQ
		    	EndIf  
			Elseif !Empty((cCG1Alias)->CG1_DTFIM) .AND. (dtData<=(cCG1Alias)->CG1_DTFIM) 
				nAliq := (cCG1Alias)->CG1_ALIQ
			EndIf               
		Else
			If !Empty((cCG1Alias)->CG1_DTFIM)
		    	If (dtData<=(cCG1Alias)->CG1_DTFIM) .AND. ( Empty(dLastDt) .OR. (dtData>dLastDt))
		 			nAliq := (cCG1Alias)->CG1_ALIQ
		    	EndIf  
		    	dLastDt := (cCG1Alias)->CG1_DTFIM 
			Else
				nAliq := (cCG1Alias)->CG1_ALIQ
			EndIf               
		EndIf
		(cCG1Alias)->(dbSkip())  
	EndDo               
	
	RestArea(aArea)             
	
	#IFDEF TOP
		If (TcSrvType ()<>"AS/400")
			DbSelectArea (cCG1Alias)
			(cCG1Alias)->(DbCloseArea ())
		Else
	#ENDIF
			RetIndex(cCG1Alias)
			FErase(clIndex+OrdBagExt())
	#IFDEF TOP
		EndIf
	#ENDIF
EndIf

Return nAliq
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |SpdGrIndM ³ Autor ³Gustavo G. Rueda       ³ Data ³16.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³          GRAVACAO DOS INDICADORES DE MOVIMENTO             ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Gravo os indicadores de movimento para todos os registros   ³±±
±±³          ³ a serem gerados.                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAlias -> Alias do TRB criado atraves da funcao principal.  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SpdGrIndM (cAlias)
	Local	lRet		:=	.T.
	Local	nQtd0990	:=	0
	Local	nQtdA990	:=	0
	Local	nQtdB990	:=	0
	Local	nQtdC990	:=	0
	Local	nQtdD990	:=	0
	Local	nQtdE990	:=	0 
	Local	nQtdG990	:=	0
	Local	nQtdH990	:=	0
	Local	nQtdI990	:=	0
	Local	nQtdJ990	:=	0
	Local	nQtdK990	:=	0
	Local	nQtdL990	:=	0
	Local	nQtdZ990	:=	0
	Local	nQtd1990	:=	0
	Local 	nQtd9990	:=	0
	Local	nPos		:=	0
	Local	aReg9900	:=	{}

	DbSelectArea (cAlias) 
	(cAlias)->(DbSetOrder (1))
	(cAlias)->(DbGoTop ())

	Do While !(cAlias)->(Eof ())
		
		If (nPos := aScan (aReg9900, {|aX| aX[2]==(cAlias)->TRB_TPREG}))==0
			aAdd (aReg9900, {"9900",(cAlias)->TRB_TPREG,"1"})
		Else
			aReg9900[nPos][3] := Alltrim(STR( Val( aReg9900[nPos][3] )+1))
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTROS - 0³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (Left ((cAlias)->TRB_TPREG, 1)$"0")
			nQtd0990++
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTROS - A³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf (Left ((cAlias)->TRB_TPREG, 1)$"A")
			nQtdA990++
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTROS - B³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf (Left ((cAlias)->TRB_TPREG, 1)$"B")
			nQtdB990++
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTROS - C³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf (Left ((cAlias)->TRB_TPREG, 1)$"C")
			nQtdC990++
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTROS - D³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf (Left ((cAlias)->TRB_TPREG, 1)$"D")
			nQtdD990++
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTROS - E³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf (Left ((cAlias)->TRB_TPREG, 1)$"E")
			nQtdE990++		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTROS - G³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf (Left ((cAlias)->TRB_TPREG, 1)$"G")
			nQtdG990++
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTROS - H³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf (Left ((cAlias)->TRB_TPREG, 1)$"H")
			nQtdH990++
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTROS - I³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf (Left ((cAlias)->TRB_TPREG, 1)$"I")
			nQtdI990++
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTROS - J³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf (Left ((cAlias)->TRB_TPREG, 1)$"J")
			nQtdJ990++
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTROS - K³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf (Left ((cAlias)->TRB_TPREG, 1)$"K")
			nQtdK990++
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTROS - L³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf (Left ((cAlias)->TRB_TPREG, 1)$"L")
			nQtdL990++
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTROS - Z³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf (Left ((cAlias)->TRB_TPREG, 1)$"Z")
			nQtdZ990++
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTROS - 8³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf (Left ((cAlias)->TRB_TPREG, 1)$"1")
			nQtd1990++
		EndIf	

		(cAlias)->(DbSkip ())
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gravacao do indicador de movimento do bloco 0.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	BlAbEnc ("A", cAlias, "0001", Iif (nQtd0990>0, "0", "1"),)
	BlAbEnc ("E", cAlias, "0990",, nQtd0990)
	aAdd (aReg9900, {"9900","0001","1"})
	aAdd (aReg9900, {"9900","0990","1"})
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gravacao do indicador de movimento do bloco C.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	BlAbEnc ("A", cAlias, "C001", Iif (nQtdC990>0, "0", "1"),)
	BlAbEnc ("E", cAlias, "C990",, nQtdC990)
	aAdd (aReg9900, {"9900","C001","1"})
	aAdd (aReg9900, {"9900","C990","1"})
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gravacao do indicador de movimento do bloco D.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	BlAbEnc ("A", cAlias, "D001", Iif (nQtdD990>0, "0", "1"),)
	BlAbEnc ("E", cAlias, "D990",, nQtdD990)
	aAdd (aReg9900, {"9900","D001","1"})
	aAdd (aReg9900, {"9900","D990","1"})
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gravacao do indicador de movimento do bloco E.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	BlAbEnc ("A", cAlias, "E001", Iif (nQtdE990>0, "0", "1"),)
	BlAbEnc ("E", cAlias, "E990",, nQtdE990)
	aAdd (aReg9900, {"9900","E001","1"})
	aAdd (aReg9900, {"9900","E990","1"})	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gravacao do indicador de movimento do bloco G.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cVersao >="004"
		BlAbEnc ("A", cAlias, "G001", Iif (nQtdG990>0, "0", "1"),)
		BlAbEnc ("E", cAlias, "G990",, nQtdG990)
		aAdd (aReg9900, {"9900","G001","1"})                      		
		aAdd (aReg9900, {"9900","G990","1"})                      
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gravacao do indicador de movimento do bloco H.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	BlAbEnc ("A", cAlias, "H001", Iif (nQtdH990>0, "0", "1"),)
	BlAbEnc ("E", cAlias, "H990",, nQtdH990)
	aAdd (aReg9900, {"9900","H001","1"})
	aAdd (aReg9900, {"9900","H990","1"})
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gravacao do indicador de movimento do bloco 1.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	BlAbEnc ("A", cAlias, "1001", Iif (nQtd1990>0, "0", "1"),)
	BlAbEnc ("E", cAlias, "1990",, nQtd1990)
	aAdd (aReg9900, {"9900","1001","1"})
	aAdd (aReg9900, {"9900","1990","1"})
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Outros registros que devem ser totalizados       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	aAdd (aReg9900, {"9900","9001","1"})
	aAdd (aReg9900, {"9900","9990","1"})
	aAdd (aReg9900, {"9900","9999","1"})
	aAdd (aReg9900, {"9900","9900",STR(len(aReg9900)+1)})
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gravacao do bloco 9 (Totalizacao dos registros)  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SpdReg9900(cAlias, aReg9900)
	nQtd9990 := Len(aReg9900) + 1
	BlAbEnc ("A", cAlias, "9001", Iif (nQtd9990>0, "0", "1"),)
	BlAbEnc ("E", cAlias, "9990",, nQtd9990)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gravacao do registro 9999 (Encerramento do arquivo) ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SpdReg9999(cAlias)

Return (lRet)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |BlAbEnc   | Autor ³Gustavo G. Rueda              ³ Data ³03.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³GRAVACAO DO INDICADOR DE BLOCO COM MOVIMENTO                       ³±±
±±³          ³                                                                   ³±±
±±³          ³Funcao de gravacao do indicador de bloco com movimento(0) ou       ³±±
±±³          ³ sem movimento(1) conforme passagem de parametros. Utilizado       ³±±
±±³          ³ na funcao SpdGrIndM.                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ExpN1 := BlAbEnc(cAbEnc,cAlias,cReg,cIndMov,nQtdLin)               ³±±
±±³          ³                                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAbEnt -> Indicador de Bloco de Abertura (A) ou Encerramento       ³±±
±±³          ³ (E).                                                              ³±±
±±³          ³cAlias -> Alias do TRB onde sera gravado as informacoes.           ³±±
±±³          ³cReg -> Codigo do registro                                         ³±±
±±³          ³cIndMov -> Indicador de movimento (0=Sim, 1=Nao)                   ³±±
±±³          ³nQtdLin -> Quantidade de linha do registro                         ³±±
±±³          ³                                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1 - Sempre .T.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function BlAbEnc(cAbEnc,cAlias,cReg,cIndMov,nQtdLin)
	Local	lRet		:=	.T.
	Local	aBlAbEnc	:=	{}
	//
	aAdd(aBlAbEnc, {})
	nPos	:=	Len (aBlAbEnc)
	//
	If ("A"$cAbEnc)
		aAdd (aBlAbEnc[nPos], cReg)
		aAdd (aBlAbEnc[nPos], cIndMov)
	Else
		aAdd (aBlAbEnc[nPos], cReg)
		aAdd (aBlAbEnc[nPos], Alltrim(STR(nQtdLin+2)))	// O +2 eh para somar o registro de abertura mais o registro de encerramento
	EndIf
	//
	GrvRegTrS (cAlias,,aBlAbEnc,)
Return (lRet)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³SPEDLC195 ³ Autor ³Natalia Antonucci      ³ Data ³21.12.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³     REGISTRO C195 - OBSERVACOES DO LANCAMENTO FISCAL       ³±±
±±³          ³                    (CODIGO 01 E 55)                        ³±±
±±³          ³                                                            ³±±
±±³          ³Geracao e gravacao dos Registros C195 			          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrS com o embasamento legal para tais      ³±±
±±³          ³ observacoes                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³3(1:N) Para cada C100                                       ³±±
±±³          ³4(1:N) Para cada C195                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nil                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAliasSFT-> Alias da tabela SFT em processamento         	  ³±±
±±³			 ³aLancFis  -> Array com a estrutura do registro 0150 a ser   ³±±
±±³          ³			gravado no TRB no final do processamento da rotina³±±
±±³          ³cAliasSF4-> Informa qual o alias da tabela SF4, podendo ser ³±±
±±³          ³            query                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPEDLC195( cAliasSFT , aLancFis , cAliasSF4 , cMVSPDTC95 )
Local	nPos		:=	0
Local 	cMensagem   := ""
Local	cMsgmCompl	:= ""
Default	cMVSPDTC95	:= "1"                  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Geracao do REGISTRO C195 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    
If !Empty((cAliasSF4)->F4_CODOBSE) .AND. (nPos := aScan(aLancFis,{|aX| aX[1]==(cAliasSF4)->F4_CODOBSE}))==0 
   	If !Empty((cAliasSFT)->FT_FORMULA)
   		cMensagem := (cAliasSFT)->(Formula((cAliasSFT)->FT_FORMULA)+FT_OBSERV)
   	Else
   		cMensagem := CCE->CCE_DESCR 
   	Endif
   	
   	// ----------------------------------------------------------------------------
   	//  Preenchimento do campo 03 - TXT_COMPL do registro C195
   	//  Atraves do Parametro MV_SPD3C195 o usuario ira informar como deseja
   	//  preencher este campo: 1 = SFT/CCE; 2 = CCE; 3 = SFT; 4 = vazio
   	// ----------------------------------------------------------------------------
   	If cMVSPDTC95 <> "4"
   		
   		If cMVSPDTC95 $ "1|3" .And. !Empty((cAliasSFT)->FT_FORMULA)
   			cMsgmCompl := (cAliasSFT)->(Formula((cAliasSFT)->FT_FORMULA)+FT_OBSERV)
   		Elseif cMVSPDTC95 $ "1|2"
   			cMsgmCompl := CCE->CCE_DESCR 
   		Endif
   		
   	Endif
   	
   	aAdd(aLancFis, {})
	nPos	:=	Len (aLancFis)
	aAdd (aLancFis[nPos], (cAliasSF4)->F4_CODOBSE)
	aAdd (aLancFis[nPos], cMensagem)
	aAdd (aLancFis[nPos], cMsgmCompl)
Endif	

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³SPEDDevol ³ Autor ³Luccas Curcio          ³ Data ³25.06.2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Processa as devolucoes que serao enviadas para o SPED Contri³±±
±±³          ³buicoes. 													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Para as devolucoes do mesmo periodo, devera verificar 	  ³±±
±±³          ³o regime e a operacao realizada, para aplicar a reducao	  ³±±
±±³          ³de base de calculo ou dar direito a credito - Bloco A/C/D.  ³±±
±±³          ³Para as devolucoes de outros periodos ira realizar os 	  ³±±
±±³          ³ajustes eprtinentes no bloco M	  						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nil                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³dDataDe   -> Data inicial do processamento         	  	  ³±±
±±³			 ³dDataAte  -> Data final do processamento   				  ³±±
±±³          ³cNrLivro  -> Numero do livro de processamento selecionado no³±±
±±³          ³             wizard                                         ³±±
±±º          ³nMVM996TPR-> Conteudo do Parametro MV_M996TPR               º±±
±±³          ³lTop      -> Flag que indica se estah utilizando TOP ou nao ³±±
±±³          ³cTpMov    -> Indica o tipo de movimento das devolucoes      ³±±
±±³          ³aDevol    -> Array que retorna as devolucoes do periodo     ³±±
±±³          ³aDevOutPer-> Array que retorna devolucoes de outro periodo  ³±±
±±º          ³cRegime   -> Informa o tipo do Regime                       º±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPEDDevol(dDataDe,dDataAte,cNrLivro,nMVM996TPR,lTop,cTpMov,aDevol,aDevOutPer,cRegime)
Local	lAchouSFT	:=	.F.
Local	cAliasSFT	:=	"SFT"
Local	cRegDev		:=	""
Local	cNotaOri	:=	""
Local	cIteOri		:=	""	
Local	aPar		:=	{}
Local	aAreaSFT	:=	SFT->(GetArea())
Local	nPos		:=	0
Local	nPercDevP	:=	0
Local	nPercDevC	:=	0
Local   cClie		:= ""


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Parametros que serao enviados na montagem da query das notas de devolucao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aPar,DTOS(dDataDe))
aAdd(aPar,DTOS(dDataAte))
aAdd(aPar,cNrLivro)
aAdd(aPar,Iif(cTpMov=="S","E","S"))
aAdd(aPar,nMVM996TPR)
aAdd(aPar,cRegime)
	
If (lAchouSFT := SPEDFFiltro(1,"SFTDEV",@cAliasSFT,aPar))

	Do While !(cAliasSFT)->(Eof ())
		cClie:= (cAliasSFT)->FT_CLIEFOR
	    aAreaSFT	:= SFT->(GetArea())
	    SFT->(DbSetOrder(6))
	    //FT_FILIAL+FT_TIPOMOV+FT_NFISCAL+FT_SERIE 
	    IF SFT->(MsSeek(xFilial("SFT")+cTpMov+Alltrim((cAliasSFT)->FT_NFORI+(cAliasSFT)->FT_SERORI)))
	    	Do While !SFT->(Eof ()) .And. (cAliasSFT)->FT_NFORI == SFT->FT_NFISCAL .And. (cAliasSFT)->FT_SERORI == SFT->FT_SERIE
	    		IF  Alltrim((cAliasSFT)->FT_PRODUTO) == Alltrim(SFT->FT_PRODUTO)
	    			cClie:= SFT->FT_CLIEFOR 
		    		EXIT
		    	Else 
		    		SFT->(DbSkip())	
		    	EndIf 	
		    EndDo	
	    Else
	      	cClie:= (cAliasSFT)->FT_CLIEFOR   
	    EndIf 
	    RestArea (aAreaSFT)      
	    
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Para as devolucoes de venda, preciso verificar qual o regime da operacao  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cTpMov == "S"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Ambiente DBF - Posiciono as tabelas necessarias e utilizo a funcao SPEDRegime³
			//³para verificar qual o regime da operacao 									³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If cRegime == "3" .And. !lTop
				
				SPEDSeek("SD1",1,xFilial("SD1")+(cAliasSFT)->(FT_NFISCAL+FT_SERIE+FT_CLIEFOR+FT_LOJA+FT_PRODUTO+FT_ITEM))
				SPEDSeek("SF4",1,xFilial("SF4")+SD1->D1_TES)
				SPEDSeek("SB1",1,xFilial("SB1")+(cAliasSFT)->FT_PRODUTO)
				SPEDSeek("SA1",1,xFilial("SA1")+(cAliasSFT)->(FT_CLIEFOR+FT_LOJA))
				
				If SPEDRegime(cRegime,"SF4","SB1","SA1",nMVM996TPR) == "C"
					cRegDev := "2"
				Else
					cRegDev := "1"
				Endif
	        
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Ambiente TOP - Ja possuo os campo necessarios atraves do JOIN feito na query ³
			//³Utilizo a funcao SPEDRegime para verificar qual o regime da operacao			³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Elseif cRegime == "3" .And. lTop
			
				If SPEDRegime(cRegime,cAliasSFT,cAliasSFT,cAliasSFT,nMVM996TPR) == "C"
					cRegDev := "2"
				Else
					cRegDev := "1"
				Endif
			Elseif cRegime == "2"
				cRegDev := "2"
			Else
				cRegDev := "1"
			Endif
		Endif
		
		SFT->(DbSetOrder(1))
		aAreaSFT	:= SFT->(GetArea())
		cNotaOri	:=	(cAliasSFT)->FT_NFISCAL
		cIteOri		:=	(cAliasSFT)->FT_ITEM
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciono na nota fiscal original, para calcular a porcentagem de devolucao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SFT->(MsSeek(xFilial("SFT")+cTpMov+(cAliasSFT)->(FT_SERORI+FT_NFORI+cClie+FT_LOJA+FT_ITEMORI+FT_PRODUTO))) .And.;
			SFT->FT_VALPIS > 0 .OR. SFT->FT_VALCOF  > 0		

			IF (cAliasSFT)->FT_BASEPIS > 0 .AND. (cAliasSFT)->FT_BASEPIS <= SFT->FT_BASEPIS
				nPercDevP :=	(cAliasSFT)->FT_BASEPIS / SFT->FT_BASEPIS
			Else
				nPercDevP := (((cAliasSFT)->FT_QUANT * 100) / SFT->FT_QUANT ) / 100
			EndIF			
						
			IF (cAliasSFT)->FT_BASECOF > 0 .AND. (cAliasSFT)->FT_BASECOF <= SFT->FT_BASECOF
				nPercDevC := (cAliasSFT)->FT_BASECOF / SFT->FT_BASECOF
			Else
				nPercDevC := (((cAliasSFT)->FT_QUANT * 100) / SFT->FT_QUANT ) / 100
			EndIF			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Devolucao no proprio periodo³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If DTOS(SFT->FT_ENTRADA) >= DTOS(dDataDe) .And. DTOS(SFT->FT_ENTRADA) <= DTOS(dDataAte)
			
				If (nPos := aScan(aDevol,{|x| x[1]+x[3]+x[4]+x[5]+x[6]==(cAliasSFT)->(FT_NFORI+FT_SERORI+FT_ITEMORI+FT_CLIEFOR_+FT_LOJA)})) == 0
				
					aAdd(aDevol, {})
					nPos	:=	Len (aDevol)
					aAdd (aDevol[nPos], SFT->FT_NFISCAL)					
					aAdd (aDevol[nPos], SFT->FT_EMISSAO)
					aAdd (aDevol[nPos], SFT->FT_SERIE)				
					aAdd (aDevol[nPos], SFT->FT_ITEM)	
					aAdd (aDevol[nPos], SFT->FT_CLIEFOR)			
					aAdd (aDevol[nPos], SFT->FT_LOJA)
					aAdd (aDevol[nPos], Round(SFT->FT_BASEPIS*nPercDevP,2))
					aAdd (aDevol[nPos], Round(SFT->FT_VALPIS*nPercDevP,2))
					aAdd (aDevol[nPos], Round(SFT->FT_BASECOF*nPercDevC,2))
					aAdd (aDevol[nPos], Round(SFT->FT_VALCOF*nPercDevC,2))
					aAdd (aDevol[nPos], (cAliasSFT)->FT_QUANT)
				Else
					If SFT->FT_QUANT == aDevol[nPos][11] + (cAliasSFT)->FT_QUANT
						aDevol[nPos][7]		:=	SFT->FT_BASEPIS
						aDevol[nPos][8]		:=	SFT->FT_VALPIS
						aDevol[nPos][9]		:=	SFT->FT_BASECOF
						aDevol[nPos][10]	:=	SFT->FT_VALCOF
						aDevol[nPos][11]	:=	SFT->FT_QUANT
					Else	 
						aDevol[nPos][7]		+=	Round(SFT->FT_BASEPIS*nPercDevP,2)
						aDevol[nPos][8]		+=	Round(SFT->FT_VALPIS*nPercDevP,2)
						aDevol[nPos][9]		+=	Round(SFT->FT_BASECOF*nPercDevC,2)
						aDevol[nPos][10]	+=	Round(SFT->FT_VALCOF*nPercDevC,2)
						aDevol[nPos][11]	+=	(cAliasSFT)->FT_QUANT	
					Endif
				Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Devolucao em outro periodo  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
			Else
				If cTpMov == "E"
					aAdd (aDevOutPer, {})
					nPos :=	Len (aDevOutPer)
					aAdd (aDevOutPer[nPos], SFT->FT_ENTRADA)					
					aAdd (aDevOutPer[nPos], SFT->FT_VALPIS) 	
					aAdd (aDevOutPer[nPos], SFT->FT_VALCOF) 
					aAdd (aDevOutPer[nPos], SFT->FT_NFISCAL) 
					aAdd (aDevOutPer[nPos], SFT->FT_SERIE) 								
					aAdd (aDevOutPer[nPos], Round(SFT->FT_BASEPIS*nPercDevP,2))
					aAdd (aDevOutPer[nPos], Round(SFT->FT_VALPIS*nPercDevP,2))
					aAdd (aDevOutPer[nPos], Round(SFT->FT_BASECOF*nPercDevC,2))
					aAdd (aDevOutPer[nPos], Round(SFT->FT_VALCOF*nPercDevC,2))
					aAdd (aDevOutPer[nPos], cNotaOri)
					aAdd (aDevOutPer[nPos], cIteOri)
					aAdd (aDevOutPer[nPos], .F. )
					aAdd (aDevOutPer[nPos], .F. )
				Else
					aAdd(aDevOutPer, {})
					nPos	:=	Len (aDevOutPer)
					aAdd (aDevOutPer[nPos], (cAliasSFT)->FT_NFISCAL)					
					aAdd (aDevOutPer[nPos], SFT->FT_ENTRADA)			  
					aAdd (aDevOutPer[nPos], IIf(SFT->FT_QUANT==(cAliasSFT)->FT_QUANT, SFT->FT_VALPIS, (cAliasSFT)->FT_QUANT*SFT->FT_VALPIS/SFT->FT_QUANT))
					aAdd (aDevOutPer[nPos], IIf(SFT->FT_QUANT==(cAliasSFT)->FT_QUANT, SFT->FT_VALCOF, (cAliasSFT)->FT_QUANT*SFT->FT_VALCOF/SFT->FT_QUANT))										
					aAdd (aDevOutPer[nPos], SFT->FT_NFISCAL)
					aAdd (aDevOutPer[nPos], cRegDev)
				Endif
			Endif
		Endif
		RestArea (aAreaSFT)
		(cAliasSFT)->(DbSkip())
	EndDo
Endif

If lAchouSFT
	SPEDFFiltro(2,,cAliasSFT)
Endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³SPEDRegime³ Autor ³Erick Dias             ³ Data ³25.06.2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna qual o regime que foi utilizado na operacao         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Devem ser passados os parametros necessarios para 		  ³±±
±±³          ³identificar a operacao, e a funcao ira retornar qual o      ³±±
±±³          ³regime que foi utilizado  								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³cRetorno -> "C" indica que eh cumulativo, "N" indica nao-   ³±±
±±³          ³			  cumulativo                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cRegime   -> Informa o tipo do Regime                       º±±
±±³			 ³cAliasSF4 -> Alias da tabela SF4   				  		  ³±±
±±³          ³caliasSB1 -> Alias da tabela SB1							  ³±±
±±³          ³cAliasSA1 -> Alias da tabela SA1 					  		  ³±±                      
±±º          ³nMVM996TPR-> Conteudo do Parametro MV_M996TPR               º±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPEDRegime(cRegime,cAliasSF4,caliasSB1,cAliasSA1,nMVM996TPR)
Local lCumulativ	:=	.F.
Local cRetorno		:=	""
Local  lB1TPREG	:= SB1->(FieldPos("B1_TPREG")) > 0
Default nMVM996TPR	:=	GetNewPar("MV_M996TPR",1)

IF nMVM996TPR = 1 //TES
	If (cAliasSF4)->F4_TPREG == "2"	//Cumulativo
		lCumulativ := .T.				
	ElseIF (cAliasSF4)->F4_TPREG == "3"	//Ambos, neste caso irei no produto para definir qual o regime				
		IF lB1TPREG .AND. (caliasSB1)->B1_TPREG == "2" //Cumulativo 
			lCumulativ := .T. 
		EndIF  				                        	
	EndIF
Elseif nMVM996TPR == 2 //PRODUTO
	IF lB1TPREG .AND. (cAliasSB1)->B1_TPREG == "2" //Cumulativo
		lCumulativ := .T.   
	EndIF									
Elseif nMVM996TPR == 3 .And. (cAliasSA1)->(FieldPos("A1_TPREG")) > 0 //CLIENTE
	IF (cAliasSA1)->A1_TPREG == "2" //Cumulativo
		lCumulativ := .T.   
	EndIF								
EndIF 

If lCumulativ
	cRetorno	:="C" //Regime Cumulativo
Else
	cRetorno	:= "N" //Regime Não Cumulativo
EndIF

Return (cRetorno)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Funcoes de tratamento de caracteres especiais copiadas do NFESEFAZ  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Function SPEDConvType(xValor,nTam)

Local cNovo := ""

If nTam==Nil
	xValor := AllTrim(xValor)
EndIf
DEFAULT nTam := 60
cNovo := AllTrim(EnCodeUtf8(NoAcento(SubStr(xValor,1,nTam))))

Return(cNovo)  

FUNCTION SPEDNoAcento(cString)
Local cChar  := ""
Local nX     := 0 
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
Local cTrema := "äëïöü"+"ÄËÏÖÜ"
Local cCrase := "àèìòù"+"ÀÈÌÒÙ" 
Local cTio   := "ãõ"
Local cCecid := "çÇ"

For nX:= 1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
		nY:= At(cChar,cAgudo)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCircu)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTrema)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCrase)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf		
		nY:= At(cChar,cTio)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("ao",nY,1))
		EndIf		
		nY:= At(cChar,cCecid)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("cC",nY,1))
		EndIf
	Endif
Next
For nX:=1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	If Asc(cChar) < 32 .Or. Asc(cChar) > 123 .Or. cChar $ '&'
		cString:=StrTran(cString,cChar,".")
	Endif
Next nX
cString := _NoTags(cString)
Return cString

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SPEDNcmCAgºAutor  ³Erick G. Dias       º Data ³  08/02/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescrição ³ Retornar se o NCM pertence aos NCMS de exportação          º±±    
±±º          ³ Para considerar percentual da base de cálculo do crédito   º±±    
±±º          ³ presumido de PIS e COFINS conforme lei 12.058/2009.        º±±    
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Parametros³ cNcm   -> NCM que consta no produto.                    	  ³±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function SPEDNcmCAg(cNcm)

Local nPos		:= 0
Local aNCM     	:= GetNewPar("MV_NCMCPPC",{})
local lRet		:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta um array com os códigos NCMs que serão considerados como exportação para percentual do cálculo da base de cálculo de crédito Presumido.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aNCM   			:= Iif (Len(aNCM) > 1,&(aNCM),aNCM)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Irá fazer for para verificar todos NCMs³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nPos := 1 to len(aNCM)

	IF aNCM[nPos] $ Alltrim(cNcm)
		lRet := .T.
		exit
	EndIf
Next nPos
Return(lRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³SPDRetCCST| Autor ³Gustavo G. Rueda              ³ Data ³22.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Funcao que retorna o codigo de situacao tributaria dos impostos    ³±±
±±³          ³ ICMS, IPI, PIS e COFINS                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ExpA1 :=SPDRetCCST(cPar1,lPar2,lPar3,lPar4,cPar5,cPar6,cPar7,cPar8)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cPar1 - Alias da tabela SFT em processamento                       ³±±
±±³          ³lPar2 - Booleano de identificacao da existencia do registro na     ³±±
±±³          ³        tabela SF4 correspondente ao item da tabela SFT            ³±±
±±³          ³lPar3 - Booleano de identificacao da existencia do campo de CST    ³±±
±±³          ³        do PIS na tabela SFT                                       ³±±
±±³          ³lPar4 - Booleano de identificacao da existencia do campo de CST    ³±±
±±³          ³        da COFINS na tabela SFT                                    ³±±
±±³          ³cPar5 - Especie do documento fiscal em processamento               ³±±
±±³          ³cPar6 - Alias da tabela SF4, query ou SF4                          ³±±
±±³          ³cPar7 - Alias da tabela SB1, query ou SB1                          ³±±
±±³          ³cPar8 - Estado do cliente/Forncedor do documento fiscal            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³aRet -> Array com os codigos de situacao tributaria                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPDRetCCST(cAliasSFT,lAchouSF4,lCstPis,lCstCof,cEspecie,cAliasSF4,cAliasSB1,cPartEst)
//						Icm Ipi Pis	Cof
Local	aRet		:= {"" ,"", "", ""}
Local   lStfrete    := GetNewPar("MV_STFRETE",.F.) //Cod.Situação Tributaria para notas de conhecimento de frete

DEFAULT cEspecie 	:=	"01"
DEFAULT cAliasSF4	:=	"SF4"
DEFAULT cAliasSB1	:=	"SB1"
DEFAULT cPartEst	:=	SA1->A1_EST

//Situacao Tributaria ICMS
If Empty((cAliasSFT)->FT_CLASFIS) .Or. Len(Alltrim((cAliasSFT)->FT_CLASFIS))<>3

	If Empty((cAliasSB1)->B1_ORIGEM)

		If Empty((cAliasSB1)->B1_IMPORT) .Or. (cAliasSB1)->B1_IMPORT=="N" 
			aRet[1] := "0"
		Else
			If cPartEst=="EX"
				aRet[1] := "1"
			Else
				aRet[1] := "2"
			EndIf
		EndIf
	Else
		aRet[1] := (cAliasSB1)->B1_ORIGEM
	EndIf
	
	If lAchouSF4
		aRet[1]	+=	(cAliasSF4)->F4_SITTRIB
	EndIf
Else
	aRet[1] :=(cAliasSFT)->FT_CLASFIS
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄd¿
//³Tratamento para notas de conhecimento de frete.                                         ³
//³  Em consulta junto nossa consultoria Tributária, foi necessario a criação do parametro ³
//³  MV_STFRETE para definir se o campo (CST)Cod.Situação Tributaria  das notas de         ³
//³ conhecimento de frete será considerado do B1_ORIGEM ou se iniciará em "0"              ³
//³ mesmo sendo uma importação.                                                            ³
//³Solicitação feita na FNC 00000019516/2010-01                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄdÙ
If lStfrete    
	If (cEspecie$"07#08#09#10#11#26#27#57") .Or. ((cAliasSFT)->FT_TIPO$"C")
    	aRet[1] := "0"+ SubStr((cAliasSFT)->FT_CLASFIS,2,3)
  	EndIf
EndIf

//Situacao Tributaria IPI
aRet[2] := (cAliasSFT)->FT_CTIPI

//Situacao Tributaria PIS
If lCstPis .And. !Empty((cAliasSFT)->FT_CSTPIS)
	aRet[3] := (cAliasSFT)->FT_CSTPIS
ElseIf lAchouSF4
	aRet[3] := (cAliasSF4)->F4_CSTPIS
EndIf

//Situacao Tributaria COFINS
If lCstCof .And. !Empty((cAliasSFT)->FT_CSTCOF)
	aRet[4] := (cAliasSFT)->FT_CSTCOF
ElseIf lAchouSF4
	aRet[4] := (cAliasSF4)->F4_CSTCOF
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ponto de Entrada para alterar a classificação fiscal do produto.³        
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("SPDFIS03")
	aRet :=  ExecBlock("SPDFIS03", .F., .F., {(cAliasSFT)->FT_FILIAL,;
						(cAliasSFT)->FT_TIPOMOV,;
						(cAliasSFT)->FT_SERIE,;
						(cAliasSFT)->FT_NFISCAL,;
						(cAliasSFT)->FT_CLIEFOR,;
						(cAliasSFT)->FT_LOJA,;
						(cAliasSFT)->FT_ITEM,;
						(cAliasSFT)->FT_PRODUTO})
EndIf 
Return(aRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |SPDRePorNf³ Autor ³Gustavo G. Rueda       ³ Data ³16.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³   GRAVACAO DE UM REGISTRO RELACIONADO COM SEU SUPERIOR     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Posiciono no registro com a chave passada como parametro e  ³±±
±±³          ³ gero o TXT na funcao SPEDGrvLin                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|nHandle -> Handle do arquivo txt aberto.                    ³±±
±±³          |cAlias -> Alias do TRB criado atraves da funcao principal.  ³±±
±±³          |cTpReg -> Tipo de registro que compoe a chave de pesquisa.  ³±±
±±³          |cRelac -> Relacionamento do registro que compoe a chave de  ³±±
±±³          | pesquisa                                                   ³±±
±±³          |nItem -> Item por relacionamento.                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPDRePorNf(nHandle,cAlias,cTpReg,cRelac,nItem,lExact)
	Local	lRet		:=	.T.
	Local	cChave		:=	cTpReg+cRelac
	Local	aAreaLoc	:=	(cAlias)->(GetArea())
	Local	bWhile		:=	{||!(cAlias)->(Eof ()) .And. cChave==(cAlias)->TRB_TPREG+(cAlias)->TRB_RELAC+Iif (nItem<>Nil .And. nItem>0, StrZero ((cAlias)->TRB_ITEM, 7, 0),"")}

	Default	lExact		:=	.F.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento para considerar o item de quebra ao efetuar o seek³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (nItem<>Nil .And. nItem>0)
		cChave	+=	StrZero (nItem, 7, 0)
	EndIf
	
	If lExact
		bWhile		:=	{|| !(cAlias)->(Eof ()) .And. cChave==Left((cAlias)->TRB_TPREG+(cAlias)->TRB_RELAC+Iif(nItem<>Nil .And. nItem>0,StrZero((cAlias)->TRB_ITEM, 7, 0),""),Len(cChave))}
	EndIf

	If ((cAlias)->(DbSeek (cChave)))
		Do While Eval(bWhile)
			SPEDGrvLin(nHandle, cAlias)

			(cAlias)->(DbSkip ())
		EndDo
	EndIf

	RestArea (aAreaLoc)
Return (lRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³SpdReg9900| Autor ³Gustavo G. Rueda              ³ Data ³03.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³REGISTROS DO ARQUIVO                                               ³±±
±±³          ³                                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Expl1 := SpdReg9900(cAlias,aReg9900)                               ³±±
±±³          ³                                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias   -> Alias do TRB que recebera as informacoes               ³±±
±±³          ³aReg9900 -> Array com informacoes que serao gravadas no TRB        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1 - Sempre .T.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SpdReg9900(cAlias,aReg9900)
	Local	lRet	:=	.T.

	GrvRegTrS (cAlias,,aReg9900,)

Return (lRet)                       

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |SpdReg9999| Autor ³Gustavo G. Rueda              ³ Data ³03.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ENCERRAMENTO DO ARQUIVO DIGITAL                                    ³±±
±±³          ³                                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ExpN1 := SpdReg9999(cAlias)                                        ³±±
±±³          ³                                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias   -> Alias do TRB que recebera as informacoes               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1 - Sempre .T.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SpdReg9999(cAlias)
	Local	lRet	:=	.T.
	Local	nPos	:=	0
	Local	aReg	:= {}

	aAdd(aReg, {})
	nPos	:=	Len (aReg)
	nTotLin := (cAlias)->(RecCount()) + 1
	aAdd (aReg[nPos], "9999")					//01 - REG
	aAdd (aReg[nPos], Alltrim(STR(nTotLin)))	//02 - QTD_LIN
	GrvRegTrS (cAlias,,aReg,)
	//
Return (lRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |SPDGerTrb | Autor ³Gustavo G. Rueda              ³ Data ³03.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ GERACAO DA ESTRUTURA DO TRB                                       ³±±
±±³          ³                                                                   ³±±
±±³          ³Geracao da estrutura do TRB utilizado em todo o processamento      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ExpL1 := GeraTrb (nTipo, aArq, cAlias)                             ³±±
±±³          ³                                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|nTipo -> 1=Gerar o TRB, 2=Fechar o TRB                             ³±±
±±³          ³cArq -> Nome fisico do TRB criado                                  ³±±
±±³          ³cAlias -> Alias do TRB criado                                      ³±±
±±³          ³lExtTaf -> Indica se a chamada da Funcao eh o Extrator TAF         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1 - Sempre .T.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPDGerTrb(nTipo,aArq,cAlias,lExtTaf)
Local	lRet  		:=	.T.
Local	aCmp  		:=	{}
Local	cArq  		:=	""
Local	nI	  		:=	0
Local	nTamTRBIt	:=	50	//Tamanho do campo relac no TRB - Tem que ser numero exato, pois faco divisao por dois nos calculos.
Local   lInscPar := GetNewPar("MV_INSCPAR",.F.) 

Default lExtTaf := .F.

//
If (nTipo==1)                

	//ÚÄÄÄÄÄÄÄÄÄ¿
	//³TRB Geral³
	//ÀÄÄÄÄÄÄÄÄÄÙ
	cAlias	:=	"TRB"
	aAdd (aCmp, {"TRB_TPREG",	"C", 	004,	   			0})
	aAdd (aCmp, {"TRB_RELAC",	"C", 	nTamTRBIt*2,		0})
	aAdd (aCmp, {"TRB_FLAG",	"C", 	001,				0})
	aAdd (aCmp, {"TRB_CONT",	"C", 	999,				0})
	aAdd (aCmp, {"TRB_ITEM",	"N", 	007,				0})
	cArq	:=	CriaTrab (aCmp)
	DbUseArea (.T., __LocalDriver, cArq, cAlias)
	IndRegua (cAlias, cArq, "TRB_TPREG+TRB_RELAC+StrZero (TRB_ITEM, 7, 0)")
 	aAdd (aArq, {cAlias, cArq})
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³TRB IVT = Bloco H - Inventario              		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCmp	:=	{}
	cAlias	:=	"IVT"
	aAdd (aCmp, {"IVT_REG",			"C", 	04,					0})
	aAdd (aCmp, {"IVT_INDP",		"C", 	01,					0})
	nTam	:=	3+FWGETTAMFILIAL+TamSx3("A1_COD")[1]+TamSx3("A1_LOJA")[1]
	IIF(lInscPar,nTam+=TamSx3("A1_INSCR")[1],.T.)
	aAdd (aCmp, {"IVT_CODPAR",		"C", 	nTam,				0})
	aAdd (aCmp, {"IVT_CTA",			"C", 	70,					0})
	nTam	:=	TamSx3("B1_COD")[1]+FWGETTAMFILIAL
	aAdd (aCmp, {"IVT_CODITE",		"C", 	nTam,				0})
	aAdd (aCmp, {"IVT_VLUNIT",		"N", 	16,					3})
	aAdd (aCmp, {"IVT_QTD",			"N", 	16,					3})
	nTam	:=	TamSx3("B1_UM")[1]
	aAdd (aCmp, {"IVT_UM",			"C", 	nTam,				0})
	aAdd (aCmp, {"IVT_VLITEM",		"N", 	16,					3})
	aAdd (aCmp, {"IVT_OBS",			"C", 	20,					0})
	aAdd (aCmp, {"IVT_SITU",    	"C",    01,                	0})
	aAdd (aCmp, {"IVT_ALIQ",		"N",	05,					2})
	aAdd (aCmp, {"IVT_CLAFIS",		"C",	03,					0})
	    
    If lExtTaf
    	aAdd (aCmp, {"IVT_ORIPRD",		"C",	01,					0})
    EndIf
    
	cArq	:=	CriaTrab (aCmp)
	DbUseArea (.T., __LocalDriver, cArq, cAlias)
	IndRegua (cAlias, cArq, "IVT_INDP+IVT_CODPAR+IVT_CODITE+IVT_SITU")
	aAdd (aArq, {cAlias, cArq})   
	
Else
	For nI := 1 To Len (aArq)
		DbSelectArea (aArq[nI][1])
		(aArq[nI][1])->(DbCloseArea ())
		//Ferase (aArq[nI][2]+GetDBExtension ())
		//Ferase (aArq[nI][2]+OrdBagExt ())	
	Next nI
EndIf

cAlias	:=	"TRB"	//Devo sempre retornar para os casos que nao tiverem TRB proprio.
Return (lRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SPDGet4DecºAutor  ³Demetrio De Los Riosº Data ³  05/25/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se o campo em questao deve gerar 4 casas decimais º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±  
±±ºParametros³ clReg = Registro a ser procurado no array alRegs           º±±
±±º          ³ nlNum = Numero do campo                                    º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±  
±±º Retorno  ³  llREt = Boolean (se deve exustir 4 casas decimais         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SPED PIS COFINS                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPDGet4Dec(clReg , nlNum)
      
Local llRet 	:= .F.
Local nlPos		:= 0             
Local alRegs	:= {	"C170",;		// 01 
						"C181",;		// 02  
						"C185",;		// 03  
						"C191",;		// 04  
						"C195",;		// 05  
						"C381",;   		// 06  
						"C385",;		// 07  
						"C396",;  		// 08  
						"C481",;		// 09  
						"C485",;  		// 10  
						"C491",; 		// 11  
						"C495",;		// 12  
						"C501",;		// 13  
						"C505",;		// 14  
						"C601",;		// 15  
						"C605",;		// 16  
						"D101",;		// 17 
						"D105",;		// 18  
						"D201",;		// 19  
						"D205",;		// 20       
						"D300",;		// 21  
						"D350",;		// 22  
						"D501",;		// 23 
						"D505",;		// 24  
						"D601",;		// 25  
						"D605",;		// 26     
						"F100",;		// 27  
						"F120",;		// 28 
						"F130",;		// 29  
						"F150",;		// 30 
						"F200",;		// 31  
						"F205",;		// 32 
						"F210",;		// 33  
						"F600",;		// 34 
						"M100",;		// 35  
						"M210",;		// 36 
						"M500",;		// 37  
						"M610",;		// 38  
						"1101",;		// 39  
						"1210",;		// 40  
						"1501",;		// 41 
						"1610",;		// 42 
						"F510",;		// 43 
						"F500",;		// 44 
						"F550",;		// 45 						
						"F560"}			// 46 
						
Local alPosi	:= {	{27,29,33,35} 	,; 	// POSICAO CAMPOS C170 - POSICAO [01] 
					  	{07,09}			,;	// POSICAO CAMPOS C181 - POSICAO [02] 
					  	{07,09}			,;	// POSICAO CAMPOS C185 - POSICAO [03] 
					  	{08,10} 		,;	// POSICAO CAMPOS C191 - POSICAO [04] 
					  	{08,10} 		,;	// POSICAO CAMPOS C195 - POSICAO [05] 
					  	{06,08} 		,;	// POSICAO CAMPOS C381 - POSICAO [06] 
					  	{06,08} 		,;	// POSICAO CAMPOS C385 - POSICAO [07] 
					  	{08,12} 		,;	// POSICAO CAMPOS C396 - POSICAO [08] 
					  	{05,07} 		,;	// POSICAO CAMPOS C481 - POSICAO [09] 
					  	{05,07} 		,;	// POSICAO CAMPOS C485 - POSICAO [10] 
					  	{07,09}			,;	// POSICAO CAMPOS C491 - POSICAO [11] 
					  	{07,09}			,;	// POSICAO CAMPOS C495 - POSICAO [12] 
					  	{06}			,;	// POSICAO CAMPOS C501 - POSICAO [13] 
					  	{06} 			,;	// POSICAO CAMPOS C505 - POSICAO [14] 
					  	{05} 			,;	// POSICAO CAMPOS C601 - POSICAO [15] 
					  	{05} 			,;	// POSICAO CAMPOS C605 - POSICAO [16] 
					  	{07} 			,;	// POSICAO CAMPOS D101 - POSICAO [17] 
					  	{07} 			,;	// POSICAO CAMPOS D105 - POSICAO [18] 
					  	{05} 			,;	// POSICAO CAMPOS D201 - POSICAO [19] 
					  	{05} 			,;	// POSICAO CAMPOS D205 - POSICAO [20] 
					  	{13,17} 		,;	// POSICAO CAMPOS D300 - POSICAO [21] 
					  	{13,15,19,21} 	,;	// POSICAO CAMPOS D350 - POSICAO [22] 
					  	{06}			,;	// POSICAO CAMPOS D501 - POSICAO [23] 
					  	{06}			,;	// POSICAO CAMPOS D505 - POSICAO [24] 
					  	{07} 			,;	// POSICAO CAMPOS D601 - POSICAO [25] 
					  	{07} 			,;	// POSICAO CAMPOS D605 - POSICAO [26] 
					  	{09,13}			,;	// POSICAO CAMPOS F100 - POSICAO [27]      
					  	{10,14} 		,;	// POSICAO CAMPOS F120 - POSICAO [28] 
					  	{13,17} 		,;	// POSICAO CAMPOS F130 - POSICAO [29] 
					  	{08,11} 		,;	// POSICAO CAMPOS F150 - POSICAO [30] 
					  	{14,18} 		,;	// POSICAO CAMPOS F200 - POSICAO [31] 
					  	{08,14} 		,;	// POSICAO CAMPOS F205 - POSICAO [32] 
					  	{07,10} 		,;	// POSICAO CAMPOS F210 - POSICAO [33] 
					  	{04} 			,;	// POSICAO CAMPOS F600 - POSICAO [34] 					  	
					  	{05,07} 		,;	// POSICAO CAMPOS M100 - POSICAO [35] 
					  	{05,07} 		,;	// POSICAO CAMPOS M210 - POSICAO [36] 
					  	{05,07} 		,;	// POSICAO CAMPOS M500 - POSICAO [37] 
					  	{05,07} 		,;	// POSICAO CAMPOS M610 - POSICAO [38] 
					  	{16}			,;	// POSICAO CAMPOS 1101 - POSICAO [39]  
					  	{08} 			,;	// POSICAO CAMPOS 1210 - POSICAO [40] 
					  	{16} 			,;	// POSICAO CAMPOS 1501 - POSICAO [41] 
					  	{08} 			,;	// POSICAO CAMPOS 1610 - POSICAO [42] 
					  	{06,11}			,;	// POSICAO CAMPOS F510 - POSICAO [43] 
					  	{06,11}			,;	// POSICAO CAMPOS F500 - POSICAO [44] 
					  	{06,11}			,;	// POSICAO CAMPOS F550 - POSICAO [45] 					  	
					  	{06,11}			}	// POSICAO CAMPOS F560 - POSICAO [46] 
						  
     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VERIFICA SE O REGISTRO TEM CAMPOS COM 4 CASAS DECIMAIS  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
If  (nlPos := aScan(alRegs, {|x| x$AllTrim(clReg)}))>0       
	If  (aScan( alPosi[nlPos],{|z| (z==nlNum) } ))>0
		llRet := !llRet 
	EndIf 
EndIf 
      
Return llRet    


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SPDGet3DecºAutor  ³Fabio Vessoni Santanaº Data ³  17/06/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se o campo em questao deve gerar 4 casas decimais  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±  
±±ºParametros³ clReg = Registro a ser procurado no array alRegs            º±±
±±º          ³ nlNum = Numero do campo                                     º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±  
±±º Retorno  ³  llREt = Boolean (se deve exustir 3 casas decimais          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SPED PIS COFINS                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPDGet3Dec(clReg , nlNum)
      
Local llRet 	:= .F.
Local nlPos		:= 0             
Local alRegs	:= {"C170",; //01
					"C181",; //02
					"C185",; //03
					"C191",; //04
					"C195",; //05
					"C381",; //06
					"C385",; //07
					"C481",; //08
					"C485",; //09
					"C491",; //10
					"C495",; //11
					"C820",; //12
					"C880",; //13
					"D350",; //14
					"F510",; //15
					"F560",; //16
					"M100",; //17
					"M105",; //18
					"M210",; //19
					"M500",; //20
					"M505",; //21
					"M610"}  //22
						
Local alPosi	:= {{28,34}		,;
				  	{08}		,;	
				  	{08} 		,;	
				  	{09} 		,;	
				  	{09} 		,;	
				  	{07} 		,;	
				  	{07} 		,;	
				  	{06} 		,;	
				  	{06} 		,;	
				  	{08}		,;	
				  	{08}		,;	
				  	{06,10}		,;	
				  	{06,10} 	,;	
				  	{14,20} 	,;	
				  	{05,10} 	,;	
				  	{05,10} 	,;	
				  	{06} 		,;	
				  	{08,09} 	,;	
				  	{06}		,;	
				  	{06} 		,;	
				  	{08,09} 	,;	
				  	{06}		}						  
     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VERIFICA SE O REGISTRO TEM CAMPOS COM 3 CASAS DECIMAIS  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
If  (nlPos := aScan(alRegs, {|x| x$AllTrim(clReg)}))>0       
	If  (aScan( alPosi[nlPos],{|z| (z==nlNum) } ))>0
		llRet := !llRet 
	EndIf 
EndIf 
      
Return llRet 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SPDGERNF  ºAutor  ³ Vitor Felipe       º Data ³  19/09/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de Geracao do SPED PIS e COFINS buscando informacoes º±±
±±º			 ³da Nota Fiscal da Saida, que nao foi gerado Livros 		  º±±
±±º		     ³Fiscais.                                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function SPDGERNF(lEnerEle,lGravaC100,nRelacDoc,cEntSai,nApurIpi,cSituaDoc,dDataDe,dDataAte,lConsolid,cAlias,lcumulativ,nRelacFil,aProd,cRegime,;
				aReg0150,aReg0200,aReg0205,aReg0190,aReg0500,aReg0600,nPaiC,nItemC170,nPosC180,aRegC170,aRegC180,aRegC181,;
				aRegC185,aRegM210,aRegM610,aRegM400,aRegM410,aRegM800,aRegM810,aRegC100,aReg0400,aReg0111)
	
Local lTop		:= .F.
Local cAliasSD2	:= "SD2"
Local cAliasSF4	:= "SF4"
Local cAliasSB1	:= "SB1"
Local cAliasSF2	:= "SF2"
Local cSlct,cSlctSF2,cSlctSD2,cSlctSf4 := ""
Local cJoin,cJoinSD2,cJoinSF4 := ""
Local cFiltro	:= ""
Local aFieldDt	:= {}
Local cIndex	:= ""
Local nIndex	:= 0
Local nValST	:= 0
Local cConta	:= ""
Local cCondCont	:= ""
Local nTotalRec	:= 0
Local nBcPis	:= 0
Local nAliqPis	:= 0
Local nCApurPIS := 0
Local nBcCOF	:= 0
Local nAliqCOF	:= 0
Local nCApurCOF := 0
Local lAchouCCZ	:= .F.
Local cProd		:= ""
Local cEspecie	:= ""
Local cChave	:= ""
Local aPartDoc	:= {}
Local cSitFrt	:= ""
Local cDtEmi	:= ""
Local nPos0400	:= 0
Local nPos210	:= 0
Local nPos610	:= 0
Local nPosM400	:= 0
Local nPosM410	:= 0
Local nPosM800	:= 0
Local nPosM810	:= 0
Local nPos180	:= 0
Local nPosC181	:= 0
Local nPosC185	:= 0
Local lGrava	:= .F.
Local lB1TPREG	:= SB1->(FieldPos("B1_TPREG")) > 0
Local nTotalNT	:= 0

#IFDEF TOP	
	If TcSrvType() <> "AS/400"
		lTop 	:= .T.		
	Endif
#ENDIF

DbSelectArea (cAliasSD2)
(cAliasSD2)->(DbSetOrder (3))

#IFDEF TOP
    If (TcSrvType ()<>"AS/400")
		//Campos da tabela SF2
		cSlctSF2 := "SF2.F2_FILIAL,SF2.F2_ESPECIE,SF2.F2_SERIE,SF2.F2_TIPO,SF2.F2_CLIENTE,SF2.F2_LOJA,SF2.F2_DOC,SF2.F2_CHVNFE,SF2.F2_EMISSAO,"
		cSlctSF2 += "SF2.F2_VALBRUT,SF2.F2_DESCONT,SF2.F2_FRETE,SF2.F2_SEGURO,SF2.F2_DESPESA,SF2.F2_BASEICM,"
		cSlctSF2 += "SF2.F2_VALICM,SF2.F2_BRICMS,SF2.F2_ICMSRET,SF2.F2_VALIPI,SF2.F2_VALIMP6,SF2.F2_VALIMP5,"
		cSlctSF2 += "SB1.B1_COD,SB1.B1_DESC,SB1.B1_POSIPI,SB1.B1_EX_NCM,SB1.B1_TNATREC,SB1.B1_CNATREC,"    	
		cSlctSF2 += "SB1.B1_TIPO,SB1.B1_CODISS,SB1.B1_CODBAR,SB1.B1_CODANT,SB1.B1_UM,SB1.B1_PICM,SB1.B1_FECP,SB1.B1_DATREF,"
		cSlctSF2 += "SB1.B1_TNATREC,SB1.B1_CNATREC,SB1.B1_GRPNATR,SB1.B1_DTFIMNT"
		
		
		IF lB1TPREG
			cSlctSF2 += ",SB1.B1_TPREG"
		EndIF

		//Campos da tabela SD2
		cSlctSD2 := ",SD2.D2_CONTA,SD2.D2_SERIE,SD2.D2_VALIMP5,SD2.D2_BASIMP5,SD2.D2_ALQIMP5,SD2.D2_VALIMP6,SD2.D2_BASIMP6,SD2.D2_ALQIMP6,"
		cSlctSD2 +=	"SD2.D2_DTFIMNT,SD2.D2_DESC,SD2.D2_TNATREC,SD2.D2_CNATREC,SD2.D2_GRUPONC,SD2.D2_TOTAL,SD2.D2_DESPESA,SD2.D2_SEGURO,"
		cSlctSD2 += "SD2.D2_BASEICM,SD2.D2_VALICM,SD2.D2_CLIENTE,SD2.D2_LOJA,SD2.D2_CF,SD2.D2_QUANT,SD2.D2_UM,SD2.D2_CLASFIS,SD2.D2_DESCON,
		cSlctSD2 +=	"SD2.D2_PICM,SD2.D2_BRICMS,SD2.D2_BASEIPI,SD2.D2_IPI,SD2.D2_VALIPI,SD2.D2_ICMSRET,SD2.D2_COD,SD2.D2_PEDIDO"
    	
    	//Campos da TES
    	cSlctSF4 := ",SF4.F4_CSTPIS,SF4.F4_CSTCOF,SF4.F4_TPREG,SF4.F4_PISCOF,SF4.F4_ESTOQUE,SF4.F4_CTIPI,SF4.F4_TEXTO,"
    	cSlctSF4 += "SF4.F4_TNATREC,SF4.F4_CNATREC,SF4.F4_GRPNATR,SF4.F4_DTFIMNT"
		//Join com SD2, SF4
		cJoinSD2	:=	"LEFT JOIN "+RetSqlName("SD2")+" SD2 ON(SD2.D2_FILIAL='"+xFilial("SD2")+"' AND SD2.D2_DOC=SF2.F2_DOC AND SD2.D2_SERIE=SF2.F2_SERIE AND SD2.D2_CLIENTE=SF2.F2_CLIENTE AND SD2.D2_LOJA=SF2.F2_LOJA AND  SD2.D_E_L_E_T_=' ') "		
		cJoinSF4	:=	"LEFT JOIN "+RetSqlName("SF4")+" SF4 ON(SF4.F4_FILIAL='"+xFilial("SF4")+"' AND SF4.F4_CODIGO=SD2.D2_TES AND SF4.D_E_L_E_T_=' ') "				
	
		cJoin	:=  cJoinSD2 + cJoinSF4
		cJoin := "%" + cJoin + "%"
		
		cSlct := cSlctSF2+cSlctSD2+cSlctSf4

		cSlct := "%" + cSlct + "%"											

		cFiltro 	:= "%"		
		cFiltro		+= "SD2.D2_CF IN ('5103','5104','6103','6104') AND SF4.F4_LFICM = 'N' AND  SF4.F4_LFIPI = 'N' AND SF4.F4_ISS = 'N' AND "
		cFiltro		+= "SF4.F4_CSTPIS <> ' ' AND SF4.F4_CSTCOF <> ' ' AND SF4.F4_PISCOF <> '4'"
		cFiltro 	+= "%"
		    	    	
    	aAdd(aFieldDt,"D2_DTFIMNT")
    	aAdd(aFieldDt,"D2_ENTRADA")
    	
    	cAliasSF2	:=	GetNextAlias()    	 			
    	
    	BeginSql Alias cAliasSF2
			
			SELECT			    
				%Exp:cSlct%
			FROM 
				%Table:SF2% SF2
				%Exp:cJoin%
				LEFT JOIN %Table:SB1% SB1 ON(SB1.B1_FILIAL=%xFilial:SB1%  AND SB1.B1_COD=SD2.D2_COD AND SB1.%NotDel%)						
			WHERE
				SF2.F2_FILIAL=%xFilial:SF2% AND 
				SF2.F2_EMISSAO>=%Exp:DToS (dDataDe)% AND 
				SF2.F2_EMISSAO<=%Exp:DToS (dDataAte)% AND
				%Exp:cFiltro% AND
				SF2.%NotDel%
			ORDER BY SF2.F2_SERIE, SF2.F2_DOC, SF2.F2_CLIENTE, SF2.F2_LOJA				
		EndSql
	Else
#ENDIF
   	    cIndex	:= CriaTrab(NIL,.F.)
	    cFiltro	:= 'F2_FILIAL=="'+xFilial ("SF2")+'".And.'
	    cFiltro += 'DToS (F2_EMISSAO)>="'+DToS (dDataDe)+'".And.DToS (F2_EMISSAO)<="'+DToS (dDataAte)+'" '
	    IndRegua (cAliasSF2, cIndex, SF2->(IndexKey ()),, cFiltro)
	    nIndex := RetIndex(cAliasSF2)
      
		#IFNDEF TOP
			DbSetIndex (cIndex+OrdBagExt ())
		#ENDIF

		DbSelectArea (cAliasSF2)
	    DbSetOrder (nIndex+1)
#IFDEF TOP
	Endif
#ENDIF
   	   
IF lTop 
	cAliasSD2	:= cAliasSF2
	cAliasSF4	:= cAliasSF2
	cAliasSB1	:= cAliasSF2
EndIF

DbSelectArea (cAliasSF2)
(cAliasSF2)->(DbGoTop ())

Do While !(cAliasSF2)->(Eof ())
	IncProc("Nota : " + (cAliasSF2)->F2_DOC + " do bloco C da Filial "+AllTrim(SM0->M0_FILIAL))
	cConta	:= Reg0500(@aReg0500,(cAliasSD2)->D2_CONTA,,"")	
	nValST	:= (cAliasSD2)->D2_ICMSRET
	cEspecie:=	AModNot ((cAliasSF2)->F2_ESPECIE)
	lGrava	:= .F.
	cProd := Alltrim((cAliasSB1)->B1_COD+xFilial("SB1"))
	If cEspecie $ "01/04/1B" .OR. (cEspecie == "55" .AND. !lConsolid)
		//C170
		aRegC170 := {}
		aAdd(aRegC170, Array(37))
		nPos := 	Len (aRegC170)     
		If cChave <> (cAliasSF2)->F2_FILIAL+(cAliasSF2)->F2_SERIE+(cAliasSF2)->F2_DOC+(cAliasSF2)->F2_CLIENTE+(cAliasSF2)->F2_LOJA
			nItemC170 := 1
			aRegC100 := {}
			nRelacDoc++
		Else
			nItemC170++
		EndIf
		aRegC170[nPos][1]	:= "C170"		   					  			  			//01 - REG
		aRegC170[nPos][2]	:= AllTrim (STR(nItemC170))			  						//02 - NUM_ITEM
		aRegC170[nPos][3]	:= cProd													//03 - COD_ITEM
  		aRegC170[nPos][4]	:= (cAliasSB1)->B1_DESC					  					//04 - DESCR_COMPL
		aRegC170[nPos][5]	:= Iif((cAliasSD2)->D2_QUANT==0,"",(cAliasSD2)->D2_QUANT)	//05 - QTD
		aRegC170[nPos][6]	:= (cAliasSD2)->D2_UM	 									//06 - UNID
		aRegC170[nPos][7]	:= (cAliasSD2)->D2_TOTAL		   				 			//07 - VL_ITEM
		aRegC170[nPos][8]	:= (cAliasSD2)->D2_DESCON		 							//08 - VL_DESC_I      
		aRegC170[nPos][9]	:= Iif((cAliasSF4)->F4_ESTOQUE=="N","1","0")				//09 - IND_MOV
		aRegC170[nPos][10]	:= (cAliasSD2)->D2_CLASFIS				   					//10 - CST ICMS
		aRegC170[nPos][11]	:= (cAliasSD2)->D2_CF	  			   						//11 - CFOP
		aRegC170[nPos][12]	:= (cAliasSD2)->D2_CF						 				//12 - COD_NAT
		aRegC170[nPos][13]	:= (cAliasSD2)->D2_BASEICM									//13 - VL_BC_ICMS_I
		aRegC170[nPos][14]	:= (cAliasSD2)->D2_PICM                            			//14 - ALIQUOTA DO ICMS
		aRegC170[nPos][15]	:= (cAliasSD2)->D2_VALICM									//15 - VL_ICMS_I
		aRegC170[nPos][16]	:= IIf(nValST==0,0,(cAliasSD2)->D2_BRICMS)					//16 - VL_BC_ST_I
		aRegC170[nPos][17]	:= IIf(nValST==0,0,(cAliasSD2)->D2_ALIQSOL)				//17 - ALIQ_ST
		aRegC170[nPos][18]	:= nValST										   			//18 - VL_ST_I
		aRegC170[nPos][19]	:= STR(nApurIpi,1)									 		//19 - IND_APUR
		aRegC170[nPos][20]	:= (cAliasSF4)->F4_CTIPI	 					  		   	//20 - CST_IPI
		aRegC170[nPos][21]	:= "" 														//21 - COD_ENQ
		aRegC170[nPos][22]	:= (cAliasSD2)->D2_BASEIPI	 								//22 - VL_BC_IPI
		aRegC170[nPos][23]	:= (cAliasSD2)->D2_IPI										//23 - ALIQ_IPI
		aRegC170[nPos][24]	:= (cAliasSD2)->D2_VALIPI									//24 - VL_IPI
		aRegC170[nPos][25]	:= (cAliasSF4)->F4_CSTPIS		 					  		//25 - CST_PIS
		aRegC170[nPos][26]	:= (cAliasSD2)->D2_BASIMP6									//26 - VL_BC_PIS
		aRegC170[nPos][27]	:= (cAliasSD2)->D2_ALQIMP6									//27 - ALIQ_PIS
		aRegC170[nPos][28]	:= ""									 			   		//28 - QUANT_BC_PIS
		aRegC170[nPos][29]	:= ""									 					//29 - ALIQ_PIS - Reais
		aRegC170[nPos][30]	:= (cAliasSD2)->D2_VALIMP6									//30 - VL_PIS
	   	aRegC170[nPos][31]	:= (cAliasSF4)->F4_CSTCOF		 					  		//31 - CST_COFINS
		aRegC170[nPos][32]	:= (cAliasSD2)->D2_BASIMP5		 							//32 - VL_BC_COFINS
		aRegC170[nPos][33]	:= (cAliasSD2)->D2_ALQIMP5 									//33 - ALIQ_COFIN
		aRegC170[nPos][34]	:= "" 					 			   						//34 - QUANT_BC_COFINS
    	aRegC170[nPos][35]	:= "" 														//35 - ALIQ_COFINS - Reais
		aRegC170[nPos][36]	:= (cAliasSD2)->D2_VALIMP5									//36 - VL_COFINS
		aRegC170[nPos][37]	:= cConta													//37 - COD_CTA
		GrvNFTrS(cAlias, nRelacDoc, aRegC170, nItemC170)
		
		cCondCont := PCCodCon("PIS",(cAliasSF4)->F4_CSTPIS,(cAliasSD2)->D2_ALQIMP6,,,(cAliasSD2)->D2_CLASFIS,lcumulativ) 
		If !Empty(cCondCont)
			//VALOR DO PIS
			nBcPis		+= (cAliasSD2)->D2_BASIMP6
			nAliqPis	:= (cAliasSD2)->D2_ALQIMP6
			nCApurPIS 	+= (cAliasSD2)->D2_VALIMP6
			
		EndIf
		
		cCondCont := PCCodCon("COF",,,(cAliasSF4)->F4_CSTCOF,(cAliasSD2)->D2_ALQIMP5,(cAliasSD2)->D2_CLASFIS,lcumulativ)
		If !Empty(cCondCont)
			//VALOR DO COFINS
			nBcCOF		+= (cAliasSD2)->D2_BASIMP5
			nAliqCOF	:= (cAliasSD2)->D2_ALQIMP5
			nCApurCOF 	+= (cAliasSD2)->D2_VALIMP5	
		EndIf
	
		If !(cAliasSF4)->F4_CSTPIS $ "04/05/06/07/08/09" .Or. !(cAliasSF4)->F4_CSTCOF $ "04/05/06/07/08/09"
			//VALOR TOTAL
			nTotalRec	+= (cAliasSD2)->D2_TOTAL        
        EndIf
        lGrava := .T.
	ElseIf	lConsolid .And. cEspecie == "55"
		//C180
		nPos180 := aScan(aRegC180, {|aX| aX[5]==cProd})
		If nPos180 == 0
			aAdd(aRegC180, {})
			nPos := Len(aRegC180)
			aAdd (aRegC180[nPos], "C180")						  			//01 - REG		
			aAdd (aRegC180[nPos], "55")				   						//02 - COD_MOD		
			aAdd (aRegC180[nPos], dDataDe)				   					//03 - DT_DOC_INI		
			aAdd (aRegC180[nPos], dDataAte)				   					//04 - DT_DOC_FIN		
			aAdd (aRegC180[nPos], cProd)							//05 - COD_ITEM   		
			aAdd (aRegC180[nPos], Iif(Alltrim((cAliasSB1)->B1_POSIPI)=="99",Replicate("9",8),(cAliasSB1)->B1_POSIPI)) 	//06 - COD_NCM   
			aAdd (aRegC180[nPos], (cAliasSB1)->B1_EX_NCM)				   	//07 - EX_IPI	
			aAdd (aRegC180[nPos], (cAliasSD2)->D2_TOTAL)					//08 - VL_TOT_ITEM 
		Else
			aRegC180[nPos180][8] += (cAliasSD2)->D2_TOTAL
		EndIf 
        
		nPosC181 := aScan (aRegC181, {|aX| aX[1]==nPos180 .AND. aX[3]==(cAliasSF4)->F4_CSTPIS .AND. aX[4]==(cAliasSD2)->D2_CF .AND. cvaltochar(aX[8])==cvaltochar((cAliasSD2)->D2_ALQIMP6) .AND. aX[12]==cConta})
		If nPosC181 == 0 
			//C181
			aAdd(aRegC181, {})
			nPos := Len(aRegC181)
			aAdd (aRegC181[nPos], Len(aRegC180))                        	//-Relacao com C180
			aAdd (aRegC181[nPos], "C181")						  			//01 - REG
			aAdd (aRegC181[nPos], (cAliasSF4)->F4_CSTPIS)					//02 - CST_PIS
			aAdd (aRegC181[nPos], (cAliasSD2)->D2_CF)					   	//03 - CFOP
			aAdd (aRegC181[nPos], (cAliasSD2)->D2_TOTAL)					//04 - VL_ITEM
			aAdd (aRegC181[nPos], (cAliasSD2)->D2_DESCON)					//05 - VL_DESC
			aAdd (aRegC181[nPos], (cAliasSD2)->D2_BASIMP6)					//06 - VL_BC_PIS
			aAdd (aRegC181[nPos], (cAliasSD2)->D2_ALQIMP6)					//07 - ALIQ_PIS	
			aAdd (aRegC181[nPos], "")										//08 - QUANT_BC_PIS
			aAdd (aRegC181[nPos], "")										//09 - ALIQ_PIS_QUANT
			aAdd (aRegC181[nPos], (cAliasSD2)->D2_VALIMP6)					//10 - VL_PIS
			aAdd (aRegC181[nPos], cConta)									//11 - COD_CTA
		Else
			aRegC181[nPosC181][5]	+= (cAliasSD2)->D2_TOTAL				//04 - VL_ITEM
			aRegC181[nPosC181][6]	+= (cAliasSD2)->D2_DESCON				//05 - VL_DESC
			aRegC181[nPosC181][7]	+= (cAliasSD2)->D2_BASIMP6				//06 - VL_BC_PIS
			aRegC181[nPosC181][11]	+=	(cAliasSD2)->D2_VALIMP6				//10 - VL_PIS
		EndIf
		
		nPosC185 := aScan (aRegC185, {|aX| aX[1]==nPos180 .AND.  aX[3]==(cAliasSF4)->F4_CSTCOF .AND. aX[4]==(cAliasSD2)->D2_CF .AND. cVAlToChar(aX[8])==cVAlToChar((cAliasSD2)->D2_ALQIMP5) .AND. aX[12]==cConta})	
		If nPosC185 == 0 
			//C185
			aAdd(aRegC185, {})
			nPos := Len(aRegC185)
			aAdd (aRegC185[nPos], Len(aRegC180))                   		     //-Relacao com C180
			aAdd (aRegC185[nPos], "C185")						  			//01 - REG		
			aAdd (aRegC185[nPos], (cAliasSF4)->F4_CSTCOF)					//02 - CST_PIS
			aAdd (aRegC185[nPos], (cAliasSD2)->D2_CF)					   	//03 - CFOP
			aAdd (aRegC185[nPos], (cAliasSD2)->D2_TOTAL)					//04 - VL_ITEM
			aAdd (aRegC185[nPos], (cAliasSD2)->D2_DESCON)					//05 - VL_DESC
			aAdd (aRegC185[nPos], (cAliasSD2)->D2_BASIMP5)					//06 - VL_BC_PIS
			aAdd (aRegC185[nPos], (cAliasSD2)->D2_ALQIMP5)					//07 - ALIQ_PIS
			aAdd (aRegC185[nPos], "")										//08 - QUANT_BC_PIS
			aAdd (aRegC185[nPos], "")										//09 - ALIQ_PIS_QUANT
			aAdd (aRegC185[nPos], (cAliasSD2)->D2_VALIMP5)					//10 - VL_PIS
			aAdd (aRegC185[nPos], cConta)									//11 - COD_CTA
 		Else
 			aRegC185[nPosC185][5]	+= (cAliasSD2)->D2_TOTAL				//04 - VL_ITEM
			aRegC185[nPosC185][6]	+= (cAliasSD2)->D2_DESCON				//05 - VL_DESC
			aRegC185[nPosC185][7]	+= (cAliasSD2)->D2_BASIMP5				//06 - VL_BC_PIS
			aRegC185[nPosC185][11]	+= (cAliasSD2)->D2_VALIMP5				//10 - VL_PIS	
 		EndIf
 		
		cCondCont := PCCodCon("PIS",(cAliasSF4)->F4_CSTPIS,(cAliasSD2)->D2_ALQIMP6,,,(cAliasSD2)->D2_CLASFIS,lcumulativ) 
		If !Empty(cCondCont)
			//VALOR DO PIS
			nBcPis		+= (cAliasSD2)->D2_BASIMP6
			nAliqPis	:= (cAliasSD2)->D2_ALQIMP6
			nCApurPIS 	+= (cAliasSD2)->D2_VALIMP6
			
		EndIf
		
		cCondCont := PCCodCon("COF",,,(cAliasSF4)->F4_CSTCOF,(cAliasSD2)->D2_ALQIMP5,(cAliasSD2)->D2_CLASFIS,lcumulativ)
		If !Empty(cCondCont)
			//VALOR DO COFINS
			nBcCOF		+= (cAliasSD2)->D2_BASIMP5
			nAliqCOF	:= (cAliasSD2)->D2_ALQIMP5
			nCApurCOF 	+= (cAliasSD2)->D2_VALIMP5	
		EndIf
		If !(cAliasSF4)->F4_CSTPIS $ "04/05/06/07/08/09" .Or. !(cAliasSF4)->F4_CSTCOF $ "04/05/06/07/08/09"
			//VALOR TOTAL
			nTotalRec	+= (cAliasSD2)->D2_TOTAL        
        EndIf
        lGrava := .T.
    EndIf
	If lGrava
	    cDtEmi := SubStr((cAliasSF2)->F2_EMISSAO,7,2)+SubStr((cAliasSF2)->F2_EMISSAO,5,2)+SubStr((cAliasSF2)->F2_EMISSAO,1,4)
	    cSitFrt := SPEDPCFRT((cAliasSF2)->F2_EMISSAO,(cAliasSD2)->D2_PEDIDO)
	    If SA1->(msSeek(xFilial("SA1")+(cAliasSF2)->F2_CLIENTE+(cAliasSF2)->F2_LOJA))
		    aPartDoc := InfPartDoc ("SA1",dDataDe,dDataAte,,.F.)
	   		If aScan(aReg0150, {|aX| aX[3]==aPartDoc[1]}) == 0 
		   		Reg0150(@aReg0150,aPartDoc,nRelacFil)
		    EndIf
		EndIf	
		cProd := (cAliasSB1)->B1_COD+xFilial("SB1")
		If aScan (aReg0200, {|aX| aX[3]==cProd}) == 0 
			Reg0200(cAlias,@aReg0200,@aReg0190,dDataDe,dDataAte,aProd,cProd,nRelacFil,@aReg0205,.F.,cAliasSB1)
		EndIf
	   	If aScan (aReg0400, {|aX| aX[3]==(cAliasSD2)->D2_CF}) == 0    
			aAdd (aReg0400, {})
			nPos0400	:=	Len (aReg0400)	
			aAdd (aReg0400[nPos0400], nRelacFil)					   		//Relacao registro pai 0140
			aAdd (aReg0400[nPos0400], "0400")								//REG
			aAdd (aReg0400[nPos0400], (cAliasSD2)->D2_CF)					//COD_NAT
			aAdd (aReg0400[nPos0400], AllTrim ((cAliasSF4)->F4_TEXTO)) 	//DESCR_NAT  
		EndIf

		//M210
		cCondCont := PCCodCon("PIS",(cAliasSF4)->F4_CSTPIS,(cAliasSD2)->D2_ALQIMP6,,,(cAliasSD2)->D2_CLASFIS,lcumulativ) 
		nPos210 := aScan (aRegM210, {|aX| aX[2]==cCondCont .AND.  cvaltochar(aX[5])==cvaltochar(nAliqPis) })
		If !Empty(cCondCont)
			If nPos210 == 0
				aAdd(aRegM210, {})
				nPos := Len(aRegM210)		
				aAdd (aRegM210[nPos], "M210")											   		//01 - REG
				aAdd (aRegM210[nPos], cCondCont)												//02 - COD_CONT
				aAdd (aRegM210[nPos], nTotalRec)												//03 - VL_REC_BRT
				aAdd (aRegM210[nPos], nBcPis)													//04 - VL_BC_CONT
				aAdd (aRegM210[nPos], nAliqPis)													//05 - ALIQ_PIS                                    		
				aAdd (aRegM210[nPos], "")														//06 - QUANT_BC_PIS  
				aAdd (aRegM210[nPos], "")														//07 - ALIQ_PIS_QUANT
				aAdd (aRegM210[nPos], nCApurPIS)												//08 - VL_CONT_APUR
				aAdd (aRegM210[nPos], 0)														//09 - VL_AJUS_ACRES				
				aAdd (aRegM210[nPos], 0)														//10 - VL_AJUS_REDUC
				aAdd (aRegM210[nPos], 0)														//11 - VL_CONT_DIFER
				aAdd (aRegM210[nPos], 0)														//12 - VL_CONT_DIFER_ANT
				aAdd (aRegM210[nPos], nCApurPIS)												//13 - VL_CONT_PER
			Else
				aRegM210[nPos210][3]	+= nTotalRec											//03 - VL_REC_BRT
				aRegM210[nPos210][4]	+= nBcPis												//04 - VL_BC_CONT
				aRegM210[nPos210][8]	+= nCApurPIS											//08 - VL_CONT_APUR
				aRegM210[nPos210][13]	+= nCApurPIS											//13 - VL_CONT_PER
			EndIf
		EndIf
		//M610
		cCondCont := PCCodCon("COF",,,(cAliasSF4)->F4_CSTCOF,(cAliasSD2)->D2_ALQIMP5,(cAliasSD2)->D2_CLASFIS,lcumulativ)
		nPos610 := aScan (aRegM610, {|aX| aX[2]==cCondCont .AND.  cvaltochar(aX[5])==cvaltochar(nAliqCOF) })
		If !Empty(cCondCont)
			If nPos610 == 0
				aAdd(aRegM610, {})
				nPos := Len(aRegM610)		
				aAdd (aRegM610[nPos], "M610")											   		//01 - REG
				aAdd (aRegM610[nPos], cCondCont)												//02 - COD_CONT
				aAdd (aRegM610[nPos], nTotalRec)												//03 - VL_REC_BRT
				aAdd (aRegM610[nPos], nBcCOF)													//04 - VL_BC_CONT
				aAdd (aRegM610[nPos], nAliqCOF)													//05 - ALIQ_PIS                                    		
				aAdd (aRegM610[nPos], "")														//06 - QUANT_BC_PIS  
				aAdd (aRegM610[nPos], "")														//07 - ALIQ_PIS_QUANT
				aAdd (aRegM610[nPos], nCApurCOF)												//08 - VL_CONT_APUR
				aAdd (aRegM610[nPos], 0)														//09 - VL_AJUS_ACRES				
				aAdd (aRegM610[nPos], 0)														//10 - VL_AJUS_REDUC
				aAdd (aRegM610[nPos], 0)														//11 - VL_CONT_DIFER
				aAdd (aRegM610[nPos], 0)														//12 - VL_CONT_DIFER_ANT
				aAdd (aRegM610[nPos], nCApurCOF)												//13 - VL_CONT_PER
			Else
				aRegM610[nPos610][3]	+= nTotalRec											//03 - VL_REC_BRT
				aRegM610[nPos610][4]	+= nBcCOF												//04 - VL_BC_CONT
				aRegM610[nPos610][8]	+= nCApurCOF											//08 - VL_CONT_APUR
				aRegM610[nPos610][13]	+= nCApurCOF											//13 - VL_CONT_PER
			EndIf
		EndIf
		
		If (cAliasSF4)->F4_CSTPIS $ "04/05/06/07/08/09" .Or. (cAliasSF4)->F4_CSTCOF $ "04/05/06/07/08/09"
			dbSelectArea("CCZ")
			dbSetOrder(1)
			If CCZ->(MsSeek(xFilial("CCZ")+ (cAliasSB1)->B1_TNATREC + (cAliasSB1)->B1_CNATREC + (cAliasSB1)->B1_GRPNATR  + (cAliasSB1)->B1_DTFIMNT))		
				lAchouCCZ := .T.
			ElseIf !lAchouCCZ .And. CCZ->(MsSeek(xFilial("CCZ")+ (cAliasSF4)->F4_TNATREC + (cAliasSF4)->F4_CNATREC + (cAliasSF4)->F4_GRPNATR  + (cAliasSF4)->F4_DTFIMNT))		
				lAchouCCZ := .T.	
			EndIf  
		EndIf 
		
		//PIS
		If (cAliasSF4)->F4_CSTPIS $ "04/05/06/07/08/09"
			nPosM400 := aScan (aRegM400, {|aX| aX[2]==(cAliasSF4)->F4_CSTPIS})
			If nPosM400 == 0
				aAdd(aRegM400, {})
				nPos := Len(aRegM400)
				aAdd (aRegM400[nPos], "M400")			   	   			//01 - REG
				aAdd (aRegM400[nPos], (cAliasSF4)->F4_CSTPIS)			//02 - CST_PIS  	   	
				aAdd (aRegM400[nPos], (cAliasSD2)->D2_TOTAL)			//03 - VL_TOT_REC   	   	
				aAdd (aRegM400[nPos], cConta)							//04 - COD_CTA   	   	
				If lAchouCCZ
					aAdd (aRegM400[nPos], CCZ->CCZ_DESC )				//05 - DESC_COMPL   	   	
				Else
					aAdd (aRegM400[nPos], "" )							//05 - DESC_COMPL   	   	
				EndIF
				If lAchouCCZ  
					aAdd (aRegM410, {})
					nPos := Len(aRegM410)
					aAdd (aRegM410[nPos], Len(aRegM400))				//Relacao com M400
					aAdd (aRegM410[nPos], "M410")			   	   		//01 - REG
					aAdd (aRegM410[nPos], CCZ->CCZ_COD)					//02 - NAT_REC
					aAdd (aRegM410[nPos], (cAliasSD2)->D2_TOTAL)		//03 - VL_REC
					aAdd (aRegM410[nPos], cConta)						//04 - COD_CTA   	   	
					aAdd (aRegM410[nPos], CCZ->CCZ_DESC)				//05 - DESC_COMPL  
				EndIf  
			Else
				aRegM400[nPosM400][3]+= (cAliasSD2)->D2_TOTAL			//03 - VL_TOT_REC   	   	
				IF lAchouCCZ
					nPosM410 := aScan (aRegM410, {|aX| aX[3]==CCZ->CCZ_COD  .AND. ax[1] == nPosM400})
					If nPosM410 == 0
						aAdd (aRegM410, {})
						nPos := Len(aRegM410)
						aAdd (aRegM410[nPos], nPosM400)					//Relacao com M400
						aAdd (aRegM410[nPos], "M410")			   	 	//01 - REG
						aAdd (aRegM410[nPos], CCZ->CCZ_COD)				//02 - NAT_REC
						aAdd (aRegM410[nPos], (cAliasSD2)->D2_TOTAL)	//03 - VL_REC
						aAdd (aRegM410[nPos], cConta)					//04 - COD_CTA   	   	
						aAdd (aRegM410[nPos], CCZ->CCZ_DESC)			//05 - DESC_COMPL  
					Else
						aRegM410[nPosM410][4]+= (cAliasSD2)->D2_TOTAL	//03 - VL_TOT_REC   	   	
					EndIf
				EndIF
			EndIF
		EndIF
		
		                   			
		//COFINS
		If (cAliasSF4)->F4_CSTCOF $ "04/05/06/07/08/09"		
			nPosM800 := aScan (aRegM800, {|aX| aX[2]==(cAliasSF4)->F4_CSTCOF})
			If nPosM800 == 0
				aAdd(aRegM800, {})
				nPos := Len(aRegM800)
				aAdd (aRegM800[nPos], "M800")			   	   			//01 - REG
				aAdd (aRegM800[nPos], (cAliasSF4)->F4_CSTCOF)			//02 - CST_PIS  	   	
				aAdd (aRegM800[nPos], (cAliasSD2)->D2_TOTAL)			//03 - VL_TOT_REC   	   	
				aAdd (aRegM800[nPos], cConta)							//04 - COD_CTA   	   	
				If lAchouCCZ
					aAdd (aRegM800[nPos], CCZ->CCZ_DESC )				//05 - DESC_COMPL   	   	
				Else
					aAdd (aRegM800[nPos], "" )							//05 - DESC_COMPL   	   	
				EndIF
				If lAchouCCZ  
					aAdd (aRegM810, {})
					nPos := Len(aRegM810)
					aAdd (aRegM810[nPos], Len(aRegM800))				//Relacao com M400
					aAdd (aRegM810[nPos], "M810")			   	   		//01 - REG
					aAdd (aRegM810[nPos], CCZ->CCZ_COD)					//02 - NAT_REC
					aAdd (aRegM810[nPos], (cAliasSD2)->D2_TOTAL)		//03 - VL_REC
					aAdd (aRegM810[nPos], cConta)						//04 - COD_CTA   	   	
					aAdd (aRegM810[nPos], CCZ->CCZ_DESC)				//05 - DESC_COMPL  
				EndIf  
			Else
				aRegM400[nPosM800][3]+= (cAliasSD2)->D2_TOTAL			//03 - VL_TOT_REC   	   	
				IF lAchouCCZ
					nPosM810 := aScan (aRegM810, {|aX| aX[3]==CCZ->CCZ_COD  .AND. ax[1] == nPosM800})
					If nPosM810 == 0
						aAdd (aRegM810, {})
						nPos := Len(aRegM810)
						aAdd (aRegM810[nPos], nPosM800)					//Relacao com M400
						aAdd (aRegM810[nPos], "M810")			   	 	//01 - REG
						aAdd (aRegM810[nPos], CCZ->CCZ_COD)				//02 - NAT_REC
						aAdd (aRegM810[nPos], (cAliasSD2)->D2_TOTAL)	//03 - VL_REC
						aAdd (aRegM810[nPos], cConta)					//04 - COD_CTA   	   	
						aAdd (aRegM810[nPos], CCZ->CCZ_DESC)			//05 - DESC_COMPL  
					Else
						aRegM410[nPosM810][4]+= (cAliasSD2)->D2_TOTAL	//03 - VL_TOT_REC   	   	
					EndIf
				EndIF
			EndIF
		EndIf
		If (cAliasSF4)->F4_CSTPIS $ "04/05/06/07/08/09" .Or. (cAliasSF4)->F4_CSTCOF $ "04/05/06/07/08/09"	
			nTotalNT += (cAliasSD2)->D2_TOTAL 
		EndIf
		If cEspecie $ "01/04/1B" .OR. (cEspecie == "55" .AND. !lConsolid) .And. cChave <> (cAliasSF2)->F2_FILIAL+(cAliasSF2)->F2_SERIE+(cAliasSF2)->F2_DOC+(cAliasSF2)->F2_CLIENTE+(cAliasSF2)->F2_LOJA
			aAdd(aRegC100, {})
			nPos	:=	Len (aRegC100)
			aAdd (aRegC100[nPos], "C100")					   					//01 - REG
			aAdd (aRegC100[nPos], "1")					 						//02 - IND_OPER
			aAdd (aRegC100[nPos], "0")											//03 - IND_EMIT
			aAdd (aRegC100[nPos], aPartDoc[1])									//04 - COD_PART
			aAdd (aRegC100[nPos], cEspecie)						 				//05 - COD_MOD
			aAdd (aRegC100[nPos], "00")						  					//06 - COD_SIT
			aAdd (aRegC100[nPos], (cAliasSF2)->F2_SERIE)	  	 				//07 - SER
			aAdd (aRegC100[nPos], (cAliasSF2)->F2_DOC)		   					//08 - NUM_DOC            
			aAdd (aRegC100[nPos], (cAliasSF2)->F2_CHVNFE)						//09 - CHV_NFE
			aAdd (aRegC100[nPos], cDtEmi)										//10 - DT_DOC		
			aAdd (aRegC100[nPos], cDtEmi)										//11 - DT_E_S
			aAdd (aRegC100[nPos], (cAliasSF2)->F2_VALBRUT)						//12 - VL_DOC
			aAdd (aRegC100[nPos], "1")	  			  							//13 - IND_PAGTO - A VISTA			
			aAdd (aRegC100[nPos], (cAliasSF2)->F2_DESCONT)						//14 - VL_DESC
			aAdd (aRegC100[nPos], 0)											//15 - VL_ABAT_NT
			aAdd (aRegC100[nPos], (cAliasSF2)->F2_VALBRUT)						//16 - VL_MERC
		  	aAdd (aRegC100[nPos], cSitFrt)										//17 - IND_FRT
			aAdd (aRegC100[nPos], (cAliasSF2)->F2_FRETE)	   					//18 - VL_FRT		
			aAdd (aRegC100[nPos], (cAliasSF2)->F2_SEGURO)	  					//19 - VL_SEG		
			aAdd (aRegC100[nPos], (cAliasSF2)->F2_DESPESA - (cAliasSF2)->(F2_FRETE + F2_SEGURO))	//20 - VL_OUT_DA	
			aAdd (aRegC100[nPos], (cAliasSF2)->F2_BASEICM)	  					//21 - VL_BC_ICMS	
			aAdd (aRegC100[nPos], (cAliasSF2)->F2_VALICM)	  					//22 - VL_ICMS		
			aAdd (aRegC100[nPos], (cAliasSF2)->F2_BRICMS)	   					//23 - VL_BC_ICMS_ST
			aAdd (aRegC100[nPos], (cAliasSF2)->F2_ICMSRET)						//24 - VL_ICMS_ST
			aAdd (aRegC100[nPos], (cAliasSF2)->F2_VALIPI) 						//25 - VL_IPI	
			aAdd (aRegC100[nPos], (cAliasSF2)->F2_VALIMP6)						//26 - VL_PIS	
			aAdd (aRegC100[nPos], (cAliasSF2)->F2_VALIMP5)						//27 - VL_COFINS
			aAdd (aRegC100[nPos], 0) 						   					//28 - VL_PIS_ST
			aAdd (aRegC100[nPos], 0)						   					//29 - VL_COF_ST
			GrvNFTrS (cAlias, nRelacDoc, aRegC100,,,nPaiC)
		EndIf
		cChave	:=	(cAliasSF2)->F2_FILIAL+(cAliasSF2)->F2_SERIE+(cAliasSF2)->F2_DOC+(cAliasSF2)->F2_CLIENTE+(cAliasSF2)->F2_LOJA
	EndIf
	(cAliasSF2)->(dbSkip())
EndDo		

//0111 
If (nTotalRec > 0 .Or. nTotalNT > 0) .And. Len(aReg0111) > 0
	aReg0111[1,2] += nTotalRec
	aReg0111[1,3] += nTotalNT
	If !cRegime$"1|3"
		aReg0111[1,4] += nTotalRec
	EndIf           
	aReg0111[1,6] := ( aReg0111[1,2] + aReg0111[1,3] + aReg0111[1,4] + aReg0111[1,5])
	// aReg0111[1,6] += nTotalRec + nTotalNT		 
EndIf

#IFDEF TOP
	If (TcSrvType ()<>"AS/400")
		DbSelectArea (cAliasSF2)
		(cAliasSF2)->(DbCloseArea ())
	Else
#ENDIF
		RetIndex("SF2")
#IFDEF TOP
	EndIf
#ENDIF			

dbSelectArea("CCZ")
CCZ->(dbCloseArea())

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PCCodCon  ºAutor  ³ Vitor Felipe       º Data ³  19/09/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa para retornar o Codigo da Contribuicao do PIS	  º±±
±±º          ³ e da COFINS.                                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PCCodCon(cImp,cPISCST,nAliqPIS,cCOFCST,nAliqCOF,cCodIcTrib,lcumulativ) 

Local cCondCont := ""  

If cIMP == "PIS"
	If cPISCST == "01"
		If "1" $ cCodIcTrib 
			cCondCont :="01"
		ElseIf  "2" $ cCodIcTrib
			cCondCont :="51"	
		ElseIf lcumulativ
			cCondCont :="51"		
		Else
			cCondCont := "01"
		EndIF	
	Elseif cPISCST == "02"
		If  "2" $ cCodIcTrib
	    	cCondCont :="52"	
	 	Else
			cCondCont :="02"	 	
	 	EndIf
	Elseif cPISCST == "03"
		If  "2" $ cCodIcTrib .AND. nAliqPIS  > 0
			cCondCont :="53"	 	
		Else
			cCondCont :="03"	 	
		EndIF				
	Elseif cPISCST == "05" 
		If nAliqPIS == 0.65	
			cCondCont :="31"	
		Else
			cCondCont :="32"		
		EndIF
	EndIf
Else
	//Tratamento para COFINS.
	If cCOFCST == "01"
		If "1" $ cCodIcTrib 
			cCondCont :="01"
		ElseIf  "2" $ cCodIcTrib
			cCondCont :="51"	
		ElseIf lcumulativ 
			cCondCont :="51"		
		Else
			cCondCont := "01"
		EndIF	
	Elseif cCOFCST == "02"
		If  "2" $ cCodIcTrib
	    	cCondCont :="52"	
	 	Else
			cCondCont :="02"	 	
	 	EndIf
	Elseif  cCOFCST == "03"
		If  "2" $ cCodIcTrib .AND. nAliqCOF  > 0
			cCondCont :="53"	 	
		Else
			cCondCont :="03"	 	
		EndIF				
	Elseif cCOFCST == "05" 
		If nAliqCOF == 3	
			cCondCont :="31"	
		Else
			cCondCont :="32"		
		EndIF
	EndIf
EndIf 

Return(cCondCont)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SPEDPCFRT ºAutor  ³ Vitor Felipe       º Data ³  19/09/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa para retornar a Situacao de Frete do PIS     	  º±±
±±º          ³ e da COFINS.                                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function SPEDPCFRT(cEmissao,cPedido)

Local lNewIndic	:=  (cEmissao >= "20120101") 
Local cSitFrt	:= ""

dbSelectArea("SC5")
SC5->(dbSetOrder(1))

If 	SC5->(MsSeek(xFilial("SC5")+Alltrim(cPedido)))
	//Sem Frete		
	If Empty(SC5->C5_TPFRETE) .or. Alltrim(SC5->C5_TPFRETE)== "S"
		cSitFrt	:= "9" 
	//Frete por conta Emitente	
	ElseIf Alltrim(SC5->C5_TPFRETE)=="C" 
		cSitFrt	:=	Iif(lNewIndic,"0","1")
	//Frete por conta do destinatario  
	ElseIf Alltrim(SC5->C5_TPFRETE)=="F"
	 	cSitFrt	:=	Iif(lNewIndic,"1","2")
	//Frete por conta de Terceiros			
	ElseIf Alltrim(SC5->C5_TPFRETE)=="T"
	 	cSitFrt	:=	Iif(lNewIndic,"2","0") 
	EndIf 	
Endif

Return(cSitFrt)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GrvNFTrS  ºAutor  ³ Vitor Felipe       º Data ³  19/09/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa para gravacao do TRB do SPED PIS e COFINS.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvNFTrS (cAlias, nRelac, aReg, nItem, nFlag, nPai, cChvPai, lLoja)
	Local 	nTamTRBIt	:=	50	//Tamanho do campo relac no TRB   
	Local	nX			:=	0
	Local	lRet		:=	.T.
	Local	cDelimit	:=	"|"
	Local	nZ			:=	0
	Local	cLinha		:=	"" 
	Local	cReg		:=	"" 
	Local 	llDecim		:= .F.
	Local 	llDecim3	:= .F.	
	//
	Default	nRelac	:=	0
	Default	nFlag	:=	0
	Default cChvPai	:= ""
	Default lLoja	:= .F.
	
	If nFlag==0
		cFlag	:=	Iif(Valtype(nRelac)=="N",StrZero (nRelac, nTamTRBIt, 0),nRelac)
	Else
		cFlag	:=	StrZero (nFlag, nTamTRBIt, 0)
	EndIf
	
	For nZ := 1 To Len (aReg)
		cLinha	:=	cDelimit
		//
		//Monto cLinha para gravar no TRB
		For nX := 1 To Len (aReg[nZ])                         
		
			// Verifica se o campo deve conter 4 casas decimais 
			llDecim  := SPDGet4Dec(aReg[nZ,1],nX) 
			llDecim3 := SPDGet3Dec(aReg[nZ,1],nX) 			
			
			If (ValType (aReg[nZ][nX])="A")
				cLinha	+=	RetStr (aReg[nZ][nX][1], aReg[nZ][nX][2])+cDelimit
			Else     
				cLinha	+=	RetStr (aReg[nZ][nX],Iif(llDecim,4,If(llDecim3,3,NIL)))+cDelimit												
			EndIf
		Next (nX)   
			 
		cReg := SubStr (cLinha, 2, 4)
		
		//Tratamento para nao permitir gerar uma string maior que o tamanho do campo TRB_CONT. Se acontecer, somente serah no registro 0450.
		If Len(cLinha)>Len((cAlias)->TRB_CONT)
			cLinha	:=	AllTrim(Left(cLinha,Len((cAlias)->TRB_CONT)-1))+cDelimit
		EndIf
		//
		//Monto TRB
		RecLock (cAlias, .T.)
			(cAlias)->TRB_TPREG		:=	cReg
			(cAlias)->TRB_RELAC		:=	cFlag+Iif(!lLoja,(Iif(Valtype(nRelac)=="N",StrZero(nRelac,nTamTRBIt,0),nRelac)), StrZero (nItem, nTamTRBIt, 0)  )
			(cAlias)->TRB_CONT		:=	cLinha
			(cAlias)->TRB_ITEM		:=	nItem
			(cAlias)->TRB_PAI		:=	nPai
			(cAlias)->TRB_CHVPAI	:=	cChvPai
		MsUnLock ()
	Next (nZ)
Return (lRet)

//-------------------------------------------------------------------
/*/{Protheus.doc} SPDCodCont
Funcao que retorna o Codigo da Contribuicao, conforme
tabela 4.3.5 do Sped Contribuicoes

@param  NaoUsar	- Compatibilidade com a chamada da funcao
		lSemNota  - Origem de nota fiscal ou nao
		cCST  - Codigo da Situacao Tributaria
		nAliq  - Aliquota
		lCumulativ  - Indice da cumulatividade (originado de cadastros)
		aAtvImob  - Array com informacoes originadas de Ativo Imobilizado
		cRegime  - Tipo do Regime (wizard)
		lSCP - Indica se eh uma Contribuicao apurada de SCP
		
@return cCondCont - Retorna Codigo da Contribuicao
			
@author Luccas Curcio
@since 24/10/2012
@version 1.0
/*/
//-------------------------------------------------------------------
Function SPDCodCont(NaoUsar,lSemNota,cCST,nAliq,lCumulativ,aAtvImob,cRegime,lSCP)
Local	cCodCont	:=	""
Local	lSpedAz		:=	GetNewPar("MV_SPEDAZ",.F.)
Default	lSemNota	:=	.F.
Default	lCumulativ	:=	.F. 
Default	aAtvImob	:=	{} 
Default	lSCP		:=	.F.

//------------------------------------------------------------------------------------------
//Informacoes originadas de Ativo Imobilizado
//------------------------------------------------------------------------------------------
If Len(aAtvImob) > 0

	//Cumulativo
	If cRegime == "2"
		//Contribuicao cumulativa apurada a aliquota basica - Atividade Imobiliaria
		cCodCont	:=	"54"
	Else
		//Contribuicao nao-cumulativa apurada a aliquota basica - Atividade Imobiliaria
		cCodCont	:=	"04"
	EndIf

//------------------------------------------------------------------------------------------
//CSTs abaixo nao geram codigo de contribuicao
//------------------------------------------------------------------------------------------
Elseif cCST $ "04|06|07|08|09|49|98|99"
	cCodCont	:=	"  "

//------------------------------------------------------------------------------------------
//Contribuicao apurada de SCP - sociedade em conta de participacao
//------------------------------------------------------------------------------------------
Elseif lSCP
    
	//Operacao cumulativa
	If lCumulativ
		
		//Contribuicao apurada de SCP - Incidencia Cumulativa
		cCodCont	:=	"72"
		
	Else
		
		//Contribuicao apurada de SCP - Incidencia Nao Cumulativa
		cCodCont	:=	"71"
	
	Endif

Else
//------------------------------------------------------------------------------------------
//Operacao de Pis/Cofins de Substituicao Tributaria
//------------------------------------------------------------------------------------------
	If cCST == "05" .And. (!lSemNota .Or. (!lSpedAz .And. lSemNota))
		
		//Verifica Aliquota basica cumulativa
		If lCumulativ 
			cCodCont:=Iif(nAliq>0 ,"31" ,"" )
			//Contribuicao apurada por substituicao tributaria
		Else
			cCodCont:=Iif(nAliq>0 ,"32" ,"" )
			//Contribuicao apurada por substituicao tributaria - Vendas a Zona Franca de Manaus
		Endif
	
	Else
//------------------------------------------------------------------------------------------
//Demais Operacoes
//------------------------------------------------------------------------------------------
		
		//-----------------------------------------------------------------------
		//Preencho primeiro caracter do codigo, utilizando Regime como parametro
		//-----------------------------------------------------------------------
		//Regime Nao-Cumulativo (wizard) / Nao-Cumulativo (caso de escolher 3=Ambos na wizard)
		If "1"$cRegime .Or. ("3"$cRegime .And. !lCumulativ)
	
			cCodCont	:=	"0"
		
		//Regime Cumulativo (wizard) / Cumulativo (caso de escolher 3=Ambos na wizard)
		ElseIf "2"$cRegime .Or. ("3"$cRegime .And. lCumulativ)
		
			cCodCont	:=	"5"
			
		Endif
	
	    //-----------------------------------------------------------------------
	    //Preencho segundo caracter do codigo, utilizando CST como parametro
		//-----------------------------------------------------------------------
		
		//Operacao Tributavel com Aliquota Diferenciada
		If cCST == "02"
		
			cCodCont	+=	"2"
			
		//Operacao Tributavel com Aliquota por Unidade de Medida de Produto	
		Elseif cCST == "03"
		
			cCodCont	+=	"3"
			
		//Operacao Tributavel com Aliquota Basica
		Else
		
			cCodCont	+=	"1"
			
		Endif
	Endif
Endif

Return cCodCont

//-------------------------------------------------------------------
/*/{Protheus.doc} SPEDCodCre
Funcao que retorna o Codigo de Tipo de Credito, conforme
tabela 4.3.6 do Sped Contribuicoes

@param  cCST  - Codigo da Situacao Tributaria
		cCodBCC  - Codigo de Base de Calculo do Credito
		lPauta  - Operacao com Unidade de Produto
		lImport  - Operacao de Importacao
		cCodNatRec  - Codigo da Natureza da Receita
		cIndCont  - Tipo de Aliquota (Basica/Diferenciada)
		cAlqUni  - Aliquota Unidade de Produto
		nCont  - Contador com Posicao do Tipo de Receita (1,2,3)
		
@return cCodCred - Retorna Codigo do Tipo de Credito
			
@author Luccas Curcio
@since 28/11/2012
@version 1.0
/*/
//-------------------------------------------------------------------
Function SPEDCodCre(cCST,cCodBCC,lPauta,lImport,cCodNatRec,cIndCont,cAlqUni,nCont)
Local	cCodCred	:=	""
Local	lMultTpRec	:=	.F.
Default	nCont		:=	0
Default cAlqUni		:=	""

Do Case

	//Codigos Vinculados a Receita Tributada no Mercado Interno
	Case cCST $ "50/60"
		cCodCred	:=	"1"
	
	//Codigos Vinculados a Receita Nao Tributada no Mercado Interno
	Case cCST $ "51/61"
		cCodCred	:=	"2"
		
	//Codigos Vinculados a Receita de Exportacao 
	Case cCST $ "52/62"
		cCodCred	:=	"3"
	
	//Chamada da funcao CSTREC() para mais de um tipo de receita	
	OtherWise
		cCodCred	:=	CSTREC(cIndCont,cAlqUni,lImport,nCont,cCst,cCodBcc)
		lMultTpRec	:=	.T.

EndCase

If !lMultTpRec		
	//Codigo de Base de Calculo do Credito 15 - Atividade Imobiliaria - Custo Incorrido de Unidade Imobiliaria
	//Codigo de Base de Calculo do Credito 16 - Atividade Imobiliaria - Custo Orcado de unidade nao concluida
	If cCodBCC $ "15/16"
		
		//Atividade Imobiliaria
		cCodCred	+=	"09"
					
	//Codigo de Base de Calculo do Credito 18 - Estoque de abertura de bens
	Elseif cCodBCC == "18"
		
		//Estoque de Abertura
		cCodCred	+=	"04"
			
	//Codigo da Situacao Tributaria 6x (exceto 67) - Credito Presumido - Operacao de Aquisicao Vinculada Exclusivamente a Receita Tributada no Mercado Interno		
	Elseif Substr(cCST,1,1) $ "6" .And. cCst <> "67"
	    
		//Presumido da Agroindustria
		cCodCred	+=	"06"
	
	//Importacao	
	Elseif lImport
	
		//Importacao
			cCodCred	+=	"08" 
			
	//Operacoes com Unidade de Produto
	Elseif  lPauta
		
		//Codigo da Natureza da Receita iniciado por 7		
		If cCodNatRec == "7"
		
		    //Aquisicao Embalagens para revenda
			cCodCred	+=	"05"
				
		Else
		    //Aliquota por Unidade de Produto
			cCodCred	+=	"03"
		Endif
	
	//Aliquota basica
	ElseIf cIndCont == "1"

	    //Aliquota Basica
		cCodCred	+=	"01"
		
	Else

	    //Aliquota Diferenciada
		cCodCred	+=	"02"
	EndIf
Endif

Return cCodCred

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |SPDLeRegRel³ Autor ³Gustavo G. Rueda       ³ Data ³16.03.2011³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o³Essa funcao primeiramente procura o relacionamento exato,    ³±±
±±³          ³ caso nao encontre, ela procura novamente quebrando pelo    ³±±
±±³          ³ grupo. Os codigos de grupo devem ser unicos por grupo, para³±±
±±³          ³ nao gerar informacoes divergentes.                         ³±±
±±³          ³Esta funcao soh prepara os registros para gravacao que serah³±±
±±³          ³ efetuada pela funcao SPDRePorNf                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nil                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|nHandle -> Handle do arquivo txt aberto.                    ³±±
±±³          |cAlias -> Alias do TRB criado atraves da funcao principal.  ³±±
±±³          |cRegP  -> Identificador do registro PAI                     ³±±
±±³          |aRegF  -> Array com os identificadores dos registros filhos ³±±
±±³          |cRelac -> Relacionamento do registro pai para com os filhos ³±±
±±³          |nTo    -> Determina se permite fazer o segundo seek ou nao  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPDLeRegRel(nHandle,cAlias,cRegP,aRegF,cRelac,nTo)
Local	nTamTRBIt	:=	Len((cAlias)->TRB_RELAC)/2		//Efetuo divisao por dois porque faco dois controles em um mesmo campo. O relacionamento e sequencia. Ex: ...0001...1, ...0001...2
Local	cChave		:=	cRegP+cRelac					//Chave do primeiro SEEK
Local	cChave2		:=	cRegP+SubStr(cRelac,1,nTamTRBIt)//Chave do segundo SEEK				
Local	nI			:=	0
Local	nX			:=	0
Local	aAreaLoc	:=	(cAlias)->(GetArea())

Default	nTo			:=	1
					
For nI := 1 To nTo					
	If (cAlias)->(DbSeek (cChave))
		Do While !(cAlias)->(Eof ()) .And. cChave==Left((cAlias)->TRB_TPREG+(cAlias)->TRB_RELAC,Len(cChave))

			If Empty((cAlias)->TRB_FLAG)

				SPEDGrvLin(nHandle,cAlias)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Utilizo o codigo de relacionamento do PAI para procurar os FILHOS.     ³
				//³Esta troca deve ser executada sometne para o segundo seek, pois no pri-³
				//³ meiro o RELAC fica a criterio de como for passado, para o segundo nao,³
				//| pego do TRB                                                           |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nI==2
					cRelac	:=	(cAlias)->TRB_RELAC
				EndIf
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Gravo todos os filhos correspondentes ao PAI³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				For nX := 1 To Len(aRegF)
			   		SPDRePorNf(nHandle,cAlias,aRegF[nX],cRelac,(cAlias)->TRB_ITEM,nTo==2)
			 	Next nX
			EndIf
			
			(cAlias)->(DbSkip ())
		EndDo                  
		//Exit
	EndIf
	cChave	:=	cChave2	//Trocando a chave para o segundo SEEK
Next nI

RestArea(aAreaLoc)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³SpedRg1010³ Autor ³ Luccas Curcio          ³ Data ³25.07.2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera o Registro 1010 									   ³±±
±±³          ³ 											                   ³±±
±±³          ³ OBRIGATORIEDADE DE REGISTROS DO BLOCO 1                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³aWizard -> informacoes preenchidas no Wizard                 ³±±
±±³          ³ cAlias -> Alias do TRB   								   ³±±   
±±³          ³ aReg1010 -> Array que contem os registros obrigatorios	   ³±±
±±³          ³ 			  declarados no registro 1010					   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SpedRg1010(aWizard,cAlias,aReg1010)
Local	nPos	:=	0
Local	nX		:=	0

aAdd(aReg1010, {})
nPos	:=	Len (aReg1010)
aAdd (aReg1010[nPos], "1010")	//01 - REG

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifico se o periodo utiliza a partir da versao 006 do layout ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cVersao >= "006"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se possui as perguntas do registro na wizard, verifico as respostas do usuario, senao preencho o registro com "N"³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	If Len(aWizard) > 4
		For nX := 1 To Len(aWizard[5])
			aAdd(aReg1010[nPos], Iif("1"$aWizard[5][nX],"S","N"))
		Next nX
	Else
		For nX := 1 To 9
			aAdd(aReg1010[nPos], "N")
   		Next nX	
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Efetuo gravacao do registro 1010 na temporaria ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	GrvRegTrS (cAlias,,aReg1010)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se estiver utilizando layout antes da versao 006, apenas preencho o registro ³
//³para gerar os demais do bloco 1, mas nao gravo o registro 1010 na temporaria ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Else
	For nX := 1 To 9
		aAdd(aReg1010[nPos], "S")
	Next nX
Endif

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} SpedMotInv
Funcao que retorna se o produto devera ser gerado nos registros do
Inventario (Bloco H)

@param  cMotInv  - Motivo do Inventario (01 - 05)
		cProd  - Codigo do produto
		lCmpAltTri  - FieldPos do campo B5_ALTTRIB
		nAliqProd  - Aliquota interna do produto
		
@return lRet - Processa ou nao o produto
			
@author Luccas Curcio
@since 20/02/2013
@version 1.0
/*/
//-------------------------------------------------------------------
Function SpedMotInv(cMotInv,cProd,lCmpAltTri,nAliqProd)
Local	lRet	:=	.F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Motivos de Inventario:	01 - No final no periodo;															³
//³							03 - Na solicitacao da baixa cadastral, paralisacao temporaria e outras situacoes;	³
//³							04 - Na alteracao de regime de pagamento - condicao do contribuinte;				³
//³							05 - Por determinacao dos fiscos													³
//³																												³
//³Processo todos os produtos para o H010 e soh nao processa H020 para Motivo 01 (verificacao no SPEDFISCAL)	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cMotInv $ "01|03|04|05"

	lRet	:=	.T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Motivo de Inventario 02 - Na mudanca de forma de tributacao da mercadoria (ICMS)	³
//³																					³
//³Apenas gero o registro H010 se houve alteracao na forma de tributacao, indicado	³
//³no campo B5_ALTTRIB 																³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifico se houve alteracao na forma de tributacao de ICMS	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lCmpAltTri .And. SB5->(MsSeek(xFilial("SB5")+PadR(Alltrim(cProd),TamSX3("B1_COD")[1])))
		If SB5->B5_ALTTRIB == "1"
			lRet	:=	.T.
		Endif
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para obter a aliquota interna do produto, caso o campo no cadastro nao esteja preenchido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nAliqProd <= 0
	nAliqProd	:=	GetNewPar("MV_ICMPAD",18)
EndIf

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³SpedApE200| Autor ³Gustavo G. Rueda 			   ³ Data ³04.05.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³                        GERACAO DO BLOCO E                         ³±± 
±±³          ³REGISTRO E200 - PERIODO DA APURACAO DO ICMS ST                     ³±± 
±±³          ³REGISTRO E210 - APURACAO DO ICMS - SUBSTITUICAO TRIBUTARIA         ³±±  
±±³          ³REGISTRO E250 - OBRIGACOES DO ICMS A RECOLHER - SUBSTITUICAO       ³±± 
±±³          ³                TRIBUTARIA                                         ³±± 
±±³          ³                                                                   ³±±
±±³          ³Funcao utilizada para montar a estrutura dos registros acima       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1 -> Identifica se houve movimento no periodo ou nao           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³aRegE200 -> Array com as informacoes do registro E200              ³±±
±±³          ³aRegE210 -> Array com as informacoes do registro E210              ³±±
±±³          ³aRegE250 -> Array com as informacoes do registro E250              ³±±
±±³          ³aVlrMovST- Valores de apuracao obtidos durante o processamento dos ³±±
±±³          ³           documentos                                              ³±±
±±³          ³nApuracao -> Tipo de apuracao, padrao 3                            ³±±
±±³          ³nPeriodo  -> Periodo de apuracao, padrao 1                         ³±±
±±³          ³cNrLivro  -> Numero do livro selecionado no wizard                 ³±±
±±³          ³cArqAnt- Arquivo de apuraao do periodo anterior inf. no wizard     ³±±
±±³          ³cMVEstado -> Conteudo do parametro MV_ESTADO                       ³±±
±±³          |aIcmPago - Informacoes das GNREs de documentos fiscais para o E250 ³±±
±±³          ³cMVSUBTRIB-Conteudo do parametro MV_SUBTRIB                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SpedApE200(aRegE200,aRegE210,aRegE250,aVlrMovST,nApuracao,nPeriodo,cNrLivro,cArqAnt,cMVEstado,aIcmPago,cMVSUBTRIB)
Local	nX			:=	0
Local	nUf			:=	0
Local	nPos		:=	0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Apos a execucao do RESUMEF3, apuro alguns valores para por UF para alimentar o E210 corretametne³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nUF := 1 To Len(aRegE200)

	aApuracao	:=	SpedCkApST(aVlrMovST,nApuracao,nPeriodo,cNrLivro,cArqAnt,cMVEstado,aRegE200[nUF,2],cMVSUBTRIB,aRegE200[nUF,4])

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³(3) VL_SLD_CRED_ANT_ST - Valor do "SALDO CREDOR DE PERIODO ANTERIOR -ST"³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aRegE210[nUF,4]	+=	aApuracao[1]

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³(4) VL_DEVOL_ST - Valor total de ICMS ST de devolucao de mercadorias³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aRegE210[nUF,5]	+=	aApuracao[2]	                                    
    
   	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³(5) VL_RESSARC_ST - Valor total do ICMS ST de ressarcimentos ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	aRegE210[nUF,6]	+=	aApuracao[5] 	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³(6)VL_OUT_CRED_ST = Valor total de ajustes "OUTROS CREDITOS ST ou ³
	//³                                        ESTORNO DE DEBITOS ST"    ³
	//³                                                                  ³
	//³O valor considerado aqui se refere ao credST                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aRegE210[nUF,7]	+=	aApuracao[3]
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³(8)VL_RETENCAO_ST - Valor total do ICMS ST retido por ST³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aRegE210[nUF,9]	+=	aApuracao[4]

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualizando valores de alguns campos do registro E210 que dependem³
	//³ dos valores dos lancamentos                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//(11)VL_SLD_DEV_ANT_ST - Valor total do saldo devedor antes das deducoes
	aRegE210[nUf,12]	:=	(aRegE210[nUf,9]+aRegE210[nUf,10]+aRegE210[nUf,11])-(aRegE210[nUf,4]+aRegE210[nUf,5]+aRegE210[nUf,6]+aRegE210[nUf,7]+aRegE210[nUf,8])

	//(13)VL_ICMS_RECOL_ST - Imposto a recolher ST
	aRegE210[nUf,14]	:=	aRegE210[nUf,12]-aRegE210[nUf,13]
	
	//(14)VL_SLD_CRED_ST_TRANSPORTAR - Saldo credor a transportar para o periodo seguinte
	If aRegE210[nUf,14]<0
		aRegE210[nUf,15]	:=	Abs(aRegE210[nUf,14])
		
		//Acertando valores negativos
		aRegE210[nUf,12]	:=	Max(aRegE210[nUf,12],0)
		aRegE210[nUf,14]	:=	Max(aRegE210[nUf,14],0)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se algum valor de ST foi encontrado na apuracao do periodo,    |
	//|  altero o Flag para "1" para indicar movimento                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 4 To Len(aRegE210[nUf])
		If aRegE210[nUf,nX]>0
			aRegE210[nUf][3]	:=	"1"
			Exit
		EndIf
	Next nX
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica GUIAS pagas na emissao do documento para agregar no registro E250 |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 to Len(aIcmPago)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Garanto que as GNREs em processamento sejam para o mesmo estado da apuracao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If aIcmPago[nX][1]==aRegE200[nUF,2]
		    
			//Se tiver GUIA, tenho que alterar o STATUS do registro E210, mesmo que tenha somente a GNRE, sem nenhum valor no E210
			aRegE210[nUf][3]	:=	"1"

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³REGISTRO E250 - OBRIGACOES DO ICMS A RECOLHER - SUBSTITUICAO TRIBUTARIA                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aAdd(aRegE250, {})
			nPos	:=	Len (aRegE250)
			aAdd (aRegE250[nPos], nUF)							//Relacionamento com E210
			aAdd (aRegE250[nPos], "E250")						//01 - REG
			                            						
			If SPEDSeek("SF6",1,xFilial("SF6")+cMVESTADO+aIcmPago[nX][3]) 
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Definindo o codigo da obrigacao a recolher³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SF6->F6_OPERNF == "1"
					aAdd (aRegE250[nPos], "001")				//02 - COD_OR - Entradas				
				ElseIf SF6->F6_EST==cMvEstado
					aAdd (aRegE250[nPos], "002")				//02 - COD_OR - Saidas p/ Estado				
				Else	
					aAdd (aRegE250[nPos], "999")				//02 - COD_OR - Saidas fora Estado				
				EndIf   
			Else
				aAdd (aRegE250[nPos], "999")					//02 - COD_OR - Saidas fora Estado				
			EndIf						
			aAdd (aRegE250[nPos], aIcmPago[nX][2])				//03 - VL_OR
			aAdd (aRegE250[nPos], aIcmPago[nX][4])				//04 - DT_VCTO
			aAdd (aRegE250[nPos], aIcmPago[nX][5])				//05 - COD_REC
			aAdd (aRegE250[nPos], aIcmPago[nX][9])				//06 - NUM_PROC
			aAdd (aRegE250[nPos], aIcmPago[nX][10])			//07 - IND_PROC
			aAdd (aRegE250[nPos], aIcmPago[nX][11])			//08 - PROC
			aAdd (aRegE250[nPos], "")							//09 - TXT_COMPL	

			If cVersao >= "004" //A partir de janeiro de 2011 incluir o campo 10 mmaaaa
				aAdd (aRegE250[nPos], StrZero(aIcmPago[nX][7],2) + cValToChar(aIcmPago[nX][8]))//10 - MES_REF
			EndIf
		EndIf
	Next
Next nUF
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} SpedXAjSCP
Funcao que processa os documentos fiscais de Sociedade em Conta de
Participacao, para que sejam gerados os ajustes e registros correspondentes

@param  nOpc  - Opcao de processamento da funcao. Opcao 1: Ajustes de 
				Contribuicao com base nos documentos apurados; Opcao 2: Ajustes 
				de Credito com base nos documentos apurados; Opcao 3: Ajustes 
				de Contribuicao com base nos Ajustes de Credito
		xInfDoc  - Informacoes do documento de origem
		aAjReduc  - Array preenchido com informacoes dos ajustes de reducao
		aAjAcres  - Array preenchido com informacoes dos ajustes de acrescimo
		lCumulativ  - Indica se eh uma operacao do regime cumulativo
		cRegime  - Regime selecionado na wizard da rotina
		dDataAte  - Data Final do processamento
		
@return Nil
			
@author Luccas Curcio
@since 19/12/2012
@version 1.0
/*/
//-------------------------------------------------------------------
Function SpedXAjSCP(nOpc,xInfDoc,aAjReduc,aAjAcres,lCumulativ,cRegime,dDataAte)
Local	nPos		:=	0
Local	nValPis		:=	0
Local	nValCof		:=	0
Local	nAliqPis	:=	0
Local	nAliqCof	:=	0
Local	cCST		:=	""
Local	cCodCont	:=	""
Local	lTypeChar	:=	ValType(xInfDoc) == "C"

//Verifico se as informacoes do documento sao passadas por uma query (Blocos A, C, D) ou um array (Bloco F)
nValPis		:=	Iif ( lTypeChar,	(xInfDoc)->FT_VALPIS,	xInfDoc[6] ) 
nValCof		:=	Iif ( lTypeChar,	(xInfDoc)->FT_VALCOF,	xInfDoc[10])
nAliqPis	:=	Iif ( lTypeChar,	(xInfDoc)->FT_ALIQPIS,	xInfDoc[5] )
nAliqCof	:=	Iif ( lTypeChar,	(xInfDoc)->FT_ALIQCOF,	xInfDoc[9] )
cCST		:=	Iif ( lTypeChar,	(xInfDoc)->FT_CSTPIS,	xInfDoc[3] )

//-----------------------------------------------------------------------
//Opcao 1: Ajustes de Contribuicao com base nos documentos apurados
//-----------------------------------------------------------------------
If nOpc == 1

	//Verifico o codigo da contribuicao
	cCodCont	:=	SpdCodCont(,.F.,cCST,,lCumulativ,,cRegime)
    
	//Gravo na posicao 10 do array aAjReduc a filial SCP que esta fazendo o ajuste, pois devo segregar esta informacao
	//ao gerar os registros de contribuicao. Utilizo o Codigo de Contribuicao e a filial na chave do processamento
	If (nPos := aScan( aAjReduc, {|x| x[1] == cCodCont .And. x[10] == FWGETCODFILIAL } ) ) == 0
		
		//Ajuste de reducao
		aAdd(aAjReduc, {})
		nPos := Len(aAjReduc)
		aAdd (aAjReduc[nPos], cCodCont)	
		aAdd (aAjReduc[nPos], nValPis)
		aAdd (aAjReduc[nPos], nValCof)
		aAdd (aAjReduc[nPos], "05")
		aAdd (aAjReduc[nPos], "")
		aAdd (aAjReduc[nPos], "Ajuste de Redução - Sociedade em Conta de Participação (Filial: "+FWGETCODFILIAL+")")
		aAdd (aAjReduc[nPos], dDataAte)
		aAdd (aAjReduc[nPos], nAliqPis)
		aAdd (aAjReduc[nPos], nAliqCof)
		aAdd (aAjReduc[nPos], FWGETCODFILIAL)
	Else
		//Aglutina valores - Ajuste de reducao
		aAjReduc[nPos][2]	+=	nValPis
		aAjReduc[nPos][3]	+=	nValCof
	Endif
	
	
	//Retorno codigo da contribuicao em relacao a SCP - 71 ou 72
	cCodCont	:=	SpdCodCont(,.F.,cCST,,lCumulativ,,cRegime,.T.)
	
	If (nPos := aScan( aAjAcres, {|x| x[1] == cCodCont .And. x[10] == FWGETCODFILIAL } ) ) == 0
                          
		//Ajuste de acrescimo
		aAdd(aAjAcres, {})
		nPos := Len(aAjAcres)
		aAdd (aAjAcres[nPos], cCodCont)
		aAdd (aAjAcres[nPos], nValPis)
		aAdd (aAjAcres[nPos], nValCof)
		aAdd (aAjAcres[nPos], "05")
		aAdd (aAjAcres[nPos], "")
		aAdd (aAjAcres[nPos], "Ajuste de Acréscimo - Sociedade em Conta de Participação (Filial: "+FWGETCODFILIAL+")")
		aAdd (aAjAcres[nPos], dDataAte)
		aAdd (aAjAcres[nPos], nAliqPis)
		aAdd (aAjAcres[nPos], nAliqCof)
		aAdd (aAjAcres[nPos], FWGETCODFILIAL)
	Else
		//Aglutina valores - Ajuste de acrescimo
		aAjAcres[nPos][2]	+=	nValPis
		aAjAcres[nPos][3]	+=	nValCof
	Endif

//-----------------------------------------------------------------------
//Opcao 2: Ajustes de Credito com base nos documentos apurados
//-----------------------------------------------------------------------
Elseif nOpc == 2

	If (nPos := aScan( aAjReduc, {|x| x[1] == FWGETCODFILIAL } ) ) == 0
	
		//Ajuste de reducao
		aAdd(aAjReduc, {})
		nPos := Len(aAjReduc)
		aAdd (aAjReduc[nPos], FWGETCODFILIAL)	
		aAdd (aAjReduc[nPos], "0")
		aAdd (aAjReduc[nPos], nValPis)
		aAdd (aAjReduc[nPos], nValCof)
		aAdd (aAjReduc[nPos], "05")
		aAdd (aAjReduc[nPos], "Ajuste de Redução - Sociedade em Conta de Participação (Filial: "+FWGETCODFILIAL+")")
		aAdd (aAjReduc[nPos], dDataAte)
		
	Else
	
		//Aglutina valores - Ajuste de reducao
		aAjReduc[nPos][3]	+=	nValPis
		aAjReduc[nPos][4]	+=	nValCof
	
	Endif

//-----------------------------------------------------------------------	
//Opcao 3: Ajustes de Contribuicao com base nos Ajustes de Credito
//-----------------------------------------------------------------------
Elseif nOpc == 3

	//Retorno codigo da contribuicao em relacao a SCP - 71 ou 72
	cCodCont	:=	SpdCodCont(,.F.,cCST,,lCumulativ,,cRegime,.T.)
	
	//Gravo na posicao 10 do array aAjReduc a filial SCP que esta fazendo o ajuste, pois devo segregar esta informacao
	//ao gerar os ajustes. Utilizo o Codigo de Contribuicao e a filial na chave do processamento
	If (nPos := aScan( aAjReduc, {|x| x[1] == cCodCont .And. x[10] == FWGETCODFILIAL } ) ) == 0
		
		//Ajuste de reducao
		aAdd(aAjReduc, {})
		nPos := Len(aAjReduc)
		aAdd (aAjReduc[nPos], cCodCont)	
		aAdd (aAjReduc[nPos], nValPis)
		aAdd (aAjReduc[nPos], nValCof)
		aAdd (aAjReduc[nPos], "05")
		aAdd (aAjReduc[nPos], "")
		aAdd (aAjReduc[nPos], "Ajuste de Redução Proveniente de Ajustes de Crédito - Sociedade em Conta de Participação (Filial: "+FWGETCODFILIAL+")")
		aAdd (aAjReduc[nPos], dDataAte)
		aAdd (aAjReduc[nPos], nAliqPis)
		aAdd (aAjReduc[nPos], nAliqCof)
		aAdd (aAjReduc[nPos], FWGETCODFILIAL)
		
	Else
		//Aglutina valores - Ajuste de reducao
		aAjReduc[nPos][2]	+=	nValPis
		aAjReduc[nPos][3]	+=	nValCof
		
	Endif
Endif

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} SpdXRetCod
Funcao que retorna os codigos conforme regime ou outra caracteristica
especifica, conforme parametros enviados

@param  nTipo  - Opcao do tipo de codigo. Tipo 1: Codigos de Contribuicao
		aTipo  - Array com os tipos de codigos que serao retornados.
				 Ex.: NC -> Nao Cumulativo; C -> Cumulativo
		
@return Nil
			
@author Luccas Curcio
@since 19/12/2012
@version 1.0
/*/
//-------------------------------------------------------------------
Function SpdXRetCod(nTipo,aTipo)
Local	cRet	:=	""
Local	nX		:=	0
Default aTipo	:=	{}	

For nX := 1 To Len(aTipo)

	//Retorna codigos de Contribuicao
	If nTipo == 1
		//Codigos de Contribuicao - Cumulativo
		If aTipo[nX] == "C"
			cRet	+=	"51, 52, 53, 54, 41, 72, 31, "
		//Codigos de Contribuicao - Nao Cumulativo
		Elseif aTipo[nX] == "NC"
			cRet	+=	"01, 02, 03, 04, 32, 71, "
		//Codigos de Contribuicao - Atividade Imobiliaria - RET
		Elseif aTipo[nX] == "RET"
			cRet	+=	"70, "
		//Codigos de Contribuicao - Folha de Salario
		Elseif aTipo[nX] == "FS"
			cRet	+=	"99, "
		Endif
	Endif

Next nX

//Exclui a virgula no final da string
cRet	:=	Substr(cRet,1,Len(cRet)-2)

Return cRet


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³SPDG130140| Autor ³Gustavo G. Rueda 			   ³ Data ³18.03.2011³±±   
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ OLD => SPDBGPrDoc                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Funcao utilizada para montar um array com as informacoes dos       ³±±
±±³          ³ documentos de acordo com o tipo de movimento para gerar os        ³±±
±±³          ³ registro G130 e G140                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³lTop     - Flag que indica processamento em ambiente TOP           ³±±
±±³          ³cAliasSFA- Alias de processamento da tabela SFA                    ³±±
±±³          ³cTpMov   - Flag que identifica o tipo de movimento CIAP            ³±±
±±³          ³lAchouSFT- Flag que indica posicionamento da tabela SFT para o     ³±±
±±³          ³  documento de entrada                                             ³±±
±±³          ³lAchouSA2- Flag que indica posicionamento da tabela SA2 para o     ³±±
±±³          ³  documento de entrada                                             ³±±
±±³          ³aCmpsSF9 - Informacoes processadas atraves de parametros para dados³±±
±±³          ³  dos documentos de entrada que nao existam no sistema             ³±±
±±³          ³aReg0150 - Array com os dados dos participantes para validacao     ³±±
±±³          ³cAlias   - Alias do TRB                                            ³±±
±±³          ³aWizard  - Informacoes do assistente da rotina                     ³±±
±±³          ³lAchouSB1- Flag que indica posicionamento da tabela SB1 para o     ³±±
±±³          ³  documento de entrada                                             ³±±
±±³          ³aReg0190 - Array de UM      para consistir um novo dado            ³±±
±±³          ³aReg0200 - Array de produto para consistir um novo dado            ³±±
±±³          ³aReg0220 - Array de produto para consistir um novo dado            ³±±   
±±³          ³nRecnoSFT - Recno do SFT do registro                               ³±±       
±±³          ³lF9SKPNF - Conteudo do parametro MV_F9SKPNF                        ³±±   
±±³          ³lExtratTAF - Informa se a chamada da funcao eh o Extrator TAF      ³±±   
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPDG130140(lTop,cAliasSFA,cTpMov,lAchouSFT,lAchouSA2,aCmpsSF9,aReg0150,cAlias,aWizard,lAchouSB1,aReg0200,aReg0190,aReg0220,nRecnoSFT,lF9SKPNF,aExistBloc,aAlIndic,lExtratTAF,lConcFil)
Local	aPartDoc	:=	{}
Local	aInf		:=	{}
Local	n2RecnoSFT	:=	Nil
Local	nRecnoSD2	:=	Nil
Local	nRecnoSA1	:=	Nil
Local	n2RecnoSB1	:=	Nil
Local	lAchou2SFT	:=	.F.
Local	lAchouSA1	:=	.F.
Local	lAchouSD2 	:= 	.F.
Local	dDataDe		:=	""
Local	dDataAte	:=	""
Local   lIniObrFis  := 	""
Local	cCodPro		:=	""
Local	cNumItem	:=	""
Local	cEspecie	:=	""
Local	cChvNfe		:=	""
Local	aProd		:=	Nil
Local	cUnid		:=	Nil     
Local   cSegUnid	:= ""
Local   cTpUnid		:= ""
Local 	nConvUnid	:= 0

Default nRecnoSFT	:= Nil   
Default lF9SKPNF	:= .F.
Default lExtratTAF  := .F.  
Default lConcFil	:= .T.

If !lExtratTAF
	dDataDe		:=	SToD(aWizard[1,1])
	dDataAte	:=	SToD(aWizard[1,2])
	lIniObrFis  := Iif("1"$aWizard[1][14],.T.,.F.)
Else
	lIniObrFis  := Iif("1"$aWizard[1][8],.T.,.F.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para enviar as informacoes de saida para os respectivos TIPO DE MOVIMENTO³
//| MC e IA nao eh tratado pela aplicacao                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTpMov$"MC/IM/IA/AT/SI" 
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Caso o campo "Inicio Obrigacao Escrituraca Fiscal CIAP" seja "Sim" os blocos G130 e G140 serao gerados para todos os bens que tiveram movimentacao  |
	//| do ativo imobilizado (campo TIPO_MOV do registro G125(Movimentação de Bem ou componente do ativo imobilizado) igual a "SI")                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cTpMov$"/IM/IA" .Or. (lIniObrFis .And. cTpMov $ "/SI") //ENTRADA
								
		// Reposiciona a tabela SFT. pois quando ha devolucao na baixa a mesma e' desposicionada  
		If !lF9SKPNF
			lAchouSFT := 	SPEDSeek("SFT",,xFilial("SFT")+"E"+SF9->(F9_SERNFE+F9_DOCNFE+F9_FORNECE+F9_LOJAFOR+F9_ITEMNFE),nRecnoSFT)    
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento para verificar o tipo de emissao do documento fiscal³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		//Emissao Propria
		If lAchouSFT .And. "S" $SFT->FT_FORMUL
			cIndEmit := "0"				
		//Emissao de Terceiros
		Else
			cIndEmit := "1"
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento para participante³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lAchouSA2
			aPartDoc :=	InfPartDoc ("SA2",,,,,,,lExtratTAF)
			If !lExtratTAF
				SDPF150175(@aReg0150,aPartDoc,cAlias,aWizard,aAlIndic)
		    EndIf						
		Else
			aAdd(aPartDoc,"")
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento para quando nao encontrar a NF, possibilita a criacao de um campo³
		//³ no SF9 para gerar a informacao                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lAchouSFT   .Or. Empty(aCmpsSF9[1]) 
			cEspecie	:=	AModNot(SFT->FT_ESPECIE)
		ElseIf !Empty(aCmpsSF9[1])	//f9_especie
			cEspecie	:=	iif(AModNot(aCmpsSF9[2])<>"", AModNot(aCmpsSF9[2]), AModNot(SFT->FT_ESPECIE))
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento para quando nao encontrar a NF, possibilita a criacao de um campo³
		//³ no SF9 para gerar a informacao                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lAchouSFT
			cChvNfe	:=	SFT->FT_CHVNFE
		ElseIf !Empty(aCmpsSF9[2])
			cChvNfe	:=	aCmpsSF9[4]
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento para utilizar o padrao ou customizado³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty(SF9->F9_ITEMNFE) 
			cNumItem	:=iif(!empty(aCmpsSF9[6]),AllTrim(Str(Val(aCmpsSF9[6]))),"1")
		Else
			cNumItem	:= iif(!empty(SF9->F9_ITEMNFE), AllTrim(Str(Val(SF9->F9_ITEMNFE))),"1") 
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento para o produto posicionado na funcao principal³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lAchouSB1
			If !lExtratTAF
				cCodPro	:=	SB1->B1_COD+ Iif(lConcFil,xFilial("SB1"),"")
				cSegUnid		:= SB1->B1_SEGUM
				nConvUnid		:= SB1->B1_CONV
				cTpUnid	 		:= SB1->B1_TIPCONV
			Else
				cCodPro	:=	SB1->B1_COD
			EndIf
		Elseif !empty(aCmpsSF9[26]) 
		    cCodpro := aCmpsSF9[26]+ Iif(lConcFil,xFilial("SB1"),"")
		Else
			cCodPro	:=	""
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Processando chamada do registro 0190/0200/0220 para verificar o produto³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(cCodPro)

		   	If !lExtratTAF
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Ponto de entrada para taratmento da informação de produtos quando o mesmo estah fora do padrao do sistema³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If aExistBloc[05] 
					aProd := Execblock("SPEDPROD", .F., .F., {"SFT","G140"})
					If Len(aProd)==11
						cCodPro 	:= 	aProd[1]
						cUnid		:=	aProd[5]
					Else
						aProd := {"","","","","","","","","","",""}
					EndIf					
				EndIf
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Processamento do ponto de entrada para alteracao da unidade de medida caso exista³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If aExistBloc[01]
			  		aSpdFis02 := ExecBlock("SPDFIS02", .F., .F., {"SFT",SFT->FT_TIPOMOV,"G140"})
	
				   If ValType(aSpdFis02)=="A"
				      cUnid     := aSpdFis02[1]
				   Else   
					  cUnid     := ExecBlock("SPDFIS02", .F., .F., {"SFT",SFT->FT_TIPOMOV,"G140"})
				   EndIf
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Processando chamada do registro 0190/0200/0220 para verificar o produto³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
				If aScan(aReg0200,{|aX| aX[2]==cCodPro}) == 0
					SFRG0200(cAlias,@aReg0200,@aReg0190,dDataDe,dDataAte,aProd,cCodPro,@aReg0220,,cUnid,,,,,,,,,{cSegUnid,nConvUnid,cTpUnid})
				EndIf
			EndIf				
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Montando array para retornar as informacoes³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd(aInf, cIndEmit)
		aAdd(aInf, aPartDoc[1])
		aAdd(aInf, cEspecie)
		aAdd(aInf, SF9->F9_SERNFE)
		aAdd(aInf, SF9->F9_DOCNFE)
		aAdd(aInf, cChvNfe)
		aAdd(aInf, SF9->F9_DTEMINE)
		aAdd(aInf, cNumItem)
		aAdd(aInf, cCodPro)
		
	ElseIf cTpMov$"/AT/"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se NAO for TOP tenho que posicioar a tabela SF9³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lTop
			n2RecnoSFT	:=	(cAliasSFA)->SFT2RECNO
			nRecnoSD2	:=	(cAliasSFA)->SD2RECNO
			nRecnoSA1	:=	(cAliasSFA)->SA1RECNO
			nRecnoSA2	:=	(cAliasSFA)->SA2RECNO
			n2RecnoSB1	:=	(cAliasSFA)->SB12RECNO
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Quando houver baixa por devolucao, o codigo do cliente nao eh informado, devendo ser utilizado o codigo do proprio fornecedor³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If (cAliasSFA)->FA_MOTIVO=="4"
				n2RecnoSFT	:=	(cAliasSFA)->FTRECDEVOL
				nRecnoSD2	:=	(cAliasSFA)->D2RECDEVOL
				nRecnoSA1	:=	Nil
				nRecnoSA2	:=	(cAliasSFA)->A2RECDEVOL
				n2RecnoSB1	:=	(cAliasSFA)->B1RECDEVOL
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posicionando o SFT para utilizar algumas informacoes do documento ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (cAliasSFA)->FA_MOTIVO=="4"	//Quando houver baixa por devolucao, o codigo do cliente nao eh informado, devendo ser utilizado o codigo do proprio fornecedor
			lAchou2SFT	:=	SPEDSeek("SFT",,xFilial("SFT")+"S"+SF9->(F9_SERNFS+F9_DOCNFS+F9_FORNECE+F9_LOJAFOR),n2RecnoSFT)
		Else
			lAchou2SFT	:=	SPEDSeek("SFT",,xFilial("SFT")+"S"+SF9->(F9_SERNFS+F9_DOCNFS+F9_CLIENTE+F9_LOJACLI),n2RecnoSFT)
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posicionando a SA2/SA1 para utilizar algumas informacoes do documento.                      ³
		//|No caso de devolucao, devo considerar o fornecedor, pois a NF de saida foi emitida para ele.|
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lAchou2SFT .And. SFT->FT_TIPO$"DB"
			lAchouSA2	:=	SPEDSeek("SA2",,xFilial("SA2")+SF9->(F9_FORNECE+F9_LOJAFOR),nRecnoSA2)
		Else
			lAchouSA1	:=	SPEDSeek("SA1",,xFilial("SA1")+SF9->(F9_CLIENTE+F9_LOJACLI),nRecnoSA1)
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento para verificar se a despesa acessoria compoe a base  ³
		//³ de calculo do ICMS, pois o registro exige a informacao separada³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lAchou2SFT
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posicionando o SD1 para utilizar algumas informacoes do documento ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lAchouSD2 := SPEDSeek("SD2",2,xFilial("SD2")+SFT->(FT_NFISCAL+FT_SERIE+FT_CLIEFOR+FT_LOJA+FT_PRODUTO+FT_ITEM),nRecnoSD2)
		
		EndIf	
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posicionando a SA2 para utilizar algumas informacoes do documento ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lAchouSB1	:=	SPEDSeek("SB1",,xFilial("SB1")+SFT->FT_PRODUTO,n2RecnoSB1)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento para verificar o tipo de emissao do documento fiscal³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//Emissao Propria
		If !lAchou2SFT .Or. (lAchou2SFT .And. (Empty(SFT->FT_FORMUL) .Or. "S"$SFT->FT_FORMUL))
			cIndEmit := "0"			

		//Emissao de Terceiros			
		Else
			cIndEmit := "1"
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento para participante³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lAchou2SFT .And. SFT->FT_TIPO$"DB" .And. lAchouSA2
			aPartDoc :=	InfPartDoc ("SA2",,,,,,,lExtratTAF)
		ElseIf lAchouSA1
			aPartDoc :=	InfPartDoc ("SA1",,,,,,,lExtratTAF)
			
		Else
			aAdd(aPartDoc,"")
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Processando chamada do registro 0150/0175 para verificar o participante³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !lExtratTAF
			If !Empty(aPartDoc[1])
				SDPF150175(@aReg0150,aPartDoc,cAlias,aWizard,aAlIndic)
			EndIf
		EndIf				
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento para o produto posicionado na funcao principal³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lAchouSB1
			If !lExtratTAF
				cCodPro	:=	SB1->B1_COD+Iif(lConcFil,xFilial("SB1"),"")
				cSegUnid		:= SB1->B1_SEGUM
				nConvUnid		:= SB1->B1_CONV
				cTpUnid			:= SB1->B1_TIPCONV				
			Else
				cCodPro	:=	SB1->B1_COD
			EndIf
		Else
			cCodPro	:=	""
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Processando chamada do registro 0190/0200/0220 para verificar o produto³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(cCodPro)
		
			If !lExtratTAF
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Ponto de entrada para taratmento da informação de produtos quando o mesmo estah fora do padrao do sistema³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If aExistBloc[05] 
					aProd := Execblock("SPEDPROD", .F., .F., {"SFT","G140"})
					If Len(aProd)==11
						cCodPro	:= 	aProd[1]
						cUnid	:=	aProd[5]
					Else
						aProd := {"","","","","","","","","","",""}
					EndIf					
				EndIf
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Processamento do ponto de entrada para alteracao da unidade de medida caso exista³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If aExistBloc[01]
			  		aSpdFis02 := ExecBlock("SPDFIS02", .F., .F., {"SFT",SFT->FT_TIPOMOV,"G140"})
	
				   If ValType(aSpdFis02)=="A"
				      cUnid     := aSpdFis02[1]
				   Else   
					  cUnid     := ExecBlock("SPDFIS02", .F., .F., {"SFT",SFT->FT_TIPOMOV,"G140"})
				   EndIf
				EndIf
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Processando chamada do registro 0190/0200/0220 para verificar o produto³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Processando chamada do registro 0190/0200/0220 para verificar o produto³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				SFRG0200(cAlias,@aReg0200,@aReg0190,dDataDe,dDataAte,aProd,cCodPro,@aReg0220,,cUnid,,,,,,,,,{cSegUnid,nConvUnid,cTpUnid})
			EndIF							
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Montando array para retornar as informacoes, para notas fiscais de saida nao precisa do parametro, pois se a NF tem de existir no sistema.³
		//| Se tiver ocorrido esta venda em outro sistema, o processo teve suas fases completas no outro sistema, nao tem sentido estar aqui.        |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd(aInf, cIndEmit)
		aAdd(aInf, aPartDoc[1])
		aAdd(aInf, AModNot(SFT->FT_ESPECIE))
		aAdd(aInf, SF9->F9_SERNFS)
		aAdd(aInf, SF9->F9_DOCNFS)
		aAdd(aInf, SFT->FT_CHVNFE)
		aAdd(aInf, SF9->F9_DTEMINS)                                      	
		If SF9->(FieldPos("F9_ITEMNFS"))>0
			aAdd(aInf, AllTrim(Str(Val(SF9->F9_ITEMNFS))))
		Else
			aAdd(aInf, "1")
		EndIf
		aAdd(aInf, cCodPro)

	EndIf
EndIf

Return aInf
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³SDPF150175| Autor ³Gustavo G. Rueda              ³ Data ³03.03.2011³±±  
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ OLD => R150R175                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³REGISTRO 0150 - TABELA DE CADASTRO DE PARTICIPANTES                ³±±
±±³          ³REGISTRO 0175 - ALTERACAO DA TABELA DE CADASTRO DE PARTICIPANTE    ³±±
±±³          ³                                                                   ³±±
±±³          ³- Geracao e gravacao dos Registros                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ExpL1 := SDPF150175(aReg0150,aPartDoc,cAlias,aWizard)              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³aReg0150 -> Array com todas as informacoes do Cliente/Forne-       ³±±
±±³          ³ cedor para controle da rotina.                                    ³±±
±±³          ³aPartDoc -> Array com todas as informacoes do Cliente/Forne-       ³±±
±±³          ³ cedor.                                                            ³±±
±±³          ³cAlias   -> Alias do arquivo temporario base de geracao do TXT     ³±±
±±³          ³aWizard  -> Parametros informados no wizard da rotina              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nil                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Function SDPF150175(aReg0150,aPartDoc,cAlias,aWizard,aAlIndic) 
Local nPos 			:= 0 
Local nX 			:= 0 
Local lHistTab 		:= .F. 
Local dDataDe 		:= SToD (aWizard[1][1]) 
Local dDataAte 		:= SToD (aWizard[1][2]) 
Default aAlIndic 	:= {AliasIndic("AIF")}  

lHistTab := SuperGetMv("MV_HISTTAB",,.F.) .And. aAlIndic[01] // AliasIndic("AIF")

If Len(aPartDoc)>0 .And. aScan(aReg0150, {|aX| aX[2]==aPartDoc[1]})==0
	aAdd (aReg0150, {})
	nPos	:=	Len (aReg0150)
	aAdd (aReg0150[nPos], "0150")
	For nX := 1 to 12
		aAdd (aReg0150[nPos], aPartDoc[nX])
	Next
	GrvRegTrS (cAlias,aReg0150[nPos][2], {aReg0150[nPos]})

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO 0175 - ALTERACAO DA TABELA DE CADASTRO DE PARTICIPANTE³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lHistTab
		SPDFHistP(aPartDoc,dDataDe,dDataAte,cAlias)
	EndIf
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³SPDFHistP | Autor ³Gustavo G. Rueda              ³ Data ³03.03.2011³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ OLD => HistPrtDoc                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Gravacao do registro 0175, historico dos participantes             ³±±
±±³          ³                                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³HistPrtDoc(aPartDoc,dDataDe,dDataAte,cAlias)                       ³±±
±±³          ³                                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|aPartDoc -> Informacoes sobre os participantes                     ³±±
±±³          |dDataDe  -> Data inicial para utilizar os dados cadastrais do      ³±±
±±³          | periodo de processamento.                                         ³±±
±±³          |dDataAte -> Data final  para utilizar os dados cadastrais do       ³±±
±±³          | periodo de processamento.                                         ³±±
±±³          |cAlias   -> Alias do arquivo de trabalho base para geracao do TXT  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPDFHistP(aPartDoc,dDataDe,dDataAte,cAlias)
Local	aHist		:=	{}
Local	aReg0175 	:=	{}
Local	nCmp		:=	0
Local	nX			:=	0
Local	cAlsPart 	:= 	""
Local	cCmpCod	 	:=	""
Local	cCodPart 	:= 	""
Local	cLojPart 	:= 	""
Local	cNumCampo	:=	""
Local	cEnd 		:= 	""
Local	cNum 		:= 	""
Local	cCom 		:= 	""
Local	aNcampo		:=	{}


cAlsPart 	:= 	SubStr(aPartDoc[1],1,3)
cCmpCod	 	:=	Substr(cAlsPart,2,2)+"_COD"
cCodPart 	:= 	SubStr(aPartDoc[1],(len(cAlsPart) + len(FWCodFil()))+1,TamSx3(cCmpCod)[1])
cLojPart 	:= 	SubStr(aPartDoc[1],(len(cAlsPart) + len(FWCodFil()))+1+TamSx3(cCmpCod)[1],TamSx3("A1_LOJA")[1])     

aNcampo		:= {{"03","A1_NOME/A2_NOME/A4_NOME"},;
				{"04","A1_CODPAIS/A2_CODPAIS/A4_CODPAIS"},;
				{"05","A1_CGC/A2_CGC/A4_CGC"},;
				{"08","A1_COD_MUN/A2_COD_MUN/A4_COD_MUN"},;
				{"09","A1_SUFRAMA/A2_SUFRAMA/A4_SUFRAMA"},;
				{"10","A1_END/A2_END/A4_END"},;
				{"13","A1_BAIRRO/A2_BAIRRO/A4_BAIRRO"}}

aHist 	 := MsConHist(cAlsPart,cCodPart,cLojPart,dDataDe,dDataAte,,cCodPart)
For nX := 1 to len(aHist)
	If !Empty(aHist[nX][2]) .And. ( nCmp := ASCAN(aNcampo,{|x| Alltrim(aHist[nX][1])$x[2] }) ) > 0
	
		cNumCampo := ""
		
		If aNcampo[nCmp][1] == "05" .And. (Empty(aPartDoc[4]) .And. !Empty(aPartDoc[5]))
			//Verifica cpf x cnpj
			cNumCampo := "06"
		ElseIf aNcampo[nCmp][1] == "10"
			//Verifica end x num
			cEnd := FisGetEnd(aHist[nX][2],aPartDoc[13])[1]
			cNum := FisGetEnd(aHist[nX][2],aPartDoc[13])[3]
			cCom := FisGetEnd(aHist[nX][2],aPartDoc[13])[4]
		
			If !(Alltrim(aPartDoc[9]) == Alltrim(cEnd))
				SPDFR0175 (cAlias, aHist[nX][3], "10", cEnd, aPartDoc[1],aReg0175)
			EndIf
		
			If !(Alltrim(aPartDoc[10]) == Alltrim(cNum))
				SPDFR0175 (cAlias, aHist[nX][3], "11", cNum, aPartDoc[1],aReg0175)
			EndIf
		
			If !Empty(cCom) .And. !(Alltrim(aPartDoc[11]) == Alltrim(cCom))
				SPDFR0175 (cAlias, aHist[nX][3], "12", cCom, aPartDoc[1],aReg0175)
			EndIf
		ElseIf aNcampo[nCmp][1] == "08" .And. Len(Alltrim(aHist[nX][2]))<=5
			SPDFR0175 (cAlias, aHist[nX][3], "08", UfCodIBGE(aPartDoc[13])+AllTrim(aHist[nX][2]), aPartDoc[1],aReg0175)
		Else
			cNumCampo := aNcampo[nCmp][1]
		EndIf
		
		If !Empty(cNumCampo)
			SPDFR0175(cAlias,aHist[nX][3],cNumCampo,aHist[nX][2],aPartDoc[1],aReg0175)
		EndIf
		
	EndIf
Next
Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³SPDFR0175 | Autor ³Gustavo G. Rueda              ³ Data ³03.03.2011³±±  
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ OLD => Reg0175                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³REGISTRO 0175 - ALTERACAO DA TABELA DE CADASTRO DE PARTICIPANTE    ³±±
±±³          ³                                                                   ³±±
±±³          ³- Geracao e gravacao dos Registros                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias   -> Alias do arquivo temporario base de geracao do TXT     ³±±
±±³          ³dDtAlt -> Data de alteracao do campo                               ³±±
±±³          ³cNumCmp-> Numero do campo alterado                                 ³±±
±±³          ³cCont  -> Conteudo do campo                                        ³±±
±±³          ³cIdPart  -> Id do participante para criar o relacionamento de      ³±±
±±³          ³            registros                                              ³±±
±±³          ³aReg0175 -> Estrutura do registro 0175 a ser gravado               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³1(1 por arquivo)                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nil                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPDFR0175(cAlias,dDtAlt,cNumCmp,cCont,cIdPart,aReg0175)
Local	nPos	 	:=	0

If (nPos := aScan (aReg0175, {|aX| aX[2]==dDtAlt .And. aX[3]==cNumCmp }) ) == 0
	aAdd(aReg0175, {})
	nPos	:=	Len (aReg0175)
	aAdd (aReg0175[nPos], "0175")								//01 - REG
	aAdd (aReg0175[nPos], dDtAlt)								//02 - DT_ALT
	aAdd (aReg0175[nPos], cNumCmp)								//03 - NR_CAMPO
	aAdd (aReg0175[nPos], cCont)			  					//04 - CONT_ANT

	GrvRegTrS (cAlias,cIdPart,{aReg0175[nPos]})
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³SPDFTotSFI³ Autor ³ Vendas e CRM				   ³ Data ³ 30/Jan/13³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica todas as tributacoes que foram registradas nos campos    ³±±
±±³          ³ da tabela SFI ( Resumo da Reducao Z )                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - So p/ Ambiente TOP. P/ ambiente Nao TOP usar TotalizSFI ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPDFTotSFI( lISS, cAliqISS, cQryAlias, aCposAliq, lCodAliq )
Local cCampo	:= ""      	// Utilizada para armazenar o campo encotrad no SF3
Local aTotaliz	:= {}		// Array com o codigo e os valores dos totalizadores
Local cCodAliq	:= ""		// Codigo dos totalizadores das aliquotas
Local nCount	:= 0        // Contador
Local cCampoCod	:= ""      	// Utilizada para armazenar o campo referente ao código da aliquota( Utilizado para validação do PAF-ECF )
Local cValorCod	:= ""		// Armazena o valor da alíquota, utilizada no Menu Fiscal(Movimento por ECF-LOJXFUND) para o PAF-ECF	
Local nY 		:= 0
Local lTrataISS	:= .F.

DEFAULT lCodAliq:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existe um valor no totalizador de Cancelamento 		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (cQryAlias)->FI_CANCEL > 0
	aAdd(aTotaliz,{ "Can-T", (cQryAlias)->FI_CANCEL,""})
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existe um valor no totalizador de Desconto 	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (cQryAlias)->FI_DESC > 0
	aAdd(aTotaliz,{"DT", (cQryAlias)->FI_DESC,""})
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existe um valor no totalizador de Subistuicao Tributaria³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (cQryAlias)->FI_SUBTRIB > 0
	aAdd(aTotaliz,{"F1", (cQryAlias)->FI_SUBTRIB,""})
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existe um valor no totalizador de Isento                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (cQryAlias)->FI_ISENTO > 0
	aAdd(aTotaliz,{"I1",(cQryAlias)->FI_ISENTO,""})
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existe um valor no totalizador de Nao Tributado 		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (cQryAlias)->FI_NTRIB > 0
	aAdd(aTotaliz,{ "N1", (cQryAlias)->FI_NTRIB,""})
EndIf

//Verifica se está preparado para tratar as aliquotas de ISS que devem ser mostradas e tratadas separadamente
lTrataISS := (SFI->(FieldPos("FI_BIS0300") > 0 ) .OR. SFI->(FieldPos("FI_BIS0500") > 0 ) .OR. ;
SFI->(FieldPos("FI_BIS0700") > 0 ))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica a aliquota de ISS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
If !lTrataISS .AND. lISS .AND. (cQryAlias)->FI_ISS > 0  
	aAdd(aTotaliz,{ cAliqISS, (cQryAlias)->FI_ISS, "00"})
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Percorre todos os tipos de aliquotas existentes  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nY:=1 to Len(aCposAliq)
	cCampo 		:= aCposAliq[nY][1]
	cCampoCod 	:= aCposAliq[nY][2]
	cCodAliq 	:= aCposAliq[nY][3]
	
	If (cQryAlias)->(&cCampo) > 0
		nCount++
		
		If lCodAliq .AND. !Empty(cCampoCod)
		    cValorCod := (cQryAlias)->(&cCampoCod)
		Else             
			cValorCod := ""
		EndIf
	    
		aAdd(aTotaliz,{ cCodAliq , (cQryAlias)->(&cCampo),StrZero(nCount,2),cValorCod})
	Endif
Next nY

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso possua apenas uma aliquota de tributacao grava    ³
//³ "00" o campo referente ao numero do totalizador  	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nCount == 1 
	aTotaliz[Len(aTotaliz)][3] := "00"
ElseIf nCount > 1 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caso ter adicionado mais de uma aliquota Tributado ,deve  		³
	//³ordernar para que os registros filhos sejam gerados corretamentes³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aTotaliz  := Asort(aTotaliz,,,{|x,y|x[1]<y[1]})
EndIf	

Return(aTotaliz) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³SPDFCliCC ³ Autor ³ Vendas e CRM              ³ Data ³05/02/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera o Cadastro das Administradoras de Cartao para gravacao    ³±±
±±³          ³ do Registro 150                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ PARAM01 - Codigo do cartao na tabela SA1                       ³±±   
±±³          ³ PARAM02 - Filial onde foi feita a venda                        ³±±
±±³          ³ PARAM03 - Loja onde foi feita a venda                          ³±± 
±±³          ³ PARAM04 - Array com o Cadastro de Clientes para a gravacao     ³±± 
±±³          ³ do Registro 150						                          ³±±  
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - So p/ Ambiente TOP. P/ ambiente Nao TOP usar CriCliCC³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/	
Static Function SPDFCliCC(cCodCli,aReg0150,cAdmin,cAlias,aWizard,cAliasSA1,lConcFil) 

Local aDadCli  := {}          // Array para gravacao das Administradoras no Registro 150 
Local cCodReg  := ""          // Campo 02 Cod Reg partic.
Local cNome    := ""          // Nome da empresa ou participante  
Local cCodPais := "01058"     // Cod do Pais Valor fixo da tabela
Local cCNPJ    := ""          // CNPJ do cliente
Local cCPF     := ""          // CPF do cliente 
Local cUF      := ""          // Estado do Cliente
Local cIE      := ""          // Inscricao Estadual
Local cCodMuni := ""          // Codigo do Municipio
Local cCodSufr := ""          // Codigo de inscricao do participante na SuFrama  
Local cEnd     := ""          // Endereco  
Local cNum     := ""          // Numero   
Local cComple  := ""          // Complemento do endereco   
Local aEnderc  := {}          // Array para retorno do enderco e numero e complemento 
Local cBairro  := ""          // Bairro

Default cCodCli := ""

cCodReg  	:= 	"SA1" + Iif(lConcFil,cFilAnt,"") + AllTrim(cCodCli) + AllTrim((cAliasSA1)->A1_LOJA)
cNome    	:= 	If(AllTrim(cAdmin) <> "", cAdmin ,  (cAliasSA1)->A1_NOME )
cCNPJ    	:= 	(cAliasSA1)->A1_CGC
cUF      	:= 	(cAliasSA1)->A1_EST  
cIE      	:= 	SPEDVldIE((cAliasSA1)->A1_INSCR)
cCodMuni 	:= 	Iif (Upper((cAliasSA1)->A1_EST) == "EX","9999999",IIF(Len((cAliasSA1)->A1_COD_MUN) <= 5,UfCodIBGE((cAliasSA1)->A1_EST),"") + (cAliasSA1)->A1_COD_MUN)
cCodSufr 	:= 	(cAliasSA1)->A1_SUFRAMA  
aEnderc  	:= 	FisGetEnd((cAliasSA1)->A1_END,(cAliasSA1)->A1_EST)  //{cEnderec,nNumero,cNumero,cComplemen} 
cEnd     	:= 	aEnderc[1]
cNum     	:= 	str(aEnderc[2])
cComple  	:= 	aEnderc[4]  
cBairro  	:= 	(cAliasSA1)->A1_BAIRRO
aDadCli  	:= 	{cCodReg,cNome,cCodPais,cCNPJ,cCPF,cIE,cCodMuni,cCodSufr,cEnd,cNum,cComple,cBairro }  

SDPF150175(@aReg0150,aDadCli,cAlias,aWizard)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ SPDFGr1600 ³ Autor ³ Vendas e CRM              ³ Data ³05/02/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera os Dados do Cadastro das Administradoras de Cartao para     ³±±
±±³          ³ gravacao do Registro 150 e o Registro 1600                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ PARAM01 - Array com os Dados das Vendas dos Cartoes              ³±±
±±³          ³ PARAM02 - Array com o Cadastro de Clientes para a gravacao       ³±±
±±³          ³ do Registro 150						                            ³±±
±±³          ³ PARAM03 - Variavel data com a data inicial			            ³±±
±±³          ³ PARAM04 - Variavel data com a data final                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - So p/ Ambiente TOP. P/ ambiente Nao TOP usar GerDad1600³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPDFGr1600( aReg1600, aReg0150, dDataDe, dDataAte, cAlias, aWizard, lExtrat,lConcFil )
Local cQuery    := ""
Local cAliasTrb := GetNextAlias()
Local cCodADM   := ""      				 	// Cod da administradora
Local cDesADM   := ""       			 	// Descricao da administradora
Local nRat      := 0       				 	// Variavel auxiliar
Local nValCC    := 0        			 	// Valor do CC
Local nValCD    := 0       				 	// Valor do CD
Local cCodReg   := ""      				 	// Codigo cartao
Local nCodSAE   := TamSx3("AE_COD")[1]
Local nL4ADMINIS:= TamSx3("L4_ADMINIS")[1]
Local aDadCart  := {}                    	// Dados dos cartoes
Local nI        := 0                     	// Tamanho do array para adicinar os itens
Local nCount    := 0
Local cRede     := ""                    	// Nome da Administradora da rede de Cartoes
Local nPosRede  := 0                     	// Posicao da Administradora da Rede
Local aCampos   := {}                    	// Array para criar os campo p/ tabela temporaria
Local cSL4      := ""                    	// Campo para Verificar se houve troca do registro
Local cArqTrab1 := ""                    	// Variavel auxiliar para criacao de tabela temporaria
Local cTipoDB	:= AllTrim(Upper(TcGetDb()))// Tipo do banco de dados

Default lExtrat	:= .F.
DEFAULT lConcFil	:= .T.
cQuery := "SELECT TABSL4.L4_FILIAL,TABSL4.L4_ADMINIS,TABSL4.L4_FORMA,TABSL4.VALOR, SA1.A1_COD AS CODADM, "
If cTipoDB $ "ORACLE|DB2"
	cQuery += "SUBSTR(TABSL4.L4_ADMINIS,"+AllTrim(Str(nCodSAE+3))+","+AllTrim(Str(nL4ADMINIS-(nCodSAE+3)+1))+") AS DESCADM, "
ElseIf cTipoDB == "INFORMIX"
	cQuery += "TABSL4.L4_ADMINIS["+AllTrim(Str(nCodSAE+3))+","+AllTrim(Str(nL4ADMINIS))+"] DESCADM, "
Else
	cQuery += "SUBSTRING(TABSL4.L4_ADMINIS,"+AllTrim(Str(nCodSAE+3))+","+AllTrim(Str(nL4ADMINIS))+") AS DESCADM, "
EndIf
cQuery += " SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_CGC, SA1.A1_EST, SA1.A1_INSCR, SA1.A1_COD_MUN, SA1.A1_SUFRAMA, "
cQuery += " SA1.A1_END, SA1.A1_BAIRRO, AE_REDE, X5_DESCRI "
cQuery += " FROM ( SELECT SL4.L4_FILIAL, SL4.L4_ADMINIS, SL4.L4_FORMA, SUM(L4_VALOR) AS VALOR "
cQuery += "          FROM " + RetSQLName("SL4") + " SL4, " + RetSQLName("SL1") + " SL1 "
cQuery += "         WHERE SL4.L4_FILIAL = SL1.L1_FILIAL "
cQuery += "           AND SL1.L1_FILIAL = '"+xFilial("SL1")+"'"
cQuery += "           AND SL4.L4_NUM 	= SL1.L1_NUM "
cQuery += "           AND SL1.L1_EMISNF >= '" + DToS (dDataDe) + "'" 
cQuery += "           AND SL1.L1_EMISNF <= '" + DToS (dDataAte) + "'"
cQuery += "           AND SL1.L1_PDV <> ' '"
cQuery += "           AND SL1.L1_DOC <> ' '"
cQuery += "           AND (SL1.L1_CARTAO > 0 OR SL1.L1_VLRDEBI > 0 ) "
cQuery += "           AND (SL4.L4_FORMA = 'CC' OR SL4.L4_FORMA = 'CD' )"
cQuery += "           AND SL4.D_E_L_E_T_ = ' '"
cQuery += "           AND SL1.D_E_L_E_T_ = ' '"
cQuery += "	   	 GROUP BY SL4.L4_FILIAL,SL4.L4_ADMINIS,SL4.L4_FORMA ) TABSL4 "
cQuery += " LEFT JOIN "+RetSQLName("SA1")+" SA1 ON (SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND SA1.A1_LOJA = '01' "
If cTipoDB $ "ORACLE|DB2"
	cQuery += " AND SUBSTR(TABSL4.L4_ADMINIS,1,3) = RTrim(SA1.A1_COD) "
ElseIf cTipoDB == "INFORMIX"
	cQuery += " AND TABSL4.L4_ADMINIS[1,3] = SA1.A1_COD "
Else
	cQuery += " AND SUBSTRING(TABSL4.L4_ADMINIS,1,3) = SA1.A1_COD "
EndIf
cQuery += "  AND SA1.D_E_L_E_T_ = ' ' )"
cQuery += " LEFT JOIN "+RetSQLName("SAE")+" SAE ON (SAE.AE_FILIAL = '"+xFilial("SAE")+"' AND RTrim(SA1.A1_COD) = SAE.AE_COD AND SAE.D_E_L_E_T_ = ' ' )"
cQuery += " LEFT JOIN "+RetSQLName("SX5")+" SX5 ON (SX5.X5_FILIAL = '"+xFilial("SX5")+"' AND X5_TABELA = 'L9' AND RTrim(SAE.AE_REDE) = RTrim(SX5.X5_CHAVE) AND SX5.D_E_L_E_T_ = ' ' )"
cQuery := ChangeQuery( cQuery )
DbUseArea( .T., 'TOPCONN', TcGenQry(,,cQuery), cAliasTrb, .T., .F. )

While !(cAliasTrb)->( Eof() )
	cCodADM := AllTrim((cAliasTrb)->CODADM)
	cDesADM := (cAliasTrb)->DESCADM
	cCodReg := "SA1" + Iif(lConcFil,cFilAnt,"") + cCodADM + "01"
	nValCC  := If( AllTrim( (cAliasTrb)->L4_FORMA ) == "CC",(cAliasTrb)->VALOR, 0 )
	nValCD  := If( AllTrim( (cAliasTrb)->L4_FORMA ) == "CD",(cAliasTrb)->VALOR, 0 )
	
	If (nPosRede := aScan(aReg1600, { |x| x[6] == (cAliasTrb)->AE_REDE }) ) == 0
    	cRede := (cAliasTrb)->X5_DESCRI
	    If Empty(cRede)
	       cRede := cDesADM
	    EndIf
	    Aadd(aReg1600, {} )
		nI := Len(aReg1600)
		AAdd(aReg1600[nI], (cAliasTrb)->L4_FILIAL  )   	// Filial
		AAdd(aReg1600[nI], cCodReg 			       )   	// CodAdm
		AAdd(aReg1600[nI], cRede				   )   	// Descicao da Administradora
		AAdd(aReg1600[nI], nValCC				   )   	// Valor de CC
		AAdd(aReg1600[nI], nValCD				   )   	// Valor do CD
		AAdd(aReg1600[nI], (cAliasTrb)->AE_REDE	   )   	// Rede dos Cartoes
		AAdd(aReg1600[nI], cCodADM				   )   	// Rede dos Cartoes
		
		If !lExtrat
			//Cadastro das Administradoras de Cartao para gravacao do Registro 150
			SPDFCliCC(cCodADM,@aReg0150,cRede,cAlias,aWizard,cAliasTrb,lConcFil)
	    EndIf
	Else
    	aReg1600[nPosRede][5] += nValCD
		aReg1600[nPosRede][4] += nValCC
	EndIf
	
	(cAliasTrb)->(DbSkip() )
End

(cAliasTrb)->(DbCloseArea() )

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³SPDFRgC425³ Autor ³ Vendas e CRM             ³ Data ³ 31/01/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua a carga dos dados dos registros C425                   ³±±
±±³          ³ REGISTRO C425 - RESUMO DE ITENS DO MOVIMENTO DIARIO           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - So p/ Ambiente TOP. P/ ambiente Nao TOP usar RegC425³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/		
Function SPDFRgC425(	aRegC425 	, sDtMovim	, cPdv		, aLinhaPai	,;
						aWizard 	, nQuantD 	, cConfFil 	, cQryAlias ,;
						cSitTriAnt	, nPosPai )
						
Local nPos			:= 0     				// Posicao atual
Local cProd			:= ""
Local aProd			:= {}
	
cProd := (cQryAlias)->FT_PRODUTO+cConfFil
If aExistBloc[05]
	aProd := Execblock("SPEDPROD", .F., .F., {cQryAlias,"C425"})
	If Len(aProd)==11
		cProd 	:= 	aProd[1]
	Else
		aProd := {"","","","","","","","","","",""}
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Preenchimento do registro 425    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aRegC425, {})        
nPos :=	Len(aRegC425)

aAdd (aRegC425[nPos], aLinhaPai[nPosPai][1]			) 	//00 - POSICAO DO REG. PAI
aAdd (aRegC425[nPos], "C425"						) 	//01 - REG
aAdd (aRegC425[nPos], cProd							) 	//02 - COD_ITEM
aAdd (aRegC425[nPos], {(cQryAlias)->FT_QUANT , nQuantD}	) 	//03 - QTD
aAdd (aRegC425[nPos], (cQryAlias)->B1_UM				)  	//04 - UNID
aAdd (aRegC425[nPos], (cQryAlias)->FT_VALCONT			)	//05 - VL_ITEM  	
If "1"$aWizard[1][15]
	aAdd (aRegC425[nPos], (cQryAlias)->FT_VALPIS		)  	//06 - VL_PIS
	aAdd (aRegC425[nPos], (cQryAlias)->FT_VALCOF		) 	//07 - VL_COFINS
Else
	aAdd (aRegC425[nPos], 0							)  	//06 - VL_PIS
	aAdd (aRegC425[nPos], 0							) 	//07 - VL_COFINS
EndIf
	
Return































































































































































































































































































































































































































/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o   ³SPDFC460470³ Autor ³ Vendas e CRM                ³ Data ³31/01/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua a carga dos dados dos registros C460 e C470               ³±±
±±³          ³ REGISTRO C460 - DOCUMENTO FISCAL EMITIDO POR ECF                 ³±±
±±³          ³ REGISTRO C470 - ITENS DO DOCUMENTO FISCAL EMITIDO POR ECF        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - So p/ Ambiente TOP. P/ ambiente Nao TOP usar RegC460470³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/		
Function SPDFC460470( 	aRegC460, aRegC470	, dDtMovim	, cPdv		,;
						aProdB1	, nLinhaPai	, aReg0200	, lCstPis	,;
						lCstCof	, aWizard 	, nQuantD 	, cQryAlias ,;
						cFilSB1	, cFilSA1 	, lCancSft 	, nPosC460	,;
						cNfC460 , aItensC470, nPosC470	, lConcFil	,;
						cConfFil, aInfPart	, cCpfCNPJ	, cChvCliAnt )

Local lRet 		:= .T.
Local aClasFis	:= {"","","",""}
Local cSituaDoc	:= ""
Local nQtCanc  	:= 0
Local nAliqSft	:= 0
Local nBCIcms	:= 0
Local cSitTrib	:= ""

If cNfC460 <> (cQryAlias)->FT_NFISCAL
	cNfC460 	:= (cQryAlias)->FT_NFISCAL
	aItensC470 	:= {}

	If cChvCliAnt <> cFilSA1 + (cQryAlias)->FT_CLIEFOR + (cQryAlias)->FT_LOJA
		
		cChvCliAnt := cFilSA1 + (cQryAlias)->FT_CLIEFOR + (cQryAlias)->FT_LOJA
		
		If SA1->(DbSeek(cChvCliAnt))
			aInfPart := InfPartDoc("SA1")
		Else
			aInfPart  := {"","","","",""}
		EndIf
		
	EndIf
//
//
//
//
//
	If !Empty( (cQryAlias)->L1_CGCCLI )
		cCpfCNPJ := (cQryAlias)->L1_CGCCLI
	Else
		cCpfCNPJ := IIf( Empty(aInfPart[4]), aInfPart[5], aInfPart[4] )
	EndIf

	
	
	
	
	
	
	
	
	
	
	

	//------------------------------
	//Preenchimento do registro 460
	//------------------------------
	cSituaDoc := SPEDSitDoc(Nil,cQryAlias,Nil,Nil,Nil,Nil,Nil,Nil,Nil,cQryAlias)
	

	aAdd(aRegC460, {})
	nPosC460++
	
	aAdd (aRegC460[nPosC460], nLinhaPai		 				)	 	   	//01 - RELACIONAMENT0 COM REGISTRO PAI
	aAdd (aRegC460[nPosC460], "C460"		 				)	 	   	//02 - REG
	aAdd (aRegC460[nPosC460], "2D"		 					)	 	   	//03 - COD_MOD
	aAdd (aRegC460[nPosC460], cSituaDoc						)	 	   	//04 - COD_SIT
	aAdd (aRegC460[nPosC460], (cQryAlias)->FT_NFISCAL		)	 		//05 - NUM_DOC
	If !lCancSft
		aAdd (aRegC460[nPosC460], (cQryAlias)->FT_EMISSAO		)	 	//06 - DT_DOC
		aAdd (aRegC460[nPosC460], (cQryAlias)->FT_VALCONT		) 	 	//07 - VL_DOC
		aAdd (aRegC460[nPosC460], (cQryAlias)->FT_VALPIS 		)	 	//08 - VL_PIS
		aAdd (aRegC460[nPosC460], (cQryAlias)->FT_VALCOF		)	 	//09 - VL_COFINS
		aAdd (aRegC460[nPosC460], cCpfCNPJ						)	   	//10 - CPF_CNPJ
		aAdd (aRegC460[nPosC460], aInfPart[2]					)	   	//11 - NOM_ADQ
	Else
		aAdd (aRegC460[nPosC460], ""  	)	 	   	//06 - DT_DOC
		aAdd (aRegC460[nPosC460], ""	) 	     	//07 - VL_DOC
		aAdd (aRegC460[nPosC460], ""	)	 	   	//08 - VL_PIS
		aAdd (aRegC460[nPosC460], ""	)	 	   	//09 - VL_COFINS
		aAdd (aRegC460[nPosC460], ""	)	 	   	//10 - CPF_CNPJ
		aAdd (aRegC460[nPosC460], ""  	)	 	   	//11 - NOM_ADQ
	EndIf
Else
	aRegC460[nPosC460][7] += (cQryAlias)->FT_VALCONT	//05 - VL_DOC // THIAGO
	If "1"$aWizard[1][15]
		aRegC460[nPosC460][8] += (cQryAlias)->FT_VALPIS	//06 - VL_PIS // THIAGO
		aRegC460[nPosC460][9] += (cQryAlias)->FT_VALCOF	//07 - VL_COFINS // THIAGO
	EndIf
EndIf

nQtCanc  := (cQryAlias)->LX_QTDCANC

cSitTrib :=	(cQryAlias)->D2_SITTRIB
If ("T" $ cSitTrib)
	If Len(cSitTrib) > 4
		nAliqSft := Val(SubStr(cSitTrib,2,2)+"."+SubStr(cSitTrib,4,Len(cSitTrib)))
	Else
		nAliqSft := Val(SubStr(cSitTrib,2,Len(cSitTrib)))
	EndIf
	nBCIcms	 := (cQryAlias)->FT_VALCONT
ElseIf ("S" $ cSitTrib)
	nAliqSft := 0
	nBCIcms	 :=	0
Else
	nAliqSft := (cQryAlias)->FT_ALIQICM
	nBCIcms	 :=	(cQryAlias)->FT_BASEICM
EndIf

If !lCancSft
	
	
	
	
	
	
	
	
	
	aClasFis[1] := (cQryAlias)->FT_CLASFIS
	
	//------------------------------
	//Preenchimento do registro 470
	//------------------------------
	SPDFRgC470( @aRegC470			, (cQryAlias)->FT_PRODUTO	, (cQryAlias)->FT_QUANT		, (cQryAlias)->FT_VALCONT	,;
			 	(cQryAlias)->FT_CFOP, nAliqSft					, (cQryAlias)->FT_VALPIS	, (cQryAlias)->FT_VALCOF 	,;
			 	aClasFis[1]			, nQtCanc					, @aProdB1					, nPosC460		 			,;
			 	cFilSB1				, (cQryAlias)->B1_UM		, aWizard 					, nQuantD 					,;
			 	@aItensC470 		, @nPosC470					, cQryAlias					, lConcFil					,;
			 	cConfFil )

EndIf

Return lRet
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³SPDFRgC470³ Autor ³ Vendas e CRM             ³ Data ³ 31/01/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua a carga dos dados dos registros C470                   ³±±
±±³          ³ REGISTRO C470 - ITENS DO DOCUMENTO FISCAL EMITIDO POR ECF     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - So p/ Ambiente TOP. P/ ambiente Nao TOP usar RegC470³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/		
Function SPDFRgC470(aRegC470	, cProduto	, nQUANT	, nValCont	,;
					cCFOP		, nALIQICM	, nVALPIS	, nVALCOF	,; 
					cCST		, nQtCanc	, aProdB1	, nLinhaPai	,;
					cFilSB1		, cProdUN   , aWizard 	, nQuantD	,;
					aItensC470 	, nPosC470  , cQryAlias	, lConcFil	,;
					cConfFil )
						
Local lRet 		:= .T.   
Local nPosAux	:= 0
Local cProd		:= cProduto+cConfFil
Local aProd		:= {}

If aExistBloc[05]
	aProd := Execblock("SPEDPROD", .F., .F., {cQryAlias,"C470"})
	If Len(aProd)==11
		cProd 	:= 	aProd[1]
	Else
		aProd := {"","","","","","","","","","",""}
	EndIf
EndIf

nPosAux := Ascan(aItensC470, {|x| x[1] == cProd .AND. x[2] == cCST})

If nPosAux == 0
	
	nPosC470++
	aAdd(aItensC470, { cProd, cCST, nPosC470 })
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Preenchimento do registro C470 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	aAdd(aRegC470, {})        
	aAdd (aRegC470[nPosC470], nLinhaPai		       		)		//00 - RELACIONAMENTO COM REGISTRO PAI
	aAdd (aRegC470[nPosC470], "C470"			       	)	 	//01 - REG
	aAdd (aRegC470[nPosC470], cProd				   		)	 	//02 - COD_ITEM
	aAdd (aRegC470[nPosC470], {nQUANT+nQtCanc , nQuantD})	 	//03 - QTD
	aAdd (aRegC470[nPosC470], nQtCanc	           		)	 	//04 - QTD_CANC
	aAdd (aRegC470[nPosC470], cProdUN		       		)		//05 - UNID
	aAdd (aRegC470[nPosC470], nValCont  		       	)	 	//06 - VL_ITEM
	aAdd (aRegC470[nPosC470], cCST			       		)	 	//07 - CST_ITEM
	aAdd (aRegC470[nPosC470], cCFOP			       		)	 	//08 - CFOP
	aAdd (aRegC470[nPosC470], nALIQICM		       		)	   	//09 - ALIQ_ICMS
	
	If "1"$aWizard[1][15]
		aAdd (aRegC470[nPosC470], nVALPIS				)	   	//10 - VL_PIS
		aAdd (aRegC470[nPosC470], nVALCOF				)	    //11 - VL_COFINS
	Else
		aAdd (aRegC470[nPosC470], 0						)	   	//10 - VL_PIS
		aAdd (aRegC470[nPosC470], 0						)	    //11 - VL_COFINS
	EndIf
Else
	nPosAux := aItensC470[nPosAux][3]
	
	aRegC470[nPosAux][4][1] += nQUANT			   				//03 - QTD
	aRegC470[nPosAux][7]  	+= nValCont		 	   				//06 - VL_ITEM
	aRegC470[nPosAux][5]  	+= nQtCanc			 		   		//04 - QTD_CANC
	
	If "1"$aWizard[1][15]
		aRegC470[nPosAux][11] 	+= nVALPIS						//10 - VL_PIS
		aRegC470[nPosAux][12] 	+= nVALCOF						//11 - VL_COFINS
	EndIf
EndIf

Return(lRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³SPDFRgC490³ Autor ³ Vendas e CRM             ³ Data ³ 31/01/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua a carga dos dados dos registros C490                   ³±±
±±³          ³ REGISTRO C490 - REGISTRO ANALITICO DO MOVIMENTO DIARIO        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - So p/ Ambiente TOP. P/ ambiente Nao TOP usar RegC490³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPDFRgC490(	aRegC490	, sDtMovim	, nLinhaPai	, lCstPis	,;
				 		lCstCof		, cPdv		, aProdB1	, nPos405	,;
				 		aReg0200	, aReg0190	, aReg0220	, nValCof	,;
				 		nValPis )

Local aAuxReg   	:= {}
Local nPos490 		:= 0
Local nPosAux   	:= 0
Local nPosAuxReg   	:= 0
Local aClasFis		:= {"","","",""}
Local nBCIcms		:= 0
Local nAliqSFT  	:= 0
Local nValIcm		:= 0
Local cSitTrib 		:= ""
Local cTemp1     	:= GetNextAlias()

BeginSql alias cTemp1
	SELECT 	SUM(FT_VALICM) FT_VALICM, SUM(FT_VALCONT) FT_VALCONT, SUM(FT_VALPIS) FT_VALPIS, SUM(FT_VALCOF) FT_VALCOF,
			SUM(FT_BASEICM) FT_BASEICM, FT_CLASFIS, FT_CFOP, FT_ALIQICM, D2_SITTRIB, FT_CTIPI, FT_CSTPIS, FT_CSTCOF, FT_TIPO
	FROM %table:SFT% SFT, %table:SD2% SD2 
	WHERE   SFT.FT_FILIAL 	= %xfilial:SFT%  		AND
			SD2.D2_FILIAL 	= %xfilial:SD2%  		AND
			SFT.FT_TIPOMOV 	= 'S'   				AND
			SFT.FT_ENTRADA 	= %exp:sDtMovim%  		AND
			SFT.FT_PDV 		= %exp:cPdv%			AND 
			SFT.FT_ESPECIE 	= 'CF'					AND
			SFT.FT_DTCANC 	= ' '					AND
			SFT.FT_PDV 		= SD2.D2_PDV     		AND 
			SFT.FT_NFISCAL 	= SD2.D2_DOC        	AND
			SFT.FT_SERIE 	= SD2.D2_SERIE			AND	
			SFT.FT_ITEM 	= SD2.D2_ITEM			AND
			SFT.%notDel% 							AND
			SD2.%notDel%
		GROUP BY FT_CLASFIS,FT_CFOP,FT_ALIQICM,D2_SITTRIB,FT_CTIPI,FT_CSTPIS,FT_CSTCOF,FT_TIPO
		ORDER BY FT_CFOP,FT_CLASFIS,FT_ALIQICM
EndSql

nPos490 := Len(aRegC490)

While !(cTemp1)->(Eof ())
	cSitTrib := (cTemp1)->D2_SITTRIB
	If ("T" $ cSitTrib)
		If Len(cSitTrib) > 4
			nAliqSft := Val(SubStr(cSitTrib,2,2)+"."+SubStr(cSitTrib,4,Len(cSitTrib)))
		Else
			nAliqSft := Val(SubStr(cSitTrib,2,Len(cSitTrib)))
		EndIf
		nBCIcms	 := (cTemp1)->FT_VALCONT
		nValIcm	 := (cTemp1)->FT_VALICM
	ElseIf ("S" $ cSitTrib)
		nAliqSft := 0
		nBCIcms	 :=	0
		nValIcm	 := 0
	Else
		nAliqSft := (cTemp1)->FT_ALIQICM
		nBCIcms	 :=	(cTemp1)->FT_BASEICM
		nValIcm	 := (cTemp1)->FT_VALICM
	EndIf
	
	//aClasFis := SPDRetCCST (cTemp1,.F.,lCstPis,lCstCof)
	aClasFis[1] := (cTemp1)->FT_CLASFIS
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Guarda os valores de PIS e Confins para 490 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nValCof += (cTemp1)->FT_VALCOF
	nValPis += (cTemp1)->FT_VALPIS
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Foi criado o array aAuxReg para que nao seja necessario dar o Ascan o array aReg490, ³
	//³ pois estava ocasionando uma lentidao no sistema pelo tamanho. 						³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    nPosAux := Ascan(aAuxReg, {|x| x[1] == nPos405 .AND. x[3] == aClasFis[1] .AND.  x[4] == (cTemp1)->FT_CFOP .AND. x[5] == nAliqSft })
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Preenchimento do registro C490 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If nPosAux == 0
		aAdd(aRegC490, {})
		nPos490++
		aAdd (aRegC490[nPos490], nPos405		 		)	//00 - RELACIONAMENTO COM O REGISTRO PAI
		aAdd (aRegC490[nPos490], "C490"		 			) 	//01 - REG
		aAdd (aRegC490[nPos490], aClasFis[1]			)	//02 - CST_ITEM
		aAdd (aRegC490[nPos490], (cTemp1)->FT_CFOP		)	//03 - CFOP
		aAdd (aRegC490[nPos490], nAliqSft				)	//04 - ALIQ_ICMS
		aAdd (aRegC490[nPos490], (cTemp1)->FT_VALCONT	)	//05 - VL_OPR
		aAdd (aRegC490[nPos490], nBCIcms				)	//06 - VL_BC_ICMS
		aAdd (aRegC490[nPos490], nValIcm				)	//07 - VL_ICMS
		aAdd (aRegC490[nPos490], ""						)	//08 - COD_OBS
		
		aAdd(aAuxReg, {})
		nPosAuxReg++
		aAdd (aAuxReg[nPosAuxReg], nPos405		 		) 	//01 - RELACIONAMENTO COM O REGISTRO PAI
		aAdd (aAuxReg[nPosAuxReg], "C490"		 	   	) 	//02 - REG
		aAdd (aAuxReg[nPosAuxReg], aClasFis[1]			)  	//03 - CST_ITEM
		aAdd (aAuxReg[nPosAuxReg], (cTemp1)->FT_CFOP	)  	//04 - CFOP
		aAdd (aAuxReg[nPosAuxReg], nAliqSft				)  	//05 - ALIQ_ICMS
		aAdd (aAuxReg[nPosAuxReg], nPos490				)  	//06 - Posicao do ARegC490
	Else
		nPos490 := aAuxReg[nPosAux][6]
		aRegC490[nPos490][6] += (cTemp1)->FT_VALCONT		//05 - VL_OPR
		If !("S" $ cSitTrib)
			aRegC490[nPos490][7] += nBCIcms					//06 - VL_BC_ICMS
			aRegC490[nPos490][8] += (cTemp1)->FT_VALICM 	//07 - VL_ICMS
		EndIf
	EndIf
	
	(cTemp1)->(dbSkip())
End

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³SPDFLj0200³ Autor ³ Vendas e CRM                 ³ Data ³05/02/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao utilizada para carregar Registros 0200 separadamente, com  ³±±
±±³          ³ objetivo de melhora de performance na execucao da rotina.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL (Funcao apenas p/ Ambiente TOP)              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPDFLj0200( cAlias, dDataDe, dDataAte, aReg0200, aReg0190, aReg0220, nQtReg0200, cFilSB1, lConcFil, cReg )
Local cQryAlias 	:= GetNextAlias() //Alias da Query
Local cQryFields 	:= ""
Local lVerif0200 	:= nQtReg0200 <> Len(aReg0200) //Variavel para indicar se deve verificar se ja existe o produto no array "aReg0200" antes de adiciona-lo
Local cMVDTINCB1	:= AllTrim(GetNewPar("MV_DTINCB1","B1_DATREF"))
Local aSetField   	:= {} //Campos da query para efetuar conversao "TcSetField"
Local nY 			:= 0
Local aProd			:= {}
Local cProd			:= ""
Local cConfFil 		:= ""

DEFAULT lConcFil	:= .T.
DEFAULT cReg  		:= "C470"

cConfFil 	:= Iif(lConcFil,cFilSB1,"")

cMVDTINCB1 := If( Left(cMVDTINCB1,1)=="'" .Or. Left(cMVDTINCB1,1)=='"' , &(cMVDTINCB1) , cMVDTINCB1 )

//------------------------------------------
//CAMPOS DA TABELA SB1 PARA MONTAR A QUERY
//------------------------------------------
cQryFields	:=	"SB1.B1_COD,		SB1.B1_DESC,		SB1.B1_VLR_PIS,		SB1.B1_VLR_COF,		SB1.B1_TNATREC,	"
cQryFields	+=  "SB1.B1_CNATREC, 	SB1.B1_GRPNATR, 	SB1.B1_DTFIMNT,		SB1.B1_TIPO,		SB1.B1_CODBAR,	"
cQryFields	+=  "SB1.B1_CODANT, 	SB1.B1_UM, 			SB1.B1_POSIPI,		SB1.B1_EX_NCM,		SB1.B1_CODISS,	"
cQryFields	+=  "SB1.B1_PICM, 		SB1.B1_FECP, 		SB1.B1_DATREF,		SB1.B1_TIPCONV, 	SB1.B1_SEGUM "

If !Empty(cMVDTINCB1) .And. cMVDTINCB1 <> "B1_DATREF" .And. !(cMVDTINCB1 $ cQryFields)
	cQryFields	+=  ",SB1."+cMVDTINCB1                 		
	aAdd( aSetField, { cMVDTINCB1, "D" , 8, 0 } )
EndIf

cQryFields	:=	"%"+cQryFields+"%" 

BeginSql Alias cQryAlias
	
		COLUMN B1_DATREF 	AS DATE
	
	SELECT DISTINCT 
		%Exp:cQryFields% 
	FROM 
		%Table:SB1% SB1,%table:SFT% SFT 
	WHERE
		SB1.B1_FILIAL = %xFilial:SB1% 		 	AND 
		SFT.FT_FILIAL = %xFilial:SFT% 		 	AND 
		SFT.FT_TIPOMOV = 'S' 					AND 
		SFT.FT_ENTRADA >= %Exp:DToS(dDataDe)% 	AND 
		SFT.FT_ENTRADA <= %Exp:DToS(dDataAte)% 	AND 
		SFT.FT_ESPECIE = 'CF' 					AND 
		SB1.B1_COD = SFT.FT_PRODUTO				AND 
		SFT.FT_DTCANC = ' ' 					AND 
		SB1.%NotDel%  		                    AND 
		SFT.%NotDel% 

EndSql

For nY := 1 To Len(aSetField)
	TcSetField(cQryAlias,aSetField[nY,1],aSetField[nY,2],aSetField[nY,3],aSetField[nY,4])
Next

While !(cQryAlias)->(Eof())
	cProd	:= (cQryAlias)->B1_COD + cConfFil
	If aExistBloc[05]
		aProd := Execblock("SPEDPROD", .F., .F., {cQryAlias,cReg})
		If Len(aProd)==11
			cProd 	:= 	aProd[1]
		Else
			aProd := {"","","","","","","","","","",""}
		EndIf
	EndIf	
	If lVerif0200
		If AScan(aReg0200, {|aX| aX[2]==cProd}) == 0
			SFRG0200(cAlias, @aReg0200, @aReg0190, dDataDe, dDataAte, ,cProd, @aReg0220, cQryAlias)
		EndIf
	Else
		SFRG0200(cAlias, @aReg0200, @aReg0190, dDataDe, dDataAte, ,cProd , @aReg0220, cQryAlias)
	EndIf
	(cQryAlias)->(DbSkip())
End

(cQryAlias)->(dbCloseArea())

nQtReg0200 := Len(aReg0200)

Return     
              

//-------------------------------------------------------------------------------
/*/{Protheus.doc} SPDBarkThr                      
--
Autor: Demetrio Fontes De Los Rios - Data: 04/2013
--
Descrição:  Funcao Bark - "casca" da thread. Ela quem fica num "listen" aguardando 
o IpcGo para chamar a funcao passada via parametro.
--
Parametros: 		cSemaphore		-> Identificacao do Semaforo
					cFunction       -> Nome da funcao que o iPCGo ira executar
					cEmp / cFil		-> Empresa/Filial para subida da thread
					cNomeTRB     	-> Nome da tabela temporaria
					cAlias          -> Alias nomeado da tabela temp
					cNThread        -> Identificao da Thread   
@version 1.0                                                            
//------------------------------------------------------------------------------- */
Function SPDBarkThr( cSemaphore, cFunction, cEmp, cFil, cNomeTRB, cAlias, cNThread )

Local uParm1, uParm2,uParm3, uParm4, uParm5, uParm6, uParm7,  uParm8, uParm9,;
	  uParm10, uParm11, uParm12, uParm13, uParm14, uParm15, uParm16, uParm17    
Local nTimeOut := 	0 

// Prepara/Abre Ambiente 
RpcSetType(3)
RpcSetEnv(cEmp,cFil)   

nTimeOut := 	SuperGetMv("MV_SPDCTTO",,190000000) // Parametro que define TimeOut da Bark -> DEFAULT 190000000 = 52HORAS    

// Abre tabela do banco           
dbUseArea( .T. ,__cRdd , cNomeTRB , cAlias , .T. , .F. )
(cAlias)->( dbClearIndex() , dbSetIndex(cNomeTRB + '_01' ) )
          
// ---------------------------------
// LISTEN - AGUARDANDO COMANDO GO
While !KillApp()
	PtInternal( 1 , 'Thread( ' + cNThread + ' ) - SPEDC )' )	// Imprime no monitor Identificacao da Thread
	If IPCWaitEx( cSemaphore, nTimeOut 	, 	@uParm1,;
									   		@uParm2,;
									  		@uParm3,;
											@uParm4,;
											@uParm5,;
											@uParm6,;
											@uParm7,;
											@uParm8,;
											@uParm9,;
											@uParm10,;
											@uParm11,;
											@uParm12,;
											@uParm13,;
											@uParm14,;
											@uParm15,;
											@uParm16,;
											@uParm17 )
										                      
		// -------------------------------------------
		// Comando EXIT 
		If ValType(uParm1) == "C" .And. uParm1 == "_E_X_I_T_"
			(cAlias)->(dbCloseArea())
			Exit
		EndIF           
		
		// ----------------------
		// Função a ser executada
		&cFunction.(uParm1,;
					uParm2,;
					uParm3,;
					uParm4,;
					uParm5,;
					uParm6,;
					uParm7,;
					uParm8,;
					uParm9,;
					uParm10,;
					uParm11,;
					uParm12,;
					uParm13,;
					uParm14,;
					uParm15,;
					uParm16,;
					uParm17)
	Else                         
		// --------------------
		// Abandona por TimeOut
		(cAlias)->(dbCloseArea())
		ConOut("_E_X_I_T_!!! -> " + Time() )
	  	Exit
	EndIf
End

Return

//-------------------------------------------------------------------------------
/*/{Protheus.doc} PCDelTmpDB                      
--
Autor: Demetrio Fontes De Los Rios - Data: 04/2013
--
Descrição:  Funcao responsavel por excluir tabela temporaria do banco
--
Parametros: 		cTempDB	   -> Nome da tabela temporaria 
					lMsg       -> Logico - se exibe mensagem ou não  
@version 1.0                                                            
//------------------------------------------------------------------------------- */
Function PCDelTmpDB( cTempDB , lMsg  )
Local	lRet		:=	.T.
Local	lOk			:=	.T.
Local	cMsgTempDB	:=	''

Default	lMsg	:=	.T. 

//Verifico se a tabela existe no RDBMS	
If TcCanOpen( cTempDB )
	
	cMsgTempDB	:=	"O SPED Contribuições desse período já foi gerada em um outro momento " //STR0123	//'A apuração deste período para este tributo já foi gerada em um outro momento, ' 
	cMsgTempDB	+=	"as informações já estão carregadas em tabelas temporárias." //STR0124	//'os valores já estão calculados conforme o movimento da ocasião. '
	cMsgTempDB	+=	"Deseja refazer a extração? " + CRLF + CRLF
	cMsgTempDB	+=	"Ao selecionar não, o sistema ira buscar as informações novamente, caso escolha SIM apenas irá gerar o arquivo magnético. "	//'Ao selecionar "Não", as informações a serem apresentadas serão com base no movimento já calculado!'	
	If lMsg	//Tratamento para tornar a mensagem opcional
		lOk	:=	MsgYesNo( cMsgTempDB , "Atenção" )	//'Atenção'
	EndIf
		
	If lOk
		If !TcDelFile( cTempDB )		//Caso exista, apago do RDBMS
			cMsgNotDel	:=	"Erro ao excluir " + ' ( ' + cTempDB + ' ).' + CRLF + CRLF	//'Problema ao excluir TEMPDB 
			cMsgNotDel	+=	TcSqlError() + CRLF + CRLF
			cMsgNotDel	+=	"A tabela em questão está presa por alguma thread de processamento pelo TOP CONNECT, entrar em contato com o Administrador do sistema." + CRLF + CRLF	//'A tabela em questão está presa por alguma thread de processamento pelo TOP CONNECT, entrar em contato com o Administrador do sistema.' 
			cMsgNotDel	+=	"As informações serão geradas com base nos dados já extraídos."	//'As informações a serem apresentadas serão com base no movimento já calculado!'
			ApMsgAlert( cMsgNotDel )
			
			lRet	:=	.F.			
		EndIf
	Else
		lRet	:=	.F.
	EndIf
EndIf

Return lRet                 

//-------------------------------------------------------------------------------
/*/{Protheus.doc} PCCriaTab                      
--
Autor: Demetrio Fontes De Los Rios - Data: 04/2013
--
Descrição:  Funcao responsavel em ciar e/ou abrir a tabela temporaria no banco 

Parametros: 		cArq		-> Nome do arquivo
					cAlsTem     -> Alias da tabela temporaria
					aCampos  	-> Array contendo estrutura/campos da tabela temporaria
					xIndice     -> Indice da Temp DB
					lOnlyOpen	-> Logico - Define se ira criar ou apenas abrir a TempDB
@version 1.0                                                            
//------------------------------------------------------------------------------- */
Function PCCriaTab( cArq , cAlsTemp, aCampos , xIndice, lOnlyOpen ) 

Local nCont			:= 0       
Local lRet 			:= .T. 
                                     
Default cArq		:= ""                       
Default xIndice 	:= ""    
Default lOnlyOpen	:= .F. 
                                                               	
If !lOnlyOpen
	//Cria a tabela no RDBMS com a estrutura definida acima
	dbCreate( cArq , aCampos , __cRdd )
	dbUseArea( .T. ,__cRdd , cArq , cAlsTemp , .T. , .F. )
	    
	//Funcao que define e retorna indices da tabela temporaria no RDBMS                                                     
	If ValType(xIndice)=="A" 
		For nCont:=1 to Len(xIndice)
			dbCreateIndex ( cArq + '_'+StrZero(nCont,2) , xIndice[nCont] )			
		Next nCont 	   
		(cAlsTemp)->( dbClearIndex() , dbSetIndex(cArq + '_01' ) ) 
		(cAlsTemp)->( dbCloseArea() )
	Else 
		dbCreateIndex ( cArq + '_01' , xIndice )
	   //	(cAlsTemp )->( dbCloseArea() )
	EndIf          		                              
Else  
	dbUseArea( .T. ,__cRdd , cArq , cAlsTemp , .T. , .F. ) 
EndIf 

Return lRet        


//-------------------------------------------------------------------------------
/*/{Protheus.doc} MThdGrvTRB                      
--
Autor: Demetrio Fontes De Los Rios - Data: 04/2013
--
Descrição: Funcao responsavel descarregar as informacoes dos arrays na tabela temporaria 
--
Parametros: 		cEmpProc	-> Empresa processando SPED
					cFilProc    -> Filial processando SPED   
					cAlias      -> Alias da tabela temporaria
					cArq        -> Arquivo / Tabela temporaria
					aRegFilho   -> Array contendo informacoes dos registros filho
					aRegPai  	-> Array contendo informacoes dos registros pai
					lCtItem     -> Logico. Conta item
					nFlag       -> Flag
					nPai        -> Identificacao do Array pai
					lRegPaiDup  -> Logico. Gera informacoes do pai 
					nPos400     -> Posicao do pai C400
					aRegC405    -> Array com as informacoes C405
					nCtC405     -> Contador Registro C405
					aRegC481    -> Array contendo informacoes do item de PIS
					aRegC485    -> Array contendo informacoes do item de COFINS
					_nRecno     -> Numero do Recno
					cJobFile    -> Nome do arquivo para controle da Thread
					cJobAux     -> Utilizado para controle de thread
@version 1.0                                                            
//------------------------------------------------------------------------------- */
Function MThdGrvTRB(cEmpProc,cFilProc,cAlias,cArq,aRegFilho,aRegPai,lCtdtem,nFlag,nPai,lRegPaiDup,nPos400,aRegC405,nCt405,aRegC481,aRegC485,_nRecno,cJobFile,cJobAux)
                            
Local	nHd1		:= 0    
Local 	nCtd		:= 1
Local 	aReg		:= {}  
Local 	nX			:= 0
Local 	nZ			:= 0   

Private n_COMMIT	:= 0                                                                
Private cNomeTRB 	:= ""   
Private n_SPCRecno	:= 0     
Private lProcMThr	:= .T.

Default nPos400		:= 0  
Default aRegPai		:= Nil    
Default lRegPaiDup	:= .F. 
Default cJobAux		:=	cJobFile

// Criacao do arquivo de controle de jobs
nHd1 := MSFCreate( cJobAux )

// STATUS 1 - Iniciando execucao do Job
PutGlbValue( cJobAux , "1" )
GlbUnLock()
				                
// nome da tabeçp                                                    
cNomeTRB 	:= cArq       
n_SPCRecno	:= _nRecno

// STATUS 2 - Iniciando a gravacao
PutGlbValue( cJobAux , "2" )
GlbUnLock()
                                                                  
// Especifico para registros do Loja     
If nPos400>0       
                                           
//	Conout("Descarregando ... ")           
	PCGrvReg ( cAlias , nPos400 , aRegC405 , nCt405 , , nPai  , , .T. )  
	PCGrvReg ( cAlias , nPos400 , aRegC481 , nCt405 , , nPai  , , .T. )  
	PCGrvReg ( cAlias , nPos400 , aRegC485 , nCt405 , , nPai  , , .T. ) 
	
// Generico 
ElseIf nPos400==0 .AND. ValType( aRegPai )<>"U" 
      
//	Conout("Descarregando ... ")
	For nZ := 1 To Len (aRegPai)         
		If !lRegPaiDup		
			PCGrvReg (cAlias, nZ, {aRegPai[nZ]}, ,nFlag,nPai  )
			
			// STATUS 3 - Gravacao Registro PAI
			PutGlbValue( cJobAux , "3" )
			GlbUnLock()
		Endif                                                                  
		
		If Len(aRegFilho)>=1  .AND. nCtd <= Len(aRegFilho)
			Do While nCtd<=Len (aRegFilho) .And. (aRegFilho[nCtd][1]==nZ)   
               
				// STATUS 4 - Gravacao Registro FILHO
				PutGlbValue( cJobAux , "4" )
				GlbUnLock()
			
				aReg	:=	{}				
	
				For nX := 2 To Len (aRegFilho[nCtd])
					aAdd (aReg, aRegFilho[nCtd][nX])
				Next (nX)
	             
				PCGrvReg (cAlias, Iif(lCtdtem,nZ,aRegPai[nZ,1]) , {aReg}, Iif(lCtdtem,nCtd,aRegFilho[nCtd][1]), nFlag,nPai )  

				nCtd++
			EndDo
		EndIf     			
	Next (nZ)
		
EndIF              

//Forco ultimo Commit
TcSQLExec( 'COMMIT' )  
n_COMMIT := 0

// STATUS 5 - Gravacao concluida
PutGlbValue( cJobAux , "5" )
GlbUnLock()

If FClose( nHd1 )
	If FErase( cJobAux ) == -1
		// STATUS 6 - Problema ao excluir o semaforo
		PutGlbValue( cJobAux , "6" )
		GlbUnLock()
	EndIf
Else
	// STATUS 6 - Problema ao fechar o semaforo
	PutGlbValue( cJobAux , "6" )
	GlbUnLock()
EndIf

Return 


//-------------------------------------------------------------------
/*/{Protheus.doc} SFPCL
Função para geração dos registros 1300, 1310, 1320, 1350, 1360 e 1370
referente as informações de PCL -Postos de Combustivel e Lubrificante,
onde as informações e valores são extraídos de um template do módulo
SIGALOJA, e serão extraídos através da função T_TpPcSped localizado
no fonte TPLPCLFUNCS.prw 

@param  aReg1300  - Array com valores do registro 1300
		aReg1310  - Array com valores do registro 1310
		aReg1320  - Array com valores do registro 1320				
		aReg1350  - Array com valores do registro 1350		
		aReg1360  - Array com valores do registro 1360		
		aReg1370  - Array com valores do registro 1370		
		aReg0190  - Array com valores do registro 0190		
		aReg0200  - Array com valores do registro 0200		
		aReg0220  - Array com valores do registro 0220		
		cAlias    - Alias do arquivo temporário
		dDataDe   - Data inicial do processamento
		dDataAte  - Data Final do Processamento												
		
@return cCodCred - Retorna Codigo do Tipo de Credito
			
@author Erick G Dias
@since 28/10/2013
@version 11.80
/*/
//-------------------------------------------------------------------
Function SPEDPCL(aReg1300,		aReg1310,		aReg1320,		aReg1350,		aReg1360,;
				 aReg1370,		aReg0190,		aReg0200,		aReg0220,		cAlias ,;
				 dDataDe,		dDataAte)

Local aRetPCL	:= {}
Local nX1300	:= 0
Local nX1310	:= 0
Local nX1320	:= 0
Local nX1350	:= 0
Local nX1360	:= 0
Local nX1370	:= 0
Local nPos1300	:= 0
Local nPos1310	:= 0
Local nPos1350	:= 0

If Type("oProcess")=="O"
	oProcess:Inc2Progress("Buscando Informações de PCL","Processando" )//"Processando" //Produto
EndIF

aRetPCL:= T_TpPcSped(dDataDe,dDataAte)

/*
Posições do array retornardo através da função T_TpPcSped
aRetPCL[2] - Retorno das informações do registro 1300
aRetPCL[3] - Retorno das informações do registro 1310
aRetPCL[4] - Retorno das informações do registro 1320
aRetPCL[5] - Retorno das informações do registro 1350
aRetPCL[6] - Retorno das informações do registro 1360
aRetPCL[7] - Retorno das informações do registro 1370
*/

If Type("oProcess")=="O"
	oProcess:Set1Progress(len(aRetPCL[1]))
	oProcess:Set2Progress(1)
EndIF


If Len(aRetPCL) >= 6
	
	//Percorre array para gerar registro 1300
	For nX1300:= 1 to Len(aRetPCL[1])
		
		If Type("oProcess")=="O"
			oProcess:Inc2Progress("Registros PCL","Produto:" +aRetPCL[1][nX1300][2] + "Data de Fechamento:" + aRetPCL[1][nX1300][3]  )//"Processando" //Produto		
			//Controle do cancelamento da rotina
			If oProcess:Cancel()
				lCancel:=.T.
				Exit
			EndIf
		EndIF		
		
		nPos1300:= Reg1300 (@aReg1300,aRetPCL[1][nX1300],@aReg0200,@aReg0190,@aReg0220,dDataDe,dDataAte,cAlias)
		
		//Percorre array para gerar registro 1310 filhos do registro 1300
		For nX1310 :=1 to Len(aRetPCL[2])
			//Verifica se a primeira posição do array filho é igual ao número corrente do registro pai.
			If aRetPCL[2][nX1310][1] == nX1300
				nPos1310:=Reg1310(@aReg1310,aRetPCL[2][nX1310],nPos1300)

				//Percorre array para gerar registro 1320
				For nX1320 :=1 to Len(aRetPCL[3])
					//Verifica se a primeira posição do array filho é igual ao número corrente do registro pai.
					If aRetPCL[3][nX1320][1] == nX1310
						Reg1320(@aReg1320,aRetPCL[3][nX1320],nPos1310)
					EndIF
					
				Next nX1320			

			EndIF
	
		Next nX1310		
	
	Next nX1300
	
	//Percorre array para gerar registro 1350
	For nX1350:= 1 to Len(aRetPCL[4])
		nPos1350:= Reg1350 (@aReg1350,aRetPCL[4][nX1350])
		
		//Percorre array para gerar registro 1360
		For nX1360	:= 1 to Len(aRetPCL[5])
			If aRetPCL[5][nX1360][1] == nX1350
				Reg1360 (@aReg1360,aRetPCL[5][nX1360] , nPos1350)
			EndIF
		Next nX1360
		
		//Percorre array para gerar registro 1370
		For nX1370	:= 1 to Len(aRetPCL[6])
			If aRetPCL[6][nX1370][1] == nX1350
				Reg1370(@aReg1370,aRetPCL[6][nX1370],nPos1350,@aReg0200,@aReg0190,@aReg0220,dDataDe,dDataAte,cAlias)				
			EndIF
		Next nX1370		
	
	Next nX1350	

EndIF

Return 

//-------------------------------------------------------------------
/*/{Protheus.doc} Reg1300
Função para geração do registro 1300

@param  aReg1300  - Array com informações do registro 1300
		aPCL1300  - Array com informações do registro 1300 gerado na função do LOJA
		aReg0200  - Array com valores do registro 0200
		aReg0190  - Array com valores do registro 0190
		aReg0220  - Array com valores do registro 0220
		dDataDe   - Data inicial do processamento
		dDataAte  - Data Final do Processamento
		cAlias    - Alias do arquivo temporário
		
@return nPos 	  - Posição do registro 1300 gerado
			
@author Erick G Dias
@since 28/10/2013
@version 11.80
/*/
//-------------------------------------------------------------------
Static Function Reg1300 (aReg1300,aPCL1300,aReg0200,aReg0190,aReg0220,dDataDe,dDataAte,cAlias)
Local nPos		:= 0
Local cProduto	:= ""

cProduto:= aPCL1300[2]+cFilAnt
If AScan(aReg0200, {|aX| aX[2]==cProduto}) == 0
	SFRG0200(cAlias, @aReg0200, @aReg0190, dDataDe, dDataAte, ,cProduto , @aReg0220)
EndIf

nPos := Ascan(aReg1300,{|aX|aX[2] == cProduto .AND. aX[3] == aPCL1300[3]})

If nPos == 0

	aAdd(aReg1300, {})
	nPos	:=	Len (aReg1300)
	aAdd (aReg1300[nPos], "1300")	 	 	  	//01 - REG
	aAdd (aReg1300[nPos], cProduto)	 		 	//02 - COD_ITEM
	aAdd (aReg1300[nPos], aPCL1300[3])	 	 	//03 - DT_FECH
	aAdd (aReg1300[nPos], {aPCL1300[4],3})	 	//04 - ESTQ)ABERT
	aAdd (aReg1300[nPos], {aPCL1300[5],3})	  	//05 - VOL_ENTR
	aAdd (aReg1300[nPos], {aPCL1300[6],3})	  	//06 - VOL_DISP
	aAdd (aReg1300[nPos], {aPCL1300[7],3})	  	//07 - VOL_SAIDAS
	aAdd (aReg1300[nPos], {aPCL1300[8],3})	  	//08 - ESTQ_ESCR
	aAdd (aReg1300[nPos], {aPCL1300[9],3})	  	//09 - VAL_AJ_PERDA
	aAdd (aReg1300[nPos], {aPCL1300[10],3}) 	//10 - VAL_AJ_GANHO
	aAdd (aReg1300[nPos], {aPCL1300[11],3}) 	//11 - FECH_FISICO
Else
	aReg1300[npos][4][1]	+=	aPCL1300[4]		//04 - ESTQ)ABERT
	aReg1300[npos][5][1]	+=	aPCL1300[5]		//05 - VOL_ENTR
	aReg1300[npos][6][1]	+=	aPCL1300[6]		//06 - VOL_DISP
	aReg1300[npos][7][1]	+=	aPCL1300[7]		//07 - VOL_SAIDAS
	aReg1300[npos][8][1]	+=	aPCL1300[8]		//08 - ESTQ_ESCR
	aReg1300[npos][9][1]	+=	aPCL1300[9]		//09 - VAL_AJ_PERDA
	aReg1300[npos][10][1]	+=	aPCL1300[10]	//10 - VAL_AJ_GANHO
	aReg1300[npos][11][1]	+=	aPCL1300[11]	//11 - FECH_FISICO		
EndIF

Return nPos

//-------------------------------------------------------------------
/*/{Protheus.doc} Reg1310
Função para geração do registro 1310

@param  aReg1310  - Array com informações do registro 1310
		aPCL1310  - Array com informações do registro 1310 gerado pelo Loja
		nPos1300  - Posição do registro pai 1300
		
@return nPos	 - Posição do registro 1310 gerado
			
@author Erick G Dias
@since 28/10/2013
@version 11.80
/*/
//-------------------------------------------------------------------
Static Function Reg1310(aReg1310,aPCL1310,nPos1300)

Local nPos	:= 0

nPos := Ascan(aReg1310,{|aX|aX[1] == nPos1300 .AND. aX[3] == aPCL1310[3] })

If nPos == 0
	aAdd(aReg1310, {})
	nPos	:=	Len (aReg1310)
	aAdd (aReg1310[nPos], nPos1300)	 	 	  		//01 - Relação com registro pai
	aAdd (aReg1310[nPos], "1310")	 	 	  		//01 - REG
	aAdd (aReg1310[nPos], aPCL1310[3])	 	 	  	//02 - NUM_TANQUE
	aAdd (aReg1310[nPos], {aPCL1310[4],3})	 	 	//03 - ESTQ_ABERT
	aAdd (aReg1310[nPos], {aPCL1310[5],3})	 	 	//04 - VOL_ENTR
	aAdd (aReg1310[nPos], {aPCL1310[6],3})	 	 	//05 - VOL_DISP
	aAdd (aReg1310[nPos], {aPCL1310[7],3})	 	 	//06 - VOL_SAIDAS
	aAdd (aReg1310[nPos], {aPCL1310[8],3})	 	 	//07 - ESTQ_ESCR
	aAdd (aReg1310[nPos], {aPCL1310[9],3})	 	 	//08 - VAL_AJ_PERDA
	aAdd (aReg1310[nPos], {aPCL1310[10],3})	 	 	//09 - VAL_AJ_GANHO
	aAdd (aReg1310[nPos], {aPCL1310[11],3})	 	//10 - FECH_FISICO
Else
	areg1310[npos][4][1]	+=	aPCL1310[4]		//03 - ESTQ_ABERT
	areg1310[npos][5][1]	+=	aPCL1310[5]		//04 - VOL_ENTR
	areg1310[npos][6][1]	+=	aPCL1310[6]		//05 - VOL_DISP
	areg1310[npos][7][1]	+=	aPCL1310[7]		//06 - VOL_SAIDAS
	areg1310[npos][8][1]	+=	aPCL1310[8]		//07 - ESTQ_ESCR
	areg1310[npos][9][1]	+=	aPCL1310[9]		//08 - VAL_AJ_PERDA
	areg1310[npos][10][1]  	+=	aPCL1310[10]		//09 - VAL_AJ_GANHO			
	areg1310[npos][11][1] 	+=	aPCL1310[11]		//10 - FECH_FISICO
EndIF


//

Return nPos

//-------------------------------------------------------------------
/*/{Protheus.doc} Reg1320
Função para geração do registro 1320

@param  aReg1320  - Array com informações do registro 1320
		aPCL1320  - Array com informações do registro 1320 gerado pelo Loja
		nPos1310  - Posição do registro pai 1310
		
@return 
			
@author Erick G Dias
@since 28/10/2013
@version 11.80
/*/
//-------------------------------------------------------------------
Static Function Reg1320(aReg1320,aPCL1320,nPos1310)

Local nPos		:= 0
Local cNrInterv	:= Iif(aPCL1320[4] == Nil,"",Str(aPCL1320[4]))

nPos := Ascan(aReg1320,{|aX|aX[1] == nPos1310 .AND. aX[3] == aPCL1320[3] .AND. aX[4] == cNrInterv .AND. aX[5] == aPCL1320[5];
								 .AND. aX[6] == aPCL1320[6] .AND. aX[7] == aPCL1320[7] .AND. aX[8] == cCpfaPCL1320[8] })

If nPos == 0

	aAdd(aReg1320, {})
	nPos	:=	Len (aReg1320)
	aAdd (aReg1320[nPos], nPos1310)	 	 	  		//01 - Relação com registro pai
	aAdd (aReg1320[nPos], "1320")	 	 	  		//01 - REG
	aAdd (aReg1320[nPos], aPCL1320[3]) 	  			//02 - NUM_BICO
	aAdd (aReg1320[nPos], cNrInterv)				//03 - NR_INTERV 
	aAdd (aReg1320[nPos], aPCL1320[5])	 	 		//04 - MOT_INTERV
	aAdd (aReg1320[nPos], aPCL1320[6])	 	 		//05 - NOM_INTERV
	aAdd (aReg1320[nPos], aPCL1320[7]) 		        //06 - CNPJ_INTERV
	aAdd (aReg1320[nPos], aPCL1320[8]) 			    //07 - CPF_INTERV	
	aAdd (aReg1320[nPos], {aPCL1320[9],3})	 	 	//08 - VAL_FECHA   
	aAdd (aReg1320[nPos], {aPCL1320[10],3})	 	//09 - VAL_ABERTNHO
	aAdd (aReg1320[nPos], {aPCL1320[11],3})	 	//10 - VOL_VENDASO
	aAdd (aReg1320[nPos], {aPCL1320[12],3})	 	//11 - VOL_VENDAS
Else
	aReg1320[npos][9][1]	+=	aPCL1320[9]	    	//08 - VAL_FECHA 
	aReg1320[npos][10][1] 	+=	aPCL1320[10]		//09 - VAL_ABERTNHO
	aReg1320[npos][11][1]	+=	aPCL1320[11]		//10 - VOL_VENDASO	
	aReg1320[npos][12][1]	+=	aPCL1320[12]		//11 - VOL_VENDAS
EndIF

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} Reg1350
Função para geração do registro 1350

@param  aReg1350  - Array com informações do registro 1350
		aPCL1350  - Array com informações do registro 1350 gerado pelo Loja		
		
@return nPos	 - Posição do registro 1350 gerado
			
@author Erick G Dias
@since 28/10/2013
@version 11.80
/*/
//-------------------------------------------------------------------
Static Function Reg1350(aReg1350,aPCL1350)

Local nPos	:= 0

nPos := Ascan(aReg1350,{|aX|aX[2] == aPCL1350[2] .AND. aX[3] == aPCL1350[3] .AND. aX[4]== aPCL1350[4] .AND. aX[5]== aPCL1350[5]})

If nPos == 0
	aAdd(aReg1350, {})
	nPos	:=	Len (aReg1350)
	aAdd (aReg1350[nPos], "1350")	  	  		//01 - REG
	aAdd (aReg1350[nPos], aPCL1350[2])	 	  	//02 - SERIE   
	aAdd (aReg1350[nPos], aPCL1350[3])	 	 	//03 - FABRICANTE
	aAdd (aReg1350[nPos], aPCL1350[4])	 	 	//04 - MODELO    
	aAdd (aReg1350[nPos], aPCL1350[5])	 	 	//05 - TIPO_MEDICAO
EndIF

Return nPos

//-------------------------------------------------------------------
/*/{Protheus.doc} Reg1360
Função para geração do registro 1360

@param  aReg1360  - Array com informações do registro 1360
		aPCL1360  - Array com informações do registro 1360 gerado pelo Loja		
		nPos1350  - Posição do registro pai 1350
		
@return nPos	 - Posição do registro 1360 gerado
			
@author Erick G Dias
@since 28/10/2013
@version 11.80
/*/
//-------------------------------------------------------------------
Static Function Reg1360(aReg1360,aPCL1360,nPos1350)

Local nPos	:= 0

nPos := Ascan(aReg1360,{|aX|aX[1] == nPos1350 .AND. aX[3] == aPCL1360[3] .AND. aX[4] == aPCL1360[4]})
If nPos == 0
	aAdd(aReg1360, {})
	nPos	:=	Len (aReg1360)
	aAdd (aReg1360[nPos], nPos1350)	  	  		//Relação com registro Pai
	aAdd (aReg1360[nPos], "1360")	  	  		//01 - REG
	aAdd (aReg1360[nPos], aPCL1360[3])	  		//02 - NUM_LACRE
	aAdd (aReg1360[nPos], aPCL1360[4])	 	  	//03 - DT_APLICACAO
EndIF

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} Reg1370
Função para geração do registro 1370

@param  aReg1370  - Array com informações do registro 1370
		aPCL1370  - Array com informações do registro 1370 gerado pelo Loja		
		nPos1350  - Posição do registro pai 1350
		aReg0200  - Posição do registro pai 1350
		aReg0190  - Array com informações do registro 0200
		aReg0220  - Posição do registro pai 0220
		dDataDe   - data inicial da geração do arquivo
		dDataAte  - Data Final da geração do arquivo
		cAlias    - Alias da tabela temporária

		
@return 
			
@author Erick G Dias
@since 28/10/2013
@version 11.80
/*/
//-------------------------------------------------------------------
Static Function Reg1370(aReg1370,aPCL1370,nPos1350,aReg0200,aReg0190,aReg0220,dDataDe,dDataAte,cAlias)

Local nPos		:= 0
Local cProduto	:= ""

cProduto:= aPCL1370[4]+cFilAnt
If AScan(aReg0200, {|aX| aX[2]==cProduto}) == 0
	SFRG0200(cAlias, @aReg0200, @aReg0190, dDataDe, dDataAte, ,cProduto , @aReg0220)
EndIf

nPos := Ascan(aReg1370,{|aX|aX[1] == nPos1350 .AND. aX[3] == aPCL1370[3] .AND. aX[4] == cProduto .AND.aX[5] == aPCL1370[5]})
If nPos == 0
	aAdd(aReg1370, {})
	nPos	:=	Len (aReg1370)
	aAdd (aReg1370[nPos], nPos1350)	  	  		//Relação com registro Pai
	aAdd (aReg1370[nPos], "1370")	  	  		//01 - REG      
	aAdd (aReg1370[nPos], aPCL1370[3])	 	  	//02 - NUM_BICO    
	aAdd (aReg1370[nPos], cProduto)	 		  	//03 - COD_ITEM
	aAdd (aReg1370[nPos], aPCL1370[5])	 	  	//04 - NUM_TANQUE
EndIF

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} RegI100
Função que irá gerar registro I100

@param  aRegI100  - Array com informações do registro I100
		 aDado  	- Array com informações que irá gerar I100.		
		 nI010  	- Posição do registro pai I010
			
@return Posição do registro I100 no array

@author Erick G Dias
@since 23/12/2013
@version 11.80
/*/
//-------------------------------------------------------------------
Static Function RegI100(aRegI100, aDado, nI010)

Local nPos	:= 0

nPos :=AScan(aRegI100, {|aX| aX[1]==nI010 .AND. aX[4]==aDado[3] .AND. aX[8]==aDado[7] .AND. aX[11]==aDado[10] .AND. aX[13]==aDado[12]})
//nPos :=AScan(aRegI100, {|aX| aX[3]==aDado[3] .AND. aX[7]==aDado[7] .AND. aX[10]==aDado[10] .AND. aX[12]==aDado[12]})

If nPos == 0
	aAdd(aRegI100, {})
	nPos	:=	Len (aRegI100)
	aAdd (aRegI100[nPos], nI010)  	  		//Relação com registro Pai registro I010
	aAdd (aRegI100[nPos], "I100")	  		//01 - REG      
	aAdd (aRegI100[nPos], aDado[2])	 	  	//02 - VL_REC   
	aAdd (aRegI100[nPos], aDado[3])		  	//03 - CST_PIS_COFINS
	aAdd (aRegI100[nPos], aDado[4])	 	  	//04 - VL_TOT_DED_GER
	aAdd (aRegI100[nPos], aDado[5])	 	  	//05 - VL_TOT_DED_ESP
	aAdd (aRegI100[nPos], aDado[6])	 	  	//06 - VL_BC_PIS
	aAdd (aRegI100[nPos], aDado[7])	 	  	//07 - ALIQ_PIS
	aAdd (aRegI100[nPos], aDado[8])	 	  	//08 - VL_PIS
	aAdd (aRegI100[nPos], aDado[9])	 	  	//09 - VL_BC_COFINS
	aAdd (aRegI100[nPos], aDado[10])	 	//10 - ALIQ_COFINS
	aAdd (aRegI100[nPos], aDado[11])	 	//11 - VL_COFINS
	aAdd (aRegI100[nPos], aDado[12])	 	//12 - INFO_COMPL
Else
	aRegI100[nPos][3] += aDado[2]			//02 - VL_REC
	aRegI100[nPos][5] += aDado[4]			//04 - VL_TOT_DED_GER
	aRegI100[nPos][6] += aDado[5]			//05 - VL_TOT_DED_ESP
	aRegI100[nPos][7] += aDado[6]			//06 - VL_BC_PIS
	aRegI100[nPos][9]  += aDado[8]			//08 - VL_PIS 
	aRegI100[nPos][10] += aDado[9]			//09 - VL_BC_COFINS	
	aRegI100[nPos][12] += aDado[11]			//11 - VL_COFINS
EndIF

Return nPos

//-------------------------------------------------------------------
/*/{Protheus.doc} RegI200
Função que irá gerar registro I200

@param  aRegI200  - Array com informações do registro I200
		  aDado  	- Array com informações que irá gerar I200.		
		  nI100  	- Posição do registro pai I100
			
@return Posição do registro I200 no array

@author Erick G Dias
@since 23/12/2013
@version 11.80
/*/
//-------------------------------------------------------------------
Static Function RegI200(aRegI200, aDado, nI100)

Local nPos	:= 0

nPos :=AScan(aRegI200, {|aX| aX[1]==nI100 .AND. aX[3]==aDado[2] .AND. aX[4]==aDado[3] .AND. aX[6]==aDado[5] .AND. aX[7]==aDado[6]})

If nPos == 0
	aAdd(aRegI200, {})
	nPos	:=	Len (aRegI200)
	aAdd (aRegI200[nPos], nI100)  	  		//Relação com registro Pai registro I100
	aAdd (aRegI200[nPos], "I200")	  		//01 - REG      
	aAdd (aRegI200[nPos], aDado[2])	 	  	//02 - NUM_CAMPO   
	aAdd (aRegI200[nPos], aDado[3])		  	//03 - COD_DET
	aAdd (aRegI200[nPos], aDado[4])	 	  	//04 - DET_VALOR
	aAdd (aRegI200[nPos], aDado[5])	 	  	//05 - COD_CTA
	aAdd (aRegI200[nPos], aDado[6])	 	  	//06 - INFO_COMPL	
Else
	aRegI200[nPos][5] += aDado[4]			//04 - DET_VALOR
EndIF

Return nPos

//-------------------------------------------------------------------
/*/{Protheus.doc} RegI300
Função que irá gerar registro I300

@param  aRegI300  - Array com informações do registro I300
		  aDado  	- Array com informações que irá gerar I300.		
		  nI100  	- Posição do registro pai I200
			
@return Posição do registro I300 no array

@author Erick G Dias
@since 23/12/2013
@version 11.80
/*/
//-------------------------------------------------------------------
Static Function RegI300(aRegI300, aDado, nI200)

Local nPos	:= 0

nPos :=AScan(aRegI300, {|aX| aX[1]==nI200 .AND. aX[3]==aDado[2] .AND. aX[5]==aDado[4] .AND. aX[6]==aDado[5] })

If nPos == 0
	aAdd(aRegI300, {})
	nPos	:=	Len (aRegI300)
	aAdd (aRegI300[nPos], nI200)  	  		//Relação com registro Pai registro I200
	aAdd (aRegI300[nPos], "I300")	  		//01 - REG      
	aAdd (aRegI300[nPos], aDado[2])	 	  	//02 - COD_COMP   
	aAdd (aRegI300[nPos], aDado[3])		  	//03 - DET_VALOR
	aAdd (aRegI300[nPos], aDado[4])	 	  	//04 - COD_CTA
	aAdd (aRegI300[nPos], aDado[5])	 	  	//05 - INFO_COMPL	
Else
	aRegI300[nPos][4] += aDado[3]			//03 - DET_VALOR
EndIF

Return nPos

//-------------------------------------------------------------------
/*/{Protheus.doc} BlocoI
Função que irá realizar a chamada das funções do módulo de saíde e do 
módulo Financeiro, para chamar as funções responsáveis pela
geração dos registros.

@param  aRegI100  - Array com informações do registro I100
		  aRegI200  - Array com informações do registro I200		
		  aRegI299  - Array com informações do registro I299
		  aRegI300  - Array com informações do registro I300
		  aRegI399  - Array com informações do registro I399
		  aReg0500 - Array com informações do registro 0500
		  aReg1010 - Array com informações do registro 1010
		  aReg1020 - Array com informações do registro 1020		  
		  nPaiI010  - Relação com registro pai I010
		  dDataDe   - Data inicial do arquivo
		  dDataAte  - Data Final do arquivo.
		  cIndAtiv	 - Indicador da Atividade
		  aRegM400	 - Array com valores do registro M400		  
		  aRegM410	 - Array com valores do registro M410
		  aRegM800	 - Array com valores do registro M800
		  aRegM810	 - Array com valores do registro M810
		  aRegI199	 - Array com valores do registro I999

@author Erick G Dias
@since 23/12/2013
@version 11.80
/*/
//-------------------------------------------------------------------
Function SPDCBlocoI(aRegI100,aRegI200,aRegI299,aRegI300,aRegI399,aReg0500,aReg1010,aReg1020,nPaiI010,dDataDe,dDataAte,cIndAtiv,aRegM400,aRegM410,aRegM800,aRegM810,aRegI199)

Local aDado		:= {}
Local aParCDG		:= {}
Local aParNaoTri	:= {}
Local cCst		:= ""
Local cInf		:= ""
Local cCampo		:= ""
Local c711712		:= ""
Local c713714		:= ""
Local cConta		:= ""
Local cProcRef	:= ""
Local cIndProc	:= ""
Local cNota		:= ""
Local cSerie		:= ""
Local cClieFor	:= ""
Local cLoja		:= ""
Local cAliasCDG	:= ""
Local cTnatRec	:= ""
Local cCnatRec	:= ""
Local cGrpRec		:= ""
Local cAliasI		:= "BLOCOI"
Local nValRec		:= 0
Local cExclGer	:= 0
Local cExclEsp	:= 0
Local nBasePis	:= 0
Local nBaseCof	:= 0
Local nAlqPis		:= 0
Local nAlqCof 	:= 0
Local nValPis 	:= 0
Local nValCof 	:= 0
Local n713714		:= 0
Local nPosI100	:= 0
Local nPosI200	:= 0
Local nPosI300	:= 0
Local nCont		:= 0
Local lAchouCDG	:= .F.
Local lAchouCCF	:= .F.
Local lProc		:= .F.
Local lI300		:= .F.
Local dDtNatRec	:= CToD ("//")
Local cIntegra	:= SuperGetMv("MV_INTBLCI",.F.,"")

For nCont :=1 to 2
	cAliasI	:= "BLOCOI"
	lProc	:= .F.
	If nCont ==1 .and. cIntegra $ "1/3" .AND. FindFunction("FinSpdBlcI") 
		//Função do Financeiro
		FinSpdBlcI(Month(dDataDe),Year(dDataDe),cAliasI)
		lProc	:= .T.
	ElseIF nCont ==2 .and. cIntegra $ "2/3" .AND. FindFunction("PLSPISCOF")
		//Função de Saúde		
		 lProc:=PLSPISCOF(dDataDe,dDataAte,cAliasI)		 
	EndIF
	
	If lProc		
		(cAliasI)->(dbGoTop())	
		While !(cAliasI)->(EOF())
		
			aDado		:= {}
			aParNaoTri	:= {}
			nValRec	:= 0
			cCst		:= ""
			cInf		:= ""
			cCampo		:= ""
			c711712	:= ""
			c713714	:= ""
			cConta		:= ""
			cExclGer	:= 0
			cExclEsp	:= 0
			nBasePis	:= 0
			nBaseCof	:= 0
			nAlqPis	:= 0
			nAlqCof 	:= 0
			nValPis 	:= 0
			nValCof 	:= 0
			n713714	:= 0
			nPosI100	:= 0
			nPosI200	:= 0
			nPosI300	:= 0
			cNota		:= ""
			cSerie		:= ""
			cClieFor	:= ""
			cLoja		:= ""	
			
			If nCont ==1	//Valores Financeiro
				nValRec	:= (cAliasI)->VALOR	
				cCst		:= (cAliasI)->CSTPIS
				nBasePis	:= (cAliasI)->BASEPIS
				nBaseCof	:= (cAliasI)->BASECOF
				nAlqPis	:= (cAliasI)->ALIQPIS
				nAlqCof	:= (cAliasI)->ALIQCOF			
				cConta		:= (cAliasI)->CONTA				
				lI300 := .F.
				IF !Empty((cAliasI)->CDRECA)
					c711712	:= Substr((cAliasI)->CDRECA,1,5)
					c713714	:= (cAliasI)->CDRECA
					IF Len(Alltrim((cAliasI)->CDRECA)) == 8
						lI300 := .T.
					EndIF				
				Elseif !Empty((cAliasI)->CDDEDA)
					c711712	:= Substr((cAliasI)->CDDEDA,1,5)
					c713714	:= (cAliasI)->CDDEDA				
					IF Len(Alltrim((cAliasI)->CDDEDA)) == 8
						lI300 := .T.
					EndIF														
				EndIF				
				cProcRef	:= (cAliasI)->NUMPRO
				cIndProc	:= (cAliasI)->INDPRO				
				cTnatRec	:= (cAliasI)->TABCCZ
				cCnatRec	:= (cAliasI)->CODCCZ
				cGrpRec	:= (cAliasI)->GRUCCZ 
				dDtNatRec	:= (cAliasI)->DTFCCZ			
			ElseIF nCont ==2  //Valores Saúde
				nValRec	:= (cAliasI)->VALOR
				cCst		:= (cAliasI)->CSTPIS
				nAlqPis	:= (cAliasI)->ALIQPIS
				nAlqCof	:= (cAliasI)->ALIQCOF
				c711712	:=	SubStr((cAliasI)->CLASS,1,5) 
				c713714	:= (cAliasI)->CLASS
				lI300 := .F.
				IF Len(Alltrim((cAliasI)->CLASS)) == 8
					lI300 := .T.
				EndIF
				cNota		:= (cAliasI)->NOTA
				cSerie		:= (cAliasI)->SERIE
				cClieFor	:= (cAliasI)->CLIENTE
				cLoja		:= (cAliasI)->LOJA	
				cTnatRec	:= (cAliasI)->NATREC
				cCnatRec	:= (cAliasI)->CNATREC
				cGrpRec	:= (cAliasI)->GRUPONC
				dDtNatRec	:= (cAliasI)->DTFIMNT
			EndIF
			
			IF !Empty(c711712)
			
				If !Empty(cProcRef)
					lAchouCCF	:=	CCF->(MsSeek (xFilial ("CCF")+cProcRef+cIndProc))
				EndIF		
				cConta	:= Reg0500(@aReg0500,cConta)
				If SubStr(c711712,1,1) == "D" //Deduções/Exclusões
					If SubStr(c711712,1,4) == "D000" //Exclusções e Deduções de caráter Geral
						cExclGer	:= nValRec
						nValRec	:= 0	
					Else
						cExclEsp	:= nValRec
						nValRec	:= 0			
					EndIF
				EndIF
						
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Informações para I100³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aDado	:=	{}
				aAdd(aDado,"I100")
				aAdd(aDado,nValRec)
				aAdd(aDado,cCst)
				aAdd(aDado,cExclGer)
				aAdd(aDado,cExclEsp)
				aAdd(aDado,nBasePis)
				aAdd(aDado,nAlqPis)
				aAdd(aDado,0 )
				aAdd(aDado,nBaseCof)
				aAdd(aDado,nAlqCof)
				aAdd(aDado,0 )
				aAdd(aDado,cInf)
				nPosI100	:= RegI100(@aRegI100, aDado, nPaiI010)
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Gera registro I199³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lI300
					ProcRBlocI(cIndProc,	cProcRef,	lAchouCCF,	@aReg1010,	@aReg1020,	@aRegI199, "I199", nPosI100 )			
				EndIF
										
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Informações para I200³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
				If nPosI100 > 0
					aDado	:=	{}
					If SubStr(c711712 ,1,1) == "R"	//Receita
						cCampo		:= "02"
						n713714	:= nValRec
					ElseIf SubStr(c711712 ,1,4) == "D000" //Dedução Geral
						cCampo		:= "04"
						n713714	:=	cExclGer			
					Else	//Dedução Específica
						cCampo		:= "05"
						n713714	:=	cExclEsp			
					EndIF
					aAdd(aDado,"I200")
					aAdd(aDado,cCampo)
					aAdd(aDado,c711712)
					aAdd(aDado,n713714)
					aAdd(aDado,cConta)
					aAdd(aDado,cInf)
					nPosI200:= RegI200(@aRegI200, aDado, nPosI100)
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Gera registro I299³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lI300
						ProcRBlocI(cIndProc,	cProcRef,	lAchouCCF,	@aReg1010,	@aReg1020,	@aRegI299, "I299", nPosI200 )
					EndIF
				EndIF
								
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Informações para I300³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If  nPosI200 > 0 .AND. lI300
					aDado	:=	{}
					aAdd(aDado,"I300")
					aAdd(aDado,c713714)
					aAdd(aDado,n713714)
					aAdd(aDado,cConta)
					aAdd(aDado,cInf)
					nPosI300:= RegI300(@aRegI300, aDado, nPosI200)
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Gera registro I399³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
					ProcRBlocI(cIndProc,	cProcRef,	lAchouCCF,	@aReg1010,	@aReg1020,	@aRegI399, "I399", nPosI300 )
				EndIF
		
				
				IF nCont ==2 .AND. lI300
					//Busco informação complementar da SFT pois no módulo de saúde não existe esta informação.					
					lAchouCDG:= CDG->(MsSeek (xFilial ("CDG")+"S"+cNota+cSerie+cClieFor+cLoja))	
					If lAchouCDG					
						ProceRefer(@aRegI199,nPosI100,@aReg1010,@aReg1020,"I199")
						ProceRefer(@aRegI299,nPosI200,@aReg1010,@aReg1020,"I299")					
						ProceRefer(@aRegI399,nPosI300,@aReg1010,@aReg1020,"I399")		
					EndIf
						
				EndIF
					
				IF cCst $ "04/06/07/08/09"
					aParNaoTri	:= {}
		
					aAdd(aParNaoTri,cCst)
					aAdd(aParNaoTri,nValRec)
					aAdd(aParNaoTri,cConta)
					aAdd(aParNaoTri,cTnatRec)	
					aAdd(aParNaoTri,cCnatRec)			
					aAdd(aParNaoTri,cGrpRec)	
					aAdd(aParNaoTri,dDtNatRec)					
					
					//Devo gerar M400/M800 para as receitas não tributadas
					RegM400(@aRegM400,@aRegM410,,@aReg0500,,,,,aParNaoTri)
					RegM800(@aRegM800,@aRegM810,,@aReg0500,,,,,aParNaoTri)			
					
				EndIF
			EndIF
			(cAliasI)->(dbSkip())
		EndDo

		DbSelectArea(cAliasI)
		dbCloseArea()
		Ferase(cAliasI+GetDBExtension())
		Ferase(cAliasI+OrdBagExt())	

	EndIF

Next nCont

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} ProcRBlocI
Função para gerar processo referenciado nos registro I299 e I399

@param  cIndProc  - Indicador do processo referenciado
		  cNumProc  - Número do processo referenciado		
		  lAchouCCF - Indica se encontrou informação na tabela CCF
		  aReg1010  - Array com valores do registro 1010
		  aReg1020  - Array com valores do registro 1020
		  aReg 		 - Array com valores do registro I299/I399
		  cReg 		 - Registro a ser processado I299/I399
		  nPosPai   - Relação com registro pai

@author Erick G Dias
@since 27/01/2014
@version 11.80
/*/
//-------------------------------------------------------------------
Static Function ProcRBlocI(cIndProc,	cNumProc,	lAchouCCF,	aReg1010,	aReg1020,	aReg, cReg, nPosPai )

Local nPos	:= 0

IF !Empty(cIndProc) .AND. !Empty(cNumProc)
	aAdd(aReg, {})
	nPos	:=	Len (aReg)
	aAdd (aReg[nPos], nPosPai)
	aAdd (aReg[nPos], cReg)	 												//01-REG
	aAdd (aReg[nPos], cNumProc) 			   					//02-NUM_PROC
	aAdd (aReg[nPos], cIndProc) 			   					//03-IND_PROC		        

	If	lAchouCCF
		If CCF->CCF_TPCOMP == "1" //Complemento do processo referenciado - Judicial
			Reg1010(@aReg1010)
		ElseIf CCF->CCF_TPCOMP == "2" //Complemento do processo referenciado - Administrativo
			Reg1020(@aReg1020)
		EndIf
	Endif
EndIF

Return
//-------------------------------------------------------------------------------
/*/{Protheus.doc} PCGrvReg                      
--
TOTVS
--
Descrição: 
--
@version 1.0                                                            
//------------------------------------------------------------------------------- */
Function PCGrvReg (cAlias, nRelac, aReg, nItem, nFlag, nPai, cChvPai, lLoja , nTamTRBIt )
Local	nX			:=	0
Local	lRet		:=	.T.
Local	cDelimit	:=	"|"
Local	nZ			:=	0
Local	cLinha		:=	"" 
Local	cReg		:=	"" 
Local 	llDecim		:= .F.  
Local 	llDecim3	:= .F.      
Local 	cExecSQL	:= ""   

Default	nRelac	:=	0
Default	nFlag	:=	0
Default cChvPai	:= "" 
Default lLoja	:= .F.  
Default nTamTRBIt	:= 50   
Default nItem	:= Iif(lProcMThr ,0, nItem )  
Default nPai	:= Iif(lProcMThr ,0, nPai )

If nFlag==0
	cFlag	:=	Iif(Valtype(nRelac)=="N",StrZero (nRelac, nTamTRBIt, 0),nRelac)
Else
	cFlag	:=	StrZero (nFlag, nTamTRBIt, 0)
EndIf

For nZ := 1 To Len (aReg)
	cLinha	:=	cDelimit
	//
	//Monto cLinha para gravar no TRB
	For nX := 1 To Len (aReg[nZ])                         
	
		// Verifica se o campo deve conter 4 casas decimais 
		llDecim  := SPDGet4Dec(aReg[nZ,1],nX) 
		llDecim3 := SPDGet3Dec(aReg[nZ,1],nX) 		

		If (ValType (aReg[nZ][nX])="A")
			cLinha	+=	PCRetStr (aReg[nZ][nX][1], aReg[nZ][nX][2])+cDelimit
		Else     
			cLinha	+=	PCRetStr (aReg[nZ][nX],Iif(llDecim,4,If(llDecim3,3,NIL)))+cDelimit
		EndIf
	Next (nX)   
		 
	cReg := SubStr (cLinha, 2, 4)
	
	//Tratamento para nao permitir gerar uma string maior que o tamanho do campo TRB_CONT. Se acontecer, somente serah no registro 0450.
	If Len(cLinha)>Len((cAlias)->TRB_CONT)
		cLinha	:=	AllTrim(Left(cLinha,Len((cAlias)->TRB_CONT)-1))+cDelimit
	EndIf    
	
	If !lProcMThr 
		//
		//Monto TRB
		RecLock (cAlias, .T.)
			(cAlias)->TRB_TPREG		:=	cReg
			(cAlias)->TRB_RELAC		:=	cFlag+Iif(!lLoja,(Iif(Valtype(nRelac)=="N",StrZero(nRelac,nTamTRBIt,0),nRelac)), StrZero (nItem, nTamTRBIt, 0)  )
			(cAlias)->TRB_CONT		:=	cLinha
			(cAlias)->TRB_ITEM		:=	nItem
			(cAlias)->TRB_PAI		:=	nPai
			(cAlias)->TRB_CHVPAI	:=	cChvPai
		MsUnLock ()
	// ---------------  GRAVACAO DIRETO NO BANCO NA FUNCIONALIDADE EM MULTITHREAD
	Else                                        
	
		cExecSQL := " INSERT INTO " + cNomeTRB + " "
		cExecSQL += " VALUES 	( "
		cExecSQL += "  '" + cReg + "' "                                                                   	                               
		cExecSQL += ", '" + cFlag+Iif(!lLoja,(Iif(Valtype(nRelac)=="N",StrZero(Iif(cReg$"C400|C490",1,nRelac),nTamTRBIt,0),nRelac)), StrZero ( Iif(cReg$"C400|C490",1,nItem), nTamTRBIt, 0) ) + "' "
		cExecSQL += ", ' ' " 							// TRB_FLAG
		cExecSQL += ", '" + cLinha + "' "
		cExecSQL += ", '"  + cValtoChar(nItem) + "' "
		cExecSQL += ", "  + cValToChar(nPai) + " "
		cExecSQL += ", '" + cChvPai + "' " 
		cExecSQL += ", ' ' " 									// D_E_L_E_T_ 
		cExecSQL += ", "  + cValToChar( n_SPCRecno ) + " "   		// R_E_C_N_O_
		cExecSQL += " 			) "       
		
		If TcSQLExec( cExecSQL ) >= 0
			n_SPCRecno ++ 
			n_COMMIT++     
		Else
			Conout("erro no insert: ")
			Conout(cExecSQL)
		EndIf  
			
	EndIf 
	

Next (nZ)    
                        
// Verifica a necessidade de fazer Commit no banco
If lProcMThr .AND. n_COMMIT > 4095
	TcSQLExec( 'COMMIT' )  
	n_COMMIT := 0
EndIf    

Return (lRet)                

Static Function PCRetStr (xValor, nDec)
	Local	xRet
	//
	If (ValType (xValor)=="N")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Todas as variaveis numericas que nao tiverem definicao de casas decimais     |
		//³serao convertidas para apresentarem 2 decimais                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (xValor==0)
			xRet	:=	"0"
		ElseIf nDec == NIL
			xRet	:=	AllTrim (StrTran (Str (xValor,,2), ".", ","))
		Else
			xRet	:=	AllTrim (StrTran (Str (xValor,,nDec), ".", ","))
		EndIf
		
	ElseIf (ValType (xValor)=="C")  
		xRet	:=	AllTrim (xValor) 
		xRet 	:=  StrTran(xRet,"'"," ")
		
	ElseIf (ValType (xValor)=="D") .And. !Empty(xValor)
		xRet	:=	StrZero (Day (xValor), 2)+StrZero (Month (xValor), 2)+StrZero (Year (xValor), 4)
		
	Else
		xRet	:=	""
		
	EndIf
	
Return (xRet) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³SpdFRg1700| Autor ³Gustavo G. Rueda 			   ³ Data ³14.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Funcao utilizada para aglutinar as informacoes a serem geradas nos ³±±
±±³          ³ registros:                                                        ³±±
±±³          ³                1700(DOCUMENTOS FISCAIS UTILIZADOS)                ³±±
±±³          ³         1710(DOCUMENTOS FISCAIS CANCELADOS/INUTILIZADOS)          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ExpC1 := Reg1700(cAliasSFT,cEspecie,aReg1700,@aReg1710,cSituaDoc)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aPar1 - Array com as informacoes do documento fiscal              ³±±
±±³          ³ aPar2 - Array passado por referencia para aglutinar as informacoes|±±
±±³          ³         do registro 1700                                          ³±±
±±³          ³ aPar3 - Array passado por referencia para aglutinar as informacoes|±±
±±³          ³         do registro 1710                                          ³±±
±±³          ³ cPar4 - Variavel que contem o status do documento fiscal          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SpdFRg1700(aRegC100,aReg1700,aReg1710,cSituaDoc)
Local	lRet		:=	.T.
Local	cDisp		:=	""
Local	nPos1700	:=	0
Local	aAidf		:=	{}

If cVersao >= "003"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Utilizo a funcao do MATXMAG para retornar o dispositivo AIDF do documento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAidf 		:= 	RetAidf(aRegC100[1,8],aRegC100[1,7])		
	If !Empty(aAidf[1])
		Do Case
			Case Alltrim(aAidf[2]) == "1"
				cDisp :="04" 
			Case Alltrim(aAidf[2]) == "2"
				cDisp :="03"
			Case Alltrim(aAidf[2]) == "3"
				cDisp :="00"
			Case Alltrim(aAidf[2]) == "4"
				cDisp :="05"
			Case Alltrim(aAidf[2]) == "6"
				cDisp :="02"
			Case Alltrim(aAidf[2]) == "7"
				cDisp :="01"
		EndCase

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³1700(DOCUMENTOS FISCAIS UTILIZADOS)³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (nPos1700 := aScan(aReg1700,{|aX| aX[2]==cDisp .And. aX[3]==aRegC100[1,5] .And. aX[4]==aRegC100[1,7]}))==0
			aAdd(aReg1700, {})
			nPos	:=	nPos1700	:=	Len (aReg1700)
			aAdd (aReg1700[nPos], "1700")											//01 - REG
			aAdd (aReg1700[nPos], cDisp)											//02 - COD_DIST
			aAdd (aReg1700[nPos], aRegC100[1,5])									//03 - COD_MOD
			aAdd (aReg1700[nPos], aRegC100[1,7])									//04 - SER
			aAdd (aReg1700[nPos], "")												//05 - SUB
			aAdd (aReg1700[nPos], aRegC100[1,8])									//06 - NUM_DOC_INI
			aAdd (aReg1700[nPos], aRegC100[1,8])								  	//07 - NUM_DOC_FIN
			aAdd (aReg1700[nPos], aAidf[1])										//08 - NUM_AUT
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³O tratamento abaixo eh para quando jah existir um relacionamento, poder ser ³
			//³ verificado se o proximo documento estah dentro do range dos campos 02 e 03.³
			//³                                                                            ³
			//³Este tratamento leva em consideracao que os documentos apresentados no      ³
			//³  periodo, de emissao propria, seguem a ordem normal de emissao, um numero  ³
			//³  de documento crescente e sequencial.                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			//Verifico se eh um numero maior que o ultimo lido
			If Val(aRegC100[1,8])>Val(aReg1700[nPos1700,7])
				aReg1700[nPos1700,7]	:=	aRegC100[1,8]
			EndIf
			
			//Verifico se eh um numero menor que o ultimo lido
			If Val(aRegC100[1,8])<Val(aReg1700[nPos1700,6])
				aReg1700[nPos1700,6]	:=	aRegC100[1,8]
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³1710(DOCUMENTOS FISCAIS CANCELADOS/INUTILIZADOS)                                  ³
		//|                                                                                  |
		//|Este registro deve ser geradoo conforme a combinacao acima dos campo 02, 03 e 04. |
		//|Ao gerar o arquivo texto, eles devem manter a hierarquia, para isso faco o        |
		//|  relacionamento atraves do primeiro campo do registro 1710.                      |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cSituaDoc$"02#03#05"  //Cancelado/Inutilizado
			
			//Verifico se ja existe 1710 para este registro 1700
			nPos := aScan(aReg1710,{|aX|aX[1]==nPos1700})
			    
			//Se nao possuir registro 1710 ainda ou se a numeracao nao for continua, devo criar um registro 1710 novo
			If (nPos == 0) .Or. (Val(aRegC100[1,8]) <> Val(aReg1710[nPos,4]) + 1)
				aAdd(aReg1710, {})
				nPos	:=	Len (aReg1710)
				aAdd (aReg1710[nPos], nPos1700)										//00 - RELACIONAMENTO COM 1700
				aAdd (aReg1710[nPos], "1710")										//01 - REG
				aAdd (aReg1710[nPos], aRegC100[1,8])								//02 - NUM_DOC_INI
				aAdd (aReg1710[nPos], aRegC100[1,8])								//03 - NUM_DOC_FIN
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³O tratamento abaixo eh para quando jah existir um relacionamento, poder ser ³
				//³ verificado se o proximo documento estah dentro do range dos campos 02 e 03.³
				//³                                                                            ³
				//³Este tratamento leva em consideracao que os documentos apresentados no      ³
				//³  periodo, de emissao propria, seguem a ordem normal de emissao, um numero  ³
				//³  de documento crescente e sequencial.                                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				//Verifico se eh um numero maior que o ultimo lido
				If Val(aRegC100[1,8])>Val(aReg1710[nPos,4])
					aReg1710[nPos,4]	:=	aRegC100[1,8]
				EndIf
				
				//Verifico se eh um numero menor que o ultimo lido
				If Val(aRegC100[1,8])<Val(aReg1710[nPos,3])
					aReg1710[nPos,3]	:=	aRegC100[1,8]
				EndIf
			EndIf
		EndIf	
	EndIf	
EndIf

Return

//-------------------------------------------------------------------
/*/Função MontOrdCre			
Irá montar array com a ordem dos códigos de créditos da tabela 4.3.6 
conforme ordem definida pelo cliente
/*/
//-------------------------------------------------------------------
Function MontOrdCre()
Local nPos		:= 0
Local aRet		:= {}
Local cTexto	:= SuperGetMv("MV_OCODCSC",,"")
Local cCod		:= ""

//Irá montar um array com os códigos da tabela 4.3.6 informados pelo cliente através do parâmetro MV_OCODCSC
IF Len(Alltrim(cTexto)) > 0
	nPos:= At(",",SubStr(cTexto,1,len(cTexto)))
	IF nPos ==0
		//Não há virgula, existe apenas um código
		AADD(aRet,Alltrim(cTexto))
	Else
		While nPos > 0
			cCod := Substr(cTexto,1,nPos-1)
			IF (aScan (aRet, {|aX| aX==alltrim(cCod)})==0)
				AADD(aRet,alltrim(cCod))
			EndIF
			cTexto := Substr(cTexto,nPos+1,len(cTexto))
			nPos  := At(",",SubStr(cTexto,1,len(cTexto)))
		EndDo
		IF len(cTexto) > 0 .AND. (aScan(aRet, {|aX| aX==Alltrim(cTexto)})==0)
			//Adiciona o último código da sequeência
			AADD(aRet,Alltrim(cTexto))
		EndIF
	EndIF
EndIF
	
Return (aRet)



/*ÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CalcCaixa ºAutor  ³Erick G. Dias       º Data ³  26/06/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Irá gerar os valores dos registros F500 e F510 para o		  º±±
±±º          ³bloco M.                                              	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ aRegM210 -> Array com informações do registro M210         º±±
±±ºParametros³ aRegM610 -> Array com informações do registro M610         º±±
±±ºParametros³ aF500	-> Array com informações do registro F500         º±±
±±ºParametros³ aF510 	-> Array com informações do registro F510         º±±*/
Function CalcCaixa(aRegM210,aRegM610,aF500,aF510,aAjusteR,aAjusteA,lFilSCP)

Local aPar	:= {}
Local nPos	:= 0
Local nPis	:= 0
Local nCof	:= 0
Local aSCP	:= {}


For nPos	:= 1 to len(aF500)
	//³Preenche array para geração do registro M200 e filhos³
	aPar		:= {}			
	aAdd(aPar,aF500[nPos][3])  		//CST DE PIS
	aAdd(aPar,aF500[nPos][6])  		//ALÍQUOTA DE PIS
	aAdd(aPar,aF500[nPos][5]) 		//BASE DE CÁLCULO DE PIS
	aAdd(aPar,aF500[nPos][2]) 		//TOTAL DA RECEITA
	nPis:= Round(aF500[nPos][5] * aF500[nPos][6] /100,2)	
	aAdd(aPar,nPis) 				//VALOR DE PIS
	aAdd(aPar,.F.)  				//Indica se é operação com pauta
	aF500[nPos][7]	:= nPis
	
	//³Geração do registro M200 e filhos³
	RegM210(@aRegM210,,,.T.,,,.T.,,,,,,,,,aPar,.F.)		
	
	//³Geração do registro M600 e filhos³
	aPar		:= {}					
	aAdd(aPar,aF500[nPos][8])  		//CST DE COFINS
	aAdd(aPar,aF500[nPos][11])  	//ALÍQUOTA DE COFINS
	aAdd(aPar,aF500[nPos][10]) 		//BASE DE CÁLCULO DE COFINS
	aAdd(aPar,aF500[nPos][2]) 		//TOTAL DA RECEITA
	nCof:= Round(aF500[nPos][10] * aF500[nPos][11] /100,2)
	aAdd(aPar,nCof) 				//VALOR DA COFINS
	aAdd(aPar,.F.)  				//Indica se é operação com pauta
	aF500[nPos][12]	:= nCof	
	
	//³Geração do registro M600 e filhos³
	RegM610(@aRegM610,,,.T.,,,.T.,,,,,,,,,aPar,.F.)	
	IF lFilSCP .AND. nCof>0 .AND. nPis>0	
		aSCP	:= {}
		Aadd(aSCP,{,,aF500[nPos][3],,aF500[nPos][6],nPis,,,aF500[nPos][11],nCof})
		SpedXAjSCP(1,aSCP[1],@aAjusteR,@aAjusteA,.T.,cRegime,dDataAte)
	EndIF	
Next nPos

For nPos	:= 1 to len(aF510)
	//³Preenche array para geração do registro M200 e filhos³
	aPar		:= {}			
	aAdd(aPar,aF510[nPos][3])  		//CST DE PIS
	aAdd(aPar,aF510[nPos][6])  		//ALÍQUOTA DE PIS
	aAdd(aPar,aF510[nPos][5]) 		//BASE DE CÁLCULO DE PIS
	aAdd(aPar,aF510[nPos][2]) 		//TOTAL DA RECEITA
	nPis:= Round(aF510[nPos][5] * aF510[nPos][6],2)	
	aAdd(aPar,nPis) 				//VALOR DE PIS
	aAdd(aPar,.T.)  				//Indica se é operação com pauta
	aF510[nPos][7]	:= nPis
	
	//³Geração do registro M200 e filhos³
	RegM210(@aRegM210,,,.T.,,,.T.,,,,,,,,,aPar,.F.)			
	
	//³Geração do registro M600 e filhos³
	aPar		:= {}					
	aAdd(aPar,aF510[nPos][8])  		//CST DE COFINS
	aAdd(aPar,aF510[nPos][11])  	//ALÍQUOTA DE COFINS
	aAdd(aPar,aF510[nPos][10]) 		//BASE DE CÁLCULO DE COFINS
	aAdd(aPar,aF510[nPos][2]) 		//TOTAL DA RECEITA
	nCof:= Round(aF510[nPos][10] * aF510[nPos][11],2)
	aAdd(aPar,nCof) 				//VALOR DA COFINS
	aAdd(aPar,.T.)  				//Indica se é operação com pauta
	aF510[nPos][12]	:= nCof		
	//³Geração do registro M600 e filhos³
	RegM610(@aRegM610,,,.T.,,,.T.,,,,,,,,,aPar,.F.)
	IF lFilSCP .AND. nCof>0 .AND. nPis>0
		aSCP	:= {}
		Aadd(aSCP,{,,aF510[nPos][3],,aF510[nPos][6],nPis,,,aF510[nPos][11],nCof})
		SpedXAjSCP(1,aSCP[1],@aAjusteR,@aAjusteA,.T.,cRegime,dDataAte)
	EndIF
Next nPos	
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³SPDFCFPrfA³ Autor ³ Vendas e CRM          ³ Data ³27/11/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua carga dos arrays dos registros de ECF (Cupom Fiscal)³±±
±±³          ³                     (PERFIL A)                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL (Ambiente TOP)                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPDFCFPrfA(aRegC400	, aRegC405	, aRegC410	, aRegC420	,;
					aRegC425	, aRegC460	, aRegC470	, aRegC490	,;
					aRegC495	, aProdB1	, dDataDe	, dDataAte	,;
					cPerfil		, cAlias	, aReg0200	, aReg0190	,;
					lCstPis		, lCstCof	, aReg0220	, aReg1600	,;
					aReg0150	, aWizard	, lTop		, cUf		,;
					nQtReg0200 	, lJob  	, lLegisPer )

Local 	nPos400		:= 0
Local 	nPos405		:= 0
Local 	aPos420		:= {}
Local 	aTotaliz	:= {}
Local 	nY 			:= 0
Local 	nValCof 	:= 0
Local	nValPis 	:= 0
Local 	cAliqISS  	:= ""
Local 	nAliqIss 	:= 0
Local 	aCposAliq 	:= {}
Local 	cCampo		:= ""      						// Utilizada para armazenar o campo encotrad no SF3
Local 	cCodAliq	:= ""							// Codigo dos totalizadores das aliquotas
Local 	cLegTrib	:= "T"							// Legenda de Tributado
Local 	cCampoCod	:= ""      						// Utilizada para armazenar o campo referente ao código da aliquota( Utilizado para validação do PAF-ECF )
Local 	nVlBrtLj  	:= 0
Local 	lAnalLEG58 	:= LJAnalisaLEG(58)[1] 			// Para a Nota Fiscal Gaucha pega os dados do cupom
Local 	aAuxReg   	:= {}
Local 	nQuantD   	:= Min(TAMSX3("FT_QUANT")[2],3)
Local 	cFilB1		:= xFilial("SB1")
Local 	cFilSA1		:= xFilial("SA1")
Local 	cFilSL1		:= xFilial("SL1")
Local 	cQryAlias 	:= GetNextAlias() 				// Alias da Query
Local 	cQryFields 	:= ""  							// Campos da Query
Local 	cOrderBy	:= ""  							// Order By da Query
Local 	cChave  	:= ""
Local 	cPDV 		:= ""
Local 	sDTMOVTO	:= ""
Local 	lCancSft  	:= .F.
Local  	aSLX 		:= {}
Local 	lConcFil	:= SuperGetMv("MV_COFLSPD",.F.,.T.)
Local 	cConfFil 	:= Iif(lConcFil,cFilB1,"")
Local 	nPosC460 	:= Len(aRegC460)
Local 	nPosC470 	:= Len(aRegC470)
Local   cNfC460 	:= ""
Local 	aItensC470 	:= {}
Local 	cMVDTINCB1	:= AllTrim(GetNewPar("MV_DTINCB1","B1_DATREF"))
Local 	aSetField   := {} //Campos da query para efetuar conversao "TcSetField"
Local 	lIsBahia 	:= cUf == "BA"
Local 	aInfPart 	:= {"","","","",""}
Local 	cCpfCNPJ  	:= ""
Local 	cChvCliAnt 	:= ""
Local   lGer410		:= !lLegisPer .And. "1"$aWizard[1][15]


cMVDTINCB1 := If( Left(cMVDTINCB1,1)=="'" .Or. Left(cMVDTINCB1,1)=='"' , &(cMVDTINCB1) , cMVDTINCB1 )

//Legenda de ISS
cAliqISS := cValToChar(SuperGetMv("MV_ALIQISS",,0))
cAliqISS := AllTrim( StrTran(cAliqISS, ",", ".") )
cAliqISS := TransForm(cAliqISS, "@E 99.99")
nAliqIss := Val(SubStr(cAliqISS , 1, At(".", cAliqISS)))
cAliqISS := StrTran(cAliqISS, ".")
cAliqISS := AllTrim(cAliqISS)
If nAliqIss >= 10
	cAliqISS := "S" + PadR(cAliqISS, 4, "0")
Else
	cAliqISS := "S0" + PadR(cAliqISS, 3, "0")
EndIf

//Verifica todos os tipos de aliquotas existentes
DbSelectArea("SX3")
DbSetOrder(2)
DbSeek("FI_BAS" , .T.)
Do While !SX3->(Eof()) .AND. SubStr(SX3->X3_CAMPO,1,6) == "FI_BAS"
	cCampo := AllTrim(SX3->X3_CAMPO)
	//Monta a legenda da tributacao
	If Len(AllTrim(cCampo)) == 7 .OR. Len(AllTrim(cCampo)) == 9
		cLegTrib	:= "T0"	// Acrescenta um zero para entrar no padrao do arquivo
	Else
		cLegTrib	:= "T"
	EndIf
	cCodAliq := Subs(cLegTrib + PadR(AllTrim(StrTran(Subs(cCampo,7,Len(cCampo)) , ",", ".")) , 4 ,"0" ),0,5)
    cCampoCod	:= "FI_COD" + Substr( cCampo, 7, Len(cCampo)-6)
    
    If !(SFI->(FieldPos(cCampoCod)) > 0)
		cCampoCod := ""
    EndIf
    aAdd( aCposAliq, { cCampo, cCampoCod, cCodAliq } )
	SX3->(dbSkip())
Enddo

If !lIsBahia
	//Executa esta funcao separadamente para carregar Registros 0200 (este tratamento foi feito para melhorar a performance do processamento)
	SPDFLj0200( cAlias, dDataDe, dDataAte, @aReg0200, @aReg0190, @aReg0220, @nQtReg0200, cFilB1, lConcFil, "C470")
EndIf

//-----------------------------------------
//CAMPOS DA TABELA SFT PARA MONTAR A QUERY
//-----------------------------------------
cQryFields := "SFT.FT_FILIAL,	SFT.FT_TIPOMOV,		SFT.FT_SERIE,	   		SFT.FT_NFISCAL,		SFT.FT_CLIEFOR,		"
cQryFields += "SFT.FT_LOJA,		SFT.FT_ITEM,		SFT.FT_PRODUTO,	   		SFT.FT_ENTRADA,		SFT.FT_NRLIVRO,		"
cQryFields += "SFT.FT_CFOP,		SFT.FT_ESPECIE,		SFT.FT_TIPO,	   		SFT.FT_EMISSAO,		SFT.FT_DTCANC,		"
cQryFields += "SFT.FT_FORMUL, 	SFT.FT_ALIQPIS,		SFT.FT_VALPIS,	   		SFT.FT_ALIQCOF,		SFT.FT_VALCOF,		"
cQryFields += "SFT.FT_VALCONT,	SFT.FT_BASEICM,		SFT.FT_VALICM,			SFT.FT_ISSST,	 	SFT.FT_BASERET,		"
cQryFields += "SFT.FT_ICMSRET,	SFT.FT_VALIPI,		SFT.FT_ISENICM,	   		SFT.FT_QUANT,		SFT.FT_DESCONT,		"
cQryFields += "SFT.FT_TOTAL,	SFT.FT_FRETE,  		SFT.FT_SEGURO,			SFT.FT_DESPESA,		SFT.FT_OUTRICM,		"
cQryFields += "SFT.FT_BASEIPI,	SFT.FT_ISENIPI,		SFT.FT_OUTRIPI,	   		SFT.FT_ICMSCOM,		SFT.FT_RECISS,		"
cQryFields += "SFT.FT_BASEIRR,	SFT.FT_ALIQICM,		SFT.FT_ALIQIPI,	   		SFT.FT_CTIPI,		SFT.FT_POSIPI,		"
cQryFields += "SFT.FT_CLASFIS,	SFT.FT_PRCUNIT,		SFT.FT_CFPS,	   		SFT.FT_ESTADO,		SFT.FT_CODISS,		"
cQryFields += "SFT.FT_ALIQIRR,	SFT.FT_VALIRR,		SFT.FT_BASEINS,			SFT.FT_VALINS,		SFT.FT_PDV,			"
cQryFields += "SFT.FT_ISSSUB,	SFT.FT_CREDST,		SFT.FT_ISENRET,	   		SFT.FT_OUTRRET,		SFT.FT_CONTA,		"
cQryFields += "SFT.FT_BASEPIS,	SFT.FT_BASECOF,		SFT.FT_VALPS3,	   		SFT.FT_VALCF3,		SFT.FT_PESO,	    "
cQryFields += "SFT.FT_SOLTRIB,	SFT.FT_CHVNFE, 		SFT.FT_CSTPIS,	   		SFT.FT_CSTCOF,		SFT.FT_INDNTFR, 	"
cQryFields += "SFT.FT_CODBCC,	SFT.FT_ALIQCF3,  	SFT.FT_VALCF3,	   		SFT.FT_BASEPS3, 	SFT.FT_ENTRADA AS DTMOVTO, "
cQryFields += "SFT.FT_ALIQPS3,  SFT.FT_VALPS3,		SFT.FT_BASECF3, "
If SFT->(FieldPos("FT_RGESPST")) > 0
	cQryFields += "	SFT.FT_RGESPST, "
EndIf

//-----------------------------------------
//CAMPOS DA TABELA SF3 PARA MONTAR A QUERY
//-----------------------------------------
If SF3->(FieldPos("F3_CODRSEF")) > 0
	cQryFields += "	SF3.F3_CODRSEF, "
EndIf

//-----------------------------------------
//CAMPOS DA TABELA SD2 PARA MONTAR A QUERY
//-----------------------------------------
cQryFields += " SD2.D2_SITTRIB, "

//-----------------------------------------
//CAMPOS DA TABELA SB1 PARA MONTAR A QUERY
//-----------------------------------------
cQryFields	+=	"SB1.B1_COD,		SB1.B1_DESC,		SB1.B1_VLR_PIS,		SB1.B1_VLR_COF,		SB1.B1_TNATREC,		"
cQryFields	+=  "SB1.B1_CNATREC, 	SB1.B1_GRPNATR, 	SB1.B1_DTFIMNT,		SB1.B1_TIPO,		SB1.B1_CODBAR,		"
cQryFields	+=  "SB1.B1_CODANT, 	SB1.B1_UM, 			SB1.B1_POSIPI,		SB1.B1_EX_NCM,		SB1.B1_CODISS,		"
cQryFields	+=  "SB1.B1_PICM, 		SB1.B1_FECP, 		SB1.B1_DATREF,		SB1.B1_TIPCONV, "
If !Empty(cMVDTINCB1) .And. cMVDTINCB1 <> "B1_DATREF" .And. !(cMVDTINCB1 $ cQryFields)
	cQryFields	+=  "SB1."+cMVDTINCB1+", "
	aAdd( aSetField, { cMVDTINCB1, "D" , 8, 0 } )
EndIf

//-----------------------------------------
//CAMPOS DA TABELA SB0 PARA MONTAR A QUERY
//-----------------------------------------
cQryFields	+=	"SB0.B0_ALIQRED, "

//-----------------------------------------
//CAMPOS DA TABELA SFI PARA MONTAR A QUERY
//-----------------------------------------
cQryFields += " SFI.FI_PDV, 		SFI.FI_DTMOVTO, 	SFI.FI_DESC,  		SFI.FI_SERPDV, 		SFI.FI_VALCON, 		"
cQryFields += "	SFI.FI_COO, 		SFI.FI_CRO, 		SFI.FI_NUMREDZ, 	SFI.FI_NUMFIM, 		SFI.FI_GTFINAL, 	"
cQryFields += "	SFI.FI_ISS, 		SFI.FI_CANCEL, 		SFI.FI_SUBTRIB, 	SFI.FI_ISENTO, 		SFI.FI_NTRIB, 		"
//Acrescenta os campos de tributacao (Ex: FI_BAS7, FI_BAS12, FI_BAS18...)
For nY:=1 to Len(aCposAliq)
	cQryFields += "SFI." + aCposAliq[nY][1] + ", "
	If !Empty(aCposAliq[nY][2])
		cQryFields += "SFI." + aCposAliq[nY][2] + ", "
	EndIf
Next nY

//-----------------------------------------
//CAMPOS DA TABELA SLG PARA MONTAR A QUERY
//-----------------------------------------
cQryFields += " SLG.LG_SERPDV, SLG.LG_IMPFISC, SLG.LG_PDV,  "

//-----------------------------------------
//CAMPOS DA TABELA SL1 PARA MONTAR A QUERY
//-----------------------------------------
If SL1->( FieldPos("L1_CGCCLI") ) > 0
	cQryFields += " L1_CGCCLI,  "
Else
	cQryFields += " '" + Space(11) + "' AS L1_CGCCLI,  "
EndIf

//-----------------------------------------
//CAMPOS (Sub-Query) Tabela SLX
//-----------------------------------------
cQryFields += " 		(SELECT SUM(LX_QTDE) "
cQryFields += " 		 FROM  " + RetSQLName("SLX") + " SLX "
cQryFields += " 		 WHERE 	SLX.LX_FILIAL 	= SFT.FT_FILIAL  AND "
cQryFields += " 		 		SLX.LX_PDV 		= SFT.FT_PDV 	 AND "
cQryFields += " 		 		SLX.LX_CUPOM 	= SFT.FT_NFISCAL AND "
cQryFields += " 		 		SLX.LX_SERIE 	= SFT.FT_SERIE 	 AND "
cQryFields += " 		 		SLX.LX_DTMOVTO	= SFT.FT_EMISSAO AND "
cQryFields += " 		 		SLX.LX_PRODUTO  = SFT.FT_PRODUTO AND "
cQryFields += " 		 		SLX.LX_ITEM		= SFT.FT_ITEM    AND "
cQryFields += "			    SLX.D_E_L_E_T_ =  ' ' ) AS LX_QTDCANC "
cQryFields	:=	"%"+cQryFields+"%"
cOrderBy  := "%ORDER BY SFI.FI_PDV, SFI.FI_DTMOVTO, SFT.FT_NFISCAL,  SFT.FT_SERIE, SFT.FT_ITEM  %"
BeginSql Alias cQryAlias

		COLUMN FT_EMISSAO 	AS DATE
    	COLUMN FT_ENTRADA 	AS DATE
    	COLUMN FT_DTCANC 	AS DATE
    	COLUMN FI_DTMOVTO 	AS DATE
    	COLUMN B1_DATREF 	AS DATE	
	SELECT 
		%Exp:cQryFields% 
	FROM 
		%Table:SFT% SFT 
		JOIN %Table:SFI% SFI ON (SFI.FI_FILIAL=%xFilial:SFI% AND SFI.FI_PDV=SFT.FT_PDV AND SFI.FI_DTMOVTO=SFT.FT_ENTRADA AND SFI.%NotDel%)
		JOIN %Table:SLG% SLG ON (SLG.LG_FILIAL=%xFilial:SLG% AND SLG.LG_PDV=SFT.FT_PDV AND SLG.%NotDel%)
		LEFT JOIN %Table:SB1% SB1 ON(SB1.B1_FILIAL=%xFilial:SB1%  AND SB1.B1_COD=SFT.FT_PRODUTO AND SB1.%NotDel%) 
		LEFT JOIN %Table:SB0% SB0 ON(SB0.B0_FILIAL=%xFilial:SB0%  AND SB0.B0_COD=SFT.FT_PRODUTO AND SB0.%NotDel%) 
		LEFT JOIN %Table:SD2% SD2 ON(SD2.D2_FILIAL=%xFilial:SD2%  AND SD2.D2_DOC=SFT.FT_NFISCAL AND SD2.D2_SERIE=SFT.FT_SERIE AND SD2.D2_CLIENTE=SFT.FT_CLIEFOR AND SD2.D2_LOJA=SFT.FT_LOJA AND SD2.D2_COD=SFT.FT_PRODUTO AND SD2.D2_ITEM=SFT.FT_ITEM AND SD2.D2_PDV=SFT.FT_PDV AND SD2.%NotDel%)
		LEFT JOIN %Table:SF3% SF3 ON(SF3.F3_FILIAL=%xFilial:SF3%  AND SF3.F3_ENTRADA=SFT.FT_ENTRADA AND SF3.F3_NFISCAL=SFT.FT_NFISCAL AND SF3.F3_SERIE=SFT.FT_SERIE AND SF3.F3_CLIEFOR=SFT.FT_CLIEFOR AND SF3.F3_LOJA=SFT.FT_LOJA AND SF3.F3_CFO=SFT.FT_CFOP AND SF3.F3_ALIQICM=SFT.FT_ALIQICM AND SF3.F3_PDV=SFT.FT_PDV AND SF3.F3_IDENTFT=SFT.FT_IDENTF3 AND SF3.%NotDel%)
		LEFT JOIN %Table:SL1% SL1 ON(SL1.L1_FILIAL=%xFilial:SL1%  AND SL1.L1_DOC=SFT.FT_NFISCAL AND SL1.L1_SERIE=SFT.FT_SERIE AND SL1.L1_CLIENTE=SFT.FT_CLIEFOR AND SL1.L1_LOJA=SFT.FT_LOJA AND SL1.%NotDel%)
	WHERE 
		SFT.FT_FILIAL=%xFilial:SFT% 		 	AND
		SFT.FT_TIPOMOV = 'S' 					AND
		SFT.FT_ENTRADA >= %Exp:DToS(dDataDe)% 	AND
		SFT.FT_ENTRADA <= %Exp:DToS(dDataAte)%  AND
		SFT.FT_ESPECIE = 'CF' 					AND
		SFT.%NotDel%
		
	%Exp:cOrderBy%

EndSql
For nY := 1 To Len(aSetField)
	TcSetField(cQryAlias,aSetField[nY,1],aSetField[nY,2],aSetField[nY,3],aSetField[nY,4])
Next nY

//---------------------
// Processa Registros.
//---------------------
Do While !(cQryAlias)->(Eof())
	
    cPDV :=  (cQryAlias)->FT_PDV
    
    If !lJob
    	oProcess:Inc2Progress("Processando Cupom Fiscal - PDV " + AllTrim(cPDV) ,"")
    EndIf
    
	RegC400 (@aRegC400, (cQryAlias)->LG_IMPFISC, (cQryAlias)->LG_SERPDV, AllTrim((cQryAlias)->LG_PDV), @nPos400)
	
	//----------------------------
	// Laco por PDV
	//----------------------------
	While !(cQryAlias)->(Eof()) .AND. cPDV==(cQryAlias)->FT_PDV
		
		sDTMOVTO 	:= (cQryAlias)->DTMOVTO
		cChave 		:= cPDV + sDTMOVTO
		
		nVlBrtLj 	:= ( (cQryAlias)->FI_VALCON + (cQryAlias)->FI_ISS ) // Valor Bruto, FI_VALCON (Valor contabil) + FI_ISS (Valor de Servicos)
		
		RegC405 (@aRegC405				, nPos400				, (cQryAlias)->FI_DTMOVTO	, (cQryAlias)->FI_CRO	, ;
				(cQryAlias)->FI_NUMREDZ	, (cQryAlias)->FI_NUMFIM, (cQryAlias)->FI_GTFINAL	, nVlBrtLj   			, ;
				@nPos405				, (cQryAlias)->FI_DESC  , (cQryAlias)->FI_CANCEL)
		
		//Reinicia variaveis
		nValCof 	:= 0
		nValPis 	:= 0
		aAuxReg 	:= {}
		cNfC460		:= ""
		aItensC470  := {}
		
		//--------------------------------------------------------------------
		// Carrego todos os codigos e valores que foram contabilizados no SFI
		//--------------------------------------------------------------------
		aTotaliz 	:= SPDFTotSFI(.T., cAliqISS, cQryAlias, aCposAliq)
		
		RegC420 (@aRegC420, 	nPos405,   	(cQryAlias)->FI_CRO, 		(cQryAlias)->FI_NUMREDZ,;
				 aTotaliz,		@aPos420)
		
		//-------------------------------------------
		// Laco por Reducao Z - Por data do Movimento
		//-------------------------------------------
		While !(cQryAlias)->(Eof())  .AND.  cChave == (cQryAlias)->FT_PDV+(cQryAlias)->DTMOVTO
	   		
	   		lCancSft := !Empty((cQryAlias)->FT_DTCANC) //Verifica se esta cancelado
	   		
			If !lIsBahia
				SPDFC460470(@aRegC460	, @aRegC470		, (cQryAlias)->FI_DTMOVTO	, (cQryAlias)->FI_PDV	,;
							@aProdB1 	, nPos405		, @aReg0200					, lCstPis				,;
					        lCstCof	   	, aWizard 		, nQuantD 					, cQryAlias   			,;
					        cFilB1	 	, cFilSA1  		, lCancSft					, @nPosC460				,;
					        @cNfC460 	, @aItensC470 	, @nPosC470					, lConcFil 				,;
					        cConfFil 	, @aInfPart		, @cCpfCNPJ					, @cChvCliAnt )
			EndIf
	   		
	  		(cQryAlias)->(dbSkip())
	  		
		EndDo
		
		
		SPDFRgC490 (@aRegC490	, sDTMOVTO		, nPos405  		, lCstPis	,;
				 	lCstCof  	, cPDV			, @aProdB1		, nPos405	,;
				 	@aReg0200	, @aReg0190 	, @aReg0220 	, @nValCof	,;
				 	@nValPis	)
		
		
		If lGer410 //Depois de ter os valores de PIS e COFINS gera o C410
			RegC410 (  @aRegC410	   	, nPos405 	, nValCof 	, nValPis  ,;
					   Nil 				, Nil 		, lTop )
		EndIf
		
	EndDo
	
	If lIsBahia
		//O Registro C495 somente deve ser gerado, caso tenha gerado tambem o Registro C400
		RegC495 (@aRegC495	, @aProdB1			, nPos400	, dDataDe	,;
				 dDataAte	, AllTrim(cPDV)		, @aReg0200	, cAlias 	,;
				 @aReg0190 	, @aReg0220 		, @aSLX 	, cFilB1)
	EndIf
	
EndDo

DbSelectArea(cQryAlias)
(cQryAlias)->(DbCloseArea())

If "1"$aWizard[5][7]//Verifica se deve gerar registro 1600
	SPDFGr1600(@aReg1600,@aReg0150,dDataDe,dDataAte,cAlias,aWizard,Nil,lConcFil)
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³SPDFCFPrfB³ Autor ³ Vendas e CRM          ³ Data ³27/11/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua carga dos arrays dos registros de ECF (Cupom Fiscal)³±±
±±³          ³                     (PERFIL B)                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL (Ambiente TOP)                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPDFCFPrfB(aRegC400	, aRegC405	, aRegC410	, aRegC420	,;
					aRegC425	, aRegC460	, aRegC470	, aRegC490	,;
					aRegC495	, aProdB1	, dDataDe	, dDataAte	,;
					cPerfil		, cAlias	, aReg0200	, aReg0190	,;
					lCstPis		, lCstCof	, aReg0220	, aReg1600	,;
					aReg0150	, aWizard	, lTop		, cUf		,;
					nQtReg0200 	, lJob  	, lLegisPer )
					
Local 	nPos400		:= 0
Local 	nPos405		:= 0
Local 	aPos420		:= {}
Local 	aTotaliz	:= {}
Local 	nY 			:= 0
Local 	nValCof 	:= 0
Local	nValPis 	:= 0
Local 	cAliqISS  	:= ""
Local 	nAliqIss 	:= 0
Local 	aCposAliq 	:= {}
Local 	cCampo		:= ""      						// Utilizada para armazenar o campo encotrad no SF3
Local 	cCodAliq	:= ""							// Codigo dos totalizadores das aliquotas
Local 	cLegTrib	:= "T"							// Legenda de Tributado
Local 	cCampoCod	:= ""      						// Utilizada para armazenar o campo referente ao código da aliquota( Utilizado para validação do PAF-ECF )
Local 	nVlBrtLj  	:= 0
Local 	nQuantD   	:= Min(TAMSX3("FT_QUANT")[2],3)
Local 	cFilB1		:= xFilial("SB1")
Local 	cQuery 		:= ""
Local 	cQryAlias 	:= GetNextAlias() 				// Alias da Query
Local 	cQryFields 	:= ""  							// Campos da Query
Local 	cFieldAliq 	:= ""							// Campos de Aliquota de ICMS
Local 	cGroupBy	:= ""  							// Group By da Query
Local 	cChave  	:= ""
Local 	cPDV 		:= ""
Local 	sDtMovto	:= ""
Local  	aSLX 		:= {}
Local 	lConcFil	:= SuperGetMv("MV_COFLSPD",.F.,.T.)
Local 	cConfFil 	:= Iif(lConcFil,cFilB1,"")
Local 	cSitTriAnt	:= ""
Local 	nPosPai 	:= 0
Local 	lIsBahia 	:= cUf == "BA"
Local   lGer410		:= !lLegisPer .And. "1"$aWizard[1][15]


//Legenda de ISS
cAliqISS := cValToChar(SuperGetMv("MV_ALIQISS",,0))
cAliqISS := AllTrim( StrTran(cAliqISS, ",", ".") )
cAliqISS := TransForm(cAliqISS, "@E 99.99")
nAliqIss := Val(SubStr(cAliqISS , 1, At(".", cAliqISS)))
cAliqISS := StrTran(cAliqISS, ".")
cAliqISS := AllTrim(cAliqISS)
If nAliqIss >= 10
	cAliqISS := "S" + PadR(cAliqISS, 4, "0")
Else
	cAliqISS := "S0" + PadR(cAliqISS, 3, "0")
EndIf

//Verifica todos os tipos de aliquotas existentes
DbSelectArea("SX3")
DbSetOrder(2)
DbSeek("FI_BAS" , .T.)
Do While !SX3->(Eof()) .AND. SubStr(SX3->X3_CAMPO,1,6) == "FI_BAS"
	cCampo := AllTrim(SX3->X3_CAMPO)
	//Monta a legenda da tributacao
	If Len(AllTrim(cCampo)) == 7 .OR. Len(AllTrim(cCampo)) == 9
		cLegTrib	:= "T0"	// Acrescenta um zero para entrar no padrao do arquivo
	Else
		cLegTrib	:= "T"
	EndIf
	cCodAliq := Subs(cLegTrib + PadR(AllTrim(StrTran(Subs(cCampo,7,Len(cCampo)) , ",", ".")) , 4 ,"0" ),0,5)
    cCampoCod	:= "FI_COD" + Substr( cCampo, 7, Len(cCampo)-6)
    
    If !(SFI->(FieldPos(cCampoCod)) > 0)
		cCampoCod := ""
    EndIf
    aAdd( aCposAliq, { cCampo, cCampoCod, cCodAliq } )
	SX3->(dbSkip())
Enddo

If !lIsBahia
	//Executa esta funcao separadamente para carregar Registros 0200 (este tratamento foi feito para melhorar a performance do processamento)
	SPDFLj0200( cAlias, dDataDe, dDataAte, @aReg0200, @aReg0190, @aReg0220, @nQtReg0200, cFilB1, lConcFil, "C425")
EndIf

//----------------------------
//CAMPOS PARA MONTAR A QUERY
//----------------------------
cQryFields := " SFT.FT_PDV, SFT.FT_ENTRADA, SD2.D2_SITTRIB, SFT.FT_PRODUTO, SB1.B1_UM,"
cQryFields += " SUM(SFT.FT_QUANT) FT_QUANT, SUM(SFT.FT_VALCONT) FT_VALCONT, SUM(SFT.FT_VALPIS) FT_VALPIS, SUM(SFT.FT_VALCOF) FT_VALCOF,"
cQryFields += " SFI.FI_NUMREDZ, SFI.FI_CRO, SFI.FI_NUMFIM, SFI.FI_GTFINAL, SFI.FI_VALCON, SFI.FI_ISS, SFI.FI_DESC, SFI.FI_CANCEL,"
cQryFields += " SFI.FI_SUBTRIB, SFI.FI_ISENTO, SFI.FI_NTRIB, SLG.LG_IMPFISC, SLG.LG_SERPDV,"
//Acrescenta os campos de tributacao (Ex: FI_BAS7, FI_BAS12, FI_BAS18...)
For nY:=1 to Len(aCposAliq)
	cFieldAliq += "SFI." + aCposAliq[nY][1] + ","
	If !Empty(aCposAliq[nY][2])
		cFieldAliq += "SFI." + aCposAliq[nY][2] + ","
	EndIf
Next nY

//Tira a ultima virgula
cFieldAliq := Left(cFieldAliq,Len(cFieldAliq)-1)

cQryFields := cQryFields + cFieldAliq

cGroupBy  := "SFT.FT_PDV, SFT.FT_ENTRADA, SD2.D2_SITTRIB, SFT.FT_PRODUTO, SB1.B1_UM,"
cGroupBy  += "SFI.FI_NUMREDZ, SFI.FI_CRO, SFI.FI_NUMFIM, SFI.FI_GTFINAL, SFI.FI_VALCON, SFI.FI_ISS, SFI.FI_DESC, SFI.FI_CANCEL,"
cGroupBy  += "SFI.FI_SUBTRIB, SFI.FI_ISENTO, SFI.FI_NTRIB, SLG.LG_IMPFISC, SLG.LG_SERPDV"

If !Empty(cFieldAliq)
	cGroupBy  := cGroupBy + ", " + cFieldAliq
EndIf

	
cQuery := " SELECT "
cQuery += cQryFields
cQuery += " FROM "
cQuery += RetSQLName("SFT") + " SFT, "
cQuery += RetSQLName("SD2") + " SD2, "
cQuery += RetSQLName("SB1") + " SB1, "
cQuery += RetSQLName("SLG") + " SLG, "
cQuery += RetSQLName("SFI") + " SFI "
cQuery += "	WHERE "
cQuery += " SFT.FT_FILIAL = '"+xFilial("SFT")+"'"
cQuery += " AND SFT.FT_TIPOMOV = 'S'"
cQuery += " AND SFT.FT_ESPECIE = 'CF'"
cQuery += " AND SFT.FT_ENTRADA BETWEEN '" + DToS(dDataDe) + "' AND '" + DToS(dDataAte) + "'"
cQuery += " AND SFT.D_E_L_E_T_ = ' '"
cQuery += " AND SFT.FT_DTCANC = ' '"
cQuery += " AND SD2.D2_FILIAL = '" + xFilial("SD2") + "'"
cQuery += " AND SFT.FT_PDV = SD2.D2_PDV"
cQuery += " AND SFT.FT_SERIE = SD2.D2_SERIE"
cQuery += " AND SFT.FT_NFISCAL = SD2.D2_DOC"
cQuery += " AND SFT.FT_CLIEFOR = SD2.D2_CLIENTE"
cQuery += " AND SFT.FT_LOJA = SD2.D2_LOJA"
cQuery += " AND SD2.D_E_L_E_T_ = ' '"
cQuery += " AND SFT.FT_ITEM = SD2.D2_ITEM"
cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
cQuery += " AND SB1.B1_COD = FT_PRODUTO"
cQuery += " AND SB1.D_E_L_E_T_ = ' '"
cQuery += " AND SLG.LG_FILIAL = '" + xFilial("SLG") + "'"
cQuery += " AND SLG.LG_PDV = SFT.FT_PDV"
cQuery += " AND SLG.D_E_L_E_T_ = ' '"
cQuery += " AND SFI.FI_FILIAL = '" + xFilial("SFI") + "'"
cQuery += " AND SFI.FI_PDV = SLG.LG_PDV"
cQuery += " AND SFI.FI_DTMOVTO = FT_ENTRADA"
cQuery += " AND SFI.FI_SERPDV = SLG.LG_SERPDV"
cQuery += " AND SFI.D_E_L_E_T_ = ' '"
cQuery += " GROUP BY " + cGroupBy
cQuery += " ORDER BY SFT.FT_PDV, SFT.FT_ENTRADA, SD2.D2_SITTRIB"

cQuery := ChangeQuery( cQuery )
DbUseArea( .T., 'TOPCONN', TcGenQry(,,cQuery), cQryAlias, .T., .F. )

//----------------------------
// Processa Registros.
//----------------------------
Do While !(cQryAlias)->(Eof())
	
    cPDV :=  (cQryAlias)->FT_PDV
    
    If !lJob
    	oProcess:Inc2Progress("Processando Cupom Fiscal - PDV " + AllTrim(cPDV) ,"")
    EndIf
    
	RegC400 (@aRegC400, (cQryAlias)->LG_IMPFISC, (cQryAlias)->LG_SERPDV, AllTrim((cQryAlias)->FT_PDV), @nPos400)
	
	//-------------------------------------------
	// Laco por Reducao Z - Por data do Movimento
	//-------------------------------------------
	While !(cQryAlias)->(Eof()) .AND. cPDV==(cQryAlias)->FT_PDV
		
		sDtMovto 	:= (cQryAlias)->FT_ENTRADA
		cChave 		:= cPDV + (cQryAlias)->FT_ENTRADA
		
		nVlBrtLj := ( (cQryAlias)->FI_VALCON + (cQryAlias)->FI_ISS ) // Valor Bruto, FI_VALCON (Valor contabil) + FI_ISS (Valor de Servicos)
		
		RegC405 (@aRegC405				, nPos400				, SToD((cQryAlias)->FT_ENTRADA)	, (cQryAlias)->FI_CRO	, ;
				(cQryAlias)->FI_NUMREDZ	, (cQryAlias)->FI_NUMFIM, (cQryAlias)->FI_GTFINAL		, nVlBrtLj   			, ;
				@nPos405				, (cQryAlias)->FI_DESC  , (cQryAlias)->FI_CANCEL )
		
		//Reinicia variaveis
		nValCof 	:= 0
		nValPis 	:= 0
		cSitTriAnt	:= ""
		
		//--------------------------------------------------------------------
		//Carrego todos os codigos e valores que foram contabilizados no SFI
		//--------------------------------------------------------------------
		aTotaliz 	:= SPDFTotSFI(.T., cAliqISS, cQryAlias, aCposAliq)
		
		RegC420 (@aRegC420, 	nPos405,   	(cQryAlias)->FI_CRO, 		(cQryAlias)->FI_NUMREDZ,;
				 aTotaliz,		@aPos420)
		
		//----------------------
		// Laco por Reducao Z
		//----------------------
		While !(cQryAlias)->(Eof())  .AND.  cChave == (cQryAlias)->FT_PDV+(cQryAlias)->FT_ENTRADA
			
			If !lIsBahia
				
				If (cQryAlias)->D2_SITTRIB <> cSitTriAnt
					cSitTriAnt 	:= (cQryAlias)->D2_SITTRIB
				   	nPosPai 	:= Ascan(aPos420,{|x| AllTrim(x[2]) == AllTrim((cQryAlias)->D2_SITTRIB) })
				   	If nPosPai == 0
				   		cSitTriAnt := ""
					   	(cQryAlias)->(dbSkip())
					   	Loop
				   	EndIf
				EndIf
				
				SPDFRgC425 (@aRegC425	, (cQryAlias)->FT_ENTRADA	, (cQryAlias)->FT_PDV	, aPos420	,;
							aWizard 	, nQuantD					, cConfFil 				, cQryAlias ,;
							cSitTriAnt	, nPosPai )
				
			EndIf
			
	  		(cQryAlias)->(dbSkip())
		EndDo
		
		
		SPDFRgC490 (@aRegC490	, sDtMovto		, nPos405  		, lCstPis	,;
				 	lCstCof  	, cPDV			, @aProdB1		, nPos405	,;
				 	@aReg0200	, @aReg0190 	, @aReg0220 	, @nValCof	,;
				 	@nValPis	)
		
		If lGer410 // Depois de ter os valores de PIS e COFINS gera o C410
			RegC410 (  @aRegC410	   	, nPos405 	, nValCof 	, nValPis  ,;
					   Nil 				, Nil 		, lTop )
		EndIf
		
	EndDo
	
	If lIsBahia
		//O Registro C495 somente deve ser gerado, caso tenha gerado tambem o Registro C400
		RegC495 (@aRegC495	, @aProdB1			, nPos400	, dDataDe	,;
				 dDataAte	, AllTrim(cPDV)		, @aReg0200	, cAlias 	,;
				 @aReg0190 	, @aReg0220 		, @aSLX 	, cFilB1)
	EndIf
	
EndDo

DbSelectArea(cQryAlias)
(cQryAlias)->(DbCloseArea())

If "1"$aWizard[5][7]//Verifica se deve gerar registro 1600
	SPDFGr1600(@aReg1600,@aReg0150,dDataDe,dDataAte,cAlias,aWizard,Nil,lConcFil)
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³SPDFCFPrfC³ Autor ³ Vendas e CRM          ³ Data ³27/11/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua carga dos arrays dos registros de ECF (Cupom Fiscal)³±±
±±³          ³                     (PERFIL C)                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS - SPEDFISCAL (Ambiente TOP)                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function SPDFCFPrfC(aRegC400	, aRegC405	, aRegC410	, aRegC420	,;
					aRegC425	, aRegC460	, aRegC470	, aRegC490	,;
					aRegC495	, aProdB1	, dDataDe	, dDataAte	,;
					cPerfil		, cAlias	, aReg0200	, aReg0190	,;
					lCstPis		, lCstCof	, aReg0220	, aReg1600	,;
					aReg0150	, aWizard	, lTop		, cUf		,;
					nQtReg0200 	, lJob  	, lLegisPer )

Local 	nPos400		:= 0
Local 	nPos405		:= 0
Local 	aPos420		:= {}
Local 	aTotaliz	:= {}
Local 	nY 			:= 0
Local 	nValCof 	:= 0
Local	nValPis 	:= 0
Local 	cAliqISS  	:= ""
Local 	nAliqIss 	:= 0
Local 	aCposAliq 	:= {}
Local 	cCampo		:= ""      						// Utilizada para armazenar o campo encotrad no SF3
Local 	cCodAliq	:= ""							// Codigo dos totalizadores das aliquotas
Local 	cLegTrib	:= "T"							// Legenda de Tributado
Local 	cCampoCod	:= ""      						// Utilizada para armazenar o campo referente ao código da aliquota( Utilizado para validação do PAF-ECF )
Local 	nVlBrtLj  	:= 0
Local 	cQuery 		:= ""
Local 	cQryAlias 	:= GetNextAlias() 				// Alias da Query
Local 	cQryFields 	:= ""  							// Campos da Query
Local 	cFieldAliq 	:= ""							// Campos de Aliquota de ICMS
Local 	cGroupBy	:= ""  							// Group By da Query
Local 	cPDV 		:= ""
Local 	sDtMovto	:= ""
Local 	lConcFil	:= SuperGetMv("MV_COFLSPD",.F.,.T.)


//Legenda de ISS
cAliqISS := cValToChar(SuperGetMv("MV_ALIQISS",,0))
cAliqISS := AllTrim( StrTran(cAliqISS, ",", ".") )
cAliqISS := TransForm(cAliqISS, "@E 99.99")
nAliqIss := Val(SubStr(cAliqISS , 1, At(".", cAliqISS)))
cAliqISS := StrTran(cAliqISS, ".")
cAliqISS := AllTrim(cAliqISS)
If nAliqIss >= 10
	cAliqISS := "S" + PadR(cAliqISS, 4, "0")
Else
	cAliqISS := "S0" + PadR(cAliqISS, 3, "0")
EndIf

//Verifica todos os tipos de aliquotas existentes
DbSelectArea("SX3")
DbSetOrder(2)
DbSeek("FI_BAS" , .T.)
Do While !SX3->(Eof()) .AND. SubStr(SX3->X3_CAMPO,1,6) == "FI_BAS"
	cCampo := AllTrim(SX3->X3_CAMPO)
	//Monta a legenda da tributacao
	If Len(AllTrim(cCampo)) == 7 .OR. Len(AllTrim(cCampo)) == 9
		cLegTrib	:= "T0"	// Acrescenta um zero para entrar no padrao do arquivo
	Else
		cLegTrib	:= "T"
	EndIf
	cCodAliq := Subs(cLegTrib + PadR(AllTrim(StrTran(Subs(cCampo,7,Len(cCampo)) , ",", ".")) , 4 ,"0" ),0,5)
    cCampoCod	:= "FI_COD" + Substr( cCampo, 7, Len(cCampo)-6)
    
    If !(SFI->(FieldPos(cCampoCod)) > 0)
		cCampoCod := ""
    EndIf
    aAdd( aCposAliq, { cCampo, cCampoCod, cCodAliq } )
	SX3->(dbSkip())
Enddo


//----------------------------
//CAMPOS PARA MONTAR A QUERY
//----------------------------
cQryFields := " SFT.FT_PDV, SFT.FT_ENTRADA,"
cQryFields += " SUM(SFT.FT_QUANT) FT_QUANT, SUM(SFT.FT_VALCONT) FT_VALCONT, SUM(SFT.FT_VALPIS) FT_VALPIS, SUM(SFT.FT_VALCOF) FT_VALCOF,"
cQryFields += " SFI.FI_NUMREDZ, SFI.FI_CRO, SFI.FI_NUMFIM, SFI.FI_GTFINAL, SFI.FI_VALCON, SFI.FI_ISS, SFI.FI_DESC, SFI.FI_CANCEL,"
cQryFields += " SFI.FI_SUBTRIB, SFI.FI_ISENTO, SFI.FI_NTRIB, SLG.LG_IMPFISC, SLG.LG_SERPDV,"
//Acrescenta os campos de tributacao (Ex: FI_BAS7, FI_BAS12, FI_BAS18...)
For nY:=1 to Len(aCposAliq)
	cFieldAliq += "SFI." + aCposAliq[nY][1] + ","
	If !Empty(aCposAliq[nY][2])
		cFieldAliq += "SFI." + aCposAliq[nY][2] + ","
	EndIf
Next nY

//Tira a ultima virgula
cFieldAliq := Left(cFieldAliq,Len(cFieldAliq)-1)

cQryFields := cQryFields + cFieldAliq

cGroupBy  := "SFT.FT_PDV, SFT.FT_ENTRADA,"
cGroupBy  += "SFI.FI_NUMREDZ, SFI.FI_CRO, SFI.FI_NUMFIM, SFI.FI_GTFINAL, SFI.FI_VALCON, SFI.FI_ISS, SFI.FI_DESC, SFI.FI_CANCEL,"
cGroupBy  += "SFI.FI_SUBTRIB, SFI.FI_ISENTO, SFI.FI_NTRIB, SLG.LG_IMPFISC, SLG.LG_SERPDV"

If !Empty(cFieldAliq)
	cGroupBy  := cGroupBy + ", " + cFieldAliq
EndIf

	
cQuery := " SELECT "
cQuery += cQryFields
cQuery += " FROM "
cQuery += RetSQLName("SFT") + " SFT, "
cQuery += RetSQLName("SLG") + " SLG, "
cQuery += RetSQLName("SFI") + " SFI "
cQuery += "	WHERE "
cQuery += " SFT.FT_FILIAL = '"+xFilial("SFT")+"'"
cQuery += " AND SFT.FT_TIPOMOV = 'S'"
cQuery += " AND SFT.FT_ESPECIE = 'CF'"
cQuery += " AND SFT.FT_ENTRADA BETWEEN '" + DToS(dDataDe) + "' AND '" + DToS(dDataAte) + "'"
cQuery += " AND SFT.D_E_L_E_T_ = ' '"
cQuery += " AND SFT.FT_DTCANC = ' '"
cQuery += " AND SLG.LG_FILIAL = '" + xFilial("SLG") + "'"
cQuery += " AND SLG.LG_PDV = SFT.FT_PDV"
cQuery += " AND SLG.D_E_L_E_T_ = ' '"
cQuery += " AND SFI.FI_FILIAL = '" + xFilial("SFI") + "'"
cQuery += " AND SFI.FI_PDV = SLG.LG_PDV"
cQuery += " AND SFI.FI_DTMOVTO = FT_ENTRADA"
cQuery += " AND SFI.FI_SERPDV = SLG.LG_SERPDV"
cQuery += " AND SFI.D_E_L_E_T_ = ' '"
cQuery += " GROUP BY " + cGroupBy
cQuery += " ORDER BY SFT.FT_PDV, SFT.FT_ENTRADA"

cQuery := ChangeQuery( cQuery )
DbUseArea( .T., 'TOPCONN', TcGenQry(,,cQuery), cQryAlias, .T., .F. )

//----------------------------
// Processa Registros.
//----------------------------
Do While !(cQryAlias)->(Eof())
	
    cPDV :=  (cQryAlias)->FT_PDV
    
    If !lJob
    	oProcess:Inc2Progress("Processando Cupom Fiscal - PDV " + AllTrim(cPDV) ,"")
    EndIf
    
	RegC400 (@aRegC400, (cQryAlias)->LG_IMPFISC, (cQryAlias)->LG_SERPDV, AllTrim((cQryAlias)->FT_PDV), @nPos400)
	
	//-------------------------------------------
	// Laco por Reducao Z - Por data do Movimento
	//-------------------------------------------
	While !(cQryAlias)->(Eof()) .AND. cPDV==(cQryAlias)->FT_PDV
		
		sDtMovto 	:= (cQryAlias)->FT_ENTRADA
		
		nVlBrtLj := ( (cQryAlias)->FI_VALCON + (cQryAlias)->FI_ISS ) // Valor Bruto, FI_VALCON (Valor contabil) + FI_ISS (Valor de Servicos)
		
		RegC405 (@aRegC405				, nPos400				, SToD((cQryAlias)->FT_ENTRADA)	, (cQryAlias)->FI_CRO	, ;
				(cQryAlias)->FI_NUMREDZ	, (cQryAlias)->FI_NUMFIM, (cQryAlias)->FI_GTFINAL		, nVlBrtLj   			, ;
				@nPos405				, (cQryAlias)->FI_DESC  , (cQryAlias)->FI_CANCEL )
		
		//Reinicia variaveis
		nValCof 	:= 0
		nValPis 	:= 0
		
		//--------------------------------------------------------------------
		//Carrego todos os codigos e valores que foram contabilizados no SFI
		//--------------------------------------------------------------------
		aTotaliz 	:= SPDFTotSFI(.T., cAliqISS, cQryAlias, aCposAliq)
		
		RegC420 (@aRegC420, 	nPos405,   	(cQryAlias)->FI_CRO, 		(cQryAlias)->FI_NUMREDZ,;
				 aTotaliz,		@aPos420)
		
		
		SPDFRgC490 (@aRegC490	, sDtMovto		, nPos405  		, lCstPis	,;
				 	lCstCof  	, cPDV			, @aProdB1		, nPos405	,;
				 	@aReg0200	, @aReg0190 	, @aReg0220 	, @nValCof	,;
				 	@nValPis	)
		
		
		(cQryAlias)->(DbSkip())
	EndDo
	
EndDo

DbSelectArea(cQryAlias)
(cQryAlias)->(DbCloseArea())

If "1"$aWizard[5][7]//Verifica se deve gerar registro 1600
	SPDFGr1600(@aReg1600,@aReg0150,dDataDe,dDataAte,cAlias,aWizard,Nil,lConcFil)
EndIf

Return
