#include "rwmake.ch"        
User Function NOMEAG()        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_NOMEAG,")

////  PROGRAMA PARA MOSTRAR O NOME DO BANCO NO CNAB QUANDO 
////  USADO TED OU DOC

IF SEA->EA_MODELO = "41" .OR. SEA->EA_MODELO ="43" .OR. SEA->EA_MODELO = "03"
	IF SA2->A2_BANCO = "001"
		_NOMEAG := "BANCO DO BRASIL"
	ELSEIF SA2->A2_BANCO = "033"
		_NOMEAG := "BANESPA SANTANDER"
	ELSEIF SA2->A2_BANCO = "104"
		_NOMEAG := "CAIXA"
	ELSEIF SA2->A2_BANCO = "107"
		_NOMEAG := "BBM"
	ELSEIF SA2->A2_BANCO = "151"
		_NOMEAG := "NOSSA CAIXA"
	ELSEIF SA2->A2_BANCO = "224"
		_NOMEAG := "FIBRA"
	ELSEIF SA2->A2_BANCO = "229"
		_NOMEAG := "CRUZEIRO DO SUL"
	ELSEIF SA2->A2_BANCO = "237"
		_NOMEAG := "BRADESCO"
	ELSEIF SA2->A2_BANCO = "291"
		_NOMEAG := "BCN"
	ELSEIF SA2->A2_BANCO = "341"
		_NOMEAG := "ITAU"
	ELSEIF SA2->A2_BANCO = "347"
		_NOMEAG := "SUDAMERIS"
	ELSEIF SA2->A2_BANCO = "353"
		_NOMEAG := "SANTANDER"
	ELSEIF SA2->A2_BANCO = "399"
		_NOMEAG := "HSBC"
	ELSEIF SA2->A2_BANCO = "409"
		_NOMEAG := "UNIBANCO"
	ELSEIF SA2->A2_BANCO = "422"
		_NOMEAG := "SAFRA"
	ELSEIF SA2->A2_BANCO = "453"
		_NOMEAG := "BANCO RURAL"
	ELSEIF SA2->A2_BANCO = "479"
		_NOMEAG := "BANK BOSTON"
	ELSEIF SA2->A2_BANCO = "754"
		_NOMEAG := "CITIBANK"
	ELSEIF SA2->A2_BANCO = "756"
		_NOMEAG := "SICOOB"
	ELSE
		_NOMEAG := "OUTROS BANCOS"
	ENDIF
Else
	_NOMEAG := ""
EndIf



Return(_NOMEAG) 