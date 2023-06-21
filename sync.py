import socket
import json
import signal
import sys
import select
import argparse
import time

from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler


class MyHandler(FileSystemEventHandler):
    def __init__(self, args):
        self.args = args

    def on_modified(self, event):
        print("File modified:", event.src_path)
        send_scripts(self.args)


def send_scripts(args):
    send_obj(
        args,
        {
            "messageID": 1,
            "scriptStates": [
                {
                    "name": "OPR-TTS-FTW",
                    "guid": args.guid,
                    "script": read_file_contents("scripts/core.lua"),
                },
            ],
        },
    )


def handle_client(client_socket):
    # TODO: Handle all data
    data = client_socket.recv(1024)
    try:
        print(f"Data from client: {json.loads(data)}")

    except:
        print("\tJson parse failed from client")

    client_socket.close()


def send_obj(args, obj):
    try:
        client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        client_socket.connect((args.host, args.port))

        client_socket.sendall(json.dumps(obj).encode())

        # TODO: Handle all data
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


def run_server(args):
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind((args.host, args.listen))

    # Register a signal handler for Ctrl+C
    def signal_handler(sig, frame):
        print("\nShutting down the server...")
        server_socket.close()
        sys.exit(0)

    signal.signal(signal.SIGINT, signal_handler)

    server_socket.setblocking(0)
    server_socket.listen(1)
    print(f"Server listening on {args.host}:{args.listen}")

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


def run():
    parser = argparse.ArgumentParser(description="")
    parser.add_argument("-r", "--host", default="localhost")
    parser.add_argument("-p", "--port", default=39999)
    parser.add_argument("-l", "--listen", default=39998)
    parser.add_argument("guid")
    args = parser.parse_args()

    observer = Observer()
    observer.schedule(MyHandler(args), path="scripts", recursive=False)

    send_scripts(args)
    observer.start()
    run_server(args)
    observer.join()


################
run()
