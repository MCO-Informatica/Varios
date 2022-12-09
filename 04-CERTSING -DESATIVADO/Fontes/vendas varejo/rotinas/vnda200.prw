#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Fileio.ch"

Static __cRetDir := ""	//Variavel utilizada para retorno da consulta padrao

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VNDA200 ºAutor  ³Opvs (Darcio)       º Data ³  07/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao criada para desmembrar o arquivo CNAB ou faturar os  º±±
±±º          ³pedidos.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Opvs x Certisign                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VNDA200()

Local cPerg := "PCNABP"
Local cSqlRet	:= ""
Local aProc     := {}
Local cResp     := ""
Local cFileName := ''


cSqlRet := "SELECT ACB.ACB_OBJETO, ACB.ACB_DESCRI "
cSqlRet += "FROM "
cSqlRet += "	"+RetSqlName("ACB")+" ACB INNER JOIN "+RetSqlName("AC9")+" AC9 ON ACB.ACB_CODOBJ = AC9.AC9_CODOBJ	"
cSqlRet += "WHERE ACB.ACB_FILIAL = '" + xFilial("ACB") + "' AND AC9.AC9_FILIAL = '" + xFilial("AC9") + "' "
cSqlRet += "AND AC9.AC9_ENTIDA = 'SZP' AND AC9.AC9_CODENT = '"+ xFilial("SZP")+ Alltrim(SZP->ZP_ID)+"' "
cSqlRet += "AND AC9.D_E_L_E_T_ <> '*' AND ACB.D_E_L_E_T_ <> '*' "

cSqlRet := ChangeQuery(cSqlRet)
TCQUERY cSqlRet NEW ALIAS "TMPACB"

DbSelectArea("TMPACB")

If TMPACB->(!Eof())
	TMPACB->(DbGoTop())
	While TMPACB->(!Eof())
		Aadd( aProc,{TMPACB->ACB_OBJETO, TMPACB->ACB_DESCRI})
		
		TMPACB->(DbSkip())
	Enddo
	
	
	DEFINE MSDIALOG oDlg TITLE "Selecione o Arquivo do Banco de Conhecimento" FROM 0,0 TO 320,500 PIXEL
	
	//ListBox
	@ 10,10 LISTBOX oLbx FIELDS HEADER ;
	"Arquivo", "Descricao",;
	SIZE 230,130 OF oDlg PIXEL ON DblClick(cResp := aProc[oLbx:nAt,1],oDlg:End())
	
	oLbx:SetArray( aProc )
	oLbx:bLine := {||{aProc[oLbx:nAt,1],;
	aProc[oLbx:nAt,2]}}
	
	//botao ok
	DEFINE SBUTTON FROM 147,183 TYPE 1 ACTION {|| cResp := aProc[oLbx:nAt,1],oDlg:End()} ENABLE OF oDlg
	//botao cancelar
	DEFINE SBUTTON FROM 147,213 TYPE 2 ACTION {|| oDlg:End()} ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTER
	
Endif

DbSelectArea("TMPACB")
TMPACB->(DbCloseArea())

IF !Empty(cResp)
	
	cFileName := cResp
	cResp := MsDocPath()+"\" + Alltrim(cResp)
	If Pergunte(cPerg, .T.)
		
		IF Mv_par01 == 3
			Processa( { || Reprocessa( cResp, cFileName ) } )
		Else
			If mv_par01 == 2
				SZQ->(DbSelectArea("SZQ"))
				SZQ->(DbSetOrder(1))
				IF SZQ->(DbSeek(xFilial("SZQ")+SZP->ZP_ID + '5'))
					IF !MSGYESNO ("Arquivo com linhas inconsistentes. Tem certeza que deseja desmembrar?","Inconsitência")
						Return
					Endif
				Endif
			Endif
			
			IF SZQ->(DbSeek(xFilial("SZQ")+SZP->ZP_ID + '7'))
				IF !MSGYESNO ("Arquivo com linhas Em Processamento. Tem certeza que deseja Continuar?","Em Processamento")
					Return
				Endif
			Endif
			
			Processa( { || U_GerFTCProc(cResp, mv_par01) } )
		EndIF
	EndIf
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GerFTCProcºAutor  ³Opvs (Darcio)       º Data ³  07/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de processamento                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Opvs x Certisign                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GerFTCProc(cArq, nTipo)
//nTipo -> 1 - Fatura / 2 - Desmembra
//Estágios da linha de cnab:
//1=Nao Processado;2=Distribuido;3=Faturado;4=Desmenbrado;5=Inconsistente;6=Baixado;7=Em Processamento
Local cArqEnt		:= Alltrim(cArq)
Local nLidos		:= 0
Local nTamDet		:= Iif( Empty (SEE->EE_NRBYTES), 400 , SEE->EE_NRBYTES + 2)
Local xReg			:= ""
Local xBuffer		:= ""
Local aTitulos		:= {}
Local _aArea		:= GetArea()
Local nQtdRec		:= 0
Local cNosso		:= ""
Local cIdPed		:= ""
Local cBanco		:= ""
Local lLog 			:= .F.
Local dDataMovFin	:= GetMv("MV_DATAFIN")
Local lFatInc 		:= .F.
Local cSql			:= ""
Local cIdCnab		:= ""
Local nCount		:= 0
Local nSecWait		:= GetMv("MV_XSECWAI")
Local cOperNPF		:= GetNewPar("MV_XOPENPF", "61,62")
Local lNewFat		:= .F.
Local dDTCred := Ctod('')

Local cAgencia := ''
Local cCtaCorr := ''
Local aBanco := {}
Local aSE1 := {}
Local lRet := .T.		
Local lNumOS := .F.				

Private lConsist  	:= .T.
Private cGrupo 	  	:= Space( TamSX3("U0_CODIGO")[1] )
Private cOperador 	:= Space( TamSX3("U7_COD")[1] )
Private cAssunto  	:= Space( TamSX3("ADE_ASSUNT")[1] )
Private cProduto	:= ""
Private cCategoria	:= ""
Private cOrigem   	:= ""
Private cCausa    	:= ""
Private cEfeito   	:= ""
Private cCampanha 	:= ""

If "_DES" $ cArqEnt
	cTpProc := iif(nTipo ==1,"Faturado","Desmembrado" )
	ApMsgAlert("Somente o Arquivo CNAB original pode ser "+cTpProc+"."+CRLF+" Por favor, selecione um arquivo válido!")
	Return(.F.)
EndIf

SZQ->(DbSelectArea("SZQ"))
SZQ->(DbSetOrder(1))
lFatInc := SZQ->(DbSeek(xFilial("SZQ")+SZP->ZP_ID + '5'))

/*-----------------------------------------
Abre arquivo enviado pelo banco
------------------------------------------*/
If !File(cArqEnt)
	ApMsgAlert("Arquivo "+cArqEnt+" não localizado. O sistema será abortado.")
	UserException("Arquivo "+cArqEnt+" não localizado. O sistema foi abortado propositalmente. "+CRLF)
Else
	/*
	Ajustes de código para atender Migração versão P12
	Uso de DbOrderNickName
	OTRS:2017103110001774
	*/
		
	DbSelectArea("SC5")
	DbOrderNickName("NUMPEDGAR")
	
	
	dbSelectArea("SC6")
	dbSetOrder(1)
	dbSelectArea("SF2")  	//F2_FILIAL+F2_CLIENTE+F2_LOJA+F2_DOC+F2_SERIE
	dbSetOrder(2)
	dbSelectArea("SE1")  	//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	dbSetOrder(2)
	/*
	-----------------------------------------
	Renomeio o arquivo informado para leitura
	-----------------------------------------*/
	//cArqEntNew := FileNoExt(cArqEnt)+".ORI" //Retorna a string sem a extensao do arquivo
	cArqEntNew := cArqEnt
	If !File(cArqEntNew)
		nHdlRen := FRENAME(cArqEnt,cArqEntNew)
		If nHdlRen < 0
			ApMsgAlert("Erro ao renomear arquivo "+cArqEnt+" O sistema será abortado.")
			UserException("Erro ao renomear arquivo "+cArqEnt+" O sistema foi abortado propositalmente. "+CRLF)
		EndIf
	Endif
	
	/*
	---------------------------------------
	Abre arquivo para leitura
	---------------------------------------*/
	nHdlBco:=FOPEN(cArqEntNew)
	
	/*
	---------------------------------------
	Cria novo arquivo com as alterações
	---------------------------------------*/
	cArqEnt := FileNoExt(cArqEnt)+"_des"+".RET"
	nHdlNew := FCREATE(cArqEnt)
	If nHdlNew < 0
		ApMsgAlert("Erro ao criar arquivo "+cArqEnt+" O sistema será abortado.")
		UserException("Erro ao renomear arquivo "+cArqEnt+" O sistema foi abortado propositalmente. "+CRLF)
	EndIf
Endif


/*
------------------------------------------
Le arquivo enviado pelo Banco
------------------------------------------*/
FSeek(nHdlBco,0,0)
nTamArq:=FSeek(nHdlBco,0,2)
FSeek(nHdlBco,0,0)

nNumSeq	:= 0	//Val(Substr(xBuffer,395,400))		//Pos.395 a 400	 ---> Numero sequencial

ProcRegua( Int(nTamArq/400) )

While .T.
	
	nQtdRec++
	IncProc( "Processando registro "+Alltrim(Str(nQtdRec)) )
	ProcessMessage()
	
	xBuffer:=Space(nTamDet)
	FREAD(nHdlBco,@xBuffer,nTamDet)
	
	If Empty(xBuffer)		//Fim do arquivo
		Exit
	EndIf
	
	nNumSeq++
	
	SZQ->(DbSelectArea("SZQ"))
	SZQ->(DbSetOrder(1))
	lLog := SZQ->(DbSeek(xFilial("SZQ")+SZP->ZP_ID + Strzero(nQtdRec,5)))
	
	//valida se a linha esta em processamento
	If lLog .and. SZQ->ZQ_STATUS == '7'
		lLinProc := .T.
	Else
		lLinProc := .F.
	EndIf
	
	//valida se a linha esta inconsistente
	If lLog .and. SZQ->ZQ_STATUS == '5'
		lLinInc := .T.
	Else
		lLinInc := .F.
	EndIf
	
	/*-------------------------------------------------------
	Verifica tipo de registro 0-header 1-detalhe 9-trailer
	-------------------------------------------------------*/
	IF SubStr(xBuffer,1,1) $ "0|9"
		If SubStr(xBuffer,1,1) == "0"
			cBanco := SubStr(xBuffer,77,3)
		EndIf
		cLinDet := Substr(xBuffer,1,394)
		cLinDet += StrZero(nNumSeq,6)
		cLinDet += CRLF
		
		If FWRITE(nHdlNew,cLinDet,nTamDet) != nTamDet
			ApMsgAlert("Erro ao tentar gravar arquivo. O sistema será abortado.","INFO","ATENCAO")
			FCLOSE(nHdlNew)
			FCLOSE(nHdlBco)
			UserException("Erro ao tentar gravar arquivo "+" O sistema foi abortado propositalmente no ponto de entrada F200PORT. "+CRLF)
		EndIf
		nLidos+=nTamDet
		Loop
	EndIF
	
	/*	-------------------------------------
	Verifica se eh um pagamento
	-------------------------------------*/
	IF	( (cBanco == '341') .and. (SubStr(xBuffer,109,2) <> "06" .OR. .NOT. (SubStr(xBuffer,83,3) $ "175,176,178" ) ) ) .or.;
		( (cBanco == '237') .and. !SubStr(xBuffer,109,2) $ "06|16" ) //06-Liquidação//16-BAIXA POR FALTA DE PAGAMEMTO
		
		cLinDet := Substr(xBuffer,1,394)
		cLinDet += StrZero(nNumSeq,6)
		cLinDet += CRLF
		
		If FWRITE(nHdlNew,cLinDet,nTamDet) != nTamDet
			ApMsgAlert("Erro ao tentar gravar arquivo. O sistema será abortado.","INFO","ATENCAO")
			FCLOSE(nHdlNew)
			FCLOSE(nHdlBco)
			UserException("Erro ao tentar gravar arquivo "+" O sistema foi abortado propositalmente no ponto de entrada F200PORT. "+CRLF)
		EndIf
		nLidos += nTamDet
		Loop
	EndIF
	
	If !Empty(Substr(xBuffer,38,25)) .AND. SubStr(xBuffer,83,3) == "112"
		cLinDet := Substr(xBuffer,1,394)
		cLinDet += StrZero(nNumSeq,6)
		cLinDet += CRLF
		
		If FWRITE(nHdlNew,cLinDet,nTamDet) != nTamDet
			ApMsgAlert("Erro ao tentar gravar arquivo. O sistema será abortado.","INFO","ATENCAO")
			FCLOSE(nHdlNew)
			FCLOSE(nHdlBco)
			UserException("Erro ao tentar gravar arquivo "+" O sistema foi abortado propositalmente no ponto de entrada F200PORT. "+CRLF)
		EndIf
		nLidos+=nTamDet
		Loop
	Else
		
		cNosso 	:= IIF( (cBanco == '341') ,Substr(xBuffer,63,08),Substr(xBuffer,71,12))	//Num do boleto no Banco
		cIdPed 	:= IIF( (cBanco == '341') ,Substr(xBuffer,63,08),Substr(xBuffer,74,08))	//Num do Pedido Site
		lNumOS	:= Left(cIdPed,1) == '9'
		cIdPed 	:= Alltrim(Str(Val(cIdPed)))
		
		cSql := " SELECT "
		cSql += "   ZQ_ID "
		cSql += " FROM "
		cSql += RetSqlName("SZQ")
		cSql += " WHERE "
		cSql += "   ZQ_FILIAL = '"+xFilial("SZQ")+"' AND "
		cSql += "   ZQ_PEDIDO = '"+cIdPed+"' AND "
		cSql += "   D_E_L_E_T_ = ' ' "
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"QRYSZQ",.F.,.T.)
		cIdCnab:=''
		nCount := 0
		While !QRYSZQ->(EoF())
			nCount++
			cIdCnab+= ","+QRYSZQ->ZQ_ID
			QRYSZQ->(DbSkip())
		EndDo
		
		QRYSZQ->(DbCloseArea())
		
		If nCount > 1 .and. lLog
			SZQ->(Reclock("SZQ"))
			SZQ->ZQ_OCORREN := "Ped. em vários arq.: "+cIdCnab
			SZQ->ZQ_STATUS := '5'
			SZQ->ZQ_DATA := ddatabase
			SZQ->ZQ_HORA:=time()
			SZQ->(MsUnlock())
		EndIf
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////
		///// Alteração de fonte, para reconhecer um atendimento aberto com uma cobrança gerada avulsa     /////
		////////////////////////////////////////////////////////////////////////////////////////////////////////
		///// Autor: Claudio Henrique Corrêa                                       Data: 04/05/2015        /////
		////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		cDigValid	:= IIF( (cBanco == '341'), SubStr(cNosso,1,2), SubStr(cIdPed,1,2) )
		cOrdemAt 	:= IIF( (cBanco == '341'), SubStr(cNosso,3,6), SubStr(cIdPed,3,6) )
		
		if  lNumOS //cDigValid == "99"
			cAtendimento := cOrdemAt
			
			dbSelectArea("PA0")
			dbSetOrder(1)
			dbSeek(xFilial("PA0")+cAtendimento)
			
			If PA0->(Found())
				
				xReg    := xBuffer
				
				dDTCred := Ctod(Substr(xBuffer,296,02)+'/'+Substr(xBuffer,298,02)+'/'+Substr(xBuffer,300,02))
				nValTit := Val(Substr(xBuffer,153, 13))/100		//Pos. 153 a 165  ---> Valor do titulo no arquivo
				nValTax := Val(Substr(xBuffer,176, 13))/100		//Pos. 176 a 188  ---> TAXA
				nValPag := Val(Substr(xBuffer,254, 13))/100		//Pos. 254 a 266  ---> VALOR PAGO (RECEBIDO)
				nDesc   := Val(Substr(xBuffer,241, 13))/100		//Pos. 241 a 253  ---> DESCONTO
				nJuros  := Val(Substr(xBuffer,267, 13))/100		//Pos. 267 a 279  ---> JUROS
				nNumBanco := Val(Substr(xBuffer,63,08))
				
				dbSelectArea("SE1")
				dbOrderNickName('ORD_SERV')
				dbSeek(xFilial("SE1")+cAtendimento)
				
				if SE1->(Found())
					
					Reclock("SZQ",.T.)
					SZQ->ZQ_OCORREN := "Titulo já existe "+cAtendimento
					SZQ->ZQ_LINHA := STRZERO(nLidos,5)
					SZQ->ZQ_ID := SubStr(cIdCnab,2,6)
					SZQ->ZQ_STATUS := '5'
					SZQ->ZQ_DATA := ddatabase
					SZQ->ZQ_HORA:=time()
					MsUnlock()
					
					U_GTPUTIN(cNosso,"O","",.T.,{"Titulo já existe "+cAtendimento},"")
					
					MsgAlert("Já existe titulo gerado para o atendimento "+ cAtendimento)
				Else
					xReg   := xBuffer
					If cBanco == '341'
						cIdPed := Substr(xBuffer,63,08)					//Numero da GAR gravado no Pedido de Venda (SC5)  C 10
					ElseIf cBanco == '237'
						cIdPed := Substr(xBuffer,71,11)					//Numero da GAR gravado no Pedido de Venda (SC5)  C 10
					EndIf
					
					cIdPed := Alltrim(Str(Val(cIdPed)))
					
					cQuery := " SELECT "+ RetSqlName("PA0")+".PA0_OS,"
					cQuery += RetSqlName("PA0")+".PA0_CLILOC,"
					cQuery += RetSqlName("PA0")+".PA0_CLIFAT,"
					cQuery += RetSqlName("PA0")+".PA0_CLLCNO,"
					cQuery += RetSqlName("PA0")+".PA0_LOJAFA,"
					cQuery += RetSqlName("PA0")+".PA0_LOJLOC,"
					cQuery += RetSqlName("PA0")+".PA0_CLFTNM,"
					cQuery += RetSqlName("PA0")+".PA0_CONDPA,"
					cQuery += RetSqlName("PA0")+".PA0_LINDIG,"
					cQuery += RetSqlName("PA0")+".PA0_DTEBOL,"
					cQuery += RetSqlName("PA0")+".PA0_DTVBOL,"
					cQuery += RetSqlName("PA1")+".PA1_VALOR"
					cQuery += " FROM "+RetSqlName("PA0")+", "+RetSqlName("PA1")
					cQuery += " WHERE "+RetSqlName("PA0")+".D_E_L_E_T_ = ''"
					cQuery += " AND "+RetSqlName("PA0")+".PA0_OS = '"+cAtendimento+"'"
					cQuery += " AND "+RetSqlName("PA0")+".PA0_OS = "+RetSqlName("PA1")+".PA1_OS"
					cQuery += " AND "+ RetSqlName("PA1")+".PA1_FATURA = 'S' "
					cQuery := changequery(cQuery)
					
					If Select("_PA0") > 0
						DbSelectArea("_PA0")
						DbCloseArea("_PA0")
					EndIf
					
					dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),"_PA0", .F., .T.)
					
					cOs := _PA0->PA0_OS
					cClicod := IIF(Empty(_PA0->PA0_CLIFAT),_PA0->PA0_CLILOC,_PA0->PA0_CLIFAT)
					cLjCod	:= IIF(Empty(_PA0->PA0_LOJAFA),_PA0->PA0_LOJLOC,_PA0->PA0_LOJAFA)
					cClinome := IIF(Empty(_PA0->PA0_CLIFAT),_PA0->PA0_CLLCNO,_PA0->PA0_CLFTNM)
					cCondpag := _PA0->PA0_CONDPA
					//	AAABC.CCDDX		DDDDD.DDFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV
					cLindig := SubStr(_PA0->PA0_LINDIG,1,5)+SubStr(_PA0->PA0_LINDIG,7,5)+SubStr(_PA0->PA0_LINDIG,13,5)+SubStr(_PA0->PA0_LINDIG,19,6)+SubStr(_PA0->PA0_LINDIG,26,5)+SubStr(_PA0->PA0_LINDIG,32,6)+SubStr(_PA0->PA0_LINDIG,39,1)+SubStr(_PA0->PA0_LINDIG,42,14)
					
					aVal := {}
					
					nTotReg := Contar("_PA0","!Eof()")
					_PA0->(DbGoTop())
					
					nPos := 1
					
					nSoma := 0
					
					While !EOF("_PA0")
						AADD(aVal,_PA0->PA1_VALOR)
						if nPos <= nTotReg
							nSoma += aVal[nPos]
							nPos++
						endif
						DbSkip()
					Enddo
					
					nValPag := ( nValPag + nValTax )
					nPago := nSoma - nValPag
					
					if nPago > 0
						nDif := nPago
						nPago := nValPag
					Else
						nDif := nValPag
						nPago := nValPag
					Endif
					
					cPrefixo  := GETNEWPAR("MV_CSGBOL5","RPC")
					cTipo     := GETNEWPAR("MV_CSGBOL6", "NCC")
					cNatureza := GETNEWPAR("MV_CSGBOL7", "FT010010  ")
					
					////////////////////////////////////////////////////////////////////////////////////////////////
					// O bloco de instrução abaixo gera o título de NCC no SE1 e o crédito no SE5.
					//----------------------------------------------------------------------------------------------
					cAgencia := "00000"

					If SA6->(DbSeek(xFilial("SA6")+cBanco+cAgencia))
						cCtaCorr	:= SA6->A6_NUMCON
					Else
						cCtaCorr	:= ''
					EndIF
					
					aBanco := {cBanco,cAgencia,cCtaCorr}
					aSE1 := {cPrefixo,"99"+cOs,cTipo,cNatureza,cClicod,cLjCod,dDTCred,'','',cNosso,'1','',cIdCnab,'','',cOS}
					lRet := U_CSFA500( 3, '000', nValPag, aSE1, .F., .T., dDTCred, aBanco, "ORD SERV 99"+cOs)
					////////////////////////////////////////////////////////////////////////////////////////////////
					
					If .NOT. lRet
						dbSelectArea("SZQ")
						Reclock("SZQ",.T.)
						SZQ->ZQ_PEDIDO := "Erro ao gravar a linha para o atendimento "+cAtendimento
						SZQ->ZQ_STATUS := '5'
						SZQ->ZQ_LINHA := STRZERO(nLidos,5)
						SZQ->ZQ_ID := SubStr(cIdCnab,2,6)
						SZQ->ZQ_DATA := ddatabase
						SZQ->ZQ_HORA:=time()
						MsUnlock()
						dbCloseArea("SZQ")
						U_GTPUTIN(cNosso,"O","",.T.,{"Erro ao gravar a linha para o atendimento "+cAtendimento},"")
					Else
						dbSelectArea("SZQ")
						Reclock("SZQ",.T.)
						SZQ->ZQ_PEDIDO := cNosso
						SZQ->ZQ_STATUS := '6'
						SZQ->ZQ_LINHA := STRZERO(nLidos,5)
						SZQ->ZQ_ID := SubStr(cIdCnab,2,6)
						SZQ->ZQ_DATA := ddatabase
						SZQ->ZQ_HORA:=time()
						SZQ->ZQ_OCORREN := "Atendimento gravado com sucesso 99"+cOS
						MsUnlock()
						dbCloseArea("SZQ")
						U_GTPUTIN(cNosso,"O","",.T.,{"Atendimento gravado com sucesso 99 "+cAtendimento},"")
						dbSelectArea("PA0")
						dbSetOrder(1)
						dbSeek(xFilial("PA0")+cAtendimento)
						if found()
							cQryADE := " SELECT * "
							cQryADE += " FROM "+RetSqlName("ADE")
							cQryADE += " WHERE D_E_L_E_T_ = '' "
							cQryADE += " AND ADE_OS = '"+cAtendimento+"'"
							
							cQryADE := changequery(cQryADE)
							
							if Select("_ADE") > 0
								dbSelectArea("_ADE")
								dbCloseArea("_ADE")
							Endif
							
							dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQryADE),"_ADE", .T., .F.)
							
							cGrupo := '9G'
							cGrpDesc := Posicione( "SU0", 1, xFilial("SU0") + cGrupo, "U0_NOME" )
							cAssunto := Posicione( "SX5", 1, xFilial("SX5")+"T1"+"BK0035","SX5->X5_DESCRI")
							cOperador := "000001"
							cAction := "000269"
							
							dbSelectArea("ADE")
							dbSetOrder(1)
							dbSeek(xFilial("ADE")+_ADE->ADE_CODIGO)
							
							if ADE->(Found())
							
								dbSelectArea("ADF")
								dbSetOrder(1)
								dbSeek(xFilial("ADF")+_ADE->ADE_CODIGO)
								
								if ADF->(Found())
								
									cTime := TIME()
									cHora := SUBSTR(cTime, 1, 2)
									cMinutos := SUBSTR(cTime, 4, 2)
									cHoraAtu := cHora+":"+cMinutos
									cOcor := '006448'
									cAcao := '000405'
									
									BEGIN TRANSACTION
										RecLock("ADF",.T.)
										ADF->ADF_CODIGO		:= _ADE->ADE_CODIGO
										ADF->ADF_ITEM 		:= NextNumero("ADF",1,"ADF_ITEM",.T.,)
										ADF->ADF_CODSU9 	:= cOcor
										ADF->ADF_CODSUQ		:= cAcao
										ADF->ADF_CODSU7		:= "000001"
										ADF->ADF_CODSU0		:= "9G"
										ADF->ADF_DATA		:= dDataBase
										ADF->ADF_HORA		:= Time()
										ADF->ADF_HORAF		:= Time()
										ADF->ADF_OS			:= cOrdemAt
										MsUnlock()
									END TRANSACTION
									
								Endif
								
							Endif
							
							If PA0->PA0_STATUS == "1" .Or. PA0->PA0_STATUS == "6" //Validação para atualização de Status de OS somente para os casos de OS Pendente de Pagamento = 1 e OS Aberta com Pendencia "6"
							
								BEGIN TRANSACTION
									RecLock("PA0",.F.)
									PA0->PA0_STATUS := "2"
									MsUnlock()
								END TRANSACTION
							
								DbSelectArea("PAW")
								DbSetOrder(4)
								DbSeek(xFilial("PAW")+cOs)
							
								If PAW->(Found())
									
									While PAW->(!EOF()) .and. PAW->PAW_STATUS == "P"
										
										If PAW->PAW_OS == cOs
											
											BEGIN TRANSACTION
											RecLock("PAW",.F.)
											PAW->PAW_STATUS := "L"
											MsUnlock()
											END TRANSACTION
											
										EndIf
										
										PAW->(dBSkip())
										
									EndDo
									
									cFileName := ""
									
									cMail := PA0->PA0_EMAIL
									
									cAssuntoEm := 'Solicitação de validação em domicílio - Confirmação de pagamento e agendamento.' //'Solicitação de atendimento - Confirmação de Pagamento'
									
									cCase := "PAGAMENTO"
									
									lRet := U_CSFSEmail(cOs, cFileName, cMail, cAssuntoEm, cCase)
									
								EndIf
								
							End If
							
						Endif
						
					Endif
				EndIf
				
				cDigValid := SubStr(cNosso,1,1)
			
			Endif	// Final da condição para gravação e validação do titulo.
			
		Else
			
			If nTipo == 1
				
			    //Gera NCC no Financeiro e compensa com provisórios notas fiscais
				If !lLinProc
					//Aguarda 5 segundos para novo faturamento para thread
					//sleep(nSecWait*1000)
					dDatabx:=ctod(Substr(xBuffer,296,02)+'/'+Substr(xBuffer,298,02)+'/'+Substr(xBuffer,300,02))
					nValTit:= Val(Substr(xBuffer,153, 13))/100		//Pos. 153 a 165  ---> Valor do titulo no arquivo
					nValTax:= Val(Substr(xBuffer,176, 13))/100		//Pos. 176 a 188  ---> TAXA
					nValPag:= Val(Substr(xBuffer,254, 13))/100		//Pos. 254 a 266  ---> VALOR PAGO (RECEBIDO)
					nDesc  := Val(Substr(xBuffer,241, 13))/100		//Pos. 241 a 253  ---> DESCONTO
					nJuros := Val(Substr(xBuffer,267, 13))/100		//Pos. 267 a 279  ---> JUROS
					
					If nDesc > 0 .or. nJuros >0
						nValRcb := nValTit-nDesc+nJuros
					Else
						nValRcb := nValPag+nValTax
					EndIf
					
					If dtos(dDatabx) <= dtos(dDataMovFin)
						dDatabx:=dDataMovFin+1
					Endif
					
					//Conout( '[VNDA200] Processo ID: ' + SZP->ZP_ID + ', pedido: ' + Alltrim(Str(Val(cIdPed))) )

				    //Gera NCC no Financeiro e compensa com provisórios notas fiscais
					U_VNDA300(Alltrim(Str(Val(cIdPed))),Alltrim(Str(Val(cNosso))),dDatabx,nValRcb,cBanco)					
				EndIf
				
				Loop
			Else
				
				xReg   := xBuffer
				If cBanco == '341'
					cIdPed := Substr(xBuffer,63,08)					//Numero da GAR gravado no Pedido de Venda (SC5)  C 10
				ElseIf cBanco == '237'
					cIdPed := Substr(xBuffer,71,11)					//Numero da GAR gravado no Pedido de Venda (SC5)  C 10
				EndIf
				cIdPed := Alltrim(Str(Val(cIdPed)))
				
				dDatabx:=ctod(Substr(xBuffer,296,02)+'/'+Substr(xBuffer,298,02)+'/'+Substr(xBuffer,300,02))
				If dtos(dDatabx) <= dtos(dDataMovFin)
					dDatabx:=dDataMovFin+1
				Endif
				
				nValTit:= Val(Substr(xBuffer,153, 13))/100		//Pos. 153 a 165  ---> Valor do titulo no arquivo
				nValTax:= Val(Substr(xBuffer,176, 13))/100		//Pos. 176 a 188  ---> TAXA
				nValPag:= Val(Substr(xBuffer,254, 13))/100		//Pos. 254 a 266  ---> VALOR PAGO (RECEBIDO)
				nDesc  := Val(Substr(xBuffer,241, 13))/100		//Pos. 241 a 253  ---> DESCONTO
				nJuros := Val(Substr(xBuffer,267, 13))/100		//Pos. 267 a 279  ---> JUROS
				
				/*	---------------------------------------
				Pesquisa Numero do Pedido de Venda
				---------------------------------------*/
				/*
				Ajustes de código para atender Migração versão P12
				Uso de DbOrderNickName
				OTRS:2017103110001774
				*/
				SC5->(DbOrderNickName("PEDSITE"))	
				//SC5->( DbSetOrder(8)) //Ordem 8 //Pedido Site
				If !SC5->(MsSeek(xFilial("SC5")+cIdPed) ) 		//Ordem 8
					lContinue := .F.
				Else
					lContinue := .T.
				EndIf
				
				If !lContinue
					
					cLinDet := Substr(xBuffer,  1, 37)					//Pos.  1 a 37
					cLinDet += "         PED NAO LOCALIZ"+Space(1)			//Pos. 38 a 62  ---> E1_IDCNAB
					cLinDet += Substr(xBuffer,63,332)
					cLinDet += StrZero(nNumSeq,6)
					cLinDet += CRLF
					
					If FWRITE(nHdlNew,cLinDet,nTamDet) != nTamDet
						ApMsgAlert("Erro ao tentar gravar arquivo. O sistema será abortado.","INFO","ATENCAO")
						FCLOSE(nHdlNew)
						FCLOSE(nHdlBco)
						UserException("Erro ao tentar gravar arquivo "+" O sistema foi abortado propositalmente no ponto de entrada F200PORT. "+CRLF)
						If lLog
							SZQ->(Reclock("SZQ"))
							SZQ->ZQ_OCORREN := "Erro ao gravar a linha."
							SZQ->ZQ_STATUS := '5'
							SZQ->ZQ_DATA := ddatabase
							SZQ->ZQ_HORA:=time()
							SZQ->(MsUnlock())
							lConsist := .F.
						Endif
					Else
						If lLog
							SZQ->(Reclock("SZQ"))
							SZQ->ZQ_OCORREN := "Pedido nao localizado."
							SZQ->ZQ_STATUS := '5'
							SZQ->ZQ_DATA := ddatabase
							SZQ->ZQ_HORA:=time()
							SZQ->(MsUnlock())
							lConsist := .F.
						Endif
					EndIf
					nLidos+=nTamDet
					Loop
				EndIF
				
				/*	--------------------------------------------------
				Pesquisa Numero do Documento Fiscal do Item
				--------------------------------------------------*/
				If SC6->( !MsSeek(xFilial("SC6")+SC5->C5_NUM) )
					cLinDet := Substr(xBuffer,1,394)
					cLinDet += StrZero(nNumSeq,6)
					cLinDet += CRLF
					
					If FWRITE(nHdlNew,cLinDet,nTamDet) != nTamDet
						ApMsgAlert("Erro ao tentar gravar arquivo. O sistema será abortado.","INFO","ATENCAO")
						FCLOSE(nHdlNew)
						FCLOSE(nHdlBco)
						UserException("Erro ao tentar gravar arquivo "+" O sistema foi abortado propositalmente no ponto de entrada F200PORT. "+CRLF)
						If lLog
							SZQ->(Reclock("SZQ"))
							SZQ->ZQ_OCORREN := "Erro ao gravar a linha."
							SZQ->ZQ_STATUS := '5'
							SZQ->ZQ_DATA := ddatabase
							SZQ->ZQ_HORA:=time()
							SZQ->(MsUnlock())
							lConsist := .F.
						Endif
					Else
						If lLog
							SZQ->(Reclock("SZQ"))
							SZQ->ZQ_OCORREN := "Item do Pedido nao localizado."
							SZQ->ZQ_STATUS := '5'
							SZQ->ZQ_DATA := ddatabase
							SZQ->ZQ_HORA:=time()
							SZQ->(MsUnlock())
							lConsist := .F.
						Endif
					EndIf
					nLidos+=nTamDet
					Loop
				EndIF
				
				aTitulos := {}
				
				If SC5->C5_TPCARGA = '1'
					cLinDet := Substr(xBuffer,  1, 37)					//Pos.  1 a 37
					cLinDet += "         TIT REF CARGA  "+Space(1)			//Pos. 38 a 62  ---> E1_IDCNAB
					cLinDet += Substr(xBuffer,63,332)
					cLinDet += StrZero(nNumSeq,6)
					cLinDet += CRLF
					
					If FWRITE(nHdlNew,cLinDet,nTamDet) != nTamDet
						ApMsgAlert("Erro ao tentar gravar arquivo. O sistema será abortado.","INFO","ATENCAO")
						FCLOSE(nHdlNew)
						FCLOSE(nHdlBco)
						UserException("Erro ao tentar gravar arquivo "+" O sistema foi abortado propositalmente no ponto de entrada F200PORT. "+CRLF)
						If lLog
							SZQ->(Reclock("SZQ"))
							SZQ->ZQ_OCORREN := "Erro ao gravar a linha."
							SZQ->ZQ_STATUS := '5'
							SZQ->ZQ_DATA := ddatabase
							SZQ->ZQ_HORA:=time()
							SZQ->(MsUnlock())
							lConsist := .F.
						Endif
					Else
						If lLog
							SZQ->(Reclock("SZQ"))
							SZQ->ZQ_OCORREN := "Tit. ref RA de delivery"
							SZQ->ZQ_STATUS := '5'
							SZQ->ZQ_DATA := ddatabase
							SZQ->ZQ_HORA:=time()
							SZQ->(MsUnlock())
							lConsist := .F.
						Endif
					EndIf
					nLidos+=nTamDet
					Loop
				Else
					While !SC6->(Eof()) .and. SC6->C6_FILIAL == SC5->C5_FILIAL .and. SC6->C6_NUM == SC5->C5_NUM
						If !SC6->C6_XOPER $ cOperNPF .and. SC6->C6_XOPER <> '53'
							If SF2->(MsSeek(xFilial("SF2")+SC6->(C6_CLI+C6_LOJA+C6_NOTA+C6_SERIE)))
								If !Empty(SF2->F2_DUPL)		//Gerou titulo a receber
									SE1->(dbSetOrder(2))
									SE1->(MsSeek(xFilial("SE1")+SF2->(F2_CLIENTE+F2_LOJA+F2_PREFIXO+F2_DUPL)))        ////E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
									
									While	SE1->(!Eof()) .AND.;
										SE1->E1_CLIENTE == SF2->F2_CLIENTE .AND.;
										SE1->E1_LOJA == SF2->F2_LOJA .AND.;
										SE1->E1_PREFIXO == SF2->F2_PREFIXO .AND.;
										SE1->E1_NUM == SF2->F2_DUPL
										
										If SE1->E1_TIPMOV <> "1" .AND. SE1->E1_TIPMOV <> "7" // Boleto e Shopline
											SE1->(dbSkip())
											Loop
										Endif
										
										If Len(aTitulos) > 0
											nTit := aScan(aTitulos,{|x| x[2]+x[3]+x[4]+x[5] == SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO  })
										Else
											nTit := 0
										EndIf
										
										If nTit = 0
											SE1->( RecLock("SE1",.F.) )
											SE1->E1_NUMBCO := IIF( (cBanco == '341') ,Substr(xBuffer,63,08),Substr(xBuffer,71,12))	//Num do boleto no Banco
											
											nE1recno:=SE1->(RECNO())
											
											If Empty(SE1->E1_IDCNAB)
												SE1->(dbSetOrder(16))
												
												cIdCnab	:= GetSxeNum("SE1","E1_IDCNAB")
												
												While SE1->(DbSeek(xFilial("SE1")+cIdCnab))
													ConfirmSx8()
													cIdCnab := GetSxeNum("SE1","E1_IDCNAB")
												Enddo
												
												SE1->(DBGOTO(nE1recno))
												SE1->E1_IDCNAB := cIdCnab
												
												ConfirmSx8()
												//retirado a pedido do Sr. Giovanni em 24/09/2012
												//SE1->E1_HIST   := FileNoExt(Right(cArqEnt,12))
											EndIf
											SE1->( MsUnlock() )
											
											aAdd(aTitulos,{SE1->E1_IDCNAB,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_VALOR,SE1->E1_SALDO,SE1->E1_BAIXA,SE1->E1_PEDGAR})
										EndIf
										
										SE1->(dbSkip())
									EndDo
								EndIf
							EndIf
							lNewFat := .F.
						ElseIf SC6->C6_XOPER $ cOperNPF
							lNewFat := .T.
						EndiF
						SC6->(  DbSkip() )
					EndDo
				EndIf
				
				/*	--------------------------------------------
				Grava linha de detalhe atualizada
				--------------------------------------------*/
				If Len(aTitulos) > 0
					/*	-----------------------------------------
					Mais de um titulo encontrado para o PV
					-----------------------------------------*/
					cPedGarAnt := ""
					nSldTitCnab	:= nValPag+nValTax
					For nCt := 1 To Len(aTitulos)
						nSldTitCnab :=  nSldTitCnab - aTitulos[nCt,6]
						cLinDet 	:= Substr(xBuffer,  1, 37)					//Pos.  1 a 37
						
						IF SubStr(xBuffer,109,2) =="16"      //16-BAIXA POR NAO RECEBIMENTO
							cLinDet +="          16 "+aTitulos[nCt,2]+aTitulos[nCt,3]
						ELSEIF aTitulos[nCt,7]==0
							cLinDet +="          BX "+DTOS(aTitulos[nCt,8])+Space(4)
						ELSE
							cLinDet += aTitulos[nCt,1]+Space(15)
						ENDIF
						
						If cBanco == '341'
							cLinDet += PadR(aTitulos[nCt,2]+aTitulos[nCt,3]+aTitulos[nCt,4], 15)					//Pos. 63 a 77
							cLinDet += Substr(xBuffer, 78, 75)					//Pos. 78 a 152
						Else
							cLinDet += Substr(xBuffer, 63, 90)					//Pos. 63 a 152
						EndIf
						
						cLinDet += STRZERO(aTitulos[nCt,6]* 100,13)		//Pos.153 a 165	---> E1_VALOR
						If (cBanco == '341') //.and. aTitulos[nCt,9] == cPedGarAnt
							cLinDet += Substr(xBuffer,166, 10)	       			//Pos.166 a 175
							cLinDet += Replicate("0",13) 						//Pos.176 a 188 - zera Taxa para 2o titulo
							cLinDet += Substr(xBuffer,189, 52)					//Pos.189 a 240
							//nValTax := 0
						Else
							cLinDet += Substr(xBuffer,166, 75)	       			//Pos.166 a 240
						EndIF
						
						/* Valor recebido com abatimento ou juros */
						nValPag := IIF(nSldTitCnab >= 0 ,aTitulos[nCt,6],(aTitulos[nCt,6]-nValTax)+nSldTitCnab )
						If nCt < Len(aTitulos)
							cLinDet += StrZero(nDesc * 100,13)   			//Pos.241 a 253 ---> Desconto/Abat.
							cLinDet += STRZERO(nValPag * 100,13)	//Pos.254 a 266 ---> VALOR PAGO (RECEBIDO)
							cLinDet += StrZero(nJuros * 100,13)   			//Pos.267 a 279 ---> Juros
						Else
							nValPag := (nValPag + nJuros - nDesc )
							
							cLinDet += StrZero(nDesc * 100,13)   			//Pos.241 a 253 ---> Desconto/Abat.
							cLinDet += STRZERO(nValPag * 100,13)			//Pos.254 a 266 ---> VALOR PAGO (a maior ou a menor)
							cLinDet += StrZero(nJuros * 100,13)   			//Pos.267 a 279 ---> Juros
						EndIf
						cLinDet += Substr(xBuffer,280,16)   				//Pos.280 a 295
						cLinDet += Substr(dtos(dDatabx),7,2)+Substr(dtos(dDatabx),5,2)+Substr(dtos(dDatabx),3,2)   				//Pos.296 a 301
						cLinDet += Substr(xBuffer,302,93)   				//Pos.302 a 394
						cLinDet += StrZero(nNumSeq,6)  			   			//Pos.395 a 400
						cLinDet += CRLF
						/*
						------------------------------------------
						Grava o registro no arquivo texto
						------------------------------------------*/
						If FWRITE(nHdlNew,cLinDet,nTamDet) != nTamDet
							ApMsgAlert("Erro ao tentar gravar arquivo. O sistema será abortado.","INFO","ATENCAO")
							FCLOSE(nHdlNew)
							FCLOSE(nHdlBco)
							UserException("Erro ao tentar gravar arquivo "+" O sistema foi abortado propositalmente no ponto de entrada F200PORT. "+CRLF)
							If lLog
								SZQ->(Reclock("SZQ"))
								SZQ->ZQ_OCORREN := "Erro ao gravar linha desmembrada."
								SZQ->ZQ_STATUS := '5'
								SZQ->ZQ_DATA := ddatabase
								SZQ->ZQ_HORA:=time()
								SZQ->(MsUnlock())
								lConsist := .F.
							Endif
						Else
							If lLog
								SZQ->(Reclock("SZQ"))
								SZQ->ZQ_OCORREN := "Linha desmembrada com sucesso."
								SZQ->ZQ_STATUS := '4'
								SZQ->ZQ_DATA := ddatabase
								SZQ->ZQ_HORA:=time()
								SZQ->(MsUnlock())
							Endif
						EndIf
						If nCt < Len(aTitulos)
							nNumSeq++
						EndIf
						cPedGarAnt := aTitulos[nCt,9]
					Next
				ElseIf SC5->C5_TPCARGA <> '1' .and. !lNewFat
					/*
					cLinDet := Substr(xBuffer,1,394)
					cLinDet += StrZero(nNumSeq,6)
					cLinDet += CRLF
					*/
					cLinDet := Substr(xBuffer,  1, 37)					//Pos.  1 a 37
					cLinDet += 	"         TIT NAO LOCALIZ"+Space(1)			//Pos. 38 a 62  ---> E1_IDCNAB
					cLinDet += Substr(xBuffer,63,332)
					cLinDet += StrZero(nNumSeq,6)
					cLinDet += CRLF
					
					If FWRITE(nHdlNew,cLinDet,nTamDet) != nTamDet
						ApMsgAlert("Erro ao tentar gravar arquivo. O sistema será abortado.","INFO","ATENCAO")
						FCLOSE(nHdlNew)
						FCLOSE(nHdlBco)
						UserException("Erro ao tentar gravar arquivo "+" O sistema foi abortado propositalmente no ponto de entrada F200PORT. "+CRLF)
						If lLog
							SZQ->(Reclock("SZQ"))
							SZQ->ZQ_OCORREN := "Erro ao gravar linha."
							SZQ->ZQ_STATUS := '5'
							SZQ->ZQ_DATA := ddatabase
							SZQ->ZQ_HORA:=time()
							SZQ->(MsUnlock())
							lConsist := .F.
						Endif
					Else
						If lLog
							SZQ->(Reclock("SZQ"))
							SZQ->ZQ_OCORREN := "Título ref. ao Pedido não Localizado"
							SZQ->ZQ_STATUS := '5'
							SZQ->ZQ_DATA := ddatabase
							SZQ->ZQ_HORA:=time()
							SZQ->(MsUnlock())
							lConsist := .F.
						Endif
					EndIf
					nLidos+=nTamDet
					//Processando Pedido do Novo Ponto de Faturamento
				ElseIf lNewFat
					cLinDet := Substr(xBuffer,  1, 37)					//Pos.  1 a 37
					cLinDet += 	"         RECIBO DE PAGTO"+Space(1)			//Pos. 38 a 62  ---> E1_IDCNAB
					cLinDet += Substr(xBuffer,63,332)
					cLinDet += StrZero(nNumSeq,6)
					cLinDet += CRLF
					
					If FWRITE(nHdlNew,cLinDet,nTamDet) != nTamDet
						ApMsgAlert("Erro ao tentar gravar arquivo. O sistema será abortado.","INFO","ATENCAO")
						FCLOSE(nHdlNew)
						FCLOSE(nHdlBco)
						UserException("Erro ao tentar gravar arquivo "+" O sistema foi abortado propositalmente no ponto de entrada F200PORT. "+CRLF)
						If lLog
							SZQ->(Reclock("SZQ"))
							SZQ->ZQ_OCORREN := "Erro ao gravar linha."
							SZQ->ZQ_STATUS := '5'
							SZQ->ZQ_DATA := ddatabase
							SZQ->ZQ_HORA:=time()
							SZQ->(MsUnlock())
							lConsist := .F.
						Endif
					Else
						If lLog
							SZQ->(Reclock("SZQ"))
							SZQ->ZQ_OCORREN := "Recibo de Pagamento"
							SZQ->ZQ_STATUS := '4'
							SZQ->ZQ_DATA := ddatabase
							SZQ->ZQ_HORA:=time()
							SZQ->(MsUnlock())
							lConsist := .F.
						Endif
					EndIf
					nLidos+=nTamDet
				EndIf
			EndIf
		Endif
	Endif
	
	nLidos+=nTamDet
	dbCloseArea("_SC5")
EndDo

Fclose(nHdlBco)
Fclose(nHdlNew)

SZP->(Reclock("SZP"))

If nTipo == 1
	Ferase(cArqEnt)
ElseIf nTipo == 2
	U_VNDA390(cArqEnt, cArqEnt, "Arquivo Cnab Desmembrado em "+DTOC(ddatabase)+" as "+Time() , "SZP", SZP->ZP_ID )
Endif

IF lConsist
	If nTipo == 1
		SZP->ZP_STATUS := "2"  //distribuido
	Else
		SZP->ZP_STATUS := "4"  //Desmenbrado
		IF lFatInc
			SZP->ZP_OCORREN += " Desmembrado com inconsistência."
		Endif
		
	Endif
Else
	
	IF lFatInc .AND. nTipo == 2
		SZP->ZP_OCORREN += " Desmembrado com inconsistência."
	Endif
	SZP->ZP_STATUS := "5"  //inconsistente
Endif
SZP->ZP_DATA := ddatabase
SZP->ZP_HORA:=time()
SZP->(MsUnlock())

RestArea(_aArea)
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VdGetDirºAutor  ³Opvs (Darcio)       º Data ³  07/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao criada para ser utilizada na consulta padrao, para   º±±
±±º          ³selecionar o arquivo CNAB.                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Opvs x Certisign                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VdGetDir()
Local cMask := "Texto |*.txt|" + "Todos |*.*|"

//__cRetDir := Trim(cGetFile(cMask, "Selecione o Arquivo CNAB", 0,, .F., GETF_ONLYSERVER+GETF_NETWORKDRIVE))
__cRetDir := Trim(cGetFile(cMask, "Selecione o Arquivo CNAB", 0,, .F., GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE))

mv_par01 := __cRetDir

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VdRetDirºAutor  ³Opvs (Darcio)       º Data ³  07/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao criada para ser utilizada para trazer o retorno da   º±±
±±º          ³consulta padrao.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Opvs x Certisign                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VdRetDir()

Return __cRetDir


Static Function Reprocessa( cFile, cFileName )
	Local cSQL		:= ''
	Local cTRB		:= ''
	Local xBuffer	:= ''
	Local cFileNew	:= IIF( 'REPROCESS_' $ cFileName, rTrim(cFileName), 'REPROCESS_' + rTrim(cFileName) )
	Local aZQRecno	:= {}
	Local nHdlOri 	:= 0
	Local nHdlNew 	:= 0
	Local nQtdRec	:= 1
	Local nLin		:= 0
	Local nCount	:= 1
	Local nTamDet	:= 402

	DbSelectArea("ACB")
	DbSetOrder(2) //ACB_FILIAL+ACB_OBJETO

	While DbSeek( xFilial("ACB") + cFileNew )
		nLin		:= Rat(".",cFileNew)
		cFileNew	:= SubStr(cFileNew,1,nLin-1)+"("+cValToChar(nCount)+")"+SubStr(cFileNew,nLin,Len(cFileNew))
		nCount++
	End

	IncProc( 'Aguarde, consultando inconsistências...' )
	ProcessMessage()
	
	cSQL += "SELECT DISTINCT ZQ_LINHA, " + CRLF
	cSQL += "                ZQ_PEDIDO, " + CRLF
	cSQL += "                ZQ.R_E_C_N_O_ AS ZQ_RECNO " + CRLF
	cSQL += "FROM   " + RetSqlName('SZQ') + " ZQ " + CRLF
	cSQL += "       INNER JOIN " + RetSqlName('SC5') + " C5 " + CRLF
	cSQL += "               ON C5_FILIAL = ' ' " + CRLF
	cSQL += "                  AND C5_XNPSITE = ZQ_PEDIDO " + CRLF
	cSQL += "                  AND C5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       INNER JOIN " + RetSqlName('SC6') + " C6 " + CRLF
	cSQL += "               ON C6_FILIAL = C5_FILIAL " + CRLF
	cSQL += "                  AND C6_NUM = C5_NUM " + CRLF
	cSQL += "                  AND C6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "WHERE  ZQ.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND ZQ_FILIAL = '" + xFilial('SZQ') + "' " + CRLF
	cSQL += "       AND ZQ_ID = '" + SZP->ZP_ID + "' " + CRLF
	cSQL += "       AND ZQ_PEDIDO <> ' ' " + CRLF
	cSQL += "       AND NOT EXISTS (SELECT * " + CRLF
	cSQL += "                       FROM " + RetSqlName('SE1') + " E1 " + CRLF
	cSQL += "                       WHERE  E1.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                              AND E1_FILIAL = '" + xFilial('SE1') + "' " + CRLF
	cSQL += "                              AND SUBSTR(E1_PREFIXO, 1, 2) = 'RC' " + CRLF
	cSQL += "                              AND E1_NUM = C5_NUM " + CRLF
	cSQL += "                              AND E1_TIPO = 'NCC' " + CRLF
	cSQL += "                              AND E1_CLIENTE = C5_CLIENTE " + CRLF
	cSQL += "                              AND E1_XNPSITE = ZQ_PEDIDO) " + CRLF

	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)

	IF .NOT. (cTRB)->( EOF() )
		IF ( nHdlOri := FOPEN( rTrim(cFile) ) ) < 0
			MsgStop('Não foi possível abrir o arquivo de origem.')
			Return
		EndIF

		If ( nHdlNew := FCREATE( cFileNew ) ) < 0
			MsgStop('Não foi possível criar o arquivo reprocessado.')
			Return
		Endif

		FREAD(nHdlOri,@xBuffer,nTamDet)
		FWRITE(nHdlNew, xBuffer + CRLF, nTamDet)

		While .NOT. (cTRB)->( EOF() )
			IncProc( "Reprocessando registro "+Alltrim(Str(nQtdRec)) )
			ProcessMessage()
			aADD( aZQRecno, (cTRB)->ZQ_RECNO )
			chamaSeek( Val( (cTRB)->ZQ_LINHA ), @nHdlOri, @nHdlNew, @nTamDet, @xBuffer )

			nQtdRec++
			(cTRB)->( dbSkip() )
		End
		FClose( nHdlOri )
		FClose( nHdlNew )

		For nLin := 1 To Len( aZQRecno )
			SZQ->( dbGoto( aZQRecno[nLin] ) )
			SZQ->( Reclock('SZQ',.F.) )
			SZQ->ZQ_STATUS = '8'
			SZQ->( MsUnlock() )
		Next nLin

		U_VNDA390( cFileNew, cFileNew, "Arquivo Cnab reprocessado" , "SZP", SZP->ZP_ID )
		Ferase( cFileNew )

		U_GerFTCProc( MsDocPath() + "\" + cFileNew, 1 )
	EndIF
	(cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )
Return

Static function chamaseek( nLinha, nHdlOri, nHdlNew, nTamDet, xBuffer )
	Local nOffset := nLinha * nTamDet
	FSeek( nHdlOri, (nOffset - nTamDet), 0 )	
	FREAD( nHdlOri, @xBuffer, nTamDet )
	FWRITE( nHdlNew, xBuffer + CRLF, nTamDet )
Return
