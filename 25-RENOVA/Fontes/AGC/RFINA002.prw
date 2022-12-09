//- Filtro de empresas
//  Par�metro ou lista de filiais para incluir no filtro
//
//- Se for somente t�tulos de TUST para centraliza��o em Diamantina
//  necessitar� identificar tais t�tulos para essa finalidade
//
//- Rotina de corre��o autom�tica para as Classes dever�o estar prontas
//  de acordo com as suas regras 
//
//- Rotina para primeira liquida��o ter� um padr�o de 2 mil para todos
//  na primeira parcela
//
//- Fernando fala que a cada momento ir� fazer uma liquida��o apenas e
//  liquida��o / reliquida��o direta ou liquida��o / reliquida��o / reliquida��o...
// 
// Processo:


#INCLUDE 'TOTVS.CH' 
#Include "rwmake.ch"
#Include 'FWMVCDef.ch'

/*======================================================================================================
= Rotina para liquida��o autom�tica de t�tulo seguindo um filtro pr�-definido para sele��o 
= dos t�tulos a pagar.
= Nessa rotina ser� feita a primeira liquida��o para o pagamento a ser efetuado em Abril conforme 
= alinhamento com Wellington em 25/02
= Liquida��o por Filial gerando o t�tulo na pr�pria filial
= Filtros: Filial + Fornecedor + Classe (3) + Natureza agrupadora e gerar 
= Autor: Luiz M Suguiura
*///====================================================================================================

user function RFINA002()

// Campos do Filtro Padr�o
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
//Local cIntervalo := "1"                 // Intervalo  : 1=Emiss�o - 2=Vencimento
//Local dData565I  := CtoD("01/01/2000")
//Local dData565F  := CtoD("31/12/2050")
//Local cPrefDe    := ""                  // Obs: Para Liquida��o � qualquer - Para Reliquida��o � "PRJ"
//Local cPrefAte   := "ZZZ"
//Local cNumDe     := ""
//Local cNumAte    := "ZZZZZZZZZ"

// Campos para Filtro Adicional
//Local cClasse    := "3"
//Local cNatIni    := ""                  // Obs: Existe tabela De-Para de Natureza = Range n�o pode ser utilizado
//Local cNatFin    := "ZZZZ"              // Criar agrupador no T�tulo ou na Natureza que pode ser a Natureza Destino

//Local cFilIni    := "0000000"           // Obs: Se puder agrupar para Renova e Diamantina definir de quais empresas 
//Local cFilFin    := "0000000"           // para cada uma delas - do contr�rio, range dentro da pr�pria empresa

// Vari�veis para as arrays de entrada
Private aGetAut1  := {}                   // Array para tela de Get dos Par�metros
Private aChvAut   := {}                   // Array n�o utilizada mas precisa enviar vazio
Private aGetAut2  := {}                   // Array para o cabe�alho dos t�tulos a serem gerados
Private aColItens := {}                   // Array para o aCols dos t�tulos a serem gerados                  
Private aEdit		  := {}                   // Array para alterar valores
Private lAutomato	:= .F.
Private aItens    := {}                   // Array de trabalho para criar o aCols dos titulos a gerar

Private dDataIni := CtoD("01/01/2000")        // Datas inicial e final pode deixar em aberto
Private dDataFin := CtoD("31/12/2050")        // A defini��o do t�tulo a usar ser� pelos outros campos

Private cQuery    := ""
Private cAliasSE2 := "" 

Private cMsg := ""

Public cNatAuto := "" 
Public cRotFina := "002"
Public lEssenc  := .F.

Public  cOpc  := ""
Private cOpcao:= Space(15)
Private lErroForn := .F.
Private cFornChoice := space(6)
Private cLojaChoice := space(2)
private dDataVenc1  := ctod("  /  /    ")
private dDataVenc2  := ctod("  /  /    ")

// Vari�vel para indicar erro na execu��o - deve ser declarada com escopo Private
Private lMsErroAuto := .F.

RFA2_OPCAO()

// cOpc
// "A"=Arrentamento / "T"=TUST / "O"=Outros
if cOpc = "X"
   Alert("Excecu��o Cancelada")
   Return()
endif

cMsg := "Voc� escolheu processar os t�tulos tipo:"+chr(10)+chr(13)
cMsg += cOpcao+chr(10)+chr(12)
if cOpc = "A"
   if lEssenc
      cMsg += "E marcar esses t�tulos como 'Essenciais'"
   else
      cMsg += "E marcar esses t�tulos como 'N�o Essenciais'"
   endif
endif

if !MsgYesNo(cMsg, "Confirma��o de Execu��o da Rotina ")
   Alert("Excecu��o Cancelada")
   Return()
endif

cFilialAtual := xFilial("SE2")

do case 
    case cOpc = "O"         // Outros
        //cQuery := "SELECT DISTINCT E2_FORNECE, E2_LOJA, E2_FILIAL, ED_XCDPARA " - tirado Loja em 18/03/2021
        cQuery := "SELECT DISTINCT E2_FORNECE, E2_FILIAL, ED_XCDPARA "
        cQuery += "FROM SE2000 INNER JOIN SED000 ON E2_NATUREZ = ED_CODIGO "
        // Se conseguir resolver problema de n�o precisar estar posicionado na filial origem + destino, pode eliminar
        // a condi��o da Filial abaixo
        cQuery += "WHERE E2_XCLASS = '3' AND E2_XRJ = 'S' AND E2_NUMLIQ = '' AND E2_FILIAL = '"+cFilialAtual+"' " 
        cQuery += "AND SED000.D_E_L_E_T_ = '' AND SE2000.D_E_L_E_T_ = '' "
        // Saldo diferente de 0
        cQuery += "AND E2_SALDO <> 0 "        
        // Ignora t�tulos de Arrendamento - Prefixo = "ARR"
        cQuery += "AND NOT (E2_PREFIXO IN "+FormatIn("ARR","|")+") "
        //" and not (E2_TIPO in " + FormatIn(MVPROVIS + "|" + MVPAGANT + "|" + MV_CPNEG,"|") + ")" ***
        // Ignora t�tulos de TUST - Naturezas = "2217, 2203, 2215 e 2335"
        cQuery += "AND NOT (E2_NATUREZ IN "+FormatIn("2217|2203|2215|2335","|")+") "
        // Ignora registro do SE2 se Filial deletada ou Filial n�o existir em SYS_COMPANY
        cQuery += "AND (SELECT SYS_COMPANY.D_E_L_E_T_ FROM SYS_COMPANY WHERE M0_CODFIL = E2_FILIAL) = '' "
        // Ignora registro do SE2 se Fornecedor bloqueado
        cQuery += "AND (SELECT A2_MSBLQL FROM SA2000 WHERE A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA AND SA2000.D_E_L_E_T_ = '') <> '1' "
        // Ignora t�tulos em Bordero
        //cQuery += "AND E2_NUMBOR = '' "               // N�o ignorar mais bordero gerado - 18/03/2021
        cQuery += " AND E2_TIPO <> 'PA' AND E2_TIPO <> 'NDF' "    // Ignora PA e NDF
        // Ignorar o Fornecedor "UNIAO"
        cQuery += "AND NOT (E2_FORNECE IN "+FormatIn("UNIAO","|")+") "
        cQuery += " ORDER BY E2_FORNECE, ED_XCDPARA"
    case cOpc = "A"         // Arrendamentos
        //cQuery := "SELECT DISTINCT E2_FORNECE, E2_LOJA, E2_FILIAL, ED_XCDPARA " - tirado Loja em 18/03/2021
        cQuery := "SELECT DISTINCT E2_FORNECE, E2_FILIAL, ED_XCDPARA "
        cQuery += "FROM SE2000 INNER JOIN SED000 ON E2_NATUREZ = ED_CODIGO "
        // Se conseguir resolver problema de n�o precisar estar posicionado na filial origem + destino, pode eliminar
        // a condi��o da Filial abaixo
        cQuery += "WHERE E2_XCLASS = '3' AND E2_XRJ = 'S' AND E2_NUMLIQ = '' AND E2_FILIAL = '"+cFilialAtual+"' " 
        cQuery += "AND SED000.D_E_L_E_T_ = '' AND SE2000.D_E_L_E_T_ = '' "
        // Saldo diferente de 0
        cQuery += "AND E2_SALDO <> 0 "        
        // Seleciona somente t�tulos de Arrendamento - Prefixo = "ARR"
        cQuery += "AND (E2_PREFIXO IN "+FormatIn("ARR","|")+") "
        //" and not (E2_TIPO in " + FormatIn(MVPROVIS + "|" + MVPAGANT + "|" + MV_CPNEG,"|") + ")" ***
        // Ignora t�tulos de TUST - Naturezas = "2217, 2203, 2215 e 2335"
        cQuery += "AND NOT (E2_NATUREZ IN "+FormatIn("2217|2203|2215|2335","|")+") "
        // Ignora registro do SE2 se Filial deletada ou Filial n�o existir em SYS_COMPANY
        cQuery += "AND (SELECT SYS_COMPANY.D_E_L_E_T_ FROM SYS_COMPANY WHERE M0_CODFIL = E2_FILIAL) = '' "
        // Ignora registro do SE2 se Fornecedor bloqueado
        cQuery += "AND (SELECT A2_MSBLQL FROM SA2000 WHERE A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA AND SA2000.D_E_L_E_T_ = '') <> '1' "
        // Ignora t�tulos em Bordero
        //cQuery += "AND E2_NUMBOR = '' "               // N�o ignorar mais bordero gerado - 18/03/2021
        cQuery += " AND E2_TIPO <> 'PA' AND E2_TIPO <> 'NDF' "    // Ignora PA e NDF
        // Ignorar o Fornecedor "UNIAO"
        cQuery += "AND NOT (E2_FORNECE IN "+FormatIn("UNIAO","|")+") "
        cQuery += " ORDER BY E2_FORNECE, ED_XCDPARA"
    case cOpc = "T"         // TUST
        //cQuery := "SELECT DISTINCT E2_FORNECE, E2_LOJA, E2_FILIAL, ED_XCDPARA " - tirado Loja em 18/03/2021
        cQuery := "SELECT DISTINCT E2_FORNECE, E2_FILIAL, ED_XCDPARA "
        cQuery += "FROM SE2000 INNER JOIN SED000 ON E2_NATUREZ = ED_CODIGO "
        // Se conseguir resolver problema de n�o precisar estar posicionado na filial origem + destino, pode eliminar
        // a condi��o da Filial abaixo
        cQuery += "WHERE E2_XCLASS = '3' AND E2_XRJ = 'S' AND E2_NUMLIQ = '' AND E2_FILIAL = '"+cFilialAtual+"' " 
        cQuery += "AND SED000.D_E_L_E_T_ = '' AND SE2000.D_E_L_E_T_ = '' "
        // Saldo diferente de 0
        cQuery += "AND E2_SALDO <> 0 "        
        // Seleciona somente t�tulos de TUST - Naturezas 2217/2203/2215/2335
        cQuery += "AND NOT (E2_PREFIXO IN "+FormatIn("ARR","|")+") "
        //" and not (E2_TIPO in " + FormatIn(MVPROVIS + "|" + MVPAGANT + "|" + MV_CPNEG,"|") + ")" ***
        cQuery += "AND (E2_NATUREZ IN "+FormatIn("2217|2203|2215|2335","|")+") "
        // Ignora registro do SE2 se Filial deletada ou Filial n�o existir em SYS_COMPANY
        cQuery += "AND (SELECT SYS_COMPANY.D_E_L_E_T_ FROM SYS_COMPANY WHERE M0_CODFIL = E2_FILIAL) = '' "
        // Ignora registro do SE2 se Fornecedor bloqueado
        cQuery += "AND (SELECT A2_MSBLQL FROM SA2000 WHERE A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA AND SA2000.D_E_L_E_T_ = '') <> '1' "
        // Ignora t�tulos em Bordero
        //cQuery += "AND E2_NUMBOR = '' "               // N�o ignorar mais bordero gerado - 18/03/2021
        cQuery += " AND E2_TIPO <> 'PA' AND E2_TIPO <> 'NDF' "    // Ignora PA e NDF
        // Ignorar o Fornecedor "UNIAO"
        cQuery += "AND NOT (E2_FORNECE IN "+FormatIn("UNIAO","|")+") "
        cQuery += " ORDER BY E2_FORNECE, ED_XCDPARA"
endcase

cAliasSE2 := "TRB002"
cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasSE2,.F.,.T.)

// mBrowse( <nLinha1>, <nColuna1>, <nLinha2>, <nColuna2>, <cAlias>, <aFixe>, <cCpo>, <nPar>, 
//          <cCorFun>, <nClickDef>, <aColors>, <cTopFun>, <cBotFun>, <nPar14>, <bInitBloc>, <lNoMnuFilter>, 
//          <lSeeAll>, <lChgAll>, <cExprFilTop>, <nInterval>, <uPar22>, <uPar23> )

dbSelectArea("TRB002")
dbGoTop()

ncontador:=0

while !eof()                        // E2_FORNECE   E2_FILIAL     ED_XCDPARA
   ncontador := ncontador + 1
   Dbskip()
enddo

if nContador = 0
    Alert("Aten��o: N�o existem t�tulos para os par�metros informados")
    dbCloseArea("TRB002")
    return
endif

ApMsgInfo("Total de Registro a Processar: "+Alltrim(str(ncontador)),"Informa��o")

ApMsgInfo("Ir� iniciar processamento", "Aviso")

dbgotop()

//MsgRun("Processando Liquida��o... ","Aguarde",{|| CursorWait(),RFA2_PROC(),CursorArrow()})

Processa( {|| RFA2_PROC(nContador) }, "Aguarde...", "Processando liquida��es...",.F.)

if lErroForn
    Alert("Finalizado devido a erro em Cadastro de Fornecedor!")
endif

if !lMsErroAuto
   ApMsgInfo("Processamento finalizado","Informa��o")
endif

dbCloseArea("TRB002")

Return()


//-------------------------
// Bloco de processamento 
Static Function RFA2_PROC(nTotReg)

//aFixe:={}
//AAdd(aFixe,{"Fornecedor"     ,"E2_FORNECE"    ,"C",6,0,"@!"})
//AAdd(aFixe,{"Loja"           ,"E2_LOJA"       ,"C",2,0,"@!"})
//AAdd(aFixe,{"Filial"         ,"E2_FILIAL"     ,"C",7,0,"@!"})
//AAdd(aFixe,{"Nat Para"       ,"ED_XCDPARA"    ,"C",6,0,"@!"})

//mBrowse( 6, 1, 22, 75, cAliasSE2, aFixe)
//mBrowse(6,1,22,75,cAlias,aCpoBrowser,,,,,aCores,,,,,.F.)

//dbCloseArea("TRB002")

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

// Vari�veis para mostrar di�logo durante execu��o
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

    IncProc() 
    nProcessado := nProcessado + 1

    if !Empty(AllTrim(cFornChoice)) .and. cFornChoice <> TRB002->E2_FORNECE
        dbSelectArea("TRB002")
        DBSkip()
        Loop
    endif

    // Verificar quanto em R$ j� foi gerado de parcela a pagar para o Fornecedor atual
    // Incluido fun��o para encontrar a loja do fornecedor a usar para destino = cLojaForn
    cLojaForn := RFA2_Fornece(TRB002->E2_FORNECE)
    if cLojaForn = "99"
       cMsg := "Aten��o: Eesse fornecedor n�o tem registro v�lido"+TRB002->E2_FORNECE
       MessageBox(cMsg, "Fornecedor Inv�lido", 16)
       lErroForn := .T.
       Return
    endif
    DBSelectArea("SA2")
    DbSetOrder(1)
    if !DBSeek(xFilial("SA2")+TRB002->E2_FORNECE+cLojaForn)
        cMsg := "Aten��o: Erro ao acessar Fornecedor "+TRB002->E2_FORNECE+"/"+cLojaForn
        MessageBox(cMsg, "Fornecedor n�o localizado", 16)
        lErroForn := .T.
        return
    endif
    DBSeek(xFilial("SA2")+TRB002->E2_FORNECE+cLojaForn)
    nValJaPago  := SA2->A2_XACPRJ

    // Valor em t�tulos desse Fornecedor para a Naturez destino atual
    nValTitulos := RFA2_Valor(cOpc)

    // Montagem das Arrays para o ExecAuto

// Array de desvio de tela - Filtro para a Query
// Adicionalmente a esse Filtro incluir� o retorno do PE FA565FIL == ALTERAR para n�o perguntar e usar daqui
    aGetAut1 := {}
    aAdd(aGetAut1, {'cFornDe'   , TRB002->E2_FORNECE}) 
//  aAdd(aGetAut1, {'cLojaDe'   , TRB002->E2_LOJA   })      // N�o enviar loja de e loja para
    aAdd(aGetAut1, {'cLojaDe'   , '  '              })     // do contr�rio n�o funciona o execauto
    aAdd(aGetAut1, {'cFornAte'  , TRB002->E2_FORNECE})     
//  aAdd(aGetAut1, {'cLojaAte'  , TRB002->E2_LOJA   }) 
    aAdd(aGetAut1, {'cLojaAte'  , 'ZZ'              })     
    aAdd(aGetAut1, {'cForn565'  , TRB002->E2_FORNECE}) 
//    aAdd(aGetAut1, {'cLoja'     , TRB002->E2_LOJA   })     // Loja destino conforme a fun��o RFA2_Fornece
    aAdd(aGetAut1, {'cLoja'     , cLojaForn   }) 
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

    cNatAuto := TRB002->ED_XCDPARA

// Cabe�alho da Tela dos t�tulos de destino
    aGetAut2 := {}
    aAdd(aGetAut2, {'cFornece' , TRB002->E2_FORNECE})   // Mesmo Fornecedor destino do Filtro
    aAdd(aGetAut2, {'cLoja'    , cLojaForn })           // Mesma Loja destino do Filtro
    aAdd(aGetAut2, {'cCondicao', ''        })               // Condicao de Pagamento (Opcional) - DEPENDE DE DEFINI��O
    aAdd(aGetAut2, {'cTipo'    , 'LIQ'     })               // Tipo
    aAdd(aGetAut2, {'cNatureza', cNatAuto  })               // Natureza - utilizar a natureza destino do De-Para
    aAdd(aGetAut2, {'NTXLIQ'   , 0         })               // TX Moeda (opcional - sempre zero)

// Montar as arrays para cada Fornecedor + Classe + Agrupador de Natureza

    // N�mero da Liquida��o atual na Filial posicionada
    cLiquid	:= Soma1(GetMv("MV_NUMLIQP"),6)
    While !MayIUseCode( "E2_NUMLIQP"+xFilial("SE2")+cLiquid )   //verifica se esta na memoria, sendo usado
    	cLiquid := Soma1(cLiquid)                               // busca o proximo numero disponivel
    EndDo
 
    nValorPagar := 0
    nValorSaldo := 0
    nSaldoForn  := 0
    if nValJaPago = 2000
        nValorPagar := 0
        nValorSaldo := nValTitulos
    else
        nSaldoForn := 2000 - nValJaPago
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

    cNumTitPagar := cLiquid+"001"
    cNumTitSaldo := cLiquid+"002"
    cDataRealSld := CtoD("31/07/2021")

//  Como nessa Fase ser�o gerados dois t�tulos - a Pagar e Saldo, a array ter� somente um ou dois elementos 

//  Montagem da Array da Parcela a Pagar
    aColItens :={}
    aItens :={}    
    if nValorPagar > 0
        AADD(aItens, {'E2_PREFIXO', 'PRJ'       })   // Prefixo
        AADD(aItens, {'E2_TIPO'   , 'LIQ'       })   // Tipo        
        AADD(aItens, {'E2_BCOCHQ' , '999'       })   // Banco
        AADD(aItens, {'E2_AGECHQ' , '9999'      })   // Agencia
        AADD(aItens, {'E2_CTACHQ' , '99999'     })   // Conta
        AADD(aItens, {'E2_NUM'    , cNumTitPagar})   // Num T�tulo = cLiquid + Sequencial a partir de 001
        AADD(aItens, {'E2_VENCTO' , dDataVenc1  })   // Data da liquida��o = digitado na janela de op��es
        AADD(aItens, {'E2_VLCRUZ' , nValorPagar })   // Valor da Parcela a Pagar
        AADD(aItens, {'E2_ACRESC' , 0           })   // Acrescimo
        AADD(aItens, {'E2_DECRESC', 0           })   // Decrescimo
        AADD(aItens, {'E2_XCLASS' , '3'         })   // Dos t�tulos originais - contido no filtro tbm
        AADD(aItens, {'E2_XRJ'    , 'S'         })   // Flag de RJ
        AADD(aItens, {'E2_VENCREA', dDataVenc1  })   // Vencimento real da parcela = digitado na janela de op��es

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
        AADD(aItens, {'E2_NUM'    , cNumTitSaldo})   // Num T�tulo = cLiquid + Sequencial a partir de 001
        AADD(aItens, {'E2_VENCTO' , dDataVenc1  })   // Data da liquida��o = da parcela de pagamento = digitado na janela de op��es
        AADD(aItens, {'E2_VLCRUZ' , nValorSaldo })   // Valor da Parcela de Saldo
        AADD(aItens, {'E2_ACRESC' , 0           })   // Acrescimo
        AADD(aItens, {'E2_DECRESC', 0           })   // Decrescimo
        AADD(aItens, {'E2_XCLASS' , '3'         })   // Dos t�tulos originais - contido no filtro tbm
        AADD(aItens, {'E2_XRJ'    , 'S'         })   // Flag de RJ
        AADD(aItens, {'E2_VENCREA', dDataVenc2  })   // Vencimento real da parcela - digitado na janela de op��es

        AADD(aColItens, ACLONE(aItens))             // Adicionar o item no aCols
    endif

// Array que controla edi��o dos t�tulos a serem liquidados - N�o Gerar
      aEdit := {}
//    AAdd( aEdit, {'Editar', .T. } ) //- Se necessario Editar Valores
//    aAdd( aEdit, { {'chave'   ,'E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA'},;
//                   {'nCotMoed', 3},;
//                   {'nValJur' , 0},;
//                   {'nValDes' , 0},;
//                   {'nValLiq' , 6005} } )
 
//    if !TRB002->E2_FORNECE = "011007"
//    if !TRB002->E2_FORNECE $ "000100;001490;005672;011007"
//      if !Empty(AllTrim(cFornChoice)) .and. cFornChoice <> TRB002->E2_FORNECE
//        dbSelectArea("TRB002")
//        DBSkip()
//        Loop
//    endif
    
// Chamada da Rotina

    //nEnrola := 0
    //while nEnrola < 20000
    //   nEnrola := nEnrola + 1
    //enddo 
    //Sleep(10000)     // Fazer congelar por 15 segundos

//    if TRB002->E2_FORNECE = "011026"
//       Alert("Aviso: Ir� fazer o fornecedor 011026 - MIRACEMA")
//    endif

    if nProcessado = nTotReg - 1
       ApMsgInfo("Ir� processar o pen�ltimo fornecedor: "+TRB002->E2_FORNECE, "Aviso")
    else
       if nProcessado = nTotReg
          ApMsgInfo("Ir� processar o �ltimo fornecedor: "+TRB002->E2_FORNECE, "Aviso")
       endif
    endif

    nPosArotina := 2
    lMsErroAuto := .F.
    MSEXECAUTO( { |a, b, c, d, e, f, g| FINA565( a, b, c, d, e, f, g )}, nPosArotina, aGetAut1, Nil, aGetAut2, aColItens, aEdit, .T. )

//    if TRB002->E2_FORNECE = "011026"
//       Alert("Aviso: Finaliza��o normal do fornecedor 011026 - MIRACEMA")
//    endif

    If lMsErroAuto    
        MostraErro()
        cMsg := "Executado com erro - Fornecedor: "+TRB002->E2_FORNECE+chr(13)+chr(10)+chr(13)+chr(10)
        cMsg += "O processamento n�o ser� interrompido."+chr(13)+chr(10)
        cMsg += "Corrija o problema nos t�tulos do fornecedor informado e "+chr(13)+chr(10)
        cMsg += "processe novamente ap�s a finaliza��o normal."
        MessageBox(cMsg, "Erro na liquida��o de t�tulo", 16)
//      exit
    else
        dbSelectArea("SA2")
        dbSetOrder(1)
        DBSeek(xFilial("SA2")+TRB002->E2_FORNECE+cLojaForn)
        reclock("SA2",.F.)
        A2_XACPRJ := A2_XACPRJ + nValorPagar
        MsUnlock()
        if lMostra 
           ApMsgInfo("Processado Fornecedor "+TRB002->E2_FORNECE+" com sucesso.", "Aviso") 
           lMostra := MsgYesNo("Continua mostrando essa mensagem?", "Confirma mostrar mensagem")
        endif
    endif

    dbSelectArea("TRB002")
    dbSkip()

enddo

Return


// Fun��o MenuDef para usar no MBrowse
Static Function MenuDef()

Local aRotina := {	{ "Pesquisar"  ,"AxPesqui"    , 0 , 1,,.F. },;	//"Pesquisar"
					{ "Visualizar" ,"AxVisual"    , 0 , 3,,.F. } }  //"Visualizar"


Return(aRotina)




// Fun��o para o usu�rio escolher o tipo de t�tulo a liquidar, informar as datas de vencimento das parcelas 
// para pagamento e saldo e fornecedor (opcional - se em branco, todos)
Static Function RFA2_OPCAO()

Local  aOpcoes := {"1=Arrendamento","2=TUST","3=Outros"}
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

DEFINE MSDIALOG oDlg TITLE "Rotina de Liquida��o Autom�tica" FROM 000, 000  TO 400, 300 COLORS 0, 16777200 PIXEL

   @ 005, 015 Say oSay Prompt "Essa rotina ir� gerar liquida��o autom�tica de t�tulos" Size 200,010 Of oDlg Pixel Color CLR_BLACK  
   @ 015, 015 Say oSay Prompt "       de acordo com as op��es preenchidas abaixo     " Size 200,010 Of oDlg Pixel Color CLR_BLACK
   @ 040, 010 SAY oSay PROMPT "Escolha o Tipo dos T�tulos Origem a liquidar:" SIZE 200, 015 OF oDlg COLORS 0, 16777215 PIXEL
   @ 050, 022 MSCOMBOBOX oComboClas VAR cOpcao ITEMS aOpcoes SIZE 067, 010 OF oDlg COLORS 0, 16777215 PIXEL
   @ 070, 010 SAY oSay PROMPT "Informe data para vencimento da parcela de Pagamento:" SIZE 200, 010 OF oDlg COLORS 0, 16777215 PIXEL    
   @ 080, 022 MsGet oDataVenc1 Var dDataVenc1 Size 050,005 Of oDlg Pixel Color CLR_BLACK Picture "@E"
   @ 100, 010 SAY oSay PROMPT "Informe data para vencimento da parcela de Saldo:" SIZE 200, 010 OF oDlg COLORS 0, 16777215 PIXEL    
   @ 110, 022 MsGet oDataVenc2 Var dDataVenc2 Size 050,005 Of oDlg Pixel Color CLR_BLACK Picture "@E"
   @ 130, 005 SAY oSay PROMPT "Informe c�digo de um fornecedor ou em branco para todos:" SIZE 200, 010 OF oDlg COLORS 0, 16777215 PIXEL    
   @ 140, 022 MsGet oFornChoice Var cFornChoice Size 010,005 Of oDlg Pixel Color CLR_BLACK F3 "SA2"
//   @ 140, 060 MsGet oLojaChoice Var cLojaChoice Size 010,005 Of oDlg Pixel Color CLR_BLACK

   oButton1:= TButton():New(180,020, "OK",oDlg,{||iif(u_RFA2_VALID(),oDlg:End(),lCancelado:=.F.)}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
   oButton2:= TButton():New(180,090, "Cancela",oDlg,{||lCancelado:= .T.,oDlg:End()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )

ACTIVATE MSDIALOG oDlg CENTERED

cOpc := substr(cOpcao,1,1)

if lCancelado
   cOpc := "X"
else 
    do case
       case cOpc = "1"
            cOpc   := "A"
            cOpcao := "T�tulos de Arrendamento"
            cMsg   := "Voc� escolheu liquidar t�tulos de Arrendamento."+chr(10)+chr(12)
            cMsg   += "Deseja marcar os t�tulos gerados como 'Essencial'?"
            lEssenc := MsgYesNo(cMsg, "Confirmar Essencial...")
       case cOpc = "2"
            cOpc   := "T"
            cOpcao := "T�tulos de TUST"
       case cOpc = "3"
            cOpc = "O"
            cOpcao := "Outros Tipos de T�tulos"
    EndCase
endif

return ()


// Validar os parametros informados na tela inicial
User Function RFA2_VALID()

Local lRet := .T.

if empty(dtos(dDataVenc1)) .or. dtos(dDataVenc1) < dtos(dDataBase)
   alert("Data de Vencimento da parcela de Pagamento inv�lida!")
   return(.F.)
endif

if empty(dtos(dDatavenc2)) .or. dtos(dDataVenc1) > dtos(dDataVenc2)
   alert("Data de Vencimento da parcela de Saldo inv�lida!")
   return(.F.)
endif   

//if Empty(AllTrim(cFornChoice)) .and. !Empty(AllTrim(cLojaChoice))
//   alert("Aten��o: Informe o C�digo do Fornecedor ou a Loja tamb�m deve estar em branco")
//   return(.F.)
//endif

//if !Empty(AllTrim(cFornChoice)) .and. Empty(AllTrim(cLojaChoice))
//   alert("Aten��o: Informe a Loja do Fornecedor ou o C�digo tamb�m deve estar em branco")
//   return(.F.)
//endif

if !empty(cFornChoice)
   cLojaChoice := RFA2_Fornece(cFornChoice)
   dbSelectArea("SA2")
   dbSetOrder(1)
   if !dbSeek(xFilial("SA2")+cFornChoice+cLojaChoice)
      lRet := .F.
      Alert("Aten��o: Fornecedor inexistente!")
   endif
endif

Return(lRet)




// Fun��o para somar todos os t�tulos do fornecedor atual selecionado em TRB002
Static Function RFA2_Valor(cOpc)

Local cAliasVAL := "VAL"
Local cQuery    := ""
Local nContador := 0
Local nValTotal := 0

do case 
    case cOpc = "O"             // Outros
        cQuery := "SELECT E2_FORNECE, E2_LOJA, E2_FILIAL, E2_NATUREZ, ED_XCDPARA, E2_SALDO, E2_ACRESC, E2_DECRESC "
        cQuery += "FROM SE2000 INNER JOIN SED000 ON E2_NATUREZ = ED_CODIGO "
        // Se conseguir resolver problema de n�o precisar estar posicionado na filial origem + destino, pode eliminar
        // a condi��o da Filial abaixo
        cQuery += "WHERE E2_XCLASS = '3' AND E2_XRJ = 'S' AND E2_NUMLIQ = '' AND E2_FILIAL = '"+cFilialAtual+"' " 
        cQuery += "AND SED000.D_E_L_E_T_ = '' AND SE2000.D_E_L_E_T_ = '' "
        // Saldo diferente de 0
        cQuery += "AND E2_SALDO <> 0 "
        // Seleciona agora somente o fornecedor atual do TRB002
        // cQuery += "AND E2_FORNECE = '"+TRB002->E2_FORNECE+"' AND E2_LOJA = '"+TRB002->E2_LOJA+"' " - sem a Loja
        cQuery += "AND E2_FORNECE = '"+TRB002->E2_FORNECE+"' "
        // Ignora t�tulos de Arrendamento - Prefixo = "ARR"
        cQuery += "AND NOT (E2_PREFIXO IN "+FormatIn("ARR","|")+") "
        //" and not (E2_TIPO in " + FormatIn(MVPROVIS + "|" + MVPAGANT + "|" + MV_CPNEG,"|") + ")" ***
        // Ignora t�tulos de TUST - Naturezas = "2217, 2203, 2215 e 2335"
        cQuery += "AND NOT (E2_NATUREZ IN "+FormatIn("2217|2203|2215|2335","|")+") "
        // Ignora registro do SE2 se Filial deletada ou Filial n�o existir em SYS_COMPANY
        cQuery += "AND (SELECT SYS_COMPANY.D_E_L_E_T_ FROM SYS_COMPANY WHERE M0_CODFIL = E2_FILIAL) = '' "
        // Ignora registro do SE2 se Fornecedor bloqueado
        cQuery += "AND (SELECT A2_MSBLQL FROM SA2000 WHERE A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA AND SA2000.D_E_L_E_T_ = '') <> '1' "
        // Ignora t�tulos em Bordero
        //cQuery += "AND E2_NUMBOR = '' "               // N�o ignorar mais bordero gerado - 18/03/2021
        // Seleciona somente os registros da Natureza Para do fornecedor atual do TRB002
        cQuery += "AND ED_XCDPARA = '"+TRB002->ED_XCDPARA+"' "
        cQuery += "AND E2_TIPO <> 'PA' AND E2_TIPO <> 'NDF' "    // Ignora PA e NDF
        // Ignorar o Fornecedor "UNIAO"
        cQuery += "AND NOT (E2_FORNECE IN "+FormatIn("UNIAO","|")+") "
        cQuery += "ORDER BY E2_FORNECE, E2_LOJA, ED_XCDPARA"
    case cOpc = "A"             // Arrendamento
        cQuery := "SELECT E2_FORNECE, E2_LOJA, E2_FILIAL, E2_NATUREZ, ED_XCDPARA, E2_SALDO, E2_ACRESC, E2_DECRESC "
        cQuery += "FROM SE2000 INNER JOIN SED000 ON E2_NATUREZ = ED_CODIGO "
        // Se conseguir resolver problema de n�o precisar estar posicionado na filial origem + destino, pode eliminar
        // a condi��o da Filial abaixo
        cQuery += "WHERE E2_XCLASS = '3' AND E2_XRJ = 'S' AND E2_NUMLIQ = '' AND E2_FILIAL = '"+cFilialAtual+"' " 
        cQuery += "AND SED000.D_E_L_E_T_ = '' AND SE2000.D_E_L_E_T_ = '' "
        // Saldo diferente de 0
        cQuery += "AND E2_SALDO <> 0 "        
        // Seleciona agora somente o fornecedor atual do TRB002
        // cQuery += "AND E2_FORNECE = '"+TRB002->E2_FORNECE+"' AND E2_LOJA = '"+TRB002->E2_LOJA+"' " - sem a Loja
        cQuery += "AND E2_FORNECE = '"+TRB002->E2_FORNECE+"' "
        // Ignora t�tulos de Arrendamento - Prefixo = "ARR"
        cQuery += "AND (E2_PREFIXO IN "+FormatIn("ARR","|")+") "
        //" and not (E2_TIPO in " + FormatIn(MVPROVIS + "|" + MVPAGANT + "|" + MV_CPNEG,"|") + ")" ***
        // Ignora t�tulos de TUST - Naturezas = "2217, 2203, 2215 e 2335"
        cQuery += "AND NOT (E2_NATUREZ IN "+FormatIn("2217|2203|2215|2335","|")+") "
        // Ignora registro do SE2 se Filial deletada ou Filial n�o existir em SYS_COMPANY
        cQuery += "AND (SELECT SYS_COMPANY.D_E_L_E_T_ FROM SYS_COMPANY WHERE M0_CODFIL = E2_FILIAL) = '' "
        // Ignora registro do SE2 se Fornecedor bloqueado
        cQuery += "AND (SELECT A2_MSBLQL FROM SA2000 WHERE A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA AND SA2000.D_E_L_E_T_ = '') <> '1' "
        // Ignora t�tulos em Bordero
        //cQuery += "AND E2_NUMBOR = '' "               // N�o ignorar mais bordero gerado - 18/03/2021
        // Seleciona somente os registros da Natureza Para do fornecedor atual do TRB002
        cQuery += "AND ED_XCDPARA = '"+TRB002->ED_XCDPARA+"' "  
        cQuery += "AND E2_TIPO <> 'PA' AND E2_TIPO <> 'NDF' "    // Ignora PA e NDF
        // Ignorar o Fornecedor "UNIAO"
        cQuery += "AND NOT (E2_FORNECE IN "+FormatIn("UNIAO","|")+") "
        cQuery += "ORDER BY E2_FORNECE, E2_LOJA, ED_XCDPARA"
    case cOpc = "T"             // TUST
        cQuery := "SELECT E2_FORNECE, E2_LOJA, E2_FILIAL, E2_NATUREZ, ED_XCDPARA, E2_SALDO, E2_ACRESC, E2_DECRESC "
        cQuery += "FROM SE2000 INNER JOIN SED000 ON E2_NATUREZ = ED_CODIGO "
        // Se conseguir resolver problema de n�o precisar estar posicionado na filial origem + destino, pode eliminar
        // a condi��o da Filial abaixo
        cQuery += "WHERE E2_XCLASS = '3' AND E2_XRJ = 'S' AND E2_NUMLIQ = '' AND E2_FILIAL = '"+cFilialAtual+"' " 
        cQuery += "AND SED000.D_E_L_E_T_ = '' AND SE2000.D_E_L_E_T_ = '' "
        // Saldo diferente de 0
        cQuery += "AND E2_SALDO <> 0 "        
        // Seleciona agora somente o fornecedor atual do TRB002
        // cQuery += "AND E2_FORNECE = '"+TRB002->E2_FORNECE+"' AND E2_LOJA = '"+TRB002->E2_LOJA+"' " - sem a Loja
        cQuery += "AND E2_FORNECE = '"+TRB002->E2_FORNECE+"' "
        // Ignora t�tulos de Arrendamento - Prefixo = "ARR"
        cQuery += "AND NOT (E2_PREFIXO IN "+FormatIn("ARR","|")+") "
        //" and not (E2_TIPO in " + FormatIn(MVPROVIS + "|" + MVPAGANT + "|" + MV_CPNEG,"|") + ")" ***
        // Ignora t�tulos de TUST - Naturezas = "2217, 2203, 2215 e 2335"
        cQuery += "AND (E2_NATUREZ IN "+FormatIn("2217|2203|2215|2335","|")+") "
        // Ignora registro do SE2 se Filial deletada ou Filial n�o existir em SYS_COMPANY
        cQuery += "AND (SELECT SYS_COMPANY.D_E_L_E_T_ FROM SYS_COMPANY WHERE M0_CODFIL = E2_FILIAL) = '' "
        // Ignora registro do SE2 se Fornecedor bloqueado
        cQuery += "AND (SELECT A2_MSBLQL FROM SA2000 WHERE A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA AND SA2000.D_E_L_E_T_ = '') <> '1' "
        // Ignora t�tulos em Bordero
        //cQuery += "AND E2_NUMBOR = '' "               // N�o ignorar mais bordero gerado - 18/03/2021
        // Seleciona somente os registros da Natureza Para do fornecedor atual do TRB002
        cQuery += "AND ED_XCDPARA = '"+TRB002->ED_XCDPARA+"' "    
        cQuery += "AND E2_TIPO <> 'PA' AND E2_TIPO <> 'NDF' "    // Ignora PA e NDF   
        // Ignorar o Fornecedor "UNIAO"
        cQuery += "AND NOT (E2_FORNECE IN "+FormatIn("UNIAO","|")+") "
        cQuery += "ORDER BY E2_FORNECE, E2_LOJA, ED_XCDPARA"
endcase

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

//if TRB002->E2_FORNECE = "011007"
// if TRB002->E2_FORNECE $ "000100;001490;005672;011007"
//   alert("Fornecedor: "+TRB002->E2_FORNECE+"/"+TRB002->E2_LOJA+" - Para Nat "+TRB002->ED_XCDPARA)
//   alert("Valor dos T�tulos: "+str(nValTotal)+" - "+str(nContador)+" T�tulos")
//endif

dbgotop()

dbCloseArea("VAL")
 
Return(nValTotal)



// Fun��o para retornar a loja destino do forncedor - criado para manter padr�o
Static Function RFA2_Fornece(cCodFor)

Local aArea   := GetArea()
Local cRetFor := ""

dbSelectArea("SA2")
dbsetorder(1)

if !dbSeek(xFilial("SA2")+cCodFor)
   cRetFor := "99"
   return(cRetFor)
endif

dbSeek(xFilial("SA2")+cCodFor)

do while .T.

   if A2_MSBLQL <> "1"
      cRetFor := A2_LOJA
      exit
   endif

   dbSkip()
   if eof() .or. A2_COD <> cCodFor
      cRetFor := "99"
      exit
   endif

enddo

RestArea(aArea)

return(cRetFor)
