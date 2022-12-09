#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CFATA02  ºAutor  ³ Anderson Zanni     º Data ³  13/08/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualização de DT.Devolucao - Notas Fiscais de Saida       º±±
±±º          ³ F2_XDTDEV                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico CertiSign                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION CFATA02()

PutSx1("CFAT02","01","Emissão De"               ,"Emissão De"               ,"Emissão De"                       ,"mv_ch1","D",08,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",;
      {"Emissão Inicial (Branco para todos)"},;
      {"Emissão Inicial (Branco para todos)"},;
      {"Emissão Inicial (Branco para todos)"},"","","","","","","")
PutSx1("CFAT02","02","Emissão Ate"              ,"Emissão Ate"              ,"Emissão Ate"                      ,"mv_ch2","D",08,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",;
      {"Emissão Final (ZZZZZZZZZZ para todos)"},;
      {"Emissão Final (ZZZZZZZZZZ para todos)"},;
      {"Emissão Final (ZZZZZZZZZZ para todos)"},"","","","","","","")
PutSx1("CFAT02","03","Serie De"               ,"Serie De"               ,"Serie De"                             ,"mv_ch3","C",03,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",;
      {"Série Inicial (Branco para todos)"},;
      {"Série Inicial (Branco para todos)"},;
      {"Série Inicial (Branco para todos)"},"","","","","","","")
PutSx1("CFAT02","04","Serie Ate"               ,"Serie Ate"               ,"Serie Ate"        ,"mv_ch4","C",03,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",;
      {"Série Final (ZZZZ para todos)"},;
      {"Série Final (ZZZZ para todos)"},;
      {"Série Final (ZZZZ para todos)"},"","","","","","","")
PutSx1("CFAT02","05","Doc. Fiscal De"               ,"Doc. Fiscal De"               ,"Doc. Fiscal De"           ,"mv_ch5","C",06,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","",;
      {"Doc. Fiscal Inicial (Branco para todos)"},;
      {"Doc. Fiscal Inicial (Branco para todos)"},;
      {"Doc. Fiscal Inicial (Branco para todos)"},"","","","","","","")
PutSx1("CFAT02","06","Doc. Fiscal Ate"               ,"Doc. Fiscal Ate"               ,"Doc. Fiscal Ate"        ,"mv_ch6","C",06,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","",;
      {"Doc. Fiscal Final (ZZZZ para todos)"},;
      {"Doc. Fiscal Final (ZZZZ para todos)"},;
      {"Doc. Fiscal Final (ZZZZ para todos)"},"","","","","","","")
PutSx1("CFAT02","07","Cliente De"               ,"Cliente De"               ,"Cliente De"                      ,"mv_ch7","C",06,0,0,"G","","SA1","","","mv_par07","","","","","","","","","","","","","","","","",;
      {"Cliente Inicial (Branco para todos)"},;
      {"Cliente Inicial (Branco para todos)"},;
      {"Cliente Inicial (Branco para todos)"},"","","","","","","SA1")
PutSx1("CFAT02","08","Loja De"               ,"Loja De"               ,"Loja De"                               ,"mv_ch8","C",02,0,0,"G","","","","","mv_par08","","","","","","","","","","","","","","","","",;
      {"Loja Inicial (ZZ para todos)"},;
      {"Loja Inicial (ZZ para todos)"},;
      {"Loja Inicial (ZZ para todos)"},"","","","","","","")
PutSx1("CFAT02","09","Cliente Ate"               ,"Cliente Ate"               ,"Cliente Ate"                      ,"mv_ch9","C",06,0,0,"G","","SA1","","","mv_par09","","","","","","","","","","","","","","","","",;
      {"Cliente Final (Branco para todos)"},;
      {"Cliente Final (Branco para todos)"},;
      {"Cliente Final (Branco para todos)"},"","","","","","","SA1")
PutSx1("CFAT02","10","Loja Ate"               ,"Loja Ate"               ,"Loja Ate"                               ,"mv_chA","C",02,0,0,"G","","","","","mv_par10","","","","","","","","","","","","","","","","",;
      {"Vendedor Final (ZZ para todos)"},;
      {"Vendedor Final (ZZ para todos)"},;
      {"Vendedor Final (ZZ para todos)"},"","","","","","","")
PutSx1("CFAT02","11","Data de Devolucao"               ,"Data de Devolucao"               ,"Data de Devolucao"                       ,"mv_chB","D",08,0,0,"G","","","","","mv_par11","","","","","","","","","","","","","","","","",;
      {"Data de Devolucao a ser considerada na gravação"},;
      {"Data de Devolucao a ser considerada na gravação"},;
      {"Data de Devolucao a ser considerada na gravação"},"","","","","","","")

If !Pergunte("CFAT02",.T.) 
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
_cFiltro += "Empty(F2_XDTDEV)"								           	
_cIndex	:= CriaTrab(nil,.f.)
_cChave	:= IndexKey()

IndRegua("SF2",_cIndex,_cChave,,_cFiltro,"Selecionando Registros...") 

cString   := "SF2"
cCadastro := "Alteração de Data de Devolução"
aRotina   := { { "Pesquisa"      ,'AxPesqui',0,1}, ;
					{ "Ajusta Data"  	,'Processa( {|| U_CFATA02Dt()} )',0,3}}
					

MarkBrow("SF2","F2_OK","F2_XDTDEV<>CtoD('')",,,@_cMarca,'U_FAT01MAll()',,,,'U_FAT01Mark()')

// Restaura Area SF2
SF2->(DbCloseArea())
DbSelectArea('SF2')         
FErase(_cIndex+'.CDX')
FErase(_cIndex+'.NDX')
Return(.T.)


/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\*/
User Function CFATA02Dt()
If !MsgYesNo('Os documentos selecionados terão o campo Data de Devolução atualizados com '+DtoC(mv_par11)+'.'+Chr(13)+Chr(10)+'Confirma o processamento?','Atualizar Registros')
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
      Replace F2_XDTDEV   With mv_par11
      MsUnlock()                      
   EndIf
      
   DbSkip()
EndDo

//Finaliza o processo
MsgBox('Foram atualizados '+Alltrim(Str(_nRegs))+' registros.','Processo finalizado')
Break                

Return .T.


