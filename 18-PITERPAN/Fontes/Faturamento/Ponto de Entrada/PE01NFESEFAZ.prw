#include 'protheus.ch'
#include 'tbiconn.ch'
#include 'topconn.ch'
#include 'fileio.ch'
#INCLUDE "rwmake.ch"

/*/{Protheus.doc} User Function PE01NFESEFAZ
    Ponto de Entrada utilizado na Rotina de Nfe-Sefaz, serve para todos os fatores assim como Mensagens, Dados de Produtos, Duplicatas e etc...
    @type  Function
    @author Lucas Baia / Cairê Vieira - UPDUO
    @since 02/06/2021
    @version version 2
    @param 
    @return 
    @example
    (examples)
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=274327446
    /*/

USER FUNCTION PE01NFESEFAZ()
	Local aArea     := GetArea()
	Local aProd     := PARAMIXB[1] //array com dados do Produto (Código produto, descrição de prod, quantidade, lote, unidade de medida....)
	Local cMensCli  := PARAMIXB[2] //mensagem do cliente na nota
	Local cMensFis  := PARAMIXB[3] //mensagem fiscal da nota
	Local aDest     := PARAMIXB[4] //array com dados do destinatario (cnpj, nome, endereço,....)
	Local aNota     := PARAMIXB[5] //array com dados da nota (numero da nota, serie, data emissao ....)
	Local aInfoItem := PARAMIXB[6] //array com as informações dos itens (numero do pedido, numero item pedido....)
	Local aDupl     := PARAMIXB[7] //array com dados das duplicatas (prefixo, numero, parcela, vencimento.....)
	Local aTransp   := PARAMIXB[8] //array com dados do transportador (cnpj, nome, ins. estadual, endereço....)
	Local aEntrega  := PARAMIXB[9] //array com dados da entrega (cnpj, endereco, municipio, bairro, email,.....)
	Local aRetirada := PARAMIXB[10] //array com dados do local de retirada (cnpj, endereço, municipio, bairro, email....)
	Local aVeiculo  := PARAMIXB[11] //array com dados do veiculo transporte (placa, estado, ....)
	Local aReboque  := PARAMIXB[12] //array com dados do segundo veiculo transporte (placa, estado, ....)
	Local aNfVincRur:= PARAMIXB[13] //array com dados da Nota Fiscal de Produtor rural referenciada (nota, serie, emissao da nota, ...)
	Local aEspVol   := PARAMIXB[14] //array com dados do volume da nota (peso liquido, peso bruto,....)
	Local aNfVinc   := PARAMIXB[15] //array com dados do cupom fiscal (numero da nota, serie, emissao, chave da nota,....)
	Local AdetPag   := PARAMIXB[16] //array com detalhes do pagamento (forma pagamento, valor .....)
	Local aObsCont  := PARAMIXB[17] //array com observação do contribuinte
	//Local aProcRef  := PARAMIXB[18] //array com dados da nota
	Local aRetorno  := {}

	fMensCli(aNota[04], @cMensCli, @cMensFis) //aNota[04] = Tipo da Nota, cMensCli = "Local cMensCli  := PARAMIXB[2]"

//O retorno deve ser exatamente nesta ordem e passando o conteúdo completo dos arrays
//pois no rdmake nfesefaz é atribuido o retorno completo para as respectivas variáveis
//Ordem:
//      aRetorno[1] -> aProd
//      aRetorno[2] -> cMensCli
//      aRetorno[3] -> cMensFis
//      aRetorno[4] -> aDest
//      aRetorno[5] -> aNota
//      aRetorno[6] -> aInfoItem
//      aRetorno[7] -> aDupl
//      aRetorno[8] -> aTransp
//      aRetorno[9] -> aEntrega
//      aRetorno[10] -> aRetirada
//      aRetorno[11] -> aVeiculo
//      aRetorno[12] -> aReboque
//      aRetorno[13] -> aNfVincRur
//      aRetorno[14] -> aEspVol
//      aRetorno[15] -> aNfVinc
//      aRetorno[16] -> AdetPag
//      aRetorno[17] -> aObsCont 
//      aRetorno[18] -> aProcRef 

	aadd(aRetorno,aProd)
	aadd(aRetorno,cMensCli)
	aadd(aRetorno,cMensFis)
	aadd(aRetorno,aDest)
	aadd(aRetorno,aNota)
	aadd(aRetorno,aInfoItem)
	aadd(aRetorno,aDupl)
	aadd(aRetorno,aTransp)
	aadd(aRetorno,aEntrega)
	aadd(aRetorno,aRetirada)
	aadd(aRetorno,aVeiculo)
	aadd(aRetorno,aReboque)
	aadd(aRetorno,aNfVincRur)
	aadd(aRetorno,aEspVol)
	aadd(aRetorno,aNfVinc)
	aadd(aRetorno,AdetPag)
	aadd(aRetorno,aObsCont)
	//aadd(aRetorno,aProcRef)

	RestArea(aArea)

RETURN aRetorno

//*****************************************************/

Static Function fMensCli(c_TpNota, cMensCli, cMensFis)

	IF c_TpNota == "1" //Tipo de Nota é igual a 1, ou seja, NF de Saída
		IF SD2->D2_TES == "970"
			cMensFis := ""
			cMensCli := "DOCUMENTO EMITIDO POR ME OU EPP PELO SIMPLES NACIONAL NAO GERA DIREITO A CREDITO FISCAL IPI." +Chr(13)+Chr(10)
			cMensCli += "Mercadoria enviada para fins de industrialização por nossa conta e ordem pela empresa " +Chr(13)+Chr(10)
			cMensCli += "Piter Pan Industria e Comercio Ltda, localizada ana Rua Solon, 1100, IE: 104817670116 " +Chr(13)+Chr(10)
			cMensCli += "CNPJ: 61.497.186/0001-20. " +Chr(13)+Chr(10)
			IF !(EMPTY(SF2->F2_MENNOTA))
				cMensCli += "" +Chr(13)+Chr(10)
				cMensCli += SF2->F2_MENNOTA +Chr(13)+Chr(10)
			ENDIF
			cMensFis := MsgFis()

		ElseIf SD2->D2_TES == "971"
			cMensFis := ""
			cMensCli := "DOCUMENTO EMITIDO POR ME OU EPP OPTANTE PELO SIMPLES NACIONAL " +Chr(13)+Chr(10)
			cMensCli += "NÃO GERA DIREITO A CREDITO FISCAL DE IPI. PERMITE O " +Chr(13)+Chr(10)
			cMensCli += "APROVEITAMENTO DO CRÉDITO DE ICMS NO VALOR DE R$ "+ Transform(SF2->F2_VALBRUT*(3.74/100),'@E 999,999.99') +Chr(13)+Chr(10)
			cMensCli += "CORRESPONDENTE A ALÍQUOTA DE "+ Str(3.74) +"%, " +Chr(13)+Chr(10)
			cMensCli += "NOS TERMOS DO ART. 23 DA LEI COMPLEMENTAR Nº 123, DE 2006." +Chr(13)+Chr(10)
			IF !(EMPTY(SF2->F2_MENNOTA))
				cMensCli += "" +Chr(13)+Chr(10)
				cMensCli += SF2->F2_MENNOTA +Chr(13)+Chr(10)
			ENDIF
			cMensFis := MsgFis()

		ElseIf SD2->D2_TES == "972"
			cMensFis := ""
			cMensCli := "DOCUMENTO EMITIDO POR ME OU EPP OPTANTE PELO SIMPLES NACIONAL " +Chr(13)+Chr(10)
			cMensCli += "NÃO GERA DIREITO A CREDITO FISCAL DE IPI "+Chr(13)+Chr(10)
			IF !(EMPTY(SF2->F2_MENNOTA))
				cMensCli += "" +Chr(13)+Chr(10)
				cMensCli += SF2->F2_MENNOTA +Chr(13)+Chr(10)
			ENDIF
			cMensFis := MsgFis()

		Elseif !(SD2->D2_TES$"970.971.972")
			cMensCli := SF2->F2_MENNOTA
		ENDIF
	ENDIF

Return Nil

//*****************************************************/


Static Function MsgFis()
Local cRet := ""

	_nomeVend  :=  posicione("SA3",1,XFILIAL("SA3")+SF2->F2_VEND1,"A3_NREDUZ")

	If !Empty(_nomeVend)
		cRet := "Vendedor: " + alltrim(_nomeVend) + " - "
	Endif
	cRet += "Telefone da Transportadora: " + SA4->A4_TEL 

Return cRet
