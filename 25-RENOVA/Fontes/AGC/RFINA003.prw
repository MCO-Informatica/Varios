// Liquidação + Reliquidação = simultâneo
// Utilizar o PE FA565OWN para ignorar o filtro padrão e utilizar seleção de títulos conforme necessário
// Não irá considerar ainda nessa rotina a transferência de títulos por assunção de dívida
// Nessa etapa, o limite já não é mais de R$ 2000 na parcela de pagamento e sim um valor pré-definido e cadastrado
// no cadastro do Fornecedor 


#INCLUDE 'TOTVS.CH' 
#Include "rwmake.ch"
#Include 'FWMVCDef.ch'

/*======================================================================================================
= Rotina para liquidação/reliquidação automática de título seguindo um filtro pré-definido para seleção 
= dos títulos a pagar.
= Liquidação/Reliquidação por Filial gerando o título na própria filial
= Filtros: Filial + Fornecedor + Classe (3) + Natureza agrupadora e gerar 
= Autor: Luiz M Suguiura
*///====================================================================================================

// COM De-Para de Fornecedor
// COM Controle de Representante / Representado

user function RFINA003()

// Campos do Filtro Padrão
//Local cFornDe    := "000000"        
//Local cLojaDe    := "01"
//Local cFornAte   := "000000"
//Local cLojaAte   := "01" 
//Local cForn565   := "000000"
//Local cLoja      := "01"
//Local nValorMax  := 0 
//Local nValorDe   := 0
//Local nValorAte  := 9999999999.99
//Local cMoeda565  := "1"                 // Moeda      : 1=Real - 2=Dolar - 3=UFIR - 4=Euro - 5-Yene
//Local cOutrMoed  := "1"                 // Outra Moeda: 1=Converte - 2=Nao considera
//Local cIntervalo := "1"                 // Intervalo  : 1=Emissão - 2=Vencimento
//Local dData565I  := CtoD("01/01/2000")
//Local dData565F  := CtoD("31/12/2050")
//Local cPrefDe    := ""                  // Obs: Para Liquidação é qualquer - Para Reliquidação é "PRJ"
//Local cPrefAte   := "ZZZ"
//Local cNumDe     := ""
//Local cNumAte    := "ZZZZZZZZZ"

// Campos para Filtro Adicional
//Local cClasse    := "3"
//Local cNatIni    := ""                  // Obs: Existe tabela De-Para de Natureza = Range não pode ser utilizado
//Local cNatFin    := "ZZZZ"              // Criar agrupador no Título ou na Natureza que pode ser a Natureza Destino


Local cUnidadeNeg  := SubStr(cFilAnt,4,2)          // Unidade de Negócio da Filial Logada

Private cFilialAtual := cFilAnt                          // Filial Logada
// Plano de acordo com a Unidade de Negócio 
// Se Unidade de Negócio = '03' ou empresa '1330001' ==> Fase A (Diamantina)
// Todas as outras serão Fase B (Renova)
Private lFaseB := cUnidadeNegocio <> "03" .and. cFilAnt <> "1330001"    

// Variáveis para as arrays de entrada
Private aGetAut1  := {}                   // Array para tela de Get dos Parâmetros
Private aChvAut   := {}                   // Array não utilizada mas precisa enviar vazio
Private aGetAut2  := {}                   // Array para o cabeçalho dos títulos a serem gerados
Private aColItens := {}                   // Array para o aCols dos títulos a serem gerados                  
Private aItens    := {}                   // Array de trabalho para criar o aCols dos titulos a gerar
Private aEdit	   := {}                   // Array para alterar valores

Private lAutomato := .F.                  

Private dDataIni := CtoD("01/01/2000")        // Datas inicial e final pode deixar em aberto
Private dDataFin := CtoD("31/12/2050")        // A definição do título a usar será pelos outros campos

Private cQuery    := ""
Private cAliasSE2 := "" 

Private cMsg := ""

Public cNatAuto := "" 
Public cRotFina := "003"
Public  cOpc  := ""

Private cOpcao:= Space(15)
Private lErroForn := .F.
Private cFornChoice := space(6)
Private cLojaChoice := space(2)
private dDataVenc1  := ctod("  /  /    ")
private dDataVenc2  := ctod("  /  /    ")

// Variável para indicar erro na execução - deve ser declarada com escopo Private
Private lMsErroAuto := .F.

// Nas opções, por ora resta apenas opção de Essencial e Não Essencial
RFA3_OPCAO()

// cOpc
// "E"=Credores Essenciais / "N"=Credores Não Essenciais     ==> nas Querys utilizar '="S"' para Essencial e '<>"S"' para Resto
if cOpc = "X"
   Alert("Excecução Cancelada")
   Return()
endif 

cMsg := "Você escolheu processar os títulos tipo:"+chr(10)+chr(13)
cMsg += cOpcao

if !MsgYesNo(cMsg, "Confirmação")
   Alert("Excecução Cancelada")
   Return()
endif

// Início da montagem da Query

cQuery := "SELECT DISTINCT E2_FILIAL, A2_XFORDES, A2_XLOJDES, E2_XFORREP, E2_XLOJREP, E2_NATUREZ, E2_XESSENC FROM SE2000 "  
// 22/04/2021 - Implementação FORN PARA - 15/06/2021 - Implementação FORN REPRESENTADO
cQuery += " INNER JOIN SA2000 ON E2_FORNECE = A2_COD AND E2_LOJA = A2_LOJA "
// Titulos de Quirografários e com flag de RJ 
cQuery += "WHERE E2_XCLASS = '3' AND E2_XRJ = 'S' "
// Títulos resultado de liquidação anterior - HFINA002 ou Manual repeitando regra de geração
cQuery += "AND E2_PREFIXO = 'PRJ' AND E2_NUMLIQ <> '' "
// Garantia que é a Parcela Saldo
cQuery += "AND E2_NUM LIKE '______002' "
// Da mesma filial posicionada
cQuery += "AND E2_FILIAL = '"+cFilialAtual+"' "
// Saldo diferente de 0
cQuery += "AND E2_SALDO <> 0 "        
// Título não excluido
cQuery += "AND SE2000.D_E_L_E_T_ = '' "
// Ignora registro do SE2 se Filial deletada ou Filial não existir em SYS_COMPANY
cQuery += "AND (SELECT SYS_COMPANY.D_E_L_E_T_ FROM SYS_COMPANY WHERE M0_CODFIL = E2_FILIAL) = '' "
// Ignora registro do SE2 se Fornecedor bloqueado ou não existir
cQuery += "AND (SELECT A2_MSBLQL FROM SA2000 WHERE A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA AND SA2000.D_E_L_E_T_ = '') <> '1' "
// Ignora títulos PA e NDF
cQuery += "AND E2_TIPO <> 'PA' AND E2_TIPO <> 'NDF' "
// Ignorar o Fornecedor "UNIAO"
cQuery += "AND NOT (E2_FORNECE IN "+FormatIn("UNIAO","|")+") "

// Classe do Credor - Essencial ou Não
if cOpc = "E"
   cQuery += " AND E2_XESSENC = 'S' "   // Se Credor Essencial
else
   cQuery += " AND E2_XESSENC <> 'S' "  // Se Não Essencial
endif

// Ordenação
cQuery += " ORDER BY A2_XFORDES, E2_NATUREZ"

// Final da montagem da Query

cAliasSE2 := "TRB003"
cQuery := ChangeQuery(cQuery) 
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasSE2,.F.,.T.)

dbSelectArea("TRB003")
dbGoTop()

ncontador:=0

while !eof()                        // E2_FORNECE   E2_FILIAL     E2_XESSENC
   ncontador := ncontador + 1
   Dbskip()
enddo

if nContador = 0
    Alert("Atenção: Não existem títulos para os parâmetros informados")
    dbCloseArea("TRB003")
    return
endif

ApMsgInfo("Total de Registro a Processar: "+Alltrim(str(ncontador)),"Informação")

ApMsgInfo("Irá iniciar processamento", "Aviso")

dbgotop()

Processa( {|| RFA3_PROC(nContador) }, "Aguarde...", "Processando liquidações...",.F.)

if lErroForn
    Alert("Finalizado devido a erro em Cadastro de Fornecedor!")
endif

if !lMsErroAuto
   ApMsgInfo("Processamento finalizado","Informação")
endif

dbCloseArea("TRB003")

Return()


//-------------------------
// Bloco de processamento 
Static Function RFA3_PROC(nTotReg)

Local nValLimite   := 0
Local nValJaPago   := 0
Local nValorPagar  := 0
Local nValorSaldo  := 0
Local nValTitulos  := 0
Local nSaldoForn   := 0
Local cLiquid      := ""
Local cNumTitPagar := ""
Local cNumTitSaldo := ""
Local dDataRealSld := CtoD("01/07/2021")
Local lMostra      := .T.
Local nEnrola      := 0
Local nProcessado  := 0
Local cChaveForn   := ""

// Variáveis para mostrar diálogo durante execução
Local  oSayProc
Local  oMsgProc
Local  oDlgProc

Define Font o_Fn10 Name "Verdana" Size 0,10
Define Font o_Fn11 Name "Verdana" Size 0,11
Define Font o_Fn12 Name "Verdana" Size 0,12
Define Font o_Fn13 Name "Verdana" Size 0,13
Define Font o_Fn14 Name "Verdana" Size 0,14
Define Font o_Fb14 Name "Verdana" Size 0,14 Bold

Private cLojaForn    := ""

ProcRegua(nTotReg) 

while !EOF()

    if !Empty(AllTrim(cFornChoice)) .and. cFornChoice <> TRB003->A2_XFORDES
        dbSelectArea("TRB003")
        DBSkip()
        Loop
    endif

    // Verificar quanto em R$ já foi gerado de parcela a pagar para o Fornecedor atual
    // Se for fornecedor representante irá utilizar o limite do representado
    if !Empty(AllTrim(TRB003->E2_XFORREP))    
       cChaveForn := TRB003->E2_XFORREP + TRB003->E2_XLOJREP
    else
       cChaveForn := TRB003->A2_XFORDES + TRB003->A2_XLOJDES
    endif

    DBSelectArea("SA2")    // A verificação da validade do fornecedor pode ser mantida para evitar eventuais erros no cadastro 
    DbSetOrder(1)          // Campos A2_XFORDES/A2_XLOJDES ou E2_XFORREP/E2_XLOJREP
    if !DBSeek(xFilial("SA2")+cChaveForn)       
        cMsg := "Atenção: Erro ao acessar Fornecedor "+substr(cChaveForn,1,6)+"/"+substr(cChaveForn,7,2)+"."+chr(13)+chr(10)
        MessageBox(cMsg, "Fornecedor não localizado - Limite para Pagamento", 16)
        lErroForn := .T.
        dbCloseArea("TRB003")
        return
    endif
    DBSeek(xFilial("SA2")+cChaveForn)
    if lFaseB
       nValLimite  := SA2->A2_XLIMPRB
       nValJaPago  := SA2->A2_XACPRJB
    else
       nValLimite  := SA2->A2_XLIMPRA
       nValJaPago  := SA2->A2_XACPRJA
    endif 

    // Valor em títulos desse Fornecedor para a Natureza destino atual
    nValTitulos := RFA3_Valor(cOpc)

    // Montagem das Arrays para o ExecAuto

// Array de desvio de tela - Filtro para a Query
// Adicionalmente a esse Filtro incluirá o retorno do PE FA565FIL
    aGetAut1 := {}
//  aAdd(aGetAut1, {'cFornDe'   , TRB003->E2_FORNECE}) 
    aAdd(aGetAut1, {'cFornDe'   , '      '}) 
    aAdd(aGetAut1, {'cLojaDe'   , '  '    }) 
//    aAdd(aGetAut1, {'cFornAte'  , TRB003->E2_FORNECE})     
    aAdd(aGetAut1, {'cFornAte'  , 'ZZZZZZ'})    
    aAdd(aGetAut1, {'cLojaAte'  , 'ZZ'              })     
//  aAdd(aGetAut1, {'cForn565'  , TRB003->E2_FORNECE}) 
//  aAdd(aGetAut1, {'cLoja'     , cLojaForn   })
    aAdd(aGetAut1, {'cForn565'  , TRB003->A2_XFORDES}) 
    aAdd(aGetAut1, {'cLoja'     , TRB003->A2_XLOJDES}) 
    aAdd(aGetAut1, {'nValorMax' , 0.00        }) 
    aAdd(aGetAut1, {'nValorDe'  , 0.00        }) 
    aAdd(aGetAut1, {'nValorAte' , 999999999999}) 
    aAdd(aGetAut1, {'cMoeda565' , '1'         }) 
    aAdd(aGetAut1, {'cOutrMoed' , '1'         }) 
    aAdd(aGetAut1, {'cIntervalo', '1'         }) 
    aAdd(aGetAut1, {'dData565I' , dDataIni    }) 
    aAdd(aGetAut1, {'dData565F' , dDataFin    }) 
    aAdd(aGetAut1, {'cPrefDe'   , ''          }) 
    aAdd(aGetAut1, {'cPrefAte'  , 'ZZZ'       }) 
    aAdd(aGetAut1, {'cNumDe'    , ''          }) 
    aAdd(aGetAut1, {'cNumAte'   , 'ZZZZZZZZZ' }) 

    cNatAuto := TRB003->E2_NATUREZ

// Cabeçalho da Tela dos títulos de destino
    aGetAut2 := {}
//  aAdd(aGetAut2, {'cFornece' , TRB003->E2_FORNECE})       // Mesmo Fornecedor destino do Filtro
    aAdd(aGetAut2, {'cFornece' , TRB003->A2_XFORDES})
//  aAdd(aGetAut2, {'cLoja'    , cLojaForn })               // Mesma Loja destino do Filtro
    aAdd(aGetAut2, {'cLoja'    , TRB003->A2_XLOJDES})
    aAdd(aGetAut2, {'cCondicao', ''        })               // Condicao de Pagamento (Opcional) - DEPENDE DE DEFINIÇÃO
    aAdd(aGetAut2, {'cTipo'    , 'LIQ'     })               // Tipo
    aAdd(aGetAut2, {'cNatureza', cNatAuto  })               // Natureza - utilizar a natureza destino do De-Para
    aAdd(aGetAut2, {'NTXLIQ'   , 0         })               // TX Moeda (opcional - sempre zero)

// Número da Liquidação atual na Filial posicionada
    cLiquid	:= Soma1(GetMv("MV_NUMLIQP"),6)
    While !MayIUseCode( "E2_NUMLIQP"+xFilial("SE2")+cLiquid )   //verifica se esta na memoria, sendo usado
    	cLiquid := Soma1(cLiquid)                               // busca o proximo numero disponivel
    EndDo
 
    nValorPagar := 0
    nValorSaldo := 0
    nSaldoForn  := 0
    if nValJaPago = nValLimite
        nValorPagar := 0
        nValorSaldo := nValTitulos
    else
        nSaldoForn := nValLimite - nValJaPago
        if nValTitulos <= nSaldoForn
            nValorPagar := nValTitulos
            nValorSaldo := 0
        else
            if nValTitulos > nSaldoForn
               nValorPagar := nSaldoForn
               nValorSaldo := nValTitulos - nValorPagar
            endif 
        endif
    endif

    cNumTitPagar := cLiquid+"003"
    cNumTitSaldo := cLiquid+"004"
    cDataRealSld := CtoD("31/07/2021")

//  Como nessa Fase serão gerados dois títulos - a Pagar e Saldo, a array terá somente um ou dois elementos 

//  Montagem da Array da Parcela a Pagar
    aColItens :={}
    aItens :={}    
    if nValorPagar > 0
        AADD(aItens, {'E2_PREFIXO', 'PRJ'       })   // Prefixo
        AADD(aItens, {'E2_TIPO'   , 'LIQ'       })   // Tipo        
        AADD(aItens, {'E2_BCOCHQ' , '999'       })   // Banco
        AADD(aItens, {'E2_AGECHQ' , '9999'      })   // Agencia
        AADD(aItens, {'E2_CTACHQ' , '99999'     })   // Conta
        AADD(aItens, {'E2_NUM'    , cNumTitPagar})   // Num Título = cLiquid + Sequencial a partir de 001
        AADD(aItens, {'E2_VENCTO' , dDataVenc1  })   // Data da liquidação = digitado na janela de opções
        AADD(aItens, {'E2_VLCRUZ' , nValorPagar })   // Valor da Parcela a Pagar
        AADD(aItens, {'E2_ACRESC' , 0           })   // Acrescimo
        AADD(aItens, {'E2_DECRESC', 0           })   // Decrescimo
        AADD(aItens, {'E2_XCLASS' , '3'         })   // Dos títulos originais - contido no filtro tbm
        AADD(aItens, {'E2_XRJ'    , 'S'         })   // Flag de RJ
        AADD(aItens, {'E2_VENCREA', dDataVenc1  })   // Vencimento real da parcela = digitado na janela de opções

        AADD(aColItens, ACLONE(aItens))             // Adicionar o item no aCols
    endif

//  Montagem da Array da Parcela de Saldo
    aItens := {}
    if nValorSaldo > 0
        AADD(aItens, {'E2_PREFIXO', 'PRJ'       })   // Prefixo
        AADD(aItens, {'E2_TIPO'   , 'LIQ'       })   // Tipo
        AADD(aItens, {'E2_BCOCHQ' , '999'       })   // Banco
        AADD(aItens, {'E2_AGECHQ' , '9999'      })   // Agencia
        AADD(aItens, {'E2_CTACHQ' , '99999'     })   // Conta
        AADD(aItens, {'E2_NUM'    , cNumTitSaldo})   // Num Título = cLiquid + Sequencial a partir de 001
        AADD(aItens, {'E2_VENCTO' , dDataVenc1  })   // Data da liquidação = da parcela de pagamento = digitado na janela de opções
        AADD(aItens, {'E2_VLCRUZ' , nValorSaldo })   // Valor da Parcela de Saldo
        AADD(aItens, {'E2_ACRESC' , 0           })   // Acrescimo
        AADD(aItens, {'E2_DECRESC', 0           })   // Decrescimo
        AADD(aItens, {'E2_XCLASS' , '3'         })   // Dos títulos originais - contido no filtro tbm
        AADD(aItens, {'E2_XRJ'    , 'S'         })   // Flag de RJ
        AADD(aItens, {'E2_VENCREA', dDataVenc2  })   // Vencimento real da parcela - digitado na janela de opções

        AADD(aColItens, ACLONE(aItens))             // Adicionar o item no aCols
    endif

// Array que controla edição dos títulos a serem liquidados - Não Gerar
      aEdit := {}
//    AAdd( aEdit, {'Editar', .T. } ) //- Se necessario Editar Valores
//    aAdd( aEdit, { {'chave'   ,'E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA'},;
//                   {'nCotMoed', 3},;
//                   {'nValJur' , 0},;
//                   {'nValDes' , 0},;
//                   {'nValLiq' , 6005} } )
     

    if nProcessado = nTotReg - 1
       ApMsgInfo("Irá processar o penúltimo fornecedor: "+TRB003->A2_XFORDES, "Aviso")
    else
       if nProcessado = nTotReg
          ApMsgInfo("Irá processar o último fornecedor: "+TRB003->A2_XFORDES, "Aviso")
       endif
    endif

    nPosArotina := 3    // Reliquidação
    lMsErroAuto := .F.
    MSEXECAUTO( { |a, b, c, d, e, f, g| FINA565( a, b, c, d, e, f, g )}, nPosArotina, aGetAut1, Nil, aGetAut2, aColItens, aEdit, .T. )

    If lMsErroAuto    
        MostraErro()
        cMsg := "Executado com erro - Fornecedor: "+TRB003->A2_XFORDES+chr(13)+chr(10)
        if !Empty(AllTrim(TRB003->E2_XFORREP))
           cMsg += "Representante do Fornecedor "+TRB003->E2_XFORREP+chr(13)+chr(10)+chr(13)+chr(10)
        else 
           cMsg += chr(13)+chr(10)
        endif
        cMsg += "O processamento não será interrompido."+chr(13)+chr(10)
        cMsg += "Corrija o problema nos títulos do fornecedor informado e "+chr(13)+chr(10)
        cMsg += "processe novamente após a finalização normal."
        MessageBox(cMsg, "Erro na liquidação de título", 16)
    else
        dbSelectArea("SA2")
        dbSetOrder(1)
        DBSeek(xFilial("SA2")+cChaveForn)
        reclock("SA2",.F.)
        if lFaseB
           A2_XACPRJB := A2_XACPRJB + nValorPagar
        else
           A2_XACPRJA := A2_XACPRJA + nValorPagar
        endif
        MsUnlock()
        if lMostra 
           ApMsgInfo("Processado Fornecedor "+TRB003->A2_XFORDES+"/"+TRB003->A2_XLOJDES+" com sucesso.", "Aviso") 
           lMostra := MsgYesNo("Continua mostrando essa mensagem?", "Confirma mostrar mensagem")
        endif
    endif

    nProcessado := nProcessado + 1
    IncProc("Processado " + cValToChar(nProcessado) + " de " + cValToChar(nTotReg) + ". . .")

    dbSelectArea("TRB003")
    dbSkip()

enddo

Return


// Função para o usuário escolher o tipo de credor a liquidar, informar as datas de vencimento das parcelas 
// para pagamento e saldo e fornecedor (opcional - se em branco, todos)
Static Function RFA3_OPCAO()

Local  aOpcoes := {"1=Credores Essenciais","2=Credores Não Essenciais"}
LOcal  oSay
Local  oButton1
Local  oButton2
Local  lCancelado := .F.
Local  oDataVenc1
Local  oDataVenc2
Local  oFornChoice   
Local  oLojaChoice
Static oDlg

Define Font o_Fn10 Name "Verdana" Size 0,10
Define Font o_Fn11 Name "Verdana" Size 0,11
Define Font o_Fn12 Name "Verdana" Size 0,12
Define Font o_Fn13 Name "Verdana" Size 0,13
Define Font o_Fn14 Name "Verdana" Size 0,14
Define Font o_Fb14 Name "Verdana" Size 0,14 Bold

DEFINE MSDIALOG oDlg TITLE "Rotina de Reliquidação Automática" FROM 000, 000  TO 400, 300 COLORS 0, 16777200 PIXEL

   @ 005, 011 Say oSay Prompt "Essa rotina irá gerar reliquidação automática de títulos" Size 200,010 Of oDlg Pixel Color CLR_BLACK  
   @ 015, 011 Say oSay Prompt "       de acordo com as opções preenchidas abaixo     " Size 200,010 Of oDlg Pixel Color CLR_BLACK
   @ 040, 015 SAY oSay PROMPT "Escolha a Prioridade dos Títulos Origem a liquidar:" SIZE 200, 015 OF oDlg COLORS 0, 16777215 PIXEL
   @ 050, 033 MSCOMBOBOX oComboClas VAR cOpcao ITEMS aOpcoes SIZE 080, 010 OF oDlg COLORS 0, 16777215 PIXEL
   @ 070, 009 SAY oSay PROMPT "Informe data para vencimento da parcela de Pagamento:" SIZE 200, 010 OF oDlg COLORS 0, 16777215 PIXEL    
   @ 080, 047 MsGet oDataVenc1 Var dDataVenc1 Size 050,005 Of oDlg Pixel Color CLR_BLACK Picture "@E"
   @ 100, 015 SAY oSay PROMPT "Informe data para vencimento da parcela de Saldo:" SIZE 200, 010 OF oDlg COLORS 0, 16777215 PIXEL    
   @ 110, 047 MsGet oDataVenc2 Var dDataVenc2 Size 050,005 Of oDlg Pixel Color CLR_BLACK Picture "@E"
   @ 125, 000 SAY oSay PROMPT "===========================================================" SIZE 200, 010 OF oDlg PIXEL
   @ 135, 005 SAY oSay PROMPT "Informe código de um fornecedor ou em branco para todos:" SIZE 200, 010 OF oDlg COLORS 0, 16777215 PIXEL    
   @ 145, 002 SAY oSay PROMPT "Atenção: Se informar, deve ser o código do 'Fornecedor Para'" SIZE 200, 010 OF oDlg PIXEL Color CLR_RED
   @ 160, 059 MsGet oFornChoice Var cFornChoice Size 010,005 Of oDlg Pixel Color CLR_BLACK F3 "SA2"
//   @ 140, 060 MsGet oLojaChoice Var cLojaChoice Size 010,005 Of oDlg Pixel Color CLR_BLACK

   oButton1:= TButton():New(180,020, "OK",oDlg,{||iif(u_RFA3_VALID(),oDlg:End(),lCancelado:=.F.)}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
   oButton2:= TButton():New(180,090, "Cancela",oDlg,{||lCancelado:= .T.,oDlg:End()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )

ACTIVATE MSDIALOG oDlg CENTERED

cOpc := substr(cOpcao,1,1)

if lCancelado
   cOpc := "X"
else 
    do case
       case cOpc = "1"
            cOpc   := "E"
            cOpcao := "Credores Essenciais"
       case cOpc = "2"
            cOpc   := "N"
            cOpcao := "Credores Não Essenciais"
    EndCase
endif

return ()


// Validar os parametros informados na tela inicial  => VERIFICAR ESSA VALIDAÇÃO
User Function RFA3_VALID()   // ====> VERIFICAR - UM FORNECEDOR ESCOLHIDO / CADASTRO DE FORNECEDORES - XFORDES (?)

Local lRet := .T.

if empty(dtos(dDataVenc1)) .or. dtos(dDataVenc1) < dtos(dDataBase)
   alert("Data de Vencimento da parcela de Pagamento inválida!")
   return(.F.)
endif

if empty(dtos(dDatavenc2)) .or. dtos(dDataVenc1) > dtos(dDataVenc2)
   alert("Data de Vencimento da parcela de Saldo inválida!")
   return(.F.)
endif   

if !empty(cFornChoice)
   cLojaChoice := RFA3_Fornece(cFornChoice)
   dbSelectArea("SA2")
   dbSetOrder(1)
   if !dbSeek(xFilial("SA2")+cFornChoice+cLojaChoice)
      lRet := .F.
      Alert("Atenção: Fornecedor inválido!")
   endif
endif

Return(lRet)


// Função para retornar a loja destino do forncedor - criado para manter padrão
// Alterado em 27/04/2021 para passar validar o campo A2_XLOJDES - Loja destino do De-Para 
Static Function RFA3_Fornece(cCodFor)

Local aArea   := GetArea()
Local cRetFor := ""
Local nConta  := 0

cQuery := "SELECT A2_COD, A2_LOJA, A2_XFORDES, A2_XLOJDES FROM SA2000 "
cQuery += "WHERE A2_XFORDES = '"+cCodFor+"' AND SA2000.D_E_L_E_T_ = '' AND A2_MSBLQL <> '1' "
cQuery += "ORDER BY A2_XFORDES"

cAliasSA2 := "FOR001"
cQuery := ChangeQuery(cQuery) 
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasSA2,.F.,.T.)

dbSelectArea("FOR001")
dbGoTop()

while !eof()
   if nConta = 0
      cRetFor := A2_XLOJDES
   else
      if A2_XLOJDES <> cRetFor
         Alert("Atenção: Esse 'Fornecedor Para' foi informado com Lojas diferentes em alguns registros - Verifique!")
         Alert("Todos os Fornecedores deverão apontar para a mesma dupla 'Fornecedor/Loja' de destino.")
         cRetFor := "**"
         exit
      endif
   endif
   nConta := nConta + 1
   Dbskip()
enddo

if nConta = 0
   Alert("Atenção: Não existem fornecedores parametrizados com esse 'Fornecedor Para' informado!")
   cRetFor := "**" 
endif

dbCloseArea("FOR001")

RestArea(aArea)

return(cRetFor)



// Função para somar todos os títulos do fornecedor atual selecionado em TRB003
Static Function RFA3_Valor(cOpc)

Local cAliasVAL := "VAL"
Local cQuery    := ""
Local nContador := 0
Local nValTotal := 0

// Início da montagem da Query

cQuery := "SELECT E2_FORNECE, E2_LOJA, E2_FILIAL, E2_NATUREZ, E2_SALDO, E2_ACRESC, E2_DECRESC FROM SE2000 "
// Titulos de Quirografários e com flag de RJ 
cQuery += "WHERE E2_XCLASS = '3' AND E2_XRJ = 'S' "
// Títulos resultado de liquidação anterior - HFINA002 ou Manual repeitando regra de geração
cQuery += "AND E2_PREFIXO = 'PRJ' AND E2_NUMLIQ <> '' 
// Garantia que é a Parcela Saldo
cQuery += "AND E2_NUM LIKE '______002' "
// Da mesma filial posicionada
cQuery += "AND E2_FILIAL = '"+cFilialAtual+"' "
// Saldo diferente de 0
cQuery += "AND E2_SALDO <> 0 "        
// Título não excluido
cQuery += "AND SE2000.D_E_L_E_T_ = '' "
// Ignora registro do SE2 se Filial deletada ou Filial não existir em SYS_COMPANY
cQuery += "AND (SELECT SYS_COMPANY.D_E_L_E_T_ FROM SYS_COMPANY WHERE M0_CODFIL = E2_FILIAL) = '' "
// Ignora registro do SE2 se Fornecedor bloqueado ou não existir
cQuery += "AND (SELECT A2_MSBLQL FROM SA2000 WHERE A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA AND SA2000.D_E_L_E_T_ = '') <> '1' "
// Ignora títulos PA e NDF
cQuery += "AND E2_TIPO <> 'PA' AND E2_TIPO <> 'NDF' "
// Ignorar o Fornecedor "UNIAO"
cQuery += "AND NOT (E2_FORNECE IN "+FormatIn("UNIAO","|")+") "

// Classe do Credor - Essencial ou Não
if cOpc = "E"
   cQuery += " AND E2_XESSENC = 'S' "   // Se Credor Essencial
else
   cQuery += " AND E2_XESSENC <> 'S' "  // Se Não Essencial
endif

// Natureza do titulo igual natureza do registro do TRB003 em execução
cQuery += "AND E2_NATUREZ = '"+TRB003->E2_NATUREZ+"' "

// Fornecedor destino título igual fornecedor do registro do TRB003 em execução - implementado em 27/04/2021
cQuery += "AND (SELECT A2_XFORDES FROM SA2000 WHERE A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA AND SA2000.D_E_L_E_T_ = '') = '"+TRB003->A2_XFORDES+"' "
cQuery += "AND (SELECT A2_XLOJDES FROM SA2000 WHERE A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA AND SA2000.D_E_L_E_T_ = '') = '"+TRB003->A2_XLOJDES+"' "

// Filtrar o Fornecedor Representado selecionado no registro do TRB003 em execução - implementado em 15/06/2021
cQuery += "AND E2_XFORREP = '"+TRB003->E2_XFORREP+"' AND E2_XLOJREP = '"+TRB003->E2_XLOJREP+"' "

// Ordenação
cQuery += " ORDER BY E2_FORNECE"

// Final da montagem da Query


cAliasVAL := "VAL"
cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasVAL,.F.,.T.)

dbSelectArea(cAliasVAL)
dbGoTop()

nContador := 0
nValTotal := 0

while !eof()
   nContador := nContador + 1
   nValTotal := nValTotal + (VAL->E2_SALDO + VAL->E2_ACRESC - VAL->E2_DECRESC)
   Dbskip()
enddo

dbgotop()

dbCloseArea("VAL")
 
Return(nValTotal)


