# Базовый образ - Ubuntu 22.04
FROM ubuntu:24.04

# Устанавливаем 32-битные библиотеки для SA-MP
RUN dpkg --add-architecture i386
RUN apt update && apt install -y libc6:i386 libstdc++6:i386 screen

# Создаем рабочую директорию
WORKDIR /server

# Копируем все файлы сервера в контейнер
COPY . /server/

# Открываем порты SA-MP
EXPOSE 7777/udp

# Команда запуска сервера
CMD ["./samp03svr"]
