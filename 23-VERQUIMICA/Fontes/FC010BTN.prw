#Include "Protheus.ch" 

User Function FC010BTN()  

Public cZ16Clien := ""
Public cZ16Loja  := ""
Public cZ16Nome  := ""
Public cZ16Orig  := "FINC010"
	
	if Paramixb[1] == 1            // Deve retornar o nome a ser exibido no botão
	       return "Anotações Cliente"
	elseif Paramixb[1] == 2        // Deve retornar a mensagem do botão (Show Hint)
	
	       return "Consulta as anotações registras para o cliente selecionado"
	else                          // Rotina a ser executada ao pressionar o botão
	       U_CfmHsZ16(SA1->A1_COD,SA1->A1_LOJA)
endif