#INCLUDE 'TOTVS.CH'
#Include 'protheus.ch'
#INCLUDE 'RWMAKE.CH'
#Include "TbiConn.ch"

//Função para importar estrutura de planilha em formato csv
User function agria01()

Local lCont   := .t.
Local aRet    := {}
Local aPar    := {}
Local cArqTxt := space(90)
Local cYN     := "2"
Local cCodZero:= space(tamSx3("B1_COD")[1])
Local aItem   := {}

Local lJob	:= (Select('SX6')==0)   //se o ambiente protheus esta aberto ou não
Local aTables := {}

	if lJob
      aTables := {"SB1","SG1","SG5"}
		RpcClearEnv()
		RpcSetType( 3 )
		RpcSetEnv( '02','02',,,"PCP", , aTables)
      //PREPARE ENVIRONMENT EMPRESA "02" FILIAL "02" MODULO "PCP" TABLES "SB1","SG1","SG5"
      cArqTxt := "d:\Desenv\tmp\estrutura.csv"
   endif

   aAdd(aPar,{6,"Nome Arq.CSV:"  ,cArqTxt,"","","",90,.t.,"Todos os arquivos (*.CSV) |*.CSV"})
   aAdd(aPar,{2,"Altera Produto?",cYN,{"1=Sim","2=Não"}, 50, ".T.", .F.})
   aAdd(aPar,{9,"O Arq CSV deve conter nas colunas 1,2,3,4,5,6,7 e 8 os campos",190,6,.f.})
   aAdd(aPar,{9,"ITEM,DESCRICAO,CODIGO,ESTRUTURA,CANT.,UNIDADE,TIPO E NCM",190,6,.f.})
   aAdd(aPar,{9,"respectivamente !",100,6,.f.})
   While lCont
      if ParamBox(aPar,"Parâmetros...",@aRet)
         cArqTxt := aPar[1,3] := aRet[1]
         cYN     := aPar[2,3] := aRet[2]
         //if Empty(cArqTxt)
         //   Msgalert("Favor preencher o nome e local do arquivo CSV !","Atenção")
         //   Loop
         //endif
         lCont := .f.
      else
         return
      endif
   end

   Processa({|| aItem := agria01a(cArqTxt,cYN,@cCodZero) },"Lendo arquivo Texto de estruturas...", "Processando aguarde...", .F.)

   Processa({|| agria01b(cCodZero,aItem) },"Incluindo estrutura com "+alltrim(str(len(aItem)))+" itens...", "Processando aguarde...", .F.)

Return

Static function agria01a(cArqTxt,cYN,cCodZero)

Local nHdl    := 0
Local cLinha  := ""
Local nlinhas  := 0
Local cEol     := Chr(13)+Chr(10)
Local nBuffer  := 0                 // Define o tamanho da linha
Local cBuffer  := Space(1)          // Variavel para criacao da linha do registro para leitura
Local nTamFile := 0
Local nBtLidos := 0
Local nTBtLidos:= 0
Local nPosFile := 0

Local nI      := 0
Local nX      := 0
Local aCampos := {}
Local nDado   := 0
Local nNivel  := 0
Local nColIni := 0
Local nColFim := 0
Local lInc    := .t.

Local cItem   := space(10)
Local cDescr  := space(tamSx3("B1_DESC")[1])
Local cCodPro := space(tamSx3("B1_COD")[1])
Local cEstru  := space(15)
Local cQtd    := space(15)
Local cUni    := space(tamSx3("B1_UM")[1])
Local cTipo   := space(tamSx3("B1_TIPO")[1])
Local cNcm    := space(tamSx3("B1_POSIPI")[1])
Local nQtd    := 0

Local cDescr1 := space(tamSx3("B1_DESC")[1])
Local cCodPro1:= space(tamSx3("B1_COD")[1])
Local cEstru1 := space(15)
Local cQtd1   := space(15)
Local cUni1   := space(tamSx3("B1_UM")[1])
Local cTipo1  := space(tamSx3("B1_TIPO")[1])
Local cNcm1   := space(tamSx3("B1_POSIPI")[1])
Local nQtd1   := 0

Local cGrupo  := space(tamSx3("B1_GRUPO")[1])
Local cSbGru  := space(tamSx3("B1_XSGRP")[1])

Local aSb1    := {}
local cCodPai := ""
Local cPesq   := ""

Local aItem   := {}
Local nOpc    := 0
Local nVlCusto:= 0

Private lMsErroAuto := .f.

   aadd(aCampos,{1,'cItem'  ,len(cItem)  })
   aadd(aCampos,{2,'cDescr' ,len(cDescr) })
   aadd(aCampos,{3,'cCodPro',len(cCodPro)})
   aadd(aCampos,{4,'cEstru' ,len(cEstru) })
   aadd(aCampos,{5,'cQtd'   ,len(cQtd)   })
   aadd(aCampos,{6,'cUni'   ,len(cUni)   })
   aadd(aCampos,{7,'cTipo'  ,len(cTipo)  })
   aadd(aCampos,{8,'cNcm'   ,len(cNcm)   })

   aadd(aCampos,{10,'cDescr1' ,len(cDescr) })
   aadd(aCampos,{11,'cCodPro1',len(cCodPro)})
   aadd(aCampos,{12,'cEstru1' ,len(cEstru) })
   aadd(aCampos,{13,'cQtd1'   ,len(cQtd)   })
   aadd(aCampos,{14,'cUni1'   ,len(cUni)   })
   aadd(aCampos,{15,'cTipo1'  ,len(cTipo)  })
   aadd(aCampos,{16,'cNcm1'   ,len(cNcm)   })

   if !file(cArqTxt)
      Msgalert("Arquivo "+cArqTxt+" não encontrado!","Atenção")
      Return
   endif

   nHdl := fOpen(cArqTxt)                    //abrir o arquivo em modo compartilhado de leitura e escrita
   If nHdl == -1
      MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser aberto! ","Atenção")
      Return
   Endif
   nTamFile := fSeek(nHdl,0,2)   // tamanho total do arquivo

   syd->(DbSetOrder(1))
   sb1->(DbSetOrder(1))
   sg1->(DbSetOrder(1))

   nPos := nBuffer := 0
   while nPos == 0                               // SE CARACTER DE FINAL DE LINHA NAO FOR ENCONTRADO
      nPosFile := fSeek(nHdl,nPosFile,0)         // REPOSICIONA PONTEIRO DO ARQUIVO
      nBuffer  += 60                             // AUMENTA TAMANHO DO BUFFER
      cBuffer  := space(nBuffer)                 // REALOCA BUFFER
      nBtLidos := fRead(nHdl,@cBuffer,nBuffer)   // LE OS CARACTERES DO ARQUIVO
      nPos := at(cEol, cBuffer, 1)               // PROCURA O PRIMEIRO FINAL DE LINHA
   end

   ProcRegua(nTamFile/(nPos+1))

   While nTamFile > nTBtLidos

      IncProc()
      nPos := nBuffer := 0
      while nPos == 0                               // SE CARACTER DE FINAL DE LINHA NAO FOR ENCONTRADO
         nPosFile := fSeek(nHdl,nPosFile,0)         // REPOSICIONA PONTEIRO DO ARQUIVO
         nBuffer  += 60                             // AUMENTA TAMANHO DO BUFFER
         cBuffer  := space(nBuffer)                 // REALOCA BUFFER
         nBtLidos := fRead(nHdl,@cBuffer,nBuffer)   // LE OS CARACTERES DO ARQUIVO
         nPos := at(cEol, cBuffer, 1)               // PROCURA O PRIMEIRO FINAL DE LINHA
      end

      nPosFile := fSeek(nHdl,nPosFile,0)      // REPOSICIONA PONTEIRO DO ARQUIVO
      nPos += 1                               // ACERTO FIM DE LINHA
      cBuffer  := space(nPos)                 // REALOCA BUFFER
      nBtLidos := fRead(nHdl,@cBuffer,nPos)   // LE OS CARACTERES DO ARQUIVO

      cLinha := cBuffer
      if !empty(cLinha) .and. substr(cLinha,1,4) != "ITEM"
         nNivel := 0
         for nI := 1 to len(cLinha)
            if substr(cLinha,nI,1) == ";" .or. nI == 1
               nNivel += 1
               nDado := aScan(aCampos,{|x| x[1] == nNivel })
               if nDado > 0
                  nColIni := nI + iif(nI==1,0,1)
                  nColFim := at(";", cLinha, nColIni)
                  &(aCampos[nDado,2]) := replace(substr(cLinha,nColIni,nColFim-nColIni),',','.')
                  &(aCampos[nDado,2]) += space( aCampos[nDado,3] - len(&(aCampos[nDado,2])) )
                  &(aCampos[nDado,2]) := substr( &(aCampos[nDado,2]), 1, aCampos[nDado,3]  )
               endif
            endif
         next
         lMsErroAuto := .f.
         //Msgalert(cItem+cDescr+cCodPro+cUni+cTipo+cNcm)
         if alltrim(cItem) == "0" .and. sg1->(MsSeek(xFilial()+cCodPro))
            Msgalert("Estrutura já foi cadastrada (SG1)")
            aItem := {}
            break
         elseif !syd->(MsSeek(xFilial()+cNcm))
            Msgalert("Ncm "+cNcm+" do produto "+cCodPro+"-"+cDescr+" não existe !")
            aItem := {}
            break
         elseif !empty(cNcm1) .and. !syd->(MsSeek(xFilial()+cNcm1)) 
            Msgalert("Ncm "+cNcm1+" do produto "+cCodPro1+"-"+cDescr1+" não existe !")
            aItem := {}
            break
         else
            if !sb1->(MsSeek(xFilial()+cCodPro)) .or. cYN == "1"
               //Tramantos campos
               cGrupo := substr(cCodPro,1,2)
               //cGrupo := '10'  //somente em teste
               cSbGru := substr(cCodPro,3,3)
               cEstru := substr(cEstru ,1,1)
               if empty(cDescr)
                  Msgalert("Produto sem descrição na planilha: "+cCodPro)
                  aItem := {}
                  break
                  //cDescr := "PRODUTO DEM DESCRICAO"   //somente em teste desmarcar acima
               elseif substr(cDescr,1,1) == " "
                  cDescr := substr(cDescr,2,tamSx3("B1_DESC")[1])
               endif
               cDescr := FwCutOff(cDescr,.t.)
               if cCodPro == sb1->b1_cod
                  nOpc := 4  //Alteração
                  nVlCusto := sb1->b1_vlcusto
               else
                  nOpc := 3  //Inclusão
                  nVlCusto := 0.01
               endif
               aSb1  := { {"B1_COD"     ,cCodPro ,Nil},;
                          {"B1_DESC"    ,cDescr  ,Nil},;
                          {"B1_TIPO"    ,cTipo   ,Nil},; 
                          {"B1_UM"      ,cUni    ,Nil},; 
                          {"B1_LOCPAD"  ,"01"    ,Nil},; 
                          {"B1_GRUPO"   ,cGrupo  ,Nil},; 
                          {"B1_XSGRP"   ,cSbGru  ,Nil},; 
                          {"B1_POSIPI"  ,cNcm    ,Nil},;
                          {"B1_ORIGEM"  ,"0"     ,Nil},; 
                          {"B1_ESTRUT"  ,cEstru  ,Nil},;
                          {"B1_VLCUSTO" ,nVlCusto,Nil},;
                          {"B1_MSBLQL"  ,"2"     ,Nil} } 
               MSExecAuto({|x,y| Mata010(x,y)},aSb1,nOpc)
               if !lMsErroAuto
                  lInc := .t.
                  if sb5->(MsSeek(xFilial()+cCodPro))
                     lInc := .f.
                  endif
                  sb5->(RecLock("SB5",lInc))
                  sb5->b5_filial := sb5->(xfilial())
                  sb5->b5_cod    := cCodPro
                  sb5->b5_ceme   := cDescr
                  sb5->b5_umind  := "1"
                  sb5->(MsUnLock())
               endif
            endif
            if lMsErroAuto
               MostraErro()
               aItem := {}
               break
            elseif !empty(cDescr1) .and. !empty(cCodPro1) .and. ( !sb1->(MsSeek(xFilial()+cCodPro1)) .or. cYN == "1" )
               //Tramantos campos
               cGrupo1 := substr(cCodPro1,1,2)
               cSbGru1 := substr(cCodPro1,3,3)
               cEstru1 := substr(cEstru1 ,1,1)
               if empty(cDescr1)
                  Msgalert("Produto sem descrição na planilha: "+cCodPro1)
                  aItem := {}
                  break
               elseif substr(cDescr1,1,1) == " "
                  cDescr := substr(cDescr1,2,tamSx3("B1_DESC")[1])
               endif
               cDescr1 := FwCutOff(cDescr1,.t.)
               if cCodPro1 == sb1->b1_cod
                  nOpc := 4 //Alteração
                  nVlCusto := sb1->b1_vlcusto
               else
                  nOpc := 3 //Inclusão
                  nVlCusto := 0.01
               endif
               aSb1  := { {"B1_COD"     ,cCodPro1,Nil},;
                          {"B1_DESC"    ,cDescr1 ,Nil},;
                          {"B1_TIPO"    ,cTipo1  ,Nil},; 
                          {"B1_UM"      ,cUni1   ,Nil},; 
                          {"B1_LOCPAD"  ,"01"    ,Nil},; 
                          {"B1_GRUPO"   ,cGrupo1 ,Nil},; 
                          {"B1_XSGRP"   ,cSbGru1 ,Nil},; 
                          {"B1_POSIPI"  ,cNcm1   ,Nil},;
                          {"B1_ORIGEM"  ,"0"     ,Nil},; 
                          {"B1_ESTRUT"  ,cEstru1 ,Nil},;
                          {"B1_VLCUSTO" ,nVlCusto,Nil},;
                          {"B1_MSBLQL"  ,"2"     ,Nil} }
               MSExecAuto({|x,y| Mata010(x,y)},aSb1,nOpc)
               if !lMsErroAuto
                  lInc := .t.
                  if sb5->(MsSeek(xFilial()+cCodPro1))
                     lInc := .f.
                  endif
                  sb5->(RecLock("SB5",lInc))
                  sb5->b5_filial := sb5->(xfilial())
                  sb5->b5_cod    := cCodPro1
                  sb5->b5_ceme   := cDescr1
                  sb5->b5_umind  := "1"
                  sb5->(MsUnLock())
               endif
            endif
            if lMsErroAuto
               MostraErro()
               aItem := {}
               break
            else
               nNivel := 0
               for nI := 1 to len(cItem)
                 if substr(cItem,nI,1) == "."
                    nNivel += 1
                 endif
               next

               nQtd := val(cQtd)
               nQtd1 := val(cQtd1)

               if alltrim(cItem) == "0"
                  cCodZero := cCodPro
               else
                  cCodPai := ""
                  if nNivel == 0
                     cCodPai := cCodZero
                  else
                     cPesq := ""
                     nX := 0
                     for nI :=  1 to len(alltrim(cItem))
                       if substr(cItem,nI,1) == "."
                          ++nX
                       endif
                       if nNivel == nX .and. empty(cPesq)
                          cPesq := substr(cItem,1,nI-1)
                       endif
                     next
                     nI := aScan(aItem,{|x| alltrim(x[1]) == cPesq })
                     if nI == 0 
                        Msgalert("Erro na estrutura de níveis no arquivo CSV. Não encontrou o item "+cPesq+" de nível superior.")
                        aItem := {}
                        break
                     else
                        cCodPai := aItem[nI,3]
                     endif
                  endif
                  aadd(aItem ,{cItem,cCodPai,cCodPro,nQtd,cDescr,strzero(nNivel,2) } )
 
                  if !empty(cCodPro1)
                     //if aScan(aItem,{|x| x[2]+x[3] == cCodPro+cCodPro1 }) == 0
                        aadd(aItem ,{alltrim(cItem)+".1",cCodPro,cCodPro1,nQtd1,cDescr1,strzero(nNivel+1,2) } )
                     //endif
                  endif

               endif
            endif
         endif
      endif
      nPosFile += nPos
      nTBtLidos += nBtLidos

      nlinhas += 1
   End

   fClose(nHdl)

   //Msgalert(str(nlinhas) + " linhas processadas")
Return(aItem)

Static function agria01b(cCodZero,aItem)
   Local aItchk := {}
   Local aSg1   := {}
   Local aDados := {}
   Local nI     := 0
   Local cCodPai := ""
   Local cCodPro := ""
   Local cSeq    := ""
   Local cNivel  := ""
   Local nQtd    := 0
   Local nItem   := len(aItem)

   ProcRegua(nItem)
   //aSort(aItem,,,{ | x,y | x[6] < y[6] } )
   for nI := 1 to nItem

     IncProc()

     cCodPai := aItem[nI,2]
     cCodPro := aItem[nI,3]
     if aScan(aItchk,{|x| x[1]+x[2] == cCodPai+cCodPro }) == 0 .and. ;
        !sg1->(MsSeek(xFilial()+cCodPai+cCodPro))
        aadd(aItchk ,{cCodPai,cCodPro} )
        cSeq   := Space(3)
        //cNivel := aItem[nI,6]
        cNivel := Space(2)
        nQtd   := aItem[nI,4]
        aDados := {}
        aadd(aDados,{"G1_COD"   ,cCodPai           ,NIL})
        aadd(aDados,{"G1_COMP"  ,cCodPro           ,NIL})
        aadd(aDados,{"G1_TRT"   ,cSeq              ,NIL})
        aadd(aDados,{"G1_NIV"   ,cNivel            ,NIL})
        aadd(aDados,{"G1_QUANT" ,nQtd              ,NIL})
        aadd(aDados,{"G1_PERDA" ,0                 ,NIL})
        aadd(aDados,{"G1_INI"   ,dDataBase         ,NIL})
        aadd(aDados,{"G1_FIM"   ,CtoD("31/12/49")  ,NIL})
        aadd(aSg1,aDados)
     endif
   next

   if !empty(cCodZero) .and. len(aSg1) > 0
      if IncEstru(cCodZero,aSg1)
         Msgalert("Inclusão de Estrutura do produto com "+alltrim(str(nItem))+" iten(s) foi processada!")
      else
         Msgalert("Erro ao incluir Estrutura do produto. "+alltrim(str(nItem))+" iten(s) foram processadas, mas não incluidos.")
      endif
   else
      Msgalert("Problemas para a inclusão da Estrutura do produto, possivelmente na leitura da arquivo CSV.")
   endif
  
Return

Static Function IncEstru(cCodZero,aSg1)
   Local lRet := .t.
   Local aCabEst   := {}

   lMsErroAuto := .f.

   aCabEst := { {"G1_COD"  ,cCodZero,NIL},;
                {"G1_QUANT",1       ,NIL},;
                {"NIVALT"  ,"S"     ,NIL}} // A variavel NIVALT eh utilizada pra recalcular ou nao a estrutura

  //Sobre execauto mata200: https://tdn.totvs.com/display/public/PROT/Estruturas+-+MATA200
  MSExecAuto({|x,y,z| mata200(x,y,z)},aCabEst,aSg1,3)  //inclusão da estrutura
  if lMsErroAuto
     lRet := .f.
     MostraErro()
  endif

Return(lRet)
