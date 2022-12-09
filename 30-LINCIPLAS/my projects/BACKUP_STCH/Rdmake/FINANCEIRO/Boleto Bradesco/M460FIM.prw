#Include "Protheus.ch"
#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณM460FIM   บAutor  ณMicrosiga           บ Data ณ  03/27/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada apos a gravacao do SE1 para alteracao de   บฑฑ
ฑฑบ          ณalguns campos e a geracao do nosso numero.                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function M460FIM()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Grava no SE1 se ele deve ou nao ir para o Banco      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local _cProduto := POSICIONE("SD2",3,xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE, "D2_COD")
Local _cTipo 	:= POSICIONE("SC6",4,XFILIAL("SC6")+SF2->F2_DOC+SF2->F2_SERIE,"C6_CONTRT")
Local _cCliente := POSICIONE("SC6",4,XFILIAL("SC6")+SF2->F2_DOC+SF2->F2_SERIE,"C6_CLI")

//MSGBOX("CHAMOU A FUNวรO")

dbSelectArea("SA1")
dbSetOrder(1)
MsSeek(xFilial("SA1")+_cCliente)

//IF ALLTRIM(SA1->A1_BCO1) == "237"
//	MSGBOX("ENCONTROU O BANCO - " + _cCliente + " - " + SA1->A1_BCO1)
// AO INVEZ DE USAR IF PARA BUSCAR O BANCO NO CLIENTE SERม UTILIZADO O COMEวO DO CODIGO DOS PRODUTOS
// SENDO QUE OS PRODUTOS INICIADOS EM ("S010" ~ "S060") E "SPI35" DEVEM ENTRAR NESSA CONDIวรO.

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
				//Aviso("Aten็ใo!","Gentileza avisar o Alexandre do financeiro da MATRIZ no fone: 11-5185-8761 sobre a FAIXA DE CODIGO DO BANCO!!!",{"Voltar"},2)
				MSGBOX("Aten็ใo!, a numera็ใo da FAIXA DE CODIGO DO BANCO estแ acabando!")
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
	//	MSGBOX("CLIENTE SEM BANCO CADASTRADO OU PRODUTO NรO ษ DA SPIDER")
	
ENDIF

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCalcDig   บAutor  ณRicardo Nunes       บ Data ณ  27/03/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCalculo do digito verificador do nosso numero.              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Uso especifico para o BankBoston                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ01-_cNum - Numero do Titulo (Nosso Numero)                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
