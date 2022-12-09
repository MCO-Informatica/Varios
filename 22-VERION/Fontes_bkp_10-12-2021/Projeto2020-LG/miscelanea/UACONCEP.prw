#include "Protheus.ch"   
 
/*/{Protheus.doc} UACONCEP
Consulta CEP
 
@author		Eurai Rapelli
@since 		24/03/2015
 
@Example	Cliente 	-> U_UACONCEP( M->A1_CEP,"M->A1_EST","M->A1_MUN","M->A1_BAIRRO","M->A1_END","M->A1_COD_MUN")
@Example	Fornecedor 	-> U_UACONCEP( M->A2_CEP,"M->A2_EST","M->A2_MUN","M->A2_BAIRRO","M->A2_END","M->A2_COD_MUN")
@Example	Vendedor 	-> U_UACONCEP( M->A3_CEP,"M->A3_EST","M->A3_MUN","M->A3_BAIRRO","M->A3_END")
 
@See		http://www.universoadvpl.com/
 
@OBS		Usar por gatilho. Dominio e contra Dominio Iguais
@OBS		Conteúdo pode ser utilizado desde que respeite as referencias do autor.
/*/

User Function UACONCEx( cCEP, oUF, oCidade, oBairro, oEnd, oCodMun )

Local oXML		:= Nil
 
Local cError	:= ''
Local cWarning	:= ''
Local cURL		:= ''
Local cXML		:= ''
 
Local cUF		:= ''
Local cCidade	:= ''
Local cBairro	:= ''
Local cEnd		:= ''
Local cTipoEnd	:= ''
 
Local aAreaCC2	:= CC2->( GetArea() )
 
Default oUF		:= ''
Default oCidade	:= ''
Default oBairro	:= ''
Default oEnd	:= ''
Default oCodMun := ''
 
 
 
cURL	:= "http://cep.republicavirtual.com.br/web_cep.php?cep=" + StrTran( cCEP, "-", "") + "&formato=xml"
MsgRun( "Aguarde..." , "Consultando CEP" , { || cXML := HTTPGET( cURL ) } )
 
oXML		:= XmlParser( cXML , "_" , @cError , @cWarning )
 
If oXml:_WebServiceCep:_Resultado:Text == '1'
 
	cUF				:= oXml:_WebServiceCep:_UF:Text
	cCidade			:= oXml:_WebServiceCep:_Cidade:Text
	cBairro			:= oXml:_WebServiceCep:_Bairro:Text
	cEnd			:= oXml:_WebServiceCep:_Logradouro:Text
	cTipoEnd		:= oXml:_WebServiceCep:_Tipo_Logradouro:Text
 
	If oUF <> ''
		&(oUF)			:= Upper(cUF)
	Endif

	If oCidade <> ''
		&(oCidade)		:= Padr(Alltrim(Transform(cCidade,"@!")),TamSX3("A1_MUN")[01])  //Upper(cCidade)
	Endif

	If oBairro <> ''
		&(oBairro)		:= Padr(Upper(Alltrim(cBairro)),TamSX3("A1_BAIRRO")[01])
	Endif

	If oEnd <> ''
		&(oEnd) 		:= padr(Alltrim(Upper(Alltrim(cTipoEnd)) + ' ' + Upper(Alltrim(cEnd))),TamSX3("A1_END")[01]) 
	Endif
 
	CC2->( dbSetOrder(4) )
	If CC2->( dbSeek( xFilial("CC2") + cUF + Upper( Padr( Alltrim(cCidade), TamSX3("CC2_MUN")[01] ) ) ) )   
		If oCodMun <> ''
			&(oCodMun)   		:= CC2->CC2_CODMUN
		Endif
	Endif	
 
Else

	If oUF <> ''
		&(oUF)			:= space(02)
	Endif

	If oCidade <> ''
		&(oCidade)		:= space(TamSX3("A1_MUN")[01])
	Endif

	If oBairro <> ''
		&(oBairro)		:= space(TamSX3("A1_BAIRRO")[01]) 
	Endif

	If oEnd <> ''
		&(oEnd)   		:= space(TamSX3("A1_END")[01])
	Endif

	If oCodMun <> ''
 		&(oCodMun)   	:= space(TamSX3("A1_COD_MUN")[01])
	Endif
 
	MsgAlert( 'CEP não encontrado: ' + cCEP, 'Universo ADVPL' )
 
Endif
RestArea( aAreaCC2 )
Return( &( Alltrim( ReadVar() ) ) )