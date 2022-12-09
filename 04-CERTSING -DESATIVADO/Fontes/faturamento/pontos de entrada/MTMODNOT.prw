#Include "Totvs.ch"  

// 05/09/2013 - Renato Ruy
// Ponto de Entrada para retornar o código da especie NFSE, o sistema não trata por padrão.

User Function MTMODNOT()
Local cCodigo := ""

Do Case
	Case Alltrim(paramixb)=="CA"		
		cCodigo:="10" // Conh.Aereo
	Case Alltrim(paramixb)=="NF"		
		cCodigo:="01" // Nota Fiscal
	Case Alltrim(paramixb)=="CTA" 	
		cCodigo:="09" // Conh.Transp.Aquaviario
	Case Alltrim(paramixb)=="CTF" 	
		cCodigo:="11" // Conh.Transp.Ferroviario
	Case Alltrim(paramixb)=="CTR" 	
		cCodigo:="08" // Conh.Transp.Rodoviario
	Case Alltrim(paramixb)=="NFCEE" 
		cCodigo:="06" // Conta de Energia Eletrica
	Case Alltrim(paramixb)=="NFE" 	
		cCodigo:="01" // NF Entrada
	Case Alltrim(paramixb)=="NFPS" 	
		cCodigo:="  " // NF Prestacao de Servico  
	Case Alltrim(paramixb)=="NFS" 	
		cCodigo:="  " // NF Servico 
	Case Alltrim(paramixb)=="NFST" 	
		cCodigo:="07" // NF Servico de Transporte
	Case Alltrim(paramixb)=="NFSC" 	
		cCodigo:="21" // NF Servico de Comunicacao
	Case Alltrim(paramixb)=="NTSC" 	
		cCodigo:="21" // NF Servico de Comunicacao
	Case Alltrim(paramixb)=="NTST" 	
		cCodigo:="22" // NF Servico de Telecomunicacoes
	Case Alltrim(paramixb)=="NFCF" 	
		cCodigo:="02" // NF de venda a Consumidor Final
	Case Alltrim(paramixb)=="NFP" 	
		cCodigo:="04" // NF de Produtor
	Case Alltrim(paramixb)=="RMD" 	
		cCodigo:="18" // Resumo Movimento Diario		
	Case Alltrim(paramixb)=="CTM" 	
		cCodigo:="26" // Conh.Transp.Multimodal
	Case Alltrim(paramixb)=="CF" .OR. Alltrim(paramixb)=="ECF"
		cCodigo:="02" // Cupon Fiscal gerado pelo SIGALOJA
	Case Alltrim(paramixb)=="RPS" 
		cCodigo:="  " // Recibo Provisorio de Servicos - Nota Fiscal Eletronica de Sao Paulo 			
	Case Alltrim(paramixb)=="SPED" 	
		cCodigo:="55" // Nota fiscal eletronica do SEFAZ.
	Case Alltrim(paramixb)=="NFFA" 	
		cCodigo:="29" // Nota fiscal de fornecimento de agua
	Case Alltrim(paramixb)=="NFCFG"
		cCodigo:="28" // Nota fiscal/conta de fornecimento de gas
	Case Alltrim(paramixb)=="CTE"
		cCodigo:="57" // Conhecimento de Transporte Eletronico
    Case Alltrim(paramixb)=="NFA"
		cCodigo:="1B" // Nota Fiscal Avulsa	
    Case Alltrim(paramixb)=="NFSE" 
		cCodigo:="56"
    Case Alltrim(paramixb)=="DOCFI" 
		cCodigo:="56"
EndCase

Return(cCodigo)