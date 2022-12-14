#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
//----------------------------------------------------------
/*/{Protheus.doc} RELANALI
Fun??o RELANALI
@param N?o recebe par?metros
@return N?o retorna nada
@author Reinaldo Dias
@owner Totvs S/A
@version Protheus 10, Protheus 11
@since 04/10/2012 - data de revis?o do artefato
 
@sample 
// RELANALI - Relatorio para identificar os produtos com desbalanceamento de saldos.
U_RELANALI()
 
Return
 
@obs Rotina Analise 
Link oficial de rotinas relacionadas: http://tdn.totvs.com.br
 
@project MIT044_RealAnali.doc
@menu \SIGAEST\Atualizacoes\Miscelanea\Acertos\Rel.Analise de Saldos
 
@history
04/10/2012 - Acrescimo de cabecalho Protheus.Doc
05/10/2012 - Inclusao da validacao para ambiente somente TOP.
/*/
//----------------------------------------------------------
User Function RELANALI()
Local   Titulo      := "ANALISE DE SALDOS"
Local   cDesc1      := "Este programa tem como objetivo imprimir relatorio "
Local   cDesc2      := "de acordo com os parametros informados pelo usuario."
Local   cDesc3      := ""
Local   cPict       := ""
Private aOrd        := ""
Private Tamanho     := "G"  // P - 80, M - 132, G - 220
Private Limite      := 220
Private wNrel       := "RELANALI"
Private cPerg       := "RELANALI"
Private cString     
Private nLastKey    := 00
Private nTipo       := 18
Private nLin        := 80
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private Imprime     := .T.
Private lEnd        := .F.
Private lAbortPrint := .F.
Private cbtxt       := Space(10)
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private cFileTMP1
Private cMsSQL      := .T.

#IFDEF TOP
    AjustaSX1() 
    Pergunte(cPerg,.F.)  // Pergunta no SX1
#ELSE
    MsgStop("Essa rotina funciona somente no ambiente TOP.")
    Return
#ENDIF

//?????????????????????????????????????????????????????????????????????????????????????Ŀ
//? Envia controle para a funcao SETPRINT
//???????????????????????????????????????????????????????????????????????????????????????
wNrel := SetPrint(cString,wNrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F., aOrd ,.T. ,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

RptStatus({|| RunReport(Titulo) },Titulo)          

Return


//----------------------------------------------------------
/*/{Protheus.doc} RunReport
Fun??o RunReport
@param Titulo Recebe o titulo do relatorio
@return N?o retorna nada
@author Reinaldo Dias
@owner Totvs S/A
@obs Funcao para imprimir o relatorio.
@history
04/10/2012 - Acrescimo de cabecalho Protheus.Doc
/*/
//----------------------------------------------------------
Static Function RunReport(Titulo)
Private dUltFech := GetMV("MV_ULMES")
Private dDataI   := dUltFech + 1
Private dDataF   := dDataBase

IF dDataF < dDataI
   dDataF := dDataI
Endif

Cabec1   := PADC("DATA FECHAMENTO: "+DTOC(dUltFech)+"  -  PERIODO: "+DTOC(dDataI)+" A "+DTOC(dDataF)+"  -  LOCAL: "+MV_PAR03,Limite)
IF MV_PAR05 == 3  // Endereco
   Cabec2   := "PRODUTO         DESCRICAO                            ENDERECO         LOTE                   SALDO INICIAL              MOVIMENTACAO               SALDO ATUAL  STATUS"
Else
   Cabec2   := "PRODUTO         DESCRICAO                            LOTE                   SALDO INICIAL              MOVIMENTACAO               SALDO ATUAL  STATUS"
Endif   
cPict    := "@E 999,999,999.99999" //PesqPict('SB2','B2_QATU')

IF MV_PAR06 = 2 .OR. MV_PAR06 = 3
   cMsSQL := .F.
Endif
/*                                                                                       
PRODUTO         DESCRICAO                            LOTE                   SALDO INICIAL              MOVIMENTACAO               SALDO ATUAL  STATUS
XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXX  SB9 => 999,999,999.99999  KAR => 999,999,999.99999  SB2 => 999,999,999.99999  XXXXXX   Problema: SB2 <> SB8 ou SB2 <> SBF+SDA ou SB8 <> SBF+SDA      
                                                                 SBJ => 999,999,999.99999  SD5 => 999,999,999.99999  SB8 => 999,999,999.99999  Problema
                                                                 SBK => 999,999,999.99999  SDB => 999,999,999.99999  SBF => 999,999,999.99999           
                                                                                           SDA => 999,999,999.99999  SDA => 999,999,999.99999  SDA+SBF => 999,999,999.99999
                16                                   53          65     72                 91     98                 117    124                143        154
*/

/*                                                                                     
PRODUTO         DESCRICAO                            ENDERECO         LOTE                   SALDO INICIAL              MOVIMENTACAO               SALDO ATUAL  STATUS
XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXX  XXXXXXXXXX  SBK => 999,999,999.99999  SDB => 999,999,999.99999  SBF => 999,999,999.99999  Problema
                16                                   53               70          82     89                 108    115                134    141                160
*/

CriaTMP1()

IF MV_PAR05 == 3  // Endereco
   CalcEndereco(Space(15))
   ImprEndereco(Titulo)
Else
   CalcSaldos(Space(15))
   ImprSaldos(Titulo)
Endif   

Return


//----------------------------------------------------------
/*/{Protheus.doc} CalcSaldos
Fun??o CalcSaldos
@param cProduto codigo do produto.
@return N?o retorna nada
@author Reinaldo Dias
@owner Totvs S/A
@obs Funcao para calcular os saldos.
@history
04/10/2012 - Acrescimo de cabecalho Protheus.Doc
/*/
//----------------------------------------------------------
Static Function CalcSaldos(cProduto)
Local aArea := GetArea()

//Processando Saldo Inicial
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IF MV_PAR05 = 1
   cQuery := " SELECT B9_COD,SUM(B9_QINI) AS B9_QINI FROM "+RETSQLNAME('SB9')+" WHERE B9_FILIAL='"+xFilial("SB9")+"' AND B9_LOCAL='"+MV_PAR03+"' AND D_E_L_E_T_ <> '*'" 
   cQuery += " AND B9_DATA = '"+DTOS(dUltFech)+"'"
   IF !Empty(cProduto)
      cQuery += " AND B9_COD = '"+cProduto+"'"
   Else
      cQuery += " AND B9_COD >= '"+MV_PAR01+"' AND B9_COD <= '"+MV_PAR02+"'"
   Endif                                                                    
   cQuery += " GROUP BY B9_COD"
   cQuery := ChangeQuery(cQuery)
   DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySB9",.F.,.T.)
   While !Eof()
     DBSelectArea("TMP1")
     IF !DBSeek(QrySB9->B9_COD)
        RecLock("TMP1",.T.)
        TMP1->PRODUTO := QrySB9->B9_COD
     Else
        RecLock("TMP1",.F.)
     Endif  
     TMP1->SB9 := QrySB9->B9_QINI
     MsUnlock()
     DBSelectArea("QrySB9")
     DBSkip()
   Enddo
   DBCloseArea()

   cQuery := " SELECT BJ_COD,SUM(BJ_QINI) AS BJ_QINI FROM "+RETSQLNAME('SBJ')+" WHERE BJ_FILIAL='"+xFilial("SBJ")+"' AND BJ_LOCAL='"+MV_PAR03+"' AND D_E_L_E_T_ <> '*'" 
   cQuery += " AND BJ_DATA = '"+DTOS(dUltFech)+"'" 
   IF !Empty(cProduto)
      cQuery += " AND BJ_COD = '"+cProduto+"'"
   Else 
      cQuery += " AND BJ_COD >= '"+MV_PAR01+"' AND BJ_COD <= '"+MV_PAR02+"'"
   Endif       
   cQuery += " GROUP BY BJ_COD"   
   cQuery := ChangeQuery(cQuery)
   DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySBJ",.F.,.T.)
   While !Eof()
     DBSelectArea("TMP1")
     IF !DBSeek(QrySBJ->BJ_COD)
        RecLock("TMP1",.T.)
        TMP1->PRODUTO := QrySBJ->BJ_COD
     Else
        RecLock("TMP1",.F.)
     Endif  
     TMP1->SBJ := QrySBJ->BJ_QINI
     TMP1->SD5 := QrySBJ->BJ_QINI
     MsUnlock()
     DBSelectArea("QrySBJ")
     DBSkip()
   Enddo
   DBCloseArea()

   cQuery := " SELECT BK_COD,SUM(BK_QINI) AS BK_QINI FROM "+RETSQLNAME('SBK')+" WHERE BK_FILIAL='"+xFilial("SBK")+"' AND BK_LOCAL='"+MV_PAR03+"' AND D_E_L_E_T_ <> '*'"
   cQuery += " AND BK_DATA = '"+DTOS(dUltFech)+"'"
   IF !Empty(cProduto)
      cQuery += " AND BK_COD = '"+cProduto+"'"
   Else           
      cQuery += " AND BK_COD >= '"+MV_PAR01+"' AND BK_COD <= '"+MV_PAR02+"'"
   Endif       
   cQuery += " GROUP BY BK_COD"   
   cQuery := ChangeQuery(cQuery)
   DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySBK",.F.,.T.)
   While !Eof()
     DBSelectArea("TMP1")
     IF !DBSeek(QrySBK->BK_COD)
        RecLock("TMP1",.T.)
        TMP1->PRODUTO := QrySBK->BK_COD
     Else
        RecLock("TMP1",.F.)
     Endif  
     TMP1->SBK := QrySBK->BK_QINI
     TMP1->SDB := QrySBK->BK_QINI
     MsUnlock()
     DBSelectArea("QrySBK")
     DBSkip()
   Enddo
   DBCloseArea()

   //Processando Saldo Atual
   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   cQuery := " SELECT B2_COD,SUM(B2_QATU) AS B2_QATU,SUM(B2_QACLASS) AS B2_QACLASS FROM "+RETSQLNAME('SB2')+" WHERE B2_FILIAL='"+xFilial("SB2")+"' AND B2_LOCAL='"+MV_PAR03+"'"
   cQuery += " AND D_E_L_E_T_ <> '*'"
   IF !Empty(cProduto)
      cQuery += " AND B2_COD = '"+cProduto+"'" 
   Else           
      cQuery += " AND B2_COD >= '"+MV_PAR01+"' AND B2_COD <= '"+MV_PAR02+"'"
   Endif       
   cQuery += " GROUP BY B2_COD"
   cQuery := ChangeQuery(cQuery)
   DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySB2",.F.,.T.)
   While !Eof()
     DBSelectArea("TMP1")
     IF !DBSeek(QrySB2->B2_COD)
        RecLock("TMP1",.T.)
        TMP1->PRODUTO := QrySB2->B2_COD
     Else
        RecLock("TMP1",.F.)
     Endif
     TMP1->SB2    := QrySB2->B2_QATU
     TMP1->SLDSDA := QrySB2->B2_QACLASS
     MsUnlock()
     DBSelectArea("QrySB2")
     DBSkip()
   Enddo
   DBCloseArea()

   cQuery := " SELECT B8_PRODUTO,SUM(B8_SALDO) AS B8_SALDO,SUM(B8_QACLASS) AS B8_QACLASS FROM "+RETSQLNAME('SB8')+" WHERE B8_FILIAL='"+xFilial("SB8")+"' AND B8_LOCAL='"+MV_PAR03+"' AND B8_SALDO <> 0"
   cQuery += " AND D_E_L_E_T_ <> '*'"
   IF !Empty(cProduto)
      cQuery += " AND B8_PRODUTO = '"+cProduto+"'" 
   Else           
      cQuery += " AND B8_PRODUTO >= '"+MV_PAR01+"' AND B8_PRODUTO <= '"+MV_PAR02+"'"
   Endif  
   cQuery += " GROUP BY B8_PRODUTO"
   cQuery := ChangeQuery(cQuery)
   DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySB8",.F.,.T.)
   While !Eof()
     DBSelectArea("TMP1")
     IF !DBSeek(QrySB8->B8_PRODUTO)
        RecLock("TMP1",.T.)
        TMP1->PRODUTO := QrySB8->B8_PRODUTO
     Else
        RecLock("TMP1",.F.)
     Endif
     TMP1->SB8    := QrySB8->B8_SALDO
     TMP1->SLDSDA := QrySB8->B8_QACLASS
     MsUnlock()
     DBSelectArea("QrySB8")
     DBSkip()
   Enddo
   DBCloseArea()

   cQuery := " SELECT BF_PRODUTO,SUM(BF_QUANT) AS BF_QUANT FROM "+RETSQLNAME('SBF')+" WHERE BF_FILIAL='"+xFilial("SBF")+"' AND BF_LOCAL='"+MV_PAR03+"' AND BF_QUANT <> 0"
   cQuery += " AND D_E_L_E_T_ <> '*'"
   IF !Empty(cProduto)
      cQuery += " AND BF_PRODUTO = '"+cProduto+"'"  
   Else           
      cQuery += " AND BF_PRODUTO >= '"+MV_PAR01+"' AND BF_PRODUTO <= '"+MV_PAR02+"'"
   Endif
   cQuery += " GROUP BY BF_PRODUTO"
   cQuery := ChangeQuery(cQuery)
   DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySBF",.F.,.T.)
   While !Eof()
     DBSelectArea("TMP1")
     IF !DBSeek(QrySBF->BF_PRODUTO)
        RecLock("TMP1",.T.)
        TMP1->PRODUTO := QrySBF->BF_PRODUTO
     Else
        RecLock("TMP1",.F.)
     Endif
     TMP1->SBF := QrySBF->BF_QUANT
     MsUnlock()
     DBSelectArea("QrySBF")
     DBSkip()
   Enddo
   DBCloseArea()

   cQuery := " SELECT DA_PRODUTO,SUM(DA_SALDO) AS DA_SALDO  FROM "+RETSQLNAME('SDA')+" WHERE DA_FILIAL='"+xFilial("SDA")+"' AND DA_LOCAL='"+MV_PAR03+"' AND DA_SALDO <> 0"
   cQuery += " AND D_E_L_E_T_ <> '*' AND DA_DATA <= '"+DTOS(dDataF)+"'"
   IF !Empty(cProduto)
      cQuery += " AND DA_PRODUTO = '"+cProduto+"'"  
   Else           
      cQuery += " AND DA_PRODUTO >= '"+MV_PAR01+"' AND DA_PRODUTO <= '"+MV_PAR02+"'"
   Endif       
   cQuery += " GROUP BY DA_PRODUTO"
   cQuery := ChangeQuery(cQuery)
   DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySDA",.F.,.T.)
   While !Eof()
     DBSelectArea("TMP1")
     IF !DBSeek(QrySDA->DA_PRODUTO)
        RecLock("TMP1",.T.)
        TMP1->PRODUTO := QrySDA->DA_PRODUTO
     Else
        RecLock("TMP1",.F.)
     Endif
     TMP1->MOVSDA := QrySDA->DA_SALDO
     MsUnlock()
     DBSelectArea("QrySDA")
     DBSkip()
   Enddo
   DBCloseArea()

   //Processando Movimentacao
   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   DBSelectArea('SB1')
   DBSetOrder(1)
   IF !Empty(cProduto)
      DBSeek(xFilial('SB1')+cProduto)
   Else
      DBSeek(xFilial('SB1')+MV_PAR01,.T.)   
   Endif   
   While !Eof() .AND. IIF(Empty(cProduto),B1_FILIAL+B1_COD <= xFilial('SB1')+MV_PAR02,B1_FILIAL+B1_COD = xFilial('SB1')+cProduto)
     aSaldos := CalcEst(SB1->B1_COD, MV_PAR03, dDataF+1)
     nSaldo  := 0
     IF aSaldos <> Nil .AND. Len(aSaldos) > 0
        nSaldo := aSaldos[1]                        
     Endif   
     DBSelectArea("TMP1")
     IF !DBSeek(SB1->B1_COD)
        RecLock("TMP1",.T.)
        TMP1->PRODUTO := SB1->B1_COD
     Else
        RecLock("TMP1",.F.)
     Endif
     TMP1->KAR := nSaldo
     MsUnlock()
     DBSelectArea("SB1")
     DBSkip()
   Enddo

   IF cMsSQL
      cQuery := " SELECT D5_PRODUTO,ISNULL(SUM(CASE WHEN D5_ORIGLAN<='500' OR SUBSTRING(D5_ORIGLAN,1,2) IN ('DE','PR','MA')  THEN ABS(D5_QUANT)"
      cQuery += "                                   WHEN D5_ORIGLAN >'500'                                                   THEN ABS(D5_QUANT) * -1  END),0) AS D5_QUANT"
      cQuery += " FROM "+RETSQLNAME('SD5')+" WHERE D5_FILIAL='"+xFilial("SD5")+"' AND D5_LOCAL='"+MV_PAR03+"' AND D_E_L_E_T_ <> '*'"
      cQuery += " AND D5_ESTORNO= ' ' AND D5_DATA >= '"+DTOS(dDataI)+"' AND D5_DATA <= '"+DTOS(dDataF)+"'"
   Else
      cQuery := " SELECT D5_PRODUTO,SUM(CASE WHEN D5_ORIGLAN<='500' OR SUBSTR(D5_ORIGLAN,1,2) IN ('DE','PR','MA')  THEN ABS(D5_QUANT)"
      cQuery += "                            WHEN D5_ORIGLAN >'500'                                                THEN ABS(D5_QUANT) * -1  END) AS D5_QUANT"
      cQuery += " FROM "+RETSQLNAME('SD5')+" WHERE D5_FILIAL='"+xFilial("SD5")+"' AND D5_LOCAL='"+MV_PAR03+"' AND D_E_L_E_T_ <> '*'"
      cQuery += " AND D5_ESTORNO= ' ' AND D5_DATA >= '"+DTOS(dDataI)+"' AND D5_DATA <= '"+DTOS(dDataF)+"'"
   Endif
   IF !Empty(cProduto)
      cQuery += " AND D5_PRODUTO = '"+cProduto+"'"  
   Else           
      cQuery += " AND D5_PRODUTO >= '"+MV_PAR01+"' AND D5_PRODUTO <= '"+MV_PAR02+"'"
   Endif          
   cQuery += " GROUP BY D5_PRODUTO"
   cQuery := ChangeQuery(cQuery)
   DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySD5",.F.,.T.)
   While !Eof()
     DBSelectArea("TMP1")
     IF !DBSeek(QrySD5->D5_PRODUTO)
        RecLock("TMP1",.T.)
        TMP1->PRODUTO := QrySD5->D5_PRODUTO
     Else
        RecLock("TMP1",.F.)
     Endif
     TMP1->SD5 += QrySD5->D5_QUANT
     MsUnlock()
     DBSelectArea("QrySD5")
     DBSkip()
   Enddo
   DBCloseArea()

   IF cMsSQL
      cQuery := " SELECT DB_PRODUTO,ISNULL(SUM(CASE WHEN DB_TM<='500' OR SUBSTRING(DB_TM,1,2) IN ('DE','PR','MA')  THEN ABS(DB_QUANT)"
      cQuery += "                                   WHEN DB_TM >'500'                                              THEN ABS(DB_QUANT) * -1  END),0) AS DB_QUANT"
      cQuery += " FROM "+RETSQLNAME('SDB')+" WHERE DB_FILIAL='"+xFilial("SDB")+"' AND DB_LOCAL='"+MV_PAR03+"' AND D_E_L_E_T_ <> '*'"
      cQuery += " AND DB_ESTORNO= ' ' AND DB_ATUEST='S' AND DB_DATA >= '"+DTOS(dDataI)+"' AND DB_DATA <= '"+DTOS(dDataF)+"'"
   Else
      cQuery := " SELECT DB_PRODUTO,SUM(CASE WHEN DB_TM<='500' OR SUBSTR(DB_TM,1,2) IN ('DE','PR','MA')  THEN ABS(DB_QUANT)"
      cQuery += "                            WHEN DB_TM >'500'                                           THEN ABS(DB_QUANT) * -1  END) AS DB_QUANT"
      cQuery += " FROM "+RETSQLNAME('SDB')+" WHERE DB_FILIAL='"+xFilial("SDB")+"' AND DB_LOCAL='"+MV_PAR03+"' AND D_E_L_E_T_ <> '*'"
      cQuery += " AND DB_ESTORNO= ' ' AND DB_ATUEST='S' AND DB_DATA >= '"+DTOS(dDataI)+"' AND DB_DATA <= '"+DTOS(dDataF)+"'"
   Endif
   IF !Empty(cProduto)
      cQuery += " AND DB_PRODUTO = '"+cProduto+"'"  
   Else           
      cQuery += " AND DB_PRODUTO >= '"+MV_PAR01+"' AND DB_PRODUTO <= '"+MV_PAR02+"'"
   Endif          
   cQuery += " GROUP BY DB_PRODUTO"
   cQuery := ChangeQuery(cQuery)
   DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySDB",.F.,.T.)
   While !Eof()
     DBSelectArea("TMP1")
     IF !DBSeek(QrySDB->DB_PRODUTO)
        RecLock("TMP1",.T.)
        TMP1->PRODUTO := QrySDB->DB_PRODUTO
     Else
        RecLock("TMP1",.F.)
     Endif
     TMP1->SDB += QrySDB->DB_QUANT
     MsUnlock()
     DBSelectArea("QrySDB")
     DBSkip()
   Enddo
   DBCloseArea()

Else // Por Lote
   cQuery := " SELECT BJ_COD,BJ_LOTECTL,SUM(BJ_QINI) AS BJ_QINI FROM "+RETSQLNAME('SBJ')+" WHERE BJ_FILIAL='"+xFilial("SBJ")+"' AND BJ_LOCAL='"+MV_PAR03+"' AND D_E_L_E_T_ <> '*'" 
   cQuery += " AND BJ_DATA = '"+DTOS(dUltFech)+"'"
   IF !Empty(cProduto)
      cQuery += " AND BJ_COD = '"+cProduto+"'"  
   Else           
      cQuery += " AND BJ_COD >= '"+MV_PAR01+"' AND BJ_COD <= '"+MV_PAR02+"'"
   Endif          
   cQuery += " GROUP BY BJ_COD,BJ_LOTECTL"
   cQuery := ChangeQuery(cQuery)
   DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySBJ",.F.,.T.)
   While !Eof()
     DBSelectArea("TMP1")
     IF !DBSeek(QrySBJ->BJ_COD+QrySBJ->BJ_LOTECTL)
        RecLock("TMP1",.T.)
        TMP1->PRODUTO := QrySBJ->BJ_COD
        TMP1->LOTE    := QrySBJ->BJ_LOTECTL
     Else
        RecLock("TMP1",.F.)
     Endif  
     TMP1->SBJ := QrySBJ->BJ_QINI
     TMP1->SD5 := QrySBJ->BJ_QINI
     MsUnlock()
     DBSelectArea("QrySBJ")
     DBSkip()
   Enddo
   DBCloseArea()

   cQuery := " SELECT BK_COD,BK_LOTECTL,SUM(BK_QINI) AS BK_QINI FROM "+RETSQLNAME('SBK')+" WHERE BK_FILIAL='"+xFilial("SBK")+"' AND BK_LOCAL='"+MV_PAR03+"' AND D_E_L_E_T_ <> '*'"
   cQuery += " AND BK_DATA = '"+DTOS(dUltFech)+"'" 
   IF !Empty(cProduto)
      cQuery += " AND BK_COD = '"+cProduto+"'"  
   Else           
      cQuery += " AND BK_COD >= '"+MV_PAR01+"' AND BK_COD <= '"+MV_PAR02+"'"
   Endif          
   cQuery += " GROUP BY BK_COD,BK_LOTECTL"
   cQuery := ChangeQuery(cQuery)
   DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySBK",.F.,.T.)
   While !Eof()
     DBSelectArea("TMP1")
     IF !DBSeek(QrySBK->BK_COD+QrySBK->BK_LOTECTL)
        RecLock("TMP1",.T.)
        TMP1->PRODUTO := QrySBK->BK_COD
        TMP1->LOTE    := QrySBK->BK_LOTECTL
     Else
        RecLock("TMP1",.F.)
     Endif  
     TMP1->SBK := QrySBK->BK_QINI
     TMP1->SDB := QrySBK->BK_QINI
     MsUnlock()
     DBSelectArea("QrySBK")
     DBSkip()
   Enddo
   DBCloseArea()

   cQuery := " SELECT B8_PRODUTO,B8_LOTECTL,SUM(B8_SALDO) AS B8_SALDO,SUM(B8_QACLASS) AS B8_QACLASS FROM "+RETSQLNAME('SB8')+" WHERE B8_FILIAL='"+xFilial("SB8")+"' AND B8_LOCAL='"+MV_PAR03+"' AND B8_SALDO <> 0"
   cQuery += " AND D_E_L_E_T_ <> '*'"
   IF !Empty(cProduto)
      cQuery += " AND B8_PRODUTO = '"+cProduto+"'"  
   Else           
      cQuery += " AND B8_PRODUTO >= '"+MV_PAR01+"' AND B8_PRODUTO <= '"+MV_PAR02+"'"
   Endif          
   cQuery += " GROUP BY B8_PRODUTO,B8_LOTECTL"
   cQuery := ChangeQuery(cQuery)
   DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySB8",.F.,.T.)
   While !Eof()
     DBSelectArea("TMP1")
     IF !DBSeek(QrySB8->B8_PRODUTO+QrySB8->B8_LOTECTL)
        RecLock("TMP1",.T.)
        TMP1->PRODUTO := QrySB8->B8_PRODUTO
        TMP1->LOTE    := QrySB8->B8_LOTECTL
     Else
        RecLock("TMP1",.F.)
     Endif
     TMP1->SB8    := QrySB8->B8_SALDO
     TMP1->SLDSDA := QrySB8->B8_QACLASS
     MsUnlock()
     DBSelectArea("QrySB8")
     DBSkip()
   Enddo
   DBCloseArea()

   cQuery := " SELECT BF_PRODUTO,BF_LOTECTL,SUM(BF_QUANT) AS BF_QUANT FROM "+RETSQLNAME('SBF')+" WHERE BF_FILIAL='"+xFilial("SBF")+"' AND BF_LOCAL='"+MV_PAR03+"' AND BF_QUANT <> 0"
   cQuery += " AND D_E_L_E_T_ <> '*'"
   IF !Empty(cProduto)
      cQuery += " AND BF_PRODUTO = '"+cProduto+"'"  
   Else           
      cQuery += " AND BF_PRODUTO >= '"+MV_PAR01+"' AND BF_PRODUTO <= '"+MV_PAR02+"'"
   Endif          
   cQuery += " GROUP BY BF_PRODUTO,BF_LOTECTL"
   cQuery := ChangeQuery(cQuery)
   DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySBF",.F.,.T.)
   While !Eof()
     DBSelectArea("TMP1")
     IF !DBSeek(QrySBF->BF_PRODUTO+QrySBF->BF_LOTECTL)
        RecLock("TMP1",.T.)
        TMP1->PRODUTO := QrySBF->BF_PRODUTO           
        TMP1->LOTE    := QrySBF->BF_LOTECTL
     Else
        RecLock("TMP1",.F.)
     Endif
     TMP1->SBF := QrySBF->BF_QUANT
     MsUnlock()
     DBSelectArea("QrySBF")
     DBSkip()
   Enddo
   DBCloseArea()

   cQuery := " SELECT DA_PRODUTO,DA_LOTECTL,SUM(DA_SALDO) AS DA_SALDO  FROM "+RETSQLNAME('SDA')+" WHERE DA_FILIAL='"+xFilial("SDA")+"' AND DA_LOCAL='"+MV_PAR03+"' AND DA_SALDO <> 0"
   cQuery += " AND D_E_L_E_T_ <> '*' AND DA_DATA <= '"+DTOS(dDataF)+"'"
   IF !Empty(cProduto)
      cQuery += " AND DA_PRODUTO = '"+cProduto+"'"  
   Else           
      cQuery += " AND DA_PRODUTO >= '"+MV_PAR01+"' AND DA_PRODUTO <= '"+MV_PAR02+"'"
   Endif          
   cQuery += " GROUP BY DA_PRODUTO,DA_LOTECTL"
   cQuery := ChangeQuery(cQuery)
   DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySDA",.F.,.T.)
   While !Eof()
     DBSelectArea("TMP1")
     IF !DBSeek(QrySDA->DA_PRODUTO+QrySDA->DA_LOTECTL)
        RecLock("TMP1",.T.)
        TMP1->PRODUTO := QrySDA->DA_PRODUTO
        TMP1->LOTE    := QrySDA->DA_LOTECTL
     Else
        RecLock("TMP1",.F.)
     Endif
     TMP1->MOVSDA := QrySDA->DA_SALDO
     MsUnlock()
     DBSelectArea("QrySDA")
     DBSkip()
   Enddo
   DBCloseArea()


   //Processando Movimentacao
   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   IF cMsSQL
      cQuery := " SELECT D5_PRODUTO,D5_LOTECTL,ISNULL(SUM(CASE WHEN D5_ORIGLAN<='500' OR SUBSTRING(D5_ORIGLAN,1,2) IN ('DE','PR','MA')  THEN ABS(D5_QUANT)"
      cQuery += "                                              WHEN D5_ORIGLAN >'500'                                                   THEN ABS(D5_QUANT) * -1  END),0) AS D5_QUANT"
      cQuery += " FROM "+RETSQLNAME('SD5')+" WHERE D5_FILIAL='"+xFilial("SD5")+"' AND D5_LOCAL='"+MV_PAR03+"' AND D_E_L_E_T_ <> '*'"
      cQuery += " AND D5_ESTORNO= ' ' AND D5_DATA >= '"+DTOS(dDataI)+"' AND D5_DATA <= '"+DTOS(dDataF)+"'"
   Else
      cQuery := " SELECT D5_PRODUTO,D5_LOTECTL,SUM(CASE WHEN D5_ORIGLAN<='500' OR SUBSTR(D5_ORIGLAN,1,2) IN ('DE','PR','MA')  THEN ABS(D5_QUANT)"
      cQuery += "                                       WHEN D5_ORIGLAN >'500'                                                   THEN ABS(D5_QUANT) * -1  END) AS D5_QUANT"
      cQuery += " FROM "+RETSQLNAME('SD5')+" WHERE D5_FILIAL='"+xFilial("SD5")+"' AND D5_LOCAL='"+MV_PAR03+"' AND D_E_L_E_T_ <> '*'"
      cQuery += " AND D5_ESTORNO= ' ' AND D5_DATA >= '"+DTOS(dDataI)+"' AND D5_DATA <= '"+DTOS(dDataF)+"'"
   Endif
   IF !Empty(cProduto)
      cQuery += " AND D5_PRODUTO = '"+cProduto+"'"  
   Else           
      cQuery += " AND D5_PRODUTO >= '"+MV_PAR01+"' AND D5_PRODUTO <= '"+MV_PAR02+"'"
   Endif          
   cQuery += " GROUP BY D5_PRODUTO,D5_LOTECTL"
   cQuery := ChangeQuery(cQuery)
   DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySD5",.F.,.T.)
   While !Eof()
     DBSelectArea("TMP1")
     IF !DBSeek(QrySD5->D5_PRODUTO+QrySD5->D5_LOTECTL)
        RecLock("TMP1",.T.)
        TMP1->PRODUTO := QrySD5->D5_PRODUTO           
        TMP1->LOTE    := QrySD5->D5_LOTECTL
     Else
        RecLock("TMP1",.F.)
     Endif
     TMP1->SD5 += QrySD5->D5_QUANT
     MsUnlock()
     DBSelectArea("QrySD5")
     DBSkip()
   Enddo
   DBCloseArea()

   IF cMsSQL
      cQuery := " SELECT DB_PRODUTO,DB_LOTECTL,ISNULL(SUM(CASE WHEN DB_TM<='500' OR SUBSTRING(DB_TM,1,2) IN ('DE','PR','MA')  THEN ABS(DB_QUANT)"
      cQuery += "                                   WHEN DB_TM >'500'                                              THEN ABS(DB_QUANT) * -1  END),0) AS DB_QUANT"
      cQuery += " FROM "+RETSQLNAME('SDB')+" WHERE DB_FILIAL='"+xFilial("SDB")+"' AND DB_LOCAL='"+MV_PAR03+"' AND D_E_L_E_T_ <> '*'"
      cQuery += " AND DB_ESTORNO= ' ' AND DB_ATUEST='S' AND DB_DATA >= '"+DTOS(dDataI)+"' AND DB_DATA <= '"+DTOS(dDataF)+"'"
   Else
      cQuery := " SELECT DB_PRODUTO,DB_LOTECTL,SUM(CASE WHEN DB_TM<='500' OR SUBSTR(DB_TM,1,2) IN ('DE','PR','MA')  THEN ABS(DB_QUANT)"
      cQuery += "                                       WHEN DB_TM >'500'                                              THEN ABS(DB_QUANT) * -1  END) AS DB_QUANT"
      cQuery += " FROM "+RETSQLNAME('SDB')+" WHERE DB_FILIAL='"+xFilial("SDB")+"' AND DB_LOCAL='"+MV_PAR03+"' AND D_E_L_E_T_ <> '*'"
      cQuery += " AND DB_ESTORNO= ' ' AND DB_ATUEST='S' AND DB_DATA >= '"+DTOS(dDataI)+"' AND DB_DATA <= '"+DTOS(dDataF)+"'"
   Endif
   IF !Empty(cProduto)
      cQuery += " AND DB_PRODUTO = '"+cProduto+"'"  
   Else           
      cQuery += " AND DB_PRODUTO >= '"+MV_PAR01+"' AND DB_PRODUTO <= '"+MV_PAR02+"'"
   Endif          
   cQuery += " GROUP BY DB_PRODUTO,DB_LOTECTL"
   cQuery := ChangeQuery(cQuery)
   DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySDB",.F.,.T.)
   While !Eof()
     DBSelectArea("TMP1")
     IF !DBSeek(QrySDB->DB_PRODUTO+QrySDB->DB_LOTECTL)
        RecLock("TMP1",.T.)
        TMP1->PRODUTO := QrySDB->DB_PRODUTO
        TMP1->LOTE    := QrySDB->DB_LOTECTL
     Else
        RecLock("TMP1",.F.)
     Endif
     TMP1->SDB += QrySDB->DB_QUANT
     MsUnlock()
     DBSelectArea("QrySDB")
     DBSkip()
   Enddo
   DBCloseArea()
Endif

DBSelectArea("TMP1")

IF Empty(cProduto)
   DBGotop()
Endif

While IIF(Empty(cProduto),!Eof(),!Eof() .AND. cProduto == TMP1->PRODUTO)
  DBSelectArea("SB1")
  DBSetOrder(1)
  DBSeek(xFilial("SB1")+TMP1->PRODUTO)
  
  RecLock("TMP1",.F.)
  TMP1->STATUS := "OK"
  Do Case 
    Case SB1->B1_RASTRO = "L" .AND. SB1->B1_LOCALIZ = "S" 
      IF MV_PAR05 == 1
         Do Case                            
            Case TMP1->KAR == TMP1->SD5 .AND. TMP1->KAR == (TMP1->SDB+TMP1->MOVSDA) .AND. TMP1->SD5 == (TMP1->SDB+TMP1->MOVSDA) .AND.;
                 TMP1->SB2 == TMP1->SB8 .AND. TMP1->SB2 == (TMP1->SBF+TMP1->SLDSDA) .AND. TMP1->SB8 == (TMP1->SBF+TMP1->SLDSDA) .AND.;
                 TMP1->KAR == TMP1->SB2 .AND. TMP1->SD5 == TMP1->SB8               .AND. (TMP1->SDB+TMP1->MOVSDA) == (TMP1->SBF+TMP1->SLDSDA); TMP1->STATUS := "OK"
            Case TMP1->KAR <> TMP1->SD5 .OR. TMP1->KAR <> (TMP1->SDB+TMP1->MOVSDA) .OR. TMP1->SD5 <> (TMP1->SDB+TMP1->MOVSDA)  ; TMP1->STATUS := "Problema: KAR <> SD5 ou KAR <> SDB+SDA ou SD5 <> SDB+SDA"            
            Case TMP1->KAR <> TMP1->SB2 .OR. TMP1->SD5 <> TMP1->SB8               .OR. TMP1->SDB <> TMP1->SBF                 ; TMP1->STATUS := "Problema: KAR <> SB2 ou SD5 <> SB8 ou SDB <> SBF"
            Case TMP1->SB2 <> TMP1->SB8 .OR. TMP1->SB2 <> (TMP1->SBF+TMP1->SLDSDA) .OR. TMP1->SB8 <> (TMP1->SBF+TMP1->SLDSDA)  ; TMP1->STATUS := "Problema: SB2 <> SB8 ou SB2 <> SBF+SDA ou SB8 <> SBF+SDA"
            Case TMP1->SB9 <> TMP1->SBJ                                                                                     ; TMP1->STATUS := "Analisar: SB9 <> SBJ"
            Case TMP1->SB9 <> TMP1->SBK .OR. TMP1->SBJ <> TMP1->SBK
                 IF TMP1->SBJ < TMP1->SBK
                    TMP1->STATUS := "Problema: SBJ < SBK"
                 Endif   
            Case TMP1->MOVSDA <> TMP1->SLDSDA; TMP1->STATUS := "Problema: MOV.SDA <> SLD.SDA"
         EndCase
      Else
         Do Case
            Case TMP1->SD5 <> (TMP1->SDB+TMP1->MOVSDA)              ; TMP1->STATUS := "Problema: SD5 <> SDB+SDA"
            Case TMP1->SB8 <> (TMP1->SBF+TMP1->SLDSDA)              ; TMP1->STATUS := "Problema: SB8 <> SBF+SDA"
            Case TMP1->SD5 <> TMP1->SB8                             ; TMP1->STATUS := "Problema: SD5 <> SB8"
            Case (TMP1->SDB+TMP1->MOVSDA) <> (TMP1->SBF+TMP1->SLDSDA); TMP1->STATUS := "Problema: SDB+SDA <> SBF+SDA"
            Case TMP1->MOVSDA <> TMP1->SLDSDA                       ; TMP1->STATUS := "Problema: MOV.SDA <> SLD.SDA"                                        
            Case TMP1->SBJ < TMP1->SBK                              ; TMP1->STATUS := "Problema: SBJ < SBK"                                        
          EndCase
      Endif   
    Case SB1->B1_LOCALIZ = "S" 
         Do Case                            
            Case TMP1->KAR == (TMP1->SDB+TMP1->MOVSDA) .AND. TMP1->SB2 == (TMP1->SBF+TMP1->SLDSDA) .AND. TMP1->KAR == TMP1->SB2 .AND. (TMP1->SDB+TMP1->MOVSDA) == (TMP1->SBF+TMP1->SLDSDA); TMP1->STATUS := "OK"
            Case TMP1->KAR <> (TMP1->SDB+TMP1->MOVSDA)             ; TMP1->STATUS := "Problema: KAR <> SDB+SDA"
            Case TMP1->KAR <> TMP1->SB2 .OR. TMP1->SDB <> TMP1->SBF ; TMP1->STATUS := "Problema: KAR <> SB2 ou SDB <> SBF"
            Case TMP1->SB2 <> (TMP1->SBF+TMP1->SLDSDA)             ; TMP1->STATUS := "Problema: SB2 <> SBF+SDA"
            Case TMP1->MOVSDA <> TMP1->SLDSDA                      ; TMP1->STATUS := "Problema: MOV.SDA <> SLD.SDA"
         EndCase
    Case SB1->B1_RASTRO = "L" 
         Do Case                            
            Case TMP1->KAR == TMP1->SD5 .AND. TMP1->SD5 == (TMP1->SDB+TMP1->MOVSDA) .AND. TMP1->SB2 == TMP1->SB8 .AND. TMP1->KAR == TMP1->SB2 .AND. TMP1->SD5 == TMP1->SB8; TMP1->STATUS := "OK"
            Case TMP1->KAR <> TMP1->SD5                           ; TMP1->STATUS := "Problema: KAR ou SD5"
            Case TMP1->KAR <> TMP1->SB2 .OR. TMP1->SD5 <> TMP1->SB8; TMP1->STATUS := "Problema: KAR <> SB2 ou SD4 <> SB8"
            Case TMP1->SB2 <> TMP1->SB8                           ; TMP1->STATUS := "Problema: SB2 <> SB8"
            Case TMP1->SB9 <> TMP1->SBJ                           ; TMP1->STATUS := "Analisar: SB9 <> SBJ"
         EndCase
    Otherwise
      IF TMP1->KAR <> TMP1->SB2
         TMP1->STATUS := "Problema: KAR <> SB2"
      Endif
  EndCase
  IF SB1->B1_TIPO == "MO" //Mao de obra
     DBDelete()
  Endif
  MsUnlock()
  DBSelectArea("TMP1")
  DBSkip()
Enddo

RestArea(aArea)

Return


//----------------------------------------------------------
/*/{Protheus.doc} ImprSaldos
Fun??o ImprSaldos
@param Titulo Recebe o titulo do relatorio
@return N?o retorna nada
@author Reinaldo Dias
@owner Totvs S/A
@obs Funcao para imprimir o saldos.
@history
04/10/2012 - Acrescimo de cabecalho Protheus.Doc
/*/
//----------------------------------------------------------
Static Function ImprSaldos(Titulo)
DBSelectArea("TMP1")
DBGotop()                       

cProduto := TMP1->PRODUTO
nTotProd := 0
nTotErro := 0

While !Eof()
  
  If nLin > 58
     nLin := Cabec(Titulo,Cabec1,Cabec2,wNrel,Tamanho,nTipo)   
     nLin++                                       
  Endif                    

  lImprimir := .T.  
  IF MV_PAR04 = 1 // Com Problemas
     IF TMP1->STATUS = "OK" 
        lImprimir := .F.
     Else 
        CalcSaldos(TMP1->PRODUTO)     
        IF TMP1->STATUS = "OK" 
           lImprimir := .F.
        Endif
     Endif   
  ElseIF MV_PAR04 = 2 // Sem Problemas
     IF TMP1->STATUS <> "OK"         
        CalcSaldos(TMP1->PRODUTO)     
        IF TMP1->STATUS <> "OK"         
           lImprimir := .F.            
        Endif
     Endif    
  Else
     IF TMP1->STATUS <> "OK"         
        CalcSaldos(TMP1->PRODUTO)     
     Endif    
  Endif     

  IF lImprimir
     DBSelectArea("SB1")
     DBSetOrder(1)
     DBSeek(xFilial("SB1")+TMP1->PRODUTO)
     
     IF MV_PAR05 == 2 .AND. cProduto <> TMP1->PRODUTO
        @ nLin,001 PSAY __PrtThinLine()
        nLin ++     
        cProduto := TMP1->PRODUTO
     Endif

     @ nLin,000 PSAY Substr(TMP1->PRODUTO,1,15)
     @ nLin,016 PSAY Substr(SB1->B1_DESC,1,35)
     @ nLin,053 PSAY TMP1->LOTE
     
     lImpProd := .F.
     
     IF MV_PAR05 == 1
        @ nLin,065 PSAY "SB9 =>"
        @ nLin,072 PSAY TMP1->SB9       PICTURE cPict
        @ nLin,091 PSAY "KAR =>" 
        @ nLin,098 PSAY TMP1->KAR       PICTURE cPict
        @ nLin,117 PSAY "SB2 =>" 
        @ nLin,124 PSAY TMP1->SB2       PICTURE cPict
        @ nLin,143 PSAY TMP1->STATUS
        nLin ++     
        IF !Empty(Substr(TMP1->PRODUTO,16,15))
           @ nLin,000 PSAY Substr(TMP1->PRODUTO,16,15)
           lImpProd := .T.
        Endif   
     Endif
     
     @ nLin,065 PSAY "SBJ =>"
     @ nLin,072 PSAY TMP1->SBJ       PICTURE cPict
     @ nLin,091 PSAY "SD5 =>" 
     @ nLin,098 PSAY TMP1->SD5       PICTURE cPict
     @ nLin,117 PSAY "SB8 =>" 
     @ nLin,124 PSAY TMP1->SB8       PICTURE cPict
     IF MV_PAR05 == 2
        @ nLin,143 PSAY TMP1->STATUS
     Endif
     nLin ++     
     IF !lImpProd .And. !Empty(Substr(TMP1->PRODUTO,16,15))
        @ nLin,000 PSAY Substr(TMP1->PRODUTO,16,15)
     Endif   
     @ nLin,065 PSAY "SBK =>"
     @ nLin,072 PSAY TMP1->SBK       PICTURE cPict
     @ nLin,091 PSAY "SDB =>" 
     @ nLin,098 PSAY TMP1->SDB       PICTURE cPict
     @ nLin,117 PSAY "SBF =>" 
     @ nLin,124 PSAY TMP1->SBF       PICTURE cPict
     nLin ++   
     @ nLin,091 PSAY "SDA =>" 
     @ nLin,098 PSAY TMP1->MOVSDA    PICTURE cPict
     @ nLin,117 PSAY "SDA =>" 
     @ nLin,124 PSAY TMP1->SLDSDA    PICTURE cPict
     IF TMP1->SLDSDA <> 0
        @ nLin,143 PSAY "SDA+SBF =>" 
        @ nLin,154 PSAY (TMP1->SBF+TMP1->SLDSDA)    PICTURE cPict
     Endif   
     nLin ++   
     IF MV_PAR05 == 1
        @ nLin,001 PSAY __PrtThinLine()
     Endif   
     nLin ++   
     IF Substr(TMP1->STATUS,1,8) = "Problema"
        nTotErro++
     Endif  
  Endif
    
  DBSelectArea("TMP1")
  DBSkip();nTotProd++
  
Enddo    

@ nLin,001 PSAY __PrtThinLine()                                                                                 
nLin++
@ nLin,001 PSAY "Total de Produtos  ==> "+Trans(nTotProd,'@E 999,999,999')
nLin++
@ nLin,001 PSAY "Total c/ Problemas ==> "+Trans(nTotErro,'@E 999,999,999')
nLin++
@ nLin,001 PSAY __PrtThinLine()

DBSelectArea("TMP1")
DBCloseArea()
FERASE(cFileTMP1+GetDBExtension())
FERASE(cFileTMP1+OrDBagExt())

//?????????????????????????????????????????????????????????????????????Ŀ
//? Finaliza a execucao do relatorio...                                 ?
//???????????????????????????????????????????????????????????????????????
SET DEVICE TO SCREEN

//?????????????????????????????????????????????????????????????????????Ŀ
//? Se impressao em disco, chama o gerenciador de impressao...          ?
//???????????????????????????????????????????????????????????????????????
If aReturn[5]==1
   DBCommitAll()
   SET PRINTER TO
   OurSpool(wNrel)
Endif

MS_FLUSH()

Return


//----------------------------------------------------------
/*/{Protheus.doc} CalcEndereco
Fun??o CalcEndereco
@param cProduto recebo o codigo do produto
@return N?o retorna nada
@author Reinaldo Dias
@owner Totvs S/A
@obs Funcao para calcular o saldo por endereco.
@history
04/10/2012 - Acrescimo de cabecalho Protheus.Doc
/*/
//----------------------------------------------------------
Static Function CalcEndereco(cProduto)
Local aArea    := GetArea()
Local aKarEnde := {}

// Identifica os Enderecos
cQuery := " SELECT DISTINCT BK_COD AS PRODUTO,BK_LOCALIZ AS LOCALIZ,BK_LOTECTL AS LOTECTL FROM "+RETSQLNAME("SBK")
cQuery += " WHERE BK_FILIAL='"+xFilial("SBK")+"' AND BK_LOCAL='"+MV_PAR03+"' AND "+RETSQLNAME("SBK")+".D_E_L_E_T_ <> '*'" 
IF !Empty(cProduto)
   cQuery += " AND BK_COD = '"+cProduto+"'"
Else
   cQuery += " AND BK_COD >= '"+MV_PAR01+"' AND BK_COD <= '"+MV_PAR02+"'"
Endif   
cQuery += " AND BK_DATA = '"+DTOS(dUltFech)+"' AND BK_QINI <> 0"
cQuery += " UNION"
cQuery += " SELECT DISTINCT DB_PRODUTO AS PRODUTO,DB_LOCALIZ AS LOCALIZ,DB_LOTECTL AS LOTECTL FROM "+RETSQLNAME("SDB")
cQuery += " WHERE DB_FILIAL='"+xFilial("SDB")+"' AND DB_LOCAL='"+MV_PAR03+"' AND "+RETSQLNAME("SDB")+".D_E_L_E_T_ <> '*'"
IF !Empty(cProduto)
   cQuery += " AND DB_PRODUTO = '"+cProduto+"'"
Else
   cQuery += " AND DB_PRODUTO >= '"+MV_PAR01+"' AND DB_PRODUTO <= '"+MV_PAR02+"'"
Endif   
cQuery += " AND DB_ESTORNO=' ' AND DB_ATUEST='S' AND DB_DATA >= '"+DTOS(dDataI)+"' AND DB_DATA <= '"+DTOS(dDataF)+"'"
cQuery += " UNION"
cQuery += " SELECT DISTINCT BF_PRODUTO AS PRODUTO,BF_LOCALIZ AS LOCALIZ,BF_LOTECTL AS LOTECTL FROM "+RETSQLNAME("SBF")
cQuery += " WHERE BF_FILIAL='"+xFilial("SBF")+"' AND BF_LOCAL='"+MV_PAR03+"' AND "+RETSQLNAME("SBF")+".D_E_L_E_T_ <> '*'"
IF !Empty(cProduto)
   cQuery += " AND BF_PRODUTO = '"+cProduto+"'"
Else
   cQuery += " AND BF_PRODUTO >= '"+MV_PAR01+"' AND BF_PRODUTO <= '"+MV_PAR02+"'"
Endif   
cQuery += " AND BF_QUANT <> 0"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QryTMP1",.F.,.T.)
While !Eof()
  // Movimento do SBK
  cQuery := " SELECT BK_LOCALIZ,BK_LOTECTL,SUM(BK_QINI) AS BK_QINI FROM "+RETSQLNAME("SBK")
  cQuery += " WHERE BK_FILIAL='"+xFilial("SBK")+"' AND BK_LOCAL='"+MV_PAR03+"' AND "+RETSQLNAME("SBK")+".D_E_L_E_T_ <> '*'"
  cQuery += " AND BK_COD = '"+QryTMP1->PRODUTO+"' AND BK_DATA = '"+DTOS(dUltFech)+"'"
  cQuery += " AND BK_LOCALIZ  = '"+QryTMP1->LOCALIZ+"' AND BK_LOTECTL  = '"+QryTMP1->LOTECTL+"'"
  cQuery += " GROUP BY BK_LOCALIZ,BK_LOTECTL"           
  cQuery := ChangeQuery(cQuery)
  DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySBK",.F.,.T.)
               //1       ,2       ,3       ,4              ,5               ,6              ,7                ,8
  AAdd(aKarEnde,{"SBK"  ,dUltFech,Space(3),QryTMP1->PRODUTO,QryTMP1->LOCALIZ,QryTMP1->LOTECTL,QrySBK->BK_QINI ,QryTMP1->PRODUTO+QryTMP1->LOCALIZ+QryTMP1->LOTECTL+"A"+Space(6)})
  AAdd(aKarEnde,{"SALDO",dDataF  ,Space(3),QryTMP1->PRODUTO,QryTMP1->LOCALIZ,QryTMP1->LOTECTL,0               ,QryTMP1->PRODUTO+QryTMP1->LOCALIZ+QryTMP1->LOTECTL+"C"+Space(6)})
  DBCloseArea()
  DBSelectArea("QryTMP1")
  DBSkip()
Enddo
DBCloseArea()

// Movimento do SDB
cQuery := " SELECT DB_DATA,DB_TM,DB_PRODUTO,DB_LOCALIZ,DB_LOTECTL,DB_QUANT,DB_NUMSEQ FROM "+RETSQLNAME("SDB")
cQuery += " WHERE DB_FILIAL='"+xFilial("SDB")+"' AND DB_LOCAL='"+MV_PAR03+"' AND "+RETSQLNAME("SDB")+".D_E_L_E_T_ <> '*'"
IF !Empty(cProduto)
   cQuery += " AND DB_PRODUTO = '"+cProduto+"'"
Else
   cQuery += " AND DB_PRODUTO >= '"+MV_PAR01+"' AND DB_PRODUTO <= '"+MV_PAR02+"'"
Endif   
cQuery += " AND DB_ESTORNO=' ' AND DB_ATUEST='S' AND DB_DATA >= '"+DTOS(dDataI)+"' AND DB_DATA <= '"+DTOS(dDataF)+"'"
cQuery += " ORDER BY DB_DATA,DB_NUMSEQ"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySDB",.F.,.T.)
TCSETFIELD( "QrySDB","DB_DATA","D")
While !Eof()
               //1     ,2      ,3    ,4         ,5         ,6         ,7        ,8
  AAdd(aKarEnde,{"SDB",DB_DATA,DB_TM,DB_PRODUTO,DB_LOCALIZ,DB_LOTECTL,DB_QUANT,DB_PRODUTO+DB_LOCALIZ+DB_LOTECTL+"B"+DB_NUMSEQ})
  DBSkip()
Enddo
DBCloseArea()

aSort(aKarEnde,,, { |x,y| y[08]+y[3] > x[08]+x[3] } )   

nSaldo   := 0
nSalSBK  := 0

For I:= 1 To Len(aKarEnde)   
  Do Case
    Case aKarEnde[I,1] == "SBK"
       nSaldo  := aKarEnde[I,7]
       nSalSBK := aKarEnde[I,7]
    Case aKarEnde[I,1] == "SDB"
       nSaldo  += IF(aKarEnde[I,3] <= "500" .OR. Substr(aKarEnde[I,3],1,2) $ 'DE/PR/MA',aKarEnde[I,7],aKarEnde[I,7]*-1)
    Case aKarEnde[I,1] == "SALDO"
       nSalSBF := 0            
       DBSelectArea("SBF")
       DBSetOrder(1) //BF_FILIAL+BF_LOCAL+BF_LOCALIZ+BF_PRODUTO+BF_NUMSERI+BF_LOTECTL+BF_NUMLOTE
       IF DBSeek(xFilial("SBF")+MV_PAR03+aKarEnde[I,5]+aKarEnde[I,4]+Space(20)+aKarEnde[I,6]+Space(6))
          nSalSBF += SBF->BF_QUANT
       Endif   
       DBSelectArea("TMP1")
       IF !DBSeek(aKarEnde[I,4]+aKarEnde[I,5]+aKarEnde[I,6])
          RecLock("TMP1",.T.)
          TMP1->PRODUTO  := aKarEnde[I,4]
          TMP1->ENDERECO := aKarEnde[I,5]
          TMP1->LOTE     := aKarEnde[I,6]
       Else                 
          RecLock("TMP1",.F.)
       Endif   
       TMP1->SBK      := nSalSBK
       TMP1->SDB      := nSaldo
       TMP1->SBF      := nSalSBF
       TMP1->STATUS   := "OK"
       IF nSaldo <> nSalSBF
          TMP1->STATUS := "Problema"
       Endif
       MsUnlock()
       nSalSBK  := 0
  EndCase
Next

RestArea(aArea)

Return


//----------------------------------------------------------
/*/{Protheus.doc} ImprEndereco
Fun??o ImprEndereco
@param Titulo Recebe o titulo do relatorio
@return N?o retorna nada
@author Reinaldo Dias
@owner Totvs S/A
@obs Funcao para imprimir o saldo por endereco.
@history
04/10/2012 - Acrescimo de cabecalho Protheus.Doc
/*/
//----------------------------------------------------------
Static Function ImprEndereco(Titulo)

DBSelectArea("TMP1")
DBGotop()                       

cProduto := ""
nTotProd := 0
nTotErro := 0

While !Eof()
  
  If nLin > 58
     nLin := Cabec(Titulo,Cabec1,Cabec2,wNrel,Tamanho,nTipo)   
     nLin++                                       
  Endif                    

  lImprimir := .T.  
  IF MV_PAR04 = 1 // Com Problemas
     IF TMP1->STATUS = "OK" 
        lImprimir := .F.
     Else
        CalcEndereco(TMP1->PRODUTO)     
        IF TMP1->STATUS = "OK" 
           lImprimir := .F.
        Endif
     Endif   
  ElseIF MV_PAR04 = 2 // Sem Problemas
     IF TMP1->STATUS <> "OK"         
        CalcEndereco(TMP1->PRODUTO)     
        IF TMP1->STATUS <> "OK"         
           lImprimir := .F.            
        Endif
     Endif    
  Else
     IF TMP1->STATUS <> "OK"         
        CalcEndereco(TMP1->PRODUTO)     
     Endif    
  Endif     

  IF lImprimir
     DBSelectArea("SB1")
     DBSetOrder(1)
     DBSeek(xFilial("SB1")+TMP1->PRODUTO)
     
     IF cProduto <> TMP1->PRODUTO
        @ nLin,000 PSAY __PrtThinLine()
        nLin ++     
        @ nLin,000 PSAY TMP1->PRODUTO
        @ nLin,016 PSAY Substr(SB1->B1_DESC,1,35)
        cProduto := TMP1->PRODUTO
     Endif

     @ nLin,053 PSAY TMP1->ENDERECO
     @ nLin,070 PSAY TMP1->LOTE
     @ nLin,082 PSAY "SBK =>"
     @ nLin,089 PSAY TMP1->SBK       PICTURE cPict
     @ nLin,108 PSAY "SDB =>" 
     @ nLin,115 PSAY TMP1->SDB       PICTURE cPict
     @ nLin,134 PSAY "SBF =>" 
     @ nLin,141 PSAY TMP1->SBF       PICTURE cPict
     @ nLin,160 PSAY TMP1->STATUS
     nLin ++     
     IF !Empty(Substr(TMP1->PRODUTO,16,15))
        @ nLin,000 PSAY Substr(TMP1->PRODUTO,16,15)
        nLin ++     
     Endif   
     IF Substr(TMP1->STATUS,1,8) = "Problema"
        nTotErro++
     Endif  
  Endif
    
  DBSelectArea("TMP1")
  DBSkip();nTotProd++
  
Enddo    

@ nLin,001 PSAY __PrtThinLine()                                                                                 
nLin++
@ nLin,001 PSAY "Total de Enderecos ==> "+Trans(nTotProd,'@E 999,999,999')
nLin++
@ nLin,001 PSAY "Total c/ Problemas ==> "+Trans(nTotErro,'@E 999,999,999')
nLin++
@ nLin,001 PSAY __PrtThinLine()

DBSelectArea("TMP1")
DBCloseArea()
FERASE(cFileTMP1+GetDBExtension())
FERASE(cFileTMP1+OrDBagExt())

//?????????????????????????????????????????????????????????????????????Ŀ
//? Finaliza a execucao do relatorio...                                 ?
//???????????????????????????????????????????????????????????????????????
SET DEVICE TO SCREEN

//?????????????????????????????????????????????????????????????????????Ŀ
//? Se impressao em disco, chama o gerenciador de impressao...          ?
//???????????????????????????????????????????????????????????????????????
If aReturn[5]==1
   DBCommitAll()
   SET PRINTER TO
   OurSpool(wNrel)
Endif

MS_FLUSH()

Return


//----------------------------------------------------------
/*/{Protheus.doc} CriaTMP1
Fun??o CriaTMP1
@param N?o recebe par?metros
@return N?o retorna nada
@author Reinaldo Dias
@owner Totvs S/A
@obs Funcao para criar arquivo de trabalho
@history
04/10/2012 - Acrescimo de cabecalho Protheus.Doc
/*/
//----------------------------------------------------------
Static Function CriaTMP1()
Local aCampos := {}
AAdd(aCampos,{"PRODUTO" ,"C",30,0})
AAdd(aCampos,{"LOTE"    ,"C",10,0})
AAdd(aCampos,{"ENDERECO","C",15,0})
AAdd(aCampos,{"SB9"     ,"N",18,4})
AAdd(aCampos,{"SBJ"     ,"N",18,4})
AAdd(aCampos,{"SBK"     ,"N",18,4})
AAdd(aCampos,{"KAR"     ,"N",18,4})
AAdd(aCampos,{"SD5"     ,"N",18,4})
AAdd(aCampos,{"SDB"     ,"N",18,4})
AAdd(aCampos,{"SB2"     ,"N",18,4})
AAdd(aCampos,{"SB8"     ,"N",18,4})
AAdd(aCampos,{"SBF"     ,"N",18,4})
AAdd(aCampos,{"MOVSDA"  ,"N",18,4})
AAdd(aCampos,{"SLDSDA"  ,"N",18,4})
AAdd(aCampos,{"STATUS"  ,"C",60,0})

cFileTMP1 := CriaTrab(aCampos) 
DBCreate(cFileTMP1,aCampos)

DBUseArea(.T.,,cFileTMP1,"TMP1",.F.,.F.) // Exclusivo
Do Case
  Case MV_PAR05 = 1; IndRegua("TMP1",cFileTMP1,"PRODUTO",,,OemToAnsi("Organizando Arquivo.."))
  Case MV_PAR05 = 2; IndRegua("TMP1",cFileTMP1,"PRODUTO+LOTE",,,OemToAnsi("Organizando Arquivo.."))
  Case MV_PAR05 = 3; IndRegua("TMP1",cFileTMP1,"PRODUTO+ENDERECO+LOTE",,,OemToAnsi("Organizando Arquivo.."))
EndCase
DBClearIndex()
DBSetIndex(cFileTMP1+OrdBagExt())

Return      


//----------------------------------------------------------
/*/{Protheus.doc} AjustaSX1
Fun??o AjustaSX1
@param N?o recebe par?metros
@return N?o retorna nada
@author Reinaldo Dias
@owner Totvs S/A
@obs Funcao para criar os parametros do relatorio.
@history
04/10/2012 - Acrescimo de cabecalho Protheus.Doc
/*/
//----------------------------------------------------------
Static Function AjustaSX1()                                                                                                                                       
Local aHelpPor01 := {'Produto Inicial.'}
Local aHelpPor02 := {'Produto Final.'}
Local aHelpPor03 := {'Informe o local.'}
Local aHelpPor04 := {'Tipo de Saldo'}
Local aHelpPor05 := {'Tipo de Analise.'}
Local aHelpPor06 := {'Tipo do Banco de Dados.'}

PutSx1(cPerg,'01','Produto De     ?','','','mv_ch1','C',30, 0, 0,'G','','SB1','','','mv_par01','','','','','','','','','','','','','','','','',aHelpPor01,aHelpPor01,aHelpPor01)
PutSx1(cPerg,'02','Produto Ate    ?','','','mv_ch2','C',30, 0, 0,'G','','SB1','','','mv_par02','','','','','','','','','','','','','','','','',aHelpPor02,aHelpPor02,aHelpPor02)
PutSx1(cPerg,'03','Local          ?','','','mv_ch3','C', 2, 0, 0,'G','',''   ,'','','mv_par03','','','','','','','','','','','','','','','','',aHelpPor03,aHelpPor03,aHelpPor03)                               
PutSx1(cPerg,'04','Tipo           ?','','','mv_ch4','N', 1, 0, 0,'C','',''   ,'','','mv_par04','Com Problemas','','','','Sem Problemas','','','Ambos','','','','','','','','',aHelpPor04,aHelpPor04,aHelpPor04)
PutSx1(cPerg,'05','Analise        ?','','','mv_ch5','N', 1, 0, 0,'C','',''   ,'','','mv_par05','Saldo','','','','Saldo por Lote','','','Saldo p/Endere?o','','','','','','','','',aHelpPor05,aHelpPor05,aHelpPor05)
PutSx1(cPerg,'06','Banco de Dados ?','','','mv_ch5','N', 1, 0, 0,'C','',''   ,'','','mv_par06','MS-SQL','','','','ORACLE','','','DB2','','','','','','','','',aHelpPor06,aHelpPor06,aHelpPor06)

Return NIL