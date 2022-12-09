#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH" 

//---------------------------------------------------------------
/*/{Protheus.doc} csReprocTotIP
Funcao responsavel por exibir ao usuario de Sistemas Corporativos
para realizar o Reprocessamento da rotina.
Devido alguns problemas na geracao das listas pela ADM Dados, 
foi preciso criar a rotina para que seja reprocessado.
	  					

@author	Douglas Parreja
@since	11/07/2016
@version 11.8
/*/
//---------------------------------------------------------------
user function csReprocTotIP()

	local aParamBox				:= {}
	local aReproc				:= {} 
	local cDataDe, cDataAte	:= ""
	local aCombo 				:= {"1-Reprocessamento"}
	local aCombo2				:= {"1-Geral","2-Importação Arquivos","3-Insert/Export Dados"}
	local lReproc				:= .T.
	local xTipo					
	
	private cCadastro 			:= "TOTAL IP"
	private aRetParam			:= {}
	
	// --------------------------------------------------------------
	// Abaixo está a montagem do vetor que será passado para a função
	// --------------------------------------------------------------	
	aAdd(aParamBox,{2,"Origem",1,aCombo,80,"",.F.}) 						// Origem	
	aAdd(aParamBox,{2,"Tipo de Reprocessamento",1,aCombo2,80,"",.F.}) // Reprocessamento
	aAdd(aParamBox,{1,"Data De"  ,Ctod(Space(8)),"","","","",50,.F.}) 	// Data De
	aAdd(aParamBox,{1,"Data Ate"  ,Ctod(Space(8)),"","","","",50,.F.}) 	// Data Ate
	
	if ParamBox(aParamBox,"Reprocessamento",@aRetParam)
		if csValid( aRetParam ) 	
			xTipo 		:= Iif( valtype(aRetParam[2]) == "C", SubStr(aRetParam[2],1,1), alltrim(Str(aRetParam[2])) )			
			cDataDe 	:= dtos( aRetParam[3] )
			cDataAte	:= dtos( aRetParam[4] )
   
   			aAdd( aReproc, {lReproc, xTipo, cDataDe, cDataAte} )
   
   			if len( aReproc ) > 0
				msgInfo("Conforme é de conhecimento, o Processamento do TOTALIP é através de JOB, neste caso, está sendo startado. Para consultar, será através do Console.log ou Tabela SZX.", "Integracao TOTALIP x Protheus")
				u_csTotIp( nil, aReproc )
			endif 
		else
			u_csReprocTotIP()
		endif
	endif

return

//---------------------------------------------------------------
/*/{Protheus.doc} csValid
Funcao responsavel por validar Dados enviados, se esta preenchido
as Datas para que possamos realizar a Query.

@param	aDados		Dados retornados conforme preenchimento da Rotina
					[1] Origem 
					[2] Tipo de Reprocessamento
					[3] Data De
					[4] Data Ate

@return	lRet		Retorna se estah valido para continuar a operacao.			  					

@author	Douglas Parreja
@since	11/07/2016
@version 11.8
/*/
//---------------------------------------------------------------
static function csValid( aDados )
	
	local lRet 	:= .T.
	local xTipo
	default aDados := {}
	
	xTipo := Iif( valtype(aDados[2]) == "C", SubStr(aDados[2],1,1), alltrim(Str(aDados[2])) )
	
	if len( aDados ) > 0
		if len( aDados ) > 1
			if empty( aDados[3] ) .and. xTipo $ '1|3'
				msgAlert("Favor preencher o campo 'Data De' para realizarmos o Reprocessamento. " )
				lRet := .F.
			endif
		else
			lRet := .F.
		endif
		if len( aDados ) > 2
			if empty( aDados[4] ) .and. xTipo $ '1|3'
				msgAlert("Favor preencher o campo 'Data Ate' para realizarmos o Reprocessamento. " )
				lRet := .F.
			endif
		else
			lRet := .F.
		endif
	endif

return lRet