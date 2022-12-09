#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ RFINR001   ³ Autor ³ Adriano Leonardo    ³ Data ³ 13/06/16 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório de fundo fixo em Excel.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RFINR001()

Private _cRotina	:= "RFINR001"
Private cPerg		:= _cRotina
Private _aSavArea	:= GetArea()
Private _cTitulo1	:= ""
Private _cTitulo2	:= ""
Private _cQuery		:= ""
Private _cAlias		:= GetNextAlias()
Private _lRet		:= .T.
Private _cEnt		:= CHR(13) + CHR(10)
Private _cFileTMP	:= ""
Private lEnd		:= .F.
Private _nTotProj	:= 0 
Private _nCustoProj	:= 0
Private _nTotHrsFt	:= 0

ValidPerg()

While !Pergunte(cPerg,.T.)
	If MsgYesNo("Deseja cancelar a emissão do relatório?",_cRotina+"_01")
		Return()
	EndIf
EndDo

//Verifica se o usuário tem permissão para emitir relatórios em Excel
If !(SubStr(cAcesso,160,1) == "S" .AND. SubStr(cAcesso,168,1) == "S" .AND. SubStr(cAcesso,170,1) == "S")
	MsgBox('Usuário sem permissão para gerar relatório em Excel. Informe o Administrador.',_cRotina +"_02",'STOP')
   Return(Nil)
EndIf

//Verifica se o Excel está instalado
If !ApOleClient('MsExcel') .And. __cUserId<>'000000'
	MsgBox('Excel não instalado.',_cRotina +"_03",'ALERT')
   Return(Nil)
EndIf

_cTitulo1 := ("Parâmetros")
_cTitulo2 := ("Fundo Fixo")

//Chamada da função para construir as planilhas
Processa({ |lEnd| Geraxls(@lEnd) },_cRotina," Gerando relatório em Excel...   Por favor aguarde.",.T.)

RestArea(_aSavArea)

Return()

Static Function Impressao()

_cQuery := "SELECT AUX.E5_DATA, SUM(SAIDAS) [SAIDAS], SUM(ENTRADAS) [ENTRADAS], E5_CTAINFO, (SELECT ISNULL(CT1_DESC01,'') FROM " + RetSqlName("CT1") + " CT1 WHERE D_E_L_E_T_='' AND CT1_FILIAL='" + xFilial("CT1") + "' AND CT1_CONTA=E5_CTAINFO) AS [DESCR] FROM ( "
_cQuery += "SELECT "
_cQuery += "E5_DATA, "
_cQuery += "ISNULL(ROUND((CASE WHEN E5_RECPAG='P' THEN E5_VALOR ELSE 0 END),2),0) AS [SAIDAS], "
_cQuery += "ISNULL(ROUND((CASE WHEN E5_RECPAG='R' THEN E5_VALOR ELSE 0 END),2),0) AS [ENTRADAS], "
_cQuery += "CASE WHEN (SELECT E1_CTAINFO FROM " + RetSqlName("SE1") + " SE1 WHERE SE1.D_E_L_E_T_='' AND SE1.E1_FILIAL='" + xFilial("SE1") + "' AND SE1.E1_NUM=SE5.E5_NUMERO AND SE1.E1_PREFIXO=SE5.E5_PREFIXO AND SE1.E1_PARCELA=SE5.E5_PARCELA AND SE1.E1_CLIENTE=SE5.E5_CLIENTE AND SE1.E1_LOJA=SE5.E5_LOJA)<>'' THEN (SELECT E1_CTAINFO FROM " + RetSqlName("SE1") + " SE1 WHERE SE1.D_E_L_E_T_='' AND SE1.E1_FILIAL='" + xFilial("SE1") + "' AND SE1.E1_NUM=SE5.E5_NUMERO AND SE1.E1_PREFIXO=SE5.E5_PREFIXO AND SE1.E1_PARCELA=SE5.E5_PARCELA AND SE1.E1_CLIENTE=SE5.E5_CLIENTE AND SE1.E1_LOJA=SE5.E5_LOJA) ELSE CASE WHEN (SELECT E2_CTAINFO FROM " + RetSqlName("SE2") + " SE2 WHERE SE2.D_E_L_E_T_='' AND SE2.E2_FILIAL='" + xFilial("SE2") + "' AND SE2.E2_NUM=SE5.E5_NUMERO AND SE2.E2_PREFIXO=SE5.E5_PREFIXO AND SE2.E2_PARCELA=SE5.E5_PARCELA AND SE2.E2_FORNECE=SE5.E5_FORNECE AND SE2.E2_LOJA=SE5.E5_LOJA)<>'' THEN (SELECT E2_CTAINFO FROM " + RetSqlName("SE2") + " SE2 WHERE SE2.D_E_L_E_T_='' AND SE2.E2_FILIAL='" + xFilial("SE2") + "' AND SE2.E2_NUM=SE5.E5_NUMERO AND SE2.E2_PREFIXO=SE5.E5_PREFIXO AND SE2.E2_PARCELA=SE5.E5_PARCELA AND SE2.E2_FORNECE=SE5.E5_FORNECE AND SE2.E2_LOJA=SE5.E5_LOJA) ELSE SE5.E5_CTAINFO END  END AS [E5_CTAINFO] "
_cQuery += "FROM " + RetSqlName("SE5") + " SE5 WHERE SE5.D_E_L_E_T_='' AND SE5.E5_FILIAL='" + xFilial("SE5") + "' AND SE5.E5_DTDISPO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
_cQuery += "AND E5_TIPODOC NOT IN ('DC','JR','MT','CP','CH') AND E5_SITUACA<>'C') AUX "
_cQuery += "GROUP BY AUX.E5_DATA, AUX.E5_CTAINFO "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.F.)

dbSelectArea(_cAlias)

While (_cAlias)->(!EOF())
	oExcel:AddRow(_cSheet2, _cTitulo2, {DTOC(STOD((_cAlias)->E5_DATA)),(_cAlias)->DESCR,(_cAlias)->SAIDAS,(_cAlias)->ENTRADAS,(_cAlias)->E5_CTAINFO})
	dbSelectArea(_cAlias)
	dbSkip()
EndDo

Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ RESTA004   ³ Autor ³ Adriano Leonardo    ³ Data ³ 16/05/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Função responsável pela inclusão dos parâmetros da rotina.  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³SIGAEST  							      	       			  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ValidPerg()

Local _sAlias	:= Alias()
Local i			:= 1
Local j			:= 1

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs :={}

AADD(aRegs,{cPerg,"01","De data?"	,"","","mv_ch1","D",08,0,0,"G",""			,"MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate data?"	,"","","mv_ch2","D",08,0,0,"G","NaoVazio()"	,"MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i := 1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Else
				exit
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_sAlias)

Return

Static Function Geraxls(lEnd)

Local _cFile		:= ""
Local _nPosPar		:= 1
Local _cFileTMP		:= ""
Private oExcel		:= FWMSEXCEL():New()
Private _cSheet1	:= _cTitulo1
Private _cSheet2	:= _cTitulo2
Private _aPar		:= {}

//Sheet1 - Parâmetros
oExcel:AddWorkSheet(_cSheet1)
oExcel:AddTable(_cSheet1,_cTitulo1)
oExcel:AddColumn(_cSheet1,_cTitulo1,"DESCRIÇÃO" ,1,1,.F.)
oExcel:AddColumn(_cSheet1,_cTitulo1,"CONTEÚDO"  ,1,4,.F.)

//Localizo os parâmetros da rotina com base na tabela SX1
dbSelectArea("SX1")
dbSetOrder(1)  //Grupo + Ordem    
dbGoTop()
cPerg := PADR(cPerg,10)
If SX1->(dbSeek(cPerg))
	While !EOF() .And. SX1->X1_GRUPO==cPerg
	IncProc('Processando parâmetros.')
		
		//Adiciono os parâmetros em array auxiliar
		If SX1->X1_GSC<>'C'
			AAdd(_aPar,{ SX1->X1_PERGUNT,&(SX1->X1_VAR01) })
		Else //Localizo a descrição do parâmetro (combobox) conforme seleção
			If &(SX1->X1_VAR01)==1
				AAdd(_aPar,{ SX1->X1_PERGUNT,SX1->X1_DEF01 })
			 ElseIf &(SX1->X1_VAR01)==2
				AAdd(_aPar,{ SX1->X1_PERGUNT,SX1->X1_DEF02 })
			 ElseIf &(SX1->X1_VAR01)==3
				AAdd(_aPar,{ SX1->X1_PERGUNT,SX1->X1_DEF03 })
			 ElseIf &(SX1->X1_VAR01)==4
				AAdd(_aPar,{ SX1->X1_PERGUNT,SX1->X1_DEF04 })					
			 ElseIf &(SX1->X1_VAR01)==5
				AAdd(_aPar,{ SX1->X1_PERGUNT,SX1->X1_DEF05 })
			 EndIf
		EndIf
		
		dbSelectArea("SX1")
		dbSetOrder(1)  //Grupo + Ordem
		dbSkip()
	EndDo
EndIf

//Adiciono as linhas no Excel com base no array de parâmetros da rotina
If Len(_aPar) > 0
	For _nPosPar := 1 To Len(_aPar)
		oExcel:AddRow(_cSheet1, _cTitulo1, _aPar[_nPosPar])
	Next
EndIf
     
//Sheet 2 - Fundo Fixo
oExcel:AddWorkSheet(_cSheet2)
oExcel:AddTable(_cSheet2,_cTitulo2)
                                   
oExcel:AddColumn(_cSheet2,_cTitulo2,"DATA"		,1,1,.F.)
oExcel:AddColumn(_cSheet2,_cTitulo2,"MOVIMENTO"	,1,1,.F.)
oExcel:AddColumn(_cSheet2,_cTitulo2,"SAÍDA"		,1,1,.F.)
oExcel:AddColumn(_cSheet2,_cTitulo2,"ENTRADA"	,1,1,.F.)
oExcel:AddColumn(_cSheet2,_cTitulo2,"C CONTÁBIL",1,1,.F.)

//Chamada da função responsável pela seleção dos dados
MsgRun("Selecionando dados " + _cSheet2 + "... Por favor AGUARDE. ",_cTitulo2,{ || Impressao()})

If lEnd
	Alert("Abortado!")
	FreeObj(oExcel)
	oExcel := NIL
	Return
EndIf

//Valida a emissão do relatório e imprime
If _lRet
	IncProc("Abrindo Arquivo...")
	oExcel:Activate()
	_cFile := (CriaTrab(NIL, .F.) + ".xml")
	While File(_cFile)
		_cFile := (CriaTrab(NIL, .F.) + ".xml")
	EndDo
	oExcel:GetXMLFile(_cFile)
	oExcel:DeActivate()
	If !(File(_cFile))
		_cFile := ""
		Break
	EndIf
	
	//_cFileTMP  := cGetFile('Arquivo Arquivo XML|*.xml','Salvar como',0,'C:\Dir\',.F.,GETF_LOCALHARD+GETF_NETWORKDRIVE,.F.) //Define o local onde o arquivo será gerado
		
	//Verifico se o formato do arquivo foi definido corretamente
	If !Empty(_cFileTMP)
		If !(".XML" $ Upper(_cFileTMP))
			_cFileTmp := StrTran(_cFileTmp,'.','')
			_cFileTmp += ".xml"
		EndIf
	Else
		_cFileTMP := (GetTempPath() + _cFile)
	EndIf
	
	If !(__CopyFile(_cFile , _cFileTMP))
		fErase( _cFile )
		_cFile := ""
		Break
	EndIf
	
	fErase(_cFile)
	_cFile := _cFileTMP
	If !(File(_cFile))
		_cFile := ""
		Break
	EndIf
	
	oMsExcel:= MsExcel():New()
	oMsExcel:WorkBooks:Open(_cFile)
	oMsExcel:SetVisible(.T.)
	IncProc('Relatório gerado com sucesso!')
	MsgBox('Relatório gerado, por favor verifique!',_cRotina+'_05','ALERT')
	oMsExcel:= oMsExcel:Destroy()
Else
	MsgBox("Não há dados a serem apresentados.",_cRotina+"_06",'ALERT')
EndIf

FreeObj(oExcel)
oExcel := NIL

Return()