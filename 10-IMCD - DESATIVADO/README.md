# Framework - Upduo Clientes

Repositorio com os fontes dos clientes da Upduo Consultoria

```
  _____   _                               _______      _______  _
 |_   _| | |                        /\   |  __ \ \    / /  __ \| |
   | |   | |     _____   _____     /  \  | |  | \ \  / /| |__) | |
   | |   | |    / _ \ \ / / _ \   / /\ \ | |  | |\ \/ / |  ___/| |
  _| |_  | |___| (_) \ V /  __/  / ____ \| |__| | \  /  | |    | |____
 |_____| |______\___/ \_/ \___| /_/    \_\_____/   \/   |_|    |______|

```

---

## Code Review

> Seja sempre imparcial, avalie o codigo não a pessoa.

Devemos verificar no codigo:

+ Alteração efetuada desempenha o papel esperado na correção? Cumpre o requerido na issue?
     + Aqui vale a experiancia de quem estão fazendo o code review.

+ Logica está correta e clara? � facilmente entendido?
     + Precisamos evitar problemas para depois, dificultando o debug.

+ O nome dos arquivos chs no include estão em letra minuscula?
     + Exemplo: `#include 'protheus.ch'`, pq? **#linuxthing**

+ Retirar variaveis `static` tipo ( `lIsP12` � `lIsP11`), somente em fonte da versão 12
     + Isso elimina condiçoes desnecessarias na versao que estamos.

+ Respeita o guia de boas praticas desenvolvimento?
     + [Guia de Boas Pr�ticas - ADVPL](http://tdn.totvs.com.br/pages/viewpage.action?pageId=22480352)

+ Efetuou a Tipagem das vari�veis e parametros?
     + [Tipagem de Dados](http://tdn.totvs.com.br/display/tec/Tipagem+de+Dados)

+ Existe codigo redundante ou duplicado?
     + Ou seja, tem esta(s) mesma(s) linha(s) em outro lugar no fonte ou no fluxo de execução e poderia ser unificado?
     + Aten��o: n�o deixe gen�rico de forma prematura

+ Efetuou a Identação do codigo?
     + Teclado de atalho SHIFT + ALT + F - Identação de Fonte

+ O codigo possui documenta��o (novos m�todos, funçoes, classes)
     + [ProtheusDOC](https://tdn.totvs.com/display/tec/ProtheusDOC)

+ Possui comentario em caso de logica mais complexas
     + �s vezes precisa ser complexo, esperamos que esteja explicado!


+ As novas Vari�veis, M�todos, Fun��es foram definidas com Nomes Sugestivos, Consistentes, Leg�veis e Claros para o contexto.



