#include 'protheus.ch'


//-------------------------------------------------------------------
/*/{Protheus.doc} SFLYBUILD
Realiza a cria��o, escreve e salva o arquivo CSV.
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
class SFLYBUILD

	method new() constructor
	method saveFile()
	method wrtBOF()
	method wrtEOF()
	method wrtContent()
	

	data fileName as character  //nome do arquivo CSV
	data handleArq as numeric   //handle do arquivo CSV
	data cMsgErro  as character

endclass

//-------------------------------------------------------------------
/*/{Protheus.doc} new
m�todo construtor
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
@param   cPath, character, caminho do arquivo CSV
@param   cArquivo, character, nome do arquivo CSV
@param   cMsgErro, character, mensagem de erro
@return  object, self
/*/
//-------------------------------------------------------------------
method new(cPath, cArquivo, cMsgErro, lRet) class SFLYBUILD
	local oSfUtils as object

	oSfUtils := SFUTILS():new()

	//-------------------------------------
	//Realiza a cria��o do arquivo CSV
	//-------------------------------------
	self:fileName := cPath+"\"+cArquivo
	self:handleArq := FCreate(self:fileName)

	if self:handleArq  < 0
		cMsgErro += "[LayoutBuilder] Erro ao criar o arquivo "+cArquivo+" : "+ Str(Ferror())
		lRet = .F.
	endif

	
return  

//-------------------------------------------------------------------
/*/{Protheus.doc} saveFile
Salva o arquivo CSV
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method saveFile() class SFLYBUILD
	FClose(self:handleArq)
return

//-------------------------------------------------------------------
/*/{Protheus.doc} wrtBof
Escreve o marcador de come�o de arquivo no CSV.
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method wrtBof() class SFLYBUILD
	FWrite(self:handleArq,"BOF_"+dtos(date())+CRLF)
return

//-------------------------------------------------------------------
/*/{Protheus.doc} wrtEof
Escreve o marcador de final de arquivo no CSV.
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method wrtEof() class SFLYBUILD
	FWrite(self:handleArq,"EOF_"+dtos(date()))
return

//-------------------------------------------------------------------
/*/{Protheus.doc} wrtContent
Escreve o conte�do no arquivo CSV.
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
@param   aDados, array, conte�do a ser escrito.(divido por colunas, cada posi��o
                        do array � uma posi��o na linha do arquivo CSV)
@return  nil, nil
/*/
//-------------------------------------------------------------------
method wrtContent(aDados) class SFLYBUILD
	local cConteudo as character
	local lOk     as logical


	cConteudo := alltrim(ArrTokStr(aDados, "|"))+ CRLF
	nRet := FWrite(self:handleArq,cConteudo)

	lOk := nRet > 0

return lOk


user function sflybuild()
return