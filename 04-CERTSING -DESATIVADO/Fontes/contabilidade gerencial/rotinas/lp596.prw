#Include "protheus.ch"
#include "PRTOPDEF.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LP596     ºAutor  ³Donizete            º Data ³  10/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Este LP retorna dados para o LP 596 (compensação contas a  º±±
±±º          ³ a receber. Trata o posicionamento dos títulos.             º±±
±±º          ³ Adaptado do rdmake originalmente elaborado por XXXXXXXXXX  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Chamada no LP 596.                                         º±±
±±º          ³ Protheus 710/811                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAtualiz.  ³ 22/01/05                                                   º±±
|±º          ³ - alterado lógica de memoriação dos alias (getarea).       º±±
|±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LP596(_cPar1,_cPar2)
	// Definição das variáveis.
	Local _aArea   	:= GetArea()
	Local _aAreaSE1	:= {}
	Local _aAreaSE5	:= {}
	Local _aAreaSA1	:= {}
	Local _aAreaSED	:= {}
	Local _cRet		:= Space(20)
	Local _cCod		:= Space(TamSX3("A1_COD")[1])
	Local _cLoja		:= Space(TamSX3("A1_LOJA")[1])
	Local _cConta		:= Space(TamSX3("CT1_CONTA")[1])
	Local _cNat		:= Space(TamSX3("ED_CODIGO")[1]) //natureza do NF
	Local _cChaveRA	:= Space(23)
	Local _cChaveNF	:= Space(23)
	Local _cChave		:= Space(23)
	Local _cCliRA		:= Space(15)
	Local _cCliNF		:= Space(15)
	Local _cTIPO		:= Space(3)
	local _cTipMov		:= Space(1)
	local _cNatRA		:= Space(TamSX3("ED_CODIGO")[1]) //natureza do RA
	_cPar1 := Upper(Alltrim(_cPar1)) // Tipo de Dado a ser retornado.
	_cPar2 := Upper(Alltrim(_cPar2)) // Tipo de Dado a ser retornado.
	
	// 1- Salva area do SE5
	dbSelectArea("SE5")
	_aAreaSE5 := GetArea()
	
	// 2- Verifica como o usuário executou a compensacao se RA/NCC ou NF
	If Alltrim(SE5->E5_TIPO) $ "RA/NCC" // Usuário compensou posicionando na NF.
		_cChaveNF := SUBSTR(SE5->E5_DOCUMEN,1,16)+SE5->E5_CLIFOR+SE5->E5_LOJA
		_cChaveRA := SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
	Else // Usuário compensou posicionando no RA/NCC
		_cChaveNF := SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
		_cChaveRA := SUBSTR(SE5->E5_DOCUMEN,1,16)+SE5->E5_CLIFOR+SE5->E5_LOJA
	EndIf
	
	// 3- Restaura area do SE5
	RestArea(_aAreaSE5)
	
	
	// 4- Salva area do SE5
	dbSelectArea("SE1")
	_aAreaSE1 := GetArea()
	
	// 5- ordena o SE1 pela chave 1
	dbSetOrder(1) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	
	// 6- Obtem do titulo o nome reduzido do cliente da NF.
	dbSeek(xFilial("SE1")+_cChaveNF,.T.)
	
	If Found()
		_cCliNF		:=	Alltrim(SE1->E1_NOMCLI)
		_cTipMov	:=	SE1->E1_TIPMOV	// le tipo de movimento do título, vindo do processo de faturamento.
		
	EndIf
	
	// 7- Obtem do titulo o nome reduzido do cliente do RA.
	dbSetOrder(1)
	dbSeek(xFilial("SE1")+_cChaveRA,.T.)
	If Found()
		
		_cCliRA	  := 	Alltrim(SE1->E1_NOMCLI)
		_cTIPO    := 	SE1->E1_TIPO
		_cNatRA   :=	SE1->E1_NATUREZ
		
	EndIf
	
	// 8- Verifica tipo de dado solicitado pelo usuário.
	If _cPar2 == "NF"
		_cChave := _cChaveNF
	Else
		_cChave := _cChaveRA // Geralmente o _cPar2 está vazio e se utiliza os dados do cliente RA
	EndIf
	
	// 9- Posiciona no título conforme tipo escolhido pelo usuário.
	dbSeek(xFilial("SE1")+_cChave,.T.)
	_cCod	:= SE1->E1_CLIENTE
	_cLoja	:= SE1->E1_LOJA
	_cNat   := SE1->E1_NATUREZ
	
	// 5- Restaura area do SE1
	RestArea(_aAreaSE1)
	
	// Retorna dados conforme solicitado.
	If _cPar1 == "SA1" // Retorna conta do cliente.
		dbSelectArea("SA1")
		_aAreaSA1 := GetArea()
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+_ccod+_cloja)
		If Found()
			_cRet := SA1->A1_CONTA
		EndIf
		RestArea(_aAreaSA1)
		
	ElseIf _cPar1 == "SED" // Retorna dados da natureza financeira, pode ser a conta por exemplo.
		dbSelectArea("SED")
		_aAreaSED := GetArea()
		dbSetOrder(1)
		dbSeek(xFilial("SED")+_cNat)
		If Found()
			//_cRet := SED->ED_CODIGO
			
			// Solicitado por Jorge 21/11/07 - retornar campo ED_ZZCTAA
			_cRet := SED->ED_ZZCTAA
		EndIf
		RestArea(_aAreaSED)
		
	ElseIf _cPar1 == "CONTAD" // Retorna dados da natureza financeira, pode ser a conta por exemplo.
		
		IF _cTipo=='NCC'
			
			_cRet := '110301005' // Reembolso de Clientes
			
		else // Trantamento para RA
			
			_cRet := '110301002' 	//Adiantamento de clientes grava para op caso da Nat estar vazia
			//le da natureza pois pode ser conta de Adiantamento ou Reembolso
			
			dbSelectArea("SED")
			_aAreaSED := GetArea()
			dbSetOrder(1)
			dbSeek(xFilial("SED")+_cNatRA)
			
			If Found().AND. !Empty(SED->ED_CONTA)
				_cRet := SED->ED_CONTA
			EndIf
			
			RestArea(_aAreaSED)
			
			
		Endif
		
	ElseIf _cPar1 == "CONTAC" // Retorna dados da natureza financeira, pode ser a conta por exemplo.
		
		IF _cTipMov == '2'
			
			_cRet := '110302005' //adm de cartão cartão
			
		else
			_cRet := '110301001'
			/*
			dbSelectArea("SA1")
			_aAreaSA1 := GetArea()
			dbSetOrder(1)
			dbSeek(xFilial("SA1")+_ccod+_cloja)
			
			If Found()
			_cRet := SA1->A1_CONTA //Adiantamento de clientes
			EndIf
			
			RestArea(_aAreaSA1)
			*/
			
			IF SE1->E1_VEND1<>'VA0001' //Diferente de varejo
				_cRet:='110301004'
			ELSE
				_cRet:='110301001'
			Endif
		Endif
		
	ElseIf _cPar1 == "HIS" // Retorna histórico para o LP.
		_cChaveNF := Transform(_cChaveNF,"@R XXX/XXXXXXXXX/X/XXX")
		_cChaveRA := Transform(_cChaveRA,"@R XXX/XXXXXXXXX/X/XXX")
		_cRet := "COMP.CR. DO TIT.: "+_cChaveNF + "-" + _cCliNF + " C/ TIT.: " + _cChaveRA + "-" + 	_cCliRA
		
	ElseIf SubStr(_cPar1,1,3) == "E5_"
		_cRet := "SE5->(" + Alltrim(_cPar1) + ")"
		_cRet := &_cRet
		
	ElseIf SubStr(_cPar1,1,3) == "E1_"
		_cRet := "SE1->(" + Alltrim(_cPar1) + ")"
		_cRet := &_cRet
		
	EndIf
	
	// Restaura áreas de trabalho.
	RestArea(_aArea)
	
	// Retorna dado para o LP.
Return(_cRet)