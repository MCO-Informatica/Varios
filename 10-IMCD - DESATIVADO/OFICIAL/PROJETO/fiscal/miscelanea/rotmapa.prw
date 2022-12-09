#include "Protheus.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} ROTMAPA
Rotina para gera��o do Mapa de Controle de Produtos Qu�micos 
conforme Portaria n� 240 de 12 de Mar�o de 2019. Siproquim 2.
Customizado para atender aglutina��o por NCM.
@author  marcio.katsumata
@since   22/08/2019
@version 1.0
/*/
//-------------------------------------------------------------------
user function ROTMAPA()

    local aRet      as array     //array de retorno da fun��o parambox
    local aParamBox as array     //array para definir os par�metros a ser apresentados no parambox
    local cDest     as character //arquivo definido para gera��o do mapa
    local cDir      as character //diret�rio definido para gravar o arquivo
    local dDataIni  as date      //data inicial do processamento
    local dDataFim  as date      //data final do processamento
    local nProcFil  as numeric   //sele��o de filiais 
    local lReceb    as logical   //Considera data de digita��o para filtrar doc de entrada?

    aRet := {}
    aParamBox := {}

    //-------------------------------------------------------------------------
    //Defin��o dos par�metros do parambox
    //------------------------------------------------------------------------
    aAdd(aParamBox,{9,"Informe os par�metros do MAPAS Siproquim 2:" ,150,7,.T.})
    aAdd(aParamBox,{1,"Data Inicial ",Ctod(Space(8)),"","","","",50,.T.}) 
    aAdd(aParamBox,{1,"Data Final ",Ctod(Space(8)),"","","","",50,.T.}) 
    aAdd(aParamBox,{1,"Arq. Destino",Space(30),"","","","",50,.T.}) 
    aAdd(aParamBox,{6,"Diretorio",Space(50),"","","",50,.T.,"",,GETF_LOCALHARD+GETF_RETDIRECTORY}) 
    aAdd(aParamBox,{2,"Seleciona Filiais",1,{"","N�o","Sim"},50,"",.T.})
    aAdd(aParamBox,{2,"Dt. Filtro Mov. Ent.",1,{"", "Dt. Digitacao", "Emiss�o NF"},50,"",.T.})   

    If ParamBox(aParamBox,"Par�metros",@aRet,,,,,,,.T.,.T.)

        //---------------------------------------------------
        //Inicializa��o de vari�veis conforme parametriza��o
        //---------------------------------------------------
        cDest    := AllTrim(aRet[4])
        cDir     := AllTrim(aRet[5])
        dDataIni := aRet[2]
        dDataFim := aRet[3]
        nProcFil := iif(aRet[6] == '' .or. aRet[6] == 'N�o' , 2, 1)
        lReceb   := iif(aRet[7] == 'Dt. Digitacao' .or. empty(aRet[7]), .T., .F.)
        //---------------------------
        //Inicio do processamento 
        //---------------------------
        oProcess := MsNewProcess():New({||  procMap(dDataIni, dDataFim, cDest, cDir, nProcFil,oProcess,lReceb)},"MAPAS Siproquim 2","Processando registros do MAPA",.F.) 
        oProcess:Activate()
        
        freeObj(oProcess)
    endif

return   

//-------------------------------------------------------------------
/*/{Protheus.doc} procMap
Processamento do MAPA
@author  marcio.katsumata
@since   22/08/2019
@version 1.0
@param   dDataDe, date, data inicio do processamento
@param   dDataAte, date, data final do processamento
@param   cArqDest, character,, nome do arquivo mapa
@param   cDir    , character, diret�rio onde ser� salvo o mapa
@param   nProcFil, numeric, seleciona filiais 1= 'SIM' 2= 'NAO'
@param   oProcess, object, barra de progresso
@return  nil, nil
/*/
//-------------------------------------------------------------------
static Function procMap(dDataDe, dDataAte, cArqDest, cDir, nProcFil,oProcess,lReceb)

    local oMapasPF  as object    //Objeto de gera��o do MAPA
    local cGrupoDe  as character //Grupo de produto inicial
    local cGrupoAte as character //Grupo de produto final
    local cProdDe   as character //Codigo de produto inicial
    local cProdAte  as character //Codigo de produto final
    local cFilBkp   as character //Backup do codigo de filial atual
    local nFil      as numeric   //Indice
    local lRet      as logical   //Retorno para seguir com o processamento
    local lFileOk   as logical   //Arquivo gerado com sucesso?
    local aFilsCalc as array     //Array com as filiais da empresa
    local oMapaNcm  as object
    local aNCM      as array
    local cMsgErro  as character

    //---------------------------
    //Inicializa��o de vari�veis
    //---------------------------
    oMapasPF := nil
    cGrupoDe := ""
    cGrupoAte := ""
    cProdDe := ""
    cProdAte := ""
    cFilBkp := ""
    nFil := 0
    lRet := .T.
    lFileOk := .F.
    cMsgErro := ""
    aNCM := {}
    aFilsCalc := MatFilCalc(nProcFil == 1)

    If Empty(aFilsCalc)
        lRet := .F.
    EndIf

    //-------------------------------------------------------------------
    //Realiza a leitura do arquivo de configura��o de algutina��o de NCMs
    //-------------------------------------------------------------------
    /*oMapaNCM := MAPALNCM():new()
    lRet := oMapaNCM:read(@cMsgErro)

    if !lRet 
        Eecview("[ERRO NA LEITURA DO ARQUIVO DE CONFIGURA��O NCM (mapasncm.csv)]"+CRLF+CRLF+cMsgErro)
    else
        aNCM := aClone(oMapaNCM:getCfg())
    endif
        
    oMapaNCM:destroy()
    freeObj(oMapaNCM)*/



    If lRet .And. !Pergunte("MAPASV2", .T.)
        lRet := .F.
    EndIf

    //-----------------------------------------
    //Atribui��o das vari�veis ap�s solicita��o 
    //dos par�metros ao usu�rio
    //-----------------------------------------
    cGrupoDe := mv_par01
    cGrupoAte := mv_par02
    cProdDe := mv_par03
    cProdAte := mv_par04



    //-----------------------------------------------------
    //Atribui��o do tamanho da primeira barra de progresso
    //-----------------------------------------------------
    oProcess:SetRegua1(Len(aFilsCalc))

    If lRet
    
        cFilBkp := cFilAnt
    
        For nFil := 1 to Len(aFilsCalc)
            //---------------------------------------------------
            //Incrementa a primeira barra de progresso
            //---------------------------------------------------
            oProcess:incRegua1("Processando filial "+aFilsCalc[nFil][2])    
            SysRefresh()
            ProcessMessage()

            //-----------------------------------------
            //Verifica se a filial deve ser processada
            //-----------------------------------------
            If aFilsCalc[nFil][1]
    
                cFilAnt  := aFilsCalc[nFil][2]


                //-----------------------------------------------------
                //Atribui��o do tamanho da segunda barra de progresso
                //-----------------------------------------------------
                oProcess:setRegua2(7)

                //---------------------------------------------------
                //Incrementa a segunda barra de progresso
                //---------------------------------------------------
                oProcess:IncRegua2("Selecionando registros...") 
                SysRefresh()
                ProcessMessage()  

                //-------------------------------------------------------------------------------
                //Cria inst�ncia do objeto MAPAIMCD e seleciona os registros a serem processados.
                //-------------------------------------------------------------------------------
                oMapasPF := MAPAIMCD():New(dDataDe, dDataAte, cGrupoDe, cGrupoAte, cProdDe, cProdAte, nProcFil, aFilsCalc[nFil][4], lReceb)
                
                //--------------------------------------------------------------------------
                //Verifica se as configura�ao minimas para o processamento do MAPA est�o OK.
                //--------------------------------------------------------------------------
                If !oMapasPF:lConfigOk
                    Exit
                EndIf

                //-----------------------------
                //Realiza a cria��o do arquivo 
                //-----------------------------
                lFileOk := oMapasPF:GeraTXT(cArqDest, cDir,oProcess)
    
                oMapasPF:Destructor()
    
                FreeObj(oMapasPF)
    
                If !lFileOk
                    Exit
                EndIf
    
            EndIf

        Next
    
        cFilAnt := cFilBkp
   
    EndIf


    if lRet .and. lFileOk
        msgInfo("Arquivo MAPA "+cArqDest+" gerado com sucesso no caminho : "+cDir)
        winexec("explorer.exe "+cDir)
    endif
    
    aSize(aNCM,0)

Return 
