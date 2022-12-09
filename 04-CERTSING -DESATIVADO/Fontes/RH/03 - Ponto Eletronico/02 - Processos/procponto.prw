#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#DEFINE F_BLOCK 200000           

/*
U_ProcPonto
Desc: Ler arquivo consolidado de Ponto, e gera vários arquivos filhos
Uso: Protheus 10  - RH_Certisign
Opvs(Warleson)  - 05/06/2012   

Alterado em 18/06/2012 - Opvs (Mariella)
Alteracao: Deixar de utilizar a funcao memoread para utilizar a funcao fread,
           ja que possui limitacao de leitura de caracteres.
Alterado em 18/06/2012 - Opvs (Bruno Nunes)
Alteracao: Revisão do fonte para funcionar no P12.
*/

User Function ProcPonto()
	local aTxt 		:= {}					// Arquivo de Origem em Vetor
	local cArq 		:= 'relogio'  		// Nome do arquivo de Origem
	local cBff 		:= ''					// Variavel auxiliar para montar buffer
	local cDir 		:= 'c:\relogio\'		// Diretorio padrão
	local cExt 		:= '.txt'		 		// Extenção do arquivo padrão
	local cLmt 		:= replicate('9',9) 	// Limitador do arquivo Origem
	local cTit 		:= ''					// Titulo do arquivo de Destino
	local cTxt 		:= ''  				// Conteudo do arquivo de Destino  
	local nBytesLidos	:= 0 
	local nBytesFalta	:= 0
	local nTamArquivo	:= 0
	local nBytesLer 	:= 0
		
	nHOrigem := FOPEN(cDir+cArq+cExt, FO_READ)
	if nHOrigem == -1
		MsgStop('Erro ao abrir origem. Ferror = '+str(ferror(),4),'Erro')
		Return .F.
	endif
	
	nTamArquivo := Fseek(nHOrigem,0,2)
	Fseek(nHOrigem,0)	
	nBytesFalta := nTamArquivo  

	While nBytesFalta > 0  	// Enquanto houver dados a serem copiados                          
		nBytesLer   := Min(nBytesFalta , F_BLOCK )
		cBuffer     := Space(nBytesLer)
	  	nBytesLidos := FREAD(nHOrigem, cBuffer, nBytesLer )   	// le os dados do Arquivo       
		
	  	if empty(cBuffer)		//Fim do arquivo
	  		Exit
	  	endif    
		
		aTxt    := Strtokarr(cBuffer,CRLF)        								      	// Ler Arquivo de Origem
		bGrvTit := {|cBff| cTit:=IIF(empty(cTxt),substr(cBff,188,17),cTit)}		  	// Salva Titulo        
		bGrvTxt := {|cBff| lEof:= substr(cBff,1,len(cLmt))==cLmt,cTxt+=cBff+CRLF}		// Popula Texto
		bGrvArq := {|cBff| memowrite(cDir+cTit+cExt,cBff),''}  							// Grava os arquivos Destino
		
		MsgRun("Processando arquivo...",,{||sleep(2000),aEval(aTxt,{|cBff|eval(bGrvTit,cBff),eval(bGrvTxt,cBff),IIF(lEof,cTxt:=eval(bGrvArq,cTxt),)})})
		
		aTxt      := Strtokarr(cBuffer,CRLF)	// Ler Arquivo de Origem      
		
		cTit:=IIF(empty(cTxt),substr(cBff,188,17),cTit)	// Salva Titulo        
		  
		if substr(cBff,1,len(cLmt))==cLmt
			cTxt+=cBff+CRLF
		else
			cTxt+=cBff
		endif
		  			
		aTxt := {}
		nBytesFalta -= nBytesLer
	enddo
	
	MsgAlert('Arquivos gravados com sucesso!')
Return()