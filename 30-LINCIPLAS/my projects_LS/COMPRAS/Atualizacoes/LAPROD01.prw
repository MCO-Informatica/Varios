/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณLAPROD01  ณ Autor ณ Vinicius Matos        ณ Data ณ 23/04/09 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o  ณ Gera็ใo de pedido de compras lendo os dados dos arquivos   ณฑฑ
ฑฑณ           ณ textos do fornecedor DINAP e CHINAGLIA                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUSO        ณ                                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ.ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

User Function LAPROD01()
Local oCombo
Local _aFor 	:= {"DINAP","FC_AR"}
Private oLetxt
Private cCombo

Conout("*** La Selva - User Function LAPROD01 - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivos Textos")
@ 02,10 TO 080,190 PIXEL OF oLetxt
@ 10,018 Say " Este programa ira gerar pedidos de compras, conforme dados" PIXEL OF oLetxt
@ 18,018 Say " dos arquivos texto DINAP e Chinaglia" PIXEL OF oLetxt

@ 45,018 Say "Escolha o Fornecedor   " PIXEL OF oLetxt
@ 43,080 COMBOBOX oCombo VAR cCombo ITEMS _aFor SIZE 80,05 PIXEL OF oLetxt

@ 70,128 BMPBUTTON TYPE 01 ACTION ( OkLeTxt(), Close(oLeTxt) )
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณOkLeTxt   บAutor  ณVinicus             บ Data ณ  23/04/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAbre arquivo texto escolhido pelo usuario                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function OkLeTxt()

Local nPos			:= ''
Local _cDrive 		:= ''
Local _cNomArq 		:= ''
Local cAux, nTam
Local _aArea 		:= GetArea()
Local _lFilial 		:= .t.

LOCAL cDirectory	:= ""
LOCAL nArq := 0

Private cArqTxt
Private nHdl
Private _aItens   	:= {}
Private _aNaoPro  	:= {}
Private _aProd    	:= {}
Private _aProces  	:= {}
Private _aLinha   	:= {}
Private _cForn 		:= ""
Private _cLoja 		:= ""
Private _ArqFal
Private _cNumPed 	:= ""
Private _cCond   	:= ""
Private _cFilAtu 	:= ""
PRIVATE aParamFile	:= ARRAY(1)
Private _cCota 		:= ""
Private aArquivos 	:= {}

Conout("*** La Selva - Static Function OKLETXT - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

If cCombo == "DINAP"
	cExt := "*.LCT"
else
	cExt := "*.RTX"

EndIf

DbSelectArea("SZH") //tabela cotas x filiais no protheus
DbSetOrder(1)

DbSelectArea("SB1")
DbSetOrder(5) //cod.barras

cDirectory := ALLTRIM(cGetFile("Escolha o Diretorio" ,'Importa็ใo '+cCombo, 0,'', .T., GETF_OVERWRITEPROMPT + GETF_LOCALHARD + GETF_NETWORKDRIVE+ GETF_RETDIRECTORY,.T.))
If empty(cDirectory)
	RestArea(_aArea)
	return

EndIf

aArquivos := Directory(cDirectory+"*.*")
lProcessa := MARKFILE(aArquivos,cDirectory,cExt,.t.)
If !lProcessa
	RestArea(_aArea)
	return

EndIf

For nArq := 1 to Len(aArquivos)
	
	If !aArquivos[nArq][1]
		loop

	EndIf
	
	_cPath  := alltrim(aArquivos[nArq][3])
	cArqTxt := _cPath + alltrim(aArquivos[nArq][2])
	
	_cDrive :=  _cPath + "\processados\"
	_cNomArq := alltrim(aArquivos[nArq][2])
	_ArqFal := _cPath + '\R_' + _cNomArq
	_ArqPro := _cDrive + _cNomArq
	
	If !ExistDir(_cDrive)
		MsgAlert("Criar a pasta:  " + upper(_cDrive) + "  antes de processar arquivo!  ","Atencao!")
		RestArea(_aArea)
		Return

	EndIf
	
	nHdl := ft_fuse(cArqTxt)
	
	If nHdl == -1
		MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser aberto! VerIfique os parametros.","Atencao!")
		loop

	EndIf
	
	_cFilAtu := cFilAnt
	_cNumPed := ""
	_aNaoPro := {}
	_aProces := {}
	
	If cCombo == "DINAP"
		MsgRun("Aguarde...  Processando Arquivo DINAP " + _cNomArq, "Aguarde", {|| fDinap()} )
	else
		//CHINAGLIA
		
		_lFilial := .t.
		//pega o codigo da cota que esta nos 04 ultimos caracteres do nome do arquivo e procura qual a
		//filial do protheus correspondente no SZH
		nTam := len(_cNomArq) - 4 //tira o ponto e a extensao (.lct)
		cAux := left(_cNomArq,nTam)
		_cCota := right(cAux,4) + space(06)
		
		DbSelectArea("SZH")
		If DbSeek(xFilial("SZH")+"2"+_cCota) //"2" e o codigo da Chinaglia na lista de opcoes do campo ZH_NOMEFOR
			cFilAnt := SZH->ZH_CODFIL
			_cForn  := SZH->ZH_FORNEC
			_cLoja  := SZH->ZH_LOJA
			MsgRun("Aguarde...  Processando Arquivo Chinaglia " + _cNomArq, "Aguarde", {|| fChinag()} )
		else
			_lFilial := .f.


		EndIf
	EndIf
	
	ft_fuse()
	
	If !_lFilial
		MsgAlert("Cota: " + _cCota +" nao cadastrada em Cotas x Filial. Arquivo " + cArqTxt + " nao processado!","Aten็ใo")
		loop

	EndIf
	
	If len(_aNaoPro) > 0  .and. len(_aProces) > 0
		GrvNPro()

	EndIf
	
	If len(_aProces) > 0
		GrvProc()

	EndIf
	
	If empty(_cNumPed)
		MsgAlert("Nenhum pedido de compras foi gerado para Filial " + cFilAnt,"Aten็ใo")

	EndIf
	
Next

MsgAlert("Processamento finalizado!","Aten็ใo")

If len(_aItens) > 0
	//Asort(_aItens,,, {|x,y| x[1]+x[2]+x[3]+x[7] < y[1]+y[2]+y[3]+y[7] } )
	U__RelHQ02()

EndIf

If len(_aProd) > 0
	U__RelHQ03()

EndIf

cFilAnt := _cFilAtu

RestArea(_aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvNPro   บAutor  ณGiane               บ Data ณ  28/04/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava arquivos com os nao processados                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GrvNPro()
Local cEOL 	:= "CHR(13)+CHR(10)"
Local _NewArq, nFal, _n, cLin

Conout("*** La Selva - Static Function GRVNPRO - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL

EndIf

If file(_ArqFal)
	_NewArq := left(_ArqFal, len(_ArqFal) - 3) + "ant"
	rename _ArqFal to _NewArq

EndIf

nFal := fCreate(_ArqFal)
If nFal == -1
	MsgAlert("O arquivo "+_ArqFal+" nao pode ser criado! ","Atencao!")
	Return

EndIf

For _n := 1 to len(_aNaoPro)
	
	cLin := _aNaoPro[_n] + cEOL
	
	If fWrite(nFal,cLin,Len(cLin)) != Len(cLin)
		MsgAlert("Erro na gravacao do arquivo " + upper(_ArqFal) ,"Atencao!")
		Exit

	EndIf
	
Next

fClose(nFal)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvProc   บAutor  ณGiane               บ Data ณ  28/04/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava arquivos com todos os registros processados          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GrvProc()
Local cEOL 	:= "CHR(13)+CHR(10)"
Local _NewArq, nPro, _n, cLin
Local _ArqOri, _cExt

Conout("*** La Selva - Static Function GRVPROC - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL

EndIf

If file(_ArqPro)
	_cExt := left(time(),2) + substr(Time(),4,2)
	_NewArq := left(_ArqPro, len(_ArqPro) - 3) + _cExt
	rename (_ArqPro) to (_NewArq)

EndIf

nPro := fCreate(_ArqPro)
If nPro == -1
	MsgAlert("O arquivo "+_ArqPro+" nao pode ser criado! ","Atencao!")
	Return

EndIf

For _n := 1 to len(_aProces)
	
	cLin := _aProces[_n] + cEOL
	
	If fWrite(nPro,cLin,Len(cLin)) != Len(cLin)
		MsgAlert("Erro na gravacao do arquivo " + upper(_ArqPro) ,"Atencao!")
		Exit

	EndIf
	
Next

fClose(nPro)

If file (_ArqPro)
	//_ArqOri := left(cArqTxt,len(cArqTxt) - 3) + "ORI"
	_ArqOri := left(_ArqPro,len(_ArqPro) - 3) + "ORI"
	//Rename (cArqTxt) to (_ArqOri)
	Copy File (cArqTxt) to (_ArqOri)
	If file(_ArqOri)
		delete file (cArqTxt)


	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfDinap    บAutor  ณGiane               บ Data ณ  23/04/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLe arquivo Dinap e processa os dados                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fDinap()

Local cBuffer, _cDescr2
//Local _cCota
Private _cCGC, _cEdicao, _cCodBarra, _cDescr
Private _nQuant, _cEditora, _nCusto, _nCstTot
Private _cProd 		:= ''
Private _cTipo,  _cRef
Private _cLinha
Private _cAssunto 	:= ''
Private _cItem 		:= ""
Private _aAuxIte 	:= {}

Conout("*** La Selva - Static Function FDINAP - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

_aLinha := {}

ft_fgotop()
While !ft_feof()
	
	_cLinha  := ft_freadln()
	cBuffer  := _cLinha
	
	_cCota     := Substr( cBuffer, 19,4)
	_cRef      := Substr( cBuffer, 36, 8)
	_cEdicao   := Substr( cBuffer,  44, 04)
	_cCodBarra := ALLTRIM(Substr( cBuffer,  48, 18))
	_cDescr    := alltrim(Substr( cBuffer,  66, 30))
	_nQuant	   := val(Substr( cBuffer,  100, 04)+ '.00')
	_cEditora  := Substr( cBuffer, 104, 30)
	_cCusto	   := Substr( cBuffer, 144, 05)
	_nCusto    := val(left(_cCusto,3) + '.' + right(_cCusto,2))
	_cDescr2   := alltrim(Substr( cBuffer, 159, 30))
	If !empty(_cDescr2)
		_cDescr += " - " +  _cDescr2

	EndIf
	
	_nCstTot := _nQuant * _nCusto
	
	DbSelectArea("SZH")
	If DbSeek(xFilial("SZH")+"1"+_cCota)
		cFilAnt := SZH->ZH_CODFIL
		_cForn := SZH->ZH_FORNEC
		_cLoja := SZH->ZH_LOJA
		_cCond := Posicione("SA2", 1, xFilial("SA2") + _cForn + _cLoja ,"A2_COND")
		
		If _nQuant <= 0
			aadd(_aProd,{cFilAnt, _cCota, _cForn, _cLoja,_cRef, _cEdicao, _cCodBarra, _cDescr, "Quantidade = 0 (zero)."} )
			ft_fskip()
			loop

		EndIf
		
		If _nCusto <= 0
			aadd(_aProd,{cFilAnt, _cCota, _cForn, _cLoja,_cRef, _cEdicao, _cCodBarra, _cDescr, "Custo unitario = 0 (zero)."} )
			ft_fskip()
			loop

		EndIf
		
		If ChkDados()
			CriaPed()

		EndIf
	else
		aadd(_aNaoPro, _cLinha)
		aadd(_aProd,{ ,_cCota,"Dinap " , , _cRef, _cEdicao, _cCodBarra, _cDescr, "COTA NAO CADASTRADA EM COTAxFILIAL"} )

	EndIf
	
	
	ft_fskip()
EndDo

If len(_aAuxIte) > 0
	GrvPed()

EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfChinag   บAutor  ณGiane               บ Data ณ  23/04/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLe arquivo Chinaglia e processa os dados                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fChinag()

Local cBuffer, _cDescr2, _n

Private _cEdicao, _cCodBarra, _cDescr
Private _nQuant, _cEditora, _nCusto, _nCstTot
Private _cProd 		:= ''
Private _cTipo,  _cRef
Private _cLinha, _cAssunto
Private _cItem 		:= ""
Private _aAuxIte 	:= {}

Conout("*** La Selva - Static Function FCHINAG - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

_aLinha := {}

_cCond := Posicione("SA2", 1, xFilial("SA2") + _cForn + _cLoja ,"A2_COND")
/*
REFERENCIA		NADA	DESCRICAO			NADA	   	NADA		EDICAO		NADA	ASSUNTO				QUANTIDADES	PRECO DE CUSTO	SOMA DO CUSTO	PRECO DE CAPA	NADA		CODIGO DE BARRA
485745			62869	AERO MAGAZINE					NORMAL		210			14		AVIAO/TRANSPORTE	350			7,6300			2.670,5000		10,9000			3.815,0000	977010462300900210
1				2		3					4			5			6			7		8					9			10				11				12				13			14
*/

ft_fgotop()
While !ft_feof()
	
	_cLinha := ft_freadln()
	
	_n := 1
	
	cBuffer := _cLinha
	While _n <= 14
		
		nPos := AT("|", cBuffer)	   //arquivo texto tem separador de campos "|"
		
		Do case
			case _n == 1
				//cod produto no fornecedor
				_cRef := left(cBuffer,nPos - 1)
			case _n == 3
				// descricao produto
				_cDescr := alltrim(left(cBuffer,nPos - 1))
			case _n == 6
				// edicao
				_cEdicao := alltrim(left(cBuffer,nPos - 1))

				_cEdicao := strzero(val(_cEdicao),iif(len(_cEdicao) == 6,6,4))


			case _n == 8
				//assunto
				_cAssunto := alltrim(left(cBuffer,nPos - 1))
			case _n == 9
				//quantidade
				_cQuant := left(cBuffer,nPos - 1)
				_cQuant := StrTran(_cQuant,".","")


				_nQuant := val(StrTran(_cQuant,",","."))



			case _n == 10
				// custo unitario
				_cCusto := left(cBuffer,nPos - 1)
				_cCusto := StrTran(_cCusto,".","")
				_nCusto := val(StrTran(_cCusto,",","."))
			case _n == 11
				// custo Total
				_cTot    := left(cBuffer,nPos - 1)
				_cTot    := StrTran(_cTot,".","")
				_nCstTot := val(StrTran(_cTot,",","."))
			case _n == 14
				//codigo de barras
				_cCodBarra := alltrim(left(cBuffer,len(cBuffer)))
		Endcase
		
		nTam := len(cBuffer) - nPos
		cBuffer := substr(cBuffer,nPos+1,nTam)
		_n ++
		
	Enddo
	
	If ChkDados()
		CriaPed()

	EndIf
	
	ft_fskip()
EndDo

If len(_aAuxIte) > 0
	GrvPed()

EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkDados  บAutor  ณGiane               บ Data ณ  23/04/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Checa produto e pedido de compra, se nใo existir cria      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ChkDados()

Local _aArea 	:= GetArea()
Local _lProd 	:= .f.
Local _lRet  	:= .f.
Local _cEdAux 	:= 0
Local _dDataAnt := ctod('')
Local _nTam   	:= len(_cCodBarra) - 4
//Local _cChave := left(_cCodBarra,_nTam)
Local _cChave 	:= left(_cCodBarra,13)
Local _nReg   	:= 0
Local _cBloq 	:= " "
Local _lExiste  := .F. // .T. caso EAN jแ esteja cadastrado   
Local _cCodBar  := ""

Conout("*** La Selva - Static Function CHKDADOS - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

If empty(_cCodBarra)
	//caso alguma linha do arquivo texto venha sem o codigo de barras
	aadd(_aProd,{cFilAnt,_cCota, _cForn, _cLoja,_cRef, _cEdicao, _cCodBarra, _cDescr, 'OBS: SEM COD.BARRAS NO ARQUIVO'} )
	Return _lRet

EndIf

If len(_cEdicao) > 4 .and. len(_cEdicao) <> 6
	//edi็ใo dIferente do padrใo
	aadd(_aProd,{cFilAnt,_cCota, _cForn, _cLoja,_cRef, _cEdicao, _cCodBarra, _cDescr, 'EDIวรO FORA DO PADRรO'} )
	Return _lRet

EndIf

//verificar se produto ja esta cadastrado, senao cadastrar com base na ultima edicao dele cadastrada.
DbSelectArea("SB1")
DbSetOrder(5)
If !SB1->(DbSeek(xFilial("SB1")+_cChave))
	aadd(_aNaoPro, _cLinha)
	If .not. empty( _cAssunto )
		aadd(_aProd,{cFilAnt,_cCota , _cForn, _cLoja,_cRef, _cEdicao, _cCodBarra, _cDescr, _cAssunto} )
	else
		aadd(_aProd,{cFilAnt,_cCota , _cForn, _cLoja,_cRef, _cEdicao, _cCodBarra, _cDescr, 'COD.BARRAS SEM EDIวีES CADASTRADAS' } )

	EndIf
	_cProd := ''
else
   cCodBar := Posicione("SB1",5,xFilial("SB1")+_cCodBarra,"B1_CODBAR")
   if !empty(cCodBar)
		lExiste := .T.
	endif
EndIf

Do While SB1->(!eof()) .and. SB1->B1_FILIAL == xFilial("SB1")
	
	If left(SB1->B1_CODBAR,13) != _cChave
		exit

	EndIf
	
	_cEdAux := right(alltrim(SB1->B1_COD),4)
	


	If _cEdAux == _cEdicao .OR. lExiste 
	//If _cEdAux == _cEdicao
		_lProd := .t.
		_cProd := SB1->B1_COD
		_cBloq := SB1->B1_MSBLQL
		exit
	Else
		
		If SB1->B1_DTCAD > _dDataAnt
			_cProd := SB1->B1_COD
			_dDataAnt := SB1->B1_DTCAD
			_cBloq := SB1->B1_MSBLQL


		EndIf
	EndIf
	
	SB1->(DbSkip())
Enddo

If !empty(_cProd)
	//Se nao achou o produto com a mesma edicao, cadastrar novo produto com a edicao
	If !_lProd
		
		//se a ultima edicao esta bloqueada, entao nao cadastra o produto, nem gera pedido
		If _cBloq == "1" //ultima edicao do produto bloqueado
			aadd(_aNaoPro, _cLinha)
			aadd(_aProd,{cFilAnt,_cCota , _cForn, _cLoja, _cRef, _cEdicao, _cCodBarra, _cDescr, "ULTIMA EDICAO DO PROD.BLOQUEADA."} )
			RestArea(_aArea)
			Return _lRet

		EndIf
		
		DbSelectArea("SB1")
		DbsetOrder(1)
		// consiste se o codigo do produto ja existe, mas com cod. de barras dIferente. Ir para a critica:
		//_cProdNew := left(_cProd,5) + _cEdicao
		_cProdNew := left(_cProd, len( alltrim( _cProd ) ) - 4 ) + _cEdicao
		If DbSeek(xFilial("SB1")+_cProdNew)
			aadd(_aNaoPro, _cLinha)
			aadd(_aProd,{cFilAnt,_cCota , _cForn, _cLoja,_cRef, _cEdicao, _cCodBarra, _cDescr, "PROD.CADASTRADO,COD.BARRA DIVERGENTE!"} )
			RestArea(_aArea)
			Return _lRet

		EndIf
		
		// colocar no array _aEstru os dados do produto da ultima edicao, para copiar no produto novo
		If DbSeek(xFilial("SB1")+_cProd)
			_aEstru := dbStruct()
			For _nx := 1 to len(_aEstru)
				_aEstru[_nx,4] := SB1->( FieldGet( FieldPos( _aEstru[_nx,1] ) ) )
			Next

		EndIf
		
		Reclock("SB1",.T.)
		SB1->B1_Filial := xFilial("SB1")
		
		For _ny := 1 to len(_aEstru)
			SB1->(FieldPut(FieldPos( _aEstru[_ny,1] ) , _aEstru[_ny,4]))
		Next
		
		SB1->B1_COD    := _cProdNew
		SB1->B1_EDICAO := _cEdicao
		If len(_cDescr) < 96
			_cDescr += " " + _cEdicao

		EndIf
		SB1->B1_DESC    := _cDescr
		SB1->B1_REFEREN := _cRef
		SB1->B1_CODBAR  := _cCodBarra
		SB1->B1_DTCAD   := dDatabase
		SB1->B1_UCOM    := CTOD('')
		SB1->B1_ENCALHE := (SB1->B1_DTCAD + SB1->B1_PERIODI)
		MsUnlock()
		
		
		//Procura edicao ant. na SBZ e grava registros iguais para todas as filiais que existir, com cod. edicao nova
		DbSelectARea("SBZ")
		DBSetOrder(2) //por cod produto
		If DbSeek(_cProd)
			_aEstru := dbStruct()
		else //em 02/10/09
			aadd(_aNaoPro, _cLinha)
			aadd(_aProd,{cFilAnt,_cCota , _cForn, _cLoja,_cRef, _cEdicao, _cCodBarra, _cDescr, "EDICAO ANTERIOR NAO POSSUI SBZ PARA COPIAR"} )
			RestArea(_aArea)
			Return _lRet

		EndIf
		_nx := 1
		Do While !eof() .and. SBZ->BZ_COD == _cProd
			
			For _nx := 1 to len(_aEstru)
				_aEstru[_nx,4] := SBZ->( FieldGet( FieldPos( _aEstru[_nx,1] ) ) )
			Next
			_nReg := SBZ->(RECNO())
			
			_ny := 1
			If !SBZ->(dbSeek(SB1->B1_COD + _aEstru[1,4] ))
				RecLock("SBZ",.T.)
				For _ny := 1 to len(_aEstru)
					SBZ->(FieldPut(FieldPos( _aEstru[_ny,1] ) , _aEstru[_ny,4]))
				Next
				SBZ->BZ_COD  := SB1->B1_COD
				SBZ->BZ_DESC := SB1->B1_DESC
				MsUnlock()
			else
				RecLock("SBZ",.f.)
				For _ny := 1 to len(_aEstru)

					If _ny > 2
						SBZ->(FieldPut(FieldPos( _aEstru[_ny,1] ) , _aEstru[_ny,4]))

					EndIf
				Next
				SBZ->BZ_DESC := SB1->B1_DESC
				MsUnlock()

			EndIf
			
			DbGoto(_nReg)
			
			DbSkip()
		Enddo
		
		//grava na tabela SZ7, para todas as filiais do sigamat
		DbSelectArea("SZ7")
		DbSetOrder(1)
		DbSelectARea("SM0")
		DbGotop()
		Do While !SM0->(eof())
			If !SZ7->(dbSeek(SM0->M0_CODFIL+SB1->B1_COD))
				RecLock("SZ7",.t.)
				SZ7->Z7_FILIAL  := SM0->M0_CODFIL
				SZ7->Z7_COD     := SB1->B1_COD
				SZ7->Z7_ENCALHE := SB1->B1_ENCALHE
				SZ7->Z7_DESC    := SB1->B1_DESC
				MsUnlock()
			else
				RecLock("SZ7",.f.)
				SZ7->Z7_ENCALHE := SB1->B1_ENCALHE
				SZ7->Z7_DESC    := SB1->B1_DESC
				MsUnlock()

			EndIf
			SM0->(DbSkip())
		Enddo
		
		_cProd := SB1->B1_COD

	EndIf
	
	//grava saldo zero na SB2, caso nao exista.
	//Fazer para todas as filiais em 02/10/09
	DbSelectARea("SM0")
	DbGotop()
	DbSelectArea("SB2")
	DbSetOrder(1)
	Do While !SM0->(eof())
		If !SB2->(DbSeek(SM0->M0_CODFIL+_cProd))
			RecLock("SB2",.t.)
			SB2->B2_FILIAL := SM0->M0_CODFIL
			SB2->B2_COD    := _cProd
			SB2->B2_LOCAL  := RetFldProd(_cProd,"B1_LOCPAD")
			MsUnlock()

		EndIf
		SM0->(DbSkip())
	Enddo
	
	If _cBloq == "1" //Produto bloqueado
		aadd(_aNaoPro, _cLinha)
		aadd(_aProd,{cFilAnt,_cCota , _cForn, _cLoja, _cRef, _cEdicao, _cCodBarra, _cDescr, "EDICAO DO PROD.BLOQUEADA."} )
		RestArea(_aArea)
		Return _lRet

	EndIf
	
	DbSelectArea("SC7")
	DbSetOrder(2)
	If !SC7->(DbSeek(xFilial("SC7")+_cProd + _cForn + _cLoja))
		_lRet := .t.
	Else
		If SC7->C7_EMISSAO < DATE()
			_lRet := .T.
		else
			aadd(_aProces, _cLinha)
		EndIf
	EndIf
EndIf

RestArea(_aArea)
Return _lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaPed   บAutor  ณGiane               บ Data ณ  23/04/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inclui novo pedido de compra com os dados do registro do   บฑฑ
ฑฑบ          ณ arquivo texto lido.                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CriaPed()

Local _aArea := GetArea()

Conout("*** La Selva - STATIC Function CRIAPED - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xfilial("SB1")+_cProd)

_cItem := strzero(val(_cItem)+1,len(SC7->C7_ITEM))

aadd(_aAuxIte, {{"C7_ITEM"   , _cItem 	 ,Nil},;
{"C7_PRODUTO", _cProd    ,Nil},;  //Codigo do Produto
{"C7_UM"     , SB1->B1_UM ,Nil},;
{"C7_QUANT"  , _nQuant	 ,Nil},;
{"C7_PRECO"  , _nCusto	 ,Nil},;
{"C7_TOTAL"  , _nCstTot	 ,Nil},;
{"C7_DATPRF" , dDataBase ,Nil},; //data
{"C7_TES"    , POSICIONE("SBZ",1,xFilial("SBZ")+_cProd,"BZ_TE_FORN"),Nil},; //codigo da TES
{"C7_LOCAL"  ,RetFldProd(SB1->B1_COD,"B1_LOCPAD")   ,Nil}} ) //armazem

aadd(_aLinha,_clinha)

RestArea(_aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvPed   บAutor  ณGiane               บ Data ณ  23/04/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inclui novo pedido de compra com os dados do registro do   บฑฑ
ฑฑบ          ณ arquivo texto lido.                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GrvPed()

Local _aArea 		:= GetArea()
Local _aCabec		:= {}

Private	lMSHelpAuto := .f.
Private	lMsErroAuto := .f.

Conout("*** La Selva - Static Function GRVPED - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+_aAuxIte[1,2,2])


_cNumPed := CriaVar("C7_NUM",.T.)
ConfirmSx8()
DbSelectArea('SC7')
Do While DbSeek(cFilAnt + _cNumPed)
	_cNumPed := CriaVar("C7_NUM",.T.)
	ConfirmSx8()
EndDo

_aCabec  :=  {{"C7_NUM"     , _cNumPed		      ,Nil},;
{"C7_FILIAL"  , cFilAnt             ,Nil},;
{"C7_TIPO"    , "1"       		  ,Nil},;
{"C7_FORNECE" , _cForn		 	  ,Nil},;
{"C7_LOJA"    , _cLoja    		  ,Nil},;
{"C7_CONTATO" , " "	              ,Nil},;
{"C7_FILENT"  , cFilAnt  	    	  ,Nil},;
{"C7_COND"    , iif(!empty(_cCond),_cCond,"075")  ,Nil},;
{"C7_EMISSAO" , dDataBase 		  ,Nil},;
{"C7_MOEDA"   , 1         		  ,Nil},;
{"C7_TXMOEDA" , 1         		  ,Nil}}



//Gravar o Pedido
Begin Transaction
MsExecAuto({ |x,y,z,w|  mata120(x,y,z,w)} ,1,_aCabec,_aAuxIte,3)

If lMsErroAuto
	_cNumPed := ""
	For _n := 1 to len(_aLinha)
		aadd(_aNaoPro, _aLinha[_n])
	Next
	
	MostraErro()




	DisarmTransaction()
Else
	
	For _x := 1 to len(_aAuxIte)
		aadd(_aItens, {cFilAnt, _cForn, _cLoja,	_aAuxIte[_x,2,2],_aAuxIte[_x,4,2] , _aAuxIte[_x,5,2],_cNumPed})
	Next
	
	For _n := 1 to len(_aLinha)
		aadd(_aProces, _aLinha[_n])
	Next
	





EndIf

End Transaction

RestArea(_aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_RELHQ02 บAutor  ณVinicius            บ Data ณ  24/04/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImprimir os pedidos de compras que foram gerados a partir   บฑฑ
ฑฑบ          ณdos dados do arquivo texto de Dinap ou Chinaglia            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function _RELHQ02()

Local cDesc1       		:= "Este programa tem como objetivo imprimir relatorio de pedidos "
Local cDesc2       		:= "gerados de acordo com o arquivo texto DINAP e Chinaglia"
Local cDesc3       		:= "Pedidos de Compras Automแtico"
Local cPict        		:= ""
Local titulo       		:= "PEDIDOS DE COMPRA GERADOS
Local nLin         		:= 80

Local Cabec1       		:= "Filial Fornec Loja                       Pedido  Produto                                           Qtdade  Custo Unit "
//"Fornecedor/Loja: "  + _cForn + space(02) + _cLoja + space(02)+ Posicione("SA2", 1, xFilial("SA2") + _cForn + _cLoja ,"A2_NREDUZ")
Local Cabec2       		:= ""
//         99   123456  99  12345678901234567890  0123456 123456789012345 123456789012345678901234567890  9,999.99  999,999.99
//        01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                  1          2         3         4         5         6         7         8        9         10        11
Local imprime        	:= .T.
Local aOrd           	:= {}
Private lEnd         	:= .F.
Private lAbortPrint  	:= .F.
Private CbTxt        	:= ""
Private limite       	:= 132 //80
Private tamanho      	:= "M"
Private nomeprog     	:= "LRELHQ02" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        	:= 18
Private aReturn      	:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     	:= 0
Private cbtxt        	:= Space(10)
Private cbcont       	:= 00
Private CONTFL       	:= 01
Private m_pag        	:= 01
Private wnrel        	:= "LRELHQ02" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString 		:= ""

Conout("*** La Selva - User Function _RELHQ02 - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
EndIf

ferase(__RelDir + wnrel + '.##r')
SetDefault(aReturn,cString)

If nLastKey == 27
	Return

EndIf

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  13/02/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem, _nx

Conout("*** La Selva - Static Function RUNREPORT - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

SetRegua(len(_aItens))

For _nx := 1 to len(_aItens)
	
	IncRegua()
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit

	EndIf
	
	If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
		_cLinUn := ""

	EndIf
	
	//If _cLinUn != _aItens[_nx,1] + _aItens[_nx,2] + _aItens[_nx,3] + _aItens[_nx,7]
	@ nLin,002 PSAY _aItens[_nx,1] //filial
	@ nLin,007 PSAY _aItens[_nx,2] //cod.fornecedor
	@ nLin,015 PSAY _aItens[_nx,3] //loja
	@ nLin,019 PSAY Posicione("SA2", 1, xFilial("SA2") +_aItens[_nx,2] + _aItens[_nx,3] ,"A2_NREDUZ")
	@ nLin,041 PSAY _aItens[_nx,7] //pedido
	_cLinUn := _aItens[_nx,1] + _aItens[_nx,2] + _aItens[_nx,3] + _aItens[_nx,7]

	//EndIf
	
	@ nLin,049 PSAY _aItens[_nx,4] //produto
	@ nLin,065 PSAY Left(Posicione("SB1", 1, xFilial("SB1") + _aItens[_nx,4] ,"B1_DESC"),30)
	@ nLin,097 PSAY Transform(_aItens[_nx,5],"@E 9,999.99")  //quantidade
	@ nLin,107 PSAY Transform(_aItens[_nx,6],"@E 999,999.99") //custo
	
	nLin := nLin + 1 // Avanca a linha de impressao
	
Next



If aReturn[5]==1


	OurSpool(wnrel)

EndIf

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_RelHQ03 บAutor  ณGiane               บ Data ณ  28/04/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImprimir os dados dos produtos que nao foram encontrados    บฑฑ
ฑฑบ          ณo codigo de barra no SB1 e portanto devem ser cadastrados   บฑฑ
ฑฑบ          ณprimeiro pelo usuario.                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function _RelHQ03()

Local cDesc1       		:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       		:= "com os produtos que devem ser cadastrados"
Local cDesc3       		:= "Produtos a serem Cadastrados"
Local cPict        		:= ""
Local titulo       		:= "PRODUTOS A SEREM CADASTRADOS / INCONSISTENCIAS "
Local nLin         		:= 80

Local Cabec1       		:= "Fil  Cota  Fornec  Loja  Referencia Edicao Cod.Barra            Descricao                                                    Assunto"
//"Fornecedor/Loja: "  + _cForn + space(02) + _cLoja + space(02)+ Posicione("SA2", 1, xFilial("SA2") + _cForn + _cLoja ,"A2_NREDUZ")
Local Cabec2       		:= ""
//        99  9999  123456   99   01234567   1234   12345678901234567890 123456789012345678901234567890123456789012345678901234567890 123456789012345678901234567890
//       0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                 1         2         3         4         5         6         7         8         9         10        11        12        13
Local imprime        	:= .T.
Local aOrd           	:= {}
Private lEnd         	:= .F.
Private lAbortPrint  	:= .F.
Private CbTxt        	:= ""
Private limite       	:= 220
Private tamanho      	:= "G"
Private nomeprog     	:= "RELHQ03" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        	:= 18
Private aReturn      	:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     	:= 0
Private cbtxt        	:= Space(10)
Private cbcont       	:= 00
Private CONTFL       	:= 01
Private m_pag        	:= 01
Private wnrel        	:= "RELHQ03" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString 		:= ""

Conout("*** La Selva - User Function _RELHQ03 - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return

EndIf

ferase(__RelDir + wnrel + '.##r')
SetDefault(aReturn,cString)

If nLastKey == 27
	Return

EndIf

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunRel03(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREL03  บ Autor ณ AP6 IDE            บ Data ณ  13/02/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunRel03(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

Conout("*** La Selva - Static Function RUNREL03 - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

SetRegua( len(_aProd))

For _nx := 1 to len(_aProd)
	
	IncRegua()
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit

	EndIf
	
	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8

	EndIf
	
	@ nLin,01 PSAY _aProd[_nx,1] //filial
	@ nLin,05 PSAY _aProd[_nx,2] //cota
	@ nLin,11 PSAY _aProd[_nx,3] //fornec
	@ nLin,20 PSAY _aProd[_nx,4] //loja
	@ nLin,25 PSAY _aProd[_nx,5] //referencia
	@ nLin,36 PSAY _aProd[_nx,6] //edicao
	@ nLin,43 PSAY _aProd[_nx,7] // cod barra
	@ nLin,64 PSAY Left(_aProd[_nx,8],60) //descricao
	@ nLin,125 PSAY _aProd[_nx,9] //assunto
	
	nLin := nLin + 1
	
Next



If aReturn[5]==1


	OurSpool(wnrel)


EndIf
MS_FLUSH()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMARKFILE  บAutor  ณ                    บ Data ณ  16/09/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTraz os arquivos do diretorio escolhido para usuario marcar บฑฑ
ฑฑบ          ณos que devem ser importados                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION MARKFILE(aArquivos,cDiretorio,cDriver,lSelecao)

Local aChaveArq 	:= {}
Local cTitulo 		:= "Arquivos para importa็ใo: "
Local bCondicao 	:= {|| .T.}
// Variแveis utilizadas na sele็ใo de categorias
Local oChkQual,lQual,oQual,cVarQ
// Carrega bitmaps
Local oOk 			:= LoadBitmap( GetResources(), "LBOK")
Local oNo 			:= LoadBitmap( GetResources(), "LBNO")
// Variแveis utilizadas para lista de filiais
Local nx 			:= 0
Local nAchou 		:= 0

Conout("*** La Selva - Static Function MARKFILE - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

For nX := 1 to Len(aArquivos)
	// aChaveArq - Contem os arquivos que serใo exibidos para sele็ใo
	cExt := right(aArquivos[nX][1],3)
	If upper(cExt) == right(cDriver,3)
		AADD(aChaveArq,{.F.,aArquivos[nX][1],cDiretorio})

	EndIf
Next nX

If len(aChaveArq) == 0
	AADD(aChaveArq,{.F.,"       ",cDiretorio})

EndIf
//+--------------------------------------------------------------------+
//| Monta tela para sele็ใo dos arquivos contidos no diret๓rio |
//+--------------------------------------------------------------------+
DEFINE MSDIALOG oDlg TITLE cTitulo STYLE DS_MODALFRAME From 145,0 To 445,628 OF oMainWnd PIXEL
oDlg:lEscClose := .F.
If cDriver == "*.LCT"
	@ 05,15 TO 125,300 LABEL "DINAP" OF oDlg PIXEL
else
	@ 05,15 TO 125,300 LABEL "CHINAGLIA" OF oDlg PIXEL

EndIf
@ 15,20 CHECKBOX oChkQual VAR lQual PROMPT "Marcar / Desmarcar" SIZE 60, 10 OF oDlg PIXEL;
ON CLICK (AEval(aChaveArq, {|z| z[1] := If(z[1]==.T.,.F.,.T.)}),oQual:Refresh(.F.))

@ 30,20 LISTBOX oQual VAR cVarQ Fields HEADER "","C๓digo","Descri็ใo" SIZE 273,090 ON DBLCLICK (aChaveArq:=Troca(oQual:nAt,aChaveArq),oQual:Refresh());
NoScroll OF oDlg PIXEL
oQual:SetArray(aChaveArq)
oQual:bLine := { || {If(aChaveArq[oQual:nAt,1],oOk,oNo),aChaveArq[oQual:nAt,2],aChaveArq[oQual:nAt,3]}}
DEFINE SBUTTON FROM 134,240 TYPE 1 ACTION iif(MarcaOk(aChaveArq),(lSelecao := .T., oDlg:End(),.T.),.F.) ENABLE OF oDlg
DEFINE SBUTTON FROM 134,270 TYPE 2 ACTION (lSelecao := .F., oDlg:End());
ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTERED
aArquivos := aChaveArq
RETURN lSelecao

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMarcaOK   บAutor  ณ                    บ Data ณ  16/09/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se algum arquivo foi marcado                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MarkFile                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION MarcaOk(aArray)

Local lRet	:= .F.
Local nx	:= 0

Conout("*** La Selva - Static Function MARCAOK - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

// Checa marca็๕es efetuadas
For nx:=1 To Len(aArray)
	If aArray[nx,1]
		lRet:=.T.
	EndIf
Next nx
// Checa se existe algum item marcado na confirma็ใo
If !lRet
	HELP("SELFILE",1,"HELP","SEL. FILE","Nใo existem itens marcados",1,0)
EndIf
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTroca     บAutor  ณ                    บ Data ณ  16/09/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณMarkFile                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION Troca(nIt,aArray)
Conout("*** La Selva - Static Function TROCA - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

aArray[nIt,1] := !aArray[nIt,1]
Return aArray
