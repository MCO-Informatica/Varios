#include 'protheus.ch'

/*/{Protheus.doc} FileInputStream
(long_description)
@author    yuri.volpe
@since     13/07/2020
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
class FileInputStream 

	Data nHdl As Integer
	Data cNome As String
	Data cLastLine As String
	Data nTotalLines As Integer
	Data nLine As Integer

	method new(cFilename) constructor
	method open(cFilename)
	method hasNext()
	method readLine()
	method readLineToArray()
	method close()

endclass

/*/{Protheus.doc} new
Metodo construtor
@author    yuri.volpe
@since     13/07/2020
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
method new(cFilename) class FileInputStream

	::open(cFilename)

return

Method open(cFilename) class FileInputStream

	If !File(cFilename)
		MsgStop("Arquivo não encontrado")
		Return
	EndIf
	
	::nHdl := FT_FUSE(cFileName)
	::nLine := 1
	::cNome := cFileName
	
	If ::nHdl == -1
		MsgStop("O arquivo não pode ser aberto. Verfique se o arquivo está aberto e tente novamente.")
		Return
	EndIf
	
	::nTotalLines := FT_FLASTREC()
	FT_FGOTOP()

Return

Method hasNext() class FileInputStream
	FT_FSKIP()
	::nLine++
Return !FT_FEOF()

Method readLine() class FileInputStream
Return ::cLastLine := DecodeUTF8(FT_FREADLN())

Method readLineToArray(cToken) class FileInputStream
Return StrTokArr2(AllTrim(::cLastLine := DecodeUTF8(FT_FREADLN())),cToken,.T.)

Method close() class FileInputStream
	FT_FUSE()
	::nHdl := Nil
	::cNome := Nil
	::cLastLine := Nil
Return 
