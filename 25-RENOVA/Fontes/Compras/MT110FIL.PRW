#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  MT110FIL   ºAutor  ³Pedro Augusto      º Data ³  29/10/09    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada filtrar usuario no browse da SC            ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Workflow RENOVA                                            º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function MT110FIL()
//Define variaveis
Local _aArea    := GetArea()
Local _nCall    := 1
Local _cString  := " "
Local _cFiltro  := " "
                                                         
Pergunte("MTA110",.f.)

//Carrega em variavel a pilha de chamada de funcoes
While !Empty(ProcName(_nCall))
	_cString +=AllTrim(ProcName(_nCall)) + "/"
	_nCall ++
EndDo

//Verifica se a chamada nao tem origem no system tracker.
If !("MATRKSHOW" $ Upper(_cString))
	//Se nao tiver origem no system tracker e o usuario logado for comprador, nao precisa existir filtro.
	DbSelectArea('SY1')
	DbSetOrder(3)
	If !DbSeek( xFilial('SY1')+__cUserId ) // nao é comprador, tem que ter filtro
		//Filtra os registros do usuario logado X solicitante X aprovador
		_cFiltro := "C1_USER == '"+__cUserID+ "' .AND. "
		//	      _cFiltro += "C1_FILDEST == '"+cFilAnt+"' .AND. C1_USER == '"+__cUserID+ "' .AND. "
		_cFiltro += "Empty(C1_XNUMANT) "
		
		DbSelectArea("SAK")
		DbSetOrder(2)
		If SAK->(DbSeek(xFilial("SAK") + __cUserId))
			DbSelectArea("SAL")
			DbSetOrder(1)
			DbGoTop()
			While !SAL->(Eof())
				If SAL->AL_USER == __cUserID
					_cFiltro += ".or. C1_GRAPROV == '"+ SAL->AL_COD+"' "
				Endif
				SAL->(DbSkip())
			Enddo
		Endif
	Else
		_cFiltro := "Empty(C1_XNUMANT) "  //Para nao mostras solicitações antigas a unificação caso seja comprador
	EndIf
Endif

RestArea(_aArea)

Return(_cFiltro)

