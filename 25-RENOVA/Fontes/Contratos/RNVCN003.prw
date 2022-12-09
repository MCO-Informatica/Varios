#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "Tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRNVCN003  บAutor  ณ B2finance          บ Data ณ  02/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Le o arquivo .csv apontado pelo usuario, contendo a medicaoบฑฑ
ฑฑบ          ณ do pedido de venda e efetua a medicao e o encerramento da  บฑฑ
ฑฑบ          ณ medicao atravez de rotina automatica.                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RNVCN003()
Local _cFiles := ""

Private _cDir		:= ""
Private _cDirErro	:= ""
Private _cDirProce	:= ""
Private _cDirLogs	:= ""
Private _cObsPA		:= ""  // Variavel customizada usada no Pedido de Compras
Private _cArquivo	:= ""
Private _cCam		:= Space(100)

Private _cEmprOrig	:= cEmpAnt		// Empresa e filial original, a serem restaurada, apos o tratamento. Pois o arquivo CSV tem contrato de multiplas empresas
Private _cFiliOrig	:= cFilAnt		// Empresa e filial original, a serem restaurada, apos o tratamento. Pois o arquivo CSV tem contrato de multiplas empresas
Private _lMudouEmp	:= .F.			// Boleano indicando que houve mudan็a de empresa. Inicia como .F.

Private _cEmpresa	:= cEmpAnt					// Variavel com empresa      original (salva) antes de utilizar o prepare environment para ser restaurada ao final do processamento
Private _cFilial	:= cFilAnt					// Variavel com Filial       original (salva) antes de utilizar o prepare environment para ser restaurada ao final do processamento
Private _cUsriORI	:= Substr(cUsuario,7,15)	// Variavel com Usuario      original (salva) antes de utilizar o prepare environment para ser restaurada a cada prepare environmet, e ao final do processamento
Private _cUsrIdORI	:= __cUserId				// Variavel com Usuario      original (salva) antes de utilizar o prepare environment para ser restaurada a cada prepare environmet, e ao final do processamento
Private _cUsrNmORI	:= cUserName				// Variavel com Nome Usuario original (salva) antes de utilizar o prepare environment para ser restaurada a cada prepare environmet, e ao final do processamento

If !ExisteSX6("MV_XPASTA")
	CriarSX6("MV_XPASTA","C","Caminho do local a onde o Protheus ira buscar os Arquivos CSV para a importa็ใo de Medi็ใo","\wbc\")
	CriarSX6("MV_XPASTAE","C","Caminho do local a onde o Protheus ira alimentar os Erros de Processamento da importa็ใo de Medi็ใo","\wbc\Erro\")
	CriarSX6("MV_XPASTAP","C","Caminho do local a onde o Protheus ira alimentar os arquivos Processados com Sucesso da importa็ใo de Medi็ใo","\wbc\Processado\")
	CriarSX6("MV_XPASTAL","C","Caminho do local a onde o Protheus ira alimentar os logs de processamento da importa็ใo de Medi็ใo","\wbc\Logs\")
Endif
_cDir		:= SuperGetMV("MV_XPASTA", .F., "\wbc\")
_cDirErro	:= SuperGetMV("MV_XPASTAE",.F., "\wbc\Erro\")
_cDirProce	:= SuperGetMV("MV_XPASTAP",.F., "\wbc\Processado\")
_cDirLogs	:= SuperGetMV("MV_XPASTAL",.F., "\wbc\Logs\")
makedir(_cDir)
makedir(_cDirErro)
makedir(_cDirProce)
makedir(_cDirLogs)

_aFiles := DIRECTORY( _cDir + "*.CSV"  )
// Directry.ch		// 1 cNome F_NAME,   2 cTamanho F_SIZE,   3 dData F_DATE,   4 cHora F_TIME,   5 cAtributos F_ATT

For _nI := 1 to len(_aFiles )
	_cFiles += _aFiles[_nI,1] + ",   "
Next
_cFiles := subs(_cFiles,1, len(_cFiles)-3)

If Len(_aFiles) > 0
	If MsgYesNo("Deseja importar as medic๕es contidas nos arquivos .CSV : " + _cFiles + " ?" )
		Processa( {|| U_RNVCN3PR() }, "Aguarde...", "Importando as medic๕es contidas nos arquivos .CSV..",.F.)
	Else
		MsgStop( "Abandonando a rotina de importa็ใo de medi็๕es" )
	Endif
Else
	MsgStop( "Nใo existe arquivo do tipo *.CSV para ser importado na pasta " + _cDir )
Endif

If _lMudouEmp			// Boleano indicando que houve mudan็a de empresa. Inicia como .F.
	cEmpAnt	:= _cEmprOrig		// Restauro a empresa e filial original, apos o processamento
	cFilAnt	:= _cFiliOrig		// Restauro a empresa e filial original, apos o processamento
	
	_cEmpresa	:= cEmpAnt	:=	SM0->M0_CODIGO
	_cFilial	:= cFilAnt	:=	SM0->M0_CODFIL
	_lMudouEmp	:= .T.
	RPCSetType(3)
	PREPARE ENVIRONMENT EMPRESA cEmpAnt FILIAL cFilAnt MODULO "GCT" FUNNAME "RNVCN002"  	//TABLES 'ACS', 'ADA', 'ADB', 'AGG', 'AGS', 'AID', 'CE2', 'CN1', 'CN9', 'CNA', 'CNB', 'CND', 'CNE', 'CNF', 'CNL', 'CNN', 'CNQ', 'CNR', 'CNS', 'CNT', 'CNV', 'CTD', 'CTH', 'CTT', 'DA0', 'DA1', 'DC5', 'DGC', 'DV9', 'FIE', 'QEK', 'SA1', 'SA2', 'SA3', 'SA7', 'SB1', 'SB2', 'SB4', 'SB6', 'SB8', 'SC0', 'SC1', 'SC5', 'SC6', 'SC7', 'SC9', 'SCV', 'SD1', 'SD2', 'SD4', 'SDC', 'SE1', 'SE2', 'SE4', 'SF1', 'SF2', 'SF3', 'SF4', 'SFB', 'SFC', 'SG1', 'SGA', 'SGO', 'SL1', 'SL2', 'SL4', 'TEW'
	cUsuario	:= _cUsriORI		// Restauro o usuario      original
	__cUserId	:= _cUsrIdORI		// Restauro o usuario      original
	cUserName	:= _cUsrNmORI		// Restauro o nome usuario original
	
Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRNVCN3PR  บAutor  ณGeronimo B. Alves   บ Data ณ  14/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RNVCN3PR()
Private cxArq	:= ""
ProcRegua( Len(_aFiles) )

For _nI := 1 to len(_aFiles)
	IncProc("Processando o arquivo "+_aFiles[_nI,1]  )
	alert(_aFiles[_nI,1])
	_cArquivo	:= _aFiles[_nI,1]
	_cCam		:= _cDir + _cArquivo
	RNVCN01A()
Next
Aviso("Aten็ใo","Foram Processados "+cvaltochar(len(_aFiles))+" e para cada Arquivo teve o seu status!"+CRLF+cxArq,{"OK"})
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RNVCN01A  บAutor  ณ B2finance          บ Data ณ  02/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo auxiliar para importacao do .CSV                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RNVCN01A()

Local  nLinhTipo9	:= 1

Private nLinha		:= 0
Private aCab			:= {}
Private aItens		:= {}
Private cComp1		:= ""
Private cPlanilha		:= ""
Private cLog			:= ""

//Aadd(aDetExcel, {cNomeCom, cEmpFil,CnpjExcel(cCgcCliFor), cContrato, cNumMed , cNumPed, "EXECAUTO", cLog})
Private cNumPed		:= ""
Private aLog			:= {}
Private aDetExcel		:= {}

Private cNumMed		:= ""
Private cNumPed		:= ""

Private cNomeCom	:= SM0->M0_NOMECOM
Private cEmpFil		:= SM0->M0_CODFIL
Private dVcto1		:= CTOD("//")
Private dVcto2		:= CTOD("//")
Private dVcto3		:= CTOD("//")
Private dDtFimCTr   := CTOD("//")
Private cContrato	:= ""
Private nParc1		:= 0
Private nParc2		:= 0
Private nParc3		:= 0
Private nDescCt		:= 0
Private aLinha		:= {}
Private aLinhaCHK	:= {}
Private lMsErroAuto	:= .F.
Private cCgcCliFor	:= ""
Private nQtdMedArq	:= 0		// Quantidade de registros tipo "1-Medicao" existente no arquivo
Private nRegPla		:= 0		// Quantidade de registros Itens de medi็ใo, existe na tabela CNB para o numero de contrato do arquivo.

Private nQtdMd1		:= 0		// Qtd Medida 		na 1ช ocorrencia do registro do tipo "1-Medicao"
Private nPrcMd1		:= 0		// Pre็o unitario	na 1ช ocorrencia do registro do tipo "1-Medicao"
Private nTotMd1		:= 0		// Pre็o total		na 1ช ocorrencia do registro do tipo "1-Medicao"
Private nDesMd1		:= 0		// Desconto			na 1ช ocorrencia do registro do tipo "1-Medicao"

Private nQtdMd2		:= 0		// Qtd Medida 		na 1ช ocorrencia do registro do tipo "1-Medicao"
Private nPrcMd2		:= 0		// Pre็o unitario	na 2ช ocorrencia do registro do tipo "1-Medicao"
Private nTotMd2		:= 0		// Pre็o total		na 2ช ocorrencia do registro do tipo "1-Medicao"
Private nDesMd2		:= 0		// Desconto. Nใo deve existir na 2ช ocorrencia do registro do tipo "1-Medicao"
Private QtdParc		:= 0
Private cQryC5		:= ""
Private _lErroArqu  := .F.
Private lMove		:= .F.
Private xQtdParc	:= ""
IncProc("Lendo arquivos CSV...")
U_miGerLog(,, .T.)
//_cCam := "C:\BKP\G\FONTES TOTVS\CLI FONTES G\RENOVA\ERP422-082015.CSV"											// Geronimo.  Para testes
//_cCam := "C:\RNV_teste\ABSOL201500032.CSV"													// Geronimo.  Para testes em 13/10/2015
//_cCam := "C:\RNV_teste\2_x_2_ABSOL201500032.CSV"											// Geronimo.  Para testes em 13/10/2015

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//Valida que a extens?o ? igual a CSV.//
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
If !".CSV" $ UPPER(_cCam)
	MsgStop("A extensใo do arquivo deve ser CSV!")
	Return Nil
EndIf

FT_FUse(_cCam)
FT_FGoTop()
//ProcRegua(FT_FLastRec())
FT_FGoTop()
While (!FT_FEof())
	nLinha++
	
	// A condicao abaixo e para ser ativa somente se a primeira linha do arquivo vir com cabecalho
	//If nLinha == 1
	//	FT_FSkip()
	//	Loop
	//EndIf
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
	//Chamada de fun??o que converte texto em array.//
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
	aLinha := U_TXTTARR(FT_FReadLn(), ";")
	If Empty(aLinha)
		cLog := "Nใo foi possivel ler as informa็๕es do arquivo CSV "+ _cCam + " para efetuar o processamento. Verifique o conteudo e o caracter separador que deve ser ponto e virgula."
		MsgStop( cLog )
		_lErroArqu  := .T.		// Encontrado erro de processamento no arquivo
		U_miGerLog(, cLog )
		Aadd(aDetExcel, {cNomeCom, cEmpFil,CnpjExcel(cCgcCliFor), cContrato, cNumMed , cNumPed, "Rotina Automatica", cLog, "Erro na rotina Automatica"})
		
		Exit
	Endif
	
	aItens := {}
	aCab   := {}
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
	//Coleta dados na planilha para obter vencimento e competencia.         //
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
	//Coleta contrato na planilha, posi??o 10 do array.   //
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
	If aLinha[1] == "1"
		
		nQtdMedArq++		// Incremento o contador de ocorrencias de leitura de registro do tipo "1-Medicao"
		
		If nQtdMedArq == 1			// Em cada arquivo pode existir mais um ou dois registros do Tipo "1-Medicao" .  Estou lendo a 1ช medicใo
			nLinhTipo9 := 1
			
			_CNPJRENOV	:= aLinha[2]
			cVendaComp	:= If(aLinha[9] == "V" , "V" , If(aLinha[9] == "C" , "C" , " " ) )
			cContrato 	:= aLinha[10]
			cCgcCliFor 	:= aLinha[19]
			
			ChkEmprFil(_CNPJRENOV)			// Prepara o ambiente da empresa indicada no campo cgc do arquivo CSV
			PosicioCN9( cContrato )
			
			cComp1 		:= aLinha[13]						// 13-Competencia da medicao
			
			nQtdMd1  	:= StrTran(aLinha[3], ".", "")		// 3-Quantidade (MWh)
			nQtdMd1  	:= StrTran(nQtdMd1 , ",", ".")
			nQtdMd1  	:= Val(nQtdMd1)
			
			nPrcMd1  	:= StrTran(aLinha[4], ".", "")		// 4-Pre็o (R$/MWh)
			nPrcMd1  	:= StrTran(nPrcMd1 , ",", ".")
			nPrcMd1  	:= Val(nPrcMd1)
			
			nTotMd1  	:= StrTran(aLinha[5], ".", "")		// 5-Valor Total (R$)
			nTotMd1  	:= StrTran(nTotMd1 , ",", ".")
			nTotMd1  	:= Val(nTotMd1)
			
			nDesMd1  	:= StrTran(aLinha[7], ".", "")		// 7-Desconto/Ressarcimento (R$))
			nDesMd1  	:= StrTran(nDesMd1 , ",", ".")
			nDesMd1  	:= Val(nDesMd1)
			
		ElseIf nQtdMedArq == 2		// Estou lendo a 2ช ocorrencia do registro do tipo "1-Medicao" .  Obs.  Na 2ช ocorrencia nao o campo "7-Desconto/Ressarcimento (R$)" esta sempre zerado
			
			nQtdMd2  	:= StrTran(aLinha[3], ".", "")		// 3-Quantidade (MWh)
			nQtdMd2  	:= StrTran(nQtdMd2 , ",", ".")
			nQtdMd2  	:= Val(nQtdMd2)
			
			nPrcMd2  	:= StrTran(aLinha[4], ".", "")		// 4-Pre็o (R$/MWh)
			nPrcMd2  	:= StrTran(nPrcMd2 , ",", ".")
			nPrcMd2  	:= Val(nPrcMd2)
			
			nTotMd2  	:= StrTran(aLinha[5], ".", "")		// 5-Valor Total (R$)
			nTotMd2  	:= StrTran(nTotMd2 , ",", ".")
			nTotMd2  	:= Val(nTotMd2)
			
			nDesMd2  	:= 0								// 7-Desconto/Ressarcimento (R$))   (Na linha 2, nunca tem desconto).
			
		Endif
		
	EndIf
	
	If aLinha[1] == "2"
		If nLinhTipo9 == 1
			dVcto1   := CTOD(aLinha[16])
			
			nParc1  	:= StrTran(aLinha[17], ".", "")
			nParc1  	:= StrTran(nParc1 , ",", ".")
			nParc1  	:= Val(nParc1)
			QtdParc		+= 1
		ElseIf nLinhTipo9 == 2
			dVcto2   := CTOD(aLinha[16])
			
			nParc2  	:= StrTran(aLinha[17], ".", "")
			nParc2  	:= StrTran(nParc2 , ",", ".")
			nParc2  	:= Val(nParc2)
			QtdParc		+= 1
		ElseiF  nLinhTipo9 == 3
			dVcto3   := CTOD(aLinha[16])
			
			nParc3  	:= StrTran(aLinha[17], ".", "")
			nParc3  	:= StrTran(nParc3 , ",", ".")
			nParc3  	:= Val(nParc3)
			QtdParc		+= 1
		EndIf
		
		nLinhTipo9 += 1
		FT_FSkip()
		
		aLinhaCHK := U_TXTTARR(FT_FReadLn(), ";")		// Faco uma leitura previa da linha, para ver se trocou de contrato.
		If FT_FEof() .or. ( aLinhaCHK[2] == "1"  .and. cContrato <> aLinhaCHK[10] )
			FazMedicao()
		Else
			Loop
		EndIf
	EndIf
	
	FT_FSkip()
	
End

FT_FUSE(_cCam)		// Fecho o arquivo texto

If _lErroArqu .and. lMove
	cxArq += _cCam+" Erro de Processamento."+CRLF
	fRename( _cCam , _cCam + "_Erro" )									// Se processou com erros, renomeio para demonstrar erro e nใo ser processado novamente
	lCopia := U_FileMove( _cCam + "_Erro"  , _cDirErro+_cArquivo+"_Erro"  ,.T.) 			// Quando o terceiro paramentro eh .T. , move o arquivo, se estiver .F. copia
	If lCopia
		fErase(_cCam + "_Erro" )
	Endif
	
ElseIF lMove
	cxArq += _cCam+" Sucesso de Processamento."+CRLF
	fRename( _cCam , _cCam + "_Processado" )							// Se processou sem erros, renomeio arquivo para nใo ser processado novamente
	lCopia := U_FileMove( _cCam + "_Processado"  , _cDirProce +_cArquivo+"_Processado" ,.T.) // Quando o terceiro paramentro eh .T. , move o arquivo, se estiver .F. copia
	If lCopia
		fErase(_cCam + "_Processado" )
	Endif
Endif

U_miGerLog(,,, .T.)

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//Gera LOG dos registros em excel. //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

// Empresa / N?mero / Contrato / CNPJ / Cod. ONS / Sigla ONS / Medi??o / Pedido Numero / Titulo / Valor Medido / STATUS

DlgToExcel({{"ARRAY", "LOG_DE_IMPORTAวรO_DO_ARQUIVO: ==>> "+Upper(_cCam), {"EMPRESA","Empresa Filial","CNPJ", "CONTRATO", "MEDIวรO","PEDIDO NUMERO","ORIGEM", "DESCRIวรO", "OCORRENCIA" }, aDetExcel}})

Return .T.




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkEmprFilบAutor  ณGeronimo B. Alves   บ Data ณ  14/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkEmprFil(_CNPJRENOV)
Local nAtuSM0

DbSelectArea("SM0")
nAtuSM0 := SM0->( Recno() )
DbGotop()
While !Eof()
	If AllTrim(SM0->M0_CGC) == Alltrim(_CNPJRENOV)
		If ! (_cEmpresa == SM0->M0_CODIGO .and. _cFilial == SM0->M0_CODFIL )
			_cEmpresa	:= cEmpAnt	:=	SM0->M0_CODIGO
			_cFilial	:= cFilAnt	:=	SM0->M0_CODFIL
			_lMudouEmp	:= .T.
			RPCSetType(3)
			PREPARE ENVIRONMENT EMPRESA _cEmpresa FILIAL _cFilial MODULO "GCT" FUNNAME "RNVCN002" 		//TABLES 'ACS', 'ADA', 'ADB', 'AGG', 'AGS', 'AID', 'CE2', 'CN1', 'CN9', 'CNA', 'CNB', 'CND', 'CNE', 'CNF', 'CNL', 'CNN', 'CNQ', 'CNR', 'CNS', 'CNT', 'CNV', 'CTD', 'CTH', 'CTT', 'DA0', 'DA1', 'DC5', 'DGC', 'DV9', 'FIE', 'QEK', 'SA1', 'SA2', 'SA3', 'SA7', 'SB1', 'SB2', 'SB4', 'SB6', 'SB8', 'SC0', 'SC1', 'SC5', 'SC6', 'SC7', 'SC9', 'SCV', 'SD1', 'SD2', 'SD4', 'SDC', 'SE1', 'SE2', 'SE4', 'SF1', 'SF2', 'SF3', 'SF4', 'SFB', 'SFC', 'SG1', 'SGA', 'SGO', 'SL1', 'SL2', 'SL4', 'TEW'
			cUsuario	:= _cUsriORI		// Restauro o usuario      original
			__cUserId	:= _cUsrIdORI		// Restauro o usuario      original
			cUserName	:= _cUsrNmORI		// Restauro o nome usuario original
			
			Exit
			
		Endif
	Endif
	
	dbSkip()
Enddo

If !_lMudouEmp					// Se nใo mudou de empresa/Filial
	SM0->(dbGoTo(nAtuSM0))		// Reposiciono no registro atual do SM0
Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFazMedicaoบAutor  ณGeronimo Bened Alvesบ Data ณ  114/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ A cada troca de numero de contrato no arquivo .CSV, ou ao  บฑฑ
ฑฑบ          ณ final da leitura do .CSV, esta funcao eh chamada p/ incluirบฑฑ
ฑฑบ          ณ e depois encerrar as medicoes                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FazMedicao()

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//Verifica se as vari?veis foram preenchidas para iniciar processamento.//
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
If !Empty(cContrato) .AND. (!Empty(dVcto1) .OR. !Empty(dVcto2) .OR. !Empty(dVcto3))
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
	//Verifica se o contrato existe na tabela de contratos (CN9).  //
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
	cQryCont := " SELECT MAX(CN9_REVISA) REVISAO, CN9_CONDPG, CN9_NUMERO, CN9_TPCTO, CN9_DTFIM "+CRLF
	cQryCont += " FROM "+RetSqlName("CN9")+" CN9"+CRLF
	cQryCont += " WHERE CN9_NUMERO = '"+cContrato+"'"+CRLF
	cQryCont += " AND CN9.D_E_L_E_T_ = ' ' "+CRLF
	cQryCont += " AND CN9.CN9_FILIAL = '" + xFilial("CN9") + "' "+CRLF
	cQryCont += " GROUP BY CN9_CONDPG, CN9_NUMERO, CN9_TPCTO, CN9_DTFIM  "+CRLF
	
	U_miGerLog(, cQryCont)
	
	If Select("QRYCON")<>0
		DbSelectArea("QRYCON")
		DbCloseArea()
	EndIf
	
	TcQuery cQryCont New Alias "QRYCON"
	
	QRYCON->(DbGoTop())
	If QRYCON->(!Eof())
		_cRevisa := QRYCON->REVISAO
		cCondPg  := QRYCON->CN9_CONDPG
		cContrato:= QRYCON->CN9_NUMERO
		dDtFimCTr := STOD(QRYCON->CN9_DTFIM)
		//%%%%%%%%%%%%%%%%%%%%%%%%%%//
		//Retira a mascara do cnpj. //
		//%%%%%%%%%%%%%%%%%%%%%%%%%%//
		cCgcCliFor  := StrTran(cCgcCliFor, ".", "")
		cCgcCliFor  := StrTran(cCgcCliFor, "/", "")
		cCgcCliFor  := StrTran(cCgcCliFor, "-", "")
		
		//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
		//Pesquisa Cliente ou fornecedro pelo cnpj no cadastro de clientes-SA1 ou de fornecedores SA2                           //
		//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
		If LocSA1_SA2(cCgcCliFor)
			
			//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
			//Pesquisa cod e loja de cliente no cabecalho da planilha do contrato CNA.//
			//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
			
			cQryPla := " SELECT *"+CRLF
			cQryPla += " FROM "+RetSqlName("CNA")+" CNA"+CRLF
			cQryPla += " INNER JOIN "+RetSqlName("CNB")+" CNB"+CRLF
			cQryPla += " ON CNA_NUMERO = CNB_NUMERO AND CNA_REVISA = CNB_REVISA "+CRLF
			cQryPla += " AND CNA_CONTRA = CNB_CONTRA"+CRLF
			cQryPla += " AND CNB.D_E_L_E_T_ = ' '"+CRLF
			cQryPla += " AND CNB.CNB_FILIAL = '" + xFilial("CNB") + "' "+CRLF
			cQryPla += " AND CNB.CNB_SLDMED > 0 " + CRLF 								// gERONIMO 21/10/15
			cQryPla += " WHERE CNA_CONTRA = '"+cContrato+"'"+CRLF
			cQryPla += " AND CNA_REVISA = '"+_cRevisa+"'"+CRLF
			If cVendaComp == "V"
				cQryPla += " AND CNA_CLIENT = '"+ CN9->CN9_CLIENT+"'"+CRLF
				cQryPla += " AND CNA_LOJACL = '"+ CN9->CN9_LOJACL+"'"+CRLF
				
			Else				//If cVendaComp == "C"
				cQryPla += " AND CNA_CLIENT = '"+CN9->CN9_CLIENT+"'"+CRLF
				cQryPla += " AND CNA_LOJACL = '"+CN9->CN9_LOJACL+"'"+CRLF
				
			Endif
			cQryPla += " AND CNA.D_E_L_E_T_ = ' '"+CRLF
			cQryPla += " AND CNA.CNA_FILIAL = '" + xFilial("CNA") + "' "+CRLF
			cQryPla += " ORDER BY CNB_NUMERO, CNB_ITEM "+CRLF
			
			U_miGerLog(, cQryPla)
			
			If Select("QRYPLA")<>0
				DbSelectArea("QRYPLA")
				DbCloseArea()
			EndIf
			
			TcQuery cQryPla New Alias "QRYPLA"
			
			Count To nRegPla
			
			//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
			//Se encontra planilha inicia processamento.//
			//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
			QRYPLA->(DbGoTop())
			If QRYPLA->(!Eof())
				cPlanilha := QRYPLA->CNA_NUMERO
				cTpPlanil := QRYPLA->CNA_TIPPLA
				While QRYPLA->(!Eof())
					aCab   := {}
					aItens := {}
					aCabEnc:= {}
					
					//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
					//Verifica se existe competencia no cronograma e inicia carregamento dos//
					//para execu??o da fun??o MSExecAuto da rotina CNTA120.                 //
					//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
					cQryCro := " SELECT *"+CRLF
					cQryCro += " FROM "+RetSqlName("CNF")+" CNF"+CRLF
					cQryCro += " WHERE CNF.D_E_L_E_T_ = ' '"+CRLF
					cQryCro += " AND CNF.CNF_FILIAL = '" + xFilial("CNF") + "' "+CRLF
					cQryCro += " AND CNF_CONTRA = '"+cContrato+"'"+CRLF
					cQryCro += " AND CNF_REVISA = '"+_cRevisa+"'"+CRLF
					cQryCro += " AND CNF_COMPET = '"+cComp1+"'"+CRLF
					cQryCro += " AND CNF_SALDO > 0  "+CRLF
					
					U_miGerLog(, cQryCro)
					
					If Select("QRYCRO")<>0
						DbSelectArea("QRYCRO")
						DbCloseArea()
					EndIf
					
					TcQuery cQryCro New Alias "QRYCRO"
					
					QRYCRO->(DbGoTop())
					If QRYCRO->(!Eof())
						cNumMed := CriaVar("CND_NUMMED")
						cNumPed := CriaVar("CND_PEDIDO")
						aAdd(aCab, {"CND_FILIAL", xFilial("CND")                , NIL})
						aAdd(aCab, {"CND_NUMMED", cNumMed                       , NIL})
						aAdd(aCab, {"CND_CONTRA", cContrato                     , NIL})
						aAdd(aCab, {"CND_REVISA", _cRevisa                      , NIL})
						If cVendaComp == "V"
							aAdd(aCab, {"CND_CLIENT", SA1->A1_COD                   , NIL})
							aAdd(aCab, {"CND_LOJACL", SA1->A1_LOJA                  , NIL})
						Else
							aAdd(aCab, {"CND_FORNEC", SA2->A2_COD                   , NIL})
							aAdd(aCab, {"CND_LJFORN", SA2->A2_LOJA                  , NIL})
						Endif
						aAdd(aCab, {"CND_MOEDA" , "1"                           , NIL})
						aAdd(aCab, {"CND_XDTVEN", dVcto1                        , NIL})
						aAdd(aCab, {"CND_ZERO"  , "2"                           , NIL})
						aAdd(aCab, {"CND_COMPET", cComp1                        , NIL})
						aAdd(aCab, {"CND_CONDPG", cCondPg                       , NIL})
						aAdd(aCab, {"CND_NUMERO", cPlanilha                     , NIL})
						aAdd(aCab, {"CND_TIPPLA", cTpPlanil                     , NIL})
						//aAdd(aCab, {"CND_PARCEL", strzero(QtdParc,3)  			, NIL})
						//aAdd(aCab, {"CND_PARCEL", QRYCRO ->CNF_PARCEL  			, NIL})
						aAdd(aCab, {"CND_PARCEL", strzero(QtdParc,3)  			, NIL})
						aAdd(aCab, {"CND_XPA", "2"                              , NIL})
						aAdd(aCab, {"CND_XPMS", "2"                             , NIL})
						aAdd(aCab, {"CND_XCTRAN", ""	                       , NIL})
						aAdd(aCab, {"CND_XDTRAN", ""	                       , NIL})
						aAdd(aCab, {"CND_PEDIDO", cNumPed                       , NIL})
						//aAdd(aCab, {"CND_DESCME", nDesMd1+nDesMd2                , NIL})
						aAdd(aCab, {"CND_PARC1 " , nParc1 +(nDesMd1+nDesMd2)     , NIL})
						aAdd(aCab, {"CND_DATA1 " , dVcto1                        , NIL})
						aAdd(aCab, {"CND_PARC2 " , nParc2                        , NIL})
						aAdd(aCab, {"CND_DATA2 " , dVcto2                        , NIL})
						aAdd(aCab, {"CND_PARC3 " , nParc3                        , NIL})
						aAdd(aCab, {"CND_DATA3 " , dVcto3                        , NIL})
						xQtdParc := QRYCRO ->CNF_PARCEL
						
						QRYPLA->(DbGoTop())
						_nItemPlan	:= 0
						nVxt		:= 0
						While QRYPLA->(!Eof()) //.and. _nItemPlan == 0
							
							_nItemPlan++
							
							nQtdMd_CSV	:= ROUND( If( _nItemPlan == 1 , nQtdMd1 , nQtdMd2 ) ,8)		// Qtd Medida 		a ser validado saldo/gravado
							nPrcMd_CSV	:= ROUND( If( _nItemPlan == 1 , nPrcMd1 , nPrcMd2 ) ,8)		// Pre็o unitario	a ser validado saldo/gravado
							nTotMd_CSV	:= ROUND( If( _nItemPlan == 1 , nTotMd1 , nTotMd2 ) ,8)		// Pre็o total		a ser validado saldo/gravado
							
							//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
							//Verifica se existe saldo a ser medido no item da planilha. Caso n?o      //
							// tenha informa zero para execu??o da fun??o MSExecAuto da rotina CNTA120.//
							//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
							DbSelectArea("CNB")
							CNB->(DbSetOrder(1))//CNB_FILIAL+CNB_CONTRA+CNB_REVISA+CNB_NUMERO+CNB_ITEM
							If CNB->(DbSeek(xFilial("CNB")+QRYPLA->CNB_CONTRA+QRYPLA->CNB_REVISA+QRYPLA->CNB_NUMERO+QRYPLA->CNB_ITEM))
								If nPrcMd_CSV <> CNB->CNB_VLUNIT
									
									_lErroArqu	:= .T.		// Encontrado erro de processamento no arquivo
									U_miGerLog(, "Diferen็a de pre็o unitario. No CSV, na linha de medicao, sequencia " + AllTrim(Str(_nItemPlan)) + " o valor e' : " + AllTrim(str(nPrcMd_CSV ,12,2)) + " e na Planilha o valor e' " +  AllTrim(str(CNB->CNB_VLUNIT, 12,2)) + " item : " + xFilial("CNB") + "-" +QRYPLA->CNB_CONTRA + "-" +QRYPLA->CNB_REVISA + "-" +QRYPLA->CNB_NUMERO + "-" +QRYPLA->CNB_ITEM  )
									Exit		// Saio do loop de geracao do array para o execAuto, pois o execAuto nao serแ executado
								Endif
							Else
								
								_lErroArqu	:= .T.		// Encontrado erro de processamento no arquivo
								U_miGerLog(, "Erro -> Encontrado o item de planilha : " + xFilial("CNB") + "-" +QRYPLA->CNB_CONTRA + "-" +QRYPLA->CNB_REVISA + "-" +QRYPLA->CNB_NUMERO + "-" +QRYPLA->CNB_ITEM   )
								Exit		// Saio do loop de geracao do array para o execAuto, pois o execAuto nao serแ executado
							EndIf
							
							nQtdMd_CSV += 0.0000001 
							
							aAdd(aItens,{})
							aAdd(aItens[Len(aItens)], {"CNE_FILIAL", xFilial("CNE")				, NIL})
							aAdd(aItens[Len(aItens)], {"CNE_ITEM"  , CNB->CNB_ITEM				, NIL})
							aAdd(aItens[Len(aItens)], {"CNE_PRODUT", CNB->CNB_PRODUT			, NIL})
							aAdd(aItens[Len(aItens)], {"CNE_QUANT" , nQtdMd_CSV					, NIL})
							aAdd(aItens[Len(aItens)], {"CNE_VLUNIT", nPrcMd_CSV					, NIL})
							nVxt	+= round((nQtdMd_CSV * nPrcMd_CSV) ,7)
							aAdd(aItens[Len(aItens)], {"CNE_VLTOT" , round((nQtdMd_CSV * nPrcMd_CSV) ,7)		, NIL})
							aAdd(aItens[Len(aItens)], {"CNE_CONTRA", cContrato					, NIL})
							aAdd(aItens[Len(aItens)], {"CNE_DTENT" , dVcto1						, NIL})
							aAdd(aItens[Len(aItens)], {"CNE_REVISA", _cRevisa					, NIL})
							aAdd(aItens[Len(aItens)], {"CNE_NUMERO", cPlanilha					, NIL})
							aAdd(aItens[Len(aItens)], {"CNE_NUMMED", cNumMed					, NIL})
							aAdd(aItens[Len(aItens)], {"CNE_PEDIDO", cNumPed					, NIL})
							QRYPLA->(DbSkip())
						End
						aAdd(aCab, {"CND_VLTOT " , nVxt            , NIL})
						
						if dVcto1 < dDatabase .or. dVcto1 > dDtFimCTr
							_lErroArqu	:= .T.		// Encontrado erro de processamento no arquivo  
					   		cLog := " A data de medi็ใo ("+DTOC(dVcto1)+") ้ superior da data de vencimento do contrato ("+DTOC(dDtFimCTr)+")"
					 		U_miGerLog(, cLog )
					  		Aadd(aDetExcel, {cNomeCom, cEmpFil, CnpjExcel(cCgcCliFor), cContrato, cNumMed , cNumPed, "CRONOGRAMA (CNF)", cLog, "Data de medi็ใo invแlida"  })
						endif
						
						if len(aItens)< iif(nQtdMd2>0,2,1)
							_lErroArqu	:= .T.		// Encontrado erro de processamento no arquivo
							U_miGerLog(, "Erro -> Encontrado no item do Contrato : " + cEmpFil+ "-" +cContrato +" O Contrato Possui somente um Item e a planilha informada possui 2 itens"  )
						endif
						
						
						//%%%%%%%%%%%%%%%%%%%%%%%%//
						//Chamada para o execauto.//
						//%%%%%%%%%%%%%%%%%%%%%%%%//
						If ! _lErroArqu
							aLog := GeraExcAu(aItens, aCab,nDesMd1+nDesMd2, cContrato,(nTotMd1+nTotMd2),xQtdParc)
							cNumPed := CND->CND_PEDIDO
							
							If aLog[1]
								_lErroArqu  := .T.		// Encontrado erro de processamento no arquivo
								cLog := aLog[2]
								U_miGerLog(, "Encontrado erro de processamento no arquivo, na rotina automatica " )
								U_miGerLog(, cLog )
								Aadd(aDetExcel, {cNomeCom, cEmpFil,CnpjExcel(cCgcCliFor), cContrato, cNumMed , cNumPed, "Rotina Automatica", cLog, "Erro na rotina Automatica"})
								
							Else
								cLog := "Importa็ใo realizada com sucesso."
								U_miGerLog(, cLog )
								Aadd(aDetExcel, {cNomeCom, cEmpFil,CnpjExcel(cCgcCliFor), cContrato, cNumMed , cNumPed, "Rotina Automatica", cLog, "OK-importacao"})
								cNumMed := ""
							EndIf
							
						EndIf
					Else
						_lErroArqu  := .T.		// Encontrado erro de processamento no arquivo
						cLog := "Compet๊ncia "+cComp1+" nใo localizada no cronograma do contrato. Possivel saldo zero no cronograma. Contrato Nro.: "+cContrato+" CNPJ: "+cCgcCliFor+"."
						U_miGerLog(, cLog )
						Aadd(aDetExcel, {cNomeCom, cEmpFil, CnpjExcel(cCgcCliFor), cContrato, cNumMed , cNumPed, "CRONOGRAMA (CNF)", cLog, "Nao localizada a competencia "+cComp1  })
					EndIf
					
					if dVcto1 < dDatabase .or. dVcto1 > dDtFimCTr  
						_lErroArqu	:= .T.		// Encontrado erro de processamento no arquivo  
						cLog := " A data de medi็ใo ("+DTOC(dVcto1)+") ้ superior da data de vencimento do contrato ("+DTOC(dDtFimCTr)+")"
						U_miGerLog(, cLog )
						Aadd(aDetExcel, {cNomeCom, cEmpFil, CnpjExcel(cCgcCliFor), cContrato, cNumMed , cNumPed, "CRONOGRAMA (CNF)", cLog, "Data de medi็ใo invแlida"  })
					endif					
					
					If _lErroArqu				// Se deu erro na leitura do arquivo
						Return					// abandono a rotina
					Else						// Se ocorreu tudo bem,
						QRYPLA->(DbSkip())		// Leio o proximo item da planilha e do arquivo CSV.
					Endif
					
				End
				
			Else
				_lErroArqu  := .T.		// Encontrado erro de processamento no arquivo
				cLog := "Planilha nใo encontrada. Verifique os dados como Filial, contrato, revisใo, cliente ou fornecedor, etc...! Filial " + xFilial("CNB") + " Contrato Nro.: "+cContrato+ " Revisao " + _cRevisa + " CNPJ: "+cCgcCliFor+"."
				U_miGerLog(, cLog )
				Aadd(aDetExcel, {cNomeCom, cEmpFil, cCgcCliFor, cContrato , cNumMed, cNumPed,  "PLANILHA (CNA/CNB)", cLog , "Erro" })
				SA1->(dbSetOrder(1))
			EndIf
			
		Else
			_lErroArqu  := .T.		// Encontrado erro de processamento no arquivo
			cLog := "Cliente ou fornecedor nใo encontrado no cadastro de Clientes ou fornecedores. Contrato Nro.: "+cContrato+" CNPJ: "+cCgcCliFor+"."
			U_miGerLog(, cLog )
			Aadd(aDetExcel, {cNomeCom, cEmpFil, cCgcCliFor, cContrato,cNumMed , cNumPed,  "CONTRATO", cLog})
			SA1->(dbSetOrder(1))
		EndIf
		
	Else
		_lErroArqu  := .T.		// Encontrado erro de processamento no arquivo
		cLog := "Na Empresa/Filial " + cEmpAnt + "/" + cFilAnt + " o contrato "+cContrato+" nใo existe no cadastro (CN9). "
		U_miGerLog(, cLog )
		Aadd(aDetExcel, {"NรO PROCESSADO", , , cContrato,,, "ARQUIVO CSV", cLog , "Contrato nใo Localizado"+cContrato  })
	EndIf
Else
	_lErroArqu  := .T.		// Encontrado erro de processamento no arquivo
	cLog := "O numero do contrato ou as parcelas nใo foram informados. Contrato = " + cContrato
	U_miGerLog(, cLog )
	Aadd(aDetExcel, {cNomeCom, cEmpFil, cCgcCliFor, cContrato,cNumMed , cNumPed,  "CONTRATO", cLog, "nใo foi informado o contrato ou as parcelas" })
	SA1->(dbSetOrder(1))
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  บ GERAEXCAUบAutor  ณ B2finance          บ Data ณ  02/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Executa os ExecAutos de inclusใo da Medi็ใo e de           บฑฑ
ฑฑบDesc.     ณ da Medi็ใo.                                                บฑฑ
ฑฑบDesc.     ณ Tem tambem um trecho que grava de forma chumbada as        บฑฑ
ฑฑบDesc.     ณ parcelas e seus vencimentos no SC5. (porem este trecho     บฑฑ
ฑฑบDesc.     ณ esta comentado)                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GeraExcAu(aItens, aCab, nDesc, cContrato, nTox,xQtdParc)
Local aAutoErro			:= {}
Local nA				:= 0
Local cDebug			:= ""
Local cEnter			:= Chr(13) + Chr(10)
Private cRet			:= ""
Private aResult			:= {}
Private lMsErroAuto		:= .F.
Private lAutoErrNoFile	:= .T.

Begin Transaction

//%%%%%%%%%%%%%//
//Gera medi??o.//
//%%%%%%%%%%%%%//

cDebug += cEnter + "Inicio de geracao da medicao" + cEnter

MsExecAuto({|a,b,c|,CNTA120(a,b,c)},aCab,aItens,3, .F.)

U_miGerLog(aCab)
U_miGerLog(aItens)
lMove := .t.
If lMsErroAuto
	cDebug += "Erro na Rotina Automatica da geracao da medicao" + cEnter
	If lAutoErrNoFile
		aAutoErro := GetAutoGrLog()
		For nA := 1 To Len(aAutoErro)
			cRet += RTrim(aAutoErro[nA])+" "+CRLF
		Next nA
		//If Upper(Alltrim(Substr(cUsuario, 7, 15))) == "TOTVS" .or. Upper(Alltrim(Substr(cUsuario, 7, 15))) == "Geronimo Alves"
		//	Alert(cRet)
		//Endif
	Else
		MostraErro()
	Endif
	DisarmTransaction()
Else
	cDebug += "Rotina Automatica da geracao da Medicao executada com sucesso" + cEnter
	IF nDesc > 0
		RECLOCK("CNQ",.T.)
		CNQ->CNQ_FILIAL		:= aCab[1,2]
		CNQ->CNQ_TPDESC		:= '0001'
		CNQ->CNQ_CONTRA		:= cContrato
		CNQ->CNQ_NUMMED		:= aCab[2,2]
		CNQ->CNQ_VALOR		:= nDesc
		MSUNLOCK()
	endif
	RECLOCK("CND",.F.)
	IF nDesc > 0
		CND->CND_DESCME	:= nDesc
	endif
	CND->CND_VLTOT	:= nTox
	CND->CND_VLPREV	:= nTox
	CND->CND_PARCEL	:= xQtdParc
	IF nDesc > 0
		CND->CND_PARC1	-= nDesc
	endif
	MSUNLOCK()
Endif

//%%%%%%%%%%%%%%%%//
//Encerra medi??o.//
//%%%%%%%%%%%%%%%%//
If !lMsErroAuto
	cDebug += "Inicio do encerramento da medicao" + cEnter
	lMsErroAuto := .F.
	MsExecAuto({|a,b,c|,CNTA120(a,b,c)},aCab,aItens,6, .F.)
	
	If lMsErroAuto
		lMove := .t.
		cDebug += "Erro no encerramento da medicao" + cEnter
		If lAutoErrNoFile
			aAutoErro := GetAutoGrLog()
			cRet += "Numero do Contrato: "+cContrato+CRLF
			For nA := 1 To Len(aAutoErro)
				cRet += RTrim(aAutoErro[nA])+" "+CRLF
			Next nA
			U_miGerLog(, cRet)
		Else
			MostraErro()
			cRet += ""
		Endif
		If MsgYesNo(cRet+"Deseja Voltar e Corrigir?")
			//MsgYesNo("Ocorreu um erro no encerramento da medi็ใo "  +aCab[2,2] + " , deseja desfazer a medi็ใo ")
			cDebug += "Transacao desarmada (Gravacao da medicao e do pedido, estornado) - RollBack executado" + cEnter
			DisarmTransaction()
			lMove := .F.
		Endif
	Else
		cDebug += "Encerramento da medicao realizado com sucesso" + cEnter
		//----------------------------------------------------------------
		//| Ajuste do fonte para tratar vencimento do pedido de venda	 |
		//----------------------------------------------------------------
		
		cQryC5 := "SELECT C5_FILIAL, C5_NUM FROM "+RetSqlName("SC5")+" C5"
		cQryC5 += " WHERE C5_FILIAL = '"+aCab[1,2]+"'"
		cQryC5 += " AND C5_MDNUMED = '"+aCab[2,2]+"'"
		cQryC5 += " AND C5.D_E_L_E_T_ = ' '"
		
		If Select("QRYSC5")<>0
			DbSelectArea("QRYSC5")
			DbCloseArea()
		EndIf
		
		TcQuery cQryC5 New Alias "QRYSC5"
		
		QRYSC5->(dbGoTop())
		If QRYSC5->(!Eof())
			
			/*
			dbSelectArea("SC5")
			dbSetOrder(1)
			If dbSeek(QRYSC5->C5_FILIAL+QRYSC5->C5_NUM)
			RecLock("SC5",.F.)
			SC5->C5_DATA1	:= dVcto1
			SC5->C5_DATA2	:= dVcto2
			SC5->C5_DATA3	:= dVcto3
			SC5->C5_PARC1	:= nParc1
			SC5->C5_PARC2	:= nParc2
			SC5->C5_PARC3	:= nParc3
			SC5->(MsUnLock())
			EndIf
			*/
			
		EndIf
		QRYSC5->(DbCloseArea())
	EndIf
EndIf
End Transaction

If ! Empty(cRet)
	If ! Alltrim(aCab[1, 1]) $ cRet
		aEval(aCab, {|z| cRet += Pad(z[1], 11) + " => " + Transform(z[2], "") + cEnter})
		For nA := 1 to Len(aItens)
			aEval(aItens[nA], {|z| cRet += Pad(z[1], 11) + " => " + Transform(z[2], "") + Chr(13) + Chr(10)})
		Next
	Endif
Endif

aResult := {lMsErroAuto, cDebug + cRet}

U_miGerLog(, If(lMsErroAuto, "Erro na Rotina Automatica da geracao da medicao ou encerramento da medicao" , "Rotina Automatica da geracao da medicao e do encerramento da medicao executadas com sucesso") + Chr(13) + Chr(10) + cDebug + cRet)

Return aResult

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  บ TXTTOARR บAutor  ณ B2finance          บ Data ณ  02/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Converte o texto contendo o caracter separador em array.   บฑฑ
ฑฑบDesc.     ณ Seno os elementos da Array definidos por estes cracteres   บฑฑ
ฑฑบDesc.     ณ separadores                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TXTTARR(cLinha, cSepara)
Local aArray   := {}
Local cLinha_  := ""
Default cLinha := ""
Default cSepara:= ";"

nPosAt := At(AllTrim(cSepara), cLinha)
If nPosAt == 0
	//MsgStop("Separador nใo encontrado!")
	Return Nil
EndIf

While Len(cLinha)>0
	nPosAt := At(AllTrim(cSepara), cLinha)
	cLinha_ := SubStr(cLinha, 1, nPosAt-1)
	cLinha  := SubStr(cLinha, nPosAt+1)
	If nPosAt == 0
		Aadd(aArray, cLinha)
		cLinha := ""
	Else
		Aadd(aArray, cLinha_)
	EndIf
End
Return aArray


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  บCnpjExcel บAutor  ณ B2finance          บ Data ณ  02/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o cnpj recebido, precedido por uma aspas simples   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CnpjExcel(cCgcCliFor)
Local cRet := "'" + cCgcCliFor
Return(cRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  บLocSA1_SA2 บAutor  ณ B2finance          บ Data ณ  02/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Pesquisa cliente ou fornecedor pelo cnpj recebido no       บฑฑ
ฑฑบDesc.     ณ parametro no cadastro de clientes SA1 ou fornecedores SA2  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LocSA1_SA2(cCgcCliFor)  //Pesquisa pelo cnpj o cliente no cadastro de clientes SA1, ou o fornecedor no cadastro de fornecedores SA2
Local cSeek			:= Nil
Local nA1_A2Recn	:= Nil
Local aSavAre		:= GetArea()

If cVendaComp == "V"					// Arquivo ้ de contrato de Vendas
	dbSelectArea("SA1")
	dbSetOrder(3) // 3  A1_FILIAL+A1_CGC
	dbSeek(cSeek := xFilial("SA1") + cCgcCliFor)
	Do While ! Eof() .And. SA1->A1_FILIAL+AllTrim(SA1->A1_CGC) == cSeek
		If SA1->A1_MSBLQL <> "1"
			nA1_A2Recn := SA1->(Recno())
			Exit
		Endif
		dbSkip()
	Enddo
	RestArea(aSavAre)
	SA1->(dbSetOrder(1))
	If nA1_A2Recn <> Nil
		SA1->(dbGoto(nA1_A2Recn))
	Endif
	
ElseIf cVendaComp == "C"				// Arquivo ้ de contrato de Compras
	dbSelectArea("SA2")
	dbSetOrder(3) // 3  A2_FILIAL+A2_CGC
	dbSeek(cSeek := xFilial("SA2") + cCgcCliFor)
	Do While ! Eof() .And. SA2->A2_FILIAL+AllTrim(SA2->A2_CGC) == cSeek
		If SA2->A2_MSBLQL <> "1"
			nA1_A2Recn := SA2->(Recno())
			Exit
		Endif
		dbSkip()
	Enddo
	RestArea(aSavAre)
	SA2->(dbSetOrder(1))
	If nA1_A2Recn <> Nil
		SA2->(dbGoto(nA1_A2Recn))
	Endif
	
Endif

Return(nA1_A2Recn <> Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  บmiGerLog บAutor  ณ B2finance          บ Data ณ  02/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava amensagem recebida como parametro pela fun็ใo em     บฑฑ
ฑฑบDesc.     ณ arquivo de log                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function miGerLog(_aAuto, cMsg, lReset, lEnd)
Local cPathServer := "\"										// cPathServer := "C:\TEMP\"
Local cFileLog       := "Log_Medicao_" + _cArquivo + "_.txt"
Local cPathLocal  := iPathLocal()
Local cEnter      := Chr(13) + Chr(10)
Local aAuto       := Nil
Local nHandle     := Nil
Local nLoop1      := Nil
Local nLoop2      := Nil

Default lReset := .F.
Default lEnd   := .F.

If lReset
	fErase(cPathServer + cFileLog)
	fErase(cPathLocal  + cFileLog)
	Return
Endif

If lEnd
	
	If _lErroArqu
		_cResult_Proc	:= "Erro_"
	Else
		_cResult_Proc	:= "Processado_"
	Endif
	
	lCopia := U_FileMove( cPathServer + cFileLog  , _cDirLogs + _cResult_Proc + cFileLog  ,.T.) // MOVE ARQUIVO DE LOG PARA A PASTA DE LOGS. Tamb้m renomeia o arquivo, comecando o seu nome com Erro_ ou Processado_
	If lCopia
		fErase( cPathServer + cFileLog  )
	Endif
	
	If Upper(Alltrim(Substr(cUsuario, 7, 15))) == "TOTVS" .or. Upper(Alltrim(Substr(cUsuario, 7, 15))) == "GERONIMO ALVES"
		WinExec( "Notepad.exe " + cPathLocal + cFileLog)
	Endif
	Return
Endif

If (nHandle := If(File(cPathServer + cFileLog), fOpen(cPathServer + cFileLog, 1), Fcreate(cPathServer + cFileLog, 0))) <= 0
	Return
Endif

fSeek(nHandle, 0, 2)

If cMsg <> Nil
	fWrite(nHandle, cEnter + cMsg + cEnter + cEnter)
Endif

If _aAuto == Nil
	fClose(nHandle)
	Return
Endif

aAuto := aClone(_aAuto)

If ValType(aAuto) == "A" .And. Len(aAuto) == 0
	fClose(nHandle)
	Return
Endif

If ValType(aAuto[1, 1]) <> "A"
	aAuto := aClone( { aAuto } )
Endif

cMsg := cEnter + cEnter

For nLoop1 := 1 to Len(aAuto)
	If Len(aAuto[nLoop1]) > 1
		cMsg += cEnter + "Array de itens: ITEM " + StrZero(nLoop1, 3) + cEnter
	Endif
	
	For nLoop2 := 1 to Len(aAuto[nLoop1])
		cMsg += Pad(aAuto[nLoop1, nLoop2, 1], 12) + " => " + Alltrim(Transform(aAuto[nLoop1, nLoop2, 2], "")) + cEnter
	Next
	cMsg += cEnter
Next

fWrite(nHandle, cMsg + cEnter)

fClose(nHandle)

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  iPathLocal บAutor  ณ B2finance          บ Data ณ  02/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Define o path local                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function iPathLocal()
Local cPathLocal

If Empty(cPathLocal := GetTempPath())
	If Len(Directory("C:\Temp\*.*", "D")) > 0
		cPathLocal := "C:\Temp\"
	Else
		cPathLocal := "C:\"
	Endif
Endif

cPathLocal := Alltrim(cPathLocal)

If Right(cPathLocal, 1) <> "\"
	cPathLocal += "\"
Endif

Return(cPathLocal)
///



/*/
ฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฟ
ณFun…o    ณFileMove      ณAutorณGeronimo Benedito Alves					ณ Dataณ31/10/14   ณ
รฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤด
ณDescri…o ณ Copiar ou Mover um arquivo de Diretorio. Se lErase estiver .T. Move o arquivo     ณ
ณ          ณ Se lErase estiver .F. Faz a copia                                                 ณ
รฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด
ณSintaxe   ณ<vide parametros formais>														   ณ
รฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด
ณParametrosณ<vide parametros formais>														   ณ
รฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด
ณUso       ณGenerico                      							         				   ณ
ภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู/*/
User Function FileMove( cOldPathFile , cNewPathFile , lErase )

Local lMoveFile

Begin Sequence

IF !(;
	lMoveFile := (;
	( __CopyFile( cOldPathFile , cNewPathFile ) );
	.and.;
	File( cNewPathFile );
	.and.;
	EqualFile( cOldPathFile , cNewPathFile );
	);
	)
	Break
EndIF

DEFAULT lErase := .T.

IF ( lErase ) .And. lMoveFile
	fErase( cOldPathFile )
EndIF

End Sequence

Return( lMoveFile )


/*/
ฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟ
ณFun…o    ณEqualFile     ณAutorณGeronimo B. Alves   ณ Data ณ 02/11/14  ณ
รฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤด
ณDescri…o ณVerifica se Dois Arquivos sao Iguais                        ณ
รฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด
ณSintaxe   ณ<vide parametros formais>									ณ
รฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด
ณParametrosณ<vide parametros formais>									ณ
รฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด
ณUso       ณGenerico                      								ณ
ภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู/*/
Static Function EqualFile( cFile1 , cFile2 )

Local lIsEqualFile	:= .F.

Local nfhFile1	:= fOpen( cFile1 )
Local nfhFile2	:= fOpen( cFile2 )

Begin Sequence

IF (;
	( nfhFile1 <= 0 );
	.or.;
	( nfhFile2 <= 0 );
	)
	Break
EndIF

lIsEqualFile := ArrayCompare( GetAllTxtFile( nfhFile1 ) , GetAllTxtFile( nfhFile2 ) )

fClose( nfhFile1 )
fClose( nfhFile2 )

End Sequence

Return( lIsEqualFile )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPosicioCN9บAutor  ณGeronimo B. ALves   บ Data ณ  19/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca e se posiciona no CONTRATO (CN9) para obter codigo   บฑฑ
ฑฑบ          ณ e loja do cliente ou fornecedor                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Functio PosicioCN9( cContrato )
Local nA1_A2Recn	:= Nil

Private  _aArea := GetArea()
DbSelectArea("CN9")
DbSetOrder(1)
DbSeek( xFilial("CN9") + cContrato )

Return
