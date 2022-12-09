#Include "rwmake.ch"         // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#Include "Protheus.ch"       // (28/11/2019 - Luiz)
#Include "TopConn.ch"        // (28/11/2019 - Luiz)

#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Kfat99r()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

Local oFWMsExcel
Local oExcel
Local cArquivo := GetTempPath()+'zTstExc1.xml'


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("AESTRU1,_CTEMP1,WNREL,CDESC1,CDESC2,CDESC3")
SetPrvt("CSTRING,LEND,TAMANHO,LIMITE,TITULO,ARETURN")
SetPrvt("NOMEPROG,NLASTKEY,ADRIVER,CBCONT,CPERG,NLIN")
SetPrvt("M_PAG,_NTOTQTD,_NTOTFAT,_NTOTSAL,_NTOTVLR,_NTQTD")
SetPrvt("_NTFAT,_NTSAL,_NTVLR,_CCHAVE,I,_CNOMECLI")
SetPrvt("_NQTDSALDO,CTITADD1,CABEC1,CABEC2,REGUA1,REGUA2")
SetPrvt("_CINDEX,_LFLAGNAT,_CDESCNATU,_CPEDLINHA,_CAUXCLI,_CAUXPRO")
SetPrvt("_CAUXPED,_DAUXDAT,_CAUXNAT,AREGS,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KFAT07R  ³ Autor ³                       ³ Data ³07/02/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Pedidos de Vendas em Aberto por Natureza        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Kenia Industrias Texteis Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/


aEstru1 :={}
AADD(aEstru1,{"PROD"    ,"C",15,0})
AADD(aEstru1,{"PEDIDO"  ,"C",06,0})
AADD(aEstru1,{"ENTREGA" ,"D",08,0})
AADD(aEstru1,{"EMISSAO" ,"D",08,0})
AADD(aEstru1,{"QUANT"   ,"N",09,2})
AADD(aEstru1,{"QTDFAT"  ,"N",09,2})
AADD(aEstru1,{"QTDSAL"  ,"N",09,2})
AADD(aEstru1,{"VLRSAL"  ,"N",12,2})
AADD(aEstru1,{"CLIENTE" ,"C",06,0})
AADD(aEstru1,{"LOJA"    ,"C",02,0})
AADD(aEstru1,{"NOMEC"   ,"C",13,0})
AADD(aEstru1,{"NATUREZ" ,"C",04,0})
AADD(aEstru1,{"PAPELET" ,"C",01,0})
AADD(aEstru1,{"DT_EMIS" ,"C",10,0})
AADD(aEstru1,{"DT_ENTR" ,"C",10,0})
_cTemp1 := CriaTrab( aEstru1, .T. )  
dbUseArea(.T.,,_cTemp1,"TRB",IF(.T. .OR. .F., !.F., NIL), .F. )


*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

wnrel     := "KFAT07R"
cDesc1    := "Emissao dos pedidos de em aberto considerando a"
cDesc2    := "natureza, conforme parametros selecionados.     "
cDesc3    := " "
cString   := "SC6"
lEnd      := .F.
tamanho   := "M"
limite    := 132
titulo    := "Pedidos de Vendas em Aberto"
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "KFAT07R"
nLastKey  := 0
aDriver   := ReadDriver()
cbCont    := 00
cPerg     := "FAT07R    "
nLin      := 8
m_pag     := 1
_nTotQtd  := 0
_nTotFat  := 0
_nTotSal  := 0
_nTotVlr  := 0
_nTQtd    := 0
_nTFat    := 0
_nTSal    := 0
_nTVlr    := 0

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01  ----> Da Data        ?                                          *
* mv_par02  ----> Ate a Data     ?                                          *
* mv_par03  ----> Do Pedido      ?                                          *
* mv_par04  ----> Ate o Pedido   ?                                          *
* mv_par05  ----> Do Cliente     ?                                          *
* mv_par06  ----> Da Loja        ?                                          *
* mv_par07  ----> Ate o Cliente  ?                                          *
* mv_par08  ----> Ate Loja       ?                                          *
* mv_par09  ----> Do Produto     ?                                          *
* mv_par10  ----> Ate o Produto  ?                                          *
* mv_par11  ----> Indexado por   ? (Entrega/Pedido/Produto/Cliente)         *
* mv_par12  ----> Quais Naturezas?                                          *
*                                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

ValidPerg()     //----> Atualiza o arquivo de perguntas SX1

Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.)

If nLastKey == 27
	Set Filter To
    DbSelectArea("TRB")
    DbCloseArea("TRB")
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
    DbSelectArea("TRB")
    DbCloseArea("TRB")
	Return
Endif

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||RunProc()},"Pedidos de Venda em Aberto")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(RunProc)},"Pedidos de Venda em Aberto")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()


_cQuery :=	""
_cQuery +=	"SELECT C5_NATUREZ,C6_NUM,C5_PAPELET,C6_PRODUTO,C6_CLI,C6_LOJA,A1_NREDUZ,C5_EMISSAO,C6_ENTREG,SUM(C6_QTDVEN) QTDVEN,SUM(C6_QTDENT) QTDENT, SUM((C6_QTDVEN - C6_QTDENT)) SALDO, SUM(((C6_QTDVEN - C6_QTDENT) * C6_PRCVEN)) VLRPEND  FROM SC6010 "
_cQuery +=	"INNER JOIN SA1010 ON A1_COD = C6_CLI AND A1_LOJA = C6_LOJA AND SA1010.D_E_L_E_T_ = '' "
_cQuery +=	"INNER JOIN SC5010 ON C5_NUM = C6_NUM AND C5_TIPO NOT IN ('B','D') AND C5_VEND1 BETWEEN '"+MV_PAR13+"' AND '"+MV_PAR14+"' AND C5_NATUREZ LIKE '%0000%' AND SC5010.D_E_L_E_T_ = '' "
_cQuery +=	"WHERE "
_cQuery +=	"C6_ENTREG BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND "
_cQuery +=	"C6_NUM BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
_cQuery +=	"C6_CLI BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR07+"' AND "
_cQuery +=	"C6_LOJA BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR08+"' AND "
_cQuery +=	"C6_PRODUTO BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' AND "
_cQuery +=	"C6_BLQ NOT IN ('R') AND C6_QTDENT < C6_QTDVEN AND "
_cQuery +=	"SC6010.D_E_L_E_T_ = '' "


//----> por data de entrega
If mv_par11 == 1
	_cQuery +=	"GROUP BY C5_NATUREZ,C6_ENTREG,C6_NUM,C5_PAPELET,C6_PRODUTO,C6_CLI,C6_LOJA,A1_NREDUZ,C5_EMISSAO "
	_cQuery +=	"ORDER BY C5_NATUREZ,C6_ENTREG,C6_NUM,C5_PAPELET,C6_PRODUTO,C6_CLI,C6_LOJA,A1_NREDUZ,C5_EMISSAO  "

//----> por pedido
ElseIf mv_par11 == 2
	_cQuery +=	"GROUP BY C5_NATUREZ,C6_NUM,C5_PAPELET,C6_PRODUTO,C6_CLI,C6_LOJA,A1_NREDUZ,C6_ENTREG,C5_EMISSAO "
	_cQuery +=	"ORDER BY C5_NATUREZ,C6_NUM,C5_PAPELET,C6_PRODUTO,C6_CLI,C6_LOJA,A1_NREDUZ,C6_ENTREG,C5_EMISSAO "

//----> por produto
ElseIf mv_par11 == 3
	_cQuery +=	"GROUP BY C5_NATUREZ,C6_PRODUTO,C5_PAPELET,C6_NUM,C6_CLI,C6_LOJA,A1_NREDUZ,C6_ENTREG,C5_EMISSAO "
	_cQuery +=	"ORDER BY C5_NATUREZ,C6_PRODUTO,C5_PAPELET,C6_NUM,C6_CLI,C6_LOJA,A1_NREDUZ,C6_ENTREG,C5_EMISSAO "

//----> por cliente
ElseIf mv_par11 == 4
	_cQuery +=	"GROUP BY C5_NATUREZ,C6_CLI,C6_LOJA,C6_NUM,C6_PRODUTO,C5_PAPELET,A1_NREDUZ,C6_ENTREG,C5_EMISSAO "
	_cQuery +=	"ORDER BY C5_NATUREZ,C6_CLI,C6_LOJA,C6_NUM,C6_PRODUTO,C5_PAPELET,A1_NREDUZ,C6_ENTREG,C5_EMISSAO "

EndIf

MEMOWRIT("C:\SQLREL.txt",_cQuery)
_cQuery := ChangeQuery(_cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery),"SQL", .F., .T.)

TCSETFIELD( "SQL","C5_EMISSAO","D")
TCSETFIELD( "SQL","C6_ENTREG","D")

dbSelectArea("SQL")
ProcRegua(RecCount())

Do While !Eof()
                                          
    IncProc("Selecionando Dados do Pedido: "+SQL->C6_NUM)
    //----> filtrando intervalo de datas definido nos parametros
    If SQL->SALDO <= 0
        DbSkip()
        Loop
    EndIf

    DbSelectArea("TRB")
    RecLock("TRB",.t.)
      TRB->EMISSAO  :=      SQL->C5_EMISSAO
      TRB->QUANT    :=      SQL->QTDVEN
      TRB->QTDFAT   :=      SQL->QTDENT
      TRB->QTDSAL   :=      SQL->SALDO
      If SQL->C5_PAPELET == "O"
          TRB->VLRSAL   :=      Iif(Dtos(SQL->C5_EMISSAO) > "20030907",((SQL->VLRPEND) * 4),((SQL->VLRPEND) * 2))
      ElseIf SQL->C5_PAPELET == "E"
          TRB->VLRSAL   :=   SQL->VLRPEND * 2
      else
          TRB->VLRSAL   :=      SQL->VLRPEND
      EndIf
      TRB->CLIENTE  :=      SQL->C6_CLI
      TRB->LOJA     :=      SQL->C6_LOJA
      TRB->NOMEC    :=      SQL->A1_NREDUZ
      TRB->ENTREGA  :=      SQL->C6_ENTREG
      TRB->PEDIDO   :=      SQL->C6_NUM
      TRB->PROD     :=      SQL->C6_PRODUTO
      TRB->NATUREZ  :=      SQL->C5_NATUREZ
      TRB->PAPELET  :=      SQL->C5_PAPELET
      TRB->DT_EMIS  :=      SUBS(DTOS(SQL->C5_EMISSAO),7,2)+"/"+SUBS(DTOS(SQL->C5_EMISSAO),5,2)+"/"+SUBS(DTOS(SQL->C5_EMISSAO),1,4)
      TRB->DT_ENTR  :=      SUBS(DTOS(SQL->C6_ENTREG),7,2)+"/"+SUBS(DTOS(SQL->C6_ENTREG),5,2)+"/"+SUBS(DTOS(SQL->C6_ENTREG),1,4)
    MsUnLock()

    DbSelectArea("SQL")
    DbSkip()
EndDo

DbSelectArea("SQL")
DbCloseArea("SQL")
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Impressao do Relatorio                                                    *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

#IFDEF WINDOWS
    RptStatus({|| Imprime()},titulo)// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>     RptStatus({|| Execute(Imprime)},titulo)
#ELSE
    Imprime()
#ENDIF


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Imprime
Static Function Imprime()

// (28/11/2019 - Luiz - Incio bloco - declaração variaveis locais)
Local oFWMsExcel              
Local oExcel
Local cArquivo := GetTempPath()+'zTstExc1.xml'
// (28/11/2019 - Luiz - Fim bloco - declaração variaveis locais)

cTitAdd1:= Iif(mv_par11 == 1," - POR DATA ENTREGA",Iif(mv_par11 == 2," - POR PEDIDO",Iif(mv_par11 == 3," - POR PRODUTO"," - POR CLIENTE")))

cabec1  := "NUMERO IT     DATA DE       CODIGO    NOME DO        CODIGO                QTDE       QTDE       QTDE             VALOR  DATA DE   P "
cabec2  := "PEDIDO        ENTREGA       CLIENTE   CLIENTE        PRODUTO               PEDI       FATU       PEND          PENDENTE  EMISSAO   P "

//regua1:= "0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012"
//regua2:= "         10        20        30        40        50        60        70        80        90       100       110       120       130  "
titulo  := titulo + cTitAdd1

DbSelectArea("TRB")

//----> por data de entrega
If mv_par11 == 1
    _cIndex :=  CriaTrab(Nil,.f.)
    _cChave :=  "TRB->NATUREZ+DTOS(TRB->ENTREGA)+TRB->PEDIDO+TRB->PROD"

//----> por pedido
ElseIf mv_par11 == 2
    _cIndex :=  CriaTrab(Nil,.f.)
    _cChave :=  "TRB->NATUREZ+TRB->PEDIDO+TRB->PROD+DTOS(TRB->ENTREGA)"

//----> por produto
ElseIf mv_par11 == 3
    _cIndex :=  CriaTrab(Nil,.f.)
    _cChave :=  "TRB->NATUREZ+TRB->PROD+TRB->PEDIDO+DTOS(TRB->ENTREGA)"

//----> por cliente
ElseIf mv_par11 == 4
    _cIndex :=  CriaTrab(Nil,.f.)
    _cChave :=  "TRB->NATUREZ+TRB->CLIENTE+TRB->LOJA+TRB->PEDIDO+DTOS(TRB->ENTREGA)"
EndIf

IndRegua("TRB",_cIndex,_cChave,,,"Indexando Dados Relatorio")
DbGoTop()
SetRegua(Lastrec())

@ 00,00 Psay AvalImp(limite)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)

_lFlagNat := .t.

// (28/11/2019 - Luiz - Inicio bloco criação objeto Excel)

//Criando o objeto que ira gerar o conteudo do Excel
oFWMsExcel := FWMSExcel():New()
     
//Aba 01 - Relatorio
oFWMsExcel:AddworkSheet("Relatorio")

Sintaxe
//Criando a Tabela
//FWMsExcelEx():AddColumn(< cWorkSheet >, < cTable >, < cColumn >, < nAlign >, < nFormat >, < lTotal >)
// Alinhamento: 1=esquerda, 2=centro, 3=direira
// Formato: 1=geral, 2=numero, 3=monetario, 4=data
oFWMsExcel:AddTable("Relatorio","Pedidos em Aberto")
oFWMsExcel:AddColumn("Relatorio","Pedidos em Aberto","Produto"      ,1,1)  
oFWMsExcel:AddColumn("Relatorio","Pedidos em Aberto","Pedido"       ,2,1)   
oFWMsExcel:AddColumn("Relatorio","Pedidos em Aberto","Entrega"      ,2,4)
oFWMsExcel:AddColumn("Relatorio","Pedidos em Aberto","Emissao"      ,2,4)
oFWMsExcel:AddColumn("Relatorio","Pedidos em Aberto","Quant"        ,3,2)
oFWMsExcel:AddColumn("Relatorio","Pedidos em Aberto","Qdt Faturada" ,3,2)
oFWMsExcel:AddColumn("Relatorio","Pedidos em Aberto","Qtd Pendente" ,3,2)
oFWMsExcel:AddColumn("Relatorio","Pedidos em Aberto","Vlr Pendente" ,3,2)
oFWMsExcel:AddColumn("Relatorio","Pedidos em Aberto","Cliente"      ,2,1)
oFWMsExcel:AddColumn("Relatorio","Pedidos em Aberto","Loja"         ,2,1)
oFWMsExcel:AddColumn("Relatorio","Pedidos em Aberto","Nome Cliente" ,1,1)
oFWMsExcel:AddColumn("Relatorio","Pedidos em Aberto","Natureza"     ,2,1)
oFWMsExcel:AddColumn("Relatorio","Pedidos em Aberto","Papeleta"     ,2,1)

// (28/11/2019 - Luiz - Final bloco criação objeto Excel)

Do While !Eof()

    IncRegua()

    If _lFlagNat
        _cDescNatu := Posicione("SED",1,xFilial("SED")+TRB->NATUREZ,"SED->ED_DESCRIC")
        @ nLin, 000      Psay Padc("*  *  *  *  *     NATUREZA : "+TRB->NATUREZ+" - "+Alltrim(_cDescNatu)+"     *  *  *  *  *",limite)
        nLin := nLin + 2
        _lFlagNat := .f.
    EndIf

    @ nLin, 000      Psay TRB->PEDIDO
    @ nLin, Pcol()+5 Psay DTOC(TRB->ENTREGA)
    @ nLin, Pcol()+6 Psay TRB->CLIENTE+"/"+TRB->LOJA
    @ nLin, Pcol()+1 Psay TRB->NOMEC  
    @ nLin, Pcol()+2 Psay TRB->PROD 
    @ nLin, Pcol()+1 Psay TRB->QUANT                Picture "@E 999,999.99"
    @ nLin, Pcol()+1 Psay TRB->QTDFAT               Picture "@E 999,999.99"
    @ nLin, Pcol()+1 Psay TRB->QTDSAL               Picture "@E 999,999.99"
    @ nLin, Pcol()+4 Psay TRB->VLRSAL               Picture "@E 999,999,999.99"
    @ nLin, Pcol()+2 Psay DTOC(TRB->EMISSAO)
    @ nLin, Pcol()+2 Psay TRB->PAPELET

    nLin := nLin + 1

    // (28/11/2019 - Incluindo a linha da tabela) 
    oFWMsExcel:AddRow("Relatorio","Pedidos em Aberto",{ TRB->PROD,;
                                                        TRB->PEDIDO,;
                                                        TRB->ENTREGA,;
                                                        TRB->EMISSAO,;
                                                        TRB->QUANT,;  
                                                        TRB->QTDFAT,;  
                                                        TRB->QTDSAL,;
                                                        TRB->VLRSAL,;  
                                                        TRB->CLIENTE,;    
                                                        TRB->LOJA,;
                                                        TRB->NOMEC,;
                                                        TRB->NATUREZ,;
                                                        TRB->PAPELET})
                                                

    //----> totaliza o relatorio
    _nTotQtd := _nTotQtd + TRB->QUANT
    _nTotFat := _nTotFat + TRB->QTDFAT
    _nTotSal := _nTotSal + TRB->QTDSAL
    _nTotVlr := _nTotVlr + TRB->VLRSAL

    _nTQtd := _nTQtd + TRB->QUANT
    _nTFat := _nTFat + TRB->QTDFAT
    _nTSal := _nTSal + TRB->QTDSAL
    _nTVlr := _nTVlr + TRB->VLRSAL

    _cPedLinha  := TRB->PEDIDO
    _cAuxCli    := TRB->CLIENTE+TRB->LOJA
    _cAuxPro    := TRB->PROD
    _cAuxPed    := TRB->PEDIDO 
    _dAuxDat    := TRB->ENTREGA 
    _cAuxNat    := TRB->NATUREZ

    DbSkip()

    //----> separa naturezas 
    If TRB->NATUREZ #_cAuxNat
        _lFlagNat := .t.
        nLin := nLin + 1
    EndIf

    //----> totaliza por data de entrega
    If TRB->ENTREGA #_dAuxDat .And. mv_par11 == 1
        @ nLin, 000 Psay "Total do Dia     ---> "
        @ nLin, 022 Psay Dtoc(_dAuxDat)
        @ nLin, 068 Psay _nTQtd                      Picture "@E 999,999.99"
        @ nLin, 079 Psay _nTFat                      Picture "@E 999,999.99"
        @ nLin, 090 Psay _nTSal                      Picture "@E 999,999.99"
        @ nLin, 104 Psay _nTVlr                      Picture "@E 999,999,999.99"
        nLin := nLin + 1

        @ nLin, 000 Psay Replicate("-",limite)
        nLin := nLin + 1

        _nTQtd := 0
        _nTFat := 0
        _nTSal := 0
        _nTVlr := 0
    EndIf

    //----> totaliza por pedido
    If TRB->PEDIDO #_cAuxPed .And. mv_par11 == 2
        @ nLin, 000 Psay "Total do Pedido  ---> "
        @ nLin, 022 Psay _cAuxPed
        @ nLin, 068 Psay _nTQtd                      Picture "@E 999,999.99"
        @ nLin, 079 Psay _nTFat                      Picture "@E 999,999.99"
        @ nLin, 090 Psay _nTSal                      Picture "@E 999,999.99"
        @ nLin, 104 Psay _nTVlr                      Picture "@E 999,999,999.99"
        nLin := nLin + 1
        @ nLin, 000 Psay Replicate("-",limite)
        nLin := nLin + 1

        _nTQtd := 0
        _nTFat := 0
        _nTSal := 0
        _nTVlr := 0
    EndIf

    //----> totaliza por produto
    If TRB->PROD #_cAuxPro .And. mv_par11 == 3
        @ nLin, 000 Psay "Total do Produto ---> "
        @ nLin, 022 Psay _cAuxPro                    
        @ nLin, 068 Psay _nTQtd                      Picture "@E 999,999.99"
        @ nLin, 079 Psay _nTFat                      Picture "@E 999,999.99"
        @ nLin, 090 Psay _nTSal                      Picture "@E 999,999.99"
        @ nLin, 104 Psay _nTVlr                      Picture "@E 999,999,999.99"
        nLin := nLin + 1
        @ nLin, 000 Psay Replicate("-",limite)
        nLin := nLin + 1

        _nTQtd := 0
        _nTFat := 0
        _nTSal := 0
        _nTVlr := 0
    EndIf

    //----> totaliza por cliente
    If TRB->CLIENTE+TRB->LOJA #_cAuxCli .And. mv_par11 == 4
        @ nLin, 000 Psay "Total do Cliente ---> "
        @ nLin, 022 Psay _cAuxCli
        @ nLin, 068 Psay _nTQtd                      Picture "@E 999,999.99"
        @ nLin, 079 Psay _nTFat                      Picture "@E 999,999.99"
        @ nLin, 090 Psay _nTSal                      Picture "@E 999,999.99"
        @ nLin, 104 Psay _nTVlr                      Picture "@E 999,999,999.99"
        nLin := nLin + 1
        @ nLin, 000 Psay Replicate("-",limite)
        nLin := nLin + 1

        _nTQtd := 0
        _nTFat := 0
        _nTSal := 0
        _nTVlr := 0
    EndIf

    If nLin > 59
        cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
        nLin := 9
    Endif
EndDo

//----> totaliza total geral do relatorio
nLin := nLin + 1
@ nLin, 000 Psay Replicate("-",limite)
nLin := nLin + 1
@ nLin, 000 Psay "Total Geral ---->"                                           
@ nLin, 068 Psay _nTotQtd   Picture "@E 999,999.99"
@ nLin, 079 Psay _nTotFat   Picture "@E 999,999.99"
@ nLin, 090 Psay _nTotSal   Picture "@E 999,999.99"
@ nLin, 104 Psay _nTotVlr   Picture "@E 999,999,999.99"


// (28/11/2019 - Início da Finalização da Criação do Excel)
//Ativando o arquivo e gerando o xml
oFWMsExcel:Activate()
oFWMsExcel:GetXMLFile(cArquivo)
        
//Abrindo o excel e abrindo o arquivo xml
oExcel := MsExcel():New()            //Abre uma nova conexão com Excel
oExcel:WorkBooks:Open(cArquivo)      //Abre uma planilha
oExcel:SetVisible(.T.)               //Visualiza a planilha
//oExcel:Destroy()                     //Encerra o processo do gerenciador de tarefas

// (28/11/2019 - Término da Finalização da Criação do Excel)


// (28/11/2019 - BLOCO DESABILITADO - INCOMPATILIDADE)
//----> cria um arquivo dbf para importacao no excel
//If !Empty(MV_PAR15)
//	_cNomeDbf := AllTrim(MV_PAR15)
//	Copy To &_cNomeDbf VIA "DBFCDX"
//
//	CpyS2T( _cNomeDbf, "C:\TOTVS12\", .F. )
//   
//	//----> seleciono o SX1 para limpar a 15 pergunta para geracao do dbf para excel
//	DbSelectArea('SX1')
//	If DbSeek('FAT07R15')
//		RecLock('SX1',.F.)
//		SX1->X1_CNT01 := ''
//		MsUnLock()
//	EndIf
//EndIf


Roda(cbCont,"Pedidos",tamanho)

Set Device to Screen

If aReturn[5] == 1 
	Set Printer TO
    dbCommitAll()
    OurSpool(wnrel)
Endif

DbSelectArea("SC6")
RetIndex("SC6")

DbSelectArea("TRB")
DbCloseArea("TRB")
Ferase(_cTemp1+".dbf")
Ferase(_cTemp1+".idx")
Ferase(_cTemp1+".mem")

MS_FLUSH()

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)

    aRegs := {}

    aadd(aRegs,{cPerg,'01','Da Entrega     ? ','mv_ch1','D',08, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'02','Ate a Entrega  ? ','mv_ch2','D',08, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'03','Do Pedido      ? ','mv_ch3','C',06, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'04','Ate o Pedido   ? ','mv_ch4','C',06, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'05','Do Cliente     ? ','mv_ch5','C',06, 0, 0,'G', '', 'mv_par05','','','','','','','','','','','','','','','SA1'})
    aadd(aRegs,{cPerg,'06','Da Loja        ? ','mv_ch6','C',02, 0, 0,'G', '', 'mv_par06','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'07','Ate o Cliente  ? ','mv_ch7','C',06, 0, 0,'G', '', 'mv_par07','','','','','','','','','','','','','','','SA1'})
    aadd(aRegs,{cPerg,'08','Ate a Loja     ? ','mv_ch8','C',02, 0, 0,'G', '', 'mv_par08','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'09','Do Produto     ? ','mv_ch9','C',15, 0, 0,'G', '', 'mv_par09','','','','','','','','','','','','','','','SB1'})
    aadd(aRegs,{cPerg,'10','Ate o Produto  ? ','mv_cha','C',15, 0, 0,'G', '', 'mv_par10','','','','','','','','','','','','','','','SB1'})
    aadd(aRegs,{cPerg,'11','Indexado por   ? ','mv_chb','N',01, 0, 0,'C', '', 'mv_par11','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'12','Quais Naturezas? ','mv_chc','C',30, 0, 0,'G', '', 'mv_par12','','','','','','','','','','','','','','',''})

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

Return()

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Retorna para sua Chamada (KFAT07R)                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

