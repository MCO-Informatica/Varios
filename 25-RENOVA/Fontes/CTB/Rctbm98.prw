#Include 'Rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RctbM98   �Autor  � Sergio Oliveira    � Data �  Jun/2009   ���
�������������������������������������������������������������������������͹��
���Descricao � Remover os caracteres que os validadores do Fisco nao per- ���
���          � mitem.                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Generico.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

User Function Rctbm98()

Local cMens   := "Elimina Caracteres Especiais - Versao SQL Server"
Local cPriLin := "Se deseja realmente efetuar esta opera��o, "
Private cPerg := "Rctbm98"
Private aRegs := {}

AADD(aRegs,{cPerg,"01","(CT2) Dt.Inicial...:","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","(CT2) Dt.Final.... :","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Informe Path p/ LOG:","","","mv_ch3","C",60,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","DIR","","","","",""})

U_ValidPerg( cPerg, aRegs )

If !Pergunte(cPerg,.t.)
    Return
EndIf

Private cTabela  := Space(03), cEol := Chr(13)+Chr(10)
Private cLog     := 'SPED-'+Dtos(Date())+'-'+StrTran(Time(),":","_")+'.log'
Private nCot     := FCreate( AllTrim(MV_PAR03)+cLog,1 )
Private cEol     := Chr(13)+Chr(10)
Private lAlterou := .f.
Private aListBox := { { .f.,"","",0,0,"" } }
Fclose( nCot )
nCot := Fopen( AllTrim(MV_PAR03)+cLog,2 )

If nCot < 0
   MsgBox('O Path especificado nao existe.','Erro no Arquivo','Info')
   Fclose( nCot )
   Return
EndIf

FWrite( nCot, FunName()+" - Line => "+Str(ProcLine())+cEol )

If !MsgBox('Deseja executar o acerto dos caracteres especiais?','Eliminacao de Caracteres Especiais','YesNo')
	FWrite( nCot, FunName()+" - Line => "+Str(ProcLine())+cEol )
	Fclose( nCot )
	Return
EndIf

Processa( { || Rctbm090() }, "Processando..." )

If lAlterou
	If Aviso("AJUSTE NAS TABELAS","Os campos foram obtidos. Deseja realmente executar o ajuste?",;
		{"&Confirma","ABANDONA"},3,"Alteracao",,;
		"PCOLOCK") == 2
		FWrite( nCot, FunName()+" - Line => "+Str(ProcLine())+cEol )
		Fclose( nCot )
		Return
	EndIf
	
	If !U_CodSegur(cMens, cPriLin)
		Aviso(cMens,"Opera��o nao Confirmada",{"&Fechar"},3,"Nao Confirmado",,"PCOLOCK")
		FWrite( nCot, FunName()+" - Line => "+Str(ProcLine())+cEol )
		Fclose( nCot )
		Return
	EndIf
	
	Processa( { || Rctbm98a() },'Processando...' )
	
EndIf

FWrite( nCot, FunName()+" - Line => "+Str(ProcLine())+cEol )
Fclose( nCot )
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �RctbM98a  �Autor  � Sergio Oliveira    � Data �  Jun/2009   ���
�������������������������������������������������������������������������͹��
���Descricao � Processamento da rotina.                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Rctbm98a()

Local cQry, cExec, nExec, nCntView
Local aInterv := { { 001,031 },{ 033,047 },{ 058,064 },{ 091,096 },{ 123,255 } } // SPED CTB
//Local aInterv := { { 060,060 },{ 062,062 },{ 038,038 },{ 034,034 },{ 039,039 } } // NFE
Local cWhere := ' ', cUpdate := ' '

ProcRegua( 32 )

For wV := 1 To Len( aInterv )
	
	For wXP := aInterv[wV][1] To aInterv[wV][2]
		
		IncProc( "Intervalo => "+AllTrim(Str( aInterv[wV][1] ))+" - "+AllTrim(Str( aInterv[wV][2] )))
		If wXP == 37
FWrite( nCot, FunName()+" - Line => "+AllTrim(Str(ProcLine()))+" - Ignorando o Caracter => "+AllTrim(Str( wXP ))+cEol )
		   Loop
		EndIf
		For w7 := 1 To Len( aListBox )
			
			If aListBox[w7][1]
			
				cQry := " SELECT COUNT(*) AS REGS "+cEol
				cQry += " FROM "+RetSqlName(cTabela)+cEol
				cQry += " WHERE "+cEol
				If cTabela == 'CT2'
					cQry += " CT2_DATA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' AND "+cEol
				EndIf
				
				cWhere  := ''
				cUpdate := ''
				If "ORACLE" $ TcGetDB()
				// INSTR ( F2_CHVNFE,CHR(32) ) > 0 
					cWhere  += IIF( !Empty( cWhere ),",","" )+" INSTR("+aListBox[w7][2]+",CHR("+Str( wXP )+") ) > 0 "+cEol
					cUpdate += IIF( !Empty( cUpdate ),",","" )+aListBox[w7][2]+" = REPLACE("+aListBox[w7][2]+", CHR("+Str( wXP )+") ,'') "+cEol
				Else
					cWhere  += IIF( !Empty( cWhere ),",","" )+aListBox[w7][2]+" LIKE '%' + CHAR("+Str( wXP )+") + '%' "+cEol
					cUpdate += IIF( !Empty( cUpdate ),",","" )+aListBox[w7][2]+" = REPLACE("+aListBox[w7][2]+", CHAR("+AllTrim(Str(wXP))+"),'') "+cEol
				EndIf
				
				cQry += cWhere
				
				FWrite( nCot, FunName()+" - Line => "+AllTrim(Str(ProcLine()))+" - Query da Faixa => "+AllTrim(Str( aInterv[wV][1] ))+" a "+AllTrim(Str( aInterv[wV][2] ))+" : "+cEol+cQry+cEol )
				
				nCntView := U_MontaView( cQry, "Work" )
				
				Work->( DbGoTop() )
				
				FWrite( nCot, FunName()+" - Line => "+AllTrim(Str(ProcLine()))+" - Resultado => "+AllTrim(Str(Work->REGS))+" registros retornados."+cEol )
				
				ProcRegua( nCntView )
				If Work->REGS > 0
					
					cExec := " UPDATE "+RetSqlName(cTabela)+cEol
					cExec += " SET "+cEol
					cExec += cUpdate
					If cTabela == 'CT2'
						cExec += " WHERE  CT2_DATA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "+cEol
					EndIf					
					
					nExec := TcSqlExec(cExec)
					FWrite( nCot, FunName()+" - Line => "+AllTrim(Str(ProcLine()))+" - Execucao do ajuste => "+cEol+cExec+cEol+" - Resultado => "+Str(nExec)+cEol )
					cExpErr := TcSqlError()
					If !Empty(cExpErr)
						FWrite( nCot, FunName()+" - Line => "+AllTrim(Str(ProcLine()))+" - Nouve Erro durante a Execucao do ajuste => "+cExpErr+cEol )
					EndIf
					
				EndIf
				
			EndIf
			
		Next
		
	Next
	
Next

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �RctbM980  �Autor  � Sergio Oliveira    � Data �  Jun/2009   ���
�������������������������������������������������������������������������͹��
���Descricao � Obter os campos de acordo com os parametros.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Rctbm090()

Private cAlias  := Space(03)
Private oDlg_, oListBox
Private _aStru  := {}, aCampos := {}, aEmps := {}
Private oOk     := Loadbitmap( GetResources(), 'LBOK')
Private oNo     := Loadbitmap( GetResources(), 'LBNO')

/*
Aadd( _aStru, {'X3_CAMPO'  ,'C', 10,0} )
Aadd( _aStru, {'X3_TIPO'   ,'C', 01,0} )
Aadd( _aStru, {'X3_TAMANHO','N', 03,0} )
Aadd( _aStru, {'X3_DECIMAL','N', 01,0} )
Aadd( _aStru, {'X3_TITULO' ,'C', 12,0} )
Aadd( _aStru, {'OK'        ,'C', 02,0} )

U_CriaTmp( _aStru, 'kWork' )

aCampos   := {}
Aadd( aCampos, {'OK'        ,'Ok'           ,'@!'   ,'02','0'} )
Aadd( aCampos, {'X3_CAMPO'  ,'Campo'        ,'@!'   ,10,'0'} )
Aadd( aCampos, {'X3_TIPO'   ,'Tipo'         ,'@!'   ,01,'0'} )
Aadd( aCampos, {'X3_TAMANHO','Tamanho'      ,'@!S30',03,'0'} )
Aadd( aCampos, {'X3_DECIMAL','Decimal'      ,'@!'   ,01,'0'} )
Aadd( aCampos, {'X3_TITULO' ,'Titulo'       ,'@!S30',12,'0'} )

kWork->( DbGoTop() )
*/

Define MsDialog oDlg_ Title "Ajuste nos Caracteres das Tabelas" From 213,027 to 635,802 of oMainWnd Pixel
//@ 213,027 To 635,684 Dialog oDlg_ Title  "Ajuste nos Caracteres das Tabelas"
@ 000,003 To 211,313
@ 066,009 To 207,251 Title  "Inform a Tabela"
//@ 060,255 To 150,308 Title  "Op��es"
//@ 076,016 To 201,246 Browse "kWork" Mark "OK" Fields aCampos Object oObj

@ 076,016 LISTBOX oListBox VAR cVar FIELDS HEADER	" ",;
"Campo "  ,;
"Tipo"    ,;
"Tamanho" ,;
"Decimal" ,;
"Titulo"  SIZE 284,127 PIXEL of oDlg_ ;
ON dblClick (aListBox:=DesTroca(oListBox:nAt,aListBox),oListBox:Refresh())
oListBox:SetArray(aListBox)
oListBox:bLine:={|| {If(aListBox[oListBox:nAt,1],oOk,oNo)  ,;
Transform(aListBox[oListBox:nAt,2],"@S30"),;
aListBox[oListBox:nAt,3],;
Transform(aListBox[oListBox:nAt,4],"@E 999"),;
Transform(aListBox[oListBox:nAt,5],"@E 9"),;
aListBox[oListBox:nAt,6] }}

@ 025,015 Say  "Tabela::"  Size 33,8
@ 024,065 Get cTabela  Size 40,10

@ 039,317 Button "_Marca Todos"     Size 45,16 Action( MarkAll() )
@ 061,317 Button "_Desmarca Todos"  Size 45,16 Action( DesmarkAll() )
@ 083,317 Button  "_Obt.Campo"      Size 45,16 Action( ProcSX6(cTabela) )
@ 105,317 Button  "_Verif.Ocorr."   Size 45,16 Action( oDlg_:End() )

Activate Dialog oDlg_ Centered

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ProcSX6   � Autor � Sergio Oliveira       � Data � Jun/2009���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Processar as alteracoes de conteudo.                       ���
�������������������������������������������������������������������������Ĵ��
���Uso       � AltSX6.prw                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ProcSX6(pcTabela, nOper)

Local nPrcRgua := 0

aListBox := {}

SX3->( DbSetOrder(1), DbSeek( cTabela ) )
While !SX3->( Eof() ) .And. SX3->X3_ARQUIVO == cTabela
	
	nPrcRgua ++
	
	SX3->( DbSkip() )
	
EndDo

lAlterou := .f.

ProcRegua( nPrcRgua )

SX3->( DbSetOrder(1), DbSeek( cTabela ) )
While !SX3->( Eof() ) .And. SX3->X3_ARQUIVO == cTabela
	
	IncProc()
	
	lAlterou := .t.
	
	Aadd( aListBox, { .f., SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_TITULO } )
	
	SX3->( DbSkip() )
	
EndDo

If !lAlterou
	Aviso("AJUSTE DA TABELA","Tabela Inexistente!",;
	{"&Fechar"},3,"Alteracao",,;
	"PCOLOCK")
	Aadd( aListBox, { .f.,"","",0,0,"" } )
EndIf

oListBox:SetArray(aListBox)
oListBox:bLine:={|| {If(aListBox[oListBox:nAt,1],oOk,oNo)  ,;
aListBox[oListBox:nAt,2],;
aListBox[oListBox:nAt,3],;
aListBox[oListBox:nAt,4],;
aListBox[oListBox:nAt,5],;
aListBox[oListBox:nAt,6] }}

oListBox:Refresh()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MarkAll  � Autor � Sergio Oliviera       � Data � Jun/2009 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Marcar todos os itens.                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function MarkAll()

For x:=1 To Len(aListBox)
	aListBox[x,1]	:= .T.
Next x

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �DesMarkAll� Autor � Sergio Oliviera       � Data � Jun/2009 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Desmarcar todos os itens.                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function DesMarkAll()

For x:=1 To Len(aListBox)
	aListBox[x,1]	:= .F.
Next x

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � Destroca � Autor � Sergio Oliviera       � Data � Jun/2009 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � No clique duplo marcar ou desmarcar o item desejado.       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function DesTroca(nIt,aVetor)

aVetor[nIt,1] := !aVetor[nIt,1]

Return(aVetor)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ValidPerg � Autor �                       � Data � 11/08/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica as perguntas inclu�ndo-as caso n�o existam        ���
�������������������������������������������������������������������������͹��
���Sintaxe   �             U_ValidPerg(cPerg, aMatriz)                    ���
���          �                                                            ���
���          �ExpC1: Nome do Grupo de Perguntas.                          ���
���          �ExpA1: Matriz contendo as perguntas.                        ���
�������������������������������������������������������������������������ͼ��
���Uso       � Generico.                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/

User Function ValidPerg(cPerg, aMatriz)

Local _sAlias := Alias()
Local _j      := 0
Local _i      := 0
Local _cPerg  := PadR(cPerg,Len(SX1->X1_GRUPO))      
//Local _cPerg  := cPerg
Local _aRegs  := aMatriz

DbSelectArea("SX1")
DbSetOrder(1)

For _i := 1 to Len(_aRegs)
	
	If !DbSeek( _cPerg + _aRegs[_i,2] )
		RecLock("SX1",.t.)
		For _j := 1 to FCount()
			FieldPut( _j, _aRegs[_i,_j] )
		Next
		MsUnlock()
	Endif
	
Next

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � CodSegur �Autor  � Sergio Oliveira    � Data �  Abr/2008   ���
�������������������������������������������������������������������������͹��
���Desc.     � Solicitar a digitacao do codigo de seguranca para confirmar���
���          � uma determinada operacao.                                  ���
�������������������������������������������������������������������������͹��
���Sintaxe   � U_CodSegur( ExpC1, ExpC2 ) , onde:                         ���
���          �                                                            ���
���          � 1. ExpC1: Titulo da caixa de mensagem;                     ���
���          � 2. ExpC2: Breve texto explicativo(51 posicoes)             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

User Function CodSegur(pcMens, pcPriLin)

Local cCodSeg  := Right( CriaTrab( Nil,.f. ),6 )
Local cConfSeg := Space(6)
Local cTxtMens := pcMens
Local oMens1
Local oFont    := TFont():New("Tahoma",8,,,.T.,,,,,.F.) // Com Negrito
Private _xlVai   := .f.

Define MsDialog _Mkw_Dlg_ Title "" From 173,165 To 380,565 Of oMainWnd Pixel
@ 000,001 To 104,194
@ 000,001 To 023,194
@ 057,010 To 099,134 Title "Confirme o Codigo de Seguran�a Abaixo:"
@ 020,141 To 104,194
@ 027,147 To 098,190 Title "Op��es"
@ 009,013 Say cTxtMens Color 8388608 Object oMens1 Size 174,8
@ 028,008 Say Left( pcPriLin, 51 ) Size 130,8
@ 035,008 Say "redigite no quadro abaixo o codigo de seguranca que" Size 130,8
@ 042,008 Say "esta sendo exibido ao lado:" Size 69,8
@ 044,082 Get cCodSeg  Picture "@!" Size 45,10 When .f.
@ 073,034 Get cConfSeg Picture "@!" Size 45,10
@ 044,150 Button "_Confirmar" Size 36,16 Action( CodSegurA(_Mkw_dlg_, cCodSeg, cConfSeg) )
@ 066,150 Button "_Abandonar" Size 36,16 Action( _Mkw_dlg_:End() )

oMens1:ofont:=ofont

Activate MsDialog _Mkw_dlg_ Centered

Return( _xlVai )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �CodSegurA �Autor  � Sergio Oliveira    � Data �  Abr/2008   ���
�������������������������������������������������������������������������͹��
���Desc.     � Validar se o codigo de seguranca foi digitado corretamente.���
�������������������������������������������������������������������������͹��
���Uso       � CodSegur()                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

Static Function CodSegurA( poDlg, pcCodSeg, pcConfSeg )

Local cTxtBlq := "Codigo de seguranca invalido. Verifique a sua digitacao."
Local cExec

If pcCodSeg # pcConfSeg
	Aviso("Codigo de Seguranca",cTxtBlq,{"&Fechar"},3,"Confirma��o Inv�lida",,"PCOLOCK")
Else
	If MsgBox('Codigo confirmado. Deseja prosseguir?','Confirmado','YesNo')
		_xlVai := .t.
	EndIf
	poDlg:End()
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �MontaWiew �Autor  �Sergio Oliveira     � Data �  Nov/2001   ���
�������������������������������������������������������������������������͹��
���Desc.     � Esta funcao cria a area de trabalho e faz a contagem de    ���
���          � registros.                                                 ���
�������������������������������������������������������������������������͹��
���Parametros�<ExpC1>    : Instrucao que sera montada a query.            ���
���          �<ExpC2>    : Alias para uso no programa da area de trabalho.���
�������������������������������������������������������������������������͹��
���Retorno   �<ExpN1> : Nro de Registros no arquivo de trabalho.          ���
�������������������������������������������������������������������������ͼ��
���Uso       � Generico.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

User Function MontaView( cSql, cAliasTRB )

Local nCnt := 0
Local cSql := ChangeQuery( cSql )

If Select(cAliasTRB) > 0           // Verificar se o Alias ja esta aberto.
	DbSelectArea(cAliasTRB)        // Se estiver, devera ser fechado.
	DbCloseArea(cAliasTRB)
EndIf

DbUseArea( .T., "TOPCONN", TcGenQry(,,cSql), cAliasTRB, .T., .F. )
DbSelectArea(cAliasTRB)
DbGoTop()

DbEval( {|| nCnt++ })              // Conta quantos sao os registros retornados pelo Select.

Return( nCnt )