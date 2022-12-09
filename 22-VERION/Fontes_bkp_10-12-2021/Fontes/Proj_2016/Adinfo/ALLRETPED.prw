#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#include "Fileio.ch"
#INCLUDE "TOPCONN.CH"
#include "TBICONN.CH"
#include "TBICODE.CH"
#INCLUDE "FONT.CH"
#INCLUDE "MSOBJECT.CH"
#include "TOTVS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ALLPED    �Autor  �Samuel Barbosa      � Data �  20/07/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �      Arquivo de pedido .TXT                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ALL ALIMENTOS                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ALLRETXML()
Private aRetDir := {}
Private cLocal  :="\adinfo\xml\"//GETMV("MV_XFTXML")
Private nAtual  := 0
Private cNfe

cSql :="SELECT C5_NUM,C5_NOTA,C5_SERIE "
cSql += CRLF +"FROM " + RetSqlName("SC5")
cSql += CRLF +"WHERE C5_NUM ='169361'"
cSql += CRLF +"AND " + RetSqlName("SC5") + ".D_E_L_E_T_ = '' "

If Select("_QRY") > 0
	_QRY->(DbCloseArea())
Endif
TcQuery ChangeQuery(cSql) New Alias "_QRY"
Count to nCount
_QRY->(DbGoTop())

if nCount >0
	
	
	if  FTPConnect('187.94.58.20',21,'meagcp_teste@datacenter.local','KbfPqOpHDn')// Conecta FTP
		Conout("FTP conectado com sucesso")
	Else
		Conout("ocorreu um erro ao conectar sua conta FTP. por favor tente novamente")
	Endif
	
	cNome:= STRZERO(val(_QRY->C5_NUM),6) +'-'+ STRZERO(val(_QRY->C5_NOTA),9)//Nome do arquivo
	zSpedXML(_QRY->C5_NOTA,_QRY->C5_SERIE, cLocal + cNome  + ".xml", .F.)//Gera XML
	zGerDanfe(_QRY->C5_NOTA,_QRY->C5_SERIE,cLocal,cNome)//Gera Danfe
	RERPM01(cLocal,cNome) //Gera arquivo txt
	
	//Envio de arquivos ao FTP.
	aFile := Directory(cLocal + cNome + "*.*")
	If  FTPDirChange("meagcp_teste/MEAGCP_5030/Faturamento/") //Seleciona Diretorio no FTP  GETMV("MV_XFTFAT"
		
		For nPosic := 1 to Len(aFile)
			If FTPUpLoad( cLocal + aFile[nPosic][1],aFile[nPosic][1])
				Conout('UpLoad Ok! '+ aFile[nPosic][1])
				DbSelectArea("SC5")
				DbSetOrder(1)
				/*If DbSeek(xFilial("SC5") + _QRY->C5_NUM)
					RecLock("SC5", .F.)
					SC5->C5_XSITWMS = "Enviado NF"
					SC5->C5_XRETWMS = "Enviado NF"
					MsUnLock() //Confirma e finaliza a opera��o
				EndIf */
			Else
				Conout('Falha UpLoad!'+aFile[nPosic][1])
				DbSelectArea("SC5")
				DbSetOrder(1)
				/*If DbSeek(xFilial("SC5") + _QRY->C5_NUM)
					RecLock("SC5", .F.)
					SC5->C5_XSITWMS = "Erro ao enviar NF"
					SC5->C5_XRETWMS = "Erro ao enviar "
					MsUnLock()
				Endif */
			EndIf
		Next
	EndIf
Endif
Return

Static Function zGerDanfe(cNota, cSerie, cPasta,cArquivo)
Local aArea     := GetArea()
Local cIdent    := ""
Local oDanfe    := Nil
Local lEnd      := .F.
Local nTamNota  := TamSX3('F2_DOC')[1]
Local nTamSerie := TamSX3('F2_SERIE')[1]
Local nPrintType :=1
Private PixelX
Private PixelY
Private nConsNeg
Private nConsTex
Private oRetNF
Private nColAux
Default cNota   := ""
Default cSerie  := ""
Default cArquivo  := ""

//Se existir nota
If ! Empty(cNota)
	//Pega o IDENT da empresa
	cIdent := RetIdEnti()
	
	//Define as perguntas da DANFE
	Pergunte("NFSIGW",.F.)
	MV_PAR01 := PadR(cNota,  nTamNota)     //Nota Inicial
	MV_PAR02 := PadR(cNota,  nTamNota)     //Nota Final
	MV_PAR03 := PadR(cSerie, nTamSerie)    //S�rie da Nota
	MV_PAR04 := 2                          //NF de Saida
	MV_PAR05 := 1                          //Frente e Verso = Sim
	MV_PAR06 := 2                          //DANFE simplificado = Nao
	
	//Cria a Danfe
	//oDanfe := FWMSPrinter():New(cArquivo, IMP_PDF, .F., , .T.)
	oDanfe  := FWMSPrinter():New(cArquivo,IMP_PDF, .F.,cPasta, .T., .F., , , .F., .F., , .F.)
	oDanfe  :cPathPDF:=cPasta
	//Propriedades da DANFE
	oDanfe:SetResolution(78)
	oDanfe:SetPortrait()
	oDanfe:SetPaperSize(DMPAPER_A4)
	oDanfe:SetMargin(60, 60, 60, 60)
	
	//For�a a impress�o em PDF
	oDanfe:nDevice  := 6
	oDanfe:cPathPDF := cPasta
	oDanfe:lServer  := .F.
	oDanfe:lViewPDF := .F.
	
	//Vari�veis obrigat�rias da DANFE (pode colocar outras abaixo)
	PixelX    := oDanfe:nLogPixelX()
	PixelY    := oDanfe:nLogPixelY()
	nConsNeg  := 0.4
	nConsTex  := 0.5
	oRetNF    := Nil
	nColAux   := 0
	
	//Chamando a impress�o da danfe no RDMAKE
	RptStatus({|lEnd| StaticCall(DANFEII, DanfeProc, @oDanfe, @lEnd, cIdent, , , .F.)}, "Imprimindo Danfe...")
	oDanfe:Preview()
EndIf

RestArea(aArea)
Return


Static Function zSpedXML(cDocumento, cSerie, cArqXML, lMostra)
Local aArea        := GetArea()
Local cURLTss      := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local oWebServ
Local cIdEnt       := StaticCall(SPEDNFE, GetIdEnt)
Local cTextoXML    := ""
Default cDocumento := ""
Default cSerie     := ""
Default cArqXML    := GetTempPath()+"arquivo_"+cSerie+cDocumento+".xml"
Default lMostra    := .F.

//Se tiver documento
If !Empty(cDocumento)
	cDocumento := PadR(cDocumento, TamSX3('F2_DOC')[1])
	cSerie     := PadR(cSerie,     TamSX3('F2_SERIE')[1])
	
	//Instancia a conex�o com o WebService do TSS         4
	oWebServ:= WSNFeSBRA():New()
	oWebServ:cUSERTOKEN        := "TOTVS"
	oWebServ:cID_ENT           := cIdEnt
	oWebServ:oWSNFEID          := NFESBRA_NFES2():New()
	oWebServ:oWSNFEID:oWSNotas := NFESBRA_ARRAYOFNFESID2():New()
	aAdd(oWebServ:oWSNFEID:oWSNotas:oWSNFESID2,NFESBRA_NFESID2():New())
	aTail(oWebServ:oWSNFEID:oWSNotas:oWSNFESID2):cID := (cSerie+cDocumento)
	oWebServ:nDIASPARAEXCLUSAO := 0
	oWebServ:_URL              := AllTrim(cURLTss)+"/NFeSBRA.apw"
	
	//Se tiver notas
	If oWebServ:RetornaNotas()
		
		//Se tiver dados
		If Len(oWebServ:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3) > 0
			
			//Se tiver sido cancelada
			If oWebServ:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFECANCELADA != Nil
				cTextoXML := oWebServ:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFECANCELADA:cXML
				
				//Sen�o, pega o xml normal
			Else
				cTextoXML := oWebServ:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFE:cXML
			EndIf
			
			//Gera o arquivo
			MemoWrite(cArqXML, cTextoXML)
			
			//Se for para mostrar, ser� mostrado um aviso com o conte�do
			If lMostra
				Aviso("zSpedXML", cTextoXML, {"Ok"}, 3)
			EndIf
			
			//Caso n�o encontre as notas, mostra mensagem
		Else
			ConOut("zSpedXML > Verificar par�metros, documento e s�rie n�o encontrados ("+cDocumento+"/"+cSerie+")...")
			
			If lMostra
				Aviso("zSpedXML", "Verificar par�metros, documento e s�rie n�o encontrados ("+cDocumento+"/"+cSerie+")...", {"Ok"}, 3)
			EndIf
		EndIf
		
		//Sen�o, houve erros na classe
	Else
		ConOut("zSpedXML > "+IIf(Empty(GetWscError(3)), GetWscError(1), GetWscError(3))+"...")
		
		If lMostra
			Aviso("zSpedXML", IIf(Empty(GetWscError(3)), GetWscError(1), GetWscError(3)), {"Ok"}, 3)
		EndIf
	EndIf
EndIf
RestArea(aArea)
Return

Static Function RERPM01(cDir,cArq)
Local aDir :={}
//�������������������������������������������������������������������������������������������������������������������Ŀ
//�FCreate - � o comando responsavel pela cria��o do arquivo.                                                         �
//���������������������������������������������������������������������������������������������������������������������
Local nHandle := 0
Local nCount  := 0
Default cDir :=""
Default cArq :=""

//�������������������������������������������������������������������������������������������������������������������Ŀ
//�nHandle - A fun��o FCreate retorna o handle, que indica se foi poss�vel ou n�o criar o arquivo. Se o valor for     �
//�menor que zero, n�o foi poss�vel criar o arquivo.                                                                  �
//���������������������������������������������������������������������������������������������������������������������
If nHandle < 0
	MsgAlert("Erro durante cria��o do arquivo.")
Else
	//�������������������������������������������������������������������������������������������������������������������Ŀ
	//�FWrite - Comando reponsavel pela grava��o do texto.                                                                �
	//���������������������������������������������������������������������������������������������������������������������
	aFiles := Directory(cDir + cArq + "*.*")
	
	nHandle := FCreate(cDir+ cArq + ".txt")
	
	For nLinha := 1 to Len(aFiles)
		FWrite(nHandle, aFiles[nLinha][1] + CRLF)
	Next nLinha
	//�������������������������������������������������������������������������������������������������������������������Ŀ
	//�FClose - Comando que fecha o arquivo, liberando o uso para outros programas.                                       �
	//���������������������������������������������������������������������������������������������������������������������
	FClose(nHandle)
EndIf
Return