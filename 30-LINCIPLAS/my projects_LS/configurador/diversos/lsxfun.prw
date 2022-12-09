#INCLUDE "PROTHEUS.CH"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	LSXFUN
// Autor 		Richard Nahas Cabral
// Data 		19/05/2014
// Descricao  	Funcoes Diversas
// Uso         	LaSelva
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

User Function LSXFUN()

Return


User Function LSLogSB2(cTexto)

Local cEOL    := CHR(13)+CHR(10)
Local cArqLog := "\Logs\LogSb2.log"
Local nHdlLog

If File(cArqLog)
	nHdlLog := fOpen(cArqLog,2)

	If nHdlLog == -1
		MsgAlert("Impossivel Abrir Arquivo " + cArqLog + " Verificar...","Atencao!")
		Return 
	Endif
	
	fSeek(nHdlLog,0,2)

Else	
    nHdlLog := fCreate(cArqLog)

	If nHdlLog == -1
		MsgAlert("Impossivel Criar Arquivo " + cArqLog + " Verificar...","Atencao!")
		Return 
	Endif

	cLine := "Data       Hora  Usuario         Rotina     Ocorrencia" + cEOL 
	fWrite(nHdlLog,cLine,Len(cLine))
EndIf

cLine := DtoC(Date()) + " " + Left(Time(),5) + " " + Substr(cUsuario,7,15) + " " + Padr(FunName(),10) + " " + Alltrim(cTexto) + cEOL

fWrite(nHdlLog,cLine,Len(cLine))
fClose(nHdlLog)

Return .T.

//
//Data       Hora  Usuario         Rotina     Ocorrencia     
//99/99/9999 99.99 xxxxxxxxxxxxxxx xxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//