#INCLUDE "rwmake.ch"


User Function HCSER001()                                      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private _cString   := "SA1"
Private _cPerg     := "SERASA"
Private _oGeraTxt  
Private _cPath     := '', _cFile  := ''
Private _cEOL      := "CHR(13)+CHR(10)"
Private _nTotCli   := 0 
Private _nTotcRec  := 0
PRIVATE aCNPJ:={} 
PRIVATE lPode:=.T.
Pergunte(_cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,1 TO 380,450 DIALOG _oGeraTxt TITLE OemToAnsi("Geracao Arquivo Exportacao SERASA/15 ")
@ 02,10 TO 060,215
@ 10,018 Say " Este programa ira gerar um arquivo texto com   informações de clientes para o " SIZE 196,0
@ 18,018 Say " SERASA e serão utilizados para informações comerciais.                        " SIZE 196,0

@ 70,128 BMPBUTTON TYPE 05 ACTION Pergunte(_cPerg,.T.)
@ 70,158 BMPBUTTON TYPE 01 ACTION Processa( {|| OkGeraTrb() }) 
@ 70,188 BMPBUTTON TYPE 02 ACTION Close(_oGeraTxt)

Activate Dialog _oGeraTxt Centered

Return
//-------------------------------------
Static Function OkGeraTrb

_cPath     := ""
_cFile     := _cPath + alltrim(mv_par04)
_cDataIni  := MV_PAR01
_cTipoMov  :=''
_nTotcRec  := 0
_cDataFim  := MV_PAR02
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o arquivo texto                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private _nHdl    := fCreate(_cFile + "")

_cEOL := CHR(13)+CHR(10)

If _nHdl == -1
	MsgAlert("O arquivo "+_cFile+""+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
Endif
//
Do case 
   case mv_par10 ==1 
       _cTipoMov := 'D'
   case mv_par10 ==2   
       _cTipoMov := 'S' 
   case mv_par10 ==3    
       _cTipoMov := 'Q'
   case mv_par10 ==4    
       _cTipoMov := 'M'   
Endcase
//
dbSelectArea('SA1')
DbSetOrder(1)
DbSeek(xFilial('SA1'))
ProcRegua( lastrec() )
//
// O bloco Abaixo tem como objetivo montar o arquivo com os dados do cliente
// A primeira parte gravará o cabecalho do arquivo 

// ------DADOS DE HEADER----- 
IF MV_PAR05=1
  _cLin := '00RELATO COMP NEGOCIOS62312426000138'+ dtos( _cDataIni ) + dtos( _cDataFim ) + _cTipoMov + space(15) + '   ' + space(29) + 'V.01' +_cEOL
ELSE
  _cLin := '00RELATO COMP NEGOCIOS62312426000138CONCILIA' + dtos( _cDataFim ) + _cTipoMov + space(15) + '   ' + space(29) + 'V.01' +_cEOL
ENDIF
//
If fWrite(_nHdl,_cLin,Len(_cLin)) != Len(_cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		Return
	Endif
Endif
// ------DETALHE - TEMPO DE RELACIONAMENTO
ntotReg := 0 
While !eof()
  lPode:=.T.
  IF DTOS(A1_PRICOM)="        "  .OR. A1_CGC="00000000000000"  .OR. A1_CGC="62312426000138" .OR. A1_CGC="62312426000219" .OR. A1_CGC="62312426000480" .OR. A1_PESSOA="F" .OR. A1_EST="EX" .OR. A1_MSBLQL="1"
    IncProc(OemToAnsi("L.Cliente " + A1_COD + ' - ' + Alltrim(A1_NREDUZ) ))  
    DbSkip()
    Loop
  ELSE
    IncProc(OemToAnsi("L.Cliente " + A1_COD + ' - ' + Alltrim(A1_NREDUZ) ))  
  ENDIF
  for x=1 to len(aCNPJ)
    if A1_CGC=aCNPJ[x] 
      lPode:=.f.
      x:=len(aCNPJ)
    endif
  next
  if lPode=.f.
    DbSkip()
    Loop
  endif
  aadd(aCNPJ,A1_CGC)    
  IF A1_PRICOM>DDATABASE
    _cLin := '01'+ A1_CGC + '01' + DTOS(DDATABASE)
  ELSE  
    _cLin := '01'+ A1_CGC + '01' + DTOS(A1_PRICOM)
  ENDIF
  //
  IF  DDATABASE  - A1_PRICOM  >= 365
    _cLin += '1'
  Elseif alltrim( dtos( A1_PRICOM ) ) <> '' .and. DDATABASE  - A1_PRICOM  < 365 
    _cLin += '2'    
  Elseif alltrim( dtos( A1_PRICOM ) ) == ''
    _cLin += '3'        
  Endif  
  //
  _cLin += space(73) + _cEOL
  //
  If fWrite(_nHdl,_cLin,Len(_cLin)) != Len(_cLin)
   	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
   		Return
   	Endif
  Endif
  // --------DETALHE TITULOS

  DbSelectArea('SE1')
  DbSetOrder(2)
  if DbSeek(xFilial('SE1') + sa1->a1_cod + sa1->a1_loja )
     While ! eof() .and. se1->e1_cliente == sa1->a1_cod .and. se1->e1_loja == sa1->a1_loja 
         //
         IF empty( se1->e1_baixa) 
           if E1_EMISSAO > MV_PAR02  .or.  E1_EMISSAO < MV_PAR01
             DbSkip()
             Loop
           Endif 
         ELSE
           if (E1_BAIXA > MV_PAR02  .or.  E1_BAIXA < MV_PAR01) .AND. (E1_EMISSAO > MV_PAR02  .or.  E1_EMISSAO < MV_PAR01)
             DbSkip()
             Loop
           ENDIF
         ENDIF
         IF E1_TIPO<>"NF "
            DbSkip()
            Loop
         ENDIF   
         //
         IF MV_PAR05<>2
           IF se1->e1_parcela=" "
             _cLin  := '01' + sa1->a1_cgc + '05'+ padr( se1->e1_num + ' ' + se1->e1_parcela, 10 ) + dtos(se1->e1_emissao) + StrTran(StrZero(se1->e1_valor,14,2),".","")        
           ELSE
             _cLin  := '01' + sa1->a1_cgc + '05'+ padr( se1->e1_num + '/' + se1->e1_parcela, 10 ) + dtos(se1->e1_emissao) + StrTran(StrZero(se1->e1_valor,14,2),".","")        
           ENDIF
           IF !empty( se1->e1_baixa )
             IF E1_BAIXA > MV_PAR02  .or.  E1_BAIXA < MV_PAR01
               _cLin  += dtos( se1->e1_vencto ) +  space(8) 
             ELSE
               _cLin  += dtos( se1->e1_vencto ) + if(!empty( se1->e1_baixa ), dtos(se1->e1_baixa), space(8) )
             ENDIF
           ELSE
              _cLin  += dtos( se1->e1_vencto ) +  space(8) 
           ENDIF     
           _cLin  += space(35) + _cEOL
  	  	    	If fWrite(_nHdl,_cLin,Len(_cLin)) != Len(_cLin)
   	    		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
   	    			Return
   	    		Endif
  	    		Endif
         
           //
           _nTotcRec ++
         else
           if se1->e1_valor+SE1->E1_ACRESC-SE1->E1_DECRESC<>se1->e1_valor .or. se1->e1_vencrea<>se1->e1_vencto 
             IF se1->e1_parcela=" "
               _cLin  := '01' + sa1->a1_cgc + '05'+ padr( se1->e1_num + ' ' + se1->e1_parcela, 10 ) + dtos(se1->e1_emissao) + StrTran(StrZero(se1->e1_valor+SE1->E1_ACRESC-SE1->E1_DECRESC,14,2),".","")        
             ELSE
               _cLin  := '01' + sa1->a1_cgc + '05'+ padr( se1->e1_num + '/' + se1->e1_parcela, 10 ) + dtos(se1->e1_emissao) + StrTran(StrZero(se1->e1_valor+SE1->E1_ACRESC-SE1->E1_DECRESC,14,2),".","")        
             ENDIF
             IF !empty( se1->e1_baixa )
               IF E1_BAIXA > MV_PAR02  .or.  E1_BAIXA < MV_PAR01
                 _cLin  += dtos( se1->e1_vencto ) +  space(8) 
               ELSE
                 _cLin  += dtos( se1->e1_vencto ) + if(!empty( se1->e1_baixa ), dtos(se1->e1_baixa), space(8) )
               ENDIF
             ELSE
                _cLin  += dtos( se1->e1_vencto ) +  space(8) 
             ENDIF     
             _cLin  += space(35) + _cEOL
  	  	    	If fWrite(_nHdl,_cLin,Len(_cLin)) != Len(_cLin)
   	    		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
   	    			Return
   	    		Endif
  	    		Endif
         
             //
             _nTotcRec ++
           endif
         endif
         DbSkip()
     Enddo
  Endif 
  // ----------- TRAILLER 
  DbSelectArea('SA1')
  
  //  
  DbSkip()      
  ntotReg ++
  // 
Enddo
//
 _cLin  := '99'+ strzero( ntotReg , 11 ) + space(44) + strzero( _nTotcRec, 11 )  + space(32) + _ceol
 If fWrite(_nHdl,_cLin,Len(_cLin)) != Len(_cLin)
    If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
  	  Return
    Endif
 Endif
//
fClose(_nHdl)
//
Return