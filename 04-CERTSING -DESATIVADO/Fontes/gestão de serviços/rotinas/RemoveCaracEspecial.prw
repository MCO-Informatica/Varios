#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"      

//-----------------------------------------------------------------------
/*/{Protheus.doc} RemoveCaracEspecial
Funcao responsavel por remover Caracter Especial.

@param		cTexto			Texto a ser verificado Caracter Especial.
@param		nModlulo		Numero que identifica o modulo na rotina (0 = Não especifica modulo, trata default).
@return		cTextoOk		Texto realizado o ajuste.

@author Douglas Parreja
@since 10/01/2017
@version 11.8
/*/
//-----------------------------------------------------------------------
user function removeCaracEspecial( cTexto, nModlulo ) 
	
	local nX		:= 0
	local cTextoOk	:= ""
	default cTexto := ""
	default nModulo := 0
	
	if !empty( cTexto )
		//----------------------------------------------------------------
		// Verifico se no Texto enviado consta algum caracter Especial
		//----------------------------------------------------------------
		if validCaracter( cTexto )
			//------------------------------------------------------------
			// Retorna lista de Caracteres Especiais
			//------------------------------------------------------------
			aRetCaracter := u_listCaracter(nModlulo)
			if len( aRetCaracter ) > 0 
				//--------------------------------------------------------
				// Primeira validacao retiro Acentuacoes e Cedilha. 
				//--------------------------------------------------------
				cTexto := FwNoAccent( cTexto )		
				//--------------------------------------------------------
				// Verifico cada Caracter e confronto com o Array. 
				// Caso encontrou o Caracter, acrescenta um caracter vazio
				// para que nao ocorra incidentes.
				//--------------------------------------------------------		
				while !empty( cTexto )
					cAux := subStr( cTexto,1,1 )
					if Ascan( aRetCaracter, {|x| x == cAux} ) > 0
						cTextoOk += ""
					else
						cTextoOk += cAux	
					endif
					cTexto := subStr( cTexto ,2)							
				endDo
			endif
		else
			cTextoOk := cTexto
		endif
	endif
	
return cTextoOk


//-----------------------------------------------------------------------
/*/{Protheus.doc} validCaracter
Funcao responsavel por validar se consta Caracter Especial.
Caso encontre, eu ja saio do While e retorno .T., ou seja, que tem 
caracter especial e com isso nao preciso verificar todo o texto enviado.

@param		cDados			Texto a ser verificado Caracter Especial.
@return		lErro			Retorna se tem Caracter Especial ou Nao.

@author Douglas Parreja
@since 10/01/2017
@version 11.8
/*/
//-----------------------------------------------------------------------
static function validCaracter( cDados )

	local lErro		:= .F.
	local cAux		:= ""
	default cDados	:= ""
	
	if !empty( cDados )			
		while !empty( cDados ) .and. !(lErro)
			cAux := subStr( cDados,1,1)
			if ( (Asc(cAux) < 65 .and. !empty(cAux)) .or. Asc(cAux) > 123 )				
				lErro := .T.		
			endIf
			cDados := subStr( cDados ,2)
		endDo  				
	endif
	
return lErro

//-----------------------------------------------------------------------
/*/{Protheus.doc} listCaracter
Funcao responsavel por carregar os Caracteres Especiais.

@return		aCaracter		Retorna os Caracteres Especiais.

@author Douglas Parreja
@since 10/01/2017
@version 11.8
/*/
//-----------------------------------------------------------------------
user function listCaracter(nModulo)

	local aCaracter := {}

	aAdd( aCaracter, "'" )
	aAdd( aCaracter, "#" )
	aAdd( aCaracter, "%" )
	aAdd( aCaracter, "*" )
	aAdd( aCaracter, "&" )
	aAdd( aCaracter, ">" )
	aAdd( aCaracter, "<" )
	aAdd( aCaracter, "!" )
	aAdd( aCaracter, "@" )
	aAdd( aCaracter, "$" )
	aAdd( aCaracter, "(" )
	aAdd( aCaracter, ")" )
	aAdd( aCaracter, "_" )
	aAdd( aCaracter, "=" )
	aAdd( aCaracter, "+" )
	aAdd( aCaracter, "{" )
	aAdd( aCaracter, "}" )
	aAdd( aCaracter, "[" )
	aAdd( aCaracter, "]" )
	aAdd( aCaracter, "/" )
	aAdd( aCaracter, "?" )
	aAdd( aCaracter, "." )
	aAdd( aCaracter, "\" )
	aAdd( aCaracter, "|" )
	aAdd( aCaracter, ":" )
	aAdd( aCaracter, ";" )
	aAdd( aCaracter, '"' )
	aAdd( aCaracter, '°' )
	aAdd( aCaracter, 'ª' )
	aAdd( aCaracter, '-' )
	aAdd( aCaracter, '¡' )
	aAdd( aCaracter, '¢' )
	aAdd( aCaracter, '£' )
	aAdd( aCaracter, '¤' )
	aAdd( aCaracter, '¥' )
	aAdd( aCaracter, '¦' )
	aAdd( aCaracter, '§' )
	aAdd( aCaracter, '¨' )
	aAdd( aCaracter, '©' )
	aAdd( aCaracter, 'ª' )
	aAdd( aCaracter, '«' )
	aAdd( aCaracter, '¬' )
	aAdd( aCaracter, '®' )
	aAdd( aCaracter, '¯' )
	aAdd( aCaracter, '°' )
	aAdd( aCaracter, '±' )
	aAdd( aCaracter, '²' )
	aAdd( aCaracter, '³' )
	aAdd( aCaracter, '´' )
	aAdd( aCaracter, 'µ' )
	aAdd( aCaracter, '¶' )
	aAdd( aCaracter, '·' )
	aAdd( aCaracter, '¸' )
	aAdd( aCaracter, '¹' )
	aAdd( aCaracter, 'º' )
	aAdd( aCaracter, '»' )
	aAdd( aCaracter, '¼' )
	aAdd( aCaracter, '½' )
	aAdd( aCaracter, '¾' )
	aAdd( aCaracter, '¿' )
	aAdd( aCaracter, '×' )
	aAdd( aCaracter, '÷' )
	aAdd( aCaracter, 'À' )
	aAdd( aCaracter, 'Á' )
	aAdd( aCaracter, 'Â' )
	aAdd( aCaracter, 'Ã' )
	aAdd( aCaracter, 'Ä' )
	aAdd( aCaracter, 'Å' )
	aAdd( aCaracter, 'Æ' )
	aAdd( aCaracter, 'Ç' )
	aAdd( aCaracter, 'È' )
	aAdd( aCaracter, 'É' )
	aAdd( aCaracter, 'Ê' )
	aAdd( aCaracter, 'Ë' )
	aAdd( aCaracter, 'Ì' )
	aAdd( aCaracter, 'Í' )
	aAdd( aCaracter, 'Î' )
	aAdd( aCaracter, 'Ï' )
	aAdd( aCaracter, 'Ð' )
	aAdd( aCaracter, 'Ñ' )
	aAdd( aCaracter, 'Ò' )
	aAdd( aCaracter, 'Ó' )
	aAdd( aCaracter, 'Ô' )
	aAdd( aCaracter, 'Õ' )
	aAdd( aCaracter, 'Ö' )
	aAdd( aCaracter, 'Ø' )
	aAdd( aCaracter, 'Ù' )
	aAdd( aCaracter, 'Ú' )
	aAdd( aCaracter, 'Û' )
	aAdd( aCaracter, 'Ü' )
	aAdd( aCaracter, 'Ý' )
	aAdd( aCaracter, 'Þ' )
	aAdd( aCaracter, 'ß' )
	aAdd( aCaracter, 'à' )
	aAdd( aCaracter, 'á' )
	aAdd( aCaracter, 'â' )
	aAdd( aCaracter, 'ã' )
	aAdd( aCaracter, 'ä' )
	aAdd( aCaracter, 'å' )
	aAdd( aCaracter, 'æ' )
	aAdd( aCaracter, 'ç' )
	aAdd( aCaracter, 'è' )
	aAdd( aCaracter, 'é' )
	aAdd( aCaracter, 'ê' )
	aAdd( aCaracter, 'ë' )
	aAdd( aCaracter, 'ì' )
	aAdd( aCaracter, 'í' )
	aAdd( aCaracter, 'î' )
	aAdd( aCaracter, 'ï' )
	aAdd( aCaracter, 'ð' )
	aAdd( aCaracter, 'ñ' )
	aAdd( aCaracter, 'ò' )
	aAdd( aCaracter, 'ó' )
	aAdd( aCaracter, 'ô' )
	aAdd( aCaracter, 'õ' )
	aAdd( aCaracter, 'ö' )
	aAdd( aCaracter, 'ø' )
	aAdd( aCaracter, 'ù' )
	aAdd( aCaracter, 'ú' )
	aAdd( aCaracter, 'û' )
	aAdd( aCaracter, 'ü' )
	aAdd( aCaracter, 'ý' )
	aAdd( aCaracter, 'þ' )
	aAdd( aCaracter, 'ÿ' )
	aAdd( aCaracter, '­' )
	aAdd( aCaracter, '—' )
	aAdd( aCaracter, '–' )
	aAdd( aCaracter, '	' )
	
	if nModulo == 7 //RH
		aAdd( aCaracter, ',' )
	endif
	
return aCaracter


//-----------------------------------------------------------------------
/*/{Protheus.doc} listHTMLCaracter
Funcao responsavel por carregar os Caracteres Especiais e ja realizado 
a transformacao para o HTML, ou seja, como se fosse um De-Para.

@return		aCaracter[1]	Retorna os Caracteres Especiais.
			aCaracter[2]	Retorna formato HTML para o Caracter.

@author Douglas Parreja
@since 10/01/2017
@version 11.8
/*/
//-----------------------------------------------------------------------
user function listHTMLCaracter()

	local aCaracter:= {}
	
	aAdd( aCaracter,{'-','&ndash;'	})
	aAdd( aCaracter,{'¡','&iexcl;'	})
	aAdd( aCaracter,{'¢','&cent;'	})
	aAdd( aCaracter,{'£','&pound;'	})
	aAdd( aCaracter,{'¤','&curren;'	})
	aAdd( aCaracter,{'¥','&yen;'	})
	aAdd( aCaracter,{'¦','&brvbar;'	})
	aAdd( aCaracter,{'§','&sect;'	})
	aAdd( aCaracter,{'¨','&uml;'	})
	aAdd( aCaracter,{'©','&copy;'	})
	aAdd( aCaracter,{'ª','&ordf;'	})
	aAdd( aCaracter,{'«','&laquo;'	})
	aAdd( aCaracter,{'¬','&not;'	})
	aAdd( aCaracter,{'®','&reg;'	})
	aAdd( aCaracter,{'¯','&macr;'	})
	aAdd( aCaracter,{'°','&deg;'	})
	aAdd( aCaracter,{'±','&plusmn;'	})
	aAdd( aCaracter,{'²','&sup2;'	})
	aAdd( aCaracter,{'³','&sup3;'	})
	aAdd( aCaracter,{'´','&acute;'	})
	aAdd( aCaracter,{'µ','&micro;'	})
	aAdd( aCaracter,{'¶','&para;'	})
	aAdd( aCaracter,{'·','&middot;'	})
	aAdd( aCaracter,{'¸','&cedil;'	})
	aAdd( aCaracter,{'¹','&sup1;'	})
	aAdd( aCaracter,{'º','&ordm;'	})
	aAdd( aCaracter,{'»','&raquo;'	})
	aAdd( aCaracter,{'¼','&frac14;'	})
	aAdd( aCaracter,{'½','&frac12;'	})
	aAdd( aCaracter,{'¾','&frac34;'	})
	aAdd( aCaracter,{'¿','&iquest;'	})
	aAdd( aCaracter,{'×','&times;'	})
	aAdd( aCaracter,{'÷','&divide;'	})
	aAdd( aCaracter,{'À','&Agrave;'	})
	aAdd( aCaracter,{'Á','&Aacute;'	})
	aAdd( aCaracter,{'Â','&Acirc;'	})
	aAdd( aCaracter,{'Ã','&Atilde;'	})
	aAdd( aCaracter,{'Ä','&Auml;'	})
	aAdd( aCaracter,{'Å','&Aring;'	})
	aAdd( aCaracter,{'Æ','&AElig;'	})
	aAdd( aCaracter,{'Ç','&Ccedil;'	})
	aAdd( aCaracter,{'È','&Egrave;'	})
	aAdd( aCaracter,{'É','&Eacute;'	})
	aAdd( aCaracter,{'Ê','&Ecirc;'	})
	aAdd( aCaracter,{'Ë','&Euml;'	})
	aAdd( aCaracter,{'Ì','&Igrave;'	})
	aAdd( aCaracter,{'Í','&Iacute;'	})
	aAdd( aCaracter,{'Î','&Icirc;'	})
	aAdd( aCaracter,{'Ï','&Iuml;'	})
	aAdd( aCaracter,{'Ð','&ETH;'	})
	aAdd( aCaracter,{'Ñ','&Ntilde;'	})
	aAdd( aCaracter,{'Ò','&Ograve;'	})
	aAdd( aCaracter,{'Ó','&Oacute;'	})
	aAdd( aCaracter,{'Ô','&Ocirc;'	})
	aAdd( aCaracter,{'Õ','&Otilde;'	})
	aAdd( aCaracter,{'Ö','&Ouml;'	})
	aAdd( aCaracter,{'Ø','&Oslash;'	})
	aAdd( aCaracter,{'Ù','&Ugrave;'	})
	aAdd( aCaracter,{'Ú','&Uacute;'	})
	aAdd( aCaracter,{'Û','&Ucirc;'	})
	aAdd( aCaracter,{'Ü','&Uuml;'	})
	aAdd( aCaracter,{'Ý','&Yacute;'	})
	aAdd( aCaracter,{'Þ','&THORN;'	})
	aAdd( aCaracter,{'ß','&szlig;'	})
	aAdd( aCaracter,{'à','&agrave;'	})
	aAdd( aCaracter,{'á','&aacute;'	})
	aAdd( aCaracter,{'â','&acirc;'	})
	aAdd( aCaracter,{'ã','&atilde;'	})
	aAdd( aCaracter,{'ä','&auml;'	})
	aAdd( aCaracter,{'å','&aring;'	})
	aAdd( aCaracter,{'æ','&aelig;'	})
	aAdd( aCaracter,{'ç','&ccedil;'	})
	aAdd( aCaracter,{'è','&egrave;'	})
	aAdd( aCaracter,{'é','&eacute;'	})
	aAdd( aCaracter,{'ê','&ecirc;'	})
	aAdd( aCaracter,{'ë','&euml;'	})
	aAdd( aCaracter,{'ì','&igrave;'	})
	aAdd( aCaracter,{'í','&iacute;'	})
	aAdd( aCaracter,{'î','&icirc;'	})
	aAdd( aCaracter,{'ï','&iuml;'	})
	aAdd( aCaracter,{'ð','&eth;'	})
	aAdd( aCaracter,{'ñ','&ntilde;'	})
	aAdd( aCaracter,{'ò','&ograve;'	})
	aAdd( aCaracter,{'ó','&oacute;'	})
	aAdd( aCaracter,{'ô','&ocirc;'	})
	aAdd( aCaracter,{'õ','&otilde;'	})
	aAdd( aCaracter,{'ö','&ouml;'	})
	aAdd( aCaracter,{'ø','&oslash;'	})
	aAdd( aCaracter,{'ù','&ugrave;'	})
	aAdd( aCaracter,{'ú','&uacute;'	})
	aAdd( aCaracter,{'û','&ucirc;'	})
	aAdd( aCaracter,{'ü','&uuml;'	})
	aAdd( aCaracter,{'ý','&yacute;'	})
	aAdd( aCaracter,{'þ','&thorn;'	})
	aAdd( aCaracter,{'ÿ','&yuml;'	})

return aCaracter

//-----------------------------------------------------------------------
/*/{Protheus.doc} ExisteCaracEspecial
Funcao responsavel por remover Caracter Especial.

@param		Texto			Texto a ser verificado Caracter Especial.
			Boolean			Se gera mensagem ou nao de saida.
@return		Array			2 Posicoes
							Array[1] - Se tem caractere Especial
							Array[2] - Texto sem caractere especial

@author Renato Ruy
@since 09/03/17
@version 11.8
/*/
//-----------------------------------------------------------------------
user function ExisteCaracEspecial( cTexto , lRetMsg)
Local lRet   := .T.
Local lAlpha := .T.
Local cDados := "" 

Default lRetMsg := .F.

//Verifico se e alphanumerico
For nI := 1 To Len(RTrim(cTexto))
	If !LETTERORNUM(substr(cTexto,nI,1))
		lAlpha := .F.
	EndIf
Next

//Remove os caracteres especiais alfanumericos
cDados := U_removeCaracEspecial(RTrim(cTexto)) 

//Retorna validacao do campo
lRet := Len(cDados) == Len(RTrim(cTexto)) .And. lAlpha

If !lRet .And. lRetMsg
	MsgInfo("O campo contém caractere especial, por favor corrija!")
Endif

Return {lRet, cDados}
