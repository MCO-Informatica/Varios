#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} className
    (Classe de Validação da Condição de Pagamento do cliente)
    @author Pirolo
    @since 28/07/2021
    @version version
    /*/
CLASS ClienteFat 
    // Declaracao das propriedades da Classe
    DATA cCliente
    DATA cLoja
    DATA cTESCli
    DATA aConds
    DATA lVld
    DATA oNiveis
    DATA cVendedor

    // Declaração dos Métodos da Classe
    METHOD New(cCliente, cLoja, cCondPg) CONSTRUCTOR
    
    //Valida a Condição de Pagamento conforme permissões do cliente
    METHOD VldCondPg( cCondPg ) 

    //Metodo que carrega os Niveis liberados para o cliente
    METHOD LoadCliente()

    //Valida se o nivel informado é permitido ao cliente
    METHOD VldNivel()

    //Metodo que carrega as condições de pagamentos do cliente
    METHOD LoadCondPg()

ENDCLASS

/*/{Protheus.doc} New
    (Metodo criador da classe ClienteFat)
    @author Pirolo
    @since 28/07/2021
    @param cCliente , Caractere, Codigo do Cliente
    @param cLoja    , Caractere, Loja do Cliente
    @param cCondPg  , Caractere, Código da Condição de Pagamento
    @return Objeto, Objeto, Objeto criado
    /*/
METHOD New(cCliente, cLoja, cCondPg) Class ClienteFat
Local aArea := GetArea()
::cCliente  := cCliente
::cLoja     := cLoja
::cTESCli   := ""
::lVld      := .F.
::aConds    := {}
::oNiveis   := oNiveis():New()

//Se Informado código do Cliente
If !Empty(::cCliente) .AND. !Empty(::cLoja)

    //Carrega as condições de pagamento liberadas para o cliente
    ::LoadCondPg()

    //Se informou a condição de pagamento, chama o metodo de validação
    If !Empty(cCondPg)
        ::VldCondPg(cCondPg)
    EndIf

    //Carrega os niveis que o cliente possui permissão
    ::LoadCliente()
EndIf

RestArea(aArea)
Return Self


/*/{Protheus.doc} LoadCondPg
    (Carrega as condições de pagamento liberadas para o cliente)
    @author Pirolo
    @since 30/07/2021
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    /*/
Method LoadCondPg() class ClienteFat
Local aAreaPA2  := PA2->(GetArea())

    DbSelectArea("PA2")
    PA2->(dbSetOrder(1))//PA2_FILIAL, PA2_CLIENT, PA2_LOJA

    //Carrega as condições de pagamento cadastradas para o cliente informado
    If PA2->(dbSeek(xFilial("PA2")+::cCliente+::cLoja))
        While PA2->(!Eof() .AND. PA2_FILIAL+PA2_CLIENT+PA2_LOJA == xFilial("PA2")+::cCliente+::cLoja)
            Aadd(::aConds, PA2->PA2_CONDPA )
            PA2->(DbSkip())
        EndDo
    EndIf

RestArea(aAreaPA2)
Return

/*/{Protheus.doc} VldCondPg
    (Metodo que valida uma condição de pagamento)
    @author Pirolo
    @since 28/07/2021
    @param cCondPg, Caractere, Cod da Cond Pagamento
    @return ::lVld, lógico, Boolean indicando validação da cond pag
    /*/
METHOD VldCondPg( cCondPg )  Class ClienteFat

//Verifica se a condição é valida para o cliente
::lVld := ASCAN(::aConds, cCondPg) > 0 .OR. ::cCliente == "000001"

Return ::lVld

/*/{Protheus.doc} LoadCliente
    (Carrega os niveis que o cliente possui direito)
    @author Pirolo
    @since 29/07/2021
    @return Nil
    /*/
Method LoadCliente() Class ClienteFat
Local aAreaSA1  := SA1->(GetArea())

//Carrega os niveis do cliente
If !Empty(::cCliente) .AND. !Empty(::cLoja)
    DbSelectArea("SA1")
    SA1->(DbSetOrder(1))

    //Pesquisa o Cliente do Objeto
    If SA1->(DbSeek(xFilial("SA1")+::cCliente+::cLoja))
        //Niveis liberados para o faturamento do cliente
        ::oNiveis:lNivel1   := SA1->A1_XNIVEL1
        ::oNiveis:lNivel2   := SA1->A1_XNIVEL2
        ::oNiveis:lNivel6   := SA1->A1_XNIVEL6
        ::oNiveis:lNivel8   := SA1->A1_XNIVEL8

        //TES a qual o cliente obrigatóriamente deve ser faturado
        ::cTESCli           := SA1->A1_XTES

        //Codigo do Vendedor responsável pelo cliente
        ::cVendedor         := SA1->A1_VEND
    EndIf
EndIf

RestArea(aAreaSA1)
Return

/*/{Protheus.doc} VldNivel
    (long_description)
    @author Pirolo
    @since 30/07/2021
    @version version
    @param cNivel, Caractere, Nivel a ser validado
    @return lRet, Logico, Informa se o nivel é permitido para o cliente
    /*/
Method VldNivel(cNivel) class ClienteFat
Local lRet := .F.

//Se for um nível valido
If Alltrim(cNivel) $ "1|2|6|8"
    //Valida se o nivel esta autorizado para o cliente
    lRet := &('(cNivel == "'+AllTrim(cNivel)+'" .AND. Self:oNiveis:lNivel'+AllTrim(cNivel)+')')
EndIf

Return lRet

/*/{Protheus.doc} oNivel
    (Classe para indicar os niveis existentes)
    @author Pirolo
    @since 29/07/2021
    @version version
    /*/
CLASS oNiveis 
    // Declaracao das propriedades da Classe
    DATA lNivel1
    DATA lNivel2 
    DATA lNivel6
    DATA lNivel8

    // Declaração dos Métodos da Classe
    METHOD New() CONSTRUCTOR
ENDCLASS

/*/{Protheus.doc} New
    (Metodo construtor da Classe oNiveis)
    @author Pirolo
    @since 29/07/2021
    @return return_var, return_type, return_description
    /*/
Method New() class oNiveis

    ::lNivel1 := .F.
    ::lNivel2 := .F.
    ::lNivel6 := .F.
    ::lNivel8 := .F.

Return Self

/*/{Protheus.doc} User Function nomeFunction
    (Função basica de teste da classe)
    @type  Function
    @author Pirolo
    @since 28/07/2021
    /*/
User Function teste() 

Local oCliCondPag := Nil 

RpcSetType(3)
RpcSetEnv("01", "0101")

oCliCondPag :=  ClienteFat():New("000008", "01", "002")

// Imprimo no console o acumulador das somas do obj 1 ( 60 )
conout(oCliCondPag:lVld)

//Testa Validação de Nivel
Conout(oCliCondPag:VldNivel("1"))

Return 

/*/{Protheus.doc} User Function TWFATA02
    (Validação Customizada do campo Condição de Pagamento do Orçamento)
    @type  Function
    @author Pirolo
    @since 28/07/2021
    @param param_name, param_type, param_descr
    /*/
User Function TWFATA02()
Local   lRet        := .T.

//Se a variavel não existir, cria
If Type("oCliFat") == "U" 
    _SetNamedPrvt("oCliFat", nil, "MATA415")
EndIf

oCliFat := ClienteFat():New(M->CJ_CLIENTE, M->CJ_LOJA, M->CJ_CONDPAG)

lRet := Iif(oCliFat:lVld, .T., Iif(Empty(M->CJ_CONDPAG), .T., .F.))

//Se a Cond. Pagto não for aceita para o cliente
If !lRet
    MsgInfo("Condição de Pagamento não cadastrada para este cliente, verifique a amarração Cliente x Cond Pagto.", "Condição de Pagamento")
EndIf

Return lRet

/*/{Protheus.doc} User Function TWFAT02A
    (Validação Customizada do campo CJ_XNIVEL)
    @type  Function
    @author Pirolo
    @since 28/07/2021
    @param lRet, Lógico, indica se o nivel foi validado para o cliente
    /*/
User Function TWFAT02A()
//Valida o nivel selecionado
Local lRet := .T.

//Verifica se o objeto esta estanciado e se instanciado se esta apontado para o cliente em uso
If Type("oCliFat") == "U" .OR. (Type("oCliFat") == "O" .AND. (oCliFat:cCliente <> M->CJ_CLIENTE .OR. oCliFat:cLoja <> M->CJ_LOJA))
    _SetNamedPrvt("oCliFat", nil, "MATA415")

    oCliFat     := ClienteFat():New(M->CJ_CLIENTE, M->CJ_LOJA, M->CJ_CONDPAG)
EndIf

//Verifica se o nivel selecionado é valido
lRet := oCliFat:VldNivel(M->CJ_XNIVEL)

If !lRet
    MsgInfo("Nivel de faturamento não autorizado para este cliente, verifique junto ao gestor responsavel.", "Nivel de Faturamento")    
EndIf

Return lRet

/*/{Protheus.doc} User Function TWFAT02B
    (Preenchimento automático do campo TES)
    @type  Function
    @author Pirolo
    @since 28/07/2021
    @param lRet, Lógico, indica se o nivel foi validado para o cliente
    /*/
User Function TWFAT02B()
Local cTes := ""

//Verifica se o objeto esta estanciado e se instanciado se esta apontado para o cliente em uso
If Type("oCliFat") == "U" .OR. (Type("oCliFat") == "O" .AND. (oCliFat:cCliente <> M->CJ_CLIENTE .OR. oCliFat:cLoja <> M->CJ_LOJA))
    _SetNamedPrvt("oCliFat", nil, "MATA415")

    oCliFat     := ClienteFat():New(M->CJ_CLIENTE, M->CJ_LOJA, M->CJ_CONDPAG)
EndIf

//Retorna a TES de acordo com nivel selecionado
If M->CJ_XNIVEL == "1"
    cTes := oCliFat:cTESCli

ElseIf M->CJ_XNIVEL == "2"
    cTes := oCliFat:cTESCli

ElseIf M->CJ_XNIVEL == "6"
    cTes := SuperGetMV("MV_XTESN6", , "506")

ElseIf M->CJ_XNIVEL == "8"
    cTes := SuperGetMV("MV_XTESN8", , "506")

EndIf

Return cTes

/*/{Protheus.doc} User Function TWFATA02C
    (Rotina para preenchimento do campo de Vendedor do Orçamento)
    @type  Function
    @author Pirolo
    @since 03/08/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function TWFAT02C()

//Verifica se o objeto esta estanciado e se instanciado se esta apontado para o cliente em uso
If Type("oCliFat") == "U" .OR. (Type("oCliFat") == "O" .AND. (oCliFat:cCliente <> M->CJ_CLIENTE .OR. oCliFat:cLoja <> M->CJ_LOJA))
    _SetNamedPrvt("oCliFat", nil, "MATA415")

    oCliFat     := ClienteFat():New(M->CJ_CLIENTE, M->CJ_LOJA, M->CJ_CONDPAG)
EndIf


Return oCliFat:cVendedor


/*/{Protheus.doc} User Function TWFAT02D
    (Rotina para preenchimento do campo de Vendedor do Orçamento)
    @type  Function
    @author Pirolo
    @since 03/08/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function TWFAT02D()
Local cConds        := ""
Local nI            := 0

//Verifica se o objeto esta estanciado e se instanciado se esta apontado para o cliente em uso
If Type("oCliFat") == "U" .OR. (Type("oCliFat") == "O" .AND. (oCliFat:cCliente <> M->CJ_CLIENTE .OR. oCliFat:cLoja <> M->CJ_LOJA))
    _SetNamedPrvt("oCliFat", nil, "MATA415")

    oCliFat     := ClienteFat():New(M->CJ_CLIENTE, M->CJ_LOJA, M->CJ_CONDPAG)
EndIf

//Concatena as condições de pagamentos do cliente
For nI := 1 to Len(oCliFat:aConds)
    cConds += ";"+oCliFat:aConds[nI]
Next nI

Return cConds
