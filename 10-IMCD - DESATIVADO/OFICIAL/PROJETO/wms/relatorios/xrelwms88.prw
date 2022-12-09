//Bibliotecas 
//relatorio WMS - status cadastro do produto 
#Include "Protheus.ch"
#Include "TopConn.ch"
 
/*/{Protheus.doc} zTstExc1
@author Luiz Oliveira - FSW / Modificado Arnon D. Neves 
@since 26/09/2019   / 06/03/2020
@version 1.1
/*/
 
User Function XRELWMS8()
    Local aArea        := GetArea()
    Local cQuery        := ""
    Local oFWMsExcel
    Local oExcel
    Local cArquivo    := GetTempPath()+'xRelWms88.xml' 
    
    Pergunte("XRELWMS",.T.)   
    //Wuery de dados 
    
    cQuery := " SELECT "
    cQuery += " SB1.B1_COD, SB1.B1_DESC, SBF.BF_LOTECTL, SBF.BF_LOCAL, SBF.BF_LOCALIZ, SBF.BF_QUANT, SB1.B1_RASTRO, SB1.B1_LOCALIZ, B1_QE, SB1.B1_PESO, SB1.B1_PESBRU, " 
    cQuery += " SB1.B1_LOTEMUL, B5_CODZON, B5_SERVSAI, CASE WHEN (B5_COMPEND = '2') THEN 'NAO' ELSE 'SIM' END COMPEND,  " 
    cQuery += " SB8.B8_DFABRIC, SB8.B8_DTVALID, " 
    cQuery += " CASE WHEN (SB5.B5_CTRWMS = '1' ) THEN 'SIM' ELSE 'NAO' END CTRWMS  " 
    cQuery += " FROM "+RETSQLNAME("SB1")+" SB1  " 
 
    cQuery += " LEFT JOIN "+RETSQLNAME("SB5")+" SB5 ON B5_FILIAL ='" + xFilial("SB5") + "' "
    cQuery += " AND B5_COD = B1_COD AND SB5.D_E_L_E_T_ <> '*' "

    cQuery += " LEFT JOIN "+RETSQLNAME("SBF")+" SBF ON BF_FILIAL ='" + xFilial("SBF") + "' "
    cQuery += " AND BF_PRODUTO = B1_COD AND SBF.D_E_L_E_T_ <> '*' " 
 
    cQuery += " LEFT JOIN "+RETSQLNAME("SB8")+" SB8 ON B8_FILIAL ='" + xFilial("SB8") + "' "
    cQuery += " AND B8_PRODUTO = B1_COD " 
    cQuery += " AND B8_LOCAL = BF_LOCAL " 
    cQuery += " AND B8_LOTECTL = BF_LOTECTL " 
    cQuery += " AND B8_SALDO > 0 " 
    cQuery += " AND SB8.D_E_L_E_T_ <> '*' "
 
    cQuery += " WHERE B1_COD BETWEEN '"+MV_PAR01+"' AND  '"+MV_PAR02+"'  " 
    cQuery += " AND SB1.D_E_L_E_T_ <> '*' "
    cQuery += " AND BF_QUANT > 0 "

    cQuery += " ORDER BY SB1.B1_COD " 
    TCQuery cQuery New Alias "QRYPRO"

	If Select("QRYPRO") < 0
		Return()
	Endif  

    //Criando o objeto que irá gerar o conteúdo do Excel
    oFWMsExcel := FWMSExcel():New()
     
    //Aba 01 
    oFWMsExcel:AddworkSheet("1 Produtos") 
        //Criando a Tabela
        oFWMsExcel:AddTable("1 Produtos","Produtos")
        //Criando Colunas
        oFWMsExcel:AddColumn("1 Produtos","Produtos","Codigo",1,1)
        oFWMsExcel:AddColumn("1 Produtos","Produtos","Descricao",1,1)
        oFWMsExcel:AddColumn("1 Produtos","Produtos","Lote",1,1)
        oFWMsExcel:AddColumn("1 Produtos","Produtos","Armazem",1,1)
        oFWMsExcel:AddColumn("1 Produtos","Produtos","Endereco",1,1)
        oFWMsExcel:AddColumn("1 Produtos","Produtos","QtdEnd",1,1)
        oFWMsExcel:AddColumn("1 Produtos","Produtos","Rastro",1,1)
        oFWMsExcel:AddColumn("1 Produtos","Produtos","ContrEnd",1,1)
        oFWMsExcel:AddColumn("1 Produtos","Produtos","QuantEmb",2,2)
        oFWMsExcel:AddColumn("1 Produtos","Produtos","PesoL",2,2)
        oFWMsExcel:AddColumn("1 Produtos","Produtos","PesoB",2,2)
        oFWMsExcel:AddColumn("1 Produtos","Produtos","LoteMult",1,1)
        oFWMsExcel:AddColumn("1 Produtos","Produtos","ZonaArm",1,1)
        oFWMsExcel:AddColumn("1 Produtos","Produtos","ServSaida",1,1)
        oFWMsExcel:AddColumn("1 Produtos","Produtos","CompartEnd",1,1)
        oFWMsExcel:AddColumn("1 Produtos","Produtos","DtFabric",1,1) 
        oFWMsExcel:AddColumn("1 Produtos","Produtos","DtValid",1,1)
        oFWMsExcel:AddColumn("1 Produtos","Produtos","ContrlWms",1,1) 

        While !(QRYPRO->(EoF()))
            if QRYPRO->BF_QUANT > 0
                    oFWMsExcel:AddRow("1 Produtos","Produtos",{;
                                                                    QRYPRO->B1_COD,;
                                                                    QRYPRO->B1_DESC,;
                                                                    QRYPRO->BF_LOTECTL,;
                                                                    QRYPRO->BF_LOCAL,;
                                                                    QRYPRO->BF_LOCALIZ,;
                                                                    QRYPRO->BF_QUANT,;
                                                                    QRYPRO->B1_RASTRO,;
                                                                    QRYPRO->B1_LOCALIZ,;
                                                                    QRYPRO->B1_QE,;
                                                                    QRYPRO->B1_PESO,;
                                                                    QRYPRO->B1_PESBRU,;
                                                                    QRYPRO->B1_LOTEMUL,;
                                                                    QRYPRO->B5_CODZON,;
                                                                    QRYPRO->B5_SERVSAI,;
                                                                    QRYPRO->COMPEND,;
                                                                    DTOC(STOD(QRYPRO->B8_DFABRIC)),;
                                                                    DTOC(STOD(QRYPRO->B8_DTVALID)),;
                                                                    QRYPRO->CTRWMS;
                })
            endif
            //Pulando Registro
            QRYPRO->(DbSkip())
        EndDo
     
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()           //Abre uma nova conexão com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)              //Visualiza a planilha
    oExcel:Destroy()                    //Encerra o processo do gerenciador de tarefas
     
    QRYPRO->(DbCloseArea())
    RestArea(aArea)
Return
