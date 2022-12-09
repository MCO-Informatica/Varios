#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHCEX0001  บAutor  ณRobson Bueno da S   บ Data ณ 27/03/09    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Esta rotina tem a finalidade de gerar fluxo caixa projetadoบฑฑ
ฑฑบ          ณ gerando uma planilha excell                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Customizacao                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function HCEX0004()
                             
Private cPerg    := 'HEX004' 

	// GravaSX1( cPerg )
	if Pergunte( cPerg, .T. )        
		If !ValidaParams()
		    ApMsgStop("****************Verifique os parametros informados************")
		 	Return
		EndIF
		
		If !HCFilRe4()
		    MsgStop("Nใo hแ dados a serem gerados!!!")
		EndIf
    ENDIF
Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSMPR0Que  บAutor  ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Customizacao                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function HCFilRe4()

Local lRet	      := .T.
Local cQuery      := '' 
Local cQuery2     := ''
Local cQuery3     := ''
Local cQuery4	  := ''
Local cQuery5	  := ''	
Local cQuery6	  := ''
Local cvirgula    := ","
Local cNomered  :=""
Local cPV		:=""
Local cPVItem	:=""
LocaL cPVForn	:=""
local dPVData   :=""
Local dPVPrazo  :=""
Local dPvEmb	:=""
Local nPVQtd	:=0
Local cOs		:=""
Local cOsItem	:=""
LocaL cOsForn	:=""
Local dOsData   :=""
Local dOsPrazo  :=""
Local nOsQtd	:=0
Local cPedcli   :="" 
Local cItemCli	:=""                     
Local cPeso     :=""
Local dEmissao  :="" 
Local dInicio   :=Date()
Local dFim      :=Date()+MV_PAR1
lOCAL dHoje
Local nCRReal
Local nCRPrev
Local nCPReal
Local nCPPrev
Local nCPCpas
Local nSaldoDia
Local nSaldoAcum
Local nVencidoNP
Local nSaldo
Local nValPed
Local lAchou:=.F.
Local aVencto  := {}
Private cFilial01 := ""
Private cFilial02 := ""
Private cFilial03 := ""
Private nCt       := 0            
Private cPathLoc  := ""
Private aItens		:= {}
Private aSdoVdas:={}
Private aSdoCpas:={}
              
nCRReal	  :=0
nCRPrev   :=0
nCPReal   :=0
nCPPrev   :=0
nCPCpas   :=0
nSaldoDia :=0
nSaldoAcum:=0
Processa(, "Aguarde.Selecionando Registros...")	
// 1 PARTE PROJETANDO PEDIDOS DE VENDA
// PEDIDOS DE VENDA VENCENDO dHoje
cQuery5 := "SELECT " + CLRF
cQuery5 += "SC6.C6_NUM,SC6.C6_ITEM,SC6.C6_PRODUTO,SC6.C6_DESCRI,SC6.C6_QUANT,SC6.C6_TES,SC6.C6_PRCVEN,SC6.C6_QTDENT,SC5.C5_NUM,SC5.C5_COND,SF4.F4_CODIGO,SF4.F4_DUPLIC,"+CRLF
cQuery5 += "SC6.C6_CLI,SC6.C6_LOJA,SC6.C6_FILIAL,SC5.C5_CLIENTE,SC5.C5_LOJACLI,SC5.C5_FILIAL,SC5.C5_MOEDA,SC6.C6_IPI"+CRLF
cQuery5 += "From " + RetSQLName( 'SC6' ) + " SC6 " + CRLF
cQuery5 += "INNER JOIN " + RetSqlName("SC5") + " SC5 ON" + CRLF
cQuery5 += "SC6.C6_CLI = SC5.C5_CLIENTE AND "+ CRLF
cQuery5 += "SC6.C6_LOJA = SC5.C5_LOJACLI AND "+ CRLF
cQuery5 += "SC6.C6_NUM = SC5.C5_NUM AND "+ CRLF
cQuery5 += "SC6.C6_FILIAL = SC5.C5_FILIAL "+ CRLF 
cQuery5 += "INNER JOIN " + RetSqlName("SF4") + " SF4 ON " + CRLF
cQuery5 += "SF4.F4_CODIGO = SC6.C6_TES " + CRLF
cQuery5 += "WHERE SF4.F4_DUPLIC='S'" + CRLF
cQuery5 += "AND   SC6.C6_QUANT-SC6.C6_QTDENT>0"+CRLF
cQuery5 += "AND   SC6.D_E_L_E_T_ = ' '"
dbUseArea( .T. , 'TOPCONN' , TcGenQry( ,, cQuery5), 'TR5' , .T. , .F. )
TR5->( dbEval( { || nCt++ },, { || !EOF()}))//substitui o numero
TR5->( dbGoTop())
While (!TR5->(EOF()))
    aVencto :={}
    nValPed:=0
    **nValped:=(TR5.C6_QUANT-TR5.C6_QTDENT)*TR5.C6_PRCVEN
    **aVencto := Condicao(nValPed,TR5->C5_COND,TR5.C6_IPI,TR5.C6_DATPRV,0)
    **nCPprev:=nCPPrev+(TR4.E2_SALDO+TR4.E2_ACRESC-(TR4.E2_IRRF+TR4.E2_CSLL+TR4.E2_PIS+TR4.E2_COFINS+TR4.E2_DECRESC))
    dbskip()
ENDDO




cQuery := "SELECT SM2.M2_FILIAL,SM2.M2_DATA,SM2.D_E_L_E_T_"+ CRLF
cQuery += "From " + RetSQLName( 'SM2' ) + " SM2 " + CRLF
cQuery += "WHERE SM2.M2_DATA>= '"	+ DTOS(dInicio) 	+ "' " + CRLF
cQuery += "AND   SM2.M2_DATA<= '"   + DTOS(dFim)    	+ "' " + CRLF 
cQuery += "AND   SM2.D_E_L_E_T_ = ' '"                                                      
dbUseArea( .T. , 'TOPCONN' , TcGenQry( ,, cQuery ), 'TRB' , .T. , .F. )
TRB->( dbEval( { || nCt++ },, { || !EOF() } ) )//substitui o numero
TRB->( dbGoTop() )
// CRIA CABECALHO DA PLANILHA EXCELL                                                                                                                       
//aAdd( aItens,{[1]PEDIDO,[2]ITEM,[3]CODIGO,[4]DESCRICAO,[5]QTD,[6]Unitario,[7]Total,[8]SALDO,[9]PRAZO,[10]REFCLI,[11]PEDCLI,[12]ITEMCLI,[13]OS,[14]ITEM,[15]EMISSAO,[16]FORNECEDOR,[17]QTD,[18]PRAZO,[19]OC,[20]ITEM,[21]EMISSAO,[22]FORNECEDOR,[23]QTD,[24]PRAZO})
If TRB->(EOF())
   lRet := .F.
EndIf
aAdd(aItens,{"DATA","CTAS A RECEBER","PEDIDO VENDA","TOTAL RECEBER","CTAS PAGAR REAL","CTAS PAGAR PREV","ORDEM COMPRA","TOTAL PAGAR", "TOTAL DIA","TOTAL ACUMULADO"})
While (!TRB->(EOF()))
  dHoje:=TRB->M2_DATA
  nCRReal	:=0
  nCRPrev   :=0
  nCPReal   :=0
  nCPPrev   :=0
  nCPCpas   :=0
  nSaldoDia :=0
  // CONTAS A RECEBER VENCENDO dHoje
  cQuery2 := "SELECT " + CLRF
  cQuery2 += "SE1.E1_NUM,SE1.E1_SERIE,SE1.E1_PREFIXO,SE1.E1_TIPO,SE1.E1_EMISSAO,SE1.E1_VENCREA,SE1.E1_IRRF,SE1.E1_CSLL,SE1.E1_PIS,SE1.E1_COFINS,SE1.E1_VALOR,SE1.E1_ACRESC,SE1.E1_DECRESC,SE1.E1_SALDO"+CRLF
  cQuery2 += "From " + RetSQLName( 'SE1' ) + " SE1 " + CRLF
  cQuery2 += "WHERE SE1.E1_VENCREA= '"	+ DTOS(dHoje) 	+ "' " + CRLF
  cQuery2 += "AND   SE1.E1_TIPO IN ('NF ','REC','DP ')"+CRLF
  cQuery2 += "AND   SE1.SALDO>0"+CRLF
  cQuery2 += "AND   SE1.D_E_L_E_T_ = ' '"
  dbUseArea( .T. , 'TOPCONN' , TcGenQry( ,, cQuery2), 'TR2' , .T. , .F. )
  TR2->( dbEval( { || nCt++ },, { || !EOF()}))//substitui o numero
  TR2->( dbGoTop())
  While (!TR2->(EOF()))
    **nCRReal:=nCRReal+(TR2.E1_SALDO+TR2.E1_ACRESC-(TR2.E1_IRRF+TR2.E1_CSLL+TR2.E1_PIS+TR2.E1_COFINS+TR2.E1_DECRESC))
    dbskip()
  ENDDO 
  dbSelectArea("TRB")
  // CONTAS A PAGAR REAL VENCENDO dHoje
  cQuery3 := "SELECT " + CLRF
  cQuery3 += "SE2.E2_NUM,SE2.E2_PREFIXO,SE2.E2_TIPO,SE2.E2_EMISSAO,SE2.E2_VENCREA,SE2.E2_IRRF,SE2.E2_CSLL,SE2.E2_PIS,SE2.E2_COFINS,SE2.E2_VALOR,SE2.E2_ACRESC,SE2.E2_DECRESC,SE2.E2_SALDO"+CRLF
  cQuery3 += "From " + RetSQLName( 'SE2' ) + " SE2 " + CRLF
  cQuery3 += "WHERE SE2.E2_VENCREA= '"	+ DTOS(dHoje) 	+ "' " + CRLF
  cQuery3 += "AND   SE2.E2_TIPO NOT IN ('PR ')"+CRLF
  cQuery3 += "AND   SE2.SALDO>0"+CRLF
  cQuery3 += "AND   SE2.D_E_L_E_T_ = ' '"
  dbUseArea( .T. , 'TOPCONN' , TcGenQry( ,, cQuery3), 'TR3' , .T. , .F. )
  TR3->( dbEval( { || nCt++ },, { || !EOF()}))//substitui o numero
  TR3->( dbGoTop())
  While (!TR3->(EOF()))
    **nCPReal:=nCPReal+(TR3.E2_SALDO+TR3.E2_ACRESC-(TR3.E2_IRRF+TR3.E2_CSLL+TR3.E2_PIS+TR3.E2_COFINS+TR3.E2_DECRESC))
    dbskip()
  ENDDO
  dbSelectArea("TRB")
  // CONTAS A PAGAR PREV VENCENDO dHoje
  cQuery4 := "SELECT " + CLRF
  cQuery4 += "SE2.E2_NUM,SE2.E2_PREFIXO,SE2.E2_TIPO,SE2.E2_EMISSAO,SE2.E2_VENCREA,SE2.E2_IRRF,SE2.E2_CSLL,SE2.E2_PIS,SE2.E2_COFINS,SE2.E2_VALOR,SE2.E2_ACRESC,SE2.E2_DECRESC,SE2.E2_SALDO"+CRLF
  cQuery4 += "From " + RetSQLName( 'SE2' ) + " SE2 " + CRLF
  cQuery4 += "WHERE SE2.E2_VENCREA= '"	+ DTOS(dHoje) 	+ "' " + CRLF
  cQuery4 += "AND   SE2.E2_TIPO IN ('PR ')"+CRLF
  cQuery4 += "AND   SE2.SALDO>0"+CRLF
  cQuery4 += "AND   SE2.D_E_L_E_T_ = ' '"
  dbUseArea( .T. , 'TOPCONN' , TcGenQry( ,, cQuery4), 'TR4' , .T. , .F. )
  TR4->( dbEval( { || nCt++ },, { || !EOF()}))//substitui o numero
  TR4->( dbGoTop())
  While (!TR4->(EOF()))
    **nCPprev:=nCPPrev+(TR4.E2_SALDO+TR4.E2_ACRESC-(TR4.E2_IRRF+TR4.E2_CSLL+TR4.E2_PIS+TR4.E2_COFINS+TR4.E2_DECRESC))
    dbskip()
  ENDDO

  dbSelectArea("TRB")
  // Ordem de Compra Vencendo dHoje
  cQuery6 := "SELECT " + CLRF
  cQuery6 += "SE2.E2_NUM,SE2.E2_SERIE,SE2.E2_PREFIXO,SE2.E2_TIPO,SE2.E2_EMISSAO,SE2.E2_VENCREA,SE2.E2_IRRF,SE2.E2_CSLL,SE2.E2_PIS,SE2.E2_COFINS,SE2.E2_VALOR,SE2.E2_ACRESC,SE2.E2_DECRESC,SE2.E2_SALDO"+CRLF
  cQuery6 += "From " + RetSQLName( 'SE2' ) + " SE2 " + CRLF
  cQuery6 += "WHERE SE2.E2_VENCREA= '"	+ DTOS(dHoje) 	+ "' " + CRLF
  cQuery6 += "AND   SE2.E2_TIPO IN ('PR ')"+CRLF
  cQuery6 += "AND   SE2.SALDO>0"+CRLF
  cQuery6 += "AND   SE2.D_E_L_E_T_ = ' '"
  dbUseArea( .T. , 'TOPCONN' , TcGenQry( ,, cQuery6), 'TR6' , .T. , .F. )
  TR6->( dbEval( { || nCt++ },, { || !EOF()}))//substitui o numero
  TR6->( dbGoTop())
  While (!TR6->(EOF()))
    **nCPprev:=nCPPrev+(TR4.E2_SALDO+TR4.E2_ACRESC-(TR4.E2_IRRF+TR4.E2_CSLL+TR4.E2_PIS+TR4.E2_COFINS+TR4.E2_DECRESC))
    dbskip()
  ENDDO
  dbSelectArea("TRB")
  
  /*                                    
  cQuery += "D2_UM,D2_QUANT,D2_PRCVEN,D2_TOTAL,D2_VALIPI,D2_IPI,D2_VALBRUT,D2_DOC,D2_SERIE, "
  cQuery += "F2_DUPL,F2_PREFIXO,F2_EMISSAO, "
  cQuery += "A1_NOME,A1_NREDUZ,A1_END,A1_MUN,A1_EST,A1_BAIRRO,A1_CEP,A1_DDD,A1_TEL,A1_FAX,A1_CGC,A1_INSCR, "
  cQuery += "C5_MSGCERT "
  */
  // CONTAS A RECEBER VENCENDO dHoje
  /*
  cQuery := "SELECT "
	cQuery += "C6_NUM,C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_MINUTA,C6_CLI,C6_LOJA, "
	cQuery += "D2_UM,D2_QUANT,D2_PRCVEN,D2_TOTAL,D2_VALIPI,D2_IPI,D2_VALBRUT,D2_DOC,D2_SERIE, "
	cQuery += "F2_DUPL,F2_PREFIXO,F2_EMISSAO, "
	cQuery += "A1_NOME,A1_NREDUZ,A1_END,A1_MUN,A1_EST,A1_BAIRRO,A1_CEP,A1_DDD,A1_TEL,A1_FAX,A1_CGC,A1_INSCR, "
	cQuery += "C5_MSGCERT "

cQuery += "FROM " + RetSqlName("SC6") + " SC6 "

cQuery += "INNER JOIN " + RetSqlName("SC5") + " SC5 ON "
	cQuery += "SC6.C6_CLI = SC5.C5_CLIENTE AND "
	cQuery += "SC6.C6_LOJA = SC5.C5_LOJACLI AND "
	cQuery += "SC6.C6_NUM = SC5.C5_NUM AND "
	cQuery += "SC6.C6_FILIAL = SC5.C5_FILIAL " 

cQuery += "INNER JOIN " + RetSqlName("SD2") + " SD2 ON "
	cQuery += "SC6.C6_ITEM = SD2.D2_ITEMPV AND "
	cQuery += "SC6.C6_PRODUTO = SD2.D2_COD AND "
	cQuery += "SC6.C6_CLI = SD2.D2_CLIENTE AND "
	cQuery += "SC6.C6_LOJA = SD2.D2_LOJA AND "
	cQuery += "SC6.C6_NOTA = SD2.D2_DOC AND "
	cQuery += "SC6.C6_SERIE = SD2.D2_SERIE AND "
	cQuery += "SC6.C6_NUM = SD2.D2_PEDIDO AND "
	cQuery += "SC6.C6_FILIAL = SD2.D2_FILIAL " 

cQuery += "LEFT OUTER JOIN " + RetSqlName("SF2") + " SF2 ON "
	cQuery += "SC6.C6_NOTA = SF2.F2_DOC AND "
	cQuery += "SC6.C6_SERIE = SF2.F2_SERIE AND "
	cQuery += "SC6.C6_CLI = SF2.F2_CLIENTE AND "
	cQuery += "SC6.C6_LOJA = SF2.F2_LOJA AND "
	cQuery += "SC6.C6_FILIAL = SF2.F2_FILIAL "

cQuery += "LEFT OUTER JOIN " + RetSqlName("SA1") + " SA1 ON "
	cQuery += "SC6.C6_CLI = SA1.A1_COD AND "
	cQuery += "SC6.C6_LOJA = SA1.A1_LOJA "

if _lOpc //reimpressao

	cQuery += "WHERE "
		cQuery += "SC6.D_E_L_E_T_ = '' AND "
		cQuery += "SC5.D_E_L_E_T_ = '' AND "	
		cQuery += "SD2.D_E_L_E_T_ = '' AND "
		cQuery += "SF2.D_E_L_E_T_ = '' AND "
		cQuery += "SA1.D_E_L_E_T_ = '' AND "
		cQuery += "SC6.C6_MINUTA = '" + mv_par01 + "' "

else //impressao

	cQuery += "WHERE "
		cQuery += "SC6.D_E_L_E_T_ = '' AND "
		cQuery += "SC5.D_E_L_E_T_ = '' AND "	
		cQuery += "SD2.D_E_L_E_T_ = '' AND "
		cQuery += "SF2.D_E_L_E_T_ = '' AND "
		cQuery += "SA1.D_E_L_E_T_ = '' AND "
		cQuery += "SC6.C6_MINUTA = '' AND "
		cQuery += "SC6.C6_NOTA <> '' AND "
		cQuery += "SC6.C6_CLI = '" + mv_par01 + "' AND "
		cQuery += "SC6.C6_LOJA = '" + mv_par02 + "' AND "
		cQuery += "SC6.C6_NUM BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND "
		cQuery += "SF2.F2_EMISSAO BETWEEN '" + DTOS(mv_par05) + "' AND '" + DTOS(mv_par06) + "' "

endif

cQuery += "ORDER BY SC6.C6_NUM, SC6.C6_ITEM, SC6.C6_CLI, SC6.C6_LOJA"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)
*/
  // PEDIDOS DE VENDA VENCENDO dHoje
  // CONTAS A PAGAR REAL VENCENDO dHoje
  // CONTAS A PAGAR PREV VENCENDO dHoje
  // Ordem de Compra Vencendo dHoje
  
  
  
  
  
  cNomered  	:=""
  cNomered:=Posicione("SA2",1,xFilial("SA2")+TRB->C7_FORNECE,"A2_NREDUZ")
  // ABRE A TABELA DE AMARRACAO
  dbSelectArea("SZK")
  DbSetOrder(4)
  MsSeek(xFilial("SZK")+"OC"+TRB->C7_NUM+SUBSTRING(TRB->C7_ITEM,2,3))
  While (SZK->ZK_OC=TRB->C7_NUM .AND. SZK->ZK_ITEM=SUBSTRING(TRB->C7_ITEM,2,3))
    cPv			:=""
    cOs			:=""
    cPvItem		:=""
    cPvForn		:=""
    dPvData   	:=""
    dPvPrazo  	:=""
    dPvEmb		:=""
    nPvQtd		:=0
    cOs			:=""
    cOsItem		:=""
    cOsForn		:=""
    dOsData   	:=""
    dOsPrazo  	:=""
    nOsQtd		:=0
    cPedcli   	:=""
    cItemCli	:=""
    cPeso     	:=""
    dEmissao	:=""
    lAchou:=.T.
    IF MV_PAR10=1 .OR. MV_PAR10=3
      IF SZK->ZK_TIPO="PV" .and. SZK->ZK_QTS>0
        cPV		:=SZK->ZK_REF 	// NUMERO OS
        cPVItem	:=SZK->ZK_REFITEM  
        cPVForn	:=SZK->ZK_NOME
        dPVData   :=DTOS(SZK->ZK_DT_VINC)
        dPVPrazo  :=DTOS(SZK->ZK_PRAZO)
        nPVQtd	:=STR(SZK->ZK_QTD)
        nSaldo:= nSaldo-SZK->ZK_QTS
        cPedCli	:=Posicione("SC5",1,xFilial("SC5")+SZK->ZK_REF,"C5_COTCLI")
        cItemCli	:=Posicione("SC6",1,xFilial("SC6")+SZK->ZK_REF+SUBSTRING(SZK->ZK_REFITEM,1,2),"C6_ITEMCLI")
        dEmissao	:=DTOS(Posicione("SC5",1,xFilial("SC5")+SZK->ZK_REF,"C5_EMISSAO"))
        dPvEmb	:=DTOS(Posicione("SW3",8,xFilial("SW3")+TRB->C7_NUM+"         "+TRB->C7_ITEM,"W3_DT_EMB")) 
        cPeso		:=Posicione("SB1",1,xFilial("SB1")+TRB->C7_PRODUTO,"B1_PESO")		
        // SO INSERE NOVO ITEM SE A TES E DE FATURAMENTO
        if Posicione("SF4",1,xFilial("SF4")+TRB->C7_TES,"F4_DUPLIC")="S" .OR. TRB->C7_TES="   " 
          // CRIA ITENS DA PLANILHA DO EXCELL
          //aAdd( aItens,{"PEDIDO","ITEM","CODIGO","DESCRICAO","QTD","R$ UNITARIO","TOTAL","SALDO","EMISSAO","PRAZO","DT EMBARQUE","REFCLI","PEDCLI","ITEMCLI","PV","ITEM","EMISSAO","CLIENTE","QTD","PRAZO","OS","ITEM","EMISSAO","FORNECEDOR","QTD","PRAZO"})
          IF cPv<>"" 
  	        aAdd( aItens,{cNomered,;
  	      			TRB->C7_NUM,;
                 	TRB->C7_ITEM,;
                 	TRB->C7_PRODUTO,;
                 	TRB->C7_DESCRI,;
                   	ConvType(TRB->C7_QUANT,6,0),;
                 	ConvType(TRB->C7_PRECO,16,2),;
                 	ConvType(TRB->C7_TOTAL,16,2),;
                 	ConvType(nSaldo,6,0),;
                 	ConvType(TRB->C7_EMISSAO,,,"D"),;
                 	ConvType(TRB->C7_DATPRF,,,"D"),;
                 	ConvType(dPvEmb,,,"D"),;
                 	TRB->C7_NUMREF,;
                 	cPedCLi,;
                 	cItemCli,;
                 	cPv,;
                 	cPvItem,;
                 	ConvType(dEmissao,,,"D"),;
                 	cPvForn,;
                 	nPvQtd,;
                 	ConvType(dPvPrazo,,,"D"),;
                 	"",;
                 	"",;
                 	"",;
                 	"",;
                 	"",;
                 	""})
          endif
        ENDIF
      endif
      IF SZK->ZK_TIPO="OS" .and. SZK->ZK_QTS>0
        cOS		:=SZK->ZK_REF 	// NUMERO OS
        cOSItem	:=SZK->ZK_REFITEM  
        cOSForn	:=SZK->ZK_NOME
        dOSData   :=DTOS(SZK->ZK_DT_VINC)
        dOSPrazo  :=DTOS(SZK->ZK_PRAZO)
        nOSQtd	:=STR(SZK->ZK_QTD)
        nSaldo:= nSaldo-SZK->ZK_QTS
        //cPedCli	:=Posicione("SC5",1,xFilial("SC5")+SZK->ZK_REF,"C5_COTCLI")
        //cItemCli	:=Posicione("SC6",1,xFilial("SC6")+SZK->ZK_REF+SZK->ZK_REFITEM,"C5_ITEMCLI")
        dEmissao	:=DTOS(Posicione("AB6",1,xFilial("AB6")+cOs+cOsItem,"AB6_EMISSA"))
        dPvEmb	:=DTOS(Posicione("SW3",8,xFilial("SW3")+TRB->C7_NUM+"         "+TRB->C7_ITEM,"W3_DT_EMB")) 
        cPeso		:=Posicione("SB1",1,xFilial("SB1")+TRB->C7_PRODUTO,"B1_PESO")		
        // SO INSERE NOVO ITEM SE A TES E DE FATURAMENTO
        if Posicione("SF4",1,xFilial("SF4")+TRB->C7_TES,"F4_DUPLIC")="S" .OR. TRB->C7_TES="   " 
          // CRIA ITENS DA PLANILHA DO EXCELL
          //aAdd( aItens,{"PEDIDO","ITEM","CODIGO","DESCRICAO","QTD","R$ UNITARIO","TOTAL","SALDO","EMISSAO","PRAZO","DT EMBARQUE","REFCLI","PEDCLI","ITEMCLI","PV","ITEM","EMISSAO","CLIENTE","QTD","PRAZO","OC","ITEM","EMISSAO","FORNECEDOR","QTD","PRAZO"})
          IF cOs<>"" 
  	        aAdd( aItens,{cNomered,;
  	        			TRB->C7_NUM,;
                    	TRB->C7_ITEM,;
                    	TRB->C7_PRODUTO,;
                    	TRB->C7_DESCRI,;
                     	ConvType(TRB->C7_QUANT,6,0),;
                    	ConvType(TRB->C7_PRECO,16,2),;
                    	ConvType(TRB->C7_TOTAL,16,2),;
                 	    ConvType(nSaldo,6,0),;
                 		ConvType(TRB->C7_EMISSAO,,,"D"),;
                 		ConvType(TRB->C7_DATPRF,,,"D"),;
                 		ConvType(dPvEmb,,,"D"),;
                 		"",;
                 		"",;
                 		"",;
                 		"",;
                 		"",;
                 		"",;
                 		"",;
                 		"",;
                 		"",;
                 		cOs,;
                 		cOsItem,;
                 		ConvType(dEmissao,,,"D"),;
                 		cOsForn,;
                 		nOsQtd,;
                 		ConvType(dOsPrazo,,,"D")})
        	endif
      	ENDIF
      endif
    ENDIF
    dbSelectArea("SZK")
    dbskip()  	
  enddo		
  IF nSaldo>0
  if lAchou=.F. .OR. MV_PAR10<>1
    // SO INSERE NOVO ITEM SE A TES E DE FATURAMENTO
    if Posicione("SF4",1,xFilial("SF4")+TRB->C7_TES,"F4_DUPLIC")="S" .OR. TRB->C7_TES="   " 
      // CRIA ITENS DA PLANILHA DO EXCELL
      //aAdd( aItens,{[1]PEDIDO,[2]ITEM,[3]CODIGO,[4]DESCRICAO,[5]QTD,[6]Unitario,[7]Total,[8]SALDO,[9]PRAZO,[10]REFCLI,[11]PEDCLI,[12]ITEMCLI,[13]OS,[14]ITEM,[15]EMISSAO,[16]FORNECEDOR,[17]QTD,[18]PRAZO,[19]OC,[20]ITEM,[21]EMISSAO,[22]FORNECEDOR,[23]QTD,[24]PRAZO})
      dPvEmb	:=DTOS(Posicione("SW3",8,xFilial("SW3")+TRB->C7_NUM+"         "+TRB->C7_ITEM,"W3_DT_EMB")) 
      aAdd( aItens,{cNomered,;
      				TRB->C7_NUM,;
                 	TRB->C7_ITEM,;
                 	TRB->C7_PRODUTO,;
                 	TRB->C7_DESCRI,;
                   	ConvType(TRB->C7_QUANT,6,0),;
                 	ConvType(TRB->C7_PRECO,16,2),;
                 	ConvType(TRB->C7_TOTAL,16,2),;
                 	ConvType(nSaldo,6,0),;
                 	ConvType(TRB->C7_EMISSAO,,,"D"),;
                 	ConvType(TRB->C7_DATPRF,,,"D"),;
                 	ConvType(dPvEmb,,,"D"),;
                 	"Saldo p/ Estoque",;
                 	"",;
                 	"",;
                 	"",;
                 	"",;
                 	"",;
                 	"",;
                 	"",;
                 	"",;
                 	"",;
                 	"",;
                 	"",;
                 	"",;
                 	"",;
                 	""})
    ENDIF
  endif
  endif
  dbSelectArea("TRB")
  dbskip()
enddo     
TRB->( dbCloseArea() )
If !U_IntegEx3()
	MsgAlert("Opera็ใo cancelada pelo usuแrio!")
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGravaSX1  บAutor  ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Customizacao                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GravaSX1( _cPerg )

Local cDia 	 := AlLTrim( StrZero( Day( Date() ), 2 ) )
Local cMes 	 := AlLTrim( StrZero( Month( Date() ), 2 ) )
Local cAno 	 := Right( Str( Year( Date() ) ), 2 )
Local cData  := "'" + cDia  + "/" + cMes + "/" + cAno + "'"
Local _aArea := GetArea()
Local aRegs  := {}
Local _nI	 := 0
Local J		 := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMontagem do Array de perguntasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd( aRegs, { _cPerg, "01", "Produto de       ?", "Produto De       ?", "Produto De       ?", "mv_ch1" , "C", TamSX3( 'B1_COD' )[1], 0, 0, "G", "", "MV_PAR01", "", "", "", Space( TamSX3( 'B1_COD' )[1] ), "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1", "", "" } )
aAdd( aRegs, { _cPerg, "02", "Produto ate      ?", "Produto Ate      ?", "Produto Ate      ?", "mv_ch2" , "C", TamSX3( 'B1_COD' )[1], 0, 0, "G", "", "MV_PAR02", "", "", "", Replicate( "z", TamSX3( 'B1_COD' )[1] ), "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1", "", "" } )
aAdd( aRegs, { _cPerg, "03", "Cliente de       ?", "Cliente De       ?", "Cliente De       ?", "mv_ch3" , "C", TamSX3( 'A1_COD' )[1], 0, 0, "G", "", "MV_PAR03", "", "", "", Space( TamSX3( 'A1_COD' )[1] ), "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA1", "", "" } )
aAdd( aRegs, { _cPerg, "04", "Cliente ate      ?", "Cliente Ate      ?", "Cliente Ate      ?", "mv_ch4" , "C", TamSX3( 'A1_COD' )[1], 0, 0, "G", "", "MV_PAR04", "", "", "", Replicate( "z", TamSX3( 'A1_COD' )[1] ), "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA1", "", "" } )
aAdd( aRegs, { _cPerg, "05", "Loja De          ?", "Loja De          ?", "Loja De          ?", "mv_ch5" , "C", 2, 0, 0, "G", "", "MV_PAR05", "", "", "", "  ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" } )
aAdd( aRegs, { _cPerg, "06", "Loja Ate         ?", "Loja Ate         ?", "Loja Ate         ?", "mv_ch6" , "C", 2, 0, 0, "G", "", "MV_PAR06", "", "", "", "  ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" } )
aAdd( aRegs, { _cPerg, "07", "Num De           ?", "Num De           ?", "Num De           ?", "mv_ch7" , "C", TamSX3( 'C5_NUM' )[1], 0, 0, "G", "", "MV_PAR07", "", "", "", Space( TamSX3( 'C5_NUM' )[1] ), "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" } )
aAdd( aRegs, { _cPerg, "08", "Num Ate          ?", "Num Ate          ?", "Num Ate          ?", "mv_ch8" , "C", TamSX3( 'C5_NUM' )[1], 0, 0, "G", "", "MV_PAR08", "", "", "", Replicate( "z", TamSX3( 'C5_NUM' )[1] ), "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" } )
aAdd( aRegs, { _cPerg, "09", "Vencto De        ?", "Vencto De        ?", "Vencto De        ?", "mv_ch9" , "D", 8, 0, 0, "G", "", "MV_PAR09", "", "", "", cData, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" } )
aAdd( aRegs, { _cPerg, "10", "Vencto Ate       ?", "Vencto Ate       ?", "Vencto Ate       ?", "mv_chA" , "D", 8, 0, 0, "G", "", "MV_PAR10", "", "", "", cData, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" } )
dbSelectArea( "SX1" )
dbSetOrder( 1 )
For _nI := 1 to Len( aRegs )
	If !dbSeek( _cPerg + aRegs[_nI, 2] )
		RecLock( "SX1", .T. )
		For j := 1 to fCount()
			If j <= Len( aRegs[_nI] )
				FieldPut( j, aRegs[_nI, j] )
			EndIf
		Next
		MsUnLock()
	EndIf
Next

RestArea( _aArea )

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidaParamsบAutor  ณ                            บ Data ณ   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Customizacao                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidaParams()

Local lRet := .T.
Local cMens := ""

If MV_PAR01 > MV_PAR02 //Codigo do Produto
	cMens := " - C๓digo inicial do produto ้ maior que o c๓digo final." + Chr( 10 )
EndIf

If MV_PAR03 > MV_PAR04 //Codigo do Fornecedor
	cMens += " - C๓digo inicial do Cliente ้ maior que o c๓digo final." + Chr( 10 )
EndIf

If DTOS(MV_PAR07) > DTOS(MV_PAR08) //Dt. Movimento
	cMens += " - Data inicial do movimento ้ maior que a data final." + Chr( 10 )
EndIf

If MV_PAR05 > MV_PAR06 //Codigo do Grupo de Produtos
	cMens += " - C๓digo inicial do Pedido ้ maior que o c๓digo final." + Chr( 10 )
EndIf

If Len( cMens ) > 0
	MsgInfo( "Por favor ajuste os parโmetros. Surgiram as seguintes inconsistencias: " + Chr( 10 ) + Chr( 10 ) + cMens )
	lRet := .F.
EndIf

Return lRet
/*                
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIntegExc  บAutor  ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio KARDEX                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCustomizacao                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function IntegEx() // INTEGEX3 - VERIFICACR HCEX0003.PRW POIS LA TEM ESSA FUNวรO

Local lRet	   	:= .T.	
Local cDesc1    := "Esta rotina gera um arquivo em excel contendo as informa็๕es:                     "
Local cDesc2    := "Seguindo os parametros definidos pelo usuario                                     "
Local cDesc3 	:= "Sera salvo um arquivo no diretorio raiz c: Com a informacao extraida na pesquisau "
Local aSay      := {}
Local aButton   := {}
Local nOpc      := 0
Local cTitulo   := "Gera็ใo de Arquivo"

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )

aAdd( aButton, { 5, .T., { || cPathLoc := SelArq()   } } )
aAdd( aButton, { 1, .T., { || nOpc := 1, FechaBatch() } } )
aAdd( aButton, { 2, .T., { || FechaBatch()            } } )

FormBatch( cTitulo, aSay, aButton )
	
If nOpc <> 1
	lRet := .F.
Else
    if Empty(cPathLoc)
    	cPathLoc := "C:\"
    Endif
	Processa({|| ProcInt()}, "Gerando integracao...")	
EndIf

Return lRet		
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcInt   บAutor  ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para gerar um arquivo com extensใo .xls com os      บฑฑ
ฑฑบ          ณ dados filtrados pela query.                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Customizacao                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ProcInt()

Local _aArea    := GetArea() 
Local cPath     := cPathLoc  
Local nHandle   := 0
//Local cArqPesq 	:= cPath + "Posicli.xls"
Local cArqPesq 	:= cPath + "Posicom.xls"
Local cCabHtml  := ""
Local cLinFile  := "" 
Local cFileCont := ""
Local nPedTotal
Local nQTDETot
Local nQTDSTot
Local nSaldTot
Local cLinha:=""                         
 
ProcRegua( LEN(aItens) ) 

	    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCria um arquivo do tipo *.xls	                                                 ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		nHandle := FCREATE(cArqPesq, 0)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifica se o arquivo pode ser criado, caso contrario um alerta sera exibido      ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If FERROR() != 0
			Alert("Nใo foi possํvel abrir ou criar o arquivo: " + cArqPesq )
        EndIf
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤิ
		//ณmonta cabe็alho de pagina HTML para posterior utiliza็ใoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤิ
		cCabHtml := "<!-- HCI Hidraulica Conexoes Industriais LTDA. --> " + CRLF
		cCabHtml += "<!DOCTYPE html PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>" + CRLF
		cCabHtml += "<html>" + CRLF
		cCabHtml += "<head>" + CRLF
		cCabHtml += "  <title>POSICAO DE PEDIDO</title>" + CRLF
		cCabHtml += "  <meta name='GENERATOR' content='HCI Hidraulica Conexoes Industriais Ltda'>" + CRLF
		cCabHtml += "</head>" + CRLF
		cCabHtml += "<body bgcolor='#FFFFFF'>" + CRLF
		cCabHtml += "" + CRLF
 		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤHง
		//ณMonta Rodape Html para posterior utiliza็aoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤHง
		
		cRodHtml := "</body>" + CRLF
		cRodHtml += "</html>" + CRLF	
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAqui come็a a montagem da pagina html propriamente ditaณ
		//ณ	 acrescenta o cabe็alho                               ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		cFileCont := cCabHtml    
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ//Aqui come็a o corpo da pagina mesmo                                                                                         ณ
		//ณ// Inicia uma tabela html e alimenta a variavel do relatorio ja que o relatorio inteiro estara contido em apenas uma variavelณ
		//ณ	// estrutura basica de tabela em html                                                                                        ณ
		//ณ	// <table> inicia uma tabela                                                                                                 ณ
		//ณ	// <TR> inicio de linha                                                                                                      ณ
		//ณ	// <TD> </TD> Coluna de uma tabela repetir tantas vezes quantas colunas existirem                                            ณ
		//ณ	// importante!!!! o numero de colunas nao podera ser alterado dentro da table ou seja todas as linhas tem que ter o mesmo    ณ
		//ณ	// numero de colunas (para aglutinar colunas ้ necessแrio utilizar um comando especifico do html, que nใo sera exemplificado ณ
		//ณ	// aqui                                                                                                                      ณ
		//ณ	// </TR> finaliza uma linha da tabela                                                                                        ณ
		//ณ	// </Table> finaliza a tabela                                                                                                ณ
		//ณ	// Utilizado o parametro Style das colunas para formatar cor da celula e tipo da fonte                                       ณ
		//ณ	                                                                                                                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		
		cLinFile := "<Table style='background: #FFFFFF; width: 100%;' border='1' cellpadding='1' cellspacing='1'>"
		//Primeira linha da tabela 	  
		for x=1 to len(aItens)
		  cLinFile += "<TR>"
		  IncProc()
          // aAdd( aItens,{"PEDIDO","ITEM","CODIGO","DESCRICAO","QTD","R$ UNITARIO","TOTAL","SALDO","EMISSAO","PRAZO","DT EMBARQUE","REFCLI","PEDCLI","ITEMCLI","PV","ITEM","EMISSAO","CLIENTE","QTD","PRAZO","OC","ITEM","EMISSAO","FORNECEDOR","QTD","PRAZO"})
		  IF X=1 
		   	cLInha:="Background: #FFFFC0; font-style: Bold;"
		   	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,1] + "</b></TD>" 	  		//[1]PEDIDO
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,2] + "</b></TD>"     		//[2]ITEM
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,3] + "</b></TD>"     		//[3]CODIGO
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,4] + "</b></TD>"     		//[4]DESCRICAO
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,5] + "</b></TD>"     		//[5]QTD
            cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,6] + "</b></TD>"       		//[6]Unitario
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,7] + "</b></TD>"       		//[7]Total
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,8] + "</b></TD>"       		//[8]SALDO
            cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,9] + "</b></TD>"       		//[9]EMISSAO
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,10] + "</b></TD>"       	//[10]PRAZO
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,11] + "</b></TD>"       	//[11]DT EMBARQUE
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,12] + "</b></TD>"       	//[12]REFCLI
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,13] + "</b></TD>"			//[13]PEDCLI
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,14] + "</b></TD>"        	//[14]ITEMCLI
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,15] + "</b></TD>"        	//[15]PV
		 	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,16] + "</b></TD>"        	//[16]ITEM 
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,17] + "</b></TD>"      		//[17]EMISSAO
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,18] + "</b></TD>"      	 	//[18]CLIENTE
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,19] + "</b></TD>"      	 	//[19]QTD
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,20] + "</b></TD>" 			//[20]PRAZO
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,21] + "</b></TD>"      		//[21]OS
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,22] + "</b></TD>"      		//[22]ITEM
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,23] + "</b></TD>"  			//[23]EMISSAO
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,24] + "</b></TD>"		  	//[24]FORNECEDOR
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,25] + "</b></TD>"      	  	//[25]QTD 
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,26] + "</b></TD>"    		//[26]Prazo 
		   	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,27] + "</b></TD>"    		//[26]Prazo 
		   	cLinFile += "</TR>"
		  ELSE
		    IF VAL(aItens[x,9])=0
		       cLInha:="Background: #B4FFA1; font-style: Bold;" 
		    ELSE
		       IF VAL(aItens[x,9])<0
		         cLInha:="Background: #FF0000; font-style: Bold;" 
		       ELSE    
                 cLInha:="Background: #FFFFFF; font-style: Bold;" 
               ENDIF  
            ENDIF   		    
		    cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,1] + "</b></TD>" 	  		//[1]PEDIDO
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,2] + "</b></TD>"     		//[2]ITEM
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,3] + "</b></TD>"     		//[3]CODIGO
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,4] + "</b></TD>"     		//[4]DESCRICAO
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,5] + "</b></TD>"     		//[5]QTD
            cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,6] + "</b></TD>"       		//[6]Unitario
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,7] + "</b></TD>"       		//[7]Total
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,8] + "</b></TD>"       		//[8]SALDO
            cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,9] + "</b></TD>"       		//[9]EMISSAO
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,10] + "</b></TD>"       	//[10]PRAZO
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,11] + "</b></TD>"       	//[11]DT EMBARQUE
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,12] + "</b></TD>"       	//[12]REFCLI
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,13] + "</b></TD>"			//[13]PEDCLI
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,14] + "</b></TD>"        	//[14]ITEMCLI
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,15] + "</b></TD>"        	//[15]PV
		 	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,16] + "</b></TD>"        	//[16]ITEM 
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,17] + "</b></TD>"      		//[17]EMISSAO
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,18] + "</b></TD>"      	 	//[18]CLIENTE
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,19] + "</b></TD>"      	 	//[19]QTD
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,20] + "</b></TD>" 			//[20]PRAZO
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,21] + "</b></TD>"      		//[21]OS
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,22] + "</b></TD>"      		//[22]ITEM
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,23] + "</b></TD>"  			//[23]EMISSAO
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,24] + "</b></TD>"		  	//[24]FORNECEDOR
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,25] + "</b></TD>"      	  	//[25]QTD 
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,26] + "</b></TD>"    		//[26]Prazo
		  	cLinFile += "<TD rowspan='1' style='"+ cLInha +"'><b>" + aItens[x,27] + "</b></TD>"    		//[26]Prazo  
		  	cLinFile += "</TR>"
		  ENDIF
		  // anexa a linha montada ao corpo da tabela
		  cFileCont += cLinFile
		  (FWRITE(nHandle, cFileCont) )
		  cLinFile := ""
		  cFileCont:= cLinFile
		next

cLinFile := "</Table>"
(FWRITE(nHandle, cLinFile) )
//Acrescenta o rodap้ html
(FWRITE(nHandle, cRodHtml))
	
// fecha a tabela aberta no inicio do arquivo

fCLose(nHandle)
ApmsgAlert("Abra o arquivo >>>>>" + cArqPesq + "<<<<<< atrav้s do Excel para ver o resultado!")

RestArea( _aArea )

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSelArq    บAutor  ณ Ernani Forastieri  บ Data ณ  20/04/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina auxiliar de Selecao do arquivo texto a ser importadoบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SelArq()
Private _cExtens   := "Arquivo Texto ( *.TXT ) |*.TXT|"
_cRet := cGetFile( _cExtens, "Selecione o Arquivo",,, .F., GETF_NETWORKDRIVE + GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_RETDIRECTORY )
_cRet := ALLTRIM( _cRet )
Return( _cRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณConvType  บAutor  ณ Ernani Forastieri  บ Data ณ  20/04/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina auxiliar de Selecao do arquivo texto a ser importadoบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
        
Static Function ConvType(xValor,nTam,nDec,ctipo)

Local cNovo := ""
DEFAULT nDec := 0
Do Case
	Case ValType(xValor)=="N"
		If xValor <> 0
			cNovo := AllTrim(Str(xValor))	
		Else
			cNovo := "0"
		EndIf
	Case ValType(xValor)=="C" .AND. cTipo=="D"
	  //	cNovo := FsDateConv(xValor,"YYYYMMDD")
		cNovo := SubStr(xValor,7,2)+"/"+SubStr(xValor,5,2)+"/"+SubStr(xValor,1,4)

EndCase
Return(cNovo)





