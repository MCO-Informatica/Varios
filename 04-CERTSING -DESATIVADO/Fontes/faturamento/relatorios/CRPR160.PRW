#Include "Totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma: CRPR160    บAutor  ณRenato Ruy Bernardo บ Data ณ  15/05/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de Regras de Remuneracao da campanha / clube.    บฑฑ
ฑฑบ          ณ 			                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CRPR160()

Local aPergs 	:= {}
Local cCodRec 	:= space(08)
Local lRet

Private aPedidos:= {}
Private aRet 	:= {}
Private cPedIn	:= ""
Private cPerg   := "CRP160"

//ValidPerg()
//pergunte(cPerg,.T.)  

aAdd( aPergs ,{11,"Pedidos",""					,'.T.','.T.',.F.})
aAdd( aPergs ,{6 ,"Gravar arquivo" 	,Space(70)	,""	  ,"","",50,.F.,"Arquivos .XML |*.XML"})

If !ParamBox(aPergs ,"Parametros ",aRet)
	Alert("O relat๓rio foi cancelado!")
	Return
EndIf

//Cria um array para nใo estourar a quantidade de pedidos
aPedidos := StrToArray(aRet[1],chr(13)+chr(10))

if Len(aPedidos) == 0
	Alert("A pesquisa somente pode continuar se existir mais de um pedido!")
	Return
EndIf

Processa( {|| GerReg() }, "Selecionando registros...")

Return

//Processamento do relat๓rio

Static Function GerReg

Local oExcel 		:= FWMSEXCEL():New()
Local cAcAnt		:= ""
Local nQtd			:= 0
Local nPercent		:= 0
Local cStatus		:= ""
Local cRede			:= ""

//Cria nova aba
oExcel:AddworkSheet("Geral")

//Cria Cabecalho da tabela
oExcel:AddTable ("Geral","Geral")


//Adiciona cabecalho dos itens
oExcel:AddColumn("Geral","Geral","AC" 				, 2,1)
oExcel:AddColumn("Geral","Geral","Pedido Gar" 		, 2,1)
oExcel:AddColumn("Geral","Geral","Produto" 			, 2,1)
oExcel:AddColumn("Geral","Geral","Pedido Anterior"	, 2,1)
oExcel:AddColumn("Geral","Geral","Codigo Voucher"	, 2,1)
oExcel:AddColumn("Geral","Geral","Tipo Voucher"		, 2,1)
oExcel:AddColumn("Geral","Geral","Porc.Campanha"	, 2,1)
oExcel:AddColumn("Geral","Geral","Valor SW"			, 2,1)
oExcel:AddColumn("Geral","Geral","Valor HW"			, 2,1)
oExcel:AddColumn("Geral","Geral","Codigo Parceiro"	, 2,1)
oExcel:AddColumn("Geral","Geral","Nome Parceiro"	, 2,1)
oExcel:AddColumn("Geral","Geral","Codigo Vendedor"	, 2,1)
oExcel:AddColumn("Geral","Geral","Nome Vendedor"	, 2,1)
oExcel:AddColumn("Geral","Geral","Status"			, 2,1)

cAcAnt := "Geral"


//Se posiciona na SZ5 - Filial + Pedido Gar
SZ5->(DbSetOrder(1))

//Se posiciona na SZ4 - Filial + Codigo Entidade
SZ4->(DbSetOrder(1))

//Se posiciona na SZ3 - Filial + Codigo Entidade
SZ3->(DbSetOrder(1))

ProcRegua(Len(aPedidos))

For nI := 1 To Len(aPedidos)

	nQtd += 1
	
	IncProc( "Exportando " + AllTrim(Str(nQtd)) + " --> Pedido: " + aPedidos[nI] )
	ProcessMessage()
	
	If !SZ5->(DbSeek(xFilial("SZ5")+aPedidos[nI]))
		//Adiciona Itens
		oExcel:AddRow("Geral","Geral",{ cRede,	aPedidos[nI]	,;
												" "	,;
								                " "	,; 
								                " "	,; 
								                " "	,; 
								                " "	,; 
								                " "	,; 
								                " "	,; 
								                " "	,; 
								                " "	,; 
								                " "	,;
								                " "	,;
								                "Pedido nใo encontrado na base"	})
		loop
	Endif
	
	nPercent := 0
	If SZ4->(DbSeek(xFilial("SZ4")+SZ5->Z5_CODPAR))
		nPercent := SZ4->Z4_PORSOFT
	Endif
	
	SZ3->(DbSeek(xFilial("SZ3")+SZ5->Z5_CODPAR))
	
	cRede := StaticCall(CRPA020,CRR20RD,SZ5->Z5_DESREDE)
	
	If Empty(cRede)
		cStatus := "Pedido nใo tem link da campanha."
	ElseIf SZ5->Z5_VALORSW + SZ5->Z5_VALORHW < 1
		cStatus := "Sem valor base para calculo."
	Elseif SZ5->Z5_COMSW < 1 .And. nPercent < 1
		cStatus := "Sem percentual para calculo."
	Elseif AllTrim(SZ5->Z5_TIPVOU) $ "1/3/5/6/7/8/C/D/G" .OR.;
		  (AllTrim(SZ5->Z5_TIPVOU) == "E" .And. !("CERTIFIQUE ON LINE" $ UPPER(SZ5->Z5_NOMPAR)))
		cStatus := "Tipo de voucher nao e remunerado."	
	Elseif AllTrim(SZ5->Z5_TIPVOU) == "F"
		SZF->(DbSetOrder(2))
		If SZF->(DbSeek(xFilial("SZF")+SZ5->Z5_CODVOU)) .And. SZF->ZF_CAMPANH == "2"
			cStatus := "O pedido nใo ้ remunerado na campanha/clube, conforme informado no voucher."
		Else 
			cStatus := "Pedido remunerado."	
		Endif	
	Elseif !(AllTrim(cRede) $ "BR/SIN/NOT/SINRJ/FACES/FENCR") .And. (!Empty(SZ5->Z5_PEDGANT) .OR. AllTrim(SZ5->Z5_TIPVOU) == 'H' .OR. 'RENOVACAO' $ UPPER(SZ5->Z5_DESGRU))
		cStatus := "Pedido de renovacao nao remunerado."
	Elseif "/"+AllTrim(SZ5->Z5_PRODGAR)+"/" $ "/REGSRFA3PF1AESHV2/NOTSRFA3PF1AESHV2/SINSRFA3PFSC1AESHV2/REGSRFA3PJTO18MCNSESHV2/SINSRFA3PJTO18MCNSESHV2/NOTSRFA3PJTO18MCNSESHV2/NOTSRFA3PJSC18MCNSESHV2/REGSRFA3PJSC18MCNSESHV2/SINSRFA3PJSC18MCNSESHV2/SRFA3PJSC18MCNSESHV2/SRFA3PJSC18MCNSESHV5/SRFA3PJSL18MCNSESHV5/SRFA3PJTO18MCNSESBVLEGHV5/SRFA3PJTO18MCNSESHV2/SRFA3PJTO18MCNSESHV5/NOTSRFA3PJTO18MCNSESHV5/" .And.;
			!("FACESP"$UPPER(SZ5->Z5_NOMPAR) .Or. "ACSP"$UPPER(SZ5->Z5_NOMPAR) .Or. "MOGIANA"$UPPER(SZ5->Z5_NOMPAR)) 
		cStatus := "Produto nao remunerado."
	Elseif "/"+AllTrim(SZ5->Z5_PRODGAR)+"/" $ "/SRFA3PJSC18MCNSESHV2/SRFA3PJSC18MCNSESHV5/SRFA3PJSL18MCNSESHV5/SRFA3PJTO18MCNSESBVLEGHV5/SRFA3PJTO18MCNSESHV2/SRFA3PJTO18MCNSESHV5/" .And. !AllTrim(cRede) $ "CACB/CNC/CRD" .And. !"REVENDEDOR" $ UPPER(SZ5->Z5_DESREDE)
		cStatus := "Produto somente e remunerado para credenciada."
	Elseif (SubStr(SZ5->Z5_PRODGAR,1,3) == "SRF" .And. !(AllTrim(cRede) $ "CNC/CRD/CACB/BR/NOT/SIN/SINRJ/FACES") .And. AllTrim(SZ5->Z5_CODPAR) != "3179") .And. !("REVENDEDOR" $ UPPER(cRede))
		cStatus := "Produto SRF somente e remunerado para CNC, Credenciada, CACB, BR, Sincor, Sincor RJ e Notarial."
	Elseif SubStr(SZ5->Z5_PRODGAR,1,3) == "OAB" .And. !("REVENDEDOR" $ UPPER(cRede))
		cStatus := "Produto OAB nao e remunerado."
	ElseIf "REG" $ SZ5->Z5_PRODGAR .And. SUBSTR(cRede,1,2) <> "BR" .And. SUBSTR(cRede,1,3) <> "NOT" .And. cRede <> "ICP"  .And. !("REVENDEDOR" $ UPPER(cRede))
		cStatus := "Produto REG nao e remunerado para rede " + cRede
	ElseIf "NOT" $ SZ5->Z5_PRODGAR .And. SUBSTR(cRede,1,3) <> "NOT" .And. SUBSTR(cRede,1,2) <> "BR" .And. cRede <> "ICP" .And. !("REVENDEDOR" $ UPPER(cRede))
		cStatus := "Produto NOT nao e remunerado para rede " + cRede
	ElseIf "SIN" $ SZ5->Z5_PRODGAR .And. SUBSTR(cRede,1,3) <> "SIN" .And. cRede <> "FENCR" .And. !("REVENDEDOR" $ UPPER(cRede))
		cStatus := "Produto SIN nao e remunerado para rede " + cRede
	ElseIf (SZ3->Z3_CODCCR == "072855" .And. "PSAR SECOVI" $ UPPER(SZ5->Z5_DESGRU))
		cStatus := "Pedidos da PSAR SECOVI sใo zerados automaticamente."
	ElseIf "GRUPO DIGITALSEG" $ UPPER(SZ6->Z6_DESGRU)	
		cStatus := "Grupo Digitalseg, nใo e remunerado por ter tabela de pre็os diferenciada.
	Else
		cStatus := "Pedido remunerado."	
	EndIf
	
	//Adiciona Itens
	oExcel:AddRow("Geral","Geral",{ cRede,	SZ5->Z5_PEDGAR	,;
											SZ5->Z5_PRODGAR	,;
							                SZ5->Z5_PEDGANT	,; 
							                SZ5->Z5_CODVOU	,; 
							                SZ5->Z5_TIPVOU	,; 
							                Iif( nPercent > 0, nPercent, SZ5->Z5_COMSW)	,; 
							                SZ5->Z5_VALORSW	,; 
							                SZ5->Z5_VALORHW	,; 
							                SZ5->Z5_CODPAR	,; 
							                SZ5->Z5_NOMPAR	,; 
							                SZ5->Z5_CODVEND	,;
							                SZ5->Z5_NOMVEND	,;
							                cStatus			})
		
Next
	
//Salva o Arquivo
oExcel:Activate()
oExcel:GetXMLFile(AllTrim(aRet[2])) 

MsgInfo("Arquivo Exportado para: " + AllTrim(aRet[2]))

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ValidPerg บAutor  ณRenato Ruy Bernardo    บ Data ณ  04/06/2013บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo Responsavel por criar as perguntas utilizadas no    บฑฑ
ฑฑบ          ณ Relat๓rio.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg()
Local aHelp		:=	{}


cPerg := PADR( cPerg, Len(SX1->X1_GRUPO) )


//    ( [ cGrupo ] 	[ cOrdem ] 	[ cPergunt ] 				[ cPerSpa ] 				[ cPerEng ] 				[ cVar ] 	[ cTipo ] 	[ nTamanho ] 	[ nDecimal ] 	[ nPresel ] [ cGSC ] 	[ cValid ] 	[ cF3 ] 	[ cGrpSxg ] [ cPyme ] 	[ cVar01 ] 	[ cDef01 ] 			[ cDefSpa1 ] 		[ cDefEng1 ] 		[ cCnt01 ] [ cDef02 ] 		[ cDefSpa2 ] 	[ cDefEng2 ] 	[ cDef03 ] [ cDefSpa3 ] [ cDefEng3 ] 	[ cDef04 ] 	[ cDefSpa4 ] 	[ cDefEng4 ] 	[ cDef05 ] 	[ cDefSpa5 ] 	[ cDefEng5 ] 	 [ aHelpPor ] 	[ aHelpEng ] 	 	[ aHelpSpa ] 		[ cHelp ] 	)
PutSX1(	cPerg		,"01" 		,"Data De?"		  			,"Data De?"	 		  		,"Data De?"	 		  		,"mv_ch1" 	,"D" 		,08     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par01"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"02" 		,"Data Ate?"	  			,"Data Ate?" 		  		,"Data Ate?"	  			,"mv_ch2" 	,"D" 		,08     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par02"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"03" 		,"Diretorio ?"	  			,"Diretorio ?"		  		,"Diretorio ?"		  		,"mv_ch3" 	,"C" 		,75     		,0      		,0     		,"C"		,"U_CRPR160A",""	    ,""         ,"S"        ,"mv_par03"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   		  	,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
//PutSX1(	cPerg		,"02" 		,"Entidade Ate?"	  		,"Entidade Ate?"	  		,"Entidade Ate?"	  		,"mv_ch2" 	,"C" 		,06     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par02"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTSA01   บAutor  ณMicrosiga           บ Data ณ  01/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CRPR160A()
Local cAux := ""
Local cDirIn := ""

MV_PAR03 := IIF(!Empty(cAux:=(cGetFile("\", "Diret๓rios", 1,"X:\" ,.F. , GETF_RETDIRECTORY+GETF_LOCALHARD ))),cAux,cDirIn)

Return(.T.)