#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Kfin10m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_AAREAGERAL,_NTXCONTRATO,_NVALDOC,_NTXIOF,_NTARIFA,_NTXCPMF")
SetPrvt("_NTOTDESAGIO,_NTOTBORDERO,NVALOR,_CNUMBORDERO,_LACHOU,_AAREA")
SetPrvt("_AAREATRB,_NDIAS,_NTAXACONTRATO,_NPERCENTUAL,_NDESAGIO,_NIOF")
SetPrvt("_NCPMF,_NDESCONTO,_NTAXA,NTAXADESC,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KFIN10M  ³ Autor ³Ricardo Correa de Souza³ Data ³31/01/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gravacao das Taxas Aplicadas nos Borderos de Descontos     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Kenia Industrias Texteis Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
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


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valor de retorno da formula.                                        ³
//³                                                                     ³
//³ Devera ser um valor negativo, pois o Siga subtrai este retorno do   ³
//³ valor total do bordero, ou seja, a variavel " nValor ".             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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

