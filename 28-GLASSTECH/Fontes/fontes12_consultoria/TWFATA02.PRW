#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} className
    (Classe de Validação da Condição de Pagamento do cliente)
    @author Glasstech
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
    @author Glasstech
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
    @author Glasstech
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
        If PA2->PA2_ATIVO == .T.         
            Aadd(::aConds, PA2->PA2_CONDPA )
        EndIf      
            PA2->(DbSkip())
        EndDo
    EndIf

RestArea(aAreaPA2)
Return

/*/{Protheus.doc} VldCondPg
    (Metodo que valida uma condição de pagamento)
    @author Glasstech
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
    @author Glasstech
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
    @author Glasstech
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
    @author Glasstech
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
    @author Glasstech
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
    @author Glasstech
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
    @author Glasstech
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

//Se tiver alterado ou informado o cliente, troca a filial de acordo com o cadastro de clientes
If ReadVar() $ "M->CJ_CLIENTE|M->CJ_LOJA"
    DbSelectArea("SA1")
    SA1->(DbSetOrder(1))

    If SA1->(DbSeek(xFilial("SA1")+M->(CJ_CLIENTE+CJ_LOJA)) .AND. !Empty(A1_XFILIAL))
        //Se for Nivel 8 o orçamento é emitido na filial 9001
        //Caso contrario emite na filial indicada no cadastro do cliente
        If M->CJ_XNIVEL <> "8"
            cFilAnt := SA1->A1_XFILIAL
        EndIf
    EndIf
EndIf

Return lRet

/*/{Protheus.doc} User Function TWFAT02A
    (Validação Customizada do campo CJ_XNIVEL)
    @type  Function
    @author Glasstech
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

If lRet
    //Recalcula os campos de impostos destacados
    RecalImpNv()
Else
    MsgInfo("Nivel de faturamento não autorizado para este cliente, verifique junto ao gestor responsavel.", "Nivel de Faturamento")    
EndIf

Return lRet

/*/{Protheus.doc} User Function TWFAT02B
    (Preenchimento automático do campo TES)
    @type  Function
    @author Glasstech
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
    @author Glasstech
    @since 03/08/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function TWFAT02C()

Local cRotinaAtu	:= "" as character
Local cCodCliente	:= "" as character
Local cLojaCliente	:= "" as character
Local cCondPag		:= "" as character

VerRotCliente(@cRotinaAtu, @cCodCliente, @cLojaCliente, @cCondPag)

//Verifica se o objeto esta estanciado e se instanciado se esta apontado para o cliente em uso
If Type("oCliFat") == "U" .OR. (Type("oCliFat") == "O" .AND. (oCliFat:cCliente <> cCodCliente .OR. oCliFat:cLoja <> cLojaCliente))
	_SetNamedPrvt("oCliFat", nil, cRotinaAtu)

	oCliFat     := ClienteFat():New(cCodCliente, cLojaCliente, cCondPag)
EndIf

Return oCliFat:cVendedor


/*/{Protheus.doc} User Function TWFAT02D
    (Rotina para preenchimento do campo de Vendedor do Orçamento)
    @type  Function
    @author Glasstech
    @since 03/08/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function TWFAT02D()

Local cConds		:= "" as character
Local cRotinaAtu	:= "" as character
Local cCodCliente	:= "" as character
Local cLojaCliente	:= "" as character
Local cCondPag		:= "" as character

Local nI			:= 0 as integer

VerRotCliente(@cRotinaAtu, @cCodCliente, @cLojaCliente, @cCondPag)

//Verifica se o objeto esta estanciado e se instanciado se esta apontado para o cliente em uso
If Type("oCliFat") == "U" .OR. (Type("oCliFat") == "O" .AND. (oCliFat:cCliente <> cCodCliente .OR. oCliFat:cLoja <> cLojaCliente))
    _SetNamedPrvt("oCliFat", nil, cRotinaAtu)

	oCliFat     := ClienteFat():New(cCodCliente, cLojaCliente, cCondPag)
EndIf

//Concatena as condições de pagamentos do cliente
For nI := 1 to Len(oCliFat:aConds)
    cConds += ";"+oCliFat:aConds[nI]
Next nI

Return cConds

/*/{Protheus.doc} User Function TWFAT02E
    (Retorna um campo de imposto conforme solicitado)
    @type  Function
    @author user
    @since 16/08/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function TWFAT02E(cCampo)
Local nVlr      := 0
Local _cTipoCli := ""
Local aAreas	:= {SCJ->(GetArea()), SCK->(GetArea()), TMP1->(GetArea()), SA1->(GetArea()), SB1->(GetArea()), GetArea()}
Local nPrcven 	:= Iif(M->CJ_XNIVEL == "2" , TMP1->CK_PRCVEN/2, TMP1->CK_PRCVEN)

Private aImp     := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

_cTipoCli := Posicione("SA1",1,xFilial("SA1")+M->CJ_CLIENTE+M->CJ_LOJA,"A1_TIPO")

//Carrega a MATXFIS para pegar os valores dos impostos
fCalcImp(M->CJ_CLIENTE,M->CJ_LOJA,_cTipoCli,TMP1->CK_PRODUTO,TMP1->CK_TES,TMP1->CK_QTDVEN, nPrcven, nPrcven*TMP1->CK_QTDVEN)

If cCampo == "CK_XVLRIPI"
    nVlr := aImp[05]
ElseIf cCampo == "CK_XBASRET"
    nVlr := aImp[14]
ElseIf cCampo == "CK_XICMSRE"
    nVlr := aImp[16]
ElseIf cCampo == "CK_XVLRTOT"
    nVlr := TMP1->(CK_VALOR+CK_XVLRIPI+CK_XICMSRE)
EndIf

//Preenche os demais campos
RecalImpNv()

aEval(aAreas, {|x| RestArea(x) })	

Return nVlr

/*
+===========================================================================+
|===========================================================================|
|Programa: fCalcImp     | Tipo: Função                |  Data: 14/08/2014   |
|===========================================================================|
|Programador: Caio Garcia - Global Gcs                                      |
|===========================================================================|
|Utilidade: Calcula impostos por item do orçamento.                         |
|===========================================================================|
*/
Static Function fCalcImp(cCliente,cLoja,cTipo,cProduto,cTes,nQtd,nPrc,nValor)

aImp := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

// -------------------------------------------------------------------
// Realiza os calculos necessários
// -------------------------------------------------------------------
MaFisIni(	cCliente,;                             // 1-Codigo Cliente/Fornecedor
			cLoja,;                                // 2-Loja do Cliente/Fornecedor
			"C",;                                  // 3-C:Cliente , F:Fornecedor
			"N",;                                  // 4-Tipo da NF
			cTipo,;                                // 5-Tipo do Cliente/Fornecedor
			MaFisRelImp("MTR700",{"SCJ","SCK"}),;  // 6-Relacao de Impostos que suportados no arquivo
			,;                                     // 7-Tipo de complemento
			,;                                     // 8-Permite Incluir Impostos no Rodape .T./.F.
			"SB1",;                                // 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
			"MTR700")                              // 10-Nome da rotina que esta utilizando a funcao

// -------------------------------------------------------------------
// Monta o retorno para a MaFisRet
// -------------------------------------------------------------------
MaFisAdd(cProduto, cTes, nQtd, nPrc, 0, "", "",, 0, 0, 0, 0, nValor,;			// 13-Valor da Mercadoria ( Obrigatorio )
		 0,;					// 14-Valor da Embalagem ( Opiconal )
		 , , , , , , , , , , , , ,;
		 TMP1->CK_CLASFIS) // 28-Classificacao fiscal)

//Monta um array com os valores necessários

aImp[1] := cProduto
aImp[2] := cTes
aImp[3] := MaFisRet(01	,"IT_ALIQICM")  //Aliquota ICMS
aImp[4] := MaFisRet(01	,"IT_VALICM")  //Valor de ICMS
aImp[5] := MaFisRet(01	,"IT_VALIPI")  //Valor de IPI
aImp[6] := MaFisRet(01	,"IT_ALIQCOF") //Aliquota de calculo do COFINS
aImp[7] := MaFisRet(01	,"IT_ALIQPIS") //Aliquota de calculo do PIS
aImp[8] := MaFisRet(01	,"IT_ALIQPS2") //Aliquota de calculo do PIS 2
aImp[9] := MaFisRet(01	,"IT_ALIQCF2") //Aliquota de calculo do COFINS 2
aImp[10]:= MaFisRet(01	,"IT_DESCZF")  //Valor de Desconto da Zona Franca de Manaus
aImp[11]:= MaFisRet(01	,"IT_VALPIS")  //Valor do PIS
aImp[12]:= MaFisRet(01	,"IT_VALCOF")  //Valor do COFINS
aImp[13]:= MaFisRet(01	,"IT_BASEICM") //Valor da Base de ICMS

//Tratamento Volvo
If M->CJ_CLIENTE == "021984"
	MaFisLoad("IT_BASESOL" , VOLVORE()    ,Val(TMP1->CK_ITEM))

EndIf

aImp[14]:= MaFisRet(01	,"IT_BASESOL") //Base do ICMS Solidario
aImp[15]:= MaFisRet(01	,"IT_ALIQSOL") //Aliquota do ICMS Solidario
aImp[16]:= MaFisRet(01	,"IT_VALSOL" ) //Valor Solidário
aImp[17]:= MaFisRet(01	,"IT_MARGEM")  //Margem de lucro para calculo da Base do ICMS Sol.

MaFisSave()
MaFisEnd()

Return aImp

/*/{Protheus.doc} Static Function RecalImpNv
    (Função para recalcular Itens de orçamento caso alterado o nivel)
    @type  Function
    @author Glasstech
    @since 16/08/2021
    @version version
    @return return_var, return_type, return_description
    /*/
Static Function RecalImpNv()
Local _cTipoCli := ""
Local aAreas	:= {SCJ->(GetArea()), SCK->(GetArea()), TMP1->(GetArea()), SA1->(GetArea()), SB1->(GetArea()), GetArea()}
Local nPrcven 	:= 0
Local oDlg      := nil

Private aImp     := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

_cTipoCli := Posicione("SA1",1,xFilial("SA1")+M->CJ_CLIENTE+M->CJ_LOJA,"A1_TIPO")

//Posiciona no primeiro item do orçamento
TMP1->(DbGoTop())

While TMP1->(!Eof())
    //Trata impostos para o Nivel 2
    nPrcven := Iif(M->CJ_XNIVEL == "2" , TMP1->CK_PRCVEN/2, TMP1->CK_PRCVEN)

    //Carrega a MATXFIS para pegar os valores dos impostos
    fCalcImp(M->CJ_CLIENTE,M->CJ_LOJA,_cTipoCli,TMP1->CK_PRODUTO,TMP1->CK_TES,TMP1->CK_QTDVEN, nPrcven, nPrcven*TMP1->CK_QTDVEN)

    TMP1->CK_XVLRIPI	:= aImp[05]
    // TMP1->CK_XBASRET 	:= aImp[14]
    TMP1->CK_XICMSRE	:= aImp[16]
    TMP1->CK_XVLRTOT	:= TMP1->(CK_VALOR+CK_XVLRIPI+CK_XICMSRE)

    TMP1->(DbSkip())
EndDo

oDlg := GetWndDefault()
A415Total(oDlg)

aEval(aAreas, {|x| RestArea(x) })

Return

Static Function A415Total(oDlg)

Local aArea   	:= GetArea()
Local aAreaTmp1	:= TMP1->(GetArea())
Local nTotVal 	:= 0
Local nTotDesc	:= 0
Local nPerDesc  := M->CJ_DESC4
Local nX  := 0
Local aControl
Local cBonusTS	:= SuperGetMv("MV_BONUSTS", .F., "")

l415Auto := If(Type("l415Auto")<>"U",l415Auto,.F.)
l416Auto := If(Type("l416Auto")<>"U",l416Auto,.F.)

If !(l415Auto) .and. !(l416Auto)
	aControl := oDlg:aControls
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Soma o os valores e os descontos, mostrando-os na tela³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TMP1")
dbGotop()
While ( !Eof() )
	If ( !TMP1->CK_FLAG ) .Or. ( TMP1->CK_FLAG .And. TMP1->CK_TES $ AllTrim(cBonusTS))
		nTotVal  += TMP1->CK_VALOR
		If (TMP1->CK_PRUNIT > TMP1->CK_PRCVEN)
			nTotDesc += A410Arred((TMP1->CK_PRUNIT * TMP1->CK_QTDVEN),"CK_VALOR") - A410Arred((TMP1->CK_PRCVEN * TMP1->CK_QTDVEN),"CK_VALOR")
		Else
			nTotDesc += TMP1->CK_VALDESC
		EndIf
	EndIf
	dbSelectArea("TMP1")
	dbSkip()
EndDo
nTotDesc += M->CJ_DESCONT
nTotVal  -= M->CJ_DESCONT
nTotDesc += A410Arred(nTotVal*M->CJ_PDESCAB/100,"C6_VALOR")
nTotVal  -= A410Arred(nTotVal*M->CJ_PDESCAB/100,"C6_VALOR")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calcula o Desconto por Total                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nTotVal > 0 .And. FtRegraDesc(4,nTotVal+nTotDesc,@M->CJ_DESC4) <> nPerDesc
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Soma o os valores e os descontos, mostrando-os na tela³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTotVal := 0
	nTotDesc:= 0
	dbSelectArea("TMP1")
	dbGotop()
	While ( !Eof() )
		If ( !TMP1->CK_FLAG )
			nTotVal  += TMP1->CK_VALOR
			If (TMP1->CK_PRUNIT > TMP1->CK_PRCVEN)
				nTotDesc += A410Arred((TMP1->CK_PRUNIT * TMP1->CK_QTDVEN),"CK_VALOR") - A410Arred((TMP1->CK_PRCVEN * TMP1->CK_QTDVEN),"CK_VALOR")
			Else
				nTotDesc += TMP1->CK_VALDESC
			EndIf
		EndIf
		dbSelectArea("TMP1")
		dbSkip()
	EndDo
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Soma as variaveis da Enchoice                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTotVal += M->CJ_FRETE
nTotVal += M->CJ_SEGURO
nTotVal += M->CJ_DESPESA
nTotVal += M->CJ_FRETAUT

If cPaisLoc $ "CHI|PAR" .And. M->CJ_MOEDA == 1
	nTotVal   := A410Arred(nTotVal ,"CK_VALOR",M->CJ_MOEDA)
	nTotDesc  := A410Arred(nTotDesc,"CK_VALOR",M->CJ_MOEDA)	
EndIf

If !( l415Auto .or. l416Auto)
	For nX := 1 To Len(aControl)
		If ValType(aControl[nX]) <> "U" .AND. ValType(aControl[nX]:Cargo)=="C"
			Do Case
			Case ( aControl[nX]:Cargo $ "Total" )
				aControl[nX]:SetText(IIf(cPaisLoc $ "CHI|PAR" .And. M->CJ_MOEDA > 1,Transform(nTotVal,PesqPict("SCK","CK_VALOR",,M->CJ_MOEDA)),nTotVal))
			Case ( aControl[nX]:Cargo $ "Desconto" )
				aControl[nX]:SetText(IIf(cPaisLoc $ "CHI|PAR" .And. M->CJ_MOEDA > 1,Transform(nTotDesc,PesqPict("SCK","CK_VALOR",,M->CJ_MOEDA)),nTotDesc))
			Case ( aControl[nX]:Cargo $ "Valor" )
				aControl[nX]:SetText(IIf(cPaisLoc $ "CHI|PAR" .And. M->CJ_MOEDA > 1,Transform(nTotVal+nTotDesc,PesqPict("SCK","CK_VALOR",,M->CJ_MOEDA)),nTotVal+nTotDesc))
			EndCase
		EndIf
	Next nX
EndIf
RestArea(aAreaTmp1)
RestArea(aArea)
Return(Nil)

/*/{Protheus.doc} VerRotCliente
	(Verifica rotina e dados do orcamento/pedido do cliente)
	@type Static Function
	@author user
	@since 25/10/2021
	@version version
	@param cRotinaAtu, character, (Rotina que esta executando o processo)
	@param cCodCliente, character, (Codigo do cliente da rotina atual)
	@param cLojaCliente, character, (Codigo da loja do cliente da rotina atual)
	@param cCondPag, character, (Condicao de pagamento da rotina atual)
	@return Nil, Nulo
	@example
	(examples)
	@see (links_or_references)
	/*/

Static Function VerRotCliente(cRotinaAtu, cCodCliente, cLojaCliente, cCondPag)

Do Case
    Case IsInCallStack("MATA415")
		cRotinaAtu := "MATA415"
		cCodCliente := M->CJ_CLIENTE
		cLojaCliente := M->CJ_LOJA
		cCondPag := M->CJ_CONDPAG
    Otherwise
		cRotinaAtu := "MATA410"
		cCodCliente := M->C5_CLIENTE
		cLojaCliente := M->C5_LOJACLI
		cCondPag := M->C5_CONDPAG
EndCase

Return Nil
