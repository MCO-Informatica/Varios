#include 'protheus.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} IN100CLI
Customiza a tela de parâmetros da integração padrão.
Localizada no fonte eicin100
@author  marcio.katsumata
@since   17/09/2019
@version 1.0
@see     https://tdn.totvs.com/pages/releaseview.action?pageId=6806909
/*/
//-------------------------------------------------------------------
user function IN100CLI()

    local cPonto as character


    cPonto := PARAMIXB

    if IsInCallStack('U_FIIMPCTL')
        //---------------------------------------------------
        //Manipula variáveis para a importação automática de
        //arquivos pela rotina de automatização FIORDE
        //---------------------------------------------------
        DO CASE
            CASE cPonto == 'MENU'
                lIntDesp := .T.
            CASE cPonto == 'ANTES_ABRE_ARQ'
                lParam := .T.
            //-------------------------------
            //Armazena mensagens de erros 
            //-------------------------------
            CASE cPonto == 'VER_ERRO'
                if Type("cMsgEI100") == "C"
                    if type('cMsg') == 'C'
                        cMsgEI100 += cMsg +CRLF
                    endif
                endif
                    
        ENDCASE
    endif

return
    