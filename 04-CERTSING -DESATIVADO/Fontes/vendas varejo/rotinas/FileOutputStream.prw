#include 'protheus.ch'

/*/{Protheus.doc} Class FileOutputStream
Classe para criação e escrita em alto-nível de arquivos.

@author     yuri.volpe
@since      24/05/2021
@version    1.0

@property  	nHdl (int)  		Handle do arquivo criado
@property   lastLine (string)   Última linha escrita no arquivo
@property   size (int)   		Tamanho em bytes do arquivo
@property   lCreated (int)      Indica se o arquivo foi criado com sucesso
*/
Class FileOutputStream 

	Data nHdl 
	Data lastLine 
	Data size 
	Data lCreated
	
	Method new(cFileName) Constructor
	Method writeLine(cString) 
	Method write(cString)
	Method close()

endClass

/*/{Protheus.doc} New
Método construtor que recebe o nome do arquivo a ser criado. Alimenta a propriedade ::lCreated
para que seja verificado se o arquivo foi criado corretamente

@author     yuri.volpe
@since      24/05/2021
@version    1.0

@param      cFileName (string)  Nome completo do arquivo, com caminho

@return     null
*/
method new(cFileName) Class FileOutputStream

	::nHdl := FCreate(cFileName)
	::lCreated := .T.
	
	If ::nHdl == -1
		MsgInfo("Não foi possível criar o arquivo." + cFileName)
		::lCreated := .F.
	EndIf

return 

/*/{Protheus.doc} writeLine
Escreve uma linha com quebra de linha no handle aberto e devolve o número de bytes

@author     yuri.volpe
@since      24/05/2021
@version    1.0

@param      cString (string)  	Linha a ser gravada no arquivo

@return     nBytes (int)  		Número de bytes gravados no arquivo
*/
Method writeLine(cString) Class FileOutputStream

	::lastLine := cString + CHR(13) + CHR(10)
	
Return ::write(::lastLine)

/*/{Protheus.doc} write
Escreve uma linha no handle aberto e devolve o número de bytes escritos.

@author     yuri.volpe
@since      24/05/2021
@version    1.0

@param      cString (string)  	Servidor de E-mail

@return     nBytes (int)  		Número de bytes gravados no arquivo
*/
Method write(cString) Class FileOutputStream

	::lastLine := cString

Return ::size := fWrite(::nHdl, ::lastLine)

/*/{Protheus.doc} close
Fecha o handle do arquivo criado 

@author     yuri.volpe
@since      24/05/2021
@version    1.0

@param      null

@return     lClosed (bool)  Informa se o arquivo foi fechado
*/
Method close() Class FileOutputStream
Return fClose(::nHdl)
