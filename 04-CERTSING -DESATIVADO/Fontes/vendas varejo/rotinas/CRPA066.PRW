#include 'protheus.ch'
#include 'parmtype.ch'

/******
*
**********************************************
* CONJUNTO DE DADOS PARA ACESSO AO CHECK-OUT *
**********************************************
*
* [TESTE]
* url...... = https://checkout-teste.certisign.com.br
* endpoint. = /rest/api/pedidos
* user..... = 9a7d0de2-06be-4339-ae40-ebf83ae88cd9
* password. = PfMlXkE1BK+PZWeRSLxmdw==
*
* [HOMOLOG]
* url...... = https://checkout-homolog.certisign.com.br
* endpoint. = /rest/api/pedidos
* user..... = 0cfda315-4a15-4708-bad1-f87deb24b49b
* password. = xcflRpM5AGmG7GukTYA5OQ==
*
* [PRODUCAO]
* url...... = https://checkout.certisign.com.br
* endpoint. = /rest/api/pedidos
* user..... = 7516d708-b733-4f5a-aae5-fbb2955c0c45
* password. = SOwY3RCA9sOSgtM68MxmQQ==
*
***/
User Function CRPA066()

    Local aPergs    := {}
    Local aPedidos  := {}

    Private aRet    := {}

    aAdd(aPergs, {11, "Pedidos", "", '.T.', '.T.', .T.})

    If !Parambox(aPergs, "Parâmetros", @aRet)
        Alert("Processo interrompido.")
        Return
    EndIf

    aPedidos := StrToArray(aRet[1], CHR(13) + CHR(10))

    Processa({|| CRPA66A(aPedidos) }, "Verificando pedidos.")

Return

Static Function CRPA66A(aPedidos)

	Local cURL			:= ""
	Local cEndPoint		:= ""
	Local cUser			:= ""
	Local cPassWord		:= ""
	Local cGetResult	:= ""
	Local cC5_XNPSITE 	:= ""
	Local cC6_PEDGAR	:= ""
	Local cMsgLog		:= ""
	Local cMsgVoucher	:= ""
	Local cPedGarAnt	:= ""
	Local cParam 		:= '?pedido_gar='
	Local oChkOut		:= Nil
	Local o881Rest		:= Nil
	Local oPSite		:= Nil
	Local o881Result	:= Nil
	Local aHeadStr		:= {}
	Local aLog			:= {}
	Local Ni			:= 0
	Local nCnt			:= 0
	Local nItens		:= 0	
	Local lDeserialize	:= .F.
	Local lGet			:= .F.
	Local lIgual		:= .F.
	
	For Ni := 1 To Len(aPedidos)

        IncProc()
        ProcessMessage()

		oChkOut := checkoutParam():get()
		
		cURL      := oChkOut:url
		cEndPoint := oChkOut:endPoint
		cUser     := oChkOut:userCode
		cPassWord := oChkOut:password
	
		AAdd( aHeadStr, "Content-Type: application/json" )
		AAdd( aHeadStr, "Accept: application/json" )
		AAdd( aHeadStr, "Authorization: Basic " + EnCode64( cUser + ":" + cPassword ) )
		
		// Host para consumo REST.
		o881Rest := FWRest():New( cURL )
		
		// Primeiro path aonde será feito a requisição
		o881Rest:setPath( cEndPoint + cParam + aPedidos[Ni] )
		
		// Efetuar o GET para completar a conexão.
		lGet := o881Rest:Get( aHeadStr )
		
		cGetResult := o881Rest:GetResult()
		
		If FwJsonDeserialize(cGetResult,@oPSite) .AND. ValType(oPSite)=='A' .AND. Len(oPSite)==1 .AND. Type('oPSite[1]:codigo')=='N'
			If oPSite[ 1 ]:codigo == 500
				cGetResult := '[ ]'
			Endif
		Endif
		
		// Se conseguiu fazer o GET e houve retorno de dados.
		If lGet .AND. cGetResult <> '[ ]' .AND. cGetResult <> '{ }'
			// Deserializar o retorno em objeto.
			lDeserialize := FWJsonDeserialize( cGetResult, @o881Result )
		Endif
	
		// Se conseguiu fazer o GET e houve retorno de dados e conseguiu deserealizar.
		If lGet .AND. cGetResult <> '[ ]' .AND. cGetResult <> '{ }' .AND. lDeserialize
		
			cC5_XNPSITE := cValToChar( o881Result[1]:numero )
			
			//cC6_XIDPED := cValToChar(o881Result[1]:itens[1]:id)
			//cC6_PEDGAR := cValToChar(o881Result[1]:itens[1]:numeroPedidoOrigem)
			
			//Tenta localizar na SC5 o Pedido do Checkout
			dbSelectArea("SC5")
			SC5->(dbOrderNickName("PEDSITE"))
			If SC5->(dbSeek(xFilial("SC5") + cC5_XNPSITE))
				
				dbSelectArea("SC6")
				SC6->(dbSetOrder(1))
				If SC6->(dbSeek(xFilial("SC6") + SC5->C5_NUM))
					
					
					
					If Empty(SC6->C6_PEDGAR)
						
						While SC6->(!EoF()).And. SC6->C6_NUM == SC5->C5_NUM 
							
							If Substr(SC6->C6_XSKU,1,2) != "CB"
							
								RecLock("SC6",.F.)
									SC6->C6_PEDGAR := aPedidos[Ni]
								SC6->(MsUnlock())
								
								cMsgLog := aPedidos[Ni] + ";" + cC5_XNPSITE + ";" + SC6->C6_NUM + ";Alterar Pedgar:" + SC6->C6_PEDGAR
														
							ElseIf Substr(SC6->C6_XSKU,1,2) == "CB"
								
								cC6_PEDGAR := getPGarById(SC6->C6_XIDPED, o881Result[1])
								
								If AllTrim(SC6->C6_PEDGAR) != cC6_PEDGAR
									
									RecLock("SC6",.F.)
										SC6->C6_PEDGAR := aPedidos[Ni]
									SC6->(MsUnlock())
									
									cMsgLog := aPedidos[Ni] + ";" + cC5_XNPSITE + ";" + SC6->C6_NUM + ";Alterar Pedgar:" + SC6->C6_PEDGAR
									
								EndIf
								
							EndIf
							
							//cMsgLog := aPedidos[Ni] + ";" + cC5_XNPSITE + ";" + SC6->C6_NUM + ";Pedgar Alterado:" + SC6->C6_PEDGAR
							
							SC6->(dbSkip())
						EndDo
					
						//aAdd(aLog, aPedidos[Ni] + ";" + cC5_XNPSITE + ";" + SC6->C6_NUM + ";sem Pedgar - Itens:" + cValToChar(nItens))
						//cMsgLog := aPedidos[Ni] + ";" + cC5_XNPSITE + ";" + SC5->C5_NUM + ";sem Pedgar - Itens:" + cValToChar(nItens)

					Else
						While SC6->(!EOF()) .And. SC6->C6_NUM == SC5->C5_NUM
							
							If Substr(SC6->C6_XSKU,1,2) == "CB"
								cC6_PEDGAR := getPGarById(SC6->C6_XIDPED, o881Result[1])
								If AllTrim(SC6->C6_PEDGAR) != cC6_PEDGAR //.And. !Empty(cC6_PEDGAR)
									cPedGarAnt := SC6->C6_PEDGAR
									RecLock("SC6",.F.)
										SC6->C6_PEDGAR := cC6_PEDGAR
									SC6->(MsUnlock())
									cMsgLog := aPedidos[Ni] + ";" + cC5_XNPSITE + ";" + SC6->C6_NUM+SC6->C6_ITEM + ";Kit Combo Pedgar Alterado: " + cPedGarAnt + " -> " +cC6_PEDGAR 
								EndIf
								
							Else
								
								If Empty(SC6->C6_PEDGAR)
									cMsgLog := aPedidos[Ni] + ";" + cC5_XNPSITE + ";" + SC6->C6_NUM + SC6->C6_ITEM + ";Pedgar vazio"
								EndIf

								If Substr(SC6->C6_XSKU,1,2) == "KT"
									RecLock("SC6",.F.)
										SC6->C6_PEDGAR := aPedidos[Ni]
									SC6->(MsUnlock())
									cMsgLog += ";PEDGAR Alterado Para: " + aPedidos[Ni]
								EndIf
								
							EndIf

							SC6->(dbSkip())
						EndDo
					
						If Empty(cMsgLog)
							cMsgLog := aPedidos[Ni] + ";" + cC5_XNPSITE + ";" + SC5->C5_NUM + ";Pedgar preenchido"
						EndIf
						
					EndIf
				Else
					cMsgLog := aPedidos[Ni] + ";" + cC5_XNPSITE + ";;Não encontrado na SC6"
				EndIf
			Else
				cMsgLog := aPedidos[Ni] + ";" + cC5_XNPSITE + ";;Não encontrado na SC5"
				
				dbSelectArea("SZ5")
				SZ5->(dbSetOrder(1))
				If SZ5->(dbSeek(xFilial("SZ5") + aPedidos[Ni])) .And. !Empty(SZ5->Z5_CODVOU)
					cCodVou := SZ5->Z5_CODVOU
					cTipVou := SZ5->Z5_TIPVOU
				Else
					If Select("TMPVOU") > 0
						TMPVOU->(dbCloseArea())
					EndIf
					
					//Voucher
					cQuery := "SELECT GT_VOUCHER FROM GTIN WHERE GT_XNPSITE = '" + cC5_XNPSITE + "' AND GT_TYPE = 'P' AND D_E_L_E_T_ = ' '"
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPVOU",.T.,.T.)
					
					If TMPVOU->(!EoF())
						cCodVou := TMPVOU->GT_VOUCHER
					Else
						TMPVOU->(dbCloseArea())
						
						cQuery := "SELECT UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(GT_PARAM)) as GT_PARAM FROM GTIN WHERE GT_XNPSITE = '" + cC5_XNPSITE + "' AND GT_TYPE = 'V' AND D_E_L_E_T_ = ' '"
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPVOU",.T.,.T.)
						
						cMemo := TMPVOU->GT_PARAM
						cAux1 := Substr(cMemo,AT("[3][1] -> C ",cMemo) + 21)
						cCodVou := Substr(cAux1, 1, at("]", cAux1) - 1)
						
						
						
					EndIf
					
					
				
					TMPVOU->(dbCloseArea())
					
				EndIf
				
				cMsgLog := ""

				cMsgVoucher := cCodVou + ";"
				
				If !Empty(cCodVou)		
					If Select("TMPSZG") > 0
						TMPSZG->(dbCloseArea())
					EndIf
					
					cQuerySZG := "SELECT R_E_C_N_O_ FROM SZG010 WHERE ZG_NUMVOUC = '" + cCodVou + "' AND D_E_L_E_T_ = ' '"
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuerySZG),"TMPSZG",.T.,.T.)
					
					If TMPSZG->(!EOF())
					
						dbSelectArea("SZG")
						SZG->(dbGoTo(TMPSZG->R_E_C_N_O_))
					
						If Empty(SZG->ZG_NUMPED)
							cMsgVoucher += "Voucher não vinculado na SZG"
						Else
							dbSelectArea("SZF")
							SZF->(dbSetOrder(2))
							If SZF->(dbSeek(xFilial("SZF") + cCodVou))
								
								If SZF->ZF_TIPOVOU $ "A/B/2/H"
									cMsgVoucher += "Voucher com pedido anterior"
									
									dbSelectArea("SZ5")
									SZ5->(dbSetOrder(1))
									If !Empty(SZF->ZF_PEDIDO) .And. SZ5->(dbSeek(xFilial("SZ5") + SZF->ZF_PEDIDO))
										If !Empty(SZ5->Z5_CODVOU)
											cMsgVoucher += ";Ped Ori " + SZ5->Z5_PEDGAR + " Voucher sobre voucher"
										Else
											cMsgVoucher += ";Ped Ori " + SZF->ZF_PEDIDO + " Valores: " + cValToChar(SZ5->Z5_VALORSW) + ";" + cValToChar(SZ5->Z5_VALORHW)
										EndIf
									Else
										cMsgVoucher += ";Pedido Origem " + SZF->ZF_PEDIDO + " não encontrado ou em branco."
									EndIf

								Else
									cMsgVoucher += "Voucher cujo valor deve vir da SZF"
								EndIf
								
							EndIf
						EndIf
	
					EndIf
						
				EndIf
				
				
				
			EndIf
			
			dbSelectArea("SZ5")
			SZ5->(dbSetOrder(1))
			If SZ5->(dbSeek(xFilial("SZ5") + aPedidos[Ni]))
				//cMsg += " | Valor: " + cValToChar(SZ5->Z5_VALOR)
				cMsgLog += ";" + cValToChar(SZ5->Z5_VALOR) + ";"
			
				dbSelectArea("SZ6")
				SZ6->(dbSetOrder(1))
				If SZ6->(dbSeek(xFilial("SZ6") + SZ5->Z5_PEDGAR))
					While SZ6->(!EoF()) .And. SZ6->Z6_PEDGAR == SZ5->Z5_PEDGAR
						If AllTrim(SZ6->Z6_TPENTID) == "4"
							//cMsg += " | Remunerado Posto: " + cValToChar(SZ6->Z6_VALCOM)
							cMsgLog += cValToChar(SZ6->Z6_VALCOM) + ";"
							Exit
						EndIf
						SZ6->(dbSkip())
					EndDo
				EndIf
						
			EndIf
		
		EndIf	
		
		cMsgLog += cMsgVoucher
		
		aAdd(aLog, cMsgLog)
				
		oChkOut   	:= Nil
		
		cURL      	:= ""
		cEndPoint 	:= ""
		cUser     	:= ""
		cPassWord 	:= ""
		cC5_XNPSITE := ""
		o881Rest	:= Nil
		cGetResult	:= ""
		lDeserialize:= .F.
		lGet		:= .F.
		oPSite		:= Nil
		aHeadStr	:= {}
		lIgual		:= .F.
		nCnt		:= 0
		nItens		:= 0
		cMsgLog		:= ""
		cMsgVoucher	:= ""
		cCodVou		:= ""
		
	Next
	
	Processa({|| MostraLog(aLog)},"Processando","Gerando Log",.F.)

Return

/*
*/
Static Function MostraLog(aLog)
Local oDlg
Local cFile
Local oFont 
Local cMemo := ""
Local Ni	:= 0

	ProcRegua(Len(aLog))

	For Ni := 1 To Len(aLog)
		IncProc()
		cMemo += aLog[Ni] + CHR(13) + CHR(10)
	Next

	DEFINE FONT oFont NAME "Courier New" SIZE 5,0   //6,15

	DEFINE MSDIALOG oDlg TITLE "cFullLog" From 3,0 to 340,417 PIXEL

	@ 5,5 GET oMemo  VAR cMemo MEMO SIZE 200,145 OF oDlg PIXEL 
	oMemo:bRClicked := {||AllwaysTrue()}
	oMemo:oFont:=oFont

	DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
	//DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,OemToAnsi("Salvar")),If(cFile="",.t.,MemoWrite(cFile,cMemo)),oDlg:End()) ENABLE OF oDlg PIXEL 
	//DEFINE SBUTTON  FROM 153,115 TYPE 6 ACTION (PrintAErr(cFullLog),oDlg:End()) ENABLE OF oDlg PIXEL //Imprime e Apaga

	ACTIVATE MSDIALOG oDlg CENTER

Return


User Function CRPA066B()

Processa({|| CRP66BLOG()}, "Verificando Pedidos","Verificando calculos",.F.)

Return

Static Function getPGarById(cID, oResult)

Local Nz := 0
Local cFkx := ""

Private aItem

	For Nz := 1 To Len(oResult:itens)
		If AllTrim(cValToChar(oResult:itens[Nz]:id)) == AllTrim(cID)
			
			aItem := oResult:itens[Nz]

			IF Type("aItem:numeroPedidoOrigem") == "U"
				Return ""
			Else
				cFkx := oResult:itens[Nz]:numeroPedidoOrigem
			EndIf		
		
			aItem := Nil

			Return  cValToCHar(oResult:itens[Nz]:numeroPedidoOrigem)
		EndIf 
	Next

Return ""


Static Function RunQuery()

	Local aPedidos := {}
	
/*	If Select("TMPPED") > 0
		TMPPED->(dbCloseArea())
	EndIf

	BeginSql Alias "TMPPED"
		SELECT DISTINCT C6_PEDGAR 
		FROM %Table:SC6% SC6
		INNER JOIN %Table:SC5% SC5 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM
		WHERE %xFilial:SC6%
		AND C6_XNPECOM > ' '
		AND SC6.%NotDel%
		AND SC5.%NotDel%
		AND C5_EMISSAO >= '20200401' AND C5_EMISSAO <= '20200430'
		AND SUBSTRING(C6_XSKU,1,2) NOT IN ('CB','KT')
	EndSql
	
	While TMPPED->(!EoF())
		aAdd(aPedidos, TMPPED->C6_PEDGAR)
		TMPPED->(dbSkip())
	EndDo*/
	

//aAdd(aPedidos,"17635291")

*/

aAdd(aPedidos,"17703146")
aAdd(aPedidos,"17710271")
aAdd(aPedidos,"17098148")
aAdd(aPedidos,"17719662")
aAdd(aPedidos,"17742377")
aAdd(aPedidos,"17678002")
aAdd(aPedidos,"17707820")
aAdd(aPedidos,"17705241")
aAdd(aPedidos,"17661919")
aAdd(aPedidos,"17723440")
aAdd(aPedidos,"17717426")
aAdd(aPedidos,"17717483")
aAdd(aPedidos,"17693417")
aAdd(aPedidos,"17718134")
aAdd(aPedidos,"17730712")
aAdd(aPedidos,"17700928")
aAdd(aPedidos,"17636377")
aAdd(aPedidos,"17670509")
aAdd(aPedidos,"17708946")
aAdd(aPedidos,"17049119")
aAdd(aPedidos,"17793628")
aAdd(aPedidos,"17685747")
aAdd(aPedidos,"17653621")
aAdd(aPedidos,"17773672")
aAdd(aPedidos,"17701976")
aAdd(aPedidos,"17683412")
aAdd(aPedidos,"17688284")
aAdd(aPedidos,"17692465")
aAdd(aPedidos,"17677971")
aAdd(aPedidos,"17688537")
aAdd(aPedidos,"17782892")
aAdd(aPedidos,"17647147")
aAdd(aPedidos,"17770653")
aAdd(aPedidos,"17644007")
aAdd(aPedidos,"17645843")
aAdd(aPedidos,"17730164")
aAdd(aPedidos,"17746805")
aAdd(aPedidos,"17746104")
aAdd(aPedidos,"17680483")
aAdd(aPedidos,"17647656")
aAdd(aPedidos,"17742879")
aAdd(aPedidos,"17762472")
aAdd(aPedidos,"17649119")
aAdd(aPedidos,"17673112")
aAdd(aPedidos,"17724696")
aAdd(aPedidos,"17731934")
aAdd(aPedidos,"17673204")
aAdd(aPedidos,"17697423")
aAdd(aPedidos,"17725522")
aAdd(aPedidos,"17693006")
aAdd(aPedidos,"17663149")
aAdd(aPedidos,"17718692")
aAdd(aPedidos,"17700018")
aAdd(aPedidos,"17726347")
aAdd(aPedidos,"17710639")
aAdd(aPedidos,"17717424")
aAdd(aPedidos,"17755586")
aAdd(aPedidos,"17772253")
aAdd(aPedidos,"17711859")
aAdd(aPedidos,"17671252")
aAdd(aPedidos,"17667195")
aAdd(aPedidos,"17747168")
aAdd(aPedidos,"17703828")
aAdd(aPedidos,"17727727")
aAdd(aPedidos,"17702867")
aAdd(aPedidos,"17744256")
aAdd(aPedidos,"17649326")
aAdd(aPedidos,"17722531")
aAdd(aPedidos,"17734389")
aAdd(aPedidos,"17743788")
aAdd(aPedidos,"17774876")
aAdd(aPedidos,"17644641")
aAdd(aPedidos,"17754194")
aAdd(aPedidos,"17686658")
aAdd(aPedidos,"17739488")
aAdd(aPedidos,"17631060")
aAdd(aPedidos,"17711526")
aAdd(aPedidos,"17711117")
aAdd(aPedidos,"17721080")
aAdd(aPedidos,"17716224")
aAdd(aPedidos,"17665944")
aAdd(aPedidos,"17711255")
aAdd(aPedidos,"17694837")
aAdd(aPedidos,"17706858")
aAdd(aPedidos,"17712414")
aAdd(aPedidos,"17682192")
aAdd(aPedidos,"17710636")
aAdd(aPedidos,"17733947")
aAdd(aPedidos,"17587672")
aAdd(aPedidos,"17704042")
aAdd(aPedidos,"17742780")
aAdd(aPedidos,"17793996")
aAdd(aPedidos,"17768574")
aAdd(aPedidos,"17785744")
aAdd(aPedidos,"17733062")
aAdd(aPedidos,"17736905")
aAdd(aPedidos,"17718764")
aAdd(aPedidos,"17700590")
aAdd(aPedidos,"17691052")
aAdd(aPedidos,"17771836")
aAdd(aPedidos,"17642070")
aAdd(aPedidos,"17709825")


Return aPedidos


User Function CRPA66B()

	Local Ni
	Local aPedidos := {}
	Local nValor := 0
	Local cOPer	:= ""
	Local cPedGar := ""
	Local aLog := {}
	
aAdd(aPedidos,{"17606165",365.75})
aAdd(aPedidos,{"17606482",240})
aAdd(aPedidos,{"17607158",235.28})
aAdd(aPedidos,{"17606878",345.57})
aAdd(aPedidos,{"17607321",168})
aAdd(aPedidos,{"17606902",172.79})
aAdd(aPedidos,{"17606122",336.58})
aAdd(aPedidos,{"17606447",277.71})
aAdd(aPedidos,{"17606946",345.57})
aAdd(aPedidos,{"17606571",164.43})
aAdd(aPedidos,{"17606937",340.63})
aAdd(aPedidos,{"17606426",246.74})
aAdd(aPedidos,{"17606734",298.42})
aAdd(aPedidos,{"17607284",338.68})
aAdd(aPedidos,{"17606409",202.31})
aAdd(aPedidos,{"17606561",246.74})
aAdd(aPedidos,{"17607092",245})
aAdd(aPedidos,{"17606723",246.74})
aAdd(aPedidos,{"17607186",268.69})
aAdd(aPedidos,{"17606255",172.79})
aAdd(aPedidos,{"17609656",168})
aAdd(aPedidos,{"17609167",252})
aAdd(aPedidos,{"17610357",168})
aAdd(aPedidos,{"17607022",345.57})
aAdd(aPedidos,{"17607163",340.63})
aAdd(aPedidos,{"17607252",304.82})
aAdd(aPedidos,{"17606510",340.63})
aAdd(aPedidos,{"17606607",246.93})
aAdd(aPedidos,{"17607029",338.68})
aAdd(aPedidos,{"17606228",299.08})
aAdd(aPedidos,{"17606443",240})
aAdd(aPedidos,{"17607245",338.68})
aAdd(aPedidos,{"17606701",298.42})
aAdd(aPedidos,{"17606824",210.61})
aAdd(aPedidos,{"17611564",168})
aAdd(aPedidos,{"17607288",345.57})
aAdd(aPedidos,{"17606605",345.57})
aAdd(aPedidos,{"17613870",252})
aAdd(aPedidos,{"17612778",252})
aAdd(aPedidos,{"17607110",240})
aAdd(aPedidos,{"17607078",338.68})
aAdd(aPedidos,{"17604179",168})
aAdd(aPedidos,{"17613373",168})
aAdd(aPedidos,{"17607300",264})
aAdd(aPedidos,{"17610783",252})
aAdd(aPedidos,{"17614173",168})
aAdd(aPedidos,{"17607125",246.74})
aAdd(aPedidos,{"17606905",175})
aAdd(aPedidos,{"17606434",245})
aAdd(aPedidos,{"17606470",164.43})
aAdd(aPedidos,{"17606502",246.74})
aAdd(aPedidos,{"17606202",336.58})
aAdd(aPedidos,{"17606438",338.68})
aAdd(aPedidos,{"17604722",168})
aAdd(aPedidos,{"17607234",345.57})
aAdd(aPedidos,{"17604929",252})
aAdd(aPedidos,{"17606692",246.74})
aAdd(aPedidos,{"17607683",252})
aAdd(aPedidos,{"17609441",168})
aAdd(aPedidos,{"17614449",252})
aAdd(aPedidos,{"17606450",365.75})
aAdd(aPedidos,{"17606813",246.74})
aAdd(aPedidos,{"17606207",245})

	

	For Ni := 1 To Len (aPedidos)
		
		
		dbSelectArea("SZ5")
		SZ5->(dbSetOrder(1))
		If SZ5->(dbSeek(xFilial("SZ5") + aPedidos[Ni][1]))
			
			RecLock("SZ5",.F.)
				SZ5->Z5_VALOR := aPedidos[Ni][2]
				SZ5->Z5_VALORSW := aPedidos[Ni][2]
			SZ5->(MsUnlock())
			
		EndIf
		
		
		
	/*	If Select("TMPPED") > 0
			TMPPED->(dbCloseArea())
		EndIf
		
		BeginSql Alias "TMPPED"
			SELECT C6_VALOR, C6_NUM, C6_PEDGAR, C6_XOPER, C6_ITEM FROM SC6010 WHERE C6_NUM = %Exp:aPedidos[Ni]%
		EndSql
		
		nValor := 0
		While TMPPED->(!EoF())
			
			cPedGar := TMPPED->C6_PEDGAR
			cOper := TMPPED->C6_XOPER
			If !Empty(cPedGar)
				
				While cPedGar == TMPPED->C6_PEDGAR
					nValor += TMPPED->C6_VALOR
					TMPPED->(dbSkip())			
				EndDo
				
				dbSelectArea("SZ5")
				SZ5->(dbSetOrder(1))
				If SZ5->(dbSeek(xFilial("SZ5") + cPedGar))
					RecLock("SZ5",.F.)
						SZ5->Z5_VALOR := 0
					SZ5->(MsUnlock())
				
					RecLock("SZ5",.F.)
						SZ5->Z5_VALOR += nValor
						If AllTrim(cOper) $ "61/51"
							SZ5->Z5_VALORSW := nValor
						ElseIf AllTrim(cOper) $ "62/52/01"
							SZ5->Z5_VALORHW := nValor
						EndIf
					SZ5->(MsUnlock())
					
					aAdd(aLog, aPedidos[Ni] + ";" + SZ5->Z5_PEDGAR + ";" + cValToChar(SZ5->Z5_VALOR) + ";" + cValToChar(SZ5->Z5_VALORSW) + ";" + cValToChar(SZ5->Z5_VALORHW))
					nValor := 0
				EndIf
			Else
			
	
			
				aAdd(aLog, aPedidos[Ni] + ";Item "+ TMPPED->C6_ITEM + " PeDGAR VAZIO")
				TMPPED->(dbSkip())
			EndIf
			
			
		EndDo
		
		TMPPED->(dbCloseArea())
		*/
	Next

	Processa({|| MostraLog(aLog)},"Processando","Gerando Log",.F.)

Return

User Function CRPA66C()

	Local cURL			:= ""
	Local cEndPoint		:= ""
	Local cUser			:= ""
	Local cPassWord		:= ""
	Local cGetResult	:= ""
	Local cC5_XNPSITE 	:= ""
	Local cC6_PEDGAR	:= ""
	Local cMsgLog		:= ""
	Local cMsgVoucher	:= ""
	Local cPedGarAnt	:= ""
	Local cParam 		:= '?pedido_gar='
	Local oChkOut		:= Nil
	Local o881Rest		:= Nil
	Local oPSite		:= Nil
	Local o881Result	:= Nil
	Local aHeadStr		:= {}
	Local aLog			:= {}
	Local aPedidos		:= {}
	Local Ni			:= 0
	Local nCnt			:= 0
	Local nItens		:= 0	
	Local lDeserialize	:= .F.
	Local lGet			:= .F.
	Local lIgual		:= .F.	
	Local aLog			:= {}
	Local cPedGar		:= ""
	
	//aAdd(aPedidos,"17504831")
aAdd(aPedidos,"17510496")
	
	For Ni := 1 To Len(aPedidos)
	
		oChkOut := checkoutParam():get()
		
		cURL      := oChkOut:url
		cEndPoint := oChkOut:endPoint
		cUser     := oChkOut:userCode
		cPassWord := oChkOut:password
	
		AAdd( aHeadStr, "Content-Type: application/json" )
		AAdd( aHeadStr, "Accept: application/json" )
		AAdd( aHeadStr, "Authorization: Basic " + EnCode64( cUser + ":" + cPassword ) )
		
		// Host para consumo REST.
		o881Rest := FWRest():New( cURL )
		
		// Primeiro path aonde será feito a requisição
		o881Rest:setPath( cEndPoint + cParam + aPedidos[Ni] )
		
		// Efetuar o GET para completar a conexão.
		lGet := o881Rest:Get( aHeadStr )
		
		cGetResult := o881Rest:GetResult()
		
		If FwJsonDeserialize(cGetResult,@oPSite) .AND. ValType(oPSite)=='A' .AND. Len(oPSite)==1 .AND. Type('oPSite[1]:codigo')=='N'
			If oPSite[ 1 ]:codigo == 500
				cGetResult := '[ ]'
			Endif
		Endif
		
		// Se conseguiu fazer o GET e houve retorno de dados.
		If lGet .AND. cGetResult <> '[ ]' .AND. cGetResult <> '{ }'
			// Deserializar o retorno em objeto.
			lDeserialize := FWJsonDeserialize( cGetResult, @o881Result )
		Endif
	
		// Se conseguiu fazer o GET e houve retorno de dados e conseguiu deserealizar.
		If lGet .AND. cGetResult <> '[ ]' .AND. cGetResult <> '{ }' .AND. lDeserialize	
	
			cC5_XNPSITE := cValToChar( o881Result[1]:numero )
			cVoucher := o881Result[1]:pagamento:voucher:codigo
			cPedGar := aPedidos[Ni]

			//dbSelectArea("SC5")
			//SC5->(dborderNickname("PEDSITE"))
			//If SC5->(dbSeek(xFilial("SC5") + cC5_XNPSITE))
				
				//dbSelectArea("SC6")
				//SC6->(dbSetOrder(1))
				//If SC6->(dbSeek(xFilial("SC6") + SC5->C5_NUM))
					
					dbSelectArea("SZF")
					SZF->(dbSetOrder(2))
					If SZF->(dbSeek(xFilial("SZF") + cVoucher))
					
						dbSelectArea("SZG")
						SZG->(dbSetOrder(3))
						If !SZG->(dbSeek(xFilial("SZG") + cC5_XNPSITE))
						
							RecLock("SZG", .T.)
								SZG->ZG_FILIAL := xFilial("SZG")
								SZG->ZG_NUMPED := cPedGar
								SZG->ZG_NUMVOUC := cVoucher
								SZG->ZG_QTDSAI := 1
								SZG->ZG_CODFLU := SZF->ZF_CODFLU
								SZG->ZG_DATAMOV := dDataBase
								SZG->ZG_ROTINA := "CRPA066"
								SZG->ZG_GRPROJ := SZF->ZF_GRPPROJ
								SZG->ZG_PEDSITE := cC5_XNPSITE
							SZG->(MsUnlock())
							
							dbSelectArea("SZ5")
							SZ5->(dbSetOrder(1))
							If SZ5->(dbSeek(xFilial("SZ5") + cPedGar))
								RecLock("SZ5",.F.)
									SZ5->Z5_CODVOU := cVoucher
									SZ5->Z5_TIPVOU := SZF->ZF_TIPOVOU
								SZ5->(MsUnlock())
							EndIf
							
							aAdd(aLog, "Vou gravar: " + cVoucher + ";" + cC5_XNPSITE)
						
						EndIf
					
					
					EndIf
					
				//EndIf
				
			//EndIf

		Else
		EndIf
		
		
		oChkOut   	:= Nil
		
		cURL      	:= ""
		cEndPoint 	:= ""
		cUser     	:= ""
		cPassWord 	:= ""
		cC5_XNPSITE := ""
		o881Rest	:= Nil
		cGetResult	:= ""
		lDeserialize:= .F.
		lGet		:= .F.
		oPSite		:= Nil
		aHeadStr	:= {}
		lIgual		:= .F.
		nCnt		:= 0
		nItens		:= 0
		cMsgLog		:= ""
		cMsgVoucher	:= ""
		cCodVou		:= ""
		
	Next
	
	Processa({|| MostraLog(aLog)},"Processando","Gerando Log",.F.)

Return
