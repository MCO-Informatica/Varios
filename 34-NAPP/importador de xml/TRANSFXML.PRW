#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
 
User Function TRANSFXML()

Processa({||RunProc()},"TRANSFERENCIA XML PARA SERVIDOR")
Return

Static Function RunProc()

Local _cFileTerm	:= '' 
Local _lLoop 		:= .T.
Local _aFiles 		:= {}
Local _aSizes 		:= {}
Local _nX
Private _cFileServ := "/importadorxml/inn/"

_cFileTerm := cGetFile( "Pasta XML | ",'Selecione a pasta dos arquivos XML',1,"C:\", .T., nOR(GETF_LOCALHARD,GETF_RETDIRECTORY),.F., .T. )

ADir(_cFileTerm+"*.xml", _aFiles, _aSizes)

ProcRegua(Len(_aFiles))

While _lLoop

	If Len(_aFiles)>0
		For _nX := 1 to Len( _aFiles )
			IncProc("Processando arquivo "+AllTrim(_aFiles[_nx]))
			CpyT2S(_cFileTerm+_aFiles[_nx],_cFileServ,.f.,.t.) 
		Next
		MsgStop("Os arquivos foram transferidos para o servidor!")
		_lLoop := .f.
	Else
		_lLoop := .f.
		MsgAlert("Não há arquivos na pasta selecionada!")
	EndIf	
EndDo    

MsgAlert("Rotina Finalizada!")

Return( Nil )
