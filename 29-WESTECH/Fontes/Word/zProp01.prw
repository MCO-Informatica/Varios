#include "protheus.ch"
#include "MSOle.Ch"
#include "rwmake.ch"

user function zProp01()
    // ------------------------------------------------------------------------//
    // Area de declaração de variaveis                                         //
    //-------------------------------------------------------------------------//
    Local cCadastro    := OemtoAnsi("Integração com MS-Word")
    Local aMensagem    :={}
    Local aBotoes   :={}
    Local nOpca        := 0
    Local nPos        := 0
    Private cPerg   :=Padr("FMODWORD",10)
    //-------------------------------------------------------------------
    // Cria/Verifica as perguntas selecionadas
    //-------------------------------------------------------------------
    Pergunte(cPerg,.T.)
    AjustaSX1()
    //AADD(aMensagem,OemToAnsi("Esta rotina ira gerar documento no Word, clique no botão PARAM para informar o parametro") )
    /*AADD(aMensagem,OemToAnsi("demais parametros.") )
    AADD(aBotoes, { 5,.T.,{||  Pergunte(cPerg,.T. )}})
    AADD(aBotoes, { 6,.T.,{|o| nOpca := 1,FechaBatch()}})
    AADD(aBotoes, { 2,.T.,{|o| FechaBatch() }} )
    FormBatch( cCadastro, aMensagem, aBotoes )*/
    /*
    +------------------------------------------------------------------
    | Variaveis utilizadas para parametros
    +------------------------------------------------------------------
    | Variaveis utilizadas para parametros
    | mv_par01        // Arquivo Modelo
    | mv_par02        // Pasta de destino do documento
    | mv_par03        // Método de saida 1 = Impressora 2 = apenas Arquivo
    +-------------------------------------------------------------------
    */
    //If nOpca == 1
        PRIVATE oWord         := OLE_CreateLink()
        PRIVATE cPath        := AllTrim(mv_par01)
        nPos := Rat("\",cPath)
        If nPos <= 0
            cPath := cPath + "\"
        EndIF
        if empty(cPath) .OR. cPath = '\'
            MsgStop("Informe o dirtorio onde o arquivo será salvo.")
            RETURN .F.
        endif
        
        //If (oWord < "0")
            //Alert("MS-WORD nao encontrado nessa maquina!!!")
            //Return
        //Endif
        Processa({|| zGerarDoc() },"Aguarde...")
    //EndIf
Return

Static Function zGerarDoc()
    // ------------------------------------------------------------------------//
    // Area de declaração de variaveis                                         //
    //-------------------------------------------------------------------------//
     //Cria um ponteiro e já chama o arquivo
    Local cArquivo := "\\srvwt\arquivos_dot\Proposta_Modelo.dotx"
    // cliente
    Local cNProp := ""
    Local cTipoProp := ""
    Local cTipoCT := ""
    Local cIDContr := ""
    Local cEmpresa := ""
    Local cEnd := ""
    Local cBairro := ""
    Local cMunicipio := ""
    Local cEstado := ""
    Local cCEP := ""
    Local cProjeto := ""
    Local cReferencia := ""
    Local cFornecimento := ""

    // Contato
    Local cContato := ""
    Local cSetCont := ""
    Local cDDICont := ""
    Local cDDDCont := ""
    Local cFonCont := ""
    Local cEmailCo := ""

    // Responsavel
    Local cIDResp := ""
    Local cResponsavel := ""
    Local cCargo := ""
    Local cDDIResp := ""
    Local cDDDResp := ""
    Local cFoneResp := ""
    Local cEmailResp := ""

    // Representante
    Local cIDRepr := ""
    Local cRepresentante := ""
    Local cDDIRepr := ""
    Local cDDDRepr := ""
    Local cFoneRepr := ""
    Local cEmailRepr := ""

    Local nRev := 0

    // cliente - proposta
    cNProp := SZ9->Z9_NPROP
    cTipoCT := SZ9->Z9_TIPOPRO

    if cTipoCT = "1"
        cArquivo := "\\srvwt\arquivos_dot\Proposta_Comercial.dotx"
    else
        cArquivo := "\\srvwt\arquivos_dot\Proposta_Tecnica.dotx"
    endif
   
    if ALLTRIM(Posicione("SZ9",1,xFilial("SZ9")+cNProp,"Z9_TIPO")) = "1"
        if cTipoCT = "1"
            cTipoProp := "Comercial Firme"
        elseif cTipoCT = "2"
            cTipoProp := "Tecnica Firme"
        endif
    elseif ALLTRIM(Posicione("SZ9",1,xFilial("SZ9")+cNProp,"Z9_TIPO")) = "2"
        if cTipoCT = "1"
            cTipoProp := "Comercial Estimativa"
        elseif cTipoCT = "2"
            cTipoProp := "Tecnica Estimativa"
        endif
    else
        cTipoProp := "Prospecção"
    endif
    
    // ------------------------------------------------------------------------//
    // Abre as tabelas para consulta                                           //
    //-------------------------------------------------------------------------//
    set softseek off
    // Inicializa o Ole com o MS-Word
    BeginMsOle()
       cIDContr := SZ9->Z9_IDCONTR 
        cEmpresa := ALLTRIM(Posicione("SZ9",1,xFilial("SZ9")+cNProp,"Z9_CONTR"))
        cProjeto := ALLTRIM(Posicione("SZ9",1,xFilial("SZ9")+cNProp,"Z9_PROJETO"))
        cReferencia := ALLTRIM(Posicione("SZ9",1,xFilial("SZ9")+cNProp,"Z9_REFEREN"))
        cFornecimento := ALLTRIM(Posicione("SZ9",1,xFilial("SZ9")+cNProp,"Z9_ESCOPO"))
        cEnd := ALLTRIM(Posicione("SA1",1,xFilial("SA1")+cIDContr,"A1_END"))
        cBairro := ALLTRIM(Posicione("SA1",1,xFilial("SA1")+cIDContr,"A1_BAIRRO"))
        cMunicipio := ALLTRIM(Posicione("SA1",1,xFilial("SA1")+cIDContr,"A1_MUN"))
        cEstado := ALLTRIM(Posicione("SA1",1,xFilial("SA1")+cIDContr,"A1_EST"))
        cCEP := ALLTRIM(Posicione("SA1",1,xFilial("SA1")+cIDContr,"A1_CEP"))

        // contato
        cContato := Posicione("SZ9",1,xFilial("SZ9")+cNProp,"Z9_CONTATO") //M->Z9_CONTATO
        cSetCont := Posicione("SZ9",1,xFilial("SZ9")+cNProp,"Z9_SETCONT") //M->Z9_SETCONT
        cDDICont := Posicione("SZ9",1,xFilial("SZ9")+cNProp,"Z9_DDICONT") //M->Z9_DDICONT
        cDDDCont := Posicione("SZ9",1,xFilial("SZ9")+cNProp,"Z9_DDDCONT") //M->Z9_DDDCONT
        cFonCont := Posicione("SZ9",1,xFilial("SZ9")+cNProp,"Z9_FONCONT") //M->Z9_FONCONT
        cEmailCo := lower(Posicione("SZ9",1,xFilial("SZ9")+cNProp,"Z9_EMAILCO")) //M->Z9_EMAILCO)

        // Responsavel
        cIDResp  := SZ9->Z9_IDRESP
        cResponsavel := Posicione("SZL",1,xFilial("SZL")+cIDResp,"ZL_NOME") 
        cCargo := Posicione("SZL",1,xFilial("SZL")+cIDResp,"ZL_CARGO") 
        cDDIResp := Posicione("SZL",1,xFilial("SZL")+cIDResp,"ZL_DDI") 
        cDDDResp := Posicione("SZL",1,xFilial("SZL")+cIDResp,"ZL_DDD") 
        cFoneResp := Posicione("SZL",1,xFilial("SZL")+cIDResp,"ZL_FONE") 
        cEmailResp := lower(Posicione("SZL",1,xFilial("SZL")+cIDResp,"ZL_EMAIL") )

        // Representante
        cIDRepr := SZ9->Z9_CODREP
        cRepresentante := Posicione("SA3",1,xFilial("SA3")+cIDRepr,"A3_NOME")
        cDDIRepr := "55"
        cDDDRepr := Posicione("SA3",1,xFilial("SA3")+cIDRepr,"A3_DDDTEL")
        cFoneRepr := Posicione("SA3",1,xFilial("SA3")+cIDRepr,"A3_TEL")
        cEmailRepr := Posicione("SA3",1,xFilial("SA3")+cIDRepr,"A3_EMAIL")


        if EMPTY(cTipoCT)
            MsgAlert("Informe se a Proposta e Comercial ou Tecnica e clique em Confirmar para Salvar alteracao.")
            Return .F.
        endif
        if EMPTY(cNProp)
            MsgAlert("Informe Numero da Proposta e clique em Confirmar para Salvar alteracao.")
            Return .F.
        endif
        if EMPTY(cIDContr)
            MsgAlert("Informe ID Contratante e clique em Confirmar para Salvar alteracao.")
            Return .F.
        endif
        if EMPTY(cTipoProp)
            MsgAlert("Informe Tipo de Proposta e clique em Confirmar para Salvar alteracao.")
            Return .F.
        endif
        if EMPTY(cProjeto)
            MsgAlert("Informe Projeto e clique em Confirmar para Salvar alteracao.")
            Return .F.
        endif
        if EMPTY(cReferencia)
            MsgAlert("Informe Referencia e clique em Confirmar para Salvar alteracao.")
            Return .F.
        endif
        if EMPTY(cFornecimento)
            MsgAlert("Informe Escopo de Fornecimento e clique em Confirmar para Salvar alteracao.")
            Return .F.
        endif
        if EMPTY(cContato)
            MsgAlert("Informe Contato e clique em Confirmar para Salvar alteracao.")
            Return .F.
        endif
        if EMPTY(cSetCont)
            MsgAlert("Informe Setor e clique em Confirmar para Salvar alteracao.")
            Return .F.
        endif
        if EMPTY(cDDICont)
            MsgAlert("Informe DDI do contato e clique em Confirmar para Salvar alteracao." )
            Return .F.
        endif
        if EMPTY(cDDDCont)
            MsgAlert("Informe DDD do Contato e clique em Confirmar para Salvar alteracao.")
            Return .F.
        endif
        if EMPTY(cFonCont)
            MsgAlert("Informe Telefone do contato e clique em Confirmar para Salvar alteracao.")
            Return .F.
        endif
        if EMPTY(cEmailCo)
            MsgAlert("Informe E-maill do contato e clique em Confirmar para Salvar alteracao.")
            Return .F.
        endif
        if EMPTY(cIDResp)
            MsgAlert("Informe ID do Responsavel e clique em Confirmar para Salvar alteracao.")
            Return .F.
        endif
        
       

        If MsgYesNo("Atualizar Controle de Revisao?")//Se a condiï¿½ï¿½o for satisfatï¿½ria verdadeiro
            nRev := SZ9->Z9_REV + 1
            
            SZ9->( dbGoTop() )	            
            
            If SZ9->( dbSeek(xFilial("SZ9")+cNProp) )
            
                While SZ9->( ! EOF() ) .AND. SZ9->Z9_NPROP  == cNProp
                            
                    RecLock("SZ9",.F.)            
                            SZ9->Z9_REV := nRev
                    MsUnlock()  
                    SZ9->( dbSkip() )
                EndDo
            
            EndIf 

        else
            if empty(SZ9->Z9_REV)
                nRev := 0    
            endif
        Endif

        //OLE_CloseLink(oWord) //fecha o Link com o Word
    
        oWord := OLE_CreateLink()
        
        OLE_SetProperty( oWord, oleWdVisible, .T. ) 

        OLE_SetProperty( oWord, oleWdWindowState, '1' ) 

        OLE_NewFile(oWord, cArquivo) //cArquivo deve conter o endereço que o dot está na máquina, por exemplo, C:\arquivos_dot\teste.dotx
        Sleep(1000)
        //Setando o conteúdo das DocVariables
        // Empresa
        OLE_SetDocumentVar(oWord, "wNProp", cNProp )
        OLE_SetDocumentVar(oWord, "wTipoProp", cTipoProp )
        OLE_SetDocumentVar(oWord, "wEmpresa", cEmpresa )
        OLE_SetDocumentVar(oWord, "wEnd", cEnd + " - " + cBairro)
        OLE_SetDocumentVar(oWord, "wMunicipio", cMunicipio + ", " + cEstado )
        OLE_SetDocumentVar(oWord, "wCEP", cCep )
        OLE_SetDocumentVar(oWord, "wProjeto", cProjeto )
        OLE_SetDocumentVar(oWord, "wReferen", cReferencia )
        OLE_SetDocumentVar(oWord, "wFornecimento", cFornecimento )
        OLE_SetDocumentVar(oWord, "wData", cValToChar(day(Date())) + " de " + MesExtenso(Date()) + " de " + cValToChar(year(Date())) )
        Sleep(1000)
        // Contato
        OLE_SetDocumentVar(oWord, "wContato", cContato )
        OLE_SetDocumentVar(oWord, "wSetCont", cSetCont )
        OLE_SetDocumentVar(oWord, "wFonCont", "+" + cDDICont + " " + cDDDCont + " " + cFonCont )
        OLE_SetDocumentVar(oWord, "wEmailCo", cEmailCo )
        Sleep(1000)
        // Responsavel
        OLE_SetDocumentVar(oWord, "wResponsavel", cResponsavel )
        OLE_SetDocumentVar(oWord, "wCargo", cCargo )
        OLE_SetDocumentVar(oWord, "wFoneResp", "+" + cDDIResp + " " + cDDDResp + " " + cFoneResp )
        OLE_SetDocumentVar(oWord, "wEmailResp", cEmailResp )
        Sleep(1000)
        // Representante
        OLE_SetDocumentVar(oWord, "wRepresentante", cRepresentante )
        OLE_SetDocumentVar(oWord, "wFoneRepr", "+" + cDDIRepr + " " + cDDDRepr + " " + cFoneRepr )
        OLE_SetDocumentVar(oWord, "wEmailRepr", cEmailRepr )

        //Atualizando campos
        OLE_UpdateFields(oWord)
        
        //Monstrando um alerta
        //Fechando o arquivo e o link
        //OLE_SaveAsFile( nHandWord, cArqCria )
        //OLE_SaveFile ( oWord )

        //OLE_SaveAsFile( oWord, "C:\WINDOWS\TEMP\" + cNProp + "_protheus",'','',.F.,oleWdFormatDocument )
        //Sleep(1000)
        //OLE_CloseFile(oWord)
        //OLE_CloseLink(oWord)


        //OLE_OpenFile(oWord, "C:\WINDOWS\TEMP\" + cNProp + "_protheus.docx")
        //MsgAlert('O arquivo gerado no Microsoft Word!','Atencao')
        //--Atualiza Variaveis
        OLE_UpDateFields(oWord)
        //OLE_SaveFile ( oWord )
        Aviso("Atencao", "Alterne para o programa do Ms-Word para visualizar proposta." + CHR(13)+CHR(10) + "O arquivo sera salvo em " + cPath + " com nome " + cNProp + "_protheus-Rev"+ cValtoChar(nRev) + ".docx" )
        OLE_SaveAsFile(oWord,cPath + cNProp + "_protheus-Rev"+ cValtoChar(nRev) + ".docx")
             
            
        EndMsOle()
        OLE_CloseLink( oWord )//fecha o Link com o Word

        If MsgYesNo("Deseja abrir o arquivo?")
            oWord := OLE_CreateLink()
            OLE_OPENFILE( oWord, cPath + cNProp + "_protheus-Rev"+ cValtoChar(nRev) + ".docx")
        endif
Return

Static Function AjustaSx1()
  
    PutSx1(cPerg,"01","Pasta Destino  ","","","mv_ch1","C",99,0,0,"G","","HSSDIR","","","mv_par1")

Return

