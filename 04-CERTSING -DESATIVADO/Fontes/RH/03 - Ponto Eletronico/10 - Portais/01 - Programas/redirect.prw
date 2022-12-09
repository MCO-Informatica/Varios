#include 'Protheus.ch'

/*/{Protheus.doc} CSRH010
Efetua acesso ao portal do ponto após clicar no menu do GCH
@Return Null
@author Bruno Nunes
@since 12/07/2016
@version 1.0
/*/
user function redirect()

	local cHTML := ''

	cHTML += ' <html xmlns="http://www.w3.org/1999/xhtml">'
	cHTML += ' <head>'
	cHTML += ' <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
	cHTML += ' <meta http-equiv="Cache-control" content="No-Store">'
	cHTML += ' <meta http-equiv="Expires" content="-1">'
	cHTML += ' <script src="ponto_eletronico/scripts/externo/jquery-1.12.3.min.js" language="JavaScript" type="text/javascript" charset="iso-8859-1"></script>'
	cHTML += ' <script src="ponto_eletronico/scripts/ponto_eletronico-2.02.js" language="JavaScript" type="text/javascript" charset="iso-8859-1"></script>	'
	cHTML += ' </head>'
	cHTML += ' <body onbeforeunload="return deleteCookie('+"'SESSIONID'"+')">'
	cHTML += ' </body>'
	cHTML += ' </html>'
	cHTML += ' <script language="javascript">'
	cHTML += ' function deleteCookie(name){'
	cHTML += ' 	document.cookie = cIDS ;'
	cHTML += ' }'
	cHTML += ' 	$.ajax({'
	cHTML += ' 		url: "U_Ajax021.APW",'
	cHTML += ' 		async: false,'
	cHTML += ' 		success: function(result)'
	cHTML += ' 		{'
	cHTML += ' 			if (!isEmpty(result))'
	cHTML += ' 			{'
	cHTML += ' 				var colaborador = $.parseJSON(result);'
	cHTML += ' 				var portal  = colaborador.portal[0].portal;'
	cHTML += ' 				if (portal == "1"){'
	cHTML += ' 					var cookies = document.cookie.split(";");'
	cHTML += ' 					for (var i = 0; i < cookies.length; i++) {'
	cHTML += ' 						var cookie = cookies[i];'
	cHTML += ' 						var eqPos = cookie.indexOf("=");'
	cHTML += ' 						var name = eqPos > -1 ? cookie.substr(0, eqPos) : cookie;'
	cHTML += ' 						if (name.trim() == '+"'SESSIONID'"+')'
	cHTML += ' 						{'
	cHTML += ' 							cIDS = cookie;'
	cHTML += ' 						}'
	cHTML += ' 					}'
	cHTML += ' 					window.top.location="ponto_eletronico/lista_periodo.htm";'
	cHTML += ' 				}else{'
	cHTML += ' 					top.frames["principal"].location.href="U_PWCERTI160.APW";'
	cHTML += ' 				}'
	cHTML += ' 			}'
	cHTML += ' 			else'
	cHTML += ' 			{'
	cHTML += ' 				window.top.location="default.htm";'
	cHTML += ' 			}'
	cHTML += ' 		},'
	cHTML += ' 		error: function(){'
	cHTML += ' 			window.top.location="default.htm";'
	cHTML += ' 		} '
	cHTML += ' 	}); '
	cHTML += ' </script> '
return(cHTML)