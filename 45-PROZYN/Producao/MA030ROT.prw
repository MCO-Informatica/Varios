
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA030ROT บAutor  ณNewbridge           บ Data ณ  08/22/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PE para tratar desbloqueio do cadastro de CLIENTES         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MA030ROT(xparam1,xparam2,xparam3)

Local aRet := {}

aAdd( aRet, {"Desbloq. Cliente",     "U_MARKBLOC()"    , 0, 2 } )

Return AClone(aRet)   


User Function M030Inc()  

if paramixb <> 3

DbSelectArea("SA1")
DbSetOrder(1)
If DbSeek(xFilial("SA1") + SA1->A1_COD + SA1->A1_LOJA )
	RecLock("SA1",.F.)
	SA1->A1_MSBLQL := '1'
	MsUnlock()
endif              
endif 
return       


User Function M030PALT()  

if paramixb[1] == 1

DbSelectArea("SA1")
DbSetOrder(1)

	If DbSeek(xFilial("SA1") + SA1->A1_COD + SA1->A1_LOJA )
		RecLock("SA1",.F.)
		SA1->A1_MSBLQL := '1'
		MsUnlock()                              
	endif          
endif
Return 

User Function MARKBLOC() 
local cLibUsr:= GetMV("MV_DBLCLIE")                       	
Local cUsr   := RetCodUsr()

If cUsr $ cLibUsr   

DbSelectArea("SA1")
DbSetOrder(1)

	If DbSeek(xFilial("SA1") + SA1->A1_COD + SA1->A1_LOJA )
		RecLock("SA1",.F.)
		SA1->A1_MSBLQL := '2'
		MsUnlock() 
	Endif
else
	Alert("O Usuแrio Logado nใo tem permissใo de acesso a esta Funcionalidade..")

Endif
Return