#include 'protheus.ch'
#INCLUDE 'FWMVCDEF.CH'

//-------------------------------------------------------------------
/*/{Protheus.doc} SFINRACT
Action de importação dos dados a partir dos arquivos recebidos e 
gerados a partir do Sales Force.
@author  marcio.katsumata
@since   26/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
class SFINRACT

	method new() constructor
	method import()
	method selFiles()
	method readFile()
	method destroy()

	data aImporting as array
	data oSfUtil    as object
endClass

//-------------------------------------------------------------------
/*/{Protheus.doc} new
Método construtor
@author  marcio.katsumata
@since   26/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method new() class SFINRACT
	self:oSfUtil := SFUTILS():new()
return

//-------------------------------------------------------------------
/*/{Protheus.doc} import
Realiza a importação dos dados a partir dos arquivos recebidos do
Sales Force. 
@author  marcio.katsumata
@since   26/07/2019
@version 1.0
@param   lOk , boolean, status do processamento
@param   cMsgErro, character, mensagem de erro
/*/
//-------------------------------------------------------------------
method import(lOk, cMsgErro) class SFINRACT
	local cEmpSF   as character
	local xLido
	local oSfInLy  as object
	local nInd     as numeric
	local oModelIn as object
	local oModelLy as object
	local oXml     as object
	local cError   as character
	local cWarning as character
	local lRet     as logical
	local nInd2    as numeric
	//---------------------------------------------------
	//Inicialização de variáveis
	//---------------------------------------------------
	oSfInLy  := SFINLYBLD():new()
	cEmpSF   := "69"+PADR(cValToChar(val(cEmpAnt)),3,"0") // Código da empresa SF.
	cMsgErro := ""
	cError   := ""
	cWarning := ""

	//-------------------------------------------
	//Realiza a checagem de arquivos importados
	//e carrega eles no array aImporting
	//-------------------------------------------
	if self:selFiles(cEmpSF)

		for nInd := 1 to 2

			for nInd2 := 1 to len(self:aImporting[nInd])

				xLido := self:readFile(self:aImporting[nInd][nInd2][2], nInd==2)

				if valtype(xLido) == 'C'

					oXml := XmlParserFile( self:aImporting[nInd][nInd2][2] , "_", @cError, @cWarning )

					oSfInLy:build(self:aImporting[nInd][nInd2][1],,,xLido,oXml)

					ZNR->(dbSetOrder(1))
					lOkZNR := ZNR->(dbSeek(xFilial("ZNR")+PADR( lower(self:aImporting[nInd][nInd2][1]) ,tamSx3("ZNR_FILE")[1])))

					if lOkZNR
						oModelIn :=  FWLoadModel("SFINRMOD")
						oModelIn:setOperation( MODEL_OPERATION_UPDATE)
						oModelIn:activate()
					endif

					if empty(cError) .and. lOkZNR

						oModelLy := FwLoadModel("SFINLYMOD")
						oModelLy:setOperation(MODEL_OPERATION_VIEW)
						oModelLy:activate()

						cRotina := oModelLy:getValue("ZNQMASTER", "ZNQ_EXEAUT")
						aRet := &cRotina.(oXml,oModelLy,oModelIn)

						lRet := aRet[1]
						cError := aRet[2]
						freeObj(oModelLy)
					else
						lRet := .F.
					endif

					oModelIn:setValue("ZNRMASTER","ZNR_STATUS", iif(lRet, "3", "4"))
					oModelIn:setValue("ZNRMASTER", "ZNR_ERROR", cError)

					if oModelIn:VldData()
						oModelIn:CommitData()
					endif

					freeObj(oModelIn)
				else

					if len(xLido) >= 2
						oSfInLy:build(self:aImporting[nInd][nInd2][1],xLido[1], xLido[2])
					endif

					aSize(xLido,0)
				endif

				//----------------------------------------------------------
				//Realiza a transferência do arquivo de pending para readed
				//----------------------------------------------------------
				cArqIn :=self:aImporting[nInd][nInd2][2]
				cArqOut := self:aImporting[nInd][nInd2][3]
				
				IF lRet
					cArqOut := STRTRAN(cArqOut,"\readed\Quote\","\readed\Quote\success\")
					__copyFile(cArqIn,cArqOut)
				else
					cArqOut := STRTRAN(cArqOut,"\readed\Quote\","\readed\Quote\ERROR\")
					_copyFile(cArqIn,cArqOut)
				Endif
				FErase(cArqIn)

			next nInd2

		next nInd
	endif
	//Limpeza do objeto
	freeObj(oSfInLy)
return

//-------------------------------------------------------------------
/*/{Protheus.doc} readFile
Realiza a leitura do arquivo
@author  marcio.katsumata
@since   22/07/2019
@version 1.0
@param   cFile, character, arquivo
@return  array, conteudo lido.
/*/
//-------------------------------------------------------------------
method readFile(cFile, lXml)  class SFINRACT
	local cLineRead as character
	local aAux      as array
	Local oTxtFile  as object
	local xLido
	local nInd      as numeric

	if lXml
		xLido := ""
	else
		xLido := {}
	endif

	if lXml
		xLido := memoread(cFile)
	else
		oTxtFile := SFFILEREADER():New(cFile)
		If !oTxtFile:Open()
			Return
		Endif

		oTxtFile:ReadLine(@cLineRead)

		if !empty(cLineRead)

			aAux := StrTokArr2(cLineRead,"|", .T.)

			for nInd := 1 to len(aAux)
                aAux[nInd] := FwCutOff(aAux[nInd])
            next nInd

			aadd(xLido, aClone(aAux))
			aSize(aAux,0)

			aadd(xLido, {})

			While oTxtFile:ReadLine(@cLineRead)
				aAux := StrTokArr2(cLineRead,"|", .T.)
				aadd(xLido[2], aClone(aAux))

			Enddo
		endif
		oTxtFile:Close()
		freeObj(oTxtFile)
	endif


return xLido



//-------------------------------------------------------------------
/*/{Protheus.doc} selFiles
Seleciona os arquivos do diretório success e error de cada entidade
@author  marcio.katsumata
@since   22/07/2019
@version 1.0
@return  boolean, existe arquivo para leitura? .T. = Sim, .F. = Não
/*/
//-------------------------------------------------------------------
method selFiles(cEmpSF)  class SFINRACT

	local aDirPend as array      //Lista de diretórios da pasta pending
	local aDirAux  as array      //Lista de arquivos
	local cPath    as character  //Caminho da pasta pending
	local cRootPath as character //RootPath do Protheus
	local nInd      as numeric   //Indice
	local nInd2     as numeric   //Indice
	local lOk       as logical   //Retorno de sucesso
	local cImpAuto  as character //Pastas que contem arquivos para a importação automatica.
	//--------------------------------------------
	//Inicialização de variáveis
	//--------------------------------------------
	cRootPath := GetSrvProfString ("ROOTPATH","")
	aDirPend := {}
	aDirAux  := {}
	self:aImporting := array(2)
	self:aImporting[1] := {}
	self:aImporting[2] := {}
	lOk      := .F.
	cDestiny := self:oSfUtil:getSfInRead()
	cPath    := self:oSfUtil:getSfInPend()
	cImpAuto := superGetMv("ES_XSFIMAT",.F.,"QUOTE/")
	aStatus  := {"Success", "Error"}
	//Verifica o diretório em busca de arquivos
	aDirPend := Directory(cPath+"\*.*")

	for nInd := 1 to len(aDirPend)

		if aDirPend[nInd][1] <> '.' .and. aDirPend[nInd][1] <> '..'

			//-------------------------------
			//Realiza a inserção da entidade
			//no array de arquivos
			//-------------------------------
			//Estrtura do array
			//  -Nome do arquivo
			//  -Caminho origem (onde o arquivo se encontra)
			//  -Caminho destino (onde o arquivo deve ser movido após o processamento)
			//--------------------------------------------------------------------------------
			if cEmpSF $ aDirPend[nInd][1]
				aadd(self:aImporting[1], {aDirPend[nInd][1], cPath+"\"+aDirPend[nInd][1], cDestiny+"\"+aDirPend[nInd][1]})
				lOk := .T.
			endif

		endif
	next nInd
	aSize(aDirPend,0)


	cPath    := self:oSfUtil:getImpPend()

	aDirPend := Directory(cPath+"\*.*", "D")

	for nInd := 1 to len(aDirPend)

		if aDirPend[nInd][1] <> '.' .and. aDirPend[nInd][1] <> '..'

			if aDirPend [nInd][1] $ cImpAuto
				aDirAux := Directory(cPath+"\"+aDirPend[nInd][1]+"\*.xml", "F")

				for nInd2 := 1 to len(aDirAux)
					if aDirAux[nInd2][1] <> '.' .and. aDirAux[nInd2][1] <> '..'
						//-------------------------------
						//Realiza a inserção da entidade
						//no array de arquivos
						//-------------------------------
						//Estrtura do array
						//  -Nome do arquivo
						//  -Caminho origem (onde o arquivo se encontra)
						//  -Caminho destino (onde o arquivo deve ser movido após o processamento)
						//--------------------------------------------------------------------------------
						if cEmpSF $ aDirAux[nInd2][1]
							cDestiny := self:oSfUtil:impReadPrc (lower(alltrim(aDirPend[nInd][1])))
							aadd(self:aImporting[2], {aDirAux[nInd2][1], cPath+"\"+aDirPend [nInd][1]+"\"+aDirAux[nInd2][1], cDestiny+"\"+aDirAux[nInd2][1]})
							lOk := .T.
						endif
					endif
				next nInd2
			endif
		endif
	next nInd

	aSize(aDirPend,0)
	aSize(aDirAux,0)

return lOk

method destroy() class SFINRACT
	freeObj(self:oSfUtil)
return

user function sfinract()
return
