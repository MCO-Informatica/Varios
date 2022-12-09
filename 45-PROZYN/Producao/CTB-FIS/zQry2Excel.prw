//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
  
/*/{Protheus.doc} zQry2Excel
Função que recebe uma consulta sql e gera um arquivo do excel, dinamicamente
@author Atilio
@since 16/05/2017
@version 1.0
    @param cQryAux, characters, Query que será executada
    @param cTitAux, characters, Título do Excel
    @example
    u_zQry2Excel("SELECT B1_COD, B1_DESC FROM SB1010")
    @obs Cuidado com colunas com mais de 200 caracteres, pode ser que o Excel dê erro ao abrir o XML
/*/
  
User Function zQry2Excel(cQryAux, cTitAux, cArquivo, cDiretorio, cFormat, aTitulos, aFormat, lOpen)
    Default cQryAux   := ""
    Default cTitAux   := "Título"
    Default cArquivo   := "zQry2Excel"
    Default cDiretorio  := GetTempPath()
    Default cFormat     := "xls"
    Default aTitulos  := {}
    Default aFormat     := {}
    Default lOpen       := .T.
     
    Processa({|| fProcessa(cQryAux, cTitAux, cArquivo, cDiretorio, cFormat, aTitulos, aFormat, lOpen) }, "Processando...")
Return
 
/*---------------------------------------------------------------------*
 | Func:  fProcessa                                                    |
 | Desc:  Função de processamento                                      |
 *---------------------------------------------------------------------*/
 
Static Function fProcessa(cQryAux, cTitAux, cArquivo, cDiretorio, cFormat, aTitulos, aFormat, lOpen)
    Local aArea       := GetArea()
    Local aAreaX3     := SX3->(GetArea())
    Local nAux        := 0
    Local oFWMsExcel
    Local oExcel
    Local cArqFull    := cDiretorio + cArquivo + "."+cFormat
    Local cWorkSheet  := "Aba - Principal"
    Local cTable      := ""
    Local aColunas    := {}
    Local aEstrut     := {}
    Local aLinhaAux   := {}
    Local cTitulo     := ""
    Local nTotal      := 0
    Local nAtual      := 0

    cArquivo += "."+cFormat
     
    cTable := cTitAux
     
    //Se tiver a consulta
    If !Empty(cQryAux)
        TCQuery cQryAux New Alias "QRY_AUX"
         
        DbSelectArea('SX3')
        SX3->(DbSetOrder(2)) //X3_CAMPO
         
        //Percorrendo a estrutura
        aEstrut := QRY_AUX->(DbStruct())
        ProcRegua(Len(aEstrut))
        For nAux := 1 To Len(aEstrut)
            IncProc("Incluindo coluna "+cValToChar(nAux)+" de "+cValToChar(Len(aEstrut))+"...")
            cTitulo := ""
             
            //Se conseguir posicionar no campo
            
            If len(aTitulos) >= nAux
                cTitulo := aTitulos[nAux]
            Else
                If SX3->(DbSeek(aEstrut[nAux][1]))
                    cTitulo := Alltrim(SX3->X3_TITULO)
                    
                    //Se for tipo data, transforma a coluna
                    If SX3->X3_TIPO == 'D'
                        TCSetField("QRY_AUX", aEstrut[nAux][1], "D")
                    EndIf
                Else
                    cTitulo := Capital(Alltrim(aEstrut[nAux][1]))
                EndIf
            EndIf
             
            //Adicionando nas colunas
            aAdd(aColunas, cTitulo)
        Next
          
        //Criando o objeto que irá gerar o conteúdo do Excel
        oFWMsExcel := FWMSExcel():New()
        oFWMsExcel:AddworkSheet(cWorkSheet)
            oFWMsExcel:AddTable(cWorkSheet, cTable)
             
            //Adicionando as Colunas
            For nAux := 1 To Len(aColunas)
                if len(aFormat) >= nAux
                oFWMsExcel:AddColumn(cWorkSheet, cTable, aColunas[nAux], aFormat[nAux], aFormat[nAux])
                Else
                oFWMsExcel:AddColumn(cWorkSheet, cTable, aColunas[nAux], 1, 1)
                EndIf
            Next
             
            //Definindo o total da barra
            DbSelectArea("QRY_AUX")
            QRY_AUX->(DbGoTop())
            Count To nTotal
            ProcRegua(nTotal)
            nAtual := 0
             
            //Percorrendo os produtos
            QRY_AUX->(DbGoTop())
            While !QRY_AUX->(EoF())
                nAtual++
                IncProc("Processando registro "+cValToChar(nAtual)+" de "+cValToChar(nTotal)+"...")
             
                //Criando a linha
                aLinhaAux := Array(Len(aColunas))
                For nAux := 1 To Len(aEstrut)
                    aLinhaAux[nAux] := &("QRY_AUX->"+aEstrut[nAux][1])
                Next
                  
                //Adiciona a linha no Excel
                oFWMsExcel:AddRow(cWorkSheet, cTable, aLinhaAux)
                  
                QRY_AUX->(DbSkip())
            EndDo
              
        //Ativando o arquivo e gerando o xml
        oFWMsExcel:Activate()
        oFWMsExcel:GetXMLFile(cArqFull)

        If lOpen
         
            //Se tiver o excel instalado
            If ApOleClient("msexcel")
                oExcel := MsExcel():New()
                oExcel:WorkBooks:Open(cArqFull)
                oExcel:SetVisible(.T.)
                oExcel:Destroy()
            
            Else
                //Se existir a pasta do LibreOffice 5
                If ExistDir("C:\Program Files (x86)\LibreOffice 5")
                    WaitRun('C:\Program Files (x86)\LibreOffice 5\program\scalc.exe "'+cDiretorio+cArquivo+'"', 1)
                
                //Senão, abre o XML pelo programa padrão
                Else
                    ShellExecute("open", cArquivo, "", cDiretorio, 1)
                EndIf
            EndIf

        EndIf
          
        QRY_AUX->(DbCloseArea())
    EndIf
     
    RestArea(aAreaX3)
    RestArea(aArea)
Return
