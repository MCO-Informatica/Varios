#include 'Protheus.ch'
#include 'rwmake.ch'
#INCLUDE "FWBROWSE.CH"
#Include 'FWMVCDef.ch'
#INCLUDE "TBICONN.CH"
#Include "MSGRAPHI.CH"
#Include "FILEIO.CH"

/*
Função de Monitoramento de Balança - Prozyn
Gera arquivos de Leitura para captura do PALM
*/

User Function LeBalanca()
Local _lRet		:= .F.
// Prepara o Ambiente ERP
PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01' Tables 'CB7'

Private _oFont 		:= TFont():New("Arial",08,16,,.T.,,,,.T.)
Private _oFont24	:= TFont():New("Arial",16,28,,.T.,,,,.T.)
Private _oDlg
Private _oPeso      
Public lMsHelpAuto := .F.

_cFile := 'C:\PROTHEUS\BALANCA.INI'
_oFile := FWFileReader():New(_cFile)
_cSala := 'Não encontrada'
If (_oFile:Open())
   _cLinha := _oFile:GetLine()
   Conout(_cLinha)
   _cSala := SubStr(_cLinha, 6, 2)
   _oFile:Close()
endif
_cPeso := '000,00'
Define MsDialog _oDlg Title "Leitura de Balança - PROZYN" From 000, 000 to 220, 260 of oMainWnd Pixel
@ 011, 015 Say _oSayUsr PROMPT "Não feche essa tela, ela está sendo utilizada para leitura da Balança." Of _oDlg Pixel COLOR CLR_BLACK Size 080,60 FONT _oFont Pixel
@ 040, 025 Say _oSayBal PROMPT "Sala "+_cSala Of _oDlg Pixel COLOR CLR_BLACK Size 080,60 FONT _oFont24 Pixel COLOR CLR_GREEN Size 080,60 
@ 055, 025 Say _oPeso   PROMPT "Peso "+_cPeso Of _oDlg Pixel COLOR CLR_BLACK Size 080,60 FONT _oFont24 Pixel COLOR CLR_GREEN Size 080,60 
@ 080, 060 Button "Cancelar"   Size 30,12 Action ( _oDlg:End() ) of _oDlg Pixel 

nMilissegundos := 2000 // Disparo será de 2 em 2 segundos

oTimer := TTimer():New(nMilissegundos, {|| getBalanca(_cSala) }, _oDlg )
oTimer:Activate()

Activate MsDialog _oDlg //Centered 

Return .T.

/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\*/
Static Function getBalanca(_cSala)
	Private nHandle := 0

    Conout('Abrindo porta COM2...')
	lPort := MSOpenPort(nHandle,"COM2:9600,N,8,1")
    If !lPort
       Conout('Porta COM2 sem comunicacao!')
    EndIf
    
	If !lPort
       MsClosePort(nHandle)
       Conout('Abrindo porta COM1...')
	   lPort := MSOpenPort(nHandle,"COM1:9600,N,8,1") // paridade NENHUMA
    EndIf

	If !lPort
        MsClosePort(nHandle)
		lPort := MSOpenPort(nHandle,"COM2:9600,N,8,1") // paridade NENHUMA
		If !lPort 
            Conout('Abrindo porta COM3...')
			lPort := MSOpenPort(nHandle,"COM3:9600,N,8,1") // paridade NENHUMA
		EndIf
	EndIf
	
	If !lPort
		Alert("Não foi possível se conectar à porta")
		Return
	EndIf

	cPesoAux := space(20)
	nCont := 0

	nPesoL := 0
	aPeso:={}
    
    Sleep(200)
	MsRead(nHandle,@cPesoAux)
    conout('Peso Balanca: '+cPesoAux)
    //PB: 000,75 T: 000,00
    //PB:-000,05 T: 0
	_cPesoAnt := _cPeso
	_cPeso  := Substr(cPesoAux,5,6)
	_nPesoL := val(_cPeso)

//    If _cPesoAnt <> _cPeso
		_oPeso:Refresh()

		If _nPesoL > 0
		MemoWrite('BALANCA'+_cSala+'.APP', _cPeso)
		Else
		MemoWrite('BALANCA'+_cSala+'.APP', '000,00')   
		EndIf
//	EndIf
	MsClosePort(nHandle)
Return
