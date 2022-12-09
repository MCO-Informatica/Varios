#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#DEFINE  ENTER CHR(13)+CHR(10)

User Function MemMgr()

alParams	:= {.T.,"01","01",.T.,.F.,""} //{.F.,"","",.F.,.F.,""}

If alParams[1]
	RpcSetType(3)
	RpcSetEnv(alParams[2],alParams[3])
Else
	alAreaSM0 := SM0->(GetArea())
	llJob:=.T.
EndIf

Private aManager	:= {}
Private aCritico	:= {}

//Alert("teste")
FOR NX := 1 TO len(Directory("\\terra\Protheus_Data\Appserver_LogMemoria\*.*"))
	
	Private cArqTxt  := "\\terra\Protheus_Data\Appserver_LogMemoria\"+alltrim(str(nx))+"_appserver_memoryLog.txt" // mv_par01
	Private cEOL     := "CHR(13)+CHR(10)"
	
	IF FILE(cArqTxt)
		
		Private nHdl     := fOpen(cArqTxt,68)
		
		If Empty(cEOL)
			cEOL := CHR(13)+CHR(10)
		Else
			cEOL := Trim(cEOL)
			cEOL := &cEOL
		Endif
		
		If nHdl == -1
			MsgAlert("O arquivo de nome " + cArqTxt + " nao pode ser aberto!","Atencao!")
			Return
		Endif
		
		//Processa({|| LeArq() },"Verificando tabelas...")
		LeArq()
		
	ENDIF
	
Next nX

//alert(len(aManager))

FOR nY := 1 TO LEN(aManager)
	IF aMANAGER[nY][2] > 1200000
		aadd(aCritico, { aManager[nY][1], Transform(aManager[nY][2],"@E 9,999,999,999") } )
	ENDIF
NEXT nY

IF LEN(aCRITICO) > 0
	cPara	:= 'informatica@laselva.com.br'
	cCorpo	:= 'O(s) serviço(s) abaixo estão com quantidade crítica de memória e poderão travar o Protheus' 	
	cCorpo	+= ' <html> '
	cCorpo	+= ' <body> '
	cCorpo	+= ' <br> '
	cCorpo	+= ' 	<TABLE width="400" cellSpacing="1" border="1" bordercolor="#ff0033"> '
	cCorpo	+= ' 	<TR> '
	cCorpo	+= ' 		<TD bgColor="#ff0033" align="left"><font color="#ffffff" size="1" face="Verdana"><b>Appserver</b></font></TD> '	
	cCorpo	+= ' 		<TD bgColor="#ff0033" align="left"><font color="#ffffff" size="1" face="Verdana"><b>Memória</b></font></TD> '	
	cCorpo	+= ' 	</TR> '
	FOR nZ := 1 TO LEN(aCRITICO)
		cCorpo	+= ' 	<TR> '
		cCorpo	+= ' 		<TD bgColor="#ffffff" align="left"><font size="2" face="Verdana" color="#000040"><b>'+aCritico[nZ][1]+'</b></font></TD> '
		cCorpo	+= ' 		<TD bgColor="#ffffff" align="right"><font size="2" face="Verdana" color="#000040"><b>'+aCritico[nZ][2]+'</b></font></TD> '
		cCorpo	+= ' 	</TR>  '
	NEXT nZ
	cCorpo	+= ' 	</TABLE>  '
	cCorpo	+= ' </body>  '
	cCorpo	+= ' </html>  '
	
	U_ENVMAIL(cPara,"Alerta - Appservers Criticos", cCorpo)
ENDIF

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ************************************************************************************************************************** //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LeArq()

Local nTamFile, nTamLin, cBuffer, nBtLidos
Local lOk    		:= .T.
Local aItens 		:= {}
Local nLinha 		:= 0
PRIVATE lMsErroAuto := .F.
PUBLIC aCT2  		:= {}
PUBLIC aDescV		:= {}
PUBLIC aDescV2		:= {}
PUBLIC aDescricao	:= {}
PUBLIC aValor		:= {}
nPosMemoria			:= 0
cProd 				:= ""
nCont				:= 1
nValid				:= 1
aCTC 				:= {}
aCTF 				:= {}
aCLI 				:= {}
aLXC 				:= {}
nTamArray			:= 0
nA                  := 1
nB					:= 1
nT					:= 1
//nX					:= 1
//nZ					:= 1
aErros				:= {}
nTamFile 			:= fSeek(nHdl,0,2)

ProcRegua(nTamFile) // Numero de registros a processar

ft_fuse(cArqTxt)

While ! ft_feof()
	
	cBuffer 		:= ft_freadln()
	aRet 			:= StrTokArr(cBuffer,CHR(9))
	cServiceName	:= substr(cBuffer,1,25)
	
	IF LEN(cBuffer) == 0
		ft_fskip() // Leitura da proxima linha do arquivo texto
		loop
	ENDIF
	
	IF substr(cBuffer,1,25) == replicate("=",25)
		ft_fskip() // Leitura da proxima linha do arquivo texto
		loop
	ENDIF
	
	IF alltrim(substr(cBuffer,1,25)) == ALLTRIM("Image Name")
		//nPosMemoria		:= at("Session#",cBuffer)+2
		//nPosMemoria		:= at("Mem Usage",cBuffer)-3
		nPosMemoria		:= at("#",cBuffer)+1
		ft_fskip() // Leitura da proxima linha do arquivo texto
		loop
	ENDIF
	
	cServiceMem	:= substr(cbuffer,nPosMemoria,12)
	nPosPonto 	:= at(".",cServiceMem)
	nPosVirgula	:= at(",",cServiceMem)
	
	// Remove os pontos
	WHILE nPosPonto > 0
		cServiceMem := substr(cServiceMem,1,nPosPonto-1)+substr(cServiceMem,nPosPonto+1,len(cServiceMem))
		nPosPonto 	:= at(".",cServiceMem)
	ENDDO
	// Remove os virgula
	WHILE nPosVirgula > 0
		cServiceMem	:= substr(cServiceMem,1,nPosVirgula-1)+substr(cServiceMem,nPosVirgula+1,len(cServiceMem))
		nPosVirgula := at(",",cServiceMem)
	ENDDO
	
	// junta os dois arrays ///////////////////////
	aadd(aManager, { cServiceName, Val(alltrim(cServiceMem)) } )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Leitura da proxima linha do arquivo texto.                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ft_fskip() // Leitura da proxima linha do arquivo texto
	
EndDo

Return
