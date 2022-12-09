#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
       #DEFINE PSAY SAY
#ENDIF

User Function Kfin08r()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CDESC1,CDESC2,CDESC3,CSTRING,ALINHA,ARETURN")
SetPrvt("CPERG,NJUROS,NLASTKEY,NOMEPROG,TAMANHO,LEND")
SetPrvt("NVEND0,TITULO,CABEC1,CABEC2,WNREL,AORD")
SetPrvt("LIMITE,LCONTINUA,NTIT0,NTIT1,NTIT2,NTIT3")
SetPrvt("NTIT4,NTIT5,NTOTJ,NTOT0,NTOT1,NTOT2")
SetPrvt("NTOT3,NTOT4,NTOTTIT,NTOTJUR,ACAMPOS,ATAM")
SetPrvt("NATRASO,NTOTABAT,NSALDO,DDATAANT,NMESTIT0,NMESTIT1")
SetPrvt("NMESTIT2,NMESTIT3,NMESTIT4,NMESTTIT,NMESTITJ,NORDEM")
SetPrvt("CMOEDA,DBAIXA,CBTXT,CBCONT,LI,M_PAG")
SetPrvt("CNOMEARQ,CQUERY,CCOND1,CCOND2,VENDEDOR,CCARANT")
SetPrvt("_CVEND,LQUEBRA,ASITUACA,_CNOMEVEND,_CESTVEND,AREGS")
SetPrvt("I,J,")


#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==>        #DEFINE PSAY SAY
#ENDIF

cDesc1   :="Imprime a posi‡„o dos titulos a receber relativo a data ba-"
cDesc2   :="se do sistema."
cDesc3   :="Especifico Kenia Industrias Texteis Ltda"
cString  :="SE1"
aLinha   :={}
aReturn  :={ "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
cPerg    :="FIN08R    "
nJuros   :=0
nLastKey :=0
nomeprog :="KFIN08R"
tamanho  :="G"
lEnd     := .F.
nVend0      := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := "Posicao dos Titulos a Receber"
cabec1 := "Codigo    Nome do Cliente           Prf-Numero-P TP       Data de       Vencto        Vencto        Banco      Valor a      Vendedor      Historico                         "
cabec2 := "                                                          Emissao       Titulo        Real                     Receber                                                      "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ValidPerg()

pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a fun‡„o SETPRINT ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="KFIN08R"            
aOrd :={ "Por Cliente"   ,;
         "Por Numero"    ,;
         "Por Banco"     ,;
         "Por Venc/Cli"  ,;
         "Por Natureza"  ,;
         "Por Emissao"   ,;
         "Por Ven/Bco"   ,;
         "Por Cod.Cli."  ,;
         "Banco/Situacao",;
         "Banco/Cliente" ,;
         "Por Vendedor" }
			
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

IF nLastKey == 27
   Return
EndIF

SetDefault(aReturn,cString)

IF nLastKey == 27
   Return
EndIF

RptStatus({||RptDetail()})// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> RptStatus({||Execute(RptDetail)})
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RptDetail
Static Function RptDetail()

limite := 220
lContinua := .T.
nTit0   :=0
nTit1   :=0
nTit2   :=0
nTit3   :=0       
nTit4   :=0
nTit5   :=0
nTotJ   :=0
nTot0   :=0
nTot1   :=0
nTot2   :=0
nTot3   :=0
nTot4   :=0
nTotTit :=0
nTotJur :=0
aCampos :={}
aTam    :={}
nAtraso :=0
nTotAbat:=0
nSaldo  :=0
dDataAnt:= dDataBase
nMesTit0:= nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0
nOrdem  := aReturn[8]
cMoeda  := Str(1)
dBaixa  := dDataBase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vari veis utilizadas para Impress„o do Cabe‡alho e Rodap‚ ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt 	:= "* indica titulo provisorio, P Indica Saldo Parcial"
cbcont	:= 0
li      := 80
m_pag 	:= 1

dbSelectArea("SE1")
Set Softseek On

cNomeArq:=CriaTrab( , .f.)

IF RddName()=="TOPCONN"

       IF nOrdem == 1
          cQuery := "Select E1_FILIAL FILIAL ,E1_NUM NUMERO, E1_PREFIXO PREFIXO ,E1_PARCELA PARCELA ,E1_TIPO TIPO ,E1_CLIENTE CLIENTE ,E1_SITUACA SITUACA ,E1_PORTADO BANCO, E1_EMISSAO EMISSAO , E1_VEND1 VENDEDOR ,"
          cQuery := cQuery +        "E1_LOJA LOJA ,E1_NOMCLI NOMECLI ,E1_VENCREA VENCIMENTO ,E1_NATUREZ NATUREZA ,R_E_C_N_O_ RECNO " 
          cQuery := cQuery + "From   SE1"+cEmpAnt+"0 NOLOCK (INDEX=SE10101) " 
          cQuery := cQuery + "Where   E1_FILIAL = '"+xfilial("SE1")+"' and E1_CLIENTE >= '"+mv_par01+ "' and E1_CLIENTE <= '"+mv_par02+ "' and "
          cQuery := cQuery +        " E1_PREFIXO >= '"+mv_par03        +"' and E1_PREFIXO <= '"+mv_par04       + "' and  "
          cQuery := cQuery +        " E1_NUM     >= '"+mv_par05        +"' and E1_NUM     <= '"+mv_par06       + "' and  "
          cQuery := cQuery +        " E1_PORTADO >= '"+mv_par07        +"' and E1_PORTADO <= '"+mv_par08       + "' and  "
          cQuery := cQuery +        " E1_VENCREA >= '"+dtos(mv_par09)  +"' and E1_VENCREA <= '"+dtos(mv_par10) + "' and  "
          cQuery := cQuery +        " E1_NATUREZ >= '"+mv_par11        +"' and E1_NATUREZ <= '"+mv_par12       + "' and  "
          cQuery := cQuery +        " E1_VEND1   >= '"+MV_PAR29        +"' and E1_VEND1   <= '"+MV_PAR30       + "' and  "
          cQuery := cQuery +        " E1_EMISSAO >= '"+dtos(mv_par13)  +"' and E1_EMISSAO <= '"+dtos(mv_par14) + "' and  "
          cQuery := cQuery +        " E1_EMISSAO <= '"+dtos(dDataBase) +"' and E1_SALDO <> 0.00"+ " and  "
          cQuery := cQuery +        " D_E_L_E_T_ <> '*' "
          cQuery := cQuery + "Order By E1_NOMCLI+E1_CLIENTE+E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
          cQuery := ChangeQuery(cQuery)

          dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "cNomeArq", .F., .T.)

          cCond1 := "CLIENTE <= mv_par02"
          cCond2 := "CLIENTE + LOJA"
          titulo := titulo + " - Por Cliente"
       ElseIF nOrdem == 2
          cQuery := "Select E1_FILIAL FILIAL ,E1_NUM NUMERO, E1_PREFIXO PREFIXO ,E1_PARCELA PARCELA ,E1_TIPO TIPO ,E1_CLIENTE CLIENTE ,E1_SITUACA SITUACA ,E1_PORTADO BANCO, E1_EMISSAO EMISSAO , E1_VEND1 VENDEDOR ,"
          cQuery := cQuery +        "E1_LOJA LOJA ,E1_NOMCLI NOMECLI ,E1_VENCREA VENCIMENTO ,E1_NATUREZ NATUREZA ,R_E_C_N_O_ RECNO " 
          cQuery := cQuery + "From   SE1"+cEmpAnt+"0 NOLOCK (INDEX=SE10102) " 
          cQuery := cQuery + "Where   E1_FILIAL = '"+xfilial("SE1")+"' and E1_CLIENTE >= '"+mv_par01+ "' and E1_CLIENTE <= '"+mv_par02+ "' and "
          cQuery := cQuery +        " E1_PREFIXO >= '"+mv_par03        +"' and E1_PREFIXO <= '"+mv_par04       + "' and  "
          cQuery := cQuery +        " E1_NUM     >= '"+mv_par05        +"' and E1_NUM     <= '"+mv_par06       + "' and  "
          cQuery := cQuery +        " E1_PORTADO >= '"+mv_par07        +"' and E1_PORTADO <= '"+mv_par08       + "' and  "
          cQuery := cQuery +        " E1_VENCREA >= '"+dtos(mv_par09)  +"' and E1_VENCREA <= '"+dtos(mv_par10) + "' and  "
          cQuery := cQuery +        " E1_NATUREZ >= '"+mv_par11        +"' and E1_NATUREZ <= '"+mv_par12       + "' and  "
          cQuery := cQuery +        " E1_VEND1   >= '"+MV_PAR29        +"' and E1_VEND1   <= '"+MV_PAR30       + "' and  "
          cQuery := cQuery +        " E1_EMISSAO >= '"+dtos(mv_par13)  +"' and E1_EMISSAO <= '"+dtos(mv_par14) + "' and  "
          cQuery := cQuery +        " E1_EMISSAO <= '"+dtos(dDataBase) +"' and E1_SALDO <> 0.00"+ " and  "
          cQuery := cQuery +        " D_E_L_E_T_ <> '*' "
          cQuery := cQuery + "Order By E1_NUM"
          cQuery := ChangeQuery(cQuery)

          dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "cNomeArq", .F., .T.)

          cCond1 := "NUMERO <= mv_par06"
          cCond2 := "NUMERO"
          titulo := titulo + " - Por Numero"

       ElseIF nOrdem == 3
          cQuery := "Select E1_FILIAL FILIAL ,E1_NUM NUMERO, E1_PREFIXO PREFIXO ,E1_PARCELA PARCELA ,E1_TIPO TIPO ,E1_CLIENTE CLIENTE ,E1_SITUACA SITUACA ,E1_PORTADO BANCO, E1_EMISSAO EMISSAO , E1_VEND1 VENDEDOR ,"
          cQuery := cQuery +        "E1_LOJA LOJA ,E1_NOMCLI NOMECLI ,E1_VENCREA VENCIMENTO ,E1_NATUREZ NATUREZA ,R_E_C_N_O_ RECNO " 
          cQuery := cQuery + "From   SE1"+cEmpAnt+"0 NOLOCK (INDEX=SE10104) " 
          cQuery := cQuery + "Where   E1_FILIAL = '"+xfilial("SE1")+"' and E1_CLIENTE >= '"+mv_par01+ "' and E1_CLIENTE <= '"+mv_par02+ "' and "
          cQuery := cQuery +        " E1_PREFIXO >= '"+mv_par03        +"' and E1_PREFIXO <= '"+mv_par04       + "' and  "
          cQuery := cQuery +        " E1_NUM     >= '"+mv_par05        +"' and E1_NUM     <= '"+mv_par06       + "' and  "
          cQuery := cQuery +        " E1_PORTADO >= '"+mv_par07        +"' and E1_PORTADO <= '"+mv_par08       + "' and  "
          cQuery := cQuery +        " E1_VENCREA >= '"+dtos(mv_par09)  +"' and E1_VENCREA <= '"+dtos(mv_par10) + "' and  "
          cQuery := cQuery +        " E1_NATUREZ >= '"+mv_par11        +"' and E1_NATUREZ <= '"+mv_par12       + "' and  "
          cQuery := cQuery +        " E1_VEND1   >= '"+MV_PAR29        +"' and E1_VEND1   <= '"+MV_PAR30       + "' and  "
          cQuery := cQuery +        " E1_EMISSAO >= '"+dtos(mv_par13)  +"' and E1_EMISSAO <= '"+dtos(mv_par14) + "' and  "
          cQuery := cQuery +        " E1_EMISSAO <= '"+dtos(dDataBase) +"' and E1_SALDO <> 0.00"+ " and  "
          cQuery := cQuery +        " D_E_L_E_T_ <> '*' "
          cQuery := cQuery + "Order By E1_PORTADO"
          cQuery := ChangeQuery(cQuery)

          dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "cNomeArq", .F., .T.)

          cCond1 := "BANCO <= mv_par08"
          cCond2 := "BANCO"
          titulo := titulo + " - Por Banco"

       ElseIF nOrdem == 4
          cQuery := "Select E1_FILIAL FILIAL ,E1_NUM NUMERO, E1_PREFIXO PREFIXO ,E1_PARCELA PARCELA ,E1_TIPO TIPO ,E1_CLIENTE CLIENTE ,E1_SITUACA SITUACA ,E1_PORTADO BANCO, E1_EMISSAO EMISSAO, E1_VEND1 VENDEDOR ,"
          cQuery := cQuery +        "E1_LOJA LOJA ,E1_NOMCLI NOMECLI ,E1_VENCREA VENCIMENTO ,E1_NATUREZ NATUREZA ,R_E_C_N_O_ RECNO " 
          cQuery := cQuery + "From   SE1"+cEmpAnt+"0 NOLOCK (INDEX=SE10107) " 
          cQuery := cQuery + "Where   E1_FILIAL = '"+xfilial("SE1")+"' and E1_CLIENTE >= '"+mv_par01+ "' and E1_CLIENTE <= '"+mv_par02+ "' and "
          cQuery := cQuery +        " E1_PREFIXO >= '"+mv_par03        +"' and E1_PREFIXO <= '"+mv_par04       + "' and  "
          cQuery := cQuery +        " E1_NUM     >= '"+mv_par05        +"' and E1_NUM     <= '"+mv_par06       + "' and  "
          cQuery := cQuery +        " E1_PORTADO >= '"+mv_par07        +"' and E1_PORTADO <= '"+mv_par08       + "' and  "
          cQuery := cQuery +        " E1_VENCREA >= '"+dtos(mv_par09)  +"' and E1_VENCREA <= '"+dtos(mv_par10) + "' and  "
          cQuery := cQuery +        " E1_NATUREZ >= '"+mv_par11        +"' and E1_NATUREZ <= '"+mv_par12       + "' and  "
          cQuery := cQuery +        " E1_VEND1   >= '"+MV_PAR29        +"' and E1_VEND1   <= '"+MV_PAR30       + "' and  "
          cQuery := cQuery +        " E1_EMISSAO >= '"+dtos(mv_par13)  +"' and E1_EMISSAO <= '"+dtos(mv_par14) + "' and  "
          cQuery := cQuery +        " E1_EMISSAO <= '"+dtos(dDataBase) +"' and E1_SALDO <> 0.00"+ " and  "
          cQuery := cQuery +        " D_E_L_E_T_ <> '*' "
          cQuery := cQuery + "Order By E1_VENCREA"
          cQuery := ChangeQuery(cQuery)

          dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "cNomeArq", .F., .T.)

          cCond1 := "VENCIMENTO <= mv_par10"
          cCond2 := "VENCIMENTO"
          titulo := titulo + " - Por Data de Vencimento"

       ElseIF nOrdem == 5
          cQuery := "Select E1_FILIAL FILIAL ,E1_NUM NUMERO, E1_PREFIXO PREFIXO ,E1_PARCELA PARCELA ,E1_TIPO TIPO ,E1_CLIENTE CLIENTE ,E1_SITUACA SITUACA ,E1_PORTADO BANCO, E1_EMISSAO EMISSAO, E1_VEND1 VENDEDOR ,"
          cQuery := cQuery +        "E1_LOJA LOJA ,E1_NOMCLI NOMECLI ,E1_VENCREA VENCIMENTO ,E1_NATUREZ NATUREZA ,R_E_C_N_O_ RECNO " 
          cQuery := cQuery + "From   SE1"+cEmpAnt+"0 NOLOCK (INDEX=SE10103) " 
          cQuery := cQuery + "Where   E1_FILIAL = '"+xfilial("SE1")+"' and E1_CLIENTE >= '"+mv_par01+ "' and E1_CLIENTE <= '"+mv_par02+ "' and "
          cQuery := cQuery +        " E1_PREFIXO >= '"+mv_par03        +"' and E1_PREFIXO <= '"+mv_par04       + "' and  "
          cQuery := cQuery +        " E1_NUM     >= '"+mv_par05        +"' and E1_NUM     <= '"+mv_par06       + "' and  "
          cQuery := cQuery +        " E1_PORTADO >= '"+mv_par07        +"' and E1_PORTADO <= '"+mv_par08       + "' and  "
          cQuery := cQuery +        " E1_VENCREA >= '"+dtos(mv_par09)  +"' and E1_VENCREA <= '"+dtos(mv_par10) + "' and  "
          cQuery := cQuery +        " E1_NATUREZ >= '"+mv_par11        +"' and E1_NATUREZ <= '"+mv_par12       + "' and  "
          cQuery := cQuery +        " E1_VEND1   >= '"+MV_PAR29        +"' and E1_VEND1   <= '"+MV_PAR30       + "' and  "
          cQuery := cQuery +        " E1_EMISSAO >= '"+dtos(mv_par13)  +"' and E1_EMISSAO <= '"+dtos(mv_par14) + "' and  "
          cQuery := cQuery +        " E1_EMISSAO <= '"+dtos(dDataBase) +"' and E1_SALDO <> 0.00"+ " and  "
          cQuery := cQuery +        " D_E_L_E_T_ <> '*' "
          cQuery := cQuery + "Order By E1_NATUREZ"
          cQuery := ChangeQuery(cQuery)

          dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "cNomeArq", .F., .T.)

          cCond1 := "NATUREZA <= mv_par12"
          cCond2 := "NATUREZA"
          titulo := titulo + " - Por Natureza"
       ElseIF nOrdem == 6
          cQuery := "Select E1_FILIAL FILIAL ,E1_NUM NUMERO, E1_PREFIXO PREFIXO ,E1_PARCELA PARCELA ,E1_TIPO TIPO ,E1_CLIENTE CLIENTE ,E1_SITUACA SITUACA ,E1_PORTADO BANCO, E1_EMISSAO EMISSAO, E1_VEND1 VENDEDOR ,"
          cQuery := cQuery +        "E1_LOJA LOJA ,E1_NOMCLI NOMECLI ,E1_VENCREA VENCIMENTO ,E1_NATUREZ NATUREZA ,R_E_C_N_O_ RECNO " 
          cQuery := cQuery + "From   SE1"+cEmpAnt+"0 NOLOCK (INDEX=SE10106) " 
          cQuery := cQuery + "Where   E1_FILIAL = '"+xfilial("SE1")+"' and E1_CLIENTE >= '"+mv_par01+ "' and E1_CLIENTE <= '"+mv_par02+ "' and "
          cQuery := cQuery +        " E1_PREFIXO >= '"+mv_par03        +"' and E1_PREFIXO <= '"+mv_par04       + "' and  "
          cQuery := cQuery +        " E1_NUM     >= '"+mv_par05        +"' and E1_NUM     <= '"+mv_par06       + "' and  "
          cQuery := cQuery +        " E1_PORTADO >= '"+mv_par07        +"' and E1_PORTADO <= '"+mv_par08       + "' and  "
          cQuery := cQuery +        " E1_VENCREA >= '"+dtos(mv_par09)  +"' and E1_VENCREA <= '"+dtos(mv_par10) + "' and  "
          cQuery := cQuery +        " E1_NATUREZ >= '"+mv_par11        +"' and E1_NATUREZ <= '"+mv_par12       + "' and  "
          cQuery := cQuery +        " E1_VEND1   >= '"+MV_PAR29        +"' and E1_VEND1   <= '"+MV_PAR30       + "' and  "
          cQuery := cQuery +        " E1_EMISSAO >= '"+dtos(mv_par13)  +"' and E1_EMISSAO <= '"+dtos(mv_par14) + "' and  "
          cQuery := cQuery +        " E1_EMISSAO <= '"+dtos(dDataBase) +"' and E1_SALDO <> 0.00"+ " and  "
          cQuery := cQuery +        " D_E_L_E_T_ <> '*' "
          cQuery := cQuery + "Order By E1_EMISSAO"
          cQuery := ChangeQuery(cQuery)

          dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "cNomeArq", .F., .T.)

          cCond1 := "EMISSAO <= mv_par14"
          cCond2 := "EMISSAO"
          titulo := titulo + " - Por Emissao"

       ElseIF nOrdem == 7
          cQuery := "Select E1_FILIAL FILIAL ,E1_NUM NUMERO, E1_PREFIXO PREFIXO ,E1_PARCELA PARCELA ,E1_TIPO TIPO ,E1_CLIENTE CLIENTE ,E1_SITUACA SITUACA ,E1_PORTADO BANCO, E1_EMISSAO EMISSAO, E1_VEND1 VENDEDOR ,"
          cQuery := cQuery +        "E1_LOJA LOJA ,E1_NOMCLI NOMECLI ,E1_VENCREA VENCIMENTO ,E1_NATUREZ NATUREZA ,R_E_C_N_O_ RECNO " 
          cQuery := cQuery + "From   SE1"+cEmpAnt+"0 NOLOCK (INDEX=SE10101) " 
          cQuery := cQuery + "Where   E1_FILIAL = '"+xfilial("SE1")+"' and E1_CLIENTE >= '"+mv_par01+ "' and E1_CLIENTE <= '"+mv_par02+ "' and "
          cQuery := cQuery +        " E1_PREFIXO >= '"+mv_par03        +"' and E1_PREFIXO <= '"+mv_par04       + "' and  "
          cQuery := cQuery +        " E1_NUM     >= '"+mv_par05        +"' and E1_NUM     <= '"+mv_par06       + "' and  "
          cQuery := cQuery +        " E1_PORTADO >= '"+mv_par07        +"' and E1_PORTADO <= '"+mv_par08       + "' and  "
          cQuery := cQuery +        " E1_VENCREA >= '"+dtos(mv_par09)  +"' and E1_VENCREA <= '"+dtos(mv_par10) + "' and  "
          cQuery := cQuery +        " E1_NATUREZ >= '"+mv_par11        +"' and E1_NATUREZ <= '"+mv_par12       + "' and  "
          cQuery := cQuery +        " E1_VEND1   >= '"+MV_PAR29        +"' and E1_VEND1   <= '"+MV_PAR30       + "' and  "
          cQuery := cQuery +        " E1_EMISSAO >= '"+dtos(mv_par13)  +"' and E1_EMISSAO <= '"+dtos(mv_par14) + "' and  "
          cQuery := cQuery +        " E1_EMISSAO <= '"+dtos(dDataBase) +"' and E1_SALDO <> 0.00"+ " and  "
          cQuery := cQuery +        " D_E_L_E_T_ <> '*' "
          cQuery := cQuery + "Order By E1_VENCREA+E1_PORTADO+E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
          cQuery := ChangeQuery(cQuery)

          dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "cNomeArq", .F., .T.)

          cCond1 := "VENCIMENTO <= mv_par10"
          cCond2 := "VENCIMENTO+BANCO"
          titulo := titulo + " - Por Vencto/Banco"

       ElseIF nOrdem == 8
          cQuery := "Select E1_FILIAL FILIAL ,E1_NUM NUMERO, E1_PREFIXO PREFIXO ,E1_PARCELA PARCELA ,E1_TIPO TIPO ,E1_CLIENTE CLIENTE ,E1_SITUACA SITUACA ,E1_PORTADO BANCO, E1_EMISSAO EMISSAO, E1_VEND1 VENDEDOR ,"
          cQuery := cQuery +        "E1_LOJA LOJA ,E1_NOMCLI NOMECLI ,E1_VENCREA VENCIMENTO ,E1_NATUREZ NATUREZA ,R_E_C_N_O_ RECNO " 
          cQuery := cQuery + "From   SE1"+cEmpAnt+"0 NOLOCK (INDEX=SE10102) " 
          cQuery := cQuery + "Where   E1_FILIAL = '"+xfilial("SE1")+"' and E1_CLIENTE >= '"+mv_par01+ "' and E1_CLIENTE <= '"+mv_par02+ "' and "
          cQuery := cQuery +        " E1_PREFIXO >= '"+mv_par03        +"' and E1_PREFIXO <= '"+mv_par04       + "' and  "
          cQuery := cQuery +        " E1_NUM     >= '"+mv_par05        +"' and E1_NUM     <= '"+mv_par06       + "' and  "
          cQuery := cQuery +        " E1_PORTADO >= '"+mv_par07        +"' and E1_PORTADO <= '"+mv_par08       + "' and  "
          cQuery := cQuery +        " E1_VENCREA >= '"+dtos(mv_par09)  +"' and E1_VENCREA <= '"+dtos(mv_par10) + "' and  "
          cQuery := cQuery +        " E1_NATUREZ >= '"+mv_par11        +"' and E1_NATUREZ <= '"+mv_par12       + "' and  "
          cQuery := cQuery +        " E1_VEND1   >= '"+MV_PAR29        +"' and E1_VEND1   <= '"+MV_PAR30       + "' and  "
          cQuery := cQuery +        " E1_EMISSAO >= '"+dtos(mv_par13)  +"' and E1_EMISSAO <= '"+dtos(mv_par14) + "' and  "
          cQuery := cQuery +        " E1_EMISSAO <= '"+dtos(dDataBase) +"' and E1_SALDO <> 0.00"+ " and  "
          cQuery := cQuery +        " D_E_L_E_T_ <> '*' "
          cQuery := cQuery + "Order By E1_CLIENTE"
          cQuery := ChangeQuery(cQuery)

          dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "cNomeArq", .F., .T.)

          cCond1 := "CLIENTE <= mv_par02"
          cCond2 := "CLIENTE"
          titulo := titulo + " - Por Cod.Cliente"

       ElseIF nOrdem == 9
          cQuery := "Select E1_FILIAL FILIAL ,E1_NUM NUMERO, E1_PREFIXO PREFIXO ,E1_PARCELA PARCELA ,E1_TIPO TIPO ,E1_CLIENTE CLIENTE ,E1_SITUACA SITUACA ,E1_PORTADO BANCO, E1_EMISSAO EMISSAO, E1_VEND1 VENDEDOR ,"
          cQuery := cQuery +        "E1_LOJA LOJA ,E1_NOMCLI NOMECLI ,E1_VENCREA VENCIMENTO ,E1_NATUREZ NATUREZA ,R_E_C_N_O_ RECNO "
          cQuery := cQuery + "From   SE1"+cEmpAnt+"0 NOLOCK (INDEX=SE10102) " 
          cQuery := cQuery + "Where   E1_FILIAL = '"+xfilial("SE1")+"' and E1_CLIENTE >= '"+mv_par01+ "' and E1_CLIENTE <= '"+mv_par02+ "' and "
          cQuery := cQuery +        " E1_PREFIXO >= '"+mv_par03        +"' and E1_PREFIXO <= '"+mv_par04       + "' and  "
          cQuery := cQuery +        " E1_NUM     >= '"+mv_par05        +"' and E1_NUM     <= '"+mv_par06       + "' and  "
          cQuery := cQuery +        " E1_PORTADO >= '"+mv_par07        +"' and E1_PORTADO <= '"+mv_par08       + "' and  "
          cQuery := cQuery +        " E1_VENCREA >= '"+dtos(mv_par09)  +"' and E1_VENCREA <= '"+dtos(mv_par10) + "' and  "
          cQuery := cQuery +        " E1_NATUREZ >= '"+mv_par11        +"' and E1_NATUREZ <= '"+mv_par12       + "' and  "
          cQuery := cQuery +        " E1_VEND1   >= '"+MV_PAR29        +"' and E1_VEND1   <= '"+MV_PAR30       + "' and  "
          cQuery := cQuery +        " E1_EMISSAO >= '"+dtos(mv_par13)  +"' and E1_EMISSAO <= '"+dtos(mv_par14) + "' and  "
          cQuery := cQuery +        " E1_EMISSAO <= '"+dtos(dDataBase) +"' and E1_SALDO <> 0.00"+ " and  "
          cQuery := cQuery +        " D_E_L_E_T_ <> '*' "
          cQuery := cQuery + "Order By E1_FILIAL+E1_PORTADO+E1_SITUACA+E1_NOMCLI+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
          cQuery := ChangeQuery(cQuery)

          dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "cNomeArq", .F., .T.)

          cCond1 := "BANCO <= mv_par08"
          cCond2 := "BANCO+SITUACA"
          titulo := titulo + " - Por Banco e Situacao"
       ElseIF nOrdem == 10
          cQuery := "Select E1_FILIAL FILIAL ,E1_NUM NUMERO, E1_PREFIXO PREFIXO ,E1_PARCELA PARCELA ,E1_TIPO TIPO ,E1_CLIENTE CLIENTE ,E1_SITUACA SITUACA ,E1_PORTADO BANCO, E1_EMISSAO EMISSAO, E1_VEND1 VENDEDOR ,"
          cQuery := cQuery +        "E1_LOJA LOJA ,E1_NOMCLI NOMECLI ,E1_VENCREA VENCIMENTO ,E1_NATUREZ NATUREZA ,R_E_C_N_O_ RECNO "
          cQuery := cQuery + "From   SE1"+cEmpAnt+"0 NOLOCK (INDEX=SE10102) " 
          cQuery := cQuery + "Where   E1_FILIAL = '"+xfilial("SE1")+"' and E1_CLIENTE >= '"+mv_par01+ "' and E1_CLIENTE <= '"+mv_par02+ "' and "
          cQuery := cQuery +        " E1_PREFIXO >= '"+mv_par03        +"' and E1_PREFIXO <= '"+mv_par04       + "' and  "
          cQuery := cQuery +        " E1_NUM     >= '"+mv_par05        +"' and E1_NUM     <= '"+mv_par06       + "' and  "
          cQuery := cQuery +        " E1_PORTADO >= '"+mv_par07        +"' and E1_PORTADO <= '"+mv_par08       + "' and  "
          cQuery := cQuery +        " E1_VENCREA >= '"+dtos(mv_par09)  +"' and E1_VENCREA <= '"+dtos(mv_par10) + "' and  "
          cQuery := cQuery +        " E1_NATUREZ >= '"+mv_par11        +"' and E1_NATUREZ <= '"+mv_par12       + "' and  "
          cQuery := cQuery +        " E1_VEND1   >= '"+MV_PAR29        +"' and E1_VEND1   <= '"+MV_PAR30       + "' and  "
          cQuery := cQuery +        " E1_EMISSAO >= '"+dtos(mv_par13)  +"' and E1_EMISSAO <= '"+dtos(mv_par14) + "' and  "
          cQuery := cQuery +        " E1_EMISSAO <= '"+dtos(dDataBase) +"' and E1_SALDO <> 0.00"+ " and  "
          cQuery := cQuery +        " D_E_L_E_T_ <> '*' "
          //cQuery := cQuery + "Order By E1_FILIAL+E1_CLIENTE+E1_PORTADO+E1_SITUACA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
          cQuery := cQuery + "Order By E1_FILIAL+E1_PORTADO"
          cQuery := ChangeQuery(cQuery)

          dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "cNomeArq", .F., .T.)

          cCond1 := "BANCO <= mv_par08"
          cCond2 := "BANCO+CLIENTE"
          titulo := titulo + " - Por Banco e Cliente"
       ElseIF nOrdem == 11
          cQuery := "Select E1_FILIAL FILIAL ,E1_NUM NUMERO, E1_PREFIXO PREFIXO ,E1_PARCELA PARCELA ,E1_TIPO TIPO ,E1_CLIENTE CLIENTE ,E1_SITUACA SITUACA ,E1_PORTADO BANCO, E1_EMISSAO EMISSAO , E1_VEND1 VENDEDOR ,"
          cQuery := cQuery +        "E1_LOJA LOJA ,E1_NOMCLI NOMECLI ,E1_VENCREA VENCIMENTO ,E1_NATUREZ NATUREZA ,R_E_C_N_O_ RECNO "
          cQuery := cQuery + "From   SE1"+cEmpAnt+"0 NOLOCK (INDEX=SE10102) " 
          cQuery := cQuery + "Where   E1_FILIAL = '"+xfilial("SE1")+"' and E1_CLIENTE >= '"+mv_par01+ "' and E1_CLIENTE <= '"+mv_par02+ "' and "
          cQuery := cQuery +        " E1_PREFIXO >= '"+mv_par03        +"' and E1_PREFIXO <= '"+mv_par04       + "' and  "
          cQuery := cQuery +        " E1_NUM     >= '"+mv_par05        +"' and E1_NUM     <= '"+mv_par06       + "' and  "
          cQuery := cQuery +        " E1_PORTADO >= '"+mv_par07        +"' and E1_PORTADO <= '"+mv_par08       + "' and  "
          cQuery := cQuery +        " E1_VENCREA >= '"+dtos(mv_par09)  +"' and E1_VENCREA <= '"+dtos(mv_par10) + "' and  "
          cQuery := cQuery +        " E1_NATUREZ >= '"+mv_par11        +"' and E1_NATUREZ <= '"+mv_par12       + "' and  "
          cQuery := cQuery +        " E1_VEND1   >= '"+MV_PAR29        +"' and E1_VEND1   <= '"+MV_PAR30       + "' and  "
          cQuery := cQuery +        " E1_EMISSAO >= '"+dtos(mv_par13)  +"' and E1_EMISSAO <= '"+dtos(mv_par14) + "' and  "
          cQuery := cQuery +        " E1_EMISSAO <= '"+dtos(dDataBase) +"' and E1_SALDO <> 0.00"+ " and  "
          cQuery := cQuery +        " D_E_L_E_T_ <> '*' "
          //cQuery := cQuery + "Order By E1_FILIAL+E1_CLIENTE+E1_PORTADO+E1_SITUACA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
          cQuery := cQuery + "Order By E1_FILIAL+E1_VEND1+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
          cQuery := ChangeQuery(cQuery)

          dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "cNomeArq", .F., .T.)

          cCond1 := "VENDEDOR <= MV_PAR29"
          cCond2 := "VENDEDOR"
          titulo := titulo + " - Por Vendedor"
       EndIF
EndIF

IF MV_PAR18 == 1
   titulo := titulo + " - Analitico"
Else
   titulo := titulo + " - Sintetico"
   cabec1 := "                                                                                          |        Titulos Vencidos         |    Titulos a Vencer     |           Valor dos juros ou         Historico     (Vencidos+Vencer)"
   cabec2 := "                                                                                          | Valor Nominal   Valor Corrigido |      Valor Nominal      |            com  permanencia                                         "
EndIF

dbSelectArea("cNomeArq")
dbGoTop()
SetRegua(RecCount())

While !Eof() .and. lContinua

      #IFNDEF WINDOWS
              Inkey()

              IF LastKey() == K_ALT_A
                 lEnd := .t.
              EndIF
      #ENDIF

      IF lEnd
         @PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
         Exit
      EndIF

      If Len(VENDEDOR) < 6
         VENDEDOR := StrZero(Val(VENDEDOR),6)
      EndIf

      dbSelectArea("SE1")
      dbSetOrder(2)
      dbSeek(xFilial()+cNomeArq->CLIENTE+cNOmeArq->LOJA+cNomeArq->PREFIXO+cNomeArq->NUMERO+cNomeArq->PARCELA+cNomeArq->TIPO)
      dbSetOrder(1)
      DbGoTo( cNomeArq->Recno )

      Store 0 To nTit1,nTit2,nTit3,nTit4,nTit5

      dbSelectArea("cNomeArq")

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Carrega data do registro para permitir ³
      //³ posterior analise de quebra por mes.   ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      dDataAnt := Iif(nOrdem == 6 , SE1->E1_EMISSAO,  SE1->E1_VENCREA)
      cCarAnt  := &cCond2
      _cVend  :=  VENDEDOR

      While &cCond2==cCarAnt .and. !Eof() .and. lContinua

            IncRegua()

            #IFNDEF WINDOWS
                    Inkey()

                    IF LastKey() == K_ALT_A
                       lEnd := .t.
                    EndIF

            #ENDIF

            IF lEnd
               @PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
               lContinua := .F.
               Exit
            EndIF

            dbSelectArea("SE1")
//          dbSetOrder(2)
//          dbSeek(xFilial()+cNomeArq->CLIENTE+cNOmeArq->LOJA+cNomeArq->PREFIXO+cNomeArq->NUMERO+cNomeArq->PARCELA+cNomeArq->TIPO)
            DbSetOrder(1)
            DbGoTo( cNomeArq->Recno )

            //----> HABILITA OPCAO DE FILTRO
            If !Empty(aReturn[7]) .And. !&(aReturn[7])
                dbSelectArea("cNomeArq")
                dbSkip()
                Loop
            EndIf

            IF xFilial("SE1") != SE1->E1_FILIAL
               dbSelectArea("cNomeArq")
               dbSkip()
               Loop
            EndIF

            IF SubStr(SE1->E1_TIPO,3,1)=="-".Or. SE1->E1_EMISSAO>dDataBase .or.;
               (!Empty(E1_FATURA).and.Substr(E1_FATURA,1,6)!="NOTFAT".and.SE1->E1_DTFATUR<=dDataBase)
               dbSelectArea("cNomeArq")
               dbSkip()
               Loop
            EndIF

            IF SubStr(E1_TIPO,1,2) == "PR" .and. MV_PAR15 == 2
               dbSelectArea("cNomeArq")
               dbSkip()
               Loop
           EndIF

           dbSelectArea("SE1")

           If SE1->E1_CLIENTE < mv_par01 .OR. SE1->E1_CLIENTE > mv_par02 
              dbSelectArea("cNomeArq")
              dbSkip()
              Loop
           EndIF

           If SE1->E1_PREFIXO < mv_par03 .OR. SE1->E1_PREFIXO > mv_par04
              dbSelectArea("cNomeArq")
              dbSkip()
              Loop
           EndIF

           If SE1->E1_NUM     < mv_par05 .OR. SE1->E1_NUM     > mv_par06
              dbSelectArea("cNomeArq")
              dbSkip()
              Loop
           EndIF

           If SE1->E1_PORTADO < mv_par07 .OR. SE1->E1_PORTADO > mv_par08
              dbSelectArea("cNomeArq")
              dbSkip()
              Loop
           EndIF

           If SE1->E1_VENCREA < mv_par09 .OR. SE1->E1_VENCREA > mv_par10
              dbSelectArea("cNomeArq")
              dbSkip()
              Loop
           EndIF

           If SE1->E1_NATUREZ < mv_par11 .OR. SE1->E1_NATUREZ > mv_par12
              dbSelectArea("cNomeArq")
              dbSkip()
              Loop
           EndIF

           If SE1->E1_EMISSAO < mv_par13 .OR. SE1->E1_EMISSAO > mv_par14
              dbSelectArea("cNomeArq")
              dbSkip()
              Loop
           EndIF

           If StrZero(Val(SE1->E1_VEND1),6)   < MV_PAR29 .OR. StrZero(Val(SE1->E1_VEND1),6)   > MV_PAR30
              dbSelectArea("cNomeArq")
              dbSkip()
              Loop
           EndIF

           If SE1->E1_EMISSAO > dDataBase
              dbSelectArea("cNomeArq")
              dbSkip()
              Loop
           EndIF

           IF MV_PAR17 == 2 .and. E1_SITUACA $ "27"
              dbSelectArea("cNomeArq")
              dbSkip()
              Loop
           EndIF

           IF !Empty(SE1->E1_DTFATUR)              // Retroativo (fatura)
              nSaldo := xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,1)
           Else
              nSaldo := xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,1)
           EndIF

           IF SE1->E1_TIPO != "RA " .And. SE1->E1_TIPO != "NCC" .And. ;
              !( MV_PAR19 == 2 .And. nSaldo == 0 ) // nao deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo
              nSaldo:= nSaldo - SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
           EndIF

           nSaldo:=Round(NoRound(nSaldo,3),2)

           IF nSaldo == 0
              dbSelectArea("cNomeArq")
              dbSkip()
              Loop
           EndIF

           dbSelectArea("SA1")
           dbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA)
           dbSelectArea("SA6")
           dbSeek(xFilial()+SE1->E1_PORTADO)
           dbSelectArea("SE1")

           IF li > 58
              cabec(@titulo,cabec1,cabec2,nomeprog,tamanho)
           EndIF

           IF MV_PAR18 == 1
              @li, 00 PSAY SE1->E1_CLIENTE
              @li, 10 PSAY SubStr( SE1->E1_NOMCLI, 1, 20 )
              @li, 36 PSAY SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA
              @li, 49 PSAY SE1->E1_TIPO
              @li, 58 PSAY SE1->E1_EMISSAO
              @li, 72 PSAY SE1->E1_VENCTO
              @li, 86 PSAY SE1->E1_VENCREA
              @li,100 PSAY SE1->E1_PORTADO+" "+SE1->E1_SITUACA
              @li,104 PSAY Iif(SE1->E1_TIPO$"RA NCC",xMoeda(-nSaldo,SE1->E1_MOEDA,1),xMoeda(nSaldo,SE1->E1_MOEDA,1))     Picture TM ( SE1->E1_VALOR, 14 )
              @li,124 PSAY SE1->E1_VEND1
              @li,138 PSAY SE1->E1_HIST 
           EndIF

                nJuros:=0
                fa070Juros(1)
                dbSelectArea("SE1")

                IF SE1->E1_TIPO $ "RA /NCC"
                   nTit0:= nTit0 - nSaldo
                Else
                   nTit0:= nTit0 + nSaldo
                Endif

                nTotJur := nTotJur + nJuros
                nMesTitj:= nMesTitj + nJuros

		If nJuros > 0
			nJuros := 0
		Endif

                nAtraso:=dDataBase-SE1->E1_VENCTO
                IF Dow(SE1->E1_VENCTO) == 1 .Or. Dow(SE1->E1_VENCTO) == 7

                    IF Dow(dBaixa) == 2 .and. nAtraso <= 2
                        nAtraso := 0
                    EndIF

                EndIF
                nAtraso:=IIF(nAtraso<0,0,nAtraso)

                IF nAtraso>0

                EndIF

                dbSelectArea("cNomeArq")

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carrega data do registro para permitir ³
        //³ posterior an lise de quebra por mes.   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dDataAnt := Iif(nOrdem == 6, SE1->E1_EMISSAO, SE1->E1_VENCREA)
        dbSkip()
                nTotTit := nTotTit + 1
                nMesTTit:= nMesTTit + 1
                nTit5   := nTit5   + 1

                IF MV_PAR18 == 1
                   li:= li + 1
                EndIF               
    IF nTit5 > 0 .and. nOrdem != 2 .and. nOrdem != 11
           SubTot130()

           If MV_PAR18 == 1
              Li:= Li + 1
           EndIf
    EndIf

    If nOrdem == 11
        IF SE1->E1_TIPO $ "RA /NCC"
            nVend0:= nVend0 - nSaldo
        Else
            nVend0:= nVend0 + nSaldo
        Endif

        If VENDEDOR <> _cVend
            SubTot130()
            nVend0  :=  0
        EndIf
    EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Verifica quebra por mˆs                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lQuebra := .F.
        If nOrdem == 4 .and. Month(SE1->E1_VENCREA) #Month(dDataAnt)
           lQuebra := .T.
        ElseIf nOrdem == 6 .and. Month(SE1->E1_EMISSAO) #Month(dDataAnt)
           lQuebra := .T.
        EndIf

        If lQuebra .and. nMesTTit #0
           ImpMes130()
           nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0
        EndIf
        nTot0:= nTot0 + nTit0
        nTot1:= nTot1 + nTit1
        nTot2:= nTot2 + nTit2
        nTot3:= nTot3 + nTit3
        nTot4:= nTot4 + nTit4
        nTotJ:= nTotJ + nTotJur

    Store 0 To nTit0,nTit1,nTit2,nTit3,nTit4,nTit5,nTotJur,nTotAbat

    EndDo
EndDo

If li != 80

    If li > 58
       Cabec(@titulo,cabec1,cabec2,nomeprog,tamanho)
	EndIF

    TotGer130()
    roda(cbcont,cbtxt,"M")
EndIf

dbSelectArea("cNomeArq")
dbCloseArea()
Ferase(cNomeArq+".DBF")    // Elimina arquivos de Trabalho
Ferase(cNomeArq+OrdBagExt())    // Elimina arquivos de Trabalho

dbSelectArea("SE1")
Set Filter To
dbSetOrder(1)

Set Device To Screen

IF aReturn[5] == 1
   Set Printer TO
   dbCommitAll()
   ourspool(wnrel)
EndIF

MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SubTot130 ³ Autor ³ Paulo Boschetti       ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Imprimir SubTotal do Relatorio                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function SubTot130
Static Function SubTot130()

aSituaca := { "Carteira","Simples","Descontada","Caucionada","Vinculada",;
              "Advogado","Judicial","Cauc Desc" }

IF MV_PAR18 == 1
   Li:= Li + 1
EndIF

If nOrdem == 1
   @li,000 PSAY Alltrim(SA1->A1_NOME)+" - Fone: "+SA1->A1_TEL
Elseif nOrdem == 2 
   @li,000 PSAY "S U B - T O T A L ----> "
   @li,030 PSAY cCarAnt
Elseif nOrdem ==  4 .or. nOrdem == 6
   @li,000 PSAY "S U B - T O T A L ----> "
   @li,030 PSAY Subs(cCarAnt,7,2)+"/"+Subs(cCarAnt,5,2)+"/"+Subs(cCarAnt,1,4)
Elseif nOrdem == 3
   @li,000 PSAY "S U B - T O T A L ----> "
   @li,030 PSAY IIF(Empty(SA6->A6_NREDUZ),"Carteira",SA6->A6_NREDUZ)
ElseIf nOrdem == 5
   dbSelectArea("SED")
   dbSeek(xFilial()+cCarAnt)
   @li,000 PSAY "S U B - T O T A L ----> "
   @li,030 PSAY cCarAnt + " "+ED_DESCRIC
   dbSelectArea("SE1")
ElseIF nOrdem == 7
   @li,000 PSAY "S U B - T O T A L ----> "
   @li,030 PSAY SubStr(cCarAnt,7,2)+"/"+SubStr(cCarAnt,5,2)+"/"+SubStr(cCarAnt,3,2)+" - "+SubStr(cCarAnt,9,3)
ElseIf nOrdem == 8
   @li,000 PSAY SA1->A1_COD+" "+SA1->A1_NOME+" "+SA1->A1_TEL
ElseIf nOrdem == 9
   @li,000 PSAY SubStr(cCarant,1,3)+" "+SA6->A6_NREDUZ + SubStr(cCarant,4,1) + " "+aSituaca[Val(SubStr(cCarant,4,1))+1]
ElseIf nOrdem == 10
   @li,000 PSAY SubStr(cCarant,1,3)+" "+SA6->A6_NREDUZ
ElseIf nOrdem == 11
   @li,000 PSAY "S U B - T O T A L ----> "
   _cNomeVend   :=  Alltrim(Iif(!Empty(SE1->E1_VEND1),Posicione("SA3",1,xFilial("SA3")+SE1->E1_VEND1,"A3_NREDUZ"),"*** TITULOS SEM VENDEDOR ***"))
   _cEstVend    :=  Iif(!Empty(SE1->E1_VEND1),Posicione("SA3",1,xFilial("SA3")+SE1->E1_VEND1,"A3_EST"),"")
   @li,030 PSAY SE1->E1_VEND1 +" "+_cNomeVend+" - "+_cEstVend
EndIf

If nOrdem == 11
    @li,104 PSAY nVend0        Picture TM(nTit0,14)
Else
    @li,104 PSAY nTit0         Picture TM(nTit0,14)
EndIf

IF nTotJur > 0
// @li,178 PSAY nTotJur            Picture TM(nTotJur,12)
EndIF

Li:= Li + 1

If nOrdem == 11
    Li:= Li + 1
   //----> VERIFICA SE E USO EXTERNO E IMPRIME UM VENDEDOR POR FOLHA
   If mv_par16 == 2
        cabec(@titulo,cabec1,cabec2,nomeprog,tamanho)
   EndIf
EndIf

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TotGer130³ Autor ³ Paulo Boschetti       ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprimir total do relatorio                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TotGer130()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function TotGer130
Static Function TotGer130()

Li:= Li + 1
@li,000 PSAY "T O T A L   G E R A L ----> "
@li,030 PSAY "("+ALLTRIM(STR(nTotTit))+" "+IIF(nTotTit > 1,"TITULOS","TITULO")+")"
@li,104 PSAY nTot0        Picture TM(nTot0,14)

Li:= Li + 2

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ImpMes130 ³ Autor ³ Vinicius Barreira     ³ Data ³ 12.12.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³IMPRIMIR TOTAL DO RELATORIO - QUEBRA POR MES                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpMes130()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ImpMes130
Static Function ImpMes130()
Li:= Li + 1
@li,000 PSAY "T O T A L   D O  M E S ---> "
@li,030 PSAY "("+ALLTRIM(STR(nMesTTit))+" "+IIF(nMesTTit > 1,"TITULOS","TITULO")+")"
@li,104 PSAY nMesTit0   Picture TM(nMesTit0,14)

Li:= Li + 2

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³fr130Cheq ³ Autor ³ Vinicius Barreira     ³ Data ³ 12.12.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta Indregua para impressao do relat¢rio                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function fr130cheq
Static Function fr130cheq()

IF !RddName()=="TOPCONN"
	cString := 'E1_PORTADO>="'+mv_par07+'" .And. '
    cSTring := cString + 'E1_PORTADO<= "'+mv_par08+'"'
	Return cString
Else
	cString := 'E1_PORTADO>="'+mv_par07+'" .And. '
    cSTring := cString + 'E1_PORTADO<= "'+mv_par08+'"'
	Return cString
EndIF

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)

    aRegs := {}

    aadd(aRegs,{cPerg,'01','Do Cliente         ? ','mv_ch1','C',06, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','','SA1'})
    aadd(aRegs,{cPerg,'02','Ate o Cliente      ? ','mv_ch2','C',06, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','','SA1'})
    aadd(aRegs,{cPerg,'03','Do Prefixo         ? ','mv_ch3','C',03, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'04','Ate o Prefixo      ? ','mv_ch4','C',03, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'05','Do Titulo          ? ','mv_ch5','C',06, 0, 0,'G', '', 'mv_par05','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'06','Ate o Titulo       ? ','mv_ch6','C',06, 0, 0,'G', '', 'mv_par06','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'07','Do Banco           ? ','mv_ch7','C',03, 0, 0,'G', '', 'mv_par07','','','','','','','','','','','','','','','SA6'})
    aadd(aRegs,{cPerg,'08','Ate o Banco        ? ','mv_ch8','C',03, 0, 0,'G', '', 'mv_par08','','','','','','','','','','','','','','','SA6'})
    aadd(aRegs,{cPerg,'09','Do Vencimento      ? ','mv_ch9','D',08, 0, 0,'G', '', 'mv_par09','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'10','Ate o Vencimento   ? ','mv_cha','D',08, 0, 0,'G', '', 'mv_par10','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'11','Da Natureza        ? ','mv_chb','C',10, 0, 0,'G', '', 'mv_par11','','','','','','','','','','','','','','','SED'})
    aadd(aRegs,{cPerg,'12','Ate a Natureza     ? ','mv_chc','C',10, 0, 0,'G', '', 'mv_par12','','','','','','','','','','','','','','','SED'})
    aadd(aRegs,{cPerg,'13','Da Emissao         ? ','mv_chd','D',08, 0, 0,'G', '', 'mv_par13','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'14','Ate a Emissao      ? ','mv_che','D',08, 0, 0,'G', '', 'mv_par14','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'15','Imprime Provisorios? ','mv_chf','N',01, 0, 0,'C', '', 'MV_PAR15','Sim','','','Nao','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'16','Uso do Relatorio   ? ','mv_chg','N',01, 0, 0,'C', '', 'MV_PAR16','Interno','','','Externo','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'17','Impr Tit em Descont? ','mv_chh','N',01, 0, 0,'C', '', 'MV_PAR17','Sim','','','Nao','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'18','Imprime Relatorio  ? ','mv_chi','N',01, 0, 0,'C', '', 'MV_PAR18','Analitico','','','Sintetico','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'19','Considera Data Base? ','mv_chj','N',01, 0, 0,'C', '', 'MV_PAR19','Sim','','','Nao','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'20','Cons Filiais Abaixo? ','mv_chk','N',01, 0, 0,'C', '', 'MV_PAR20','Sim','','','Nao','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'21','Da Filial          ? ','mv_chl','C',02, 0, 0,'G', '', 'MV_PAR21','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'22','Ate a Filial       ? ','mv_chm','C',02, 0, 0,'G', '', 'MV_PAR22','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'23','Da Loja            ? ','mv_chn','C',02, 0, 0,'G', '', 'MV_PAR23','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'24','Ate a Loja         ? ','mv_cho','C',02, 0, 0,'G', '', 'MV_PAR24','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'25','Considera Adiantam.? ','mv_chp','N',01, 0, 0,'C', '', 'MV_PAR25','Sim','','','Nao','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'26','Da Data Contabil   ? ','mv_chq','D',08, 0, 0,'G', '', 'MV_PAR26','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'27','Ate a Data Contabil? ','mv_chr','D',08, 0, 0,'G', '', 'MV_PAR27','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'28','Imprime Nome       ? ','mv_chs','N',01, 0, 0,'C', '', 'MV_PAR28','Nome Reduzido','','','Razao Social','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'29','Do Vendedor        ? ','mv_cht','C',06, 0, 0,'G', '', 'MV_PAR29','','','','','','','','','','','','','','','SA3'})
    aadd(aRegs,{cPerg,'30','Ate o Vendedor     ? ','mv_chu','C',06, 0, 0,'G', '', 'MV_PAR30','','','','','','','','','','','','','','','SA3'})

    For i:=1 to Len(aRegs)
        Dbseek(cPerg+StrZero(i,2))
        If found() == .f.
            RecLock("SX1",.t.)
            For j:=1 to Fcount()
                FieldPut(j,aRegs[i,j])
            Next
            MsUnLock()
        EndIf
    Next
EndIf

Return
