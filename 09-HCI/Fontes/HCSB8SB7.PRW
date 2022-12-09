#INCLUDE "Protheus.ch" 
#INCLUDE "Rwmake.CH"
#INCLUDE "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออัออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ Programa    ณHCSB8SB7  ณ Entrada para AJUSTAR OS VALORES DOS ALMOXARIFADOS POR INV.   บฑฑ
ฑฑบ             ณ          ณ                                                              บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Solicitante ณ 20.04.07 ณ Robson                                                       บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Autor       ณ 20.04.07 ณ Robson Bueno                                                 บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Produ็ใo    ณ ??.??.?? ณ Ignorado                                                     บฑฑ
ฑฑฬอออออออออออออุออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Parโmetros  ณ Nil                                                                     บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno     ณ Nil                                                                     บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Observa็๕es ณ                                                                         บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Altera็๕es  ณ ??.??.?? - Nome - Descri็ใo                                             บฑฑ
ฑฑศอออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function HCSB8SB7()

  Local aAreaAtu	:= GetArea()												// Salva a area atual
  Local lRet		:= .T.
  LOCAL cDesComp :=Space(255)
  LOCAL cDe  :=Space(15)
  LOCAL cPara:=SPACE(15)
  Local oDlgL
  Local cTitulo :="Uniao de Almoxarifados"
  @ 000,000 To 180,400 Dialog Odlg1 Title OemToAnsi("Rotina para ajustar Almox")
  @ 003,008 To 85,200 Title OemToAnsi("Digite o Produto?")
 
  @ 015,015 Say OemToAnsi("Codigo De:")  OF Odlgl PIXEL
  @ 015,045 msget cDe  SIZE 60,10 F3 "SB1" OF OdlgL PIXEL
  @ 035,015 Say OemToAnsi("Codigo Ate:") OF Odlgl PIXEL
  @ 035,045 msget cPara  SIZE 60,10 F3 "SB1" OF OdlgL PIXEL
  @ 055,030 BMPBUTTON TYPE 1 ACTION 	Processa({|| OkProc(odlg1,cDe,cPara)},cTitulo,"Atualizando dados, aguarde...")
  @ 055,060 BMPBUTTON TYPE 2 ACTION Finaliza(odlg1)
  Activate Dialog Odlg1 CENTER
Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFinaliza  บAutor  ณRobson Bueno        บ Data ณ 18/04/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFinalizacao do Objeto                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณHCI                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function OkProc(odlg1,cDe, cPara)
Local nAlmox01
Local nAlmox15
Local nAlmox60
Local aLocais:={}
Local aAreaAtu	:= GetArea()												// Salva a area atual
Local lRet		:= .T.
Local cCodigo:=cDe
DbSelectArea("SB2")
dbSetOrder(1)
dbseek(xfilial("SB2")+cDe)
While ( !Eof())
    cCodigo:=SB2->B2_COD
    nAlmox01:=0 
    nAlmox15:=0
    nAlmox60:=0
    aLocais:={}
    If MsgYesNo("Deseja AJUSTAR produto -->" + cCodigo + " ","Rotinas Automแticas")
      WHILE (!EOF() .AND. cCodigo=SB2->B2_COD)
        aAdd(aLocais,SB2->B2_LOCAL)
        if SB2->B2_local='01' .or. SB2->B2_local='90' .or. SB2->B2_local='60' .OR. SB2->B2_local='1 '
          nAlmox01:=nAlmox01+SB2->B2_QATU
        endif
        if SB2->B2_local='14' .or. SB2->B2_local='15' .or. SB2->B2_local='16' .or. SB2->B2_local='17' .or. SB2->B2_local='18' .or. SB2->B2_local='19'
          nAlmox15:=nAlmox15+SB2->B2_QATU
        endif
        dbSkip()
      enddo 
      for a=1 to len(aLocais)
        DbSelectArea("SB7")
        dbSetOrder(1)
        RecLock("SB7",.T.)
        SB7->B7_FILIAL='01'
        SB7->B7_COD:=cCodigo
        SB7->B7_TIPO:='PA'
        SB7->B7_DOC:='AUT001'
        SB7->B7_DATA:=DATE()
        SB7->B7_DTVALID:=DATE()+365
        SB7->B7_MOTIVO:='AJ. SIST.'
        SB7->B7_STATUS:='1'
        SB7->B7_LOCAL:=aLocais[a]
        if aLocais[a]='01' .or. alocais[a]='90' .OR. aLocais[a]='60'   
          SB7->B7_QUANT:=nAlmox01
        endif
        if aLocais[a]='14' .or. alocais[a]='15' .or. alocais[a]='16' .or. alocais[a]='17'.or. alocais[a]='18'.or. alocais[a]='19'
          SB7->B7_QUANT:=nAlmox15
        endif
        if  alocais[a]!='01' .AND.  aLocais[a]!='15'   
          SB7->B7_QUANT:=0
        endif
        MSUNLOCK()
      next
    else
      return(.t.)
    endif
    DbSelectArea("SB2")
    DBSKIP()
EndDo												// Inicializa o retorno
RestArea(aAreaAtu)
Close(Odlg1)
Return(.T.)  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFinaliza  บAutor  ณRobson Bueno        บ Data ณ 18/04/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFinalizacao do Objeto                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณHCI                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Finaliza(Odlg1)

Close(Odlg1)

Return       
