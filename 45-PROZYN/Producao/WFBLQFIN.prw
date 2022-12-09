#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"
#Include "RPTDEF.CH"
#INCLUDE "TBICONN.CH"

User Function WFBLQFIN()
    Local nA := 0
    Local aPedidos := {}
    Private cTo := ""
    Private cHTML := ""

    PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01'

    cQry := " SELECT C5_FILIAL,C5_NUM,C5_CLIENTE,C5_LOJACLI,C5_XBLQMOT FROM "+RetSqlName("SC5")+" C5 
    cQry += " WHERE C5_FILIAL = '"+xFilial("SC5")+"' AND C5.D_E_L_E_T_ = ''
    // cQry += " AND C5_NUM = '052815'
    cQry += " AND C5_XBLQMOT LIKE 'X%' AND C5_XBLQFIN = 'B'

    dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQry),'WFBLQFIN',.T.,.T.)

    While WFBLQFIN->(!EOF())

      aAdd(aPedidos, {WFBLQFIN->C5_FILIAL,WFBLQFIN->C5_NUM,WFBLQFIN->C5_CLIENTE,WFBLQFIN->C5_LOJACLI,WFBLQFIN->C5_XBLQMOT})

      WFBLQFIN->(DbSkip())
    EndDo
    WFBLQFIN->(DbcloseArea())


    DbSelectArea("SC5")
    SC5->(DbSetOrder(1))

    DbSelectArea("SA1")
    SA1->(DbSetOrder(1))

    DbSelectArea("SA3")
    SA3->(DbSetOrder(1))

    DbSelectArea("SC6")
    SC6->(DbSetOrder(1))

    For nA := 1 to len(aPedidos)

      If SC5->(DbSeek(aPedidos[nA][1]+aPedidos[nA][2]+aPedidos[nA][3]+aPedidos[nA][4]))

        SA1->(DbGoTop())
        SA3->(DbGoTop())
        SC6->(DbGoTop())

        SetHTML(aPedidos[nA])
        cTo += SuperGetMV("MV_WFBLQFI",,"pedidos@prozyn.com.br")
        
        U_zEnvMail(cTo, "Aviso de Bloqueio: "+SC5->C5_NUM, cHTML, {}, .f., .t., .t.)
        //sandra.alencar@prozyn.com.br;daiana.schimmel@prozyn.com.br;marcio.nunes@prozyn.com.br;pedidos@prozyn.com.br;comercial@prozyn.com.br
        SC5->(RecLock("SC5",.F.))
        SC5->C5_XBLQMOT := SubStr(SC5->C5_XBLQMOT,2)
        SC5->(MsUnlock())
      EndIf

    Next nA

    RESET ENVIRONMENT

Return

Static Function SetHTML(aPedido)
  Local nTotal := nQtd := 0
  Local cMotivo := AllTrim(SubStr(aPedido[5],2))

  cHTML := "<html>
  cHTML += "<head>
  cHTML += "<style>
  cHTML += "* {outline: none;border:none;margin: 0;padding:0;box-sizing: border-box;font-family: Arial;}
  cHTML += "table { width: 100%;max-width: 900px;font-size:10px;}
  cHTML += "table thead {background: #C0D9D9;text-align: center;}
  cHTML += "table td {padding: 5px;border:1px solid #222;}
  cHTML += "p {margin-bottom: 15px;padding:5px;}
  cHTML += "h4 {padding:5px;margin:10px 0;}
  cHTML += "</style>
  cHTML += "</head>
  cHTML += "<body>

  SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))

  SA3->(DbGoTop())
  SA3->(DbSeek(xFilial("SA3")+SC5->C5_VEND1))
  cVndMail := Alltrim(SA3->A3_EMAIL)
  cVndNome := Alltrim(SA3->A3_NREDUZ)
  SA3->(DbGoTop())
  SA3->(DbSeek(xFilial("SA3")+SC5->C5_VEND2))
  cGerMail := Alltrim(SA3->A3_EMAIL)
  SA3->(DbGoTop())
  SA3->(DbSeek(xFilial("SA3")+SC5->C5_VEND3))
  cDirMail := Alltrim(SA3->A3_EMAIL)

  cTo := cVndMail + ";" + cGerMail + ";" //+ cDirMail + ";"
  // cTo := "eliane.oliveira@prozyn.com.br;robson.patekoski@prozyn.com.br;"

  cHTML += "<p>Sr(a). "+trim(cVndNome)+",</p>
  cHTML += "<p>Informamos que o pedido "+SC5->C5_NUM+" do cliente "+trim(SA1->A1_NREDUZ)+" está bloqueado por "+cMotivo+".</p>
  If Trim(cMotivo) == 'Limite de Crédito'
    cHTML += "<p><strong>Limite de Crédito:</strong> "+TRANSFORM(SA1->A1_LC, "@E 999,999,999.99")+"<br/>"
    cHTML += "<strong>Saldo disponível:</strong> "+TRANSFORM(SA1->A1_LC - SA1->A1_SALPEDL - SA1->A1_SALDUP, "@E 999,999,999.99")+"</p>"
  EndIf
  cHTML += "<h4>Informações do pedido:</h4>
  cHTML += "<table>
  cHTML += "	<thead>
  cHTML += "		<tr>
  cHTML += "			<td>Nº PEDIDO</td>
  cHTML += "			<td>DATA EMISSÃO</td>
  cHTML += "			<td>DATA SOLICITADA</td>
  cHTML += "			<td>CLIENTE</td>
  cHTML += "			<td>DESCRIÇÃO DO PRODUTO</td>
  cHTML += "			<td>QUANTIDADE</td>
  cHTML += "			<td>VALOR TOTAL DO PEDIDO</td>
  cHTML += "		</tr>
  cHTML += "	</thead>
  cHTML += "	<tbody>
  SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
  While SC6->(!EOF()) .AND. SC6->C6_NUM == SC5->C5_NUM
    cHTML += "		<tr>
    cHTML += "			<td align='center'>"+SC5->C5_NUM+"</td>
    cHTML += "			<td align='center'>"+DtoC(SC5->C5_EMISSAO)+"</td>
    cHTML += "			<td align='center'>"+DtoC(SC5->C5_FECENT)+"</td>
    cHTML += "			<td align='center'>"+trim(SA1->A1_NREDUZ)+"</td>
    cHTML += "			<td>"+Trim(Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_DESC"))+"</td>
    cHTML += "			<td align='right'>"+cValtoChar(SC6->C6_QTDVEN)+"</td>
    cHTML += "			<td align='right'>R$ "+TRANSFORM(SC6->C6_VALOR, "@E 999,999,999.99")+"</td>
    nQtd += SC6->C6_QTDVEN
    nTotal += SC6->C6_VALOR
    cHTML += "		</tr>
    SC6->(DbSkip())
  EndDo

    cHTML += "		<tr>
    cHTML += "			<td></td>
    cHTML += "			<td></td>
    cHTML += "			<td></td>
    cHTML += "			<td></td>
    cHTML += "			<td><strong>Total:</strong></td>
    cHTML += "			<td align='right'><strong>"+cValtoChar(nQtd)+"</strong></td>
    cHTML += "			<td align='right'><strong>R$ "+TRANSFORM(nTotal, "@E 999,999,999.99")+"</strong></td>
    cHTML += "		</tr>

  cHTML += "	</tbody>
  cHTML += "</table>

  If cMotivo == "Inadimplência"

    cQry := " SELECT E1_NUM,E1_PREFIXO,E1_PARCELA,E1_TIPO,E1_EMISSAO,E1_VENCTO,E1_VENCREA,E1_VALOR FROM SE1010 E1 
    cQry += " WHERE E1_CLIENTE = '"+SC5->C5_CLIENTE+"' AND E1_LOJA = '"+SC5->C5_LOJACLI+"' 
    cQry += " AND E1_VENCTO < '"+DtoS(Date())+"' AND E1_STATUS = 'A' AND E1.D_E_L_E_T_ = '' "
    dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQry),'TMPE1',.T.,.T.)

    If TMPE1->(!EOF())

      cHTML += "<h4>Título (s) em aberto:</h4>
      cHTML += "<table>
      cHTML += "	<thead>
      cHTML += "		<tr>
      cHTML += "			<td>No. Titulo</td>
      cHTML += "			<td>Codigo</td>
      cHTML += "			<td>Estado</td>
      cHTML += "			<td>Codigo-Lj-Nome do Cliente</td>
      cHTML += "			<td>Prefixo</td>
      cHTML += "			<td>Número</td>
      cHTML += "			<td>Parcela</td>
      cHTML += "			<td>TP</td>
      cHTML += "			<td>Data de Emissao</td>
      cHTML += "			<td>Vencto Titulo</td>
      cHTML += "			<td>Vencto Real</td>
      cHTML += "			<td>Valor Original</td>
      cHTML += "		</tr>
      cHTML += "	</thead>
      cHTML += "	<tbody>
      While TMPE1->(!EOF())

        cHTML += "		<tr>
        cHTML += "			<td align='center'>"+TMPE1->E1_NUM+"</td>
        cHTML += "			<td align='center'>"+SA1->A1_COD+"</td>
        cHTML += "			<td align='center'>"+SA1->A1_EST+"</td>
        cHTML += "			<td align='center'>"+SA1->A1_COD+"-"+SA1->A1_LOJA+"-"+TRIM(SA1->A1_NREDUZ)+"</td>
        cHTML += "			<td align='center'>"+TMPE1->E1_PREFIXO+"</td>
        cHTML += "			<td align='center'>"+TMPE1->E1_NUM+"</td>
        cHTML += "			<td align='center'>"+TMPE1->E1_PARCELA+"</td>
        cHTML += "			<td align='center'>"+TMPE1->E1_TIPO+"</td>
        cHTML += "			<td align='center'>"+DtoC(StoD(TMPE1->E1_EMISSAO))+"</td>
        cHTML += "			<td align='center'>"+DtoC(StoD(TMPE1->E1_VENCTO))+"</td>
        cHTML += "			<td align='center'>"+DtoC(StoD(TMPE1->E1_VENCREA))+"</td>
        cHTML += "			<td align='right'>R$ "+TRANSFORM(TMPE1->E1_VALOR, "@E 999,999,999.99")+"</td>
        cHTML += "		</tr>

        TMPE1->(DbSkip())
      EndDo
      
      cHTML += "	</tbody>
      cHTML += "</table>

    EndIf
    TMPE1->(DbCloseArea())

  EndIf
  cHTML += "</body>
  cHTML += "</html>

Return
