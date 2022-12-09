#include 'protheus.ch'



//-------------------------------------------------------------------
/*/{Protheus.doc} SFGENMOD
Classe model da extração de dados para o Sales Force.
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
class SFGENMOD

    method new() constructor
    method getStruct()
    method getDataSet()
    method setDataSet()
    method destroy()


    data cModelName as string  //Nome do model
    data aColumns   as array   //Estrutura de colunas da view
    data aData      as array   //Registros extraidos pela view
    data cAliasMod  as string  //Alias temporário da view
    data cX2Unico   as string  //X2 Unico da tabela
    data cFilMsExp  as string
    data aColumnAux  as array
    data cAliasHead  as string
endclass

//-------------------------------------------------------------------
/*/{Protheus.doc} new
Método construtor
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
@param   cModelName, character, nome do model
@param   cAliasMod , character, alias temporário da view
@return  object, self
/*/
//-------------------------------------------------------------------
method new(cModelName,cAliasHead,cX2Unico, cFilMsExp,aHeader,cAliasMod) class SFGENMOD
    local aAuxCols as array //Array auxiliar da estrutura da view
    default cAliasMod := cAliasHead
    //-----------------------------
    //Inicialização de atributos
    //-----------------------------
    self:aColumns   := {}
    self:aColumnAux := {}
    self:aData      := {}
    self:cModelName := cModelName
    self:cAliasHead := cAliasHead
    self:cAliasMod  := cAliasMod
    self:cX2Unico   := cX2Unico
    self:cFilMsExp  := cFilMsExp
    //-----------------------------------------------------
    //Verifica e armazena a estrutura de colunas da view
    //-----------------------------------------------------
    aAuxCols := (cAliasHead)->(dbStruct())
    aEval(aAuxCols, {|aColumn| iif( !(aColumn[1] $ self:cX2Unico+"+"+self:cFilMsExp+"+"+"RECNUMBER"),  aadd(self:aColumns, alltrim((cAliasHead)->&(alltrim(aColumn[1])))),"")})
    aEval(aAuxCols, {|aColumn| iif( !(aColumn[1] $ self:cX2Unico+"+"+self:cFilMsExp+"+"+"RECNUMBER"),  aadd(self:aColumnAux, alltrim(aColumn[1])),"")})    
    
    aadd(aHeader, aClone(self:aColumnAux))  
    aadd(aHeader, aClone(self:aColumns))   
    //---------------------------------------
    //Realiza a limpeza do array auxiliar
    //---------------------------------------
    aSize(aAuxCols,0)
return

//-------------------------------------------------------------------
/*/{Protheus.doc} getStruct
Método responsável por retornar a estrutura de colunas
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method getStruct() class SFGENMOD

return self:aColumns

//-------------------------------------------------------------------
/*/{Protheus.doc} getDataSet
Método responsável por retornar os dados dos registros.
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
@return  array, dados.
/*/
//-------------------------------------------------------------------
method getDataSet() class SFGENMOD

return self:aData

//-------------------------------------------------------------------
/*/{Protheus.doc} setDataSet
Método responsável por gravar os dados 
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
@return  nil, nil
/*/
//-------------------------------------------------------------------
method setDataSet(lAcumula, cNewCode) class SFGENMOD
    Local nInd := 0
    local nPosCod := 0

    private oSfUtils   as object //objeto utils
    private aDataAux as array  //array auxiliar para popular o model
    private cX2Unico as character

    default cNewCode := ""

    cX2Unico := self:cX2Unico  
    aDataAux := {}
    
    //Instância do objeto utils
    oSfUtils := SFUTILS():new() 
    if !lAcumula
        //Populando o array auxiliar.
        aEval(self:aColumnAux, {|cColumn|iif(!(cColumn $cX2Unico+"+"+self:cFilMsExp+"+"+"RECNUMBER" ), aadd(aDataAux, oSfUtils:normaliza((self:cAliasMod)->&(cColumn))),"")}) 
        
        if !empty(cNewCode)
            if "SD2" $ self:cModelName 
                nPosCod := aScan(self:aColumns, {|cColumn| alltrim(upper(cColumn)) == "ORDERLINEADDRESSKEY"})
            endif
            if nPosCod > 0 
                aDataAux[nPosCod] := cNewCode
            endif
        endif

        //Realiza a adição do registro no array geral de registros
        aadd(self:aData, aClone(aDataAux)) 

    else
        nUltReg := len(self:aData)
        for nInd := 1 to len(self:aColumnAux)
            cColumn := self:aColumnAux[nInd]
            if valType((self:cAliasMod)->&(cColumn)) == 'N'
                nResult := val(self:aData[nUltReg][nInd]) + (self:cAliasMod)->&(cColumn)
                self:aData[nUltReg][nInd] := oSfUtils:normaliza(nResult)
            endif
        next nInd
    endif
    //Limpeza do array auxiliar e do objeto
    aSize(aDataAux,0)
    freeObj(oSfUtils)
return

//-------------------------------------------------------------------
/*/{Protheus.doc} destroy
Limpeza dos arrays de dados e estrutura.
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method destroy() class SFGENMOD
    //---------------------
    //Limpeza dos arrays
    //---------------------
    aSize(self:aColumns, 0)
    aSize(self:aData   , 0)


return


user function sfgenmod()
return