#include 'protheus.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} FIIMPROT
Realiza a importação manual de arquivos fiorde
@author  marcio.katsumata
@since   18/09/2019
@version 1.0
@param   cEtapa, character, entidade a ser processada.
/*/
//-------------------------------------------------------------------
user function FIIMPROT(cEtapa)

    local cFileImp   as character
    local oSysFiUtl  as object
    local cDirIni    as character
    local cDirArq    as character
    local aImporting as array
    local lRet       as logical
    local cDrive     as character
    local cDiretorio as character 
    local cNome      as character
    local cExtensao  as character
    local cZNTFILIAL as character
    local cZNTCODPRC as character
    local cFileOnly  as character
    local cReaded    as character
    local lMove      as logical


    lMove   := .T.

    if cEtapa == 'RESULT'

        lRet := u_FIIMPCTL(,,,,,,,.T.) 

        oBrowseLeft:refresh(.T.)
        staticcall(FIADMPNL, loadZNT)
    else
        aFilAtu    :=  FWArrFilAtu()
        cCnpjAtu   :=  aFilAtu[18]
        aSize(aFilAtu,0)
        aImporting := {}
        oSysFiUtl := SYSFIUTL():new()
        cDirArq := oSysFiUtl:impPendPrc(cEtapa)
        cDirIni := strtran('SERVIDOR'+cDirArq, "\\","\") 

        cFileImp := cGetFile ( iif (cEtapa $ 'rnm/rdi/rnd',"text file .txt|*"+cCnpjAtu+"*.txt", "Comma-separated values.csv|*"+cCnpjAtu+"*.csv"),;
                               "Selecione o arquivo para importar", 1, cDirIni, .t., GETF_NOCHANGEDIR, .T.)
        

        if !empty(cFileImp)
            cFileImp := iif('\fiorde' $ cFileImp, cFileImp, cDirArq+cFileImp )
            if file(cFileImp)
                SplitPath ( cFileImp, @cDrive, @cDiretorio,@cNome, @cExtensao )
                cFileOnly := cNome+cExtensao
                //Estrtura do array de arquivo
                //- Entidade
                //  -Success
                //  -Arquivos do Success
                //      -Nome do arquivo
                //      -Caminho origem (onde o arquivo se encontra)
                //      -Caminho destino (onde o arquivo deve ser movido após o processamento)
                //  -Error
                //  -Arquivos do Error
                //      -Nome do arquivo
                //      -Caminho origem (onde o arquivo se encontra)
                //      -Caminho destino (onde o arquivo deve ser movido após o processamento)
                //--------------------------------------------------------------------------------

                aadd(aImporting,{} )
                nPos:= len(aImporting)
                aadd(aImporting[nPos],upper(cEtapa))


                aadd(aImporting[nPos],{})
                nPosSta := len(aImporting[nPos])
                aadd(aImporting[nPos][nPosSta], '')
                aadd(aImporting[nPos][nPosSta],{})

                //Verifica o diretório de arquivos pendentes por tipo de arquivo
                cReaded := oSysFiUtl:impReadPrc (cEtapa,'')
                cFilReg := ""

                aadd(aImporting[nPos][nPosSta][2], {lower(cFileOnly), lower(cFileImp), lower(cReaded+"\"+cFileOnly), cFilReg})  

                lRet := u_FIIMPCTL(,,,,,,aImporting)  

                aSize(aImporting,0)   

                if lRet
                    msgInfo("Arquivo processado.")
                else
                    eecview("Arquivo com erros no processamento "+CRLF+ZNT->ZNT_MSGERR)   
                    if !msgYesNo("Deseja manter o arquivo processsado para posterior reprocessamento?")
                        __copyFile(lower(cFileImp),lower(cReaded+"\"+cFileOnly))
                        FErase(lower(cFileImp)) 
                    endif

                endif  

                cZNTFILIAL := ZNT->ZNT_FILIAL
                cZNTCODPRC := ZNT->ZNT_CODPRC
                cZNTFILE   := ZNT->ZNT_FILE

                oBrowseLeft:refresh(.T.)
                staticcall(FIADMPNL, loadZNT)
            endif    
        endif
    endif
    freeObj(oSysFiUtl)
    
return 

