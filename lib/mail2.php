<?
    header('Content-Type: text/plain;');
    //error_reporting(E_ALL ^ E_WARNING);
    ob_implicit_flush();


function smtpSend($to, $from, $subject, $message){

    $address = 'mail.djerelo.info'; 			// адрес smtp-сервера
    $port    = 25;          				// порт (стандартный smtp - 25)

    $login   = 'forum@djerelo.info';    	// логин к ящику
    $pwd     = 'QRUPcmLD';    				// пароль к ящику

    try {
       
        // Создаем сокет
        $socket = socket_create(AF_INET, SOCK_STREAM, SOL_TCP);
        if ($socket < 0) {
            throw new Exception('socket_create() failed: '.socket_strerror(socket_last_error())."\n");
        }

        // Соединяем сокет к серверу
        echo 'Connect to \''.$address.':'.$port.'\' ... ';
        $result = socket_connect($socket, $address, $port);
        if ($result === false) {
            throw new Exception('socket_connect() failed: '.socket_strerror(socket_last_error())."\n");
        } else {
            echo "OK\n";
        }
       
        // Читаем информацию о сервере
        read_smtp_answer($socket);
       
        // Приветствуем сервер
        write_smtp_response($socket, 'EHLO '.$address);
        read_smtp_answer($socket); // ответ сервера
       
        echo 'Authentication ... ';
           
        // Делаем запрос авторизации
        write_smtp_response($socket, 'AUTH LOGIN');
        read_smtp_answer($socket); // ответ сервера
       
        // Отравляем логин
        write_smtp_response($socket, base64_encode($login));
        read_smtp_answer($socket); // ответ сервера
       
        // Отравляем пароль
        write_smtp_response($socket, base64_encode($pwd));
        read_smtp_answer($socket); // ответ сервера
       
        echo "OK\n";
        echo "Check sender address ... ";
       
        // Задаем адрес отправителя
        write_smtp_response($socket, 'MAIL FROM:<'.$from.'>');
        read_smtp_answer($socket); // ответ сервера
       
        echo "OK\n";
        echo "Check recipient address ... ";
       
        // Задаем адрес получателя
        write_smtp_response($socket, 'RCPT TO:<'.$to.'>');
        read_smtp_answer($socket); // ответ сервера
       
        echo "OK\n";
        echo "Send message text ... ";
       
        // Готовим сервер к приему данных
        write_smtp_response($socket, 'DATA');
        read_smtp_answer($socket); // ответ сервера
       
        // Отправляем данные
        $message = "To: $to\r\n".$message; // добавляем заголовок сообщения "адрес получателя"
        $message = "Subject: $subject\r\n".$message; // заголовок "тема сообщения"
		$message = "From: $from\r\n".$message; // заголовок "тема сообщения"
		//$message = "Content-Type:text/html; charset=utf-8\r\n".$message; // заголовок "тема сообщения"
		
		//Content-Type:text/html; charset=windows-1251\r\n
		
        write_smtp_response($socket, $message."\r\n.");
        read_smtp_answer($socket); // ответ сервера
       
        echo "OK\n";
        echo 'Close connection ... ';
       
        // Отсоединяемся от сервера
        write_smtp_response($socket, 'QUIT');
        read_smtp_answer($socket); // ответ сервера
       
        echo "OK\n";
       
    } catch (Exception $e) {
        echo "\nError: ".$e->getMessage();
    }
   
    if (isset($socket)) {
        socket_close($socket);
    }
   
}

    // Функция для чтения ответа сервера. Выбрасывает исключение в случае ошибки
    function read_smtp_answer($socket) {
        $read = socket_read($socket, 1024);
       
        if ($read{0} != '2' && $read{0} != '3') {
            if (!empty($read)) {
                throw new Exception('SMTP failed: '.$read."\n");
            } else {
                throw new Exception('Unknown error'."\n");
            }
        }
    }
   
    // Функция для отправки запроса серверу
    function write_smtp_response($socket, $msg) {
        $msg = $msg."\r\n";
        socket_write($socket, $msg, strlen($msg));
    }

smtpSend('oleksadesign@gmail.com', 'Forum Djerelo.Info', 'You have a message in Djerelo Forum', 'this is test message');

?>