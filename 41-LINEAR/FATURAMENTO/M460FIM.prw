#Include "Protheus.ch"
#INCLUDE "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M460FIM   �Autor  �Thiago Queiroz      � Data �  03/27/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada apos a gravacao do SE1 para alteracao de   ���
���          �alguns campos e a geracao do nosso numero.                  ���
���          �IMPRESS�O DO BOLETO DO BRADESCO E ITAU. DESATIVADO	      ���
���          �---------------------------------------	                  ���
���          �Programa utilizado para controlar os n�meros de s�rie       ���
�������������������������������������������������������������������������͹��
���Uso       � LINCIPLAS - FINANCEIRO                                     ���
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
Local cCodBco	:= SuperGetMV("MV_CODBCO", ," ")


// CRIAR PROCESSO PARA GRAVAR O N�MERO DE S�RIE NAS TABELAS SC6 E SZB E ATUALIZAR O N�MERO DE S�RIE NO CADASTRO DO CLIENTE


/*
// REMOVIDO POR THIAGO - SUPERTECH EM 19/06/2013

dbSelectArea("SA1")
dbSetOrder(1)
MsSeek(xFilial("SA1")+_cCliente)

//IF ALLTRIM(SA1->A1_BCO1) == "237"
//	MSGBOX("ENCONTROU O BANCO - " + _cCliente + " - " + SA1->A1_BCO1)
// AO INVES DE USAR IF PARA BUSCAR O BANCO NO CLIENTE SER� UTILIZADO O COME�O DO CODIGO DOS PRODUTOS
// SENDO QUE OS PRODUTOS INICIADOS EM ("S010" ~ "S060") E "SPI35" DEVEM ENTRAR NESSA CONDI��O.
IF (SUBSTR(_cProduto,1,4) >= "S010" .AND. SUBSTR(_cProduto,1,4) <= "S060") .OR. SUBSTR(_cProduto,1,5) == "SPI35"

	IF cCodBco == "237" //BRADESCO
		
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
				
				//MsSeek(xFilial("SEE")+SB1->B1_BANCO+SB1->B1_AGENCIA+SB1->B1_NUMCON+SB1->B1_SUBCTA)
				//MsSeek(xFilial("SEE")+"237"+"2501 "+"33175     "+"001") // -> CONTA GARANTIA -> BASE TESTE
				//MsSeek(xFilial("SEE")+"237"+"2501 "+"331750    "+"001") // -> CONTA GARANTIA -> BASE OFICIAL
				MsSeek(xFilial("SEE")+"237"+"2501 "+"33175     "+"001") // -> CONTA CORRENTE -> BASE OFICIAL
				
				//���������������������������������������������������������������Ŀ
				//� Grava no SE1 se ele deve ou nao ir para o Banco BRADESCO      �
				//� SERA UTILIZADA A CONTA CORRENTE AGORA E N�O A GARANTIA		  �
				//�����������������������������������������������������������������
				cnbco := SUBSTR(nossonum(),4,9)
				If Val(SEE->EE_FAXFIM)-Val(SEE->EE_FAXATU) < 500
					MSGBOX("Aten��o!, a numera��o da FAIXA DE CODIGO DO BANCO est� acabando!")
				Endif
				
				// CARTEIRA "02" REFERENTE A CONTA GARANTIA, N�O SER� UTILIZADO
				//xcpo := "0200"+SE1->E1_NUMBCO // -> CONTA GARANTIA -> BASE OFICIAL
				
				// CARTEIRA "09" REFERENTE A CONTA CORRENTE
				xcpo := "0900"+SE1->E1_NUMBCO
				_cDig := U_MOD11(xcpo,2,7)
				IF val(_cDig) == 10
					_cDig := "P"
				ELSE
					_cDig := SUBSTR(_cDig,2,1)
				ENDIF
				RecLock("SE1",.F.)
				//SE1->E1_NUMBCO	:= Alltrim(Str(Val(SE1->E1_NUMBCO)))+_cDig
				SE1->E1_NUMBCO		:= ALLTRIM(SE1->E1_NUMBCO) + _cDig
				SE1->E1_PORTAD2		:= "237"
				SE1->E1_BOLBRAD		:= "1"
				
				MsUnlock()
				dbSelectArea("SE1")
				dbSkip()
			EndDo
		EndIf
		
		RestArea(_aAreaSE1)
		
	ELSEIF cCodBco == "341" //ITAU
		
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
				MsSeek(xFilial("SEE")+"341"+"7646 "+"075270    "+"001") // -> CONTA CORRENTE -> BASE OFICIAL
				
				//���������������������������������������������������������������Ŀ
				//� Grava no SE1 se ele deve ou nao ir para o Banco ITAU	      �
				//� SERA UTILIZADA A CONTA CORRENTE 							  �
				//�����������������������������������������������������������������
				cnbco := SUBSTR(nossonum(),2,9)
				If Val(SEE->EE_FAXFIM)-Val(SEE->EE_FAXATU) < 500
					MSGBOX("Aten��o!, a numera��o da FAIXA DE CODIGO DO BANCO est� acabando!")
				Endif
				
				xcpo := "764607527109"+SUBSTR(SE1->E1_NUMBCO,2,9)
				_cDig := U_MOD10(xcpo,1,2)
				//IF val(_cDig) == 10
				//	_cDig := "P"
				//ELSE
				_cDig := SUBSTR(_cDig,2,1)
				//ENDIF
				RecLock("SE1",.F.)
				//SE1->E1_NUMBCO	:= Alltrim(Str(Val(SE1->E1_NUMBCO)))+_cDig
				SE1->E1_NUMBCO		:= ALLTRIM(SE1->E1_NUMBCO) + _cDig
				SE1->E1_PORTAD2		:= "341"
				SE1->E1_BOLBRAD		:= "1"
				
				MsUnlock()
				dbSelectArea("SE1")
				dbSkip()
			EndDo
		EndIf
		
		RestArea(_aAreaSE1)
		
	ENDIF
ENDIF

*/

RETURN
