#include 'protheus.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} EICOR100
Integração com despachante.
Disponibilizado o ponto de entrada EICOR100 com diversos parâmetros 
que possibilitam alterações na rotina de integração com despachante.
@author  marcio.katsumata
@since   17/10/2019
@version 1.0
@see     https://tdn.totvs.com/pages/releaseview.action?pageId=342313622
/*/
//-------------------------------------------------------------------
user function EICOR100()

    Local cParam as character
    local bForCus
    
    IF Type("ParamIXB") == "C"
        cParam:= PARAMIXB
    Else
        cParam:= PARAMIXB[1]
    Endif

    DO CASE 
        //---------------------------------
        //Modificação da linha CAPI (capa)
        //---------------------------------
        CASE cParam == 'CAPI'

            //Realiza esta tratativa apenas para arquivos PO.
            if type('cFase') <> 'U' .and. type('FASE_PO') <> 'U'

                if cFase == FASE_PO
                    //Inclusão do exportador na CAPI
                    bForCus := { ||SW2->W2_EXPORTA+IIF(EICLoja(),SW2->W2_EXPLOJ,"")}
                    cTexto := STUFF(cTexto,059,004,PADR(staticcall(EICOR100,ORIBusGip,cCodigo,IF(lDePara2,"4","2"),EVAL(bForCus),cFase,"E"),4))
                    
                    //Inclusão do LOCAL de destino no CAPI
                    cTexto := STUFF(cTexto,241+(nColExtra*2),018,PADR(SYR->YR_DESTINO,18)) 
                endif

            endif
        //---------------------------------------
        //Modificação de valores da linha ITEA.
        //---------------------------------------
        CASE cParam == 'ITEA_VALORES'
            //Alteração do valor unitário caso o frete esteja incluso.
            //Deve se informar o preço unitário
            if SW2->W2_FREINC == '1' 
                cValor_Uni := SW3->W3_PRECO
            endif
   
        CASE cParam == 'ITEA'

            IF EasyGParam("MV_LAYDESP",,.F.)
                nInc:= 10
             Else
                nInc:= 0
             Endif

            if type('cFase') <> 'U' .and. type('FASE_DI') <> 'U'
                //----------------------------------------
                //Alteração do sequencia do arquivo de DI,
                //deve ser igual a W7_POSICAO
                //-----------------------------------------
                if cFase == FASE_DI 
                    Mseq := val(SW7->W7_POSICAO)
                    cTexto := STUFF(cTexto,237+nInc+(nColExtra*2),004,PADL(MSeq,4,"0"))     
                //----------------------------------------
                //Alteração do sequencia do arquivo de PO,
                //deve ser igual a W3_POSICAO
                //-----------------------------------------
                elseif cFase == FASE_PO
                    Mseq := val(SW3->W3_POSICAO)
                    cTexto := STUFF(cTexto,237+nInc+(nColExtra*2),004,PADL(MSeq,4,"0"))     
                endif
            endif   
        
        
        //----------------------------------------------
        //Renomeia o arquivo para o padrão da integração
        //----------------------------------------------
        CASE cParam == 'ANTES_CRIA_ARQ'
            if cFase == FASE_PO .or. cFase == FASE_DI
                aFilAtu := FWArrFilAtu()
                cCnpjArq := aFilAtu[18]
                cArqTxt:= cArq_Dest := iif(cFase == FASE_PO, "epo","edi")+ "_"+;
                             cCnpjArq+"_"+;
                             iif(cFase == FASE_PO, lower(alltrim(SW2->W2_PO_NUM)), lower(alltrim(SW6->W6_HAWB)))+"_"+;
                             dtos(date())+strtran(time(),":","")+".txt"

                aSize(aFilAtu,0)    
            endif

    ENDCASE

return