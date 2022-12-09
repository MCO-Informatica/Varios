#INCLUDE "rwmake.ch"

// Programa: LS_SZX
// Autor   : Alexandre Dalpiaz
// Data    : 22/03/11
// Função  : integraçao EDI com TREND OPERADORA
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_SZX()
//////////////////////

Private cString := "SZX"

dbSelectArea("SZX")
dbSetOrder(1)

aRotina    := {}
cCadastro  := "Integração TREND OPERADORA"
aLegenda   := {}
aCores     := {}
nOpca := 0

Aadd(aRotina,{"Pesquisar" 			,"AxPesqui"	   		,0,1 })
Aadd(aRotina,{"Visualizar"  		,"AxVisual" 		,0,2 })
Aadd(aRotina,{"Incluir"  			,"AxInclui"			,0,3 })
Aadd(aRotina,{"Alterar"  			,"AxAltera" 		,0,4 })
Aadd(aRotina,{"Exclui"  			,"AxDeleta" 		,0,5 })
Aadd(aRotina,{"Integração" 			,"U_SZXImp" 		,0,3 })
Aadd(aRotina,{"Gera Boleto"			,"U_SZXBol" 		,0,8 })

DbSelectArea('SZX')
mBrowse( 7, 4,20,74,'SZX')
Return                 

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SZXIMP()
//////////////////////
Processa({|| _append()})
Return()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function _append()
/////////////////////////   

_cPath := GetMv('LS_TRENDOP')

If !file(_cPath + 'TRENDOPERADORA.CSV')
	MsgBox('Não existem arquivos para importação','Finalizando','ALERT')
	Return()
EndIf

_nQuant := mlCount(_cPath + 'TRENDOPERADORA.CSV',24)
ProcRegua(_nQuant)
DbSelectArea('SZX')
FT_FUSE(_cPath + 'TRENDOPERADORA.CSV')
FT_FGotop()
_lFirst := .t.	

Do	While ( !FT_FEof() )
		
	_cLinha  := FT_FREADLN()
	IncProc()
	If IsAlpha(left(_cLinha,1))
		FT_FSkip()
 		loop
	EndIf             
   			                                        
	//RESERVA;EMISSAO;COMISSAO;STATUS
	//238931;24/01/2011;9,79;C
   			
	_nPosic  := at(';',_cLinha) ; _cReserva := padl(left(_cLinha,_nPosic-1),10,'0')				; _cLinha := substr(_cLinha,_nPosic+1)
	_nPosic  := at(';',_cLinha) ; _dEmissao := ctod(left(_cLinha,_nPosic-1)) 					; _cLinha := substr(_cLinha,_nPosic+1)
	_nPosic  := at(';',_cLinha) ; _nValor   := val(strtran(left(_cLinha,_nPosic-1),',','.')) 	; _cLinha := substr(_cLinha,_nPosic+1)
	_cStatus := _cLinha
	
	DbSeek(xFilial('SZX') + _cReserva,.f.)
	_cSeq    := '00'
	_lInclui := .t.
	Do While !eof() .and. _cReserva == SZX->ZX_RESERVA
		If SZX->ZX_EMISSAO == _dEmissao .and. SZX->ZX_VALOR == _nValor .and. SZX->ZX_STATUS == _cStatus
			_lInclui := .f.
		EndIf
		_cSeq := SZX->ZX_SEQ
		DbSkip()
	EndDo	                       

	If _lInclui
		RecLock('SZX',.T.)
		SZX->ZX_FILIAL  := xFilial('SZX')
		SZX->ZX_RESERVA := _cReserva
		SZX->ZX_SEQ     := Soma1(_cSeq)
		SZX->ZX_EMISSAO := _dEmissao
		SZX->ZX_VALOR   := _nValor
		SZX->ZX_STATUS  := _cStatus
		MsUnLock()	              
	EndIf
	FT_FSkip()

EndDo

FT_FUse()

fRename('C:\PROTHEUS10\TRENDOPERADORA.CSV','C:\PROTHEUS10\TRENDOPERADORA_' + dtos(date()) + '.CSV')

Return

