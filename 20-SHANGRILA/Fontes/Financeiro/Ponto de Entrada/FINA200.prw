#INCLUDE "PROTHEUS.CH"

/**
* Funcao		:	FINA200
* Autor			:	Jo�o Zabotto
* Data			: 	20/08/14
* Descricao		:	Ponto de Entrada Respons�vel por abater o valor do juros na contabiliza�~�ao do retorno do cnab no valor aglutinado 'VALOR'
* Retorno		: 	Nenhum
*/
User Function FINA200()
Local aArea := Getarea()

&& Valor Recebido no CNAB
nTotAGer -= nJuros

Restarea(aArea)

Return Nil
