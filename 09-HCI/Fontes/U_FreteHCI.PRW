#INCLUDE "PROTHEUS.CH"

User Function FreHCI()

	Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
	Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

	Private cString := "A99"

	dbSelectArea("A99")
	dbSetOrder(1)

	AxCadastro(cString,"Cadastro de Frete HCI",cVldExc,cVldAlt)

Return