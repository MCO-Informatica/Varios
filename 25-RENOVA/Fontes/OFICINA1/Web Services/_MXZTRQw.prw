#include "protheus.ch"

User Function _MXZTRQw ; Return  // "dummy" function - Internal Use

//-------------------------------------------------------------------
/*/{Protheus.doc} TSSManifestacaoDestinatarioParametros
Classe responsável pelos parâmetros para a Manifestação do Destinatário.

@author		Marcos Taranta
@since		08/05/2012
@version	11.6
/*/
//-------------------------------------------------------------------
class TSSManifestacaoDestinatarioParametros from LongClassName
	
	data	cAmbiente
	data	cClassName
	data	cIDEnt
	data	cUltimoNSU
	data	cVersao
	
	method	new()
	method	className()
	
	method	gravar()
	
endclass

//-------------------------------------------------------------------
/*/{Protheus.doc} new
Método de instanciação da classe TSSManifestacaoDestinatarioParametros.

@param		cIDEnt	ID da entidade a ser manipulada.

@return		nil

@author		Marcos Taranta
@since		08/05/2012
@version	11.6
/*/
//-------------------------------------------------------------------
method new( cIDEnt ) class TSSManifestacaoDestinatarioParametros
	
	::cClassName	:= "TSSMANIFESTACAODESTINATARIOPARAMETROS"
	
	::cIDEnt		:= cIDEnt
	
	::cAmbiente		:= spedGetMV( "MV_MDAMB", ::cIDEnt, "2" )
	::cUltimoNSU	:= spedGetMV( "MV_MDNSU", ::cIDEnt, "0" )
	::cVersao		:= spedGetMV( "MV_MDVER", ::cIDEnt, "1.01" )
	
return nil

//-------------------------------------------------------------------
/*/{Protheus.doc} className
Método que retorna o nome da classe TSSManifestacaoDestinatarioParametros.

@return		cClassName	Nome da classe em caixa alta.

@author		Marcos Taranta
@since		08/05/2012
@version	11.6
/*/
//-------------------------------------------------------------------
method className() class TSSManifestacaoDestinatarioParametros
return ::cClassName

//-------------------------------------------------------------------
/*/{Protheus.doc} gravar
Grava os parâmetros na base de dados.

@return		lRetorno	

@author		Marcos Taranta
@since		08/05/2012
@version	11.6
/*/
//-------------------------------------------------------------------
method gravar() class TSSManifestacaoDestinatarioParametros
	
	local	nOrder1	:= 0
	local	nRecno1	:= 0
	
	if empty( ::cIDEnt )
		return .F.
	endif
	
	nOrder1	:= SPED001->( indexOrd() )
	nRecno1	:= SPED001->( recno() )
	SPED001->( dbSetOrder( 1 ) )
	
	if !SPED001->( dbSeek( ::cIDEnt ) )
		return .F.
	endif
	
	SPED001->( dbSetOrder( nOrder1 ) )
	SPED001->( dbGoTo( nRecno1 ) )
	
	if !empty( ::cAmbiente )
		spedPutMV( "MV_MDAMB", ::cIDEnt, ::cAmbiente )
	endif
	
	if !empty( ::cUltimoNSU )
		spedPutMV( "MV_MDNSU", ::cIDEnt, ::cUltimoNSU )
	endif
	
	if !empty( ::cVersao )
		spedPutMV( "MV_MDVER", ::cIDEnt, ::cVersao )
	endif
	
return .T.