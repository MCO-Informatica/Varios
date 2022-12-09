#INCLUDE "protheus.ch"
#INCLUDE "TOTVS.CH"

#DEFINE INPUT       1
#DEFINE COMBOBOX    2
#DEFINE RADIO       3
#DEFINE CHECKLABEL  4
#DEFINE CHECKBOX    5
#DEFINE FILE        6
#DEFINE FILTER      7
#DEFINE PASSWORD    8
#DEFINE LABEL       9
#DEFINE RANGE       10
#DEFINE MULTIGET    11    
#DEFINE PEDIDOS     12

/*/{Protheus.doc} Class CSParambox
Classe que utiliza a fun��o Parambox para montar um formul�rio de par�metros padr�es do Protheus.
A classe cont�m alguns m�todos para que o desenvolvimento e utiliza��o do Parambox sejam utilizados
em alto-n�vel, em contraste � necessidade da declara��o de arrays e indica��o de tipos num�ricos
como a fun��o padr�o hoje � definida.

@author     yuri.volpe
@since      14/07/2021
@version    1.0

@property   aPedidos (array)        Lista de pedidos indicados no tipo LISTAPEDIDOS
@property   nQtdPedidos (int)       Quantidade de pedidos contidos no ::aPedidos
@property   aRespostas (array)      Rela��o das respostas dadas aos par�metros
@property   aParam (array)          Perguntas que ser�o utilizadas no Parambox
@property   lHasListaPedidos (bool) Indica se o parambox utiliza o tipo LISTAPEDIDOS
@property   cCabec (string)         Cabe�alho utilizado no Parambox
@property   aLabel (array)          Lista de labels para identifica��o das respostas
*/
Class CSParambox

    Data aPedidos
    Data aRespostas
    Data nQtdPedidos
    Data aParam
    Data lHasListaPedidos
    Data nItemPedidos
    Data cCabec
    Data aLabel

    Method New(cCabecalho, aParametros) Constructor
    Method resetPedidos()
    Method hasData()
    Method addParam(nTipo, xParam1, xParam2, xParam3, xParam4, xParam5, xParam6, xParam7, xParam8, xParam9, xParam10)
    Method addInput(cLabel, cDescricao, cInit, cPicture, cValid, cF3, cWhen, nTamanho, lObrigat)
    Method addCombo(cLabel, cDescricao, aOpcoes, nOpIni, nTamanho, cValid, lObrigat)
    Method addRadio(cLabel, cDescricao, aOpcoes, nOpIni, nTamanho, cValid, lObrigat)
    Method addChkLabel(cLabel, cDescricao, lChecked, cTexto, nTamanho, cValid, lObrigat) 
    Method addCheckbox(cLabel, cDescricao, lChecked, nTamanho, cValid, lObrigat)
    Method addFile(cLabel, cDescricao, cArqs, cDirIni, nFlags, cInit, cPicture, cValid, cWhen, nTamanho, lObrigat)
    Method addFilter(cLabel, cDescricao, cAlias, cFiltro)
    Method addPassword(cLabel, cDescricao, cInit, cPicture, cValid, cF3, cWhen, nTamanho, lObrigat) 
    Method addLabel(cLabel, cDescricao, nWidth, nHeight, lFont) 
    Method addRange(cLabel, cTitulo, cInit, cF3, nTamanho, cTipo, nEspaco, cWhen)
    Method addMultiGet(cLabel, cDescricao, cInit, cValid, cWhen, lObrigat)
    Method addListaPedidos()
    Method show()
    Method setCabecalho(cCabecalho)
    Method getValueByLabel(cLabel)

EndClass

/*/{Protheus.doc} New
M�todo construtor para iniciar os atributos. Os par�metros s�o opcionais. Caso sejam informados,
o Parambox ser� criado conforme os par�metros passados. Caso contr�rio, os m�todos auxiliares 
dever�o ser utilizados para estruturar o Parambox.

@author     yuri.volpe
@since      14/07/2021
@version    1.0
@type       Method

@param      cCabecalho (string) Descri��o a ser apresentada no Parambox [OPCIONAL]
@param      aParametros (array) Par�metros para cria��o do Parambox [OPCIONAL]
@return     null
*/
Method New(cCabecalho, aParametros) Class CSParambox

    DEFAULT aParametros := {}
    DEFAULT cCabecalho  := "Par�metros"

    ::resetPedidos()
    ::cCabec := cCabecalho

    If Len(aParametros) > 0
        ::aParam := aParametros
    EndIf

Return 

/*/{Protheus.doc} resetPedidos
M�todo respons�vel por limpar os atributos de cria��o do Parambox

@author     yuri.volpe
@since      14/07/2021
@version    1.0
@type       Method

@param      null
@return     null
*/
Method resetPedidos() Class CSParambox
    ::aPedidos := {}
    ::aParam := {}
    ::aLabel := {}
    ::lHasListaPedidos := .F.
Return

/*/{Protheus.doc} hasData
M�todo respons�vel por limpar o atributo aParam, que contem o retorno da fun��o Parambox

@author     yuri.volpe
@since      14/07/2021
@version    1.0
@type       Method

@param      null
@return     lHasData (boolean)  Indica se o Parambox n�o foi cancelado e tem respostas
*/
Method hasData() Class CSParambox
Return Len(::aRespostas) > 0

/*/{Protheus.doc} addInput
Inclui um campo do tipo GET para receber dados digitados pelo usu�rio.

@author     yuri.volpe
@since      14/07/2021
@version    1.0
@type       Method

@param      cLabel (string)     R�tulo para retornar o valor do campo
@param      cDescricao (string) Label para o campo de inser��o de dados
@param      cInit (string)      String contendo o inicializador do campo [OPCIONAL]
@param      cPicture (string)   String contendo a Picture do campo [OPCIONAL]
@param      cValid (string)     String contendo a validacao [OPCIONAL]
@param      cF3 (string)        Consulta F3 [OPCIONAL]
@param      cWhen (string)      String contendo a validacao When [OPCIONAL]
@param      nTamanho (int)      Tamanho do MsGet [OPCIONAL]
@param      lObrigat (bool)     Indica se o par�metro � obrigat�rio [OPCIONAL]

@return     lAdd (bool)         Par�metro inclu�do
*/
Method addInput(cLabel, cDescricao, cInit, cPicture, cValid, cF3, cWhen, nTamanho, lObrigat) Class CSParambox

    Default cInit       := Space(80)
    Default cPicture    := "@!"
    Default cValid      := ""
    Default cF3         := ""
    Default cWhen       := ""
    Default nTamanho    := 75
    Default lObrigat    := .F.

    aAdd(::aLabel, {cLabel, INPUT})

Return ::addParam(INPUT, cDescricao, cInit, cPicture, cValid, cF3, cWhen, nTamanho, lObrigat)

/*/{Protheus.doc} addCombo
Inclui um campo do tipo Combobox (Dropdown) para sele��o do usu�rio

@author     yuri.volpe
@since      14/07/2021
@version    1.0
@type       Method

@param      cLabel (string)     R�tulo para retornar o valor do campo
@param      cDescricao (string) Label para o campo dropdown
@param      aOpcoes (array)     Array de Strings contendo as op��es do Combo
@param      nOpIni (int)        Op��o pr�-selecionada
@param      nTamanho (int)      Tamanho do MsGet
@param      cValid (string)     String contendo a validacao
@param      lObrigat (bool)     Indica se o par�metro � obrigat�rio

@return     lAdd (bool)         Par�metro inclu�do
*/
Method addCombo(cLabel, cDescricao, aOpcoes, nOpIni, nTamanho, cValid, lObrigat) Class CSParambox

    Default nOpIni      := 1
    Default cValid      := ""
    Default nTamanho    := 75
    Default lObrigat    := .F.

    aAdd(::aLabel, {cLabel, COMBOBOX})

Return ::addParam(COMBOBOX, cDescricao, nOpIni, aOpcoes, nTamanho, cValid, lObrigat)

/*/{Protheus.doc} addRadio
Inclui um campo do tipo Radio para sele��o do usu�rio

@author     yuri.volpe
@since      14/07/2021
@version    1.0
@type       Method

@param      cLabel (string)     R�tulo para retornar o valor do campo
@param      cDescricao (string) Label para o campo da radio
@param      aOpcoes (array)     Array de Strings contendo as op��es do Radio
@param      nOpIni (int)        Op��o pr�-selecionada
@param      nTamanho (int)      Tamanho do MsGet
@param      cValid (string)     String contendo a validacao
@param      lObrigat (bool)     Indica se o par�metro � obrigat�rio

@return     lAdd (bool)         Par�metro inclu�do
*/
Method addRadio(cLabel, cDescricao, aOpcoes, nOpIni, nTamanho, cValid, lObrigat) Class CSParambox

    Default nOpIni      := 1
    Default cValid      := ""
    Default nTamanho    := 75
    Default lObrigat    := .F.

    aAdd(::aLabel, {cLabel, RADIO})

Return ::addParam(RADIO, cDescricao, nOpIni, aOpcoes, nTamanho, cValid, lObrigat)

/*/{Protheus.doc} addChkLabel
Inclui um campo do tipo Checkbox com Label

@author     yuri.volpe
@since      14/07/2021
@version    1.0
@type       Method

@param      cLabel (string)     R�tulo para retornar o valor do campo
@param      cDescricao (string) Label para o campo da checkbox
@param      lChecked (bool)     Indica se o checkbox inicia selecionado
@param      cTexto (string)     Texto do Checkbox
@param      nTamanho (int)      Tamanho do MsGet
@param      cValid (string)     String contendo a validacao
@param      lObrigat (bool)     Indica se o par�metro � obrigat�rio

@return     lAdd (bool)         Par�metro inclu�do
*/
Method addChkLabel(cLabel, cDescricao, lChecked, cTexto, nTamanho, cValid, lObrigat) Class CSParambox

    Default lChecked    := .F.
    Default nTamanho    := 75
    Default cValid      := ""
    Default lObrigat    := .F.

    aAdd(::aLabel, {cLabel, CHECKLABEL})

Return ::addParam(CHECKLABEL, cDescricao, lChecked, cTexto, nTamanho, cValid, lObrigat)

/*/{Protheus.doc} addCheckbox
Inclui um campo do tipo Checkbox com Label

@author     yuri.volpe
@since      14/07/2021
@version    1.0
@type       Method

@param      cLabel (string)     R�tulo para retornar o valor do campo
@param      cDescricao (string) Label para o campo da checkbox
@param      lChecked (bool)     Indica se o checkbox inicia selecionado
@param      nTamanho (int)      Tamanho do MsGet
@param      cValid (string)     String contendo a validacao
@param      lObrigat (bool)     Indica se o par�metro � obrigat�rio

@return     lAdd (bool)         Par�metro inclu�do
*/
Method addCheckbox(cLabel, cDescricao, lChecked, nTamanho, cValid, lObrigat) Class CSParambox

    Default lChecked    := .F.
    Default nTamanho    := 75
    Default cValid      := ""
    Default lObrigat    := .F.

    aAdd(::aLabel, {cLabel, CHECKBOX})

Return ::addParam(CHECKBOX, cDescricao, Iif(lChecked==Nil,.F.,.T.), nTamanho, cValid, lObrigat)

/*/{Protheus.doc} addFile
Inclui um campo do tipo cGetFile para obter o diret�rio

@author     yuri.volpe
@since      14/07/2021
@version    1.0
@type       Method

@param      cLabel (string)     R�tulo para retornar o valor do campo
@param      cDescricao (string) Label para o campo do arquivo
@param      cArqs (string)      Filtro de Tipos de arquivo Ex.: "Todos os arquivos (*.*) |*.*"
@param      cDirIni (string)    Diret�rio inicial para utiliza��o do getfile
@param      nFlags (int)        Flags de acesso e grava��o do getfile
@param      cInit (string)      String contendo o inicializador do campo
@param      cPicture (string)   String contendo a Picture do campo
@param      cValid (string)     String contendo a validacao
@param      cWhen (string)      String contendo a valida��o When
@param      nTamanho (int)      Tamanho do MsGet
@param      lObrigat (bool)     Indica se o par�metro � obrigat�rio

@return     lAdd (bool)         Par�metro inclu�do
*/
Method addFile(cLabel, cDescricao, cArqs, cDirIni, nFlags, cInit, cPicture, cValid, cWhen, nTamanho, lObrigat) Class CSParambox

    Default cArqs := "Todos os arquivos (*.*) |*.*"
    Default cInit := Space(150)
    Default cPicture := "@!"
    Default cValid := ""
    Default cWhen := ""
    Default nTamanho := 70
    Default lObrigat := .F.

    aAdd(::aLabel, {cLabel,FILE})

Return ::addParam(FILE, cDescricao, cInit, cPicture, cValid, cWhen, nTamanho, lObrigat, cArqs, cDirIni, nFlags)

/*/{Protheus.doc} addFilter
Inclui um campo do tipo Filtro

@author     yuri.volpe
@since      14/07/2021
@version    1.0
@type       Method

@param      cLabel (string)     R�tulo para retornar o valor do campo
@param      cDescricao (string) Descri��o do filtro
@param      cArqs (string)      Alias da tabela
@param      cDirIni (string)    Filtro inicial

@return     lAdd (bool)         Par�metro inclu�do
*/
Method addFilter(cLabel, cDescricao, cAlias, cFiltro) Class CSParambox
    aAdd(::aLabel, {cLabel, FILTER})
Return ::addParam(FILTER, cDescricao, cAlias, cFiltro)

/*/{Protheus.doc} addPassword
Inclui um campo do tipo Input, mascarado como Senha

@author     yuri.volpe
@since      14/07/2021
@version    1.0
@type       Method

@param      cLabel (string)     R�tulo para retornar o valor do campo
@param      cDescricao (string) Label para o campo do tipo Password
@param      cInit (string)      String contendo o inicializador do campo
@param      cPicture (string)   String contendo a Picture do campo
@param      cValid (string)     String contendo a validacao
@param      cF3 (string)        Consulta F3
@param      cWhen (string)      String contendo a valida��o When
@param      nTamanho (int)      Tamanho do MsGet
@param      lObrigat (bool)     Indica se o par�metro � obrigat�rio

@return     lAdd (bool)         Par�metro inclu�do
*/
Method addPassword(cLabel, cDescricao, cInit, cPicture, cValid, cF3, cWhen, nTamanho, lObrigat) Class CSParambox
    aAdd(::aLabel, {cLabel, PASSWORD})
Return ::addParam(PASSWORD, cDescricao, cInit, cPicture, cValid, cF3, cWhen, nTamanho, lObrigat)

/*/{Protheus.doc} addLabel
Inclui um Label

@author     yuri.volpe
@since      14/07/2021
@version    1.0
@type       Method

@param      cLabel (string)     R�tulo para retornar o valor do campo
@param      cDescricao (string) Label para o campo do tipo Password
@param      nWidth (int)        Largura do texto
@param      nHeight (int)       Altura do texto
@param      lFont (bool)        Valor l�gico sendo: .T. => fonte tipo VERDANA e .F. => fonte tipo ARIAL

@return     lAdd (bool)         Par�metro inclu�do
*/
Method addLabel(cLabel, cDescricao, nWidth, nHeight, lFont) Class CSParambox
    aAdd(::aLabel, {cLabel, LABEL})
Return ::addParam(LABEL, cDescricao, nWidth, nHeight, lFont)

/*/{Protheus.doc} addRange
Inclui um campo do tipo Range

@author     yuri.volpe
@since      14/07/2021
@version    1.0
@type       Method

@param      cLabel (string)     R�tulo para retornar o valor do campo
@param      cDescricao (string) Label para o campo do tipo Range
@param      cInit (string)      Inicializador padr�o
@param      cF3 (string)        Consulta F3
@param      nTamanho (int)      Tamanho do MsGet
@param      cTipo (string)      Tipo do dado, somente (C=caractere e D=data)
@param      nEspcao (int)       Tamanho do espa�o
@param      cWhen (string)      String contendo a valida��o When

@return     lAdd (bool)         Par�metro inclu�do
*/
Method addRange(cLabel, cTitulo, cInit, cF3, nTamanho, cTipo, nEspaco, cWhen) Class CSParambox
    aAdd(::aLabel, {cLabel, RANGE})
Return ::addParam(RANGE, cTitulo, cInit, cF3, nTamanho, cTipo, nEspaco, cWhen)

/*/{Protheus.doc} addMultiGet
Inclui um campo do tipo Memo para input de m�ltiplas linhas

@author     yuri.volpe
@since      14/07/2021
@version    1.0
@type       Method

@param      cLabel (string)     R�tulo para retornar o valor do campo
@param      cDescricao (string) Label para o campo do tipo Range
@param      cInit (string)      Inicializador padr�o
@param      cValid (string)     String contendo a validacao
@param      cWhen (string)      String contendo a valida��o When
@param      lObrigat (bool)     Indica se o par�metro � obrigat�rio

@return     lAdd (bool)         Par�metro inclu�do
*/
Method addMultiGet(cLabel, cDescricao, cInit, cValid, cWhen, lObrigat) Class CSParambox

    Default cInit    := ""
    Default cValid   := ""
    Default cWhen    := ""
    Default lObrigat := .F.

    aAdd(::aLabel, {cLabel, MULTIGET})

Return ::addParam(MULTIGET, cDescricao, cInit, cValid, cWhen, lObrigat)

/*/{Protheus.doc} addListaPedidos
Adiciona um campo do tipo Multiget para tratar exclusivamente uma lista de Pedidos GAR/Site/E-Commerce

@author     yuri.volpe
@since      14/07/2021
@version    1.0

@param      null
@return     lAdd (bool)         Par�metro inclu�do
*/
Method addListaPedidos() Class CSParambox
    ::lHasListaPedidos := .T.
    ::nItemPedidos := Len(::aParam) + 1
    aAdd(::aLabel, "ListaPedidos")
Return ::addMultiGet("Pedidos",,,,.T.)

/*/{Protheus.doc} addParam
Inclui par�metros que ser�o utilizados para montagem da tela do Parambox. A obrigatoriedade de cada par�metro depende do tipo
de campo que ser� inclu�do.

@author     yuri.volpe
@since      14/07/2021
@version    1.0
@type       Method

@param      nTipo (string)      Tipo do campo que ser� criado.
@param      xParam1...10 (any)  Valores que ser�o passados para inclus�o no array de par�metros

@return     lAdd (bool)         Par�metro inclu�do
*/
Method addParam(nTipo, xParam1, xParam2, xParam3, xParam4, xParam5, xParam6, xParam7, xParam8, xParam9, xParam10) Class CSParambox

    Local aParamTmp := {}

    aAdd(aParamTmp, nTipo)
    
    If xParam1  != Nil; aAdd(aParamTmp, xParam1);  EndIf
    If xParam2  != Nil; aAdd(aParamTmp, xParam2);  EndIf
    If xParam3  != Nil; aAdd(aParamTmp, xParam3);  EndIf
    If xParam4  != Nil; aAdd(aParamTmp, xParam4);  EndIf
    If xParam5  != Nil; aAdd(aParamTmp, xParam5);  EndIf
    If xParam6  != Nil; aAdd(aParamTmp, xParam6);  EndIf
    If xParam7  != Nil; aAdd(aParamTmp, xParam7);  EndIf
    If xParam8  != Nil; aAdd(aParamTmp, xParam8);  EndIf
    If xParam9  != Nil; aAdd(aParamTmp, xParam9);  EndIf
    If xParam10 != Nil; aAdd(aParamTmp, xParam10); EndIf

    aAdd(::aParam, aParamTmp)

Return .T.

/*/{Protheus.doc} show
Monta o Parambox a partir dos par�metros utilizados e trata, caso haja um campo do tipo LISTA DE PEDIDOS, a quebra dos itens
para um Array na propriedade ::aRespostas.

@author     yuri.volpe
@since      14/07/2021
@version    1.0

@param      null
@return     null
*/
Method show() Class CSParambox

    // Se n�o houver par�metros, n�o exibe o Parambox
    If Len(::aParam) == 0
        Return
    EndIf

    // Executa o Parambox
    If Parambox(::aParam, ::cCabec, @::aRespostas)
        // Caso haja um tipo de campo Lista de Pedidos, trata para quebrar a lista
        // de pedidos no array ::aRespostas
        If ::lHasListaPedidos
            ::aPedidos := StrToArray(::aRespostas:getValueByLabel("ListaPedidos"), CHR(13) + CHR(10))
            ::nQtdPedidos := Len(::aPedidos)
        EndIf
    EndIf

Return 

/*/{Protheus.doc} setCabecalho
Atualiza o cabe�alho do Parambox, caso n�o tenha sido passado como par�metro na inst�ncia do Objeto

@author     yuri.volpe
@since      14/07/2021
@version    1.0

@param      cCabecalho(string)  Define o cabe�alho do parambox
@return     null
*/
Method setCabecalho(cCabecalho) Class CSParambox

    Default cCabecalho := "Par�metros"

    ::cCabec := Iif(!Empty(cCabecalho), cCabecalho, "Par�metros")

Return

/*/{Protheus.doc} getValueByLabel
Devolve a resposta preenchida em determinado campo do Parambox, baseado o no Label utilizado.

@author     yuri.volpe
@since      14/07/2021
@version    1.0

@param      cLabel (string) R�tulo para identificar o valor a ser obtido
@return     xRet (any)      Valor que corresponde � resposta do par�metro rotulado. Nil caso o label n�o exista
*/
Method getValueByLabel(cLabel) Class CSParambox

    Local xRet  := Nil   // Deve retornar NIL caso o Label n�o exista
    Local nPos  := 0
    Local nTipo := 0

    // Tenta localizar o label e o tipo do campo
    nPos := aScan(::aLabel, {|x| x[1] == cLabel })
    nTipo := ::aLabel[nPos][2]

    If nPos > 0
        // Para RADIOBUTTON ou COMBOBOX trata o valor selecionado
        // Quando o valor estiver diferente de num�rico
        If nTipo == RADIO .Or. nTipo == COMBOBOX
            If ValType(::aRespostas[nPos]) != "N"
                xRet := Val(Substr(::aRespostas[nPos],1,1))
            Else
                xRet := ::aRespostas[nPos]
            EndIf
        ElseIf cLabel == "ListaPedidos"
            // Trata o tipo LISTAPEDIDOS como exce��o
            xRet := ::aPedidos
        Else
            xRet := ::aRespostas[nPos]
        EndIf
    EndIf

Return xRet
