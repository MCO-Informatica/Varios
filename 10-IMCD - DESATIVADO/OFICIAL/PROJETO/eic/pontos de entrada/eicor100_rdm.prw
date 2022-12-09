#include 'protheus.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} EICOR100
Integra��o com despachante.
Disponibilizado o ponto de entrada EICOR100 com diversos par�metros 
que possibilitam altera��es na rotina de integra��o com despachante.
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
        //Modifica��o da linha CAPI (capa)
        //---------------------------------
        CASE cParam == 'CAPI'

            //Realiza esta tratativa apenas para arquivos PO.
            if type('cFase') <> 'U' .and. type('FASE_PO') <> 'U'

                if cFase == FASE_PO
                    //Inclus�o do exportador na CAPI
                    bForCus := { ||SW2->W2_EXPORTA+IIF(EICLoja(),SW2->W2_EXPLOJ,"")}
                    cTexto := STUFF(cTexto,059,004,PADR(staticcall(EICOR100,ORIBusGip,cCodigo,IF(lDePara2,"4","2"),EVAL(bForCus),cFase,"E"),4))
                    
                    //Inclus�o do LOCAL de destino no CAPI
                    cTexto := STUFF(cTexto,241+(nColExtra*2),018,PADR(SYR->YR_DESTINO,18)) 
                endif

            endif
        //---------------------------------------
        //Modifica��o de valores da linha ITEA.
        //---------------------------------------
        CASE cParam == 'ITEA_VALORES'
            //Altera��o do valor unit�rio caso o frete esteja incluso.
            //Deve se informar o pre�o unit�rio
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
                //Altera��o do sequencia do arquivo de DI,
                //deve ser igual a W7_POSICAO
                //-----------------------------------------
                if cFase == FASE_DI 
                    Mseq := val(SW7->W7_POSICAO)
                    cTexto := STUFF(cTexto,237+nInc+(nColExtra*2),004,PADL(MSeq,4,"0"))     
                //----------------------------------------
                //Altera��o do sequencia do arquivo de PO,
                //deve ser igual a W3_POSICAO
                //-----------------------------------------
                elseif cFase == FASE_PO
                    Mseq := val(SW3->W3_POSICAO)
                    cTexto := STUFF(cTexto,237+nInc+(nColExtra*2),004,PADL(MSeq,4,"0"))     
                endif
            endif   
        
        
        //----------------------------------------------
        //Renomeia o arquivo para o padr�o da integra��o
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