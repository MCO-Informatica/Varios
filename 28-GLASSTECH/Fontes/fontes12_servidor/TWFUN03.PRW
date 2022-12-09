/*/{Protheus.doc} TWFUN03
    (Rotina pontual para tratar titulos diversos que serão baixados ou excluidos do sistema)
    @type  Function
    @author Pirolo
    @since 26/08/2020
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @TWFUN03 (links_or_references)
    /*/
User Function TWFUN03()
Private aDet := {}

//Lê o arquivo do Contas a Receber
LeArquivoCSV("")



Return

/*/{Protheus.doc} LeArquivoCSV()
    @type  
    @author Pirolo
    @since 26/08/2020
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
/*/
Static Function LeArquivoCSV(cFile)
Local oFile		:= nil
Local nJ		:= 0
Local cLinha	:= ""
Local nI		:= 0
Local nPos		:= 0
Local aLinhas	:= {}

//Abre o arquivo CSV
oFile := FWFileReader():New(cFile)

//Se o arquivo abrir com sucesso
If (oFile:Open())
    //Carrega o conteudo do arquivo para array
    aLinhas := oFile:GetAllLines()
   
    //Fecha o arquivo
    oFile:Close()
   
    //Define a regua de processamento
    ProcRegua(Len(aLinhas))

    //Lê o arquivo linha a linha
    For nJ := 1 to Len(aLinhas)
        //Atualiza posição da regua de processamento
        INCPROC("Lendo arquivo csv (total de linhas "+AllTrim(AllToChar(nJ))+")")
        
        //Lê a próxima linha
        cLinha := aLinhas[nJ]
        
        //Remove caractere especial adicionado pelo Excel
        cLinha := replace(cLinha, "ï»¿", "")

        //Se não possuir ";" no final da linha a função StrToKarr não quebra corretamente
        If Substring(cLinha, Len(cLinha), 1) <> ";"
            cLinha := Alltrim(cLinha)+";"
        EndIf
        
        //trata campos vazios para leitura correta do StrToKarr
        While At(";;", cLinha) > 0
            cLinha := StrTran(cLinha, ";;", "; ;")
        EndDo
        
        If Substring(cLinha, 1, 1) == ";"
            cLinha := " "+cLinha
        EndIf
        
        //A primeira linha deve sempre ser os nomes dos campos
        If nJ > 1
            //Se não for a primeira linha, efetua a quabra das colunas
            Aadd(aDet, StrToKarr(cLinha, ";"))
        EndIf
    Next nJ
Else
	Alert("Não foi possivel abrir o arquivo, por favor verificar.")
EndIf

Return

/*/{Protheus.doc} User Function TWFUN03A
    (Altera o comprador de uma SC)
    @type  Function
    @author Pirolo
    @since 08/03/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function TWFUN03A()
Local cCodComp  := "   "
Local aAreaSC1  := SC1->(GetArea())
Local cNumSC    := SC1->(C1_FILIAL+C1_NUM)

aAdd(aPergs, {1, "Cód Comprador", cCodComp,  "", ".T.", "SY1", ".T.", 03,  .T.})

If ParamBox(aPergs ,"Migrar comprador",aRet)
    If SC1->(DbSeek(cNumSC))
        While SC1->(!Eof() .AND. cNumSC == SC1->(C1_FILIAL+C1_NUM))
            RecLock("SC1", .F.)
                SC1->C1_CODCOMP := MV_PAR01

        EndDo
    EndIf
EndIf

RestArea(aAreaSC1)
Return return_var
