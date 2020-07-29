      $set sourceformat"free"

      *>Divisão de identificação do programa
       identification division.
       program-id. "lista11exercicio3versao2".
       author. "Stephani S. Zatta".
       installation. "PC".
       date-written. 28/07/2020.
       date-compiled. 28/07/2020.

      *>------------------------------------------------------------------------
      *>Divisão para configuração do ambiente
       environment division.

       configuration section.
           special-names. decimal-point is comma.

      *>------------------------------------------------------------------------
      *>---Declaração de recursos externos
       input-output section.
       file-control.

           select arqCadAluno assign to "arqCadAluno.txt"     *> assiciando arquivo logico (nome dado ao arquivo do programa com o arquivo fisico)
           organization is indexed                            *> forma de organização dos dados
           access mode is dynamic                             *> forma de acesso aos dados
        *> todos os programas que forem feitos com arquivos, usar a condição abaixo (lock mode)
           lock mode is automatic                             *> dead lock, evita a perda de informações
           record key is fd-cod                               *> chave de acesso
           file status is ws-fs-arqCadAluno.                  *> file status (o status da ultima operação)

       i-o-control.

      *>------------------------------------------------------------------------
      *>---Declaração de variáveis
       data division.

      *>------------------------------------------------------------------------
      *>---Variáveis de arquivos
       file section.

       fd arqCadAluno.           *> inico da declaração das variaveis do arquivo
       01  fd-cadastro-alunos.   *> layout do arquivo propriamente dito / layout do registro do arquivo
           05 fd-cod                               pic 9(03).
           05 fd-aluno                             pic x(25).
           05 fd-endereco                          pic x(35).
           05 fd-mae                               pic x(25).
           05 fd-pai                               pic x(25).
           05 fd-telefone                          pic x(15).
           05 fd-cadastro-notas.
              10 fd-nota1                          pic 9(02)v99.
              10 fd-nota2                          pic 9(02)v99.
              10 fd-nota3                          pic 9(02)v99.
              10 fd-nota4                          pic 9(02)v99.

      *>------------------------------------------------------------------------
      *>---Variáveis de trabalho
       working-storage section.

       77  ws-fs-arqCadAluno                       pic  9(02).

       77 ws-menu                                  pic x(03).

       01  ws-cadastro-alunos.
           05 ws-cod                               pic 9(03).
           05 ws-aluno                             pic x(25).
           05 ws-endereco                          pic x(35).
           05 ws-mae                               pic x(25).
           05 ws-pai                               pic x(25).
           05 ws-telefone                          pic x(15).
           05 ws-cadastro-notas.
              10 ws-nota1                          pic 9(02)v99.
              10 ws-nota2                          pic 9(02)v99.
              10 ws-nota3                          pic 9(02)v99.
              10 ws-nota4                          pic 9(02)v99.

       77 ws-sair                                  pic  x(01).
          88 ws-fechar-programa                    value "N" "n".
          88  voltar-tela                          value "V" "v".

       01  ws-mensagem.
           05 ws-msgm                              pic x(42).

       01  ws-msn-erro.
           05 ws-msn-erro-ofsset                   pic 9(04).
           05 filler                               pic x(01) value "-".
           05 ws-msn-erro-cod                      pic 9(02).
           05 filler                               pic x(01) value space.
           05 ws-msn-erro-text                     pic x(42).

      *>------------------------------------------------------------------------
      *>---Variáveis para comunicação entre programas
       linkage section.

      *>------------------------------------------------------------------------
      *>---Declaração de tela
       screen section.

      *>------------------------------------------------------------------------
      *>Declaração do corpo do programa
       procedure division.

           perform inicializa.
           perform processamento.
           perform finaliza.

      *>-------- ---------------------------------------------------
      *>  Procedimentos de inicialização
      *>-----------------------------------------------------------
       inicializa section.

       *>  abre o arquivo para leitura e escrita
           open i-o arqCadAluno
       *>  caso dê erro ao abrir o arquivo, aparecera a mensagem de erro e irá para a section finaliza-anormal
           if ws-fs-arqCadAluno  <> 00
           if ws-fs-arqCadAluno <> 05 then
               move 1                                 to ws-msn-erro-ofsset
               move ws-fs-arqCadAluno                 to ws-msn-erro-cod
               move "Erro ao abrir arq. arqCadAluno " to ws-msn-erro-text
               perform finaliza-anormal
           end-if

           .
       inicializa-exit.
           exit.

      *>-----------------------------------------------------------
      *>  Processamento principal
      *>-----------------------------------------------------------
       processamento section.

       *> ------------- Menu Principal ------------------

           perform until ws-fechar-programa

               display "Insira 'CA'  para cadastrar um aluno."
               display "Insira 'CN'  para cadastrar notas."
               display "Insira 'CON' para consultar cadastro."
               display "Insira 'DEL' para deletar um cadastro."
               display "Insira 'ALT' para alterar um cadastro."

       *>      cadastrar aluno
               accept ws-menu

       *>      cadastrar as 04 notas
               evaluate ws-menu
                   when = "ca"
                     or = "CA"
                       perform cadastrar-aluno

                   when = "cn"
                     or = "CN"
                       perform cadastrar-notas

       *>          consultar cadastro
                   when = "con"
                     or = "CON"
                       perform consultar-cadastro

       *>          deletar cadastro de algum aluno
                   when = "del"
                     or = "DEL"
                       perform deletar-aluno

       *>          alterar cadastro de algum aluno
                   when = "alt"
                     or = "ALT"
                       perform alterar-aluno

       *>          caso a entrada do teclado não seja nenhuma das opções descritas acima
                   when other
                       display "Insira uma opcao valida!"
               end-evaluate

           end-perform

           .
       processamento-exit.
           exit.

      *>-----------------------------------------------------------
      *> Cadastro de Aluno
      *>-----------------------------------------------------------
       cadastrar-aluno section.

       *> ------------- Cadastro de Aluno ------------------

           perform until ws-fechar-programa

               display " "
               display "Codigo: "
               accept  ws-cod

               display "Aluno: "
               accept  ws-aluno

               display "Endereco: "
               accept ws-endereco

                display "Nome da Mae: "
               accept ws-mae

               display "Nome do Pai: "
               accept ws-pai

               display "Telefone: "
               accept ws-telefone

      *>       salvar dados no arquivo arqCadAluno.txt
               move  ws-cadastro-alunos to fd-cadastro-alunos
               write fd-cadastro-alunos
       *>      caso dê erro ao gravar infos no arquivo, aparecera a mensagem de erro e irá para a section finaliza-anormal
               if ws-fs-arqCadAluno  <> 00 then
                   move 1                                  to ws-msn-erro-ofsset
                   move ws-fs-arqCadAluno                  to ws-msn-erro-cod
                   move "Erro ao gravar arq. arqCadAluno " to ws-msn-erro-text
                   perform finaliza-anormal
               end-if
      *> -------------

               display " "
               display "Deseja cadastrar mais um aluno? 'S'im ou 'N'ao: "
               accept ws-sair

           end-perform

           .
       cadastrar-aluno-exit.
           exit.

      *>-----------------------------------------------------------
      *> Cadastro de Notas
      *>-----------------------------------------------------------
       cadastrar-notas section.

       *> ------------- Cadastro das 04 Notas ------------------

           perform until ws-fechar-programa

               display " "
               display "Codigo: "
               accept  ws-cod

               display "Insira a nota 1: "
               accept  ws-nota1

               display "Insira a nota 2: "
               accept  ws-nota2

               display "Insira a nota 3: "
               accept  ws-nota3

               display "Insira a nota 4: "
               accept  ws-nota4

       *>      salvar notas no arquivo arqCadAluno.txt
               move ws-cod to fd-cod *> preenche a chave
               read arqCadAluno      *> leitura direta
       *>      caso o codigo inserido seja inexistente
               if ws-fs-arqCadAluno  <> 00 then
                   if ws-fs-arqCadAluno = 23 then
                       display "Codigo de aluno inexistente."
                   else
                       move 1                                  to ws-msn-erro-ofsset
                       move ws-fs-arqCadAluno                  to ws-msn-erro-cod
                       move "Erro ao gravar arq. arqCadAluno " to ws-msn-erro-text
                       perform finaliza-anormal
                   end-if
               else
                   move ws-cadastro-notas to fd-cadastro-notas
                   rewrite fd-cadastro-alunos
       *>          caso dê erro ao gravar infos no arquivo, aparecera a mensagem de erro e irá para a section finaliza-anormal
                   if ws-fs-arqCadAluno <> 0 then
                       move 1                                  to ws-msn-erro-ofsset
                       move ws-fs-arqCadAluno                  to ws-msn-erro-cod
                       move "Erro ao gravar arq. arqCadAluno " to ws-msn-erro-text
                       perform finaliza-anormal
                   end-if
               end-if

      *> -------------

               display " "
               display "Deseja cadastrar mais 04 notas de algum aluno? 'S'im ou 'N'ao: "
               accept ws-sair

           end-perform
           .
       cadastrar-notas-exit.
           exit.

      *>-----------------------------------------------------------
      *> Concultar cadastro de Aluno
      *>-----------------------------------------------------------
       consultar-cadastro section.

           perform until ws-fechar-programa

       *> ------------- Consulta de Cadastro ------------------
               display " "
               display "Informe o codigo co aluno que deseja consultar: "
               accept ws-cod

               move ws-cod to fd-cod
               read arqCadAluno
               if  ws-fs-arqCadAluno <> 0
               and ws-fs-arqCadAluno <> 10 then
                   if ws-fs-arqCadAluno = 23 then
                       display "Codigo informada invalido!"
                   else
                       move 2                           to ws-msn-erro-ofsset
                       move ws-fs-arqCadAluno           to ws-msn-erro-cod
                       move "Erro ao ler arq. arqTemp " to ws-msn-erro-text
                       perform finaliza-anormal
                   end-if
               end-if

               move fd-cadastro-alunos to ws-cadastro-alunos

       *> ------------- Display no Cadastro ------------------
               display " "
               display "Codigo     : " ws-cod
               display "Aluno      : " ws-aluno
               display "Endereco   : " ws-endereco
               display "Nome da Mae: " ws-mae
               display "Nome do Pai: " ws-pai
               display "Telefone   : " ws-telefone
               display " "
               display "Nota 1: " ws-nota1
               display "Nota 2: " ws-nota2
               display "Nota 3: " ws-nota3
               display "Nota 4: " ws-nota4

               display " "
               display "Deseja consultar mais um cadastro? 'S'im ou 'N'ao: "
               accept ws-sair

           end-perform

           .
       consultar-cadastro-exit.
           exit.

      *>-----------------------------------------------------------
      *> Deletar Aluno
      *>-----------------------------------------------------------
       deletar-aluno section.

       *> ------------- Excluir Algum Cadastro ------------------
               display " "
               display "Informe o codigo do aluno a ser excluido: "
               accept ws-cod

               move ws-cod to fd-cod
               delete arqCadAluno
               if  ws-fs-arqCadAluno = 0 then
                   display "Aluno de codigo " ws-cod " deletado com sucesso!"
               else
       *>          caso o codigo recebido pelo teclado ainda nao exista
                   if ws-fs-arqCadAluno = 23 then
                       display "Codigo informado invalido!"
                   else
                       move 5                              to ws-msn-erro-ofsset
                       move ws-fs-arqCadAluno              to ws-msn-erro-cod
                       move "Erro ao apagar arq. arqTemp " to ws-msn-erro-text
                       perform finaliza-anormal
                   end-if
               end-if

          .
       deletar-aluno-exit.
           exit.

      *>-----------------------------------------------------------
      *> Alterar Aluno
      *>-----------------------------------------------------------
       alterar-aluno section.

               perform consultar-cadastro

       *> ------------- Altera Cadastro ------------------
               display " "
               display "Insira o codigo do aluno que voce deseja alterar o cadastro: "
               accept ws-cod

               display "Altere o cadastro: "

               display " "
               display "Codigo     : "
               accept  ws-cod
               display "Aluno      : "
               accept  ws-aluno
               display "Endereco   : "
               accept ws-endereco
               display "Nome da Mae: "
               accept ws-mae
               display "Nome do Pai: "
               accept ws-pai
               display "Telefone   : "
               accept ws-telefone

               display " "
               display "Altere as notas: "

               display " "
               display "Insira a nota 1: "
               accept  ws-nota1
               display "Insira a nota 2: "
               accept  ws-nota2
               display "Insira a nota 3: "
               accept  ws-nota3
               display "Insira a nota 4: "
               accept  ws-nota4

               move ws-cod      to fd-cod
               move ws-aluno    to fd-aluno
               move ws-endereco to fd-endereco
               move ws-mae      to fd-mae
               move ws-pai      to fd-pai
               move ws-telefone to fd-telefone

               move ws-nota1 to fd-nota1
               move ws-nota2 to fd-nota2
               move ws-nota3 to fd-nota3
               move ws-nota4 to fd-nota4

               rewrite fd-cadastro-alunos
               if  ws-fs-arqCadAluno = 0 then
                   display "Cadastro alterado com sucesso!"
               else
                   move 6                               to ws-msn-erro-ofsset
                   move ws-fs-arqCadAluno               to ws-msn-erro-cod
                   move "Erro ao alterar arq. arqTemp " to ws-msn-erro-text
                   perform finaliza-anormal
               end-if

          .
       alterar-aluno-exit.
           exit.

      *>-----------------------------------------------------------
      *> Finalização Normal
      *>-----------------------------------------------------------
       finaliza-anormal section.

       *> Esta section é para o encerramento forçado do programa, caso haja algum erro com o arquivo

          display ws-msn-erro
          accept  ws-msn-erro

          stop run
          .
       finaliza-anormal-exit.
           exit.

      *>-----------------------------------------------------------
      *> Finalização Normal
      *>-----------------------------------------------------------
       finaliza section.

          close arqCadAluno
           if ws-fs-arqCadAluno  <> 00 then
               move 1                                  to ws-msn-erro-ofsset
               move ws-fs-arqCadAluno                  to ws-msn-erro-cod
               move "Erro ao fechar arq. arqCadAluno " to ws-msn-erro-text
               perform finaliza-anormal
           end-if

          stop run
          .
       finaliza-exit.
           exit.





