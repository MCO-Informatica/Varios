#include 'protheus.ch'

/*/{Protheus.doc} ArquivoConsolidadoRemuneracao
(long_description)
@author    yuri.volpe
@since     30/07/2020
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
class ArquivoConsolidadoRemuneracao 

	Data aLinhas

	Data cNomeArquivo
	Data oArquivo

	method new(cArquivo) constructor 
	Method createConsolidado()
	Method kill()

endclass

/*/{Protheus.doc} new
Metodo construtor
@author    yuri.volpe
@since     30/07/2020
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
method new(cArquivo) class ArquivoConsolidadoRemuneracao

	::aLinhas := {}
	::cNomeArquivo := ""

	If File(cArquivo)
		::cNomeArquivo := cArquivo
		::createConsolidado()
	EndIf

return

Method createConsolidado() Class ArquivoConsolidadoRemuneracao

	Local aLinha		:= {}

	::oArquivo := FileInputStream():New(::cNomeArquivo)
	
	While ::oArquivo:hasNext()
		aLinha := ::oArquivo:readLineToArray(";")
		aAdd(aLinha, ::oArquivo:nLine)
		aAdd(aLinha, ::oArquivo:cNome)
		//oConsolidado := ConsolidadoRemuneracao():New()
		//oConsolidado:fromArray(aLinha)
		aAdd(::aLinhas, ConsolidadoRemuneracao():fromArray(aLinha))
		
		//FreeObj(oConsolidado)
		//oConsolidado := Nil
	EndDo

	::kill()

Return

Method kill() Class ArquivoConsolidadoRemuneracao
	::oArquivo:close()
	FreeObj(::oArquivo)
	::oArquivo := Nil
Return

/*
	MODELO ARQUIVO
	
1	ZZ6_CODAC	C	Codigo AC		6			SIN
2	ZZ6_PERIOD	C	Periodo			6	not null	202006
3	ZZ6_CODENT	C	Cod.Entidade	6	not null	075412
4	ZZ6_DESENT	C	Des.Entidade	100			AR ACICG 
5	ZZ6_QTDPED	N	Qtde.Pedidos	9	0		1028
6	ZZ6_VALSW	N	Valor SW		15	0.00	233725.69
7	ZZ6_VALHW	N	Valor HW		15	0.00	1458.00
8	ZZ6_VALFAT	N	Valor Fat.		15	0.00	153827.00
9	ZZ6_COMSW	N	Comissao SW		15	0.00	3864.85
10	ZZ6_COMHW	N	Comissao HW		15	0.00	770.60
11	ZZ6_SALDO	N	Saldo			15	0.00	4748.50
12	ZZ6_COMTOT	N	Total Comiss	15	0.00	57282.18
13	ZZ6_VALFED	N	Valor Fed.		15	0.00	0.00
14	ZZ6_VALCAM	N	Val.Campanha	15	0.00	6048.88
15	ZZ6_VALVIS	N	Valor Visita	15	0.00	0.00
16	ZZ6_TOTGER	N	Total Geral		15	0.00	17512.08
17	ZZ6_ORIGEM	C	Origem Reg.		1	X		A
18	ZZ6_FEDSW	N	Vl. Fed. SW		15	0.00	15.25
19	ZZ6_FEDHW	N	Vl. Fed. HW		15	0.00	0.85
20	ZZ6_CAMPSW	N	Vl.Camp.SW		15	0.00	7820.24
21	ZZ6_CAMPHW	N	Vl.Camp.HW		15	0.00	4.50
22	ZZ6_VALPOS	N	Val.Posto		15	0.00	0.50
23	ZZ6_POSSW	N	Vl.Posto.SW		15	0.00	0.25
24	ZZ6_POSHW	N	Vl.Posto.HW		15	0.00	0.25
25	ZZ6_VALAR	N	Valor AR		15	0.00	15.00
26	ZZ6_ARSW	N	Valor AR SW		15	0.00	25.15
27	ZZ6_ARHW	N	Valor AR HW		15	0.00	13.00
28	ZZ6_FORNEC	C	Fornecedor		6	not null	001522
29	ZZ6_LOJA	C	Loja Forn.		2	not null	01
30	ZZ6_COND	C	Cond. Pagto		3	007	007
31	ZZ6_CCUSTO	C	Centro Custo	9	80000000	80000000
32	ZZ6_CC		C	Cta Contabil	20	420201014	420201014
33	ZZ6_FPGTO	C	Forma Pgto		120	not null	Boleto Bancário
34	ZZ6_NF		C	No. Doc. Fiscal	40		001564874
35	ZZ6_VENC	D	Vencimento		8		20/04/2015
36	ZZ6_CONTRA	C	Contrato		15		000000000001246
37	ZZ6_CNPJ	C	CNPJ/CPF		15		01001001000125

*/
