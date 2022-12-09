#include 'Protheus.ch'
#include 'TbiConn.ch'
#include 'TopConn.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRETINTV   บAutor  ณBruno Daniel Abrigo บ Data ณ  05/23/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para definir o pulo de numeracao do lacre           บฑฑ
ฑฑบ          ณ deve retornar o ultimo recno dos itens da Z01              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Metalacre                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RetIntv(xPers)
Local aArea := GetArea()
Local _cRec:=''
Local cQry :=''

cQry := "SELECT TOP 1 R_E_C_N_O_'REC' FROM "+RetSqlName("Z01")+" "+CRLF
cQry += " WHERE Z01_COD = '"+xPers+"' AND D_E_L_E_T_ <> '*' ORDER BY R_E_C_N_O_ DESC "+CRLF
TCQUERY cQry New Alias 'TRB'


DbSelectArea('TRB');TRB->(DbGotop())

If TRB->(!Eof())
	DbSelectArea('Z00');Z00->(DbSetOrder(1)) // Necessario para WorkArea in use
	_cRec:=Alltrim(Str(TRB->(REC)));TRB->(DbCloseArea())
	RestArea(aArea)
	Return( _cRec )
Endif

TRB->(DbCloseArea())
RestArea(aArea)
Return( _cRec )
