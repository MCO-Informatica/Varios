#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"      

//-----------------------------------------------------------------------
/*/{Protheus.doc} RemoveCaracEspecial
Funcao responsavel por remover Caracter Especial.

@param		cTexto			Texto a ser verificado Caracter Especial.
@param		nModlulo		Numero que identifica o modulo na rotina (0 = N�o especifica modulo, trata default).
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
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '-' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
	aAdd( aCaracter, '�' )
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
	aAdd( aCaracter,{'�','&iexcl;'	})
	aAdd( aCaracter,{'�','&cent;'	})
	aAdd( aCaracter,{'�','&pound;'	})
	aAdd( aCaracter,{'�','&curren;'	})
	aAdd( aCaracter,{'�','&yen;'	})
	aAdd( aCaracter,{'�','&brvbar;'	})
	aAdd( aCaracter,{'�','&sect;'	})
	aAdd( aCaracter,{'�','&uml;'	})
	aAdd( aCaracter,{'�','&copy;'	})
	aAdd( aCaracter,{'�','&ordf;'	})
	aAdd( aCaracter,{'�','&laquo;'	})
	aAdd( aCaracter,{'�','&not;'	})
	aAdd( aCaracter,{'�','&reg;'	})
	aAdd( aCaracter,{'�','&macr;'	})
	aAdd( aCaracter,{'�','&deg;'	})
	aAdd( aCaracter,{'�','&plusmn;'	})
	aAdd( aCaracter,{'�','&sup2;'	})
	aAdd( aCaracter,{'�','&sup3;'	})
	aAdd( aCaracter,{'�','&acute;'	})
	aAdd( aCaracter,{'�','&micro;'	})
	aAdd( aCaracter,{'�','&para;'	})
	aAdd( aCaracter,{'�','&middot;'	})
	aAdd( aCaracter,{'�','&cedil;'	})
	aAdd( aCaracter,{'�','&sup1;'	})
	aAdd( aCaracter,{'�','&ordm;'	})
	aAdd( aCaracter,{'�','&raquo;'	})
	aAdd( aCaracter,{'�','&frac14;'	})
	aAdd( aCaracter,{'�','&frac12;'	})
	aAdd( aCaracter,{'�','&frac34;'	})
	aAdd( aCaracter,{'�','&iquest;'	})
	aAdd( aCaracter,{'�','&times;'	})
	aAdd( aCaracter,{'�','&divide;'	})
	aAdd( aCaracter,{'�','&Agrave;'	})
	aAdd( aCaracter,{'�','&Aacute;'	})
	aAdd( aCaracter,{'�','&Acirc;'	})
	aAdd( aCaracter,{'�','&Atilde;'	})
	aAdd( aCaracter,{'�','&Auml;'	})
	aAdd( aCaracter,{'�','&Aring;'	})
	aAdd( aCaracter,{'�','&AElig;'	})
	aAdd( aCaracter,{'�','&Ccedil;'	})
	aAdd( aCaracter,{'�','&Egrave;'	})
	aAdd( aCaracter,{'�','&Eacute;'	})
	aAdd( aCaracter,{'�','&Ecirc;'	})
	aAdd( aCaracter,{'�','&Euml;'	})
	aAdd( aCaracter,{'�','&Igrave;'	})
	aAdd( aCaracter,{'�','&Iacute;'	})
	aAdd( aCaracter,{'�','&Icirc;'	})
	aAdd( aCaracter,{'�','&Iuml;'	})
	aAdd( aCaracter,{'�','&ETH;'	})
	aAdd( aCaracter,{'�','&Ntilde;'	})
	aAdd( aCaracter,{'�','&Ograve;'	})
	aAdd( aCaracter,{'�','&Oacute;'	})
	aAdd( aCaracter,{'�','&Ocirc;'	})
	aAdd( aCaracter,{'�','&Otilde;'	})
	aAdd( aCaracter,{'�','&Ouml;'	})
	aAdd( aCaracter,{'�','&Oslash;'	})
	aAdd( aCaracter,{'�','&Ugrave;'	})
	aAdd( aCaracter,{'�','&Uacute;'	})
	aAdd( aCaracter,{'�','&Ucirc;'	})
	aAdd( aCaracter,{'�','&Uuml;'	})
	aAdd( aCaracter,{'�','&Yacute;'	})
	aAdd( aCaracter,{'�','&THORN;'	})
	aAdd( aCaracter,{'�','&szlig;'	})
	aAdd( aCaracter,{'�','&agrave;'	})
	aAdd( aCaracter,{'�','&aacute;'	})
	aAdd( aCaracter,{'�','&acirc;'	})
	aAdd( aCaracter,{'�','&atilde;'	})
	aAdd( aCaracter,{'�','&auml;'	})
	aAdd( aCaracter,{'�','&aring;'	})
	aAdd( aCaracter,{'�','&aelig;'	})
	aAdd( aCaracter,{'�','&ccedil;'	})
	aAdd( aCaracter,{'�','&egrave;'	})
	aAdd( aCaracter,{'�','&eacute;'	})
	aAdd( aCaracter,{'�','&ecirc;'	})
	aAdd( aCaracter,{'�','&euml;'	})
	aAdd( aCaracter,{'�','&igrave;'	})
	aAdd( aCaracter,{'�','&iacute;'	})
	aAdd( aCaracter,{'�','&icirc;'	})
	aAdd( aCaracter,{'�','&iuml;'	})
	aAdd( aCaracter,{'�','&eth;'	})
	aAdd( aCaracter,{'�','&ntilde;'	})
	aAdd( aCaracter,{'�','&ograve;'	})
	aAdd( aCaracter,{'�','&oacute;'	})
	aAdd( aCaracter,{'�','&ocirc;'	})
	aAdd( aCaracter,{'�','&otilde;'	})
	aAdd( aCaracter,{'�','&ouml;'	})
	aAdd( aCaracter,{'�','&oslash;'	})
	aAdd( aCaracter,{'�','&ugrave;'	})
	aAdd( aCaracter,{'�','&uacute;'	})
	aAdd( aCaracter,{'�','&ucirc;'	})
	aAdd( aCaracter,{'�','&uuml;'	})
	aAdd( aCaracter,{'�','&yacute;'	})
	aAdd( aCaracter,{'�','&thorn;'	})
	aAdd( aCaracter,{'�','&yuml;'	})

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
	MsgInfo("O campo cont�m caractere especial, por favor corrija!")
Endif

Return {lRet, cDados}
