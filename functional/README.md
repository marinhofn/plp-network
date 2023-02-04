# plp-network
Projeto Funcional da Disciplina de Paradigmas da Programação @ UFCG

INSTALAÇÃO

	Para executar a aplicação é necessária a instalação de alguns requisitos, são eles GHC, cabal-install e postgreSQL. Os primeiros dois itens podem ser instalados ao instalar o GHCup.
	Caso esteja usando windows, é possível que encontre o erro pg_config executable not found, para resolvê-lo adicione o caminho do arquivo pg_config (encontra-se na pasta bin do postgreSQL) ao path.

EXECUÇÃO

	Para executar o programa, dê o comando cabal build e posteriormente cabal run, esta sequência de comandos irá compilar e executar o programa, conectando-se ao banco de dados e direcionando o usuário à primeira tela de menu do sistema.
