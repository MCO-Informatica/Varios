#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CFATA01  ºAutor  ³ Anderson Zanni     º Data ³  10/07/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualização de DT.Entrega - Notas Fiscais de Saida         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7 - Específico CertiSign                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION CFATA01()

PutSx1("CFAT01","01","Emissão De"               ,"Emissão De"               ,"Emissão De"                       ,"mv_ch1","D",08,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",;
      {"Emissão Inicial (Branco para todos)"},;
      {"Emissão Inicial (Branco para todos)"},;
      {"Emissão Inicial (Branco para todos)"},"","","","","","","")
PutSx1("CFAT01","02","Emissão Ate"              ,"Emissão Ate"              ,"Emissão Ate"                      ,"mv_ch2","D",08,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",;
      {"Emissão Final (ZZZZZZZZZZ para todos)"},;
      {"Emissão Final (ZZZZZZZZZZ para todos)"},;
      {"Emissão Final (ZZZZZZZZZZ para todos)"},"","","","","","","")
PutSx1("CFAT01","03","Serie De"               ,"Serie De"               ,"Serie De"                             ,"mv_ch3","C",03,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",;
      {"Série Inicial (Branco para todos)"},;
      {"Série Inicial (Branco para todos)"},;
      {"Série Inicial (Branco para todos)"},"","","","","","","")
PutSx1("CFAT01","04","Serie Ate"               ,"Serie Ate"               ,"Serie Ate"        ,"mv_ch4","C",03,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",;
      {"Série Final (ZZZZ para todos)"},;
      {"Série Final (ZZZZ para todos)"},;
      {"Série Final (ZZZZ para todos)"},"","","","","","","")
PutSx1("CFAT01","05","Doc. Fiscal De"               ,"Doc. Fiscal De"               ,"Doc. Fiscal De"           ,"mv_ch5","C",06,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","",;
      {"Doc. Fiscal Inicial (Branco para todos)"},;
      {"Doc. Fiscal Inicial (Branco para todos)"},;
      {"Doc. Fiscal Inicial (Branco para todos)"},"","","","","","","")
PutSx1("CFAT01","06","Doc. Fiscal Ate"               ,"Doc. Fiscal Ate"               ,"Doc. Fiscal Ate"        ,"mv_ch6","C",06,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","",;
      {"Doc. Fiscal Final (ZZZZ para todos)"},;
      {"Doc. Fiscal Final (ZZZZ para todos)"},;
      {"Doc. Fiscal Final (ZZZZ para todos)"},"","","","","","","")
PutSx1("CFAT01","07","Cliente De"               ,"Cliente De"               ,"Cliente De"                      ,"mv_ch7","C",06,0,0,"G","","SA1","","","mv_par07","","","","","","","","","","","","","","","","",;
      {"Cliente Inicial (Branco para todos)"},;
      {"Cliente Inicial (Branco para todos)"},;
      {"Cliente Inicial (Branco para todos)"},"","","","","","","SA1")
PutSx1("CFAT01","08","Loja De"               ,"Loja De"               ,"Loja De"                               ,"mv_ch8","C",02,0,0,"G","","","","","mv_par08","","","","","","","","","","","","","","","","",;
      {"Loja Inicial (ZZ para todos)"},;
      {"Loja Inicial (ZZ para todos)"},;
      {"Loja Inicial (ZZ para todos)"},"","","","","","","")
PutSx1("CFAT01","09","Cliente Ate"               ,"Cliente Ate"               ,"Cliente Ate"                      ,"mv_ch9","C",06,0,0,"G","","SA1","","","mv_par09","","","","","","","","","","","","","","","","",;
      {"Cliente Final (Branco para todos)"},;
      {"Cliente Final (Branco para todos)"},;
      {"Cliente Final (Branco para todos)"},"","","","","","","SA1")
PutSx1("CFAT01","10","Loja Ate"               ,"Loja Ate"               ,"Loja Ate"                               ,"mv_chA","C",02,0,0,"G","","","","","mv_par10","","","","","","","","","","","","","","","","",;
      {"Vendedor Final (ZZ para todos)"},;
      {"Vendedor Final (ZZ para todos)"},;
      {"Vendedor Final (ZZ para todos)"},"","","","","","","")
PutSx1("CFAT01","11","Data de Envio"               ,"Data de Envio"               ,"Data de Envio"                       ,"mv_chB","D",08,0,0,"G","","","","","mv_par11","","","","","","","","","","","","","","","","",;
      {"Data de Envio a ser considerada na gravação"},;
      {"Data de Envio a ser considerada na gravação"},;
      {"Data de Envio a ser considerada na gravação"},"","","","","","","")

If !Pergunte("CFAT01",.T.) 
   Return
EndIf

DbSelectArea('SF2')    
Private _cMarca  := GetMark(,'SF2','F2_OK')
Private _lMarca  := .F.
_cFiltro := "F2_EMISSAO >= mv_par01 .And. F2_EMISSAO <= mv_par02 .And."  
_cFiltro += "F2_SERIE   >= mv_par03 .And. F2_SERIE   <= mv_par04 .And."  
_cFiltro += "F2_DOC     >= mv_par05 .And. F2_DOC     <= mv_par06 .And."  
_cFiltro += "F2_CLIENTE >= mv_par07 .And. F2_CLIENTE <= mv_par09 .And."  
_cFiltro += "F2_LOJA    >= mv_par08 .And. F2_LOJA    <= mv_par10 .And."  
_cFiltro += "(Empty(F2_DTENTR) .or. Empty(F2_XDTENV2))"								           	
_cIndex	:= CriaTrab(nil,.f.)
_cChave	:= IndexKey()

IndRegua("SF2",_cIndex,_cChave,,_cFiltro,"Selecionando Registros...") 

cString   := "SF2"
cCadastro := "Alteração de Data de Entrega"
aRotina   := { { "Pesquisa"      ,'AxPesqui',0,1}, ;
					{ "Ajusta Data"  	,'Processa( {|| U_CFATA01Dt()} )',0,3}}
					

// MarkBrow("SF2","F2_OK","F2_DTENTR<>CtoD('')",,,@_cMarca,'U_FAT01MAll()',,,,'U_FAT01Mark()')
MarkBrow("SF2","F2_OK","F2_XDTENV2<>CtoD('')",,,@_cMarca,'U_FAT01MAll()',,,,'U_FAT01Mark()')

// Restaura Area SF2
SF2->(DbCloseArea())
DbSelectArea('SF2')         
FErase(_cIndex+'.CDX')
FErase(_cIndex+'.NDX')
Return(.T.)


/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\*/
User Function CFATA01Dt()
If !MsgYesNo('Os documentos selecionados terão o campo Data de Envio atualizados com '+DtoC(mv_par11)+'.'+Chr(13)+Chr(10)+'Confirma o processamento?','Atualizar Registros')
   Return 
EndIf

ProcRegua(RecCount())
DbSelectArea('SF2')
DbGoTop()
_nRegs := 0
Do While !EoF()                 
   IncProc()
   If IsMark("F2_OK", _cMarca)
      _nRegs++
      RecLock('SF2',.F.)               
      If Empty(F2_DTENTR)
         Replace F2_DTENTR   With mv_par11
      Else
         Replace F2_XDTENV2   With mv_par11
      EndIf   
      MsUnlock()                      
   EndIf
      
   DbSkip()
EndDo

//Finaliza o processo
MsgBox('Foram atualizados '+Alltrim(Str(_nRegs))+' registros.','Processo finalizado')
Break                

Return .T.

/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\*/
User Function FAT01Mark
dbSelectArea("SF2")
RecLock("SF2", .F.)
Replace F2_OK With Iif(IsMark("F2_OK", _cMarca), Space(4), _cMarca)
MsUnLock()

Return Nil
                                                        

/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\*/
User Function FAT01MAll
Local nRecno := Recno()

dbSelectarea("SF2")
dbGoTop()

While !Eof()
   RecLock("SF2", .F.)
   Replace F2_OK With Iif(_lMarca, Space(4), _cMarca)
   MsUnLock()
	dbSkip()
EndDo
_lMarca := !_lMarca
dbGoTo(nRecno)
Return Nil
