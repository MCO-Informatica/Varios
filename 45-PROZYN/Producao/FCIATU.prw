#Include "Protheus.ch"
#Include "Topconn.ch"
#include "tbiconn.ch"

/*
Programa para atualização do código de FCI dos pedidos em aberto.
Denis Varella ~ 01/10/2021
*/

User Function FCIAtu()
    Local aArea := GetArea()
    Local aPergs   := {}
    Private cMes := ""
    Private cAno := ""
    Private dInicio := CtoD("  /  /    ")
    Private dFim := CtoD("  /  /    ")
    Private aMudanca := {}
    
    aAdd(aPergs, {1, "Ano",  Year2Str(dDatabase),  "@R 9999", ".T.", "", ".T.", 80,  .F.})
    aAdd(aPergs, {1, "Mês",  Month2Str(dDatabase),  "@R 99", ".T.", "", ".T.", 80,  .F.})
    
    If ParamBox(aPergs, "Informe os parâmetros")
        cAno := MV_PAR01
        cMes := MV_PAR02
        dInicio := StoD(cAno+cMes+"01")
        dFim := LastDate(dInicio)
        If MsgYesNo("Tem certeza de que deseja atualizar o código FCI dos pedidos pendentes de faturamento de "+cMes+"/"+cAno+"?","Confirmação")
            Processa( {|| AtuOrigem() },"Aguarde" ,"Atualizando Origens 0, 6 e 7...")
            Processa( {|| AjustaPed() },"Aguarde" ,"Atualizando pedidos com código FCI...")
            Processa( {|| AtuDA1FCI() },"Aguarde" ,"Atualizando tabelas de preço...")
        EndIf
    EndIf

    RestArea(aArea)

Return

Static Function AtuOrigem()
    // If (B1_Origem = 0, 6 ou 7; then na tabela CFD o produto deverá ter o Campo CFD_FCICOD zerado e o campo CFD_ORIGEM deve ficar igual ao conteúdo da B1_Origem.)
    Local aArea := GetArea()
    
    DbSelectArea("CFD")
    CFD->(DbSetOrder(1))
    If CFD->(DbSeek(xFilial("CFD")+cMes+cAno))

        DbSelectArea("SB1")
        SB1->(DbSetOrder(1))

        While CFD->(!EOF()) .AND. CFD->CFD_PERCAL == cMes+cAno
            If SB1->(DbSeek(xFilial("SB1")+CFD->CFD_COD)) .AND. SB1->B1_ORIGEM $ '0;6;7'
                CFD->(RecLock("CFD",.F.))
                CFD->CFD_ORIGEM := SB1->B1_ORIGEM
                CFD->CFD_FCICOD := ""
                CFD->(MsUnlock())
            ElseIf SB1->(DbSeek(xFilial("SB1")+CFD->CFD_COD)) .AND. CFD->CFD_ORIGEM $ '3;5;8'
                SB1->(RecLock("SB1",.F.))
                SB1->B1_ORIGEM := CFD->CFD_ORIGEM
                SB1->(MsUnlock())
            EndIf
            CFD->(DbSkip())
        EndDo

    EndIf
    RestArea(aArea)
Return

Static Function AjustaPed()
    Local aArea := GetArea()
    Local cQry := ""

    cQry := " SELECT C6_NUM,C6_CLI,C6_LOJA,A1_NREDUZ,C6_PRODUTO,B1_DESC,B1_TIPO,C6_FCICOD FCI_ANTIGO,ISNULL(CFD_FCICOD,'') FCI_NOVO,C6_CLASFIS CLASFIS_ANTIGO,CONCAT(ISNULL(CFD_ORIGEM,B1_ORIGEM),SUBSTRING(C6_CLASFIS,2,2)) CLASFIS_NOVO,ISNULL(CFD_ORIGEM,B1_ORIGEM) ORIGEM,C6.R_E_C_N_O_ 
    cQry += " FROM "+RetSqlName("SC6")+" C6
    cQry += " INNER JOIN "+RetSqlName("SB1")+" B1 ON B1_COD = C6_PRODUTO AND B1.D_E_L_E_T_ = ''
    cQry += " INNER JOIN "+RetSqlName("SA1")+" A1 ON A1_COD = C6_CLI AND A1_LOJA = C6_LOJA AND A1.D_E_L_E_T_ = ''
    cQry += " INNER JOIN "+RetSqlName("SC5")+" C5 ON C5_NUM = C6_NUM AND C5_CLIENTE = C6_CLI AND C5_LOJACLI = C6_LOJA AND C5.D_E_L_E_T_ = ''
    cQry += " LEFT JOIN "+RetSqlName("CFD")+" CFD ON CFD_COD = C6_PRODUTO AND CFD_PERCAL = '"+cMes+cAno+"' AND CFD.D_E_L_E_T_ = '' 
    // cQry += " AND CFD_FCICOD != '' AND (CFD_FCICOD != C6_FCICOD OR SUBSTRING(C6_CLASFIS,1,1) != CFD_ORIGEM)
    cQry += " WHERE C6_NOTA = '' AND C6.D_E_L_E_T_ = '' AND C5_FECENT LIKE '"+cAno+cMes+"%'
    // cQry += " AND (TRIM(C6_CLASFIS) != TRIM(CONCAT(ISNULL(CFD_ORIGEM,B1_ORIGEM),SUBSTRING(C6_CLASFIS,2,2))) OR C6_FCICOD != ISNULL(CFD_FCICOD,''))
    cQry += " ORDER BY C6_NUM,B1_DESC
    DbUseArea(.T.,"TOPCONN", TcGenQry(,,cQry),"FCIATU",.F.,.F.)

    If FCIATU->(!EOF())

        U_zQry2Excel(cQry,"Atualizacao FCI - "+cMes+"/"+cAno)

        DbSelectArea("SC6")

        While FCIATU->(!eof())
            SC6->(DbGoTo(FCIATU->R_E_C_N_O_))
            SC6->(RecLock("SC6",.F.))

            SC6->C6_CLASFIS := FCIATU->CLASFIS_NOVO
            SC6->C6_FCICOD := FCIATU->FCI_NOVO
            SC6->(MsUnlock())
            FCIATU->(DbSkip())
        EndDo
        MsgAlert("Produtos atualizados com sucesso!","Atenção!")
    Else
        MsgAlert("Não há itens pendentes de atualização de código de FCI neste mês.","Atenção!")
    EndIf
    FCIATU->(DbCloseArea())

    RestArea(aArea)

Return

Static Function AtuDA1FCI()
    Local aArea := GetArea()
    Local cQry := ""
    Local cHTML := "Prezado(a), segue relação de atualização do FCI - Origens 3 e 8."
    Private cFolder := "\FCI Atu\"
    Private cArquivo  := DtoS(Date())+".XML"
    Private aFile := {cFolder+cArquivo}
    
    If !ExistDir( cFolder )
        MakeDir( cFolder )
    EndIf

    cQry := " SELECT DISTINCT ISNULL(A1_EST,'') A1_EST,DA1_YICMS,DA1_CODTAB,DA1_CODPRO,CFD_ORIGEM,B1_DESC,DA1.R_E_C_N_O_ DA1REC,A1_COD,A1_LOJA FROM "+RetSqlName("CFD")+" CFD
    cQry += " INNER JOIN "+RetSqlName("SB1")+" B1 ON B1_COD = CFD_COD AND B1.D_E_L_E_T_ = ''
    cQry += " INNER JOIN "+RetSqlName("DA1")+" DA1 ON DA1_CODPRO = CFD_COD AND DA1.D_E_L_E_T_ = ''
    cQry += " INNER JOIN "+RetSqlName("DA0")+" DA0 ON DA0_CODTAB = DA1_CODTAB AND DA0.D_E_L_E_T_ = ''
    cQry += " LEFT JOIN "+RetSqlName("SA1")+" A1 ON A1_COD = DA0_YCODCL AND A1_LOJA = DA0_YLJCLI AND A1.D_E_L_E_T_ = ''
    cQry += " WHERE CFD.D_E_L_E_T_ = '' AND CFD_PERCAL = '"+cMes+cAno+"' AND CFD_ORIGEM IN ('0','5','6','7','3','8') 
    
    //Para debug
    // cQry += " AND B1_COD IN ('011173','011794') AND DA1_CODTAB = '359'
    DbUseArea(.T.,"TOPCONN", TcGenQry(,,cQry),"DA1FCI",.F.,.F.)

    DbSelectArea("DA1")
    DbSelectArea("SB1")
    SB1->(DbSetOrder(1))
    While DA1FCI->(!EOF())

        If Trim(DA1FCI->A1_EST) != 'EX'
            If (DA1FCI->CFD_ORIGEM $ '3,8' .and. Trim(DA1FCI->A1_EST) != 'SP') .or. DA1FCI->CFD_ORIGEM $ '0,5,6,7'
                DA1->(DbGoTo(DA1FCI->DA1REC))
                    
                SB1->(DbSeek(xFilial("SB1")+DA1->DA1_CODPRO))

                If DA1FCI->CFD_ORIGEM $ '0,5,6,7'
                    aRet := getICMS(DA1->DA1_CODTAB,DA1->DA1_CODPRO)
                    If !aRet[2]
                        DA1FCI->(DbSkip())
                        LOOP
                    EndIf
                    nPICM := aRet[1]
                ElseIf DA1FCI->CFD_ORIGEM $ '3,8'
                    nPICM := 4
                EndIf

                If DA1FCI->DA1_YICMS == nPICM
                    DA1FCI->(DbSkip())
                    LOOP
                EndIf
                

                aAdd(aMudanca, {DA1->DA1_CODTAB,DA1->DA1_CODPRO,DA1FCI->B1_DESC,DA1->DA1_YICMS,DA1->DA1_PRCVEN,0,{}})

                nPrcVen := Round(DA1->DA1_PRNET * 100 / (100 - nPICM - DA1->DA1_YPIS - DA1->DA1_YCOFIN),2)

                DA1->(RecLock("DA1",.F.))
                DA1->DA1_YICMS := nPICM
                DA1->DA1_PRCVEN := nPrcVen
                DA1->(MsUnlock())

                aMudanca[len(aMudanca)][6] := nPrcVen

                AtuSC6(DA1->DA1_CODTAB,DA1->DA1_CODPRO,nPrcVen,DA1->DA1_PRNET)

            EndIf
        EndIf

        DA1FCI->(DbSkip())
    EndDo
    DA1FCI->(DbCloseArea())
    
    // cHTML := SetHTML()
    If len(aMudanca) > 0
        aFile := SetExcel()
        cTo := "nailson.paixao@prozyn.com.br"
        U_zEnvMail(cTo, "Atualização FCI", cHTML, aFile, .f., .t., .t.)
        FERASE(cFolder+cArquivo)
    Else
        MsgAlert("Não foi necessário atualizar nenhuma tabela de preço / pedido de venda.", "Atenção!")
    EndIf

    RestArea(aArea)
Return

Static Function GetICMS(cTabela,cProduto)
    Local nPICM := 0
    Local lFound := .F.
    cQry := " SELECT TOP 1 C5.R_E_C_N_O_ C5REC,C6.R_E_C_N_O_ C6REC FROM "+RetSqlName("SC6")+" C6
    cQry += " INNER JOIN "+RetSqlName("SC5")+" C5 ON C5_NUM = C6_NUM AND C5_CLIENTE = C6_CLI AND C5_LOJACLI = C6_LOJA AND C5.D_E_L_E_T_ = ''
    cQry += " WHERE C6_NOTA = '' AND C6.D_E_L_E_T_ = '' AND C6_PRODUTO = '"+cProduto+"' AND C5_TABELA = '"+cTabela+"' AND 
    cQry += " Year(C5_FECENT) = '"+cAno+"' and Month(C5_FECENT) = '"+cMes+"'
    DbUseArea(.T.,"TOPCONN", TcGenQry(,,cQry),"GETICM",.F.,.F.)

    DbSelectArea("SC5")
    DbSelectArea("SC6")

    If GETICM->(!EOF())
        lFound := .T.
        SC5->(DbGoTo(GETICM->C5REC))
        SC6->(DbGoTo(GETICM->C6REC))

        MaFisIni(SC5->C5_CLIENTE,SC5->C5_LOJACLI,If(SC5->C5_TIPO$'DB',"F","C"),SC5->C5_TIPO,SC5->C5_TIPOCLI,MaFisRelImp("MTR700",{"SC5","SC6"}),,,"SB1","MTR700")
        MaFisAdd(SC6->C6_PRODUTO,;
            SC6->C6_TES,;
            SC6->C6_QTDVEN,;
            SC6->C6_PRCVEN,;
            SC6->C6_PRUNIT - SC6->C6_PRCVEN,;
            "",;
            "",;
            0,;
            0,;
            0,;
            0,;
            0,;
            SC6->C6_VALOR,;
            0,;
            0,;
            0)
        nPICM := MaFisRet(1,"IT_ALIQICM" )
        MaFisEnd()
    EndIf

    GETICM->(DbCloseArea())

Return {nPICM, lFound}

Static Function AtuSC6(cTabela,cProduto,nPrcVen,nPrcNet)
    Local aArea := GetArea()
    Local cQry := ""
	Private lMsErroAuto := .F.

    cQry := " SELECT C6.R_E_C_N_O_ C6REC,C5.R_E_C_N_O_ C5REC,C5_TABELA,C6_PRODUTO,C6_NUM,C6_ITEM,B1_DESC FROM "+RetSqlName("SC6")+" C6
    cQry += " INNER JOIN "+RetSqlName("SB1")+" B1 ON B1_COD = C6_PRODUTO AND B1.D_E_L_E_T_ = ''
    cQry += " INNER JOIN "+RetSqlName("SC5")+" C5 ON C5_NUM = C6_NUM AND C5_CLIENTE = C6_CLI AND C5_LOJACLI = C6_LOJA AND C5.D_E_L_E_T_ = ''
    cQry += " WHERE C6_NOTA = '' AND C6.D_E_L_E_T_ = '' AND C6_PRODUTO = '"+cProduto+"' AND C5_TABELA = '"+cTabela+"' AND Year(C5_FECENT) = '"+cAno+"' and Month(C5_FECENT) = '"+cMes+"' 
    DbUseArea(.T.,"TOPCONN", TcGenQry(,,cQry),"SC6FCI",.F.,.F.)

    DbSelectArea("SC5")
    DbSelectArea("SC6")

    While SC6FCI->(!EOF())
        lMsErroAuto := .F.
        SC5->(DbGoTo(SC6FCI->C5REC))
        SC6->(DbGoTo(SC6FCI->C6REC))
        nOldPrc := SC6->C6_PRUNIT
        nOldNet := SC6->C6_XPRCNET

        aCabec   := {}
        aItens   := {}

        aAdd(aCabec,{"C5_FILIAL"	,SC5->C5_FILIAL , Nil})
        aAdd(aCabec,{"C5_NUM"		,SC5->C5_NUM , Nil})

        SC6->(DbSetOrder(1))
        SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
        nItem := 1
        While SC6->(!EOF()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM == SC5->C5_NUM
            nPrcUnit := Iif(SC6->(Recno()) != SC6FCI->C6REC,SC6->C6_PRUNIT,nPrcVen)
            nPrcVenNet := Iif(SC6->(Recno()) != SC6FCI->C6REC,SC6->C6_XPRCNET,nPrcNet)
            nItPrcVen := Iif(SC6->(Recno()) != SC6FCI->C6REC,SC6->C6_PRCVEN,nPrcVen)
            nTotal := Round(nItPrcVen * SC6->C6_QTDVEN,2)

            aItem   := {}
			aadd(aItem,{"AUTDELETA"		,"N"				, Nil})
			aAdd(aItem,{"C6_FILIAL"		,SC6->C6_FILIAL		, Nil})
			aAdd(aItem,{"C6_ITEM"		,SC6->C6_ITEM		, Nil})
			aAdd(aItem,{"C6_PRODUTO"	,SC6->C6_PRODUTO	, Nil})
			aAdd(aItem,{"C6_QTDVEN"		,SC6->C6_QTDVEN		, Nil})
			aAdd(aItem,{"C6_QTDLIB"		,0		            , Nil})
			aAdd(aItem,{"C6_PRUNIT"		,nPrcUnit		    , Nil})
			aAdd(aItem,{"C6_XPRCNET"	,nPrcVenNet		    , Nil})
			aAdd(aItem,{"C6_PRCVEN"		,nItPrcVen		    , Nil})
			aAdd(aItem,{"C6_VALOR"		,nTotal             , Nil})
			aAdd(aItem,{"C6_TES"		,SC6->C6_TES		, Nil})
			aAdd(aItem,{"C6_CLASFIS"	,SC6->C6_CLASFIS	, Nil})
			aAdd(aItem,{"C6_FCICOD"	    ,SC6->C6_FCICOD	    , Nil})
			aAdd(aItem,{"C6_LOCAL"		,SC6->C6_LOCAL		, Nil})

            aadd(aItens, aItem)
            nItem++

            SC6->(DbSkip())
        EndDo

        lMsHelpAuto	:= .T.
        lMsErroAuto	:= .F.
        MSExecAuto({|a, b, c, d| MATA410(a, b, c, d)}, aCabec, aItens, 4, .F.)

        If !lMsErroAuto

            aAdd(aMudanca[len(aMudanca)][7], {Trim(SC5->C5_NUM),Trim(SC5->C5_TABELA),Trim(SC6->C6_ITEM),Trim(SC6->C6_PRODUTO),Trim(SC6FCI->B1_DESC),nOldPrc,nItPrcVen,nOldNet,nPrcNet})
        EndIf

        SC6FCI->(DbSkip())
    EndDo

    SC6FCI->(DbCloseArea())

    RestArea(aArea)
Return

Static Function SetExcel()
    
    Local oFWMsExcel
    Local nA := nB := 0

        oFWMsExcel := FWMSExcel():New()
        
        cTitulo := "Tab Preço"
        cAba := "Atualização FCI"
        oFWMsExcel:AddworkSheet(cTitulo)

        oFWMsExcel:AddTable(cTitulo,cAba)
        oFWMsExcel:AddColumn(cTitulo,cAba,"Tabela", 1,1)
        oFWMsExcel:AddColumn(cTitulo,cAba,"Produto", 1,1)
        oFWMsExcel:AddColumn(cTitulo,cAba,"Descrição", 1,1)
        oFWMsExcel:AddColumn(cTitulo,cAba,"ICMS Anterior", 2,2) 
        oFWMsExcel:AddColumn(cTitulo,cAba,"Preço de Venda Anterior", 3,3)
        oFWMsExcel:AddColumn(cTitulo,cAba,"ICMS Novo", 2,2)
        oFWMsExcel:AddColumn(cTitulo,cAba,"Preço de Venda Novo", 3,3)
        
        cTitulo2 := "Ped Venda"
        oFWMsExcel:AddworkSheet(cTitulo2)

        oFWMsExcel:AddTable(cTitulo2,cAba)
        oFWMsExcel:AddColumn(cTitulo2,cAba,"Pedido", 1,1)
        oFWMsExcel:AddColumn(cTitulo2,cAba,"Tabela", 1,1)
        oFWMsExcel:AddColumn(cTitulo2,cAba,"Item", 1,1)
        oFWMsExcel:AddColumn(cTitulo2,cAba,"Produto", 1,1)
        oFWMsExcel:AddColumn(cTitulo2,cAba,"Descrição", 1,1)
        oFWMsExcel:AddColumn(cTitulo2,cAba,"Preço Bruto Anterior", 3,3) 
        oFWMsExcel:AddColumn(cTitulo2,cAba,"Preço Bruto Novo", 3,3) 
        oFWMsExcel:AddColumn(cTitulo2,cAba,"Preço NET Anterior", 3,3)
        oFWMsExcel:AddColumn(cTitulo2,cAba,"Preço NET Novo", 3,3)
  
        For nA := 1 to len(aMudanca)
    	    oFWMsExcel:AddRow(cTitulo,cAba,{Trim(aMudanca[nA][1]),;
                Trim(aMudanca[nA][2]),;
                Trim(aMudanca[nA][3]),;
                aMudanca[nA][4],;
                aMudanca[nA][5],;
                4,;
                aMudanca[nA][6]})

            aItens := aMudanca[nA][len(aMudanca[nA])]
            For nB := 1 to len(aItens)
    	        oFWMsExcel:AddRow(cTitulo2,cAba,aItens[nB])
            Next nB
        Next nA

        oFWMsExcel:Activate()
        oFWMsExcel:GetXMLFile(cFolder+cArquivo)

Return aFile

Static Function SetHTML()
  Local nA := nB := 0
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

  cHTML += "<p>Prezados,</p>
  cHTML += "<p>Segue a relação de alterações realizadas devido a atualização do FCI.</p>
 
  cHTML += "<h4>Atualizações:</h4>
  For nA := 1 to len(aMudanca)
    cHTML += "<table>
    cHTML += "	<thead>
    cHTML += "		<tr>
    cHTML += "			<td align='left'>Tabela</td>
    cHTML += "            <td align='left'>Produto</td>
    cHTML += "            <td align='center'>ICMS Anterior</td>
    cHTML += "            <td align='center'>Preço de Venda Anterior</td>
    cHTML += "            <td align='center'>ICMS Novo</td>
    cHTML += "            <td align='center'>Preço de Venda Novo</td>
    cHTML += "		</tr>
    cHTML += "	</thead>
    cHTML += "	<tbody>
    cHTML += "		<tr>
    cHTML += "			<td align='left'>"+aMudanca[nA][1]+"</td>
    cHTML += "			<td align='left'>"+aMudanca[nA][2]+" | "+aMudanca[nA][3]+"</td>
    cHTML += "			<td align='center'>"+AllTrim(TRANSFORM(aMudanca[nA][4], "@E 999,999,999.99"))+"</td>
    cHTML += "			<td align='center'>"+AllTrim(TRANSFORM(aMudanca[nA][5], "@E 999,999,999.99"))+"</td>
    cHTML += "			<td align='center'>"+AllTrim(TRANSFORM(4, "@E 999,999,999.99"))+"</td>
    cHTML += "			<td align='center'>"+AllTrim(TRANSFORM(aMudanca[nA][6], "@E 999,999,999.99"))+"</td>
    cHTML += "		</tr>
    cHTML += "	</tbody>
    cHTML += "</table>

    cHTML += "<table>
    cHTML += "	<thead>
    cHTML += "		<tr>
    cHTML += "			<td align='left'>Pedido</td>
    cHTML += "          <td align='left'>Tabela</td>
    cHTML += "          <td align='left'>Item</td>
    cHTML += "          <td align='left'>Produto</td>
    cHTML += "          <td align='center'>Preço Anterior</td>
    cHTML += "          <td align='center'>Preço Net Anterior</td>
    cHTML += "          <td align='center'>Preço Novo</td>
    cHTML += "          <td align='center'>Preço Net Novo</td>
    cHTML += "		</tr>
    cHTML += "	</thead>
    cHTML += "	<tbody>
    aItens := aMudanca[nA][len(aMudanca[nA])]
    For nB := 1 to len(aItens)
        cHTML += "		<tr>
        cHTML += "			<td align='left'>"+aItens[nB][1]+"</td>
        cHTML += "			<td align='left'>"+aItens[nB][2]+"</td>
        cHTML += "			<td align='left'>"+aItens[nB][3]+"</td>
        cHTML += "			<td align='left'>"+aItens[nB][4]+"</td>
        cHTML += "			<td align='center'>"+AllTrim(TRANSFORM(aItens[nB][5], "@E 999,999,999.99"))+"</td>
        cHTML += "			<td align='center'>"+AllTrim(TRANSFORM(aItens[nB][6], "@E 999,999,999.99"))+"</td>
        cHTML += "			<td align='center'>"+AllTrim(TRANSFORM(aItens[nB][7], "@E 999,999,999.99"))+"</td>
        cHTML += "			<td align='center'>"+AllTrim(TRANSFORM(aItens[nB][8], "@E 999,999,999.99"))+"</td>
        cHTML += "		</tr>
    Next nB
    cHTML += "	</tbody>
    cHTML += "</table>
  Next nA

  cHTML += "</body>
  cHTML += "</html>

Return cHTML
