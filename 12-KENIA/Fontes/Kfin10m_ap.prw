#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Kfin10m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("_AAREAGERAL,_NTXCONTRATO,_NVALDOC,_NTXIOF,_NTARIFA,_NTXCPMF")
SetPrvt("_NTOTDESAGIO,_NTOTBORDERO,NVALOR,_CNUMBORDERO,_LACHOU,_AAREA")
SetPrvt("_AAREATRB,_NDIAS,_NTAXACONTRATO,_NPERCENTUAL,_NDESAGIO,_NIOF")
SetPrvt("_NCPMF,_NDESCONTO,_NTAXA,NTAXADESC,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿛rograma  ? KFIN10M  ? Autor 쿝icardo Correa de Souza? Data ?31/01/2001낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escricao ? Gravacao das Taxas Aplicadas nos Borderos de Descontos     낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿢so       ? Kenia Industrias Texteis Ltda                              낢?
굇쳐컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇?            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           낢?
굇쳐컴컴컴컴컴컴컫컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇?   Analista   ?  Data  ?             Motivo da Alteracao               낢?
굇쳐컴컴컴컴컴컴컵컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇?              ?        ?                                               낢?
굇읕컴컴컴컴컴컴컨컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
/*/                                                            
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Executado a partir da formula (Configurador) - "DES"                      *
*                                                                           *
* O Ponto de Entrada FA60BDE atualizara os titulos e o                      *
* SEA com os valores a serem descontados por titulo,                        *
* individualmente.                                                          *
*                                                                           *
* nTaxaDesc = Percentual (taxa) utilizada na operacao de desconto           *
* nValCred    = Valor total do bordero (a Receber)                            *
* nQtdTit   = Quantidade de titulos selecionados para o bordero             *
* nValDesc  = Valor do desconto aplicado sobre o valor total do bordero     *
*                                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_aAreaGeral   := GetArea()

_nTxContrato  := 0
_nValDoc      := 0
_nTxIof       := 0
_nTarifa      := 0
_nTxCpmf      := 0
_nTotDesagio  := 0
_nTotBordero  := 0
_nTac		  := 0
_nFloat       := 0
//nValor        := 0

*--- Bordero ja processado + 1 ---*
_cNumBordero := strzero(val(GetMv('MV_NUMBORR'))+1,6)

dbselectarea('szr')
dbsetorder(1)
dbseek(xFilial('SZR')+_cNumBordero)
If found()
    _lAchou := .t.
Else
    _lAchou := .f.
EndIf

If _lAchou
    Return(nValor)
EndIf


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Montagem da tela de processamento.                                  ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

@200,001 to 460,460 dialog oDesconto TITLE 'Operacao de Desconto de Duplicata'

@005,015 say ' Taxa Permanencia : '		Size 50,10
@020,015 say ' Valor TAC        : '		Size 50,10
@035,015 say ' Valor TED/DOC    : '		Size 50,10
@050,015 say ' Taxa IOF         : '		Size 50,10
@065,015 say ' Valor Cobranca   : '		Size 50,10
@080,015 say ' Taxa CPMF        : '		Size 50,10
@095,015 say ' Float            : '		Size 50,10

@005,075 get _nTxContrato         picture '@e 999.9999'      		Size 50,10
@020,075 get _nTac                picture '@e 999,999.99'    		Size 50,10
@035,075 get _nValDoc             picture '@e 999.99'    		Size 50,10
@050,075 get _nTxIof              picture '@e 999.9999'      		Size 50,10
@065,075 get _nTarifa             picture '@e 999,999.99'    		Size 50,10
@080,075 get _nTxCpmf             picture '@e 999.9999'      		Size 50,10
@095,075 get _nFloat              picture '@e 999'      		Size 50,10

@110,150 BMPBUTTON TYPE 01 ACTION CalculoDesc()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> @110,150 BMPBUTTON TYPE 01 ACTION Execute(CalculoDesc)

activate dialog oDesconto center

RestArea(_aAreaGeral)

nValCred:= _nTotBordero-_nTotDesagio

Return(nValCred)
*---------------------------------------------------------------------*

*---------------------------------------------------------------------*
Static Function CalculoDesc
*---------------------------------------------------------------------*
* arquivo temporario do SigaFin, contendo os titulos filtrados, 
* marcados ou nao
*---------------------------------------------------------------------*

_aArea := GetArea()

dbselectarea('trb')

_aAreaTRB := GetArea()

dbgotop()

_nTotDesagio := 0
_nTotBordero := 0

while eof() == .f.
    if TRB->e1_ok <> cMarca
         dbselectarea('TRB')
         dbskip()
         loop
    endif

    _nDias         := (TRB->e1_vencrea + _nFloat) - dDataBase
    _nTaxaContrato := round(_nTxContrato / 30,6)

    _nPercentual   := round((_nTaxaContrato * _nDias) / 100,10)
    _nDesagio      := round(TRB->e1_saldo * _nPercentual,2)

    _nPercentual   := round((_nTxIof * _nDias) / 100,6)
    _nIof          := round(TRB->e1_saldo * _nPercentual,2)

    _nCpmf         := round(TRB->e1_saldo * round(_nTxCpmf / 100,8),2)

    _nDesconto     := _nDesagio + _nIof + _nCpmf + _nTarifa

    _nTotDesagio   := _nTotDesagio + _nDesconto

    _nTotBordero   := _nTotBordero + TRB->e1_saldo

    dbselectarea('trb')
    dbskip()
enddo

_nTotDesagio := _nTotDesagio + _nTac + _nValDoc

_nTaxa        := round(_nTotDesagio / _nTotBordero,6)
_nTaxa        := round(_nTaxa * 100,2)
nTaxaDesc     := _nTaxa

msgbox('Taxa Real: '+transform(_nTaxa,'@e 999.99')+'  Valor Liq: '+;
       transform((_nTotBordero-_nTotDesagio),'@e 999,999,999.99'),;
       'Taxa do Desconto','INFO')

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Valor de retorno da formula.                                        ?
//?                                                                     ?
//? Devera ser um valor negativo, pois o Siga subtrai este retorno do   ?
//? valor total do bordero, ou seja, a variavel " nValor ".             ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

//_nTotDesagio := _nTotDesagio * -1

RestArea(_aAreaTRB)

dbselectarea('szr')
dbsetorder(1)
If _lAchou
        reclock('SZR',.f.)
Else
        reclock('SZR',.t.)
EndIf

replace zr_filial       with xFilial('SZR')
replace zr_bordero      with _cNumBordero
replace zr_contrat      with _nTxContrato
replace zr_iof          with _nTxIof
replace zr_tarifa       with _nTarifa
replace zr_doc          with _nValDoc
replace zr_cpmf         with _nTxCpmf
replace zr_tac          with _nTac
replace zr_float        with _nFloat
replace zr_desagio      with _nTotDesagio

msUnlock()

Close(oDesconto)

RestArea(_aArea)

Return(_nTotDesagio*(-1))
*
*-------------------------------------------------------------------------*


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

