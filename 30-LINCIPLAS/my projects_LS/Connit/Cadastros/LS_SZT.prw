#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
// Programa.: ls_szt
// Autor....: Alexandre Dalpiaz
// Data.....: 31/01/2011
// Descrição: reservas
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_SZT()
//////////////////////
Local aArea  	:= GetArea()
Local cAlias  	:= "SZT"   
aLegenda  := {}
aCores    := {}

aAdd(aLegenda, {'BR_VERDE'	  	,'Ativa'       		, '1'	})
aAdd(aLegenda, {'BR_AMARELO' 	,'Em Uso'    		, '2'	})
aAdd(aLegenda, {'BR_VERMELHO'	,'Encerrada' 		, '3'	})
aAdd(aLegenda, {'BR_PRETO'	    ,'Cancelada' 		, '4'	})

Aadd(aCores,{ "ZT_STATUS == '1'"         , 'BR_VERDE'		}) // ATIVA
Aadd(aCores,{ "ZT_STATUS == '2'"         , 'BR_AMARELO'		}) // EM USO
Aadd(aCores,{ "ZT_STATUS == '3'"          , 'BR_PRETO'   	}) // CANCELADA
Aadd(aCores,{ "ZT_STATUS == '4'"         , 'BR_VERMELHO'	}) // ENCERRADO

_cQuery := "UPDATE " + RetSqlName('SZT')
_cQuery += _cEnter + " SET ZT_STATUS = '4'"
_cQuery += _cEnter + " WHERE D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND ZT_STATUS IN ('1','2')"
_cQuery += _cEnter + " AND ZT_DATARES + ZT_HORAFIM < '" + dtos(date()) + left(time(),2) + substr(time(),4,2) + "'"
TcSqlExec(_cQuery)

_cQuery := "UPDATE " + RetSqlName('SZT')
_cQuery += _cEnter + " SET ZT_STATUS = '2'"
_cQuery += _cEnter + " WHERE D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND ZT_STATUS = '1'"
_cQuery += _cEnter + " AND ZT_DATARES + ZT_HORAINI < '" + dtos(date()) + left(time(),2) + substr(time(),4,2) + "'"
_cQuery += _cEnter + " AND ZT_DATARES + ZT_HORAFIM > '" + dtos(date()) + left(time(),2) + substr(time(),4,2) + "'"
TcSqlExec(_cQuery)

aRotina    := {}
cCadastro  := "Cadastro de Reservas"
nOpca := 0

Aadd(aRotina,{"Pesquisar" 			,"AxPesqui"	   		,0,1 })
Aadd(aRotina,{"Visualizar"  		,"AxVisual" 		,0,2 })
Aadd(aRotina,{"Incluir"  			,"U_SZTINC"			,0,3 })
Aadd(aRotina,{"Alterar"  			,"U_SZTALT" 		,0,4 })
Aadd(aRotina,{"Exclui"  			,"U_SZTDEL" 		,0,5 })
//Aadd(aRotina,{"Disponibilidade"		,"U_SZTDIS" 		,0,5 })
Aadd(aRotina,{"Legenda"  			,"BrwLegenda('Central de Reservas' , 'Legenda' , aLegenda)"		,0,3 })

DbSelectArea('SZT')
mBrowse( 7, 4,20,74,cAlias,,,,,,aCores)

Return()
                                                                                       
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SZTINC()
//////////////////////

nOpca := AxInclui("SZT",SZT->(Recno()), 3, ,, , "U_SZTTUDOOK()")

Return()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SZTTUDOOK()
/////////////////////////                                                    

If M->ZT_STATUS == '1' .and. M->ZT_DATARES == date() .and. (M->ZT_HORAINI < left(time(),2) + substr(time(),4,2) .or. M->ZT_HORAFIM < left(time(),2) + substr(time(),4,2))
	MsgBox('Data / horário da reserva inválido','ATENÇÃO!!!','ALERT')
	Return(.f.)
EndIf
                         
_cQuery := "SELECT *"
_cQuery += _cEnter + " FROM " + RetSqlName('SZT') + " SZT (NOLOCK)"
_cQuery += _cEnter + " WHERE ZT_OBJETO = '" + M->ZT_OBJETO + "'"
_cQuery += _cEnter + " AND ZT_DATARES = '" + dtos(M->ZT_DATARES) + "'"         

_cQuery += _cEnter + " AND ("
_cQuery += _cEnter + " (ZT_HORAINI <= '" + M->ZT_HORAINI + "' AND ZT_HORAFIM >= '" + M->ZT_HORAFIM + "') OR "
_cQuery += _cEnter + " (ZT_HORAINI >= '" + M->ZT_HORAINI + "' AND ZT_HORAFIM <= '" + M->ZT_HORAFIM + "') OR "
_cQuery += _cEnter + " (ZT_HORAINI <= '" + M->ZT_HORAINI + "' AND ZT_HORAFIM <= '" + M->ZT_HORAFIM + "' AND ZT_HORAINI >= '" + M->ZT_HORAINI + "' ) OR "
//_cQuery += _cEnter + " (ZT_HORAINI >= '" + M->ZT_HORAINI + "' AND ZT_HORAFIM >= '" + M->ZT_HORAFIM + "') OR "
_cQuery += _cEnter + " ('" + M->ZT_HORAINI + "' BETWEEN ZT_HORAINI AND ZT_HORAFIM ) OR "
_cQuery += _cEnter + " ('" + M->ZT_HORAFIM + "' BETWEEN ZT_HORAINI AND ZT_HORAFIM ) OR "

_cQuery += _cEnter + " (ZT_HORAINI >= '" + M->ZT_HORAINI + "' AND ZT_HORAFIM <= '" + M->ZT_HORAFIM + "')) "
_cQuery += _cEnter + " AND SZT.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND ZT_STATUS IN ('1','2')"

U_GravaQuery('SZTVALIDA.SQL',_cQuery)
MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_SZT', .F., .T.) },'Pesquisando Reservas...')
           
_cMsg := ''
Do While !eof()
	_cMsg += tran(_SZT->ZT_HORAINI ,'@R 99:99') + ' as ' + tran(_SZT->ZT_HORAFIM ,'@R 99:99') + ' reservado por ' + alltrim(_SZT->ZT_NOMUSU) + _cEnter
	DbSkip()
EndDo

_lRet := empty(_cMsg)

If !empty(_cMsg)                               
	_cMsg := alltrim(Posicione('SX5',1,xFilial('SX5')+'ZS'+M->ZT_OBJETO,'X5_DESCRI')) + ' para o(s) seguinte(s) horário(s):' + _cEnter + _cEnter + _cMsg
	MsgBox(_cMsg,'Central de Reservas','ALERT')
EndIf

DbCloseArea()        

Return(_lRet)                

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SZTALT()
//////////////////////

If SZT->ZT_STATUS == '4'
	MsgBox('Reserva encerrada, não pode ser alterada','ATENÇÃO!!!','ALERT')
	Return()
EndIf

DbSelectArea('SZT')
DbSetOrder(1)

If __cUserId == SZT->ZT_USUARIO .or. __cUserId $ GetMv('LA_PODER') + GetMv('LS_RESERVA')

	nOpca := AxAltera("SZT",SZT->(Recno()), 3,,,,, "U_SZTTUDOOK()")
	If nOpca == 1
		RecLock('SZT')
		SZT->ZT_NOMEALT := cUserName
		MsUnLock()
	EndIf
Else 
	MsgBox('Somente o usuário que inclui pode alterar a reserva','Central de Reservas','ALERT')
EndIf

Return()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SZTDEL()
//////////////////////

If SZT->ZT_STATUS == '4'
	MsgBox('Reserva encerrada, não pode ser excluída','ATENÇÃO!!!','ALERT')
	Return()
EndIf

If __cUserId == SZT->ZT_USUARIO .or. __cUserId $ GetMv('LA_PODER') + GetMv('LS_RESERVA')
	nOpca := AxDeleta("SZT",SZT->(Recno()), 5)
	If nOpca == 1
		RecLock('SZT')
		SZT->ZT_NOMEALT := cUserName
		MsUnLock()
	EndIf
Else 
	MsgBox('Somente o usuário que inclui pode excluir a reserva','Central de Reservas','ALERT')
EndIf


Return()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function VL_ZT_OBJ()
/////////////////////////
If (M->ZT_OBJETO == '01' .and. __cUserId $ GetMv('LS_RESERVA') + GetMv('LA_PODER')) .or. M->ZT_OBJETO <> '01'
	_lRet := .t.

Else
	_lRet := .f.
	MsgBox('Sala reservada somente para diretoria','ATENÇÃO!!!!','ALERT')
EndIf	
	
	
/*
If _lRet .and. M->ZT_OBJETO == '05'
  	_lRet := .f.
	MsgBox('Sala Não Disponível','ATENÇÃO!!!!','ALERT')
EndIf
*/
Return(_lRet)


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SZTDIS()
///////////////////////

DbSelectArea('SX5')
DBSeek(xFilial('SX5') + 'ZS',.f.)
_aObjetos := {}
Do While !eof() .and. xFilial('SX5') + 'ZS' == SX5->X5_FILIAL + SX5->X5_TABELA
	aAdd(_aObjetos,{SX5->X5_CHAVE, SX5->X5_DESCRI}) 
	DbSkip()
EndDo

DEFINE FONT oFont   NAME 'Arial Black' SIZE 14, 15 Bold
_dData := date()

DEFINE MSDIALOG oDlg TITLE 'Disponibilidades' FROM 000,000 TO 400,800 PIXEL 
                                             
@ 010,010 say 'Data: ' Font oFont 	Size 18,12 COLOR CLR_RED  	PIXEL OF oDlg
@ 010,030 MsGet _oData Var _dData   Size 25,12 COLOR CLR_BLUE	PIXEL OF oDlg
                            
For _nI := 1 to len(_aObjetos)
	@ 010 + _nI * 010 , 010 Say _aObjetos[1] + ' - ' + _aObjetos[2] Font oFont Size C(018),C(008) COLOR CLR_BLACK  PIXEL OF oDlg
	@ 030 + _nI * 010 , 010 say ''
	
Next
	
@ C(150),C(220) Button "Ok" 							Size C(037),C(012) 					PIXEL OF oDlg ACTION(GrvRom(lSaida))

fListBox1(lSaida)

ACTIVATE MSDIALOG oDlg CENTERED

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function AtuDisp()                                                	
/////////////////////////

_cQuery := "SELECT *"
_cQuery += _cEnter + "FROM " + RetSqlName('SZT') + " SZT (NOLOCK)"
_cQuery += _cEnter + "WHERE ZT_DATARES = '" + dtos(_dData) + "'"
_cQuery += _cEnter + "AND SZT.D_E_L_E_T_ = ''"
_cQuery += _cEnter + "ORDER BY ZT_OBJETO, ZT_HORAINI"
