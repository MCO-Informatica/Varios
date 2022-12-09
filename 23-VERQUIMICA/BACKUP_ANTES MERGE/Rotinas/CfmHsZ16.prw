#Include "Protheus.Ch"
#Include "TopConn.Ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+------------------+||
||| Programa: CfmAxZ16 | Autor: Celso Ferrone Martins   | Data: 09/04/2015 |||
||+-----------+--------+--------------------------------+------------------+||
||| Descricao | Axcadastro Anotacoes do cliente                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
User Function CfmHsZ16(cZ16Cli,cZ16Loj)

Local aAreaSa1  := SA1->(GetArea())
Default cZ16Cli := ""
Default cZ16Loj := ""
                       
DbSelectArea("SA1") ; DbSetOrder(1)
If SA1->(DbSeek(xFilial("SA1")+cZ16Cli+cZ16Loj))
	CfmTelaCli(cZ16Cli,cZ16Loj)
Else
	MsgAlert("Cliente nao encontrado...","Atencao!!!")
EndIf

SA1->(RestArea(aAreaSa1))

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: CfmTelaCli | Autor: Celso Ferrone Martins | Data: 26/03/2015 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao | Consulta Anotacoes de Clientes                             |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function CfmTelaCli(cUaCliente,cUaLoja)

Local cTexto     := "Anotacoes do Cliente"

//Private oPrint	 := TMSPrinter():New(cTexto)
Private nOpcao   := 0
Private oDlgImp

cZ16Clien := cUaCliente
cZ16Loja  := cUaLoja
cZ16Nome  := Posicione("SA1",1,xFilial("SA1")+cUaCliente+cUaLoja,"A1_NOME")

DEFINE MSDIALOG oDlgImp TITLE cTexto FROM 0,0 TO 140,150 PIXEL

@ 023,008 BUTTON "&Incluir"		SIZE 60,12 PIXEL ACTION (nOpcao:=1,oDlgImp:End()) OF oDlgImp
@ 038,008 BUTTON "&Consulta" 	SIZE 60,12 PIXEL ACTION (nOpcao:=2,oDlgImp:End()) OF oDlgImp

ACTIVATE MSDIALOG oDlgImp CENTERED


If nOpcao > 0
	
	If nOpcao == 1
		DbSelectArea("Z16") ; DbSetOrder(1)
		//AxInclui("Z16",0,3,"U_CFMOKZ16()")
		//AxInclui("Z16",0,3)
		AxInclui("Z16")
	EndIf
	
	If nOpcao == 2
		CfmQrZ16()
	EndIf
	
EndIf

Return(.T.)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+------------------+||
||| Programa: CfmAxZ16 | Autor: Celso Ferrone Martins   | Data: 09/04/2015 |||
||+-----------+--------+--------------------------------+------------------+||
||| Descricao | Axcadastro Anotacoes do cliente                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function CfmQrZ16()

Local cQuery   := ""
Local cEof     := Chr(13)+Chr(10)
Local cHistZ16 := ""

DbSelectArea("Z16") ; DbSetOrder(1)

cQuery += " SELECT * FROM " + RetSqlName("Z16") + " Z16" 
cQuery += " WHERE"
cQuery += "    Z16.D_E_L_E_T_ <> '*' "
cQuery += "    AND Z16_FILIAL = '"+xFilial("Z16")+"' "
cQuery += "    AND Z16_CLIENT = '"+SA1->A1_COD   +"' "
cQuery += "    AND Z16_LOJA   = '"+SA1->A1_LOJA  +"' "
cQuery += " ORDER BY Z16_FILIAL DESC, Z16_CLIENT DESC, Z16_LOJA DESC, Z16_DATA DESC, Z16_HORA DESC "

cQuery := ChangeQuery(cQuery)

If Select("TMPZ16") > 0
	TMPZ16->(DbCloseArea())
EndIf

TcQuery cQuery New Alias "TMPZ16"

While !TMPZ16->(Eof())
	If Z16->(DbSeek(xFilial("Z16")+TMPZ16->(Z16_CLIENT+Z16_LOJA+Z16_DATA+Z16_HORA)))
		cHistZ16 += Z16->Z16_USER+" - "
		cHistZ16 += dToc(Z16->Z16_DATA)+" - "
		cHistZ16 += Z16->Z16_HORA+cEof 
		cHistZ16 += Z16->Z16_HIST+cEof
		cHistZ16 += cEof 
	EndIf
	TMPZ16->(DbSkip())
EndDo

If Select("TMPZ16") > 0
	TMPZ16->(DbCloseArea())
EndIf

EECVIEW(@cHistZ16)
Return()