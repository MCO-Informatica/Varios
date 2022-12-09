#Include "Protheus.Ch"
#Include "TopConn.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBOLBB     บAutor  ณSYMM                บ Data ณ  18/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function BOLBB()
	
	Local cPerg			:= Padr("BOLBB",10)
	Local aRegs			:= {}
	Private oBrowse	:= Nil
	Private lOrdem1	:= .T.
	Private oOK 	 	:= LoadBitmap(GetResources(),'WFCHK')
	Private oNO 	 	:= LoadBitmap(GetResources(),'WFUNCHK')
	Private cNumBoleto	:= ""			
	Private cJuros		:= ""
	Private cMensBol4	:= ""	//GetMv("MV_MSBOL1",,"Devolver apos 10 dias do vencimento.")
	Private cMensBol1	:= "PROTESTO CASO NAO PAGO NO VENCIMENTO."
	Private cMensBol2	:= "APOS O VENCIMENTO COBRAR JUROS DE.....R$ "
	Private cMensBol3	:= "APOS O VENCIMENTO COBRAR MULTA DE.....R$ "
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFuncao que cria as perguntas no arquivo SX1ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	BRPCRIASX1(cPerg)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInforma os parametros na telaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !(Pergunte(cPerg,.T.))
		Return()
	EndIf
	
	If MV_PAR07 == 2
		If MsgYesNo("Confirma emissใo do boleto bancแrio?")
			BRPCRIAQRY()
			aRegs:= BRPMNTREGS()
			Processa( {|lEnd| BRPIMPRIME(aRegs,Nil) }, "Aguarde...","Gerando Boletos...",.T.)
			Return()
		EndIf	
	EndIf	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChama as rotinas responsaveis para impressao e exibicaoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	LjMsgRun("Aguarde... Consultando banco de dados",""	,{|| 	CursorWait()	,;
																BRPCRIAQRY()			,;
																aRegs:= BRPMNTREGS()	,;
																BRPMNTTELA(aRegs)		})	

Return()                                                                        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBRPIMPBOL บAutor  ณCaio SYMM           บ Data ณ  06/22/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BRPCRIAQRY()
	
	Local cQry	:= ""
	
//	cQry:="	SELECT E1_NUM,E1_PREFIXO,E1_PARCELA,E1_VENCTO,E1_VENCREA,E1_VALOR,E1_CLIENTE,E1_LOJA,E1_PEDIDO,C5_NUM,C5_NOTA,SE1.R_E_C_N_O_ AS E1_NUMREC"+CRLF
	cQry:="	SELECT E1_NUM,E1_PREFIXO,E1_PARCELA,E1_VENCTO,E1_VENCREA,E1_VALOR,E1_CLIENTE,E1_LOJA,E1_PEDIDO,SE1.R_E_C_N_O_ AS E1_NUMREC"+CRLF
	cQry+="	FROM "+RetSqlName("SE1")+" SE1"+CRLF
//	cQry+=" INNER JOIN "+RetSqlName("SC5")+" SC5 ON E1_PEDIDO = C5_NUM AND C5_FILIAL = '"+xFilial("SC5")+"' AND SC5.D_E_L_E_T_ = ' ' "
	cQry+="	WHERE E1_FILIAL = '"+xFilial("SE1")+"'"+CRLF
	cQry+="	AND E1_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"+CRLF
	cQry+="	AND E1_NUMBOR BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"+CRLF
	cQry+="	AND E1_NATUREZ BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"+CRLF
	cQry+="	AND E1_SALDO > 0"+CRLF
//	cQry+=" AND E1_ORIGEM = 'MATA460'
	cQry+="	AND SE1.D_E_L_E_T_ = ' '"+CRLF
	If MV_PAR08 == 1
		cQry+="	AND E1_NUMBCO <> ' '"+CRLF
	Else
		cQry+="	AND E1_NUMBCO = ' '"+CRLF
	EndIf	
	cQry+="	ORDER BY E1_NUM,E1_PREFIXO,E1_PARCELA,E1_VENCTO,E1_VENCREA,E1_VALOR,E1_CLIENTE,E1_LOJA"	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica se o arquivo esta em usoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Select("TRB1") > 0
		TRB1->(DbCloseArea())
	EndIf                  
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCria instancia de trabalhoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	TcQuery cQry New Alias "TRB1"
	
	TcSetField("TRB1","E1_VENCTO"	,"D",8,0)
	TcSetField("TRB1","E1_VENCREA"	,"D",8,0)
	TcSetField("TRB1","E1_VALOR"	,"N",14,2)
	
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBRPIMPBOL บAutor  ณSYMM                บ Data ณ  06/22/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BRPMNTREGS()
	
	Local aRegs	:= {}
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAdiciona os itens no array para exibir na telaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	TRB1->(DbGoTop())
	If TRB1->(Eof())
		aAdd(aRegs,{.F.		,;
					""		,;
					""		,;
					""		,;
					""		,;
					""		,;
					""		,;
					""		,;
					""		,;
					""		,;
					""		})
	EndIf
	While TRB1->(!Eof())
		aAdd(aRegs,{Iif(MV_PAR07 == 1,.F.,.T.),;
					TRB1->E1_NUM		,;
					TRB1->E1_PREFIXO	,;
					TRB1->E1_PARCELA	,;
					TRB1->E1_VENCTO		,;
					TRB1->E1_VENCREA	,;
					TRB1->E1_VALOR		,;
					TRB1->E1_CLIENTE	,;
					TRB1->E1_LOJA		,;
					TRB1->E1_NUM		,;
					TRB1->E1_NUMREC})
		TRB1->(DbSkip())
	EndDo            
	
Return(aRegs)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBRPIMPBOL บAutor  ณSYMM                บ Data ณ  06/22/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BRPMNTTELA(aCols)
	
	Local oDlg		:= Nil
	Local oFWLayer	:= Nil
	Local oPanel1	:= Nil
	Local aSize		:= MsAdvSize()
	Local aHeader	:= {	" "						,;
							 RetTitle("E1_NUM")		,;
							 RetTitle("E1_PREFIXO")	,;
							 RetTitle("E1_PARCELA")	,;
							 RetTitle("E1_VENCTO")	,;
							 RetTitle("E1_VENCREA")	,;
							 RetTitle("E1_VALOR")	,;
							 RetTitle("E1_CLIENTE")	,;
							 RetTitle("E1_LOJA")	,;
							 RetTitle("C5_NOTA")	}
	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCriacao da Telaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Define MsDialog oDlg Title "Emissใo de Boleto Bancแrio" From aSize[7],000 TO aSize[6]-230,aSize[5]-540 Pixel Of oDlg
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCriacao do FWLAYERณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oFWLayer := FWLayer():New()
		oFWLayer:init( oDlg, .F. )
		          
		oFWLayer:addLine("CABEC",088,.F.)
		oFWLayer:addCollumn("Col01",100,.F.,"CABEC")                                  
		oFWLayer:addWindow("Col01","Win01","Selecione os itens que deseja imprimir",100,.F.,.T.,,"CABEC")
		oPanel1	:= oFWLayer:GetWinPanel("Col01","Win01","CABEC")
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณMontagem da TwBrowse com os NCMSณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oBrowse := TWBrowse():New( 010,010,010,200,,aHeader,;
			{	10																,;
				CalcFieldSize("N",Len(aHeader[2]),TamSx3("E1_NUM")		[1]	,)	,;
				CalcFieldSize("N",Len(aHeader[3]),TamSx3("E1_PREFIXO")	[1]	,)	,;
				CalcFieldSize("N",Len(aHeader[4]),TamSx3("E1_PARCELA")	[1]	,)	,;
				CalcFieldSize("N",Len(aHeader[5]),TamSx3("E1_VENCTO")	[1]	,)	,;
				CalcFieldSize("N",Len(aHeader[6]),TamSx3("E1_VENCREA")	[1]	,)	,;
				CalcFieldSize("N",Len(aHeader[7]),TamSx3("E1_VALOR")	[1]	,)	,;
				CalcFieldSize("N",Len(aHeader[8]),TamSx3("E1_CLIENTE")	[1]	,)	,;
				CalcFieldSize("N",Len(aHeader[9]),TamSx3("E1_LOJA")		[1]	,)	,;
				CalcFieldSize("N",Len(aHeader[10]),TamSx3("C5_NOTA")	[1]	,)}	,;
		oPanel1,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
		
		oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
		BRPSTARRAY(aHeader,aCols)		
		oBrowse:bHeaderClick := {|oObj,nCol| BRPORDER(aHeader,aCols,nCol)}		
		oBrowse:blDblClick := {|| BRPCLICK(aCols)}
		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtiva janela para exibicaoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Activate MsDialog oDlg Centered On Init EnchoiceBar(oDlg,{|| IiF(MsgYesNo("Confirma emissใo do boleto bancแrio?"), (Processa( {|lEnd| BRPIMPRIME(aCols,aHeader) }, "Aguarde...","Gerando Boletos...",.T.),oDlg:End()),.F.)},{|| oDlg:End() })
	
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBRPIMPBOL บAutor  ณ SYMM               บ Data ณ  06/22/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BRPSTARRAY(aHeader,aCols)

	oBrowse:SetArray(aCols)
	oBrowse:bLine := {|| {	If(aCols[oBrowse:nAt,01],oOK,oNO)	,;
							aCols[oBrowse:nAt,2]				,;
							aCols[oBrowse:nAt,3]				,;
							aCols[oBrowse:nAt,4]				,;
							aCols[oBrowse:nAt,5]				,;
							aCols[oBrowse:nAt,6]				,;
							Transform(aCols[oBrowse:nAt,7],"@E 99,999,999,999.99"),;
							aCols[oBrowse:nAt,8]				,;
							aCols[oBrowse:nAt,9]				,;
							aCols[oBrowse:nAt,10]				}}
Return()  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBRPIMPBOL บAutor  ณ SYMM               บ Data ณ  06/22/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BRPCLICK(aCols)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica qual coluna foi clicadaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If oBrowse:nColPos = 1
		aCols[oBrowse:nAt][1] := !aCols[oBrowse:nAt][1]
		oBrowse:DrawSelect()
	EndIf

Return()							

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBRPIMPBOL บAutor  ณ SYMM               บ Data ณ  06/22/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BRPORDER(aHeader,aCols,nCol)
	
	Local nX	:= 0           
	Local nPos	:= nCol
	
	If nPos == 1
		For nX:= 1 To Len(aCols)
			If aCols[nX][1]
				aCols[nX][1]:= .F.			
			Else                  
				aCols[nX][1]:= .T.
			EndIf
		Next nX
	Else
		lOrdem1:= !lOrdem1
		If lOrdem1
			aSort(aCols,,,{|x,y| x[nPos] < y[nPos]})
		Else
			aSort(aCols,,,{|x,y| x[nPos] > y[nPos]})
		EndIf		      
		BRPSTARRAY(aHeader,aCols)
	EndIf
		
	oBrowse:Refresh()
	
Return()
  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBRPIMPBOL บAutor  ณ SYMM               บ Data ณ  06/22/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿RRBPER฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                            
Static Function BRPIMPRIME(aCols,aHeader)
	
	Local nX		:= 0
	Local oPrint	:= Nil
	
	Private nNota
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Inicializa impressao dos boletos.                  		       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oPrint := TMSPrinter():New( "Boleto Laser" )
	oPrint:Setup()
	oPrint:SetPortrait()
	
	ProcRegua(Len(aCols))
	For nX:= 1 To Len(aCols)
		nNota := aCols[nX][10]
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณSe o registro nao estiver marcado nao sera relacionadoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If !(aCols[nX][1])
			Loop
		EndIf               
		
		IncProc("Titulo "+aCols[nX][2]+" Parcela "+aCols[nX][4])
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤุฟ
		//ณPosiciona no registro atraves do recno filtrado na queryณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤุู
		SE1->(DbGoTo(aCols[nX][Len(aCols[nX])]))
		     
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifica se e reimpressaoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If MV_PAR08 == 1		
			If Empty(SE1->E1_NUMBCO)
				Loop
			EndIf
		Else
			If !(Empty(SE1->E1_NUMBCO))
				Loop
			EndIf			
		EndIf	
		
		SA1->( DbSetOrder(1) )
		SA1->( DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA) )
		
		SA6->( DbSetOrder(1) )
		SA6->( DbSeek(xFilial("SA6")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA) )
		If !( AllTrim(SA6->A6_COD) $ "001" )
			MsgAlert("A impressใo de boletos nใo ้ valida para o banco "+AllTrim(SA6->A6_COD),"Aten็ใo")
		Else
			SEE->( DbSetOrder(1) )
			IF !SEE->(DbSeek(xFilial("SEE")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA))
				MsgAlert("Nใo existe os dados de configura็ใo do banco (SEE).","Aten็ใo")
			Else
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณChama funcao para impressaoณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				BRPBOLIMP(oPrint,nNota)
			EndIF
		EndIF
	Next nX
	
	oPrint:EndPage()
	oPrint:Preview()
	
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBRPIMPBOL บAutor  ณ SYMM               บ Data ณ  06/22/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BRPBOLIMP(oPrint,nNota)
    
	Local cCarteira		:= "18"
	Local cValorTit		:= ""
	Local cFatorVcto	:= ""
	Local cConvenio		:= Alltrim(SEE->EE_CODEMP)
	Local cNumBanco		:= AllTrim(SA6->A6_COD)
	Local cAgencia		:= Alltrim(SA6->A6_AGENCIA)
	Local cDigAgencia	:= Alltrim(SA6->A6_DVAGE)
//	Local cNumConta		:= SubStr(Alltrim(StrTran(SA6->A6_NUMCON,"-","")),1,Len(Alltrim(StrTran(SA6->A6_NUMCON,"-","")))-1)
	Local cNumConta		:= Alltrim(SA6->A6_NUMCON)
	Local cDigConta		:= Alltrim(SA6->A6_DVCTA)
	Local cDtVencto		:= Ctod("")
	Local cBitMapBanco	:= GetSrvProfString("Startpath","")+"BB.bmp"
//	Local cNumTit		:= StrZero(Val(SE1->E1_NUM),6)
	Local cNumTit		:= Iif(!Empty(SE1->E1_NFELETR), Alltrim(SE1->E1_NFELETR), StrZero(Val(SE1->E1_NUM),6))
	Local cParcela		:= IIF(Empty(SE1->E1_PARCELA),"0",SE1->E1_PARCELA)	
	Local oFont8  		:= TFont():New("Arial", 9, 08, .T., .F., 5, .T., 5, .T., .F.)
	Local oFont10 		:= TFont():New("Arial", 9, 10, .T., .T., 5, .T., 5, .T., .F.)
	Local oFont11 		:= TFont():New("Arial", 9, 11, .T., .T., 5, .T., 5, .T., .F.)
	Local oFont16 		:= TFont():New("Arial", 9, 16, .T., .T., 5, .T., 5, .T., .F.)
	Local oFont14N		:= TFont():New("Arial", 9, 14, .T., .F., 5, .T., 5, .T., .F.)
	Local oFont22 		:= TFont():New("Arial", 9, 22, .T., .T., 5, .T., 5, .T., .F.)
	Local nValorTit		:= 0
//	Local aAreaSA1		:= {}
	
	cDtVencto := SE1->E1_VENCTO
	nValorTit := SE1->E1_SALDO - SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)

	cFatorVcto := StrZero(cDtVencto - Ctod("07/10/1997"),4)
	
	cValorTit  := Right(StrZero(nValorTit * 100,17,0),10)

	IF nValorTit > 99999999.99
		cFatorVcto:= ""
		cValorTit := Substr(StrZero(nValorTit * 100,17,2),1,14)
	EndIF
                           
	cDigBanco   :=	"9"
	cAgencia    :=	StrZero(Val(cAgencia),4)
	cNumBoleto  :=	BRPRETNBOL(10,cNumBanco)
	cDigitao	:=	BRPDIG2(cConvenio+StrZero(Val(cNumBoleto),10))
	cDadosCta   :=	cAgencia + "-" + cDigAgencia + " / " + cNumConta + "-" + cDigConta

	cDigCodBar	:=	BRPDVBAR(cNumBanco+"9"+cFatorVcto+cValorTit+"000000"+cConvenio+StrZero(Val(cNumBoleto),10)+cCarteira)
	
	cCodBar2	:= cNumBanco + "9" + cDigCodBar + cFatorVcto + cValorTit+"000000"+cConvenio+StrZero(Val(cNumBoleto),10)+cCarteira
                    

   
	cDigblc1	:=	BRPDIG1(cNumBanco + "9" + SubStr(cCodBar2,20,5))	
	cBloco1		:=	Transform(cNumBanco + "9" + SubStr(cCodBar2,20,5)+cDigblc1,"@R 99999.99999")
	cDigblc2	:=	BRPCALBLC2(SubStr(cCodBar2,25,10))
	cBloco2		:= 	Transform(SubStr(cCodBar2,25,10) + cDigblc2,"@R 99999.999999")
	cDigblc3	:=	BRPDIG3(SubStr(cCodBar2,35,10))
	cBloco3		:=	Transform(SubStr(cCodBar2,35,10) + cDigblc3,"@R 99999.999999")
	cBloco4		:=	cFatorVcto + cValorTit        
					
	cCodBarras	:=	cBloco1 +"   "+ cBloco2 +"   "+ cBloco3 +"  "+ cDigCodBar +"   "+ cBloco4

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Inicia nova pagina. 												ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oPrint:StartPage()

	oPrint:Say  (0050, 1700, SM0->M0_EndCOB, oFont10)
	oPrint:Say  (0085, 1700, AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB, oFont10)
	oPrint:Say  (0120, 1700, "CEP: "+TransForm(SM0->M0_CEPCOB, "@R 99999-999"), oFont10)
	oPrint:Say  (0155, 1700, "PABX/FAX: "+SM0->M0_TEL, oFont10)
	oPrint:Say  (0190, 1700, "CNPJ: "+TransForm(SM0->M0_CGC, "@R 99.999.999/9999-99"), oFont10)
	oPrint:Say  (0225, 1700, "I.E.: "+TransForm(SM0->M0_INSC, "@R 999.999.999.999"), oFont10)
	oPrint:Say  (0200, 0100, SM0->M0_NOMECOM, oFont10)

	IF !Empty(cBitMapBanco)
		oPrint:SayBitmap (0040, 0100, cBitMapBanco, 0470, 0110)
	Else
		oPrint:Say  (1334, 0180, SA6->A6_NREDUZ, oFont11)
	EndIF	
	
	oPrint:Box  (0300, 0100, 1200, 2300)
	oPrint:Line (0400, 0100, 0400, 2300)
	oPrint:Line (0600, 0100, 0600, 2300)
	oPrint:Line (0300, 0400, 0400, 0400)
	oPrint:Line (0300, 0800, 0400, 0800)
	oPrint:Line (0300, 1150, 0400, 1150)
	oPrint:Line (0300, 1500, 0400, 1500)
	oPrint:Line (0300, 1850, 0400, 1850)
    
	oPrint:Say  (0315, 0115, "Vencimento", oFont8)
	oPrint:Say  (0345, 0150, DTOC(cDtVencto), oFont10)
	oPrint:Say  (0315, 0415, "Valor R$", oFont8)
	oPrint:Say  (0345, 0550, AllTrim(TransForm(nValorTit, "@E 999,999,999.99")), oFont10)
	oPrint:Say  (0315, 0815, "Data da Opera็ใo", oFont8)
	oPrint:Say  (0345, 0815, DTOC(Date()), oFont10)
	oPrint:Say  (0315, 1165, "Nro.do Documento", oFont8)
	oPrint:Say  (0345, 1165, cNumTit+"-"+cParcela, oFont10)
	oPrint:Say  (0315, 1515, "Ag๊ncia/C๓digo Cedente", oFont8)
	oPrint:Say  (0345, 1515, cDadosCta, oFont10)
	oPrint:Say  (0315, 1865, "Nosso N๚mero", oFont8)
	oPrint:Say  (0345, 1865,cConvenio+cNumBoleto,oFont10)
	oPrint:Say  (0430, 0115, "Dados do Sacado", oFont8) 
	                                   
	oPrint:Say  (0470, 0200, AllTrim(SA1->A1_NOME)+" ("+AllTrim(SA1->A1_COD)+") ", oFont10)
	oPrint:Say  (0505, 0200, Iif(!Empty(SA1->A1_ENDCOB),AllTrim(SA1->A1_ENDCOB)+" ("+AllTrim(SA1->A1_BAIRROC)+") ",AllTrim(SA1->A1_END)+" ("+AllTrim(SA1->A1_BAIRRO)+")"), oFont10)
	oPrint:Say  (0540, 0200, Iif(!Empty(SA1->A1_CEPC),TransForm(SA1->A1_CEPC, "@R 99999-999"),TransForm(SA1->A1_CEP, "@R 99999-999")) +;
							" - " + Iif(!Empty(SA1->A1_MUNC),AllTrim(SA1->A1_MUNC),AllTrim(SA1->A1_MUN))+;
							", "  + Iif(!Empty(SA1->A1_ESTC),SA1->A1_ESTC,SA1->A1_EST), oFont10)

	IF Len(AllTrim(SA1->A1_CGC)) <= 11
		oPrint:Say  (0540, 1500, "CPF: "+TransForm(StrZero(Val(SA1->A1_CGC),11), "@R 999.999.999-99"), oFont10)
	Else
		oPrint:Say  (0540, 1500, "CNPJ: "+TransForm( StrZero(Val(SA1->A1_CGC),14), "@R 99.999.999/9999-99"), oFont10)
	EndIF 
	
	cJuros:= BRPCALMORA(nValorTit) + " AO DIA."
	
	oPrint:Say  (0670, 0115, cMensBol1, oFont10)
	oPrint:Say  (0720, 0115, cMensBol2 + cJuros , oFont10)
	oPrint:Say  (0770, 0115, cMensBol3 + Alltrim(Transform( Round(((nValorTit / 100) * 2) ,2),"@E 999,999,999.99")), oFont10)
	oPrint:Say  (0820, 0115, cMensBol4, oFont10) 
	                                  
	oPrint:Say  (1210, 1605, "Destaque aqui, esta via nใo precisa ser levada ao banco", oFont8)
	oPrint:Line (1400, 0100, 1400, 2300)
	oPrint:Line (1400, 0580, 1300, 0580)
	oPrint:Line (1400, 0800, 1300, 0800)
	oPrint:Say  (1312, 0590, cNumBanco + "-" + cDigBanco, oFont22)
	
	IF !Empty(cBitMapBanco)
		oPrint:SayBitmap( 1260, 0100,cBitMapBanco,450,110 )
	Else
		oPrint:Say  (1334, 0180, SA6->A6_NREDUZ, oFont11)
	EndIF

	oPrint:Say  (1334, 1900, "Via do Sacado", oFont16)
	oPrint:Say  (1450, 0247, "Cedente:", oFont8)
	oPrint:Say  (1448, 0400, SM0->M0_NOMECOM, oFont10)
	oPrint:Say  (1510, 0156, "Nro.Documento:", oFont8)
	oPrint:Say  (1508, 0400, cNumTit+"-"+cParcela, oFont10)
	oPrint:Say  (1510, 1500, "Nosso N๚mero:", oFont8)
	oPrint:Say  (1508, 1725, cConvenio+cNumBoleto, oFont10)
	oPrint:Say  (1570, 0100, "Data do Documento:", oFont8)
	oPrint:Say  (1568, 0400, DTOC(Date()), oFont10)
	oPrint:Say  (1570, 1538, "Vencimento:", oFont8)
	oPrint:Say  (1568, 1725, DTOC(cDtVencto), oFont10)
	oPrint:Say  (1630, 0241, "Valor R$:", oFont8)
	oPrint:Say  (1628, 0400, AllTrim(TransForm(nValorTit, "@E 999,999,999.99")), oFont10)
	oPrint:Line (1700, 0100, 1700, 2300)
	oPrint:Say  (1720, 1000, "Autentica็ใo Mecโnica", oFont8)
	oPrint:Line (2000, 0100, 2000, 2300)
	oPrint:Line (2000, 0580, 1900, 0580)
	oPrint:Line (2000, 0800, 1900, 0800)
	
	IF !Empty(cBitMapBanco)
		oPrint:SayBitmap( 1860, 0100,cBitMapBanco,450,110 )
	Else
		oPrint:Say  (1934, 0180, SA6->A6_NREDUZ, oFont11)
	EndIF
	
	oPrint:Say  (1912, 0590, cNumBanco + "-" + cDigBanco, oFont22)
	oPrint:Say  (1934, 0820, cCodBarras, oFont14N)
	oPrint:Line (2100, 0100, 2100, 2300)
	oPrint:Line (2200, 0100, 2200, 2300)
	oPrint:Line (2270, 0100, 2270, 2300)
	oPrint:Line (2340, 0100, 2340, 2300)
	oPrint:Line (2200, 0500, 2340, 0500)
	oPrint:Line (2270, 0750, 2340, 0750)
	oPrint:Line (2200, 1000, 2340, 1000)
	oPrint:Line (2200, 1350, 2270, 1350)
	oPrint:Line (2200, 1550, 2340, 1550)
	oPrint:Say  (2000, 0100, "Local de Pagamento", oFont8)
	oPrint:Say  (2040, 0100, "PAGAVEL EM QUALQUER BANCO ATษ O VENCIMENTO", oFont10)
	oPrint:Say  (2000, 1910, "Vencimento", oFont8)
	oPrint:Say  (2040, 2290, DTOC(cDtVencto), oFont10,,,,1)
	oPrint:Say  (2100, 0100, "Cedente", oFont8)
	oPrint:Say  (2140, 0100, SM0->M0_NOMECOM, oFont10)
	oPrint:Say  (2100, 1910, "Ag๊ncia/C๓digo Cedente", oFont8)
	oPrint:Say  (2140, 2290, cDadosCta, oFont10,,,,1)
	oPrint:Say  (2200, 0100, "Data do Documento", oFont8)
	oPrint:Say  (2230, 0100, DTOC(Date()), oFont10)
	oPrint:Say  (2200, 0505, "Nro.Documento", oFont8)
	oPrint:Say  (2230, 0505, cNumTit+"-"+cParcela, oFont10)
	oPrint:Say  (2200, 1005, "Esp้cie Doc.", oFont8)
	oPrint:Say  (2230, 1005, "DM", oFont10)
	oPrint:Say  (2200, 1355, "Aceite", oFont8)
	oPrint:Say  (2230, 1355, "N", oFont10)
	oPrint:Say  (2200, 1555, "Data do Processamento", oFont8)
	oPrint:Say  (2230, 1555, DTOC(SE1->E1_EMISSAO), oFont10)
	oPrint:Say  (2200, 1910, "Nosso N๚mero", oFont8)
	oPrint:Say  (2230, 2290, cConvenio+cNumBoleto,oFont10,,,,1)
	oPrint:Say  (2270, 0100, "Uso do Banco", oFont8)
	oPrint:Say  (2270, 0505, "Carteira", oFont8)
	oPrint:Say  (2300, 0505, cCarteira, oFont10)
	oPrint:Say  (2270, 0755, "Esp้cie", oFont8)
	oPrint:Say  (2300, 0755, "R$", oFont10)
	oPrint:Say  (2270, 1005, "Quantidade", oFont8)
	oPrint:Say  (2270, 1555, "Valor", oFont8)
	oPrint:Say  (2270, 1910, "(=)Valor do Documento", oFont8)
	oPrint:Say  (2300, 2290, AllTrim(TransForm(nValorTit, "@E 999,999,999.99")), oFont10,,,,1)
	oPrint:Say  (2340, 0100, "Instru็๕es (Texto de responsabilidade do cedente)", oFont8)
	
	oPrint:Say  (2390, 0100, cMensBol1, oFont10)
	oPrint:Say  (2440, 0100, cMensBol2 + cJuros, oFont10)
	oPrint:Say  (2490, 0100, cMensBol3  + Alltrim(Transform( Round(((nValorTit / 100) * 2) ,2),"@E 999,999,999.99")), oFont10)
	oPrint:Say  (2540, 0100, cMensBol4, oFont10)//Acrescido pela Symm em 28/02/2011	

	oPrint:Say  (2340, 1910, "(-)Desconto/Abatimento", oFont8)
	oPrint:Say  (2410, 1910, "(-)Outras Dedu็๕es", oFont8)
	oPrint:Say  (2480, 1910, "(+)Mora/Multa", oFont8)
	oPrint:Say  (2550, 1910, "(+)Outros Acr้scimos", oFont8)
	oPrint:Say  (2620, 1910, "(-)Valor Cobrado", oFont8)
	oPrint:Say  (2690, 0100, "Sacado", oFont8)
	
	oPrint:Say  (2720, 0400, AllTrim(SA1->A1_NOME)+" ("+AllTrim(SA1->A1_COD)+") ", oFont10)
	oPrint:Say  (2773, 0400, Iif(!Empty(SA1->A1_ENDCOB),AllTrim(SA1->A1_ENDCOB)+" ("+AllTrim(SA1->A1_BAIRROC)+") ",AllTrim(SA1->A1_END)+" ("+AllTrim(SA1->A1_BAIRRO)+")"), oFont10)
	oPrint:Say  (2826, 0400, Iif(!Empty(SA1->A1_CEPC),TransForm(SA1->A1_CEPC, "@R 99999-999"),TransForm(SA1->A1_CEP, "@R 99999-999")) +;
							" - " + Iif(!Empty(SA1->A1_MUNC),AllTrim(SA1->A1_MUNC),AllTrim(SA1->A1_MUN))+;
							", "  + Iif(!Empty(SA1->A1_ESTC),SA1->A1_ESTC,SA1->A1_EST), oFont10)

	If Len(AllTrim(SA1->A1_CGC)) <= 11
		oPrint:Say  (2826, 1500, "CPF: "+TransForm(StrZero(Val(SA1->A1_CGC),11), "@R 999.999.999-99"), oFont10)
	Else
		oPrint:Say  (2826, 1500, "CNPJ: "+TransForm( StrZero(Val(SA1->A1_CGC),14), "@R 99.999.999/9999-99"), oFont10)
	EndIF

	oPrint:Say  (2895, 0100, "Sacador/Avalista", oFont8)
	oPrint:Say  (2885, 0400, "NF. "+cValtoChar(nNota), oFont10)     									          //-> Incluso por CH. em 27-07-2010
	oPrint:Say  (2935, 1500, "Autentica็ใo Mecโnica -", oFont8)
	oPrint:Say  (2935, 1850, "Ficha de Compensa็ใo", oFont10)
	
	oPrint:Line (2000, 1900, 2690, 1900)
	oPrint:Line (2410, 1900, 2410, 2300)
	oPrint:Line (2480, 1900, 2480, 2300)
	oPrint:Line (2550, 1900, 2550, 2300)
	oPrint:Line (2620, 1900, 2620, 2300)
	oPrint:Line (2690, 0100, 2690, 2300)
	oPrint:Line (2930, 0100, 2930, 2300)
	cMasc:= Replicate("9",44)
	//MSBAR3("INT25",25.0,1.0,Transform(cCodBar2,"@R "+cMasc),oPrint,.F.,,,,1.4,.T.,,,.F.)
	MSBAR("INT25",25.5,1.0,cCodBar2,oPrint,.F.,,.T.,0.025,1.4,.F.,NIL,NIL,.F.)
  //	MSBAR("INT25",25.0,1.0,cCodBar2,oPrint,,,,,,,NIL,NIL,.F.)
	                                      
	oPrint:EndPage()    
	
	
Return()
  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBRPIMPBOL บAutor  ณ SYMM               บ Data ณ  06/22/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BRPDIG1(cDadCont)
	
	Local aPesos	:= 	{2,1,2,1,2,1,2,1,2}
	Local nX		:= 	0
	Local nResult1	:=	0
	Local nResult2	:=	0
	Local nResult3	:=	0
	Local aDadCont	:= 	{}
	Local aResult	:= 	{}
	
	For nX	:= 1 To Len(Alltrim(cDadCont))
		aAdd(aDadCont,Val(SubStr(Alltrim(cDadCont),nX,1)))
	Next nX                                          
	
	For nX:= 1 To Len(aPesos)
		aAdd(aResult,aPesos[nX]*aDadCont[nX])		
	Next nX                    
	
	For nX:= 1 To Len(aResult)
		If Len(Alltrim(Str(aResult[nX]))) > 1
			aResult[nX]	:= Val(SubStr(Alltrim(Str(aResult[nX])),1,1)) + Val(SubStr(Alltrim(Str(aResult[nX])),2,1))
		EndIf
	Next                 
	
	For nX:= 1 To Len(aResult)
		nResult1	+= aResult[nX]
	Next nX
		
	nResult2	:= Mod(nResult1,10)
	nResult3	:= 10 - nResult2
	
Return(Iif(Alltrim(Str(nResult3)) == "10","0",Alltrim(Str(nResult3))))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBRPIMPBOL บAutor  ณ SYMM               บ Data ณ  06/22/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                      
Static Function BRPDIG2(cNossoNum)
	
	Local aDados1	:=	{}
	Local aPesos	:=	{1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2}
	Local aResult	:=	{}
	Local nResult1	:=	0
	Local nResult2	:=	0
	Local nResult3	:=	0
	Local nX		:=	0
	
	For nX:= 1 To Len(cNossoNum)
		aAdd(aDados1,Val(SubStr(cNossoNum,nX,1)))
	Next nX
	
	For nX:= 1 To Len(aDados1)
		aAdd(aResult,aPesos[nX]*aDados1[nX])	
	Next nX
	
	For nX:= 1 To Len(aResult)
		If Len(Alltrim(Str(aResult[nX]))) > 1
			aResult[nX]	:= Val(SubStr(Alltrim(Str(aResult[nX])),1,1)) + Val(SubStr(Alltrim(Str(aResult[nX])),2,1))
		EndIf
	Next                 
	
	For nX:= 1 To Len(aResult)
		nResult1	+= aResult[nX]
	Next nX
		
	nResult2	:= Mod(nResult1,10)
	nResult3	:= 10 - nResult2
	
Return(Iif(Alltrim(Str(nResult3)) == "10","0",Alltrim(Str(nResult3))))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBRPIMPBOL บAutor  ณ SYMM               บ Data ณ  06/22/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BRPCALBLC2(cBloco2)
	
	Local aDados1	:=	{}
	Local aPesos	:=	{1,2,1,2,1,2,1,2,1,2}
	Local aResult	:=	{}
	Local nResult1	:=	0
	Local nResult2	:=	0
	Local nResult3	:=	0
	Local nX		:=	0
	
	For nX:= 1 To Len(cBloco2)
		aAdd(aDados1,Val(SubStr(cBloco2,nX,1)))
	Next nX
	
	For nX:= 1 To Len(aDados1)
		aAdd(aResult,aPesos[nX]*aDados1[nX])	
	Next nX
	
	For nX:= 1 To Len(aResult)
		If Len(Alltrim(Str(aResult[nX]))) > 1
			aResult[nX]	:= Val(SubStr(Alltrim(Str(aResult[nX])),1,1)) + Val(SubStr(Alltrim(Str(aResult[nX])),2,1))
		EndIf
	Next                 
	
	For nX:= 1 To Len(aResult)
		nResult1	+= aResult[nX]
	Next nX
		
	nResult2	:= Mod(nResult1,10)
	nResult3	:= 10 - nResult2	
	
Return(Iif(Alltrim(Str(nResult3)) == "10","0",Alltrim(Str(nResult3))))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBRPIMPBOL บAutor  ณ SYMM               บ Data ณ  06/22/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BRPDIG3(cNossoNum)
	
	Local aPesos	:=	{1,2,1,2,1,2,1,2,1,2}
	Local aDados1	:=	{}
	Local aResult	:=	{}
	Local nResult1	:=	0
	Local nResult2	:=	0
	Local nResult3	:=	0
	Local nX		:=	0
	
	For nX:= 1 To Len(cNossoNum)
		aAdd(aDados1,Val(SubStr(cNossoNum,nX,1)))
	Next nX
	
	For nX:= 1 To Len(aDados1)
		aAdd(aResult,aPesos[nX]*aDados1[nX])	
	Next nX
	
	For nX:= 1 To Len(aResult)
		If Len(Alltrim(Str(aResult[nX]))) > 1
			aResult[nX]	:= Val(SubStr(Alltrim(Str(aResult[nX])),1,1)) + Val(SubStr(Alltrim(Str(aResult[nX])),2,1))
		EndIf
	Next                 
	
	For nX:= 1 To Len(aResult)
		nResult1	+= aResult[nX]
	Next nX
		
	nResult2	:= Mod(nResult1,10)
	nResult3	:= 10 - nResult2
	
Return(Iif(Alltrim(Str(nResult3)) == "10","0",Alltrim(Str(nResult3))))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBRPIMPBOL บAutor  ณ SYMM               บ Data ณ  06/22/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BRPDVBAR(cCodBar)

Local i := 0
Local nCont := 0
Local cPeso := 2
Local Resto := 0
Local Result := 0
//Local nResult:= 0
Local nDV_BARRA := 0


	For i := 43 To 1 Step -1
		nCont := nCont + ( Val( SUBSTR( cCodBar,i,1 )) * cPeso )
		cPeso := cPeso + 1
		If cPeso >  9
			cPeso := 2
		Endif
	Next
	
	Resto  := ( nCont % 11 )
	Result := ( 11 - Resto )
	
	If Result >= 10 .or. Result == 0
		nDV_BARRA := "1"
	Else
		nDV_BARRA := Str(Result,1)
	Endif
	
//	Do Case
//		Case nResult == 10 .or. nResult == 0 .or. nResult == 1
//			nDV_BARRA := "1"
//		OtherWise
//			nDV_BARRA := Str(nResult,1)
//	EndCase

Return (nDV_BARRA)

 /*
 
 	
	Local aPesos	:=	{4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2}
	Local aDados1	:=	{}
	Local aResult	:=	{}
	Local nResult1	:=	0
	Local nResult2	:=	0
	Local nResult3	:=	0
	Local nX		:=	0
	
	For nX:= 1 To Len(cCodBar)
		aAdd(aDados1,Val(SubStr(cCodBar,nX,1)))
	Next nX
	
	For nX:= 1 To Len(aDados1)
		aAdd(aResult,aPesos[nX]*aDados1[nX])	
	Next nX
	
	For nX:= 1 To Len(aResult)
		If Len(Alltrim(Str(aResult[nX]))) > 1
			aResult[nX]	:= Val(SubStr(Alltrim(Str(aResult[nX])),1,1)) + Val(SubStr(Alltrim(Str(aResult[nX])),2,1))
		EndIf
	Next                 
	
	For nX:= 1 To Len(aResult)
		nResult1	+= aResult[nX]
	Next nX              
	
	nResult2	:= Mod(nResult1,11)
	nResult3	:= 11 - nResult2	
	
	If nResult3 == 10 .Or. nResult3 == 0 .Or. nResult3 == 1 .Or. nResult3 == 11
		nResult3	:= 1
	EndIf
*/		
Return(Alltrim(Str(nResult3)))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBRPIMPBOL บAutor  ณ SYMM               บ Data ณ  06/22/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BRPRETNBOL(nTam,cNumBanco)

	Local cNumero

	IF Empty(SE1->E1_NUMBCO)
		cNumero := StrZero(Val(SEE->EE_FAXATU),nTam)
		
		DbSelectArea("SE1")
		RecLock("SE1",.F.)
			SE1->E1_NUMBCO := cNumero
			SE1->E1_IDCNAB := cNumero		// PARA POSSIBILITAR A BAIXA AUTOMมTICA POSTERIOMENTE.
		MsUnlock()
		
		DbSelectArea("SEE")
		RecLock("SEE",.F.)
			Replace EE_FAXATU With StrZero(Val(cNumero)+1,10)
		MsUnlock()
	Else
		cNumero:= StrZero(Val(SE1->E1_NUMBCO),nTam)
	EndIF

Return(cNumero)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBRPIMPBOL บAutor  ณ SYMM               บ Data ณ  06/22/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/  
Static Function BRPCALMORA(nValorTit)
	
	Local nPrcMes	:= GetMv("MV_PRCMES",,3)
	Local nResult	:= 0
	
	nResult	:= ((nPrcMes/100)/30)*nValorTit
		
Return(Alltrim(Transform(nResult,"@E 999,999,999.99")))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBRPIMPBOL บAutor  ณ SYMM               บ Data ณ  06/22/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BRPCRIASX1(cPerg)
	
	PutSx1( cPerg,"01","Emissao De ?"			,"","","mv_ch1","D",08,0,0,"G","","","","","mv_par01",,,,,,,,,,,,,,,,,{"Emissao De para considerar no filtro."},{},{} )
	PutSx1( cPerg,"02","Emissao Ate ?"			,"","","mv_ch2","D",08,0,0,"G","","","","","mv_par02",,,,,,,,,,,,,,,,,{"Emissao Ate para considerar no filtro."},{},{} )
	PutSx1( cPerg,"03","Bordero De ?"			,"","","mv_ch3","C",06,0,0,"G","","","","","mv_par03",,,,,,,,,,,,,,,,,{"Bordero De para considerar no filtro."},{},{} )
	PutSx1( cPerg,"04","Bordero Ate ?"			,"","","mv_ch4","C",06,0,0,"G","","","","","mv_par04",,,,,,,,,,,,,,,,,{"Bordero Ate para considerar no filtro."},{},{} )
	PutSx1( cPerg,"05","Natureza De ?"			,"","","mv_ch5","C",10,0,0,"G","","","","","mv_par05",,,,,,,,,,,,,,,,,{"Natureza De para considerar no filtro."},{},{} )
	PutSx1( cPerg,"06","Natureza Ate ?"			,"","","mv_ch6","C",10,0,0,"G","","","","","mv_par06",,,,,,,,,,,,,,,,,{"Natureza Ate para considerar no filtro."},{},{} )
	PutSx1( cPerg,"07","Seleciona titulos ?"	,"","","mv_ch7","N",01,0,1,"C","","","","","mv_par07","Sim","","","","Nใo","","","","","","",,,,,,{"Seleciona Titulos","para considerar na","gera็ใo do relat๓rio."},{},{})
	PutSx1( cPerg,"08","Reimpressใo ?"			,"","","mv_ch8","N",01,0,1,"C","","","","","mv_par08","Sim","","","","Nใo","","","","","","",,,,,,{"Reimpressใo","para considerar na","gera็ใo do relat๓rio."},{},{})
	
	
Return()