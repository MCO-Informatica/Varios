#include 'totvs.ch'
#include 'protheus.ch'
#include 'rwmake.ch'
#include 'parmtype.ch'
#include "topconn.ch"

#DEFINE _CLRF CHR(13) + CHR(10)

user function XGBOL001(_cPrfTit,_cNumTit,_cPrcTit,_cTpoTit,_cChamada)
//    Rotina principal de registros de titulo no banco via webservices API
    local _lRet := .F.

    private _aSavArea := GetArea()
    private _aSavSE1  := SE1->(GetArea())
    private _aSavSEA  := SEA->(GetArea())
    private _aSavSEE  := SEE->(GetArea())
    private _cToken   := ''
    private _cNumbor  := ''

    default _cPrfTit := ''
    default _cNumTit := ''
    default _cPrcTit := ''
    default _cTpoTit := ''
    default _cChamada := ''
    
    _cRotina := 'SPEDNFE'
    if !(empty(alltrim(SE1->(E1_NUMBOR)))) .and. !(Funname() $ _cRotina) .and. empty(_cChamada)//valida se o titulo esta em Bordero
        Processa( {|| XGBOL002()}, 'Aguarde...', 'Identificando Token',.F.)
        //verifica o token
        // Fazer a validacao dos titulos
        if !(empty(_cToken))
            _cNumbor := SE1->E1_NUMBOR
            dbselectarea("SE1")
            dbsetorder(5)
            dbgotop()
            _nP := 0
            _nE := 0

            if msseek(xFilial('SE1')+_cNumbor) .and. !(empty(_cNumTit))
                while !(SE1->(eof())) .and. SE1->E1_NUMBOR == _cNumbor
                    if posicione('SE1',1,xFilial('SE1')+_cPrfTit+_cNumTit+_cPrcTit+_cTpoTit,'E1_VENCREA') < ddatabase
                        msgbox('O vencimento do titulo deve ser maior que ' + dtoc(ddatabase),'XGBOL001','alert')
                        //return()
                    endif
                    if SE1->(fieldpos('E1_XDTPROC')) <> 0 .and. alltrim(SE1->(E1_PORTADO)) == '341'

                    	//Valida se permite emitir boleto. Campo A1_XEMIBOL
                        If Posicione("SA1",1,xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,"A1_XEMIBOL") $ " |N"
                        	msgbox('Não é permitido emitir boletos para o cliente: '+SE1->E1_CLIENTE+" / " + SE1->E1_LOJA +",verifique o cadastro de cliente." ,'XGBOL001','alert')
                        	Return
                        EndIf

                        // Se nao tiver data de processamento ou ocorrencia de alteracao
                        if empty(SE1->(E1_XDTPROC))
                            Processa( {|| XGBOL003()}, 'Aguarde...', 'Processando titulos',.F.)
                            _nE ++
                        endif
                    endif
                    _nP ++
                    SE1->(dbskip())
                end
            endif
            _cMensErro := 'Foram processados '+cvaltochar(_nP)+' titulos e registrados ' +cValtoChar(_nE) +'.' + _CLRF
            _cMensErro += 'Para saber mais detalhes dos registros verifique o campo de observacao dos titulos.' + _CLRF

            if !(empty(_cMensErro))
                aviso("XGBOL003 - Envio de Titulo Itau",_cMensErro,{"Fechar"},3)
            endif
        else
            msgbox('Nao foi possivel autenticar a transacao no banco, Informe o Administrador do sistema.','XGBOL001','alert')
        endif
    elseif funname() $ _cRotina .or. !(empty(_cChamada))
        XGBOL002() // valida o token
        if !(empty(_cToken))
            dbselectarea('SE1')
            dbsetorder(1)//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
            if msseek(xFilial('SE1')+_cPrfTit+_cNumTit+_cPrcTit+_cTpoTit)
                if SE1->E1_VENCREA < ddatabase
                    msgbox('O vencimento do titulo deve ser maior que ' + dtoc(ddatabase),'XGBOL001','alert')
                    return(_lRet)
                endif

            	//Valida se permite emitir boleto. Campo A1_XEMIBOL
                If Posicione("SA1",1,xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,"A1_XEMIBOL") $ " |N"
                	msgbox('Não é permitido emitir boletos para o cliente: '+SE1->E1_CLIENTE+" / " + SE1->E1_LOJA +",verifique o cadastro de cliente." ,'XGBOL001','alert')
                    return(_lRet)
                EndIf

                if SE1->(fieldpos('E1_XDTPROC')) <> 0 .and. alltrim(SE1->(E1_PORTADO)) == '341'
                    if empty(SE1->(E1_XDTPROC)) // Processa a transmissao
                        _lRet := XGBOL003()
                    else // retorna que ja esta processado
                        _lRet := .T.
                    endif
                endif
            endif
        endif
    else
        msgbox('O titulo '+SE1->(E1_NUM)+' nao esta em bordero, insira o mesmo em um para o envio do CNAB on-line ITAu','XGBOL001','alert')
    endif
    
    restArea(_aSavSEE)
    restArea(_aSavSEA)
    restArea(_aSavSE1)
    restArea(_aSavArea)

return(_lRet)


static function XGBOL002()
// BUSCA CHAVE E ACESSO 
    local _cUrlToken  := 'https://oauth.itau.com.br/identity/connect/token'
    local _cGetParams := ''
    local _cPostParms := ''
    local _cHeaderGet := ''
    local _nTimeOut   := 600
    local _aHeadStr   := {}
    local _oObjJson   := nil
    local _cIdConect  := SuperGetMv("MV_XIDCONE" ,,"JignFdQS9NMR0")
    local _cSecret 	  := SuperGetMv("MV_XSECRET" ,,"Zwd1HxFETGvDZe6TiK8_KdtI1jU2SHcP-pE7r8L4s61AXSOjACVe2YPVvMet9w6lVjt9Cdrk1EdMBEAtIs9n_g2")
    
    aadd(_aHeadStr,"content-type: application/x-www-form-urlencoded")


    _cPostParms += "client_id="+_cIdConect+"&client_secret="+_cSecret+"&scope=readonly&grant_type=client_credentials"
    _cRet := HttpPost( _cUrlToken, _cGetParams, _cPostParms, _nTimeOut, _aHeadStr, @_cHeaderGet)

    if HttpGetStatus() == 200
        if FWJsonDeserialize(_cRet,@_oObjJson)
            _cToken := _oObjJson:ACCESS_TOKEN
            _cTime  := _oObjJson:EXPIRES_IN
            _cType  := _oObjJson:TOKEN_TYPE
        else
            // somente para testes - RETIRAR O IF
            if _cIdConect <> ''
                return()
//            ELSE 
//                _cToken := "TESTE"    
            ENDIF    
        endif
    else
        conout("Retorno invalido: " + cValToChar(HttpGetStatus()))
        //Alert("Retorno " + cValToChar(HttpGetStatus()))
        //somente para teste - retirar linha do  token?
        //_cToken := "TESTE"    
    endif
 
return()


static function XGBOL003()
// ENVIA O ARQUIVO JSON
    
    local _cURLpost   := 'https://gerador-boletos.itau.com.br/router-gateway-app/public/codigo_barras/registro'
    local _cGetParams := ''
    local _cPostParms := ''
    local _cHeadrPost := ''
    local _cTagjson   := ''
    local _cMensErro  := ''
    local _nTimeOut   := 600
    local _aHeadStr   := {}
    local _oObjJson   := nil
    local _lRet       := .F.
    local _dDataJ	  := ''
    local _cDtJur	  := ''
    local _cChvItau   := SuperGetMv("MV_XCHVITA" ,,"9a6a013b-54df-49a5-bf99-f674761f5775")
    local cQtde      := (SuperGetMv("MV_XQTDEV" ,,''))
	local cMen1      := (SuperGetMv("MV_XMEN1" ,,''))
	local cMen2      := (SuperGetMv("MV_XMEN2" ,,''))
   // local _nPorcJ     := 0
    local _nValjur	  := 0
    Local _x         := 0
    private _cNumbco  := ''
    
    
    // Inicia a montagem das tags
    _cTagjson := '{' + _CLRF
    // 1=testes/2=producao
    _cAmbItau := SuperGetMV('MV_XAMBREG',,'1')
    _cTagjson += '	"tipo_ambiente": '+_cAmbItau+',' + _CLRF

    //1=registro/2=alteracao/3=consulta
    if SE1->(E1_OCORREN) == '01'
        _cTagjson += '	"tipo_registro": '+'1'+',' + _CLRF
    else
        _cTagjson += '	"tipo_registro": '+'2'+',' + _CLRF
    endif

    //1=boletos/2=debito automatico/3=cartao de credito/4=TEF reversa
    _cTagjson += '	"tipo_cobranca": '+'1'+',' + _CLRF
    //00006=cliente
    _cTagjson += '	"tipo_produto": "00006",' + _CLRF
    //00008=cliente
    _cTagjson += '	"subproduto": "00008",' + _CLRF
    
    _cCGC := SuperGetMV('MV_XCGCBOL',,SM0->M0_CGC) 
    
    _cTagjson += '	"beneficiario": {' + _CLRF
    _cTagjson += '					"cpf_cnpj_beneficiario": "'+alltrim(_cCGC)+'",' + _CLRF
    _cTagjson += '					"agencia_beneficiario": "'+alltrim(SE1->(E1_AGEDEP))+'",' + _CLRF

    if '-' $ SE1->E1_CONTA
        _cTagjson += '					"conta_beneficiario": "'+strzero(val(substr(SE1->E1_CONTA,1,at('-',SE1->E1_CONTA)-1)),7)+'",' + _CLRF
        _cTagjson += '					"digito_verificador_conta_beneficiario": "'+substr(SE1->E1_CONTA,at('-',SE1->E1_CONTA)+1,1)+'"' + _CLRF
    else
        _cTagjson += '					"conta_beneficiario": "'+strzero(val(Left(alltrim(SE1->E1_CONTA) , Len(alltrim(SE1->E1_CONTA))-1)),7)+'",' + _CLRF
        _cTagjson += '					"digito_verificador_conta_beneficiario": "'+right(alltrim(SE1->E1_CONTA),1)+'"' + _CLRF
    endif
    _cTagjson += '					},' + _CLRF

    /*OPCIONAL
    _cTagjson += '	"debito": {' + _CLRF
    _cTagjson += '				"agencia_debito": "0000",' + _CLRF
    _cTagjson += '				"conta_debito": "0000000",' + _CLRF
    _cTagjson += '				"digito_verificador_conta_debito": "0"' + _CLRF
    _cTagjson += '			},' + _CLRF
    */

    //campo de livre 25c
    //_cTagjson += '	"identificador_titulo_empresa": "'+alltrim(SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO))+'",' + _CLRF
    _cTagjson += '	"identificador_titulo_empresa": "'+alltrim(SE1->(E1_NUM+E1_PARCELA))+'",' + _CLRF
    //uso interno do Banco 21c
    _cTagjson += '	"uso_banco": "",' + _CLRF
    //"S"=boleto de cobranca/"N"=boleto de proposta
    _cTagjson += '	"titulo_aceite": "S",' + _CLRF
    
    _cTagjson += '	"pagador": {' + _CLRF
    _cTagjson += '				"cpf_cnpj_pagador": "'+alltrim(posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_CGC"))+'",' + _CLRF
    _cTagjson += '				"nome_pagador": "'+substr(alltrim(posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_NOME")),1,30)+'",' + _CLRF
    _cTagjson += '				"logradouro_pagador": "'+substr(alltrim(posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_END")),1,40)+'",' + _CLRF
    _cTagjson += '				"bairro_pagador": "'+substr(alltrim(posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_BAIRRO")),1,15)+'",' + _CLRF
    _cTagjson += '				"cidade_pagador": "'+substr(alltrim(posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_MUN")),1,20)+'",' + _CLRF
    _cTagjson += '				"uf_pagador": "'+alltrim(posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_EST"))+'",' + _CLRF
    _cTagjson += '				"cep_pagador": "'+alltrim(posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_CEP"))+'",' + _CLRF
    _cTagjson += '				"grupo_email_pagador": [{' + _CLRF
    _cTagjson += '										"email_pagador": "'+ALLTRIM(substr(alltrim(posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_EMAIL")),1,100))+'"' + _CLRF
    _cTagjson += '										}]' + _CLRF
    _cTagjson += '				},' + _CLRF

    /*OPCIONAL
    _cTagjson += '	"sacador_avalista": {' + _CLRF
    _cTagjson += '						"cpf_cnpj_sacador_avalista": "",' + _CLRF
    _cTagjson += '						"nome_sacador_avalista": "",' + _CLRF
    _cTagjson += '						"logradouro_sacador_avalista": "",' + _CLRF
    _cTagjson += '						"bairro_sacador_avalista": "",' + _CLRF
    _cTagjson += '						"cidade_sacador_avalista": "",' + _CLRF
    _cTagjson += '						"uf_sacador_avalista": "",' + _CLRF
    _cTagjson += '						"cep_sacador_avalista": ""' + _CLRF
    _cTagjson += '	},' + _CLRF
    */

    //codigos de carteiras disponiveis
    //109, 110, 111, 124, 125, 131, 133, 142, 143, 145, 146, 148, 149, 150, 
    //153, 160, 167, 175, 179,182, 186, 187, 189, 196, 198, 202, 203, 210
    _cTagjson += '	"tipo_carteira_titulo": 109,' + _CLRF
    //Deve ser informado o codigo CNAB da moeda que expressa o valor do titulo. Para o Banco Itau o titulo e sempre emitido em real.
    //Para moeda real o campo deve ser preenchido com 09.
    _cTagjson += '	"moeda": {' + _CLRF
    _cTagjson += '			"codigo_moeda_cnab": "09",' + _CLRF
    _cTagjson += '			"quantidade_moeda": ""' + _CLRF
    _cTagjson += '			},' + _CLRF
    
    //Carteiras Diretas = Livre utilizacao pelo beneficiario *
    //Carteira 133 Enviar valor do nosso numero no campo uso da empresa.
    //Carteiras 189, 196 e 198 = Enviar os 8 primeiros digitos no campo nosso numero e os digitos restantes no campo seu numero.
    //* e um campo de livre utilizacao pelo usuario, nao podendo ser repetida se o numero ainda estiver registrado no Banco Itau
    // ou se transcorridos menos de 45 dias de sua Baixa/Liquidacao no Banco Itau. Dependendo da carteira de cobranca utilizada,
    // a faixa de Nosso Numero pode ser definida pelo Banco. A empresa e responsavel pelo seu controle e pela geracao correta do
    // numero do DAC (Digito de Auto Conferencia).
    
    //_cNumbco := U_VNNUM341(alltrim(SE1->E1_NUMBCO))
    _cNumbco := U_XGBOL004(alltrim(SE1->E1_NUMBCO))
    //_cTagjson += '	"nosso_numero": "'+substr(_cNumbco,1,len(_cNumbco)-1)+'",' + _CLRF
    _cTagjson += '	"nosso_numero": "'+substr(_cNumbco,4,8)+'",' + _CLRF
    _cTagjson += '	"digito_verificador_nosso_numero": "'+substr(_cNumbco,len(_cNumbco),1)+'",' + _CLRF

    //numero do codigo de barras 44c
    _cTagjson += '	"codigo_barras": "",' + _CLRF
    //data de vencimento do titulo (AAAA-MM-DD)
    _cVencto:= substr(DTOS(SE1->E1_VENCREA),1,4) + '-' + substr(DTOS(SE1->E1_VENCREA),5,2) + '-' + substr(DTOS(SE1->E1_VENCREA),7,2)
    _cTagjson += '	"data_vencimento": "'+_cVencto+'",' + _CLRF
    //Completar com zeros à esquerda e à direita (9 - Digito inteiro. 0 - Casa decimal) = 99999999999999900
    //_cTagjson += '	"valor_cobrado": "'+strzero((SE1->E1_VALOR*100),17)+'",' + _CLRF
    _cTagjson += '	"valor_cobrado": "'+strzero((SE1->(E1_SALDO-E1_SDDECRE+E1_SDACRES)*100),17)+'",' + _CLRF
    //_cTagjson += '	"seu_numero": "'+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+'",' + _CLRF
    _cTagjson += '	"seu_numero": "'+Alltrim(SE1->(E1_NUM+E1_PARCELA))+'",' + _CLRF
    /*
    01 - Duplicata Mercantil 01
    02 - Nota Promissoria 02
    03 - Nota de Seguro 03
    04 - Mensalidade Escolar 04
    05 - Recibo 05
    06 - Contrato 06
    07 - Cosseguros 07
    08 - Duplicata de Servico 08
    09 - Letra de Cambio 09
    13 - Nota de Debitos 13
    15 - Documento de Divida 15
    16 - Encargos Condominiais 16
    17 - Prestacao de Servicos 17
    18 - Boleto de Proposta 18
    99 - Diversos 99
    */
    _cTagjson += '	"especie": "01",' + _CLRF
    _cEmiss:= substr(DTOS(SE1->E1_EMISSAO),1,4) + '-' + substr(DTOS(SE1->E1_EMISSAO),5,2) + '-' + substr(DTOS(SE1->E1_EMISSAO),7,2)
    _cTagjson += '	"data_emissao": "'+_cEmiss+'",' + _CLRF
    //_cTagjson += '	"data_limite_pagamento": "'+_cVencto+'",' + _CLRF //Comentado por Arthur Silva em 21/01/2020 conforme solicitado pelo Sr. William, pois com essa configuração o título fica bloqueado para ajustes no banco.
    _cTagjson += '	"data_limite_pagamento": ""   ,' + _CLRF
    _cTagjson += '	"tipo_pagamento": 3,' + _CLRF
    /*
    true - Aceita pagamento parcial 
    false - Nao aceita pagamento parcial 
    */
    _cTagjson += '	"indicador_pagamento_parcial": "false",' + _CLRF
    _cTagjson += '	"quantidade_pagamento_parcial": "",' + _CLRF
    _cTagjson += '	"quantidade_parcelas": "",' + _CLRF
    
    // criar parametros para instrucoes
    /*
    Devolver apos 05 dias do vencimento 02
    Devolver apos 30 dias do vencimento 03
    Receber conforme instrucoes no proprio titulo 05
    Devolver apos 10 dias do vencimento 06
    Devolver apos 15 dias do vencimento 07
    Devolver apos 20 dias do vencimento 08
    PROTESTAR (envia a cartorio apos quantidade_dias dias uteis ou corridos do vencimento de acordo com o cadastro do beneficiario / nao imprimi no boleto) 09
    Nao protestar (inibe protesto, quando houver) 10
    Devolver apos 25 dias do vencimento 11
    Devolver apos 35 dias do vencimento 12
    Devolver apos 40 dias do vencimento 13
    Devolver apos 45 dias do vencimento 14
    Devolver apos 50 dias do vencimento 15
    Devolver apos 60 dias do vencimento 16
    Devolver apos 60 dias do vencimento 17
    Devolver apos 90 dias do vencimento 18
    Nao receber apos 05 dias do vencimento 19
    Nao receber apos 10 dias do vencimento 20
    Nao receber apos 15 dias do vencimento 21
    Nao receber apos 20 dias do vencimento 22
    Nao receber apos 25 dias do vencimento 23
    Nao receber apos 30 dias do vencimento 24
    Nao receber apos 35 dias do vencimento 25
    Nao receber apos 40 dias do vencimento 26
    Nao receber apos 45 dias do vencimento 27
    Nao receber apos 50 dias do vencimento 28
    Nao receber apos 55 dias do vencimento 29
    Importancia de desconto por dia 30
    Nao receber apos 60 dias do vencimento 31
    Nao receber apos 90 dias do vencimento 32
    Conceder abatimento ref. À PIS-PASEP/COFIN/CSLL, mesmo apos vencimento 33
    Protesto urgente (Envia a cartorio apos quantidade_dias uteis ou corridos do vencimento de acordo com o cadastro do beneficiario / nao imprime no boleto) 36
    Receber ate o ultimo dia do mes de vencimento 37
    Conceder desconto mesmo apos vencimento 38
    Nao receber apos o vencimento 39
    Conceder desconto conforme nota de credito 40
    Protesto para fins alimentares 42
    Sujeito a protesto se nao for pago no vencimento 43
    Importancia por dia de atraso a partir de YYYY-MM-DD 44
    Tem dia da graca 45
    Uso do banco 46
    Dispensar Juros/Comissao de permanencia 47
    Receber somente com a parcela anterior quitada 51
    Efetuar o pagamento somente atraves deste boleto e na rede bancaria 52
    Uso do banco 53
    Apos vencimento, pagavel somente na empresa 54
    Uso do banco 56
    Somar valor do titulo ao valor do campo mora/multa caso exista 57
    Devolver apos 365 dias de vencido 58
    Cobranca negociada. Pagavel somente por este boleto na rede bancaria 59
    Titulo entregue em penhor em favor do beneficiario acima 61
    Titulo transferido a favor do beneficiario 62
    Entrada em negativacao expressa (Impresso no boleto: “SUJEITO A NEGATIVAcaO APoS O VENCIMENTO”) 66
    Nao negativar (Inibe entrada na negativacao expressa) 67
    Uso do banco 70 a 75
    Valor da ida engloba multa de 10% pro rata 78
    Cobrar juros apos 15 dias da emissao (Para titulos com emissao à vista) 79
    Pagamento em cheque: Somente receber com cheque de emissao do pagador 80
    Protesto Urgente – Protestar apos quantidade_dias dias corridos do vencimento (imprime no boleto) 81
    Protesto urgente – Protestar apos quantidade_dias dias uteis do vencimento (imprime no boleto) 82
    Operacao referente a vendor 83
    Apos vencimento consultar a agencia beneficiario 84
    Antes do vencimento ou apos 15 dias, pagavel somente em nossa sede 86
    Uso do banco 87
    Nao receber antes do vencimento 88
    Uso do banco 89
    No vencimento, pagavel em qualquer agencia bancaria 90
    Nao receber apos quantidade_dias dias do vencimento 91
    Devolver apos quantidade_dias dias do vencimento 92
    Mensagens nos boletos com 30 posicoes 93
    Mensagens nos boletos com 40 posicoes 94
    Uso do banco 95 a 97
    Duplicata / Fatura nº 98
    */
    _dDataJ := (SE1->E1_VENCREA+1)
    //_cDtJur:= substr(DTOS(SE1->E1_VENCREA),1,4) + '-' + substr(DTOS(SE1->E1_VENCREA),5,2) + '-' + substr(DTOS(SE1->E1_VENCREA+1),7,2)
    _cDtJur := substr(DTOS(_dDataJ),1,4) + '-' + substr(DTOS(_dDataJ),5,2) + '-' + substr(DTOS(_dDataJ),7,2)
    //_cTagjson += '	"instrucao_cobranca_1": "'+SE1->(E1_OCORREN)+'",' + _CLRF
    If !Empty(cQtde)
        _cTagjson += '	"instrucao_cobranca_1": "92",' + _CLRF // devolver após x dias
        _cTagjson += '	"quantidade_dias_1": "' + strzero(val(cQtde),2)+ '",' + _CLRF
        _cTagjson += '	"data_instrucao_1": "'+_cDtJur+'",' + _CLRF
    else    
        _cTagjson += '	"instrucao_cobranca_1": "",' + _CLRF // devolver após x dias
        _cTagjson += '	"quantidade_dias_1": "",' + _CLRF
        _cTagjson += '	"data_instrucao_1": "",' + _CLRF
    ENDIF

    /*
    _cTagjson += '	"instrucao_cobranca_2": "84",' + _CLRF
    _cTagjson += '	"quantidade_dias_2": "00",' + _CLRF
    _cTagjson += '	"data_instrucao_2": "'+_cDtJur+'",' + _CLRF

    _cTagjson += '	"instrucao_cobranca_3": "21",' + _CLRF
    _cTagjson += '	"quantidade_dias_3": "15",' + _CLRF
    _cTagjson += '	"data_instrucao_3": "'+_cDtJur+'",' + _CLRF
    */
    _cTagjson += '	"instrucao_cobranca_2": "",' + _CLRF
    _cTagjson += '	"quantidade_dias_2": ""   ,' + _CLRF
    _cTagjson += '	"data_instrucao_2": "'+_cDtJur+'",' + _CLRF
    
    _cTagjson += '	"instrucao_cobranca_3": "",' + _CLRF
    _cTagjson += '	"quantidade_dias_3": ""   ,' + _CLRF
    _cTagjson += '	"data_instrucao_3": ""    ,' + _CLRF
    // Valor abatimento e opcional
    //_cTagjson += '	"valor_abatimento": "'+'000000000000000000'+'",' + _CLRF

    _cTagjson += '	"juros": {' + _CLRF
    _cTagjson += '				"data_juros": "'+_cDtJur+'",' + _CLRF
    // Tag Juros
    /*
    1 - Valor diario para incidencia de juros apos um dia corrido da Data de Vencimento
    2 - Percentual diario para incidencia de juros apos um dia corrido da Data de Vencimento
    3 - Percentual mensal para incidencia de juros apos um dia corrido da Data de Vencimento
    4 - Percentual anual para incidencia de juros apos um dia corrido da Data de Vencimento
    5 - Nao se aplica juros caso o titulo seja pago apos a Data de Vencimento (isento)
    6 - Valor diario para incidencia de juros apos um dia util da Data de Vencimento
    7 - Percentual diario para incidencia de juros apos um dia util da Data de Vencimento
    8 - Percentual mensal para incidencia de juros apos um dia util da Data de Vencimento
    9 - Percentual anual para incidencia de juros apos um dia util da Data de Vencimento
    */
	//if !empty(SE1->E1_VALJUR) // Alterado para considerar somente o percentual mensal, não obrigatorio informar o valor para tipo 3
	if !empty(SE1->E1_PORCJUR)
		//Trecho acrescentado devido ao banco recusar valores de juros menores que R$0.10, ele apresenta erro de integração se o valor for menor.
		_nValJur := round(SE1->(E1_SALDO+E1_ACRESC) * (SE1->E1_PORCJUR/30),2)
		If _nValJur < 0.11
            reclock("SE1",.F.)
                SE1->E1_PORCJUR := 0
                SE1->E1_VALJUR  := 0
            SE1->(msunlock())
		EndIf
		If _nValJur < 0.11
		    _cTagjson += '				"tipo_juros": 5,' + _CLRF
		    _cTagjson += '				"valor_juros": "'+strzero((SE1->E1_VALJUR*100),17)+'",' + _CLRF
		    _cTagjson += '				"percentual_juros": "'+strzero((SE1->E1_PORCJUR*100),12)+'"' + _CLRF
		Else
		    _cTagjson += '				"tipo_juros": 3,' + _CLRF	
		    //_cTagjson += '				"valor_juros": "'+strzero((SE1->E1_VALJUR*100),17)+'",' + _CLRF
		    //_cTagjson += '				"percentual_juros": "'+strzero((SE1->E1_PORCJUR*100),12)+'"' + _CLRF
			_cTagjson += '				"percentual_juros": "'+strzero((SE1->E1_PORCJUR*1000000),12)+'"' + _CLRF
		EndIf
    else
	    _cTagjson += '				"tipo_juros": 5,' + _CLRF
	    _cTagjson += '				"valor_juros": "'+strzero((SE1->E1_VALJUR*100),17)+'",' + _CLRF
	    _cTagjson += '				"percentual_juros": "'+strzero((SE1->E1_PORCJUR*100),12)+'"' + _CLRF
	endif
    //_cTagjson += '				"valor_juros": "'+strzero((SE1->E1_VALJUR*100),17)+'",' + _CLRF
    //_cTagjson += '				"percentual_juros": "'+strzero((SE1->E1_VALJUR*100),12)+'"' + _CLRF
    _cTagjson += '				},' + _CLRF
    
    _cTagjson += '	"multa": {' + _CLRF
    //Deve ser informada a data em que sera cobrada multa ao ser atingida. Caso esteja vazio, o valor automaticamente passara a assumir a data de vencimento.
    _cTagjson += '				"data_multa": "",' + _CLRF
    /*
    1 - Quando se deseja cobrar um valor fixo de multa apos o vencimento.
    2 - Quando se deseja cobrar um percentual do valor do titulo de multa apos o vencimento.
    3 - Quando nao se deseja cobrar multa caso o pagamento seja feito apos o vencimento (isento)
    */
    //_cTagjson += '				"tipo_multa": 3,' + _CLRF
    _cTagjson += '				"tipo_multa": 2,' + _CLRF
    _cTagjson += '				"valor_multa": "00000000000000000",' + _CLRF
	/*
	Validacao: Inserir em formato 999999900000
	Completar com zeros a esquerda e a direita
	(9 - Digito inteiro. 0 - Casa decimal)
	*/
    _cTagjson += '				"percentual_multa": "000000200000"' + _CLRF
    _cTagjson += '				},' + _CLRF
    

    _cTagjson += '	"grupo_desconto": [{' + _CLRF
    _cTagjson += '						"data_desconto": "",' + _CLRF
    /*
    0 - Quando nao houver condicao de desconto – sem desconto
    1 - Quando o desconto for um valor fixo se o titulo for pago ate a data informada (data_desconto)
    2 - Quando o desconto for um percentual do valor do titulo e for pago ate a data informada (data_desconto)
    3 - Quando o desconto for um valor dependente da quantidade de dias corridos na antecipacao do pagamento referente à Data de Vencimento.
    4 - Quando o desconto for um valor dependente da quantidade de dias uteis na antecipacao do pagamento referente à Data de Vencimento.
    5 - Quando o desconto for um percentual do valor do titulo e dependente da quantidade de dias corridos na antecipacao do pagamento referente à Data de Vencimento
    6 - Quando o desconto for um percentual do valor do titulo e dependente da quantidade de dias uteis na antecipacao do pagamento referente à Data de Vencimento.
    */
    _cTagjson += '						"tipo_desconto": 0,' + _CLRF
    _cTagjson += '						"valor_desconto": "",' + _CLRF
    _cTagjson += '						"percentual_desconto": ""' + _CLRF
    _cTagjson += '						}],' + _CLRF
    
    _cTagjson += '	"recebimento_divergente": {' + _CLRF
    /*
    1 - Quando o titulo aceita qualquer valor divergente ao da cobranca
    2 - Quando o titulo contem uma faixa de valores aceitos para recebimentos divergentes
    3 - Quando o titulo nao deve aceitar pagamentos de valores divergentes ao da cobranca
    4 - Quando o titulo aceitar pagamentos de valores superiores ao minimo definido
    */
    _cTagjson += '								"tipo_autorizacao_recebimento": "3",' + _CLRF
    _cTagjson += '								"tipo_valor_percentual_recebimento": "",' + _CLRF
    _cTagjson += '								"valor_minimo_recebimento": "",' + _CLRF
    _cTagjson += '								"percentual_minimo_recebimento": "",' + _CLRF
    _cTagjson += '								"valor_maximo_recebimento": "",' + _CLRF
    _cTagjson += '								"percentual_maximo_recebimento": ""' + _CLRF
    /*
    //Tag Grupo de rateio e Opcional
    // Se acrescentar a Tag Rateio observe a tag de fechamento
    //_cTagjson += '								},' + _CLRF
    _cTagjson += '	"grupo_rateio": [{' + _CLRF
    _cTagjson += '					"agencia_grupo_rateio": "",' + _CLRF
    _cTagjson += '					"conta_grupo_rateio": "",' + _CLRF
    _cTagjson += '					"digito_verificador_conta_grupo_rateio": "",' + _CLRF
    _cTagjson += '					"tipo_rateio": "",' + _CLRF
    _cTagjson += '					"valor_percentual_rateio": ""' + _CLRF
    _cTagjson += '					}]' + _CLRF
    */
    _cTagjson += '								}' + _CLRF
    _cTagjson += '}'
    conout(_cTagjson)
    /* 
    Itau chave: 9a6a013b-54df-49a5-bf99-f674761f5775
    Id Cliente: KoyB6m4vRPiF0
    SEGREDO: JdXDCoAXg8_pjSqcRkC2lgKdk5Nzf02AArD8Uuei8OnpINUHxMP5fOUy485Tdhq5mIlGSmP2N3JEJp0eAXZNdA2
    */

    aadd(_aHeadStr,"Accept:application/vnd.itau")
    aadd(_aHeadStr,"access_token:"+_cToken)
    aadd(_aHeadStr,"itau-chave:"+_cChvItau) // Chave Cliente 
    aadd(_aHeadStr,"identificador:"+ SM0->M0_CGC) // CNPJ 
    aadd(_aHeadStr,"Content-Type:application/json")
    _cPostParms := _cTagjson
    //HttpPost( < cUrl >, [ cGetParms ], [ cPostParms ], [ nTimeOut ], [ _aHeadStr ], [ @_cHeaderGet ] )
    _cRet := HttpPost( _cURLpost, _cGetParams, _cPostParms, _nTimeOut, _aHeadStr, @_cHeadrPost)
    if HttpGetStatus() == 200
        _lRet := .T.
        if FWJsonDeserialize(_cRet,@_oObjJson)
            _cCodBar   := _oObjJson:CODIGO_BARRAS
            _cLinDig   := _oObjJson:NUMERO_LINHA_DIGITAVEL
            _dProcess := stod(substr(_oObjJson:DATA_PROCESSAMENTO,1,4) + substr(_oObjJson:DATA_PROCESSAMENTO,6,2) + substr(_oObjJson:DATA_PROCESSAMENTO,9,2))
            reclock('SE1',.F.)

                if SE1->(fieldpos('E1_CODBAR')) <> 0
                    SE1->(E1_CODBAR) := _cCodBar
                else
                    _cMensErro+= 'Campo [E1_CODBAR] nao criado, o codigo de barras nao pode ser gravado' + _CLRF
                endif

                if SE1->(fieldpos('E1_XLNDIGT')) <> 0
                    SE1->(E1_XLNDIGT) := _cLinDig
                else
                    _cMensErro+= 'Campo [E1_XLNDIGT] nao criado, a linha digitavel nao pode ser gravada' + _CLRF
                endif

                if SE1->(fieldpos('E1_XDTPROC')) <> 0
                    SE1->(E1_XDTPROC) := _dProcess
                else
                    _cMensErro+= 'Campo [E1_XDTPROC] nao criado, a data de processamento nao pode ser gravada' + _CLRF
                endif

                if SE1->(fieldpos("E1_XMSGERR")) <> 0
                    SE1->(E1_XMSGERR) := _cMensErro
                else
                    _cMensErro+= 'Campo [E1_XMSGERR] nao criado, a data de processamento nao pode ser gravada' + _CLRF
                endif
                if SE1->(fieldpos('E1_XLPROC')) <> 0
                    SE1->(E1_XLPROC) := 'S'
                else
                    _cMensErro+= 'Campo [E1_XLPROC] nao criado, o status de processamento nao pode ser gravado' + _CLRF
                endif
                If Empty(SE1->E1_IDCNAB)
                	SE1->E1_IDCNAB := (SE1->E1_NUM+SE1->E1_PARCELA)
                EndIf
                if !(empty(_cMensErro))
                    aviso("XGBOL003 - Envio de Titulo Itau",_cMensErro,{"Fechar"},3)
                endif
            SE1->(msunlock())
        else
            conout("Falha ao deserealizar o objeto")
            //return()
        endif
    elseif HttpGetStatus() == 400
        FWJsonDeserialize(_cRet,@_oObjJson)
        _cMensErro += _oObjJson:CODIGO + _CLRF
        _cMensErro += _oObjJson:MENSAGEM + _CLRF
        _cMensErro += "Titulo - "+ SE1->(E1_PREFIXO)+SE1->(E1_NUM)+SE1->(E1_PARCELA)+ _CLRF
        for _x := 1 to len(_oObjJson:CAMPOS)
            _cMensErro += replicate("-",80) + _CLRF
            _cMensErro += "Erro - "+cvaltochar(_x) + _CLRF
            _cMensErro += "Campo   - " + _oObjJson:CAMPOS[_x]:CAMPO + _CLRF
            _cMensErro += "Mensagem- " + _oObjJson:CAMPOS[_x]:MENSAGEM + _CLRF
            if valtype(_oObjJson:CAMPOS[_x]:VALOR) == "N"
                _cMensErro += "Valor   - " + cvaltochar(_oObjJson:CAMPOS[_x]:VALOR) + _CLRF
            else
                _cMensErro += "Valor   - " + _oObjJson:CAMPOS[_x]:VALOR + _CLRF
            endif
        next
        if !(empty(_cMensErro))
            aviso("XGBOL003 - Envio de Titulo Itau",_cMensErro,{"Fechar"},3)
        endif
        if SE1->(fieldpos("E1_XMSGERR")) <> 0
            reclock("SE1",.F.)
                SE1->(E1_XMSGERR) := _cMensErro
            SE1->(msunlock())
        else
            _cMensErro+= 'Campo [E1_XMSGERR] nao criado, a data de processamento nao pode ser gravada' + _CLRF
        endif
        if SE1->(fieldpos('E1_XLPROC')) <> 0
            reclock("SE1",.F.)
                SE1->(E1_XLPROC) := 'N'
            SE1->(msunlock())
        else
            _cMensErro+= 'Campo [E1_XLPROC] nao criado, o status de processamento nao pode ser gravada' + _CLRF
        endif
    else
    	
    	msgbox('Nao foi possível postar registro do título: - Erro ' + cvaltochar(HttpGetStatus()) + " - " + _cRet,'XGBOL003','stop')
    	
        If SE1->(fieldpos("E1_XMSGERR")) <> 0
            reclock("SE1",.F.)
                SE1->(E1_XMSGERR) := _cRet
            SE1->(msunlock())
        EndIf
    endif

return(_lRet)

user function XGBOL004(_cNNumero)
    
    local cCart := ''
    local _aSavSEE  := SEE->(GetArea())
    local _NossNum  := ""
    local _cSbct    := ""
    local _cFilial  := ""
    Local _x        := 0
    private ModuloNN  := 10
    private StrMult   := "12121212121212121212"
    
    default _cNNumero := ''
    
    
    dbselectarea('SEE')
	SEE->(dbsetorder(1))//EE_FILIAL+EE_CODIGO+EE_AGENCIA+EE_CONTA+EE_SUBCTA
	if  msseek(xFilial('SEE')+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA,.T.,.F.) 
        //msseek(xFilial('SEE')+SE1->E1_PORTADO+SE1->E1_AGEDEP+SUBSTR(SE1->E1_CONTA,1,AT("-", SE1->E1_CONTA)-1) )
	    cCart := AllTrim(SEE->EE_CODCART)
    endif
    If empty(cCart)
        cCart :=  '109'        
	endif
	
    //AGeNCIA / CONTA (sem DAC) / CARTEIRA / NOSSO NuMERO
    if !(empty(_cNNumero))
        _nSeq := SubStr(SE1->E1_NUMBCO,len(alltrim(SE1->E1_NUMBCO))-7,8)
        BaseDac  := AllTrim(SE1->E1_AGEDEP) + Left(alltrim(SE1->E1_CONTA) , Len(alltrim(SE1->E1_CONTA))-1) + cCart + _nSeq
        VarDac   := 0

        for _x := 1 to 20
            _cMult := StrZero(Val(SubStr(BaseDac,_x,1)) * Val(SubStr(StrMult,_x,1)),2)
            VarDac += Val(SubStr(_cMult,1,1)) + Val(SubStr(_cMult,2,1))
        next
        _nResto := MOD(VarDac,10)
        VarDac   := 10-_nResto

        if VarDac == 10
            VarDac  := "0"
        else
            VarDac  := Str(VarDac,1)
        endif
        _NossNum := cCart + _nSeq + VarDac

    else //Se for para atualizar nosso numero e/ou primeira impressao gerando nosso numero
    	
    	_cSbct := "0"
    	_cFilial := xFilial('SEE')
    	
        dbselectarea('SEE')
        SEE->(dbsetorder(1))//EE_FILIAL+EE_CODIGO+EE_AGENCIA+EE_CONTA+EE_SUBCTA
        //if msseek(xFilial('SEE')+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA+_cSbct,.T.,.F.)
        
        //Ajuste realizado, pois no cadastro da SEE não é compartilhado e é utilizado o mesmo registro para integração
        //de outras filiais, isso foi feito por causa da sequência numérica do Nosso Numero ao integrar com o banco.
        // Se for registros diferentes integrando no mesmo banco, terá problemas na integração por causa da numeração. 
        if  msseek(_cFilial+SE1->E1_PORTADO+SE1->E1_AGEDEP + SE1->E1_CONTA + _CSBCT)
        //msseek(_cFilial+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA+_cSbct,.T.,.F.)
            if Empty(SEE->EE_FAXATU)
                RecLock("SEE",.F.)
                    SEE->EE_FAXATU := Substr(SEE->EE_FAXINI,1,08)
                SEE->(MsUnLock())
            endif
            x := SEE->EE_FAXATU
            if Val(x) > Val(Substr(SEE->EE_FAXFIM,1,08))
                Alert("O nosso numero atingiu a faixa maxima permitida. A sequencia sera reiniciada.")
                // Reinicia automaticamente conforme a faixa inicial cadastrada no cadastro de 
                x := SEE->EE_FAXINI
            endif
            //Verificar se esta gravando o registro correto
            RecLock("SEE",.F.)
                SEE->EE_FAXATU := StrZero(Val(x)+1,08)
            SEE->(MsUnLock())

            _nSeq    := StrZero(VAL(SEE->EE_FAXATU),08)
            // Claudia 25/02/2021 - no SEE a conta está com o digito, mas não tem o - e por isso dava erro de digito verificador pois ia oum digito a mais.
            //BaseDac  := AllTrim(SEE->EE_AGENCIA) + AllTrim(IIF("-"$SEE->EE_CONTA,SubStr(SEE->EE_CONTA,1,AT("-",SEE->EE_CONTA)-1),SEE->EE_CONTA)) + cCart + _nSeq
            BaseDac  := AllTrim(SE1->E1_AGEDEP) + Left(alltrim(SE1->E1_CONTA) , Len(alltrim(SE1->E1_CONTA))-1) + cCart + _nSeq
            VarDac   := 0
            For _x := 1 To 20
                _cMult := StrZero(Val(SubStr(BaseDac,_x,1)) * Val(SubStr(StrMult,_x,1)),2)
                VarDac += Val(SubStr(_cMult,1,1)) + Val(SubStr(_cMult,2,1))
            Next _x
            _nResto := MOD(VarDac,10)
            VarDac   := 10-_nResto
            if VarDac == 10
                VarDac  := "0"
            Else 	
                VarDac  := Str(VarDac,1)
            Endif
            _NossNum := cCart+_nSeq + VarDac
            
            RecLock("SE1",.F.)
                SE1->E1_NUMBCO  := cCart + _nSeq 
                if SE1->(fieldpos('E1_XNOSNUM')) <> 0
                    SE1->E1_XNOSNUM := "S"
                end
            SE1->(MsUnLock())
        else
            msgbox('Nao foi possivel encontrar a faixa para nosso-numero. Verifique o cadastro de Parametros banco','XGBOL003','stop')
        endif
    endif
    restArea(_aSavSEE)

return(_NossNum)


user function XGBOL005(_cPrfTit,_cNumTit,_cPrcTit,_cTpoTit)
//GERA O BORDERO PARA O TITULO
    local _cBco  := SuperGetMv("MV_XBCOAPI" ,,"341")
    local _cAge  := SuperGetMv("MV_XAGENAP" ,,"0761")
    local _cCnt  := SuperGetMv("MV_XCONTAP" ,,"461060")
    local _cSit  := '1'
    local _cNBor := ''
   // local _cMsgAlert := ''
   // local _aTit  := {}
   // local _aBor  := {}
   // local aErroAuto := {}
   // local cErroRet  := ''
   // local nCntErr   := 0
    local _lRet := .T.

    private lMsErroAuto    := .F.
    private lMsHelpAuto    := .T.
    private lAutoErrNoFile := .T.

    default _cPrfTit := ''
    default _cNumTit := ''
    default _cPrcTit := ''
    default _cTpoTit := ''

    if !(empty(_cNumTit))
        // Pega o numero do bordero para os titulos automaticos
		//if supergetmv('MV_XDTNBOR',,,xFilial()) == dtos(ddatabase)
        
        _cNBor := NextNumero("SEA",1,"EA_NUM",.T.,)

        /* retirado claudia
		if GetNewPar('MV_XDTNBOR','') == dtos(ddatabase)
            _cNBor := getmv('MV_XNUMBOR')
            if (empty(_cNBor))
                _cNBor := NextNumero("SEA",1,"EA_NUM",.T.,)
                if PutMV('MV_XNUMBOR',_cNBor)
                    if !(PutMV('MV_XDTNBOR',dtos(ddatabase)))
                        _cMsgAlert+= 'Parametro [MV_XDTNBOR] nao criado.' + _CLRF
                    endif
                else
                    _cMsgAlert+= 'Parametro [MV_XNUMBOR] nao criado.' + _CLRF
                endif
            endif
        else
            _cNBor := NextNumero("SEA",1,"EA_NUM",.T.,)
            if PutMV('MV_XNUMBOR',_cNBor)
                if !(PutMV('MV_XDTNBOR',dtos(ddatabase)))
                    _cMsgAlert+= 'Parametro [MV_XDTNBOR] nao criado.' + _CLRF
                endif
            else
                _cMsgAlert+= 'Parametro [MV_XNUMBOR] nao criado.' + _CLRF
            endif
        endif
        if !(empty(_cMsgAlert))
            aviso("XGBOL005 - Gera bordero",_cMsgAlert,{"Fechar"},3)
        endif
        */
        dbselectarea('SE1')
        dbsetorder(1)//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
        if msseek(xFilial('SE1')+_cPrfTit+_cNumTit+_cPrcTit+_cTpoTit)
            if empty(SE1->E1_NUMBOR)
                reclock("SE1",.F.)
                    SE1->E1_PORTADO := _cBco
                    SE1->E1_AGEDEP  := _cAge
                    SE1->E1_CONTA   := _cCnt
                    SE1->E1_SITUACA := _cSit
                    SE1->E1_NUMBOR  := _cNBor
                    SE1->E1_DATABOR := dDataBase
                    SE1->E1_MOVIMEN := dDataBase
                    SE1->E1_OCORREN := "01"
                SE1->(msunlock())

                dbselectarea('SEA')
                dbsetorder(1) //EA_FILIAL+EA_NUMBOR+EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA
                if !(msseek(xFilial('SEA')+_cNBor+_cPrfTit+_cNumTit+_cPrcTit+_cTpoTit))
                    reclock("SEA",.T.)
                        SEA->EA_FILIAL  := xFilial("SEA")
                        SEA->EA_PREFIXO := _cPrfTit
                        SEA->EA_NUM     := _cNumTit
                        SEA->EA_PARCELA := _cPrcTit
                        SEA->EA_NUMBOR  := _cNBor
                        SEA->EA_DATABOR := ddatabase
                        SEA->EA_PORTADO := _cBco
                        SEA->EA_AGEDEP  := _cAge
                        SEA->EA_NUMCON  := _cCnt
                        SEA->EA_TIPO    := _cTpoTit
                        SEA->EA_CART    := "R"
                        SEA->EA_SITUACA := _cSit
                        //SEA->EA_SITUANT := _cSitAnt
                        //SEA->EA_FILORIG := xFilial("SEA")
                        //SEA->EA_PORTANT := _cBco
                        //SEA->EA_AGEANT  := _cAge
                        //SEA->EA_CONTANT := _cCnt
                    SEA->(msunlock())
                endif
            else
                msgbox('O titulo ja se encontra em outro bordero','','alert')
            endif
        else
            msgbox('O titulo nao foi encontrado','','alert')
        endif
    else
        _lRet := .F.
    endif

return(_lRet)
