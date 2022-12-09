#include "protheus.ch"

#DEFINE cFONT   '<b><font size="5" color="red"><b><u>'
#DEFINE cFONTOK '<font size="5" color="black">'
#DEFINE cFONTGR '<font size="5" color="Green">'
#DEFINE cNOFONT '</b></font></u></b> '
//---------------------------------------------------------------------------------
// Rotina | RFATG11           | Autor | Lucas Baia          | Data | 17/06/2021
//---------------------------------------------------------------------------------
// Descr. | Fonte customizado com objetivo de travar quando o Cliente não é 
//        | Segmentado e também precisa atualizar o cadastro quando realizou a 
//        | ultima compra em 2020 ou anterior.
//---------------------------------------------------------------------------------
// Uso    | Biodomani Indústria e Comércio Ltda
//--------------------------------------------------------------------------------- 
// OBS    | Colocar esse fonte através do Gatilho de C5_CLIENTE para C5_CLIENTE.
//--------------------------------------------------------------------------------- 
User Function RFATG11()

	Local _aArea        := GetArea()
	Local _lRet         := .F.
	Local _cCliente		:=	M->C5_CLIENTE
	Local _cLoja		:=	Iif(!Empty(M->C5_LOJACLI),M->C5_LOJACLI,'01')
	Local _cTipo        :=  M->C5_TIPO
	//Local dUltData      := Year(SA1->A1_ULTCOM)
	Local nDiasCompr    := dDataBase - IIF(Alltrim(DTOS(SA1->A1_ULTCOM)) == "",dDataBase,SA1->A1_ULTCOM)
	Local nDiasCadast   := dDataBase - IIF(Alltrim(DTOS(SA1->A1_YDTALT)) == "",dDataBase,SA1->A1_YDTALT)
	Local nRcno         := SA1->(Recno ( ))
	Private cCadastro   := "Clientes"
	Private aMemos      := {{"A1_CODMARC","A1_VM_MARC"},{"A1_OBS","A1_VM_OBS"}}
	Private bFiltraBrw  := {|| Nil}
	Private aRotina
	Private aRotAuto    := Nil
	Private aCpoAltSA1  := {} // Vetor usado na gravacao do historico de alteracoes
	Private aCpoSA1     := {} // Vetor usado na gravacao do historico de alteracoes
	Private lCGCValido  := .F. // Variavel usada na validacao do CNPJ/CPF (utilizando o Mashup)
	Private l030Auto    := .F. // Variavel usada para saber se é rotina automática
	Private cFilAux	    := cFilAnt // Variavel utilizada no FINC010


	//----> SÓ EXECUTAR SE A ROTINA FOR CHAMADA NA MATA410
	If Alltrim(FunName()) $"MATA410"

		//----> VERIFICA O TIPO DO PEDIDO
		If _cTipo$"NICP"
			DbSelectArea("SA1")
			SA1->(DbSetOrder(1))
			If SA1->(DbSeek(xFilial("SA1")+_cCliente+_cLoja))

				//----> VERIFICA SE TEM BLOQUEIO FINANCEIRO
				If Empty(SA1->A1_SATIV1)
					Alert( cFONT+"ATENÇÃO" + cNOFONT + cFONTOK + "<br>Cliente não segmentado."+chr(13)+;
						"<br>Favor revisar o cadastro do cliente e preencher o campo SEGMENTO na aba VENDAS"+cNOFONT)
					//MsgStop("Cliente não segmentado. Favor revisar o cadastro do cliente e preencher o campo SEGMENTO na aba VENDAS")
					If _lRet == .F.
						_lRet := .T.
						A030Altera("SA1",nRcno, 4)
					EndIf
				ENDIF

				//IF dUltData < Year(Date()) //---> Se o Ano do campo A1_ULTCOM for menor que 2021, ou seja, 2020 para baixo, exibir Mensagem.
				IF nDiasCompr > 180 //---> se a ultima compra for maior que 6 meses
					Alert( cFONT+"ATENÇÃO" + cNOFONT + cFONTOK + "<br>Cliente realizou a última compra a mais de 6 meses!"+chr(13)+;
						"<br>Data da Última Compra: "+ cNOFONT + cFONTGR+DToC(SA1->A1_ULTCOM)+cNOFONT+chr(13)+;
						cFONTOK+"Recomenda-se realizar a atualização cadastral e análise financeira deste Cliente."+cNOFONT)
					If _lRet == .F.
						_lRet := .T.
						A030Altera("SA1",nRcno, 4)
					EndIf
				EndIf

				IF nDiasCadast > 180  //---> se a ultima atualizacao de cadastro for maior que 6 meses
					Alert( cFONT+"ATENÇÃO" + cNOFONT + cFONTOK + "<br>Cliente realizou a última Atualização a mais de 6 meses!"+chr(13)+;
						"<br>Data da Última Alteração Cadastral: "+ cNOFONT + cFONTGR+DToC(SA1->A1_YDTALT)+cNOFONT+chr(13)+;
						cFONTOK+"É necessário realizar a atualização do cadastro deste Cliente."+cNOFONT)
					If _lRet == .F.
						_lRet := .T.
						A030Altera("SA1",nRcno, 4)
					EndIf
				EndIf
				/*
				IF _lRet == .F. .and. Empty(SA1->A1_YDTALT) //---> se o campo Data de Alteração estiver vazio, obriga-se realizar uma nova alteração.
					Alert( cFONT+"ATENÇÃO" + cNOFONT + cFONTOK + "<br>Atualização cadastral do Cliente."+chr(13)+;
						"É necessário realizar a atualização do cadastro deste Cliente."+cNOFONT)
					A030Altera("SA1",nRcno, 4)
				ENDIF*/
			EndIf
		EndIf
	EndIf

	RestArea(_aArea)

Return(_cLoja)
