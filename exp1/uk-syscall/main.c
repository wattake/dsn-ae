#include <stdio.h>

/* Import user configuration: */
#ifdef __Unikraft__
#include <uk/config.h>
#endif /* __Unikraft__ */

#include <mr_time.h>
#include <uk/print.h>


#include <string.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <errno.h>

#define LOOP 100

#if CONFIG_LIBMRTIME_SYSCALL_SOCKWRITE | CONFIG_LIBMRTIME_SYSCALL_SOCKREAD  | CONFIG_LIBMRTIME_SYSCALL_SHUTDOWN
#define LISTEN_PORT 8123
static const char reply[] = "HTTP/1.1 200 OK\r\n" \
			    "Content-type: text/html\r\n" \
			    "Connection: close\r\n" \
			    "\r\n" \
			    "<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">" \
			    "<html>" \
			    "<head><title>It works!</title></head>" \
			    "<body><h1>It works!</h1><p>This is only a test.</p></body>" \
			    "</html>\n";

#define BUFLEN 2048
static char recvbuf[BUFLEN];
#endif

#if CONFIG_LIBMRTIME_SYSCALL_WRITE | CONFIG_LIBMRTIME_SYSCALL_READ
static char io_buf[4096];
#endif

int main()
{
	
	int res;

#if CONFIG_LIBMRTIME_SYSCALL_GETPID
	printf("----- syscall performance -----\n");
	for(int i=0; i<LOOP; i++){
		start_timer();
		lap_timer(TIME_EXEC);
		res = getpid();
		end_timer();
	}
#endif


#if CONFIG_LIBMRTIME_SYSCALL_OPEN
	int fd;
	fd = creat("test.txt", 0);
	close(fd);
	printf("----- syscall performance -----\n");
	for(int i=0; i<LOOP; i++){
		start_timer();
		lap_timer(TIME_EXEC);
		fd = open("test.txt", 0, 0);
		end_timer();
		res = fd;
		if(fd<0){
			printf("open end with %d\n", fd);
			goto out;
		}
		close(fd);
	}
#endif


#if CONFIG_LIBMRTIME_SYSCALL_WRITE
	int fd;
	fd = creat("test.txt", 0);
	printf("----- syscall performance -----\n");
	for(int i=0; i<LOOP; i++){
		start_timer();
		lap_timer(TIME_EXEC);
		res=write(fd, io_buf, 4096);
		end_timer();
		if(res!=4096){
			printf("open end with %d\n", fd);
			goto out;
		}
	}
#endif


#if CONFIG_LIBMRTIME_SYSCALL_READ
	int fd;
	fd = creat("test.txt", 0);

	for(int i=0; i<200; i++){
		res=write(fd, "a", 1);
	}
	close(fd);
	fd= open("test.txt", 0, 0);
	if(fd<0){
		res=fd;
		goto out;
	}


	printf("----- syscall performance -----\n");
	for(int i=0; i<LOOP; i++){
		start_timer();
		lap_timer(TIME_EXEC);
		res=read(fd, io_buf, 1);
		end_timer();
		if(res!=1){
			printf("open end with %d\n", fd);
			goto out;
		}
	}
#endif

#if CONFIG_LIBMRTIME_SYSCALL_CLOSE
	int fd;
	fd = creat("test.txt", 0);
	close(fd);

	printf("----- syscall performance -----\n");
	for(int i=0; i<LOOP; i++){
		fd = open("test.txt", 0, 0);
		start_timer();
		lap_timer(TIME_EXEC);
		res = close(fd);
		end_timer();
		if(fd<0){
			printf("open end with %d\n", fd);
			goto out;
		}
	}
#endif

#if CONFIG_LIBMRTIME_SYSCALL_FSTAT
	int fd;
	fd = creat("test.txt", 0);
	struct stat stat;

	printf("----- syscall performance -----\n");
	for(int i=0; i<LOOP; i++){
	start_timer();
	lap_timer(TIME_EXEC);
	res = fstat(fd, &stat);
	end_timer();
	if(fd<0)
		printf("open end with %d\n", fd);
		goto out;
	}
#endif


#if CONFIG_LIBMRTIME_SYSCALL_FCNTL
	int fd;
	fd = creat("test.txt", 0);
	struct stat stat;

	printf("----- syscall performance -----\n");
	for(int i=0; i<LOOP; i++){
		start_timer();
		lap_timer(TIME_EXEC);
		res = fcntl(fd, 8, 0);
		end_timer();
		if(fd<0){
			printf("open end with %d\n", fd);
			goto out;
		}
	}
#endif



#if CONFIG_LIBMRTIME_SYSCALL_SOCKET
	int srv, client;
	ssize_t n;
	struct sockaddr_in srv_addr;
	int cnt = 0;

	for(int i=0; i<LOOP; i++){
		start_timer();
		lap_timer(TIME_EXEC);
		srv = socket(AF_INET, SOCK_STREAM, 0);
		end_timer();
		res = srv;
		close(srv);
	}

#endif


#if CONFIG_LIBMRTIME_SYSCALL_SOCKWRITE
	int srv, client;
	struct sockaddr_in srv_addr;
	int cnt = 0;


	srv = socket(AF_INET, SOCK_STREAM, 0);

	if (srv < 0) {
		fprintf(stderr, "Failed to create socket: %d\n", errno);
		goto out;
	}

	srv_addr.sin_family = AF_INET;
	srv_addr.sin_addr.s_addr = INADDR_ANY;
	srv_addr.sin_port = htons(LISTEN_PORT);

	res = bind(srv, (struct sockaddr *) &srv_addr, sizeof(srv_addr));
	if (res < 0) {
		fprintf(stderr, "Failed to bind socket: %d\n", errno);
		goto out;
	}

	/* Accept one simultaneous connection */
	res = listen(srv, 1);
	if (res < 0) {
		fprintf(stderr, "Failed to listen on socket: %d\n", errno);
		goto out;
	}

	printf("Listening on port %d...\n", LISTEN_PORT);



	printf("----- syscall performance -----\n");
	while (1) {
		client = accept(srv, NULL, 0);
		if (client < 0) {
			fprintf(stderr,
				"Failed to accept incoming connection: %d\n",
				errno);
			goto out;
		}

		/* Receive some bytes (ignore errors) */
		read(client, recvbuf, BUFLEN);

		/* Send reply */
		// for(int i=0; i<LOOP; i++){
		cnt++;
		start_timer();
		lap_timer(TIME_EXEC);
		write(client, reply, sizeof(reply) - 1);
		end_timer();

		/* Close connection */
		close(client);
		if(cnt==LOOP){
			close(srv);
			return 0;
		}
	}
#endif

#if CONFIG_LIBMRTIME_SYSCALL_SOCKREAD
	int srv, client;
	struct sockaddr_in srv_addr;
	int cnt = 0;

	srv = socket(AF_INET, SOCK_STREAM, 0);

	if (srv < 0) {
		fprintf(stderr, "Failed to create socket: %d\n", errno);
		goto out;
	}

	srv_addr.sin_family = AF_INET;
	srv_addr.sin_addr.s_addr = INADDR_ANY;
	srv_addr.sin_port = htons(LISTEN_PORT);

	res = bind(srv, (struct sockaddr *) &srv_addr, sizeof(srv_addr));
	if (res < 0) {
		fprintf(stderr, "Failed to bind socket: %d\n", errno);
		goto out;
	}

	/* Accept one simultaneous connection */
	res = listen(srv, 1);
	if (res < 0) {
		fprintf(stderr, "Failed to listen on socket: %d\n", errno);
		goto out;
	}

	printf("Listening on port %d...\n", LISTEN_PORT);


	printf("----- syscall performance -----\n");
	while (1) {
		client = accept(srv, NULL, 0);
		if (client < 0) {
			fprintf(stderr,
				"Failed to accept incoming connection: %d\n",
				errno);
			goto out;
		}

		/* Receive some bytes (ignore errors) */
		start_timer();
		lap_timer(TIME_EXEC);
		read(client, recvbuf, BUFLEN);
		end_timer();
		cnt++;

		/* Send reply */
		write(client, reply, sizeof(reply) - 1);


		/* Close connection */
		close(client);
		if(cnt==LOOP){
			close(srv);
			return 0;
		}
	}

#endif


#if CONFIG_LIBMRTIME_SYSCALL_SHUTDOWN
	int srv, client;
	ssize_t n;
	struct sockaddr_in srv_addr;
	int cnt = 0;


	srv = socket(AF_INET, SOCK_STREAM, 0);

	if (srv < 0) {
		fprintf(stderr, "Failed to create socket: %d\n", errno);
		goto out;
	}

	srv_addr.sin_family = AF_INET;
	srv_addr.sin_addr.s_addr = INADDR_ANY;
	srv_addr.sin_port = htons(LISTEN_PORT);

	res = bind(srv, (struct sockaddr *) &srv_addr, sizeof(srv_addr));
	if (res < 0) {
		fprintf(stderr, "Failed to bind socket: %d\n", errno);
		goto out;
	}

	/* Accept one simultaneous connection */
	res = listen(srv, 1);
	if (res < 0) {
		fprintf(stderr, "Failed to listen on socket: %d\n", errno);
		goto out;
	}

	printf("Listening on port %d...\n", LISTEN_PORT);
	printf("----- syscall performance -----\n");
	while (1) {
		client = accept(srv, NULL, 0);
		if (client < 0) {
			fprintf(stderr,
				"Failed to accept incoming connection: %d\n",
				errno);
			goto out;
		}

		/* Receive some bytes (ignore errors) */
		/* Send reply */
		// for(int i=0; i<LOOP; i++){
		cnt++;
	// }
		// if (n < 0)
		// 	fprintf(stderr, "Failed to send a reply\n");
		// else
		// 	printf("Sent a reply %d\n", ++cnt);

		/* Close connection */
		start_timer();
		lap_timer(TIME_EXEC);
		close(client);
		end_timer();
		

		if(cnt==LOOP){
			close(srv);
			return 0;
		}
	}

#endif

out:
	return res;
}
