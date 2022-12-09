#Include "Rwmake.ch"
#include "protheus.ch"
/*
================================================================
Programa.: 	CN100SIT  
Autor....:	Pedro Augusto
Data.....: 	15/10/15
Descricao: 	PE ponto de entrada para tratamento de inclusao de 
novas rotinas apos alterar a situacao do contrato    
Recebe PARAMIXB: 
PARAMIXB[1]: Situacao atual
PARAMIXB[2]: Situacao proposta
Uso......: 	RENOVA
================================================================
*/
User Function CN100SIT()
	Local _lOk 	:= .F.                              	
	Local _aArea 	:= CN9->(GetArea())
	If ParamIXB[2] = '04' .AND. CN9->CN9_ESPCTR == '1' // Somente Contratos de Compras devem passar por aprovação de alçadas.
		_lOk := RE100Alc('CT',CN9->CN9_NUMERO, CN9->CN9_REVISA, CN9->CN9_APROV)	// 	 O CN9_APROV já vem gravado, atraves do Pgatilho da unid.requisitante
	Else 
		_lOk := .T.
	Endif	
	RestArea(_aArea)
Return _lOk
/*
===================================================================
Programa.: 	EL100Alc  
Autor....:	Pedro Augusto
Data.....: 	23/05/15
Descricao: 	Gerar documento para aprovacao com alcada na tabela SCR 
especifico para finalizacao de contrato
Uso......: 	ELCA
====================================================================
*/
Static Function RE100Alc(cTipo, cNumero, cRevisa, cGrpApr)

	Local nTxMoeda 	:= 0    // Taxa da moeda
	Local cDoc     	:= ""   // Documento composto de numero do contrato + revisao
	Local cTipoDoc 	:= cTipo	// Indica que o documento é do tipo contrato
	Local cCodUsu	:= __cUserID
	Local lRet	   	:= .F.
	//Local _cRtip    :=""

	Default cRevisa := ""
	Default cGrpApr := ""

	cDoc     := cNumero + cRevisa
	nTxMoeda := recMoeda(dDataBase,CN9->CN9_MOEDA) // Taxa da moeda

	If CN9->(FieldPos("CN9_APROV")) > 0

		If !Empty(cGrpApr)
			dbSelectArea("SCR")
			dbSetOrder(2)
			If SCR->(DbSeek(xFilial("SCR")+cTipoDoc+cDoc))
				MaAlcDoc({cDoc,cTipoDoc,CN9->CN9_VLINI,,,cGrpApr,,1,1,dDataBase},dDataBase,3)   // exclusao, se existir
			Endif	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Guardar o grupo aprovador no contrato para gerar documento de liberacao (SCR)³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			MaAlcDoc({;
			cDoc,			;								//[1] Numero do documento
			cTipoDoc,		;   							//[2] Tipo de Documento
			IIf(CN9->CN9_VLINI==0,0.01,CN9->CN9_VLINI),	;   //[3] Valor do Documento
			"",				; 								//[4] Codigo do Aprovador
			cCodUsu,		;   							//[5] Codigo do Usuario
			cGrpApr,		;								//[6] Grupo do Aprovador
			"",				;   							//[7] Aprovador Superior
			CN9->CN9_MOEDA,	;   							//[8] Moeda do Documento		
			nTxMoeda,		;   							//[9] Taxa da Moeda
			dDataBase,		;   							//[10] Data de Emis.Doc.
			""}				;								//[11] Grupo de Compras
			,dDataBase,1,"",.F.)

			lRet := .T.
			//----------------------------------------------------------------------|
			//.........Inserido por André Couto em 23/07/2021.......................|
			/* Esta condição irá ler o cadastro de aprovadores e irá ajustar o......|
			| Aprovador Substito nos casos de o aprovador principal estar de ferias |
			| ou ausente..........................................................*/	
				If cTipoDoc=="CT"
					DbSelectArea("SCR")
						DbSetOrder(1)
						If SCR->(DbSeek(xFilial("SCR")+cTipoDoc+Padr(cDoc, TamSX3("CR_NUM")[1])))  
							While SCR->(CR_FILIAL + CR_TIPO + CR_NUM) = xFilial("SCR")+  cTipoDoc+Padr(cDoc, TamSX3("CR_NUM")[1]).AND. SCR->CR_STATUS = "02"  .and. !SCR->(Eof()) 
							DbSelectArea("SAK")
								DbSetOrder(1)//SE O USUÁRIO TIVER COM A DATA PREENCHIDA, ELE VERIFICA SE HOJE O INTERVALO ESTÁ ATIVO
								IF SAK->(DbSeek(xFilial("SAK")+SCR->CR_APROV)) .AND. (!Empty(SAK->AK_XDTFERI) .And. !Empty(SAK->AK_XDFERIA))
									IF (Date() >= SAK->AK_XDTFERI .And. Date() <= SAK->AK_XDFERIA)
										IF !Empty(SAK->AK_APROSUP)								
											Reclock("SCR",.F.) //Jogo aqui pra dentro o código do usuáiro do APROVADOR SUPERIOR
												SCR->CR_USER := Posicione("SAK",1,xFilial("SAK")+SAK->AK_APROSUP,"AK_USER")
												SCR->CR_WF		:= Space(01)
												SCR->CR_WFID   	:= Space(10) //CR_XWFID
												SCR->CR_DTLIMIT	:= CtoD("  /  /  ")
												SCR->CR_HRLIMIT	:= Space(5)
											MSUnlock()
										EndIf
									ENDIF
								ENDIF		
								SCR->(DbSkip())
							Enddo	
						ENDIF
				ENDIF //Fim da manutenção André Couto

		Else
			MsgAlert("O tipo desse contrato requer um grupo de aprovação." + CRLF +"A situação do contrato não será modificada.","Atenção!") 
		EndIf
	Else
		MsgAlert("Não foi possível localizar o campo CN9_APROV. Atualize seu Dicionário." +  CRLF + "A situação do contrato não será modificada.","Atenção!") 
	EndIf
Return lRet
