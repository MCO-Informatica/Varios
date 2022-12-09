#Include 'protheus.ch'
#Include "topconn.ch"

//Função para Baixa de títulos de um arquivo, sem contabilização (MOTIVO BNC)
User function csfin32(cArqTxt,cHistBx)

Local lJob 	  := ( Select( "SX6" ) == 0 )
Local lBlind  := IsBlind()
Local lCont   := .t.
Local aRet      := {}
Local aPar    := {}
Local cJobEmp := '01'
Local cJobFil := '02'
Local cJobMod := 'FIN'

	If lJob
      RpcClearEnv()
		RpcSetType( 3 )
		RpcSetEnv( cJobEmp, cJobFil, , , cJobMod )
   endif

   Default cArqTxt := space(100)
   Default cHistBx := space(tamSx3("E5_HISTOR")[1])

   //cArqTxt := "c:\temp\PRSIS5863teste.csv"
   //cHistBx := "Inconsistência na programação - SIS-5863"

   //cArqTxt := "c:\temp\RCPSIS5816teste.csv"
   //cArqTxt := "c:\temp\NFSIS5816teste.csv"
   //cHistBx := "Inconsistência na programação - SIS-5816"

   if !lBlind
      //aAdd(aPar,{1,"Arquivo CSV:",cArqTxt,"","","",".T.",0,.T.})
      aAdd(aPar,{6,"Arquivo CSV:",cArqTxt,"","","",len(cArqTxt),.t.,"Arquivos (*.CSV) |*.CSV"})
      aAdd(aPar,{1,"Historico Baixa:" ,cHistBx,"","" ,"",".T.",0,.T.})
      aAdd(aPar,{9,"O Arq CSV deve conter nas colunas 4,5,6,7, os campos",200,7,.T.})
      aAdd(aPar,{9,"prefixo,número,parcela e tipo respectivamente !",200,7,.T.})
      While lCont
        if ParamBox(aPar,"Parâmetros...",@aRet)
           cArqTxt := aPar[1,3] := aRet[1]
           cHistBx := aPar[2,3] := aRet[2]
           if Empty(cArqTxt)
              Msgalert("Favor preencher o nome e local do arquivo CSV !","Atenção")
              Loop
           endif
           if Empty(cHistBx)
              Msgalert("Favor preencher o Histórico da baixa !","Atenção")
              Loop
           endif
           lCont := .f.
        else
           return
        endif
      end
	EndIf

   Processa({|| ( csfin32a(cArqTxt,cHistBx) ) },"Lendo arquivo Texto e baixando títulos...", "Processando aguarde...", .F.)

Return

Static function csfin32a(cArqTxt,cHistBx)

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
Local aCampos := {}
Local nDado   := 0
Local nOrdem  := 0
Local nColIni := 0
Local nColFim := 0

Local cPrefixo := space(tamSx3("E1_PREFIXO")[1])
Local cNum     := space(tamSx3("E1_NUM")[1])
Local cParcela := space(tamSx3("E1_PARCELA")[1])
Local cTipo    := space(tamSx3("E1_TIPO")[1])

Local nRecSe1  := 0
Local cBco 		:= ' '
Local cAge 		:= ' '
Local cCta 		:= ' '
Local cHistor  := space(tamSx3("E5_HISTOR")[1])
Local aBaixa 	:= {}
Local aParam 	:= {}
Local aFaVlAtuCR := {}
Local aSe1Dados := {}
Local aRet      := {}

   aadd(aCampos,{4,'cPrefixo','E1_PREFIXO'})      //Ordem dos campos que serão usados para localizar o título
   aadd(aCampos,{5,'cNum','E1_NUM'})
   aadd(aCampos,{6,'cParcela','E1_PARCELA'})
   aadd(aCampos,{7,'cTipo','E1_TIPO'})    

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

   se1->(DbSetOrder(1))
   ProcRegua(1) 
   While nTamFile > nTBtLidos

      IncProc()
      nPos := nBuffer := 0
      while nPos == 0                              // SE CARACTER DE FINAL DE LINHA NAO FOR ENCONTRADO
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

      if !empty(cLinha)
         nOrdem := 0
         for nI := 1 to len(cLinha)
            if substr(cLinha,nI,1) == ";" .or. nI == 1
               nOrdem += 1
               nDado := aScan(aCampos,{|x| x[1] == nOrdem })
               if nDado > 0
                  nColIni := nI + 1
                  nColFim := at(";", cLinha, nColIni)
                  &(aCampos[nDado,2]) := replace(substr(cLinha,nColIni,nColFim-nColIni),',','.')
                  &(aCampos[nDado,2]) += space( tamSx3(aCampos[nDado,3])[1] - len(&(aCampos[nDado,2])) )
                  &(aCampos[nDado,2]) := substr( &(aCampos[nDado,2]), 1, tamSx3(aCampos[nDado,3])[1]  )
               endif
            endif
         next

         if cTipo == 'NF '
            cNum := strzero(val(cNum),tamSx3("E1_NUM")[1])
         endif

         if se1->( dbseek( xfilial()+cPrefixo+cNum+cParcela+cTipo ) )
            if se1->e1_saldo > 0
               nRecSe1 := se1->(recno())
               cBco := ' '
               cAge := ' '
               cCta := ' '
               aBaixa := { "BNC", se1->e1_saldo, cBco,cAge,cCta, dDataBase, dDataBase } //BNC (BX. NÃO CON)
               aParam	:= {}
               aFaVlAtuCR := FaVlAtuCr("SE1",dDataBase)
               aSe1Dados := {}
               if !empty(cHistBx)
                  cHistor := cHistBx
               else
                  cHistor := "Inconsistência na programação - "+iif(se1->e1_tipo =='PR ',"SIS-5863","SIS-5816")
               endif
               AAdd( aSE1Dados, { nRecSe1, cHistor, aClone( aFaVlAtuCR ) } )
               aRet := U_CSFA530( 1, { nRecSe1 }, aBaixa, /*aNCC_RA*/, /*aLiquidacao*/, aParam, /*bBlock*/, /*aEstorno*/, aSe1Dados, /*aNewSE1*/ )
               SE5->(MSUNLOCK())
               SE1->(MSUNLOCK())
               SA1->(MSUNLOCK())
               if !aRet[1]
                  MsgAlert("Problema na baixa do título "+cPrefixo+cNum+cParcela+cTipo+": "+aRet[2],"Atenção")
               endif
            //else
            //   MsgAlert("Não há saldo para baixar do título "+cPrefixo+cNum+cParcela+cTipo+" !","Atenção")
            endif
         endif

      endif
      nPosFile += nPos
      nTBtLidos += nBtLidos

      nlinhas += 1
   End

   fClose(nHdl)
   MsgInfo(str(nlinhas) + " linhas processadas")

Return
