# vsftpd: Instalacao via docker

## Material necessário

- Ambiente *docker* instalado e funcionando em sua máquina (Real ou virtual). Visite

  - <https://docs.docker.com/engine/install/debian>

  para instalação na [VM Dybian-musico](https://oulu.ifrn.edu.br/vm/dybian-musico.ova).

## Roteiro

1. Visite: <https://hub.docker.com/r/fauria/vsftpd/>;
2. Procure pela seção **Use cases**;
3. Teste e adapte os códigos lá disponibilizados;

   1. Crie um contêiner temporário para fins de teste:
      
      ```sh
      docker run --rm fauria/vsftpd
      ```
      
   2. Crie um contêiner no modo ativo usando a conta de usuário padrão, com um diretório de dados vinculado:

      ```sh
      mkdir -pv /var/www/html/proverbios
      docker run -d -p 21:21 -v /var/www/html/proverbios:/home/vsftpd --name vsftpd fauria/vsftpd

      # Veja os logs para as credenciais:
      docker logs vsftpd
      ```

   3. Crie um contêiner de produção com uma conta de usuário personalizada, vinculando um diretório de dados e habilitando o modo ativo e passivo:

      ```sh
      docker run -d -v /var/www/html/proverbios:/home/vsftpd \
      -p 20:20 -p 21:21 -p 21100-21110:21100-21110 \
      -e FTP_USER=estudante -e FTP_PASS=estudante \
      -e PASV_ADDRESS=192.168.56.34 -e PASV_MIN_PORT=21100 -e PASV_MAX_PORT=21110 \
      --name vsftpd --restart=always fauria/vsftpd
      ```

   4. Adicione manualmente um novo usuário FTP a um contêiner existente:

      ```sh
      docker exec -i -t vsftpd bash
      mkdir /home/vsftpd/myuser
      echo -e "myuser\nmypass" >> /etc/vsftpd/virtual_users.txt
      /usr/bin/db_load -T -t hash -f /etc/vsftpd/virtual_users.txt /etc/vsftpd/virtual_users.db
      exit
      docker restart vsftpd
      ```
