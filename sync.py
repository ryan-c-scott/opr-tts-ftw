import socket
import json
import signal
import sys
import select

import time
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

# Specify the directory and file to monitor
directory = "scripts"
Filename = "global.lua"
host = "localhost"
port = 39998


class MyHandler(FileSystemEventHandler):
    def on_modified(self, event):
        print("File modified:", event.src_path)
        send_scripts()


def send_scripts():
    send_obj(
        host,
        39999,
        {
            "messageID": 1,
            "scriptStates": [
                {
                    "name": "Global",
                    "guid": "-1",
                    "script": read_file_contents("scripts/global.lua"),
                },
            ],
        },
    )


# Create an observer and attach the event handler
observer = Observer()
observer.schedule(MyHandler(), path=directory, recursive=False)


def handle_client(client_socket):
    # Handle client connection
    data = client_socket.recv(1024)
    try:
        print(f"Data from client: {json.loads(data)}")

    except:
        print("\tJson parse failed from client")

    client_socket.close()


def send_obj(host, port, obj):
    try:
        client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        client_socket.connect((host, port))

        client_socket.sendall(json.dumps(obj).encode())

        # Receive the response (optional)
        response = client_socket.recv(1024).decode()
        print("Response received:", response)

        client_socket.close()

    except Exception as e:
        print("An error occurred:", str(e))


def read_file_contents(file_path):
    try:
        with open(file_path, "r") as file:
            file_contents = file.read()
            return file_contents

    except Exception as e:
        print("An error occurred:", str(e))
        return None


def run_server(host, port):
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind((host, port))

    # Register a signal handler for Ctrl+C
    def signal_handler(sig, frame):
        print("\nShutting down the server...")
        server_socket.close()
        sys.exit(0)

    signal.signal(signal.SIGINT, signal_handler)

    server_socket.setblocking(0)
    server_socket.listen(1)
    print(f"Server listening on {host}:{port}")

    inputs = [server_socket]
    outputs = []

    while inputs:
        try:
            readable, writable, exceptional = select.select(
                inputs, outputs, inputs, 1.0
            )
        except select.error:
            break

        for sock in readable:
            if sock is server_socket:
                client_socket, client_address = server_socket.accept()
                print(f"New connection from {client_address[0]}:{client_address[1]}")
                inputs.append(client_socket)
                outputs.append(client_socket)
            else:
                handle_client(sock)
                inputs.remove(sock)
                outputs.remove(sock)
                sock.close()


################
observer.start()
run_server(host, port)
observer.join()
