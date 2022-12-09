#Include "Protheus.ch"
#INCLUDE "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������"��
���Programa  �M460FIM   �Autor  �Microsiga           � Data �  03/27/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada apos a gravacao do SE1 para alteracao de   ���
���          �alguns campos e a geracao do nosso numero.                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M460FIM()

//������������������������������������������������������Ŀ
//� Grava no SE1 se ele deve ou nao ir para o Banco      �
//��������������������������������������������������������

Local _cProduto := POSICIONE("SD2",3,xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE, "D2_COD")
Local _cTipo 	:= POSICIONE("SC6",4,XFILIAL("SC6")+SF2->F2_DOC+SF2->F2_SERIE,"C6_CONTRT")
Local _cCliente := POSICIONE("SC6",4,XFILIAL("SC6")+SF2->F2_DOC+SF2->F2_SERIE,"C6_CLI")

//MSGBOX("CHAMOU A FUN��O")

dbSelectArea("SA1")
dbSetOrder(1)
MsSeek(xFilial("SA1")+_cCliente)

//IF ALLTRIM(SA1->A1_BCO1) == "237"
//	MSGBOX("ENCONTROU O BANCO - " + _cCliente + " - " + SA1->A1_BCO1)
// AO INVEZ DE USAR IF PARA BUSCAR O BANCO NO CLIENTE SER� UTILIZADO O COME�O DO CODIGO DOS PRODUTOS
// SENDO QUE OS PRODUTOS INICIADOS EM ("S010" ~ "S060") E "SPI35" DEVEM ENTRAR NESSA CONDI��O.

IF (SUBSTR(_cProduto,1,4) >= "S010" .AND. SUBSTR(_cProduto,1,4) <= "S060") .OR. SUBSTR(_cProduto,1,5) == "SPI35"
	
	If !SF2->F2_TIPO $ "D/B"
		dbSelectArea("SE1")
		_aAreaSE1  := GetArea("SE1")
		dbSetOrder(1)
		MsSeek(xFilial("SE1")+SF2->F2_SERIE+SF2->F2_DOC)
		While !eof() .and. SE1->E1_NUM+SE1->E1_PREFIXO+SE1->E1_CLIENTE+SE1->E1_LOJA==SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA
			dbSelectArea("SB1")
			dbSetOrder(1)
			MsSeek(xFilial("SB1")+_cProduto)
			dbSelectArea("SEE")
			dbSetOrder(1)
			//dbSelectArea("SEE")
			
			// 	MsSeek(xFilial("SEE")+SB1->B1_BANCO+SB1->B1_AGENCIA+SB1->B1_NUMCON+SB1->B1_SUBCTA)
			//	MsSeek(xFilial("SEE")+"237"+"2501 "+"33175     "+"001") // -> BASE TESTE
			MsSeek(xFilial("SEE")+"237"+"2501 "+"331750    "+"001") // -> BASE OFICIAL
			//			If SubStr(SE1->E1_TIPO,3,1) == "-"
			//				SE1->(dbSkip())
			//				Loop
			//			Endif
			// NossoNum()
			cnbco := SUBSTR(nossonum(),4,9)
			If Val(SEE->EE_FAXFIM)-Val(SEE->EE_FAXATU) < 500
				//Aviso("Aten��o!","Gentileza avisar o Alexandre do financeiro da MATRIZ no fone: 11-5185-8761 sobre a FAIXA DE CODIGO DO BANCO!!!",{"Voltar"},2)
				MSGBOX("Aten��o!, a numera��o da FAIXA DE CODIGO DO BANCO est� acabando!")
			Endif
			//			MSGBOX("02"+=STRZERO(VAL(SE1->E1_NUMBCO),11))
			//			MODULO11("02"+=STRZERO(VAL(SE1->E1_NUMBCO),11),2,7) := ""
			xcpo := "0200"+SE1->E1_NUMBCO
			_cDig := U_MOD11(xcpo,2,7)
			IF val(_cDig) == 10
				_cDig := "P"
			ELSE
				_cDig := SUBSTR(_cDig,2,1)
			ENDIF
			// _cDig := U_CalcDig(Val(SE1->E1_NUMBCO))
			RecLock("SE1",.F.)
			//SE1->E1_NUMBCO  := Alltrim(Str(Val(SE1->E1_NUMBCO)))+_cDig
			SE1->E1_NUMBCO    := ALLTRIM(SE1->E1_NUMBCO) + _cDig
			SE1->E1_PORTAD2  := "237"
			//		SE1->E1_FORMCOB := POSICIONE("SA1",1,XFILIAL("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_FORMCOB")
			
			/*
			If Alltrim(_cProduto) == "RET"
			SE1->E1_HIST    := "RETAINER"
			ElseIf _cTipo == Space(15)
			SE1->E1_HIST    := "SERVICOS"
			Else
			SE1->E1_HIST    := "CONTRATOS"
			Endif
			*/
			
			MsUnlock()
			dbSelectArea("SE1")
			dbSkip()
		EndDo
	EndIf
	
	RestArea(_aAreaSE1)
	
	//ELSE
	//	MSGBOX("CLIENTE SEM BANCO CADASTRADO OU PRODUTO N�O � DA SPIDER")
	
ENDIF

RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CalcDig   �Autor  �Ricardo Nunes       � Data �  27/03/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Calculo do digito verificador do nosso numero.              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Uso especifico para o BankBoston                           ���
�������������������������������������������������������������������������͹��
���Parametros�01-_cNum - Numero do Titulo (Nosso Numero)                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//User Function CalcDig(_cNum)

User Function Mod11(cStr,nMultIni,nMultFim)
Local i, nModulo := 0, cChar, nMult

nMultIni := Iif( nMultIni==Nil,2,nMultIni )
nMultFim := Iif( nMultFim==Nil,9,nMultFim )
nMult := nMultIni
cStr := AllTrim(cStr)

For i := Len(cStr) to 1 Step -1
	cChar := Substr(cStr,i,1)
	If isAlpha( cChar )
		Help(" ", 1, "ONLYNUM")
		Return .f.
	End
	nModulo += Val(cChar)*nMult
	nMult:= IIf(nMult==nMultfim,2,nMult+1)
Next
nRest := nModulo % 11
IF nRest == 0
	nRest := 0
ELSEIF nRest == 1
	nRest := 10
ELSE
	nRest := 11-nRest
	//nRest := IIf(nRest==0 .or. nRest==1,0,11-nRest)
ENDIF

Return(Str(nRest,2))


//Return(Str(_cDigito,1))
