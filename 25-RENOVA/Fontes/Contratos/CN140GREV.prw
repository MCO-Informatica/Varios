#Include "Rwmake.ch"
#Include "Protheus.ch"
/*
================================================================
Programa.: 	CN140GREV
Autor....:	Pedro Augusto
Data.....: 	16/06/2015 º±±
Descricao: 	PE utilizado para determinar o grupo de aprovacao e
gerar alcada de aprovacao de revisao de contrato
Uso......: 	RENOVA
================================================================
*/
User Function CN140GREV()
Local aArea     := GetArea()
Local cContra   := PARAMIXB[1]
Local cRevisa   := PARAMIXB[2]
Local cNRevisa  := PARAMIXB[3]
Local _CliVen   := "" // SE PREENCHIDO É CONTRATO DE VENDA.

//	dbSelectArea("CN9")
//	dbSetOrder(1)
//	dbSeek(xFilial("CN9") + cContra) // Pega o grupo do contrato - revisao 000
//	cGrupo := CN9->CN9_APROV

dbSelectArea("CN9")
dbSetOrder(1)
dbSeek(xFilial("CN9") + cContra + cNRevisa)
_CliVen   := CN9->CN9_CLIENT // SE PREENCHIDO É CONTRATO DE VENDA.

If Empty(_CliVen)  //Só grava se for contrato de compra
	RecLock("CN9",.F.)
	CN9->CN9_XSTREV 	:= ''
	MsUnlock()
Endif

RestArea(aArea)
Return
        
